<%-- 
    Document   : sedanashift
    Created on : Feb 23, 2013, 12:00:53 PM
    Author     : dw1p4
--%>

<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlSedanaShift"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmSedanaShift"%>
<%@page import="com.dimata.sedana.entity.masterdata.SedanaShift"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstSedanaShift"%>
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
<%@page import="com.dimata.aiso.entity.masterdata.region.*"%>
<%@page import="com.dimata.aiso.form.masterdata.region.*"%>


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
                {"Shift"},
                {"Shift"}
            };

    public static final String textListHeader[][]
            = {
                {"No", "Nama Shift", "Waktu Mulai", "Waktu Selesai"},
                {"Number", "Shift Name", "Start Time", "End Time"}
            };

    public String drawList(int iCommand, FrmSedanaShift frmObject, SedanaShift objEntity, Vector objectClass, long sedanaShiftId, int languange, int number) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.setCellSpacing("0");

        ctrlist.addHeader(textListHeader[languange][0], "1%");
        ctrlist.addHeader(textListHeader[languange][1], "30%");
        ctrlist.addHeader(textListHeader[languange][2], "30%");
        ctrlist.addHeader(textListHeader[languange][3], "30%");
        ctrlist.addHeader("Action", "1%");

        //ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        //Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;

        //Edit by Hadi tanggal 8 Maret 2013 penambahan field tabel Id Province
        if (iCommand == Command.FIRST) {
            number = 0;
        }
        ControlCombo comboBox = new ControlCombo();
        int countSedanaShift = PstSedanaShift.getCount("");
        Vector listSedanaShift = PstSedanaShift.list(0, countSedanaShift, "", PstSedanaShift.fieldNames[PstSedanaShift.FLD_NAME]);
        Vector sedanashiftKey = new Vector(1, 1);
        Vector sedanashiftValue = new Vector(1, 1);
        for (int i = 0; i < listSedanaShift.size(); i++) {
            SedanaShift sedanashift = (SedanaShift) listSedanaShift.get(i);
            sedanashiftKey.add("" + sedanashift.getName());
            sedanashiftValue.add(String.valueOf(sedanashift.getOID()).toString());
        }

        int i = 0;
        Vector<SedanaShift> obj = objectClass;
        for (SedanaShift sedanaShift : obj) {
            number = number + 1;
            rowx = new Vector();
            if (sedanaShiftId == sedanaShift.getOID()) {
                index = i;
            }

            if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {
                rowx.add("<center>" + number + ".</center><input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_SHIFT_ID] + "\" value=\"" + sedanaShift.getOID() + "\" class=\"formElemen\"><input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_REMARK] + "\" value='' class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_NAME] + "\" value=\"" + sedanaShift.getName() + "\" class=\"formElemen\">");
                rowx.add("" + ControlDate.drawTime(frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_START_TIME], objEntity.getStartTime()));
                rowx.add("" + ControlDate.drawTime(frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_END_TIME], objEntity.getEndTime()));
                //rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_START_TIME] + "\" value=\"" + Master.date2String(sedanaShift.getStartTime(), "HH:mm:ss") + "\" class=\"formElemen\">");
                //rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_END_TIME] + "\" value=\"" + Master.date2String(sedanaShift.getEndTime(), "HH:mm:ss") + "\" class=\"formElemen\">");

            } else {
                rowx.add("" + number + ".");
                rowx.add(sedanaShift.getName());
                rowx.add(Master.date2String(sedanaShift.getStartTime(), "HH:mm:ss"));
                rowx.add(Master.date2String(sedanaShift.getEndTime(), "HH:mm:ss"));
            }
            rowx.add(String.valueOf("<center><a class=\"btn-warning btn btn-xs\" href=\"javascript:cmdEdit('" + sedanaShift.getOID() + "')\">Edit</a></center>"));
            lstData.add(rowx);
            i++;

        }

        rowx = new Vector();

        if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_SHIFT_ID] + "\" value=\"" + objEntity.getOID() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_NAME] + "\" value=\"" + objEntity.getName() + "\" class=\"formElemen\">");
            rowx.add("" + ControlDate.drawTime(frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_START_TIME], objEntity.getStartTime()));
            rowx.add("" + ControlDate.drawTime(frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_END_TIME], objEntity.getEndTime()));
            //rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_START_TIME] + "\" value=\"" + objEntity.getStartTime()+ "\" class=\"formElemen\">");
            //rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmSedanaShift.FRM_FIELD_END_TIME] + "\" value=\"" + objEntity.getEndTime()+ "\" class=\"formElemen\">");
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
    long oidSedanaShift = FRMQueryString.requestLong(request, "hidden_sedanaShift_id");
    String keyword = request.getParameter("keyword");
