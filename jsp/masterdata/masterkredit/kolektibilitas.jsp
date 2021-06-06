<%-- 
    Document   : kolektibilitas
    Created on : Jul 4, 2017, 11:31:18 AM
    Author     : Regen
--%>

<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmKolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlKolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmKolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package region -->
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*" %>

<%@include file="../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE);%>
<%@ include file = "../../main/checkuser.jsp" %>

<!DOCTYPE html>
<%  boolean privView = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

%>

<%!
    public static String strTitle[][] = {
        {"No", "Kode", "Tingkat Kolektibilitas", "Judul Kolektibilitas", "Max Hari Tunggakan Pokok", "Max Hari Jml Tunggakan Bunga", "Tingkat Resiko", "Aksi", "Tempo"},
        {"No", "Kode", "Tingkat Kolektibilitas", "Judul Kolektibilitas", "Max Hari Tunggakan Pokok", "Max Hari Jml Tunggakan Bunga", "Tingkat Resiko", "Action", "Tempo"},};

    public static final String systemTitle[] = {
        "Kolektibilitas", "Collectibility"
    };

    public static final String userTitle[] = {
        "Daftar", "List"
    };

    public String drawListKredit(int language, Vector objectClass, long oid, int start) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");

        //untuk tabel
        ctrlist.dataFormat(strTitle[language][0], "1%", "center", "left");
        ctrlist.dataFormat(strTitle[language][1], "5%", "center", "left");
        ctrlist.dataFormat(strTitle[language][8], "10%", "center", "left");
        ctrlist.dataFormat(strTitle[language][2], "7%", "center", "left");
        ctrlist.dataFormat(strTitle[language][3], "8%", "center", "left");
        ctrlist.dataFormat(strTitle[language][4], "10%", "center", "left");
        ctrlist.dataFormat(strTitle[language][5], "10%", "center", "left");
        ctrlist.dataFormat(strTitle[language][6], "10%", "center", "left");
        ctrlist.dataFormat(strTitle[language][7], "1%", "center", "left");

        Vector lstData = ctrlist.getData();
        int index = -1;
        int indexNumber = start;

        for (int i = 0; i < objectClass.size(); i++) {
            indexNumber = indexNumber + 1;
            KolektibilitasPembayaranDetails kp = (KolektibilitasPembayaranDetails) objectClass.get(i);
            if (oid == kp.getOID()) {
                index = i;
            }

            Vector rowx = new Vector();
            rowx.add(String.valueOf(indexNumber + "."));
            rowx.add(String.valueOf(kp.getKodeKolektibilitas()));

            rowx.add(String.valueOf(I_Sedana.TIPE_KREDIT.get(kp.getTipeKreidt())[language]));
            rowx.add(String.valueOf(kp.getTingkatKolektibilitas()));
            rowx.add(String.valueOf(kp.getJudulKolektibilitas()));
            rowx.add(String.valueOf(kp.getMaxHariTunggakanPokok()));
            rowx.add(String.valueOf(kp.getMaxHariJumlahTunggakanBunga()));
            rowx.add(String.valueOf(kp.getTingkatResiko()));
            rowx.add(String.valueOf("<center><a class=\"btn btn-xs btn-warning\" href=\"javascript:cmdEdit('" + kp.getOID() + "')\">Ubah</a></center>"));

            lstData.add(rowx);
        }
        return ctrlist.draw(-1);
    }
%>

<%
    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int start = FRMQueryString.requestInt(request, "start");
    String keyword = FRMQueryString.requestString(request, "keyword");
    int showHistory = FRMQueryString.requestInt(request, "show_history");
    long oidKolektibilitas = FRMQueryString.requestLong(request, FrmKolektibilitasPembayaran.fieldNames[FrmKolektibilitasPembayaran.FRM_FIELD_KOLEKTIBILITASID]);

    //
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    CtrlKolektibilitasPembayaran ctrlKolektibilitas = new CtrlKolektibilitasPembayaran(request);
    
    //========== ACTION LIST DATA KOLEKTIBILITAS ==========
    String whereClause = PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_JUDUL_KOLEKTIBILITAS] + " LIKE '%" + keyword + "%'"
            + " OR " + PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KODE_KOLEKTIBILITAS] + " LIKE '%" + keyword + "%'";
    String orderClause = PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KODE_KOLEKTIBILITAS];
    
    int recordToGet = 10;
    int vectSize = PstKolektibilitasPembayaranDetails.getJoin(0, 0, whereClause, orderClause).size();
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlKolektibilitas.actionList(iCommand, start, vectSize, recordToGet);
    }
    
    Vector listKolektibilitas = PstKolektibilitasPembayaranDetails.getJoin(start, recordToGet, whereClause, orderClause);
    if (listKolektibilitas.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listKolektibilitas = PstKolektibilitasPembayaranDetails.getJoin(start, recordToGet, whereClause, orderClause);
    }
%>

