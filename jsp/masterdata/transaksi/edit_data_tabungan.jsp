<%--
    Document   : edit_data_tabungan
    Created on : Mar 21, 2013, 9:50:44 AM
    Author     : Dede
--%>

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
        {"No Registrasi",//0
            "Nama Anggota",//1
            "Alamat Anggota",//2
            "Nomor Rekening",//3
            "Jenis Simpanan",//4
            "Kelompok Anggota",//5
            "Tanggal",//6
            "Jumlah Simpanan",//7
            "PPH",//8
            "Bunga",//9
            "Biaya Admin",//10
            "Status"//11
        },
        {"Member ID",//0
            "Member Name",//1
            "Member Address",//2
            "Rekening Number",//3
            "Saving Type",//4
            "Member Club",//5
            "Date",//6
            "Amount of Saving",//7
            "PPH",//8
            "Bunga",//9
            "Biaya Admin",//10
            "Status"//11
        }
    };
    public static final String systemTitle[] = {
        "Data", "Saving"
    };
    public static final String userTitle[][] = {
        {"Tambah", "Edit"}, {"Add", "Edit"}
    };
    public static final String tabTitle[][] = {
        {"Pembuatan Tabungan", "Proses Transaksi Menabung dan Penarikan"}, {"Pembuatan Tabungan", "Proses Transaksi Menabung dan Penarikan"}
    };
%>

<%
    CtrlDataTabungan ctrlDataTabungan = new CtrlDataTabungan(request);
    String noReg = FRMQueryString.requestString(request, "" + FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]);
    long idAngg = FRMQueryString.requestLong(request, FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_ID_ANGGOTA]);
    String tgl = FRMQueryString.requestString(request, "" + FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_TANGGAL]);
    String nama = FRMQueryString.requestString(request, "" + FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]);
    String noRek = FRMQueryString.requestString(request, "" + FrmAnggota.fieldNames[FrmAnggota.FRM_NO_REKENING]);
    String alamat = FRMQueryString.requestString(request, "" + FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PERMANENT]);

    long oidJenisSimpanan = FRMQueryString.requestLong(request, FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_ID_JENIS_SIMPANAN]);
    long oidMasterTabungan = FRMQueryString.requestLong(request, FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]);
    long oidJenisTabungan = FRMQueryString.requestLong(request, FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_JENIS_TABUNGAN_ID]);
    long datatabunganOID = FRMQueryString.requestLong(request, "" + FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_ID_SIMPANAN]);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    //long oidAnggota =  FRMQueryString.requestLong(request, ""+FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FLD_ID_ANGGOTA]);
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.ERR_NONE;

    String errMsg = "";
    String whereClause = "";
    String orderClause = "";
    String formName = FRMQueryString.requestString(request, "formName");
    int addresstype = FRMQueryString.requestInt(request, "addresstype");
    int refresh = FRMQueryString.requestInt(request, "commandRefresh");
    String sTipeTabungan = ""; //Ward
    String sJenisTabungan = ""; //SubRegency
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

    CtrlJenisTabungan ctrlJenisTabungan = new CtrlJenisTabungan(request);
    iErrCode = ctrlDataTabungan.Action(iCommand, datatabunganOID);
    errMsg = ctrlDataTabungan.getMessage();
    FrmDataTabungan frmDataTabungan = ctrlDataTabungan.getForm();
    FrmJenisTabungan frmJenisTabungan = ctrlJenisTabungan.getForm();
    DataTabungan dataTabungan = ctrlDataTabungan.getDataTabungan();
    JenisTabungan jenisTabungan = ctrlJenisTabungan.getJenisTabungan();

    Anggota anggota1 = new Anggota();
    if (refresh == 1) {
        dataTabungan.setTanggal(Formater.formatDate(tgl, "yyyy-MM-dd"));
        anggota1.setNoAnggota(noReg);
        anggota1.setName(nama);
        anggota1.setNoRekening(noRek);
        anggota1.setAddressPermanent(alamat);
        dataTabungan.setIdJenisSimpanan(oidJenisSimpanan);
        dataTabungan.setIdJenisTabungan(oidJenisTabungan);
        jenisTabungan.setId_tabungan(oidMasterTabungan);
    }
    
