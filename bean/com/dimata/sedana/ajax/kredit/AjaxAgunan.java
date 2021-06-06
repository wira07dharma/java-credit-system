/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.kredit;

import com.dimata.harisma.entity.employee.PstEmpCustomField;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.kredit.Agunan;
import com.dimata.sedana.entity.kredit.PstAgunanMapping;
import com.dimata.sedana.form.kredit.CtrlAgunan;
import com.dimata.util.Command;
import java.io.IOException;
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
public class AjaxAgunan extends HttpServlet {

    //OBJECT
    private JSONObject jSONObject = new JSONObject();
    private JSONArray jSONArray = new JSONArray();
    //LONG
    private long oid = 0;
    private long oidPinjaman = 0;
    private long oidAnggota = 0;
    //STRING
    private String dataFor = "";
    private String message = "";
    
    //INT
    private int iCommand = 0;
    private int iErrCode = 0;
    
    //DOUBLE
    private double prosentasePinjaman = 0;
    
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
        //STRING
        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.message = "";
        //INT
        this.iCommand = FRMQueryString.requestCommand(request);
        this.iErrCode = 0;
        //DOUBLE
        this.prosentasePinjaman = FRMQueryString.requestDouble(request, "SEND_PROSENTASE_PINJAMAN");
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

            this.jSONObject.put("FRM_FIELD_HTML", this);
            this.jSONObject.put("SEND_ERROR_CODE", "" + this.iErrCode);
            this.jSONObject.put("SEND_MESSAGE", "" + this.message);

        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }

        response.getWriter().print(this.jSONObject);
    }

    public void commandSave(HttpServletRequest request) {
        if (this.dataFor.equals("saveAgunan")) {
            saveAgunan(request);
        }
    }

    public void saveAgunan(HttpServletRequest request) {
        Agunan agunan = new Agunan();
        CtrlAgunan ctrlAgunan = new CtrlAgunan(request);
        ctrlAgunan.action(iCommand, oid, oidAnggota, oidPinjaman, prosentasePinjaman);
        agunan = ctrlAgunan.getAgunan();
        long oidAgunan = agunan.getOID();
        PstEmpCustomField.saveCustomField(request, oidAgunan);
        this.message = ctrlAgunan.getMessage();
    }

    public void commandDelete(HttpServletRequest request) {
        if (this.dataFor.equals("deleteAgunan")) {
            deleteAgunan(request);
        }
    }

    public void deleteAgunan(HttpServletRequest request) {
        try {
            PstAgunanMapping.deleteExc(oid);
            this.message = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
        } catch (DBException ex) {
            this.iErrCode = 1;
            this.message = ex.getMessage();
        }
    }

    public void commandList(HttpServletRequest request, HttpServletResponse response) {
        
    }

    public void commandNone(HttpServletRequest request) {
        
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
