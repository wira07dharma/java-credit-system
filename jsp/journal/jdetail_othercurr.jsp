<%@ page language="java" %>

<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.util.*" %>

<!--import qdep-->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<!--package posbo -->
<%@ page import = "com.dimata.common.entity.payment.*" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.form.jurnal.*" %> 

<%!
public static String strTitle[][] = {
	{
	"Input Mata Uang Lain","Keterangan","Debet","Kredit","Mata Uang","Kurs","OK","Kembali"
	},	
	
	{
	"Entry Other Currency","Remark","Debet","Credit","Currency","Rate","OK","Back"
	}
};
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
long lCurrTypeOidUsed = FRMQueryString.requestLong(request,"curr_type_used");
double dCurrRateUsed = Double.parseDouble(String.valueOf(request.getParameter("curr_rate_used")));
boolean bWeight = FRMQueryString.requestBoolean(request,"weight");
System.out.println("lCurrTypeOidUsed="+lCurrTypeOidUsed+" dCurrRateUsed="+dCurrRateUsed+" bWeight="+bWeight+"iCommand="+iCommand);
if(dCurrRateUsed == 0)
{
	dCurrRateUsed = 1;
}

double dDebetAmount = Double.parseDouble(String.valueOf(request.getParameter("debet_amount")));
double dCreditAmount = Double.parseDouble(String.valueOf(request.getParameter("credit_amount")));

CtrlJurnalDetail ctrljurnaldetail = new CtrlJurnalDetail(request); 
FrmJurnalDetail frmjurnaldetail = ctrljurnaldetail.getForm();
frmjurnaldetail.setDecimalSeparator(sUserDecimalSymbol); 
frmjurnaldetail.setDigitSeparator(sUserDigitGroup);

// get masterdata currency
String sOrderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector vlistCurrencyType = PstCurrencyType.list(0, 0, "", sOrderBy);

// get masterdata standart rate
String sStRateWhereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS] + " = " + PstStandartRate.ACTIVE;
String sStRateOrderBy = PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE] + 
						", " + PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE];
Vector vlistStandartRate = PstStandartRate.list(0, 0, sStRateWhereClause, sStRateOrderBy);
%>

<html>
<head>
<title>Accounting Information System Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/login.css" type="text/css">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<script language="JavaScript" src="../main/dsj_common.js"></script>
<script type="text/javascript" src="../main/digitseparator.js"></script>
<script language="javascript">
/*var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";*/	

var sysDecSymbol = ".";
var usrDigitGroup = ",";
var usrDecSymbol = ".";

function getText(element){
	parserNumber(element,false,0,'');
}

function changeCurrType()  
{ 
	var iCurrType = document.frmjdetailothcurr.CURRENCY_TYPE.value;
	switch(iCurrType)
	{
	<%
	if(vlistStandartRate!=null && vlistStandartRate.size()>0)
	{
		int ilistStandartRateCount = vlistStandartRate.size();
		for(int i=0; i<ilistStandartRateCount; i++)
		{
			StandartRate objStandartRate = (StandartRate) vlistStandartRate.get(i); 		
	%>
		case "<%=objStandartRate.getCurrencyTypeId()%>" :
			 document.frmjdetailothcurr.STANDART_RATE.value = "<%=Formater.formatNumber(objStandartRate.getSellingRate(), "##,###.##")%>";
			 document.frmjdetailothcurr.standard_rt.value = "<%=Formater.formatNumber(objStandartRate.getSellingRate(), "###")%>";
			 changeJournalDebet();
			 changeJournalKredit();
			 break;
	<%	
		}	
	}
	%>			
		default :
			 document.frmjdetailothcurr.STANDART_RATE.value = "<%=Formater.formatNumber(1,"##,###.##")%>";		
			 changeJournalDebet();
			 changeJournalKredit();			 
			 break;
	}
}


