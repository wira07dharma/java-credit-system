<%-- 
    Document   : krediteditor
    Created on : Mar 4, 2013, 3:48:16 PM
    Author     : dw1p4
--%>

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

<%
//Edit by Hadi untuk proses form koperasi
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privView = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
    if (!privView && !privAdd && !privUpdate && !privDelete) {
%>
<script language="javascript">
    window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
} else {
%>

<!-- JSP Block -->
<%!    public static String strTitle[][] = {
        {"Nomor", "Jenis Deposito", "Min Deposito", "Max Deposits", "Bunga", "Jangka Waktu", "Provisi", "Biaya Admin", "Kegunaan"},
        {"Number", "Deposits Type", "Deposits Min", "Deposits Max", "Interest", "Jangka Waktu", "Provisi", "Admin Cost", "Usefulness"}
    };
    public static final String systemTitle[] = {
        "Deposito", "Deposits"
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
    String strAddDeposito = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveDeposito = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskDeposito = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteDeposito = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackDeposito = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";
    String saveConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Data Member Success" : "Simpan Data Sukses");

    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    long jenisDepositoOID = FRMQueryString.requestLong(request, FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]);
    int start = FRMQueryString.requestInt(request, "start");

    CtrlJenisDeposito ctrlJenisDeposito = new CtrlJenisDeposito(request);
    FrmJenisDeposito frmJenisDeposito = ctrlJenisDeposito.getForm();
    String strMasage = "";

    int excCode = ctrlJenisDeposito.action(iCommand, jenisDepositoOID);
    JenisDeposito jenisDeposito = ctrlJenisDeposito.getJenisDeposito();
    strMasage = ctrlJenisDeposito.getMessage();

    if (iCommand == Command.SAVE) {
        jenisDeposito = new JenisDeposito();
        //strMasage = saveConfirm;
    }

    if (((iCommand == Command.SAVE) || (iCommand == Command.DELETE)) && (frmJenisDeposito.errorSize() < 1)) {
%>
<jsp:forward page="jenis_deposito.jsp"> 
    <jsp:param name="start" value="<%=start%>" />
    <jsp:param name="JENIS_DEPOSITO" value="<%=jenisDeposito.getOID()%>" />
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
            function cmdCancel(){
                document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.EDIT%>";
                document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito.jsp";
                document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
            }

            <% if (privAdd || privUpdate) {%>
                function cmdSave(){
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.SAVE%>";
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito_edit.jsp";
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
                }
            <%}%>

            <% if (privDelete) {%>
                function cmdAsk(oid){
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>.value=oid;
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.ASK%>";
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito_edit.jsp";
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
                }

                function cmdDelete(oid){
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>.value=oid;
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.DELETE%>";
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito_edit.jsp";
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
                }
            <%}%>


                function cmdBack(oid){
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>.value=oid;
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.BACK%>";
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito.jsp";
                    document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
                }

        </script>
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" --> 
        <SCRIPT language=JavaScript>
            function hideObjectForMenuJournal(){
            }
	
            function hideObjectForMenuReport(){	 
            }
	
            function hideObjectForMenuPeriod(){
            }
	 
            function hideObjectForMenuMasterData(){
            }

            function hideObjectForMenuSystem(){
            }

            function showObjectForMenu(){ 	
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

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
    </head> 

    <body style="background-color: #eaf3df;">    
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                Jenis Deposito
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Tabungan</li>
                <li class="active">Jenis Deposito</li>
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
                        <form class="form-horizontal" name="<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>" method="get" action="">
                            <input type="hidden" name="command" value="">
                            <input type="hidden" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>" value="<%=jenisDepositoOID%>">
                            <input type="hidden" name="start" value="<%=start%>">
                            <div class="box-body">

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][1]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][1]%>" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_NAMA_JENIS_DEPOSITO]%>" value="<%=jenisDeposito.getNamaJenisDeposito()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][2]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][2]%>" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_MIN_DEPOSITO]%>" value="<%=jenisDeposito.getMinDeposito()==0?"":FRMHandler.userFormatStringDecimal(jenisDeposito.getMinDeposito())%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][3]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][3]%>" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_MAX_DEPOSITO]%>" value="<%=jenisDeposito.getMaxDeposito()==0?"":FRMHandler.userFormatStringDecimal(jenisDeposito.getMaxDeposito())%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][4]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][4]%>" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_BUNGA]%>" value="<%=jenisDeposito.getBunga()==0?"":Formater.formatNumber(jenisDeposito.getBunga(), "#.##")%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][5]%></label>                                    
                                        <div class="col-sm-9">
                                            <%
                                            String jangkaWaktu="";
                                            if(jenisDeposito.getJangkaWaktu()==0){
                                                
                                            }else{
                                                jangkaWaktu = Formater.formatNumber(jenisDeposito.getJangkaWaktu(), "#.##");
                                            }
                                            %>
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][5]%>" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_JANGKA_WAKTU]%>" value="<%=jangkaWaktu%>">
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][6]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][6]%>" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_PROVISI]%>" value="<%=jenisDeposito.getProvisi()==0?"":Formater.formatNumber(jenisDeposito.getProvisi(), "#.##")%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][7]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][7]%>" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_BIAYA_ADMIN]%>" value="<%=jenisDeposito.getBiayaAdmin()==0?"":Formater.formatNumber(jenisDeposito.getBiayaAdmin(), "#.##")%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][8]%></label>                                    
                                        <div class="col-sm-9">
                                            <textarea rows="5" class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][8]%>" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_KETERANGAN]%>"><%=jenisDeposito.getKeterangan()%></textarea>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <div class="pull-right">
                                    <a class="btn btn-success" href="javascript:cmdSave()"><%=strSaveDeposito%></a>
                                    <a class="btn btn-success" href="javascript:cmdBack()"><%=strBackDeposito%></a>
                                    <% if (jenisDepositoOID > 0) { %>
                                        <a class="btn btn-danger" href="javascript:cmdDelete('<%=jenisDepositoOID%>')"><%=strAskDeposito%></a>
                                    <% } %>
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

        <%--
        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
            <tr> 
                <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">

                        <tr> 
                            <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
                                <b><%=systemTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=jenisDepositoOID != 0 ? userTitle[SESS_LANGUAGE][1].toUpperCase() : userTitle[SESS_LANGUAGE][0].toUpperCase()%></font></b><!-- #EndEditable --></td>
                        </tr>

                        <tr> 
                            <td valign="top"><!-- #BeginEditable "content" --> 
                                <form name="<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>" method="get" action="">
                                    <input type="hidden" name="command" value="">
                                    <input type="hidden" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>" value="<%=jenisDepositoOID%>">
                                    <input type="hidden" name="start" value="<%=start%>">		  			  			  
                                    <table width="100%" border="0" cellspacing="2" cellpadding="2" class="listgenactivity">
                                        <%if ((excCode > -1) || ((iCommand == Command.SAVE) && (frmJenisDeposito.errorSize() > 0)) || (iCommand == Command.ADD) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) {%>
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
                                            <!-- Nama Jenis Deposito-->
                                            <td width="15%" height="35"><%=strTitle[SESS_LANGUAGE][1]%></td>
                                            <td width="1%" >:</td>
                                            <td width="35%" >&nbsp; 
                                                <input type="text" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_NAMA_JENIS_DEPOSITO]%>" value="<%=jenisDeposito.getNamaJenisDeposito()%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisDeposito.getErrorMsg(frmJenisDeposito.FRM_NAMA_JENIS_DEPOSITO)%>
                                            </td>
                                            <!-- Provisi -->
                                            <td width="15%"><%=strTitle[SESS_LANGUAGE][6]%></td>
                                            <td width="1%">:</td>
                                            <td width="35%">&nbsp;
                                                <input type="text" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_PROVISI]%>" value="<%=Formater.formatNumber(jenisDeposito.getProvisi(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisDeposito.getErrorMsg(frmJenisDeposito.FRM_PROVISI)%></td>

                                        </tr>
                                        <tr>
                                            <!-- Min Deposito -->
                                            <td height="35"><%=strTitle[SESS_LANGUAGE][2]%></td>
                                            <td>:</td>
                                            <td>&nbsp; 
                                                <input type="text" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_MIN_DEPOSITO]%>" value="<%=Formater.formatNumber(jenisDeposito.getMinDeposito(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisDeposito.getErrorMsg(frmJenisDeposito.FRM_MIN_DEPOSITO)%>
                                            </td>
                                            <!-- biaya admin -->
                                            <td><%=strTitle[SESS_LANGUAGE][7]%></td>
                                            <td>:</td>
                                            <td>&nbsp;
                                                <input type="text" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_BIAYA_ADMIN]%>" value="<%=Formater.formatNumber(jenisDeposito.getBiayaAdmin(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisDeposito.getErrorMsg(frmJenisDeposito.FRM_BIAYA_ADMIN)%>
                                            </td>

                                        </tr>
                                        <tr>
                                            <!-- Max Deposito-->
                                            <td height="35"><%=strTitle[SESS_LANGUAGE][3]%></td>
                                            <td>:</td>
                                            <td>&nbsp; 
                                                <input type="text" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_MAX_DEPOSITO]%>" value="<%=Formater.formatNumber(jenisDeposito.getMaxDeposito(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisDeposito.getErrorMsg(frmJenisDeposito.FRM_MAX_DEPOSITO)%>
                                            </td>
                                            <!--Ket -->
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td rowspan="3" >
                                                <textarea name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_KETERANGAN]%>" cols="46" rows="5" class="formElemen"><%=jenisDeposito.getKeterangan()%></textarea>
                                                * &nbsp;<%= frmJenisDeposito.getErrorMsg(frmJenisDeposito.FRM_KETERANGAN)%> 
                                            </td> 
                                        </tr>
                                        <tr> 
                                            <!-- Bunga-->
                                            <td height="35"><%=strTitle[SESS_LANGUAGE][4]%></td>
                                            <td>:</td>
                                            <td>&nbsp; 
                                                <input type="text" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_BUNGA]%>" value="<%=Formater.formatNumber(jenisDeposito.getBunga(), "#.##")%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisDeposito.getErrorMsg(frmJenisDeposito.FRM_BUNGA)%>
                                            </td>

                                            <!--Ket -->
                                            <td><%=strTitle[SESS_LANGUAGE][8]%></td>  
                                            <td>:</td>

                                        </tr>
                                        <tr> 
                                            <!--jangka Waktu--->
                                            <td height="35"><%=strTitle[SESS_LANGUAGE][5]%></td>
                                            <td>:</td>
                                            <td>&nbsp; 
                                                <input type="text" name="<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_JANGKA_WAKTU]%>" value="<%=jenisDeposito.getJangkaWaktu()%>" class="formElemen" size="50">
                                                * &nbsp;<%= frmJenisDeposito.getErrorMsg(frmJenisDeposito.FRM_JANGKA_WAKTU)%>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>

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
                                                &nbsp;<a href="javascript:cmdSave()"><%=strSaveDeposito%></a> | 


                                                <%}%>
                                                <a href="javascript:cmdBack()"><%=strBackDeposito%></a> 
                                                <%if (privDelete && (iCommand != Command.ADD) && (!((iCommand == Command.SAVE) && (jenisDepositoOID < 1)))) {%>
                                                | <a href="javascript:cmdAsk('<%=jenisDepositoOID%>')"><%=strAskDeposito%></a> 
                                                <%}%>
                                                <%} else {%>
                                                <% if (privDelete) {%>
                                                &nbsp;<a href="javascript:cmdDelete('<%=jenisDepositoOID%>')"><%=strDeleteDeposito%></a> | <a href="javascript:cmdCancel()"><%=strCancel%></a> 
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