<%--
    Document   : anggota_edit
    Created on : Feb 28, 2013, 9:50:44 AM
    Author     : HaddyPuutraa
--%>
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

<%@include file="../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
    boolean privPrint = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
%>

<%!
  
    public static String strTitle[][] = {
        {"Nomor",//0
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
            "Tanggal Regristrasi"},//25
        {"Member ID",//0
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
            "Regristation Date"}//25
    };

    public static final String systemTitle[] = {
        "Keluarga", "Family"
    };

    public static final String userTitle[][] = {
        {"Tambah", "Edit"}, {"Add", "Edit"}
    };

    public static final String tabTitle[][] = {
        {"Data Pribadi", "Anggota Keluarga", "Registrasi Tabungan", "Pendidikan", "Data Tabungan", "Dokumen Bersangkutan"}, 
        {"Personal Date", "Family Member", "Saving Registration", "Education", "Saving Type", "Relevant Document"}
    };

    public static final String titleTabel[][] = {
        {"No", "Nama", "Jenis Kelamin", "Status Keluarga", "No. Telpon", "Tidak ada anggota keluarga", "Alamat Email", "No. Handphone","Alamat"},
        {"Number", "Name", "Gender", "Family Status", "Phone Number", "No family member found", "Email Address", "Handphone Number","Address"}
    };

    public String drawList(Vector listFamily, int languange, long oidAnggota) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");

        //create tabel
        ctrlist.addHeader(titleTabel[languange][0], "1%");
        ctrlist.addHeader(titleTabel[languange][1], "");
        ctrlist.addHeader(titleTabel[languange][2], "");
        ctrlist.addHeader(titleTabel[languange][3], "");
        ctrlist.addHeader(titleTabel[languange][4], "");
        ctrlist.addHeader(titleTabel[languange][7], "");
        ctrlist.addHeader(titleTabel[languange][8], "");
        //ctrlist.addHeader(titleTabel[languange][6], "20%");

        //ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        //Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;
        int number = 0;

        //untuk list Education update tanggal 4 maret oleh hadi
        /*ControlCombo comboBox = new ControlCombo();
         int countEducation = PstEducation.getCount("");
         Vector listEducation = PstEducation.list(0, countEducation, "", PstEducation.fieldNames[PstEducation.FLD_EDUCATION_ID]);
         Vector educationKey = new Vector(1, 1);
         Vector educationValue = new Vector(1, 1);
         for (int i = 0; i < listEducation.size(); i++) {
         Education education = (Education) listEducation.get(i);
         educationKey.add("" + education.getEducation());
         educationValue.add(String.valueOf(education.getOID()).toString());
         }*/
        String[] statusKeluarga = {"Bapak kandung", "Ibu kandung", "Istri", "Suami", "Anak kandung", "Anak tiri", "Saudara kandung", "Saudara tiri", "Sepupu", "Paman / Bibi"};
        String[] jenisKelamin = {"Laki-laki", "Perempuan"};
        if (!listFamily.isEmpty()) {
            for (int i = 0; i < listFamily.size(); i++) {
                number = number + 1;
                Anggota anggota = (Anggota) listFamily.get(i);
                long keluargaOid = anggota.getOID();
                rowx = new Vector();
                rowx.add("" + number);
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(keluargaOid) + "','" + String.valueOf(oidAnggota) + "','" + String.valueOf(anggota.getRelasiId()) + "')\">" + anggota.getName() + "</a>");
                rowx.add("" + jenisKelamin[anggota.getSex()]);
                rowx.add("" + statusKeluarga[anggota.getHubunganKeluarga()]);
                rowx.add("" + anggota.getTelepon());
                rowx.add("" + anggota.getHandPhone());
                rowx.add("" + anggota.getAddressPermanent());
                //rowx.add("" + anggota.getEmail());
                lstData.add(rowx);
            }
        } else {
            rowx = new Vector();
            rowx.add("<td colspan='7' style='background-color: white'>" + titleTabel[languange][5] + "</td>");
            lstData.add(rowx);
        }

        rowx = new Vector();

        //untuk membuat form input 
        //Education education = new Education();
        /*if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)) {
         rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[frmObject.FRM_ANGGOTA_ID] + "\" value=\"" + anggotaId + "\" class=\"\">");
         rowx.add("" + comboBox.draw(FrmAnggotaEducation.fieldNames[FrmAnggotaEducation.FRM_EDUCATION_ID], "", "select...", "" + objEntity.getEducationId(), educationValue, educationKey));
         rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[frmObject.FRM_EDUCATION_DETAIL] + "\" value=\"" + objEntity.getEducationDetail() + "\" class=\"\" size=\"60\">");
         }
         lstData.add(rowx);*/
        return ctrlist.draw(index);
    }
