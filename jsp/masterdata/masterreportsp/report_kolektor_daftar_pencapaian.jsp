<%-- 
    Document   : report_kolektor_daftar_pencapaian
    Created on : Dec 16, 2019, 1:01:29 PM
    Author     : arise
--%>
<%@page import="com.dimata.sedana.entity.report.ReportKredit"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.sedana.print.component.PrintUtility"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAngsuran"%>
<%@page import="com.dimata.pos.entity.billing.PstBillMain"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_KOLEKTOR); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privUpdate && !privDelete){
	response.sendRedirect(approot + "/nopriv.html"); 
}
%>

<%!
	public static final String textHeader[][] = {
		{"Daftar Pencapaian", "Laporan Kolektor", "List Hasil Pencarian", "Form Pencarian", "Kwitansi", "Laporan", "Dengan", "Kolektor", "Tanggal"},
		{"Achievement List", "Collector Report", "Search Result List", "Search Form", "Receipt", "Report", "With", "Collector", "Date"}
	};

	public static final String textCrud[][] ={
		{"Tambah", "Ubah", "Hapus", "Simpan", "Cari", "Cetak"},
		{"Add", "Update", "Delete", "Save", "Search", "Print"}
	};

	public static final String textHeaderTable[][] = {
		{"No.", "Tanggal", "Estimasi Tagihan", "Realisasi Tagihan", "Sisa", "Qty", "Jumlah", "%", "Koml (%)"},
		{"No.", "Date", "Estimated Bill", "Bill Realization", "Rest", "Qty", "Amount", "%", "Koml (%)"}
	};

	public static final String dataTableTitle[][] = {
		{"Tampilkan _MENU_ data per halaman",
			"Data Tidak Ditemukan",
			"Menampilkan halaman _PAGE_ dari _PAGES_",
			"Belum Ada Data",
			"(Disaring dari _MAX_ data)",
			"Pencarian :",
			"Awal",
			"Akhir",
			"Berikutnya",
			"Sebelumnya"},
		{"Display _MENU_ records per page",
			"Nothing found - sorry",
			"Showing page _PAGE_ of _PAGES_",
			"No records available",
			"(filtered from _MAX_ total records)",
			"Search :",
			"First",
			"Last",
			"Next",
			"Previous"}
	};
	

%>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    String[] oidKol = request.getParameterValues("KOLEKTOR_OID");
    String[] oidLoc = request.getParameterValues("LOCATION_ID");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    String reportType = request.getParameter("reportType");

    Date cvtStartDate = null;
    Date cvtEndDate = null;

    String whereClause = "";
    String dataFor = "";
    int type = 0;

    Vector listReport = new Vector(1, 1);
    Vector listAngsuran = new Vector(1, 1);


    Vector listLocation = PstLocation.getListFromApiAll();

//    Vector kolektorList = new Vector(1, 1);
    JSONArray kolektorList = new JSONArray();

//    if (iCommand == Command.LIST) {
//        if (oidKol != null && oidKol.length > 0) {
//            whereClause += "(";
//            for (int i = 0; i < oidKol.length; i++) {
//                long kolektorOid = Long.parseLong(String.valueOf(oidKol[i]));
//                if (i > 0) {
//                    whereClause += " OR ";
//                }
//                whereClause += PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " LIKE '%" + kolektorOid + "%' ";
//            }
//            whereClause += ") ";
//        }
//        kolektorList = PstEmployee.getListEmpDivFromApi(0, 0, whereClause, "");
//        kolektorList = PstEmployee.getListFromApi(0, 0, whereClause, "");

        //listReport = SessReportKredit.listDaftarTagihan(whereClause);
