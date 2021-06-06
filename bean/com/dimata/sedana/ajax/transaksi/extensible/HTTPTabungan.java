/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.transaksi.extensible;

import com.dimata.aiso.entity.admin.AppUser;
import com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisSimpanan;
import com.dimata.aiso.session.admin.SessUserSession;
import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.common.session.convert.Master;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.ajax.kredit.AjaxKredit;
import com.dimata.sedana.ajax.transaksi.AjaxSetoran;
import com.dimata.sedana.entity.assigntabungan.AssignTabungan;
import com.dimata.sedana.entity.assigntabungan.PstAssignTabungan;
import com.dimata.sedana.entity.masterdata.AssignContact;
import com.dimata.sedana.entity.masterdata.CashTeller;
import com.dimata.sedana.entity.masterdata.MasterTabungan;
import com.dimata.sedana.entity.masterdata.PstAssignContact;
import com.dimata.sedana.entity.masterdata.PstCashTeller;
import com.dimata.sedana.entity.masterdata.PstMasterTabungan;
import com.dimata.sedana.entity.tabungan.DataTabungan;
import com.dimata.sedana.entity.tabungan.DetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstDataTabungan;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksiPayment;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.sedana.entity.tabungan.TransaksiPayment;
import com.dimata.sedana.session.Tabungan;
import com.dimata.util.Formater;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Regen
 */
public abstract class HTTPTabungan extends HttpServlet {

  protected HttpServletRequest req = null;
  protected HttpServletResponse res = null;
  protected String username = null;
  protected int dataFor = 0;
  protected long userOID = 0;
  protected long TelerId = 0;
  private long assignContactTabunganId = 0;
  protected String JSON = "";
  protected boolean isJSON = false;
  protected boolean redirect = false;
  protected Vector<TransaksiPayment> paymentSystem = new Vector<TransaksiPayment>();
  protected boolean SessionError = false;
  protected Tabungan tabungan = null;
  protected long transaksiId = 0;
  protected String keterangan = "";
  
  //added by dewok 20190117 for payment type tabungan
  List<Long> listIdSimpananPayment = new ArrayList<Long>();
  List<Double> listNominalPenarikanPayment = new ArrayList<Double>();

  public static final String FRM_FIELD_NAMA = "nama";
  public static final String FRM_FIELD_TGL = "tanggal";
  public static final String FRM_FIELD_SALDO = "saldo";
  public static final String FRM_FIELD_SALDO_AWAL = "saldo_awal";
  public static final String FRM_FIELD_DENDA = "denda";
  public static final String FRM_FIELD_MEMBER_ID = "id";
  public static final String FRM_FIELD_ALAMAT = "alamat";
  public static final String FRM_FIELD_NO_TABUNGAN = "no_tabungan";
  public static final String FRM_FIELD_SIMPANAN_ID = "simpanan_id";
  public static final String FRM_FIELD_MASTER_TABUNGAN_ID = "mastab_id";
  public static final String FRM_FIELD_SIMPANAN_NAMA = "simpanan_nama";
  public static final String FRM_FIELD_JENIS_TRANSAKSI = "jenis_transaksi";
  public static final String FRM_FIELD_JENIS_TRANSAKSI_DENDA = "jenis_transaksi_denda";
  public static final String FRM_FIELD_DENDA_STATE = "denda_state";
  public static final String FRM_FIELD_PAYMENT_TYPE = "arr_payment_type";
  public static final String FRM_FIELD_PAYMENT_NOMINAL = "arr_payment_nominal";
  public static final String FRM_FIELD_ASSIGN_CONTACT_TABUNGAN_ID = "assign_contact_id";
  //
  public static final String FRM_FIELD_ID_SIMPANAN_PAYMENT = "FRM_FIELD_ID_SIMPANAN_PAYMENT";
  public static final String FRM_FIELD_CARD_NUMBER = "FRM_FIELD_CARD_NUMBER";
  public static final String FRM_FIELD_BANK_NAME = "FRM_FIELD_BANK_NAME";
  public static final String FRM_FIELD_VALIDATE_DATE = "FRM_FIELD_VALIDATE_DATE";
  public static final String FRM_FIELD_CARD_NAME = "FRM_FIELD_CARD_NAME";
  //ADDED BY DEWOK 20180827 FOR PENUTUPAN TABUNGAN
  public static final String FRM_FIELD_ALASAN_TUTUP = "FRM_FIELD_ALASAN_TUTUP";
  //ADDED BY DEWOK 20190123 FOR KETERANGAN TRANSAKSI
  public static final String FRM_FIELD_KETERANGAN = "FRM_FIELD_KETERANGAN";

