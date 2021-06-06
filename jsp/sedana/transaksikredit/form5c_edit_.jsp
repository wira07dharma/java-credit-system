<%-- 
    Document   : form5c_edit
    Created on : Nov 25, 2019, 2:11:23 PM
    Author     : arise
--%>

<%@page import="com.dimata.sedana.entity.analisakredit.PstAnalisaKreditMain"%>
<%@page import="com.dimata.sedana.entity.analisakredit.AnalisaKreditMain"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.form.analisakredit.FrmAnalisaKreditDetail"%>
<%@page import="com.dimata.sedana.form.analisakredit.FrmAnalisaKreditMain"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%!
	public static String textHeader[][] = {
			{"Form 5C", "Kredit", "Input", "Detail", "Analisa Penilaian"},
			{"Form 5C", "Kredit", "Input", "Detail", "Analysis Assessment"}
		};
		public static String textGlobal[][] = {
			{"Data Umum", "Kemampuan Bayar", "Analis", "Komite Kredit", "Approve", "Total Nilai"},
			{"General Data", "Paying Capability", "Analyst", "Loan Committee", "Approve", "Total Value"}
		};
		public static String textForm[][] = {
			{"Nomor", "No. Kredit", "Nama", "Tanggal", "Catatan", "Penghasilan", "Pengeluaran", "Surplus untuk Angsuran", "Angsuran Pinjaman", "Kepala Divisi", "Manager", "Pemohon", "Penanggung", "Konsumsi", "Listelpam", "Pendidikan", "Sandang", "Lainnya", "Total"},
			{"Number", "Loan Number", "Name", "Date", "Notes", "Income", "Spending", "Surplus for Installments", "Loan installments", "Division Head", "Manager", "Applicant", "Insurer", "Consumption", "Listelpam", "Education", "Clothings", "Others", "Total"}
		};
		public static String textCrud[][] = {
			{"Tambah", "Ubah", "Hapus", "Simpan", "Kembali", "Pilih"},
			{"Add", "Update", "Delete", "Save", "Back", "Select"}
		};
		public static String textCurrency[] = {
			"Rp.", "$"
		};
		public static String textTableHeader[][] = {
			{"Group", "Deskripsi", "Nilai", "Bobot", "Skor", "Catatan", "Aksi"},
			{"Group", "Description", "Value", "Weight", "Score", "Note", "Action"}
		};
		public static String textEmployeeTableHeader[][] = {
			{"No", "Nomor Pegawai", "Nama", "Departement", "Aksi"},
			{"No", "Employee Number", "Nama", "Departement", "Action"}
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
	
	long oidAnalisaMain = FRMQueryString.requestLong(request, "oidanalisamain");
	long oidPinjaman = FRMQueryString.requestLong(request, "oidpinjaman");
	
	long oidPosKadiv = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_KADIV_KREDIT_OID"));
	long oidPosManOpr = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_MANAGER_OPERASIONAL_OID"));
	
	String whereClause = "";
	
	AnalisaKreditMain akm = new AnalisaKreditMain();
	Pinjaman pinjaman = new Pinjaman();
	Anggota analis = new Anggota();
	
	Vector listAngsuran = new Vector();
	JadwalAngsuran ja = new JadwalAngsuran();
	
	try {
			pinjaman = PstPinjaman.fetchExc(oidPinjaman);
			analis = PstAnggota.fetchExc(pinjaman.getAccountOfficerId());
			if(oidAnalisaMain != 0){
				akm = PstAnalisaKreditMain.fetchExc(oidAnalisaMain);
			} else {
				whereClause = PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PINJAMANID] + "=" + pinjaman.getOID();
				Vector listAkm = PstAnalisaKreditMain.list(0, 0, whereClause, "");
				akm = (AnalisaKreditMain) listAkm.get(0);
			} 
			
			whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + "=" + pinjaman.getOID();
			listAngsuran = PstJadwalAngsuran.list(0, 0, whereClause, "");
			if(!listAngsuran.isEmpty()){
				ja = (JadwalAngsuran) listAngsuran.get(0);
			}
			
		} catch (Exception e) {
		}

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/font-awesome-4.7.0/css/font-awesome.min.css">        
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/ionicons-2.0.1/css/ionicons.min.css">        
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/iCheck/all.css">        
        <!-- Datetime Picker -->
        <link href="../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <!-- Select2 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins
             folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
        <link href="../../style/datatables/dataTables.bootstrap.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../../style/bootstrap-notify/bootstrap-notify.css"/>


        <!-- jQuery 2.2.3 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <!-- Bootstrap 3.3.6 -->
        <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <script src="../../style/AdminLTE-2.3.11/plugins/iCheck/icheck.min.js"></script>
        <!-- FastClick -->
        <script src="../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>

        <!-- AdminLTE for demo purposes -->
        <script src="../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
        <!-- AdminLTE App -->
        <script type="text/javascript" src="../../style/bootstrap-notify/bootstrap-notify.js"></script>
        <script src="../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>    
        <script src="../../style/dist/js/dimata-app.js" type="text/javascript"></script>
        <!-- Select2 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
        <!-- Datetime Picker -->
        <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <script src="../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
        <script src="../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>
        <script src="<%=approot%>/style/money/jquery.maskMoney.min.js" type="text/javascript"></script>

		<style>
			.lds-dual-ring {
				display: inline-block;
				width: 80px;
				height: 80px;
			}
			.lds-dual-ring:after {
				content: " ";
				display: block;
				width: 24px;
				height: 24px;
				margin: 8px;
				border-radius: 50%;
				border: 4px solid #00a65a;
				border-color: #00a65a transparent #00a65a transparent;
				animation: lds-dual-ring 1.2s linear infinite;
			}
			@keyframes lds-dual-ring {
				0% {
					transform: rotate(0deg);
				}
				100% {
					transform: rotate(360deg);
				}
			}
		</style>

    </head>
    <body style="background-color: #eaf3df;">
		<div class="main-page">
			<section class="content-header">
				<h1>
					<%= textHeader[SESS_LANGUAGE][0]%>
				</h1>
				<ol class="breadcrumb">
					<li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li><%= textHeader[SESS_LANGUAGE][1]%></li>
                    <li class="active"><%= textHeader[SESS_LANGUAGE][0]%></li>
				</ol>
			</section>

			<section class="content">
				<div class="box box-success">
					<div class="box-header with-border border-gray">
						<h3 class="box-title"><%= textHeader[SESS_LANGUAGE][2]%> <%= textHeader[SESS_LANGUAGE][0]%></h3>
					</div>
					<div class="box-body">
						
						<form id="<%= FrmAnalisaKreditMain.FRM_NAME_ANALISAKREDITMAIN%>">
							<input type="hidden" value="<%= oidPinjaman %>"
								   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PINJAMANID]%>"
								   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PINJAMANID]%>">
							<input type="hidden" value="<%= pinjaman.getAccountOfficerId() %>"
								   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_ANALISID]%>"
								   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_ANALISID]%>">
							<input type="hidden" value="<%= akm.getDivisionHeadId() %>"
								   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_DIVISIONHEADID]%>"
								   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_DIVISIONHEADID]%>">
							<input type="hidden" value="<%= akm.getManagerId()%>"
								   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_MANAGERID]%>"
								   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_MANAGERID]%>">
							<input type="hidden" value="<%= ((akm.getLocationId()==0)? userLocationId : akm.getLocationId()) %>"
								   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_LOCATIONID]%>"
								   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_LOCATIONID]%>">
							<div class="row form-horizontal">
								<div class="col-sm-6">
									<h4 class="box-title text-bold"><%= textGlobal[SESS_LANGUAGE][0]%></h4>
									<!--<label class="text-bold"><%= textGlobal[SESS_LANGUAGE][0]%></label>-->
									<div class="form-group row">
										<label class="col-sm-3 control-label"><%= textForm[SESS_LANGUAGE][0]%></label>
										<div class="col-sm-6">
											<input type="text" class="form-control input-sm" value="<%= ((akm.getAnalisaNumber().equals(""))? "" : akm.getAnalisaNumber()) %>"
												   placeholder="<- dibuat otomatis apabila kosong ->"
												   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_ANALISANUMBER]%>"
												   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_ANALISANUMBER]%>">
										</div>
									</div>
									<div class="form-group row">
										<label class="col-sm-3 control-label"><%= textForm[SESS_LANGUAGE][1]%></label>
										<div class="col-sm-6">
											<input type="text" class="form-control input-sm" name="nokredit" id="nokredit_" value="<%= pinjaman.getNoKredit() %>" readonly="">
										</div>
									</div>
									<div class="form-group row">
										<label class="col-sm-3 control-label" control-label><%= textForm[SESS_LANGUAGE][2]%> <%= textGlobal[SESS_LANGUAGE][2]%></label>
										<div class="col-sm-6">
											<input type="text" class="form-control input-sm" name="namaanalis" id="namaanalis_" value="<%= analis.getName() %>" readonly="">
										</div>
									</div>
									<div class="form-group row">
										<label class="col-sm-3 control-label" control-label><%= textForm[SESS_LANGUAGE][3]%></label>
										<div class="col-sm-6">
											<input type="text" class="form-control input-sm datePicker" value="<%= Formater.formatDate(((akm.getAnalisaTgl()==null)? new Date():akm.getAnalisaTgl()),"yyyy-MM-dd") %>"
												   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_ANALISATGL]%>"
												   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_ANALISATGL]%>">
										</div>
									</div>
									<div class="form-group row">
										<label class="col-sm-3 control-label"><%= textForm[SESS_LANGUAGE][8]%></label>
										<div class="col-sm-6">
											<div class="input-group">
												<span class="input-group-addon"><%= textCurrency[0]%></span>
												<input type="text" class="form-control input-sm money" name="angsuran" id="angsuran_" value="<%= ja.getJumlahANgsuran() %>" readonly="">
											</div>
										</div>
									</div>
									<div class="form-group row">
										<label class="col-sm-3 control-label"><%= textForm[SESS_LANGUAGE][4]%></label>
										<div class="col-sm-6">
											<textarea class="form-control input-sm" rows="3"
													  name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_ANALISANOTE]%>"
													  id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_ANALISANOTE]%>"><%= akm.getAnalisaNote()%></textarea>
										</div>
									</div>
								</div>
								<div class="col-sm-6">
									<h4 class="box-title text-bold"><%= textGlobal[SESS_LANGUAGE][1]%></h4>
									<div class="row">
										<div class="col-sm-12">
										   <div class="col-sm-5">
											   <h5 class="text-bold text-center"><%= textForm[SESS_LANGUAGE][6]%></h5>
											   <div class="form-group">
												   <label class="control-label"><%= textForm[SESS_LANGUAGE][13]%></label>
												   <div class="input-group">
													   <span class="input-group-addon"><%= textCurrency[0]%></span>
													   <input type="text" class="form-control input-sm money pengeluaran" data-cast-class="pengeluaran" value="<%= akm.getPengeluaranKonsumsi()%>">
													   <input type="hidden" class="pengeluaran" value="<%= akm.getPengeluaranKonsumsi()%>"
															  name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_KONSUMSI]%>" 
															  id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_KONSUMSI]%>">
												   </div>												   
											   </div>
											   <div class="form-group">
												   <label class="control-label"><%= textForm[SESS_LANGUAGE][14]%></label>
												   <div class="input-group">
													   <span class="input-group-addon"><%= textCurrency[0]%></span>
													   <input type="text" class="form-control input-sm money pengeluaran" data-cast-class="pengeluaran" value="<%= akm.getPengeluaranListelpam()%>">
													   <input type="hidden" class="pengeluaran" value="<%= akm.getPengeluaranListelpam()%>"
															  name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_LISTELPAM]%>" 
															  id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_LISTELPAM]%>">
												   </div>
											   </div>
											   <div class="form-group">
												   <label class="control-label"><%= textForm[SESS_LANGUAGE][15]%></label>
												   <div class="input-group">
													   <span class="input-group-addon"><%= textCurrency[0]%></span>
													   <input type="text" class="form-control input-sm money pengeluaran" data-cast-class="pengeluaran" value="<%= akm.getPengeluaranPendidikan()%>">
													   <input type="hidden" class="pengeluaran" value="<%= akm.getPengeluaranPendidikan()%>"
															  name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_PENDIDIKAN]%>" 
															  id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_PENDIDIKAN]%>">
												   </div>
											   </div>
											   <div class="form-group">
												   <label class="control-label"><%= textForm[SESS_LANGUAGE][16]%></label>
												   <div class="input-group">
													   <span class="input-group-addon"><%= textCurrency[0]%></span>
													   <input type="text" class="form-control input-sm money pengeluaran" data-cast-class="pengeluaran" value="<%= akm.getPengeluaranSandang()%>">
													   <input type="hidden" class="pengeluaran" value="<%= akm.getPengeluaranSandang()%>"
															  name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_SANDANG]%>" 
															  id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_SANDANG]%>">
												   </div>
											   </div>
											   <div class="form-group">
												   <label class="control-label"><%= textForm[SESS_LANGUAGE][17]%></label>
												   <div class="input-group">
													   <span class="input-group-addon"><%= textCurrency[0]%></span>
													   <input type="text" class="form-control input-sm money pengeluaran" data-cast-class="pengeluaran" value="<%= akm.getPengeluaranLainnya()%>">
													   <input type="hidden" class="pengeluaran" value="<%= akm.getPengeluaranLainnya()%>"
															  name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_LAINNYA]%>" 
															  id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_LAINNYA]%>">
												   </div>
											   </div>
										   </div>
										   <div class="col-sm-1"></div>
										   <div class="col-sm-5">
												<h5 class="text-bold text-center"><%= textForm[SESS_LANGUAGE][5]%></h5>
												<div class="form-group">
													<label class="control-label"><%= textForm[SESS_LANGUAGE][11]%></label>
													<div class="input-group">
														<span class="input-group-addon"><%= textCurrency[0]%></span>
														<input type="text" class="form-control input-sm money penghasilan" data-cast-class="penghasilanPemohon" value="<%= akm.getPenghasilanPemohon()%>">
														<input type="hidden" class="penghasilanPemohon" value="<%= akm.getPenghasilanPemohon()%>"
															   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGHASILAN_PEMOHON]%>"
															   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGHASILAN_PEMOHON]%>" >
													</div>
												</div>
												<div class="form-group">
													<label class="control-label"><%= textForm[SESS_LANGUAGE][12]%></label>
													<div class="input-group">
														<span class="input-group-addon"><%= textCurrency[0]%></span>
														<input type="text" class="form-control input-sm money penghasilan" data-cast-class="penghasilanPenanggung" value="<%= akm.getPenghasilanPenanggung()%>">
														<input type="hidden" class="penghasilanPenanggung" value="<%= akm.getPenghasilanPenanggung()%>"
															   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGHASILAN_PENANGGUNG]%>"
															   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGHASILAN_PENANGGUNG]%>" >
													</div>
												</div>
													
												<!--<h5 class="text-bold text-center"><%= textForm[SESS_LANGUAGE][18]%></h5>-->
												<div class="form-group">
													<label class="control-label"><%= textForm[SESS_LANGUAGE][18]%> <%= textForm[SESS_LANGUAGE][5]%></label>
													<div class="input-group">
														<span class="input-group-addon"><%= textCurrency[0]%></span>
														<input type="text" class="form-control input-sm money" value="0" id="total-penghasilan" readonly="">
														<input type="hidden" id="penghasilan-total" value="">
													</div>
												</div>
												<div class="form-group">
													<label class="control-label"><%= textForm[SESS_LANGUAGE][18]%> <%= textForm[SESS_LANGUAGE][6]%></label>
													<div class="input-group">
														<span class="input-group-addon"><%= textCurrency[0]%></span>
														<input type="text" class="form-control input-sm money" value="0" id="total-pengeluaran" readonly="">
														<input type="hidden" id="pengeluaran-total" value="">
													</div>
												</div>
												<div class="form-group">
													<label class="control-label"><%= textForm[SESS_LANGUAGE][7]%></label>
													<div class="input-group">
														<span class="input-group-addon"><%= textCurrency[0]%></span>
														<input type="text" class="form-control input-sm money" id="surplus-angsuran" value="<%= akm.getSurplusAngsuran()%>" readonly="">
														<input type="hidden" id="surplus-angsuran-hidden" value="<%= akm.getSurplusAngsuran()%>" 
															   name="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_SURPLUSANGSURAN]%>" 
															   id="<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_SURPLUSANGSURAN]%>">
													</div>
												</div>
										   </div>
										</div>
									</div>
									
								</div>
							</div>
							<div class="row form-horizontal">
								<div class="col-sm-12">
									<div class=" col-md-12">
										<h4 class="box-title text-bold"><%= textGlobal[SESS_LANGUAGE][3]%></h4>
									</div>
									<div class="col-md-4">
										<div class="form-group">
											<label class="col-sm-4 control-label"><%= textGlobal[SESS_LANGUAGE][2]%></label>
											<div class="col-sm-8">
												<input type="text" class="form-control input-sm" value="<%= analis.getName() %>" readonly="">
											</div>
										</div>
									</div>
									<div class="col-md-4">
										<div class="form-group">
											<label class="col-sm-4 control-label"><%= textForm[SESS_LANGUAGE][9]%></label>
											<div class="input-group input-group-sm col-sm-8">
												<input type="text" class="form-control" readonly="">
												<span class="input-group-btn">
													<button type="button" class="btn btn-success btn-flat select-employee-btn" value="0"><i class="fa fa-search"></i></button>
												</span>
											</div>
										</div>
									</div>
									<div class="col-md-4">
										<div class="form-group">
											<label class="col-sm-4 control-label"><%= textForm[SESS_LANGUAGE][10]%></label>
											<div class="input-group input-group-sm col-sm-8">
												<input type="text" class="form-control" readonly="">
												<span class="input-group-btn">
													<button type="button" class="btn btn-success btn-flat select-employee-btn" value="1"><i class="fa fa-search"></i></button>
												</span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</form>
						
						<% if(akm.getOID() != 0){ %>
						<hr class="border-gray">
						<div class="row form-horizontal">
							<div class="col-sm-12">
								<div class="col-sm-2">
									<button class="btn btn-success add-analisa-btn" value="0">
										<i class="fa fa-plus"></i>
										<%= textCrud[SESS_LANGUAGE][0] %>
									</button>
								</div>
								<div class="col-sm-2">
<!--
								<div class="form-group">
									<div class="col-sm-offset-2 col-sm-10">
										<div class="checkbox">
											<label class="text-bold">
												<input type="checkbox">
												<%= textGlobal[SESS_LANGUAGE][4]%>
											</label>
										</div>
									</div>
								</div>
-->
								</div>
								<div class="col-sm-6">
									<div class="form-group pull-right">
										<label class="col-sm-4 control-label">
											<%= textGlobal[SESS_LANGUAGE][5]%>
										</label>
										<div class="col-sm-6">
											<input type="text" class="form-control" id="total_skor_" name="total_skor" readonly="" value="">
										</div>
									</div>
								</div>
								<div class="col-sm-2">
									<div class="pull-right">
										<button id="print-doc-pdf-btn" class="btn btn-warning">
											<i class="fa fa-print"></i>
											Print Pdf
										</button>										
									</div>
								</div>
							</div>
						</div>
										
						<div class="row">
							<div class="col-sm-12">
								<table id="penilaian-table" class="table table-bordered table-hover table-responsive table-striped">
									<thead>
										<tr>
											<th class="text-center" style="width: 10%"><%= textTableHeader[SESS_LANGUAGE][0] %></th>
											<th class="text-center" style="width: 30%"><%= textTableHeader[SESS_LANGUAGE][1] %></th>
											<th class="text-center" style="width: 10%"><%= textTableHeader[SESS_LANGUAGE][2] %></th>
											<th class="text-center" style="width: 10%"><%= textTableHeader[SESS_LANGUAGE][3] %></th>
											<th class="text-center" style="width: 10%"><%= textTableHeader[SESS_LANGUAGE][4] %></th>
											<th class="text-center" style="width: 20%"><%= textTableHeader[SESS_LANGUAGE][5] %></th>
											<th class="text-center" style="width: 10%"><%= textTableHeader[SESS_LANGUAGE][6] %></th>
										</tr>
									</thead>
								</table>
							</div>
						</div>
						<% } %>
						
						<hr class="border-gray">				
						<div class="row">
							<div class="col-sm-12">
								<button id="save-form-btn" class="btn btn-success" value="<%= akm.getOID() %>">
									<i class="fa fa-save"></i>
									<%= textCrud[SESS_LANGUAGE][3] %>
								</button>
								<button id="back-btn" class="btn btn-default">
									<i class="fa fa-refresh"></i>
									<%= textCrud[SESS_LANGUAGE][4] %>
								</button>
							</div>
						</div>				
					</div>
				</div>
			</section>
        </div>

		<div class="example-modal">
			<div class="modal fade" id="add-analisa-modal" tabindex="-1" role="dialog">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header" style="background-color: #00A65A; color: white;">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true">&times;</span></button>
							<h3 class="modal-title judul">Judul</h3>
						</div>
						<div class="modal-body">
							<form id="<%= FrmAnalisaKreditDetail.FRM_NAME_ANALISAKREDITDETAIL%>">
								<div id="updateSection">
									
								</div>
								<div class="row">
									<div id="select-master-analisa-group-parent">

									</div>
									<div id="select-master-analisa-parent">
																				
									</div>
									<div id="input-nilai-analisa-parent">
										
									</div>
								</div>
							</form>
						</div>
						<div class="modal-footer">
							<button type="button" id="save-penilaian-btn" class="btn btn-success">
								<i class="fa fa-save"></i>
								<%= textCrud[SESS_LANGUAGE][3] %>
							</button>
						</div>
					</div>
					<!-- /.modal-content -->
				</div>
				<!-- /.modal-dialog -->
			</div>
			<!-- /.modal -->
		</div>
		<!-- /.example-modal -->								
		
		<div class="example-modal">
			<div class="modal fade" id="select-employee-modal" tabindex="-1" role="dialog">
				<div class="modal-dialog modal-lg" role="document">
					<div class="modal-content">
						<div class="modal-header" style="background-color: #00A65A; color: white;">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true">&times;</span></button>
							<h3 class="modal-title judul">Judul</h3>
						</div>
						<div class="modal-body">
							<input type="hidden" value="" id="pos-tipe">
							<div id="select-kadiv-table-parent">
								<table id="select-kadiv-table">
									<thead>
										<tr>
											<td class="text-center"  style="width: 5%"><%= textEmployeeTableHeader[SESS_LANGUAGE][0] %></td>
											<td class="text-center" style="width: 15%"><%= textEmployeeTableHeader[SESS_LANGUAGE][1] %></td>
											<td class="text-left" style="width: 20%"><%= textEmployeeTableHeader[SESS_LANGUAGE][2] %></td>
											<td class="text-center"  style="width: 15%"><%= textEmployeeTableHeader[SESS_LANGUAGE][3] %></td>
											<td class="text-center"  style="width: 5%"><%= textEmployeeTableHeader[SESS_LANGUAGE][4] %></td>
										</tr>
									</thead>
								</table>
							</div>
							
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
						</div>
					</div>
					<!-- /.modal-content -->
				</div>
				<!-- /.modal-dialog -->
			</div>
			<!-- /.modal -->
		</div>
		<!-- /.example-modal -->	
		
		<div id="loading-spinner" class="lds-dual-ring"></div>

		
		<script>
			$(document).ready(function () {
				var sess_language = "<%= SESS_LANGUAGE %>";
				var loading = $('#loading-spinner');
				
				$(document).ajaxStart(function(){
					$('#loading-spinner').show();
				});
				$(document).ajaxStop(function(){
					$('#loading-spinner').hide();
				});
	
				//MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };
				
				// DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "searching": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></div>",
                            "sLengthMenu": "<%=dataTableTitle[SESS_LANGUAGE][0]%>",
                            "sZeroRecords": "<%=dataTableTitle[SESS_LANGUAGE][1]%>",
                            "sInfo": "<%=dataTableTitle[SESS_LANGUAGE][2]%>",
                            "sInfoEmpty": "<%=dataTableTitle[SESS_LANGUAGE][3]%>",
                            "sInfoFiltered": "<%=dataTableTitle[SESS_LANGUAGE][4]%>",
                            "sSearch": "<%=dataTableTitle[SESS_LANGUAGE][5]%>",
                            "oPaginate": {
                                "sFirst ": "<%=dataTableTitle[SESS_LANGUAGE][6]%>",
                                "sLast ":  "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                "sNext ":  "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                "sPrevious ":   "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            }
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST %>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor,
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [0, -1]
                            }
                        ],
                        "initComplete": function (settings, json) {
                            if (callBackDataTables !== null) {
                                callBackDataTables();
                            }
                        },
                        "fnDrawCallback": function (oSettings) {
                            if (callBackDataTables !== null) {
                                callBackDataTables();
                            }
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }
				function runPilihKadivTable() {
                    dataTablesOptions("#select-kadiv-table-parent", "select-kadiv-table", "AjaxAnalisaKredit", "listKepalaDivisi", null);
                }
				function runPilihManagerTable() {
                    dataTablesOptions("#select-kadiv-table-parent", "select-kadiv-table", "AjaxAnalisaKredit", "listManagerOperasional", null);
                }
				
				function analisaFormListener(){
					$('#master_group_').change(function (){
						var masterOid = $(this).val();
						var analisaKreditParent = $('#select-master-analisa-parent');
						$.ajax({
							type: 'POST',
							url: "<%= approot %>/AjaxAnalisaKredit?SESS_LANGUAGE="+ sess_language +"&FRM_FIELD_DATA_FOR=showMasterAnalisaOption&ANALISA_MAIN_OID=<%= akm.getOID() %>&master_group=" + masterOid,
							dataType: 'json',
							case: false,
							beforeSend: function () {
								analisaKreditParent.html(loading);
							},
							success: function (data) {
								analisaKreditParent.html(data.FRM_FIELD_HTML);
								analisaFormListener();
							}
						}).done();
					});
					$('#<%= FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_MASTERANALISAKREDITID] %>').change(function (){
						var analisOid = $(this).val();
						var formInputNilai = $('#input-nilai-analisa-parent');
						var analisaHeader = "<%= FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_MASTERANALISAKREDITID] %>";
						$.ajax({
							type: 'POST',
							url: "<%= approot %>/AjaxAnalisaKredit?SESS_LANGUAGE="+ sess_language +"&FRM_FIELD_DATA_FOR=showInputNilai&"+ analisaHeader +"=" + analisOid,
							dataType: 'json',
							case: false,
							beforeSend: function () {
								formInputNilai.html(loading);
							},
							success: function (data) {
								formInputNilai.html(data.FRM_FIELD_HTML);
								$('#save-penilaian-btn').removeAttr('disabled');
								analisaFormListener();
							}
						}).done();
					});
				}
				
				function runTablePenilaian(){
					$('#penilaian-table').DataTable({
						"bDestroy": true,
						"paging": false,
						"lengthChange": false,
						"searching": false,
						"ordering": false,
						"info": true,
						"autoWidth": false,
						"bServerSide": true,
						"sAjaxSource": "<%= approot%>/AjaxAnalisaKredit?command=<%= Command.LIST %>&ANALISA_MAIN_OID=<%= akm.getOID() %>&FRM_FIELD_DATA_FOR=listDetailPenilaian",
						aoColumnDefs: [
							{
								bSortable: false,
								aTargets: [0, -1]
							}
						],
						"initComplete": function (settings, json, data) {
                            $('#total_skor_').val(json.FRM_FIELD_HTML);
                        },
                        "fnDrawCallback": function (oSettings) {

						}
					});
				}
				$('.datePicker').datetimepicker({
					format: "yyyy-mm-dd",
					todayBtn: true,
					autoclose: true,
					minView: 2
				});

				function calcTotPengeluaran(){
					var konsumsi = parseFloat($('#<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_KONSUMSI]%>').val());
					var lain = parseFloat($('#<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_LAINNYA]%>').val());
					var listelpam = parseFloat($('#<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_LISTELPAM]%>').val());
					var pendidikan = parseFloat($('#<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_PENDIDIKAN]%>').val());
					var sandang = parseFloat($('#<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGELUARAN_SANDANG]%>').val());
					
					var total = konsumsi + lain + listelpam + pendidikan + sandang;
					
					var inputForm = $('#total-pengeluaran');
					inputForm.val(total.toLocaleString().replace(/,/g,"."));
					$('#pengeluaran-total').val(total);
					calcSurplusAngsuran();
				}
				
				function calcTotPenghasilan(){
					var pemohon = parseFloat($('#<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGHASILAN_PEMOHON]%>').val());
					var penanggung = parseFloat($('#<%= FrmAnalisaKreditMain.fieldNames[FrmAnalisaKreditMain.FRM_FIELD_PENGHASILAN_PENANGGUNG]%>').val());
					
					var total = pemohon + penanggung;
					$('#total-penghasilan').val(total.toLocaleString().replace(/,/g, "."));
					$('#penghasilan-total').val(total);
					calcSurplusAngsuran();
				}
				
				function calcSurplusAngsuran(){
					var totalPengeluaran = parseFloat($('#pengeluaran-total').val());
					var totalPenghasilan = parseFloat($('#penghasilan-total').val());
					
					var surplus = totalPenghasilan - totalPengeluaran;
					
					$('#surplus-angsuran').val(surplus.toLocaleString().replace(/,/g,"."));
					$('#surplus-angsuran-hidden').val(surplus);
				}
				
				$('#select-employee-modal').on('shown.bs.modal', function(){
					var modalTitle = "<%= textCrud[SESS_LANGUAGE][5] %>";
					var modal = $(this);
					var tipe = modal.find('.modal-body #pos-tipe').val();
					if(tipe == 0){
						modalTitle += " <%= textForm[SESS_LANGUAGE][9] %>";
						runPilihKadivTable();
					}
					if(tipe == 1){
						modalTitle += " <%= textForm[SESS_LANGUAGE][10] %>";
						runPilihManagerTable(); 
					}
					modal.find('.judul').html(modalTitle);
				});

				$('body').on('click','.add-analisa-btn',function(){
					var oid = $(this).val();
					var modal = $('#add-analisa-modal');
					modalSetting('#add-analisa-modal', 'static', false, false);
					modal.modal('show');
					var modalTitle = "";
					var parentSection = null;
					var url = "";
					if(oid == 0) {
						modalTitle += "<%= textCrud[SESS_LANGUAGE][0] %>";
						parentSection = $('#select-master-analisa-group-parent');
						$('#save-penilaian-btn').attr('disabled','true');
						url = "<%= approot %>/AjaxAnalisaKredit?SESS_LANGUAGE="+ sess_language +"&FRM_FIELD_DATA_FOR=showMasterAnalisaGroupOption&ANALISA_MAIN_OID=<%= akm.getOID() %>";
					} else {
						modalTitle += "<%= textCrud[SESS_LANGUAGE][1] %>";
						parentSection = $('#updateSection');
						url = "<%= approot %>/AjaxAnalisaKredit?SESS_LANGUAGE="+ sess_language +"&FRM_FIELD_DATA_FOR=showUpdateAnalisaDetailForm&ANALISA_DETAIL_OID="+oid;
					}
					modalTitle += "<%= textHeader[SESS_LANGUAGE][3] %> <%= textHeader[SESS_LANGUAGE][4] %>";
					modal.find('.modal-header .judul').html(modalTitle);
					modal.find('.modal-footer #save-penilaian-btn').val(oid);
					
					$.ajax({
						type: 'POST',
						url: url,
						dataType: 'json',
						case: false,
						beforeSend: function () {
							parentSection.html(loading);
						},
						success: function (data) {
							parentSection.html(data.FRM_FIELD_HTML);
							analisaFormListener();
						}
					}).done();
				});

				$('body').on('click', '.delete-analisa-btn', function(){
					var oid = $(this).val();
					if(confirm('Are you sure want to delete? ')){
						var url = "<%= approot %>/AjaxAnalisaKredit?SESS_LANGUAGE="+ sess_language +"&command=<%= Command.DELETE %>&FRM_FIELD_DATA_FOR=deleteAnalisaDetail&ANALISA_DETAIL_OID="+oid;
						$.ajax({
							type: 'POST',
							url: url,
							dataType: 'json',
							case: false,
							success: function (data) {
								alert(data.RETURN_MESSAGE);
								runTablePenilaian();
							}
						}).done();
					}
				});

				$('body').on('click', '.select-employee-btn',function(){
					var modal = $('#select-employee-modal');
					modalSetting('#select-employee-modal', 'static', false, false);	
					modal.modal('show');
					modal.find('.modal-body #pos-tipe').val($(this).val());
				});
				
				$('#save-form-btn').click(function (){
					var oid = $(this).val();
					var formData = $('#<%= FrmAnalisaKreditMain.FRM_NAME_ANALISAKREDITMAIN %>');
					$.ajax({
						type: 'POST',
						url: "<%= approot %>/AjaxAnalisaKredit?SESS_LANGUAGE="+ sess_language +"&command=<%= Command.SAVE %>&FRM_FIELD_DATA_FOR=saveForm5C&ANALISA_MAIN_OID="+oid,
						data: formData.serialize(),
						dataType: 'json',
						cache: false,
						success: function (data) {
							alert(data.RETURN_MESSAGE);
							var htmlReturn = data.FRM_FIELD_HTML;
							window.location = "<%= approot %>/sedana/transaksikredit/form5c_edit.jsp?oidpinjaman=<%= pinjaman.getOID() %>&oidanalisamain="+htmlReturn;
						}
					}).done();
				});
				
				$('body').on('click', '#save-penilaian-btn',function(){
					var formData = $('#<%= FrmAnalisaKreditDetail.FRM_NAME_ANALISAKREDITDETAIL%>');
					var oid = $(this).val();
					var url = "<%= approot %>/AjaxAnalisaKredit?SESS_LANGUAGE="+ sess_language +"&command=<%= Command.SAVE %>&FRM_FIELD_DATA_FOR=saveDetailPenilaian&ANALISA_DETAIL_OID="+oid;
					var modal = $('#add-analisa-modal');
					$.ajax({
						type: 'POST',
						url: url,
						data: formData.serialize(),
						dataType: 'json',
						cache: false,
						success: function (data) {
							alert(data.RETURN_MESSAGE);
							runTablePenilaian();
							modal.modal('hide');
						}
					}).done();
				});
				
				$('#print-doc-pdf-btn').click(function(){
					var url = "<%= approot %>/PrintAnalisaKredit?approot=<%= approot %>&SESS_LANGUAGE=<%= SESS_LANGUAGE %>&ANALISA_MAIN_OID=<%= akm.getOID() %>";
					window.open(url);
				});
				
				$('#add-analisa-modal').on('hidden.bs.modal', function(){
					$('#select-master-analisa-parent').html(null);
					$('#select-master-analisa-group-parent').html(null);
					$('#input-nilai-analisa-parent').html(null);
					$('#updateSection').html(null);
				});
				
				$('#back-btn').click(function(){
					var url = "<%= approot %>/sedana/transaksikredit/penilaian_kredit.jsp?command=<%= Command.EDIT  %>&pinjaman_id=<%= akm.getPinjamanId() %>";
					window.location = url;
				});
				
				$('.pengeluaran').keyup(function(){
					calcTotPengeluaran();
				});
				$('.penghasilan').keyup(function(){
					calcTotPenghasilan();
				});
				
				runTablePenilaian();
				calcTotPengeluaran();
				calcTotPenghasilan();
				calcSurplusAngsuran();
			});
		</script>						
    </body>
</html>
