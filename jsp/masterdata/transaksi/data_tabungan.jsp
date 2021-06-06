<%-- 
    Document   : data tabungan
    Created on : Mar 18, 2013, 3:33:36 PM
    Author     : dede nuharta
--%>

<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.sedana.form.tabungan.CtrlDataTabungan"%>
<%@page import="com.dimata.sedana.form.tabungan.FrmDataTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.AssignContact"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstAssignContact"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.ajax.transaksi.AjaxSetoran"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.searchtabungan.SearchTabungan"%>
<%@page import="com.dimata.sedana.form.searchtabungan.FrmSearchTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="java.io.Console"%>
<%@page language="java" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
<%@page import="com.dimata.aiso.entity.masterdata.transaksi.*" %>
<%@page import="com.dimata.aiso.form.masterdata.transaksi.*"%>

<%@include file="../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../main/checkuser.jsp" %>

<% if (userOID != 0) { %>
<%
  Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
  if (open.size() < 1) {
    String redirectUrl = approot + "/tellershift/open_teller_shift.jsp?redir=" + approot + "/masterdata/transaksi/data_tabungan.jsp";
    response.sendRedirect(redirectUrl);
  }

  /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
  boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
  boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
  boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
  boolean privPrint = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
%>

<%
  FrmSearchTabungan frmSearchTabungan = new FrmSearchTabungan(request);
  SearchTabungan searchTabungan = frmSearchTabungan.getEntityObject();
%>

<%!
  public static String strTitle[][] = {
    {"Tanggal",//0
      "Nomor Tabungan",//1
      "Nama",//2
      "Teller",//
      "Setoran (Rp)",//4
    },
    {"Date",//0
      "Account No.",//1
      "Name",//2
      "Teller",//3
      "Amount (Rp)",//4
    }
  };

  public static final String systemTitle[] = {
    "Data Tabungan", "Data Saving"
  };

  public static final String userTitle[] = {
    "Transaksi", "Transaction"
  };

  public String drawListDataTabungan(int language, Vector objectClass, long oid, Vector listSaldo, SearchTabungan parameter) {
    String temp = "";
    String regdatestr = "";
    
    String idJenisSimpanan = "";
    for(long id: parameter.getIdJenisSimpanan()) {
      if(!idJenisSimpanan.equals("")) { idJenisSimpanan+=", "; }
      idJenisSimpanan+=id;
    }

    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("100%");
    ctrlist.setListStyle("table table-bordered");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
    ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");

    //untuk tabel
    ctrlist.dataFormat(strTitle[language][0], "10%", "left", "left");
    ctrlist.dataFormat(strTitle[language][1], "10%", "left", "left");
    ctrlist.dataFormat(strTitle[language][2], "10%", "left", "left");
    ctrlist.dataFormat(strTitle[language][3], "10%", "left", "left");
    ctrlist.dataFormat(strTitle[language][4], "10%", "right", "right");
    ctrlist.dataFormat("Status", "10%", "left", "left");
    ctrlist.dataFormat("Aksi", "1%", "center", "center");

    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");
    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();
    ctrlist.setLinkPrefix("javascript:cmdEdit('");
    ctrlist.setLinkSufix("')");
    ctrlist.reset();
    int index = -1;

    String tgl = "";
    for (int i = 0; i < objectClass.size(); i++) {
      String totSaldo = "";
      Transaksi trx = (Transaksi) objectClass.get(i);
      if (oid == trx.getOID()) {
        index = i;
      }

      Vector rowx = new Vector();
      ContactList cl = new ContactList();
      CashTeller teller = new CashTeller();
      AppUser tellerUser = new AppUser();
      PstDetailTransaksi pstDetailTransaksi = new PstDetailTransaksi();
      try {
        cl = PstContactList.fetchExc(trx.getIdAnggota());
        teller = PstCashTeller.fetchExc(trx.getTellerShiftId());
        tellerUser = PstAppUser.fetch(teller.getAppUserId());
      } catch (Exception e) {

      }
      
      Vector<DetailTransaksi> sdt = PstDetailTransaksi.list(0, 1, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID]+"="+trx.getOID(), "");
      String noTabungan = "";
      try {
        DataTabungan dt = PstDataTabungan.fetchExc(sdt.get(0).getIdSimpanan());
        AssignContact a = PstAssignContact.fetchExc(dt.getAssignTabunganId());
        noTabungan = a.getNoTabungan(); 
      } catch(Exception e) {
        
      }
      
      if (trx.getTanggalTransaksi() != null) {
        try {
          tgl = Formater.formatDate(trx.getTanggalTransaksi(), "MMM, dd yyyy HH:mm:ss");
        } catch (Exception e) { 
          tgl = "";
        }
      } else {
        tgl = "";
      }
      rowx.add(String.valueOf(tgl));
      rowx.add(String.valueOf(noTabungan));
      rowx.add(String.valueOf(cl.getPersonName()));
      rowx.add(String.valueOf(tellerUser.getFullName()));
      rowx.add(String.valueOf("<div class='money'>"+pstDetailTransaksi.getTotalSaldo(trx.getOID(), idJenisSimpanan)+"</div>"));
      rowx.add("" + Transaksi.STATUS_DOC_TRANSAKSI_TITLE[trx.getStatus()]);
      rowx.add(String.valueOf("<a class=\"btn-success btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('" + trx.getOID() + "')\">Lihat</a>"));

      lstData.add(rowx);
      lstLinkData.add(String.valueOf(trx.getOID()));
    }
    return ctrlist.drawMe(index);
  }
