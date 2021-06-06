<%-- 
    Document   : relevant_doc_group
    Created on : Dec 28, 2017, 5:35:44 PM
    Author     : dedy_blinda
--%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmEmpRelevantDocGroup"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlEmpRelevantDocGroup"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstEmpRelevantDocGroup"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.sedana.entity.masterdata.EmpRelevantDocGroup"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@page import="java.util.Vector"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@include file="../main/javainit.jsp" %>
<% //int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
    int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE);%>
<%@ include file = "../main/checkuser.jsp" %>

<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<%!    public static final String textListTitle[][] = {
        {"Kelompok Dokumen"},
        {"Document Group"}
    };
    public static final String textListHeader[][] = {
        {"Kelompok Dokumen", "Deskripsi"},
        {"Doc Group", "Doc Description"}
    };

    public String drawList(int iCommand, Vector objectClass, long docId, int languange, FrmEmpRelevantDocGroup frmEmpRelevantDocGroup) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");

        /* ctrlist.addHeader("System","10%");
         ctrlist.addHeader("Modul","20%");*/
        ctrlist.addHeader("No", "1%");
        ctrlist.addHeader(textListHeader[languange][0], "20%");
        ctrlist.addHeader(textListHeader[languange][1], "50%");
        ctrlist.addHeader("Action", "1%");

        //ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        //Vector lstLinkData = ctrlist.getLinkData();
        //ctrlist.setLinkPrefix("javascript:cmdEdit('");
        //ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;
        Vector rowx = new Vector();
        String modul = "-";

        for (int i = 0; i < objectClass.size(); i++) {
            EmpRelevantDocGroup empRelevantDocGroup = (EmpRelevantDocGroup) objectClass.get(i);
            rowx = new Vector();
            if (docId == empRelevantDocGroup.getOID()) {
                index = i;
            }
            /*    try{    
             modul = I_System.MODULS[empRelevantDocGroup.getSystemName()][empRelevantDocGroup.getModul()];
             } catch(Exception e) {
             modul = "-";
             }
                         
             rowx.add(""+I_System.SYSTEM_NAME[empRelevantDocGroup.getSystemName()]);
             rowx.add(""+modul);*/
            rowx.add("" + (i + 1) + ".");
            if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {
                rowx.add("<input type=\"hidden\" name=\"" + frmEmpRelevantDocGroup.fieldNames[FrmEmpRelevantDocGroup.FRM_FIELD_EMP_RELVT_DOC_GRP_ID] + "\" value=\"" + empRelevantDocGroup.getOID() + "\" class=\"formElemen\">"
                        + "<input type=\"text\" name=\"" + frmEmpRelevantDocGroup.fieldNames[FrmEmpRelevantDocGroup.FRM_FIELD_DOC_GROUP] + "\" value=\"" + empRelevantDocGroup.getDocGroup() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmEmpRelevantDocGroup.fieldNames[FrmEmpRelevantDocGroup.FRM_FIELD_DOC_GROUP_DESC] + "\" value=\"" + empRelevantDocGroup.getDocGroupDesc() + "\" class=\"formElemen\">");
                rowx.add("-");
            } else {
                rowx.add(empRelevantDocGroup.getDocGroup());
                rowx.add(empRelevantDocGroup.getDocGroupDesc());
                rowx.add(String.valueOf("<center><a class=\"btn-warning btn btn-xs\" style=\"color:#FFF\" href=\"javascript:cmdEdit('" + empRelevantDocGroup.getOID() + "')\">Edit</a></center>"));
            }
            lstData.add(rowx);
            //lstLinkData.add(String.valueOf(empRelevantDocGroup.getOID()));
        }

        rowx = new Vector();

        if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmEmpRelevantDocGroup.errorSize() > 0)) {
            rowx.add("");
            rowx.add("<input type=\"hidden\" name=\"" + frmEmpRelevantDocGroup.fieldNames[FrmEmpRelevantDocGroup.FRM_FIELD_EMP_RELVT_DOC_GRP_ID] + "\" value=\"\" class=\"formElemen\">"
                    + "<input type=\"text\" name=\"" + frmEmpRelevantDocGroup.fieldNames[FrmEmpRelevantDocGroup.FRM_FIELD_DOC_GROUP] + "\" value=\"\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmEmpRelevantDocGroup.fieldNames[FrmEmpRelevantDocGroup.FRM_FIELD_DOC_GROUP_DESC] + "\" value=\"\" class=\"formElemen\">");
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
    long oidDocGroupId = FRMQueryString.requestLong(request, "hidden_doc_group_id");
    String source = FRMQueryString.requestString(request, "source");
//int modul = FRMQueryString.requestInt(request, PstEmpRelevantDocGroup.fieldNames[PstEmpRelevantDocGroup.FLD_MODUL]);

    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = PstEmpRelevantDocGroup.fieldNames[PstEmpRelevantDocGroup.FLD_EMP_RELVT_DOC_GRP_ID];

    CtrlEmpRelevantDocGroup ctrlEmpRelevantDocGroup = new CtrlEmpRelevantDocGroup(request);
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = textListTitle[SESS_LANGUAGE][0];
    String strAddMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";

    Vector listDocGroup = new Vector(1, 1);

    /*switch statement */
    iErrCode = ctrlEmpRelevantDocGroup.action(iCommand, oidDocGroupId);
    /* end switch*/
    FrmEmpRelevantDocGroup frmEmpRelevantDocGroup = ctrlEmpRelevantDocGroup.getForm();

    /*count list All GradeLevel*/
    int vectSize = PstEmpRelevantDocGroup.getCount(whereClause);

    EmpRelevantDocGroup empRelevantDocGroup = ctrlEmpRelevantDocGroup.getEmpRelevantDocGroup();
    msgString = ctrlEmpRelevantDocGroup.getMessage();

    /*switch list GradeLevel*/
    if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)) {
        //start = PstGradeLevel.findLimitStart(gradeLevel.getOID(),recordToGet, whereClause, orderClause);
        oidDocGroupId = empRelevantDocGroup.getOID();
    }

    if ((iCommand == Command.FIRST || iCommand == Command.PREV)
            || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
        start = ctrlEmpRelevantDocGroup.actionList(iCommand, start, vectSize, recordToGet);
    }
    /* end switch list*/

    /* get record to display */
    listDocGroup = PstEmpRelevantDocGroup.list(start, recordToGet, whereClause, orderClause);

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listDocGroup.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listDocGroup = PstEmpRelevantDocGroup.list(start, recordToGet, whereClause, orderClause);
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>input#keyword{display:inline-block;}</style>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="../dtree/dtree.js"></script>
        <style>
            table {font-size: 14px}
        </style>
        <script language="JavaScript">
            function cmdAdd() {
                document.frmDocGroup.hidden_doc_group_id.value = "0";
                document.frmDocGroup.command.value = "<%=Command.ADD%>";
                document.frmDocGroup.prev_command.value = "<%=prevCommand%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }

            function cmdAsk(oidRelevant) {
                document.frmDocGroup.hidden_doc_group_id.value = oidRelevant;
                document.frmDocGroup.command.value = "<%=Command.ASK%>";
                document.frmDocGroup.prev_command.value = "<%=prevCommand%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }

            function cmdConfirmDelete(oidRelevant) {
                document.frmDocGroup.hidden_doc_group_id.value = oidRelevant;
                document.frmDocGroup.command.value = "<%=Command.DELETE%>";
                document.frmDocGroup.prev_command.value = "<%=prevCommand%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }

            function cmdSave() {
                document.frmDocGroup.command.value = "<%=Command.SAVE%>";
                document.frmDocGroup.prev_command.value = "<%=prevCommand%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }

            function cmdEdit(oidRelevant) {
                document.frmDocGroup.hidden_doc_group_id.value = oidRelevant;
                document.frmDocGroup.command.value = "<%=Command.EDIT%>";
                document.frmDocGroup.prev_command.value = "<%=prevCommand%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }

            function cmdCancel(oidRelevant) {
                document.frmDocGroup.hidden_doc_group_id.value = oidRelevant;
                document.frmDocGroup.command.value = "<%=Command.EDIT%>";
                document.frmDocGroup.prev_command.value = "<%=prevCommand%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }

            function cmdBack() {
                document.frmDocGroup.command.value = "<%=Command.BACK%>";
                document.frmDocGroup.submit();
            }

            function cmdListFirst() {
                document.frmDocGroup.command.value = "<%=Command.FIRST%>";
                document.frmDocGroup.prev_command.value = "<%=Command.FIRST%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }

            function cmdListPrev() {
                document.frmDocGroup.command.value = "<%=Command.PREV%>";
                document.frmDocGroup.prev_command.value = "<%=Command.PREV%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }

            function cmdListNext() {
                document.frmDocGroup.command.value = "<%=Command.NEXT%>";
                document.frmDocGroup.prev_command.value = "<%=Command.NEXT%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }

            function cmdListLast() {
                document.frmDocGroup.command.value = "<%=Command.LAST%>";
                document.frmDocGroup.prev_command.value = "<%=Command.LAST%>";
                document.frmDocGroup.action = "relevant_doc_group.jsp";
                document.frmDocGroup.submit();
            }
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>Kelompok Dokumen<small></small></h1>
            <ol class="breadcrumb">
                <li><i class="fa fa-dashboard"></i> Home</li>
                <li>Master Bumdesa</li>
                <li>Master</li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Kelompok Dokumen</h3>
                </div>
                <div class="box-body">
                    <form name="frmDocGroup" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_doc_group_id" value="<%=oidDocGroupId%>">
                        <input type="hidden" name="source" value="">

                        <%= drawList(iCommand, listDocGroup, oidDocGroupId, SESS_LANGUAGE, frmEmpRelevantDocGroup)%>

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
                        String scomDel = "javascript:cmdAsk('" + oidDocGroupId + "')";
                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidDocGroupId + "')";
                        String scancel = "javascript:cmdEdit('" + oidDocGroupId + "')";
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
                        arr.put(SessHistory.document[SessHistory.DOC_RELEVANT_DOC_GROUP]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% }%>

            <a href="relevant_doc_group.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>

        </section>
    </body>
</html>
