/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.service;

import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.posbo.entity.masterdata.Category;
import com.dimata.posbo.entity.masterdata.HelperPriceList;
import com.dimata.posbo.entity.masterdata.PstCategory;
import com.dimata.posbo.entity.masterdata.PstHelperPriceList;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.sedana.entity.masterdata.JangkaWaktu;
import com.dimata.sedana.entity.masterdata.JangkaWaktuFormula;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktu;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktuFormula;
import com.dimata.services.WebServices;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author gndiw
 */
public class AutomaticCalculatePrice implements Runnable {
    int i = 0;
    //update by satrya 2013-02-25
    private Date startDate=null;
     private boolean running = false;
     private long sleepMs = 86400000;
    public AutomaticCalculatePrice() {
    }
    
    public void run() 
    {
        try {

            int i = 0;
            while (this.running) {
                
                try {
                    DBHandler.execUpdate("DELETE FROM helper_price_list_kredit");
                } catch (Exception exc){}
                
                Vector listCat = PstCategory.list(0, 0, "", "");
                
                for (int c = 0; c < listCat.size(); c++){
                    Category category = (Category) listCat.get(c);
                    String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
                    String url = posApiUrl + "/material/list/simple?limitStart=0&recordToGet=0&whereClause="+URLEncoder.encode("CATEGORY_ID="+category.getOID()+" AND VIEW_IN_SHOPPING_CHART = 1")+"&orderBy=M.NAME";
                       JSONArray arr = WebServices.getAPIArray("", url);
                       Vector listJangkaWaktu = PstJangkaWaktu.list(0, 0, "", PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU]);
                       if (arr != null){
                           for (int x = 0; x < arr.length(); x++){

                                    JSONObject objects = arr.getJSONObject(x);
                                     // get the price average
                                     double avgPrice = objects.optDouble(PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE],0);
                                     String merkName = objects.optString("MERK","-");
                                     for (int j = 0; j < listJangkaWaktu.size(); j++){
                                         JangkaWaktu jw = (JangkaWaktu) listJangkaWaktu.get(j);
                                        Vector listFormula = PstJangkaWaktuFormula.list(0, 0,
                                                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID] + "=" + jw.getOID() + " AND "
                                                        + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_KREDIT_ID] + "= 0 AND "+
                                                    PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_STATUS]+"= 0" ,
                                                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);
                                         Hashtable<String, Double> hashFormula = new Hashtable<>();
                                        double pengajuan = 0;
                                        double value = 0;
                                        double increase = 0;
                                        double hpp = 0;
                                        double totalCash = 0;
                                        double pokok = 0;
                                        double bunga = 0;
                                        double minDp = 0;
                                        double angs= 0;

                                        if (listFormula.size() > 0) {
                                            for (int f = 0; f < listFormula.size(); f++) {
                                                JangkaWaktuFormula jangkaWaktuFormula = (JangkaWaktuFormula) listFormula.get(f);
                                                String formula = jangkaWaktuFormula.getFormula().replaceAll("%", "/100");
                                                formula = formula.replaceAll("&gt", ">");
                                                formula = formula.replaceAll("&lt", "<");
                                                if (checkString(formula, "HPP") > -1) {
                                                    formula = formula.replaceAll("HPP", "" + avgPrice);
                                                }
                                                if (checkString(formula, "DP") > -1) {
                                                    formula = formula.replaceAll("DP", "" + 0);
                                                }
                                                if (checkString(formula, "INCREASE") > -1) {
                                                    formula = formula.replaceAll("INCREASE", increase + " / 100.0");
                                                }

                                                String sComp = checkStringStart(formula, "JANGKA_WAKTU");
                                                if (sComp != null && sComp.length() > 0) {
                                                    double compVal = getComponentValue("JANGKA_WAKTU", sComp, increase, hpp, 0);
                                                    formula = formula.replaceAll("" + sComp, "" + compVal);
                                                }

                                                for (Map.Entry m : hashFormula.entrySet()) {
                                                    formula = formula.replaceAll("" + m.getKey(), "" + m.getValue());
                                                }

                                                value = getValue(formula);

                                                switch (jangkaWaktuFormula.getPembulatan()) {
                                                    case PstJangkaWaktuFormula.PEMBULATAN_PULUHAN:
                                                        value = rounding(-1, value);
                                                        break;
                                                    case PstJangkaWaktuFormula.PEMBULATAN_RATUSAN:
                                                        value = rounding(-2, value);
                                                        break;
                                                    case PstJangkaWaktuFormula.PEMBULATAN_RIBUAN:
                                                        value = rounding(-3, value);
                                                        break;
                                                }

                                                if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_NILAI_PENGAJUAN) {
                                                    pengajuan = value;
                                                    break;
                                                }
                                                if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_BUNGA) {
                                                    bunga = value;
                                                }
                                                if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_POKOK) {
                                                    pokok = value;
                                                }
                                                if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_DP) {
                                                    minDp = value;
                                                }

