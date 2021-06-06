/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.sedana.ajax.transaksi;

import com.dimata.sedana.entity.tabungan.JenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import com.dimata.sedana.session.SessMutasi;
import com.dimata.util.Command;
import java.io.IOException;
import java.util.HashMap;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Regen
 */
public class AjaxMutasi extends SessMutasi {
  
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

  @Override
  protected HashMap<Integer, String> pageMapping() {
    HashMap<Integer, String> page = new HashMap<Integer, String>();
    page.put(Command.NONE, uri + "mutasi.jsp");
    page.put(Command.LOAD, uri + "mutasi.jsp");
    return page;
  }

  @Override
  protected void executeMethod() {
    switch(dataFor) {
      default:
        none();
    }
  }
  
  private void none() {
    this.isJSON = false;
    this.redirect = false;
    
    this.req.setAttribute("dataFor", Command.LOAD);
  }

}
