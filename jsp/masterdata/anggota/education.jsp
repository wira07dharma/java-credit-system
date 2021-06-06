<%-- 
    Document   : education_list
    Created on : Feb 22, 2013, 11:19:43 AM
    Author     : HaddyPuutraa
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
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>

<%@include file="../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE);
%>


<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

    //if of "hasn't access" condition 
    if (!privAdd && !privUpdate && !privDelete) {
%>
<script language="javascript">
    window.location = "<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
} else {
%>

<!-- Jsp Block -->
<%!
    public static final String textListTitle[][] = {
        {"Pendidikan"},
        {"Education"}
    };

    public static final String textListHeader[][] = {
        {"Pendidikan", "Deskripsi Pendidikan", "Kode Pendidikan"},
        {"Education", "Education Description", "Code Education"}
    };

    public String drawList(int iCommand, FrmEducation frmObject, Education objEntity, Vector objectClass, long educationId, int languange) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.setCellSpacing("0");

        //create tabel
        ctrlist.addHeader("No", "1%");
        ctrlist.addHeader(textListHeader[languange][2], "30%");
        ctrlist.addHeader(textListHeader[languange][0], "30%");
        ctrlist.addHeader(textListHeader[languange][1], "30%");
        ctrlist.addHeader("Action", "1%");
        //ctrlist.setLinkRow(0);
        //ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        //Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Education education = (Education) objectClass.get(i);
            rowx = new Vector();
            if (educationId == education.getOID()) {
                index = i;
            }
            rowx.add(""+(i+1)+".");
            if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmEducation.FRM_EDUCATION_CODE] + "\" value=\"" + education.getEducationCode() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmEducation.FRM_EDUCATION] + "\" value=\"" + education.getEducation() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmEducation.FRM_EDUCATION_DESC] + "\" value=\"" + education.getEducationDesc() + "\" class=\"formElemen\">");

            } else {
                rowx.add(education.getEducationCode());
                rowx.add(education.getEducation());
                rowx.add(education.getEducationDesc());
            }
            rowx.add(String.valueOf("<center><a class=\"btn btn-warning btn-xs\" href=\"javascript:cmdEdit('" + education.getOID() + "')\">Edit</a></center>"));

            lstData.add(rowx);

        }
        rowx = new Vector();
        
        if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmEducation.FRM_EDUCATION_CODE] + "\" value=\"" + objEntity.getEducationCode() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmEducation.FRM_EDUCATION] + "\" value=\"" + objEntity.getEducation() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmEducation.FRM_EDUCATION_DESC] + "\" value=\"" + objEntity.getEducationDesc() + "\" class=\"formElemen\">");
            rowx.add("");
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
    long oidEducation = FRMQueryString.requestLong(request, "hidden_education_id");
    String keyword = request.getParameter("keyword");

    // variable declaration
    boolean privManageData = true;
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;

    //variabel untuk search 
    if (keyword == null) {
        keyword = "";
    }
    String whereClause = "" + PstEducation.fieldNames[PstEducation.FLD_EDUCATION] + " LIKE '%" + keyword + "%'"
            + " OR " + PstEducation.fieldNames[PstEducation.FLD_EDUCATION_CODE] + " LIKE '%" + keyword + "%'"
            + " OR " + PstEducation.fieldNames[PstEducation.FLD_EDUCATION_DESC] + " LIKE '%" + keyword + "%'"
            + "";
    String orderClause = "" + PstEducation.fieldNames[PstEducation.FLD_EDUCATION];
    /**
     * ControlLine and Commands caption
     */
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

    CtrlEdu ctrlEducation = new CtrlEdu(request);
    iErrCode = ctrlEducation.Action(iCommand, oidEducation);
    FrmEducation frmEducation = ctrlEducation.getForm();
    Education education = ctrlEducation.getEducation();
    msgString = ctrlEducation.getMessage();

    Vector listEducation = new Vector(1, 1);
    int vectSize = PstEducation.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlEducation.actionList(iCommand, start, vectSize, recordToGet);
    }

    listEducation = PstEducation.list(start, recordToGet, whereClause, orderClause);
    if (listEducation.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listEducation = PstEducation.list(start, recordToGet, whereClause, orderClause);
    }
%>

