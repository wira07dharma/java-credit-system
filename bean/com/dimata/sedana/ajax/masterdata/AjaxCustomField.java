/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.masterdata;

import com.dimata.harisma.entity.employee.EmpCustomField;
import com.dimata.harisma.entity.employee.PstEmpCustomField;
import com.dimata.harisma.entity.masterdata.CustomFieldDataList;
import com.dimata.harisma.entity.masterdata.CustomFieldMaster;
import com.dimata.harisma.entity.masterdata.PstCustomFieldDataList;
import com.dimata.harisma.entity.masterdata.PstCustomFieldMaster;
import com.dimata.harisma.form.masterdata.CtrlCustomFieldDataList;
import com.dimata.harisma.form.masterdata.FrmCustomFieldDataList;
import com.dimata.harisma.form.masterdata.FrmCustomFieldMaster;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.kredit.Agunan;
import com.dimata.util.Command;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Gunadi
 */
public class AjaxCustomField extends HttpServlet {

    //OBJECT
    private JSONObject jSONObject = new JSONObject();
    private JSONArray jSONArray = new JSONArray();
    //LONG
    private long oidCustomField = 0;
    private long oidDataList = 0;
    //STRING
    private String dataFor = "";
    private String message = "";
    private String html = "";
    private String map_simpanan = "";
    private String value = "";
    //INT
    private int iCommand = 0;
    private int iErrCode = 0;
    private int modul = 0;
    private int field = 0;
    
    //DOUBLE

    //HISTORY
    private long userId = 0;
    private String userName = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //OBJECT
        this.jSONObject = new JSONObject();
        this.jSONArray = new JSONArray();
        
        this.dataFor = FRMQueryString.requestString(request, "dataFor");
        
        this.oidCustomField = FRMQueryString.requestLong(request, "FRM_FIELD_CUSTOM_FIELD_ID");
        this.oidDataList = FRMQueryString.requestLong(request, "FRM_FIELD_CUSTOM_FIELD_DATA_LIST_ID");
        
        this.modul = FRMQueryString.requestInt(request, "modul");
        this.field = FRMQueryString.requestInt(request, "field");
        this.value = FRMQueryString.requestString(request, "value");
        this.iCommand = FRMQueryString.requestCommand(request);
        this.iErrCode = 0;
        //DOUBLE

        //HISTORY
        this.userId = 0;
        this.userName = "";
        if (this.iCommand != 0){
            switch (this.iCommand){
                case Command.LIST:
                    if (this.dataFor.equals("getTableDataList")){
                        this.html = getTableDataList();
                    } else {
                        this.html = getCustomField(request);
                    }
                    break;
                case Command.SAVE:
                    this.html = getDataList(request);
                    break;
                case Command.DELETE:
                    if (this.dataFor.equals("deletedetail")){
                        deleteDetail(request);
                    }
                    break;
            }
        } else {
            switch (this.modul) {
                case 99:
                    break;
                case PstCustomFieldMaster.MODUL_AGUNAN:
                    //history
                    agunan(request);
                    break;
            }
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
    
    public void deleteDetail(HttpServletRequest request){
        CtrlCustomFieldDataList ctrlCustomFieldDataList = new CtrlCustomFieldDataList(request);
        this.iErrCode = ctrlCustomFieldDataList.action(this.iCommand, this.oidDataList);
    }

    public String fieldSelect(){
        String returnData = "<select class='form-control' name='"+FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_MODUL_FIELD]+"'>";
                    for(int ig2=0;ig2< PstCustomFieldMaster.namaField[this.modul].length; ig2++){
                        returnData+="<option value='"+ig2+"'>"+PstCustomFieldMaster.namaField[this.modul][ig2]+"</option>";
                    }
                returnData+="</select>";
        
        return returnData;
    }

    public void agunan(HttpServletRequest request) {
        switch (this.field) {
            case PstCustomFieldMaster.FIELD_TIPE_AGUNAN:
                this.html = tipeAgunan();
                break;
            default:
                this.html = "";
                break;
        }
    }
    
