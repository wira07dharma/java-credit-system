/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.ajax.masterdata;

import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.posbo.entity.masterdata.PstSales;
import com.dimata.posbo.entity.masterdata.Sales;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.services.WebServices;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;

/**
 *
 * @author IanRizky
 */
public class AjaxSales extends HttpServlet {

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
    private JSONArray jsonArraySales = new JSONArray();
    private JSONArray jsonArrayLocation = new JSONArray();
    private JSONArray jsonArrayEmployee = new JSONArray();

    //LONG
    private long oid = 0;
    private long oidReturn = 0;

    //STRING
    private String dataFor = "";
    private String oidDelete = "";
    private String approot = "";
    private String htmlReturn = "";
    private String message = "";
    private String posApiUrl = "";

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
        this.oid = FRMQueryString.requestLong(request, "FRM_FIELD_OID");

        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.oidDelete = FRMQueryString.requestString(request, "FRM_FIELD_OID_DELETE");
        this.approot = FRMQueryString.requestString(request, "FRM_FIELD_APPROOT");
        this.htmlReturn = "";
        this.message = "";
        this.posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");

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
        this.jsonArraySales = new JSONArray();

        switch (this.iCommand) {
            case Command.SAVE:
                //history
                //commandSave(request);
                break;

            case Command.DELETE:
                //commandDelete(request);
                break;

            case Command.LIST:
                commandList(request, response);
                break;

            default:
                commandNone(request);
                break;
        }

