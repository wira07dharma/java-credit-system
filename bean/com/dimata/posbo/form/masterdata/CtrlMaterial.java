package com.dimata.posbo.form.masterdata;

/* java package */

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

/* dimata package */
import com.dimata.util.*; 
import com.dimata.util.lang.*;

/* qdep package */
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.posbo.db.*;

/* project package */
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.posbo.session.masterdata.SessMaterial;
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.system.entity.*;

//integrasi dengan BO
import com.dimata.ObjLink.BOPos.CatalogLink;
import com.dimata.interfaces.BOPos.I_Catalog;
import com.dimata.common.entity.payment.*;
import com.dimata.common.entity.payment.PstPriceType;
import com.dimata.common.entity.payment.PriceType;
import com.dimata.common.entity.payment.PstCurrencyType;
import com.dimata.common.entity.payment.CurrencyType;
import com.dimata.common.entity.payment.StandartRate;
import com.dimata.common.entity.payment.PstStandartRate;
import com.dimata.common.entity.location.Location;

public class CtrlMaterial extends Control implements I_Language {
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_DELETE_RESTRICT = 4;

    // ini untuk membedakan material
    // untuk hanoman,material sendiri, atau yang lain
    public int DESIGN_MATERIAL_FOR = DESIGN_HANOMAN;
    public static int DESIGN_MATERIAL = 0;
    public static int DESIGN_HANOMAN = 1;

    public static String[][] resultText = {
        {"Berhasil ...", "Tidak dapat diproses ...", "Kode material sudah ada ...", "Data tidak lengkap ...", "Material tidak bisa dihapus, masih dipakai modul lain ..."},
        {"Succes ...", "Can not process ...", "Material code already exist ...", "Data incomplate ...", "Cannot delete, material still used by another module"}
    };

    private int start;
    private String msgString;
    private Material material;
    private PstMaterial pstMaterial;
    private FrmMaterial frmMaterial;
    private Vector listPriceMapping = new Vector(1, 1);
    private Vector listDiscountMapping = new Vector(1, 1);
    int language = LANGUAGE_DEFAULT;
    private HttpServletRequest req;

    public CtrlMaterial(HttpServletRequest request) {
        msgString = "";
        material = new Material();
        try {
            pstMaterial = new PstMaterial(0);
        } catch (Exception e) {
            ;
        }
        req = request;
        frmMaterial = new FrmMaterial(request, material);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmMaterial.addError(frmMaterial.FRM_FIELD_MATERIAL_ID, resultText[language][RSLT_CODE_EXIST]);
                return resultText[language][RSLT_CODE_EXIST];
            case I_DBExceptionInfo.DEL_RESTRICTED:
                return resultText[language][RSLT_DELETE_RESTRICT];

            default:
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }

    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                return RSLT_CODE_EXIST;
            case I_DBExceptionInfo.DEL_RESTRICTED:
                return RSLT_DELETE_RESTRICT;

