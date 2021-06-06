<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>
<!--import aiso-->
<%@ page import = "com.dimata.util.*,
                   com.dimata.aiso.entity.periode.PstPeriode,
                   com.dimata.aiso.entity.periode.Periode,
                   com.dimata.aiso.form.jurnal.CtrlJurnalDetail,
                   com.dimata.aiso.form.jurnal.FrmJurnalDetail,
                   com.dimata.aiso.entity.masterdata.PstPerkiraan,
                   com.dimata.aiso.entity.masterdata.Perkiraan,
			 	   com.dimata.aiso.entity.jurnal.*,
                   com.dimata.aiso.session.report.SessGeneralLedger,
                   com.dimata.gui.jsp.ControlCombo,
                   com.dimata.gui.jsp.ControlList,
                   com.dimata.aiso.entity.report.GeneralLedger,
                   com.dimata.harisma.entity.masterdata.PstDepartment,
                   com.dimata.harisma.entity.masterdata.Department,
                   com.dimata.aiso.session.jurnal.SessJurnal,
                   com.dimata.gui.jsp.ControlDate,
				   com.dimata.aiso.session.report.*,
				   com.dimata.aiso.entity.report.*,
				   com.dimata.aiso.entity.masterdata.PstActivity,
				   com.dimata.qdep.system.*,
				   com.dimata.aiso.session.admin.*,
				   com.dimata.aiso.entity.admin.*"%>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_GNR_LEDGER, AppObjInfo.OBJ_REPORT_GNR_LEDGER_PRIV); %>
<%@ include file = "../../main/checkuser.jsp" %>
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

private static String strTitle[][] = {
	{"Nama Proyek","Program Utama","Alokasi Program Pendukung","Total","Total Pembiayaan","Keterangan","Jumlah","Periode","Total Program Pendukung","dalam Jt-an Rupiah"},
	{"IFC Component","Programmatic","Support Allocation","Total by IFC Component","Total Expenditure","Description","Amount","Period","Total Support","In IDR mio"}
};

private static final String masterTitle[] = {
	"Laporan","Report"	
};

private static final String listTitle[] = {
	"Laporan ke Donor","Consolidated Monthly IFC Report"	
};

private static String numberFormat(double value){
	String valueFormat = "";
		try{
			if(value < 0){
				valueFormat = "("+Formater.formatNumber((value * -1), "##,###.##")+")";
			}else{
				valueFormat = Formater.formatNumber(value, "##,###.##");
			}
			
		}catch(Exception e){
			valueFormat = "";
			System.out.println("Exception on numberFormat() ::: "+e.toString());
		}
	
	return valueFormat;
}


/**
 * dwi
 * @param objectClass
 * @param language
 * @return Vector result
 */
public Vector drawDonorReport(Vector objectClass, int language, double valueReport){
    Vector result = new Vector(1,1);
	Vector vectDataToReport = new Vector(1,1);
	Vector vectContentToReport = new Vector(1,1);
	Vector vectSubTotalToReport = new Vector(1,1);
	
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("100%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");	
    ctrlist.addHeader(strTitle[language][0],"30%","0","0");
    ctrlist.addHeader(strTitle[language][1],"20%","0","0");
    ctrlist.addHeader(strTitle[language][2],"20%","0","0");
    ctrlist.addHeader(strTitle[language][3],"25%","0","0");
       
    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.reset();
	
	double valueProgramatic = 0.0;
	double valueSupport = 0.0;
	int level = 0;
	
	Vector rowx = new Vector();
	Vector rowr = new Vector();
	
	DonorReport objDonorReport = new DonorReport();
	
    if(objectClass != null && objectClass.size() > 0){
		try{
			for(int i = 0; i < objectClass.size(); i++){
				objDonorReport = (DonorReport)objectClass.get(i);
				level = objDonorReport.getLevel();
				
				rowx = new Vector();				
				rowx.add(objDonorReport.getActDescription());
				rowx.add("<div align=\"right\">"+numberFormat(objDonorReport.getMtdAmount() / valueReport)+"</div>");				
				rowx.add("<div align=\"right\">"+numberFormat(objDonorReport.getSptAmount() / valueReport)+"</div>");
				rowx.add("<div align=\"right\">"+numberFormat((objDonorReport.getMtdAmount() + objDonorReport.getSptAmount()) / valueReport)+"</div>");
				
				lstData.add(rowx);
				
				rowr = new Vector();				
				rowr.add(objDonorReport.getActDescription());
				rowr.add(numberFormat(objDonorReport.getMtdAmount() / valueReport));
				rowr.add(numberFormat(objDonorReport.getSptAmount() / valueReport));
				rowr.add(numberFormat((objDonorReport.getMtdAmount() + objDonorReport.getSptAmount()) / valueReport));
				rowr.add(""+level);
				
				vectContentToReport.add(rowr);
				
				if(level == PstActivity.LEVEL_MODULE){
					valueProgramatic += objDonorReport.getMtdAmount();
					valueSupport += objDonorReport.getSptAmount();
				}
				
			}
			
			rowx = new Vector();
			rowx.add("<b>"+strTitle[language][4].toUpperCase()+"</b>");
			rowx.add("<b><div align=\"right\">"+numberFormat(valueProgramatic / valueReport)+"</div></b>");
			rowx.add("<b><div align=\"right\">"+numberFormat(valueSupport / valueReport)+"</div></b>");
			rowx.add("<b><div align=\"right\">"+numberFormat((valueProgramatic + valueSupport) / valueReport)+"</div></b>");
			lstData.add(rowx);
			
			rowr = new Vector();
			rowr.add(strTitle[language][4].toUpperCase());
			rowr.add(numberFormat(valueProgramatic / valueReport));
			rowr.add(numberFormat(valueSupport / valueReport));
			rowr.add(numberFormat((valueProgramatic + valueSupport) / valueReport));
			rowr.add(""+level);
			
			vectSubTotalToReport.add(rowr);
			vectDataToReport.add(vectContentToReport);
			vectDataToReport.add(vectSubTotalToReport);
			
		}catch(Exception e){
			objectClass = new Vector();
			System.out.println("Exception on drawDonorReport() :::: "+e.toString());
		}
		
		
	}
	result.add(ctrlist.drawList());
	result.add(vectDataToReport);	
	return result;
}

