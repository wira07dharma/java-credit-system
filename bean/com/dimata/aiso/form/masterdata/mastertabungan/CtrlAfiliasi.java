/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.aiso.form.masterdata.mastertabungan;

import com.dimata.aiso.entity.masterdata.mastertabungan.Afiliasi;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstAfiliasi;
import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.qdep.db.*;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.json.JSONObject;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author nuharta
 */
public class CtrlAfiliasi extends Control implements I_Language {

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
    private Afiliasi afiliasi;
    private PstAfiliasi pstAfiliasi;
    private FrmAfiliasi frmAfiliasi;
    int language = LANGUAGE_DEFAULT;

    private JSONObject history = new JSONObject();
    LogSysHistory logSysHistory = new LogSysHistory();
    Afiliasi cloneObj = null;

    public CtrlAfiliasi(HttpServletRequest request) {
        msgString = "";
        afiliasi = new Afiliasi();
        try {
            pstAfiliasi = new PstAfiliasi(0);
        } catch (Exception e) {;
        }
        frmAfiliasi = new FrmAfiliasi(request, afiliasi);
        logSysHistory.setLogApplication((String) request.getAttribute("app"));
        logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_MASTER_AFILIASI]);
        logSysHistory.setLogOpenUrl("#");
        logSysHistory.setLogUpdateDate(new java.util.Date());
        logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
        logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmAfiliasi.addError(FrmAfiliasi.FRM_FIELD_AFILIASI_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public Afiliasi getAfiliasi() {
        return afiliasi;
    }

    public FrmAfiliasi getForm() {
        return frmAfiliasi;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidAfiliasi) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidAfiliasi != 0) {
                    try {
                        afiliasi = PstAfiliasi.fetchExc(oidAfiliasi);
                        cloneObj = afiliasi.clone();
                    } catch (Exception exc) {
                    }
                }

                frmAfiliasi.requestEntityObject(afiliasi);
                if (frmAfiliasi.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (afiliasi.getOID() == 0) {
                    try {
                        oidAfiliasi = pstAfiliasi.insertExc(this.afiliasi);
                        logSysHistory.setLogUserAction("INSERT");
                        history.combine(this.afiliasi.historyNew());
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
                        long oid = pstAfiliasi.updateExc(this.afiliasi);
                        logSysHistory.setLogUserAction("UPDATE");
                        history.combine(cloneObj.historyCompare(this.afiliasi));
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidAfiliasi != 0) {
                    try {
                        afiliasi = PstAfiliasi.fetchExc(oidAfiliasi);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                break;

            case Command.ASK:
                if (oidAfiliasi != 0) {
                    try {
                        afiliasi = PstAfiliasi.fetchExc(oidAfiliasi);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidAfiliasi != 0) {
                    try {
                        this.cloneObj = PstAfiliasi.fetchExc(oidAfiliasi);
                        long oid = PstAfiliasi.deleteExc(oidAfiliasi);
                        logSysHistory.setLogUserAction("DELETE");
                        history.combine(this.cloneObj.historyNew());
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

        if (logSysHistory != null && rsCode == RSLT_OK && !history.toString().equals("{}")) {
            logSysHistory.setLogDocumentId(oidAfiliasi);
            logSysHistory.setLogDetail(history.toString());
            logSysHistory.setLogDocumentNumber("-");
            logSysHistory.setLogDocumentStatus(5);
            PstLogSysHistory.insertExc(logSysHistory);
        }

        return rsCode;
    }
}