            default:
                return RSLT_UNKNOWN_ERROR;
        }
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public Material getMaterial() {
        return material;
    }

    public FrmMaterial getForm() {
        return frmMaterial;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public void setListPriceMapping(Vector result) {
        this.listPriceMapping = result;
    }

    public Vector getListPriceMapping() {
        return this.listPriceMapping;
    }

    public void setListDiscountMapping(Vector result) {
        this.listDiscountMapping = result;
    }

    public Vector getListDiscountMapping() {
        return this.listDiscountMapping;
    }

    public int action(int cmd, long oidMaterial) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;

        // proses men set program yang untk hanoman / material sendiri.
        try {
            String designMat = String.valueOf(PstSystemProperty.getValueByName("DESIGN_MATERIAL_FOR"));
            DESIGN_MATERIAL_FOR = Integer.parseInt(designMat);
        } catch (Exception e) {
        }
        // - selesai

        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidMaterial != 0) {
                    try {
                        material = PstMaterial.fetchExc(oidMaterial);
                    } catch (Exception exc) {
                    }
                }

                frmMaterial.requestEntityObject(material);
                //System.out.println("isi dari item type"+material.getItemType());
                material.setLastUpdate(new Date());

                if (frmMaterial.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                /**
                 * ini di gunakan untuk proses penggabungan category dan merk
                 * jika type switch nya automatic
                 */
                String goodName = material.getName();
                if (material.getMaterialSwitchType() == Material.WITH_USE_SWITCH_MERGE_AUTOMATIC) {
                    try {
                        Merk merk = PstMerk.fetchExc(material.getMerkId());
                        goodName = merk.getName() + Material.getSeparate() + goodName;
                    } catch (Exception e) {
                    }
                    try {
                        Category categ = PstCategory.fetchExc(material.getCategoryId());
                        goodName = categ.getName() + Material.getSeparate() + goodName;
                    } catch (Exception e) {
                    }
                }
                material.setName(goodName);
                // end ------------------

                if (material.getOID() == 0) {
                    try {
                        long oid = pstMaterial.insertExc(this.material);

                        // integrasi data material dengan
                        // data yang ada di hanoman
                        if (DESIGN_MATERIAL_FOR == DESIGN_HANOMAN) {
                            if (oid != 0) {
                                goodName = material.getName();
                                if (material.getMaterialSwitchType() == Material.WITH_USE_SWITCH_MERGE_AUTOMATIC) {
                                    String forDiff = "";
                                    try {
                                        Merk merk = PstMerk.fetchExc(material.getMerkId());
                                        forDiff = merk.getName() + Material.getSeparate();
                                    } catch (Exception e) {
                                    }
                                    try {
                                        Category categ = PstCategory.fetchExc(material.getCategoryId());
                                        forDiff = categ.getName() + Material.getSeparate() + forDiff;
                                    } catch (Exception e) {
                                    }
                                    try {
                                        goodName = goodName.substring(forDiff.length(), goodName.length());
                                    } catch (Exception e) {
                                    }
                                }


                                CatalogLink clink = new CatalogLink();
                                clink.setCatalogId(oid);
                                clink.setName(goodName);
                                clink.setItemCategoryId(material.getCategoryId());

                                clink.setPriceRp(material.getDefaultPrice());
                                clink.setPriceUsd(0);

                                clink.setCostRp(material.getDefaultCost());
                                clink.setCostUsd(0);

                                clink.setDescription("");
                                clink.setCode(material.getSku());
                                clink.setStores(new Vector(1, 1));

                                //System.out.println("clink.getCatalogId() : "+clink.getCatalogId());
                                //System.out.println("clink.setName : "+clink.getName());
                                //System.out.println("clink.setCode : "+clink.getCode());
                                //System.out.println("clink.setStores : "+clink.getStores());

                                I_Catalog i_catalog = (I_Catalog) Class.forName(I_Catalog.classNameHanoman).newInstance();
                                i_catalog.insertCatalog(clink);
                            }
                            //----- end
                        }

                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }

                } else {
                    try {
                        long oid = pstMaterial.updateExc(this.material);

                        if (DESIGN_MATERIAL_FOR == DESIGN_HANOMAN) {
                            //integrasi POS to BO
                            if (oid != 0) {
                                goodName = material.getName();
                                if (material.getMaterialSwitchType() == Material.WITH_USE_SWITCH_MERGE_AUTOMATIC) {
                                    String forDiff = "";
                                    try {
                                        Merk merk = PstMerk.fetchExc(material.getMerkId());
                                        forDiff = merk.getName() + Material.getSeparate();
                                    } catch (Exception e) {
                                    }
                                    try {
                                        Category categ = PstCategory.fetchExc(material.getCategoryId());
                                        forDiff = categ.getName() + Material.getSeparate() + forDiff;
                                    } catch (Exception e) {
                                    }
                                    try {
                                        goodName = goodName.substring(forDiff.length(), goodName.length());
                                    } catch (Exception e) {
                                    }
                                }

                                CatalogLink clink = new CatalogLink();
                                clink.setCatalogId(oid);
                                clink.setName(goodName);
                                clink.setItemCategoryId(material.getCategoryId());

                                clink.setPriceRp(material.getDefaultPrice());
                                clink.setPriceUsd(0);

                                clink.setCostRp(material.getDefaultCost());
                                clink.setCostUsd(0);

                                clink.setDescription("");
                                clink.setCode(material.getSku());
                                clink.setStores(new Vector(1, 1));

                                // System.out.println("clink.getCatalogId() : " + clink.getCatalogId());
                                // System.out.println("clink.setName : " + clink.getName());
                                // System.out.println("clink.setCode : " + clink.getCode());
                                // System.out.println("clink.setStores : " + clink.getStores());

                                I_Catalog i_catalog = (I_Catalog) Class.forName(I_Catalog.classNameHanoman).newInstance();
                                i_catalog.updateCatalog(clink);
                            }
                            //----- end
                        }

                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidMaterial != 0) {
                    try {
                        material = PstMaterial.fetchExc(oidMaterial);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidMaterial != 0) {
                    try {
                        material = PstMaterial.fetchExc(oidMaterial);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidMaterial != 0) {
                    try {
                        long oid = PstMaterial.deleteExc(oidMaterial);

                        if (DESIGN_MATERIAL_FOR == DESIGN_HANOMAN) {
                            //
                            CatalogLink clink = new CatalogLink();
                            clink.setCatalogId(oidMaterial);
                            clink.setName(material.getName());
                            clink.setItemCategoryId(material.getCategoryId());
                            clink.setPriceRp(material.getDefaultPrice());
                            clink.setPriceUsd(0);
                            clink.setCostRp(material.getDefaultCost());
                            clink.setCostUsd(0);
                            clink.setDescription("");
                            clink.setCode(material.getSku());
                            clink.setStores(new Vector(1, 1));
                            I_Catalog i_catalog = (I_Catalog) Class.forName(I_Catalog.classNameHanoman).newInstance();
                            i_catalog.deleteCatalog(clink);
                        }

                        if (oid != 0) {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            default :

        }
        return rsCode;
    }

    public int action(int cmd, long oidMaterial, Vector vectDataPrice, Vector vectDataDisc, Vector locations) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;

        // proses men set program yang untk hanoman / material sendiri.
        try {
            String designMat = String.valueOf(PstSystemProperty.getValueByName("DESIGN_MATERIAL_FOR"));
            DESIGN_MATERIAL_FOR = Integer.parseInt(designMat);
        } catch (Exception e) {
        }

        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                try{
                    PstMaterialStock.refreshCatalogStock();
                }catch(Exception exc){
                    System.out.println(exc);
                }
                if (oidMaterial != 0) {
                    try {
                        material = PstMaterial.fetchExc(oidMaterial);
                    } catch (Exception exc) {
                    }
                }

                frmMaterial.requestEntityObject(material);
                material.setLastUpdate(new Date());

                /**
                 * ini pengecekan bila oid unit tidak ada
                 * karena oid unit harus ada
                 */
                if(material.getDefaultStockUnitId() == 0){
                    long oidUnit = PstUnit.getOidUnit();
                    material.setDefaultStockUnitId(oidUnit);
                    material.setBuyUnitId(oidUnit);
                    /*try{
                        String sql = "UPDATE "+PstMaterial.TBL_MATERIAL+" SET "+PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID]+"="+oidUnit+
                                " , "+PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID]+"="+oidUnit;
                        DBHandler.execUpdate(sql);
                    }catch(Exception e){} */
                }

                if (frmMaterial.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                /**
                 * ini di gunakan untuk proses penggabungan category dan merk
                 * jika type switch nya automatic
                 */
                String goodName = material.getName();
                if (material.getMaterialSwitchType() == Material.WITH_USE_SWITCH_MERGE_AUTOMATIC) {
                    try {
                        Merk merk = PstMerk.fetchExc(material.getMerkId());
                        goodName = merk.getName() + Material.getSeparate() + goodName;
                    } catch (Exception e) {}
                    try {
                        Category categ = PstCategory.fetchExc(material.getCategoryId());
                        goodName = categ.getName() + Material.getSeparate() + goodName;
                    } catch (Exception e) {}
                }
                material.setName(goodName);
                // end ------------------

                boolean isInsert = true;
                if (material.getOID() == 0) {
                    isInsert = true;
                    try {
                        material.setProses(Material.IS_PROCESS_INSERT_UPDATE);
                        long oid = pstMaterial.insertExc(this.material);
                        oidMaterial = oid;

                        // digunakan untuk mengupdate data yang
                        // ada di hanoman material
                        if (DESIGN_MATERIAL_FOR == DESIGN_HANOMAN) {
                            PstMaterial.insertOutlet(locations, oid);
                        }
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                } else {
                    isInsert = false;
                    try {
                        material.setProses(Material.IS_PROCESS_INSERT_UPDATE);
                        material.setProcessStatus(PstMaterial.UPDATE);
                        long oid = pstMaterial.updateExc(this.material);

                        // digunakan untuk mengupdate data yang
                        // ada di hanoman material
                        if (DESIGN_MATERIAL_FOR == DESIGN_HANOMAN) {
                            PstMaterial.updateOutlet(locations, oid);
                        }
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                CatalogLink clink = new CatalogLink();
                //integrasi POS to BO
                if (material.getOID() != 0) {
                    goodName = material.getName();
                    if (material.getMaterialSwitchType() == Material.WITH_USE_SWITCH_MERGE_AUTOMATIC) {
                        String forDiff = "";
                        if (material.getMaterialSwitchType() == Material.WITH_USE_SWITCH_MERGE_AUTOMATIC) {
                            try {
                                Merk merk = PstMerk.fetchExc(material.getMerkId());
                                forDiff = merk.getName() + Material.getSeparate();
                            } catch (Exception e) {
                            }
                            try {
                                Category categ = PstCategory.fetchExc(material.getCategoryId());
                                forDiff = categ.getName() + Material.getSeparate() + forDiff;
                            } catch (Exception e) {
                            }
                        }
                        try {
                            goodName = goodName.substring(forDiff.length(), goodName.length());
                        } catch (Exception e) {
                        }
                    }

                    if (DESIGN_MATERIAL_FOR == DESIGN_HANOMAN) {

                        clink.setCatalogId(material.getOID());
                        clink.setName(goodName);
                        clink.setItemCategoryId(material.getCategoryId());

                        clink.setCostRp(material.getDefaultCost());
                        clink.setCostUsd(0);

                        clink.setDescription("");
                        clink.setCode(material.getSku());
                        clink.setStores(locations);
                    }
                }
                //----- end
                System.out.println(" oidMaterial >>>>>>>> : "+oidMaterial);
                /* manipulate price mapping */
                if (oidMaterial != 0) {
                    if (vectDataPrice != null && vectDataPrice.size() > 0) {
                        for (int i = 0; i < vectDataPrice.size(); i++) {
                            Vector vect = (Vector) vectDataPrice.get(i);
                            if (vect != null && vect.size() > 0) {
                                for (int j = 0; j < vect.size(); j++) {
                                    Vector vect2 = (Vector) vect.get(j);
                                    if (vect2 != null && vect2.size() == 3) {
                                        long oidPrice = 0L;
                                        try{oidPrice = Long.parseLong((String) vect2.get(0));} catch(Exception exc){;}
                                        double value = 0.0d;
                                        try{value=Double.parseDouble((String) vect2.get(1));} catch(Exception exc){;}
                                        long oidStandard = 0;
                                        try{oidStandard = Long.parseLong((String) vect2.get(2));} catch(Exception exc){;}
                                        PriceTypeMapping priceTypeMap = new PriceTypeMapping();
                                        if (value > 0) {
                                            priceTypeMap.setPrice(value);
                                            priceTypeMap.setPriceTypeId(oidPrice);
                                            priceTypeMap.setStandartRateId(oidStandard);
                                            priceTypeMap.setMaterialId(oidMaterial);

                                            // ini proses pengecekan jika ada integrasi dengan hanoman
                                            if (DESIGN_MATERIAL_FOR == DESIGN_HANOMAN) {
                                                // ================================================
                                                // Integration between POS & BO -- Eka
                                                // default price type
                                                String strInit = PstSystemProperty.getValueByName("INTEGRATION_PRICE_MAP");
                                                String where = PstPriceType.fieldNames[PstPriceType.FLD_CODE] + "='" + strInit + "'";
                                                long oidPrcType = 0;
                                                Vector vct = PstPriceType.list(0, 0, where, null);
                                                if (vct != null && vct.size() > 0) {
                                                    PriceType pt = (PriceType) vct.get(0);
                                                    oidPrcType = pt.getOID();
                                                }

                                                if (oidPrcType == oidPrice) {
                                                    //default IDR ambil dari master,
                                                    strInit = PstSystemProperty.getValueByName("INTEGRATION_CURR_RP");
                                                    where = PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE] + "='" + strInit + "'";
                                                    long oidRp = 0;
                                                    vct = PstCurrencyType.list(0, 0, where, null);
                                                    if (vct != null && vct.size() > 0) {
                                                        CurrencyType unit = (CurrencyType) vct.get(0);
                                                        oidRp = unit.getOID();
                                                    }
                                                    StandartRate stRateRp = PstStandartRate.getActiveStandardRate(oidRp);
                                                    if (stRateRp.getOID() == oidStandard) {
                                                        clink.setPriceRp(value);
                                                    }

                                                    //default USD ambil dari master
                                                    strInit = PstSystemProperty.getValueByName("INTEGRATION_CURR_USD");
                                                    where = PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE] + "='" + strInit + "'";
                                                    long oidUsd = 0;
                                                    vct = PstCurrencyType.list(0, 0, where, null);
                                                    if (vct != null && vct.size() > 0) {
                                                        CurrencyType unit = (CurrencyType) vct.get(0);
                                                        oidUsd = unit.getOID();
                                                    }
                                                    StandartRate stRateUsd = PstStandartRate.getActiveStandardRate(oidUsd);
                                                    if (stRateUsd.getOID() == oidStandard) {
                                                        clink.setPriceUsd(value);
                                                    }
                                                }
                                                //end integration
                                                //==========================================================
                                            }

                                            boolean checkOID = PstPriceTypeMapping.checkOID(priceTypeMap.getPriceTypeId(), priceTypeMap.getMaterialId(), priceTypeMap.getStandartRateId());
                                            if (checkOID) {
                                                try {
                                                    PstPriceTypeMapping.updateExc(priceTypeMap);
                                                } catch (Exception err) {
                                                    err.printStackTrace();
                                                    System.out.println("errr>>>>>>>>>>> update mapping : " + err.toString());
                                                }
                                            } else {
                                                try {
                                                    PstPriceTypeMapping.insertExc(priceTypeMap);
                                                } catch (Exception err) {
                                                    err.printStackTrace();
                                                    System.out.println("errr>>>>>>>>>>> insert mapping : " + err.toString());
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    setListPriceMapping(oidMaterial);
                }


                if (DESIGN_MATERIAL_FOR == DESIGN_HANOMAN) {
                    //integration between BO and POS
                    try {
                        if (isInsert) {
                            /*System.out.println("-");
                            System.out.println("-");
                            System.out.println("Inserting catalog to hanoman ...");
                            System.out.println("clink.getCatalogId() : " + clink.getCatalogId());
                            System.out.println("clink.setName : " + clink.getName());
                            System.out.println("clink.setCode : " + clink.getCode());
                            System.out.println("clink.setStores : " + clink.getStores());
                            System.out.println("clink.getPriceRp : " + clink.getPriceRp());
                            System.out.println("clink.getPriceUsd : " + clink.getPriceUsd()); */

                            I_Catalog i_catalog = (I_Catalog) Class.forName(I_Catalog.classNameHanoman).newInstance();

                            // System.out.println("i_catalog : " + i_catalog);

                            i_catalog.insertCatalog(clink);

                            // System.out.println("----> iserting catalog success");
                        } else {
                            /* System.out.println("-");
                            System.out.println("-");
                            System.out.println("updating catalog on hanoman ...");
                            System.out.println("clink.getCatalogId() : " + clink.getCatalogId());
                            System.out.println("clink.setName : " + clink.getName());
                            System.out.println("clink.setCode : " + clink.getCode());
                            System.out.println("clink.setStores : " + clink.getStores());
                            System.out.println("clink.getPriceRp : " + clink.getPriceRp());
                            System.out.println("clink.getPriceUsd : " + clink.getPriceUsd()); */

                            I_Catalog i_catalog = (I_Catalog) Class.forName(I_Catalog.classNameHanoman).newInstance();

                            // System.out.println("i_catalog : " + i_catalog);

                            i_catalog.updateCatalog(clink);
                        }

                        //System.out.println("----> end process inserting catalog ");

                    } catch (Exception e) {
                        System.out.println("Exception exx :" + e.toString());
                    }
                    //==============================
                }

                /* manupalate data discount */
                if (oidMaterial != 0) {
                    if (vectDataDisc != null && vectDataDisc.size() > 0) {
                        for (int i = 0; i < vectDataDisc.size(); i++) {
                            Vector vect = (Vector) vectDataDisc.get(i);
                            for (int j = 0; j < vect.size(); j++) {
                                Vector vect2 = (Vector) vect.get(j);
                                long oidDiscType = 0;
                                try{oidDiscType = Long.parseLong((String) vect2.get(0));}catch(Exception exc){}
                                long oidCurrType = 0;
                                try{oidCurrType = Long.parseLong((String) vect2.get(1));}catch(Exception exc){}
                                double valuePct = 0;
                                try{valuePct=Double.parseDouble((String) vect2.get(2));}catch(Exception exc){}                                
                                double value = 0;
                                try{value = Double.parseDouble((String) vect2.get(3));}catch(Exception exc){}
                                DiscountMapping discMapping = new DiscountMapping();
                                discMapping.setCurrencyTypeId(oidCurrType);
                                discMapping.setDiscountPct(valuePct);
                                discMapping.setDiscountTypeId(oidDiscType);
                                discMapping.setDiscountValue(value);
                                discMapping.setMaterialId(oidMaterial);

                                boolean checkOID = PstDiscountMapping.checkOID(oidDiscType, oidMaterial, oidCurrType);
                                if (!checkOID) {
                                    try {
                                        PstDiscountMapping.insertExc(discMapping);
                                    } catch (Exception err) {
                                        err.printStackTrace();
                                        System.out.println("err di insert to disc mapping " + err.toString());
                                    }
                                } else {
                                    try {
                                        PstDiscountMapping.updateExc(discMapping);
                                    } catch (Exception err) {
                                        err.printStackTrace();
                                        System.out.println("err di update to disc mapping " + err.toString());
                                    }
                                }
                            }
                        }
                    }
                    setListDiscMapping(oidMaterial);
                }

                break;

            case Command.EDIT:
                if (oidMaterial != 0) {
                    try {
                        material = PstMaterial.fetchExc(oidMaterial);
                        setListPriceMapping(oidMaterial);
                        setListDiscMapping(oidMaterial);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidMaterial != 0) {
                    try {
                        material = PstMaterial.fetchExc(oidMaterial);
                        setListPriceMapping(oidMaterial);
                        setListDiscMapping(oidMaterial);
                      
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidMaterial != 0) {
                    try {
                        long oid = 0; //PstMaterial.deleteExc(oidMaterial);
                        material = PstMaterial.fetchExc(oidMaterial);
                        if (SessMaterial.readyDataToDelete(oidMaterial)) {
                            material.setBarCode("" + oidMaterial);
                            material.setSku("" + oidMaterial);
                            material.setProcessStatus(PstMaterial.DELETE);
                            material.setLastUpdate(new Date());
                            oid = PstMaterial.updateExc(material);
                            PstDiscountMapping.deleteByMaterialId(oidMaterial);
                            PstPriceTypeMapping.deleteByMaterialId(oidMaterial);
                            //delete Disc Qty
                            PstDiscountQtyMapping.deleteByMaterialId(oidMaterial);

                            if (DESIGN_MATERIAL_FOR == DESIGN_HANOMAN) {
                                //
                                clink = new CatalogLink();
                                clink.setCatalogId(oidMaterial);
                                clink.setName(material.getName());
                                clink.setItemCategoryId(material.getCategoryId());
                                clink.setPriceRp(material.getDefaultPrice());
                                clink.setPriceUsd(0);
                                clink.setCostRp(material.getDefaultCost());
                                clink.setCostUsd(0);
                                clink.setDescription("");
                                clink.setCode(material.getSku());
                                clink.setStores(new Vector(1, 1));
                                I_Catalog i_catalog = (I_Catalog) Class.forName(I_Catalog.classNameHanoman).newInstance();
                                i_catalog.deleteCatalog(clink);
                            }
                        }
                        if (oid != 0) {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            setListPriceMapping(oidMaterial);
                            setListDiscMapping(oidMaterial);
                            frmMaterial.addError(FrmMaterial.FRM_FIELD_MATERIAL_ID, "");
                            msgString = "Hapus data gagal, Data sudah pernah di pakai untuk transaksi."; //FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            default :
                setListPriceMapping(oidMaterial);
                setListDiscMapping(oidMaterial);
                break;

        }
        return excCode;
    }

    public void setListPriceMapping(long oidMaterial) {
        String wh = PstPriceTypeMapping.fieldNames[PstPriceTypeMapping.FLD_MATERIAL_ID] + " = " + oidMaterial;
        listPriceMapping = PstPriceTypeMapping.list(0, 0, wh, "");
        setListPriceMapping(listPriceMapping);
    }

    public void setListDiscMapping(long oidMaterial) {
        String wh = PstDiscountMapping.fieldNames[PstDiscountMapping.FLD_MATERIAL_ID] + " = " + oidMaterial;
        listDiscountMapping = PstDiscountMapping.list(0, 0, wh, "");
        setListDiscountMapping(listDiscountMapping);
    }

    /**
     * ini di gunakan untuk men set data minimum stok
     * per location
     */
    public void setMinimumStockPerLocation(Vector vLocation, long materialId, long periodeId) {
        try {
            if (vLocation != null && vLocation.size() > 0) {
                for (int k = 0; k < vLocation.size(); k++) {
                    Location location = (Location) vLocation.get(k);
                    double minQty = FRMQueryString.requestDouble(req, "" + location.getOID() + "");
                    System.out.println("minQty : "+minQty);
                    long oidMatStock = PstMaterialStock.fetchByMaterialLocation(materialId, location.getOID());
                    if (oidMatStock != 0) {
                        MaterialStock materialStock = PstMaterialStock.fetchExc(oidMatStock);
                        materialStock.setQtyMin(minQty);
                        try {
                            PstMaterialStock.updateExc(materialStock);
                        } catch (Exception e) {
                        }
                    } else {
                        MaterialStock materialStock = new MaterialStock();
                        materialStock.setQtyMin(minQty);
                        materialStock.setPeriodeId(periodeId);
                        materialStock.setMaterialUnitId(materialId);
                        materialStock.setLocationId(location.getOID());
                        try {
                            PstMaterialStock.insertExc(materialStock);
                        } catch (Exception e) {
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Err save minim stock : " + e.toString());
        }
    }


    /** gadnyana
     * ini di gunakan untuk insert  data material yang dengan link
     * ke hanoman, data yang di dapat dari upload dari excel
     */
    public static void insertCatalogManual(long oidMaterial, Vector locations){
        try{
            Material material = PstMaterial.fetchExc(oidMaterial);

            // ini untuk link ke hanoman
            CatalogLink clink = new CatalogLink();
            clink.setCatalogId(oidMaterial);
            clink.setName(material.getName());
            clink.setItemCategoryId(material.getCategoryId());
            clink.setCostRp(material.getDefaultCost());
            clink.setCostUsd(0);
            clink.setDescription("");
            clink.setCode(material.getSku());
            clink.setStores(locations);

            I_Catalog i_catalog = (I_Catalog) Class.forName(I_Catalog.classNameHanoman).newInstance();
            i_catalog.insertCatalog(clink);

        }catch(Exception e){
            System.out.println("");
        }
    }

    public static void updateCatalogPriceManual(long oidMaterial,double price){
        try{
            Material material = PstMaterial.fetchExc(oidMaterial);

            // ini untuk link ke hanoman
            CatalogLink clink = new CatalogLink();
            clink.setCatalogId(material.getOID());
            clink.setName(material.getName());
            clink.setItemCategoryId(material.getCategoryId());
            clink.setCostRp(material.getDefaultCost());
            clink.setCostUsd(0);
            clink.setDescription("");
            clink.setCode(material.getSku());
            clink.setPriceRp(price);

            I_Catalog i_catalog = (I_Catalog) Class.forName(I_Catalog.classNameHanoman).newInstance();
            i_catalog.updateCatalog(clink);

        }catch(Exception e){
            System.out.println("");
        }
    }

}
