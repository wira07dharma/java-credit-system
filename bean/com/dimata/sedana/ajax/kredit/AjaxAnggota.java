/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.kredit;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.aiso.entity.masterdata.anggota.PstVocation;
import com.dimata.aiso.entity.masterdata.anggota.Vocation;
import com.dimata.aiso.form.masterdata.anggota.CtrlAnggota;
import com.dimata.aiso.session.masterdata.SessAnggota;
import com.dimata.common.entity.contact.ContactClass;
import com.dimata.common.entity.contact.ContactClassAssign;
import com.dimata.common.entity.contact.PstContactClass;
import com.dimata.common.entity.contact.PstContactClassAssign;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.anggota.AnggotaBadanUsaha;
import com.dimata.sedana.entity.anggota.PengurusKelompok;
import com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha;
import com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan;
import com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan;
import com.dimata.sedana.entity.assigntabungan.AssignTabungan;
import com.dimata.sedana.entity.assigntabungan.PstAssignTabungan;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.masterdata.MasterTabungan;
import com.dimata.sedana.entity.masterdata.PstAssignContact;
import com.dimata.sedana.entity.masterdata.PstMasterTabungan;
import com.dimata.sedana.entity.tabungan.DataTabungan;
import com.dimata.sedana.entity.tabungan.PstAssignPenarikanTabungan;
import com.dimata.sedana.entity.tabungan.PstDataTabungan;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.form.anggota.CtrlPengurusKelompok;
import com.dimata.sedana.form.masterdata.CtrlAssignContact;
import com.dimata.sedana.session.SessReportTabungan;
import com.dimata.services.WebServices;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Dimata 007
 */
public class AjaxAnggota extends HttpServlet {

    //DATATABLES
    private String searchTerm;
    private String colName;
    private int colOrder;
    private String dir;
    private int start;
    private int amount;

    //OBJECT
    private JSONObject jSONObject = new JSONObject();
    private JSONArray jSONArray = new JSONArray();
    private JSONArray jsonArrayAnggota = new JSONArray();

    //LONG
    private long oid = 0;
    private long oidReturn = 0;
    private long oidKelompok = 0;
    private long oidMasterTabungan = 0;
    private long oidNasabah = 0;
    private long oidPenjaminKredit = 0;
    private long oidLocAssignAO = 0;
    private long oidLocAssignKol = 0;

    //STRING
    private String dataFor = "";
    private String subDataFor = "";
    private String oidDelete = "";
    private String approot = "";
    private String htmlReturn = "";
    private String message = "";
    private String noTabungan = "";
    private String arrayIdNasabah = "";
    private String hrApiUrl = "";

    //BOOLEAN
    private boolean privAdd = false;
    private boolean privUpdate = false;
    private boolean privDelete = false;
    private boolean privView = false;

    //INT
    private int iCommand = 0;
    private int iErrCode = 0;

    private long userId = 0;
    private String userName = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //LONG
        this.oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        this.oidReturn = 0;
        this.oidKelompok = 0;
        this.oidMasterTabungan = FRMQueryString.requestLong(request, "SEND_OID_MASTER_TABUNGAN");
        this.oidNasabah = FRMQueryString.requestLong(request, "SEND_OID_NASABAH");
        this.oidLocAssignAO = FRMQueryString.requestLong(request, "ASSIGN_LOCATION_AO");
        this.oidLocAssignKol = FRMQueryString.requestLong(request, "ASSIGN_LOCATION_KOL");
        this.oidPenjaminKredit = 0;

        //STRING
        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.subDataFor = FRMQueryString.requestString(request, "SUB_FRM_FIELD_DATA_FOR");
        this.oidDelete = FRMQueryString.requestString(request, "FRM_FIELD_OID_DELETE");
        this.approot = FRMQueryString.requestString(request, "FRM_FIELD_APPROOT");
        this.htmlReturn = "";
        this.message = "";
        this.noTabungan = FRMQueryString.requestString(request, "SEND_NO_TABUNGAN");
        this.arrayIdNasabah = FRMQueryString.requestString(request, "SEND_ARRAY_ID_NASABAH");
        this.hrApiUrl = PstSystemProperty.getValueByName("HARISMA_URL");

        //BOOLEAN
        this.privAdd = FRMQueryString.requestBoolean(request, "privadd");
        this.privUpdate = FRMQueryString.requestBoolean(request, "privupdate");
        this.privDelete = FRMQueryString.requestBoolean(request, "privdelete");
        this.privView = FRMQueryString.requestBoolean(request, "privview");

        //INT
        this.iCommand = FRMQueryString.requestCommand(request);
        this.iErrCode = 0;

        //OBJECT
        this.jSONObject = new JSONObject();
        this.jsonArrayAnggota = new JSONArray();

