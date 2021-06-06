/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.ajax.masterdata;

import com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.hanoman.entity.masterdata.MasterGroup;
import com.dimata.hanoman.entity.masterdata.MasterType;
import com.dimata.hanoman.entity.masterdata.PstMasterType;
import com.dimata.pos.entity.billing.PstBillDetail;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.posbo.entity.masterdata.Category;
import com.dimata.posbo.entity.masterdata.Color;
import com.dimata.posbo.entity.masterdata.Material;
import com.dimata.posbo.entity.masterdata.MaterialTypeMapping;
import com.dimata.posbo.entity.masterdata.Merk;
import com.dimata.posbo.entity.masterdata.PstCategory;
import com.dimata.posbo.entity.masterdata.PstColor;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import com.dimata.posbo.entity.masterdata.PstMaterialMappingType;
import com.dimata.posbo.entity.masterdata.PstMerk;
import com.dimata.posbo.entity.masterdata.PstPriceTypeMapping;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.kredit.PstTypeKredit;
import com.dimata.sedana.entity.kredit.TypeKredit;
import com.dimata.sedana.entity.masterdata.JangkaWaktu;
import com.dimata.sedana.entity.masterdata.JangkaWaktuFormula;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktu;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktuFormula;
import com.dimata.services.WebServices;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.ResultSet;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Dimata IT Solutions
 */
public class AjaxMaterial extends HttpServlet {

    //DATATABLES
    private String searchTerm;
    private String colName;
    private int colOrder;
    private String dir;
    private int start;
    private int amount;

    //OBJECT
    private JSONObject jSONObject = new JSONObject();
    private JSONArray jSONArray = new JSONArray();
    private JSONArray jSONMaterial = new JSONArray();

    //LONG
    private long oid = 0;
    private long oidReturn = 0;
    private long tipeKreditId = 0;

    //STRING
    private String dataFor = "";
    private String oidDelete = "";
    private String approot = "";
    private String htmlReturn = "";
    private String message = "";
    private String posApiUrl = "";

    //BOOLEAN
    private boolean privAdd = false;
    private boolean privUpdate = false;
    private boolean privDelete = false;
    private boolean privView = false;

    //INT
    private int iCommand = 0;
    private int iErrCode = 0;

    private long userId = 0;
    private String userName = "";

    private double totalPrice = 0;
    private double totalPokok = 0;
    private double totalBunga = 0;
    private double minDp = 0;
    private double jumlahBunga = 0;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        this.tipeKreditId = FRMQueryString.requestLong(request, "TIPE_KREDIT_ID");

        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.oidDelete = FRMQueryString.requestString(request, "FRM_FIELD_OID_DELETE");
        this.approot = FRMQueryString.requestString(request, "FRM_FIELD_APPROOT");
        this.htmlReturn = "";
        this.message = "";
        this.posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");

        //BOOLEAN
        this.privAdd = FRMQueryString.requestBoolean(request, "privadd");
        this.privUpdate = FRMQueryString.requestBoolean(request, "privupdate");
        this.privDelete = FRMQueryString.requestBoolean(request, "privdelete");
        this.privView = FRMQueryString.requestBoolean(request, "privview");

        //INT
        this.iCommand = FRMQueryString.requestCommand(request);
        this.iErrCode = 0;
        this.totalPrice = 0;
        this.jumlahBunga = 0;

        //OBJECT
        this.jSONObject = new JSONObject();
        this.jSONMaterial = new JSONArray();

        switch (this.iCommand) {
            case Command.SAVE:
                //history
                //commandSave(request);
                break;

            case Command.DELETE:
                commandDelete(request);
                break;

            case Command.LIST:
                commandList(request, response);
                break;

            default:
                commandNone(request);
                break;
        }