  protected abstract String[] page();

  protected abstract void executeMethod();

  /**
   * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
   * methods.
   *
   * @param request servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException if an I/O error occurs
   */
  protected void processRequest(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
    this.clear();
    sessionStarter(request, response);
    if (!this.SessionError && !this.redirect) {
      saveRequest();
      execute();
    }
  }

  private String baseUrl(String uri) {
    return generateUrl(req, uri);
  }

  private static String generateUrl(HttpServletRequest req, String uri) {
    String scheme = req.getScheme() + "://";
    String serverName = req.getServerName();
    String serverPort = (req.getServerPort() == 80) ? "" : ":" + req.getServerPort();
    String contextPath = req.getContextPath();
    return scheme + serverName + serverPort + contextPath + "/" + uri;
  }

  private void sessionStarter(HttpServletRequest request, HttpServletResponse response) throws IOException {
    res = response;
    req = request;
    this.SessionError = false;
    HttpSession session = this.req.getSession(false);
    Cookie[] cookies = request.getCookies();
    String sessionId = "";
    if(cookies !=null){
        for(Cookie cookie : cookies){
                if(cookie.getName().equals("JSESSIONID")) sessionId = cookie.getValue();
                //session.putValue(sessionId, userSess);
        }
    }
    SessUserSession userSession = new SessUserSession();
    userSession = (SessUserSession) session.getValue(sessionId);
    if (userSession == null) {
      this.SessionError = true;
      userSession = new SessUserSession();
      try {
        this.res.sendRedirect(this.req.getContextPath() + "/inform.jsp");
        this.redirect = true;
      } catch (IOException ex) {
        Logger.getLogger(AjaxSetoran.class.getName()).log(Level.SEVERE, null, ex);
      }
    } else if (userSession.isLoggedIn()) {
      AppUser appUser = userSession.getAppUser();
      this.username = appUser.getLoginId();
      this.userOID = appUser.getOID();
      this.dataFor = FRMQueryString.requestInt(req, "command");
      this.req.setAttribute("username", this.username);
      this.req.setAttribute("userOID", this.userOID);
      Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
      if (open.size() < 1) {
        this.SessionError = true;
        String redirectUrl = baseUrl("/open_cashier.jsp?redir=" + baseUrl("/masterdata/transaksi/data_tabungan.jsp"));
        this.redirect = true;
        res.sendRedirect(redirectUrl);
      } else {
        this.TelerId = open.get(0).getOID();
      }
    }
  }

  public static void redirectOpeningCashier(HttpServletRequest req, HttpServletResponse res) {
    String redirectUrl = generateUrl(req, "open_cashier.jsp?redir=" + generateUrl(req, "masterdata/transaksi/data_tabungan.jsp"));
    try {
      res.sendRedirect(redirectUrl);
    } catch (IOException ex) {
      Logger.getLogger(HTTPTabungan.class.getName()).log(Level.SEVERE, null, ex);
    }
  }

  private synchronized void clear() {
    this.JSON = "";
    this.isJSON = false;
    this.redirect = false;
    this.SessionError = false;
    this.transaksiId = 0;
  }

