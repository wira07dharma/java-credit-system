<%-- 
    Document   : krediteditor
    Created on : Mar 4, 2013, 3:48:16 PM
    Author     : dw1p4
--%>

<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
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
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privView = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));    

%>

<!-- JSP Block -->
<%!    public static String strTitle[][] = {
        {"Nama Jenis Kredit",
            "Minimal Pengajuan",//1
            "Maksimal Pengajuan",//2
            "Bunga Min",//3
            "Bunga Max",//4
            "Biaya Admin",//5
            "Provisi",//6
            "Denda",//7
            "Jangka Waktu Min",//8
            "Jangka Waktu Max",//9
            "Kegunaan",
            "Tipe Bunga",
            "Berlaku Mulai",
            "Berlaku Sampai",//10
            "Frekuensi Angsuran",
            "Hari Angsuran",
            "Toleransi Denda"
        },
        {"Type Credit Name",
            "Min Credit",//1
            "Max Credit",//2
            "Interest Min",//3
            "Interest Max",//4
            "Admin Cost",//5
            "Provisi",//6
            "Penalty",//7
            "Min Period",//8
            "Max Period",//9
            "Usefulness",
            "Type of Interest",
            "Valid Start",
            "Valid Until",//10
            "Frequency Type",
            "Frequency",
            "Tolerance of Penalty"
        },};
    public static final String systemTitle[] = {
        "Jenis Kredit", "Credit"
    };
    public static final String userTitle[][] = {
        {"Data", "Data"}, {"Data", "Data"}
    };
%>

<%
    /* VARIABLE DECLARATION */
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
    long kreditOID = FRMQueryString.requestLong(request, "kredit_oid");
    int start = FRMQueryString.requestInt(request, "start");

    CtrlJenisKredit ctrlJenisKredit = new CtrlJenisKredit(request);
    FrmJenisKredit frmJenisKredit = ctrlJenisKredit.getForm();
    String strMasage = "";

    int excCode = ctrlJenisKredit.action(iCommand, kreditOID);
//    JenisKredit kredit = ctrlJenisKredit.getKredit();
    JenisKredit kredit = PstJenisKredit.fetch(kreditOID);
    strMasage = ctrlJenisKredit.getMessage();

	int enableTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN"));

    if (((iCommand == Command.SAVE) || (iCommand == Command.DELETE)) && (frmJenisKredit.errorSize() < 1)) {%>
<jsp:forward page="jenis_kredit.jsp"> 
    <jsp:param name="start" value="<%=start%>" />
    <jsp:param name="kredit_oid" value="<%=kredit.getOID()%>" />
</jsp:forward>
<%
    }
