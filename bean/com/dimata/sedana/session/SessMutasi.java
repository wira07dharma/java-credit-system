/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.sedana.session;

import com.dimata.aiso.entity.admin.AppUser;
import com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisSimpanan;
import com.dimata.aiso.session.admin.SessUserSession;
import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.ajax.transaksi.AjaxSetoran;
import com.dimata.sedana.entity.masterdata.CashTeller;
import com.dimata.sedana.entity.masterdata.PstCashTeller;
import com.dimata.sedana.entity.tabungan.DetailTransaksi;
import com.dimata.sedana.entity.tabungan.MutasiParam;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.sedana.form.tabungan.FrmMutasi;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
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
public abstract class SessMutasi extends HttpServlet {
  
  protected HttpServletRequest req = null;
  protected HttpServletResponse res = null;
  protected String username = null;
  protected int dataFor = 0;
  protected long userOID = 0;
  protected long TelerId = 0;
  protected String JSON = "";
  protected boolean isJSON = false;
  protected boolean redirect = false;
  protected boolean SessionError = false;
  protected MutasiParam mutasiParam = null;

  protected static final String uri = "/transaksi/tabungan/";
  protected abstract HashMap<Integer, String> pageMapping();
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
    sessionStarter(request, response);
    if (!this.SessionError && !this.redirect) {
      saveRequest();
      execute();
    }
  }

  private String baseUrl(String uri) {
    String scheme = this.req.getScheme() + "://";
    String serverName = this.req.getServerName();
    String serverPort = (this.req.getServerPort() == 80) ? "" : ":" + this.req.getServerPort();
    String contextPath = this.req.getContextPath();
    return scheme + serverName + serverPort + contextPath + "/" + uri;
  }

  private void sessionStarter(HttpServletRequest request, HttpServletResponse response) throws IOException {
    this.res = response;
    this.req = request;
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
      } catch (IOException ex) {
        Logger.getLogger(AjaxSetoran.class.getName()).log(Level.SEVERE, null, ex);
      }
    } else if (userSession.isLoggedIn()) {
      AppUser appUser = userSession.getAppUser();
      this.username = appUser.getLoginId();
      this.userOID = appUser.getOID();
      this.dataFor = FRMQueryString.requestInt(req, "cmd");
      Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
      if (open.size() < 1) {
        this.SessionError = true;
        String redirectUrl = baseUrl("/open_cashier.jsp?redir=" + baseUrl("/masterdata/transaksi/data_tabungan.jsp"));
        res.sendRedirect(redirectUrl);
      } else {
        this.TelerId = open.get(0).getOID();
      }
    }
  }
  
  private void clear() {
    this.JSON = "";
    this.isJSON = false;
    this.redirect = false;
    this.SessionError = false;
  }

  private void execute() {
    this.clear();
    this.executeMethod();
    if(!this.redirect) {
      if (this.isJSON) {
        try {
          this.res.getWriter().print(this.JSON);
        } catch (IOException iOException) {
          iOException.printStackTrace();
        }
      } else {
        try {
          HashMap<Integer, String> pages = this.pageMapping();
          String jspPath = pages.get(this.dataFor);
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

  private void saveRequest() {
    FrmMutasi frmMutasi = new FrmMutasi(req);
    this.mutasiParam = frmMutasi.getMutasiParam();
    this.req.setAttribute("mutasi", this.mutasiParam);
  }
}
