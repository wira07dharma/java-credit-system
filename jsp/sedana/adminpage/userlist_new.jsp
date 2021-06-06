<%-- 
    Document   : userlist_new
    Created on : Dec 27, 2019, 11:11:43 AM
    Author     : arise
--%>

<%@page import="com.dimata.sedana.common.AjaxHelper"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.aiso.form.admin.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ page import = "com.dimata.aiso.entity.admin.*" %> 
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
	boolean privAdd = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
	if (!privView && !privAdd && !privUpdate && !privDelete) {
		response.sendRedirect(approot + "/nopriv.html");
	}
%>
<%!
	public static String textHeader[][] = {
		{"Pengguna", "Sistem Admin"},
		{"User", "Admin System"}
	};
	public static String strTitle[][] = {
		{"No.", "Login ID", "Nama", "Status", "Tgl. Registrasi", "Tgl. Diubah", "Aksi"},
		{"No.", "Login ID", "Name", "Status", "Registration Date", "Update Date", "Action"}
	};
	public static final String systemTitle[] = {
		"Operator", "User"
	};
	public static final String userTitle[] = {
		"Daftar", "List"
	};
	public static String textCrud[][] = {
		{"Tambah", "Ubah", "Hapus", "Simpan", "Kembali", "Pilih"},
		{"Add", "Update", "Delete", "Save", "Back", "Select"}
	};
	public static final String dataTableTitle[][] = {
		{"Tampilkan _MENU_ data per halaman",
			"Data Tidak Ditemukan",
			"Menampilkan halaman _PAGE_ dari _PAGES_",
			"Belum Ada Data",
			"(Disaring dari _MAX_ data)",
			"Pencarian :",
			"Awal",
			"Akhir",
			"Berikutnya",
			"Sebelumnya"},
		{"Display _MENU_ records per page",
			"Nothing found - sorry",
			"Showing page _PAGE_ of _PAGES_",
			"No records available",
			"(filtered from _MAX_ total records)",
			"Search :",
			"First",
			"Last",
			"Next",
			"Previous"}
	};
%>
<%
    AjaxHelper helper = new AjaxHelper();
    System.out.println("tes"+helper.isAjaxKreditRun());
    String optAll = "<option value='0'>Semua</option>";
    String optLocation = "";
    Vector<Location> listLocation = PstLocation.getListFromApi(0, 0, "", "");
    int index = 0;
    for(Location l : listLocation){
        if(index == 0){
            optLocation += optAll;
        } 
        optLocation += "<option value='" + l.getOID() + "'>" + l.getName() + "</option>";
        index++;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%@include file="../../style/style_kredit.jsp" %>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    <%= textHeader[SESS_LANGUAGE][0]%>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li><%= textHeader[SESS_LANGUAGE][1]%></li>
                    <li class="active"><%= textHeader[SESS_LANGUAGE][0]%></li>
                </ol>
            </section>
            <section class="content">
                <div class="box box-success">
                    <div class="box-header with-border border-gray">
                        <h3 class="box-title">
                            <%= systemTitle[SESS_LANGUAGE]%>: <span class="text-red"><%= userTitle[SESS_LANGUAGE]%></span>
                        </h3>
                        <div class="row">
                            <div class="col-sm-5"></div>
                            <div class="col-sm-2">
                                <select style="width: 100%" class="form-control input-sm" id="id_location" name="FRM_USER_LOCATION">
                                    <%= optLocation %>
                                </select>
                            </div>
                            <div class="col-sm-5"></div>
                        </div>
                    </div>
                    <div class="box-body">
                        <div id="user-table-parent">
                            <table id="user-table" class="table table-bordered table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 5%;"><%= strTitle[SESS_LANGUAGE][0]%></th>
                                        <th class="text-center" style="width: 20%;"><%= strTitle[SESS_LANGUAGE][1]%></th>
                                        <th class="text-center" style="width: 20%;"><%= strTitle[SESS_LANGUAGE][2]%></th>
                                        <th class="text-center" style="width: 15%;"><%= strTitle[SESS_LANGUAGE][3]%></th>
                                        <th class="text-center" style="width: 10%;"><%= strTitle[SESS_LANGUAGE][4]%></th>
                                        <th class="text-center" style="width: 10%;"><%= strTitle[SESS_LANGUAGE][5]%></th>
                                        <th class="text-center" style="width: 5%;"><%= strTitle[SESS_LANGUAGE][6]%></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                    <% if (privAdd) {%>
                    <div class="box-footer">
                        <button type="button" class="btn btn-success create-edit-user" value="0">
                            <i class="fa fa-plus"></i>
                            <%= textCrud[SESS_LANGUAGE][0]%>
                        </button>
                    </div>
                    <% }%> 
                </div>
            </section>
        </div>

        <script>
            $(function(){
                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables, order) {
                    var datafilter = "";
                    var privUpdate = "";
                    let locationId = $('#id_location').val();
                    var colss = [0,-1];
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({
                        "bDestroy": true,
                        "searching": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "order": order,
                        "oLanguage": {
                            "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></div>",
                            "sLengthMenu": "<%=dataTableTitle[SESS_LANGUAGE][0]%>",
                            "sZeroRecords": "<%=dataTableTitle[SESS_LANGUAGE][1]%>",
                            "sInfo": "<%=dataTableTitle[SESS_LANGUAGE][2]%>",
                            "sInfoEmpty": "<%=dataTableTitle[SESS_LANGUAGE][3]%>",
                            "sInfoFiltered": "<%=dataTableTitle[SESS_LANGUAGE][4]%>",
                            "sSearch": "<%=dataTableTitle[SESS_LANGUAGE][5]%>",
                            "oPaginate": {
                                    "sFirst ": "<%=dataTableTitle[SESS_LANGUAGE][6]%>",
                                    "sLast ":  "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                    "sNext ":  "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                    "sPrevious ":   "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            }
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>"
                            + "&privupdate=<%= privUpdate%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor 
                            + "&FRM_USER_LOCATION=" + locationId,
                        aoColumnDefs: [
                            {
                                    bSortable: false,
                                    aTargets: colss
                            }
                        ],
                        "initComplete": function (settings, json) {
                            if (callBackDataTables !== null) {
                                    callBackDataTables();
                            }
                        },
                        "fnDrawCallback": function (oSettings) {
                            if (callBackDataTables !== null) {
                                    callBackDataTables();
                            }
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }
                function runDataTable(){
                    var order = [[1, "asc"]];
                    dataTablesOptions("#user-table-parent", "user-table", "AjaxAppUser", "listAppUser", null, order);
                }

                $('body').on('click', '.create-edit-user', function(){
                    var oid = $(this).val();
                    var cmd = "<%= Command.ADD%>";
                    if(oid != 0){
                            cmd = "<%= Command.EDIT%>";
                    }
                    var url = "useredit_new.jsp?command=" + cmd + "&user_oid=" + oid;
                    window.location = url;
                });

                runDataTable();
                
                $('#id_location').on('change', function(){
                    runDataTable();
                });
            });
        </script>						
    </body>
</html>
