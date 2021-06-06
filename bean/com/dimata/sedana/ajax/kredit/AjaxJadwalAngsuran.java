/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.kredit;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.common.session.convert.ConvertAngkaToHuruf;
import com.dimata.pos.entity.billing.Billdetail;
import com.dimata.pos.entity.billing.PstBillDetail;
import com.dimata.posbo.entity.masterdata.PstShift;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.kredit.Angsuran;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.MappingDendaPinjaman;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstAngsuran;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstMappingDendaPinjaman;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.masterdata.BiayaTransaksi;
import com.dimata.sedana.entity.masterdata.CashTeller;
import com.dimata.sedana.entity.masterdata.JangkaWaktu;
import com.dimata.sedana.entity.masterdata.PstBiayaTransaksi;
import com.dimata.sedana.entity.masterdata.PstCashTeller;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktu;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.sedana.form.kredit.FrmAngsuran;
import com.dimata.sedana.session.SessKredit;
import com.dimata.sedana.session.SessReportKredit;
import com.dimata.sedana.session.kredit.SessKreditKalkulasi;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.Month;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
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
public class AjaxJadwalAngsuran extends HttpServlet {

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
    private JSONArray jSONArrayJadwalAngsuran = new JSONArray();

    //LONG
    private long oid = 0;
    private long oidTransaksi = 0;
    public long oidTellerShift = 0;
    private List<Long> oidKreditDenda = new ArrayList<Long>();

    //STRING
    private String dataFor = "";
    private String oidDelete = "";
    private String approot = "";
    private String htmlReturn = "";
    private String message = "";
    private String history = "";
    private String rangeAwal = "";
    private String rangeAkhir = "";
    private String oidMulti = "";
    private String raditya = "";
    private String dataAngsuran = "";

    //BOOLEAN
    private boolean privAdd = false;
    private boolean privUpdate = false;
    private boolean privDelete = false;
    private boolean privView = false;

    //INT
    private int iCommand = 0;
    private int iErrCode = 0;
    private int jenisAngsuran = 0;
    private int error = 0;
    private int dendaDibuat = 0;
    private int lastRow = 0;
    private int tipeAngsuranGenerate = 0;
    private int jenisAng = 0;

    private long userId = 0;
    private String userName = "";
    private String transparentStyle = "";

    private int enableTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN"));
    private NumberFormat formatNumber = NumberFormat.getInstance(new Locale("id", "ID"));
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // OBJECT
        this.jSONObject = new JSONObject();
        this.jSONArray = new JSONArray();
        this.jSONArrayJadwalAngsuran = new JSONArray();

        //LONG
        this.oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        this.userId = FRMQueryString.requestLong(request, "FRM_FIELD_USER_OID");
        this.oidTransaksi = 0;
        this.oidTellerShift = FRMQueryString.requestLong(request, "SEND_OID_TELLER_SHIFT");
        this.oidKreditDenda.clear();

        //STRING
        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.oidDelete = FRMQueryString.requestString(request, "FRM_FIELD_OID_DELETE");
        this.approot = FRMQueryString.requestString(request, "FRM_FIELD_APPROOT");
        this.htmlReturn = "";
        this.message = "";
        this.history = "";
        this.dataAngsuran = "";
        this.rangeAwal = FRMQueryString.requestString(request, "SEND_RANGE_AWAL");
        this.rangeAkhir = FRMQueryString.requestString(request, "SEND_RANGE_AKHIR");
        this.oidMulti = FRMQueryString.requestString(request, "SEND_OID_MULTI");
        this.raditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");
//        this.transparentStyle = "color: rgba(255, 255, 255, 0) !important;";
        this.transparentStyle = "";
        
        //BOOLEAN
        this.privAdd = FRMQueryString.requestBoolean(request, "privadd");
        this.privUpdate = FRMQueryString.requestBoolean(request, "privupdate");
        this.privDelete = FRMQueryString.requestBoolean(request, "privdelete");
        this.privView = FRMQueryString.requestBoolean(request, "privview");

        //INT
        this.iCommand = FRMQueryString.requestCommand(request);
        this.iErrCode = 0;
        this.jenisAngsuran = FRMQueryString.requestInt(request, "FRM_JENIS_ANGSURAN");
        this.error = 0;
        this.dendaDibuat = 0;
        this.lastRow = FRMQueryString.requestInt(request, "SEND_LAST_ROW");
        this.tipeAngsuranGenerate = FRMQueryString.requestInt(request, "TIPE_ANGSURAN");
        this.jenisAng = FRMQueryString.requestInt(request, "SEND_JENIS_ANGSURAN");

