<%-- 
    Document   : jenis_kredit
    Created on : Mar 1, 2013, 4:50:54 PM
    Author     : dw1p4
--%>

<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.sedana.form.sumberdana.CtrlSumberDana"%>
<%@page import="com.dimata.sedana.form.sumberdana.FrmSumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.SumberDana"%>
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
        {"No", "Nama Sumber Dana", "Jenis Sumber Dana", "Kode Sumber Dana", "Judul Sumber Dana", "Target Pendanaan", "Prioritas Penggunaan", "Total Ketersediaan Dana", "Biaya Bunga Ke Kreditur", "Tipe Bunga Ke Kreditur", "Tanggal Dana Masuk", "Tanggal Lunas Ke Kreditur", "Tanggal Dana Mulai Tersedia", "Tanggal Akhir Tersedia", "Minimum Pinjaman Ke Debitur", "Maximum Pinjaman Ke Debitur"},
        {"No", "Fund Sources Name", "Types of Fund Sources", "Code of Fund Sources", "Title of Fund Sources", "Funding Target", "Usage Priority", "Total Description of Funds", "Cost of Interest to Creditors", "Type of Interest to the Creditor", "Date of Entrance Fund", "Dated to Creditors", "Funding Date Start Available", "End Date Available", "Minimum Loan to Debtor", "Maximum Loan to Debtor"},};

    public static final String systemTitle[] = {
        "Sumber Dana", "Fund Sources"
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

        ctrlist.dataFormat(strTitle[language][0], "1%", "center", "left");
        ctrlist.dataFormat(strTitle[language][1], "", "center", "left");
        ctrlist.dataFormat(strTitle[language][3], "", "center", "left");
        ctrlist.dataFormat(strTitle[language][4], "", "center", "left");
        ctrlist.dataFormat(strTitle[language][2], "", "center", "left");
        ctrlist.dataFormat(strTitle[language][5], "", "center", "left");
        //ctrlist.dataFormat(strTitle[language][6], "10%", "center", "left");
        ctrlist.dataFormat(strTitle[language][7], "", "center", "left");
        //ctrlist.dataFormat(strTitle[language][8], "10%", "center", "left");
        //ctrlist.dataFormat(strTitle[language][9], "10%", "center", "left");
        //ctrlist.dataFormat(strTitle[language][10], "4%", "center", "left");
        //ctrlist.dataFormat(strTitle[language][11], "4%", "center", "left");
        ctrlist.dataFormat("Aksi", "1%", "center", "left");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;
        int indexNumber = start;

        String tgl_min = "";
        String tgl_max = "";
        for (int i = 0; i < objectClass.size(); i++) {
            indexNumber = indexNumber + 1;
            SumberDana sumberDana = (SumberDana) objectClass.get(i);
            if (oid == sumberDana.getOID()) {
                index = i;
            }
            Anggota anggota = new Anggota();
            if (sumberDana.getContactId() != 0) {
                try {
                    anggota = PstAnggota.fetchExc(sumberDana.getContactId());
                } catch (Exception ex) {

                }
            }

            Vector rowx = new Vector();
            rowx.add(String.valueOf(indexNumber + "."));
            rowx.add(String.valueOf(anggota.getName()));
            rowx.add(String.valueOf(sumberDana.getKodeSumberDana()));
            rowx.add(String.valueOf(sumberDana.getJudulSumberDana()));
            rowx.add(String.valueOf(PstSumberDana.jenisSumberDana[sumberDana.getJenisSumberDana()]));
            rowx.add(String.valueOf(sumberDana.getTargetPendanaan()));
            //rowx.add(String.valueOf(sumberDana.getPrioritasPenggunaan()));
            rowx.add("<span class='money'>" + sumberDana.getTotalKetersediaanDana() + "</span>");
            //rowx.add(String.valueOf(FRMHandler.userFormatStringDecimal(sumberDana.getBiayaBungaKeKreditur())));
            //rowx.add(String.valueOf(PstSumberDana.tipeBunga[sumberDana.getTipeBungaKeKreditur()]));

            if (sumberDana.getTanggalDanaMasuk() != null) {
                try {
                    tgl_max = Formater.formatDate(sumberDana.getTanggalDanaMasuk(), "dd-MM-yyyy");
                } catch (Exception e) {
                    tgl_max = "";
                }
            } else {
                tgl_max = "";
            }
            //rowx.add(String.valueOf(tgl_max));
            if (sumberDana.getTanggalLunasKeKreditur() != null) {
                try {
                    tgl_max = Formater.formatDate(sumberDana.getTanggalLunasKeKreditur(), "dd-MM-yyyy");
                } catch (Exception e) {
                    tgl_max = "";
                }
            } else {
                tgl_max = "";
            }
            //rowx.add(String.valueOf(tgl_max));
            rowx.add(String.valueOf("<center><a class=\"btn btn-xs btn-warning\" href=\"javascript:cmdEdit('" + sumberDana.getOID() + "')\">Ubah</a></center>"));

            lstData.add(rowx);
        }
        return ctrlist.draw(index);
    }
