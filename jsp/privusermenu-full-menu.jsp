<%@ page import = "java.util.*"%>
<%@ page import = "com.dimata.util.*" %>

<%
String val = request.getParameter("user_group");
Date objDate = new Date();
long lTime = session.getLastAccessedTime();
int groupUser = Integer.parseInt(val);
/**
* pemilihan menu per user group.
* 0 = Admin
* 1 = Accounting Denpasar
* 2 = Accounting Bajo
* 3 = Staf Denpasar
* 4 = Staf Bajo
* 5 = Kasir Denpasar
* 6 = Kasir bajo
* 7 = report only
*/
	%>
	<script type="text/javascript">
	
	</script>
	<script type="text/javascript">
	<!--
	d = new dTree('d');
	
	d.config.target="";//"dtree";		
	d.add(0,-1,'<%=strMenuNames[SESS_LANGUAGE][0]%>',"javascript: d.oAll('true')");
	
	d.add(1,0,'<%=strMenuNames[SESS_LANGUAGE][1]%>',"javascript:setMainFrameUrl('<%=approot%>/homexframe.jsp')");
	
	//------------------------------------------- Menu Invoice --------------------------------------------------
	<% switch(groupUser){
		case 0:%> // admin %>
			d.add(10,0,'<%=strMenuNames[SESS_LANGUAGE][74]%>','javascript: d.o(2)');
			d.add(11,10,'<%=strMenuNames[SESS_LANGUAGE][74]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");				
		<%	break;
		case 1:%> // acc den
			
		<%	break;
		case 2:%>	// acc bajo		
			
		<%	break;
		case 3:	%>// stf den
			d.add(10,0,'<%=strMenuNames[SESS_LANGUAGE][74]%>','javascript: d.o(2)');
			d.add(11,10,'<%=strMenuNames[SESS_LANGUAGE][74]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
		<%	break;
		case 4:%> // staf bajo			
			d.add(10,0,'<%=strMenuNames[SESS_LANGUAGE][74]%>','javascript: d.o(2)');
			d.add(11,10,'<%=strMenuNames[SESS_LANGUAGE][74]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
		<%	break;
		case 5:%>	// kasir den
			d.add(10,0,'<%=strMenuNames[SESS_LANGUAGE][74]%>','javascript: d.o(2)');
			d.add(11,10,'<%=strMenuNames[SESS_LANGUAGE][74]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
		<%	break;
		case 6:%>	// kasir bajo
			d.add(10,0,'<%=strMenuNames[SESS_LANGUAGE][74]%>','javascript: d.o(2)');
			d.add(11,10,'<%=strMenuNames[SESS_LANGUAGE][74]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
	<%		break;
	}%>
	
	//---------------------------------------------------------------- Menu Cash ---------------------------------------------------------
	<% switch(groupUser){
		case 0:%> // admin %>
			d.add(50,0,'<%=strMenuNames[SESS_LANGUAGE][2]%>','javascript: d.o(4)');
			d.add(51,50,'<%=strMenuNames[SESS_LANGUAGE][3]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashreceipts/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
			d.add(52,50,'<%=strMenuNames[SESS_LANGUAGE][5]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycash/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
		<%	break;
		case 1:%> // acc den
			d.add(50,0,'<%=strMenuNames[SESS_LANGUAGE][2]%>','javascript: d.o(4)');
			d.add(51,50,'<%=strMenuNames[SESS_LANGUAGE][3]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashreceipts/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(52,50,'<%=strMenuNames[SESS_LANGUAGE][5]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycash/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
		<%	break;
		case 2:%>	// acc bajo		
			d.add(50,0,'<%=strMenuNames[SESS_LANGUAGE][2]%>','javascript: d.o(4)');
			d.add(51,50,'<%=strMenuNames[SESS_LANGUAGE][3]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashreceipts/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");		
			d.add(52,50,'<%=strMenuNames[SESS_LANGUAGE][5]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycash/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
		<%	break;
		case 3:	%>// stf den
			
		<%	break;
		case 4:%> // staf bajo			
			
		<%	break;
		case 5:%>	// kasir den
			
		<%	break;
		case 6:%>	// kasir bajo
			
	<%		break;
	}%>
	
	//----------------------------------------------------------------- Menu Bank -------------------------------------------------------------
	<% switch(groupUser){
		case 0: %> // admin
			d.add(100,0,'<%=strMenuNames[SESS_LANGUAGE][6]%>','javascript: d.o(7)');
			d.add(101,100,'<%=strMenuNames[SESS_LANGUAGE][7]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdeposite/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(102,100,'<%=strMenuNames[SESS_LANGUAGE][8]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdraw/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(103,100,'<%=strMenuNames[SESS_LANGUAGE][9]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycashreplacement/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(104,100,'<%=strMenuNames[SESS_LANGUAGE][10]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/banktransfer/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			//d.add(65,60,'<%=strMenuNames[SESS_LANGUAGE][4]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashpayment/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(105,100,'<%=strMenuNames[SESS_LANGUAGE][33]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/payment/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
		<%	break;
		case 1:%> // acc den
			d.add(100,0,'<%=strMenuNames[SESS_LANGUAGE][6]%>','javascript: d.o(7)');
			d.add(101,100,'<%=strMenuNames[SESS_LANGUAGE][7]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdeposite/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(102,100,'<%=strMenuNames[SESS_LANGUAGE][8]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdraw/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(103,100,'<%=strMenuNames[SESS_LANGUAGE][9]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycashreplacement/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(104,100,'<%=strMenuNames[SESS_LANGUAGE][10]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/banktransfer/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			//d.add(65,60,'<%=strMenuNames[SESS_LANGUAGE][4]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashpayment/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(105,100,'<%=strMenuNames[SESS_LANGUAGE][33]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/payment/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
		<%	break;
		case 2:%>	// acc bajo		
			d.add(100,0,'<%=strMenuNames[SESS_LANGUAGE][6]%>','javascript: d.o(7)');
			d.add(101,100,'<%=strMenuNames[SESS_LANGUAGE][7]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdeposite/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(102,100,'<%=strMenuNames[SESS_LANGUAGE][8]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdraw/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(103,100,'<%=strMenuNames[SESS_LANGUAGE][9]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycashreplacement/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(104,100,'<%=strMenuNames[SESS_LANGUAGE][10]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/banktransfer/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			//d.add(65,60,'<%=strMenuNames[SESS_LANGUAGE][4]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashpayment/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
			d.add(105,100,'<%=strMenuNames[SESS_LANGUAGE][33]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/payment/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
		<%	break;
		case 3:	%>// stf den
			
		<%	break;
		case 4:%> // staf bajo			
			
		<%	break;
		case 5:%>	// kasir den
			
		<%	break;
		case 6:%>	// kasir bajo
			
	<%		break;
	}%>
	
	//--------------------------------------- AR Module --------------------------------------------------------
	<% switch(groupUser){
		case 0: %> // admin
			d.add(150,0,'<%=strMenuNames[SESS_LANGUAGE][51]%>','javascript: d.o(13)');
			d.add(151,150,'<%=strMenuNames[SESS_LANGUAGE][55]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arap_type=0&menu_type=1')");
			d.add(152,150,'<%=strMenuNames[SESS_LANGUAGE][56]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&payment=1&arap_type=0')");				
		<%	break;
		case 1:%> // acc den
			d.add(150,0,'<%=strMenuNames[SESS_LANGUAGE][51]%>','javascript: d.o(13)');
			d.add(151,150,'<%=strMenuNames[SESS_LANGUAGE][55]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(152,150,'<%=strMenuNames[SESS_LANGUAGE][56]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");				
		<%	break;
		case 2:%>	// acc bajo	
			d.add(150,0,'<%=strMenuNames[SESS_LANGUAGE][51]%>','javascript: d.o(13)');
			d.add(151,150,'<%=strMenuNames[SESS_LANGUAGE][55]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(152,150,'<%=strMenuNames[SESS_LANGUAGE][56]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");					
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//-------------------------------------------------------------- AP Module ----------------------------------------------------
	<% switch(groupUser){
		case 0: %> // admin
			d.add(200,0,'<%=strMenuNames[SESS_LANGUAGE][52]%>','javascript: d.o(16)');
			d.add(201,200,'<%=strMenuNames[SESS_LANGUAGE][55]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arap_type=1&menu_type=1')");
			d.add(202,200,'<%=strMenuNames[SESS_LANGUAGE][56]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&payment=1&arap_type=1')");				
		<%	break;
		case 1:%> // acc den
			d.add(200,0,'<%=strMenuNames[SESS_LANGUAGE][51]%>','javascript: d.o(16)');
			d.add(201,200,'<%=strMenuNames[SESS_LANGUAGE][55]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(202,200,'<%=strMenuNames[SESS_LANGUAGE][56]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");				
		<%	break;
		case 2:%>	// acc bajo
			d.add(200,0,'<%=strMenuNames[SESS_LANGUAGE][51]%>','javascript: d.o(16)');
			d.add(201,200,'<%=strMenuNames[SESS_LANGUAGE][55]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(202,200,'<%=strMenuNames[SESS_LANGUAGE][56]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");						
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//------------------------------------------------------------------ Menu Non Cash ------------------------------------------
	<% switch(groupUser){
		case 0: %> // admin
			d.add(250,0,'<%=strMenuNames[SESS_LANGUAGE][11]%>','javascript: d.o(19)');
			d.add(251,250,'<%=strMenuNames[SESS_LANGUAGE][11]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/noncash/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
		<%	break;
		case 1:%> // acc den
			d.add(250,0,'<%=strMenuNames[SESS_LANGUAGE][11]%>','javascript: d.o(19)');
			d.add(251,250,'<%=strMenuNames[SESS_LANGUAGE][11]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/noncash/journalmain.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
		<%	break;
		case 2:%>	// acc bajo		
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//------------------------------------------------------------------------- Menu General Journal -----------------------------------------
	<% switch(groupUser){
		case 0: %>// admin 
			d.add(300,0,'<%=strMenuNames[SESS_LANGUAGE][12]%>','javascript: d.o(21)');
			d.add(301,300,'<%=strMenuNames[SESS_LANGUAGE][12]%>',"javascript:setMainFrameUrl('<%=approot%>/journal/jumum.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");			
		<%	break;
		case 1:%> // acc den			
		<%	break;
		case 2:%>	// acc bajo					
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//---------------------------------------------------------- Aktiva Tetap --------------------------------------------------
	<% switch(groupUser){
		case 0: %> // admin
			d.add(350,0,'<%=strMenuNames[SESS_LANGUAGE][53]%>','javascript: d.o(23)');
			d.add(351,350,'<%=strMenuNames[SESS_LANGUAGE][57]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/order_aktiva_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(352,350,'<%=strMenuNames[SESS_LANGUAGE][58]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/receive_aktiva_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
			d.add(353,350,'<%=strMenuNames[SESS_LANGUAGE][59]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/selling_aktiva_edit.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
			d.add(354,350,'<%=strMenuNames[SESS_LANGUAGE][60]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/penyusutan_aktiva.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");				
		<%	break;
		case 1:%> // acc den
		<%	break;
		case 2:%>	// acc bajo		
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//----------------------------------------------------------- Approved Ticket --------------------------------------------------
	<% switch(groupUser){
		case 0:%> // admin %>
			d.add(400,0,'<%=strMenuNames[SESS_LANGUAGE][75]%>','javascript: d.o(28)');
			d.add(401,400,'<%=strMenuNames[SESS_LANGUAGE][75]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=1')");				
		<%	break;
		case 1:%> // acc den
			
		<%	break;
		case 2:%>	// acc bajo		
			
		<%	break;
		case 3:	%>// stf den
			
		<%	break;
		case 4:%> // staf bajo	
			d.add(400,0,'<%=strMenuNames[SESS_LANGUAGE][75]%>','javascript: d.o(4)');
			d.add(401,400,'<%=strMenuNames[SESS_LANGUAGE][75]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=1')");	
		<%	break;
		case 5:%>	// kasir den
			/*d.add(400,0,'<%=strMenuNames[SESS_LANGUAGE][75]%>','javascript: d.o(4)');
			d.add(401,400,'<%=strMenuNames[SESS_LANGUAGE][75]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=1')");*/
		<%	break;
		case 6:%>	// kasir bajo
			/*d.add(400,0,'<%=strMenuNames[SESS_LANGUAGE][75]%>','javascript: d.o(4)');
			d.add(401,400,'<%=strMenuNames[SESS_LANGUAGE][75]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=1')");*/
	<%		break;
	}%>
	
	//----------------------------------------------------------- Approved Package --------------------------------------------------
	<% switch(groupUser){
		case 0:%> // admin %>
			d.add(425,0,'<%=strMenuNames[SESS_LANGUAGE][79]%>','javascript: d.o(30)');
			d.add(426,425,'<%=strMenuNames[SESS_LANGUAGE][79]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=4')");				
		<%	break;
		case 1:%> // acc den
			
		<%	break;
		case 2:%>	// acc bajo		
			
		<%	break;
		case 3:	%>// stf den 
			d.add(425,0,'<%=strMenuNames[SESS_LANGUAGE][79]%>','javascript: d.o(4)');
			d.add(426,425,'<%=strMenuNames[SESS_LANGUAGE][79]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=4')");
		<%	break;
		case 4:%> // staf bajo	
			
		<%	break;
		case 5:%>	// kasir den
			/*d.add(400,0,'<%=strMenuNames[SESS_LANGUAGE][75]%>','javascript: d.o(4)');
			d.add(401,400,'<%=strMenuNames[SESS_LANGUAGE][75]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=1')");*/
		<%	break;
		case 6:%>	// kasir bajo
			/*d.add(400,0,'<%=strMenuNames[SESS_LANGUAGE][75]%>','javascript: d.o(4)');
			d.add(401,400,'<%=strMenuNames[SESS_LANGUAGE][75]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=1')");*/
	<%		break;
	}%>
	
	//-------------------------------------------------------------------------- Posting Data ------------------------------------------------------------
	<% switch(groupUser){
		case 0:%> // admin %>
			d.add(450,0,'<%=strMenuNames[SESS_LANGUAGE][76]%>','javascript: d.o(32)');
			d.add(451,450,'<%=strMenuNames[SESS_LANGUAGE][76]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/post_invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=2')");
			d.add(452,450,'<%=strMenuNames[SESS_LANGUAGE][84]+" "+strMenuNames[SESS_LANGUAGE][74]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/update_invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=6')");
			d.add(453,450,'<%=strMenuNames[SESS_LANGUAGE][85]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/crosscheck_invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=7')");
		<%	break;
		case 1:%> // acc den
			
		<%	break;
		case 2:%>	// acc bajo		
			
		<%	break;
		case 3:	%>// stf den
			
		<%	break;
		case 4:%> // staf bajo		
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//------------------------------------------------------------------------ Void Invoice ---------------------------------------------
	<% switch(groupUser){
		case 0:%> // admin %>
			d.add(500,0,'<%=strMenuNames[SESS_LANGUAGE][78]%>','javascript: d.o(36)');
			d.add(501,500,'<%=strMenuNames[SESS_LANGUAGE][78]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/void_invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=3')");				
		<%	break;
		case 1:%> // acc den
		<%	break;
		case 2:%>	// acc bajo		
			
		<%	break;
		case 3:	%>// stf den
			
		<%	break;
		case 4:%> // staf bajo		
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//---------------------------------------------------------- AR/AP Inquiries --------------------------------------------------
	<% switch(groupUser){
		case 0: %> // admin
			d.add(550,0,'<%=strMenuNames[SESS_LANGUAGE][68]%>','javascript: d.o(38)');
			d.add(551,550,'<%=strMenuNames[SESS_LANGUAGE][51]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arapType=0&menu_type=0&arapEdit=1')");
			d.add(552,550,'<%=strMenuNames[SESS_LANGUAGE][52]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arapType=1&menu_type=0&arapEdit=1')");	
		<%	break;
		case 1:%> // acc den
			d.add(550,0,'<%=strMenuNames[SESS_LANGUAGE][68]%>','javascript: d.o(21)');
			d.add(551,550,'<%=strMenuNames[SESS_LANGUAGE][51]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arapType=0&menu_type=0&arapEdit=1')");
			d.add(552,550,'<%=strMenuNames[SESS_LANGUAGE][52]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arapType=1&menu_type=0&arapEdit=1')");	
		<%	break;
		case 2:%>	// acc bajo	
			d.add(550,0,'<%=strMenuNames[SESS_LANGUAGE][68]%>','javascript: d.o(19)');
			d.add(551,550,'<%=strMenuNames[SESS_LANGUAGE][51]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arapType=0&menu_type=0&arapEdit=1')");
			d.add(552,550,'<%=strMenuNames[SESS_LANGUAGE][52]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arapType=1&menu_type=0&arapEdit=1')");		
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//---------------------------------------------------------- Fixed Assets Inquiries --------------------------------------------------
	<% switch(groupUser){
		case 0: %> // admin
			d.add(600,0,'<%=strMenuNames[SESS_LANGUAGE][69]%>','javascript: d.o(41)');
			d.add(601,600,'<%=strMenuNames[SESS_LANGUAGE][57]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/order_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(602,600,'<%=strMenuNames[SESS_LANGUAGE][58]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/receive_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
			d.add(603,600,'<%=strMenuNames[SESS_LANGUAGE][59]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/selling_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(604,600,'<%=strMenuNames[SESS_LANGUAGE][53]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/modul_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&fa_type=1')");		
		<%	break;
		case 1:%> // acc den
			d.add(600,0,'<%=strMenuNames[SESS_LANGUAGE][69]%>','javascript: d.o(24)');
			d.add(601,600,'<%=strMenuNames[SESS_LANGUAGE][57]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/order_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(602,600,'<%=strMenuNames[SESS_LANGUAGE][58]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/receive_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
			d.add(603,600,'<%=strMenuNames[SESS_LANGUAGE][59]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/selling_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(604,600,'<%=strMenuNames[SESS_LANGUAGE][53]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/modul_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");		
		<%	break;
		case 2:%>	// acc bajo		
			d.add(600,0,'<%=strMenuNames[SESS_LANGUAGE][69]%>','javascript: d.o(22)');
			d.add(601,600,'<%=strMenuNames[SESS_LANGUAGE][57]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/order_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(602,600,'<%=strMenuNames[SESS_LANGUAGE][58]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/receive_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");	
			d.add(603,600,'<%=strMenuNames[SESS_LANGUAGE][59]%>',"javascript:setMainFrameUrl('<%=approot%>/aktiva/selling_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(604,600,'<%=strMenuNames[SESS_LANGUAGE][53]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/modul_aktiva_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");		
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//--------------------------------------------------------------------------------- Journal Search ----------------------------------------------------------------
	<% switch(groupUser){
		case 0: %>// admin 
			d.add(650,0,'<%=strMenuNames[SESS_LANGUAGE][44]%>','javascript: d.o(46)');
			d.add(651,650,'<%=strMenuNames[SESS_LANGUAGE][3]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashreceipts/journalsearch.jsp')");
			d.add(652,650,'<%=strMenuNames[SESS_LANGUAGE][5]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycash/journalsearch.jsp')");
			d.add(653,650,'<%=strMenuNames[SESS_LANGUAGE][7]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdeposite/journalsearch.jsp')");
			d.add(654,650,'<%=strMenuNames[SESS_LANGUAGE][8]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdraw/journalsearch.jsp')");
			d.add(655,650,'<%=strMenuNames[SESS_LANGUAGE][9]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycashreplacement/journalsearch.jsp')");
			d.add(656,650,'<%=strMenuNames[SESS_LANGUAGE][10]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/banktransfer/journalsearch.jsp')");
			//d.add(207,200,'<%=strMenuNames[SESS_LANGUAGE][4]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashpayment/journalsearch.jsp')");
			d.add(657,650,'<%=strMenuNames[SESS_LANGUAGE][33]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/payment/journalsearch.jsp')");
			d.add(658,650,'<%=strMenuNames[SESS_LANGUAGE][11]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/noncash/journalsearch.jsp')");
			d.add(659,650,'<%=strMenuNames[SESS_LANGUAGE][12]%>',"javascript:setMainFrameUrl('<%=approot%>/journal/journals.jsp?edit_journal=1')");
		<%	break;
		case 1:%> // acc den
			
		<%	break;
		case 2:%>	// acc bajo		
			
		<%	break;
		case 3:	%>// stf den
		
		<%	break;	
		case 4:%> // staf bajo	
		
		<%	break;	
		case 5:%>	// kasir den
			
		<%	break;
		case 6:%>	// kasir bajo
			
	<%		break;
	}%>
	
	//--------------------------------------------------------------------- Financial Report ----------------------------------------
	<% switch(groupUser){
		case 0: %>// admin 
			d.add(700,0,'<%=strMenuNames[SESS_LANGUAGE][13]%>','javascript: d.o(56)');			
			d.add(701,700,'<%=strMenuNames[SESS_LANGUAGE][42]%>',"javascript:setMainFrameUrl('<%=approot%>/report/BS_summary.jsp')");			
			d.add(702,700,'<%=strMenuNames[SESS_LANGUAGE][16]%>',"javascript:setMainFrameUrl('<%=approot%>/report/balance_sheet_dept.jsp')");
			d.add(703,700,'<%=strMenuNames[SESS_LANGUAGE][14]%>',"javascript:setMainFrameUrl('<%=approot%>/report/cash_flow_dept.jsp')");
			d.add(704,700,'<%=strMenuNames[SESS_LANGUAGE][36]%>',"javascript:setMainFrameUrl('<%=approot%>/report/dep_cost.jsp')");
			d.add(705,700,'<%=strMenuNames[SESS_LANGUAGE][17]%>',"javascript:setMainFrameUrl('<%=approot%>/report/general_ledger_dept.jsp')");
			d.add(706,700,'<%=strMenuNames[SESS_LANGUAGE][15]%>',"javascript:setMainFrameUrl('<%=approot%>/report/P_and_L.jsp')");
			d.add(707,700,'<%=strMenuNames[SESS_LANGUAGE][37]%>',"javascript:setMainFrameUrl('<%=approot%>/report/PL_YTD_Var.jsp')");
			d.add(708,700,'<%=strMenuNames[SESS_LANGUAGE][38]%>',"javascript:setMainFrameUrl('<%=approot%>/report/PL_YTD.jsp')");
			d.add(709,700,'<%=strMenuNames[SESS_LANGUAGE][39]%>',"javascript:setMainFrameUrl('<%=approot%>/report/PL_summary_MTDYTD.jsp')");
			d.add(710,700,'<%=strMenuNames[SESS_LANGUAGE][40]%>',"javascript:setMainFrameUrl('<%=approot%>/report/PL_summary_YTD.jsp')");
			d.add(711,700,'<%=strMenuNames[SESS_LANGUAGE][41]%>',"javascript:setMainFrameUrl('<%=approot%>/report/PL_summary.jsp')");
			d.add(712,700,'<%=strMenuNames[SESS_LANGUAGE][18]%>',"javascript:setMainFrameUrl('<%=approot%>/report/trial_balance_dept.jsp')");
			d.add(713,700,'<%=strMenuNames[SESS_LANGUAGE][19]%>',"javascript:setMainFrameUrl('<%=approot%>/report/worksheet_dept.jsp')");	
			/*d.add(520,0,'<%=strMenuNames[SESS_LANGUAGE][34]%>','javascript: d.o(64)');
			d.add(521,520,'<%=strMenuNames[SESS_LANGUAGE][34]%>',"javascript:setMainFrameUrl('<%=approot%>/report/donor/donor_report.jsp')");
			d.add(522,520,'<%=strMenuNames[SESS_LANGUAGE][35]%>',"javascript:setMainFrameUrl('<%=approot%>/report/donor/donor_rpt_consolidated.jsp')");*/
		<%	break;
		case 1:%> // acc den
			
		<%	break;
		case 2:%>	// acc bajo		
			
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	//---------------------------------------------------------- Financial Analysis -------------------------------------------------
	<% switch(groupUser){
		case 0: %>// admin 
			d.add(730,0,'<%=strMenuNames[SESS_LANGUAGE][86]%>','javascript: d.o(70)');			
			d.add(731,730,'<%=strMenuNames[SESS_LANGUAGE][87]%>',"javascript:setMainFrameUrl('<%=approot%>/chart/PieChartTest.jsp')");
		<%	break;
		case 1:%> // acc den
			
		<%	break;
		case 2:%>	// acc bajo		
			
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	//---------------------------------------------------------- Bisnis Report -------------------------------------------------
	
	<% switch(groupUser){
		case 0: %> // admin
			d.add(750,0,'<%=strMenuNames[SESS_LANGUAGE][77]%>','javascript: d.o(72)');
			d.add(751,750,'<%=strMenuNames[SESS_LANGUAGE][80]%>',"javascript:setMainFrameUrl('<%=approot%>/report/lap_kegiatan_usaha.jsp?get_time_menu=<%=session.getLastAccessedTime()%>')");
			d.add(752,750,'<%=strMenuNames[SESS_LANGUAGE][81]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=5')");
			d.add(753,750,'<%=strMenuNames[SESS_LANGUAGE][82]%>',"javascript:setMainFrameUrl('<%=approot%>/report/lap_kegiatan_usaha.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=6')");
			d.add(754,750,'<%=strMenuNames[SESS_LANGUAGE][94]%>',"javascript:setMainFrameUrl('<%=approot%>/report/invoice/reservation_pack_list.jsp?get_time_menu=<%=session.getLastAccessedTime()%>')");
			d.add(755,750,'<%=strMenuNames[SESS_LANGUAGE][95]%>',"javascript:setMainFrameUrl('<%=approot%>/report/invoice/sales_ticket_list.jsp?get_time_menu=<%=session.getLastAccessedTime()%>')");
		<%	break;
		case 1:%> // acc den
		
		<%	break;	
		case 2:%>	// acc bajo		
		
		<%	break;
		case 3:	%>// stf den
			d.add(750,0,'<%=strMenuNames[SESS_LANGUAGE][77]%>','javascript: d.o(6)');
			d.add(751,750,'<%=strMenuNames[SESS_LANGUAGE][81]%>',"javascript:setMainFrameUrl('<%=approot%>/invoice/invoice_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=5')");
			d.add(752,750,'<%=strMenuNames[SESS_LANGUAGE][82]%>',"javascript:setMainFrameUrl('<%=approot%>/report/lap_kegiatan_usaha.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>&query_type=6')");
		<%	break;
		case 4:%> // staf bajo	
			d.add(750,0,'<%=strMenuNames[SESS_LANGUAGE][77]%>','javascript: d.o(6)');
			d.add(751,750,'<%=strMenuNames[SESS_LANGUAGE][80]%>',"javascript:setMainFrameUrl('<%=approot%>/report/lap_kegiatan_usaha.jsp?get_time_menu=<%=session.getLastAccessedTime()%>')");		
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//---------------------------------------------------------- AR/AP Report  --------------------------------------------------
	<% switch(groupUser){
		case 0: %> // admin
			d.add(800,0,'<%=strMenuNames[SESS_LANGUAGE][70]%>','javascript: d.o(78)');
			d.add(801,800,'<%=strMenuNames[SESS_LANGUAGE][71]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&payment=0')");
			d.add(802,800,'<%=strMenuNames[SESS_LANGUAGE][72]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arap_type=0')");
			d.add(803,800,'<%=strMenuNames[SESS_LANGUAGE][73]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arap_type=1')");	
		<%	break;
		case 1:%> // acc den
			d.add(800,0,'<%=strMenuNames[SESS_LANGUAGE][70]%>','javascript: d.o(29)');
			d.add(801,800,'<%=strMenuNames[SESS_LANGUAGE][71]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&payment=0')");
			d.add(802,800,'<%=strMenuNames[SESS_LANGUAGE][72]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arap_type=0')");
			d.add(803,800,'<%=strMenuNames[SESS_LANGUAGE][73]%>',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&arap_type=1')");	
		<%	break;
		case 2:%>	// acc bajo		
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//---------------------------------------------------------- Fixed Assets Report  --------------------------------------------------
	<% switch(groupUser){
		case 0: %> // admin
			d.add(850,0,'<%=strMenuNames[SESS_LANGUAGE][54]%>','javascript: d.o(82)');
			d.add(851,850,'<%=strMenuNames[SESS_LANGUAGE][61]%>',"javascript:setMainFrameUrl('<%=approot%>/report/aktiva/labarugi_aktiva.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(852,850,'<%=strMenuNames[SESS_LANGUAGE][62]%>',"javascript:setMainFrameUrl('<%=approot%>/report/aktiva/aktiva_dan_penyusutannya.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
		<%	break;
		case 1:%> // acc den
			d.add(850,0,'<%=strMenuNames[SESS_LANGUAGE][54]%>','javascript: d.o(33)');
			d.add(851,850,'<%=strMenuNames[SESS_LANGUAGE][61]%>',"javascript:setMainFrameUrl('<%=approot%>/report/aktiva/labarugi_aktiva.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(852,850,'<%=strMenuNames[SESS_LANGUAGE][62]%>',"javascript:setMainFrameUrl('<%=approot%>/report/aktiva/aktiva_dan_penyusutannya.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
		<%	break;
		case 2:%>	// acc bajo		
			d.add(850,0,'<%=strMenuNames[SESS_LANGUAGE][54]%>','javascript: d.o(27)');
			d.add(851,850,'<%=strMenuNames[SESS_LANGUAGE][61]%>',"javascript:setMainFrameUrl('<%=approot%>/report/aktiva/labarugi_aktiva.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
			d.add(852,850,'<%=strMenuNames[SESS_LANGUAGE][62]%>',"javascript:setMainFrameUrl('<%=approot%>/report/aktiva/aktiva_dan_penyusutannya.jsp?get_time_menu=<%=session.getLastAccessedTime()%>&command=<%=Command.ADD%>')");
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	//--------------------------------------------------------------------- Setup periode -------------------------------------------
	<% switch(groupUser){
		case 0: %>// admin 
			d.add(900,0,'<%=strMenuNames[SESS_LANGUAGE][20]%>','javascript: d.o(85)');
			d.add(901,900,'<%=strMenuNames[SESS_LANGUAGE][21]%>',"javascript:setMainFrameUrl('<%=approot%>/period/setup_period.jsp')");
			d.add(902,900,'<%=strMenuNames[SESS_LANGUAGE][22]%>',"javascript:setMainFrameUrl('<%=approot%>/period/close_book.jsp')");
		<%	break;
		case 1:%> // acc den
			
		<%	break;
		case 2:%>	// acc bajo		
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>
	
	/*<% switch(groupUser){
		case 0: %>// admin 
			d.add(700,0,'<%=strMenuNames[SESS_LANGUAGE][23]%>','javascript: d.o(86)');
			d.add(701,700,'<%=strMenuNames[SESS_LANGUAGE][21]%>',"javascript:setMainFrameUrl('<%=approot%>/period/setup_activity_period.jsp')");
			d.add(702,700,'<%=strMenuNames[SESS_LANGUAGE][22]%>',"javascript:setMainFrameUrl('<%=approot%>/period/close_activity_period.jsp')");
		<%	break;
		case 1:%> // acc den
			d.add(700,0,'<%=strMenuNames[SESS_LANGUAGE][23]%>','javascript: d.o(67)');
			d.add(701,700,'<%=strMenuNames[SESS_LANGUAGE][21]%>',"javascript:setMainFrameUrl('<%=approot%>/period/setup_activity_period.jsp')");
			d.add(702,700,'<%=strMenuNames[SESS_LANGUAGE][22]%>',"javascript:setMainFrameUrl('<%=approot%>/period/close_activity_period.jsp')");
		<%	break;
		case 2:%>	// acc bajo		
		<%	break;
		case 3:	%>// stf den
		<%	break;
		case 4:%> // staf bajo			
		<%	break;
		case 5:%>	// kasir den
		<%	break;
		case 6:%>	// kasir bajo
	<%		break;
	}%>*/
	
	<% switch(groupUser){
		case 0: %>// admin 
			d.add(950,0,'<%=strMenuNames[SESS_LANGUAGE][24]%>','javascript: d.o(88)');
			d.add(951,950,'<%=strMenuNames[SESS_LANGUAGE][25]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/account_chart.jsp')");
			d.add(952,950,'<%=strMenuNames[SESS_LANGUAGE][26]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/account_link.jsp')");
			d.add(953,950,'<%=strMenuNames[SESS_LANGUAGE][27]%>',"javascript:setMainFrameUrl('<%=approot%>/common/payment/currencytype.jsp')");
			d.add(954,950,'<%=strMenuNames[SESS_LANGUAGE][28]%>',"javascript:setMainFrameUrl('<%=approot%>/common/payment/standartrate.jsp')");
			/*d.add(805,800,'<%=strMenuNames[SESS_LANGUAGE][29]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/donorcomp/donor_component.jsp')");
			d.add(806,800,'<%=strMenuNames[SESS_LANGUAGE][30]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/activity/activity.jsp')");*/
			//d.add(807,800,'<%=strMenuNames[SESS_LANGUAGE][43]%>',"javascript:setMainFrameUrl('<%=approot%>/upload_excel/import_src.jsp')");
			d.add(955,950,'<%=strMenuNames[SESS_LANGUAGE][46]%>',"javascript:setMainFrameUrl('<%=approot%>/admin/userlist.jsp')");
			d.add(956,950,'<%=strMenuNames[SESS_LANGUAGE][47]%>',"javascript:setMainFrameUrl('<%=approot%>/admin/grouplist.jsp')");
			d.add(957,950,'<%=strMenuNames[SESS_LANGUAGE][48]%>',"javascript:setMainFrameUrl('<%=approot%>/admin/privilegelist.jsp')");
			d.add(958,950,'<%=strMenuNames[SESS_LANGUAGE][49]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/contact/srccontact_list.jsp')");
			d.add(959,950,'<%=strMenuNames[SESS_LANGUAGE][50]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/contact/contact_class.jsp')");
			d.add(960,950,'<%=strMenuNames[SESS_LANGUAGE][63]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/jenisaktiva.jsp')");
			d.add(961,950,'<%=strMenuNames[SESS_LANGUAGE][64]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/typepenyusutan.jsp')");
			d.add(962,950,'<%=strMenuNames[SESS_LANGUAGE][65]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/metodepenyusutan.jsp')");
			d.add(963,950,'<%=strMenuNames[SESS_LANGUAGE][66]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/aktiva_group.jsp')");
			d.add(964,950,'<%=strMenuNames[SESS_LANGUAGE][67]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/modul_aktiva_edit.jsp')");
			d.add(965,950,'<%=strMenuNames[SESS_LANGUAGE][83]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/aktiva_location.jsp')");	
			d.add(966,950,'<%=strMenuNames[SESS_LANGUAGE][88]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/ticket/ticket_master_carrier.jsp')");
			d.add(967,950,'<%=strMenuNames[SESS_LANGUAGE][89]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/ticket/ticket_master_route.jsp')");	
			d.add(968,950,'<%=strMenuNames[SESS_LANGUAGE][90]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/ticket/ticket_master_class.jsp')");	
			d.add(969,950,'<%=strMenuNames[SESS_LANGUAGE][91]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/ticket/ticket_rate.jsp')");
			d.add(970,950,'<%=strMenuNames[SESS_LANGUAGE][93]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/ticket/ticket_deposit.jsp')");
			d.add(971,950,'<%=strMenuNames[SESS_LANGUAGE][92]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/ticket/ticket_list.jsp')");		
			d.add(1000,0,'<%=strMenuNames[SESS_LANGUAGE][31]%>',"javascript:setMainFrameUrl('<%=approot%>/manual/aiso_manual_ina.html')");
		<%	break;
		case 1:%> // acc den
			d.add(950,0,'<%=strMenuNames[SESS_LANGUAGE][24]%>','javascript: d.o(36)');
			d.add(951,950,'<%=strMenuNames[SESS_LANGUAGE][25]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/account_chart.jsp')");
			d.add(952,950,'<%=strMenuNames[SESS_LANGUAGE][26]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/account_link.jsp')");
			d.add(953,950,'<%=strMenuNames[SESS_LANGUAGE][27]%>',"javascript:setMainFrameUrl('<%=approot%>/common/payment/currencytype.jsp')");
			d.add(954,950,'<%=strMenuNames[SESS_LANGUAGE][28]%>',"javascript:setMainFrameUrl('<%=approot%>/common/payment/standartrate.jsp')");
			d.add(955,950,'<%=strMenuNames[SESS_LANGUAGE][43]%>',"javascript:setMainFrameUrl('<%=approot%>/upload_excel/import_src.jsp')");
			d.add(956,950,'<%=strMenuNames[SESS_LANGUAGE][49]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/contact/srccontact_list.jsp')");
			d.add(957,950,'<%=strMenuNames[SESS_LANGUAGE][50]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/contact/contact_class.jsp')");
			d.add(958,950,'<%=strMenuNames[SESS_LANGUAGE][63]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/jenisaktiva.jsp')");
			d.add(959,950,'<%=strMenuNames[SESS_LANGUAGE][64]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/typepenyusutan.jsp')");
			d.add(960,950,'<%=strMenuNames[SESS_LANGUAGE][65]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/metodepenyusutan.jsp')");
			d.add(961,950,'<%=strMenuNames[SESS_LANGUAGE][66]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/aktiva_group.jsp')");
			d.add(962,950,'<%=strMenuNames[SESS_LANGUAGE][67]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/modul_aktiva_edit.jsp')");
			d.add(963,950,'<%=strMenuNames[SESS_LANGUAGE][83]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/aktiva_location.jsp')");
			/*d.add(805,800,'<%=strMenuNames[SESS_LANGUAGE][29]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/donorcomp/donor_component.jsp')");
			d.add(806,800,'<%=strMenuNames[SESS_LANGUAGE][30]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/activity/activity.jsp')");*/			
			d.add(1000,0,'<%=strMenuNames[SESS_LANGUAGE][31]%>',"javascript:setMainFrameUrl('<%=approot%>/manual/aiso_manual_english.htm')");
		<%	break;
		case 2:%>	// acc bajo		
			d.add(1000,0,'<%=strMenuNames[SESS_LANGUAGE][31]%>',"javascript:setMainFrameUrl('<%=approot%>/manual/aiso_manual_english.htm')");
		<%	break;
		case 3:	%>// stf den
			d.add(1000,0,'<%=strMenuNames[SESS_LANGUAGE][31]%>',"javascript:setMainFrameUrl('<%=approot%>/manual/aiso_manual_english.htm')");
		<%	break;
		case 4:%> // staf bajo			
			d.add(1000,0,'<%=strMenuNames[SESS_LANGUAGE][31]%>',"javascript:setMainFrameUrl('<%=approot%>/manual/aiso_manual_english.htm')");
		<%	break;
		case 5:%>	// kasir den
			d.add(1000,0,'<%=strMenuNames[SESS_LANGUAGE][31]%>',"javascript:setMainFrameUrl('<%=approot%>/manual/aiso_manual_english.htm')");
		<%	break;
		case 6:%>	// kasir bajo
			d.add(1000,0,'<%=strMenuNames[SESS_LANGUAGE][31]%>',"javascript:setMainFrameUrl('<%=approot%>/manual/aiso_manual_english.htm')");
	<%		break;
	}%>
	d.add(1050,0,'<%=strMenuNames[SESS_LANGUAGE][32]%>',"javascript:logOut('<%=approot%>/logout.jsp')");
	document.write(d);
	d.closeAll();

//-->
</script>
