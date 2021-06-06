
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksi"%>
<%@page import="com.dimata.qdep.db.DBException"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksiMapping"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksiMapping"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%  /* 
     * Page Name  		:  jenis_simpanan.jsp
     * Created on 		:  [date] [time] AM/PM 
     * 
     * @author  		:  [dede nuharta] 
     * @version  		:  [version] 
     */

    /**
     * *****************************************************************
     * Page Description : [project description ... ] Imput Parameters : [input
     * parameter ...] Output : [output ...]
     * *****************************************************************
     */
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package master -->
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*"%> 
<%@page import="com.dimata.gui.jsp.ControlList"%>

<%@include file="../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<%!
    public static final String textListTitle[][]
            = {
                {"Jenis Item"},
                {"Item Type"}
            };

    public static final String textListHeader[][]
            = {
                {"No", "Nama Item", "Setoran Minimal", "Bunga per Bulan", "Provisi", "Biaya Bulanan", "Keterangan", "Frekuensi Setoran", "Frekuensi Penarikan", "Basis Hari Bunga", "Aksi", "Jenis Bunga", "Tautan Denda"},
                {"No", "Item Name", "Minimum Deposit", "Interest per Month", "Provision", "Admin Costs per Month", "Description", "Frekuensi Simpanan", "Frekuensi Penarikan", "Basis Hari Bunga", "Action", "Jenis Bunga", "Penalty"}
            };

    public String drawList(int iCommand, FrmJenisSimpanan frmObject, JenisSimpanan objEntity, Vector objectClass, long jenisSimpananId, int languange, int vectorNumber, int start, String approot) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");

        ctrlist.addHeader(textListHeader[languange][0], "1%");
        ctrlist.addHeader(textListHeader[languange][1], "10%");
        ctrlist.addHeader(textListHeader[languange][7], "10%");
        ctrlist.addHeader(textListHeader[languange][8], "10%");
        ctrlist.addHeader(textListHeader[languange][11], "10%");
        ctrlist.addHeader(textListHeader[languange][9], "10%");
        ctrlist.addHeader(textListHeader[languange][2], "10%");
        ctrlist.addHeader(textListHeader[languange][4], "10%");
        ctrlist.addHeader(textListHeader[languange][5], "10%");
        ctrlist.addHeader(textListHeader[languange][6], "10%");
        //ctrlist.addHeader(textListHeader[languange][12], "5%");
        ctrlist.addHeader(textListHeader[languange][10], "1%");

        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int indexNumber = start;

        for (int i = 0; i < objectClass.size(); i++) {
            indexNumber = indexNumber + 1;
            JenisSimpanan jenisSimpanan = (JenisSimpanan) objectClass.get(i);
            rowx = new Vector();
            rowx.add("" + indexNumber + ".");
            rowx.add(String.valueOf(jenisSimpanan.getNamaSimpanan()));
            rowx.add("" + JenisSimpanan.FREKUENSI_SIMPANAN_TITLE[jenisSimpanan.getFrekuensiSimpanan()]);
            rowx.add("" + JenisSimpanan.FREKUENSI_PENARIKAN_TITLE[jenisSimpanan.getFrekuensiPenarikan()]);
            rowx.add("" + JenisSimpanan.BUNGA.get(jenisSimpanan.getJenisBunga())[languange]);
            rowx.add("" + Formater.formatNumber(jenisSimpanan.getBasisHariBunga(), "#"));
            rowx.add("<span class='money'>" + jenisSimpanan.getSetoranMin() + "</span>");
            rowx.add("<span class='money'>" + jenisSimpanan.getProvisi() + "</span>");
            rowx.add("<span class='money'>" + jenisSimpanan.getBiayaAdmin() + "</span>");
            rowx.add(String.valueOf(jenisSimpanan.getDescJenisSimpanan()));
            //rowx.add("<a href='" + approot + (jenisTransaksi.getOID() <= 0 ? "/sedana/masterbumdes/list_jenis_transaksi.jsp" : "/sedana/masterbumdes/jenis_transaksi.jsp?command=3&oid=" + jenisTransaksi.getOID()) + "'>" + (jenisTransaksi.getOID() > 0 ? (jenisTransaksi.getProsentasePerhitungan() > 0 ? jenisTransaksi.getProsentasePerhitungan() + "%" : jenisTransaksi.getValueStandarTransaksi()) : "link") + "</a>");
            rowx.add(String.valueOf("<center><a class=\"btn btn-xs btn-warning\" href=\"javascript:cmdEdit('" + jenisSimpanan.getOID() + "')\">Ubah</a></center>"));
            lstData.add(rowx);
        }
        return ctrlist.draw(-1);
    }
