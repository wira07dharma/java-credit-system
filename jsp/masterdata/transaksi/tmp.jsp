<%--
    Document   : deposito_edit
    Created on : Mar 21, 2013, 9:50:44 AM
    Author     : HaddyPuutraa
--%>

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
    <!-- #EndEditable -->
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link rel="stylesheet" href="../../style/main.css" type="text/css">
    <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
    <script type="text/javascript" src="../../dtree/dtree.js"></script>
    <!-- #EndEditable --> 
  </head>
  <body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg')">


    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF">
      <tr>
        <td bgcolor="#9BC1FF"  valign="middle" height="15" class="contenttitle">
          <font color="#FF6600" face="Arial">
          <!-- #BeginEditable "contenttitle" -->
          <%=systemTitle[SESS_LANGUAGE]%>&nbsp;
          <%
            if (depositoOID != 0) {
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
                                        <form name="<%=frmDeposito.FRM_DEPOSITO_NAME%>" method="post" action="">
                                          <input type="hidden" name="start" value="<%=start%>">
                                          <input type="hidden" name="command" value="<%=iCommand%>">
                                          <input type="hidden" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_DEPOSITO]%>" value="<%=deposito.getOID()%>">
                                          <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td>&nbsp;</td>
                                            </tr>
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
                                                                  <input class="formElemen" type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]%>" readonly="true" value="<%=anggota.getNoAnggota()%>" size="40" onClick="javascript:updateAnggota('<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_ANGGOTA]%>')">*&nbsp;
                                                                  <input class="formElemen" type="hidden" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_ANGGOTA]%>" value="<%="" + deposito.getIdAnggota()%>" size="40">                                                                                                                                  
                                                                </td>
                                                                <td>&nbsp;</td>
                                                              </tr>
                                                              <tr>
                                                                <td>&nbsp;</td>
                                                                <td>&nbsp;</td>
                                                                <td>&nbsp;</td>
                                                                <td class="comment"><em>*) entry required</em></td>
                                                                <td>&nbsp;</td>
                                                                <td><%=strTitle[SESS_LANGUAGE][6]%></td>
                                                                <td>:</td>
                                                                <td>
                                                                  <%if (deposito.getTanggalPengajuanDeposito() != null) {%>
                                                                  <%=Formater.formatDate(deposito.getTanggalPengajuanDeposito(), "MMM, dd yyyy")%>
                                                                  <%}%>
                                                                  <input type="hidden" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_TGL_PENGAJUAN_DEPOSITO]%>" value="<%=deposito.getTanggalPengajuanDeposito()%>" class="form-control">
                                                                </td>
                                                                <td>&nbsp;</td>
                                                              </tr>
                                                              <tr>
                                                                <td>&nbsp;</td>
                                                                <!--nama anggota--->
                                                                <td><%=strTitle[SESS_LANGUAGE][1]%></td>
                                                                <td>:</td>
                                                                <td>
                                                                  <input class="formElemen form-control"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>" value="<%="" + anggota.getName()%>" size="40">
                                                                </td>
                                                                <td>&nbsp;</td>
                                                                <td>&nbsp;</td>
                                                                <td>&nbsp;</td>
                                                                <td>&nbsp;</td>
                                                                <td>&nbsp;</td>
                                                              </tr>
                                                              <tr>
                                                                <!--no rekening-->
                                                                <td>&nbsp;</td>
                                                                <td><%=strTitle[SESS_LANGUAGE][3]%></td>
                                                                <td>:</td>
                                                                <td><input class="formElemen form-control"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_REKENING]%>" value="<%="" + anggota.getNoRekening()%>" size="40"></td>
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
                                                                <td><input class="formElemen form-control"  type="text" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PERMANENT]%>" value="<%="" + anggota.getAddressPermanent()%>" size="40"></td>
                                                                <td>&nbsp;</td>
                                                                <!--status-->
                                                                <td><%=strTitle[SESS_LANGUAGE][11]%></td>
                                                                <td>:</td>
                                                                <%
                                                                  ControlCombo combo = new ControlCombo();
                                                                  Vector keyStatus = PstDeposito.getStatusDepositoKey();
                                                                  Vector valueStatus = PstDeposito.getStatusDepositoValue();
                                                                %>   
                                                                <td valign="top">
                                                                  <%=combo.draw(frmDeposito.fieldNames[frmDeposito.FRM_FLD_STATUS], "formElemen", null, "" + deposito.getStatus(), valueStatus, keyStatus)%> 
                                                                  * &nbsp;<%= frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_STATUS)%>
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
                                                                      <!--jenis deposito-->
                                                                      <td height="30">&nbsp;</td>
                                                                      <td><%=strTitle[SESS_LANGUAGE][4]%></td>
                                                                      <td>:</td>
                                                                      <td>
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
                                                                        <input class="formElemen form-control"  type="text" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_NAMA_JENIS_DEPOSITO]%>" readonly="true" value="<%=jenisDeposito.getNamaJenisDeposito()%>" size="40" onClick="javascript:updateJenisDeposito()">*&nbsp;
                                                                        <input type="hidden" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_JENIS_DEPOSITO]%>" value="<%="" + deposito.getIdJenisDeposito()%>" >
                                                                      </td>
                                                                      <td>&nbsp;</td>
                                                                      <!---pph-->
                                                                      <td><%=strTitle[SESS_LANGUAGE][8]%></td>
                                                                      <td>:</td>
                                                                      <td>
                                                                        <input class="formElemen form-control"  type="text" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_PROVISI]%>" value="<%="" + Formater.formatNumber(jenisDeposito.getProvisi(), "#.##")%>" size="40">
                                                                      </td>
                                                                      <td>&nbsp;</td>
                                                                    </tr>
                                                                    <tr>
                                                                      <!--jenis kelompok-->
                                                                      <td height="30">&nbsp;</td>
                                                                      <td><%=strTitle[SESS_LANGUAGE][5]%></td>
                                                                      <td>:</td>
                                                                      <td>
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
                                                                        <%=comboBox.draw(frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_KELOMPOK], "formElemen", "select...", "" + deposito.getIdKelompokKoperasi(), kelompokValue, kelompokKey)%> 
                                                                        &nbsp;<%=frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_ID_KELOMPOK)%>
                                                                      </td>
                                                                      <td>&nbsp;</td>
                                                                      <!--bunga--->
                                                                      <td><%=strTitle[SESS_LANGUAGE][9]%></td>
                                                                      <td>:</td>
                                                                      <td>
                                                                        <input class="formElemen form-control"  type="text" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_BUNGA]%>" value="<%="" + Formater.formatNumber(jenisDeposito.getBunga(), "#.##")%>" size="40">
                                                                      </td>
                                                                      <td>&nbsp;</td>
                                                                    </tr>
                                                                    <tr height="30">
                                                                      <td>&nbsp;</td>
                                                                      <!--jum lah deposito-->
                                                                      <td><%=strTitle[SESS_LANGUAGE][7]%></td>
                                                                      <td>:</td>
                                                                      <td>
                                                                        <input type="text" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_JUMLAH_DEPOSITO]%>" value="<%=Formater.formatNumber(deposito.getJumlahDeposito(), "#.##")%>">
                                                                        *&nbsp;<%=frmDeposito.getErrorMsg(frmDeposito.FRM_FLD_JUMLAH_DEPOSITO)%>
                                                                      </td>
                                                                      <td>&nbsp;</td>
                                                                      <!--biaya admin-->
                                                                      <td><%=strTitle[SESS_LANGUAGE][10]%></td>
                                                                      <td>:</td>
                                                                      <td>
                                                                        <input type="text" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_BIAYA_ADMIN]%>" value="<%=Formater.formatNumber(jenisDeposito.getBiayaAdmin(), "#.##")%>" class="formElemen form-control" maxlength="20" size="40">
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
                                                                        String scomDel = "javascript:cmdAsk('" + depositoOID + "')";
                                                                        String sconDelCom = "javascript:cmdConfirmDelete('" + depositoOID + "')";
                                                                        String scancel = "javascript:cmdEdit('" + depositoOID + "')";

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