public Vector drawSummarySupport(Vector objectClass, int language, double valueReport){
    Vector result = new Vector(1,1);
	Vector vectDataToReport = new Vector(1,1);
	Vector vectContentToReport = new Vector(1,1);
	Vector vectSubTotalToReport = new Vector(1,1);
	
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("60%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");	
    ctrlist.addHeader(strTitle[language][5],"40%","0","0");
    ctrlist.addHeader(strTitle[language][6],"20%","0","0");
       
    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.reset();
	
	double valueSupport = 0.0;
	int level = 0;
	
	Vector rowx = new Vector();
	Vector rowr = new Vector();
	
	DonorReport objDonorReport = new DonorReport();
	
    if(objectClass != null && objectClass.size() > 0){
		try{
			for(int i = 0; i < objectClass.size(); i++){
				objDonorReport = (DonorReport)objectClass.get(i);
				level = objDonorReport.getLevel();
				
				rowx = new Vector();				
				rowx.add(objDonorReport.getActDescription());
				rowx.add("<div align=\"right\">"+numberFormat(objDonorReport.getMtdAmount() / valueReport)+"</div>");
				lstData.add(rowx);
				
				rowr = new Vector();				
				rowr.add(objDonorReport.getActDescription());
				rowr.add(numberFormat(objDonorReport.getMtdAmount() / valueReport));				
				rowr.add(""+level);
				
				vectContentToReport.add(rowr);
								
				valueSupport += objDonorReport.getMtdAmount();
				
			}
			
			rowx = new Vector();
			rowx.add("<b>"+strTitle[language][8].toUpperCase()+"</b>");
			rowx.add("<b><div align=\"right\">"+numberFormat(valueSupport / valueReport)+"</div></b>");
			lstData.add(rowx);
			
			rowr = new Vector();
			rowr.add(strTitle[language][8].toUpperCase());
			rowr.add(numberFormat(valueSupport / valueReport));
			rowr.add(""+level);
			
			vectSubTotalToReport.add(rowr);
			vectDataToReport.add(vectContentToReport);
			vectDataToReport.add(vectSubTotalToReport);
			
		}catch(Exception e){
			objectClass = new Vector();
			System.out.println("Exception on drawSummarySupport() :::: "+e.toString());
		}
		
		
	}
	result.add(ctrlist.drawList());
	result.add(vectDataToReport);	
	return result;
}

%>

<!-- JSP Block -->
<%
int iCommand = FRMQueryString.requestCommand(request);
long accountId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERKIRAAN);
long periodId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERIODE);
String numberP = FRMQueryString.requestString(request,"ACCOUNT_NUMBER");
String namaP = FRMQueryString.requestString(request,"ACCOUNT_TITLES");
long oidDepartment = FRMQueryString.requestLong(request,"DEPARTMENT");
Date startDate = null;
Date endDate = null;
if(iCommand==Command.LIST){
    startDate = FRMQueryString.requestDate(request,"START_DATE_GL");
    endDate = FRMQueryString.requestDate(request,"END_DATE_GL");
}
Date today = new Date();
String linkPdf = reportrootfooter+"report.bukuBesar.GeneralLedgerPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
String linkXls = reportrootfooter+"report.bukuBesar.GeneralLedgerXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
String pathImage = reportrootimage+"company121.jpg";


