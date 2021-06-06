package com.dimata.posbo.form.purchasing;

/* java package */

import javax.servlet.http.*;
/* dimata package */
import com.dimata.util.*;
import com.dimata.util.lang.*;
/* qdep package */
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.posbo.db.*;
/* project package */
import com.dimata.posbo.entity.purchasing.*;

public class CtrlPurchaseOrderItem extends Control implements I_Language {
    public static final int RSLT_OK = 0;
    public static final int RSLT_UNKNOWN_ERROR = 1;
    public static final int RSLT_MATERIAL_EXIST = 2;
    public static final int RSLT_FORM_INCOMPLETE = 3;
    public static final int RSLT_QTY_NULL = 4;
    
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "Material sudah ada", "Data tidak lengkap", "Jumlah material tidak boleh nol ..."},
        {"Succes", "Can not process", "Material already exist ...", "Data incomplete", "Quantity may not zero ..."}
    };
    
    private int start;
    private String msgString;
    private PurchaseOrderItem poItem;
    private PstPurchaseOrderItem pstPoItem;
    private FrmPurchaseOrderItem frmPoItem;
    int language = LANGUAGE_DEFAULT;
    
    public CtrlPurchaseOrderItem() {
    }
    
    public CtrlPurchaseOrderItem(HttpServletRequest request) {
        msgString = "";
        poItem = new PurchaseOrderItem();
        try {
            pstPoItem = new PstPurchaseOrderItem(0);
        } catch (Exception e) {
            ;
        }
        frmPoItem = new FrmPurchaseOrderItem(request, poItem);
    }
    
    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case RSLT_MATERIAL_EXIST:
                this.frmPoItem.addError(frmPoItem.FRM_FIELD_MATERIAL_ID, resultText[language][RSLT_MATERIAL_EXIST]);
                return resultText[language][RSLT_MATERIAL_EXIST];
            case RSLT_QTY_NULL:
                this.frmPoItem.addError(frmPoItem.FRM_FIELD_QUANTITY, resultText[language][RSLT_QTY_NULL]);
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
    
    public PurchaseOrderItem getPurchaseOrderItem() {
        return poItem;
    }
    
    public FrmPurchaseOrderItem getForm() {
        return frmPoItem;
    }
    
    public String getMessage() {
        return msgString;
    }
    
    public int getStart() {
        return start;
    }
    
    public int action(int cmd, long oidPoItem, long oidPurchaseOrder) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;
                
            case Command.SAVE:
                if (oidPoItem != 0) {
                    try {
                        poItem = PstPurchaseOrderItem.fetchExc(oidPoItem);
                    } catch (Exception exc) {
                    }
                }
                
                frmPoItem.requestEntityObject(poItem);
                poItem.setPurchaseOrderId(oidPurchaseOrder);
                
                // check if current material already exist in orderMaterial
                if (poItem.getOID() == 0 && PstPurchaseOrderItem.materialExist(poItem.getMaterialId(), oidPurchaseOrder)) {
                    msgString = getSystemMessage(RSLT_MATERIAL_EXIST);
                    return getControlMsgId(RSLT_MATERIAL_EXIST);
                }
                
                // check if current material already exist in orderMaterial
                if (poItem.getQuantity() == 0) {
                    msgString = getSystemMessage(RSLT_QTY_NULL);
                    return getControlMsgId(RSLT_QTY_NULL);
                }
                
                if (frmPoItem.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (poItem.getOID() == 0) {
                    try {
                        long oid = pstPoItem.insertExc(this.poItem);
                    } catch (DBException dbexc) {
                        System.out.println(dbexc);
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        System.out.println(exc);
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                    
                } else {
                    try {
                        long oid = pstPoItem.updateExc(this.poItem);
                    } catch (DBException dbexc) {
                        System.out.println(dbexc);
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        System.out.println(exc);
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                    
                }
                break;
                
            case Command.EDIT:
                if (oidPoItem != 0) {
                    try {
                        poItem = PstPurchaseOrderItem.fetchExc(oidPoItem);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.ASK:
                if (oidPoItem != 0) {
                    try {
                        poItem = PstPurchaseOrderItem.fetchExc(oidPoItem);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.DELETE:
                if (oidPoItem != 0) {
                    try {
                        long oid = PstPurchaseOrderItem.deleteExc(oidPoItem);
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
