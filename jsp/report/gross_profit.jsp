<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.Date" %>
<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.form.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_GROSS_PROFIT, AppObjInfo.OBJ_REPORT_GROSS_PROFIT_PRIV); %>
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
	{"Penjualan","Periode","Tipe Pembukuan","Anda tidak punya hak akses untuk laporan laba kotor penjualan !!!"},	
	{"Sales","Period","Book Type","You haven't privilege for accessing gross profit of goods sold report !!!"}
};

public static final String masterTitle[] = {
	"Laporan","Report"	
};

public static final String listTitle[] = {
	"Laba Kotor Penjualan","Gross Profit of Goods Sold"	
};
%>
<!-- JSP Block -->
<%
/**
* Declare Commands caption
*/
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/aiso.dwt" -->    
<head>   
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">

function report(){ 
	var accountName = document.frmGrossProfit.<%=SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_ACCOUNT_SALES]%>.value;				
	var idPeriod = document.frmGrossProfit.<%=SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_PERIOD]%>.value;				
	var currency = document.frmGrossProfit.<%=SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_CURRENCY]%>.value;					
	if(idPeriod!=""){
		var linkPage  = "gross_profit_buffer.jsp?" + 		
						"<%=SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_ACCOUNT_SALES]%>=" + accountName + "&" +
						"<%=SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_PERIOD]%>=" + idPeriod + "&" +
						"<%=SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_CURRENCY]%>=" + currency;						
		window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no"); 			
	}else{
		document.frmGrossProfit.<%=SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_PERIOD]%>.focus();						
	}
}	
</script>
<!-- #EndEditable --> 
<!-- #BeginEditable "headerscript" -->
<SCRIPT language=JavaScript>
function hideObjectForMenuJournal(){ 
}
	
function hideObjectForMenuReport(){
    <%if(privView && privSubmit){%>						  			  
	document.all.<%=SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_ACCOUNT_SALES]%>.style.visibility = "hidden";
	<%}%>
}
	
function hideObjectForMenuPeriod(){
}
	
function hideObjectForMenuMasterData(){
}

function hideObjectForMenuSystem(){
}

//*****************
function showObjectForMenu(){
    <%if(privView && privSubmit){%>						  			  
	document.all.<%=SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_ACCOUNT_SALES]%>.style.visibility = "";
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
    <td bgcolor="#000099" height="20" ID="MAINMENU"> 
      <%@ include file = "../main/menumain.jsp" %>
    </td> 
  </tr>
  <tr>
    <td valign="top" align="left">  
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td  class="contenttitle" height="10"><!-- #BeginEditable "contenttitle" --> 
            <%=masterTitle[SESS_LANGUAGE]%>&nbsp;&gt;&nbsp;<%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td height="21"><!-- #BeginEditable "content" --> 
            <form name="frmGrossProfit" method="post" action="">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"> 
                    <hr>
                  </td>
                </tr>
              </table>
			  <%if(privView && privSubmit){%>						  			  
              <table width="100%" border="0">
                <%String odClause = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
				  Vector vectPeriod = PstPeriode.list(0,0,"",odClause);
				  if(vectPeriod!=null && vectPeriod.size()>0){
					  Vector vectorKey = new Vector(1,1);
					  Vector vectorVal = new Vector(1,1);					
					  for(int i=0; i<vectPeriod.size(); i++){ 
						   Periode per = (Periode)vectPeriod.get(i);
						   vectorKey.add(""+per.getOID());
						   vectorVal.add(per.getNama()) ; 
					  }
					  Periode peri = (Periode)vectPeriod.get(vectPeriod.size()-1);
					  String selected = ""+peri.getOID();					  
				%>
                <tr> 
                  <td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="23" width="2%"> :</td>
                  <td height="23" width="87%"> 
                    <%
				  /*
				  String whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN] + 
				  					   " LIKE \"" + PstPerkiraan.INCOME + "%\"" + 
				  					   " AND " + PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE] + 
									   " = " + PstPerkiraan.ACC_POSTED;
				  String order = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];
				  */
				  CtrlAccountLink ctrlAccountLink = new CtrlAccountLink(request);
				  String salesAccOid = PstAccountLink.getLinkAccountStr(ctrlAccountLink.TYPE_GROSS_PROFIT);
				  String whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_IDPERKIRAAN] + " IN (" + salesAccOid + ")";
				  String order = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];
				  
				  Vector vectKey = new Vector(1,1);									   
				  Vector vectVal = new Vector(1,1);
				  vectKey.add(""+SessGrossProfit.TOTAL_COGS);
				  vectVal.add("All Sales");									   				  
 				  Vector listAccountSales = PstPerkiraan.list(0,0,whereClause,order);
				  String space = "";
				  for(int i=0; i<listAccountSales.size(); i++){ 
				  	   Perkiraan acc = (Perkiraan)listAccountSales.get(i);
					   vectKey.add(String.valueOf(acc.getOID())); 					   
					   vectVal.add(space+acc.getNama()); 
				  }
				  
				  out.println(ControlCombo.draw(SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_ACCOUNT_SALES],null,null,vectKey,vectVal));
				  %>
                  </td>
                </tr>
                <tr> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td height="20%" width="2%">:</td>
                  <td height="20%" width="90%"> <%=ControlCombo.draw(SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_PERIOD],null,selected,vectorKey,vectorVal)%></td>
                </tr>
                <tr> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td height="20%" width="2%">:</td>
                  <td height="20%" width="90%"> 
				  <%
				  Vector vBookTypeKey = new Vector(1,1);
				  Vector vBookTypeVal = new Vector(1,1);				  
				  
				  vBookTypeKey.add(""+PstJurnalUmum.CURRENCY_RUPIAH);				  
				  vBookTypeVal.add(PstJurnalUmum.currencyValue[PstJurnalUmum.CURRENCY_RUPIAH]);
				  
				  out.println(ControlCombo.draw(SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_CURRENCY],null,"",vBookTypeKey,vBookTypeVal));
				  %> 
				  </td>
                </tr>
                <tr> 
                  <td width="8%" height="20%">&nbsp;</td>
                  <td height="20%" width="2%">&nbsp;</td>
                  <td height="20%" width="90%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="8%" height="20%">&nbsp;</td>
                  <td height="20%" width="2%">&nbsp;</td>
                  <td height="20%" width="90%"><a href="javascript:report()"><span class="command"><%=strReport%></span></a></td>
                </tr>
                <%}%>
              </table>
			  <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][3]%></i></font></td>
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
    <td bgcolor="#000099" height="29"> 
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>