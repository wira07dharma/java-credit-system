<%-- 
    Document   : custom_field_master
    Created on : 26-Feb-2018, 13:38:43
    Author     : Gunadi
--%>
<%@page import="com.dimata.harisma.form.masterdata.FrmCustomFieldDataList"%>
<%@page import="com.dimata.harisma.entity.masterdata.CustomFieldMaster"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlCustomFieldMaster"%>
<%@page import="com.dimata.harisma.entity.masterdata.CustomFieldDataList"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstCustomFieldDataList"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstCustomFieldMaster"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmCustomFieldMaster"%>
<%@page import="com.dimata.util.Command"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    public String getDataList(int inputType){
       String data = "";
       Vector listDataList = PstCustomFieldDataList.list(0, 0, "", "");
       if (listDataList != null && listDataList.size() > 0){
           switch(inputType){
                case 2:
                    data = "<select name=\"input2\">";
                    for(int i=0; i<listDataList.size(); i++){
                        CustomFieldDataList dataList = (CustomFieldDataList)listDataList.get(i);
                        data += "<option value=\""+dataList.getDataListValue()+"\">"+dataList.getDataListCaption()+"</option>";
                    }
                    data += "</select>";
                    break;
                case 3: 
                    data = "<select name=\"input3\" multiple=\"multiple\">";
                    for(int i=0; i<listDataList.size(); i++){
                        CustomFieldDataList dataList = (CustomFieldDataList)listDataList.get(i);
                        data += "<option value=\""+dataList.getDataListValue()+"\">"+dataList.getDataListCaption()+"</option>";
                    }
                    data += "</select>";
                    break;
                case 6:
                    for(int i=0; i<listDataList.size(); i++){
                        CustomFieldDataList dataList = (CustomFieldDataList)listDataList.get(i);
                        data += "<input type=\"checkbox\" name=\"input6\" value=\""+dataList.getDataListValue()+"\" /> "+dataList.getDataListCaption();
                    }
                    break;
                case 7: 
                    for(int i=0; i<listDataList.size(); i++){
                        CustomFieldDataList dataList = (CustomFieldDataList)listDataList.get(i);
                        data += "<input type=\"radio\" name=\"input7\" value=\""+dataList.getDataListValue()+"\" /> "+dataList.getDataListCaption();
                    }
                    break;
           }
       }
       return data;
   }
   
   public void deleteTempDataList(){
       Vector listDataList = PstCustomFieldDataList.list(0, 0, "", "");
        if (listDataList != null && listDataList.size()>0){
            for(int i=0; i<listDataList.size(); i++){
                CustomFieldDataList data = (CustomFieldDataList)listDataList.get(i);
                try {
                  PstCustomFieldDataList.deleteExc(data.getOID());
                } catch(Exception ex){
                    System.out.println("deleteTempDataList => "+ex.toString());
                }
            }
        }
   }
