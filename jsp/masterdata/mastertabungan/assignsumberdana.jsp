<%-- 
    Document   : assignsumberdana
    Created on : Jun 19, 2017, 7:32:54 PM
    Author     : QA
--%>

<%@page import="com.dimata.sedana.form.assignsumberdana.FrmAssignSumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.SumberDana"%>
<%@page import="com.dimata.sedana.form.assignsumberdana.CtrlAssignSumberDana"%>
<%@page import="com.dimata.sedana.entity.assignsumberdana.PstAssignSumberDana"%>
<%@page import="com.dimata.sedana.entity.assignsumberdana.AssignSumberDana"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package region -->
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*" %>

<%@include file="../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE); %>
<%@ include file = "../../main/checkuser.jsp" %>

<!DOCTYPE html>
<%
    boolean privView = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

    //if of "hasn't access" condition 
    if (!privView && !privAdd && !privUpdate && !privDelete) {
%>
<script language="javascript">
    window.location = "<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
} else {
%>
<%!
    public static String strTitle[][] = {
        {"No", "Sumber Dana", "Max Presentase Pengguanaan"},
        {"No", "Fund Sources", "Max Usage Percentage",},};

    public static final String systemTitle[] = {
        "Assign Sumber Dana", "Assign Fund Sources"
    };

    public static final String userTitle[] = {
        "Daftar", "List"
    };

    public String drawListKredit(int language, Vector objectClass, long oid, int start) {
        String temp = "";
        String regdatestr = "";

        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");

        //untuk tabel
        ctrlist.dataFormat(strTitle[language][0], "1%", "center", "left");
        ctrlist.dataFormat(strTitle[language][1], "50%", "center", "left");
        ctrlist.dataFormat(strTitle[language][2], "50%", "center", "left");
        ctrlist.dataFormat("Action", "1%", "center", "left");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;
        int indexNumber = start;

        String tgl_min = "";
        String tgl_max = "";
        for (int i = 0; i < objectClass.size(); i++) {
            indexNumber = indexNumber + 1;
            AssignSumberDana assignSumberDana = (AssignSumberDana) objectClass.get(i);
            if (oid == assignSumberDana.getOID()) {
                index = i;
            }
            
            SumberDana sumberDana = new SumberDana();
            if(assignSumberDana.getSumberDanaId() != 0){
                try{
                    sumberDana = PstSumberDana.fetchExc(assignSumberDana.getSumberDanaId());
                }catch(Exception ex){
                    
                }
            }

            Vector rowx = new Vector();
            rowx.add(String.valueOf(indexNumber + "."));
            rowx.add(String.valueOf(sumberDana.getJudulSumberDana()));

            rowx.add(String.valueOf(FRMHandler.userFormatStringDecimal(assignSumberDana.getMaxPresentasePenggunaan())));
            rowx.add(String.valueOf("<center><a class=\"btn-warning btn-sm\" href=\"javascript:cmdEdit('" + assignSumberDana.getOID() + "')\">Edit</a></center>"));

            lstData.add(rowx);
            //lstLinkData.add(String.valueOf(kredit.getOID()));
        }
        return ctrlist.drawMe(index);
    }
%>

<%
    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    long kreditOID = FRMQueryString.requestLong(request, "kredit_oid");
    int listCommand = FRMQueryString.requestInt(request, "list_command");
    if (listCommand == Command.NONE) {
        listCommand = Command.LIST;
    }

    /* VARIABLE DECLARATION */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);

    String currPageTitle = systemTitle[SESS_LANGUAGE];
    String strAddKredit = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strBackKredit = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");

    int recordToGet = 10;
    String order = " " + PstAssignSumberDana.fieldNames[PstAssignSumberDana.FLD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID];
    String where =""+PstAssignSumberDana.fieldNames[PstAssignSumberDana.FLD_TYPE_KREDIT_ID]+"='"+kreditOID+"'";
    CtrlAssignSumberDana ctrlAssignSumberDana = new CtrlAssignSumberDana(request);
    int vectSize = PstAssignSumberDana.getCount(""+where);

    if (iCommand != Command.BACK) {
        start = ctrlAssignSumberDana.actionList(iCommand, start, vectSize, recordToGet);
    } else {
        iCommand = Command.LIST;
    }
    Vector list = PstAssignSumberDana.list(start, recordToGet, ""+where, order);