        //OBJECT
        this.jSONObject = new JSONObject();

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
            this.jSONObject.put("FRM_FIELD_HTML_DATA_ANGSURAN", this.dataAngsuran);
            this.jSONObject.put("RETURN_ERROR", "" + this.error);
            this.jSONObject.put("RETURN_MESSAGE", "" + this.message);
            this.jSONObject.put("RETURN_DATA_SCHEDULE", this.jSONArrayJadwalAngsuran);
            this.jSONObject.put("RETURN_DATA_DENDA", "" + this.dendaDibuat);
            this.jSONObject.put("RETURN_LAST_ROW", "" + this.lastRow);

        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }

        response.getWriter().print(this.jSONObject);

    }

    public void commandSave(HttpServletRequest request) {
        if (this.dataFor.equals("cekDendaKredit")) {
            cekValidasiTanggalV2(request);
            showDataDenda(request);
        } else if (this.dataFor.equals("generateDendaPerKredit")) {
//            cekDendaPerKredit(request);
            cekDendaPerKreditV2(request);
//            cekValidasiTanggalV2(request);
        } else if (this.dataFor.equals("setRounding")) {
            setRounding(request);
        } else if(this.dataFor.equals("updateStatusCetak")){
            updateStatusCetak(request);
        }
    }
    
    public void updateStatusCetak(HttpServletRequest request){
        try {
            String[] listJadwalStr = request.getParameterValues("OID_JADWAL");
            if(listJadwalStr != null && listJadwalStr.length > 0){
                for(String jaOid : listJadwalStr){
                    long oidJadwal = Long.parseLong(jaOid);
                    JadwalAngsuran ja = PstJadwalAngsuran.fetchExc(oidJadwal);
                    
                    ja.setStatusCetak(JadwalAngsuran.STATUS_CETAK_PRINTED);
                    
                    try {
                        PstJadwalAngsuran.updateExc(ja);
                    } catch (Exception e) {
                        printErrorMessage(e.getMessage());
                    }
                    
                }
            }
            
        } catch (Exception e) {
            printErrorMessage(e.toString());
        }
    }

    public void setRounding(HttpServletRequest request) {
        if (!PstPinjaman.checkOID(this.oid)) {
            this.message = "Data kredit tidak ditemukan !";
            return;
        }
        Pinjaman p = new Pinjaman();
        try {
            p = PstPinjaman.fetchExc(this.oid);
            if (p.getStatusPinjaman() != Pinjaman.STATUS_DOC_DRAFT) {
                this.message = "Data jadwal tidak dapat diubah ! \nStatus pinjaman harus " + Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_DRAFT);
                return;
            }
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        //CEK SUDAH ADA PEMBAYARAN
        if (!SessKredit.getListAngsuranByPinjaman(this.oid).isEmpty()) {
            this.message = "Data jadwal tidak dapat diubah ! \nSudah ada pembayaran!";
            return;
        }
        int roundSetting = FRMQueryString.requestInt(request, "ROUND_SETTING");
        int roundValue = FRMQueryString.requestInt(request, "ROUND_VALUE");
        //GET JADWAL
        Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + this.oid, null);
        double totalPokok = 0;
        for (JadwalAngsuran ja : listJadwal) {
            try {
                double angsuran = ja.getJumlahAngsuranSeharusnya();
                double sisa = 0;
                if (roundSetting == 1) {
                    angsuran = (Math.floor((ja.getJumlahAngsuranSeharusnya() + (roundValue - 1)) / roundValue)) * roundValue;
                    if (ja.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK) {
                        if ((totalPokok + angsuran) > p.getJumlahPinjaman()) {
                            angsuran = p.getJumlahPinjaman() - totalPokok;
                        }
                        totalPokok += angsuran;
                    }
                    sisa = angsuran - ja.getJumlahANgsuran();
                }
                ja.setJumlahANgsuran(angsuran);
                ja.setSisa(sisa);
                PstJadwalAngsuran.updateExc(ja);
            } catch (Exception e) {
                this.iErrCode++;
                this.message += "Terjadi kesalahan : " + e.getMessage();
                printErrorMessage(e.getMessage());
            }
        }
        if (this.iErrCode == 0) {
            this.message = (roundSetting == 1) ? "Pembulatan berhasil." : "Pembulatan berhasil dihilangkan.";
        }
    }

    public synchronized long saveTransaksi(HttpServletRequest request, Pinjaman p, String kode, int useCaseType) {
        //set kode transaksi
        Date tglTransaksi = new Date();
        String nomorTransaksi = PstTransaksi.generateKodeTransaksi(kode, useCaseType, tglTransaksi);
        long idTransaksi = 0;
        if(this.oidTellerShift == 0){
            Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + this.userId 
                    + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
            if (open.size() < 1) {
                this.iErrCode = 1;
                this.message = "<br>Tidak ada cashier yang sudah opening";
                return 0;
            } else {
                this.oidTellerShift = open.get(0).getOID();
            }
        }
        Transaksi transaksi = new Transaksi();
        transaksi.setTanggalTransaksi(tglTransaksi);
        transaksi.setKodeBuktiTransaksi(nomorTransaksi);
        transaksi.setIdAnggota(p.getAnggotaId());
        transaksi.setTellerShiftId(this.oidTellerShift);
        transaksi.setKeterangan(Transaksi.USECASE_TYPE_TITLE.get(useCaseType));
        transaksi.setPinjamanId(p.getOID());
        transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
        transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
        transaksi.setUsecaseType(useCaseType);
        try {
            idTransaksi = PstTransaksi.insertExc(transaksi);
        } catch (DBException ex) {
            this.error = 1;
            this.message += ex.getMessage();
            printErrorMessage(ex.getMessage());
        }
        return idTransaksi;
    }

    public synchronized void cekDendaPerKredit(HttpServletRequest request) {
        try {
            this.tipeAngsuranGenerate = JadwalAngsuran.TIPE_ANGSURAN_DENDA;
            Pinjaman p = PstPinjaman.fetchExc(this.oid);
            if (p.getStatusPinjaman() != Pinjaman.STATUS_DOC_CAIR) {
                this.iErrCode += 1;
                this.message = "Status pinjaman harus cair untuk bisa generate denda.";
            }
            Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 1, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID(), PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
            for (JadwalAngsuran ja : listJadwal) {
                //cek per tanggal
                Calendar c = Calendar.getInstance();
                c.setTime(ja.getTanggalAngsuran());
                Date dateCek = c.getTime();
                String now = Formater.formatDate(new Date(), "yyyy-MM-dd");
                Date dateAkhir = Formater.formatDate(now, "yyyy-MM-dd");
                int cek = 0;
                while (cek <= 0) {
                    cekDendaPerTanggal(request, dateCek);
                    c.add(Calendar.DATE, 1);
                    dateCek = c.getTime();
                    cek = dateCek.compareTo(dateAkhir);
                }
            }
        } catch (Exception e) {
            this.iErrCode += 1;
            this.message = e.getMessage();
            printErrorMessage(e.getMessage());
            return;
        }
        this.message = (this.dendaDibuat > 0) ? "" + this.dendaDibuat + " jadwal denda baru berhasil di generate. " + this.message : "Tidak ada jadwal denda baru. " + this.message;
    }
    public synchronized void cekDendaPerKreditV2(HttpServletRequest request) {
        try {
            this.tipeAngsuranGenerate = JadwalAngsuran.TIPE_ANGSURAN_DENDA;
            Pinjaman p = PstPinjaman.fetchExc(this.oid);
            if (p.getStatusPinjaman() != Pinjaman.STATUS_DOC_CAIR) {
                this.iErrCode += 1;
                this.message = "Status pinjaman harus cair untuk bisa generate denda.";
            }
//            Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 1, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID(), PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
//            for (JadwalAngsuran ja : listJadwal) {
//                //cek per tanggal
//                Calendar c = Calendar.getInstance();
//                c.setTime(ja.getTanggalAngsuran());
//                Date dateCek = c.getTime();
//                String now = Formater.formatDate(new Date(), "yyyy-MM-dd");
//                Date dateAkhir = Formater.formatDate(now, "yyyy-MM-dd");
//                int cek = 0;
//                while (cek <= 0) {
//                    cekDendaJadwalAngsuran(request, dateCek, dateAkhir);
//                    c.add(Calendar.DATE, 1);
//                    dateCek = c.getTime();
//                    cek = dateCek.compareTo(dateAkhir);
//                }
//            }
            if(p.getStatusDenda() == Pinjaman.STATUS_DENDA_NONAKTIF){
                this.iErrCode += 1;
                this.message = "Denda tidak dapat dibuat. Status denda pada " + p.getNoKredit() + " " + Pinjaman.STATUS_DENDA_TITLE[p.getStatusDenda()];
                return;
            } else {
                Date dateAkhir = new Date();
                cekDendaJadwalAngsuran(request, dateAkhir, dateAkhir);
            }
        } catch (Exception e) {
            this.iErrCode += 1;
            this.message = e.getMessage();
            printErrorMessage(e.getMessage());
            return;
        }
        this.message = (this.dendaDibuat > 0) ? "" + this.dendaDibuat + " jadwal denda baru berhasil di generate. " + this.message : "Tidak ada jadwal denda baru. " + this.message;
    }

    public synchronized void cekValidasiTanggal(HttpServletRequest request) {
        int generateDenda = FRMQueryString.requestInt(request, "GENERATE_NEW_DENDA");
        Date dateAwal = Formater.formatDate(this.rangeAwal, "yyyy-MM-dd");
        Date dateAkhir = Formater.formatDate(this.rangeAkhir, "yyyy-MM-dd");

        //cek tanggal kosong
        if (dateAwal == null || dateAkhir == null) {
            this.error = 1;
            this.message = "<br><i class='fa fa-exclamation-circle text-red'></i> Pastikan tanggal diinput dengan benar!";
            return;
        }
        //cek tanggal tdk sesuai
        int cekDateAwal = dateAwal.compareTo(new Date());
        int cekDateAkhir = dateAkhir.compareTo(new Date());
        if (cekDateAwal > 0 || cekDateAkhir > 0) {
            this.error = 1;
            this.message = "<br><i class='fa fa-exclamation-circle text-red'></i> Pastikan tanggal yang diinput tidak lewat dari tanggal hari ini!";
            return;
        }

        //cek generate denda baru
        if (generateDenda == 0) {
            return;
        }

        //cek per tanggal
        Calendar c = Calendar.getInstance();
        c.setTime(dateAwal);
        Date dateCek = c.getTime();
        int cek = 0;
        while (cek <= 0) {
            cekDendaPerTanggal(request, dateCek);
            c.add(Calendar.DATE, 1);
            dateCek = c.getTime();
            cek = dateCek.compareTo(dateAkhir);
        }
    }
    public synchronized void cekValidasiTanggalV2(HttpServletRequest request) {
        int generateDenda = FRMQueryString.requestInt(request, "GENERATE_NEW_DENDA");
        Date dateAwal = Formater.formatDate(this.rangeAwal, "yyyy-MM-dd");
        Date dateAkhir = Formater.formatDate(this.rangeAkhir, "yyyy-MM-dd");

        //cek tanggal kosong
        if (dateAwal == null || dateAkhir == null) {
            this.error = 1;
            this.message = "<br><i class='fa fa-exclamation-circle text-red'></i> Pastikan tanggal diinput dengan benar!";
            return;
        }
        //cek tanggal tdk sesuai
        int cekDateAwal = dateAwal.compareTo(new Date());
        int cekDateAkhir = dateAkhir.compareTo(new Date());
        if (cekDateAwal > 0 || cekDateAkhir > 0) {
            this.error = 1;
            this.message = "<br><i class='fa fa-exclamation-circle text-red'></i> Pastikan tanggal yang diinput tidak lewat dari tanggal hari ini!";
            return;
        }

        //cek generate denda baru
        if (generateDenda != 0) {
            cekDendaJadwalAngsuran(request, dateAwal, dateAkhir);
        }
    }
    
    //baru
    public synchronized void cekDendaJadwalAngsuran(HttpServletRequest request, Date dateAwal, Date dateAkhir) {
        String whereClause = " DATE(SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] 
                + ") < DATE('" + Formater.formatDate(dateAkhir, "yyyy-MM-dd") + "')"
                + " AND AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_CAIR 
                + " AND SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " IN ("
                + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA
                + ")";
        whereClause += this.oid > 0 ? " AND SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + this.oid : "";
        Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.listJoinPinjaman(0, 0, whereClause, "");
        ArrayList<Long> listTerlambat = new ArrayList<>();
        for(JadwalAngsuran ja : listJadwal){
            long oidPinjaman = ja.getPinjamanId();
            double diBayar = 0;
            Pinjaman p = new Pinjaman();
            try {
                p = PstPinjaman.fetchExc(oidPinjaman);
            } catch (Exception e) {
                System.out.println("Error, Pinjaman tidak ditemukan. " + e.getMessage());
            }
            
            if(p.getStatusDenda() == Pinjaman.STATUS_DENDA_NONAKTIF){
                this.iErrCode += 1;
                this.message = "Denda tidak dapat dibuat. Status denda pada " + p.getNoKredit() + " " + Pinjaman.STATUS_DENDA_TITLE[p.getStatusDenda()];
                return;
            } 
            
            boolean denda = cekPengenaanDenda(p, ja, dateAkhir);
            if(!denda){
                continue;
            }
            //GET SETTING DENDA
            MappingDendaPinjaman dendaPinjaman = PstMappingDendaPinjaman.getSettingDenda(p.getOID(), this.tipeAngsuranGenerate);
            if (dendaPinjaman == null) {
                this.error += 1;
                this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Aturan denda untuk nomor pinjaman '" + p.getNoKredit() + "' tidak ditemukan! ";
                continue;
            }
            
            Vector<Angsuran> listDibayar = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + ja.getOID(), "");
            if(listDibayar.isEmpty()){
                if(!listTerlambat.contains(p.getOID())){
                    listTerlambat.add(p.getOID()); 
                }
            }
            for(Angsuran a : listDibayar){
                Transaksi t = new Transaksi();
                try {
                    t = PstTransaksi.fetchExc(a.getTransaksiId());
                } catch (Exception e) {
                    System.out.println("Error, transaki tidak ditemukan. " + e.getMessage());
                }
                if(t.getTanggalTransaksi() != null){
                    diBayar = a.getJumlahAngsuran();
                    if(ja.getJumlahANgsuran() > diBayar){
                        if(ja.getTanggalAngsuran().compareTo(t.getTanggalTransaksi()) < 0){
                            if(!listTerlambat.contains(p.getOID())){
                                listTerlambat.add(p.getOID()); 
                            }
                        }
                    }
                }
            }
        }
        
        prosesDendaJadwalAngsuran(request, listTerlambat, dateAwal, dateAkhir);
        
    }

    public synchronized void prosesDendaJadwalAngsuran(HttpServletRequest request, ArrayList<Long> listTerlambat, Date dateAwal, Date dateAkhir) {
        for(Long oidPinjaman : listTerlambat){
            Pinjaman p = new Pinjaman();
            try {
                p = PstPinjaman.fetchExc(oidPinjaman);
            } catch (Exception e) {
            }
            //GET SETTING DENDA
            MappingDendaPinjaman dendaPinjaman = PstMappingDendaPinjaman.getSettingDenda(p.getOID(), this.tipeAngsuranGenerate);
            if (dendaPinjaman == null) {
                this.error += 1;
                this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Aturan denda untuk nomor pinjaman '" + p.getNoKredit() + "' tidak ditemukan! ";
                continue;
            }
            
            Calendar c = Calendar.getInstance();
            String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " IN ("
                    + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA
                    + ")";
            String group = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN];
            Vector<JadwalAngsuran> listJa = PstJadwalAngsuran.list(0, 0, whereClause, "", group);
            for(JadwalAngsuran ja : listJa){
                if(ja.getTanggalAngsuran().before(dateAkhir)){
                    c.setTime(ja.getTanggalAngsuran());
                    c.add(Calendar.DAY_OF_MONTH, dendaPinjaman.getDendaToleransi());
                    Date tglAngsuran = c.getTime();
                    if(tglAngsuran.compareTo(dateAkhir) < 0){
                        long idJadwalParent = ja.getOID();
                        generateRangePeriodeDendaV2(request, p, dendaPinjaman, idJadwalParent, ja.getTanggalAngsuran(), dateAkhir);
//                        double denda = getNilaiDenda(p, dendaPinjaman, ja.getTanggalAngsuran(), dateAkhir);
//                        hitungDenda(request, dendaPinjaman, p, ja.getTanggalAngsuran(), dateAkhir);
                    }
                }
            }
        }
    }
    
    public synchronized void hitungDenda(HttpServletRequest request, MappingDendaPinjaman dendaPinjaman, Pinjaman p, Date tglAngsuran, Date dateAkhir) {
        try {
            String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                    + " AND DATE(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") "
                    + " = DATE('" + Formater.formatDate(tglAngsuran, "yyyy-MM-dd") + "')";
            Vector<JadwalAngsuran> listJa = PstJadwalAngsuran.list(0, 0, whereClause, "");
            
            for(JadwalAngsuran ja : listJa){
                long idJadwalParent = ja.getOID();
                generateRangePeriodeDenda(request, p, dendaPinjaman, idJadwalParent, tglAngsuran, dateAkhir);
            }
            
        } catch (Exception e) {
        }
    }
   
    
    public synchronized void cekDendaPerTanggal(HttpServletRequest request, Date dateCek) {
        //CARI JADWAL ANGSURAN KREDIT YG JATUH TEMPONYA SEBELUM TANGGAL CEK
        String textDateCek = Formater.formatDate(dateCek, "yyyy-MM-dd");
        String whereTerlambat = " jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " < '" + textDateCek + "'";
        whereTerlambat += (this.oid > 0) ? " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + this.oid : "";
        whereTerlambat += " GROUP BY jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN];
        Vector<Vector> listJadwalTerlambat = SessKredit.checkJadwalTerlambat(0, 0, whereTerlambat, "");

        if (listJadwalTerlambat.isEmpty()) {
            //this.message += "<br>Tidak ada jadwal yang berpotensi terkena denda di tanggal " + textDateCek;
            return;
        }

        for (Vector v : listJadwalTerlambat) {
            try {
                JadwalAngsuran jadwal = (JadwalAngsuran) v.get(0);
                Pinjaman pinjaman = (Pinjaman) v.get(1);

                //CEK APAKAH DIKENAKAN DENDA
                boolean kenaDenda = cekPengenaanDenda(pinjaman, jadwal, dateCek);
                if (!kenaDenda) {
                    continue;
                }
                //GET SETTING DENDA
                MappingDendaPinjaman dendaPinjaman = PstMappingDendaPinjaman.getSettingDenda(pinjaman.getOID(), this.tipeAngsuranGenerate);
                if (dendaPinjaman == null) {
                    this.error += 1;
                    this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Aturan denda untuk nomor pinjaman '" + pinjaman.getNoKredit() + "' tidak ditemukan! ";
                    continue;
                }

                //CARI JADWAL YG DIJADIKAN SYARAT DENDA
                String jadwalSyaratDenda = "";
                switch (dendaPinjaman.getTipeDendaBerlaku()) {
                    case JenisKredit.TIPE_DENDA_BERLAKU_POKOK:
                        jadwalSyaratDenda = " pokok ";
                        break;
                    case JenisKredit.TIPE_DENDA_BERLAKU_BUNGA:
                        jadwalSyaratDenda = " bunga ";
                        break;
                    case JenisKredit.TIPE_DENDA_BERLAKU_SEMUA:
                        jadwalSyaratDenda = " pokok dan bunga ";
                        break;
                }
                String textJadwal = Formater.formatDate(jadwal.getTanggalAngsuran(), "yyyy-MM-dd");
                String whereTipeDenda = getWhereClauseTipeDenda(pinjaman, dendaPinjaman, textJadwal);
                Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, whereTipeDenda, "");
                if (listJadwal.isEmpty()) {
                    this.error += 1;
                    this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Syarat denda berdasarkan jadwal angsuran " + jadwalSyaratDenda + " tanggal " + textJadwal + " untuk nomor pinjaman '" + pinjaman.getNoKredit() + "' tidak ditemukan! ";
                } else {
                    //CEK JADWAL APAKAH SUDAH LUNAS
                    cekAngsuranLunas(request, dateCek, pinjaman, dendaPinjaman, listJadwal);
                }

            } catch (Exception e) {
                this.error += 1;
                this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Terjadi kesalahan saat pengecekan syarat denda : " + e.getMessage();
                printErrorMessage(e.getMessage());
            }
        }
    }

    public boolean cekPengenaanDenda(Pinjaman pinjaman, JadwalAngsuran jadwal, Date dateCek) {
        //CARI DATA SETTING DENDA
        MappingDendaPinjaman dendaPinjaman = PstMappingDendaPinjaman.getSettingDenda(pinjaman.getOID(), this.tipeAngsuranGenerate);
        if (dendaPinjaman == null) {
            this.error += 1;
            this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Aturan denda untuk nomor pinjaman '" + pinjaman.getNoKredit() + "' tidak ditemukan! ";
            return false;
        }
        //cek toleransi denda
        if (dendaPinjaman.getDendaToleransi() == -1) {
            //tidak dikenakan denda
            //this.message += "<br>Nomor pinjaman '" + pinjaman.getNoKredit() + "' tidak dikenakan denda";
            return false;
        } else if (dendaPinjaman.getDendaToleransi() == -2) {
            //bandingkan tanggal cek dengan tanggal akhir angsuran
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(jadwal.getTanggalAngsuran());
            calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
            Date lastAngsuranDate = calendar.getTime();
            if (dateCek.compareTo(lastAngsuranDate) <= 0) {
                //belum kena denda
                this.message += "<br>Nomor pinjaman '" + pinjaman.getNoKredit() + "' pada tanggal " + Formater.formatDate(dateCek, "dd MMM yyyy") + " berada di masa toleransi";
                return false;
            }
        } else {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(jadwal.getTanggalAngsuran());
            calendar.add(Calendar.DATE, dendaPinjaman.getDendaToleransi());
            Date toleransi = calendar.getTime();
            if (dateCek.compareTo(toleransi) <= 0) {
                //belum kena denda
                //this.message += "<br>Nomor pinjaman " + pinjaman.getNoKredit() + " pada tanggal " + textDateCek + " berada di masa toleransi";
                return false;
            }
        }

        //cek frekuensi denda
        if (dendaPinjaman.getFrekuensiDenda() == 0) {
            //tidak dikenakan denda
            this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Nomor pinjaman '" + pinjaman.getNoKredit() + "' tidak dikenakan denda karena frekuensi denda = " + dendaPinjaman.getFrekuensiDenda();
            return false;
        }

        //cek satuan frekuensi denda
        Date jatuhTempo = jadwal.getTanggalAngsuran();
        Calendar c = Calendar.getInstance();
        Date tglDenda = new Date();
        switch (dendaPinjaman.getSatuanFrekuensiDenda()) {
            case JenisKredit.SATUAN_FREKUENSI_DENDA_HARIAN:
                c.setTime(jatuhTempo);
                c.add(Calendar.DATE, dendaPinjaman.getFrekuensiDenda());
                tglDenda = c.getTime();
                if (dateCek.before(tglDenda)) {
                    //tidak dikenakan denda
                    //this.message += "<br>Nomor pinjaman '" + pinjaman.getNoKredit() + "' pada tanggal " + textDateCek + " belum dikenakan denda";
                    return false;
                }
                break;
            case JenisKredit.SATUAN_FREKUENSI_DENDA_BULANAN:
                c.setTime(jatuhTempo);
                c.add(Calendar.MONTH, dendaPinjaman.getFrekuensiDenda());
                c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
                Date tglAwalDenda = c.getTime();
                if (dateCek.before(tglAwalDenda)) {
                    //tidak dikenakan denda
                    //this.message += "<br>Nomor pinjaman '" + pinjaman.getNoKredit() + "' pada tanggal " + textDateCek + " belum dikenakan denda";
                    return false;
                }
                break;
            case JenisKredit.SATUAN_FREKUENSI_DENDA_JATUH_TEMPO:
                c.setTime(jatuhTempo);
                c.add(Calendar.MONTH, dendaPinjaman.getFrekuensiDenda());
                tglDenda = c.getTime();
                if (dateCek.before(tglDenda)) {
                    //tidak dikenakan denda
                    //this.message += "<br>Nomor pinjaman '" + pinjaman.getNoKredit() + "' pada tanggal " + textDateCek + " belum dikenakan denda";
                    return false;
                }
                break;
        }
        return true;
    }

    public String getWhereClauseTipeDenda(Pinjaman pinjaman, MappingDendaPinjaman dendaPinjaman, String textJadwal) {
        String whereTipeDenda = "";
        switch (dendaPinjaman.getTipeDendaBerlaku()) {
            case JenisKredit.TIPE_DENDA_BERLAKU_BUNGA:
                whereTipeDenda = ""
                        + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'"
                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + "'"
                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + textJadwal + "'";
                break;
            case JenisKredit.TIPE_DENDA_BERLAKU_POKOK:
                whereTipeDenda = ""
                        + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'"
                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + "'"
                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + textJadwal + "'";
                break;
            case JenisKredit.TIPE_DENDA_BERLAKU_SEMUA:
                whereTipeDenda = ""
                        + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'"
                        + " AND "
                        + "(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + "'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + "'"
                        + ")"
                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + textJadwal + "'";
                break;
        }
        return whereTipeDenda;
    }

    public synchronized void cekAngsuranLunas(HttpServletRequest request, Date dateCek, Pinjaman pinjaman, MappingDendaPinjaman dendaPinjaman, Vector<JadwalAngsuran> listJadwal) {
        for (JadwalAngsuran ja : listJadwal) {
            try {
                double nilaiAngsuran = ja.getJumlahANgsuran();
                double totalDibayar = 0;
                int telat = 0;
                Date tglTempo = ja.getTanggalAngsuran();
                long idJadwalParent = ja.getOID();

                //CARI DATA ANGSURAN PER JADWAL
                Vector listAngsuran = PstAngsuran.list(0, 0, "" + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + ja.getOID() + "'", "");
                for (int j = 0; j < listAngsuran.size(); j++) {
                    Angsuran a = (Angsuran) listAngsuran.get(j);
                    long idTransaksiAngsuran = a.getTransaksiId();
                    totalDibayar += a.getJumlahAngsuran();

                    //CEK TGL BAYAR APAKAH SEBELUM ATAU SESUDAH JATUH TEMPO
                    Transaksi t = PstTransaksi.fetchExc(idTransaksiAngsuran);
                    //hilangkan info jam di tanggal bayar
                    String textTglBayar = Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd");
                    Date newTglBayar = Formater.formatDate(textTglBayar, "yyyy-MM-dd");
                    if (newTglBayar.after(tglTempo)) {
                        telat += 1;
                    }
                }

                //CEK APAKAH DIKENAKAN DENDA
                if (nilaiAngsuran >= totalDibayar) {
                    if (telat > 0) {
                        //DIKENAKAN DENDA
                        generateRangePeriodeDenda(request, pinjaman, dendaPinjaman, idJadwalParent, tglTempo, dateCek);
                    }
                } else {
                    //DIKENAKAN DENDA
                    generateRangePeriodeDenda(request, pinjaman, dendaPinjaman, idJadwalParent, tglTempo, dateCek);
                }

                if (telat > 0 || totalDibayar < nilaiAngsuran) {
                    //sudah pasti kena denda, tidak perlu cek jadwal selanjutnya
                    //karna record denda hanya 1 untuk setiap periode denda
                    break;
                }
            } catch (Exception e) {
                this.error += 1;
                this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Terjadi kesalahan saat pengecekan angsuran lunas : " + e.getMessage();
                printErrorMessage(e.getMessage());
            }
        }
    }

    public synchronized void generateRangePeriodeDenda(HttpServletRequest request, Pinjaman pinjaman, MappingDendaPinjaman dendaPinjaman, long idJadwalParent, Date tglTempo, Date dateCek) {
        Calendar c = Calendar.getInstance();
        c.setTime(tglTempo);
        c.add(Calendar.DATE, 1);
        Date tglAwal = c.getTime();
        Date tglAkhir = c.getTime();
        
        if (dendaPinjaman.getTipeFrekuensiDenda() == JenisKredit.TIPE_FREKUENSI_DENDA_TUNGGAL) {
            tglAwal = null;
            tglAkhir = null;
        } else {
            //cek satuan frekuensi denda
            int frekuensiDenda = dendaPinjaman.getFrekuensiDenda();
            switch (dendaPinjaman.getSatuanFrekuensiDenda()) {
                case JenisKredit.SATUAN_FREKUENSI_DENDA_HARIAN:
                    //cek range frekuensi denda
                    if (frekuensiDenda > 1) {
                        c.setTime(tglAwal);
                        c.add(Calendar.DATE, frekuensiDenda - 1);
                        tglAkhir = c.getTime();
                        while (tglAkhir.before(dateCek)) {
                            c.setTime(tglAwal);
                            c.add(Calendar.DATE, frekuensiDenda);
                            tglAwal = c.getTime();
                            c.setTime(tglAkhir);
                            c.add(Calendar.DATE, frekuensiDenda);
                            tglAkhir = c.getTime();
                        }
                    } else {
                        tglAwal = dateCek;
                        tglAkhir = dateCek;
                    }
                    break;
                case JenisKredit.SATUAN_FREKUENSI_DENDA_BULANAN:
                    //set start date
                    c.setTime(tglTempo);
                    c.add(Calendar.MONTH, frekuensiDenda);
                    c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
                    tglAwal = c.getTime();
                    //set end date
                    c.setTime(tglTempo);
                    c.add(Calendar.MONTH, frekuensiDenda);
                    c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                    tglAkhir = c.getTime();
                    while (tglAkhir.before(dateCek)) {
                        //set new start date
                        c.setTime(tglAwal);
                        c.add(Calendar.MONTH, frekuensiDenda);
                        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
                        tglAwal = c.getTime();
                        //set new end date
                        c.setTime(tglAkhir);
                        c.add(Calendar.MONTH, frekuensiDenda);
                        c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                        tglAkhir = c.getTime();
                    }
                    break;
                case JenisKredit.SATUAN_FREKUENSI_DENDA_JATUH_TEMPO:
                    //cek frekuensi denda
                    //belum selesai
                    break;
            }
        }

        //CEK APAKAH JADWAL DENDA SUDAH ADA
        Date tglDenda = generateTanggalDenda2(pinjaman, tglTempo, dateCek);
        if (dendaPinjaman.getTipeFrekuensiDenda() == JenisKredit.TIPE_FREKUENSI_DENDA_BERLIPAT) {
            tglDenda = generateTanggalDenda(pinjaman, tglTempo, dateCek);
        }
        String textTglTempo = Formater.formatDate(tglDenda, "yyyy-MM-dd");
        String wherePeriode = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + this.tipeAngsuranGenerate + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PARENT_JADWAL_ANGSURAN_ID] + " = '" + idJadwalParent + "'";

        if (dendaPinjaman.getTipeFrekuensiDenda() == JenisKredit.TIPE_FREKUENSI_DENDA_BERLIPAT) {
            String textTglAwal = Formater.formatDate(tglAwal, "yyyy-MM-dd");
            String textTglAkhir = Formater.formatDate(tglAkhir, "yyyy-MM-dd");
            wherePeriode += ""
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + textTglTempo + "'"
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_START_DATE] + " = '" + textTglAwal + "'"
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_END_DATE] + " = '" + textTglAkhir + "'";
        }
        Vector<JadwalAngsuran> listJadwalDenda = PstJadwalAngsuran.list(0, 0, wherePeriode, "");
        if (listJadwalDenda.isEmpty()) {
            //BUAT RECORD DENDA
            buatJadwalDenda(request, pinjaman, dendaPinjaman, idJadwalParent, tglTempo, tglAwal, tglAkhir, dateCek, tglDenda);
        } else {
            //CEK APAKAH JADWAL YG ADA SUDAH PERNAH DIBAYAR
            cekJadwalDendaSudahDibayar(request, pinjaman, listJadwalDenda);
        }
    }
    public synchronized void generateRangePeriodeDendaV2(HttpServletRequest request, Pinjaman pinjaman, MappingDendaPinjaman dendaPinjaman, long idJadwalParent, Date tglTempo, Date dateCek) {
        Calendar c = Calendar.getInstance();
        c.setTime(tglTempo);
        c.add(Calendar.DATE, 1);
        Date tglAwal = c.getTime();
        Date tglAkhir = c.getTime();
        int days = 0;
        
        if (dendaPinjaman.getTipeFrekuensiDenda() == JenisKredit.TIPE_FREKUENSI_DENDA_TUNGGAL) {
            tglAwal = null;
            tglAkhir = null;
        } else {
            //cek satuan frekuensi denda
            int frekuensiDenda = dendaPinjaman.getFrekuensiDenda();
            switch (dendaPinjaman.getSatuanFrekuensiDenda()) {
                case JenisKredit.SATUAN_FREKUENSI_DENDA_HARIAN:
                    //cek range frekuensi denda
                    if (frekuensiDenda > 1) {
                        c.setTime(tglAwal);
                        c.add(Calendar.DATE, frekuensiDenda - 1);
                        tglAkhir = c.getTime();
                        while (tglAkhir.before(dateCek)) {
                            c.setTime(tglAwal);
                            c.add(Calendar.DATE, frekuensiDenda);
                            tglAwal = c.getTime();
                            c.setTime(tglAkhir);
                            c.add(Calendar.DATE, frekuensiDenda);
                            tglAkhir = c.getTime();
                        }
                    } else {
                        tglAwal = dateCek;
                        tglAkhir = dateCek;
                        
                        c.setTime(tglTempo);
                        LocalDate tempTglTempo = LocalDate.of(c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1, c.get(Calendar.DAY_OF_MONTH));
                        c.setTime(dateCek);
                        LocalDate tempTglCek = LocalDate.of(c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1, c.get(Calendar.DAY_OF_MONTH));
                        long dateDiffRes = ChronoUnit.DAYS.between(tempTglTempo, tempTglCek);
                        int daysDiff = Integer.parseInt(Long.toString(dateDiffRes));
                        int between = daysDiff - dendaPinjaman.getDendaToleransi();
                        if(between > 0){
                            days = between;
                        }
                    }
                    break;
                case JenisKredit.SATUAN_FREKUENSI_DENDA_BULANAN:
                    //set start date
                    c.setTime(tglTempo);
                    c.add(Calendar.MONTH, frekuensiDenda);
                    c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
                    tglAwal = c.getTime();
                    //set end date
                    c.setTime(tglTempo);
                    c.add(Calendar.MONTH, frekuensiDenda);
                    c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                    tglAkhir = c.getTime();
                    while (tglAkhir.before(dateCek)) {
                        //set new start date
                        c.setTime(tglAwal);
                        c.add(Calendar.MONTH, frekuensiDenda);
                        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
                        tglAwal = c.getTime();
                        //set new end date
                        c.setTime(tglAkhir);
                        c.add(Calendar.MONTH, frekuensiDenda);
                        c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                        tglAkhir = c.getTime();
                    }
                    break;
                case JenisKredit.SATUAN_FREKUENSI_DENDA_JATUH_TEMPO:
                    //cek frekuensi denda
                    //belum selesai
                    break;
            }
        }

        //CEK APAKAH JADWAL DENDA SUDAH ADA
        Date tglDenda = generateTanggalDenda2(pinjaman, tglTempo, dateCek);
        if (dendaPinjaman.getTipeFrekuensiDenda() == JenisKredit.TIPE_FREKUENSI_DENDA_BERLIPAT) {
            tglDenda = generateTanggalDenda(pinjaman, tglTempo, dateCek);
        }
        String textTglTempo = Formater.formatDate(tglDenda, "yyyy-MM-dd");
        String wherePeriode = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + this.tipeAngsuranGenerate + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PARENT_JADWAL_ANGSURAN_ID] + " = '" + idJadwalParent + "'";

        if (dendaPinjaman.getTipeFrekuensiDenda() == JenisKredit.TIPE_FREKUENSI_DENDA_BERLIPAT) {
            String textTglAwal = Formater.formatDate(tglAwal, "yyyy-MM-dd");
            String textTglAkhir = Formater.formatDate(tglAkhir, "yyyy-MM-dd");
            wherePeriode += ""
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + textTglTempo + "'"
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_START_DATE] + " = '" + textTglAwal + "'"
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_END_DATE] + " = '" + textTglAkhir + "'";
        }
        Vector<JadwalAngsuran> listJadwalDenda = PstJadwalAngsuran.list(0, 0, wherePeriode, "");
        if (listJadwalDenda.isEmpty()) {
            //BUAT RECORD DENDA
            buatJadwalDendaV2(request, pinjaman, dendaPinjaman, idJadwalParent, tglTempo, tglAwal, tglAkhir, dateCek, tglDenda, days);
        } else {
            //CEK APAKAH JADWAL YG ADA SUDAH PERNAH DIBAYAR
            cekJadwalDendaSudahDibayar(request, pinjaman, listJadwalDenda);
        }
    }

    public synchronized void cekJadwalDendaSudahDibayar(HttpServletRequest request, Pinjaman pinjaman, Vector<JadwalAngsuran> listJadwalDenda) {
        for (JadwalAngsuran ja : listJadwalDenda) {
            Vector listAngsuranDenda = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + ja.getOID(), null);
            if (listAngsuranDenda.isEmpty()) {
                //hold dulu
            }
        }
    }

    public synchronized void buatJadwalDenda(HttpServletRequest request, Pinjaman pinjaman, MappingDendaPinjaman dendaPinjaman, long idJadwalParent, Date tglTempo, Date periodeStart, Date periodeEnd, Date dateCek, Date tglDenda) {
        //get nilai denda
        double nilaiDenda = getNilaiDenda(pinjaman, dendaPinjaman, tglTempo, dateCek);
        if (nilaiDenda <= 0) {
            this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Terjadi kesalahan, saat pengecekan di tanggal " + Formater.formatDate(dateCek, "dd-MM-yyyy") + ", nilai denda untuk nomor pinjaman '" + pinjaman.getNoKredit() + "' jadwal angsuran " + tglTempo + " menghasilkan Rp. " + nilaiDenda;
            return;
        }
        double pembulatanDenda = nilaiDenda;
        //cek sysprop untuk pembulatan nilai denda
        int useRounding = 0;
        try {
            useRounding = Integer.valueOf(PstSystemProperty.getValueByName("GUNAKAN_PEMBULATAN_ANGSURAN"));
            if (useRounding == 1) {
                pembulatanDenda = (Math.floor((nilaiDenda + 499) / 500)) * 500;
            } else {
                DecimalFormat df = new DecimalFormat("#.##");
                pembulatanDenda = Double.valueOf(df.format(pembulatanDenda));
            }
        } catch (Exception exc) {
            printErrorMessage(exc.getMessage());
        }

        double sisaDenda = pembulatanDenda - nilaiDenda;

        //buat transaksi
        if (this.tipeAngsuranGenerate == JadwalAngsuran.TIPE_ANGSURAN_DENDA) {
            this.oidTransaksi = saveTransaksi(request, pinjaman, Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_DENDA, Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN);
        } else if (this.tipeAngsuranGenerate == JadwalAngsuran.TIPE_ANGSURAN_BUNGA_TAMBAHAN) {
            this.oidTransaksi = saveTransaksi(request, pinjaman, Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_BUNGA_TAMBAHAN, Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN);
        }
        if (this.oidTransaksi == 0) {
            this.error += 1;
            this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Gagal menyimpan data transaksi pencatatan denda untuk nomor pinjaman '" + pinjaman.getNoKredit() + "'! ";
            return;
        }
        //simpan record denda
        try {
            JadwalAngsuran jadwalAngsuran = new JadwalAngsuran();
            jadwalAngsuran.setPinjamanId(pinjaman.getOID());
            jadwalAngsuran.setTanggalAngsuran(tglDenda);
            jadwalAngsuran.setJenisAngsuran(this.tipeAngsuranGenerate);
            jadwalAngsuran.setJumlahANgsuran(pembulatanDenda);
            jadwalAngsuran.setTransaksiId(this.oidTransaksi);
            jadwalAngsuran.setParentJadwalAngsuranId(idJadwalParent);
            jadwalAngsuran.setStartDate(periodeStart);
            jadwalAngsuran.setEndDate(periodeEnd);
            jadwalAngsuran.setJumlahAngsuranSeharusnya(nilaiDenda);
            jadwalAngsuran.setSisa(sisaDenda);
            PstJadwalAngsuran.insertExc(jadwalAngsuran);
            this.dendaDibuat += 1;
            if (!this.oidKreditDenda.contains(pinjaman.getOID())) {
                this.oidKreditDenda.add(pinjaman.getOID());
            }
        } catch (DBException ex) {
            this.error = 1;
            this.message = "<br><i class='fa fa-exclamation-circle text-red'></i> Gagal menyimpan jadwal angsuran denda untuk nomor pinjaman '" + pinjaman.getNoKredit() + "'! <br>" + ex.getMessage();
            printErrorMessage(ex.getMessage());
        }
    }
    public synchronized void buatJadwalDendaV2(HttpServletRequest request, Pinjaman pinjaman, MappingDendaPinjaman dendaPinjaman, long idJadwalParent, Date tglTempo, Date periodeStart, Date periodeEnd, Date dateCek, Date tglDenda, int days) {
        //get nilai denda
        double nilaiDenda = getNilaiDendaV2(pinjaman, dendaPinjaman, tglTempo, dateCek, days);
        if (nilaiDenda <= 0) {
            this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Terjadi kesalahan, saat pengecekan di tanggal " + Formater.formatDate(dateCek, "dd-MM-yyyy") + ", nilai denda untuk nomor pinjaman '" + pinjaman.getNoKredit() + "' jadwal angsuran " + tglTempo + " menghasilkan Rp. " + nilaiDenda;
            return;
        }
        double pembulatanDenda = nilaiDenda;
        //cek sysprop untuk pembulatan nilai denda
        int useRounding = 0;
        try {
            useRounding = Integer.valueOf(PstSystemProperty.getValueByName("GUNAKAN_PEMBULATAN_ANGSURAN"));
            if (useRounding == 1) {
                pembulatanDenda = (Math.floor((nilaiDenda + 499) / 500)) * 500;
            } else {
                DecimalFormat df = new DecimalFormat("#.##");
                pembulatanDenda = Double.valueOf(df.format(pembulatanDenda));
                pembulatanDenda = convertInteger(-3, pembulatanDenda);
            }
        } catch (Exception exc) {
            printErrorMessage(exc.getMessage());
        }

        double sisaDenda = pembulatanDenda - nilaiDenda;

        //buat transaksi
        if (this.tipeAngsuranGenerate == JadwalAngsuran.TIPE_ANGSURAN_DENDA) {
            this.oidTransaksi = saveTransaksi(request, pinjaman, Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_DENDA, Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN);
        } else if (this.tipeAngsuranGenerate == JadwalAngsuran.TIPE_ANGSURAN_BUNGA_TAMBAHAN) {
            this.oidTransaksi = saveTransaksi(request, pinjaman, Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_BUNGA_TAMBAHAN, Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN);
        }
        if (this.oidTransaksi == 0) {
            this.error += 1;
            this.message += "<br><i class='fa fa-exclamation-circle text-red'></i> Gagal menyimpan data transaksi pencatatan denda untuk nomor pinjaman '" + pinjaman.getNoKredit() + "'! ";
            return;
        }
        //simpan record denda
        try {
            
            String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + pinjaman.getOID()
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_DENDA 
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + Formater.formatDate(tglDenda, "yyyy-MM-dd") + "'";
            Vector<JadwalAngsuran> angsuran = PstJadwalAngsuran.list(0, 0, whereClause, "");
            JadwalAngsuran jadwalAngsuran = new JadwalAngsuran();
            if(!angsuran.isEmpty()){
                jadwalAngsuran = angsuran.get(0);
            }
            jadwalAngsuran.setPinjamanId(pinjaman.getOID());
            jadwalAngsuran.setTanggalAngsuran(tglDenda);
            jadwalAngsuran.setJenisAngsuran(this.tipeAngsuranGenerate);
            jadwalAngsuran.setJumlahANgsuran(pembulatanDenda);
            jadwalAngsuran.setTransaksiId(this.oidTransaksi);
            jadwalAngsuran.setParentJadwalAngsuranId(idJadwalParent);
            jadwalAngsuran.setStartDate(periodeStart);
            jadwalAngsuran.setEndDate(periodeEnd);
            jadwalAngsuran.setJumlahAngsuranSeharusnya(nilaiDenda);
            jadwalAngsuran.setSisa(sisaDenda);
            if(jadwalAngsuran.getOID() == 0){
                PstJadwalAngsuran.insertExc(jadwalAngsuran);
            } else {
                PstJadwalAngsuran.updateExc(jadwalAngsuran);
            }
            this.dendaDibuat += 1;
            if (!this.oidKreditDenda.contains(pinjaman.getOID())) {
                this.oidKreditDenda.add(pinjaman.getOID());
            }
        } catch (DBException ex) {
            this.error = 1;
            this.message = "<br><i class='fa fa-exclamation-circle text-red'></i> Gagal menyimpan jadwal angsuran denda untuk nomor pinjaman '" + pinjaman.getNoKredit() + "'! <br>" + ex.getMessage();
            printErrorMessage(ex.getMessage());
        }
    }

    public Date generateTanggalDenda2(Pinjaman pinjaman, Date tglTempo, Date dateCek) {
        JenisKredit jK = PstJenisKredit.fetch(pinjaman.getTipeKreditId());
        Calendar date = Calendar.getInstance();
        date.setTime(tglTempo);
        switch (jK.getTipeFrekuensiPokokLegacy()) {
            case JenisKredit.TIPE_KREDIT_HARIAN:
                date.add(Calendar.DAY_OF_MONTH, 1);
                break;
            case JenisKredit.TIPE_KREDIT_MINGGUAN:
                date.add(Calendar.WEEK_OF_MONTH, 1);
                break;
            default:
//                date.add(Calendar.MONTH, 1);
                break;
        }
        Date tglDenda = date.getTime();
        return tglDenda;
    }

    public Date generateTanggalDenda(Pinjaman pinjaman, Date tglTempo, Date dateCek) {
        Date tglDenda = tglTempo;
        boolean check = true;
        while (check) {
            Date jadwalBaru = getNextSchedule(pinjaman, tglDenda);
            int compareDate = jadwalBaru.compareTo(dateCek);
            if (compareDate > 0) {
                check = false;
            } else {
                tglDenda = jadwalBaru;
            }
        }
        return tglDenda;
    }

    public Date getNextSchedule(Pinjaman pinjaman, Date tglTempo) {
        Date jadwalBaru = tglTempo;
        SessKreditKalkulasi k = new SessKreditKalkulasi();
        k.setKredit(PstJenisKredit.fetch(pinjaman.getTipeKreditId()));
        k.setRealizationDate(tglTempo);
        k.setPengajuanTotal(pinjaman.getJumlahPinjaman());
        k.setSukuBunga(pinjaman.getSukuBunga());
        k.setJangkaWaktu(pinjaman.getJangkaWaktu());
        k.setTipeBunga(pinjaman.getTipeBunga());
        k.setDateTempo(tglTempo);
        k.setTipeJadwal(pinjaman.getTipeJadwal());
        k.generateDataKredit();
        for (int i = 1; i < k.getTSize(); i++) {
            if (k.getTDate(i).after(tglTempo)) {
                jadwalBaru = k.getTDate(i);
                break;
            }
        }
        return jadwalBaru;
    }

    public double getNilaiDenda(Pinjaman pinjaman, MappingDendaPinjaman dendaPinjaman, Date tglTempo, Date dateCek) {
        double nilaiPokok = 0;
        double nilaiBunga = 0;
        double pokokDibayar = 0;
        double bungaDibayar = 0;
        String textTglJadwal = Formater.formatDate(tglTempo, "yyyy-MM-dd");
        String textTglCek = Formater.formatDate(dateCek, "yyyy-MM-dd");

        int tipeVariabel = dendaPinjaman.getTipeVariabelDenda();

        //get nilai angsuran sesuai variabel rumus
        if (dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_POKOK || dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_SEMUA) {
            if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_AKUMULASI) {
                //nilaiPokok = SessReportKredit.getTotalAngsuranDariJadwalPertama(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, textJadwal);
                nilaiPokok = SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
            } else if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_PER_JADWAL) {
                nilaiPokok = SessReportKredit.getTotalAngsuranPerJadwal(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, textTglJadwal);
            }
        }
        if (dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_BUNGA || dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_SEMUA) {
            if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_AKUMULASI) {
                //nilaiBunga = SessReportKredit.getTotalAngsuranDariJadwalPertama(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA, textJadwal);
                nilaiBunga = SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
            } else if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_PER_JADWAL) {
                nilaiBunga = SessReportKredit.getTotalAngsuranPerJadwal(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA, textTglJadwal);
            }
        }

        //get nilai dibayar
        if (dendaPinjaman.getTipePerhitunganDenda() == JenisKredit.TIPE_PERHITUNGAN_DENDA_SISA) {
            //nilai angsuran dikurangi nilai angsuran yg sudah dibayar
            if (dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_POKOK || dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_SEMUA) {
                if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_AKUMULASI) {
                    //pokokDibayar = SessReportKredit.getTotalAngsuranDibayarDariJadwalPertama(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, textJadwal);
                    pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                } else if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_PER_JADWAL) {
                    pokokDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, textTglJadwal);
                }
            }
            if (dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_BUNGA || dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_SEMUA) {
                if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_AKUMULASI) {
                    //bungaDibayar = SessReportKredit.getTotalAngsuranDibayarDariJadwalPertama(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA, textJadwal);
                    bungaDibayar = SessReportKredit.getTotalAngsuranDibayar(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                } else if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_PER_JADWAL) {
                    bungaDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA, textTglJadwal);
                }
            }
        } else if (dendaPinjaman.getTipePerhitunganDenda() == JenisKredit.TIPE_PERHITUNGAN_DENDA_FULL) {
            //angsuran yg sudah dibayar tidak diperhitungkan
        }

        //RUMUS DENDA LENGKAP = (TOTAL ANGSURAN - TOTAL ANGSURAN DIBAYAR) * %DENDA
        this.history = "("
                + "(" + nilaiPokok + "-" + pokokDibayar + ")"
                + "+"
                + "(" + nilaiBunga + "-" + bungaDibayar + ")"
                + ")"
                + "*" + dendaPinjaman.getNilaiDenda() + "/100"
                + "";

        double nilaiDenda = ((nilaiPokok - pokokDibayar) + (nilaiBunga - bungaDibayar)) * dendaPinjaman.getNilaiDenda() / 100;
        return nilaiDenda;
    }
    public double getNilaiDendaV2(Pinjaman pinjaman, MappingDendaPinjaman dendaPinjaman, Date tglTempo, Date dateCek, int days) {
        double nilaiPokok = 0;
        double nilaiBunga = 0;
        double pokokDibayar = 0;
        double bungaDibayar = 0;
        String textTglJadwal = Formater.formatDate(tglTempo, "yyyy-MM-dd");
        String textTglCek = Formater.formatDate(dateCek, "yyyy-MM-dd");

        int tipeVariabel = dendaPinjaman.getTipeVariabelDenda();
        
        //get nilai angsuran sesuai variabel rumus
        if (dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_POKOK || dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_SEMUA) {
            if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_AKUMULASI) {
                //nilaiPokok = SessReportKredit.getTotalAngsuranDariJadwalPertama(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, textJadwal);
                nilaiPokok = SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
            } else if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_PER_JADWAL) {
                nilaiPokok = SessReportKredit.getTotalAngsuranPerJadwal(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, textTglJadwal);
            }
        }
        if (dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_BUNGA || dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_SEMUA) {
            if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_AKUMULASI) {
                //nilaiBunga = SessReportKredit.getTotalAngsuranDariJadwalPertama(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA, textJadwal);
                nilaiBunga = SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
            } else if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_PER_JADWAL) {
                nilaiBunga = SessReportKredit.getTotalAngsuranPerJadwal(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA, textTglJadwal);
            }
        }

        //get nilai dibayar
        if (dendaPinjaman.getTipePerhitunganDenda() == JenisKredit.TIPE_PERHITUNGAN_DENDA_SISA) {
            //nilai angsuran dikurangi nilai angsuran yg sudah dibayar
            if (dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_POKOK || dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_SEMUA) {
                if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_AKUMULASI) {
                    //pokokDibayar = SessReportKredit.getTotalAngsuranDibayarDariJadwalPertama(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, textJadwal);
                    pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                } else if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_PER_JADWAL) {
                    pokokDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, textTglJadwal);
                }
            }
            if (dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_BUNGA || dendaPinjaman.getVariabelDenda() == JenisKredit.VARIABEL_DENDA_SEMUA) {
                if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_AKUMULASI) {
                    //bungaDibayar = SessReportKredit.getTotalAngsuranDibayarDariJadwalPertama(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA, textJadwal);
                    bungaDibayar = SessReportKredit.getTotalAngsuranDibayar(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                } else if (tipeVariabel == JenisKredit.TIPE_VARIABEL_DENDA_PER_JADWAL) {
                    bungaDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA, textTglJadwal);
                }
            }
        } else if (dendaPinjaman.getTipePerhitunganDenda() == JenisKredit.TIPE_PERHITUNGAN_DENDA_FULL) {
            //angsuran yg sudah dibayar tidak diperhitungkan
        }

        //RUMUS DENDA LENGKAP = (TOTAL ANGSURAN - TOTAL ANGSURAN DIBAYAR) * %DENDA
        this.history = "("
                + "(" + nilaiPokok + "-" + pokokDibayar + ")"
                + "+"
                + "(" + nilaiBunga + "-" + bungaDibayar + ")"
                + ")"
                + "*" + dendaPinjaman.getNilaiDenda() + "/100"
                + "";

        double nilaiDenda = (((nilaiPokok - pokokDibayar) + (nilaiBunga - bungaDibayar)) * dendaPinjaman.getNilaiDenda() / 100) * (days > 0 ? days : 1);
        return nilaiDenda;
    }

    public void showDataDenda(HttpServletRequest request) {
        //TAMPILKAN INFORMASI
        int generateDenda = FRMQueryString.requestInt(request, "GENERATE_NEW_DENDA");
        if (generateDenda == 1) {
            if (this.oidKreditDenda.isEmpty()) {
                this.message = "Tidak ada angsuran baru. " + this.message;
            } else {
                this.message = "Terdapat <b>" + this.dendaDibuat + "</b> angsuran baru untuk <b>" + this.oidKreditDenda.size() + "</b> data kredit. " + this.message;
            }
            this.message += "<hr style='margin: 10px 0px'>";
        }

        //TAMPILKAN DATA ANGSURAN
        String periodeCek = "<b>" + this.rangeAwal + " s/d " + this.rangeAkhir + "</b>";
        if (this.rangeAwal.equals(this.rangeAkhir)) {
            periodeCek = this.rangeAwal;
        }
        this.htmlReturn = ""
                + " <div class=''>"
                + "     <p>Data angsuran periode <b>" + periodeCek + "</b></p>"
                + "     <table class='table table-bordered table-stripped' style='font-size: 14px;margin-bottom: 0px'>"
                + "         <tr class='label-success text-center'>"
                + "             <td style='width: 1%'>No.</td>"
                + "             <td>Nomor Kredit</td>"
                + "             <td id='namaNasabah'>Nama </td>"
                + "             <td>Jatuh Tempo</td>"
                + "             <td>Total Angsuran</td>"
                + "         </tr>"
                + "";

        Vector<JadwalAngsuran> listAllDenda = SessKredit.getListDenda(this.rangeAwal, this.rangeAkhir, this.tipeAngsuranGenerate);

        if (listAllDenda.isEmpty()) {
            this.htmlReturn += ""
                    + "<tr class='text-center label-default'><td colspan='5'>Data angsuran tidak ditemukan</td></tr>"
                    + "";
        }
        int i = 0;
        long idKredit = 0;
        for (JadwalAngsuran ja : listAllDenda) {
            i++;
            Pinjaman p = new Pinjaman();
            Anggota a = new Anggota();
            try {
                if (PstPinjaman.checkOID(ja.getPinjamanId())) {
                    p = PstPinjaman.fetchExc(ja.getPinjamanId());
                }
                if (p.getAnggotaId() > 0) {
                    a = PstAnggota.fetchExc(p.getAnggotaId());
                }
            } catch (Exception e) {
                printErrorMessage(e.getMessage());
            }

            String no = "";
            String kodeKredit = "";
            String nama = "";
            if (idKredit != p.getOID()) {
                idKredit = p.getOID();
                no = "" + i;
                kodeKredit = p.getNoKredit();
                nama = a.getName();
            }

            this.htmlReturn += ""
                    + "     <tr>"
                    + "         <td class='text-center'>" + no + "</td>"
                    + "         <td class='text-left'>" + kodeKredit + "</td>"
                    + "         <td>" + nama + "</td>"
                    + "         <td class='text-center'>" + Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy") + "</td>"
                    + "         <td class='text-right money'>" + ja.getJumlahANgsuran() + "</td>"
                    + "     </tr>"
                    + "";
        }
        this.htmlReturn += "</table>";
    }

    public void commandDelete(HttpServletRequest request) {

    }

    public void commandList(HttpServletRequest request, HttpServletResponse response) {
        if (this.dataFor.equals("listSchedule")) {
            String[] cols = {
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN],
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN],
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN],
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN],
                "",
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listJadwalAngsuran")) {
            String[] cols = {
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN],
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN],
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN],
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN],
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN],
                "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN]
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        }
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

        if (dataFor.equals("listSchedule")) {
            if (whereClause.length() > 0) {
                whereClause += "AND ("
                        + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            } else {
                whereClause += " ("
                        + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        } else if (dataFor.equals("listJadwalAngsuran")) {
            if (whereClause.length() > 0) {
                whereClause += "AND ("
                        + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            } else {
                whereClause += " ("
                        + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                        + ")";
            }
        }

        String colName = cols[col];
        int total = -1;

        if (dataFor.equals("listSchedule")) {
            String jenisAngsuran = "";
            if(this.jenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA){
                jenisAngsuran = "" + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
            } else {
                jenisAngsuran = "" + this.jenisAngsuran;
            }
            String whereAdd = " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + this.oid + "'"
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " IN (" + jenisAngsuran + ")";
            if (this.oidMulti.length() > 0) {
                whereAdd += " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " NOT IN (" + this.oidMulti + ")";
            }
            total = PstJadwalAngsuran.getCount(whereClause + whereAdd);
        } else if (dataFor.equals("listJadwalAngsuran")) {
            total = PstJadwalAngsuran.list(0, 0, whereClause + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + this.oid + "'"
                    + " GROUP BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN], null).size();
        }

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

    String whereClause = "";
    String order = "";
    int useRaditya = Integer.parseInt(PstSystemProperty.getValueByName("USE_FOR_RADITYA"));

    if (this.searchTerm == null) {
      whereClause += "";
    } else {
      if (datafor.equals("listSchedule")) {
        if (whereClause.length() > 0) {
          whereClause += "AND ("
                  + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + ")";
        } else {
          whereClause += " ("
                  + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + ")";
        }
      } else if (datafor.equals("listJadwalAngsuran")) {
        if (whereClause.length() > 0) {
          whereClause += "AND ("
                  + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + ")";
        } else {
          whereClause += " ("
                  + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + " OR " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " LIKE '%" + searchTerm + "%'"
                  + ")";
        }
      }
    }

    if (this.colOrder >= 0) {
      order += "" + colName + " " + dir + "";
    }

    Vector listData = new Vector(1, 1);
    if (datafor.equals("listSchedule")) {
      if (this.jenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA) {
        String whereAdd = ""
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + this.oid + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
        if (this.oidMulti.length() > 0) {
          whereAdd += " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " NOT IN (" + this.oidMulti + ")";
        }
        listData = PstJadwalAngsuran.list(start, amount, whereClause + whereAdd, order);

      } else {
        String whereAdd = ""
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + this.oid + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + this.jenisAngsuran + "'";
        if (this.oidMulti.length() > 0) {
          whereAdd += " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " NOT IN (" + this.oidMulti + ")";
        }
        listData = PstJadwalAngsuran.list(start, amount, whereClause + whereAdd, order);
      }
    } else if (datafor.equals("listJadwalAngsuran")) {
      listData = PstJadwalAngsuran.list(start, amount, whereClause + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + this.oid + "'"
              + " GROUP BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN], order);
    }

    for (int i = 0; i < listData.size(); i++) {
      JSONArray ja = new JSONArray();
        if (datafor.equals("listSchedule")) {
            JadwalAngsuran jadwal = (JadwalAngsuran) listData.get(i);
            String tglTempo = Formater.formatDate(jadwal.getTanggalAngsuran(), "dd MMM yyyy");
            //set warna info jika terlambat
            String color = "";
            String sNow = Formater.formatDate(new Date(), "yyyy-MM-dd");
            Date dateNow = Formater.formatDate(sNow, "yyyy-MM-dd");
            if (jadwal.getTanggalAngsuran().before(dateNow)) {
                color = "red";
            }
            //get info denda atas jadwal yg mana
            String dendaAtasJadwal = "";
            if (jadwal.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_DENDA) {
                try {
                    JadwalAngsuran parent = PstJadwalAngsuran.fetchExc(jadwal.getParentJadwalAngsuranId());
                    dendaAtasJadwal = "Denda atas " + JadwalAngsuran.getTipeAngsuranTitle(parent.getJenisAngsuran()).toLowerCase();
                    dendaAtasJadwal += " tanggal " + Formater.formatDate(parent.getTanggalAngsuran(), "dd MMM yyyy");
                    dendaAtasJadwal = " &nbsp; <span data-toggle='tooltip' data-placement='top' title='" + dendaAtasJadwal + "'><i class='fa fa-question-circle' style='color: lightgrey'></i></span>";
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                }
            }
            //get jumlah angsuran dan nilai dibayar
            int banyakAngsuran = PstAngsuran.getCount("" + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jadwal.getOID() + "'");
            double totalAngsuran = 0;

            //format angka jadi 2 digit desimal
            DecimalFormat df = new DecimalFormat("#.##");
            double newJumlah = 0;
            double newTotal = 0;
            if (this.jenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA) {
                String tglAngsuran = Formater.formatDate(jadwal.getTanggalAngsuran(), "yyyy-MM-dd");
                Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.getAngsuranWithBunga(jadwal.getPinjamanId(), tglAngsuran);
                for (JadwalAngsuran jada : listAngsuran) {
                    totalAngsuran = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jada.getOID() + "'");
                    newTotal += totalAngsuran;
                }
                double jumlahAngsuran = PstJadwalAngsuran.getJumlahAngsuranWithBunga(jadwal.getPinjamanId(), tglAngsuran);
                newJumlah = jumlahAngsuran;
            } else {
                totalAngsuran = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jadwal.getOID() + "'");
                newJumlah = Double.valueOf(df.format(jadwal.getJumlahANgsuran()));
            }
            
            double newTotalAngsuran = Double.valueOf(df.format(totalAngsuran));
            double sisa = newJumlah - newTotalAngsuran;
            if (this.jenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA) {
                newTotalAngsuran = Double.valueOf(df.format(newTotal));
                sisa = newJumlah - newTotalAngsuran;
                ja.put("" + (this.start + i + 1) + ".");
                if (newTotalAngsuran >= newJumlah) {
                    ja.put("" + tglTempo + dendaAtasJadwal);
                } else {
                    ja.put("<a href='#' style='color: " + color + "' class='btn-actionschedule' data-jenis='" + this.jenisAngsuran + "' data-sisa='" + sisa + "' data-oid='" + jadwal.getOID() + "'>" + tglTempo + "</a>" + dendaAtasJadwal);
                }
                if (useRaditya == 1) {
                    ja.put(" <div class='text-center'> Angsuran Ke-" + (this.start + i + 1) + "</div>");
                } else {
                    ja.put("" + JadwalAngsuran.getTipeAngsuranTitle(jadwal.getJenisAngsuran()));
                }
                ja.put("<div class='money text-right'>" + newJumlah + "</div>");
                ja.put("<div class='money text-right'>" + newTotalAngsuran + "</div>");
                ja.put("" + banyakAngsuran + " kali");
                ja.put("<div class='money text-right'>" + sisa + "</div>");

                if (newTotalAngsuran >= newJumlah && banyakAngsuran > 0) {
                    ja.put("<div class='text-center'>Lunas</div>");
                } else {
                    ja.put("<div class='text-center'><input type='checkbox' data-jenis='" + this.jenisAngsuran + "' class='check_multi' value='" + jadwal.getOID() + "'></div>");
                }
                array.put(ja);

            } else {
                ja.put("" + (this.start + i + 1) + ".");
                if (newTotalAngsuran >= newJumlah) {
                    ja.put("" + tglTempo + dendaAtasJadwal);
                } else {
                    ja.put("<a href='#' style='color: " + color + "' class='btn-actionschedule' data-jenis='" + this.jenisAngsuran + "' data-sisa='" + sisa + "' data-oid='" + jadwal.getOID() + "'>" + tglTempo + "</a>" + dendaAtasJadwal);
                }
                if (useRaditya == 1) {
                    ja.put(" <div class='text-center'> Angsuran Ke-" + (this.start + i + 1) + "</div>");
                } else {
                    ja.put("" + JadwalAngsuran.getTipeAngsuranTitle(jadwal.getJenisAngsuran()));
                }
                ja.put("<div class='money text-right'>" + newJumlah + "</div>");
                ja.put("<div class='money text-right'>" + newTotalAngsuran + "</div>");
                ja.put("" + banyakAngsuran + " kali");
                ja.put("<div class='money text-right'>" + sisa + "</div>");
                if (newTotalAngsuran >= newJumlah && banyakAngsuran > 0) {
                    ja.put("<div class='text-center'>Lunas</div>");
                } else {
                    ja.put("<div class='text-center'><input type='checkbox' data-jenis='" + this.jenisAngsuran + "' class='check_multi' value='" + jadwal.getOID() + "'></div>");
                }
                array.put(ja);
            }
        } else if (datafor.equals("listJadwalAngsuran")) {
        JadwalAngsuran jadwal = (JadwalAngsuran) listData.get(i);
        //GET NILAI ANGSURAN

        //CEK APAKAH PUNYA DP
        Map<String, String> mapScheduleDp = getScheduleDetail(jadwal, JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT);
        double dp = Double.valueOf(mapScheduleDp.get("JUMLAH_ANGSURAN"));
        String statusDp = mapScheduleDp.get("STATUS_LUNAS");
        String statusDpTerlambat = mapScheduleDp.get("STATUS_TERLAMBAT");

        //CEK APAKAH PUNYA JADWAL POKOK
        Map<String, String> mapSchedulePokok = getScheduleDetail(jadwal, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
        double pokok = Double.valueOf(mapSchedulePokok.get("JUMLAH_ANGSURAN"));
        String statusPokok = mapSchedulePokok.get("STATUS_LUNAS");
        String statusPokokTerlambat = mapSchedulePokok.get("STATUS_TERLAMBAT");

        //CEK APAKAH PUNYA JADWAL BUNGA
        Map<String, String> mapScheduleBunga = getScheduleDetail(jadwal, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
        double bunga = Double.valueOf(mapScheduleBunga.get("JUMLAH_ANGSURAN"));
        String statusBunga = mapScheduleBunga.get("STATUS_LUNAS");
        String statusBungaTerlambat = mapScheduleBunga.get("STATUS_TERLAMBAT");

        //CEK APAKAH PUNYA JADWAL DENDA
        Map<String, String> mapScheduleDenda = getScheduleDetail(jadwal, JadwalAngsuran.TIPE_ANGSURAN_DENDA);
        double denda = Double.valueOf(mapScheduleDenda.get("JUMLAH_ANGSURAN"));
        String statusDenda = mapScheduleDenda.get("STATUS_LUNAS");
        String statusDendaTerlambat = mapScheduleDenda.get("STATUS_TERLAMBAT");

        //CEK APAKAH PUNYA JADWAL PENALTY
        int tipeJadwal = (jadwal.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_DINI) ? JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_DINI : JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_MACET;
        Map<String, String> mapSchedulePenalty = getScheduleDetail(jadwal, tipeJadwal);
        double penalty = Double.valueOf(mapSchedulePenalty.get("JUMLAH_ANGSURAN"));
        String statusPenalty = mapSchedulePenalty.get("STATUS_LUNAS");
        String statusPenaltyTerlambat = mapSchedulePenalty.get("STATUS_TERLAMBAT");

        statusDp = statusDp.isEmpty() ? "" : "&nbsp;&nbsp;" + statusDp;
        statusDpTerlambat = statusDpTerlambat.isEmpty() ? "" : "&nbsp;&nbsp;" + statusDpTerlambat;
        statusPokok = statusPokok.isEmpty() ? "" : "&nbsp;&nbsp;" + statusPokok;
        statusPokokTerlambat = statusPokokTerlambat.isEmpty() ? "" : "&nbsp;&nbsp;" + statusPokokTerlambat;
        statusBunga = statusBunga.isEmpty() ? "" : "&nbsp;&nbsp;" + statusBunga;
        statusBungaTerlambat = statusBungaTerlambat.isEmpty() ? "" : "&nbsp;&nbsp;" + statusBungaTerlambat;
        statusDenda = statusDenda.isEmpty() ? "" : "&nbsp;&nbsp;" + statusDenda;
        statusDendaTerlambat = statusDendaTerlambat.isEmpty() ? "" : "&nbsp;&nbsp;" + statusDendaTerlambat;
        statusPenalty = statusPenalty.isEmpty() ? "" : "&nbsp;&nbsp;" + statusPenalty;
        statusPenaltyTerlambat = statusPenaltyTerlambat.isEmpty() ? "" : "&nbsp;&nbsp;" + statusPenaltyTerlambat;

        //GET DATA TRANSAKSI
        String whereTransaksi = ""
                + " t." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + "= '" + this.oid + "'"
                + " AND ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + jadwal.getTanggalAngsuran() + "'"
                + " GROUP BY t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID];
        Vector<Transaksi> listTransaksi = SessKredit.getListTransaksiAngsuran(0, 0, whereTransaksi, "");
        String kodeTransaksi = "";
        for (int k = 0; k < listTransaksi.size(); k++) {
          kodeTransaksi += (k > 0) ? " , " : "";
          kodeTransaksi += "<a class='no_transaksi text-wrap' data-oid='" + listTransaksi.get(k).getOID() + "'>" + listTransaksi.get(k).getKodeBuktiTransaksi() + "</a>";
        }

        String tglAngsuran = Formater.formatDate(jadwal.getTanggalAngsuran(), "dd MMM yyyy");
        try {
          Pinjaman p = PstPinjaman.fetchExc(jadwal.getPinjamanId());
          JenisKredit jk = PstJenisKredit.fetch(p.getTipeKreditId());
          if (jk.getTipeFrekuensiPokokLegacy() == JenisKredit.TIPE_KREDIT_HARIAN) {
            tglAngsuran = Formater.formatDate(jadwal.getTanggalAngsuran(), "EEE, dd MMM yyyy");
          }
        } catch (Exception e) {
          printErrorMessage(e.getMessage());
        }

        DecimalFormat df = new DecimalFormat("#.##");
        pokok = Double.valueOf(df.format(pokok));
        bunga = Double.valueOf(df.format(bunga));
        denda = Double.valueOf(df.format(denda));
        penalty = Double.valueOf(df.format(penalty));
        String kwitansiStr = "";

        ja.put("" + (this.start + i + 1) + ".");
        ja.put("" + tglAngsuran);
        if (dp != 0) {
          ja.put("" + "<div class='text-right'><span class='money'>" + dp + "</span>" + statusDp + "" + statusDpTerlambat + "</div>");
          kwitansiStr = "" + "<div class='text-center'>" + jadwal.getNoKwitansi() + " " + statusDp + " " + statusDpTerlambat + "</div>";
        } else {
          ja.put("" + "<div class='text-right'><span class='money'>" + pokok + "</span>" + statusPokok + "" + statusPokokTerlambat + "</div>");
          kwitansiStr = "" + "<div class='text-center'>" + jadwal.getNoKwitansi() + " " + statusPokok + " " + statusPokokTerlambat + "</div>";
        }
        //if(enableTabungan == 1){
        ja.put("" + "<div class='text-right'><span class='money'>" + bunga + "</span>" + statusBunga + "" + statusBungaTerlambat + "</div>");
        //}
        ja.put("" + "<div class='text-right'><span class='money'>" + denda + "</span>" + statusDenda + "" + statusDendaTerlambat + "</div>");
        ja.put("" + "<div class='text-right'><span class='money'>" + penalty + "</span>" + statusPenalty + "" + statusPenaltyTerlambat + "</div>");

        ja.put(kwitansiStr);

        ja.put("" + kodeTransaksi);
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

    public void commandNone(HttpServletRequest request) {
        if (this.dataFor.equals("getDataAngsuran")) {
            getDataAngsuran(request);
        } else if (this.dataFor.equals("getSchedule")) {
            getSchedule(request);
        } else if (this.dataFor.equals("getPrioritySchedule")) {
            getPrioritySchedule(request);
        } else if (this.dataFor.equals("getSelectedSchedule")) {
            getSelectedSchedule(request);
        } else if (this.dataFor.equals("getAngsuranDP")) {
            getAngsuranDP(request);
        } else if (this.dataFor.equals("getAngsuranPertama")) {
            getAngsuranPertama(request);
        } else if (this.dataFor.equals("cetakKartuAngsuran")) {
            cetakKartuAngsuran(request);
        } else if (this.dataFor.equals("getScheduleBayarLunas")){
            getScheduleBayarLunas(request);
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

    public void cetakKartuAngsuran(HttpServletRequest request){
        int isDuplicate = FRMQueryString.requestInt(request, "printDuplicate");
        Pinjaman p = new Pinjaman();
        try {
            p = PstPinjaman.fetchExc(this.oid);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        String title = "";
        String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
        if(isDuplicate == JadwalAngsuran.CETAK_NORMAL){
            title = "Kartu Angsuran " + namaNasabah;
        } else {
            title = PstSystemProperty.getValueByName("COMPANY_NAME");
        }
        String html = "";
        
        String whereClause = PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = " + p.getOID() 
                + " AND " +PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_STATUS_CETAK] + " = " + JadwalAngsuran.STATUS_CETAK_PRINTED;
        int count = PstJadwalAngsuran.getCount(whereClause);
        boolean pernahCetak = count > 0;
        
        
        html += headerKartuAngsuran(request, p, pernahCetak, title);
        html += isiKartuAngsuran(request, p);
        this.htmlReturn = html;
    }
    
    public String headerKartuAngsuran(HttpServletRequest request, Pinjaman p, boolean pernahCetak, String title){
        String html = ""; 
        try {
            Anggota a = new Anggota();
            Vector<JadwalAngsuran> listJa = new Vector<>();
            ArrayList<Billdetail> listBarang = new ArrayList<>();
            JangkaWaktu jw = new JangkaWaktu();
            
            String whereClause = "";
            String order = "";
            String dateFormat = "dd-MM-yyyy";
            String listBarangStr = "";
            String hilangkan = "";
//            String hilangkan = pernahCetak ? transparentStyle : "";
            double jumlahAngsuran = 0;
            try {
                a = PstAnggota.fetchExc(p.getAnggotaId());
                jw = PstJangkaWaktu.fetchExc(p.getJangkaWaktuId());
                
                whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] 
                        + " IN (" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ")"
                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID();
                order = "";
                listJa = PstJadwalAngsuran.list(0, 2, whereClause, order);
                
                whereClause = PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + " = " + p.getBillMainId();
                listBarang = PstBillDetail.listFromApi(0, 0, whereClause, "");
                
                for(JadwalAngsuran ja : listJa){
                    jumlahAngsuran += ja.getJumlahANgsuran();
                }
                
                int index = 0;
                for(Billdetail bd : listBarang){
                    if(index != 0){
                        listBarangStr += ", ";
                    }
                    listBarangStr += bd.getItemName();
                }
                
            } catch (Exception e) {
                System.out.println("Something happening in fetch some data in this section <Cetak Header Kartu Angsuran in AjaxJadwalAngsuran>");
                e.printStackTrace();
            }
            // nama : detail <kosong> nama : detail
            html += "<h3 style='" + hilangkan + "'>" + title + "</h3>"
                    + "<table class='print-header'>"
                    + "<tr>"
                    + "<td style='width: 15%; " + hilangkan + "'>No Kredit</td>"
                    + "<td style='width: 3%; " + hilangkan + "'> : </td>"
                    + "<td style='width: 20%; " + hilangkan + "'>" + p.getNoKredit() + "</td>"
                    + "<td style='width: 25%; " + hilangkan + "'></td>"
                    + "<td style='width: 15%; " + hilangkan + "'>Tgl. Pengambilan</td>"
                    + "<td style='width: 3%; " + hilangkan + "'> : </td>"
                    + "<td style='width: 20%; " + hilangkan + "'>" + Formater.formatDate(p.getTglRealisasi(), dateFormat) + "</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td style='" + hilangkan + "'>Nama</td>"
                    + "<td style='" + hilangkan + "'> : </td>"
                    + "<td style='" + hilangkan + "'>" + a.getName() + "</td>"
                    + "<td style='" + hilangkan + "'></td>"
                    + "<td style='" + hilangkan + "'>Tgl. Jatuh Tempo</td>"
                    + "<td style='" + hilangkan + "'> : </td>"
                    + "<td style='" + hilangkan + "'>" + Formater.formatDate(p.getJatuhTempo(), dateFormat) + "</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td style='" + hilangkan + "'>Alamat</td>"
                    + "<td style='" + hilangkan + "'> : </td>"
                    + "<td style='" + hilangkan + "'>" + a.getAddressPermanent() + "</td>"
                    + "<td style='" + hilangkan + "'></td>"
                    + "<td style='" + hilangkan + "'>Jangka Waktu</td>"
                    + "<td style='" + hilangkan + "'> : </td>"
                    + "<td style='" + hilangkan + "'>" + jw.getJangkaWaktu() + " x</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td style='" + hilangkan + "'>Total Kredit</td>"
                    + "<td style='" + hilangkan + "'> : </td>"
                    + "<td style='" + hilangkan + "'>" + formatNumber.format(p.getJumlahPinjaman()+p.getDownPayment()) + "</td>"
                    + "<td style='" + hilangkan + "'>&nbsp;</td>"
                    + "<td style='" + hilangkan + "'>Angsuran</td>"
                    + "<td style='" + hilangkan + "'> : </td>"
                    + "<td style='" + hilangkan + "'>" + formatNumber.format(jumlahAngsuran) + "</td>"
                    + "</tr>"
                    + "<td style='" + hilangkan + "'>Jenis Barang</td>"
                    + "<td style='" + hilangkan + "'> : </td>"
                    + "<td style='" + hilangkan + "' colspan='5'>" + listBarangStr + "</td>"
                    + "</tr>"
                    + "</table>";
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return html;
    }
    
    public String isiKartuAngsuran(HttpServletRequest request, Pinjaman p){
        String html = "";
        try {
            double jumlahPinjaman = SessKredit.getTotalAngsuran(p.getOID());
            String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID();
            Vector listJa = PstJadwalAngsuran.listDenganBunga(0, 0, whereClause, "");
            
            html += "<table class='print-content'>"
                    + "<tr>"
                    + "<td rowspan='2' style=' " + transparentStyle + "'>Tgl.</td>"
                    + "<td colspan='4' style=' " + transparentStyle + "'>Pembayaran</td>"
                    + "<td rowspan='2' style='width: 200px; " + transparentStyle + "'>Keterangan</td>"
                    + "<td rowspan='2' style='width: 100px; " + transparentStyle + "'>Tanda Tangan Penerima</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td style=' " + transparentStyle + "'>Jumlah Sewa</td>"
                    + "<td style=' " + transparentStyle + "'>Ongkos</td>"
                    + "<td style=' " + transparentStyle + "'>Jumlah</td>"
                    + "<td style=' " + transparentStyle + "'>Saldo Akhir</td>"
                    + "</tr>";
            
            whereClause = PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = " + p.getOID();
            Vector<BiayaTransaksi> listBiaya = SessKredit.getBiayaKredit(0, 0, whereClause, "");
            double totalBiaya = 0;
            boolean biayaSudahDibayar = false;
            for(BiayaTransaksi bt : listBiaya){
                int count = SessKredit.getCountTransaksiBiayaKredit(p.getOID(), bt.getIdJenisTransaksi());
                double biaya = 0;
                if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                    biaya = bt.getValueBiaya();
                } else {
                    biaya = p.getJumlahPinjaman() * bt.getValueBiaya();
                }
                totalBiaya += biaya;
                if (count > 0) {
                    biayaSudahDibayar = true;
                }
            }
            
            if(!listJa.isEmpty()){
                boolean sudahDibayar = false;
                int countBiaya = 0;
                for(int i = 0; i < listJa.size(); i++){                    
                    Vector tempData = (Vector) listJa.get(i);
                    String jumlahAngsuranStr = String.valueOf(tempData.get(4));
                    double jumlahAngsuran = !jumlahAngsuranStr.equals("") ? Double.parseDouble(jumlahAngsuranStr) : 0;
                    String tglAngsuranStr = String.valueOf(tempData.get(2));
                    Date tglAngsuran = Formater.formatDate(tglAngsuranStr, "yyyy-MM-dd");
                    String keterangan = "";
                    String hilangkan = "";
                    boolean sudahDicetak = false;
                    ArrayList<Long> listJaOid = new ArrayList<>();
                    
                    whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                            + " AND DATE(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") = DATE('" + tglAngsuranStr + "')";
                    Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, whereClause, "");
                                        
                    double jumlahAngsuranDibayar = 0;
                    int jumlahDicetak = 0;
                    for(JadwalAngsuran ja : listJadwal){
                        if(ja.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_BUNGA || ja.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK){
                            keterangan = "Angsuran";
                        } else {
                            keterangan = JadwalAngsuran.getTipeAngsuranRadityaTitle(ja.getJenisAngsuran());
                        }
                        
                        whereClause = PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + ja.getOID();
                        Vector<Angsuran> listTerbayar = PstAngsuran.list(0, 0, whereClause, "");
                        for(Angsuran a : listTerbayar){
                            jumlahAngsuranDibayar += a.getJumlahAngsuran();
                        }
                        
                        listJaOid.add(ja.getOID());
                        jumlahDicetak += ja.getStatusCetak();
                    }
                    
                    sudahDibayar = jumlahAngsuranDibayar >= jumlahAngsuran;
                    sudahDicetak = jumlahDicetak > 0;
                    if(sudahDibayar && sudahDicetak){
                        //hilangkan = transparentStyle;
                    }
                    
                    double saldoAkhir = jumlahPinjaman - jumlahAngsuran;
                    if (sudahDibayar) {
                        html += "<tr>"
                                + "<td style='" + hilangkan + "'>" + Formater.formatDate(tglAngsuran, "dd-MM-yyyy") + "</td>"
                                + "<td style='" + hilangkan + "'>" + formatNumber.format(jumlahPinjaman) + "</td>"
                                + "<td style='" + hilangkan + "'>" + (countBiaya == 0 ? formatNumber.format(totalBiaya) : "-") +"</td>"
                                + "<td style='" + hilangkan + "'>" + formatNumber.format(jumlahAngsuran) + "</td>"
                                + "<td style='" + hilangkan + "'>" + formatNumber.format(saldoAkhir) + "</td>"
                                + "<td style='" + hilangkan + "'>" + keterangan + "</td>"
                                + "<td style='" + hilangkan + "'>&nbsp;</td>"
                                + "</tr>";
                        
                        for(long oid : listJaOid){
                            this.dataAngsuran += "<input type='hidden' name='OID_JADWAL' value='" + oid + "'>";
                        }
                        countBiaya++;
                        
                    } else {
                        html += "<tr>"
                                + "<td style='" + hilangkan + "'>&nbsp;</td>"
                                + "<td style='" + hilangkan + "'>&nbsp;</td>"
                                + "<td style='" + hilangkan + "'>&nbsp;</td>"
                                + "<td style='" + hilangkan + "'>&nbsp;</td>"
                                + "<td style='" + hilangkan + "'>&nbsp;</td>"
                                + "<td style='" + hilangkan + "'>&nbsp;</td>"
                                + "<td style='" + hilangkan + "'>&nbsp;</td>"
                                + "</tr>";
                    }
                    jumlahPinjaman = saldoAkhir;
                }
            }
            html += "</table>";
            
            
        } catch (Exception e) {
            System.out.println("Error di Isi Kartu Angsuran <AjaxJadwalAngsuran> " + e.toString());
            e.printStackTrace();
        }
        return html;
    }
    
    public void getAngsuranDP(HttpServletRequest request) {
        try {
            Pinjaman p = PstPinjaman.fetchExc(this.oid);
            //CEK APAKAH SUDAH ADA TRANSAKSI PEMBAYARAN UNTUK KREDIT INI
            int angsuran = SessKredit.getListAngsuranByPinjaman(p.getOID()).size();
            if (angsuran > 0) {
                this.message = "Terdapat jadwal yang sudah dibayar. Pastikan kredit belum pernah dibayar sebelumnya untuk melakukan pembayaran DP !";
                this.error += 1;
                return;
            }
            
            //CARI JADWAL ANGSURAN POKOK PERTAMA
            String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
            String orderBy = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " ASC ";
            Vector<JadwalAngsuran> jadwalPokokPertama = PstJadwalAngsuran.list(0, 1, whereJadwal, orderBy);
            if (jadwalPokokPertama.isEmpty()) {
                this.message = "Jadwal angsuran DP tidak ditemukan !";
                this.error += 1;
                return;
            }
            
            //format angka jadi 2 digit desimal
            DecimalFormat df = new DecimalFormat("#.##");
            int row = 0;
            double jumlahUang = 0;
            for (JadwalAngsuran ja : jadwalPokokPertama) {
                double dibayar = SessReportKredit.getSumAngsuranDibayar(ja.getOID());
                double newJumlah = Double.valueOf(df.format(ja.getJumlahANgsuran()));
                double newDibayar = Double.valueOf(df.format(dibayar));
                double sisa = newJumlah - newDibayar;
                double sisaDibayar = sisa;
                jumlahUang += sisaDibayar;
                this.htmlReturn += ""
                        + " <tr id='angsuran" + row + "'>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly='' class='form-control input-sm' value='Pembayaran DP'>"
                        + "        <input type='hidden' name='FRM_ANGSURAN_DP' value='1'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' required='' readonly='' class='form-control input-sm jadwal jadwalAngsuran" + row + "' value='" + Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy") + "'>"
                        + "        <input type='hidden' class='jadwalAngsuran idJadwal" + row + "' value='" + ja.getOID() + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JADWAL_ANGSURAN_ID] + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly='' data-cast-class='valTotalAngsuran' class='form-control input-sm money jumlahAngsuran jumlahAngsuran" + row + "' data-row='" + row + "' value='" + newJumlah + "'>"
                        + "        <input type='hidden' class='valTotalAngsuran' id='valTotalAngsuran" + row + "' value='" + newJumlah + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly='' data-cast-class='valSisaAngsuran' class='form-control input-sm money sisaAngsuran' id='sisaAngsuran" + row + "' data-row='" + row + "' value='" + sisa + "'>"
                        + "        <input type='hidden' class='valSisaAngsuran' id='valSisaAngsuran" + row + "' name='FORM_SISA_ANGSURAN' value='" + sisa + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly='' autocomplete='off' required='' data-cast-class='valJumlahDibayar" + row + "' class='form-control input-sm money inputAngsuran' id='inputAngsuran" + row + "' data-row='" + row + "' value='" + sisaDibayar + "'>"
                        + "        <input type='hidden' class='valJumlahDibayar" + row + " valAngsuran' value='" + sisaDibayar + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JUMLAH_ANGSURAN] + "'>"
                        + "    </td>"
                        + "    <td class='text-center' style='width: 1px'>"
                        + "        <button style='color: grey;' disabled type='button' data-row='" + row + "' class='btn btn-sm btn-default btn_remove_angsuran'><i class='fa fa-minus'></i></button>"
                        + "    </td>"
                        + " </tr>"
                        + "";
                row++;
            }
            
            if (this.htmlReturn.equals("")) {
                this.htmlReturn += ""
                        + "<tr>"
                        + "<td colspan='6' class='label-default text-center'>Jadwal angsuran tidak ditemukan</td>"
                        + "</tr>";
            } else {
                try {
                    this.jSONObject.put("RETURN_JUMLAH_UANG", "" + jumlahUang);
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                }
            }
            
        } catch (DBException | NumberFormatException e) {
            printErrorMessage(e.getMessage());
            this.error += 1;
        }
    }
    public void getAngsuranPertama(HttpServletRequest request) {
        try {
            Pinjaman p = PstPinjaman.fetchExc(this.oid);
            //CEK APAKAH SUDAH ADA TRANSAKSI PEMBAYARAN UNTUK KREDIT INI
            int angsuran = SessKredit.getListAngsuranByPinjaman(p.getOID()).size();
            if (angsuran > 0) {
                this.message = "Terdapat jadwal yang sudah dibayar. Pastikan kredit belum pernah dibayar sebelumnya untuk melakukan pembayaran DP !";
                this.error += 1;
                return;
            }
            
            
            
            
            //CARI JADWAL ANGSURAN POKOK PERTAMA
            String orderBy = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN];
            String whereJadwalDP = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT;
            Vector<JadwalAngsuran> jadwalPokokPertama = PstJadwalAngsuran.list(0, 1, whereJadwalDP, orderBy);
            String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID();
//                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT;
            if (jadwalPokokPertama.isEmpty()) {
            jadwalPokokPertama = PstJadwalAngsuran.list(0, 2, whereJadwal, orderBy);
                if (jadwalPokokPertama.isEmpty()) {
                    this.message = "Jadwal angsuran tidak ditemukan !";
                    this.error += 1;
                    return;
                }
            }
            
            //format angka jadi 2 digit desimal
            DecimalFormat df = new DecimalFormat("#.##");
            int row = 0;
            double jumlahUang = 0;
                        //cari data biaya yg belum dibayar
            String whereBiaya = PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = " + p.getOID()
                    + " AND " + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_VALUE_BIAYA] + " > 0 ";
            Vector<BiayaTransaksi> listBiaya = PstBiayaTransaksi.list(0, 0, whereBiaya, "");
            String htmlHidden = "";
            double biaya = 0;
            if(listBiaya != null && listBiaya.size() > 0) {
                for (BiayaTransaksi bt : listBiaya) {
                    if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                        biaya += p.getJumlahPinjaman() * (bt.getValueBiaya() / 100);
                    } else if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                        biaya += bt.getValueBiaya();
                    }
                }
            }
            double totalAngsuran = 0;
            double sisaAngsuran = 0;
            double totalDibayar = 0;
            Date tglAngsuranPertama = null;
            for (JadwalAngsuran ja : jadwalPokokPertama) {
                double dibayar = SessReportKredit.getSumAngsuranDibayar(ja.getOID());
                //                double newJumlah = Double.valueOf(df.format(ja.getJumlahANgsuran() + biaya));
                double newJumlah = Double.valueOf(df.format(ja.getJumlahANgsuran()));
                double newDibayar = Double.valueOf(df.format(dibayar));
                double sisa = newJumlah - newDibayar;
                double sisaDibayar = sisa;
                jumlahUang += sisaDibayar;
                totalAngsuran += newJumlah;
                sisaAngsuran += sisaDibayar;
                totalDibayar += sisaDibayar;
                tglAngsuranPertama = ja.getTanggalAngsuran();
                htmlHidden += ""
                        + " <tr id='angsuran" + row + "' style='display:none;'>"
                        + "    <td class='text-center'>"
                        + "        <input class='jenisAngsuran" + row + "' data-row='" + row + "' type='hidden' value='" + ja.getJenisAngsuran() + "' name='FRM_FIELD_JENIS_ANGSURAN'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='hidden' required='' readonly='' class='form-control input-sm jadwal jadwalAngsuran" + row + "' value='" + Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy") + "'>"
                        + "        <input type='hidden' class='jadwalAngsuran idJadwal" + row + "' value='" + ja.getOID() + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JADWAL_ANGSURAN_ID] + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='hidden' readonly='' data-cast-class='valTotalAngsuran' class='form-control input-sm money jumlahAngsuran jumlahAngsuran" + row + "' data-row='" + row + "' value='" + newJumlah + "'>"
                        + "        <input type='hidden' class='valTotalAngsuran' id='valTotalAngsuran" + row + "' value='" + newJumlah + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='hidden' readonly='' data-cast-class='valSisaAngsuran' class='form-control input-sm money sisaAngsuran' id='sisaAngsuran" + row + "' data-row='" + row + "' value='" + sisa + "'>"
                        + "        <input type='hidden' class='valSisaAngsuran' id='valSisaAngsuran" + row + "' name='FORM_SISA_ANGSURAN' value='" + sisa + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='hidden' readonly='' autocomplete='off' required='' data-cast-class='valDiscPct" + row + "' class='form-control input-sm money inputDicPct' id='inputDicPct" + row + "' data-row='" + row + "' value='0'>"
                        + "        <input type='hidden' class='valDiscPct" + row + "' value='0' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_PCT] + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='hidden' readonly='' autocomplete='off' required='' data-cast-class='valDiscAmount" + row + "' class='form-control input-sm money inputDicAmount' id='inputDicAmount" + row + "' data-row='" + row + "' value='0'>"
                        + "        <input type='hidden' class='valDiscAmount" + row + "' value='0' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_AMOUNT] + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='hidden' readonly='' autocomplete='off' required='' data-cast-class='valJumlahDibayar" + row + "' class='form-control input-sm money inputAngsuran' id='inputAngsuran" + row + "' data-row='" + row + "' value='" + sisaDibayar + "'>"
                        + "        <input type='hidden' class='valJumlahDibayar" + row + " valAngsuran' value='" + sisaDibayar + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JUMLAH_ANGSURAN] + "'>"
                        + "    </td>"
                        + "    <td class='text-center' style='width: 1px'>"
