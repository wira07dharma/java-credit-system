
<%@page import="com.dimata.sedana.entity.masterdata.PstJangkaWaktuMarkup"%>
<%@page import="com.dimata.sedana.entity.masterdata.JangkaWaktuMarkup"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmJangkaWaktuMarkup"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlJangkaWaktuMarkup"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.qdep.db.DBException"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%  /* 
     * Page Name  		:  jenis_simpanan.jsp
     * Created on 		:  [date] [time] AM/PM 
     * 
     * @author  		:  [dede nuharta] 
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
                {"Jangka Waktu"},
                {"Range Time"}
            };

    public static final String textListHeader[][]
            = {
                {"No", "Jangka Waktu", "Markup Pct", "Markup Type", "Lokasi"},
                {"No", "Range Time", "Markup Pct", "Markup Type", "Location"}
            };

    public String drawList(int iCommand, FrmJangkaWaktuMarkup frmObject, JangkaWaktuMarkup objEntity, Vector objectClass, long jenisSimpananId, int languange, int vectorNumber, int start) {
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
        ctrlist.addHeader("Action", "1%");

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
            JangkaWaktuMarkup jw = (JangkaWaktuMarkup) objectClass.get(i);
            rowx = new Vector();
            if (jenisSimpananId == jw.getOID()) {
                index = i;
            }
            if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {        
                rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmJangkaWaktuMarkup.FRM_FIELD_JANGKA_WAKTU_MARKUP_ID] + "\" value=\"" + jw.getOID() + "\" class=\"\">" + indexNumber + ".");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmJangkaWaktuMarkup.FRM_FIELD_MARKUP_PCT] + "\" value=\"" +jw.getMarkupPct()+ "\" class=\"\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmJangkaWaktuMarkup.FRM_FIELD_MARKUP_TYPE] + "\" value=\"" +jw.getMarkupType()+ "\" class=\"\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmJangkaWaktuMarkup.FRM_FIELD_USE_AS_CASH_CALCULATION] + "\" value=\"" +jw.getCashCalculation()+ "\" class=\"\">");
                rowx.add("-");
            } else {
                rowx.add("" + indexNumber + ".");
                rowx.add(""+jw.getMarkupPct());
                rowx.add(""+jw.getMarkupType());
                rowx.add(""+jw.getCashCalculation());
                rowx.add(String.valueOf("<center><a class=\"btn btn-warning btn-xs\" href=\"javascript:cmdEdit('" + jw.getOID() + "')\">Edit</a></center>"));
            }
            lstData.add(rowx);

        }

        rowx = new Vector();
        if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmJangkaWaktuMarkup.FRM_FIELD_JANGKA_WAKTU_MARKUP_ID] + "\" value=\"" + objEntity.getOID() + "\" class=\"\">" + indexNumber + "");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmJangkaWaktuMarkup.FRM_FIELD_MARKUP_PCT] + "\" value=\"" +objEntity.getMarkupPct()+ "\" class=\"\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmJangkaWaktuMarkup.FRM_FIELD_MARKUP_TYPE] + "\" value=\"" +objEntity.getMarkupType()+ "\" class=\"\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmJangkaWaktuMarkup.FRM_FIELD_USE_AS_CASH_CALCULATION] + "\" value=\"" +objEntity.getCashCalculation()+ "\" class=\"\">");
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
    long oidJangkaWaktu = FRMQueryString.requestLong(request, "hidden_jangka_waktu_id");
    String keyword = request.getParameter("keyword");
    // variable declaration
    boolean privManageData = true;
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    if (keyword == null) {
        keyword = "";
    }
    String whereClause = "" + PstJangkaWaktuMarkup.fieldNames[PstJangkaWaktuMarkup.FLD_MARKUP_TYPE] + " LIKE '%" + keyword + "%'";;
    String orderClause = "" + PstJangkaWaktuMarkup.fieldNames[PstJangkaWaktuMarkup.FLD_MARKUP_TYPE];

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

    CtrlJangkaWaktuMarkup ctrlJangkaWaktuMarkup = new CtrlJangkaWaktuMarkup(request);
    iErrCode = ctrlJangkaWaktuMarkup.action(iCommand, oidJangkaWaktu);
    FrmJangkaWaktuMarkup frmJangkaWaktuMarkup = ctrlJangkaWaktuMarkup.getForm();
    JangkaWaktuMarkup jangkaWaktuMarkup = ctrlJangkaWaktuMarkup.getJangkaWaktuMarkup();
    msgString = ctrlJangkaWaktuMarkup.getMessage();

    Vector listJangkaWaktu = new Vector(1, 1);
    int vectSize = PstJangkaWaktuMarkup.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlJangkaWaktuMarkup.actionList(iCommand, start, vectSize, recordToGet);
    }

    listJangkaWaktu = PstJangkaWaktuMarkup.list(start, recordToGet, whereClause, orderClause);

    if (listJangkaWaktu.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listJangkaWaktu = PstJangkaWaktuMarkup.list(start, recordToGet, whereClause, orderClause);
    }
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>input#keyword{display:inline-block;}</style>
        <!-- #BeginEditable "doctitle" --> 
        <title>SEDANA -  Sistem Manajemen Simpan Pinjam</title>
        <script language="JavaScript">
            function cmdAdd() {
                document.frmJangkaWaktu.hidden_jangka_waktu_id.value = "0";
                document.frmJangkaWaktu.command.value = "<%=Command.ADD%>";
                document.frmJangkaWaktu.prev_command.value = "<%=prevCommand%>";
                document.frmJangkaWaktu.action = "jangkaWaktuMarkup.jsp";
                document.frmJangkaWaktu.submit();
            }

            function cmdAsk(oidJangkaWaktu) {
                document.frmJangkaWaktu.hidden_jangka_waktu_id.value = oidJangkaWaktu;
                document.frmJangkaWaktu.command.value = "<%=Command.ASK%>";
                document.frmJangkaWaktu.prev_command.value = "<%=prevCommand%>";
                document.frmJangkaWaktu.action = "jangkaWaktuMarkup.jsp";
                document.frmJangkaWaktu.submit();
            }

            function cmdConfirmDelete(oidJangkaWaktu) {
                document.frmJangkaWaktu.hidden_jangka_waktu_id.value = oidJangkaWaktu;
                document.frmJangkaWaktu.command.value = "<%=Command.DELETE%>";
                document.frmJangkaWaktu.prev_command.value = "<%=prevCommand%>";
                document.frmJangkaWaktu.action = "jangkaWaktuMarkup.jsp";
                document.frmJangkaWaktu.submit();
            }

            function cmdSave() {
                document.frmJangkaWaktu.command.value = "<%=Command.SAVE%>";
                document.frmJangkaWaktu.prev_command.value = "<%=prevCommand%>";
                document.frmJangkaWaktu.action = "jangkaWaktuMarkup.jsp";
                document.frmJangkaWaktu.submit();
            }

            function cmdEdit(oidJangkaWaktu) {
                document.frmJangkaWaktu.hidden_jangka_waktu_id.value = oidJangkaWaktu;
                document.frmJangkaWaktu.command.value = "<%=Command.EDIT%>";
                document.frmJangkaWaktu.prev_command.value = "<%=prevCommand%>";
                document.frmJangkaWaktu.action = "jangkaWaktuMarkup.jsp";
                document.frmJangkaWaktu.submit();
            }

            function cmdCancel(oidJangkaWaktu) {
                document.frmJangkaWaktu.hidden_jangka_waktu_id.value = oidJangkaWaktu;
                document.frmJangkaWaktu.command.value = "<%=Command.EDIT%>";
                document.frmJangkaWaktu.prev_command.value = "<%=prevCommand%>";
                document.frmJangkaWaktu.action = "jangkaWaktuMarkup.jsp";
                document.frmJangkaWaktu.submit();
            }

            function cmdBack() {
                document.frmJangkaWaktu.command.value = "<%=Command.BACK%>";
                document.frmJangkaWaktu.submit();
            }

            function cmdListFirst() {
                document.frmJangkaWaktu.command.value = "<%=Command.FIRST%>";
                document.frmJangkaWaktu.prev_command.value = "<%=Command.FIRST%>";
                document.frmJangkaWaktu.action = "jenis_simpanan.jsp";
                document.frmJangkaWaktu.submit();
            }

            function cmdListPrev() {
                document.frmJangkaWaktu.command.value = "<%=Command.PREV%>";
                document.frmJangkaWaktu.prev_command.value = "<%=Command.PREV%>";
                document.frmJangkaWaktu.action = "jenis_simpanan.jsp";
                document.frmJangkaWaktu.submit();
            }

            function cmdListNext() {
                document.frmJangkaWaktu.command.value = "<%=Command.NEXT%>";
                document.frmJangkaWaktu.prev_command.value = "<%=Command.NEXT%>";
                document.frmJangkaWaktu.action = "jenis_simpanan.jsp";
                document.frmJangkaWaktu.submit();
            }

            function cmdListLast() {
                document.frmJangkaWaktu.command.value = "<%=Command.LAST%>";
                document.frmJangkaWaktu.prev_command.value = "<%=Command.LAST%>";
                document.frmJangkaWaktu.action = "jenis_simpanan.jsp";
                document.frmJangkaWaktu.submit();
            }
        </script>
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <style>
            table {font-size: 14px}
        </style>
    </head> 

    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>Jangka Waktu <small></small></h1>
            <ol class="breadcrumb">
                <li><i class="fa fa-dashboard"></i> Home</li>
                <li>Master Sedana</li>
                <li>Master</li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Jangka Waktu</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="jangkaWaktuMarkup.jsp" class="form-inline">
                        <input type="text" name="keyword" id="keyword" class="form-control input-sm">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form> 

                    <form name="frmJangkaWaktu" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_jangka_waktu_id" value="<%=oidJangkaWaktu%>">

                        <%= drawList(iCommand, frmJangkaWaktuMarkup, jangkaWaktuMarkup, listJangkaWaktu, oidJangkaWaktu, SESS_LANGUAGE, vectSize, start)%>

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
                        String scomDel = "javascript:cmdAsk('" + oidJangkaWaktu + "')";
                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidJangkaWaktu + "')";
                        String scancel = "javascript:cmdEdit('" + oidJangkaWaktu + "')";
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
        </section>
    </body>
    <%
        if (iCommand == Command.ADD || iCommand == Command.EDIT) {
    %>
    <script language="javascript">
        document.frmJangkaWaktu.<%=FrmJangkaWaktuMarkup.fieldNames[FrmJangkaWaktuMarkup.FRM_FIELD_MARKUP_PCT]%>.focus();
    </script>
    <%
        }
    %>
</html>