        switch (this.iCommand) {
            case Command.SAVE:
                //history
                commandSave(request);
                break;

            case Command.DELETE:
                commandDelete(request);
                break;

            case Command.LIST:
                commandList(request, response);
                break;

            default:
                commandNone(request);
                break;
        }
        try {
            this.jSONObject.put("FRM_FIELD_HTML", this.htmlReturn);
            this.jSONObject.put("RETURN_DATA_ANGGOTA", this.jsonArrayAnggota);
            this.jSONObject.put("RETURN_MESSAGE", this.message);
            this.jSONObject.put("RETURN_ERROR_CODE", "" + this.iErrCode);
            this.jSONObject.put("RETURN_OID_KELOMPOK", "" + this.oidKelompok);
            this.jSONObject.put("RETURN_OID_PENJAMIN", "" + this.oidPenjaminKredit);

        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }
        response.getWriter().print(this.jSONObject);
    }

    public void commandSave(HttpServletRequest request) {
        if (this.dataFor.equals("saveKelompok")) {
            saveKelompok(request);
        } else if (this.dataFor.equals("savePengurus")) {
            savePengurus(request);
        } else if (this.dataFor.equals("saveTabunganKelompok")) {
            saveTabunganKelompok(request);
        } else if (this.dataFor.equals("savePenjaminKredit")) {
            savePenjaminKredit(request);
        } else if (this.dataFor.equals("saveCustomer")) {
            saveCustomer(request);
        } else if (this.dataFor.equals("updateKolektorBaru")) {
            updateKolektorBaru(request);
        }
    }

    public synchronized void updateKolektorBaru(HttpServletRequest request) {
        try {
            long oidPinjaman = FRMQueryString.requestLong(request, "PINJAMAN_ID");
            long oidKolektor = FRMQueryString.requestLong(request, "NEW_KOLEKTOR_ID");
            this.iErrCode = 0;

            if (oidPinjaman != 0) {
                if (oidKolektor != 0) {
                    Pinjaman p = new Pinjaman();
                    try {
                        p = PstPinjaman.fetchExc(oidPinjaman);
                    } catch (Exception e) {
                        printErrorMessage("Fetch pinjaman di AjaxAnggota " + e.getMessage());
                    }

                    p.setCollectorId(oidKolektor);

                    try {
                        long oid = PstPinjaman.updateExc(p);
                        if (oid != 0) {
                            Employee emp = PstEmployee.fetchFromApi(p.getCollectorId());
                            this.jSONObject.put("FRM_RETURN_KOLEKTOR_NAME", emp.getFullName());
                            this.message = "Kolektor berhasil di update.";
                        }
                    } catch (Exception e) {
                        printErrorMessage("Update pinjaman di AjaxAnggota " + e.getMessage());
                    }

                } else {
                    this.iErrCode = 1;
                    this.message = "Kolektor belum terpilih";
                    return;
                }
            } else {
                this.iErrCode = 1;
                this.message = "Data pinjaman tidak ditemukan.";
                return;
            }

        } catch (Exception e) {
        }
    }

    public synchronized void saveCustomer(HttpServletRequest request) {
        CtrlAnggota ca = new CtrlAnggota(request);
        try {
            iErrCode = ca.Action(iCommand, oid);
            message = ca.getMessage();
            Anggota anggota = ca.getAnggota();
            this.oid = anggota.getOID();
            getDataJenisKredit(request);
        } catch (DBException ex) {
            iErrCode = 1;
            message = ex.toString();
        }
    }

    public synchronized void savePenjaminKredit(HttpServletRequest request) {
        CtrlAnggota ca = new CtrlAnggota(request);
        try {
            iErrCode = ca.ActionPenjaminKredit(iCommand, oid);
            message = ca.getMessage();
            AnggotaBadanUsaha penjamin = ca.getAnggotaBadanUsaha();
            this.oidPenjaminKredit = penjamin.getOID();
        } catch (DBException ex) {
            iErrCode = 1;
            message = ex.toString();
        }
    }

    public synchronized void saveTabunganKelompok(HttpServletRequest request) {
        AssignContactTabungan act = new AssignContactTabungan();
        act.setOID(oid);
        act.setNoTabungan(this.noTabungan);
        act.setContactId(this.oidNasabah);
        act.setMasterTabunganId(this.oidMasterTabungan);
        try {
            if (this.noTabungan.length() == 0) {
                AnggotaBadanUsaha abu = PstAnggotaBadanUsaha.fetchExc(this.oidNasabah);
                MasterTabungan mt = PstMasterTabungan.fetchExc(this.oidMasterTabungan);
                String nomorTabungan = mt.getKodeTabungan() + "-" + abu.getNoAnggota();
                act.setNoTabungan(nomorTabungan);
                int last = 1;
                while (last > 0) {
                    int count = PstAssignContact.getCount(PstAssignContact.fieldNames[PstAssignContact.FLD_NO_TABUNGAN] + " = '" + act.getNoTabungan() + "' AND " + PstAssignContact.fieldNames[PstAssignContact.FLD_ASSIGN_TABUNGAN_ID] + " <> " + this.oid);
                    if (count > 0) {
                        last++;
                        act.setNoTabungan(nomorTabungan + "-" + last);
                    } else {
                        last = 0;
                    }
                }
            } else {
                int count = PstAssignContact.getCount(PstAssignContact.fieldNames[PstAssignContact.FLD_NO_TABUNGAN] + " = '" + this.noTabungan + "' AND " + PstAssignContact.fieldNames[PstAssignContact.FLD_ASSIGN_TABUNGAN_ID] + " <> " + this.oid);
                if (count > 0) {
                    message = "Nomor tabungan sudah ada";
                    iErrCode = 1;
                    return;
                }
            }

            if (oid == 0) {
                long idAssign = PstAssignContactTabungan.insertExc(act);
                //GENERATE AISO DATA TABUNGAN
                if (idAssign != 0) {
                    Vector<AssignTabungan> ats = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + " = " + this.oidMasterTabungan, "");
                    for (AssignTabungan a : ats) {
                        DataTabungan dt = new DataTabungan();
                        dt.setIdAnggota(this.oidNasabah);
                        dt.setIdJenisSimpanan(a.getIdJenisSimpanan());
                        dt.setTanggal(new Date());
                        dt.setStatus(1);
                        dt.setContactIdAhliWaris(this.oidNasabah);
                        dt.setAssignTabunganId(idAssign);
                        long idSimpanan = PstDataTabungan.insertExc(dt);

                        //set id alokasi bunga
                        dt.setIdAlokasiBunga(idSimpanan);

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
                message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
            } else {
                PstAssignContactTabungan.updateExc(act);
                //SET ALOKASI BUNGA
                String idSimpananAll[] = FRMQueryString.requestStringValues(request, "FRM_ID_SIMPANAN_ALL");
                String idSimpananAlokasi[] = FRMQueryString.requestStringValues(request, "FRM_ID_SIMPANAN_ALOKASI");
                CtrlAssignContact ctrlAssignContact = new CtrlAssignContact(request);
                ctrlAssignContact.actionSetAlokasiBunga(idSimpananAll, idSimpananAlokasi);

                //SET TANGGAL TUTUP PERIODE PENARIKAN
                int penarikan = PstAssignPenarikanTabungan.list(0, 0, PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID] + " = " + act.getMasterTabunganId(), null).size();
                if (penarikan > 0) {
                    String tanggalTutup[] = FRMQueryString.requestStringValues(request, "FRM_TANGGAL_TUTUP");
                    ctrlAssignContact.actionSetTanggalTutup(idSimpananAll, tanggalTutup);
                }

                message = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
            }
        } catch (DBException ex) {
            iErrCode = 1;
            message = ex.toString();
        }
    }

    public synchronized void savePengurus(HttpServletRequest request) {
        CtrlPengurusKelompok cpk = new CtrlPengurusKelompok(request);
        cpk.action(iCommand, oid);
        message = cpk.getMessage();
        PengurusKelompok pk = cpk.getPengurusKelompok();
        long idKelompok = pk.getOID();
        if (!message.equals(FRMMessage.getMessage(FRMMessage.MSG_SAVED)) && !message.equals(FRMMessage.getMessage(FRMMessage.MSG_UPDATED))) {
            iErrCode = 1;
        }
    }

    public synchronized void saveKelompok(HttpServletRequest request) {
        CtrlAnggota ca = new CtrlAnggota(request);
        try {
            ca.ActionKelompok(iCommand, oid);
            message = ca.getMessage();
            AnggotaBadanUsaha abu = ca.getAnggotaBadanUsaha();
            this.oidKelompok = abu.getOID();
        } catch (DBException ex) {
            message = ex.toString();
        }
        if (!message.equals(FRMMessage.getMessage(FRMMessage.MSG_SAVED)) && !message.equals(FRMMessage.getMessage(FRMMessage.MSG_UPDATED))) {
            iErrCode = 1;
        }
    }

    public void commandDelete(HttpServletRequest request) {
        if (this.dataFor.equals("deletePengurus")) {
            deletePengurus(request);
        } else if (this.dataFor.equals("deleteTabunganKelompok")) {
            deleteTabungan(request);
        }
    }

    public synchronized void deleteTabungan(HttpServletRequest request) {
        try {
            //PstAssignContactTabungan.deleteExc(oid);
            this.message = cekApakahTabunganSudahPernahDigunakan(this.oid);

            if (this.message.length() == 0) {
                long oidDelete = PstAssignContact.deleteWithCheck(this.oid);
                message = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
            }

        } catch (Exception ex) {
            message = ex.toString();
        }
        if (!message.equals(FRMMessage.getMessage(FRMMessage.MSG_DELETED))) {
            iErrCode = 1;
        }
    }

    public synchronized void deletePengurus(HttpServletRequest request) {
        CtrlPengurusKelompok cpk = new CtrlPengurusKelompok(request);
        cpk.action(iCommand, oid);
        message = cpk.getMessage();
        PengurusKelompok pk = cpk.getPengurusKelompok();
        long idKelompok = pk.getOID();
        if (!message.equals(FRMMessage.getMessage(FRMMessage.MSG_DELETED))) {
            iErrCode = 1;
        }
    }

    public void commandList(HttpServletRequest request, HttpServletResponse response) {
        if (this.dataFor.equals("listNasabah")) {
            String[] cols = {
                PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                PstAnggota.fieldNames[PstAnggota.FLD_TLP],
                PstAnggota.fieldNames[PstAnggota.FLD_HANDPHONE],
                PstAnggota.fieldNames[PstAnggota.FLD_EMAIL],
                PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PERMANENT]
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listKelompok")) {
            String[] cols = {
                PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                PstAnggota.fieldNames[PstAnggota.FLD_TLP],
                PstAnggota.fieldNames[PstAnggota.FLD_EMAIL],
                PstAnggota.fieldNames[PstAnggota.FLD_OFFICE_ADDRESS]
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listIndividu")) {
            String[] cols = {
                PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                PstAnggota.fieldNames[PstAnggota.FLD_SEX],
                PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_PLACE],
                PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_DATE],
                PstAnggota.fieldNames[PstAnggota.FLD_VOCATION_ID],
                PstAnggota.fieldNames[PstAnggota.FLD_HANDPHONE],
                PstAnggota.fieldNames[PstAnggota.FLD_TLP],
                PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PERMANENT]
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listAO")) {
            String[] cols = {
                PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                PstAnggota.fieldNames[PstAnggota.FLD_SEX],
                PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_PLACE],
                PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_DATE],
                PstAnggota.fieldNames[PstAnggota.FLD_VOCATION_ID],
                PstAnggota.fieldNames[PstAnggota.FLD_HANDPHONE],
                PstAnggota.fieldNames[PstAnggota.FLD_TLP],
                PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PERMANENT]
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listKL")) {
            String[] cols = {
                PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                PstAnggota.fieldNames[PstAnggota.FLD_SEX],
                PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_PLACE],
                PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_DATE],
                PstAnggota.fieldNames[PstAnggota.FLD_VOCATION_ID],
                PstAnggota.fieldNames[PstAnggota.FLD_HANDPHONE],
                PstAnggota.fieldNames[PstAnggota.FLD_TLP],
                PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PERMANENT]
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listSelectAo")) {
            String[] cols = {
                "",
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_PHONE],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS],
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listSelectKol")) {
            String[] cols = {
                "",
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_PHONE],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS],
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listAssignKolektor")) {
            String[] cols = {
                "",
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME],
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listEmployee")) {
            String[] cols = {
                "",
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE],
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("select2Anggota")) {
            jSONObject = listSelect2(request, response, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("select2Employee")) {
            jSONObject = listSelect2(request, response, this.dataFor, this.jSONObject);
        }
    }

    public JSONObject listSelect2(HttpServletRequest request, HttpServletResponse response, String dataFor, JSONObject result) {
        this.searchTerm = FRMQueryString.requestString(request, "searchTerm");
        this.start = FRMQueryString.requestInt(request, "limitStart");
        this.amount = FRMQueryString.requestInt(request, "recordToGet");
        JSONObject pagination = new JSONObject();
        
        String whereClause = "";
        String order = "";
        Vector listData = new Vector(1, 1);
        int countData = 0;
        if (this.dataFor.equals("select2Anggota")) {
            whereClause += "("
                    + " cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + this.searchTerm + "%'"
                    + ")"
                    + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                    + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "'";
            order += " cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME];
            listData = SessAnggota.listJoinContactClassAssign(this.start, this.amount, whereClause, order);
            countData = SessAnggota.getCountJoinContactClassAssign(whereClause);
        } else if (this.dataFor.equals("select2Employee")) {
            whereClause += "("
                    + " emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + this.searchTerm + "%'"
                    + ")";
            long posId = 0;
            long aoId = 0;
            long sbkId = 0;
            long locId = FRMQueryString.requestLong(request, "FRM_USER_LOCATION_ID");
            try {
                if(this.subDataFor.equals("kolektor")){
                    long empId = FRMQueryString.requestLong(request, "EMP_AO_ID");
                    if (empId > 0){
                        whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + empId;
                    } else {
                        posId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_KOLEKTOR_OID"));
                        aoId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_ANALIS_OID"));
                        sbkId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_SBK_OID"));
                    }
                } else if(this.subDataFor.equals("user")){ 
                    long empId = FRMQueryString.requestLong(request, "EMP_AO_ID");
                    if (empId > 0){
                        whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + empId;
                    }
                }
            } catch (Exception e) {
                System.out.println("com.dimata.sedana.ajax.kredit.AjaxAnggota.listSelect2() error parsing position id");;
            }
            if(posId != 0 || aoId != 0 || sbkId != 0){
                whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " IN (" + posId+","+aoId+","+sbkId+")";
            }
            if(locId != 0){
                whereClause += " AND dv." + PstDivision.fieldNames[PstDivision.FLD_LOCATION_ID] + " = " + locId;
            }
            order += " emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME];
            listData = PstEmployee.getListFromApi(this.start, this.amount, whereClause, order);
            countData = PstEmployee.getCountFromApi(0, 0, whereClause, "");
        }

        JSONArray array = new JSONArray();
        int countDataFetched = 0;
        for (int i = 0; i < listData.size(); i++) {
            JSONObject temp = new JSONObject();
            if (this.dataFor.equals("select2Anggota")) {
                Anggota a = (Anggota) listData.get(i);
                long id = a.getOID();
                try {
                    if((this.start + i) == 0){
                        String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
                        temp.put("id", 0);
                        temp.put("text", "-- Semua " + namaNasabah + " --");
                        array.put(temp);
                    }
                    temp = new JSONObject();  
                    temp.put("id", String.valueOf(id));
                    temp.put("text", a.getName());
                    array.put(temp);
                } catch (Exception e) {
                    System.out.println("Ajax Anggota | listSelect2Anggota : " + e.getMessage());
                }

            }
            if (this.dataFor.equals("select2Employee")) {
                Employee emp = (Employee) listData.get(i);
                long id = emp.getOID();
                try {
                    if((this.start + i) == 0){
                        temp.put("id", 0);
                        if(this.subDataFor.equals("kolektor")){
                        temp.put("text", "-- Semua Kolektor --");
                        } else {
                            temp.put("text", "-- Semua User --");
                        }
                        array.put(temp);
                    }
                    temp = new JSONObject();  
                    temp.put("id", String.valueOf(id));
                    temp.put("text", emp.getFullName());
                    array.put(temp);
                } catch (Exception e) {
                    System.out.println("Ajax Anggota | listSelect2Kolektor : " + e.getMessage());
                }

            }
            countDataFetched++;
        }
        try {
            
            pagination.put("CURRENT_PAGE", start + countDataFetched);
            pagination.put("ITEM_PER_PAGE", this.amount);
            
            result.put("ANGGOTA_DATA", array);
            result.put("ANGGOTA_TOTAL", countData);
            result.put("PAGINATION_HEADER", pagination);
        } catch (Exception e) {
            System.out.println("Ajax Kredit | listSelect2 : " + e.getMessage());
        }
        
        return result;
    }

    public JSONObject listDataTables(HttpServletRequest request, HttpServletResponse response, String[] cols, String dataFor, JSONObject result) {
        this.searchTerm = FRMQueryString.requestString(request, "sSearch");
        int amount = 10;
        int start = 0;
        int col = 0;
        String dir = "asc";
        String sStart = request.getParameter("iDisplayStart");
        String sAmount = request.getParameter("iDisplayLength");
        String sCol = request.getParameter("iSortCol_0");
        String sdir = request.getParameter("sSortDir_0");

        if (sStart != null) {
            start = Integer.parseInt(sStart);
            if (start < 0) {
                start = 0;
            }
        }
        if (sAmount != null) {
            amount = Integer.parseInt(sAmount);
            if (amount < 10) {
                amount = 10;
            }
        }
        if (sCol != null) {
            col = Integer.parseInt(sCol);
            if (col < 0) {
                col = 0;
            }
        }
        if (sdir != null) {
            if (!sdir.equals("asc")) {
                dir = "desc";
            }
        }

        String whereClause = "";

        if (dataFor.equals("listNasabah")) {
            whereClause += " ("
                    + " cl." + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                    + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                    + ")";
        } else if (dataFor.equals("listKelompok")) {
            if (whereClause.length() > 0) {
                whereClause += ""
                        + "AND ("
                        + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                        + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            } else {
                whereClause += " ("
                        + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                        + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            }
        } else if (dataFor.equals("listIndividu")) {
            if (whereClause.length() > 0) {
                whereClause += ""
                        + "AND ("
                        + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                        + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            } else {
                whereClause += " ("
                        + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                        + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            }
        } else if (dataFor.equals("listAO")) {
            if (whereClause.length() > 0) {
                whereClause += ""
                        + "AND ("
                        + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                        + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            } else {
                whereClause += " ("
                        + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                        + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            }
        } else if (dataFor.equals("listKL")) {
            if (whereClause.length() > 0) {
                whereClause += ""
                        + "AND ("
                        + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                        + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            } else {
                whereClause += " ("
                        + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                        + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            }
        } else if (dataFor.equals("listSelectAo") || dataFor.equals("listSelectKol")) {
            whereClause += " ("
                    + "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%' "
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%' "
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE] + " LIKE '%" + searchTerm + "%' "
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_PHONE] + " LIKE '%" + searchTerm + "%' "
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS] + " LIKE '%" + searchTerm + "%' "
                    + ")";
        } else if (this.dataFor.equals("listAssignKolektor")) {
            whereClause = " ("
                    + "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%'"
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (this.dataFor.equals("listEmployee")) {
            whereClause += " ("
                    + "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%' "
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%' "
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE] + " LIKE '%" + searchTerm + "%' "
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS] + " LIKE '%" + searchTerm + "%' "
                    + ")";
        }