%>
<%
    long oidCustomField = FRMQueryString.requestLong(request, "field_id");
    int iCommand = FRMQueryString.requestCommand(request);
    int commandOther = FRMQueryString.requestInt(request, "command_other");
    long oidCustom = FRMQueryString.requestLong(request, "oid_custom");
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    String[] showField = FRMQueryString.requestStringValues(request, "show_field");
    String dataListCaption = FRMQueryString.requestString(request, "data_list_caption");
    String dataListValue = FRMQueryString.requestString(request, "data_list_value");
    int radioType = FRMQueryString.requestInt(request, FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_INPUT_TYPE]);
    
    if (commandOther > 0){
        CustomFieldDataList dataList = new CustomFieldDataList();
        dataList.setCustomFieldId(oidCustomField);
        dataList.setDataListCaption(dataListCaption);
        dataList.setDataListValue(dataListValue);
        PstCustomFieldDataList.insertExc(dataList);
        dataListCaption = "";
        dataListValue = "";
        commandOther = 0;
    }
    
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";//

    CtrlCustomFieldMaster ctrlCustomField = new CtrlCustomFieldMaster(request);
    Vector listCustomField = new Vector(1,1);
    FrmCustomFieldMaster frmCustomField = new FrmCustomFieldMaster();
    frmCustomField = ctrlCustomField.getForm();
    CustomFieldMaster customField = new CustomFieldMaster();
    
    if (iCommand == Command.SAVE){
        String dataList = getDataList(radioType);
        frmCustomField.setDataList(dataList);
        frmCustomField.setShowFields(showField);
        frmCustomField.requestEntityObject(customField);
        
    }
    /* reset temp data list */
    if (iCommand == Command.RESET){
        deleteTempDataList();
    }
    /* code process save */
    iErrCode = ctrlCustomField.action(iCommand, oidCustomField);
    /* end switch*/
    

    /*count list All Position*/
    int vectSize = PstCustomFieldMaster.getCount(whereClause); //PstWarningReprimandAyat.getCount(whereClause);
    customField = ctrlCustomField.getCustomFieldMaster();
    msgString = ctrlCustomField.getMessage();
    
    
    /* get record to display */
    listCustomField = PstCustomFieldMaster.list(0, 0, "", "");
    
    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listCustomField.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listCustomField = PstCustomFieldMaster.list(start, recordToGet, whereClause, orderClause);
    }
    
