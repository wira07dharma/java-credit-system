<%-- 
    Document   : krediteditor
    Created on : Mar 4, 2013, 3:48:16 PM
    Author     : dw1p4
--%>

<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.sedana.entity.assignsumberdana.PstAssignSumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.SumberDana"%>
<%@page import="com.dimata.sedana.entity.assignsumberdana.AssignSumberDana"%>
<%@page import="com.dimata.sedana.form.assignsumberdana.CtrlAssignSumberDana"%>
<%@page import="com.dimata.sedana.form.assignsumberdana.FrmAssignSumberDana"%>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@ page language="java" %>

<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%//Edit by Hadi untuk proses form koperasi
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
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

<!-- JSP Block -->
<%!
    public static String strTitle[][] = {
        {"No", "Sumber Dana", "Max Persentase Penggunaan"},
        {"No", "Fund Sources", "Max Usage Percentage",},};

    public static final String systemTitle[] = {
        "Assign Sumber Dana", "Assign Fund Sources"
    };
    public static final String userTitle[][] = {
        {"Data", "Data"}, {"Data", "Data"}
    };
%>

<%
    /* VARIABLE DECLARATION */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);

    String currPageTitle = userTitle[SESS_LANGUAGE][0];
    String strAddKredit = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveKredit = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskKredit = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteKredit = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackKredit = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";
    String saveConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Data Member Success" : "Simpan Data Sukses");

    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    long kreditOID = FRMQueryString.requestLong(request, FrmAssignSumberDana.fieldNames[FrmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID]);
    long getKreditOid = FRMQueryString.requestLong(request, "kredit_oid");
    int start = FRMQueryString.requestInt(request, "start");

    CtrlAssignSumberDana ctrlAssignSumberDana = new CtrlAssignSumberDana(request);
    FrmAssignSumberDana frmAssignSumberDana = ctrlAssignSumberDana.getForm();
    String strMasage = "";

    int excCode = ctrlAssignSumberDana.action(iCommand, kreditOID);
    AssignSumberDana assignSumberDana = ctrlAssignSumberDana.getAssignSumberDana();
    strMasage = ctrlAssignSumberDana.getMessage();
    SumberDana sumberDana = new SumberDana();
    if (assignSumberDana.getSumberDanaId() != 0) {
        try {
            sumberDana = PstSumberDana.fetchExc(assignSumberDana.getSumberDanaId());
        } catch (Exception ex) {

        }
    }
    if (iCommand == Command.SAVE) {
        sumberDana = new SumberDana();
        //strMasage = saveConfirm;
    }
