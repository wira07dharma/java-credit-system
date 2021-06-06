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
import com.dimata.sedana.entity.assigntabungan.PstAssignTabungan;
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
import com.dimata.common.session.convert.Master;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.session.Tabungan;
import java.io.IOException;
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
 * @author Regen
 */
public class AjaxSetoran extends HTTPTabungan {

  public static final int SAVE_TABUNGAN = 0;
  public static final int FORM_TABUNGAN = 1;
  public static final int FORM_SEARCH = 2;
  public static final int VIEW_TABUNGAN = 3;
  public static final int SEARCH_NO_TABUNGAN = 4;
  public static final int SEARCH_MEMBER_NAME = 5;
  private static final String uri = "/transaksi/tabungan/";

  @Override
  protected String[] page() {
    String[] r = {
      uri + "setoran.jsp",
      uri + "setoran.jsp",
      uri + "setoran.jsp",
      uri + "setoran.jsp",
      uri + "setoran.jsp",
      uri + "setoran.jsp"
    };

    return r;
  }

  @Override
  protected void executeMethod() {
    switch (this.dataFor) {
      case FORM_SEARCH:
        formSearch();
        break;
      case FORM_TABUNGAN:
        formTabungan();
        break;
      case SAVE_TABUNGAN:
        saveTabungan();
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

  protected void formSearch() {
    this.isJSON = false;
    this.redirect = false;
    this.req.setAttribute("dataFor", FORM_TABUNGAN);
  }

  protected void formTabungan() {
    this.isJSON = false;
    this.redirect = false;

    Vector<JenisSimpanan> tjs = PstJenisSimpanan.listJenisSetoran(Integer.valueOf(Master.date2String(this.tabungan.getTanggal(), "yyyy")), Integer.valueOf(Master.date2String(this.tabungan.getTanggal(), "MM")), this.tabungan.getOID());
    String availableJS = "";
    for (JenisSimpanan x : tjs) {
      if (!availableJS.equals("")) {
        availableJS += ", ";
      }
      availableJS += String.valueOf(x.getOID());
    }

    //Vector<JenisSimpanan> js = PstJenisSimpanan.list(0, 0, PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_ID_JENIS_SIMPANAN] + " IN (" + PstAssignTabungan.getIdJenisSimpananByTabungan(tabungan) + ") AND " + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_ID_JENIS_SIMPANAN] + " IN (" + availableJS + ")", "");
    Vector<JenisSimpanan> js = PstJenisSimpanan.list(0, 0, PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_ID_JENIS_SIMPANAN] + " IN (" + PstAssignTabungan.getIdJenisSimpananByTabungan(tabungan) + ")", "");
    Vector<JenisTransaksi> jts = PstJenisTransaksi.list(0, 0, PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + " = 0 AND TYPE_PROSEDUR = 1", PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI]);
    String jenisTransaksi = "";
    for (JenisTransaksi jt : jts) {
      jenisTransaksi += "<option value='" + jt.getOID() + "'>" + jt.getJenisTransaksi() + "</option>";
    }

    this.req.setAttribute("dataFor", SAVE_TABUNGAN);
    this.req.setAttribute("jenisTransaksi", jenisTransaksi);
    this.req.setAttribute("js", js);
  }

