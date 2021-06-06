/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.ajax.masterdata;

import com.dimata.aiso.entity.admin.AppUser;
import com.dimata.aiso.entity.admin.PstAppUser;
import com.dimata.common.entity.admin.MappingUserGroup;
import com.dimata.common.entity.admin.PstMappingUserGroup;
import com.dimata.common.entity.custom.DataCustom;
import com.dimata.common.entity.custom.PstDataCustom;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.system.PstSystemProperty;
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
public class AjaxUser extends HttpServlet {

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
    private JSONArray jsonArraySalesUser = new JSONArray();
    private JSONArray jsonArrayLocation = new JSONArray();

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
    private String locationName ="";

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
        this.jsonArraySalesUser = new JSONArray();

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
            this.jSONObject.put("RETURN_DATA_SALES_USER", this.jsonArraySalesUser);
            this.jSONObject.put("RETURN_DATA_LOCATION", this.locationName);
            this.jSONObject.put("RETURN_MESSAGE", this.message);
            this.jSONObject.put("RETURN_ERROR_CODE", "" + this.iErrCode);

        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }
        response.getWriter().print(this.jSONObject);
    }

    public void commandNone(HttpServletRequest request) {
        if (this.dataFor.equals("getDataSalesUser")) {
            getDataSalesUser(request);
        }
    }

    public void commandList(HttpServletRequest request, HttpServletResponse response) {
         if (this.dataFor.equals("listSalesUser")) {
            String[] cols = {
                PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME],
                PstAppUser.fieldNames[PstAppUser.FLD_EMAIL],
                PstAppUser.fieldNames[PstAppUser.FLD_EMAIL],
                PstAppUser.fieldNames[PstAppUser.FLD_EMAIL]
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

//        String payload = "{oid: 0, keyword:'" + searchTerm + "',limitStart:" + start + ",recordToGet:" + amount + "}";
//        String url = "";
//        if (searchTerm.length()>0){
//            url = this.posApiUrl+"/master/sales-search/"+searchTerm+"/"+start+"/"+amount+"/"+colName;
//        } else {
//            url = this.posApiUrl+"/master/sales-search/"+start+"/"+amount+"/"+colName;
//        }
//        
//        JSONObject object = WebServices.getAPI(payload, url);
          String url = this.posApiUrl+"/user/sales/6/0";

                  try {
                      JSONObject jo = WebServices.getAPI("",url);
                      JSONArray ja = jo.getJSONArray("DATA");

                      jsonArraySalesUser = ja;

                  } catch (Exception exc){

                  }
          JSONArray jaa = jsonArraySalesUser;

        String colName = cols[col];
        int total = -1;
        try {
          JSONObject objUserGroup  = new JSONObject();
          JSONObject objUser  = new JSONObject();
            for(int i = 0; i  < jaa.length(); i++){
            JSONArray temp = jaa.optJSONArray(i);
            objUserGroup = (JSONObject) temp.get(0);
            objUser = (JSONObject) temp.get(1);

            }
            total = objUser.getInt("COUNT");
        } catch (Exception exc) {
        }

        this.amount = amount;

        this.colName = colName;
        this.dir = dir;
        this.start = start;
        this.colOrder = col;

        try {
            result = getData(total, request, dataFor, jaa);
        } catch (Exception ex) {
            //printErrorMessage(ex.getMessage());
        }

        return result;
    }

    public JSONObject getData(int total, HttpServletRequest request, String datafor, JSONArray ja) {
        int totalAfterFilter = total;
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();

        String whereClause = "";
        String order = "";

        if (this.colOrder >= 0) {
            order += "" + colName + " " + dir + "";
        }

        try {
            AppUser ap =new AppUser();
            MappingUserGroup mg = new MappingUserGroup();
            DataCustom dc = new DataCustom();
            Location loc = new Location();
            for(int i = 0; i  < ja.length(); i++){
            JSONArray temp = ja.optJSONArray(i);
            JSONArray j = new JSONArray();
            JSONObject objUserGroup = (JSONObject) temp.get(0);
            JSONObject objUser = (JSONObject) temp.get(1);
            JSONObject objDataCustom = (JSONObject) temp.get(2);
            PstMappingUserGroup.convertJsonToObject(objUserGroup, mg);
            PstAppUser.convertJsonToObject(objUser, ap);
            PstDataCustom.convertJsonToObject(objDataCustom, dc);
            loc = PstLocation.fetchExc(Long.parseLong(dc.getDataValue()));
            
            j.put("" + (this.start + i + 1) + ".");
            j.put("<a href='#' class='no-sales' data-oid='" + ap.getOID() + "'>" + ap.getFullName() + "</a>");
            j.put("" + ap.getLoginId());
            j.put("" + loc.getName());
            j.put("<div class='text-center'><button type='button' class='btn btn-xs btn-warning no-sales' data-oid='" + ap.getOID() + "'>Pilih</button></div>");
            array.put(j);
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

    public void getDataSalesUser(HttpServletRequest request) {
        message = "";

        String url = this.posApiUrl + "/user/sales/6/" + oid;
        AppUser ap = new AppUser();
        long oidLoc = 0;
        Location loc = new Location();
        try {
            JSONObject jo = WebServices.getAPI("", url);
            JSONArray ja = jo.getJSONArray("DATA");
            JSONObject objUser = new JSONObject();
            JSONObject objDataCustom = new JSONObject();
            for (int i = 0; i < ja.length(); i++) {
                JSONArray temp = ja.optJSONArray(i);
                JSONArray j = new JSONArray();
                JSONObject objUserGroup = (JSONObject) temp.get(0);
                objUser = (JSONObject) temp.get(1);
                objDataCustom = (JSONObject) temp.get(2);
                loc = PstLocation.fetchExc(objDataCustom.getLong(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_VALUE]));
            }

            jsonArraySalesUser.put(objUser);
            locationName = loc.getName();

        } catch (Exception exc) {

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