%>

<%
  /* GET REQUEST FROM HIDDEN TEXT */
  int iCommand = FRMQueryString.requestCommand(request);
  int start = FRMQueryString.requestInt(request, "start");
  long dataTabunganOID = FRMQueryString.requestLong(request, FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_ID_SIMPANAN]);
  int prevCommand = FRMQueryString.requestInt(request, "prev_command");

  int listCommand = FRMQueryString.requestInt(request, "list_command");
  if (listCommand == Command.NONE) {
    listCommand = Command.LIST;
  }

  /* VARIABLE DECLARATION */
  ControlLine ctrLine = new ControlLine();
  ctrLine.setLanguage(SESS_LANGUAGE);

  String currPageTitle = userTitle[SESS_LANGUAGE];
  String strAddDataTabungan = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);

  int recordToGet = 10;
  String whereClause = PstTransaksi.fieldNames[PstTransaksi.FLD_TIPE_ARUS_KAS]+" = '" + Transaksi.TIPE_ARUS_KAS_BERTAMBAH + "'"
          + " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]+" IN "
          + " (SELECT "+PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID]+""
          + " FROM "+PstDetailTransaksi.TBL_DETAILTRANSAKSI+")";
  String order = " " + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ";

  CtrlDataTabungan ctrlDataTabungan = new CtrlDataTabungan(request);
  int vectSize = PstDataTabungan.getCount("");

  if (iCommand != Command.BACK) {
    start = ctrlDataTabungan.actionList(iCommand, start, vectSize, recordToGet);
  } else {
    iCommand = Command.LIST;
  }
 
%>

