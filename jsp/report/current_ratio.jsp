<%@ page language = "java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>
<!--import java-->
<%@ page import="java.util.Date" %>
<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_PROFIT_LOSS, AppObjInfo.OBJ_REPORT_PROFIT_LOSS_PRIV); %>
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
	{"Tipe Laporan","Periode","Tahun","Tipe Pembukuan","Kurs","Level","Anda tidak punya hak akses untuk laporan laba rugi !!!"},	
	{"Report Type","Period","Annual","Book Type","Rate","Level","You haven't privilege for accessing profit loss report !!!"}
};

public static final String masterTitle[] = {
	"Laporan > Analisis","Report > Analysis"	
};

public static final String listTitle[] = {
	"Current Ratio", "Current Ratio"	
};
%>

<!-- JSP Block -->
<%
int plType = FRMQueryString.requestInt(request,"pltype");

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
<html><!-- #BeginTemplate "/Templates/aiso.dwt" -->    
<head>   
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">

function cmdChange(){
	var type = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_TYPE]%>.value;
	if(type==0){
		document.all.PERIODE.style.display = "block";			
		document.all.ANNUAL.style.display = "none";				
	}
	if(type==1){
		document.all.PERIODE.style.display = "none";		
		document.all.ANNUAL.style.display = "block"; 			
	}	
}

function cmdChangeCurrency(){
	var curr = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_CURRENCY]%>.value;
	if(curr==""){ 
		//document.all.KURS.style.display = "block";
		//document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.value=""; 		
		document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.focus(); 
	}else{	
		//document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.value=""; 			
		//document.all.KURS.style.display = "none"; 			
	}
}

function report(){
	var reportType = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_TYPE]%>.value;		
	if(reportType==0){
		var periodId = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_PERIOD]%>.value;		
		if(periodId!=""){	
			var reportType = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_TYPE]%>.value;		
			var currency = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_CURRENCY]%>.value;					
			//var selectedLevel = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_LEVEL]%>.value;
			//var rate = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.value;			
			var rate = 0;			
			if(currency==""){currency = <%=SessPL.PL_ALL%>;}				
			var linkPage   = "current_ratio_buffer.jsp?" +
							 "<%=SessPL.plFieldText[SessPL.PL_TYPE]%>=" + reportType + "&" + 
							 "<%=SessPL.plFieldText[SessPL.PL_PERIOD]%>=" + periodId + "&" + 
							 "<%=SessPL.plFieldText[SessPL.PL_CURRENCY]%>=" + currency;/* + "&" + 
							 "<%=SessPL.plFieldText[SessPL.PL_RATE]%>=" + rate + "&" + 							 
							 "<%=SessPL.plFieldText[SessPL.PL_LEVEL]%>=" + selectedLevel;*/
			//window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no,scrollbars=no");  								
			window.open(linkPage,"reportPage","");  											
		}else{
			msgText.innerHTML="<i>Cannot process, please choose an period ...</i>";
			document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_PERIOD]%>.focus();			
		}
	}else{
		msgText.innerHTML=""; 	
		var reportType = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_TYPE]%>.value;		
		var selectedYear = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_ANNUALS]%>.value;
		var currency = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_CURRENCY]%>.value;					
		//var selectedLevel = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_LEVEL]%>.value;				
		//var rate = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.value;					
		var rate = 0;
		if(currency==""){currency = <%=SessPL.PL_ALL%>;}						
		var linkPage   = "current_ratio_buffer.jsp?" +
						 "<%=SessPL.plFieldText[SessPL.PL_TYPE]%>=" + reportType + "&" + 
						 "<%=SessPL.plFieldText[SessPL.PL_ANNUALS]%>=" + selectedYear + "&" + 					 					 	
						 "<%=SessPL.plFieldText[SessPL.PL_CURRENCY]%>=" + currency;/* + "&" + 
						 "<%=SessPL.plFieldText[SessPL.PL_RATE]%>=" + rate + "&" + 							 						 
						 "<%=SessPL.plFieldText[SessPL.PL_LEVEL]%>=" + selectedLevel; */
		window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no,scrollbars=no"); 					
	}	
}	
</script>
<!-- #EndEditable --> 
<!-- #BeginEditable "headerscript" -->
<SCRIPT language=JavaScript>
function hideObjectForMenuJournal(){ 
	}
	
function hideObjectForMenuReport(){
	}
	
function hideObjectForMenuPeriod(){
	}
	
function hideObjectForMenuMasterData(){
	}

function hideObjectForMenuSystem(){
	}

//*****************
function showObjectForMenu(){
	
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
            <form name="frmProfitLoss" method="post" action="">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"> 
                    <hr>
                  </td>
                </tr>
              </table>
			  <%if(privView && privSubmit){%>						  			  
              <table width="100%" border="0">
                <tr> 
                  <td colspan="3" height="20%" ID=msgText class="msgbalance"> 
                    <div align="center"><b></b></div>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="20%"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="87%"> 
                    <%
				  Vector vectorKey = new Vector(1,1);
				  Vector vectorValue = new Vector(1,1);
				  for(int i=0; i<SessPL.reportFieldNames[0].length; i++){ 
					   vectorKey.add(String.valueOf(i));
					   vectorValue.add(SessPL.reportFieldNames[SESS_LANGUAGE][i]) ; 
				  }
				  String attrType = "onChange=\"javascript:cmdChange()\"";
				  %>
                    <%=ControlCombo.draw(SessPL.plFieldText[SessPL.PL_TYPE],null,null,vectorKey,vectorValue,attrType)%> </td>
                </tr>
                <%String order = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
				  Vector vectPeriod = PstPeriode.list(0,0,"",order);
					  Vector vectKey = new Vector(1,1);
					  Vector vectVal = new Vector(1,1);					
					  for(int i=0; i<vectPeriod.size(); i++){ 
						   Periode per = (Periode)vectPeriod.get(i);
						   vectKey.add(""+per.getOID());
						   vectVal.add(per.getNama()) ; 
					  }
					   Periode peri = (Periode)vectPeriod.get(vectPeriod.size()-1);
					   String selected = ""+peri.getOID();					  
				%>
                <tr ID="PERIODE"> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td height="20%" width="2%">  
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%"><%=ControlCombo.draw(SessPL.plFieldText[SessPL.PL_PERIOD],null,selected,vectKey,vectVal)%></td>
                </tr>
                <tr ID="ANNUAL"> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%"> <%=ControlDate.drawDateYear(SessPL.plFieldText[SessPL.PL_ANNUALS], new Date(),"",0,interval)%> </td>
                </tr>
                <tr> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][3]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%"> 
                    <%
				  String eventKurs = "onChange=\"javascript:cmdChangeCurrency()\"";				  
				  out.println(ControlCombo.draw(SessPL.plFieldText[SessPL.PL_CURRENCY],"All",null,PstJurnalUmum.getCurrencyKey(),PstJurnalUmum.getCurrencyValue(),eventKurs));
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
                <script language="javascript">
					document.all.PERIODE.style.display = "block";			
					document.all.ANNUAL.style.display = "none";				
				</script>
              </table>
			  <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][5]%></i></font></td>
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