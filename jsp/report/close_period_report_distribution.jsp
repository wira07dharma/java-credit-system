<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>
<! -- 
  !!!! PAGE INI HANYA DIPAKAI UNTUK MELAKUKAN CLOSING PERIOD UNTUK REPORT DISTRIBUTION SECARA MANUAL IN CASE PROSES CLOSE PERNAH GAGAL TERJADI
  -->
<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*,
                 com.dimata.util.Formater,
                 com.dimata.util.Command,
                 com.dimata.harisma.entity.masterdata.PstDepartment,
                 com.dimata.harisma.entity.masterdata.Department,
                 com.dimata.aiso.entity.periode.PstPeriode,
                 com.dimata.aiso.entity.periode.Periode,
                 com.dimata.aiso.entity.masterdata.Perkiraan,
                 com.dimata.interfaces.chartofaccount.I_ChartOfAccountGroup,
                 com.dimata.aiso.entity.masterdata.PstPerkiraan" %>

<!--import java-->
<%@ page import="java.util.Date" %>
<%@ page import="com.dimata.aiso.session.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.BussinessCenter" %>
<%@ page import="com.dimata.aiso.entity.masterdata.PstBussinessCenter"%>  
<%@ page import="com.dimata.aiso.form.jurnal.FrmJournalDistribution" %>
<%@ page import="com.dimata.aiso.session.report.villamanagement.*" %>

<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_TRIAL_BALANCE, AppObjInfo.OBJ_REPORT_TRIAL_BALANCE_PRIV); %>
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

int FLAG_PRINT = 0;

public static String strTitle[][] = {
	{"Periode","Bisnis Center"},

	{"Period","Business Center"}
};

public static String strHeader[][] = {
	{"Perkiraan","Desember","Perubahan","Dalam Jutaan Rp","%"},
	{"Account","as of","Changes","IDR Mio","%"}	
};

private static final String strTitleReporPDF[][] = {
	{"OWNER'S DISTRIBUTION REPORT","Per","dalam jutaan Rp."},
	{"OWNER'S DISTRIBUTION REPORT","As of","in IDR Mio"}
};

public static final String masterTitle[] = {
	"OWNER'S DISTRIBUTION REPORT","OWNER'S DISTRIBUTION REPORT"
};


public static String formatStringNumber(double dbl, FRMHandler frmHandler){
    if(Double.isInfinite(dbl))
        return String.valueOf(frmHandler.userFormatStringDecimal(0.0));
    if(Double.isNaN(dbl))
        return String.valueOf(frmHandler.userFormatStringDecimal(0.0));

    if(dbl<0)
        return "("+String.valueOf(frmHandler.userFormatStringDecimal(dbl * -1))+")";
    else
        return String.valueOf(frmHandler.userFormatStringDecimal(dbl));
}


/** dwi 2007/05/24
 * For value format
 * @param double that will be formatted
 * @return String formatted value
 */
	 
private static String formatNumber(double dblValue){
	String strValue = "";	
	if(dblValue < 0)
		strValue = "<div align=\"right\">("+Formater.formatNumber(dblValue * -1, "##,###.##")+")</div>";
	else
		strValue = "<div align=\"right\">"+Formater.formatNumber(dblValue, "##,###.##")+"</div>";		
	return 	strValue;
}

/** dwi 2007/05/24
 * For value format PDF
 * @param double that will be formatted
 * @return String formatted value
 */
	 
private static String formatNumberPDF(double dblValue){
	String strValue = "";	
	if(dblValue < 0)
		strValue = "("+Formater.formatNumber(dblValue * -1, "##,###.##")+")";
	else
		strValue = Formater.formatNumber(dblValue, "##,###.##");		
	return 	strValue;
}


%>

