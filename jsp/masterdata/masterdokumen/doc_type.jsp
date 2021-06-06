<%-- 
    Document   : doc_type
    Created on : 19-Dec-2017, 11:10:15
    Author     : Gunadi
--%>

<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
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
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page import="com.dimata.harisma.form.masterdata.*"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>

<%@include file="../../main/javainit.jsp" %>
<% //int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
    int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_DOCUMENT, AppObjInfo.OBJ_DOCUMENT_TYPE);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<%!
    public static final String textListTitle[]
            = {
                "Jenis Dokumen", "Document Type"
            };

    public static final String textListHeader[][]
            = {
                {"No", "Jenis Dokumen", "Deskripsi", "Aksi"},
                {"No", "Document Type", "Description", "Action"}
            };

    public String drawList(int iCommand, FrmDocType frmObject, DocType objEntity, Vector objectClass, long docTypeId, int languange, int vectorNumber, int start) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");

        ctrlist.addHeader(textListHeader[languange][0], "1%");
        ctrlist.addHeader(textListHeader[languange][1], "30%");
        ctrlist.addHeader(textListHeader[languange][2], "40%");
        ctrlist.addHeader(textListHeader[languange][3], "1%");

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
            DocType docType = (DocType) objectClass.get(i);
            rowx = new Vector();
            if (docTypeId == docType.getOID()) {
                index = i;
            }

            if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {

                rowx.add("<center><input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmDocType.FRM_FIELD_DOC_TYPE_ID] + "\" value=\"" + docType.getOID() + "\" class=\"formElemen\">" + indexNumber + ".</center>");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmDocType.FRM_FIELD_TYPE_NAME] + "\" value=\"" + docType.getType_name() + "\" class=\"formElemen\">");
                rowx.add("<textarea cols=\"35\" rows=\"2\" type=\"text\" name=\"" + frmObject.fieldNames[FrmDocType.FRM_FIELD_DESCRIPTION] + "\" value=\"" + docType.getDescription() + "\" class=\"formElemen\">" + docType.getDescription() + "</textarea>");

            } else {

                rowx.add("" + indexNumber + ".");
                rowx.add(String.valueOf(docType.getType_name()));
                rowx.add(String.valueOf(docType.getDescription()));

            }
            rowx.add(String.valueOf("<center><a class=\"btn-warning btn btn-xs\" style=\"color:#FFF\" href=\"javascript:cmdEdit('" + docType.getOID() + "')\">Edit</a></center>"));

            lstData.add(rowx);

        }

        rowx = new Vector();

        if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("<center><input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmDocType.FRM_FIELD_DOC_TYPE_ID] + "\" value=\"" + objEntity.getOID() + "\" class=\"formElemen\">" + (indexNumber + 1) + ".</center>");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmDocType.FRM_FIELD_TYPE_NAME] + "\" value=\"" + objEntity.getType_name() + "\" class=\"formElemen\">");
            rowx.add("<textarea clos=\"35\" rows=\"2\" type=\"text\" name=\"" + frmObject.fieldNames[FrmDocType.FRM_FIELD_DESCRIPTION] + "\" value=\"" + objEntity.getDescription() + "\" class=\"formElemen\"></textarea>");
            rowx.add("-");
        }
        lstData.add(rowx);

        return ctrlist.draw(-1);
    }
