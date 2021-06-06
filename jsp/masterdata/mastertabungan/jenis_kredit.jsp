<%-- 
    Document   : jenis_kredit
    Created on : Mar 1, 2013, 4:50:54 PM
    Author     : dw1p4
--%>

<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
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
<%//
    boolean privView = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

%>

<%!
    public static String strTitle[][] = {
        {"No", "Jenis Kredit", "Pengajuan Min", "Pengajuan Max", "Bunga Min", "Bunga Max", "Biaya Admin", "Provisi", "Denda", "Jangka Waktu Min", "Jangka Waktu Max", "Kegunaan", "Frekuensi Angsuran", "Berlaku Mulai", "Berlaku Sampai"},
        {"No", "Credit Type", "Min Credit", "Max Credit", "Interest Min", "Interest Max", "Admin Cost", "Provisi", "Penalty", "Min Period", "Max Period", "Usefulness"},};

    public static final String systemTitle[] = {
        "Jenis Kredit", "Credit Type"
    };

    public static final String userTitle[] = {
        "Daftar", "List"
    };

    public String drawListKredit(int language, Vector objectClass, long oid, int start, int enableTabungan, int SESS_LANGUAGE) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");

        //untuk tabel
        ctrlist.dataFormat(strTitle[language][0], "1%", "center", "left");
        ctrlist.dataFormat(strTitle[language][1], "", "center", "left");
		if(enableTabungan == 1){
        ctrlist.dataFormat(strTitle[language][2], "", "center", "left");
        ctrlist.dataFormat(strTitle[language][3], "", "center", "left");
        ctrlist.dataFormat(strTitle[language][4], "", "center", "left");
        ctrlist.dataFormat(strTitle[language][5], "", "center", "left");
        ctrlist.dataFormat(strTitle[language][9], "", "center", "left");
        ctrlist.dataFormat(strTitle[language][10], "", "center", "left");
		} else {
			ctrlist.dataFormat(strTitle[language][12], "", "center", "left");
			ctrlist.dataFormat(strTitle[language][13], "", "center", "left");
			ctrlist.dataFormat(strTitle[language][14], "", "center", "left");
			ctrlist.dataFormat(strTitle[language][11], "", "center", "left");
		}
        ctrlist.dataFormat("Action", "", "center", "left");

        Vector lstData = ctrlist.getData();
        ctrlist.reset();
        int index = -1;
        int indexNumber = start;

		String dateFormat = "dd MMMM yyyy";

        for (int i = 0; i < objectClass.size(); i++) {
            indexNumber = indexNumber + 1;
            JenisKredit kredit = (JenisKredit) objectClass.get(i);
            if (oid == kredit.getOID()) {
                index = i;
            }

            Vector rowx = new Vector();
            rowx.add("" + indexNumber + ".");
            rowx.add("" + kredit.getNamaKredit());
			if(enableTabungan == 1){
            rowx.add("<span class='money'>" + kredit.getMinKredit() + "</span>");
            rowx.add("<span class='money'>" + kredit.getMaxKredit() + "</span>");
            rowx.add("<span class='money'>" + kredit.getBungaMin() + "</span> %");
            rowx.add("<span class='money'>" + kredit.getBungaMax() + "</span> %");
            rowx.add("" + Math.round(kredit.getJangkaWaktuMin()));
            rowx.add("" + Math.round(kredit.getJangkaWaktuMax()));
			} else {
				String[] frekuensi = I_Sedana.TIPE_KREDIT.get(kredit.getTipeFrekuensiPokok());
				rowx.add("<div class='text-center'>" + frekuensi[SESS_LANGUAGE] + "</div>");
				rowx.add("<div class='text-center'>" + Formater.formatDate(kredit.getBerlakuMulai(), dateFormat) + "</div>");
				rowx.add("<div class='text-center'>" + Formater.formatDate(kredit.getBerlakuSampai(), dateFormat) + "</div>");
				rowx.add("<div class='text-center'>" + kredit.getKegunaan() + "</div>");
			}
            rowx.add("<div class='text-center'>"
                    + "<nobr>"
                    + "<a class=\"btn btn-xs btn-warning\" href=\"javascript:cmdEdit('" + kredit.getOID() + "')\">Ubah</a>"
                    + "&nbsp;"
                    + "<a class=\"btn btn-xs btn-info\" href=\"javascript:cmdAssign('" + kredit.getOID() + "')\">Sumber Dana</a>"
                    + "</nobr>"
                    + "</div>");

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
    long oidJenisKredit = FRMQueryString.requestLong(request, "kredit_oid");
    
    //
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    CtrlJenisKredit ctrlJenisKredit = new CtrlJenisKredit(request);
    
    //========== ACTION LIST DATA JENIS KREDIT ==========
    String whereClause = PstJenisKredit.fieldNames[PstJenisKredit.FLD_NAME_KREDIT] + " LIKE '%" + keyword + "%'";
    String orderClause = PstJenisKredit.fieldNames[PstJenisKredit.FLD_NAME_KREDIT];

    int recordToGet = 10;
    int vectSize = PstJenisKredit.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlJenisKredit.actionList(iCommand, start, vectSize, recordToGet);
    }
    
    Vector listKredit = PstJenisKredit.list(start, recordToGet, whereClause, orderClause);
    if (listKredit.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listKredit = PstMasterTabungan.list(start, recordToGet, whereClause, orderClause);
    }
    
	int enableTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN"));

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
    
    ctrLine.setDeleteCommand("javascript:cmdAsk('" + oidJenisKredit + "')");
    ctrLine.setConfirmDelCommand("javascript:cmdConfirmDelete('" + oidJenisKredit + "')");
    ctrLine.setCancelCommand("javascript:cmdCancel('" + oidJenisKredit + "')");
    
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
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css">
        
        <style>
            table {font-size: 14px}
            .listtitle{padding-bottom:5px;}
            .listgenactivity{margin-top:20px !important;}
            .listgenactivity td{padding-left:5px !important;padding-right:5px !important;}
            .listgentitle {background-color: #00a65a; color: white; font-weight: normal;}
        </style>

        <script language="JavaScript">
            function cmdAdd() {
                document.frmKredit.kredit_oid.value = "0";
                document.frmKredit.command.value = "<%=Command.ADD%>";
                document.frmKredit.prev_command.value = "<%=prevCommand%>";
                document.frmKredit.action = "krediteditor.jsp";
                document.frmKredit.submit();
            }

            function cmdEdit(oid) {
                document.frmKredit.kredit_oid.value = oid;
                document.frmKredit.command.value = "<%=Command.EDIT%>";
                document.frmKredit.prev_command.value = "<%=prevCommand%>";
                document.frmKredit.action = "krediteditor.jsp";
                document.frmKredit.submit();
            }
            
            function cmdBack() {
                document.frmKredit.command.value = "<%=Command.BACK%>";
                document.frmKredit.action = "jenis_kredit.jsp";
                document.frmKredit.submit();
            }

            function cmdAssign(oid) {
                document.frmKredit.kredit_oid.value = oid;
                document.frmKredit.command.value = "<%= Command.NONE%>";
                document.frmKredit.prev_command.value = "<%=prevCommand%>";
                document.frmKredit.action = "assignsumberdana.jsp";
                document.frmKredit.submit();
            }

            function first() {
                document.frmKredit.command.value = "<%=Command.FIRST%>";
                document.frmKredit.prev_command.value = "<%=Command.FIRST%>";
                document.frmKredit.action = "jenis_kredit.jsp";
                document.frmKredit.submit();
            }
            
            function prev() {
                document.frmKredit.command.value = "<%=Command.PREV%>";
                document.frmKredit.prev_command.value = "<%=Command.PREV%>";
                document.frmKredit.action = "jenis_kredit.jsp";
                document.frmKredit.submit();
            }

            function next() {
                document.frmKredit.command.value = "<%=Command.NEXT%>";
                document.frmKredit.prev_command.value = "<%=Command.NEXT%>";
                document.frmKredit.action = "jenis_kredit.jsp";
                document.frmKredit.submit();
            }
            
            function last() {
                document.frmKredit.command.value = "<%=Command.LAST%>";
                document.frmKredit.prev_command.value = "<%=Command.LAST%>";
                document.frmKredit.action = "jenis_kredit.jsp";
                document.frmKredit.submit();
            }

        </script>

    </head>
    <body style="background-color: #eaf3df;">

        <section class="content-header">
            <h1>Jenis Kredit <small></small></h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Kredit</li>
                <li class="active"><a href="#">Jenis Kredit</a></li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Jenis Kredit</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="jenis_kredit.jsp" class="form-inline">
                        <input type="text" id="keyword" class="form-control input-sm" name="keyword" value="<%=keyword%>">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>
                    
                    <form name="frmKredit" method="get" action="">
                        <input type="hidden" name="command" value="">
                        <input type="hidden" name="kredit_oid" value="<%=oidJenisKredit%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">

                        <%=drawListKredit(SESS_LANGUAGE, listKredit, oidJenisKredit, start, enableTabungan, SESS_LANGUAGE)%>
                        <%if(listKredit.isEmpty()) {out.println("<br>Tidak ada data");}%>
                        
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

            <a href="jenis_kredit.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>
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
    </body>
</html>
