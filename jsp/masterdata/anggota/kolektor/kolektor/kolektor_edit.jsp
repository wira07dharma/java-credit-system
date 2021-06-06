<%--
    Document   : anggota_edit
    Created on : Feb 28, 2013, 9:50:44 AM
    Author     : HaddyPuutraa
--%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.common.entity.contact.PstContactClassAssign"%>
<%@page import="com.dimata.common.entity.contact.ContactClassAssign"%>
<%@page import="com.dimata.common.entity.contact.ContactClass"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.common.form.contact.FrmContactClass"%> 
<%@page import="java.io.File"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.PstAssignTabungan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.AssignTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.AssignContact"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstAssignContact"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="javax.print.DocFlavor.STRING"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package aiso -->
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.region.*" %>
<%@page import="com.dimata.aiso.form.masterdata.region.*" %>

<%@include file="../../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../../main/checkuser.jsp" %>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
    boolean privPrint = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
%>

<%!
    public static String strTitle[][] = {
        {
			"No Anggota",//0
            "Nama",//1
            "Jenis Kelamin",//2
            "Tempat Lahir",//3
            "Tanggal Lahir",//4
            "Pekerjaan",//5
            "Agensi",//6
            "Alamat Kantor",//7
            "Kota Alamat Kantor",//8
            "Posisi",//9
            "Alamat Asal",//10
            "Kota Asal",//11
            "Propinsi Asal",//12
            "Kabupaten Asal",//13
            "Kecamatan Asal",//14
            "Kelurahan",//15
            "Id Identitas KTP/SIM",//16
            "Masa Brlaku KTP",//17
            "Telepon",//18
            "Hand Phone",//19
            "Email",//20
            "Pendidikan",//21
            "No NPWP",//22
            "Status",//23
            "Nomor Rekening",//24
            "Tanggal Regristrasi",//25
			"Lokasi Tugas"//26
		},{
			"Member ID",//0
            "Name",//1
            "Sex",//2
            "Birth of Place",//3
            "Birth of Date",//4
            "Vocation",//5
            "Agencies",//6
            "Office Address",//7
            "Address Office City",//8
            "Position",//9
            "Address",//10
            "City",//11
            "Province",//12
            "Regency",//13
            "Sub Regency",//14
            "Ward",//15
            "ID Card",//16
            "Expired Date KTP",//17
            "Telephone",//18
            "Hand Phone",//19
            "Email",//20
            "Education",//21
            "No NPWP",//22
            "Status",//23
            "Rekening Number",//24
            "Regristation Date",//25
			"Assign Location"//26
		}
    };

    public static final String systemTitle[] = {
        "Kontak", "Member"
    };

    public static final String userTitle[][] = {
        {"Tambah", "Edit"}, {"Add", "Edit"}
    };

    public static final String tabTitle[][] = {
        {"Data Pribadi", "Anggota Keluarga", "Registrasi Tabungan", "Pendidikan", "Data Tabungan", "Dokumen Bersangkutan"}, 
        {"Personal Date", "Family Member", "Saving Registration", "Education", "Saving Type", "Relevant Document"}
    };
%>

<%
    CtrlAnggota ctrlAnggota = new CtrlAnggota(request);
    long oidAnggota = FRMQueryString.requestLong(request, "anggota_oid");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int hidden_command = FRMQueryString.requestInt(request, "hidden_flag_cmd");
    int statusUpload = FRMQueryString.requestInt(request, "status");
    String pesanUpload = FRMQueryString.requestString(request, "message");

    int iErrCode = FRMMessage.ERR_NONE;
    String errMsg = "";
    String whereClause = "";
    String orderClause = "";
    int start = FRMQueryString.requestInt(request, "start");
    //untuk tab edit Personal data oleh hadi tanggal 2 Maret 2013
    int iCommand = FRMQueryString.requestCommand(request);
    if (oidAnggota != 0 && iCommand == Command.NONE) {
        iCommand = Command.EDIT;
    } else {
        iCommand = FRMQueryString.requestCommand(request);
    }
    
    String lokasiSimpanFoto = PstSystemProperty.getValueByName("PHOTO_LOCATION_PATH");
    String lokasiAmbilFoto = PstSystemProperty.getValueByName("PHOTO_LOCATION_GET_PATH");
    
    Anggota a = new Anggota();
    if (oidAnggota != 0) {
        a = PstAnggota.fetchExc(oidAnggota);
    }
    String pathDelete = "" + lokasiSimpanFoto + File.separator + a.getFotoAnggota();
    File lastName = new File(pathDelete);

    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = systemTitle[SESS_LANGUAGE];
    String strAddAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";
    String saveConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Data Member Success" : "Simpan Data Sukses");

    ctrlAnggota.setLanguage(SESS_LANGUAGE);
    iErrCode = ctrlAnggota.Action(iCommand, oidAnggota);

    errMsg = ctrlAnggota.getMessage();
    FrmAnggota frmAnggota = ctrlAnggota.getForm();
    Anggota anggota = ctrlAnggota.getAnggota();


//	if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmAnggota.errorSize()<1)){
    if (iCommand == Command.DELETE && iErrCode == 0) {
        lastName.delete();
%>
<jsp:forward page="anggota_search.jsp">
    <jsp:param name="prev_command" value="<%=prevCommand%>" />
    <jsp:param name="start" value="<%=start%>" />
    <jsp:param name="anggota_oid" value="<%=anggota.getOID()%>" />
</jsp:forward>
<%
    }
    boolean isCopy = FRMQueryString.requestBoolean(request, "hidden_copy_status");
    long gotoAnggota = FRMQueryString.requestLong(request, "hidden_goto_anggota");
%>

