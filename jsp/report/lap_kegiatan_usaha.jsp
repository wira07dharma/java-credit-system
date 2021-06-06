<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.report.*,
				 com.dimata.aiso.entity.report.*,
				 com.dimata.aiso.entity.periode.*,
				 com.dimata.aiso.entity.search.SrcLapKegiatanUsaha,
                 com.dimata.common.entity.contact.*,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.gui.jsp.ControlLine,
				 com.dimata.gui.jsp.*,
                 com.dimata.util.Command,
				 com.dimata.qdep.entity.I_DocStatus,
                 com.dimata.util.Formater" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privSubmit){
%>

<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>

<!-- if of "has access" condition -->
<%
}
else
{
%>

<!-- JSP Block -->
<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static String strTitle[][] = 
{
	{
		"No.",//0
		"Nama Agent/Tamu",//1
		"Pelayanan",//2
		"Penjualan",//3
        "No.Invoice",//4
		"Tunai",//5
		"Kredit",//6
		"Harga Pokok Penjualan",//7
		"Penyedia",//8
		"Faktur",//9
		"Saldo",//10
		"Keterangan",//11
		"Periode",//12
		"Tanggal",//13
		"s.d",//14
		"System tidak menemukan data yg dicari. Silahkan ulangi kembali"//15
	},
	{
		"No.",
		"Agent/Guest Name",
		"Service",
		"Sales",
        "Invoice No.",
		"Cash",
		"Credit",
		"Cost of Sales",
		"Supplier",
		"Ref No.",
		"Balance",
		"Description",
		"Periode",
		"Date",
		"To",
		"System can not found data. Please try again"
	}
};

public static final String masterTitle[] = 
{
	"Laporan",
	"Report"
};

public static final String listTitle[] = 
{
	"Kegiatan Usaha",
	"Bussiness Activity"
};


public Vector drawBussActivityReport(Vector objectClass, int language){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.addHeader(strTitle[language][0],"3%","2","0");// No
	ctrlist.addHeader(strTitle[language][1],"10%","2","0");//Agent
	ctrlist.addHeader(strTitle[language][2],"10%","2","0");//Service
	ctrlist.addHeader(strTitle[language][3],"10%","0","3");//Sales
	ctrlist.addHeader(strTitle[language][4],"10%","0","0");//Invoice No
	ctrlist.addHeader(strTitle[language][5],"10%","0","0");//Cash Sales
	ctrlist.addHeader(strTitle[language][6],"10%","0","0");//Credit Sales
	ctrlist.addHeader(strTitle[language][7],"10%","0","4");//CoGs
	ctrlist.addHeader(strTitle[language][8],"10%","0","0");//Supplier
	ctrlist.addHeader(strTitle[language][9],"10%","0","0");//Supplier Inv No
	ctrlist.addHeader(strTitle[language][5],"10%","0","0");//Cash Supplier
	ctrlist.addHeader(strTitle[language][6],"10%","0","0");//Credit Supplier
	ctrlist.addHeader(strTitle[language][10],"10%","2","0");//Balance
	ctrlist.addHeader(strTitle[language][11],"10%","2","0");//Description
	
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	Vector rowx = new Vector();
	Vector rowy = new Vector();
	Vector vDataToReport = new Vector();
	Vector vTotal = new Vector();
	Vector vResult = new Vector();
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int idx = 0;
	int index = -1;
	LapKegiatanUsaha objLapKegiatanUsaha = new LapKegiatanUsaha();
	double dAmountSales = 0.0;
	double dAmountSalesCredit = 0.0;
	double dAmountCosting = 0.0;
	double dAmountBalance = 0.0;
	try{
		for (int i = 0; i < objectClass.size(); i++){
			objLapKegiatanUsaha = (LapKegiatanUsaha)objectClass.get(i);
			
			String sts = "";
			if(objLapKegiatanUsaha.getInvoiceStatus() == I_DocStatus.DOCUMENT_STATUS_CANCELLED){
				if(objLapKegiatanUsaha.getDescription().length() == 0){
					sts = "Status Void";
				}else{
					sts = "Status Void, "+objLapKegiatanUsaha.getDescription();
				}
			}else{
				if(objLapKegiatanUsaha.getDescription().length() > 0){
					sts = objLapKegiatanUsaha.getDescription();
				}
			}
			
			rowx = new Vector();
			if((objLapKegiatanUsaha.getSalesAmount() + objLapKegiatanUsaha.getCreditSalesAmount()) == 0){
				rowx.add("");
				idx++;
			}else{
				rowx.add("<div align=\"center\">"+(i+1-idx)+"</div>");
				idx = 0;
			}
			rowx.add(objLapKegiatanUsaha.getAgent());
            rowx.add(objLapKegiatanUsaha.getService());
            rowx.add(objLapKegiatanUsaha.getInvNumber());
			if((objLapKegiatanUsaha.getSalesAmount() + objLapKegiatanUsaha.getCreditSalesAmount()) == 0){
				rowx.add("");
				rowx.add("");
			}else{
            	rowx.add("<div align=\"right\">"+Formater.formatNumber(objLapKegiatanUsaha.getSalesAmount(), "##,###")+"</div>");
				rowx.add("<div align=\"right\">"+Formater.formatNumber(objLapKegiatanUsaha.getCreditSalesAmount(), "##,###")+"</div>");
			}
			rowx.add(objLapKegiatanUsaha.getSupplier());
			rowx.add(objLapKegiatanUsaha.getReference());
			rowx.add("");
			rowx.add("<div align=\"right\">"+Formater.formatNumber(objLapKegiatanUsaha.getCostingAmount(),"##,###")+"</div>");
			rowx.add("<div align=\"right\">"+Formater.formatNumber(objLapKegiatanUsaha.getBalance(), "##,###")+"</div>");
			rowx.add(sts);
			
			dAmountSales += objLapKegiatanUsaha.getSalesAmount();
			dAmountCosting += objLapKegiatanUsaha.getCostingAmount();
			dAmountSalesCredit += objLapKegiatanUsaha.getCreditSalesAmount();
            lstData.add(rowx);
			
			rowy = new Vector();
			rowy.add(objLapKegiatanUsaha.getAgent());//0
            rowy.add(objLapKegiatanUsaha.getService());//1
            rowy.add(objLapKegiatanUsaha.getInvNumber());//2
            rowy.add(Formater.formatNumber(objLapKegiatanUsaha.getSalesAmount(), "##,###"));//3
			rowy.add(Formater.formatNumber(objLapKegiatanUsaha.getCreditSalesAmount(), "##,###"));//4
			rowy.add(objLapKegiatanUsaha.getSupplier());//5
			rowy.add(objLapKegiatanUsaha.getReference());//6
			rowy.add("");//7
			rowy.add(Formater.formatNumber(objLapKegiatanUsaha.getCostingAmount(),"##,###"));//8
			rowy.add(Formater.formatNumber(objLapKegiatanUsaha.getBalance(), "##,###"));//9
			rowy.add(sts);//10
			vDataToReport.add(rowy);
		}
		
		rowx = new Vector();
		rowx.add("");
		rowx.add("<b>TOTAL</b>");
		rowx.add("");
		rowx.add("");
		rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(dAmountSales, "##,###")+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(dAmountSalesCredit, "##,###")+"</b></div>");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(dAmountCosting,"##,###")+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(((dAmountSales + dAmountSalesCredit) - dAmountCosting), "##,###")+"</b></div>");
		rowx.add("");
			
		lstData.add(rowx);
		vTotal.add(Formater.formatNumber(dAmountSales, "##,###"));//0
		vTotal.add(Formater.formatNumber(dAmountSalesCredit, "##,###"));//1
		vTotal.add(Formater.formatNumber(dAmountCosting,"##,###"));//2
		vTotal.add(Formater.formatNumber(((dAmountSales + dAmountSalesCredit) - dAmountCosting), "##,###"));//3
     }catch(Exception e){
	 	System.out.println("EXc : "+e.toString());
	 }		
	 vResult.add(ctrlist.drawList()); 	
	 vResult.add(vDataToReport);	
	 vResult.add(vTotal);						
	 return vResult;
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
long periodId = FRMQueryString.requestLong(request,SessWorkSheet.FRM_NAMA_PERIODE);
int iQueryType = FRMQueryString.requestInt(request,"query_type");
int iDate = FRMQueryString.requestInt(request,"date_from_dy");
int iMonth = FRMQueryString.requestInt(request,"date_from_mn");
int iYear = FRMQueryString.requestInt(request,"date_from_yr"); 
int iDateTo = FRMQueryString.requestInt(request,"date_to_dy");
int iMonthTo = FRMQueryString.requestInt(request,"date_to_mn");
int iYearTo = FRMQueryString.requestInt(request,"date_to_yr"); 
int vectSize = 0;

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Invoice" : "Invoice";
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
String strCmdPrint[] = {"Cetak Laporan", "Print Report"};
String strReportShortName = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "BAR" : "LKU";
String strReportName = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "(BISNIS ACTIVITY REPORT)" : "(LAPORAN KEGIATAN USAHA)";
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Report Search" : "Kembali Ke Pencarian Laporan";
String pathImage = reportrootimage+"company121.jpg";

