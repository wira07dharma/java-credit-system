<%-- 
    Document   : anggota_dokumen
    Created on : Dec 23, 2017, 9:47:28 AM
    Author     : dedy_blinda
--%>

<%@page import="java.io.File"%>
<%@page import="com.dimata.sedana.entity.masterdata.EmpRelevantDocGroup"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstEmpRelevantDocGroup"%>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
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
        {"Kelompok Dokumen",//0
            "Judul",//1
            "Keterangan",//2
            "No Anggota",//3
            "Nama",//4
            "Dokumen Bersangkutan",//5
            "Dokumen",//6
            "Dibutuhkan"},//7
        {"Group Doc",//0
            "Title",//1
            "Description",//2
            "Member ID",//3
            "Name",//4
            "Dokumen Bersangkutan",//5
            "Document",//6
            "Required"}//6
    };

    public static final String systemTitle[] = {
        "Dokumen", "Document"
    };

    public static final String userTitle[][] = {
        {"Tambah", "Ubah", "Lihat", "Unduh"}, {"Add", "Edit", "View", "Download"}
    };

    public static final String tabTitle[][] = {
        {"Data Pribadi", "Anggota Keluarga", "Registrasi Tabungan", "Pendidikan", "Data Tabungan", "Dokumen Bersangkutan"}, {"Personal Date", "Family Member", "Saving Registration", "Education", "Saving Type", "Relevant Document"}
    };

    public static final String titleTabel[][] = {
        {"Judul", "Dokumen", "Keterangan","Aksi","No"}, {"Title", "Document", "Description", "Action","No"}
    };

    public String drawList(int iCommand, FrmEmpRelevantDoc frmObject, EmpRelevantDoc objEntity, Vector objectClass, long relevantId, long anggotaId, int languange, int start, String approot) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.setCellSpacing("0");
        ctrlist.addHeader(titleTabel[languange][4],"1%");
        ctrlist.addHeader(titleTabel[languange][0],"");
        ctrlist.addHeader(titleTabel[languange][1],"");
        ctrlist.addHeader(titleTabel[languange][2],"");
        ctrlist.addHeader(titleTabel[languange][3],"10%");

        Vector lstData = ctrlist.getData();
        ctrlist.reset();
        int index = -1;
        
        if (objectClass.isEmpty()) {
            Vector rowx = new Vector();
            rowx.add("<td colspan='4' style='background-color: white'>Tidak ada data dokumen</td>");
            lstData.add(rowx);
        } else {
            for (int i = 0; i < objectClass.size(); i++) {
                EmpRelevantDoc empRelevantDoc = (EmpRelevantDoc) objectClass.get(i);
                Vector rowx = new Vector();
                if (relevantId == empRelevantDoc.getOID()) {
                    index = i;
                }
                rowx.add("<a href=\"javascript:cmdEdit('" + empRelevantDoc.getOID() + "')\">" + (i+1) + "</a>");
                rowx.add("<a href=\"javascript:cmdEdit('" + empRelevantDoc.getOID() + "')\">" + empRelevantDoc.getDocTitle() + "</a>");
                rowx.add(empRelevantDoc.getFileName());
                rowx.add(empRelevantDoc.getDocDescription());
                if(empRelevantDoc.getFileName().length() > 0) {
                    rowx.add("<div class='text-center'>"
                            + "<a class='btn btn-xs btn-primary' href=\"javascript:cmdOpen('" + empRelevantDoc.getFileName() + "')\" download>" + userTitle[languange][2] + "</a>"
                            + " <a class='btn btn-xs btn-primary' href=\"" + approot + "/imgdoc/" + empRelevantDoc.getFileName() + "\" download>" + userTitle[languange][3] + "</a>"
                            + "</div>");
                } else {
                    rowx.add("Tidak ada dokumen");
                }
                
                lstData.add(rowx);
            }
        }

        return ctrlist.draw(-1);
    }
%>

