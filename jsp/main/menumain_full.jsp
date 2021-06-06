<% 
// if menu will show
if(showMenu){ 

int intCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_SYSTEM, AppObjInfo.OBJ_SYSTEM_SYSTEM_APP); 
boolean pAdd=userSession.checkPrivilege(AppObjInfo.composeCode(intCode, AppObjInfo.COMMAND_ADD));
boolean pUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(intCode, AppObjInfo.COMMAND_UPDATE));
boolean pDelete=userSession.checkPrivilege(AppObjInfo.composeCode(intCode, AppObjInfo.COMMAND_DELETE));


String strSubMenuList[][] = {
	{"Jurnal Umum","Depresiasi","Aktiva Tetap","Aktiva Lain","Lainnya","Piutang","Utang","Buku Besar","Daftar Jurnal",
	 "Neraca Percobaan","Aliran Kas","Laba Kotor Penjualan","Laba Rugi","Neraca","Setup Periode","Tutup Buku",
	 "Perkiraan","Daftar Perkiraan","Link Perkiraan","Grup Aktiva","Masterdata","Departemen","Posisi","Kategori",
	 "Perkawinan","Agama","Perusahaan","Daftar Pegawai","Kontak","Perusahaan","Perseorangan","Kelompok Kontak",
	 "Manajemen User","User","Group","Privilege","Manajemen System","Setting Aplikasi","Back Up Data","<%=approot%>/manual/aiso_manual_ina.htm"},    
	 
	{"General Journal","Depreciation","Fixed Asset","Others Asset","Others","Receivable","Payable","General Ledger","Query Journal",
	 "Trial Balance","Cash Flow","Gross Profit of Goods Sold","Profit Loss","Balance Sheet","Setup Period","Close Book",
	 "Account","Account Chart","Account Link","Asset Group","Masterdata","Department","Position","Category",
	 "Marital","Religion","Company","Employee List","Contact","Company","Personnel","Contact Class",
	 "User Management","User","Group","Privilege","System Management","Application Setting","Back Up Service","<%=approot%>/manual/aiso_manual_english.htm"}
};
%>

