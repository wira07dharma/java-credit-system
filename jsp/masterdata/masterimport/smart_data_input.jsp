<%-- 
    Document   : smart_data_input
    Created on : 09-Mar-2018, 10:21:22
    Author     : Gunadi
--%>

<%@page import="com.dimata.tools.db.Excel2DB"%>
<%@page import="java.lang.reflect.Method"%>
<%@page import="com.dimata.common.entity.excel.FlowModul"%>
<%@page import="com.dimata.common.entity.excel.PstFlowModul"%>
<%@page import="com.dimata.common.entity.excel.FlowGroup"%>
<%@page import="com.dimata.common.entity.excel.PstFlowGroup"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.tools.db.MetaDataBuilder"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidFlowGroup = FRMQueryString.requestLong(request, "flow_group");
    long oidFlow = FRMQueryString.requestLong(request, "oid_flow");
    FlowModul flowModul = new FlowModul();
    try {
        flowModul = PstFlowModul.fetchExc(oidFlow);
    } catch (Exception exc){}
    
    String htmlTable = "";
    
    if (iCommand == Command.POST){
        JspWriter output = pageContext.getOut();
        htmlTable = Excel2DB.drawImport(config, request, response, output, oidFlow);
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style type="text/css">
            * {margin: 0; padding: 0;}

            .tree ul {
                    padding-top: 20px; position: relative;

                    transition: all 0.5s;
                    -webkit-transition: all 0.5s;
                    -moz-transition: all 0.5s;
            }

            .tree li {
                    float: left; text-align: center;
                    list-style-type: none;
                    position: relative;
                    padding: 20px 5px 0 5px;

                    transition: all 0.5s;
                    -webkit-transition: all 0.5s;
                    -moz-transition: all 0.5s;
            }

            /*We will use ::before and ::after to draw the connectors*/

            .tree li::before, .tree li::after{
                    content: '';
                    position: absolute; top: 0; right: 50%;
                    border-top: 1px solid #ccc;
                    width: 50%; height: 20px;
            }
            .tree li::after{
                    right: auto; left: 50%;
                    border-left: 1px solid #ccc;
            }

            /*We need to remove left-right connectors from elements without 
            any siblings*/
            .tree li:only-child::after, .tree li:only-child::before {
                    display: none;
            }

            /*Remove space from the top of single children*/
            .tree li:only-child{ padding-top: 0;}

            /*Remove left connector from first child and 
            right connector from last child*/
            .tree li:first-child::before, .tree li:last-child::after{
                    border: 0 none;
            }
            /*Adding back the vertical connector to the last nodes*/
            .tree li:last-child::before{
                    border-right: 1px solid #ccc;
                    border-radius: 0 5px 0 0;
                    -webkit-border-radius: 0 5px 0 0;
                    -moz-border-radius: 0 5px 0 0;
            }
            .tree li:first-child::after{
                    border-radius: 5px 0 0 0;
                    -webkit-border-radius: 5px 0 0 0;
                    -moz-border-radius: 5px 0 0 0;
            }

            /*Time to add downward connectors from parents*/
            .tree ul ul::before{
                    content: '';
                    position: absolute; top: 0; left: 50%;
                    border-left: 1px solid #ccc;
                    width: 0; height: 20px;
            }

            .tree li a{
                    border: 1px solid #ccc;
                    padding: 5px 10px;
                    text-decoration: none;
                    font-family: arial, verdana, tahoma;
                    font-size: 11px;
                    display: inline-block;

                    border-radius: 5px;
                    -webkit-border-radius: 5px;
                    -moz-border-radius: 5px;

                    transition: all 0.5s;
                    -webkit-transition: all 0.5s;
                    -moz-transition: all 0.5s;
            }

            .done{
                background-color: #4CAF50;
                color: white;
            }
            
            .disable{
                background-color: #dddddd;
                color: black;
                pointer-events: none;
            }
            
            #exTab1 .tab-content {
                color : white;
                background-color: #428bca;
                padding : 5px 15px;
            }

            #exTab2 h3 {
                color : white;
                background-color: #428bca;
                padding : 5px 15px;
            }

            /* remove border radius for the tab */

            #exTab1 .nav-pills > li > a {
                border-radius: 0;
            }

            /* change border radius for the tab , apply corners on top*/

            #exTab3 .nav-pills > li > a {
                border-radius: 4px 4px 0 0 ;
            }

            #exTab3 .tab-content {
                color : white;
                background-color: #428bca;
                padding : 5px 15px;
            }
            
            /* Style tab links */
            .tablink {
                background-color: #f2f2f2;
                color: black;
                float: left;
                border: none;
                outline: none;
                cursor: pointer;
                padding: 14px 16px;
                font-size: 17px;
                width: 15%;
            }

            .tablink:hover {
                background-color: #00a65a;
                color: white;
            }

            /* Style the tab content (and add height:100% for full page content) */
            .tabcontent {
                color: white;
                display: none;
                padding: 100px 20px;
                height: 100%;
            }
        </style>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="../../dtree/dtree.js"></script>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>JSP Page</title>
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
        <!-- Ionicons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
        <!-- Datetime Picker -->
        <link href="../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <!-- Select2 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins
             folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
        <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <script src="../../style/lib.js"></script>
        <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <script language="JavaScript">
            
            function openFlow(flowId,groupId){
                window.open("smart_data_input.jsp?oid_flow="+flowId+"&flow_group="+groupId, "_self");
            }
            function openTab(groupId){
                window.open("smart_data_input.jsp?flow_group="+groupId, "_self");
            }
            
            $(document).ready(function(){
                
                var upload = function(elementId){
                    $(elementId).click(function(){
                        $("#btnupload").html("Save").removeAttr("disabled");
                        $(".modal-dialog").css("width", "50%");
                        $("#uploaddoc").modal("show");
                        var command = <%= Command.POST %>;
                        var oidFlow = $("#oidFlow").val();
                        var oidFlowGroup = $("#oidFlowGroup").val();
                        var dataFor = $(this).data('for');
    //                    if (dataFor == "showEmpRelevantDocForm") {
                            $("#formupload").attr("action","smart_data_input.jsp?oid_flow="+oidFlow+"&flow_group="+oidFlowGroup+"&command="+command);
    //                    }

                        $("#tempname").val("");
                        $("#generaldatafor").val(dataFor);
                        $("#oiddata").val(oid);
                    });
                };

                function uploadTrigger(){
                    $("#uploadtrigger").unbind().click(function(){
                        $("#FRM_DOC").trigger('click');
                    });

                    $("#FRM_DOC").unbind().change(function(){
                        var doc = $("#FRM_DOC").val();
                        if (doc.indexOf("'") > -1){
                            $('#btnupload').prop('disabled', true);
                            alert("File Name Can't Contain ' Character ")
                            $("#tempname").val('');
                        } else {
                            $('#btnupload').prop('disabled', false);
                            $("#tempname").val(doc);
                        }

                    });

                    $("#tempname").unbind().click(function(){
                        $("#FRM_DOC").trigger('click');
                    });
                }
                upload(".btnupload");
                uploadTrigger();
                
                $('.btndownload').click(function() {
                    var oid = $(this).data('oid');
                    //window.location = "<%=approot%>/ExcelTemplate?oid_flow="+oid;
                    $("#oid").val(oid);
                    modalSetting("#modal-template", "static", false, false);
                    $('#modal-template').modal('show');
                  });
                  
                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };
            })
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                Smart Data Input <%=(oidFlow != 0? " - " +flowModul.getFlowModulName():"")%>
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                <li class="active">Smart Data Input</li>
            </ol>
        </section>
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-success">
                        <div class="box-body">
                            <div class="col-md-12">
                            <ul class="nav nav-tabs">
                                    <%
                                        Vector listFlowGroup = PstFlowGroup.listAll();
                                        if (listFlowGroup.size() > 0){
                                            for (int i=0; i < listFlowGroup.size();i++){
                                                FlowGroup flowGroup = (FlowGroup) listFlowGroup.get(i);
                                                String clss = "";
                                                if (oidFlowGroup == 0 && i==0){
                                                        clss = "class='active'";
                                                }
                                                else if (flowGroup.getOID() == oidFlowGroup){
                                                        clss = "class='active'";
                                                }
                                                %>
                                                <li <%=clss%>><a href="javascript:openTab('<%=flowGroup.getOID()%>')" ><%=flowGroup.getFlowGroupName()%></a></li>
                                                <%
                                            }
                                        }
                                    %>
                            </ul>
                                        <%
                                            if (oidFlowGroup > 0){
                                        %>
                                            <div class="col-md-2">
                                                <div class="tree">
                                                <%
                                                    String whereFlow = PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_GROUP_ID]+"="+oidFlowGroup;
                                                    String order = PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_LEVEL];
                                                    Vector listFlow = PstFlowModul.list(0, 0, whereFlow, order);
                                                    if (listFlow.size()>0){
                                                        String close = "";
                                                        for (int x = 0; x < listFlow.size(); x++){
                                                                FlowModul flow = (FlowModul) listFlow.get(x);
                                                                close += "</li></ul>";

                                                                int currData = MetaDataBuilder.countData(flow.getFlowModulTable());
                                                                int prevData = 0;
                                                                if (flow.getFlowLevel() > 1 && x != 0){
                                                                        FlowModul prevFlow = (FlowModul)listFlow.get(x-1);
                                                                        prevData = MetaDataBuilder.countData(prevFlow.getFlowModulTable());
                                                                }

                                                                String style = "";
                                                                if (prevData==0 && x!=0){
                                                                    style = "class='disable'";
                                                                } else if (currData > 0){
                                                                    style = "class='done'";
                                                                }



                                                                %>
                                                        <ul>
                                                            <li>
                                                               <a href="javascript:openFlow('<%=flow.getOID()%>','<%=flow.getFlowGroupId()%>')" <%=style%>><%=flow.getFlowModulName()%></a> 
                                                        <%
                                                        }
                                                        %>
                                                                <%=close%>
                                                        <%
                                                    }  else {

                                                %>
                                                <div class="col-md-12" style="padding-top: 16px">
                                                    Belum Ada Data
                                                </div>
                                                <%
                                                    }
                                                %>
                                                    </div>
                                                </div>
                                                <%
                                                    if (oidFlow != 0){
                                                %>
                                                <div class="col-md-10" style="padding-top: 16px">
                                                    <div class="header">
                                                            <button class="btn btn-primary btnupload">Unggah data Baru</button>
                                                            <button class="btn btn-success btndownload" data-oid="<%=oidFlow%>">Unduh Template</button>
                                                    </div>
                                                    <div class="col-md-10" style="padding-top: 16px">
                                                        <%=htmlTable%>
                                                    </div>
                                                </div>
                                                <%
                                                    }
                                                %>
                                        <%
                                            } else {
                                            %>
                                                <div class="col-md-12" style="padding-top: 16px">
                                                    Belum Ada Data
                                                </div>
                                            <%
                                            }
                                        %>
                        </div>
                        
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </body>
    <div id="uploaddoc" class="modal fade nonprint" tabindex="-1">
	<div class="modal-dialog nonprint">
	    <div class="modal-content">
		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		    <h4 class="addeditgeneral-title-doc">Unggah Data <%=(oidFlow != 0? flowModul.getFlowModulName():"")%></h4>
		</div>
                <form method="POST" id="formupload" enctype="multipart/form-data">		    
		    <input type="hidden" name="command" value="<%= Command.POST %>">
                    <input type="hidden" name="FRM_FIELD_DATA_FOR" id="generaldatafor">
                    <input style="width:0px; height:0px;"  type="file" name="FRM_DOC" id="FRM_DOC" accept=".xls">
		   <input type="hidden" name="oid_flow" id="oidFlow" value="<%=oidFlow%>">
                   <input type="hidden" name="flow_group" id="oidFlowGroup" value="<%=oidFlowGroup%>">
		    <div class="modal-body ">
			<div class="row">
			    <div class="col-md-12">
				<div class="box-body upload-body">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label>Pilih Berkas</label>
                                                <div class="input-group my-colorpicker2 colorpicker-element">
                                                    <input required id="tempname" class="form-control" type="text">
                                                    <div style="cursor: pointer" class="input-group-addon" id="uploadtrigger">
                                                        <i class="fa fa-file-excel-o"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>    
				</div>
			    </div>
			</div>
		    </div>
		    <div class="modal-footer">
			<button type="submit" class="btn btn-primary" id="btnupload"><i class="fa fa-check"></i> Save</button>
			<button type="button" data-dismiss="modal" class="btn btn-danger"><i class="fa fa-ban"></i> Close</button>
		    </div>
		</form>
	    </div>
	</div>
    </div>
    <div id="modal-template" class="modal fade" role="dialog">
        <div class="modal-dialog modal-sm">                
            <!-- Modal content-->
            <div class="modal-content">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Unduh Template</h4>
                </div>

                <form id="form-data" enctype="multipart/form-data" action="<%=approot%>/ExcelTemplate">
                    <input type="hidden" name="oid_flow" id="oid">
                    <div class="modal-body">
                        <div class="box-body data-body">
                            <input type="text" name="dataCount" placeholder="Masukkan Jumlah Data" class="form-control">
                        </div>
                    </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-sm btn-success" id="btn-unduh-data"><i class="fa fa-file-excel-o"></i> &nbsp; Unduh</button>
                </div>
            </form>
            </div>

        </div>
    </div>
</html>
