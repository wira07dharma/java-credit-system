<%-- 
    Document   : form5c_list
    Created on : Dec 3, 2019, 1:55:56 PM
    Author     : arise
--%>
<%@page import="com.dimata.sedana.entity.kredit.ReturnKredit"%>
<%@page import="com.dimata.sedana.entity.analisakredit.PstAnalisaKreditMain"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_RETURN_KREDIT);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
    if (!privView && !privAdd && !privUpdate && !privDelete) {
        response.sendRedirect(approot + "/nopriv.html");
    }
%>

<%!
    public static final String textHeader[][] = {
        {"Transaksi", "Pengembalian Barang", "List Pengembalian", "Form Pencarian"},
        {"Transaction", "Loan Return", "List Return", "Search Form"}
    };

    public static final String textCrud[][] = {
        {"Tambah", "Ubah", "Hapus", "Simpan", "Cari"},
        {"Add", "Update", "Delete", "Save", "Search"}
    };

    public static final String textHeaderTable[][] = {
        {"No.", "Nomor Dokumen", "Nomor Kredit", "Nama Pemohon", "Catatan", "Status", "Aksi", "Tanggal Return"},
        {"No.", "Document Number", "Credit Number", "Applicant Name", "Note", "Status", "Action", "Return Date"}
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
    int iCommand = FRMQueryString.requestCommand(request);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../../style/style_kredit.jsp" %>

        <style>

        </style>

    </head>
    <body style="background-color: #eaf3df;">

        <div class="main-page">

            <!-- ===== HEADER ===== -->
            <section class="content-header">
                <h1>
                    <%= textHeader[SESS_LANGUAGE][0]%> <small><%= textHeader[SESS_LANGUAGE][1]%></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li><%= textHeader[SESS_LANGUAGE][1]%></li>
                    <li class="active"><%= textHeader[SESS_LANGUAGE][0]%></li>
                </ol>
            </section>

            <!-- ===== CONTENT ===== -->
            <section class="content">

                <div class="box box-success">
                    <div class="box-header with-border border-gray">
                        <h3 class="box-title"> <%= textHeader[SESS_LANGUAGE][3]%> </h3>
                    </div>
                    <div class="box-body">
                        <form id="form-search" class="form-horizontal">
                            <div class="row">
                                <div class="col-md-12">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-4">Nomor Dokumen</label>
                                            <div class="col-md-8">
                                                <input type="text" class="form-control" placeholder="Nomor Dokumen" name="form_num">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="control-label col-md-4">Nomor Kredit</label>
                                            <div class="col-md-8">
                                                <input type="text" class="form-control" placeholder="Nomor Kredit" name="kredit_num">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-4">Tgl. Return</label>
                                            <div class="col-md-8">
                                                <div class="input-group">
                                                    <input type="text" class="form-control datePicker"
                                                           name="startDate" autocomplete="off">
                                                    <div class="input-group-addon">
                                                        <span>s/d</span>
                                                    </div>
                                                    <input type="text" class="form-control datePicker"
                                                           name="endDate" autocomplete="off">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label col-md-4">Status</label>
                                            <div class="col-md-8">
                                                <select class="form-control input-sm select2" multiple="multiple" style="width: 100%;" 
                                                        name="form_status">
                                                    <%
                                                        for (int i = 0; i < ReturnKredit.returnStatusKey.length; i++) {
                                                            out.println("<option value='" + ReturnKredit.returnStatusValue[i] + "'>" + ReturnKredit.returnStatusKey[i] + "</option>");
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="box-footer">
                        <button type="button" id="search-form-btn" class="btn btn-primary" value="0">
                            <i class="fa fa-search"></i>&nbsp;
                            <%= textCrud[SESS_LANGUAGE][4]%>
                        </button>
                        <button type="button" id="create-form-btn" class="btn btn-success" value="0">
                            <i class="fa fa-plus"></i>&nbsp;
                            <%= textCrud[SESS_LANGUAGE][0]%>
                        </button>
                    </div>
                </div>

                <div id="search-result-box">
                    <div class="box box-success">
                        <div class="box-header with-border border-gray">
                            <h3 class="box-title"> <%= textHeader[SESS_LANGUAGE][2]%> </h3>
                        </div>
                        <div class="box-body">
                            <div id="returnListTable">
                                <table id="returnList" class="table table-bordered table-striped table-responsive">
                                    <thead>
                                        <tr>
                                            <th style="width: 5%"> <%= textHeaderTable[SESS_LANGUAGE][0]%> </th>
                                            <th style="width: 20%"> <%= textHeaderTable[SESS_LANGUAGE][1]%> </th>
                                            <th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][7]%> </th>
                                            <th style="width: 20%"> <%= textHeaderTable[SESS_LANGUAGE][3]%> </th>
                                            <th style="width: 20%"> <%= textHeaderTable[SESS_LANGUAGE][4]%> </th>
                                            <th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][5]%> </th>
                                            <th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][6]%> </th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <!-- ========================================= MODAL ============================================  -->								

        <!-- ========================================= END OF MODAL ============================================  -->								

        <script>
            $(document).ready(function () {
                var searchResBox = $('#search-result-box');
                $(".select2").select2();

                searchResBox.hide();

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    var datafilter = "";
                    var privUpdate = "";
                    var searchForm = $('#form-search');
                    var url = "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FOR=" + dataFor + "&" + searchForm.serialize();
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({
                        "bDestroy": true,
                        "searching": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "order": [[1]],
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
                                "sLast ": "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                "sNext ": "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                "sPrevious ": "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            }
                        },
                        "bServerSide": true,
                        "sAjaxSource": url,
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [0, -1]
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
                function runDataTable() {
                    dataTablesOptions("#returnListTable", "returnList", "AjaxKredit", "listReturn", null);
                }

                if ("<%= iCommand%>" == "<%= Command.LIST%>") {
                    searchResBox.show();
                    runDataTable();
                }

                $('.datePicker').datetimepicker({
                    format: "yyyy-mm-dd",
                    todayBtn: true,
                    autoclose: true,
                    minView: 2
                });

                $('body').on('click', '#search-form-btn', function () {
                    searchResBox.show();
                    runDataTable();
                });

                $('body').on('click', '#create-form-btn', function () {
                    var url = "return_kredit.jsp";
                    window.location = url;
                });

                $('body').on('click', '.open-form-btn', function () {
                    var oid = $(this).val();
                    var oidPinjaman = $(this).data('oidpinjaman');

                    var url = "<%= approot%>/sedana/transaksikredit/form5c_edit.jsp?oidpinjaman=" + oidPinjaman + "&oidanalisamain=" + oid;
                    window.location = url;
                });

            });
        </script>				

    </body>
</html>

