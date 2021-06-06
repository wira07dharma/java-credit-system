
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%  /* 
     * Page Name  		:  afiliasi.jsp
     * Created on 		:  [date] [time] AM/PM 
     * 
     * @author  		:  [dede] 
     * @version  		:  [version] 
     */

    /**
     * *****************************************************************
     * Page Description : [project description ... ] Imput Parameters : [input
     * parameter ...] Output : [output ...]
     * *****************************************************************
     */
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package master -->
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>


<%@include file="../../main/javainit.jsp" %>
<% //int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
    int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<%!
    public static final String textListTitle[][]
            = {
                {"Afiliasi"},
                {"Affiliation"}
            };

    public static final String textListHeader[][]
            = {
                {"No", "Nama Afiliasi", "Biaya Koperasi", "Alamat Afiliasi", "Aksi"},
                {"No", "Afiliasi Name", "Fee Koperasi", "Afiliasi Address", "Action"}
            };

    public String drawList(int iCommand, FrmAfiliasi frmObject, Afiliasi objEntity, Vector objectClass, long afiliasiId, int languange, int vectorNumber, int start) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");

        ctrlist.addHeader(textListHeader[languange][0], "1%");
        ctrlist.addHeader(textListHeader[languange][1], "");
        ctrlist.addHeader(textListHeader[languange][2], "");
        ctrlist.addHeader(textListHeader[languange][3], "");
        ctrlist.addHeader(textListHeader[languange][4], "1%");

        //ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        //Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;
        int indexNumber = start;

        for (int i = 0; i < objectClass.size(); i++) {
            indexNumber = indexNumber + 1;
            Afiliasi afiliasi = (Afiliasi) objectClass.get(i);
            rowx = new Vector();
            if (afiliasiId == afiliasi.getOID()) {
                index = i;
            }

            if (afiliasiId == afiliasi.getOID() && (iCommand == Command.EDIT || iCommand == Command.ASK || (iCommand == Command.SAVE && frmObject.errorSize() > 0))) {

                rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmAfiliasi.FRM_FIELD_AFILIASI_ID] + "\" value=\"" + objEntity.getOID() + "\" class=\"formElemen\">" + indexNumber + ".");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmAfiliasi.FRM_FIELD_NAME_AFILIASI] + "\" value=\"" + objEntity.getNamaAfiliasi() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmAfiliasi.FRM_FIELD_FEE_KOPERASI] + "\" value=\"" + objEntity.getFeeKoperasi() + "\" class=\"formElemen\">");
                rowx.add("<textarea rows=\"2\" type=\"text\" name=\"" + FrmAfiliasi.fieldNames[FrmAfiliasi.FRM_FIELD_ALAMAT_AFILIASI] + "\" class=\"formElemen\">" + objEntity.getAlamatAfiliasi() + "</textarea>");

            } else {

                rowx.add("" + indexNumber + ".");
                rowx.add(String.valueOf(afiliasi.getNamaAfiliasi()));
                rowx.add("" + Formater.formatNumber(afiliasi.getFeeKoperasi(), "###,###,###.##"));
                rowx.add(String.valueOf(afiliasi.getAlamatAfiliasi()));

            }
            rowx.add(String.valueOf("<center><a class=\"btn btn-xs btn-warning\" href=\"javascript:cmdEdit('" + afiliasi.getOID() + "')\">Ubah</a></center>"));

            lstData.add(rowx);

        }

        rowx = new Vector();

        if (afiliasiId == 0 && (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0))) {
            rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmAfiliasi.FRM_FIELD_AFILIASI_ID] + "\" value=\"" + objEntity.getOID() + "\" class=\"formElemen\">" + indexNumber + ".");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmAfiliasi.FRM_FIELD_NAME_AFILIASI] + "\" value=\"" + objEntity.getNamaAfiliasi() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmAfiliasi.FRM_FIELD_FEE_KOPERASI] + "\" value=\"" + objEntity.getFeeKoperasi() + "\" class=\"formElemen\">");
            rowx.add("<textarea rows=\"2\" type=\"text\" name=\"" + frmObject.fieldNames[FrmAfiliasi.FRM_FIELD_ALAMAT_AFILIASI] + "\" class=\"formElemen\" >" + objEntity.getAlamatAfiliasi() + "</textarea>");
            rowx.add("");
        }
        lstData.add(rowx);

        return ctrlist.draw(-1);
    }
