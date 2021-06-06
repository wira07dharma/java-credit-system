<%-- 
    Document   : editpinjaman
    Created on : Mar 23, 2013, 12:40:15 PM
    Author     : dw1p4
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
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*"%>
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
        {"Tanggal Pengajuan",//0
            "Tanggal Lunas",//1
            "No Anggota",//2
            "Nama",//3
            "No Rekening",//4
            "Kelompok",//5
            "Jumlah Pinjaman",//6
            "Jangka Waktu",//7
            "Jatuh Tempo (Kontrak)",//8
            "Biaya Admin",//9
            "Bunga",//10
            "Denda",//11
            "Alamat",//12
            "Jenis Kredit"},//13

        {"Reg Date",//0
            "Date Paid",//1
            "Member Id",//2
            "Name",//3
            "Account Number",//4
            "Club",//5
            "Loan Amount",//6
            "Period",//7
            "Maturity Date",//8
            "Admin Cost",//9
            "Interest",//10
            "Pinalty",//11
            "Address",//12
            "Type Kredit"},//13
    };
    public static final String tabTitle[][] = {
        {"Peminjaman", "Angsuran"}, {"Loan", "Installment Payment"}
    };
    public static final String systemTitle[] = {
        "Pinjaman", "Loan"
    };
    public static final String userTitle[][] = {
        {"Tambah", "Edit"}, {"Add", "Edit"}
    };
%>

<%
    CtrlPinjaman ctrlPinjaman = new CtrlPinjaman(request);

    long oidPinjaman = FRMQueryString.requestLong(request, "" + FrmPinjaman.fieldNames[FrmPinjaman.FRM_PINJAMAN_ID]);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.ERR_NONE;
    if (oidPinjaman != 0 && iCommand == Command.NONE) {
        iCommand = Command.EDIT;
    } else {
        iCommand = FRMQueryString.requestCommand(request);
    }

    String errMsg = "";
    String whereClause = "";
    String orderClause = "";
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

    ctrlPinjaman.setLanguage(SESS_LANGUAGE);
    iErrCode = ctrlPinjaman.action(iCommand, oidPinjaman);
    errMsg = ctrlPinjaman.getMessage();
    FrmPinjaman frmPinjaman = ctrlPinjaman.getForm();
    Pinjaman pinjaman = ctrlPinjaman.getPinjaman();

//	if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmAnggota.errorSize()<1)){
    if (iCommand == Command.DELETE) {
%>
<jsp:forward page="listpinjaman.jsp">
    <jsp:param name="prev_command" value="<%=prevCommand%>" />
    <jsp:param name="start" value="<%=start%>" />
    <jsp:param name="FRM_PINJAMAN_ID" value="<%=pinjaman.getOID()%>" />
</jsp:forward>
<%
    }
%>

