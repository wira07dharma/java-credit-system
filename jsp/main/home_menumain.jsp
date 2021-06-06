<%
// if menu will show
if(showMenu){

int intCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_SYSTEM, AppObjInfo.OBJ_SYSTEM_SYSTEM_APP);
boolean pAdd=userSession.checkPrivilege(AppObjInfo.composeCode(intCode, AppObjInfo.COMMAND_ADD));
boolean pUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(intCode, AppObjInfo.COMMAND_UPDATE));
boolean pDelete=userSession.checkPrivilege(AppObjInfo.composeCode(intCode, AppObjInfo.COMMAND_DELETE));

String strSubMenuList[][] =
{
	{
	 "HALAMAN UTAMA","BANTUAN","KELUAR","/manual/aiso_manual_ina.htm"
	 },

	{
	 "HOMEPAGE","HELP","LOGOUT","/manual/aiso_manual_english.htm"
	 }
};


String strSubMenuJournal[][] =
{
	{
	 "JURNAL",
	 "Jurnal Umum","Shared Transaksi","Integrasi dengan BO",
	 "Shared Pendapatan","Shared Biaya","Exchange Currency",
	 "Generate dari BO","Daftar Jurnal IJ"
	 },

	{
	 "JOURNAL",
	 "General Journal","Shared Transaction","BO Integration",
	 "Shared Income","Shared Expense","Exchange Currency",
	 "Generate from BO","List of IJ Journal"
	 }
};

String strSubMenuAktivaTetap[][] =
{
    {
     "AKTIVA TETAP",
     "Transaksi","Laporan","Order Aktiva",
     "Terima Aktiva","Penjualan Aktiva",
     "Penyusutan Aktiva","Laba(Rugi) Aktiva",
     "Aktiva dan Penyusutan"
     },

    {
     "AKTIVA TETAP",
     "Transaction","Report","Aktiva Order",
     "Aktiva Receive","Selling Aktiva",
     "Aktiva Reduction","Profit(Loss) Aktiva",
     "Aktiva and Penyusutan"
     }
};

// todo
String strSubMenuArAp[][] =
{
    {
     "HUTANG/PIUTANG",
     "Entry Hutang/Piutang",
     "Pembayaran Hutang/Piutang",
     "Laporan Hutang/Piutang",
     "Laporan Piutang Detail",
     "Laporan Hutang Detail",
     "Laporan BO Piutang",
     "Laporan BO Piutang Detail",
     "Laporan"
     },

    {
     "A.R./A.P",
     "AR/AP Entry",
     "AR/AP Payment",
     "AR/AP Report",
     "Receivable Detail Report",
     "Payable Detail Report",
     "BO Receivable Report",
     "BO Receivable Detail Report",
     "Report"
     }
};

String strSubMenuReport[][] =
{
	{
	 "LAPORAN",
	 "Laporan Utama","Laporan Pendukung","Analisa Laporan",
	 "Aliran Kas","Laba (Rugi)","Neraca",
	 "Buku Besar","Neraca Percobaan","Neraca Lajur",
	 "Cash Ratio","Current Ratio","Solvabilitas","Rentabilitas Modal","Rentabilitas Ekonomi"
	 },

	{
	 "REPORTS",
	 "Main Report","Additional Report","Report Analysis",
	 "Cash Flow","Profit (Loss)","Balance Sheet",
	 "General Ledger","Trial Balance","Work Sheet",
	 "Cash Ratio","Current Ratio","Solvability", "Equity Rentability", "Economic Rentability"
	 }
};

String strSubMenuPeriod[][] =
{
	{
	 "PERIODE",
	 "Setup Periode","Tutup Periode"
	 },

	{
	 "PERIOD",
	 "Period Setup","Closing Period"
	 }
};