<SCRIPT language=JavaScript>
function fwLoadMenus() {
  if (window.fw_menu_0) return;  
  
  	  // menu journal
	  window.fw_menu_0 = new Menu("root",170,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_0.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][0]%>", "location='<%=approot%>/journal/journals.jsp'");
 	  fw_menu_0.addMenuItem("Check Unbalance Journal", "location='<%=approot%>/journal/unbalancejournal.jsp'");
	  fw_menu_0.hideOnMouseOut=true; 
	
	  
	  //menu report 
	  //-------create sub menu others -----------
	  window.fw_menu_1_7_1 = new Menu("<%=strSubMenuList[SESS_LANGUAGE][1]%>",90,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_1_7_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][2]%>", "location='<%=approot%>/report/fixed_depretiation.jsp'");
      fw_menu_1_7_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][3]%>", "location='<%=approot%>/report/other_depretiation.jsp'");
      fw_menu_1_7_1.hideOnMouseOut=true;	  

	  //-------create sub menu others -----------
	  window.fw_menu_1_7 = new Menu("<%=strSubMenuList[SESS_LANGUAGE][4]%>",100,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_1_7.addMenuItem(fw_menu_1_7_1);
      fw_menu_1_7.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][5]%>", "location='<%=approot%>/report/receivable.jsp'");
      fw_menu_1_7.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][6]%>", "location='<%=approot%>/report/payable.jsp'");	  	  
	  fw_menu_1_7.childMenuIcon="<%=approot%>/images/arrows.gif"; 	  
      fw_menu_1_7.hideOnMouseOut=true;	  
	   
	  window.fw_menu_1 = new Menu("root",180,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][7]%>", "location='<%=approot%>/report/general_ledger.jsp'");	  
	  fw_menu_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][8]%>", "location='<%=approot%>/report/query_journal.jsp'");
	  fw_menu_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][9]%>", "location='<%=approot%>/report/trial_balance.jsp'");
	  fw_menu_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][10]%>", "location='<%=approot%>/report/cash_flow.jsp'");
	  fw_menu_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][11]%>", "location='<%=approot%>/report/gross_profit.jsp'");
	  fw_menu_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][12]%>", "location='<%=approot%>/report/profit_loss.jsp'");   	  
	  fw_menu_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][13]%>", "location='<%=approot%>/report/balance_sheet.jsp'");
	  fw_menu_1.addMenuItem(fw_menu_1_7);   
	  fw_menu_1.childMenuIcon="<%=approot%>/images/arrows.gif"; 	  
      fw_menu_1.hideOnMouseOut=true; 	  
	
	  
	  //period
	  window.fw_menu_2 = new Menu("root",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_2.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][14]%>", "location='<%=approot%>/period/setup_period.jsp'");
	  <%if(validCloseBookToday){%>
	  fw_menu_2.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][15]%>", "location='<%=approot%>/period/close_book.jsp'");
	  <%}%>
	  fw_menu_2.hideOnMouseOut=true;
	  
	
	  //master data 
	  //-----------create sub Menu Account--------------
	  window.fw_menu_3_1 = new Menu("<%=strSubMenuList[SESS_LANGUAGE][16]%>",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][17]%>", "location='<%=approot%>/masterdata/account_chart.jsp'");
	  fw_menu_3_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][18]%>", "location='<%=approot%>/masterdata/account_link.jsp'");	  	    	  	  
	  fw_menu_3_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][19]%>", "location='<%=approot%>/masterdata/assetgroup.jsp'");
	  fw_menu_3_1.childMenuIcon="<%=approot%>/images/arrows.gif";	  	  	
      fw_menu_3_1.hideOnMouseOut=true; 	 	  

		  //-----------create sub Employee--------------
		  window.fw_menu_3_2_1 = new Menu("<%=strSubMenuList[SESS_LANGUAGE][20]%>",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
		  fw_menu_3_2_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][21]%>", "location='<%=approot%>/masterdata/company/department.jsp'");
		  fw_menu_3_2_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][22]%>", "location='<%=approot%>/masterdata/company/position.jsp'");
		  fw_menu_3_2_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][23]%>", "location='<%=approot%>/masterdata/company/empcategory.jsp'");	  	  		  		  
		  fw_menu_3_2_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][24]%>", "location='<%=approot%>/masterdata/company/marital.jsp'");
		  fw_menu_3_2_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][25]%>", "location='<%=approot%>/masterdata/company/religion.jsp'");	  	  
		  fw_menu_3_2_1.childMenuIcon="<%=approot%>/images/arrows.gif";	  		  
		  fw_menu_3_2_1.hideOnMouseOut=true;  

	  //-----------create sub Employee--------------
	  window.fw_menu_3_2 = new Menu("<%=strSubMenuList[SESS_LANGUAGE][26]%>",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3_2.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][27]%>", "location='<%=approot%>/masterdata/company/srcemployee.jsp'");
	  fw_menu_3_2.addMenuItem(fw_menu_3_2_1);  	  
	  fw_menu_3_2.childMenuIcon="<%=approot%>/images/arrows.gif";	  
	  fw_menu_3_2.hideOnMouseOut=true;
	  
	  //-----------create sub Menu Reference Data--------------
	  window.fw_menu_3_3 = new Menu("<%=strSubMenuList[SESS_LANGUAGE][28]%>",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3_3.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][29]%>", "location='<%=approot%>/masterdata/contact/srccontact_list.jsp'");
	  fw_menu_3_3.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][30]%>", "location='<%=approot%>/masterdata/contact/srcpersonnel_list.jsp'");   
	  fw_menu_3_3.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][31]%>", "location='<%=approot%>/masterdata/contact/contact_class.jsp'");	  
	  fw_menu_3_3.childMenuIcon="<%=approot%>/images/arrows.gif";	  
	  fw_menu_3_3.hideOnMouseOut=true; 	     	  	  	  
	  	  
	  window.fw_menu_3 = new Menu("root",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3.addMenuItem(fw_menu_3_1);  
	  fw_menu_3.addMenuItem(fw_menu_3_2);  
	  fw_menu_3.addMenuItem(fw_menu_3_3);	 
	  fw_menu_3.childMenuIcon="<%=approot%>/images/arrows.gif";
	  fw_menu_3.hideOnMouseOut=true;           
	
	  
	  // system
	  //-----------create sub Menu User Management--------------
	  window.fw_menu_4_1 = new Menu("<%=strSubMenuList[SESS_LANGUAGE][32]%>",82,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_4_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][33]%>", "location='<%=approot%>/admin/userlist.jsp'");
      //fw_menu_4_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][34]%>", "location='<%=approot%>/admin/grouplist.jsp'");
	  //fw_menu_4_1.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][35]%>", "location='<%=approot%>/admin/privilegelist.jsp'");
      fw_menu_4_1.hideOnMouseOut=true;
	  //-----------create sub Menu System--------------
	  window.fw_menu_4_2 = new Menu("<%=strSubMenuList[SESS_LANGUAGE][36]%>",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_4_2.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][37]%>", "location='<%=approot%>/system/sysprop.jsp'");
      fw_menu_4_2.addMenuItem("<%=strSubMenuList[SESS_LANGUAGE][38]%>", "location='<%=approot%>/service/service_center.jsp'");  
      fw_menu_4_2.hideOnMouseOut=true;

	  window.fw_menu_4 = new Menu("root",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_4.addMenuItem(fw_menu_4_1);
	  <%if(pAdd && pUpdate && pDelete){%>
	  fw_menu_4.addMenuItem(fw_menu_4_2);
	  <%}%>
	  fw_menu_4.hideOnMouseOut=true;
	  fw_menu_4.childMenuIcon="<%=approot%>/images/arrows.gif";
	   
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
	hideObjectForMenuJournal(); 
}
	
function cordYMenu1 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_1,cordX,posY); 
	hideObjectForMenuReport(); 	
}	

