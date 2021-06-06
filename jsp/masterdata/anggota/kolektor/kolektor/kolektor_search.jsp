<%-- 
    Document   : anggota_edit
    Created on : Feb 22, 2013, 9:50:44 AM
    Author     : HaddyPuutraa
--%>

<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.CtrlJenisDeposito"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisDeposito"%>
<%@ page language="java" %>

<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %> 
<%@ page import = "com.dimata.qdep.form.*" %>

<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.region.*" %>
<%@page import="com.dimata.aiso.form.masterdata.region.*" %>

<%@ include file = "../../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../../main/checkuser.jsp" %>

<%//Edit by Hadi untuk proses form koperasi
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privView = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
    if (!privView && !privAdd && !privUpdate && !privDelete) {
%>
<script language="javascript">
    window.location = "<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
} else {
%>

<!-- JSP Block -->
<%!
    public static String strTitle[][] = {
        {"Nomor Anggota",
            "Nama",//0
            "Jenis Kelamin",//1
            "Tempat Lahir",//2
            "Tanggal Lahir",//3
            "Pekerjaan",//4
            "Handphone",//5
            "Email",//6
            "Kota Alamat Kantor",//7
            "Posisi",//8
            "Alamat Asal",//9
            "Kota Asal",//10
            "Propinsi Asal",//11
            "Kabupaten Asal",//12
            "Kecamatan Asal",//13
            "Kelurahan",//14
            "Id Identitas KTP/SIM",//15
            "Masa Brlaku KTP",//16
            "Telepon",//17
            "Hand Phone",//18
            "Email",//19
            "Pendidikan",//20
            "No NPWP",//21
            "Status"},//22
        {"Member Number",
            "Name",//0
            "Sex",//1
            "Birth Place",//2
            "Birth Date",//3
            "Vocation",//4
            "Agencies",//5
            "Email",//6
            "Address Office City",//7
            "Position",//8
            "Address",//9
            "City",//10
            "Province",//11
            "Regency",//12
            "Sub Regency",//13
            "Ward",//14
            "ID Card",//15
            "Expired Date KTP",//16
            "Telephone",//17
            "Hand Phone",//18
            "Email",//19
            "Education",//20
            "No NPWP",//21
            "Status"}//22
    };

    public static final String systemTitle[] = {
        "Master Data", "Master Data"
    };

    public static final String userTitle[][] = {
        {"Anggota", "Cari"}, {"Anggota", "Search"}
    };

    public static final String errAnggota[] = {
        "List Anggota Tidak Ditemukan", "No Member List Available"
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

    public String drawListAnggota(int language, Vector objectClass, long oid, String namaNasabah) {
        String temp = "";
        String regdatestr = "";

        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");

        //untuk tabel
        ctrlist.dataFormat(" Nomor " + namaNasabah, "20%", "center", "left");//1
        ctrlist.dataFormat(strTitle[language][1], "25%", "center", "left");//2
        ctrlist.dataFormat(strTitle[language][2], "12%", "center", "left");//3
        ctrlist.dataFormat(strTitle[language][3], "12%", "center", "left");//4	
        ctrlist.dataFormat(strTitle[language][4], "10%", "center", "left");//5
        ctrlist.dataFormat(strTitle[language][5], "10%", "center", "left");//6
        ctrlist.dataFormat(strTitle[language][6], "25%", "center", "left");//7
        ctrlist.dataFormat(strTitle[language][7], "25%", "center", "left");//8
        ctrlist.dataFormat("Action", "10%", "center", "left");//9

        //ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        String tgl_lahir = "";
        for (int i = 0; i < objectClass.size(); i++) {
            Anggota anggota = (Anggota) objectClass.get(i);
            if (oid == anggota.getOID()) {
                index = i;
            }

            Vector rowx = new Vector();
            rowx.add(String.valueOf(anggota.getNoAnggota()));//1
            rowx.add(String.valueOf(anggota.getName()));//2
            if (anggota.getSex() == 0) {
                rowx.add("Laki-Laki");//2
            } else {
                rowx.add("Perempuan");//2
            }
            rowx.add(String.valueOf(anggota.getBirthPlace()));//3
            if (anggota.getBirthDate() != null) {
                try {
                    tgl_lahir = Formater.formatDate(anggota.getBirthDate(), "dd, MMM yyyy");
                } catch (Exception e) {
                    tgl_lahir = "";
                }
            } else {
                tgl_lahir = "";
            }
            rowx.add(String.valueOf(tgl_lahir));//4
            String pekerjaan = "";
            if (anggota.getVocationId() != 0) {
                pekerjaan = PstVocation.getNamaPekerjaan("" + PstVocation.fieldNames[PstVocation.FLD_VOCATION_ID] + "='" + anggota.getVocationId() + "'");
            }
            rowx.add(String.valueOf(pekerjaan));//5
            rowx.add(String.valueOf(anggota.getHandPhone()));//6
            rowx.add(String.valueOf(anggota.getEmail()));//7
            //rowx.add(String.valueOf(anggota.getAddressPermanent()));//8
            rowx.add(String.valueOf("<center><a class=\"btn-edit btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('" + anggota.getOID() + "')\">Edit</a></center>"));
            lstData.add(rowx);
            //lstLinkData.add(String.valueOf(anggota.getOID()));
        }
        return ctrlist.drawMe(index);
    }

%>

<%
    /* VARIABLE DECLARATION */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    int iErrCode = FRMMessage.NONE;
    String currPageTitle = userTitle[SESS_LANGUAGE][0];
    String strAddMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";

    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    long anggotaOID = FRMQueryString.requestLong(request, "anggota_oid");
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int print = FRMQueryString.requestInt(request, "print_nasabah");

    CtrlAnggota ctrlAnggota = new CtrlAnggota(request);
    FrmAnggota frmAnggota = ctrlAnggota.getForm();
    String strMasage = "";
    int excCode = ctrlAnggota.Action(iCommand, anggotaOID);
    Anggota anggota = ctrlAnggota.getAnggota();
    strMasage = ctrlAnggota.getMessage();

    /* VARIABLE DECLARATION Search*/
    int listCommand = FRMQueryString.requestInt(request, "list_command");
    String strAddAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSearchAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK_SEARCH, true);

    int recordToGet = 20;
    String whereClause = "";
    String order = "cl. " + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA];
    //update tanggal 14 Maret
    if (iCommand == Command.SEARCH) {
        String noAnggota = FRMQueryString.requestString(request, FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]);
        String namaAnggota = FRMQueryString.requestString(request, FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]);
        if (namaAnggota == "" && noAnggota != "") {
            whereClause += "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + noAnggota + "%'";
        } else if ((namaAnggota == "" && noAnggota == "") || (namaAnggota != "" && noAnggota != "")) {
            whereClause += " (cl." + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " LIKE '%" + noAnggota + "%' OR "
                    + "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + namaAnggota + "%' )";
        } else {
            whereClause += "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + namaAnggota + "%'";
        }
    } else {
        whereClause += "";
    }

	
    int vectSize = PstAnggota.getCountJoin(whereClause);

    if (iCommand != Command.BACK) {
        start = ctrlAnggota.actionList(iCommand, start, vectSize, recordToGet);
    } else {
        iCommand = Command.LIST;
    }
    Vector listAnggota = PstAnggota.listJoin(start, recordToGet, whereClause, order);
    
    Vector listNasabahIndividu = SessAnggota.listJoinContactClassAssign(0, 0, whereClause, order);
    if (print == 0) {
        listNasabahIndividu = new Vector();
    }
    
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
    <head>
        <!-- #BeginEditable "doctitle" --> 
        <title>Sistem Manajemen Simpan Pinjam</title>
        <script language="JavaScript">
            function cmdCancel() {
                //document.frmAnggota.anggota_oid.value=oid;
                document.frmAnggota.command.value = "<%=Command.EDIT%>";
                document.frmAnggota.action = "kolektor_search.jsp";
                document.frmAnggota.submit();
            }

            <% if (privAdd || privUpdate) {%>
            function cmdSave() {
                document.frmAnggota.command.value = "<%=Command.SAVE%>";
                document.frmAnggota.action = "kolektor_edit.jsp";
                document.frmAnggota.submit();
            }
            <%}%>

            <% if (privDelete) {%>
            function cmdAsk(oid) {
                document.frmAnggota.anggota_oid.value = oid;
                document.frmAnggota.command.value = "<%=Command.ASK%>";
                document.frmAnggota.action = "kolektor_edit.jsp";
                document.frmAnggota.submit();
            }

            function cmdDelete(oid) {
                document.frmAnggota.anggota_oid.value = oid;
                document.frmAnggota.command.value = "<%=Command.DELETE%>";
                document.frmAnggota.action = "kolektor_edit.jsp";
                document.frmAnggota.submit();
            }
            <%}%>

            function cmdEdit(oid) {
            <%if (privUpdate) {%>
                document.frmAnggota.anggota_oid.value = oid;
                document.frmAnggota.list_command.value = "<%=listCommand%>";
                document.frmAnggota.command.value = "<%=Command.EDIT%>";
                document.frmAnggota.action = "kolektor_edit.jsp";
                document.frmAnggota.submit();
            <%}%>
            }

            <%if (privAdd) {%>
            function cmdAdd() {
                document.frmAnggota.anggota_oid.value = "0";
                document.frmAnggota.list_command.value = "<%=listCommand%>";
                document.frmAnggota.command.value = "<%=Command.ADD%>";
                document.frmAnggota.action = "kolektor_edit.jsp";
                document.frmAnggota.submit();
            }
            <%}%>

            function cmdBack(oid) {
                document.frmAnggota.anggota_oid.value = oid;
                document.frmAnggota.command.value = "<%=Command.BACK%>";
                document.frmAnggota.action = "kolektor_search.jsp";
                document.frmAnggota.submit();
            }

            function cmdSearchAnggota() {
                anggota_number = document.frmAnggota.<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_ANGGOTA]%>.value;
                anggota_name = document.frmAnggota.<%=frmAnggota.fieldNames[frmAnggota.FRM_NAME_ANGGOTA]%>.value;
                document.frmAnggota.command.value = "<%=Command.SEARCH%>";
                document.frmAnggota.action = "kolektor_search.jsp?anggota_number=" + anggota_number + "&anggota_name=" + anggota_name;
                document.frmAnggota.submit();
            }



            function cmdSearch() {
                document.frmAnggota.command.value = "<%=Command.NONE%>";
                document.frmAnggota.action = "kolektor_search.jsp";
                document.frmAnggota.submit();
            }

            function cmdListFirst() {
                document.frmAnggota.command.value = "<%=Command.FIRST%>";
                document.frmAnggota.list_command.value = "<%=Command.FIRST%>";
                document.frmAnggota.action = "kolektor_search.jsp";
                document.frmAnggota.submit();
            }

            function cmdListPrev() {
                document.frmAnggota.command.value = "<%=Command.PREV%>";
                document.frmAnggota.list_command.value = "<%=Command.PREV%>";
                document.frmAnggota.action = "kolektor_search.jsp";
                document.frmAnggota.submit();
            }

            function cmdListNext() {
                document.frmAnggota.command.value = "<%=Command.NEXT%>";
                document.frmAnggota.list_command.value = "<%=Command.NEXT%>";
                document.frmAnggota.action = "kolektor_search.jsp";
                document.frmAnggota.submit();
            }

            function cmdListLast() {
                document.frmAnggota.command.value = "<%=Command.LAST%>";
                document.frmAnggota.list_command.value = "<%=Command.LAST%>";
                document.frmAnggota.action = "kolektor_search.jsp";
                document.frmAnggota.submit();
            }
        </script>
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" --> 
        <SCRIPT language=JavaScript>
            function hideObjectForMenuJournal() {
            }

            function hideObjectForMenuReport() {
            }

            function hideObjectForMenuPeriod() {
            }

            function hideObjectForMenuMasterData() {
            }

            function hideObjectForMenuSystem() {
            }

            function showObjectForMenu() {
            }
        </SCRIPT>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <!--link rel="stylesheet" href="../../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../../dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="../../../dtree/dtree.js"></script>

        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="../../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="../../../style/AdminLTE-2.3.11/plugins/font-awesome-4.7.0/css/font-awesome.min.css">        
        <!-- Datetime Picker -->
        <link href="../../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <!-- Select2 -->
        <link rel="stylesheet" href="../../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="../../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="../../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
        <link href="../../../style/datatables/dataTables.bootstrap.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../../../style/bootstrap-notify/bootstrap-notify.css"/>
        <!-- jQuery 2.2.3 -->
        <script src="../../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <!-- Bootstrap 3.3.6 -->
        <script src="../../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="../../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>
        <!-- AdminLTE for demo purposes -->
        <script src="../../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
        <!-- AdminLTE App -->
        <script type="text/javascript" src="../../../style/bootstrap-notify/bootstrap-notify.js"></script>
        <script src="../../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>    
        <script src="../../../style/dist/js/dimata-app.js" type="text/javascript"></script>
        <!-- Select2 -->
        <script src="../../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
        <!-- Datetime Picker -->
        <script src="../../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <script src="../../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
        <script src="../../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            th:after {display: none !important;}
            table {font-size: 14px}

            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }
            @media print
            {
                body .main-page * { visibility: hidden; display: none; } 
                body print-area * { visibility: visible; }
                body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
            }
        </style>
        <script language="javascript">
            $(document).ready(function () {

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "oPaginate": {
                                "sFirst ": "<%=dataTableTitle[SESS_LANGUAGE][6]%>",
                                "sLast ":  "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                "sNext ":  "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                "sPrevious ":   "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            },
                            "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></div>",
                            "sLengthMenu": "<%=dataTableTitle[SESS_LANGUAGE][0]%>",
                            "sZeroRecords": "<%=dataTableTitle[SESS_LANGUAGE][1]%>",
                            "sInfo": "<%=dataTableTitle[SESS_LANGUAGE][2]%>",
                            "sInfoEmpty": "<%=dataTableTitle[SESS_LANGUAGE][3]%>",
                            "sInfoFiltered": "<%=dataTableTitle[SESS_LANGUAGE][4]%>",
                            "sSearch": "<%=dataTableTitle[SESS_LANGUAGE][5]%>"
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>",
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
                    dataTablesOptions("#individuTableElement", "tableIndividuTableElement", "AjaxAnggota", "listKL", null);
                }

                runDataTable();

                $('#btn_print').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "anggota_search.jsp?print_nasabah=1";
                });
                
                $('body').on("click",".btn-edit",function() {
                    $(this).attr({"disabled":true}).html('<i class="fa fa-spinner fa-pulse"></i>');
                });
                
                if ("<%= print %>" === "1") {
                    window.print();
                }

            });
        </script>
    </head> 

    <body style="background-color: #eaf3df;">   
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Daftar Kontak
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Master Kredit</li>
                    <li class="active">Kontak</li>
                </ol>
            </section>

            <section class="content">
                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Daftar Kontak</h3>
                    </div>

                    <p></p>

                    <div class="box-body">

                        <div id="individuTableElement" class="">
                            <table class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th style="width: 1%">No.</th>                                    
                                        <th>Nomor Kontak</th>
                                        <th>Nama Kontak</th>
                                        <th>Jenis Kelamin</th>
                                        <th>Tempat Lahir</th>
                                        <th>Tanggal Lahir</th>
                                        <th>Pekerjaan</th>
                                        <th>Handphone</th>
                                        <th>Telepon</th>
                                        <th>Alamat</th>
                                        <th>Kontak Tipe</th>
                                        <th style="width: 1%">Aksi</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                                    
                        <form name="frmAnggota" method="get" action="" class="form-horizontal">
                            <input type="hidden" name="command" value="">
                            <input type="hidden" name="anggota_oid" value="<%=anggotaOID%>">
                            <input type="hidden" name="start" value="<%=start%>">	
                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                            <input type="hidden" name="list_command" value="<%=listCommand%>">

                            <br>
                            <% if (privAdd) {%>
                            <button type="button" class="btn btn-sm btn-primary" onclick="javascript:cmdAdd()"><i class="fa fa-plus"></i> &nbsp; Tambah Anggota</button>
                            <%}%>
                            <% if (listNasabahIndividu.size() > 0) { %>
                                <button type="button" id="btn_print" class="btn btn-sm btn-primary pull-right"><i class="fa fa-print"></i> &nbsp; Cetak Seluruh Data <%=namaNasabah%></button>
                            <% } %>
                        </form>                                                       
                    </div>
                </div>

            </section>
        </div>

        <!--------------------------------------------------------------------->

    <print-area>
        <div style="size: A4;" class="">
            <div style="width: 50%; float: left;">
                <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
            </div>
            <div style="width: 50%; float: right; text-align: right">
                <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">DATA SELURUH <%=namaNasabah.toUpperCase()%> INDIVIDU</span>
                <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
            </div>
            <div class="clearfix"></div>
            <hr class="" style="border-color: gray">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Nomor <%=namaNasabah%></th>
                        <th>Nama <%=namaNasabah%></th>
                        <th>Jenis Kelamin</th>
                        <th>Tempat Lahir</th>
                        <th style="width: 100px">Tanggal Lahir</th>
                        <th>Pekerjaan</th>
                        <th>Nomor Telepon</th>
                        <th>Nomor Handphone</th>
                        <th>Alamat</th>
                    </tr>  
                </thead>
                <tbody>
                    <%
                        for (int i = 0; i < listNasabahIndividu.size(); i++) {
                            Anggota a = (Anggota) listNasabahIndividu.get(i);
                            Vocation v = new Vocation();
                            try {
                                v = PstVocation.fetchExc(a.getVocationId());
                            } catch (Exception exc) {

                            }
                    %>
                    <tr>
                        <td><%=(i + 1)%></td>
                        <td><%=a.getNoAnggota()%></td>
                        <td><%=a.getName()%></td>
                        <td><%=PstAnggota.sexKey[0][a.getSex()]%></td>
                        <td><%=a.getBirthPlace()%></td>
                        <td><%=a.getBirthDate()%></td>
                        <td><%=v.getVocationName()%></td>
                        <td><%=a.getTelepon()%></td>
                        <td><%=a.getHandPhone()%></td>
                        <td><%=a.getAddressPermanent()%></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </print-area>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>