SrcLapKegiatanUsaha srcLapKegiatanUsaha = new SrcLapKegiatanUsaha();
Date dateFrom = null;
Date dateTo = null;
if(iCommand == Command.LIST){
		dateFrom = new Date(iYear - 1900, iMonth - 1, iDate);
		dateTo = new Date(iYearTo - 1900, iMonthTo - 1, iDateTo);
		srcLapKegiatanUsaha.setDateFrom(dateFrom);
		srcLapKegiatanUsaha.setDateTo(dateTo);
}
	
SessLKU sessLKU = new SessLKU();
Vector vListLKU = new Vector(1,1);
Vector vTempList = new Vector(1,1);
Vector vDataToReport = new Vector(1,1);
Vector vTotal = new Vector(1,1);
Vector vDataToSession = new Vector(1,1);
String strListReport = "";
String strDepReport = "";
strDepReport = iQueryType == 6? "TOUR" : "TICKETING";
if(iCommand == Command.LIST){
	try{
		if(iQueryType == 6){
			vListLKU = sessLKU.listLapKegiatanUsaha(periodId, srcLapKegiatanUsaha, 1);
		}else{	
			vListLKU = sessLKU.listLapKegiatanUsaha(periodId, srcLapKegiatanUsaha);
		}
		if(vListLKU != null && vListLKU.size() > 0){
			vTempList = (Vector)drawBussActivityReport(vListLKU, SESS_LANGUAGE);
			if(vTempList != null && vTempList.size() > 0){
				strListReport = vTempList.get(0).toString();
				vDataToReport = (Vector)vTempList.get(1);
				vTotal = (Vector)vTempList.get(2);
			}
		}
	}catch(Exception e){vListLKU = new Vector(1,1);}  
}
 
