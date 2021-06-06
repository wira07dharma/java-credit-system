/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.aiso.form.masterdata.mastertabungan;

import com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisSimpanan;
import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.sedana.entity.assigntabungan.PstAssignTabungan;
import com.dimata.sedana.entity.masterdata.PstTingkatanBunga;
import com.dimata.sedana.entity.masterdata.TingkatanBunga;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.json.JSONObject;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Dede Nuharta
 */
public class CtrlJenisSimpanan extends Control implements I_Language {

    public static final int RSLT_OK = 0;
    public static final int RSLT_SAME = 1;
    public static final int RSLT_INCOMPLETE = 2;
    public static final int RSLT_EXIST = 3;
    public static final int RSLT_UNKNOWN = 4;
    private JSONObject history = new JSONObject();
    LogSysHistory logSysHistory = new LogSysHistory();
    JenisSimpanan cloneObj = null;
    public static String resultText[][] = {
        {"OK ...", "Data sama ...", "Form belum lengkap ...", "Account link sudah ada ...", "Kesalahan tidak diketahui ..."},
        {"OK ...", "Same Data ...", "Form incomplete ...", "Link account already exist ...", "Unknown Error ..."}
    };

    private int start;
    private String msgString;
    private JenisSimpanan jenisSimpanan;
    private PstJenisSimpanan pstJenisSimpanan;
    private FrmJenisSimpanan frmJenisSimpanan;
    private int language = LANGUAGE_DEFAULT;
    private HttpServletRequest request;