<!DOCTYPE html>
<html>
  <head>
    <title>SEDANA</title>
    <style>
        .table {font-size: 14px}
    </style>
    <script language="JavaScript">
      <%if (privAdd) {%>
      function addNew() {
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.<%=FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_ID_SIMPANAN]%>.value = 0;
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.list_command.value = "<%=listCommand%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.command.value = "<%=Command.ADD%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.action = "<%=approot%>/Setoran";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
      }
      <%}%>

      function cmdEdit(oid) {
      <%if (privUpdate) {%>
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.oid.value = oid;
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.list_command.value = "<%=listCommand%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.command.value = "<%=Command.EDIT%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.action = "<%=approot%>/Setoran";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
      <%}%>
      }

      function first() {
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.command.value = "<%=Command.FIRST%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.list_command.value = "<%=Command.FIRST%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.action = "data_tabungan.jsp";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
      }

      function prev() {
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.command.value = "<%=Command.PREV%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.list_command.value = "<%=Command.PREV%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.action = "data_tabungan.jsp";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
      }

      function next() {
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.command.value = "<%=Command.NEXT%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.list_command.value = "<%=Command.NEXT%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.action = "data_tabungan.jsp";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
      }

      function last() {
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.command.value = "<%=Command.LAST%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.list_command.value = "<%=Command.LAST%>";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.action = "data_tabungan.jsp";
        document.<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>.submit();
      }
    </script>
    <%@ include file = "/style/lte_head.jsp" %>
  </head>
  <body style="background-color: #eaf3df;">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Daftar Penambahan Tabungan
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="/sedana_v1/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
        <li>Laporan</li>
        <li class="active">Tabungan</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
      <div class="row">
        <div class="col-xs-12">
          <!-- Horizontal Form -->
          <div class="box box-success">
            <div class="box-header with-border">
              <h3 class="box-title">Pencarian</h3>
            </div>
            <!-- /.box-header -->
            <!-- form start -->
            <form class="form-horizontal" method="post">
              <input type="hidden" value="<%=iCommand%>" class="hidden" name="cmd">
              <div class="box-body">
                <div class="row">
                <div class="col-sm-6">
                  <div class="form-group">
                    <label class="col-sm-3 control-label"><%=namaNasabah%></label>
                    <div class="col-sm-9">
                      <input name="<%=FrmSearchTabungan.FRM_FIELD_NASABAH_ID %>" value="<%=searchTabungan.getOID() %>" type="number" min="1" required="" id="search-memberOID" class="hidden" placeholder="">
                      <div style="padding-left: 0;" class="col-sm-6">
                        <input name="<%=FrmSearchTabungan.FRM_FIELD_NASABAH_NO_REKENING %>" value="<%=searchTabungan.getNoRekening() %>" type="text" data-onselect="setTabungan" data-action="<%=approot + "/Setoran"%>" data-for="<%=AjaxSetoran.SEARCH_NO_TABUNGAN%>" required="" class="form-control autocomplete" id="search-personRekening" placeholder="No. Tabungan" style="margin-bottom: 5px;">
                      </div>
                      <div style="padding-right: 0;" class="col-sm-6">
                        <input name="<%=FrmSearchTabungan.FRM_FIELD_NASABAH_NAMA %>" value="<%=searchTabungan.getNama() %>" type="text" data-onselect="setMemberName" data-action="<%=approot + "/Setoran"%>" data-for="<%=AjaxSetoran.SEARCH_MEMBER_NAME%>" required="" class="form-control autocomplete" id="search-personName" placeholder="Nama">
                      </div>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-3 control-label">Jenis Item</label>
                    <div class="col-sm-9">
                      <select name="<%=FrmSearchTabungan.FRM_FIELD_JENIS_SIMPANAN %>" placeholder="Semua" class="form-control select2" multiple="">
                        <% Vector<JenisSimpanan> jss = PstJenisSimpanan.list(0, 0, "", PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]); %>
                        <% for (JenisSimpanan js : jss) {%>
                        <option <%=(searchTabungan.isIdJenisSimpanan(js.getOID())) ? "selected" : ""%> value="<%=js.getOID()%>"><%=js.getNamaSimpanan()%></option>
                        <% }%>
                      </select>
                    </div>
                  </div>
                </div>
                <div class="col-sm-6">
                  <div class="form-group">
                    <label class="col-sm-3 control-label">Tanggal Awal</label>
                    <div class="col-sm-9">
                        <input name="<%=FrmSearchTabungan.FRM_FIELD_START_DATE %>" value="<%=Master.date2String(searchTabungan.getTanggalAwal(), "yyyy-MM-dd") %>" type="text" data-date-format="yyyy-mm-dd" class="form-control datetime-picker" autocomplete="off" placeholder="">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-3 control-label">Tanggal Akhir</label>
                    <div class="col-sm-9">
                        <input name="<%=FrmSearchTabungan.FRM_FIELD_END_DATE %>" value="<%=Master.date2String(searchTabungan.getTanggalAkhir(), "yyyy-MM-dd") %>" type="text" data-date-format="yyyy-mm-dd" class="form-control datetime-picker" autocomplete="off" placeholder="">
                    </div>
                  </div>
                </div>
                </div>
                <!-- /.box-footer -->
              </div>
              <!-- /.box-body -->
              <div class="box-footer">
                  <button type="submit" class="btn btn-sm btn-success pull-right"><i class="fa fa-search"></i> Cari</button>
              </div>
              <!-- /.box-footer -->
            </form>
          </div>
        </div>
        <!--/.col (right) -->
      </div>
      <div class="row">
        <div class="col-xs-12">
          <!-- Horizontal Form -->
          <div class="box box-success">
            <div class="box-header with-border">
              <h3 class="box-title">Daftar Setoran</h3>
            </div>
            <div class="box-body">
              <form name="<%=FrmDataTabungan.FRM_TABUNGAN_NAME%>" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                <input type="hidden" name="list_command" value="<%=listCommand%>">
                <input type="hidden" name="<%=FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_ID_SIMPANAN]%>" value="<%=dataTabunganOID%>"> 
                <input type="hidden" name="oid" value="<%=dataTabunganOID%>"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="3"> 
                      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">     
                        <tr align="left" valign="top"> 
                          <td height="8" align="left" colspan="3" class="command"> 
                              <% if (privAdd) {%>
                              <button class="btn btn-sm btn-success" onclick="javascript:addNew()"><i class="fa fa-plus"></i> <%=strAddDataTabungan%></button>
                              <%}%>
                          </td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="8" valign="middle" colspan="3">&nbsp;</td>
                        </tr>
                        <tr>
                          <td></td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td width="100%" height="22" valign="middle" colspan="3">
                          <%
                            if (searchTabungan.getOID() != 0) {
                                whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]+" IN ("+PstAssignContact.queryTransaksiId(searchTabungan.getNoRekening())+")";
                              }
                              if(searchTabungan.getIdJenisSimpanan().size() > 0) {
                                whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]+" IN ("+PstDetailTransaksi.queryGetTransaksiByJenisSimpanan(searchTabungan.getIdJenisSimpanan())+")";
                              }
                              if(searchTabungan.getTanggalAwal() != null) {
                                whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+" >= '"+Master.date2String(searchTabungan.getTanggalAwal())+"'";
                              }
                              
                              if(searchTabungan.getTanggalAkhir() != null) {
                                Date e = (Date) searchTabungan.getTanggalAkhir().clone();
                                e.setDate(e.getDate()+1);
                                whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+" <= '"+Master.date2String(searchTabungan.getTanggalAkhir())+"'";
                              }
                              
                              Vector listDataTabungan = PstTransaksi.list(start, recordToGet, whereClause, order);
                              Vector listTotalSaldo = new Vector();
                          %>
                          <%=drawListDataTabungan(SESS_LANGUAGE, listDataTabungan, dataTabunganOID, listTotalSaldo, searchTabungan)%>  
                          </td>
                        </tr>
                        <%--tr align="left" valign="top">
                          <td height="8" align="left" colspan="3" class="command">
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
                          </td>
                        </tr--%>
                        <tr align="left" valign="top">
                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                        </tr>
                        
                      </table>
                    </td>
                  </tr>
                </table>
              </form>
            </div>
          </div>
        </div>
      </div>
    </section>
  </body>
</html>
<% } %>