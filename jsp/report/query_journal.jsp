<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<%@ page import="com.dimata.util.*" %> 
<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.form.periode.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>
<!--import common-->
<%@ page import="com.dimata.common.entity.contact.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_QUERY_JOURNAL, AppObjInfo.OBJ_REPORT_QUERY_JOURNAL_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 
if(!privView && !privSubmit){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<%!
public static String strTitle[][] = {
	{"Tanggal Transaksi","Periode Ini (",")","Berdasar Tanggal, Dari ","Sampai","No Voucher","No Bill","Nama Kontak","Operator",
	"Tipe Pembukuan","Urut Berdasar","Anda tidak punya hak akses untuk laporan daftar jurnal !!!"},	
	
	{"Transaction Date","Current Period (",")","Base On Date, From ","To","Voucher No","Bill No","Contact Name","Operator",
	"Book Type","Sort By","You haven't privilege for accessing query journal report !!!"}
};

public static final String masterTitle[] = {
	"Laporan","Report"	
};

public static final String listTitle[] = {
	"Daftar Jurnal","Query Journal"	
};
%>

<!-- JSP Block -->
<%
String YR = "_yr";
String MN = "_mn";
String DY = "_dy";
String MM = "_mm";
String HH = "_hh";
String orderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
Vector listPeriod = PstPeriode.list(0,0,"",orderBy);
Date firstPeriodDate = new Date();
if(listPeriod!=null && listPeriod.size()>0){
	Periode per = (Periode)listPeriod.get(0);
	firstPeriodDate = per.getTglAwal();
}
Date nowDate = new Date();
int interval = firstPeriodDate.getYear() - nowDate.getYear();   

/**
* Declare Commands caption
*/
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">

	function report(){ 
		//var startYear  = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE]+YR%>.value;								
		//var startMonth = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE]+MN%>.value;
		//var startDate  = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE]+DY%>.value;
		var dueYear    = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE]+YR%>.value;				
		var dueMonth   = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE]+MN%>.value;				
		var dueDate    = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE]+DY%>.value;		
		var voucherNo  = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_VOUCHER]%>.value;		
		var invoiceNo  = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_INVOICE_NO]%>.value;
		var cntName    = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_CONTACT]%>.value;		
		var operator   = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_OPERATOR_ID]%>.value;
		var currency   = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_CURRENCY]%>.value;		
		
		var dateType   = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>.value;										
		if(document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>[0].checked)
			dateType = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>[0].value;								
		else if(document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>[1].checked)
			dateType = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>[1].value;								
		else if(document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>[2].checked)
			dateType = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>[2].value;								
		else
			dateType = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>[3].value;								

		var orderBy = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>.value;
		if(document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>[0].checked)
			orderBy = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>[0].value;								
		else if(document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>[1].checked)
			orderBy = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>[1].value;								
		else if(document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>[2].checked)
			orderBy = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>[2].value;								
		else if(document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>[3].checked)
			orderBy = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>[3].value;											
		else
			orderBy = document.frmQuery.<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>[4].value; 								
		var linkPage   = "query_journal_buffer.jsp?" + 		
						 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>=" + dateType + "&";
						 if(dateType==2){						 		
							 linkPage = linkPage + "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE]+YR%>=" + startYear + "&" +
							 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE]+MN%>=" + startMonth + "&" +						 
							 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE]+DY%>=" + startDate + "&" + 
							 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE]+YR%>=" + dueYear + "&" + 
							 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE]+MN%>=" + dueMonth + "&" + 						 
							 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE]+DY%>=" + dueDate + "&"; 
						 }
						 linkPage = linkPage + "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_VOUCHER]%>=" + voucherNo + "&" + 
						 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_INVOICE_NO]%>=" + invoiceNo + "&" +  		
						 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_CONTACT]%>=" + cntName + "&" +  		
						 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_OPERATOR_ID]%>=" + operator + "&" +  								 						
						 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_CURRENCY]%>=" + currency + "&" +  								 						 						  
						 "<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>=" + orderBy;  								 
		//window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no");  			
		window.open(linkPage,"reportPage");  					
	}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
function hideObjectForMenuJournal(){ 
}
	
function hideObjectForMenuReport(){
    <%if(privView && privSubmit){%>						  			  
	document.all.DUE_yr.style.visibility = "hidden";
	document.all.DUE_mn.style.visibility = "hidden";
	document.all.DUE_dy.style.visibility = "hidden";	 
	<%}%>
}
	
function hideObjectForMenuPeriod(){
}
	
function hideObjectForMenuMasterData(){
}

function hideObjectForMenuSystem(){
}

