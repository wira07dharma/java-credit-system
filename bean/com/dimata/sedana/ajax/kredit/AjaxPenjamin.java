/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.kredit;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.form.masterdata.anggota.CtrlAnggota;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.kredit.Penjamin;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPenjamin;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.penjamin.PersentaseJaminan;
import com.dimata.sedana.entity.penjamin.PstPersentaseJaminan;
import com.dimata.sedana.entity.tabungan.JenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import com.dimata.util.Command;
import java.io.IOException;
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
public class AjaxPenjamin extends HttpServlet {

    //OBJECT
    private JSONObject jSONObject = new JSONObject();
    private JSONArray jSONArray = new JSONArray();
    //LONG
    private long oid = 0;
    private long oidPinjaman = 0;
    private long oidAnggota = 0;
    private long oidPenjaminKredit = 0;
    private long oidJenisTransaksi = 0;
    //STRING
    private String dataFor = "";
    private String message = "";
    private String htmlReturn = "";
    //INT
    private int iCommand = 0;
    private int iErrCode = 0;
    private int jangkaWaktu = 0;
    //DOUBLE
    private double prosentaseDijamin = 0;
    private double prosentaseCoverage = 0;
    //HISTORY
    private long userId = 0;
    private String userName = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //OBJECT
        this.jSONObject = new JSONObject();
        this.jSONArray = new JSONArray();
        //LONG
        this.oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        this.oidPinjaman = FRMQueryString.requestLong(request, "SEND_OID_PINJAMAN");
        this.oidAnggota = FRMQueryString.requestLong(request, "SEND_OID_ANGGOTA");
        this.oidPenjaminKredit = FRMQueryString.requestLong(request, "SEND_OID_PENJAMIN");
        this.oidJenisTransaksi = FRMQueryString.requestLong(request, "SEND_OID_JENIS_TRANSAKSI");
        //STRING
        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.message = "";
        this.htmlReturn = "";
        //INT
        this.iCommand = FRMQueryString.requestCommand(request);
        this.iErrCode = 0;
        this.jangkaWaktu = FRMQueryString.requestInt(request, "SEND_JANGKA_WAKTU");
        //DOUBLE
        this.prosentaseDijamin = FRMQueryString.requestDouble(request, "SEND_PROSENTASE_DIJAMIN");
        this.prosentaseCoverage = FRMQueryString.requestDouble(request, "SEND_PROSENTASE_COVERAGE");
        //HISTORY
        this.userId = 0;
        this.userName = "";

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

