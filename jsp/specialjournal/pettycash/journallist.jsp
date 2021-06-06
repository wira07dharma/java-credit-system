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
<%@ page import="com.dimata.interfaces.journal.I_JournalType"%>

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
		"No",
		"No Jurnal",
		"Tgl Transaksi",
		"Dokumen Referensi",
		"Keterangan",
		"Amount",		
		"Operator",
		"Tidak Ada Jurnal"
	},	
	{
		"No",//0
		"Journal No",//1
		"Transaction Date",//2
		"Reference Document",//3
		"Description",//4
		"Amount",//5		
		"Operator",//6
		"There is no journal"//7
	}
};

public static final String masterTitle[] = 
{
	"Daftar Jurnal",
	"List Journal"	
};

public static final String listTitle[] = 
{
	"Kas Kecil",
	"Petty Cash"	
};

public String listDrawJurnalUmum(FRMHandler objFRMHandler, Vector objectClass,long oid, int language, int start)
{
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"5%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","center");
	ctrlist.dataFormat(strTitle[language][2],"13%","center","center");	
	ctrlist.dataFormat(strTitle[language][3],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"40%","center","left");
	ctrlist.dataFormat(strTitle[language][5],"12%","center","right");			
	ctrlist.dataFormat(strTitle[language][6],"10%","center","left");
	
	ctrlist.setLinkRow(1);
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	
	String dateStrEntry = "";
    String dateStrTrans = "";
	int index = -1;
	try
	{
		for (int i = 0; i < objectClass.size(); i++) 
		{
			 Vector vect = (Vector)objectClass.get(i);
			 
			 SpecialJournalMain objSpecialJournalMain = (SpecialJournalMain)vect.get(0);		 
			 Periode periode = (Periode)vect.get(1);
			 AppUser aUser = (AppUser)vect.get(2);
			 
			 if(oid==objSpecialJournalMain.getOID())
			 {
			 	index =i;
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
			 
			 rowx.add(""+(i+1+start));			 
			 rowx.add(objSpecialJournalMain.getVoucherNumber());				 
			 rowx.add(dateStrTrans);           		 			 
			 rowx.add(sReferenceDocNumber); 			 
			 rowx.add(objSpecialJournalMain.getDescription()); 			 
			 rowx.add(objFRMHandler.userFormatStringDecimal(objSpecialJournalMain.getAmount())); 		
			 rowx.add(aUser.getLoginId());			 
					 
			 lstData.add(rowx);
			 lstLinkData.add(String.valueOf(objSpecialJournalMain.getOID()));
		}
     }
	 catch(Exception e)
	 {
	 	System.out.println("EXc : "+e.toString());
	 }		 							
	 return ctrlist.drawMe(index);
}
%>

<%
showMenu = false;
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
long journalID = FRMQueryString.requestLong(request,"journal_id");
int recordToGet = 15;
int vectSize = 0;

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Journal" : "Jurnal";  
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Journal Search" : "Kembali Ke Pencarian Jurnal";
String strCloseBook = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close Book" : "Tutup Buku";
String strAddJournal = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Journal" : "Tambah Jurnal";
String strSetupPeriod = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Setting Period" : "Setup Periode";

SrcJurnalUmum srcJurnalUmum = new SrcJurnalUmum();
FrmSrcJurnalUmum frmSrcJurnalUmum = new FrmSrcJurnalUmum(request);
if((iCommand==Command.BACK) && (session.getValue(SrcJurnalUmum.SESS_SEARCH_JURNAL_UMUM)!=null))
{
	srcJurnalUmum = (SrcJurnalUmum)session.getValue(SrcJurnalUmum.SESS_SEARCH_JURNAL_UMUM); 
}
else
{
	frmSrcJurnalUmum.requestEntityObject(srcJurnalUmum);
}

try
{
	session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);	
}
catch(Exception e)
{
	System.out.println("--- Remove session error ---");
}

if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try
	{
		srcJurnalUmum = (SrcJurnalUmum)session.getValue(SrcJurnalUmum.SESS_SEARCH_JURNAL_UMUM);
	}
	catch(Exception e)
	{
		srcJurnalUmum = new SrcJurnalUmum();
	}
}

if(srcJurnalUmum==null)
{
	srcJurnalUmum = new SrcJurnalUmum();
} 

session.putValue(SrcJurnalUmum.SESS_SEARCH_JURNAL_UMUM, srcJurnalUmum);

SessSpecialJurnal objSessSpecialJournal = new SessSpecialJurnal();
vectSize = objSessSpecialJournal.getCount(srcJurnalUmum, I_JournalType.TIPE_SPECIAL_JOURNAL_PETTY_CASH, PstSpecialJournalMain.STS_KREDIT);