//	if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmAnggota.errorSize()<1)){
    if (iCommand == Command.DELETE) {
%>
<jsp:forward page="data_tabungan.jsp">
    <jsp:param name="prev_command" value="<%=prevCommand%>" />
    <jsp:param name="start" value="<%=start%>" />
    <jsp:param name="ID_DEPOSITO" value="<%=dataTabungan.getOID()%>" /> 
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
          
            function cmdUpdateJenisTabungan(){
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.command.value="<%=iCommand%>";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.commandRefresh.value= "1";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.action="edit_data_tabungan.jsp";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
            }
            
            function updateAnggota(){
                oidAnggota    = document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_ANGGOTA]%>.value;  
                window.open("<%=approot%>/masterdata/transaksi/select_anggota_tabungan.jsp?formName=<%=frmDataTabungan.FRM_TABUNGAN_NAME%>&<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_SIMPANAN]%>=<%=String.valueOf(datatabunganOID)%>"+ 
                    "<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ID_ANGGOTA]%>="+oidAnggota+"",                                                
                null, "height=430, width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function updateJenisSimpanan(){
                oidJenisDataTabungan    = document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_JENIS_SIMPANAN]%>.value; 
                window.open("<%=approot%>/masterdata/transaksi/select_jenis_simpanan.jsp?formName=<%=frmDataTabungan.FRM_TABUNGAN_NAME%>&<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_SIMPANAN]%>=<%=String.valueOf(datatabunganOID)%>"+
                    "<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_ID_JENIS_SIMPANAN]%>="+oidJenisDataTabungan+"",                                                
                null, "height=350, width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdAdd(){
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.command.value="<%=Command.ADD%>"; 
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.action="edit_data_tabungan.jsp";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_SIMPANAN]%>.value=0;
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
            }
            
            function cmdCancel(){
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.command.value="<%=Command.CANCEL%>";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.action="edit_data_tabungan.jsp";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
            }

            function cmdEdit(oid){
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.command.value="<%=Command.EDIT%>";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.action="edit_data_tabungan.jsp";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
            }
            
            function cmdSave(){
                var oidAngta = document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_ANGGOTA]%>.value;
                var oidJenisSimp = document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_JENIS_SIMPANAN]%>.value;
                var oidJenisTab = document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_JENIS_TABUNGAN_ID]%>.value;
                var date = document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_TANGGAL]%>.value;
                if (oidAngta == 0) {
                    alert("Silakan pilih nomor registrasi anggota");
                    return false;
                } else if (date == "") {
                    alert("Silakan masukkan tanggal");
                    return false;
                } else if (oidJenisSimp == 0) {
                    alert("Silakan pilih jenis simpanan");
                    return false;
                } else if (oidJenisTab == 0) {
                    alert("Silakan pilih jenis tabungan");
                    return false;
                }
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.command.value="<%=Command.SAVE%>";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.action="edit_data_tabungan.jsp";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
            }
            
            function cmdAsk(oid){
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.command.value="<%=Command.ASK%>";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.action="edit_data_tabungan.jsp";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
            }
            
            function cmdConfirmDelete(oid){
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.command.value="<%=Command.DELETE%>";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.action="edit_data_tabungan.jsp";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
            }
            
            function cmdBack(){
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.command.value="<%=Command.FIRST%>";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.action="data_tabungan.jsp";
                document.<%=frmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
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
                Data Tabungan
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Transaksi</li>
                <li class="active">Data Tabungan</li>
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
                        <form class="form-horizontal" name="<%=frmDataTabungan.FRM_TABUNGAN_NAME%>" method="post" action="">
                            <input type="hidden" name="start" value="<%=start%>">
                            <input type="hidden" name="command" value="<%=iCommand%>">
                            <input type="hidden" name="commandRefresh" value= "0">  
                            <input type="hidden" name="<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_SIMPANAN]%>" value="<%=dataTabungan.getOID()%>">
                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                            <div class="box-body">                                

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][0]%></label>                                    
                                        <div class="col-sm-9">
                                            <%
                                                Anggota anggota2 = new Anggota();
                                                if (dataTabungan.getIdAnggota() != 0) {
                                                    try {
                                                        anggota2 = PstAnggota.fetchExc(dataTabungan.getIdAnggota());
                                                    } catch (Exception e) {
                                                        anggota2 = new Anggota();
                                                    }
                                                }
                                                if (refresh == 1) {
                                                    anggota2.setNoAnggota(anggota1.getNoAnggota());
                                                    dataTabungan.setIdAnggota(idAngg);
                                                }
                                            %>
                                            <input type="text" readonly class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][0]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]%>" value="<%=anggota2.getNoAnggota()%>" onClick="javascript:updateAnggota()">
                                            <input class="formElemen" type="hidden" name="<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_ANGGOTA]%>" value="<%="" + dataTabungan.getIdAnggota()%>" size="40">                                                                                                                                  
                                        </div>
                                    </div>   

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][6]%></label>                                    
                                        <div class="col-sm-9">
                                            <%
                                                String tanggal = "" + dataTabungan.getTanggal();
                                                if (tanggal.equals("null")) {
                                                    tanggal = "";
                                                } else {
                                                    tanggal = Formater.formatDate(dataTabungan.getTanggal(), "yyyy-MM-dd");
                                                }
                                            %>
                                            <input type="text" required class="form-control datetime-picker" data-date-format="yyyy-mm-dd" placeholder="<%=strTitle[SESS_LANGUAGE][6]%>" name="<%=FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_TANGGAL]%>" value="<%=tanggal%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][1]%></label>                                    
                                        <div class="col-sm-9">   
                                            <%
                                                if (refresh == 1) {
                                                    anggota2.setName(anggota1.getName());
                                                }
                                            %>
                                            <input type="text" class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][1]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>" value="<%="" + anggota2.getName()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][3]%></label>                                    
                                        <div class="col-sm-9">  
                                            <%
                                                if (refresh == 1) {
                                                    anggota2.setNoRekening(anggota1.getNoRekening());
                                                }
                                            %>
                                            <input type="text" class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][3]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_REKENING]%>" value="<%="" + anggota2.getNoRekening()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][2]%></label>                                    
                                        <div class="col-sm-9">  
                                            <%
                                                if (refresh == 1) {
                                                    anggota2.setAddressPermanent(anggota1.getAddressPermanent());
                                                }
                                            %>
                                            <input type="text" class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][2]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PERMANENT]%>" value="<%="" + anggota2.getAddressPermanent()%>">
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6">   
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][4]%></label>                                    
                                        <div class="col-sm-9">  
                                            <%
                                                Vector simpanan_value = new Vector(1, 1);
                                                Vector simpanan_key = new Vector(1, 1);

                                                simpanan_value.add("0");
                                                simpanan_key.add("select ...");
                                                String strWhere1 = ""; //PstProvince.fieldNames[PstProvince.FLD_PROVINCE_ID] + "=" +ward.getIdProvince();
                                                Vector listSimpanan = PstJenisSimpanan.list(0, 300, strWhere1, "" + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]);
                                                boolean oidProvOk1 = false;
                                                for (int i = 0; i < listSimpanan.size(); i++) {
                                                    JenisSimpanan jenisSimpanan = (JenisSimpanan) listSimpanan.get(i);
                                                    simpanan_key.add(jenisSimpanan.getNamaSimpanan());
                                                    simpanan_value.add(String.valueOf(jenisSimpanan.getOID()));
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_JENIS_SIMPANAN], "form-control", null, "" + dataTabungan.getIdJenisSimpanan(), simpanan_value, simpanan_key, "required")%>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Tipe Tabungan</label>                                    
                                        <div class="col-sm-9">  
                                            <%
                                                Vector pro_value2 = new Vector(1, 1);
                                                Vector pro_key2 = new Vector(1, 1);
                                                MasterTabungan masterTabungan2 = new MasterTabungan();
                                                pro_value2.add("0");
                                                pro_key2.add("select ...");
                                                String strWhere2 = ""; //PstProvince.fieldNames[PstProvince.FLD_PROVINCE_ID] + "=" +ward.getIdProvince();
                                                Vector listPro2 = PstMasterTabungan.list(0, 300, strWhere2, "" + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN]);
                                                boolean oidProvOk2 = false;
                                                for (int i = 0; i < listPro2.size(); i++) {
                                                    MasterTabungan masterT = (MasterTabungan) listPro2.get(i);
                                                    pro_key2.add(masterT.getSavingName());
                                                    pro_value2.add(String.valueOf(masterT.getOID()));
                                                    if (masterT.getOID() == jenisTabungan.getId_tabungan()) {
                                                        oidProvOk2 = true;
                                                        jenisTabungan.setId_tabungan(masterT.getOID());
                                                    }
                                                }
                                                if (!oidProvOk2) {
                                                    jenisTabungan.setId_tabungan(0);
                                                    oidMasterTabungan = 0;
                                                }
                                                if(oidMasterTabungan==0){
                                                    if(dataTabungan.getIdJenisTabungan()!=0){
                                                        jenisTabungan.setId_tabungan(dataTabungan.getIdJenisTabungan());
                                                   }
                                                }
                                                
                                            %>
                                            <%= ControlCombo.draw(frmJenisTabungan.fieldNames[frmJenisTabungan.FRM_FIELD_ID_TABUNGAN], "form-control", null, "" + jenisTabungan.getId_tabungan(), pro_value2, pro_key2, "id = \"jentab\" onChange=\"javascript:cmdUpdateJenisTabungan()\" required")%>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Jenis Tabungan</label>                                    
                                        <div class="col-sm-9">
                                            <%
                                                Vector jenis_value2 = new Vector(1, 1);
                                                Vector jenis_key2 = new Vector(1, 1);
                                                jenis_value2.add("0");
                                                jenis_key2.add("select ...");
                                                String strWhereKota2 = PstJenisTabungan.fieldNames[PstJenisTabungan.FLD_ID_TABUNGAN] + "=" + jenisTabungan.getId_tabungan();
                                                Vector listKota2 = PstJenisTabungan.list(0, 300, strWhereKota2, "" + PstJenisTabungan.fieldNames[PstJenisTabungan.FLD_NAMA_JENIS_TABUNGAN]);
                                                boolean oidKotaOk2 = false;
                                                long jentab = 0;
                                                for (int i = 0; i < listKota2.size(); i++) {
                                                    JenisTabungan objEntity = (JenisTabungan) listKota2.get(i);
                                                    jenis_key2.add(objEntity.getNamaJenisTbgn());
                                                    jenis_value2.add(String.valueOf(objEntity.getOID()));
                                                    jentab = objEntity.getOID();
                                                }
                                            %> <%= ControlCombo.draw(frmJenisTabungan.fieldNames[frmJenisTabungan.FRM_FIELD_JENIS_TABUNGAN_ID], "form-control", null, "" + jentab, jenis_value2, jenis_key2, "required")%>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][7]%></label>                                    
                                        <div class="col-sm-9"> 
                                            <td valign="top">
                                                <input type="number" class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][7]%>" name="<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_JUMLAH]%>" value="<%="" + dataTabungan.getJumlah()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][11]%></label>                                    
                                        <div class="col-sm-9">  
                                            <%
                                                ControlCombo combo2 = new ControlCombo();
                                                Vector keyStatus2 = PstDataTabungan.getStatusDataTabunganKey();
                                                Vector valueStatus2 = PstDataTabungan.getStatusDataTabunganValue();
                                            %>   
                                            <td valign="top">
                                                <%=combo2.draw(frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_STATUS], "form-control", null, "" + dataTabungan.getStatus(), valueStatus2, keyStatus2)%> 
                                        </div>
                                    </div>                                                                            
                                </div>

                                <%--
                <div class="col-sm-12" style="background-color: rgba(144, 238, 144, 0.7); padding-top: 15px; padding-left: 0px;padding-right: 0px">

                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][4]%></label>                                    
                                            <div class="col-sm-9"> 
                                                <%
                                                    JenisSimpanan jenisSimpanan2 = new JenisSimpanan();
                                                    if (dataTabungan.getIdJenisSimpanan() != 0) {
                                                        try {
                                                            jenisSimpanan2 = PstJenisSimpanan.fetchExc(dataTabungan.getIdJenisSimpanan());
                                                        } catch (Exception e) {
                                                            jenisSimpanan2 = new JenisSimpanan();
                                                        }
                                                    }
                                                    String js = "" + jenisSimpanan2.getDescJenisSimpanan();
                                                    if (js.equals("null")) {
                                                        js = "";
                                                    }
                                                %>
                                                <input type="text" readonly class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][4]%>" name="" value="">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Saldo Saat Ini</label>                                    
                                            <div class="col-sm-9">  
                                                <input type="text" readonly class="form-control" placeholder="Saldo Saat Ini" name="" value="">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][8]%></label>                                    
                                            <div class="col-sm-9">  
                                                <input type="text" readonly class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][8]%>" name="" value="">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][9]%></label>                                    
                                            <div class="col-sm-9">  
                                                <input type="text" readonly class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][9]%>" name="" value="">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][10]%></label>                                    
                                            <div class="col-sm-9">  
                                                <input type="text" readonly class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][10]%>" name="" value="">
                                            </div>
                                        </div>
                                    </div>

                                </div>  
                                --%>

                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <%
                                    ctrLine.setLocationImg(approot + "/image/ctr_line");
                                    ctrLine.initDefault();
                                    ctrLine.setTableWidth("100%");
                                    String scomDel = "javascript:cmdAsk('" + datatabunganOID + "')";
                                    String sconDelCom = "javascript:cmdConfirmDelete('" + datatabunganOID + "')";
                                    String scancel = "javascript:cmdEdit('" + datatabunganOID + "')";

                                    ctrLine.setCommandStyle("command");
                                    ctrLine.setColCommStyle("command");

                                    ctrLine.setAddCaption(strAddAnggota);
                                    ctrLine.setCancelCaption(" | " + strCancel);
                                    ctrLine.setBackCaption(" | " + strBackAnggota);
                                    ctrLine.setSaveCaption(strSaveAnggota);
                                    ctrLine.setDeleteCaption(" | " + strAskAnggota);
                                    ctrLine.setConfirmDelCaption(" | " + strDeleteAnggota);

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
if (datatabunganOID != 0) {
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
                                                                                <form name="<%=frmDataTabungan.FRM_TABUNGAN_NAME%>" method="post" action="">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="commandRefresh" value= "0">  
                                                                                    <input type="hidden" name="<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_SIMPANAN]%>" value="<%=dataTabungan.getOID()%>">
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
                                                                                                                                <td scope="col" width="25%" class="comment"><em>*) entry required</em></td>
                                                                                                                                <td scope="col" width="5%">&nbsp;</td>
                                                                                                                                <td scope="col" width="15%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="25%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--no anggota-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][0]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <%
                                                                                                                                        Anggota anggota = new Anggota();
                                                                                                                                        if (dataTabungan.getIdAnggota() != 0) {
                                                                                                                                            try {
                                                                                                                                                anggota = PstAnggota.fetchExc(dataTabungan.getIdAnggota());
                                                                                                                                            } catch (Exception e) {
                                                                                                                                                anggota = new Anggota();
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                    <input class="formElemen" type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]%>" readonly="true" value="<%=anggota.getNoAnggota()%>" size="40" onClick="javascript:updateAnggota()">*&nbsp;
                                                                                                                                    <input class="formElemen" type="hidden" name="<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_ANGGOTA]%>" value="<%="" + dataTabungan.getIdAnggota()%>" size="40">                                                                                                                                  
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>Tipe Tabungan</td>
                                                                                                                                <td>:</td>
                                                                                                                                <td width="75%"><%
                                                                                                                                    Vector pro_value = new Vector(1, 1);
                                                                                                                                    Vector pro_key = new Vector(1, 1);
                                                                                                                                    MasterTabungan masterTabungan = new MasterTabungan();
                                                                                                                                    pro_value.add("0");
                                                                                                                                    pro_key.add("select ...");
                                                                                                                                    String strWhere = ""; //PstProvince.fieldNames[PstProvince.FLD_PROVINCE_ID] + "=" +ward.getIdProvince();
                                                                                                                                    Vector listPro = PstMasterTabungan.list(0, 300, strWhere, "" + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN]);
                                                                                                                                    boolean oidProvOk = false;
                                                                                                                                    for (int i = 0; i < listPro.size(); i++) {
                                                                                                                                        MasterTabungan masterT = (MasterTabungan) listPro.get(i);
                                                                                                                                        pro_key.add(masterT.getSavingName());
                                                                                                                                        pro_value.add(String.valueOf(masterT.getOID()));
                                                                                                                                        if (masterT.getOID() == jenisTabungan.getId_tabungan()) {
                                                                                                                                            oidProvOk = true;
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    if (!oidProvOk) {
                                                                                                                                        jenisTabungan.setId_tabungan(0);
                                                                                                                                        oidMasterTabungan = 0;
                                                                                                                                    }
                                                                                                                                    %>
                                                                                                                                    <%= ControlCombo.draw(frmJenisTabungan.fieldNames[frmJenisTabungan.FRM_FIELD_ID_TABUNGAN], "formElemen", null, "" + jenisTabungan.getId_tabungan(), pro_value, pro_key, "onChange=\"javascript:cmdUpdateJenisTabungan()\"")%>
                                                                                                                                </td>

                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>Tanggal</td>
                                                                                                                                <td>:</td>
                                                                                                                                <%if (dataTabungan.getTanggal() != null) {%>
                                                                                                                                <td>
                                                                                                                                    <%=Formater.formatDate(dataTabungan.getTanggal(), "MMM, dd yyyy")%>
                                                                                                                                </td>
                                                                                                                                <%} else {%>
                                                                                                                                <td>
                                                                                                                                    <%=ControlDatePopup.writeDate(FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_TANGGAL], dataTabungan.getTanggal())%> 
                                                                                                                                </td>
                                                                                                                                <%}%>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>Jenis Tabungan</td>
                                                                                                                                <td>:</td>
                                                                                                                                <td><%
                                                                                                                                    Vector jenis_value = new Vector(1, 1);
                                                                                                                                    Vector jenis_key = new Vector(1, 1);
                                                                                                                                    jenis_value.add("0");
                                                                                                                                    jenis_key.add("select ...");
                                                                                                                                    String strWhereKota = PstJenisTabungan.fieldNames[PstJenisTabungan.FLD_ID_TABUNGAN] + "=" + jenisTabungan.getId_tabungan();
                                                                                                                                    Vector listKota = PstJenisTabungan.list(0, 300, strWhereKota, "" + PstJenisTabungan.fieldNames[PstJenisTabungan.FLD_NAMA_JENIS_TABUNGAN]);
                                                                                                                                    boolean oidKotaOk = false;
                                                                                                                                    for (int i = 0; i < listKota.size(); i++) {
                                                                                                                                        JenisTabungan objEntity = (JenisTabungan) listKota.get(i);
                                                                                                                                        jenis_key.add(objEntity.getNamaJenisTbgn());
                                                                                                                                        jenis_value.add(String.valueOf(objEntity.getOID()));
                                                                                                                                    }
                                                                                                                                    %> <%= ControlCombo.draw(frmJenisTabungan.fieldNames[frmJenisTabungan.FRM_FIELD_JENIS_TABUNGAN_ID], "formElemen", null, "" + jenisTabungan.getOID(), jenis_value, jenis_key)%>
                                                                                                                                </td>

                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--nama anggota--->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][1]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <input class="formElemen"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>" value="<%="" + anggota.getName()%>" size="40">
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>No Rekening</td>
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
                                                                                                                                <!--alamat-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][2]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td><input class="formElemen"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PERMANENT]%>" value="<%="" + anggota.getAddressPermanent()%>" size="40"></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--status-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][11]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <%
                                                                                                                                    ControlCombo combo = new ControlCombo();
                                                                                                                                    Vector keyStatus = PstDataTabungan.getStatusDataTabunganKey();
                                                                                                                                    Vector valueStatus = PstDataTabungan.getStatusDataTabunganValue();
                                                                                                                                %>   
                                                                                                                                <td valign="top">
                                                                                                                                    <%=combo.draw(frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_STATUS], "formElemen", null, "" + dataTabungan.getStatus(), valueStatus, keyStatus)%> 
                                                                                                                                    * &nbsp;<%= frmDataTabungan.getErrorMsg(frmDataTabungan.FRM_FIELD_STATUS)%>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="40"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td colspan="7">
                                                                                                                                    <table border="0" width="100%" cellpadding="0" cellspacing="0" class="listgenactivity">
                                                                                                                                        <tr>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                            <td width="20%">&nbsp;</td>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                            <td width="25%">&nbsp;</td>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                            <td width="20%">&nbsp;</td>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                            <td width="25%">&nbsp;</td>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="30">&nbsp;</td>
                                                                                                                                            <td>Jenis Simpanan</td>
                                                                                                                                            <td>:</td>
                                                                                                                                            <td>
        <%--
          JenisSimpanan jenisSimpanan = new JenisSimpanan();
          if(dataTabungan.getIdJenisSimpanan()!= 0){
            try{
                jenisSimpanan = PstJenisSimpanan.fetchExc(dataTabungan.getIdJenisSimpanan()); 
            }catch(Exception e){
                jenisSimpanan = new JenisSimpanan(); 
            }
          }                                                                                                                   
        --%><%--
        <!--input class="formElemen"  type="text" name="<%=//FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_NAMA_SIMPANAN]%>" readonly="true" value="<%=//jenisSimpanan.getNamaSimpanan()%>" size="40" onClick="javascript:updateJenisSimpanan()"-->*&nbsp; 
        <input type="hidden" name="<%=frmDataTabungan.fieldNames[frmDataTabungan.FRM_FIELD_ID_JENIS_SIMPANAN]%>" value="<%="" + dataTabungan.getIdJenisSimpanan()%>" > ---%>
        <%--
    </td>
    <td>&nbsp;</td>
    <td>PPH</td>
    <td>:</td>
    <td>
        <%-- <input class="formElemen"  type="text" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_PROVISI]%>" value="<%=//"" + jenisSimpanan.getProvisi()%>" size="40">--%>
        <%--
    </td>
    <td>&nbsp;</td>