  protected void viewTabungan() {
    this.isJSON = false;
    this.redirect = false;
    this.req.setAttribute("dataFor", VIEW_TABUNGAN);
    Vector<MasterTabungan> mt = PstMasterTabungan.list(0, 0, PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID] + " IN (" + PstAssignContact.queryAssignTabungan(tabungan.getOID()) + ")", "");
    this.req.setAttribute("ttabungan", mt);
  }

  protected synchronized void saveTabungan() {

    long idTransaksi = 0;
    try {
        String kodeTransaksi = I_Sedana.KODE_TRANSAKSI_TABUNGAN_SETORAN;
        int useCaseType = I_Sedana.USECASE_TYPE_TABUNGAN_SETORAN;
        String nomorTransaksi = PstTransaksi.generateKodeTransaksi(kodeTransaksi, useCaseType, tabungan.getTanggal());
        if (keterangan.isEmpty()) {
            keterangan = Transaksi.USECASE_TYPE_TITLE.get(useCaseType);
        } else {
            keterangan = Transaksi.USECASE_TYPE_TITLE.get(useCaseType) + ". CATATAN : " + keterangan;
        }
      //
      Transaksi trx = new Transaksi();
      trx.setIdAnggota(tabungan.getOID());
      trx.setTanggalTransaksi(tabungan.getTanggal());
      trx.setTellerShiftId(this.TelerId);
      trx.setKodeBuktiTransaksi(nomorTransaksi);
      trx.setKeterangan(keterangan);
      trx.setUsecaseType(useCaseType);
      trx.setTipeArusKas(0);
      trx.setStatus(5);
      idTransaksi = PstTransaksi.insertExc(trx);
      this.transaksiId = idTransaksi;

      boolean pokok = true;
      long oidSukarela = 0;
      String namaTabungan = "";
      String namaSimpanan = "";

      for (Tabungan.List t : tabungan.getSimpanan()) {
//        if(t.getInputSaldo() > 0) {
        if (true) {
          JenisSimpanan s = PstJenisSimpanan.fetchExc(t.getOID());
          //
          DataTabungan dt = new DataTabungan();
          Vector<DataTabungan> dts = PstDataTabungan.list(0, 1, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + "=" + tabungan.getAssignContactTabunganId() + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA] + "=" + tabungan.getOID() + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + "=" + t.getOID(), "");
          if (dts.size() < 1) {
            dt.setIdAnggota(tabungan.getOID());
            dt.setContactIdAhliWaris(tabungan.getOID());
            dt.setAssignTabunganId(tabungan.getAssignContactTabunganId());
            dt.setTanggal(tabungan.getTanggal());
            dt.setStatus(1);
            dt.setIdJenisSimpanan(t.getOID());
            PstDataTabungan.insertExc(dt);
            pokok = s.getFrekuensiSimpanan() == 1;
          } else {
            dt = dts.get(0);
          }

          //
          if (dt.getOID() != 0) {
            DetailTransaksi dtrx = new DetailTransaksi();
            dtrx.setIdSimpanan(dt.getOID());
            dtrx.setJenisTransaksiId(t.getIdJenisTransaksi());
            dtrx.setKredit(t.getInputSaldo());
            dtrx.setTransaksiId(trx.getOID());
            PstDetailTransaksi.insertExc(dtrx);
            if (s.getFrekuensiSimpanan() == 0 && oidSukarela == 0) {
              oidSukarela = dt.getOID();
              namaSimpanan = t.getNamaSimpanan();
              namaTabungan = t.getNamaTabungan();
            }
          }
        }
      }

      //
      if (!pokok && oidSukarela != 0) {
        Vector<JenisTransaksi> jt = PstJenisTransaksi.list(0, 0, PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + "=" + "1 AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_PROSEDUR] + "=" + "0 AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + "=" + "0 AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_TRANSAKSI] + "=" + "1 ", "");
        for (JenisTransaksi j : jt) {
          DetailTransaksi dtrx = new DetailTransaksi();
          dtrx.setIdSimpanan(oidSukarela);
          dtrx.setJenisTransaksiId(j.getOID());
          dtrx.setDebet(j.getValueStandarTransaksi());
          dtrx.setTransaksiId(trx.getOID());
          PstDetailTransaksi.insertExc(dtrx);

          tabungan.addSimpanan(oidSukarela, namaTabungan, namaSimpanan, j.getOID(), 0, -j.getValueStandarTransaksi());
        }
      }
    } catch (DBException ex) {
      Logger.getLogger(AjaxSetoran.class.getName()).log(Level.SEVERE, null, ex);
    }

    if (idTransaksi != 0) {
      this.redirect = false;
      this.dataFor = VIEW_TABUNGAN;
      tabungan.setOID(idTransaksi);
      this.req.setAttribute("oid", idTransaksi);
      this.viewTabungan();
    } else {
      this.redirect = true;
    }
  }

  protected void searchMember() {
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

        Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + c.getParentId(), "");
        String namaItem = "";
        for (DataTabungan dt : listSimpanan) {
            namaItem += (namaItem.isEmpty()) ? "":", ";
            try {
                namaItem += PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan()).getNamaSimpanan();
            } catch (Exception e) {
            }
        }
        
        //Additional
        jContact.put("assignContactID", String.valueOf(c.getParentId()));
        jContact.put("memberOID", String.valueOf(c.getOID()));
        jContact.put("noRekening", c.getNoRekening());
        jContact.put("personName", c.getPersonLastname() + " - ["+namaItem+"]");
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
