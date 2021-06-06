

<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%  /* 
     * Page Name  		:  Vocation.jsp
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
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*"%>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*"%>


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

<!-- Jsp Block -->
<%!
    public static final String textListTitle[][]
            = {
                {"Jabatan Anggota"},
                {"Position Club"}
            };

    public static final String textListHeader[][]
            = {
                {"No", "Nama Jabatan"},
                {"No", "Position Name"}
            };

    public String drawList(int iCommand, FrmPosition frmObject, Position objEntity, Vector objectClass, long positionId, int languange, int start) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.setCellSpacing("0");

        ctrlist.addHeader(textListHeader[languange][0], "1%");
        ctrlist.addHeader(textListHeader[languange][1], "90%");
        ctrlist.addHeader("Action", "1%");

        //ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        //Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;
        int number = start;

        for (int i = 0; i < objectClass.size(); i++) {
            number = number + 1;
            Position position = (Position) objectClass.get(i);
            rowx = new Vector();
            if (positionId == position.getOID()) {
                index = i;
            }

            if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {
                rowx.add("" + number + ".");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmPosition.FRM_FIELD_POSITION_NAME] + "\" value=\"" + position.getPositionName() + "\" class=\"formElemen\">");
            } else {
                rowx.add("" + number + ".");
                rowx.add(position.getPositionName());
            }
            rowx.add(String.valueOf("<center><a class=\"btn btn-warning btn-xs\" href=\"javascript:cmdEdit('" + position.getOID() + "')\">Edit</a></center>"));
            lstData.add(rowx);

        }

        rowx = new Vector();

        if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmPosition.FRM_FIELD_POSITION_NAME] + "\" value=\"" + objEntity.getPositionName() + "\" class=\"formElemen\">");
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
    long oidPosition = FRMQueryString.requestLong(request, "hidden_position_id");
    String keyword = request.getParameter("keyword");
// variable declaration
    boolean privManageData = true;
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    if (keyword == null) {
        keyword = "";
    }
    String whereClause = "" + PstPosition.fieldNames[PstPosition.FLD_POSITION_NAME] + " LIKE '%" + keyword + "%'";;
    String orderClause = "" + PstPosition.fieldNames[PstPosition.FLD_POSITION_NAME];

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

    CtrlPosition ctrlPosition = new CtrlPosition(request);
    iErrCode = ctrlPosition.action(iCommand, oidPosition);
    FrmPosition frmPosition = ctrlPosition.getForm();
    Position position = ctrlPosition.getposition();
    msgString = ctrlPosition.getMessage();

    Vector listPosition = new Vector(1, 1);
    int vectSize = PstPosition.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlPosition.actionList(iCommand, start, vectSize, recordToGet);
    }

    listPosition = PstPosition.list(start, recordToGet, whereClause, orderClause);
    if (listPosition.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listPosition = PstPosition.list(start, recordToGet, whereClause, orderClause);
    }
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>input#keyword{display:inline-block;}</style>
        <!-- #BeginEditable "doctitle" --> 
        <title>Accounting Information System Online</title>
        <script language="JavaScript">
            function cmdAdd() {
                document.frmPosition.hidden_position_id.value = "0";
                document.frmPosition.command.value = "<%=Command.ADD%>";
                document.frmPosition.prev_command.value = "<%=prevCommand%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdAsk(oidPosition) {
                document.frmPosition.hidden_position_id.value = oidPosition;
                document.frmPosition.command.value = "<%=Command.ASK%>";
                document.frmPosition.prev_command.value = "<%=prevCommand%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdConfirmDelete(oidPosition) {
                document.frmPosition.hidden_position_id.value = oidPosition;
                document.frmPosition.command.value = "<%=Command.DELETE%>";
                document.frmPosition.prev_command.value = "<%=prevCommand%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdSave() {
                document.frmPosition.command.value = "<%=Command.SAVE%>";
                document.frmPosition.prev_command.value = "<%=prevCommand%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdEdit(oidPosition) {
                document.frmPosition.hidden_position_id.value = oidPosition;
                document.frmPosition.command.value = "<%=Command.EDIT%>";
                document.frmPosition.prev_command.value = "<%=prevCommand%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdCancel(oidPosition) {
                document.frmPosition.hidden_position_id.value = oidPosition;
                document.frmPosition.command.value = "<%=Command.EDIT%>";
                document.frmPosition.prev_command.value = "<%=prevCommand%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdBack() {
                document.frmPosition.command.value = "<%=Command.BACK%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdListFirst() {
                document.frmPosition.command.value = "<%=Command.FIRST%>";
                document.frmPosition.prev_command.value = "<%=Command.FIRST%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdListPrev() {
                document.frmPosition.command.value = "<%=Command.PREV%>";
                document.frmPosition.prev_command.value = "<%=Command.PREV%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdListNext() {
                document.frmPosition.command.value = "<%=Command.NEXT%>";
                document.frmPosition.prev_command.value = "<%=Command.NEXT%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
            }

            function cmdListLast() {
                document.frmPosition.command.value = "<%=Command.LAST%>";
                document.frmPosition.prev_command.value = "<%=Command.LAST%>";
                document.frmPosition.action = "position.jsp";
                document.frmPosition.submit();
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
            <h1>Jabatan <small></small></h1>
            <ol class="breadcrumb">
                <li><i class="fa fa-dashboard"></i> Home</li>
                <li>Master Bumdesa</li>
                <li>Status</li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Jabatan</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="position.jsp">
                        <input onFocus="this.select()" name="keyword"  type="text" id="keyword" size="25" maxlength="25">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>

                    <form name="frmPosition" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_position_id" value="<%=oidPosition%>">

                        <%= drawList(iCommand, frmPosition, position, listPosition, oidPosition, SESS_LANGUAGE, start)%>

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
                        String scomDel = "javascript:cmdAsk('" + oidPosition + "')";
                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidPosition + "')";
                        String scancel = "javascript:cmdEdit('" + oidPosition + "')";
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
                        arr.put(SessHistory.document[SessHistory.DOC_MASTER_POSISI]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% } %>
            
            <a href="vocation.jsp?show_history=<%= (showHistory == 0) ? "1":"0" %>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan":"Sembunyikan Riwayat Perubahan" %></a>
            
        </section>
    </body>
    <%
        if (iCommand == Command.ADD || iCommand == Command.EDIT) {
    %>
    <script language="javascript">
        document.frmPosition.<%=FrmPosition.fieldNames[FrmPosition.FRM_FIELD_POSITION_NAME]%>.focus();
    </script>
    <%
        }
    %>
</html>

