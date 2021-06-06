<%@ page language="java" %>

<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>

<!-- import java -->
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>

<!-- import interfaces -->
<%@ page import="com.dimata.interfaces.chartofaccount.*" %>

<!-- import qdep -->
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<!--package common -->
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.entity.payment.*" %>

<!-- import ij -->
<%@ page import = "com.dimata.ij.iaiso.*" %>
<%@ page import = "com.dimata.ij.ibosys.*" %>
<%@ page import = "com.dimata.ij.session.engine.*" %>
<%@ page import = "com.dimata.ij.entity.configuration.*" %>

<%@ include file = "../../main/javainit.jsp" %>

<!-- JSP Block -->
<%!
/**
* this method used to list jurnal detail
*/
public String listJurnalDetail(FRMHandler objFRMHandler, int iLanguage, Vector listjurnaldetail, Vector listCurrencyAiso, long systemBookType)
{
	// selected aisoCurrency
	Hashtable hastAiso = new Hashtable();
	Hashtable hastCurrAiso = new Hashtable();	
	if(listCurrencyAiso!=null && listCurrencyAiso.size()>0)
	{
		int maxCurrencyAiso = listCurrencyAiso.size();
		for(int i=0; i<maxCurrencyAiso; i++)
		{
			CurrencyType objCurrencyType = (CurrencyType) listCurrencyAiso.get(i);
			hastAiso.put(String.valueOf(objCurrencyType.getOID()), objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");		
			hastCurrAiso.put(String.valueOf(objCurrencyType.getOID()), objCurrencyType.getCode());			
		}
	}																										

	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat("Account's Group","15%","left","left");
	ctrlist.dataFormat("Account's Name","45%","left","left");
	ctrlist.dataFormat("Currency","10%","left","left");
	ctrlist.dataFormat("Rate","10%","right","right");		
	ctrlist.dataFormat("Debet("+hastCurrAiso.get(String.valueOf(systemBookType))+")","10%","right","right");
	ctrlist.dataFormat("Kredit("+hastCurrAiso.get(String.valueOf(systemBookType))+")","10%","right","right");
	ctrlist.setLinkRow(1);	
	ctrlist.reset();

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();  
	Vector rowx = new Vector();	
	String attr = "onChange=\"parent.frames[0].cmdChangeAccount()\"";
	String attrChange = "onChange=\"parent.frames[0].cmdChange()\""; 	
	String strSelect = "";	
	
	for(int it=0; it<listjurnaldetail.size(); it++)
	{																								
		 IjJournalDetail objIjJournalDetail = (IjJournalDetail) listjurnaldetail.get(it);		 		 

		 String strAccountGroup = ""; 
		 String strAccountName = "";  
		 try
		 {
			I_Aiso i_aiso = (I_Aiso) Class.forName(I_Aiso.implClassName).newInstance();                        
			IjAccountChart objAccountChart = i_aiso.getAccountChart(objIjJournalDetail.getJdetAccChart());	
			strAccountGroup = I_ChartOfAccountGroup.arrAccountGroupNames[iLanguage][objAccountChart.getAccGroup()];
			strAccountName = objAccountChart.getAccName();		 			
		 }
		 catch(Exception e)
		 {
			System.out.println("Exc : " + e.toString());
		 }
		 
    	 rowx = new Vector();		 
		 rowx.add(strAccountGroup);
		 rowx.add(strAccountName);							 
		 rowx.add(hastAiso.get(""+objIjJournalDetail.getJdetTransCurrency()));							 							 		 		 
		 rowx.add(""+objFRMHandler.userFormatStringDecimal(objIjJournalDetail.getJdetTransRate()));		 
		 rowx.add(""+objFRMHandler.userFormatStringDecimal(objIjJournalDetail.getJdetDebet()));
		 rowx.add(""+objFRMHandler.userFormatStringDecimal(objIjJournalDetail.getJdetCredit()));				
		 
		 lstData.add(rowx); 
	 }	 

	 return ctrlist.drawMe(); 													 												
}

public String drawListTotal(FRMHandler objFRMHandler, String strMessage, double debet, double kredit){
	String result = "<table width=\"100%\"><tr><td>"+
						"<table width=\"100%\" border=\"0\" cellspacing=\"1\">"+
							"<tr>"+
								"<td width=\"80%\" class=\"msgbalance\">"+
									"<div align=\"left\" ID=msgPostable><i>"+strMessage+"</i></div>"+
								"</td>"+
								"<td width=\"10%\" class=\"listgenTitle\">"+
									"<div align=\"right\">"+objFRMHandler.userFormatStringDecimal(debet)+"</div>"+
								"</td>"+
								"<td width=\"10%\" class=\"listgenTitle\">"+
									"<div align=\"right\">"+objFRMHandler.userFormatStringDecimal(kredit)+"</div>"+
								"</td>"+				
							"</tr>"+
						"</table>"+
						"</td></tr></table>";	
	return result;					
}
%>
<%
// get data from form request
int iCommand = FRMQueryString.requestCommand(request);   
long oidIjJournalMain = FRMQueryString.requestLong(request, "hidden_ij_journal_main_id");
long oidIjJournalDetail = FRMQueryString.requestLong(request, "hidden_ij_journal_detail_id");
String strDisabled = "";

// setting currency format
FRMHandler objFRMHandler = new FRMHandler();
objFRMHandler.setDigitSeparator(".");
objFRMHandler.setDecimalSeparator(",");

// get object journal depend on selected from list
double amountDt = 0;
double amountCr = 0;
IjJournalMain objIjJournalMain = PstIjJournalMain.getIjJournalMain(oidIjJournalMain);
Vector listDetail = objIjJournalMain.getListOfDetails();
if(listDetail!=null && listDetail.size()>0)
{
	int detailCount = listDetail.size();
	for(int i=0; i<detailCount; i++)
	{
		IjJournalDetail objIjJournalDetail = (IjJournalDetail) listDetail.get(i);		 		 
		amountDt = amountDt + objIjJournalDetail.getJdetDebet();
		amountCr = amountCr + objIjJournalDetail.getJdetCredit();				
	}
}


Vector vJournal = new Vector(1,1);
vJournal.add(objIjJournalMain);
if( (iCommand == Command.SAVE) && (vJournal!=null && vJournal.size()>0) )
{
	try
	{
		System.out.println(">>> Start save journal ...");
		
		Periode objPeriod = PstPeriode.fetchExc(currentPeriodOid);
		if(objPeriod.getOID() != 0)
		{			

			IjEngineParam objIjEngineParam = new IjEngineParam();
			objIjEngineParam.setLCurrPeriodeOid(objPeriod.getOID());                   
			objIjEngineParam.setDStartDatePeriode(objPeriod.getTglAwal());                   
			objIjEngineParam.setDEndDatePeriode(objPeriod.getTglAkhir());                    
			objIjEngineParam.setDLastEntryDatePeriode(objPeriod.getTglAkhirEntry());                    
			objIjEngineParam.setLOperatorOid(userOID);                           					

			IjEngineController objIjEngineController = new IjEngineController(); 
			objIjEngineController.runAisoJournalProcess(vJournal, objIjEngineParam);					
		}

		System.out.println(">>> Finish save journal ...");		
	}
	catch(Exception e)
	{
		System.out.println("Exc : " + e.toString());
	}								
}
%>
<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<script language="javascript">
function cmdSave()
{ 
	document.frmjournal.command.value="<%=Command.SAVE%>";
	document.frmjournal.action="ij_journal_edit.jsp";
	document.frmjournal.submit(); 
} 

function cmdBack()
{ 
	document.frmjournal.command.value="<%=Command.EDIT%>";
	document.frmjournal.action="ij_journal_list.jsp";
	document.frmjournal.submit(); 
} 
</script>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE"> 
      <%@ include file = "../../main/header.jsp" %>
    </td>
  </tr>
  <tr> 
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
      <%@ include file = "../../main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" -->Journal 
            &gt; Journal Editor<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmjournal" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="hidden_ij_journal_main_id" value="<%=oidIjJournalMain%>">
              <input type="hidden" name="hidden_ij_journal_detail_id" value="<%=oidIjJournalDetail%>">
              <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr> 
                  <td> 
                    <hr size="1" noshade>
                  </td>
                </tr>
                <tr> 
                  <td class="tabtitleactive"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
                      <tr> 
                        <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                        <td width="94%" height="25" class="listgensell" valign="top">&nbsp;</td>
                        <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="3%" valign="top"></td>
                        <td width="94%"> 
                          <table width="100%">
                            <tr> 
                              <td width="14%" height="25">&nbsp;Booking Type</td>
                              <td width="3%" height="25"><b>:</b></td>
                              <td width="40%" height="25">
								<input type="hidden" name="IJ_BOOK_TYPE" value="<%=""+accountingBookType%>" size="35">									
								<%
								String sBookType = "";
								try
								{
									CurrencyType objCurrencyType = PstCurrencyType.fetchExc(accountingBookType);
									sBookType = objCurrencyType.getName();
								}
								catch(Exception e)
								{
									System.out.println("Exc when fetch book type from currtype : " + e.toString());
								}
								out.println(sBookType);
								%>							  
							  </td>
                              <td width="11%" height="25">Referensi Doc.</td>
                              <td width="3%" height="25"><b>:</b></td>
                              <td height="25"><input type="text" name="IJ_REF_BO_DOC_NUMBER" value="<%=objIjJournalMain.getRefBoDocNumber()%>" <%=strDisabled%>></td>
                            </tr>
                            <tr> 
                              <td width="14%" height="25">&nbsp;Transaction In</td>
                              <td width="3%" height="25"><b>:</b></td>
                              <td width="40%" height="25"> 
                                <%
								Vector vectKeyCurrency = new Vector(1,1);
								Vector vectValCurrency = new Vector(1,1);								

								PstCurrencyType objPstCurrencyType = new PstCurrencyType();
								String strOrder = objPstCurrencyType.fieldNames[objPstCurrencyType.FLD_TAB_INDEX];
								Vector listCurrAiso = objPstCurrencyType.list(0, 0, "", strOrder);  
								if(listCurrAiso!=null && listCurrAiso.size()>0)
								{
									int maxCurrencyType = listCurrAiso.size();
									for(int i=0; i<maxCurrencyType; i++)
									{
										CurrencyType objCurrencyType = (CurrencyType) listCurrAiso.get(i);                 					
										vectKeyCurrency.add(""+objCurrencyType.getOID());
										vectValCurrency.add(objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");						
									}
								}								
								
								out.println(ControlCombo.draw("JOURNAL_CURRENCY_ID", null, ""+objIjJournalMain.getJurTransCurrency(), vectKeyCurrency, vectValCurrency, strDisabled));	
								%>
                              </td>
                              <td width="11%" height="25">Journal Notes</td>
                              <td width="3%" height="25"><b>:</b></td>
                              <td rowspan="2" height="26" valign="top"> 
                                <textarea name="textarea" cols="40" rows="3" <%=strDisabled%>><%=objIjJournalMain.getJurDesc()%></textarea>
                              </td>
                            </tr>
                            <tr> 
                              <td width="14%" height="25">&nbsp;Transaction Date</td>
                              <td width="3%" height="25"><b>:</b></td>
                              <td width="40%" height="25"> 
                                <%
								out.println(ControlDate.drawDate("JOURNAL_TRANSACTION_DATE", objIjJournalMain.getJurTransDate(), "", "", "", "", 0, -2, strDisabled));
								%>
                              </td>
                              <td width="11%" height="25">&nbsp;</td>
                              <td width="3%" height="25">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="6"> 
                                <%
								out.println(listJurnalDetail(objFRMHandler, SESS_LANGUAGE, listDetail, listCurrAiso, accountingBookType));
								String strMsg = "";
								if(amountDt>0 || amountCr>0)
								{
									out.println(drawListTotal(objFRMHandler,strMsg,amountDt,amountCr));
								}
								%>
                              </td>
                            </tr>
                            <tr> 
                              <td colspan="6" class="command">&nbsp; <a href="javascript:cmdSave()" class="command">Posted 
                                Journal</a> | <a href="javascript:cmdBack()" class="command">Back 
                                To Journal List</a> </td>
                            </tr>
                          </table>
                        </td>
                        <td width="3%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="3%" valign="top" height="25"></td>
                        <td width="94%" height="25">&nbsp;</td>
                        <td width="3%" height="25">&nbsp;&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </form>
            <!-- #EndEditable --></td>
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
<!-- #EndTemplate -->
</html>