<html>
    <!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>input#keyword{display:inline-block;}</style>
        <!-- #BeginEditable "doctitle" --> 
        <title>Accounting Information System Online</title>
        <script language="JavaScript">
            function cmdAdd() {
                document.frmEducation.hidden_education_id.value = "0";
                document.frmEducation.command.value = "<%=Command.ADD%>";
                document.frmEducation.prev_command.value = "<%=prevCommand%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdAsk(oidEducation) {
                document.frmEducation.hidden_education_id.value = oidEducation;
                document.frmEducation.command.value = "<%=Command.ASK%>";
                document.frmEducation.prev_command.value = "<%=prevCommand%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdConfirmDelete(oidEducation) {
                document.frmEducation.hidden_education_id.value = oidEducation;
                document.frmEducation.command.value = "<%=Command.DELETE%>";
                document.frmEducation.prev_command.value = "<%=prevCommand%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdSave() {
                document.frmEducation.command.value = "<%=Command.SAVE%>";
                document.frmEducation.prev_command.value = "<%=prevCommand%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdEdit(oidEducation) {
                document.frmEducation.hidden_education_id.value = oidEducation;
                document.frmEducation.command.value = "<%=Command.EDIT%>";
                document.frmEducation.prev_command.value = "<%=prevCommand%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdCancel(oidEducation) {
                document.frmEducation.hidden_education_id.value = oidEducation;
                document.frmEducation.command.value = "<%=Command.EDIT%>";
                document.frmEducation.prev_command.value = "<%=prevCommand%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdBack() {
                document.frmEducation.command.value = "<%=Command.BACK%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdListFirst() {
                document.frmEducation.command.value = "<%=Command.FIRST%>";
                document.frmEducation.prev_command.value = "<%=Command.FIRST%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdListPrev() {
                document.frmEducation.command.value = "<%=Command.PREV%>";
                document.frmEducation.prev_command.value = "<%=Command.PREV%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdListNext() {
                document.frmEducation.command.value = "<%=Command.NEXT%>";
                document.frmEducation.prev_command.value = "<%=Command.NEXT%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }

            function cmdListLast() {
                document.frmEducation.command.value = "<%=Command.LAST%>";
                document.frmEducation.prev_command.value = "<%=Command.LAST%>";
                document.frmEducation.action = "education.jsp";
                document.frmEducation.submit();
            }
        </script>
        <!-- #EndEditable -->

        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" >
        <link rel="StyleSheet" href="../../style/font-awesome/4.6.1/css/font-awesome.css" type="text/css" >
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <style>
            table {font-size: 14px}
        </style>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>Pendidikan <small></small></h1>
            <ol class="breadcrumb">
                <li><i class="fa fa-dashboard"></i> Home</li>
                <li>Master Bumdesa</li>
                <li>Status</li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Pendidikan</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="education.jsp" class="form-inline">
                        <input type="text" id="keyword" class="form-control input-sm" name="keyword">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>

                    <form name="frmEducation" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_education_id" value="<%=oidEducation%>">

                        <%= drawList(iCommand, frmEducation, education, listEducation, oidEducation, SESS_LANGUAGE)%>
                        
                        <br>
                        
                        <%
                            int cmd = 0;
                            ctrLine.setListFirstCaption("<i class=\"fa fa-angle-double-left\"></i>");
                            ctrLine.setListPrevCaption("<i class=\"fa fa-angle-left\"></i> ");
                            ctrLine.setListNextCaption("<i class=\"fa fa-angle-right\"></i> ");
                            ctrLine.setListLastCaption("<i class=\"fa fa-angle-double-right\"></i> ");
                            ctrLine.setFirstStyle("class=\"btn-primary btn-lg\"");
                            ctrLine.setPrevStyle("class=\"btn-primary btn-lg\"");
                            ctrLine.setNextStyle("class=\"btn-primary btn-lg\"");
                            ctrLine.setLastStyle("class=\"btn-primary btn-lg\"");
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
                        String scomDel = "javascript:cmdAsk('" + oidEducation + "')";
                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidEducation + "')";
                        String scancel = "javascript:cmdEdit('" + oidEducation + "')";
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
                        arr.put(SessHistory.document[SessHistory.DOC_MASTER_PENDIDIKAN]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% } %>
            
            <a href="education.jsp?show_history=<%= (showHistory == 0) ? "1":"0" %>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan":"Sembunyikan Riwayat Perubahan" %></a>
        </section>
        
    </body>
    <%
        if (iCommand == Command.ADD || iCommand == Command.EDIT) {
    %>
    <script language="javascript">
        document.frmEducation.<%=frmEducation.fieldNames[FrmEducation.FRM_EDUCATION]%>.focus();
    </script>
    <%
        }
    %>
</html>
<%
    }
%>

