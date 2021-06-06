/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.tabungan;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisSimpanan;
import com.dimata.aiso.form.masterdata.mastertabungan.CtrlJenisSimpanan;
import com.dimata.common.entity.payment.PaymentSystem;
import com.dimata.common.entity.payment.PstPaymentSystem;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.ajax.kredit.AjaxKredit;
import com.dimata.sedana.ajax.transaksi.AjaxSetoran;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan;
import com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan;
import com.dimata.sedana.entity.assigntabungan.AssignTabungan;
import com.dimata.sedana.entity.assigntabungan.PstAssignTabungan;
import com.dimata.sedana.entity.kredit.AngsuranPayment;
import com.dimata.sedana.entity.masterdata.PstTingkatanBunga;
import com.dimata.sedana.entity.tabungan.DataTabungan;
import com.dimata.sedana.entity.tabungan.DetailTransaksi;
import com.dimata.sedana.entity.tabungan.JenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstDataTabungan;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksiPayment;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.sedana.entity.tabungan.TransaksiPayment;
import com.dimata.sedana.form.assigntabungan.FrmAssignTabungan;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.SessReportTabungan;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.io.IOException;
import java.util.ArrayList;
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
public class AjaxTabungan extends HttpServlet {

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

    //LONG
    private long oid = 0;
    private long oidTellerShift = 0;

    //STRING
    private String dataFor = "";
    private String oidDelete = "";
    private String approot = "";
    private String htmlReturn = "";
    private String message = "";
    private String history = "";

    //BOOLEAN
    private boolean privAdd = false;
    private boolean privUpdate = false;
    private boolean privDelete = false;
    private boolean privView = false;

    //INT
    private int iCommand = 0;
    private int iErrCode = 0;
    private int errorNumber = 0;

    //DOUBLE
    private double setoranMin = 0;

    private long userId = 0;
    private String userName = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //JSON
        this.jSONArray = new JSONArray();
        this.jSONObject = new JSONObject();

        //LONG
        this.oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        this.oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");

        //STRING
        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.oidDelete = FRMQueryString.requestString(request, "FRM_FIELD_OID_DELETE");
        this.approot = FRMQueryString.requestString(request, "FRM_FIELD_APPROOT");
        this.htmlReturn = "";
        this.message = "";
        this.history = "";

        //BOOLEAN
        this.privAdd = FRMQueryString.requestBoolean(request, "privadd");
        this.privUpdate = FRMQueryString.requestBoolean(request, "privupdate");
        this.privDelete = FRMQueryString.requestBoolean(request, "privdelete");
        this.privView = FRMQueryString.requestBoolean(request, "privview");

        //INT
        this.iCommand = FRMQueryString.requestCommand(request);
        this.iErrCode = 0;
        this.errorNumber = 0;

        //DOUBLE
        this.setoranMin = 0;

        this.userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
        this.userName = FRMQueryString.requestString(request, "SEND_USER_NAME");

        switch (this.iCommand) {
            case Command.SAVE:
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
            this.jSONObject.put("RETURN_DATA_ARRAY", this.jSONArray);
            this.jSONObject.put("RETURN_ERROR_CODE", "" + this.iErrCode);
            this.jSONObject.put("RETURN_MESSAGE", "" + this.message);
        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }

        response.getWriter().print(this.jSONObject);
    }

    //COMMAND SAVE==============================================================
    public synchronized void commandSave(HttpServletRequest request) {
        if (dataFor.equals("hitungBungaDepositoTerakhir")) {
            hitungBungaDepositoTerakhir(request);
        } else if (dataFor.equals("hitungBiayaAdmin")) {
            hitungBiayaAdmin(request);
        } else if (dataFor.equals("saveItem")) {
            try {
                saveItem(request);
            } catch (DBException exc) {
                printErrorMessage(exc.getMessage());
            }
        }
    }

    //COMMAND DELETE============================================================
    public synchronized void commandDelete(HttpServletRequest request) {

    }

    //COMMAND LIST==============================================================
    public synchronized void commandList(HttpServletRequest request, HttpServletResponse response) {

    }

    //COMMAND NONE==============================================================
    public synchronized void commandNone(HttpServletRequest request) {
        if (this.dataFor.equals("getKonfirmasiSetoran")) {
            getKonfirmasiTabungan(request, "setoran");
        } else if (this.dataFor.equals("getKonfirmasiPenarikan")) {
            getKonfirmasiTabungan(request, "penarikan");
        } else if (this.dataFor.equals("getKonfirmasiPenutupan")) {
            getKonfirmasiTabungan(request, "penutupan");
        } else if (this.dataFor.equals("getDataBunga")) {
            getDataBunga(request);
        }
    }

    public synchronized void getDataBunga(HttpServletRequest request) {
        String date = FRMQueryString.requestString(request, "SEND_DATE");
        this.htmlReturn = "";
        ArrayList<ArrayList> listBunga = PstTransaksi.getDetaiBungaTabunganPerTanggal(date);
        int no = 0;
        double total = 0;
        for (ArrayList al : listBunga) {
            DataTabungan tab = (DataTabungan) al.get(0);
            DetailTransaksi dt = (DetailTransaksi) al.get(1);
            no++;
            total += dt.getKredit();
            this.htmlReturn += "<tr>";
            this.htmlReturn += "<td>" + no + ".</td>";
            this.htmlReturn += "<td>" + tab.getKodeTabungan()+ "</td>";
            this.htmlReturn += "<td>" + tab.getCatatan()+ "</td>";
            this.htmlReturn += "<td>" + I_Sedana.BUNGA.get(tab.getStatus())[0] + "</td>";
            this.htmlReturn += "<td class='money text-right'>" + dt.getKredit() + "</td>";
            this.htmlReturn += "<td>" + dt.getDetailInfo()+ "</td>";
            this.htmlReturn += "</tr>";
        }
        if (listBunga.isEmpty()) {
            this.htmlReturn = "<tr><td colspan='6' class='text-center'>Tidak ada data bunga</td></tr>";
        } else {
            this.htmlReturn += "<tr>";
            this.htmlReturn += "<td colspan='4' class='text-right text-bold'>TOTAL :</td>";
            this.htmlReturn += "<td class='money text-right text-bold'>" + total + "</td>";
            this.htmlReturn += "<td></td>";
            this.htmlReturn += "</tr>";
        }
    }
    
    public synchronized void getKonfirmasiTabungan(HttpServletRequest request, String transaksi) {
        long assignContactId = FRMQueryString.requestLong(request, AjaxSetoran.FRM_FIELD_ASSIGN_CONTACT_TABUNGAN_ID);
        String simpanan[] = FRMQueryString.requestStringValues(request, AjaxSetoran.FRM_FIELD_SIMPANAN_NAMA);
        String saldoAwal[] = FRMQueryString.requestStringValues(request, AjaxSetoran.FRM_FIELD_SALDO_AWAL);
        String jenisTransaksi[] = FRMQueryString.requestStringValues(request, AjaxSetoran.FRM_FIELD_JENIS_TRANSAKSI);
        String setoran[] = FRMQueryString.requestStringValues(request, AjaxSetoran.FRM_FIELD_SALDO);
        String namaJenisTransaksi[] = new String[jenisTransaksi.length];
        String errMsg = "";

        AssignContactTabungan act = new AssignContactTabungan();
        Anggota a = new Anggota();
        try {
            act = PstAssignContactTabungan.fetchExc(assignContactId);
            a = PstAnggota.fetchExc(act.getContactId());
            int i = 0;
            for (String s : jenisTransaksi) {
                JenisTransaksi js = PstJenisTransaksi.fetchExc(Long.valueOf(s));
                namaJenisTransaksi[i] = js.getJenisTransaksi();
                i++;
            }
        } catch (Exception e) {
            errMsg += "<i class='fa fa-exclamation-circle text-red'></i> " + e.getMessage() + "<br>";
            printErrorMessage(e.getMessage());
        }

        this.htmlReturn = ""
                + "<p style='font-size: 16px'><b>Anda akan melakukan transaksi " + transaksi + " tabungan :</b></p>"
                + "<table>"
                + "   <tr>"
                + "       <td style='padding-right: 10px'>Nomor Tabungan</td>"
                + "       <td>: &nbsp; " + act.getNoTabungan() + "</td>"
                + "   </tr>"
                + "   <tr>"
                + "       <td>Nasabah</td>"
                + "       <td>: &nbsp; " + a.getName() + " (" + a.getNoAnggota() + ")</td>"
                + "   </tr>"
                + "</table>"
                + "";

        this.htmlReturn += ""
                + "<br>"
                + "<label>Simpanan :</label>"
                + "<table class='table table-bordered' style='font-size: 14px'>"
                + "   <tr class='label-success'>"
                + "       <th style='width: 1%'>No.</th>"
                + "       <th>Jenis Item</th>"
                + "       <th>Saldo Saat Ini</th>"
                + "       <th>Jenis Transaksi</th>"
                + "       <th>Nilai Setoran</th>"
                + "   </tr>"
                + "";

        double totalSetoran = 0;
        if (simpanan != null && simpanan.length > 0) {
            int nol = 0;
            for (int i = 0; i < simpanan.length; i++) {
                double dSetoran = Double.valueOf(setoran[i]);
                totalSetoran += dSetoran;
                nol += (dSetoran <= 0) ? 1 : 0;
                String warning = (dSetoran <= 0) ? "text-bold text-red" : "";
                this.htmlReturn += ""
                        + "<tr class='" + warning + "'>"
                        + "     <td>" + (i + 1) + ".</td>"
                        + "     <td>" + simpanan[i] + "</td>"
                        + "     <td class='money text-right'>" + saldoAwal[i] + "</td>"
                        + "     <td>" + namaJenisTransaksi[i] + "</td>"
                        + "     <td class='money text-right'>" + setoran[i] + "</td>"
                        + "</tr>"
                        + "";
            }
            if (nol > 0) {
                errMsg += "<i class='fa fa-exclamation-circle text-red'></i> Terdapat nilai setoran 0 !<br>";
            }
            this.htmlReturn += ""
                    + "<tr>"
                    + "   <td class='text-right text-bold' colspan='4'>TOTAL : </td>"
                    + "   <td class='text-right text-bold money'>" + totalSetoran + "</td>"
                    + "</tr>"
                    + "</table>";
        }

        this.htmlReturn += ""
                + "<label>Jenis Pembayaran :</label>"
                + "<table class='table table-bordered' style='font-size: 14px'>"
                + "   <tr class='label-success'>"
                + "       <th style='width: 1%'>No.</th>"
                + "       <th>Tipe Pembayaran</th>"
                + "       <th>Detail</th>"
                + "       <th>Nominal</th>"
                + "   </tr>"
                + "";

        String paymentType[] = FRMQueryString.requestStringValues(request, AjaxSetoran.FRM_FIELD_PAYMENT_TYPE);
        String uang[] = FRMQueryString.requestStringValues(request, AjaxSetoran.FRM_FIELD_PAYMENT_NOMINAL);
        String tabungan[] = FRMQueryString.requestStringValues(request, AjaxSetoran.FRM_FIELD_ID_SIMPANAN_PAYMENT);

        double totalUang = 0;
        if (paymentType != null && paymentType.length > 0) {
            for (int i = 0; i < paymentType.length; i++) {
                try {
                    totalUang += Double.valueOf(uang[i]);
                    PaymentSystem ps = PstPaymentSystem.fetchExc(Long.valueOf(paymentType[i]));
                    String keterangan = "";
                    if (ps.getPaymentType() == AngsuranPayment.TIPE_PAYMENT_SAVING) {
                        String noTab = "???";
                        try {
                            DataTabungan dt = PstDataTabungan.fetchExc(Long.valueOf(tabungan[i]));
                            AssignContactTabungan assign = PstAssignContactTabungan.fetchExc(dt.getAssignTabunganId());
                            noTab = assign.getNoTabungan();
                        } catch (Exception e) {
                            errMsg += "<i class='fa fa-exclamation-circle text-red'></i> " + e.getMessage() + "<br>";
                            printErrorMessage(e.getMessage());
                        }
                        keterangan += "Nomor tabungan : " + noTab;
                    }
                    this.htmlReturn += ""
                            + "<tr>"
                            + "   <td>" + (i + 1) + ".</td>"
                            + "   <td>" + ps.getPaymentSystem() + "</td>"
                            + "   <td>" + keterangan + "</td>"
                            + "   <td class='text-right money'>" + uang[i] + "</td>"
                            + "</tr>"
                            + "";
                } catch (Exception e) {
                    errMsg += "<i class='fa fa-exclamation-circle text-red'></i> " + e.getMessage() + "<br>";
                    printErrorMessage(e.getMessage());
                }
            }
            this.htmlReturn += ""
                    + "<tr>"
                    + "   <td class='text-right text-bold' colspan='3'>TOTAL : </td>"
                    + "   <td class='text-right text-bold money'>" + totalUang + "</td>"
                    + "</tr>"
                    + "</table>";
        }
        this.htmlReturn += "</table>";

        if (totalSetoran != totalUang) {
            errMsg += "<i class='fa fa-exclamation-circle text-red'></i> Jumlah total uang dan nilai transaksi tidak sama !<br>";
        }
        this.htmlReturn += "<div>" + errMsg + "</div>";
    }

    public synchronized void saveItem(HttpServletRequest request) throws DBException {

        long masterTabunganId = FRMQueryString.requestLong(request, "FRM_FIELD_MASTER_TABUNGAN_ID");

        String appUserInit = FRMQueryString.requestString(request, "SEND_APP_USER_INIT");
        long userOID = FRMQueryString.requestLong(request, "SEND_USER_OID");
        String userGroup = FRMQueryString.requestString(request, "SEND_USER_GROUP");
        String userFullName = FRMQueryString.requestString(request, "SEND_USER_FULL_NAME");

        request.setAttribute("appUserInit", appUserInit);
        request.setAttribute("userName", userName);
        request.setAttribute("userOID", userOID);
        request.setAttribute("userGroup", userGroup);
        request.setAttribute("userFullName", userFullName);
        request.setAttribute("app", "SEDANA");
        CtrlJenisSimpanan ctrlJenisSimpanan = new CtrlJenisSimpanan(request);
        iErrCode = ctrlJenisSimpanan.action(iCommand, 0);
        String sim = "";
        Vector<AssignTabungan> ast = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + "='" + masterTabunganId + "'", "");
        Vector<JenisSimpanan> jss = PstJenisSimpanan.list(0, 0, "", PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]);
        for (JenisSimpanan js : jss) {
            String checked = "";
            for (AssignTabungan at : ast) {
                if (js.getOID() == at.getIdJenisSimpanan()) {
                    checked = "checked";
                    break;
                }
            }
            sim += "<input type='checkbox' " + checked + " name='" + FrmAssignTabungan.fieldNames[FrmAssignTabungan.FRM_FIELD_IDJENISSIMPANAN] + "' value='" + js.getOID() + "' style='display: inline;'> " + js.getNamaSimpanan() + "<br>";
            //sim+="<option "+(oidJenisSimpanan == js.getOID() ? "selected" : "")+" value='"+js.getOID()+"'>"+js.getNamaSimpanan()+"</option>";
        }
        sim += "<br><button class=\"btn btn-xs btn-success btn-add-item\" type=\"button\">Tambah</button>";
        this.htmlReturn = sim;
    }

    public synchronized void hitungBungaDepositoTerakhir(HttpServletRequest request) {
        String tgl = FRMQueryString.requestString(request, "SEND_DATE");
        String nomorTabungan = FRMQueryString.requestString(request, "SEND_NO_TABUNGAN");
        if (tgl.isEmpty()) {
            this.message = "Periode harus harus dipilih !";
            return;
        }
        
        Date tglPencatatanDepositoTerakhir = Formater.formatDate(tgl, "yyyy-MM-dd");
        if (tglPencatatanDepositoTerakhir == null) {
            this.message = "Pastikan periode dipilih dengan benar !";
            return;
        }
        
        //CARI TABUNGAN DEPOSITO YG TUTUP PER TANGGAL PENCATATAN
        ArrayList<DataTabungan> listDeposito = SessReportTabungan.getTabunganDepositoPerTanggalTutup(tglPencatatanDepositoTerakhir, nomorTabungan);
        if (listDeposito.isEmpty()) {
            if (nomorTabungan.isEmpty()) {
                this.message = "Tidak ada tabungan deposito yang berakhir di periode " + Formater.formatDate(tglPencatatanDepositoTerakhir, "MMMM yyyy") + ".";
            } else {
                this.message = "Nomor tabungan '" + nomorTabungan + "' yang berakhir di periode " + Formater.formatDate(tglPencatatanDepositoTerakhir, "MMMM yyyy") + " tidak ditemukan.";
            }
            return;
        }
        
        //CARI JENIS TRANSAKSI PENAMBAHAN BUNGA TABUNGAN
        long oidJenisTransaksi = 0;
        String where = PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + " = " + Transaksi.TIPE_ARUS_KAS_BERKURANG + " AND "
                + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_PROSEDUR] + " = " + Transaksi.TIPE_PROSEDUR_BY_SYSTEM + " AND "
                + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = " + Transaksi.TUJUAN_PROSEDUR_TABUNGAN + " AND "
                + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " = " + Transaksi.STATUS_JENIS_TRANSAKSI_AKTIF + " AND "
                + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_TRANSAKSI] + " = " + Transaksi.TIPE_TRANSAKSI_PENGELUARAN;
        Vector<JenisTransaksi> jenisTransaksi = PstJenisTransaksi.list(0, 0, where, "");
        if (jenisTransaksi.isEmpty()) {
            this.message = "Jenis transaksi penambahan bunga tabungan tidak ditemukan.";
            return;
        } else {
            oidJenisTransaksi = jenisTransaksi.get(0).getOID();
        }
        
        //TAMBAHKAN BUNGA TABUNGAN TERAKHIR
        String pembulatanBunga = PstSystemProperty.getValueByName("GUNAKAN_PEMBULATAN_BUNGA_TABUNGAN");
        int generated = 0;
        for (DataTabungan dt : listDeposito) {
            try {
                AssignContactTabungan assign = PstAssignContactTabungan.fetchExc(dt.getAssignTabunganId());
                JenisSimpanan j = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                if (j.getJenisBunga() == I_Sedana.BUNGA_SALDO_DEPOSITO) {
                    //HITUNG BUNGA
                    Calendar currentMonth = Calendar.getInstance();
                    int maxDate = 30;//lastMonth.getActualMaximum(Calendar.DAY_OF_MONTH);

                    double saldo = PstDetailTransaksi.getLastSaldoOfTheMonth(dt.getOID(), currentMonth.get(Calendar.MONTH) + 1, currentMonth.get(Calendar.YEAR));

                    double interestRate = PstTingkatanBunga.getBungaBySaldo(saldo, dt.getOID());
                    double bunga = saldo * interestRate / 100 * maxDate / j.getBasisHariBunga();
                    if (bunga <= 0) {
                        printErrorMessage("Bunga untuk nomor tabungan " + assign.getNoTabungan() + " = " + bunga);
                    }
                    
                    if (pembulatanBunga.equals("1")) {
                        bunga = Math.round(bunga);
                    }
                    
                    Calendar calNewPeriode = Calendar.getInstance();
                    calNewPeriode.setTime(tglPencatatanDepositoTerakhir);
                    calNewPeriode.add(Calendar.MONTH, 1);
                    Date newTglBunga = calNewPeriode.getTime();
                    
                    int useCaseType = I_Sedana.USECASE_TYPE_TABUNGAN_BUNGA_PENCATATAN;
                    String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_TABUNGAN_PENCATATAN_BUNGA, useCaseType, newTglBunga);
                    
                    Transaksi transaksi = new Transaksi();
                    transaksi.setIdAnggota(dt.getIdAnggota());
                    transaksi.setTanggalTransaksi(newTglBunga);
                    transaksi.setTellerShiftId(this.oidTellerShift);
                    transaksi.setUsecaseType(useCaseType);
                    transaksi.setKeterangan(I_Sedana.USECASE_TYPE_TITLE.get(useCaseType) + ". Periode : " + Formater.formatDate(newTglBunga, "MMMM yyyy") + ". Bunga untuk nomor tabungan : " + assign.getNoTabungan());
                    transaksi.setKodeBuktiTransaksi(nomorTransaksi);
                    transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                    long oidTransaksi = PstTransaksi.insertExc(transaksi);
                    
                    generated++;
                    
                    long idAlokasiBunga = (dt.getIdAlokasiBunga() == 0) ? dt.getOID() : dt.getIdAlokasiBunga();
                    DetailTransaksi detailTransaksi = new DetailTransaksi();
                    detailTransaksi.setIdSimpanan(idAlokasiBunga);
                    detailTransaksi.setJenisTransaksiId(oidJenisTransaksi);
                    detailTransaksi.setTransaksiId(oidTransaksi);
                    detailTransaksi.setDetailInfo("Bunga untuk nomor tabungan : " + assign.getNoTabungan());
                    detailTransaksi.setKredit(bunga);
                    PstDetailTransaksi.insertExc(detailTransaksi);
                    
                } else {
                    printErrorMessage("Jenis bunga untuk nomor tabungan " + assign.getNoTabungan() + " bukan " + I_Sedana.BUNGA.get(I_Sedana.BUNGA_SALDO_DEPOSITO)[0]);
                }
            } catch (Exception e) {
                printErrorMessage(e.getMessage());
            }
        }
        
        if (!nomorTabungan.isEmpty() && generated > 0) {
            this.message = "Nomor tabungan '" + nomorTabungan + "' berhasil mendapatkan bunga.";
        } else {
            String success = (generated == listDeposito.size()) ? "" + generated : "" + generated + " dari " + listDeposito.size();
            this.message = (generated == 0) ? "Tidak ada tabungan deposito yang mendapatkan bunga." : "" + success + " tabungan deposito berhasil mendapatkan bunga.";
        }
    }
    
    public synchronized void hitungBiayaAdmin(HttpServletRequest request) {
        String tgl = FRMQueryString.requestString(request, "SEND_DATE");
        if (tgl.isEmpty()) {
            this.message = "Tanggal harus diisi !";
            return;
        }

        Date tglPencatatanBiayaAdmin = Formater.formatDate(tgl, "yyyy-MM-dd");
        if (tglPencatatanBiayaAdmin == null) {
            this.message = "Pastikan tanggal diisi dengan benar !";
            return;
        }

        //CARI DATA SIMPANAN YG AKAN DIHITUNG BIAYA ADMIN
        String whereSimpanan = PstDataTabungan.fieldNames[PstDataTabungan.FLD_STATUS] + " = '" + I_Sedana.STATUS_AKTIF + "'"
                + " AND DATE(" + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL] + ") < '" + Formater.formatDate(tglPencatatanBiayaAdmin, "yyyy-MM-01") + "'"
                + " AND (" + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + " IS NULL "
                + " OR DATE(" + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + ") >= '" + Formater.formatDate(tglPencatatanBiayaAdmin, "yyyy-MM-dd") + "'"
                + ")";
        Vector<DataTabungan> listTabungan = PstDataTabungan.list(0, 0, whereSimpanan, PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL] + " DESC");
        if (listTabungan.isEmpty()) {
            this.message = "Tidak ada data tabungan yang ditemukan.";
            return;
        }

        //CARI JENIS TRANSAKSI POTONGAN BIAYA ADMIN
        String whereCon = PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + " = " + Transaksi.TIPE_ARUS_KAS_BERTAMBAH + " AND "
                + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_PROSEDUR] + " = " + Transaksi.TIPE_PROSEDUR_BY_SYSTEM + " AND "
                + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = " + Transaksi.TUJUAN_PROSEDUR_TABUNGAN + " AND "
                + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " = " + Transaksi.STATUS_JENIS_TRANSAKSI_AKTIF + " AND "
                + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_TRANSAKSI] + " = " + Transaksi.TIPE_TRANSAKSI_PENDAPATAN + " AND "
                + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = " + I_Sedana.TIPE_DOC_TABUNGAN_BIAYA_BULANAN;

        Vector<JenisTransaksi> jenisTransaksiPotongan = PstJenisTransaksi.list(0, 0, whereCon, "");
        if (jenisTransaksiPotongan.isEmpty()) {
            this.message = "Jenis transaksi potongan biaya admin tidak ditemukan !";
            return;
        }

        long oidJenisTransaksi = jenisTransaksiPotongan.get(0).getOID();
        for (DataTabungan dt : listTabungan) {
            try {
                AssignContactTabungan assign = PstAssignContactTabungan.fetchExc(dt.getAssignTabunganId());
                
                //CARI DATA TRANSAKSI BIAYA ADMIN DI PERIODE YG SAMA
                ArrayList<Transaksi> listBunga = PstTransaksi.getTransaksiBiayaAdminBulanan(dt.getOID(), tglPencatatanBiayaAdmin);
                for (Transaksi t : listBunga) {
                    if (t.getStatus() != Transaksi.STATUS_DOC_TRANSAKSI_CLOSED) {
                        this.message = "Tidak dapat menghapus transaksi biaya admin sebelumnya untuk nomor tabungan " + assign.getNoTabungan() + " karena sudah di POSTED";
                        return;
                    }
                }
                for (Transaksi t : listBunga) {
                    deleteTransaction(t.getOID(), this.userId, this.userName);
                    if (this.iErrCode > 0) {
                        return;
                    }
                }
                
                //CEK NILAI BIAYA ADMIN
                JenisSimpanan j = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                if (j.getBiayaAdmin() <= 0) {
                    printErrorMessage("Biaya admin untuk nomor tabungan " + assign.getNoTabungan() + " Rp " + j.getBiayaAdmin());
                    continue;
                }

                String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_TABUNGAN_PENCATATAN_POTONGAN_ADMIN, I_Sedana.USECASE_TYPE_TABUNGAN_POTONGAN_ADMIN_PENCATATAN, tglPencatatanBiayaAdmin);

                Transaksi trs = new Transaksi();
                trs.setIdAnggota(dt.getIdAnggota());
                trs.setTanggalTransaksi(tglPencatatanBiayaAdmin);
                trs.setTellerShiftId(this.oidTellerShift);
                trs.setUsecaseType(I_Sedana.USECASE_TYPE_TABUNGAN_POTONGAN_ADMIN_PENCATATAN);
                trs.setKeterangan(I_Sedana.USECASE_TYPE_TITLE.get(trs.getUsecaseType()) + " periode " + Formater.formatDate(tglPencatatanBiayaAdmin, "MMMM yyyy"));
                trs.setKodeBuktiTransaksi(nomorTransaksi);
                trs.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                PstTransaksi.insertExc(trs);

                DetailTransaksi dtrs = new DetailTransaksi();
                dtrs.setIdSimpanan(dt.getOID());
                dtrs.setJenisTransaksiId(oidJenisTransaksi);
                dtrs.setDebet(j.getBiayaAdmin());
                dtrs.setTransaksiId(trs.getOID());
                PstDetailTransaksi.insertExc(dtrs);
                
                if (this.iErrCode == 0) {
                    this.message = "Potongan biaya admin berhasil dihitung";
                }

            } catch (DBException ex) {
                this.message += "Error: " + ex.getMessage() + " ";
                printErrorMessage(ex.getMessage());
            }
        }
    }

    public synchronized String deleteTransaction(long idTransaksi, long idUser, String namaUser) {
        try {
            Transaksi t = PstTransaksi.fetchExc(idTransaksi);
            if (t.getStatus() != Transaksi.STATUS_DOC_TRANSAKSI_CLOSED) {
                this.iErrCode += 1;
                this.message += "Tidak dapat menghapus transaksi dengan status " + Transaksi.STATUS_DOC_TRANSAKSI_TITLE[t.getStatus()];
                return this.message;
            }

            Vector<Transaksi> listChild = PstTransaksi.list(0, 0, PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_PARENT_ID] + " = " + idTransaksi, null);
            //cek transaksi yg sudah posted
            for (Transaksi tChild : listChild) {
                if (tChild.getStatus() != Transaksi.STATUS_DOC_TRANSAKSI_CLOSED) {
                    this.iErrCode += 1;
                    this.message += "Tidak dapat menghapus transaksi. Terdapat transaksi child dengan status " + Transaksi.STATUS_DOC_TRANSAKSI_TITLE[t.getStatus()];
                    return this.message;
                }
            }
            for (Transaksi tChild : listChild) {
                this.deleteTransaction(tChild.getOID(), idUser, namaUser);
                if (this.iErrCode > 0) {
                    return this.message;
                }
            }

            //get history transaksi
            Transaksi t2 = PstTransaksi.fetchExc(idTransaksi);
            AjaxKredit ak = new AjaxKredit();
            this.history = ak.getHistoryTransaksi(t2);

            //hapus data detail
            Vector<DetailTransaksi> detail = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + idTransaksi, null);
            for (DetailTransaksi dt : detail) {
                PstDetailTransaksi.deleteExc(dt.getOID());
            }

            //hapus data payment
            Vector<TransaksiPayment> payments = PstTransaksiPayment.list(0, 0, PstTransaksiPayment.fieldNames[PstTransaksiPayment.FLD_TRANSAKSI_ID] + " = " + idTransaksi, null);
            for (TransaksiPayment tp : payments) {
                PstTransaksiPayment.deleteExc(tp.getOID());
            }

            //hapus transaksi
            PstTransaksi.deleteExc(idTransaksi);
            this.message += "Transaksi " + t.getKodeBuktiTransaksi() + " berhasil dihapus";

            //simpan history
            SessHistory sessHistory = new SessHistory();
            sessHistory.saveHistory(idUser, namaUser, "DELETE", t2.getOID(), t2.getKodeBuktiTransaksi(), SessHistory.document[SessHistory.DOC_TRANSAKSI_TABUNGAN], "SEDANA", "#", history);

        } catch (Exception e) {
            this.iErrCode += 1;
            this.message += "Terjadi kesalahan : " + e.getMessage();
            printErrorMessage(e.getMessage());
        }
        return this.message;
    }

    public int getError() {
        return this.iErrCode;
    }

    public void clearMessage() {
        this.message = "";
    }

    public String getMessage() {
        return this.message;
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