  private synchronized void savePayment() {
    if (transaksiId != 0) {
      try {
        for (TransaksiPayment tp : this.paymentSystem) {
          tp.setTransaksiId(this.transaksiId);
          PstTransaksiPayment.insertExc(tp);
        }
      } catch (DBException ex) {
        Logger.getLogger(HTTPTabungan.class.getName()).log(Level.SEVERE, null, ex);
      }
    }
  }
  
  //added by dewok 20190117 for payment type tabungan
  private synchronized void saveDetailTransaksiPenarikanForPaymentTabungan() {
    if (this.transaksiId != 0 && this.listIdSimpananPayment.size() > 0) {
        try {
            Transaksi setoran = PstTransaksi.fetchExc(this.transaksiId);
            String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_TABUNGAN_PENARIKAN, Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN, setoran.getTanggalTransaksi());
            
            Transaksi t = new Transaksi();
            Calendar cal = Calendar.getInstance();
            cal.setTime(setoran.getTanggalTransaksi());
            cal.add(Calendar.SECOND, -1);
            
            t.setTanggalTransaksi(cal.getTime());
            t.setIdAnggota(setoran.getIdAnggota());
            t.setTellerShiftId(setoran.getTellerShiftId());
            t.setKeterangan("Penarikan tabungan untuk transaksi setoran ke nomor tabungan '" + tabungan.getNoTabungan() + "'");
            t.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
            t.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERKURANG);
            t.setUsecaseType(Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN);
            t.setKodeBuktiTransaksi(nomorTransaksi);
            t.setTransaksiParentId(this.transaksiId);
            long idTransaksiPenarikan = PstTransaksi.insertExc(t);
            
            long idPenarikanCash = PstJenisTransaksi.getIdJenisTransaksiByNamaJenisTransaksi("Penarikan Cash");
            for (int i = 0; i < this.listIdSimpananPayment.size(); i++) {
                if (PstDataTabungan.checkOID(listIdSimpananPayment.get(i))) {
                    DetailTransaksi dtrx = new DetailTransaksi();
                    dtrx.setIdSimpanan(this.listIdSimpananPayment.get(i));
                    dtrx.setJenisTransaksiId(idPenarikanCash);
                    dtrx.setDebet(this.listNominalPenarikanPayment.get(i));
                    dtrx.setTransaksiId(idTransaksiPenarikan);
                    PstDetailTransaksi.insertExc(dtrx);
                }
            }
        } catch (DBException ex) {
            Logger.getLogger(HTTPTabungan.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
  }

  private synchronized void execute() {
    this.clear();
    this.executeMethod();
    this.savePayment();
    this.saveDetailTransaksiPenarikanForPaymentTabungan(); //added by dewok 20190117 for payment type tabungan
    if (!this.redirect) {
      if (this.isJSON) {
        try {
          this.res.getWriter().print(this.JSON);
        } catch (IOException iOException) {
          iOException.printStackTrace();
        }
      } else {
        try {
          String[] pages = page();
          String jspPath = pages[this.dataFor];
          RequestDispatcher dispatcher = this.req.getRequestDispatcher(jspPath);
          dispatcher.forward(this.req, this.res);
        } catch (Error e) {
          System.out.println(e);
        } catch (ServletException ex) {
          Logger.getLogger(AjaxSetoran.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
          Logger.getLogger(AjaxSetoran.class.getName()).log(Level.SEVERE, null, ex);
        }
      }
    }
  }

  private synchronized void saveRequest() {
    this.paymentSystem = new Vector<TransaksiPayment>();
    long oid = FRMQueryString.requestLong(this.req, "oid");
    this.req.setAttribute("oid", oid);
    if (oid == 0) {
      this.tabungan = new Tabungan();
      String tgl = FRMQueryString.requestString(this.req, FRM_FIELD_TGL);
      this.tabungan.setOID(FRMQueryString.requestLong(this.req, FRM_FIELD_MEMBER_ID));
      this.tabungan.setTanggal((tgl.equals("") || tgl == null) ? new Date() : Master.string2Date(tgl));
      this.tabungan.setNoTabungan(FRMQueryString.requestString(this.req, FRM_FIELD_NO_TABUNGAN));
      this.tabungan.setNama(FRMQueryString.requestString(this.req, FRM_FIELD_NAMA));
      this.tabungan.setAlamat(FRMQueryString.requestString(this.req, FRM_FIELD_ALAMAT));
      this.tabungan.setAssignContactTabunganId(FRMQueryString.requestLong(this.req, FRM_FIELD_ASSIGN_CONTACT_TABUNGAN_ID));
      String[] simpananId = this.req.getParameterValues(FRM_FIELD_SIMPANAN_ID);
      String[] simpananNama = this.req.getParameterValues(FRM_FIELD_SIMPANAN_NAMA);
      String[] jenisTransaksi = this.req.getParameterValues(FRM_FIELD_JENIS_TRANSAKSI);
      String[] saldo = this.req.getParameterValues(FRM_FIELD_SALDO);
      String[] saldoAwal = this.req.getParameterValues(FRM_FIELD_SALDO_AWAL);
      String[] paymentType = this.req.getParameterValues(FRM_FIELD_PAYMENT_TYPE);
      String[] paymentNominal = this.req.getParameterValues(FRM_FIELD_PAYMENT_NOMINAL);
      String[] jenisTransaksiDenda = this.req.getParameterValues(FRM_FIELD_JENIS_TRANSAKSI_DENDA);
      String[] denda = this.req.getParameterValues(FRM_FIELD_DENDA);
      String[] dendaState = this.req.getParameterValues(FRM_FIELD_DENDA_STATE);
      //
      String[] paymentTabungan = this.req.getParameterValues(FRM_FIELD_ID_SIMPANAN_PAYMENT);
      String[] cardName = this.req.getParameterValues(FRM_FIELD_CARD_NAME);
      String[] cardNo = this.req.getParameterValues(FRM_FIELD_CARD_NUMBER);
      String[] bankName = this.req.getParameterValues(FRM_FIELD_BANK_NAME);
      String[] validateDate = this.req.getParameterValues(FRM_FIELD_VALIDATE_DATE);
      //ADDED BY DEWOK 20180827 FOR PENUTUPAN TABUNGAN
      String alasanTutup = this.req.getParameter(FRM_FIELD_ALASAN_TUTUP);
      //ADDED BY DEWOK 20190123 FOR KETERANGAN TRANSAKSI
      String keteranganTransaksi = this.req.getParameter(FRM_FIELD_KETERANGAN);
      
      if (paymentNominal != null) {
          
        //ADDED BY DEWOK 20180827 FOR PENUTUPAN TABUNGAN
        this.tabungan.setAlasanTutup(alasanTutup);
        //ADDED BY DEWOK 20190123 FOR KETERANGAN TRANSAKSI
        this.keterangan = (keteranganTransaksi == null) ? "" : keteranganTransaksi;
        
        for (int i = 0; i < paymentType.length; i++) {
          if (!paymentType[i].equals("") && paymentType[i] != null) {
            TransaksiPayment tp = new TransaksiPayment();
            tp.setPaymentSystemId(Long.valueOf(paymentType[i]));
            tp.setJumlah(Double.valueOf(paymentNominal[i]));
            tp.setCardName(cardName[i]);
            tp.setCardNo(cardNo[i]);
            tp.setBankName(bankName[i]);
            tp.setValidateDate(Formater.formatDate(validateDate[i], "yyyy-MM-dd"));
            paymentSystem.add(tp);
          }
        }
        
        //added by dewok 20190117 for payment type tabungan
        if (paymentTabungan != null) {
            for (int i = 0; i < paymentTabungan.length; i++) {
                this.listIdSimpananPayment = new ArrayList<Long>();
                this.listNominalPenarikanPayment = new ArrayList<Double>();
                if (paymentTabungan[i].isEmpty() || paymentTabungan[i].equals("0")) {
                    continue;
                }
                this.listIdSimpananPayment.add(Long.valueOf(paymentTabungan[i]));
                this.listNominalPenarikanPayment.add(Double.valueOf(paymentNominal[i]));
            }
        }

        if (simpananId != null) {
          for (int i = 0; i < simpananId.length; i++) {
            this.tabungan.addSimpanan(
                    Long.valueOf(simpananId[i]),
                    tabungan.getNoTabungan(),//simpananNama[i], updated by dewok 20181218
                    simpananNama[i],
                    Long.valueOf(jenisTransaksi[i]),
                    (saldoAwal != null && saldoAwal.length > 0) ? Double.valueOf(saldoAwal[i]) : 0,
                    Double.valueOf(saldo[i])
            );
            if (dendaState != null && Boolean.parseBoolean(dendaState[i])) {
              this.tabungan.addSimpanan(
                      Long.valueOf(simpananId[i]),
                      tabungan.getNoTabungan(),//simpananNama[i], updated by dewok 20181218
                      simpananNama[i],
                      Long.valueOf(jenisTransaksiDenda[i]),
                      (saldoAwal != null && saldoAwal.length > 0) ? Double.valueOf(saldoAwal[i]) : 0,
                      Double.valueOf(denda[i])
              );
            }
          }
        }
      }
    } else {
      try {
        this.tabungan = new Tabungan();
        Transaksi trx = PstTransaksi.fetchExc(oid);
        ContactList cl = PstContactList.fetchExc(trx.getIdAnggota());

        this.tabungan.setOID(cl.getOID());
        this.tabungan.setTanggal(trx.getTanggalTransaksi());
        this.tabungan.setNoTabungan(PstTransaksi.getNoAnggotaByTransaksiId(oid));
        this.tabungan.setNama(cl.getPersonName());
        this.tabungan.setAlamat(cl.getHomeAddr());
        Vector<DetailTransaksi> dtrxs = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + "=" + trx.getOID(), "");
        for (DetailTransaksi dtrx : dtrxs) {
          DataTabungan dt = PstDataTabungan.fetchExc(dtrx.getIdSimpanan());
          MasterTabungan mt = new MasterTabungan();
          JenisSimpanan js = new JenisSimpanan();
          try {
            AssignContact act = new AssignContact();
            act = PstAssignContact.fetchExc(dt.getAssignTabunganId());
            mt = PstMasterTabungan.fetchExc(act.getMasterTabunganId());
            Vector<AssignTabungan> at = PstAssignTabungan.list(0, 1, PstAssignTabungan.fieldNames[PstAssignContact.FLD_MASTER_TABUNGAN_ID] + "=" + mt.getOID(), "");
            js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
          } catch (Exception e) {

          }
          this.tabungan.addSimpanan(
                  dtrx.getOID(),
                  mt.getNamaTabungan(),
                  js.getNamaSimpanan(),
                  dtrx.getJenisTransaksiId(),
                  0,
                  dtrx.getKredit() - dtrx.getDebet()
          );
        }
      } catch (DBException ex) {
        Logger.getLogger(HTTPTabungan.class.getName()).log(Level.SEVERE, null, ex);
      } catch (com.dimata.common.db.DBException ex) {
        Logger.getLogger(HTTPTabungan.class.getName()).log(Level.SEVERE, null, ex);
      }
    }
    this.req.setAttribute("tabungan", this.tabungan);
  }

  /**
   * @return the assignContactTabunganId
   */
  public long getAssignContactTabunganId() {
    return assignContactTabunganId;
  }

  /**
   * @param assignContactTabunganId the assignContactTabunganId to set
   */
  public void setAssignContactTabunganId(long assignContactTabunganId) {
    this.assignContactTabunganId = assignContactTabunganId;
  }
}