/**
* Declare Commands caption
*/
String strCheck = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "check" : "cari";
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
String strReset = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Reset" : "Kosongkan";
String strBackToSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back to Search" : "Kembali ke Pencarian";

String order = "NOMOR_PERKIRAAN";
String nameperiode = "";
String namedepartment = "";
CtrlJurnalDetail ctrljurnaldetail = new CtrlJurnalDetail(request) ;
FrmJurnalDetail frmjurnaldetail = ctrljurnaldetail.getForm();
frmjurnaldetail.setDecimalSeparator(sUserDecimalSymbol); 
frmjurnaldetail.setDigitSeparator(sUserDigitGroup);
String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
String strCmdPrint[] = {"Cetak Laporan", "Print Report"};
String strCmdExport[] = {"Ekspor ke Excel", "Export To Excel"};
String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
SessGeneralLedger sessGeneralLedger = new SessGeneralLedger();


    Vector list = new Vector();
	Vector listSupport = new Vector();
    if(iCommand==Command.LIST)
        list = SessDonorReport.getDataReportDonor(periodId);
		listSupport = SessDonorReport.getDonorReportSupport(periodId);
	try{
            Periode period = PstPeriode.fetchExc(periodId);
            nameperiode = period.getNama();
			namedepartment = PstDepartment.fetchExc(oidDepartment).getDepartment();
        }catch(Exception e){}
	

%>
<!-- End of JSP Block -->

<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">

function report(){    
        document.frmGeneralLedger.command.value ="<%=Command.LIST%>";
        document.frmGeneralLedger.action = "donor_rpt_consolidated.jsp#down";
        document.frmGeneralLedger.submit();
}

function reportPdf(){
		var linkPage = "<%=reportroot%>report.donorReport.DonorRptCondPdf";
		window.open(linkPage);  				
}
function printXLS(){
		var linkPage = "<%=reportroot%>report.donorReport.DonorRptCondXls";
		window.open(linkPage);
}

