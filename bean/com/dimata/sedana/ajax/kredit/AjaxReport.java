/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.kredit;

import com.dimata.aiso.entity.admin.AppUser;
import com.dimata.aiso.entity.admin.PstAppUser;
import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.pos.entity.billing.BillMain;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.posbo.entity.masterdata.Material;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.kredit.Angsuran;
import com.dimata.sedana.entity.kredit.AngsuranPayment;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstAngsuran;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.kredit.ReturnKredit;
import com.dimata.sedana.entity.kredit.ReturnKreditItem;
import com.dimata.sedana.entity.report.ReportKredit;
import com.dimata.sedana.entity.tabungan.DetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.sedana.session.SessKredit;
import com.dimata.sedana.session.SessReportKredit;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author gndiw
 */
public class AjaxReport extends HttpServlet {

    private long userId = 0;
    private String userName = "";
    
    private JSONObject jSONObject = new JSONObject();
    private JSONArray jSONArray = new JSONArray();
    
    private String dataFor = "";
    private String htmlReturn = "";
    
    AppUser au = new AppUser();
    
    final String pattern = "###,###.##";
    DecimalFormat decimalFormat = new DecimalFormat(pattern);
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
        this.userName = FRMQueryString.requestString(request, "SEND_USER_NAME");
        try {
            au = PstAppUser.fetch(this.userId);
        } catch (Exception e) {
        }
        
        if (this.dataFor.equals("reportTransaksi")){
            reportTransaksi(request);
        } else if (this.dataFor.equals("reportPengembalianBarang")){
            reportPengembalian(request);
        } else if (this.dataFor.equals("reportPenjualanKredit")){
            getReportPenjualanKredit(request);
        } else if (this.dataFor.equals("reportSisaPinjaman")){
            getSisaKredit(request);
        } else if (this.dataFor.equals("reportPenghapusanKredit")){
            reportPenghapusan(request);
        }
        
        try {
            this.jSONObject.put("FRM_FIELD_HTML", this.htmlReturn);

        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }
        
