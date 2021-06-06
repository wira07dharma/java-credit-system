package com.dimata.sedana.form.masterdata;

/**
 *
 * @author Regen
 */
import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.system.*;
import com.dimata.sedana.entity.masterdata.MasterLoket;
import com.dimata.sedana.entity.masterdata.PstMasterLoket;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.json.JSONObject;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import javax.servlet.http.*;

/*
 Description : Controll MasterLoket
 Date : Fri Jun 30 2017
 Author : Regen
 */
public class CtrlMasterLoket extends Control implements I_Language {

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
    private MasterLoket obj;
    private PstMasterLoket pst;
    private FrmMasterLoket frm;
    int language = LANGUAGE_DEFAULT;

    private JSONObject history = new JSONObject();
    LogSysHistory logSysHistory = new LogSysHistory();
    MasterLoket cloneObj = new MasterLoket();

    public CtrlMasterLoket(HttpServletRequest request) {
        msgString = "";
        obj = new MasterLoket();
        try {
            pst = new PstMasterLoket(0);
        } catch (Exception e) {;
        }
        frm = new FrmMasterLoket(request, obj);
        logSysHistory.setLogApplication((String) request.getAttribute("app"));
        logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_MASTER_LOKET]);
        logSysHistory.setLogOpenUrl("#");
        logSysHistory.setLogUpdateDate(new java.util.Date());
        logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
        logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frm.addError(frm.FRM_FIELD_LOCATOIN_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public MasterLoket getMasterLoket() {
        return obj;
    }

    public FrmMasterLoket getForm() {
        return frm;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidMasterLoket) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidMasterLoket != 0) {
                    try {
                        obj = PstMasterLoket.fetchExc(oidMasterLoket);
                        cloneObj = obj == null ? cloneObj : obj.clone();
                    } catch (Exception exc) {
                    }
                }

                frm.requestEntityObject(obj);

                if (frm.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (obj.getOID() == 0) {
                    try {
                        long oid = pst.insertExc(this.obj);
                        logSysHistory.setLogUserAction("INSERT");
                        history.combine(this.obj.historyNew());
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
                        long oid = pst.updateExc(this.obj);
                        logSysHistory.setLogUserAction("UPDATE");
                        history.combine(cloneObj.historyCompare(this.obj));
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidMasterLoket != 0) {
                    try {
                        obj = PstMasterLoket.fetchExc(oidMasterLoket);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidMasterLoket != 0) {
                    try {
                        obj = PstMasterLoket.fetchExc(oidMasterLoket);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidMasterLoket != 0) {
                    try {
                        this.cloneObj = pst.fetchExc(oidMasterLoket);
                        long oid = PstMasterLoket.deleteExc(oidMasterLoket);
                        if (oid != 0) {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                            logSysHistory.setLogUserAction("DELETE");
                            history.combine(this.cloneObj.historyNew());
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
        if (logSysHistory != null
                && rsCode == RSLT_OK
                && logSysHistory.getLogUserAction() != null
                && !logSysHistory.getLogUserAction().equals("")) {
            logSysHistory.setLogDocumentId(oidMasterLoket);
            logSysHistory.setLogDetail(history.toString());
            logSysHistory.setLogDocumentNumber("-");
            logSysHistory.setLogDocumentStatus(5);
            PstLogSysHistory.insertExc(logSysHistory);
        }
        return rsCode;
    }
}
