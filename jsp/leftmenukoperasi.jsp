<%@ page language="java" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ include file = "main/javainit.jsp" %>
<%  int iMain = 0;
  iMain = FRMQueryString.requestInt(request, "closeopen");
  if (session.getValue("CHECK_MENU") != null) {
    session.removeValue("CHECK_MENU");
  }
  System.out.println("iCheckMenu left menu :::::::::::::::::: " + iCheckMenu);
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
      "Penambahan Tabungan",//133
      "Penarikan Tabungan",//134
      "Laporan",//135
      "Laporan Tabungan",//136
      "Laporan Usaha",//137
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
      "Laporan Usaha",//137
    },};


%>
<html>
  <head>
    <title>SEDANA Menu</title>
    <SCRIPT language=JavaScript>

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
                              <%@ include file = "privkoperasimenu.jsp" %>  
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



<div id="dd0" class="clip" style="display:block;"><div class="dTreeNode"><img src="img/join.gif" alt=""><img id="id1" src="img/page.gif" alt=""><a id="sd1" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/homexframe.jsp')" onclick="javascript: d.s(1);">Halaman Utama</a></div><div class="dTreeNode"><a href="javascript: d.o(2);"><img id="jd2" src="img/plus.gif" alt=""></a><img id="id2" src="img/folder.gif" alt=""><a id="sd2" class="node" href="javascript: d.0(111)" onclick="javascript: d.s(2);">Master Koperasi</a></div><div id="dd2" class="clip" style="display: none;"><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id3" src="img/page.gif" alt=""><a id="sd3" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/anggota/anggota_search.jsp')" onclick="javascript: d.s(3);">List Anggota</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id4" src="img/page.gif" alt=""><a id="sd4" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/anggota/education.jsp')" onclick="javascript: d.s(4);">Pendidikan</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id5" src="img/page.gif" alt=""><a id="sd5" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/anggota/kelompok_koperasi.jsp')" onclick="javascript: d.s(5);">Kelompok Anggota</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id6" src="img/page.gif" alt=""><a id="sd6" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/region/province.jsp')" onclick="javascript: d.s(6);">Propinsi</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id7" src="img/page.gif" alt=""><a id="sd7" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/region/city.jsp')" onclick="javascript: d.s(7);">Kota</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id8" src="img/page.gif" alt=""><a id="sd8" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/region/regency.jsp')" onclick="javascript: d.s(8);">Kabupaten</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id9" src="img/page.gif" alt=""><a id="sd9" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/region/subregency.jsp')" onclick="javascript: d.s(9);">Kecamatan</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id10" src="img/page.gif" alt=""><a id="sd10" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/region/ward.jsp')" onclick="javascript: d.s(10);">Kelurahan</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id11" src="img/page.gif" alt=""><a id="sd11" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/anggota/vocation.jsp')" onclick="javascript: d.s(11);">Pekerjaan</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/joinbottom.gif" alt=""><img id="id12" src="img/page.gif" alt=""><a id="sd12" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/anggota/position.jsp')" onclick="javascript: d.s(12);">Jabatan</a></div></div><div class="dTreeNode"><a href="javascript: d.o(13);"><img id="jd13" src="img/plus.gif" alt=""></a><img id="id13" src="img/folder.gif" alt=""><a id="sd13" class="node" href="javascript: d.0(113)" onclick="javascript: d.s(13);">Master Tabungan</a></div><div id="dd13" class="clip" style="display: none;"><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id14" src="img/page.gif" alt=""><a id="sd14" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/mastertabungan/jenis_deposito.jsp')" onclick="javascript: d.s(14);">Jenis Deposito</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id15" src="img/page.gif" alt=""><a id="sd15" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/mastertabungan/jenis_kredit.jsp')" onclick="javascript: d.s(15);">Jenis Kredit</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id16" src="img/page.gif" alt=""><a id="sd16" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/mastertabungan/jenis_simpanan.jsp')" onclick="javascript: d.s(16);">Jenis Simpanan</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id17" src="img/page.gif" alt=""><a id="sd17" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/mastertabungan/mastertabungan.jsp')" onclick="javascript: d.s(17);">Jenis Tabungan Koperasi</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id18" src="img/page.gif" alt=""><a id="sd18" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/mastertabungan/afiliasi.jsp')" onclick="javascript: d.s(18);">Afiliasi</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id19" src="img/page.gif" alt=""><a id="sd19" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/mastertabungan/setting_tabungan.jsp')" onclick="javascript: d.s(19);">Tabungan Setting Bunga</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/joinbottom.gif" alt=""><img id="id20" src="img/page.gif" alt=""><a id="sd20" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/mastertabungan/type_tabungan.jsp')" onclick="javascript: d.s(20);">Jenis Penabungan</a></div></div><div class="dTreeNode"><a href="javascript: d.o(21);"><img id="jd21" src="img/plus.gif" alt=""></a><img id="id21" src="img/folder.gif" alt=""><a id="sd21" class="node" href="javascript: d.0(112)" onclick="javascript: d.s(21);">Transaksi</a></div><div id="dd21" class="clip" style="display: none;"><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id22" src="img/page.gif" alt=""><a id="sd22" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/transaksi/deposito.jsp')" onclick="javascript: d.s(22);">Deposito</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id23" src="img/page.gif" alt=""><a id="sd23" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/transaksi/listpinjaman.jsp')" onclick="javascript: d.s(23);">Kredit</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id24" src="img/page.gif" alt=""><a id="sd24" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/transaksi/data_tabungan.jsp')" onclick="javascript: d.s(24);">Data Tabungan</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/joinbottom.gif" alt=""><img id="id25" src="img/page.gif" alt=""><a id="sd25" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/transaksi/data_transaksi.jsp')" onclick="javascript: d.s(25);">Data Transaksi</a></div></div><div class="dTreeNode"><a href="javascript: d.o(26);"><img id="jd26" src="img/plus.gif" alt=""></a><img id="id26" src="img/folder.gif" alt=""><a id="sd26" class="node" href="javascript: d.0(116)" onclick="javascript: d.s(26);">Laporan</a></div><div id="dd26" class="clip" style="display: none;"><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/join.gif" alt=""><img id="id27" src="img/page.gif" alt=""><a id="sd27" class="nodeSel" href="javascript:setMainFrameUrl('/sedana_v1.0/masterdata/masterreportsp/report_tabungan.jsp')" onclick="javascript: d.s(27);">Laporan Tabungan</a></div><div class="dTreeNode"><img src="img/line.gif" alt=""><img src="img/joinbottom.gif" alt=""><img id="id28" src="img/page.gif" alt=""><a id="sd28" class="node" href="#" onclick="javascript: d.s(28);">Laporan Usaha</a></div></div><div class="dTreeNode"><img src="img/join.gif" alt=""><img id="id29" src="img/page.gif" alt=""><a id="sd29" class="node" href="javascript:setMainFrameUrl('/sedana_v1.0/manual/Manual Aiso_Ina.htm')" onclick="javascript: d.s(29);">Buku Petunjuk</a></div><div class="dTreeNode"><img src="img/joinbottom.gif" alt=""><img id="id30" src="img/page.gif" alt=""><a id="sd30" class="node" href="javascript:logOut('/sedana_v1.0/logout.jsp')" onclick="javascript: d.s(30);">Keluar</a></div></div>