function cmdBackToSearch(){
	document.frmGeneralLedger.command.value="<%=Command.BACK%>";
	document.frmGeneralLedger.action="donor_rpt_consolidated.jsp#up";
	document.frmGeneralLedger.<%=sessGeneralLedger.FRM_NAMA_PERIODE%>.focus();
	document.frmGeneralLedger.submit();
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<SCRIPT language=JavaScript>
</SCRIPT>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="stylesheet" href="../../style/calendar.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
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
            <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmGeneralLedger" method="post" action=""> 
			<input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="journal_id" value="0">
             <input type="hidden" name="fromGL" value="true">
			<input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>" value="<%=accountId%>">
              
			  <%if(privView && privSubmit){%>						  			  
              <table width="100%" cellspacing="0" cellpadding="0">
			  	<tr><td></td></tr>
                <tr> 
                  <td>
				  		<table width="100%" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
							<tr>
								<td>
									<table width="100%" border="0" class="search00">
			  	<tr>
				<td>
				<table width="100%" border="0" class="mainJournalOut">
                <tr>
                  <td height="23" ><a id="up">&nbsp;</a></td>
                  <td height="23" align="center">&nbsp;</td>
                  <td height="23">&nbsp;</td>
                </tr>
                <tr>
                  <td width="11%" height="20%"><b><%=strTitle[SESS_LANGUAGE][7]%></b></td>
                  <td height="20%" width="1%" align="center"><strong>:</strong></td>
                  <td height="20%" width="89%">
                  <%
                      Vector vtPeriod = PstPeriode.list(0,0,"",PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL]+" DESC ");
                      Periode lastPeriode = new Periode();
                      Periode firstPeriode = new Periode();
                      Vector vPeriodKey = new Vector(1,1);
                      Vector vPeriodVal = new Vector(1,1);
                      for(int k=0;k<vtPeriod.size();k++){
                        Periode periode = (Periode)vtPeriod.get(k);
                        if(k==0){
                            lastPeriode = periode;
                        }
                        if(k==(vtPeriod.size()-1)){
                            firstPeriode = periode;
                        }
                        vPeriodKey.add(""+periode.getOID());
                        vPeriodVal.add(periode.getNama());
                      }
                      out.println(ControlCombo.draw(SessGeneralLedger.FRM_NAMA_PERIODE,"",null,""+periodId,vPeriodKey,vPeriodVal,"onChange=\"javascript:refresh()\""));
                      if(startDate==null || endDate==null || iCommand==Command.REFRESH){
                          if(periodId>0){
                                try{
                                    Periode periode = PstPeriode.fetchExc(periodId);
                                    startDate = periode.getTglAwal();
                                    endDate = periode.getTglAkhir();
                                    System.out.println("masuk periodeId>0");
                                }
                                catch(Exception e){
                                    System.out.println("masuk err periodeId>0");
                                }
                          }
                          else{
                                startDate = lastPeriode.getTglAwal();
                                endDate = lastPeriode.getTglAkhir();
                                System.out.println("masuk periodeId<=0");
                          }
                      }

                   int yrInterval = 0;
                   yrInterval = firstPeriode.getTglAwal().getYear()-today.getYear();

                    // process data on control drawlist
                    Vector vectResult = drawDonorReport(list, SESS_LANGUAGE, dValueReport);
					Vector vecResultSupport = drawSummarySupport(listSupport, SESS_LANGUAGE, dValueReport);
                    					
					String listData = String.valueOf(vectResult.get(0));
                    Vector vDataToReportContent = (Vector)vectResult.get(1);
					
					String listDataSupport = String.valueOf(vecResultSupport.get(0));
                    Vector vDataToReportSupport = (Vector)vecResultSupport.get(1);					
					
					Vector vHeader = new Vector();
					for(int t = 0; t < strTitle[SESS_LANGUAGE].length; t++){
						vHeader.add(strTitle[SESS_LANGUAGE][t]);
					}
					
                    Vector vecSess = new Vector();                    
                    vecSess.add(linkPdf);
                    vecSess.add(vDataToReportContent);
                    vecSess.add(linkXls);
					vecSess.add(listTitle[SESS_LANGUAGE]);
					vecSess.add(vHeader);
					vecSess.add(pathImage);
					vecSess.add(vDataToReportSupport);
					
                    if(session.getValue("DONOR_REPORT")!=null){
                        session.removeValue("DONOR_REPORT");
                    }
                    session.putValue("DONOR_REPORT",vecSess);
					
					
				  %>
                  </td>
                </tr><!-- end search -->
				
                <tr>
                  <td width="11%" colspan="3" height="20%">&nbsp;</td>
                </tr>
                <tr>
                  <td  height="20%">
                  <div align="center"></div><!--  <a href="javascript:report()" id="cmd_report"><span class="command"><%//=strReport%></span></a> --> </td>
                  <td  height="20%">&nbsp;</td>
                  <td  height="20%"><input name="button" type="button" id="button" onClick="javascript:report()" value="<%=strReport%>"></td>
                </tr>
				</table>
				</td>
				</tr>
                <tr>
                  <td colspan="3" height="15">&nbsp;</td>
                </tr>
                <%if(iCommand==Command.LIST){%>				
		    <tr>
			<td colspan="3" id="down"><b><%=masterTitle[SESS_LANGUAGE]%> : <%=listTitle[SESS_LANGUAGE]%> (<%=strTitle[SESS_LANGUAGE][9]%>)</td>
		    </tr>	
                <tr>
                  <td colspan="3" height="15" >&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="3" height="15" ><%=listData%></td>
                </tr>
				<%if(listSupport != null && listSupport.size() > 0){%>
				<tr>
                  <td colspan="3" height="15" ><b><%=strTitle[SESS_LANGUAGE][8]%></b></td>
                </tr>	
				<tr>
                  <td colspan="3" height="15" ><%=listDataSupport%></td>
                </tr>
				<%}%>		
					<%int FLAG_PRINT = 1; %>			
						<%if(FLAG_PRINT == 1){%>
						<tr>
						  <td>&nbsp;</td>
						</tr>
						<tr>
							<td>
								<table width="18%" border="0" cellspacing="1" cellpadding="1">
								<tr>
									<td width="83%" nowrap><input type="button" value="<%=strCmdPrint[SESS_LANGUAGE]%>" onClick="javascript:reportPdf()"><!-- <b><a href="javascript:reportPdf()" class="command"><%//=strCmdPrint[SESS_LANGUAGE]%></a></b> --></td>
									<td width="83%" nowrap>&nbsp;&nbsp;<input type="button" value="<%=strCmdExport[SESS_LANGUAGE]%>" onClick="javascript:printXLS()"><!-- <b><a href="javascript:printXLS()" class="command"><%//=strCmdExport[SESS_LANGUAGE]%></a></b> --></td>
									<td width="83%" nowrap>&nbsp;&nbsp;<input type="button" id="cmd_report" value="<%=strBackToSearch%>" onClick="javascript:cmdBackToSearch()"><!-- <b><a href="javascript:printXLS()" class="command"><%//=strCmdExport[SESS_LANGUAGE]%></a></b> --></td>

								</tr>
								</table>
							</td>
						</tr>
						<%}%>
                <%}%>				
              </table>
								</td>
							</tr>
						</table>
                  </td>
                </tr>
              </table>
			  <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][8]%></i></font></td>
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>