%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int start = FRMQueryString.requestInt(request, "start");
    String keyword = FRMQueryString.requestString(request, "keyword");
    int showHistory = FRMQueryString.requestInt(request, "show_history");
    long oidAfiliasi = FRMQueryString.requestLong(request, "hidden_afiliasi_id");
    
    //
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    CtrlAfiliasi ctrlAfiliasi = new CtrlAfiliasi(request);
    iErrCode = ctrlAfiliasi.action(iCommand, oidAfiliasi);
    FrmAfiliasi frmAfiliasi = ctrlAfiliasi.getForm();
    Afiliasi afiliasi = ctrlAfiliasi.getAfiliasi();
    msgString = ctrlAfiliasi.getMessage();

    //========== ACTION LIST DATA AFILIASI ==========
    String whereClause = "" + PstAfiliasi.fieldNames[PstAfiliasi.FLD_NAME_AFILIASI] + " LIKE '%" + keyword + "%'";;
    String orderClause = "" + PstAfiliasi.fieldNames[PstAfiliasi.FLD_NAME_AFILIASI];
    
    int recordToGet = 10;
    int vectSize = PstAfiliasi.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlAfiliasi.actionList(iCommand, start, vectSize, recordToGet);
    }

    Vector listAfiliasi = PstAfiliasi.list(start, recordToGet, whereClause, orderClause);
    if (listAfiliasi.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listAfiliasi = PstAfiliasi.list(start, recordToGet, whereClause, orderClause);
    }
%>