String strSubMenuMasterdata[][] =
{
	{
	 "MASTERDATA",
	 "Data Perkiraan","Data Perusahaan","Data Pembayaran","Data Konfigurasi IJ",
	 "Daftar Perkiraan","Link Perkiraan",
	 "Daftar Departmen",
	 "Tipe Matauang","Kurs Standar",
	 "Konfigurasi IJ","Mapping Currency","Mapping Payment","Mapping Account","Mapping Lokasi",
     "Master Aktiva","Jenis Aktiva","Tipe Penyusutan","Metode Penyusutan","Aktiva","Grup Aktiva",
     "Master Hutang/Piutang", "Kontak", "Kelompok Kontak"
	 },

	{
	 "MASTERDATA",
	 "Account Data","Company Data","Payment Data","IJ Configuration Data",
	 "Chart Of Account","Account Link",
	 "List Of Department",
	 "Currency Type","Standart Rate",
	 "IJ Configuration","Currency Mapping","Payment Mapping","Account Mapping","Location Mapping",
     "Master Aktiva","Jenis Aktiva","Tipe Penyusutan","Metode Penyusutan","Aktiva","Aktiva Group",
     "Master AR/AP", "Contact", "Contact Class"
	 }
};

String strSubMenuSystem[][] =
{
	{
	 "SISTEM",
	 "Manajemen User","Manajemen Sistem",
	 "User","Group","Privilege",
	 "Setting Aplikasi","Back Up Database"
	 },

	{
	 "SYSTEM",
	 "User Management","System Management",
	 "User","Group","Privilege",
	 "Application Setting","Back Up Database"
	 }
};
%>