%>

<%
    CtrlAnggota ctrlAnggota = new CtrlAnggota(request);
    long oidAnggota = FRMQueryString.requestLong(request, "anggota_oid");
    long oidAnggotaKeluarga = FRMQueryString.requestLong(request, "keluarga_oid");
    long oidRelasi = FRMQueryString.requestLong(request, "relasi_oid");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int hidden_command = FRMQueryString.requestInt(request, "hidden_flag_cmd");
    int hubunganKeluarga = FRMQueryString.requestInt(request, "hubungan_keluarga");
    String keteranganKeluarga = FRMQueryString.requestString(request, "keterangan_keluarga");
    int iErrCode = FRMMessage.ERR_NONE;
    String errMsg = "";
    String whereClause = "";
    String orderClause = "";
    int recordToGet = 0;
    int start = FRMQueryString.requestInt(request, "start");
    
    //untuk tab edit Personal data oleh hadi tanggal 2 Maret 2013
    int iCommand = FRMQueryString.requestCommand(request);
    if (oidAnggota != 0 && iCommand == Command.NONE) {
        //iCommand = Command.EDIT;
    } else {
        iCommand = FRMQueryString.requestCommand(request);
    }

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
    iErrCode = ctrlAnggota.ActionFamily(iCommand, oidAnggotaKeluarga, oidAnggota, hubunganKeluarga, keteranganKeluarga, oidRelasi);

    errMsg = ctrlAnggota.getMessage();
    FrmAnggota frmAnggota = ctrlAnggota.getForm();
    Anggota anggota = ctrlAnggota.getAnggota();
    AnggotaKeluarga keluarga = new AnggotaKeluarga();
    Anggota a = new Anggota();
    try {
        a = PstAnggota.fetchExc(oidAnggota);
        keluarga = PstAnggotaKeluarga.fetchExc(oidRelasi);
    } catch (Exception exc) {
        System.out.println(exc.getMessage());
    }
    Vector listFamily = SessAnggota.listJoinKeluarga(start, recordToGet, whereClause, orderClause, oidAnggota);
//	if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmAnggota.errorSize()<1)){
  //  if (iCommand == Command.DELETE) {
//<jsp:forward page="anggota_family.jsp">
  //  <jsp:param name="prev_command" value="<%=prevCommand%" />
   // <jsp:param name="start" value="<%=start%" />
   // <jsp:param name="anggota_oid" value="<%=anggota.getOID()%" />