                                                hashFormula.put(jangkaWaktuFormula.getCode(), value);

                                            }
                                        }
                                        try {
                                            angs = rounding(-3, pengajuan / Double.valueOf(jw.getJangkaWaktu()) );
                                        } catch (Exception exc){}

                                        HelperPriceList helper = new HelperPriceList();
                                        helper.setCategoryId(category.getOID());
                                        helper.setJangkaWaktuId(jw.getOID());
                                        helper.setJmlAngsuran(angs);
                                        helper.setMaterialId(objects.optLong(PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID],0));
                                        helper.setMerk(objects.optString("MERK","-"));
                                        helper.setName(objects.optString(PstMaterial.fieldNames[PstMaterial.FLD_NAME],"-"));
                                        helper.setSku(objects.optString(PstMaterial.fieldNames[PstMaterial.FLD_SKU],"-"));
                                        try {
                                            PstHelperPriceList.insertExc(helper);
                                        } catch (Exception exc){}
                                     }


                           }
                       }
                }
                
                try {
                    Thread.sleep(this.getSleepMs());
                } catch (Exception exc) {
                    System.out.println(exc);
                } finally {
                }
            }
            this.running = false;


        } catch (Exception exc) {
            System.out.println(">>> Exception on AutomaticAlClosing service :((");
        }
    }
    
    public static int checkString(String strObject, String toCheck) {
        if (toCheck == null || strObject == null) {
            return -1;
        }
        if (strObject.startsWith("=")) {
            strObject = strObject.substring(1);
        }

        String[] parts = strObject.split(" ");
        if (parts.length > 0) {
            for (int i = 0; i < parts.length; i++) {
                String p = parts[i];
                if (toCheck.trim().equalsIgnoreCase(p.trim())) {
                    return i;
                };
            }
        }
        return -1;
    }

    public static String checkStringStart(String strObject, String toCheck) {
        if (toCheck == null || strObject == null) {
            return null;
        }
        if (strObject.startsWith("=")) {
            strObject = strObject.substring(1);
        }

        String[] parts = strObject.split(" ");
        if (parts.length > 0) {
            for (int i = 0; i < parts.length; i++) {
                String p = parts[i];
                if (p.trim().startsWith(toCheck.trim())) {
                    return p.trim();
                };
            }
        }
        return null;
    }
    
     public static double getValue(String formula) {
        DBResultSet dbrs = null;
        double compValueX = 0;
        try {
            String sql = "SELECT (" + formula + ")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                compValueX = rs.getDouble(1);
            }

            rs.close();
            return compValueX;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

     public static double getComponentValue(String compName, String formulaPart, double increase, double hpp, double dp) {
        double retValue = 0.0;

        Vector vLsitComp = null;
        if (compName == null || formulaPart == null) {
            return 0;
        }
        compName = compName.trim();
        formulaPart = formulaPart.trim();
        if (formulaPart.startsWith(compName)) {
            String[] parts = formulaPart.split("#");
            if (parts.length > 0) {
                vLsitComp = new Vector();
                for (int i = 1; i < parts.length; i++) {
                    vLsitComp.add(parts[i]);
                }
            }
        }

        Vector vJangkaWaktu = PstJangkaWaktu.list(0, 0, PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU] + "='" + vLsitComp.get(0) + "'", "");
        if (vJangkaWaktu.size() > 0) {
            JangkaWaktu jangkaWaktu = (JangkaWaktu) vJangkaWaktu.get(0);

            Vector listFormula = PstJangkaWaktuFormula.list(0, 0,
                    PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID] + "=" + jangkaWaktu.getOID(),
                    PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);

            Hashtable<String, Double> hashFormula = new Hashtable<>();
            double value = 0;
            if (listFormula.size() > 0) {
                for (int i = 0; i < listFormula.size(); i++) {
                    JangkaWaktuFormula jangkaWaktuFormula = (JangkaWaktuFormula) listFormula.get(i);
                    String formula = jangkaWaktuFormula.getFormula().replaceAll("%", "/100");
                    formula = formula.replaceAll("&gt", ">");
                    formula = formula.replaceAll("&lt", "<");
                    if (checkString(formula, "HPP") > -1) {
                        formula = formula.replaceAll("HPP", "" + hpp);
                    }
                    if (checkString(formula, "DP") > -1) {
                        formula = formula.replaceAll("DP", "" + dp);
                    }
                    if (checkString(formula, "INCREASE") > -1) {
                        formula = formula.replaceAll("INCREASE", increase + " / 100.0");
                    }

                    for (Map.Entry m : hashFormula.entrySet()) {
                        formula = formula.replaceAll("" + m.getKey(), "" + m.getValue());
                    }

                    String sComp = checkStringStart(formula, "JANGKA_WAKTU");
                    if (sComp != null && sComp.length() > 0) {
                        double compVal = getComponentValue("JANGKA_WAKTU", sComp, increase, hpp, dp);
                        formula = formula.replaceAll("" + sComp, "" + compVal);
                    }

                    value = getValue(formula);

                    switch (jangkaWaktuFormula.getPembulatan()) {
                        case PstJangkaWaktuFormula.PEMBULATAN_PULUHAN:
                            value = rounding(-1, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RATUSAN:
                            value = rounding(-2, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RIBUAN:
                            value = rounding(-3, value);
                            break;
                    }

                    hashFormula.put(jangkaWaktuFormula.getCode(), value);
                    if (String.valueOf(vLsitComp.get(1)).equals(jangkaWaktuFormula.getCode())) {
                        retValue = value;
                        break;
                    }

                }
            }
        }

        return retValue;
    }
     
    public int convertInteger(int scale, double val) {
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(scale, RoundingMode.UP);
        return bDecimal.intValue();
    }

    public static double rounding(int scale, double val) {
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(scale, RoundingMode.UP);
        return bDecimal.doubleValue();
    }
    
    /**
     * @return the running
     */
    public boolean isRunning() {
        return running;
    }

    /**
     * @param running the running to set
     */
    public void setRunning(boolean running) {
        this.running = running;
    }
    
    /**
     * @return the sleepMs
     */
    public long getSleepMs() {
        return sleepMs;
    }

    /**
     * @param sleepMs the sleepMs to set
     */
    public void setSleepMs(long sleepMs) {
        this.sleepMs = sleepMs;
    }
    
}
