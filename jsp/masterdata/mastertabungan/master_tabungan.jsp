<%-- 
    Document   : mastertabungan
    Created on : Feb 23, 2013, 12:00:53 PM
    Author     : dw1p4
--%>

<%@page import="com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstAssignPenarikanTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.AssignPenarikanTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstMasterTabunganPenarikan"%>
<%@page import="com.dimata.sedana.entity.tabungan.MasterTabunganPenarikan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.PstAssignTabungan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.AssignTabungan"%>
<%@page import="com.dimata.sedana.form.assigntabungan.CtrlAssignTabungan"%>
<%@page import="com.dimata.sedana.form.assigntabungan.FrmAssignTabungan"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.FrmJenisSimpanan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmMasterTabungan"%>
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
<%@page import="com.dimata.aiso.entity.masterdata.region.*"%>
<%@page import="com.dimata.aiso.form.masterdata.region.*"%>


<%@include file="../../main/javainit.jsp" %>
<% //int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
    int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<!-- Jsp Block -->
<%!
    public static final String textListTitle[][]
            = {
                {"Tabungan"},
                {"Saving"}
            };

    public static final String textListHeader[][]
            = {
                {"No", "Kode Tabungan", "Nama Tabungan", "Keterangan", "Jenis Item", "Aksi", "Denda", "Jenis Denda", "Minimum Saldo Bunga", "Periode Penarikan"},
                {"No", "Saving Code", "Saving Name", "Description", "Saving Type", "Action", "Penalty", "Type of Penalty", "Min. Balance of Rate", "Periode Penarikan"}
            };

    public String drawList(int iCommand, FrmMasterTabungan frmObject, MasterTabungan objEntity, Vector objectClass, long masterTabunganId, int languange, int number, long oidAssignTabungan, String multiIdJenisSimpanan[]) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.setCellSpacing("0");

        ctrlist.addHeader(textListHeader[languange][0], "1%");
        ctrlist.addHeader(textListHeader[languange][1], "");
        ctrlist.addHeader(textListHeader[languange][2], "");
        ctrlist.addHeader(textListHeader[languange][4], "");
        ctrlist.addHeader(textListHeader[languange][6], "");
        ctrlist.addHeader(textListHeader[languange][3], "");
        ctrlist.addHeader(textListHeader[languange][9], "");
        ctrlist.addHeader(textListHeader[languange][5], "");

        Vector lstData = ctrlist.getData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;

        ControlCombo comboBox = new ControlCombo();
        int countMasterTabungan = PstMasterTabungan.getCount("");
        Vector listMasterTabungan = PstMasterTabungan.list(0, countMasterTabungan, "", PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN]);
        Vector mastertabunganKey = new Vector(1, 1);
        Vector mastertabunganValue = new Vector(1, 1);
        for (int i = 0; i < listMasterTabungan.size(); i++) {
            MasterTabungan mastertabungan = (MasterTabungan) listMasterTabungan.get(i);
            mastertabunganKey.add("" + mastertabungan.getNamaTabungan());
            mastertabunganValue.add(String.valueOf(mastertabungan.getOID()).toString());
        }

        int i = 0;
        Vector<MasterTabungan> obj = objectClass;
        for (MasterTabungan masterTabungan : obj) {
            number = number + 1;
            rowx = new Vector();
            if (masterTabunganId == masterTabungan.getOID()) {
                index = i;
            }

            int countUsed = PstAssignContactTabungan.getCount(PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_MASTER_TABUNGAN_ID] + " = " + masterTabungan.getOID());
            int jumlahPeriodePenarikan = PstAssignPenarikanTabungan.getCount(PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID] + " = " + masterTabungan.getOID());
            String periodePenarikan = (jumlahPeriodePenarikan == 0) ? "-" : "" + jumlahPeriodePenarikan + " periode";

            if (masterTabunganId == masterTabungan.getOID() && (iCommand == Command.EDIT || iCommand == Command.ASK || (iCommand == Command.SAVE && frmObject.errorSize() > 0))) {
                Vector<JenisSimpanan> jss = PstJenisSimpanan.list(0, 0, "", PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]);
                String sim = "";
                for (JenisSimpanan js : jss) {
                    String checked = "";
                    int count = PstAssignTabungan.getCount(PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + " = " + masterTabungan.getOID()
                            + " AND " + PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_ID_JENIS_SIMPANAN] + " = " + js.getOID());
                    if (countUsed > 0) {
                        if (count > 0) {
                            sim += (sim.length() > 0) ? ", " + js.getNamaSimpanan() : js.getNamaSimpanan();
                        }
                    } else {
                        if (count > 0) {
                            checked = "checked";
                        }
                        sim += "<input type='checkbox' " + checked + " name='" + FrmAssignTabungan.fieldNames[FrmAssignTabungan.FRM_FIELD_IDJENISSIMPANAN] + "' value='" + js.getOID() + "' style='display: inline; vertical-align: sub;'> " + js.getNamaSimpanan() + "<br>";
                    }
                }

                String opt = "";
                int li = 0;
                String chkDenda = "";
                for (String[] s : MasterTabungan.txtJenisDenda) {
                    opt += "<option " + (objEntity.getJenisDenda() == li ? "selected" : "") + " value='" + li + "'>" + s[languange] + "</option>";
                    chkDenda += "<input type='radio' " + (objEntity.getJenisDenda() == li ? "checked" : "") + " name='" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_DENDA_JENIS] + "' value='" + li + "' style='display: inline; vertical-align: sub;'> " + s[languange] + "<br>";
                    li++;
                }
                rowx.add("" + number + ".<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_MASTERTABUNGANID] + "\" value=\"" + objEntity.getOID() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_KODETABUNGAN] + "\" value=\"" + objEntity.getKodeTabungan() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_NAMATABUNGAN] + "\" value=\"" + objEntity.getNamaTabungan() + "\" class=\"formElemen\">");
                rowx.add("<div class='item'>" + sim + "</div>");
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_DENDA] + "\" value=\"" + objEntity.getDenda() + "\" class=\"formElemen\">" + chkDenda);
                rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_KET] + "\" value=\"" + objEntity.getKet() + "\" class=\"formElemen\">");
                rowx.add(periodePenarikan);
            } else {
                Vector<AssignTabungan> ast = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + "=" + masterTabungan.getOID(), "");
                String namaSimpanan = "";
                for (AssignTabungan a : ast) {
                    JenisSimpanan js = new JenisSimpanan();
                    try {
                        js = PstJenisSimpanan.fetchExc(a.getIdJenisSimpanan());
                    } catch (Exception e) {
                    }
                    namaSimpanan += namaSimpanan.isEmpty() ? "" : ", ";
                    namaSimpanan += js.getNamaSimpanan();
                }
                namaSimpanan = namaSimpanan.isEmpty() ? "-" : namaSimpanan;

                String tipeDendaPersen = (masterTabungan.getJenisDenda() == MasterTabungan.DENDA_PROSENTASE) ? " %" : "";
                String tipeDendaNominal = (masterTabungan.getJenisDenda() == MasterTabungan.DENDA_NOMINAL) ? "Rp " : "";
                rowx.add("" + number + ".");
                rowx.add(masterTabungan.getKodeTabungan());
                rowx.add(masterTabungan.getNamaTabungan());
                rowx.add(namaSimpanan);
                rowx.add(tipeDendaNominal + "<span class='money'>" + masterTabungan.getDenda() + "</span>" + tipeDendaPersen);
                rowx.add(masterTabungan.getKet());
                rowx.add(periodePenarikan);
            }
            rowx.add("<div class='text-center'>"
                    + "<a class='btn btn-xs btn-warning' href=\"javascript:cmdEdit('" + masterTabungan.getOID() + "')\">Ubah</a>"
                    + "&nbsp;"
                    + "<a class='btn btn-xs btn-info' href=\"javascript:cmdShowPeriode('" + masterTabungan.getOID() + "')\">Periode</a>"
                    + "</div>");
            lstData.add(rowx);
            i++;

        }

        rowx = new Vector();

        if (masterTabunganId == 0 && (iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0))) {
            Vector<JenisSimpanan> jss = PstJenisSimpanan.list(0, 0, "", PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]);
            String sim = "";
            for (JenisSimpanan js : jss) {
                String checked = "";
                if (multiIdJenisSimpanan != null) {
                    for (String idJS : multiIdJenisSimpanan) {
                        if (js.getOID() == Long.valueOf(idJS)) {
                            checked = "checked";
                            break;
                        }
                    }
                }
                sim += "<input type='checkbox' " + checked + " name='" + FrmAssignTabungan.fieldNames[FrmAssignTabungan.FRM_FIELD_IDJENISSIMPANAN] + "' value='" + js.getOID() + "' style='display: inline; vertical-align: sub;'> " + js.getNamaSimpanan() + "<br>";
            }
            sim += "<br><button class=\"btn btn-xs btn-success btn-add-item\" type=\"button\">Tambah</button>";
            String opt = "";
            int li = 0;
            String chkDenda = "";
            for (String[] s : MasterTabungan.txtJenisDenda) {
                opt += "<option value='" + li + "'>" + s[languange] + "</option>";
                chkDenda += "<input type='radio' name='" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_DENDA_JENIS] + "' value='" + li + "' style='display: inline; vertical-align: sub;'> " + s[languange] + "<br>";
                li++;
            }
            rowx.add("<input type=\"hidden\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_MASTERTABUNGANID] + "\" value=\"" + objEntity.getOID() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_KODETABUNGAN] + "\" value=\"" + objEntity.getKodeTabungan() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_NAMATABUNGAN] + "\" value=\"" + objEntity.getNamaTabungan() + "\" class=\"formElemen\">");
            rowx.add("<input type='hidden' name='" + FrmAssignTabungan.fieldNames[FrmAssignTabungan.FRM_FIELD_ASSIGNMASTERTABUNGANID] + "' value='" + oidAssignTabungan + "' style='display:none;' /> " + sim);
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_DENDA] + "\" value=\"" + objEntity.getDenda() + "\" class=\"formElemen\">" + chkDenda);
            rowx.add("<input type=\"text\" name=\"" + frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_KET] + "\" value=\"" + objEntity.getKet() + "\" class=\"formElemen\">");
            rowx.add("");
        }
        lstData.add(rowx);

        return ctrlist.draw(-1);
    }