//                        + "        <button style='color: grey;' disabled type='button' data-row='" + row + "' class='btn btn-sm btn-default btn_remove_angsuran'><i class='fa fa-minus'></i></button>"
                        + "        <input type='hidden' name='' value=''>"
                        + "    </td>"
                        + " </tr>"
                        + "";
                if(ja.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT){
                    break;
                }
                row++;
            }
            String htmlShow = ""
                        + " <tr>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' class='form-control input-sm' value='Angsuran Pertama'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly='' class='form-control input-sm' value='" + Formater.formatDate(tglAngsuranPertama, "dd MMM yyyy") + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly='' class='form-control input-sm money' value='" + totalAngsuran + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly=''class='form-control input-sm money' value='" + sisaAngsuran + "'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly='' class='form-control input-sm money' value='0'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly='' class='form-control input-sm money' value='0'>"
                        + "    </td>"
                        + "    <td class='text-center'>"
                        + "        <input type='text' readonly='' class='form-control input-sm money' value='" + totalDibayar + "'>"
                        + "    </td>"
                        + "    <td class='text-center' style='width: 1px'>"
                        + "        <button style='color: grey;' disabled type='button' class='btn btn-sm btn-default'><i class='fa fa-minus'></i></button>"
                        + "    </td>"
                        + " </tr>"
                        + "";

            this.htmlReturn = htmlShow + htmlHidden;
            
            if (this.htmlReturn.equals("")) {
                this.htmlReturn += ""
                        + "<tr>"
                        + "<td colspan='6' class='label-default text-center'>Jadwal angsuran tidak ditemukan</td>"
                        + "</tr>";
            } else {
                try {
                    this.jSONObject.put("RETURN_JUMLAH_UANG", "" + (jumlahUang + biaya));
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                }
            }
            
        } catch (DBException | NumberFormatException e) {
            printErrorMessage(e.getMessage());
            this.error += 1;
        }
    }

    public void getSelectedSchedule(HttpServletRequest request) {
        if (this.oid == 0 || this.oidMulti.length() == 0) {
            this.iErrCode += 1;
            this.message = "Pastikan data jadwal di pilih dengan benar!";
            return;
        }
        int row = FRMQueryString.requestInt(request, "SEND_LAST_ROW");
        //GET JADWAL
        jSONArray = new JSONArray();
        if (this.jenisAng == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA) {
            String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " IN (" + this.oidMulti + ")";
//            Vector getData = PstJadwalAngsuran.list(0, 0, where, "");
//            JadwalAngsuran jad = new JadwalAngsuran();
//            for (int i = 0; i < getData.size(); i++) {
//                jad = (JadwalAngsuran) getData.get(i);
//            }
            Vector<JadwalAngsuran> getData = PstJadwalAngsuran.list(0, 0, where, "");
            for (JadwalAngsuran ja : getData) {
                double totalDibayar = 0;
                double totalAngsuran = 0;
                double totalSisa = 0;
                
                String order = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " DESC ";
                Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.getAngsuranWithBunga(ja.getPinjamanId(), Formater.formatDate(ja.getTanggalAngsuran(), "yyyy-MM-dd"), order);
                ArrayList<String> joinRows = new ArrayList<>();
                for(JadwalAngsuran jad : listAngsuran){
                    double jumlahAngsuran = jad.getJumlahANgsuran();
                    double jumlahDibayar = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jad.getOID() + "'");
                    double sisa = jumlahAngsuran - jumlahDibayar;
                    double sisaDibayar = sisa;
                    totalAngsuran += jumlahAngsuran;
                    totalSisa += sisa;
                    
                    row += 1;

                    if (jad.getJenisAngsuran() != JadwalAngsuran.TIPE_ANGSURAN_BUNGA
                            && jad.getJenisAngsuran() != JadwalAngsuran.TIPE_ANGSURAN_POKOK) {
                        generateListPembayaran(row, jad, sisa, sisaDibayar);
                    } else {
                        totalDibayar += sisaDibayar;
                        generateHiddenListPembayaran(row, jad, sisa, sisaDibayar);
                        joinRows.add(String.valueOf(row));
                    }
                    
                }
                if(totalSisa != 0 && totalDibayar != 0){
                    generateListPembayaranJoin(ja, totalAngsuran, totalSisa, totalDibayar, joinRows, ja.getJenisAngsuran());
                }
            }
            
            //format angka jadi 2 digit desimal
//            DecimalFormat df = new DecimalFormat("#.##");
//            JadwalAngsuran ja = new JadwalAngsuran();
//            for (int i = 0; i < listJadwal.size(); i++) {
//                ja = (JadwalAngsuran) listJadwal.get(i);
////                dibayar = SessReportKredit.getSumAngsuranDibayar(ja.getOID());
//                dibayar = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + ja.getOID() + "'");
//                bungaa = ja.getJumlahANgsuran();
//                newJumlah = Double.valueOf(df.format(bungaa));
//                newDibayar = Double.valueOf(df.format(dibayar));
//                sisa = newJumlah - newDibayar;
//                sisaDibayar = sisa;
//                ja.setJenisAngsuran(this.jenisAng);
//                ja.setJumlahANgsuran(bungaa);
//            }
//            if(!listJadwal.isEmpty()){
//                generateListPembayaranDenganBunga(row, ja, sisa, sisaDibayar);
//            }
            jSONArray.put(row);

        } else {
            String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + this.oid
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " IN (" + this.oidMulti + ")";
            String order = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]
                    + "," + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN];
            Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, where, order);
            double newJumlah = 0;
            double newDibayar = 0;
            double dibayar = 0;
            double sisa = 0;
            double sisaDibayar = 0;
            double totalSisa = 0;
            double totalDibayar = 0;
            double totalAngsuran = 0;

            //format angka jadi 2 digit desimal
            DecimalFormat df = new DecimalFormat("#.##");
            JadwalAngsuran jad = new JadwalAngsuran();
            ArrayList<String> joinRows = new ArrayList<>();
            for (JadwalAngsuran ja : listJadwal) {
                dibayar = SessReportKredit.getSumAngsuranDibayar(ja.getOID());
                newJumlah = Double.valueOf(df.format(ja.getJumlahANgsuran()));
                newDibayar = Double.valueOf(df.format(dibayar));
                sisa = newJumlah - newDibayar;
                sisaDibayar = sisa;
//                generateListPembayaran(row, ja, sisa, sisaDibayar);
                jad = ja;
                totalAngsuran += newJumlah;
                totalSisa += sisa;
                totalDibayar += sisaDibayar;
                generateHiddenListPembayaran(row, ja, sisa, sisaDibayar);
                jSONArray.put(row);
                joinRows.add(String.valueOf(row));
                row += 1;
            }
            if(totalSisa != 0 && totalDibayar != 0){
                generateListPembayaranJoin(jad, totalAngsuran, totalSisa, totalDibayar, joinRows, jad.getJenisAngsuran());
            }
        }
        try {
            this.jSONObject.put("array_row", jSONArray);
        } catch (JSONException ex) {
            printErrorMessage(ex.getMessage());
        }
        if (this.htmlReturn.equals("")) {
            this.htmlReturn += ""
                    + "<tr>"
                    + "<td colspan='6' class='label-default text-center'>Jadwal angsuran tidak ditemukan</td>"
                    + "</tr>";
        }
    }
    
    public void getScheduleBayarLunas(HttpServletRequest request){
        String whereClause = ""
                + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + this.oid + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
        Vector listData = PstJadwalAngsuran.list(0, 0, whereClause , PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
        String inJadwal = "";
        int x = 0;
        for (int i = 0; i < listData.size(); i++) {
            JadwalAngsuran jadwal = (JadwalAngsuran) listData.get(i);
            double totalAngsuran = 0;
            double newJumlah = 0;
            double newTotal = 0;
            int banyakAngsuran = PstAngsuran.getCount("" + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jadwal.getOID() + "'");
            DecimalFormat df = new DecimalFormat("#.##");
            String tglAngsuran = Formater.formatDate(jadwal.getTanggalAngsuran(), "yyyy-MM-dd");
            Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.getAngsuranWithBunga(jadwal.getPinjamanId(), tglAngsuran);
            for (JadwalAngsuran jada : listAngsuran) {
                totalAngsuran = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jada.getOID() + "'");
                newTotal += totalAngsuran;
            }
            double jumlahAngsuran = PstJadwalAngsuran.getJumlahAngsuranWithBunga(jadwal.getPinjamanId(), tglAngsuran);
            newJumlah = jumlahAngsuran;
            
            
            double newTotalAngsuran = Double.valueOf(df.format(totalAngsuran));
            double sisa = newJumlah - newTotalAngsuran;
            newTotalAngsuran = Double.valueOf(df.format(newTotal));
            sisa = newJumlah - newTotalAngsuran;
            if (newTotalAngsuran >= newJumlah && banyakAngsuran > 0) {
                
            } else {
                if (x>0){
                    inJadwal += ",";
                }   
                inJadwal += ""+jadwal.getOID();
                x++;
            }
        }
        int row = 0;
        String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " IN (" + inJadwal + ")";
        Vector<JadwalAngsuran> getData = PstJadwalAngsuran.list(0, 0, where, "");
        int noRow = 0;
        for (JadwalAngsuran ja : getData) {
                double totalDibayar = 0;
                double totalAngsuran = 0;
                double totalSisa = 0;
                noRow++;
                
                String order = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " DESC ";
                Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.getAngsuranWithBunga(ja.getPinjamanId(), Formater.formatDate(ja.getTanggalAngsuran(), "yyyy-MM-dd"), order);
                ArrayList<String> joinRows = new ArrayList<>();
                for(JadwalAngsuran jad : listAngsuran){
                    double jumlahAngsuran = jad.getJumlahANgsuran();
                    double jumlahDibayar = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jad.getOID() + "'");
                    double sisa = jumlahAngsuran - jumlahDibayar;
                    double sisaDibayar = sisa;
                    totalAngsuran += jumlahAngsuran;
                    totalSisa += sisa;
                    
                    row += 1;

                    if (jad.getJenisAngsuran() != JadwalAngsuran.TIPE_ANGSURAN_BUNGA
                            && jad.getJenisAngsuran() != JadwalAngsuran.TIPE_ANGSURAN_POKOK) {
                        generateListPembayaran(row, jad, sisa, sisaDibayar);
                    } else {
                        totalDibayar += sisaDibayar;
                        generateHiddenListPembayaran(row, jad, sisa, sisaDibayar);
                        joinRows.add(String.valueOf(row));
                    }
                    
                }
                if(totalSisa != 0 && totalDibayar != 0){
                    generateListPembayaranDiskonEnable(ja, totalAngsuran, totalSisa, totalDibayar, joinRows, ja.getJenisAngsuran(),noRow);
                }
            }
    }

    public void getPrioritySchedule(HttpServletRequest request) {
        this.htmlReturn = "";

        String[] jumlahUang = request.getParameterValues("FORM_JUMLAH_SETORAN");
        String[] jumlahBiaya = request.getParameterValues("FRM_BIAYA_DIBAYAR");
        
        double uangSetoran = 0;
        if (jumlahUang != null) {
            for (int i = 0; i < jumlahUang.length; i++) {
                if (jumlahUang[i].equals("")) {
                    iErrCode += 1;
                    message = "Pastikan jumlah uang setoran tidak kosong !";
                    return;
                }
                try {
                    uangSetoran += Double.parseDouble(jumlahUang[i]);
                } catch (Exception e) {
                    iErrCode += 1;
                    message = "Pastikan jumlah uang setoran diisi dengan benar !";
                    printErrorMessage(e.getMessage());
                    return;
                }
            }
        }

        double totalBiaya = 0;
        if(jumlahBiaya != null){
            if(jumlahBiaya.length > 0){
                for(String biaya : jumlahBiaya){
                    String cvtBiaya = biaya.replaceAll("[.]", "");
                    totalBiaya += Double.valueOf(cvtBiaya);
                }
            }
        }
        
        uangSetoran = uangSetoran - totalBiaya;
        
        int row = 0;
        //cari jadwal
        String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + this.oid + "'"
                + " GROUP BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN];
        Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, where, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
        for (JadwalAngsuran jadwal : listJadwal) {
            if (uangSetoran <= 0) {
                break;
            }
            Calendar c = Calendar.getInstance();
            c.setTime(jadwal.getTanggalAngsuran());
            String date = Formater.formatDate(c.getTime(), "dd");
            String month = Formater.formatDate(c.getTime(), "MM");
            String year = Formater.formatDate(c.getTime(), "yyyy");

            int tipeAngsuran[] = {
                JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT,
                JadwalAngsuran.TIPE_ANGSURAN_DENDA,
                JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA,
                JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_DINI,
                JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_MACET,
                JadwalAngsuran.TIPE_ANGSURAN_BUNGA_TAMBAHAN
            };
//            int tipeAngsuran[] = {
//                JadwalAngsuran.TIPE_ANGSURAN_DENDA,
//                JadwalAngsuran.TIPE_ANGSURAN_BUNGA,
//                JadwalAngsuran.TIPE_ANGSURAN_POKOK,
//                JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_DINI,
//                JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_MACET,
//                JadwalAngsuran.TIPE_ANGSURAN_BUNGA_TAMBAHAN
//            };

            for (int i : tipeAngsuran) {
                if (uangSetoran <= 0) {
                    break;
                }
                String jenisAngsurans = String.valueOf(i);
                if(i == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA){
                    jenisAngsurans = String.valueOf(JadwalAngsuran.TIPE_ANGSURAN_BUNGA) + ", " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
                }
                String whereJadwal = ""
                        + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + this.oid
                        + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " IN (" + jenisAngsurans + ") "
                        + " AND DATE(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") = '" + jadwal.getTanggalAngsuran() + "'"
                        + "";
                Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.list(0, 0, whereJadwal, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " DESC ");
                //format angka jadi 2 digit desimal
                DecimalFormat df = new DecimalFormat("#.##");
                double totalAngsuran = 0;
                double totalSisa = 0;
                double totalDibayar = 0;
                ArrayList<String> joinRows = new ArrayList<>();
                for (JadwalAngsuran ja : listAngsuran) {
                    double dibayar = SessReportKredit.getSumAngsuranDibayar(ja.getOID());
                    double newJumlah = Double.valueOf(df.format(ja.getJumlahANgsuran()));
                    double newDibayar = Double.valueOf(df.format(dibayar));
                    double sisa = newJumlah - newDibayar;
                    double sisaDibayar = sisa;
                    int tempRow = 0;
                    totalAngsuran += newJumlah;
                    totalSisa += sisa;
                    if (sisa <= 0) {
                        continue;
                    }
                    if (uangSetoran < sisa) {
                        sisaDibayar = uangSetoran;
                    }
                    row += 1;
                    tempRow = row;
//                    if(ja.getJenisAngsuran() != JadwalAngsuran.TIPE_ANGSURAN_BUNGA && ja.getJenisAngsuran() != JadwalAngsuran.TIPE_ANGSURAN_POKOK){
//                        generateListPembayaran(row, ja, sisa, sisaDibayar);
//                    } else {
                        totalDibayar += sisaDibayar;
                        generateHiddenListPembayaran(row, ja, sisa, sisaDibayar);
                        joinRows.add(String.valueOf(tempRow));
//                    }
                    if (uangSetoran <= 0) {
                        break;
                    }
                    uangSetoran -= sisaDibayar;
                }
//                if(i == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA){
                    if(totalSisa != 0 && totalDibayar != 0){
                        generateListPembayaranJoin(jadwal, totalAngsuran, totalSisa, totalDibayar, joinRows, i);
                    }
//                }
            }
        }

        if (this.htmlReturn.equals("")) {
            this.htmlReturn += ""
                    + "<tr>"
                    + "<td colspan='6' class='label-default text-center'>Jadwal angsuran tidak ditemukan</td>"
                    + "</tr>";
        }
    }

    public void generateListPembayaran(int row, JadwalAngsuran ja, double sisa, double sisaDibayar) {
        //format angka jadi 2 digit desimal
        DecimalFormat df = new DecimalFormat("#.##");
        double newJumlah = Double.valueOf(df.format(ja.getJumlahANgsuran()));
        
        this.lastRow = row;
        this.htmlReturn += ""
                + " <tr id='angsuran" + row + "'>"
                + "    <td class='text-center'>"
                + "        <select class='form-control input-sm jenisAngsuran" + row + "' data-row='" + row + "' name='FRM_FIELD_JENIS_ANGSURAN'>"
                + "            <option value='" + ja.getJenisAngsuran() + "'>" + JadwalAngsuran.getTipeAngsuranTitle(ja.getJenisAngsuran()) + "</option>"
                + "        </select>"
                + "    </td>"
                + "    <td class='text-center'>"
//                + "        <div class='input-group'>"
                + "            <input type='text' required='' readonly='' class='form-control input-sm jadwal jadwalAngsuran" + row + "' value='" + Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy") + "'>"
                + "            <input type='hidden' class='jadwalAngsuran idJadwal" + row + "' value='" + ja.getOID() + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JADWAL_ANGSURAN_ID] + "'>"
