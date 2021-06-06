<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>

<!-- import aiso -->
<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %> 
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.specialJournal.*" %>
<%@ page import="com.dimata.aiso.form.specialJournal.*" %>
<%@ page import="com.dimata.aiso.form.periode.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.session.specialJournal.*" %>
<%@ page import="com.dimata.interfaces.journal.I_JournalType,
				 com.dimata.common.entity.contact.*"%>

<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../../main/checkuser.jsp" %>

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
//else
//{
%>

<!-- JSP Block -->
<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static String strTitle[][] = 
{
	{
		"No",
		"No Bukti",
		"Tgl Transaksi",
		"Supplier",
		"Amount",
		"Keterangan",
		"Seluruh hutang sudah terbayar. Silahkan tutup window ini dan lanjutkan proses berikutnya"
	},	
	{
		"No",//0
		"Reference",//1
		"Transaction Date",//2
		"Contact",//3
		"Amount",//4
		"Description",//5
		"All payabale is paid. Please close this window and continue next step journal. Thank you"		
	}
};

public static final String masterTitle[] = 
{
	"Daftar",
	"Payable"	
};

public static final String listTitle[] = 
{
	"Hutang",
	"List"	
};

public static final String strCekAmountTransaction[][] = {
	{"Nilai transaksi melebihi saldo","Nilai transaksi tidak boleh nol","Saldo = ","Nilai hutang melebihi nilai pembayaran","Selisihnya = "},
	{"Transaction Amount Over than Balance Amount","Transaction value has to be greater than zero","Balance Amount is ","Payable amount over than payment amount","Out of balance : "}
};

