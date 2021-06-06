<%-- 
    Document   : krediteditor
    Created on : Mar 4, 2013, 3:48:16 PM
    Author     : dw1p4
--%>

<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.SumberDana"%>
<%@page import="com.dimata.sedana.form.sumberdana.CtrlSumberDana"%>
<%@page import="com.dimata.sedana.form.sumberdana.FrmSumberDana"%>
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

%>
<!-- if of "has access" condition -->

<!-- JSP Block -->
<%!    public static String strTitle[][] = {
        {"No", "Nama", "Jenis Sumber Dana", "Kode Sumber Dana", "Judul Sumber Dana", "Target Pendanaan", "Prioritas Penggunaan", "Total Ketersediaan Dana", "Biaya Bunga Ke Kreditur", "Tipe Bunga Ke Kreditur", "Tanggal Dana Masuk", "Tanggal Lunas Ke Kreditur", "Tanggal Dana Mulai Tersedia", "Tanggal Akhir Tersedia", "Minimum Pinjaman Ke Debitur", "Maximum Pinjaman Ke Debitur"},
        {"No", "Name", "Types of Fund Sources", "Code of Fund Sources", "Title of Fund Sources", "Funding Target", "Usage Priority", "Total Description of Funds", "Cost of Interest to Creditors", "Type of Interest to the Creditor", "Date of Entrance Fund", "Dated to Creditors", "Funding Date Start Available", "End Date Available", "Minimum Loan to Debtor", "Maximum Loan to Debtor"},};

    public static final String systemTitle[] = {
        "Sumber Dana", "Fund Sources"
    };
    public static final String userTitle[][] = {
        {"Data", "Data"}, {"Data", "Data"}
    };
%>

