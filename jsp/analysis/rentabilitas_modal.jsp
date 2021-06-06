<%@ page language = "java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.analysis.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>
<%@ page import="com.dimata.aiso.session.analysis.*" %>

<!--import java-->
<%@ page import="java.util.Date" %>

<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<%@ page import = "com.dimata.util.*" %>

<%@ page import = "com.dimata.common.entity.payment.*" %>

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

public static final int TYPE_PERIOD = 0;
public static final int TYPE_ANNUAL = 1;

public static String typeTitles[][] = {
    {"Periode", "Tahunan"},
    {"Periodic", "Annual"}
};

public static String strTitle[][] = {
	{"Periode Laporan","Periode","Tahun","Anda tidak punya hak akses untuk melihat laporan rentabilitas modal !!!"},	
	{"Report Periode","Period","Annual","You don't have privilege to access equity rentability report !!!"}
};

public static final String masterTitle[] = {
	"Analisis","Analysis"	
};

public static final String listTitle[] = {
	"Rentabilitas Modal", "Equity Rentability"	
};

public static final String reportTitles[][] = {
    {"Perkiraan" ,"Rincian", "Nilai", "Laba Tahun Berjalan", "Modal", "Rasio Rentabilitas Modal"},
    {"Account", "Description", "Value", "Current Earning Year", "Equity", "Equity Rentability Ratio"}
};

