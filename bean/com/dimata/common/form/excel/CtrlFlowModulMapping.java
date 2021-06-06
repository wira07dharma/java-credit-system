/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.form.excel;

import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.common.entity.excel.*;

/**
 *
 * @author Gunadi
 */
public class CtrlFlowModulMapping extends Control implements I_Language {

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
    private FlowModulMapping entFlowModulMapping;
    private PstFlowModulMapping pstFlowModulMapping;
    private FrmFlowModulMapping frmFlowModulMapping;
    int language = LANGUAGE_DEFAULT;

    public CtrlFlowModulMapping(HttpServletRequest request) {
        msgString = "";
        entFlowModulMapping = new FlowModulMapping();
        try {
            pstFlowModulMapping = new PstFlowModulMapping(0);
        } catch (Exception e) {;
        }
        frmFlowModulMapping = new FrmFlowModulMapping(request, entFlowModulMapping);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmFlowModulMapping.addError(frmFlowModulMapping.FRM_FIELD_FLOW_MODUL_MAPPING_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public FlowModulMapping getFlowModulMapping() {
        return entFlowModulMapping;
    }

    public FrmFlowModulMapping getForm() {
        return frmFlowModulMapping;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidFlowModulMapping) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidFlowModulMapping != 0) {
                    try {
                        entFlowModulMapping = PstFlowModulMapping.fetchExc(oidFlowModulMapping);
                    } catch (Exception exc) {
                    }
                }

                frmFlowModulMapping.requestEntityObject(entFlowModulMapping);

                if (frmFlowModulMapping.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entFlowModulMapping.getOID() == 0) {
                    try {
                        long oid = pstFlowModulMapping.insertExc(this.entFlowModulMapping);
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
                        long oid = pstFlowModulMapping.updateExc(this.entFlowModulMapping);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidFlowModulMapping != 0) {
                    try {
                        entFlowModulMapping = PstFlowModulMapping.fetchExc(oidFlowModulMapping);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidFlowModulMapping != 0) {
                    try {
                        entFlowModulMapping = PstFlowModulMapping.fetchExc(oidFlowModulMapping);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidFlowModulMapping != 0) {
                    try {
                        long oid = PstFlowModulMapping.deleteExc(oidFlowModulMapping);
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