<%//
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);

    String currPageTitle = systemTitle[SESS_LANGUAGE];
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
    long oidSumberDana = FRMQueryString.requestLong(request, FrmSumberDana.fieldNames[FrmSumberDana.FRM_FIELD_SUMBER_DANA_ID]);
    int start = FRMQueryString.requestInt(request, "start");

    CtrlSumberDana ctrlSumberDana = new CtrlSumberDana(request);
    FrmSumberDana frmSumberDana = ctrlSumberDana.getForm();
    String strMasage = "";

    int excCode = ctrlSumberDana.action(iCommand, oidSumberDana);
    SumberDana sumberDana = ctrlSumberDana.getSumberDana();
    strMasage = ctrlSumberDana.getMessage();
    Anggota anggota = new Anggota();
    if (sumberDana.getContactId() != 0) {
        try {
            anggota = PstAnggota.fetchExc(sumberDana.getContactId());
        } catch (Exception ex) {

        }
    }
    if (iCommand == Command.SAVE) {
        sumberDana = new SumberDana();
    }

    if (((iCommand == Command.SAVE) || (iCommand == Command.DELETE)) && (frmSumberDana.errorSize() < 1)) {
%>
<jsp:forward page="sumber_dana.jsp"> 
    <jsp:param name="start" value="<%=start%>" />
    <jsp:param name="FRM_FIELD_SUMBER_DANA_ID" value="<%=sumberDana.getOID()%>" />
</jsp:forward>
<%
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>
        
        <%@ include file = "/style/lte_head.jsp" %>
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />

        <script language="JavaScript">
            function cmdCancel() {
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.EDIT%>";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumber_dana.jsp";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }

            function cmdSave() {
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.SAVE%>";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumberdanaeditor.jsp";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }

            function cmdAsk(oid) {
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.<%= frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>.value = oid;
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.ASK%>";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumberdanaeditor.jsp";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }

            function cmdDelete(oid) {
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.<%= frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>.value = oid;
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.DELETE%>";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumberdanaeditor.jsp";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }


            function cmdBack(oid) {
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.<%= frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>.value = oid;
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.BACK%>";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumber_dana.jsp";
                document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }

            function checkJenisBunga() {
                var getVal = document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.<%= frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_JENIS_SUMBER_DANA]%>.value;
                var tipeBunga = document.getElementById("tipebunga");
                if (getVal == 1) {
                    tipeBunga.style.display = 'block';
                } else {
                    tipeBunga.style.display = 'none';
                    document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.<%= frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_TIPE_BUNGA_KE_KREDITUR]%>.value = '';
                }
            }

            function updatAnggota(frmID) {
                var oidAnggota = document.<%= frmSumberDana.FRM_NAME_SUMBERDANA%>.<%= frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_CONTACT_ID]%>.value;
                window.open("<%=approot%>/masterdata/masterkredit/select_anggota.jsp?formName=<%= frmSumberDana.FRM_NAME_SUMBERDANA%>&frmFieldIdAnggotaName=<%= frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_CONTACT_ID]%>&<%= frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_CONTACT_ID]%>=" + oidAnggota + "&frmFieldIdAnggotaName=" + oidAnggota,
                        null, "height=430, width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }

        </script>
        
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
                
                $('#formInput').submit(function () {
                    cmdSave();
                    return false;
                });
            });
        </script>
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
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <h3 class="box-title">Form Input</h3>
                        </div>
                        <form id="formInput" class="form-horizontal" name="<%= frmSumberDana.FRM_NAME_SUMBERDANA%>" method="get" action="">
                            <input type="hidden" name="command" value="">
                            <input type="hidden" name="<%= frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>" value="<%=oidSumberDana%>">
                            <input type="hidden" name="start" value="<%=start%>">
                            <div class="box-body">

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][1]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" name="contact" onclick="javascript:updatAnggota()" value="<%= anggota.getName()%>">
                                            <input type="hidden" class="form-control" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_CONTACT_ID]%>" value="<%=sumberDana.getContactId()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][2]%></label>                                    
                                        <div class="col-sm-8">
                                            <%
                                                Vector jenis_sumber_dana_key = new Vector(1, 1);
                                                Vector jenis_sumber_dana_val = new Vector(1, 1);
                                                for (int i = 0; i < PstSumberDana.jenisSumberDana.length; i++) {
                                                    jenis_sumber_dana_key.add("" + i);
                                                    jenis_sumber_dana_val.add("" + PstSumberDana.jenisSumberDana[i]);
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_JENIS_SUMBER_DANA], "-- Pilih --", "" + sumberDana.getJenisSumberDana(), jenis_sumber_dana_key, jenis_sumber_dana_val, "onchange='javascript:checkJenisBunga()'", "form-control")%>

                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][3]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="text" required class="form-control" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_KODE_SUMBER_DANA]%>" value="<%=sumberDana.getKodeSumberDana()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][4]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="text" required class="form-control" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_JUDUL_SUMBER_DANA]%>" value="<%=sumberDana.getJudulSumberDana()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][5]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="text" required class="form-control" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_TARGET_PENDANAAN]%>" value="<%=sumberDana.getTargetPendanaan()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][6]%></label>                                    
                                        <div class="col-sm-8">
                                            <%
                                                Vector prioritas_key = new Vector(1, 1);
                                                for (int i = 1; i <= 4; i++) {
                                                    prioritas_key.add("" + i);
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_PRIORITAS_PENGGUNAAN], "-- Pilih --", "" + sumberDana.getPrioritasPenggunaan(), prioritas_key, prioritas_key, "", "form-control")%>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][7]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="number" required class="form-control" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_TOTAL_KETERSEDIAAN_DANA]%>" value="<%=sumberDana.getTotalKetersediaanDana()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][8]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="number" required class="form-control" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_BIAYA_BUNGA_KE_KREDITUR]%>" value="<%=sumberDana.getBiayaBungaKeKreditur()%>">
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <%
                                        String display = "display:none;";
                                        if (sumberDana.getTipeBungaKeKreditur() == 1) {
                                            display = "";
                                        }
                                    %>
                                    <div class="form-group" id="tipebunga" style="<%= display%>">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][9]%></label>                                    
                                        <div class="col-sm-8">
                                            <%
                                                Vector tipe_bunga_key = new Vector(1, 1);
                                                Vector tipe_bunga_val = new Vector(1, 1);
                                                for (int i = 0; i < PstSumberDana.tipeBunga.length; i++) {
                                                    tipe_bunga_key.add("" + i);
                                                    tipe_bunga_val.add("" + PstSumberDana.tipeBunga[i]);
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_TIPE_BUNGA_KE_KREDITUR], "-- Pilih --", "" + sumberDana.getTipeBungaKeKreditur(), tipe_bunga_key, tipe_bunga_val, "", "form-control")%>
                                        </div>
                                    </div>


                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][10]%></label>
                                        <div class="col-sm-8">
                                            <%
                                                String tglDanaMasuk = "" + sumberDana.getTanggalDanaMasuk();
                                                if (tglDanaMasuk.equals("null")) {
                                                    tglDanaMasuk = "";
                                                }
                                            %>
                                            <input type="text" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_TANGGAL_DANA_MASUK]%>" value="<%=tglDanaMasuk%>">
                                            <%--=ControlDate.drawDate(frmJenisKredit.fieldNames[frmJenisKredit.FRM_JANGKA_WAKTU_MIN], kredit.getJangkaWaktuMin(), "", "form-control col-sm-4", "", "", 10, -20, "style='width:25%'")--%> 
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][11]%></label>
                                        <div class="col-sm-8">
                                            <%
                                                String tglLunasKeKreditur = "" + sumberDana.getTanggalLunasKeKreditur();
                                                if (tglLunasKeKreditur.equals("null")) {
                                                    tglLunasKeKreditur = "";
                                                }
                                            %>
                                            <input type="text" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_TANGGAL_LUNAS_KE_KREDITUR]%>" value="<%= tglLunasKeKreditur%>">
                                            <%--=ControlDate.drawDate(frmJenisKredit.fieldNames[frmJenisKredit.FRM_JANGKA_WAKTU_MAX], kredit.getJangkaWaktuMax(), "", "form-control col-sm-4", "", "", 10, -20, "style='width:25%'")--%> 
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][12]%></label>
                                        <div class="col-sm-8">
                                            <%
                                                String tglDanaMulaiTersedia = "" + sumberDana.getTanggalDanaMulaiTersedia();
                                                if (tglDanaMulaiTersedia.equals("null")) {
                                                    tglDanaMulaiTersedia = "";
                                                }
                                            %>
                                            <input type="text" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_TANGGAL_DANA_MULAI_TERSEDIA]%>" value="<%= tglDanaMulaiTersedia%>">
                                            <%--=ControlDate.drawDate(frmJenisKredit.fieldNames[frmJenisKredit.FRM_JANGKA_WAKTU_MAX], kredit.getJangkaWaktuMax(), "", "form-control col-sm-4", "", "", 10, -20, "style='width:25%'")--%> 
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][13]%></label>
                                        <div class="col-sm-8">
                                            <%
                                                String tglAkhirTersedia = "" + sumberDana.getTanggalAkhirTersedia();
                                                if (tglAkhirTersedia.equals("null")) {
                                                    tglAkhirTersedia = "";
                                                }
                                            %>
                                            <input type="text" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_TANGGAL_AKHIR_TERSEDIA]%>" value="<%= tglAkhirTersedia%>">
                                            <%--=ControlDate.drawDate(frmJenisKredit.fieldNames[frmJenisKredit.FRM_JANGKA_WAKTU_MAX], kredit.getJangkaWaktuMax(), "", "form-control col-sm-4", "", "", 10, -20, "style='width:25%'")--%> 
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][14]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="number" class="form-control" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_MINIMUM_PINJAMAN_KE_DEBITUR]%>" value="<%=sumberDana.getMinimumPinjamanKeDebitur()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][15]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="number" class="form-control" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_MAXIMUM_PINJAMAN_KE_DEBITUR]%>" value="<%=sumberDana.getMaximumPinjamanKeDebitur()%>">
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="box-footer">
                                <div class="col-sm-12">
                                    <div class="pull-right">
                                        <button type="submit" form="formInput" class="btn btn-sm btn-success"><i class="fa fa-check"></i> <%=strSaveKredit%></button>
                                        <a class="btn btn-sm btn-default" href="javascript:cmdBack()"><i class="fa fa-undo"></i> <%=strBackKredit%></a>
                                        <% if (oidSumberDana > 0) {%>
                                        <a class="btn btn-sm btn-danger" href="javascript:cmdDelete('<%=oidSumberDana%>')"><i class="fa fa-remove"></i> <%=strAskKredit%></a>
                                        <% }%>
                                    </div>                 
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </body>
</html>