<%//
    ControlLine ctrLine = new ControlLine();
    ctrLine.initDefault();
    ctrLine.setLanguage(SESS_LANGUAGE);
    
    String currPageTitle = textListTitle[SESS_LANGUAGE][0];
    String strAddMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda yakin akan menghapus ") + currPageTitle + " ?";

    ctrLine.setLocationImg(approot + "/images");
    ctrLine.setTableWidth("100%");
    ctrLine.setCommandStyle("");
    ctrLine.setColCommStyle("");

    ctrLine.setFirstStyle("class='btn btn-xs btn-primary'");
    ctrLine.setPrevStyle("class='btn btn-xs btn-primary'");
    ctrLine.setNextStyle("class='btn btn-xs btn-primary'");
    ctrLine.setLastStyle("class='btn btn-xs btn-primary'");
    
    ctrLine.setListFirstCaption("<<");
    ctrLine.setListPrevCaption("<");
    ctrLine.setListNextCaption(">");
    ctrLine.setListLastCaption(">>");
    
    ctrLine.setDeleteCommand("javascript:cmdAsk('" + oidAfiliasi + "')");
    ctrLine.setConfirmDelCommand("javascript:cmdConfirmDelete('" + oidAfiliasi + "')");
    ctrLine.setCancelCommand("javascript:cmdCancel('" + oidAfiliasi + "')");
    
    ctrLine.setAddStyle("class=\"btn btn-sm btn-primary\"");
    ctrLine.setSaveStyle("class=\"btn btn-sm btn-success\"");
    ctrLine.setDeleteStyle("class=\"btn btn-sm btn-danger\"");
    ctrLine.setConfirmStyle("class=\"btn btn-sm btn-success\"");
    ctrLine.setCancelStyle("class=\"btn btn-sm btn-warning\"");
    ctrLine.setBackStyle("class=\"btn btn-sm btn-primary\"");

    ctrLine.setAddCaption("<i class=\"fa fa-plus\"></i> " + strAddMar);
    ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveMar);
    ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskMar);
    ctrLine.setDeleteQuestion(delConfirm);
    ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> " + strDeleteMar);
    ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
    ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackMar);

    if (privAdd == false) {
        ctrLine.setAddCaption("");
    }

    if (privUpdate == false) {
        ctrLine.setSaveCaption("");
    }

    if (privDelete == false) {
        ctrLine.setDeleteCaption("");
    }

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>
        
        <%@ include file = "/style/lte_head.jsp" %>
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        
        <style>
            table {font-size: 14px}
            .listtitle{padding-bottom:5px;}
            .listgenactivity{margin-top:20px !important;}
            .listgenactivity td{padding-left:5px !important;padding-right:5px !important;}
            .listgentitle {background-color: #00a65a; color: white; font-weight: normal;}
            .listgensell input[type=text], .listgensellOdd input[type=text], textArea {width: 100%}
        </style>
        
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <script language="JavaScript">
            function cmdAdd() {
                document.frmAfiliasi.hidden_afiliasi_id.value = "0";
                document.frmAfiliasi.command.value = "<%=Command.ADD%>";
                document.frmAfiliasi.prev_command.value = "<%=prevCommand%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdAsk(oidAfiliasi) {
                document.frmAfiliasi.hidden_afiliasi_id.value = oidAfiliasi;
                document.frmAfiliasi.command.value = "<%=Command.ASK%>";
                document.frmAfiliasi.prev_command.value = "<%=prevCommand%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdConfirmDelete(oidAfiliasi) {
                document.frmAfiliasi.hidden_afiliasi_id.value = oidAfiliasi;
                document.frmAfiliasi.command.value = "<%=Command.DELETE%>";
                document.frmAfiliasi.prev_command.value = "<%=prevCommand%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdSave() {
                document.frmAfiliasi.command.value = "<%=Command.SAVE%>";
                document.frmAfiliasi.prev_command.value = "<%=prevCommand%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdEdit(oidAfiliasi) {
                document.frmAfiliasi.hidden_afiliasi_id.value = oidAfiliasi;
                document.frmAfiliasi.command.value = "<%=Command.EDIT%>";
                document.frmAfiliasi.prev_command.value = "<%=prevCommand%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdCancel(oidAfiliasi) {
                document.frmAfiliasi.hidden_afiliasi_id.value = oidAfiliasi;
                document.frmAfiliasi.command.value = "<%=Command.EDIT%>";
                document.frmAfiliasi.prev_command.value = "<%=prevCommand%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdBack() {
                document.frmAfiliasi.command.value = "<%=Command.BACK%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdListFirst() {
                document.frmAfiliasi.command.value = "<%=Command.FIRST%>";
                document.frmAfiliasi.prev_command.value = "<%=Command.FIRST%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdListPrev() {
                document.frmAfiliasi.command.value = "<%=Command.PREV%>";
                document.frmAfiliasi.prev_command.value = "<%=Command.PREV%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdListNext() {
                document.frmAfiliasi.command.value = "<%=Command.NEXT%>";
                document.frmAfiliasi.prev_command.value = "<%=Command.NEXT%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }

            function cmdListLast() {
                document.frmAfiliasi.command.value = "<%=Command.LAST%>";
                document.frmAfiliasi.prev_command.value = "<%=Command.LAST%>";
                document.frmAfiliasi.action = "afiliasi.jsp";
                document.frmAfiliasi.submit();
            }
        </script>
    </head>

    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>Afiliasi <small></small></h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Tabungan</li>
                <li class="active"><a href="#">Afiliasi</a></li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Afiliasi</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="afiliasi.jsp" class="form-inline">
                        <input type="text" name="keyword" id="keyword" class="form-control input-sm" value="<%=keyword%>">
                        <button type="submit" class="btn-primary btn btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>

                    <form name="frmAfiliasi" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_afiliasi_id" value="<%=oidAfiliasi%>">

                        <%= drawList(iCommand, frmAfiliasi, afiliasi, listAfiliasi, oidAfiliasi, SESS_LANGUAGE, vectSize, start)%>
                        <%if(listAfiliasi.isEmpty()) {out.println("<br>Tidak ada data");}%>
                        
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
                        <br>
                        <%=ctrLine.drawMeListLimit(cmd, vectSize, start, recordToGet, "cmdListFirst", "cmdListPrev", "cmdListNext", "cmdListLast", "left")%>
                    </form>

                    <%=ctrLine.draw(iCommand, iErrCode, msgString)%>
                </div>
            </div>

            <a href="afiliasi.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>
            <p></p>
            <% if (showHistory == 1) { %>
            <div class="box box-default">
                <div class="box-header">
                    <h3 class="box-title">Riwayat Perubahan</h3>
                </div>
                <div class="box-body">
                    <%
                        JSONObject obj = new JSONObject();
                        JSONArray arr = new JSONArray();
                        arr.put(SessHistory.document[SessHistory.DOC_MASTER_AFILIASI]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% } %>

        </section>
    </body>
    <%
        if (iCommand == Command.ADD || iCommand == Command.EDIT) {
    %>
    <script language="javascript">
        document.frmAfiliasi.<%=FrmAfiliasi.fieldNames[FrmAfiliasi.FRM_FIELD_NAME_AFILIASI]%>.focus();
    </script>
    <%
        }
    %>
</html>

