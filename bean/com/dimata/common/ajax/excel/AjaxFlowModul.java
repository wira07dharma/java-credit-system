/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.ajax.excel;

import com.dimata.common.entity.excel.FlowGroup;
import com.dimata.common.entity.excel.FlowMappingDataList;
import com.dimata.common.entity.excel.FlowModul;
import com.dimata.common.entity.excel.FlowModulMapping;
import com.dimata.common.entity.excel.PstFlowGroup;
import com.dimata.common.entity.excel.PstFlowMappingDataList;
import com.dimata.common.entity.excel.PstFlowModul;
import com.dimata.common.entity.excel.PstFlowModulMapping;
import com.dimata.common.form.excel.CtrlFlowModul;
import com.dimata.common.form.excel.FrmFlowMappingDataList;
import com.dimata.common.form.excel.FrmFlowModulMapping;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.tools.db.MetaData;
import com.dimata.tools.db.MetaDataBuilder;
import com.dimata.util.Command;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.*;
/**
 *
 * @author Gunadi
 */
public class AjaxFlowModul extends HttpServlet {

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
    //LONG
    private long oid = 0;
    //STRING
    private String dataFor = "";
    private String message = "";
    private String html = "";
    private String tabel = "";
    //INT
    private int iCommand = 0;
    private int iErrCode = 0;
    private int jumlah = 0;
    private int jumlahData = 0;
    //DOUBLE

    //HISTORY
    private long userId = 0;
    private String userName = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //OBJECT
        this.jSONObject = new JSONObject();
        this.jSONArray = new JSONArray();
        //LONG
        this.oid = FRMQueryString.requestLong(request, "flow_id");
        //STRING
        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.message = "";
        this.tabel = FRMQueryString.requestString(request, "table");
        //INT
        this.iCommand = FRMQueryString.requestCommand(request);
        this.iErrCode = 0;
        this.jumlah = FRMQueryString.requestInt(request, "jumlah");
        this.jumlahData = FRMQueryString.requestInt(request, "jumlahData");
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

    public void commandSave(HttpServletRequest request) {
        if (this.dataFor.equals("saveDataList")){
            saveDataList(request);
        } else {
            saveFlow(request);
        }
        
    }