%>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int start = FRMQueryString.requestInt(request, "start");
    String keyword = FRMQueryString.requestString(request, "keyword");
    int showHistory = FRMQueryString.requestInt(request, "show_history");
    long oidMasterTabungan = FRMQueryString.requestLong(request, "hidden_masterTabungan_id");
    String multiIdJenisSimpanan[] = FRMQueryString.requestStringValues(request, FrmAssignTabungan.fieldNames[FrmAssignTabungan.FRM_FIELD_IDJENISSIMPANAN]);

    //form data periode penarikan
    int commandPeriode = FRMQueryString.requestInt(request, "aksi_periode");
    int editPeriode = FRMQueryString.requestInt(request, "set_periode");
    long oidPeriode = FRMQueryString.requestLong(request, "id_periode");
    long oidAssignPeriode = FRMQueryString.requestLong(request, "id_assign_periode");
    String judulPeriode = FRMQueryString.requestString(request, "FRM_JUDUL_PERIODE");
    int tipePeriode = FRMQueryString.requestInt(request, "FRM_TIPE_PERIODE");
    Date tglMulaiPeriode = FRMQueryString.requestDate(request, "FRM_TGL_MULAI");
    Date tglSelesaiPeriode = FRMQueryString.requestDate(request, "FRM_TGL_SELESAI");
    int jumlahBulanPeriode = FRMQueryString.requestInt(request, "FRM_JUMLAH_BULAN");

    long oidAssignTabungan = 0;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;

    CtrlMasterTabungan ctrlMasterTabungan = new CtrlMasterTabungan(request);
    //========== AKSI MASTER TABUNGAN ==========
    iErrCode = ctrlMasterTabungan.action(iCommand, oidMasterTabungan);
    msgString = ctrlMasterTabungan.getMessage();
    MasterTabungan masterTabungan = ctrlMasterTabungan.getMasterTabungan();
    FrmMasterTabungan frmMasterTabungan = ctrlMasterTabungan.getForm();

    //========== AKSI ASSIGN TABUNGAN ==========
    if (iCommand == Command.SAVE && iErrCode == 0) {
        iErrCode = ctrlMasterTabungan.saveAssignTabungan(masterTabungan.getOID(), multiIdJenisSimpanan);
        msgString = ctrlMasterTabungan.getMessage();
    }

    //========== AKSI PERIODE PENARIKAN ==========
    String messagePeriode = "";
    String color = "";
    if (commandPeriode == Command.SAVE) {
        MasterTabunganPenarikan mtp = new MasterTabunganPenarikan();
        mtp.setJudulRangePenarikan(judulPeriode);
        mtp.setTipeRange(tipePeriode);
        if (tipePeriode == Transaksi.TIPE_PENARIKAN_TABUNGAN_TANGGAL) {
            mtp.setStartDate(tglMulaiPeriode);
            mtp.setEndDate(tglSelesaiPeriode);
            mtp.setPeriodeBulan(0);
        } else if (tipePeriode == Transaksi.TIPE_PENARIKAN_TABUNGAN_BULAN) {
            mtp.setPeriodeBulan(jumlahBulanPeriode);
            mtp.setStartDate(null);
            mtp.setEndDate(null);
        }
        int error = ctrlMasterTabungan.savePeriodePenarikan(oidPeriode, oidMasterTabungan, mtp);
        messagePeriode = ctrlMasterTabungan.getMessage();
        if (error == 0) {
            color = "green";
        } else {
            color = "red";
        }
    }

    if (commandPeriode == Command.DELETE && oidAssignPeriode != 0 && oidPeriode != 0) {
        try {
            PstAssignPenarikanTabungan.deleteExc(oidAssignPeriode);
            PstMasterTabunganPenarikan.deleteExc(oidPeriode);
            messagePeriode = "Periode penarikan berhasil dihapus";
            color = "green";
        } catch (Exception ex) {
            messagePeriode = "Gagal menghapus periode penarikan. " + ex.getMessage();
            color = "red";
        }
    }

    //========== AKSI LIST DATA MASTER TABUNGAN ==========
    String whereClause = "" + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN] + " LIKE '%" + keyword + "%'"
            + " OR " + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_KET] + " LIKE '%" + keyword + "%'";
    String orderClause = "" + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN];

    int recordToGet = 10;
    int vectSize = PstMasterTabungan.getCount(whereClause);
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        start = ctrlMasterTabungan.actionList(iCommand, start, vectSize, recordToGet);
    }

    Vector listMasterTabungan = PstMasterTabungan.list(start, recordToGet, whereClause, orderClause);
    if (listMasterTabungan.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST;
        }
        listMasterTabungan = PstMasterTabungan.list(start, recordToGet, whereClause, orderClause);
    }