<!-- JSP Block -->
<%

    int iCommand = FRMQueryString.requestCommand(request);
    long busCenterId= FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_BUSS_CENTER_ID]);
    BussinessCenter bCenter=null;
    long periodId = FRMQueryString.requestLong(request,"period_id");
    long oidDepartment = FRMQueryString.requestLong(request,"DEPARTMENT");
    String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
	String strBack[] = {"Kembali ke Pencarian", "Back to Search"};
    String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
    Date today = new Date();
	String strPrint = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Print Report" : "Cetak Laporan";
	String strExpToExcel = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Export to Excel" : "Ekspor ke Excel";
	String linkPdf = reportrootfooter+"report.neraca.BalanceSheetDeptPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String linkXls = reportrootfooter+"report.neraca.BalanceSheetDeptXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String strPathImage = reportrootimage+"company121.jpg";
	String nameperiode = "";
	String prevPeriodeName = "";
    String namedepartment = ""; 
	
	FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSymbol); 
	frmHandler.setDigitSeparator(sUserDigitGroup);
	
    Vector list = new Vector();
	String currYear = "";
	String prevYear = "";
    if(iCommand==Command.LIST)
        list = null;
		
	try{
            Periode period = PstPeriode.fetchExc(periodId);
			//long preOidPeriod = SessWorkSheet.getOidPeriodeLalu(periodId);	
			Date prevDate = (Date)period.getTglAwal();		
			if(prevDate.getMonth() == 0){
				prevDate.setMonth(11);
				prevDate.setYear(prevDate.getYear() - 1);
				prevPeriodeName = Formater.formatShortMonthyYear(prevDate);
			}else{
				prevDate.setMonth(prevDate.getMonth() - 1);
				prevPeriodeName = Formater.formatShortMonthyYear(prevDate);
			}
			Date currDate = (Date)period.getTglAkhir();
            nameperiode = Formater.formatShortMonthyYear(currDate);	
			namedepartment = "";//PstDepartment.fetchExc(oidDepartment).getDepartment();
			
    }catch(Exception e){
		System.out.println("Exception on fetch periode ::::: "+e.toString());
	}
	
        try{
            bCenter= PstBussinessCenter.fetchExc(busCenterId);            
        }catch(Exception exc){
		System.out.println("Exception on fetch Business Center ::::: "+exc.toString());            
        }
        if( bCenter==null ){
            bCenter = new BussinessCenter();
            
        }
        
	
	if(session.getValue("OWNER_DISTRIBUTION")!=null){   
		session.removeValue("OWNER_DISTRIBUTION");
	}	

/**
* Declare Commands caption
*/
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">
function report(){
        document.frmTrialBalance.command.value ="<%=Command.LIST%>";
        document.frmTrialBalance.action = "close_period_report_distribution.jsp";
        document.frmTrialBalance.submit();
}