// proses untuk data custom
//if(iCommand == Command.DELETE)
//	response.sendRedirect("kredit.jsp"); 

    if (((iCommand == Command.SAVE) || (iCommand == Command.DELETE)) && (frmAssignSumberDana.errorSize() < 1)) {
%>
<jsp:forward page="assignsumberdana.jsp"> 
    <jsp:param name="start" value="<%=start%>" />
    <jsp:param name="kredit_oid" value="<%= getKreditOid%>" />
</jsp:forward>
<%
    }
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
    <head>
        <!-- #BeginEditable "doctitle" --> 
        <title>Accounting Information System Online</title>
        <script language="JavaScript">
            function cmdCancel() {
                //document.frmKredit.kredit_oid.value=oid;
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.command.value = "<%=Command.EDIT%>";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.action = "assignsumberdana.jsp";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.submit();
            }

            <% if (privAdd || privUpdate) {%>
            function cmdSave() {
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.command.value = "<%=Command.SAVE%>";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.action = "assignsumberdanaeditor.jsp";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.submit();
            }
            <%}%>

            <% if (privDelete) {%>
            function cmdAsk(oid) {
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.<%= frmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID]%>.value = oid;
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.command.value = "<%=Command.ASK%>";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.action = "assignsumberdanaeditor.jsp";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.submit();
            }

            function cmdDelete(oid) {
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.<%= frmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID]%>.value = oid;
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.command.value = "<%=Command.DELETE%>";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.action = "assignsumberdanaeditor.jsp";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.submit();
            }
            <%}%>


            function cmdBack(oid) {
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.<%= frmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID]%>.value = oid;
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.command.value = "<%=Command.BACK%>";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.action = "assignsumberdana.jsp";
                document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.submit();
            }

            function updatAnggota(frmID) {
                var oidAnggota = document.<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>.<%= frmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>.value;
                window.open("<%=approot%>/masterdata/mastertabungan/select_sumberdana.jsp?formName=<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>&frmFieldIdAnggotaName=<%= frmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>&<%= frmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>=" + oidAnggota + "&frmFieldIdAnggotaName=" + oidAnggota,
                        null, "height=430, width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }

        </script>
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" --> 
        <SCRIPT language=JavaScript>
            function hideObjectForMenuJournal() {
            }

            function hideObjectForMenuReport() {
            }

            function hideObjectForMenuPeriod() {
            }

            function hideObjectForMenuMasterData() {
            }

            function hideObjectForMenuSystem() {
            }

            function showObjectForMenu() {
            }
        </SCRIPT>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="../../dtree/dtree.js"></script>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>AdminLTE 2 | General Form Elements</title>
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
        <!-- Ionicons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
        <!-- Datetime Picker -->
        <link href="../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <!-- Select2 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins
             folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">

    </head> 

    <body style="background-color: #eaf3df;">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                Sumber Dana
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Kredit</li>
                <li class="active">Sumber Dana</li>
            </ol>
        </section>
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <!-- Horizontal Form -->
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <h3 class="box-title">Form Input</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form class="form-horizontal" name="<%= frmAssignSumberDana.FRM_NAME_ASSIGNSUMBERDANA%>" method="get" action="">
                            <input type="hidden" name="command" value="">
                            <input type="hidden" name="<%= frmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID]%>" value="<%=kreditOID%>">
                            <input type="hidden" name="start" value="<%=start%>">
                            <input type="hidden" name="kredit_oid" value="<%= getKreditOid%>">
                            <input type="hidden" name="<%= FrmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_TYPE_KREDIT_ID]%>" value="<%= getKreditOid%>">
                            <div class="box-body">


                                <div class="form-group">
                                    <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][1]%></label>                                    
                                    <div class="col-sm-8">
                                        <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][1]%>" name="contact" onclick="javascript:updatAnggota()" value="<%= sumberDana.getJudulSumberDana()%>">
                                        <input type="hidden" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][1]%>" name="<%=frmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>" value="<%=assignSumberDana.getSumberDanaId()%>">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][2]%></label>                                    
                                    <div class="col-sm-2">
                                        <div class="input-group">
                                            <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][2]%>" name="<%=frmAssignSumberDana.fieldNames[frmAssignSumberDana.FRM_FIELD_MAX_PRESENTASE_PENGGUNAAN]%>" value="<%=assignSumberDana.getMaxPresentasePenggunaan()%>">
                                            <span class="input-group-addon">%</span>
                                        </div>
                                    </div>
                                </div>


                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <div class="form-group">
                                    <div class="col-sm-11">
                                        <div class="pull-right">
                                            <a class="btn btn-sm btn-success" href="javascript:cmdSave()"><%=strSaveKredit%></a>
                                            <a class="btn btn-sm btn-default" href="javascript:cmdBack()"><%=strBackKredit%></a>
                                            <% if (kreditOID > 0) {%>
                                            <a class="btn btn-sm btn-danger" href="javascript:cmdDelete('<%=kreditOID%>')"><%=strAskKredit%></a>
                                            <% } %>
                                        </div>   
                                    </div>
                                </div>
                            </div>
                            <!-- /.box-footer -->
                        </form>
                    </div>
                </div>
                <!--/.col (right) -->
            </div>
            <!-- /.row -->
        </section>

        <!-- jQuery 2.2.3 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <!-- Bootstrap 3.3.6 -->
        <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>
        <!-- AdminLTE App -->
        <script src="../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>
        <!-- AdminLTE for demo purposes -->
        <script src="../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
        <!-- Select2 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
        <!-- Datetime Picker -->
        <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <!-- Declaration -->
        <script>
            jQuery(function () {
                $('.select2').select2();
                $('.datetime-picker').datetimepicker({
                    weekStart: 1,
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2 // No time
                            // showMeridian: 0
                });
            });
        </script>
        <%--
        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
            <tr> 
                <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
                        <tr> 
                            <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
                                <b><%=systemTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=kreditOID != 0 ? userTitle[SESS_LANGUAGE][1].toUpperCase() : userTitle[SESS_LANGUAGE][0].toUpperCase()%></font></b><!-- #EndEditable --></td>
                        </tr>
                        <tr> 
                            <td valign="top"><!-- #BeginEditable "content" --> 
                                <form name="frmKredit" method="get" action="">
                                    <input type="hidden" name="command" value="">
                                    <input type="hidden" name="kredit_oid" value="<%=kreditOID%>">
                                    <input type="hidden" name="start" value="<%=start%>">		  			  			  
                                    <table width="100%" border="0" cellspacing="2" cellpadding="2" class="listgenactivity">
                                        <%if ((excCode > -1) || ((iCommand == Command.SAVE) && (frmJenisKredit.errorSize() > 0)) || (iCommand == Command.ADD) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) {%>
                                        <tr> 
                                            <td colspan="3" class="txtheading1"></td>
                                        </tr>
                                        <tr> 
                                            <td width="15%" height="35">&nbsp;</td>
                                            <td width="1%" >&nbsp;</td>
                                            <td colspan="3" class="comment">
                                                <div align="left">*) entry required</div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <!-- Nama Type Kredit-->
                                            <td width="15%" height="35"><%=strTitle[SESS_LANGUAGE][0]%></td>
                                            <td width="1%" >:</td>
                                            <td width="35%" >&nbsp; 
                                                <input type="text" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_NAME_KREDIT]%>" value="<%=kredit.getNamaKredit()%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_NAME_KREDIT)%>
                                            </td>
                                            <!--Denda -->
                                            <td width="15%"><%=strTitle[SESS_LANGUAGE][7]%></td>
                                            <td width="1%">:</td>
                                            <td width="35%">&nbsp;
                                                <input type="text" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_DENDA]%>" value="<%=Formater.formatNumber(kredit.getDenda(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_DENDA)%></td>

                                        </tr>
                                        <tr>
                                            <!-- Min Kredit -->
                                            <td width="15%" height="35"><%=strTitle[SESS_LANGUAGE][1]%></td>
                                            <td width="1%" >:</td>
                                            <td width="35%" >&nbsp; 
                                                <input type="text" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_MIN_KREDIT]%>" value="<%=Formater.formatNumber(kredit.getMinKredit(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_MIN_KREDIT)%>
                                            </td>
                                            <!-- Min Periode -->
                                            <td width="15%"><%=strTitle[SESS_LANGUAGE][8]%></td>
                                            <td width="1%">:</td>
                                            <td width="35%">&nbsp;
                                                <%=ControlDate.drawDate(frmJenisKredit.fieldNames[frmJenisKredit.FRM_JANGKA_WAKTU_MIN], kredit.getJangkaWaktuMin(), "formElemen", 10, -20)%> 
                                                * &nbsp;<%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_JANGKA_WAKTU_MIN)%>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td width="15%" height="35"><%=strTitle[SESS_LANGUAGE][2]%></td>
                                            <td width="1%" >:</td>
                                            <td width="35%" >&nbsp; 
                                                <input type="text" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_MAX_KREDIT]%>" value="<%=Formater.formatNumber(kredit.getMaxKredit(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_MAX_KREDIT)%>
                                            </td>
                                            <td width="15%"><%=strTitle[SESS_LANGUAGE][9]%></td>
                                            <td width="1%">:</td>
                                            <td width="35%">&nbsp;
                                                <%=ControlDate.drawDate(frmJenisKredit.fieldNames[frmJenisKredit.FRM_JANGKA_WAKTU_MAX], kredit.getJangkaWaktuMax(), "formElemen", 10, -20)%> 
                                                *&nbsp; <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_JANGKA_WAKTU_MAX)%>
                                            </td> 
                                        </tr>
                                        <tr> 
                                            <td width="15%" height="35"><%=strTitle[SESS_LANGUAGE][3]%></td>
                                            <td width="1%">:</td>
                                            <td width="35%">&nbsp; 
                                                <input type="text" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_BUNGA_MIN]%>" value="<%=Formater.formatNumber(kredit.getBungaMin(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_BUNGA_MIN)%>


                                            <td width="15%">&nbsp;</td>
                                            <td width="1%" >&nbsp;</td>
                                            <td width="35%" rowspan="3" >&nbsp;
                                                <textarea name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_KEGUNAAN]%>" cols="46" rows="5" class="formElemen"><%=kredit.getKegunaan()%></textarea>
                                                * &nbsp;<%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_KEGUNAAN)%> 
                                            </td>

                                        </tr>
                                        <tr> 

                                            <td width="15%" height="35"><%=strTitle[SESS_LANGUAGE][4]%></td>
                                            <td width="1%">:</td>
                                            <td width="35%">&nbsp; 
                                                <input type="text" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_BUNGA_MAX]%>" value="<%=Formater.formatNumber(kredit.getBungaMax(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_BUNGA_MAX)%>
                                            </td>


                                            <td width="15%"><%=strTitle[SESS_LANGUAGE][10]%></td>
                                            <td width="1%" >:</td>
                                            <td width="35%" >&nbsp;</td>

                                        </tr>
                                        <tr> 
                                            <td width="15%" height="35"><%=strTitle[SESS_LANGUAGE][5]%></td>
                                            <td width="1%">:</td>
                                            <td width="35%">&nbsp;
                                                <input type="text" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_BIAYA_ADMIN]%>" value="<%=Formater.formatNumber(kredit.getBiayaAdmin(), "#.##")%>" class="formElemen" size="50">

                                                * <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_BIAYA_ADMIN)%></td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="1%">&nbsp;</td>
                                        </tr>

                                        <tr> 
                                            <td width="15%" height="35"><%=strTitle[SESS_LANGUAGE][6]%></td>
                                            <td width="1%">:</td>
                                            <td width="35%">&nbsp;
                                                <input type="text" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_PROVISI]%>" value="<%=Formater.formatNumber(kredit.getProvisi(), "#.##")%>" class="formElemen" size="50">
                                                * <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_PROVISI)%></td>

                                            <td width="15%" height="35">&nbsp;</td>
                                            <td width="1%" height="35">&nbsp;</td>
                                        </tr>

                                        <tr> 
                                            <td width="15%" height="35"></td>
                                            <td width="1%"></td>
                                            <td width="35%"></td>

                                            <td width="15%"></td>
                                            <td width="1%"></td>
                                            <td width="35%"></td>

                                        </tr>

                                        <%if (iCommand == Command.ASK) {%>
                                        <tr> 
                                            <td colspan="6" class="msgerror"><%=delConfirm%></td>
                                        </tr>
                                        <%}%>
                                        <%if (strMasage.length() > 0) {
                                                if (excCode > 0) {
                                        %>
                                        <tr> 
                                            <td colspan="6" class="msgerror"><%=strMasage%></td>
                                        </tr>
                                        <%} else {%>	
                                        <tr> 
                                            <td colspan="6" class="msginfo"><%=strMasage%></td>
                                        </tr>
                                        <%}
                                            }%>			
                                        <tr> 
                                            <td width="15%" class="command">&nbsp;</td>
                                            <td width="1%" class="command">&nbsp;</td>
                                            <td width="35%" class="command"> 
                                                <%if (iCommand != Command.ASK) {%>     
                                                <%if (iCommand != Command.ADD) {%>
                                                <%}%>               
                                                <% if (privAdd || privUpdate) {%>
                                                &nbsp;<a href="javascript:cmdSave()"><%=strSaveKredit%></a> | 


                                                <%}%>
                                                <a href="javascript:cmdBack()"><%=strBackKredit%></a> 
                                                <%if (privDelete && (iCommand != Command.ADD) && (!((iCommand == Command.SAVE) && (kreditOID < 1)))) {%>
                                                | <a href="javascript:cmdAsk('<%=kreditOID%>')"><%=strAskKredit%></a> 
                                                <%}%>
                                                <%} else {%>
                                                <% if (privDelete) {%>
                                                &nbsp;<a href="javascript:cmdDelete('<%=kreditOID%>')"><%=strDeleteKredit%></a> | <a href="javascript:cmdCancel()"><%=strCancel%></a> 
                                                <%
                                                    }// end of privDelete

                                                %>
                                                <%}%>
                                            </td>
                                            <td width="15%" class="command">&nbsp;</td>
                                            <td width="1%" class="command">&nbsp;</td>
                                            <td width="35%" class="command">&nbsp;</td>
                                        </tr>
                                        <%} else {%>
                                        <%if (SESS_LANGUAGE == langDefault) {%>
                                        <tr> 
                                            <td colspan="6">&nbsp; Prosess OK .. kembali ke daftar, <a href="javascript:cmdBack()">klik di sini</a></td>
                                        <script language="JavaScript">
                                            cmdBack();
                                        </script>
                                        </tr>
                                        <%} else {%>
                                        <tr> 
                                            <td colspan="6">&nbsp; Processing OK .. back to list, <a href="javascript:cmdBack()">click here</a></td>
                                        <script language="JavaScript">
                                            cmdBack();
                                        </script>				  
                                        </tr>
                                        <%}%>								
                                        <%}%>

                                    </table>
                                </form>
                                <!-- #EndEditable --></td>
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
            <tr> 
                <td colspan="2" height="20" class="footer"> 
                    <%@ include file = "../../main/footer.jsp" %>
                </td>
            </tr>
        </table>
        --%>
    </body>
    <!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>