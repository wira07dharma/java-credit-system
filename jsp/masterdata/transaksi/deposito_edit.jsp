<%@page import="com.dimata.sedana.form.reportsearch.FrmRscReport"%>
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

<%!
  public static String strTitle[][] = {
    {"No Anggota",//0
      "Nama Anggota",//1
      "Alamat Anggota",//2
      "Nomor Rekening",//3
      "Jenis Deposito",//4
      "Kelompok Anggota",//5
      "Tanggal Registrasi",//6
      "Jumlah Deposito",//7
      "PPH",//8
      "Bunga",//9
      "Biaya Admin",//10
      "Status"//11
  },
    {"Member ID",//0
      "Member Name",//1
      "Member Address",//2
      "Rekening Number",//3
      "Deposits Type",//4
      "Member Club",//5
      "Reg Date",//6
      "Amount of Deposits",//7
      "Provisi",//8
      "Interest",//9
      "Admin Cost",//10
      "Status"//11
  }
  };

  public static final String systemTitle[] = {
    "Deposito", "Deposits"
  };

  public static final String userTitle[][] = {
    {"Tambah", "Edit"}, {"Add", "Edit"}
  };
%>

<%
  CtrlDeposito ctrlDeposito = new CtrlDeposito(request);
  long depositoOID = FRMQueryString.requestLong(request, FrmDeposito.fieldNames[FrmDeposito.FRM_FLD_ID_DEPOSITO]);
  int prevCommand = FRMQueryString.requestInt(request, "prev_command");
  int iCommand = FRMQueryString.requestCommand(request);
  int iErrCode = FRMMessage.ERR_NONE;

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

  iErrCode = ctrlDeposito.Action(iCommand, depositoOID);
  errMsg = ctrlDeposito.getMessage();
  FrmDeposito frmDeposito = ctrlDeposito.getForm();
  Deposito deposito = ctrlDeposito.getDeposito();