%>
<!-- End of JSP Block -->
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>

        <%@ include file = "/style/lte_head.jsp" %>
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />

        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <script src="../../style/lib.js"></script>
        <script language="JavaScript">
            function cmdCancel() {
                document.frmKredit.command.value = "<%=Command.EDIT%>";
                document.frmKredit.action = "jenis_kredit.jsp";
                document.frmKredit.submit();
            }

            function cmdSave() {
                document.frmKredit.command.value = "<%=Command.SAVE%>";
                document.frmKredit.action = "krediteditor.jsp";
                $(".form_submit").trigger("click");
            }

            function cmdAsk(oid) {
                document.frmKredit.kredit_oid.value = oid;
                document.frmKredit.action = "krediteditor.jsp";
                document.frmKredit.submit();
            }
            
            function cmdDelete(oid) {
                document.frmKredit.kredit_oid.value = oid;
                document.frmKredit.command.value = "<%=Command.DELETE%>";
                document.frmKredit.action = "krediteditor.jsp";
                basicAjax(baseUrl("ajax/validation.jsp"), function (data) {
                    if (data.status == "true") {
                        document.frmKredit.submit();
                    } else {
                        alert("Jenis kredit tidak dapat dihapus karena sudah digunakan");
                    }
                }, {
                    dataFor: "validateDelJenisKredit",
                    id: oid
                });
            }

            function cmdBack(oid) {
                document.frmKredit.kredit_oid.value = oid;
                document.frmKredit.command.value = "<%=Command.BACK%>";
                document.frmKredit.action = "jenis_kredit.jsp";
                document.frmKredit.submit();
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
            });
        </script>
    </head> 

    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                <%=systemTitle[0]%>
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Kredit</li>
                <li class="active"><%=systemTitle[0]%></li>
            </ol>
        </section>
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <h3 class="box-title">Form Input</h3>
                        </div>
                        <form class="form-horizontal" name="frmKredit" method="get" action="">
                            <input type="hidden" name="command" value="">
                            <input type="hidden" name="kredit_oid" value="<%=kreditOID%>">
                            <input type="hidden" name="start" value="<%=start%>">
                            <div class="box-body">
                                <div class="col-sm-6">

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][0]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="text" required="" class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_NAME_KREDIT]%>" value="<%=kredit.getNamaKredit()%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][14]%></label>
                                        <div class="col-sm-8">
                                            <select name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_TIPE_FREKUENSI]%>" class="form-control tipe-kredit">
                                                <%//
                                                    int idt = -1;
                                                    for (String[] tipe : I_Sedana.TIPE_KREDIT) {
                                                        idt++;
                                                %>
                                                <option <%=(idt == kredit.getTipeFrekuensiPokokLegacy() ? "selected" : "")%> value="<%=idt%>"><%=tipe[SESS_LANGUAGE]%></option>
                                                <% }%>
                                            </select>
                                        </div>
                                    </div>

                                    <script>
                                        $(window).load(function () {
                                            var harian = "<%= I_Sedana.TIPE_KREDIT_HARIAN%>";
                                            var musiman = "<%= I_Sedana.TIPE_KREDIT_MUSIMAN%>";

                                            var textCountMusiman = function () {
                                                var term = $("#musiman .term").val();
                                                var x = $("#musiman .x").val();
                                                var txt = (term * x) > 0 ? "Dari " + (term * x) + " bulan jangka waktu kredit, pembayaran pokok dilakukan sebanyak " + x + " kali." : "";
                                                $("#ket").html(txt);
                                            };
                                            var test = function () {
                                                $(".tipe_frekuensi_legacy").html($("body .tipe-kredit option:selected").text());
                                                $("#musiman, #harian").hide();
                                                $("body input[name='FRM_JANGKA_WAKTU_MIN'], body input[name='FRM_JANGKA_WAKTU_MAX']").removeAttr("readonly");
                                                $("body #harian .form-control, body #musiman .form-control").removeAttr("required min");
                                                switch ($("body .tipe-kredit").val()) {
                                                    case harian:
                                                        $("#harian").show();
                                                        $("#harian .form-control").attr("required", "");
                                                        break;

                                                    case musiman:
                                                        $("#musiman").show();
                                                        $("#musiman .form-control").attr("required", "");
                                                        $("#musiman .form-control").attr("min", "1");
                                                        $("body input[name='FRM_JANGKA_WAKTU_MIN'], body input[name='FRM_JANGKA_WAKTU_MAX']").attr("readonly", "");
                                                        break;

                                                    default:
                                                }
                                                ;
                                                textCountMusiman();
                                            };
                                            test(true);
                                            $("body .tipe-kredit").change(test);
                                            $("#musiman input.form-control").on("change keyup", function () {
                                                var n = parseInt($("#musiman .term").val()) * parseInt($("#musiman .x").val());
                                                $("body input[name='FRM_JANGKA_WAKTU_MIN'], body input[name='FRM_JANGKA_WAKTU_MAX']").val(n > 0 ? n : "0.0");
                                                textCountMusiman();
                                                $("#harian").hide();
                                            });
                                        });
                                    </script>

                                    <div id="harian" class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][15]%></label>                                    
                                        <div class="col-sm-8">
                                            <select name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_FREKUENSI_HARI]%>" multiple class="form-control select2">
                                                <% for (int iday = 1; iday <= I_Sedana.DAYS.size(); iday++) {%>
                                                <option <%=(kredit.getWeekValues().get(iday) ? "selected" : "")%> value="<%=iday%>"><%=I_Sedana.DAYS.get(iday)[SESS_LANGUAGE]%></option>
                                                <% }%>
                                            </select>
                                        </div>
                                    </div>

                                    <div id="musiman" style="display:none;" class="form-group">
                                        <label class="col-sm-4 control-label"></label>                                    
                                        <div class="col-sm-4">
                                            <div class="input-group">
                                                <input type="number" pattern="[0-9]" value="<%=(kredit.getFrekuensiPokok() != 0 ? Math.round(kredit.getJangkaWaktuMin()) / kredit.getFrekuensiPokok() : 0)%>" class="form-control term" placeholder="<%=(SESS_LANGUAGE == langForeign ? "Term" : "Musim")%>" aria-describedby="basic-addon1">
                                                <span class="input-group-addon" id="basic-addon1"><%=(SESS_LANGUAGE == langForeign ? "mnth" : "bln")%></span>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="input-group">
                                                <input type="number" value="<%=kredit.getFrekuensiPokok()%>" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_FREKUENSI_N]%>" pattern="[0-9]" class="form-control x" placeholder="<%=(SESS_LANGUAGE == langForeign ? "Frequency" : "Frekuensi")%>" aria-describedby="basic-addon1">
                                                <span class="input-group-addon" id="basic-addon1"><%=(SESS_LANGUAGE == langForeign ? "X" : "kali")%></span>
                                            </div>
                                        </div>
                                        <div class="col-sm-4"></div>
                                        <div style="margin-top:10px;" class="col-sm-8"><p id="ket"></p></div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][11]%></label>                                    
                                        <div class="col-sm-8">
                                            <%
                                                Vector tipe_bunga_key = new Vector();
                                                Vector tipe_bunga_val = new Vector();
                                                for (int i = 0; i < Pinjaman.TIPE_BUNGA_TITLE.length; i++) {
                                                    tipe_bunga_key.add("" + i);
                                                    tipe_bunga_val.add("" + Pinjaman.TIPE_BUNGA_TITLE[i]);
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmJenisKredit.fieldNames[frmJenisKredit.FRM_TIPE_BUNGA], "-- Pilih --", "" + kredit.getTipeBunga(), tipe_bunga_key, tipe_bunga_val, "", "form-control")%>
                                        </div>
                                    </div>
									<% if(enableTabungan == 1){ %>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][1]%></label>                                    
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <span class="input-group-addon">Rp</span>
                                                <input type="text" required data-cast-class="valMinKredit" class="form-control money" value="<%=kredit.getMinKredit()%>">
                                                <input type="hidden" class="valMinKredit" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_MIN_KREDIT]%>" value="<%=kredit.getMinKredit()%>">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][2]%></label>                                    
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <span class="input-group-addon">Rp</span>
                                                <input type="text" required class="form-control money" data-cast-class="valMaxKredit" value="<%=kredit.getMaxKredit()%>">
                                                <input type="hidden" class="valMaxKredit" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_MAX_KREDIT]%>" value="<%=kredit.getMaxKredit()%>">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][3]%> Per Tahun</label>                                    
                                        <div class="col-sm-8">
                                            <div class="input-group">                                                
                                                <input required class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_BUNGA_MIN]%>" value="<%=kredit.getBungaMin()%>">
                                                <span class="input-group-addon">%</span>
                                            </div>                                            
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][4]%> Per Tahun</label>                                    
                                        <div class="col-sm-8">
                                            <div class="input-group">                                                
                                                <input required class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_BUNGA_MAX]%>" value="<%=kredit.getBungaMax()%>">
                                                <span class="input-group-addon">%</span>
                                            </div>                                              
                                        </div>
                                    </div>
									<% } %>
                                </div>

                                <div class="col-sm-6">
									<% if(enableTabungan == 1){ %>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][8]%></label>
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <%
                                                    String arrayTipeFrekuensi[] = I_Sedana.TIPE_KREDIT.get(kredit.getTipeFrekuensiPokokLegacy());
                                                    String frekuensi = arrayTipeFrekuensi[SESS_LANGUAGE];
                                                %>

                                                <%
                                                    String min = String.format("%.0f", kredit.getJangkaWaktuMin());
                                                    if (min.equals("null")) {
                                                        min = "";
                                                    }
                                                %>
                                                <input type="number" required class="form-control"  placeholder="<%=strTitle[SESS_LANGUAGE][8]%>" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_JANGKA_WAKTU_MIN]%>" value="<%=min%>">
                                                <span class="input-group-addon tipe_frekuensi_legacy"><%= frekuensi%></span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][9]%></label>
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <%
                                                    String max = String.format("%.0f", kredit.getJangkaWaktuMax());
                                                    if (max.equals("null")) {
                                                        max = "";
                                                    }
                                                %>
                                                <input type="number" required class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_JANGKA_WAKTU_MAX]%>" value="<%=max%>">
                                                <span class="input-group-addon tipe_frekuensi_legacy"><%= frekuensi%></span>
                                            </div>
                                        </div>
                                    </div>
                                    <%--
                              <div class="form-group">
                                <label class="col-sm-4 control-label" title="Persentase ketika pencairan kredit yang dialokasikan ke tabungan wajib. 0 = tidak ada">Alokasi Tabungan Wajib</label>                                    
                                <div class="col-sm-8">
                                  <div class="input-group">
                                    <input type="text" required class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_PERSENTASE_WAJIB]%>" value="<%=kredit.getPersentaseWajib()%>">
                                    <span class="input-group-addon">%</span>
                                  </div>
                                </div>
                              </div>
                                    --%>
                                    <%
                                        boolean disablePersentase = false;
                                        boolean disableNominal = false;
                                        if (kredit.getPersentaseWajib() == 0 && kredit.getNominalWajib() != 0) {
                                            disablePersentase = true;
                                        } else if (kredit.getPersentaseWajib() != 0 && kredit.getNominalWajib() == 0) {
                                            disableNominal = true;
                                        }
                                    %>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" title="Persentase ketika pencairan kredit yang dialokasikan ke tabungan wajib. 0 = tidak ada">Alokasi Tabungan Wajib</label>                                    
                                        <div class="col-sm-4">
                                            <div class="input-group">
                                                <input type="text" <%=(disablePersentase ? "readonly" : "")%> required class="form-control valWajib" id="wajib1" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_PERSENTASE_WAJIB]%>" value="<%=kredit.getPersentaseWajib()%>">
                                                <span class="input-group-addon">%</span>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="input-group">
                                                <span class="input-group-addon">Rp.</span>
                                                <input type="text" <%=(disableNominal ? "readonly" : "")%> required class="form-control money valWajib" id="wajib2" data-cast-class="valPersentaseWajib" value="<%=kredit.getNominalWajib()%>">
                                                <input type="hidden" class="valPersentaseWajib" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_NOMINAL_WAJIB]%>" value="<%=kredit.getNominalWajib()%>">
                                            </div>
                                        </div>
                                        <script>
                                            $(window).load(function () {
                                                var toggleWajib = function () {
                                                    var id = $(this).attr("id");
                                                    var otherId = (id == "wajib1") ? $("#wajib2") : $("#wajib1");
                                                    if ($(this).val() && $(this).val() != "0" && $(this).val() != "0.0") {
                                                        $(otherId).attr("readonly", "readonly");
                                                    } else {
                                                        $(otherId).removeAttr("readonly");
                                                    }
                                                };
                                                $(".valWajib").keyup(toggleWajib);
                                            });
                                        </script>
                                    </div>    
									<% } %>


                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][12]%></label>
                                        <div class="col-sm-8">
                                            <%
                                                String mulai = (kredit.getBerlakuMulai() != null) ? Formater.formatDate(kredit.getBerlakuMulai(), "yyyy-MM-dd") : "";
                                            %>
                                            <input type="text" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_BERLAKU_MULAI]%>" value="<%=mulai%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][13]%></label>
                                        <div class="col-sm-8">
                                            <%
                                                String sampai = (kredit.getBerlakuSampai() != null) ? Formater.formatDate(kredit.getBerlakuSampai(), "yyyy-MM-dd") : "";
                                            %>
                                            <input type="text" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_BERLAKU_SAMPAI]%>" value="<%=sampai%>">
                                            <%--=ControlDate.drawDate(frmJenisKredit.fieldNames[frmJenisKredit.FRM_JANGKA_WAKTU_MAX], kredit.getJangkaWaktuMax(), "", "form-control col-sm-4", "", "", 10, -20, "style='width:25%'")--%> 
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][10]%></label>                                    
                                        <div class="col-sm-8">
                                            <textarea style="resize: none" class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_KEGUNAAN]%>"><%=kredit.getKegunaan()%></textarea>
                                        </div>
                                    </div>

                                    <!--div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][5]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="number" required class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_BIAYA_ADMIN]%>" value="<%=kredit.getBiayaAdmin()%>">
                                        </div>
                                    </div-->

                                    <!--div class="form-group">
                                        <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][6]%></label>                                    
                                        <div class="col-sm-8">
                                            <input type="number" required class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_PROVISI]%>" value="<%=kredit.getProvisi()%>">
                                        </div>
                                    </div-->

                                </div>

                                <div class="col-sm-12">
                                    <hr style="border-color: grey">
                                </div>

                                <div class="col-sm-12">
                                    <h4 class="">* Ketentuan Pengenaan Denda :</h4>

                                    <div class="form-group">
                                        <label class="col-sm-2 control-label"><%=strTitle[SESS_LANGUAGE][16]%></label>
                                        <div class="col-sm-2">
                                            <% int toleransi = kredit.getDendaToleransi();%>
                                            <select class="form-control" id="toleransi">
                                                <option <%=(toleransi == -1 ? "selected" : "")%> value="-1">Tak Terbatas</option>
                                                <option <%=(toleransi == -2 ? "selected" : "")%> value="-2">Akhir bulan</option>
                                                <option <%=(toleransi > -1 ? "selected" : "")%> value="-3">Jeda Hari</option>
                                            </select>                      
                                            <script>
                                                $(window).load(function () {
                                                    $("#tinput").val() < 0 || $("#tinput").show();
                                                    $("#toleransi").change(function () {
                                                        var v = $(this).val();
                                                        if (v == "-3") {
                                                            $("#tinput").val(0);
                                                            $("#tinput").show();
                                                        } else {
                                                            $("#tinput").hide();
                                                            $("#tinput").val(v);
                                                        }
                                                    });
                                                });
                                            </script>
                                        </div>
                                        <div class="col-sm-2">
                                            <input style="display: none;" id="tinput" type="number" min="-2" class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_DENDA_TOLERANSI]%>" value="<%=toleransi%>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">Syarat Denda</label>                                    
                                        <div class="col-sm-4">
                                            <%
                                                Vector tipe_berlaku_key = new Vector();
                                                Vector tipe_berlaku_val = new Vector();
                                                for (int i = 0; i < JenisKredit.TIPE_DENDA_BERLAKU_TITLE.length; i++) {
                                                    tipe_berlaku_key.add("" + i);
                                                    tipe_berlaku_val.add("" + JenisKredit.TIPE_DENDA_BERLAKU_TITLE[i]);
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmJenisKredit.fieldNames[frmJenisKredit.FRM_TIPE_DENDA_BERLAKU], null, "" + kredit.getTipeDendaBerlaku(), tipe_berlaku_key, tipe_berlaku_val, "", "form-control")%>
                                            <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_TIPE_DENDA_BERLAKU)%>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">Persentase Denda</label>
                                        <div class="col-sm-2">
                                            <div class="input-group">
                                                <input type="text" required class="form-control" data-cast-class="valDenda" value="<%=kredit.getDenda()%>">
                                                <input type="hidden" class="valDenda" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_DENDA]%>" value="<%=kredit.getDenda()%>">
                                                <span class="input-group-addon">%</span>
                                                <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_DENDA)%>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">Variabel Denda</label>
                                        <div class="col-sm-2">
                                            <%
                                                Vector tipe_perhitungan_key = new Vector();
                                                Vector tipe_perhitungan_val = new Vector();
                                                for (int i = 0; i < JenisKredit.TIPE_PERHITUNGAN_DENDA_TITLE.length; i++) {
                                                    tipe_perhitungan_key.add("" + i);
                                                    tipe_perhitungan_val.add("" + JenisKredit.TIPE_PERHITUNGAN_DENDA_TITLE[i]);
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmJenisKredit.fieldNames[frmJenisKredit.FRM_TIPE_PERHITUNGAN_DENDA], null, "" + kredit.getTipePerhitunganDenda(), tipe_perhitungan_key, tipe_perhitungan_val, "", "form-control")%>
                                            <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_TIPE_PERHITUNGAN_DENDA)%>
                                        </div>
                                        <div class="col-sm-2">
                                            <%
                                                Vector variabel_key = new Vector();
                                                Vector variabel_val = new Vector();
                                                for (int i = 0; i < JenisKredit.VARIABEL_DENDA_TITLE.length; i++) {
                                                    variabel_key.add("" + i);
                                                    variabel_val.add("" + JenisKredit.VARIABEL_DENDA_TITLE[i]);
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmJenisKredit.fieldNames[frmJenisKredit.FRM_VARIABEL_DENDA], null, "" + kredit.getVariabelDenda(), variabel_key, variabel_val, "", "form-control")%>
                                            <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_VARIABEL_DENDA)%>
                                        </div>
                                        <div class="col-sm-2">
                                            <select class="form-control" name="<%= frmJenisKredit.fieldNames[frmJenisKredit.FRM_TIPE_VARIABEL_DENDA]%>">
                                                <% for (int i = 0; i < JenisKredit.TIPE_VARIABEL_DENDA_TITLE.length; i++) {%>
                                                <option <%= (kredit.getTipeVariabelDenda() == i) ? "selected" : ""%> value="<%= i%>"><%= JenisKredit.TIPE_VARIABEL_DENDA_TITLE[i]%></option>
                                                <% }%>
                                            </select>
                                            <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_TIPE_VARIABEL_DENDA)%>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">Denda Setiap</label>
                                        <div class="col-sm-2">
                                            <input type="number" required class="form-control" name="<%=frmJenisKredit.fieldNames[frmJenisKredit.FRM_FREKUENSI_DENDA]%>" value="<%=kredit.getFrekuensiDenda()%>">
                                            <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_FREKUENSI_DENDA)%>
                                        </div>
                                        <div class="col-sm-2">
                                            <%
                                                Vector tipe_satuan_key = new Vector();
                                                Vector tipe_satuan_val = new Vector();
                                                for (int i = 0; i < JenisKredit.SATUAN_FREKUENSI_DENDA_TITLE.length; i++) {
                                                    tipe_satuan_key.add("" + i);
                                                    tipe_satuan_val.add("" + JenisKredit.SATUAN_FREKUENSI_DENDA_TITLE[i]);
                                                }
                                            %>
                                            <%= ControlCombo.draw(frmJenisKredit.fieldNames[frmJenisKredit.FRM_SATUAN_FREKUANSI_DENDA], null, "" + kredit.getSatuanFrekuensiDenda(), tipe_satuan_key, tipe_satuan_val, "", "form-control")%>
                                            <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_SATUAN_FREKUANSI_DENDA)%>
                                        </div>
                                        <div class="col-sm-2">
                                            <select class="form-control" name="<%= frmJenisKredit.fieldNames[frmJenisKredit.FRM_TIPE_FREKUENSI_DENDA]%>">
                                                <% for (int i = 0; i < JenisKredit.TIPE_FREKUENSI_DENDA_TITLE.length; i++) {%>
                                                <option  <%= (kredit.getTipeFrekuensiDenda() == i) ? "selected" : ""%> value="<%= i%>"><%= JenisKredit.TIPE_FREKUENSI_DENDA_TITLE[i]%></option>
                                                <% }%>
                                            </select>
                                            <%= frmJenisKredit.getErrorMsg(frmJenisKredit.FRM_TIPE_FREKUENSI_DENDA)%>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <div class="col-sm-12">
                                    <div class="pull-right">                                        
                                        <a class="btn btn-sm btn-success" href="javascript:cmdSave()"><i class="fa fa-check"></i> <%=strSaveKredit%></a>
                                        <a class="btn btn-sm btn-default" href="javascript:cmdBack()"><i class="fa fa-undo"></i> <%=strBackKredit%></a>
                                        <% if (kreditOID > 0) {%>
                                        <a class="btn btn-sm btn-danger" href="javascript:cmdDelete('<%=kreditOID%>')"><i class="fa fa-remove"></i> <%=strAskKredit%></a>
                                        <% }%>
                                    </div>
                                </div>
                            </div>
                            <button class="hidden form_submit" type="submit">Submit</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </body>
</html>