%>
<html>
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <title><%= userTitle[SESS_LANGUAGE] %></title>

        <script language="JavaScript">
            <%if (privAdd) {%>
            function addNew() {
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.<%= FrmAssignSumberDana.fieldNames[FrmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID] %>.value = "0";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.list_command.value = "<%=listCommand%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.command.value = "<%=Command.ADD%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.action = "assignsumberdanaeditor.jsp";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.submit();
            }
            <%}%>

            function cmdEdit(oid) {
            <%if (privUpdate) {%>
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.<%= FrmAssignSumberDana.fieldNames[FrmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID] %>.value = oid;
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.list_command.value = "<%=listCommand%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.command.value = "<%=Command.EDIT%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.action = "assignsumberdanaeditor.jsp";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.submit();
            <%}%>
            }

            function first() {
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.command.value = "<%=Command.FIRST%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.list_command.value = "<%=Command.FIRST%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.action = "assignsumberdana.jsp";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.submit();
            }
            function prev() {
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.command.value = "<%=Command.PREV%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.list_command.value = "<%=Command.PREV%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.action = "assignsumberdana.jsp";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.submit();
            }

            function next() {
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.command.value = "<%=Command.NEXT%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.list_command.value = "<%=Command.NEXT%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.action = "assignsumberdana.jsp";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.submit();
            }
            function last() {
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.command.value = "<%=Command.LAST%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.list_command.value = "<%=Command.LAST%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.action = "assignsumberdana.jsp";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.submit();
            }
            
            function cmdBack(oid){
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.<%= FrmAssignSumberDana.fieldNames[FrmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID] %>.value=oid;
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.command.value="<%=Command.BACK%>";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.action="jenis_kredit.jsp";
                document.<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>.submit();
            }

        </script>

    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>Assign Sumber Dana<small></small></h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Kredit</li>
                <li class="active">Sumber Dana</li>
            </ol>
        </section>
        
        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border" style="border-color: lightgray">
                    <h3 class="box-title">Daftar Assign Sumber Dana</h3>
                </div>
                <div class="box-body">
                    <form name="<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>" method="get" action="">
                        <input type="hidden" name="command" value="">
                        <input type="hidden" name="kredit_oid" value="<%= kreditOID%>">
                        <input type="hidden" name="<%= FrmAssignSumberDana.fieldNames[FrmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID]%>" value="<%=kreditOID%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="list_command" value="<%=listCommand%>">

                        <% if ((list != null) && (list.size() > 0)) {%>
                        <%=drawListKredit(SESS_LANGUAGE, list, kreditOID, start)%>
                        <%}%>
                        
                        <br>
                        
                        <%
                            int cmd = 0;
                        %>
                        <%=ctrLine.drawMeListLimit(cmd, vectSize, start, recordToGet, "cmdListFirst", "cmdListPrev", "cmdListNext", "cmdListLast", "left")%>

                        <% if (privAdd) {%>
                        <a href="javascript:addNew()" class="btn-primary btn btn-sm"><i class="fa fa-plus"></i> <%=strAddKredit%></a>
                        <a href="javascript:cmdBack()" class="btn-primary btn btn-sm"><i class="fa fa-undo"></i> <%= strBackKredit%></a>
                        <%} else {%>
                        <a href="javascript:cmdBack()" class="btn-primary btn btn-sm"><i class="fa fa-undo"></i> <%= strBackKredit%></a>
                        <%}%>
                        
                    </form>
                </div>
            </div>
        </section>
        <%--
        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
            <tr>
                <td width="91%" valign="top" align="left" bgcolor="#99CCCC">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
                        <tr>
                            <td height="20" class="contenttitle" >&nbsp;
                                <!-- #BeginEditable "contenttitle" -->
                                <b><%=userTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=systemTitle[SESS_LANGUAGE].toUpperCase()%></font></b>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                        <tr>
                            <td valign="top"><!-- #BeginEditable "content" --> 
                                <table width="100%" class="listgenactivity">
                                    <tr>
                                        <td>
                                            <form name="<%= FrmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA %>" method="get" action="">
                                                <input type="hidden" name="command" value="">
                                                <input type="hidden" name="kredit_oid" value="<%= kreditOID %>">
                                                <input type="hidden" name="<%= FrmAssignSumberDana.fieldNames[FrmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID] %>" value="<%=kreditOID%>">
                                                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                <input type="hidden" name="start" value="<%=start%>">
                                                <input type="hidden" name="list_command" value="<%=listCommand%>">
                                                <table width="100%" cellspacing="0" cellpadding="0">

                                                </table>
                                                <% if ((list != null) && (list.size() > 0)) {%>
                                                <%=drawListKredit(SESS_LANGUAGE, list, kreditOID, start)%>
                                                <%}%>
                                                <table width="100%">
                                                    <tr> 
                                                        <td colspan="2"> <span class="command"> <%=ctrLine.drawMeListLimit(listCommand, vectSize, start, recordToGet, "first", "prev", "next", "last", "left")%> </span> </td>
                                                    </tr>
                                                    <% if (privAdd) {%>	
                                                        <td  colspan="2" class="command">&nbsp;<a href="javascript:addNew()" class="btn-save btn-lg"><%=strAddKredit%></a> 
                                                        &nbsp;<a href="javascript:cmdBack()" class="btn-save btn-lg"><%= strBackKredit %></a></td>
                                                    </tr>
                                                    <%}else{%>
                                                    <tr valign="middle"> 
                                                        <td colspan="2" class="command">&nbsp;<a href="javascript:cmdBack()" class="btn-save btn-lg"><%= strBackKredit %></a> </td>
                                                    </tr>
                                                    <%}%>
                                                </table>
                                            </form>
                                            <!-- #EndEditable -->
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
                                <p>&nbsp;</p>
                                <p>&nbsp;</p>
                                <p>&nbsp;</p>
                                <p>&nbsp;</p>
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
            <tr>
                <td colspan="2" height="20" class="footer"> 
                    <%@include file="../../main/footer.jsp" %>
                </td>
            </tr>
        </table>
    --%>
    </body>
</html>
<%}%>
