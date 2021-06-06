
<%@page import="com.dimata.sedana.ajax.transaksi.AjaxSetoran"%>
<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstAssignPenarikanTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.AssignPenarikanTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.AssignContact"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmAssignContact"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlAssignContact"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstAssignContact"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="javax.print.DocFlavor.STRING"%>
<%@page language = "java" %>
<!-- package java -->
<%@page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package aiso -->
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.region.*" %>
<%@page import="com.dimata.aiso.form.masterdata.region.*" %>
<%@page import="com.dimata.sedana.form.assigntabungan.CtrlAssignTabungan" %>
<%@page import="com.dimata.sedana.form.assigntabungan.FrmAssignTabungan" %>
<%@page import="com.dimata.sedana.entity.assigntabungan.AssignTabungan" %>
<%@page import="com.dimata.sedana.entity.assigntabungan.PstAssignTabungan" %>

<%@include file="../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%!
    public static String strTitle[][] = {
        {"No Anggota",//0
            "Nama",//1
            "Jenis Kelamin",//2
            "Tempat Lahir",//3
            "Tanggal Lahir",//4
            "Pekerjaan",//5
            "Agensi",//6
            "Alamat Kantor",//7
            "Kota Alamat Kantor",//8
            "Posisi",//9
            "Alamat Asal",//10
            "Kota Asal",//11
            "Propinsi Asal",//12
            "Kabupaten Asal",//13
            "Kecamatan Asal",//14
            "Kelurahan",//15
            "Id Identitas KTP/SIM",//16
            "Masa Brlaku KTP",//17
            "Telepon",//18
            "Hand Phone",//19
            "Email",//20
            "Pendidikan",//21
            "No NPWP",//22
            "Status",//23
            "Nomor Rekening",//24
            "Tanggal Regristrasi"},//25
        {"Member ID",//0
            "Name",//1
            "Sex",//2
            "Birth of Place",//3
            "Birth of Date",//4
            "Vocation",//5
            "Agencies",//6
            "Office Address",//7
            "Address Office City",//8
            "Position",//9
            "Address",//10
            "City",//11
            "Province",//12
            "Regency",//13
            "Sub Regency",//14
            "Ward",//15
            "ID Card",//16
            "Expired Date KTP",//17
            "Telephone",//18
            "Hand Phone",//19
            "Email",//20
            "Education",//21
            "No NPWP",//22
            "Status",//23
            "Rekening Number",//24
            "Regristation Date"}//25
    };

    public static final String systemTitle[] = {
        "Tabungan", "Saving"
    };

    public static final String userTitle[][] = {
        {"Tambah", "Edit"}, {"Add", "Edit"}
    };

    public static final String titleTabel[][] = {
        {"No", "Nama Tabungan", "Jenis Item", "Tidak ada data tabungan", "No Tabungan", "Transaksi Terakhir"},
        {"No", "Nama Tabungan", "Jenis Item", "No data found", "No Tabungan", "Last Deposit"}
    };

%>

<%!
    public String getNamaTabunganAlokasiBunga(long idSimpanan) {
        String namaTabunganAlokasiBunga = "";
        try {
            DataTabungan dt = PstDataTabungan.fetchExc(idSimpanan);
            long idAlokasiBunga = (dt.getIdAlokasiBunga() == 0) ? dt.getOID() : dt.getIdAlokasiBunga();
            DataTabungan dtAlokasi = PstDataTabungan.fetchExc(idAlokasiBunga);
            String noTabunganAlokasi = PstAssignContact.fetchExc(dtAlokasi.getAssignTabunganId()).getNoTabungan();
            String namaSimpananAlokasi = PstJenisSimpanan.fetchExc(dtAlokasi.getIdJenisSimpanan()).getNamaSimpanan();
            namaTabunganAlokasiBunga = noTabunganAlokasi + " (" + namaSimpananAlokasi + ")";
        } catch (Exception e) {
            namaTabunganAlokasiBunga = e.getMessage();
        }
        return namaTabunganAlokasiBunga;
    }
%>

<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
    boolean privPrint = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
    int vectSize = 0;
    long oidAssignContact = FRMQueryString.requestLong(request, "hidden_masterTabungan_id");

    String tabTitle[][] = {
        {"Data Pribadi", "Anggota Keluarga", "Registrasi Tabungan", "Pendidikan", "Data Tabungan", "Dokumen Bersangkutan"}, 
        {"Personal Date", "Family Member", "Saving Registration", "Education", "Saving Type", "Relevant Document"}
    };

    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = systemTitle[SESS_LANGUAGE];
    String strAddMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " and all related transactions" : " dan seluruh transaksi yang berkaitan") + "?";
    
    long oidAnggota = FRMQueryString.requestLong(request, "anggota_oid");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    String idSimpananAll[] = FRMQueryString.requestStringValues(request, "FRM_ID_SIMPANAN_ALL");
    String idSimpananAlokasi[] = FRMQueryString.requestStringValues(request, "FRM_ID_SIMPANAN_ALOKASI");
    String tanggalTutup[] = FRMQueryString.requestStringValues(request, "FRM_TANGGAL_TUTUP");

    int iErrCode = FRMMessage.ERR_NONE;
    String errMsg = "";
    String whereClause = PstAssignContact.fieldNames[PstAssignContact.FLD_CONTACT_ID] + "=" + oidAnggota;
    String orderClause = "";
    int recordToGet = 10;
    int start = FRMQueryString.requestInt(request, "start");

    //untuk tab edit Personal data oleh hadi tanggal 2 Maret 2013
    int iCommand = FRMQueryString.requestCommand(request);
    if (oidAnggota != 0 && iCommand == Command.NONE) {
        //iCommand = Command.EDIT;
    } else {
        iCommand = FRMQueryString.requestCommand(request);
    }

    String keyword = request.getParameter("keyword");
