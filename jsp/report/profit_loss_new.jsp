<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.report.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>
<!--import java-->
<%@ page import="java.util.Date" %>
<!--import qdep-->
<%@ page import="com.dimata.util.*" %>
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
	{"Laporan Per","Periode","Tahun","Tipe Pembukuan","Kurs","Level","Anda tidak punya hak akses untuk laporan laba rugi !!!"},	
	{"Report Per","Period","Annual","Book Type","Rate","Level","You haven't privilege for accessing profit loss report !!!"}
};

public static final String masterTitle[] = {
	"Laporan","Report"	
};

public static final String listTitle[] = {
	"Laba Rugi","Profit Loss"	
};


public static final String textJspTitle[][] = {
	{"Nama","Periode Lalu", "Periode Ini"},
	{"Nama Perkiraan","Periode Lalu", "Periode Ini"}	
};

public String drawList(Vector vProfitLossReport, int language)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader(textJspTitle[language][0],"80%","0","0");
	ctrlist.addHeader(textJspTitle[language][1],"10%","0","0");
	ctrlist.addHeader(textJspTitle[language][2],"10%","0","0");

	ctrlist.setLinkRow(0);
   	ctrlist.setLinkSufix("");
	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
   	 
	int index = -1;
	try 
	{ 								
		int intProfitLossCount = vProfitLossReport.size();						
		for(int i=0; i<intProfitLossCount; i++)
		{
			ProfitLossReport objProfitLossReport = (ProfitLossReport) vProfitLossReport.get(i);					  
			
			String space = "";
			for(int j=0; j<objProfitLossReport.getIAccountLevel(); j++)
			{
				space = space + "&nbsp;&nbsp;";
			}
	
			Vector rowx = new Vector(1,1);		
			rowx.add(space+objProfitLossReport.getSAccountName().toUpperCase());  
			
			if(objProfitLossReport.isBShowBalance())
			{
				rowx.add("<div align=\"right\">"+objProfitLossReport.getSPrevBalance()+"</div>"); 
				rowx.add("<div align=\"right\">"+objProfitLossReport.getSCurrBalance()+"</div>");  
			}
			else
			{
				rowx.add("&nbsp;"); 
				rowx.add("&nbsp;");  
			}
			
			lstData.add(rowx);
		}
	}
	catch(Exception exc) 
	{
		System.out.println("Exc : " + exc.toString());
	}
	return ctrlist.draw(); 
}
%>

<!-- JSP Block -->
<%
// get data from "form request"
int iCommand = FRMQueryString.requestCommand(request);
int plType = FRMQueryString.requestInt(request,"pltype");	
int reportType = FRMQueryString.requestInt(request,SessPL.plFieldText[SessPL.PL_TYPE]);
long periodId = FRMQueryString.requestLong(request,SessPL.plFieldText[SessPL.PL_PERIOD]);
int selectedYear = FRMQueryString.requestInt(request,SessPL.plFieldText[SessPL.PL_ANNUALS]);
int currency = FRMQueryString.requestInt(request,SessPL.plFieldText[SessPL.PL_CURRENCY]);
double rate = FRMQueryString.requestFloat(request,SessPL.plFieldText[SessPL.PL_RATE]);
int selectedLevel = FRMQueryString.requestInt(request,SessPL.plFieldText[SessPL.PL_LEVEL]);
long lastPeriodId = SessPeriode.getPeriodIdJustBefore(periodId);

// format form into 'regional' setting
FRMHandler objFRMHandler = new FRMHandler();
objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);
objFRMHandler.setDigitSeparator(sUserDigitGroup);										

// Declare Commands caption
String strViewReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
String strPrintReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Print Report" : "Cetak Laporan";

// get list of period object that will be used in "Period's Combobox"
String orderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
Vector vectPeriod = PstPeriode.list(0,0,"",orderBy);
Date firstPeriodDate = new Date();
if(vectPeriod!=null && vectPeriod.size()>0)
{
	Periode per = (Periode)vectPeriod.get(0);
	firstPeriodDate = per.getTglAwal();
}
int interval = firstPeriodDate.getYear() - (new Date()).getYear();