//                + "            <span class='input-group-addon btn btn-primary btn-searchschedule' data-row='" + row + "'><i class='fa fa-search'></i></span>"
//                + "        </div>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' data-cast-class='valTotalAngsuran' class='form-control input-sm money jumlahAngsuran jumlahAngsuran" + row + "' data-row='" + row + "' value='" + newJumlah + "'>"
                + "        <input type='hidden' class='valTotalAngsuran' id='valTotalAngsuran" + row + "' value='" + newJumlah + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' data-cast-class='valSisaAngsuran' class='form-control input-sm money sisaAngsuran' id='sisaAngsuran" + row + "' data-row='" + row + "' value='" + sisa + "'>"
                + "        <input type='hidden' class='valSisaAngsuran' id='valSisaAngsuran" + row + "' name='FORM_SISA_ANGSURAN' value='" + sisa + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' autocomplete='off' required='' data-cast-class='valDiscPct" + row + "' class='form-control input-sm money inputDicPct' id='inputDicPct" + row + "' data-row='" + row + "' value='0'>"
                + "        <input type='hidden' class='valDiscPct" + row + "' value='0' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_PCT] + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' autocomplete='off' required='' data-cast-class='valDiscAmount" + row + "' class='form-control input-sm money inputDicAmount' id='inputDicAmount" + row + "' data-row='" + row + "' value='0'>"
                + "        <input type='hidden' class='valDiscAmount" + row + "' value='0' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_AMOUNT] + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' autocomplete='off' required='' data-cast-class='valJumlahDibayar" + row + "' class='form-control input-sm money inputAngsuran' id='inputAngsuran" + row + "' data-row='" + row + "' value='" + sisaDibayar + "'>"
                + "        <input type='hidden' class='valJumlahDibayar" + row + " valAngsuran' value='" + sisaDibayar + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JUMLAH_ANGSURAN] + "'"
                + "          data-rows='" + row + "' value='" + sisaDibayar + "' data-batasbayar='" + sisa + "' data-total='" + sisaDibayar + "'>"
                + "    </td>"
                + "    <td class='text-center' style='width: 1px'>"
                + "        <button style='color: #dd4b39;' type='button' data-row='" + row + "' class='btn btn-sm btn-default btn_remove_angsuran'><i class='fa fa-minus'></i></button>"
                + "    </td>"
                + " </tr>"
                + "";
    }
    public void generateHiddenListPembayaran(int row, JadwalAngsuran ja, double sisa, double sisaDibayar) {
        //format angka jadi 2 digit desimal
        DecimalFormat df = new DecimalFormat("#.##");
        double newJumlah = Double.valueOf(df.format(ja.getJumlahANgsuran()));
        this.lastRow = row;
        this.htmlReturn += ""
                + " <tr id='angsuran" + row + "' style='display: none;'>"
                + "    <td class='text-center'>"
                + "        <input class='jenisAngsuran" + row + "' data-row='" + row + "' type='hidden' value='" + ja.getJenisAngsuran() + "' name='FRM_FIELD_JENIS_ANGSURAN'>"
//                + "        <select class='form-control input-sm jenisAngsuran" + row + "' data-row='" + row + "' name='FRM_FIELD_JENIS_ANGSURAN'>"
//                + "            <option value='" + ja.getJenisAngsuran() + "'>" + JadwalAngsuran.getTipeAngsuranTitle(ja.getJenisAngsuran()) + "</option>"
//                + "        </select>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <div class='input-group'>"
                + "            <input type='hidden' required='' readonly='' class='form-control input-sm jadwal jadwalAngsuran" + row + "' value='" + Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy") + "'>"
                + "            <input type='hidden' class='jadwalAngsuran idJadwal" + row + "' value='" + ja.getOID() + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JADWAL_ANGSURAN_ID] + "'>"
                + "            <span class='input-group-addon btn btn-primary btn-searchschedule' data-row='" + row + "'><i class='fa fa-search'></i></span>"
                + "        </div>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='hidden' readonly='' data-cast-class='valTotalAngsuran' class='form-control input-sm jumlahAngsuran jumlahAngsuran" + row + "' data-row='" + row + "' value='" + newJumlah + "'>"
                + "        <input type='hidden' class='valTotalAngsuran' id='valTotalAngsuran" + row + "' value='" + newJumlah + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='hidden' readonly='' data-cast-class='valSisaAngsuran' class='form-control input-sm sisaAngsuran' id='sisaAngsuran" + row + "' data-row='" + row + "' value='" + sisa + "'>"
                + "        <input type='hidden' class='valSisaAngsuran' id='valSisaAngsuran" + row + "' name='FORM_SISA_ANGSURAN' value='" + sisa + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' autocomplete='off' required='' data-cast-class='valDiscPct" + row + "' class='form-control input-sm money inputDicPct' id='inputDicPct" + row + "' data-row='" + row + "' value='0'>"
                + "        <input type='hidden' class='valDiscPct" + row + "' value='0' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_PCT] + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' autocomplete='off' required='' data-cast-class='valDiscAmount" + row + "' class='form-control input-sm money inputDicAmount' id='inputDicAmount" + row + "' data-row='" + row + "' value='0'>"
                + "        <input type='hidden' class='valDiscAmount" + row + "' value='0' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_AMOUNT] + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='hidden' autocomplete='off' required='' data-cast-class='valJumlahDibayar" + row + "' class='form-control input-sm inputAngsuran' id='inputAngsuran" + row + "' data-row='" + row + "' value='" + sisaDibayar + "' data-batasbayar='" + ja.getJumlahANgsuran() + "'>"
                + "        <input type='hidden' class='valJumlahDibayar" + row + " valAngsuran' value='" + sisaDibayar + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JUMLAH_ANGSURAN] + "'>"
                + "    </td>"
                + "    <td class='text-center' style='width: 1px'>"
                + "        <input type='hidden' value='' name=''>" 