// variable declaration
    boolean privManageData = true;
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    if (keyword == null) {
        keyword = "";
    }
    String whereClause = "" + PstSedanaShift.fieldNames[PstSedanaShift.FLD_NAME] + " LIKE '%" + keyword + "%'";;
    String orderClause = "" + PstSedanaShift.fieldNames[PstSedanaShift.FLD_NAME];

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

    CtrlSedanaShift ctrlSedanaShift = new CtrlSedanaShift(request);
    iErrCode = ctrlSedanaShift.action(iCommand, oidSedanaShift, request);
    FrmSedanaShift frmSedanaShift = ctrlSedanaShift.getForm();
    SedanaShift sedanaShift = ctrlSedanaShift.getSedanaShift();
    msgString = ctrlSedanaShift.getMessage();

    Vector listSedanaShift = new Vector(1, 1);
    int vectSize = PstSedanaShift.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlSedanaShift.actionList(iCommand, start, vectSize, recordToGet);
    }

    listSedanaShift = PstSedanaShift.list(start, recordToGet, whereClause, orderClause);
    if (listSedanaShift.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listSedanaShift = PstSedanaShift.list(start, recordToGet, whereClause, orderClause);
    }
%>

<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <!-- #BeginEditable "doctitle" --> 
        <title>Accounting Information System Online</title>
        <script language="JavaScript">
            function cmdAdd() {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.hidden_sedanaShift_id.value = "0";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.ADD%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdAsk(oidSedanaShift) {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.hidden_sedanaShift_id.value = oidSedanaShift;
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.ASK%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdConfirmDelete(oidSedanaShift) {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.hidden_sedanaShift_id.value = oidSedanaShift;
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.DELETE%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdSave() {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.SAVE%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdEdit(oidSedanaShift) {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.hidden_sedanaShift_id.value = oidSedanaShift;
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdCancel(oidSedanaShift) {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.hidden_sedanaShift_id.value = oidSedanaShift;
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdBack() {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.BACK%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdListFirst() {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.FIRST%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=Command.FIRST%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdListPrev() {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.PREV%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=Command.PREV%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdListNext() {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.NEXT%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=Command.NEXT%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }

            function cmdListLast() {
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.command.value = "<%=Command.LAST%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.prev_command.value = "<%=Command.LAST%>";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.action = "shift.jsp";
                document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.submit();
            }
        </script>
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <link rel="StyleSheet" href="../../style/font-awesome/4.6.1/css/font-awesome.css" type="text/css" >
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <style>#keyword{display:inline !important;}</style>
        <style>
            table {font-size: 14px}
        </style>
    </head> 

    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>Shift <small></small></h1>
            <ol class="breadcrumb">
                <li><i class="fa fa-dashboard"></i> Home</li>
                <li>Master Bumdesa</li>
                <li>Master</li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Shift</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="shift.jsp">
                        <input onFocus="this.select()" name="keyword"  type="text" id="keyword" size="25" maxlength="25">
                        <button type="submit" class="btn-primary btn btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>

                    <form name="<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_sedanaShift_id" value="<%=oidSedanaShift%>">

                        <%= drawList(iCommand, frmSedanaShift, sedanaShift, listSedanaShift, oidSedanaShift, SESS_LANGUAGE, start)%>

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
                        String scomDel = "javascript:cmdAsk('" + oidSedanaShift + "')";
                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidSedanaShift + "')";
                        String scancel = "javascript:cmdEdit('" + oidSedanaShift + "')";
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
                        arr.put(SessHistory.document[SessHistory.DOC_MASTER_SHIFT]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% }%>

            <a href="shift.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>

        </section>
    </body>

    <%
        if (iCommand == Command.ADD || iCommand == Command.EDIT) {
    %>
    <script language="javascript">
        document.<%=FrmSedanaShift.FRM_NAME_SEDANA_SHIFT%>.<%=FrmSedanaShift.fieldNames[FrmSedanaShift.FRM_FIELD_NAME]%>.focus();
    </script>
    <%
        }
    %>
</html>