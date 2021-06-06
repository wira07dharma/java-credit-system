/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.kredit;

import com.dimata.aiso.entity.admin.AppGroup;
import com.dimata.aiso.entity.admin.AppObjInfo;
import com.dimata.aiso.entity.admin.AppUser;
import com.dimata.aiso.entity.admin.PstAppUser;
import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit;
import com.dimata.aiso.entity.masterdata.region.PstRegency;
import com.dimata.aiso.entity.masterdata.region.Regency;
import com.dimata.aiso.form.masterdata.mastertabungan.FrmJenisKredit;
import com.dimata.aiso.session.admin.SessAppUser;
import com.dimata.aiso.session.admin.SessUserSession;
import com.dimata.aiso.session.masterdata.SessAnggota;
import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactClass;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.common.entity.custom.PstDataCustom;
import com.dimata.common.entity.location.Kabupaten;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstKabupaten;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.common.entity.payment.PaymentSystem;
import com.dimata.common.entity.payment.PstPaymentSystem;
import com.dimata.common.entity.payment.PstStandartRate;
import com.dimata.common.entity.payment.StandartRate;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.common.session.convert.ConvertAngkaToHuruf;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.interfaces.docstatus.I_DocStatus;
import com.dimata.pos.entity.billing.BillMain;
import com.dimata.pos.entity.billing.Billdetail;
import com.dimata.pos.entity.billing.PstBillDetail;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.pos.form.billing.CtrlBillMain;
import com.dimata.pos.form.billing.FrmBillMain;
import com.dimata.posbo.entity.admin.PstUserGroup;
import com.dimata.posbo.entity.masterdata.Material;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import com.dimata.posbo.entity.masterdata.PstSales;
import com.dimata.posbo.entity.masterdata.Sales;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.ajax.tabungan.AjaxTabungan;
import com.dimata.sedana.common.AjaxHelper;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.analisakredit.AnalisaKreditMain;
import com.dimata.sedana.entity.analisakredit.PstAnalisaKreditMain;
import com.dimata.sedana.entity.anggota.AnggotaBadanUsaha;
import com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha;
import com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan;
import com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan;
import com.dimata.sedana.entity.assignsumberdana.AssignSumberDana;
import com.dimata.sedana.entity.assignsumberdana.PstAssignSumberDana;
import com.dimata.sedana.entity.assigntabungan.AssignTabungan;
import com.dimata.sedana.entity.assigntabungan.PstAssignTabungan;
import com.dimata.sedana.entity.kredit.Agunan;
import com.dimata.sedana.entity.kredit.AgunanMapping;
import com.dimata.sedana.entity.kredit.Angsuran;
import com.dimata.sedana.entity.kredit.AngsuranPayment;
import com.dimata.sedana.entity.kredit.HapusKredit;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.MappingDendaPinjaman;
import com.dimata.sedana.entity.kredit.Penjamin;
import com.dimata.sedana.entity.kredit.Pinjaman;
import static com.dimata.sedana.entity.kredit.Pinjaman.STATUS_DOC_DRAFT;
import com.dimata.sedana.entity.kredit.PinjamanSumberDana;
import com.dimata.sedana.entity.kredit.PstAgunan;
import com.dimata.sedana.entity.kredit.PstAgunanMapping;
import com.dimata.sedana.entity.kredit.PstAngsuran;
import com.dimata.sedana.entity.kredit.PstAngsuranPayment;
import com.dimata.sedana.entity.kredit.PstHapusKredit;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstMappingDendaPinjaman;
import com.dimata.sedana.entity.kredit.PstPenjamin;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.kredit.PstPinjamanSumberDana;
import com.dimata.sedana.entity.kredit.PstReturnKredit;
import com.dimata.sedana.entity.kredit.PstReturnKreditItem;
import com.dimata.sedana.entity.kredit.PstTypeKredit;
import com.dimata.sedana.entity.kredit.ReturnKredit;
import com.dimata.sedana.entity.kredit.ReturnKreditItem;
import com.dimata.sedana.entity.kredit.TypeKredit;
import com.dimata.sedana.entity.masterdata.BiayaTransaksi;
import com.dimata.sedana.entity.masterdata.CashTeller;
import com.dimata.sedana.entity.masterdata.JangkaWaktu;
import com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran;
import com.dimata.sedana.entity.masterdata.MasterLoket;
import com.dimata.sedana.entity.masterdata.MasterTabungan;
import com.dimata.sedana.entity.masterdata.PstBiayaTransaksi;
import com.dimata.sedana.entity.masterdata.PstCashTeller;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktu;
import com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran;
import com.dimata.sedana.entity.masterdata.PstMasterLoket;
import com.dimata.sedana.entity.masterdata.PstMasterTabungan;
import com.dimata.sedana.entity.masterdata.PstSedanaShift;
import com.dimata.sedana.entity.masterdata.SedanaShift;
import com.dimata.sedana.entity.penjamin.PersentaseJaminan;
import com.dimata.sedana.entity.penjamin.PstPersentaseJaminan;
import com.dimata.sedana.entity.sumberdana.PstSumberDana;
import com.dimata.sedana.entity.sumberdana.SumberDana;
import com.dimata.sedana.entity.tabungan.DataTabungan;
import com.dimata.sedana.entity.tabungan.DetailTransaksi;
import com.dimata.sedana.entity.tabungan.JenisSimpanan;
import com.dimata.sedana.entity.tabungan.JenisTransaksi;
import com.dimata.sedana.entity.tabungan.JenisTransaksiMapping;
import com.dimata.sedana.entity.tabungan.PstDataTabungan;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisSimpanan;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksiMapping;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksiPayment;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.sedana.entity.tabungan.TransaksiPayment;
import com.dimata.sedana.form.kredit.CtrlPinjaman;
import com.dimata.sedana.form.kredit.FrmPinjaman;
import com.dimata.sedana.form.masterdata.CtrlAssignContact;
import com.dimata.sedana.session.SessAutoCode;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.SessKredit;
import com.dimata.sedana.session.SessReportKredit;
import com.dimata.sedana.session.SessReportTabungan;
import com.dimata.sedana.session.kredit.SessKreditKalkulasi;
import com.dimata.services.WebServices;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.Vector;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Dimata 007
 */
public class AjaxKredit extends HttpServlet {

    private SessUserSession getUserSession(HttpServletRequest request){
        HttpSession session = request.getSession();
        Cookie[] cookies = request.getCookies();
        String sessionId = "";
        if(cookies !=null){
            for(Cookie cookie : cookies){
                    if(cookie.getName().equals("JSESSIONID")) sessionId = cookie.getValue();
                    //session.putValue(sessionId, userSess);
            }
        }
        
        SessUserSession userSession = (SessUserSession) session.getValue(sessionId);
        
        return userSession;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

       
        // OBJECT
        JSONArray jsonArrayJenisKredit = new JSONArray();
        JSONArray jsonArrayDataKredit = new JSONArray();
        JSONArray jsonArrayPrintValue = new JSONArray();
        JSONArray jSONArray = new JSONArray();
        JSONObject jSONObject = new JSONObject();

        String dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        
        int iCommand = FRMQueryString.requestCommand(request);
        
        
        boolean sessLogin = false;
        boolean privAccept = false;
        Vector listUserGroup = new Vector();
        SessUserSession userSession = getUserSession(request);
        if (userSession != null) {
            if (userSession.isLoggedIn()) {
                sessLogin = true;
                int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_PENILAIAN_KREDIT);
                privAccept = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ACCEPT));
                String userGroupAdmin = PstSystemProperty.getValueByName("GROUP_ADMIN_OID");
                String whereUserGroup = PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + "=" + userGroupAdmin
                        + " AND " + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "=" + userSession.getAppUser().getOID();
                listUserGroup = PstUserGroup.list(0, 0, whereUserGroup, "");
            }
        }

        JSONObject objValue = new JSONObject();
        try {
            if (sessLogin == true) {
                objValue.put("FRM_FIELD_HTML", "");
                objValue.put("RETURN_DATA_JENIS_KREDIT", new JSONArray());
                objValue.put("RETURN_DATA_KREDIT", new JSONArray());
                objValue.put("RETURN_PRINT_VALUE", new JSONArray());
                objValue.put("RETURN_DATA_ARRAY", new JSONArray());
                objValue.put("RETURN_SESSION_LOGIN", sessLogin);
                objValue.put("RETURN_DATA_OID_PINJAMAN", "" + 0);
                objValue.put("RETURN_DATA_OID_ANGGOTA", "" + 0);
                objValue.put("RETURN_ERROR_CODE", "" + 0);
                objValue.put("RETURN_MESSAGE", "");
                objValue.put("RETURN_OID_PAYMENT_TYPE", "" + 0);
                objValue.put("RETURN_NOMOR_TRANSAKSI", "");
                objValue.put("RETURN_PAYMENT_TYPE", "" +0);
                objValue.put("RETURN_DATA_OPEN_TRANSACTION", "" + 0);
                objValue.put("RETURN_APPROVAL", "" + false);
                objValue.put("RETURN_BILL_MAIN_ID", "" + 0);
                switch (iCommand) {
                    case Command.SAVE:
                        objValue = commandSave(request, dataFor, objValue);
                        break;

                    case Command.DELETE:
                        objValue = commandDelete(request, dataFor, objValue);
                        break;

                    case Command.LIST:
                        objValue = commandList(request, response, dataFor, objValue);
                        break;

                    default:
                        objValue = commandNone(request, dataFor, objValue);
                        break;
                }
            } else {
                objValue.put("RETURN_ERROR_CODE", "1");
                objValue.put("message ", "Sesi login Anda telah berakhir. Silakan login ulang untuk melanjutkan.");
            }
        } catch (Exception exc){}
        
        response.getWriter().print(objValue);

    }

    //COMMAND SAVE==============================================================
    public JSONObject commandSave(HttpServletRequest request, String dataFor, JSONObject objValue) throws JSONException{
        if (dataFor.equals("saveKredit")) {
            objValue = cekValidasiDataKredit(request, objValue);
        } else if (dataFor.equals("saveKreditAction")) {
            objValue = savePenilaianKredit(request, objValue);
            saveHistoryKredit(request, "Update Data", objValue);
        } else if (dataFor.equals("toProduction")) {
            objValue = toProduction(request, objValue);
            saveHistoryKredit(request, "Update Data", objValue);
        } else if (dataFor.equals("cairkanKredit")) {
            objValue = pencairanKredit(request, objValue);
            saveHistoryKredit(request, "Update Data", objValue);
        } else if (dataFor.equals("kirimPengajuan")) {
            objValue = kirimPengajuan(request, objValue);
        } else if (dataFor.equals("pembayaranAngsuran")) {
            objValue = cekValidasiBayar(request, objValue);
        } else if (dataFor.equals("saveBiayaDinamis")) {
            objValue = saveDetailKredit(request, objValue);
        } else if (dataFor.equals("bayarSeluruhAngsuranBunga")) {
            request.setAttribute("dataFor", "bayarSeluruhAngsuranBunga");
            objValue = cekValidasiBayar(request, objValue);
        } else if (dataFor.equals("backStatusKreditDraft")) {
            objValue = backStatusKreditDraft(request, objValue);
        } else if (dataFor.equals("saveTabungan")) {
            objValue = saveTabungan(request, objValue);
        } else if (dataFor.equals("cekPenutupanKredit")) {
            objValue = penutupanKredit(request, objValue);
        } else if (dataFor.equals("saveNewSchedule")) {
            objValue = saveNewSchedule(request, objValue);
        } else if (dataFor.equals("penarikanDanaPencairan")) {
            objValue = createPenarikanForPencairanKredit(request, objValue);
        } else if (dataFor.equals("backStatusKreditCair")) {
            objValue = backStatusKreditCair(request, objValue);
        } else if (dataFor.equals("reScheduleJadwalAngsuran")) {
            objValue = reScheduleJadwalAngsuran(request, objValue);
        } else if (dataFor.equals("generateBungaKreditUntilNow")) {
            objValue = generateBungaKreditUntilNow(request, objValue);
        } else if (dataFor.equals("saveSimulasiPengajuan")) {
            objValue = saveSimulasiPengajuan(request, objValue);
        } else if (dataFor.equals("saveKreditReturn")) {
            objValue = saveKreditReturn(request, objValue);
        } else if (dataFor.equals("saveKreditExchange")) {
            objValue = saveKreditExchange(request, objValue);
        } else if (dataFor.equals("tutupTransaksiKredit")) {
            objValue = tutupTransaksiKredit(request, objValue);
        } else if (dataFor.equals("toggleStatusDenda")) {
            objValue = toggleStatusDenda(request, objValue);
        } else if (dataFor.equals("saveKreditHapus")){
            objValue = saveKreditHapus(request, objValue);
        }
        return objValue;
    }

    public synchronized JadwalAngsuran getJadwalBungaTerakhir(Pinjaman p) throws DBException {
        String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + "'";
        Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 1, whereJadwal, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " DESC ");
        if (!listJadwal.isEmpty()) {
            return listJadwal.get(0);
        }
        return new JadwalAngsuran();
    }

    public synchronized JSONObject tutupTransaksiKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        boolean privApprove = FRMQueryString.requestBoolean(request, "privApprove");
        if (privApprove) {
            try {
                String[] listTransaksi = request.getParameterValues("MULTI_TRANSAKSI_ID");
                ArrayList<Long> listOidRes = new ArrayList<>();
                if (listTransaksi != null && listTransaksi.length > 0) {
                    for (String oidStr : listTransaksi) {
                        long oid = Long.parseLong(oidStr);
                        Transaksi t = new Transaksi();
                        if (oid != 0) {
                            t = PstTransaksi.fetchExc(oid);
                            t.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                            Vector<Transaksi> childList = PstTransaksi.list(0, 0, PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_PARENT_ID] + " = " + t.getOID(), "");
                            try {
                                long oidRes = PstTransaksi.updateExc(t);
                                listOidRes.add(oidRes);
                                for (Transaksi ct : childList) {
                                    ct.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                                    try {
                                        oidRes = PstTransaksi.updateExc(ct);
                                        listOidRes.add(oidRes);
                                    } catch (Exception e) {
                                    }
                                }
                            } catch (Exception e) {
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", "Terjadi kesalah saat update data.\n" + e.getMessage());
                            }
                        }
                    }
                    if (!listOidRes.isEmpty()) {
                        objValue.put("RETURN_MESSAGE", "Transaksi yang terpilih berhail di tutup.");
                    }
                } else {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Tidak ada data terpilih.");
                }
            } catch (Exception e) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Terjadi sebuah kesalahan.\n" + e.getMessage());
            }
        } else {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", "Tidak memiliki akses untuk melakukan perintah ini.");
        }
        return objValue;
    }

    public synchronized JSONObject toggleStatusDenda(HttpServletRequest request, JSONObject objValue) throws JSONException{
        int statusDenda = FRMQueryString.requestInt(request, "FRM_FIELD_STATUS_DENDA");
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        Pinjaman p = new Pinjaman();
        try {
            p = PstPinjaman.fetchExc(oid);
            p.setStatusDenda(statusDenda);
            long oidRes = PstPinjaman.updateExc(p);

            if (oidRes == 0) {
                objValue.put("RETURN_ERROR_CODE", 1);
            }
            objValue.put("RETURN_MESSAGE", "Status denda " + (oidRes == 0 ? "gagal" : "berhasil") + " di ubah."
                    + "\nStatus denda " + p.getNoKredit() + " : " + Pinjaman.STATUS_DENDA_TITLE[p.getStatusDenda()]);

        } catch (Exception e) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", "Terjadi sebuah kesalahan.\n" + e.getMessage());
        }
        return objValue;
    }

    public synchronized long createTransaksiPencatatanBungaKreditTambahan(Pinjaman p, HttpServletRequest request) throws DBException {
        long oidTransaksi = 0;
        long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        Date tglTransaksi = new Date();
        String kodeTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_BUNGA_TAMBAHAN, Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN, tglTransaksi);
        Transaksi t = new Transaksi();
        t.setTanggalTransaksi(tglTransaksi);
        t.setKodeBuktiTransaksi(kodeTransaksi);
        t.setIdAnggota(p.getAnggotaId());
        t.setTellerShiftId(oidTellerShift);
        t.setKeterangan(Transaksi.USECASE_TYPE_TITLE.get(Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN));
        t.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
        t.setUsecaseType(Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN);
        t.setPinjamanId(p.getOID());
        oidTransaksi = PstTransaksi.insertExc(t);
        return oidTransaksi;
    }

    public synchronized JSONObject generateBungaKreditUntilNow(HttpServletRequest request, JSONObject objValue) throws JSONException{
        try {
            //CARI SEMUA DATA KREDIT DENGAN STATUS CAIR
            String whereKredit = PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'";
            //whereKredit += " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = '576462193133417413'";
            Vector<Pinjaman> listKreditCair = PstPinjaman.list(0, 0, whereKredit, "");
            int bungaGenerated = 0;
            for (Pinjaman p : listKreditCair) {
                //CARI JADWAL BUNGA TERAKHIR
                JadwalAngsuran ja = getJadwalBungaTerakhir(p);
                if (ja.getOID() != 0) {
                    //COMPARE TANGGAL JADWAL BUNGA TERAKHIR DENGAN TANGGAL TERAKHIR BULAN INI
                    Calendar calNow = Calendar.getInstance();
                    calNow.setTime(new Date());
                    calNow.set(Calendar.DAY_OF_MONTH, calNow.getActualMaximum(Calendar.DAY_OF_MONTH));
                    Date now = calNow.getTime();
                    Date last = ja.getTanggalAngsuran();
                    int compare = last.compareTo(now);

                    while (compare <= 0) {
                        //GENERATE JADWAL BARU
                        SessKreditKalkulasi k = new SessKreditKalkulasi();
                        k.setKredit(PstJenisKredit.fetch(p.getTipeKreditId()));
                        k.setRealizationDate(ja.getTanggalAngsuran());
                        k.setPengajuanTotal(p.getJumlahPinjaman());
                        k.setSukuBunga(p.getSukuBunga());
                        k.setJangkaWaktu(1);
                        k.setTipeBunga(p.getTipeBunga());
                        k.setDateTempo(ja.getTanggalAngsuran());
                        k.setTipeJadwal(p.getTipeJadwal());
                        k.generateDataKredit();

                        if (k.getTSize() > 1) {
                            Date tglBunga = k.getTDate(1);
                            //COMPARE TGL HASIL GENERATE
                            compare = tglBunga.compareTo(now);
                            if (compare >= 1) {
                                break;
                            }

                            //CEK APAKAH JADWAL YG DI GENERATE ADA DI BULAN FEBRUARI
                            Calendar calJadwal = Calendar.getInstance();
                            calJadwal.setTime(tglBunga);
                            if (calJadwal.get(Calendar.MONTH) != Calendar.FEBRUARY) {
                                //JIKA BUKAN DI BULAN FEBRUARI MAKA SESUAIKAN TGL JADWAL SEPERTI TGL JATUH TEMPO DI PENGAJUAN KREDIT
                                Calendar calTempo = Calendar.getInstance();
                                calTempo.setTime(p.getJatuhTempo());
                                calJadwal.set(Calendar.DAY_OF_MONTH, calTempo.get(Calendar.DAY_OF_MONTH));
                                tglBunga = calJadwal.getTime();
                            }

                            //CARI NILAI POKOK
                            double totalPokok = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                            double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                            DecimalFormat df = new DecimalFormat("#.##");
                            double newAngsuran = Double.valueOf(df.format(totalPokok));
                            double newDibayar = Double.valueOf(df.format(pokokDibayar));

                            double nilaiPokok = p.getJumlahPinjaman();
                            if (p.getTipeBunga() == Pinjaman.TIPE_BUNGA_MENURUN) {
                                nilaiPokok = newAngsuran - newDibayar;
                            }

                            //BUAT TRANSAKSI PENCATATAN BUNGA KREDIT TAMBAHAN
                            long oidTransaksi = createTransaksiPencatatanBungaKreditTambahan(p, request);

                            //SIMPAN JADWAL BARU
                            JadwalAngsuran jadwal = new JadwalAngsuran();
                            jadwal.setPinjamanId(p.getOID());
                            jadwal.setTanggalAngsuran(tglBunga);
                            jadwal.setJenisAngsuran(JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                            jadwal.setTransaksiId(oidTransaksi);

                            double bunga = SessKreditKalkulasi.getBunga(nilaiPokok, p.getTipeJadwal(), p.getTipeBunga(), 1, k.getKredit(), p);
                            int useRounding = 0;
                            try {
                                useRounding = Integer.valueOf(PstSystemProperty.getValueByName("GUNAKAN_PEMBULATAN_ANGSURAN"));
                            } catch (Exception exc) {
                                printErrorMessage(exc.getMessage());
                            }
                            if (useRounding == 1) {
                                double pembulatan = (Math.floor((bunga + 499) / 500)) * 500;
                                jadwal.setJumlahAngsuranSeharusnya(bunga);
                                jadwal.setJumlahANgsuran(pembulatan);
                                jadwal.setSisa(pembulatan - bunga);
                            } else {
                                double pembulatan = Double.valueOf(df.format(bunga));
                                jadwal.setJumlahAngsuranSeharusnya(bunga);
                                jadwal.setJumlahANgsuran(pembulatan);
                                jadwal.setSisa(pembulatan - bunga);
                            }

                            PstJadwalAngsuran.insertExc(jadwal);
                            bungaGenerated++;

                            //COMPARE ULANG TANGGAL JADWAL BUNGA TERAKHIR HASIL GENERATE DENGAN TANGGAL TERAKHIR BULAN INI
                            ja = getJadwalBungaTerakhir(p);
                            if (ja.getOID() != 0) {
                                last = ja.getTanggalAngsuran();
                                compare = last.compareTo(now);
                            }
                        }
                    }
                }
            }
            if (objValue.optInt("iErrCode",0) == 0) {
                objValue.put("RETURN_MESSAGE", (bungaGenerated > 0) ? "" + bungaGenerated + " bunga kredit berhasil dibuat." : "Tidak ada bunga kredit baru.");
            }

        } catch (DBException | NumberFormatException e) {
            printErrorMessage(e.getMessage());
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.getMessage());
        }
        
        return objValue;
    }

    public synchronized JSONObject reScheduleJadwalAngsuran(HttpServletRequest request, JSONObject objValue) throws JSONException{
        try {
            String tglRealisasi = FRMQueryString.requestString(request, "FRM_TGL_REALISASI");
            Date newTglRealisasi = Formater.formatDate(tglRealisasi, "yyyy-MM-dd");
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            if (newTglRealisasi == null) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Tidak dapat membuat jadwal ulang. Tanggal realisasi = " + newTglRealisasi + " !");
                return objValue;
            }

            Pinjaman p = PstPinjaman.fetchExc(oid);
            if (p.getStatusPinjaman() != Pinjaman.STATUS_DOC_CAIR) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Tidak dapat membuat jadwal ulang. Status kredit bukan Cair !");
                return objValue;
            }
//            if (newTglRealisasi.before(p.getTglPengajuan())) {
//                objValue.put("RETURN_ERROR_CODE", 1);
//                this.message = "Tidak dapat membuat jadwal ulang. Tanggal realisasi tidak boleh mundur dari tanggal pengajuan kredit !";
//                return;
//            }

            //CEK APAKAH ADA TRANSAKSI PEMBAYARAN
//            String wherePembayaran = PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT + "'"
//                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'";
//            Vector listTransaksiPembayaran = PstTransaksi.list(0, 0, wherePembayaran, "");
//            if (!listTransaksiPembayaran.isEmpty()) {
//                objValue.put("RETURN_ERROR_CODE", 1);
//                this.message = "Tidak dapat membuat jadwal ulang. Kredit sudah memasuki masa pembayaran angsuran !";
//                return;
//            }
//
//            //CARI DATA TRANSAKSI PENCAIRAN
//            String wherePencairan = PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN + "'"
//                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'";
//            Vector<Transaksi> listTransaksiPencairan = PstTransaksi.list(0, 0, wherePencairan, "");
//            long idTransaksiPencairan = 0;
//            if (listTransaksiPencairan.isEmpty()) {
//                objValue.put("RETURN_ERROR_CODE", 1);
//                this.message = "Tidak dapat membuat jadwal ulang. Data transaksi pencairan tidak ditemukan !";
//                return;
//            } else {
//                idTransaksiPencairan = listTransaksiPencairan.get(0).getOID();
//            }

//            long startTime = p.getTglRealisasi().getTime();
//            long endTime = newTglRealisasi.getTime();
//            long diffTime = endTime - startTime;
//            long diffDays = diffTime / (1000 * 60 * 60 * 24);
//            p.setTglRealisasi(newTglRealisasi);
//            //HAPUS SELURUH JADWAL ANGSURAN
//            Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'", "");
//            for (JadwalAngsuran ja : listJadwal) {
//                Calendar c = Calendar.getInstance();
//                c.setTime(ja.getTanggalAngsuran());
//                c.add(Calendar.DAY_OF_MONTH, (int) diffDays);
//                ja.setTanggalAngsuran(c.getTime());
//                p.setJatuhTempo(c.getTime());
//                try {
//                    PstJadwalAngsuran.updateExc(ja);
//                } catch (Exception exc){}
//            }
            
            Calendar calendarDp = Calendar.getInstance();
            Calendar calendarPokok = Calendar.getInstance();
            Calendar calendarBunga = Calendar.getInstance();
            calendarDp.setTime(newTglRealisasi);
            calendarPokok.setTime(newTglRealisasi);
            calendarBunga.setTime(newTglRealisasi);

            p.setTglRealisasi(calendarDp.getTime());

            Vector listJadwalDP = PstJadwalAngsuran.list(0, 0, "PINJAMAN_ID="+p.getOID()+" AND JENIS_ANGSURAN = 18", "");
            for (int x=0; x < listJadwalDP.size(); x++){
                JadwalAngsuran jadwalAngsuran = (JadwalAngsuran) listJadwalDP.get(x);
                jadwalAngsuran.setTanggalAngsuran(calendarDp.getTime());
                p.setJatuhTempo(calendarDp.getTime());
                try {
                    PstJadwalAngsuran.updateExc(jadwalAngsuran);
                } catch (Exception exc){}
            }
            Vector listJadwal = PstJadwalAngsuran.list(0, 0, "PINJAMAN_ID="+p.getOID()+" AND JENIS_ANGSURAN = 4", "");
            for (int x=0; x < listJadwal.size(); x++){
                JadwalAngsuran jadwalAngsuran = (JadwalAngsuran) listJadwal.get(x);
                if (x > 0 || listJadwalDP.size()>0){
                    calendarPokok.setTime(p.getTglRealisasi());
                    calendarPokok.add(Calendar.MONTH, x);
                }
                jadwalAngsuran.setTanggalAngsuran(calendarPokok.getTime());
                p.setJatuhTempo(calendarPokok.getTime());
                try {
                    PstJadwalAngsuran.updateExc(jadwalAngsuran);
                } catch (Exception exc){}
            }
            listJadwal = PstJadwalAngsuran.list(0, 0, "PINJAMAN_ID="+p.getOID()+" AND JENIS_ANGSURAN = 5", "");
            for (int x=0; x < listJadwal.size(); x++){
                JadwalAngsuran jadwalAngsuran = (JadwalAngsuran) listJadwal.get(x);
                if (x > 0 || listJadwalDP.size()>0){
                    calendarBunga.setTime(p.getTglRealisasi());
                    calendarBunga.add(Calendar.MONTH, x);
                }
                jadwalAngsuran.setTanggalAngsuran(calendarBunga.getTime());
                p.setJatuhTempo(calendarBunga.getTime());
                try {
                    PstJadwalAngsuran.updateExc(jadwalAngsuran);
                } catch (Exception exc){}
            }
            
            PstPinjaman.updateExc(p);
//
//            //UPDATE TGL REALISASI DAN TGL JATUH TEMPO
//            p.setTglRealisasi(newTglRealisasi);
//            p.setJatuhTempo(newTglRealisasi);
//            Calendar c = Calendar.getInstance();
//            c.setTime(newTglRealisasi);
//            c.add(Calendar.MONTH, p.getJangkaWaktu());
//            p.setTglLunas(c.getTime());
//            PstPinjaman.updateExc(p);
//
//            //GENERATE JADWAL ANGSURAN BARU
//            createScheduleOnly(request, p);
//
//            //TAMBAHKAN ID TRANSAKSI PENCAIRAN PADA JADWAL BARU
//            Vector<JadwalAngsuran> listJadwalBaru = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'", "");
//            for (JadwalAngsuran ja : listJadwalBaru) {
//                ja.setTransaksiId(idTransaksiPencairan);
//                PstJadwalAngsuran.updateExc(ja);
//            }

            if (objValue.optInt("iErrCode",0) == 0) {
                objValue.put("RETURN_MESSAGE", "Pembuatan jadwal ulang berhasil");
            }

        } catch (Exception e) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", "Tidak dapat membuat jadwal ulang. " + e.getMessage());
            printErrorMessage(e.getMessage());
        }
        
        return objValue;
    }

    public synchronized JSONObject backStatusKreditCair(HttpServletRequest request, JSONObject objValue) throws JSONException{
        try {
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            Pinjaman p = PstPinjaman.fetchExc(oid);
            //CEK STATUS PINJAMAN
            if (p.getStatusPinjaman() == Pinjaman.STATUS_DOC_LUNAS || p.getStatusPinjaman() == Pinjaman.STATUS_DOC_PELUNASAN_DINI || p.getStatusPinjaman() == Pinjaman.STATUS_DOC_PELUNASAN_MACET) {

                //CARI TRANSAKSI PENGENDAPAN JIKA ADA
                String whereTransfer = PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
                        + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN + "," + Transaksi.USECASE_TYPE_TABUNGAN_SETORAN + ")"
                        + " AND ("
                        + "" + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " LIKE '%" + Transaksi.KODE_TRANSAKSI_TABUNGAN_PENARIKAN_PENGENDAPAN_KREDIT + "%'"
                        + " OR " + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " LIKE '%" + Transaksi.KODE_TRANSAKSI_TABUNGAN_SETORAN_PENGENDAPAN_KREDIT + "%'"
                        + ")";
                Vector<Transaksi> listTransfer = PstTransaksi.list(0, 0, whereTransfer, "");
                if (listTransfer.size() > 0) {
                    //CEK APAKAH TRANSAKSI SUDAH DIPOSTED
                    for (Transaksi t : listTransfer) {
                        if (t.getStatus() == Transaksi.STATUS_DOC_TRANSAKSI_POSTED) {
                            objValue.put("RETURN_ERROR_CODE", 1);
                            objValue.put("RETURN_MESSAGE", "Tidak dapat mengembalikan status kredit menjadi Cair. \nTerdapat transaksi transfer dana pengendapan yang sudah di POSTED");
                            return objValue;
                        }
                    }
                }

                //UBAH STATUS JADI CAIR
                if (objValue.optInt("iErrCode",0) == 0) {
                    p.setStatusPinjaman(Pinjaman.STATUS_DOC_CAIR);
                    PstPinjaman.updateExc(p);
                }

            } else {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Status kredit tidak sesuai untuk aksi ini.");
            }
        } catch (Exception exc) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", exc.getMessage());
            printErrorMessage(exc.getMessage());
        }
        return objValue;
    }

    public synchronized JSONObject saveNewSchedule(HttpServletRequest request, JSONObject objValue) throws JSONException{
        int jenisAngsuran = FRMQueryString.requestInt(request, "FRM_JENIS_ANGSURAN");
        long idParentSchedule = FRMQueryString.requestLong(request, "FRM_ID_PARENT_JADWAL_ANGSURAN");
        double jumlahAngsuran = FRMQueryString.requestDouble(request, "FRM_JUMLAH_ANGSURAN");
        long oidPinjaman = FRMQueryString.requestLong(request, "SEND_OID_PINJAMAN");
        String tglTempo = FRMQueryString.requestString(request, "SEND_TGL_TEMPO");
        long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        DecimalFormat df = new DecimalFormat("#.##");
        double pembulatanJumlahAngsuran = Double.valueOf(df.format(jumlahAngsuran));

        try {
            Pinjaman p = PstPinjaman.fetchExc(oidPinjaman);
            Date tglAngsuran = Formater.formatDate(tglTempo, "yyyy-MM-dd");
            //simpan transaksi pencatatan denda
            Date tglTransaksi = new Date();
            String kodeTransaksi = "Transaksi." + Formater.formatDate(tglTransaksi, "yyyyMMdd");
            if (jenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_DENDA) {
                kodeTransaksi = PstTransaksi.generateKodeTransaksi(JadwalAngsuran.KODE_TRANSAKSI_KREDIT_PENCATATAN_DENDA, Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN, tglTransaksi);
            }
            Transaksi t = new Transaksi();
            t.setTanggalTransaksi(tglTransaksi);
            t.setKodeBuktiTransaksi(kodeTransaksi);
            t.setIdAnggota(p.getAnggotaId());
            t.setTellerShiftId(oidTellerShift);
            t.setKeterangan(Transaksi.USECASE_TYPE_TITLE.get(Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN));
            t.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
            t.setUsecaseType(Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN);
            t.setPinjamanId(p.getOID());
            long idTransaksi = PstTransaksi.insertExc(t);

            //simpan jadwal baru
            JadwalAngsuran jadwal = new JadwalAngsuran();
            jadwal.setPinjamanId(p.getOID());
            jadwal.setTanggalAngsuran(tglAngsuran);
            jadwal.setJenisAngsuran(jenisAngsuran);
            jadwal.setTransaksiId(idTransaksi);
            jadwal.setParentJadwalAngsuranId(idParentSchedule);
            jadwal.setJumlahAngsuranSeharusnya(jumlahAngsuran);
            jadwal.setJumlahANgsuran(pembulatanJumlahAngsuran);
            jadwal.setSisa(pembulatanJumlahAngsuran - jumlahAngsuran);
            PstJadwalAngsuran.insertExc(jadwal);
            objValue.put("RETURN_MESSAGE", "Jadwal berhasil disimpan");
        } catch (Exception e) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.getMessage());
            printErrorMessage(e.getMessage());
        }
        
        return objValue;
    }

    //penutupan kredit
    public synchronized JSONObject penutupanKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        objValue.put("RETURN_ERROR_CODE", 0);
        objValue.put("RETURN_MESSAGE", "");
        try {
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            Pinjaman p = PstPinjaman.fetchExc(oid);
            if (p.getStatusPinjaman() != Pinjaman.STATUS_DOC_CAIR) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Status kredit tidak sesuai untuk aksi ini. ");
                return objValue;
            }

            //cek total seluruh angsuran sudah dibayar semua
            if (objValue.optInt("iErrCode",0) == 0) {
                double totalAngsuran = SessKredit.getTotalAngsuran(p.getOID());
                double totalDibayar = SessKredit.getTotalAngsuranDibayar(p.getOID());
                DecimalFormat df = new DecimalFormat("#.##");
                double newAngsuran = Double.valueOf(df.format(totalAngsuran));
                double newDibayar = Double.valueOf(df.format(totalDibayar));

                if (newDibayar < newAngsuran) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Penutupan kredit gagal. Masih terdapat sisa angsuran yg belum dibayar. ");
                    return objValue;
                }
            }

            //cek apakah ada jadwal yg belum di bayar
            if (objValue.optInt("iErrCode",0) == 0) {
                String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "' AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " NOT IN (" + queryGetIdJadwalDibayar(p.getOID()) + ")";
                int jadwalBelumDibayar = PstJadwalAngsuran.getCount(where);
                if (jadwalBelumDibayar > 0) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Masih terdapat jadwal yang belum dibayar. ");
                    return objValue;
                }
            }

            //cek apakah sudah pernah ada transaksi transfer pengendapan untuk nomor kredit ini
            if (objValue.optInt("iErrCode",0) == 0) {
                String whereTransfer = PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
                        + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN + "," + Transaksi.USECASE_TYPE_TABUNGAN_SETORAN + ")"
                        + " AND ("
                        + "" + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " LIKE '%" + Transaksi.KODE_TRANSAKSI_TABUNGAN_PENARIKAN_PENGENDAPAN_KREDIT + "%'"
                        + " OR " + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " LIKE '%" + Transaksi.KODE_TRANSAKSI_TABUNGAN_SETORAN_PENGENDAPAN_KREDIT + "%'"
                        + ")";
                Vector<Transaksi> listTransfer = PstTransaksi.list(0, 0, whereTransfer, "");
                for (Transaksi t : listTransfer) {
                    deleteTransaction(request, t.getOID(), objValue);
                    if (objValue.optInt("iErrCode",0) > 0) {
                        return objValue;
                    }
                }
            }

            //transfer uang pengendapan (jika menggunakan pengendapan) dari simpanan wajib ke simpanan sukarela (tabungan pencairan)
            String messagePengendapan = "";
            double pengendapan = p.getWajibValueType() == Pinjaman.WAJIB_VALUE_TYPE_PERSEN ? p.getJumlahPinjaman() * p.getWajibValue() / 100 : p.getWajibValue();

            if (objValue.optInt("iErrCode",0) == 0 && p.getWajibIdJenisSimpanan() != 0 && pengendapan != 0) {
                try {
                    String noTabPencairan = SessReportTabungan.getNomorTabungan("act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + p.getAssignTabunganId());
                    String noTabPengendapan = SessReportTabungan.getNomorTabungan("adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_SIMPANAN] + " = " + p.getWajibIdJenisSimpanan());

                    long idSimpananPencairan = 0;
                    Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 1, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + "=" + p.getAssignTabunganId() + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + "=" + p.getIdJenisSimpanan(), null);
                    if (listSimpanan.isEmpty()) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Penutupan kredit gagal. OID simpanan untuk pencairan tidak ditemukan! ");
                        return objValue;
                    } else {
                        idSimpananPencairan = listSimpanan.get(0).getOID();
                    }

                    long idPenambahanCash = PstJenisTransaksi.getIdJenisTransaksiByNamaJenisTransaksi("Penambahan Cash");
                    if (idPenambahanCash == 0) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Penutupan kredit gagal. OID jenis transaksi penambahan cash tidak ditemukan! ");
                        return objValue;
                    }

                    long idPenarikanCash = PstJenisTransaksi.getIdJenisTransaksiByNamaJenisTransaksi("Penarikan Cash");
                    if (idPenarikanCash == 0) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Penutupan kredit gagal. OID jenis transaksi penarikan cash tidak ditemukan! ");
                        return objValue;
                    }

                    long idPaymentSystem = 0;
                    Vector<PaymentSystem> listPS = PstPaymentSystem.list(0, 1, PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_TYPE] + " = " + AngsuranPayment.TIPE_PAYMENT_CASH, null);
                    if (listPS.isEmpty()) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Penutupan kredit gagal. OID payment system cash tidak ditemukan! ");
                        return objValue;
                    } else {
                        idPaymentSystem = listPS.get(0).getOID();
                    }

                    String tgl = FRMQueryString.requestString(request, "TGL_TRANSAKSI");
                    Date tglTransaksi = Formater.formatDate(tgl, "yyyy-MM-dd HH:mm:ss");

                    String nomorTransaksi1 = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_TABUNGAN_PENARIKAN_PENGENDAPAN_KREDIT, Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN, tglTransaksi);
                    long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
                    Transaksi t1 = new Transaksi();
                    t1.setTanggalTransaksi(tglTransaksi);
                    t1.setIdAnggota(p.getAnggotaId());
                    t1.setTellerShiftId(oidTellerShift);
                    t1.setKeterangan("Penarikan pengendapan tabungan wajib. Nomor kredit : " + p.getNoKredit());
                    t1.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                    t1.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERKURANG);
                    t1.setUsecaseType(Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN);
                    t1.setKodeBuktiTransaksi(nomorTransaksi1);
                    t1.setPinjamanId(p.getOID());
                    PstTransaksi.insertExc(t1);

                    if (t1.getOID() != 0) {
                        DetailTransaksi d1 = new DetailTransaksi();
                        d1.setTransaksiId(t1.getOID());
                        d1.setJenisTransaksiId(idPenarikanCash);
                        d1.setDebet(pengendapan);
                        d1.setIdSimpanan(p.getWajibIdJenisSimpanan());
                        PstDetailTransaksi.insertExc(d1);

                        TransaksiPayment tp1 = new TransaksiPayment();
                        tp1.setPaymentSystemId(idPaymentSystem);
                        tp1.setJumlah(pengendapan);
                        tp1.setTransaksiId(t1.getOID());
                        PstTransaksiPayment.insertExc(tp1);
                    }

                    String nomorTransaksi2 = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_TABUNGAN_SETORAN_PENGENDAPAN_KREDIT, Transaksi.USECASE_TYPE_TABUNGAN_SETORAN, tglTransaksi);

                    Transaksi t2 = new Transaksi();
                    t2.setTanggalTransaksi(tglTransaksi);
                    t2.setIdAnggota(p.getAnggotaId());
                    t2.setTellerShiftId(oidTellerShift);
                    t2.setKeterangan("Setoran pengendapan tabungan wajib. Nomor kredit : " + p.getNoKredit());
                    t2.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                    t2.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
                    t2.setUsecaseType(Transaksi.USECASE_TYPE_TABUNGAN_SETORAN);
                    t2.setKodeBuktiTransaksi(nomorTransaksi2);
                    t2.setPinjamanId(p.getOID());
                    PstTransaksi.insertExc(t2);

                    if (t2.getOID() != 0) {
                        DetailTransaksi d2 = new DetailTransaksi();
                        d2.setTransaksiId(t2.getOID());
                        d2.setJenisTransaksiId(idPenambahanCash);
                        d2.setKredit(pengendapan);
                        d2.setIdSimpanan(idSimpananPencairan);
                        PstDetailTransaksi.insertExc(d2);

                        TransaksiPayment tp2 = new TransaksiPayment();
                        tp2.setPaymentSystemId(idPaymentSystem);
                        tp2.setJumlah(pengendapan);
                        tp2.setTransaksiId(t2.getOID());
                        PstTransaksiPayment.insertExc(tp2);
                    }
                    messagePengendapan = "\nPemindahan dana pengendapan sebesar '" + String.format("%,.2f", pengendapan) + "' dari nomor tabunga '" + noTabPencairan + "' ke nomor tabungan '" + noTabPengendapan + "' berhasil.";
                } catch (Exception e) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", e.getMessage());
                    printErrorMessage(e.getMessage());
                    return objValue;
                }
            }

            //update status kredit jadi lunas
            if (objValue.optInt("iErrCode",0) == 0) {
                int docStatus = Pinjaman.STATUS_DOC_LUNAS;
                //cek tipe pelunasan
                String wherePelunasan = "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                        + " AND (" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_DINI
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_MACET
                        + ")";
                Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, wherePelunasan, "");
                if (!listJadwal.isEmpty()) {
                    if (listJadwal.get(0).getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_DINI) {
                        docStatus = Pinjaman.STATUS_DOC_PELUNASAN_DINI;
                    } else if (listJadwal.get(0).getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_MACET) {
                        docStatus = Pinjaman.STATUS_DOC_PELUNASAN_MACET;
                    }
                }
                //update status pinjaman
                try {
                    p.setStatusPinjaman(docStatus);
                    PstPinjaman.updateExc(p);
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Penutupan kredit dengan nomor '" + p.getNoKredit() + "' berhasil. " + messagePengendapan + " ");
                } catch (DBException ex) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Update status lunas kredit gagal : " + ex.toString() + " ");
                    printErrorMessage(ex.getMessage());
                }
            }
        } catch (DBException | NumberFormatException exc) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", exc.getMessage());
            printErrorMessage(exc.getMessage());
        }
        
        return objValue;
    }

    //pemunduran status kredit---------------------------------------
    public synchronized JSONObject backStatusKreditDraft(HttpServletRequest request, JSONObject objValue) throws JSONException{
        try {
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            Pinjaman p = PstPinjaman.fetchExc(oid);
            //CEK STATUS KREDIT
            if (p.getStatusPinjaman() != Pinjaman.STATUS_DOC_CAIR) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Status pinjaman tidak sesuai untuk aksi ini.");
                return objValue;
            }

            //CARI SEMUA DATA TRANSAKSI YG BERKAITAN DENGAN DATA KREDIT INI
            Vector<Transaksi> listAllTransaksi = PstTransaksi.list(0, 0, PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'", null);
            for (Transaksi tr : listAllTransaksi) {
                //CEK APAKAH ADA TRANSAKSI YG SUDAH DI POSTED
                if (tr.getStatus() != Transaksi.STATUS_DOC_TRANSAKSI_CLOSED) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Data kredit tidak dapat diubah. Terdapat transaksi yang sudah di POSTED.");
                    return objValue;
                }
                //CEK APAKAH ADA TRANSAKSI PEMBAYARAN
                if (tr.getStatus() == Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Data kredit tidak dapat diubah. Terdapat jadwal angsuran yang sudah dibayar.");
                    return objValue;
                }
            }

            //HAPUS SEMUA TRANSAKSI PARENT (TRANSAKSI CHILD AKAN TERHAPUS DI METHOD "deleteTransaction")
            if (objValue.optInt("iErrCode",0) == 0) {
                String whereTransaksiParent = PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
                        + " AND (" + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_PARENT_ID] + " = 0 OR " + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_PARENT_ID] + " IS NULL )";
                Vector<Transaksi> listTransaksiParent = PstTransaksi.list(0, 0, whereTransaksiParent, null);
                for (Transaksi tr : listTransaksiParent) {
                    deleteTransaction(request, tr.getOID(), objValue);
                }
            }

            //CEK ULANG APAKAH MASIH ADA DATA TRANSAKSI
            listAllTransaksi = PstTransaksi.list(0, 0, PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'", null);
            if (listAllTransaksi.size() > 0) {
                //HAPUS PAKSA
                for (Transaksi tr : listAllTransaksi) {
                    deleteTransaction(request, tr.getOID(), objValue);
                }
            }

            //UBAH STATUS KREDIT JADI DRAFT
            if (objValue.optInt("iErrCode",0) == 0) {
                p.setStatusPinjaman(Pinjaman.STATUS_DOC_DRAFT);
                PstPinjaman.updateExc(p);
                objValue.put("RETURN_MESSAGE", FRMMessage.getMessage(FRMMessage.MSG_UPDATED));
            }

        } catch (Exception exc) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", exc.getMessage());
            printErrorMessage(exc.getMessage());
            return objValue;
        }
        
        return objValue;
    }

    //pembayaran kredit---------------------------------------------------------    
    public synchronized JSONObject cekValidasiBayar(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        if (dataFor != null && dataFor.equals("bayarSeluruhAngsuranBunga")) {
            long pinjamanId = FRMQueryString.requestLong(request, "PINJAMAN_ID");
            int n = PstJadwalAngsuran.getCount(PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + "=" + pinjamanId + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + "=" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " NOT IN (SELECT DISTINCT a.`JADWAL_ANGSURAN_ID` FROM `aiso_angsuran` a JOIN sedana_jadwal_angsuran j ON a.`JADWAL_ANGSURAN_ID`=j.`JADWAL_ANGSURAN_ID` AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + "=" + pinjamanId + " AND j." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + "=" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ")");
            if (n < 1) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Jadwal pembayaran bunga tidak ditemukan.");
                return objValue;
            }
        }

        Pinjaman p = new Pinjaman();
        try {
            p = PstPinjaman.fetchExc(oid);
        } catch (Exception exc) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", exc.getMessage());
            printErrorMessage(exc.getMessage());
            return objValue;
        }

        //==================== CEK KESESUAIAN JUMLAH UANG ====================
        //HITUNG TOTAL UANG PAYMENT
        String[] arrayPaymentValue = request.getParameterValues("FORM_JUMLAH_SETORAN");
        double uang = 0;
        if (objValue.optInt("iErrCode",0) == 0) {
            for (int i = 0; i < arrayPaymentValue.length; i++) {
                if (arrayPaymentValue[i].equals("")) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Pastikan nominal payment tidak kosong !");
                    return objValue;
                }
                if (Double.valueOf(arrayPaymentValue[i]) <= 0) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Pastikan nominal payment tidak minus !");
                    return objValue;
                }
                uang += Double.valueOf(arrayPaymentValue[i]);
            }
        }

        //HITUNG TOTAL JUMLAH JADWAL DIBAYAR
        String[] arraySisaAngsuran = request.getParameterValues("FORM_SISA_ANGSURAN");
        String[] arrayDibayar = request.getParameterValues("FRM_FIELD_JUMLAH_ANGSURAN");
        String[] arrayDiscPct = request.getParameterValues("FRM_FIELD_DISC_PCT");
        String[] arrayDiscAmount = request.getParameterValues("FRM_FIELD_DISC_AMOUNT");
        String[] multiBiayaDibayar = request.getParameterValues("FRM_BIAYA_DIBAYAR");

        double dibayar = 0;
        if (dataFor.equals("pembayaranAngsuran")) {
            if (objValue.optInt("iErrCode",0) == 0) {
                for (int i = 0; i < arrayDibayar.length; i++) {
                    if (arrayDibayar[i].equals("")) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Pastikan jumlah yang dibayar tidak kosong !");
                        return objValue;
                    } else if (Double.valueOf(arrayDibayar[i]) > Double.valueOf(arraySisaAngsuran[i])) {
                        //objValue.put("RETURN_ERROR_CODE", 1);
                        //message = "Pastikan jumlah uang per jadwal tidak melebihi sisa angsuran masing-masing ! \nSisa = " + Double.valueOf(sisaAngsuran[i]) + "\nDibayar = " + Double.valueOf(arrayDibayar[i]);
                        //return;
                    }
                    dibayar += Double.valueOf(arrayDibayar[i]);
                }
            }
            DecimalFormat df = new DecimalFormat("#.##");

            double biaya = 0;
            if (multiBiayaDibayar != null) {
                try {
                    if (multiBiayaDibayar.length > 0) {
                        for (String biayaStr : multiBiayaDibayar) {
                            String cleanedBiayaStr = biayaStr.replaceAll("[.]", "");
                            double tempBiaya = Double.valueOf(cleanedBiayaStr);
                            biaya += tempBiaya;
                        }
                    }
                } catch (Exception e) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", e.getMessage());
                    return objValue;
                }
            }

            //CEK NILAI UANG PAYMENT HARUS SAMA DENGAN JUMLAH JADWAL DIBAYAR
            //PEMBULATAN NILAI UANG 2 DIGIT DI BELAKANG KOMA
            double uangDibayar = dibayar + biaya;
            double newUang = Double.valueOf(df.format(uang));
            double newDibayar = Double.valueOf(df.format(uangDibayar));

            if (newDibayar < newUang) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Pastikan total nominal payment sama dengan total angsuran yang dibayar ! \nJumlah uang = " + newUang + "\nNilai dibayar = " + newDibayar);
                return objValue;
            }
        }

        //==================== CEK OID JADWAL ANGSURAN ====================
        if (objValue.optInt("iErrCode",0) == 0 && dataFor.equals("pembayaranAngsuran")) {
            String[] arrayJadwal = request.getParameterValues("FRM_FIELD_JADWAL_ANGSURAN_ID");
            for (int i = 0; i < arrayJadwal.length; i++) {
                try {
                    if (arrayJadwal[i].equals("") || arrayJadwal[i].equals("0")) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Pastikan jadwal angsuran dipilih dengan benar !");
                        return objValue;
                    }
                    long idJadwalAngsuran = Long.valueOf(arrayJadwal[i]);
                    JadwalAngsuran ja = new JadwalAngsuran();
                    if (idJadwalAngsuran != -1) {
                        ja = PstJadwalAngsuran.fetchExc(idJadwalAngsuran);
                    }

                    //CEK JADWAL DIPILIH LEBIH DARI SEKALI
                    int j = i;
                    while (j < arrayJadwal.length - 1) {
                        long idJadwalCheck = Long.valueOf(arrayJadwal[j + 1]);
                        if (idJadwalAngsuran == idJadwalCheck) {
                            objValue.put("RETURN_ERROR_CODE", 1);
                            objValue.put("RETURN_MESSAGE", "Pastikan jadwal yang sama tidak dipilih dua kali ! " + Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy"));
                            return objValue;
                        }
                        j++;
                    }
                    if (objValue.optInt("iErrCode",0) != 0) {
                        return objValue;
                    }

                } catch (NumberFormatException | DBException exc) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", exc.getMessage());
                    printErrorMessage(exc.getMessage());
                    return objValue;
                }
            }
        }

        //==================== CEK OID PAYMENT ====================
        if (objValue.optInt("iErrCode",0) == 0) {
            String[] arrayPaymentType = request.getParameterValues("FORM_PAYMENT_ID");
            for (int i = 0; i < arrayPaymentType.length; i++) {
                try {
                    if (arrayPaymentType[i].equals("") || arrayPaymentType[i].equals("0")) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Pastikan cara bayar dipilih dengan benar !");
                        return objValue;
                    }
                    long idPayment = Long.valueOf(arrayPaymentType[i]);
                    PaymentSystem ap = PstPaymentSystem.fetchExc(idPayment);

                    //CEK TIPE PAYMENT DIPILIH LEBIH DARI SEKALI (KECUALI TABUNGAN)
                    if (ap.getPaymentType() == AngsuranPayment.TIPE_PAYMENT_SAVING) {
                        continue;
                    }
                    int j = i;
                    while (j < arrayPaymentType.length - 1) {
                        long idPaymentCheck = Long.valueOf(arrayPaymentType[j + 1]);
                        if (idPayment == idPaymentCheck) {
                            objValue.put("RETURN_ERROR_CODE", 1);
                            objValue.put("RETURN_MESSAGE", "Pastikan cara bayar yang sama tidak dipilih dua kali !");
                            return objValue;
                        }
                        j++;
                    }
                    if (objValue.optInt("iErrCode",0) != 0) {
                        return objValue;
                    }

                } catch (NumberFormatException | com.dimata.posbo.db.DBException exc) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", exc.getMessage());
                    printErrorMessage(exc.getMessage());
                    return objValue;
                }
            }
        }

        //==================== CEK OID SIMPANAN ====================
        String[] paymentCode = request.getParameterValues("FORM_PAYMENT_TYPE");
        String[] idSimpanan = request.getParameterValues("FORM_OID_SIMPANAN");
        String[] jumlahPenarikan = request.getParameterValues("FORM_JUMLAH_PENARIKAN_TABUNGAN");
        if (objValue.optInt("iErrCode",0) == 0) {
            for (int i = 0; i < paymentCode.length; i++) {
                try {
                    if (paymentCode[i].equals("")) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Pastikan cara bayar dipilih dengan benar !");
                        return objValue;
                    }
                    int kode = Integer.valueOf(paymentCode[i]);
                    if (kode == AngsuranPayment.TIPE_PAYMENT_SAVING) {
                        if (idSimpanan[i].equals("") || idSimpanan[i].equals("0")) {
                            objValue.put("RETURN_ERROR_CODE", 1);
                            objValue.put("RETURN_MESSAGE", "Pastikan nomor tabungan dipilih dengan benar !");
                            return objValue;//continue;
                        }
                        if (jumlahPenarikan[i].equals("") || jumlahPenarikan[i].equals("0")) {
                            objValue.put("RETURN_ERROR_CODE", 1);
                            objValue.put("RETURN_MESSAGE", "Pastikan nominal payment tidak kosong atau 0 !");
                            return objValue;//continue;
                        }

                        DataTabungan dt = PstDataTabungan.fetchExc(Long.valueOf(idSimpanan[i]));
                        AssignContactTabungan act = PstAssignContactTabungan.fetchExc(dt.getAssignTabunganId());
                        JenisSimpanan js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                        //CEK SIMPANAN DIPILIH LEBIH DARI SEKALI
                        int j = i;
                        while (j < idSimpanan.length - 1) {
                            if (idSimpanan[j + 1].equals("") || idSimpanan[j + 1].equals("0")) {
                                //
                            } else {
                                long oidCheck = Long.valueOf(idSimpanan[j + 1]);
                                if (dt.getOID() == oidCheck) {
                                    objValue.put("RETURN_ERROR_CODE", 1);
                                    objValue.put("RETURN_MESSAGE", "Pastikan nomor tabungan dengan jenis item yang sama tidak dipilih dua kali !");
                                    return objValue;
                                }
                            }
                            j++;
                        }
                        double saldo = PstDetailTransaksi.getSimpananSaldo(dt.getOID());
                        double jumlahDitarik = Double.valueOf(jumlahPenarikan[i]);
                        if (saldo < jumlahDitarik) {
                            objValue.put("RETURN_ERROR_CODE", 1);
                            objValue.put("RETURN_MESSAGE", "Jumlah saldo " + act.getNoTabungan() + " - " + js.getNamaSimpanan() + " tidak cukup !");
                            return objValue;
                        }
                    }

                } catch (NumberFormatException | DBException e) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", e.getMessage());
                    printErrorMessage(e.getMessage());
                    return objValue;
                }
            }
        }

        //==================== CEK NILAI INPUT SETORAN ====================
        if (dataFor.equals("bayarSeluruhAngsuranBunga")) {
            double totalBunga = SessReportKredit.getTotalAngsuran(oid, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
            double totalBungaDibayar = SessReportKredit.getTotalAngsuranDibayar(oid, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
            double sisaBunga = totalBunga - totalBungaDibayar;
            if (uang < sisaBunga) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Pastikan jumlah uang setoran sesuai dengan total (sisa) angsuran bunga !");
                return objValue;
            }
        }

        if (objValue.optInt("iErrCode",0) == 0) {
            int confirmation = FRMQueryString.requestInt(request, "CONFIRMATION_PAY");
            if (confirmation == 1) {
                objValue = pembayaranAngsuran(request, objValue);
            } else {
                objValue = konfirmasiPembayaran(request, p, idSimpanan, objValue);
            }
        }
        
        return objValue;
    }

    public JSONObject konfirmasiPembayaran(HttpServletRequest request, Pinjaman p, String[] idSimpanan, JSONObject objValue) throws JSONException{
        Anggota a = new Anggota();
        String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
        try {
            a = PstAnggota.fetchExc(p.getAnggotaId());
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        String htmlReturn = ""
                + "<p style='font-size: 16px'><b>Anda akan melakukan transaksi pembayaran kredit :</b></p>"
                + "<table>"
                + "   <tr>"
                + "       <td style='width: 100px'>Nomor Kredit</td>"
                + "       <td>: &nbsp; " + p.getNoKredit() + "</td>"
                + "   </tr>"
                + "   <tr>"
                + "       <td>" + namaNasabah + "</td>"
                + "       <td>: &nbsp; " + a.getName() + " (" + a.getNoAnggota() + ")</td>"
                + "   </tr>"
                + "</table>"
                + "<br>"
                + "<label>Angsuran Dibayar :</label>"
                + "<table class='table table-bordered' style='font-size: 14px'>"
                + "   <tr class='label-success'>"
                + "       <th style='width: 1%'>No.</th>"
                + "       <th>Jatuh Tempo</th>"
                + "       <th>Jenis Angsuran</th>"
                //+ "       <th>Jumlah Angsuran</th>"
                + "       <th>Sisa Angsuran</th>"
                + "       <th>Diskon</th>"
                + "       <th>Jumlah Dibayar</th>"
                + "   </tr>";

        double totalDibayar = 0;
        String errMsg = "";
        int selisihBayar = 0;
        DecimalFormat df = new DecimalFormat("#.##");
        String arrayJenisAngsuran[] = request.getParameterValues("FRM_FIELD_JENIS_ANGSURAN");
        long oidJadwalAngsuran = FRMQueryString.requestLong(request, "FRM_FIELD_JADWAL_ANGSURAN_ID");
        JadwalAngsuran jad = new JadwalAngsuran();
        try {
            if (oidJadwalAngsuran != 0) {
                jad = PstJadwalAngsuran.fetchExc(oidJadwalAngsuran);
            }
        } catch (Exception e) {
        }

        //cari data biaya yg belum dibayar
        String whereBiaya = PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = " + p.getOID()
                + " AND " + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_VALUE_BIAYA] + " > 0 ";
        Vector<BiayaTransaksi> listBiaya = PstBiayaTransaksi.list(0, 0, whereBiaya, "");

        //cek biaya sudah dibayar apa belum
        boolean sudahBayar = false;
        whereBiaya = PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = " + p.getOID()
                + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = " + I_Sedana.USECASE_TYPE_KREDIT_BIAYA;
        Vector<Transaksi> listTransaksiBiaya = PstTransaksi.list(0, 0, whereBiaya, "");
        if (!listTransaksiBiaya.isEmpty()) {
            ArrayList<Long> biayaIds = new ArrayList<>();
            for (Transaksi t : listTransaksiBiaya) {
                biayaIds.add(t.getOID());
            }
            if (!biayaIds.isEmpty()) {
                String idStr = biayaIds.toString();
                String id = idStr.substring(1, idStr.length() - 1);
                whereBiaya = PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " IN (" + id + ")";
                Vector<DetailTransaksi> listDetailTransaksi = PstDetailTransaksi.list(0, 0, whereBiaya, "");
                sudahBayar = !listBiaya.isEmpty();
            }
        }

        double biaya = 0;
        int count = 0;
        if (!sudahBayar) {
            if (listBiaya != null && listBiaya.size() > 0) {
                for (BiayaTransaksi bt : listBiaya) {
                    if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                        biaya += p.getJumlahPinjaman() * (bt.getValueBiaya() / 100);
                    } else if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                        biaya += bt.getValueBiaya();
                    }
                    count = SessKredit.getCountTransaksiBiayaKredit(p.getOID(), bt.getIdJenisTransaksi());
                }
            }
        }

        int index = 1;
        double totalSisa = 0;
        double totalBayar = 0;
        double totalDisc = 0;
        String[] arrayJadwal = request.getParameterValues("FRM_FIELD_JADWAL_ANGSURAN_ID");
        String[] arraySisaAngsuran = request.getParameterValues("FORM_SISA_ANGSURAN");
        String[] arrayDibayar = request.getParameterValues("FRM_FIELD_JUMLAH_ANGSURAN");
        String[] arrayDiscPct = request.getParameterValues("FRM_FIELD_DISC_PCT");
        String[] arrayDiscAmount = request.getParameterValues("FRM_FIELD_DISC_AMOUNT");
        String[] multiBiayaDibayar = request.getParameterValues("FRM_BIAYA_DIBAYAR");
        for (int i = 0; i < arrayJadwal.length; i++) {
            try {
                JadwalAngsuran jadwal = new JadwalAngsuran();
                if (arrayJadwal[i].equals("-1")) {
                    jadwal.setJenisAngsuran(Integer.valueOf(arrayJenisAngsuran[i]));
                    jadwal.setTanggalAngsuran(new Date());
                } else {
                    jadwal = PstJadwalAngsuran.fetchExc(Long.valueOf(arrayJadwal[i]));
                }
                totalDibayar += Double.valueOf(arrayDibayar[i]) - Double.valueOf(df.format(Double.valueOf(arrayDiscAmount[i])));
                double newSisa = Double.valueOf(df.format(Double.valueOf(arraySisaAngsuran[i])));
                double newDibayar = Double.valueOf(df.format(Double.valueOf(arrayDibayar[i])));
                double newDisc = Double.valueOf(df.format(Double.valueOf(arrayDiscAmount[i])));
                String warning = (newSisa != newDibayar) ? "text-red text-bold" : "";
                selisihBayar += (newSisa != newDibayar) ? 1 : 0;
//                if (count == 0) {
//                    this.htmlReturn += ""
//                            + "<tr class='" + warning + "'>"
//                            + "   <td>" + (i + 1) + ".</td>"
//                            + "   <td>" + Formater.formatDate(jadwal.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
//                            + "   <td>" + JadwalAngsuran.getTipeAngsuranTitle(jadwal.getJenisAngsuran()) + "</td>"
//                            //+ "   <td class='text-right money'>" + jadwal.getJumlahANgsuran() + "</td>"
//                            + "   <td class='text-right money'>" + jadwal.getJumlahANgsuran() + "</td>"
//                            + "   <td class='text-right money'>" + jadwal.getJumlahANgsuran() + "</td>"
//                            + "</tr>"
//                            + "";
//
//                } else
                String jenisAngsuranText = "";
                int jenisAng = FRMQueryString.requestInt(request, "FRM_FIELD_JENIS_ANGSURAN");
                if (jenisAng == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA) {
                    if (jadwal.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT) {
                        jenisAngsuranText = JadwalAngsuran.getTipeAngsuranRadityaTitle(jadwal.getJenisAngsuran());
                    } else {
                        jenisAngsuranText = JadwalAngsuran.getTipeAngsuranRadityaTitle(JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA);
                    }
                    htmlReturn += ""
                            + "<tr class='" + warning + "'>"
                            + "   <td>" + index + ".</td>"
                            + "   <td>" + Formater.formatDate(jadwal.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
                            + "   <td>" + jenisAngsuranText + "</td>"
                            + "   <td class='text-right money'>" + arraySisaAngsuran[i] + "</td>"
                            + "   <td class='text-right money'>" + arrayDiscAmount[i] + "</td>"
                            + "   <td class='text-right money'>" + (newDibayar -  newDisc)+ "</td>"
                            + "</tr>"
                            + "";
                    index++;
                } else if (jadwal.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_BUNGA || jadwal.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK) {
                    totalBayar += Double.parseDouble(String.valueOf(arrayDibayar[i]));
                    totalSisa += Double.parseDouble(String.valueOf(arraySisaAngsuran[i]));
                    totalDisc += Double.parseDouble(String.valueOf(arrayDiscAmount[i]));
                } else {
                    htmlReturn += ""
                            + "<tr class='" + warning + "'>"
                            + "   <td>" + index + ".</td>"
                            + "   <td>" + Formater.formatDate(jadwal.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
                            + "   <td>" + JadwalAngsuran.getTipeAngsuranTitle(jadwal.getJenisAngsuran()) + "</td>"
                            //+ "   <td class='text-right money'>" + jadwal.getJumlahANgsuran() + "</td>"
                            + "   <td class='text-right money'>" + arraySisaAngsuran[i] + "</td>"
                            + "   <td class='text-right money'>" + arrayDiscAmount[i] + "</td>"
                            + "   <td class='text-right money'>" + (newDibayar -  newDisc)+ "</td>"
                            + "</tr>"
                            + "";
                    index++;
                }
                int before = 0;
                int result1 = (i == 0 ? Integer.parseInt(arrayJenisAngsuran[i]) : Integer.parseInt(arrayJenisAngsuran[i - 1]));

//                int result2 = (arrayJenisAngsuran.length > 1 ?  : Integer.parseInt(arrayJenisAngsuran[arrayJenisAngsuran.length - 1]));
//                int danger = Integer.parseInt(arrayJenisAngsuran[i]); 
//                int before = 0;
//                int result1 = (i == 0 ? Integer.parseInt(arrayJenisAngsuran[i]) : Integer.parseInt(arrayJenisAngsuran[i - 1]));
                before = (i >= arrayJenisAngsuran.length ? Integer.parseInt(arrayJenisAngsuran[arrayJenisAngsuran.length - 1]) : Integer.parseInt(arrayJenisAngsuran[i]));
                if (jadwal.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK && (before == JadwalAngsuran.TIPE_ANGSURAN_BUNGA || before == jadwal.getJenisAngsuran())) {
//                if (jadwal.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK ) {
                    if (totalBayar > 0 && totalSisa > 0) {
                        jenisAngsuranText = JadwalAngsuran.getTipeAngsuranRadityaTitle(JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA);
                        htmlReturn += ""
                                + "<tr class='" + warning + "'>"
                                + "   <td>" + index + ".</td>"
                                + "   <td>" + Formater.formatDate(jadwal.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
                                + "   <td>" + jenisAngsuranText + "</td>"
                                + "   <td class='text-right money'>" + totalSisa + "</td>"
                                + "   <td class='text-right money'>" + totalDisc + "</td>"
                                + "   <td class='text-right money'>" + ( totalBayar - totalDisc ) + "</td>"
                                + "</tr>"
                                + "";
                        index++;
                        totalSisa = 0;
                        totalBayar = 0;
                        totalDisc = 0;
                    }
                } else if (jadwal.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_BUNGA) {
                    if (totalBayar > 0 && totalSisa > 0) {
                        String last = "";
                        try {
                            last = arrayJenisAngsuran[arrayJenisAngsuran.length - 1];
                        } catch (Exception e) {
                            System.out.println("Error konfirmasi permbayaran : " + e.getMessage());
                        }
                        if (i == arrayJenisAngsuran.length - 1) {
                            if (!last.equals("")) {
                                int cvtLast = Integer.parseInt(last);
                                if (cvtLast == jadwal.getJenisAngsuran()) {
                                    Vector<JadwalAngsuran> tempListJa = PstJadwalAngsuran.list(0, 0, "DATE(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")"
                                            + "= DATE('" + jadwal.getTanggalAngsuran() + "')", "");
                                    JadwalAngsuran nextJa = new JadwalAngsuran();
                                    if (tempListJa.size() > 1) {
                                        for (JadwalAngsuran ja : tempListJa) {
                                            if (ja.getJenisAngsuran() != jadwal.getJenisAngsuran()) {
                                                nextJa = ja;
                                            }
                                        }
                                    }
                                    jenisAngsuranText = JadwalAngsuran.getTipeAngsuranRadityaTitle(JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA);
                                    htmlReturn += ""
                                            + "<tr class='" + warning + "'>"
                                            + "   <td>" + index + ".</td>"
                                            + "   <td>" + Formater.formatDate(jadwal.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
                                            + "   <td>" + jenisAngsuranText + "</td>"
                                            + "   <td class='text-right money'>" + (totalSisa + nextJa.getJumlahANgsuran()) + "</td>"
                                            + "   <td class='text-right money'>" + totalDisc + "</td>"
                                            + "   <td class='text-right money'>" + (totalBayar - totalDisc) + "</td>"
                                            + "</tr>"
                                            + "";
                                    index++;
                                    totalSisa = 0;
                                    totalBayar = 0;
                                    totalDisc = 0;
                                }
                            }
                        }
                    }
                }
            } catch (NumberFormatException | DBException e) {
                errMsg += "<i class='fa fa-exclamation-circle text-red'></i> " + e.getMessage() + "<br>";
                printErrorMessage(e.getMessage());
            }
        }

        if (biaya > 0) {
            totalDibayar += biaya;
            htmlReturn += ""
                    + "<tr>"
                    + "   <td>" + index + ".</td>"
                    + "   <td colspan='4' class='text-center'>Biaya Lain</td>"
                    + "   <td class='text-right money'>" + biaya + "</td>"
                    + "</tr>"
                    + "";
        }
        if (selisihBayar > 0) {
            errMsg += "<i class='fa fa-exclamation-circle text-red'></i> Terdapat selisih antara sisa angsuran dengan jumlah dibayar !<br>";
        }
        htmlReturn += ""
                + "<tr>"
                + "   <td class='text-right text-bold' colspan='5'>TOTAL : </td>"
                + "   <td class='text-right text-bold money'>" + ( totalDibayar - totalDisc ) + "</td>"
                + "</tr>"
                + "";
        htmlReturn += "</table>";
        //
        htmlReturn += ""
                + "<label>Jenis Pembayaran :</label>"
                + "<table class='table table-bordered' style='font-size: 14px'>"
                + "   <tr class='label-success'>"
                + "       <th style='width: 1%'>No.</th>"
                + "       <th>Tipe Pembayaran</th>"
                + "       <th>Detail</th>"
                + "       <th>Nominal</th>"
                + "   </tr>";

        double totalUang = 0;
        String[] arrayPaymentType = request.getParameterValues("FORM_PAYMENT_ID");
        String[] arrayPaymentValue = request.getParameterValues("FORM_JUMLAH_SETORAN");
        for (int i = 0; i < arrayPaymentType.length; i++) {
            try {
                totalUang += Double.valueOf(arrayPaymentValue[i]);
                PaymentSystem ps = PstPaymentSystem.fetchExc(Long.valueOf(arrayPaymentType[i]));
                String keterangan = "";
                if (ps.getPaymentType() == AngsuranPayment.TIPE_PAYMENT_SAVING) {
                    Long simpananId = Long.valueOf(idSimpanan[i]);
                    DataTabungan dt = PstDataTabungan.fetchExc(simpananId);
                    AssignContactTabungan act = PstAssignContactTabungan.fetchExc(dt.getAssignTabunganId());
                    JenisSimpanan js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                    keterangan += "Nomor tabungan : " + act.getNoTabungan() + " (" + js.getNamaSimpanan() + ")";
                }
                htmlReturn += ""
                        + "<tr>"
                        + "   <td>" + (i + 1) + ".</td>"
                        + "   <td>" + ps.getPaymentSystem() + "</td>"
                        + "   <td>" + keterangan + "</td>"
                        + "   <td class='text-right money'>" + arrayPaymentValue[i] + "</td>"
                        + "</tr>"
                        + "";
            } catch (NumberFormatException | com.dimata.posbo.db.DBException | DBException e) {
                errMsg += "<i class='fa fa-exclamation-circle text-red'></i> " + e.getMessage() + "<br>";
                printErrorMessage(e.getMessage());
            }
        }
        htmlReturn += ""
                + "<tr>"
                + "   <td class='text-right text-bold' colspan='3'>TOTAL : </td>"
                + "   <td class='text-right text-bold money'>" + totalUang + "</td>"
                + "</tr>"
                + "";
        htmlReturn += "</table>"
                + "<div>" + errMsg + "</div>"
                + "";
        
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        
        return objValue;
        
    }

    public synchronized JSONObject pembayaranAngsuran(HttpServletRequest request, JSONObject objValue) throws JSONException{
        Pinjaman p = new Pinjaman();
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        String dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        try {
            p = PstPinjaman.fetchExc(oid);
        } catch (Exception exc) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", exc.getMessage());
            printErrorMessage(exc.getMessage());
            return objValue;
        }

        SessUserSession userSession = getUserSession(request);
        
        //Generate Penalty
        if (dataFor.equals("pembayaranAngsuran")) {
            String[] arrayJadwal = request.getParameterValues("FRM_FIELD_JADWAL_ANGSURAN_ID");
            String[] arrayDibayar = request.getParameterValues("FRM_FIELD_JUMLAH_ANGSURAN");
            String[] arrayDiscPct = request.getParameterValues("FRM_FIELD_DISC_PCT");
            String[] arrayDiscAmount = request.getParameterValues("FRM_FIELD_DISC_AMOUNT");
            String arrayJenisAngsuran[] = request.getParameterValues("FRM_FIELD_JENIS_ANGSURAN");
            for (int i = 0; i < arrayJadwal.length; i++) {
                String jadwal = arrayJadwal[i];
                if (jadwal.equals("-1")) {
                    int useRounding = 0;
                    try {
                        useRounding = Integer.valueOf(PstSystemProperty.getValueByName("GUNAKAN_PEMBULATAN_ANGSURAN"));
                    } catch (Exception exc) {
                        printErrorMessage(exc.getMessage());
                    }

                    double pembulatan = Double.valueOf(arrayDibayar[i]);
                    if (useRounding == 1) {
                        pembulatan = (Math.floor((Double.valueOf(arrayDibayar[i]) + 499) / 500)) * 500;
                    }
                    double sisa = pembulatan - Double.valueOf(arrayDibayar[i]);
                    try {
                        long idTransaksi = 0;
                        int useCaseType = Transaksi.USECASE_TYPE_KREDIT_PENALTY_MACET_PENCATATAN;
                        String kodeTransaksi = Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_PENALTI_MACET;
                        if (Integer.valueOf(arrayJenisAngsuran[i]) == JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_DINI) {
                            useCaseType = Transaksi.USECASE_TYPE_KREDIT_PENALTY_DINI_PENCATATAN;
                            kodeTransaksi = Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_PENALTI_LUNAS_DINI;
                        }

                        //buat transaksi pencatatan penalty
                        String tgl = FRMQueryString.requestString(request, "TGL_TRANSAKSI_PEMBAYARAN");
                        Date tglBayar = Formater.formatDate(tgl, "yyyy-MM-dd HH:mm:ss");
                        String nomorTransaksi = PstTransaksi.generateKodeTransaksi(kodeTransaksi, useCaseType, tglBayar);

                        //kurangi tgl bayar 1 detik
                        Calendar cal = Calendar.getInstance();
                        cal.setTime(tglBayar);
                        cal.add(Calendar.SECOND, -1);
                        tglBayar = cal.getTime();

                        String whereClause = PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+"='"+Formater.formatDate(tglBayar, "yyyy-MM-dd HH:mm:ss")+"' AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]+"="+p.getOID();
                        Vector listTransaksi = PstTransaksi.list(0, 0, whereClause, "");
                        if (listTransaksi.size()>0){
                            return objValue;
                        }
                        
                        Transaksi transaksi = new Transaksi();
                        transaksi.setTanggalTransaksi(tglBayar);
                        transaksi.setKodeBuktiTransaksi(nomorTransaksi);
                        transaksi.setIdAnggota(p.getAnggotaId());
                        transaksi.setTellerShiftId(oidTellerShift);
                        transaksi.setKeterangan(Transaksi.USECASE_TYPE_TITLE.get(useCaseType));
                        transaksi.setPinjamanId(p.getOID());
                        transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                        transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
                        transaksi.setUsecaseType(useCaseType);
                        transaksi.setAppUserId(userSession.getAppUser().getOID()); 
                        boolean isExisting = PstTransaksi.checkExisting(transaksi);
                        if(!isExisting){
                            idTransaksi = PstTransaksi.insertExc(transaksi);
                        }
                        if (idTransaksi != 0) {

                            //buat jadwal penalty
                            JadwalAngsuran jadwalAngsuran = new JadwalAngsuran();
                            jadwalAngsuran.setPinjamanId(p.getOID());
                            jadwalAngsuran.setTanggalAngsuran(new Date());
                            jadwalAngsuran.setJenisAngsuran(Integer.valueOf(arrayJenisAngsuran[i]));
                            jadwalAngsuran.setJumlahANgsuran(pembulatan);
                            jadwalAngsuran.setTransaksiId(idTransaksi);
                            jadwalAngsuran.setParentJadwalAngsuranId(0);
                            jadwalAngsuran.setStartDate(new Date());
                            jadwalAngsuran.setEndDate(new Date());
                            jadwalAngsuran.setJumlahAngsuranSeharusnya(Double.valueOf(arrayDibayar[i]));
                            jadwalAngsuran.setSisa(sisa);
                            arrayJadwal[i] = String.valueOf(PstJadwalAngsuran.insertExc(jadwalAngsuran));

                        }
                    } catch (DBException e) {
                        printErrorMessage(e.getMessage());
                        return objValue;
                    }
                }
            }
        }

        //save transaksi
        long idTransaksi = 0;
        String typeCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
        int jenisAng = FRMQueryString.requestInt(request, "FRM_FIELD_JENIS_ANGSURAN");
        if (jenisAng == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA) {
            idTransaksi = saveTransaksiPembayaranAngsuranDenganBunga(request, p, Transaksi.KODE_TRANSAKSI_KREDIT_PEMBAYARAN_ANGSURAN, Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT, objValue);
            if (idTransaksi == 0) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Gagal melakukan penyimpanan transaksi.");
                return objValue;
            }
        } else {
            idTransaksi = saveTransaksiPembayaranAngsuran(request, p, Transaksi.KODE_TRANSAKSI_KREDIT_PEMBAYARAN_ANGSURAN, Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT);
            if (idTransaksi == 0) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Gagal melakukan penyimpanan transaksi.");
                return objValue;
            }

        }

        //save tabel aiso_angsuran
        if (jenisAng != JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA) {
            List<Long> listIdAngsuran = saveAngsuran(request, idTransaksi);
            //save tabel sedana_angsuran_payment        
            List<Long> listIdAngsuranPayment = saveAngsuranPayment(request, idTransaksi);
            //save tabel sedana_transaksi_detail
            List<Long> listIdDetailTransaksi = saveDetailTransaksiAngsuran(request, p, listIdAngsuranPayment, idTransaksi);
            if (typeCredit.equals("1") && p.getBillMainId() != 0) {
                //simpan transaksi biaya (jika ada)
                saveTransaksiBiaya(request, p, idTransaksi);
            }
        }

        //generate jadwal bunga baru
        if (objValue.optInt("iErrCode",0) == 0) {
            if (p.getTipeJadwal() == Pinjaman.TIPE_JADWAL_ON_PAID) {
                try {
                    String tgl = FRMQueryString.requestString(request, "TGL_TRANSAKSI_PEMBAYARAN");
                    Date tglBayar = Formater.formatDate(tgl, "yyyy-MM-dd");
                    SessKreditKalkulasi.generateNewJadwalIfNecessary(p, oidTellerShift, tglBayar, PstTransaksi.fetchExc(idTransaksi));
                } catch (Exception ex) {
                    printErrorMessage(ex.getMessage());
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", ex.getMessage());
                    return objValue;
                }
            }
        }

        
        //update tanggal pembayaran di bill
        String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        if (p.getBillMainId()>0){
            try {
                BillMain billMain = PstBillMain.fetchExc(p.getBillMainId());
                if(billMain.getFirstPaymentDate() == null){
                    billMain.setFirstPaymentDate(new Date());
                    PstBillMain.updateExc(billMain);
                    String url = posApiUrl + "/bill/billmain/update-first-pay-date/"+Formater.formatDate(billMain.getFirstPaymentDate(),"yyyy-MM-dd")+"/"+Formater.formatDate(billMain.getFirstPaymentDate(),"HH:mm:ss")+"/"+billMain.getOID();
                    JSONObject res = WebServices.getAPI("", url);
                }
            } catch (Exception exc){
                
            }
        }
        
        //cek apakah angsuran adalah pembayaran DP kredit barang
        boolean angsuranDp = FRMQueryString.requestBoolean(request, "FRM_ANGSURAN_DP");
        if (angsuranDp) {
            updateTanggalJadwal(p, idTransaksi);
            //print out faktur
            objValue.put("FRM_FIELD_HTML", getPrintOutFaktur(idTransaksi, request));
            return objValue;
        }

        //print out nota pembayaran
        if (objValue.optInt("iErrCode",0) == 0) {
            //cek apakah tipe kredit adalah kredit barang
            if (typeCredit.equals("1") && p.getBillMainId() != 0) {
                objValue.put("FRM_FIELD_HTML", getPrintOutNota(idTransaksi, request));
            } else {
                getPrintOutAngsuranKredit(request, idTransaksi, objValue);
            }
        }
        
        return objValue;
    }

    public synchronized void updateTanggalJadwal(Pinjaman p, long idTransaksi) {
        //UPDATE TGL JADWAL ANGSURAN MENGIKUTI TGL BAYAR DP
        //cari transaksi pembayaran DP (angsuran pokok pertama)
        String whereTransaksi = PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = " + p.getOID()
                + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = " + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT;
        Vector<Transaksi> listTransaksiDp = PstTransaksi.list(0, 1, whereTransaksi, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " ASC ");
        if (!listTransaksiDp.isEmpty()) {
            try {
                Date tglBayarDP = listTransaksiDp.get(0).getTanggalTransaksi();
                //cari semua jadwal pokok
                String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
                Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, whereJadwal, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " ASC ");
                for (JadwalAngsuran ja : listJadwal) {
                    ja.setTanggalAngsuran(tglBayarDP);
                    PstJadwalAngsuran.updateExc(ja);

                    //set tgl untuk bulan berikutnya
                    Calendar c = Calendar.getInstance();
                    c.setTime(tglBayarDP);
                    c.add(Calendar.MONTH, 1);
                    tglBayarDP = c.getTime();
                }
            } catch (Exception e) {
                printErrorMessage(e.getMessage());
            }
        } else {
            printErrorMessage("Gagal update tanggal jadwal saat bayar DP. Transaksi bayar DP tidak ditemukan.");
        }

        //UPDATE TGL JADWAL ANGSURAN MENGIKUTI TGL BAYAR DP
        //cari transaksi pembayaran DP (angsuran pokok pertama)
//        String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + "=" + p.getOID();
//        String order = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " ASC ";
//        Vector<JadwalAngsuran> listJadwalAngsuran = PstJadwalAngsuran.list(0, 0, whereClause, order);
//        if(!listJadwalAngsuran.isEmpty()){
//            for(JadwalAngsuran ja : listJadwalAngsuran){
//                whereClause = PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = " + p.getOID()
//                        + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = " + ja.getJenisAngsuran();
//                Vector<Transaksi> listTransaksiDp = PstTransaksi.list(0, 0, whereClause, "");
//                
//            }
//        }
//        if (!listTransaksiDp.isEmpty()) {
//            try {
//                Date tglBayarDP = listTransaksiDp.get(0).getTanggalTransaksi();
//                //cari semua jadwal pokok
//                String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
//                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
//                Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, whereJadwal, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " ASC ");
//                for (JadwalAngsuran ja : listJadwal) {
//                    ja.setTanggalAngsuran(tglBayarDP);
//                    PstJadwalAngsuran.updateExc(ja);
//
//                    //set tgl untuk bulan berikutnya
//                    Calendar c = Calendar.getInstance();
//                    c.setTime(tglBayarDP);
//                    c.add(Calendar.MONTH, 1);
//                    tglBayarDP = c.getTime();
//                }
//            } catch (Exception e) {
//                objValue.put("RETURN_ERROR_CODE", 1);
//                this.objValue.put("RETURN_MESSAGE", e.toString());
//                printErrorMessage(e.getMessage());
//            }
//        } else {
//            printErrorMessage("Gagal update tanggal jadwal saat bayar DP. Transaksi bayar DP tidak ditemukan.");
//        }
    }

    public synchronized String getKodeTransaksi(String kodeTransaksi, int useCaseType, String tgl) {
        String nomorTransaksi = "";
        String where = ""
                + " DATE(" + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") = '" + tgl + "'"
                + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = " + useCaseType + "";
        int last = PstTransaksi.getCount(where);
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
            nomorTransaksi = kodeTransaksi + tgl.replace("-", "") + "-" + newLast;
            Vector listTransaksi = PstTransaksi.list(0, 0, "" + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " = '" + nomorTransaksi + "'", "");
            if (listTransaksi.isEmpty()) {
                check = 0;
            } else {
                last += 1;
            }
        }
        return nomorTransaksi;
    }

    public synchronized long saveTransaksiPembayaranAngsuran(HttpServletRequest request, Pinjaman p, String kodeTransaksi, int useCaseType) {
        long idTransaksi = 0;
        //buat kode transaksi
        long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        long userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
        Date tglBayar = new Date();
        String keterangan = FRMQueryString.requestString(request, "KETERANGAN_TRANSAKSI_PEMBAYARAN");
        String tgl = FRMQueryString.requestString(request, "TGL_TRANSAKSI_PEMBAYARAN");
        try {
            tglBayar = Formater.formatDate(tgl, "yyyy-MM-dd HH:mm:ss");
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        
        String whereClause = PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+"='"+tgl+"' AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]+"="+p.getOID()
                +" AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE]+"="+useCaseType;
        Vector listTransaksi = PstTransaksi.list(0, 0, whereClause, "");
        if (listTransaksi.size()>0){
            return 0;
        }
        
        String nomorTransaksi = PstTransaksi.generateKodeTransaksi(kodeTransaksi, useCaseType, tglBayar);
        if (keterangan.isEmpty()) {
            keterangan = Transaksi.USECASE_TYPE_TITLE.get(useCaseType);
        } else {
            keterangan = Transaksi.USECASE_TYPE_TITLE.get(useCaseType) + ". CATATAN : " + keterangan;
        }

        //save tabel sedana_transaksi
        Transaksi transaksi = new Transaksi();
        transaksi.setTanggalTransaksi(tglBayar);
        transaksi.setKodeBuktiTransaksi(nomorTransaksi);
        transaksi.setIdAnggota(p.getAnggotaId());
        transaksi.setTellerShiftId(oidTellerShift);
        transaksi.setKeterangan(keterangan);
        transaksi.setPinjamanId(p.getOID());
        transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_OPEN);
        transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
        transaksi.setUsecaseType(useCaseType);
        transaksi.setAppUserId(userId); 
        try {
            boolean isExisting = PstTransaksi.checkExisting(transaksi);
            if(!isExisting){
                idTransaksi = PstTransaksi.insertExc(transaksi);
                //message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
            }
        } catch (DBException ex) {
//            objValue.put("RETURN_ERROR_CODE", 1);
//            objValue.put("RETURN_MESSAGE", ex.toString());
            printErrorMessage(ex.getMessage());
        }
        return idTransaksi;
    }

    public synchronized long saveTransaksiPembayaranAngsuranDenganBunga(HttpServletRequest request, Pinjaman p, String kodeTransaksi, int useCaseType, JSONObject objValue) {
        long idTransaksi = 0;
        //buat kode transaksi
        Date tglBayar = new Date();
        String keterangan = FRMQueryString.requestString(request, "KETERANGAN_TRANSAKSI_PEMBAYARAN");
        String tgl = FRMQueryString.requestString(request, "TGL_TRANSAKSI_PEMBAYARAN");
        long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        long userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
        try {
            tglBayar = Formater.formatDate(tgl, "yyyy-MM-dd HH:mm:ss");
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        
        String whereClause = PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+"='"+tgl+"' AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]+"="+p.getOID()
                +" AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE]+"="+useCaseType;
        Vector listTransaksi = PstTransaksi.list(0, 0, whereClause, "");
        if (listTransaksi.size()>0){
            return 0;
        }
        
        String nomorTransaksi = PstTransaksi.generateKodeTransaksi(kodeTransaksi, useCaseType, tglBayar);
        if (keterangan.isEmpty()) {
            keterangan = Transaksi.USECASE_TYPE_TITLE.get(useCaseType);
        } else {
            keterangan = Transaksi.USECASE_TYPE_TITLE.get(useCaseType) + ". CATATAN : " + keterangan;
        }

        //save tabel sedana_transaksi
        Transaksi transaksi = new Transaksi();
        transaksi.setTanggalTransaksi(tglBayar);
        transaksi.setKodeBuktiTransaksi(nomorTransaksi);
        transaksi.setIdAnggota(p.getAnggotaId());
        transaksi.setTellerShiftId(oidTellerShift);
        transaksi.setKeterangan(keterangan);
        transaksi.setPinjamanId(p.getOID());
        transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_OPEN);
        transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
        transaksi.setUsecaseType(useCaseType);
        transaksi.setAppUserId(userId); 
        try {
            boolean isExisting = PstTransaksi.checkExisting(transaksi);
            if(!isExisting){
                idTransaksi = PstTransaksi.insertExc(transaksi);
            }
        } catch (Exception e) {
//            message = "Gagal membuat transaksi.";
//            objValue.put("RETURN_ERROR_CODE", 1);
            return 0;
        }

        if (objValue.optInt("iErrCode",0) == 0) {
            String typeCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
            String[] arrayJadwal = request.getParameterValues("FRM_FIELD_JADWAL_ANGSURAN_ID");
            for (int i = 0; i < arrayJadwal.length; i++) {
                String jadwal = arrayJadwal[i];
                String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + jadwal;
                Vector listData = PstJadwalAngsuran.list(0, 0, where, "");
                JadwalAngsuran jad = new JadwalAngsuran();
                for (int x = 0; x < listData.size(); x++) {
                    jad = (JadwalAngsuran) listData.get(x);
                    try {
                        long listIdAngsuran = saveAngsuranDenganBunga(request, idTransaksi, jad, p);
                        if (typeCredit.equals("1") && p.getBillMainId() != 0) {
                            //simpan transaksi biaya (jika ada)
                            saveTransaksiBiaya(request, p, idTransaksi);
                        }
                        //message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                    } catch (Exception ex) {
                        printErrorMessage(ex.getMessage());
                    }
                }
            }
        }
        return idTransaksi;
    }

    public synchronized List<Long> saveAngsuran(HttpServletRequest request, long idTransaksi) {
        List<Long> listAngsuranId = new ArrayList<Long>();
        String dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        if (dataFor.equals("bayarSeluruhAngsuranBunga")) {

            Vector listSisaJadwalBunga = SessKredit.getListSisaJadwalBunga(oid, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
            for (int i = 0; i < listSisaJadwalBunga.size(); i++) {
                JadwalAngsuran ja = (JadwalAngsuran) listSisaJadwalBunga.get(i);
                double dibayar = SessReportKredit.getSumAngsuranDibayar(ja.getOID());
                double sisa = ja.getJumlahANgsuran() - dibayar;
                Angsuran a = new Angsuran();
                a.setJadwalAngsuranId(ja.getOID());
                a.setJumlahAngsuran(sisa);
                a.setTransaksiId(idTransaksi);
                try {
                    long idAngsuran = PstAngsuran.insertExc(a);
                    //message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                    listAngsuranId.add(idAngsuran);
                } catch (DBException ex) {
                    //message = ex.getMessage();
                    printErrorMessage(ex.getMessage());
                }
            }

        } else if (dataFor.equals("pembayaranAngsuran")) {

            String[] arrayJadwal = request.getParameterValues("FRM_FIELD_JADWAL_ANGSURAN_ID");; //request.getParameterValues("FRM_FIELD_JADWAL_ANGSURAN_ID");
            String[] arrayDibayar = request.getParameterValues("FRM_FIELD_JUMLAH_ANGSURAN");; //request.getParameterValues("FRM_FIELD_JUMLAH_ANGSURAN");
            String[] arrayDiscPct = request.getParameterValues("FRM_FIELD_DISC_PCT");
            String[] arrayDiscAmount = request.getParameterValues("FRM_FIELD_DISC_AMOUNT");
            String[] jumlahUang = request.getParameterValues("FORM_JUMLAH_SETORAN");	
            String[] multiBiayaDibayar = request.getParameterValues("FRM_BIAYA_DIBAYAR");
            double jumlah = 0;
            if (jumlahUang != null){
                for (int i = 0; i < jumlahUang.length; i++) {
                    jumlah += Double.valueOf(jumlahUang[i]);
                }
            }
            if (multiBiayaDibayar != null){
                for (int i = 0; i < multiBiayaDibayar.length; i++) {
                    jumlah -= Double.valueOf(multiBiayaDibayar[i].replaceAll("[.]", ""));
                }
            }
            double jumlahDibayar = 0;
            if (arrayDibayar != null){
                for (int i = 0; i < arrayDibayar.length; i++) {
                    jumlahDibayar += Double.valueOf(arrayDibayar[i]);
                }
            }
            double disc = 0;
            if (arrayDiscAmount != null){
                for (int i = 0; i < arrayDiscAmount.length; i++) {
                    jumlahDibayar -= Double.valueOf(arrayDiscAmount[i]);
                }
            }
            if (jumlah != jumlahDibayar){
                long idJadwal = Long.valueOf(arrayJadwal[0]);
                try {
                    JadwalAngsuran ja = PstJadwalAngsuran.fetchExc(idJadwal);
                    String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]+" >= '"+ja.getTanggalAngsuran()+"' AND "
                                        +PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+" = "+ja.getPinjamanId();
                    Vector listJadwal = PstJadwalAngsuran.list(0, 0, whereJadwal, "tanggal_angsuran, jenis_angsuran");
                    for (int x = 0; x < listJadwal.size(); x++){
                        JadwalAngsuran jad = (JadwalAngsuran) listJadwal.get(x);
                        double sudahDiBayar = SessReportKredit.getSumAngsuranDibayar(jad.getOID());
                        double jumlahAngsuran = jad.getJumlahANgsuran();
                        double dibayar = jumlahAngsuran - sudahDiBayar;
                        if(dibayar <= 0){
                            continue;
                        }
                        if (jumlah < dibayar) {
                            dibayar = jumlah;
                        }
                        Angsuran a = new Angsuran();
                        a.setJadwalAngsuranId(jad.getOID());
                        a.setJumlahAngsuran(dibayar);
                        a.setTransaksiId(idTransaksi);
                        a.setDiscPct(0);
                        a.setDiscAmount(0);
                        try {
                            long idAngsuran = PstAngsuran.insertExc(a);
                            //message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                            listAngsuranId.add(idAngsuran);
                        } catch (DBException ex) {
                            //message = ex.getMessage();
                            printErrorMessage(ex.getMessage());
                        }
                        jumlah -= dibayar;
                        if (jumlah <= 0) {
                            break;
                        }
                        
                    }
                } catch (Exception exc){
                    
                }
            } else {
                for (int i = 0; i < arrayJadwal.length; i++) {
                    long idJadwal = Long.valueOf(arrayJadwal[i]);
                    double jumlahBayar = Double.valueOf(arrayDibayar[i]);
                    double discPct = Double.valueOf(arrayDiscPct[i]);
                    double discAmount = Double.valueOf(arrayDiscAmount[i]);
                    Angsuran a = new Angsuran();
                    a.setJadwalAngsuranId(idJadwal);
                    a.setJumlahAngsuran(jumlahBayar);
                    a.setTransaksiId(idTransaksi);
                    a.setDiscPct(discPct);
                    a.setDiscAmount(discAmount);
                    try {
                        long idAngsuran = PstAngsuran.insertExc(a);
                        //message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                        listAngsuranId.add(idAngsuran);
                    } catch (DBException ex) {
                        //message = ex.getMessage();
                        printErrorMessage(ex.getMessage());
                    }
                }
            }
        }

        return listAngsuranId;
    }

    public synchronized Long saveAngsuranDenganBunga(HttpServletRequest request, long idTransaksi, JadwalAngsuran jad, Pinjaman p) {
        long listAngsuranId = 0;

        String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + jad.getTanggalAngsuran() + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + jad.getPinjamanId();
        Vector listDataa = PstJadwalAngsuran.list(0, 0, where, "");
        for (int xx = 0; xx < listDataa.size(); xx++) {
            JadwalAngsuran jada = (JadwalAngsuran) listDataa.get(xx);
            long idJadwal = jada.getOID();
            double jumlahAngsuran = jada.getJumlahANgsuran();
            Angsuran a = new Angsuran();
            a.setJadwalAngsuranId(idJadwal);
            a.setJumlahAngsuran(jumlahAngsuran);
            a.setTransaksiId(idTransaksi);
            try {
                long idAngsuran = PstAngsuran.insertExc(a);
                List<Long> listIdAngsuranPayment = saveAngsuranPaymentDenganBunga(request, idTransaksi, jada);
                List<Long> listIdDetailTransaksi = saveDetailTransaksiAngsuran(request, p, listIdAngsuranPayment, idTransaksi);
                //message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                listAngsuranId = idAngsuran;
            } catch (DBException ex) {
                //message = ex.getMessage();
                printErrorMessage(ex.getMessage());
            }
        }

        return listAngsuranId;
    }

    public synchronized List<Long> saveAngsuranPayment(HttpServletRequest request, long idTransaksi) {
        List<Long> listAngsuranPaymentId = new ArrayList<Long>();
        //payment detail
        String[] paymentCode = request.getParameterValues("FORM_PAYMENT_TYPE");
        String[] paymentId = request.getParameterValues("FORM_PAYMENT_ID");
        String[] jumlahUang = request.getParameterValues("FORM_JUMLAH_SETORAN");
        //tambahan untuk credit/debit card
        String[] nomorKartu = request.getParameterValues("FORM_CARD_NUMBER");
        String[] namaBank = request.getParameterValues("FORM_BANK_NAME");
        String[] tglValidate = request.getParameterValues("FORM_VALIDATE");
        //kusus credit card
        String[] namaKartu = request.getParameterValues("FORM_CARD_NAME");
        //untuk tabungan
        String[] idSimpanan = request.getParameterValues("FORM_OID_SIMPANAN");

        for (int i = 0; i < paymentCode.length; i++) {
            long idPayment = Long.valueOf(paymentId[i]);
            double jumlah = Double.valueOf(jumlahUang[i]);

            AngsuranPayment ap = new AngsuranPayment();
            ap.setPaymentSystemId(idPayment);
            ap.setJumlah(jumlah);
            ap.setStatus(AngsuranPayment.STATUS_DOC_CLOSE);
            ap.setTransaksiId(idTransaksi);
            //tambahan untuk kartu
            if (paymentCode[i].equals("" + AngsuranPayment.TIPE_PAYMENT_CREDIT_CARD) || paymentCode[i].equals("" + AngsuranPayment.TIPE_PAYMENT_DEBIT_CARD)) {
                ap.setCardNumber(nomorKartu[i]);
                ap.setBankName(namaBank[i]);
                ap.setValidateDate(Formater.formatDate(tglValidate[i], "yyyy-MM-dd"));
                //kusus credit card
                if (paymentCode[i].equals("" + AngsuranPayment.TIPE_PAYMENT_CREDIT_CARD)) {
                    ap.setCardName(namaKartu[i]);
                }
            }
            if (paymentCode[i].equals("" + AngsuranPayment.TIPE_PAYMENT_SAVING)) {
                if (!idSimpanan[i].equals("") || !idSimpanan[i].equals("0")) {
                    ap.setIdSimpanan(Long.valueOf(idSimpanan[i]));
                }
            }

            try {
                long oidAngsuranPayment = PstAngsuranPayment.insertExc(ap);
                //message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                listAngsuranPaymentId.add(oidAngsuranPayment);
            } catch (DBException ex) {
//                objValue.put("RETURN_ERROR_CODE", 1);
//                message = ex.getMessage();
                printErrorMessage(ex.getMessage());
            }
        }
        return listAngsuranPaymentId;
    }

    public synchronized List<Long> saveAngsuranPaymentDenganBunga(HttpServletRequest request, long idTransaksi, JadwalAngsuran jad) {
        List<Long> listAngsuranPaymentId = new ArrayList<Long>();
        //payment detail
        String[] paymentCode = request.getParameterValues("FORM_PAYMENT_TYPE");
        String[] paymentId = request.getParameterValues("FORM_PAYMENT_ID");
        String[] jumlahUang = request.getParameterValues("FORM_JUMLAH_SETORAN");
        //tambahan untuk credit/debit card
        String[] nomorKartu = request.getParameterValues("FORM_CARD_NUMBER");
        String[] namaBank = request.getParameterValues("FORM_BANK_NAME");
        String[] tglValidate = request.getParameterValues("FORM_VALIDATE");
        //kusus credit card
        String[] namaKartu = request.getParameterValues("FORM_CARD_NAME");
        //untuk tabungan
        String[] idSimpanan = request.getParameterValues("FORM_OID_SIMPANAN");

        for (int i = 0; i < paymentCode.length; i++) {
            long idPayment = Long.valueOf(paymentId[i]);
            double jumlah = Double.valueOf(jumlahUang[i]);

            AngsuranPayment ap = new AngsuranPayment();
            ap.setPaymentSystemId(idPayment);
            ap.setJumlah(jad.getJumlahANgsuran());
            ap.setStatus(AngsuranPayment.STATUS_DOC_CLOSE);
            ap.setTransaksiId(idTransaksi);
            //tambahan untuk kartu
            if (paymentCode[i].equals("" + AngsuranPayment.TIPE_PAYMENT_CREDIT_CARD) || paymentCode[i].equals("" + AngsuranPayment.TIPE_PAYMENT_DEBIT_CARD)) {
                ap.setCardNumber(nomorKartu[i]);
                ap.setBankName(namaBank[i]);
                ap.setValidateDate(Formater.formatDate(tglValidate[i], "yyyy-MM-dd"));
                //kusus credit card
                if (paymentCode[i].equals("" + AngsuranPayment.TIPE_PAYMENT_CREDIT_CARD)) {
                    ap.setCardName(namaKartu[i]);
                }
            }
            if (paymentCode[i].equals("" + AngsuranPayment.TIPE_PAYMENT_SAVING)) {
                if (!idSimpanan[i].equals("") || !idSimpanan[i].equals("0")) {
                    ap.setIdSimpanan(Long.valueOf(idSimpanan[i]));
                }
            }

            try {
                long oidAngsuranPayment = PstAngsuranPayment.insertExc(ap);
                //message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                listAngsuranPaymentId.add(oidAngsuranPayment);
            } catch (DBException ex) {
//                objValue.put("RETURN_ERROR_CODE", 1);
//                message = ex.getMessage();
                printErrorMessage(ex.getMessage());
            }
        }
        return listAngsuranPaymentId;
    }

    public synchronized List<Long> saveDetailTransaksiAngsuran(HttpServletRequest request, Pinjaman p, List<Long> listIdAngsuranPayment, long idTransaksi) {
        List<Long> listDetailTransaksiId = new ArrayList<Long>();
        String[] idSimpanan = request.getParameterValues("FORM_OID_SIMPANAN");
        String[] jumlahUang = request.getParameterValues("FORM_JUMLAH_SETORAN");
        long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        long userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
        long idTransaksiPenarikan = 0;
        for (int i = 0; i < idSimpanan.length; i++) {
            try {
                if (idSimpanan[i].equals("") || idSimpanan[i].equals("0")) {
                    continue;
                }

                if (idTransaksiPenarikan == 0) {
                    //BUAT TRANSAKSI PENARIKAN TABUNGAN
                    Transaksi pembayaran = PstTransaksi.fetchExc(idTransaksi);

                    Date tglTransaksi = new Date();
                    String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_TABUNGAN_PENARIKAN, Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN, tglTransaksi);

                    Transaksi t = new Transaksi();
                    t.setTanggalTransaksi(tglTransaksi);
                    t.setIdAnggota(p.getAnggotaId());
                    t.setTellerShiftId(oidTellerShift);
                    t.setKeterangan("Penarikan tabungan untuk pembayaran kredit. No kredit : " + p.getNoKredit() + ". No transaksi pembayaran : " + pembayaran.getKodeBuktiTransaksi());
                    t.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                    t.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERKURANG);
                    t.setUsecaseType(Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN);
                    t.setKodeBuktiTransaksi(nomorTransaksi);
                    t.setTransaksiParentId(idTransaksi);
                    t.setAppUserId(userId);
                    idTransaksiPenarikan = PstTransaksi.insertExc(t);
                }

                //cari id jenis transaksi penarikan cash
                Vector<JenisTransaksi> listJenisTransaksi = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + " = '" + JenisTransaksi.TIPE_ARUS_KAS_BERKURANG + "'"
                        + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_PROSEDUR] + " = '" + JenisTransaksi.TIPE_PROSEDUR_BY_TELLER + "'"
                        + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = '" + JenisTransaksi.TUJUAN_PROSEDUR_TABUNGAN + "'"
                        + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_TRANSAKSI] + " = '" + JenisTransaksi.TIPE_TRANSAKSI_NORMAL + "'", "");
                long jenisTransId = 0;
                if (!listJenisTransaksi.isEmpty()) {
                    jenisTransId = listJenisTransaksi.get(0).getOID();
                } else {
//                    this.message = "ID jenis transaksi penarikan cash tidak ditemukan!";
//                    objValue.put("RETURN_ERROR_CODE", 1);
                }

                //set detail info
                DetailTransaksi detailTransaksi = new DetailTransaksi();
                detailTransaksi.setTransaksiId(idTransaksiPenarikan);
                detailTransaksi.setJenisTransaksiId(jenisTransId);
                detailTransaksi.setDebet(Double.valueOf(jumlahUang[i]));
                detailTransaksi.setKredit(0);
                detailTransaksi.setIdSimpanan(Long.valueOf(idSimpanan[i]));
                long idDetailTransaksi = PstDetailTransaksi.insertExc(detailTransaksi);

                //set payment system
                long idPaymentSystemCash = 0;
                Vector<PaymentSystem> listPS = PstPaymentSystem.list(0, 1, PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_TYPE] + " = " + AngsuranPayment.TIPE_PAYMENT_CASH, null);
                if (listPS.isEmpty()) {
//                    this.message = "ID payment system cash tidak ditemukan!";
//                    objValue.put("RETURN_ERROR_CODE", 1);
                } else {
                    idPaymentSystemCash = listPS.get(0).getOID();
                }
                TransaksiPayment tp = new TransaksiPayment();
                tp.setPaymentSystemId(idPaymentSystemCash);
                tp.setJumlah(Double.valueOf(jumlahUang[i]));
                tp.setTransaksiId(idTransaksiPenarikan);
                PstTransaksiPayment.insertExc(tp);
                try {
                    BillMain bm = PstBillMain.fetchExc(p.getBillMainId());
                    bm.setBillStatus(I_DocStatus.DOCUMENT_STATUS_FINAL);
                    long billOid = PstBillMain.updateExc(bm);
                } catch (Exception e) {
                }
                //message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                listDetailTransaksiId.add(idDetailTransaksi);
            } catch (DBException ex) {
//                message = ex.getMessage();
//                objValue.put("RETURN_ERROR_CODE", 1);
                printErrorMessage(ex.getMessage());
            }

        }
        return listDetailTransaksiId;
    }

    public synchronized void saveTransaksiBiaya(HttpServletRequest request, Pinjaman p, long idTransaksi) {
        try {
            String[] multiJenisTransaksi = request.getParameterValues("FRM_ID_JENIS_TRANSAKSI");
            String[] multiBiayaDibayar = request.getParameterValues("FRM_BIAYA_DIBAYAR");
            long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
            long userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
            if (multiJenisTransaksi != null && multiJenisTransaksi.length > 0) {
                Date tglTransaksi = new Date();
                String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_KREDIT_PEMBAYARAN_BIAYA, Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN, tglTransaksi);
                //save transaksi
                Transaksi transaksi = new Transaksi();
                transaksi.setTanggalTransaksi(tglTransaksi);
                transaksi.setKodeBuktiTransaksi(nomorTransaksi);
                transaksi.setIdAnggota(p.getAnggotaId());
                transaksi.setTellerShiftId(oidTellerShift);
                transaksi.setKeterangan(Transaksi.USECASE_TYPE_TITLE.get(Transaksi.USECASE_TYPE_KREDIT_BIAYA));
                transaksi.setPinjamanId(p.getOID());
                transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_OPEN);
                transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
                transaksi.setUsecaseType(Transaksi.USECASE_TYPE_KREDIT_BIAYA);
                transaksi.setTransaksiParentId(idTransaksi);
                transaksi.setAppUserId(userId);
                long oidTransaksi = PstTransaksi.insertExc(transaksi);

                for (int i = 0; i < multiJenisTransaksi.length; i++) {
                    try {
                        if (!multiJenisTransaksi[i].equals("0") && !multiJenisTransaksi[i].equals("")) {
                            String jumlahBiayaStr = multiBiayaDibayar[i].replaceAll("[.]", "");
                            long idJenisTransaksi = Long.valueOf(multiJenisTransaksi[i]);
                            double biaya = Double.valueOf(jumlahBiayaStr);
                            //save detail transaksi
                            DetailTransaksi detailKredit = new DetailTransaksi();
                            detailKredit.setTransaksiId(oidTransaksi);
                            detailKredit.setJenisTransaksiId(idJenisTransaksi);
                            detailKredit.setDebet(biaya);
                            detailKredit.setKredit(0);
                            detailKredit.setTransaksiId(oidTransaksi);
                            long oidRes = PstDetailTransaksi.insertExc(detailKredit);
                            try {
                                if (oidRes != 0) {
                                    String whereClause = PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_JENIS_TRANSAKSI] + " = " + idJenisTransaksi
                                            + " AND " + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = " + p.getOID();
                                    Vector<BiayaTransaksi> listBiaya = PstBiayaTransaksi.list(0, 0, whereClause, "");
                                    for (BiayaTransaksi bt : listBiaya) {
                                        bt.setIdTransaksi(oidTransaksi);
                                        try {
                                            PstBiayaTransaksi.updateExc(bt);
                                        } catch (Exception e) {
                                            printErrorMessage(e.getMessage());
                                        }
                                    }
                                }
                            } catch (Exception e) {
                                printErrorMessage(e.getMessage());
                            }

                        }
                    } catch (NumberFormatException | DBException e) {
                        printErrorMessage(e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
    }

    //pencairan kredit----------------------------------------------------------
    public synchronized JSONObject pencairanKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        try {
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            
            Pinjaman p = PstPinjaman.fetchExc(oid);
            Anggota a = PstAnggota.fetchExc(p.getAnggotaId());

            String where = PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN + "'"
                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
                    + "";
            Vector<Transaksi> listPencairan = PstTransaksi.list(0, 0, where, null);
            if (listPencairan.size() > 0) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Pengajuan kredit dengan nomor " + p.getNoKredit() + " sudah cair pada tanggal " + Formater.formatDate(listPencairan.get(0).getTanggalTransaksi(), "dd MMM yyyy"));
                return objValue;
            }
            if (objValue.optInt("iErrCode",0) == 0) {
                objValue = hitungBiayaKredit(request, p, objValue);
            }
            if (objValue.optInt("iErrCode",0) == 0) {
                //createPrintOutPencairan(request, p);
            }

        } catch (Exception e) {
            objValue.put("RETURN_ERROR_CODE",1 );
            objValue.put("RETURN_MESSAGE", e.getMessage());
            printErrorMessage(e.getMessage());
            return objValue;
        }
        return objValue;
    }

    public JSONObject toProduction(HttpServletRequest request, JSONObject objValue) throws JSONException{
        try {
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
            Pinjaman p = PstPinjaman.fetchExc(oid);
            Anggota a = PstAnggota.fetchExc(p.getAnggotaId());

            String where = PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN + "'"
                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
                    + "";
            Vector<Transaksi> listPencairan = PstTransaksi.list(0, 0, where, null);
            if (listPencairan.size() > 0) {
                objValue.put("RETURN_ERROR_CODE", "1");
                objValue.put("message ", "Pengajuan kredit dengan nomor " + p.getNoKredit() + " sudah cair pada tanggal " + Formater.formatDate(listPencairan.get(0).getTanggalTransaksi(), "dd MMM yyyy"));
                return objValue;
            }

            //set kode transaksi
            Date tglTransaksi = new Date();
            String tglCair = FRMQueryString.requestString(request, "SEND_TANGGAL_CAIR");
            if (!tglCair.isEmpty()) {
                tglTransaksi = Formater.formatDate(tglCair, "yyyy-MM-dd HH:mm:ss");
                if (tglTransaksi == null) {
                    tglTransaksi = new Date();
                }
            }

//            String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_KREDIT_PENCAIRAN, Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN, tglTransaksi);
//            //save transaksi
//            Transaksi transaksi = new Transaksi();
//            transaksi.setTanggalTransaksi(tglTransaksi);
//            transaksi.setKodeBuktiTransaksi(nomorTransaksi);
//            transaksi.setIdAnggota(p.getAnggotaId());
//            transaksi.setTellerShiftId(this.oidTellerShift);
//            transaksi.setKeterangan(Transaksi.USECASE_TYPE_TITLE.get(Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN));
//            transaksi.setPinjamanId(p.getOID());
//            transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
//            transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
//            transaksi.setUsecaseType(Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN);
//            long oidTransaksi = 0;
//            try {
//                oidTransaksi = PstTransaksi.insertExc(transaksi);
//                message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
//            } catch (DBException ex) {
//                printErrorMessage(ex.getMessage());
//                objValue.put("RETURN_MESSAGE", ex.toString());
//                objValue.put("RETURN_ERROR_CODE", 1);
//                return;
//            }
//            //update data jadwal tambah id transaksi
//            if (iErrCode == 0) {
//                Vector<JadwalAngsuran> listJadwalPokokBunga = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
//                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " <> '" + JadwalAngsuran.TIPE_ANGSURAN_DENDA + "'", "");
//                for (int i = 0; i < listJadwalPokokBunga.size(); i++) {
//                    JadwalAngsuran ja = new JadwalAngsuran();
//                    long idJadwal = listJadwalPokokBunga.get(i).getOID();
//                    try {
//                        ja = PstJadwalAngsuran.fetchExc(idJadwal);
//                        ja.setTransaksiId(oidTransaksi);
//                        PstJadwalAngsuran.updateExc(ja);
//                    } catch (Exception e) {
//                        printErrorMessage(e.getMessage());
//                        objValue.put("RETURN_MESSAGE", e.toString());
//                        objValue.put("RETURN_ERROR_CODE", 1);
//                        return;
//                    }
//                }
//            }
            //ubah status kredit jadi cair (5)
            if (objValue.optInt("iErrCode",0) == 0) {
                p.setStatusPinjaman(Pinjaman.STATUS_DOC_CAIR);
                boolean result = false;
                try {
                    String url = posApiUrl + "/bill/billmain/update/" + p.getBillMainId() + "/" + PstBillMain.PETUGAS_DELIVERY_STATUS_ON_PRODUCTION;
                    JSONObject res = WebServices.getAPI("", url);
                    result = res.getBoolean("SUCCES");
                } catch (Exception e) {
                }
                try {
                    if (result) {
                        PstPinjaman.updateExc(p);
                    }
                } catch (DBException ex) {
                    printErrorMessage(ex.getMessage());
                    objValue.put("RETURN_MESSAGE", ex.toString());
                    objValue.put("RETURN_ERROR_CODE", 1);
                }
            }
        } catch (Exception e) {
            objValue.put("RETURN_MESSAGE", e.getMessage());
            objValue.put("RETURN_ERROR_CODE", 1);
            printErrorMessage(e.getMessage());
            return objValue;
        }
        return objValue;
    }

    public synchronized JSONObject hitungBiayaKredit(HttpServletRequest request, Pinjaman p, JSONObject objValue) throws JSONException{
        //get id simpanan
        long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        long idSimpanan = 0;
        Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, "" + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " = '" + p.getIdJenisSimpanan() + "'"
                + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = '" + p.getAssignTabunganId() + "'", "");
        if (!listSimpanan.isEmpty()) {
            idSimpanan = listSimpanan.get(0).getOID();
        }

        //set kode transaksi
        Date tglTransaksi = new Date();
        String tglCair = FRMQueryString.requestString(request, "SEND_TANGGAL_CAIR");
        if (!tglCair.isEmpty()) {
            tglTransaksi = Formater.formatDate(tglCair, "yyyy-MM-dd HH:mm:ss");
            if (tglTransaksi == null) {
                tglTransaksi = new Date();
            }
        }

        String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_KREDIT_PENCAIRAN, Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN, tglTransaksi);
        //save transaksi
        Transaksi transaksi = new Transaksi();
        transaksi.setTanggalTransaksi(tglTransaksi);
        transaksi.setKodeBuktiTransaksi(nomorTransaksi);
        transaksi.setIdAnggota(p.getAnggotaId());
        transaksi.setTellerShiftId(oidTellerShift);
        transaksi.setKeterangan(Transaksi.USECASE_TYPE_TITLE.get(Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN));
        transaksi.setPinjamanId(p.getOID());
        transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
        transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
        transaksi.setUsecaseType(Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN);
        long oidTransaksi = 0;
        try {
            oidTransaksi = PstTransaksi.insertExc(transaksi);
            objValue.put("RETURN_MESSAGE", FRMMessage.getMessage(FRMMessage.MSG_SAVED));
        } catch (DBException ex) {
            printErrorMessage(ex.getMessage());
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", ex.toString());
            return objValue;
        }

        //save detail transaksi penambahan cash
        if (objValue.optString("message","").equals(FRMMessage.getMessage(FRMMessage.MSG_SAVED))) {
            Vector<JenisTransaksi> listTransaksi = PstJenisTransaksi.list(0, 0, ""
                    + "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + " = '" + JenisTransaksi.TIPE_ARUS_KAS_BERTAMBAH + "'"
                    + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_PROSEDUR] + " = '" + JenisTransaksi.TIPE_PROSEDUR_BY_TELLER + "'"
                    + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = '" + JenisTransaksi.TUJUAN_PROSEDUR_TABUNGAN + "'"
                    + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_TRANSAKSI] + " = '" + JenisTransaksi.TIPE_TRANSAKSI_NORMAL + "'"
                    + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " = '" + JenisTransaksi.STATUS_JENIS_TRANSAKSI_AKTIF + "'", "");
            if (!listTransaksi.isEmpty()) {
                try {
                    long idJenisTransaksi = listTransaksi.get(0).getOID();
                    JenisKredit jenis = PstJenisKredit.fetch(p.getTipeKreditId());
                    double jumlah = p.getJumlahPinjaman();
                    if (p.getWajibIdJenisSimpanan() > 0) {

                        double keWajib = (p.getWajibValueType() == p.WAJIB_VALUE_TYPE_NOMINAL) ? p.getWajibValue() : (jumlah * p.getWajibValue() / 100);
                        jumlah -= keWajib;

                        DetailTransaksi detailWajib = new DetailTransaksi();
                        detailWajib.setTransaksiId(oidTransaksi);
                        detailWajib.setJenisTransaksiId(idJenisTransaksi);
                        detailWajib.setDebet(0);
                        detailWajib.setKredit(keWajib);
                        detailWajib.setIdSimpanan(p.getWajibIdJenisSimpanan());
                        PstDetailTransaksi.insertExc(detailWajib);
                    }
                    if (idSimpanan != 0) {
                        DetailTransaksi detailPenambahanCash = new DetailTransaksi();
                        detailPenambahanCash.setTransaksiId(oidTransaksi);
                        detailPenambahanCash.setJenisTransaksiId(idJenisTransaksi);
                        detailPenambahanCash.setDebet(0);
                        detailPenambahanCash.setKredit(jumlah);
                        detailPenambahanCash.setIdSimpanan(idSimpanan);
                        PstDetailTransaksi.insertExc(detailPenambahanCash);
                    }
                } catch (DBException ex) {
                    printErrorMessage(ex.getMessage());
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", ex.toString());
                    return objValue;
                }
            }
        }

        //save detail transaksi biaya asuransi
        if (objValue.optString("message","").equals(FRMMessage.getMessage(FRMMessage.MSG_SAVED))) {
            //1.cari oid jenis transaksi asuransi
            long oidJenisTransaksiAsuransi = 0;
            Vector<JenisTransaksi> listAsuransi = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_ASURANSI + "'", "");
            if (!listAsuransi.isEmpty()) {
                oidJenisTransaksiAsuransi = listAsuransi.get(0).getOID();
            }
            //2.save biaya asuransi
            Vector<Penjamin> listBiayaAsuransi = PstPenjamin.list(0, 0, "" + PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID] + " = '" + oid + "'", "");
            for (int i = 0; i < listBiayaAsuransi.size(); i++) {
                double nilai = listBiayaAsuransi.get(i).getProsentasePenjamin();
                double biaya = p.getJumlahPinjaman() * (nilai / 100);
                DetailTransaksi detailKredit = new DetailTransaksi();
                detailKredit.setTransaksiId(oidTransaksi);
                detailKredit.setJenisTransaksiId(oidJenisTransaksiAsuransi);
                detailKredit.setDebet(biaya);
                detailKredit.setKredit(0);
                detailKredit.setIdSimpanan(idSimpanan);
                try {
                    PstDetailTransaksi.insertExc(detailKredit);
                } catch (DBException ex) {
                    printErrorMessage(ex.getMessage());
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", ex.toString());
                    return objValue;
                }
            }
        }

        //save detail transaksi biaya umum
        if (objValue.optString("message","").equals(FRMMessage.getMessage(FRMMessage.MSG_SAVED))) {
            //Vector<BiayaTransaksi> listBiayaKredit = PstBiayaTransaksi.list(0, 0, "" + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + this.oid + "'", "");
            Vector<BiayaTransaksi> listBiayaKredit = SessKredit.getBiayaKredit(0, 0, ""
                    + "" + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oid + "'"
                    + " AND (jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + Transaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_UMUM + "'"
                    + " OR jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + Transaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_PERUSAHAAN + "')"
                    + "", "");
            for (int b = 0; b < listBiayaKredit.size(); b++) {
                long idJenisTransaksi = listBiayaKredit.get(b).getIdJenisTransaksi();
                double nilai = listBiayaKredit.get(b).getValueBiaya();
                int tipe = listBiayaKredit.get(b).getTipeBiaya();
                double biaya = 0;
                if (tipe == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                    biaya = p.getJumlahPinjaman() * (nilai / 100);
                } else if (tipe == BiayaTransaksi.TIPE_BIAYA_UANG) {
                    biaya = nilai;
                }
                DetailTransaksi detailKredit = new DetailTransaksi();
                detailKredit.setTransaksiId(oidTransaksi);
                detailKredit.setJenisTransaksiId(idJenisTransaksi);
                detailKredit.setDebet(biaya);
                detailKredit.setKredit(0);
                detailKredit.setIdSimpanan(idSimpanan);
                try {
                    PstDetailTransaksi.insertExc(detailKredit);
                } catch (DBException ex) {
                    printErrorMessage(ex.getMessage());
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", ex.toString());
                    return objValue;
                }
            }
        }

        //update data jadwal tambah id transaksi
        if (objValue.optInt("iErrCode",0) == 0) {
            Vector<JadwalAngsuran> listJadwalPokokBunga = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " <> '" + JadwalAngsuran.TIPE_ANGSURAN_DENDA + "'", "");
            for (int i = 0; i < listJadwalPokokBunga.size(); i++) {
                JadwalAngsuran ja = new JadwalAngsuran();
                long idJadwal = listJadwalPokokBunga.get(i).getOID();
                try {
                    ja = PstJadwalAngsuran.fetchExc(idJadwal);
                    ja.setTransaksiId(oidTransaksi);
                    PstJadwalAngsuran.updateExc(ja);
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", e.toString());
                    return objValue;
                }
            }
        }

        //ubah status kredit jadi cair (5)
        if (objValue.optInt("iErrCode",0) == 0) {
            p.setStatusPinjaman(Pinjaman.STATUS_DOC_CAIR);
            boolean result = false;
            try {
                String url = posApiUrl + "/rest/billmain/update/" + p.getBillMainId() + "/" + PstBillMain.PETUGAS_DELIVERY_STATUS_ON_PRODUCTION;
                JSONObject res = WebServices.getAPI("", url);
                result = res.getBoolean("SUCCES");
            } catch (Exception e) {
            }
            try {
                if (result) {
                    PstPinjaman.updateExc(p);
                }
            } catch (DBException ex) {
                printErrorMessage(ex.getMessage());
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", ex.toString());
            }
        }
        
        return objValue;
        
    }

    public JSONObject createPenarikanForPencairanKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        try {
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
            Pinjaman p = PstPinjaman.fetchExc(oid);

            //CARI TRANSAKSI PENCAIRAN
            String where = PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN + "'"
                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'";
            Vector<Transaksi> listPencairan = PstTransaksi.list(0, 0, where, null);

            if (listPencairan.isEmpty()) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Transaksi pencairan untuk nomor kredit " + p.getNoKredit() + " tidak ditemukan");
                return objValue;
            }
            if (listPencairan.size() > 1) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Terdapat lebih dari 1 transaksi pencairan untuk nomor kredit " + p.getNoKredit());
                return objValue;
            }

            //HITUNG NILAI PENCAIRAN
            //cari id simpanan alokasi pencairan
            long idSimpananPencairan = 0;
            Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 1, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + "=" + p.getAssignTabunganId() + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + "=" + p.getIdJenisSimpanan(), null);
            if (listSimpanan.isEmpty()) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Pelunasan gagal. OID simpanan untuk pencairan tidak ditemukan!");
                return objValue;
            } else {
                idSimpananPencairan = listSimpanan.get(0).getOID();
            }

            double nilaiPencairan = 0;
            String wherePencairan = PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = '" + listPencairan.get(0).getOID() + "'"
                    + " AND " + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN] + " = '" + idSimpananPencairan + "'";
            Vector<DetailTransaksi> listDetail = PstDetailTransaksi.list(0, 0, wherePencairan, null);
            for (DetailTransaksi dt : listDetail) {
                nilaiPencairan += dt.getKredit() - dt.getDebet();
            }

            //CEK APAKAH TRANSAKSI PENARIKAN OTOMATIS SUDAH ADA
            String wherePenarikan = PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = " + Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN
                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_PARENT_ID] + " = '" + listPencairan.get(0).getOID() + "'";
            Vector<Transaksi> listPenarikanPencairan = PstTransaksi.list(0, 0, wherePenarikan, null);
            if (listPenarikanPencairan.size() > 0) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Penarikan untuk pencairan kredit " + p.getNoKredit() + " sudah ada. Nomor transaksi penarikan : " + listPenarikanPencairan.get(0).getKodeBuktiTransaksi());
                return objValue;
            }

            if (listPenarikanPencairan.isEmpty()) {
                Transaksi transaksiPencairan = listPencairan.get(0);

                Date tglTransaksi = new Date();
                String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_TABUNGAN_PENARIKAN, Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN, tglTransaksi);

                Transaksi t = new Transaksi();
                t.setTanggalTransaksi(tglTransaksi);
                t.setIdAnggota(p.getAnggotaId());
                t.setTellerShiftId(oidTellerShift);
                t.setKeterangan("Penarikan dana pencairan kredit. Nomor kredit : " + p.getNoKredit() + ". Nomor transaksi pencairan : " + transaksiPencairan.getKodeBuktiTransaksi());
                t.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                t.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERKURANG);
                t.setUsecaseType(Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN);
                t.setKodeBuktiTransaksi(nomorTransaksi);
                t.setTransaksiParentId(transaksiPencairan.getOID());
                t.setPinjamanId(p.getOID());
                PstTransaksi.insertExc(t);

                //SIMPAN DETAIL
                if (t.getOID() != 0) {
                    long idJenisTransaksiPenarikanCash = PstJenisTransaksi.getIdJenisTransaksiByNamaJenisTransaksi("Penarikan Cash");
                    if (idJenisTransaksiPenarikanCash == 0) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Pelunasan gagal. OID jenis transaksi penarikan cash tidak ditemukan!");
                        return objValue;
                    }
                    DetailTransaksi d = new DetailTransaksi();
                    d.setTransaksiId(t.getOID());
                    d.setJenisTransaksiId(idJenisTransaksiPenarikanCash);
                    d.setDebet(nilaiPencairan);
                    d.setIdSimpanan(idSimpananPencairan);
                    PstDetailTransaksi.insertExc(d);

                    long idPaymentSystemCash = 0;
                    Vector<PaymentSystem> listPS = PstPaymentSystem.list(0, 1, PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_TYPE] + " = " + AngsuranPayment.TIPE_PAYMENT_CASH, null);
                    if (listPS.isEmpty()) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "ID payment system cash tidak ditemukan!");
                        return objValue;
                    } else {
                        idPaymentSystemCash = listPS.get(0).getOID();
                    }
                    TransaksiPayment tp = new TransaksiPayment();
                    tp.setPaymentSystemId(idPaymentSystemCash);
                    tp.setJumlah(nilaiPencairan);
                    tp.setTransaksiId(t.getOID());
                    PstTransaksiPayment.insertExc(tp);
                }
                objValue.put("RETURN_MESSAGE", "Penarikan dana pencairan berhasil.");
            }

        } catch (Exception e) {
            printErrorMessage(e.getMessage());
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.getMessage());
        }
        return objValue;
    }

    public void createPrintOutPencairan(HttpServletRequest request, Pinjaman p) {
        Anggota a = new Anggota();
        try {
            a = PstAnggota.fetchExc(p.getAnggotaId());
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
//            objValue.put("RETURN_MESSAGE", e.getMessage());
//            objValue.put("RETURN_ERROR_CODE", 1);
            return;
        }
        double totalBiaya = 0;
        double totalAsuransi = 0;
        String htmlReturn = ""
                + "                <div style='width: 50%; float: left;'>"
                + "                    <strong style='width: 100%; display: inline-block; font-size: 20px;' id='compName'></strong>"
                + "                    <span style='width: 100%; display: inline-block;' id='compAddr'></span>"
                + "                    <span style='width: 100%; display: inline-block;' id='compPhone'></span>"
                + "                </div>"
                + "                <div style='width: 50%; float: right; text-align: right'>"
                + "                    <span style='width: 100%; display: inline-block; font-weight: 400; font-size: 20px;'>TRANSAKSI PENCAIRAN KREDIT</span>"
                + "                    <span style='width: 100%; display: inline-block; font-size: 12px;'>Tanggal &nbsp; : &nbsp; " + Formater.formatDate(new Date(), "dd MMMM yyyy") + "</span>"
                + "                    <span style='width: 100%; display: inline-block; font-size: 12px;'>Admin &nbsp; : &nbsp; <font id='userFullName'></font></span>"
                + "                </div>"
                + "                <div class='clearfix'></div>"
                + "                <hr class='' style='border-color: gray'>"
                + "                <div>"
                + "                    <span style='width: 120px; float: left;'>Nomor Kredit</span>"
                + "                    <span style='width: calc(100% - 120px); float: right;'>:&nbsp;&nbsp; " + p.getNoKredit() + "</span>"
                + "                </div>"
                + "                <div>"
                + "                    <span style='width: 120px; float: left;'>Nama <font id='namaNasabah'></font></span>"
                + "                    <span style='width: calc(100% - 120px); float: right;'>:&nbsp;&nbsp; " + a.getName() + "</span>"
                + "                </div>"
                + "                <div>"
                + "                    <span style='width: 120px; float: left;'>Jumlah Pinjaman</span>"
                + "                    <span style='width: calc(100% - 120px); float: right;'>:&nbsp;&nbsp; Rp <a style='color: black' class='money'>" + p.getJumlahPinjaman() + "</a></span>"
                + "                </div>"
                + "                <div>"
                + "                    <span style='width: 120px; float: left;'>Suku Bunga</span>"
                + "                    <span style='width: calc(100% - 120px); float: right;'>:&nbsp;&nbsp; <a style='color: black' class='money'>" + p.getSukuBunga() + "</a> % / Tahun</span>"
                + "                </div>"
                + "                <div>"
                + "                    <span style='width: 120px; float: left;'>Jangka Waktu</span>"
                + "                    <span style='width: calc(100% - 120px); float: right;'>:&nbsp;&nbsp; " + p.getJangkaWaktu() + " Bulan</span>"
                + "                </div>"
                + "                <div class='clearfix'></div>"
                + "                <br>"
                + "                 <div>";
        Vector listJenisBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + p.getOID() + "'"
                + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = '" + JenisTransaksi.TUJUAN_PROSEDUR_KREDIT + "'"
                + " GROUP BY jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC], "");
        for (int i = 0; i < listJenisBiaya.size(); i++) {
            BiayaTransaksi bt = (BiayaTransaksi) listJenisBiaya.get(i);
            int jumlahTransaksi = JenisTransaksi.TIPE_DOC_JUMLAH_DATA[bt.getTipeDoc()];
            if (jumlahTransaksi == JenisTransaksi.TIPE_DOC_JUMLAH_MULTIPLE) {
                htmlReturn += ""
                        + " <div>"
                        + "     <label class='control-label'>" + JenisTransaksi.TIPE_DOC_TITLE[bt.getTipeDoc()] + " &nbsp; : &nbsp;</label>"
                        + " </div>"
                        + " <table>";
                Vector listDetailBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                        + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + p.getOID() + "'"
                        + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + bt.getTipeDoc() + "'", "");
                for (int j = 0; j < listDetailBiaya.size(); j++) {
                    BiayaTransaksi biaya = (BiayaTransaksi) listDetailBiaya.get(j);
                    JenisTransaksi transaksi = new JenisTransaksi();
                    try {
                        transaksi = PstJenisTransaksi.fetchExc(biaya.getIdJenisTransaksi());
                    } catch (Exception exc) {
                        printErrorMessage(exc.getMessage());
                    }
                    double nilai = 0;
                    String tampil = "";
                    if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                        tampil = "Rp <span class='money'>" + biaya.getValueBiaya() + "</span>";
                        totalBiaya += biaya.getValueBiaya();
                    } else if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                        nilai = (p.getJumlahPinjaman() * (biaya.getValueBiaya() / 100));
                        totalBiaya += nilai;
                        tampil = "Rp <span class='money'>" + nilai + "</span>"
                                + "&nbsp; (<span class='money'>" + biaya.getValueBiaya() + "</span> %)";
                    }
                    htmlReturn += ""
                            + " <tr>"
                            + "     <td>" + transaksi.getJenisTransaksi() + "</td>"
                            + "     <td>&nbsp; : &nbsp;</td>"
                            + "     <td>" + tampil + "</td>"
                            + " </tr>"
                            + "";
                }
                htmlReturn += "</table>";
            }
        }
        htmlReturn += ""
                + " </div>"
                + " <br>"
                //biaya asuransi
                + " <div>"
                + "     <label class='control-label'>" + JenisTransaksi.TIPE_DOC_TITLE[JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_ASURANSI] + " &nbsp; : &nbsp;</label>"
                + " </div>"
                + " <table>";
        Vector listPenjamin = PstPenjamin.list(0, 0, "" + PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'", "");
        for (int i = 0; i < listPenjamin.size(); i++) {
            Penjamin penjamin = (Penjamin) listPenjamin.get(i);
            AnggotaBadanUsaha abu = new AnggotaBadanUsaha();
            try {
                abu = PstAnggotaBadanUsaha.fetchExc(penjamin.getContactId());
            } catch (Exception exc) {
                printErrorMessage(exc.getMessage());
            }
            double nilai = (p.getJumlahPinjaman() * (penjamin.getProsentasePenjamin() / 100));
            totalAsuransi += nilai;
            htmlReturn += ""
                    + " <tr>"
                    + "     <td>" + (i + 1) + ".</td>"
                    + "     <td>" + abu.getName() + "</td>"
                    + "     <td>&nbsp; : &nbsp;</td>"
                    + "     <td>Rp <span class='money'>" + nilai + "</span> &nbsp; (<span class='money'>" + penjamin.getProsentasePenjamin() + "</span> %)</td>"
                    + " </tr>"
                    + "";
        }
        if (listPenjamin.isEmpty()) {
            htmlReturn += ""
                    + " <tr><td>Tidak ada penjamin.</td></tr>"
                    + "";
        }
        htmlReturn += "</table>"
                + "<hr style='border-color: grey'>";
        double total = Math.ceil(p.getJumlahPinjaman() - (totalBiaya + totalAsuransi));
        long longTotal = (long) (total);
        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
        String con = convert.getText() + " rupiah.";
        String output = con.substring(0, 1).toUpperCase() + con.substring(1);

        htmlReturn += ""
                + " <div>"
                + "     <label class='control-label'>Perhitungan &nbsp; : &nbsp;</label>"
                + " </div>"
                + " <table>"
                + "     <tr>"
                + "         <td>Jumlah pinjaman &nbsp;-&nbsp; Total biaya</td>"
                + "         <td>&nbsp; = &nbsp;</td>"
                + "         <td>"
                + "             <span class='money'>" + p.getJumlahPinjaman() + "</span>"
                + "             <span>&nbsp;-&nbsp;</span>"
                + "             <span class='money'>" + (totalBiaya + totalAsuransi) + "</span>"
                + "         </td>"
                + "     </tr>"
                + "     <tr>"
                + "         <td>Total uang diterima</td>"
                + "         <td>&nbsp; : &nbsp;</td>"
                + "         <td>Rp <span class='money'>" + (p.getJumlahPinjaman() - (totalBiaya + totalAsuransi)) + "</span></td>"
                + "     </tr>"
                + "     <tr>"
                + "         <td>Terbilang (Nilai dibulatkan)<t/td>"
                + "         <td>&nbsp; : &nbsp;</td>"
                + "         <td>" + output + "</td>"
                + "     </tr>"
                + " </table>"
                + "";
    }

    //penilaian kredit----------------------------------------------------------    
    public JSONObject savePenilaianKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        try {
            
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            String keteranganPenilaian = FRMQueryString.requestString(request, "FRM_FIELD_HISTORY");
            long oidAo = FRMQueryString.requestLong(request, FrmPinjaman.fieldNames[FrmPinjaman.FRM_ACCOUNT_OFFICER_ID]);
            long oidKolektor = FRMQueryString.requestLong(request, FrmPinjaman.fieldNames[FrmPinjaman.FRM_COLLECTOR_ID]);
            int lokasiPengihan = FRMQueryString.requestInt(request, "FRM_LOKASI_PENAGIHAN");
            int statusPinjaman = FRMQueryString.requestInt(request, "FRM_FIELD_ACTION");
           
            
            Pinjaman prevPinjaman = PstPinjaman.fetchExc(oid);
            Pinjaman newPinjaman = PstPinjaman.fetchExc(oid);
            newPinjaman.setKeterangan(keteranganPenilaian);
            newPinjaman.setAccountOfficerId(oidAo);
            newPinjaman.setCollectorId(oidKolektor);
            newPinjaman.setLokasiPenagihan(lokasiPengihan);

            int useRaditya = Integer.parseInt(PstSystemProperty.getValueByName("USE_FOR_RADITYA"));
            String tempTxt = "";
            if (useRaditya == 1) {
                if (statusPinjaman == Pinjaman.STATUS_DOC_APPROVED) {
                    Vector<AnalisaKreditMain> listAnalisa = PstAnalisaKreditMain.list(0, 0, PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PINJAMANID] + "=" + newPinjaman.getOID(), "");
                    if (!listAnalisa.isEmpty()) {
                        AnalisaKreditMain akm = listAnalisa.get(0);
                        if (akm.getAnalisaStatus() == PstAnalisaKreditMain.ANALISA_STATUS_CLOSED) {
                            newPinjaman.setStatusPinjaman(statusPinjaman);
                        } else {
                            tempTxt = "Status Kredit tidak dapat di Accept.\n"
                                    + "Form Analisa pada kredit ini masih dalam status Draft.\n"
                                    + "Harap update status form analisa pada kredit ini\n";
                        }
                    } else {
                        tempTxt = "Status Kredit tidak dapat di Accept.\n"
                                + "Form Analisa tidak ditemukan pada kredit ini.\n";
                    }
                } else {
                    newPinjaman.setStatusPinjaman(statusPinjaman);
                }
            } else {
                newPinjaman.setStatusPinjaman(statusPinjaman);
            }

            PstPinjaman.updateExc(newPinjaman);
            objValue.put("RETURN_MESSAGE", "Simpan berhasil.\n" + tempTxt);

            if (prevPinjaman.getStatusPinjaman() != newPinjaman.getStatusPinjaman()) {
                if (statusPinjaman == Pinjaman.STATUS_DOC_APPROVED) {
                    objValue.put("RETURN_MESSAGE", "Penilaian kredit selesai. \nSelanjutnya akan diteruskan ke tahap pencairan");
                } else {
                    objValue.put("RETURN_MESSAGE", "Status kredit diubah menjadi \"" + Pinjaman.STATUS_DOC_TITLE[statusPinjaman] + "\"");
                }
            }
            if (prevPinjaman.getAccountOfficerId() != newPinjaman.getAccountOfficerId()) {
                Employee tempAoOld = new Employee();
                Employee tempAoNew = new Employee();
                String whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + prevPinjaman.getAccountOfficerId();
                Vector listTemp = PstEmployee.getListFromApi(0, 0, whereClause, "");
                if (!listTemp.isEmpty()) {
                    tempAoOld = (Employee) listTemp.get(0);
                }
                whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + newPinjaman.getAccountOfficerId();
                listTemp = PstEmployee.getListFromApi(0, 0, whereClause, "");
                if (!listTemp.isEmpty()) {
                    tempAoOld = (Employee) listTemp.get(0);
                }
                String msg = "Analyst bertugas diubah dari " + tempAoOld.getFullName() + " menjadi " + tempAoNew.getFullName();
                if (objValue.optString("message","").equals("")) {
                    objValue.put("RETURN_MESSAGE", msg);
                } else {
                    objValue.put("RETURN_MESSAGE", objValue.optString("message","")+"\n" + msg);
                }
            }
            if (prevPinjaman.getCollectorId() != newPinjaman.getCollectorId()) {
                Employee tempKolOld = new Employee();
                Employee tempKolNew = new Employee();
                String whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + prevPinjaman.getCollectorId();
                Vector listTemp = PstEmployee.getListFromApi(0, 0, whereClause, "");
                if (!listTemp.isEmpty()) {
                    tempKolOld = (Employee) listTemp.get(0);
                }
                whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + newPinjaman.getCollectorId();
                listTemp = PstEmployee.getListFromApi(0, 0, whereClause, "");
                if (!listTemp.isEmpty()) {
                    tempKolNew = (Employee) listTemp.get(0);
                }
                String msg = "Kolektor bertugas diubah dari " + tempKolOld.getFullName() + " menjadi " + tempKolNew.getFullName();
                if (objValue.optString("message","").equals("")) {
                    objValue.put("RETURN_MESSAGE", msg);
                } else {
                    objValue.put("RETURN_MESSAGE", objValue.optString("message","")+"\n" + msg);
                }

            }
            objValue.put("history", objValue.optString("history","")+newPinjaman.getLogDetail(prevPinjaman, newPinjaman));
            //history += "Keterangan penilaian : " + keteranganPenilaian;
        } catch (Exception exc) {
            printErrorMessage(exc.getMessage());
        }
        return objValue;
    }

    public synchronized void saveHistoryKredit(HttpServletRequest request, String action, JSONObject objValue) {
        SessHistory sessHistory = new SessHistory();
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        long userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
        String userName = FRMQueryString.requestString(request, "SEND_USER_NAME");
        Pinjaman p = new Pinjaman();
        try {
            p = PstPinjaman.fetchExc(oid);
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        if (!objValue.optString("history","").equals("")) {
            sessHistory.saveHistory(userId, userName, action, oid, p.getNoKredit(), "doctype", "Aiso/Sedana", "sedana/transaksikredit/penilaian_kredit.jsp", objValue.optString("history",""));
        }
    }

    //pengajuan kredit----------------------------------------------------------
    public JSONObject cekValidasiDataKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        //cek tanggal
        
        String tglPengajuan = FRMQueryString.requestString(request, "FRM_TGL_PENGAJUAN");
        String tglRealisasi = FRMQueryString.requestString(request, "FRM_TGL_REALISASI");
        String tglJatuhTempo = FRMQueryString.requestString(request, "FRM_JATUH_TEMPO");
        Date pengajuan = Formater.formatDate(tglPengajuan, "yyyy-MM-dd");
        Date realisasi = Formater.formatDate(tglRealisasi, "yyyy-MM-dd");
        Date tempo = Formater.formatDate(tglJatuhTempo, "yyyy-MM-dd");
        String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");

        if (tglPengajuan == null || tglPengajuan.isEmpty() || pengajuan == null) {
            objValue.put("RETURN_ERROR_CODE", "1");
            objValue.put("message ", "Pastikan tanggal pengajuan diisi dengan benar.");
            return objValue;
        }
        if (tglRealisasi == null || tglRealisasi.isEmpty() || realisasi == null) {
            objValue.put("RETURN_ERROR_CODE", "1");
            objValue.put("message ", "Pastikan tanggal realisasi diisi dengan benar.");
            return objValue;
        }
        if (tglJatuhTempo == null || tglJatuhTempo.isEmpty() || tempo == null) {
            objValue.put("RETURN_ERROR_CODE", "1");
            objValue.put("message ", "Pastikan tanggal jatuh tempo diisi dengan benar.");
            return objValue;
        }
        if (realisasi.before(pengajuan)) {
            objValue.put("RETURN_ERROR_CODE", "1");
            objValue.put("message ", "Tanggal realisasi tidak boleh mundur dari tanggal pengajuan.");
            return objValue;
        }
        if (tempo.before(pengajuan)) {
            objValue.put("RETURN_ERROR_CODE", "1");
            objValue.put("message ", "Tanggal jatuh tempo tidak boleh mundur dari tanggal pengajuan.");
            return objValue;
        }

        //cek jenis kredit, jumlah pengajuan, jumlah suku bunga, jangka waktu
        if (typeOfCredit.equals("0")) {
            if (objValue.optInt("iErrCode", 0) == 0) {
                long idJenisKredit = FRMQueryString.requestLong(request, "FRM_TIPE_KREDIT_ID");
                try {
                    JenisKredit jk = PstTypeKredit.fetchExc(idJenisKredit);

                    //cek jumlah pengajuan
                    double jumlahPengajuan = FRMQueryString.requestDouble(request, "FRM_JUMLAH_PINJAMAN");
                    double minPengajuan = jk.getMinKredit();
                    double maxPengajuan = jk.getMaxKredit();
                    if (jumlahPengajuan < minPengajuan) {
                        objValue.put("RETURN_ERROR_CODE", "1");
                        objValue.put("message ", "Jumlah pengajuan kurang dari Rp " + String.format("%,.2f", minPengajuan));
                        return objValue;
                    }
                    if (jumlahPengajuan > maxPengajuan) {
                        objValue.put("RETURN_ERROR_CODE", "1");
                        objValue.put("message ", "Jumlah pengajuan lebih dari Rp " + String.format("%,.2f", maxPengajuan));
                        return objValue;
                    }

                    //cek jumlah suku bunga
                    double sukuBunga = FRMQueryString.requestDouble(request, "FRM_SUKU_BUNGA");
                    double minBunga = jk.getBungaMin();
                    double maxBunga = jk.getBungaMax();
                    if (sukuBunga < minBunga) {
                        objValue.put("RETURN_ERROR_CODE", "1");
                        objValue.put("message ", "Suku bunga kurang dari " + minBunga + " %");
                        return objValue;
                    }
                    if (sukuBunga > maxBunga) {
                        objValue.put("RETURN_ERROR_CODE", "1");
                        objValue.put("message ", "Suku bunga lebih dari " + maxBunga + " %");
                        return objValue;
                    }

                    //cek jangka waktu
                    double jangkaWaktu = FRMQueryString.requestFloat(request, "FRM_JANGKA_WAKTU");
                    int tipeJadwal = FRMQueryString.requestInt(request, FrmPinjaman.fieldNames[FrmPinjaman.FRM_TIPE_JADWAL]);
                    double minJangka = jk.getJangkaWaktuMin();
                    double maxJangka = jk.getJangkaWaktuMax();
                    if (tipeJadwal == Pinjaman.TIPE_JADWAL_BY_PERIOD) {
                        if (jangkaWaktu < minJangka) {
                            objValue.put("RETURN_ERROR_CODE", "1");
                            objValue.put("message ", "Jangka waktu kurang dari " + Formater.formatNumber(minJangka, "#"));
                            return objValue;
                        }
                        if (jangkaWaktu > maxJangka) {
                            objValue.put("RETURN_ERROR_CODE", "1");
                            objValue.put("message ", "Jangka waktu lebih dari " + Formater.formatNumber(maxJangka, "#"));
                            return objValue;
                        }
                    }

                } catch (Exception exc) {
                    objValue.put("RETURN_ERROR_CODE", "1");
                    objValue.put("message ", "Pastikan jenis kredit dipilih dengan benar.");
                    printErrorMessage(exc.getMessage());
                    return objValue;
                }
            }
        }

        //cek nasabah
        if (objValue.optInt("iErrCode", 0) == 0) {
            long idNasabah = FRMQueryString.requestLong(request, "FRM_ANGGOTA_ID");
            String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
            try {
                PstAnggota.fetchExc(idNasabah);
            } catch (Exception exc) {
                objValue.put("RETURN_ERROR_CODE", "1");
                objValue.put("message ", "Pastikan " + namaNasabah + " dipilih dengan benar.");
                printErrorMessage(exc.getMessage());
                return objValue;
            }
        }

        //cek sumber dana
        if (typeOfCredit.equals("0")) {
            if (objValue.optInt("iErrCode", 0) == 0) {
                long idSumberDana = FRMQueryString.requestLong(request, "sumber-dana");
                try {
                    PstSumberDana.fetchExc(idSumberDana);
                } catch (Exception exc) {
                    objValue.put("RETURN_ERROR_CODE", "1");
                    objValue.put("message ", "Pastikan sumber dana dipilih dengan benar.");
                    printErrorMessage(exc.getMessage());
                    return objValue;
                }
            }
        }

        //save kredit
        if (objValue.optInt("iErrCode", 0) == 0) {
            objValue = saveKredit(request, objValue);
        }
        
        return objValue;
    }

    //pengajuan kredit----------------------------------------------------------
    public synchronized JSONObject saveSimulasiPengajuan(HttpServletRequest request, JSONObject objValue) throws JSONException {
        BillMain bm = new BillMain();
        try {
            long userCashierId = FRMQueryString.requestLong(request, "FRM_FIELD_APP_USER_ID");
            long cashCashierId = FRMQueryString.requestLong(request, "FRM_FIELD_CASH_CASHIER_ID");
            long shiftCashierId = FRMQueryString.requestLong(request, "FRM_FIELD_SHIFT_ID");
            long locationId = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_ID");
            String billDate = Formater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss");
            bm.setCashCashierId(cashCashierId);
            bm.setShiftId(shiftCashierId);
            bm.setAppUserId(userCashierId);
            bm.setLocationId(locationId);
            bm.setBillDate(Formater.formatDate(billDate, "yyyy-MM-dd HH:mm:ss"));
            long oidRes = PstBillMain.insertExc(bm);
            objValue.put("RETURN_BILL_MAIN_ID", ""+oidRes);
        } catch (Exception e) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
        }
        return objValue;
    }

    public JSONObject saveKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        // simpan data kredit

        int iCommand = FRMQueryString.requestCommand(request);
        long oidPinjaman = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
        long idSumberDana = FRMQueryString.requestLong(request, "sumber-dana");
        
        CtrlPinjaman ctrlPinjaman = new CtrlPinjaman(request);
        int iErrCode = ctrlPinjaman.action(iCommand, oidPinjaman);
        Pinjaman pinjaman;
        pinjaman = ctrlPinjaman.getPinjaman();
        String message = ctrlPinjaman.getMessage();
        objValue.put("RETURN_DATA_OID_PINJAMAN", ""+pinjaman.getOID());
        objValue.put("RETURN_DATA_OID_ANGGOTA", ""+pinjaman.getAnggotaId());
        objValue.put("RETURN_MESSAGE", message);

        // simpan data sumber dana
        if (typeOfCredit.equals("0")) {
            PinjamanSumberDana sumberDana = new PinjamanSumberDana();
            if (message.equals(FRMMessage.getMessage(FRMMessage.MSG_SAVED))) {
                sumberDana.setPinjamanId(pinjaman.getOID());
                sumberDana.setSumberDanaId(idSumberDana);
                sumberDana.setJumlahDana(pinjaman.getJumlahPinjaman());
                try {
                    long newOid = PstPinjamanSumberDana.insertExc(sumberDana);
                } catch (Exception e) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", e.toString());
                    printErrorMessage(e.getMessage());
                }
            } else if (message.equals(FRMMessage.getMessage(FRMMessage.MSG_UPDATED))) {
                try {
                    Vector listSumberDana = PstPinjamanSumberDana.list(0, 0, "" + PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'"
                            + " AND " + PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_SUMBER_DANA_ID] + " = '" + idSumberDana + "'", "");
                    if (!listSumberDana.isEmpty()) {
                        PinjamanSumberDana dana = (PinjamanSumberDana) listSumberDana.get(0);
                        try {
                            sumberDana = PstPinjamanSumberDana.fetchExc(dana.getOID());
                        } catch (Exception exc) {
                            printErrorMessage(exc.getMessage());
                        }
                        sumberDana.setSumberDanaId(idSumberDana);
                        sumberDana.setJumlahDana(pinjaman.getJumlahPinjaman());
                        long newOid = PstPinjamanSumberDana.updateExc(sumberDana);
                    }
                } catch (Exception e) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", message);
                }
            } else {
                objValue.put("RETURN_ERROR_CODE", 1);
                return objValue;
            }
        }
        //        save SalesCode untuk pengajuan lewat simulasi
        String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        String salesCode = FRMQueryString.requestString(request, "FRM_FIELD_SALES_CODE");
        long salesOid = FRMQueryString.requestLong(request, "FRM_FIELD_APP_USER_SALES_ID");
        BillMain bm = new BillMain();
        Location loc = new Location();
        try {
            bm = PstBillMain.fetchExc(pinjaman.getBillMainId());
            loc = PstLocation.fetchFromApi(bm.getLocationId());
            bm.setTaxPercentage(loc.getTaxPersen());
            bm.setTaxInclude(loc.getTaxSvcDefault());
            bm.setCustomerId(pinjaman.getAnggotaId());
            bm.setAppUserSalesId(salesOid);
            bm.setSalesCode(salesCode);
            try {
            ContactList contactList = PstContactList.fetchExc(pinjaman.getAnggotaId());
            bm.setCustName(contactList.getPersonName());
            } catch (Exception exc){}
            long oidBillMain = PstBillMain.updateExc(bm);
            try {
                String url = posApiUrl + "/bill/billmain/updatecontact/" + bm.getOID()+ "/" + bm.getCustomerId();
                JSONObject res = WebServices.getAPI("", url);
            } catch (Exception e) {
            }
        } catch (Exception e) {
        }

        //buat bill
        if (iErrCode == 0) {
            if (pinjaman.getBillMainId() > 0) {
                Vector listDetail = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + pinjaman.getBillMainId(), "");
                Hashtable<Long, Boolean> h = new Hashtable<>();
                if (listDetail.size() > 0) {
                    for (int i = 0; i < listDetail.size(); i++) {
                        Billdetail billdetail = (Billdetail) listDetail.get(i);
                        h.put(billdetail.getOID(), false);
                    }
                }

                String[] oidMaterials = FRMQueryString.requestStringValues(request, "OID_MATERIAL");
                String[] qtys = FRMQueryString.requestStringValues(request, "MATERIAL_QTY");
                String[] costs = FRMQueryString.requestStringValues(request, "COST");
                String[] prices = FRMQueryString.requestStringValues(request, "MATERIAL_PRICE");
                String[] pricesTotal = FRMQueryString.requestStringValues(request, "MATERIAL_PRICE_TOTAL");

                if (oidMaterials != null) {
                    for (int i = 0; i < oidMaterials.length; i++) {
                        try {
                            String url = posApiUrl + "/material/material-credit/" + oidMaterials[i];
                            JSONObject jo = WebServices.getAPI("", url);
                            long oidMaterial = PstMaterial.syncExc(jo);
                            String whereBillDetail = PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + pinjaman.getBillMainId()
                                    + " AND " + PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_ID] + "=" + oidMaterial;
                            Vector listBillDetail = PstBillDetail.list(0, 0, whereBillDetail, "");
                            
                            double taxVal = 0;
                            double svcVal = 0;
                            double amount = 0;
                            double totalPrice = Double.valueOf(prices[i]);
                            double taxPct = 0;
                            double svcPct = 0;
                            int taxInc = 0;
                            try {
                                Location l = PstLocation.fetchExc(bm.getLocationId());
                                taxPct = l.getTaxPersen();
                                svcPct = l.getServicePersen();
                                taxInc = l.getTaxSvcDefault();
                            } catch (Exception e) {
                            }
                            
                            if (taxInc == PstBillMain.INC_CHANGEABLE || taxInc == PstBillMain.INC_NOT_CHANGEABLE) {
                                amount = totalPrice / ((taxPct + svcPct + 100) / 100);
                                svcVal = amount * (svcPct / 100);
                                taxVal = amount * (taxPct / 100);
                                totalPrice = amount;
                            }
                            
                            Billdetail billdetail = new Billdetail();
                            if (listBillDetail.size() > 0) {
                                billdetail = (Billdetail) listBillDetail.get(0);
                            }
                            
                            billdetail.setBillMainId(pinjaman.getBillMainId());
                            billdetail.setUnitId(jo.optLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID], 0));
                            billdetail.setMaterialId(oidMaterial);
                            billdetail.setQty(Double.valueOf(qtys[i]));
                            billdetail.setItemPrice(Double.valueOf(prices[i]));
                            billdetail.setCost(Double.valueOf(costs[i]));
                            billdetail.setTotalPrice(totalPrice);
                            billdetail.setTotalTax(taxVal);
                            billdetail.setTotalSvc(svcVal);
                            billdetail.setSku(jo.optString(PstMaterial.fieldNames[PstMaterial.FLD_SKU], ""));
                            billdetail.setItemName(jo.optString(PstMaterial.fieldNames[PstMaterial.FLD_NAME], ""));  
                            
                            long oidBillDetail = 0;
                            try {
                                if (listBillDetail.size() > 0) {
                                    oidBillDetail = PstBillDetail.updateExc(billdetail);
                                } else {
                                    oidBillDetail = PstBillDetail.insertExc(billdetail);
                                }
                                if(oidBillDetail == 0){
                                    objValue.put("RETURN_ERROR_CODE", 1);
                                    objValue.put("RETURN_MESSAGE", "Gagal menyimpan / update barang.");
                                    return objValue;
                                }
                            } catch (Exception e) {
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", "Masalah ditemukan. " + e.toString());
                                return objValue;
                            }

                            JSONObject jSONObject = PstBillDetail.fetchJSON(oidBillDetail);
                            String urlPost = posApiUrl + "/bill/billd/insert";
                            JSONObject objStatus = WebServices.postAPI(jSONObject.toString(), urlPost);
                            boolean status = objStatus.optBoolean("SUCCESS", false);
                            if (!status) {
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", "Gagal menambahkan barang ");
                            }
                            if (h.containsKey(oidBillDetail)) {
                                h.put(oidBillDetail, true);
                            }

                        } catch (Exception exc) {
                        }
                    }
                }

                Set<Long> keys = h.keySet();
                for (Long oid : keys) {
                    if (!h.get(oid)) {
                        try {
                            PstBillDetail.deleteExc(oid);
                            String urlDelete = posApiUrl + "/bill/billmain/delete/" + oid;
                            JSONObject objStatus = WebServices.postAPI("", urlDelete);
                            boolean status = objStatus.optBoolean("SUCCES", false);
                            if (!status) {
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", "Gagal menghapus barang ");
                            }
                        } catch (Exception exc) {
                        }
                    }
                }
            }
        }
        //buat jadwal
        if (iErrCode == 0) {
            //hapus jadwal awal (jika ada)
            Vector listJadwal = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'", "");
            for (int i = 0; i < listJadwal.size(); i++) {
                JadwalAngsuran ja = (JadwalAngsuran) listJadwal.get(i);
                try {
                    PstJadwalAngsuran.deleteExc(ja.getOID());
                } catch (DBException ex) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", ex.getMessage());
                    printErrorMessage(ex.getMessage());
                }
            }
            //buat jadwal baru
            if (typeOfCredit.equals("1")) {
                createJadwalAngsuran(request, pinjaman);
            } else {
                createScheduleOnly(request, pinjaman);
            }
        }
        objValue.put("RETURN_ERROR_CODE", iErrCode);
        return objValue;
    }

    public synchronized JSONObject saveKreditHapus(HttpServletRequest request, JSONObject objValue) throws JSONException{
        
        String tglHapus = FRMQueryString.requestString(request, "TGL_HAPUS");
        String catatanReturn = FRMQueryString.requestString(request, "CATATAN");
        long pinjamanId = FRMQueryString.requestLong(request, "PINJAMAN_ID");
        long hapusKreditId = FRMQueryString.requestLong(request, "HAPUS_KREDIT_ID");
        long billMainId = FRMQueryString.requestLong(request, "BILL_MAIN_ID");
        long userLocationId = FRMQueryString.requestLong(request, "USER_LOCATION_ID");
        String dokumenNumber = FRMQueryString.requestString(request, "DOKUMEN_NUMBER");
        int status = FRMQueryString.requestInt(request, "STATUS");
        double sisaPokok = FRMQueryString.requestDouble(request, "SISA_POKOK");
        double sisaBunga = FRMQueryString.requestDouble(request, "SISA_BUNGA");
        
        Pinjaman p = new Pinjaman();
        BillMain bm = new BillMain();
        HapusKredit rk = new HapusKredit();
        
        try {
            
            if (pinjamanId != 0) {
                p = PstPinjaman.fetchExc(pinjamanId);
            }
            if (p.getBillMainId() != 0) {
                bm = PstBillMain.fetchExc(p.getBillMainId());
            }
            
            long oid = 0;
            String nomorHapus = dokumenNumber.equals("") ? "HK-" + p.getNoKredit() : dokumenNumber;
            rk.setOID(hapusKreditId);
            rk.setCashBillMainId(billMainId);
            rk.setPinjamanId(pinjamanId);
            rk.setLocationTransaksi(bm.getLocationId());
            rk.setCatatan(catatanReturn);
            rk.setNomorHapus(nomorHapus);
            rk.setStatus(status);
            rk.setSisaPokok(sisaPokok);
            rk.setSisaBunga(sisaBunga);
            rk.setTanggalHapus(Formater.formatDate(tglHapus, "yyyy-MM-dd HH:mm:ss"));
            
            if (hapusKreditId == 0) {
                oid = PstHapusKredit.insertExc(rk);
            } else {
                oid = PstHapusKredit.updateExc(rk);
            }
            
            if (status == I_DocStatus.DOCUMENT_STATUS_CLOSED){
                p.setStatusPinjaman(Pinjaman.STATUS_DOC_DIHAPUS);
                PstPinjaman.updateExc(p);
            }
            
            try {
                
                objValue.put("RESULT_PINJAMAN_ID", String.valueOf(pinjamanId));
                objValue.put("RESULT_HAPUS_ID", String.valueOf(oid));
            } catch (Exception e) {
                printErrorMessage(e.toString());
            }
            
        } catch (Exception exc){
            System.out.println("");
        }
        
        
        return objValue;
    }
    
    public synchronized JSONObject saveKreditReturn(HttpServletRequest request, JSONObject objValue) throws JSONException{
        // simpan data kredit
        String tglReturn = FRMQueryString.requestString(request, "TGL_RETURN");
        String catatanReturn = FRMQueryString.requestString(request, "CATATAN");
        long pinjamanId = FRMQueryString.requestLong(request, "PINJAMAN_ID");
        long returnKreditId = FRMQueryString.requestLong(request, "RETURN_KREDIT_ID");
        long billMainId = FRMQueryString.requestLong(request, "BILL_MAIN_ID");
        long userLocationId = FRMQueryString.requestLong(request, "USER_LOCATION_ID");
        String dokumenNumber = FRMQueryString.requestString(request, "DOKUMEN_NUMBER");
        int status = FRMQueryString.requestInt(request, "STATUS");
        int jenisReturn = FRMQueryString.requestInt(request, "RETURN_KREDIT");
        long oidTransaksi = 0;
        
        Pinjaman p = new Pinjaman();
        BillMain bm = new BillMain();
        JSONObject dataSend = new JSONObject();
        ReturnKredit rk = new ReturnKredit();
        try {
            if (pinjamanId != 0) {
                p = PstPinjaman.fetchExc(pinjamanId);
            }
            if (p.getBillMainId() != 0) {
                bm = PstBillMain.fetchExc(p.getBillMainId());
            }
            
            String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]
                    + " IN (" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ", " + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ")";
            Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, whereClause, "");
            int banyakAngsuran = listJadwal.size();
            int banyakAngsuranDibayar = 0;
            for(JadwalAngsuran ja : listJadwal){
                Vector<Angsuran> listAngsuran = SessKredit.getJadwalSudahDibayar(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + ja.getOID(), "");
                double diBayar = 0;
                for(Angsuran angs : listAngsuran){
                    diBayar += angs.getJumlahAngsuran();
                }
                if(ja.getJumlahANgsuran() - diBayar == 0){
                    banyakAngsuranDibayar++;
                }
            }
            
            long oidRes = 0;
            String nomorReturn = dokumenNumber.equals("") ? "RK-" + p.getNoKredit() : dokumenNumber;
            rk.setOID(returnKreditId);
            rk.setCashBillMainId(billMainId);
            rk.setPinjamanId(pinjamanId);
            rk.setLocationTransaksi(bm.getLocationId());
            rk.setCatatan(catatanReturn);
            rk.setNomorReturn(nomorReturn);
            rk.setStatus(status);
            rk.setTanggalReturn(Formater.formatDate(tglReturn, "yyyy-MM-dd"));
            rk.setTransaksiId(oidTransaksi);
            rk.setJenisReturn(jenisReturn);
            
            if (returnKreditId == 0) {
                oidRes = PstReturnKredit.insertExc(rk);
            } else {
                oidRes = PstReturnKredit.updateExc(rk);
            }
            
            String[] oids = FRMQueryString.requestStringValues(request, "OID_DETAIL");
            if (oids.length > 0){
                for (int xx = 0; xx < oids.length; xx++){
                    try {
                        long oidDetail = Long.valueOf(oids[xx]);
                        long oid = FRMQueryString.requestLong(request, "OID_"+oidDetail);
                        long materialId = FRMQueryString.requestLong(request, "MATERIAL_ID_"+oidDetail);
                        double hpp = FRMQueryString.requestDouble(request, "HPP_"+oidDetail);
                        double persediaan = FRMQueryString.requestDouble(request, "PERSEDIAAN_"+oidDetail);
                        int qty = FRMQueryString.requestInt(request, "QTY_"+oidDetail);
                        String newSku = FRMQueryString.requestString(request, "NEW_SKU_"+oidDetail);
                        String newName = FRMQueryString.requestString(request, "NEW_NAME_"+oidDetail);
                        
                        Vector listItem = PstReturnKreditItem.list(0, 0, PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NEW_SKU]+"= '"+newSku+"' AND "
                                + PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_RETURN_KREDIT_ITEM_ID]+"!="+oid, "");
                        if (listItem.size()>0 && rk.getJenisReturn()==0){
                            objValue.put("RETURN_ERROR_CODE", 1);
                            objValue.put("RETURN_MESSAGE", "SKU sudah ada!");
                        } else {
                            ReturnKreditItem item = new ReturnKreditItem();
                            if (oid>0){
                                item = PstReturnKreditItem.fetchExc(oid);
                                item.setCashBillDetailId(oidDetail);
                                item.setReturnId(oidRes);
                                item.setMaterialId(materialId);
                                item.setNilaiHpp(hpp);
                                item.setNilaiPersediaan(persediaan);
                                item.setQty(qty);
                                item.setNewSku(newSku);
                                item.setNewMaterialName(newName);
                                PstReturnKreditItem.updateExc(item);
                            } else {
                                item.setCashBillDetailId(oidDetail);
                                item.setReturnId(oidRes);
                                item.setMaterialId(materialId);
                                item.setNilaiHpp(hpp);
                                item.setNilaiPersediaan(persediaan);
                                item.setQty(qty);
                                item.setNewSku(newSku);
                                item.setNewMaterialName(newName);
                                PstReturnKreditItem.insertExc(item);
                            }
                        }
                    } catch (Exception exc){}
                }
            }
        
            if (status == ReturnKredit.STATUS_RETURN_RETURN) {
                String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
                try {
//                    String url = this.posApiUrl + "/material-return/insert/" + p.getBillMainId() + "/" + p.getOID();
//                    JSONObject objStatus = WebServices.postAPI("", url);
                    dataSend.put("NO_CREDIT", ""+p.getNoKredit());
                    dataSend.put("BILL_MAIN_ID", ""+p.getBillMainId());
                    dataSend.put("USER_LOCATION_ID", ""+bm.getLocationId());
                    dataSend.put("REALISASI_KREDIT", ""+Formater.formatDate(p.getTglRealisasi(), "yyyy-MM-dd"));
                    dataSend.put("JENIS_RETURN_KREDIT", ""+jenisReturn);
                    dataSend.put("BANYAK_ANGSURAN", ""+banyakAngsuran);
                    dataSend.put("BANYAK_ANGSURAN_DIBAYAR", ""+banyakAngsuranDibayar);
                    Vector listKreditItem = PstReturnKreditItem.list(0, 0, PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_RETURN_ID]+"="+oidRes, "");
                    JSONArray arr = new JSONArray();
                    for (int x = 0; x< listKreditItem.size(); x++){
                        ReturnKreditItem retItem = (ReturnKreditItem) listKreditItem.get(x);
                        JSONObject obj = new JSONObject();
                        obj.put("BILL_DETAIL_ID", ""+retItem.getCashBillDetailId());
                        obj.put("MATERIAL_ID", ""+retItem.getMaterialId());
                        obj.put("NILAI_HPP", ""+retItem.getNilaiHpp());
                        obj.put("NILAI_PERSEDIAAN", ""+retItem.getNilaiPersediaan());
                        obj.put("QTY", ""+retItem.getQty());
                        obj.put("MATERIAL_NAME", ""+retItem.getNewMaterialName());
                        obj.put("SKU", ""+retItem.getNewSku());
                        arr.put(obj);
                    }
                    dataSend.put("MATERIAL_DATA", arr);
                    String url = posApiUrl + "/return-credit";
                    JSONObject objStatus = WebServices.postAPI(dataSend.toString(), url);
                    
                    boolean statusObj = objStatus.optBoolean("SUCCES", false);
                    if (statusObj){
                         if(oidRes != 0){
                            p.setStatusPinjaman(Pinjaman.STATUS_DOC_BATAL);
                            long oid = PstPinjaman.updateExc(p);
                        }
                        objValue.put("RETURN_MESSAGE", "pembuatan penerimaan berhasil");
                    } else {
                        rk.setStatus(0);
                        PstReturnKredit.updateExc(rk);
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", "Gagal membuat penerimaan, silahkan hubungi admin untuk bantuan");
                    }

//                    if (statusObj) {
//                        
//                        System.out.println("pembuatan penerimaan : SUCCESS URL : " + url);
//                    } else {
//                        System.out.println("pembuatan penerimaan : GAGAL!!! URL : " + url);
//                    }
                } catch (Exception e) {
                    System.out.println("Error : " + e.getMessage());
                    e.printStackTrace();
                }
                
//                double jumlahTunggakan = getTotalBiayaReturn(pinjamanId, JadwalAngsuran.TIPE_ANGSURAN_POKOK, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
//                Date tglTransaksi = new Date();
//                String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_KREDIT_PEMBAYARAN_BIAYA, Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT, tglTransaksi);
//                //save transaksi 
//                Transaksi transaksi = new Transaksi();
//                transaksi.setTanggalTransaksi(tglTransaksi);
//                transaksi.setKodeBuktiTransaksi(nomorTransaksi);
//                transaksi.setIdAnggota(p.getAnggotaId());
//                transaksi.setTellerShiftId(this.oidTellerShift);
//                transaksi.setKeterangan(Transaksi.USECASE_TYPE_TITLE.get(Transaksi.USECASE_TYPE_KREDIT_RETURN));
//                transaksi.setPinjamanId(p.getOID());
//                transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
//                transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERKURANG);
//                transaksi.setUsecaseType(Transaksi.USECASE_TYPE_KREDIT_RETURN);
//                transaksi.setTransaksiParentId(0);
//                oidTransaksi = PstTransaksi.insertExc(transaksi);
//
//                try {
//                    long idJenisTransaksi = Long.valueOf(this.oidReturnKredit);
//                    double biaya = jumlahTunggakan;
//                    //save detail transaksi
//                    DetailTransaksi detailKredit = new DetailTransaksi();
//                    detailKredit.setTransaksiId(oidTransaksi);
//                    detailKredit.setJenisTransaksiId(idJenisTransaksi);
//                    detailKredit.setDebet(biaya);
//                    detailKredit.setKredit(0);
//                    long oidDetailTransaksi = PstDetailTransaksi.insertExc(detailKredit);
//
//                } catch (NumberFormatException | DBException e) {
//                    printErrorMessage(e.getMessage());
//                }

                // Membuat Penerimaan Untuk Prochain 
            }
            
            try {
                
                objValue.put("RESULT_PINJAMAN_ID", String.valueOf(pinjamanId));
                objValue.put("RESULT_RETURN_ID", String.valueOf(oidRes));
            } catch (Exception e) {
                printErrorMessage(e.toString());
            }
            
        } catch (Exception e) {
            printErrorMessage(e.toString());
        }
        
        return objValue;
    }

    public synchronized JSONObject saveKreditExchange(HttpServletRequest request, JSONObject objValue) throws JSONException{
        // simpan data kredit

        int iCommand = FRMQueryString.requestCommand(request);
        long oidP = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        
        CtrlPinjaman ctrlPinjaman = new CtrlPinjaman(request);
        int iErrCode = ctrlPinjaman.action(iCommand, oidP);
        Pinjaman pinjaman;
        pinjaman = ctrlPinjaman.getPinjaman();
//        this.oidPinjaman = pinjaman.getOID();
        objValue.put("RETURN_DATA_OID_ANGGOTA", pinjaman.getAnggotaId());
        objValue.put("RETURN_ERROR_CODE", iErrCode);
        objValue.put("RETURN_ERROR_CODE", ctrlPinjaman.getMessage());

        //        save SalesCode untuk pengajuan lewat simulasi
        String salesCode = FRMQueryString.requestString(request, "FRM_FIELD_SALES_CODE");
        BillMain bm = new BillMain();
        try {
            bm = PstBillMain.fetchExc(pinjaman.getBillMainId());
            bm.setSalesCode(salesCode);
            long oidBillMain = PstBillMain.updateExc(bm);
        } catch (Exception e) {
        }

        //buat bill
        String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        if (iErrCode == 0) {
            if (pinjaman.getBillMainId() > 0) {
                Vector listDetail = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + pinjaman.getBillMainId(), "");
                Hashtable<Long, Boolean> h = new Hashtable<>();
                if (listDetail.size() > 0) {
                    for (int i = 0; i < listDetail.size(); i++) {
                        Billdetail billdetail = (Billdetail) listDetail.get(i);
                        h.put(billdetail.getOID(), false);
                    }
                }

                String[] oidMaterials = FRMQueryString.requestStringValues(request, "OID_MATERIAL");
                String[] qtys = FRMQueryString.requestStringValues(request, "MATERIAL_QTY");
                String[] costs = FRMQueryString.requestStringValues(request, "COST");
                String[] prices = FRMQueryString.requestStringValues(request, "MATERIAL_PRICE");
                String[] pricesTotal = FRMQueryString.requestStringValues(request, "MATERIAL_PRICE_TOTAL");

                if (oidMaterials != null) {
                    for (int i = 0; i < oidMaterials.length; i++) {
                        try {
                            String url = posApiUrl + "/material/material-credit/" + oidMaterials[i];
                            JSONObject jo = WebServices.getAPI("", url);
                            long oidMaterial = PstMaterial.syncExc(jo);
                            String whereBillDetail = PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + pinjaman.getBillMainId()
                                    + " AND " + PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_ID] + "=" + oidMaterial;
                            Vector listBillDetail = PstBillDetail.list(0, 0, whereBillDetail, "");
                            long oidBillDetail = 0;
                            if (listBillDetail.size() > 0) {
                                Billdetail billdetail = (Billdetail) listBillDetail.get(0);
                                billdetail.setBillMainId(pinjaman.getBillMainId());
                                billdetail.setUnitId(jo.optLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID], 0));
                                billdetail.setMaterialId(oidMaterial);
                                billdetail.setQty(Double.valueOf(qtys[i]));
                                billdetail.setItemPrice(Double.valueOf(prices[i]));
                                billdetail.setCost(Double.valueOf(costs[i]));
                                billdetail.setTotalPrice(billdetail.getQty() * Double.valueOf(pricesTotal[i]));
                                billdetail.setSku(jo.optString(PstMaterial.fieldNames[PstMaterial.FLD_SKU], ""));
                                billdetail.setItemName(jo.optString(PstMaterial.fieldNames[PstMaterial.FLD_NAME], ""));
                                oidBillDetail = PstBillDetail.updateExc(billdetail);
                            } else {
                                Billdetail billdetail = new Billdetail();
                                billdetail.setBillMainId(pinjaman.getBillMainId());
                                billdetail.setUnitId(jo.optLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID], 0));
                                billdetail.setMaterialId(oidMaterial);
                                billdetail.setQty(Double.valueOf(qtys[i]));
                                billdetail.setItemPrice(Double.valueOf(prices[i]));
                                billdetail.setCost(Double.valueOf(costs[i]));
                                billdetail.setTotalPrice(billdetail.getQty() * Double.valueOf(pricesTotal[i]));
                                billdetail.setSku(jo.optString(PstMaterial.fieldNames[PstMaterial.FLD_SKU], ""));
                                billdetail.setItemName(jo.optString(PstMaterial.fieldNames[PstMaterial.FLD_NAME], ""));
                                oidBillDetail = PstBillDetail.insertExc(billdetail);
                            }

                            JSONObject jSONObject = PstBillDetail.fetchJSON(oidBillDetail);
                            String urlPost = posApiUrl + "/bill/billd/insert";
                            JSONObject objStatus = WebServices.postAPI(jSONObject.toString(), urlPost);
                            boolean status = objStatus.optBoolean("SUCCESS", false);
                            if (!status) {
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", "Gagal menambahkan barang ");
                            }
                            if (h.containsKey(oidBillDetail)) {
                                h.put(oidBillDetail, true);
                            }

                        } catch (Exception exc) {
                        }
                    }
                }

                Set<Long> keys = h.keySet();
                for (Long oid : keys) {
                    if (!h.get(oid)) {
                        try {
                            PstBillDetail.deleteExc(oid);
                            String urlDelete = posApiUrl + "/bill/billmain/delete/" + oid;
                            JSONObject objStatus = WebServices.postAPI("", urlDelete);
                            boolean status = objStatus.optBoolean("SUCCES", false);
                            if (!status) {
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", "Gagal menghapus barang");
                            }
                        } catch (Exception exc) {
                        }
                    }
                }
            }
        }
        //ubah status kredit jadi cair (5)
        if (iErrCode == 0) {
            pinjaman.setStatusPinjaman(Pinjaman.STATUS_DOC_CAIR);
            boolean result = false;
            try {
                String url = posApiUrl + "/bill/billmain/update/" + pinjaman.getBillMainId() + "/" + PstBillMain.PETUGAS_DELIVERY_STATUS_ON_PRODUCTION;
                JSONObject res = WebServices.getAPI("", url);
                result = res.getBoolean("SUCCES");
            } catch (Exception e) {
            }
            try {
                if (result) {
                    PstPinjaman.updateExc(pinjaman);
                    try {
                        BillMain billMain = PstBillMain.fetchExc(pinjaman.getBillMainId());
                        billMain.setStatus(PstBillMain.PETUGAS_DELIVERY_STATUS_ON_PRODUCTION);
                        PstBillMain.updateExc(billMain);
                    } catch (Exception exc){}
                }
            } catch (DBException ex) {
                printErrorMessage(ex.getMessage());
                objValue.put("RETURN_ERROR_CODE", ex.toString());
                objValue.put("RETURN_MESSAGE", 1);
            }
        }
        //this.oidPinjaman = pinjaman.getBillMainId();
        //buat jadwal
        if (iErrCode == 0) {
            //hapus jadwal awal (jika ada)
            Vector listJadwal = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'", "");
            for (int i = 0; i < listJadwal.size(); i++) {
                JadwalAngsuran ja = (JadwalAngsuran) listJadwal.get(i);
                try {
                    PstJadwalAngsuran.deleteExc(ja.getOID());
                } catch (DBException ex) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", ex.getMessage());
                    printErrorMessage(ex.getMessage());
                }
            }
            //buat jadwal baru
            String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
            if (typeOfCredit.equals("1")) {
                createJadwalAngsuran(request, pinjaman);
            } else {
                createScheduleOnly(request, pinjaman);
            }
        }
        return objValue;
    }

    public synchronized void createJadwalAngsuran(HttpServletRequest request, Pinjaman p) {
        try {
            Calendar cal = Calendar.getInstance();
            cal.setTime(p.getTglRealisasi());
            JangkaWaktu jangkaWaktu = PstJangkaWaktu.fetchExc(p.getJangkaWaktuId());
            double angsuranPokok = FRMQueryString.requestDouble(request, "TOTAL_POKOK");
            double angsuranBunga = FRMQueryString.requestDouble(request, "TOTAL_BUNGA");
            double angsuranSeharusnya = angsuranPokok / jangkaWaktu.getJangkaWaktu();
            double bungaSeharusnya = angsuranBunga / jangkaWaktu.getJangkaWaktu();
            double jumlahDp = p.getDownPayment();
            double lebih = 0;
            double bungaLebih = 0;
            SessAutoCode s = new SessAutoCode();
            s.setSysProp("CODE_KWITANSI");
            s.setDbFieldToCheck(PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_NO_KWITANSI]);
            s.setDb(PstJadwalAngsuran.TBL_JADWALANGSURAN);
            String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " NOT IN (" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ")";
            s.setWhereClause(whereClause);
            boolean isDp = jumlahDp != 0;
            boolean dpShown = false;
            int dataSize = jangkaWaktu.getJangkaWaktu();
            int bound = 1;
            if (isDp) {
                dataSize += 1;
                bound += 1;
            }
            for (int i = 0; i < dataSize; i++) {

                double angsuran = 0;
                double bunga = 0;
                if (isDp && !dpShown) {
                    angsuran = jumlahDp;
                } else {
                    angsuran = angsuranSeharusnya;
                    bunga = bungaSeharusnya;
                    if (i == (dataSize - 1)) {
//			angsuran = convertInteger(-3, angsuranSeharusnya - lebih);
//			bunga = convertInteger(-3, bungaSeharusnya - bungaLebih);
                        angsuran = angsuranSeharusnya - lebih;
                        bunga = bungaSeharusnya - bungaLebih;
                    } else {
                        angsuran = convertInteger(-3, angsuran);
                        bunga = convertInteger(-3, bunga);
                        lebih += angsuran - angsuranSeharusnya;
                        bungaLebih += bunga - bungaSeharusnya;
                    }
                    System.out.println("==============================================================================");
                    System.out.println("Angsuran ke " + (i + 1));
                    System.out.println("Angsuran: " + angsuran);
                    System.out.println("Bunga: " + bunga);
                    System.out.println("Angsuran Seharusnya: " + angsuranSeharusnya);
                    System.out.println("Bunga Seharusnya: " + bungaSeharusnya);
                    System.out.println("Angsuran Lebih: " + lebih);
                    System.out.println("Bunga Lebih: " + bungaLebih);
                    System.out.println("==============================================================================");
                }

                if (i > 0) {
                    cal.setTime(p.getTglRealisasi());
                    cal.add(Calendar.MONTH, i);
                }
                String noKwitansi = s.generate(0L, p.getOID());
                JadwalAngsuran ja = new JadwalAngsuran();

                if (!dpShown && isDp) {
                    ja.setPinjamanId(p.getOID());
                    ja.setTanggalAngsuran(cal.getTime());
                    ja.setJumlahANgsuran(angsuran);
                    ja.setJumlahAngsuranSeharusnya(angsuran);
                    ja.setJenisAngsuran(I_Sedana.TIPE_DOC_KREDIT_NASABAH_DOWN_PAYMENT);
                    ja.setNoKwitansi(noKwitansi);
                    PstJadwalAngsuran.insertExc(ja);

                    dpShown = true;
                } else {
                    ja.setPinjamanId(p.getOID());
                    ja.setTanggalAngsuran(cal.getTime());
                    ja.setJumlahANgsuran(angsuran);
                    ja.setJumlahAngsuranSeharusnya(angsuran);
                    ja.setJenisAngsuran(I_Sedana.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_POKOK);
                    ja.setNoKwitansi(noKwitansi);
                    PstJadwalAngsuran.insertExc(ja);

                    ja.setPinjamanId(p.getOID());
                    ja.setTanggalAngsuran(cal.getTime());
                    ja.setJumlahANgsuran(bunga);
                    ja.setJumlahAngsuranSeharusnya(bunga);
                    ja.setJenisAngsuran(I_Sedana.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_BUNGA);
                    ja.setNoKwitansi(noKwitansi);
                    PstJadwalAngsuran.insertExc(ja);
                }

//				ja.setPinjamanId(p.getOID());
//				ja.setTanggalAngsuran(cal.getTime());
//				ja.setJumlahANgsuran(angsuran);
//				ja.setJumlahAngsuranSeharusnya(angsuran);
//				ja.setJenisAngsuran(I_Sedana.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_POKOK);
//				ja.setNoKwitansi(noKwitansi);
//				PstJadwalAngsuran.insertExc(ja);
//
//				ja.setPinjamanId(p.getOID());
//				ja.setTanggalAngsuran(cal.getTime());
//				ja.setJumlahANgsuran(bunga);
//				ja.setJumlahAngsuranSeharusnya(bunga);
//				ja.setJenisAngsuran(I_Sedana.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_BUNGA);
//				ja.setNoKwitansi(noKwitansi);
//				PstJadwalAngsuran.insertExc(ja);
            }
        } catch (Exception exc) {
        }
    }

    public synchronized void createScheduleOnly(HttpServletRequest request, Pinjaman p) {
        try {
            SessKreditKalkulasi k = new SessKreditKalkulasi();
            k.setKredit(PstJenisKredit.fetch(p.getTipeKreditId()));
            k.setRealizationDate(p.getTglRealisasi());
            k.setJangkaWaktu(p.getJangkaWaktu());
            k.setPengajuanTotal(p.getJumlahPinjaman());
            k.setSukuBunga(p.getSukuBunga());
            k.setTipeBunga(p.getTipeBunga());
            k.setWithMinimal(false);
            k.setDateTempo(p.getJatuhTempo());
            k.setTipeJadwal(p.getTipeJadwal());
            k.generateDataKredit();

            double totalPokok = 0;
            DecimalFormat df = new DecimalFormat("#.##");

            for (int i = 1; i < k.getTSize(); i++) {
                int useRounding = 0;
                try {
                    useRounding = Integer.valueOf(PstSystemProperty.getValueByName("GUNAKAN_PEMBULATAN_ANGSURAN"));
                } catch (Exception exc) {
                    printErrorMessage(exc.getMessage());
                }

                // create schedule for angsuran pokok
                if (k.getTPokok(i) != 0) {
                    double jmlAngsuranPokok = 0;

                    if (useRounding == 1) {
//                        jmlAngsuranPokok = (Math.floor((k.getTPokok(i) + 499) / 500)) * 500;
                        jmlAngsuranPokok = convertInteger(-3, k.getTPokok(i));

                        //cek jika total angsuran pokok berbeda dengan jumlah pinjaman
                        if ((totalPokok + jmlAngsuranPokok) > p.getJumlahPinjaman()) {
                            //jika berbeda, nilai angsuran terakhir disesuaikan agar total angsuran sama dengan jumlah pinjaman
                            jmlAngsuranPokok = p.getJumlahPinjaman() - totalPokok;
                        }
                    } else {
                        jmlAngsuranPokok = k.getTPokok(i);
                        if (i == p.getJangkaWaktu()) {
                            //cek jika total angsuran pokok berbeda dengan jumlah pinjaman
                            if (totalPokok < p.getJumlahPinjaman()) {
                                //jika berbeda, nilai angsuran terakhir disesuaikan agar total angsuran sama dengan jumlah pinjaman
                                jmlAngsuranPokok = p.getJumlahPinjaman() - totalPokok;
                            }
                        }
                    }

                    //format angka jadi 2 digit desimal
                    jmlAngsuranPokok = Double.valueOf(df.format(jmlAngsuranPokok));
                    totalPokok += jmlAngsuranPokok;

                    JadwalAngsuran angsuranPokok = new JadwalAngsuran();
                    angsuranPokok.setPinjamanId(p.getOID());
                    angsuranPokok.setTanggalAngsuran(k.getTDate(i));
                    angsuranPokok.setJenisAngsuran(JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                    angsuranPokok.setJumlahANgsuran(jmlAngsuranPokok);
                    angsuranPokok.setJumlahAngsuranSeharusnya(k.getTPokok(i));
                    angsuranPokok.setSisa(jmlAngsuranPokok - k.getTPokok(i));
                    PstJadwalAngsuran.insertExc(angsuranPokok);
                }

                // create schedule for angsuran bunga
                if (k.getTBunga(i) != 0) {
                    double jmlAngsuranBunga = 0;

                    if (useRounding == 1) {
                        jmlAngsuranBunga = (Math.floor((k.getTBunga(i) + 499) / 500)) * 500;
                    } else {
                        jmlAngsuranBunga = k.getTBunga(i);
                    }
                    //format angka jadi 2 digit desimal
                    jmlAngsuranBunga = Double.valueOf(df.format(jmlAngsuranBunga));

                    JadwalAngsuran angsuranBunga = new JadwalAngsuran();
                    angsuranBunga.setPinjamanId(p.getOID());
                    angsuranBunga.setTanggalAngsuran(k.getTDate(i));
                    angsuranBunga.setJenisAngsuran(JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                    angsuranBunga.setJumlahANgsuran(jmlAngsuranBunga);
                    angsuranBunga.setJumlahAngsuranSeharusnya(k.getTBunga(i));
                    angsuranBunga.setSisa(jmlAngsuranBunga - k.getTBunga(i));
                    PstJadwalAngsuran.insertExc(angsuranBunga);
                }
            }

            //CEK LAGI APAKAH TOTAL ANGSURAN POKOK SAMA DENGAN JUMLAH PINJAMAN
            double totalAngsuranPokok = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
            if (totalAngsuranPokok != p.getJumlahPinjaman()) {
                //CARI JADWAL ANGSURAN POKOK
                String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + "'";
                String orderJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN];
                Vector<JadwalAngsuran> listPokok = PstJadwalAngsuran.list(0, 0, whereJadwal, orderJadwal);
                int cek = 1;
                double countPokok = 0;
                for (JadwalAngsuran ja : listPokok) {
                    if (cek == listPokok.size()) {
                        double newPokok = Double.valueOf(df.format(p.getJumlahPinjaman() - countPokok));
                        ja.setJumlahANgsuran(newPokok);
                        try {
                            PstJadwalAngsuran.updateExc(ja);
                        } catch (Exception e) {
//                            objValue.put("RETURN_ERROR_CODE", 1);
//                            message = "Terjadi kesalahan saat penyesuaian jadwal angsuran pokok terakhir. " + e.getMessage();
                            printErrorMessage("Terjadi kesalahan saat penyesuaian jadwal angsuran pokok terakhir. " + e.getMessage());
                        }
                    } else {
                        countPokok += ja.getJumlahANgsuran();
                        cek++;
                    }
                }
            }

            //UPDATE TANGGAL LUNAS KREDIT SESUAI JADWAL ANGSURAN TERAKHIR
            String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'";
            Vector<JadwalAngsuran> listPokokTerakhir = PstJadwalAngsuran.list(0, 1, where, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " DESC ");
            for (JadwalAngsuran ja : listPokokTerakhir) {
                p.setTglLunas(ja.getTanggalAngsuran());
                PstPinjaman.updateExc(p);
            }

        } catch (DBException | NumberFormatException ex) {
//            objValue.put("RETURN_ERROR_CODE", 1);
//            message = ex.getMessage();
            printErrorMessage(ex.getMessage());
        }
    }

    public synchronized JSONObject saveDetailKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String[] arrayIdJenisTransaksi = request.getParameterValues("FORM_ID_JENIS_TRANSAKSI");
        String[] arrayNilai = request.getParameterValues("FORM_NILAI_BIAYA");
        String[] arrayTipe = request.getParameterValues("FORM_TIPE_BIAYA");
        String[] arrayNilaiSelect = request.getParameterValues("FORM_SELECTION_TRANSAKSI");
        String statusDendaStr = FRMQueryString.requestString(request, "FRM_STATUS_DENDA");
        int statusDenda = statusDendaStr.length() > 0 ? Pinjaman.STATUS_DENDA_AKTIF : Pinjaman.STATUS_DENDA_NONAKTIF;
        long oidPinjaman = FRMQueryString.requestLong(request, "SEND_OID_PINJAMAN");
        // hapus biaya sebelum
        Vector<BiayaTransaksi> listBiaya = PstBiayaTransaksi.list(0, 0, "" + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oidPinjaman + "'", "");
        for (int i = 0; i < listBiaya.size(); i++) {
            long idRelasiBiaya = listBiaya.get(i).getOID();
            try {
                PstBiayaTransaksi.deleteExc(idRelasiBiaya);
            } catch (DBException ex) {
                objValue.put("RETURN_MESSAGE", ex.getMessage());
                printErrorMessage(ex.getMessage());
            }
        }

        // simpan biaya baru
        for (int i = 0; i < arrayNilai.length; i++) {
            BiayaTransaksi bt = new BiayaTransaksi();
            bt.setIdPinjaman(oidPinjaman);
            bt.setIdJenisTransaksi(Long.valueOf(arrayIdJenisTransaksi[i]));
            bt.setValueBiaya(Double.valueOf(arrayNilai[i]));
            bt.setTipeBiaya(Integer.valueOf(arrayTipe[i]));
            try {
                PstBiayaTransaksi.insertExc(bt);
                objValue.put("RETURN_MESSAGE", FRMMessage.getMessage(FRMMessage.MSG_SAVED));
            } catch (DBException ex) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", ex.getMessage());
                printErrorMessage(ex.getMessage());
                break;
            }
        }
        String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");
        if (useForRaditya.equals("1")) {
            //simpan kolektor
            long oidKolektor = FRMQueryString.requestLong(request, "KOLEKTOR_ID");
            if (oidKolektor != 0) {
                Pinjaman p = new Pinjaman();
                try {
                    p = PstPinjaman.fetchExc(oidPinjaman);
                } catch (Exception e) {
                    System.out.println("Error fetch pinjaman pada pencairan.");
                    e.printStackTrace();
                }

                p.setCollectorId(oidKolektor);
                p.setStatusDenda(statusDenda);

                try {
                    PstPinjaman.updateExc(p);
                } catch (Exception e) {
                    System.out.println("Error update pinjaman pada pencairan.");
                    e.printStackTrace();
                }

            }

            for (int i = 0; i < arrayNilai.length; i++) {
                BiayaTransaksi bt = new BiayaTransaksi();
                BillMain bm = new BillMain();
                Pinjaman p = new Pinjaman();
                bt.setIdPinjaman(oidPinjaman);
                bt.setIdJenisTransaksi(Long.valueOf(arrayIdJenisTransaksi[i]));
                bt.setValueBiaya(Double.valueOf(arrayNilai[i]));
                bt.setTipeBiaya(Integer.valueOf(arrayTipe[i]));
                try {
                    p = PstPinjaman.fetchExc(oidPinjaman);
                    double biaya = 0;
                    if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                        biaya = p.getJumlahPinjaman() * bt.getValueBiaya() / 100;
                    } else if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                        biaya = bt.getValueBiaya();
                    }
                    try {
                        bm = PstBillMain.fetchExc(p.getBillMainId());
                        if (bt.getIdJenisTransaksi() == Long.parseLong(BiayaTransaksi.TIPE_BIAYA_ADMIN)) {
                            bm.setAdminFee(Double.valueOf(biaya));
                        } else if (bt.getIdJenisTransaksi() == Long.parseLong(BiayaTransaksi.TIPE_BIAYA_ONGKIR)) {
                            bm.setShippingFee(Double.valueOf(biaya));
                        }
                        PstBillMain.updateExc(bm);
                    } catch (Exception e) {
                    }
                    objValue.put("RETURN_MESSAGE", FRMMessage.getMessage(FRMMessage.MSG_SAVED));
                } catch (DBException ex) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", ex.getMessage());
                    printErrorMessage(ex.getMessage());
                    break;
                }
            }
        }
        if (useForRaditya.equals("0")) {
            //simpan transaksi tanpa value
            for (int i = 0; i < arrayNilaiSelect.length; i++) {
                BiayaTransaksi bt = new BiayaTransaksi();
                bt.setIdPinjaman(oidPinjaman);
                bt.setIdJenisTransaksi(Long.valueOf(arrayNilaiSelect[i]));
                bt.setValueBiaya(0);
                bt.setTipeBiaya(0);
                try {
                    PstBiayaTransaksi.insertExc(bt);
                    objValue.put("RETURN_MESSAGE", FRMMessage.getMessage(FRMMessage.MSG_SAVED));
                } catch (DBException ex) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", ex.getMessage());
                    printErrorMessage(ex.getMessage());
                    break;
                }
            }
        }
        long idTabunganWajib = FRMQueryString.requestLong(request, "FORM_WAJIB_TABUNGAN");
        long idSimpananPencairan = FRMQueryString.requestLong(request, "FORM_ALOKASI_TABUNGAN_PENCAIRAN");

        try {
            Pinjaman pinjaman = PstPinjaman.fetchExc(oidPinjaman);
            pinjaman.setWajibIdJenisSimpanan(idTabunganWajib);
            //if (idTabunganWajib > 0) {
            double valueWajib1 = FRMQueryString.requestDouble(request, "PERSEN_WAJIB");
            double valueWajib2 = FRMQueryString.requestDouble(request, "NOMINAL_WAJIB");
            int valType = valueWajib1 > 0 ? Pinjaman.WAJIB_VALUE_TYPE_PERSEN : Pinjaman.WAJIB_VALUE_TYPE_NOMINAL;

            pinjaman.setWajibValue(valueWajib1 > 0 ? valueWajib1 : valueWajib2);
            pinjaman.setWajibValueType(valType);
            //}

            if (PstDataTabungan.checkOID(idSimpananPencairan)) {
                try {
                    pinjaman.setAssignTabunganId(PstDataTabungan.fetchExc(idSimpananPencairan).getAssignTabunganId());
                    pinjaman.setIdJenisSimpanan(PstDataTabungan.fetchExc(idSimpananPencairan).getIdJenisSimpanan());
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                }
            }
            PstPinjaman.updateExc(pinjaman);
            if (idTabunganWajib == 0) {
                SessKredit.hapusIdSimpananWajib(pinjaman.getOID());
            }
            if (idSimpananPencairan == 0) {
                SessKredit.hapusIdSimpananPencairan(pinjaman.getOID());
            }

        } catch (DBException ex) {
            printErrorMessage(ex.getMessage());
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", ex.getMessage());
        }

        //simpan mapping denda
        //hapus mapping denda sebelum
        Vector<MappingDendaPinjaman> listMappingDenda = PstMappingDendaPinjaman.list(0, 0, "" + PstMappingDendaPinjaman.fieldNames[PstMappingDendaPinjaman.FLD_PINJAMAN_ID] + " = " + oidPinjaman, "");
        for (MappingDendaPinjaman mdp : listMappingDenda) {
            try {
                PstMappingDendaPinjaman.deleteExc(mdp.getOID());
            } catch (DBException ex) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", ex.getMessage());
                printErrorMessage(ex.getMessage());
            }
        }
        //set mapping denda
        MappingDendaPinjaman dendaPinjaman = new MappingDendaPinjaman();
        dendaPinjaman.setNilaiDenda(FRMQueryString.requestDouble(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_DENDA]));
        dendaPinjaman.setTipeDendaBerlaku(FRMQueryString.requestInt(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TIPE_DENDA_BERLAKU]));
        dendaPinjaman.setTipePerhitunganDenda(FRMQueryString.requestInt(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TIPE_PERHITUNGAN_DENDA]));
        dendaPinjaman.setFrekuensiDenda(FRMQueryString.requestInt(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_FREKUENSI_DENDA]));
        dendaPinjaman.setSatuanFrekuensiDenda(FRMQueryString.requestInt(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_SATUAN_FREKUANSI_DENDA]));
        dendaPinjaman.setPinjamanId(oidPinjaman);
        dendaPinjaman.setDendaToleransi(FRMQueryString.requestInt(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_DENDA_TOLERANSI]));
        dendaPinjaman.setVariabelDenda(FRMQueryString.requestInt(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_VARIABEL_DENDA]));
        dendaPinjaman.setJenisAngsuran(JadwalAngsuran.TIPE_ANGSURAN_DENDA);
        dendaPinjaman.setTipeVariabelDenda(FRMQueryString.requestInt(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TIPE_VARIABEL_DENDA]));
        dendaPinjaman.setTipeFrekuensiDenda(FRMQueryString.requestInt(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TIPE_FREKUENSI_DENDA]));

        //set mapping bunga tambahan
        /*BATAL DIGUNAKAN
         MappingDendaPinjaman bungaTambahan = new MappingDendaPinjaman();
         bungaTambahan.setNilaiDenda(FRMQueryString.requestDouble(request, "FRM_BUNGA"));
         bungaTambahan.setTipeDendaBerlaku(FRMQueryString.requestInt(request, "FRM_TIPE_BUNGA_BERLAKU"));
         bungaTambahan.setTipePerhitunganDenda(FRMQueryString.requestInt(request, "FRM_TIPE_PERHITUNGAN_BUNGA"));
         bungaTambahan.setFrekuensiDenda(FRMQueryString.requestInt(request, "FRM_FREKUENSI_BUNGA"));
         bungaTambahan.setSatuanFrekuensiDenda(FRMQueryString.requestInt(request, "FRM_SATUAN_FREKUANSI_BUNGA"));
         bungaTambahan.setPinjamanId(this.oidPinjaman);
         bungaTambahan.setDendaToleransi(FRMQueryString.requestInt(request, "TOLERANSI_BUNGA"));
         bungaTambahan.setVariabelDenda(FRMQueryString.requestInt(request, "FRM_VARIABEL_BUNGA"));
         bungaTambahan.setJenisAngsuran(JadwalAngsuran.TIPE_ANGSURAN_BUNGA_TAMBAHAN);
         */
        try {
            PstMappingDendaPinjaman.insertExc(dendaPinjaman);
            //PstMappingDendaPinjaman.insertExc(bungaTambahan);
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.getMessage());
        }

        return objValue;
    }

    public synchronized JSONObject kirimPengajuan(HttpServletRequest request, JSONObject objValue) throws JSONException{
        objValue = getSyaratPengajuan(request, objValue);
        int syaratTerpenuhi = objValue.optInt("syaratTerpenuhi",0);
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        if (true || syaratTerpenuhi >= 2) {
            Pinjaman p = new Pinjaman();
            try {
                p = PstPinjaman.fetchExc(oid);
                p.setStatusPinjaman(Pinjaman.STATUS_DOC_TO_BE_APPROVE);
                PstPinjaman.updateExc(p);
            } catch (Exception exc) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", exc.getMessage());
                printErrorMessage(exc.getMessage());
            }
        } else {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", "Syarat belum terpenuhi");
        }
        return objValue;
    }

    //Save Tabungan-------------------------------------------------------------
    public synchronized JSONObject saveTabungan(HttpServletRequest request, JSONObject objValue) throws JSONException{
        int iCommand = FRMQueryString.requestCommand(request);
        CtrlAssignContact ctrlAssignContact = new CtrlAssignContact(request);
        int iErrCode = ctrlAssignContact.action(iCommand, 0);
        objValue.optInt("iErrCode",iErrCode);
        return objValue;
    }

    //COMMAND DELETE============================================================
    public synchronized JSONObject commandDelete(HttpServletRequest request, String dataFor, JSONObject objValue) throws JSONException{
        if (dataFor.equals("deleteTransaction")) {
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            objValue = deleteTransaction(request, oid, objValue);
        } else if (dataFor.equals("deleteKreditHapus")){
            objValue = deleteHapusKredit(request, objValue);
        }
        return objValue;
    }

    public synchronized JSONObject deleteHapusKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        try {
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            
            PstHapusKredit.deleteExc(oid);
            
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.getMessage());
        }
        return objValue;
    }
    
    public synchronized JSONObject deleteTransaction(HttpServletRequest request, long idTransaksi, JSONObject objValue) throws JSONException{
        try {
            Transaksi t = PstTransaksi.fetchExc(idTransaksi);
            //CEK STATUS TRANSAKSI
            if (t.getStatus() == Transaksi.STATUS_DOC_TRANSAKSI_POSTED) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "Tidak dapat menghapus transaksi dengan status " + Transaksi.STATUS_DOC_TRANSAKSI_TITLE[t.getStatus()]);
                return objValue;
            }

            //CEK STATUS KREDIT
            if (t.getPinjamanId() != 0) {
                Pinjaman p = PstPinjaman.fetchExc(t.getPinjamanId());
                if (p.getStatusPinjaman() != Pinjaman.STATUS_DOC_CAIR) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Tidak dapat menghapus transaksi kredit dengan status kredit " + Pinjaman.STATUS_DOC_TITLE[p.getStatusPinjaman()]);
                    return objValue;
                }
            }

            //CEK APAKAH TRANSAKSI PUNYA CHILD TRANSAKSI
            Vector<Transaksi> listChild = PstTransaksi.list(0, 0, PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_PARENT_ID] + " = " + idTransaksi, null);
            //CEK APAKAH ADA CHILD YG SUDAH POSTED
            for (Transaksi tChild : listChild) {
                if (tChild.getStatus() == Transaksi.STATUS_DOC_TRANSAKSI_POSTED) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "Tidak dapat menghapus transaksi. Terdapat transaksi child dengan status " + Transaksi.STATUS_DOC_TRANSAKSI_TITLE[t.getStatus()]);
                    return objValue;
                }
            }
            //HAPUS TRANSAKSI CHILD
            for (Transaksi tChild : listChild) {
                deleteTransaction(request, tChild.getOID(), objValue);
                if (objValue.optInt("iErrCode",0) > 0) {
                    return objValue;
                }
            }

            //CREATE HISTORY
            Transaksi t2 = PstTransaksi.fetchExc(idTransaksi);
            objValue.put("history", getHistoryTransaksi(t2));
            long userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
            String userName = FRMQueryString.requestString(request, "SEND_USER_NAME");
            if (objValue.optInt("iErrCode",0) == 0) {
                //CEK USECASE TYPE
                switch (t.getUsecaseType()) {
                    case Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN:
                        //HAPUS OID TRANSAKSI PENCAIRAN DARI JADWAL
                        int dataUpdated = PstJadwalAngsuran.updateIdTransaksiJadwalAngsuranKredit(t.getPinjamanId(), t.getOID());
                        break;
                    case Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN:
                    case Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN:
                    case Transaksi.USECASE_TYPE_KREDIT_PENALTY_DINI_PENCATATAN:
                    case Transaksi.USECASE_TYPE_KREDIT_PENALTY_MACET_PENCATATAN:
                        //CARI DATA JADWAL
                        Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                        //CEK APAKAH ADA JADWAL YG SUDAH DIBAYAR
                        for (JadwalAngsuran ja : listJadwal) {
                            Vector<Angsuran> listAngsuran = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + ja.getOID(), null);
                            if (!listAngsuran.isEmpty()) {
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", "Tidak dapat menghapus jadwal " + JadwalAngsuran.getTipeAngsuranTitle(ja.getJenisAngsuran()) + " tanggal " + ja.getTanggalAngsuran() + " karena sudah dibayar.");
                                return objValue;
                            }
                        }
                        //HAPUS DATA JADWAL
                        for (JadwalAngsuran ja : listJadwal) {
                            try {
                                PstJadwalAngsuran.deleteExc(ja.getOID());
                            } catch (Exception e) {
                                printErrorMessage(e.getMessage());
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", e.getMessage());
                                return objValue;
                            }
                        }
                        break;

                    case Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT:
                        //HAPUS DATA ANGSURAN
                        Vector<Angsuran> listAngsuran = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                        for (Angsuran a : listAngsuran) {
                            try {
                                PstAngsuran.deleteExc(a.getOID());
                            } catch (Exception e) {
                                printErrorMessage(e.getMessage());
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", e.getMessage());
                                return objValue;
                            }
                        }
                        //HAPUS DATA PAYMENT
                        Vector<AngsuranPayment> listPayment = PstAngsuranPayment.list(0, 0, PstAngsuranPayment.fieldNames[PstAngsuranPayment.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                        for (AngsuranPayment ap : listPayment) {
                            try {
                                PstAngsuranPayment.deleteExc(ap.getOID());
                            } catch (Exception e) {
                                printErrorMessage(e.getMessage());
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", e.getMessage());
                                return objValue;
                            }
                        }
                        //HAPUS DATA DETAIL
                        Vector<DetailTransaksi> listDetail = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                        for (DetailTransaksi dt : listDetail) {
                            try {
                                PstDetailTransaksi.deleteExc(dt.getOID());
                            } catch (Exception e) {
                                printErrorMessage(e.getMessage());
                                objValue.put("RETURN_ERROR_CODE", 1);
                                objValue.put("RETURN_MESSAGE", e.getMessage());
                                return objValue;
                            }
                        }
                        break;

                    case Transaksi.USECASE_TYPE_TABUNGAN_SETORAN:
                    case Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN:
                    case Transaksi.USECASE_TYPE_TABUNGAN_PENUTUPAN:
                        AjaxTabungan at = new AjaxTabungan();
                        String message = at.deleteTransaction(t.getOID(), userId, userName);
                        objValue.put("RETURN_MESSAGE", message);
                        return objValue;
                }

                if (objValue.optInt("iErrCode",0) == 0) {
                    PstTransaksi.deleteExc(t.getOID());
                    objValue.put("RETURN_MESSAGE", "Transaksi " + t.getKodeBuktiTransaksi() + " berhasil dihapus");
                    SessHistory sessHistory = new SessHistory();
                    sessHistory.saveHistory(userId, userName, "DELETE", t2.getOID(), t2.getKodeBuktiTransaksi(), SessHistory.document[SessHistory.DOC_TRANSAKSI_KREDIT], "SEDANA", "#", objValue.optString("history",""));
                }
            }
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.getMessage());
        }
        return objValue;
    }

    public String getHistoryTransaksi(Transaksi t) {
        String detailTransaksi = "";
        String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
        try {
            Anggota anggota = PstAnggota.fetchExc(t.getIdAnggota());
            Pinjaman p = new Pinjaman();
            if (t.getPinjamanId() != 0) {
                p = PstPinjaman.fetchExc(t.getPinjamanId());
            }
            CashTeller cashTeller = PstCashTeller.fetchExc(t.getTellerShiftId());
            SedanaShift shift = PstSedanaShift.fetchExc(cashTeller.getShiftId());
            double nilaiTransaksi = 0;
            switch (t.getUsecaseType()) {
                case Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT:
                    Vector<Angsuran> listAngsuran = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                    for (Angsuran a : listAngsuran) {
                        nilaiTransaksi += a.getJumlahAngsuran();
                    }
                    break;
                case Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN:
                case Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN:
                    Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                    for (JadwalAngsuran ja : listJadwal) {
                        nilaiTransaksi += ja.getJumlahANgsuran();
                    }
                    break;
                case Transaksi.USECASE_TYPE_TABUNGAN_SETORAN:
                case Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN:
                    Vector<DetailTransaksi> listDetail = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                    for (DetailTransaksi dt : listDetail) {
                        nilaiTransaksi += dt.getKredit() - dt.getDebet();
                    }
                    break;
            }

            detailTransaksi += " Kode Transaksi : " + t.getKodeBuktiTransaksi();
            detailTransaksi += ",Tanggal Transaksi : " + Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss");
            detailTransaksi += ",Nilai Transaksi : " + String.format("%,.2f", nilaiTransaksi);
            detailTransaksi += ",Keterangan : " + t.getKeterangan();
            detailTransaksi += ",Status Transaksi : " + Transaksi.STATUS_DOC_TRANSAKSI_TITLE[t.getStatus()];
            detailTransaksi += ",Tipe Arus Kas : " + Transaksi.TIPE_ARUS_KAS_TITLE[t.getTipeArusKas()];
            detailTransaksi += ",Use Case : " + Transaksi.USECASE_TYPE_TITLE.get(t.getUsecaseType());
            detailTransaksi += "," + namaNasabah + " : " + anggota.getName();
            detailTransaksi += ",Shift : " + shift.getName();
            detailTransaksi += ",Nomor Pinjaman : " + p.getNoKredit();
            detailTransaksi += ",Id Transaksi : " + t.getOID();
            detailTransaksi += " ";
        } catch (DBException | com.dimata.posbo.db.DBException e) {
            printErrorMessage(e.getMessage());
        }
        return detailTransaksi;
    }

    //COMMAND LIST==============================================================
    public JSONObject commandList(HttpServletRequest request, HttpServletResponse response, String dataFor, JSONObject objValue) throws JSONException{
        String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
        if (dataFor.equals("listPinjamanAll")) {
            if (typeOfCredit.equals("1")) {
                String[] cols = {
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN],
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                    "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                    "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                    "loc." + PstLocation.fieldNames[PstLocation.FLD_NAME],
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN]
                };
                objValue = listDataTables(request, response, cols, dataFor, objValue);
            } else {
                String[] cols = {
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN],
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                    "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                    "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                    "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN]
                };
                objValue = listDataTables(request, response, cols, dataFor, objValue);

            }
        } else if (dataFor.equals("listPinjamanFinal")) {
            String[] cols = {
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "loc." + PstLocation.fieldNames[PstLocation.FLD_NAME],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                //"sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listSearchKredit")) {
            String[] cols = {
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "loc." + PstLocation.fieldNames[PstLocation.FLD_NAME],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                //"sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listSearchReturn")) {
            String[] cols = {
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "loc." + PstLocation.fieldNames[PstLocation.FLD_NAME],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                //"sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listHistory")) {
            String[] cols = {
                "" + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_ID],
                "" + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_UPDATE_DATE],
                "" + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_LOGIN_NAME],
                "" + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_USER_ACTION]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listPencairan")) {
            String[] cols = {
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "loc." + PstLocation.fieldNames[PstLocation.FLD_NAME],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN]
            //"sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA],
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listPenilaian")) {
            String[] cols = {
                "",
                //				"pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                //"sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN],
                ""
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listAngsuran")) {
            String[] cols = {
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listJenisTransaksi")) {
            String[] cols = {
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_TRANSAKSI],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_PROSEDUR],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_INPUT_OPTION],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSENTASE_PERHITUNGAN],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_VALUE_STANDAR_TRANSAKSI],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF],
                "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listTransaksiKredit")) {
            String[] cols = {
                "t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI],
                "t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI],
                "t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE],
                "t." + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI],
                "a." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "loc." + PstLocation.fieldNames[PstLocation.FLD_NAME],
                "p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "p." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN]
            //"t." + PstTransaksi.fieldNames[PstTransaksi.FLD_STATUS]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listReturn")) {
            String[] cols = {
                "r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN],
                "r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN],
                "con." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME],
                "r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN],
                "r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS],
                "r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listHapus")) {
            String[] cols = {
                "h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_NOMOR_HAPUS],
                "h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_TANGGAL_HAPUS],
                "con." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME],
                "h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_CATATAN],
                "h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_STATUS],
                "h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_STATUS]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listKreditKolektabilitas")) {
            String[] cols = {
                "",
                "AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "CL." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "",
                "",
                "",
                ""
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listRiwayatKonsumen")) {
            String[] cols = {
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "loc." + PstLocation.fieldNames[PstLocation.FLD_NAME],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        } else if (dataFor.equals("listDokumenKonsumen")) {
            String[] cols = {
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "loc." + PstLocation.fieldNames[PstLocation.FLD_NAME],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN]
            };
            objValue = listDataTables(request, response, cols, dataFor, objValue);
        }
        
        return objValue;
    }

    public JSONObject listDataTables(HttpServletRequest request, HttpServletResponse response, String[] cols, String dataFor, JSONObject result) throws JSONException{
        String searchTerm = FRMQueryString.requestString(request, "sSearch");
        result.put("searchTerm", searchTerm);
        int amount = 10;
        int start = 0;
        int col = 0;
        String dir = "asc";
        if (dataFor.equals("listTransaksiKredit") || dataFor.equals("listHistory")) {
            dir = "desc";
        }
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
                if (dataFor.equals("listTransaksiKredit") || dataFor.equals("listHistory")) {
                    dir = "asc";
                }
            }
        }

        
        SessUserSession userSession = getUserSession(request);
        int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_PENILAIAN_KREDIT);
        boolean privAccept = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ACCEPT));
        String userGroupAdmin = PstSystemProperty.getValueByName("GROUP_ADMIN_OID");
        String whereUserGroup = PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + "=" + userGroupAdmin
                + " AND " + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "=" + userSession.getAppUser().getOID();
        Vector listUserGroup = PstUserGroup.list(0, 0, whereUserGroup, "");
        
        String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
        String form_num = FRMQueryString.requestString(request, "form_num");
        String kredit_num = FRMQueryString.requestString(request, "kredit_num");
        String start_date = FRMQueryString.requestString(request, "startDate");
        String end_date = FRMQueryString.requestString(request, "endDate");
        String[] strList = request.getParameterValues("form_status");
        List<String> form_status = new ArrayList<>();
        if (strList != null) {
            form_status = Arrays.asList(strList);
        }
        String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");
        long oidKolektor = FRMQueryString.requestLong(request, FrmPinjaman.fieldNames[FrmPinjaman.FRM_COLLECTOR_ID]);
        int jenisReturn = FRMQueryString.requestInt(request, "JENIS_RETURN");
        String tglReturn = FRMQueryString.requestString(request, "TGL_RETURN");
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        long oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");
        String statusDoc = FRMQueryString.requestString(request, "SEND_STATUS_DOC");
        
        String whereClause = "";
        if (dataFor.equals("listPinjamanAll")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_SUKU_BUNGA] + " LIKE '%" + searchTerm + "%'"
                        + ")";
                if (!privAccept && listUserGroup.isEmpty()) {
                    whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                            +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
                }
            } else {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_SUKU_BUNGA] + " LIKE '%" + searchTerm + "%'"
                        // + " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        } else if (dataFor.equals("listPinjamanFinal")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        //+ " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            } else {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        } else if (dataFor.equals("listSearchKredit")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        //+ " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            } else {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
            boolean isSearchHapus = FRMQueryString.requestBoolean(request, "SEARCH_HAPUS");
            if (isSearchHapus){
                whereClause += " AND pinjaman."+PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]+" NOT IN (SELECT PINJAMAN_ID FROM sedana_hapus_kredit WHERE STATUS = 0)";
            }
        } else if (dataFor.equals("listSearchReturn")) {
            whereClause += "("
                    + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    //+ " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (dataFor.equals("listHistory")) {
            whereClause += "("
                    + "" + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_ID] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_UPDATE_DATE] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_LOGIN_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_USER_ACTION] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (dataFor.equals("listPencairan")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        //+ " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
                if (!privAccept && listUserGroup.isEmpty()) {
                    whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                            +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
                }
            } else {
                whereClause += "("
                        + "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        } else if (dataFor.equals("listPenilaian")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            } else {
                whereClause += "("
                        + "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        } else if (dataFor.equals("listAngsuran")) {
            whereClause += "("
                    + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + ")";

        } else if (dataFor.equals("listJenisTransaksi")) {
            whereClause += "("
                    + "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_PROSEDUR] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_INPUT_OPTION] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSENTASE_PERHITUNGAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_VALUE_STANDAR_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (dataFor.equals("listTransaksiKredit")) {
            whereClause += "("
                    + "t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR t." + PstTransaksi.fieldNames[PstTransaksi.FLD_KETERANGAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR t." + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR a." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (dataFor.equals("listReturn")) {
            whereClause += "("
                    + "r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN] + " LIKE '%" + searchTerm + "%'"
                    + " OR r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN] + " LIKE '%" + searchTerm + "%'"
                    + " OR con." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS] + " LIKE '%" + searchTerm + "%'"
                    + ")";
            if (form_num != null && form_num.length() > 0) {
                whereClause += " AND r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN] + "='" + form_num + "'";
            }
            if (kredit_num != null && kredit_num.length() > 0) {
                whereClause += " AND p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + "='" + kredit_num + "'";
            }
            if ((start_date != null && start_date.length() > 0) && (end_date != null && end_date.length() > 0)) {
                whereClause += " AND ("
                        + "(r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN] + ""
                        + ">= '" + start_date + "') AND "
                        + "(r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN] + ""
                        + "<= '" + end_date + "')"
                        + ")";
            }
            if (strList != null){
                String inStatus = "";
                for (int i = 0; i < strList.length; i++){
                    if (inStatus.length()>0){
                        inStatus += ","+strList[i];
                    } else {
                        inStatus += strList[i];
                    }
                }
                whereClause += " AND r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS] + " IN ("+inStatus+")";
            }
        } else if (dataFor.equals("listHapus")) {
            whereClause += "("
                    + "h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_NOMOR_HAPUS] + " LIKE '%" + searchTerm + "%'"
                    + " OR h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_TANGGAL_HAPUS] + " LIKE '%" + searchTerm + "%'"
                    + " OR con." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_CATATAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_STATUS] + " LIKE '%" + searchTerm + "%'"
                    + ")";
            if (form_num != null && form_num.length() > 0) {
                whereClause += " AND h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_NOMOR_HAPUS] + "='" + form_num + "'";
            }
            if (kredit_num != null && kredit_num.length() > 0) {
                whereClause += " AND p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + "='" + kredit_num + "'";
            }
            if ((start_date != null && start_date.length() > 0) && (end_date != null && end_date.length() > 0)) {
                whereClause += " AND ("
                        + "(h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_TANGGAL_HAPUS] + ""
                        + ">= '" + start_date + " 00:00:00') AND "
                        + "(h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_TANGGAL_HAPUS] + ""
                        + "<= '" + end_date + " 23:59:00')"
                        + ")";
            }
            if (strList != null){
                String inStatus = "";
                for (int i = 0; i < strList.length; i++){
                    if (inStatus.length()>0){
                        inStatus += ","+strList[i];
                    } else {
                        inStatus += strList[i];
                    }
                }
                whereClause += " AND h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_STATUS] + " IN ("+inStatus+")";
            }
        } else if (dataFor.equals("listKreditKolektabilitas")) {
            whereClause = " ("
                    + "AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + "OR CL." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + "OR AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (dataFor.equals("listRiwayatKonsumen")) {
            whereClause = "("
                        + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_SUKU_BUNGA] + " LIKE '%" + searchTerm + "%'"
                        + ")";
        } else if (dataFor.equals("listDokumenKonsumen")) {
            whereClause = "("
                        + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_SUKU_BUNGA] + " LIKE '%" + searchTerm + "%'"
                        + ")";
        }

        String colName = cols[col];
        int total = -1;

        //cek parameter daftar transaksi
        String addSql = "";
        if (dataFor.equals("listTransaksiKredit")) {
            String tglAwal = FRMQueryString.requestString(request, "SEND_TGL_AWAL");
            String tglAkhir = FRMQueryString.requestString(request, "SEND_TGL_AKHIR");
            String dataNasabah = FRMQueryString.requestString(request, "SEND_ID_NASABAH");
            String dataTransaksi = FRMQueryString.requestString(request, "SEND_KODE_TRANSAKSI");
            long dataKolektor = FRMQueryString.requestLong(request, "SEND_ID_KOLEKTOR");
            long dataUser = FRMQueryString.requestLong(request, "SEND_ID_USER");
            int status = FRMQueryString.requestInt(request, "FRM_STATUS");
            if (!tglAwal.equals("") && !tglAkhir.equals("")) {
                addSql += " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + tglAwal + "'"
                        + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + tglAkhir + "'";
            }
            if (!dataNasabah.equals("") && !dataNasabah.equals("null") && !dataNasabah.equals("undefined")) {
                String arrayNasabah[] = dataNasabah.split(",");
                String idNasabah = "";
                for (int i = 0; i < arrayNasabah.length; i++) {
                    if (arrayNasabah[i].equals("0")) {
                        continue;
                    }
                    if (i > 0) {
                        idNasabah += ",";
                    }
                    idNasabah += arrayNasabah[i];
                }
                addSql += (idNasabah.isEmpty()) ? "" : " AND a." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " IN (" + idNasabah + ")";
            }
            if (!dataTransaksi.equals("") && !dataTransaksi.equals("null") && !dataTransaksi.equals("undefined")) {
                String arrayTransaksi[] = dataTransaksi.split(",");
                String kodeTransaksi = "";
                for (int i = 0; i < arrayTransaksi.length; i++) {
                    if (arrayTransaksi[i].equals("0")) {
                        continue;
                    }
                    if (i > 0) {
                        kodeTransaksi += ",";
                    }
                    kodeTransaksi += arrayTransaksi[i];
                }
                if (kodeTransaksi.isEmpty()) {
                    addSql += " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN ("
                            + "" + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT;
                    if (useForRaditya.equals("0")) {
                        addSql += "," + Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN;
                    }
                    addSql += "," + Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN
                            + "," + Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN
                            + "," + Transaksi.USECASE_TYPE_KREDIT_PENALTY_MACET_PENCATATAN
                            + "," + Transaksi.USECASE_TYPE_KREDIT_PENALTY_DINI_PENCATATAN
                            + ")";
                } else {
                    addSql += " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + kodeTransaksi + ")";
                }
            }
            if(dataKolektor != 0){
                addSql += " AND p." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + dataKolektor;
            }
            if(dataUser != 0){
                addSql += " AND u." + PstAppUser.fieldNames[PstAppUser.FLD_EMPLOYEE_ID] + " = " + dataUser;
            }
            if (status > 0){
                addSql += " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_STATUS] + " = " + status ;
            }
        }

        if (dataFor.equals("listPinjamanFinal")) {
            if (typeOfCredit.equals("1")) {
                whereClause += " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "' ";
                if (userSession.getAppUser().getAssignLocationId() != 0) {
                    whereClause += " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId();
                }
                if(oidKolektor != 0){
                    whereClause += " AND (pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + oidKolektor + " OR "
                            + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " = " + oidKolektor+")";
                }
                total = PstPinjaman.getCountJoinKredit(whereClause);
//                Vector<Pinjaman> tempList = PstPinjaman.listJoinKredit(0, 0, whereClause, "");
//                if (!tempList.isEmpty()) {
//                    for (Pinjaman p : tempList) {
//                        String url = this.posApiUrl + "/bill/billmain/check-production/" + p.getBillMainId();
//                        JSONObject apiResponse = WebServices.getAPI("", url);
//                        int status = apiResponse.optInt("STATUS", -1);
//                        if (status == PstBillMain.PETUGAS_DELIVERY_STATUS_DITERIMA || status == PstBillMain.PETUGAS_DELIVERY_STATUS_DIKIRIM) {
//                            this.listIdPinjaman.add(p);
//                        }
//                    }
//                }
//                total = this.listIdPinjaman.size();
            } else {
                total = PstPinjaman.getCountJoinPinjaman(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'");
            }
        } else if (dataFor.equals("listSearchKredit")) {
            
            Vector listLocation = PstLocation.getListFromApiAll();
            String inLocation = "";
            for (int i = 0; i < listLocation.size(); i++) {
                Location loc = (Location) listLocation.get(i);
                boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+loc.getOID());
                if (loc.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
                    if (inLocation.length()>0){
                      inLocation += ","  ;
                    } 
                    inLocation += ""+loc.getOID();
                }
            }
            
            if (typeOfCredit.equals("1")) {
                if (inLocation.length()>0) {
                    total = PstPinjaman.getCountJoinKredit(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "' AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " IN ( " + inLocation +")");
                } else {
                    total = PstPinjaman.getCountJoinKredit(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'");
                }
            } else {
                total = PstPinjaman.getCountJoinPinjaman(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'");
            }
        } else if (dataFor.equals("listSearchReturn")) {
            if (jenisReturn == ReturnKredit.JENIS_RETURN_CABUTAN){
                whereClause += " AND (MONTH(pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]+") != MONTH('"+tglReturn+"') OR YEAR(pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]+") != YEAR('"+tglReturn+"'))";
            } else {
                whereClause += " AND MONTH(pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]+") = MONTH('"+tglReturn+"') AND YEAR(pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]+") = YEAR('"+tglReturn+"')";
            }
            whereClause += " AND pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]+" NOT IN (SELECT PINJAMAN_ID FROM sedana_return_kredit WHERE STATUS=0)";
            if (userSession.getAppUser().getAssignLocationId() != 0) {
                total = PstPinjaman.getCountJoinReturn(whereClause + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "' AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId());
            } else {
                total = PstPinjaman.getCountJoinReturn(whereClause + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'");
            }
        } else if (dataFor.equals("listHistory")) {
            total = PstLogSysHistory.getCount(whereClause + " AND " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DOCUMENT_ID] + " = '" + oid + "'");
        } else if (dataFor.equals("listPencairan")) {
            if (typeOfCredit.equals("1")) {
                if (userSession.getAppUser().getAssignLocationId() != 0) {
                    total = PstPinjaman.getCountJoinKredit(whereClause + " AND (" + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_APPROVED + "' OR " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "') AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId());
                } else {
                    total = PstPinjaman.getCountJoinKredit(whereClause + " AND (" + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_APPROVED + "' OR " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "')");
                }
            } else {
                total = PstPinjaman.getCountJoinPinjaman(whereClause + " AND (" + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_APPROVED + "' OR " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "')");
            }
        } else if (dataFor.equals("listPenilaian")) {
            if (typeOfCredit.equals("1")) {
//                if(this.privPosAnalis){
//                    whereClause += " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " = " + this.oidEmployeeUser;
//                }
                if (!privAccept && listUserGroup.isEmpty()) {
                    whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                            +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
                }
                whereClause += " AND ("
                        + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_TO_BE_APPROVE + "'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_APPROVED + "'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'"
                        + ")";
                if (oidLocation != 0) {
                    whereClause += " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + oidLocation;
                }
                total = PstPinjaman.getCountJoinKredit(whereClause);
            } else {
                total = PstPinjaman.getCountJoinPinjaman(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_TO_BE_APPROVE + "'");
            }
        } else if (dataFor.equals("listAngsuran")) {
            if (typeOfCredit.equals("1")) {
                total = PstPinjaman.getCountJoinKredit(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'");

            } else {
                total = PstPinjaman.getCountJoinPinjaman(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'");
            }
        } else if (dataFor.equals("listPinjamanAll")) {

            if (statusDoc.equals("all")) {
                if (typeOfCredit.equals("1")) {
                    if (userSession.getAppUser().getAssignLocationId() != 0) {
                        total = PstPinjaman.getCountJoinKredit(whereClause + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId());
                    } else {
                        total = PstPinjaman.getCountJoinKredit(whereClause);
                    }
                } else {
                    total = PstPinjaman.getCountJoinPinjaman(whereClause);
                }
            } else {
                if (typeOfCredit.equals("1")) {
                    if (userSession.getAppUser().getAssignLocationId() != 0) {
                        total = PstPinjaman.getCountJoinKredit(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + statusDoc + "' AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId());
                    } else {
                        total = PstPinjaman.getCountJoinKredit(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + statusDoc + "'");
                    }
                } else {
                    total = PstPinjaman.getCountJoinPinjaman(whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + statusDoc + "'");
                }
            }
        } else if (dataFor.equals("listJenisTransaksi")) {
            total = PstJenisTransaksi.getCount(whereClause);
        } else if (dataFor.equals("listTransaksiKredit")) {
            if (userSession.getAppUser().getAssignLocationId() != 0) {
                total = SessKredit.getCountListTransaksiKredit(whereClause + addSql + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId());
            } else {
                total = SessKredit.getCountListTransaksiKredit(whereClause + addSql);
            }
        } else if (dataFor.equals("listReturn")) {
            if (userSession.getAppUser().getAssignLocationId() != 0) {
                total = SessKredit.getCountListReturn(whereClause + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId());
            } else {
                total = SessKredit.getCountListReturn(whereClause);
            }
        } else if (dataFor.equals("listHapus")) {
            Vector listLocation = PstLocation.getListFromApiAll();
            String inLocation = "";
            for (int i = 0; i < listLocation.size(); i++) {
                Location loc = (Location) listLocation.get(i);
                boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+loc.getOID());
                if (loc.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
                    if (inLocation.length()>0){
                      inLocation += ","  ;
                    } 
                    inLocation += ""+loc.getOID();
                }
            }
            total = SessKredit.getCountListHapus(whereClause + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " IN (" + inLocation+")");
//            if (userSession.getAppUser().getAssignLocationId() != 0) {
//                total = SessKredit.getCountListHapus(whereClause + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId());
//            } else {
//                total = SessKredit.getCountListHapus(whereClause);
//            }
        } else if (dataFor.equals("listKreditKolektabilitas")) {
            String noKredit = FRMQueryString.requestString(request, "NO_KREDIT");
            long lokasiId = FRMQueryString.requestLong(request, "LOKASI_ID");
            long kolektabilitasId = FRMQueryString.requestLong(request, "KOLEKTABILITAS_ID");

            whereClause += " AND AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "' ";
            if (noKredit != null && noKredit.length() > 0) {
                whereClause += " AND AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + noKredit + "%'";
            }
            if (lokasiId != 0) {
                whereClause += " AND BM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " LIKE '%" + lokasiId + "%'";
            }
            if (kolektabilitasId != 0) {
                whereClause += " AND SKP." + PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KOLEKTIBILITAS_ID] + " LIKE '%" + kolektabilitasId + "%'";
            }
            total = SessKredit.getCountListKreditKolektabilitas(whereClause);
        } else if (dataFor.equals("listRiwayatKonsumen")) {
            whereClause += " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " IN ('" + Pinjaman.STATUS_DOC_CAIR + "','" + Pinjaman.STATUS_DOC_LUNAS + "','" + Pinjaman.STATUS_DOC_DIHAPUS + "','" + Pinjaman.STATUS_DOC_BATAL + "')"
                    + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + oidLocation;
            total = PstPinjaman.getCountJoinKreditSyncPOS(whereClause, PstBillMain.PETUGAS_DELIVERY_STATUS_DITERIMA);
        } else if (dataFor.equals("listDokumenKonsumen")) {
            String noKredit = FRMQueryString.requestString(request, "NO_KREDIT");
            long idLokasi = FRMQueryString.requestLong(request, "LOKASI_ID");
            long idNasabah = FRMQueryString.requestLong(request, "NASABAH_ID");
            
            if(!noKredit.equals("") && noKredit.length() > 0){
                whereClause += " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + noKredit + "%'";
            }
            
            if(idLokasi != 0){
                whereClause += " AND loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " = " + idLokasi;
            }
            
            if(idNasabah != 0){
                whereClause += " AND cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = " + idNasabah;
            }
            if (!privAccept && listUserGroup.isEmpty()) {
                whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                        +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
            }
            total = PstPinjaman.getCountJoinKredit(whereClause);
        }

        result.put("amount", amount);
        result.put("colName", colName);
        result.put("dir", dir);
        result.put("start", start);
        result.put("colOrder", col);

        try {
            result = getData(total, request, dataFor, addSql, result);
        } catch (Exception ex) {
            printErrorMessage(ex.getMessage());
        }

        return result;
    }

    public JSONObject getData(int total, HttpServletRequest request, String datafor, String addSql, JSONObject objValue) throws JSONException{
        int totalAfterFilter = total;
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        JenisKredit typeKredit = new JenisKredit();
        Anggota anggota = new Anggota();
        Pinjaman pinjaman = new Pinjaman();
        SumberDana sumberDana = new SumberDana();
        LogSysHistory history = new LogSysHistory();
        JenisTransaksi jenisTransaksi = new JenisTransaksi();

        String whereClause = "";
        String order = "";
        
        NumberFormat numberFormat = NumberFormat.getInstance(new Locale("id", "ID"));

        String searchTerm = objValue.optString("searchTerm","");
        SessUserSession userSession = getUserSession(request);
        int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_PENILAIAN_KREDIT);
        boolean privAccept = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ACCEPT));
        String userGroupAdmin = PstSystemProperty.getValueByName("GROUP_ADMIN_OID");
        String whereUserGroup = PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + "=" + userGroupAdmin
                + " AND " + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "=" + userSession.getAppUser().getOID();
        Vector listUserGroup = PstUserGroup.list(0, 0, whereUserGroup, "");
        
        String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
        String form_num = FRMQueryString.requestString(request, "form_num");
        String kredit_num = FRMQueryString.requestString(request, "kredit_num");
        String start_date = FRMQueryString.requestString(request, "startDate");
        String end_date = FRMQueryString.requestString(request, "endDate");
        String[] strList = request.getParameterValues("form_status");
        List<String> form_status = new ArrayList<>();
        if (strList != null) {
            form_status = Arrays.asList(strList);
        }
        String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");
        long oidKolektor = FRMQueryString.requestLong(request, FrmPinjaman.fieldNames[FrmPinjaman.FRM_COLLECTOR_ID]);
        int jenisReturn = FRMQueryString.requestInt(request, "JENIS_RETURN");
        String tglReturn = FRMQueryString.requestString(request, "TGL_RETURN");
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        long oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");
        String statusDoc = FRMQueryString.requestString(request, "SEND_STATUS_DOC");
        
        if (datafor.equals("listPinjamanAll")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_SUKU_BUNGA] + " LIKE '%" + searchTerm + "%'"
                        + ")";
                if (!privAccept && listUserGroup.isEmpty()) {
                    whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                            +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
                }
            } else {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_SUKU_BUNGA] + " LIKE '%" + searchTerm + "%'"
                        + " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        } else if (datafor.equals("listPinjamanFinal")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        //+ " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            } else {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        } else if (datafor.equals("listSearchKredit")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        //+ " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            } else {
                whereClause += "("
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
            boolean isSearchHapus = FRMQueryString.requestBoolean(request, "SEARCH_HAPUS");
            if (isSearchHapus){
                whereClause += " AND pinjaman."+PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]+" NOT IN (SELECT PINJAMAN_ID FROM sedana_hapus_kredit WHERE STATUS = 0)";
            }
        } else if (datafor.equals("listSearchReturn")) {
            whereClause += "("
                    + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    //+ " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                    + ")";

        } else if (datafor.equals("listHistory")) {
            whereClause += "("
                    + "" + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_ID] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_UPDATE_DATE] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_LOGIN_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_USER_ACTION] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (datafor.equals("listPencairan")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        //+ " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
                if (!privAccept && listUserGroup.isEmpty()) {
                    whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                            +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
                }
            } else {
                whereClause += "("
                        + "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        } else if (datafor.equals("listPenilaian")) {
            if (typeOfCredit.equals("1")) {
                whereClause += "("
                        + "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            } else {
                whereClause += "("
                        + "atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        } else if (datafor.equals("listAngsuran")) {
            whereClause += "("
                    + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (datafor.equals("listJenisTransaksi")) {
            whereClause += "("
                    + "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_PROSEDUR] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_INPUT_OPTION] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSENTASE_PERHITUNGAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_VALUE_STANDAR_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (datafor.equals("listTransaksiKredit")) {
            whereClause += "("
                    + "t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR t." + PstTransaksi.fieldNames[PstTransaksi.FLD_KETERANGAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR t." + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " LIKE '%" + searchTerm + "%'"
                    + " OR p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR a." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (datafor.equals("listReturn")) {
            whereClause += "("
                    + "r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN] + " LIKE '%" + searchTerm + "%'"
                    + " OR r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN] + " LIKE '%" + searchTerm + "%'"
                    + " OR con." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS] + " LIKE '%" + searchTerm + "%'"
                    + ")";
            if (form_num != null && form_num.length() > 0) {
                whereClause += " AND r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN] + "='" + form_num + "'";
            }
            if (kredit_num != null && kredit_num.length() > 0) {
                whereClause += " AND p."+ PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + "='" + kredit_num + "'";
            }
            if ((start_date != null && start_date.length() > 0) && (end_date != null && end_date.length() > 0)) {
                whereClause += " AND ("
                        + "(r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN] + ""
                        + ">= '" + start_date + "') AND "
                        + "(r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN] + ""
                        + "<= '" + end_date + "')"
                        + ")";
            }
            if (strList != null){
                String inStatus = "";
                for (int i = 0; i < strList.length; i++){
                    if (inStatus.length()>0){
                        inStatus += ","+strList[i];
                    } else {
                        inStatus += strList[i];
                    }
                }
                whereClause += " AND r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS] + " IN ("+inStatus+")";
            }
        } else if (datafor.equals("listHapus")) {
            whereClause += "("
                    + "h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_NOMOR_HAPUS] + " LIKE '%" + searchTerm + "%'"
                    + " OR h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_TANGGAL_HAPUS] + " LIKE '%" + searchTerm + "%'"
                    + " OR con." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_CATATAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_STATUS] + " LIKE '%" + searchTerm + "%'"
                    + ")";
            if (form_num != null && form_num.length() > 0) {
                whereClause += " AND h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_NOMOR_HAPUS] + "='" + form_num + "'";
            }
            if (kredit_num != null && kredit_num.length() > 0) {
                whereClause += " AND p."+ PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + "='" + kredit_num + "'";
            }
            if ((start_date != null && start_date.length() > 0) && (end_date != null && end_date.length() > 0)) {
                whereClause += " AND ("
                        + "(h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_TANGGAL_HAPUS] + ""
                        + ">= '" + start_date + " 00:00:00') AND "
                        + "(h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_TANGGAL_HAPUS] + ""
                        + "<= '" + end_date + " 23:59:00')"
                        + ")";
            }
            if (strList != null){
                String inStatus = "";
                for (int i = 0; i < strList.length; i++){
                    if (inStatus.length()>0){
                        inStatus += ","+strList[i];
                    } else {
                        inStatus += strList[i];
                    }
                }
                whereClause += " AND h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_STATUS] + " IN ("+inStatus+")";
            }
        } else if (datafor.equals("listKreditKolektabilitas")) {
            whereClause = " ( AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR CL." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (datafor.equals("listRiwayatKonsumen")) {
            whereClause = "("
                        + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_SUKU_BUNGA] + " LIKE '%" + searchTerm + "%'"
                        + ")";
        } else if (datafor.equals("listDokumenKonsumen")) {
            whereClause = "("
                        + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR atk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR loc." + PstLocation.fieldNames[PstLocation.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_SUKU_BUNGA] + " LIKE '%" + searchTerm + "%'"
                        + ")";
        }

        if (objValue.optInt("colOrder",0) >= 0) {
            order += "" + objValue.optString("colName","") + " " + objValue.optString("dir","") + "";
        }

        Vector listData = new Vector(1, 1);
        if (datafor.equals("listPinjamanFinal")) {
            if (typeOfCredit.equals("1")) {
                whereClause += " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "' ";
                if(oidKolektor != 0){
                    whereClause += " AND (pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + oidKolektor + " OR "
                            + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " = " + oidKolektor+")";
                }
                if (userSession.getAppUser().getAssignLocationId() != 0) {
                    whereClause += " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId();
                }
                listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause, order);
            } else {
                listData = PstPinjaman.listJoinPinjaman(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'", order);
            }
        } else if (datafor.equals("listSearchKredit")) {
            
            Vector listLocation = PstLocation.getListFromApiAll();
            String inLocation = "";
            for (int i = 0; i < listLocation.size(); i++) {
                Location loc = (Location) listLocation.get(i);
                boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+loc.getOID());
                if (loc.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
                    if (inLocation.length()>0){
                      inLocation += ","  ;
                    } 
                    inLocation += ""+loc.getOID();
                }
            }
            
            if (inLocation.length()>0) {
                if (userSession.getAppUser().getAssignLocationId() != 0) {
                    listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "' AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " IN (" + inLocation+")", order);
                } else {
                    listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'", order);
                }
            } else {
                listData = PstPinjaman.listJoinPinjaman(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'", order);
            }
        } else if (datafor.equals("listSearchReturn")) {
            if (jenisReturn == ReturnKredit.JENIS_RETURN_CABUTAN){
                whereClause += " AND (MONTH(pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]+") != MONTH('"+tglReturn+"') OR YEAR(pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]+") != YEAR('"+tglReturn+"'))";
            } else {
                whereClause += " AND MONTH(pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]+") = MONTH('"+tglReturn+"') AND YEAR(pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI]+") = YEAR('"+tglReturn+"')";
            }
            whereClause += " AND pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]+" NOT IN (SELECT PINJAMAN_ID FROM sedana_return_kredit WHERE STATUS=0)";
            if (userSession.getAppUser().getAssignLocationId() != 0) {
                listData = PstPinjaman.listJoinReturn(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "' AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId(), order);
            } else {
                listData = PstPinjaman.listJoinReturn(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'", order);
            }

        } else if (datafor.equals("listHistory")) {
            listData = SessHistory.listHistory(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DOCUMENT_ID] + " = '" + oid + "'", order);
        } else if (datafor.equals("listPencairan")) {
            order = "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + ",pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " DESC";
            if (typeOfCredit.equals("1")) {
                if (userSession.getAppUser().getAssignLocationId() != 0) {
                    listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND (" + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_APPROVED + "' OR " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "') AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId(), order);
                } else {
                    listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND (" + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_APPROVED + "' OR " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "')", order);
                }
            } else {
                listData = PstPinjaman.listJoinPinjaman(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND (" + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_APPROVED + "' OR " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "')", order);
            }
        } else if (datafor.equals("listPenilaian")) {
            if (typeOfCredit.equals("1")) {
//                if(this.privPosAnalis){
//                    whereClause += " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " = " + this.oidEmployeeUser;
//                }
                if (!privAccept && listUserGroup.isEmpty()) {
                    whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                            +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
                }
                whereClause += " AND ("
                        + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_TO_BE_APPROVE + "'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_APPROVED + "'"
                        + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'"
                        + ")";
                if (oidLocation != 0) {
                    whereClause += " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + oidLocation;
                }
                //order = PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] +" ASC"; 
                listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause, order);
            } else {
                listData = PstPinjaman.listJoinPinjaman(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_TO_BE_APPROVE + "'", order);
            }
        } else if (datafor.equals("listAngsuran")) {
            listData = PstPinjaman.listJoinPinjaman(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'", order);
        } else if (datafor.equals("listPinjamanAll")) {
            
            Vector listLocation = PstLocation.getListFromApiAll();
            String inLocation = "";
            for (int i = 0; i < listLocation.size(); i++) {
                Location loc = (Location) listLocation.get(i);
                boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+loc.getOID());
                if (loc.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
                    if (inLocation.length()>0){
                      inLocation += ","  ;
                    } 
                    inLocation += ""+loc.getOID();
                }
            }
            
            if (statusDoc.equals("all")) {
                if (typeOfCredit.equals("1")) {
                    if (inLocation.length()>0) {
                        listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " IN (" + inLocation+")", order);
                    } else {
                        listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause, order);
                    }
                } else {
                    listData = PstPinjaman.listJoinPinjaman(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause, order);
                }
            } else {
                if (typeOfCredit.equals("1")) {
                    if (inLocation.length()>0) {
                        listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + statusDoc + "' AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " IN (" + inLocation +")", order);
                    } else {
                        listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + statusDoc + "'", order);
                    }
                } else {
                    listData = PstPinjaman.listJoinPinjaman(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + statusDoc + "'", order);
                }
            }
        } else if (datafor.equals("listJenisTransaksi")) {
            listData = PstJenisTransaksi.list(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause, order);
        } else if (datafor.equals("listTransaksiKredit")) {
            if (userSession.getAppUser().getAssignLocationId() != 0) {
                listData = SessKredit.getListTransaksiKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + addSql + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId() + " GROUP BY t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID], order);
            } else {
                listData = SessKredit.getListTransaksiKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + addSql + " GROUP BY t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID], order);
            }
        } else if (datafor.equals("listReturn")) {
            if (userSession.getAppUser().getAssignLocationId() != 0) {
                listData = SessKredit.getListReturn(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId() + " GROUP BY r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID], order);
            } else {
                listData = SessKredit.getListReturn(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " GROUP BY r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID], order);
            }
        } else if (datafor.equals("listHapus")) {
            Vector listLocation = PstLocation.getListFromApiAll();
            String inLocation = "";
            for (int i = 0; i < listLocation.size(); i++) {
                Location loc = (Location) listLocation.get(i);
                boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+loc.getOID());
                if (loc.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
                    if (inLocation.length()>0){
                      inLocation += ","  ;
                    } 
                    inLocation += ""+loc.getOID();
                }
            }
            listData = SessKredit.getListHapus(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " IN (" + inLocation + ") GROUP BY h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_HAPUS_ID], order);
//            if (userSession.getAppUser().getAssignLocationId() != 0) {
//                listData = SessKredit.getListHapus(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId() + " GROUP BY r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID], order);
//            } else {
//                listData = SessKredit.getListHapus(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause + " GROUP BY r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID], order);
//            }
        } else if (datafor.equals("listKreditKolektabilitas")) {
            String noKredit = FRMQueryString.requestString(request, "NO_KREDIT");
            long lokasiId = FRMQueryString.requestLong(request, "LOKASI_ID");
            long kolektabilitasId = FRMQueryString.requestLong(request, "KOLEKTABILITAS_ID");

            whereClause += " AND AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "' ";
            if (noKredit != null && noKredit.length() > 0) {
                whereClause += " AND AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + noKredit + "%'";
            }
            if (lokasiId != 0) {
                whereClause += " AND BM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " LIKE '%" + lokasiId + "%'";
            }
            if (kolektabilitasId != 0) {
                whereClause += " AND SKP." + PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KOLEKTIBILITAS_ID] + " LIKE '%" + kolektabilitasId + "%'";
            }
            listData = SessKredit.getListKreditKolektabilitas(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause, order);
        } else if (datafor.equals("listRiwayatKonsumen")) {
            whereClause += " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " IN ('" + Pinjaman.STATUS_DOC_CAIR + "','" + Pinjaman.STATUS_DOC_LUNAS + "','" + Pinjaman.STATUS_DOC_DIHAPUS + "','" + Pinjaman.STATUS_DOC_BATAL + "')"
                    + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + oidLocation;
            listData = PstPinjaman.listJoinKreditSyncPOS(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause, order, PstBillMain.PETUGAS_DELIVERY_STATUS_DITERIMA);
        } else if (datafor.equals("listDokumenKonsumen")) {
            String noKredit = FRMQueryString.requestString(request, "NO_KREDIT");
            long idLokasi = FRMQueryString.requestLong(request, "LOKASI_ID");
            long idNasabah = FRMQueryString.requestLong(request, "NASABAH_ID");
            
            if(!noKredit.equals("") && noKredit.length() > 0){
                whereClause += " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + noKredit + "%'";
            }
            
            if(idLokasi != 0){
                whereClause += " AND loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " = " + idLokasi;
            }
            
            if(idNasabah != 0){
                whereClause += " AND cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = " + idNasabah;
            }
            if (!privAccept && listUserGroup.isEmpty()) {
                whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                        +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
            }
            listData = PstPinjaman.listJoinKredit(objValue.optInt("start",0), objValue.optInt("amount",0), whereClause, order);
        }

        String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        boolean privApprove = FRMQueryString.requestBoolean(request, "privApprove");
        for (int i = 0; i <= listData.size() - 1; i++) {
            JSONArray ja = new JSONArray();
            if (datafor.equals("listPinjamanFinal")) {
                pinjaman = (Pinjaman) listData.get(i);
                BillMain bm = new BillMain();
                Location loc = new Location();
                int status = 0;
                try {
                    typeKredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                    bm = PstBillMain.fetchExc(pinjaman.getBillMainId());
                    loc = PstLocation.fetchExc(bm.getLocationId());
                    if (typeOfCredit.equals("0")) {
                        sumberDana = PstSumberDana.fetchExc(pinjaman.getSumberDanaId());
                    }
                    String url = posApiUrl + "/bill/billmain/check-production/" + bm.getOID();
                    JSONObject apiRes = WebServices.getAPI("", url);
                    status = apiRes.optInt("STATUS", 0);

                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                    objValue.put("RETURN_MESSAGE", e.toString());
                }
                //if (status == PstBillMain.PETUGAS_DELIVERY_STATUS_DITERIMA || status == PstBillMain.PETUGAS_DELIVERY_STATUS_DIKIRIM) {
                    ja.put("" + (objValue.optInt("start",0) + i + 1) + ".");
                    if (status == PstBillMain.PETUGAS_DELIVERY_STATUS_DITERIMA || status == PstBillMain.PETUGAS_DELIVERY_STATUS_DIKIRIM || status == PstBillMain.PETUGAS_DELIVERY_STATUS_DIAMBIL_LANGSUNG) {
                        ja.put("<a href='#' class='btn-actionkredit' data-oid='" + pinjaman.getOID() + "'>" + pinjaman.getNoKredit() + "</a>");
                    } else {
                        ja.put("" + pinjaman.getNoKredit());
                    }
                    ja.put("" + anggota.getName());
                    ja.put("" + typeKredit.getNameKredit());
                    ja.put("<div class='money text-right'>" + pinjaman.getJumlahPinjaman() + "</div>");
                    ja.put("" + loc.getName());
                    ja.put("<div class='text-center'>" + pinjaman.getTglPengajuan() + "</div>");
                    //ja.put("" + sumberDana.getKodeSumberDana() + " - " + sumberDana.getJudulSumberDana());
                    ja.put("<div class='text-center'>" + pinjaman.getTglRealisasi() + "</div>");
                    ja.put("<div class='text-center'>" + PstBillMain.produksiDeliveryStatus[status] + "</div>");
                    if (status == PstBillMain.PETUGAS_DELIVERY_STATUS_DITERIMA || status == PstBillMain.PETUGAS_DELIVERY_STATUS_DIKIRIM || status == PstBillMain.PETUGAS_DELIVERY_STATUS_DIAMBIL_LANGSUNG) {
                        ja.put("<div class='text-center'><button type='button' title='Aksi' class='btn btn-xs btn-warning btn-actionkredit' data-oid='" + pinjaman.getOID() + "'>Pilih</button></div>");
                    } else {
                        ja.put("");
                    }
                    array.put(ja);
                //}
//                ja.put("" + (this.start + i + 1) + ".");
//                ja.put("<a href='#' class='btn-actionkredit' data-oid='" + pinjaman.getOID() + "'>" + pinjaman.getNoKredit() + "</a>");
//                ja.put("" + anggota.getName());
//                ja.put("" + typeKredit.getNameKredit());
//                ja.put("<div class='money text-right'>" + pinjaman.getJumlahPinjaman() + "</div>");
//                ja.put("" + loc.getName());
//                ja.put("<div class='text-center'>" + pinjaman.getTglPengajuan() + "</div>");
//                //ja.put("" + sumberDana.getKodeSumberDana() + " - " + sumberDana.getJudulSumberDana());
//                ja.put("<div class='text-center'>" + pinjaman.getTglRealisasi() + "</div>");
//                ja.put("<div class='text-center'><button type='button' title='Aksi' class='btn btn-xs btn-warning btn-actionkredit' data-oid='" + pinjaman.getOID() + "'>Pilih</button></div>");
//                array.put(ja);

            } else if (datafor.equals("listSearchKredit")) {
                pinjaman = (Pinjaman) listData.get(i);
                BillMain bm = new BillMain();
                Location loc = new Location();
                try {
                    typeKredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                    bm = PstBillMain.fetchExc(pinjaman.getBillMainId());
                    loc = PstLocation.fetchExc(bm.getLocationId());
                    if (typeOfCredit.equals("0")) {
                        sumberDana = PstSumberDana.fetchExc(pinjaman.getSumberDanaId());
                    }
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                    objValue.put("RETURN_MESSAGE", e.toString());
                }
                ja.put("" + (objValue.optInt("start",0) + i + 1) + ".");
                ja.put("<a href='#' class='btn-actionkredit' data-oid='" + pinjaman.getOID() + "'>" + pinjaman.getNoKredit() + "</a>");
                ja.put("" + anggota.getName());
                ja.put("" + typeKredit.getNameKredit());
                ja.put("<div class='money text-right'>" + pinjaman.getJumlahPinjaman() + "</div>");
                ja.put("" + loc.getName());
                ja.put("<div class='text-center'>" + pinjaman.getTglPengajuan() + "</div>");
                ja.put("<div class='text-center'>" + pinjaman.getTglRealisasi() + "</div>");
                ja.put("<div class='text-center'><button type='button' title='Aksi' class='btn btn-xs btn-warning btn-actionkredit' data-oid='" + pinjaman.getOID() + "'>Pilih</button></div>");
                array.put(ja);

            } else if (datafor.equals("listSearchReturn")) {
                pinjaman = (Pinjaman) listData.get(i);
                BillMain bm = new BillMain();
                Location loc = new Location();
                try {
                    typeKredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                    bm = PstBillMain.fetchExc(pinjaman.getBillMainId());
                    loc = PstLocation.fetchExc(bm.getLocationId());
                    if (typeOfCredit.equals("0")) {
                        sumberDana = PstSumberDana.fetchExc(pinjaman.getSumberDanaId());
                    }
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                    objValue.put("RETURN_MESSAGE", e.toString());
                }
                ja.put("" + (objValue.optInt("start",0)  + i + 1) + ".");
                ja.put("<a href='#' class='btn-actionkredit' data-oid='" + pinjaman.getOID() + "'>" + pinjaman.getNoKredit() + "</a>");
                ja.put("" + anggota.getName());
                ja.put("" + typeKredit.getNameKredit());
                ja.put("<div class='money text-right'>" + pinjaman.getJumlahPinjaman() + "</div>");
                ja.put("" + loc.getName());
                ja.put("<div class='text-center'>" + pinjaman.getTglPengajuan() + "</div>");
                ja.put("<div class='text-center'>" + pinjaman.getTglRealisasi() + "</div>");
                ja.put("<div class='text-center'><button type='button' title='Aksi' class='btn btn-xs btn-warning btn-actionkredit' data-oid='" + pinjaman.getOID() + "'>Pilih</button></div>");
                array.put(ja);

            } else if (datafor.equals("listHistory")) {
                history = (LogSysHistory) listData.get(i);
                ja.put("" + (objValue.optInt("start",0)  + i + 1) + ".");
                ja.put("<div style='white-space: nowrap'>" + Formater.formatDate(history.getLogUpdateDate(), "yyyy-MM-dd HH:mm:ss") + "</div>");
                ja.put("<div style='white-space: nowrap'>" + history.getLogLoginName());
                ja.put("<div style='white-space: nowrap'>" + history.getLogUserAction());
                ja.put("" + history.getLogDetail());
                array.put(ja);
            } else if (datafor.equals("listPencairan")) {
                pinjaman = (Pinjaman) listData.get(i);
                BillMain bm = new BillMain();
                Location loc = new Location();
                try {
                    typeKredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                    bm = PstBillMain.fetchExc(pinjaman.getBillMainId());
                    loc = PstLocation.fetchExc(bm.getLocationId());
                    if (typeOfCredit.equals("0")) {
                        sumberDana = PstSumberDana.fetchExc(pinjaman.getSumberDanaId());
                    }
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                    objValue.put("RETURN_MESSAGE", e.toString());
                }
                ja.put("" + (objValue.optInt("start",0)  + i + 1) + ".");
                //ja.put("" + pinjaman.getNoKredit());
                ja.put("<a href='../transaksikredit/transaksi_kredit.jsp?pinjaman_id=" + pinjaman.getOID() + "&command=" + Command.EDIT + "'>" + pinjaman.getNoKredit() + "</a>");
                ja.put("" + anggota.getName());
                ja.put("" + typeKredit.getNameKredit());
                ja.put("<div class='money text-right'>" + pinjaman.getJumlahPinjaman() + "</div>");
                ja.put("" + loc.getName());
                ja.put("" + pinjaman.getTglPengajuan());
                ja.put("" + Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman()));
                //ja.put("" + sumberDana.getKodeSumberDana() + " - " + sumberDana.getJudulSumberDana());
                String showButton = "";
                String btnSettingDetail = "";
                String btnDokumen = "";
                if (useForRaditya.equals("1")) {
                    btnSettingDetail = "<div style='margin-bottom: 3px;'><button type='button' title='Detail kredit' class='btn btn-xs btn-warning btn-pencairan' data-oid='" + pinjaman.getOID() + "'><i class='fa fa-pencil'></i></button></div>";
                    btnDokumen = "<button type='button' title='Dokumen kredit' class='btn btn-xs btn-primary btn-dokumen' data-oid='" + pinjaman.getOID() + "' data-type='pk'><i class='fa fa-file'></i></button>";
                } else {
                    btnSettingDetail = "<div style='margin-bottom: 3px;'><button type='button' title='Detail kredit' class='btn btn-xs btn-warning btn-pencairan' data-oid='" + pinjaman.getOID() + "'>Pencairan</button></div>";
                    btnDokumen = "<button type='button' title='Dokumen kredit' class='btn btn-xs btn-primary btn-dokumen' data-oid='" + pinjaman.getOID() + "' data-type='pk'>Dokumen</button>";
                }
                String btnCair = "<button type='button' title='Cairkan kredit' class='btn btn-xs btn-warning btn-cair' data-oid='" + pinjaman.getOID() + "'>Cair</button> ";
                if (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED) {
                    showButton += btnSettingDetail;
                }
                if (pinjaman.getStatusPinjaman() >= Pinjaman.STATUS_DOC_APPROVED) {
                    showButton += " " + btnDokumen;
                }
                ja.put("<div class='text-center'>" + showButton + "</div>");
                array.put(ja);
            } else if (datafor.equals("listPenilaian")) {
                pinjaman = (Pinjaman) listData.get(i);
                try {
                    typeKredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                    if (typeOfCredit.equals("0")) {
                        sumberDana = PstSumberDana.fetchExc(pinjaman.getSumberDanaId());
                    }
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                    objValue.put("RETURN_MESSAGE", e.toString());
                }
                ja.put("" + (objValue.optInt("start",0)  + i + 1) + ".");
                //ja.put("" + pinjaman.getNoKredit());
                ja.put("<a href='../transaksikredit/transaksi_kredit.jsp?pinjaman_id=" + pinjaman.getOID() + "&command=" + Command.EDIT + "'>" + pinjaman.getNoKredit() + "</a>");
                ja.put("" + anggota.getName());
                ja.put("" + typeKredit.getNameKredit());
                ja.put("<div class='money text-right'>" + pinjaman.getJumlahPinjaman() + "</div>");
                ja.put("<div class='text-center'>" + pinjaman.getTglPengajuan() + "</div>");
                //ja.put("" + sumberDana.getKodeSumberDana() + " - " + sumberDana.getJudulSumberDana());
                ja.put("<div class='text-center'>" + Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman()) + "</div>");
                ja.put("<div class='text-center'>"
                        + "<button type='button' title='Aksi' class='btn btn-xs btn-warning btn-actionkredit' data-oid='" + pinjaman.getOID() + "'><i class='fa fa-pencil'></i></button>"
                        + "\t"
                        + "<button type='button' title='History' class='btn btn-xs btn-info btn-showhistory' data-oid='" + pinjaman.getOID() + "'><i class='fa fa-file-text'></i></button>"
                        + "</div>");
                array.put(ja);
            } else if (datafor.equals("listAngsuran")) {
                pinjaman = (Pinjaman) listData.get(i);
                try {
                    typeKredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                    if (typeOfCredit.equals("0")) {
                        sumberDana = PstSumberDana.fetchExc(pinjaman.getSumberDanaId());
                    }
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                    objValue.put("RETURN_MESSAGE", e.toString());
                }
                ja.put("" + (objValue.optInt("start",0)  + i + 1) + ".");
                ja.put("" + pinjaman.getNoKredit());
                ja.put("" + anggota.getName());
                ja.put("" + typeKredit.getNameKredit());
                ja.put("" + pinjaman.getTglPengajuan());
                ja.put("" + Formater.formatNumber(pinjaman.getJumlahPinjaman(), "#,###"));
                ja.put("" + pinjaman.getTglRealisasi());
                array.put(ja);
            } else if (datafor.equals("listPinjamanAll")) {
                pinjaman = (Pinjaman) listData.get(i);
                AppUser user = new AppUser();
                BillMain bm = new BillMain();
                Location loc = new Location();
                try {
                    typeKredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                    bm = PstBillMain.fetchExc(pinjaman.getBillMainId());
                    loc = PstLocation.fetchExc(bm.getLocationId());
                    if (typeOfCredit.equals("0")) {
                        sumberDana = PstSumberDana.fetchExc(pinjaman.getSumberDanaId());
                    }
                    long userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
                    user = PstAppUser.fetch(userId);
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                    objValue.put("RETURN_MESSAGE", e.toString());
                }
                ja.put("" + (objValue.optInt("start",0)  + i + 1) + ".");
                //ja.put("" + pinjaman.getNoKredit());
                ja.put("<a href='../transaksikredit/transaksi_kredit.jsp?pinjaman_id=" + pinjaman.getOID() + "&command=" + Command.EDIT + "'>" + pinjaman.getNoKredit() + "</a>");
                ja.put("" + anggota.getName());
                ja.put("" + typeKredit.getNameKredit());
                ja.put("<div class='money text-right'>" + pinjaman.getJumlahPinjaman() + "</div>");
                ja.put("" + loc.getName());
                //ja.put("<div class='text-right'>" + pinjaman.getSukuBunga() + " %</div>");
                ja.put("" + pinjaman.getTglPengajuan());
                //ja.put("" + sumberDana.getKodeSumberDana() + " - " + sumberDana.getJudulSumberDana());
                ja.put("" + Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman()));
                if (pinjaman.getStatusPinjaman() == 0) {
                    String btnCair = "";
                    if (user.getGroupUser() == AppUser.USER_GROUP_HO_STAFF) {
                        //btnCair = "\t<button type='button' title='Cairkan kredit' class='btn btn-xs btn-warning btn-cair' data-oid='" + pinjaman.getOID() + "'>Langsung Cair</button>";
                    }
                    ja.put("<div class='text-center'>"
                            + "<button type='button' title='Ubah data' class='btn btn-xs btn-warning btn-detailkredit' data-oid='" + pinjaman.getOID() + "'><i class='fa fa-pencil'></i></button>"
                            + "\t"
                            + "<button type='button' title='Kirim pengajuan' class='btn btn-xs btn-success btn-sendkredit' data-oid='" + pinjaman.getOID() + "'><i class='fa fa-share'></i></button>"
                            + btnCair
                            + "</div>");
                } else {
                    ja.put("<div class='text-center'><button type='button' title='Detail' class='btn btn-xs btn-info btn-detailkredit' data-oid='" + pinjaman.getOID() + "'><i class='fa fa-file-text'></i></button></div>");
                }
                array.put(ja);
            } else if (datafor.equals("listJenisTransaksi")) {
                jenisTransaksi = (JenisTransaksi) listData.get(i);
                Vector<JenisTransaksiMapping> listMap = PstJenisTransaksiMapping.list(0, 0, "" + PstJenisTransaksiMapping.fieldNames[PstJenisTransaksiMapping.FLD_JENIS_TRANSAKSI_ID] + " = '" + jenisTransaksi.getOID() + "'", "");
                String mapping = "";
                for (int j = 0; j < listMap.size(); j++) {
                    long idJs = listMap.get(j).getIdJenisSimpanan();
                    JenisSimpanan jenisSimpanan = new JenisSimpanan();
                    try {
                        jenisSimpanan = PstJenisSimpanan.fetchExc(idJs);
                    } catch (Exception e) {
                        printErrorMessage(e.getMessage());
                    }
                    if (j == 0) {
                        mapping += "" + jenisSimpanan.getNamaSimpanan() + "";
                    } else {
                        mapping += ", " + "" + jenisSimpanan.getNamaSimpanan() + "";
                    }
                }
                ja.put("" + (objValue.optInt("start",0)  + i + 1) + ".");
                ja.put("" + jenisTransaksi.getJenisTransaksi());
                ja.put("" + JenisTransaksi.TUJUAN_PROSEDUR_TITLE[jenisTransaksi.getProsedureUntuk()]);
                ja.put("" + JenisTransaksi.TIPE_ARUS_KAS_TITLE[jenisTransaksi.getTipeArusKas()]);
                ja.put("" + JenisTransaksi.TIPE_TRANSAKSI_TITLE[jenisTransaksi.getTypeTransaksi()]);
                ja.put("" + JenisTransaksi.TIPE_PROSEDUR_TITLE[jenisTransaksi.getTypeProsedur()]);
                ja.put("" + JenisTransaksi.TIPE_DOC_TITLE[jenisTransaksi.getTipeDoc()]);
                ja.put("" + JenisTransaksi.TIPE_DOC_INPUT_TITLE[jenisTransaksi.getInputOption()]);
                ja.put("<div class='money'>" + jenisTransaksi.getProsentasePerhitungan() + "</div>");
                ja.put("<div class='money'>" + jenisTransaksi.getValueStandarTransaksi() + "</div>");
                ja.put("" + mapping);
                ja.put("" + JenisTransaksi.STATUS_JENIS_TRANSAKSI_TITLE[jenisTransaksi.getStatusAktif()]);
                ja.put("<button type='button' class='btn btn-xs btn-warning btn_edit' data-oid='" + jenisTransaksi.getOID() + "'><i class='fa fa-pencil'></i></button>");
                array.put(ja);
            } else if (datafor.equals("listTransaksiKredit")) {
                Transaksi t = (Transaksi) listData.get(i);
                Pinjaman p = new Pinjaman();
                Anggota a = new Anggota();
                BillMain bm = new BillMain();
                Location loc = new Location();
                AppUser u = new AppUser();

                try {
                    p = PstPinjaman.fetchExc(t.getPinjamanId());
                    a = PstAnggota.fetchExc(p.getAnggotaId());
                    bm = PstBillMain.fetchExc(p.getBillMainId());
                    loc = PstLocation.fetchExc(bm.getLocationId());
                    u = PstAppUser.fetch(t.getAppUserId());
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                }
                //cari nilai transaksi
                double nilaiTransaksi = 0;
                switch (t.getUsecaseType()) {
                    case Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN:
                        Vector<DetailTransaksi> listBiaya = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = '" + t.getOID() + "'", null);
                        double biaya = 0;
                        for (DetailTransaksi d : listBiaya) {
                            biaya += d.getDebet();
                        }
                        double pengendapan = p.getWajibValueType() == Pinjaman.WAJIB_VALUE_TYPE_PERSEN ? p.getJumlahPinjaman() * p.getWajibValue() / 100 : p.getWajibValue();
                        nilaiTransaksi = p.getJumlahPinjaman() - biaya - pengendapan;
                        break;

                    case Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT:
                        Vector<Angsuran> listAngsuran = PstAngsuran.list(0, 0, "" + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = '" + t.getOID() + "'", "");
                        for (int j = 0; j < listAngsuran.size(); j++) {
                            nilaiTransaksi += (listAngsuran.get(j).getJumlahAngsuran() - listAngsuran.get(j).getDiscAmount());
                        }
                        break;

                    case Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN:
                    case Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN:
                    case Transaksi.USECASE_TYPE_KREDIT_PENALTY_DINI_PENCATATAN:
                    case Transaksi.USECASE_TYPE_KREDIT_PENALTY_MACET_PENCATATAN:
                        Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = '" + t.getOID() + "'", null);
                        for (JadwalAngsuran j : listJadwal) {
                            nilaiTransaksi += j.getJumlahANgsuran();
                        }
                        break;

                    case Transaksi.USECASE_TYPE_TABUNGAN_SETORAN:
                    case Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN:
                    case Transaksi.USECASE_TYPE_TABUNGAN_PENUTUPAN:
                        Vector<DetailTransaksi> listDetail = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = '" + t.getOID() + "'", null);
                        for (DetailTransaksi d : listDetail) {
                            nilaiTransaksi += d.getDebet();
                            nilaiTransaksi += d.getKredit();
                        }
                        break;
                }
                
                String status = Transaksi.STATUS_DOC_TRANSAKSI_TITLE[t.getStatus()].toUpperCase();
                if (t.getStatus() == Transaksi.STATUS_DOC_TRANSAKSI_POSTED) {
                    status = "<span style='color: red'>" + status + "</span>";
                }

                String whereClauseBiaya = PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_PARENT_ID] + " = " + t.getOID() 
                        + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = " + I_Sedana.USECASE_TYPE_KREDIT_BIAYA;
                Vector<Transaksi> listTransaksiBiaya = PstTransaksi.list(0, 0, whereClauseBiaya, "");
                for(Transaksi tBiaya : listTransaksiBiaya){
                    whereClauseBiaya = PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + tBiaya.getOID(); 
                    Vector<DetailTransaksi> listDetailTransaksi = PstDetailTransaksi.list(0, 0, whereClauseBiaya, "");
                    for(DetailTransaksi dt : listDetailTransaksi){
                        nilaiTransaksi += dt.getDebet();
                    }
                }
                
                ja.put("" + (objValue.optInt("start",0)  + i + 1) + ".");
                ja.put("" + Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss"));
                ja.put("" + t.getKeterangan());
                ja.put("<a class='btn_detail' data-oid='" + t.getOID() + "'>" + t.getKodeBuktiTransaksi() + "</a>");
                ja.put("" + a.getName());
                ja.put("<div class='text-center'>" + loc.getName() + "</div>");
                ja.put("<div class='text-center'><a href='../transaksikredit/transaksi_kredit.jsp?pinjaman_id=" + p.getOID() + "&command=" + Command.EDIT + "'>" + p.getNoKredit() + "</a></div>");
                ja.put("<div class='text-right money'>" + nilaiTransaksi + "</div>");
                ja.put("<div class='text-center'>" + u.getFullName() + "</div>");
                ja.put("<div class='text-center'>" + status + "</div>");
                
                String btnApproval = "";
                if (t.getStatus() == Transaksi.STATUS_DOC_TRANSAKSI_OPEN) {
                    objValue.put("RETURN_DATA_OPEN_TRANSACTION", objValue.optInt("RETURN_DATA_OPEN_TRANSACTION",0)+1);
                    if (privApprove) {
                        btnApproval = "<input type='checkbox' class='flat-green tutup-transaksi' name='MULTI_TRANSAKSI_ID' value='" + t.getOID() + "'>";
                    } else {
                        btnApproval = "<span class='text-red text-bold' data-toggle='tooltip' data-placement='top' title='Akses Ditolak'>&times;</span>";
                    }
                }
                ja.put("<div class='check-transaksi text-center'>" + btnApproval + "</div>");
                //ja.put("<a class='btn btn-xs btn-link btn_detail' data-oid='" + t.getOID() + "'>Detail</a>");
                array.put(ja);
                if ((objValue.optInt("start",0)  + i + 1) == totalAfterFilter){
                    double totalTransaksi = 0;
                    if (userSession.getAppUser().getAssignLocationId() != 0) {
                        totalTransaksi = SessKredit.getSumTransaksi(whereClause + addSql + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + userSession.getAppUser().getAssignLocationId());
                    } else {
                        totalTransaksi = SessKredit.getSumTransaksi(whereClause + addSql);
                    }
                    //double totalTransaksi = SessKredit.getSumTransaksi(whereClause);
                    ja = new JSONArray();
                    ja.put("");
                    ja.put("");
                    ja.put("");
                    ja.put("");
                    ja.put("");
                    ja.put("");
                    ja.put("<b>TOTAL</b>");
                    ja.put("<b><div class='text-right money'>"+totalTransaksi+"</div></b>");
                    ja.put("");
                    ja.put("");
                    ja.put("");
                    array.put(ja);
                }
            } else if (datafor.equals("listReturn")) {
                Vector temp = (Vector) listData.get(i);
                ReturnKredit ret = (ReturnKredit) temp.get(0);
                ContactList con = (ContactList) temp.get(1);
                long oidReturn = ret.getOID();
                long oidPinjaman = ret.getPinjamanId();
                String status = "-";
                if (ret.getStatus() == ReturnKredit.STATUS_RETURN_DRAFT) {
                    status = "Draft";
                } else if (ret.getStatus() == ReturnKredit.DOCUMENT_STATUS_POSTED) {
                    status = "Posted";
                } else if (ret.getStatus() == ReturnKredit.DOCUMENT_STATUS_CANCELLED) {
                    status = "Cancel";
                } else if (ret.getStatus() == ReturnKredit.STATUS_RETURN_RETURN) {
                    status = "Closed";
                } 

                ja.put("<div class='text-center'>" + (objValue.optInt("start",0)  + i + 1) + "</div>");
                ja.put("<div class='text-center'>" + ret.getNomorReturn() + "</div>");
                ja.put("<div class='text-center'>" + Formater.formatDate(ret.getTanggalReturn(), "yyyy-MM-dd") + "</div>");
                ja.put("<div class='text-center'>" + con.getPersonName() + "</div>");
                ja.put("<div class='text-center'>" + ret.getCatatan() + "</div>");
                ja.put("<div class='text-center'>" + status + "</div>");
                ja.put("<div class='text-center'><a href='../transaksikredit/return_kredit.jsp?PINJAMAN_ID=" + oidPinjaman + "&command=" + Command.EDIT + "&RETURN_KREDIT_ID=" + oidReturn + "' class='btn btn-warning'><i class='fa fa-pencil'></i></a></div>");
                array.put(ja);
            } else if (datafor.equals("listHapus")) {
                Vector temp = (Vector) listData.get(i);
                HapusKredit hap = (HapusKredit) temp.get(0);
                ContactList con = (ContactList) temp.get(1);
                long oidHapus = hap.getOID();
                long oidPinjaman = hap.getPinjamanId();
                String status = "-";
                if (hap.getStatus() == ReturnKredit.STATUS_RETURN_DRAFT) {
                    status = "Draft";
                } else if (hap.getStatus() == ReturnKredit.DOCUMENT_STATUS_POSTED) {
                    status = "Posted";
                } else if (hap.getStatus() == ReturnKredit.DOCUMENT_STATUS_CANCELLED) {
                    status = "Cancel";
                } else if (hap.getStatus() == ReturnKredit.STATUS_RETURN_RETURN) {
                    status = "Closed";
                } 

                ja.put("<div class='text-center'>" + (objValue.optInt("start",0)  + i + 1) + "</div>");
                ja.put("<div class='text-center'>" + hap.getNomorHapus()+ "</div>");
                ja.put("<div class='text-center'>" + Formater.formatDate(hap.getTanggalHapus(), "yyyy-MM-dd") + "</div>");
                ja.put("<div class='text-center'>" + con.getPersonName() + "</div>");
                ja.put("<div class='text-center'>" + hap.getCatatan() + "</div>");
                ja.put("<div class='text-center'>" + I_DocStatus.fieldDocumentStatus[hap.getStatus()] + "</div>");
                ja.put("<div class='text-center'><a href='../transaksikredit/penghapusan_kredit.jsp?PINJAMAN_ID=" + oidPinjaman + "&command=" + Command.EDIT + "&HAPUS_KREDIT_ID=" + oidHapus + "' class='btn btn-warning'><i class='fa fa-pencil'></i></a></div>");
                array.put(ja);
            } else if (datafor.equals("listKreditKolektabilitas")) {
                Vector tempData = (Vector) listData.get(i);

                Pinjaman p = (Pinjaman) tempData.get(0);
                Anggota a = (Anggota) tempData.get(1);
                BillMain bm = (BillMain) tempData.get(2);
                KolektibilitasPembayaran kp = (KolektibilitasPembayaran) tempData.get(3);

                Location loc = new Location();
                Employee kolektor = new Employee();
                try {
                    loc = PstLocation.fetchFromApi(bm.getLocationId());
                    kolektor = PstEmployee.fetchFromApi(p.getCollectorId());
                } catch (Exception e) {
                }

                ja.put("<div class='text-center'>" + (objValue.optInt("start",0)  + i + 1) + "</div>");
                ja.put("<div class='text-center'>" + p.getNoKredit() + "</div>");
                ja.put("<div class='text-left'>" + a.getName() + "</div>");
                ja.put("<div class='text-center'><span class='pull-left'>Rp.</span> <span class='pull-right'>" + numberFormat.format(p.getJumlahPinjaman()) + "</span></div>");
                ja.put("<div class='text-center'>" + loc.getName() + "</div>");
                ja.put("<div class='text-center'>" + kolektor.getFullName() + "</div>");
                ja.put("<div class='text-center'>" + kp.getJudulKolektibilitas() + "</div>");
                String button = ""
                        + "<button class='btn btn-sm btn-warning assign-kolektor'"
                        + " data-pinjaman='" + p.getOID() + "'"
                        + " data-kolektor='" + kolektor.getFullName() + "'"
                        + " data-konsumen='" + a.getName() + "'"
                        + " data-no-konsumen='" + a.getNoAnggota() + "'"
                        + " data-no-kredit='" + p.getNoKredit() + "'"
                        + ">"
                        + " <i class='fa fa-edit'></i>"
                        + "</button>"
                        //                        + "<button class='btn btn-sm btn-primary'>"
                        //                        + " <i class='fa fa-file-o'></i>"
                        //                        + "</button>"
                        + "";
                ja.put("<div class='text-center'>" + button + "</div>");
                array.put(ja);
            } else if (datafor.equals("listRiwayatKonsumen")){
                Vector temp = (Vector) listData.get(i);
                JSONObject tempJson = new JSONObject();
                int billStatus = 0;
                try {
                    pinjaman = (Pinjaman) temp.get(0);
                    tempJson = (JSONObject) temp.get(1);
                    billStatus = tempJson.optInt("BILL_STATUS", 0);
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                    typeKredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                } catch (Exception e) {
                    printErrorMessage(e.toString());
                }

                ja.put("<div class='text-center'>" + (objValue.optInt("start",0)  + i + 1) + "</div>");
                ja.put("<div class='text-center'>" + pinjaman.getNoKredit() + "</div>");
                ja.put("<div class='text-left'>" + anggota.getName() + "</div>");
                ja.put("<div class='text-center'>" + typeKredit.getNamaKredit() + "</div>");
                ja.put("<div class='text-center'><span class='pull-left'>Rp.</span> <span class='pull-right'>" + numberFormat.format(pinjaman.getJumlahPinjaman()) + "</span></div>");
                ja.put("<div class='text-center'>" + Pinjaman.STATUS_DOC_TITLE[pinjaman.getStatusPinjaman()].toUpperCase() + "</div>");
                ja.put("<div class='text-center'>" + PstBillMain.produksiDeliveryStatus[billStatus] + "</div>");
                String button = ""
                        + "<button class='btn btn-sm btn-warning pilih-konsumen'"
                        + " data-pinjaman='" + pinjaman.getOID() + "'"
                        + " data-konsumen='" + anggota.getName() + "'"
                        + ">"
                        + " <i class='fa fa-edit'></i>"
                        + "</button>"
                        + "";
                ja.put("<div class='text-center'>" + button + "</div>");
                array.put(ja);
            } else if (datafor.equals("listDokumenKonsumen")){
                pinjaman = (Pinjaman) listData.get(i);
                BillMain bm = new BillMain();
                Location loc = new Location();
                try {
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                    bm = PstBillMain.fetchExc(pinjaman.getBillMainId());
                    loc = PstLocation.fetchFromApi(bm.getLocationId());
                    typeKredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                } catch (Exception e) {
                    printErrorMessage(e.toString());
                }

                ja.put("<div class='text-center'>" + (objValue.optInt("start",0)  + i + 1) + "</div>");
                ja.put("<div class='text-center'>" + pinjaman.getNoKredit() + "</div>");
                ja.put("<div class='text-left'>" + anggota.getName() + "</div>");
                ja.put("<div class='text-center'>" + loc.getName() + "</div>");
                String button = ""
                        + "<button class='btn btn-sm btn-success lihat-dokumen'"
                        + " data-pinjaman='" + pinjaman.getOID() + "'"
                        + " data-konsumen='" + anggota.getName() + "'"
                        + ">"
                        + " <i class='fa fa-file-text'></i>"
                        + "&nbsp; Dokumen"
                        + "</button>"
                        + "";
                ja.put("<div class='text-center'>" + button + "</div>");
                array.put(ja);
            }
        }
        totalAfterFilter = total;
        try {
            result.put("iTotalRecords", total);
            result.put("iTotalDisplayRecords", totalAfterFilter);
            result.put("aaData", array);
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        return result;
    }

    //COMMAND NONE==============================================================
    public synchronized JSONObject commandNone(HttpServletRequest request, String dataFor, JSONObject objValue) throws JSONException{
        if (dataFor.equals("getDataJenisKredit")) {
            objValue = getDataJenisKredit(request, objValue);
        } else if (dataFor.equals("getDataKredit")) {
            objValue = getDataKredit(request, objValue);
        } else if (dataFor.equals("getDataKreditForReturn")) {
            objValue = getDataKreditForReturn(request, objValue);
        } else if (dataFor.equals("getDataKreditForHapus")) {
            objValue = getDataKreditForHapus(request, objValue);
        } else if (dataFor.equals("getListTabungan")) {
            objValue = getListTabungan(request, objValue);
        } else if (dataFor.equals("getDataTabungan")) {
            objValue = getDataTabungan(request, objValue);
        } else if (dataFor.equals("setTglLunas")) {
            objValue = setTglLunas(request, objValue);
        } else if (dataFor.equals("checkTabungan")) {
            objValue = cekTabungan(request, objValue);
        } else if (dataFor.equals("getJenisSimpananTabungan")) {
            objValue = getJenisSimpananTabungan(request, objValue);
        } else if (dataFor.equals("getSyaratPengajuan")) {
            objValue = getSyaratPengajuan(request, objValue);
        } else if (dataFor.equals("getIdPayment")) {
            objValue = getIdPayment(request, objValue);
        } else if (dataFor.equals("getListCard") || dataFor.equals("getListCard2")) {
            objValue = getListCard(request, objValue);
        } else if (dataFor.equals("cekKolektibilitas")) {
            cekKolektibilitas(request);
        } else if (dataFor.equals("getOptionJenisKredit")) {
            objValue = getOptionJenisKredit(request, objValue);
        } else if (dataFor.equals("getDetailTransaksi")) {
            objValue = getDetailTransaksi(request, objValue);
        } else if (dataFor.equals("getDetailTransaksiJadwal")) {
            objValue = getDetailTransaksi(request, objValue);
        } else if (dataFor.equals("getLoket")) {
            objValue = getLoket(request, objValue);
        } else if (dataFor.equals("getLoketRaditya")) {
            objValue = getLoketRaditya(request, objValue);
        } else if (dataFor.equals("cekPaymentType")) {
            objValue = cekPaymentType(request, objValue);
        } else if (dataFor.equals("getDataCoverage")) {
            objValue = getDataCoverage(request, objValue);
        } else if (dataFor.equals("cekBungaTambahan")) {
            objValue = cekBungaTambahan(request, objValue);
        } else if (dataFor.equals("generateBungaTambahan")) {
            objValue = generateBungaTambahan(request, objValue);
        } else if (dataFor.equals("getPrintOutTransaksiPembayaran")) {
            objValue = getPrintOutTransaksiPembayaran(request, objValue);
        } else if (dataFor.equals("getFormNewSchedule")) {
            objValue = getFormNewSchedule(request, objValue);
        } else if (dataFor.equals("getSimulasiKredit")) {
            String htmlReturn = getSimulasiKredit(request);
            objValue.put("FRM_FIELD_HTML", htmlReturn);
        } else if (dataFor.equals("getPrintOutNotaTransaksi")) {
            objValue = getPrintOutNotaTransaksi(request, objValue);
        } else if (dataFor.equals("getPrintOutAngsuranPertama")) {
            String htmlReturn = getPrintOutAngsuranPertama(request);
            objValue.put("FRM_FIELD_HTML", htmlReturn);
        } else if (dataFor.equals("getSelectKonsumen")) {
            getSelectKonsumen(request);
        } else if (dataFor.equals("hapusTransaksiApproval")) {
            objValue = hapusTransaksiApproval(request, objValue);
        } else if (dataFor.equals("getDokumenKreditButton")) {
            objValue = getDokumenKreditButton(request, objValue);
        } else if (dataFor.equals("getDataJumlahKreditLabel")) {
            objValue = getDataJumlahKreditLabel(request, objValue);
        } else if (dataFor.equals("printDaftarTransaksi")) {
            objValue = printDaftarTransaksi(request, objValue);
        }
        return objValue;
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

    public JSONObject getFormNewSchedule(HttpServletRequest request, JSONObject objValue) throws JSONException{
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        Vector<JadwalAngsuran> listJadwalAngsuran = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + oid, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + "," + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
        String optionSchedule = "";
        for (JadwalAngsuran ja : listJadwalAngsuran) {
            optionSchedule += "<option value='" + ja.getOID() + "'>" + JadwalAngsuran.getTipeAngsuranTitle(ja.getJenisAngsuran()) + " - " + ja.getTanggalAngsuran() + "</option>";
        }
        String htmlReturn = ""
                + "<input type='hidden' name='SEND_OID_PINJAMAN' value='" + oid + "'>"
                + "<input type='hidden' name='SEND_OID_TELLER_SHIFT' value='" + oidTellerShift + "'>"
                + "<input type='hidden' name='FRM_FIELD_DATA_FOR' value='saveNewSchedule'>"
                + "<input type='hidden' name='command' value='" + Command.SAVE + "'>"
                + ""
                + "<div class='form-group'>"
                + "     <label class=\"col-sm-4\">Jenis Angsuran</label>"
                + "     <div class=\"col-sm-8\">"
                + "         <select class=\"form-control\" name=\"FRM_JENIS_ANGSURAN\">"
                + "             <option value='" + JadwalAngsuran.TIPE_ANGSURAN_DENDA + "'>" + JadwalAngsuran.getTipeAngsuranTitle(JadwalAngsuran.TIPE_ANGSURAN_DENDA) + "</option>"
                + "         </select>"
                + "     </div>"
                + "</div>"
                + ""
                + "<div class=\"form-group\">"
                + "     <label class=\"col-sm-4\">Denda Untuk</label>"
                + "     <div class=\"col-sm-8\">"
                + "         <select class=\"form-control\" name=\"FRM_ID_PARENT_JADWAL_ANGSURAN\">"
                + "             <option value=\"\">- Pilih Jadwal -</option>"
                + "             " + optionSchedule
                + "         </select>"
                + "     </div>"
                + "</div>"
                + ""
                + "<div class=\"form-group\">"
                + "     <label class=\"col-sm-4\">Jumlah Angsuran</label>"
                + "     <div class=\"col-sm-8\">"
                + "         <input type=\"text\" class=\"form-control\" name=\"FRM_JUMLAH_ANGSURAN\">"
                + "     </div>"
                + "</div>"
                + ""
                + "<div class=\"form-group\">"
                + "     <label class=\"col-sm-4\">Tanggal Tempo</label>"
                + "     <div class=\"col-sm-8\">"
                + "         <input type=\"text\" class=\"form-control date-picker\" name=\"SEND_TGL_TEMPO\">"
                + "     </div>"
                + "</div>"
                + ""
                + "";
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject getDataJumlahKreditLabel(HttpServletRequest request, JSONObject objValue) throws JSONException{
        JSONObject result = new JSONObject();
        int jumlahPengajuan = 0;
        int jumlahAnalisa = 0;
        int jumlahInputDetail = 0;
        int jumlahForm5C = 0;
        String whereClause = "";
        String whereClauseForm5C = "";
        
        SessUserSession userSession = getUserSession(request);
        long oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");
        
        String userGroupAdmin = PstSystemProperty.getValueByName("GROUP_ADMIN_OID");
        String whereUserGroup = PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + "=" + userGroupAdmin
                + " AND " + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "=" + userSession.getAppUser().getOID();
        Vector listUserGroup = PstUserGroup.list(0, 0, whereUserGroup, "");
        int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_PENILAIAN_KREDIT);
        boolean privAccept = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ACCEPT));
        try {
            if(oidLocation != 0){
                whereClause += " bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + oidLocation;
                whereClauseForm5C += PstBillMain.TBL_CASH_BILL_MAIN + "." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + oidLocation;
            }
            if(whereClause.length() > 0){
                whereClause += " AND ";
            }
            if(whereClauseForm5C.length() > 0){
                whereClauseForm5C += " AND ";
            }
            String whereClausePengajuan = whereClause + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_DRAFT; 
            String whereClauseInputDetail = whereClause + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_APPROVED;
            String whereClauseAnalisa = whereClause + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_TO_BE_APPROVE;
            whereClauseForm5C += PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISA_STATUS]
                    + " = " + PstAnalisaKreditMain.ANALISA_STATUS_DRAFT;
//            if(this.privPosAnalis){
//                whereClauseAnalisa += " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " = " + this.oidEmployeeUser;
//                whereClauseForm5C += " AND " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]
//                        + " = " + this.oidEmployeeUser;
//            }
            if (!privAccept && listUserGroup.isEmpty()) {
                whereClausePengajuan += " AND (pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " = " + userSession.getAppUser().getEmployeeId()+" OR "
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + userSession.getAppUser().getEmployeeId()+")";
                whereClauseInputDetail += " AND (pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " = " + userSession.getAppUser().getEmployeeId()+" OR "
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + userSession.getAppUser().getEmployeeId()+")";
                whereClauseAnalisa += " AND (pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " = " + userSession.getAppUser().getEmployeeId()+" OR "
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + userSession.getAppUser().getEmployeeId()+")";
                whereClauseForm5C += " AND (pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " = " + userSession.getAppUser().getEmployeeId()+" OR "
                        + "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + userSession.getAppUser().getEmployeeId()+")";
            }
            jumlahPengajuan = PstPinjaman.getCountJoinKredit(whereClausePengajuan);
            jumlahAnalisa = PstPinjaman.getCountJoinKredit(whereClauseAnalisa);
            jumlahInputDetail = PstPinjaman.getCountJoinKredit(whereClauseInputDetail);
            jumlahForm5C = PstAnalisaKreditMain.getCountJoin(whereClauseForm5C);
            
            try {
                result.put("JUMLAH_DATA_PENGAJUAN", jumlahPengajuan);
                result.put("JUMLAH_DATA_ANALISA", jumlahAnalisa);
                result.put("JUMLAH_DATA_INPUT_DETAIL", jumlahInputDetail);
                result.put("JUMLAH_DATA_FORM_5C", jumlahForm5C);
            
                objValue.put("JUMLAH_DATA", result);
            } catch (Exception e) {
                printErrorMessage(e.toString());
            }
        } catch (Exception e) {
            printErrorMessage(e.toString());
        }
        return objValue;
    }
    
    public JSONObject printDaftarTransaksi(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String html = "";
        String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
        String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
        String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
        String arrayNasabah[] = request.getParameterValues("FRM_NASABAH");
        String arrayTransaksi[] = request.getParameterValues("FRM_TRANSAKSI");
        long oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");
        String userName = FRMQueryString.requestString(request, "SEND_USER_NAME");
        Location loc = new Location();
        
        String whereClause = "(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN ("
                + Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN
                + "," + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT
                + "," + Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN
                + "," + Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN
                + ")"
                + ")";
        
        if (tglAwal.equals("") && tglAkhir.equals("")) {
            System.out.println("com.dimata.sedana.ajax.kredit.AjaxKredit.printDaftarTransaksi()");
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            tglAkhir = Formater.formatDate(cal.getTime(), "yyyy-MM-dd");
            System.out.println("Tgl Akhir " + tglAkhir);
            cal.add(Calendar.MONTH, -1);
            tglAwal = Formater.formatDate(cal.getTime(), "yyyy-MM-dd");
            System.out.println("Tgl Awal " + tglAwal);
        }
        
        if (!tglAwal.equals("") && !tglAkhir.equals("")) {
            whereClause += " AND ("
                    + " DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + tglAwal + "'"
                    + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + tglAkhir + "'"
                    + ")";
        } 
        
        String nasabah = "";
        if (arrayNasabah != null && !arrayNasabah[0].equals("0")) {
            String idNasabah = "";
            for (int i = 0; i < arrayNasabah.length; i++) {
                if (i > 0) {
                    idNasabah += ",";
                    nasabah += ", ";
                }
                idNasabah += "" + arrayNasabah[i];
                Anggota a = PstAnggota.fetchExc(Long.valueOf(arrayNasabah[i]));
                nasabah += "" + a.getName();
            }
            if (!idNasabah.equals("")) {
                whereClause += " AND a." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " IN (" + idNasabah + ")";
            }
        } else {
            nasabah = "Semua " + namaNasabah;
        }
        
        String namaTransaksi = "";
        if (arrayTransaksi != null && !arrayTransaksi[0].equals("0")) {
            String kodeTransaksi = "";
            for (int i = 0; i < arrayTransaksi.length; i++) {
                if (i > 0) {
                    kodeTransaksi += ",";
                    namaTransaksi += ", ";
                }
                kodeTransaksi += "" + arrayTransaksi[i];
                namaTransaksi += "" + Transaksi.USECASE_TYPE_TITLE.get(Integer.valueOf(arrayTransaksi[i]));
            }
            if (!kodeTransaksi.equals("")) {
                whereClause += " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + kodeTransaksi + ")";
            }
        } else {
            namaTransaksi = "Semua transaksi";
        }
        
        String textTglAwal = "";
        String textTglAkhir = "";
        Date now = new Date();
        textTglAwal = Formater.formatDate(now, "dd MMM yyyy");
        textTglAkhir = Formater.formatDate(now, "dd MMM yyyy");
        if (!tglAwal.equals("") && !tglAkhir.equals("")) {
            Date dAwal = Formater.formatDate(tglAwal, "yyyy-MM-dd");
            textTglAwal = Formater.formatDate(dAwal, "dd MMM yyyy");
            Date dAkhir = Formater.formatDate(tglAkhir, "yyyy-MM-dd");
            textTglAkhir = Formater.formatDate(dAkhir, "dd MMM yyyy");
        }
        
        if (oidLocation > 0){
            whereClause += " AND loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " = " + oidLocation;
        }
        
        try {
            try {
                loc = PstLocation.fetchFromApi(oidLocation);
            } catch (Exception e) {
                objValue.put("RETURN_MESSAGE", e.getMessage());
                objValue.put("RETURN_ERROR_CODE", 1);
                printErrorMessage(e.toString());
            }
            
            
            Vector listTransaksi = SessKredit.getListTransaksiKredit(0, 0, whereClause
                    + " GROUP BY " + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID], PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ");

            String content = "";
            for (int i = 0; i < listTransaksi.size(); i++) {
                Transaksi t = (Transaksi) listTransaksi.get(i);
                Pinjaman p = new Pinjaman();
                Anggota a = new Anggota();
                try {
                    p = PstPinjaman.fetchExc(t.getPinjamanId());
                    a = PstAnggota.fetchExc(p.getAnggotaId());
                } catch (Exception e) {
                    System.out.println(e);
                }
                //cari nilai transaksi
                double nilaiTransaksi = 0;
                if (t.getUsecaseType() == Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN) {
                    nilaiTransaksi = p.getJumlahPinjaman();
                } else if (t.getUsecaseType() == Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT) {
                    Vector<Angsuran> listAngsuran = PstAngsuran.list(0, 0, "" + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = '" + t.getOID() + "'", "");
                    for (int j = 0; j < listAngsuran.size(); j++) {
                        nilaiTransaksi += listAngsuran.get(j).getJumlahAngsuran();
                    }
                } else if (t.getUsecaseType() == Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN) {
                    Vector<JadwalAngsuran> listBungaTambahan = PstJadwalAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = '" + t.getOID() + "'", null);
                    for (JadwalAngsuran j : listBungaTambahan) {
                        nilaiTransaksi += j.getJumlahANgsuran();
                    }
                }
                
                content += "<tr>"
                        + " <td>" + (i + 1) + "</td>"
                        + " <td>" + Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd") + "&nbsp;&nbsp;" + Formater.formatDate(t.getTanggalTransaksi(), "HH:mm:ss") + "</td>"
                        + " <td>" + t.getKeterangan() + "</td>"
                        + " <td>" + t.getKodeBuktiTransaksi() + "</td>"
                        + " <td>" + a.getName() + "</td>"
                        + " <td class='money text-right'>" + nilaiTransaksi + "</td>"
                        + " <td>" + Transaksi.STATUS_DOC_TRANSAKSI_TITLE[t.getStatus()] + "</td>"
                        + "</tr>";

            }
                        
            
            html = ""
                    + "<div style='width: 50%; float: left;'>"
                    + " <strong style='width: 100%; display: inline-block; font-size: 20px;'>" + loc.getName() + "</strong>"
                    + " <span style='width: 100%; display: inline-block;'>" + loc.getAddress() + "</span>"
                    + " <span style='width: 100%; display: inline-block;'>" + loc.getTelephone() + "</span>"
                    + "</div>"
                    + "<div style='width: 50%; float: right; text-align: right'>"
                    + " <span style='width: 100%; display: inline-block; font-weight: 400; font-size: 20px;'>DAFTAR TRANSAKSI KREDIT</span>"
                    + " <span style='width: 100%; display: inline-block; font-size: 12px;'>Tanggal :" + Formater.formatDate(new Date(), "dd MMM yyyy / HH:mm:ss") + "</span>"
                    + " <span style='width: 100%; display: inline-block; font-size: 12px;'>Admin : " + userName + "</span>"
                    + "</div>"
                    + "<div class='clearfix'></div>"
                    + "<hr class='' style='border-color: gray'> "
                    + "<table style='font-size: 12px'>"
                    + " <tr>"
                    + "  <td>Tanggal</td>"
                    + "  <td style='padding: 0px 10px'>&nbsp;&nbsp;:&nbsp;&nbsp;</td>"
                    + "  <td>" + textTglAwal + " s.d. " + textTglAkhir + "</td>"
                    + " </tr>"
                    + " <tr>"
                    + "  <td>Transaksi</td>"
                    + "  <td style='padding: 0px 10px'>&nbsp;&nbsp;:&nbsp;&nbsp;</td>"
                    + "  <td>" + namaTransaksi + "</td>"
                    + " </tr>"
                    + " <tr>"
                    + "  <td>Nasabah</td>"
                    + "  <td style='padding: 0px 10px'>&nbsp;&nbsp;:&nbsp;&nbsp;</td>"
                    + "  <td>" + nasabah + "</td>"
                    + " </tr>"
                    + "</table>"
                    + "<br>"
                    + "<div>"
                    + " <table class='table table-bordered tabel_data_print'>"
                    + "  <thead>"
                    + "   <tr>"
                    + "    <th style='width: 1%'>No.</th>"
                    + "    <th>Tanggal Transaksi</th>"
                    + "    <th style='width: 25%'>Keterangan</th>"
                    + "    <th>Nomor Transaksi</th>"
                    + "    <th>Nama " + namaNasabah + "</th>"
                    + "    <th>Nilai Transaksi</th>"
                    + "    <th>Status</th>"
                    + "   </tr>"
                    + "  </thead>"
                    + "  <tbody>"
                    + content
                    + "  </tbody>"
                    + " </table>"
                    + "</div>";


        } catch (Exception e) {
            objValue.put("RETURN_MESSAGE", e.getMessage());
            objValue.put("RETURN_ERROR_CODE", 1);
            printErrorMessage(e.toString());
        }
        objValue.put("FRM_FIELD_HTML", html);
        return objValue;
    }
    
    public JSONObject getPrintOutTransaksiPembayaran(HttpServletRequest request, JSONObject objValue) throws JSONException{
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        getPrintOutAngsuranKredit(request, oid, objValue);
        return objValue;
    }

    public synchronized JSONObject getDokumenKreditButton(HttpServletRequest request, JSONObject objValue) throws JSONException{
        Pinjaman p = new Pinjaman();
        String output = "";
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        try {
            p = PstPinjaman.fetchExc(oid);

            output = "<div class='text-center'>"
                    + " <button type='button' class='btn btn-primary btn-dokumen kartu-angsuran' data-oid='" + p.getOID() + "'> Kartu Angsuran </button>"
                    + " <button type='button' class='btn btn-primary btn-dokumen show-dokumen' data-oid='" + p.getOID() + "' data-type='BAP'> Berita Acara Pemeriksaan </button>"
                    + " <button type='button' class='btn btn-primary btn-dokumen show-dokumen' data-oid='" + p.getOID() + "' data-type='SPMK'> Surat Permohonan Kredit </button>"
                    + " <button type='button' class='btn btn-primary btn-dokumen show-dokumen' data-oid='" + p.getOID() + "' data-type='PK'> Surat Perjanjian Kredit </button>"
                    + " <button type='button' class='btn btn-primary btn-dokumen show-dokumen' data-oid='" + p.getOID() + "' data-type='SPT'> Surat Pernyataan </button>"
                    + "</div>";

        } catch (Exception e) {
            printErrorMessage(e.toString());
        }
        objValue.put("FRM_FIELD_HTML",output);
        return objValue;
    }
    
    public synchronized JSONObject hapusTransaksiApproval(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String username = FRMQueryString.requestString(request, "username");
        String password = FRMQueryString.requestString(request, "password");
        boolean approve = false;
        if (username == null || username.length() == 0) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", "Username tidak boleh kosong.");
            return objValue;
        }
        if (password == null || password.length() == 0) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", "Password tidak boleh kosong.");
            return objValue;
        }
        if (objValue.optInt("iErrCode",0) == 0) {
            try {
                String kadivPosId = PstSystemProperty.getValueByName("SEDANA_KADIV_KREDIT_OID");
                AppUser user = new AppUser();
                Vector userList = PstAppUser.listFullObj(0, 0,
                        PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID] + " = '" + username + "'"
                        + " AND " + PstAppUser.fieldNames[PstAppUser.FLD_PASSWORD] + " = '" + password + "'",
                        "");
                if (!userList.isEmpty()) {
                    user = (AppUser) userList.get(0);
                }
                String whereClause = "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + user.getEmployeeId()
                        + " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = " + kadivPosId;
                JSONArray array = PstEmployee.getListEmpDivFromApi(0, 0, whereClause, "");
                if (array.length() > 0) {
                    approve = true;
                } else {
                    objValue.put("RETURN_ERROR_CODE", 1);
                    objValue.put("RETURN_MESSAGE", "User Kadiv tidak ditemukan.");
                    return objValue;
                }
            } catch (Exception e) {
                printErrorMessage(e.getMessage());
            }
        }
        if (approve) {
            long oidTransaksi = FRMQueryString.requestLong(request, "oidTransaksi");
            if (oidTransaksi != 0) {
                deleteTransaction(request, oidTransaksi, objValue);
            } else {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", "ID Transaksi tidak ditemukan.");
            }
        }
        return objValue;
    }

    public JSONObject getPrintOutNotaTransaksi(HttpServletRequest request, JSONObject objValue) throws JSONException{
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        getPrintOutNotaTransaksi(request, oid, objValue);
        return objValue;
    }

    public JSONObject generateBungaTambahan(HttpServletRequest request, JSONObject objValue) throws JSONException{
        Pinjaman pinjaman = new Pinjaman();
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        long oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        try {
            pinjaman = PstPinjaman.fetchExc(oid);
            if (pinjaman.getStatusPinjaman() != Pinjaman.STATUS_DOC_CAIR) {
                objValue.put("RETURN_MESSAGE", "Status pinjaman harus cair untuk bisa generate bunga tambahan.");
                return objValue;
            }
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }

        int jadwalBaru = 0;
        //CARI JADWAL BUNGA TERAKHIR
        String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + pinjaman.getOID()
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA;
        Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 1, whereJadwal, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " DESC ");
        for (JadwalAngsuran ja : listJadwal) {
            try {
                //BUAT TRANSAKSI PENCATATAN BUNGA KREDIT TAMBAHAN
                Date tglTransaksi = new Date();
                String kodeTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_BUNGA_TAMBAHAN, Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN, tglTransaksi);
                Transaksi t = new Transaksi();
                t.setTanggalTransaksi(tglTransaksi);
                t.setKodeBuktiTransaksi(kodeTransaksi);
                t.setIdAnggota(pinjaman.getAnggotaId());
                t.setTellerShiftId(oidTellerShift);
                t.setKeterangan(Transaksi.USECASE_TYPE_TITLE.get(Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN));
                t.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                t.setUsecaseType(Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN);
                t.setPinjamanId(pinjaman.getOID());
                long idTrx = PstTransaksi.insertExc(t);

                //GENERATE JADWAL BARU
                SessKreditKalkulasi k = new SessKreditKalkulasi();
                k.setKredit(PstJenisKredit.fetch(pinjaman.getTipeKreditId()));
                k.setRealizationDate(ja.getTanggalAngsuran());
                k.setPengajuanTotal(pinjaman.getJumlahPinjaman());
                k.setSukuBunga(pinjaman.getSukuBunga());
                k.setJangkaWaktu(pinjaman.getJangkaWaktu());
                k.setTipeBunga(pinjaman.getTipeBunga());
                k.setDateTempo(ja.getTanggalAngsuran());
                k.setTipeJadwal(pinjaman.getTipeJadwal());
                k.generateDataKredit();

                Calendar c = Calendar.getInstance();
                c.setTime(new Date());
                c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));

                for (int i = 1; i < k.getTSize(); i++) {
                    int compareToNow = k.getTDate(i).compareTo(c.getTime());
                    int compareToLast = k.getTDate(i).compareTo(ja.getTanggalAngsuran());
                    //CEK HASIL GENERATE JADWAL
                    if (compareToLast > 0) {
                        try {
                            Date tglBunga = k.getTDate(i);

                            //cek apakah jadwal yg di generate bukan di bulan februari
                            Calendar calJadwal = Calendar.getInstance();
                            calJadwal.setTime(tglBunga);
                            if (calJadwal.get(Calendar.MONTH) != Calendar.FEBRUARY) {
                                //jika bulan bukan februari, sesuaikan tanggal di jadwal dengan tanggal jatuh tempo di data pinjaman
                                Calendar calTempo = Calendar.getInstance();
                                calTempo.setTime(pinjaman.getJatuhTempo());
                                calJadwal.set(Calendar.DAY_OF_MONTH, calTempo.get(Calendar.DAY_OF_MONTH));
                                tglBunga = calJadwal.getTime();
                            }

                            double totalPokok = SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                            double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                            DecimalFormat df = new DecimalFormat("#.##");
                            double newAngsuran = Double.valueOf(df.format(totalPokok));
                            double newDibayar = Double.valueOf(df.format(pokokDibayar));

                            JadwalAngsuran jadwal = new JadwalAngsuran();
                            jadwal.setPinjamanId(pinjaman.getOID());
                            jadwal.setTanggalAngsuran(tglBunga);
                            jadwal.setJenisAngsuran(JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                            jadwal.setTransaksiId(idTrx);

                            double nilaiPokok = pinjaman.getJumlahPinjaman();
                            if (pinjaman.getTipeBunga() == Pinjaman.TIPE_BUNGA_MENURUN) {
                                nilaiPokok = newAngsuran - newDibayar;
                            }

                            double bunga = SessKreditKalkulasi.getBunga(nilaiPokok, pinjaman.getTipeJadwal(), pinjaman.getTipeBunga(), 1, k.getKredit(), pinjaman);
                            int useRounding = 0;
                            try {
                                useRounding = Integer.valueOf(PstSystemProperty.getValueByName("GUNAKAN_PEMBULATAN_ANGSURAN"));
                            } catch (Exception exc) {
                                printErrorMessage(exc.getMessage());
                            }
                            if (useRounding == 1) {
                                double pembulatan = (Math.floor((bunga + 499) / 500)) * 500;
                                jadwal.setJumlahAngsuranSeharusnya(bunga);
                                jadwal.setJumlahANgsuran(pembulatan);
                                jadwal.setSisa(pembulatan - bunga);
                            } else {
                                double pembulatan = Double.valueOf(df.format(bunga));
                                jadwal.setJumlahAngsuranSeharusnya(bunga);
                                jadwal.setJumlahANgsuran(pembulatan);
                                jadwal.setSisa(pembulatan - bunga);
                            }

                            PstJadwalAngsuran.insertExc(jadwal);
                            jadwalBaru++;
                        } catch (DBException ex) {
                            printErrorMessage(ex.getMessage());
                            objValue.put("RETURN_MESSAGE", ex.getMessage());
                        }
                    }

                    //bunga digenerate 1 kali, jadi harus di break setelah loop pertama
                    break;
                }
                if (jadwalBaru == 0) {
                    deleteTransaction(request, idTrx, objValue);
                }
            } catch (DBException | NumberFormatException e) {
                printErrorMessage(e.getMessage());
                objValue.put("RETURN_MESSAGE", e.getMessage());
            }
        }
        String message = (jadwalBaru > 0) ? "" + jadwalBaru + " jadwal bunga baru berhasil di generate. " : "Tidak ada jadwal bunga baru. " ;
        objValue.put("RETURN_MESSAGE", message);
        return objValue;
    }

    public JSONObject cekBungaTambahan(HttpServletRequest request, JSONObject objValue) throws JSONException{
        int iErrCode = 0;
        try {
            
            long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            Pinjaman p = PstPinjaman.fetchExc(oid);

            //CEK SISA POKOK
            double totalPokok = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
            double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
            double sisaPokok = totalPokok - pokokDibayar;
            if (sisaPokok > 0) {
                //CEK TIPE BUNGA
                if (p.getTipeBunga() == Pinjaman.TIPE_BUNGA_MENURUN) {
                    objValue.put("RETURN_ERROR_CODE", 1);
                } else if (p.getTipeBunga() == Pinjaman.TIPE_BUNGA_FLAT) {
                    Date now = new Date();
                    Date lastJadwal = new Date();

                    //GET JADWAL POKOK TERAKHIR
                    String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                            + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
                    Vector<JadwalAngsuran> list = PstJadwalAngsuran.list(0, 1, where, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " DESC ");
                    for (JadwalAngsuran ja : list) {
                        lastJadwal = ja.getTanggalAngsuran();
                    }

                    //CEK TANGGAL ANGSURAN POKOK TERAKHIR
                    if (now.after(lastJadwal)) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                    }
                }
            }

        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        objValue.put("RETURN_ERROR_CODE", iErrCode);
        return objValue;
    }

    public JSONObject getDataCoverage(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String htmlReturn = "";
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        int jangka = FRMQueryString.requestInt(request, "SEND_JANGKA_WAKTU");
        Vector listCoverage = PstPersentaseJaminan.list(0, 0, ""
                + "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + oid + "'"
                + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " = '" + jangka + "'"
                + "", "");
        htmlReturn = "<option value=''>- Pilih -</option>";
        for (int i = 0; i < listCoverage.size(); i++) {
            PersentaseJaminan pj = (PersentaseJaminan) listCoverage.get(i);
            htmlReturn += ""
                    + "<option data-persen=" + pj.getPersentaseDijamin() + " value='" + pj.getOID() + "'>" + pj.getPersentaseCoverage() + " %</option>"
                    + "";
        }
        if (listCoverage.isEmpty()) {
            htmlReturn = "<option>Coverage dengan jangka waktu tersebut tidak ditemukan</option>";
        }
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject cekPaymentType(HttpServletRequest request, JSONObject objValue) throws JSONException{
        PaymentSystem ps = new PaymentSystem();
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        try {
            ps = PstPaymentSystem.fetchExc(oid);
        } catch (Exception e) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
            return objValue;
        }
        objValue.put("RETURN_PAYMENT_TYPE", ps.getPaymentType());
        return objValue;
    }

    public JSONObject getLoketRaditya(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String htmlReturn = "";
        String hrApiUrl = PstSystemProperty.getValueByName("HARISMA_URL");
        String[] loket1 = PstSystemProperty.getValueByName("SEDANA_ASSIGN_LOKET_KOLEKTOR").split(",");
        String[] loket2 = PstSystemProperty.getValueByName("SEDANA_ASSIGN_LOKET_OPERASIONAL").split(",");
        String[] loket3 = PstSystemProperty.getValueByName("SEDANA_ASSIGN_LOKET_SALES_COUNTER").split(",");
        long adminGroup = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_ASSIGN_LOKET_ADMIN"));
        AppUser ap = new AppUser();
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        try {
            ap = PstAppUser.fetch(oid);
        } catch (Exception e) {
        }
        long positionId = 0;
        String url = hrApiUrl + "/employee/employee-fetch/" + ap.getEmployeeId();
        JSONObject obj = WebServices.getAPI("", url);
        long poId = 0;
        int loketType = 0;
        String loketData = "";
        if (obj.length() > 0) {
            positionId = obj.optLong(PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID], 0);
        }

        Vector groups = SessAppUser.getUserGroup(oid);
        if (!groups.isEmpty()) {
            for (int j = 0; j < groups.size(); j++) {
                AppGroup ags = (AppGroup) groups.get(j);
                if (adminGroup == ags.getOID()) {
                    poId = 1;
                    loketType = 2;
                }
            }
        } 
        if (loketType == 0) {
            for (int i = 0; i < loket1.length; i++) {
                long loketId = Long.parseLong(loket1[i]);
                if (positionId == loketId) {
                    poId = loketId;
                    loketType = 1;
                }
            }
            if (poId == 0) {
                for (int i = 0; i < loket2.length; i++) {
                    long loketId = Long.parseLong(loket2[i]);
                    if (positionId == loketId) {
                        poId = loketId;
                        loketType = 2;
                    }
                }

            }

            if (poId == 0) {
                for (int i = 0; i < loket3.length; i++) {
                    long loketId = Long.parseLong(loket3[i]);
                    if (positionId == loketId) {
                        poId = loketId;
                        loketType = 3;
                    }
                }

            }
        }

        long oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");
        String where = PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOCATION_ID] + " = '" + oidLocation + "'";
        if (loketType == 1) {
            where += " AND " + PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOKET_TYPE] + " = '" + PstMasterLoket.LOKET_TYPE_KOLEKTOR + "'";
        } else if (loketType == 2) {
            where += " AND " + PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOKET_TYPE] + " = '" + PstMasterLoket.LOKET_TYPE_OPERASIONAL + "'";
        } else if (loketType == 3) {
            where += " AND " + PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOKET_TYPE] + " = '" + PstMasterLoket.LOKET_TYPE_SALES + "'";
        }
        Vector listLoket = PstMasterLoket.list(0, 0, where, "");
        if (loketType == 0) {
            htmlReturn += "<option value='0'>Loket Tidak Ditemukan</option>";
        } else {
            if (!listLoket.isEmpty()) {
                for (int i = 0; i < listLoket.size(); i++) {
                    MasterLoket ml = (MasterLoket) listLoket.get(i);
                    htmlReturn += ""
                            + "<option value='" + ml.getOID() + "'>" + ml.getLoketName() + "</option>";

                }
            } else {
                htmlReturn += "<option value='0'>Loket Tidak Ditemukan</option>";
                objValue.put("RETURN_ERROR_CODE", 1);
            }
        }
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject getLoket(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String htmlReturn = "";
        long oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");
        Vector listLoket = PstMasterLoket.list(0, 0, "" + PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOCATION_ID] + " = '" + oidLocation + "'", "");
        for (int i = 0; i < listLoket.size(); i++) {
            MasterLoket ml = (MasterLoket) listLoket.get(i);
            //cek loket available
            String dateNow = Formater.formatDate(new Date(), "yyyy-MM-dd");
            Vector loketAvailable = PstCashTeller.list(0, 0, ""
                    + "" + PstCashTeller.fieldNames[PstCashTeller.FLD_MASTER_LOKET_ID] + " = '" + ml.getOID() + "'"
                    + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_STATUS] + " = '" + Transaksi.STATUS_DOC_TRANSAKSI_OPEN + "'"
                    //                    + " AND DATE(" + PstCashTeller.fieldNames[PstCashTeller.FLD_OPEN_DATE] + ") = '" + dateNow + "'"
                    + "", "");
            if (loketAvailable.isEmpty()) {
                htmlReturn += ""
                        + "<option value='" + ml.getOID() + "'>" + ml.getLoketNumber() + "</option>";
            }
        }
        if (htmlReturn.equals("")) {
            htmlReturn += "<option value=''>Semua loket sudah terisi</option>";
        }
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject getDetailTransaksi(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String htmlReturn = "";
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        long userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
        String dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        Transaksi transaksi = new Transaksi();
        Pinjaman pinjaman = new Pinjaman();
        AppUser user = new AppUser();
        try {
            transaksi = PstTransaksi.fetchExc(oid);
            if (transaksi.getPinjamanId() != 0) {
                pinjaman = PstPinjaman.fetchExc(transaksi.getPinjamanId());
            }
            user = PstAppUser.fetch(userId);
        } catch (Exception e) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
            return objValue;
        }
        String tipeTrans = "";
        if (transaksi.getStatus() == Transaksi.STATUS_DOC_TRANSAKSI_OPEN) {
            tipeTrans = "btn_delete_open_trans";
        } else {
            tipeTrans = "btn_delete_close_trans";
        }

        htmlReturn += ""
                + "<table style='font-size: 14px'>"
                + "     <tr>"
                + "         <td style='width: 120px'>Nomor Transaksi</td>"
                + "         <td>: &nbsp;&nbsp;" + transaksi.getKodeBuktiTransaksi() + "</td>"
                + "     </tr>"
                + "     <tr>"
                + "         <td>Tanggal Transaksi</td>"
                + "         <td>: &nbsp;&nbsp;" + Formater.formatDate(transaksi.getTanggalTransaksi(), "dd MMM yyyy HH:mm:ss") + "</td>"
                + "     </tr>"
                + "     <tr>"
                + "         <td>Jenis Transaksi</td>"
                + "         <td>: &nbsp;&nbsp;" + Transaksi.USECASE_TYPE_TITLE.get(transaksi.getUsecaseType()) + "</td>"
                + "     </tr>"
                + "</table>"
                + "<br>";

        switch (transaksi.getUsecaseType()) {
            case Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN:
                //get detail pencairan
                Vector listDetailPencairan = SessKredit.getTransaksiPencairanKredit(0, 0, ""
                        + " t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = '" + transaksi.getOID() + "'"
                        + " AND ("
                        + " jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_TABUNGAN + "'"
                        + " OR jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_ASURANSI + "'"
                        + " OR jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_UMUM + "'"
                        + " OR jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_PERUSAHAAN + "'"
                        + ")", "");

                htmlReturn += ""
                        + " <table class='table table-bordered table-striped' style='font-size: 14px'>"
                        + "     <tr>"
                        + "         <th class='aksi'>No.</th>"
                        + "         <th>No. Tabungan</th>"
                        + "         <th>Jenis Transaksi</th>"
                        + "         <th>Debet</th>"
                        + "         <th>Kredit</th>"
                        + "     </tr>"
                        + "";

                double totalbiaya = 0;
                double pengendapan = pinjaman.getWajibValueType() == Pinjaman.WAJIB_VALUE_TYPE_PERSEN ? pinjaman.getJumlahPinjaman() * pinjaman.getWajibValue() / 100 : pinjaman.getWajibValue();
                String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");
                for (int i = 0; i < listDetailPencairan.size(); i++) {
                    DetailTransaksi dt = (DetailTransaksi) listDetailPencairan.get(i);
                    JenisTransaksi jt = new JenisTransaksi();
                    AssignContactTabungan act = new AssignContactTabungan();
                    JenisSimpanan js = new JenisSimpanan();
                    double nilaiKredit = dt.getKredit();
                    double nilaiDebet = dt.getDebet();
                    totalbiaya += nilaiDebet;
                    try {
                        if (useForRaditya.equals("0")) {
                            DataTabungan dataTabungan = PstDataTabungan.fetchExc(dt.getIdSimpanan());
                            jt = PstJenisTransaksi.fetchExc(dt.getJenisTransaksiId());
                            act = PstAssignContactTabungan.fetchExc(dataTabungan.getAssignTabunganId());
                            js = PstJenisSimpanan.fetchExc(dataTabungan.getIdJenisSimpanan());
                        }
                        jt = PstJenisTransaksi.fetchExc(dt.getJenisTransaksiId());
                    } catch (Exception e) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", e.toString());
                        printErrorMessage(e.getMessage());
                    }
                    htmlReturn += ""
                            + " <tr>"
                            + "     <td>" + (i + 1) + ".</td>"
                            + "     <td>" + act.getNoTabungan() + " (" + js.getNamaSimpanan() + ")</td>"
                            + "     <td>" + jt.getJenisTransaksi() + "</td>"
                            + "     <td class='text-right'><span class='money'>" + nilaiDebet + "</span></td>"
                            + "     <td class='text-right'><span class='money'>" + nilaiKredit + "</span></td>"
                            + " </tr>";
                }
                double nilaiTransaksi = pinjaman.getJumlahPinjaman() - totalbiaya - pengendapan;
                String formula = "Jumlah pinjaman - total biaya - jumlah pengendapan";
                htmlReturn += ""
                        + " <tr>"
                        + "     <td colspan='5' class='text-right'><b>Nilai Transaksi &nbsp;:&nbsp Rp <span class='money' title='" + formula + "'>" + nilaiTransaksi + "</span></b></td>"
                        + " </tr>"
                        + "</table>";
                break;

            case Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT:
                //get detail pembayaran
                String whereClause = " AA." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = '" + transaksi.getOID() + "'";
                String group = " SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN];
                ArrayList listDetailPembayaran = PstAngsuran.listAngsuranJoinJadwal(whereClause, group);
                Vector<Angsuran> listAngsuran = PstAngsuran.list(0, 0, "" + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = '" + transaksi.getOID() + "'", "");
                htmlReturn += ""
                        + " <label>Angsuran Dibayar :</label>"
                        + " <table class='table table-bordered' style='font-size: 14px'>"
                        + "     <tr>"
                        + "         <th style='width: 1%'>No.</th>"
                        + "         <th>Jatuh Tempo</th>"
                        + "         <th>Jenis Angsuran</th>"
                        + "         <th>Jumlah Angsuran</th>"
                        + "         <th>Diskon</th>"
                        + "         <th>Jumlah Dibayar</th>"
                        + "     </tr>"
                        + "";
                JadwalAngsuran jad = new JadwalAngsuran();
                Angsuran a = new Angsuran();
                double totalDibayar = 0;
                double totalDiskon = 0;
                double jumlahBayar = 0;
                for (Angsuran angs : listAngsuran) {
                    a = angs;
                    try {
                        jad = PstJadwalAngsuran.fetchExc(a.getJadwalAngsuranId());
                    } catch (Exception e) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", e.toString());
                        printErrorMessage(e.getMessage());
                    }
                }
                int count = 1;
                for (int i = 0; i < listDetailPembayaran.size(); i++) {
                    count++;
//                    a = (Angsuran) listDetailPembayaran.get(i);
//                    jad = new JadwalAngsuran();
//                    try {
//                        jad = PstJadwalAngsuran.fetchExc(a.getJadwalAngsuranId());
//                    } catch (Exception e) {
//                        objValue.put("RETURN_ERROR_CODE", 1);
//                        objValue.put("RETURN_MESSAGE", e.toString());
//                        printErrorMessage(e.getMessage());
//                    }
//                    jumlahBayar += a.getJumlahAngsuran();
//                    totalDibayar += a.getJumlahAngsuran();
//                    jumlahAngsuran += jad.getJumlahANgsuran();
//                    if (jad.getJumlahANgsuran() < a.getJumlahAngsuran() && listDetailPembayaran.size() == 1) {
//                        this.htmlReturn += ""
//                                + " <tr>"
//                                + "     <td>" + (i + 1) + ".</td>"
//                                + "     <td>" + Formater.formatDate(jad.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
//                                + "     <td>" + JadwalAngsuran.getTipeAngsuranTitle(jad.getJenisAngsuran()) + "</td>"
//                                + "     <td class='money text-right'>" + jad.getJumlahANgsuran() + "</td>"
//                                + "     <td class='money text-right'>" + jad.getJumlahANgsuran() + "</td>"
//                                + " </tr>";
//                    } else if (listDetailPembayaran.size() == 1) {
//                        this.htmlReturn += ""
//                                + " <tr>"
//                                + "     <td>" + (i + 1) + ".</td>"
//                                + "     <td>" + Formater.formatDate(jad.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
//                                + "     <td>" + JadwalAngsuran.getTipeAngsuranTitle(jad.getJenisAngsuran()) + "</td>"
//                                + "     <td class='money text-right'>" + jad.getJumlahANgsuran() + "</td>"
//                                + "     <td class='money text-right'>" + a.getJumlahAngsuran() + "</td>"
//                                + " </tr>";
//
//                    }

                    ArrayList<String> data = (ArrayList<String>) listDetailPembayaran.get(i);
                    String dateStr = data.get(0);
                    String jenisAngsuranStr = data.get(1);
                    String jumlahAngsuranStr = data.get(2);
                    String jumlahDibayarStr = data.get(3);
                    String tglAngsuranStr = data.get(4);
                    String diskon = data.get(5);

                    String jenisAngsuranWhere = "";
                    if(Integer.parseInt(jenisAngsuranStr) == JadwalAngsuran.TIPE_ANGSURAN_BUNGA 
                            || Integer.parseInt(jenisAngsuranStr) == JadwalAngsuran.TIPE_ANGSURAN_POKOK ){
                        jenisAngsuranWhere = JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ", " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
                    } else { 
                        jenisAngsuranWhere = "" + jenisAngsuranStr;
                    }
                    
                    double jumlahAngsuran = 0;
                    String whereJa = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + transaksi.getPinjamanId()
                            + " AND DATE(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")"
                            + " = DATE('" + tglAngsuranStr + "')"
                            + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] 
                            + " IN (" + jenisAngsuranWhere + ")";
                    Vector<JadwalAngsuran> listJadwalAngsuran = PstJadwalAngsuran.list(0, 0, whereJa, "");
                    for (JadwalAngsuran ja : listJadwalAngsuran) {
                        jumlahAngsuran += ja.getJumlahANgsuran();
                    }

                    double cvtJumlahBayar = Double.valueOf(jumlahDibayarStr);
                    double cvtJumlahAngsuran = Double.valueOf(jumlahAngsuranStr);
                    double cvtDiskon = Double.valueOf(diskon);
                    if (cvtJumlahAngsuran != jumlahAngsuran) {
                        cvtJumlahAngsuran = jumlahAngsuran;
                    }
                    jumlahBayar += cvtJumlahBayar;
                    totalDibayar += cvtJumlahBayar;
                    totalDiskon += cvtDiskon;
                    jumlahAngsuran += cvtJumlahAngsuran;
                    Date tglAngsuran = null;
                    int cvtJenisAngsuran = -1;
                    String jenisAngsuran = "";
                    try {
                        tglAngsuran = Formater.formatDate(dateStr, "yyyy-MM-dd");
                        cvtJenisAngsuran = Integer.valueOf(jenisAngsuranStr);
                    } catch (Exception e) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", e.toString());
                        printErrorMessage("Gagal Parse Tanggal Angsuran di detail Daftar Transaksi.\n" + e.getMessage());
                    }
                    if (cvtJenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_BUNGA || cvtJenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_POKOK) {
                        jenisAngsuran = "Angsuran";
                    } else {
                        jenisAngsuran = JadwalAngsuran.getTipeAngsuranTitle(cvtJenisAngsuran);
                    }
                    htmlReturn += ""
                            + " <tr>"
                            + "     <td>" + (i + 1) + ".</td>"
                            + "     <td>" + (tglAngsuran == null ? "-" : Formater.formatDate(tglAngsuran, "dd MMM yyyy")) + "</td>"
                            + "     <td>" + (cvtJenisAngsuran < 0 ? "-" : jenisAngsuran) + "</td>"
                            + "     <td class='money text-right'>" + cvtJumlahAngsuran + "</td>"
                            + "     <td class='money text-right'>" + cvtDiskon + "</td>"
                            + "     <td class='money text-right'>" + (cvtJumlahBayar - cvtDiskon) + "</td>"
                            + " </tr>";
                }
//                if (listDetailPembayaran.size() > 1) {
//                    this.htmlReturn += ""
//                            + " <tr>"
//                            + "     <td>1.</td>"
//                            + "     <td>" + Formater.formatDate(jad.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
//                            + "     <td>" + JadwalAngsuran.getTipeAngsuranRadityaTitle(JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA) + "</td>"
//                            + "     <td class='money text-right'>" + jumlahAngsuran + "</td>"
//                            + "     <td class='money text-right'>" + jumlahBayar + "</td>"
//                            + " </tr>";
//                }
//                if (jad.getJumlahANgsuran() < a.getJumlahAngsuran()) {
//                    double biaya = a.getJumlahAngsuran() - jad.getJumlahANgsuran();
//                    this.htmlReturn += ""
//                            + "<tr>"
//                            + "   <td>2.</td>"
//                            + "   <td colspan='3' class='text-center'>Biaya Lain</td>"
//                            + "   <td class='text-right money'>" + biaya + "</td>"
//                            + "</tr>"
//                            + "";
//                }
                Vector<Transaksi> listBiaya = PstTransaksi.list(0, 0, PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_PARENT_ID] + "=" + transaksi.getOID(), "");
                double biaya = 0;
                if (!listBiaya.isEmpty()) {
                    for (Transaksi trans : listBiaya) {
                        Vector<DetailTransaksi> listDetailTransaksi = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + "=" + trans.getOID(), "");
                        if (!listDetailTransaksi.isEmpty()) {
                            for (DetailTransaksi dt : listDetailTransaksi) {
                                biaya += dt.getDebet();
                            }
                        }
                    }
                }
                if (biaya > 0) {
                    totalDibayar += biaya;
                    htmlReturn += ""
                            + "<tr>"
                            + "   <td>" + count + "</td>"
                            + "   <td colspan='4' class='text-center'>Biaya Lain</td>"
                            + "   <td class='text-right money'>" + biaya + "</td>"
                            + "</tr>"
                            + "";
                }
                htmlReturn += ""
                        + " <tr>"
                        + "   <td colspan='6' class='text-right text-bold'>Total : Rp. <span class='money'>" + (totalDibayar-totalDiskon) + "</span></td>"
                        + " </tr>"
                        + "</table>";

                //get jenis payment
                Vector listDetailPayment = PstAngsuranPayment.list(0, 0, "" + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = '" + transaksi.getOID() + "'", "");
                htmlReturn += ""
                        + " <label>Jenis Pembayaran :</label>"
                        + " <table class='table table-bordered' style='font-size: 14px'>"
                        + "     <tr>"
                        + "         <th style='width: 1%'>No.</th>"
                        + "         <th>Tipe Pembayaran</th>"
                        + "         <th>Detail</th>"
                        + "         <th>Nominal</th>"
                        + "     </tr>"
                        + "";
                double totalBayar = 0;
                PaymentSystem ps = new PaymentSystem();
                String keterangan = "";
                for (int i = 0; i < listDetailPayment.size(); i++) {
                    AngsuranPayment ap = (AngsuranPayment) listDetailPayment.get(i);
                    DataTabungan dt = new DataTabungan();
                    AssignContactTabungan act = new AssignContactTabungan();
                    JenisSimpanan js = new JenisSimpanan();
                    totalBayar += ap.getJumlah();
                    try {
                        ps = PstPaymentSystem.fetchExc(ap.getPaymentSystemId());
                        if (ap.getIdSimpanan() != 0) {
                            dt = PstDataTabungan.fetchExc(ap.getIdSimpanan());
                            act = PstAssignContactTabungan.fetchExc(dt.getAssignTabunganId());
                            js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                        }
                    } catch (com.dimata.posbo.db.DBException | DBException e) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", e.toString());
                        printErrorMessage(e.getMessage());
                    }
                    if (ps.getPaymentType() == AngsuranPayment.TIPE_PAYMENT_SAVING) {
                        keterangan += "Nomor tabungan : " + act.getNoTabungan() + " (" + js.getNamaSimpanan() + ")";
                    } else if (ps.getPaymentType() == AngsuranPayment.TIPE_PAYMENT_CREDIT_CARD) {
                        keterangan += "Nama kartu : " + ap.getCardName();
                        keterangan += "Nomor kartu : " + ap.getCardNumber();
                        keterangan += "Nama bank : " + ap.getBankName();
                    } else if (ps.getPaymentType() == AngsuranPayment.TIPE_PAYMENT_DEBIT_CARD) {
                        keterangan += "Nomor kartu : " + ap.getCardNumber();
                        keterangan += "Nama bank : " + ap.getBankName();
                    }
//                    if (listDetailPayment.size() == 1) {
                    htmlReturn += ""
                            + " <tr>"
                            + "     <td>" + (i + 1) + ".</td>"
                            + "     <td>" + ps.getPaymentSystem() + "</td>"
                            + "     <td>" + keterangan + "</td>"
                            + "     <td class='money text-right'>" + ap.getJumlah() + "</td>"
                            + " </tr>";
//                    }
                }
//                if (listDetailPayment.size() > 1) {
//                    this.htmlReturn += ""
//                            + " <tr>"
//                            + "     <td>1.</td>"
//                            + "     <td>" + ps.getPaymentSystem() + "</td>"
//                            + "     <td>" + keterangan + "</td>"
//                            + "     <td class='money text-right'>" + jumlahBayar + "</td>"
//                            + " </tr>";
//                }
                htmlReturn += ""
                        + "<tr>"
                        + "   <td colspan='4' class='text-right text-bold'>Total : Rp. <span class='money'>" + totalBayar + "</span></td>"
                        + "</tr>"
                        + "</table>";

                if (dataFor.equals("getDetailTransaksi")) {
                    if (transaksi.getStatus() != Transaksi.STATUS_DOC_TRANSAKSI_POSTED && (user.getGroupUser() == AppUser.USER_GROUP_ADMIN || user.getGroupUser() == AppUser.USER_GROUP_HO_STAFF)) {
                        if (pinjaman.getOID() != 0 && pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR) {
                            htmlReturn += "<button type='button' class='btn btn-xs btn-default  " + tipeTrans + "'"
                                    + " data-oid='" + transaksi.getOID() + "'>Hapus Transaksi</button>";
                        }
                    }
                    htmlReturn += "&nbsp; <button type='button' class='btn btn-xs btn-default btn_printTransaksi' data-oid='" + transaksi.getOID() + "'>Cetak Transaksi</button>";
                }
                break;

            case Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN:
            case Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN:
            case Transaksi.USECASE_TYPE_KREDIT_PENALTY_DINI_PENCATATAN:
            case Transaksi.USECASE_TYPE_KREDIT_PENALTY_MACET_PENCATATAN:
                htmlReturn += ""
                        + " <table class='table table-bordered' style='font-size: 14px'>"
                        + "     <tr>"
                        + "         <th style='width: 1%'>No.</th>"
                        + "         <th>Jatuh Tempo</th>"
                        + "         <th>Jenis Angsuran</th>"
                        + "         <th>Nilai Angsuran</th>"
                        + "     </tr>"
                        + "";
                Vector<JadwalAngsuran> listJadwalBunga = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TRANSAKSI_ID] + " = " + transaksi.getOID(), PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
                int no = 0;
                double totalAngsuran = 0;
                for (JadwalAngsuran ja : listJadwalBunga) {
                    totalAngsuran += ja.getJumlahANgsuran();
                    no++;
                    htmlReturn += ""
                            + "<tr>"
                            + "     <td>" + no + ".</td>"
                            + "     <td>" + ja.getTanggalAngsuran() + "</td>"
                            + "     <td>" + JadwalAngsuran.getTipeAngsuranTitle(ja.getJenisAngsuran()) + "</td>"
                            + "     <td class='text-right'><div class='money'>" + ja.getJumlahANgsuran() + "</div></td>"
                            + "</tr>";
                }
                if (!listJadwalBunga.isEmpty()) {
                    htmlReturn += "<tr><td colspan='4' class='text-right text-bold'>Total : Rp. <span class='money'>" + totalAngsuran + "</span></td></tr>";
                }
                htmlReturn += "</table>";

                if (dataFor.equals("getDetailTransaksi")) {
                    if (transaksi.getStatus() != Transaksi.STATUS_DOC_TRANSAKSI_POSTED && (user.getGroupUser() == AppUser.USER_GROUP_ADMIN || user.getGroupUser() == AppUser.USER_GROUP_HO_STAFF)) {
                        if (pinjaman.getOID() != 0 && pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR) {
                            htmlReturn += "<button type='button' class='btn btn-xs btn-default " + tipeTrans + "'"
                                    + " data-oid='" + transaksi.getOID() + "'>Hapus Transaksi</button>";
                        }
                    }
                }
                break;

            case Transaksi.USECASE_TYPE_TABUNGAN_SETORAN:
            case Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN:
            case Transaksi.USECASE_TYPE_TABUNGAN_PENUTUPAN:
                htmlReturn += ""
                        + " <table class='table table-bordered table-striped' style='font-size: 14px'>"
                        + "     <tr>"
                        + "         <th class='aksi'>No.</th>"
                        + "         <th>No. Tabungan</th>"
                        + "         <th>Jenis Transaksi</th>"
                        + "         <th>Debet</th>"
                        + "         <th>Kredit</th>"
                        + "     </tr>"
                        + "";

                Vector<DetailTransaksi> listDetail = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + transaksi.getOID(), null);
                int i = 0;
                for (DetailTransaksi dt : listDetail) {
                    JenisTransaksi jt = new JenisTransaksi();
                    AssignContactTabungan act = new AssignContactTabungan();
                    try {
                        jt = PstJenisTransaksi.fetchExc(dt.getJenisTransaksiId());
                        act = PstAssignContactTabungan.fetchExc(PstDataTabungan.fetchExc(dt.getIdSimpanan()).getAssignTabunganId());
                    } catch (Exception e) {
                        objValue.put("RETURN_ERROR_CODE", 1);
                        objValue.put("RETURN_MESSAGE", e.getMessage());
                        printErrorMessage(e.getMessage());
                    }
                    htmlReturn += ""
                            + " <tr>"
                            + "     <td>" + (i + 1) + ".</td>"
                            + "     <td>" + act.getNoTabungan() + "</td>"
                            + "     <td>" + jt.getJenisTransaksi() + "</td>"
                            + "     <td class='text-right'><span class='money'>" + dt.getDebet() + "</span></td>"
                            + "     <td class='text-right'><span class='money'>" + dt.getKredit() + "</span></td>"
                            + " </tr>";
                }
                htmlReturn += "</table>";

                if (dataFor.equals("getDetailTransaksi")) {
                    if (transaksi.getStatus() != Transaksi.STATUS_DOC_TRANSAKSI_POSTED && (user.getGroupUser() == AppUser.USER_GROUP_ADMIN || user.getGroupUser() == AppUser.USER_GROUP_HO_STAFF)) {
                        if (pinjaman.getOID() != 0 && pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR) {
                            htmlReturn += "<button type='button' class='btn btn-xs btn-default  " + tipeTrans + "'"
                                    + " data-oid='" + transaksi.getOID() + "'>Hapus Transaksi</button>";
                        }
                    }
                }
                break;
        }

        if (transaksi.getUsecaseType() == Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN) {

        }

        if (transaksi.getUsecaseType() == Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT) {

        }

        if (transaksi.getUsecaseType() == Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN) {

        }

        if (false && transaksi.getUsecaseType() == Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN) {
            htmlReturn += ""
                    + " <table class='table table-bordered' style='font-size: 14px'>"
                    + "     <tr>"
                    + "         <th style='width: 1%'>No.</th>"
                    + "         <th>Jatuh Tempo</th>"
                    + "         <th>Jenis Angsuran</th>"
                    + "         <th>Nilai Angsuran</th>"
                    + "     </tr>"
                    + "";
            Vector<JadwalAngsuran> listJadwalDenda = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TRANSAKSI_ID] + " = " + transaksi.getOID(), PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
            int no = 0;
            double totalAngsuran = 0;
            for (JadwalAngsuran ja : listJadwalDenda) {
                totalAngsuran += ja.getJumlahANgsuran();
                no++;
                htmlReturn += ""
                        + "<tr>"
                        + "     <td>" + no + ".</td>"
                        + "     <td>" + ja.getTanggalAngsuran() + "</td>"
                        + "     <td>" + JadwalAngsuran.getTipeAngsuranTitle(ja.getJenisAngsuran()) + "</td>"
                        + "     <td class='text-right'><div class='money'>" + ja.getJumlahANgsuran() + "</div></td>"
                        + "</tr>";
            }
            if (!listJadwalDenda.isEmpty()) {
                htmlReturn += "<tr><td colspan='4' class='text-right text-bold'>Total : Rp. <span class='money'>" + totalAngsuran + "</span></td></tr>";
            }
            htmlReturn += "</table>";
            if (dataFor.equals("getDetailTransaksi")) {
                if (transaksi.getStatus() != Transaksi.STATUS_DOC_TRANSAKSI_POSTED
                        && (user.getGroupUser() == AppUser.USER_GROUP_ADMIN || user.getGroupUser() == AppUser.USER_GROUP_HO_STAFF)) {
                    if (pinjaman.getOID() != 0 && pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR) {
                        htmlReturn += "<button type='button' class='btn btn-xs btn-default " + tipeTrans + "'"
                                + " data-oid='" + transaksi.getOID() + "'>Hapus Transaksi</button>";
                    }
                }
            }
        }

        if (transaksi.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_SETORAN || transaksi.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN) {

        }
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject getOptionJenisKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String html = "";
        String where = "";
        String arrayIdSumberDana = FRMQueryString.requestString(request, "SEND_ARRAY_ID_SUMBER_DANA");
        if (!arrayIdSumberDana.equals("all")) {
            where = "(";
            String[] arrayId = arrayIdSumberDana.split(",");
            for (int i = 0; i < arrayId.length; i++) {
                if (i > 0) {
                    where += " OR ";
                }
                where += "sd.`SUMBER_DANA_ID` = '" + arrayId[i] + "'";
            }
            where += ") GROUP BY tk.TYPE_KREDIT_ID";
        }
        Vector listJenisKredit = SessReportKredit.listJoinJenisKreditBySumberDana(where, "");
        for (int i = 0; i < listJenisKredit.size(); i++) {
            AssignSumberDana asd = (AssignSumberDana) listJenisKredit.get(i);
            JenisKredit tk = new JenisKredit();
            try {
                tk = PstTypeKredit.fetchExc(asd.getTypeKreditId());
            } catch (Exception e) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", e.toString());
                printErrorMessage(e.getMessage());
            }
            html += "<option value='" + tk.getOID() + "'>" + tk.getNameKredit() + "</option>";
        }
        objValue.put("FRM_FIELD_HTML",html);
        return objValue;
    }

    public void cekKolektibilitas(HttpServletRequest request) {
        String dateCheck = FRMQueryString.requestString(request, "SEND_DATE_CHECK");
        Vector<Pinjaman> listPinjamanNunggak = PstPinjaman.list(0, 0, ""
                + "" + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'"
                + " OR " + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_LUNAS + "'", "");
        for (int i = 0; i < listPinjamanNunggak.size(); i++) {
            long idPinjaman = listPinjamanNunggak.get(i).getOID();
            Date tglAwalTunggakanPokok = SessReportKredit.getTunggakanKredit(idPinjaman, dateCheck, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
            Date tglAwalTunggakanBunga = SessReportKredit.getTunggakanKredit(idPinjaman, dateCheck, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
            long hariPokok = 0;
            long hariBunga = 0;
            if (tglAwalTunggakanPokok != null) {
                Date jatuhTempoAwal = tglAwalTunggakanPokok;
                Date now = Formater.formatDate(dateCheck, "yyyy-MM-dd");
                long diff = now.getTime() - jatuhTempoAwal.getTime();
                hariPokok = TimeUnit.MILLISECONDS.toDays(diff);
                String hariPokokNunggak = "" + hariPokok;
            }
            if (tglAwalTunggakanBunga != null) {
                Date jatuhTempoAwal = tglAwalTunggakanBunga;
                Date now = Formater.formatDate(dateCheck, "yyyy-MM-dd");
                long diff = now.getTime() - jatuhTempoAwal.getTime();
                hariBunga = TimeUnit.MILLISECONDS.toDays(diff);
                String hariBungaNunggak = "" + hariBunga;
            }
            if (hariPokok != 0 || hariBunga != 0) {

            }
        }
    }

    public JSONObject getPrintOutAngsuranKredit(HttpServletRequest request, long idTransaksi, JSONObject objValue) throws JSONException{
        String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
        Transaksi t = new Transaksi();
        Pinjaman p = new Pinjaman();
        Anggota a = new Anggota();
        try {
            t = PstTransaksi.fetchExc(idTransaksi);
            p = PstPinjaman.fetchExc(t.getPinjamanId());
            a = PstAnggota.fetchExc(p.getAnggotaId());
        } catch (Exception e) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
        }
        String htmlReturn = ""
                + " <div style='width: 50%; float: left;'>"
                + "     <strong style='width: 100%; display: inline-block; font-size: 20px;' id='compName'></strong>"
                + "     <span style='width: 100%; display: inline-block;' id='compAddr'></span>"
                + "     <span style='width: 100%; display: inline-block;' id='compPhone'></span>                    "
                + " </div>"
                + " <div style='width: 50%; float: right; text-align: right'>"
                + "     <span style='width: 100%; display: inline-block; font-weight: 400; font-size: 20px;'>PEMBAYARAN ANGSURAN KREDIT</span>"
                + "     <span style='width: 100%; display: inline-block; font-size: 12px;'>Tanggal &nbsp; : &nbsp; " + Formater.formatDate(new Date(), "dd MMM yyyy / HH:mm:ss") + "</span>"
                + "     <span style='width: 100%; display: inline-block; font-size: 12px;'>No. Transaksi &nbsp; : &nbsp; " + t.getKodeBuktiTransaksi() + "</span>"
                + " </div>"
                + " <div class='clearfix'></div>"
                + "     <hr class='' style='border-color: gray'>"
                + " <div>"
                + "     <span style='width: 120px; float: left;'>Nomor Kredit</span>"
                + "     <span style='width: calc(100% - 120px); float: right;'>:&nbsp;&nbsp; " + p.getNoKredit() + "</span>"
                + " </div>"
                + " <div>"
                + "     <span style='width: 120px; float: left;'>Nama " + namaNasabah + "</span>"
                + "     <span style='width: calc(100% - 120px); float: right;'>:&nbsp;&nbsp; " + a.getName() + "</span>"
                + " </div>"
                + " <div>"
                + "     <span style='width: 120px; float: left;'>Jumlah Pinjaman</span>"
                + "     <span style='width: calc(100% - 120px); float: right;'>:&nbsp;&nbsp; Rp <a style='color: black' class='money'>" + p.getJumlahPinjaman() + "</a></span>"
                + " </div>"
                //+ "                <hr style='border-color: gray'>"
                + " <div class='clearfix'></div>"
                + " <br>"
                + " <div style='width: 60%; float: left;'>"
                + "     <label>Angsuran dibayar :</label>"
                + "     <table class='table table-bordered' style='font-size: 10px'>"
                + "         <thead>"
                + "             <tr>"
                + "                 <th>#</th>"
                + "                 <th>Jatuh Tempo</th>"
                + "                 <th>Jenis Angsuran</th>"
                + "                 <th>Jumlah Angsuran</th>"
                + "                 <th>Jumlah Dibayar</th>"
                + "             </tr>"
                + "         </thead>"
                + "         <tbody>";
        Vector listAngsuran = PstAngsuran.list(0, 0, "" + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = '" + t.getOID() + "'", "");
        double totalAngsuran = 0;
        for (int i = 0; i < listAngsuran.size(); i++) {
            Angsuran angsuran = (Angsuran) listAngsuran.get(i);
            JadwalAngsuran jadwal = new JadwalAngsuran();
            try {
                jadwal = PstJadwalAngsuran.fetchExc(angsuran.getJadwalAngsuranId());
            } catch (Exception e) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", e.toString());
                printErrorMessage(e.getMessage());
            }
            totalAngsuran += angsuran.getJumlahAngsuran();
            htmlReturn += ""
                    + " <tr>"
                    + "     <td>" + (i + 1) + ".</td>"
                    + "     <td>" + Formater.formatDate(jadwal.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
                    + "     <td>" + JadwalAngsuran.getTipeAngsuranTitle(jadwal.getJenisAngsuran()) + "</td>"
                    + "     <td class='money text-right'>" + jadwal.getJumlahANgsuran() + "</td>"
                    + "     <td class='money text-right'>" + angsuran.getJumlahAngsuran() + "</td>"
                    + " </tr>"
                    + "";
        }
        double total = Math.ceil(totalAngsuran);
        long longTotal = (long) (total);
        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
        String con = convert.getText() + " rupiah.";
        String output = con.substring(0, 1).toUpperCase() + con.substring(1);
        htmlReturn += ""
                + "             <tr>"
                + "                 <td colspan='5' class='text-right'>Total : Rp <a style='color: black' class='money'>" + totalAngsuran + "</a></td>"
                + "             </tr>"
                //+ "             <tr>"
                //+ "                 <td colspan='5'>Terbilang (Nilai dibulatkan) : " + output + "</td>"
                //+ "             </tr>"
                + "         </tbody>"
                + "     </table>"
                + " </div>"
                + " <div style='width: 35%; float: right;'>"
                + "     <label>Jenis Pembayaran :</label>"
                + "     <table class='table table-bordered' style='font-size: 10px'>"
                + "         <thead>"
                + "             <tr>"
                + "                 <th>#</th>"
                + "                 <th>Tipe Pembayaran</th>"
                + "                 <th>Nominal</th>"
                + "             </tr>"
                + "         </thead>"
                + "         <tbody>";
        Vector listPayment = PstAngsuranPayment.list(0, 0, "" + PstAngsuranPayment.fieldNames[PstAngsuranPayment.FLD_TRANSAKSI_ID] + " = '" + t.getOID() + "'", "");
        double totalPayment = 0;
        for (int j = 0; j < listPayment.size(); j++) {
            AngsuranPayment payment = (AngsuranPayment) listPayment.get(j);
            PaymentSystem ps = new PaymentSystem();
            try {
                ps = PstPaymentSystem.fetchExc(payment.getPaymentSystemId());
            } catch (Exception e) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", e.toString());
                printErrorMessage(e.getMessage());
            }
            String caraBayar = "";
            if (ps.getPaymentType() == AngsuranPayment.TIPE_PAYMENT_SAVING) {
                caraBayar = "Tabungan";
            } else {
                caraBayar = AngsuranPayment.getTipePaymentTitle(ps.getPaymentType());
            }
            totalPayment += payment.getJumlah();
            htmlReturn += ""
                    + " <tr>"
                    + "     <td>" + (j + 1) + ".</td>"
                    + "     <td>" + caraBayar + "</td>"
                    + "     <td class='money text-right'>" + payment.getJumlah() + "</td>"
                    + " </tr>"
                    + "";
        }
        double total2 = Math.ceil(totalPayment);
        long longTotal2 = (long) (total2);
        ConvertAngkaToHuruf convert2 = new ConvertAngkaToHuruf(longTotal2);
        String con2 = convert2.getText() + " rupiah.";
        String output2 = con2.substring(0, 1).toUpperCase() + con2.substring(1);
        htmlReturn += ""
                + "             <tr>"
                + "                 <td colspan='3' class='text-right'>Total : Rp <a style='color: black' class='money'>" + totalPayment + "</a></td>"
                + "             </tr>"
                //+ "             <tr>"
                //+ "                 <td colspan='3'>Terbilang (Nilai dibulatkan) : " + output2 + "</td>"
                //+ "             </tr>"
                + "         </tbody>"
                + "     </table>"
                + " </div>"
                + " <div class='clearfix'></div>"
                //+ "                <hr style='border-color: gray'>"
                + " <div style='width: 100%;padding-top: 40px;'>"
                + "     <div style='width: 25%;float: left;text-align: center;'>"
                + "         <span>Petugas</span>"
                + "         <br><br><br><br>"
                + "         <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>"
                + "     </div>"
                + "     <div style='width: 25%;float: right;text-align: center;'>"
                + "         <span>" + namaNasabah + "</span>"
                + "         <br><br><br><br>"
                + "         <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>"
                + "     </div>"
                + " </div>"
                + " <div class='clearfix'></div>"
                + " <div style='width: 100%;padding-top: 30px;'>Admin Cetak : <a style='color: black' id='adminCetak'></a></div>"
                + "";
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject getPrintOutNotaTransaksi(HttpServletRequest request, long idTransaksi, JSONObject objValue) throws JSONException{
        String namaCustomer = "-";
        String alamatCustomer = "";
        String namaSales = "-";
        String nomorInduk = "-";
        String noKredit = "-";
        Date tglPengambilan = null;
        String namaItem = "-";//bisa multiple dengan pemisah tanda plus (+)
        Date jatuhTempo = null;
        int angsuranKe = 0;
        double jumlahDiskon = 0;
        double jumlahAngsuran = 0;
        double saldo = 0;
        String namaKolektor = "-";
        String namaAnalis = "-";
        String tglSetoran = "-";
        String tglCetak = Formater.formatDate(new Date(), "dd MMMM yyyy");
        String namaManager = "";
        long oidPinjaman = 0;
        double totalAngsuran = 0;
        Vector listMaterial = new Vector();
        Vector angsuranTotal = new Vector();
        DecimalFormat df = new DecimalFormat("#.##");
        String spasiTTD = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        String spasiLokasi = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        ArrayList<Integer> listAngsurangKe = new ArrayList<>();
        Transaksi t = new Transaksi();
        Location loc = new Location();
        Kabupaten kab = new Kabupaten();
        long oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");
        try {
            //
            t = PstTransaksi.fetchExc(idTransaksi);
            Pinjaman p = PstPinjaman.fetchExc(t.getPinjamanId());
            nomorInduk = t.getKodeBuktiTransaksi();
            noKredit = p.getNoKredit();
            tglSetoran = Formater.formatDate(t.getTanggalTransaksi(), "dd-MM-yyyy");
            //
            Anggota a = PstAnggota.fetchExc(t.getIdAnggota());
            namaCustomer = a.getName();
            alamatCustomer = p.getLokasiPenagihan() == Pinjaman.LOKASI_PENAGIHAN_RUMAH ? a.getAddressPermanent() : a.getOfficeAddress();
            //
            oidPinjaman = p.getOID();
            tglPengambilan = p.getTglRealisasi();
            //
            long oidKol = p.getCollectorId();
            long oidAo = p.getAccountOfficerId();
            Employee analis = new Employee();
            Employee collector = new Employee();

            try {
                analis = PstEmployee.fetchFromApi(oidAo);
                collector = PstEmployee.fetchFromApi(oidKol);
                
                namaAnalis = analis.getFullName().equals("") ? "-" : analis.getFullName();
                namaKolektor = collector.getFullName().equals("") ? "-" : collector.getFullName();
             
                loc = PstLocation.fetchFromApi(oidLocation);
                kab = PstKabupaten.fetchFromApi(loc.getRegencyId());
                
            } catch (Exception e) {
                printErrorMessage(e.toString());
            }
            //
            Date prevJatuhTempo = new Date();
            Vector<Angsuran> listAngsuran = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = " + t.getOID(), "");
            for (Angsuran angsuran : listAngsuran) {
                jumlahAngsuran += angsuran.getJumlahAngsuran();
                jumlahDiskon += angsuran.getDiscAmount();
                JadwalAngsuran jadwal = PstJadwalAngsuran.fetchExc(angsuran.getJadwalAngsuranId());
                jatuhTempo = jadwal.getTanggalAngsuran();
                if (jatuhTempo.compareTo(prevJatuhTempo) > 0 || jatuhTempo.compareTo(prevJatuhTempo) < 0) {
                    String tempWhere = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + oidPinjaman;
                    int angsuranIndex = SessKredit.listAngsuranKe(tempWhere, Formater.formatDate(jatuhTempo, "yyyy-MM-dd"));
                    listAngsurangKe.add(angsuranIndex);
                    prevJatuhTempo = jatuhTempo;
                }

            }
            //
            double pokokDibayar = SessReportKredit.getTotalAngsuranDenganBungaDibayar(p.getOID(), t.getTanggalTransaksi());
            double totalPokok = SessReportKredit.getTotalAngsuranDenganBunga(p.getOID());
            saldo = (totalPokok - pokokDibayar) - jumlahAngsuran;

            //cari total dan sisa angsuran
//            double totalPokok = SessReportKredit.getTotalAngsuran(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_POKOK);
//            double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_POKOK);
            BillMain bm = PstBillMain.fetchExc(p.getBillMainId());
            namaSales = bm.getSalesCode();
//            Sales sales = PstSales.getObjectSales(bm.getSalesCode());
//            namaSales = sales.getName();

            listMaterial = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + bm.getOID(), "");

            //
            angsuranKe = SessKredit.getAngsuranKe(oidPinjaman);

        } catch (DBException | com.dimata.pos.db.DBException e) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
        }

        String listAngsuranOutPrint = "Tidak Ditemukan";
        if (!listAngsurangKe.isEmpty()) {
            String tempText = listAngsurangKe.toString();
            listAngsuranOutPrint = tempText.substring(1, tempText.length() - 1);
        }

        String htmlReturn = ""
                + "<span style=\"font-size: 20px; border-bottom: 2px solid\">" + loc.getName().toUpperCase() + "</span>"
                + "            <div style=\"font-size: 20px\">ELECTRONIC, MESIN, FURNITURE</div>"
                + "            <div style=\"font-size: 16px\">" + loc.getAddress() + " Telp. " + loc.getTelephone() + " - fax. " + loc.getFax() + "</div>"
                + ""
                + "            <br>"
                + ""
                + "            <div class=\"text-center\"><h4><b>BUKTI PEMBAYARAN SEWA BELI</b></h4></div>"
                + "            <p style=\"font-size: 16px\">"
                + "                <span>Sudah terima dari : " + namaCustomer + "</span>"
                + "                <span class=\"pull-right\">Sales : " + namaSales + "</span>"
                + "            </p>"
                + ""
                + "            <table class=\"table table-bordered tabel_data\">"
                + "                <tr class=\"\">"
                + "                    <td>No. Induk</td>"
                + "                    <td>Tgl. Pengambilan</td>"
                + "                    <td colspan=\"2\">Jenis Barang</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>" + noKredit+ "<br>"+nomorInduk+"<br></td>"
                + "                    <td><br>" + tglPengambilan + "<br><br></td>"
                + "                    <td colspan=\"2\">";
        for (int i = 0; i < listMaterial.size(); i++) {
            Billdetail bd = (Billdetail) listMaterial.get(i);
            namaItem = bd.getItemName();
            htmlReturn += "           <br>" + namaItem + "<br>";
        }
        htmlReturn += "         </td>"
                + "                 </tr>"
                + "                <tr class=\"\">"
                + "                    <td>Jatuh Tempo</td>"
                + "                    <td>Angsuran ke</td>"
                + "                    <td>Jumlah Angsuran</td>"
                + "                    <td>Saldo</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td><br>" + jatuhTempo + "<br><br></td>"
                + "                    <td><br>" + listAngsuranOutPrint + "<br><br></td>"
                //                + "                    <td><br>" + angsuranKe + "<br><br></td>"
                + "                    <td><br>Rp. " + FRMHandler.userFormatStringDecimal(jumlahAngsuran - jumlahDiskon) + "<br><br></td>"
                + "                    <td><br>Rp. " + FRMHandler.userFormatStringDecimal(saldo) + "<br><br></td>"
                + "                </tr>"
                + "                <tr class=\"\">"
                + "                    <td>Nama Kolektor</td>"
                + "                    <td>Nama Analis</td>"
                + "                    <td>TTD Kolektor</td>"
                + "                    <td>Tgl. Setoran</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td><br>" + namaKolektor + "<br><br></td>"
                + "                    <td><br>" + namaAnalis + "<br><br></td>"
                + "                    <td></td>"
                + "                    <td><br>" + tglSetoran + "<br><br></td>"
                + "                </tr>"
                + "            </table>"
                + ""
                + "            <div style=\"font-size: 16px\">Alamat : " + alamatCustomer + "</div>"
//                + "            <div style=\"font-size: 16px\" class=\"pull-right\">"
//                + "                <div>" + kab.getNmKabupaten() + ", " + tglCetak + "</div>"
//                + "                <div>" + loc.getName() + "</div>"
//                + "            </div>"
                + "            <br>"
                + "            <table class=\"tabel_sign_nota\" style=\"width: 100%\">"
                + "                <tr>"
                + "                    <td style=\"width: 30%\"></td>"
                + "                    <td style=\"width: 40%\"></td>"
                //+ "                    <td style=\"width: 30%\">" + kab.getNmKabupaten() + ", " + tglCetak + "<br>" + loc.getName().toUpperCase() + "</td>" 
                + "                    <td style=\"width: 40%;text-align:center\"><u>"+spasiLokasi+"</u> , " + tglCetak + "<br>" + loc.getName().toUpperCase() + "</td>" 
                + "                </tr>"
                + "                <tr>"
                + "                    <td><br><br><br></td>"
                + "                    <td><br><br><br></td>"
                + "                    <td><br><br><br></td>" 
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"text-align: center; white-space: nowrap;\">(&nbsp; <u>" + namaCustomer + "</u> &nbsp;)</td>"
                + "                    <td></td>"
                + "                    <td style=\"text-align: center; white-space: nowrap;\">(&nbsp; <u>" + (namaManager.equals("") ? spasiTTD : namaManager) + "</u> &nbsp;)</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"text-align: center;\">Konsumen</td>"
                + "                    <td></td>"
                + "                    <td style=\"text-align: center;\">Manager</td>"
                + "                </tr>"
                + "            </table>"
                + "";
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public String getPrintOutFaktur(long idTransaksi, HttpServletRequest request) {
        String nomorFaktur = "-";
        String namaCustomer = "-";
        String alamatCustomer = "-";
        double jumlahSetoran = 0;
        String setoranTerbilang = "-";
        int angsuranKe = 0;
        double jumlahAngsuran = 0;
        double hargaTotal = 0;
        double materai = 0;
        double notaris = 0;
        double administrasi = 0;
        double transport = 0;
        int jangkaWaktu = 0;
        long setoran = 0;
        String namaItem = "-";//bisa multiple dengan pemisah tanda plus (+)
        String namaSales = "-";
        String kodeSales = "-";
        String namaAnalis = "-";
        String namaKolektor = "-";
        String namaKasir = "-";
        Vector listMaterial = new Vector();
        Vector listTipeBiaya = new Vector();
        String tglCetak = Formater.formatDate(new Date(), "dd-MM-yyyy");
        String spasiTTD = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        long oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");
        Pinjaman p = new Pinjaman();
        Location loc = new Location();
        if (oidLocation != 0) {
            loc = PstLocation.fetchFromApi(oidLocation);
        }
        try {
            Transaksi t = PstTransaksi.fetchExc(idTransaksi);
            nomorFaktur = t.getKodeBuktiTransaksi();
            //
            Anggota a = PstAnggota.fetchExc(t.getIdAnggota());
            namaCustomer = a.getName();
            alamatCustomer = a.getAddressPermanent();
            //
            p = PstPinjaman.fetchExc(t.getPinjamanId());
            hargaTotal = p.getJumlahPinjaman();
            //
            JangkaWaktu jk = new JangkaWaktu();
            try {
                jk = PstJangkaWaktu.fetchExc(p.getJangkaWaktuId());
            } catch (Exception e) {
            }
            jangkaWaktu = jk.getJangkaWaktu();
            //
            long oidKol = p.getCollectorId();
            long oidAo = p.getAccountOfficerId();
            Employee analis = new Employee();
            Employee collector = new Employee();

            String whereAnalis = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + oidAo;
            Vector listAnalist = PstEmployee.getListFromApi(0, 0, whereAnalis, "");
            if (!listAnalist.isEmpty()) {
                analis = (Employee) listAnalist.get(0);
                namaAnalis = analis.getFullName();
            }

            String whereKolektor = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + oidKol;
            Vector listKolektor = PstEmployee.getListFromApi(0, 0, whereKolektor, "");
            if (!listKolektor.isEmpty()) {
                collector = (Employee) listKolektor.get(0);
                namaKolektor = collector.getFullName();
            }
            //
            Vector<Angsuran> listAngsuran = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = " + t.getOID(), "");
            for (Angsuran angsuran : listAngsuran) {
                jumlahSetoran += angsuran.getJumlahAngsuran();

                setoran = (new Double(angsuran.getJumlahAngsuran())).longValue();
            }
            //
            BillMain bm = PstBillMain.fetchExc(p.getBillMainId());
//            Sales sales = PstSales.getObjectSales(bm.getSalesCode());
            namaSales = bm.getSalesCode();
            kodeSales = bm.getSalesCode();
            //
            listMaterial = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + bm.getOID(), "");
            //
            ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(setoran);
            setoranTerbilang = convert.getText();
            //
            listTipeBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                    + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + p.getOID() + "'"
                    + " GROUP BY jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC], "");

        } catch (Exception e) {
//            objValue.put("RETURN_ERROR_CODE", 1);
//            this.objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
        }
        String persen = "";
        String uang = "";
        double valueTransaksi = 0;

        for (int b = 0; b < listTipeBiaya.size(); b++) {
            BiayaTransaksi bt = (BiayaTransaksi) listTipeBiaya.get(b);
            int jumlahData = JenisTransaksi.TIPE_DOC_JUMLAH_DATA[bt.getTipeDoc()];
            Vector listAllBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                    + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + p.getOID() + "'"
                    + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + bt.getTipeDoc() + "'", "");
            for (int c = 0; c < listAllBiaya.size(); c++) {
                BiayaTransaksi biaya = (BiayaTransaksi) listAllBiaya.get(c);
                JenisTransaksi transaksi = new JenisTransaksi();
                try {
                    transaksi = PstJenisTransaksi.fetchExc(biaya.getIdJenisTransaksi());
                } catch (Exception exc) {
                    System.out.println(exc.getMessage());
                }
                if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                    valueTransaksi += hargaTotal * biaya.getValueBiaya() / 100;
                } else if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                    valueTransaksi += biaya.getValueBiaya();
                }
            }
        }
        String html = ""
                + "<span style=\"font-size: 20px; font-family: Times New Roman; border-bottom: 2px solid\"><b>"
                + (loc.getName().equals("") ? "PT. RADITYA DEWATA PERKASA" : loc.getName())
                + "</b></span>"
                + "<div style=\"font-size: 18px; letter-spacing: 1px\"><b>ELECTRONIC, &nbsp; MESIN, &nbsp; FURNITURE</b></div>"
                + "<div style=\"font-size: 15px; font-family: Arial\"><b>"
                + (loc.getAddress().equals("") ? "Jalan Gunung Sanghyang No. 17 R, Padang Sambian, Denpasar" : loc.getAddress())
                + "</b></div>"
                + "<div style=\"font-size: 15px; font-family: Arial\"><b>"
                + "Telp. " + (loc.getTelephone().equals("") ? "(0361) 430461" : loc.getTelephone()) + ", "
                + "Fax " + (loc.getFax().equals("") ? "430462" : loc.getFax())
                + "</b></div>"
                + "<hr style=\"margin: 5px 0px 3px 0px; border-top: 3px solid black\">"
                + "<hr style=\"margin: 0px; border-top: 1px solid black\">"
                + "<br>"
                + "            <table class=\"tabel_info\">"
                + "                <tr>"
                + "                    <td>No. Induk / Faktur</td>"
                + "                    <td>:</td>"
                + "                    <td colspan=\"3\">" + nomorFaktur + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>Sudah terima dari</td>"
                + "                    <td>:</td>"
                + "                    <td colspan=\"3\">" + namaCustomer + " / " + alamatCustomer + "</td>"
                + "                </tr>"
                + "                <tr class=\"uangAngka\">"
                + "                    <td>Banyaknya Uang</td>"
                + "                    <td>:</td>"
                + "                    <td colspan=\"3\">Rp. " + FRMHandler.userFormatStringDecimal(jumlahSetoran) + "</td>"
                + "                </tr>"
                + "                <tr class=\"uangTerbilang\">"
                + "                    <td>Terbilang</td>"
                + "                    <td>:</td>"
                + "                    <td colspan=\"3\">" + setoranTerbilang + "rupiah </td>"
                + "                </tr>"
                + "                <tr class=\"pembayaran\">"
                + "                    <td>Untuk Pembayaran</td>"
                + "                    <td>:</td>"
                + "                    <td>Angsuran I</td>"
                + "                    <td>Rp.&nbsp;&nbsp; <span class=\"pull-right\">" + FRMHandler.userFormatStringDecimal(jumlahSetoran - valueTransaksi) + "</span></td>"
                + "                </tr>";
        for (int b = 0; b < listTipeBiaya.size(); b++) {
            BiayaTransaksi bt = (BiayaTransaksi) listTipeBiaya.get(b);
            int jumlahData = JenisTransaksi.TIPE_DOC_JUMLAH_DATA[bt.getTipeDoc()];
            if (jumlahData == JenisTransaksi.TIPE_DOC_JUMLAH_MULTIPLE) {
                Vector listAllBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                        + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + p.getOID() + "'"
                        + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + bt.getTipeDoc() + "'", "");
                for (int c = 0; c < listAllBiaya.size(); c++) {
                    BiayaTransaksi biaya = (BiayaTransaksi) listAllBiaya.get(c);
                    JenisTransaksi transaksi = new JenisTransaksi();
                    try {
                        transaksi = PstJenisTransaksi.fetchExc(biaya.getIdJenisTransaksi());
                    } catch (Exception exc) {
                        System.out.println(exc.getMessage());
                    }
                    if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                        valueTransaksi = hargaTotal * biaya.getValueBiaya() / 100;
                    } else if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                        valueTransaksi = biaya.getValueBiaya();
                    }
                    html += "          <tr class=\"pembayaran\">"
                            + "                    <td></td>"
                            + "                    <td></td>"
                            + "                    <td>" + transaksi.getJenisTransaksi() + "</td>"
                            + "                    <td>Rp.&nbsp;&nbsp; <span class=\"pull-right money\">" + valueTransaksi + "</span></td>"
                            + "                    </tr>";
                }
            }
        }
        html += "             <tr class=\"pembayaran\">"
                + "                    <td></td>"
                + "                    <td></td>"
                + "                    <td>Harga Total</td>"
                + "                    <td>Rp.&nbsp;&nbsp; <span class=\"pull-right\">" + FRMHandler.userFormatStringDecimal(hargaTotal) + "</span></td>"
                + "                    <td>/ " + jangkaWaktu + " x Angsuran</td>"
                + "                </tr>"
                + "            </table>"
                + ""
                + "            <br>"
                + ""
                + "            <table class=\"tabel_item\">"
                + "                <tr>"
                + "                    <td>Pembelian/sewa beli barang/Type</td>";
        for (int i = 0; i < listMaterial.size(); i++) {
            Billdetail bd = (Billdetail) listMaterial.get(i);
            namaItem = bd.getItemName();
            html += "          <td>:</td>"
                    + "                    <td>" + namaItem + "</td>";
        }
        html += "         </tr>"
                + "            </table>"
                + ""
                + "            <br>"
                + ""
                + "            <table class=\"tabel_person\">"
                + "                <tr>"
                + "                    <td>Sales</td>"
                + "                    <td>:</td>"
                + "                    <td>" + namaSales + " ( " + kodeSales + " )</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>Analis</td>"
                + "                    <td>:</td>"
                + "                    <td>" + namaAnalis + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>Kolektor</td>"
                + "                    <td>:</td>"
                + "                    <td>" + namaKolektor + "</td>"
                + "                </tr>"
                + "            </table>"
                + ""
                + "            <br>"
                + ""
                + "            <table class=\"tabel_sign_faktur\">"
                + "                <tr>"
                + "                    <td></td>"
                + "                    <td></td>"
                + "                    <td></td>"
                + "                    <td style=\"padding-bottom: 10px\">Denpasar, " + tglCetak + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>Bagian Barang</td>"
                + "                    <td>Pengirim</td>"
                + "                    <td>Penerima</td>"
                + "                    <td>Kasir</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td colspan=\"4\"><br><br><br></td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"white-space: nowrap\">(&nbsp; " + spasiTTD + spasiTTD + spasiTTD + spasiTTD + " &nbsp;)</td>"
                + "                    <td style=\"white-space: nowrap\">(&nbsp; " + spasiTTD + spasiTTD + spasiTTD + spasiTTD + " &nbsp;)</td>"
                + "                    <td style=\"white-space: nowrap\">(&nbsp; " + spasiTTD + spasiTTD + spasiTTD + spasiTTD + " &nbsp;)</td>"
                + "                    <td style=\"white-space: nowrap\">(&nbsp; " + namaKasir + " &nbsp;)</td>"
                + "                </tr>"
                + "            </table>"
                + "";
        return html;
    }

    public String getPrintOutAngsuranPertama(HttpServletRequest request) {
        long idPinjaman = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        long userLocationId = FRMQueryString.requestLong(request, "FRM_FIELD_USER_LOCATION");
        String result = "";
        String namaCustomer = "-";
        String alamatCustomer = "-";
        String namaSales = "-";
        String setoranTerbilang = "-";
        String nomorKredit = "-";
        String nomorKwitansi = "-";
        Date tglPengambilan = null;
        String namaItem = "-";//bisa multiple dengan pemisah tanda plus (+)
        Date jatuhTempo = null;
        int angsuranKe = 0;
        double jumlahAngsuran = 0;
        double saldo = 0;
        String namaKolektor = "-";
        String namaAnalis = "-";
        String kodeSales = "-";
        String tglSetoran = "-";
        String tglCetak = Formater.formatDate(new Date(), "dd MMMM yyyy");
        String namaManager = "-";
        double totalAngsuran = 0;
        double totalDibayar = 0;
        double setoran = 0;
        double setoranBiaya = 0;
        double hargaTotal = 0;
        Vector listMaterial = new Vector();
        Vector angsuranTotal = new Vector();
        Vector listTipeBiaya = new Vector();
        boolean isDp = false;
        long oidKol = 0;
        long oidAo = 0;
        Employee analis = new Employee();
        Employee collector = new Employee();
        Location userLocation = new Location();
        Kabupaten userRegency = new Kabupaten();
        DecimalFormat df = new DecimalFormat("#.##");
        String spasiTTD = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        Pinjaman p = new Pinjaman();
        int jangkaWaktu = 0;
        try {
            p = PstPinjaman.fetchExc(idPinjaman);
            nomorKredit = p.getNoKredit();

            //fetch anggota
            Anggota a = PstAnggota.fetchExc(p.getAnggotaId());
            namaCustomer = a.getName();
            alamatCustomer = a.getAddressPermanent();
            tglPengambilan = p.getTglRealisasi();

            //cari jadwal angsuran
            String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID();
            String orderBy = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " ASC ";
            Vector<JadwalAngsuran> jadwalPokokPertama = PstJadwalAngsuran.list(0, 2, whereJadwal, orderBy);
            if (jadwalPokokPertama.isEmpty()) {
//                this.message = "Jadwal angsuran tidak ditemukan !";
//                objValue.put("RETURN_ERROR_CODE", 1);
            }

            //cek data jadwal DP atau angsuran
            JadwalAngsuran jaPertama = jadwalPokokPertama.get(0);
            JadwalAngsuran jaKedua = jadwalPokokPertama.get(jadwalPokokPertama.size() - 1);
            if (jaPertama.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT) {
                if (jaKedua.getJenisAngsuran() != JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT) {
                    isDp = true;
                }
            }

            nomorKwitansi = jaPertama.getNoKwitansi();
            hargaTotal = p.getJumlahPinjaman();

            oidKol = p.getCollectorId();
            oidAo = p.getAccountOfficerId();

            JangkaWaktu jk = new JangkaWaktu();
            try {
                jk = PstJangkaWaktu.fetchExc(p.getJangkaWaktuId());
            } catch (Exception e) {
            }
            jangkaWaktu = jk.getJangkaWaktu();

//            String whereAnalis = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + oidAo;
//            Vector listAnalist = PstEmployee.getListFromApi(0, 0, whereAnalis, "");
            JSONArray analisJson = PstEmployee.fetchEmpDivFromApi(oidAo);
            if (analisJson.length() > 0) {
                JSONObject analisTemp = analisJson.optJSONObject(0);
                PstEmployee.convertJsonToObject(analisTemp, analis);
                namaAnalis = analis.getFullName();
            }

//            String whereKolektor = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + oidKol;
//            Vector listKolektor = PstEmployee.getListFromApi(0, 0, whereKolektor, "");
//                collector = (Employee) listKolektor.get(0);
            JSONArray kolektorJson = PstEmployee.fetchEmpDivFromApi(oidKol);
            if (kolektorJson.length() > 0) {
                JSONObject kolektorTemp = kolektorJson.optJSONObject(0);
                PstEmployee.convertJsonToObject(kolektorTemp, collector);
                namaKolektor = collector.getFullName();
            }

            if (userLocationId != 0) {
                userLocation = PstLocation.fetchFromApi(userLocationId);
                userRegency = PstKabupaten.fetchFromApi(userLocation.getRegencyId());
            }

            //
            //cari total dan sisa angsuran
            if (isDp) {
                jumlahAngsuran = jaPertama.getJumlahANgsuran();
            } else {
                jumlahAngsuran = jaPertama.getJumlahANgsuran() + jaKedua.getJumlahANgsuran();
            }
            setoran = jumlahAngsuran;
            totalAngsuran += SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT);
            totalAngsuran += SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
            totalAngsuran += SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
            totalDibayar += SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT);
            totalDibayar += SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
            totalDibayar += SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
            saldo = totalAngsuran - totalDibayar;

            BillMain bm = PstBillMain.fetchExc(p.getBillMainId());
            namaSales = bm.getSalesCode();
            kodeSales = bm.getSalesCode();

            listMaterial = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + bm.getOID(), "");
            angsuranKe = SessKredit.getAngsuranKe(idPinjaman);

            jatuhTempo = jaPertama.getTanggalAngsuran();

        } catch (DBException | com.dimata.pos.db.DBException e) {
//            objValue.put("RETURN_ERROR_CODE", 1);
//            this.objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
        }

        String listBarang = "";
        for (int i = 0; i < listMaterial.size(); i++) {
            Billdetail bd = (Billdetail) listMaterial.get(i);
            namaItem = bd.getItemName();
            listBarang += "<br>" + namaItem + "<br>";
        }

        listTipeBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + p.getOID() + "'"
                + " GROUP BY jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC], "");

        double valueTransaksi = 0;
        String listBiayaStr = "";
        for (int b = 0; b < listTipeBiaya.size(); b++) {
            BiayaTransaksi bt = (BiayaTransaksi) listTipeBiaya.get(b);
            int jumlahData = JenisTransaksi.TIPE_DOC_JUMLAH_DATA[bt.getTipeDoc()];
            if (jumlahData == JenisTransaksi.TIPE_DOC_JUMLAH_MULTIPLE) {
                Vector listAllBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                        + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + p.getOID() + "'"
                        + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + bt.getTipeDoc() + "'", "");
                for (int c = 0; c < listAllBiaya.size(); c++) {
                    BiayaTransaksi biaya = (BiayaTransaksi) listAllBiaya.get(c);
                    JenisTransaksi transaksi = new JenisTransaksi();
                    try {
                        transaksi = PstJenisTransaksi.fetchExc(biaya.getIdJenisTransaksi());
                    } catch (Exception exc) {
                        System.out.println(exc.getMessage());
                    }
                    if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                        valueTransaksi = p.getJumlahPinjaman() * biaya.getValueBiaya() / 100;
                    } else if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                        valueTransaksi = biaya.getValueBiaya();
                    }
                    listBiayaStr += "          <tr class=\"pembayaran\">"
                            + "                    <td></td>"
                            + "                    <td></td>"
                            + "                    <td>" + transaksi.getJenisTransaksi() + "</td>"
                            + "                    <td>Rp.&nbsp;&nbsp; <span class=\"pull-right money\">" + valueTransaksi + "</span></td>"
                            + "                    </tr>";
                    setoranBiaya += valueTransaksi;
                }
            }
        }
        setoran += setoranBiaya;
        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(new Double(setoran).longValue());
        setoranTerbilang = convert.getText();

        String html = ""
                + "<span style=\"font-size: 24px; font-family: Times New Roman; border-bottom: 2px solid\"><b>" + (userLocation.getName().equals("") ? "PT. RADITYA DEWATA PERKASA" : userLocation.getName().toUpperCase()) + "</b></span>"
                + "<div style=\"font-size: 18px; letter-spacing: 1px\"><b>ELECTRONIC, &nbsp; MESIN, &nbsp; FURNITURE</b></div>"
                + "<div style=\"font-size: 15px; font-family: Arial\"><b>" + userLocation.getAddress() + "</b></div>"
                + "<div style=\"font-size: 15px; font-family: Arial\"><b>Telp. " + userLocation.getTelephone() + ", Fax. " + userLocation.getFax() + "</b></div>"
                + "<hr style=\"margin: 5px 0px 3px 0px; border-top: 3px solid black\">"
                + "<hr style=\"margin: 0px; border-top: 1px solid black\">"
                + "<br>"
                + "            <table class=\"tabel_info\">"
                + "                <tr>"
                + "                    <td style='width: 32%;'>No. Kwitansi</td>"
                + "                    <td style='width: 3%;'>:</td>"
                + "                    <td colspan=\"3\">" + nomorKwitansi + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>No. Kredit</td>"
                + "                    <td>:</td>"
                + "                    <td colspan=\"3\">" + p.getNoKredit() + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>Sudah terima dari</td>"
                + "                    <td>:</td>"
                + "                    <td colspan=\"3\">" + namaCustomer + " / " + alamatCustomer + "</td>"
                + "                </tr>"
                + "                <tr class=\"uangAngka\">"
                + "                    <td>Banyaknya Uang</td>"
                + "                    <td>:</td>"
                + "                    <td colspan=\"3\">Rp. " + FRMHandler.userFormatStringDecimal(setoran) + "</td>"
                + "                </tr>"
                + "                <tr class=\"uangTerbilang\">"
                + "                    <td>Terbilang</td>"
                + "                    <td>:</td>"
                + "                    <td colspan=\"3\">" + setoranTerbilang + "rupiah </td>"
                + "                </tr>"
                + "                <tr class=\"pembayaran\">"
                + "                    <td>Untuk Pembayaran</td>"
                + "                    <td>:</td>"
                + "                    <td>Angsuran I</td>"
                + "                    <td>Rp.&nbsp;&nbsp; <span class=\"pull-right\">" + FRMHandler.userFormatStringDecimal(jumlahAngsuran) + "</span></td>"
                + "                </tr>";

        html += listBiayaStr
                + "             <tr class=\"pembayaran\">"
                + "                    <td></td>"
                + "                    <td></td>"
                + "                    <td>Harga Total</td>"
                + "                    <td>Rp.&nbsp;&nbsp; <span class=\"pull-right\">" + FRMHandler.userFormatStringDecimal(hargaTotal) + "</span></td>"
                + "                    <td>/ " + jangkaWaktu + " x Angsuran</td>"
                + "                </tr>"
                + "            </table>"
                + ""
                + "            <br>"
                + ""
                + "            <table class=\"tabel_item\">"
                + "                <tr>"
                + "                    <td>Pembelian/sewa beli barang/Type</td>";
        for (int i = 0; i < listMaterial.size(); i++) {
            Billdetail bd = (Billdetail) listMaterial.get(i);
            namaItem = bd.getItemName();
            html += "          <td>:</td>"
                    + "                    <td>" + namaItem + "</td>";
        }
        html += "         </tr>"
                + "            </table>"
                + ""
                + "            <br>"
                + ""
                + "            <table class=\"tabel_person\">"
                + "                <tr>"
                + "                    <td>Sales</td>"
                + "                    <td>:</td>"
                + "                    <td>" + namaSales + " ( " + kodeSales + " )</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>Analis</td>"
                + "                    <td>:</td>"
                + "                    <td>" + namaAnalis + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>Kolektor</td>"
                + "                    <td>:</td>"
                + "                    <td>" + namaKolektor + "</td>"
                + "                </tr>"
                + "            </table>"
                + ""
                + "            <br>"
                + ""
                + "            <table class=\"tabel_sign_faktur\">"
                + "                <tr>"
                + "                    <td></td>"
                + "                    <td></td>"
                + "                    <td></td>"
                + "                    <td style=\"padding-bottom: 10px; text-align: right;\" colspan='2'>" + userRegency.getNmKabupaten() + ", " + tglCetak + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>Bagian Barang</td>"
                + "                    <td>Pengirim</td>"
                + "                    <td>Penerima</td>"
                + "                    <td>Kasir</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td colspan=\"4\"><br><br><br></td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"white-space: nowrap\">(&nbsp; " + spasiTTD + spasiTTD + spasiTTD + spasiTTD + " &nbsp;)</td>"
                + "                    <td style=\"white-space: nowrap\">(&nbsp; " + spasiTTD + spasiTTD + spasiTTD + spasiTTD + " &nbsp;)</td>"
                + "                    <td style=\"white-space: nowrap\">(&nbsp; " + spasiTTD + spasiTTD + spasiTTD + spasiTTD + " &nbsp;)</td>"
                + "                    <td style=\"white-space: nowrap\">(&nbsp; " + spasiTTD + spasiTTD + spasiTTD + spasiTTD + " &nbsp;)</td>"
                + "                </tr>"
                + "            </table>"
                + "";
        return html;

    }

    public String getPrintOutNota(long idTransaksi, HttpServletRequest request) {
        String namaCustomer = "-";
        String alamatCustomer = "";
        String namaSales = "-";
        String nomorInduk = "-";
        String noKredit = "-";
        Date tglPengambilan = null;
        String namaItem = "-";//bisa multiple dengan pemisah tanda plus (+)
        Date jatuhTempo = null;
        int angsuranKe = 0;
        double jumlahDiskon = 0;
        double jumlahAngsuran = 0;
        double saldo = 0;
        String namaKolektor = "-";
        String namaAnalis = "-";
        String tglSetoran = "-";
        String tglCetak = Formater.formatDate(new Date(), "dd MMMM yyyy");
        String namaManager = "";
        long oidPinjaman = 0;
        double totalAngsuran = 0;
        Vector listMaterial = new Vector();
        Vector angsuranTotal = new Vector();
        DecimalFormat df = new DecimalFormat("#.##");
        String spasiTTD = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        String spasiLokasi = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        long oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");
        ArrayList<Integer> listAngsurangKe = new ArrayList<>();
        Transaksi t = new Transaksi();
        Location loc = new Location();
        Kabupaten kab = new Kabupaten();
        try {
            //
            t = PstTransaksi.fetchExc(idTransaksi);
            Pinjaman p = PstPinjaman.fetchExc(t.getPinjamanId());
            nomorInduk = t.getKodeBuktiTransaksi();
            noKredit = p.getNoKredit();
            tglSetoran = Formater.formatDate(t.getTanggalTransaksi(), "dd-MM-yyyy");
            //
            Anggota a = PstAnggota.fetchExc(t.getIdAnggota());
            namaCustomer = a.getName();
            alamatCustomer = p.getLokasiPenagihan() == Pinjaman.LOKASI_PENAGIHAN_RUMAH ? a.getAddressPermanent() : a.getOfficeAddress();
            //
            oidPinjaman = p.getOID();
            tglPengambilan = p.getTglRealisasi();
            //
            long oidKol = p.getCollectorId();
            long oidAo = p.getAccountOfficerId();
            Employee analis = new Employee();
            Employee collector = new Employee();

            try {
                analis = PstEmployee.fetchFromApi(oidAo);
                collector = PstEmployee.fetchFromApi(oidKol);
                
                namaAnalis = analis.getFullName().equals("") ? "-" : analis.getFullName();
                namaKolektor = collector.getFullName().equals("") ? "-" : collector.getFullName();
             
                loc = PstLocation.fetchFromApi(oidLocation);
                kab = PstKabupaten.fetchFromApi(loc.getRegencyId());
                
            } catch (Exception e) {
                printErrorMessage(e.toString());
            }
            //
            Date prevJatuhTempo = new Date();
            Vector<Angsuran> listAngsuran = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = " + t.getOID(), "");
            for (Angsuran angsuran : listAngsuran) {
                jumlahAngsuran += angsuran.getJumlahAngsuran();
                jumlahDiskon += angsuran.getDiscAmount();
                JadwalAngsuran jadwal = PstJadwalAngsuran.fetchExc(angsuran.getJadwalAngsuranId());
                jatuhTempo = jadwal.getTanggalAngsuran();
                if (jatuhTempo.compareTo(prevJatuhTempo) > 0 || jatuhTempo.compareTo(prevJatuhTempo) < 0) {
                    String tempWhere = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + oidPinjaman;
                    int angsuranIndex = SessKredit.listAngsuranKe(tempWhere, Formater.formatDate(jatuhTempo, "yyyy-MM-dd"));
                    listAngsurangKe.add(angsuranIndex);
                    prevJatuhTempo = jatuhTempo;
                }

            }
            //
            double pokokDibayar = SessReportKredit.getTotalAngsuranDenganBungaDibayar(p.getOID(), t.getTanggalTransaksi());
            double totalPokok = SessReportKredit.getTotalAngsuranDenganBunga(p.getOID());
            saldo = (totalPokok - pokokDibayar) - jumlahAngsuran;

            //cari total dan sisa angsuran
//            double totalPokok = SessReportKredit.getTotalAngsuran(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_POKOK);
//            double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_POKOK);
            BillMain bm = PstBillMain.fetchExc(p.getBillMainId());
            namaSales = bm.getSalesCode();
//            Sales sales = PstSales.getObjectSales(bm.getSalesCode());
//            namaSales = sales.getName();

            listMaterial = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + bm.getOID(), "");

            //
            angsuranKe = SessKredit.getAngsuranKe(oidPinjaman);

        } catch (DBException | com.dimata.pos.db.DBException e) {
//            objValue.put("RETURN_ERROR_CODE", 1);
//            this.objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
        }

        String listAngsuranOutPrint = "Tidak Ditemukan";
        if (!listAngsurangKe.isEmpty()) {
            String tempText = listAngsurangKe.toString();
            listAngsuranOutPrint = tempText.substring(1, tempText.length() - 1);
        }

        String htmlReturn = ""
                + "<span style=\"font-size: 20px; border-bottom: 2px solid\">" + loc.getName().toUpperCase() + "</span>"
                + "            <div style=\"font-size: 20px\">ELECTRONIC, MESIN, FURNITURE</div>"
                + "            <div style=\"font-size: 16px\">" + loc.getAddress() + " Telp. " + loc.getTelephone() + " - fax. " + loc.getFax() + "</div>"
                + ""
                + "            <br>"
                + ""
                + "            <div class=\"text-center\"><h4><b>BUKTI PEMBAYARAN SEWA BELI</b></h4></div>"
                + "            <p style=\"font-size: 16px\">"
                + "                <span>Sudah terima dari : " + namaCustomer + "</span>"
                + "                <span class=\"pull-right\">Sales : " + namaSales + "</span>"
                + "            </p>"
                + ""
                + "            <table class=\"table table-bordered tabel_data\">"
                + "                <tr class=\"\">"
                + "                    <td>No. Induk</td>"
                + "                    <td>Tgl. Pengambilan</td>"
                + "                    <td colspan=\"2\">Jenis Barang</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td>" + noKredit+ "<br>"+nomorInduk+"<br></td>"
                + "                    <td><br>" + tglPengambilan + "<br><br></td>"
                + "                    <td colspan=\"2\">";
        for (int i = 0; i < listMaterial.size(); i++) {
            Billdetail bd = (Billdetail) listMaterial.get(i);
            namaItem = bd.getItemName();
            htmlReturn += "           <br>" + namaItem + "<br>";
        }
        htmlReturn += "         </td>"
                + "                 </tr>"
                + "                <tr class=\"\">"
                + "                    <td>Jatuh Tempo</td>"
                + "                    <td>Angsuran ke</td>"
                + "                    <td>Jumlah Angsuran</td>"
                + "                    <td>Saldo</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td><br>" + jatuhTempo + "<br><br></td>"
                + "                    <td><br>" + listAngsuranOutPrint + "<br><br></td>"
                //                + "                    <td><br>" + angsuranKe + "<br><br></td>"
                + "                    <td><br>Rp. " + FRMHandler.userFormatStringDecimal(jumlahAngsuran - jumlahDiskon) + "<br><br></td>"
                + "                    <td><br>Rp. " + FRMHandler.userFormatStringDecimal(saldo) + "<br><br></td>"
                + "                </tr>"
                + "                <tr class=\"\">"
                + "                    <td>Nama Kolektor</td>"
                + "                    <td>Nama Analis</td>"
                + "                    <td>TTD Kolektor</td>"
                + "                    <td>Tgl. Setoran</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td><br>" + namaKolektor + "<br><br></td>"
                + "                    <td><br>" + namaAnalis + "<br><br></td>"
                + "                    <td></td>"
                + "                    <td><br>" + tglSetoran + "<br><br></td>"
                + "                </tr>"
                + "            </table>"
                + ""
                + "            <div style=\"font-size: 16px\">Alamat : " + alamatCustomer + "</div>"
//                + "            <div style=\"font-size: 16px\" class=\"pull-right\">"
//                + "                <div>" + kab.getNmKabupaten() + ", " + tglCetak + "</div>"
//                + "                <div>" + loc.getName() + "</div>"
//                + "            </div>"
                + "            <br>"
                + "            <table class=\"tabel_sign_nota\" style=\"width: 100%\">"
                + "                <tr>"
                + "                    <td style=\"width: 30%\"></td>"
                + "                    <td style=\"width: 40%\"></td>"
                //+ "                    <td style=\"width: 30%\">" + kab.getNmKabupaten() + ", " + tglCetak + "<br>" + loc.getName().toUpperCase() + "</td>" 
                + "                    <td style=\"width: 40%;text-align:center\"><u>"+spasiLokasi+"</u> , " + tglCetak + "<br>" + loc.getName().toUpperCase() + "</td>" 
                + "                </tr>"
                + "                <tr>"
                + "                    <td><br><br><br></td>"
                + "                    <td><br><br><br></td>"
                + "                    <td><br><br><br></td>" 
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"text-align: center; white-space: nowrap;\">(&nbsp; <u>" + namaCustomer + "</u> &nbsp;)</td>"
                + "                    <td></td>"
                + "                    <td style=\"text-align: center; white-space: nowrap;\">(&nbsp; <u>" + (namaManager.equals("") ? spasiTTD : namaManager) + "</u> &nbsp;)</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"text-align: center;\">Konsumen</td>"
                + "                    <td></td>"
                + "                    <td style=\"text-align: center;\">Manager</td>"
                + "                </tr>"
                + "            </table>"
                + "";
        return htmlReturn;
    }

    public JSONObject getListCard(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String htmlReturn = "";
        String dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        int paymentType = FRMQueryString.requestInt(request, "SEND_CARA_BAYAR");
        if (dataFor.equals("getListCard")) {
            htmlReturn += ""
                    + " <div class='form-group'>"
                    + "     <label class='col-sm-4'>Tipe Kartu</label>"
                    + "     <div class='col-sm-8'>"
                    + "         <select required='' class='form-control input-sm' id='selectKartu'>"
                    + "             <option value=''>- Pilih Kartu -</option>";

            Vector<PaymentSystem> listCard = PstPaymentSystem.list(0, 0, "" + PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_TYPE] + " = '" + paymentType + "'", "");
            for (int i = 0; i < listCard.size(); i++) {
                htmlReturn += ""
                        + "<option value='" + listCard.get(i).getOID() + "'>" + listCard.get(i).getPaymentSystem() + "</option>";
            }

            htmlReturn += ""
                    + "         </select>"
                    + "     </div>"
                    + " </div>"
                    + "";
        }
        if (paymentType == 0) {
            htmlReturn += ""
                    + " <div class='form-group'>"
                    + "     <label class='col-sm-4'>Nama Kartu</label>"
                    + "     <div class='col-sm-8'>"
                    + "         <input type='text' required='' class='form-control input-sm' id='namaKartu'>"
                    + "     </div>"
                    + " </div>";
        }
        htmlReturn += ""
                + ""
                + " <div class='form-group'>"
                + "     <label class='col-sm-4'>Nomor Kartu</label>"
                + "     <div class='col-sm-8'>"
                + "         <input type='text' required='' class='form-control input-sm' id='nomorKartu'>"
                + "     </div>"
                + " </div>"
                + ""
                + " <div class='form-group'>"
                + "     <label class='col-sm-4'>Nama Bank</label>"
                + "     <div class='col-sm-8'>"
                + "         <input type='text' required='' class='form-control input-sm' id='namaBank'>"
                + "     </div>"
                + " </div>"
                + ""
                + " <div class='form-group'>"
                + "     <label class='col-sm-4'>Tanggal Validasi</label>"
                + "     <div class='col-sm-8'>"
                + "         <input type='text' required='' class='form-control input-sm input_tgl' id='tglValidate'>"
                + "     </div>"
                + " </div>"
                + "";
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject getIdPayment(HttpServletRequest request, JSONObject objValue) throws JSONException{
        int paymentType = FRMQueryString.requestInt(request, "SEND_CARA_BAYAR");
        Vector<PaymentSystem> listPaymentType = PstPaymentSystem.list(0, 0, "" + PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_TYPE] + " = '" + paymentType + "'", "");
        if (listPaymentType.isEmpty()) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE","Tipe pembayaran tidak diketahui !");
        }
        if (!listPaymentType.isEmpty()) {
            objValue.put("RETURN_OID_PAYMENT_TYPE", listPaymentType.get(0).getOID());
//            this.oidPaymentType = ;
        }
        return objValue;
    }

    public synchronized void getSelectKonsumen(HttpServletRequest request) {
        String data = FRMQueryString.requestString(request, "FRM_DATA");
        String where = " cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + data + "%' AND ("
                + " cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "'"
                + ") ";
        Vector listNasabah = SessAnggota.listJoinContactClassAssign(0, 0, where, "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]);
    }

    public JSONObject getSyaratPengajuan(HttpServletRequest request, JSONObject objValue) throws JSONException{
        Pinjaman pinjaman = new Pinjaman();
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        try {
            pinjaman = PstPinjaman.fetchExc(oid);
        } catch (Exception e) {
            objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
        }
        String htmlReturn = "";
        int syaratTerpenuhi = 0;
        //cek data tabungan
        Vector listTabungan = PstDataTabungan.list(0, 0, "" + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = '" + pinjaman.getAssignTabunganId() + "'"
                + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " = '" + pinjaman.getIdJenisSimpanan() + "'", "");
        htmlReturn += ""
                + " <div class='col-sm-12'>"
                + "     <label class='control-label'>Tabungan :</label>";
        if (listTabungan.isEmpty()) {
            htmlReturn += ""
                    + "     <ul class='list-inline'>"
                    + "         <li style='color: red;'>Tidak ada data tabungan.</li>"
                    + "     </ul>";
        } else {
            syaratTerpenuhi += 1;
            htmlReturn += ""
                    + "     <ul class='list-inline'>";
        }
        for (int i = 0; i < listTabungan.size(); i++) {
            DataTabungan dt = (DataTabungan) listTabungan.get(i);
            AssignContactTabungan act = new AssignContactTabungan();
            JenisSimpanan js = new JenisSimpanan();
            try {
                act = PstAssignContactTabungan.fetchExc(dt.getAssignTabunganId());
                js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
            } catch (Exception e) {
                objValue.put("RETURN_MESSAGE", e.toString());
                printErrorMessage(e.getMessage());
            }
            htmlReturn += ""
                    + "         <li> - Nomor Tabungan : <a>" + act.getNoTabungan() + "</a></li> -"
                    + "         <li>Jenis Item : <a>" + js.getNamaSimpanan() + "</a></li>"
                    + "<br>";
        }
        htmlReturn += ""
                + "     </ul>"
                + " </div>";
        //cek penjamin
        Vector listPenjamin = PstPenjamin.list(0, 0, "" + PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID] + " = '" + oid + "'", "");
        htmlReturn += ""
                + ""
                + " <div class='col-sm-12'>"
                + "     <label class='control-label'>Penjamin :</label>";
        if (listPenjamin.isEmpty()) {
            htmlReturn += ""
                    + "     <ul class='list-inline'>"
                    + "         <li style='color: red;'>Tidak ada data Penjamin.</li>"
                    + "     </ul>";
        } else {
            syaratTerpenuhi += 1;
            htmlReturn += ""
                    + "     <ul class='list-inline'>";
        }
        for (int i = 0; i < listPenjamin.size(); i++) {
            Penjamin p = (Penjamin) listPenjamin.get(i);
            AnggotaBadanUsaha abu = new AnggotaBadanUsaha();
            try {
                abu = PstAnggotaBadanUsaha.fetchExc(p.getContactId());
            } catch (Exception e) {
                objValue.put("RETURN_MESSAGE", e.toString());
                printErrorMessage(e.getMessage());
            }
            htmlReturn += ""
                    + "         <li> - Nama Penjamin : <a>" + abu.getName() + "</a></li> -"
                    + "         <li>Persentase Dijamin : <a class='money'>" + p.getProsentasePenjamin() + "</a> %</li>"
                    + "<br>";
        }
        htmlReturn += ""
                + "     </ul>"
                + " </div>";
        //cek agunan
        Vector listAgunan = PstAgunanMapping.list(0, 0, "" + PstAgunanMapping.fieldNames[PstAgunanMapping.FLD_PINJAMAN_ID] + " = '" + oid + "'", "");
        htmlReturn += ""
                + ""
                + " <div class='col-sm-12'>"
                + "     <label class='control-label'>Agunan :</label>";
        if (listAgunan.isEmpty()) {
            htmlReturn += ""
                    + "     <ul class='list-inline'>"
                    + "         <li style='color: red;'>Tidak ada data agunan.</li>"
                    + "     </ul>";
        } else {
            syaratTerpenuhi += 1;
            htmlReturn += ""
                    + "     <ul class='list-inline'>";
        }
        for (int i = 0; i < listAgunan.size(); i++) {
            AgunanMapping am = (AgunanMapping) listAgunan.get(i);
            Agunan a = new Agunan();
            try {
                a = PstAgunan.fetchExc(am.getAgunanId());
            } catch (Exception e) {
                objValue.put("RETURN_MESSAGE", e.toString());
                printErrorMessage(e.getMessage());
            }

            htmlReturn += ""
                    + "         <li> - Nomor Agunan : <a>" + a.getKodeJenisAgunan() + "</a></li> -"
                    + "         <li>Nilai NJOP : Rp. <a class='money'>" + a.getNilaiAgunanNjop() + "</a></li>"
                    + "<br>";
        }
        htmlReturn += ""
                + "     </ul>"
                + " </div>";
        //cek biaya
        //Vector listBiaya = PstBiayaTransaksi.list(0, 0, "" + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + this.oid + "'", "");
        Vector listBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, "bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oid + "'"
                + " AND (jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_UMUM + "'"
                + " OR jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_PERUSAHAAN + "')", "");
        htmlReturn += ""
                + ""
                + " <div class='col-sm-12'>"
                + "     <label class='control-label'>Rincian Biaya :</label>";
        if (listBiaya.isEmpty()) {
            htmlReturn += ""
                    + "     <ul class='list-inline'>"
                    + "         <li style='color: red;'>Tidak ada data biaya.</li>"
                    + "     </ul>";
        } else {
            syaratTerpenuhi += 1;
            htmlReturn += ""
                    + "     <ul class='list-inline'>";
        }
        for (int i = 0; i < listBiaya.size(); i++) {
            BiayaTransaksi bt = (BiayaTransaksi) listBiaya.get(i);
            String tipePersen = "";
            String tipeRupiah = "";
            if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                tipePersen = " %";
                tipeRupiah = "";
            } else if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                tipePersen = "";
                tipeRupiah = "Rp. ";
            }
            JenisTransaksi jt = new JenisTransaksi();
            try {
                jt = PstJenisTransaksi.fetchExc(bt.getIdJenisTransaksi());
            } catch (Exception e) {
                objValue.put("RETURN_MESSAGE", e.toString());
                printErrorMessage(e.getMessage());
            }
            htmlReturn += ""
                    + "         <li> - Jenis Biaya : <a>" + jt.getJenisTransaksi() + "</a></li> -"
                    + "         <li>Jumlah : " + tipeRupiah + "<a class='money'>" + bt.getValueBiaya() + "</a>" + tipePersen + "</li>"
                    + "<br>";
        }
        htmlReturn += ""
                + "     </ul>"
                + " </div>";

        htmlReturn += ""
                + " <div class='col-sm-12'>"
                + "     <hr style='border-color: lightgray'>"
                + " </div>"
                + ""
                + " <div class='col-sm-6'>"
                + "     <label class='control-label'>Status :</label>"
                + "     <select required='' class='form-control input-sm' name='FRM_FIELD_ACTION'>"
                + "         <option selected='' disabled='' style='padding: 5px' value='" + Pinjaman.STATUS_DOC_TO_BE_APPROVE + "'>" + Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_TO_BE_APPROVE) + "</option>";
        if (true || syaratTerpenuhi >= 2) {
            htmlReturn += ""
                    + "         <option style='padding: 5px' value='" + Pinjaman.STATUS_DOC_APPROVED + "'>" + Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_APPROVED) + "</option>";
        }
        htmlReturn += ""
                + "         <option style='padding: 5px' value='" + Pinjaman.STATUS_DOC_DRAFT + "'>" + Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_DRAFT) + "</option>"
                + "         <option style='padding: 5px' value='" + Pinjaman.STATUS_DOC_BATAL + "'>" + Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_BATAL) + "</option>"
                + "         <option style='padding: 5px' value='" + Pinjaman.STATUS_DOC_TIDAK_DISETUJUI + "'>" + Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_TIDAK_DISETUJUI) + "</option>"
                + "     </select>"
                + " </div>"
                + ""
                + " <div class='col-sm-6'>"
                + "     <label class='control-label'>Keterangan Penilaian :</label>"
                + "     <textarea required='' style='resize: none' class='form-control' name='FRM_FIELD_HISTORY' id='FRM_FIELD_HISTORY'></textarea>"
                + " </div>"
                + "";
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        objValue.put("syaratTerpenuhi", syaratTerpenuhi);
        return objValue;
    }

    public JSONObject getJenisSimpananTabungan(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String message = "";
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        try {
            MasterTabungan mt = PstMasterTabungan.fetchExc(oid);
            objValue.put("KODE_TAB", "" + mt.getKodeTabungan());
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        Vector<AssignTabungan> at = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + "=" + oid, "");
        for (int in = 0; in < at.size(); in++) {
            JenisSimpanan js = PstJenisSimpanan.fetchExc(at.get(in).getIdJenisSimpanan());
            if (in == 0) {
                message += js.getNamaSimpanan();
            } else {
                message += ", " + js.getNamaSimpanan();

            }
        }
        objValue.put("RETURN_MESSAGE", message);
        return objValue;
    }

    public JSONObject cekTabungan(HttpServletRequest request, JSONObject objValue) throws JSONException{
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        String htmlReturn = "<option style='padding: 5px' value=''>- Pilih Jenis Simpanan -</option>";
        Vector listSimpanan = SessKredit.listTabunganBebas(0, 0, "asscontab." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = '" + oid + "'"
                + " AND js." + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_FREKUENSI_SIMPANAN] + " = '" + JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS + "'", "");
        for (int i = 0; i < listSimpanan.size(); i++) {
            JenisSimpanan js = (JenisSimpanan) listSimpanan.get(i);
            htmlReturn += "<option style='padding: 5px' value='" + js.getOID() + "'>" + js.getNamaSimpanan() + "</option>";
        }
        if (listSimpanan.isEmpty()) {
            htmlReturn = "<option style='padding: 5px' value=''>- Tidak ada simpanan bebas -</option>";
        }
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject setTglLunas(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String tglTempo = FRMQueryString.requestString(request, "SEND_TGL_TEMPO");
        int jangkaWaktu = FRMQueryString.requestInt(request, "SEND_JANGKA_WAKTU");
        Date tempo = Formater.formatDate(tglTempo, "yyyy-MM-dd");
        Calendar calTempo = Calendar.getInstance();
        calTempo.setTime(tempo);
        calTempo.add(Calendar.MONTH, (jangkaWaktu));
        Date newTempo = calTempo.getTime();
        String finalTempo = Formater.formatDate(newTempo, "yyyy-MM-dd");
        JSONArray jSONArray = new JSONArray();
        JSONObject jo = new JSONObject();
        try {
            jo.put("tgl_tempo", "" + finalTempo);
        } catch (JSONException ex) {
            objValue.put("RETURN_MESSAGE", ex.toString());
            printErrorMessage(ex.getMessage());
        }
        jSONArray.put(jo);
        objValue.put("RETURN_DATA_ARRAY", jSONArray);
        return objValue;
    }

    public JSONObject getDataTabungan(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String htmlReturn = "<option style='padding: 5px' value=''>- Pilih Tabungan -</option>";
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        Vector listTabungan = PstAssignContactTabungan.listJoinGetNoTabungan(0, 0, " asscontab." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_CONTACT_ID] + " = '" + oid + "'"
                + " AND jensim." + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_FREKUENSI_SIMPANAN] + " = '" + JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS + "'", "");
        for (int i = 0; i < listTabungan.size(); i++) {
            AssignContactTabungan act = (AssignContactTabungan) listTabungan.get(i);
            MasterTabungan mt = new MasterTabungan();
            mt = PstMasterTabungan.fetchExc(act.getMasterTabunganId());
            htmlReturn += "<option style='padding: 5px' value='" + act.getOID() + "' data-no='" + act.getNoTabungan() + "' data-nama='" + mt.getNamaTabungan() + "'>" + mt.getNamaTabungan() + " (" + act.getNoTabungan() + ")</option>";
        }
        if (listTabungan.isEmpty()) {
            objValue.put("RETURN_ERROR_CODE", 1);
            htmlReturn = "<option style='padding: 5px' value=''>- Tidak ada tabungan -</option>";
        }
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject getListTabungan(HttpServletRequest request, JSONObject objValue) throws JSONException{
        String htmlReturn = "";
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        String whereJenisSimpanan = "SELECT " + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_ID_JENIS_SIMPANAN] + " FROM " + PstJenisSimpanan.TBL_JENISSIMPANAN + " WHERE " + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_FREKUENSI_PENARIKAN] + " = " + JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS;
        String whereSimpanan = PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA] + " = " + oid
                + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_STATUS] + " = " + I_Sedana.STATUS_AKTIF
                + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " IN (" + whereJenisSimpanan + ")"
                + "";
        Vector<DataTabungan> listTabunganBebas = PstDataTabungan.list(0, 0, whereSimpanan, null);

        if (listTabunganBebas.isEmpty()) {
            htmlReturn = ""
                    + "<tr>"
                    + "<td colspan='4'>Tidak ada data tabungan.</td>"
                    + "</tr>";
        }
        for (int i = 0; i < listTabunganBebas.size(); i++) {
            DataTabungan dt = listTabunganBebas.get(i);
            double saldo = PstDetailTransaksi.getSimpananSaldo(dt.getOID());
            AssignContactTabungan act = new AssignContactTabungan();
            JenisSimpanan js = new JenisSimpanan();
            try {
                act = PstAssignContactTabungan.fetchExc(dt.getAssignTabunganId());
                js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
            } catch (Exception e) {
                objValue.put("RETURN_MESSAGE", e.toString());
                printErrorMessage(e.getMessage());
            }
            String disabled = (saldo <= 0) ? "disabled" : "";
            htmlReturn += ""
                    + "<tr>"
                    + "<td>" + (i + 1) + ".</td>"
                    + "<td>" + act.getNoTabungan() + "</td>"
                    + "<td>" + js.getNamaSimpanan() + "</td>"
                    + "<td class='money'>" + saldo + "</td>"
                    + "<td class='text-center'><button type='button' " + disabled + " class='btn btn-xs btn-warning btn-pilihtabungan' data-idsimpanan='" + dt.getOID() + "' data-oid='" + act.getOID() + "' data-notab='" + act.getNoTabungan() + "' data-saldo='" + saldo + "'>Pilih</button></td>"
                    + "</tr>"
                    + "";
        }
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        return objValue;
    }

    public JSONObject getDataKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        objValue.put("RETURN_MESSAGE", "");
        Pinjaman p = new Pinjaman();
        Anggota a = new Anggota();
        JenisKredit tk = new JenisKredit();
        KolektibilitasPembayaran kolektibilitas = new KolektibilitasPembayaran();
        JangkaWaktu jk = new JangkaWaktu();
        
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");

        try {
            p = PstPinjaman.fetchExc(oid);
            a = PstAnggota.fetchExc(p.getAnggotaId());
            tk = PstTypeKredit.fetchExc(p.getTipeKreditId());
            jk = PstJangkaWaktu.fetchExc(p.getJangkaWaktuId());
            kolektibilitas = PstKolektibilitasPembayaran.fetchExc(p.getKodeKolektibilitas());
        } catch (Exception e) {
            objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
            return objValue;
        }
        String analis = "-";
//        JSONArray jArr = new JSONArray();
//        JSONArray array = new JSONArray();
        try {
            Employee analisObj = new Employee();
            JSONArray analisArr = PstEmployee.fetchEmpDivFromApi(p.getAccountOfficerId());
            PstEmployee.convertJsonToObject(analisArr.optJSONObject(0), analisObj);
            analis = analisObj.getFullName();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
//        String hrApiUrl = PstSystemProperty.getValueByName("HARISMA_URL");
//        String whereAnalis = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = '" + p.getAccountOfficerId() + "'";
//        String param = "limitStart=" + WebServices.encodeUrl("" + 0) + "&recordToGet=" + WebServices.encodeUrl("" + 0)
//                + "&whereClause=" + WebServices.encodeUrl(whereAnalis) + "&order=" + WebServices.encodeUrl("");
//        JSONObject joo = WebServices.getAPIWithParam("", hrApiUrl + "/employee/employee-list", param);
//        try {
//            jArr = joo.getJSONArray("DATA");
//        } catch (Exception e) {
//        }
//        if (jArr.length() > 0) {
//            for (int i = 0; i < jArr.length(); i++) {
//                try {
//                    JSONObject tempObj = jArr.getJSONObject(i);
//                    JSONArray ja = new JSONArray();
//                    Analis = tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-");
//                } catch (Exception e) {
//                }
//            }
//        }

        String kolektor = "-";
        try {
            Employee kolektorObj = new Employee();
            JSONArray kolektorArr = PstEmployee.fetchEmpDivFromApi(p.getCollectorId());
            PstEmployee.convertJsonToObject(kolektorArr.optJSONObject(0), kolektorObj);
            kolektor = kolektorObj.getFullName();
        } catch (Exception e) {
            System.out.println(e.toString());
        }

//        String whereKolektor = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = '" + p.getCollectorId() + "'";
//        param = "limitStart=" + WebServices.encodeUrl("" + 0) + "&recordToGet=" + WebServices.encodeUrl("" + 0)
//                + "&whereClause=" + WebServices.encodeUrl(whereKolektor) + "&order=" + WebServices.encodeUrl("");
//        JSONObject jooo = WebServices.getAPIWithParam("", hrApiUrl + "/employee/employee-list", param);
//        try {
//            jArr = jooo.getJSONArray("DATA");
//        } catch (Exception e) {
//        }
//        if (jArr.length() > 0) {
//            for (int i = 0; i < jArr.length(); i++) {
//                try {
//                    JSONObject tempObj = jArr.getJSONObject(i);
//                    JSONArray ja = new JSONArray();
//                    kolektor = tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-");
//                } catch (Exception e) {
//                }
//            }
//        }
        //cari total dan sisa angsuran
        double totalPokok = SessReportKredit.getTotalAngsuran(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_POKOK);
        double totalBunga = SessReportKredit.getTotalAngsuran(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_BUNGA);
        double totalDenda = SessReportKredit.getTotalAngsuran(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_DENDA);
        double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_POKOK);
        double bungaDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_BUNGA);
        double dendaDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), Transaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_DENDA);
        double sisaPokok = totalPokok - pokokDibayar;
        double sisaBunga = totalBunga - bungaDibayar;
        double sisaDenda = totalDenda - dendaDibayar;

        //get real total angsuran
        double totalAngsuran = SessKredit.getTotalAngsuran(p.getOID());
        double totalDibayar = SessKredit.getTotalAngsuranDibayar(p.getOID());

        //pembulatan 2 angka di belakang koma
        DecimalFormat df = new DecimalFormat("#.##");
        double newAngsuran = Double.valueOf(df.format(totalAngsuran));
        double newDibayar = Double.valueOf(df.format(totalDibayar));
        double realSisaAngsuran = newAngsuran - newDibayar;

        double newTotalPokok = Double.valueOf(df.format(totalPokok));
        double newTotalBunga = Double.valueOf(df.format(totalBunga));
        double newTotalDenda = Double.valueOf(df.format(totalDenda));
        double newSisaPokok = Double.valueOf(df.format(sisaPokok));
        double newSisaBunga = Double.valueOf(df.format(sisaBunga));
        double newSisaDenda = Double.valueOf(df.format(sisaDenda));

        //cek jadwal yg belum di bayar
        String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "' AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " NOT IN (" + queryGetIdJadwalDibayar(p.getOID()) + ")";
        int jadwalBelumDibayar = PstJadwalAngsuran.getCount(where);

        //cek apakah tipe kredit adalah kredit barang
        boolean kreditBarang = false;
        String typeCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
        if (typeCredit.equals("1") && p.getBillMainId() != 0) {
            //cek apakah sudah ada jadwal yg dibayar
            Vector angsuran = SessKredit.getListAngsuranByPinjaman(p.getOID());
            if (angsuran.isEmpty()) {
                kreditBarang = true;
            }

            //cari data biaya yg belum dibayar
            String whereBiaya = PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = " + p.getOID()
                    + " AND " + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_VALUE_BIAYA] + " > 0 ";
            Vector<BiayaTransaksi> listBiaya = PstBiayaTransaksi.list(0, 0, whereBiaya, "");
            String html = "";
            for (BiayaTransaksi bt : listBiaya) {
                //cek apakah biaya sudah dibayar
                int count = SessKredit.getCountTransaksiBiayaKredit(p.getOID(), bt.getIdJenisTransaksi());
                if (count == 0) {
                    try {
                        JenisTransaksi jt = PstJenisTransaksi.fetchExc(bt.getIdJenisTransaksi());
                        double biaya = 0;
                        String infoBiaya = "";
                        if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                            biaya = p.getJumlahPinjaman() * (bt.getValueBiaya() / 100);
                            infoBiaya = "<div class='input-group'><input type='text' readonly='' class='form-control input-sm money' value='" + bt.getValueBiaya() + "'><span class='input-group-addon'>%</span></div>";
                        } else if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                            biaya = bt.getValueBiaya();
                            infoBiaya = "<div class='input-group'><span class='input-group-addon'>Rp</span><input type='text' readonly='' class='form-control input-sm money' value='" + bt.getValueBiaya() + "'></div>";
                        }
                        html += ""
                                + "<tr>"
                                + " <td>"
                                + "     <input type='text' readonly='' class='form-control input-sm' value='" + jt.getJenisTransaksi() + "'>"
                                + "     <input type='hidden' name='FRM_ID_JENIS_TRANSAKSI' class='dataOid' value='" + jt.getOID() + "'>"
                                + " </td>"
                                + " <td>" + infoBiaya + "</td>"
                                + " <td>"
                                + "     <input type='text' readonly='' data-cast-class='valBiaya' class='form-control input-sm money' name='FRM_BIAYA_DIBAYAR' value='" + biaya + "'>"
                                + "     <input type='hidden' class='valBiaya' value='" + biaya + "'>"
                                + " </td>"
                                + "</tr>";
                    } catch (Exception e) {
                    }
                }
            }

            if (!html.isEmpty()) {
                html = ""
                        + " <label>Biaya :</label>"
                        + " <table style='width: 100%' class='table table-bordered'>"
                        + "     <tr>"
                        + "         <th>Jenis Biaya</th>"
                        + "         <th>Nilai</th>"
                        + "         <th>Jumlah Dibayar</th>"
                        + html
                        + "     </tr>"
                        + " </table>"
                        + "";
                try {
                    objValue.put("RETURN_HTML_BIAYA_KREDIT", html);
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                }
            }
        }
        
        JSONArray jsonArrayDataKredit = new JSONArray();
        if (objValue.optString("message","").equals("")) {
            JSONObject jo = new JSONObject();

            try {
                jo.put("id_pinjaman", p.getOID());
                jo.put("nomor_kredit", "" + p.getNoKredit());
                jo.put("jenis_kredit", "" + tk.getNameKredit());
                jo.put("nomor_nasabah", "" + a.getNoAnggota());
                jo.put("nama_nasabah", "" + a.getName());
                jo.put("id_nasabah", "" + a.getOID());
                jo.put("alamat_nasabah", "" + a.getAddressPermanent());
                jo.put("jumlah_pinjaman", "" + p.getJumlahPinjaman());
                jo.put("suku_bunga", "" + p.getSukuBunga());
                jo.put("jenis_bunga", "" + Pinjaman.TIPE_BUNGA_TITLE[p.getTipeBunga()]);
                jo.put("jangka_waktu", "" + jk.getJangkaWaktu());
                jo.put("tgl_pengajuan", "" + Formater.formatDate(p.getTglPengajuan(), "yyyy-MM-dd"));
                jo.put("tgl_realisasi", "" + Formater.formatDate(p.getTglRealisasi(), "yyyy-MM-dd"));
                jo.put("tgl_tempo", "" + Formater.formatDate(p.getJatuhTempo(), "yyyy-MM-dd"));
                jo.put("total_pokok", "" + newTotalPokok);
                jo.put("total_bunga", "" + newTotalBunga);
                jo.put("total_denda", "" + newTotalDenda);
                jo.put("sisa_pokok", "" + newSisaPokok);
                jo.put("sisa_bunga", "" + newSisaBunga);
                jo.put("sisa_denda", "" + newSisaDenda);
                jo.put("macet", kolektibilitas.getTingkatResiko() >= 90 ? "true" : "false");
                jo.put("tipe_bunga", "" + p.getTipeBunga());
                jo.put("sisa_angsuran", realSisaAngsuran);
                jo.put("jadwal_belum_dibayar", jadwalBelumDibayar);
                jo.put("analis", "" + analis);
                jo.put("kolektor", "" + kolektor);
                if (kreditBarang) {
                    jo.put("show_btn_dp", true);
                }
                jsonArrayDataKredit.put(jo);
                objValue.put("RETURN_DATA_KREDIT", jsonArrayDataKredit);
            } catch (JSONException ex) {
                objValue.put("RETURN_MESSAGE", ex.toString());
                printErrorMessage(ex.getMessage());
            }
        }
        return objValue;
    }

    public JSONObject getDataKreditForHapus(HttpServletRequest request, JSONObject objValue) throws JSONException{
        Pinjaman p = new Pinjaman();
        Anggota a = new Anggota();
        JenisKredit tk = new JenisKredit();
        JangkaWaktu jk = new JangkaWaktu();
        BillMain bm = new BillMain();
        Location loc = new Location();
        
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        try {
            p = PstPinjaman.fetchExc(oid);
            a = PstAnggota.fetchExc(p.getAnggotaId());
            tk = PstTypeKredit.fetchExc(p.getTipeKreditId());
            jk = PstJangkaWaktu.fetchExc(p.getJangkaWaktuId());
        } catch (Exception e) {
            objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
            return objValue;
        }
        
        long cbmOid = p.getBillMainId();
        
        String Analis = "";
        JSONArray jArr = new JSONArray();
        JSONArray array = new JSONArray();
        String hrApiUrl = PstSystemProperty.getValueByName("HARISMA_URL");
        String kolektor = "";

        String url = hrApiUrl + "/employee/employee-fetch/" + p.getAccountOfficerId();
        JSONObject jooo = WebServices.getAPI("", url);
        if (jooo.length() > 0) {

            Analis = jooo.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-");

        }

        String url1 = hrApiUrl + "/employee/employee-fetch/" + p.getCollectorId();
        JSONObject joo = WebServices.getAPI("", url1);
        if (joo.length() > 0) {

            kolektor = joo.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-");

        }

        Date dateNow = new Date();
        String dateCheck = Formater.formatDate(dateNow, "yyyy-MM-dd");
        double jumlahDP = PstJadwalAngsuran.sumJadwalAngsuran(oid, ""+JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT);
        double jumlahPokok = PstJadwalAngsuran.sumJadwalAngsuran(oid, ""+JadwalAngsuran.TIPE_ANGSURAN_POKOK);
        double jumlahPokokDibayar = PstJadwalAngsuran.sumJadwalAngsuranDibayar(oid, ""+JadwalAngsuran.TIPE_ANGSURAN_POKOK);
        double jumlahBunga = PstJadwalAngsuran.sumJadwalAngsuran(oid, ""+JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
        double jumlahBungaDibayar = PstJadwalAngsuran.sumJadwalAngsuranDibayar(oid, ""+JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
        int jangkaWaktuDibayar = PstJadwalAngsuran.countAngsuranDibayar(oid);
        int addDp = 0;
        if (jumlahDP >0){
            addDp = 1;
        }
        
        String whereClause = PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + " = " + cbmOid;
        Vector<Billdetail> listItem = PstBillDetail.list(0, 0, whereClause, "");
        int start = 0;
        String html = "";
        html += "<h4>Daftar Barang</h4>"
                + "<table id='return-table' class='table table-bordered table-striped table-responsive'>"
                + "<thead>"
                + "<tr>"
                + "<th style=\"width: 5%\"> No </th>"
                + "<th style=\"width: 10%\"> SKU </th>"
                + "<th style=\"width: 20%\"> Nama Barang </th>"
                + "<th style=\"width: 5%\"> Qty </th>"
                +"</tr>"
                + "</thead>"
                + "<tbody>";
        
        for (Billdetail bd : listItem) {
            start++;
            html += ""
                    + "<tr>"
                    + " <td class='text-center'>"
                    + start + "<input type='hidden' name='OID_"+bd.getOID()+"' class='form-control'>"
                    + "<input type='hidden' name='OID_DETAIL' value='"+bd.getOID()+"' class='form-control'>"
                    + "<input type='hidden' name='MATERIAL_ID_"+bd.getOID()+"' value='"+bd.getMaterialId()+"' class='form-control'>"
                    + "<input type='hidden' name='HPP_"+bd.getOID()+"' value='"+bd.getCost()+"' class='form-control'>"
                    + "<input type='hidden' name='QTY_"+bd.getOID()+"' value='"+(int) bd.getQty()+"' class='form-control'>"
                    + "</td>"
                    + " <td class='text-center'>" 
                    + bd.getSku()
                    + "</td>"
                    + " <td class='text-center'>" 
                    + bd.getItemName()
                    + "</td>"
                    + " <td class='text-center'>" 
                    + bd.getQty() 
                    + "</td>";
                    html+= "</tr>";

        }
        html += "</tbody>"
                + "</table>";
        try {
            objValue.put("RETURN_HTML_BIAYA_KREDIT", html);
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        JSONArray jsonArrayDataKredit = new JSONArray();
        if (objValue.optString("message", "").equals("")) {
            JSONObject jo = new JSONObject();

            try {
                jo.put("nomor_kredit", "" + p.getNoKredit());
                jo.put("jenis_kredit", "" + tk.getNameKredit());
                jo.put("nama_nasabah", "" + a.getName());
                jo.put("id_nasabah", "" + a.getOID());
                jo.put("analis", "" + Analis);
                jo.put("kolektor", "" + kolektor);
                jo.put("location", "" + loc.getName());
                jo.put("billoid", "" + cbmOid);
                jo.put("pokok", "" + jumlahPokok);
                jo.put("bunga", "" + jumlahBunga);
                jo.put("nilaiAngsuran", "" + (jumlahBunga+jumlahPokok));
                jo.put("dibayar", "" + (jumlahBungaDibayar+jumlahPokokDibayar+jumlahDP));
                jo.put("cbmOid", "" + cbmOid);
                jo.put("pinjaman", "" + p.getOID());
                jo.put("saldo", "" + ((jumlahBunga+jumlahPokok) - (jumlahBungaDibayar+jumlahPokokDibayar)));
                jo.put("jangkaWaktu", "" + (p.getJangkaWaktu()+addDp));
                jo.put("sisaWaktu", "" + (p.getJangkaWaktu() +addDp - jangkaWaktuDibayar));
                jo.put("sisaPokok", "" + (jumlahPokok - jumlahPokokDibayar));
                jo.put("sisaBunga", "" + (jumlahBunga - jumlahBungaDibayar));
                jo.put("DP", "" + jumlahDP);
                jsonArrayDataKredit.put(jo);
                objValue.put("RETURN_DATA_KREDIT", jsonArrayDataKredit);
            } catch (JSONException ex) {
                objValue.put("RETURN_MESSAGE", ex.toString());
                printErrorMessage(ex.getMessage());
            }
        }
        
        return objValue;
    }
    
    public JSONObject getDataKreditForReturn(HttpServletRequest request, JSONObject objValue) throws JSONException{
        objValue.put("RETURN_MESSAGE", "");
        Pinjaman p = new Pinjaman();
        Anggota a = new Anggota();
        JenisKredit tk = new JenisKredit();
        KolektibilitasPembayaran kolektibilitas = new KolektibilitasPembayaran();
        JangkaWaktu jk = new JangkaWaktu();
        BillMain bm = new BillMain();
        Location loc = new Location();
        double nilaiHpp = 0;
        double nilaiInventori = 0;
        
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");

        try {
            p = PstPinjaman.fetchExc(oid);
            a = PstAnggota.fetchExc(p.getAnggotaId());
            tk = PstTypeKredit.fetchExc(p.getTipeKreditId());
            jk = PstJangkaWaktu.fetchExc(p.getJangkaWaktuId());
            kolektibilitas = PstKolektibilitasPembayaran.fetchExc(p.getKodeKolektibilitas());
        } catch (Exception e) {
            objValue.put("RETURN_MESSAGE", e.toString());
            printErrorMessage(e.getMessage());
            return objValue;
        }

        String Analis = "";
        JSONArray jArr = new JSONArray();
        JSONArray array = new JSONArray();
        String hrApiUrl = PstSystemProperty.getValueByName("HARISMA_URL");
        String kolektor = "";

        String url = hrApiUrl + "/employee/employee-fetch/" + p.getAccountOfficerId();
        JSONObject jooo = WebServices.getAPI("", url);
        if (jooo.length() > 0) {

            Analis = jooo.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-");

        }

        String url1 = hrApiUrl + "/employee/employee-fetch/" + p.getCollectorId();
        JSONObject joo = WebServices.getAPI("", url1);
        if (joo.length() > 0) {

            kolektor = joo.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-");

        }

        Date dateNow = new Date();
        String dateCheck = Formater.formatDate(dateNow, "yyyy-MM-dd");
        Date tglAwalTunggakanPokok = getTunggakanKredit(p.getOID(), dateCheck, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
        long hariPokok = 0;
        long hariBunga = 0;
        long tunggakan = 0;
        long diff = 0;
        if (tglAwalTunggakanPokok != null) {
            Date jatuhTempoAwal = tglAwalTunggakanPokok;
            Date now = Formater.formatDate(dateCheck, "yyyy-MM-dd");
            diff = now.getTime() - jatuhTempoAwal.getTime();
        }

        tunggakan = TimeUnit.MILLISECONDS.toDays(diff);
        long cbmOid = p.getBillMainId();
        try {
            bm = PstBillMain.fetchExc(cbmOid);
            long locationId = bm.getLocationId();
            loc = PstLocation.fetchExc(locationId);

        } catch (Exception e) {
        }

        double angsuranBelumDibayar = 0;
        double sisaTunggakan = 0;
        int angsDp = 0;
        double DP = 0;
        String whereDp = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oid + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT;
        Vector listJadwalDp = PstJadwalAngsuran.list(0, 0, whereDp, "");
        for (int xx = 0; xx < listJadwalDp.size();xx++){
            JadwalAngsuran jad = (JadwalAngsuran) listJadwalDp.get(xx);
            DP += jad.getJumlahANgsuran();
            double totalAngsuran = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jad.getOID() + "'");
            double sisa = jad.getJumlahANgsuran() - totalAngsuran;
            if (sisa>0){
                angsuranBelumDibayar += sisa / totalAngsuran;
                sisaTunggakan += sisa;
            }
            angsDp++;
        }
        
        String whereAdd = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oid + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
        Vector listJadwalPokok = PstJadwalAngsuran.list(0, 0, whereAdd, "");
        double nilaiAngsuran = 0;
        for (int xx = 0; xx < listJadwalPokok.size();xx++){
            JadwalAngsuran jad = (JadwalAngsuran) listJadwalPokok.get(xx);
            double totalAngsuran = 0;
            double newTotal = 0;
            String tglAngsuran = Formater.formatDate(jad.getTanggalAngsuran(), "yyyy-MM-dd");
            Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.getAngsuranWithBunga(jad.getPinjamanId(), tglAngsuran);
            for (JadwalAngsuran jada : listAngsuran) {
                totalAngsuran = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jada.getOID() + "'");
                nilaiAngsuran+= jada.getJumlahANgsuran();
                newTotal += totalAngsuran;
            }
            double jumlahAngsuran = PstJadwalAngsuran.getJumlahAngsuranWithBunga(jad.getPinjamanId(), tglAngsuran);
            double sisa = jumlahAngsuran - newTotal;
            if (sisa>0){
                angsuranBelumDibayar += sisa / jumlahAngsuran;
                sisaTunggakan += sisa;
            }
        }
        
        int jenisReturn = FRMQueryString.requestInt(request, "JENIS_RETURN");
        String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        String whereClause = PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + " = " + cbmOid;
        Vector<Billdetail> listItem = PstBillDetail.list(0, 0, whereClause, "");
        int start = 0;
        String html = "";
        html += "<h4>Daftar Barang</h4>"
                + "<table id='return-table' class='table table-bordered table-striped table-responsive'>"
                + "<thead>"
                + "<tr>"
                + "<th style=\"width: 5%\"> No </th>"
                + "<th style=\"width: 10%\"> SKU </th>"
                + "<th style=\"width: 20%\"> Nama Barang </th>"
                + "<th style=\"width: 10%\"> Nilai Hpp </th>"
                + "<th style=\"width: 10%\"> Nilai Persediaan </th>"
                + "<th style=\"width: 5%\"> Qty </th>";
                if (jenisReturn == ReturnKredit.JENIS_RETURN_CABUTAN){
                html += "<th style=\"width: 10%\"> SKU Baru </th>"
                + "<th style=\"width: 30%\"> Nama Barang Baru </th>";
                }
                html+= "</tr>"
                + "</thead>"
                + "<tbody>";
        
        for (Billdetail bd : listItem) {
            JSONObject jo = new JSONObject();
            try {
                String urlMat = posApiUrl + "/material/material-credit/" + bd.getMaterialId();
                jo = WebServices.getAPI("", urlMat);
                //mat = PstMaterial.fetchExc(bd.getMaterialId());
                nilaiHpp += bd.getCost();
            } catch (Exception e) {
            }
            double nilaiHppPerbulan = bd.getCost() / (double) (p.getJangkaWaktu() + angsDp);
            double nilaiPersediaan = 0;
            if (jenisReturn == ReturnKredit.JENIS_RETURN_CABUTAN){
                nilaiPersediaan = angsuranBelumDibayar * nilaiHppPerbulan;
            } else {
                nilaiPersediaan = bd.getCost();
            }
            start++;
            Vector listReturnItem = PstReturnKreditItem.list(0, 1, PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_CASH_BILL_DETAIL_ID]+"="+bd.getOID(), "");
            ReturnKreditItem ret = new ReturnKreditItem();
            if (listReturnItem.size()>0){
                ret = (ReturnKreditItem) listReturnItem.get(0);
            }
            html += ""
                    + "<tr>"
                    + " <td class='text-center'>"
                    + start + "<input type='hidden' name='OID_"+bd.getOID()+"' value='"+ret.getOID()+"' class='form-control'>"
                    + "<input type='hidden' name='OID_DETAIL' value='"+bd.getOID()+"' class='form-control'>"
                    + "<input type='hidden' name='MATERIAL_ID_"+bd.getOID()+"' value='"+bd.getMaterialId()+"' class='form-control'>"
                    + "<input type='hidden' name='HPP_"+bd.getOID()+"' value='"+bd.getCost()+"' class='form-control'>"
                    + "<input type='hidden' name='QTY_"+bd.getOID()+"' value='"+(int) bd.getQty()+"' class='form-control'>"
                    + "</td>"
                    + " <td class='text-center'>" 
                    + bd.getSku()
                    + "</td>"
                    + " <td class='text-center'>" 
                    + bd.getItemName()
                    + "</td>"
                    + " <td class='money text-center'>" 
                    + bd.getCost() 
                    + "</td>";
                    if (jenisReturn == ReturnKredit.JENIS_RETURN_CABUTAN){
                        html+= " <td>" 
                            + "<input type='text' value='"+nilaiPersediaan+"' id='persediaan' class='form-control money' data-cast-class='persediaan"+bd.getOID()+"'>"
                            + "<input type='hidden' name='PERSEDIAAN_"+bd.getOID()+"' value='"+nilaiPersediaan+"' class='persediaan"+bd.getOID()+"'>"
                        + "</td>";
                    } else {
                        html+= " <td class='text-center'>" 
                            +"<a class='money'>"+nilaiPersediaan+"</a>"+ "<input type='hidden' name='PERSEDIAAN_"+bd.getOID()+"' value='"+nilaiPersediaan+"'>"
                        + "</td>";
                    }
                    
                    html+= " <td class='text-center'>" 
                    + bd.getQty() 
                    + "</td>";
                    if (jenisReturn == ReturnKredit.JENIS_RETURN_CABUTAN){
                        html+= " <td><input type='text' name='NEW_SKU_"+bd.getOID()+"' value='' class='form-control'></td>"
                        + " <td><input type='text' name='NEW_NAME_"+bd.getOID()+"' value='' class='form-control'></td>";
                    }
                    html+= "</tr>";

        }
        html += "</tbody>"
                + "</table>";

//        whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
//                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]
//                + " IN (" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ", " + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ")";
//        Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, whereClause, "");
//        int banyakAngsuran = listJadwal.size();
//        int banyakAngsuranDibayar = 0;
//        for(JadwalAngsuran ja : listJadwal){
//            Vector<Angsuran> listAngsuran = SessKredit.getJadwalSudahDibayar(0, 0, "angsuran."+PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + ja.getOID(), "");
//            double diBayar = 0;
//            for(Angsuran angs : listAngsuran){
//                diBayar += angs.getJumlahAngsuran();
//            }
//            if(ja.getJumlahANgsuran() - diBayar == 0){
//                banyakAngsuranDibayar++;
//            }
//        }
         
        //double selisihBanyakAngsuran = banyakAngsuran - banyakAngsuranDibayar;
        nilaiInventori = (nilaiHpp/(p.getJangkaWaktu()+angsDp))*angsuranBelumDibayar;
        try {
            objValue.put("RETURN_HTML_BIAYA_KREDIT", html);
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        double sisaPokokPerTgl = getTunggakanPokok(p.getOID(), dateCheck, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
        double sisaBungaPerTgl = getTunggakanBunga(p.getOID(), dateCheck, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
        double tunggakanTotal = sisaPokokPerTgl + sisaBungaPerTgl;
        
        JSONArray jsonArrayDataKredit = new JSONArray();
        if (objValue.optString("message", "").equals("")) {
            JSONObject jo = new JSONObject();

            try {
                jo.put("nomor_kredit", "" + p.getNoKredit());
                jo.put("jenis_kredit", "" + tk.getNameKredit());
                jo.put("nama_nasabah", "" + a.getName());
                jo.put("id_nasabah", "" + a.getOID());
                jo.put("analis", "" + Analis);
                jo.put("kolektor", "" + kolektor);
                jo.put("tunggakan", "" + tunggakan);
                jo.put("location", "" + loc.getName());
                jo.put("billoid", "" + cbmOid);
                jo.put("tunggakanPokok", "" + sisaPokokPerTgl);
                jo.put("tunggakanBunga", "" + sisaBungaPerTgl);
                jo.put("tunggakanTotal", "" + tunggakanTotal);
                jo.put("cbmOid", "" + cbmOid);
                jo.put("pinjaman", "" + p.getOID());
                jo.put("nilaiHpp", "" + nilaiHpp);
                jo.put("nilaiInventori", "" + nilaiInventori);
                jo.put("sisaTunggakan", "" + sisaTunggakan);
                jo.put("sisaWaktu", "" + String.format("%,.2f", angsuranBelumDibayar));
                jo.put("nilaiPinjaman", "" + nilaiAngsuran);
                jo.put("jangkaWaktu", "" + (p.getJangkaWaktu()+angsDp));
                jo.put("DP", "" + DP);
                jsonArrayDataKredit.put(jo);
                objValue.put("RETURN_DATA_KREDIT", jsonArrayDataKredit);
            } catch (JSONException ex) {
                objValue.put("RETURN_MESSAGE", ex.toString());
                printErrorMessage(ex.getMessage());
            }
        }
        return objValue;
    }

    public String queryGetIdJadwalDibayar(long idPinjaman) {
        return ""
                + " SELECT a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS a "
                + "  JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS ja "
                + "    ON ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                + " WHERE ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                + "";
    }

    public JSONObject getDataJenisKredit(HttpServletRequest request, JSONObject objValue) throws JSONException{
        objValue.put("RETURN_MESSAGE", "");
        long oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        int sessLanguage = FRMQueryString.requestInt(request, "SESS_LANGUAGE");
        JenisKredit kredit = new JenisKredit();
        try {
            kredit = PstTypeKredit.fetchExc(oid);
        } catch (Exception e) {
            objValue.put("RETURN_ERROR_CODE", 1);
            objValue.put("RETURN_MESSAGE", e.getMessage());
            printErrorMessage(e.getMessage());
        }
        //get detail kredit
//        if (iErrCode == 0) {
        JSONArray jsonArrayJenisKredit = new JSONArray();
        JSONObject jo = new JSONObject();
        try {
            jo.put("kredit_min", "" + kredit.getMinKredit());
            jo.put("kredit_max", "" + kredit.getMaxKredit());
            jo.put("bunga_min", "" + kredit.getBungaMin());
            jo.put("bunga_max", "" + kredit.getBungaMax());
            jo.put("tipe_bunga", "" + kredit.getTipeBunga());
            Date startDate = kredit.getBerlakuMulai();
            Date endDate = kredit.getBerlakuSampai();
            String mulai = "";
            String berakhir = "";
            if (startDate != null) {
                mulai = Formater.formatDate(kredit.getBerlakuMulai(), "yyyy-MM-dd");
            }
            if (endDate != null) {
                berakhir = Formater.formatDate(kredit.getBerlakuSampai(), "yyyy-MM-dd");
            }
            jo.put("berlaku_mulai", "" + mulai);
            jo.put("berlaku_sampai", "" + berakhir);
            jo.put("jangka_min", "" + Formater.formatNumber(kredit.getJangkaWaktuMin(), "#"));
            jo.put("jangka_max", "" + Formater.formatNumber(kredit.getJangkaWaktuMax(), "#"));
            String arrayTipeFrekuensi[] = I_Sedana.TIPE_KREDIT.get(kredit.getTipeFrekuensiPokokLegacy());
            String tipeFrekuensi = arrayTipeFrekuensi[sessLanguage];
            jo.put("tipe_frekuensi", "" + tipeFrekuensi);
            jsonArrayJenisKredit.put(jo);
            objValue.put("RETURN_DATA_JENIS_KREDIT", jsonArrayJenisKredit);
        } catch (JSONException ex) {
            objValue.put("RETURN_MESSAGE", ex.getMessage());
            printErrorMessage(ex.getMessage());
        }
//        }
        //get sumber dana
//        if (iErrCode == 0) {
        String htmlReturn = "";
        Vector listSumberDana = SessReportKredit.listJoinJenisKreditBySumberDana("tk." + PstAssignSumberDana.fieldNames[PstAssignSumberDana.FLD_TYPE_KREDIT_ID] + " = '" + kredit.getOID() + "'", "");
        for (int i = 0; i < listSumberDana.size(); i++) {
            AssignSumberDana asd = (AssignSumberDana) listSumberDana.get(i);
            SumberDana sd = new SumberDana();
            try {
                sd = PstSumberDana.fetchExc(asd.getSumberDanaId());
            } catch (Exception e) {
                objValue.put("RETURN_ERROR_CODE", 1);
                objValue.put("RETURN_MESSAGE", e.toString());
                printErrorMessage(e.getMessage());
            }
            htmlReturn += "<option value='" + sd.getOID() + "'>" + sd.getKodeSumberDana() + " - " + sd.getJudulSumberDana() + "</option>";
        }
        if (listSumberDana.isEmpty()) {
            htmlReturn = "<option value=''>Tidak ada data sumber dana</option>";
        }
        objValue.put("FRM_FIELD_HTML", htmlReturn);
        
        return objValue;
//        }
    }

    public String getSimulasiKredit(HttpServletRequest request) {
        String html = "";

        try {
            String tglRealisasi = FRMQueryString.requestString(request, "FORM_TGL_REALISASI");
            long jangkaWaktuId = FRMQueryString.requestLong(request, "FORM_JANGKA_WAKTU");
            double jumlahPinjaman = FRMQueryString.requestDouble(request, "FORM_JUMLAH_PINJAMAN");
            double dp = FRMQueryString.requestDouble(request, "DP");
            long penjaminId = FRMQueryString.requestLong(request, "FORM_PENJAMIN");
            double coverage = FRMQueryString.requestDouble(request, "FORM_COVERAGE");
            double persentaseDijamin = FRMQueryString.requestDouble(request, "FORM_PERSENTASE_DIJAMIN");
            long typeKreditId = FRMQueryString.requestLong(request, "FORM_JENIS_KREDIT");
            Date date1 = new SimpleDateFormat("yyyy-MM-dd").parse(tglRealisasi);
            String nilaiBiaya = FRMQueryString.requestString(request, "FORM_NILAI_BIAYA");
            String[] nilaiBiayaNew = nilaiBiaya.split(",");
            String typeBiaya = FRMQueryString.requestString(request, "FORM_TIPE_BIAYA");
            String[] typeBiayaNew = typeBiaya.split(",");
            Calendar cal = Calendar.getInstance();
            cal.setTime(date1);
            JenisKredit tk = new JenisKredit();
            tk = PstJenisKredit.fetch(typeKreditId);
            String typeKredit = tk.getNameKredit();
            JangkaWaktu jangkaWaktu = PstJangkaWaktu.fetchExc(jangkaWaktuId);
            double biayaAsuransi = jumlahPinjaman * (persentaseDijamin / 100);
            double angsuranSeharusnya = jumlahPinjaman / jangkaWaktu.getJangkaWaktu();
            double lebih = 0;
            double biayaLain = 0;
            for (int i = 0; i < nilaiBiayaNew.length; i++) {
                double isiBiaya = Double.valueOf(nilaiBiayaNew[i]);
                int isiTipe = Integer.valueOf(typeBiayaNew[i]);
                if (isiTipe == BiayaTransaksi.TIPE_BIAYA_UANG) {
                    biayaLain += isiBiaya;
                } else if (isiTipe == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                    double newNilaiBiaya = jumlahPinjaman * (isiBiaya / 100);
                    biayaLain += newNilaiBiaya;
                }
            }

            html = "<label>Perhitungan Simulasi</label>"
                    + "<p>* Simulasi kredit dengan <strong>jumlah pengajuan</strong> sebesar <strong>Rp. " + FRMHandler.userFormatStringDecimal(jumlahPinjaman) + "</strong> </p>"
                    + "<table>"
                    + "<tr>"
                    + "<td>Jenis Kredit</td>"
                    + "<td> : </td>"
                    + "<td>" + typeKredit + "</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td> Jumlah Pengajuan</td>"
                    + "<td> : </td>"
                    + "<td><span class='money'>Rp. " + FRMHandler.userFormatStringDecimal(jumlahPinjaman) + "</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td>Jangka Waktu</td>"
                    + "<td> : </td>"
                    + "<td>" + jangkaWaktu.getJangkaWaktu() + " Bulan</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td>Biaya Asuransi</td>"
                    + "<td> : </td>"
                    + "<td>Rp. " + FRMHandler.userFormatStringDecimal(biayaAsuransi) + "</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td>Deposit</td>"
                    + "<td> : </td>"
                    + "<td>Rp. " + FRMHandler.userFormatStringDecimal(dp) + "</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td>Perhitungan Biaya</td>"
                    + "<td> : </td>"
                    + "<td>Jumlah  pungajuan + ( biaya asuransi + biaya lain )</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td> </td>"
                    + "<td> : </td>"
                    + "<td>" + FRMHandler.userFormatStringDecimal(jumlahPinjaman) + " + (" + FRMHandler.userFormatStringDecimal(biayaAsuransi) + " + " + FRMHandler.userFormatStringDecimal(biayaLain) + ")</p>"
                    + "</tr>"
                    + "<tr>"
                    + "<td>Total</td>"
                    + "<td> : </td>"
                    + "<td>Rp. " + FRMHandler.userFormatStringDecimal(jumlahPinjaman + (biayaAsuransi + biayaLain)) + "</td>"
                    + "</tr>"
                    + "</table>"
                    + "<label>Rincian Ansuransi</label>"
                    + "<table class='table table-stripped table-bordered table-responsive table-hover'>"
                    + "<thead>"
                    + "<th style=\"width:20px\" >No.</th>"
                    + "<th>Jatuh Tempo</th>"
                    + "<th>Angsuran</th>"
                    + "</thead>"
                    + "<tbody>";

            if (dp != 0) {
                html += "<tr>"
                        + "<td style=\"text-align: center;\">" + (1) + "</td>"
                        + "<td style=\"text-align: center;\">" + Formater.formatDate(cal.getTime(), "yyyy-MM-dd") + "</td>"
                        + "<td style=\"text-align: center;\"><span class='money dp'>" + dp + "</td>"
                        + "</tr>";
            }

            if (dp != 0) {
                for (int i = 1; i < (jangkaWaktu.getJangkaWaktu() + 1); i++) {
                    double angsuran = angsuranSeharusnya;
                    if (i == (jangkaWaktu.getJangkaWaktu())) {
                        angsuran = angsuranSeharusnya - lebih;
                    } else {
                        angsuran = convertInteger(-3, angsuran);
                        lebih += angsuran - angsuranSeharusnya;
                    }

                    if (i > 0) {
                        cal.add(Calendar.MONTH, 1);
                    }
                    html += "<tr>"
                            + "<td style=\"text-align: center;\">" + (i + 1) + "</td>"
                            + "<td style=\"text-align: center;\">" + Formater.formatDate(cal.getTime(), "yyyy-MM-dd") + "</td>"
                            + "<td style=\"text-align: center;\">" + FRMHandler.userFormatStringDecimal(angsuran) + "</td>"
                            + "</tr>";
                }
            } else {

                for (int i = 0; i < jangkaWaktu.getJangkaWaktu(); i++) {
                    double angsuran = angsuranSeharusnya;
                    if (i == (jangkaWaktu.getJangkaWaktu() - 1)) {
                        angsuran = angsuranSeharusnya - lebih;
                    } else {
                        angsuran = convertInteger(-3, angsuran);
                        lebih += angsuran - angsuranSeharusnya;
                    }

                    if (i > 0) {
                        cal.add(Calendar.MONTH, 1);
                    }
                    html += "<tr>"
                            + "<td style=\"text-align: center;\">" + (i + 1) + "</td>"
                            + "<td style=\"text-align: center;\">" + Formater.formatDate(cal.getTime(), "yyyy-MM-dd") + "</td>"
                            + "<td style=\"text-align: center;\">" + FRMHandler.userFormatStringDecimal(angsuran) + "</td>"
                            + "</tr>";
                }
            }
            html += "</tbody>"
                    + "</table>";

        } catch (Exception exc) {

        }

        return html;
    }

    public BillMain setBillMain(HttpServletRequest request) {
        long cashTellerId = FRMQueryString.requestLong(request, FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_CASH_CASHIER_ID]);
        long locationId = FRMQueryString.requestLong(request, FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_LOCATION_ID]);
        long appUserId = FRMQueryString.requestLong(request, FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_APP_USER_ID]);
        long shiftId = FRMQueryString.requestLong(request, FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_SHIFT_ID]);
        String salesCode = FRMQueryString.requestString(request, FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_SALES_CODE]);
        long currencyType = 0;
        StandartRate standartRate = new StandartRate();
        try {
            currencyType = Long.valueOf(PstSystemProperty.getValueByName("CURRENCY_TYPE_DEFAULT"));
            standartRate = PstStandartRate.getActiveStandardRate(currencyType);
        } catch (Exception exc) {
        }
        BillMain billMain = new BillMain();
        billMain.setCashCashierId(cashTellerId);
        billMain.setLocationId(locationId);
        billMain.setBillDate(new Date());
        billMain.setAppUserId(appUserId);
        billMain.setShiftId(shiftId);
        billMain.setSalesCode(salesCode);
        billMain.setInvoiceCounter(PstBillMain.getCounterTransaction(1));
        billMain.setDocType(PstBillMain.TYPE_INVOICE);
        billMain.setTransctionType(PstBillMain.TRANS_TYPE_CREDIT);
        billMain.setTransactionStatus(PstBillMain.TRANS_STATUS_OPEN);
        billMain.setStatusInv(PstBillMain.INVOICING_ON_PROSES);
        billMain.setCurrencyId(currencyType);
        billMain.setRate(standartRate.getSellingRate());

        return billMain;
    }

    public int convertInteger(int scale, double val) {
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(scale, RoundingMode.UP);
        return bDecimal.intValue();
    }

    public static Date getTunggakanKredit(long idPinjaman, String tanggalCek, int jenisAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT MIN(tb.TANGGAL_ANGSURAN) "
                    + " FROM "
                    + " (SELECT "
                    + " jadwal.`TANGGAL_ANGSURAN`,"
                    + " jadwal.`JADWAL_ANGSURAN_ID`,"
                    + " jadwal.`PINJAMAN_ID`,"
                    + " jadwal.`JUMLAH_ANGSURAN`,"
                    + " angsuran.`JUMLAH_ANGSURAN` AS PEMBAYARAN,"
                    + " jadwal.`JUMLAH_ANGSURAN` AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID` "
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NULL "
                    + " UNION ALL"
                    + " SELECT"
                    + " jadwal.`TANGGAL_ANGSURAN`,"
                    + " jadwal.`JADWAL_ANGSURAN_ID`,"
                    + " jadwal.`PINJAMAN_ID`,"
                    + " jadwal.`JUMLAH_ANGSURAN`,"
                    + " SUM(angsuran.`JUMLAH_ANGSURAN`) AS PEMBAYARAN,"
                    + " ("
                    + " jadwal.`JUMLAH_ANGSURAN` - SUM(angsuran.`JUMLAH_ANGSURAN`)"
                    + " ) AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID`"
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NOT NULL "
                    + " GROUP BY jadwal.`JADWAL_ANGSURAN_ID`) AS tb "
                    + " WHERE balance != 0 "
                    + " ORDER BY tb.TANGGAL_ANGSURAN "
                    + "";
            System.out.println(" SQL getTunggakan :" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Date tanggal = null;
            while (rs.next()) {
                tanggal = rs.getDate(1);
            }
            rs.close();
            return tanggal;
        } catch (Exception e) {
            return null;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTunggakanPokok(long idPinjaman, String tanggalCek, int jenisAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT  SUM(tb.`JUMLAH_ANGSURAN`) AS JUMLAH "
                    + " FROM "
                    + " (SELECT "
                    + " jadwal.`TANGGAL_ANGSURAN`,"
                    + " jadwal.`JADWAL_ANGSURAN_ID`,"
                    + " jadwal.`PINJAMAN_ID`,"
                    + " jadwal.`JUMLAH_ANGSURAN`,"
                    + " angsuran.`JUMLAH_ANGSURAN` AS PEMBAYARAN,"
                    + " jadwal.`JUMLAH_ANGSURAN` AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID` "
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NULL "
                    + " UNION ALL"
                    + " SELECT"
                    + " jadwal.`TANGGAL_ANGSURAN`,"
                    + " jadwal.`JADWAL_ANGSURAN_ID`,"
                    + " jadwal.`PINJAMAN_ID`,"
                    + " jadwal.`JUMLAH_ANGSURAN`,"
                    + " SUM(angsuran.`JUMLAH_ANGSURAN`) AS PEMBAYARAN,"
                    + " ("
                    + " jadwal.`JUMLAH_ANGSURAN` - SUM(angsuran.`JUMLAH_ANGSURAN`)"
                    + " ) AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID`"
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NOT NULL "
                    + " GROUP BY jadwal.`JADWAL_ANGSURAN_ID`) AS tb "
                    + " WHERE balance != 0 "
                    + " ORDER BY tb.TANGGAL_ANGSURAN "
                    + "";
            System.out.println(" SQL getTunggakan :" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double pokok = 0;
            while (rs.next()) {
                pokok = rs.getDouble(1);
            }
            rs.close();
            return pokok;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTunggakanBunga(long idPinjaman, String tanggalCek, int jenisAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT  SUM(tb.`JUMLAH_ANGSURAN`) AS JUMLAH "
                    + " FROM "
                    + " (SELECT "
                    + " jadwal.`TANGGAL_ANGSURAN`,"
                    + " jadwal.`JADWAL_ANGSURAN_ID`,"
                    + " jadwal.`PINJAMAN_ID`,"
                    + " jadwal.`JUMLAH_ANGSURAN`,"
                    + " angsuran.`JUMLAH_ANGSURAN` AS PEMBAYARAN,"
                    + " jadwal.`JUMLAH_ANGSURAN` AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID` "
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NULL "
                    + " UNION ALL"
                    + " SELECT"
                    + " jadwal.`TANGGAL_ANGSURAN`,"
                    + " jadwal.`JADWAL_ANGSURAN_ID`,"
                    + " jadwal.`PINJAMAN_ID`,"
                    + " jadwal.`JUMLAH_ANGSURAN`,"
                    + " SUM(angsuran.`JUMLAH_ANGSURAN`) AS PEMBAYARAN,"
                    + " ("
                    + " jadwal.`JUMLAH_ANGSURAN` - SUM(angsuran.`JUMLAH_ANGSURAN`)"
                    + " ) AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID`"
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NOT NULL "
                    + " GROUP BY jadwal.`JADWAL_ANGSURAN_ID`) AS tb "
                    + " WHERE balance != 0 "
                    + " ORDER BY tb.TANGGAL_ANGSURAN "
                    + "";
            System.out.println(" SQL getTunggakan :" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double pokok = 0;
            while (rs.next()) {
                pokok = rs.getDouble(1);
            }
            rs.close();
            return pokok;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalBiayaReturn(long idPinjaman, int jenisAngsuranPokok, int jenisAngsuranBunga) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + " SUM(tb.JUMLAH_ANGSURAN) AS JUMLAH "
                    + " FROM "
                    + " (SELECT "
                    + " jadwal.`TANGGAL_ANGSURAN`, "
                    + " jadwal.`JADWAL_ANGSURAN_ID`, "
                    + " jadwal.`PINJAMAN_ID`, "
                    + " jadwal.`JUMLAH_ANGSURAN`, "
                    + " angsuran.`JUMLAH_ANGSURAN` AS PEMBAYARAN, "
                    + " jadwal.`JUMLAH_ANGSURAN` AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID` "
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND jadwal.`JENIS_ANGSURAN` IN (" + jenisAngsuranPokok + ", " + jenisAngsuranBunga + ") "
                    + " AND angsuran.id_angsuran IS NULL "
                    + " UNION ALL"
                    + " SELECT"
                    + " jadwal.`TANGGAL_ANGSURAN`,"
                    + " jadwal.`JADWAL_ANGSURAN_ID`,"
                    + " jadwal.`PINJAMAN_ID`,"
                    + " jadwal.`JUMLAH_ANGSURAN`,"
                    + " SUM(angsuran.`JUMLAH_ANGSURAN`) AS PEMBAYARAN,"
                    + " ("
                    + " jadwal.`JUMLAH_ANGSURAN` - SUM(angsuran.`JUMLAH_ANGSURAN`) "
                    + " ) AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID` "
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND jadwal.`JENIS_ANGSURAN` IN (" + jenisAngsuranPokok + ", " + jenisAngsuranBunga + ") "
                    + " AND angsuran.id_angsuran IS NOT NULL "
                    + " GROUP BY jadwal.`JADWAL_ANGSURAN_ID`) AS tb "
                    + " WHERE balance != 0 "
                    + "";
            System.out.println(" SQL getTunggakan :" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double biayaReturn = 0;
            while (rs.next()) {
                biayaReturn = rs.getDouble(1);
            }
            rs.close();
            return biayaReturn;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    // --------------------------------------------------------------------------
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