%>

<%//
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = textListTitle[SESS_LANGUAGE][0];
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

    ctrLine.setDeleteCommand("javascript:cmdAsk('" + oidMasterTabungan + "')");
    ctrLine.setConfirmDelCommand("javascript:cmdConfirmDelete('" + oidMasterTabungan + "')");
    ctrLine.setCancelCommand("javascript:cmdCancel('" + oidMasterTabungan + "')");

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

<%//
    int commandPagination = 0;
    if (iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST) {
        commandPagination = iCommand;
    } else {
        if (iCommand == Command.NONE || prevCommand == Command.NONE) {
            commandPagination = Command.FIRST;
        } else {
            commandPagination = prevCommand;
        }
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
            .listgensell input[type=text], .listgensellOdd input[type=text] {width: 100%}

            .tipe_hide {display: none}
            #tabel_periode { border-style: solid; border-width: 1px; border-color: lightgray;}
            #tabel_periode td {padding: 5px; vertical-align: text-top !important;}
            #view_periode td {vertical-align: top}
        </style>

        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <script language="JavaScript">
            function cmdAdd() {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = "0";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.ADD%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdAsk(oidMasterTabungan) {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = oidMasterTabungan;
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.ASK%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdConfirmDelete(oidMasterTabungan) {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = oidMasterTabungan;
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.DELETE%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdSave() {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.SAVE%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdEdit(oidMasterTabungan) {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = oidMasterTabungan;
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdCancel(oidMasterTabungan) {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = oidMasterTabungan;
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=prevCommand%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdBack() {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.BACK%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdListFirst() {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.FIRST%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=Command.FIRST%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdListPrev() {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.PREV%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=Command.PREV%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdListNext() {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.NEXT%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=Command.NEXT%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdListLast() {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.LAST%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.prev_command.value = "<%=Command.LAST%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            //========== ACTION FOR PERIOD ==========

            function cmdShowPeriode(oidMasterTabungan) {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = oidMasterTabungan;
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.NONE%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp?set_periode=1";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdAddPeriode(oidMasterTabungan) {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = oidMasterTabungan;
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.NONE%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp?set_periode=1&aksi_periode=<%=Command.ADD%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdEditPeriode(oidMasterTabungan, oidPeriode) {
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = oidMasterTabungan;
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.NONE%>";
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp?set_periode=1&aksi_periode=<%=Command.EDIT%>&id_periode=" + oidPeriode;
                document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
            }

            function cmdSavePeriode(oidMasterTabungan, oidPeriode) {
                var tp = document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.FRM_TIPE_PERIODE.value;
                if (tp == "" || tp == 0 || tp == null) {
                    alert("Pilih tipe periode !");
                } else {
                    document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = oidMasterTabungan;
                    document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.NONE%>";
                    document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp?set_periode=1&aksi_periode=<%=Command.SAVE%>&id_periode=" + oidPeriode;
                    document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
                }
            }

            function cmdDeletePeriode(oidMasterTabungan, oidPeriode, oidAssignPeriode) {
                var msg = "Yakin ingin menghapus periode ini ?";
                if (confirm(msg) === true) {
                    document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.hidden_masterTabungan_id.value = oidMasterTabungan;
                    document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.command.value = "<%=Command.NONE%>";
                    document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.action = "master_tabungan.jsp?set_periode=1&aksi_periode=<%=Command.DELETE%>&id_periode=" + oidPeriode + "&id_assign_periode=" + oidAssignPeriode;
                    document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.submit();
                }
            }

        </script>

        <script>
            $(document).ready(function () {

                var approot = "<%= approot%>";
                var getDataFunction = function (onDone, onSuccess, approot, command, dataSend, servletName, dataAppendTo, notification) {
                    /*
                     * getDataFor	: # FOR PROCCESS FILTER
                     * onDone	: # ON DONE FUNCTION,
                     * onSuccess	: # ON ON SUCCESS FUNCTION,
                     * approot	: # APPLICATION ROOT,
                     * dataSend	: # DATA TO SEND TO THE SERVLET,
                     * servletName  : # SERVLET'S NAME
                     */
                    $(this).getData({
                        onDone: function (data) {
                            onDone(data);
                        },
                        onSuccess: function (data) {
                            onSuccess(data);
                        },
                        approot: approot,
                        dataSend: dataSend,
                        servletName: servletName,
                        dataAppendTo: dataAppendTo,
                        notification: notification
                    });
                };

                $('.radio_tipe_periode').click(function () {
                    var value = $(this).val();
                    if (value === "1") {
                        $('.tipe_periode_tanggal').removeClass('tipe_hide');
                        $('.tipe_periode_bulan').addClass('tipe_hide');
                    } else if (value === "2") {
                        $('.tipe_periode_tanggal').addClass('tipe_hide');
                        $('.tipe_periode_bulan').removeClass('tipe_hide');
                    }
                });

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };

                $('.btn-add-item').click(function () {
                    modalSetting("#modal-additem", "static", false, false);
                    $('#modal-additem').modal('show');
                });

                $("form#form-item").submit(function () {
                    var currentBtnHtml = $("#btn-simpan-item").html();
                    $("#btn-simpan-item").html("Menyimpan...").attr({"disabled": "true"});
                    var command = "<%=Command.SAVE%>";

                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        if (error === "0") {
                            $(".item").html(data.FRM_FIELD_HTML);
                        } else {
                            alert("gagal input data");
                        }
                    };

                    if ($(this).find(".has-error").length == 0) {
                        var onSuccess = function (data) {
                            $("#btn-simpan-item").removeAttr("disabled").html(currentBtnHtml);
                            $("#modal-additem").modal("hide");
                            cmdAdd();
                        };

                        var dataSend = $(this).serialize();
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxTabungan", null, false);
                    } else {
                        $("#btn-simpan-item").removeAttr("disabled").html(currentBtnHtml);
                    }

                    return false;
                });

            });
        </script>
    </head> 

    <body style="background-color: #eaf3df;">

        <section class="content-header">
            <h1>Master Tabungan <small></small></h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Tabungan</li>
                <li class="active"><a href="#">Master Tabungan</a></li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Daftar Master Tabungan</h3>
                </div>
                <div class="box-body">
                    <form name="cari" method="get" action="master_tabungan.jsp" class="form-inline">
                        <input type="text" id="keyword" class="form-control input-sm" name="keyword" value="<%=keyword%>">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                    </form>

                    <form name="<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>" method ="post">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="start" value="<%=start%>">
                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                        <input type="hidden" name="hidden_masterTabungan_id" value="<%=oidMasterTabungan%>">

                        <%= drawList(iCommand, frmMasterTabungan, masterTabungan, listMasterTabungan, oidMasterTabungan, SESS_LANGUAGE, start, oidAssignTabungan, multiIdJenisSimpanan)%>
                        <%if(listMasterTabungan.isEmpty()) {out.println("<br>Tidak ada data");}%>
                        <br>
                        <%=ctrLine.drawMeListLimit(commandPagination, vectSize, start, recordToGet, "cmdListFirst", "cmdListPrev", "cmdListNext", "cmdListLast", "left")%>


                        <!-- >>>>>>>>>> FORM PERIODE PENARIKAN <<<<<<<<<< -->
                        <% if (editPeriode == 1) { %>

                        <hr style="border-color: lightgray;">

                        <%
                            MasterTabungan mt = PstMasterTabungan.fetchExc(oidMasterTabungan);
                        %>

                        <label>Periode penarikan tabungan &nbsp;:&nbsp; <%=mt.getNamaTabungan()%> (<%=mt.getKodeTabungan()%>)</label>

                        <%
                            Vector listPeriode = PstAssignPenarikanTabungan.list(0, 0, PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID] + " = '" + oidMasterTabungan + "'", "");
                        %>

                        <table style="width: 100%" id="view_periode">
                            <tr>
                                <td style="width: 60%">
                                    <table style="width: 100%" class="listgen" border="1" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="listgentitle">No.</td>
                                            <td class="listgentitle">Judul Periode</td>
                                            <td class="listgentitle">Tipe Periode</td>
                                            <td class="listgentitle">Jangka Periode</td>
                                            <td class="listgentitle" style="width: 1%">Aksi</td>
                                        </tr>
                                        <%
                                            for (int i = 0; i < listPeriode.size(); i++) {
                                                AssignPenarikanTabungan apt = (AssignPenarikanTabungan) listPeriode.get(i);
                                                MasterTabunganPenarikan mtp = PstMasterTabunganPenarikan.fetchExc(apt.getIdTabunganRangePenarikan());
                                        %>
                                        <tr>
                                            <td class="listgensell"><%=(i + 1)%>.</td>
                                            <td class="listgensell"><%=mtp.getJudulRangePenarikan()%></td>
                                            <td class="listgensell"><%=Transaksi.TIPE_PENARIKAN_TABUNGAN_TITLE[mtp.getTipeRange()]%></td>
                                            <td class="listgensell">
                                                <% if (mtp.getTipeRange() == Transaksi.TIPE_PENARIKAN_TABUNGAN_TANGGAL) {%>
                                                <%=Formater.formatDate(mtp.getStartDate(), "dd MMM yyyy")%> - <%=Formater.formatDate(mtp.getEndDate(), "dd MMM yyyy")%>
                                                <% } else if (mtp.getTipeRange() == Transaksi.TIPE_PENARIKAN_TABUNGAN_BULAN) {%>
                                                <%=mtp.getPeriodeBulan()%> Bulan
                                                <% }%>
                                            </td>
                                            <td class="listgensell text-center" style="white-space: nowrap">
                                                <a class="btn btn-xs btn-warning" href="javascript:cmdEditPeriode('<%=oidMasterTabungan%>','<%=mtp.getOID()%>')">Ubah</a>
                                                <a class="btn btn-xs btn-danger" href="javascript:cmdDeletePeriode('<%=oidMasterTabungan%>','<%=mtp.getOID()%>','<%=apt.getOID()%>')">Hapus</a>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>

                                        <% if (listPeriode.isEmpty()) {%>
                                        <tr>
                                            <td class="listgensell" colspan="5" style="text-align: center">Tidak ada data periode</td>
                                        </tr>
                                        <% }%>

                                    </table>

                                    <br>
                                    <p>
                                        <a class="btn btn-xs btn-primary" href="javascript:cmdAddPeriode('<%=oidMasterTabungan%>')">Tambah periode</a>
                                        <a class="btn btn-xs btn-success" href="javascript:cmdBack()">Selesai</a>
                                    </p>

                                    <p style="background-color: yellow; text-align: center; color: <%=color%>"><%=messagePeriode%></p>

                                    <br>
                                    <i class="fa fa-warning text-red"></i> <label>Ketentuan pembuatan periode penarikan tabungan :</label>
                                    <div>1) Periode penarikan DEPOSITO :</div>
                                    <ul>
                                        <li>Pilih tipe periode '<b>Bulan</b>'.</li>
                                        <li>Masukkan jumlah periode bulan deposito yang diinginkan.</li>
                                        <li>Jumlah periode penarikan untuk deposito (tipe bulan) <b>hanya boleh dibuat 1 periode saja</b>.</li>
                                    </ul>
                                    <div>2) Periode penarikan SELAIN DEPOSITO :</div>
                                    <ul>
                                        <li>Pilih tipe periode '<b>Tanggal</b>'.</li>
                                        <li>Pilih tanggal mulai dan tanggal berakhir sesuai dengan jangka waktu yang diinginkan.</li>
                                        <li>Untuk tipe periode tanggal, jumlah periode <b>bisa dibuat lebih dari 1 periode</b>.</li>
                                    </ul>
                                </td>  

                                <td style="width: 5%"></td>

                                <td style="width: 35%">
                                    <% if (commandPeriode == Command.ADD || commandPeriode == Command.EDIT) {%>

                                    <%
                                        MasterTabunganPenarikan mtp = new MasterTabunganPenarikan();
                                        if (commandPeriode == Command.EDIT && oidPeriode != 0) {
                                            mtp = PstMasterTabunganPenarikan.fetchExc(oidPeriode);
                                        }
                                    %>

                                    <table id="tabel_periode" style="width: 100%">
                                        <tr>
                                            <td>Judul Periode</td>
                                            <td>:</td>
                                            <td><input type="text" name="FRM_JUDUL_PERIODE" value="<%=mtp.getJudulRangePenarikan()%>"></td>
                                        </tr>
                                        <tr>
                                            <td>Tipe Periode Penarikan</td>
                                            <td>:</td>
                                            <td>
                                                <input type="radio" style="display: inline" <%=(mtp.getTipeRange() == Transaksi.TIPE_PENARIKAN_TABUNGAN_TANGGAL) ? "checked" : ""%> class="radio_tipe_periode" name="FRM_TIPE_PERIODE" value="<%= Transaksi.TIPE_PENARIKAN_TABUNGAN_TANGGAL%>"> Tanggal
                                                &nbsp;
                                                <input type="radio" style="display: inline" <%=(mtp.getTipeRange() == Transaksi.TIPE_PENARIKAN_TABUNGAN_BULAN) ? "checked" : ""%> class="radio_tipe_periode" name="FRM_TIPE_PERIODE" value="<%= Transaksi.TIPE_PENARIKAN_TABUNGAN_BULAN%>"> Bulan
                                            </td>
                                        </tr>

                                        <% if (commandPeriode == Command.EDIT) {%>

                                        <%String hide = "tipe_hide";
                                            if (mtp.getTipeRange() == Transaksi.TIPE_PENARIKAN_TABUNGAN_TANGGAL) {
                                                hide = "";
                                            }%>
                                        <tr class="<%=hide%> tipe_periode_tanggal">
                                            <td>Tanggal Mulai Penarikan</td>
                                            <td>:</td>
                                            <td><%=ControlDate.drawDate("FRM_TGL_MULAI", mtp.getStartDate(), "", 0, 100)%></td>
                                        </tr>
                                        <tr class="<%=hide%> tipe_periode_tanggal">
                                            <td>Tanggal Berakhir Penarikan</td>
                                            <td>:</td>
                                            <td><%=ControlDate.drawDate("FRM_TGL_SELESAI", mtp.getEndDate(), "", 0, 100)%></td>
                                        </tr>
                                        <%hide = "tipe_hide";
                                            if (mtp.getTipeRange() == Transaksi.TIPE_PENARIKAN_TABUNGAN_BULAN) {
                                                hide = "";
                                            }%>
                                        <tr class="<%=hide%> tipe_periode_bulan">
                                            <td>Periode Bulan Penarikan</td>
                                            <td>:</td>
                                            <td><input type="number" min="1" name="FRM_JUMLAH_BULAN" value="<%=mtp.getPeriodeBulan()%>"></td>
                                        </tr>                    

                                        <% } else {%>

                                        <tr class="tipe_hide tipe_periode_tanggal">
                                            <td>Tanggal Mulai Penarikan</td>
                                            <td>:</td>
                                            <td><%=ControlDate.drawDate("FRM_TGL_MULAI", null, "", 0, 100)%></td>
                                        </tr>
                                        <tr class="tipe_hide tipe_periode_tanggal">
                                            <td>Tanggal Berakhir Penarikan</td>
                                            <td>:</td>
                                            <td><%=ControlDate.drawDate("FRM_TGL_SELESAI", null, "", 0, 100)%></td>
                                        </tr>

                                        <tr class="tipe_hide tipe_periode_bulan">
                                            <td>Periode Bulan Penarikan</td>
                                            <td>:</td>
                                            <td><input type="number" min="1" name="FRM_JUMLAH_BULAN" value=""></td>
                                        </tr>

                                        <%}%>
                                        <tr>
                                            <td colspan="2"></td>
                                            <td>
                                                <p></p>
                                                <a class="btn btn-xs btn-success" href="javascript:cmdSavePeriode('<%=oidMasterTabungan%>','<%=oidPeriode%>')">Simpan</a>
                                                <a class="btn btn-xs btn-warning" href="javascript:cmdShowPeriode('<%=oidMasterTabungan%>')">Batal</a>
                                            </td>
                                        </tr>
                                    </table>  

                                    <%}%>
                                </td>
                            </tr>
                        </table>

                        <% } %>

                    </form>

                    <%
                        if (editPeriode == 0) {
                            out.println(ctrLine.draw(iCommand, iErrCode, msgString));
                        }
                    %>
                </div>
            </div>

            <a href="master_tabungan.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>
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
                        arr.put(SessHistory.document[SessHistory.DOC_MASTER_TABUNGAN]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% }%>

        </section>

        <!------------------ Modal -------------->
        <div id="modal-additem" class="modal fade" role="dialog">
            <div class="modal-dialog">                
                <!-- Modal content-->
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Tambah Jenis Item</h4>
                    </div>

                    <form id="form-item" enctype="multipart/form-data">
                        <input type="hidden" name="FRM_FIELD_DATA_FOR" id="datafor" value="saveItem">
                        <input type="hidden" name="command" value="<%= Command.SAVE%>">
                        <input type="hidden" name="FRM_FIELD_MASTER_TABUNGAN_ID" value="<%=oidMasterTabungan%>">
                        <input type="hidden" name="SEND_USER_NAME" value="<%=userName%>">
                        <input type="hidden" name="SEND_APP_USER_INIT" value="<%=appUserInit%>">
                        <input type="hidden" name="SEND_USER_OID" value="<%=userOID%>">
                        <input type="hidden" name="SEND_USER_GROUP" value="<%=userGroup%>">
                        <input type="hidden" name="SEND_USER_FULL_NAME" value="<%=userFullName%>">
                        <input type="hidden" name="SEND_APP" value="SEDANA">
                        <input type="hidden" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_ID_JENIS_SIMPANAN]%>" value="0"/>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Item</label>
                                        <input type="text" class="form-control" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_NAMA_SIMPANAN]%>"/>
                                    </div>
                                    <div class="form-group">
                                        <label>Setoran Minimal</label>
                                        <input type="text" class="form-control" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_SETORAN_MIN]%>" value="0.0"/>
                                    </div>
                                    <div class="form-group">
                                        <label>Bunga Per Bulan</label>
                                        <input type="text" class="form-control" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_BUNGA]%>" value="0.0"/>
                                    </div>
                                    <div class="form-group">
                                        <label>Provisi</label>
                                        <input type="text" class="form-control" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_PROVISI]%>" value="0.0"/>
                                    </div>
                                    <div class="form-group">
                                        <label>Biaya Admin Per Bulan</label>
                                        <input type="text" class="form-control" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_BIAYA_ADMIN]%>" value="0.0"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Frekuensi Setoran</label>
                                        <%
                                            Vector val_penyimpanan = new Vector(1, 1);
                                            Vector key_penyimpanan = new Vector(1, 1);
                                            val_penyimpanan.add("" + JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS);
                                            key_penyimpanan.add("" + JenisSimpanan.FREKUENSI_SIMPANAN_TITLE[JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS]);
                                            val_penyimpanan.add("" + JenisSimpanan.FREKUENSI_SIMPANAN_SEKALI);
                                            key_penyimpanan.add("" + JenisSimpanan.FREKUENSI_SIMPANAN_TITLE[JenisSimpanan.FREKUENSI_SIMPANAN_SEKALI]);
                                            val_penyimpanan.add("" + JenisSimpanan.FREKUENSI_SIMPANAN_BERULANG);
                                            key_penyimpanan.add("" + JenisSimpanan.FREKUENSI_SIMPANAN_TITLE[JenisSimpanan.FREKUENSI_SIMPANAN_BERULANG]);
                                        %>
                                        <%=ControlCombo.draw(FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_FREKUENSI_SIMPANAN], "form-control", null, "", val_penyimpanan, key_penyimpanan, "")%>
                                    </div>
                                    <div class="form-group">
                                        <label>Frekuensi Penarikan</label>
                                        <%
                                            Vector val_penarikan = new Vector(1, 1);
                                            Vector key_penarikan = new Vector(1, 1);
                                            val_penarikan.add("" + JenisSimpanan.FREKUENSI_PENARIKAN_BEBAS);
                                            key_penarikan.add("" + JenisSimpanan.FREKUENSI_PENARIKAN_TITLE[JenisSimpanan.FREKUENSI_PENARIKAN_BEBAS]);
                                            val_penarikan.add("" + JenisSimpanan.FREKUENSI_PENARIKAN_SEKALI);
                                            key_penarikan.add("" + JenisSimpanan.FREKUENSI_PENARIKAN_TITLE[JenisSimpanan.FREKUENSI_PENARIKAN_SEKALI]);
                                        %>
                                        <%=ControlCombo.draw(FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_FREKUENSI_PENARIKAN], "form-control", null, "", val_penarikan, key_penarikan, "")%>
                                    </div>
                                    <div class="form-group">
                                        <label>Basis Hari Bunga</label>
                                        <input type="text" class="form-control" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_BASIS_HARI_BUNGA]%>" value="0.0"/>
                                    </div>
                                    <div class="form-group">
                                        <label>Jenis Bunga</label>
                                        <%
                                            Vector val_jb = new Vector(1, 1);
                                            Vector key_jb = new Vector(1, 1);
                                            for (int i = 0; i < JenisSimpanan.BUNGA.size(); i++) {
                                                key_jb.add("" + JenisSimpanan.BUNGA.get(i)[SESS_LANGUAGE]);
                                                val_jb.add("" + i);
                                            }
                                        %>
                                        <%=ControlCombo.draw(FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_JENIS_BUNGA], "form-control", null, "", val_jb, key_jb, "")%>
                                    </div>
                                    <div class="form-group">
                                        <label>Keterangan</label>
                                        <textarea class="form-control" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_DESC_JENIS_SIMPANAN]%>"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-sm btn-success" id="btn-simpan-item"><i class="fa fa-save"></i> &nbsp; Simpan</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>   
        <%
            if (iCommand == Command.ADD || iCommand == Command.EDIT) {
        %>
        <script language="javascript">
            document.<%=FrmMasterTabungan.FRM_NAME_MASTERTABUNGAN%>.<%=FrmMasterTabungan.fieldNames[FrmMasterTabungan.FRM_FIELD_NAMATABUNGAN]%>.focus();
        </script>
        <%
            }
        %>
    </body>
</html>