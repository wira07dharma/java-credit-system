/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.masterdata;

import com.dimata.aiso.entity.admin.AppUser;
import com.dimata.aiso.session.admin.SessUserSession;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.tabungan.JenisTransaksi;
import com.dimata.sedana.entity.tabungan.JenisTransaksiMapping;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksiMapping;
import com.dimata.sedana.form.tabungan.CtrlJenisTransaksi;
import com.dimata.util.Command;
import java.io.IOException;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
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
public class AjaxJenisTransaksi extends HttpServlet {

  //OBJECT
  private JSONObject jSONObject = new JSONObject();
  private JSONArray jSONArray = new JSONArray();
  //LONG
  private long oid = 0;
  //STRING
  private String dataFor = "";
  private String message = "";
  private String html = "";
  private String map_simpanan = "";
  //INT
  private int iCommand = 0;
  private int iErrCode = 0;
    //DOUBLE

  //HISTORY
  private long userId = 0;
  private String userName = "";

  protected void processRequest(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
    HttpSession session = request.getSession(false);
    if (session != null) {
      long userOID = 0;
      String userName = "";
      String userFullName = "";
      int iCheckMenu = 0;
      int userGroup = 0;
      Cookie[] cookies = request.getCookies();
        String sessionId = "";
        if(cookies !=null){
            for(Cookie cookie : cookies){
                    if(cookie.getName().equals("JSESSIONID")) sessionId = cookie.getValue();
                    //session.putValue(sessionId, userSess);
            }
        }
      SessUserSession userSession = (SessUserSession) session.getValue(sessionId);
      if (userSession == null) {
        userSession = new SessUserSession();
      }
      AppUser appUserInit = new AppUser();
      try {
        appUserInit = userSession.getAppUser();
        userName = appUserInit.getLoginId();
        userOID = appUserInit.getOID();
        userGroup = appUserInit.getGroupUser();
        userFullName = appUserInit.getFullName();
      } catch (Exception exc) {
        appUserInit = new AppUser();
      }
      request.setAttribute("appUserInit", appUserInit);
      request.setAttribute("userName", userName);
      request.setAttribute("userOID", userOID);
      request.setAttribute("userGroup", userGroup);
      request.setAttribute("userFullName", userFullName);
      request.setAttribute("app", "SEDANA");

      //OBJECT
      this.jSONObject = new JSONObject();
      this.jSONArray = new JSONArray();
      //LONG
      this.oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
      //STRING
      this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
      this.message = "";
      this.map_simpanan = FRMQueryString.requestString(request, "SEND_MAP_SIMPANAN");
      //INT
      this.iCommand = FRMQueryString.requestCommand(request);
      this.iErrCode = 0;
        //DOUBLE

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

        this.jSONObject.put("RETURN_HTML", this.html);
        this.jSONObject.put("RETURN_MESSAGE", this.message);
        this.jSONObject.put("RETURN_ERROR_CODE", this.iErrCode);

      } catch (JSONException jSONException) {
        jSONException.printStackTrace();
      }

      response.getWriter().print(this.jSONObject);
    }
  }

  public void commandSave(HttpServletRequest request) {
    if (this.dataFor.equals("saveJenisTransaksi")) {
      saveJenisTransaksi(request);
    }
  }

  public synchronized void saveJenisTransaksi(HttpServletRequest request) {
    CtrlJenisTransaksi ctrlJenisTransaksi = new CtrlJenisTransaksi(request);
    ctrlJenisTransaksi.action(iCommand, oid);
    message = ctrlJenisTransaksi.getMessage();
    JenisTransaksi jenisTransaksi = ctrlJenisTransaksi.getJenisTransaksi();
    long oidJenisTransaksi = jenisTransaksi.getOID();
    //delete mapping
    if (oid != 0) {
      Vector<JenisTransaksiMapping> list = PstJenisTransaksiMapping.list(0, 0, "" + PstJenisTransaksiMapping.fieldNames[PstJenisTransaksiMapping.FLD_JENIS_TRANSAKSI_ID] + " = '" + oidJenisTransaksi + "'", "");
      for (int i = 0; i < list.size(); i++) {
        long oidMapping = list.get(i).getOID();
        try {
          PstJenisTransaksiMapping.deleteExc(oidMapping);
        } catch (DBException ex) {
          message = ex.toString();
        }
      }
    }
    //save mapping
    try {
      this.jSONArray = new JSONArray(this.map_simpanan);
      for (int i = 0; i < jSONArray.length(); i++) {
        JSONObject ms = jSONArray.getJSONObject(i);
        long idSimpanan = ms.getLong("id");
        JenisTransaksiMapping jtm = new JenisTransaksiMapping();
        jtm.setIdJenisSimpanan(idSimpanan);
        jtm.setJenisTransaksiId(oidJenisTransaksi);
        try {
          PstJenisTransaksiMapping.insertExc(jtm);
        } catch (DBException ex) {
          message = ex.toString();
        }
      }
    } catch (JSONException ex) {
      message = ex.toString();
    }

    if (!message.equals(FRMMessage.getMessage(FRMMessage.MSG_SAVED)) && !message.equals(FRMMessage.getMessage(FRMMessage.MSG_UPDATED))) {
      iErrCode = 1;
    }
  }

  public void commandDelete(HttpServletRequest request) {
    if (this.dataFor.equals("deleteJenisTransaksi")) {
      deleteJenisTransaksi(request);
    }
  }

  public synchronized void deleteJenisTransaksi(HttpServletRequest request) {
    Vector<JenisTransaksiMapping> list = PstJenisTransaksiMapping.list(0, 0, "" + PstJenisTransaksiMapping.fieldNames[PstJenisTransaksiMapping.FLD_JENIS_TRANSAKSI_ID] + " = '" + oid + "'", "");
    for (int i = 0; i < list.size(); i++) {
      long oidMapping = list.get(i).getOID();
      try {
        PstJenisTransaksiMapping.deleteExc(oidMapping);
      } catch (DBException ex) {
        message = ex.toString();
      }
    }
    CtrlJenisTransaksi ctrlJenisTransaksi = new CtrlJenisTransaksi(request);
    ctrlJenisTransaksi.action(iCommand, oid);
    message = ctrlJenisTransaksi.getMessage();
  }

  public void commandList(HttpServletRequest request, HttpServletResponse response) {
    if (this.dataFor.equals("")) {

    }
  }

  public void commandNone(HttpServletRequest request) {
    if (this.dataFor.equals("")) {

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