        try {
            this.jSONObject.put("FRM_FIELD_HTML", this.htmlReturn);
            this.jSONObject.put("RETURN_DATA_SALES", this.jsonArraySales);
            this.jSONObject.put("RETURN_DATA_EMPLOYEE", this.jsonArrayEmployee);
            this.jSONObject.put("RETURN_DATA_LOCATION", this.jsonArrayLocation);
            this.jSONObject.put("RETURN_MESSAGE", this.message);
            this.jSONObject.put("RETURN_ERROR_CODE", "" + this.iErrCode);

        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }
        response.getWriter().print(this.jSONObject);
    }

    public void commandNone(HttpServletRequest request) {
        if (this.dataFor.equals("getDataSales")) {
            getDataSales(request);
        } 
    }

    public void commandList(HttpServletRequest request, HttpServletResponse response) {
        if (this.dataFor.equals("listSales")) {
            String[] cols = {
                PstSales.fieldNames[PstSales.FLD_SALES_ID],
                PstSales.fieldNames[PstSales.FLD_CODE],
                PstSales.fieldNames[PstSales.FLD_NAME],
                PstSales.fieldNames[PstSales.FLD_ASSIGN_LOCATION_WAREHOUSE]
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        }
    }

    public JSONObject listDataTables(HttpServletRequest request, HttpServletResponse response, String[] cols, String dataFor, JSONObject result) {
        this.searchTerm = FRMQueryString.requestString(request, "sSearch");
        int amount = 10;
        int start = 0;
        int col = 0;
        String dir = "asc";
        String sStart = request.getParameter("iDisplayStart");
        String sAmount = request.getParameter("iDisplayLength");
        String sCol = request.getParameter("iSortCol_0");
        String sdir = request.getParameter("sSortDir_0");

        if (sStart != null) {
            start = Integer.parseInt(sStart);
            if (start < 0) {
                start = 0;
            }
        }
        if (sAmount != null) {
            amount = Integer.parseInt(sAmount);
            if (amount < 10) {
                amount = 10;
            }
        }
        if (sCol != null) {
            col = Integer.parseInt(sCol);
            if (col < 0) {
                col = 0;
            }
        }
        if (sdir != null) {
            if (!sdir.equals("asc")) {
                dir = "desc";
            }
        }

        String whereClause = "";

        String payload = "{oid: 0, keyword:'" + searchTerm + "',limitStart:" + start + ",recordToGet:" + amount + "}";
        String url = "";
        if (searchTerm.length()>0){
            url = this.posApiUrl+"/master/sales-search/"+searchTerm+"/"+start+"/"+amount+"/"+colName;
        } else {
            url = this.posApiUrl+"/master/sales-search/"+start+"/"+amount+"/"+colName;
        }
        
        JSONObject object = WebServices.getAPI(payload, url);

        String colName = cols[col];
        int total = -1;
        try {
            total = object.getInt("COUNT");
        } catch (Exception exc) {
        }

        this.amount = amount;

        this.colName = colName;
        this.dir = dir;
        this.start = start;
        this.colOrder = col;

        try {
            result = getData(total, request, dataFor, object);
        } catch (Exception ex) {
            //printErrorMessage(ex.getMessage());
        }

        return result;
    }

    public JSONObject getData(int total, HttpServletRequest request, String datafor, JSONObject object) {
        int totalAfterFilter = total;
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();

        String whereClause = "";
        String order = "";

        if (this.colOrder >= 0) {
            order += "" + colName + " " + dir + "";
        }

        try {
            JSONArray arr = object.getJSONArray("DATA");
            for (int i = 0; i < arr.length(); i++) {
                JSONArray ja = new JSONArray();
                try {
                    long oid = arr.getJSONObject(i).getLong(PstSales.fieldNames[PstSales.FLD_SALES_ID]);
                    JSONObject objectLoc = new JSONObject();
                    String location = "-";
                    try {
                        objectLoc = arr.getJSONObject(i).getJSONObject(PstLocation.TBL_P2_LOCATION);
                        location = objectLoc.getString(PstLocation.fieldNames[PstLocation.FLD_NAME]);
                    } catch (Exception exc) {
                    }

                    String salesCode = arr.getJSONObject(i).getString(PstSales.fieldNames[PstSales.FLD_CODE]);
                    ja.put("" + (this.start + i + 1) + ".");
                    ja.put("<a href='#' class='no-sales' data-oid='" + oid + "'>" + salesCode + "</a>");
                    ja.put("" + arr.getJSONObject(i).getString(PstSales.fieldNames[PstSales.FLD_NAME]));
                    ja.put("" + objectLoc.getString(PstLocation.fieldNames[PstLocation.FLD_NAME]));
                    ja.put("<div class='text-center'><button type='button' class='btn btn-xs btn-warning no-sales' data-oid='" + oid + "'>Pilih</button></div>");
                    array.put(ja);
                } catch (Exception exc) {
                }

            }
        } catch (Exception exc) {
        }

        totalAfterFilter = total;
        try {
            result.put("iTotalRecords", total);
            result.put("iTotalDisplayRecords", totalAfterFilter);
            result.put("aaData", array);
        } catch (Exception e) {

        }
        return result;
    }

    public void getDataSales(HttpServletRequest request) {
        message = "";

        String url = this.posApiUrl+"/master/sales-search/"+oid;
//        String payload = "{oid: '" + oid + "', keyword:'" + searchTerm + "',limitStart:" + start + ",recordToGet:" + amount + "}";
//        JSONObject jo = WebServices.getAPI(payload, 0, 0, "", "Sales");
        try {
            JSONObject jo = WebServices.getAPI("",url);
            JSONObject joEmp = jo.optJSONObject(PstEmployee.TBL_HR_EMPLOYEE);
            JSONObject joLoc = jo.optJSONObject(PstLocation.TBL_P2_LOCATION);

            long oidSales = PstSales.syncExc(jo);
            long oidEmployee = PstEmployee.syncExc(jo.optJSONObject(PstEmployee.TBL_HR_EMPLOYEE));
            long oidLocation = PstLocation.syncExc(jo.optJSONObject(PstLocation.TBL_P2_LOCATION));

            jsonArraySales.put(jo);
            jsonArrayEmployee.put(joEmp);
            jsonArrayLocation.put(joLoc);
        } catch (Exception exc){

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