    public String getDataList(HttpServletRequest request){
        
        String caption = FRMQueryString.requestString(request, FrmCustomFieldDataList.fieldNames[FrmCustomFieldDataList.FRM_FIELD_DATA_LIST_CAPTION]);
        String value = FRMQueryString.requestString(request, FrmCustomFieldDataList.fieldNames[FrmCustomFieldDataList.FRM_FIELD_DATA_LIST_VALUE]);
        String returnData = "";
        
        if (this.oidCustomField != 0){
            CustomFieldDataList customFieldDataList = new CustomFieldDataList();
            customFieldDataList.setCustomFieldId(this.oidCustomField);
            customFieldDataList.setDataListCaption(caption);
            customFieldDataList.setDataListValue(value);
            try {
                if (this.oidDataList != 0){
                    customFieldDataList.setOID(this.oidDataList);
                    this.oidDataList = PstCustomFieldDataList.updateExc(customFieldDataList);
                } else {
                    this.oidDataList = PstCustomFieldDataList.insertExc(customFieldDataList);
                }
               
            } catch (Exception exc){
                System.out.println("Exception save data list "+exc.toString());
            }
        }
        
        
        return returnData;
    }
    
    public String getTableDataList(){
        String returnData="<table id='tb_data_list' class='table-bordered table table-striped' style='width: 100%'>"
                            + "<tbody><tr><td>Caption</td><td>Nilai</td><td>Aksi</td></tr>";
                            String whereDataList = PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_CUSTOM_FIELD_ID]
                                                    + " = "+this.oidCustomField;
                              Vector listDataList = PstCustomFieldDataList.list(0, 0, whereDataList, "");
                              if (listDataList.size()>0){
                                  for (int i=0; i<listDataList.size();i++){
                                      CustomFieldDataList customFieldDataList = (CustomFieldDataList) listDataList.get(i);
                                          returnData+= "<tr>"
                                              + "<td>"+customFieldDataList.getDataListCaption()+"</td>"
                                              + "<td>"+customFieldDataList.getDataListValue()+"</td>"
                                              + "<td>"
                                                  + "<button type='button' class='btn btn-xs btn-warning btn-edit-datalist' data-oid='"+customFieldDataList.getOID()+"' data-caption='"+customFieldDataList.getDataListCaption()+"' data-value='"+customFieldDataList.getDataListValue()+"'><i class='fa fa-pencil'></i></button> &nbsp;"
                                                  + "<button type='button' class='btn btn-xs btn-danger btn-delete-datalist' data-oid='"+customFieldDataList.getOID()+"'><i class='fa fa-times-circle'></i></button>"
                                              + "</td>"
                                          + "</tr>";
                                  }
                              }
               returnData += "</tbody>"
                       + "</table>"
                       + "<div class='pull-right'>";
                            if (this.oidCustomField != 0){
                                returnData += "<button type='button' class='btn btn-sm btn-success btn-add-detail'> &nbsp; Tambah Data Pilihan</button>";
                            } else {
                                returnData += "<strong>*) Tombol tambah akan muncul setelah form disimpan</strong>";
                            }
                returnData += "</div>";
        
