<%@ page language="java" %>
<%@ include file = "main/javainit.jsp" %>

<html>
<head>
<title>Untitled Document</title>
<script language="JavaScript">
function fwLoadMenus() {
  if (window.fw_menu_0) return;
  	  // menu journal
	  window.fw_menu_0 = new Menu("root",105,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_0.addMenuItem("General Jurnal", "location='<%=approot%>/journal/journal_search.jsp'");
	  fw_menu_0.hideOnMouseOut=true;
	  
	  //menu report
	  //-------create sub menu cash flow----------
	  window.fw_menu_1_1 = new Menu("Cash Flow",82,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_1_1.addMenuItem("Mounthly", "location='<%=approot%>/report/cash_flow.jsp'");
      fw_menu_1_1.addMenuItem("Annualy", "location='<%=approot%>/report/cash_flow.jsp'");
      fw_menu_1_1.hideOnMouseOut=true;
	  //-------create sub menu balance sheet----------
	  window.fw_menu_1_2 = new Menu("Balance Sheet",82,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_1_2.addMenuItem("Mounthly", "location='<%=approot%>/report/cash_flow.jsp'");
      fw_menu_1_2.hideOnMouseOut=true;
	   
	  window.fw_menu_1 = new Menu("root",180,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_1.addMenuItem("General Ledger", "location='<%=approot%>/report/general_ledger.jsp'");
	  fw_menu_1.addMenuItem("Query Journal", "location='<%=approot%>/report/query_journal.jsp'");
	  fw_menu_1.addMenuItem("Trial Balance", "location='<%=approot%>/report/trial_balance.jsp'");
	  fw_menu_1.addMenuItem("Asset Liabilities", "location='<%=approot%>/report/asset_liabilities.jsp'");
	  fw_menu_1.addMenuItem(fw_menu_1_1);
	  fw_menu_1.addMenuItem("Gross Profit of Goods Sold", "location='<%=approot%>/report/gross_profit.jsp'");
	  fw_menu_1.addMenuItem(fw_menu_1_2);
	  fw_menu_1.addMenuItem("Profit and Loss", "location='<%=approot%>/report/profit_loss.jsp'");
	  fw_menu_1.hideOnMouseOut=true;
	  fw_menu_1.childMenuIcon="../images/arrows.gif";
	  
	  
	  //period
	  window.fw_menu_2 = new Menu("root",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_2.addMenuItem("Setup Periode", "location='<%=approot%>/period/setup_period.jsp'");
	  fw_menu_2.addMenuItem("Setup Link Account", "location='<%=approot%>/period/setup_link_account.jsp'");
	  fw_menu_2.addMenuItem("Close Book", "location='<%=approot%>/period/close_book.jsp'");
	  fw_menu_2.hideOnMouseOut=true;
	  
	  //master data
	  //-----------create sub Menu Parameter--------------
	  window.fw_menu_3_1 = new Menu("Parameter",82,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_3_1.addMenuItem("Voucher", "location='<%=approot%>/masterdata/voucher.jsp'");
      fw_menu_3_1.addMenuItem("Setup", "location='<%=approot%>/masterdata/setup.jsp'");
      fw_menu_3_1.hideOnMouseOut=true;
	  //-----------create sub Menu Company--------------
	  window.fw_menu_3_2 = new Menu("Company",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_3_2.addMenuItem("Employee", "location='<%=approot%>/masterdata/voucher.jsp'");
      fw_menu_3_2.addMenuItem("Employee Position", "location='<%=approot%>/masterdata/setup.jsp'");
	  fw_menu_3_2.addMenuItem("Contact Class", "location='<%=approot%>/masterdata/setup.jsp'");
      fw_menu_3_2.hideOnMouseOut=true;
	  //-----------create sub Menu Reference Data--------------
	  window.fw_menu_3_3 = new Menu("Reference Data",130,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
      fw_menu_3_3.addMenuItem("Company", "location='<%=approot%>/masterdata/ref_ext_comp_lst.jsp'");
      fw_menu_3_3.addMenuItem("External Personell", "location='<%=approot%>/masterdata/ref_ext_personell_lst.jsp'");
      fw_menu_3_3.hideOnMouseOut=true;
	  window.fw_menu_3 = new Menu("root",120,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_3.addMenuItem("Account", "location='<%=approot%>/masterdata/estimation.jsp?estimation_type=1'");
	  fw_menu_3.addMenuItem(fw_menu_3_1);
	  fw_menu_3.addMenuItem(fw_menu_3_2);
	  fw_menu_3.addMenuItem(fw_menu_3_3);	 
	  fw_menu_3.hideOnMouseOut=true;
	  fw_menu_3.childMenuIcon="../images/arrows.gif";
	  
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
      fw_menu_4_2.addMenuItem("Application Setting", "location='<%=approot%>/admin/sysprop.jsp'");
	  fw_menu_4_2.addMenuItem("Object Locking", "location='<%=approot%>/admin/objectlock.jsp'");
      fw_menu_4_2.hideOnMouseOut=true;

	  window.fw_menu_4 = new Menu("root",140,17,"Verdana, Arial, Helvetica, sans-serif",10,"#000000","#ffffff","#ffffff","#000084");
	  fw_menu_4.addMenuItem(fw_menu_4_1);
	  fw_menu_4.addMenuItem(fw_menu_4_2);
	  fw_menu_4.hideOnMouseOut=true;
	  fw_menu_4.childMenuIcon="../images/arrows.gif";
	   
	  fw_menu_4.writeMenus();
} // fwLoadMenus()

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
</SCRIPT>
<script language="JavaScript"> 
function cordYMenu0(){		
	//var fwmenu = "fw_menu_";
	//var test = "fw_menu_"+menu; 
	//alert (test);
	var posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	alert(posY);
	window.document.all.FW_showMenu(window.fw_menu_0,50,74); 
}	
function cordYMenu1 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	window.FW_showMenu(window.fw_menu_1,cordX,posY); 
}	

function cordYMenu2 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	window.FW_showMenu(window.fw_menu_2,cordX,posY); 
}	

function cordYMenu3 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	window.FW_showMenu(window.fw_menu_3,cordX,posY); 
}	
function cordYMenu4 (cordX){
	posY = Math.abs(document.all.TOPTITLE.height) + Math.abs(document.all.MAINMENU.height) + 4;
	window.FW_showMenu(window.fw_menu_4,cordX,posY); 
}	

</script>
  	  		  

<SCRIPT language=JavaScript src="fw_menu.js"></SCRIPT>
<SCRIPT language=JavaScript1.2>fwLoadMenus();</SCRIPT>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="topmenu" >
  <tr> 
    <td class="topmenu"> 
      <div align="left" class="topmenu"><img src="<%=approot%>/images/spacer.gif" width="30" height="8">| 
        | <A onmouseover="javascript:cordYMenu2(144)"; 
        	onmouseout=FW_startTimeout();  
			a href="<%=approot%>/period/index.jsp"  class="topmenu">Period</A> 
        | <A onmouseover="javascript:cordYMenu3(185)"; 
        	onmouseout=FW_startTimeout();  			
			a href="<%=approot%>/masterdata/index.jsp"  class="topmenu">Master 
        Data</A> | <A onmouseover="javascript:cordYMenu4(252)"; 
        	onmouseout=FW_startTimeout();  
			a href="<%=approot%>/admin/index.jsp" class="topmenu">System</A> 
        <% if (isLoggedIn) {%>
        | <a href="<%=approot%>/logout.jsp"  class="topmenu">Logout</a> 
        <%}%>
      </div>
    </td> 
  </tr>
</table>
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td ID="TOPTITLE" height="25"> <a  onMouseOver= "javascript:cordYMenu0()";  
        onMouseOut=FW_startTimeout(); 
        href="<%=approot%>/journal/index.jsp" class="topmenu">Journal</a> </td>
    <td height="25"><a onMouseOver="javascript:cordYMenu1(104)"; 
        	onMouseOut=FW_startTimeout();         
			a href="<%=approot%>/report/index.jsp"  class="topmenu">Report</a> 
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</body>
</html>
