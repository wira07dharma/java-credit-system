/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.masterdata;

import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.qdep.db.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.system.*;
import com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan;
import com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan;
import com.dimata.sedana.entity.assigntabungan.AssignTabungan;
import com.dimata.sedana.entity.assigntabungan.PstAssignTabungan;
import com.dimata.sedana.entity.masterdata.MasterTabungan;
import com.dimata.sedana.entity.masterdata.PstMasterTabungan;
import com.dimata.sedana.entity.tabungan.AssignPenarikanTabungan;
import com.dimata.sedana.entity.tabungan.MasterTabunganPenarikan;
import com.dimata.sedana.entity.tabungan.PstAssignPenarikanTabungan;
import com.dimata.sedana.entity.tabungan.PstMasterTabunganPenarikan;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.json.JSONObject;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import java.util.Vector;
import javax.servlet.http.*;

/*
 Description : Controll MasterTabungan
 Date : Tue Jul 18 2017
 Author : Regen
 */
public class CtrlMasterTabungan extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "Kode Master Tabungan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Master Saving code exist", "Data incomplete"}
    };
    private int start;
    private String msgString;
    private MasterTabungan entMasterTabungan;
    private PstMasterTabungan pstMasterTabungan;
    private FrmMasterTabungan frmMasterTabungan;
    int language = LANGUAGE_DEFAULT;
    public long oid;

    private JSONObject history = new JSONObject();
    LogSysHistory logSysHistory = new LogSysHistory();
    MasterTabungan cloneObj = null;

    public CtrlMasterTabungan(HttpServletRequest request) {
        msgString = "";
        entMasterTabungan = new MasterTabungan();
        try {
            pstMasterTabungan = new PstMasterTabungan(0);
        } catch (Exception e) {;
        }
        frmMasterTabungan = new FrmMasterTabungan(request, entMasterTabungan);

        logSysHistory.setLogApplication((String) request.getAttribute("app"));
        logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_MASTER_TABUNGAN]);
        logSysHistory.setLogOpenUrl("#");
        logSysHistory.setLogUpdateDate(new java.util.Date());
        logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
        logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmMasterTabungan.addError(frmMasterTabungan.FRM_FIELD_MASTERTABUNGANID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public MasterTabungan getMasterTabungan() {
        return entMasterTabungan;
    }

    public FrmMasterTabungan getForm() {
        return frmMasterTabungan;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidMasterTabungan) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidMasterTabungan != 0) {
                    try {
                        entMasterTabungan = PstMasterTabungan.fetchExc(oidMasterTabungan);
                        cloneObj = entMasterTabungan.clone();
                    } catch (Exception exc) {
                    }
                }

                frmMasterTabungan.requestEntityObject(entMasterTabungan);

                if (frmMasterTabungan.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entMasterTabungan.getOID() == 0) {
                    try {
                        long oid = pstMasterTabungan.insertExc(this.entMasterTabungan);
                        this.oid = oid;
                        logSysHistory.setLogUserAction("INSERT");
                        history.combine(this.entMasterTabungan.historyNew());
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
                        long oid = pstMasterTabungan.updateExc(this.entMasterTabungan);
                        this.oid = oid;
                        logSysHistory.setLogUserAction("UPDATE");
                        history.combine(cloneObj.historyCompare(this.entMasterTabungan));
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidMasterTabungan != 0) {
                    entMasterTabungan = PstMasterTabungan.fetchExc(oidMasterTabungan);
                }
                break;

            case Command.ASK:
                if (oidMasterTabungan != 0) {
                    entMasterTabungan = PstMasterTabungan.fetchExc(oidMasterTabungan);
                }
                break;

            case Command.DELETE:
                if (oidMasterTabungan != 0) {
                    try {
                        this.cloneObj = PstMasterTabungan.fetchExc(oidMasterTabungan);
                        //cek apakah tabungan sudah di gunakan oleh nasabah
                        int count = PstAssignContactTabungan.getCount(PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_MASTER_TABUNGAN_ID] + " = " + oidMasterTabungan);
                        if (count == 0) {
                            //hapus periode penarikan
                            Vector<AssignPenarikanTabungan> listAssignPenarikan = PstAssignPenarikanTabungan.list(0, 0, PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID] + " = " + oidMasterTabungan, null);
                            for (AssignPenarikanTabungan apt : listAssignPenarikan) {
                                PstAssignPenarikanTabungan.deleteExc(apt.getOID());
                                PstMasterTabunganPenarikan.deleteExc(apt.getIdTabunganRangePenarikan());
                            }

                            //hapus assign tabungan
                            Vector<AssignTabungan> listAssignTabungan = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + " = " + oidMasterTabungan, null);
                            for (AssignTabungan at : listAssignTabungan) {
                                PstAssignTabungan.deleteExc(at.getOID());
                            }

                            long oid = PstMasterTabungan.deleteExc(oidMasterTabungan);
                            logSysHistory.setLogUserAction("DELETE");
                            history.combine(this.cloneObj.historyNew());
                            if (oid != 0) {
                                msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                                excCode = RSLT_OK;
                            } else {
                                msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                                excCode = RSLT_FORM_INCOMPLETE;
                            }
                        } else {
                            excCode = 1;
                            msgString = "Tidak dapat menghapus data. Tabungan ini sudah digunakan.";
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
            logSysHistory.setLogDocumentId(oidMasterTabungan);
            logSysHistory.setLogDetail(history.toString());
            logSysHistory.setLogDocumentNumber("-");
            logSysHistory.setLogDocumentStatus(5);
            PstLogSysHistory.insertExc(logSysHistory);
        }
        return excCode;
    }

    public int saveAssignTabungan(long oidMasterTabungan, String[] multiIdJenisSimpanan) {
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        if (oidMasterTabungan != 0) {
            try {
                //delete last assign tabungan if exist
                Vector<AssignTabungan> listAssignTab = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + " = '" + oidMasterTabungan + "'", "");
                for (AssignTabungan at : listAssignTab) {
                    PstAssignTabungan.deleteExc(at.getOID());
                }

                //save new assign
                if (multiIdJenisSimpanan != null) {
                    for (String id : multiIdJenisSimpanan) {
                        AssignTabungan as = new AssignTabungan();
                        as.setIdJenisSimpanan(Long.valueOf(id));
                        as.setMasterTabungan(oidMasterTabungan);
                        PstAssignTabungan.insertExc(as);
                    }
                }
                this.msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                excCode = RSLT_OK;
            } catch (DBException dbe) {
                excCode = dbe.getErrorCode();
                this.msgString = getSystemMessage(excCode);
                return getControlMsgId(excCode);
            }
        }
        return excCode;
    }

    public int savePeriodePenarikan(long oidPeriode, long oidMasterTabungan, MasterTabunganPenarikan penarikan) {
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        try {
            if (oidPeriode == 0 && oidMasterTabungan != 0) {
                long idPeriode = PstMasterTabunganPenarikan.insertExc(penarikan);
                //save assign penarikan
                AssignPenarikanTabungan assign = new AssignPenarikanTabungan();
                assign.setMasterTabunganId(oidMasterTabungan);
                assign.setIdTabunganRangePenarikan(idPeriode);
                PstAssignPenarikanTabungan.insertExc(assign);
                this.msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
            } else {
                penarikan.setOID(oidPeriode);
                PstMasterTabunganPenarikan.updateExc(penarikan);
                this.msgString = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
            }
        } catch (DBException dbe) {
            excCode = dbe.getErrorCode();
            this.msgString = getSystemMessage(excCode);
            return getControlMsgId(excCode);
        }
        return excCode;
    }
}
