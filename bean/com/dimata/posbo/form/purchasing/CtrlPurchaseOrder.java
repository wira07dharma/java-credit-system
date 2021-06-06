package com.dimata.posbo.form.purchasing;

/* java package */

import java.util.*;
import javax.servlet.http.*;

import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.entity.*;
import com.dimata.qdep.form.*;
import com.dimata.posbo.db.*;
import com.dimata.posbo.entity.purchasing.*;
import com.dimata.posbo.form.purchasing.*;
import com.dimata.posbo.session.purchasing.*;

public class CtrlPurchaseOrder extends Control implements I_Language {
    public static final String className = I_DocType.DOCTYPE_CLASSNAME;
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;

    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
    };

    private int start;
    private String msgString;
    private PurchaseOrder po;
    private PstPurchaseOrder pstpo;
    private FrmPurchaseOrder frmpo;
    int language = LANGUAGE_DEFAULT;

    public CtrlPurchaseOrder(HttpServletRequest request) {
        msgString = "";
        po = new PurchaseOrder();
        try {
            pstpo = new PstPurchaseOrder(0);
        } catch (Exception e) {
            ;
        }
        //po=po-2;
        frmpo = new FrmPurchaseOrder(request, po);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmpo.addError(frmpo.FRM_FIELD_PURCHASE_ORDER_ID, resultText[language][RSLT_EST_CODE_EXIST]);
                return resultText[language][RSLT_EST_CODE_EXIST];
            default:
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }

    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                return RSLT_EST_CODE_EXIST;
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

    public PurchaseOrder getPurchaseOrder() {
        return po;
    }

    public FrmPurchaseOrder getForm() {
        return frmpo;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPurchaseOrder) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        int prMaterialType = -1;
        try {
            I_PstDocType i_pstDocType = (I_PstDocType) Class.forName(className).newInstance();
            prMaterialType = i_pstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL, I_DocType.MAT_DOC_TYPE_POR);
        } catch (Exception e) {
            System.out.println("Error action Order Material");
        }
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                boolean incrementAllPrType = true;
                Date purchDate = null;
                int counter = 0;
                int st = 0;
                PurchaseOrder prevPo = null;
                if (oidPurchaseOrder != 0) {
                    try {
                        po = PstPurchaseOrder.fetchExc(oidPurchaseOrder);
                        purchDate = po.getPurchDate();
                        counter = po.getPoCodeCounter();
                        st = po.getPoStatus();
                    } catch (Exception exc) {
                    }
                    try {
                        prevPo = PstPurchaseOrder.fetchExc(oidPurchaseOrder);
                    } catch (Exception exc) {
                    }
                }

                frmpo.requestEntityObject(po);

                if (oidPurchaseOrder == 0) {
                    po.setPoCodeCounter(SessPurchaseOrder.getIntCode(po, purchDate, oidPurchaseOrder, counter, incrementAllPrType));
                    po.setPoCode(SessPurchaseOrder.getCodeOrderMaterial(po));
                } else {
                    if(prevPo.getLocationId()== po.getLocationId()){
                    po.setPoCodeCounter(po.getPoCodeCounter());
                    po.setPoCode(SessPurchaseOrder.getCodeOrderMaterial(po)); // po.getPoCode()
                    } else {
                    po.setPoCodeCounter(SessPurchaseOrder.getIntCode(po, purchDate, oidPurchaseOrder, counter, incrementAllPrType));
                    po.setPoCode(SessPurchaseOrder.getCodeOrderMaterial(po));                        
                    }

                    // ini proses yang di gunakan untuk nomor PO yang di revisi
                    if(po.getCodeRevisi().length()>0){
                        po.setPoCode(po.getPoCode()+"-"+po.getCodeRevisi());
                    }
                }


                if (frmpo.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (po.getOID() == 0) {
                    try {
                        long oid = pstpo.insertExc(this.po);
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
                        long oid = pstpo.updateExc(this.po);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.EDIT:
                if (oidPurchaseOrder != 0) {
                    try {
                        po = PstPurchaseOrder.fetchExc(oidPurchaseOrder);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidPurchaseOrder != 0) {
                    try {
                        po = PstPurchaseOrder.fetchExc(oidPurchaseOrder);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidPurchaseOrder != 0) {
                    try {
                        PstPurchaseOrderItem.deleteByPurchaseOrder(oidPurchaseOrder);
                        long oid = PstPurchaseOrder.deleteExc(oidPurchaseOrder);
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