    public CtrlJenisSimpanan(HttpServletRequest request) {
        this.request = request;
        msgString = "";
        jenisSimpanan = new JenisSimpanan();
        try {
            pstJenisSimpanan = new PstJenisSimpanan(0);
        } catch (Exception e) {
        }
        frmJenisSimpanan = new FrmJenisSimpanan(request, jenisSimpanan);
        logSysHistory.setLogApplication((String) request.getAttribute("app"));
        logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_JENIS_SIMPANAN]);
        logSysHistory.setLogOpenUrl("#");
        logSysHistory.setLogUpdateDate(new java.util.Date());
        logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
        logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmJenisSimpanan.addError(frmJenisSimpanan.FRM_FIELD_NAMA_SIMPANAN, resultText[language][RSLT_EXIST]);
                return resultText[language][RSLT_EXIST];

            default:
                return resultText[language][RSLT_UNKNOWN];

        }
    }

    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                return RSLT_EXIST;

            default:
                return RSLT_UNKNOWN;
        }
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public JenisSimpanan getJenisSimpanan() {
        return jenisSimpanan;
    }

    public FrmJenisSimpanan getForm() {
        return frmJenisSimpanan;
    }

    public String getMessage() {
        return msgString;
    }

    public int actionList(int listCmd, int start, int vectSize, int recordToGet) {
        msgString = "";

        switch (listCmd) {
            case Command.FIRST:
                this.start = 0;
                break;

            case Command.PREV:
                this.start = start - recordToGet;
                if (start < 0) {
                    this.start = 0;
                }
                break;

            case Command.NEXT:
                this.start = start + recordToGet;
                if (start >= vectSize) {
                    this.start = start - recordToGet;
                }
                break;

            case Command.LAST:
                int mdl = vectSize % recordToGet;
                if (mdl > 0) {
                    this.start = vectSize - mdl;
                } else {
                    this.start = vectSize - recordToGet;
                }

                break;

            default:
                this.start = start;
                if (vectSize < 1) {
                    this.start = 0;
                }

                if (start > vectSize) {
                    // set to last
                    mdl = vectSize % recordToGet;
                    if (mdl > 0) {
                        this.start = vectSize - mdl;
                    } else {
                        this.start = vectSize - recordToGet;
                    }
                }
                break;
        } //end switch
        return this.start;
    }

    public int action(int cmd, long Oid) throws DBException {
        int errCode = -1;
        int excCode = 0;
        int rsCode = 0;

        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (Oid != 0) {
                    try {
                        jenisSimpanan = pstJenisSimpanan.fetchExc(Oid);
                        cloneObj = jenisSimpanan.clone();
                    } catch (Exception exc) {

                    }
                }

                frmJenisSimpanan.requestEntityObject(jenisSimpanan);
                String nama = jenisSimpanan.getNamaSimpanan();
                if (frmJenisSimpanan.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_INCOMPLETE;
                }

                if (jenisSimpanan.getOID() == 0) {
                    try {
                        Oid = pstJenisSimpanan.insertExc(this.jenisSimpanan);

                        logSysHistory.setLogUserAction("INSERT");
                        history.combine(this.jenisSimpanan.historyNew());
                        msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
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
                        Vector listAssignTabungan = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_ID_JENIS_SIMPANAN] + " = " + Oid, null);
                        if (!listAssignTabungan.isEmpty()) {
                            //msgString = "Data tidak dapat diubah. Jenis item ini sudah digunakan di master tabungan.";
                            //return 1;
                        }
                        long oid = pstJenisSimpanan.updateExc(this.jenisSimpanan);
                        logSysHistory.setLogUserAction("UPDATE");
                        history.combine(cloneObj.historyCompare(this.jenisSimpanan));
                        msgString = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                boolean error = false;
                String[] idBunga = request.getParameterValues("ID_BUNGA");
                String[] bungaSaldoMin = request.getParameterValues("BUNGA_SALDO_MIN");
                String[] bunga = request.getParameterValues("BUNGA_VAL");
                if (idBunga != null) {
                    for (int i = 0; i < idBunga.length; i++) {
                        try {
                            boolean emptyBungaSaldoMin = bungaSaldoMin[i] == null || bungaSaldoMin[i].equals("") || bungaSaldoMin[i].equals("0");
                            boolean emptyBunga = bunga[i] == null || bunga[i].equals("") || bunga[i].equals("0");
                            if (emptyBungaSaldoMin && emptyBunga) {
                                PstTingkatanBunga.deleteExc(Long.valueOf(idBunga[i]));
                            } else {
                                TingkatanBunga tingkatanBunga = new TingkatanBunga();
                                tingkatanBunga.setIdJenisSimpanan(Oid);
                                tingkatanBunga.setNominalSaldoMin(Double.valueOf(bungaSaldoMin[i].equals("") ? "0" : bungaSaldoMin[i]));
                                tingkatanBunga.setPersentaseBunga(Double.valueOf(bunga[i].equals("") ? "0" : bunga[i]));
                                tingkatanBunga.setOID(Long.valueOf(idBunga[i].equals("") ? "0" : idBunga[i]));
                                if (tingkatanBunga.getOID() == 0) {
                                    PstTingkatanBunga.insertExc(tingkatanBunga);
                                } else if (tingkatanBunga.getOID() != 0) {
                                    PstTingkatanBunga.updateExc(tingkatanBunga);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            error = true;
                        }
                    }
                    if (error) {
                        msgString += ". Gagal simpan bunga !";
                    }
                }

                break;

            case Command.EDIT:
                if (Oid != 0) {
                    try {
                        jenisSimpanan = pstJenisSimpanan.fetchExc(Oid);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (Oid != 0) {
                    try {
                        jenisSimpanan = pstJenisSimpanan.fetchExc(Oid);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (Oid != 0) {
                    try {
                        this.cloneObj = PstJenisSimpanan.fetchExc(Oid);
                        long oid = pstJenisSimpanan.deleteExc(Oid);
                        logSysHistory.setLogUserAction("DELETE");
                        history.combine(this.cloneObj.historyNew());
                        if (oid != 0) {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                            excCode = RSLT_INCOMPLETE;
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

        }//end switch

        if (logSysHistory != null && rsCode == RSLT_OK && !history.toString().equals("{}")) {
            logSysHistory.setLogDocumentId(Oid);
            logSysHistory.setLogDocumentNumber("-");
            logSysHistory.setLogDetail(history.toString());
            logSysHistory.setLogDocumentStatus(5);
            PstLogSysHistory.insertExc(logSysHistory);
        }

        return excCode;
    }
}
