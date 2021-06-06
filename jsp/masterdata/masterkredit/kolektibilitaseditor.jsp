<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlKolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmKolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlKolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmKolektibilitasPembayaran"%>
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
  long kolektibilitasid = FRMQueryString.requestLong(request, FrmKolektibilitasPembayaranDetails.fieldNames[FrmKolektibilitasPembayaranDetails.FRM_FIELD_KOLEKTIBILITASID]);
  long kolektibilitasDetailOID = FRMQueryString.requestLong(request, FrmKolektibilitasPembayaranDetails.fieldNames[FrmKolektibilitasPembayaranDetails.FRM_FIELD_KOLEKTIBILITASDETAILID]);
  int start = FRMQueryString.requestInt(request, "start");

  CtrlKolektibilitasPembayaran ctrlkolektibilitas = new CtrlKolektibilitasPembayaran(request);
  CtrlKolektibilitasPembayaranDetails ctrlDetails = new CtrlKolektibilitasPembayaranDetails(request);
  FrmKolektibilitasPembayaran frmKolektibilitas = ctrlkolektibilitas.getForm();
  FrmKolektibilitasPembayaranDetails frmDetails = ctrlDetails.getForm();
  String strMasage = "";
  
  if(iCommand==Command.SAVE && kolektibilitasid==0){
    ctrlkolektibilitas.action(Command.SAVE, 0);
    ctrlDetails.getKolektibilitasPembayaranDetails().setKolektibilitasId(ctrlkolektibilitas.getKolektibilitasPembayaran().getOID());
  }
  int excCode = ctrlDetails.action(iCommand, kolektibilitasDetailOID);
  KolektibilitasPembayaran kolektibilitasPembayaran = ctrlkolektibilitas.getKolektibilitasPembayaran();
  KolektibilitasPembayaranDetails kolektibilitasDetail = ctrlDetails.getKolektibilitasPembayaranDetails();
  if(iCommand==Command.EDIT && kolektibilitasDetailOID!=0) {
    kolektibilitasDetail = PstKolektibilitasPembayaranDetails.fetchExc(kolektibilitasDetailOID);
    kolektibilitasPembayaran = PstKolektibilitasPembayaran.fetchExc(kolektibilitasDetail.getKolektibilitasId());
  }
  strMasage = ctrlkolektibilitas.getMessage();