// variable declaration
    boolean privManageData = true;
    String msgString = "";
    if (keyword == null) {
        keyword = "";
    }

    /**
     * ControlLine and Commands caption
     */
    ctrLine.setLanguage(SESS_LANGUAGE);
    CtrlAssignContact ctrlAssignContact = new CtrlAssignContact(request);
    iErrCode = ctrlAssignContact.action(iCommand, oidAssignContact);
    FrmAssignContact frmAssignContact = ctrlAssignContact.getForm();
    AssignContact assign = ctrlAssignContact.getAssignContact();
    
    int penarikan = PstAssignPenarikanTabungan.list(0, 0, PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID] + " = " + assign.getMasterTabunganId(), null).size();
    int bulanPeriodeDeposito = SessReportTabungan.getPeriodeBulanDeposito(assign.getOID());
    
    if (iCommand == Command.SAVE && assign.getOID() != 0) {
        iErrCode = ctrlAssignContact.actionSetAlokasiBunga(idSimpananAll, idSimpananAlokasi);
        if (penarikan > 0) {
            iErrCode = ctrlAssignContact.actionSetTanggalTutup(idSimpananAll, tanggalTutup);
        }
    }
    msgString = ctrlAssignContact.getMessage();

    Vector listAssignContact = new Vector(1, 1);
    vectSize = PstAssignContact.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlAssignContact.actionList(iCommand, start, vectSize, recordToGet);
    }

    listAssignContact = PstAssignContact.list(start, recordToGet, whereClause, orderClause);
    if (listAssignContact.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listAssignContact = PstAssignContact.list(start, recordToGet, whereClause, orderClause);
    }

    String kodeNasabah = "";
    Anggota a = new Anggota();
    if (oidAnggota != 0) {
        try {
            a = PstAnggota.fetchExc(oidAnggota);
            kodeNasabah = a.getNoAnggota();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    int jumlahSemuaSimpanan = PstDataTabungan.getCount(PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA] + " = " + oidAnggota);
    int jumlahSimpananTerdeteksi = 0;

%>

<%  ctrlAssignContact.setLanguage(SESS_LANGUAGE);
    //iErrCode = ctrlAssignContact.action(iCommand, oidAssignContact);

    errMsg = ctrlAssignContact.getMessage();
//	if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmAnggota.errorSize()<1)){
%>

<!-- End of Jsp Block -->
<html>
    <!-- #BeginTemplate "/Templates/maintab.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>Koperasi - Anggota</title>
        <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <script language="JavaScript">

            function cmdAdd(oid) {
                document.frmAnggota.command.value = "<%=Command.ADD%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + oid;
                document.frmAnggota.anggota_oid.value = oid;
                document.frmAnggota.keluarga_oid.value = 0;
                document.frmAnggota.submit();
            }

            function cmdCancel() {
                document.frmAnggota.command.value = "<%=Command.CANCEL%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
                document.frmAnggota.submit();
            }

            function cmdEdit(idKeluarga, idAnggota, idRelasi) {
                document.frmAnggota.command.value = "<%=Command.EDIT%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + idAnggota;
                document.frmAnggota.anggota_oid.value = idAnggota;
                document.frmAnggota.keluarga_oid.value = idKeluarga;
                document.frmAnggota.relasi_oid.value = idRelasi;
                document.frmAnggota.submit();
            }

            function cmdSave() {
                document.frmAnggota.command.value = "<%=Command.SAVE%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
                document.frmAnggota.submit();
            }

            function cmdAsk(oid) {
                document.frmAnggota.command.value = "<%=Command.ASK%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
                document.frmAnggota.submit();
            }

            function cmdConfirmDelete(oid) {
                document.frmAnggota.command.value = "<%=Command.DELETE%>";
                document.frmAnggota.action = "anggota_tabungan.jsp?hidden_masterTabungan_id=" + "<%=oidAnggota%>";
                document.frmAnggota.submit();
            }

            function cmdBack() {
                document.frmAnggota.command.value = "<%=Command.FIRST%>";
                document.frmAnggota.action = "anggota_family.jsp?anggota_oid=" + "<%=oidAnggota%>";
                document.frmAnggota.submit();
            }

        </script>

        <script>
            $(document).ready(function () {
                $('.jenisTabungan').change(function () {
                    var selectedText = $(".jenisTabungan option:selected").data('kode');
                    $(".autoNoTab").val(selectedText + "-<%=kodeNasabah%>");
                });
                
                $('.date-picker').datetimepicker({
                    weekStart: 1,
                    format: "yyyy-mm-dd",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2 // No time
                            // showMeridian: 0
                });
                
                $('.add-setoran').click(function(){
                    var act = $(this).data('act');
                    var notab = $(this).data('notab');
                    
                    $('#form_setoran #<%=AjaxSetoran.FRM_FIELD_ASSIGN_CONTACT_TABUNGAN_ID%>').val(act);
                    $('#form_setoran #<%=AjaxSetoran.FRM_FIELD_NO_TABUNGAN%>').val(notab);
                    $('#form_setoran').submit();
                });
            });

        </script>

        <!-- #EndEditable -->
        <%@ include file = "/style/lte_head.jsp" %>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <!--link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css"-->
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
        <SCRIPT language=JavaScript>

            function MM_preloadImages() { //v3.0
                var d = document;
                if (d.images) {
                    if (!d.MM_p)
                        d.MM_p = new Array();
                    var i, j = d.MM_p.length, a = MM_preloadImages.arguments;
                    for (i = 0; i < a.length; i++)
                        if (a[i].indexOf("#") != 0) {
                            d.MM_p[j] = new Image;
                            d.MM_p[j++].src = a[i];
                        }
                }
            }

            function MM_findObj(n, d) { //v4.0
                var p, i, x;
                if (!d)
                    d = document;
                if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
                    d = parent.frames[n.substring(p + 1)].document;
                    n = n.substring(0, p);
                }
                if (!(x = d[n]) && d.all)
                    x = d.all[n];
                for (i = 0; !x && i < d.forms.length; i++)
                    x = d.forms[i][n];
                for (i = 0; !x && d.layers && i < d.layers.length; i++)
                    x = MM_findObj(n, d.layers[i].document);
                if (!x && document.getElementById)
                    x = document.getElementById(n);
                return x;
            }

            function MM_swapImage() { //v3.0
                var i, j = 0, x, a = MM_swapImage.arguments;
                document.MM_sr = new Array;
                for (i = 0; i < (a.length - 2); i += 3)
                    if ((x = MM_findObj(a[i])) != null) {
                        document.MM_sr[j++] = x;
                        if (!x.oSrc)
                            x.oSrc = x.src;
                        x.src = a[i + 2];
                    }
            }

        </SCRIPT>
        <script language="JavaScript">
            function cmdAdd() {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.hidden_masterTabungan_id.value = "0";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.ADD%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdAsk(oidAssignContact) {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.hidden_masterTabungan_id.value = oidAssignContact;
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.ASK%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdConfirmDelete(oidAssignContact) {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.hidden_masterTabungan_id.value = oidAssignContact;
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.DELETE%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdSave() {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.SAVE%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdEdit(oidAssignContact) {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.hidden_masterTabungan_id.value = oidAssignContact;
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdCancel(oidAssignContact) {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.hidden_masterTabungan_id.value = oidAssignContact;
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdBack() {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.BACK%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdListFirst() {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.FIRST%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=Command.FIRST%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdListPrev() {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.PREV%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=Command.PREV%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdListNext() {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.NEXT%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=Command.NEXT%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }

            function cmdListLast() {
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.command.value = "<%=Command.LAST%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.prev_command.value = "<%=Command.LAST%>";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.action = "anggota_tabungan.jsp";
                document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.submit();
            }
        </script>
        <!-- #EndEditable -->
        <style>
            .tabel_info_anggota {width: 50%}
            .tabel_info_anggota td {padding: 5px; vertical-align: text-top}
            
            #tabel_tab_menu {width: 100%; border-collapse: collapse}
            #tabel_tab_menu {border-color: transparent}
            #tabel_tab_menu a {color: black}
            #tabel_tab_menu td {background-color: lightgray; border-color: #eaf3df; text-decoration: none;}
            
            .row-edit td {background-color: papayawhip}
        </style>
    </head>
    <body style="background-color: #eaf3df;">

        <section class="content-header">
            <h1><%=namaNasabah %> Individu <small></small></h1>
            <ol class="breadcrumb">
                <li><i class="fa fa-dashboard"></i> Home</li>
                <li>Master Bumdesa</li>
                <li><%=namaNasabah %> Individu</li>
            </ol>
        </section>

        <section class="content">
            
            <table id="tabel_tab_menu" border="1">
                <tr style="height: 35px;">
                    <td width="20%">
                        <!-- Data Personal -->
                        <div align="center">
                            <a href="anggota_edit.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][0]%></a>
                        </div>
                    </td>                                                                                                        
                    <td width="20%">
                        <!-- Pendidikan-->
                        <div align="center">
                            <a href="anggota_education.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][3]%></a>
                        </div>
                    </td>
                    <td width="20%">
                        <!-- Keluarga Anggota-->
                        <div align="center">
                            <a href="anggota_family.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][1]%></a>
                        </div>
                    </td>
                    <td width="20%" style="background-color: #337ab7;">
                        <!-- Data Tabungan-->
                        <div align="center">
                            <a href="anggota_tabungan.jsp?anggota_oid=<%=oidAnggota%>" style="color: white"><%=tabTitle[SESS_LANGUAGE][4]%></a>
                        </div>
                    </td>
                    <td width="20%">
                        <!-- Dokumen Bersangkutan-->
                        <div align="center">
                            <a href="anggota_dokumen.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][5]%></a>
                        </div>
                    </td>
                </tr>
            </table>
 
            <form name="<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>"> 
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                <input type="hidden" name="hidden_masterTabungan_id" value="<%=oidAssignContact%>">
                <input type="hidden" name="anggota_oid" value="<%=oidAnggota%>">
                
                <br>
                <table class="tabel_info_anggota">
                    <tr>
                        <td style="width: 50px">Nama</td>
                        <td>: <%= a.getName() %></td>
                    </tr>
                    <tr>
                        <td>Nomor</td>
                        <td>: <%= a.getNoAnggota() %></td>
                    </tr>
                </table>
                        
                <br>
                <table class="listgen" width="100%" cellspacing="1" border="0">
                    <tbody>
                        <tr>
                            <td class="listgentitle" width="1%"><%=titleTabel[SESS_LANGUAGE][0]%></td>
                            <td class="listgentitle" width=""><%=titleTabel[SESS_LANGUAGE][4]%></td>
                            <td class="listgentitle" width=""><%=titleTabel[SESS_LANGUAGE][1]%></td>
                            <td class="listgentitle" width=""><%=titleTabel[SESS_LANGUAGE][2]%></td>
                            <td class="listgentitle" width="">Alokasi Bunga</td>
                            <td class="listgentitle" width="">Tgl Buka Tabungan</td>
                            <td class="listgentitle" width=""><%=titleTabel[SESS_LANGUAGE][5]%></td>
                            <td class="listgentitle" width="">Tgl Tutup Tabungan</td>
                            <td class="listgentitle" width="">Status</td>
                        </tr>
                        <% if (listAssignContact.isEmpty()) { %>
                        <tr>
                            <td class="listgensell"></td>
                            <td class="listgensell" colspan="8">Tidak ada data tabungan</td>
                        </tr>
                        <% } %>
                        
                        <%
                            for (int i = 0; i < listAssignContact.size(); i++) {
                                AssignContact ac = (AssignContact) listAssignContact.get(i);
                                MasterTabungan mt = PstMasterTabungan.fetchExc(ac.getMasterTabunganId());
                                int jumlahPeriodePenarikan = PstAssignPenarikanTabungan.getCount(PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID] + " = " + mt.getOID());
                                String periodePenarikan = (jumlahPeriodePenarikan == 0) ? "" : "<br>(<a href='"+approot+"/masterdata/mastertabungan/master_tabungan.jsp?set_periode=1&hidden_masterTabungan_id="+mt.getOID()+"'>" + jumlahPeriodePenarikan + " periode penarikan</a>)";
                                
                                //GET DATA SIMPANAN (aiso_data_tabungan)
                                Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + ac.getOID(), PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL]);
                                jumlahSimpananTerdeteksi += listSimpanan.size();
                                JenisSimpanan js = new JenisSimpanan();
                                String namaSimpanan = "-";
                                String alokasiBunga = "-";
                                String tglBukaTab = "-";
                                String tglTutupTab = "-";
                                String statusSimpanan = "Tidak terdaftar";
                                //GET DATA SIMPANAN PERTAMA
                                if (!listSimpanan.isEmpty()) {
                                    js = PstJenisSimpanan.fetchExc(listSimpanan.get(0).getIdJenisSimpanan());
                                    namaSimpanan = js.getNamaSimpanan();
                                    alokasiBunga = getNamaTabunganAlokasiBunga(listSimpanan.get(0).getOID());
                                    statusSimpanan = (listSimpanan.get(0).getStatus() == 1) ? "Aktif" : "Tidak Aktif";
                                    tglBukaTab = (listSimpanan.get(0).getTanggal() == null) ? "-" : "" + Formater.formatDate(listSimpanan.get(0).getTanggal(), "yyyy-MM-dd HH:mm:ss");
                                    tglTutupTab = (listSimpanan.get(0).getTanggalTutup() == null) ? "-" : "" + Formater.formatDate(listSimpanan.get(0).getTanggalTutup(), "yyyy-MM-dd HH:mm:ss");
                                }
                        %>
                        <tr>
                            <td class="listgensell" rowspan="<%= listSimpanan.size() %>"><a href="javascript:cmdEdit('<%=String.valueOf(ac.getOID())%>')"><%= (i+1) %>.</a></td>
                            <td class="listgensell" rowspan="<%= listSimpanan.size() %>"><a href="javascript:cmdEdit('<%=String.valueOf(ac.getOID())%>')"><%= ac.getNoTabungan()%></a> <a class="add-setoran" title="Tambah setoran" style="float: right; cursor: pointer" data-act="<%=ac.getOID()%>" data-notab="<%=ac.getNoTabungan()%>"><i class="fa fa-plus-circle"></i></a></td>
                            <td class="listgensell" rowspan="<%= listSimpanan.size() %>"><%= mt.getNamaTabungan() + periodePenarikan%></td>
                            <!--data simpanan pertama-->
                            <td class="listgensell"><%= namaSimpanan %></td>
                            <td class="listgensell"><%= alokasiBunga %></td>
                            <td class="listgensell"><%= tglBukaTab %></td>
                            <td class="listgensell"><%= PstTransaksi.getLastTransactionDate(oidAnggota, ac.getOID(), js.getOID()) %></td>
                            <td class="listgensell"><%= tglTutupTab %></td>
                            <td class="listgensell"><%= statusSimpanan %></td>
                        </tr>
                        
                        <!-- GET SISA DATA SIMPANAN JIKA ADA -->
                        <%
                            for (int j = 1; j < listSimpanan.size(); j++) {
                                namaSimpanan = "-";
                                alokasiBunga = "-";
                                tglBukaTab = "-";
                                tglTutupTab = "-";
                                statusSimpanan = "Tidak terdaftar";
                                try {
                                    js = PstJenisSimpanan.fetchExc(listSimpanan.get(j).getIdJenisSimpanan());
                                    namaSimpanan = js.getNamaSimpanan();
                                    alokasiBunga = getNamaTabunganAlokasiBunga(listSimpanan.get(j).getOID());
                                    statusSimpanan = (listSimpanan.get(j).getStatus() == 1) ? "Aktif" : "Tidak Aktif";
                                    tglBukaTab = (listSimpanan.get(j).getTanggal() == null) ? "-" : "" + Formater.formatDate(listSimpanan.get(j).getTanggal(), "yyyy-MM-dd HH:mm:ss");
                                    tglTutupTab = (listSimpanan.get(j).getTanggalTutup() == null) ? "-" : "" + Formater.formatDate(listSimpanan.get(j).getTanggalTutup(), "yyyy-MM-dd HH:mm:ss");
                                } catch (Exception e) {
                                    System.out.println(e.getMessage());
                                }
                        %>
                        <tr>
                            <td class="listgensell"><%= namaSimpanan %></td>
                            <td class="listgensell"><%= alokasiBunga %></td>
                            <td class="listgensell"><%= tglBukaTab %></td>
                            <td class="listgensell"><%= PstTransaksi.getLastTransactionDate(oidAnggota, ac.getOID(), js.getOID()) %></td>
                            <td class="listgensell"><%= tglTutupTab %></td>
                            <td class="listgensell"><%= statusSimpanan %></td>
                        </tr>
                        <%
                            } //end for loop j
                        %>
                            
                        <%
                            } //end for loop i
                        %>
                        
                        <%
                            int indexNumber = start;
                            int index = -1;
                            for (int i = 0; i < listAssignContact.size(); i++) {
                                indexNumber = indexNumber + 1;
                                AssignContact assignContact = (AssignContact) listAssignContact.get(i);
                                if (oidAssignContact == assignContact.getOID()) {
                                    index = i;
                                }
                                if ((index == i && (iCommand == Command.EDIT || iCommand == Command.ASK))) {
                                    
                                    Vector<MasterTabungan> mts = PstMasterTabungan.list(0, 0, "", PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN]);
                                    String smt = "<select class='jenisTabungan' name='" + frmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_MASTERTABUNGANID] + "'>";
                                    //smt += "<option data-kode=''>- Pilih Tabungan -</option>";
                                    for (MasterTabungan mt : mts) {
                                        if (mt.getOID() == assignContact.getMasterTabunganId()) {
                                            smt += "<option data-kode='" + mt.getKodeTabungan() + "' value='" + mt.getOID() + "' selected>" + mt.getNamaTabungan() + "</option>";
                                        } else {
                                            //smt += "<option data-kode='" + mt.getKodeTabungan() + "' value='" + mt.getOID() + "'>" + mt.getNamaTabungan() + "</option>";
                                        }

                                    }
                                    smt += "</select>";
                                    
                                    MasterTabungan mt = new MasterTabungan();
                                    JenisSimpanan js = new JenisSimpanan();
                                    Vector<AssignTabungan> at = new Vector<AssignTabungan>();
                                    try {
                                        mt = PstMasterTabungan.fetchExc(assignContact.getMasterTabunganId());
                                        at = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + "=" + mt.getOID(), "");
                                    } catch (Exception e) {
                                    }
                        %>
                        <tr class="row-edit">
                            <td class="listgensell text-center" width="1%" rowspan="<%=at.size()%>">
                                <a href="javascript:cmdEdit('<%=String.valueOf(assignContact.getOID())%>')"><i class="fa fa-pencil"></i></a>
                                <input type="hidden" name="<%=frmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_ASSIGNTABUNGANID]%>" value="<%=assignContact.getOID()%>"><input type="hidden" name="<%=frmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_CONTACTID]%>" value="<%=oidAnggota%>">
                            </td>
                            <td class="listgensell" width="" rowspan="<%=at.size()%>">
                                <input type="text" class="autoNoTab" name="<%=frmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_NOTABUNGAN]%>" value="<%=assignContact.getNoTabungan()%>">
                            </td>
                            <td class="listgensell" width="" rowspan="<%=at.size()%>">
                                <%= smt%>
                            </td>
                            <% if (at.size() > 0) { %>
                            <% js = PstJenisSimpanan.fetchExc(at.get(0).getIdJenisSimpanan()); %>
                            <%
                                Vector<DataTabungan> dt = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + assignContact.getOID() + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " = " + js.getOID(), null);
                                String status = "Tidak Terdaftar";
                                String tglBuka = "";
                                String tglTutup = "";
                                long idSimpanan = 0;
                                String optionIdSimpanan = "";
                                if (!dt.isEmpty()) {
                                    status = (dt.get(0).getStatus() == 1) ? "Aktif" : "Tidak Aktif";
                                    tglBuka = (dt.get(0).getTanggal() == null) ? "-" : "" + Formater.formatDate(dt.get(0).getTanggal(), "yyyy-MM-dd HH:mm:ss");
                                    tglTutup = (dt.get(0).getTanggalTutup() == null) ? "-" : "" + Formater.formatDate(dt.get(0).getTanggalTutup(), "yyyy-MM-dd HH:mm:ss");
                                    idSimpanan = dt.get(0).getOID();
                                    long idAlokasiBunga = (dt.get(0).getIdAlokasiBunga() == 0) ? dt.get(0).getOID() : dt.get(0).getIdAlokasiBunga();
                                    Vector<DataTabungan> listDt = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA] + " = " + assignContact.getContactId(), null);
                                    for (DataTabungan dtab : listDt) {
                                        String nomorTabungan = PstAssignContact.fetchExc(dtab.getAssignTabunganId()).getNoTabungan();
                                        String jenisSimpanan = PstJenisSimpanan.fetchExc(dtab.getIdJenisSimpanan()).getNamaSimpanan();
                                        String selected = (idAlokasiBunga == dtab.getOID()) ? "selected":"";
                                        optionIdSimpanan += "<option "+selected+" value='"+dtab.getOID()+"'>"+nomorTabungan+" ("+jenisSimpanan+")</option>";
                                    }
                                }
                            %>
                            <td class="listgensell" width=""><%=js.getNamaSimpanan()%></td>
                            <td class="listgensell" width="">
                                <input type="hidden" name="FRM_ID_SIMPANAN_ALL" value="<%= idSimpanan %>">
                                <select name="FRM_ID_SIMPANAN_ALOKASI">
                                    <%=optionIdSimpanan%>
                                </select>
                            </td>
                            <td class="listgensell" width=""><%=tglBuka%></td>
                            <td class="listgensell" width=""><%=PstTransaksi.getLastTransactionDate(oidAnggota, assignContact.getOID(), js.getOID())%></td>
                            <td class="listgensell" width=""><%=tglTutup%></td>
                            <td class="listgensell" width=""><%=status%></td>
                            <% } %>
                            <%  if (at.size() > 0) { %>

                            <%
                                for (int in = 1; in < at.size(); in++) {
                                    js = PstJenisSimpanan.fetchExc(at.get(in).getIdJenisSimpanan());
                                    Vector<DataTabungan> dt = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + assignContact.getOID() + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " = " + js.getOID(), null);
                                    String status = "Tidak Terdaftar";
                                    String tglBuka = "";
                                    String tglTutup = "";
                                    long idSimpanan = 0;
                                    String optionIdSimpanan = "";
                                    if (!dt.isEmpty()) {
                                        status = (dt.get(0).getStatus() == 1) ? "Aktif" : "Tidak Aktif";
                                        tglBuka = (dt.get(0).getTanggal() == null) ? "-" : "" + Formater.formatDate(dt.get(0).getTanggal(), "yyyy-MM-dd HH:mm:ss");
                                        tglTutup = (dt.get(0).getTanggalTutup() == null) ? "-" : "" + Formater.formatDate(dt.get(0).getTanggalTutup(), "yyyy-MM-dd HH:mm:ss");
                                        idSimpanan = dt.get(0).getOID();
                                        long idAlokasiBunga = (dt.get(0).getIdAlokasiBunga() == 0) ? dt.get(0).getOID() : dt.get(0).getIdAlokasiBunga();
                                        Vector<DataTabungan> listDt = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA] + " = " + assignContact.getContactId(), null);
                                        for (DataTabungan dtab : listDt) {
                                            String nomorTabungan = PstAssignContact.fetchExc(dtab.getAssignTabunganId()).getNoTabungan();
                                            String jenisSimpanan = PstJenisSimpanan.fetchExc(dtab.getIdJenisSimpanan()).getNamaSimpanan();
                                            String selected = (idAlokasiBunga == dtab.getOID()) ? "selected":"";
                                            optionIdSimpanan += "<option "+selected+" value='"+dtab.getOID()+"'>"+nomorTabungan+" ("+jenisSimpanan+")</option>";
                                        }
                                    }
                            %>
                            <tr class="row-edit">
                                <td class="listgensell" width=""><%=js.getNamaSimpanan()%></td>
                                <td class="listgensell" width="">
                                    <input type="hidden" name="FRM_ID_SIMPANAN_ALL" value="<%= idSimpanan %>">
                                    <select name="FRM_ID_SIMPANAN_ALOKASI">
                                        <%=optionIdSimpanan%>
                                    </select>
                                </td>
                                <td class="listgensell" width=""><%=tglBuka%></td>
                                <td class="listgensell" width=""><%=PstTransaksi.getLastTransactionDate(oidAnggota, assignContact.getOID(), js.getOID())%></td>
                                <td class="listgensell" width=""><%=tglTutup%></td>
                                <td class="listgensell" width=""><%=status%></td>
                            </tr>
                            <%
                                }
                            %>

                            <% } %>
                        </tr>
                        <% } %>

                        <% } %>

                        <%
                            if (iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode > 0)) {
                                Vector<MasterTabungan> mts = PstMasterTabungan.list(0, 0, "", PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN]);
                                String smt = "<select class='jenisTabungan' name='" + frmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_MASTERTABUNGANID] + "'>";
                                smt += "<option data-kode=''>- Pilih Tabungan -</option>";
                                for (MasterTabungan mt : mts) {
                                    String selected = (mt.getOID() == assign.getMasterTabunganId()) ? "selected" : "";
                                    smt += "<option data-kode='" + mt.getKodeTabungan() + "' "+selected+" value='" + mt.getOID() + "'>" + mt.getNamaTabungan() + "</option>";
                                }
                                smt += "</select>";
                        %>
                        <tr>
                            <td class="listgensell text-center" width="1%">
                                <a><i class="fa fa-plus"></i></a>
                                <input type="hidden" name="<%=frmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_ASSIGNTABUNGANID]%>"><input type="hidden" name="<%=frmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_CONTACTID]%>" value="<%=oidAnggota%>">
                            </td>
                            <td class="listgensell" width="">
                                <input type="text" placeholder="Otomatis jika kosong" class="autoNoTab" name="<%=frmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_NOTABUNGAN]%>" value="<%= assign.getNoTabungan() %>">
                            </td>
                            <td class="listgensell" width="">
                                <%= smt%>
                            </td>
                            <td class="listgensell" width="">&nbsp</td>
                            <td class="listgensell" width="">&nbsp</td>
                            <td class="listgensell" width="">&nbsp</td>
                            <td class="listgensell" width="">&nbsp</td>
                            <td class="listgensell" width="">&nbsp</td>
                            <td class="listgensell" width="">&nbsp</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                
                <% if (iCommand == Command.EDIT && bulanPeriodeDeposito > 0) {%>
                <br>
                <p>Tanggal Berakhir Deposito :</p>
                <table>
                    <%
                        Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + assign.getOID(), null);
                        for (DataTabungan dt : listSimpanan) {
                            JenisSimpanan js = new JenisSimpanan();
                            try {
                                js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                            } catch (Exception e) {
                                
                            }
                    %>
                    <tr>
                        <td style="width : 100px"><%= js.getNamaSimpanan() %></td>
                        <td><input type="text" placeholder="-" class="date-picker" name="FRM_TANGGAL_TUTUP" value="<%= (dt.getTanggalTutup() == null) ? "" : Formater.formatDate(dt.getTanggalTutup(), "yyyy-MM-dd") %>"</td>
                    </tr>
                    <%
                        }
                    %>
                </table>
                <% } %>
                
                <br>
                <%
                    ctrLine.setListFirstCaption("<i class=\"fa fa-angle-double-left\"></i>");
                    ctrLine.setListPrevCaption("<i class=\"fa fa-angle-left\"></i> ");
                    ctrLine.setListNextCaption("<i class=\"fa fa-angle-right\"></i> ");
                    ctrLine.setListLastCaption("<i class=\"fa fa-angle-double-right\"></i> ");
                    ctrLine.setFirstStyle("class=\"btn-primary btn-sm\"");
                    ctrLine.setPrevStyle("class=\"btn-primary btn-sm\"");
                    ctrLine.setNextStyle("class=\"btn-primary btn-sm\"");
                    ctrLine.setLastStyle("class=\"btn-primary btn-sm\"");
                %>
                <%=ctrLine.drawMeListLimit(0, vectSize, start, recordToGet, "first", "prev", "next", "last", "left")%>
                
                <%
                    ctrLine.setLocationImg(approot + "/images");
                    ctrLine.initDefault();
                    ctrLine.setTableWidth("80%");
                    String scomDel = "javascript:cmdAsk('" + oidAssignContact + "')";
                    String sconDelCom = "javascript:cmdConfirmDelete('" + oidAssignContact + "')";
                    String scancel = "javascript:cmdEdit('" + oidAssignContact + "')";
                    ctrLine.setCommandStyle("command");
                    ctrLine.setColCommStyle("command");
                    ctrLine.setAddStyle("class=\"btn-primary btn-sm\"");
                    ctrLine.setCancelStyle("class=\"btn-delete btn-sm\"");
                    ctrLine.setDeleteStyle("class=\"btn-delete btn-sm\"");
                    ctrLine.setBackStyle("class=\"btn-primary btn-sm\"");
                    ctrLine.setSaveStyle("class=\"btn-save btn-sm\"");
                    ctrLine.setConfirmStyle("class=\"btn-primary btn-sm\"");
                    ctrLine.setAddCaption("<i class=\"fa fa-plus\"></i> " + strAddMar);
                    //ctrLine.setBackCaption("");
                    ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
                    ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackMar);
                    ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveMar);
                    ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskMar);
                    ctrLine.setConfirmDelCaption("<i class=\"fa fa-check\"></i> " + strDeleteMar);
                    
                    ctrLine.setAddCaption(strAddMar);
                    ctrLine.setCancelCaption(strCancel);
                    ctrLine.setBackCaption(strBackMar);
                    ctrLine.setSaveCaption(strSaveMar);
                    ctrLine.setDeleteCaption(strAskMar);
                    ctrLine.setConfirmDelCaption(strDeleteMar);

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
                %>
                <%= ctrLine.draw(iCommand, iErrCode, errMsg)%>
            </form>

                <%= (jumlahSemuaSimpanan > jumlahSimpananTerdeteksi) ? "<i class='fa fa-exclamation-circle text-red'></i> <b>Terdapat " + jumlahSemuaSimpanan + " data simpanan ditemukan !<b>":"" %>

                <form id="form_setoran" action="<%=approot%>/Setoran" class="form-horizontal" method="post">
                    <input type="hidden" name="command" value="<%=AjaxSetoran.FORM_TABUNGAN%>">
                    <input type="hidden" name="query" id="query" value="">
                    <input type="hidden" name="<%=AjaxSetoran.FRM_FIELD_ASSIGN_CONTACT_TABUNGAN_ID%>" id="<%=AjaxSetoran.FRM_FIELD_ASSIGN_CONTACT_TABUNGAN_ID%>" value="">
                    <input type="hidden" name="<%=AjaxSetoran.FRM_FIELD_NO_TABUNGAN%>" id="<%=AjaxSetoran.FRM_FIELD_NO_TABUNGAN%>" value="">
                    <input type="hidden" name="<%=AjaxSetoran.FRM_FIELD_MEMBER_ID%>" id="<%=AjaxSetoran.FRM_FIELD_MEMBER_ID%>" value="<%=a.getOID() %>">
                    <input type="hidden" name="<%=AjaxSetoran.FRM_FIELD_NAMA%>" id="<%=AjaxSetoran.FRM_FIELD_NAMA%>" value="<%=a.getName() %>">
                    <input type="hidden" name="<%=AjaxSetoran.FRM_FIELD_ALAMAT%>" id="<%=AjaxSetoran.FRM_FIELD_ALAMAT%>" value="<%=a.getAddressPermanent()%>">
                </form>
        </section>
    