Vector vListTitle = new Vector(1,1);
for(int t = 0; t < strTitle[SESS_LANGUAGE].length; t++){
	vListTitle.add(strTitle[SESS_LANGUAGE][t]);
}

vDataToSession.add(vDataToReport);// 0
vDataToSession.add(vListTitle);// 1
vDataToSession.add(strReportShortName);// 2
vDataToSession.add(strReportName);// 3
vDataToSession.add(pathImage);// 4
vDataToSession.add(vTotal);// 5
vDataToSession.add(strDepReport);// 6
vDataToSession.add(Formater.formatDate(dateFrom, "dd MMM yyyy"));// 7
vDataToSession.add(Formater.formatDate(dateTo, "dd MMM yyyy"));// 8

if(session.getValue("LKU") != null){
	session.removeValue("LKU");
}

session.putValue("LKU",vDataToSession);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
function getThn(){
	var date1 = ""+document.frmreportlku.date_from.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.frmreportlku.date_from_mn.value=bln;
	document.frmreportlku.date_from_dy.value=hri;
	document.frmreportlku.date_from_yr.value=thn;
	
	var date2 = ""+document.frmreportlku.date_to.value;
	var thn1 = date2.substring(6,10);
	var bln1 = date2.substring(3,5);	
	if(bln1.charAt(0)=="0"){
		bln1 = ""+bln1.charAt(1);
	}
	
	var hri1 = date2.substring(0,2);
	if(hri1.charAt(0)=="0"){
		hri1 = ""+hri1.charAt(1);
	}
	
	document.frmreportlku.date_to_mn.value=bln1;
	document.frmreportlku.date_to_dy.value=hri1;
	document.frmreportlku.date_to_yr.value=thn1;		
}

function report(){
	document.frmreportlku.command.value ="<%=Command.LIST%>";
	document.frmreportlku.action = "lap_kegiatan_usaha.jsp";
	document.frmreportlku.submit();
}

function cmdBack(){
	document.frmreportlku.command.value ="<%=Command.BACK%>";
	document.frmreportlku.action = "lap_kegiatan_usaha.jsp";
	document.frmreportlku.submit();
}

function reportPdf(){	 
	var linkPage = "<%=reportroot%>report.lapKegiatanUsaha.LapKegiatanUsahaPdf";       
	window.open(linkPage);  				
}

function hideObjectForDate(){
}
	
function showObjectForDate(){
}

