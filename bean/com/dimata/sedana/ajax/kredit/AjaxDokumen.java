/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.kredit;

import com.dimata.aiso.entity.masterdata.anggota.EmpRelevantDoc;
import com.dimata.aiso.entity.masterdata.anggota.PstEmpRelevantDoc;
import com.dimata.aiso.form.masterdata.anggota.CtrlEmpRelevantDoc;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.anggota.AnggotaBadanUsaha;
import com.dimata.util.Command;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author dedy_blinda
 */
public class AjaxDokumen extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * 
     */
    
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
    private JSONArray jsonArrayAnggota = new JSONArray();

    //LONG
    private long oid = 0;
    private long oidReturn = 0;
    private long oidKelompok = 0;
    private long oidRelevant = 0;

    //STRING
    private String dataFor = "";
    private String oidDelete = "";
    private String approot = "";
    private String htmlReturn = "";
    private String message = "";

    //BOOLEAN
    private boolean privAdd = false;
    private boolean privUpdate = false;
    private boolean privDelete = false;
    private boolean privView = false;

    //INT
    private int iCommand = 0;
    private int iErrCode = 0;

    private long userId = 0;
    private String userName = "";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
            //LONG
            this.oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
            this.oidReturn = 0;
            this.oidKelompok = 0;

            //STRING
            this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
            this.oidDelete = FRMQueryString.requestString(request, "FRM_FIELD_OID_DELETE");
            this.oidKelompok = FRMQueryString.requestLong(request, "FRM_FIELD_OID_KELOMPOK");
            this.approot = FRMQueryString.requestString(request, "FRM_FIELD_APPROOT");
            this.htmlReturn = "";
            this.message = "";

            //BOOLEAN
            this.privAdd = FRMQueryString.requestBoolean(request, "privadd");
            this.privUpdate = FRMQueryString.requestBoolean(request, "privupdate");
            this.privDelete = FRMQueryString.requestBoolean(request, "privdelete");
            this.privView = FRMQueryString.requestBoolean(request, "privview");

            //INT
            this.iCommand = FRMQueryString.requestCommand(request);
            this.iErrCode = 0;

            //OBJECT
            this.jSONObject = new JSONObject();
            this.jsonArrayAnggota = new JSONArray();

            switch (this.iCommand) {
                case Command.SAVE:
                    //history
                    commandSave(request);
                    break;

                case Command.DELETE:
                    commandDelete(request);
                    break;

                case Command.LIST:
                  //  commandList(request, response);
                    break;

                default:
                    commandNone(request);
                    break;
            }
            try {
                this.jSONObject.put("FRM_FIELD_HTML", this.htmlReturn);
                this.jSONObject.put("RETURN_DATA_ANGGOTA", this.jsonArrayAnggota);
                this.jSONObject.put("RETURN_MESSAGE", this.message);
                this.jSONObject.put("RETURN_ERROR_CODE", "" + this.iErrCode);
                this.jSONObject.put("RETURN_OID_KELOMPOK", "" + this.oidKelompok);

            } catch (JSONException jSONException) {
                jSONException.printStackTrace();
            }
            response.getWriter().print(this.jSONObject);
            
        }
    
        public void commandNone(HttpServletRequest request) {
            if (this.dataFor.equals("getDataAnggota")) {
                getDataRelevantDoc(request);
            } 
        }
    
        public void commandSave(HttpServletRequest request) {
            if (this.dataFor.equals("saveDoc")) {
                saveDoc(request);
            }
        }
        
        public void commandDelete(HttpServletRequest request) {
            if (this.dataFor.equals("deleteDoc")) {
                deletePengurus(request);
            }
        }
        
        public synchronized void deletePengurus(HttpServletRequest request) {
            CtrlEmpRelevantDoc cpk = new CtrlEmpRelevantDoc(request);
            cpk.action(iCommand, oid, oidKelompok);
            message = cpk.getMessage();
            EmpRelevantDoc pk = cpk.getEmpRelevantDoc();
            long idDoc = pk.getOID();
            if (!message.equals(FRMMessage.getMessage(FRMMessage.MSG_DELETED))) {
                iErrCode = 1;
            }
        }
        /*
        public void commandList(HttpServletRequest request, HttpServletResponse response) {
            if (this.dataFor.equals("listNasabah")) {
                String[] cols = {
                    PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                    PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                    PstAnggota.fieldNames[PstAnggota.FLD_SEX],
                    PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_PLACE],
                    PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_DATE],
                    PstAnggota.fieldNames[PstAnggota.FLD_VOCATION_ID],
                    PstAnggota.fieldNames[PstAnggota.FLD_HANDPHONE],
                    PstAnggota.fieldNames[PstAnggota.FLD_EMAIL]
                };
                jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
            } else if (this.dataFor.equals("listKelompok")) {
                String[] cols = {
                    PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA],
                    PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                    PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                    PstAnggota.fieldNames[PstAnggota.FLD_TLP],
                    PstAnggota.fieldNames[PstAnggota.FLD_EMAIL],
                    PstAnggota.fieldNames[PstAnggota.FLD_OFFICE_ADDRESS]
                };
                jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
            } else if (this.dataFor.equals("listIndividu")) {
                String[] cols = {
                    PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                    PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA],
                    PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                    PstAnggota.fieldNames[PstAnggota.FLD_SEX],
                    PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_PLACE],
                    PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_DATE],
                    PstAnggota.fieldNames[PstAnggota.FLD_VOCATION_ID],
                    PstAnggota.fieldNames[PstAnggota.FLD_HANDPHONE],
                    PstAnggota.fieldNames[PstAnggota.FLD_TLP],
                    PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PERMANENT]
                };
                jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
            }
        }
    }*/
        
    public synchronized void saveDoc(HttpServletRequest request) {
        CtrlEmpRelevantDoc ca = new CtrlEmpRelevantDoc(request);
        try {
            ca.action(iCommand, oid, oidKelompok);
            message = ca.getMessage();
        } catch (Exception ex) {
            message = ex.toString();
        }
        if (!message.equals(FRMMessage.getMessage(FRMMessage.MSG_SAVED)) && !message.equals(FRMMessage.getMessage(FRMMessage.MSG_UPDATED))) {
            iErrCode = 1;
        }
    }

    public void getDataRelevantDoc(HttpServletRequest request) {
        message = "";

        EmpRelevantDoc empRelevantDoc = new EmpRelevantDoc();
        try {
            empRelevantDoc = PstEmpRelevantDoc.fetchExc(oid);
        } catch (Exception e) {
            message = e.toString();
        }

        if (message.equals("")) {
            JSONObject jo = new JSONObject();
            try {
                jo.put("anggota_id", "" + empRelevantDoc.getOID());
                jsonArrayAnggota.put(jo);
            } catch (JSONException ex) {
                message = ex.toString();
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
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
     * Handles the HTTP
     * <code>POST</code> method.
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
