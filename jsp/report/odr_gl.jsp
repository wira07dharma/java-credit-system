<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>
<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*,
                 com.dimata.util.Formater,
                 com.dimata.util.Command,
                 com.dimata.harisma.entity.masterdata.PstDepartment,
                 com.dimata.harisma.entity.masterdata.Department,
                 com.dimata.aiso.entity.periode.PstPeriode,
                 com.dimata.aiso.entity.periode.Periode,
                 com.dimata.aiso.entity.specialJournal.*,
                 com.dimata.interfaces.journal.*,
                 com.dimata.aiso.entity.masterdata.Perkiraan,
                 com.dimata.interfaces.chartofaccount.I_ChartOfAccountGroup,
                 com.dimata.aiso.entity.masterdata.PstPerkiraan, 
                 com.dimata.aiso.entity.jurnal.JournalDistribution, com.dimata.aiso.session.report.villamanagement.OwnerDistributionReport" %>
<!--import java-->
<%@ page import="java.util.Date" %>
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
    String prevPeriodeName = "";
    String nameperiode  = "";
    int iCommand = FRMQueryString.requestCommand(request);
    long busCenterId= FRMQueryString.requestLong(request,"bus_center_id");
    BussinessCenter bCenter=null;
    long periodId = FRMQueryString.requestLong(request,"period_id");
    long acc_id   = FRMQueryString.requestLong(request,"acc_id");
    String acc_group = FRMQueryString.requestString(request,"acc_group");   
    
    String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
	String strBack[] = {"Kembali ke Pencarian", "Back to Search"};

	
    FRMHandler frmHandler = new FRMHandler();
    frmHandler.setDecimalSeparator(sUserDecimalSymbol); 
    frmHandler.setDigitSeparator(sUserDigitGroup);
	
    Vector list = new Vector();
	String currYear = "";
	String prevYear = "";
        
    
    Periode period= new Periode();
    if(iCommand==Command.LIST || iCommand==Command.CONFIRM || iCommand==Command.DELETE){
        list = null;
		
	try{
            period = PstPeriode.fetchExc(periodId);
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
	
	if(session.getValue("ODR_GL")!=null){   
		session.removeValue("ODR_GL");
	}	                
        
       }

/**
* Declare Commands caption
*/
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
%>
<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" -->
<!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>GL - ODR Journal - Dimata AISO</title>
<script language="javascript">
function report(){
        document.frmTrialBalance.command.value ="<%=Command.LIST%>";
        document.frmTrialBalance.action = "owner_distribution.jsp";
        document.frmTrialBalance.submit();
}

function cmdBack(){
	document.frmTrialBalance.command.value ="<%=Command.BACK%>";
	document.frmTrialBalance.action = "owner_distribution.jsp#up";
	document.frmTrialBalance.submit();
}

</script>
<!-- #EndEditable --><!-- #BeginEditable "headerscript" -->
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

function openDistributionGL(bus_center_id, period_id, acc_id){		
		window.open("odr_gl.jsp?bus_center_id="+bus_center_id+"&period_id="+period_id+"&acc_id="+acc_id);  				      
    }
    
function cmdEdit(oid,jurnaltype,amountstatus){
	document.frmGeneralLedger.journal_id.value=oid;
	document.frmGeneralLedger.journal_type.value=jurnaltype;
	document.frmGeneralLedger.amount_status.value=amountstatus;
	document.frmGeneralLedger.command.value="<%=Command.EDIT%>";	
	var jurnaltype = document.frmGeneralLedger.journal_type.value;
	var amountstatus = document.frmGeneralLedger.amount_status.value;
	switch(jurnaltype){
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_CASH%>":	
			document.frmGeneralLedger.action="../specialjournal/cashreceipts/journalmain.jsp";			
	  	break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_BANK%>":
		if(amountstatus == "<%=PstSpecialJournalMain.STS_DEBET%>"){	
			document.frmGeneralLedger.action="../specialjournal/bankdeposite/journalmain.jsp";
		}else{
			document.frmGeneralLedger.action="../specialjournal/bankdraw/journalmain.jsp";
		} 
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_PETTY_CASH%>":	
			document.frmGeneralLedger.action="../specialjournal/pettycash/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_REPLACEMENT%>":	
			document.frmGeneralLedger.action="../specialjournal/pettycashreplacement/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_BANK_TRANSFER%>":	
			document.frmGeneralLedger.action="../specialjournal/banktransfer/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_NON_CASH%>":	
			document.frmGeneralLedger.action="../specialjournal/noncash/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_FUND%>":	
			document.frmGeneralLedger.action="../specialjournal/cashpayment/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_PAYMENT%>":	
			document.frmGeneralLedger.action="../specialjournal/payment/journalmain.jsp";
		break;
		default:	
			document.frmGeneralLedger.action="../journal/jumum.jsp";
		break;		
	}
	
	document.frmGeneralLedger.submit();
}    

function AskDeleteJournal(){        
        alert("Delete Journal ???");
     	document.frmGeneralLedger.command.value="<%=Command.CONFIRM%>";	
        document.frmGeneralLedger.submit();
    }

function deleteJournal(){
        alert ("Journal will be deleted");
     	document.frmGeneralLedger.command.value="<%=Command.DELETE%>";	
        document.frmGeneralLedger.submit();
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
        <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --> General Ledger - <%=masterTitle[SESS_LANGUAGE]%> <font color="#CC3300"><%=""%></font><!-- #EndEditable --></td>
      </tr>
      <tr>
        <td valign="top">
        <!-- #BeginEditable "content" -->
        <br>
        <h3>Bussines Center : <%=bCenter.getBussCenterName()%>  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Period : <%=period.getNama()%> </h3>
        <form name="frmGeneralLedger" method="post" action=""> 
          <input type="hidden" name="command" value="<%=iCommand%>">
          <input type="hidden" name="journal_id" value="">
          <input type="hidden" name="journal_type" value="">
          <input type="hidden" name="amount_status" value="">
          <input type="hidden" name="bus_center_id" value="<%=busCenterId%>">
          <input type="hidden" name="period_id" value="<%=periodId%>">
          <input type="hidden" name="acc_id" value="<%=acc_id%>">
          <input type="hidden" name="acc_group" value="<%=acc_group%>">

                   
         <%if(privView && privSubmit){%>
          <table width="100%" cellspacing="0" cellpadding="0">
            <tr>
              <td colspan="2">&nbsp;
                <table width="100%" class="listarea" cellspacing="0">
                <%
                 Vector vAccs= new Vector();
                 if((acc_id==0) && (acc_group !=null)){
                     if(acc_group.equals(OwnerDistributionReport.GROUP_ACC_COMMON_AREA)){                                                 
                         if(OwnDisRepAccount.commonArea!=null){
                           for(int ica=0;ica<OwnDisRepAccount.commonArea.length;ica++){
                               long oidAcc = PstPerkiraan.getAccountIdByNo(OwnDisRepAccount.commonArea[ica]);     
                               vAccs.add(new Long(oidAcc));
                           }                                                    
                         }                                                 
                     }                                             
                 } else {
                     vAccs.add(new Long(acc_id));
                 }
                 if (vAccs==null){ 
                     vAccs = new Vector();
                 }
                 double grandTotalDebt =0.0;
                 double grandTotalCredit=0.0;
                 
                 for(int ic=0;ic<vAccs.size();ic++)
                    {
                      acc_id = ((Long)vAccs.get(ic)).longValue();
                      Perkiraan perk= new Perkiraan();
                      
                      try{ perk =PstPerkiraan.fetchExc(acc_id);} catch(Exception exc){}
                      
                      try { 
                            Vector glList= null;   

                                try{
                                     glList = OwnerDistributionReport.listODRJournal(busCenterId, periodId, acc_id);
                                    } catch(Exception exc){
                                      System.out.println(">>> ODR GL"+exc);    
                                    }               
                             if( glList!=null ){
                                   
                                   
                               for(int idx=0;idx<glList.size();idx++){
                                   JournalDistribution trans = (JournalDistribution ) glList.get(idx);
                                   double totalDebt=0.0;
                                   double totalCredit=0.0;
                            %>                         
                        <tr>
                            <td width="100%" >&nbsp; </td>
                        </tr>
                        <tr>
                            <td width="100%" ><%=(perk.getNoPerkiraan()+" "+perk.getNama()+" / "+perk.getAccountNameEnglish())%> </td>
                        </tr>
                        <tr>
                              <td>
                                  <table width="100%" class="listgen" cellspacing="1" border="0">
                                      <tr>
                                          <td width="2%" class="listgentitle">&nbsp</td>
                                          <td width="8%" class="listgentitle">Date</td>
                                          <td width="10%" class="listgentitle">No Voucher</td>
                                          <td width="31%" class="listgentitle">Description</td>
                                          <td width="10%" class="listgentitle">Debet</td>
                                          <td width="10%" class="listgentitle">Credit</td>
                                       </tr>
                                       <tr valign="top">
                                           <td class="listgensellOdd" >
                                               <div align="center"> <input type="checkbox" name="jounalid" value="<%=trans.getOID()%>" /></div>
                                            </td>
                                           <td class="listgensellOdd" ><div align="center"> <% try{ %>
                                               <%=(trans.getTransDate()==null?"":Formater.formatDate(trans.getTransDate(),"MMM dd, yyyy"))%>
                                               <% } catch(Exception exc){}%>
                                               </div>
                                            </td>
                                           <td class="listgensellOdd" ><a href="javascript:cmdEdit('<%=trans.getMainJournalId()%>','0','0')"><div align="left"><%=trans.getMainJournalNumber()%></div></a></td>
                                           <td class="listgensellOdd" >&nbsp;
                                           <% try{ %>
                                                  <%=(trans.getMainJournalNote()!=null?trans.getMainJournalNote():"")%>
                                                  <%
                                                   if( (trans.getMainJournalNote()!=null)  && (trans.getJDetailNote()!=null) && !(trans.getJDetailNote().equals(trans.getMainJournalNote()))){
                                                  %>
                                                  <%=(trans.getJDetailNote())%>
                                                  <%}%>
                                                  
                                                  <%
                                                   if( (trans.getNote()!=null)  && (trans.getNote()!=null) && !(trans.getJDetailNote().equals(trans.getNote()))){
                                                  %>
                                                  
                                                  <%=trans.getNote()%>
                                                  <%}%>
                                               <% } catch(Exception exc){}%>   
                                            </td>
                                           <td class="listgensellOdd" ><div align="right"><%=Formater.formatNumber(trans.getDebitAmount(), "##,###.##")%></div></td>
                                           <td class="listgensellOdd" ><div align="right"><%=Formater.formatNumber(trans.getCreditAmount(), "##,###.##")%></div></td>
                                           
                                            <%totalDebt=totalDebt+trans.getDebitAmount();
                                                 totalCredit = totalCredit+trans.getCreditAmount();
                                            %>
                                       </tr>
                                       
                                       <tr valign="top">
                                           <td class="listgentitle">&nbsp;</td>
                                           <td class="listgensell" ></td>
                                           <td class="listgensell" ></td>
                                           <td class="listgensell" ><div align="right"><b>TOTAL</b></div></td>
                                           <td class="listgensell" ><div align="right"><b><%=Formater.formatNumber(totalDebt, "##,###.##")%></b></div></td>
                                           <td class="listgensell" ><div align="right"><b><%=Formater.formatNumber(totalCredit, "##,###.##")%></b></div></td>                                           
                                           <%
                                                 grandTotalDebt = grandTotalDebt+ totalDebt;
                                                 grandTotalCredit= grandTotalCredit +  totalCredit;

                                           %>
                                       </tr>
                                       <tr valign="top">
                                           <td class="listgensell" >&nbsp;</td>
                                           <td class="listgensell" >&nbsp;</td>
                                           <td class="listgensell" >&nbsp;</td>
                                           <td class="listgensell" >&nbsp;</td>
                                           <td class="listgensell" >&nbsp;</td>
                                           <td class="listgensell" >&nbsp;</td>
                                       </tr>
                                       
                                   </table>                               
                              </td>
                         </tr>
                         <% 
                             }      
                            }
                          } catch(Exception exc){
                           }
                      }%>
                        <tr>
                            <td width="100%" class="listgentitle" >&nbsp;Grand Total Debt = <%=Formater.formatNumber(grandTotalDebt,"##,###.##")%> &nbsp;&nbsp;Grand Total Credit=<%=Formater.formatNumber(grandTotalCredit,"##,###.##")%></td>
                        </tr>
                </table>
              </td>
            </tr>
            <tr>
                <td>
                    <% if(iCommand==Command.LIST) {%>
                    <input type="button" value="Delete Journal(s)" name="askdelete"  onClick="javascript:AskDeleteJournal();"/>
                    <%} else { 
                     if(iCommand==Command.CONFIRM) {
                     %>                     
                       <input type="button" value=" Delete Journal(s) ? YES  " name="delete"  onClick="javascript:deleteJournal();"/>
                       &nbsp;&nbsp;&nbsp;&nbsp;
                       <input type="button" value=" CANCEL " name="cancelDel"  onClick="javascript:deleteJournal();"/>
                    <%
                      }
                    }%>
                    </td>
            </tr>
          <%} else{%>
          <table width="100%" cellspacing="0" cellpadding="0">
            <tr>
              <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][2]%></i></font></td>
            </tr>
          </table>
          <%}%>
        </form>
        <!-- #EndEditable -->
        </td>
      </tr>
      <tr>
        <td height="100%"><p>&nbsp;</p>
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
          <p>&nbsp;</p></td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td colspan="2" height="20" class="footer"><%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
<!-- endif of "has access" condition -->
<%}%>