if(iCommand!=Command.BACK)
{  
	if((iCommand==Command.NONE)||(iCommand==Command.LIST))
	{
		iCommand = Command.LAST;	
	}
	CtrlSpecialJournalMain ctrlSpecialJournalMain = new CtrlSpecialJournalMain(request);
	start = ctrlSpecialJournalMain.actionList(iCommand, start, vectSize, recordToGet);	
}
else
{
	iCommand = Command.LIST;
}

Vector listSpecialJournal = objSessSpecialJournal.listJurnalUmum(srcJurnalUmum, start, recordToGet, I_JournalType.TIPE_SPECIAL_JOURNAL_PETTY_CASH, PstSpecialJournalMain.STS_KREDIT);

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
function cmdAdd(){
	document.frmsrcju.journal_id.value="0";	
	document.frmsrcju.command.value="<%=Command.ADD%>";
	document.frmsrcju.add_type.value="<%=ADD_TYPE_LIST%>";		
	document.frmsrcju.action="journalmain.jsp";
	document.frmsrcju.submit();
}
<%}%>

function cmdEdit(oid){
	document.frmsrcju.journal_id.value=oid;	
	document.frmsrcju.command.value="<%=Command.EDIT%>";	
	document.frmsrcju.action="journalmain.jsp";
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
	document.frmsrcju.action="journallist.jsp";
	document.frmsrcju.submit();
}

function last(){
	document.frmsrcju.command.value="<%=Command.LAST%>";	
	document.frmsrcju.action="journallist.jsp";
	document.frmsrcju.submit();
}

function cmdBack(){
	document.frmsrcju.command.value="<%=Command.BACK%>";
	document.frmsrcju.target="_self";	
	document.frmsrcju.action="journalsearch.jsp";
	document.frmsrcju.submit();
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
            <form name="frmsrcju" method="post" action="">
              <input type="hidden" name="journal_id" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">			  			  			  
              <input type="hidden" name="command" value="<%=iCommand%>">
			  
			  <table width="100%">
				  <tr>
				  	<td>
						<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
							<tr>
								<td>
									<table width="100%" border="0" cellpadding="0" cellspacing="2" class="list">				
									
					<tr>
					  <td height="16" colspan="2" class="command"><span class="msgErrComment">
					    <%if(periodStatus>ctrlperiode.MSG_PER_OK){%>
					    <%=periodMessage%>
					    <%}%>
                      </span></td>
					  </tr>
					<tr>
					  <td height="16" colspan="2" class="command"><span class="comment">
					    <%if((listSpecialJournal!=null)&&(listSpecialJournal.size()>0)){ %>
                        <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(listDrawJurnalUmum(objFRMHandler,listSpecialJournal,journalID,SESS_LANGUAGE,start));
				  %>
				  		<% ctrlLine.initDefault(SESS_LANGUAGE,"");%>
                        <%=ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%>
                        <%} else {%>
                        <%=strTitle[SESS_LANGUAGE][7]%></span>
                        <%}%></td>
					  </tr>
					<tr>
					  <td height="16" colspan="2" class="command">&nbsp;</td>
					</tr>
					<tr> 
					  <td height="16" class="command">
					  &nbsp;&nbsp;
                      <%if((periodStatus==ctrlperiode.MSG_PER_OK)||(periodStatus==ctrlperiode.MSG_PER_LAST)||(periodStatus==ctrlperiode.MSG_PER_LAST_DUE)){%>
                      <a href="javascript:cmdBack()"><%=strBack%></a> </td>
					  <td class="command"><div align="right">
                        <%if((privAdd)){%>
                        <!-- input type="button" name="addJournal" value="<%//=strAddJournal%>" onClick="javascript:cmdAdd()" -->
                        <%}%>
					    </div></td>
					</tr>
				
					<tr>
					  <td height="16" colspan="2" class="command">&nbsp;</td>
					  </tr>
					<tr> 
					  <td height="16" colspan="2" class="command"><a href="javascript:cmdSetPeriod()"><a href="javascript:cmdSetPeriod()">
					    <%}else{%>
                        <%if(periodStatus==ctrlperiode.MSG_NO_PER){%>
					  </a><%=strSetupPeriod%>| <a href="javascript:cmdBack()"><%=strBack%></a><%}else{%>					  </td>
					</tr>
					
					<tr> 
					  <td height="16" colspan="2" class="command"><a href="javascript:cmdCloseBook()"><%=strCloseBook%></a>
					  | <a href="javascript:cmdBack()"><%=strBack%></a><%}%>
                <%}%>
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