<%--
        <table width="100%" border="0" cellspacing="0" cellpadding="0"  bgcolor="#F9FCFF">
            <tr> 
                <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
                    <b><%=systemTitle[SESS_LANGUAGE]%> > <%=oidAnggota != 0 ? userTitle[SESS_LANGUAGE][1].toUpperCase() : userTitle[SESS_LANGUAGE][0].toUpperCase()%></b>
                </td>
            </tr>
            <tr>
                <td>
                    <br>
                    

                    <form name="<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>"> 
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_masterTabungan_id" value="<%=oidAssignContact%>">
                        <input type="hidden" name="anggota_oid" value="<%=oidAnggota%>">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <% if (oidAnggota != 0) {%>
                            <tr>
                                <td>
                                    <br>
                                    
                                </td>
                            </tr>

                            <tr align="left" valign="top"> 
                                <td height="8"  colspan="3"> 
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr align="left" valign="top"> 
                                            <td height="8" valign="middle" colspan="3">&nbsp; 
                                            </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                            <td height="22" valign="middle" colspan="3"> 
                                                
                                            </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                            <td height="8" align="left" colspan="3" class="command"> 
                                                <span class="command">
                                                    
                                                </span> </td>
                                        </tr>
                                        <%
                                            if (privAdd && (iErrCode == ctrlAssignContact.RSLT_OK) && (iCommand != Command.ADD) && (iCommand != Command.ASK) && (iCommand != Command.EDIT) && (frmAssignContact.errorSize() == 0)) {
                                        %>					  
                                        <tr align="left" valign="top"> 
                                            <td height="22" valign="middle" colspan="3"> 
                                                <table width="20%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr><td>&nbsp;<a href="javascript:cmdAdd()" class="command"><%//=strAddMar%></a></td></tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </table>
                                </td>
                            </tr>

                            <%} else {%>
                            <tr>
                                <td>&nbsp;</td>
                            </tr>
                            <%}%>

                        </table>
                    </form>
                </td>
            </tr>
            <tr>
                <td>
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
            <tr>
                <td colspan="2" height="20" bgcolor=""> 
                    <!-- #BeginEditable "footer" -->
                    <%@ include file = "../../main/footer.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
        </table>
--%>
    </body>

    <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>
    <script language="javascript">
        document.<%=FrmAssignContact.FRM_NAME_ASSIGNCONTACT%>.<%=FrmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_NOTABUNGAN]%>.focus();
    </script>
    <%}%>
    <!-- #BeginEditable "script" -->
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>
