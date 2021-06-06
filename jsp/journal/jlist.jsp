<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

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
		"Tidak Ada Jurnal"
	},	
	{
		"Voucher No",
		"Transaction Date",
		"Reference Document",
		"Description",
		"Debet",
		"Credit",
		"Operator",
		"No Journal Available"
	}
};

public static final String masterTitle[] = 
{
	"Daftar Jurnal",
	"List Journal"	
};

public static final String listTitle[] = 
{
	"Jurnal Umum",
	"General Journal"	
};

public String listDrawJurnalUmum(JspWriter outObj, FRMHandler objFRMHandler, Vector objectClass,long oid, int language)
{
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"8%","left","left");
	ctrlist.dataFormat(strTitle[language][1],"10%","left","left");
	ctrlist.dataFormat(strTitle[language][2],"13%","left","left");	
	ctrlist.dataFormat(strTitle[language][3],"35%","left","left");
	ctrlist.dataFormat(strTitle[language][4],"12%","right","right");
	ctrlist.dataFormat(strTitle[language][5],"12%","right","right");			
	ctrlist.dataFormat(strTitle[language][6],"10%","left","left");
	
	ctrlist.setLinkRow(0);
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
			 
			 JurnalUmum jUmum = (JurnalUmum)vect.get(0);		 
			 Periode periode = (Periode)vect.get(1);
			 AppUser aUser = (AppUser)vect.get(2);
			 
			 if(oid==jUmum.getOID())
			 {
			 	index =i;
			 } 
			 
			 Vector rowx = new Vector(); 
			  
			 try
			 {
				Date dateTrans = jUmum.getTglTransaksi();
				dateStrTrans = Formater.formatDate(dateTrans,"MMM dd, yyyy");
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
			 
			 //rowx.add(jUmum.getVoucherNo()+"-"+SessJurnal.intToStr(jUmum.getVoucherCounter(),4));	
			 rowx.add(jUmum.getSJurnalNumber()); 			 
			 rowx.add(dateStrTrans);           		 			 
			 rowx.add(sReferenceDocNumber); 			 
			 rowx.add(jUmum.getKeterangan()); 			 
			 rowx.add("");//objFRMHandler.userFormatStringDecimal(amountDt)); 		 	 		 		 
			 rowx.add("");//objFRMHandler.userFormatStringDecimal(amountCr)); 			 			 
			 rowx.add(aUser.getLoginId());			 
					 
			 lstData.add(rowx);
			 lstLinkData.add(String.valueOf(jUmum.getOID()));
                         
                         if(jUmum.getJurnalDetails()!=null){
                             for(int id=0;id<jUmum.getJurnalDetailsSize();id++){
                                 JurnalDetail jd = (JurnalDetail)jUmum.getJurnalDetail(id);
                                 if(jd!=null){
                                     rowx = new Vector(); // print detail journal
                                     rowx.add("");
                                     rowx.add("");
                                     rowx.add(""+jd.getAccount().getNoPerkiraan());
                                     String namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? jd.getAccount().getAccountNameEnglish() : jd.getAccount().getNama();
                                     rowx.add(""+namaAcc);
                                     rowx.add(FrmJurnalDetail.userFormatStringDecimal(jd.getDebet()));
                                     rowx.add(FrmJurnalDetail.userFormatStringDecimal(jd.getKredit()));
                                     rowx.add("");
                                     lstData.add(rowx);
                                     lstLinkData.add("");
                                  }
                             }
                         }
                                     rowx = new Vector(); // print detail journal
                                     rowx.add("");
                                     rowx.add("");
                                     rowx.add("");
                                     rowx.add("");
                                     rowx.add("");
                                     rowx.add("");
                                     rowx.add("");
                                     lstData.add(rowx);
                                     lstLinkData.add(String.valueOf(jUmum.getOID()));
                         
                         
                         
                         
		}
     }
	 catch(Exception e)
	 {
	 	System.out.println("EXc : "+e.toString());
	 }	
        try{ 							
	 ctrlist.drawMe(outObj, index);
         } catch(Exception io){
             System.out.println(io);
         }
         return "";
}
%>

