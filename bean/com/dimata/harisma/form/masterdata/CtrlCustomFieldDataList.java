/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Gunadi
 */

import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.masterdata.*;

public class CtrlCustomFieldDataList extends Control implements I_Language {

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
    private CustomFieldDataList entCustomFieldDataList;
    private PstCustomFieldDataList pstCustomFieldDataList;
    private FrmCustomFieldDataList frmCustomFieldDataList;
    int language = LANGUAGE_DEFAULT;

    public CtrlCustomFieldDataList(HttpServletRequest request) {
        msgString = "";
        entCustomFieldDataList = new CustomFieldDataList();
        try {
            pstCustomFieldDataList = new PstCustomFieldDataList(0);
        } catch (Exception e) {;
        }
        frmCustomFieldDataList = new FrmCustomFieldDataList(request, entCustomFieldDataList);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmCustomFieldDataList.addError(frmCustomFieldDataList.FRM_FIELD_CUSTOM_FIELD_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public CustomFieldDataList getCustomFieldDataList() {
        return entCustomFieldDataList;
    }

    public FrmCustomFieldDataList getForm() {
        return frmCustomFieldDataList;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidCustomFieldDataList) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidCustomFieldDataList != 0) {
                    try {
                        entCustomFieldDataList = PstCustomFieldDataList.fetchExc(oidCustomFieldDataList);
                    } catch (Exception exc) {
                    }
                }

                frmCustomFieldDataList.requestEntityObject(entCustomFieldDataList);

                if (frmCustomFieldDataList.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entCustomFieldDataList.getOID() == 0) {
                    try {
                        long oid = pstCustomFieldDataList.insertExc(this.entCustomFieldDataList);
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
                        long oid = pstCustomFieldDataList.updateExc(this.entCustomFieldDataList);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidCustomFieldDataList != 0) {
                    try {
                        entCustomFieldDataList = PstCustomFieldDataList.fetchExc(oidCustomFieldDataList);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidCustomFieldDataList != 0) {
                    try {
                        entCustomFieldDataList = PstCustomFieldDataList.fetchExc(oidCustomFieldDataList);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidCustomFieldDataList != 0) {
                    try {
                        long oid = PstCustomFieldDataList.deleteExc(oidCustomFieldDataList);
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
