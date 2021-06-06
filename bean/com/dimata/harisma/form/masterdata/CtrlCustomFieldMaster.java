/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Dimata 007
 */
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.masterdata.*;

/*
 Description : Controll CustomFieldMaster
 Date : Wed Jun 10 2015
 Author : Hendra Putu
 */
public class CtrlCustomFieldMaster extends Control implements I_Language {

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
    private CustomFieldMaster entCustomFieldMaster;
    private PstCustomFieldMaster pstCustomFieldMaster;
    private FrmCustomFieldMaster frmCustomFieldMaster;
    int language = LANGUAGE_DEFAULT;

    public CtrlCustomFieldMaster(HttpServletRequest request) {
        msgString = "";
        entCustomFieldMaster = new CustomFieldMaster();
        try {
            pstCustomFieldMaster = new PstCustomFieldMaster(0);
        } catch (Exception e) {;
        }
        frmCustomFieldMaster = new FrmCustomFieldMaster(request, entCustomFieldMaster);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmCustomFieldMaster.addError(frmCustomFieldMaster.FRM_FIELD_CUSTOM_FIELD_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public CustomFieldMaster getCustomFieldMaster() {
        return entCustomFieldMaster;
    }

    public FrmCustomFieldMaster getForm() {
        return frmCustomFieldMaster;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidCustomFieldMaster) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidCustomFieldMaster != 0) {
                    try {
                        entCustomFieldMaster = PstCustomFieldMaster.fetchExc(oidCustomFieldMaster);
                    } catch (Exception exc) {
                    }
                }

                frmCustomFieldMaster.requestEntityObject(entCustomFieldMaster);

                if (frmCustomFieldMaster.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entCustomFieldMaster.getOID() == 0) {
                    try {
                        long oid = pstCustomFieldMaster.insertExc(this.entCustomFieldMaster);
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
                        long oid = pstCustomFieldMaster.updateExc(this.entCustomFieldMaster);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidCustomFieldMaster != 0) {
                    try {
                        entCustomFieldMaster = PstCustomFieldMaster.fetchExc(oidCustomFieldMaster);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidCustomFieldMaster != 0) {
                    try {
                        entCustomFieldMaster = PstCustomFieldMaster.fetchExc(oidCustomFieldMaster);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidCustomFieldMaster != 0) {
                    try {
                        long oid = PstCustomFieldMaster.deleteExc(oidCustomFieldMaster);
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