//    }
    if (reportType != null && reportType.length() > 0) {
        type = Integer.parseInt(reportType);
        if (type == 1) {
            dataFor = "perTanggal";
        } else {
            dataFor = "perKolektor";
        }
    }
    Locale locale = new Locale("id", "ID");
    NumberFormat numberFormat = NumberFormat.getInstance(locale);

    Location assLoc = new Location();

    try {
        if (userLocationId != 0) {
            assLoc = PstLocation.fetchExc(userLocationId);
        }
    } catch (Exception e) {
    }

    whereClause += " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_CAIR;
    
    if (oidLoc != null && oidLoc.length > 0) {
        whereClause += " AND (";
        for (int j = 0; j < oidLoc.length; j++) {
            long locOid = Long.parseLong(String.valueOf(oidLoc[j]));
            if (j > 0) {
                whereClause += " OR ";
            }
            whereClause += " loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " LIKE '%" + locOid + "%' ";
        }
        whereClause += ") ";
    }
    
    if (oidKol != null && oidKol.length > 0) {
            whereClause += " AND (";
            for (int i = 0; i < oidKol.length; i++) {
                long kolektorOid = Long.parseLong(String.valueOf(oidKol[i]));
                if (i > 0) {
                    whereClause += " OR ";
                }
                whereClause += "p."+PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " LIKE '%" + kolektorOid + "%' ";
            }
            whereClause += ") ";
        }