<!-- End of Jsp Block -->
<html>
    <!-- #BeginTemplate "/Templates/maintab.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>Koperasi - Pinjaman</title>
        <script type="text/javascript">
            
            function updatAnggota(frmID){
                oidAnggota    = document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["<%=frmPinjaman.fieldNames[frmPinjaman.FRM_ANGGOTA_ID]%>"].value; 
                window.open("<%=approot%>/masterdata/transaksi/select_anggota.jsp?formName=<%=frmPinjaman.FRM_PINJAMAN%>&frmFieldIdAnggotaName="+frmID+"&<%=frmPinjaman.fieldNames[frmPinjaman.FRM_PINJAMAN_ID]%>=<%=String.valueOf(oidPinjaman)%>"+
                    "<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ID_ANGGOTA]%>="+oidAnggota+"",                                                
                null, "height=430, width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function updatKredit(){
                oidKredit    = document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["<%=frmPinjaman.fieldNames[frmPinjaman.FRM_TIPE_KREDIT_ID]%>"].value; 
                window.open("<%=approot%>/masterdata/transaksi/select_kredit.jsp?formName=<%=frmPinjaman.FRM_PINJAMAN%>&<%=frmPinjaman.fieldNames[frmPinjaman.FRM_PINJAMAN_ID]%>=<%=String.valueOf(oidPinjaman)%>"+
                    "<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TYPE_KREDIT_ID]%>="+oidKredit+"",                                                
                null, "height=430, width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdAdd(){
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["command"].value="<%=Command.ADD%>";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].action="editpinjaman.jsp";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["<%=frmPinjaman.fieldNames[frmPinjaman.FRM_PINJAMAN_ID]%>"].value=0;
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].submit();
            }
            
            function cmdCancel(){
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["command"].value="<%=Command.CANCEL%>";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].action="editpinjaman.jsp";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].submit();
            }

            function cmdEdit(oid){
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["command"].value="<%=Command.EDIT%>";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].action="editpinjaman.jsp";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].submit();
            }
            
            function cmdSave(){
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["command"].value="<%=Command.SAVE%>";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].action="editpinjaman.jsp";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].submit();
            }
            
            function cmdAsk(oid){
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["command"].value="<%=Command.ASK%>";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].action="editpinjaman.jsp";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].submit();
            }
            
            function cmdConfirmDelete(oid){
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["command"].value="<%=Command.DELETE%>";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].action="editpinjaman.jsp";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].submit();
            }
            
            function cmdBack(){
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"]["command"].value="<%=Command.FIRST%>";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].action="listpinjaman.jsp";
                document.forms["<%=frmPinjaman.FRM_PINJAMAN%>"].submit();
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
                Jenis Kredit
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Transaksi</li>
                <li class="active">Kredit</li>
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
                        <form class="form-horizontal" name="<%=frmPinjaman.FRM_PINJAMAN%>" method="post" action="">
                            <input type="hidden" name="start" value="<%=start%>">
                            <input type="hidden" name="command" value="<%=iCommand%>">
                            <input type="hidden" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_PINJAMAN_ID]%>" value="<%=pinjaman.getOID()%>">
                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                            <div class="box-body">
                                <%
                                    Anggota anggota2 = new Anggota();
                                    if (pinjaman.getAnggotaId() != 0) {
                                        try {
                                            anggota2 = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                                        } catch (Exception e) {
                                            anggota2 = new Anggota();
                                        }
                                    }
                                %>
                                <div class="form-group">
                                    <div class="col-sm-5"></div>
                                    <div class="col-sm-7">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][0]%></label>                                    
                                        <div class="col-sm-8">
                                            <h5><%=Formater.formatDate(pinjaman.getTanggalPengajuan(), "MMM, dd yyyy hh:mm")%></h5>
                                        </div>
                                    </div>
                                </div>
                                        
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][2]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="text" readonly class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][2]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]%>" value="<%=anggota2.getNoAnggota()%>" onClick="javascript:updatAnggota('<%=frmPinjaman.fieldNames[frmPinjaman.FRM_ANGGOTA_ID]%>')">
                                            <input class="formElemen" type="hidden" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_ANGGOTA_ID]%>" value="<%="" + pinjaman.getAnggotaId()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][3]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][3]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>" value="<%="" + anggota2.getName()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][4]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][4]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_REKENING]%>" value="<%="" + anggota2.getNoRekening()%>">
                                        </div>
                                    </div>                                    
                                </div>

                                <div class="col-sm-6">                                                                            
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][1]%></label>                                    
                                        <div class="col-sm-9">
                                            <%
                                                String tanggalLunas = "" + pinjaman.getTanggalLunas();
                                                if (tanggalLunas.equals("null")) {
                                                    tanggalLunas = "";
                                                }
                                            %>
                                            <input type="text" required class="form-control datetime-picker" data-date-format="yyyy-mm-dd" placeholder="<%=strTitle[SESS_LANGUAGE][1]%>" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_TGL_LUNAS]%>" value="<%=tanggalLunas%>">
                                        </div>
                                    </div>      

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][12]%></label>                                    
                                        <div class="col-sm-9">
                                            <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][12]%>" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PERMANENT]%>" value="<%="" + anggota2.getAddressPermanent()%>">
                                        </div>
                                    </div> 
                                    <%--        
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][5]%></label>                                    
                                        <div class="col-sm-9">
                                            <%
                                                ControlCombo comboBox2 = new ControlCombo();
                                                int countKelompok2 = PstKelompokKoperasi.getCount("");
                                                Vector listKelompok2 = PstKelompokKoperasi.list(0, countKelompok2, "", PstKelompokKoperasi.fieldNames[PstKelompokKoperasi.FLD_NAMA_KELOMPOK]);
                                                Vector kelompokKey2 = new Vector(1, 1);
                                                Vector kelompokValue2 = new Vector(1, 1);

                                                for (int i = 0; i < listKelompok2.size(); i++) {
                                                    KelompokKoperasi kelompokKoperasi = (KelompokKoperasi) listKelompok2.get(i);
                                                    kelompokKey2.add(kelompokKoperasi.getNamaKelompok());
                                                    kelompokValue2.add(String.valueOf(kelompokKoperasi.getOID()).toString());
                                                }
                                            %>
                                            <%=comboBox2.draw(frmPinjaman.fieldNames[frmPinjaman.FRM_KELOMPOK_ID], "form-control", "select...", "" + pinjaman.getKelompokId(), kelompokValue2, kelompokKey2)%> 
                                        </div>
                                    </div>
                                    --%>
                                </div>

                                <div class="col-sm-12" style="background-color: rgba(144, 238, 144, 0.7); padding-top: 15px; padding-left: 0px;padding-right: 0px">

                                    <div class="col-sm-6">
                                        
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][13]%></label>                                    
                                            <div class="col-sm-9">
                                                <%
                                                    long idTypeKredit = pinjaman.getTipeKreditId();
                                                    JenisKredit jenisKredit = new JenisKredit();
                                                    String nameJenis="";
                                                    if(idTypeKredit!=0){
                                                        jenisKredit = PstJenisKredit.fetch(idTypeKredit);
                                                        nameJenis = jenisKredit.getJangkaWaktuMin() +" s/d "+jenisKredit.getJangkaWaktuMax();
                                                    }else{
                                                        nameJenis="";
                                                    }
                                                %>
                                                <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][13]%>" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_TIPE_KREDIT_NAME]%>" value="<%=nameJenis%>"  onClick="javascript:updatKredit()">
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][7]%></label>                                    
                                            <div class="col-sm-9">
                                                <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][7]%>" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_JANGKA_WAKTU]%>" value="<%=pinjaman.getJangkaWaktu()%>">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][8]%></label>                                    
                                            <div class="col-sm-9">
                                                <%
                                                    String jatuhTempo = "" + pinjaman.getJatuhTempo();
                                                    if (jatuhTempo.equals("null")) {
                                                        jatuhTempo = "";
                                                    }
                                                %>
                                                <input type="text" required class="form-control datetime-picker" data-date-format="yyyy-mm-dd" placeholder="<%=strTitle[SESS_LANGUAGE][8]%>" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_JATUH_TEMPO]%>" value="<%=jatuhTempo%>">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][6]%></label>                                    
                                            <div class="col-sm-9">
                                                <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][6]%>" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_JUMLAH_PINJAMAN]%>" value="<%=Formater.formatNumber(pinjaman.getJumlahPinjaman(), "#.##")%>">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-6">
                                        
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"></label>                                    
                                            <div class="col-sm-9">
                                                <br><br>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][9]%></label>                                    
                                            <div class="col-sm-9">
                                                <%
                                                    JenisKredit kredit2 = new JenisKredit();
                                                    if (pinjaman.getTipeKreditId() != 0) {
                                                        try {
                                                            kredit2 = PstJenisKredit.fetch(pinjaman.getTipeKreditId());
                                                        } catch (Exception e) {
                                                            kredit2 = new JenisKredit();
                                                        }
                                                    }
                                                %>
                                                <input type="text" readonly class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][9]%>" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_BIAYA_ADMIN]%>" value="<%=Formater.formatNumber(kredit2.getBiayaAdmin(), "#.##")%>">
                                                <input type="hidden" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_TIPE_KREDIT_ID]%>" value="<%="" + pinjaman.getTipeKreditId()%>" >                                                
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][10]%></label>                                    
                                            <div class="col-sm-9">
                                                <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][10]%>" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_BUNGA_MIN]%>" value="<%=Formater.formatNumber(kredit2.getBungaMin(), "#.##")%>">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"><%=strTitle[SESS_LANGUAGE][11]%></label>                                    
                                            <div class="col-sm-9">
                                                <input type="text" required class="form-control" placeholder="<%=strTitle[SESS_LANGUAGE][11]%>" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_DENDA]%>" value="<%=Formater.formatNumber(kredit2.getDenda(), "#.##")%>">
                                            </div>
                                        </div>
                                    </div>

                                </div>  

                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <%
                                    ctrLine.setLocationImg(approot + "/image/ctr_line");
                                    ctrLine.initDefault();
                                    ctrLine.setTableWidth("100%");
                                    String scomDel2 = "javascript:cmdAsk('" + oidPinjaman + "')";
                                    String sconDelCom2 = "javascript:cmdConfirmDelete('" + oidPinjaman + "')";
                                    String scancel2 = "javascript:cmdEdit('" + oidPinjaman + "')";

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
                        if (oidPinjaman != 0) {
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
                                                                                <form name="<%=frmPinjaman.FRM_PINJAMAN%>" method="post" action="">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_PINJAMAN_ID]%>" value="<%=pinjaman.getOID()%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <% if (oidPinjaman != 0 || (pinjaman.getOID() != 0 && iErrCode == Command.NONE && iCommand == Command.SAVE)) {
                                                                                                oidPinjaman = pinjaman.getOID();
                                                                                        %>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <br>
                                                                                                <table width="98%" align="center" border="0" cellspacing="2" cellpadding="2" height="26">
                                                                                                    <tr>
                                                                                                        <%-- TAB MENU --%>
                                                                                                        <%-- active tab --%>
                                                                                                        <%--
                                                                                                        <td width="11%" nowrap bgcolor="#66CCFF">
                                                                                                            <!-- Data Pinjaman -->
                                                                                                            <div align="center" class="tablink">
                                                                                                                <span class="tablink"><%=tabTitle[SESS_LANGUAGE][0]%></span>
                                                                                                            </div>
                                                                                                        </td>

                                                                                                        <td width="11%" nowrap bgcolor="#0066CC">
                                                                                                            <!-- Data Angsuran-->
                                                                                                            <div align="center"  class="tablink">
                                                                                                                <a href="angsuran_pinjaman.jsp?<%=frmPinjaman.fieldNames[frmPinjaman.FRM_PINJAMAN_ID]%>=<%=oidPinjaman%>" class="tablink"><%=tabTitle[SESS_LANGUAGE][1]%></a>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <%-- END TAB MENU --%> <%--
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
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
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="15%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="25%">&nbsp;</td>
                                                                                                                                <td scope="col" width="5%">&nbsp;</td>
                                                                                                                                <td scope="col" width="15%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="25%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--no anggota-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][0]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <%=Formater.formatDate(pinjaman.getTanggalPengajuan(), "MMM, dd yyyy hh:mm")%>                                                                                                                                  
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td class="comment"><em>*) entry required</em></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][1]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <%=ControlDate.drawDate(frmPinjaman.fieldNames[frmPinjaman.FRM_TGL_LUNAS], pinjaman.getTanggalLunas(), "formElemen", 10, -20)%><%= frmPinjaman.getErrorMsg(frmPinjaman.FRM_TGL_LUNAS)%>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--nama anggota--->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][2]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <%
                                                                                                                                        Anggota anggota = new Anggota();
                                                                                                                                        if (pinjaman.getAnggotaId() != 0) {
                                                                                                                                            try {
                                                                                                                                                anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                                                                                                                                            } catch (Exception e) {
                                                                                                                                                anggota = new Anggota();
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                    <input class="formElemen" type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]%>" readonly="true" value="<%=anggota.getNoAnggota()%>" size="40" onClick="javascript:updatAnggota('<%=frmPinjaman.fieldNames[frmPinjaman.FRM_ANGGOTA_ID]%>')">*&nbsp;
                                                                                                                                    <input class="formElemen" type="hidden" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_ANGGOTA_ID]%>" value="<%="" + pinjaman.getAnggotaId()%>" size="40">
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][3]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <input class="formElemen"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>" value="<%="" + anggota.getName()%>" size="40">
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][12]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td><input class="formElemen"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PERMANENT]%>" value="<%="" + anggota.getAddressPermanent()%>" size="40"></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--alamat-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][4]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>
                                                                                                                                    <input class="formElemen"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_REKENING]%>" value="<%="" + anggota.getNoRekening()%>" size="40">
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                </td>
                                                                                                                                <!--status-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][5]%></td>
                                                                                                                                <td>:</td>  
                                                                                                                                <td valign="top">
                                                                                                                                    <%
                                                                                                                                        ControlCombo comboBox = new ControlCombo();
                                                                                                                                        int countKelompok = PstKelompokKoperasi.getCount("");
                                                                                                                                        Vector listKelompok = PstKelompokKoperasi.list(0, countKelompok, "", PstKelompokKoperasi.fieldNames[PstKelompokKoperasi.FLD_NAMA_KELOMPOK]);
                                                                                                                                        Vector kelompokKey = new Vector(1, 1);
                                                                                                                                        Vector kelompokValue = new Vector(1, 1);

                                                                                                                                        for (int i = 0; i < listKelompok.size(); i++) {
                                                                                                                                            KelompokKoperasi kelompokKoperasi = (KelompokKoperasi) listKelompok.get(i);
                                                                                                                                            kelompokKey.add(kelompokKoperasi.getNamaKelompok());
                                                                                                                                            kelompokValue.add(String.valueOf(kelompokKoperasi.getOID()).toString());
                                                                                                                                        }
                                                                                                                                    %>
                                                                                                                                    <%=comboBox.draw(frmPinjaman.fieldNames[frmPinjaman.FRM_KELOMPOK_ID], "formElemen", "select...", "" + pinjaman.getKelompokId(), kelompokValue, kelompokKey)%> 
                                                                                                                                    &nbsp;<%= frmPinjaman.getErrorMsg(frmPinjaman.FRM_KELOMPOK_ID)%>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
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
                                                                                                                                            <td><%=strTitle[SESS_LANGUAGE][7]%></td>
                                                                                                                                            <td>:</td>
                                                                                                                                            <td>
                                                                                                                                                <input type="text" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_JANGKA_WAKTU]%>" value="<%=pinjaman.getJangkaWaktu()%>" class="formElemen" size="30">
                                                                                                                                                <%=SESS_LANGUAGE != 0 ? "Moon" : "Bulan"%> &nbsp;<%= frmPinjaman.getErrorMsg(frmPinjaman.FRM_JANGKA_WAKTU)%>
                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td><%=strTitle[SESS_LANGUAGE][9]%></td>
                                                                                                                                            <td>:</td>
                                                                                                                                            <td>
                                                                                                                                                <%
                                                                                                                                                    JenisKredit kredit = new JenisKredit();
                                                                                                                                                    if (pinjaman.getTipeKreditId() != 0) {
                                                                                                                                                        try {
                                                                                                                                                            kredit = PstJenisKredit.fetch(pinjaman.getTipeKreditId());
                                                                                                                                                        } catch (Exception e) {
                                                                                                                                                            kredit = new JenisKredit();
                                                                                                                                                        }
                                                                                                                                                    }
                                                                                                                                                %>

                                                                                                                                                <input class="formElemen"  type="text" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_BIAYA_ADMIN]%>" readonly="true" value="<%=Formater.formatNumber(kredit.getBiayaAdmin(), "#.##")%>" size="40" onClick="javascript:updatKredit()">*&nbsp;
                                                                                                                                                <input type="hidden" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_TIPE_KREDIT_ID]%>" value="<%="" + pinjaman.getTipeKreditId()%>" >
                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="30">&nbsp;</td>
                                                                                                                                            <td><%=strTitle[SESS_LANGUAGE][8]%></td>
                                                                                                                                            <td>:</td>
                                                                                                                                            <td>
                                                                                                                                                <%=ControlDate.drawDate(frmPinjaman.fieldNames[frmPinjaman.FRM_JATUH_TEMPO], pinjaman.getJatuhTempo(), "formElemen", 10, -20)%> * 
                                                                                                                                                <%= frmPinjaman.getErrorMsg(frmPinjaman.FRM_JATUH_TEMPO)%>
                                                                                                                                            </td>
                                                                                                                                            <td></td>
                                                                                                                                            <td><%=strTitle[SESS_LANGUAGE][10]%></td>
                                                                                                                                            <td>:</td>
                                                                                                                                            <td>
                                                                                                                                                <input class="formElemen"  type="text" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_BUNGA_MIN]%>" value="<%=Formater.formatNumber(kredit.getBungaMin(), "#.##")%>" size="40">
                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="30">
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td><%=strTitle[SESS_LANGUAGE][6]%></td>
                                                                                                                                            <td>:</td>
                                                                                                                                            <td>
                                                                                                                                                <input type="text" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_JUMLAH_PINJAMAN]%>" value="<%=Formater.formatNumber(pinjaman.getJumlahPinjaman(), "#.##")%>" class="formElemen" size="30">
                                                                                                                                                * <%= frmPinjaman.getErrorMsg(frmPinjaman.FRM_JUMLAH_PINJAMAN)%>
                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td><%=strTitle[SESS_LANGUAGE][11]%></td>
                                                                                                                                            <td>:</td>
                                                                                                                                            <td>
                                                                                                                                                <input class="formElemen"  type="text" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_DENDA]%>" value="<%=Formater.formatNumber(kredit.getDenda(), "#.##")%>" size="40">
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
                                                                                                                                            <td> <%

                                                                                                                                                ctrLine.setLocationImg(approot + "/image/ctr_line");
                                                                                                                                                ctrLine.initDefault();
                                                                                                                                                ctrLine.setTableWidth("100%");
                                                                                                                                                String scomDel = "javascript:cmdAsk('" + oidPinjaman + "')";
                                                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidPinjaman + "')";
                                                                                                                                                String scancel = "javascript:cmdEdit('" + oidPinjaman + "')";

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
                                                                                                                                <td height="40">&nbsp;</td>
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
                                                                                                                                            --%>
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
    </body>
    <!-- #BeginEditable "script" -->
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>