<SCRIPT language=JavaScript>
function fwLoadMenus() {
  if (window.fw_menu_0) return;

	  // --- start menu jurnal ---
	  // create sub menu shared transaction
	  window.fw_menu_0_0 = new Menu("<%=strSubMenuJournal[SESS_LANGUAGE][2]%>", 130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_0_0.addMenuItem("<%=strSubMenuJournal[SESS_LANGUAGE][4]%>", "location='<%=approot%>/journal/shared_income_trans.jsp'");
	  fw_menu_0_0.addMenuItem("<%=strSubMenuJournal[SESS_LANGUAGE][5]%>", "location='<%=approot%>/journal/shared_expense_trans.jsp'");
	  fw_menu_0_0.addMenuItem("<%=strSubMenuJournal[SESS_LANGUAGE][6]%>", "location='<%=approot%>/journal/currency_exchange_trans.jsp'");

	  // create sub menu IJ
	  window.fw_menu_0_1 = new Menu("<%=strSubMenuJournal[SESS_LANGUAGE][3]%>",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_0_1.addMenuItem("<%=strSubMenuJournal[SESS_LANGUAGE][7]%>", "location='<%=ijroot%>/engine/ij_journal_process.jsp'");
	  fw_menu_0_1.addMenuItem("<%=strSubMenuJournal[SESS_LANGUAGE][8]%>", "location='<%=ijroot%>/engine/src_ij_journal.jsp'");
	  fw_menu_0_1.hideOnMouseOut=true;

  	  // menu journal
	  window.fw_menu_0 = new Menu("root",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_0.addMenuItem("<%=strSubMenuJournal[SESS_LANGUAGE][1]%>", "location='<%=approot%>/journal/journals.jsp'");
 	  //fw_menu_0.addMenuItem(fw_menu_0_0);
	  fw_menu_0.addMenuItem(fw_menu_0_1);
	  fw_menu_0.childMenuIcon="<%=approot%>/images/arrows.gif";
	  fw_menu_0.hideOnMouseOut=true;
	  // --- end menu jurnal ---



	  // --- start menu report ---
	  // create sub menu laporan utama
	  window.fw_menu_1_0 = new Menu("<%=strSubMenuReport[SESS_LANGUAGE][1]%>",100,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_1_0.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][4]%>", "location='<%=approot%>/report/cash_flow_dept.jsp'");
	  fw_menu_1_0.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][5]%>", "location='<%=approot%>/report/profit_loss_dept.jsp'");
	  fw_menu_1_0.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][6]%>", "location='<%=approot%>/report/balance_sheet_dept.jsp'");
      fw_menu_1_0.hideOnMouseOut=true;

	  // create sub menu laporan pendukung
	  window.fw_menu_1_1 = new Menu("<%=strSubMenuReport[SESS_LANGUAGE][2]%>",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_1_1.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][7]%>", "location='<%=approot%>/report/general_ledger_dept.jsp'");
      fw_menu_1_1.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][8]%>", "location='<%=approot%>/report/trial_balance_dept.jsp'");
      fw_menu_1_1.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][9]%>", "location='<%=approot%>/report/worksheet_dept.jsp'");
	  fw_menu_1_1.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_1_1.hideOnMouseOut=true;

	  // create sub menu analisa laporan
	  window.fw_menu_1_2 = new Menu("<%=strSubMenuReport[SESS_LANGUAGE][3]%>",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_1_2.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][10]%>", "location='<%=approot%>/analysis/cash_ratio.jsp'");
      fw_menu_1_2.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][11]%>", "location='<%=approot%>/analysis/current_ratio.jsp'");
      fw_menu_1_2.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][12]%>", "location='<%=approot%>/analysis/solvabilitas.jsp'");
      fw_menu_1_2.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][13]%>", "location='<%=approot%>/analysis/rentabilitas_modal.jsp'");
      fw_menu_1_2.addMenuItem("<%=strSubMenuReport[SESS_LANGUAGE][14]%>", "location='<%=approot%>/analysis/rentabilitas_ekonomis.jsp'");
	  fw_menu_1_2.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_1_2.hideOnMouseOut=true;

	  window.fw_menu_1 = new Menu("root",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_1.addMenuItem(fw_menu_1_0);
	  fw_menu_1.addMenuItem(fw_menu_1_1);
	  //fw_menu_1.addMenuItem(fw_menu_1_2);
	  fw_menu_1.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_1.hideOnMouseOut=true;
	  // --- end menu report ---



	  // --- start menu period ---
	  window.fw_menu_2 = new Menu("root",100,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_2.addMenuItem("<%=strSubMenuPeriod[SESS_LANGUAGE][1]%>", "location='<%=approot%>/period/setup_period.jsp'");
	  <%
	  if(validCloseBookToday)
	  {
	  %>
	  fw_menu_2.addMenuItem("<%=strSubMenuPeriod[SESS_LANGUAGE][2]%>", "location='<%=approot%>/period/close_book.jsp'");
	  <%
	  }
	  %>
	  fw_menu_2.hideOnMouseOut=true;
	  // --- end menu period ---




	  // --- start menu masterdata ---
	  // create sub menu data perkiraan
	  window.fw_menu_3_0 = new Menu("<%=strSubMenuMasterdata[SESS_LANGUAGE][1]%>",110,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3_0.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][5]%>", "location='<%=approot%>/masterdata/account_chart.jsp'");
	  fw_menu_3_0.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][6]%>", "location='<%=approot%>/masterdata/account_link.jsp'");
	  fw_menu_3_0.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_3_0.hideOnMouseOut=true;

	  // create sub menu data perusahaan
	  window.fw_menu_3_1 = new Menu("<%=strSubMenuMasterdata[SESS_LANGUAGE][2]%>",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3_1.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][7]%>", "location='<%=approot%>/masterdata/company/department.jsp'");
	  fw_menu_3_1.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_3_1.hideOnMouseOut=true;

	  // create sub menu data pembayaran
	  window.fw_menu_3_2 = new Menu("<%=strSubMenuMasterdata[SESS_LANGUAGE][3]%>",110,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3_2.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][8]%>", "location='<%=approot%>/common/payment/currencytype.jsp'");
	  fw_menu_3_2.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][9]%>", "location='<%=approot%>/common/payment/standartrate.jsp'");
	  fw_menu_3_2.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_3_2.hideOnMouseOut=true;

	  // create sub menu data IJ
	  window.fw_menu_3_3 = new Menu("<%=strSubMenuMasterdata[SESS_LANGUAGE][4]%>",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3_3.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][10]%>", "location='<%=ijroot%>/configuration/ijconfiguration.jsp'");
	  fw_menu_3_3.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][11]%>", "location='<%=ijroot%>/mapping/ijcurrencymapping.jsp'");
	  fw_menu_3_3.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][12]%>", "location='<%=ijroot%>/mapping/ijpaymentmapping.jsp'");
	  fw_menu_3_3.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][13]%>", "location='<%=ijroot%>/mapping/ijaccountmapping.jsp'");
	  fw_menu_3_3.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][14]%>", "location='<%=ijroot%>/mapping/ijlocationmapping.jsp'");
	  fw_menu_3_3.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_3_3.hideOnMouseOut=true;

	  window.fw_menu_3_4 = new Menu("<%=strSubMenuMasterdata[SESS_LANGUAGE][15]%>",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3_4.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][16]%>", "location='<%=approot%>/masterdata/aktiva/jenisaktiva.jsp'");
	  fw_menu_3_4.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][17]%>", "location='<%=approot%>/masterdata/aktiva/typepenyusutan.jsp'");
	  fw_menu_3_4.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][18]%>", "location='<%=approot%>/masterdata/aktiva/metodepenyusutan.jsp'");
      fw_menu_3_4.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][20]%>", "location='<%=approot%>/masterdata/aktiva/aktiva_group.jsp'");
      fw_menu_3_4.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][19]%>", "location='<%=approot%>/masterdata/aktiva/modul_aktiva_search.jsp'");
	  fw_menu_3_4.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_3_4.hideOnMouseOut=true;

      window.fw_menu_3_5 = new Menu("<%=strSubMenuMasterdata[SESS_LANGUAGE][21]%>",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3_5.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][22]%>", "location='<%=approot%>/masterdata/contact/srccontact_list.jsp'");
	  fw_menu_3_5.addMenuItem("<%=strSubMenuMasterdata[SESS_LANGUAGE][23]%>", "location='<%=approot%>/masterdata/contact/contact_class.jsp'");
	  fw_menu_3_5.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_3_5.hideOnMouseOut=true;

	  window.fw_menu_3 = new Menu("root",150,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3.addMenuItem(fw_menu_3_0);
	  fw_menu_3.addMenuItem(fw_menu_3_1);
	  fw_menu_3.addMenuItem(fw_menu_3_2);
  	  fw_menu_3.addMenuItem(fw_menu_3_3);
      fw_menu_3.addMenuItem(fw_menu_3_4);
      fw_menu_3.addMenuItem(fw_menu_3_5);
	  fw_menu_3.childMenuIcon="<%=approot%>/images/arrows.gif";
	  fw_menu_3.hideOnMouseOut=true;
	  // --- end menu masterdata ---




	  // --- start menu system ---
	  // create sub menu manajemen user
	  window.fw_menu_4_0 = new Menu("<%=strSubMenuSystem[SESS_LANGUAGE][1]%>",80,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_4_0.addMenuItem("<%=strSubMenuSystem[SESS_LANGUAGE][3]%>", "location='<%=approot%>/admin/userlist.jsp'");
      fw_menu_4_0.addMenuItem("<%=strSubMenuSystem[SESS_LANGUAGE][4]%>", "location='<%=approot%>/admin/grouplist.jsp'");
      fw_menu_4_0.addMenuItem("<%=strSubMenuSystem[SESS_LANGUAGE][5]%>", "location='<%=approot%>/admin/privilegelist.jsp'");
      fw_menu_4_0.hideOnMouseOut=true;

	  // create sub menu manajemen sistem
	  window.fw_menu_4_1 = new Menu("<%=strSubMenuSystem[SESS_LANGUAGE][2]%>",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_4_1.addMenuItem("<%=strSubMenuSystem[SESS_LANGUAGE][6]%>", "location='<%=approot%>/common/system/sysprop.jsp'");
      fw_menu_4_1.addMenuItem("<%=strSubMenuSystem[SESS_LANGUAGE][7]%>", "location='<%=approot%>/common/service/service_center.jsp'");
      fw_menu_4_1.hideOnMouseOut=true;

	  window.fw_menu_4 = new Menu("root",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_4.addMenuItem(fw_menu_4_0);
	  <%
	  if(pAdd && pUpdate && pDelete)
	  {
	  %>
	  fw_menu_4.addMenuItem(fw_menu_4_1);
	  <%
	  }
	  %>
	  // --- end menu system ---
	  fw_menu_4.hideOnMouseOut=true;
	  fw_menu_4.childMenuIcon="<%=approot%>/images/arrows.gif";


      // menus aktiva tetap
      window.fw_menu_5_0 = new Menu("<%=strSubMenuAktivaTetap[SESS_LANGUAGE][1]%>",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_5_0.addMenuItem("<%=strSubMenuAktivaTetap[SESS_LANGUAGE][3]%>", "location='<%=approot%>/aktiva/order_aktiva_search.jsp'");
      fw_menu_5_0.addMenuItem("<%=strSubMenuAktivaTetap[SESS_LANGUAGE][4]%>", "location='<%=approot%>/aktiva/receive_aktiva_search.jsp'");
      fw_menu_5_0.addMenuItem("<%=strSubMenuAktivaTetap[SESS_LANGUAGE][5]%>", "location='<%=approot%>/aktiva/selling_aktiva_search.jsp'");
      fw_menu_5_0.addMenuItem("<%=strSubMenuAktivaTetap[SESS_LANGUAGE][6]%>", "location='<%=approot%>/aktiva/penyusutan_aktiva.jsp'");
      fw_menu_5_0.hideOnMouseOut=true;

      // menus report aktiva tetap
      window.fw_menu_5_1 = new Menu("<%=strSubMenuAktivaTetap[SESS_LANGUAGE][2]%>",160,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_5_1.addMenuItem("<%=strSubMenuAktivaTetap[SESS_LANGUAGE][7]%>", "location='<%=approot%>/report/aktiva/labarugi_aktiva.jsp'");
      fw_menu_5_1.addMenuItem("<%=strSubMenuAktivaTetap[SESS_LANGUAGE][8]%>", "location='<%=approot%>/report/aktiva/aktiva_dan_penyusutannya.jsp'");
      fw_menu_5_1.hideOnMouseOut=true;

	  window.fw_menu_5 = new Menu("root",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_5.addMenuItem(fw_menu_5_0);
      fw_menu_5.addMenuItem(fw_menu_5_1);
      fw_menu_5.childMenuIcon="<%=approot%>/images/arrows.gif";
      fw_menu_5.hideOnMouseOut=true;

<%// todo%>
      // menu AR/AP
      // menus aktiva tetap
      window.fw_menu_6_0 = new Menu("<%=strSubMenuArAp[SESS_LANGUAGE][8]%>",180,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_6_0.addMenuItem("<%=strSubMenuArAp[SESS_LANGUAGE][3]%>", "location='<%=approot%>/arap/arap_report_search.jsp'");
      fw_menu_6_0.addMenuItem("<%=strSubMenuArAp[SESS_LANGUAGE][4]%>", "location='<%=approot%>/arap/arap_report_detail_search.jsp?arap_type=0'");
      fw_menu_6_0.addMenuItem("<%=strSubMenuArAp[SESS_LANGUAGE][5]%>", "location='<%=approot%>/arap/arap_report_detail_search.jsp?arap_type=1'");
      fw_menu_6_0.addMenuItem("<%=strSubMenuArAp[SESS_LANGUAGE][6]%>", "location='<%=approot%>/arap/arap_bo_report_search.jsp'");
      fw_menu_6_0.addMenuItem("<%=strSubMenuArAp[SESS_LANGUAGE][7]%>", "location='<%=approot%>/arap/arap_bo_report_detail_search.jsp?arap_type=0'");
      fw_menu_6_0.hideOnMouseOut=true;

	  window.fw_menu_6 = new Menu("root",180,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_6.addMenuItem("<%=strSubMenuArAp[SESS_LANGUAGE][1]%>", "location='<%=approot%>/arap/arap_entry_search.jsp'");
      fw_menu_6.addMenuItem("<%=strSubMenuArAp[SESS_LANGUAGE][2]%>", "location='<%=approot%>/arap/arap_report_detail_search.jsp?payment=1'");
      fw_menu_6.addMenuItem(fw_menu_6_0);
 	  fw_menu_6.childMenuIcon="<%=approot%>/images/arrows.gif";
	  fw_menu_6.hideOnMouseOut=true;
	  // --- end menu jurnal ---

      fw_menu_4.writeMenus();
} // fwLoadMenus()

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
</SCRIPT>

<SCRIPT language="JavaScript">
function cordYMenu0(cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_0,cordX,posY);
}

function cordYMenu1 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_1,cordX,posY);
}

function cordYMenu2 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_2,cordX,posY);
}

function cordYMenu3 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_3,cordX,posY);
}

function cordYMenu4 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_4,cordX,posY);
}
function cordYMenu5 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_5,cordX,posY);
}