public static String drawList(int language,
                              ReportAnalysis objProfit,  
                              Vector vectEquity,
                              String sDigitSymbol,
                              String sDecimalSymbol)
{
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("100%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
    ctrlist.setHeaderStyle("listgentitle");
    ctrlist.dataFormat("<div align=\"center\">" + reportTitles[language][0] + "</div>", "20%", "", "");
    ctrlist.dataFormat("<div align=\"center\">" + reportTitles[language][1] + "</div>", "60%", "", "");
    ctrlist.dataFormat("<div align=\"center\">" + reportTitles[language][2] + "</div>", "20%", "", "");
    
    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");
	
    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();
    
    int iEquitySize = vectEquity.size();
    FRMHandler frmHandler = new FRMHandler();
    frmHandler.setDigitSeparator(sDigitSymbol);
    frmHandler.setDecimalSeparator(sDecimalSymbol);
    
    double amount = 0;
    double totalProfit = 0;
    double totalEquity = 0;
    
    Vector rowx = new Vector();
    rowx.add("&nbsp;" + reportTitles[language][3]);
    rowx.add("&nbsp;" + objProfit.getAccountName());
    totalProfit = objProfit.getAmount();
    if (totalProfit < 0)
        rowx.add("<div align=\"right\">(" + frmHandler.userFormatStringDecimal(totalProfit * -1) + ")&nbsp;</div>");
    else
        rowx.add("<div align=\"right\">" + frmHandler.userFormatStringDecimal(totalProfit) + "&nbsp;</div>");
    lstData.add(rowx);
    
    rowx = new Vector();
    rowx.add("&nbsp;" + reportTitles[language][4]);
    if (iEquitySize > 0) {
        ReportAnalysis ra = (ReportAnalysis) vectEquity.get(0);
        rowx.add("&nbsp;" + ra.getAccountName());
        amount = ra.getAmount();
        totalEquity = amount;
        if (amount < 0)
            rowx.add("<div align=\"right\">(" + frmHandler.userFormatStringDecimal(amount * -1) + ")&nbsp;</div>");
        else
            rowx.add("<div align=\"right\">" + frmHandler.userFormatStringDecimal(amount) + "&nbsp;</div>");
        
    } else {
        rowx.add("&nbsp;-");
        rowx.add("<div align=\"right\">" + frmHandler.userFormatStringDecimal(0) + "&nbsp;</div>");
    }
    lstData.add(rowx);
    
    for (int item = 1; item < iEquitySize; item++) {
        ReportAnalysis ra = (ReportAnalysis) vectEquity.get(item);
        rowx = new Vector();
        rowx.add("");
        rowx.add("&nbsp;" + ra.getAccountName());
        amount = ra.getAmount();
        totalEquity += amount;
        if (amount < 0)
            rowx.add("<div align=\"right\">(" + frmHandler.userFormatStringDecimal(amount * -1) + ")&nbsp;</div>");
        else
            rowx.add("<div align=\"right\">" + frmHandler.userFormatStringDecimal(amount) + "&nbsp;</div>");
        lstData.add(rowx);
    }
    
    rowx = new Vector();
    rowx.add("");
    rowx.add("<b>&nbsp;Total&nbsp;" + reportTitles[language][4] + "</b>");
    if (totalEquity < 0)
        rowx.add("<b><div align=\"right\">(" + frmHandler.userFormatStringDecimal(totalEquity * -1) + ")&nbsp;</div></b>");
    else    
        rowx.add("<b><div align=\"right\">" + frmHandler.userFormatStringDecimal(totalEquity) + "&nbsp;</div></b>");
    lstData.add(rowx);
    
    double ratio = 0;
    
    if (totalEquity == 0) {
        totalEquity = 1;
    }
    
    ratio = totalProfit * 100 / totalEquity;
    
    rowx = new Vector();
    rowx.add("<b>&nbsp;" + reportTitles[language][5] + "</b>");
    rowx.add("<b>&nbsp;(Total&nbsp;" + reportTitles[language][3] + "&nbsp;/&nbsp;Total&nbsp;" + reportTitles[language][4] + ")&nbsp;x&nbsp;100%</b>");
    rowx.add("<b><div align=\"right\">" + frmHandler.userFormatStringDecimal(ratio) + "&nbsp;%&nbsp;</div></b>");
    lstData.add(rowx);

    return ctrlist.draw();
}    

%>

<!-- JSP Block -->
<%
int iCommand = FRMQueryString.requestCommand(request);
int iReportType = FRMQueryString.requestInt(request, "reportType");
long lPeriodOid = FRMQueryString.requestLong(request, "period"); 
int iYear = FRMQueryString.requestInt(request, "annual");

String YR = "_yr";
String MN = "_mn";
String DY = "_dy";
String MM = "_mm";
String HH = "_hh";    

// mencari data periode
String order = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
Date firstPeriodDate = new Date();
Hashtable objHashPeriod = new Hashtable();
Vector vectKey = new Vector(1,1);
Vector vectVal = new Vector(1,1);					
Vector vectPeriod = PstPeriode.list(0, 0, "", order);
for (int i = 0; i < vectPeriod.size(); i++) 
{ 
    Periode per = (Periode) vectPeriod.get(i);
    vectKey.add(String.valueOf(per.getOID()));
    vectVal.add(per.getNama());
 
    objHashPeriod.put(String.valueOf(per.getOID()),per.getNama());

    if( i == 0 )
    {
        firstPeriodDate = per.getTglAwal();
    }
}

Date nowDate = new Date();
int interval = firstPeriodDate.getYear() - nowDate.getYear();
String strPeriodName = (String) objHashPeriod.get(String.valueOf(lPeriodOid));


// Declare Commands caption
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";


ReportAnalysis objProfit = new ReportAnalysis();   // laba tahun berjalan
Vector vectEquity = new Vector();                  // modal
if (iCommand == Command.VIEW) 
{
	// report use annual
	if (iReportType == TYPE_ANNUAL) 	
	{ 
		objProfit = SessAnalysis.getProfitYear(iYear, SESS_LANGUAGE);
		vectEquity = SessAnalysis.generateReportYear(PstPerkiraan.ACC_GROUP_EQUITY, iYear, SESS_LANGUAGE);	 
	}
	
	// report use periode
	if (iReportType == TYPE_PERIOD)
	{                           
		objProfit = SessAnalysis.getProfitPeriod(lPeriodOid, SESS_LANGUAGE);
		vectEquity = SessAnalysis.generateReportPeriod(PstPerkiraan.ACC_GROUP_EQUITY, lPeriodOid, SESS_LANGUAGE);	 
	}
    
        // simpan data ke session utk laporan di pdf
        String sTitle = "";        
        if (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) 
        {
            if (iReportType == TYPE_ANNUAL)
            {
                sTitle = "Equity Rentability Analysis Report";
                sTitle += "\nPeriod : " + iYear;                
            }
 
            if (iReportType == TYPE_PERIOD)
            {
                sTitle = "Equity Rentability Analysis Report";
                sTitle += "\nPeriod : " + strPeriodName;                
            }            
         }
         
         else
         {         
            if (iReportType == TYPE_ANNUAL)
            {
                sTitle = "Laporan Analisa Rentabilitas Modal Sendiri";
                sTitle += "\nPeriode : " + iYear;                
            }
 
            if (iReportType == TYPE_PERIOD)
            {
                sTitle = "Laporan Analisa Rentabilitas Modal Sendiri";
                sTitle += "\nPeriode : " + strPeriodName;
            }            
        }    

        Vector vectEquityRent = new Vector();

        vectEquityRent.add(objProfit);
        vectEquityRent.add(vectEquity);
        vectEquityRent.add(sTitle);
        vectEquityRent.add(String.valueOf(SESS_LANGUAGE));
        vectEquityRent.add(sUserDigitGroup);
        vectEquityRent.add(sUserDecimalSymbol);
        vectEquityRent.add(new Boolean(bPdfCompanyTitleUseImg));
        vectEquityRent.add(sPdfCompanyTitle);
        vectEquityRent.add(sPdfCompanyDetail);
        vectEquityRent.add(String.valueOf(iPdfHeaderFooterFlag));

        if (session.getValue("EQUITY_RENTABILITY") != null) {
            session.removeValue("EQUITY_RENTABILITY");
        }
        session.putValue("EQUITY_RENTABILITY", vectEquityRent);
}    

String strPrint = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) ? "Print Report" : "Cetak Laporan";
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/aiso.dwt" -->    
<head>   
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">