<%
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE JOURNAL PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES JURNAL SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int exportall = FRMQueryString.requestInt(request, "exportall"); 
int start = FRMQueryString.requestInt(request, "start"); 
int iEditJournal = FRMQueryString.requestInt(request, "edit_journal"); 
long journalID = FRMQueryString.requestLong(request,"journal_id");
int recordToGet = 25;
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
		iCommand = Command.FIRST;	
		
	}
	CtrlJurnalUmum objCtrlJurnalUmum = new CtrlJurnalUmum(request);
	start = objCtrlJurnalUmum.actionList(iCommand, start, vectSize, recordToGet);	
}
else
{
	iCommand = Command.LIST;
}

System.out.println("start 2 ===> "+start);
System.out.println("vectSize 2 ===> "+vectSize);
	
Vector listJurnalUmum = objSessJurnal.listJurnalUmum(srcJurnalUmum, start, recordToGet);

if(exportall==1){
        Vector listJurnalUmumAll = objSessJurnal.listJurnalUmum(srcJurnalUmum, 0, 3000);
        session.putValue("JOURNAL_LIST",listJurnalUmumAll);
    } else {
        session.putValue("JOURNAL_LIST",listJurnalUmum);
    }

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
	document.frmsrcju.target="_self";	
	document.frmsrcju.action="jumum.jsp";
	document.frmsrcju.submit();
}
<%}%>

function cmdEdit(oid){
	document.frmsrcju.journal_id.value=oid;	
	document.frmsrcju.command.value="<%=Command.EDIT%>";
	document.frmsrcju.edit_journal.value="<%=iEditJournal%>";
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

function exportAll(){
        alert("Export all will take time to process !");
	document.frmsrcju.command.value="<%=Command.LIST%>";
        document.frmsrcju.exportall.value="1";
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

function printXLS(){	 
		var linkPage = "<%=reportroot%>report.jurnal.JournalListXls";       
		window.open(linkPage);  				
}
</script>
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmsrcju" method="post" action="">
              <input type="hidden" name="journal_id" value="journalID">
              <input type="hidden" name="start" value="<%=start%>">
	      <input type="hidden" name="edit_journal" value="<%=iEditJournal%>">
              <input type="hidden" name="add_type" value="">	
              <input type="hidden" name ="exportall" value="0">
              <input type="hidden" name="command" value="<%=iCommand%>">
			  <table width="100%">
				  <tr>
				  	<td><div align="center">
						<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
							<tr>
								<td>
									<table width="100%" class="list">
			  <tr>
			  <td>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">                
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
				  //out.println(listDrawJurnalUmum(objFRMHandler,listJurnalUmum,journalID,SESS_LANGUAGE));
                                  listDrawJurnalUmum(out, objFRMHandler,listJurnalUmum,journalID,SESS_LANGUAGE);
				  %>
				  <%ctrlLine.initDefault(SESS_LANGUAGE,"");%>                            
                  <%=ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%>               
                  <input name="btnExport" type="button" onClick="javascript:printXLS()" value="Export to Excel"> &nbsp;&nbsp;&nbsp;
                  <input name="btnExportAll" type="button" onClick="javascript:exportAll()" value="Export all ">
                <%} else {%>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">				
                <tr> 
                  <td><span class="comment"><%=strTitle[SESS_LANGUAGE][7]%></span></td>
                </tr>
			  </table>
                <%  }	%>
				
              <table width="100%" border="0" cellspacing="2" cellpadding="0">							
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
					  <td height="16" colspan="2" class="command"><a href="javascript:cmdSetPeriod()">
					    <%}else{%>
                        <%if(periodStatus==ctrlperiode.MSG_NO_PER){%>
                        <%=strSetupPeriod%></a>
					  | <a href="javascript:cmdBack()"><%=strBack%></a>
					  </td>
					</tr>
					<%}else{%>
					<tr> 
					  <td height="16" colspan="2" class="command"><a href="javascript:cmdCloseBook()"><%=strCloseBook%></a>
					  | <a href="javascript:cmdBack()"><%=strBack%></a>
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
					</div></td>
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
<%if(exportall==1){
%>
<script language="javascript">
    printXLS();
</script>
<%}%>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>