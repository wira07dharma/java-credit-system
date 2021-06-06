/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.masterdata;

/**
 *
 * @author Regen
 */
import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.system.*;
import com.dimata.sedana.ajax.kredit.AjaxAnggota;
import com.dimata.sedana.entity.assigntabungan.AssignTabungan;
import com.dimata.sedana.entity.assigntabungan.PstAssignTabungan;
import com.dimata.sedana.entity.masterdata.AssignContact;
import com.dimata.sedana.entity.masterdata.MasterTabungan;
import com.dimata.sedana.entity.masterdata.PstAssignContact;
import com.dimata.sedana.entity.masterdata.PstMasterTabungan;
import com.dimata.sedana.entity.tabungan.DataTabungan;
import com.dimata.sedana.entity.tabungan.PstDataTabungan;
import com.dimata.sedana.session.SessReportTabungan;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;
import java.util.logging.Logger;
import javax.servlet.http.*;

/*
 Description : Controll AssignContact
 Date : Sat Jul 22 2017
 Author : Regen
 */
public class CtrlAssignContact extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_FORM_FOREIGN_CONFLICT = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap", "Terjadi konflik data"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete", "Data conflict"}
    };
    private int start;
    private String msgString;
    private AssignContact entAssignContact;
    private PstAssignContact pstAssignContact;
    private FrmAssignContact frmAssignContact;
    int language = LANGUAGE_DEFAULT;

    public CtrlAssignContact(HttpServletRequest request) {
        msgString = "";
        entAssignContact = new AssignContact();
        try {
            pstAssignContact = new PstAssignContact(0);
        } catch (Exception e) {;
        }
        frmAssignContact = new FrmAssignContact(request, entAssignContact);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmAssignContact.addError(frmAssignContact.FRM_FIELD_ASSIGNTABUNGANID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public AssignContact getAssignContact() {
        return entAssignContact;
    }

    public FrmAssignContact getForm() {
        return frmAssignContact;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidAssignContact) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidAssignContact != 0) {
                    try {
                        entAssignContact = PstAssignContact.fetchExc(oidAssignContact);
                    } catch (Exception exc) {
                    }
                }

                frmAssignContact.requestEntityObject(entAssignContact);

                if (frmAssignContact.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (entAssignContact.getNoTabungan() == null || entAssignContact.getNoTabungan().equals("")) {
                    //BUAT NOMOR TABUNGAN
                    MasterTabungan mt = new MasterTabungan();
                    Anggota anggota = new Anggota();
                    try {
                        mt = PstMasterTabungan.fetchExc(entAssignContact.getMasterTabunganId());
                        anggota = PstAnggota.fetchExc(entAssignContact.getContactId());
                    } catch (Exception exc) {
                    }
                    String nomorTabungan = "" + mt.getKodeTabungan() + "-" + anggota.getNoAnggota();
                    entAssignContact.setNoTabungan(nomorTabungan);
                    int jumlah = 1;
                    while (jumlah > 0) {
                        int count = PstAssignContact.getCount(PstAssignContact.fieldNames[PstAssignContact.FLD_NO_TABUNGAN] + "='" + entAssignContact.getNoTabungan() + "' AND " + PstAssignContact.fieldNames[PstAssignContact.FLD_ASSIGN_TABUNGAN_ID] + " <> " + entAssignContact.getOID());
                        if (count > 0) {
                            jumlah++;
                            entAssignContact.setNoTabungan(nomorTabungan + "-" + jumlah);
                        } else {
                            jumlah = 0;
                        }
                    }
                    
                } else {
                    int count = PstAssignContact.getCount(PstAssignContact.fieldNames[PstAssignContact.FLD_NO_TABUNGAN] + "='" + entAssignContact.getNoTabungan() + "' AND " + PstAssignContact.fieldNames[PstAssignContact.FLD_ASSIGN_TABUNGAN_ID] + " <> " + entAssignContact.getOID());
                    if (count > 0) {
                        msgString = "Nomor tabungan sudah ada";
                        return getControlMsgId(I_DBExceptionInfo.DEL_RESTRICTED);
                    }
                }
                    
                if (entAssignContact.getOID() == 0) {
                    try {
                        long oid = pstAssignContact.insertExc(this.entAssignContact);
                        if (oid != 0) {
                            Vector<AssignTabungan> ats = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + "=" + this.entAssignContact.getMasterTabunganId(), "");
                            for (AssignTabungan a : ats) {
                                DataTabungan dt = new DataTabungan();
                                dt.setIdAnggota(this.entAssignContact.getContactId());
                                dt.setIdJenisSimpanan(a.getIdJenisSimpanan());
                                dt.setTanggal(new Date());
                                dt.setStatus(1);
                                dt.setContactIdAhliWaris(this.entAssignContact.getContactId());
                                dt.setAssignTabunganId(this.entAssignContact.getOID());
                                long idSimpanan = PstDataTabungan.insertExc(dt);
                                dt.setIdAlokasiBunga(idSimpanan);
                                PstDataTabungan.updateExc(dt);
                                
                                //cek apakah termasuk tabungan deposito
                                int periodeBulanDeposito = SessReportTabungan.getPeriodeBulanDeposito(dt.getAssignTabunganId());
                                if (periodeBulanDeposito > 0) {
                                    Calendar cal = Calendar.getInstance();
                                    cal.setTime(dt.getTanggal());
                                    cal.add(Calendar.MONTH, periodeBulanDeposito);
                                    dt.setTanggalTutup(cal.getTime());
                                }
                                PstDataTabungan.updateExc(dt);
                            }
                        }
                    } catch (DBException dbexc) {
                        try {
                            PstAssignContact.deleteExc(entAssignContact.getOID());
                        } catch (DBException ex) {
                            Logger.getLogger(CtrlAssignContact.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
                        }
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        try {
                            PstAssignContact.deleteExc(oidAssignContact);
                        } catch (DBException ex) {
                            Logger.getLogger(CtrlAssignContact.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
                        }
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }

                } else {
                    try {
                        long oid = pstAssignContact.updateExc(this.entAssignContact);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidAssignContact != 0) {
                    try {
                        entAssignContact = PstAssignContact.fetchExc(oidAssignContact);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidAssignContact != 0) {
                    try {
                        entAssignContact = PstAssignContact.fetchExc(oidAssignContact);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidAssignContact != 0) {
                    AjaxAnggota ajaxAnggota = new AjaxAnggota();
                    //cek tabungan pernah digunakan
                    msgString = ajaxAnggota.cekApakahTabunganSudahPernahDigunakan(oidAssignContact);
                    if (msgString.length() > 0) {
                        excCode = RSLT_FORM_FOREIGN_CONFLICT;
                    } else {
                        long oid = PstAssignContact.deleteWithCheck(oidAssignContact);
                        if (oid >= 0) {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                            excCode = RSLT_FORM_FOREIGN_CONFLICT;
                        }
                    }
                }
                break;

            default:

        }
        return excCode;
    }

    public int actionSetAlokasiBunga(String[] idSimpanan, String[] idSimpananAlokasi) {
        if (idSimpanan != null && idSimpananAlokasi != null) {
            for (int i = 0; i < idSimpanan.length; i++) {
                if (idSimpanan[i].equals("0") || idSimpananAlokasi[i].equals("0")) {
                    continue;
                }
                try {
                    DataTabungan dt = PstDataTabungan.fetchExc(Long.valueOf(idSimpanan[i]));
                    dt.setIdAlokasiBunga(Long.valueOf(idSimpananAlokasi[i]));
                    PstDataTabungan.updateExc(dt);
                } catch (DBException ex) {
                    msgString = "Gagal menyimpan alokasi bunga! : " + ex.getMessage();
                    return 1;
                }
            }
        }
        return 0;
    }
    
    public int actionSetTanggalTutup(String[] idSimpanan, String[] tanggalTutup) {
        if (tanggalTutup != null) {
            for (int i = 0; i < tanggalTutup.length; i++) {
                try {
                    Date tglTutup = null;
                    if (!tanggalTutup[i].equals("")) {
                        tglTutup = Formater.formatDate(tanggalTutup[i], "yyyy-MM-dd");
                    }
                    DataTabungan dt = PstDataTabungan.fetchExc(Long.valueOf(idSimpanan[i]));
                    dt.setTanggalTutup(tglTutup);
                    PstDataTabungan.updateExc(dt);
                } catch (NumberFormatException e) {

                } catch (DBException e) {

                }
            }
        }
        return 0;
    }
}