            this.jSONObject.put("SEND_ERROR_CODE", "" + this.iErrCode);
            this.jSONObject.put("SEND_MESSAGE", "" + this.message);
            this.jSONObject.put("FRM_FIELD_HTML", this.htmlReturn);

        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }

        response.getWriter().print(this.jSONObject);
    }

    public void commandSave(HttpServletRequest request) {
        if (this.dataFor.equals("savePenjamin")) {
            saveMasterPenjamin(request);
        } else if (this.dataFor.equals("savePenjaminKredit")) {
            savePenjaminKredit(request);
        } else if (this.dataFor.equals("savePersentaseJaminan")) {
            savePersentaseJaminan(request);
        }
    }

    public void savePersentaseJaminan(HttpServletRequest request) {
        //cek database
        /*
        Vector<PersentaseJaminan> listData = PstPersentaseJaminan.list(0, 0, "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + this.oidPenjaminKredit + "'"
                + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_PERSENTASE_COVERAGE] + " = '" + this.prosentaseCoverage + "'"
                + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " = '" + this.jangkaWaktu + "'", "");
        if (!listData.isEmpty() && this.oid == 0) {
            this.iErrCode = 1;
            this.message = "Data dengan coverage " + this.prosentaseCoverage + " % dengan jangka waktu " + this.jangkaWaktu + " bulan sudah ada.";
            return;
        }
        */
        PersentaseJaminan jaminan = new PersentaseJaminan();
        jaminan.setIdPenjamin(this.oidPenjaminKredit);
        jaminan.setJangkaWaktu(this.jangkaWaktu);
        jaminan.setPersentaseCoverage(this.prosentaseCoverage);
        jaminan.setPersentaseDijamin(this.prosentaseDijamin);
        try {
            if (this.oid == 0) {
                PstPersentaseJaminan.insertExc(jaminan);
                message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
            } else {
                jaminan.setOID(this.oid);
                PstPersentaseJaminan.updateExc(jaminan);
                message = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
            }
        } catch (DBException ex) {
            iErrCode = 1;
            message = ex.getMessage();
        }
    }
    
    public void cekValidasiPenjamin(HttpServletRequest request) {
        Penjamin pe = new Penjamin();
        Pinjaman pi = new Pinjaman();
        JenisTransaksi jt = new JenisTransaksi();
        try {
            pe = PstPenjamin.fetchExc(this.oidPenjaminKredit);
            pi = PstPinjaman.fetchExc(this.oidPinjaman);
            jt = PstJenisTransaksi.fetchExc(this.oidJenisTransaksi);
        } catch (Exception e) {
            this.iErrCode += 1;
            if (pe.getOID() == 0) {
                this.message += "Pastikan data penjamin dipilih dengan benar !";
            }
            if (pi.getOID() == 0) {
                this.message += "Data kredit tidak ditemukan !";
            }
            if (jt.getOID() == 0) {
                this.message += "Data jenis transaksi tidak ditemukan !";
            }
            return;
        }
        //cek persentase jaminan
        
        //
        if (this.iErrCode == 0) {
            savePenjaminKredit(request);
        }
    }
    
    public void savePenjaminKredit(HttpServletRequest request) {
        // set nilai penjamin
        Penjamin p = new Penjamin();
        p.setContactId(this.oidPenjaminKredit);
        p.setProsentasePenjamin(this.prosentaseDijamin);
        p.setCoverage(this.prosentaseCoverage);
        p.setPinjamanId(this.oidPinjaman);
        p.setJenisTransaksiId(this.oidJenisTransaksi);
        try {
            if (this.oid == 0) {
                PstPenjamin.insertExc(p);
                message = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
            } else {
                p.setOID(oid);
                PstPenjamin.updateExc(p);
                message = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
            }
        } catch (DBException ex) {
            this.iErrCode = 1;
            message = ex.getMessage();
        }
    }

    public void saveMasterPenjamin(HttpServletRequest request) {
        Anggota anggota = new Anggota();
        CtrlAnggota ctrlAnggota = new CtrlAnggota(request);
        try {
            ctrlAnggota.ActionPenjamin(iCommand, oid, oidPinjaman, prosentaseDijamin);
            anggota = ctrlAnggota.getAnggota();
        } catch (DBException ex) {

        }
        long idPenjamin = anggota.getOID();
        this.message = ctrlAnggota.getMessage();
        if (!message.equals(FRMMessage.getMessage(FRMMessage.MSG_SAVED)) && !message.equals(FRMMessage.getMessage(FRMMessage.MSG_UPDATED))) {
            this.iErrCode = 1;
        }
    }

    public void commandDelete(HttpServletRequest request) {
        if (this.dataFor.equals("deletePenjamin")) {
            deleteMasterPenjamin(request);
        } else if (this.dataFor.equals("deletePenjaminKredit")) {
            deletePenjaminKredit(request);
        } else if (this.dataFor.equals("deletePersentaseJaminan")) {
            deletePersentaseJaminan(request);
        }
    }

    public void deletePersentaseJaminan(HttpServletRequest request) {
        try {
            PstPersentaseJaminan.deleteExc(this.oid);
            message = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
        } catch (DBException ex) {
            iErrCode = 1;
            message = ex.getMessage();
        }
    }

    public void deletePenjaminKredit(HttpServletRequest request) {
        try {
            PstPenjamin.deleteExc(this.oid);
            message = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
        } catch (DBException ex) {
            iErrCode = 1;
            message = ex.getMessage();
        }
    }

    public void deleteMasterPenjamin(HttpServletRequest request) {
        Anggota anggota = new Anggota();
        CtrlAnggota ctrlAnggota = new CtrlAnggota(request);
        try {
            ctrlAnggota.ActionPenjamin(iCommand, oid, oidPinjaman, prosentaseDijamin);
            anggota = ctrlAnggota.getAnggota();
        } catch (DBException ex) {

        }
        long idPenjamin = anggota.getOID();
        this.message = ctrlAnggota.getMessage();
        if (!message.equals(FRMMessage.getMessage(FRMMessage.MSG_DELETED))) {
            this.iErrCode = 1;
        }
    }

    public void commandList(HttpServletRequest request, HttpServletResponse response) {

    }

    public void commandNone(HttpServletRequest request) {
        if (this.dataFor.equals("getDataCoverage")) {
            getDataCoverage(request);
        }else if (this.dataFor.equals("getDataPersentasePenjamin")) {
            getDataPersentasePenjamin(request);
        }
    }
    
    public void getDataCoverage(HttpServletRequest request) {
        this.htmlReturn = "";
        Vector listCoverage = PstPersentaseJaminan.list(0, 0, ""
                + "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + this.oid + "'"
                + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " = '" + this.jangkaWaktu + "'"
                + "", "");
        this.htmlReturn = "<option value=''>- Pilih Coverage -</option>";
        for (int i = 0; i < listCoverage.size(); i++) {
            PersentaseJaminan pj = (PersentaseJaminan) listCoverage.get(i);
            this.htmlReturn += ""
                    + "<option data-persen=" + pj.getPersentaseDijamin() + " value='" + pj.getPersentaseCoverage()+ "'>" + pj.getPersentaseCoverage() + " % (Biaya penjamin " + pj.getPersentaseDijamin() + " %)</option>"
                    + "";
        }
        if (listCoverage.isEmpty()) {
            this.htmlReturn = "<option>Coverage dengan jangka waktu tersebut tidak ditemukan</option>";
        }
    }

    public void getDataPersentasePenjamin(HttpServletRequest request) {
        this.htmlReturn = "";
        Vector listCoverage = PstPersentaseJaminan.list(0, 0, ""
                + "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + this.oid + "'"
                + "", "");
        this.htmlReturn = "<option value=''>- Pilih Coverage -</option>";
        for (int i = 0; i < listCoverage.size(); i++) {
            PersentaseJaminan pj = (PersentaseJaminan) listCoverage.get(i);
            this.htmlReturn += ""
                    + "<option data-persen=" + pj.getPersentaseDijamin() + " value='" + pj.getPersentaseCoverage()+ "'>" + pj.getPersentaseCoverage() + " % (Biaya penjamin " + pj.getPersentaseDijamin() + " %)</option>"
                    + "";
        }
        if (listCoverage.isEmpty()) {
            this.htmlReturn = "<option>Coverage dengan jangka waktu tersebut tidak ditemukan</option>";
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
