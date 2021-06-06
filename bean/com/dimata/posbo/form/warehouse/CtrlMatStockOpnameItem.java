package com.dimata.posbo.form.warehouse;

import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.entity.masterdata.Material;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.qdep.entity.I_DocStatus;
import com.dimata.posbo.db.DBException;
import com.dimata.posbo.session.warehouse.SessReportSale;
import com.dimata.util.lang.I_Language;
import com.dimata.util.Command;
import com.dimata.pos.entity.billing.PstBillMain;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;

public class CtrlMatStockOpnameItem extends Control implements I_Language {
    public static final int RSLT_OK = 0;
    public static final int RSLT_UNKNOWN_ERROR = 1;
    public static final int RSLT_MATERIAL_EXIST = 2;
    public static final int RSLT_FORM_INCOMPLETE = 3;
    public static final int RSLT_QTY_NULL = 4;
    
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "Barang sudah ada", "Data tidak lengkap", "Jumlah barang tidak boleh kurang dari nol ..."},
        {"Succes", "Can not process", "Material already exist ...", "Data incomplete", "Quantity may not zero ..."}
    };
    
    private int start;
    private String msgString;
    private MatStockOpnameItem matStockOpnameItem;
    private PstMatStockOpnameItem pstMatStockOpnameItem;
    private FrmMatStockOpnameItem frmMatStockOpnameItem;
    int language = LANGUAGE_DEFAULT;
    
    // gadnyana
    // item opname in vector
    private Vector vectItemOpname;
    // type insert opname, vector or one by one
    public static final int INPUT_ONE_BY_ONE = 0;
    public static final int INPUT_ONE_BY_VECTOR = 1;
    private int opt_opname = INPUT_ONE_BY_ONE;
    
    public void setVectOptOpname(int opt, Vector vect){
        this.vectItemOpname = vect;
        this.opt_opname = opt;
    }
    
    public Vector getVectOpname(){
        return this.vectItemOpname;
    }
    
    //---------
    
    public CtrlMatStockOpnameItem() {
    }
    
    public CtrlMatStockOpnameItem(HttpServletRequest request) {
        msgString = "";
        matStockOpnameItem = new MatStockOpnameItem();
        try {
            pstMatStockOpnameItem = new PstMatStockOpnameItem(0);
        } catch (Exception e) {
            ;
        }
        frmMatStockOpnameItem = new FrmMatStockOpnameItem(request, matStockOpnameItem);
    }
    
    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case RSLT_MATERIAL_EXIST:
                this.frmMatStockOpnameItem.addError(frmMatStockOpnameItem.FRM_FIELD_MATERIAL_ID, resultText[language][RSLT_MATERIAL_EXIST]);
                return resultText[language][RSLT_MATERIAL_EXIST];
            case RSLT_QTY_NULL:
                this.frmMatStockOpnameItem.addError(frmMatStockOpnameItem.FRM_FIELD_QTY_OPNAME, resultText[language][RSLT_QTY_NULL]);
                return resultText[language][RSLT_QTY_NULL];
            default :
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }
    
    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case RSLT_MATERIAL_EXIST:
                return RSLT_MATERIAL_EXIST;
            case RSLT_QTY_NULL:
                return RSLT_QTY_NULL;
            default :
                return RSLT_UNKNOWN_ERROR;
        }
    }
    
    public int getLanguage() {
        return language;
    }
    
    public void setLanguage(int language) {
        this.language = language;
    }
    
    public MatStockOpnameItem getMatStockOpnameItem() {
        return matStockOpnameItem;
    }
    
    public FrmMatStockOpnameItem getForm() {
        return frmMatStockOpnameItem;
    }
    
    public String getMessage() {
        return msgString;
    }
    
    public int getStart() {
        return start;
    }
    
    public int action(int cmd, long oidMatStockOpnameItem, long oidMatStockOpname) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        
        switch (cmd) {
            case Command.ADD:
                break;
                
            case Command.SAVE:
                
                if (oidMatStockOpnameItem != 0) {
                    try {
                        matStockOpnameItem = PstMatStockOpnameItem.fetchExc(oidMatStockOpnameItem);
                    } catch (Exception exc) {
                    }
                }
                
                // insert item for one by one
                if(this.opt_opname==INPUT_ONE_BY_ONE){
                    frmMatStockOpnameItem.requestEntityObject(matStockOpnameItem);
                    // check if current material already exist in orderMaterial
                    if (matStockOpnameItem.getOID() == 0 && PstMatStockOpnameItem.materialExist(matStockOpnameItem.getMaterialId(), oidMatStockOpname)) {
                        msgString = getSystemMessage(RSLT_MATERIAL_EXIST);
                        return getControlMsgId(RSLT_MATERIAL_EXIST);
                    }
                    
                    /**
                     * check if current material already exist in orderMaterial
                     * @created <CODE>by Gedhy</CODE>
                     */
                    if (matStockOpnameItem.getQtyOpname() < 0) {
                        msgString = getSystemMessage(RSLT_QTY_NULL);
                        return getControlMsgId(RSLT_QTY_NULL);
                    }
                    
                    if (frmMatStockOpnameItem.errorSize() > 0) {
                        msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                        return RSLT_FORM_INCOMPLETE;
                    }
                    
                    if (matStockOpnameItem.getOID() == 0) {
                        try {
                            Material material = PstMaterial.fetchExc(matStockOpnameItem.getMaterialId());
                            matStockOpnameItem.setCost(material.getAveragePrice());
                            MatStockOpname matStockOpname = PstMatStockOpname.fetchExc(oidMatStockOpname);
                            matStockOpnameItem.setQtySold(SessReportSale.getQtySale(matStockOpnameItem.getMaterialId(),matStockOpname.getLocationId()));
                            long oid = pstMatStockOpnameItem.insertExc(this.matStockOpnameItem);
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
                            Material material = PstMaterial.fetchExc(matStockOpnameItem.getMaterialId());
                            matStockOpnameItem.setCost(material.getAveragePrice());
                            MatStockOpname matStockOpname = PstMatStockOpname.fetchExc(oidMatStockOpname);
                            matStockOpnameItem.setQtySold(SessReportSale.getQtySale(matStockOpnameItem.getMaterialId(),matStockOpname.getLocationId()));
                            long oid = pstMatStockOpnameItem.updateExc(this.matStockOpnameItem);
                        } catch (DBException dbexc) {
                            excCode = dbexc.getErrorCode();
                            msgString = getSystemMessage(excCode);
                        } catch (Exception exc) {
                            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        }
                    }
                    
                    // input witch vector
                }else{
                    Vector vect = getVectOpname();
                    if(vect!=null && vect.size()>0){
                        for(int k=0;k<vect.size();k++){
                            MatStockOpnameItem matOpnameItem = (MatStockOpnameItem)vect.get(k);
                            try {
                                long oid = pstMatStockOpnameItem.insertExc(matOpnameItem);
                            } catch (DBException dbexc) {
                                excCode = dbexc.getErrorCode();
                                System.out.println("idx :"+k+" > "+getSystemMessage(excCode));
                                //return getControlMsgId(excCode);
                            } catch (Exception exc) {
                                System.out.println("idx :"+k+" > "+getSystemMessage(I_DBExceptionInfo.UNKNOWN));
                                //return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                            }
                        }
                    }else{
                        System.out.println("==> VECTOR IS BLANK, NO ITEM FOR INSERT ;");
                    }
                }
                break;
                
            case Command.EDIT:
                if (oidMatStockOpnameItem != 0) {
                    try {
                        matStockOpnameItem = PstMatStockOpnameItem.fetchExc(oidMatStockOpnameItem);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.ASK:
                if (oidMatStockOpnameItem != 0) {
                    try {
                        matStockOpnameItem = PstMatStockOpnameItem.fetchExc(oidMatStockOpnameItem);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.DELETE:
                if (oidMatStockOpnameItem != 0) {
                    try {
                        long oid = PstMatStockOpnameItem.deleteExc(oidMatStockOpnameItem);
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
}