        response.getWriter().print(this.jSONObject);
        
    }
    
    
    private void reportPengembalian(HttpServletRequest request){
        String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
        String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
        int jenisTransaksi = FRMQueryString.requestInt(request, "FRM_TRANSAKSI");
        String[] lokasi = request.getParameterValues("FORM_LOKASI");
        String[] status = request.getParameterValues("form_status");
        String addSql = "";
        if (!tglAwal.equals("") && !tglAkhir.equals("")) {
            addSql += " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + tglAwal + "'"
                    + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + tglAkhir + "'";
        }
        String inLokasi = "";
        if (lokasi != null){
            for (int i = 0; i < lokasi.length; i++){
                if (inLokasi.length()>0){
                    inLokasi += ","+lokasi[i];
                } else {
                    inLokasi += lokasi[i];
                }
            }
        }

        String cabang = "Semua Cabang";
        if (inLokasi.length()>0){
            cabang = "";
            Vector listLokasi = PstLocation.list(0, 0, PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]+" IN ("+inLokasi+")", "");
            for (int i=0; i < listLokasi.size();i++){
                Location loc = (Location) listLokasi.get(i);
                if (i>0){
                    cabang += ",";
                }
                cabang += loc.getName();
            }
        }

        String jenis = "Semua Jenis";
        switch (jenisTransaksi){
            case 0 : jenis = "Return";
                break;
            case 1 : jenis = "Pengembalian";
                break;
        }
        
        String inStatus = "";
        if (status != null){
            for (int i = 0; i < status.length; i++){
                if (inStatus.length()>0){
                    inStatus += ","+status[i];
                } else {
                    inStatus += status[i];
                }
            }
        }

        Vector records = SessReportKredit.listReportPengembalianBarang(tglAwal, tglAkhir, jenisTransaksi, inLokasi, au.getOID(), au.getAssignLocationId(), inStatus);
        
        this.htmlReturn = "<table id='report' style='border-collapse:collapse'>"
                + "<tr>"
                    + "<td style='text-align: left;white-space: nowrap;width: 50px; display: inline-block'>Laporan Barang Kembali</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Tanggal : "+tglAwal+" - "+tglAkhir+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Cabang : "+cabang+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Jenis Transaksi : "+jenis+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: center;padding:5px; font-size: large'>&nbsp;</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;width: 50px; display: inline-block'>No</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>CABANG</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>JENIS</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>NO. PK</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>NAMA KONSUMEN</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>ALAMAT</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>NAMA BARANG</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>TOTAL KREDIT</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>ANALIS</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>ANGSURAN</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>SUDAH DIBAYAR</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>SALDO</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>SISA HPP</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>NAMA BARANG BARU</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>HPP BARU</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>KET</td>"
                + "</tr>";
        double total = 0;
        long currP = 0;
        int no = 0;
        for (int i = 0; i <= records.size() - 1; i++) {
            Vector temp = (Vector) records.get(i);
            ReturnKreditItem retItem = (ReturnKreditItem) temp.get(0);
            ReturnKredit retKredit = (ReturnKredit) temp.get(1);
            Pinjaman p = (Pinjaman) temp.get(2);
            Anggota ang = (Anggota) temp.get(3);
            Material mat = (Material) temp.get(4);
            Employee emp = (Employee) temp.get(5);
            Location loc = (Location) temp.get(6);
            Integer cnt = (Integer) temp.get(7);
            Double hpp = (Double) temp.get(8);

            Date dateNow = new Date();
            String dateCheck = Formater.formatDate(dateNow, "yyyy-MM-dd");
            Date tglAwalTunggakanPokok = SessKredit.getTunggakanKredit(p.getOID(), dateCheck, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
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


            double angsuranBelumDibayar = 0;
            double sisaTunggakan = 0;
            int angsDp = 0;
            double DP = 0;
            String whereDp = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
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

            String whereAdd = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
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

            double nilaiHppPerbulan = retItem.getNilaiHpp()/ (double) (p.getJangkaWaktu() + angsDp);
            double nilaiPersediaan = 0;
            if (retKredit.getJenisReturn() == ReturnKredit.JENIS_RETURN_CABUTAN){
                nilaiPersediaan = angsuranBelumDibayar * nilaiHppPerbulan;
            } else {
                nilaiPersediaan = retItem.getNilaiHpp();
            }

            if (currP != p.getOID()){
                currP = p.getOID();
                no++;
                this.htmlReturn += "<tr>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle; width: 50px; display: inline-block' rowspan='"+cnt+"'>"+(no)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+loc.getName()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+(retKredit.getJenisReturn() == 0 ? "Return" : "Pengembalian")+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+p.getNoKredit()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+ang.getName()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+ang.getAddressPermanent()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+ mat.getName()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"' class=\"uang\">"+(p.getJumlahPinjaman()+p.getDownPayment())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+emp.getFullName()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+String.format("%,.2f", (p.getJangkaWaktu() - angsuranBelumDibayar))+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"' class=\"uang\">"+((p.getJumlahPinjaman()+p.getDownPayment()) - sisaTunggakan)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"' class=\"uang\">"+sisaTunggakan+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class=\"uang\">"+nilaiPersediaan+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+(retItem.getNewMaterialName().length()>0 ? retItem.getNewMaterialName() : mat.getName())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class=\"uang\">"+retItem.getNilaiPersediaan()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+retKredit.getCatatan()+"</td>"
                    + "</tr>";
            } else {
                this.htmlReturn += "<tr>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+ mat.getName()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class=\"uang\">"+nilaiPersediaan+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+(retItem.getNewMaterialName().length()>0 ? retItem.getNewMaterialName() : mat.getName())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class=\"uang\">"+retItem.getNilaiPersediaan()+"</td>"
                    + "</tr>";
            }
            
            
            
        }
        this.htmlReturn += "</table>";
        
    }
    
    private void reportPenghapusan(HttpServletRequest request){
        String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
        String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
        String[] lokasi = request.getParameterValues("FORM_LOKASI");
        String[] status = request.getParameterValues("form_status");
        
        String inLokasi = "";
        if (lokasi != null){
            for (int i = 0; i < lokasi.length; i++){
                if (inLokasi.length()>0){
                    inLokasi += ","+lokasi[i];
                } else {
                    inLokasi += lokasi[i];
                }
            }
        }

        String cabang = "Semua Cabang";
        if (inLokasi.length()>0){
            cabang = "";
            Vector listLokasi = PstLocation.list(0, 0, PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]+" IN ("+inLokasi+")", "");
            for (int i=0; i < listLokasi.size();i++){
                Location loc = (Location) listLokasi.get(i);
                if (i>0){
                    cabang += ",";
                }
                cabang += loc.getName();
            }
        }
        
        String inStatus = "";
        if (status != null){
            for (int i = 0; i < status.length; i++){
                if (inStatus.length()>0){
                    inStatus += ","+status[i];
                } else {
                    inStatus += status[i];
                }
            }
        }

        Vector records = SessReportKredit.listReportPenghapusanKredit(tglAwal, tglAkhir, inLokasi, au.getOID(), au.getAssignLocationId(), inStatus);
        
        this.htmlReturn = "<table id='report' style='border-collapse:collapse'>"
                + "<tr>"
                    + "<td style='text-align: left;white-space: nowrap;width: 50px; display: inline-block'>Laporan Penghapusan Kredit</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Tanggal : "+tglAwal+" - "+tglAkhir+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Cabang : "+cabang+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: center;padding:5px; font-size: large'>&nbsp;</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;width: 50px; display: inline-block'>No</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>CABANG</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>NO. PK</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>NAMA KONSUMEN</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>ALAMAT</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>NAMA BARANG</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>DP</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>PIUTANG POKOK</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>PIUTANG BUNGA</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>TOTAL KREDIT</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>DIBAYAR</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>SISA POKOK</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>SISA BUNGA</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>SISA KREDIT</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>KETERANGAN</td>"
                + "</tr>";
        
        double grandKredit = 0;
        double grandDp = 0;
        double grandSudahDibayar = 0;
        double grandSisaPokok = 0;
        double grandSisaBunga = 0;
        double grandPokok = 0;
        double grandBunga = 0;
        
        double total = 0;
        String noKredit = "";
        int no = 0;
        for (int i = 0; i <= records.size() - 1; i++) {
            ReportKredit reportKredit = (ReportKredit) records.get(i);
            int cnt = reportKredit.getCntKredit();

            if (!noKredit.equals(reportKredit.getNoPk())){
                noKredit = reportKredit.getNoPk();;
                no++;
                
                grandDp += reportKredit.getJmlDp();
                grandKredit += reportKredit.getTotal();
                grandSudahDibayar += reportKredit.getPembayaran();
                grandSisaPokok += reportKredit.getSisaPokok();
                grandSisaBunga += reportKredit.getSisaBunga();
                grandPokok += reportKredit.getPokok();
                grandBunga += reportKredit.getBunga();
                
                this.htmlReturn += "<tr>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle; width: 50px; display: inline-block' rowspan='"+cnt+"'>"+(no)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+reportKredit.getCabang()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+reportKredit.getNoPk()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+reportKredit.getNamaKonsumen()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+reportKredit.getAddrKonsumen()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+ reportKredit.getNamaItem()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+String.format("%,.2f", reportKredit.getJmlDp())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+String.format("%,.2f", reportKredit.getPokok())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+String.format("%,.2f", reportKredit.getBunga())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+String.format("%,.2f", reportKredit.getTotal())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+String.format("%,.2f", reportKredit.getPembayaran())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+String.format("%,.2f", reportKredit.getSisaPokok())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+String.format("%,.2f", reportKredit.getSisaBunga())+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+String.format("%,.2f", (reportKredit.getSisaBunga() + reportKredit.getSisaPokok()))+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' rowspan='"+cnt+"'>"+reportKredit.getNotes()+"</td>"
                    + "</tr>";
            } else {
                this.htmlReturn += "<tr>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+ reportKredit.getNamaItem()+"</td>"
                    + "</tr>";
            }
        }
        this.htmlReturn += "<tr>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle; width: 50px; display: inline-block'>&nbsp;</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>&nbsp;</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>&nbsp;</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>&nbsp;</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>&nbsp;</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>&nbsp;</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+String.format("%,.2f", grandDp)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+String.format("%,.2f", grandPokok)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+String.format("%,.2f", grandBunga)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+String.format("%,.2f", grandKredit)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+String.format("%,.2f", grandSudahDibayar)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+String.format("%,.2f", grandSisaPokok)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+String.format("%,.2f", grandSisaBunga)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+String.format("%,.2f", (grandSisaPokok + grandSisaBunga))+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>&nbsp;</td>"
                    + "</tr>";
        this.htmlReturn += "</table>";
        
    }
    
    private void reportTransaksi(HttpServletRequest request){
        String where  = "";
        String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
        String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
        String arrayNasabah[] = request.getParameterValues("FRM_NASABAH");
//        String arrayTransaksi[] = request.getParameterValues("FRM_TRANSAKSI");
        long dataKolektor = FRMQueryString.requestLong(request, "FRM_KOLEKTOR");
        long dataUser = FRMQueryString.requestLong(request, "FRM_USER");
        String dataTransaksi = FRMQueryString.requestString(request, "FRM_TRANSAKSI");
        int status = FRMQueryString.requestInt(request, "FRM_STATUS");
        
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
            where += " DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + tglAwal + "'"
                    + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + tglAkhir + "'";
        }
        
        String nasabah = "Semua";
        
        if (arrayNasabah != null && !arrayNasabah[0].equals("0")) {
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
            where += (idNasabah.isEmpty()) ? "" : " AND a." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " IN (" + idNasabah + ")";
            Vector listAnggota = PstAnggota.list(0, 0, PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " IN (" + idNasabah + ")", "");
            for (int x=0; x < listAnggota.size(); x++){
                Anggota ang = (Anggota) listAnggota.get(x);
                if (x>0){
                    nasabah += ","+ang.getName();
                } else {
                    nasabah = ang.getName();
                }
            }
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
                where += " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN ("
                        + "" + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT;
                where += "," + Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN;
                where += "," + Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN
                        + "," + Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN
                        + "," + Transaksi.USECASE_TYPE_KREDIT_PENALTY_MACET_PENCATATAN
                        + "," + Transaksi.USECASE_TYPE_KREDIT_PENALTY_DINI_PENCATATAN
                        + ")";
            } else {
                where += " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + kodeTransaksi + ")";
            }
        }
        String kolektor = "Semua";
        if(dataKolektor != 0){
            where += " AND p." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + dataKolektor;
            Employee emp = PstEmployee.fetchFromApi(dataKolektor);
            kolektor = emp.getFullName();
        }
        
        String user = "Semua";
        if(dataUser != 0){
            where += " AND u." + PstAppUser.fieldNames[PstAppUser.FLD_EMPLOYEE_ID] + " = " + dataUser;
            Employee emp = PstEmployee.fetchFromApi(dataUser);
            user = emp.getFullName();
        }
        
        String statusTr = "Semua";
        if (status > 0){
            where += " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_STATUS] + " = " + status ;
            statusTr = Transaksi.STATUS_DOC_TRANSAKSI_TITLE[status];
        }
        
        Vector listData = new Vector();
        if (au.getAssignLocationId() != 0) {
            listData = SessKredit.getListReport(0, 0, where + " AND bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + au.getAssignLocationId() + " GROUP BY t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID], "t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+" DESC");
        } else {
            listData = SessKredit.getListReport(0, 0, where + " GROUP BY t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID], "t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+" DESC");
        }
        
        Location locUser = new Location();
        try {
            locUser = PstLocation.fetchExc(au.getAssignLocationId());
        } catch (Exception exc){}
        
        this.htmlReturn = "<table id='report' style='border-collapse:collapse'>"
                + "<tr>"
                    + "<td style='text-align: left;white-space: nowrap;width: 50px; display: inline-block'>Daftar Transaksi</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Tanggal : "+tglAwal+" - "+tglAkhir+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Cabang : "+(locUser.getOID()>0 ? locUser.getName() : "Semua")+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Nasabah : "+nasabah+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Kolektor : "+kolektor+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>User : "+user+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Status : "+statusTr+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: center;padding:5px; font-size: large'>&nbsp;</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;width: 50px; display: inline-block'>No</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Tanggal Transaksi</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Keterangan</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nomor Transaksi</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nama Konsumen</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Lokasi</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nomor Kredit</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nilai Transaksi</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>User</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Status</td>"
                + "</tr>";
        double total = 0;
        for (int i = 0; i <= listData.size() - 1; i++) {
            Vector vect = (Vector) listData.get(i);
            Transaksi tr = (Transaksi) vect.get(0);
            Pinjaman p =(Pinjaman) vect.get(3);
            Anggota a = (Anggota) vect.get(1);
            AngsuranPayment ap = (AngsuranPayment) vect.get(4);
            Location loc = (Location) vect.get(2);
            AppUser u = new AppUser();

            try {
                u = PstAppUser.fetch(tr.getAppUserId());
            } catch (Exception e) {

            }
            total += ap.getJumlah();
            String strStatus = Transaksi.STATUS_DOC_TRANSAKSI_TITLE[tr.getStatus()].toUpperCase();
            if (tr.getStatus() == Transaksi.STATUS_DOC_TRANSAKSI_POSTED) {
                strStatus = "<span style='color: red'>Posted</span>";
            }

            this.htmlReturn += "<tr>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle; width: 50px; display: inline-block'>"+(i + 1)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+Formater.formatDate(tr.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss")+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+tr.getKeterangan()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+tr.getKodeBuktiTransaksi()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+a.getName()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+loc.getName()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+ p.getNoKredit()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;' class='money'>"+ap.getJumlah()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+u.getFullName()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'>"+strStatus+"</td>"
                    + "</tr>";
        }
        this.htmlReturn += "<tr>"
                + "<td colspan='7' style='border:1px solid black; height: 50px;text-align: right;vertical-align: middle;'><b>Total</b></td>"
                + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'><b><div class='text-right money'>"+total+"</div></b></td>"
                + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'>&nbsp;</td>"
                + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'>&nbsp;</td>"
                + "</table>";
        
    }
    
    private void getReportPenjualanKredit(HttpServletRequest request){
        String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
        String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
        String[] lokasi = request.getParameterValues("FORM_LOKASI");
        String[] status = request.getParameterValues("FORM_STATUS");
        String inLokasi = "";
        if (lokasi != null){
            for (int i = 0; i < lokasi.length; i++){
                if (inLokasi.length()>0){
                    inLokasi += ","+lokasi[i];
                } else {
                    inLokasi += lokasi[i];
                }
            }
        }
        if (inLokasi.equals("0")){
            inLokasi = "";
        }
        String namaLokasi = "";
        if (inLokasi.length()>0){
            Vector listLokasi = PstLocation.list(0, 0, PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]+" IN ("+inLokasi+")", "");
            for (int i=0; i < listLokasi.size(); i++){
                Location loc = (Location) listLokasi.get(i);
                if (i>0){
                    namaLokasi += ",";
                }
                namaLokasi += loc.getName();
            }
        }
        String inStatus = "";
        int type = 0;
        if (status != null){
            boolean isStatusBayar = false;
            boolean isStatusBelumBayar = false;
            for (int i=0; i < status.length; i++){
                if (status[i].equals("-1")){
                    isStatusBayar = true;
                } else if (status[i].equals("-2")){
                    isStatusBelumBayar = true;
                } else {
                    if (inStatus.length()>0){
                        inStatus += ","+status[i];
                    } else {
                        inStatus += status[i];
                    }
                }
            }
            if (!isStatusBayar && !isStatusBelumBayar){
                type = 0;
            } else if (isStatusBayar){
                type = 1;
            } else if (isStatusBelumBayar){
                type = 2;
            }
        }
        Vector records = SessReportKredit.getReportPenjualanKredit(tglAwal, tglAkhir, inLokasi, type, inStatus);
        this.htmlReturn = "<table id='report' style='border-collapse:collapse'>"
                + "<tr>"
                    + "<td style='text-align: left;white-space: nowrap;width: 150px; display: inline-block'>Daftar Penjualan Kredit</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Tanggal : "+tglAwal+" - "+tglAkhir+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Cabang : "+(namaLokasi.length()>0 ? namaLokasi : "Semua")+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: center;padding:5px; font-size: large'>&nbsp;</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Tanggal Transaksi</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Tahun</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Bulan</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Tanggal</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>No PK</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Cabang</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nama Pelanggan</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Alamat Pelanggan</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Kode Marketing</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nama Marketing</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Kode Analis</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nama Analis</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Kode Kolektor</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nama Kolektor</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Kode Kelompok</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nama Kelompok</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>SKU</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nama Barang</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Qty</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Lama Kredit</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Tgl Jatuh Tempo</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Angsuran</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Total Penjualan</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Pembayaran</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Saldo</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Hpp</td>"
                + "</tr>";
        
        double grandAngsuran = 0;
        double grandSudahDibayar = 0;
        double grandSaldo = 0;
        double grandTotal = 0;
        double grandHpp = 0;
        String lastPk = "";
        if (records.size()>0){ 
            for (int x=0; x<records.size();x++){
                ReportKredit reportKredit = (ReportKredit) records.get(x);
                if (!reportKredit.getNoPk().equals(lastPk)){
                    grandAngsuran += reportKredit.getAngsuran();
                    grandTotal += reportKredit.getTotal();
                    grandSudahDibayar += reportKredit.getPembayaran();
                    grandSaldo += reportKredit.getTotal() - reportKredit.getPembayaran();
                }
                grandHpp += reportKredit.getCost();
                this.htmlReturn += "<tr>"
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+Formater.formatDate(reportKredit.getTglRealisasi(), "dd MMM yyyy")+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getYear()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getMonth()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getDay()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getNoPk()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getCabang()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getNamaKonsumen()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getAddrKonsumen()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getCodeSales()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getNamaSales()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getCodeAnalis()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getNamaAnalis()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getCodeKolektor()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getNamaKolektor()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getCodeGroup()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getNamaGroup()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getSkuItem()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getNamaItem()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getQty()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getJangkaWaktu()+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+Formater.formatDate(reportKredit.getJatuhTempo(), "dd MMM yyyy")+"</td>";
                if (!reportKredit.getNoPk().equals(lastPk)){
                    this.htmlReturn += ""
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+decimalFormat.format(reportKredit.getAngsuran())+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+decimalFormat.format(reportKredit.getTotal())+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+decimalFormat.format(reportKredit.getPembayaran())+"</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+decimalFormat.format((reportKredit.getTotal()-reportKredit.getPembayaran()))+"</td>";
                    lastPk = reportKredit.getNoPk();
                } else {
                    this.htmlReturn += ""
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'></td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'></td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'></td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'></td>";
                }
                this.htmlReturn += ""
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+decimalFormat.format(reportKredit.getCost())+"</td></tr>" 
                        ;
            }
            
            this.htmlReturn += "<tr>"
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle; text-align: right;' colspan='21'><b>TOTAL</td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'><b>"+decimalFormat.format(grandAngsuran)+"</b></td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'><b>"+decimalFormat.format(grandTotal)+"</b></td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'><b>"+decimalFormat.format(grandSudahDibayar)+"</b></td>" 
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'><b>"+decimalFormat.format(grandSaldo)+"</b></td>"
                        + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'><b>"+decimalFormat.format(grandHpp)+"</b></td>"
                    + "</tr>"
                    + "</table>";
            
        }
        
    }

    private void getSisaKredit(HttpServletRequest request){
        String[] lokasi = request.getParameterValues("FORM_LOKASI");
        String noKredit = FRMQueryString.requestString(request, "FORM_NO_KREDIT");
        String date = FRMQueryString.requestString(request, "FRM_TGL");
        
        
        String addSql = "";
        String cvtLoc = "";
        if (lokasi != null) {
            int count = 0;
            for(String loc : lokasi){
                if(count > 0){
                        cvtLoc += ",";
                }
                cvtLoc += loc;
                count++;
            }
            addSql += " AND loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " IN (" + cvtLoc + ")";
        }
        
        if (!noKredit.equals("")) {
            addSql += " AND p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " = '" + noKredit + "'";
        }
        
        String namaLokasi = "";
        Vector listLokasi = PstLocation.list(0, 0, PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " IN (" + cvtLoc + ")", "");
        for (int x=0; x< listLokasi.size();x++){
            Location loc = (Location) listLokasi.get(x);
            if (x>0){
                namaLokasi += ",";
            }
            namaLokasi += loc.getName();
        }
        
        String where = "p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_CAIR;
        String group = " GROUP BY p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID];
        String order = "p." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI];
        Vector listSisaPinjaman = SessReportKredit.listSisaPinjamanV2(where + addSql, order, date);
        this.htmlReturn = "<table id='report' style='border-collapse:collapse'>"
                + "<tr>"
                    + "<td style='text-align: left;white-space: nowrap;width: 50px; display: inline-block'>Daftar Sisa Kredit</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Saldo per Tanggal : "+date+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: left; white-space: nowrap; width: 50px; display: inline-block'>Cabang : "+(namaLokasi.length()>0 ? namaLokasi : "Semua")+"</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='text-align: center;padding:5px; font-size: large'>&nbsp;</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                    + "<td style='text-align: left;'>&nbsp</td>"
                + "</tr>"
                + "<tr>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>No.</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nomor Kredit</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Nama Konsumen</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Jumlah Kredit</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>DP</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Jangka Waktu</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Lokasi Transaksi</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Kolektor</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Tanggal Realisasi</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Jatuh Tempo</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Angsuran</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Sisa Pokok</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Sisa Bunga</td>"
                    + "<td style='border:1px solid black; height: 50px;background-color: #eee; text-align: center;vertical-align: middle;'>Sisa Saldo</td>"
                + "</tr>";
        
        if (listSisaPinjaman.size()>0){
            double totalPinjaman = 0;
            double totalDP = 0;
            double totalAngsuran = 0;
            double totalSisaPokok = 0;
            double totalSisaBunga = 0;
            for (int i = 0; i < listSisaPinjaman.size(); i++) {
                ReportKredit reportKredit = (ReportKredit) listSisaPinjaman.get(i);
                totalPinjaman += reportKredit.getJmlKredit();
                totalDP += reportKredit.getJmlDp();
                totalAngsuran += reportKredit.getAngsuran();
                totalSisaBunga += reportKredit.getSisaBunga();
                totalSisaPokok += reportKredit.getSisaPokok();
                
                this.htmlReturn += "<tr>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle; width: 50px; display: inline-block'>"+(i + 1)+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getNoPk()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getNamaKonsumen()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class='money'>"+reportKredit.getJmlKredit()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class='money'>"+reportKredit.getJmlDp()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getJangkaWaktu()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+ reportKredit.getCabang()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' >"+reportKredit.getNamaKolektor()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getTglRealisasi()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;'>"+reportKredit.getJatuhTempo()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class='money'>"+reportKredit.getAngsuran()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class='money'>"+reportKredit.getSisaPokok()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class='money'>"+reportKredit.getSisaBunga()+"</td>"
                    + "<td style='border:1px solid black; height: 50px; vertical-align: middle;' class='money'>"+(reportKredit.getSisaBunga()+reportKredit.getSisaPokok()) +"</td>"
                    + "</tr>";
                
            }
            this.htmlReturn += "<tr>"
                + "<td colspan='3' style='border:1px solid black; height: 50px;text-align: right;vertical-align: middle;'><b>Total</b></td>"
                + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'><b><div class='text-right money'>"+totalPinjaman+"</div></b></td>"
                + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'><b><div class='text-right money'>"+totalDP+"</div></b></td>"
                + "<td colspan='5' style='border:1px solid black; height: 50px;text-align: right;vertical-align: middle;'></td>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'><b><div class='text-right money'>"+totalAngsuran+"</div></b></td>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'><b><div class='text-right money'>"+totalSisaPokok+"</div></b></td>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'><b><div class='text-right money'>"+totalSisaBunga+"</div></b></td>"
                    + "<td style='border:1px solid black; height: 50px; text-align: center;vertical-align: middle;'><b><div class='text-right money'>"+(totalSisaBunga + totalSisaPokok)+"</div></b></td>"
                    + "</tr>"
                + "</table>";
        }
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