<%
    CtrlEmpRelevantDoc ctrlEmpRelevantDoc = new CtrlEmpRelevantDoc(request);
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidAnggota = FRMQueryString.requestLong(request, "anggota_oid");
    long oidRelevant = FRMQueryString.requestLong(request, "relevant_oid");

    Anggota anggota = new Anggota();
    try {
        anggota = PstAnggota.fetchExc(oidAnggota);
    } catch (Exception exc) {
        anggota = new Anggota();
    }
    
    int iErrCode = FRMMessage.ERR_NONE;
    String errMsg = "";
    String whereClause = "" + PstAnggotaEducation.fieldNames[PstAnggotaEducation.FLD_ANGGOTA_ID] + " = " + oidAnggota;
    String orderClause = "" + PstAnggotaEducation.fieldNames[PstAnggotaEducation.FLD_ANGGOTA_ID];
    int recordToGet = 10;

    //khusus untuk edit data reques dari anggota_test.jsp oleh hadi tanggal 2 Mret 2013
    /**
     * if(oidRelevant != 0 && iCommand== Command.NONE && iCommand !=
     * Command.SAVE){ iCommand = Command.EDIT; }else{ iCommand =
     * FRMQueryString.requestCommand(request); }
     */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = systemTitle[SESS_LANGUAGE];
    String strAddMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";

    iErrCode = ctrlEmpRelevantDoc.action(iCommand, oidRelevant, oidAnggota);

    errMsg = ctrlEmpRelevantDoc.getMessage();
    FrmEmpRelevantDoc frmEmpRelevantDoc = ctrlEmpRelevantDoc.getForm();
    EmpRelevantDoc empRelevantDoc = ctrlEmpRelevantDoc.getEmpRelevantDoc();

    Vector listEmpRelevantDoc = new Vector(1, 1);
    int vectSize = PstEmpRelevantDoc.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlEmpRelevantDoc.actionList(iCommand, start, vectSize, recordToGet);
    }
    listEmpRelevantDoc = PstEmpRelevantDoc.list(start, recordToGet, whereClause, orderClause);
    if (listEmpRelevantDoc.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listEmpRelevantDoc = PstEmpRelevantDoc.list(start, recordToGet, whereClause, orderClause);
    }

    if (iCommand == Command.DELETE) {
    }
%>

