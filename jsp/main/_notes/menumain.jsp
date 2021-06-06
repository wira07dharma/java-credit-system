<SCRIPT language=JavaScript>
function fwLoadMenus() {
  if (window.fw_menu_0) return;
  	  // menu journal
	  window.fw_menu_0 = new Menu("root",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_0.addMenuItem("General Ledger", "location='<%=approot%>/journal/journal_search.jsp'");
	  fw_menu_0.hideOnMouseOut=true;
	  
	  //menu report 
	  //-------create sub menu cash flow----------
	  window.fw_menu_1_1 = new Menu("Cash Flow",65,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_1_1.addMenuItem("Period", "location='<%=approot%>'");
      fw_menu_1_1.addMenuItem("Annual", "location='<%=approot%>'");
      fw_menu_1_1.hideOnMouseOut=true;
	  //-------create sub menu others -----------
	  window.fw_menu_1_4 = new Menu("Others",90,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_1_4.addMenuItem("Depretiation", "location='<%=approot%>/report/depretiation.jsp'");
      fw_menu_1_4.addMenuItem("Receivable", "location='<%=approot%>/report/receivable.jsp'");
      fw_menu_1_4.addMenuItem("Payable", "location='<%=approot%>/report/payable.jsp'");	  	  
      fw_menu_1_4.hideOnMouseOut=true;	  
	   
	  window.fw_menu_1 = new Menu("root",180,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_1.addMenuItem("General Ledger", "location='<%=approot%>/report/general_ledger.jsp'");
	  fw_menu_1.addMenuItem("Query Journal", "location='<%=approot%>/report/query_journal.jsp'");
	  fw_menu_1.addMenuItem("Trial Balance", "location='<%=approot%>/report/trial_balance.jsp'");
	  fw_menu_1.addMenuItem("Cash Flow", "location='<%=approot%>/report/cash_flow.jsp'");
	  fw_menu_1.addMenuItem("Gross Profit of Goods Sold", "location='<%=approot%>/report/gross_profit.jsp'");
	  fw_menu_1.addMenuItem("Balance Sheet", "location='<%=approot%>/report/balance_sheet.jsp'");
	  fw_menu_1.addMenuItem("Profit and Loss", "location='<%=approot%>/report/profit_loss.jsp'");   
	  fw_menu_1.childMenuIcon="<%=approot%>/images/arrows.gif"; 
	  fw_menu_1.addMenuItem(fw_menu_1_4);   
	  
	  
	  //period
	  window.fw_menu_2 = new Menu("root",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_2.addMenuItem("Setup Period", "location='<%=approot%>/period/setup_period.jsp'");
	  fw_menu_2.addMenuItem("Close Book", "location='<%=approot%>/period/close_book.jsp'");
	  fw_menu_2.hideOnMouseOut=true;
	  
	  //master data 
	  //-----------create sub Menu Company--------------
	  window.fw_menu_3_2 = new Menu("Company",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_3_2.addMenuItem("Employee", "location='<%=approot%>/masterdata/cmp_employee_lst.jsp'");
      fw_menu_3_2.addMenuItem("Employee Position", "location='<%=approot%>/masterdata/cmp_employeepos_edit.jsp'");
	  fw_menu_3_2.addMenuItem("Contact Class", "location='<%=approot%>/masterdata/cmp_contactclass_edit.jsp'");
      fw_menu_3_2.hideOnMouseOut=true;
	  //-----------create sub Menu Reference Data--------------
	  window.fw_menu_3_3 = new Menu("Reference Data",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_3_3.addMenuItem("Company", "location='<%=approot%>/masterdata/ref_ext_comp_lst.jsp'");
      fw_menu_3_3.addMenuItem("External Person", "location='<%=approot%>/masterdata/ref_ext_personell_lst.jsp'");
      fw_menu_3_3.hideOnMouseOut=true; 
	  
	  window.fw_menu_3 = new Menu("root",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3.addMenuItem("Account Chart", "location='<%=approot%>/masterdata/estimation.jsp'");
	  fw_menu_3.addMenuItem("Setup Link Account", "location='<%=approot%>/masterdata/account_link.jsp'");	  
	  fw_menu_3.addMenuItem(fw_menu_3_2);  
	  fw_menu_3.addMenuItem(fw_menu_3_3);	 
	  fw_menu_3.hideOnMouseOut=true;           
	  fw_menu_3.childMenuIcon="<%=approot%>/images/arrows.gif";
	  
	  // system
	  //-----------create sub Menu User Management--------------
	  window.fw_menu_4_1 = new Menu("User Management",82,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_4_1.addMenuItem("User", "location='<%=approot%>/admin/userlist.jsp'");
      fw_menu_4_1.addMenuItem("Group", "location='<%=approot%>/admin/grouplist.jsp'");
	  fw_menu_4_1.addMenuItem("Privilege", "location='<%=approot%>/admin/privilegelist.jsp'");
      fw_menu_4_1.hideOnMouseOut=true;
	  //-----------create sub Menu System--------------
	  window.fw_menu_4_2 = new Menu("System",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_4_2.addMenuItem("Back Up Service", "location='<%=approot%>/admin/backup.jsp'");
      fw_menu_4_2.addMenuItem("Application Setting", "location='<%=approot%>/system/sysprop.jsp'");
	  fw_menu_4_2.addMenuItem("Object Locking", "location='<%=approot%>/admin/objectlock.jsp'");
      fw_menu_4_2.hideOnMouseOut=true;

	  window.fw_menu_4 = new Menu("root",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_4.addMenuItem(fw_menu_4_1);
	  fw_menu_4.addMenuItem(fw_menu_4_2);
	  fw_menu_4.hideOnMouseOut=true;
	  fw_menu_4.childMenuIcon="<%=approot%>/images/arrows.gif";
	   
	  fw_menu_4.writeMenus();
} // fwLoadMenus()

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
</SCRIPT>
<script language="JavaScript"> 
function cordYMenu0(cordX){		
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	window.FW_showMenu(window.fw_menu_0,cordX,posY);
	hideObjectForMenuJournal(); 
}
	
function cordYMenu1 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	window.FW_showMenu(window.fw_menu_1,cordX,posY); 
	hideObjectForMenuReport(); 	
}	

function cordYMenu2 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	window.FW_showMenu(window.fw_menu_2,cordX,posY); 
	hideObjectForMenuPeriod(); 	
}	
 
function cordYMenu3 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	window.FW_showMenu(window.fw_menu_3,cordX,posY);  
	hideObjectForMenuMasterData(); 	
}	

function cordYMenu4 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	window.FW_showMenu(window.fw_menu_4,cordX,posY); 
	hideObjectForMenuSystem(); 	
}	

</script>
  	  		  

<SCRIPT language=JavaScript src="<%=approot%>/main/fw_menu.js"></SCRIPT>
<SCRIPT language=JavaScript1.2>fwLoadMenus();</SCRIPT>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="footer" >
  <tr>  
    <td> 
      <div align="center"><A href="<%=approot%>/journal/index.jsp" onmouseover="javascript:cordYMenu0(375)"; onmouseout=FW_startTimeout(); class="topmenu">Ledger</A> 
        | <A href="<%=approot%>/report/index.jsp" onmouseover="javascript:cordYMenu1(420)"; onmouseout=FW_startTimeout(); class="topmenu">Report</A> 
        | <A href="<%=approot%>/period/index.jsp" onmouseover="javascript:cordYMenu2(460)"; onmouseout=FW_startTimeout(); class="topmenu">Period</A> 
        | <A href="<%=approot%>/masterdata/index.jsp" onmouseover="javascript:cordYMenu3(500)"; onmouseout=FW_startTimeout(); class="topmenu">Master 
        Data</A> | <A href="<%=approot%>/admin/index.jsp" onmouseover="javascript:cordYMenu4(570)"; onmouseout=FW_startTimeout(); class="topmenu">System</A> 
        <% if(userSession!=null) {%>
        | <A href="<%=approot%>/logout.jsp" class="topmenu">Logout</A> 
        <%}%>
      </div>
    </td> 
  </tr>
</table>
