<%--
    Document   : anggota_edit
    Created on : Feb 28, 2013, 9:50:44 AM
    Author     : HaddyPuutraa
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
<%@page import="com.dimata.aiso.entity.masterdata.region.*" %>
<%@page import="com.dimata.aiso.form.masterdata.region.*" %>

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
      "Pendidikan Anda"},//25 tambahan untuk educasi
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
      "Your Education"}//25
  };

  public static final String systemTitle[] = {
    "Pendidikan", "Education"
  };

  public static final String userTitle[][] = {
    {"Tambah", "Edit"}, {"Add", "Edit"}
  };

  public static final String tabTitle[][] = {
    {"Data Pribadi", "Anggota Keluarga", "Registrasi Tabungan", "Pendidikan", "Data Tabungan", "Dokumen Bersangkutan"},
    {"Personal Date", "Family Member", "Saving Registration", "Education", "Saving Type", "Relevant Document"}
  };

  public static final String titleTabel[][] = {
    {"No", "Pendidikan", "Detail Pendidikan"}, {"Number", "Education", "Education of Detail"}
  };

  public String drawList(int iCommand, FrmAnggotaEducation frmObject, AnggotaEducation objEntity, Vector objectClass, long educationId, long anggotaId, int languange, int start) {
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("50%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
    ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");

    //create tabel
    ctrlist.addHeader(titleTabel[languange][0], "1%");
    ctrlist.addHeader(titleTabel[languange][1], "");
    ctrlist.addHeader(titleTabel[languange][2], "");

    //ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");
    Vector lstData = ctrlist.getData();
    //Vector lstLinkData = ctrlist.getLinkData();
    Vector rowx = new Vector(1, 1);
    ctrlist.reset();
    int index = -1;
    int number = start;

    //untuk list Education update tanggal 4 maret oleh hadi
    ControlCombo comboBox = new ControlCombo();
    int countEducation = PstEducation.getCount("");
    Vector listEducation = PstEducation.list(0, countEducation, "", PstEducation.fieldNames[PstEducation.FLD_EDUCATION]);
    Vector educationKey = new Vector(1, 1);
    Vector educationValue = new Vector(1, 1);
    for (int i = 0; i < listEducation.size(); i++) {
      Education education = (Education) listEducation.get(i);
      educationKey.add("" + education.getEducation());
      educationValue.add(String.valueOf(education.getOID()).toString());
    }

    for (int i = 0; i < objectClass.size(); i++) {
      number = number + 1;
      AnggotaEducation anggotaEducation = (AnggotaEducation) objectClass.get(i);
      rowx = new Vector();
      if (educationId == anggotaEducation.getEducationId()) {
        index = i;
      }

      Education education = new Education();
      if (anggotaEducation.getEducationId() != 0) {
        try {
          education = PstEducation.fetchExc(anggotaEducation.getEducationId());
        } catch (Exception e) {
          education = new Education();
        }
      }

      if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {

        rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[frmObject.FRM_ANGGOTA_ID] + "\" value=\"" + anggotaId + "\" class=\"\">" + number);
        rowx.add("" + comboBox.draw(FrmAnggotaEducation.fieldNames[FrmAnggotaEducation.FRM_EDUCATION_ID], "", "select...", "" + anggotaEducation.getEducationId(), educationValue, educationKey));
        rowx.add("<input type=\"text\" name=\"" + FrmAnggotaEducation.fieldNames[FrmAnggotaEducation.FRM_EDUCATION_DETAIL] + "\" value=\"" + anggotaEducation.getEducationDetail() + "\" class=\"\" size=\"60\">");
        
      } else {
        rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(anggotaEducation.getEducationId()) + "')\">" + number + "</a>");
        rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(anggotaEducation.getEducationId()) + "')\">" + education.getEducation() + "</a>");
        rowx.add(anggotaEducation.getEducationDetail());
      }
      lstData.add(rowx);

    }
    rowx = new Vector();

        //untuk membuat form input 
    //Education education = new Education();
    if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)) {
      rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[frmObject.FRM_ANGGOTA_ID] + "\" value=\"" + anggotaId + "\" class=\"\">");
      rowx.add("" + comboBox.draw(FrmAnggotaEducation.fieldNames[FrmAnggotaEducation.FRM_EDUCATION_ID], "", "select...", "" + objEntity.getEducationId(), educationValue, educationKey));
      rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[frmObject.FRM_EDUCATION_DETAIL] + "\" value=\"" + objEntity.getEducationDetail() + "\" class=\"\" size=\"60\">");
    }
    
    if (iCommand != Command.ADD && objectClass.isEmpty() && frmObject.errorSize() == 0) {
        rowx.add("<td class='listgensell' colspan='3'>Tidak ada data pendidikan</td>");
    }
    lstData.add(rowx);

    return ctrlist.draw(-1);
  }