</tr>
<tr>
    <td height="30">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Bunga</td>
    <td>:</td>
    <td>
        <%-- <input class="formElemen"  type="text" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_BUNGA]%>" value="<%=//"" + jenisSimpanan.getBunga()%>" size="40"> --%>
        <%--
    </td>
    <td>&nbsp;</td>
</tr>
<tr height="30">
    <td>&nbsp;</td>
    <td>Saldo Saat Ini</td>
    <td>:</td>
    <td>

                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>Biaya Admin</td>
                                                                                                                                            <td>:</td>
                                                                                                                                            <td>
        <%--<input type="text" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_BIAYA_ADMIN]%>" value="<%=//jenisSimpanan.getBiayaAdmin()%>" class="formElemen" maxlength="20" size="40">--%>
        <%--
    </td>
    <td>&nbsp;</td>
</tr>
<tr>
    <td>&nbsp;</td>
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
    <td> <%--
        ctrLine.setLocationImg(approot + "/image/ctr_line"); 
        ctrLine.initDefault();
        ctrLine.setTableWidth("100%");
        String scomDel = "javascript:cmdAsk('" + datatabunganOID+ "')";
        String sconDelCom = "javascript:cmdConfirmDelete('" + datatabunganOID + "')";
        String scancel = "javascript:cmdEdit('" + datatabunganOID + "')";
        
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
        --%><%-- <%= ctrLine.draw(iCommand, iErrCode, errMsg)%> 
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