//		else if (dataFor.equals("listSelectKol")) {
//			whereClause += " AND ("
//					+ "" + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%' "
//					+ " OR " + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%' "
//					+ " OR " + PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE] + " LIKE '%" + searchTerm + "%' "
//					+ " OR " + PstEmployee.fieldNames[PstEmployee.FLD_PHONE] + " LIKE '%" + searchTerm + "%' "
//					+ " OR " + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS] + " LIKE '%" + searchTerm + "%' "
//					+ ")";
//		}

        String colName = cols[col];
        int total = -1;

        if (dataFor.equals("listNasabah")) {
            String whereAdd = " AND "
                    + "(cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                    + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "')";
            total = SessAnggota.listJoinContactClassAssign(0, 0, whereClause + whereAdd, null).size();
        } else if (dataFor.equals("listKelompok")) {
            total = SessAnggota.getCountJoinContactClassAssign(whereClause + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "'");
        } else if (dataFor.equals("listIndividu")) {
            total = SessAnggota.getCountJoinContactClassAssign(whereClause + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'");
        } else if (dataFor.equals("listAO")) {
            total = SessAnggota.getCountJoinContactClassAssign(whereClause + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_ACCOUNT_OFFICER + "'");
        } else if (dataFor.equals("listKL")) {
            total = SessAnggota.getCountJoinContactClassAssign(whereClause + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " <> 0 ");
        } else if (dataFor.equals("listSelectAo") || dataFor.equals("listSelectKol")) {
            long tempPosOid = 0;
            long tempDivOid = 0;
            tempPosOid = FRMQueryString.requestLong(request, "POSITION_ID");
            if (dataFor.equals("listSelectAo")) {
                if (this.oidLocAssignAO != 0) {
                    tempDivOid = this.oidLocAssignAO;
                }

            } else if (dataFor.equals("listSelectKol")) {
                if (this.oidLocAssignKol != 0) {
                    tempDivOid = this.oidLocAssignKol;
                }
            }
            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = '" + tempPosOid + "'"
                    + " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            if (tempDivOid != 0) {
                whereClause += " AND dv." + PstDivision.fieldNames[PstDivision.FLD_LOCATION_ID] + " = '" + tempDivOid + "'";
            }
            String param = "limitStart=" + WebServices.encodeUrl("" + 0) + "&recordToGet=" + WebServices.encodeUrl("" + 0)
                    + "&whereClause=" + WebServices.encodeUrl(whereClause) + "&order=" + WebServices.encodeUrl("");
            JSONObject jo = WebServices.getAPIWithParam("", hrApiUrl + "/employee/employee-list", param);
            total = jo.optInt("COUNT");
        } else if (this.dataFor.equals("listAssignKolektor")) {
            long positionId = FRMQueryString.requestLong(request, "POSITION_ID");
            long locationId = FRMQueryString.requestLong(request, "LOKASI_KOLEKTOR");

            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            if (positionId != 0) {
                whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = " + positionId;
            }
            if (locationId != 0) {
                whereClause += " AND dv." + PstDivision.fieldNames[PstDivision.FLD_LOCATION_ID] + " = " + locationId;
            }

            total = PstEmployee.getCountFromApi(0, 0, whereClause, "");

        } else if (this.dataFor.equals("listEmployee")) {
            long positionId = FRMQueryString.requestLong(request, "POSITION_ID");
            long locationId = FRMQueryString.requestLong(request, "LOKASI_ID");

            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            if (positionId != 0) {
                whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = " + positionId;
            }
            if (locationId != 0) {
                whereClause += " AND dv." + PstDivision.fieldNames[PstDivision.FLD_LOCATION_ID] + " = " + locationId;
            }

            total = PstEmployee.getCountFromApi(0, 0, whereClause, "");
        }