//	if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmAnggota.errorSize()<1)){
  if (iCommand == Command.DELETE) {
%>
<jsp:forward page="deposito.jsp">
  <jsp:param name="prev_command" value="<%=prevCommand%>" />
  <jsp:param name="start" value="<%=start%>" />
  <jsp:param name="ID_DEPOSITO" value="<%=deposito.getOID()%>" />
</jsp:forward>
<%}%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>SEDANA</title>
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
    <script language="JavaScript">
      function updateAnggota(frmID) {
        oidAnggota = document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_ANGGOTA]%>.value;
        window.open("<%=approot%>/masterdata/transaksi/select_anggota.jsp?formName=<%=frmDeposito.FRM_DEPOSITO_NAME%>&frmFieldIdAnggotaName=" + frmID + "&<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_DEPOSITO]%>=<%=String.valueOf(depositoOID)%>" +
                "<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ID_ANGGOTA]%>=" + oidAnggota + "",
                null, "height=430, width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
      }

      function updateJenisDeposito() {
        oidJenisDeposito = document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_JENIS_DEPOSITO]%>.value;
        window.open("<%=approot%>/masterdata/transaksi/select_jenis_deposito.jsp?formName=<%=frmDeposito.FRM_DEPOSITO_NAME%>&<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_DEPOSITO]%>=<%=String.valueOf(depositoOID)%>" +
                    "<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>=" + oidJenisDeposito + "",
                    null, "height=350, width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
          }

          function cmdAdd() {
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value = "<%=Command.ADD%>";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action = "deposito_edit.jsp";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_DEPOSITO]%>.value = 0;
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
          }

          function cmdCancel() {
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value = "<%=Command.CANCEL%>";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action = "deposito_edit.jsp";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
          }

          function cmdEdit(oid) {
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value = "<%=Command.EDIT%>";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action = "doposito_edit.jsp";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
          }

          function cmdSave() {
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value = "<%=Command.SAVE%>";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action = "deposito_edit.jsp";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
          }

          function cmdAsk(oid) {
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value = "<%=Command.ASK%>";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action = "deposito_edit.jsp";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
          }

          function cmdConfirmDelete(oid) {
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value = "<%=Command.DELETE%>";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action = "deposito_edit.jsp";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
          }

          function cmdBack() {
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value = "<%=Command.FIRST%>";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action = "deposito.jsp";
            document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
          }
    </script>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body style="background-color: #eaf3df; padding-bottom: 40px;">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Laporan Tabungan
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><i class="fa fa-edit"></i> Transaksi</li>
        <li class="active">Deposito</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
      <div class="row">
        <div class="col-xs-12">
          <!-- Horizontal Form -->
          <div class="box box-success">
            <div class="box-header with-border">
              <h3 class="box-title">Form Deposito</h3>
            </div>
            <!-- /.box-header -->
            <!-- form start -->
            <form name="<%=frmDeposito.FRM_DEPOSITO_NAME%>" class="form-horizontal" method="post" action="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_DEPOSITO]%>" value="<%=deposito.getOID()%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <div class="box-body">
                <div class="col-xs-6">
                  <div class="form-group">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][6]%></label>
                    <div class="col-sm-8">
                      <%
                        String date = "-";
                        if (deposito.getTanggalPengajuanDeposito() != null) {
                          date = Formater.formatDate(deposito.getTanggalPengajuanDeposito(), "MMM, dd yyyy");
                        }
                      %>
                      <span style="vertical-align: bottom; display: inline-block; margin-top: 8px;" class="text-success"><%=date%></span>
                      <input type="hidden" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_TGL_PENGAJUAN_DEPOSITO]%>" value="<%=deposito.getTanggalPengajuanDeposito()%>" class="form-control">
                    </div>
                  </div>
                  <div class="form-group <%=(frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_ID_ANGGOTA).equals("")) ? "" : "has-error"%>">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][0]%>*</label>
                    <div class="col-sm-8">
                      <%
                        Anggota anggota = new Anggota();
                        if (deposito.getIdAnggota() != 0) {
                          try {
                            anggota = PstAnggota.fetchExc(deposito.getIdAnggota());
                          } catch (Exception e) {
                            anggota = new Anggota();
                          }
                        }
                      %>
                      <input class="formElemen form-control" type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]%>" readonly="true" value="<%=anggota.getNoAnggota()%>" size="40" onClick="javascript:updateAnggota('<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_ANGGOTA]%>')">
                      <input class="formElemen" type="hidden" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_ANGGOTA]%>" value="<%="" + deposito.getIdAnggota()%>" size="40">
                      <%=(frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_ID_ANGGOTA).equals("")) ? "" : "<span class='help-block'>" + frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_ID_ANGGOTA) + "</span>"%>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][1]%></label>
                    <div class="col-sm-8">
                      <input class="formElemen form-control"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>" value="<%="" + anggota.getName()%>" size="40">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][3]%></label>
                    <div class="col-sm-8">
                      <input class="formElemen form-control"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_REKENING]%>" value="<%="" + anggota.getNoRekening()%>" size="40">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][2]%></label>
                    <div class="col-sm-8">
                      <input class="formElemen form-control"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PERMANENT]%>" value="<%="" + anggota.getAddressPermanent()%>" size="40">
                    </div>
                  </div>
                </div>
                <!--/.col (left) -->
                <div class="col-xs-6">
                  <div class="form-group <%=(frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_STATUS).equals("")) ? "" : "has-error"%>">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][11]%>*</label>
                    <div class="col-sm-8">
                      <%
                        ControlCombo combo = new ControlCombo();
                        Vector keyStatus = PstDeposito.getStatusDepositoKey();
                        Vector valueStatus = PstDeposito.getStatusDepositoValue();
                      %> 
                      <%=combo.draw(frmDeposito.fieldNames[frmDeposito.FRM_FLD_STATUS], "formElemen form-control", "Select...", "" + deposito.getStatus(), valueStatus, keyStatus)%> 
                      <%=(frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_STATUS).equals("")) ? "" : "<span class='help-block'>" + frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_STATUS) + "</span>"%>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][4]%></label>
                    <div class="col-sm-8">
                      <%
                        JenisDeposito jenisDeposito = new JenisDeposito();
                        if (deposito.getIdJenisDeposito() != 0) {
                          try {
                            jenisDeposito = PstJenisDeposito.fetchExc(deposito.getIdJenisDeposito());
                          } catch (Exception e) {
                            jenisDeposito = new JenisDeposito();
                          }
                        }
                      %>
                      <input class="formElemen form-control"  type="text" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_NAMA_JENIS_DEPOSITO]%>" readonly="true" value="<%=jenisDeposito.getNamaJenisDeposito()%>" size="40" onClick="javascript:updateJenisDeposito()">
                      <input type="hidden" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_JENIS_DEPOSITO]%>" value="<%="" + deposito.getIdJenisDeposito()%>" >
                    </div>
                  </div>
                  <%--
                  <div class="form-group <%=(frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_ID_KELOMPOK).equals("")) ? "" : "has-error"%>">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][5]%>*</label>
                    <div class="col-sm-8">
                      <style>
                        .msginfo, .msgerror { display: block; position: absolute; left: 0; padding-left: 10px; padding-top: 5px; font-weight: bold; }
                        .msginfo { color: #00a65a; }
                        .msgerror { color: rgb(221, 75, 57); }
                      </style>
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
                      <%=comboBox.draw(frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_KELOMPOK], "formElemen form-control", "Select...", "" + deposito.getIdKelompokKoperasi(), kelompokValue, kelompokKey)%> 
                      <%=(frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_ID_KELOMPOK).equals("")) ? "" : "<span class='help-block'>" + frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_ID_KELOMPOK) + "</span>"%>
                    </div>
                  </div>
                  --%>
                  <div class="form-group <%=(frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_JUMLAH_DEPOSITO).equals("")) ? "" : "has-error"%>">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][7]%>*</label>
                    <div class="col-sm-8">
                      <input type="text" class="form-control" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_JUMLAH_DEPOSITO]%>" value="<%=Formater.formatNumber(deposito.getJumlahDeposito(), "#.##")%>">
                      <%=(frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_JUMLAH_DEPOSITO).equals("")) ? "" : "<span class='help-block'>" + frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_JUMLAH_DEPOSITO) + "</span>"%>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][8]%></label>
                    <div class="col-sm-8">
                      <input class="formElemen form-control"  type="text" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_PROVISI]%>" value="<%="" + Formater.formatNumber(jenisDeposito.getProvisi(), "#.##")%>" size="40">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][9]%></label>
                    <div class="col-sm-8">
                      <input class="formElemen form-control"  type="text" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_BUNGA]%>" value="<%="" + Formater.formatNumber(jenisDeposito.getBunga(), "#.##")%>" size="40">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-4 control-label"><%=strTitle[SESS_LANGUAGE][10]%>*</label>
                    <div class="col-sm-8">
                      <input type="text" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_BIAYA_ADMIN]%>" value="<%=Formater.formatNumber(jenisDeposito.getBiayaAdmin(), "#.##")%>" class="formElemen form-control" maxlength="20" size="40">
                    </div>
                  </div>
                </div>
                <!--/.col (right) -->
              </div>
              <!-- /.box-body -->
              <div class="box-footer">
                <div class="pull-right">
                  <%
                    ctrLine.setLocationImg(approot + "/image/ctr_line");
                    ctrLine.initDefault();
                    ctrLine.setTableWidth("100%");
                    String scomDel = "javascript:cmdAsk('" + depositoOID + "')";
                    String sconDelCom = "javascript:cmdConfirmDelete('" + depositoOID + "')";
                    String scancel = "javascript:cmdEdit('" + depositoOID + "')";

                    ctrLine.setCommandStyle("command");
                    ctrLine.setColCommStyle("command");
                    ctrLine.setAddStyle("class=\"btn btn-primary\"");
                    ctrLine.setCancelStyle("class=\"btn btn-danger\"");
                    ctrLine.setDeleteStyle("class=\"btn btn-danger\"");
                    ctrLine.setBackStyle("class=\"btn btn-info\"");
                    ctrLine.setSaveStyle("class=\"btn btn-success\"");
                    ctrLine.setConfirmStyle("class=\"btn btn-primary\"");
                    ctrLine.setAddCaption("<i class=\"fa fa-plus-circle\"></i> "+"");
                    ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> "+strCancel);														
                    ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> "+"");														
                    ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> "+"");
                    ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> "+"");
                    ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> "+"");

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
                  %>
                  <%= ctrLine.draw(iCommand, iErrCode, errMsg)%> 
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
                            minView: 2, // No time
                            // showMeridian: 0
                          });
                        });
    </script>
    <%@ include file = "/footerkoperasi.jsp" %>
  </body>
</html>