        try {
            this.jSONObject.put("FRM_FIELD_HTML", this.htmlReturn);
            this.jSONObject.put("RETURN_DATA_MATERIAL", this.jSONMaterial);
            this.jSONObject.put("RETURN_MESSAGE", this.message);
            this.jSONObject.put("RETURN_ERROR_CODE", "" + this.iErrCode);
            this.jSONObject.put("FRM_TOTAL_PRICE", "" + this.totalPrice);
            this.jSONObject.put("FRM_TOTAL_BUNGA", "" + this.totalBunga);
            this.jSONObject.put("FRM_TOTAL_POKOK", "" + this.totalPokok);
            this.jSONObject.put("FRM_MIN_DP", "" + this.minDp);
            this.jSONObject.put("FRM_JUMLAH_BUNGA", "" + this.jumlahBunga);

        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }
        response.getWriter().print(this.jSONObject);
    }

    public void commandNone(HttpServletRequest request) {
        if (this.dataFor.equals("calculatePrice")) {
            calculatePriceV2(request);
        } else if (this.dataFor.equals("getMaterial")) {
            this.htmlReturn = getMaterial(request);
        } else if (this.dataFor.equals("getMatSimulasi")) {
            this.htmlReturn = getMatSimulasi(request);
        } else if (this.dataFor.equals("calculateDP")) {
            calculateDpV2(request);
        }
    }
    
    public void commandDelete(HttpServletRequest request) {
        if (this.dataFor.equals("deleteBillDetail")) {
            deleteBillDetail();
        }
    }

    public void commandList(HttpServletRequest request, HttpServletResponse response) {
        if (this.dataFor.equals("listMaterial")) {
            String[] cols = {
                PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID],
                PstMaterial.fieldNames[PstMaterial.FLD_SKU],
                PstMaterial.fieldNames[PstMaterial.FLD_BARCODE],
                PstMaterial.fieldNames[PstMaterial.FLD_NAME],
                PstCategory.fieldNames[PstCategory.FLD_NAME],
                PstMerk.fieldNames[PstMerk.FLD_NAME],
                PstColor.fieldNames[PstColor.FLD_COLOR_NAME],
                PstMaterial.fieldNames[PstMaterial.FLD_NAME],
                PstMaterial.fieldNames[PstMaterial.FLD_NAME],
                PstMaterial.fieldNames[PstMaterial.FLD_NAME]
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        }
    }

    public JSONObject listDataTables(HttpServletRequest request, HttpServletResponse response, String[] cols, String dataFor, JSONObject result) {
        this.searchTerm = FRMQueryString.requestString(request, "sSearch");
        this.searchTerm = WebServices.encodeUrl(this.searchTerm);
        int amount = 10;
        int start = 0;
        int col = 0;
        String dir = "asc";
        String sStart = request.getParameter("iDisplayStart");
        String sAmount = request.getParameter("iDisplayLength");
        String sCol = request.getParameter("iSortCol_0");
        String sdir = request.getParameter("sSortDir_0");

        if (sStart != null) {
            start = Integer.parseInt(sStart);
            if (start < 0) {
                start = 0;
            }
        }
        if (sAmount != null) {
            amount = Integer.parseInt(sAmount);
            if (amount < 10) {
                amount = 10;
            }
        }
        if (sCol != null) {
            col = Integer.parseInt(sCol);
            if (col < 0) {
                col = 0;
            }
        }
        if (sdir != null) {
            if (!sdir.equals("asc")) {
                dir = "desc";
            }
        }

        String whereClause = "";
        String creditPriceTypeId = PstSystemProperty.getValueByName("CREDIT_PRICE_TYPE_MAPPING_ID");
        String defaultStandardRateId = PstSystemProperty.getValueByName("DEFAULT_PRICE_CURRENCY_ID");
        String payload = "{priceTypeId : '" + creditPriceTypeId + "', "
                + "standardRateId : '" + defaultStandardRateId + "',"
                + "oids: '', "
                + "keyword:'" + searchTerm + "',"
                + "limitStart:" + start + ","
                + "recordToGet:" + amount + "}";

        String url = "";
        JenisKredit typeKredit = new JenisKredit();
        try {
            typeKredit = PstTypeKredit.fetchExc(this.tipeKreditId);
        } catch (Exception exc) {
        }
        if (typeKredit.getCategoryId() > 0) {
            if (searchTerm.length() > 0) {
                url = this.posApiUrl + "/material/material-credit-by-category/" + typeKredit.getCategoryId() + "/" + WebServices.encodeUrl(searchTerm) + "/" + start + "/" + amount + "/" + colName;
            } else {
                url = this.posApiUrl + "/material/material-credit-by-category/" + typeKredit.getCategoryId() + "/" + start + "/" + amount + "/" + colName;
            }
        } else {
            if (searchTerm.length() > 0) {
                url = this.posApiUrl + "/material/material-credit/" + WebServices.encodeUrl(searchTerm) + "/" + start + "/" + amount + "/" + colName;
            } else {
                url = this.posApiUrl + "/material/material-credit/" + start + "/" + amount + "/" + colName;
            }
        }

        System.out.println("Url : " + url);
        JSONObject object = WebServices.getAPI(payload, url);

        String colName = cols[col];
        int total = -1;
        try {
            total = object.getInt("COUNT");
        } catch (Exception exc) {
        }

        this.amount = amount;

        this.colName = colName;
        this.dir = dir;
        this.start = start;
        this.colOrder = col;

        try {
            result = getData(total, request, dataFor, object);
        } catch (Exception ex) {
            //printErrorMessage(ex.getMessage());
        }

        return result;
    }

    public JSONObject getData(int total, HttpServletRequest request, String datafor, JSONObject object) {
        int totalAfterFilter = total;
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        Material mat = new Material();
        MaterialTypeMapping matType = new MaterialTypeMapping();
        Category cat = new Category();
        Merk mk = new Merk();
        MasterType masType = new MasterType();
        MasterGroup masGroup = new MasterGroup();
        Color col = new Color();
        String whereClause = "";
        String order = "";
        String category = "-";
        String brand = "-";
        String warna = "-";
        
        long locationId = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_ID");
        
        int type = 0;

        if (this.colOrder >= 0) {
            order += "" + colName + " " + dir + "";
        }

        try {
            JSONArray arr = object.getJSONArray("DATA");
            for (int i = 0; i < arr.length(); i++) {
                JSONArray ja = new JSONArray();
                try {
                    long oid = arr.getJSONObject(i).optLong(PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID], 0);

                    String linkMaterial = posApiUrl + "/material/material-credit/" + oid;
                    JSONObject objMaterial = WebServices.getAPI("", linkMaterial);
                    long oidMaterial = PstMaterial.syncExc(objMaterial);
                    mat = PstMaterial.fetchExc(oidMaterial);
                    System.out.println("Material Services : " + linkMaterial);

                    String linkTypeMaterial = posApiUrl + "/material-type-id/" + oidMaterial;
                    JSONObject objTypeMaterial = WebServices.getAPI("", linkTypeMaterial);
                    long oidMaterialType = PstMaterialMappingType.syncExc(objTypeMaterial);
                    try {
                        matType = PstMaterialMappingType.fetchExc(oidMaterialType);
                    } catch (Exception exc){}
                    
                    System.out.println("Material Type Mapping Services : " + linkTypeMaterial);

                    //Untuk check data baru MasterType 
                    String linkMasterType = posApiUrl + "/master-type/" + matType.getTypeId();
                    JSONObject objMasterType = WebServices.getAPI("", linkMasterType);
                    
                    try {
                        long oidMasterType = PstMasterType.syncExc(objMasterType);
                    } catch (Exception exc){}
                    System.out.println("Master Type Services : " + linkMasterType);

                    String linkColor = posApiUrl + "/color/" + mat.getColorId();
                    JSONObject objColor = WebServices.getAPI("", linkColor);
                    long oidColor = PstColor.syncExc(objColor);
                    try {
                        col = PstColor.fetchExc(oidColor);
                    } catch (Exception exc){}
                    
                    System.out.println("Color Services : " + linkColor);

                    try {
                        cat = PstCategory.fetchExc(mat.getCategoryId());
                        mk = PstMerk.fetchExc(mat.getMerkId());
                    } catch (Exception exc){}
                    
                    Vector listType = PstMasterType.list(0, 0, PstMasterType.fieldNames[PstMasterType.FLD_MASTER_TYPE_ID] + " = " + matType.getTypeId() + " AND " + PstMasterType.fieldNames[PstMasterType.FLD_TYPE_GROUP] + "= 2", "");

                    String sku = arr.getJSONObject(i).optString(PstMaterial.fieldNames[PstMaterial.FLD_SKU], "-");
                    String barcode = arr.getJSONObject(i).optString(PstMaterial.fieldNames[PstMaterial.FLD_BARCODE], "-");
                    String name = arr.getJSONObject(i).optString(PstMaterial.fieldNames[PstMaterial.FLD_NAME], "-");
                    category = cat.getName();
                    brand = mk.getName();
                    warna = col.getColorName();
                    //JSONObject objectPrice = new JSONObject();
                    double price = arr.getJSONObject(i).optDouble("PRICE", 0);
//                    try {
//                        objectPrice = arr.getJSONObject(i).getJSONObject(PstPriceTypeMapping.TBL_POS_PRICE_TYPE_MAPPING);
//                        price = objectPrice.getDouble(PstPriceTypeMapping.fieldNames[PstPriceTypeMapping.FLD_PRICE]);
//                    } catch (Exception exc) {
//                    }

                    String linkQty = posApiUrl + "/material/material-stock/" + oid+"/"+locationId;
                    JSONObject objQty = WebServices.getAPI("", linkQty);
                    int qty = objQty.optInt("QTY", 0);
                    ja.put("" + (this.start + i + 1) + ".");
                    ja.put("<a href='#' class='mat-sku' data-oid='" + oid + "' data-matname='" + name + "' data-matprice='" + price + "' data-qty='"+qty+"'>" + sku + "</a>");
                    ja.put(barcode);
                    ja.put(name);
                    ja.put(category);
                    ja.put(brand);
                    ja.put(warna);
                    if (listType.isEmpty()) {
                        ja.put("-");
                    } else {
                        for (int x = 0; x < listType.size(); x++) {
                            MasterType mt = (MasterType) listType.get(x);
                            ja.put(mt.getMasterName());
                        }
                    }
                    ja.put(Formater.formatNumber(price, "#,###"));
                    ja.put(""+qty);
                    ja.put("<div class='text-center'><button type='button' class='btn btn-xs btn-warning mat-sku' data-oid='" + oid + "' data-matname='" + name + "' data-matprice='" + price + "' data-qty='"+qty+"'>Pilih</button></div>");
                    array.put(ja);
                } catch (Exception exc) {
                }

            }
        } catch (Exception exc) {
        }

        totalAfterFilter = total;
        try {
            result.put("iTotalRecords", total);
            result.put("iTotalDisplayRecords", totalAfterFilter);
            result.put("aaData", array);
        } catch (Exception e) {

        }
        return result;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    public void calculatePrice(HttpServletRequest request) {
        String[] oids = FRMQueryString.requestStringValues(request, "OID_MATERIAL");
        String[] qtys = FRMQueryString.requestStringValues(request, "MATERIAL_QTY");
        double dp = FRMQueryString.requestDouble(request, "DP");
        double totalCash = FRMQueryString.requestDouble(request, "TOTAL_CASH");
        JSONObject jo = new JSONObject();
        double pengajuan = 0;
        double bunga = 0;
        double totalIemPrice = 0;
        if (oids != null) {
            double priceTotal = 0;
            int i = 0;
            for (String strOid : oids) {
                try {
                    String url = this.posApiUrl + "/material/material-credit/" + strOid;
                    jo = WebServices.getAPI("", url);
                    int qty = 1;
                    try {
                        qty = Integer.parseInt(qtys[i]);
                    } catch (Exception exc) {
                    }         
                    double itemPrice = 0;
                    if (dp > 0) {
                        double priceDp = qty * convertInteger(-3, calculatePrice(request, jo, priceTotal, PstBillMain.TRANS_TYPE_CREDIT, true));
                        itemPrice = qty * convertInteger(-3, calculatePrice(request, jo, priceTotal, PstBillMain.TRANS_TYPE_CASH, true));
                        totalIemPrice += itemPrice;
                        priceTotal += priceDp;
                        bunga += (priceDp - itemPrice);
                        double tempPrice = itemPrice - dp;
                        itemPrice = tempPrice;
                    } else {
                        itemPrice = qty * convertInteger(-3, calculatePrice(request, jo, priceTotal, PstBillMain.TRANS_TYPE_CASH));
                        priceTotal += itemPrice;
                    }
                } catch (Exception exc) {
                }
                i++;
            }
            this.totalPrice = priceTotal;
            this.jumlahBunga = priceTotal - totalCash;
        } else {
            this.totalPrice = 0;
        }
    }

    public void calculatePriceV2(HttpServletRequest request) {
        this.totalPrice = 0;
        this.totalBunga = 0;
        this.totalPokok = 0;
        this.minDp = 0;
        this.jumlahBunga = 0;
        String[] oids = FRMQueryString.requestStringValues(request, "OID_MATERIAL");
        String[] qtys = FRMQueryString.requestStringValues(request, "MATERIAL_QTY");
        double dp = FRMQueryString.requestDouble(request, "DP");
        double totalCash = FRMQueryString.requestDouble(request, "TOTAL_CASH");
        double totalHPP = FRMQueryString.requestDouble(request, "TOTAL_HPP");
        long oidJangkaWaktu = FRMQueryString.requestLong(request, "JANGKA_WAKTU_ID");
        long jenisKreditId = FRMQueryString.requestLong(request, "JENIS_KREDIT_ID");
        Hashtable<String, Double> hashFormula = new Hashtable<>();
        Vector listFormula = PstJangkaWaktuFormula.list(0, 0, 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID]+"="+oidJangkaWaktu+" AND "+
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_KREDIT_ID]+"="+jenisKreditId+" AND "+
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_STATUS]+"= 0", 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);
        if (listFormula.size()==0){
            listFormula = PstJangkaWaktuFormula.list(0, 0, 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID]+"="+oidJangkaWaktu+" AND "+
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_KREDIT_ID]+"= 0 AND "+
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_STATUS]+"= 0", 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);
        }
        
        double pengajuan = 0;
        double pokok = 0;
        double bunga = 0;
        double value = 0;
        double minDp = 0;
        double increase = 0;
        
        if (oids != null) {
            for (int o=0; o < oids.length;o++){
                JSONObject jo = new JSONObject();
                String url = this.posApiUrl + "/material/material-credit/" + oids[o];
                jo = WebServices.getAPI("", url);
                JSONObject joCat = jo.optJSONObject(PstCategory.TBL_CATEGORY);
                increase =  joCat.optDouble("KENAIKAN_HARGA");
                double qty = 0;
                try {
                    qty = Double.parseDouble(qtys[o]);
                } catch (Exception exc){}
                if (listFormula.size()>0) {
            
                for (int i = 0; i < listFormula.size(); i ++){
                    JangkaWaktuFormula jangkaWaktuFormula = (JangkaWaktuFormula) listFormula.get(i);
                    String formula = jangkaWaktuFormula.getFormula().replaceAll("%", "/100");
                    formula = formula.replaceAll("&gt", ">");
                    formula = formula.replaceAll("&lt", "<");
                    if (checkString(formula, "HPP") > -1) {
                        formula = formula.replaceAll("HPP", "" + (jo.optDouble(PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE],0)));
                    }
                    if (checkString(formula, "DP") > -1) {
                        formula = formula.replaceAll("DP", "" + dp);
                    }
                    if (checkString(formula, "INCREASE") > -1) {
                        formula = formula.replaceAll("INCREASE", increase + " / 100.0");
                    }

                    String sComp = checkStringStart(formula, "JANGKA_WAKTU");
                    if (sComp != null && sComp.length() > 0) {
                        double compVal = getComponentValue("JANGKA_WAKTU",sComp,increase,totalHPP,dp);
                        formula = formula.replaceAll(""+sComp, "" + compVal);
                    }

                    for(Map.Entry m : hashFormula.entrySet()) {
                        formula = formula.replaceAll(""+m.getKey(), "" + m.getValue());
                    }

                    value = getValue(formula);

                    switch(jangkaWaktuFormula.getPembulatan()){
                        case PstJangkaWaktuFormula.PEMBULATAN_PULUHAN :
                            value = rounding(-1, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RATUSAN :
                            value = rounding(-2, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RIBUAN :
                            value = rounding(-3, value);
                            break;
                    }

                    if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_NILAI_PENGAJUAN) {
                        pengajuan = value * qty;
                    }
                    if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_BUNGA) {
                        bunga = value * qty;
                    }
                    if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_POKOK) {
                        pokok = value * qty;
                    }
                    if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_DP) {
                        minDp = value * qty;
                    }


                    hashFormula.put(jangkaWaktuFormula.getCode(), value);

                }

                this.totalPrice += pengajuan;
                this.totalBunga += bunga;
                this.totalPokok += pokok;
                this.minDp = +minDp;
                this.jumlahBunga += pengajuan - totalCash;
            } else {
                this.totalPrice += 0;
            }
                
            }
            
        }
        
        if (oids != null){
            if (dp>0 & oids.length > 1){
                hashFormula = new Hashtable<>();
                for (int i = 0; i < listFormula.size(); i ++){
                    JangkaWaktuFormula jangkaWaktuFormula = (JangkaWaktuFormula) listFormula.get(i);
                    String formula = jangkaWaktuFormula.getFormula().replaceAll("%", "/100");
                    formula = formula.replaceAll("&gt", ">");
                    formula = formula.replaceAll("&lt", "<");
                    if (checkString(formula, "HPP") > -1) {
                        formula = ""+totalCash;
                    }
                    if (checkString(formula, "DP") > -1) {
                        formula = formula.replaceAll("DP", "" + dp);
                    }
                    if (checkString(formula, "INCREASE") > -1) {
                        formula = formula.replaceAll("INCREASE", increase + " / 100.0");
                    }

                    String sComp = checkStringStart(formula, "JANGKA_WAKTU");
                    if (sComp != null && sComp.length() > 0) {
                        double compVal = getComponentValue("JANGKA_WAKTU",sComp,increase,totalHPP,dp);
                        formula = formula.replaceAll(""+sComp, "" + compVal);
                    }

                    for(Map.Entry m : hashFormula.entrySet()) {
                        formula = formula.replaceAll(""+m.getKey(), "" + m.getValue());
                    }

                    value = getValue(formula);

                    switch(jangkaWaktuFormula.getPembulatan()){
                        case PstJangkaWaktuFormula.PEMBULATAN_PULUHAN :
                            value = rounding(-1, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RATUSAN :
                            value = rounding(-2, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RIBUAN :
                            value = rounding(-3, value);
                            break;
                    }

                    if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_NILAI_PENGAJUAN) {
                        pengajuan = value;
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
                this.totalPrice = pengajuan;
                this.totalBunga = bunga;
                this.totalPokok = pokok;
                this.minDp = minDp;
                this.jumlahBunga = pengajuan - totalCash;
            }
        }
        
    }
    
    public double getComponentValue(String compName, String formulaPart, double increase, double hpp, double dp){
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

        Vector vJangkaWaktu = PstJangkaWaktu.list(0, 0, PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU]+"='"+vLsitComp.get(0)+"'", "");
        if (vJangkaWaktu.size()>0){
            JangkaWaktu jangkaWaktu = (JangkaWaktu) vJangkaWaktu.get(0);

             Vector listFormula = PstJangkaWaktuFormula.list(0, 0, 
                    PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID]+"="+jangkaWaktu.getOID(), 
                    PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);

            Hashtable<String, Double> hashFormula = new Hashtable<>();
            double value = 0;
            if (listFormula.size()>0){
                for (int i = 0; i < listFormula.size(); i ++){
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

                    for(Map.Entry m : hashFormula.entrySet()) {
                        formula = formula.replaceAll(""+m.getKey(), "" + m.getValue());
                    }

                    String sComp = checkStringStart(formula, "JANGKA_WAKTU");
                    if (sComp != null && sComp.length() > 0) {
                        double compVal = getComponentValue("JANGKA_WAKTU",sComp,increase,hpp,dp);
                        formula = formula.replaceAll(""+sComp, "" + compVal);
                    }

                    value = getValue(formula);

                    switch(jangkaWaktuFormula.getPembulatan()){
                        case PstJangkaWaktuFormula.PEMBULATAN_PULUHAN :
                            value = rounding(-1, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RATUSAN :
                            value = rounding(-2, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RIBUAN :
                            value = rounding(-3, value);
                            break;
                    }

                    hashFormula.put(jangkaWaktuFormula.getCode(), value);
                    if (String.valueOf(vLsitComp.get(1)).equals(jangkaWaktuFormula.getCode())){
                        retValue = value;
                        break;
                    }

                }
            }
        }

        return retValue;
    }

    public static Vector listComponent(String compName, String formulaPart, String sPartBy) {
        Vector vLsitComp = null;
        if (compName == null || formulaPart == null) {
            return null;
        }
        compName = compName.trim();
        formulaPart = formulaPart.trim();
        if (formulaPart.startsWith(compName)) {
            String[] parts = formulaPart.split(sPartBy);
            if (parts.length > 0) {
                vLsitComp = new Vector();
                for (int i = 1; i < parts.length; i++) {
                    vLsitComp.add(parts[i]);
                }
            }
        }
        return vLsitComp;
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
    
    public String getMaterial(HttpServletRequest request) {
        String url = this.posApiUrl + "/material/material-credit/" + oid;
        String html = "";
        try {
            JSONObject jo = WebServices.getAPI("", url);
            double dp = FRMQueryString.requestDouble(request, "DP");
            double priceTotal = FRMQueryString.requestDouble(request, "TOTAL_PRICE");
            double itemPrice = 0;
            int qty = FRMQueryString.requestInt(request, "QTY");
            if (dp > 0) {
                itemPrice = jo.optDouble("PRICE", 0);
                this.totalPrice = qty * convertInteger(-3, calculatePrice(request, jo, priceTotal, 1));
            } else {
                itemPrice = calculatePrice(request, jo, priceTotal, 0);
                this.totalPrice = qty * convertInteger(-3, this.totalPrice + itemPrice);
            }

            html = "<tr class='row_" + oid + "' id='" + oid + "'>"
                    + "<td><input type='hidden' name='OID_MATERIAL' value='" + oid + "'>" + jo.optString(PstMaterial.fieldNames[PstMaterial.FLD_NAME], "") + "</td>"
                    + "<td><input type='hidden' name='MATERIAL_QTY' value='" + qty + "'>" + qty + "</td>"
                    + "<td>"
                    + "<input type='hidden' name='MATERIAL_PRICE_TOTAL' value='" + convertInteger(-3, itemPrice) + "'>"
                    + "<input type='hidden' class='cost' name='COST' value='" + (jo.optDouble(PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE], 0)) + "'>"
                    + "<input type='hidden' name='MATERIAL_PRICE' value='" + jo.optDouble("PRICE", 0) + "'><span id='total_" + oid + "' class='money'>" + (qty * jo.optDouble("PRICE", 0)) + "</span>"
                    + "<input type='hidden' class='cashTotal' value='" + (qty * jo.optDouble("PRICE", 0)) + "'>"
                    + "</td>"
                    + "<td><button type='button' class='btn btn-xs btn-danger mat-delete' data-oid='" + oid + "' data-total='" + jo.optDouble("PRICE", 0) + "'><i class='fa fa-trash'></i></button></td>"
                    + "</tr>";

        } catch (Exception exc) {

        }
        return html;
    }

    public String getMatSimulasi(HttpServletRequest request) {
        String simulasiMatId = FRMQueryString.requestString(request, "FRM_FIELD_OID");
        String[] idSimulasi = simulasiMatId.split(",");
        String simulasiMatQty = FRMQueryString.requestString(request, "QTY");
        String[] qtySimulasi = simulasiMatQty.split(",");
        String simulasiMatPrice = FRMQueryString.requestString(request, "PRICE");
        String[] priceSimulasi = simulasiMatPrice.split(",");
        Material mti = new Material();
        long oidSimulasiMat = 0;
        int qtySim = 0;
        double priceSim = 0;
        String html = "";
        for (int i = 0; i < idSimulasi.length; i++) {
            oidSimulasiMat = Long.parseLong(idSimulasi[i]);
            qtySim = Integer.parseInt(qtySimulasi[i]);
            priceSim = Double.valueOf(priceSimulasi[i]);

            String url = this.posApiUrl + "/material/material-credit/" + oidSimulasiMat;
            try {
                JSONObject jo = WebServices.getAPI("", url);
                double dp = FRMQueryString.requestDouble(request, "DP");
                double priceTotal = FRMQueryString.requestDouble(request, "TOTAL_PRICE");
                double itemPrice = 0;
                int qty = qtySim;
                if (dp > 0) {
                    itemPrice = jo.optDouble("PRICE", 0);
                    this.totalPrice = qty * convertInteger(-3, calculatePrice(request, jo, priceTotal, 1));
                } else {
                    itemPrice = calculatePrice(request, jo, priceTotal, 0);
                    this.totalPrice = qty * convertInteger(-3, this.totalPrice + itemPrice);
                }

                html += "<tr id='" + oidSimulasiMat + "'>"
                        + "<td><input type='hidden' name='OID_MATERIAL' value='" + oidSimulasiMat + "'>" + jo.optString(PstMaterial.fieldNames[PstMaterial.FLD_NAME], "") + "</td>"
                        + "<td><input type='hidden' name='MATERIAL_QTY' value='" + qty + "'>" + qty + "</td>"
                        + "<td>"
                        + "<input type='hidden' name='MATERIAL_PRICE_TOTAL' value='" + convertInteger(-3, itemPrice) + "'>"
                        + "<input type='hidden' name='COST' value='" + jo.optDouble(PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE], 0) + "'>"
                        + "<input type='hidden' name='MATERIAL_PRICE' value='" + jo.optDouble("PRICE", 0) + "'><span id='total_" + oidSimulasiMat + "' class='money'>" + (qty * jo.optDouble("PRICE", 0)) + "</span>"
                        + "</td>"
                        + "<td><button type='button' class='btn btn-xs btn-danger mat-delete' data-oid='" + oidSimulasiMat + "' data-total='" + jo.optDouble("PRICE", 0) + "'><i class='fa fa-trash'></i></button></td>"
                        + "</tr>";

            } catch (Exception exc) {

            }
        }
        return html;
    }

    public void calculateDp(HttpServletRequest request) {
        String[] oids = FRMQueryString.requestStringValues(request, "OID_MATERIAL");
        String[] qtys = FRMQueryString.requestStringValues(request, "MATERIAL_QTY");
        double totalCash = FRMQueryString.requestDouble(request, "TOTAL_CASH");
        int tipeDp = FRMQueryString.requestInt(request, "TIPE_DP");
        double totalAwal = 0;
        if (oids != null) {
            double priceTotal = 0;
            int i = 0;
            for (String strOid : oids) {
                try {
                    String url = this.posApiUrl + "/material/material-credit/" + strOid;
                    JSONObject jo = WebServices.getAPI("", url);
                    int qty = 1;
                    try {
                        qty = Integer.parseInt(qtys[i]);
                    } catch (Exception exc) {
                    }
                    double itemPrice = qty * convertInteger(-3, calculatePrice(request, jo, priceTotal, 0, true));
                    priceTotal = priceTotal + itemPrice;
                } catch (Exception exc) {
                }
                i++;
            }
            totalAwal = priceTotal;
        }
//        double potongan = totalAwal;
        double cash = totalAwal;
        double totalDp = 0;
        if (tipeDp == 0) {
            totalDp = cash * 30 / 100;
        } else {
            totalDp = cash * 70 / 100;
        }
        this.totalPrice = convertInteger(-3, totalDp);
        this.jumlahBunga = totalAwal - totalCash;
    }
    
    public void calculateDpV2(HttpServletRequest request) {
        String[] oids = FRMQueryString.requestStringValues(request, "OID_MATERIAL");
        String[] qtys = FRMQueryString.requestStringValues(request, "MATERIAL_QTY");
        double totalCash = FRMQueryString.requestDouble(request, "TOTAL_CASH");
        double totalHPP = FRMQueryString.requestDouble(request, "TOTAL_HPP");
        long oidJangkaWaktu = FRMQueryString.requestLong(request, "JANGKA_WAKTU_ID");
        int tipeDp = FRMQueryString.requestInt(request, "TIPE_DP");
        long jenisKreditId = FRMQueryString.requestLong(request, "JENIS_KREDIT_ID");
        
        /*Vector listFormula = PstJangkaWaktuFormula.list(0, 0, 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID]+"="+oidJangkaWaktu, 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]); */
        
        
        Vector listFormula = PstJangkaWaktuFormula.list(0, 0, 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID]+"="+oidJangkaWaktu+" AND "+
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_KREDIT_ID]+"="+jenisKreditId+" AND "+
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_STATUS]+"= 0", 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);
        if (listFormula.size()==0){
            listFormula = PstJangkaWaktuFormula.list(0, 0, 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID]+"="+oidJangkaWaktu+" AND "+
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_KREDIT_ID]+"= 0 AND "+
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_STATUS]+"= 0", 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);
        }
        
        Hashtable<String, Double> hashFormula = new Hashtable<>();
        double dp = 0;
        double pengajuan = 0;
        double value = 0;
        double increase = 0;
        double totalPengajuan = 0;
        JSONObject jo = new JSONObject();
        if (oids != null) {
            for (int o=0; o < oids.length;o++){
                String url = this.posApiUrl + "/material/material-credit/" + oids[o];
                jo = WebServices.getAPI("", url);
                JSONObject joCat = jo.optJSONObject(PstCategory.TBL_CATEGORY);
                totalPengajuan +=  (Integer.valueOf(qtys[o]) * jo.optDouble("PRICE",0));
            }
            
        }
        
        
        
        if (listFormula.size()>0){
            for (int i = 0; i < listFormula.size(); i ++){
                JangkaWaktuFormula jangkaWaktuFormula = (JangkaWaktuFormula) listFormula.get(i);
                String formula = jangkaWaktuFormula.getFormula().replaceAll("%", "/100");
                formula = formula.replaceAll("&gt", ">");
                formula = formula.replaceAll("&lt", "<");
                
                if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_DP){
                    formula = formula.replaceAll("A1", "" + totalPengajuan);
                }
                
                
                value = getValue(formula);

                switch(jangkaWaktuFormula.getPembulatan()){
                    case PstJangkaWaktuFormula.PEMBULATAN_PULUHAN :
                        value = rounding(-1, value);
                        break;
                    case PstJangkaWaktuFormula.PEMBULATAN_RATUSAN :
                        value = rounding(-2, value);
                        break;
                    case PstJangkaWaktuFormula.PEMBULATAN_RIBUAN :
                        value = rounding(-3, value);
                        break;
                }
                
                if (jangkaWaktuFormula.getTransType() == PstJangkaWaktuFormula.TYPE_DP){
                    dp = value;
                } 

                hashFormula.put(jangkaWaktuFormula.getCode(), value);

            }
        }
        this.totalPrice = dp;
        this.jumlahBunga = pengajuan - totalCash;
    }

    public double calculatePrice(HttpServletRequest request, JSONObject object, double priceTotal, int transType) {
        return calculatePrice(request, object, priceTotal, transType, false);
    }
    
    public double calculatePrice(HttpServletRequest request, JSONObject object, double priceTotal, int transType, boolean isDp) {
        String formula = "";
        try {
            long jangkaWaktuId = FRMQueryString.requestLong(request, "JANGKA_WAKTU_ID");
            double dp = FRMQueryString.requestDouble(request, "DP");
            
            if(isDp){
                if(transType == PstBillMain.TRANS_TYPE_CREDIT){
                    String jangkaWaktu = PstSystemProperty.getValueByName("JANGKA_WAKTU_6");
                    String whereClause = PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID] + "=" + jangkaWaktu
                            + " AND " + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_TRANSACTION_TYPE] + "=" + PstBillMain.TRANS_TYPE_CASH;
                    Vector list = PstJangkaWaktuFormula.list(0, 0, whereClause, "");
                    formula = ((JangkaWaktuFormula) list.get(0)).getFormula();
                } else {
                    String url = this.posApiUrl + "/formula-cash/";
                    JSONObject formulaRes = WebServices.getAPI("", url);
                    formula = formulaRes.optString("RESULT", "");
                }
            } else {
                String whereClause = PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID] + "=" + jangkaWaktuId
                        + " AND " + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_TRANSACTION_TYPE] + "=" + transType;
                Vector list = PstJangkaWaktuFormula.list(0, 0, whereClause, "");
                if (list.size() > 0) {
                    JangkaWaktuFormula jwf = (JangkaWaktuFormula) list.get(0);
                    formula = jwf.getFormula();
                }
            }
            if (formula.length() > 0) {
                if (checkString(formula, "HPP") > -1) {
                    formula = formula.replaceAll("HPP", "" + object.optDouble(PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE], 0));
                }
                if (checkString(formula, "DP") > -1) {
                    formula = formula.replaceAll("DP", "" + dp);
                }
                if (checkString(formula, "INCREASE") > -1) {
                    JSONObject joCat = object.optJSONObject(PstCategory.TBL_CATEGORY);
                    formula = formula.replaceAll("INCREASE", "" + joCat.optDouble("KENAIKAN_HARGA", 0));
                }
                if (checkString(formula, "TOTAL_PRICE") > -1) {
                    formula = formula.replaceAll("TOTAL_PRICE", "" + priceTotal);
                }
            }
        } catch (Exception exc) {
            System.out.println("Calculate Price: " + exc.getMessage());
            exc.printStackTrace();
        }

        return getValue(formula);
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

    public int convertInteger(int scale, double val) {
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(scale, RoundingMode.UP);
        return bDecimal.intValue();
    }
    
    public static double rounding(int scale, double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(scale, RoundingMode.UP);
        return bDecimal.doubleValue();
    }

    public void deleteBillDetail(){
        try {
            PstBillDetail.deleteExc(oid);
            String url = this.posApiUrl + "/bill/bill-detail/delete-oid/" + oid;
            JSONObject jo = WebServices.getAPI("", url);
        } catch (Exception exc){}
    }
    
}