//		else if (dataFor.equals("listSelectKol")) {
//			whereClause += " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_ACCOUNT_COLLECTOR + "'"
//					+ " AND cl." + PstAnggota.fieldNames[PstAnggota.FLD_ASSIGN_LOCATION_ID] + "=" + this.oidLocAssignKol;
//			total = SessAnggota.getCountJoinContactClassAssign(whereClause);
//		}

        this.amount = amount;

        this.colName = colName;
        this.dir = dir;
        this.start = start;
        this.colOrder = col;

        try {
            result = getData(total, request, dataFor);
        } catch (Exception ex) {
            printErrorMessage(ex.getMessage());
        }

        return result;
    }

    public JSONObject getData(int total, HttpServletRequest request, String datafor) {
        int totalAfterFilter = total;
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        JSONArray jArr = new JSONArray();
        Anggota anggota = new Anggota();
        int searchType = -1;

        String whereClause = "";
        String order = "";

        if (this.searchTerm == null) {
            whereClause += "";
        } else {
            if (datafor.equals("listNasabah")) {
                whereClause += " ("
                        + " cl." + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            } else if (datafor.equals("listKelompok")) {
                if (whereClause.length() > 0) {
                    whereClause += ""
                            + "AND ("
                            + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                            + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                            + ")";
                } else {
                    whereClause += " ("
                            + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                            + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                            + ")";
                }
            } else if (datafor.equals("listIndividu")) {
                if (whereClause.length() > 0) {
                    whereClause += ""
                            + "AND ("
                            + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                            + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                            + ")";
                } else {
                    whereClause += " ("
                            + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                            + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                            + ")";
                }
            } else if (dataFor.equals("listAO")) {
                if (whereClause.length() > 0) {
                    whereClause += ""
                            + "AND ("
                            + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                            + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                            + ")";
                } else {
                    whereClause += " ("
                            + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                            + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                            + ")";
                }
            } else if (dataFor.equals("listKL")) {
                if (whereClause.length() > 0) {
                    whereClause += ""
                            + "AND ("
                            + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                            + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                            + ")";
                } else {
                    whereClause += " ("
                            + "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
                            + " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
                            + ")";
                }
            } else if (dataFor.equals("listSelectAo") || dataFor.equals("listSelectKol")) {
                whereClause += " ("
                        + " emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%' "
                        + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%' "
                        + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE] + " LIKE '%" + searchTerm + "%' "
                        + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_PHONE] + " LIKE '%" + searchTerm + "%' "
                        + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            } else if (this.dataFor.equals("listAssignKolektor")) {
                whereClause = " ("
                        + "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%'"
                        + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            } else if (this.dataFor.equals("listEmployee")) {
                whereClause += " ("
                        + "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%' "
                        + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%' "
                        + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE] + " LIKE '%" + searchTerm + "%' "
                        + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            }