%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int start = FRMQueryString.requestInt(request, "start");
    String keyword = FRMQueryString.requestString(request, "keyword");
    int showHistory = FRMQueryString.requestInt(request, "show_history");
    long oidSumberDana = FRMQueryString.requestLong(request, FrmSumberDana.fieldNames[FrmSumberDana.FRM_FIELD_SUMBER_DANA_ID]);

    //
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    CtrlSumberDana ctrlSumberDana = new CtrlSumberDana(request);
    
    //========== ACTION LIST DATA SUMBER DANA ==========
    String whereClause = PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + keyword + "%'"
            + " OR " + PstSumberDana.fieldNames[PstSumberDana.FLD_KODE_SUMBER_DANA] + " LIKE '%" + keyword + "%'";
    String orderClause = PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA];
    
    int recordToGet = 10;
    int vectSize = PstSumberDana.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlSumberDana.actionList(iCommand, start, vectSize, recordToGet);
    }

    Vector listSumberDana = PstSumberDana.list(start, recordToGet, whereClause, orderClause);
    if (listSumberDana.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listSumberDana = PstSumberDana.list(start, recordToGet, whereClause, orderClause);
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
    
    ctrLine.setDeleteCommand("javascript:cmdAsk('" + oidSumberDana + "')");
    ctrLine.setConfirmDelCommand("javascript:cmdConfirmDelete('" + oidSumberDana + "')");
    ctrLine.setCancelCommand("javascript:cmdCancel('" + oidSumberDana + "')");
    
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
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.<%= FrmSumberDana.fieldNames[FrmSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>.value = "0";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.ADD%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.prev_command.value = "<%=prevCommand%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumberdanaeditor.jsp";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }

            function cmdEdit(oid) {
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.<%= FrmSumberDana.fieldNames[FrmSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>.value = oid;
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.prev_command.value = "<%=prevCommand%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.EDIT%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumberdanaeditor.jsp";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }
            
            function cmdBack() {
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.BACK%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumber_dana.jsp";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }

            function first() {
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.FIRST%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.prev_command.value = "<%=Command.FIRST%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumber_dana.jsp";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }
            
            function prev() {
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.PREV%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.prev_command.value = "<%=Command.PREV%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumber_dana.jsp";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }

            function next() {
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.NEXT%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.prev_command.value = "<%=Command.NEXT%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumber_dana.jsp";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }
            
            function last() {
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.command.value = "<%=Command.LAST%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.prev_command.value = "<%=Command.LAST%>";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.action = "sumber_dana.jsp";
                document.<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>.submit();
            }
        </script>

    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>Sumber Dana<small></small></h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Kredit</li>
                <li class="active"><a href="#">Sumber Dana</a></li>
            </ol>
        </section>

        <section class="content">

            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Sumber Dana</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="sumber_dana.jsp" class="form-inline">
                        <input type="text" id="keyword" class="form-control input-sm" name="keyword" value="<%=keyword%>">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>
                    
                    <form name="<%= FrmSumberDana.FRM_NAME_SUMBERDANA%>" method="get" action="">
                        <input type="hidden" name="command" value="">
                        <input type="hidden" name="<%= FrmSumberDana.fieldNames[FrmSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>" value="<%=oidSumberDana%>">
                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">

                        <%=drawListKredit(SESS_LANGUAGE, listSumberDana, oidSumberDana, start)%>
                        <%if(listSumberDana.isEmpty()) {out.println("<br>Tidak ada data");}%>
                        
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

            <a href="sumber_dana.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>
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
            <% }%>
            
        </section>
    </body>
</html>