//    if ((startDate != null && startDate.length() > 0) && (endDate != null && endDate.length() > 0)) {
//        cvtStartDate = Formater.formatDate(startDate, "yyyy-MM-dd");
//        cvtEndDate = Formater.formatDate(endDate, "yyyy-MM-dd");
//        whereClause += " AND ("
//                + " (TO_DAYS(SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")"
//                + " >= TO_DAYS('" + Formater.formatDate(cvtStartDate, "yyyy-MM-dd") + "'))"
//                + " AND (TO_DAYS(SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")"
//                + " <= TO_DAYS('" + Formater.formatDate(cvtEndDate, "yyyy-MM-dd") + "')))";
//    }
    

    Vector listData = SessReportKredit.listPencapaian(startDate, endDate, type, whereClause);

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@include file="../../style/style_kredit.jsp" %>

		<style type="text/css">
			.print-area { 
				visibility: hidden; 
				display: none; 
			}
            .print-area.print-preview { 
				visibility: visible; 
				display: block; 
			}
			@media all {
				.page-break	{ display: none; }
			}
            @media print{
                body * { 
					visibility: hidden; 
				}
                .print-area * { 
					visibility: visible;
					page-break-inside: auto;
					page-break-after: always;
				}
                .print-area   { 
					visibility: visible; 
					display: block; 
					position: fixed; 
					top: 0; 
					left: 0; 
					overflow: visible;
					height: auto !important;
				}
				div{
					page-break-inside: auto;
				}
				table th{
					background-color: #95a5a6;
					background: #95a5a6;
				}
				table{
					max-height: 100%;
					overflow: hidden;
					page-break-inside:auto;
				}
				tr{
					page-break-inside:avoid; 
					page-break-after:auto;
				}
				thead{
					display: table-header-group;
				}
				.table td, .table th{
					border-color: black;
				}

				
            }
		</style>

    </head>
    <body style="background-color: #eaf3df;">

		<div class="main-page">

			<!-- ===== HEADER ===== -->
			<section class="content-header">
				<h1>
					<%= textHeader[SESS_LANGUAGE][0]%> <small><%= textHeader[SESS_LANGUAGE][1]%></small>
				</h1>
				<ol class="breadcrumb">
					<li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li><%= textHeader[SESS_LANGUAGE][1]%></li>
                    <li class="active"><%= textHeader[SESS_LANGUAGE][0]%></li>
				</ol>
			</section>

			<!-- ===== CONTENT ===== -->
			<section class="content">
				<div class="box box-success">
					<div class="box-header with-border border-gray">
						<h3 class="box-title"> <%= textHeader[SESS_LANGUAGE][3]%> </h3>
					</div>
					<div class="box-body">
						<form id="form-search" class="form-horizontal">
							<input type="hidden" name="command" value="<%= Command.LIST %>">
							<div class="row">
								<div class="col-md-12">
									<div class="col-md-4">
										<div class="form-group">
											<label class="control-label col-md-2">Periode</label>
											<div class="col-md-10">
												<div class="input-group">
													<input type="text" class="form-control datePicker" autocomplete="off"
														   name="startDate" value="<%= startDate == null ? "" : startDate %>">
													<div class="input-group-addon">
														<span>s/d</span>
													</div>
													<input type="text" class="form-control datePicker" autocomplete="off"
														   name="endDate" value="<%= endDate == null ? "" : endDate %>">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="control-label col-md-2">By</label>
											<div class="col-md-10">
												<select class="form-control" name="reportType" id="reportType">
													<option value="0" <%= type == 0 ? "selected" : "" %>><%= textHeader[SESS_LANGUAGE][7] %></option>
													<option value="1" <%= type == 1 ? "selected" : "" %>><%= textHeader[SESS_LANGUAGE][8] %></option>
												</select>
											</div>
										</div>
									</div>
                                                                        <div class="col-md-4">
										<div class="form-group">
											<label class="control-label col-md-2">Lokasi</label>
											<div class="col-md-8">
												<select class="form-control input-sm select2" multiple="multiple" style="width: 100%;" 
														name="LOCATION_ID">
													<% 
                                                                                                                String inLocation = "";
                                                                                                                for(int i = 0; i < listLocation.size(); i++){
															Location  loc = (Location) listLocation.get(i);
                                                                                                                        boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+loc.getOID());
                                                                                                                        if (loc.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
                                                                                                                            inLocation += loc.getOID()+",";
                                                                                                                            String selected = "";
                                                                                                                            if(oidLoc != null && oidLoc.length > 0){
                                                                                                                                    for(String oid : oidLoc){
                                                                                                                                            Long tempOid = Long.parseLong(oid);
                                                                                                                                            if(loc.getOID() == tempOid){
                                                                                                                                                    selected = "selected=''";
                                                                                                                                            }
                                                                                                                                    }
                                                                                                                            } else if (loc.getOID() == userSession.getAppUser().getAssignLocationId()) {
                                                                                                                                selected = "selected=''";
                                                                                                                            }
                                                                                                                            out.println("<option value='" + loc.getOID() + "' " + selected + ">" + loc.getName() + "</option>");
                                                                                                                        }
														} 
                                                                                                                if (inLocation.length()>0){
                                                                                                                    inLocation = inLocation.substring(0, inLocation.length() - 1);
                                                                                                                }
													
													%>
												</select>
											</div>
										</div>
									</div>
									<div class="col-md-4">
										<div class="form-group">
											<label class="control-label col-md-2">Kolektor</label>
											<div class="col-md-8">
												<select class="form-control input-sm select2" multiple="multiple" style="width: 100%;" 
														name="KOLEKTOR_OID">
													<% 
                                                                                                                String whereCollector = "";
                                                                                                            
                                                                                                                int appObjCodePriv = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_PENILAIAN_KREDIT);
                                                                                                                boolean privAccept = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePriv, AppObjInfo.COMMAND_ACCEPT));
                                                                                                                String userGroupAdmin = PstSystemProperty.getValueByName("GROUP_ADMIN_OID");
                                                                                                                String whereUserGroup = PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + "=" + userGroupAdmin
                                                                                                                        + " AND " + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "=" + userSession.getAppUser().getOID();
                                                                                                                Vector listUserGroup = PstUserGroup.list(0, 0, whereUserGroup, "");
                                                                                                                if (!privAccept && listUserGroup.isEmpty()) {
                                                                                                                    whereCollector = "emp."+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+"="+userSession.getAppUser().getEmployeeId();
                                                                                                                } else {
                                                                                                                    whereCollector = "dv."+PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]+" IN ("+inLocation+")";
                                                                                                                }
                                                                                                                Vector listKolektor = PstEmployee.getListFromApi(0, 0, whereCollector, "");
                                                                                                                for(int i = 0; i < listKolektor.size(); i++){
															Employee kol = (Employee) listKolektor.get(i);
															String selected = "";
															if(oidKol != null && oidKol.length > 0){
																for(String oid : oidKol){
																	Long tempOid = Long.parseLong(oid);
																	if(kol.getOID() == tempOid){
																		selected = "selected=''";
																	}
																}
															} else if (kol.getOID() == userSession.getAppUser().getEmployeeId()){
                                                                                                                            selected = "selected=''";
                                                                                                                        }
															out.println("<option value='" + kol.getOID() + "' " + selected + ">" + kol.getFullName() + "</option>");
														} 
													
													%>
												</select>
											</div>
										</div>
									</div>
								</div>
							</div>
						</form>
					</div>
					<div class="box-footer">
						<button type="button" id="search-report-btn" class="btn btn-primary" value="0">
							<i class="fa fa-search"></i>&nbsp;
							<%= textCrud[SESS_LANGUAGE][4]%>
						</button>
					</div>
				</div>
				
				<% if(iCommand == Command.LIST){ %>
				<div id="search-result-box">
					<div class="box box-success">
						<div class="box-header with-border border-gray">
							<h3 class="box-title">
								<%= textHeader[SESS_LANGUAGE][2]%>
								<small>
									Periode 
									<% 
										String txt = "";
										if(cvtStartDate != null && cvtEndDate != null){
											txt = Formater.formatDate(cvtStartDate, "dd MMMM yyyy") + " - " + Formater.formatDate(cvtEndDate, "dd MMMM yyyy") + ".";
										} else {
											txt = "Semua.";
										}
										out.println(txt);
									%>
								</small>
							</h3>
							<div class="pull-right">
								<button type="button" id="print-report-btn" class="btn btn-warning" value="0">
									<i class="fa fa-print"></i>&nbsp;
									<%= textCrud[SESS_LANGUAGE][5]%> <%= textHeader[SESS_LANGUAGE][5] %>
								</button>
							</div>
						</div>
						<div>
						<div class="box-body">
							
							<div id="search-result-table-parent">
								<form id="form-list-kwitansi">
								<table id="search-result-table" class="table table-bordered table-striped table-responsive table-hover">
									<thead>
										<tr>
											<th style="width: 5%" rowspan="2"> <%= textHeaderTable[SESS_LANGUAGE][0]%> </th>
											<th style="width: 15%" rowspan="2"> <%= textHeaderTable[SESS_LANGUAGE][1]%> </th>
											<th style="width: 15%" colspan="2"> <%= textHeaderTable[SESS_LANGUAGE][2]%> </th>
											<th style="width: 15%" colspan="4"> <%= textHeaderTable[SESS_LANGUAGE][3]%> </th>
											<th style="width: 15%" colspan="2"> <%= textHeaderTable[SESS_LANGUAGE][4]%> </th>
										</tr>
										<tr>
											<th style="width: 5%"> <%= textHeaderTable[SESS_LANGUAGE][5]%> </th>
											<th style="width: 15%"> <%= textHeaderTable[SESS_LANGUAGE][6]%> </th>
											<th style="width: 5%"> <%= textHeaderTable[SESS_LANGUAGE][5]%> </th>
											<th style="width: 15%"> <%= textHeaderTable[SESS_LANGUAGE][6]%> </th>
											<th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][7]%> </th>
											<th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][8]%> </th>
											<th style="width: 5%"> <%= textHeaderTable[SESS_LANGUAGE][5]%> </th>
											<th style="width: 15%"> <%= textHeaderTable[SESS_LANGUAGE][6]%> </th>
										</tr>
									</thead>
									<tbody>
                                                                            <%
                                                                                if (listData.size()>0){
                                                                                    long oidCol = 0;
                                                                                    int subQtyEst = 0;
                                                                                    int subQtyReal = 0;
                                                                                    int subQtySisa = 0;
                                                                                    double subTotalEst = 0;
                                                                                    double subTotalReal = 0;
                                                                                    double subTotalSisa = 0;
                                                                                    
                                                                                    int grandQtyEst = 0;
                                                                                    int grandQtyReal = 0;
                                                                                    int grandQtySisa = 0;
                                                                                    double grandTotalEst = 0;
                                                                                    double grandTotalReal = 0;
                                                                                    double grandTotalSisa = 0;
                                                                                    
                                                                                    int cnt = 0;
                                                                                    if (type == 0) {
                                                                                        for (int i = 0; i < listData.size(); i++){
                                                                                            ReportKredit report = (ReportKredit) listData.get(i);
                                                                                            if (oidCol != report.getOidCollector()){

                                                                                                cnt = 0;
                                                                                                cnt++;
                                                                                                Employee emp = PstEmployee.fetchFromApiWResigned(report.getOidCollector());
                                                                                                if (oidCol == 0){
                                                                                                    oidCol = report.getOidCollector();
                                                                                                    out.println("<tr>");
                                                                                                    out.println("<td class='text-left text-bold' colspan='10'>" + emp.getFullName() + (emp.getResigned() == 0 ? "" : " (Resign)")+ " </td>");
                                                                                                    //out.println("<td class='text-right text-bold' >Lokasi: </td>");
                                                                                                    //out.println("<td class='text-left text-bold' colspan='3'>" + kolLoc.getName() + "</td>");
                                                                                                    out.println("</tr>");

                                                                                                    Date dateCvt = Formater.formatDate(report.getTglAngs(), "yyyy-MM-dd");
                                                                                                    int qtyEst = report.getQtyEst();
                                                                                                    subQtyEst += qtyEst;
                                                                                                    double totalEst = report.getJumEst();
                                                                                                    subTotalEst += totalEst;
                                                                                                    Calendar calendar = Calendar.getInstance(locale);
                                                                                                    calendar.setTime(dateCvt);
                                                                                                    int day = calendar.get(Calendar.DAY_OF_WEEK);
                                                                                                    out.println("<tr>");
                                                                                                    out.println("<td class='text-center'>" + cnt + "</td>");
                                                                                                    SimpleDateFormat sdf = new SimpleDateFormat("EEEE", locale);
                                                                                                    out.println("<td class='text-center'>" + sdf.format(dateCvt) + "<br>" + Formater.formatDate(dateCvt, "dd MMMM yyyy") + "</td>");
                                                                                                    out.println("<td class='text-center'>" + qtyEst + "</td>");
                                                                                                    out.println("<td class='text-left'>Rp." + numberFormat.format(totalEst) + "</td>");
                                                                                                    int qtyReal = report.getQtyReal();
                                                                                                    subQtyReal += qtyReal;
                                                                                                    double totalReal = report.getJumReal();
                                                                                                    subTotalReal += totalReal;
                                                                                                    out.println("<td class='text-center'>" + qtyReal + "</td>");
                                                                                                    out.println("<td class='text-left'>Rp. " + numberFormat.format(totalReal) + "</td>");
                                                                                                    out.println("<td class='text-center'>" + Formater.formatNumber(((totalReal / totalEst) * 100), "##.##") + "%</td>");
                                                                                                    out.println("<td class='text-center'>" + Formater.formatNumber(((subTotalReal / subTotalEst) * 100), "##.##") + "%</td>");
                                                                                                    double sisaTotal = totalEst - totalReal;
                                                                                                    int sisaQty = qtyEst - qtyReal;
                                                                                                    subQtySisa += sisaQty;
                                                                                                    subTotalSisa += sisaTotal;
                                                                                                    out.println("<td class='text-center'>" + sisaQty + "</td>");
                                                                                                    out.println("<td class='text-left'>Rp. " + numberFormat.format(sisaTotal) + "</td>");
                                                                                                    out.println("</tr>");


                                                                                                } else {

                                                                                                    oidCol = report.getOidCollector();
                                                                                                    out.println("<tr>");
                                                                                                    out.println("<td class='text-right' colspan='2'><b>Sub Total</b></td>");
                                                                                                    out.println("<td class='text-center'><b>" + subQtyEst + "</b></td>");
                                                                                                    out.println("<td class='text-left'><b>Rp. " + numberFormat.format(subTotalEst) + "</b></td>");
                                                                                                    out.println("<td class='text-center'><b>" + subQtyReal + "</b></td>");
                                                                                                    out.println("<td class='text-left'><b>Rp. " + numberFormat.format(subTotalReal) + "</b></td>");
                                                                                                    out.println("<td class='text-center'><b>" + Formater.formatNumber(((subTotalReal / subTotalEst) * 100), "##.##") + "%</b></td>");
                                                                                                    out.println("<td class='text-center'></td>");
                                                                                                    out.println("<td class='text-center'><b>" + subQtySisa + "</b></td>");
                                                                                                    out.println("<td class='text-left'><b>Rp. " + numberFormat.format(subTotalSisa) + "</b></td>");
                                                                                                    out.println("</tr>");


                                                                                                    grandQtyEst += subQtyEst;
                                                                                                    grandQtyReal += subQtyReal;
                                                                                                    grandQtySisa += subQtySisa;
                                                                                                    grandTotalEst += subTotalEst;
                                                                                                    grandTotalReal += subTotalReal;
                                                                                                    grandTotalSisa += subTotalSisa;

                                                                                                    subQtyEst = 0;
                                                                                                    subTotalEst = 0;
                                                                                                    subQtyReal = 0;
                                                                                                    subTotalReal = 0;
                                                                                                    subQtySisa = 0;
                                                                                                    subTotalSisa = 0;

                                                                                                    out.println("<tr>");
                                                                                                    out.println("<td class='text-left text-bold' colspan='10'>" + emp.getFullName() + "</td>");
                                                                                                    //out.println("<td class='text-right text-bold' >Lokasi: </td>");
                                                                                                    //out.println("<td class='text-left text-bold' colspan='3'>" + kolLoc.getName() + "</td>");
                                                                                                    out.println("</tr>");

                                                                                                    Date dateCvt = Formater.formatDate(report.getTglAngs(), "yyyy-MM-dd");
                                                                                                    int qtyEst = report.getQtyEst();
                                                                                                    subQtyEst += qtyEst;
                                                                                                    double totalEst = report.getJumEst();
                                                                                                    subTotalEst += totalEst;
                                                                                                    Calendar calendar = Calendar.getInstance(locale);
                                                                                                    calendar.setTime(dateCvt);
                                                                                                    int day = calendar.get(Calendar.DAY_OF_WEEK);
                                                                                                    out.println("<tr>");
                                                                                                    out.println("<td class='text-center'>" + cnt + "</td>");
                                                                                                    SimpleDateFormat sdf = new SimpleDateFormat("EEEE", locale);
                                                                                                    out.println("<td class='text-center'>" + sdf.format(dateCvt) + "<br>" + Formater.formatDate(dateCvt, "dd MMMM yyyy") + "</td>");
                                                                                                    out.println("<td class='text-center'>" + qtyEst + "</td>");
                                                                                                    out.println("<td class='text-left'>Rp." + numberFormat.format(totalEst) + "</td>");
                                                                                                    int qtyReal = report.getQtyReal();
                                                                                                    subQtyReal += qtyReal;
                                                                                                    double totalReal = report.getJumReal();
                                                                                                    subTotalReal += totalReal;
                                                                                                    out.println("<td class='text-center'>" + qtyReal + "</td>");
                                                                                                    out.println("<td class='text-left'>Rp. " + numberFormat.format(totalReal) + "</td>");
                                                                                                    out.println("<td class='text-center'>" + Formater.formatNumber(((totalReal / totalEst) * 100), "##.##") + "%</td>");
                                                                                                    out.println("<td class='text-center'>" + Formater.formatNumber(((subTotalReal / subTotalEst) * 100), "##.##") + "%</td>");
                                                                                                    double sisaTotal = totalEst - totalReal;
                                                                                                    int sisaQty = qtyEst - qtyReal;
                                                                                                    subQtySisa += sisaQty;
                                                                                                    subTotalSisa += sisaTotal;
                                                                                                    out.println("<td class='text-center'>" + sisaQty + "</td>");
                                                                                                    out.println("<td class='text-left'>Rp. " + numberFormat.format(sisaTotal) + "</td>");
                                                                                                    out.println("</tr>");
                                                                                                }

                                                                                            } else {
                                                                                                cnt++;
                                                                                                Date dateCvt = Formater.formatDate(report.getTglAngs(), "yyyy-MM-dd");
                                                                                                int qtyEst = report.getQtyEst();
                                                                                                subQtyEst += qtyEst;
                                                                                                double totalEst = report.getJumEst();
                                                                                                subTotalEst += totalEst;
                                                                                                Calendar calendar = Calendar.getInstance(locale);
                                                                                                calendar.setTime(dateCvt);
                                                                                                int day = calendar.get(Calendar.DAY_OF_WEEK);
                                                                                                out.println("<tr>");
                                                                                                out.println("<td class='text-center'>" + cnt + "</td>");
                                                                                                SimpleDateFormat sdf = new SimpleDateFormat("EEEE", locale);
                                                                                                out.println("<td class='text-center'>" + sdf.format(dateCvt) + "<br>" + Formater.formatDate(dateCvt, "dd MMMM yyyy") + "</td>");
                                                                                                out.println("<td class='text-center'>" + qtyEst + "</td>");
                                                                                                out.println("<td class='text-left'>Rp." + numberFormat.format(totalEst) + "</td>");
                                                                                                int qtyReal = report.getQtyReal();
                                                                                                subQtyReal += qtyReal;
                                                                                                double totalReal = report.getJumReal();
                                                                                                subTotalReal += totalReal;
                                                                                                out.println("<td class='text-center'>" + qtyReal + "</td>");
                                                                                                out.println("<td class='text-left'>Rp. " + numberFormat.format(totalReal) + "</td>");
                                                                                                out.println("<td class='text-center'>" + Formater.formatNumber(((totalReal / totalEst) * 100), "##.##") + "%</td>");
                                                                                                out.println("<td class='text-center'>" + Formater.formatNumber(((subTotalReal / subTotalEst) * 100), "##.##") + "%</td>");
                                                                                                double sisaTotal = totalEst - totalReal;
                                                                                                int sisaQty = qtyEst - qtyReal;
                                                                                                subQtySisa += sisaQty;
                                                                                                subTotalSisa += sisaTotal;
                                                                                                out.println("<td class='text-center'>" + sisaQty + "</td>");
                                                                                                out.println("<td class='text-left'>Rp. " + numberFormat.format(sisaTotal) + "</td>");
                                                                                                out.println("</tr>");
                                                                                            }

                                                                                        }

                                                                                        out.println("<tr>");
                                                                                        out.println("<td class='text-right' colspan='2'><b>Sub Total</b></td>");
                                                                                        out.println("<td class='text-center'><b>" + subQtyEst + "</b></td>");
                                                                                        out.println("<td class='text-left'><b>Rp. " + numberFormat.format(subTotalEst) + "</b></td>");
                                                                                        out.println("<td class='text-center'><b>" + subQtyReal + "</b></td>");
                                                                                        out.println("<td class='text-left'><b>Rp. " + numberFormat.format(subTotalReal) + "</b></td>");
                                                                                        out.println("<td class='text-center'><b>" + Formater.formatNumber(((subTotalReal / subTotalEst) * 100), "##.##") + "%</b></td>");
                                                                                        out.println("<td class='text-center'></td>");
                                                                                        out.println("<td class='text-center'><b>" + subQtySisa + "</b></td>");
                                                                                        out.println("<td class='text-left'><b>Rp. " + numberFormat.format(subTotalSisa) + "</b></td>");
                                                                                        out.println("</tr>");


                                                                                        grandQtyEst += subQtyEst;
                                                                                        grandQtyReal += subQtyReal;
                                                                                        grandQtySisa += subQtySisa;
                                                                                        grandTotalEst += subTotalEst;
                                                                                        grandTotalReal += subTotalReal;
                                                                                        grandTotalSisa += subTotalSisa;
                                                                                    } else {
                                                                                        for (int i = 0; i < listData.size(); i++){
                                                                                            ReportKredit report = (ReportKredit) listData.get(i);
                                                                                            cnt++;
                                                                                            
                                                                                            Date dateCvt = Formater.formatDate(report.getTglAngs(), "yyyy-MM-dd");
                                                                                            int qtyEst = report.getQtyEst();
                                                                                            grandQtyEst += qtyEst;
                                                                                            double totalEst = report.getJumEst();
                                                                                            grandTotalEst += totalEst;
                                                                                            Calendar calendar = Calendar.getInstance(locale);
                                                                                            calendar.setTime(dateCvt);
                                                                                            int day = calendar.get(Calendar.DAY_OF_WEEK);
                                                                                            out.println("<tr>");
                                                                                            out.println("<td class='text-center'>" + cnt + "</td>");
                                                                                            SimpleDateFormat sdf = new SimpleDateFormat("EEEE", locale);
                                                                                            out.println("<td class='text-center'>" + sdf.format(dateCvt) + "<br>" + Formater.formatDate(dateCvt, "dd MMMM yyyy") + "</td>");
                                                                                            out.println("<td class='text-center'>" + qtyEst + "</td>");
                                                                                            out.println("<td class='text-left'>Rp." + numberFormat.format(totalEst) + "</td>");
                                                                                            int qtyReal = report.getQtyReal();
                                                                                            grandQtyReal += qtyReal;
                                                                                            double totalReal = report.getJumReal();
                                                                                            grandTotalReal += totalReal;
                                                                                            out.println("<td class='text-center'>" + qtyReal + "</td>");
                                                                                            out.println("<td class='text-left'>Rp. " + numberFormat.format(totalReal) + "</td>");
                                                                                            out.println("<td class='text-center'>" + Formater.formatNumber(((totalReal / totalEst) * 100), "##.##") + "%</td>");
                                                                                            out.println("<td class='text-center'>" + Formater.formatNumber(((grandTotalReal / grandTotalEst) * 100), "##.##") + "%</td>");
                                                                                            double sisaTotal = totalEst - totalReal;
                                                                                            int sisaQty = qtyEst - qtyReal;
                                                                                            grandQtySisa += sisaQty;
                                                                                            grandTotalSisa += sisaTotal;
                                                                                            out.println("<td class='text-center'>" + sisaQty + "</td>");
                                                                                            out.println("<td class='text-left'>Rp. " + numberFormat.format(sisaTotal) + "</td>");
                                                                                            out.println("</tr>");
                                                                                            
                                                                                        }
                                                                                    }
                                                                                    out.println("<tr>");
                                                                                    out.println("<td class='text-right' colspan='2'><b>Grand Total</b></td>");
                                                                                    out.println("<td class='text-center'><b>" + grandQtyEst + "</b></td>");
                                                                                    out.println("<td class='text-left'><b>Rp. " + numberFormat.format(grandTotalEst) + "</b></td>");
                                                                                    out.println("<td class='text-center'><b>" + grandQtyReal + "</b></td>");
                                                                                    out.println("<td class='text-left'><b>Rp. " + numberFormat.format(grandTotalReal) + "</b></td>");
                                                                                    out.println("<td class='text-center'><b>" + Formater.formatNumber(((grandTotalReal / grandTotalEst) * 100), "##.##") + "%</b></td>");
                                                                                    out.println("<td class='text-center'></td>");
                                                                                    out.println("<td class='text-center'><b>" + grandQtySisa + "</b></td>");
                                                                                    out.println("<td class='text-left'><b>Rp. " + numberFormat.format(grandTotalSisa) + "</b></td>");
                                                                                    out.println("</tr>");
                                                                                    
                                                                                }
                                                                            %>
									</tbody>
								</table>
								</form>
							</div>
						</div>
					</div>
				</div>
				<% }%>
			</section>
		</div>

		<script>
			$(document).ready(function(){
				$(".select2").select2();
				
				$('.datePicker').datetimepicker({
					format: "yyyy-mm-dd",
					todayBtn: true,
					autoclose: true,
					minView: 2
				});
				
				$('body').on('click', '#print-report-btn', function(){
					var formParam = $('#form-search').serialize();
					var url = "<%= approot %>/PrintPencapaianTagihan?approot=<%= approot %>&SESS_LANGUAGE=<%= SESS_LANGUAGE %>&LOCATION_OID=<%= userLocationId %>&dataFor=<%= dataFor %>&" + formParam;
					window.open(url);
				});
				
				$('body').on('click', '#search-report-btn', function(){
                                        $(this).html("Tunggu...");
					var formParam = $('#form-search').serialize();
					window.location = "report_kolektor_daftar_pencapaian.jsp?" + formParam;
				});
				
				$('input[type="checkbox"].flat-green').iCheck({
				  checkboxClass: 'icheckbox_square-green'
				});
				
				var checkboxes = $('table tbody tr td input:checkbox');
				
				$('body').on('ifChecked', '#select-kwitansi-all-btn', function(){
					checkboxes.iCheck('check');
				});
				$('body').on('ifUnchecked', '#select-kwitansi-all-btn', function(){
					checkboxes.iCheck('uncheck');
				});
				
			});
		</script>
										
    </body>
</html>