function cmdBack(){
	document.frmTrialBalance.command.value ="<%=Command.BACK%>";
	document.frmTrialBalance.action = "close_period_report_distribution.jsp#up";
	document.frmTrialBalance.submit();
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

function reportPdf(){	 
		var linkPage = "<%=reportroot%>report.neraca.BalanceSheetSummaryPdf";       
		window.open(linkPage);  				
}

function printXLS(){	 
		var linkPage = "<%=reportroot%>report.villamanagement.OwnerDistributionReportXls";       
		window.open(linkPage);  				
}

</SCRIPT>
<!-- #EndEditable -->
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
            <%=masterTitle[SESS_LANGUAGE]%> <font color="#CC3300"><%=""%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmTrialBalance" method="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="2">&nbsp;
                  </td>
                </tr>
              </table>
			  <%if(privView && privSubmit){%>
              <table width="100%" border="0" height="94">
                <tr>
                  <td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="23" width="2%">
                    <div align="center">:</div></td>
                  <td height="23" width="1%">
                    <%
                      String sOrderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL]+" DESC";
                      Vector vtPeriod = PstPeriode.list(0,0,"",sOrderBy);
                      Vector vPeriodKey = new Vector(1,1);
                      Vector vPeriodVal = new Vector(1,1);
                      for(int k=0;k<vtPeriod.size();k++){
                        Periode periode = (Periode)vtPeriod.get(k);

                        vPeriodKey.add(""+periode.getOID());
                        vPeriodVal.add(periode.getNama());
                      }
                      out.println(ControlCombo.draw("period_id","",null,""+periodId,vPeriodKey,vPeriodVal,""));
				  %>                  </td> 
                </tr>
                <tr>
                  <td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td height="23" width="2%">
                    <!-- <div align="center">:</div></td> -->
                  <td height="23" width="87%"><%
                  	Vector vBisnisCenterVal = new Vector();
	Vector vBisnisCenterKey = new Vector();
	String selectedBisnisCenter = ""+busCenterId;
        Vector vBisnisCenter = PstBussinessCenter.list(0,0,"",PstBussinessCenter.fieldNames[PstBussinessCenter.FLD_BUSS_CENTER_NAME]);
	if(vBisnisCenter.size() > 0){
		for(int b = 0; b < vBisnisCenter.size(); b++){
			BussinessCenter objBCenter = (BussinessCenter)vBisnisCenter.get(b);			
			vBisnisCenterVal.add(""+objBCenter.getOID()); 
			vBisnisCenterKey.add(objBCenter.getBussCenterName());
		}
	}

                %>
                      <%=ControlCombo.draw((FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_BUSS_CENTER_ID]), "-",  selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey,"","")%>                    </td>
                </tr>
               
                <tr>
                  <td width="11%" height="23">&nbsp;</td>
                  <td height="23" width="2%">
                    <div align="center"><b></b></div></td>
                  <td height="23" width="87%"><input name="btnViewReport" type="button" onClick="javascript:report()" value="<%=strReport%>"></td>
                </tr>
                <tr>
                  <td colspan="3" height="2">&nbsp;</td>
                </tr>
                <%if(iCommand==Command.LIST){%>
                <tr>
                  <td colspan="3" height="2"></td>
                </tr>
                <!--tr>
                  <td colspan="3" height="2">&nbsp;&nbsp;<b>VILLA NAME : <%=bCenter.getBussCenterName()%></td>
                </tr>
                <tr>
                  <td colspan="3" height="2">&nbsp;&nbsp;<b><%=masterTitle[SESS_LANGUAGE]%></b></td>
                </tr>
                <tr>
                  <td colspan="3" height="2">&nbsp;</td>
                </tr-->
                <tr>
                  <td colspan="3" height="2"> 
				  <%     
                                    try{
                                    SessJournalDistribution.closeJournalDistribution(periodId);
                                    } catch(Exception exc){
                                        System.out.println(" EXCEPTION "+ exc);
                                    }
				    OwnerDistributionReport own = new OwnerDistributionReport(busCenterId, periodId);
                                    own.loadReportByAccounts(OwnDisRepAccount.clientAdvance,OwnDisRepAccount.villaRevenue,OwnDisRepAccount.managementExpense,
                                            OwnDisRepAccount.varDirectOpExpense, OwnDisRepAccount.fixDirectOpExpense,
                                            OwnDisRepAccount.indirectOpExpense,OwnDisRepAccount.otherVillaOpExpense,OwnDisRepAccount.commisionAndFee,
                                            OwnDisRepAccount.commonArea,OwnDisRepAccount.clientContribution);
                                    session.putValue("OWNER_DISTRIBUTION",own);
				  %>
				  <table class="listarea"><tr><td>
				  <table class="listgen" width="100%" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                      <th class="listgentitle" scope="col">Acc.Nr</th>
                      <th class="listgentitle" scope="col">Account Name </th>
                      <th class="listgentitle" scope="col">&nbsp;</th>
                      <th class="listgentitle" scope="col">&nbsp;<%=(own.getPrev2Period()!=null ? own.getPrev2Period().getNama() : "")%></th>
                      <th class="listgentitle" scope="col">&nbsp;<%=(own.getPrev1Period()!=null ? own.getPrev1Period().getNama() : "")%></th>
                      <th class="listgentitle" scope="col">&nbsp;<%=(own.getCurrentPeriod()!=null ? own.getCurrentPeriod().getNama() : "")%></th>
                      <th class="listgentitle" scope="col">&nbsp;</th>
                    </tr>
                    <tr>
                      <td class="listgentitle2">&nbsp;</td>
                      <td class="listgentitle2">&nbsp;BALANCE PLUS(MINUS) ADVANCE PAYMENT PREVIOUS PERIOD</td>
                      <td class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(own.getPrev3PerBalnc().getAdvance_pay_balance(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(own.getPrev2PerBalnc().getAdvance_pay_balance(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(own.getPrev1PerBalnc().getAdvance_pay_balance(),"###,###.##")%></td>
                      <td class="listgentitle2">&nbsp;</td>
                    </tr>
                    <%
                        for (int idx = 0; idx < own.getClientAdvanceSize(); idx++) {
                            OwnDisRepAccount item = (OwnDisRepAccount) own.getClientAdvance(idx);
                    %>
                    <tr>
                      <td class="listgensell">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="listgensell">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <% } %>
                    <tr>
                      <td class="listgentitle2">&nbsp;</td>
                      <td class="listgentitle2">&nbsp;BALANCE ADVANCE PAYMENT
                      <%
                       OwnDisRepAccount balAdvPay =  own.getBalanceAdvancePayment();
                      %>
                      </td>
                      <td class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(balAdvPay.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(balAdvPay.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(balAdvPay.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgentitle2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    
                    <%
                        for (int idx = 0; idx < own.getVillaRevenueSize(); idx++) {
                                OwnDisRepAccount item = (OwnDisRepAccount) own.getVillaRevenue(idx);
                    %>
                    <tr>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <% } %>
                    <%
                        for (int idx = 0; idx < own.getManagementExpenseSize(); idx++) {
                            OwnDisRepAccount item = (OwnDisRepAccount) own.getManagementExpense(idx);
                    %>
                    <tr>
                      <td class="listgensell">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="listgensell">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <% } %>
                    <tr>
                      <td class="listgentitle2">&nbsp;</td>
                      <td class="listgentitle2">&nbsp;VILLA GROSS REVENUE
                      <%
                        OwnDisRepAccount vGrosRev = own.getVillaGrossRevenue();                                              
                      %></td>
                      <td class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vGrosRev.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vGrosRev.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vGrosRev.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgentitle2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>                                                            
                    <%
                        for (int idx = 0; idx < own.getVarDirectOpExpense().size(); idx++) {
                            OwnDisRepAccount item = (OwnDisRepAccount) own.getVarDirectOpExpense().get(idx);
                    %>
                    <tr>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                    </tr>
                    <% } %>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <%
                        for (int idx = 0; idx < own.getFixDirectOpExpense().size(); idx++) {
                            OwnDisRepAccount item = (OwnDisRepAccount) own.getFixDirectOpExpense().get(idx);
                    %>
                    <tr>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                    </tr>
                    <% } %>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <%
                        for (int idx = 0; idx < own.getIndirectOpExpense().size(); idx++) {
                            OwnDisRepAccount item = (OwnDisRepAccount) own.getIndirectOpExpense().get(idx);
                    %>
                    <tr>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                    </tr>
                    <% } %>                    
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <%
                        for (int idx = 0; idx < own.getOtherVillaOpExpense().size(); idx++) {
                            OwnDisRepAccount item = (OwnDisRepAccount) own.getOtherVillaOpExpense().get(idx);
                    %>
                    <tr>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                    </tr>
                    <% } %>                                        
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <%
                        for (int idx = 0; idx < own.getCommisionAndFee().size(); idx++) {
                            OwnDisRepAccount item = (OwnDisRepAccount) own.getCommisionAndFee().get(idx);
                    %>
                    <tr>
                      <td class="<%=(idx>-1?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="<%=(idx>-1?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="<%=(idx>-1?"listgensell":"listgentitle2")%>">&nbsp;</td>
                      <td align="right" valign="middle" class="<%=(idx>-1?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>-1?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>-1?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="<%=(idx>-1?"listgensell":"listgentitle2")%>">&nbsp;</td>
                    </tr>
                    <% } %>
                    
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <%
                        for (int idx = 0; idx < 1; idx++) { // only show the summary of common area cost
                            OwnDisRepAccount item = (OwnDisRepAccount) own.getCommonArea().get(idx);
                    %>
                    <tr>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                    </tr>
                    <% } %>

                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgentitle2">&nbsp;</td>
                      <td class="listgentitle2">&nbsp;VILLA EXPENSES</td>
                      <%
                        OwnDisRepAccount vExpense = own.getSumVillaExpenses();                                              
                      %></td>
                      <td class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vExpense.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vExpense.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vExpense.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgentitle2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgentitle2">&nbsp;</td>
                      <td class="listgentitle2">&nbsp;BALANCE REVENUE DUE TO OWNER</td>
                      <%
                        OwnDisRepAccount vBalRev = own.getBalanceRevDueToOwner();                                              
                      %></td>
                      <td class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vBalRev.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vBalRev.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vBalRev.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgentitle2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp; </td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <%
                        for (int idx = 0; idx < own.getClientContribution().size(); idx++) {
                            OwnDisRepAccount item = (OwnDisRepAccount) own.getClientContribution().get(idx);
                    %>
                    <tr>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNoPerkiraan()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=item.getAccount().getNama()%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;<%=Formater.formatNumber(item.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="<%=(idx>0?"listgensell":"listgentitle2")%>">&nbsp;</td>
                    </tr>
                    <% } %>
                    
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgentitle2">&nbsp;</td>
                      <td class="listgentitle2">&nbsp;BALANCE FUND TO OWNER</td>
                      <td class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;</td>
                      <td class="listgentitle2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgentitle2">&nbsp;</td>
                      <td class="listgentitle2">&nbsp;BALANCE THREE MONTHS OPERATIONAL EXP.</td>
                      <%
                        OwnDisRepAccount vBal3Month = own.getBalance3MonthOpExp();                                              
                      %></td>
                      <td class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vBal3Month.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vBal3Month.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(vBal3Month.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgentitle2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;Three months operational expenses projection</td>
                      <%
                        OwnDisRepAccount v3MontOpPrj = own.getThreeMonthsOpProjection();                                              
                      %></td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(v3MontOpPrj.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(v3MontOpPrj.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(v3MontOpPrj.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;40% ofTotal Three months operational</td>
                      <%
                        OwnDisRepAccount vProc3Month = own.getProcentOfThreeMonthsOpProj();                                              
                      %></td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(vProc3Month.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(vProc3Month.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;<%=Formater.formatNumber(vProc3Month.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgentitle2">&nbsp;</td>
                      <td class="listgentitle2">&nbsp;Balance Amount to be TOPPED UP for three months operational expenses</td>
                      <%
                        OwnDisRepAccount topUp = own.getBalAmountTopUp();                                              
                      %></td>
                      <td class="listgentitle2">&nbsp;</td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(topUp.getPrev2PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(topUp.getPrev1PeriodSaldo(),"###,###.##")%></td>
                      <td align="right" valign="middle" class="listgentitle2">&nbsp;<%=Formater.formatNumber(topUp.getThisPeriodSaldo(),"###,###.##")%></td>
                      <td class="listgentitle2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td align="right" valign="middle" class="listgensell">&nbsp;</td>
                      <td class="listgensell">&nbsp;</td>
                    </tr>

                  </table></td></tr></table></td>
                </tr>
                <tr>
                  <td colspan="3" height="2"><table width="18%" border="0" cellspacing="1" cellpadding="1">
                    <tr>
                      <td width="83%" nowrap><!--input name="btnPrint" type="button" onClick="javascript:reportPdf()" value="<%=strPrint%>"--></td>
                      <td width="83%" nowrap><input name="btnExport" type="button" onClick="javascript:printXLS()" value="<%=strExpToExcel%>"></td>
					  <td width="83%" nowrap><input name="btnBack" type="button" onClick="javascript:cmdBack()" value="<%=strBack[SESS_LANGUAGE]%>"></td>
                    </tr>
                  </table></td>
                   </tr>
                <%if(FLAG_PRINT == 1){%>
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <%}%>
              </table>
			  <%}else{%>
			   	<%if(iCommand == Command.LIST){%>
			   	<table width="100%">
					<tr><td class="msgerror"><%=strTitle[SESS_LANGUAGE][8]%></td></tr>
				</table>
				<%}%>
			   <%}%>
              <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][2]%></i></font></td>
                </tr>
              </table>
			  <%}%>
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
<!-- endif of "has access" condition -->
<%}%>