function cordYMenu2 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_2,cordX,posY); 
	hideObjectForMenuPeriod(); 	
}	
 
function cordYMenu3 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_3,cordX,posY);  
	hideObjectForMenuMasterData(); 	
}	

function cordYMenu4 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 20;
	window.FW_showMenu(window.fw_menu_4,cordX,posY); 
	hideObjectForMenuSystem(); 	
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
<SCRIPT>
function setScr(){
	document.all.M0.value = document.all.divMenu0.offsetLeft + 10;
	document.all.M1.value = document.all.divMenu1.offsetLeft + 10;
	document.all.M2.value = document.all.divMenu2.offsetLeft + 10;
	document.all.M3.value = document.all.divMenu3.offsetLeft + 10;
	document.all.M4.value = document.all.divMenu4.offsetLeft + 10;
}
window.onload = setScr;
window.onresize = setScr;

function showHelp(){   
	window.open("<%=strSubMenuList[SESS_LANGUAGE][39]%>","reportPage","height=600,width=800,status=no,scrollbars=yes,toolbar=no,menubar=yes,location=no");
}	
</SCRIPT>  
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="footer"> 
  <tr> 
	<td nowrap> 
	  <div align="center"> 
	    <A href="<%=approot%>/main/homepage.jsp"" class="topmenu"><%=strMenuList[SESS_LANGUAGE][0]%></A>    
	    | <A id="divMenu0" href="#" onclick="javascript:cordYMenu0(document.all.M0.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strMenuList[SESS_LANGUAGE][1]%></A> 
        | <A id="divMenu1" href="#" onclick="javascript:cordYMenu1(document.all.M1.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strMenuList[SESS_LANGUAGE][2]%></A> 
        | <A id="divMenu2" href="#" onclick="javascript:cordYMenu2(document.all.M2.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strMenuList[SESS_LANGUAGE][3]%></A> 
        | <A id="divMenu3" href="#" onclick="javascript:cordYMenu3(document.all.M3.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strMenuList[SESS_LANGUAGE][4]%></A> 
        | <A id="divMenu4" href="#" onclick="javascript:cordYMenu4(document.all.M4.value);" onmouseout=FW_startTimeout(); class="topmenu"><%=strMenuList[SESS_LANGUAGE][5]%></A> 
        | <A href="#" onclick="javascript:showHelp();" class="topmenu"><%=strMenuList[SESS_LANGUAGE][6]%></A> 
        <%if(userSession!=null){%>
        | <A href="<%=approot%>/logout.jsp" class="topmenu"><%=strMenuList[SESS_LANGUAGE][7]%></A> 
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