function changeJournalDebet()
{ 	
	var dStandartRate = 0;	
	var dStandartRate = parseFloat(document.frmjdetailothcurr.standard_rt.value);
	if(dStandartRate > 1){
		dStandartRate = cleanNumberFloat(document.frmjdetailothcurr.STANDART_RATE.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	}else{
		dStandartRate = document.frmjdetailothcurr.std_rate.value;
	}
	
	var dDebetSource = cleanNumberFloat(document.frmjdetailothcurr.DEBET_CURR_SOURCE.value, sysDecSymbol, usrDigitGroup, usrDecSymbol); 
	if(!isNaN(dDebetSource))
	{	
		document.frmjdetailothcurr.DEBET_CURR_SOURCE.value = formatFloat(parseFloat(dDebetSource), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		document.frmjdetailothcurr.DEBET_CURR_BOOK_TYPE.value = formatFloat(parseFloat(dDebetSource * dStandartRate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		
	}
	else
	{
		document.frmjdetailothcurr.DEBET_CURR_SOURCE.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
		document.frmjdetailothcurr.DEBET_CURR_BOOK_TYPE.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);				
	}							
}

function changeJournalKredit()
{ 
	var dStandartRate = 0;	
	var dStandartRate = parseFloat(document.frmjdetailothcurr.standard_rt.value);
	if(dStandartRate > 1){
		dStandartRate = cleanNumberFloat(document.frmjdetailothcurr.STANDART_RATE.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	}else{
		dStandartRate = document.frmjdetailothcurr.std_rate.value;
	}
	var dCreditSource = cleanNumberFloat(document.frmjdetailothcurr.KREDIT_CURR_SOURCE.value, sysDecSymbol, usrDigitGroup, usrDecSymbol); 	

	if(!isNaN(dCreditSource))
	{
		document.frmjdetailothcurr.KREDIT_CURR_SOURCE.value = formatFloat(parseFloat(dCreditSource), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);		
		document.frmjdetailothcurr.KREDIT_CURR_BOOK_TYPE.value = formatFloat(parseFloat(dCreditSource * dStandartRate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	}
	else
	{
		document.frmjdetailothcurr.KREDIT_CURR_SOURCE.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);			
		document.frmjdetailothcurr.KREDIT_CURR_BOOK_TYPE.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);;				
	}			
}

function processToJDetail()
{ 
	var lCurrTypeUsed = document.frmjdetailothcurr.CURRENCY_TYPE.value;	
	var dStandartRateVal = 0;
	<%if(dCurrRateUsed > 1){%>
		dStandartRateVal = document.frmjdetailothcurr.std_rate.value;
	<%}else{%>
		dStandartRateVal = cleanNumberFloat(document.frmjdetailothcurr.STANDART_RATE.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	<%}%>
	var dDebetVal = parseFloat(cleanNumberFloat(document.frmjdetailothcurr.DEBET_CURR_BOOK_TYPE.value, sysDecSymbol, usrDigitGroup, usrDecSymbol));	
	var dKreditVal = parseFloat(cleanNumberFloat(document.frmjdetailothcurr.KREDIT_CURR_BOOK_TYPE.value, sysDecSymbol, usrDigitGroup, usrDecSymbol));
	
	self.opener.document.forms.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_TYPE]%>.value = lCurrTypeUsed;	
	
	if(!isNaN(dStandartRateVal))
	{
		self.opener.document.forms.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_AMOUNT]%>.value = formatFloat(dStandartRateVal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	}
	else
	{
		self.opener.document.forms.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_AMOUNT]%>.value = formatFloat(1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	}
			
	if(!isNaN(dDebetVal))
	{
		self.opener.document.forms.frmjournaldetail.<%=(bWeight?"TOTAL_DEBET":"DEBET")%>.value = formatFloat(dDebetVal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	}
	else
	{
		self.opener.document.forms.frmjournaldetail.<%=(bWeight?"TOTAL_DEBET":"DEBET")%>.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	}
	
	if(!isNaN(dKreditVal))
	{
		self.opener.document.forms.frmjournaldetail.<%=(bWeight?"TOTAL_KREDIT":"KREDIT")%>.value = formatFloat(dKreditVal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	}
	else
	{
		self.opener.document.forms.frmjournaldetail.<%=(bWeight?"TOTAL_KREDIT":"KREDIT")%>.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
	}	
	
	self.close();
}

function cancelProcess()
{ 
	self.close();
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<form name="frmjdetailothcurr" method="post" action="">
<input type="hidden" name="std_rate" value="<%=dCurrRateUsed%>">
<input type="hidden" name="standard_rt" value="">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
    <tr> 
      <td width="3%" class="listgensell" valign="top">&nbsp;</td>
      <td width="94%" class="listgensell" valign="top">&nbsp;</td>
      <td width="3%" class="listgensell" valign="top">&nbsp;</td>
    </tr>
    <tr> 
      <td width="3%" class="listgensell" valign="top" height="25">&nbsp;</td>
      <td width="94%" class="listgensell" valign="top" height="25" align="center"><b><%=strTitle[SESS_LANGUAGE][0]%></b></td>
      <td width="3%" class="listgensell" valign="top" height="25">&nbsp;</td>
    </tr>
    <tr> 
      <td width="3%" class="listgensell" valign="top" height="25">&nbsp;</td>
      <td width="94%" class="listgensell" valign="top" height="25"> 
        <table width="100%" border="0" class="listgen" cellspacing="1">
          <tr> 
            <td colspan="2" class="listgentitle"> 
              <div align="center"><%=strTitle[SESS_LANGUAGE][1]%></div>
            </td>
            <td width="30%" class="listgentitle"> 
              <div align="center"><%=strTitle[SESS_LANGUAGE][2]%></div>
            </td>
            <td width="30%" class="listgentitle"> 
              <div align="center"><%=strTitle[SESS_LANGUAGE][3]%></div>
            </td>
          </tr>
          <tr> 
            <td class="listgensell" width="5%" nowrap ><b><%=strTitle[SESS_LANGUAGE][4]%></b></td>
            <td class="listgensell" width="35%" > 
              <%
		  Vector currencytypeid_value = new Vector(1,1);
		  Vector currencytypeid_key = new Vector(1,1);
		  
		  String sSelectedCurrType = ""+lCurrTypeOidUsed;
		  if(vlistCurrencyType!=null && vlistCurrencyType.size()>0)
		  {		  
		  	int ilistCurrencyTypeCount = vlistCurrencyType.size();
			for(int i=0; i<ilistCurrencyTypeCount; i++)
			{
				CurrencyType currencyType =(CurrencyType)vlistCurrencyType.get(i);
				currencytypeid_value.add(currencyType.getName()+"("+currencyType.getCode()+")");												
				currencytypeid_key.add(""+currencyType.getOID());
			}
		  }		  
		  out.println(ControlCombo.draw("CURRENCY_TYPE", null, sSelectedCurrType, currencytypeid_key, currencytypeid_value, "onChange=\"javascript:changeCurrType()\"", ""));
		  %>
            </td>
            <td class="listgensell" width="30%" > 
              <div align="right" > 
                <input type="text" name="DEBET_CURR_SOURCE" size="15" style="text-align:right" onBlur="javascript:changeJournalDebet()" onKeyUp="javascript:getText(this)" value="<%=frmjurnaldetail.userFormatStringDecimal(dDebetAmount/dCurrRateUsed)%>">
              </div>
            </td>
            <td class="listgensell" width="30%" > 
              <div align="right" > 
                <input type="text" name="KREDIT_CURR_SOURCE" size="15" style="text-align:right" onBlur="javascript:changeJournalKredit()" onKeyUp="javascript:getText(this)" value="<%=frmjurnaldetail.userFormatStringDecimal(dCreditAmount/dCurrRateUsed)%>">
              </div>
            </td>
          </tr>
          <tr> 
            <td class="listgensell" width="5%" nowrap ><b><%=strTitle[SESS_LANGUAGE][5]%></b></td>
            <td class="listgensell" width="35%" > 
              <div align="left" > 
                <input type="text" name="STANDART_RATE" size="15" readonly style="background-color:#E8E8E8; text-align:right" value="<%=frmjurnaldetail.userFormatStringDecimal(dCurrRateUsed)%>">
              </div>
            </td>
            <td class="listgensell" width="30%" > 
              <div align="right" > 
                <input type="text" name="DEBET_CURR_BOOK_TYPE" size="15" readonly style="background-color:#E8E8E8; text-align:right" value="<%=frmjurnaldetail.userFormatStringDecimal(dDebetAmount)%>">
              </div>
            </td>
            <td class="listgensell" width="30%" > 
              <div align="right" > 
                <input type="text" name="KREDIT_CURR_BOOK_TYPE" size="15" readonly style="background-color:#E8E8E8; text-align:right" value="<%=frmjurnaldetail.userFormatStringDecimal(dCreditAmount)%>">
              </div>
            </td>
          </tr>
        </table>
      </td>
      <td width="3%" class="listgensell" valign="top" height="25">&nbsp;</td>
    </tr>
    <tr class="listgensell">
      <td width="3%">&nbsp;</td>
      <td width="94%">&nbsp;</td>
      <td width="3%">&nbsp;</td>
    </tr>
    <tr class="listgensell"> 
      <td width="3%" class="command">&nbsp;</td>
      <td width="94%" class="command">&nbsp;<a href="javascript:processToJDetail()"><%=strTitle[SESS_LANGUAGE][6]%></a> 
        | <a href="javascript:cancelProcess()"><%=strTitle[SESS_LANGUAGE][7]%></a></td>
      <td width="3%" class="command">&nbsp;</td>
    </tr>
    <tr> 
      <td width="3%" class="listgensell">&nbsp;</td>
      <td width="94%" class="listgensell">&nbsp;</td>
      <td width="3%" class="listgensell">&nbsp;</td>
    </tr>
  </table>
<script language="javascript">
	document.frmjdetailothcurr.CURRENCY_TYPE.focus();
</script>
</form>
</body>
</html>