</script>
<link rel="stylesheet" href="../style/calendar.css" type="text/css">
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
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
		  <%if(isUseDatePicker.equalsIgnoreCase("Y")){%> 
      		<table class="ds_box" cellpadding="0" cellspacing="0" id="ds_conclass" style="display: none;">
			<tr><td id="ds_calclass">
			</td></tr>
			</table>
			<script language=JavaScript src="<%=approot%>/main/calendar.js"></script>
			<%}%>	
		  <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%>&nbsp;(<%=strDepReport%>)</font>
		  <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmreportlku" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>"> 
			  <input type="hidden" name="query_type" value="<%=iQueryType%>"> 
              <table width="100%">
			  	<tr>
			  	  <td>
				 <table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
			  <tr>
			  <td>
				  	<table width="100%" border="0" class="listgensellOdd">
                <tr>
                  <td height="23" id="up">&nbsp;</td>
                  <td height="23">&nbsp;</td>
                  <td height="23" colspan="3">&nbsp;</td>
                </tr>
                <tr><!-- start search -->
                  <td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][12]%></td>
                  <td height="23" width="2%">
                    <div align="center">:</div>
                  </td>
                  <td height="23" colspan="3">                  <%
				  	  String sOrderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL]+" DESC";	
                      Vector vtPeriod = PstPeriode.list(0,0,"",sOrderBy);
                      Vector vPeriodKey = new Vector(1,1);
                      Vector vPeriodVal = new Vector(1,1);
                      for(int k=0;k<vtPeriod.size();k++){
                        Periode periode = (Periode)vtPeriod.get(k);

                        vPeriodKey.add(""+periode.getOID());
                        vPeriodVal.add(periode.getNama());
                      }
                      out.println(ControlCombo.draw(SessWorkSheet.FRM_NAMA_PERIODE,"",null,""+periodId,vPeriodKey,vPeriodVal,""));
				  %>
                    </td>
                </tr>
                <tr>
                  <td height="23"><%=strTitle[SESS_LANGUAGE][13]%></td>
                  <td height="23"><div align="center">:</div></td>
                  <td width="14%" height="23">   										   
							  <input onClick="ds_sh(this);" size="14" name="date_from" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcLapKegiatanUsaha.getDateFrom() == null? new Date() : srcLapKegiatanUsaha.getDateFrom()), "dd-MM-yyyy")%>"/> 						  
							  <input type="hidden" name="date_from_mn">
							  <input type="hidden" name="date_from_dy">
							  <input type="hidden" name="date_from_yr">	
						 
				  </td>
                  <td width="3%"><div align="center"><%=strTitle[SESS_LANGUAGE][14]%></div></td>
                  <td width="70%">
				  										   										   
							  <input onClick="ds_sh(this);" size="14" name="date_to" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcLapKegiatanUsaha.getDateTo() == null? new Date() : srcLapKegiatanUsaha.getDateTo()), "dd-MM-yyyy")%>"/> 						  
							  <input type="hidden" name="date_to_mn">
							  <input type="hidden" name="date_to_dy">
							  <input type="hidden" name="date_to_yr">	
							  <script language="JavaScript" type="text/JavaScript">getThn();</script>				
				  </td>
                </tr>
                <tr>
                  <td width="11%" height="23"><%//=strTitle[SESS_LANGUAGE][9]%></td>
                  <td height="23" width="2%">
                    <!-- <div align="center">:</div> -->
                  </td>
                  <td height="23" colspan="3">&nbsp;</td>
                </tr>
                <tr>
                  <td height="23" colspan="5">&nbsp;</td>
                </tr>
                <tr>
                  <td width="11%" height="23">&nbsp;</td>
                  <td height="23" width="2%">
                    <div align="center"><b></b></div>
                  </td>
                  <td height="23" colspan="3"><input type="button" value="<%=strReport%>" onClick="javascript:report()"></td>
                </tr><!-- end search-->
				</table>
				</td>
				</tr>
				</table>
				  </td>
		  	    </tr>
			  	<tr>
				<td>	  
				<%if((vListLKU!=null)&&(vListLKU.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(strListReport);
				  %>
				  </td>
				</tr>
				<tr>
				<td>
                <%} else {%>
                <%if(iCommand == Command.LIST){%> </td>
				</tr>
				<tr>
				<td>
				<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
				<tr>
					<td>
					  <table width="100%" border="0" cellspacing="2" cellpadding="0" class="listgensellOdd">		
					  	<tr><td>&nbsp;</td></tr>		
						<tr> 
						  <td><div align="center"><span class="errfont"><%=strTitle[SESS_LANGUAGE][15]%></span></div></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					  </table>
					  </td>
				 </tr>
				 </table> 
                <%  }
				}	%>
				</td>
				</tr>
				<%if(iCommand == Command.LIST){%>
				<tr>
				<td>
				  <table width="100%" border="0" cellspacing="2" cellpadding="0">
						<tr> 
						  <td height="16" class="command"><input name="btnPrint" type="button" onClick="javascript:cmdBack()" value="<%=strBack%>"></td>
						  <td width="83%" nowrap><input name="btnPrint" type="button" onClick="javascript:reportPdf()" value="<%=strCmdPrint[SESS_LANGUAGE]%>"></td>
						</tr>
				  </table>
			  </td>
			  </tr>
			  <%}%>
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
<!-- endif of "has access" condition -->
<%}%>