function showObjectForMenu(){
    <%if(privView && privSubmit){%>						  			  
	document.all.DUE_yr.style.visibility = "";
	document.all.DUE_mn.style.visibility = "";	 
	document.all.DUE_dy.style.visibility = "";	 		
	<%}%>
}
</SCRIPT>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head> 

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE"> 
      <%@ include file = "../main/header.jsp" %> 
    </td>
  </tr>
  <tr> 
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
      <%@ include file = "../main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%>&nbsp;&gt;&nbsp;<%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmQuery" method="post" action="">
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr> 
                  <td colspan="2"> 
                    <hr>
                  </td>
                </tr>
			  </table>	
			  <%if(privView && privSubmit){%>						  							
                <%
				String currStartDate = "";
				String currDueDate = "";
				Date startDate = new Date();
				Date dueDate = new Date();				
				Vector currDate = SessPeriode.getCurrPeriod();
				if(currDate.size()==1){
				   Periode per = (Periode) currDate.get(0);
				   
				   if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
					   currStartDate = Formater.formatDate(per.getTglAwal(),SESS_LANGUAGE,"MMMM dd, yyyy");
					   currDueDate = Formater.formatDate(per.getTglAkhir(),SESS_LANGUAGE,"MMMM dd, yyyy");
				   }else{
					   currStartDate = Formater.formatDate(per.getTglAwal(),SESS_LANGUAGE,"dd MMMM yyyy");
					   currDueDate = Formater.formatDate(per.getTglAkhir(),SESS_LANGUAGE,"dd MMMM yyyy");				   
				   }
				   
				   startDate = per.getTglAwal();
				   if(dueDate.compareTo(per.getTglAkhir())>0){
						dueDate = per.getTglAkhir();
				   }				   
				}
				%>			  
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr> 
                  <td width="11%" height="80%" valign="top"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="88%"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> 
                          <input type="radio" name="<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>" value="0" checked>
                          <%=strTitle[SESS_LANGUAGE][1]%><%=currStartDate+"&nbsp;&nbsp;to&nbsp;&nbsp;"+currDueDate%><%=strTitle[SESS_LANGUAGE][2]%></td>
                      </tr>
                      <!--<tr> 
                        <td> 
                          <input type="radio" name="<%//=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>" value="1" >
                          Including All Date</td>
                      </tr>-->
                      <tr> 
                        <td> 
                          <input type="radio" name="<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]%>" value="2" >
                          <%=strTitle[SESS_LANGUAGE][3]%><%=ControlDate.drawDate(SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE], startDate, 0, interval)%> <%=strTitle[SESS_LANGUAGE][4]%> <%=ControlDate.drawDate(SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE], dueDate, 0, interval)%></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%" valign="top" nowrap><%=strTitle[SESS_LANGUAGE][5]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="88%">&nbsp;&nbsp; 
                    <input type="text" name="<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_VOUCHER]%>" size="10" class="txtalign">
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%" valign="top" nowrap><%=strTitle[SESS_LANGUAGE][6]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="88%">&nbsp;&nbsp; 
                    <input type="text" name="<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_INVOICE_NO]%>" size="10" class="txtalign">
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%" valign="top" nowrap><%=strTitle[SESS_LANGUAGE][7]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="88%">&nbsp;&nbsp; 
                    <input type="text" name="<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_CONTACT]%>" size="30">
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%" valign="top"><%=strTitle[SESS_LANGUAGE][8]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="88%"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> 
                          <%
							Vector optKey = new Vector(1,1);
							Vector optValue = new Vector(1,1);
							Vector listOperator =  PstAppUser.listAll();
							if(listOperator!=null && listOperator.size()>0){
								optValue.add("All Operator");
								optKey.add("0");
								try{
									for(int i = 0; i<listOperator.size(); i++){
										AppUser operator = (AppUser)listOperator.get(i);
										optKey.add(String.valueOf(operator.getOID()));																
										optValue.add(operator.getLoginId());
									}
								}catch(Exception exc){}
							}
	    				  %>
                          <%="&nbsp;&nbsp;"+ControlCombo.draw(SessQueryJournal.fieldNames[SessQueryJournal.QUERY_OPERATOR_ID],null,null,optKey,optValue)%> </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%" valign="top" nowrap><%=strTitle[SESS_LANGUAGE][9]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="88%">&nbsp;&nbsp; 
				  <%
				  Vector vBookTypeKey = new Vector(1,1);
				  Vector vBookTypeVal = new Vector(1,1);				  
				  
				  vBookTypeKey.add(""+PstJurnalUmum.CURRENCY_RUPIAH);				  
				  vBookTypeVal.add(PstJurnalUmum.currencyValue[PstJurnalUmum.CURRENCY_RUPIAH]);

				  out.println(ControlCombo.draw(SessQueryJournal.fieldNames[SessQueryJournal.QUERY_CURRENCY],null,"",vBookTypeKey,vBookTypeVal));
				  %>
				  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%" valign="top"><%=strTitle[SESS_LANGUAGE][10]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="88%"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> 
                          <% Vector sortOrder = FrmSrcJurnalUmum.getSortOrder(SESS_LANGUAGE); %>
                          <% for(int i=0;i < sortOrder.size();i++){%>
                          <input type="radio" name="<%=SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]%>" value="<%=i%>"
						  <%if(i==0){%>checked<%}%>>
                          <%=sortOrder.get(i)%>&nbsp;&nbsp; 
                          <% } %>						  
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="88%"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> &nbsp; <a href="javascript:report()" class="command"><%=strReport%></a></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="16">&nbsp;</td>
                  <td width="1%" height="16" class="command">&nbsp;</td>
                  <td width="88%" height="16" class="command">&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td width="11%" height="16">&nbsp;</td>
                  <td width="1%" height="16">&nbsp;</td>
                  <td width="88%" height="16">&nbsp; </td>
                </tr>
              </table>
			  <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][11]%></i></font></td>
                </tr>
              </table>			  			  
			  <%}%>			  
            </form>
            <!-- #EndEditable --></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" class="footer"> 
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>