//			else if (dataFor.equals("listSelectKol")) {
//				if (whereClause.length() > 0) {
//					whereClause += ""
//							+ "AND ("
//							+ "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
//							+ " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
//							+ ")";
//				} else {
//					whereClause += " ("
//							+ "" + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + searchTerm + "%' "
//							+ " OR " + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%' "
//							+ ")";
//				}
//			}
        }

        if (this.colOrder >= 0) {
            order += "" + colName + " " + dir + "";
        }

        Vector listData = new Vector(1, 1);
        if (datafor.equals("listNasabah")) {
            String whereAdd = " AND "
                    + "(cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                    + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "')";
            listData = SessAnggota.listJoinContactClassAssign(start, amount, whereClause + whereAdd, order);
        } else if (datafor.equals("listKelompok")) {
            listData = SessAnggota.listJoinContactClassAssign(start, amount, whereClause + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "'", order);
        } else if (datafor.equals("listIndividu")) {
            listData = SessAnggota.listJoinContactClassAssign(start, amount, whereClause + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'", order);
        } else if (dataFor.equals("listAO")) {
            listData = SessAnggota.listJoinContactClassAssign(start, amount, whereClause + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_ACCOUNT_OFFICER + "'", order);
        } else if (dataFor.equals("listKL")) {
            listData = SessAnggota.listJoinContactClassAssign(start, amount, whereClause + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " <> 0 ", order);
        } else if (dataFor.equals("listSelectAo") || dataFor.equals("listSelectKol")) {
            long tempPosOid = 0;
            long tempDivOid = 0;
            tempPosOid = FRMQueryString.requestLong(request, "POSITION_ID");
            if (dataFor.equals("listSelectAo")) {
                if (this.oidLocAssignAO != 0) {
                    tempDivOid = this.oidLocAssignAO;
                }

            } else if (dataFor.equals("listSelectKol")) {
                if (this.oidLocAssignKol != 0) {
                    tempDivOid = this.oidLocAssignKol;
                }
            }
            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = '" + tempPosOid + "'"
                    + " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            if (tempDivOid != 0) {
                whereClause += " AND dv." + PstDivision.fieldNames[PstDivision.FLD_LOCATION_ID] + " = '" + tempDivOid + "'";
            }
            String param = "limitStart=" + WebServices.encodeUrl("" + start) + "&recordToGet=" + WebServices.encodeUrl("" + amount)
                    + "&whereClause=" + WebServices.encodeUrl(whereClause) + "&order=" + WebServices.encodeUrl(order);
            JSONObject jo = WebServices.getAPIWithParam("", hrApiUrl + "/employee/employee-list", param);
            try {
                jArr = jo.getJSONArray("DATA");
            } catch (Exception e) {
            }
        } else if (this.dataFor.equals("listAssignKolektor")) {
            long positionId = FRMQueryString.requestLong(request, "POSITION_ID");
            long locationId = FRMQueryString.requestLong(request, "LOKASI_KOLEKTOR");
            searchType = FRMQueryString.requestInt(request, "SEARCH_TYPE");
            
            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            if (positionId != 0) {
                whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = " + positionId;
            }
            if (locationId != 0) {
                whereClause += " AND dv." + PstDivision.fieldNames[PstDivision.FLD_LOCATION_ID] + " = " + locationId;
            }

            jArr = PstEmployee.getListEmpDivFromApi(start, amount, whereClause, order);

        } else if (this.dataFor.equals("listEmployee")) {
            long positionId = FRMQueryString.requestLong(request, "POSITION_ID");
            long locationId = FRMQueryString.requestLong(request, "LOKASI_ID");

            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            if (positionId != 0) {
                whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = " + positionId;
            }
            if (locationId != 0) {
                whereClause += " AND dv." + PstDivision.fieldNames[PstDivision.FLD_LOCATION_ID] + " = " + locationId;
            }

            jArr = PstEmployee.getListEmpDivFromApi(start, amount, whereClause, order);
        }
