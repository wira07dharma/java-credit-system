<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTellerBalance"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTellerBalance"%>
<%@page import="com.dimata.sedana.ajax.transaksi.AjaxSetoran"%>
<%@page import="com.dimata.aiso.form.masterdata.CtrlCompany"%>
<%@page import="com.dimata.aiso.entity.masterdata.Company"%>
<%@page import="com.dimata.sedana.entity.masterdata.TellerShift"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlCashTellerBalance"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlCashTeller"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmCashTellerBalance"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstSedanaShift"%>
<%@page import="com.dimata.sedana.entity.masterdata.SedanaShift"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterLoket"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterLoket"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstCompany"%>
<!DOCTYPE html>
<html>
  <head>
    <%@ page language="java" %>
    <%@ page import = "com.dimata.qdep.form.*" %>
    <%@ include file = "main/javainit.jsp" %>
    <style>
      .teller-shift-i.error .affect, .teller-shift-i.error .affect * {color: #bb544d;}
      .sidebar-collapse .error a>i {animation: blinker 1.5s linear infinite; color:red !important;}
      .sidebar-collapse .warning a>i {animation: blinker 1.5s linear infinite; color:#FFB300;}
      .teller-shift-i .fa-exclamation-circle {display: none !important;}
      .teller-shift-i.error .affect .fa-angle-left {display: none !important;}
      .teller-shift-i.error .affect .fa-exclamation-circle {display: unset !important;}
      @keyframes blinker {  
        95% { color: black; }
      }
    </style>
    <%  int iMain = 0;
      iMain = FRMQueryString.requestInt(request, "closeopen");
      if (session.getValue("CHECK_MENU") != null) {
        session.removeValue("CHECK_MENU");
      }
      System.out.println("iCheckMenu left menu :::::::::::::::::: " + iCheckMenu);
	  int enableTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN"));
    %>
    <%!
      public static final String[][] strMenuNames = {
        {
          "Menu",//0
          "Halaman Utama",//1
          "Kas",//2
          "Penerimaan",//3
          "Pendanaan",//4
          "Kas Kecil",//5
          "Bank",//6
          "Setoran",//7
          "Penarikan",//8
          "Pengisian Kas Kecil",//9
          "Transfer",//10
          "Non Kas & Bank",//11
          "Jurnal Umum",//12
          "Lap Keuangan",//13
          "Arus Kas",//14
          "Laba(Rugi)",//15
          "Neraca",//16
          "Buku Besar",//17
          "Neraca Percobaan",//18
          "Neraca Lajur",//19
          "Periode Akuntansi",//20
          "Setup Periode",//21
          "Tutup Periode",//22
          "Periode Aktivitas",//23
          "Data Master",//24
          "Perkiraan",//25
          "Link Perkiraan",//26
          "Mata Uang",//27
          "Kurs Standar",//28
          "Komponen Donor",//29
          "Master Aktivitas",//30
          "Buku Petunjuk",//31
          "Keluar",//32
          "Pembayaran",//33
          "Report Donor",//34
          "Report Donor Konsolidasi",//35
          "Report Biaya per Department",//36
          "Report Laba(Rugi) Tahunan Detail",//37
          "Report Laba(Rugi) Tahunan",//38
          "Lap Laba(Rugi) Rekap dgn Data Tahunan Bulanan",//39
          "Lap Laba(Rugi) Rekap dgn Data Tahunan",//40
          "Lap Laba(Rugi) Rekap Tahunan",//41
          "Lap Neraca Rekap",//42
          "Impor Data",//43
          "Search Jurnal",//44		
          "Apakah anda ingin pindah menu?",//45	
          "Pemakai",//46	
          "Kelompok Wewenang",//47
          "Wewenang",//48	
          "Kontak",//49	
          "Kelompok Kontak",//50
          "Manajemen Piutang",//51
          "Manajemen Hutang",//52
          "Manj Aktiva Tetap",//53
          "Lap Aktiva Tetap",//54
          "Input Data",//55
          "Input Pembayaran",//56
          "Order",//57
          "Input Penerimaan",//58
          "Input Pengeluaran",//59
          "Penyusutan",//60
          "Pengeluaran Aktiva Tetap",//61
          "Daftar Aktiva Tetap",//62
          "Jenis Aktiva Tetap",//63
          "Type Penyusutan",//64
          "Metode Penyusutan",//65
          "Kelompok Aktiva",//66
          "Master Aktiva Tetap",//67
          "Pencarian Hutang/Piutang",//68
          "Pencarian Aktiva Tetap",//69		
          "Report Hutang/Piutang",//70
          "Rekap Hutang/Piutang",//71
          "Detail Piutang",//72
          "Detail Hutang",//73
          "Invoice",//74
          "Pengesahan Tiket",//75		
          "Posting Data",//76
          "Lap Kegiatan Usaha",//77
          "Pembatalan Invoice",//78
          "Pengesahan Paket",//79
          "Tiket",//80
          "Paket",//81
          "Rekap Paket",//82
          "Lokasi Inventaris",//83
          "Ubah Status",//84
          "Pencocokan Data",//85
          "Analisa Lap Keu",//86
          "Analisa Grafik",//87
          "Penyedia Jasa Penerbangan",//88
          "Rute Penerbangan",//89
          "Kelas Tiket",//90
          "Harga Tiket",//91
          "Daftar Tiket",//92
          "Daftar Uang Muka Tiket",//93
          "Daftar Reservasi Paket",//94
          "Daftar Penjualan Ticket",//95
          "Perusahaan",//96
          "Kelompok Bisnis",//97
          "Pusat Bisnis",//98
          "Anggaran Pusat Bisnis",//99
          "Kurs Harian",//100
          "Owner Distribution",//101
          //nambah menu ij
          "Interactive Journal (IJ)", //102
          "IJ - Configuration",//103
          "IJ - Currency Mapping",//104
          "IJ - Payment Mapping",//105
          "IJ - Account Mapping",//106
          "IJ - Location Mapping",//107
          "IJ - Journal Process",//108
          "IJ - List Journal",//109
          //system property
          "System Property",//110

          //koprasi
          "Master Koperasi",//111
          "Transaksi",//112
          "Master Tabungan",//113
          "List Anggota",//114
          "Pendidikan",//115
          "Kelompok Anggota",//116
          "Propinsi",//117
          "Kota",//118
          "Kabupaten",//119
          "Kecamatan",//120
          "Kelurahan",//121
          "Pekerjaan",//122
          "Jabatan",//123
          "Jenis Deposito",//124
          "Jenis Kredit",//125
          "Jenis Simpanan",//126
          "Deposito",//127
          "Kredit",//128
          "Jenis Tabungan Koperasi",//129
          "Afiliasi",//130
          "Tabungan Setting Bunga",//131
          "Jenis Penabungan",//132
          "Data Tabungan",//133
          "Data Transaksi",//134
          "Report",//135
          "Report Tabungan",//136
          "Report Usaha",//137
        },
        {
          "SEDANA Menu",//0
          "Home",//1//
          "Cash",//2
          "Receipt",//3
          "Receipt Fund",//4
          "Petty Cash",//5
          "Bank",//6
          "Deposit",//7
          "Check Request",//8		
          "Replacement Petty Cash",//9
          "Transfer",//10
          "Non Cash & Bank",//11
          "General Journal",//12
          "Financial Report",//13
          "Cash Flow",//14
          "Profit(Loss)",//15
          "Balance Sheet",//16
          "General Ledger",//17
          "Trial Balance",//18
          "WorkSheet",//19
          "Accounting Period",//20
          "Setup Period",//21
          "Closing Period",//22
          "Activity Period",//23
          "Master Data",//24
          "Chart of Account",//25
          "Account Link",//26
          "Currency",//27
          "Bookkeeping Rate",//28
          "Donor Component",//29
          "Master Activity",//30
          "Help",//31
          "Log Out",//32
          "Payment",//33
          "Donor Report",//34
          "Consolidated Donor Report",//35
          "Departmental Expenses",//36
          "Profit(Loss) Annual Detail",//37
          "Profit(Loss) Annual",//38
          "Profit(Loss) Summary with YTD MTD",//39
          "Profit(Loss) Annual Summary with Variance",//40
          "Profit(Loss) Annual Summary",//41
          "Balance Sheet Summary",//42
          "Import Data",//43
          "Journal Inquiries",//44
          "Are you sure go to another menu?",//45	
          "User",//46	
          "Group Privilege",//47
          "Privilege",//48	
          "Contact",//49	
          "Contact Class",//50
          "Account Receivable",//51
          "Account Payable",//52
          "Fixed Assets",//53
          "Fixed Assets Report",//54	
          "Entry Data",//55
          "Payment",//56
          "Order",//57
          "Receive",//58
          "Out Going",//59
          "Depreciation",//60
          "Fixed Assets Out Going",//61
          "Fixed Assets List",//62
          "Fixed Assets Type",//63
          "Depreciation Type",//64
          "Depreciation Method",//65
          "Fixed Assets Group",//66
          "Fixed Assets Master",//67
          "AR/AP Inquiries",//68
          "Fixed Assets Inquiries",//69
          "AR/AP Report",//70
          "AR/AP Summary",//71
          "AR Detail",//72
          "AP Detail",//73
          "Invoice",//74
          "Approved Ticket",//75
          "Posted Data",//76
          "Bisnis Report",//77
          "Voiding Invoice",//78
          "Approved Package",//79
          "Ticket",//80
          "Package",//81
          "Package Summary",//82
          "Fixed Assets Location",//83
          "Update Status",//84
          "Cross Check Data",//85
          "Financial Analysis",//86
          "Chart Analysis",//87
          "Ticket Carrier",//88
          "Ticket Route",//89
          "Ticket Class",//90
          "Ticket Price",//91
          "Ticket List",//92
          "Deposit Ticket List",//93
          "Reservation Package List",//94
          "Ticket Sales List",//95
          "Company",//96
          "Bussiness Group",//97
          "Bussiness Center",//98
          "Buss Center Budget",//99
          "Daily Rate",//100
          "Owner Distribution",//101
          //nambah menu ij
          "Interactive Journal (IJ)",//102
          "IJ - Configuration",//103
          "IJ - Currency Mapping",//104
          "IJ - Payment Mapping",//105
          "IJ - Account Mapping",//106
          "IJ - Location Mapping",//107
          "IJ - Journal Process",//108
          "IJ - List Journal",//109
          //system property
          "System Property",//110

          //koprasi
          "Master Koperasi",//111
          "Transaction",//112
          "Master Tabungn",//113
          "Member List",//114
          "Education",//115
          "Member Club",//116
          "Province",//117
          "City",//118
          "Regency",//119
          "Sub Regency",//120
          "Ward",//121
          "Vocation",//122
          "Position",//123
          "Deposits Type",//124
          "Credit Type",//125
          "Saving Type",//126
          "Deposits",//127
          "Credit",//128
          "Koperasi Type Saving",//129
          "Afiliasi",//130
          "Saving Setting",//131
          "Types of Saving",//132
          "Data Saving",//133
          "Transaction Data",//134
          "Report",//135
          "Saving Report",//136
          "Report Usaha",//137
        },};


    %>

    <%
      urlForSessExpired = approot + "/login.jsp";
      //g2 master data
      int appObjCodeNasabah = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_NASABAH);
      int appObjCodeBadanUsaha = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_BADAN_USAHA);
      int appObjCodePropinsi = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_PROPINSI);
      int appObjCodeKabupaten = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_KABUPATEN);
      int appObjCodeKecamatan = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_KECAMATAN);
      int appObjCodeDesa = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_DESA);
      int appObjCodePendidikan = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_PENDIDIKAN);
      int appObjCodePekerjaan = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_PEKERJAAN);
      int appObjCodeJabatan = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_JABATAN);
      int appObjCodeLoket = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_LOKET);
      int appObjCodeShift = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_SHIFT);
      int appObjCodeJenisTransaksi = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_JENIS_TRANSAKSI);
      int appObjCodeServices = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTERDATA, AppObjInfo.OBJ_SERVICES);
      //g2 master tabungan
      int appObjCodeJenisItem = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_TABUNGAN, AppObjInfo.OBJ_JENIS_ITEM);
      int appObjCodeAfiliasi = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_TABUNGAN, AppObjInfo.OBJ_AFILIASI);
      int appObjCodeMasterTabungan = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_TABUNGAN, AppObjInfo.OBJ_MASTER_TABUNGAN);
      //g2 master kredit
      int appObjCodeJenisKredit = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_KREDIT, AppObjInfo.OBJ_JENIS_KREDIT);
      int appObjCodeSumberDana = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_KREDIT, AppObjInfo.OBJ_SUMBER_DANA);
      int appObjCodeKolektibilitasPembayaran = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_KREDIT, AppObjInfo.OBJ_KOLEKTIBILITAS_PEMBAYARAN);
      int appObjCodePenjaminKredit = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_KREDIT, AppObjInfo.OBJ_PENJAMIN_KREDIT);
      int appObjCodeAnalisaMaster = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_KREDIT, AppObjInfo.OBJ_ANALISA_MASTER);
      int appObjCodeAnalisaMasterGroup = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_KREDIT, AppObjInfo.OBJ_ANALISA_MASTER_GROUP);
      //g2 transaksi
      int appObjCodePenambahanTabungan = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_PENAMBAHAN_TABUNGAN);
      int appObjCodePenarikanTabungan = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_PENARIKAN_TABUNGAN);
      int appObjCodeMutasi = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_MUTASI);
      int appObjCodePengajuanKredit = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_PENGAJUAN_KREDIT);
      int appObjCodePenilaianKredit = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_PENILAIAN_KREDIT);
      int appObjCodePencairanKredit = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_PENCAIRAN_KREDIT);
      int appObjCodePembayaranKredit = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_PEMBAYARAN_KREDIT);
      int appObjCodeDaftarTransaksiKredit = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_DAFTAR_TRANSAKSI_KREDIT);
      int appObjCodeSistemKredit = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_SISTEM_KREDIT);
      int appObjCodeAnalisaForm5c = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_ANALISA_FORM_5C);
      int appObjCodeGantiKolektor = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_CHANGE_KOLEKTOR_MODULE);
      //g2 report
      int appObjCodeReportPerPinjaman = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_REPORT_PER_PINJAMAN);
      int appObjCodeTabunganWajib = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_TABUNGAN_WAJIB);
      int appObjCodeSisaPinjaman = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_SISA_PINJAMAN);
      int appObjCodeKolektibilitas = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_KOLEKTIBILITAS);
      int appObjCodeRangkumanKolektibilitas = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_RANGKUMAN_KOLEKTIBILITAS);
      int appObjCodeRiwayatPembayaranKredit = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_RIWAYAT_PEMBAYARAN_KREDIT); 
      int appObjCodeKreditPerShift = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_KREDIT_PER_SHIFT); 
      int appObjCodeKolektor = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_KOLEKTOR); 
      int appObjCodeKomisiSales = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_KOMISI_SALES); 
      int appObjCodeKolektorPencapaian = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_KOLEKTOR_PENCAPAIAN); 
	  
      //g2 teller shift
      int appObjCodeOpening = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TELLER_SHIFT, AppObjInfo.OBJ_OPENING);
      int appObjCodeClosing = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TELLER_SHIFT, AppObjInfo.OBJ_CLOSING);
      int appObjCodePrintOpening = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TELLER_SHIFT, AppObjInfo.OBJ_PRINT_OPENING);
      int appObjCodePrintClosing = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TELLER_SHIFT, AppObjInfo.OBJ_PRINT_CLOSING);
      int appObjCodeTellerShiftManajement = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TELLER_SHIFT, AppObjInfo.OBJ_TELLER_SHIFT_MANAGEMENT);
      //g2 sistem admin
      int appObjCodeUser = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_SYSTEM_ADMIN, AppObjInfo.OBJ_USER);
      int appObjCodeGroupPrivilage = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_SYSTEM_ADMIN, AppObjInfo.OBJ_GROUP_PRIVILAGE);
      int appObjCodePrivilage = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_SYSTEM_ADMIN, AppObjInfo.OBJ_PRIVILAGE);
      int appObjCodeSystemProperty = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_SYSTEM_ADMIN, AppObjInfo.OBJ_SYSTEM_PROPERTY);
      //g2 master dokumen
      int appObjCodeJenisDokumen = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_DOCUMENT, AppObjInfo.OBJ_DOCUMENT_TYPE);
      int appObjCodeTemplateDokumen = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_DOCUMENT, AppObjInfo.OBJ_DOCUMENT_TEMPLATE);
    %>
    <%@ include file = "/main/checkuser.jsp" %>

    <%        /**
       * Check privilege except VIEW, view is already checked on checkuser.jsp
       * as basic access
       */
      //g2 master data
      boolean privNasabahView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeNasabah, AppObjInfo.COMMAND_VIEW));
      boolean privBadanUsahaView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeBadanUsaha, AppObjInfo.COMMAND_VIEW));
      boolean privPropinsiView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePropinsi, AppObjInfo.COMMAND_VIEW));
      boolean privKabupatenView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeKabupaten, AppObjInfo.COMMAND_VIEW));
      boolean privKecamatanView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeKecamatan, AppObjInfo.COMMAND_VIEW));
      boolean privDesaView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeDesa, AppObjInfo.COMMAND_VIEW));
      boolean privPendidikanView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePendidikan, AppObjInfo.COMMAND_VIEW));
      boolean privPekerjaanView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePekerjaan, AppObjInfo.COMMAND_VIEW));
      boolean privJabatanView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeJabatan, AppObjInfo.COMMAND_VIEW));
      boolean privLoketView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeLoket, AppObjInfo.COMMAND_VIEW));
      boolean privShiftView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeShift, AppObjInfo.COMMAND_VIEW));
      boolean privJenisTransaksiView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeJenisTransaksi, AppObjInfo.COMMAND_VIEW));
      boolean privServicesView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeServices, AppObjInfo.COMMAND_VIEW));
      //g2 master tabungan
      boolean privJenisItemView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeJenisItem, AppObjInfo.COMMAND_VIEW));
      boolean privAfiliasiView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAfiliasi, AppObjInfo.COMMAND_VIEW));
      boolean privMasterTabunganView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeMasterTabungan, AppObjInfo.COMMAND_VIEW));
      //g2 master kredit
      boolean privJenisKreditView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeJenisKredit, AppObjInfo.COMMAND_VIEW));
      boolean privSumberDanaView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeSumberDana, AppObjInfo.COMMAND_VIEW));
      boolean privKolektibilitasPembayaranView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeKolektibilitasPembayaran, AppObjInfo.COMMAND_VIEW));
      boolean privPenjaminKreditView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePenjaminKredit, AppObjInfo.COMMAND_VIEW));
      boolean privAnalisaMasterView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAnalisaMaster, AppObjInfo.COMMAND_VIEW));
      boolean privAnalisaMasterGroupView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAnalisaMasterGroup, AppObjInfo.COMMAND_VIEW));
      //g2 transaksi
      boolean privPenambahanTabunganView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePenambahanTabungan, AppObjInfo.COMMAND_VIEW));
      boolean privPenarikanTabunganView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePenarikanTabungan, AppObjInfo.COMMAND_VIEW));
      boolean privMutasiView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeMutasi, AppObjInfo.COMMAND_VIEW));
      boolean privPengajuanKreditView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePengajuanKredit, AppObjInfo.COMMAND_VIEW));
      boolean privPenilaianKreditView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePenilaianKredit, AppObjInfo.COMMAND_VIEW));
      boolean privPencairanKreditView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePencairanKredit, AppObjInfo.COMMAND_VIEW));
      boolean privPembayaranKreditView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePembayaranKredit, AppObjInfo.COMMAND_VIEW));
      boolean privDaftarTransaksiKreditView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeDaftarTransaksiKredit, AppObjInfo.COMMAND_VIEW));
      boolean privSistemKreditView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeSistemKredit, AppObjInfo.COMMAND_VIEW));
      boolean privAnalisaForm5cView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAnalisaForm5c, AppObjInfo.COMMAND_VIEW));
      boolean privGantiKolektorView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeGantiKolektor, AppObjInfo.COMMAND_VIEW));
      //g2 report
      boolean privReportPerPinjamanView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeReportPerPinjaman, AppObjInfo.COMMAND_VIEW));
      boolean privTabunganWajibView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeTabunganWajib, AppObjInfo.COMMAND_VIEW));
      boolean privSisaPinjamanView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeSisaPinjaman, AppObjInfo.COMMAND_VIEW));
      boolean privKolektibilitasView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeKolektibilitas, AppObjInfo.COMMAND_VIEW));
      boolean privRangkumanKolektibilitasView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRangkumanKolektibilitas, AppObjInfo.COMMAND_VIEW));
      boolean privRiwayatPembayaranKreditView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRiwayatPembayaranKredit, AppObjInfo.COMMAND_VIEW));
      boolean privKreditPerShiftView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeKreditPerShift, AppObjInfo.COMMAND_VIEW));
      boolean privDaftarTagihanView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeKolektor, AppObjInfo.COMMAND_VIEW));
      boolean privKomisiSalesView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeKomisiSales, AppObjInfo.COMMAND_VIEW));
      boolean privDaftarPencapaianView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeKolektorPencapaian, AppObjInfo.COMMAND_VIEW));
      //g2 teller shift
      boolean privOpeningView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeOpening, AppObjInfo.COMMAND_VIEW));
      boolean privClosingView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeClosing, AppObjInfo.COMMAND_VIEW));
      boolean privPrintOpeningView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePrintOpening, AppObjInfo.COMMAND_VIEW));
      boolean privPrintClosingView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePrintClosing, AppObjInfo.COMMAND_VIEW));
      boolean privTellerShiftManagementView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeTellerShiftManajement, AppObjInfo.COMMAND_VIEW));
      //g2 sistem admin
      boolean privUserView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeUser, AppObjInfo.COMMAND_VIEW));
      boolean privGroupPrivilageView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeGroupPrivilage, AppObjInfo.COMMAND_VIEW));
      boolean privPrivilageView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePrivilage, AppObjInfo.COMMAND_VIEW));
      boolean privSystemPropertyView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeSystemProperty, AppObjInfo.COMMAND_VIEW));
      //g2 master dokumen
      boolean privJenisDokumenView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeJenisDokumen, AppObjInfo.COMMAND_VIEW));
      boolean privTemplateDokumenView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeTemplateDokumen, AppObjInfo.COMMAND_VIEW));
      
      String analisOidStr = PstSystemProperty.getValueByName("SEDANA_ANALIS_OID");
      long idEmployeeUser = appUserInit.getEmployeeId();
      long analisOid = Long.parseLong(analisOidStr);
      Employee emp = PstEmployee.fetchFromApi(idEmployeeUser);
      boolean privAnalis = emp.getPositionId() == analisOid;
    
    %>

    <%
      String redir = FRMQueryString.requestString(request, "redir");
      redir = (!redir.equals("") && redir != null) ? redir : "homexframe.jsp";
      Vector<CashTeller> justClosedCount = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND (" + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NOT NULL OR DATE(" + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + ") = DATE(NOW()) )", PstCashTeller.fieldNames[PstCashTeller.FLD_OPEN_DATE] + " DESC");
      Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND (" + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL)", PstCashTeller.fieldNames[PstCashTeller.FLD_OPEN_DATE] + " DESC");
      CashTeller c = new CashTeller();
      boolean opened = open.size() > 0;
      boolean justClosed = justClosedCount.size() > 0;
      long oidCahsTeller = 0;
      if (opened) {
        oidCahsTeller = open.get(0).getOID();
        c = open.get(0);
      } else if (justClosed) {
        oidCahsTeller = justClosedCount.get(0).getOID();
        c = justClosedCount.get(0);
      }
      //== 4 baris di bawah ini dikeluarkan dari pengecekan "opened"
      int iCommand = FRMQueryString.requestCommand(request);
      int iErrCode = FRMMessage.ERR_NONE;
      CtrlCashTeller ctrlCashTeller = new CtrlCashTeller(request);
      iErrCode = ctrlCashTeller.action(iCommand, oidCahsTeller);
      CashTeller entCashTeller = ctrlCashTeller.getCashTeller();
      //==
      if (opened) {
        //4 baris di atas di keluarkan dari sini karna belum pasti SOP nya
        /*updated by dewok 20190121
        CtrlCashTellerBalance ctrlCashTellerBalance = new CtrlCashTellerBalance(request);
        ctrlCashTellerBalance.action(iCommand, 0);
        */
        //added by dewok 20190121 for multiple closing value
        String payment[] = FRMQueryString.requestStringValues(request, ""+FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_PAYMENT_SYSTEM_ID]);
        String currency[] = FRMQueryString.requestStringValues(request, ""+FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_CURRENCYID]);
        String balance[] = FRMQueryString.requestStringValues(request, ""+FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_BALANCEVALUE]);
        if (payment != null) {
            for (int ip = 0; ip < payment.length; ip++) {
                long idPayment = 0;
                long idCurrency = 0;
                double closingValue = 0;
                try {
                    idPayment = Long.valueOf(payment[ip]);
                    idCurrency = Long.valueOf(currency[ip]);
                    closingValue = Double.valueOf(balance[ip]);
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                try {
                    CashTellerBalance tellerBalance = new CashTellerBalance();
                    tellerBalance.setTellerShiftId(entCashTeller.getOID());
                    tellerBalance.setCurrencyId(idCurrency);
                    tellerBalance.setType(FrmCashTellerBalance.STATUS_CLOSE);
                    tellerBalance.setBalanceDate(entCashTeller.getCloseDate());
                    tellerBalance.setBalanceValue(closingValue);
                    tellerBalance.setPaymentSystemId(idPayment);
                    PstCashTellerBalance.insertExc(tellerBalance);
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
        }
        
        if (iErrCode == FRMMessage.ERR_NONE && iCommand == Command.SAVE && userOID == entCashTeller.getAppUserId()) {
          if (open.size() < 2) {
            opened = false;
          } else {
            open.remove(0);
          }
        }
      }

      long oidCompany = PstCompany.getOidCompany();
      Company objCompany = new Company();
      if (oidCompany != 0) {
        objCompany = PstCompany.fetchExc(oidCompany);
      }
      String lokasiAmbilFoto = PstSystemProperty.getValueByName("COMP_IMAGE_GET_PATH");

    %>
    <%@ include file = "/style/lte_head.jsp" %>    
    <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>
    <script>

      function setMainFrameUrl(url) {
      <% if (iCheckMenu > 0) {%>
        if (confirm("<%=strMenuNames[SESS_LANGUAGE][45]%>")) {
          if (parent.mainFrame.window.closeWindow != null) {
            parent.mainFrame.window.closeWindow();
          }
          parent.mainFrame.window.location = url;
        }
      <% } else {%>
        if (parent.mainFrame.window.closeWindow != null) {
          parent.mainFrame.window.closeWindow();
        }
        parent.mainFrame.window.location = url;
      <%}%>

      }
      function logOut(url) {

        parent.window.location = url;
      }
      function delay(length = 1) {
        var that = this;
        this.length = length * 1000; // in ms
        this.invoke = null;
        this.t = null;
        this.start = function () {
          that.t = setTimeout(that.invoke, that.length);
        }
        this.clear = function () {
          clearTimeout(that.t);
          that.t = null;
        }
      }
    </script>
    <style>
      body{height: 100% !important;}
      #mainFrame { height:calc(100% - 50px); position:absolute; top:0px; left:0px; bottom:0px; right:0px; width:100%; border:none; margin:0; padding:0; overflow:visible; z-index:999999; display: block; border-left: none; }
      @media (max-width:767px)  { 
        #mainFrame { height: calc(100% - 100px); }
        .main-sidebar { margin-top: 60px; }
      }
      body > div.modal-backdrop.in { display: none !important; }
    </style>
    <script>
        $(document).ready(function(){
            let labelPengajuan = $('#label_pengajuan');
            let labelAnalisa = $('#label_analisa');
            let labelInputDetail = $('#label_input_detail');
            let labelAnalisaKredit = $('#label_analisa_kredit');
            let labelForm5C = $('#label_form_5c');
            
            var getDataFunction = function (onDone, onSuccess, dataSend, servletName, dataAppendTo, notification) {
                $(this).getData({
                    onDone: function (data) {
                        onDone(data);
                    },
                    onSuccess: function (data) {
                        onSuccess(data);
                    },
                    approot: "<%=approot%>",
                    dataSend: dataSend,
                    servletName: servletName,
                    dataAppendTo: dataAppendTo,
                    notification: notification
                });
            };
            
            function getJumlahDataKredit(){
                var dataSend = {
                    "FRM_FIELD_DATA_FOR": "getDataJumlahKreditLabel",
                    "FRM_FIELD_LOCATION_OID": "<%= userLocationId %>",
                    "FRM_EMPLOYEE_USER": "<%= idEmployeeUser %>",
                    "PRIV_POS_ANALIS": "<%= privAnalis %>",
                    "command": "<%= Command.NONE %>"
                };
                onDone = function (data) {
                    let dataJumlah = data.JUMLAH_DATA;
                    let jumlahPengajuan = dataJumlah.JUMLAH_DATA_PENGAJUAN;
                    let jumlahAnalisa = dataJumlah.JUMLAH_DATA_ANALISA;
                    let jumlahInputDetail = dataJumlah.JUMLAH_DATA_INPUT_DETAIL;
                    let jumlahForm5C = dataJumlah.JUMLAH_DATA_FORM_5C;
                    
                    labelPengajuan.html("<small class='label pull-right bg-red' data-toggle='tooltip' data-placement='top' title='Status Draft'>" + jumlahPengajuan + "</small>");
                    labelAnalisa.html("<small class='label pull-right bg-red' data-toggle='tooltip' data-placement='top' title='Status Analisa'>" + jumlahAnalisa + "</small>"
                            + "<small class='label pull-right bg-yellow' data-toggle='tooltip' data-placement='top' title='Status Draft Form 5C'>" + jumlahForm5C + "</small>"
                            );
                    labelInputDetail.html("<small class='label pull-right bg-red' data-toggle='tooltip' data-placement='top' title='Status Accept'>" + jumlahInputDetail + "</small>");
                    labelAnalisaKredit.html("<small class='label pull-right bg-red' data-toggle='tooltip' data-placement='top' title='Status Analisa'>" + jumlahAnalisa + "</small>");
                    labelForm5C.html("<small class='label pull-right bg-red' data-toggle='tooltip' data-placement='top' title='Status Draft'>" + jumlahForm5C + "</small>");
                };
                onSuccess = function (data) {
                };
                getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);            
            }
            
            getJumlahDataKredit();
        });
    </script>
  </head>
  <body class="hold-transition skin-green-light sidebar-mini" style="background: rgb(249, 250, 252); overflow: visible; width: 100%; position: fixed;">
    <div class="main-page" style="position: fixed; width: 100%; height: 100%;">
      <header class="main-header" style="box-shadow:0px 0px 40px #00000047, 0px 0px 10px #0000006b, 0px 0px 5px #00000030;">
        <!-- Logo -->
        <a href="" target="_blank" class="logo">
          <!-- mini logo for sidebar mini 50x50 pixels -->
          <span class="logo-mini"><b>D</b>NA</span>
          <!-- logo for regular state and mobile devices -->
          <span class="logo-lg"><b>Dimata</b>SEDANA</span>
        </a>

        <!-- Header Navbar: style can be found in header.less -->
        <nav class="navbar navbar-static-top">
          <!-- Sidebar toggle button-->
          <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
          </a>
          <div class="navbar-custom-menu">
          </div>
        </nav>
      </header>
      <!-- Left side column. contains the logo and sidebar -->
      <aside class="main-sidebar" style="z-index: unset !important; height: 100%; overflow: hidden;">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar" style="overflow: scroll; top: 50px; position: absolute; left: 0; right: -17px; bottom: -17px;">
          <!-- Sidebar user panel -->
          <div class="user-panel">
            <div class="pull-left image">
              <% if (!lokasiAmbilFoto.equals("") && (!objCompany.getCompImage().equals("") && objCompany.getCompImage() != null)) {%>
              <img src="<%=lokasiAmbilFoto%>/<%=objCompany.getCompImage()%>" class="img-circle">
              <% } else {%>
              <img src="<%=approot%>/images/company_logo.jpg" class="img-circle">
              <% }%>
            </div> 
            <div class="pull-left info">
              <p><%=userFullName%></p>
              <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
            </div>
          </div>
          <!-- /.search form -->
          <!-- sidebar menu: : style can be found in sidebar.less -->
          <ul class="sidebar-menu">
            <li class="header">MAIN NAVIGATION</li>
            <li class="treeview"><a href="#"><i class="fa fa-dashboard"></i> <span>Dashboard</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
              <ul class="treeview-menu">
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/homexframe.jsp')"><i class="fa fa-circle-o"></i> Welcome</a></li>
              </ul>
            </li>
            <%if (privNasabahView || privBadanUsahaView || privPropinsiView || privKabupatenView || privKecamatanView
                      || privDesaView || privPendidikanView || privPekerjaanView || privJabatanView || privLoketView
                      || privShiftView || privJenisTransaksiView || privServicesView) {%>
            <li class="treeview"><a href="#"><i class="fa fa-files-o"></i> <span><%=namaMasterData%></span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
              <ul class="treeview-menu">
                <%if (privNasabahView || privBadanUsahaView) {%>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span><%=namaNasabah%></span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                  <ul class="treeview-menu">
                    <%if (privNasabahView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/anggota_search.jsp')"><i class="fa fa-circle"></i> <%=namaNasabah%> Individu</a></li>
                      <%}%>
                      <%if (privBadanUsahaView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/anggota/list_anggota_kelompok.jsp')"><i class="fa fa-circle"></i> Kelompok / Badan Usaha</a></li>
                      <%}%>
                  </ul>
                </li> 
                <%}%>
                <%if (privPropinsiView || privKabupatenView || privKecamatanView || privDesaView) {%>
                <%--<li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Area</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                  <ul class="treeview-menu">
                    <%if(privPropinsiView){%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/region/province.jsp')"><i class="fa fa-circle"></i> Propinsi</a></li>
                    <%}%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/region/city.jsp')" ><i class="fa fa-circle"></i> Kota</a></li>
                    <%if(privKabupatenView){%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/region/regency.jsp')"><i class="fa fa-circle"></i> Kabupaten</a></li>
                    <%}%>
                    <%if(privKecamatanView){%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/region/subregency.jsp')"><i class="fa fa-circle"></i> Kecamatan</a></li>
                    <%}%>
                    <%if(privDesaView){%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/region/ward.jsp')"><i class="fa fa-circle"></i> Desa</a></li>
                    <%}%>
                  </ul>
                </li>--%>
                <%}%>
                <%if (privPendidikanView || privPekerjaanView || privJabatanView) {%>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Status</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                  <ul class="treeview-menu">
                    <%if (privPendidikanView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/education.jsp')"><i class="fa fa-circle"></i> Pendidikan</a></li>
                      <%}%>
                      <%if (privPekerjaanView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/vocation.jsp')"><i class="fa fa-circle"></i> Pekerjaan</a></li>
                      <%}%>
                      <%if (privJabatanView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/position.jsp')"><i class="fa fa-circle"></i> Jabatan</a></li>
                      <%}%>
                  </ul>
                </li> 
                <%}%>
                <%if (privLoketView || privShiftView || privJenisTransaksiView) {%>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Master</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                  <ul class="treeview-menu">
                    <%if (privLoketView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/company/loket.jsp')"><i class="fa fa-circle"></i> Loket</a></li>
                      <%}%>
                      <%if (privShiftView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/company/shift.jsp')"><i class="fa fa-circle"></i> Shift</a></li>                            
                      <%}%>
                      <%if (privShiftView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/relevant_doc_group.jsp')"><i class="fa fa-circle"></i> Kelompok Dokumen </a></li>                            
                      <%}%>
                      <%if (privJenisTransaksiView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/masterbumdes/list_jenis_transaksi.jsp')"><i class="fa fa-circle"></i> Jenis Transaksi</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/masterbumdes/payment_system.jsp')"><i class="fa fa-circle"></i> Tipe Pembayaran </a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/masterbumdes/company_edit.jsp?command=<%=Command.EDIT%>')"><i class="fa fa-circle"></i> Organisasi </a></li>
                      <%}%>
					<% if(useRaditya == 1) {%>
					<li class="treeview"><a href="#"><i class="fa fa-circle"></i> <span>Jangka Waktu</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
						<ul class="treeview-menu">
							<li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/company/jangkaWaktu.jsp')"><i class="fa fa-circle"></i>Waktu</a></li>
							<li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/company/jangkaWaktuFormula.jsp')"><i class="fa fa-circle"></i>Formula</a></li>
						</ul>
					</li>
					<% } else { %>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/company/jangkaWaktu.jsp')"><i class="fa fa-circle"></i>Jangka Waktu</a></li>
					<% } %>
				  </ul>
                </li>
                <%}%>
                <%if (privJenisDokumenView || privTemplateDokumenView) {%>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Master Dokumen</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                  <ul class="treeview-menu">
                    <%if (privJenisDokumenView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterdokumen/doc_type.jsp')"><i class="fa fa-circle"></i> Jenis Dokumen</a></li>
                      <%}%>
                      <%--<li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/mastertabungan.jsp')"><i class="fa fa-circle-o"></i> Jenis Tabungan Koperasi</a></li>--%>
                      <%if (privTemplateDokumenView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterdokumen/doc_master.jsp')"><i class="fa fa-circle"></i> Template Dokumen</a></li>
                      <%}%>                    
                  </ul>
                </li>
                <%}%>
                <%if (privServicesView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/services.jsp')"><i class="fa fa-circle-o"></i> Jasa/Layanan</a></li>
                  <%}%>
				<% if(enableTabungan == 1){ %>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterkredit/custom_field_master.jsp')"><i class="fa fa-circle-o"></i> Master Field Tambahan</a></li>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Smart Data Input</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                    <ul class="treeview-menu">
                        <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterimport/flow_group.jsp')"><i class="fa fa-circle"></i> Flow Group</a></li>
                        <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterimport/flow.jsp')"><i class="fa fa-circle"></i> Flow</a></li>
                        <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterimport/smart_data_input.jsp')"><i class="fa fa-circle"></i> Smart Data Input</a></li>
                    </ul>
                </li>
				<% } %>
              </ul>
            </li>
            <%}%>

            <%if ((privJenisItemView || privAfiliasiView || privMasterTabunganView)  && enableTabungan == 1) {%>
            <li class="treeview"><a href="#"><i class="fa fa-laptop"></i> <span>Master Tabungan</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>                        
              <ul class="treeview-menu">
                <%--<li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/jenis_deposito.jsp')"><i class="fa fa-circle-o"></i> Jenis Deposito</a></li>--%>
                <%if (privJenisItemView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/jenis_simpanan.jsp')"><i class="fa fa-circle-o"></i> Jenis Item</a></li>
                  <%}%>
                  <%--<li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/mastertabungan.jsp')"><i class="fa fa-circle-o"></i> Jenis Tabungan Koperasi</a></li>--%>
                  <%if (privAfiliasiView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/afiliasi.jsp')"><i class="fa fa-circle-o"></i> Afiliasi</a></li>
                  <%}%>
                  <%--<li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/setting_tabungan.jsp')"><i class="fa fa-circle-o"></i> Tabungan Setting Bunga</a></li>
                  <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/type_tabungan.jsp')"><i class="fa fa-circle-o"></i> Jenis Penabungan</a></li>--%>
                  <%if (privMasterTabunganView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/master_tabungan.jsp')"><i class="fa fa-circle-o"></i> Master Tabungan</a></li>
                  <%}%>
              </ul>
            </li>
            <%}%>

            <%if (privJenisKreditView || privSumberDanaView || privKolektibilitasPembayaranView
                    || privPenjaminKreditView || privAnalisaMasterView || privAnalisaMasterGroupView){ %>
            <li class="treeview"><a href="#"><i class="fa fa-money"></i> <span>Master Kredit</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
              <ul class="treeview-menu">
                <%if (privJenisKreditView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/jenis_kredit.jsp')"><i class="fa fa-circle-o"></i> Jenis Kredit</a></li>
                  <%}%>
                  <%if ((privSumberDanaView) && (enableTabungan == 1)) {%> 
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterkredit/sumber_dana.jsp')"><i class="fa fa-circle-o"></i> Sumber Dana</a></li>
                  <%}%>
                  <%if (privKolektibilitasPembayaranView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterkredit/kolektibilitas.jsp')"><i class="fa fa-circle-o"></i> Kolektibilitas Pembayaran</a></li>  
                  <%}%>
                  <%if (privPenjaminKreditView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterkredit/penjamin_kredit.jsp')"><i class="fa fa-circle-o"></i> Penjamin Kredit</a></li>              
                  <%}%>
                  <% if(privAnalisaMasterGroupView || privAnalisaMasterView) %>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Analisa Kredit</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                    <ul class="treeview-menu">
                        <% if(privAnalisaMasterGroupView){ %>
                        <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masteranalisakredit/group_analisa_kredit.jsp')"><i class="fa fa-circle"></i> Master Group</a></li>
                        <% } %>
                        <% if(privAnalisaMasterView){ %>
                        <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masteranalisakredit/analisa_kredit.jsp')"><i class="fa fa-circle"></i> Master Analisa Kredit</a></li>
                        <% } %>
                    </ul>
                </li>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Kontak</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                    <ul class="treeview-menu">
                        <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/kolektor/kolektor_search.jsp')"><i class="fa fa-circle"></i> Semua Kontak</a></li>
                    </ul>
            </li>
              </ul>
            </li>
            <%}%>

            <%if (privPenambahanTabunganView || privPenarikanTabunganView || privMutasiView || privPengajuanKreditView || privPenilaianKreditView || privPencairanKreditView || privPembayaranKreditView || privDaftarTransaksiKreditView || privSistemKreditView) {%>
            <li class="treeview"><a href="#"><i class="fa fa-edit"></i> <span>Transaksi</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>          
              <ul class="treeview-menu">
                <%if ((privPenambahanTabunganView || privPenarikanTabunganView || privMutasiView) && enableTabungan == 1) {%>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Tabungan</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                  <ul class="treeview-menu">
                    <%if (privPenambahanTabunganView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/Setoran?command=<%=AjaxSetoran.FORM_SEARCH%>')"><i class="fa fa-circle"></i> Penambahan Tabungan</a></li>
                      <%}%>
                      <%if (privPenarikanTabunganView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/Penarikan?command=<%=AjaxSetoran.FORM_SEARCH%>')"><i class="fa fa-circle"></i> Penarikan Tabungan</a></li>
                      <%}%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/Penutupan?command=<%=AjaxSetoran.FORM_SEARCH%>')"><i class="fa fa-circle"></i> Penutupan Tabungan</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/tabungan/multiple_penambahan_tabungan.jsp')"><i class="fa fa-circle"></i> Multiple Setoran</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/tabungan/list_transaksi_tabungan.jsp')"><i class="fa fa-circle"></i> Daftar Transaksi</a></li>
                  </ul>
                </li>
                <%}%>

                <%--
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-circle-o"></i> <span>Deposito</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/deposito.jsp')"><i class="fa fa-circle"></i> Pendaftaran Deposito</a></li>
                        <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/deposito.jsp')"><i class="fa fa-circle"></i> Transfer Bunga</a></li>
                        <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/deposito.jsp')"><i class="fa fa-circle"></i> Tutup Rekening</a></li>
                    </ul>
                </li>--%>

                <%if (privPengajuanKreditView || privPenilaianKreditView || privPencairanKreditView
                        || privPembayaranKreditView || privDaftarTransaksiKreditView || privSistemKreditView || privAnalisaForm5cView) {%>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Kredit</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                  <ul class="treeview-menu">
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/simulasi_kredit.jsp')"><i class="fa fa-circle"></i> Simulasi Kredit</a></li>
                      <%if (privPengajuanKreditView) {%>
                    <li>
                        <a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/list_kredit.jsp')">
                            <i class="fa fa-circle"></i> Pengajuan Kredit
                            <span class="pull-right-container" id="label_pengajuan"></span>
                        </a>
                    </li>
                      <%}%>
                      <%if (privPenilaianKreditView || privAnalisaForm5cView) {%>
                    <li class="treeview">
                        <a href="#"><i class="fa fa-circle"></i> 
                            <span>Analisa</span>
                            <span class="pull-right-container">
                                <span id="label_analisa" class="pull-left"></span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                    <% if(useRaditya == 1){ %>
                    <ul class="treeview-menu">
                        <% if(privPenilaianKreditView){ %>
                        <li>
                            <a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/penilaian_kredit.jsp')">
                                <i class="fa fa-circle"></i> Analisa Kredit
                                <span class="pull-right-container" id="label_analisa_kredit"></span>
                            </a>
                        </li>
                        <% } %>
                        <% if(privAnalisaForm5cView){ %>
                        <li>
                            <a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/form5c_list.jsp')">
                                <i class="fa fa-circle"></i> Analisa Form 5C
                                <span class="pull-right-container" id="label_form_5c"></span>
                            </a>
                        </li>
                        <% } %>
                    </ul>
                    <%} else {%>
                        <li>
                            <a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/penilaian_kredit.jsp')"><i class="fa fa-circle"></i> Penilaian Kredit</a>
                        </li>
                    <%}%>
                    </li> 
                      <%}%>
                      <%if (privPencairanKreditView) {%>
                    <li>
                        <a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/pencairan_kredit.jsp')">
                            <i class="fa fa-circle"></i> <%= PstSystemProperty.getValueByName("SEDANA_PENCAIRAN_KREDIT_NAME") %>
                            <span class="pull-right-container" id="label_input_detail">
                            </span>
                        </a>
                    </li>
                      <%}%>
                      <%if (privPembayaranKreditView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/form_pembayaran_kredit.jsp')"><i class="fa fa-circle"></i> Pembayaran Kredit</a></li>
                      <%}%>
                      <%if (privDaftarTransaksiKreditView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/list_transaksi.jsp')"><i class="fa fa-circle"></i> Daftar Transaksi</a></li>
                      <%}%>
                    <% if (useRaditya == 1) { %>
                    <% if (privDaftarTagihanView || privKomisiSalesView || privDaftarPencapaianView) { %>
                    <li class="treeview"><a href="#"><i class="fa fa-circle"></i> <span>Kolektor</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                        <ul class="treeview-menu">
                            <% if(privGantiKolektorView){ %>
                            <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/reassign_kolektor.jsp')"><i class="fa fa-circle"></i> Ganti Kolektor</a></li>
                            <% } %>
                            <% if(privDaftarTagihanView){ %>
                            <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_kolektor_daftar_tagihan.jsp')"><i class="fa fa-circle"></i> Daftar Tagihan</a></li>
                            <% } %>
                            <% if(privDaftarPencapaianView){ %>
                            <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_kolektor_daftar_pencapaian.jsp')"><i class="fa fa-circle"></i> Pencapaian Tagihan</a></li>
                            <% } %>
                        </ul>
                    </li>
                    <% } %>
                    <% }%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/list_return.jsp')"><i class="fa fa-circle"></i> Pengembalian Barang</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/list_penghapusan_kredit.jsp')"><i class="fa fa-circle"></i> Penghapusan Kredit</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/transaksikredit/dokumen_kredit.jsp')"><i class="fa fa-circle"></i> Dokumen Kredit</a></li>
                  </ul>
                </li>
                <%}%>
                <!---->
              </ul>
            </li>
            <%}%>

            <%if (privPenambahanTabunganView || privPenarikanTabunganView || privMutasiView || privReportPerPinjamanView || privTabunganWajibView || privSisaPinjamanView || privKolektibilitasView || privRangkumanKolektibilitasView) {%>
            <li class="treeview"><a href="#"><i class="fa fa-table"></i> <span>Laporan</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>          
              <ul class="treeview-menu">
                <%if ((privReportPerPinjamanView || privTabunganWajibView) && enableTabungan == 1) {%>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Tabungan</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                  <ul class="treeview-menu">
                    <%if (privReportPerPinjamanView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/report/tabungan/report_tabungan_per_pinjaman.jsp')"><i class="fa fa-circle"></i> Berdasarkan Jenis Item</a></li>
                      <%}%>
                      <%if (privTabunganWajibView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/report/tabungan/report_tabungan_mengendap.jsp')"><i class="fa fa-circle"></i> Tabungan Wajib</a></li>
                      <%}%> 
                      <%if (privPenambahanTabunganView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/data_tabungan.jsp')"><i class="fa fa-circle"></i> Penambahan Tabungan</a></li>
                      <%}%>
                      <%if (privPenarikanTabunganView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/data_transaksi.jsp')"><i class="fa fa-circle"></i> Penarikan Tabungan</a></li>
                      <%}%>
                      <%if (privMutasiView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/Mutasi')"><i class="fa fa-circle"></i> Mutasi</a></li>
                      <%}%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_nasabah_tidak_aktif.jsp')"><i class="fa fa-circle"></i> <%=namaNasabah%> Tidak Aktif</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_tabungan_per_shift.jsp')"><i class="fa fa-circle"></i> Tabungan Per Shift</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/report/tabungan/report_tabungan_saldo_akhir.jsp')"><i class="fa fa-circle"></i> Tabungan Saldo</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_kolektor.jsp')"><i class="fa fa-circle"></i> Kolektor</a></li>
                      <%--<li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_tabungan_per_nasabah.jsp')"><i class="fa fa-circle"></i> Tabungan Per <%=namaNasabah%></a></li>--%>
                  </ul>
                </li>
                <%}%>
                <%if (privSisaPinjamanView || privKolektibilitasView || privRangkumanKolektibilitasView
                        || privRiwayatPembayaranKreditView || privKreditPerShiftView || privKomisiSalesView) {%>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Kredit</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>              
                  <ul class="treeview-menu">
                    <%if (privSisaPinjamanView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/sisa_pinjaman.jsp')"><i class="fa fa-circle"></i> Sisa Pinjaman</a></li>
                      <%}%>
                    <%if (privRiwayatPembayaranKreditView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/riwayat_pembayaran_kredit.jsp')"><i class="fa fa-circle"></i> Riwayat Pembayaran Kredit</a></li>
                      <%}%>
                      <%if (privKolektibilitasView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_kolektabilitas.jsp')"><i class="fa fa-circle"></i> Kolektabilitas Kredit</a></li>
                      <%}%>
                      <%if (privRangkumanKolektibilitasView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_rangkuman_kolektabilitas.jsp')"><i class="fa fa-circle"></i> Rangkuman Kolektabilitas</a></li>
                      <%}%>     
                      <%if (privKreditPerShiftView) {%> 
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_kredit_per_shift.jsp')"><i class="fa fa-circle"></i> Kredit Per Shift</a></li>
                      <%}%>
                    <% if(privKomisiSalesView){ %>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_komisi_sales.jsp')"><i class="fa fa-circle"></i> Komisi Sales</a></li>
                    <% } %>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_pengembalian_barang.jsp')"><i class="fa fa-circle"></i> Laporan Pengembalian Barang</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_penghapusan_kredit.jsp')"><i class="fa fa-circle"></i> Laporan Penghapusan Kredit</a></li>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_penjualan_kredit.jsp')"><i class="fa fa-circle"></i> Data Penjualan Kredit</a></li>
                  </ul>
                </li>
                <%}%>
              </ul>
            </li>
            <%}%>

            <%if (privOpeningView || privClosingView || privPrintOpeningView || privPrintClosingView || privTellerShiftManagementView) {%>
            <li class="treeview teller-shift-i"><a class="affect" href="#"><i class="fa fa-bullhorn"></i> <span>Pergantian Teller</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i><i style="font-size:18px;margin-top:-2px;" class="fa fa-exclamation-circle pull-right">&nbsp;</i></span></a>          
              <ul class="treeview-menu">
                <%if (privOpeningView || privClosingView) {%>
                <li class="treeview"><a href="#" class="affect"><i class="fa fa-circle-o"></i> <span>Buka / Tutup Teller</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i><i style="font-size:18px;margin-top:-2px;" class="fa fa-exclamation-circle pull-right">&nbsp;</i></span></a>
                  <ul class="treeview-menu">
                    <% if (!opened) { %>
                    <%if (privOpeningView) {%>
                    <li><a href="javascript:setMainFrameUrl('<%=approot%>/tellershift/open_teller_shift.jsp')"><i class="fa fa-circle"></i> Buka</a></li>
                      <%}%>
                      <% } else { %>
                      <%if (privClosingView) {%>
                    <li><a href="#" class="show-closing affect" data-ask-spv="true" data-id="<%=open.get(0).getOID()%>"><i class="fa fa-circle"></i> Tutup</a></li>
                      <%}%>
                      <% } %>
                  </ul>
                </li>
                <%}%>
                <% if (opened || justClosed) { %>
                <%if (privPrintOpeningView || privPrintClosingView) {%>
                <li class="treeview"><a href="#"><i class="fa fa-circle-o"></i> <span>Dokumen Pergantian Teller</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>
                  <ul class="treeview-menu">
                    <%if (privPrintOpeningView) {%>
                    <li><a class="print-shift" data-print="opening" data-id="<%=c.getOID()%>" href="#"><i class="fa fa-circle"></i> Cetak Dok. Buka</a></li>
                      <%}%>
                      <% if (justClosed) { %>
                      <%if (privPrintClosingView) {%>
                    <li><a class="print-shift" data-print="closing" data-id="<%=c.getOID()%>" href="#"><i class="fa fa-circle"></i> Cetak Dok. Tutup</a></li>
                      <%}%>
                      <% } %>
                  </ul>
                </li>
                <%}%>
                <%}%>
                <%if (privTellerShiftManagementView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/tellershift/teller_shift_mgmt.jsp')"><i class="fa fa-circle-o"></i> Manajemen Teller </a></li>
                  <%}%>
              </ul>
            </li>
            <%}%>

            <%--<li><a href="javascript:setMainFrameUrl('/sedana_v1.0/manual/Manual Aiso_Ina.htm')"><i class="fa fa-book"></i> <span>Buku Petunjuk</span></a></li>--%>

            <%if (privUserView || privGroupPrivilageView || privPrivilageView || privSystemPropertyView) {%>
            <li class="treeview"><a href="#"><i class="fa fa-table"></i> <span>Sistem Admin</span><span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span></a>          
              <ul class="treeview-menu">
                <%if (privUserView) {%>
                <!--<li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/adminpage/userlist.jsp')"><i class="fa fa-circle-o"></i>User</a></li>-->
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/adminpage/userlist_new.jsp')"><i class="fa fa-circle-o"></i>User</a></li>
                  <%}%>
                  <%if (privGroupPrivilageView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/adminpage/grouplist.jsp')"><i class="fa fa-circle-o"></i>Group Privilage</a></li>
                  <%}%>
                  <%if (privPrivilageView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/sedana/adminpage/privilegelist.jsp')"><i class="fa fa-circle-o"></i>Privilage</a></li>
                  <%}%>
                  <%if (privSystemPropertyView) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/common/system/sysprop_1.jsp')"><i class="fa fa-circle-o"></i>System Property</a></li>
                  <%}%>  
                  <%if (true) {%>
                <li><a href="javascript:setMainFrameUrl('<%=approot%>/history_log/log_list.jsp')"><i class="fa fa-circle-o"></i>Log History</a></li>
                  <%}%>  
              </ul>
            </li>
            <%}%>
            <li><a href="javascript:logOut('<%=approot%>/logout.jsp')"><i class="fa fa-lock"></i> <span>Logout</span></a></li>
          </ul>
        </section>
        <!-- /.sidebar -->
      </aside>
      <!-- Content Wrapper. Contains page content -->

      <style>.content-wrapper{min-height: 0 !important;height:100% !important;}</style>
      <div class="content-wrapper" style="position: relative; background-color: #ffffff;">
        <!-- iFrame -->
        <iframe name="mainFrame" id="mainFrame" class="mainFrame" src="<%=redir%>"></iframe>
        <!-- /.mainFrame -->
      </div>
      <!-- /.content-wrapper -->
      <!-- ./wrapper -->
      <div id="shift-container"></div>    
      <div id="woo-modal"></div>
      <script>
        $(document).ready(function () {
          dataTableInvoker["shiftAction"]($("body").find("aside"));
        });
        $(document).on('doModal', function (event, e) {
          $('#woo-modal').html(e);
          $('#woo-modal').modal("show");
        });
      </script>
      <script>
        $(window).load(function () {
          var x = true;
          setInterval(function () {
            if (x) {
              x = false;
              basicAjax(baseUrl("ajax/check-closing-time.jsp"), function (r) {
                x = true;
                var o = JSON.parse(r);
                var target = $("body .teller-shift-i");
                if (o.isClosingTime == "true" && !$(target).hasClass("error")) {
                  $(target).addClass("error");
                } else if (o.isClosingTime == "false") {
                  $(target).removeClass("error");
                }
              }, {id: user});
            }
          }, 2000);
          $("#mainFrame").load(function () {
            $("#mainFrame").contents().find("body").css({'overflow': 'visible', 'position': 'relative', 'height': 0});
            $("#mainFrame").contents().find("html").css({'overflow-y': 'visible', 'position': 'relative'});
          });
        });
      </script>
    </div>
  <print-area><div id="shift-print" class="print-area"></div></print-area>
    <% if (justClosed && privOpeningView && !opened && FRMQueryString.requestCommand(request) == Command.SAVE) { %>
  <script>$(window).load(function () {
      $(".print-shift[data-print='closing']").trigger("click");
    })</script>
    <% } %>
    <%
      boolean opening = session.getAttribute("opening") == null ? false : (Boolean) session.getAttribute("opening");
      if (opening) {
        session.setAttribute("opening", false);
    %>
  <script>$(window).load(function () {
      $(".print-shift[data-print='opening']").trigger("click");
    })</script>
    <%}%>
</body>
</html>
