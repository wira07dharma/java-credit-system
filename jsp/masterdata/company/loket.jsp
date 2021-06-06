
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.qdep.db.DBException"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlMasterLoket"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmMasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterLoket"%>
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
                {"Loket"},
                {"Locket"}
            };

    public static final String textListHeader[][]
            = {
                {"No", "Nomor Loket", "Nama Loket", "Jenis Loket", "Lokasi"},
                {"No", "Locket Number", "Locket Name", "Locket Type", "Location"}
            };

    public String drawList(int iCommand, FrmMasterLoket frmObject, MasterLoket objEntity, Vector objectClass, long jenisSimpananId, int languange, int vectorNumber, int start) {
        
        String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");
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
        ctrlist.addHeader(textListHeader[languange][4], "");
        ctrlist.addHeader("Action", "1%");

        Vector<Location> ls = new Vector<Location>();
        try {
            ls = PstLocation.list(0, 0, "", PstLocation.fieldNames[PstLocation.FLD_NAME]);
        } catch (Exception e) {

        }

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
            MasterLoket ml = (MasterLoket) objectClass.get(i);
            rowx = new Vector();
            if (jenisSimpananId == ml.getOID()) {
                index = i;
            }

            if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {
                String select = "<select name='" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_LOCATOIN_ID] + "' class=''>";
                for (Location l : ls) {
                    select += "<option " + (ml.getLocationId() == l.getOID() ? "selected" : "") + " value='" + l.getOID() + "'>" + l.getName() + "</option>";
                }
                select += "</select>";
                
                String selectLoketType = "<select name='" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_LOKET_TYPE] + "' class=''>";

                if(useForRaditya.equals("0")){
                    for (int a = 0; a < PstMasterLoket.loketTypeTitle.length; a++) {
                        selectLoketType += "<option " + (ml.getLoketType() == a ? "selected":"") + " value='" +a+ "'>" + PstMasterLoket.loketTypeTitle[a] + "</option>";
                    }
                }else{
                    for (int a = 0; a < PstMasterLoket.loketRadityaTypeTitle.length; a++) {
                        selectLoketType += "<option " + (ml.getLoketType() == a ? "selected":"") + " value='" +a+ "'>" + PstMasterLoket.loketRadityaTypeTitle[a] + "</option>";
                    }

                }
                selectLoketType += "</select>";

                rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_MASTER_LOKET_ID] + "\" value=\"" + ml.getOID() + "\" class=\"\">" + indexNumber + ".");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_LOKET_NUMBER] + "\" value=\"" + ml.getLoketNumber() + "\" class=\"\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_LOKET_NAME] + "\" value=\"" + ml.getLoketName()+ "\" class=\"\">");
                rowx.add(selectLoketType);
                rowx.add(select);
                rowx.add("-");

            } else {
                Location location = new Location();
                try {
                    location = PstLocation.fetchExc(ml.getLocationId());
                } catch (Exception e) {

                }
                rowx.add("" + indexNumber + ".");
                rowx.add(String.valueOf(ml.getLoketNumber()));
                rowx.add(""+ml.getLoketName());
                if(useForRaditya.equals("0")){
                    rowx.add(""+PstMasterLoket.loketTypeTitle[ml.getLoketType()]);
                }else{
                    rowx.add(""+PstMasterLoket.loketRadityaTypeTitle[ml.getLoketType()]);
                }
                rowx.add(location.getName());
                rowx.add(String.valueOf("<center><a class=\"btn btn-warning btn-xs\" href=\"javascript:cmdEdit('" + ml.getOID() + "')\">Edit</a></center>"));
                
            }
            lstData.add(rowx);

        }

        rowx = new Vector();

        if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)) {
            String select = "<select name='" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_LOCATOIN_ID] + "' class=''>";
            for (Location l : ls) {
                select += "<option " + (objEntity.getLocationId() == l.getOID() ? "selected" : "") + " value='" + l.getOID() + "'>" + l.getName() + "</option>";
            }
            select += "</select>";
            
            String selectLoketType = "<select name='" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_LOKET_TYPE] + "' class=''>";
            if(useForRaditya.equals("0")){
                for (int a = 0; a < PstMasterLoket.loketTypeTitle.length; a++) {
                    selectLoketType += "<option " + (objEntity.getLoketType() == a ? "selected":"") + " value='" +a+ "'>" + PstMasterLoket.loketTypeTitle[a] + "</option>";
                }
            }else{
                for (int a = 0; a < PstMasterLoket.loketRadityaTypeTitle.length; a++) {
                    selectLoketType += "<option " + (objEntity.getLoketType() == a ? "selected":"") + " value='" +a+ "'>" + PstMasterLoket.loketRadityaTypeTitle[a] + "</option>";
                }
            
            }
            selectLoketType += "</select>";
                
            rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_MASTER_LOKET_ID] + "\" value=\"" + objEntity.getOID() + "\" class=\"\">" + indexNumber + "");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_LOKET_NUMBER] + "\" value=\"" + objEntity.getLoketNumber() + "\" class=\"\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterLoket.FRM_FIELD_LOKET_NAME] + "\" value=\"" + objEntity.getLoketName()+ "\" class=\"\">");
            rowx.add(selectLoketType);
            rowx.add(select);
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
    long oidMasterLoket = FRMQueryString.requestLong(request, "hidden_loket_id");
    String keyword = request.getParameter("keyword");
    // variable declaration
    boolean privManageData = true;
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    if (keyword == null) {
        keyword = "";
    }
    String whereClause = "" + PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOKET_NUMBER] + " LIKE '%" + keyword + "%'";;
    String orderClause = "" + PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOKET_NUMBER];

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

    CtrlMasterLoket ctrlMasterLoket = new CtrlMasterLoket(request);
    iErrCode = ctrlMasterLoket.action(iCommand, oidMasterLoket);
    FrmMasterLoket frmMasterLoket = ctrlMasterLoket.getForm();
    MasterLoket masterLoket = ctrlMasterLoket.getMasterLoket();
    msgString = ctrlMasterLoket.getMessage();

    Vector listLoket = new Vector(1, 1);
    int vectSize = PstMasterLoket.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlMasterLoket.actionList(iCommand, start, vectSize, recordToGet);
    }

    listLoket = PstMasterLoket.list(start, recordToGet, whereClause, orderClause);

    if (listLoket.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listLoket = PstMasterLoket.list(start, recordToGet, whereClause, orderClause);
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
                document.frmJenisSimpanan.hidden_loket_id.value = "0";
                document.frmJenisSimpanan.command.value = "<%=Command.ADD%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdAsk(oidJenisSimpanan) {
                document.frmJenisSimpanan.hidden_loket_id.value = oidJenisSimpanan;
                document.frmJenisSimpanan.command.value = "<%=Command.ASK%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdConfirmDelete(oidJenisSimpanan) {
                document.frmJenisSimpanan.hidden_loket_id.value = oidJenisSimpanan;
                document.frmJenisSimpanan.command.value = "<%=Command.DELETE%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdSave() {
                document.frmJenisSimpanan.command.value = "<%=Command.SAVE%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdEdit(oidJenisSimpanan) {
                document.frmJenisSimpanan.hidden_loket_id.value = oidJenisSimpanan;
                document.frmJenisSimpanan.command.value = "<%=Command.EDIT%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdCancel(oidJenisSimpanan) {
                document.frmJenisSimpanan.hidden_loket_id.value = oidJenisSimpanan;
                document.frmJenisSimpanan.command.value = "<%=Command.EDIT%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdBack() {
                document.frmJenisSimpanan.command.value = "<%=Command.BACK%>";
                document.frmJenisSimpanan.submit();
            }

            function cmdListFirst() {
                document.frmJenisSimpanan.command.value = "<%=Command.FIRST%>";
                document.frmJenisSimpanan.prev_command.value = "<%=Command.FIRST%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdListPrev() {
                document.frmJenisSimpanan.command.value = "<%=Command.PREV%>";
                document.frmJenisSimpanan.prev_command.value = "<%=Command.PREV%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdListNext() {
                document.frmJenisSimpanan.command.value = "<%=Command.NEXT%>";
                document.frmJenisSimpanan.prev_command.value = "<%=Command.NEXT%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdListLast() {
                document.frmJenisSimpanan.command.value = "<%=Command.LAST%>";
                document.frmJenisSimpanan.prev_command.value = "<%=Command.LAST%>";
                document.frmJenisSimpanan.action = "loket.jsp";
                document.frmJenisSimpanan.submit();
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
            <h1>Loket <small></small></h1>
            <ol class="breadcrumb">
                <li><i class="fa fa-dashboard"></i> Home</li>
                <li>Master Bumdesa</li>
                <li>Master</li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Loket</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="loket.jsp" class="form-inline">
                        <input type="text" name="keyword" id="keyword" class="form-control input-sm">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>

                    <form name="frmJenisSimpanan" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_loket_id" value="<%=oidMasterLoket%>">

                        <%= drawList(iCommand, frmMasterLoket, masterLoket, listLoket, oidMasterLoket, SESS_LANGUAGE, vectSize, start)%>

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
                        String scomDel = "javascript:cmdAsk('" + oidMasterLoket + "')";
                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidMasterLoket + "')";
                        String scancel = "javascript:cmdEdit('" + oidMasterLoket + "')";
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
                        arr.put(SessHistory.document[SessHistory.DOC_MASTER_LOKET]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% } %>
            
            <a href="loket.jsp?show_history=<%= (showHistory == 0) ? "1":"0" %>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan":"Sembunyikan Riwayat Perubahan" %></a>
            
        </section>
    </body>
    <%
        if (iCommand == Command.ADD || iCommand == Command.EDIT) {
    %>
    <script language="javascript">
        document.frmJenisSimpanan.<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_NAMA_SIMPANAN]%>.focus();
    </script>
    <%
        }
    %>
</html>

