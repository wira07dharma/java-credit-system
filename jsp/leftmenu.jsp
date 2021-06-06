<%@ page language="java" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ include file = "main/javainit.jsp" %>
<%
int iMain = 0;
iMain = FRMQueryString.requestInt(request, "closeopen");
if(session.getValue("CHECK_MENU") != null){
    session.removeValue("CHECK_MENU");
}
System.out.println("iCheckMenu left menu :::::::::::::::::: "+iCheckMenu);
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
		"Laporan Donor",//34
		"Laporan Donor Konsolidasi",//35
		"Laporan Biaya per Department",//36
		"Laporan Laba(Rugi) Tahunan Detail",//37
		"Laporan Laba(Rugi) Tahunan",//38
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
		"Laporan Hutang/Piutang",//70
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
                        "Laporan"//135
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
                        "Report"//135
	},
};


%>
<html>
<head>
<title>SEDANA Menu</title>
<SCRIPT language=JavaScript>

function setMainFrameUrl(url){  
 <% if(iCheckMenu > 0){ %>
	    if(confirm("<%=strMenuNames[SESS_LANGUAGE][45]%>")){
		    if(parent.mainFrame.window.closeWindow != null){
			    parent.mainFrame.window.closeWindow(); 
		    }
		    parent.mainFrame.window.location=url; 
	     }
	<% }else{%>
	    if(parent.mainFrame.window.closeWindow != null){
		    parent.mainFrame.window.closeWindow(); 
		}		
		parent.mainFrame.window.location=url;		
  <%}%>
  
}
function logOut(url){

 parent.window.location=url;
}

</SCRIPT>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="style/main.css" type="text/css">
<link rel="StyleSheet" href="dtree/dtree.css" type="text/css" />
<script type="text/javascript" src="dtree/dtree.js"></script>
</head>
<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" background="#FFFFFF">
<form name="leftframe" method="post" action="">
<input type="hidden" name="command" value="">
<input type="hidden" name="closeopen" value="<%=iMain%>">
</form>
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td class="leftbar" ID="TOPTITLE" valign="top"> 
      <table width="100%" border="0" cellpadding="1" cellspacing="2">
        <tr> 
          <td bgcolor="#CCCC66" height="18"> 
            <table width="100%" border="0" bgcolor="#FFFFFF" height="100%">
              <tr> 
                <td> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="menuleft" height="100%">
                      <tr> 
                          <td colspan="2"> 
                              <div class="dtree"> 
                                  <%@ include file = "privusermenu.jsp" %>  
                              </div>
                          </td>
                      </tr>
                      <tr align="left" valign="top"> 
                          <td height="100%" width="17%" align="right">&nbsp; </td>
                          <td height="100%" width="83%">&nbsp;</td>
                      </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</body>
</html>