        return returnData;
    }
    
    public String getCustomField(HttpServletRequest request){
        long oid = FRMQueryString.requestLong(request, "oid");
        String returnData = "";
        String where = PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_MODUL]
                        + "='"+this.modul+"' AND "+PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_MODUL_FIELD]
                        + "='"+this.field+"' AND "+PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_MODUL_FIELD_VALUE]
                        + "='"+this.value+"'";
        Vector listCustom = PstCustomFieldMaster.list(0, 0, where, "");
        String valueInput = "";
        int countInput3 = 0;
        int countInput6 = 0;
        int countInput7 = 0;
        for(int c=0; c<listCustom.size(); c++){
            CustomFieldMaster custom = (CustomFieldMaster)listCustom.get(c);
            String whereEmpCustom = "CUSTOM_FIELD_ID="+custom.getOID()+" AND EMPLOYEE_ID="+oid;
            Vector listEmpCustom = PstEmpCustomField.list(0, 0, whereEmpCustom, "");
            String[] valueList = new String[listEmpCustom.size()];
            if (listEmpCustom != null && listEmpCustom.size()>0){
                for(int e=0; e<listEmpCustom.size(); e++){
                    EmpCustomField empCust = (EmpCustomField)listEmpCustom.get(e);
                    switch(custom.getFieldType()){
                        case 0: valueInput = empCust.getDataText(); valueList[e]=""+empCust.getDataText();break;
                        case 1: valueInput = ""+empCust.getDataNumber(); valueList[e]=""+empCust.getDataNumber();break;
                        case 2: valueInput = ""+empCust.getDataNumber(); valueList[e]=""+empCust.getDataNumber();break;
                        case 3: valueInput = ""+empCust.getDataDate(); valueList[e]=""+empCust.getDataDate();break;
                        case 4: valueInput = ""+empCust.getDataDate(); valueList[e]=""+empCust.getDataDate();break;
                    }
                }
            } else {
                valueInput = "";
            }
            String input = "";

            switch(custom.getInputType()){
                case 0: input = "<input type=\"text\" class=\"form-control\" name=\"input0\" size=\"50\" value=\""+valueInput+"\" />";
                        input += "<input type=\"hidden\" name=\"hidden0\" value=\""+custom.getOID()+"\" />";
                        input += "<input type=\"hidden\" name=\"data_type0\" value=\""+custom.getFieldType()+"\" />";
                        break;
                case 1: input = "<textarea class=\"form-control\" name=\"input1\">"+valueInput+"</textarea>";
                        input += "<input type=\"hidden\" name=\"hidden1\" value=\""+custom.getOID()+"\" />";
                        input += "<input type=\"hidden\" name=\"data_type1\" value=\""+custom.getFieldType()+"\" />";
                        break;
                case 2: input = "<select class=\"form-control\" name=\"input2\">";
                                String whereInput2 = PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_CUSTOM_FIELD_ID]
                                                    + " = "+custom.getOID();
                                Vector listData2 = PstCustomFieldDataList.list(0, 0, whereInput2, "");
                                if (listData2.size() > 0){
                                    for (int i=0; i < listData2.size(); i++){
                                        CustomFieldDataList customFieldDataList = (CustomFieldDataList) listData2.get(i);
                                        if (valueInput.equals(customFieldDataList.getDataListValue())){
                                            input += "<option value='"+customFieldDataList.getDataListValue()+"' selected>"+customFieldDataList.getDataListCaption()+"</option>";
                                        } else {
                                            input += "<option value='"+customFieldDataList.getDataListValue()+"'>"+customFieldDataList.getDataListCaption()+"</option>";
                                        }
                                    }
                                }
                        input+= "</select>";
                        input += "<input type=\"hidden\" name=\"hidden2\" value=\""+custom.getOID()+"\" />";
                        input += "<input type=\"hidden\" name=\"data_type2\" value=\""+custom.getFieldType()+"\" />";
                        break;
                case 3: input = "<div class=custom-input3>"
                                + "<select class=\"form-control select-input3 select2\" name=\"input3_"+countInput3+"\" multiple>";
                                String whereInput3 = PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_CUSTOM_FIELD_ID]
                                                    + " = "+custom.getOID();
                                Vector listData3 = PstCustomFieldDataList.list(0, 0, whereInput3, "");
                                if (listData3.size() > 0){
                                    for (int i=0; i < listData3.size(); i++){
                                        String selected = "";
                                        CustomFieldDataList customFieldDataList = (CustomFieldDataList) listData3.get(i);
                                        if (valueList.length > 0 && valueList != null){
                                            for (int x=0; x < valueList.length; x++){
                                                if (valueList[x].equals(customFieldDataList.getDataListValue())){
                                                    selected = "selected";
                                                    break;
                                                } else {
                                                        selected="";
                                                }
                                            }
                                        }
                                        input += "<option value='"+customFieldDataList.getDataListValue()+"' data-hidden3='"+custom.getOID()+"' data-type3='"+custom.getFieldType()+"' "+selected+">"+customFieldDataList.getDataListCaption()+"</option>";
                                    }
                                }
                        input+= "</select></div>";
                        input += "<input type=\"hidden\" name=\"hidden3\" value=\""+custom.getOID()+"\" />";
                        input += "<input type=\"hidden\" name=\"data_type3\" value=\""+custom.getFieldType()+"\" />";
                        countInput3++;
                        break;
                case 4: input = "<input type=\"text\" class=\"form-control\" class=\"mydate\" name=\"input4\" value=\""+valueInput+"\" />";
                        
                        input += "<input type=\"hidden\" name=\"hidden4\" value=\""+custom.getOID()+"\" />";
                        input += "<input type=\"hidden\" name=\"data_type4\" value=\""+custom.getFieldType()+"\" />";
                        break;
                case 5: input = "<input type=\"text\" class=\"form-control\" class=\"mydate\" name=\"input5\" />";
                        input += "<input type=\"hidden\" name=\"hidden5\" value=\""+custom.getOID()+"\" />";
                        input += "<input type=\"hidden\" name=\"data_type5\" value=\""+custom.getFieldType()+"\" />";
                        break;
                case 6: String whereInput6 = PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_CUSTOM_FIELD_ID]
                                            + " = "+custom.getOID();
                        Vector listData6 = PstCustomFieldDataList.list(0, 0, whereInput6, "");
                        if (listData6.size() > 0){
                            for (int i=0; i < listData6.size(); i++){
                                String checked = "";
                                CustomFieldDataList customFieldDataList = (CustomFieldDataList) listData6.get(i);
                                if (valueList.length > 0 && valueList != null){
                                    for (int x=0; x < valueList.length; x++){
                                        if (valueList[x].equals(customFieldDataList.getDataListValue())){
                                            checked = "checked";
                                            break;
                                        } else {
                                                checked="";
                                        }
                                    }
                                }
                                input += "<label class=\"checkbox-inline\">"
                                        + "<input name=\"input6_"+countInput6+"\" value=\""+customFieldDataList.getDataListValue()+"\" type=\"checkbox\" "+checked+">"
                                        + "</label>";
                            }
                        }
                        input += "<input type=\"hidden\" name=\"hidden6\" value=\""+custom.getOID()+"\" />";
                        input += "<input type=\"hidden\" name=\"data_type6\" value=\""+custom.getFieldType()+"\" />";
                        countInput6++;
                        break;
                case 7: String whereInput7 = PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_CUSTOM_FIELD_ID]
                                            + " = "+custom.getOID();
                        Vector listData7 = PstCustomFieldDataList.list(0, 0, whereInput7, "");
                        if (listData7.size() > 0){
                            for (int i=0; i < listData7.size(); i++){
                                CustomFieldDataList customFieldDataList = (CustomFieldDataList) listData7.get(i);
                                if (valueInput.equals(customFieldDataList.getDataListValue())){
                                    input += "<label class=\"radio-inline\">"
                                            + "<input name=\"input7_"+countInput7+"\" value=\""+customFieldDataList.getDataListValue()+"\" style=\"display: inline\" checked type=\"radio\">"
                                            + customFieldDataList.getDataListCaption()
                                            + "</label>";
                                } else {
                                    input += "<label class=\"radio-inline\">"
                                            + "<input name=\"input7_"+countInput7+"\" value=\""+customFieldDataList.getDataListValue()+"\" style=\"display: inline\" type=\"radio\">"
                                            + customFieldDataList.getDataListCaption()
                                            + "</label>";
                                }
                            }
                        }
                        input += "<input type=\"hidden\" name=\"hidden7\" value=\""+custom.getOID()+"\" />";
                        input += "<input type=\"hidden\" name=\"data_type7\" value=\""+custom.getFieldType()+"\" />";
                        countInput7++;
                        break;
            }
            returnData+= "<div class=\"form-group\">"
                    + "<label class=\"control-label col-sm-2\">"+custom.getFieldName()+"</label>"
                    + "<div class=\"col-sm-4\">"
                        +input
                    +"</div>"
                    + "</div>";

        }
        return returnData;
    }
    
    public String tipeAgunan(){
        String selected="";
        String returnData = "<label class=\"control-label col-sm-4\">Tipe Agunan</label>"
                + "<div class=\"col-sm-8\">"
                    + "<select class='form-control' id='selectField' name='"+FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_MODUL_FIELD_VALUE]+"'"
                    + "data-modul='"+PstCustomFieldMaster.MODUL_AGUNAN+"' data-field='"+PstCustomFieldMaster.FIELD_TIPE_AGUNAN+"'>";
                        for (int i=0; i < Agunan.TIPE_AGUNAN.size();){
                            HashMap<String, String> type = Agunan.TIPE_AGUNAN.get(++i);
                            if (this.value.equals(""+i)){
                                selected = "selected";
                            } else {
                                selected = "";
                            }
                            returnData+="<option style='padding: 5px' value='"+i+"' "+selected+">"+type.get("TITLE")+"</option>";
                        }
                        returnData+="</select>"
                                + "</div>";
        
        return returnData;
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