%>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>
          input#keyword{display:inline-block;margin-left:5px;}
          .listtitle{padding-bottom:5px;}
          .listgenactivity{margin-top:20px !important;}
          .listgenactivity td{padding-left:5px !important;padding-right:5px !important;}
        </style>
        <style>
          th {text-align: center; font-weight: normal; vertical-align: middle !important}
          .nilai_persen:hover {background-color: lightblue;}
          #desc_field_type{padding:7px 12px; background-color: #F3F3F3; border:1px solid #FFF; margin:3px 0px;}
          #text_desc {background-color: #FFF;color:#575757; padding:3px; font-size: 9px;}
          #data_list{padding:3px 5px; color:#FFF; background-color: #79bbff; margin:2px 1px 2px 0px; border-radius: 3px;}
          #data_list_close {padding:3px 5px; color:#FFF; background-color: #79bbff; margin:2px 1px 2px 0px; border-radius: 3px; cursor: pointer;}
          #data_list_close:hover {padding:3px 5px; color:#FFF; background-color: #0099FF; margin:2px 1px 2px 0px; border-radius: 3px;}
        </style>
        <script type="text/javascript">
            function getCmd(){
                document.form_fieldtambahan.action = "custom_field_master.jsp";
                document.form_fieldtambahan.submit();
            }
            function cmdSave() {
                document.form_fieldtambahan.command.value = "<%=Command.SAVE%>";
                getCmd();
            }
        </script>
        <script language="javascript">
            $(document).ready(function() {
                
                var approot = "<%= approot%>";
                
                var getDataFunction = function (onDone, onSuccess, approot, command, dataSend, servletName, dataAppendTo, notification) {
                    /*
                     * getDataFor	: # FOR PROCCESS FILTER
                     * onDone	: # ON DONE FUNCTION,
                     * onSuccess	: # ON ON SUCCESS FUNCTION,
                     * approot	: # APPLICATION ROOT,
                     * dataSend	: # DATA TO SEND TO THE SERVLET,
                     * servletName  : # SERVLET'S NAME
                     */
                    $(this).getData({
                        onDone: function (data) {
                            onDone(data);
                        },
                        onSuccess: function (data) {
                            onSuccess(data);
                        },
                        approot: approot,
                        dataSend: dataSend,
                        servletName: servletName,
                        dataAppendTo: dataAppendTo,
                        notification: notification
                    });
                };
                
                $('.btn_edit').click(function() {
                    $(this).attr({"disabled": "true"}).html("....");
                    var oid = $(this).data('oid');
                    window.location = "../masterkredit/custom_field_master.jsp?field_id=" + oid + "&command=<%=Command.EDIT%>";
                  });
                
                $('#btn_add').click(function() {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../masterkredit/custom_field_master.jsp?field_id=0&command=<%=Command.ADD%>";
                  });
                  
                $('.btn_cancel').click(function() {
                  $(this).attr({"disabled": "true"}).html("Tunggu...");
                  window.location = "../masterkredit/custom_field_master.jsp";
                });
                  
                $("#FRM_FIELD_MODUL_FIELD").change(function(){
                    var command = 0;
                    var modul = $("#FRM_FIELD_MODUL").val();
                    var field = $(this).val();
                    var dataSend = {
                        "field": field,
                        "modul": modul
                    }
                    var onDone = function(data){
                        $(".field-value").html(data.RETURN_HTML);
                        $(".field-value").removeAttr("style");
                    };
                    var onSuccess = function(data){

                    };
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxCustomField", null, false);
                });
                
                var editdetail = function(elementId){
                    $(elementId).click(function(){
                        modalSetting("#modal-adddatalist", "static", false, false);
                        $('#modal-adddatalist').modal('show');
                        var dataFor = "adddatalist";

                        $("#form-datalist #dataFor").val(dataFor);
                        $("#form-datalist #oid").val($('#field_id').val());
                        $("#form-datalist #FRM_FIELD_DATA_LIST_CAPTION").val($(this).data('caption'));
                        $("#form-datalist #FRM_FIELD_DATA_LIST_VALUE").val($(this).data('value'));
                        $("#form-datalist #oidDataList").val($(this).data('oid'));
                    });
                };
                
                function loadDataListTable(){
                        var oid = $('#field_id').val();
                        var command = "<%=Command.LIST%>";
                        var dataFor = "getTableDataList";
                        var dataSend = {
                            "FRM_FIELD_CUSTOM_FIELD_ID": oid,
                            "command": command,
                            "dataFor":dataFor
                        }
                        var onDone = function(data){
                            $("#div-table-datalist").html(data.RETURN_HTML);
                            editdetail(".btn-edit-datalist");
                            deletedetail(".btn-delete-datalist");
                            $('.btn-add-detail').click(function () {
                                modalSetting("#modal-adddatalist", "static", false, false);
                                $('#modal-adddatalist').modal('show');
                                var dataFor = "adddatalist";

                                $("#form-datalist #dataFor").val(dataFor);
                                $("#form-datalist #oid").val($('#field_id').val())
                            });
                        };
                        var onSuccess = function(data){

                        };
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxCustomField", null, false);
                    }
                    
                    var deletedetail = function(elementId){
                        $(elementId).click(function(){
                            var command = "<%= Command.DELETE%>";
                            var oid = ($(this).data('oid'));
                            var confirmTextSingle = "Hapus Data?";
                            var dataFor = "deletedetail";
                            var currentHtml = $(this).html();
                            $(this).html("...").attr({"disabled": true});
                                if (confirm(confirmTextSingle)) {
                                var dataSend = {
                                    "dataFor": dataFor,
                                    "FRM_FIELD_CUSTOM_FIELD_DATA_LIST_ID": oid,
                                    "command": command
                                };
                                var onSuccess = function (data) {

                                };

                                var onDone = function(data){
                                    loadDataListTable();
                                };
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxCustomField", null, false);
                                $(this).removeAttr("disabled").html(currentHtml);
                            } else {
                                    $(this).removeAttr("disabled").html(currentHtml);
                                }
                        });
                    };
                <% if (iCommand == Command.EDIT) {%>
                    function loadFieldValue(){
                        var command = 0;
                        var modul = $("#FRM_FIELD_MODUL").val();
                        var field = $("#FRM_FIELD_MODUL_FIELD").val();
                        var value = "<%=customField.getModulFieldValue()%>";
                        var dataSend = {
                            "field": field,
                            "modul": modul,
                            "value": value
                        }
                        var onDone = function(data){
                            $(".field-value").html(data.RETURN_HTML);
                            $(".field-value").removeAttr("style");
                            loadDataListTable();
                        };
                        var onSuccess = function(data){

                        };
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxCustomField", null, false);
                    }

                    loadFieldValue();
                <% } else {%>
                    loadDataListTable();
                <% } %>
                
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };
                
                $("form#form-datalist").submit(function(){
                    var currentBtnHtml = $("#btn-simpan-datalist").html();
                    $("#btn-simpan-datalist").html("Menyimpan...").attr({"disabled":"true"});
                    var command = "<%=Command.SAVE%>";
                    
                    onDone = function(data){
			loadDataListTable();
		    };
                    
                    if($(this).find(".has-error").length == 0){
                        var onSuccess = function(data){
                            $("#btn-simpan-datalist").removeAttr("disabled").html(currentBtnHtml);
                            $("#modal-adddatalist").modal("hide");
                        };

                        var dataSend = $(this).serialize();
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxCustomField", null, false);
                    }else{
                        $("#btn-simpan-datalist").removeAttr("disabled").html(currentBtnHtml);
                    }

                    return false;
                });
                  
            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
              Field Tambahan
              <small></small>
            </h1>
            <ol class="breadcrumb">
              <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
              <li>Master Kredit</li>
              <li class="active">Field Tambahan</li>
            </ol>
        </section>
        
        <section class="content">
            <div class="box box-success">
              <div class="box-body">
                <label>Daftar Field Tambahan</label>
                <table class="table table-bordered table-striped">
                  <tr class="label-success">
                    <th style="width: 1%">No.</th>
                    <th>Modul</th>
                    <th>Nama Field</th>
                    <th>Tipe</th>
                    <th>Wajib</th>
                    <th>Tipe Inputan</th>
                    <th>Catatan</th>
                    <th style="width: 70px">Aksi</th>
                  </tr>
                  <%if (listCustomField.isEmpty()) {%>
                    <tr><td colspan="9" class="text-center label-default">Tidak ada data</td></tr>
                  <% } else {
                        for (int i = 0; i < listCustomField.size(); i++) {
                          CustomFieldMaster customFieldMaster = (CustomFieldMaster) listCustomField.get(i);
                          String strType = "";
                          switch(customFieldMaster.getFieldType()){
                            case 0: strType = "Text"; break;
                            case 1: strType = "Decimal"; break;
                            case 2: strType = "Integer"; break;
                            case 3: strType = "Date"; break;
                            case 4: strType = "Date time"; break;
                          }
                          
                          String required="";
                          if (customFieldMaster.getRequired()== 1){required="Wajib Isi";}else{required="Tidak Wajib Isi";}
                          
                          String strInput = "";
                          switch(customFieldMaster.getInputType()){
                                case 0: strInput = "Text Field"; break;
                                case 1: strInput = "Text Area"; break;
                                case 2: strInput = "Combo Box"; break;
                                case 3: strInput = "Multiple Combo Box"; break;
                                case 4: strInput = "Datepicker"; break;
                                case 5: strInput = "Datepicker and Time"; break;
                                case 6: strInput = "Check Box"; break;
                                case 7: strInput = "Radio button"; break;
                          }
                  %>
                  <tr>
                    <td><%=(i + 1)%></td>
                    <td><%=PstCustomFieldMaster.modulName[customFieldMaster.getModul()]%></td>
                    <td><%=customFieldMaster.getFieldName()%></td>
                    <td><%=strType%></td>
                    <td><%=required%></td>
                    <td><%=strInput%></td>
                    <td><%=customFieldMaster.getNote()%></td>
                    <td class="text-center">
                      <button type="button" title="Ubah Data" class="btn btn-xs btn-warning btn_edit" data-oid="<%=customFieldMaster.getOID()%>"><i class="fa fa-pencil"></i></button>
                    </td>
                  </tr>
                  <%
                    }
                  }
                %>
                </table>
              </div>
              <div class="box-footer" style="border-color: lightgray">
                <button type="button" class="btn btn-sm btn-primary" id="btn_add"><i class="fa fa-plus"></i> &nbsp; Tambah Field</button>
              </div>
            </div>
            
            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>
            <div class="box box-success">
                <div class="box-header with-border" style="border-color: lightgrey">                    
                    <h3 class="box-title">Form Input Field Tambahan</h3>
                </div>
                <p></p>
                
                <form id="form_fieldtambahan" name="form_fieldtambahan" class="form-horizontal" method="POST" action="">
                    <div class="box-body">
                        <input type="hidden" value="<%=oidCustomField%>" name="field_id" id="field_id">
                        <input type="hidden" name="command" value="<%=iCommand%>" />
                        <div class="col-sm-12">
                            <div class="col-sm-4">
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Nama Modul</label>
                                    <div class="col-sm-8">
                                        <select class="form-control input-sm" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_MODUL]%>" id="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_MODUL]%>" >
                                            <% for(int ig1=0;ig1< PstCustomFieldMaster.modulName.length; ig1++){  
                                                String selected="";
                                                if (ig1==customField.getModul()){
                                                    selected="selected";
                                                } else {
                                                    selected="";
                                                }
                                            %>
                                                <option value="<%=ig1%>" <%=selected%>><%=PstCustomFieldMaster.modulName[ig1]%></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Field Modul</label>
                                    <div class="col-sm-8">
                                        <select class="form-control input-sm" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_MODUL_FIELD]%>" id="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_MODUL_FIELD]%>" value="">
                                            <% for(int ig2=0;ig2< PstCustomFieldMaster.namaField[0].length; ig2++){  
                                                String selected="";
                                                if (ig2==customField.getModulField()){
                                                    selected="selected";
                                                } else {
                                                    selected="";
                                                }
                                            %>
                                                <option value="<%=ig2%>" <%=selected%>><%=PstCustomFieldMaster.namaField[0][ig2]%></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                <% if (iCommand == Command.EDIT) {%>
                                <div class="form-group field-value"></div>
                                
                                <% } else {%>
                                <div class="form-group field-value" style="visibility: hidden">
                                    
                                </div>
                                <% } %>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Nama Field</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_FIELD_NAME]%>" value="<%=customField.getFieldName()%>"  />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Jenis Field</label>
                                    <div class="col-sm-8">
                                        <%
                                            String chkText = "";
                                            String chkDecimal = "";
                                            String chkInt = "";
                                            String chkDate = "";
                                            String chkDateTime = "";
                                            
                                            switch(customField.getFieldType()){
                                                case 0: chkText = "checked"; break;
                                                case 1: chkDecimal = "checked"; break;
                                                case 2: chkInt = "checked"; break;
                                                case 3: chkDate = "checked"; break;
                                                case 4: chkDateTime = "checked"; break;
                                            }
                                        %>
                                        <div id="desc_field_type">    
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_FIELD_TYPE]%>" value="0" style="display: inline" <%=chkText%>/><strong> Teks</strong>
                                            <div id="text_desc">text text text ...</div>
                                        </div>
                                        <div id="desc_field_type">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_FIELD_TYPE]%>" value="1" style="display: inline" <%=chkDecimal%>/><strong> Desimal</strong>
                                            <div>2.00, 1000.00 ...</div>
                                        </div>
                                        <div id="desc_field_type">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_FIELD_TYPE]%>" value="2" style="display: inline" <%=chkInt%>/><strong> Bilangan</strong>
                                            <div>1, 2, 100, ...</div>
                                        </div>
                                        <div id="desc_field_type" style="background-color: #dff092">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_FIELD_TYPE]%>" value="3" style="display: inline" <%=chkDate%>/><strong> Tanggal</strong>
                                            <div>2015-01-01</div>
                                        </div>
                                        <div id="desc_field_type" style="background-color: #c9c9c9">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_FIELD_TYPE]%>" value="4" style="display: inline" <%=chkDateTime%>/><strong> Tanggal Waktu</strong>
                                            <div>2015-01-01 00:00</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Wajib Isi</label>
                                    <div class="col-sm-8">
                                        <%
                                            String chkReq="";
                                            String chkNotReq ="";
                                            if (customField.getRequired()== 1){chkReq="checked";}else{chkNotReq="checked";}
                                        %>
                                        <label class="radio-inline">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_REQUIRED]%>" value="0" style="display: inline" <%=chkNotReq%>/> Tidak Wajib &nbsp;
                                        </label>
                                        <label class="radio-inline">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_REQUIRED]%>" value="1" style="display: inline" <%=chkReq%>/> Wajib Isi &nbsp;
                                        </label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">
                                        <i class="fa fa-question-circle" data-toggle="tooltip" data-placement="right" title="" data-original-title="Daftar pilihan untuk jenis inputan Seleksi, Seleksi Ganda, Checkbox dan Tombol Radio"></i>
                                        Data untuk Pilihan
                                    </label>
                                    <div class="col-sm-8" id="div-table-datalist">
                                        
                                        
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Jenis Inputan</label>
                                    <div class="col-sm-9">
                                        <%
                                            String chkFldTxt="";
                                            String chkFldTxtArea="";
                                            String chkFldSel="";
                                            String chkFldMulSel="";
                                            String chkDtPick="";
                                            String chkDtPickTime="";
                                            String chkChkBox="";
                                            String chkRadio="";
                                            switch(customField.getInputType()){
                                                case 0: chkFldTxt = "checked"; break;
                                                case 1: chkFldTxtArea = "checked"; break;
                                                case 2: chkFldSel = "checked"; break;
                                                case 3: chkFldMulSel = "checked"; break;
                                                case 4: chkDtPick = "checked"; break;
                                                case 5: chkDtPickTime = "checked"; break;
                                                case 6: chkChkBox = "checked"; break;
                                                case 7: chkRadio = "checked"; break;
                                            }
                                        %>
                                        <div id="desc_field_type">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_INPUT_TYPE]%>" value="0" style="display: inline" <%=chkFldTxt%>/><strong> Input Teks</strong>
                                            <div><i>Contoh </i><br><input type="text" name="ex_text" class="form-control" /></div>
                                        </div>
                                        <div id="desc_field_type">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_INPUT_TYPE]%>" value="1" style="display: inline" <%=chkFldTxtArea%>/><strong> Input Textarea</strong>
                                            <div><i>Contoh </i><br><textarea name="txtarea" class="form-control"></textarea></div>
                                        </div>
                                        <div id="desc_field_type">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_INPUT_TYPE]%>" value="2" style="display: inline" <%=chkFldSel%>/><strong> Seleksi</strong>
                                            <div><i>Contoh </i><br><select class="form-control"><option>opsi 1</option><option>opsi 2</option></select></div>
                                        </div>
                                        <div id="desc_field_type">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_INPUT_TYPE]%>" value="3" style="display: inline" <%=chkFldMulSel%>/><strong> Seleksi Ganda</strong>
                                            <div><i>Contoh </i><br><select class="form-control" multiple="multiple"><option>nilai 1</option><option>nilai 2</option><option>nilai 3</option></select></div> 
                                            <i>*)anda dapat memilih lebih dari satu pilihan</i>
                                        </div>
                                        <div id="desc_field_type" style="background-color: #dff092">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_INPUT_TYPE]%>" value="4" style="display: inline" <%=chkDtPick%>/><strong> Input Tanggal</strong>
                                            <div>
                                                <i>Contoh </i><br>
                                                <img src="../../images/datepicker.jpg" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Catatan</label>
                                    <div class="col-sm-9">
                                        <textarea class="form-control" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_NOTE]%>"><%=customField.getNote()%></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="form-group">
                                    <div class="col-sm-9">
                                        <div id="desc_field_type" style="background-color: #c9c9c9">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_INPUT_TYPE]%>" value="5" style="display: inline" <%=chkDtPickTime%>/><strong> Input Tanggal & Waktu</strong>
                                            <div>
                                                <i>Contoh </i><br>
                                                <img src="../../images/datepicker.jpg" />
                                            </div>
                                            <div>
                                                <select><option>00</option></select>:<select><option>00</option></select>
                                            </div>
                                        </div>
                                        <div id="desc_field_type">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_INPUT_TYPE]%>" value="6" style="display: inline" <%=chkChkBox%>/><strong>Check Box</strong>
                                            <div><i>Contoh </i><br><input type="checkbox" name="ex_chk" style="display: inline"/>Keterangan 1&nbsp;<input type="checkbox" name="ex_chk" style="display: inline"/>Keterangan 2</div>
                                            <i>*)anda dapat centang lebih dari 1</i>
                                        </div>
                                        <div id="desc_field_type">
                                            <input type="radio" name="<%=FrmCustomFieldMaster.fieldNames[FrmCustomFieldMaster.FRM_FIELD_INPUT_TYPE]%>" value="7" style="display: inline" <%=chkRadio%>/><strong> Tombol Radio</strong>
                                            <div><i>Contoh </i><br><input type="radio" name="ex_radio" style="display: inline"/>Keterangan 1&nbsp;<input type="radio" name="ex_radio" style="display: inline"/>Keterangan 2</div>
                                            <i>*)anda hanya dapat memilih satu opsi</i>
                                        </div>  
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    <div class="box-footer" style="border-color: lightgrey">
                        <div class="form-group" style="margin-bottom: 0px">
                          <div class="col-sm-2"></div>
                          <div class="col-sm-4">
                            <div class="pull-right">
                              <button onclick="cmdSave()" id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                              <button type="button" id="" class="btn btn-sm btn-default btn_cancel"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                            </div>
                          </div>
                        </div>
                    </div>
                </form>
                
            </div>
            
            <% } %>
            
          </section>
            
          <div id="modal-adddatalist" class="modal fade" role="dialog">
            <div class="modal-dialog modal-sm">                
                <!-- Modal content-->
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Tambah Data List</h4>
                    </div>

                    <form id="form-datalist" enctype="multipart/form-data">
                        <input type="hidden" name="FRM_FIELD_DATA_FOR" id="datafor">
                        <input type="hidden" name="command" value="<%= Command.SAVE%>">
                        <input type="hidden" name="<%=FrmCustomFieldDataList.fieldNames[FrmCustomFieldDataList.FRM_FIELD_CUSTOM_FIELD_DATA_LIST_ID]%>" id="oidDataList">
                        <input type="hidden" name="<%=FrmCustomFieldDataList.fieldNames[FrmCustomFieldDataList.FRM_FIELD_CUSTOM_FIELD_ID]%>" id="oid">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>Caption</label>
                                        <%
                                            
                                        %>
                                        <input type="text" name="<%=FrmCustomFieldDataList.fieldNames[FrmCustomFieldDataList.FRM_FIELD_DATA_LIST_CAPTION]%>" id="<%=FrmCustomFieldDataList.fieldNames[FrmCustomFieldDataList.FRM_FIELD_DATA_LIST_CAPTION]%>" value="" class="form-control" required="">
                                    </div>
                                    <div class="form-group">
                                        <label>Value</label>
                                        <input type="text" name="<%=FrmCustomFieldDataList.fieldNames[FrmCustomFieldDataList.FRM_FIELD_DATA_LIST_VALUE]%>" id="<%=FrmCustomFieldDataList.fieldNames[FrmCustomFieldDataList.FRM_FIELD_DATA_LIST_VALUE]%>" value="" class="form-control" required="">
                                    </div>
                                </div>
                            </div>
                        </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-sm btn-success" id="btn-simpan-datalist"><i class="fa fa-save"></i> &nbsp; Simpan</button>
                    </div>
                </form>
                </div>

            </div>
        </div>    
    </body>
</html>