<!-- End of Jsp Block -->
<html>
    <!-- #BeginTemplate "/Templates/maintab.dwt" -->
    <head>

        <!-- #BeginEditable "doctitle" -->
        <title>Koperasi - Anggota</title>
        <script language="JavaScript">

            function cmdSearchEmp() {
                window.open("<%=approot%>/employee/search/search.jsp?formName=frmAnggota&employeeOID=<%=String.valueOf(oidAnggota)%>&empPathId=<%=frmAnggota.fieldNames[frmAnggota.FRM_NAME_ANGGOTA]%>",
                                "Search_HOD", "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    }

                    function cmdClearSearchEmp() {
                        document.frmAnggota.EMP_NUMBER.value = "";
                        document.frmAnggota.EMP_FULLNAME.value = "";
                        document.frmAnggota.EMP_DEPARTMENT.value = "";
                    }

                    function updateGeoAddressPmnt() {
                        oidProvince = document.frmAnggota.<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_PROVINCE_ID]%>.value;
                        oidCity = document.frmAnggota.<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_CITY_PERMANENT]%>.value;
                        oidRegency = document.frmAnggota.<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_PMNT_REGENCY_ID]%>.value;
                        oidSubRegency = document.frmAnggota.<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_PMNT_SUBREGENCY_ID]%>.value;
                        oidWard = document.frmAnggota.<%=frmAnggota.fieldNames[frmAnggota.FRM_WARD_ID]%>.value;
                        window.open("<%=approot%>/masterdata/anggota/geo_area_anggota.jsp?formName=frmAnggota&anggota_oid=<%=String.valueOf(oidAnggota)%>&addresstype=1&" +
                                "<%=FrmWard.fieldNames[FrmWard.FRM_WARD_PROVINCE_ID]%>=" + oidProvince + "&" +
                                "<%=FrmWard.fieldNames[FrmWard.FRM_WARD_CITY_ID]%>=" + oidCity + "&" +
                                "<%=FrmWard.fieldNames[FrmWard.FRM_WARD_REGENCY_ID]%>=" + oidRegency + "&" +
                                "<%=FrmWard.fieldNames[FrmWard.FRM_WARD_SUBREGENCY_ID]%>=" + oidSubRegency + "&" +
                                "<%=FrmWard.fieldNames[FrmWard.FRM_WARD_ID]%>=" + oidWard + "&anggota=<%=(anggota.getNoAnggota() + " / " + anggota.getName())%>",
                                null, "height=297, width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    }

                    function cmdAdd() {
                        document.frmAnggota.command.value = "<%=Command.ADD%>";
                        document.frmAnggota.action = "kolektor_edit.jsp";
                        document.frmAnggota.anggota_oid.value = 0;
                        document.frmAnggota.submit();
                    }

                    function cmdCancel() {
                        document.frmAnggota.command.value = "<%=Command.CANCEL%>";
                        document.frmAnggota.action = "kolektor_edit.jsp";
                        document.frmAnggota.submit();
                    }

                    function cmdEdit(oid) {
                        document.frmAnggota.command.value = "<%=Command.EDIT%>";
                        document.frmAnggota.action = "kolektor_edit.jsp";
                        document.frmAnggota.submit();
                    }

                    function cmdSave() {
                        document.frmAnggota.command.value = "<%=Command.SAVE%>";
                        document.frmAnggota.action = "kolektor_edit.jsp";
                        basicAjax(baseUrl("ajax/validation.jsp"), function(data){
                          if(data.status=="true"){
                            document.frmAnggota.submit();
                          } else {
                            alert("KTP tidak dapat didaftarkan karena sudah digunakan");
                          }
                        }, {
                          dataFor:"validateUniqueKTP",
                          id:document.frmAnggota.<%=frmAnggota.fieldNames[frmAnggota.FRM_ID_CARD]%>.value,
                          oid_anggota:document.frmAnggota.anggota_oid.value
                        });
                    }

                    function cmdAsk(oid) {
                        document.frmAnggota.command.value = "<%=Command.ASK%>";
                        document.frmAnggota.action = "kolektor_edit.jsp";
                        document.frmAnggota.submit();
                    }

                    function cmdConfirmDelete(oid) {
                        document.frmAnggota.command.value = "<%=Command.DELETE%>";
                        document.frmAnggota.action = "kolektor_edit.jsp";
                        document.frmAnggota.submit();
                    }

                    function cmdBack() {
                        document.frmAnggota.command.value = "<%=Command.FIRST%>";
                        document.frmAnggota.action = "kolektor_search.jsp";
                        document.frmAnggota.submit();
                    }

                    function cmdSearchEmp_old() {
                        emp_number = document.frmAnggota.EMP_NUMBER.value;
                        emp_fullname = document.frmAnggota.EMP_FULLNAME.value;
                        emp_department = document.frmAnggota.EMP_DEPARTMENT.value;
                        emp_section = document.frmAnggota.EMP_SECTION.value;
                        emp_edit = document.frmAnggota.<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>.value;
                        window.open("empsearch.jsp?emp_number=" + emp_number + "&emp_fullname=" + emp_fullname + "&emp_department=" + emp_department + "&emp_edit=" + emp_edit + "&emp_section=" + emp_section);

                    }

                    function cmdClearSearchEmp_old() {
                        document.frmAnggota.EMP_NUMBER.value = "";
                        document.frmAnggota.EMP_FULLNAME.value = "";
                    }

                    function cmdCopyPaste(oid) {
                        document.frmAnggota.command.value = "<%=String.valueOf(Command.SAVE)%>";
                        document.frmAnggota.hidden_copy_status.value = true;
                        document.frmAnggota.action = "kolektor_edit.jsp";
                        document.frmAnggota.submit();
                    }

        </script>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../../dtree/dtree.css" type="text/css" />
        <!--link rel="stylesheet" href="../../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css"-->
        <script type="text/javascript" src="../../../dtree/dtree.js"></script>
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
        <!-- jQuery 2.2.3 -->
        <script src="../../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <script src="../../../style/lib.js"></script>
        <script src="../../../style/dist/js/dimata-app.js" type="text/javascript"></script>
        <style>
            .print-area { visibility: hidden; display: none; }
            .print-area.print-preview { visibility: visible; display: block; }
            @media print
            {
                body * { visibility: hidden; }
                .print-area * { visibility: visible; }
                .print-area   { visibility: visible; display: block; position: fixed; top: 0; left: 0; }
            }
            .tabel_data {
                border-collapse: collapse;
            }
            .tabel_data td {
                padding: 5px 8px;
            }
            .tabel_data th {
                padding: 5px 8px;
                font-size: 12px;
                font-weight: normal;
            }

            .label-button {
                border-style: solid;
                border-width: thin;
                border-color: grey;
                border-radius: 2px;
                padding: 3px 5px;
                cursor: pointer;
            }
            
            .modal::before {
                content: '';
                display: inline-block;
                height: 100%;
                vertical-align: middle;
                margin: 0;
              }
              
             .target {
                display: block;
                left: 0;
                position: fixed;
                top: 0;
                width: 0;
                height: 0;
                visibility: hidden;
                pointer-events: none;
               }

              .modal {
                position: fixed;
                top: 0;
                right: 0;
                left: 0;
                bottom: 0;
                z-index: 100;
                text-align: center;
                display: none;
                /* Fallback for legacy browsers */
                background-color: rgba(0,0,0,0.6);
              }
              .modal > .content {
                 text-align: left;
                 display: inline-block;
                 background-color: #ffffff;
                 box-sizing: border-box;
                 color: white;
                 position: relative;
                 width: 700px;
                 padding: 20px;
               }

               .modal > .content .close-btn {
                  position: absolute;
                  top: 18px;
                  right: 18px;
                  width: 15px;
                  height: 15px;
                  color: black;
                  font-size: 18px;
                  text-decoration: none;
               }

               /* Behaviour on legacy browsers */
              .target:target + .modal {
                  display: block;
              }

              /* Fallback for IE8 */
              .modal.is-expanded {
                 display: block;
              }
              .modal.is-expanded > .content {
                top: 50%;
                margin-top: -45px;
              }

              /* Making main page blurred when modal window open */
              :root .target:target ~ .page-container {
                 filter: blur(5px);
                -webkit-filter: blur(5px);
                filter: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' ><filter id='blur5'><feGaussianBlur in='SourceGraphic' stdDeviation='5' /></filter></svg>#blur5");
                filter:progid:DXImageTransform.Microsoft.Blur(PixelRadius='5');
                overflow: hidden;
              }
              :root span[id="start"]:target ~ .page-container {
               filter: none;
               -webkit-filter: none;
              }

              /* Behavior on modern browsers */
              :root .modal {
                display: block;
                background-color: transparent;
                transition: transform 0.3s cubic-bezier(0.5, -0.5, 0.5, 1.5);
                transform-origin: center center;
                transform: scale(0, 0);
              }
              :root .modal > .content {
                box-shadow: 0 5px 20px rgba(0,0,0,0.5);
              }
              :root .target:target + .modal {
                transform: scale(1, 1);
              } 

            #container {
                margin: 0px auto;
                width: 500px;
                height: 375px;
                border: 10px #333 solid;
            }
            #videoElement {
                width: 500px;
                height: 375px;
                background-color: #666;
            }
        </style>
        <SCRIPT language=JavaScript>
                    $(document).ready(function () {

                        var getDataFunction = function (onDone, onSuccess, dataSend, servletName, dataAppendTo, notification) {
                            $(this).getData({
                                onDone: function (data) {
                                    onDone(data);
                                },
                                onSuccess: function (data) {
                                    onSuccess(data);
                                },
                                approot: "<%=approot%>",
                                dataSend: dataSend,
                                servletName: servletName,
                                dataAppendTo: dataAppendTo,
                                notification: notification
                            });
                        };

                        $('#btn_upload').click(function () {
                            var foto = $('#btn_browse').val();
                            if (foto === "") {
                                alert("Silakan pilih foto terlebih dahulu");
                            } else {
                                $('#formUpload').submit();
                            }
                        });

                        $('#btn_printNasabah').click(function () {
                            var buttonHtml = $(this).html();
                            $(this).attr({"disabled": "true"}).html("Tunggu...");
                            window.print();
                            $(this).removeAttr('disabled').html(buttonHtml);
                        });

                    });

                    ////////////////////////////////////////////////////////////

                    var loadFile = function (event) {
                        var output = document.getElementById('output');
                        output.src = URL.createObjectURL(event.target.files[0]);
                    };

                    function MM_preloadImages() { //v3.0
                        var d = document;
                        if (d.images) {
                            if (!d.MM_p)
                                d.MM_p = new Array();
                            var i, j = d.MM_p.length, a = MM_preloadImages.arguments;
                            for (i = 0; i < a.length; i++)
                                if (a[i].indexOf("#") != 0) {
                                    d.MM_p[j] = new Image;
                                    d.MM_p[j++].src = a[i];
                                }
                        }
                    }

                    function MM_findObj(n, d) { //v4.0
                        var p, i, x;
                        if (!d)
                            d = document;
                        if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
                            d = parent.frames[n.substring(p + 1)].document;
                            n = n.substring(0, p);
                        }
                        if (!(x = d[n]) && d.all)
                            x = d.all[n];
                        for (i = 0; !x && i < d.forms.length; i++)
                            x = d.forms[i][n];
                        for (i = 0; !x && d.layers && i < d.layers.length; i++)
                            x = MM_findObj(n, d.layers[i].document);
                        if (!x && document.getElementById)
                            x = document.getElementById(n);
                        return x;
                    }

                    function MM_swapImage() { //v3.0
                        var i, j = 0, x, a = MM_swapImage.arguments;
                        document.MM_sr = new Array;
                        for (i = 0; i < (a.length - 2); i += 3)
                            if ((x = MM_findObj(a[i])) != null) {
                                document.MM_sr[j++] = x;
                                if (!x.oSrc)
                                    x.oSrc = x.src;
                                x.src = a[i + 2];
                            }
                    }

        </SCRIPT>
        <!-- #EndEditable -->
    </head>
    <body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg')">

        <table width="100%" border="0" cellspacing="0" cellpadding="0"  bgcolor="#F9FCFF">
            <%--<tr>
                <td bgcolor="#9BC1FF"  valign="middle" height="15" class="contenttitle">
                    <font color="#FF6600" face="Arial">
                    <!-- #BeginEditable "contenttitle" -->
                    <%=systemTitle[SESS_LANGUAGE]%>&nbsp;
                    <%
                        if(oidAnggota != 0){
                            out.print(userTitle[SESS_LANGUAGE][1]);
                        } else{
                            out.print(userTitle[SESS_LANGUAGE][0]);
                        }
                    %><font color="000000"><strong>&nbsp;>> </strong></font><%=tabTitle[SESS_LANGUAGE][0]%>
                    <!-- #EndEditable --> 
                   </font>
                </td>
            </tr>--%>
            <tr> 
                <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
                    <b><%=systemTitle[SESS_LANGUAGE]%> > <%=oidAnggota != 0 ? userTitle[SESS_LANGUAGE][1].toUpperCase() : userTitle[SESS_LANGUAGE][0].toUpperCase()%></b>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td  bgcolor="#9BC1FF" valign="middle">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>

                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td width="88%" valign="top" align="left">
                                <table width="100%" border="0" cellspacing="3" cellpadding="2">
                                    <tr>
                                        <td width="100%">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td valign="top">
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                        <tr>
                                                                            <td valign="top"> <!-- #BeginEditable "content" -->     
                                                                                <% if (anggota.getOID() != 0) {%>                                                                                                                                            
                                                                                <form id="formUpload" class="form-horizontal" action="<%=approot%>/AjaxUploadFile?anggota_oid=<%=anggota.getOID()%>&SEND_ROOT=<%=approot%>&SEND_LOCATION=<%=lokasiSimpanFoto%>" method="post" enctype="multipart/form-data">    
                                                                                    <div>
                                                                                        <!--label class="" for="<%= frmAnggota.fieldNames[frmAnggota.FRM_FOTO_ANGGOTA]%>">Unggah Foto <%=namaNasabah%> &nbsp; (.jpg/.JPG/.jpeg/.JPEG) </label-->
                                                                                        <input type="file" name="file" id="btn_browse" style="display: none" accept=".jpg" onchange="loadFile(event)" />                                                                                                                                                                                
                                                                                    </div>
                                                                                </form>

                                                                                <% }%>
                                                                                <form name="frmAnggota" method="post" action="">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="hidden_goto_anggota" value="<%=String.valueOf(gotoAnggota)%>">
                                                                                    <input type="hidden" name="hidden_copy_status">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="anggota_oid" value="<%=anggota.getOID()%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="hidden_flag_cmd" value="<%=hidden_command%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">

                                                                                        <% if (oidAnggota != 0 || (anggota.getOID() != 0 && iErrCode == Command.NONE && iCommand == Command.SAVE)) {
                                                                                                oidAnggota = anggota.getOID();//karena ada proses save baru update tanggal 2 Maret oleh Hadi
                                                                                        %>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <br>
                                                                                                <table width="98%" align="center" border="0" cellspacing="2" cellpadding="2" height="26">
                                                                                                    <tr style="height: 35px;">

                                                                                                        <%-- TAB MENU --%>
                                                                                                        <%-- active tab --%>
                                                                                                        <td width="20%" style="background-color: #337ab7">
                                                                                                            <!-- Data Personal -->
                                                                                                            <div align="center" class="">
                                                                                                              <a href="../anggota_edit.jsp?anggota_oid=<%=oidAnggota%>" style="color: white; text-decoration: none;" class=""><%=tabTitle[SESS_LANGUAGE][0]%></a>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="20%" style="background-color: lightgray">
                                                                                                            <!-- Pendidikan-->
                                                                                                            <div align="center"  class="">
                                                                                                              <a href="../anggota_education.jsp?anggota_oid=<%=oidAnggota%>" style="color: black; text-decoration: none;" class=""><%=tabTitle[SESS_LANGUAGE][3]%></a>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="20%" style="background-color: lightgray">
                                                                                                            <!-- Keluarga Anggota-->
                                                                                                            <div align="center"  class="">
                                                                                                              <a href="../anggota_family.jsp?anggota_oid=<%=oidAnggota%>" style="color: black; text-decoration: none;" class=""><%=tabTitle[SESS_LANGUAGE][1]%></a>
                                                                                                            </div>
                                                                                                        </td>                                                                                                        
                                                                                                        <td width="20%" style="background-color: lightgray">
                                                                                                            <!-- Pendidikan-->
                                                                                                            <div align="center"  class="">
                                                                                                              <a href="../anggota_tabungan.jsp?anggota_oid=<%=oidAnggota%>" style="color: black; text-decoration: none;" class=""><%=tabTitle[SESS_LANGUAGE][4]%></a>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="20%" style="background-color: lightgray">
                                                                                                            <!-- Keluarga Anggota-->
                                                                                                            <div align="center"  class="">
                                                                                                              <a href="../anggota_dokumen.jsp?anggota_oid=<%=oidAnggota%>" style="color: black; text-decoration: none;" class=""><%=tabTitle[SESS_LANGUAGE][5]%></a>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <%-- END TAB MENU --%>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td class="tablecolor">
                                                                                                <table  width="98%" align="center" border="0" cellspacing="2" cellpadding="2" bgcolor="#F5F7FA">
                                                                                                    <tr>
                                                                                                        <td valign="top">
                                                                                                            <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                                                                                                <tr>
                                                                                                                    <td valign="top" width="100%">
                                                                                                                        <table width="100%" border="0" cellspacing="2" cellpadding="2" >
                                                                                                                            <tr>                                                                                                                                
                                                                                                                                <td width="2%" height="20">&nbsp;</td>
                                                                                                                                <% if (anggota.getOID() != 0) {%>
                                                                                                                                <td width="15%" class="" height="20">Foto <%=namaNasabah%></td>
                                                                                                                                <td width="30%" class="" height="20">                                                                                                                                     
                                                                                                                                    <!--input type="file" name="foto" accept="image/*" onchange="loadFile(event)"-->                                                                                                                                     
                                                                                                                                    <%
                                                                                                                                        //String path = approot + lokasiAmbilFoto + anggota.getFotoAnggota();
                                                                                                                                        String path = lokasiAmbilFoto + anggota.getFotoAnggota();
                                                                                                                                    %>                                                                                                                                    
                                                                                                                                    <img id="output" height="auto" width="200" src="<%=path%>" alt=""/>
                                                                                                                                    <p></p>
                                                                                                                                    <% if (statusUpload == 1) {%>                                                                                                                                    
                                                                                                                                    Jika foto tidak muncul klik di <a href="anggota_edit.jsp?anggota_oid=<%=oidAnggota%>&datetime=<%=new Date()%>"><b>SINI</b></a>.
                                                                                                                                    <% } else {%>
                                                                                                                                    <%=pesanUpload%>
                                                                                                                                    <% } %>
                                                                                                                                    <p></p>
                                                                                                                                    <label class="label-button" for="btn_browse">Pilih foto</label>
                                                                                                                                    &nbsp;
                                                                                                                                    <a class="label-button" id="takePicture" href="#about">Ambil foto</a>
                                                                                                                                    &nbsp;
                                                                                                                                    <button type="button" id="btn_upload">Simpan foto</button>
                                                                                                                                </td>
                                                                                                                                <% } else {%>
                                                                                                                                <td width="15%" class="" height="20"></td>
                                                                                                                                <td width="30%" class="" height="20"></td>
                                                                                                                                <% }%>
                                                                                                                                <td width="45%" colspan="2" height="20">
                                                                                                                                    <!-- status dan tanggal registrasi -->
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <!--tanggal registrasi -->
                                                                                                                                            <td width="5%">&nbsp;</td>
                                                                                                                                            <td width="30%" height="30">
                                                                                                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][25]%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="2%">:</td>
                                                                                                                                            <td width="58%">
                                                                                                                                                <%if (anggota.getTanggalRegistrasi() != null) {%>
                                                                                                                                                <%=Formater.formatDate(anggota.getTanggalRegistrasi(), "MMM, dd yyyy")%>
                                                                                                                                                <%} else {%>
                                                                                                                                                <%=Formater.formatDate(new Date(), "MMM, dd yyyy")%>                                                            
                                                                                                                                                <%}%>&nbsp;
                                                                                                                                                <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_REGRISTATION_DATE]%>" value="<%=anggota.getTanggalRegistrasi()%>">
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <!--status -->
                                                                                                                                            <td width="5%">&nbsp;</td>
                                                                                                                                            <td width="30%" height="30">
                                                                                                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][23]%></div>
                                                                                                                                            </td>
                                                                                                                                            <td width="2%">:</td>
                                                                                                                                            <td width="58%">
                                                                                                                                                <%
                                                                                                                                                    ControlCombo combo = new ControlCombo();
                                                                                                                                                    Vector keyStatus = PstAnggota.getStatusKey();
                                                                                                                                                    Vector valueStatus = PstAnggota.getStatusValue();
                                                                                                                                                %>
                                                                                                                                                <%=combo.draw(frmAnggota.fieldNames[frmAnggota.FRM_STATUS], "", null, "" + anggota.getStatus(), valueStatus, keyStatus)%> 
                                                                                                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_STATUS)%>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td width="2%" height="10">&nbsp;</td>
                                                                                                                                <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                                                                                                <td width="35%" class="comment" height="20">
                                                                                                                                    &nbsp;
                                                                                                                                </td>
                                                                                                                                <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                                                                                                <td width="35%" height="20">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="20">&nbsp;</td>
                                                                                                                                <td class="txtheading1" height="20">&nbsp;</td>
                                                                                                                                <td class="comment" height="20">
                                                                                                                                    <div align="left">*) entry required</div>
                                                                                                                                </td>
                                                                                                                                <td class="txtheading1" height="20">&nbsp;</td>
                                                                                                                                <td height="20">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <td valign="top">
                                                                                                                                    <!-- Untuk No Anggota-->
                                                                                                                                    <div align="left">No <%=namaNasabah%></div>
                                                                                                                                </td>
                                                                                                                                <td> 
                                                                                                                                    <%
                                                                                                                                        String noAnggota = "Auto-Number";
                                                                                                                                        if(!anggota.getNoAnggota().equals("")) {
                                                                                                                                          noAnggota = anggota.getNoAnggota();
                                                                                                                                        }
                                                                                                                                        
                                                                                                                                        if (iCommand == Command.EDIT) {
                                                                                                                                            noAnggota = anggota.getNoAnggota();
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_ANGGOTA]%>" value="<%=noAnggota%>" class="" maxlength="20" size="40">
                                                                                                                                    * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_ANGGOTA)%>
                                                                                                                                </td>
                                                                                                                                <td valign="top"  >
                                                                                                                                    <!-- Untuk ID Card (KTP)-->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][16]%></div>
                                                                                                                                </td>
                                                                                                                                <td valign="top">
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ID_CARD]%>" value="<%=anggota.getIdCard()%>" class="" size="40" maxlength="50">
                                                                                                                                    * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_ID_CARD)%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <td valign="top">
                                                                                                                                    <!-- Untuk Nama Anggota-->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][1]%></div>
                                                                                                                                </td>
                                                                                                                                <td> 
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NAME_ANGGOTA]%>" value="<%=anggota.getName()%>" class="" maxlength="50" size="40">
                                                                                                                                    * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NAME_ANGGOTA)%>
                                                                                                                                </td>
                                                                                                                                <td valign="top"  >
                                                                                                                                    <!-- Untuk Email -->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][20]%></div>
                                                                                                                                </td>
                                                                                                                                <td valign="top">
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_EMAIL]%>" value="<%=anggota.getEmail()%>" maxlength="50" size="40" class="">
                                                                                                                                    * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_EMAIL)%>
                                                                                                                                </td>
                                                                                                                                <%--
                                                                                                                                <td  valign="top">
                                                                                                                                    <!-- Untuk Masa Berlaku ID Card-->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][17]%></div>
                                                                                                                                </td>
                                                                                                                                <td  valign="top">
                                                                                                                                    <%=ControlDate.drawDate(FrmAnggota.fieldNames[FrmAnggota.FRM_EXPIRED_DATE_KTP], anggota.getExpiredDateKtp(), "", 0, 5)%>                                                                                                                             
                                                                                                                                </td>
                                                                                                                                --%>
                                                                                                                            </tr>
                                                                                                                            <tr align="left">
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <td valign="top">
                                                                                                                                    <!-- Untuk Jenis Kelamin -->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][2]%></div>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <input type="radio" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_SEX]%>" value="<%= PstAnggota.sexValue[PstAnggota.MALE]%>" checked> <%= PstAnggota.sexKey[SESS_LANGUAGE][PstAnggota.MALE]%>
                                                                                                                                    <input type="radio" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_SEX]%>" value="<%= PstAnggota.sexValue[PstAnggota.FEMALE]%>" <% if (anggota.getSex() == PstAnggota.sexValue[PstAnggota.FEMALE]) {%> checked <% }%> > <%= PstAnggota.sexKey[SESS_LANGUAGE][PstAnggota.FEMALE]%>
                                                                                                                                    &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_SEX)%>                                                                                                                                
                                                                                                                                </td>
                                                                                                                                <!-- Untuk Pekerjaan -->
                                                                                                                                <td ><%=strTitle[SESS_LANGUAGE][5]%></td>
                                                                                                                                <td >
                                                                                                                                    <%
                                                                                                                                        ControlCombo comboBox = new ControlCombo();
                                                                                                                                        int countVocation = PstVocation.getCount("");
                                                                                                                                        Vector listVocation = PstVocation.list(0, countVocation, "", PstVocation.fieldNames[PstVocation.FLD_VOCATION_NAME]);
                                                                                                                                        Vector vocationKey = new Vector(1, 1);
                                                                                                                                        Vector vocationValue = new Vector(1, 1);

                                                                                                                                        for (int i = 0; i < listVocation.size(); i++) {
                                                                                                                                            Vocation vocation = (Vocation) listVocation.get(i);
                                                                                                                                            vocationKey.add(vocation.getVocationName());
                                                                                                                                            vocationValue.add(String.valueOf(vocation.getOID()).toString());
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                    <%=comboBox.draw(frmAnggota.fieldNames[frmAnggota.FRM_VOCATION_ID], "", "select...", "" + anggota.getVocationId(), vocationValue, vocationKey)%> 
                                                                                                                                    &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_VOCATION_ID)%>                                                                                                                               
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left">
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <td  valign="top"> 
                                                                                                                                    <!-- untuk tempat lahir-->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][3]%></div>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_BIRTH_PLACE]%>" value="<%=anggota.getBirthPlace()%>" class="" size="20">
                                                                                                                                    * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_BIRTH_PLACE)%>
                                                                                                                                </td>
                                                                                                                                <!-- untuk office address -->
                                                                                                                                <td valign="top">
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][7]%></div>
                                                                                                                                </td>
                                                                                                                                <td  valign="top">
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_OFFICE_ADDRESS]%>" value="<%=anggota.getOfficeAddress()%>" size="40" maxlength="50" class="">
                                                                                                                                    &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_OFFICE_ADDRESS)%>                                                                                                                           
                                                                                                                                </td>
                                                                                                                                <!-- untuk Agensi -->
                                                                                                                                <%--
                                                                                                                                <td>
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][6]%></div>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_AGENCIES] %>" value="<%=anggota.getAgencies()%>" class="" size="20">
                                                                                                                                    &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_AGENCIES) %>
                                                                                                                                </td>
                                                                                                                                --%>
                                                                                                                            </tr>

                                                                                                                            <tr align="left">
                                                                                                                                <td valign="top" height="25">&nbsp;</td>
                                                                                                                                <td valign="top"  >
                                                                                                                                    <!-- untuk Tanggal Lahir -->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][4]%></div>
                                                                                                                                </td>
                                                                                                                                <td  valign="top">
                                                                                                                                    <%=ControlDate.drawDate(frmAnggota.fieldNames[frmAnggota.FRM_BIRTH_DATE], anggota.getBirthDate(), "", 0, -100)%>
                                                                                                                                    * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_BIRTH_DATE)%>
                                                                                                                                </td>
                                                                                                                                <td  valign="top">
                                                                                                                                    <!-- untuk city office -->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][8]%></div>
                                                                                                                                </td>
                                                                                                                                <td valign="top">
                                                                                                                                    <%
                                                                                                                                        int countCityKantor = PstCity.getCount("");
                                                                                                                                        Vector listCityKantor = PstCity.list(0, countCityKantor, "", PstCity.fieldNames[PstCity.FLD_CITY_NAME]);
                                                                                                                                        Vector cityKantorKey = new Vector(1, 1);
                                                                                                                                        Vector cityKantorValue = new Vector(1, 1);

                                                                                                                                        for (int i = 0; i < listCityKantor.size(); i++) {
                                                                                                                                            City city = (City) listCityKantor.get(i);
                                                                                                                                            cityKantorKey.add(city.getCityName());
                                                                                                                                            cityKantorValue.add(String.valueOf(city.getOID()).toString());
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                    <%=comboBox.draw(frmAnggota.fieldNames[frmAnggota.FRM_ADDR_OFFICE_CITY], "", "select...", "" + anggota.getAddressOfficeCity(), cityKantorValue, cityKantorKey)%> 
                                                                                                                                    &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_ADDR_OFFICE_CITY)%>                                                                                                                             
                                                                                                                                </td>
                                                                                                                                <!-- untuk Posisi -->
                                                                                                                                <%--
                                                                                                                                <td  valign="top">
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][9]%></div>
                                                                                                                                </td>
                                                                                                                                <td valign="top">
                                                                                                                                    <%
                                                                                                                                        int countPosition = PstPosition.getCount("");
                                                                                                                                        Vector listPosition = PstPosition.list(0, countPosition, "", PstPosition.fieldNames[PstPosition.FLD_POSITION_NAME]);
                                                                                                                                        Vector positionKey = new Vector(1, 1);
                                                                                                                                        Vector positionValue = new Vector(1, 1);

                                                                                                                                        for (int i = 0; i < listPosition.size(); i++) {
                                                                                                                                            Position position = (Position) listPosition.get(i);
                                                                                                                                            positionKey.add(position.getPositionName());
                                                                                                                                            positionValue.add(String.valueOf(position.getOID()).toString());
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                    <%=comboBox.draw(frmAnggota.fieldNames[frmAnggota.FRM_POSITION_ID], "", "select...", "" + anggota.getPositionId(), positionValue, positionKey)%> 
                                                                                                                                    &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_POSITION_ID)%>                                                                                                                            
                                                                                                                                </td>
                                                                                                                                --%>
                                                                                                                            </tr>
                                                                                                                            <tr align="left">
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <td valign="top">
                                                                                                                                    <!-- untuk Alamat Asal -->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][10]%></div>
                                                                                                                                </td>
                                                                                                                                <td  valign="top">
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_PERMANENT]%>" value="<%=(anggota.getAddressPermanent() != null ? anggota.getAddressPermanent() : "")%>" size="40" maxlength="50" class="">
                                                                                                                                    *&nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_ADDR_PERMANENT)%>
                                                                                                                                    <%--
                                                                                                                                    <input class=""  type="text" name="geo_address_pmnt" readonly="true" value="<%=anggota.getGeoAddressPermanent()%>" size="40" maxlength="50" onClick="javascript:updateGeoAddressPmnt()"> *&nbsp;
                                                                                                                                    <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_PROVINCE_ID]%>" value="<%="" + anggota.getAddressProvinceId()%>" >
                                                                                                                                    <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_CITY_PERMANENT]%>" value="<%="" + anggota.getAddressOfficeCity()%>" >
                                                                                                                                    <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_PMNT_REGENCY_ID]%>" value="<%="" + anggota.getAddressPermanentRegencyId()%>" >
                                                                                                                                    <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_PMNT_SUBREGENCY_ID]%>" value="<%="" + anggota.getAddressPermanentSubRegencyId()%>" >
                                                                                                                                    <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_WARD_ID]%>" value="<%="" + anggota.getWardId()%>" >
                                                                                                                                    --%>
                                                                                                                                </td>
                                                                                                                                <td valign="top">
                                                                                                                                    <!-- no NPWP -->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][22]%></div>
                                                                                                                                </td>
                                                                                                                                <td valign="top">
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_NPWP]%>" value="<%=anggota.getNoNpwp()%>" maxlength="30" size="40" class="">
                                                                                                                                    * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_NPWP)%>                                                                                                                      
                                                                                                                                </td>

                                                                                                                            </tr>
                                                                                                                            <tr align="left">
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <td valign="top"  >
                                                                                                                                    <!-- untuk Telepon-->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][18]%></div>
                                                                                                                                </td>
                                                                                                                                <td valign="top">
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_TLP]%>" value="<%=anggota.getTelepon()%>">
                                                                                                                                    &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_TLP)%>                                                                                                                                
                                                                                                                                </td>

                                                                                                                                <td valign="top"  >
                                                                                                                                    <!-- untuk Telepon-->
                                                                                                                                    <div align="left">No Kartu Keluarga</div>
                                                                                                                                </td>
                                                                                                                                <td valign="top">
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_KARTU_KELUARGA]%>" value="<%=anggota.getNoKartuKeluarga()%>">
                                                                                                                                    &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_KARTU_KELUARGA)%>                                                                                                                                
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left">
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <td valign="top"  >
                                                                                                                                    <!-- Untuk Hand Phone-->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][19]%></div>
                                                                                                                                </td>
                                                                                                                                <td  valign="top">
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_HANDPHONE]%>" value="<%=anggota.getHandPhone()%>">                                                                                                                            
                                                                                                                                </td>
																																<td>
																																	<div align="left"><%=strTitle[SESS_LANGUAGE][26]%></div>
																																</td>
																																<td>
                                                                                                                                    <%
																																		Vector obj_locationid = new Vector(1, 1);
																																		Vector val_locationid = new Vector(1, 1);
																																		Vector key_locationid = new Vector(1, 1);
																																		//PstLocation.fieldNames[PstLocation.FLD_TYPE] + " = " + PstLocation.TYPE_LOCATION_WAREHOUSE
																																		//add opie-eyek
																																		//algoritma : di check di sistem usernya dimana saja user tsb bisa melakukan create document
																																		whereClause = " (" + PstLocation.fieldNames[PstLocation.FLD_TYPE] + " = " + PstLocation.TYPE_LOCATION_STORE + ")";
																																		//whereClause += " AND " + PstDataCustom.whereLocReportView(userId, "user_create_document_location");
																																		Vector vt_loc = PstLocation.list(0,0,whereClause, PstLocation.fieldNames[PstLocation.FLD_NAME]);
																																		for (int d = 0; d < vt_loc.size(); d++) {
																																		  Location loc = (Location) vt_loc.get(d);
																																		  val_locationid.add("" + loc.getOID() + "");
																																		  key_locationid.add(loc.getName());
																																		}
																																		String select_locationid = "" + anggota.getAssignLocation(); //selected on combo box
																																	  %>
																																	  <%=ControlCombo.draw(frmAnggota.fieldNames[frmAnggota.FRM_ASSIGN_LOCATION_ID], null, select_locationid, val_locationid, key_locationid, "", "form-control")%>
																																</td>

                                                                                                                            </tr>
                                                                                                                            <tr align="left">
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <td valign="top"  >
                                                                                                                                    <!-- Untuk Hand Phone-->
                                                                                                                                    <div align="left">Contact Class</div>
                                                                                                                                </td>
                                                                                                                                <td  valign="top">
                                                                                                                                  
                                                                                                                                    <%
                                                                                                                                          String whereContact = PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] +" = "+ oidAnggota;
                                                                                                                                          Vector listContactAssign = PstContactClassAssign.list(0, 0, whereContact, "");
                                                                                                                                          for(int id = 0; id < listContactAssign.size(); id++){
                                                                                                                                          ContactClassAssign contactClassAssign = (ContactClassAssign)listContactAssign.get(id);
                                                                                                                                          
                                                                                                                                          Vector obj_contactid = new Vector(1, 1);
                                                                                                                                          Vector val_contactid = new Vector(1, 1);
                                                                                                                                          Vector key_contactid = new Vector(1, 1);
                                                                                                                                          whereClause = "";
                                                                                                                                          Vector listContact = PstContactClass.list(0,0,"", "");
                                                                                                                                          for (int d = 0; d < listContact.size(); d++) {
                                                                                                                                            ContactClass contactClass = (ContactClass) listContact.get(d);
                                                                                                                                            val_contactid.add("" + contactClass.getOID() + "");
                                                                                                                                            key_contactid.add(contactClass.getClassName());
                                                                                                                                          }
                                                                                                                                            String select_contact = "" +contactClassAssign.getContactClassId();
                                                                                                                                           %>
                                                                                                                                         <%=ControlCombo.draw(FrmContactClass.fieldNames[FrmContactClass.FRM_FIELD_CLASS_NAME], null, select_contact, val_contactid, key_contactid, "", "form-control")%>
                                                                                                                                          <%}%>
                                                                                                                                </td>

                                                                                                                            </tr>
                                                                                                                            <tr align="left">
                                                                                                                                <td valign="top"  height="25">&nbsp;</td>

                                                                                                                                <%--
                                                                                                                                <td valign="top"  >
                                                                                                                                    <!-- Untuk no Rekening-->
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][24]%></div>
                                                                                                                                </td>
                                                                                                                                <td valign="top">
                                                                                                                                    <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_REKENING] %>" value="<%=anggota.getNoRekening()%>" maxlength="30" size="40" class="">
                                                                                                                                    * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_REKENING) %>
                                                                                                                                </td>
                                                                                                                                --%>
                                                                                                                            </tr>
                                                                                                                            <tr align="left">
                                                                                                                                <!-- entity hidden -->
                                                                                                                                <td valign="top"  height="25">&nbsp;</td>
                                                                                                                                <td valign="top"  >
                                                                                                                                    &nbsp;
                                                                                                                                </td>
                                                                                                                                <td  valign="top">
                                                                                                                                    &nbsp;
                                                                                                                                </td>
                                                                                                                                <td valign="top"  >&nbsp;
                                                                                                                                </td>
                                                                                                                                <td valign="top">&nbsp;                                                                                                                              
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left">
                                                                                                                                <td height="40">&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr><br><br> 
                                                                                                                            <tr align="left">
                                                                                                                                <td valign="top"  >&nbsp;</td>
                                                                                                                                <td colspan="4"  valign="top"  >
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td> <%

                                                                                                                                                ctrLine.setLocationImg(approot + "/image/ctr_line");
                                                                                                                                                ctrLine.initDefault();
                                                                                                                                                ctrLine.setTableWidth("100%");
                                                                                                                                                String scomDel = "javascript:cmdAsk('" + oidAnggota + "')";
                                                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidAnggota + "')";
                                                                                                                                                String scancel = "javascript:cmdEdit('" + oidAnggota + "')";

                                                                                                                                                ctrLine.setCommandStyle("command");
                                                                                                                                                ctrLine.setColCommStyle("command");
                                                                                                                                                ctrLine.setCommandStyle("command");
                                                                                                                                                ctrLine.setColCommStyle("command");
                                                                                                                                                ctrLine.setAddStyle("class=\"btn-primary btn-lg\"");
                                                                                                                                                ctrLine.setCancelStyle("class=\"btn-delete btn-lg\"");
                                                                                                                                                ctrLine.setDeleteStyle("class=\"btn-delete btn-lg\"");
                                                                                                                                                ctrLine.setBackStyle("class=\"btn-primary btn-lg\"");
                                                                                                                                                ctrLine.setSaveStyle("class=\"btn-save btn-lg\"");
                                                                                                                                                ctrLine.setConfirmStyle("class=\"btn-primary btn-lg\"");
                                                                                                                                                ctrLine.setAddCaption("<i class=\"fa fa-plus-circle\"></i> " + strAddAnggota);
                                                                                                                                                //ctrLine.setBackCaption("");
                                                                                                                                                ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
                                                                                                                                                ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackAnggota);
                                                                                                                                                ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveAnggota);
                                                                                                                                                ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskAnggota);
                                                                                                                                                ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> " + strDeleteAnggota);
                                                                                                                                                ctrLine.setAddCaption(strAddAnggota);
                                                                                                                                                ctrLine.setCancelCaption(strCancel);
                                                                                                                                                ctrLine.setBackCaption(strBackAnggota);
                                                                                                                                                ctrLine.setSaveCaption(strSaveAnggota);
                                                                                                                                                ctrLine.setDeleteCaption(strAskAnggota);
                                                                                                                                                ctrLine.setConfirmDelCaption(strDeleteAnggota);

                                                                                                                                                if (privDelete) {
                                                                                                                                                    ctrLine.setConfirmDelCommand(sconDelCom);
                                                                                                                                                    ctrLine.setDeleteCommand(scomDel);
                                                                                                                                                    ctrLine.setEditCommand(scancel);
                                                                                                                                                } else {
                                                                                                                                                    ctrLine.setConfirmDelCaption("");
                                                                                                                                                    ctrLine.setDeleteCaption("");
                                                                                                                                                    ctrLine.setEditCaption("");
                                                                                                                                                }
                                                                                                                                                if (privAdd == false && privUpdate == false) {
                                                                                                                                                    ctrLine.setSaveCaption("");
                                                                                                                                                }
                                                                                                                                                if (privAdd == false) {
                                                                                                                                                    ctrLine.setAddCaption("");
                                                                                                                                                }

                                                                                                                                                if (iCommand == Command.EDIT) {
                                                                                                                                                    iCommand = Command.EDIT;
                                                                                                                                                }
                                                                                                                                                %> <%= ctrLine.draw(iCommand, iErrCode, errMsg)%> 
                                                                                                                                                <% if (anggota.getOID() != 0) {%> 
                                                                                                                                                <button type="button" id="btn_printNasabah" style="float: right" class="btn btn-primary btn-lg"><b>Cetak data <%=namaNasabah%></b></button>
                                                                                                                                                <% }%>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>

                                                                                                <!-- #EndEditable -->
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </form>                                                                                   
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr> 
                                                                <td height="100%">
                                                                    <p>&nbsp;</p>
                                                                    <p>&nbsp;</p>
                                                                    <p>&nbsp;</p>
                                                                    <p>&nbsp;</p>
                                                                    <p>&nbsp;</p>
                                                                    <p>&nbsp;</p>
                                                                    <p>&nbsp;</p>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="20" bgcolor="#9BC1FF"> 
                                <!-- #BeginEditable "footer" -->
                                <%@ include file = "../../../main/footer.jsp" %>
                                <!-- #EndEditable --> 
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
     <span id="about" class="target"><!-- Hidden anchor to open adjesting modal container--></span>                           
        <div class="modal">
            <div class="content vertical-align-middle">
                <form id="generalform" action="<%=approot%>/AjaxUploadFile" method="post">
                    <input type="hidden" name="anggota_oid" value="<%= anggota.getOID() %>">
		    <input type="hidden" name="SEND_ROOT" value="<%= approot %>">
		    <input type="hidden" name="SEND_LOCATION" value="<%= lokasiSimpanFoto %>">
                    <input type="hidden" name="BASE64" id="base64">
                    <table width="100%">
                        <tr>
                            <td valign="top">
                                <div id="container">
                                    <video  autoplay="true" id="videoElement" >

                                    </video>
                                    <canvas id="canvas" width="500" height="375" style="display: none"></canvas>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="takeContainer">
                                    <a class="btn-primary btn-lg" id="snap">Ambil Gambar</a>
                                </div>
                                <div id="saveContainer" style="display: none">
                                    <a class="btn-primary btn-lg" id="save">Simpan</a>
                                    <a class="btn-primary btn-lg" id="cancel">Ambil Ulang</a>
                                </div>
                            </td>
                        </tr>
                    </table>
                </form>
              
              <a class="close-btn" href="#start" id="close-modal">X</a>
            </div>
        </div>

        <div class="print-area">
            <div style="size: A5;" class="container">
                <div style="overflow: auto">
                    <div style="width: 50%; float: left;">
                        <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                        <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                        <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
                    </div>
                    <div style="width: 50%; float: right; text-align: right">
                        <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">DATA <%=namaNasabah.toUpperCase()%></span>
                        <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                        <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
                    </div>
                </div>
                <div class="clearfix"></div>
                <br>
                <hr class="" style="border-color: gray">
                <!------------------------->
                <br>
                <div>
                    <strong>Data <%=namaNasabah%> &nbsp; : &nbsp;</strong>
                </div>
                <table class="tabel_data">
                    <tr><td>Nomor <%=namaNasabah%></td><td>&nbsp; : &nbsp;</td><td><%=anggota.getNoAnggota()%></td></tr>
                    <tr><td>Nama <%=namaNasabah%></td><td>&nbsp; : &nbsp;</td><td><%=anggota.getName()%></td></tr>
                    <tr><td>Jenis Kelamin</td><td>&nbsp; : &nbsp;</td><td><%=PstAnggota.sexKey[0][anggota.getSex()]%></td></tr>
                    <tr><td>Tempat Lahir</td><td>&nbsp; : &nbsp;</td><td><%=anggota.getBirthPlace()%></td></tr>
                    <tr><td>Tanggal Lahir</td><td>&nbsp; : &nbsp;</td><td><%=Formater.formatDate(anggota.getBirthDate(), "dd MMMM yyyy")%></td></tr>
                    <tr><td>Alamat</td><td>&nbsp; : &nbsp;</td><td><%=anggota.getAddressPermanent()%></td></tr>
                    <tr><td>Telepon</td><td>&nbsp; : &nbsp;</td><td><%=anggota.getTelepon()%></td></tr>
                    <tr><td>Handphone</td><td>&nbsp; : &nbsp;</td><td><%=anggota.getHandPhone()%></td></tr>
                    <tr><td>Email</td><td>&nbsp; : &nbsp;</td><td><%=anggota.getEmail()%></td></tr>
                    <tr><td>Nomor Identitas (KTP)</td><td>&nbsp; : &nbsp;</td><td><%=anggota.getIdCard()%></td></tr>                    
                    <%
                        Vocation v = new Vocation();
                        try {
                            v = PstVocation.fetchExc(anggota.getVocationId());
                        } catch (Exception exc) {

                        }
                    %>
                    <tr><td>Pekerjaan</td><td>&nbsp; : &nbsp;</td><td><%=v.getVocationName()%></td></tr>
                    <tr><td>Alamat Tempat Bekerja</td><td>&nbsp; : &nbsp;</td><td><%=anggota.getOfficeAddress()%></td></tr>
                    <tr><td>Nomor NPWP</td><td>&nbsp; : &nbsp;</td><td><%=anggota.getNoNpwp()%></td></tr>
                </table>
                <br>
                <div>
                    <strong>Data Pendidikan &nbsp; : &nbsp;</strong>
                </div>
                <table class="tabel_data" border="1" cellpadding="0" cellspacing="0">
                    <tr>
                        <th>No.</th>
                        <th>Pendidikan</th>
                        <th>Detail</th>
                    </tr>
                    <%
                        Vector listAnggotaEducation = PstAnggotaEducation.list(0, 0, "" + PstAnggotaEducation.fieldNames[PstAnggotaEducation.FLD_ANGGOTA_ID] + " = '" + oidAnggota + "'", orderClause);
                        for (int i = 0; i < listAnggotaEducation.size(); i++) {
                            AnggotaEducation edu = (AnggotaEducation) listAnggotaEducation.get(i);
                            Education education = new Education();
                            try {
                                education = PstEducation.fetchExc(edu.getEducationId());
                            } catch (Exception e) {
                                education = new Education();
                            }
                    %>
                    <tr>
                        <td><%=(i + 1)%>.</td>
                        <td><%=education.getEducation()%></td>
                        <td><%=edu.getEducationDetail()%></td>
                    </tr>
                    <%
                        }
                    %>
                    <% if (listAnggotaEducation.isEmpty()) {%>
                    <tr><td colspan="3" style="text-align: center">Tidak ada data pendidikan</td></tr>
                    <%}%>
                </table>
                <br>
                <div>
                    <strong>Data Keluarga &nbsp; : &nbsp;</strong>
                </div>
                <table class="tabel_data" border="1" cellpadding="0" cellspacing="0">
                    <tr>
                        <th>No.</th>
                        <th>Nama</th>
                        <th>Jenis Kelamin</th>
                        <th>Hubungan Keluarga</th>
                        <th>Keterangan</th>
                    </tr>
                    <%
                        String[] statusKeluarga = {"Bapak kandung", "Ibu kandung", "Istri", "Suami", "Anak kandung", "Anak tiri", "Saudara kandung", "Saudara tiri", "Sepupu", "Paman / Bibi"};
                        Vector listFamily = SessAnggota.listJoinKeluarga(0, 0, whereClause, orderClause, oidAnggota);
                        for (int i = 0; i < listFamily.size(); i++) {
                            Anggota keluarga = (Anggota) listFamily.get(i);
                    %>
                    <tr>
                        <td><%=(i + 1)%>.</td>
                        <td><%=keluarga.getName()%></td>
                        <td><%=PstAnggota.sexKey[0][keluarga.getSex()]%></td>
                        <td><%=statusKeluarga[keluarga.getHubunganKeluarga()]%></td>
                        <td><%=keluarga.getKeteranganKeluarga()%></td>
                    </tr>
                    <%
                        }
                    %>
                    <% if (listFamily.isEmpty()) {%>
                    <tr><td colspan="5" style="text-align: center">Tidak ada data keluarga</td></tr>
                    <%}%>
                </table>
                <br>
                <div>
                    <strong>Data Tabungan &nbsp; : &nbsp;</strong>
                </div>
                <table class="tabel_data" border="1" cellpadding="0" cellspacing="0">
                    <tr>
                        <th>No.</th>
                        <th>Nomor Tabungan</th>
                        <th>Nama Tabungan</th>
                        <th>Jenis Simpanan</th>
                    </tr>
                    <%
                        Vector listTabungan = PstAssignContact.list(0, 0, "" + PstAssignContact.fieldNames[PstAssignContact.FLD_CONTACT_ID] + " = '" + oidAnggota + "'", orderClause);
                        for (int i = 0; i < listTabungan.size(); i++) {
                            AssignContact assignContact = (AssignContact) listTabungan.get(i);
                            MasterTabungan mt = new MasterTabungan();
                            JenisSimpanan js = new JenisSimpanan();
                            String namaSimpanan = "";
                            try {
                                mt = PstMasterTabungan.fetchExc(assignContact.getMasterTabunganId());
                                Vector<AssignTabungan> at = new Vector<AssignTabungan>();
                                at = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + "=" + mt.getOID(), "");
                                for (int in = 0; in < at.size(); in++) {
                                    js = PstJenisSimpanan.fetchExc(at.get(in).getIdJenisSimpanan());
                                    if (in == 0) {
                                        namaSimpanan += js.getNamaSimpanan();
                                    } else {
                                        namaSimpanan += ", " + js.getNamaSimpanan();
                                    }
                                }

                            } catch (Exception e) {

                            }
                    %>
                    <tr>
                        <td><%=(i + 1)%></td>
                        <td><%=assignContact.getNoTabungan()%></td>
                        <td><%=mt.getNamaTabungan()%></td>
                        <td><%=namaSimpanan%></td>
                    </tr>
                    <%
                        }
                    %>
                    <% if (listTabungan.isEmpty()) {%>
                    <tr><td colspan="4" style="text-align: center">Tidak ada data tabungan</td></tr>
                    <%}%>
                </table>
            </div>
        </div>
        <script language="JavaScript">
            var video = document.getElementById('videoElement');

            // Get access to the camera!
            if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                // Not adding `{ audio: true }` since we only want video now
                navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
                    video.src = window.URL.createObjectURL(stream);
                    video.play();
                });
            }
            
            var canvas = document.getElementById('canvas');
            var context = canvas.getContext('2d');
            
            document.getElementById("snap").addEventListener("click", function() {
                document.getElementById('videoElement').setAttribute( "style", "display:none" );
                document.getElementById('canvas').removeAttribute("style");
                document.getElementById('takeContainer').setAttribute( "style", "display:none" );
                document.getElementById('saveContainer').removeAttribute( "style");
                context.drawImage(video, 0, 0, 500, 375);
            });
            
            document.getElementById("cancel").addEventListener("click", function() {
                document.getElementById('videoElement').removeAttribute( "style");
                document.getElementById('canvas').setAttribute("style", "display:none" );
                document.getElementById('takeContainer').removeAttribute( "style" );
                document.getElementById('saveContainer').setAttribute( "style", "display:none" );
            });
            
            document.getElementById("save").addEventListener("click", function() {
               var dataURL = canvas.toDataURL(); 
               $("#generalform #base64").val(dataURL);
               document.getElementById("generalform").submit();
            });
            
        </script>
    </body>
    <!-- #BeginEditable "script" -->
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>