%>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    int showHistory = FRMQueryString.requestInt(request, "show_history");
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidDocType = FRMQueryString.requestLong(request, "hidden_doctype_id");
    String keyword = request.getParameter("keyword");
    // variable declaration
    boolean privManageData = true;
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    if (keyword == null) {
        keyword = "";
    }
    String whereClause = "" + PstDocType.fieldNames[PstDocType.FLD_TYPE_NAME] + " LIKE '%" + keyword + "%'"
            + " OR " + PstDocType.fieldNames[PstDocType.FLD_DESCRIPTION] + " LIKE '%" + keyword + "%'"
            + "";
    String orderClause = "" + PstDocType.fieldNames[PstDocType.FLD_TYPE_NAME];

    /**
     * ControlLine and Commands caption
     */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = textListTitle[SESS_LANGUAGE];
    String strAddMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";

    CtrlDocType ctrlDocType = new CtrlDocType(request);
    iErrCode = ctrlDocType.action(iCommand, oidDocType);
    FrmDocType frmDocType = ctrlDocType.getForm();
    DocType docType = ctrlDocType.getdDocType();
    msgString = ctrlDocType.getMessage();

    Vector listDocType = new Vector(1, 1);
    int vectSize = PstDocType.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlDocType.actionList(iCommand, start, vectSize, recordToGet);
    }

    listDocType = PstDocType.list(start, recordToGet, whereClause, orderClause);

    if (listDocType.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listDocType = PstDocType.list(start, recordToGet, whereClause, orderClause);
    }
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>
            input#keyword{display:inline-block;}
            .listtitle{padding-bottom:5px;}
            .listgenactivity{margin-top:20px !important;}
            .listgenactivity td{padding-left:5px !important;padding-right:5px !important;}
            table {font-size: 14px}
        </style>
        <!-- #BeginEditable "doctitle" --> 
        <title>Accounting Information System Online</title>
        <script language="JavaScript">
            function cmdAdd() {
                document.frmDocType.hidden_doctype_id.value = "0";
                document.frmDocType.command.value = "<%=Command.ADD%>";
                document.frmDocType.prev_command.value = "<%=prevCommand%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdAsk(oidDocType) {
                document.frmDocType.hidden_doctype_id.value = oidDocType;
                document.frmDocType.command.value = "<%=Command.ASK%>";
                document.frmDocType.prev_command.value = "<%=prevCommand%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdConfirmDelete(oidDocType) {
                document.frmDocType.hidden_doctype_id.value = oidDocType;
                document.frmDocType.command.value = "<%=Command.DELETE%>";
                document.frmDocType.prev_command.value = "<%=prevCommand%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdSave() {
                document.frmDocType.command.value = "<%=Command.SAVE%>";
                document.frmDocType.prev_command.value = "<%=prevCommand%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdEdit(oidDocType) {
                document.frmDocType.hidden_doctype_id.value = oidDocType;
                document.frmDocType.command.value = "<%=Command.EDIT%>";
                document.frmDocType.prev_command.value = "<%=prevCommand%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdCancel(oidDocType) {
                document.frmDocType.hidden_doctype_id.value = oidDocType;
                document.frmDocType.command.value = "<%=Command.EDIT%>";
                document.frmDocType.prev_command.value = "<%=prevCommand%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdBack() {
                document.frmDocType.command.value = "<%=Command.BACK%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdListFirst() {
                document.frmDocType.command.value = "<%=Command.FIRST%>";
                document.frmDocType.prev_command.value = "<%=Command.FIRST%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdListPrev() {
                document.frmDocType.command.value = "<%=Command.PREV%>";
                document.frmDocType.prev_command.value = "<%=Command.PREV%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdListNext() {
                document.frmDocType.command.value = "<%=Command.NEXT%>";
                document.frmDocType.prev_command.value = "<%=Command.NEXT%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }

            function cmdListLast() {
                document.frmDocType.command.value = "<%=Command.LAST%>";
                document.frmDocType.prev_command.value = "<%=Command.LAST%>";
                document.frmDocType.action = "doc_type.jsp";
                document.frmDocType.submit();
            }
        </script>
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <link rel="StyleSheet" href="../../style/font-awesome/4.6.1/css/font-awesome.css" type="text/css" >
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
    </head> 

    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>Jenis Dokumen<small></small></h1>
            <ol class="breadcrumb">
                <li><i class="fa fa-dashboard"></i> Home</li>
                <li>Master Bumdesa</li>
                <li>Master Dokumen</li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Jenis Dokumen</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="doc_type.jsp">
                        <input onFocus="this.select()" name="keyword"  type="text" id="keyword" size="25" maxlength="25">
                        <button type="submit" class="btn-primary btn btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>

                    <form name="frmDocType" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_doctype_id" value="<%=oidDocType%>">

                        <%= drawList(iCommand, frmDocType, docType, listDocType, oidDocType, SESS_LANGUAGE, vectSize, start)%>

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
                    </form>

                    <%
                        ctrLine.setLocationImg(approot + "/images");
                        ctrLine.initDefault();
                        ctrLine.setTableWidth("80%");
                        String scomDel = "javascript:cmdAsk('" + oidDocType + "')";
                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidDocType + "')";
                        String scancel = "javascript:cmdEdit('" + oidDocType + "')";
                        ctrLine.setCommandStyle("command");
                        ctrLine.setColCommStyle("command");
                        ctrLine.setAddStyle("class=\"btn-primary btn-lg\"");
                        ctrLine.setCancelStyle("class=\"btn-delete btn-lg\"");
                        ctrLine.setDeleteStyle("class=\"btn-delete btn-lg\"");
                        ctrLine.setBackStyle("class=\"btn-primary btn-lg\"");
                        ctrLine.setSaveStyle("class=\"btn-save btn-lg\"");
                        ctrLine.setConfirmStyle("class=\"btn-primary btn-lg\"");
                        ctrLine.setAddCaption("<i class=\"fa fa-plus-circle\"></i> " + strAddMar);
                        //ctrLine.setBackCaption("");
                        ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
                        ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackMar);
                        ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveMar);
                        ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskMar);
                        ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> " + strDeleteMar);

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

                        if (iCommand == Command.ASK) {
                            ctrLine.setDeleteQuestion(delConfirm);
                        }
                        out.println(ctrLine.draw(iCommand, iErrCode, msgString));
                    %>
                </div>
            </div>

            <% if (showHistory == 1) { %>
            <div class="box box-danger">
                <div class="box-header">
                    <h3 class="box-title">Riwayat Perubahan</h3>
                </div>
                <div class="box-body">
                    <%
                        JSONObject obj = new JSONObject();
                        JSONArray arr = new JSONArray();
                        arr.put(SessHistory.document[SessHistory.DOC_JENIS_DOKUMEN]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% }%>

            <a href="doc_type.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>

        </section>
    </body>
    <%
        if (iCommand == Command.ADD || iCommand == Command.EDIT) {
    %>
    <script language="javascript">
        document.frmDoctype.<%=FrmDocType.fieldNames[FrmDocType.FRM_FIELD_TYPE_NAME]%>.focus();
    </script>
    <%
        }
    %>
</html>