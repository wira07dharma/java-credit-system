/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.transaksi;

import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.ajax.transaksi.extensible.HTTPTabungan;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.masterdata.MasterTabungan;
import com.dimata.sedana.entity.masterdata.PstAssignContact;
import com.dimata.sedana.entity.masterdata.PstMasterTabungan;
import com.dimata.sedana.entity.tabungan.DataTabungan;
import com.dimata.sedana.entity.tabungan.DetailTransaksi;
import com.dimata.sedana.entity.tabungan.JenisSimpanan;
import com.dimata.sedana.entity.tabungan.JenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstDataTabungan;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisSimpanan;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.sedana.session.Tabungan;
import java.io.IOException;
import java.util.Date;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Dimata 007
 */
public class AjaxPenutupan extends HTTPTabungan {

    public static final int SAVE_PENUTUPAN = 0;
    public static final int FORM_PENUTUPAN = 1;
    public static final int FORM_SEARCH = 2;
    public static final int VIEW_TABUNGAN = 3;
    public static final int SEARCH_NO_TABUNGAN = 4;
    public static final int SEARCH_MEMBER_NAME = 5;
    private static final String uri = "/transaksi/tabungan/";
    
    @Override
    protected String[] page() {
        String[] r = {
            uri + "penutupan.jsp",
            uri + "penutupan.jsp",
            uri + "penutupan.jsp",
            uri + "penutupan.jsp",
            uri + "penutupan.jsp"
        };
        return r;
    }

    @Override
    protected void executeMethod() {
        switch (this.dataFor) {

            case FORM_SEARCH:
                formSearch();
                break;

            case FORM_PENUTUPAN:
                formPenutupan();
                break;

            case SAVE_PENUTUPAN:
                savePenutupan();
                break;

            case VIEW_TABUNGAN:
                viewTabungan();
                break;

            case SEARCH_NO_TABUNGAN:
                searchMember();
                break;

            case SEARCH_MEMBER_NAME:
                searchMember();
                break;
        }
    }

  public void formSearch() {
    this.isJSON = false;
    this.redirect = false;
    this.req.setAttribute("dataFor", FORM_PENUTUPAN);
  }
  