// If iCommand is SUBMIT, then view report in JSP 
Vector listProfitLoss = new Vector(1,1);
Vector vProfitLossReport = new Vector(1,1);
if(iCommand == Command.SUBMIT)
{	
	Date startDate = new Date(selectedYear-1900,0,1);
	Date dueDate = new Date(selectedYear-1900,11,31);
	Date lastStartDate = new Date(selectedYear-1901,0,1);
	Date lastDueDate = new Date(selectedYear-1901,11,31);
	String timeReport = "";
	String titleReport  = "";
	if(reportType==SessPL.REPORT_PERIODIC)
	{
		String whereClause = PstPeriode.fieldNames[PstPeriode.FLD_IDPERIODE] + " = " + periodId;
		Vector listPeriode = PstPeriode.list(0,0,whereClause,"");
		if(listPeriode!=null && listPeriode.size()>0)
		{
		  Periode per = (Periode)listPeriode.get(0);
		  timeReport = per.getNama();	  
		  titleReport = "PERIOD";
		}
	}
	else
	{
		timeReport = String.valueOf(selectedYear);  
		titleReport = "YEAR";
	}
	
	
	if(reportType==SessPL.REPORT_PERIODIC)
	{
		listProfitLoss = SessProfitLoss.listProfitLossReport(null,null,null,null,lastPeriodId,periodId,currency,selectedLevel,rate);
	}
	else
	{
		listProfitLoss = SessProfitLoss.listProfitLossReport(lastStartDate,lastDueDate,startDate,dueDate,0,0,currency,selectedLevel,rate);
	}	

	
	// convert data into "ProfitLossReport" format	
	String sTaxesOid = PstAccountLink.getLinkAccountStr(CtrlAccountLink.TYPE_TAXES);      
	String[][] sArrAccountTitle = 
	{
		{"Laba (Rugi) Sebelum Pajak", "Pajak", "Total Pajak", "Laba (Rugi) Setelah Pajak"},
		{"Profit (Loss) Before Tax", "Tax", "Total Tax", "Profit (Loss) After Tax"}
	};		
	SessPL objSessPL = new SessPL();					
	vProfitLossReport = objSessPL.generateProfitLoss(SESS_LANGUAGE,listProfitLoss, sTaxesOid, selectedLevel, objFRMHandler, sArrAccountTitle);	
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/aiso.dwt" -->    
<head>   
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
function seachReport()
{
	document.frmProfitLoss.command.value="<%=Command.SUBMIT%>";
	document.frmProfitLoss.action="profit_loss.jsp";
	document.frmProfitLoss.submit();
}

function cmdChange()
{
	var type = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_TYPE]%>.value;
	if(type==0)
	{
		document.all.PERIODE.style.display = "block";			
		document.all.ANNUAL.style.display = "none";				
	}
	if(type==1)
	{
		document.all.PERIODE.style.display = "none";		
		document.all.ANNUAL.style.display = "block"; 			
	}	
}

/*
function cmdChangeCurrency()
{
	var curr = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_CURRENCY]%>.value;
	if(curr=="")
	{ 
		document.all.KURS.style.display = "block";
		document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.value=""; 		
		document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.focus(); 
	}
	else
	{		
		document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.value=""; 			
		document.all.KURS.style.display = "none"; 			
	}
}
*/