%>

<%
  CtrlAnggotaEducation ctrlAnggotaEducation = new CtrlAnggotaEducation(request);
  int iCommand = FRMQueryString.requestCommand(request);
  int start = FRMQueryString.requestInt(request, "start");
  int prevCommand = FRMQueryString.requestInt(request, "prev_command");
  long oidAnggota = FRMQueryString.requestLong(request, "anggota_oid");
  long oidEducation = FRMQueryString.requestLong(request, "education_oid");
  
  Anggota anggota = new Anggota();
    try {
      anggota = PstAnggota.fetchExc(oidAnggota);
    } catch (Exception exc) {
      anggota = new Anggota();
    }

  int iErrCode = FRMMessage.ERR_NONE;
  String errMsg = "";
  String whereClause = "" + PstAnggotaEducation.fieldNames[PstAnggotaEducation.FLD_ANGGOTA_ID] + " = " + oidAnggota;
  String orderClause = "" + PstAnggotaEducation.fieldNames[PstAnggotaEducation.FLD_ANGGOTA_ID];
  int recordToGet = 10;

  //khusus untuk edit data reques dari anggota_test.jsp oleh hadi tanggal 2 Mret 2013
  /**
   * if(oidEducation != 0 && iCommand== Command.NONE && iCommand !=
   * Command.SAVE){ iCommand = Command.EDIT; }else{ iCommand =
   * FRMQueryString.requestCommand(request); }
   */
  ControlLine ctrLine = new ControlLine();
  ctrLine.setLanguage(SESS_LANGUAGE);
  String currPageTitle = systemTitle[SESS_LANGUAGE];
  String strAddMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
  String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
  String strAskMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
  String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
  String strBackMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
  String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
  String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";

  iErrCode = ctrlAnggotaEducation.action(iCommand, oidAnggota, oidEducation);

  errMsg = ctrlAnggotaEducation.getMessage();
  FrmAnggotaEducation frmAnggotaEducation = ctrlAnggotaEducation.getForm();
  AnggotaEducation anggotaEducation = ctrlAnggotaEducation.getAnggotaEducation();

  Vector listAnggotaEducation = new Vector(1, 1);
  int vectSize = PstAnggotaEducation.getCount(whereClause);
  if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
    start = ctrlAnggotaEducation.actionList(iCommand, start, vectSize, recordToGet);
  }
  listAnggotaEducation = PstAnggotaEducation.list(start, recordToGet, whereClause, orderClause);
  if (listAnggotaEducation.size() < 1 && start > 0) {
    if (vectSize - recordToGet > recordToGet) {
      start = start - recordToGet;
    } else {
      start = 0;
      iCommand = Command.FIRST;
      prevCommand = Command.FIRST;
    }
    listAnggotaEducation = PstAnggotaEducation.list(start, recordToGet, whereClause, orderClause);
  }

  if (iCommand == Command.DELETE) {
  }
%>