%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int start = FRMQueryString.requestInt(request, "start");
    String keyword = FRMQueryString.requestString(request, "keyword");
    int showHistory = FRMQueryString.requestInt(request, "show_history");
    long oidJenisSimpanan = FRMQueryString.requestLong(request, "hidden_jenisSimpanan_id");
    
    //    
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    CtrlJenisSimpanan ctrlJenisSimpanan = new CtrlJenisSimpanan(request);
    iErrCode = ctrlJenisSimpanan.action(iCommand, oidJenisSimpanan);
    FrmJenisSimpanan frmJenisSimpanan = ctrlJenisSimpanan.getForm();
    JenisSimpanan jenisSimpanan = ctrlJenisSimpanan.getJenisSimpanan();
    msgString = ctrlJenisSimpanan.getMessage();

    //ACTION LIST DATA JENIS ITEM
    String whereClause = "" + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN] + " LIKE '%" + keyword + "%'"
            + " OR " + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_DESC_JENIS_SIMPANAN] + " LIKE '%" + keyword + "%'";
    String orderClause = "" + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN];

    int recordToGet = 10;
    int vectSize = PstJenisSimpanan.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlJenisSimpanan.actionList(iCommand, start, vectSize, recordToGet);
    }

    Vector listJenisSimpanan = PstJenisSimpanan.list(start, recordToGet, whereClause, orderClause);
    if (listJenisSimpanan.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listJenisSimpanan = PstJenisSimpanan.list(start, recordToGet, whereClause, orderClause);
    }
%>

