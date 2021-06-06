<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*, 
				 com.dimata.common.entity.contact.ContactList,
                 com.dimata.common.entity.contact.PstContactList"
%>

<!-- import aiso -->
<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %> 
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.periode.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.session.jurnal.*" %>

<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
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
		"No Voucher",
		"Tgl Transaksi",
		"Dokumen Referensi",
		"Keterangan",
		"Debet",
		"Kredit",
		"Operator",
		"Tidak Ada Jurnal",
		"Kontak",
		"Perkiraan"
	},	
	{
		"Voucher No",//0
		"Transaction Date",//1
		"Reference Document",//2
		"Description",//3
		"Debet",//4
		"Credit",//5
		"Operator",//6
		"No Journal Available",//7
		"Contact",//8
		"Account Name" //9
	}
};

public static final String masterTitle[] = 
{
	"Jurnal Umum",
	"General Journal"	
};

public static final String listTitle[] = 
{
	"Daftar Jurnal",
	"List Journal"	
};

public String drawList(FRMHandler objFRMHandler, Vector objectClass, long oid, int language)
{
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"8%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","center");
	ctrlist.dataFormat(strTitle[language][2],"13%","center","left");
	ctrlist.dataFormat(strTitle[language][8],"15%","center","left");	
	ctrlist.dataFormat(strTitle[language][3],"25%","center","left");	
	ctrlist.dataFormat(strTitle[language][4],"12%","center","right");
	ctrlist.dataFormat(strTitle[language][5],"12%","center","right");			
	ctrlist.dataFormat(strTitle[language][6],"5%","center","left");
	
	ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	
	String dateStrEntry = "";
    String dateStrTrans = "";	
	String compName = "";
	String contactName = "";
	ContactList kontak = new ContactList();	
	int index = -1;
	try
	{
		for (int i = 0; i < objectClass.size(); i++) 
		{
			 Vector vect = (Vector)objectClass.get(i);
			 
			 JurnalUmum jUmum = (JurnalUmum)vect.get(0);		 
			 Periode periode = (Periode)vect.get(1);
			 AppUser aUser = (AppUser)vect.get(2);
			 kontak = (ContactList)vect.get(3);			
			 
			 contactName = kontak.getCompName();					 
			 
			 if(oid==jUmum.getOID())
			 {
			 	index =i;
			 } 
			 
			 Vector rowx = new Vector(); 
			  
			 try
			 {
				Date dateTrans = jUmum.getTglTransaksi();
				dateStrTrans = Formater.formatDate(dateTrans,"dd MMM yyyy");
			 }
			 catch(Exception e) 
			 {
			 	System.out.println("Exc when format Date Transaction : " + e.toString());			 
			 }	
			 
			 String sReferenceDocNumber = jUmum.getReferenceDoc();
			 if(sReferenceDocNumber==null || sReferenceDocNumber.length()==0)
			 {
			 	sReferenceDocNumber = "-"; 
			 }
			 
 			 Vector vectListJd = jUmum.getJurnalDetails();
			 double amountDt = SessJurnal.getBalanceSide(vectListJd,PstJurnalDetail.SIDE_DEBET);
			 double amountCr = SessJurnal.getBalanceSide(vectListJd,PstJurnalDetail.SIDE_CREDIT);
			 
			 rowx.add(jUmum.getSJurnalNumber());				 
			 rowx.add(dateStrTrans);           		 			 
			 rowx.add(sReferenceDocNumber);
				 if(contactName.length() > 0){
					rowx.add(contactName); 
				 }else{
					rowx.add(kontak.getPersonName());
				 }			 
			 rowx.add(jUmum.getKeterangan());
			 rowx.add(objFRMHandler.userFormatStringDecimal(amountDt)); 	
			 rowx.add(objFRMHandler.userFormatStringDecimal(amountCr)); 			 
			 rowx.add(aUser.getLoginId());			 
					 
			 lstData.add(rowx);
			 lstLinkData.add(String.valueOf(jUmum.getOID()));
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
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE JOURNAL PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES JURNAL SEBELUM MELAKUKAN PROSES LAIN";
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
	session.removeValue(SessJurnal.SESS_JURNAL_MAIN);	
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

SessJurnal objSessJurnal = new SessJurnal();
vectSize = objSessJurnal.getCount(srcJurnalUmum);

if(iCommand!=Command.BACK)
{  
	if((iCommand==Command.NONE)||(iCommand==Command.LIST))
	{
		iCommand = Command.LAST;	
	}
	CtrlJurnalUmum objCtrlJurnalUmum = new CtrlJurnalUmum(request);
	start = objCtrlJurnalUmum.actionList(iCommand, start, vectSize, recordToGet);	
}
else
{
	iCommand = Command.LIST;
}

Vector listJurnalUmum = objSessJurnal.listJurnalUmum(srcJurnalUmum, start, recordToGet);

CtrlPeriode ctrlperiode = new CtrlPeriode(request);
int periodStatus = ctrlperiode.getStatusPeriod();
String periodMessage = ctrlperiode.msgPeriodeText[SESS_LANGUAGE][periodStatus];
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
<%if(privAdd){%>
function cmdAdd(){
	document.frmsrcju.journal_id.value="0";	
	document.frmsrcju.command.value="<%=Command.ADD%>";
	document.frmsrcju.add_type.value="<%=ADD_TYPE_LIST%>";	
	document.frmsrcju.target="_self";	
	document.frmsrcju.action="jumum.jsp";
	document.frmsrcju.submit();
}
<%}%>

function cmdEdit(oid){
	document.frmsrcju.journal_id.value=oid;	
	document.frmsrcju.command.value="<%=Command.EDIT%>";
	document.frmsrcju.target="_self";	
	document.frmsrcju.action="jumum.jsp";
	document.frmsrcju.submit();
}

function first(){
	document.frmsrcju.command.value="<%=Command.FIRST%>";
	document.frmsrcju.target="_self";	
	document.frmsrcju.action="jlist.jsp";
	document.frmsrcju.submit();
}

function prev(){
	document.frmsrcju.command.value="<%=Command.PREV%>";
	document.frmsrcju.target="_self";	
	document.frmsrcju.action="jlist.jsp";
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
	document.frmsrcju.target="_self";	
	document.frmsrcju.action="jlist.jsp";
	document.frmsrcju.submit();
}

function cmdBack(){
	document.frmsrcju.command.value="<%=Command.BACK%>";
	document.frmsrcju.target="_self";	
	document.frmsrcju.action="jsearch.jsp";
	document.frmsrcju.submit();
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
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
      <%@ include file = "../main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> &gt; <%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmsrcju" method="post" action="">
              <input type="hidden" name="journal_id" value="journalID">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">			  			  			  
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr> 
                  <td> 
                    <hr>
                  </td>
                </tr>
                <%if(periodStatus>ctrlperiode.MSG_PER_OK){%>
                <tr> 
                  <td colspan="2" class="msgErrComment"><%=periodMessage%></td>
                </tr>
                <%}%>
                <tr> 				
			  </table>	
                <%if((listJurnalUmum!=null)&&(listJurnalUmum.size()>0)){ %>                 
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(drawList(objFRMHandler,listJurnalUmum,journalID,SESS_LANGUAGE));
				  %>                            
                  <%=ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%>               
                <%} else {%>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">				
                <tr> 
                  <td><span class="comment"><%=strTitle[SESS_LANGUAGE][7]%></span></td>
                </tr>
			  </table>
                <%  }	%>
				
              <table width="100%" border="0" cellspacing="2" cellpadding="0">				
				<%if((periodStatus==ctrlperiode.MSG_PER_OK)||(periodStatus==ctrlperiode.MSG_PER_LAST)||(periodStatus==ctrlperiode.MSG_PER_LAST_DUE)){%>					
					<tr> 
					  <td height="16" class="command">
  					  <%if((privAdd)){%>
					  <a href="javascript:cmdAdd()"><%=strAdd%></a> |					  					  					  					  
					  <%}%>					  
					  <a href="javascript:cmdBack()"><%=strBack%></a>					  
					  </td>
					</tr>
				<%}else{%>
					<%if(periodStatus==ctrlperiode.MSG_NO_PER){%>
					<tr> 
					  <td height="16" class="command"><a href="javascript:cmdSetPeriod()"><%=strSetupPeriod%></a>
					  | <a href="javascript:cmdBack()"><%=strBack%></a>
					  </td>
					</tr>
					<%}else{%>
					<tr> 
					  <td height="16" class="command"><a href="javascript:cmdCloseBook()"><%=strCloseBook%></a>
					  | <a href="javascript:cmdBack()"><%=strBack%></a>
					  </td>
					</tr>
					<%}%>
                <%}%>
              </table>
            </form>
            <!-- #EndEditable --></td>
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