<!-- End of Jsp Block -->
<html>
    <!-- #BeginTemplate "/Templates/maintab.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>Koperasi - Anggota</title>
        <script language="JavaScript">

            function cmdAdd() {
                document.frmEmpRelevantDoc.command.value = "<%=Command.ADD%>";
                document.frmEmpRelevantDoc.relevant_oid.value = 0;
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }
            function cmdCancel() {
                document.frmEmpRelevantDoc.command.value = "<%=Command.CANCEL%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }

            function cmdEdit(oidRelevant) {
                document.frmEmpRelevantDoc.relevant_oid.value = oidRelevant;
                document.frmEmpRelevantDoc.command.value = "<%=Command.EDIT%>";
                document.frmEmpRelevantDoc.prev_command.value = "<%=prevCommand%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }

            function cmdSave() {
                document.frmEmpRelevantDoc.command.value = "<%=Command.SAVE%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }

            function cmdAsk(oidRelevant) {
                document.frmEmpRelevantDoc.relevant_oid.value = oidRelevant;
                document.frmEmpRelevantDoc.command.value = "<%=Command.ASK%>";
                document.frmEmpRelevantDoc.prev_command.value = "<%=prevCommand%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }

            function cmdConfirmDelete(oid) {
                document.frmEmpRelevantDoc.command.value = "<%=Command.DELETE%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }

            function cmdBack() {
                document.frmEmpRelevantDoc.command.value = "<%=Command.FIRST%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }

            function cmdListFirst() {
                document.frmEmpRelevantDoc.command.value = "<%=Command.FIRST%>";
                document.frmEmpRelevantDoc.prev_command.value = "<%=Command.FIRST%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }

            function cmdListPrev() {
                document.frmEmpRelevantDoc.command.value = "<%=Command.PREV%>";
                document.frmEmpRelevantDoc.prev_command.value = "<%=Command.PREV%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }

            function cmdListNext() {
                document.frmEmpRelevantDoc.command.value = "<%=Command.NEXT%>";
                document.frmEmpRelevantDoc.prev_command.value = "<%=Command.NEXT%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }

            function cmdListLast() {
                document.frmEmpRelevantDoc.command.value = "<%=Command.LAST%>";
                document.frmEmpRelevantDoc.prev_command.value = "<%=Command.LAST%>";
                document.frmEmpRelevantDoc.action = "anggota_dokumen.jsp";
                document.frmEmpRelevantDoc.submit();
            }
            function cmdAttach(empdocId, empId){
                window.open("upload_pict.jsp?command="+<%=Command.EDIT%>+"&emp_relevant_doc_id=" + empdocId + "&emp_id=" + empId , null, "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");

            }
            function cmdOpenPages(empdocId){
                newWindow=window.open("doc_relevant_pages.jsp?command="+<%=Command.ADD%>+"&emp_relevant_doc_id=" + empdocId, null, "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                window.focus();
            }
            function cmdOpenPagesEdit(empdocpagesId, empdocId){
                window.open("doc_relevant_pages.jsp?command="+<%=Command.EDIT%>+"&emp_relevant_doc_id=" + empdocId+"&relevant_doc_pages_oid=" + empdocpagesId, null, "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
            }
            function cmdOpen(fileName){
		window.open("<%=approot%>/imgdoc/"+fileName , null);
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
<!--

            function hideObjectForEmployee() {
            }

            function hideObjectForLockers() {
            }

            function hideObjectForCanteen() {
            }

            function hideObjectForClinic() {
            }

            function hideObjectForMasterdata() {
            }

            function MM_swapImgRestore() { //v3.0
                var i, x, a = document.MM_sr;
                for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++)
                    x.src = x.oSrc;
            }

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

            //-->
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
                    <td width="20%">
                        <!-- Keluarga Anggota-->
                        <div align="center">
                            <a href="anggota_family.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][1]%></a>
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
                    
                    <td width="20%" style="background-color: #337ab7;">
                        <!-- Dokumen Bersangkutan-->
                        <div align="center">
                            <a href="anggota_dokumen.jsp?anggota_oid=<%=oidAnggota%>" style="color: white"><%=tabTitle[SESS_LANGUAGE][5]%></a>
                        </div>
                    </td>
                </tr>
            </table>
 
                <form name="frmEmpRelevantDoc" method="post" action="">
                    <input type="hidden" name="command" value="<%=iCommand%>">
                    <input type="hidden" name="start" value="<%=start%>">
                    <input type="hidden" name="anggota_oid" value="<%=oidAnggota%>">
                    <input type="hidden" name="relevant_oid" value="<%=oidRelevant%>">
                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                    
                    <br>
                    <table class="tabel_info_anggota">
                        <tr>
                            <td style="width: 50px">Nama</td>
                            <td>: <%= anggota.getName() %></td>
                        </tr>
                        <tr>
                            <td>Nomor</td>
                            <td>: <%= anggota.getNoAnggota() %></td>
                        </tr>
                    </table>
                    
                    <br>
                    <%= drawList(iCommand, frmEmpRelevantDoc, empRelevantDoc, listEmpRelevantDoc, oidRelevant, oidAnggota, SESS_LANGUAGE, start, approot)%>
                    
                    <br>
                    <%
                        int cmd = 0;
                        if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
                            cmd = iCommand;
                        } else {
                            if (iCommand == Command.NONE || prevCommand == Command.NONE) {
                                cmd = Command.FIRST;
                            } else {
                                cmd = prevCommand;
                            }
                        }
                    %>
                    <%=ctrLine.drawMeListLimit(cmd, vectSize, start, recordToGet, "cmdListFirst", "cmdListPrev", "cmdListNext", "cmdListLast", "left")%>

                    <%if((iCommand ==Command.ADD)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)||(iCommand==Command.LIST)){%>
                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                        <tr> 
                            <td colspan="2"><b class="listtitle"><%=strTitle[SESS_LANGUAGE][5]%></b></td>
                        </tr>
                        <tr> 
                            <td colspan="2">*) <%=strTitle[SESS_LANGUAGE][7]%></td>
                        </tr>
                        <tr> 
                            <td width="100%" height="216" colspan="2"> 
                                <table width="99%" height="144" border="0" cellpadding="2" cellspacing="2">
                                    <tr align="left" valign="top"> 
                                        <td width="13%" height="32" valign="top"><%=strTitle[SESS_LANGUAGE][0]%>
                                        </td>
                                        <td>
                                            <%
                                               Vector val_doc = new Vector(1, 1);
                                               Vector key_doc = new Vector(1, 1);
                                               Vector vdoc = PstEmpRelevantDocGroup.listAll();
                                               val_doc.add("0");
                                               key_doc.add("-- Pilih --");
                                               for (int k = 0; k < vdoc.size(); k++) {
                                                   EmpRelevantDocGroup empRelevantDocGroup = (EmpRelevantDocGroup) vdoc.get(k);
                                                   val_doc.add("" + empRelevantDocGroup.getOID());
                                                   key_doc.add("" + empRelevantDocGroup.getDocGroup());
                                               }
                                            %>
                                            <%=ControlCombo.draw("" + frmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_RELVT_DOC_GRP_ID], null, "" + empRelevantDoc.getRelvtDocGrpId(), val_doc, key_doc, "id=\"FRM_FIELD_RELVT_DOC_GRP_ID\"", "formElemen")%>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="top"> 
                                        <td width="13%" height="32" valign="top"><%=strTitle[SESS_LANGUAGE][1]%> 
                                        </td>
                                        <td valign="top" width="44%"><input type="hidden" name="<%=frmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_ANGGOTA_ID] %>"  value="<%=""+oidAnggota %>" class="formElemen"> 
                                            <input type="text" name="<%=frmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_DOC_TITLE] %>"  value="<%=(empRelevantDoc.getDocTitle()!=null?empRelevantDoc.getDocTitle():"")%>" class="formElemen"> *
                                            <%= frmEmpRelevantDoc.getErrorMsg(FrmEmpRelevantDoc.FRM_FIELD_DOC_TITLE) %>
                                        </td>
                                        <td width="43%" rowspan="2">
                                            <table width="45%" height="139" border="0">
                                                <tr>
                                                    <td height="133">

                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="top"> 
                                        <td width="13%" height="106" valign="top"><%=strTitle[SESS_LANGUAGE][2]%>
                                        </td>
                                        <td valign="top" width="44%"><textarea name="<%=frmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_DOC_DESCRIPTION] %>" class="elemenForm" cols="30" rows="3"><%= empRelevantDoc.getDocDescription() %></textarea> 
                                        </td>
                                    </tr>
                                    <% if((iCommand !=Command.ADD)){%>
                                    <tr align="left" valign="top"> 
                                        <td width="13%" valign="top"><%=strTitle[SESS_LANGUAGE][6] %>
                                        </td>

                                        <% if(empRelevantDoc.getFileName().length() > 0){%>
                                        <td ><input type="hidden" name="<%=frmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_FILE_NAME] %>"  value="<%= empRelevantDoc.getFileName() %>" class="formElemen"> 
                                            <a href="javascript:cmdOpen('<%=empRelevantDoc.getFileName()%>')"><%=empRelevantDoc.getFileName()%></a>
                                        </td>
                                        <% }else{
                                                                                                                                                          
                                            String[] noDoc =  {"Tidak ada data dokumen", "No Relevant Document Found . . ."};
                                                                                                                                                              
                                        %>
                                        <td valign="top" width="44%"><i><font  color="#FF0000"> <%=noDoc[SESS_LANGUAGE]%></font></i>
                                        </td>
                                        <%
                                        }
                                        %>

                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <button type="button" onclick="javascript:cmdAttach('<%=empRelevantDoc.getOID()%>', <%=empRelevantDoc.getAnggotaId()%>)">Unggah File</button>
                                        </td>
                                    </tr>
                                    <%}%>

                                </table>
                            </td>
                        </tr>

                    </table>
                    <%}%>
                    
                    <%
                        ctrLine.initDefault();
                        ctrLine.setTableWidth("80%");
                        String scomDel = "javascript:cmdAsk('" + oidRelevant + "')";
                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidRelevant + "')";
                        String scancel = "javascript:cmdEdit('" + oidRelevant + "')";
                        ctrLine.setCommandStyle("command");
                        ctrLine.setColCommStyle("command");
                        ctrLine.setAddStyle("class=\"btn-primary btn-sm\"");
                        ctrLine.setCancelStyle("class=\"btn-delete btn-sm\"");
                        ctrLine.setDeleteStyle("class=\"btn-delete btn-sm\"");
                        ctrLine.setBackStyle("class=\"btn-primary btn-sm\"");
                        ctrLine.setSaveStyle("class=\"btn-save btn-sm\"");
                        ctrLine.setConfirmStyle("class=\"btn-primary btn-sm\"");
                        ctrLine.setAddCaption("<i class=\"fa fa-plus-circle\"></i> " + strAddMar);
                        //ctrLine.setBackCaption("");
                        ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
                        ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackMar);
                        ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveMar);
                        ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskMar);
                        ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> " + strDeleteMar);

                        ctrLine.setAddCaption(strAddMar);
                        ctrLine.setCancelCaption(strCancel);
                        ctrLine.setBackCaption(strBackMar);
                        ctrLine.setSaveCaption(strSaveMar);
                        ctrLine.setDeleteCaption(strAskMar);
                        ctrLine.setConfirmDelCaption(strDeleteMar);

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
            
                    <%--
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="30%" bgcolor="#F9FCFF">
            <tr> 
                <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
                    <b><%=systemTitle[SESS_LANGUAGE]%> > <%=oidAnggota != 0 ? userTitle[SESS_LANGUAGE][1].toUpperCase() : userTitle[SESS_LANGUAGE][0].toUpperCase()%></b>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="88%" valign="top" align="left">
                                <table width="100%" border="0" cellspacing="3" cellpadding="2">
                                    <tr>
                                        <td width="100%">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td valign="top">
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                        <tr>
                                                                            <td valign="top"> <!-- #BeginEditable "content" -->
                                                                                <form name="" method="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="anggota_oid" value="<%=oidAnggota%>">
                                                                                    <input type="hidden" name="relevant_oid" value="<%=oidRelevant%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">

                                                                                        <% if (oidAnggota != 0) {%>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <br>
                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td class="tablecolor">
                                                                                                <table  width="98%" align="center" border="0" cellspacing="2" cellpadding="2" >
                                                                                                    <tr>
                                                                                                        <td valign="top">
                                                                                                            <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                                                                                                <tr>
                                                                                                                    <td valign="top" width="100%">
                                                                                                                        <table width="100%" border="0" cellspacing="2" cellpadding="2" >
                                                                                                                            <% if (oidAnggota != 0) {
                                                                                                                                    Anggota anggota = new Anggota();
                                                                                                                                    try {
                                                                                                                                        anggota = PstAnggota.fetchExc(oidAnggota);
                                                                                                                                    } catch (Exception exc) {
                                                                                                                                        anggota = new Anggota();
                                                                                                                                    }
                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td colspan="5" height="20">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td width="2%" height="20">&nbsp;</td>
                                                                                                                                <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                                                                                                <td width="35%" class="comment" height="20">
                                                                                                                                    <div align="left">&nbsp;</div>
                                                                                                                                </td>
                                                                                                                                <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                                                                                                <td width="35%" height="20">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <!-- Untuk No Anggota-->
                                                                                                                                <td valign="top">
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][3]%></div>
                                                                                                                                </td>
                                                                                                                                <td valign="top"> 
                                                                                                                                    :&nbsp;<%=anggota.getNoAnggota()%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                                                                                <!-- Untuk No Anggota-->
                                                                                                                                <td valign="top">
                                                                                                                                    <div align="left"><%=strTitle[SESS_LANGUAGE][4]%></div>
                                                                                                                                </td>
                                                                                                                                <td valign="top"> 
                                                                                                                                    :&nbsp;<%=anggota.getName()%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%}
                                                                                                                                try {
                                                                                                                                    if (listEmpRelevantDoc.size() > 0 || iCommand == Command.ADD) {
                                                                                                                            %>
                                                                                                                            <tr align="left">
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--td><%=strTitle[SESS_LANGUAGE][5]%></td-->
                                                                                                                                <td colspan="3">
                                                                                                                                    <%= drawList(iCommand, frmEmpRelevantDoc, empRelevantDoc, listEmpRelevantDoc, oidRelevant, oidAnggota, SESS_LANGUAGE, start, approot)%>
                                                                                                                                </td>
                                                                                                                            </tr> 
                                                                                                                            <tr align="left">
                                                                                                                                <td height="40">&nbsp;</td>
                                                                                                                                <td colspan="3">
                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr> 
                                                                                                                            <%} else {
                                                                                                                                String[] erorEducation = {"Data Dokumen Bersangkutan Kosong . . .", "No Relevant Document . . ."};
                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td colspan="3"><font color="#FF6600"><%=erorEducation[SESS_LANGUAGE]%></font></td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                    }
                                                                                                                                } catch (Exception e) {
                                                                                                                                }
                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td></td>
                                                                                                                                <td>
                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top" >
                                                                                                                                <td></td>
                                                                                                                                    <td colspan="2" class="command"> 
                                                                                                                                      
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
                            <td colspan="2" height="20" bgcolor="#9BC1FF"> <!-- #BeginEditable "footer" -->
                                <%@ include file = "../../main/footer.jsp" %>
                                <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
                                --%>
    </body>
    <!-- #BeginEditable "script" -->
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>