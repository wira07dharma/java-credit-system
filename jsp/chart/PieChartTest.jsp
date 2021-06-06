
<%@ page import = "org.jfree.chart.plot.PiePlot,org.jfree.chart.*,java.awt.*,org.jfree.ui.*,org.jfree.data.general.*, java.util.*,org.jfree.chart.servlet.*,org.jfree.chart.entity.*,java.io.*"%>
<%@ page import="com.dimata.aiso.report.analisa.*,
		 com.dimata.aiso.entity.periode.*,
		 com.dimata.util.*,
		 java.util.*,
		 com.dimata.aiso.entity.search.SrcPieChart,
		 com.dimata.interfaces.chartofaccount.I_ChartOfAccountGroup"%>
<!--package posbo -->
<%@ include file = "../../main/javainit.jsp" %>

<!-- Jsp Block -->
<%!
    public String[][] pageTitle = {
	{"Analisa Lap Keuangan", "Analisa Grafik"},
	{"Financial Analysis", "Chart Analysis"}
    };
%>
<%
    Periode objPeriode = new Periode();
    Date startPeriodDate = null;
    Date endPeriodDate = null;
    long lPeriodId = 0;
    double dInAmount = 1000000;
    int iRecordToGet = 3;
    String sTitleExpenses = "";
    String sTitleRevCompotition = "";
    String sTitleRevContribution = "";
    String sTitleWorkingCapitalContribution = "";
    
    try{
	lPeriodId = PstPeriode.getCurrPeriodId();
    }catch(Exception e){}

    if(lPeriodId != 0){
	try{
	    objPeriode = PstPeriode.fetchExc(lPeriodId);
	    startPeriodDate = (Date)objPeriode.getTglAwal();
	    endPeriodDate = (Date)objPeriode.getTglAkhir();
	}catch(Exception e){}
    }
    
    String sAmount = NumberSpeller.specialSpeller(dInAmount, SESS_LANGUAGE);
    sTitleExpenses = sChartTitle[SESS_LANGUAGE][0] + sAmount +")";
    sTitleRevCompotition = sChartTitle[SESS_LANGUAGE][1] + sAmount +")";
    sTitleRevContribution = sChartTitle[SESS_LANGUAGE][2];
    sTitleWorkingCapitalContribution = sChartTitle[SESS_LANGUAGE][3] + sAmount +")";
    
    SrcPieChart srcPieChartExpenses = new SrcPieChart(out,chartroot,session,startPeriodDate,endPeriodDate,dInAmount,
					    true,SHORT_DESC,iRecordToGet,sTitleExpenses,sOtherLabel[SESS_LANGUAGE]);
    
    SrcPieChart srcPieChartRevCompotition = new SrcPieChart(out,chartroot,session,startPeriodDate,endPeriodDate,dInAmount,
					    true,SHORT_DESC,iRecordToGet,sTitleRevCompotition,sOtherLabel[SESS_LANGUAGE]);
    
    SrcPieChart srcPieChartRevContribution = new SrcPieChart(out,chartroot,session,startPeriodDate,endPeriodDate,dInAmount,
					    true,SHORT_DESC,iRecordToGet,sTitleRevContribution,sOtherLabel[SESS_LANGUAGE]);
    
    SrcPieChart srcPieChartWorkingCapitalContribution = new SrcPieChart(out,chartroot,session,startPeriodDate,endPeriodDate,dInAmount,
					    true,SHORT_DESC,iRecordToGet,sTitleWorkingCapitalContribution,sOtherLabel[SESS_LANGUAGE]);
   
    String pathExpenses = ChartGenerator.generatePieChart(srcPieChartExpenses, I_ChartOfAccountGroup.ACC_GROUP_EXPENSE, ChartGenerator.PIE_CHART_EXPENSES);
    String pathRevCompotition = ChartGenerator.generatePieChart(srcPieChartRevCompotition, I_ChartOfAccountGroup.ACC_GROUP_REVENUE, ChartGenerator.PIE_CHART_REVENUE_COMPOSITION);
    String pathRevContribution = ChartGenerator.generatePieChart(srcPieChartRevContribution, I_ChartOfAccountGroup.ACC_GROUP_REVENUE, ChartGenerator.PIE_CHART_REVENUE_CONTRIBUTION);
    String pathWorkingCapitalContribution = ChartGenerator.generatePieChart(srcPieChartWorkingCapitalContribution, I_ChartOfAccountGroup.ACC_GROUP_EQUITY, ChartGenerator.PIE_CHART_NET_WORKING_CAPITAL);
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
<script type="text/javascript" src="../dtree/dtree.js"></script>
</head>
<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">  
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --> 
            <%=pageTitle[SESS_LANGUAGE][0]%> :  <font color="#CC3300"><%=pageTitle[SESS_LANGUAGE][1].toUpperCase()%></font> <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="test" method ="post" action="">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr align="left" valign="top"> 
			    <td><img src="<%=pathRevCompotition%>" border=0></td>
			    <!-- td><img src="<%//=path%>" border=0></td -->
			</tr>
			<tr align="left" valign="top"> 
			    <td><img src="<%=pathRevContribution%>" border=0></td>
			    <!-- td><img src="<%//=path%>" border=0></td -->
			</tr>
			<tr align="left" valign="top"> 
			    <td><img src="<%=pathExpenses%>" border=0></td>
			    <td><img src="<%=pathWorkingCapitalContribution%>" border=0></td>
			</tr>
		    </table>
		  </td>
                </tr>
              </table>
            </form>
            
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td height="100%"> 
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
          </td>
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
