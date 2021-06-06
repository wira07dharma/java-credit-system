<%--
    Document   : edit_data_tabungan
    Created on : Mar 21, 2013, 9:50:44 AM
    Author     : Dede
--%>

<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package aiso -->
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.transaksi.*" %>
<%@page import="com.dimata.aiso.form.masterdata.transaksi.*" %>

<%@include file="../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
    boolean privPrint = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
%>

<%!    public static String strTitle[][] = {
        {"No Transaksi",//0
            "Nama",//1
            "Tipe Transaksi",//2
            "Nomor Rekening",//3
            "Jenis Simpanan",//4
            "Jumlah Transaksi",//5
            "Tanggal",//6
            "Jumlah Simpanan",//7
            "Potongan",//8
            "Bunga",//9
            "Saldo Saat Ini",//10
            "Status"//11
        },
        {"Transation Number",//0
            "Name",//1
            "Type Transaction",//2
            "Rekening Number",//3
            "Saving Type",//4
            "Traksation Jumlah",//5
            "Date",//6
            "Amount of Saving",//7
            "Potongan",//8
            "Bunga",//9
            "Saldo Saat Ini",//10
            "Status"//11
        }
    };
    public static final String systemTitle[] = {
        "Simpanan", "Saving"
    };
    public static final String userTitle[][] = {
        {"Tambah", "Edit"}, {"Add", "Edit"}
    };
    public static final String tabTitle[][] = {
        {"Pembuatan Rekening", "Proses Transaksi Menabung dan Penarikan"}, {"Pembuatan Rekening", "Proses Transaksi Menabung dan Penarikan"}
    };
%>

<%
    CtrlDataTransaksi ctrlDataTransaksi = new CtrlDataTransaksi(request);
    long oidDataTransaksi = FRMQueryString.requestLong(request, FrmDataTransaksi.fieldNames[FrmDataTransaksi.FRM_FIELD_ID_TRANSAKSI]);
    long oidTypeTabungan = FRMQueryString.requestLong(request, FrmTypeTabungan.fieldNames[FrmTypeTabungan.FRM_FIELD_ID_TIPE_TABUNGAN]);
    long dataTransaksiOID = FRMQueryString.requestLong(request, "" + FrmDataTransaksi.fieldNames[FrmDataTransaksi.FRM_FIELD_ID_TRANSAKSI]);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    //long oidAnggota =  FRMQueryString.requestLong(request, ""+FrmDataTransaksi.fieldNames[FrmDataTransaksi.FRM_FLD_ID_ANGGOTA]);
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.ERR_NONE;

    String errMsg = "";
    String whereClause = "";
    String orderClause = "";
    String formName = FRMQueryString.requestString(request, "formName");
    int addresstype = FRMQueryString.requestInt(request, "addresstype");
    String sTipeTabungan = ""; //Ward
    String sTypeTabungan = ""; //SubRegency
    int start = FRMQueryString.requestInt(request, "start");

    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = systemTitle[SESS_LANGUAGE];
    String strAddAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";
    String saveConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Data Member Success" : "Simpan Data Sukses");

    CtrlTypeTabungan ctrlTypeTabungan = new CtrlTypeTabungan(request);
    iErrCode = ctrlDataTransaksi.Action(iCommand, dataTransaksiOID);
    errMsg = ctrlDataTransaksi.getMessage();
    FrmDataTransaksi frmDataTransaksi = ctrlDataTransaksi.getForm();
    FrmTypeTabungan frmTypeTabungan = ctrlTypeTabungan.getForm();
    DataTransaksi dataTransaksi = ctrlDataTransaksi.getDataTransaksi();
    TypeTabungan typeTabungan = ctrlTypeTabungan.getTypeTabungan();

    typeTabungan.setOID(oidTypeTabungan);
//	if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmAnggota.errorSize()<1)){
    if (iCommand == Command.DELETE) {
%>
<jsp:forward page="data_tabungan.jsp">
    <jsp:param name="prev_command" value="<%=prevCommand%>" />
    <jsp:param name="start" value="<%=start%>" />
    <jsp:param name="ID_DEPOSITO" value="<%=dataTransaksi.getOID()%>" /> 
</jsp:forward>
<%
    }
%>