private static String getAccNameBaseonLanguage(Perkiraan objPerkiraan, int iLanguage){
	if(iLanguage == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
		return objPerkiraan.getAccountNameEnglish();
	else
		return objPerkiraan.getNama();
}

public boolean getTruedFalse(Vector vectAmount, double dAmount){
	for(int i=0;i<vectAmount.size();i++){
		double amountStatus = Double.parseDouble((String)vectAmount.get(i));
		if(amountStatus==dAmount)
			return true;
	}
	return false;
}

public String listDrawJurnalUmum(FRMHandler objFRMHandler, Vector objectClass, int language, Vector vAmount)
{
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	
	ctrlist.dataFormat("","5%","center","center");
	ctrlist.dataFormat(strTitle[language][0],"5%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"10%","center","center");	
	ctrlist.dataFormat(strTitle[language][3],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"15%","center","right");
	ctrlist.dataFormat(strTitle[language][5],"40%","center","left");			
	
	
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	
	String dateStrEntry = "";
    String dateStrTrans = "";
	String strContact = "";
	int index = -1;
	try
	{
		for (int i = 0; i < objectClass.size(); i++) 
		{
			 Vector vect = (Vector)objectClass.get(i);
			 
			 SpecialJournalMain objSpecialJournalMain = (SpecialJournalMain)vect.get(0);
			 ContactList objContactList = (ContactList)vect.get(1);	
			 
			 if(objContactList.getCompName().length() > 0){
			 		strContact = objContactList.getCompName();
			 }else{
			 		strContact = objContactList.getPersonName();
			 }
			 
			 
			 Vector rowx = new Vector(); 
			  
			 try
			 {
				Date dateTrans = objSpecialJournalMain.getTransDate();
				dateStrTrans = Formater.formatDate(dateTrans,"MMM dd, yyyy");
			 }
			 catch(Exception e) 
			 {
			 	System.out.println("Exc when format Date Transaction : " + e.toString());			 
			 }	
			 
			 String sReferenceDocNumber = objSpecialJournalMain.getReference();
			 
			 if(sReferenceDocNumber==null || sReferenceDocNumber.length()==0)
			 {
			 	sReferenceDocNumber = "-"; 
			 }	
			  
 			 String vNumber = objSpecialJournalMain.getVoucherNumber();
			 String strAmount = Formater.formatNumber(objSpecialJournalMain.getAmount(), "###");
			  
			 long lCntId = 0;
			 long lContactId = objSpecialJournalMain.getContactId();
			 if(lContactId != 0)
			 	lCntId = lContactId;
			 
			 String chk = "";
			 if(getTruedFalse(vAmount,objSpecialJournalMain.getAmount())){
			 	chk = "checked";	
			 }
			 rowx.add("<input type=\"checkbox\" "+chk+" name=\"cb_"+i+"\" onClick=\"javascript:getAmount()\" value=\""+objSpecialJournalMain.getAmount()+"\">");
			 rowx.add(""+(i+1));			 
			 rowx.add(sReferenceDocNumber);				 
			 rowx.add(dateStrTrans);           		 			 
			 rowx.add(strContact); 			 
			 rowx.add(Formater.formatNumber(objSpecialJournalMain.getAmount(), "##,###.##")); 			 
			 rowx.add(objSpecialJournalMain.getDescription()); 		
				
			
			 Perkiraan objPerkiraan = new Perkiraan();
			 if(objSpecialJournalMain.getIdPerkiraan() != 0){
			 	try{
					objPerkiraan = PstPerkiraan.fetchExc(objSpecialJournalMain.getIdPerkiraan());
				}catch(Exception e){
					System.out.println("Exception on payablelist.fetchObjPerkiraan :::: "+e.toString());
				}
			 }
			 String strAccName = getAccNameBaseonLanguage(objPerkiraan, language);		 
			 lstData.add(rowx);
			 lstLinkData.add(sReferenceDocNumber+"','"+strAmount+"','"+objSpecialJournalMain.getIdPerkiraan()+"','"+objSpecialJournalMain.getContactId()+"','"+
			 				strContact+"','"+strAccName);
			 
		}
     }
	 catch(Exception e)
	 {
	 	System.out.println("EXc : "+e.toString());
	 }
	 if(objectClass != null && objectClass.size() > 0)		 							
	 return ctrlist.drawMe(index);
	 else
	 return strTitle[language][6];
}

public String listDrawPayable(FRMHandler objFRMHandler, Vector objectClass, int language)
{
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	
	ctrlist.dataFormat(strTitle[language][0],"5%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"10%","center","center");	
	ctrlist.dataFormat(strTitle[language][3],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"15%","center","right");
	ctrlist.dataFormat(strTitle[language][5],"40%","center","left");			
	
	ctrlist.setLinkRow(1);
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	
	String dateStrEntry = "";
    String dateStrTrans = "";
	String strContact = "";
	int index = -1;
	System.out.println("objectClass.size() ====> "+objectClass.size());
	try
	{
		for (int i = 0; i < objectClass.size(); i++) 
		{
			 Vector vect = (Vector)objectClass.get(i);
			 
			 SpecialJournalMain objSpecialJournalMain = (SpecialJournalMain)vect.get(0);
			 ContactList objContactList = (ContactList)vect.get(1);	
			 
			 if(objContactList.getCompName().length() > 0){
			 		strContact = objContactList.getCompName();
			 }else{
			 		strContact = objContactList.getPersonName();
			 }
			 
			 
			 Vector rowx = new Vector(); 
			  
			 try
			 {
				Date dateTrans = objSpecialJournalMain.getTransDate();
				dateStrTrans = Formater.formatDate(dateTrans,"MMM dd, yyyy");
			 }
			 catch(Exception e) 
			 {
			 	System.out.println("Exc when format Date Transaction : " + e.toString());			 
			 }	
			 
			 String sReferenceDocNumber = objSpecialJournalMain.getReference();
			 
			 if(sReferenceDocNumber==null || sReferenceDocNumber.length()==0)
			 {
			 	sReferenceDocNumber = "-"; 
			 }	
			  
 			 String vNumber = objSpecialJournalMain.getVoucherNumber();
			 String strAmount = Formater.formatNumber(objSpecialJournalMain.getAmount(), "###");
			  
			 long lCntId = 0;
			 long lContactId = objSpecialJournalMain.getContactId();
			 if(lContactId != 0)
			 	lCntId = lContactId;
			 
			 rowx.add(""+(i+1));			 
			 rowx.add(sReferenceDocNumber);				 
			 rowx.add(dateStrTrans);           		 			 
			 rowx.add(strContact); 			 
			 rowx.add(Formater.formatNumber(objSpecialJournalMain.getAmount(), "##,###.##")); 			 
			 rowx.add(objSpecialJournalMain.getDescription()); 		
				
			
			 Perkiraan objPerkiraan = new Perkiraan();
			 if(objSpecialJournalMain.getIdPerkiraan() != 0){
			 	try{
					objPerkiraan = PstPerkiraan.fetchExc(objSpecialJournalMain.getIdPerkiraan());
				}catch(Exception e){
					System.out.println("Exception on payablelist.fetchObjPerkiraan :::: "+e.toString());
				}
			 }
			 String strAccName = getAccNameBaseonLanguage(objPerkiraan, language);		 
			 lstData.add(rowx);
			 lstLinkData.add(sReferenceDocNumber+"','"+strAmount+"','"+objSpecialJournalMain.getIdPerkiraan()+"','"+objSpecialJournalMain.getContactId()+"','"+
			 				strContact+"','"+strAccName);
			 
		}
     }
	 catch(Exception e)
	 {
	 	System.out.println("EXc : "+e.toString());
	 }
	 if(objectClass != null && objectClass.size() > 0)		 							
	 return ctrlist.drawMe(index);
	 else
	 return strTitle[language][6];
}
%>

<%
showMenu = false;
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
long journalID = FRMQueryString.requestLong(request,"journal_id");
int iSearchForm = FRMQueryString.requestInt(request, "src_from"); 
String dbalance = FRMQueryString.requestString(request,"dbalance");

int recordToGet = 15;
int vectSize = 0;

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Journal" : "Jurnal";  
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Journal Search" : "Kembali Ke Pencarian Jurnal";
String strCloseBook = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close Book" : "Tutup Buku";
String strSetupPeriod = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Setting Period" : "Setup Periode";
String strSelAmount = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Get selected amount" : "Ambil hutang";
String strCloseWindow = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close window" : "Tutup";


SessSpecialJurnal objSessSpecialJournal = new SessSpecialJurnal();
Vector objectClass = new Vector(1,1);
try{
	objectClass = (Vector)session.getValue("objectClass");
}catch(Exception e){
	objectClass = new Vector(1,1);
	e.printStackTrace();
}

String strWhClause = "";

if(objectClass != null && objectClass.size() > 0){
	strWhClause = " WHERE UN.REFERENCE NOT IN(";
	for(int i = 0; i < objectClass.size(); i++){
		Vector vTemp = (Vector)objectClass.get(i);
		SpecialJournalDetail objSJD = (SpecialJournalDetail)vTemp.get(0);
		
		if(objectClass.size() == 1){
			strWhClause += "'"+objSJD.getDescription()+"'";
		}else{
			if(i != (objectClass.size() - 1)){
				strWhClause += "'"+objSJD.getDescription()+"',";
			}else{
				strWhClause += "'"+objSJD.getDescription()+"'";
			}
		}
		
	}
	strWhClause += ");";
}



Vector listSpecialJournal = objSessSpecialJournal.listPayable(strWhClause);

double dAmount = 0;
Vector vAmount = new Vector(1,1);
if(iCommand == Command.SUBMIT){
	for(int i = 0; i < listSpecialJournal.size(); i++){
		String strAmount = request.getParameter("cb_"+i);
		double dAmnt = 0;
		if(strAmount != null && strAmount.length() > 0){
			dAmnt = Double.parseDouble(strAmount);
		}
		dAmount += dAmnt;
		vAmount.add(""+dAmnt);
	}
}
System.out.println("vAmount.size() = "+vAmount.size());
CtrlPeriode ctrlperiode = new CtrlPeriode(request);
int periodStatus = ctrlperiode.getStatusPeriod();
String periodMessage = ctrlperiode.msgPeriodeText[SESS_LANGUAGE][periodStatus];
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
<%if(privAdd){%>

function cmdEdit(ref,amount,idacc,idcnt,name,accname){
	var balance = parseFloat(document.frmsrcju.dbalance.value);
	var amnt = parseFloat(amount);
	var strBalance = balance.toLocaleString();
	if(amnt <= balance){
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DESCRIPTION]%>.value = ref;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DESCRIPTION]%>_TEXT.value = ref;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT]%>.value = amount;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT]%>_TEXT.value = amount;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN]%>.value = idacc;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN]%>_TEXT.value = accname;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CONTACT_ID]%>.value = idcnt;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.cont_name.value = name;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DESCRIPTION]%>.disabled = false;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT]%>.disabled = false;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN]%>.disabled = false;
		self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CONTACT_ID]%>.disabled = false;
		self.close();
	}else{
		alert("<%=strCekAmountTransaction[SESS_LANGUAGE][3]%>\n<%=strCekAmountTransaction[SESS_LANGUAGE][4]%> "+strBalance);
	}
}