    public synchronized void saveFlow(HttpServletRequest request) {
        CtrlFlowModul ctrlFlowModul = new CtrlFlowModul(request);
        ctrlFlowModul.action(iCommand, oid);
        message = ctrlFlowModul.getMessage();
        FlowModul flowModul = ctrlFlowModul.getFlow();
        long oidFlow = flowModul.getOID();
        
        String[] oid = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FLOW_MODUL_MAPPING_ID]);
        String[] field = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FIELD_NAME]);
        String[] dataType = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TYPE]);
        String[] column = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_NAME]);
        //String[] example = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_EXAMPLE]);
        String[] level = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_LEVEL]);
        String[] type = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_TYPE]);
        String[] inpuType = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_INPUT_TYPE]);
        String[] dataTable = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]);
        String[] dataColumn = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]);
        String[] dataVaue = FRMQueryString.requestStringValues(request, FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_VALUE]);
        
        if (oidFlow != 0){
            if (oid.length>0){
                for (int i=0;i<oid.length;i++){
                    try{
                        long oidFlowMapping = Long.valueOf(oid[i]);
                        FlowModulMapping flowModulMapping = new FlowModulMapping();
                        flowModulMapping.setFieldName(field[i]);
                        flowModulMapping.setDataType(Integer.valueOf(dataType[i]));
                        flowModulMapping.setColumnName(column[i]);
                        //flowModulMapping.setDataExample(example[i]);
                        flowModulMapping.setColumnLevel(Integer.valueOf(level[i]));
                        flowModulMapping.setType(Integer.valueOf(type[i]));
                        flowModulMapping.setInputType(Integer.valueOf(inpuType[i]));
                        flowModulMapping.setDataTable(dataTable[i]);
                        flowModulMapping.setDataColumn(dataColumn[i]);
                        flowModulMapping.setDataValue(dataVaue[i]);
                        flowModulMapping.setFlowModulId(oidFlow);
                        
                        if (oidFlowMapping != 0){
                            flowModulMapping.setOID(oidFlowMapping);
                            PstFlowModulMapping.updateExc(flowModulMapping);
                        } else {
                            PstFlowModulMapping.insertExc(flowModulMapping);
                        }
                        
                    } catch (Exception exc){}
                    
                }
            }
        }
    }
    
    public synchronized void saveDataList(HttpServletRequest request) {
        long oidMapping = FRMQueryString.requestLong(request, "FRM_FIELD_OID");
        String[] oidData = FRMQueryString.requestStringValues(request, FrmFlowMappingDataList.fieldNames[FrmFlowMappingDataList.FRM_FIELD_FLOW_MAPPING_DATA_LIST_ID]);
        String[] caption = FRMQueryString.requestStringValues(request, FrmFlowMappingDataList.fieldNames[FrmFlowMappingDataList.FRM_FIELD_DATA_CAPTION]);
        String[] value = FRMQueryString.requestStringValues(request, FrmFlowMappingDataList.fieldNames[FrmFlowMappingDataList.FRM_FIELD_DATA_VALUE]);
        
        if (oidMapping != 0 && caption.length > 0){
            for (int i = 0 ; i < caption.length; i++){
                try {
                    long oidDataList = Long.valueOf(oidData[i]);
                    FlowMappingDataList dataList = new FlowMappingDataList();
                    dataList.setDataCaption(caption[i]);
                    dataList.setDataValue(value[i]);
                    dataList.setFlowMappingId(oidMapping);
                    if(oidDataList != 0){
                        dataList.setOID(oidDataList);
                        PstFlowMappingDataList.updateExc(dataList);
                    } else {
                        PstFlowMappingDataList.insertExc(dataList);
                    }
                    
                    
                } catch (Exception exc){
                    
                }
            }
        }
        
    }

    public void commandDelete(HttpServletRequest request) {
        if (this.dataFor.equals("deleteMapping")) {
            if (this.oid != 0){
                try {
                    PstFlowModulMapping.deleteExc(this.oid);
                } catch (Exception exc){}
            }
        } else if (this.dataFor.equals("deleteDataList")) {
            if (this.oid != 0){
                try {
                    PstFlowMappingDataList.deleteExc(this.oid);
                } catch (Exception exc){}
            }
        }
    }


    public void commandList(HttpServletRequest request, HttpServletResponse response) {
        if (this.dataFor.equals("listFlow")) {
            String[] cols = {
                "FG."+PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_GROUP_ID],
                "FL."+PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_NAME],
                "FL."+PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_TABLE],
                "FL."+PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_LEVEL]
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

        if (whereClause.length() > 0) {
            whereClause += ""
                    + "AND ("
                    + " FG." + PstFlowGroup.fieldNames[PstFlowGroup.FLD_FLOW_GROUP_NAME] + " LIKE '%" + searchTerm + "%' "
                    + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_NAME] + " LIKE '%" + searchTerm + "%' "
                    + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_TABLE] + " LIKE '%" + searchTerm + "%' "
                    + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_LEVEL] + " LIKE '%" + searchTerm + "%' "
                    + ")";
        } else {
            whereClause += " ("
                    + " FG." + PstFlowGroup.fieldNames[PstFlowGroup.FLD_FLOW_GROUP_NAME] + " LIKE '%" + searchTerm + "%' "
                    + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_NAME] + " LIKE '%" + searchTerm + "%' "
                    + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_TABLE] + " LIKE '%" + searchTerm + "%' "
                    + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_LEVEL] + " LIKE '%" + searchTerm + "%' "
                    + ")";
        }

        String colName = cols[col];
        int total = -1;

        total = PstFlowModul.getCountJoinFlowGroup(whereClause);
        

        this.amount = amount;

        this.colName = colName;
        this.dir = dir;
        this.start = start;
        this.colOrder = col;

        try {
            result = getData(total, request, dataFor);
        } catch (Exception ex) {
            System.out.println(ex);
        }

        return result;
    }
    
        public JSONObject getData(int total, HttpServletRequest request, String datafor) {
        int totalAfterFilter = total;
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        FlowModul flowModul = new FlowModul();

        String whereClause = "";
        String order = "";

        if (this.searchTerm == null) {
            whereClause += "";
        } else {
            if (whereClause.length() > 0) {
                whereClause += ""
                        + "AND ("
                        + " FG." + PstFlowGroup.fieldNames[PstFlowGroup.FLD_FLOW_GROUP_NAME] + " LIKE '%" + searchTerm + "%' "
                        + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_NAME] + " LIKE '%" + searchTerm + "%' "
                        + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_TABLE] + " LIKE '%" + searchTerm + "%' "
                        + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_LEVEL] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            } else {
                whereClause += " ("
                        + " FG." + PstFlowGroup.fieldNames[PstFlowGroup.FLD_FLOW_GROUP_NAME] + " LIKE '%" + searchTerm + "%' "
                        + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_NAME] + " LIKE '%" + searchTerm + "%' "
                        + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_TABLE] + " LIKE '%" + searchTerm + "%' "
                        + " OR FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_LEVEL] + " LIKE '%" + searchTerm + "%' "
                        + ")";
            }
        }

        if (this.colOrder >= 0) {
            order += "" + colName + " " + dir + "";
        }

        Vector listData = new Vector(1, 1);
        listData = PstFlowModul.listJoinFlowGroup(start, amount, whereClause, order);
        

        for (int i = 0; i <= listData.size() - 1; i++) {
            JSONArray ja = new JSONArray();
            if (datafor.equals("listFlow")) {
                flowModul = (FlowModul) listData.get(i);
                FlowGroup flowGroup = new FlowGroup();
                try {
                    flowGroup = PstFlowGroup.fetchExc(flowModul.getFlowGroupId());
                } catch (Exception exc) {

                }
                ja.put("" + (this.start + i + 1));
                ja.put("" + flowGroup.getFlowGroupName());
                ja.put("" + flowModul.getFlowModulName());
                ja.put("" + flowModul.getFlowModulTable());
                ja.put("" + flowModul.getFlowLevel());
                String edit = "<button class='btn btn-xs btn-warning btn_edit' data-oid='" + flowModul.getOID() + "'><i class='fa fa-pencil'></i></button>";
                String delete = "<button class='btn btn-xs btn-danger btn_delete' data-oid='" + flowModul.getOID() + "'><i class='fa fa-trash'></i></button>";
                ja.put("<div class='text-center'>"+edit+" "+delete+"</div>");
                array.put(ja);
            } 
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

    public void commandNone(HttpServletRequest request) {
        if (this.dataFor.equals("showTable")){
            try {
                this.html = showTable(this.tabel, request);
            } catch (DBException ex) {
                
            } catch (SQLException ex) {
                
            }
        } else if (this.dataFor.equals("appendTable")) {
            try {
                this.html = getRow(this.jumlah, this.tabel, request);
            } catch (DBException ex) {
                
            } catch (SQLException ex) {
                
            }
        } else if (this.dataFor.equals("getTabelMeta")) {
            try {
                this.html = getAllTabelSelect(this.jumlah, request, "", "","");
            } catch (DBException ex) {
                
            } catch (SQLException ex) {
                
            }
        } else if (this.dataFor.equals("getColumnMeta")) {
            try {
                this.html = getColumnSelect(this.jumlah, this.tabel, request, "","");
            } catch (DBException ex) {
                
            } catch (SQLException ex) {
                
            }
        }  else if (this.dataFor.equals("getDataList")) {
            this.html = getDataList(this.oid, this.jumlah,this.jumlahData);
        }  else if (this.dataFor.equals("appendData")) {
            this.html = getDataRow(this.jumlah);
        }
    }
    
    public String getAllTabelSelect(int jumlah, HttpServletRequest request, String table, String column, String value) throws DBException, SQLException{
        HttpSession session=request.getSession(false);
        Vector listTable = new Vector();
        if(session.getValue("listTable")!=null){
            listTable = (Vector) session.getValue("listTable");
        } else {
            listTable = MetaDataBuilder.getAllTables();
            session.putValue("listTable", listTable);
        }
        
        String returnData = "<div class='col-sm-6'>"
                + "<select class='form-control input-sm selectCol select2' id='selectTable' data-row='"+jumlah+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]+"' width='50%'>"
                                    + "<option value='-1'>Pilih Tabel</option>";
                                    for (int x=0; x < listTable.size();x++){
                                        String tblName = (String) listTable.get(x);
                                        String selected = "";
                                        if (table.equals(tblName)){
                                            selected = "selected";
                                        }
                                        returnData += "<option value='"+tblName+"' "+selected+">"+tblName+"</option>";
                                    }
                    returnData += "</select>"
                            + "</div><div class='col-sm-6'>"
                                + "<div id='colContainer"+jumlah+"'>";
                                    if (table.equals("")){
                            returnData +=  "<select class='form-control input-sm selectCol select2' id='selectFkCol"+jumlah+"'>"
                                            + "<option value='-1'>Pilih Kolom Caption</option>"    
                                        + "</select>"
                                        + "<select class='form-control input-sm selectCol select2' id='selectFkVal"+jumlah+"'>"
                                            + "<option value='-1'>Pilih Kolom Value</option>"    
                                        + "</select>";
                                    } else {
                        returnData += getColumnSelect(jumlah, table, request, column, value);
                                    }
                                    
                    returnData += "</div></div>";
        
        return returnData;
    }
    
    public String getColumnSelect(int jumlah, String tableName, HttpServletRequest request, String columnName, String valueName) throws DBException, SQLException{
        
        HttpSession session=request.getSession(false);
        Vector listColumn = new Vector();
        Vector listTable = new Vector();
        if(session.getValue("listColumn"+tableName)!=null){
            listColumn = (Vector) session.getValue("listColumn"+tableName);
        } else {
            listColumn = MetaDataBuilder.getMetaDataColumns(tableName);
            session.putValue("listColumn"+tableName, listColumn);
        }
        
        String returnData = "<select class='form-control input-sm selectCol select2' id='selectFkCol' data-row='"+jumlah+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]+"' width='50%'>"
                                + "<option value='-1'>Pilih Field Caption</option>";
                                for (int i=0; i < listColumn.size();i++){
                                    MetaData metaData = (MetaData) listColumn.get(i);
                                    String selected = "";
                                    if(columnName.equals(metaData.getColName())){
                                        selected = "selected";
                                    }
                                    returnData += "<option value='"+metaData.getColName()+"' data-type='"+metaData.getDataType()+"' "+selected+">"+metaData.getColName()+"</option>";
                                }
                returnData += "</select>"
                            + "<select class='form-control input-sm selectCol select2' id='selectFkVal' data-row='"+jumlah+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_VALUE]+"' width='50%'>"
                                + "<option value='-1'>Pilih Field Value</option>";
                                for (int i=0; i < listColumn.size();i++){
                                    MetaData metaData = (MetaData) listColumn.get(i);
                                    String selected = "";
                                    if(valueName.equals(metaData.getColName())){
                                        selected = "selected";
                                    }
                                    returnData += "<option value='"+metaData.getColName()+"' data-type='"+metaData.getDataType()+"' "+selected+">"+metaData.getColName()+"</option>";
                                }
                returnData += "</select>";
        
        return returnData;
        
    }
    
    public String showTable(String tableName, HttpServletRequest request) throws DBException, SQLException{
        String returnData = "";
        Vector listColumn = MetaDataBuilder.getMetaDataColumns(this.tabel);
        if (this.oid != 0){
            String whereMapping = PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_ID]+"="+this.oid;
            Vector listMapping = PstFlowModulMapping.list(0, 0, whereMapping, PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_COLUMN_LEVEL]);
            
            returnData = "<hr style='border-color: lightgray'>"
                    + "<input type='hidden' value='"+(listMapping.size()-1)+"' id='jumlah_col'>"
                    + "<input type='hidden' value='"+tableName+"' id='nmTabel'>"
                    + "<table style='width: 100%' class='table table-bordered'>"
                        + "<thead>"
                            + "<tr>"
                                + "<th style='width: 15%'>Field</th>"
                                + "<th style='width: 15%'>Nama Kolom</th>"
                                + "<th style='width: 5px'>Level</th>"
                                + "<th style='width: 20%'>Type</th>"
                                + "<th style='width: 30%'>Data List</th>"
                                + "<th style='width: 8%'><i class='fa fa-pencil'></i></th>"
                            + "</tr>"
                        + "</thead>"
                        + "<tbody id='LIST_FIELD'>";
            
            if (listMapping.size()>0){
                for (int i=0; i < listMapping.size(); i++){
                    FlowModulMapping flowModulMapping = (FlowModulMapping) listMapping.get(i);
                    String readOnly = "";
                    String readOnlySelect = "";
                    if (flowModulMapping.getType()==2){
                        readOnly = "readonly";
                        readOnlySelect = "readonly";
                    } else if (flowModulMapping.getType()==1) {
                        readOnlySelect = "readonly";
                    }
            returnData += "<tr id='field"+i+"'>"
                            + "<td>"
                                + "<select class='form-control input-sm selectCol select2' id='selectCol' data-row='"+i+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FIELD_NAME]+"' "+readOnlySelect+">"
                                    + "<option value='-1'>Pilih Field</option>";
                                    for (int x=0; x < listColumn.size();x++){
                                        MetaData metaData = (MetaData) listColumn.get(x);
                                        String selected = "";
                                        if (flowModulMapping.getFieldName().equals(metaData.getColName())){
                                            selected = "selected";
                                        }
                                        returnData += "<option value='"+metaData.getColName()+"' data-type='"+metaData.getDataType()+"' "+selected+">"+metaData.getColName()+"</option>";
                                    }
                    returnData += "</select>"
                                + "<input type='hidden' id='dataType"+i+"' value='"+flowModulMapping.getDataType()+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TYPE]+"'>"
                                + "<input type='hidden' id='oidMapping"+i+"' value='"+flowModulMapping.getOID()+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FLOW_MODUL_MAPPING_ID]+"'>"
                                + "<input type='hidden' value='"+flowModulMapping.getType()+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_TYPE]+"'>"
                            + "</td>"
                            + "<td>"
                                + "<input type='text' class='form-control' value='"+flowModulMapping.getColumnName()+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_NAME]+"' "+readOnly+">"
                            + "</td>"
                            + "<td>"
                                + "<input type='text' class='form-control' value='"+flowModulMapping.getColumnLevel()+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_LEVEL]+"' "+readOnly+">"
                            + "</td>"
                            + "<td>"
                                + "<select class='form-control input-sm selectCol select2' id='selectType' data-row='"+i+"' data-oid='"+flowModulMapping.getOID()+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_INPUT_TYPE]+"'>";
                                    for (int x=0; x < PstFlowModulMapping.inputTypeName.length;x++){
                                        String selected = "";
                                        if (flowModulMapping.getInputType() == x){
                                            selected = "selected";
                                        }
                                        returnData += "<option value='"+x+"' "+selected+">"+PstFlowModulMapping.inputTypeName[x]+"</option>";
                                    }
                    returnData += "</select>"
                            + "</td>"
                            + "<td id='tdDataList"+i+"'>";
                            switch(flowModulMapping.getInputType()){
                                case PstFlowModulMapping.INPUT_TYPE_TEXT:
                                    returnData += "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]+"'>"
                                                + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]+"'>"
                                                + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_VALUE]+"'>";
                                    break;
                                case PstFlowModulMapping.INPUT_TYPE_DATALIST_SELECTION:
                                    returnData += "<button type='button' data-row='"+i+"' data-oid='"+flowModulMapping.getOID()+"' class='btn btn-sm btn-success btn_add'><i class='fa fa-plus'></i> Tambah Data List</button>"
                                                + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]+"'>"
                                                + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]+"'>"
                                                + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_VALUE]+"'>";
                                    break;
                                case PstFlowModulMapping.INPUT_TYPE_TABLECOLUMN_SELECTION:
                                    returnData += getAllTabelSelect(i, request, flowModulMapping.getDataTable(), flowModulMapping.getDataColumn(), flowModulMapping.getDataValue());
                                    break;
                            }
                    returnData += "</td>"
                            + "<td>"
                                + "<button style=\"color: #dd4b39;\" type=\"button\" data-row=\""+i+"\" data-oid=\""+flowModulMapping.getOID()+"\" class=\"btn btn-sm btn-default btn_remove_col\"><i class=\"fa fa-minus\"></i></button>"
                            + "</td>"
                        + "</tr>";
                }
            }
        } else {
             Vector listFK = MetaDataBuilder.getMetaDataFK(tableName);
             Vector listPK = MetaDataBuilder.getMetaDataPK(tableName);
        
             returnData = "<hr style='border-color: lightgray'>"
                    + "<input type='hidden' value='"+(listFK.size()+listPK.size())+"' id='jumlah_col'>"
                    + "<input type='hidden' value='"+tableName+"' id='nmTabel'>"
                    + "<table style='width: 100%' class='table table-bordered'>"
                        + "<thead>"
                            + "<tr>"
                                + "<th style='width: 15%'>Field</th>"
                                + "<th style='width: 15%'>Nama Kolom</th>"
                                + "<th style='width: 5px'>Level</th>"
                                + "<th style='width: 20%'>Type</th>"
                                + "<th style='width: 30%'>Data List</th>"
                                + "<th style='width: 8%'><i class='fa fa-pencil'></i></th>"
                            + "</tr>"
                        + "</thead>"
                        + "<tbody id='LIST_FIELD'>";
                        int field=0;
                        if (listPK.size()>0){
                            for (int i=0;i<listPK.size();i++){
                                MetaData metaData = (MetaData) listPK.get(i);
                returnData += "<tr id='field"+field+"'>"
                                    + "<td>"
                                        + "<select class='form-control input-sm selectCol select2' id='selectCol' data-row='"+field+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FIELD_NAME]+"'>"
                                            + "<option value='"+metaData.getPk()+"' selected='' readonly>"+metaData.getPk()+"</option>"
                                        + "</select>"
                                        + "<input type='hidden' value='"+metaData.getDataType()+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TYPE]+"'>"
                                        + "<input type='hidden' value='0' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FLOW_MODUL_MAPPING_ID]+"'>"
                                        + "<input type='hidden' value='"+PstFlowModulMapping.TYPE_PRIMARY+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_TYPE]+"'>"
                                    + "</td>"
                                    + "<td>"
                                        + "<input type='text' class='form-control' value='No' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_NAME]+"' readonly>"
                                    + "</td>"
                                    + "<td>"
                                        + "<input type='text' class='form-control' value='1' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_LEVEL]+"' readonly>"
                                    + "</td>"
                                    + "<td>"
                                        + "<input type='hidden' class='form-control' value='"+PstFlowModulMapping.INPUT_TYPE_TEXT+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_INPUT_TYPE]+"'>"
                                        + "<input type='text' class='form-control' value='"+PstFlowModulMapping.typeName[PstFlowModulMapping.INPUT_TYPE_TEXT]+"' readonly>"
                                    + "</td>"
                                    + "<td id='tdDataList"+i+"'>"
                                        + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]+"'>"
                                        + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]+"'>"
                                        + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_VALUE]+"'>"
                                    + "</td>"
                                    + "<td>"
                                    + "</td>"
                                + "</tr>";
                                field++;
                            }
                        }
                        if (listFK.size()>0){
                            for (int i=0;i<listFK.size();i++){
                                MetaData metaData = (MetaData) listFK.get(i);
                returnData += "<tr id='field"+field+"'>"
                                    + "<td>"
                                        + "<select class='form-control input-sm selectCol select2' id='selectCol' data-row='"+field+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FIELD_NAME]+"'>"
                                            + "<option value='"+metaData.getFkColumn()+"' selected='' disabled=''>"+metaData.getFkColumn()+"</option>"
                                        + "</select>"
                                        + "<input type='hidden' value='"+metaData.getDataType()+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TYPE]+"'>"
                                        + "<input type='hidden' value='0' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FLOW_MODUL_MAPPING_ID]+"'>"
                                        + "<input type='hidden' value='"+PstFlowModulMapping.TYPE_FOREIGN+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_TYPE]+"'>"
                                    + "</td>"
                                    + "<td>"
                                        + "<input type='text' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_NAME]+"'>"
                                    + "</td>"
                                    + "<td>"
                                        + "<input type='text' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_LEVEL]+"'>"
                                    + "</td>"
                                    + "<td>"
                                        + "<select class='form-control input-sm selectCol select2' id='selectType' data-row='"+jumlah+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_INPUT_TYPE]+"'>";
                                        for (int x=0; x < PstFlowModulMapping.inputTypeName.length;x++){
                                            returnData += "<option value='"+x+"'>"+PstFlowModulMapping.inputTypeName[x]+"</option>";
                                        }
                        returnData += "</select>"
                                    + "</td>"
                                    + "<td id='tdDataList"+i+"'>"
                                        + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]+"'>"
                                        + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]+"'>"                                        
                                    + "</td>"
                                    + "<td>"
                                    + "</td>"
                                + "</tr>";
                                field++;
                            }
                        }
                    }
                returnData +="</tbody>"
                            + "</tfoot>"
                                + "<td colspan='5'></td>"
                                + "<td>"
                                    + "<button style='color: #00a65a;' type='button' id='btn_add_column' class='btn btn-sm btn-default'><i class='fa fa-plus'></i></button>"
                                + "</td>"
                            + "</tfoot>"
                        + "</table>";
        
        
        
        return returnData;
    }
    
    public String getRow(int jumlah, String tableName, HttpServletRequest request) throws DBException, SQLException{
        HttpSession session=request.getSession(false);
        Vector listColumn = new Vector();
        Vector listTable = new Vector();
        if(session.getValue("listColumn"+tableName)!=null){
            listColumn = (Vector) session.getValue("listColumn"+tableName);
        } else {
            listColumn = MetaDataBuilder.getMetaDataColumns(this.tabel);
            session.putValue("listColumn"+tableName, listColumn);
        }
        
        if(session.getValue("listTable")!=null){
            listTable = (Vector) session.getValue("listTable");
        } else {
            listTable = MetaDataBuilder.getAllTables();
            session.putValue("listTable", listTable);
        }
        String returnData="<tr id='field"+jumlah+"'>"
                + "<td>"
                    + "<select class='form-control input-sm selectCol select2' id='selectCol' data-row='"+jumlah+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FIELD_NAME]+"'>"
                        + "<option value='-1'>Pilih Field</option>";
                        for (int i=0; i < listColumn.size();i++){
                            MetaData metaData = (MetaData) listColumn.get(i);
                            returnData += "<option value='"+metaData.getColName()+"' data-type='"+metaData.getDataType()+"'>"+metaData.getColName()+"</option>";
                        }
        returnData += "</select>"
                    + "<input type='hidden' id='dataType"+jumlah+"' value='' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TYPE]+"'>"
                    + "<input type='hidden' value='0' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_FLOW_MODUL_MAPPING_ID]+"'>"
                    + "<input type='hidden' value='"+PstFlowModulMapping.TYPE_REGULAR+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_TYPE]+"'>"
                + "</td>"
                + "<td>"
                    + "<input type='text' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_NAME]+"'>"
                + "</td>"
                + "<td>"
                    + "<input type='text' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_COLUMN_LEVEL]+"'>"
                + "</td>"
                + "<td>"
                    + "<select class='form-control input-sm selectCol select2' id='selectType' data-row='"+jumlah+"' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_INPUT_TYPE]+"'>";
                        for (int i=0; i < PstFlowModulMapping.inputTypeName.length;i++){
                            returnData += "<option value='"+i+"'>"+PstFlowModulMapping.inputTypeName[i]+"</option>";
                        }
        returnData += "</select>"
                + "</td>"
                + "<td id='tdDataList"+jumlah+"'>"
                        + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]+"'>"
                        + "<input type='hidden' class='form-control' name='"+FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]+"'>"
                + "</td>"
                + "<td>"
                    + "<button style=\"color: #dd4b39;\" type=\"button\" data-row=\""+jumlah+"\" data-oid=\"0\" class=\"btn btn-sm btn-default btn_remove_col\"><i class=\"fa fa-minus\"></i></button>"
                + "</td>";
        
        
        return returnData;
    }
    
    public String getDataList(long oidMapping, int jumlah, int jumlahData){
        Vector listData = PstFlowMappingDataList.list(0, 0, 
                PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_FLOW_MAPPING_ID]+"="+oidMapping, "");
        String returnData = "<input type='hidden' value='"+listData.size()+"' id='jumlah_data'>"
                            + "<table class='table table-striped table-bordered'>"
                                + "<thead>"
                                    + "<tr>"
                                        + "<th>Caption</th>"
                                        + "<th>Value</th>"
                                        + "<th style='width: 8%'><i class='fa fa-pencil'></i></th>"
                                    + "</tr>"
                                + "</thead>"
                                + "<tbody id='DATA_LIST'>";
                                    if (listData.size()>0){
                                        for (int i=0; i < listData.size(); i++){
                                            FlowMappingDataList dataList = (FlowMappingDataList) listData.get(i);
                                            returnData += "<tr id='data"+i+"'>"
                                                            + "<td>"
                                                                + "<input type='hidden' class='form-control' name='"+FrmFlowMappingDataList.fieldNames[FrmFlowMappingDataList.FRM_FIELD_FLOW_MAPPING_DATA_LIST_ID]+"' value='"+dataList.getOID()+"'>"
                                                                + "<input type='text' class='form-control' name='"+FrmFlowMappingDataList.fieldNames[FrmFlowMappingDataList.FRM_FIELD_DATA_CAPTION]+"' value='"+dataList.getDataCaption()+"'>"
                                                            + "</td>"
                                                            + "<td>"
                                                                + "<input type='text' class='form-control' name='"+FrmFlowMappingDataList.fieldNames[FrmFlowMappingDataList.FRM_FIELD_DATA_VALUE]+"' value='"+dataList.getDataValue()+"'>"
                                                            + "</td>"
                                                            + "<td>"
                                                                + "<button style=\"color: #dd4b39;\" type=\"button\" data-row=\""+jumlahData+"\" data-oid=\""+dataList.getOID()+"\" class=\"btn btn-sm btn-default btn_remove_datalist\"><i class=\"fa fa-minus\"></i></button>"
                                                            + "</td>"
                                                        + "</tr>";
                                        }
                                    }
                    returnData += "</tbody>"
                                    + "</tfoot>"
                                    + "<td colspan='2'></td>"
                                    + "<td>"
                                        + "<button style='color: #00a65a;' type='button' id='btn_add_data' class='btn btn-sm btn-default'><i class='fa fa-plus'></i></button>"
                                    + "</td>"
                                + "</tfoot>"
                            + "</table>";
                
        
        return returnData;
    }
    
    public static String getDataRow(int jumlahData){
        
        String returnData = "<tr id='data"+jumlahData+"'>"
                                + "<td>"
                                    + "<input type='hidden' class='form-control' name='"+FrmFlowMappingDataList.fieldNames[FrmFlowMappingDataList.FRM_FIELD_FLOW_MAPPING_DATA_LIST_ID]+"' value='0'>"
                                    + "<input type='text' class='form-control' name='"+FrmFlowMappingDataList.fieldNames[FrmFlowMappingDataList.FRM_FIELD_DATA_CAPTION]+"' placeholder='Caption'>"
                                + "</td>"
                                + "<td>"
                                    + "<input type='text' class='form-control' name='"+FrmFlowMappingDataList.fieldNames[FrmFlowMappingDataList.FRM_FIELD_DATA_VALUE]+"' placeholder='Value'>"
                                + "</td>"
                                + "<td>"
                                    + "<button style=\"color: #dd4b39;\" type=\"button\" data-row=\""+jumlahData+"\" data-oid=\"0\" class=\"btn btn-sm btn-default btn_remove_datalist\"><i class=\"fa fa-minus\"></i></button>"
                                + "</td>"
                            + "</tr>";
        
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