<%//
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

    ctrLine.setLocationImg(approot + "/images");
    ctrLine.initDefault();
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
    
    ctrLine.setDeleteCommand("javascript:cmdAsk('" + oidKolektibilitas + "')");
    ctrLine.setConfirmDelCommand("javascript:cmdConfirmDelete('" + oidKolektibilitas + "')");
    ctrLine.setCancelCommand("javascript:cmdCancel('" + oidKolektibilitas + "')");
    
    ctrLine.setAddStyle("class=\"btn btn-sm btn-primary\"");
    ctrLine.setCancelStyle("class=\"btn btn-sm btn-warning\"");
    ctrLine.setDeleteStyle("class=\"btn btn-sm btn-danger\"");
    ctrLine.setBackStyle("class=\"btn btn-sm btn-primary\"");
    ctrLine.setSaveStyle("class=\"btn btn-sm btn-success\"");
    ctrLine.setConfirmStyle("class=\"btn btn-sm btn-success\"");
    
    ctrLine.setAddCaption("<i class=\"fa fa-plus\"></i> " + strAddMar);
    ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
    ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackMar);
    ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveMar);
    ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskMar);
    ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> " + strDeleteMar);

    if (privAdd == false) {
        ctrLine.setAddCaption("");
    }

    if (privUpdate == false) {
        ctrLine.setSaveCaption("");
    }

    if (privDelete == false) {
        ctrLine.setConfirmDelCaption("");
        ctrLine.setDeleteCaption("");
        ctrLine.setEditCaption("");
    }

    if (iCommand == Command.ASK) {
        ctrLine.setDeleteQuestion(delConfirm);
    }
    
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>
        
        <%@ include file = "/style/lte_head.jsp" %>
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        
        <style>
            table {font-size: 14px}
            .listtitle{padding-bottom:5px;}
            .listgenactivity{margin-top:20px !important;}
            .listgenactivity td{padding-left:5px !important;padding-right:5px !important;}
            .listgentitle {background-color: #00a65a; color: white; font-weight: normal;}
        </style>
        
        <script language="JavaScript">
            function cmdAdd() {
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.<%= FrmKolektibilitasPembayaranDetails.fieldNames[FrmKolektibilitasPembayaranDetails.FRM_FIELD_KOLEKTIBILITASDETAILID]%>.value = "0";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.ADD%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.prev_command.value = "<%=prevCommand%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitaseditor.jsp";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
            }

            function cmdEdit(oid) {
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.<%= FrmKolektibilitasPembayaranDetails.fieldNames[FrmKolektibilitasPembayaranDetails.FRM_FIELD_KOLEKTIBILITASDETAILID]%>.value = oid;
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.EDIT%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.prev_command.value = "<%=prevCommand%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitaseditor.jsp";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
            }
            
            function cmdBack() {
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.BACK%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitas.jsp";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
            }

            function first() {
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.FIRST%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.prev_command.value = "<%=Command.FIRST%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitas.jsp";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
            }
            
            function prev() {
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.PREV%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.prev_command.value = "<%=Command.PREV%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitas.jsp";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
            }

            function next() {
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.NEXT%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.prev_command.value = "<%=Command.NEXT%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitas.jsp";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
            }
            
            function last() {
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.command.value = "<%=Command.LAST%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.prev_command.value = "<%=Command.LAST%>";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.action = "kolektibilitas.jsp";
                document.<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>.submit();
            }

        </script>

    </head>
    <body style="background-color: #eaf3df;">

        <section class="content-header">
            <h1>Kolektibilitas Pembayaran <small></small></h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Kredit</li>
                <li class="active"><a href="#">Kolektibilitas Pembayaran</a></li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Kolektibilitas Pembayaran</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="kolektibilitas.jsp" class="form-inline">
                        <input type="text" id="keyword" class="form-control input-sm" name="keyword" value="<%=keyword%>">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>
                    
                    <form name="<%= FrmKolektibilitasPembayaran.FRM_NAME_KOLEKTIBILITASPEMBAYARAN%>" method="get" action="">
                        <input type="hidden" name="command" value="">
                        <input type="hidden" name="<%= FrmKolektibilitasPembayaranDetails.fieldNames[FrmKolektibilitasPembayaranDetails.FRM_FIELD_KOLEKTIBILITASDETAILID]%>" value="<%=oidKolektibilitas%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">

                        <%=drawListKredit(SESS_LANGUAGE, listKolektibilitas, oidKolektibilitas, start)%>
                        <%if(listKolektibilitas.isEmpty()) {out.println("<br>Tidak ada data");}%>
                        
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
                        <%=ctrLine.drawMeListLimit(cmd, vectSize, start, recordToGet, "first", "prev", "next", "last", "left")%>
                    </form>
                    
                    <%=ctrLine.draw(iCommand, iErrCode, msgString)%>
                </div>
            </div>

            <a href="kolektibilitas.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>
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
                        arr.put(SessHistory.document[SessHistory.DOC_MASTER_KOLEKTIBILITAS_PEMBAYARAN]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% }%>

        </section>
    </body>
</html>
