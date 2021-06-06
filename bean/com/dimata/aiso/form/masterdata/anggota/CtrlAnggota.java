/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.aiso.form.masterdata.anggota;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.AnggotaKeluarga;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggotaKeluarga;
import com.dimata.aiso.session.masterdata.SessAnggota;
import com.dimata.common.entity.contact.ContactClass;
import com.dimata.common.entity.contact.ContactClassAssign;
import com.dimata.common.entity.contact.PstContactClass;
import com.dimata.common.entity.contact.PstContactClassAssign;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.common.form.contact.FrmContactClass;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.sedana.entity.anggota.AnggotaBadanUsaha;
import com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha;
import com.dimata.sedana.entity.kredit.Penjamin;
import com.dimata.sedana.entity.kredit.PstPenjamin;
import com.dimata.services.WebServices;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import java.util.Date;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONObject;

/**
 *
 * @author HaddyPuutraa (PKL) Created Kamis, 21 Pebruari 2013
 */
public class CtrlAnggota extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_RECORD_NOT_FOUND = 4;

    public static String[][] resultText = {
        {"Proses Berhasil", "Tidak Dapat Diproses", "Anggota Tersebut Sudah Ada", "Data Tidak Lengkap", "Data tidak ditemukan karena telah diubah oleh user lain"},
        {"Success", "Can not process", "Anggota Name exist", "Data Incomplete", "Data not found cause another user changed it"}
    };

    private int start;
    private String msgString;
    private Anggota anggota;
    private AnggotaBadanUsaha anggotaBadanUsaha;
    private ContactClass contactClass;
    private PstAnggota pstAnggota;
    private PstAnggotaBadanUsaha pstAnggotaBadanUsaha;
    private PstContactClass pstContactClass;
    private FrmAnggota frmAnggota;
    private FrmPenjamin frmPenjamin;
    private FrmAnggotaBadanUsaha frmKelompokBadanUsaha;
    private FrmContactClass frmContactClass;
    int language = LANGUAGE_DEFAULT;

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public CtrlAnggota(HttpServletRequest request) {
        msgString = "";
        anggota = new Anggota();
        anggotaBadanUsaha = new AnggotaBadanUsaha();
        contactClass = new ContactClass();
        try {
            pstAnggota = new PstAnggota(0);
            pstAnggotaBadanUsaha = new PstAnggotaBadanUsaha(0);
            pstContactClass = new PstContactClass(0);
        } catch (Exception e) {
            System.out.println("kesalahan hasil request http " + e);
        }
        frmAnggota = new FrmAnggota(request, anggota);
        frmPenjamin = new FrmPenjamin(request, anggota);
        String xxxx = request.getParameter(""+FrmAnggota.fieldNames[FrmAnggota.FRM_SEX]);
        frmKelompokBadanUsaha = new FrmAnggotaBadanUsaha(request, anggotaBadanUsaha);
        frmContactClass = new FrmContactClass(request, contactClass);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmAnggota.addError(frmAnggota.FRM_NO_ANGGOTA, resultText[language][RSLT_EST_CODE_EXIST]);
                this.frmPenjamin.addError(frmPenjamin.FRM_NO_ANGGOTA, resultText[language][RSLT_EST_CODE_EXIST]);
                this.frmKelompokBadanUsaha.addError(frmKelompokBadanUsaha.FRM_NO_ANGGOTA, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public Anggota getAnggota() {
        return anggota;
    }

    public AnggotaBadanUsaha getAnggotaBadanUsaha() {
        return anggotaBadanUsaha;
    }

    public FrmAnggota getForm() {
        return frmAnggota;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
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

    public int Action(int cmd, long Oid) throws DBException {
        int errCode = -1;
        int excCode = 0;
        int rsCode = 0;
        String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (Oid != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(Oid);
                    } catch (Exception exc) {

                    }
                }

                frmAnggota.requestEntityObject(anggota);
                frmContactClass.requestEntityObject(contactClass);
                int contactType = contactClass.getClassType();
                String oidContactClass = contactClass.getClassName();
                if (frmAnggota.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                 
                if (Oid == 0) {
                    //set no anggota
                    if(anggota.getNoAnggota().equals("Auto-Number")) {
                      String kodeAnggota = "";
                      String nomorAnggota = "";
                      String today = Formater.formatDate(new Date(), "yyyyMMdd");
                      int last = SessAnggota.getCountJoinContactClassAssign("cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + contactType + "'");
                      last += 1;
                      int check = 1;
					  
                    switch(contactType){
                            case PstContactClass.CONTACT_TYPE_MEMBER:
                                    kodeAnggota = "NI";
                                    break;
                            case PstContactClass.CONTACT_TYPE_ACCOUNT_OFFICER:
                                    kodeAnggota = "AO";
                                    break;
                            case PstContactClass.CONTACT_TYPE_ACCOUNT_COLLECTOR:
                                    kodeAnggota = "KL";
                                    break;
                    }
					  
                      while (check > 0) {
                          String newLast = "" + last;
                          if (newLast.length() == 1) {
                              newLast = "000" + last;
                          } else if (newLast.length() == 2) {
                              newLast = "00" + last;
                          } else if (newLast.length() == 3) {
                              newLast = "0" + last;
                          } else if (newLast.length() == 4) {
                              newLast = "" + last;
                          }
                          nomorAnggota = kodeAnggota + newLast;
                          Vector listAnggota = PstAnggota.list(0, 0, "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " = '" + nomorAnggota + "'", "");
                          if (listAnggota.isEmpty()) {
                              check = 0;
                          } else {
                              last += 1;
                          }
                      }
                      anggota.setNoAnggota(nomorAnggota);
                    } else {
                      if(PstAnggota.getCount(PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA]+"='"+anggota.getNoAnggota()+"'")>0) {
                        return getControlMsgId(RSLT_EST_CODE_EXIST);
                      }
                    }
                }

                if (anggota.getOID() == 0) {
                    try {
                        long oid = pstAnggota.insertExc(this.anggota);
                        JSONObject jSONObject = PstContactList.fetchJSON(oid);
                        String urlPost = posApiUrl+"/master/contact/insert";
                        JSONObject objStatus = WebServices.postAPI(jSONObject.toString(),urlPost);
                        boolean status = objStatus.optBoolean("SUCCES", false);
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
                        long oid = pstAnggota.updateExc(this.anggota);
                        JSONObject jSONObject = PstContactList.fetchJSON(oid);
                        String urlPost = posApiUrl+"/master/contact/insert";
                        JSONObject objStatus = WebServices.postAPI(jSONObject.toString(),urlPost);
                        boolean status = objStatus.optBoolean("SUCCES", false);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                Vector vectClassAssign = PstContactClass.list(0, 0, "" + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" +  contactType + "'", "");
                if ((vectClassAssign != null) && (vectClassAssign.size() > 0)) {
                    PstContactClassAssign.deleteClassAssign(anggota.getOID());
                    for (int i = 0; i < vectClassAssign.size(); i++) {
                        ContactClass cntClsAssign = (ContactClass) vectClassAssign.get(i);
                        ContactClassAssign contactClassAssign = new ContactClassAssign();
                        contactClassAssign.setContactClassId(cntClsAssign.getOID());
                        contactClassAssign.setContactId(anggota.getOID());
                        PstContactClassAssign.insertExc(contactClassAssign);
                        JSONObject jSONObject = PstContactClassAssign.fetchJSON(cntClsAssign.getOID(), anggota.getOID());
                        String urlPost = posApiUrl+"/master/contact-class-assign/insert";
                        JSONObject objStatus = WebServices.postAPI(jSONObject.toString(),urlPost);
                        boolean status = objStatus.optBoolean("SUCCES", false);
                    }
                }

                Vector classAssign = PstContactClass.list(0, 0, "" + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] + " = '" +  oidContactClass + "'", "");
                if ((classAssign != null) && (classAssign.size() > 0)) {
                    PstContactClassAssign.deleteClassAssign(anggota.getOID());
                    for (int i = 0; i < classAssign.size(); i++) {
                        ContactClass cntClsAssign = (ContactClass) classAssign.get(i);
                        ContactClassAssign contactClassAssign = new ContactClassAssign();
                        contactClassAssign.setContactClassId(cntClsAssign.getOID());
                        contactClassAssign.setContactId(anggota.getOID());
                        PstContactClassAssign.insertExc(contactClassAssign);
                        JSONObject jSONObject = PstContactClassAssign.fetchJSON(cntClsAssign.getOID(), anggota.getOID());
                        String urlPost = posApiUrl+"/master/contact-class-assign/insert";
                        JSONObject objStatus = WebServices.postAPI(jSONObject.toString(),urlPost);
                        boolean status = objStatus.optBoolean("SUCCES", false);
                    }
                }
 
                pstAnggota.addressAnggotaGeo(anggota);

                break;

            case Command.EDIT:
                if (Oid != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(Oid);
                        pstAnggota.addressAnggotaGeo(anggota);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (Oid != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(Oid);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (Oid != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(Oid);
                        long oid = pstAnggota.deleteExc(Oid);
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

        }//end switch

        return excCode;
    }

    public int ActionFamily(int cmd, long Oid, long oidAnggota, int hubunganKeluarga, String keteranganKeluarga, long oidRelasi) throws DBException {
        int errCode = -1;
        int excCode = 0;
        int rsCode = 0;

        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (Oid != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(Oid);
                    } catch (Exception exc) {

                    }
                }

                frmAnggota.requestEntityObject(anggota);
                if (frmAnggota.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (!anggota.getIdCard().equals("")) {
                    if (cekNoKtp(PstContactClass.FLD_CLASS_DONOR)) {
                        msgString = "Nomor KTP sudah ada !";
                        return RSLT_UNKNOWN_ERROR;
                    }
                }
                
                if (Oid == 0) {
                    //set no keluarga
                    String nomorKeluarga = "";                    
                    String today = Formater.formatDate(new Date(), "yyyyMMdd");
                    int last = SessAnggota.getCountJoinContactClassAssign("cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_DONOR + "'");
                    last += 1;
                    int check = 1;
                    while (check > 0) {
                        String newLast = "" + last;
                        if (newLast.length() == 1) {
                            newLast = "000" + last;
                        } else if (newLast.length() == 2) {
                            newLast = "00" + last;
                        } else if (newLast.length() == 3) {
                            newLast = "0" + last;
                        } else if (newLast.length() == 4) {
                            newLast = "" + last;
                        }
                        nomorKeluarga = "AK" + newLast;
                        Vector listAnggota = PstAnggota.list(0, 0, "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " = '" + nomorKeluarga + "'", "");
                        if (listAnggota.isEmpty()) {
                            check = 0;
                        } else {
                            last += 1;
                        }
                    }
                    anggota.setNoAnggota(nomorKeluarga);
                }

                if (anggota.getOID() == 0) {
                    try {
                        long oid = pstAnggota.insertExc(this.anggota);
                        AnggotaKeluarga keluarga = new AnggotaKeluarga();
                        keluarga.setContactAnggotaId(oidAnggota);
                        keluarga.setContactKeluargaId(oid);
                        keluarga.setKeterangan(keteranganKeluarga);
                        keluarga.setStatusRelasi(hubunganKeluarga);
                        PstAnggotaKeluarga.insertExc(keluarga);
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
                        long oid = pstAnggota.updateExc(this.anggota);
                        AnggotaKeluarga keluarga = new AnggotaKeluarga();
                        try {
                            keluarga = PstAnggotaKeluarga.fetchExc(oidRelasi);
                        } catch (Exception exc) {

                        }
                        keluarga.setKeterangan(keteranganKeluarga);
                        keluarga.setStatusRelasi(hubunganKeluarga);
                        PstAnggotaKeluarga.updateExc(keluarga);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                Vector vectClassAssign = PstContactClass.list(0, 0, "" + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_DONOR + "'", "");
                PstContactClassAssign.deleteClassAssign(anggota.getOID());
                if ((vectClassAssign != null) && (vectClassAssign.size() > 0)) {
                    for (int i = 0; i < vectClassAssign.size(); i++) {
                        ContactClass cntClsAssign = (ContactClass) vectClassAssign.get(i);
                        ContactClassAssign contactClassAssign = new ContactClassAssign();
                        contactClassAssign.setContactClassId(cntClsAssign.getOID());
                        contactClassAssign.setContactId(anggota.getOID());
                        PstContactClassAssign.insertExc(contactClassAssign);
                    }
                }

                pstAnggota.addressAnggotaGeo(anggota);

                break;

            case Command.EDIT:
                if (Oid != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(Oid);
                        pstAnggota.addressAnggotaGeo(anggota);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (Oid != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(Oid);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (Oid != 0) {
                    try {
                        long oid = pstAnggota.deleteExc(Oid);
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

        }//end switch

        return excCode;
    }

    public int ActionPenjamin(int cmd, long oidPenjamin, long oidPinjaman, double prosentaseDijamin) throws DBException {
        int errCode = -1;
        int excCode = 0;
        int rsCode = 0;

        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidPenjamin != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(oidPenjamin);
                    } catch (Exception exc) {

                    }
                }

                frmPenjamin.requestEntityObjectPenjamin(anggota);
                if (frmPenjamin.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (anggota.getOID() == 0) {
                    try {
                        long oid = pstAnggota.insertExc(this.anggota);
                        Penjamin penjamin = new Penjamin();
                        penjamin.setContactId(oid);
                        penjamin.setPinjamanId(oidPinjaman);
                        penjamin.setProsentasePenjamin(prosentaseDijamin);
                        PstPenjamin.insertExc(penjamin);
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
                        long oid = pstAnggota.updateExc(this.anggota);
                        Vector listPenjamin = PstPenjamin.list(0, 0, "" + PstPenjamin.fieldNames[PstPenjamin.FLD_CONTACT_ID] + " = '" + oid + "'"
                                + " AND " + PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'", "");
                        Penjamin penjamin = new Penjamin();
                        if (!listPenjamin.isEmpty()) {
                            Penjamin p = (Penjamin) listPenjamin.get(0);
                            penjamin = PstPenjamin.fetchExc(p.getOID());
                            penjamin.setProsentasePenjamin(prosentaseDijamin);
                            PstPenjamin.updateExc(penjamin);
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
                        } else {
                            penjamin.setContactId(oid);
                            penjamin.setPinjamanId(oidPinjaman);
                            penjamin.setProsentasePenjamin(prosentaseDijamin);
                            PstPenjamin.insertExc(penjamin);
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                        }
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                Vector vectClassAssign = PstContactClass.list(0, 0, "" + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_DONOR + "'", "");
                PstContactClassAssign.deleteClassAssign(anggota.getOID());
                if ((vectClassAssign != null) && (vectClassAssign.size() > 0)) {
                    for (int i = 0; i < vectClassAssign.size(); i++) {
                        ContactClass cntClsAssign = (ContactClass) vectClassAssign.get(i);
                        ContactClassAssign contactClassAssign = new ContactClassAssign();
                        contactClassAssign.setContactClassId(cntClsAssign.getOID());
                        contactClassAssign.setContactId(anggota.getOID());
                        PstContactClassAssign.insertExc(contactClassAssign);
                    }
                }

                pstAnggota.addressAnggotaGeo(anggota);

                break;

            case Command.EDIT:
                if (oidPenjamin != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(oidPenjamin);
                        pstAnggota.addressAnggotaGeo(anggota);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidPenjamin != 0) {
                    try {
                        anggota = pstAnggota.fetchExc(oidPenjamin);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidPenjamin != 0) {
                    try {
                        long oid = PstPenjamin.deleteExc(oidPenjamin);
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

        }//end switch

        return excCode;
    }

    public int ActionKelompok(int cmd, long oidKelompok) throws DBException {
        int errCode = -1;
        int excCode = 0;
        int rsCode = 0;

        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKelompok != 0) {
                    try {
                        anggotaBadanUsaha = pstAnggotaBadanUsaha.fetchExc(oidKelompok);
                    } catch (Exception exc) {
                        
                    }
                }
                
                frmKelompokBadanUsaha.requestEntityObject(anggotaBadanUsaha);
                if (frmKelompokBadanUsaha.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (anggotaBadanUsaha.getNoAnggota().length() == 0) {
                    String nomorBadanUsaha = "";
                    String kodeBadanUsaha = "BU";
                    String today = Formater.formatDate(new Date(), "yyyyMMdd");
                    int last = PstAnggotaBadanUsaha.getCount(" DATE(" + PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_REG_DATE] + ") = DATE(NOW())");
                    last += 1;
                    int check = 1;
                    while (check > 0) {
                        String newLast = "" + last;
                        if (newLast.length() == 1) {
                            newLast = "000" + last;
                        } else if (newLast.length() == 2) {
                            newLast = "00" + last;
                        } else if (newLast.length() == 3) {
                            newLast = "0" + last;
                        } else if (newLast.length() == 4) {
                            newLast = "" + last;
                        }
                        nomorBadanUsaha = kodeBadanUsaha + today + "" + newLast;
                        Vector listBadanUsaha = PstAnggotaBadanUsaha.list(0, 0, "" + PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NO_ANGGOTA] + " = '" + nomorBadanUsaha + "'", "");
                        if (listBadanUsaha.isEmpty()) {
                            check = 0;
                        } else {
                            last += 1;
                        }
                    }
                    anggotaBadanUsaha.setNoAnggota(nomorBadanUsaha);
                }

                if (anggotaBadanUsaha.getOID() == 0) {
                    try {
                        anggotaBadanUsaha.setRegDate(new Date());
                        long oid = pstAnggotaBadanUsaha.insertExc(this.anggotaBadanUsaha);
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
                        long oid = pstAnggotaBadanUsaha.updateExc(this.anggotaBadanUsaha);
                        msgString = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                Vector vectClassAssign = PstContactClass.list(0, 0, "" + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "'", "");
                PstContactClassAssign.deleteClassAssign(anggotaBadanUsaha.getOID());
                if ((vectClassAssign != null) && (vectClassAssign.size() > 0)) {
                    for (int i = 0; i < vectClassAssign.size(); i++) {
                        ContactClass cntClsAssign = (ContactClass) vectClassAssign.get(i);
                        ContactClassAssign contactClassAssign = new ContactClassAssign();
                        contactClassAssign.setContactClassId(cntClsAssign.getOID());
                        contactClassAssign.setContactId(anggotaBadanUsaha.getOID());
                        PstContactClassAssign.insertExc(contactClassAssign);
                    }
                }

                break;

            case Command.EDIT:
                if (oidKelompok != 0) {
                    try {
                        anggotaBadanUsaha = pstAnggotaBadanUsaha.fetchExc(oidKelompok);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKelompok != 0) {
                    try {
                        anggotaBadanUsaha = pstAnggotaBadanUsaha.fetchExc(oidKelompok);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKelompok != 0) {
                    try {
                        PstContactClassAssign.deleteClassAssign(anggotaBadanUsaha.getOID());
                        long oid = PstAnggotaBadanUsaha.deleteExc(oidKelompok);
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

        }//end switch

        return excCode;
    }

    public int ActionPenjaminKredit(int cmd, long oidPenjamin) throws DBException {
        int errCode = -1;
        int excCode = 0;
        int rsCode = 0;

        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidPenjamin != 0) {
                    try {
                        anggotaBadanUsaha = pstAnggotaBadanUsaha.fetchExc(oidPenjamin);
                    } catch (Exception exc) {

                    }
                }

                frmKelompokBadanUsaha.requestEntityObject(anggotaBadanUsaha);
                
                if (frmKelompokBadanUsaha.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (anggotaBadanUsaha.getNoAnggota().isEmpty()) {
                    String nomorPenjamin = "";
                    String kodeBadanUsaha = "P";
                    String today = Formater.formatDate(new Date(), "yyyyMMdd");
                    int last = PstContactClass.countClassAssign(PstContactClass.FLD_CLASS_PENJAMIN);
                    last += 1;
                    boolean isExist = true;
                    String zero = "0000";
                    while (isExist) {
                        String newLast = "" + last;
                        if (newLast.length() <= zero.length()) {
                            newLast = zero.substring(zero.length() - (zero.length() - newLast.length())) + last;
                        }
                        nomorPenjamin = kodeBadanUsaha + today + "-" + newLast;
                        Vector listBadanUsaha = PstAnggotaBadanUsaha.list(0, 0, "" + PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NO_ANGGOTA] + " = '" + nomorPenjamin + "'", "");
                        if (listBadanUsaha.isEmpty()) {
                            isExist = false;
                        } else {
                            last += 1;
                        }
                    }
                    anggotaBadanUsaha.setNoAnggota(nomorPenjamin);
                }

                if (anggotaBadanUsaha.getOID() == 0) {
                    try {
                        anggotaBadanUsaha.setRegDate(new Date());
                        long oid = pstAnggotaBadanUsaha.insertExcPenjamin(this.anggotaBadanUsaha);
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
                        long oid = pstAnggotaBadanUsaha.updateExcPenjamin(this.anggotaBadanUsaha);
                        msgString = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                Vector vectClassAssign = PstContactClass.list(0, 0, "" + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" +PstContactClass.FLD_CLASS_PENJAMIN+ "'", "");
                PstContactClassAssign.deleteClassAssign(anggotaBadanUsaha.getOID());
                if ((vectClassAssign != null) && (vectClassAssign.size() > 0)) {
                    for (int i = 0; i < vectClassAssign.size(); i++) {
                        ContactClass cntClsAssign = (ContactClass) vectClassAssign.get(i);
                        ContactClassAssign contactClassAssign = new ContactClassAssign();
                        contactClassAssign.setContactClassId(cntClsAssign.getOID());
                        contactClassAssign.setContactId(anggotaBadanUsaha.getOID());
                        PstContactClassAssign.insertExc(contactClassAssign);
                    }
                }

                break;

            case Command.EDIT:
                if (oidPenjamin != 0) {
                    try {
                        anggotaBadanUsaha = pstAnggotaBadanUsaha.fetchExc(oidPenjamin);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidPenjamin != 0) {
                    try {
                        anggotaBadanUsaha = pstAnggotaBadanUsaha.fetchExc(oidPenjamin);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidPenjamin != 0) {
                    try {
                        long oid = PstAnggotaBadanUsaha.deleteExc(oidPenjamin);
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

        }//end switch

        return excCode;
    }
    
    public boolean cekNoKtp(int classType) {
        String queryClassType = "SELECT " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] + " FROM " + PstContactClass.TBL_CONTACT_CLASS + " WHERE " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = " + classType;
        String queryClassAssign = "SELECT " + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " FROM " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN
                + " WHERE " + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] + " IN (" + queryClassType + ")";
        String whereContact = PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " IN (" + queryClassAssign + ")"
                + " AND " + PstAnggota.fieldNames[PstAnggota.FLD_ID_CARD] + " = '" + anggota.getIdCard() + "'"
                + " AND " + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " <> " + anggota.getOID();
        return (PstAnggota.getCount(whereContact) > 0);
    }
}