// proses untuk data custom
//if(iCommand == Command.DELETE)
//	response.sendRedirect("kredit.jsp"); 

  if (((iCommand == Command.SAVE) || (iCommand == Command.DELETE)) && (frmKolektibilitas.errorSize() < 1)) {
%>
<jsp:forward page="kolektibilitas.jsp"> 
  <jsp:param name="start" value="<%=start%>" />
  <jsp:param name="FRM_FIELD_KOLEKTIBILITASID" value="<%=kolektibilitasPembayaran.getOID()%>" />
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
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.EDIT%>";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitas.jsp";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
      }

      <% if (privAdd || privUpdate) {%>
      function cmdSave() {
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.SAVE%>";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitaseditor.jsp";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
      }
      <%}%>

      <% if (privDelete) {%>
      function cmdAsk(oid) {
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.<%= frmKolektibilitas.fieldNames[FrmKolektibilitasPembayaran.FRM_FIELD_KOLEKTIBILITASID]%>.value = oid;
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.ASK%>";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitaseditor.jsp";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
      }

      function cmdDelete(oid) {
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.<%= frmKolektibilitas.fieldNames[FrmKolektibilitasPembayaran.FRM_FIELD_KOLEKTIBILITASID]%>.value = oid;
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.DELETE%>";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitaseditor.jsp";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
      }
      <%}%>


      function cmdBack(oid) {
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.<%= frmKolektibilitas.fieldNames[FrmKolektibilitasPembayaran.FRM_FIELD_KOLEKTIBILITASID]%>.value = oid;
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.BACK%>";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitas.jsp";
        document.<%= frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
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
    <title>SEDANA</title>
    <%@ include file = "/style/lte_head.jsp" %>

  </head> 

  <body style="background-color: #eaf3df;">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Kolektibilitas Pembayaran
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
        <li>Master Kredit</li>
        <li class="active">Kolektibilitas Pembayaran</li>
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
            <form class="form-horizontal" name="<%=frmKolektibilitas.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>" method="get" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="<%=frmDetails.fieldNames[frmDetails.FRM_FIELD_KOLEKTIBILITASDETAILID]%>" value="<%=kolektibilitasDetailOID%>">
              <input type="hidden" name="start" value="<%=start%>">
              <div class="box-body">
                <div class="col-sm-6">
                  <div class="form-group">
                    <label class="col-sm-5 control-label">Kolektibilitas</label>
                    <div class="col-sm-7">
                      <select id="kol" name="<%=frmDetails.fieldNames[frmDetails.FRM_FIELD_KOLEKTIBILITASID] %>" class="form-control input-sm">
                        <% Vector<KolektibilitasPembayaran> kps = PstKolektibilitasPembayaran.list(0, 0, "", PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_TINGKAT_KOLEKTIBILITAS]);%>
                        <% for (KolektibilitasPembayaran kp : kps) {%>
                        <option <%=(kolektibilitasPembayaran.getOID() == kp.getOID() ? "selected" : "")%> data-kode="<%=kp.getKodeKolektibilitas()%>" data-tingkat="<%=kp.getTingkatKolektibilitas()%>" data-judul="<%=kp.getJudulKolektibilitas()%>" data-tingkat="<%=kp.getTingkatKolektibilitas()%>" data-resiko="<%=kp.getTingkatResiko()%>" value="<%=kp.getOID()%>"><%=kp.getJudulKolektibilitas()%></option>
                        <% }%>
                        <option value="0">-- Kolektibilitas Baru --</option>
                      </select>
                      <script>
                        $(document).ready(function () {
                          var kode = $("input[name=FRM_FIELD_KODEKOLEKTIBILITAS]");
                          var tingkat = $("input[name=FRM_FIELD_TINGKATKOLEKTIBILITAS]");
                          var judul = $("input[name=FRM_FIELD_JUDULKOLEKTIBILITAS]");
                          var maxPokok = $("input[name=FRM_FIELD_MAXHARITUNGGAKANPOKOK]");
                          var maxBunga = $("input[name=FRM_FIELD_MAXHARIJUMLAHTUNGGAKANBUNGA]");
                          var resiko = $("input[name=FRM_FIELD_TINGKATRESIKO]");
                          var state = function (e) {
                            if ($(e).val() == "0") {
                              kode.removeAttr("readonly");
                              tingkat.removeAttr("readonly");
                              judul.removeAttr("readonly");
                              maxPokok.removeAttr("readonly");
                              maxBunga.removeAttr("readonly");
                              resiko.removeAttr("readonly");
                              kode.val("");
                              tingkat.val("");
                              judul.val("");
                              resiko.val("");
                            } else {
                              kode.attr("readonly", "true");
                              tingkat.attr("readonly", "true");
                              judul.attr("readonly", "true");
                              resiko.attr("readonly", "true");
                              kode.val($(e).find("option:selected").data("kode"));
                              tingkat.val($(e).find("option:selected").data("tingkat"));
                              judul.val($(e).find("option:selected").data("judul"));
                              resiko.val($(e).find("option:selected").data("resiko"));
                            }
                          }
                          state($("#kol"));
                          $("#kol").change(function () {
                            state($(this));
                          });
                        });
                      </script>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-5 control-label">Tipe Kredit</label>
                    <div class="col-sm-7">
                      <select name="<%=frmDetails.fieldNames[frmDetails.FRM_FIELD_TIPEKREIDT]%>" class="form-control input-sm">
                        <% for (int i = 0; i < I_Sedana.TIPE_KREDIT.size(); i++) {%>
                        <option <%=(kolektibilitasDetail.getTipeKreidt()==i)?"selected":""%> value="<%=i%>"><%=I_Sedana.TIPE_KREDIT.get(i)[SESS_LANGUAGE]%></option>
                        <% }%>
                      </select>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-5 control-label">Max Hari Tunggakan Pokok</label>
                    <div class="col-sm-7">
                      <input type="number" name="<%=frmDetails.fieldNames[frmDetails.FRM_FIELD_MAXHARITUNGGAKANPOKOK]%>" class="form-control input-sm" value="<%=kolektibilitasDetail.getMaxHariTunggakanPokok()%>" />
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-5 control-label">Max Hari Tunggakan Bunga</label>
                    <div class="col-sm-7">
                      <input type="number" name="<%=frmDetails.fieldNames[frmDetails.FRM_FIELD_MAXHARIJUMLAHTUNGGAKANBUNGA]%>" class="form-control input-sm" value="<%=kolektibilitasDetail.getMaxHariJumlahTunggakanBunga()%>" />
                    </div>
                  </div>
                </div>
                <div class="col-sm-6"><div class="form-group">
                    <label class="col-sm-4 control-label">Kode Kolektibilitas</label>
                    <div class="col-sm-8">
                        <input id="kodeKol" class="form-control input-sm" name="<%=FrmKolektibilitasPembayaran.fieldNames[FrmKolektibilitasPembayaran.FRM_FIELD_KODEKOLEKTIBILITAS]%>" value="<%=kolektibilitasPembayaran.getKodeKolektibilitas()%>" />
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label">Tingkat Kolektibilitas</label>
                    <div class="col-sm-8">
                      <input type="number" class="form-control input-sm" name="<%=FrmKolektibilitasPembayaran.fieldNames[FrmKolektibilitasPembayaran.FRM_FIELD_TINGKATKOLEKTIBILITAS]%>" value="<%=kolektibilitasPembayaran.getTingkatKolektibilitas()%>" />
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label">Judul Kolektibilitas</label>
                    <div class="col-sm-8">
                        <input id="judulKol" class="form-control input-sm" name="<%=FrmKolektibilitasPembayaran.fieldNames[FrmKolektibilitasPembayaran.FRM_FIELD_JUDULKOLEKTIBILITAS]%>" value="<%=kolektibilitasPembayaran.getJudulKolektibilitas()%>" />
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label">Tingkat Resiko</label>
                    <div class="col-sm-8">
                      <input type="number" class="form-control input-sm" name="<%=FrmKolektibilitasPembayaran.fieldNames[FrmKolektibilitasPembayaran.FRM_FIELD_TINGKATRESIKO]%>" value="<%=kolektibilitasPembayaran.getTingkatResiko()%>" />
                    </div>
                  </div>
                </div>
              </div>
              <div class="box-footer">
                <div class="col-sm-6"></div>
                <div class="col-sm-6">
                  <div class="form-group">
                    <div class="col-sm-9">
                      <div class="pull-right">
                        <a id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan Data</a>
                        <a id="btn_cancel" class="btn btn-sm btn-default" href="javascript:cmdBack()"><i class="fa fa-undo"></i> &nbsp; Kembali</a>
                        <% if (kolektibilitasDetailOID > 0) {%>
                        <a id="btn_delete" class="btn btn-sm btn-danger" href="javascript:cmdDelete('<%=kolektibilitasDetailOID%>')"><i class="fa fa-remove"></i> &nbsp; Hapus Data</a>
                        <% } %>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
          </div>
          </form>
        </div>
      </div>
      <!--/.col (right) -->
    </div>
    <!-- /.row -->
  </section>
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
      $('#btn_save').click(function () {
        var kode = $('#kodeKol').val();
        var judul = $('#judulKol').val();
        if (kode == "") {
            alert("Kode kolektibilitas harus diisi !");
            $('#kodeKol').focus();
            return false;
        }
        if (judul == "") {
            alert("Judul kolektibilitas harus diisi !");
            $('#judulKol').focus();
            return false;
        }
        cmdSave();
        $(this).attr({"disabled": "true"}).html("Tunggu...");
      });
      $('#btn_cancel').click(function () {
        $(this).attr({"disabled": "true"}).html("Tunggu...");
      });
      $('#btn_delete').click(function () {
        $(this).attr({"disabled": "true"}).html("Tunggu...");
      });
    });
  </script>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>