//</jsp:forward>
   // }
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
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
                document.frmAnggota.anggota_oid.value = "<%=oidAnggota%>";
                document.frmAnggota.keluarga_oid.value = 0;
                document.frmAnggota.submit();
            }

            function cmdCancel() {
                document.frmAnggota.command.value = "<%=Command.CANCEL%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
                document.frmAnggota.submit();
            }

            function cmdEdit(idKeluarga, idAnggota, idRelasi) {
                document.frmAnggota.command.value = "<%=Command.EDIT%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + idAnggota;
                document.frmAnggota.anggota_oid.value = idAnggota;
                document.frmAnggota.keluarga_oid.value = idKeluarga;
                document.frmAnggota.relasi_oid.value = idRelasi;
                document.frmAnggota.submit();
            }

            function cmdSave() {
                document.frmAnggota.command.value = "<%=Command.SAVE%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
                document.frmAnggota.submit();
            }

            function cmdAsk(oid) {
                document.frmAnggota.command.value = "<%=Command.ASK%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
                document.frmAnggota.submit();
            }

            function cmdConfirmDelete(oid) {
                document.frmAnggota.command.value = "<%=Command.DELETE%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
                document.frmAnggota.submit();
            }

            function cmdBack() {
                document.frmAnggota.command.value = "<%=Command.FIRST%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
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
                document.frmAnggota.action = "anggota_edit.jsp";
                document.frmAnggota.submit();
            }

        </script>
        <!-- #EndEditable -->
        <%@ include file = "/style/lte_head.jsp" %>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <!--link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css"-->
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
        <SCRIPT language=JavaScript>

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
        <style>
            .tabel_info_anggota {width: 50%}
            .tabel_info_anggota td {padding: 5px; vertical-align: text-top}
            
            #tabel_tab_menu {width: 100%; border-collapse: collapse}
            #tabel_tab_menu {border-color: transparent}
            #tabel_tab_menu a {color: black}
            #tabel_tab_menu td {background-color: lightgray; border-color: #eaf3df; text-decoration: none;}

        </style>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1><%=namaNasabah %> Individu <small></small></h1>
            <ol class="breadcrumb">
                <li><i class="fa fa-dashboard"></i> Home</li>
                <li>Master Bumdesa</li>
                <li><%=namaNasabah %> Individu</li>
            </ol>
        </section>
        
        <section class="content">

            <table id="tabel_tab_menu" border="1">
                <tr style="height: 35px;">
                    <td width="20%">
                        <!-- Data Personal -->
                        <div align="center">
                            <a href="anggota_edit.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][0]%></a>
                        </div>
                    </td>                                                                                                        
                    <td width="20%">
                        <!-- Pendidikan-->
                        <div align="center">
                            <a href="anggota_education.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][3]%></a>
                        </div>
                    </td>
                    <td width="20%" style="background-color: #337ab7;">
                        <!-- Keluarga Anggota-->
                        <div align="center">
                            <a href="anggota_family.jsp?anggota_oid=<%=oidAnggota%>" style="color: white"><%=tabTitle[SESS_LANGUAGE][1]%></a>
                        </div>
                    </td>
                    
                    <%if(useRaditya == 1){}else{%>
                    <td width="20%">
                        <!-- Data Tabungan-->
                        <div align="center">
                            <a href="anggota_tabungan.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][4]%></a>
                        </div>
                    </td>
                    <%}%>
                    
                    <td width="20%">
                        <!-- Dokumen Bersangkutan-->
                        <div align="center">
                            <a href="anggota_dokumen.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][5]%></a>
                        </div>
                    </td>
                </tr>
            </table>

                <form name="frmAnggota" method="post" action="">
                    <input type="hidden" name="start" value="<%=start%>">
                    <input type="hidden" name="hidden_goto_anggota" value="<%=String.valueOf(gotoAnggota)%>">
                    <input type="hidden" name="hidden_copy_status">
                    <input type="hidden" name="command" value="<%=iCommand%>">
                    <input type="hidden" name="anggota_oid" value="<%=oidAnggota%>">
                    <input type="hidden" name="keluarga_oid" value="<%=oidAnggotaKeluarga%>">
                    <input type="hidden" name="relasi_oid" value="<%=oidRelasi%>">
                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                    <input type="hidden" name="hidden_flag_cmd" value="<%=hidden_command%>">
                    
                    <br>
                    <table class="tabel_info_anggota">
                        <tr>
                            <td style="width: 50px">Nama</td>
                            <td>: <%= a.getName() %></td>
                        </tr>
                        <tr>
                            <td>Nomor</td>
                            <td>: <%= a.getNoAnggota() %></td>
                        </tr>
                    </table>
                        
                    <br>
                    <%= drawList(listFamily, SESS_LANGUAGE, oidAnggota)%>
                    
                    <% if (iCommand == Command.EDIT || iCommand == Command.ADD || iCommand == Command.ASK || iCommand == Command.SAVE) {%>

                    <table  width="98%" align="center" border="0" cellspacing="2" cellpadding="2" bgcolor="#F5F7FA">
                        <tr>
                            <td valign="top">
                                <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                    <tr>
                                        <td valign="top" width="100%">
                                            <table width="100%" border="0" cellspacing="2" cellpadding="2" >
                                                <tr>
                                                    <td width="2%" height="20">&nbsp;</td>
                                                    <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                    <td width="35%" class="comment" height="20">
                                                        &nbsp;
                                                    </td>
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
                                                        <!-- Untuk hubungan keluarga -->
                                                        <div align="left">Hubungan Keluarga</div>
                                                    </td>
                                                    <td>
                                                        <select name="hubungan_keluarga" value="<%=keluarga.getStatusRelasi()%>" class="">
                                                            <option value="">- Select -</option>
                                                            <%
                                                                String[] statusKeluarga = {"Bapak kandung", "Ibu kandung", "Istri", "Suami", "Anak kandung", "Anak tiri", "Saudara kandung", "Saudara tiri", "Sepupu", "Paman / Bibi"};
                                                                for (int i = 0; i < statusKeluarga.length; i++) {
                                                                    String selected = "";
                                                                    if (i == keluarga.getStatusRelasi()) {
                                                                        selected = "selected";
                                                                    }
                                                            %>

                                                            <option value="<%=i%>" <%=selected%> ><%=statusKeluarga[i]%></option>

                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                        * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_ANGGOTA)%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" height="25" >&nbsp;</td>
                                                    <td valign="top">
                                                        <!-- Untuk No Anggota-->
                                                        <div align="left">Keterangan Keluarga</div>
                                                    </td>
                                                    <td>
                                                        <input type="text" name="keterangan_keluarga" value="<%=keluarga.getKeterangan()%>" class="" maxlength="20" size="40">
                                                        * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_ANGGOTA)%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" height="25" >&nbsp;</td>
                                                    <td valign="top">
                                                        <!-- Untuk No Anggota-->
                                                        <div align="left"><%=strTitle[SESS_LANGUAGE][0]%></div>
                                                    </td>
                                                    <td> 
                                                        <%
                                                            String noAnggota = "Auto-Number";
                                                            if (iCommand == Command.EDIT) {
                                                                noAnggota = anggota.getNoAnggota();
                                                            }
                                                        %>
                                                        <input type="text" readonly="" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_ANGGOTA]%>" value="<%=noAnggota%>" class="" maxlength="20" size="40">
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
                                                    <%--<td  valign="top">
                                                        <!-- Untuk Masa Berlaku ID Card-->
                                                        <div align="left"><%=strTitle[SESS_LANGUAGE][17]%></div>
                                                    </td>
                                                    <td  valign="top">
                                                        <%=ControlDate.drawDate(FrmAnggota.fieldNames[FrmAnggota.FRM_EXPIRED_DATE_KTP], anggota.getExpiredDateKtp(), "", 0, 5)%>                                                                                                                             
                                                    </td>--%>
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
                                                    <td valign="top">
                                                        <div align="left"><%=strTitle[SESS_LANGUAGE][7]%></div>
                                                    </td>
                                                    <td  valign="top">
                                                        <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_OFFICE_ADDRESS]%>" value="<%=anggota.getOfficeAddress()%>" size="40" maxlength="50" class="">
                                                        &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_OFFICE_ADDRESS)%>                                                                                                                           
                                                    </td>
                                                    <!-- untuk Agensi -->
                                                    <!--td>
                                                        <div align="left"><%=strTitle[SESS_LANGUAGE][6]%></div>
                                                    </td>
                                                    <td>
                                                        <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_AGENCIES]%>" value="<%=anggota.getAgencies()%>" class="" size="20">
                                                        &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_AGENCIES)%>
                                                    </td-->
                                                </tr>

                                                <tr align="left">
                                                    <td valign="top" height="25">&nbsp;</td>
                                                    <td valign="top"  >
                                                        <!-- untuk Tanggal Lahir -->
                                                        <div align="left"><%=strTitle[SESS_LANGUAGE][4]%></div>
                                                    </td>
                                                    <td  valign="top">
                                                        <%=ControlDate.drawDate(frmAnggota.fieldNames[frmAnggota.FRM_BIRTH_DATE], anggota.getBirthDate(), "", -17, 110)%>
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
                                                    <td  valign="top">
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
                                                                                                                    </td>--%>
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
                                                    <!-- untuk office address -->

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

                                                </tr>
                                                <tr align="left">
                                                    <td valign="top"  height="25">&nbsp;</td>

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
                                                                <td> 

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

                    <%}%>
                    
                    <br>
                    
                    <%
                        ctrLine.setLocationImg(approot + "/image/ctr_line");
                        ctrLine.initDefault();
                        ctrLine.setTableWidth("100%");
                        String scomDel = "javascript:cmdAsk('" + oidAnggotaKeluarga + "')";
                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidAnggotaKeluarga + "')";
                        String scancel = "javascript:cmdEdit('" + oidAnggotaKeluarga + "')";

                        ctrLine.setCommandStyle("command");
                        ctrLine.setColCommStyle("command");
                        ctrLine.setCommandStyle("command");
                        ctrLine.setColCommStyle("command");
                        ctrLine.setAddStyle("class=\"btn-primary btn-sm\"");
                        ctrLine.setCancelStyle("class=\"btn-delete btn-sm\"");
                        ctrLine.setDeleteStyle("class=\"btn-delete btn-sm\"");
                        ctrLine.setBackStyle("class=\"btn-primary btn-sm\"");
                        ctrLine.setSaveStyle("class=\"btn-save btn-sm\"");
                        ctrLine.setConfirmStyle("class=\"btn-primary btn-sm\"");
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
                    %> 
                    <%= ctrLine.draw(iCommand, iErrCode, errMsg)%>
                    
                </form>
                
        </section>               
    </body>
    <!-- #BeginEditable "script" -->
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>