//		else if (dataFor.equals("listSelectAo")) {
//			whereClause += " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_ACCOUNT_OFFICER + "'"
//					+ " AND cl." + PstAnggota.fieldNames[PstAnggota.FLD_ASSIGN_LOCATION_ID] + "=" + this.oidLocAssignAO;
//			listData = SessAnggota.listJoinContactClassAssign(start, amount, whereClause, order);
//		} else if (dataFor.equals("listSelectKol")) {
//			whereClause += " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_ACCOUNT_COLLECTOR + "'"
//					+ " AND cl." + PstAnggota.fieldNames[PstAnggota.FLD_ASSIGN_LOCATION_ID] + "=" + this.oidLocAssignKol;
//			listData = SessAnggota.listJoinContactClassAssign(start, amount, whereClause, order);
//		}

        for (int i = 0; i <= listData.size() - 1; i++) {
            JSONArray ja = new JSONArray();
            if (datafor.equals("listNasabah")) {
                anggota = (Anggota) listData.get(i);
                ja.put("" + (this.start + i + 1) + ".");
                ja.put("<a href='#' class='no-anggota' data-oid='" + anggota.getOID() + "'>" + anggota.getNoAnggota() + "</a>");
                ja.put("" + anggota.getName());
                ja.put("" + anggota.getTelepon());
                ja.put("" + anggota.getHandPhone());
                ja.put("" + anggota.getEmail());
                ja.put("" + anggota.getAddressPermanent());
                ja.put("<div class='text-center'><button class='btn btn-xs btn-warning no-anggota' data-oid='" + anggota.getOID() + "'>Pilih</button></div>");
                array.put(ja);
            } else if (datafor.equals("listKelompok")) {
                anggota = (Anggota) listData.get(i);
                ja.put("" + (this.start + i + 1) + ".");
                ja.put("<a class='btn_detail' data-oid='" + anggota.getOID() + "'>" + anggota.getNoAnggota() + "</a>");
                ja.put("" + anggota.getName());
                ja.put("" + anggota.getTelepon());
                ja.put("" + anggota.getEmail());
                ja.put("" + anggota.getAddressPermanent());
                ja.put("<div class='text-center'><button class='btn btn-xs btn-warning btn_detail' data-oid='" + anggota.getOID() + "'><i class='fa fa-pencil'></i></button></div>");
                array.put(ja);
            } else if (datafor.equals("listIndividu")) {
                anggota = (Anggota) listData.get(i);
                Vocation vocation = new Vocation();
                try {
                    vocation = PstVocation.fetchExc(anggota.getVocationId());
                } catch (Exception exc) {

                }
                ja.put("" + (this.start + i + 1) + ".");
                ja.put("" + anggota.getNoAnggota());
                ja.put("" + anggota.getName());
                ja.put("" + PstAnggota.sexKey[0][anggota.getSex()]);
                ja.put("" + anggota.getBirthPlace());
                ja.put("" + Formater.formatDate(anggota.getBirthDate(), "dd-MM-yyyy"));
                ja.put("" + vocation.getVocationName());
                ja.put("" + anggota.getHandPhone());
                ja.put("" + anggota.getTelepon());
                ja.put("" + anggota.getAddressPermanent());
                ja.put("<a class='btn-edit btn btn-xs btn-warning' href='javascript:cmdEdit(\"" + anggota.getOID() + "\")'><i class='fa fa-pencil'></i></a>");
                array.put(ja);
            } else if (datafor.equals("listAO")) {
                anggota = (Anggota) listData.get(i);
                Vocation vocation = new Vocation();
                try {
                    vocation = PstVocation.fetchExc(anggota.getVocationId());
                } catch (Exception exc) {

                }
                ja.put("" + (this.start + i + 1) + ".");
                ja.put("" + anggota.getNoAnggota());
                ja.put("" + anggota.getName());
                ja.put("" + PstAnggota.sexKey[0][anggota.getSex()]);
                ja.put("" + anggota.getBirthPlace());
                ja.put("" + Formater.formatDate(anggota.getBirthDate(), "dd-MM-yyyy"));
                ja.put("" + vocation.getVocationName());
                ja.put("" + anggota.getHandPhone());
                ja.put("" + anggota.getTelepon());
                ja.put("" + anggota.getAddressPermanent());
                ja.put("<a class='btn-edit btn btn-xs btn-warning' href='javascript:cmdEdit(\"" + anggota.getOID() + "\")'><i class='fa fa-pencil'></i></a>");
                array.put(ja);
            } else if (datafor.equals("listKL")) {
                anggota = (Anggota) listData.get(i);
                String whereContact = PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " = " + anggota.getOID();
                Vector listContactAssign = PstContactClassAssign.list(0, 0, whereContact, "");
                for (int id = 0; id < listContactAssign.size(); id++) {
                    ContactClassAssign contactClassAssign = (ContactClassAssign) listContactAssign.get(id);
                    Vocation vocation = new Vocation();
                    ContactClass contactClass = new ContactClass();
                    try {
                        vocation = PstVocation.fetchExc(anggota.getVocationId());
                        contactClass = PstContactClass.fetchExc(contactClassAssign.getContactClassId());
                    } catch (Exception exc) {

                    }
                    ja.put("" + (this.start + i + 1) + ".");
                    ja.put("" + anggota.getNoAnggota());
                    ja.put("" + anggota.getName());
                    ja.put("" + PstAnggota.sexKey[0][anggota.getSex()]);
                    ja.put("" + anggota.getBirthPlace());
                    ja.put("" + Formater.formatDate(anggota.getBirthDate(), "dd-MM-yyyy"));
                    ja.put("" + vocation.getVocationName());
                    ja.put("" + anggota.getHandPhone());
                    ja.put("" + anggota.getTelepon());
                    ja.put("" + anggota.getAddressPermanent());
                    ja.put("" + contactClass.getClassName());
                    ja.put("<a class='btn-edit btn btn-xs btn-warning' href='javascript:cmdEdit(\"" + anggota.getOID() + "\")'><i class='fa fa-pencil'></i></a>");
                    array.put(ja);
                }
            }
//			else if (datafor.equals("listSelectAo")) {
//				anggota = (Anggota) listData.get(i);
//				Vocation vocation = new Vocation();
//				Location assLoc = new Location();
//				try {
//					vocation = PstVocation.fetchExc(anggota.getVocationId());
//					assLoc = PstLocation.fetchExc(anggota.getAssignLocation());
//				} catch (Exception exc) {
//
//				}
//				ja.put("<div class=\"text-center\">" + (this.start + i + 1) + ". </div>");
//				ja.put("" + anggota.getNoAnggota());
//				ja.put("" + anggota.getName());
//				ja.put("" + assLoc.getName());
//				ja.put("" + anggota.getHandPhone());
//				ja.put("" + anggota.getEmail());
//				ja.put("" + anggota.getAddressPermanent());
//				ja.put("<div class=\"text-center\"><button class='btn-edit btn btn-sm btn-primary btn-select-ao' data-name=\"" + anggota.getName() + "\" value=\"" + anggota.getOID() + "\"'><i class='fa fa-pencil'></i></button></div>");
//				array.put(ja);
//			} else if (datafor.equals("listSelectKol")) {
//				anggota = (Anggota) listData.get(i);
//				Vocation vocation = new Vocation();
//				try {
//					vocation = PstVocation.fetchExc(anggota.getVocationId());
//				} catch (Exception exc) {
//
//				}
//				Location assLoc = PstLocation.fetchExc(anggota.getAssignLocation());
//				ja.put("<div class=\"text-center\">" + (this.start + i + 1) + ". </div>");
//				ja.put("" + anggota.getNoAnggota());
//				ja.put("" + anggota.getName());
//				ja.put("" + assLoc.getName());
//				ja.put("" + anggota.getHandPhone());
//				ja.put("" + anggota.getEmail());
//				ja.put("" + anggota.getAddressPermanent());
//				ja.put("<div class=\"text-center\"><button class='btn-edit btn btn-sm btn-primary btn-select-kolektor' data-name=\"" + anggota.getName() + "\" value=\"" + anggota.getOID() + "\"'><i class='fa fa-pencil'></i></button></div>");
//				array.put(ja);
//			}
        }

        if (jArr.length() > 0) {
            for (int i = 0; i < jArr.length(); i++) {
                try {
                    JSONArray temp = jArr.optJSONArray(i);
                    JSONObject tempObj = temp.getJSONObject(0);
                    JSONArray ja = new JSONArray();
                    if (datafor.equals("listSelectAo") || datafor.equals("listSelectKol")) {
                        String btnClass = "";
                        if (datafor.equals("listSelectAo")) {
                            btnClass = "btn-select-ao";
                        } else if (datafor.equals("listSelectKol")) {
                            btnClass = "btn-select-kolektor";
                        }
                        ja.put("<div class='text-center'>" + (this.start + i + 1) + "</div>");
                        ja.put("<div class='text-center'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM], "-") + "</div>");
                        ja.put("<div class='text-left'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-") + "</div>");
                        ja.put("<div class='text-center'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE], "-") + "</div>");
                        ja.put("<div class='text-center'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_PHONE], "-") + "</div>");
                        ja.put("<div class='text-left'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS], "-") + "</div>");
                        String button = "<div class='text-center'>"
                                + "<button type='button' title='Pilih' "
                                + "class='btn btn-sm btn-success " + btnClass + "'"
                                + "data-name='" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]) + "'"
                                + "value='" + tempObj.optLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]) + "'>"
                                + "<i class='fa fa-check'></i>"
                                + "</button>"
                                + "</div>";
                        ja.put(button);
                        array.put(ja);
                    } else if (datafor.equals("listAssignKolektor")) {
                        ja.put("<div class='text-center'>" + (this.start + i + 1) + "</div>");
                        ja.put("<div class='text-center'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM], "-") + "</div>");
                        ja.put("<div class='text-left'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-") + "</div>");
                        String btnClass = "";
                        if(searchType >= 0){
                            if(searchType == 1){
                                btnClass = "select-kolektor";
                            } else if (searchType == 0){
                                btnClass = "pilih-kolektor";
                            }
                        }
                        String button = "<div class='text-center'>"
                                + "<button type='button'"
                                + "class='btn btn-sm btn-warning " + btnClass + "'"
                                + "data-name='" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]) + "'"
                                + "value='" + tempObj.optLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]) + "'>"
                                + "<i class='fa fa-check'></i>&nbsp; Pilih"
                                + "</button>"
                                + "</div>";
                        ja.put(button);
                        array.put(ja);
                    } else if (datafor.equals("listEmployee")) {
                        ja.put("<div class='text-center'>" + (this.start + i + 1) + "</div>");
                        ja.put("<div class='text-center'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM], "-") + "</div>");
                        ja.put("<div class='text-left'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-") + "</div>");
                        ja.put("<div class='text-left'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS], "-") + "</div>");
//                        ja.put("<div class='text-left'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE], "-") + "</div>");
                        String button = "<div class='text-center'>"
                                + "<button type='button'"
                                + "class='btn btn-sm btn-warning pilih-pegawai'"
                                + "data-name='" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]) + "'"
                                + "value='" + tempObj.optLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]) + "'>"
                                + "<i class='fa fa-check'></i>&nbsp; Pilih"
                                + "</button>"
                                + "</div>";
                        ja.put(button);
                        array.put(ja);
                    }
                } catch (Exception e) {
                }
            }
        }

        totalAfterFilter = total;
        try {
            result.put("iTotalRecords", total);
            result.put("iTotalDisplayRecords", totalAfterFilter);
            result.put("aaData", array);
        } catch (Exception e) {

        }
        return result;
    }

    public void commandNone(HttpServletRequest request) {
        if (this.dataFor.equals("getDataAnggota")) {
            getDataJenisKredit(request);
        } else if (this.dataFor.equals("getOptionNasabah")) {
            getOptionNasabah(request);
        }
    }

    public void printErrorMessage(String errorMessage) {
        System.out.println("");
        System.out.println("========================================>>> WARNING <<<========================================");
        System.out.println("");
        System.out.println("MESSAGE : " + errorMessage);
        System.out.println("");
        System.out.println("========================================<<< * * * * >>>========================================");
        System.out.println("");
    }

    public void getOptionNasabah(HttpServletRequest request) {
        String html = "";
        String where = "";
        if (this.arrayIdNasabah.equals("all")) {
            where += "(cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                    + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "')";
        }/* else if (this.arrayIdNasabah.equals("null")) {
            where += "(cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                    + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "')";
        }*/ else {
            where += "(";
            String[] arrayId = this.arrayIdNasabah.split(",");
            for (int i = 0; i < arrayId.length; i++) {
                if (i > 0) {
                    where += " OR ";
                }
                where += "cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + arrayId[i] + "'";
            }
            where += ")";
        }
        Vector listNasabah = SessAnggota.listJoinContactClassAssign(0, 0, where, "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " ASC ");
        for (int i = 0; i < listNasabah.size(); i++) {
            Anggota a = (Anggota) listNasabah.get(i);
            html += "<option value='" + a.getOID() + "'>" + a.getName() + "</option>";
        }
        this.htmlReturn = html;
    }

    public void getDataJenisKredit(HttpServletRequest request) {
        message = "";

        Anggota anggota = new Anggota();
        try {
            anggota = PstAnggota.fetchExc(oid);
            PstAnggota.addressAnggotaGeo(anggota);
        } catch (Exception e) {
            message = e.toString();
        }

        if (message.equals("")) {
            JSONObject jo = new JSONObject();
            try {
                jo.put("anggota_id", "" + anggota.getOID());
                jo.put("anggota_number", "" + anggota.getNoAnggota());
                jo.put("anggota_name", "" + anggota.getName());
                jo.put("anggota_address", "" + anggota.getAddressPermanent());

                // tambahan data untuk penjamin.jsp
                jo.put("anggota_gender", "" + anggota.getSex());
                jo.put("anggota_birth_place", "" + anggota.getBirthPlace());
                jo.put("anggota_birth_date", "" + Formater.formatDate(anggota.getBirthDate(), "yyyy-MM-dd"));
                jo.put("anggota_geo_address", "" + anggota.getGeoAddressPermanent());
                jo.put("anggota_telpon", "" + anggota.getTelepon());
                jo.put("anggota_handphone", "" + anggota.getHandPhone());
                jo.put("anggota_email", "" + anggota.getEmail());
                jo.put("anggota_id_card", "" + anggota.getIdCard());
                jo.put("anggota_expired_id", "" + Formater.formatDate(anggota.getExpiredDateKtp(), "yyyy-MM-dd"));
                jo.put("anggota_vocation", "" + anggota.getVocationId());
                jo.put("anggota_position_id", "" + anggota.getPositionId());
                jo.put("anggota_office_addrs", "" + anggota.getOfficeAddress());
                jo.put("anggota_office_city", "" + anggota.getAddressOfficeCity());
                jo.put("anggota_npwp", "" + anggota.getNoNpwp());
                // tambahan untuk geo address
                jo.put("anggota_province", "" + anggota.getAddressProvinceId());
                jo.put("anggota_city", "" + anggota.getAddressCityPermanentId());
                jo.put("anggota_regency", "" + anggota.getAddressPermanentRegencyId());
                jo.put("anggota_subregency", "" + anggota.getAddressPermanentSubRegencyId());
                jo.put("anggota_ward", "" + anggota.getWardId());
                jsonArrayAnggota.put(jo);
            } catch (JSONException ex) {
                message = ex.toString();
            }
        }
    }

    public String cekApakahTabunganSudahPernahDigunakan(long idAssignContactTabungan) {
        String msg = "";
        //get data simpanan yg dimiliki oleh nomor tabungan
        Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + idAssignContactTabungan, null);
        for (DataTabungan dt : listSimpanan) {
            //cek apakah id simpanan pernah digunakan untuk mengajukan kredit
            String where = PstPinjaman.fieldNames[PstPinjaman.FLD_ASSIGN_TABUNGAN_ID] + " = " + idAssignContactTabungan
                    + " OR " + PstPinjaman.fieldNames[PstPinjaman.FLD_WAJIB_ID_JENIS_SIMPANAN] + " = " + dt.getOID();
            Vector listPinjaman = PstPinjaman.list(0, 0, where, null);
            if (!listPinjaman.isEmpty()) {
                msg = "Tidak dapat menghapus data. Nomor tabungan ini sudah digunakan untuk pengajuan kredit.";
                break;
            }
            //cek apakah id simpanan pernah punya transaksi setoran/penarikan tabungan
            Vector listDetail = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN] + " = " + dt.getOID(), null);
            if (!listDetail.isEmpty()) {
                msg = "Tidak dapat menghapus data. Nomor tabungan ini sudah memiliki transaksi tabungan.";
                break;
            }
        }
        return msg;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