function cordYMenu6 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_6,cordX,posY);
}

</SCRIPT>


<SCRIPT language=JavaScript src="<%=approot%>/main/fw_menu.js"></SCRIPT>
<SCRIPT language=JavaScript1.2>fwLoadMenus();</SCRIPT>

<!-- saved offset of each menu -->
<input type="hidden" id="M0">
<input type="hidden" id="M1">
<input type="hidden" id="M2">
<input type="hidden" id="M3">
<input type="hidden" id="M4">
<input type="hidden" id="M5">
<input type="hidden" id="M6">

<SCRIPT>
function setScr(){
	document.all.M0.value = document.all.divMenu0.offsetLeft + 10;
	document.all.M1.value = document.all.divMenu1.offsetLeft + 10;
	document.all.M2.value = document.all.divMenu2.offsetLeft + 10;
	document.all.M3.value = document.all.divMenu3.offsetLeft + 10;
	document.all.M4.value = document.all.divMenu4.offsetLeft + 10;
    document.all.M5.value = document.all.divMenu5.offsetLeft + 10;
    document.all.M6.value = document.all.divMenu6.offsetLeft + 10;
}
window.onload = setScr;
window.onresize = setScr;

function showHelp(){
	window.open("<%=approot+strSubMenuList[SESS_LANGUAGE][3]%>","reportPage","height=600,width=800,status=no,scrollbars=yes,toolbar=no,menubar=yes,location=no");
}
</SCRIPT>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="footer">
  <tr>
	<td nowrap>
	  <div align="center">
	    <A href="<%=approot%>/main/homepage.jsp"" class="topmenu"><%=strSubMenuList[SESS_LANGUAGE][0]%></A>
	    | <A id="divMenu0" href="#" onclick="javascript:cordYMenu0(document.all.M0.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strSubMenuJournal[SESS_LANGUAGE][0]%></A>
        | <A id="divMenu5" href="#" onclick="javascript:cordYMenu5(document.all.M5.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strSubMenuAktivaTetap[SESS_LANGUAGE][0]%></A>
        | <A id="divMenu6" href="#" onclick="javascript:cordYMenu6(document.all.M6.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strSubMenuArAp[SESS_LANGUAGE][0]%></A>
        | <A id="divMenu1" href="#" onclick="javascript:cordYMenu1(document.all.M1.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strSubMenuReport[SESS_LANGUAGE][0]%></A>
        | <A id="divMenu2" href="#" onclick="javascript:cordYMenu2(document.all.M2.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strSubMenuPeriod[SESS_LANGUAGE][0]%></A>
        | <A id="divMenu3" href="#" onclick="javascript:cordYMenu3(document.all.M3.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strSubMenuMasterdata[SESS_LANGUAGE][0]%></A>
        | <A id="divMenu4" href="#" onclick="javascript:cordYMenu4(document.all.M4.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strSubMenuSystem[SESS_LANGUAGE][0]%></A>
        | <A href="#" onclick="javascript:showHelp();" class="topmenu"><%=strSubMenuList[SESS_LANGUAGE][1]%></A>
        <%if(userSession!=null){%>
        | <A href="<%=approot%>/logout.jsp" class="topmenu"><%=strSubMenuList[SESS_LANGUAGE][2]%></A>
        <%}%>
		</div>
	</td>
  </tr>
</table>


<%
// if menu will not show
}else{
%>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="footer">
  <tr><td><div align="center"><%=replaceMenuWith%></div></td></tr>
</table>

<%}%>