<!-- End of Jsp Block -->
<html>
  <!-- #BeginTemplate "/Templates/maintab.dwt" -->
  <head>
    <!-- #BeginEditable "doctitle" -->
    <title>Koperasi - Anggota</title>
    <script language="JavaScript">

      function cmdAdd() {
        document.frmAnggotaEducation.command.value = "<%=Command.ADD%>";
        document.frmAnggotaEducation.education_oid.value = 0;
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }
      function cmdCancel() {
        document.frmAnggotaEducation.command.value = "<%=Command.CANCEL%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

      function cmdEdit(oidEducation) {
        document.frmAnggotaEducation.education_oid.value = oidEducation;
        document.frmAnggotaEducation.command.value = "<%=Command.EDIT%>";
        document.frmAnggotaEducation.prev_command.value = "<%=prevCommand%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

      function cmdSave() {
        document.frmAnggotaEducation.command.value = "<%=Command.SAVE%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

      function cmdAsk(oidEducation) {
        document.frmAnggotaEducation.education_oid.value = oidEducation;
        document.frmAnggotaEducation.command.value = "<%=Command.ASK%>";
        document.frmAnggotaEducation.prev_command.value = "<%=prevCommand%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

      function cmdConfirmDelete(oid) {
        document.frmAnggotaEducation.command.value = "<%=Command.DELETE%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

      function cmdBack() {
        document.frmAnggotaEducation.command.value = "<%=Command.FIRST%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

      function cmdListFirst() {
        document.frmAnggotaEducation.command.value = "<%=Command.FIRST%>";
        document.frmAnggotaEducation.prev_command.value = "<%=Command.FIRST%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

      function cmdListPrev() {
        document.frmAnggotaEducation.command.value = "<%=Command.PREV%>";
        document.frmAnggotaEducation.prev_command.value = "<%=Command.PREV%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

      function cmdListNext() {
        document.frmAnggotaEducation.command.value = "<%=Command.NEXT%>";
        document.frmAnggotaEducation.prev_command.value = "<%=Command.NEXT%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

      function cmdListLast() {
        document.frmAnggotaEducation.command.value = "<%=Command.LAST%>";
        document.frmAnggotaEducation.prev_command.value = "<%=Command.LAST%>";
        document.frmAnggotaEducation.action = "anggota_education.jsp";
        document.frmAnggotaEducation.submit();
      }

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
<!--

      function hideObjectForEmployee() {
      }

      function hideObjectForLockers() {
      }

      function hideObjectForCanteen() {
      }

      function hideObjectForClinic() {
      }

      function hideObjectForMasterdata() {
      }

      function MM_swapImgRestore() { //v3.0
        var i, x, a = document.MM_sr;
        for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++)
          x.src = x.oSrc;
      }

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

      //-->
    </SCRIPT>
    <!-- #EndEditable -->
    <style>
        .tabel_info_anggota {width: 50%}
        .tabel_info_anggota td {padding: 5px; vertical-align: text-top}
        
        #tabel_tab_menu {width: 100%; border-collapse: collapse}
        #tabel_tab_menu {border-color: transparent}
        #tabel_tab_menu a {color: black}
        #tabel_tab_menu td {background-color: lightgray; border-color: #eaf3df; text-decoration: none;}
        
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
                    <td width="20%" style="background-color: #337ab7;">
                        <!-- Pendidikan-->
                        <div align="center">
                            <a href="anggota_education.jsp?anggota_oid=<%=oidAnggota%>" style="color: white"><%=tabTitle[SESS_LANGUAGE][3]%></a>
                        </div>
                    </td>
                    <td width="20%">
                        <!-- Keluarga Anggota-->
                        <div align="center">
                            <a href="anggota_family.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][1]%></a>
                        </div>
                    </td>
                    <%if(useRaditya == 1){}else{%>
                    <td width="20%">
                        <!-- Data Tabungan-->
                        <div align="center">
                            <a href="anggota_tabungan.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][4]%></a>
                        </div>
                    </td>
                    <%}%>
                    <td width="20%">
                        <!-- Dokumen Bersangkutan-->
                        <div align="center">
                            <a href="anggota_dokumen.jsp?anggota_oid=<%=oidAnggota%>"><%=tabTitle[SESS_LANGUAGE][5]%></a>
                        </div>
                    </td>
                </tr>
            </table>

            <form name="frmAnggotaEducation" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="anggota_oid" value="<%=oidAnggota%>">
                <input type="hidden" name="education_oid" value="<%=oidEducation%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                
                <br>
                <table class="tabel_info_anggota">
                    <tr>
                        <td style="width: 50px">Nama</td>
                        <td>: <%= anggota.getName() %></td>
                    </tr>
                    <tr>
                        <td>Nomor</td>
                        <td>: <%= anggota.getNoAnggota() %></td>
                    </tr>
                </table>
                
                <br>
                <%= drawList(iCommand, frmAnggotaEducation, anggotaEducation, listAnggotaEducation, oidEducation, oidAnggota, SESS_LANGUAGE, start)%>
                
                <br>
                <%
                    int cmd = 0;
                    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
                        cmd = iCommand;
                    } else {
                        if (iCommand == Command.NONE || prevCommand == Command.NONE) {
                            cmd = Command.FIRST;
                        } else {
                            cmd = prevCommand;
                        }
                    }
                %>
                <%=ctrLine.drawMeListLimit(cmd, vectSize, start, recordToGet, "cmdListFirst", "cmdListPrev", "cmdListNext", "cmdListLast", "left")%>
                
                <%
                    ctrLine.initDefault();
                    ctrLine.setTableWidth("80%");
                    String scomDel = "javascript:cmdAsk('" + oidEducation + "')";
                    String sconDelCom = "javascript:cmdConfirmDelete('" + oidEducation + "')";
                    String scancel = "javascript:cmdEdit('" + oidEducation + "')";
                    ctrLine.setCommandStyle("command");
                    ctrLine.setColCommStyle("command");
                    ctrLine.setAddStyle("class=\"btn-primary btn-sm\"");
                    ctrLine.setCancelStyle("class=\"btn-delete btn-sm\"");
                    ctrLine.setDeleteStyle("class=\"btn-delete btn-sm\"");
                    ctrLine.setBackStyle("class=\"btn-primary btn-sm\"");
                    ctrLine.setSaveStyle("class=\"btn-save btn-sm\"");
                    ctrLine.setConfirmStyle("class=\"btn-primary btn-sm\"");
                    ctrLine.setAddCaption("<i class=\"fa fa-plus-circle\"></i> " + strAddMar);
                    //ctrLine.setBackCaption("");
                    ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
                    ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackMar);
                    ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveMar);
                    ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskMar);
                    ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> " + strDeleteMar);

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

                    if (iCommand == Command.EDIT) {
                        iCommand = Command.EDIT;
                    }
                %>
                <%= ctrLine.draw(iCommand, iErrCode, errMsg)%>
                                                                    
            </form>
            
        </section>

                <%--
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="30%" bgcolor="#F9FCFF">
      <tr> 
        <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
          <b><%=systemTitle[SESS_LANGUAGE]%> > <%=oidAnggota != 0 ? userTitle[SESS_LANGUAGE][1].toUpperCase() : userTitle[SESS_LANGUAGE][0].toUpperCase()%></b>
        </td>
      </tr>
      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="88%" valign="top" align="left">
                <table width="100%" border="0" cellspacing="3" cellpadding="2">
                  <tr>
                    <td width="100%">
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td valign="top">
                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                    <tr>
                                      <td valign="top"> <!-- #BeginEditable "content" -->
                                        <form name="" method="post" action="">
                                          <input type="hidden" name="command" value="<%=iCommand%>">
                                          <input type="hidden" name="start" value="<%=start%>">
                                          <input type="hidden" name="anggota_oid" value="<%=oidAnggota%>">
                                          <input type="hidden" name="education_oid" value="<%=oidEducation%>">
                                          <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">

                                            <% if (oidAnggota != 0) {%>
                                            <tr>
                                              <td>
                                                <br>
                                                
                                              </td>
                                            </tr>
                                            <%} else {%>
                                            <tr>
                                              <td>&nbsp;</td>
                                            </tr>
                                            <%}%>
                                            <tr>
                                              <td class="tablecolor">
                                                <table  width="98%" align="center" border="0" cellspacing="2" cellpadding="2" >
                                                  <tr>
                                                    <td valign="top">
                                                      <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                                        <tr>
                                                          <td valign="top" width="100%">
                                                            <table width="100%" border="0" cellspacing="2" cellpadding="2" >
                                                              <% if (oidAnggota != 0) {
                                                                  
                                                              %>
                                                              <tr>
                                                                <td colspan="5" height="20">&nbsp;</td>
                                                              </tr>
                                                              <tr>
                                                                <td width="2%" height="20">&nbsp;</td>
                                                                <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                                <td width="35%" class="comment" height="20">
                                                                  <div align="left">&nbsp;</div>
                                                                </td>
                                                                <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                                <td width="35%" height="20">&nbsp;</td>
                                                              </tr>
                                                              <tr>
                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                <!-- Untuk No Anggota-->
                                                                <td valign="top">
                                                                  <div align="left"><%=strTitle[SESS_LANGUAGE][0]%></div>
                                                                </td>
                                                                <td valign="top"> 
                                                                  :&nbsp;<%=anggota.getNoAnggota()%>
                                                                </td>
                                                              </tr>
                                                              <tr>
                                                                <td valign="top" height="25" >&nbsp;</td>
                                                                <!-- Untuk No Anggota-->
                                                                <td valign="top">
                                                                  <div align="left"><%=strTitle[SESS_LANGUAGE][1]%></div>
                                                                </td>
                                                                <td valign="top"> 
                                                                  :&nbsp;<%=anggota.getName()%>
                                                                </td>
                                                              </tr>
                                                              <%}
                                                                try {
                                                                  if (listAnggotaEducation.size() > 0 || iCommand == Command.ADD) {
                                                              %>
                                                              <tr align="left">
                                                                <td>&nbsp;</td>
                                                                <!--td><%=strTitle[SESS_LANGUAGE][25]%></td-->
                                                                <td colspan="3">
                                                                  <%= drawList(iCommand, frmAnggotaEducation, anggotaEducation, listAnggotaEducation, oidEducation, oidAnggota, SESS_LANGUAGE, start)%>
                                                                </td>
                                                              </tr> 
                                                              <tr align="left">
                                                                <td height="40">&nbsp;</td>
                                                                <td colspan="3">
                                                                  
                                                                </td>
                                                              </tr> 
                                                              <%} else {
                                                                String[] erorEducation = {"Data Pendidikan Kosong . . .", "No Member Education . . ."};
                                                              %>
                                                              <tr>
                                                                <td>&nbsp;</td>
                                                                <td>&nbsp;</td>
                                                                <td colspan="3"><font color="#FF6600"><%=erorEducation[SESS_LANGUAGE]%></font></td>
                                                              </tr>
                                                              <%
                                                                  }
                                                                } catch (Exception e) {
                                                                }
                                                              %>
                                                              <tr align="left">
                                                                <td valign="top"  >&nbsp;</td>
                                                                <td colspan="3"  valign="top"  >
                                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td> 
                                                                     
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
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
                                                                </td>
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
                                <td height="100%">
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
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td colspan="2" height="20" bgcolor="#9BC1FF"> <!-- #BeginEditable "footer" -->
                <%@ include file = "../../main/footer.jsp" %>
                <!-- #EndEditable --> </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
                --%>
  </body>
</html>