function amountToMain(amount){
	self.opener.document.forms.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT]%>.value = amount;
	self.close();
}

function getAmount(){
	document.frmsrcju.command.value="<%=Command.SUBMIT%>";	
	document.frmsrcju.action="payablelist.jsp";
	document.frmsrcju.submit();
}



function first(){
	document.frmsrcju.command.value="<%=Command.FIRST%>";	
	document.frmsrcju.action="journallist.jsp";
	document.frmsrcju.submit();
}

function prev(){
	document.frmsrcju.command.value="<%=Command.PREV%>";	
	document.frmsrcju.action="journallist.jsp";
	document.frmsrcju.submit();
}

function next(){
	document.frmsrcju.command.value="<%=Command.NEXT%>";
	document.frmsrcju.target="_self";	
	document.frmsrcju.action="jlist.jsp";
	document.frmsrcju.submit();
}

function last(){
	document.frmsrcju.command.value="<%=Command.LAST%>";	
	document.frmsrcju.action="journallist.jsp";
	document.frmsrcju.submit();
}

function backtoWindow(){
	window.close();
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
		    <script language="JavaScript">
		  		window.focus();
		  </SCRIPT> 
            <form name="frmsrcju" method="post" action="">
              <input type="hidden" name="journal_id" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">
			  <input type="hidden" name="dbalance" value="<%=dbalance%>">		
			  <input type="hidden" name="src_from" value="<%=iSearchForm%>">  			  			  
              <input type="hidden" name="command" value="<%=iCommand%>">
			  <table width="100%">
			  <tr>
			  <td>
			  <table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
			  <tr>
			  <td>
              <table align="center" width="100%" border="0" cellpadding="0" cellspacing="2" class="search00">		
					<tr>
					  <td height="16" class="command">&nbsp;</td>
					  </tr>
					<tr>
					  <td height="16" class="command">
                        <%
							  FRMHandler objFRMHandler = new FRMHandler();
							  objFRMHandler.setDigitSeparator(sUserDigitGroup);
							  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);
							  if(iSearchForm == 1){				  
							  	out.println(listDrawJurnalUmum(objFRMHandler,listSpecialJournal,SESS_LANGUAGE,vAmount));
							  }else{
							  	out.println(listDrawPayable(objFRMHandler,listSpecialJournal,SESS_LANGUAGE));
							  }
				  		%>
				  </td>
					  </tr>
					<tr>
					  <td height="16" class="command">&nbsp;</td>
					</tr>
					<tr> 
					  <td height="16" class="command">
					  <%if(iSearchForm == 1){%>
					  		<input name="btnSbAmount" type="button" onClick="javascript:amountToMain('<%=Formater.formatNumber(dAmount,"###")%>')" value="<%=strSelAmount%>">
								
					 	<%}%>
					  <%if(listSpecialJournal.size() == 0){%>
					  		<input name="clsWin" type="button" value="<%=strCloseWindow%>" onClick="javascript:backtoWindow()">
					  <%}%>  
					  </td>
					</tr>
				
					<tr>
					  <td height="16" class="command"></td>
					  </tr>
					<tr> 
					  <td height="16" class="command">&nbsp;
					  </td>
					</tr>
					
					<tr> 
					  <td height="16" class="command">&nbsp;
					  </td>
					</tr>
              </table>
			  </td>
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>