//                + "        <button style='color: #dd4b39;' type='button' data-row='" + row + "' class='btn btn-sm btn-default btn_remove_angsuran'><i class='fa fa-minus'></i></button>"
                + "    </td>"
                + " </tr>"
                + "";
    }
    public void generateListPembayaranJoin(JadwalAngsuran ja, double angsuran, double sisa, double sisaDibayar, ArrayList<String> rows, int jenisAngsuran) {
        //format angka jadi 2 digit desimal
        DecimalFormat df = new DecimalFormat("#.##");
        JSONArray rowArray = new JSONArray();
        JSONObject rowObject = new JSONObject();
        if(jenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_BUNGA || jenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_POKOK){
            jenisAngsuran = JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA;
        }
        for(String i : rows){
            rowArray.put(i);
        }
        try {
            rowObject.put("ROW", rowArray);
        } catch (Exception e) {
            System.out.println("Generate list pembayaran join : " + e.getMessage());
        }
        this.htmlReturn += ""
                + " <tr>"
                + "    <td class='text-center'>"
                + "        <select class='form-control input-sm'>"
                + "            <option>" + JadwalAngsuran.getTipeAngsuranRadityaTitle(jenisAngsuran) + "</option>"
                + "        </select>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' required='' readonly='' class='form-control input-sm' value='" + Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy") + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' class='form-control input-sm money ' value='" + angsuran + "' data-total='" + angsuran + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' class='form-control input-sm money' value='" + sisa + "' data-total='" + sisa + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' class='form-control input-sm money inputDiscPct'"
                + "          data-rows='" + rowObject.toString() + "' value='0' data-batasbayar='0' data-total='0'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' class='form-control input-sm money inputDiscAmount'"
                + "          data-rows='" + rowObject.toString() + "' value='0' data-batasbayar='0' data-total='0'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' required='' class='form-control input-sm money inputJumlahBayar'"
                + "          data-rows='" + rowObject.toString() + "' value='" + sisaDibayar + "' data-batasbayar='" + sisa + "' data-total='" + sisaDibayar + "'>"
                + "    </td>"
                + "    <td class='text-center' style='width: 1px'>"
                + "        <button style='color: #dd4b39;' type='button' data-rows='" + rowObject.toString() + "'"
                + "          disabled='' class='btn btn-sm btn-default btn_remove_angsuran'><i class='fa fa-minus'></i></button>"
                + "    </td>"
                + " </tr>"
                + "";
    }
    public void generateListPembayaranDiskonEnable(JadwalAngsuran ja, double angsuran, double sisa, double sisaDibayar, ArrayList<String> rows, int jenisAngsuran, int row) {
        //format angka jadi 2 digit desimal
        DecimalFormat df = new DecimalFormat("#.##");
        JSONArray rowArray = new JSONArray();
        JSONObject rowObject = new JSONObject();
        if(jenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_BUNGA || jenisAngsuran == JadwalAngsuran.TIPE_ANGSURAN_POKOK){
            jenisAngsuran = JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA;
        }
        for(String i : rows){
            rowArray.put(i);
        }
        try {
            rowObject.put("ROW", rowArray);
        } catch (Exception e) {
            System.out.println("Generate list pembayaran join : " + e.getMessage());
        }
        this.htmlReturn += ""
                + " <tr>"
                + "    <td class='text-center'>"
                + "        <select class='form-control input-sm'>"
                + "            <option>" + JadwalAngsuran.getTipeAngsuranRadityaTitle(jenisAngsuran) + "</option>"
                + "        </select>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' required='' readonly='' class='form-control input-sm' value='" + Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy") + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' class='form-control input-sm money ' value='" + angsuran + "' data-total='" + angsuran + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' class='form-control input-sm money' id='sisaAngs"+row+"' value='" + sisa + "' data-total='" + sisa + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' class='form-control input-sm money inputPctDisc' id='discPct"+row+"'"
                + "          data-rows='" + rowObject.toString() + "' data-row='"+row+"' value='0' data-batasbayar='0' data-total='0'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' class='form-control input-sm money inputAmountDisc' id='discAmount"+row+"'"
                + "          data-rows='" + rowObject.toString() + "' data-row='"+row+"' value='0' data-batasbayar='0' data-total='0'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' required='' class='form-control input-sm money' id='jumlahBayar"+row+"'"
                + "          data-rows='" + rowObject.toString() + "' data-row='"+row+"' value='" + sisaDibayar + "' data-batasbayar='" + sisa + "' data-total='" + sisaDibayar + "'>"
                + "    </td>"
                + "    <td class='text-center' style='width: 1px'>"
                + "        <button style='color: #dd4b39;' type='button' data-rows='" + rowObject.toString() + "'"
                + "          disabled='' class='btn btn-sm btn-default btn_remove_angsuran'><i class='fa fa-minus'></i></button>"
                + "    </td>"
                + " </tr>"
                + "";
    }
    public void generateListPembayaranDenganBunga(int row, JadwalAngsuran ja, double sisa, double sisaDibayar) {
        //format angka jadi 2 digit desimal
        DecimalFormat df = new DecimalFormat("#.##");
        double newJumlah = Double.valueOf(df.format(ja.getJumlahANgsuran()));
        
        this.lastRow = row;
        this.htmlReturn += ""
                + " <tr id='angsuran" + row + "'>"
                + "    <td class='text-center'>"
                + "        <select class='form-control input-sm jenisAngsuran" + row + "' data-row='" + row + "' name='FRM_FIELD_JENIS_ANGSURAN'>"
                + "            <option value='" + JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA + "'>" + JadwalAngsuran.getTipeAngsuranRadityaTitle(JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA) + "</option>"
                + "        </select>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <div class='input-group'>"
                + "            <input type='text' required='' readonly='' class='form-control input-sm jadwal jadwalAngsuran" + row + "' value='" + Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy") + "'>"
                + "            <input type='hidden' class='jadwalAngsuran idJadwal" + row + "' value='" + ja.getOID() + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JADWAL_ANGSURAN_ID] + "'>"
                + "            <span class='input-group-addon btn btn-primary btn-searchschedule' data-row='" + row + "'><i class='fa fa-search'></i></span>"
                + "        </div>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' data-cast-class='valTotalAngsuran' class='form-control input-sm money jumlahAngsuran jumlahAngsuran" + row + "' data-row='" + row + "' value='" + newJumlah + "'>"
                + "        <input type='hidden' class='valTotalAngsuran' id='valTotalAngsuran" + row + "' value='" + newJumlah + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' data-cast-class='valSisaAngsuran' class='form-control input-sm money sisaAngsuran' id='sisaAngsuran" + row + "' data-row='" + row + "' value='" + sisa + "'>"
                + "        <input type='hidden' class='valSisaAngsuran' id='valSisaAngsuran" + row + "' name='FORM_SISA_ANGSURAN' value='" + sisa + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' autocomplete='off' required='' data-cast-class='valDiscPct" + row + "' class='form-control input-sm money inputDicPct' id='inputDicPct" + row + "' data-row='" + row + "' value='0'>"
                + "        <input type='hidden' class='valDiscPct" + row + "' value='0' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_PCT] + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' readonly='' autocomplete='off' required='' data-cast-class='valDiscAmount" + row + "' class='form-control input-sm money inputDicAmount' id='inputDicAmount" + row + "' data-row='" + row + "' value='0'>"
                + "        <input type='hidden' class='valDiscAmount" + row + "' value='0' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_AMOUNT] + "'>"
                + "    </td>"
                + "    <td class='text-center'>"
                + "        <input type='text' autocomplete='off' required='' data-cast-class='valJumlahDibayar" + row + "' class='form-control input-sm money inputAngsuran' id='inputAngsuran" + row + "' data-row='" + row + "' value='" + sisaDibayar + "'>"
                + "        <input type='hidden' class='valJumlahDibayar" + row + " valAngsuran' value='" + sisaDibayar + "' name='" + FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JUMLAH_ANGSURAN] + "'>"
                + "    </td>"
                + "    <td class='text-center' style='width: 1px'>"
                + "        <button style='color: #dd4b39;' type='button' data-row='" + row + "' class='btn btn-sm btn-default btn_remove_angsuran'><i class='fa fa-minus'></i></button>"
                + "    </td>"
                + " </tr>"
                + "";
    }

    public void getSchedule(HttpServletRequest request) {
        this.htmlReturn = "";
        Vector<JadwalAngsuran> listPokok = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + this.oid + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + "'", "");
        Vector<JadwalAngsuran> listBunga = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + this.oid + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + "'", "");
        double totalPokok = 0;
        double totalBunga = 0;
        for (int i = 0; i < listPokok.size(); i++) {
            htmlReturn += ""
                    + "<tr>"
                    + "<td>" + (i + 1) + ".</td>"
                    + "<td>" + listPokok.get(i).getTanggalAngsuran() + "</td>"
                    + "";
            if (listPokok.get(i).getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK) {
                totalPokok += listPokok.get(i).getJumlahANgsuran();
                htmlReturn += ""
                        + "<td style='text-align: right' class='money'>" + listPokok.get(i).getJumlahANgsuran() + "</td>"
                        + "";
            }
            if (listBunga.get(i).getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_BUNGA) {
                totalBunga += listBunga.get(i).getJumlahANgsuran();
                htmlReturn += ""
                        + "<td style='text-align: right' class='money'>" + listBunga.get(i).getJumlahANgsuran() + "</td>"
                        + "";
            }
            htmlReturn += ""
                    + "<td style='text-align: right' class='money'>" + (listPokok.get(i).getJumlahANgsuran() + listBunga.get(i).getJumlahANgsuran()) + "</td>"
                    + "</tr>";
        }
        htmlReturn += ""
                + "<tr>"
                + "<th></th>"
                + "<th style='text-align: right'>TOTAL &nbsp;&nbsp;&nbsp;:</th>"
                + "<th style='text-align: right' class='money'>" + totalPokok + "</th>"
                + "<th style='text-align: right' class='money'>" + totalBunga + "</th>"
                + "<th style='text-align: right' class='money'>" + (totalPokok + totalBunga) + "</th>"
                + "</tr>"
                + "";
    }

    public void getDataAngsuran(HttpServletRequest request) {
        message = "";
        DecimalFormat df = new DecimalFormat("#.##");
        JadwalAngsuran jadwal = new JadwalAngsuran();
        try {
            jadwal = PstJadwalAngsuran.fetchExc(oid);
            String jenisAngsuranWhere = "";
            if(jenisAng == JadwalAngsuran.TIPE_ANGSURAN_DENGAN_BUNGA){
                jenisAngsuranWhere = JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ", " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
            } else {
                jenisAngsuranWhere = "" + jenisAng;
            }
            
            String where = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + jadwal.getPinjamanId()
                    + " AND DATE(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")"
                    + " = DATE('" + Formater.formatDate(jadwal.getTanggalAngsuran(), "yyyy-MM-dd") + "')"
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] 
                    + " IN (" + jenisAngsuranWhere + ")";
            String order = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " DESC ";
            Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, where, order);
            
            int row = FRMQueryString.requestInt(request, "SEND_LAST_ROW");
            double jumlahAngsuran = 0;
            double jumlahDibayar = 0;
            double dibayar = 0;
            double sisa = 0;
            double sisaDibayar = 0;
            double totalSisa = 0;
            double totalDibayar = 0;
            double totalAngsuran = 0;
            
            JadwalAngsuran jad = new JadwalAngsuran();
            ArrayList<String> joinRows = new ArrayList<>();
            for(JadwalAngsuran ja : listJadwal){
                dibayar = SessReportKredit.getSumAngsuranDibayar(ja.getOID());
                jumlahAngsuran = Double.valueOf(df.format(ja.getJumlahANgsuran()));
                jumlahDibayar = Double.valueOf(df.format(dibayar));
                    sisa = jumlahAngsuran - jumlahDibayar;
                sisaDibayar = sisa;
                jad = ja;
                totalAngsuran += jumlahAngsuran;
                totalSisa += sisa;
                totalDibayar += sisaDibayar;
                generateHiddenListPembayaran(row, ja, sisa, sisaDibayar);
                jSONArray.put(row);
                joinRows.add(String.valueOf(row));
                row += 1;
            }
            if (totalSisa != 0 && totalDibayar != 0) {
                generateListPembayaranJoin(jad, totalAngsuran, totalSisa, totalDibayar, joinRows, jad.getJenisAngsuran());
            }
            
            try {
                this.jSONObject.put("array_row", jSONArray);
            } catch (JSONException ex) {
                printErrorMessage(ex.getMessage());
            }
            
            if (this.htmlReturn.equals("")) {
                this.htmlReturn += ""
                        + "<tr>"
                        + "<td colspan='6' class='label-default text-center'>Jadwal angsuran tidak ditemukan</td>"
                        + "</tr>";
            }
            /*
            double total = Math.ceil(totalSisa);
            long longTotal = (long) (total);
            ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
            String con = convert.getText() + " rupiah.";
            String output = con.substring(0, 1).toUpperCase() + con.substring(1);
            
            JSONObject jo = new JSONObject();
            jo.put("tgl_angsuran", "" + Formater.formatDate(jadwal.getTanggalAngsuran(), "dd MMM yyyy"));
            jo.put("jumlah_angsuran", "" + jumlahAngsuran);
            jo.put("jumlah_terbilang", output);
            jSONArrayJadwalAngsuran.put(jo);
            */
        } catch (Exception e) {
            message = e.toString();
            printErrorMessage(e.getMessage());
        }
    }
    
    public int convertInteger(int scale, double val) {
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(scale, RoundingMode.UP);
        return bDecimal.intValue();
    }
    
    public Map<String, String> getScheduleDetail(JadwalAngsuran jadwal, int jenisAngsuran) {
        
        String sNow = Formater.formatDate(new Date(), "yyyy-MM-dd");
        Date dateNow = Formater.formatDate(sNow, "yyyy-MM-dd");
                
        double jumlahAngsuran = 0;
        double jumlahDibayar = 0;
        double sisaAngsuran = 0;
        String keteranganLunas = "";
        String keteranganTerlambat = "";
        
        String statusBelumDibayar   = "<i data-toggle='tooltip' data-placement='top' title='Belum dibayar' class='fa fa-info-circle' style='color: lightgrey'></i>";
        String statusBelumLunas     = "<i data-toggle='tooltip' data-placement='top' title='Belum lunas' class='fa fa-info-circle' style='color: darkorange'></i>";
        String statusLunas          = "<i data-toggle='tooltip' data-placement='top' title='Lunas' class='fa fa-check-circle' style='color: green'></i>";
        String statusBelumTerlambat = "<i data-toggle='tooltip' data-placement='top' title='Belum terlambat' class='fa fa-info-circle' style='color: lightgrey'></i>";
        String statusTidakTerlambat = "<i data-toggle='tooltip' data-placement='top' title='Tidak terlambat' class='fa fa-check-circle' style='color: green'></i>";
        String statusTerlambat      = "<i data-toggle='tooltip' data-placement='top' title='Terlambat' class='fa fa-exclamation-circle text-red' style='color: red'></i>";
        
        String whereJadwal = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + jadwal.getPinjamanId() + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "'"
                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + jadwal.getTanggalAngsuran() + "'";
        Vector listJadwal = PstJadwalAngsuran.list(0, 0, whereJadwal, "");
        if (!listJadwal.isEmpty()) {
            jumlahAngsuran = SessReportKredit.getTotalAngsuranPerJadwal(jadwal.getPinjamanId(), jenisAngsuran, jadwal.getTanggalAngsuran().toString());
            
            //CEK APAKAH ADA PEMBAYARAN POKOK
            int frekuensiBayar = SessReportKredit.getCountAngsuranDibayarPerJadwal(jadwal.getPinjamanId(), jenisAngsuran, jadwal.getTanggalAngsuran().toString());
            if (frekuensiBayar > 0) {
                jumlahDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(jadwal.getPinjamanId(), jenisAngsuran, jadwal.getTanggalAngsuran().toString());
                
                //CEK APAKAH ANGSURAN POKOK SUDAH LUNAS
                DecimalFormat df = new DecimalFormat("#.##");
                jumlahAngsuran = Double.valueOf(df.format(jumlahAngsuran));
                jumlahDibayar = Double.valueOf(df.format(jumlahDibayar));
                sisaAngsuran = jumlahAngsuran - jumlahDibayar;
                if (jumlahDibayar >= jumlahAngsuran) {
                    keteranganLunas = statusLunas;
                    //CEK APAKAH ADA PEMBAYARAN YG TERLAMBAT
                    int bayarTerlambat = SessReportKredit.getCountAngsuranDibayarTerlambatPerJadwal(jadwal.getPinjamanId(), jenisAngsuran, jadwal.getTanggalAngsuran().toString());
                    if (bayarTerlambat > 0) {
                        keteranganTerlambat = statusTerlambat;
                    } else {
                        keteranganTerlambat = statusTidakTerlambat;
                    }
                } else {
                    keteranganLunas = statusBelumLunas;
                    if (jadwal.getTanggalAngsuran().before(dateNow)) {
                        keteranganTerlambat = statusTerlambat;
                    } else {
                        keteranganTerlambat = statusBelumTerlambat;
                    }
                }
                
            } else {
                keteranganLunas = statusBelumDibayar;
                //CEK APAKAH ANGSURAN SUDAH LEWAT JATUH TEMPO
                if (jadwal.getTanggalAngsuran().before(dateNow)) {
                    keteranganTerlambat = statusTerlambat;
                } else {
                    keteranganTerlambat = statusBelumTerlambat;
                }
            }
        }
        
        Map<String, String> mapAngsuran = new HashMap();
        mapAngsuran.put("JUMLAH_ANGSURAN", "" + jumlahAngsuran);
        mapAngsuran.put("JUMLAH_DIBAYAR", "" + jumlahDibayar);
        mapAngsuran.put("SISA_ANGSURAN", "" + sisaAngsuran);
        mapAngsuran.put("STATUS_LUNAS", keteranganLunas);
        mapAngsuran.put("STATUS_TERLAMBAT", keteranganTerlambat);
        return mapAngsuran;
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
