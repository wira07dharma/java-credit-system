/*
 * CtrlCashMaster.java
 *
 * Created on January 8, 2004, 9:53 AM
 */
package com.dimata.pos.form.billing;

/**
 *
 * @author  gedhy
 */
// java package  
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 

// dimata package 
import com.dimata.util.*;
import com.dimata.util.lang.*;

// qdep package 
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*; 
//import com.dimata.qdep.db.*;

// project package 
import com.dimata.pos.entity.masterCashier.*;
import com.dimata.pos.entity.billing.*;
import com.dimata.pos.db.*;

public class CtrlBillMain extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;

    public static String[][] resultText
            = {
                {"Berhasil", "Tidak dapat diproses", "Code Material Sales sudah ada", "Data tidak lengkap"},
                {"Succes", "Can not process", "Material Sales Code already exist", "Data incomplete"}
            };

    private int start;
    private String msgString;
    private BillMain billMain;
    private PstBillMain pstBillMain;
    private FrmBillMain frmBillMain;
    int language = LANGUAGE_FOREIGN;

    public CtrlBillMain(HttpServletRequest request) {
        msgString = "";
        billMain = new BillMain();
        try {
            pstBillMain = new PstBillMain(0);
        } catch (Exception e) {;
        }
        frmBillMain = new FrmBillMain(request, billMain);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmBillMain.addError(frmBillMain.FRM_FIELD_CASH_BILL_MAIN_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public BillMain getBillMain() {
        return billMain;
    }

    public FrmBillMain getForm() {
        return frmBillMain;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidBillMain) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidBillMain != 0) {
                    try {
                        billMain = PstBillMain.fetchExc(oidBillMain);
                    } catch (Exception exc) {
                    }
                }

                frmBillMain.requestEntityObject(billMain);

                if (frmBillMain.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (billMain.getOID() == 0) {
                    try {
                        long oid = pstBillMain.insertExc(this.billMain);
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
                        long oid = pstBillMain.updateExc(this.billMain);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidBillMain != 0) {
                    try {
                        billMain = PstBillMain.fetchExc(oidBillMain);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidBillMain != 0) {
                    try {
                        billMain = PstBillMain.fetchExc(oidBillMain);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidBillMain != 0) {
                    try {
                        long oid = PstBillMain.deleteExc(oidBillMain);
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

            default:

        }
        return rsCode;
    }

}