function report(){
	var reportType = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_TYPE]%>.value;		
	if(reportType==0){
		var periodId = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_PERIOD]%>.value;		
		if(periodId!=""){	
			var reportType = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_TYPE]%>.value;		
			var currency = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_CURRENCY]%>.value;					
			var selectedLevel = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_LEVEL]%>.value;
			var rate = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.value;			
			//var rate = 0;			
			if(currency==""){currency = <%=SessPL.PL_ALL%>;}				
			var linkPage   = "profit_loss_buffer.jsp?" +
							 "<%=SessPL.plFieldText[SessPL.PL_TYPE]%>=" + reportType + "&" + 
							 "<%=SessPL.plFieldText[SessPL.PL_PERIOD]%>=" + periodId + "&" + 
							 "<%=SessPL.plFieldText[SessPL.PL_CURRENCY]%>=" + currency + "&" + 
							 "<%=SessPL.plFieldText[SessPL.PL_RATE]%>=" + rate + "&" + 							 
							 "<%=SessPL.plFieldText[SessPL.PL_LEVEL]%>=" + selectedLevel;
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
		var selectedLevel = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_LEVEL]%>.value;				
		var rate = document.frmProfitLoss.<%=SessPL.plFieldText[SessPL.PL_RATE]%>.value;					
		var rate = 0;
		if(currency==""){currency = <%=SessPL.PL_ALL%>;}						
		var linkPage   = "profit_loss_buffer.jsp?" +
						 "<%=SessPL.plFieldText[SessPL.PL_TYPE]%>=" + reportType + "&" + 
						 "<%=SessPL.plFieldText[SessPL.PL_ANNUALS]%>=" + selectedYear + "&" + 					 					 	
						 "<%=SessPL.plFieldText[SessPL.PL_CURRENCY]%>=" + currency + "&" + 
						 "<%=SessPL.plFieldText[SessPL.PL_RATE]%>=" + rate + "&" + 							 						 
						 "<%=SessPL.plFieldText[SessPL.PL_LEVEL]%>=" + selectedLevel;
		window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no,scrollbars=no"); 					
	}	
}
</script>
<!-- #EndEditable --> 
<!-- #BeginEditable "headerscript" -->
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
              <input type="hidden" name="command" value="<%=iCommand%>">			
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"> 
                    <hr>
                  </td>
                </tr>
              </table>
			  
			  <%
			  if(privView && privSubmit)
			  {
			  %>						  			  
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

				  vectorKey.add(""+SessPL.REPORT_PERIODIC);
				  vectorValue.add(SessPL.reportFieldNames[SESS_LANGUAGE][SessPL.REPORT_PERIODIC]); 

				  vectorKey.add(""+SessPL.REPORT_ANNUAL);
				  vectorValue.add(SessPL.reportFieldNames[SESS_LANGUAGE][SessPL.REPORT_ANNUAL]); 

				  String attrType = "onChange=\"javascript:cmdChange()\"";
				  %>
                  <%=ControlCombo.draw(SessPL.plFieldText[SessPL.PL_TYPE],null,""+reportType,vectorKey,vectorValue,attrType)%> 
				  </td>
                </tr>
                <tr ID="PERIODE"> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%">
                  <%
				  Vector vectKey = new Vector(1,1);
				  Vector vectVal = new Vector(1,1);									  
				  for(int i=0; i<vectPeriod.size(); i++)
				  { 
					   Periode per = (Periode)vectPeriod.get(i);
					   vectKey.add(""+per.getOID());
					   vectVal.add(per.getNama()) ; 
				  }				  
				  String selected = ""+periodId;					  
				  out.println(ControlCombo.draw(SessPL.plFieldText[SessPL.PL_PERIOD],null,selected,vectKey,vectVal));
				  %>				  
				  </td>
                </tr>
                <tr ID="ANNUAL"> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%"><%=ControlDate.drawDateYear(SessPL.plFieldText[SessPL.PL_ANNUALS], new Date(), ""+selectedYear, 0, interval)%> </td>
                </tr>
                <tr> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][3]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%"> 
                  <%
				  //String eventKurs = "onChange=\"javascript:cmdChangeCurrency()\"";				  
				  //out.println(ControlCombo.draw(SessPL.plFieldText[SessPL.PL_CURRENCY],"All",null,PstJurnalUmum.getCurrencyKey(),PstJurnalUmum.getCurrencyValue(),eventKurs));
				  
				  Vector vBookTypeKey = new Vector(1,1);
				  Vector vBookTypeVal = new Vector(1,1);				  
				  
				  vBookTypeKey.add(""+PstJurnalUmum.CURRENCY_RUPIAH);				  
				  vBookTypeVal.add(PstJurnalUmum.currencyValue[PstJurnalUmum.CURRENCY_RUPIAH]);
				  				  
				  out.println(ControlCombo.draw(SessPL.plFieldText[SessPL.PL_CURRENCY],null,""+currency,vBookTypeKey,vBookTypeVal));								  
				  %>
                  <input type="hidden" name="<%=SessPL.plFieldText[SessPL.PL_RATE]%>" size="10" class="txtalign">
                  </td>
                </tr>
				
                <!--
                <tr id=KURS> 
                  <td width="8%" height="20%"><%//=strTitle[SESS_LANGUAGE][4]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%"> 
                    <input type="hidden" name="<%//=SessPL.plFieldText[SessPL.PL_RATE]%>" size="10" class="txtalign">
                </tr>
				-->
				
                <tr> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][5]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%">  
                  <%
				  Vector vectorKeyLvl = new Vector(1,1);
				  Vector vectorValueLvl = new Vector(1,1);

				  int iMaxAccountLevel = 7;	
				  for(int i=1; i<iMaxAccountLevel; i++)
				  {
					  vectorKeyLvl.add(""+i);
					  vectorValueLvl.add(""+i); 
				  }

				  String sSelected = ""+selectedLevel;
				  %>
                  <%=ControlCombo.draw(SessPL.plFieldText[SessPL.PL_LEVEL],null,sSelected,vectorKeyLvl,vectorValueLvl,"")%>
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
                  <td height="20%" width="90%"><a href="javascript:seachReport()"><span class="command"><%=strViewReport%></span></a></td>
                </tr>
                <tr> 
                  <td width="8%" height="20%">&nbsp;</td>
                  <td height="20%" width="2%">&nbsp;</td>
                  <td height="20%" width="90%">&nbsp;</td>
                </tr>				

				<%
				if(vProfitLossReport!=null && vProfitLossReport.size()>0)
				{
				%>
                <tr> 
                  <td colspan="3">
                    <hr size="1">
                  </td>
                </tr>				
                <tr> 
                  <td colspan="3"><%=drawList(vProfitLossReport, SESS_LANGUAGE)%></td>
                </tr>				
                <tr> 
                  <td colspan="3">&nbsp;<a href="javascript:report()"><span class="command"><%=strPrintReport%></span></a></td>
                </tr>
				<%
				}
				%>						
				
				<%
				if(reportType == SessPL.REPORT_PERIODIC)
				{
				%>
                <script language="javascript">
					document.all.PERIODE.style.display = "block";			
					document.all.ANNUAL.style.display = "none";				
				</script>
				<%
				}
				else
				{
				%>
                <script language="javascript">
					document.all.PERIODE.style.display = "none";			
					document.all.ANNUAL.style.display = "block";				
				</script>				
				<%
				}
				%>
				
              </table>
			  <%
			  }
			  else
			  {
			  %>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][5]%></i></font></td>
                </tr>
              </table>			  			  
			  <%
			  }
			  %>			  
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
<%
}
%>