<!-- End of Jsp Block -->
<html>
    <!-- #BeginTemplate "/Templates/maintab.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>Koperasi - Anggota</title>
        <script language="JavaScript">
          
           
            
            function updateAnggota(){
                oidAnggota    = document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_ID_ANGGOTA]%>.value;  
                window.open("<%=approot%>/masterdata/transaksi/select_anggota_transaksi.jsp?formName=<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>&<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_ID_TRANSAKSI]%>=<%=String.valueOf(dataTransaksiOID)%>"+ 
                    "<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ID_ANGGOTA]%>="+oidAnggota+"",                                                
                null, "height=430, width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
           
            
            function cmdAdd(){
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.command.value="<%=Command.ADD%>"; 
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.action="edit_data_transaksi.jsp";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_ID_TRANSAKSI]%>.value=0;
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.submit();
            }
            
            function cmdCancel(){
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.command.value="<%=Command.CANCEL%>";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.action="edit_data_transaksi.jsp";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.submit();
            }

            function cmdEdit(oid){
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.command.value="<%=Command.EDIT%>";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.action="edit_data_transaksi.jsp";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.submit();
            }
            
            function cmdSave(){
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.command.value="<%=Command.SAVE%>";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.action="edit_data_transaksi.jsp";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.submit();
            }
            
            function cmdAsk(oid){
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.command.value="<%=Command.ASK%>";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.action="edit_data_transaksi.jsp";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.submit();
            }
            
            function cmdConfirmDelete(oid){
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.command.value="<%=Command.DELETE%>";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.action="edit_data_transaksi.jsp";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.submit();
            }
            
            function cmdBack(){
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.command.value="<%=Command.FIRST%>";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.action="data_transaksi.jsp";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.submit();
            }
            
            function cmdView(){
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.command.value="<%=Command.FIRST%>";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.action="data_transaksi.jsp";
                document.<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>.submit();
            }
            
        </script>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <!-- #EndEditable --> 

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
    <body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg')">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                Data Transaksi
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Transaksi</li>
                <li class="active">Data Transaksi</li>
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
                        <form class="form-horizontal" name="<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>" method="post" action=""> 
                            <input type="hidden" name="start" value="<%=start%>">
                            <input type="hidden" name="command" value="<%=iCommand%>">
                            <input type="hidden" name="commandRefresh" value= "0">  
                            <input type="hidden" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_ID_TRANSAKSI]%>" value="<%=dataTransaksi.getOID()%>"> 
                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                            <div class="box-body">

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][3]%></label>                                    
                                        <div class="col-sm-9">
                                            <%
                                                Anggota anggota2 = new Anggota();
                                                if (dataTransaksi.getIdAnggota() != 0) {
                                                    try {
                                                        anggota2 = PstAnggota.fetchExc(dataTransaksi.getIdAnggota());
                                                    } catch (Exception e) {
                                                        anggota2 = new Anggota();
                                                    }
                                                }
                                            %>
                                            <input class="form-control" readonly type="text" placeholder="<%=strTitle[SESS_LANGUAGE][3]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_REKENING]%>" value="<%=anggota2.getNoRekening()%>" onClick="javascript:updateAnggota()"> 
                                            <input class="formElemen" type="hidden" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_ID_ANGGOTA]%>" value="<%="" + dataTransaksi.getIdAnggota()%>" size="40">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][1]%></label>                                    
                                        <div class="col-sm-9">
                                            <input class="form-control"  type="text" placeholder="<%=strTitle[SESS_LANGUAGE][1]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>" value="<%="" + anggota2.getName()%>" size="40">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][2]%></label>                                    
                                        <div class="col-sm-9">
                                            <%
                                                Vector jenis_value2 = new Vector(1, 1);
                                                Vector jenis_key2 = new Vector(1, 1);
                                                jenis_value2.add("0");
                                                jenis_key2.add("select ...");
                                                String strWhereKota2 = "";//PstTypeTabungan.fieldNames[PstTypeTabungan.FLD_TIPE_TABUNGAN] + "=" + typeTabungan.getTypeTabungan();  
                                                Vector listKota2 = PstTypeTabungan.list(0, 300, strWhereKota2, "" + PstTypeTabungan.fieldNames[PstTypeTabungan.FLD_TIPE_TABUNGAN]);
                                                boolean oidKotaOk2 = false;
                                                for (int i = 0; i < listKota2.size(); i++) {
                                                    TypeTabungan objEntity = (TypeTabungan) listKota2.get(i);
                                                    jenis_key2.add(objEntity.getTypeTabungan());
                                                    jenis_value2.add(String.valueOf(objEntity.getOID()));
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_JENIS_TRANSAKSI], "form-control", null, "" + dataTransaksi.getJenisTransaksi(), jenis_value2, jenis_key2)%>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][5]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][5]%>" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_JUMLAH_TRANSAKSI]%>" value="<%=dataTransaksi.getJumlahTransaksi()%>">  
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][9]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][9]%>" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_BUNGA]%>" value="<%=dataTransaksi.getBunga()%>">  
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][8]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][8]%>" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_POTONGAN]%>" value="<%=dataTransaksi.getPotongan()%>">  
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][10]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="number" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][10]%>" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_TOTAL_SALDO]%>" value="<%=dataTransaksi.getSaldo()%>">  
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][0]%></label>                                    
                                        <div class="col-sm-9">
                                            <%if (iCommand == Command.ADD || iCommand == Command.NONE) {%>
                                            <%  String codeAutomatic = PstDataTransaksi.getCodeAutoGenerate();%>
                                            <input class="form-control" type="text" placeholder="<%=strTitle[SESS_LANGUAGE][0]%>" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_CODE_TRANSAKSI]%>" value="<%="" + codeAutomatic%>">                                                                                                                                  
                                            <%} else {%>
                                            <input class="form-control" type="text" placeholder="<%=strTitle[SESS_LANGUAGE][0]%>" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_CODE_TRANSAKSI]%>" value="<%="" + dataTransaksi.getCodeTransaksi()%>">
                                            <%}%>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][6]%></label>                                    
                                        <div class="col-sm-9">
                                            <%
                                                String tanggal = "" + dataTransaksi.getTanggal();
                                                if (tanggal.equals("null")) {
                                                    tanggal = "";
                                                } else {
                                                    tanggal = Formater.formatDate(dataTransaksi.getTanggal(),"yyyy-MM-dd");
                                                }
                                            %>
                                            <input type="text" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" placeholder="<%=strTitle[SESS_LANGUAGE][6]%>" name="<%=FrmDataTransaksi.fieldNames[FrmDataTransaksi.FRM_FIELD_TANGGAL_TRANSAKSI]%>" value="<%=tanggal%>">
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <div class="">
                                    <%

                                        ctrLine.setLocationImg(approot + "/image/ctr_line");
                                        ctrLine.initDefault();
                                        ctrLine.setTableWidth("100%");
                                        String scomDel2 = "javascript:cmdAsk('" + dataTransaksiOID + "')";
                                        String sconDelCom2 = "javascript:cmdConfirmDelete('" + dataTransaksiOID + "')";
                                        String scancel2 = "javascript:cmdEdit('" + dataTransaksiOID + "')";

                                        ctrLine.setCommandStyle("command");
                                        ctrLine.setColCommStyle("command");

                                        ctrLine.setAddCaption(strAddAnggota);
                                        ctrLine.setCancelCaption(" | " + strCancel);
                                        ctrLine.setBackCaption(" | " + strBackAnggota);
                                        ctrLine.setSaveCaption(strSaveAnggota);
                                        ctrLine.setDeleteCaption(" | " + strAskAnggota);
                                        ctrLine.setConfirmDelCaption(" | " + strDeleteAnggota);

                                        if (privDelete) {
                                            ctrLine.setConfirmDelCommand(sconDelCom2);
                                            ctrLine.setDeleteCommand(scomDel2);
                                            ctrLine.setEditCommand(scancel2);
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

                                        if (iCommand == Command.EDIT) {
                                            iCommand = Command.EDIT;
                                        }
                                    %> <%= ctrLine.draw(iCommand, iErrCode, errMsg)%> 
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
                    todayBtn:  1,
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
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF">
            <tr>
                <td bgcolor="#9BC1FF"  valign="middle" height="15" class="contenttitle">
                    <font color="#FF6600" face="Arial">
                    <!-- #BeginEditable "contenttitle" -->
                    <%=systemTitle[SESS_LANGUAGE]%>&nbsp;
                    <%
                        if (dataTransaksiOID != 0) {
                            out.print(userTitle[SESS_LANGUAGE][1]);
                        } else {
                            out.print(userTitle[SESS_LANGUAGE][0]);
                        }
                    %>
                    <!-- #EndEditable --> 
                    </font>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td  bgcolor="#9BC1FF" height="10" valign="middle">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>

                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td width="88%" valign="top" align="left">
                                <table width="100%" border="0" cellspacing="3" cellpadding="2">
                                    <tr>
                                        <td width="100%">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td valign="top">
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                        <tr>
                                                                            <td valign="top"> <!-- #BeginEditable "content" -->
                                                                                <form name="<%=frmDataTransaksi.FRM_TRANSAKSI_NAME%>" method="post" action=""> 
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="commandRefresh" value= "0">  
                                                                                    <input type="hidden" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_ID_TRANSAKSI]%>" value="<%=dataTransaksi.getOID()%>"> 
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td class="tablecolor">
                                                                                                <table  width="98%" align="center" border="0" cellspacing="2" cellpadding="2" bgcolor="#9BC1FF">
                                                                                                    <tr>
                                                                                                        <td valign="top">
                                                                                                            <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                                                                                                <tr>

                                                                                                                    <td valign="top" width="100%">
                                                                                                                        <table width="100%" border="0" cellspacing="2" cellpadding="2" >
                                                                                                                            <tr>
                                                                                                                                <td height="60"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="15%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="25%"></td>
                                                                                                                                <td scope="col" width="5%">&nbsp;</td>
                                                                                                                                <td scope="col" width="15%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="25%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>

                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <!--no transaksi-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][0]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <%if (iCommand == Command.ADD || iCommand == Command.NONE) {%>
                                                                                                                                    <%  String codeAutomatic = PstDataTransaksi.getCodeAutoGenerate();%>
                                                                                                                                    <input class="formElemen" type="text" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_CODE_TRANSAKSI]%>" value="<%="" + codeAutomatic%>" size="40">                                                                                                                                  
                                                                                                                                    <%} else {%>
                                                                                                                                    <input class="formElemen" type="text" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_CODE_TRANSAKSI]%>" value="<%="" + dataTransaksi.getCodeTransaksi()%>" size="40">
                                                                                                                                    <%}%>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>

                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td class="comment"><em>*) entry required</em></td>
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>Tanggal</td>
                                                                                                                                <td>:</td>
                                                                                                                                <%if (dataTransaksi.getTanggal() != null) {%>
                                                                                                                                <td>
                                                                                                                                    <%=Formater.formatDate(dataTransaksi.getTanggal(), "MMM, dd yyyy")%>
                                                                                                                                </td>
                                                                                                                                <%} else {%>
                                                                                                                                <td>
                                                                                                                                    <%=ControlDatePopup.writeDate(FrmDataTransaksi.fieldNames[FrmDataTransaksi.FRM_FIELD_TANGGAL_TRANSAKSI], dataTransaksi.getTanggal())%> 
                                                                                                                                </td>
                                                                                                                                <%}%>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--nama anggota--->
                                                                                                                                <td>No Rekening</td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <%
                                                                                                                                        Anggota anggota = new Anggota();
                                                                                                                                        if (dataTransaksi.getIdAnggota() != 0) {
                                                                                                                                            try {
                                                                                                                                                anggota = PstAnggota.fetchExc(dataTransaksi.getIdAnggota());
                                                                                                                                            } catch (Exception e) {
                                                                                                                                                anggota = new Anggota();
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                    <input class="formElemen" type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>" readonly="true" value="<%=anggota.getName()%>" size="40" onClick="javascript:updateAnggota()">*&nbsp; 
                                                                                                                                    <input class="formElemen" type="hidden" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_ID_ANGGOTA]%>" value="<%="" + dataTransaksi.getIdAnggota()%>" size="40">
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][1]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td><input class="formElemen"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_REKENING]%>" value="<%="" + anggota.getNoRekening()%>" size="40"></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Tipe Transaksi-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][2]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td><%
                                                                                                                                    Vector jenis_value = new Vector(1, 1);
                                                                                                                                    Vector jenis_key = new Vector(1, 1);
                                                                                                                                    jenis_value.add("0");
                                                                                                                                    jenis_key.add("select ...");
                                                                                                                                    String strWhereKota = "";//PstTypeTabungan.fieldNames[PstTypeTabungan.FLD_TIPE_TABUNGAN] + "=" + typeTabungan.getTypeTabungan();  
                                                                                                                                    Vector listKota = PstTypeTabungan.list(0, 300, strWhereKota, "" + PstTypeTabungan.fieldNames[PstTypeTabungan.FLD_TIPE_TABUNGAN]);
                                                                                                                                    boolean oidKotaOk = false;
                                                                                                                                    for (int i = 0; i < listKota.size(); i++) {
                                                                                                                                        TypeTabungan objEntity = (TypeTabungan) listKota.get(i);
                                                                                                                                        jenis_key.add(objEntity.getTypeTabungan());
                                                                                                                                        jenis_value.add(String.valueOf(objEntity.getOID()));
                                                                                                                                    }
                                                                                                                                    %> <%= ControlCombo.draw(frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_JENIS_TRANSAKSI], "formElemen", null, "" + dataTransaksi.getJenisTransaksi(), jenis_value, jenis_key)%>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--status-->
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp</td>

                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Jumlah Simpanan-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][5]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <input type="text" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_JUMLAH_TRANSAKSI]%>" value="<%=dataTransaksi.getJumlahTransaksi()%>">  
                                                                                                                                    *&nbsp;<%=frmDataTransaksi.getErrorMsg(frmDataTransaksi.FRM_FIELD_JUMLAH_TRANSAKSI)%>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--status-->
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp</td>

                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Bunga-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][9]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <input type="text" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_BUNGA]%>" value="<%=dataTransaksi.getBunga()%>">  
                                                                                                                                    *&nbsp;<%=frmDataTransaksi.getErrorMsg(frmDataTransaksi.FRM_FIELD_BUNGA)%>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp</td>

                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Potongan-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][8]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <input type="text" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_POTONGAN]%>" value="<%=dataTransaksi.getPotongan()%>">  
                                                                                                                                    *&nbsp;<%=frmDataTransaksi.getErrorMsg(frmDataTransaksi.FRM_FIELD_POTONGAN)%>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp</td>

                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Saldo Saat Ini-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][10]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <input type="text" name="<%=frmDataTransaksi.fieldNames[frmDataTransaksi.FRM_FIELD_TOTAL_SALDO]%>" value="<%=dataTransaksi.getSaldo()%>">  
                                                                                                                                    *&nbsp;<%=frmDataTransaksi.getErrorMsg(frmDataTransaksi.FRM_FIELD_TOTAL_SALDO)%>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp</td>

                                                                                                                                <td>&nbsp</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="20" colspan="9"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td colspan="5">
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td> <%

                                                                                                                                                ctrLine.setLocationImg(approot + "/image/ctr_line");
                                                                                                                                                ctrLine.initDefault();
                                                                                                                                                ctrLine.setTableWidth("100%");
                                                                                                                                                String scomDel = "javascript:cmdAsk('" + dataTransaksiOID + "')";
                                                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + dataTransaksiOID + "')";
                                                                                                                                                String scancel = "javascript:cmdEdit('" + dataTransaksiOID + "')";

                                                                                                                                                ctrLine.setCommandStyle("command");
                                                                                                                                                ctrLine.setColCommStyle("command");

                                                                                                                                                ctrLine.setAddCaption(strAddAnggota);
                                                                                                                                                ctrLine.setCancelCaption(strCancel);
                                                                                                                                                ctrLine.setBackCaption(strBackAnggota);
                                                                                                                                                ctrLine.setSaveCaption(strSaveAnggota);
                                                                                                                                                ctrLine.setDeleteCaption(strAskAnggota);
                                                                                                                                                ctrLine.setConfirmDelCaption(strDeleteAnggota);

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

                                                                                                                                                if (iCommand == Command.EDIT) {
                                                                                                                                                    iCommand = Command.EDIT;
                                                                                                                                                }
                                                                                                                                                %> <%= ctrLine.draw(iCommand, iErrCode, errMsg)%> 
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="20">&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>

                                                                                                <!-- #EndEditable -->
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </form>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="70">&nbsp;</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="20" bgcolor="#9BC1FF"> 
                                <!-- #BeginEditable "footer" -->
                                <%@ include file = "../../main/footer.jsp" %>
                                <!-- #EndEditable --> 
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        --%>
    </body>
    <!-- #BeginEditable "script" -->
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>