  public void formPenutupan() {
    String whereJs = PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_ID_JENIS_SIMPANAN]+ " IN (SELECT ID_JENIS_SIMPANAN FROM `sedana_assign_contact_tabungan` t JOIN `aiso_data_tabungan` d ON d.`ASSIGN_TABUNGAN_ID`=t.`ASSIGN_TABUNGAN_ID` WHERE t.`NO_TABUNGAN` = '"+this.tabungan.getNoTabungan()+"' AND d.STATUS = 1)"
            //+ " AND " + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_FREKUENSI_PENARIKAN] + " = '0'"
            + "";
    Vector<JenisSimpanan> js = PstJenisSimpanan.list(0, 0, whereJs, PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]);
    Vector<JenisTransaksi> jts = PstJenisTransaksi.list(0, 0, PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + " = " + Transaksi.TIPE_ARUS_KAS_BERKURANG + " AND TYPE_PROSEDUR = " + Transaksi.TIPE_PROSEDUR_BY_TELLER, PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI]);
    String jenisTransaksi = "";
    for (JenisTransaksi jt : jts) {
        jenisTransaksi += "<option value='" + jt.getOID() + "'>" + jt.getJenisTransaksi() + "</option>";
      }
    this.isJSON = false;
    this.redirect = false;
    this.req.setAttribute("dataFor", SAVE_PENUTUPAN);
    this.req.setAttribute("jenisTransaksi", jenisTransaksi);
    this.req.setAttribute("js", js);
  }
  
  public void viewTabungan() {
    this.isJSON = false;
    this.redirect = false;
    this.req.setAttribute("dataFor", VIEW_TABUNGAN);
    Vector<MasterTabungan> mt = PstMasterTabungan.list(0, 0, PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID]+" IN ("+PstAssignContact.queryAssignTabungan(tabungan.getOID())+")", "");
    this.req.setAttribute("ttabungan", mt);
  }
  
  public synchronized void savePenutupan() {
    this.redirect = true;
    String kodeTransaksi = I_Sedana.KODE_TRANSAKSI_TABUNGAN_PENUTUPAN;
    int useCaseType = I_Sedana.USECASE_TYPE_TABUNGAN_PENUTUPAN;
    String nomorTransaksi = PstTransaksi.generateKodeTransaksi(kodeTransaksi, useCaseType, tabungan.getTanggal());
    if (keterangan.isEmpty()) {
        keterangan = Transaksi.USECASE_TYPE_TITLE.get(useCaseType);
    } else {
        keterangan = Transaksi.USECASE_TYPE_TITLE.get(useCaseType) + ". CATATAN : " + keterangan;
    }
    Transaksi trx = new Transaksi();
    trx.setIdAnggota(tabungan.getOID());
    trx.setTanggalTransaksi(tabungan.getTanggal());
    trx.setKodeBuktiTransaksi(nomorTransaksi);
    trx.setKeterangan(keterangan);
    trx.setUsecaseType(useCaseType);
    trx.setTellerShiftId(this.TelerId);
    trx.setTipeArusKas(1);
    trx.setStatus(5);
    long idTransaksi = 0;
    try {
      idTransaksi = PstTransaksi.insertExc(trx);
      this.transaksiId = idTransaksi;
      for(Tabungan.List t: tabungan.getSimpanan()) {
        if(t.getInputSaldo() > 0 && (t.getSaldoAwal()-t.getInputSaldo() >= 0)) {
          DataTabungan dt = new DataTabungan();
          Vector<DataTabungan> dts = PstDataTabungan.list(0, 1, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID]+"="+tabungan.getAssignContactTabunganId()+" AND "+PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA]+"="+tabungan.getOID()+" AND "+PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN]+"="+t.getOID(), "");
          if(dts.size() < 1) {
            dt.setIdAnggota(tabungan.getOID());
            dt.setContactIdAhliWaris(tabungan.getOID());
            dt.setAssignTabunganId(tabungan.getAssignContactTabunganId());
            dt.setTanggal(tabungan.getTanggal());
            dt.setStatus(1);
            dt.setIdJenisSimpanan(t.getOID());
            try {
              PstDataTabungan.insertExc(dt);
            } catch (DBException ex) {
              Logger.getLogger(AjaxSetoran.class.getName()).log(Level.SEVERE, null, ex);
            }
          } else {
            dt = dts.get(0);
          }

          DetailTransaksi dtrx = new DetailTransaksi();
          dtrx.setIdSimpanan(dt.getOID());
          dtrx.setJenisTransaksiId(t.getIdJenisTransaksi());
          dtrx.setDebet(t.getInputSaldo());
          dtrx.setTransaksiId(trx.getOID());
          try {
            PstDetailTransaksi.insertExc(dtrx);
          } catch (DBException ex) {
            Logger.getLogger(AjaxSetoran.class.getName()).log(Level.SEVERE, null, ex);
          }
        }
      }
      
      //UBAH STATUS SIMPANAN JADI 0 (tutup tabungan)
      for(Tabungan.List t: tabungan.getSimpanan()) {
          Vector<DataTabungan> dts = PstDataTabungan.list(0, 1, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID]+"="+tabungan.getAssignContactTabunganId()+" AND "+PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA]+"="+tabungan.getOID()+" AND "+PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN]+"="+t.getOID(), "");
          if (!dts.isEmpty()) {
            try {
                DataTabungan dt = dts.get(0);
                dt.setStatus(0);
                dt.setAlasanTutup(this.tabungan.getAlasanTutup());
                PstDataTabungan.updateExc(dt);
                if (dt.getTanggalTutup() == null) {
                    dt.setTanggalTutup(new Date());
                    PstDataTabungan.updateExc(dt);
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
                System.out.println("Gagal menutup tabungan " + this.tabungan.getNoTabungan() + " Item " + t.getNamaSimpanan() + " !");
            }
          }
      }
    } catch (DBException ex) {
      Logger.getLogger(AjaxSetoran.class.getName()).log(Level.SEVERE, null, ex);
    }
    
    if(idTransaksi != 0) {
      this.redirect = false;
      this.dataFor = VIEW_TABUNGAN;
      tabungan.setOID(idTransaksi);
      this.req.setAttribute("oid", idTransaksi);
      this.viewTabungan();
    } else {
      this.redirect = true;
    }
  }
  
  public void searchMember() {
     try {
      JSONArray jsonArray = new JSONArray();

      String query = FRMQueryString.requestString(this.req, "query");
      String where = (this.dataFor == SEARCH_MEMBER_NAME) ? PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE \"%" + query + "%\" " : PstAssignContact.fieldNames[PstAssignContact.FLD_NO_TABUNGAN] + " LIKE \"%" + query + "%\" ";
      Vector<ContactList> members = PstContactList.listTabungan(0, 0, where, PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME]);

      for (ContactList c : members) {
        JSONObject jContact = new JSONObject();

        //Plugin required fields
        String value = (this.dataFor == SEARCH_MEMBER_NAME) ? c.getPersonLastname() : c.getNoRekening();
        jContact.put("value", value);
        jContact.put("name", value);

        //Additional
        jContact.put("assignContactID", String.valueOf(c.getParentId()));
        jContact.put("memberOID", String.valueOf(c.getOID()));
        jContact.put("noRekening", c.getNoRekening());
        jContact.put("personName", c.getPersonLastname());
        jContact.put("homeAddr", c.getHomeAddr());

        jsonArray.put(jContact);
      }
      String result = jsonArray.toString();
      this.isJSON = true;
      this.JSON = "{ \"suggestions\": " + result + " }";
    } catch (JSONException jSONException) {
      jSONException.printStackTrace();
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