<%//
    ControlLine ctrLine = new ControlLine();
    ctrLine.initDefault();
    ctrLine.setLanguage(SESS_LANGUAGE);
    
    String currPageTitle = textListTitle[SESS_LANGUAGE][0];
    String strAddMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda yakin akan menghapus ") + currPageTitle + " ?";

    ctrLine.setLocationImg(approot + "/images");
    ctrLine.setTableWidth("100%");
    ctrLine.setCommandStyle("");
    ctrLine.setColCommStyle("");

    ctrLine.setFirstStyle("class='btn btn-xs btn-primary'");
    ctrLine.setPrevStyle("class='btn btn-xs btn-primary'");
    ctrLine.setNextStyle("class='btn btn-xs btn-primary'");
    ctrLine.setLastStyle("class='btn btn-xs btn-primary'");
    
    ctrLine.setListFirstCaption("<<");
    ctrLine.setListPrevCaption("<");
    ctrLine.setListNextCaption(">");
    ctrLine.setListLastCaption(">>");
    
    ctrLine.setDeleteCommand("javascript:cmdAsk('" + oidJenisSimpanan + "')");
    ctrLine.setConfirmDelCommand("javascript:cmdConfirmDelete('" + oidJenisSimpanan + "')");
    //ctrLine.setCancelCommand("javascript:cmdCancel('" + oidJenisSimpanan + "')");
    
    ctrLine.setAddStyle("class=\"btn btn-sm btn-primary\"");
    ctrLine.setSaveStyle("class=\"btn btn-sm btn-success\"");
    ctrLine.setDeleteStyle("class=\"btn btn-sm btn-danger\"");
    ctrLine.setConfirmStyle("class=\"btn btn-sm btn-success\"");
    ctrLine.setCancelStyle("class=\"btn btn-sm btn-warning\"");
    ctrLine.setBackStyle("class=\"btn btn-sm btn-primary\"");

    ctrLine.setAddCaption("<i class=\"fa fa-plus\"></i> " + strAddMar);
    ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveMar);
    ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskMar);
    ctrLine.setDeleteQuestion(delConfirm);
    ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> " + strDeleteMar);
    ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
    ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackMar);

    if (privAdd == false) {
        ctrLine.setAddCaption("");
    }

    if (privUpdate == false) {
        ctrLine.setSaveCaption("");
    }

    if (privDelete == false) {
        ctrLine.setDeleteCaption("");
    }

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>
        
        <%@ include file = "/style/lte_head.jsp" %>
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css">
        
        <style>
            table {font-size: 14px}
            .listtitle{padding-bottom:5px;}
            .listgenactivity{margin-top:20px !important;}
            .listgenactivity td{padding-left:5px !important;padding-right:5px !important;}
            .listgentitle {background-color: #00a65a; color: white; font-weight: normal;}
        </style>
        
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <script language="JavaScript">
            function cmdAdd() {
                document.frmJenisSimpanan.hidden_jenisSimpanan_id.value = "0";
                document.frmJenisSimpanan.command.value = "<%=Command.ADD%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "jenis_simpanan_editor.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdAsk(oidJenisSimpanan) {
                document.frmJenisSimpanan.hidden_jenisSimpanan_id.value = oidJenisSimpanan;
                document.frmJenisSimpanan.command.value = "<%=Command.ASK%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "jenis_simpanan.jsp";
                basicAjax(baseUrl("ajax/validation.jsp"), function (data) {
                    if (data.status == "true") {
                        document.frmJenisSimpanan.submit();
                    } else {
                        alert("Jenis simpanan tidak dapat dihapus karena sudah digunakan");
                    }
                }, {
                    dataFor: "validateDelJenisSimpanan",
                    id: oidJenisSimpanan
                });
            }

            function cmdConfirmDelete(oidJenisSimpanan) {
                document.frmJenisSimpanan.hidden_jenisSimpanan_id.value = oidJenisSimpanan;
                document.frmJenisSimpanan.command.value = "<%=Command.DELETE%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "jenis_simpanan.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdSave() {
                document.frmJenisSimpanan.command.value = "<%=Command.SAVE%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "jenis_simpanan.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdEdit(oidJenisSimpanan) {
                document.frmJenisSimpanan.hidden_jenisSimpanan_id.value = oidJenisSimpanan;
                document.frmJenisSimpanan.command.value = "<%=Command.EDIT%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "jenis_simpanan_editor.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdCancel(oidJenisSimpanan) {
                document.frmJenisSimpanan.hidden_jenisSimpanan_id.value = oidJenisSimpanan;
                document.frmJenisSimpanan.command.value = "<%=Command.EDIT%>";
                document.frmJenisSimpanan.prev_command.value = "<%=prevCommand%>";
                document.frmJenisSimpanan.action = "jenis_simpanan.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdBack() {
                document.frmJenisSimpanan.command.value = "<%=Command.BACK%>";
                document.frmJenisSimpanan.action = "jenis_simpanan.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdListFirst() {
                document.frmJenisSimpanan.command.value = "<%=Command.FIRST%>";
                document.frmJenisSimpanan.prev_command.value = "<%=Command.FIRST%>";
                document.frmJenisSimpanan.action = "jenis_simpanan.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdListPrev() {
                document.frmJenisSimpanan.command.value = "<%=Command.PREV%>";
                document.frmJenisSimpanan.prev_command.value = "<%=Command.PREV%>";
                document.frmJenisSimpanan.action = "jenis_simpanan.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdListNext() {
                document.frmJenisSimpanan.command.value = "<%=Command.NEXT%>";
                document.frmJenisSimpanan.prev_command.value = "<%=Command.NEXT%>";
                document.frmJenisSimpanan.action = "jenis_simpanan.jsp";
                document.frmJenisSimpanan.submit();
            }

            function cmdListLast() {
                document.frmJenisSimpanan.command.value = "<%=Command.LAST%>";
                document.frmJenisSimpanan.prev_command.value = "<%=Command.LAST%>";
                document.frmJenisSimpanan.action = "jenis_simpanan.jsp";
                document.frmJenisSimpanan.submit();
            }
        </script>
    </head>

    <body style="background-color: #eaf3df;">

        <section class="content-header">
            <h1>Jenis Item <small></small></h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Tabungan</li>
                <li class="active"><a href="#">Jenis Item</a></li>
            </ol>
        </section>
        
        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Jenis Item</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="jenis_simpanan.jsp" class="form-inline">
                        <input type="text" name="keyword" id="keyword" class="form-control input-sm" value="<%=keyword%>">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>
                    
                    <form name="frmJenisSimpanan" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="hidden_jenisSimpanan_id" value="<%=oidJenisSimpanan%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        
                        <%= drawList(iCommand, frmJenisSimpanan, jenisSimpanan, listJenisSimpanan, oidJenisSimpanan, SESS_LANGUAGE, vectSize, start, approot)%>
                        <%if(listJenisSimpanan.isEmpty()) {out.println("<br>Tidak ada data");}%>
                        
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
                        <br>
                        <%=ctrLine.drawMeListLimit(cmd, vectSize, start, recordToGet, "cmdListFirst", "cmdListPrev", "cmdListNext", "cmdListLast", "left")%>
                    </form>
                    
                    <%=ctrLine.draw(iCommand, iErrCode, msgString)%>
                        
                    <%
                        if (iCommand == Command.ADD || iCommand == Command.EDIT) {
                    %>
                    <script language="javascript">
                        document.frmJenisSimpanan.<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_NAMA_SIMPANAN]%>.focus();
                    </script>
                    <%
                        }
                    %>
                </div>
            </div>
                
            <a href="jenis_simpanan.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>
            <p></p>
            <% if (showHistory == 1) { %>
            <div class="box box-default">
                <div class="box-header">
                    <h3 class="box-title">Riwayat Perubahan</h3>
                </div>
                <div class="box-body">
                    <%
                        JSONObject obj = new JSONObject();
                        JSONArray arr = new JSONArray();
                        arr.put(SessHistory.document[SessHistory.DOC_JENIS_SIMPANAN]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% } %>
            
        </section>

        <% if (iCommand == Command.ACTIVATE && oidJenisSimpanan != 0) {%>
        <script>cmdAsk("<%=(oidJenisSimpanan)%>");</script>
        <%}%>
    </body>
    <script>
        $(document).ready(function() {
            $('.dataTable').DataTable({
                
            });
        });
    </script>
</html>