function cmdChange(){
	var type = document.frmCurrentRatio.reportType.value;
	if(type==0){
		document.all.PERIODE.style.display = "block";			
		document.all.ANNUAL.style.display = "none";				
	}
	if(type==1){
		document.all.PERIODE.style.display = "none";		
		document.all.ANNUAL.style.display = "block"; 			
	}	
}

function report() {
    document.frmCurrentRatio.command.value = "<%=Command.VIEW%>";
    document.frmCurrentRatio.action = "rentabilitas_modal.jsp";
    document.frmCurrentRatio.submit();
}


function print(){
    var linkPage = "<%=reportroot%>session.analysis.EquityRentabilityPdf?gettime=<%=System.currentTimeMillis()%>";
    //window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no");  			
    window.open(linkPage);  				
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
            <form name="frmCurrentRatio" method="post" action="">
             <input type="hidden" name="command" value="<%=iCommand%>">
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
                      Vector vectorKey = new Vector(1, 1);
                      Vector vectorValue = new Vector(1, 1);

                      vectorKey.add(String.valueOf(TYPE_PERIOD));
                      vectorValue.add(typeTitles[SESS_LANGUAGE][TYPE_PERIOD]);

                      vectorKey.add(String.valueOf(TYPE_ANNUAL));
                      vectorValue.add(typeTitles[SESS_LANGUAGE][TYPE_ANNUAL]);
                      
                      String selReportType = String.valueOf(iReportType);

                      String attrType = "onChange=\"javascript:cmdChange()\"";
                    %>
                    <%=ControlCombo.draw("reportType", null, selReportType, vectorKey, vectorValue, attrType)%> </td>
                </tr>
                <tr ID="PERIODE"> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td height="20%" width="2%">  
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%"><%=ControlCombo.draw("period", null, String.valueOf(lPeriodOid), vectKey, vectVal)%></td>
                </tr>
                <tr ID="ANNUAL"> 
                  <td width="8%" height="20%"><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="90%"> <%=ControlDate.drawDateYear("annual", new Date(), "", 0, interval)%> </td>
                </tr>
                <tr><td height="5"></td></tr>
                <tr> 
                  <td width="8%" height="10%">&nbsp;</td>
                  <td height="10%" width="2%">&nbsp;</td>
                  <td height="10%" width="90%"><a href="javascript:report()"><span class="command"><%=strReport%></span></a></td>
                </tr>
                <% if (iReportType == 0) { %>
                <script language="javascript">
					document.all.PERIODE.style.display = "block";			
					document.all.ANNUAL.style.display = "none";				
				</script>
				<% } else { %>
				<script language="javascript">
							document.all.PERIODE.style.display = "none";
							document.all.ANNUAL.style.display = "block";
				</script>
				<% } %>
				<tr><td height="7"></td></tr>
				<tr><td colspan="3">
				<%
                 if (iCommand == Command.VIEW) {
                    out.println(drawList(SESS_LANGUAGE, objProfit, vectEquity, sUserDigitGroup, sUserDecimalSymbol));
                 }
                %>
				</td></tr>
				<% if (iCommand == Command.VIEW) { %>
				<tr><td height="5"></td></tr>
				<tr><td colspan="3" class="command">&nbsp;<a href="javascript:print()"><b><%=strPrint%></b></a></td></tr>
				<% } %>
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
<!-- #EndTemplate -->
</html>
<!-- endif of "has access" condition -->
<%}%>