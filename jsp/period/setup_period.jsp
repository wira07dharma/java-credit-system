<%@ page language = "java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- package dimata-->
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- package aiso-->
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.form.periode.*" %>
<%@ page import = "com.dimata.aiso.session.periode.*" %>

<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_PERIOD, AppObjInfo.G2_PERIOD_SETUP, AppObjInfo.OBJ_PERIOD_SETUP); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
 boolean privView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
 boolean privUpdate = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));

 //if of "hasn't access" condition 
 if (!privView && !privUpdate) {
%>
<script language = "javascript">
 window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
 } else {
%>

<%!
 /* this constant used to list text of listHeader */
 public static final String textJspTitle[][] = {
  {"Tanggal Awal", "Tanggal Akhir", "Terakhir Entry", "Nama", "Keterangan", "Status"},
  {"Start Date", "Last Date", "Last Entry", "Name", "Description", "Status"}	
 };

public String getJspTitle(String textJsp[][],
                          int index,
                          int language,
                          String prefiks,
                          boolean addBody)
{
 String result = "";
 if (addBody) {
  if (language == com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT) {	
   result = textJsp[language][index] + " " + prefiks;
  } else {
   result = prefiks + " " + textJsp[language][index];		
  }
 } else {
  result = textJsp[language][index];
 } 
 return result;
}

public static final String pageTitle[] = {"Setup Periode", "Setup Period"	
};

public String drawListPeriode(Vector objectClass,
                              long oid,
                              int language)
{
 ControlList ctrlist = new ControlList();	
 ctrlist.setAreaWidth("100%");
 ctrlist.setListStyle("listgen");
 ctrlist.setTitleStyle("listgentitle");
 ctrlist.setCellStyle("listgensell");
 ctrlist.setCellStyleOdd("listgensellOdd");
 ctrlist.setHeaderStyle("listgentitle");
 ctrlist.setRowSelectedStyle("listSelCell");

 ctrlist.dataFormat(getJspTitle(textJspTitle,3,language,"",false),"20%","left","left");		
 ctrlist.dataFormat(getJspTitle(textJspTitle,4,language,"",false),"39%","left","left");
 ctrlist.dataFormat(getJspTitle(textJspTitle,0,language,"",false),"10%","left","left");
 ctrlist.dataFormat(getJspTitle(textJspTitle,1,language,"",false),"10%","left","left");
 ctrlist.dataFormat(getJspTitle(textJspTitle,2,language,"",false),"10%","left","left");	
 ctrlist.dataFormat(getJspTitle(textJspTitle,5,language,"",false),"11%","left","left");

 ctrlist.setLinkRow(0);
 ctrlist.setLinkSufix("");

 Vector lstData = ctrlist.getData();
 Vector lstLinkData = ctrlist.getLinkData();						
	
 ctrlist.setLinkPrefix("javascript:cmdEdit('");
 ctrlist.setLinkSufix("')");
 ctrlist.reset();
	
 String dateStrStart = "";
 String dateStrLast = "";
 String dateStrLastEntry = "";
 String strPosted = "";
 int index = -1;
	
 for (int i = 0; i < objectClass.size(); i++) {
  Periode periode = (Periode) objectClass.get(i);
  if (oid == periode.getOID()) {
   index = i;
  }
  Vector rowx = new Vector(); 

  rowx.add(periode.getNama()); 
  rowx.add(periode.getKeterangan()); 

  try {
   Date dateStart = periode.getTglAwal();
   dateStrStart = Formater.formatDate(dateStart, "MMM dd, yyyy");
  } catch (Exception e) {
  }		
  rowx.add(dateStrStart); 
  
  try {
   Date dateLast = periode.getTglAkhir();
   dateStrLast = Formater.formatDate(dateLast, "MMM dd, yyyy");
  } catch (Exception e) {
  }	
  rowx.add(dateStrLast); 
  
  try {
   Date dateLastEntry = periode.getTglAkhirEntry();
   dateStrLastEntry = Formater.formatDate(dateLastEntry, "MMM dd, yyyy");
  } catch (Exception e) {
  }	
  rowx.add(dateStrLastEntry); 
         
  switch (periode.getPosted()) {
  case PstPeriode.PERIOD_OPEN : strPosted = "Open";
  break;
  case PstPeriode.PERIOD_CLOSED : strPosted = "Close";
  break;
  case PstPeriode.PERIOD_PREPARE_OPEN : strPosted = "Prepare Open";
  break;
  default : strPosted = "Unknown";
  }
		 
  rowx.add(strPosted); 
  lstData.add(rowx);
  lstLinkData.add(String.valueOf(periode.getOID()));
 }						
 return ctrlist.drawMe(index);	   	
}
%>

<%
/* get request from hidden form */
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
long periodeID = FRMQueryString.requestLong(request, "periode_id");
int listCommand = FRMQueryString.requestInt(request, "list_command");
if (listCommand == Command.NONE) {
 listCommand = Command.LIST;
}

/* variable declaration */
int recordToGet = 5;
String whereClause = "";
String orderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];

/**
* Setup controlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String titles[] = {"Periode Akuntansi", "Accounting Period"};
String currPageTitle = titles[SESS_LANGUAGE];
String strAdd = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
String strSave = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
String strBack = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCloseBook = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close Book" : "Tutup Buku";
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete this " : "Anda Yakin akan Menghapus ") + currPageTitle;
if (SESS_LANGUAGE != com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
    delConfirm += " ini";
delConfirm += " ?";

String strDeleteAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);

Vector listPeriode = new Vector(1,1);

Control controlList = new Control();
CtrlPeriode ctrlPeriode = new CtrlPeriode(request);
FrmPeriode frmPeriode = ctrlPeriode.getForm();

int ctrlErr = ctrlPeriode.action(iCommand, periodeID, periodInterval, lastEntryDuration);
Periode periode = ctrlPeriode.getPeriode(); 
int periodStatus = ctrlPeriode.getStatusPeriod();
String periodMessage = ctrlPeriode.msgPeriodeText[SESS_LANGUAGE][periodStatus];

int vectSize = PstPeriode.getCount(whereClause);

int startYear = 0;
int startMonth = 0;
int startDate = 0;
int lastYear = 0;
int lastMonth = 0;
int lastDate = 0;
if (iCommand == Command.EDIT || iCommand == Command.SAVE) {
 startYear = periode.getTglAwal().getYear() + 1900;
 startMonth = periode.getTglAwal().getMonth() + 1;
 startDate = periode.getTglAwal().getDate();
 lastYear = periode.getTglAkhir().getYear() + 1900;
 lastMonth = periode.getTglAkhir().getMonth() + 1;
 lastDate = periode.getTglAkhir().getDate();
}

String msgString = ctrlPeriode.getMessage();
int iErrCode = ctrlPeriode.getErrCode();

//start = ctrlPeriode.getStart();
if (start >= vectSize)
    start -= recordToGet;
if (start < 0)
    start = 0;

start = controlList.actionList(listCommand, start, vectSize, recordToGet);
listPeriode = PstPeriode.list(start, recordToGet, whereClause, orderBy);

String readOnlyCombo = "";
if (PstPeriode.isTherePeriod()) {
 readOnlyCombo = "disabled";
}
%>

<%

 Date firstDateOfNewPeriod = periode.getTglAwal();
 Date lastDateOfNewPeriod = periode.getTglAkhir();
 Date lastEntryDate = periode.getTglAkhirEntry();   
 
 int iPeriodeCount = PstPeriode.getCount(""); 
 
 if (iCommand == Command.ADD) {
  firstDateOfNewPeriod = PstPeriode.getFirstDateOfNewPeriod();
  int year = firstDateOfNewPeriod.getYear();
  int month = firstDateOfNewPeriod.getMonth() + periodInterval - 1;
  int date = firstDateOfNewPeriod.getDate();
  GregorianCalendar gregCal = new GregorianCalendar(year + 1900,  month, date);
  date = gregCal.getActualMaximum(gregCal.DAY_OF_MONTH);
  lastDateOfNewPeriod = new Date(year, month, date);
  lastEntryDate = new Date(year, month, date + lastEntryDuration);
 } else if (iCommand == Command.SAVE && frmPeriode.errorSize() > 0 && iPeriodeCount > 0) {
     try {
        Periode objPeriode = PstPeriode.fetchExc(periodeID);
        firstDateOfNewPeriod = objPeriode.getTglAwal();
        lastDateOfNewPeriod = objPeriode.getTglAkhir();
     } catch (Exception error) {
         System.out.println("setup_period.jsp : " + error.toString());
     }
 }
 
 if (firstDateOfNewPeriod == null && iPeriodeCount <= 0) {
     Date currDate = new Date();
     firstDateOfNewPeriod = new Date(currDate.getYear(), currDate.getMonth(), 1);
 }
 //int diffYear = firstDateOfNewPeriod.getYear() - (new Date()).getYear();
 
 String strNotes[] = {"Catatan", "Note"};
 String strReqs[] = {"Harus diisi", "Entry required"};
 String strDel[] = {"Hapus Periode", "Delete Period"};
 
 %>

<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">

function addNew() {
    document.frmperiod.periode_id.value = "0";
    document.frmperiod.command.value = "<%=Command.ADD%>";
    document.frmperiod.action = "setup_period.jsp#down";
    document.frmperiod.submit();
}

function cmdSave() {
    document.frmperiod.command.value = "<%=Command.SAVE%>";
    document.frmperiod.action = "setup_period.jsp#down";
    document.frmperiod.submit();
}

function cmdEdit(oid){
	document.frmperiod.periode_id.value=oid;
	document.frmperiod.command.value="<%=Command.EDIT%>";
	document.frmperiod.action="setup_period.jsp#down";
	document.frmperiod.submit();
}

function cmdCancelDel() {
    document.frmperiod.command.value = "<%=Command.EDIT%>";
    document.frmperiod.action = "setup_period.jsp#down";
    document.frmperiod.submit();
}

function first(){
	document.frmperiod.list_command.value="<%=Command.FIRST%>";
	document.frmperiod.action="setup_period.jsp";
	document.frmperiod.submit();
}

function prev(){
	document.frmperiod.list_command.value="<%=Command.PREV%>";
	document.frmperiod.action="setup_period.jsp";
	document.frmperiod.submit();
}

function next(){
	document.frmperiod.list_command.value="<%=Command.NEXT%>";
	document.frmperiod.action="setup_period.jsp";
	document.frmperiod.submit();
}

function last(){
	document.frmperiod.list_command.value="<%=Command.LAST%>";
	document.frmperiod.action="setup_period.jsp";
	document.frmperiod.submit();
}

function cmdBackList(){
	document.frmperiod.command.value="<%=Command.NONE%>"; 
	document.frmperiod.list_command.value="<%=Command.LIST%>";
	document.frmperiod.action="setup_period.jsp";
	document.frmperiod.submit();
}
function cmdCloseBook(){
	var act = "<%=approot%>" + "/period/close_book.jsp";
	document.frmperiod.command.value="<%=Command.NONE%>";
	document.frmperiod.action=act;
	document.frmperiod.submit();	
}

function cmdDelConfirm() {
    document.frmperiod.command.value = "<%=Command.ASK%>";
    document.frmperiod.action = "setup_period.jsp#down";
    document.frmperiod.submit();
}

function cmdDel() {
    document.frmperiod.command.value = "<%=Command.DELETE%>";
    document.frmperiod.action = "setup_period.jsp";
    document.frmperiod.submit();
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=currPageTitle%> : <font color="#CC3300"><%=pageTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
     <form name="frmperiod" method="post">
      <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
      <input type="hidden" name="list_command" value="<%=Command.LIST%>">
      <input type="hidden" name="start" value="<%=start%>">
      <input type="hidden" name="periode_id" value="<%=periodeID%>">
	  
      <% 
	  if (PstPeriode.isTherePeriod()) 
	  { 
		  %>
		   <input type="hidden" name="<%=FrmPeriode.fieldNames[FrmPeriode.FRM_TGLAWAL]%>_yr" value="<%=startYear%>">
		   <input type="hidden" name="<%=FrmPeriode.fieldNames[FrmPeriode.FRM_TGLAWAL]%>_mn" value="<%=startMonth%>">
		   <input type="hidden" name="<%=FrmPeriode.fieldNames[FrmPeriode.FRM_TGLAWAL]%>_dy" value="<%=startDate%>">
		   <input type="hidden" name="<%=FrmPeriode.fieldNames[FrmPeriode.FRM_TGLAKHIR]%>_yr" value="<%=lastYear%>">
		   <input type="hidden" name="<%=FrmPeriode.fieldNames[FrmPeriode.FRM_TGLAKHIR]%>_mn" value="<%=lastMonth%>">
		   <input type="hidden" name="<%=FrmPeriode.fieldNames[FrmPeriode.FRM_TGLAKHIR]%>_dy" value="<%=lastDate%>">			  
		  <%
	  }
	  %>
		   <table width="100%" border="0" cellspacing="0" cellpadding="0">
		   	<tr><td></td></tr>
			<tr>
				<td>
					<table width="100%"  align="center" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
				<tr>
					<td>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" class="list">
							 <tr>
							   <td colspan="2"><% if (periodStatus > ctrlPeriode.MSG_PER_OK) { %></td>
							 </tr>
							 <tr>
							   <td colspan="2"><span class="msgErrComment"><%=periodMessage%></span></td>
							 </tr>
							 <tr>
							   <td colspan="2"><% } %>
								 <% if ((listPeriode != null) && (listPeriode.size() > 0)) { %>
								 <%=drawListPeriode(listPeriode, periode.getOID(), SESS_LANGUAGE)%> </td>
					      </tr>
							 <tr>
							   <td colspan="2"><span class="command"><%=ctrLine.drawMeListLimit(listCommand, vectSize, start, recordToGet, "first", "prev", "next", "last", "left")%>
								 <% } %>
							   </span></td>
					      </tr>
							 <tr>
							   <td colspan="2">&nbsp;</td>
							 </tr>
							 <tr>
							   <td colspan="2"><span class="command">&nbsp;&nbsp;
								 <% if (iCommand != Command.ADD && iCommand != Command.EDIT && !(iCommand == Command.SAVE && frmPeriode.errorSize() > 0)) { %>
								 <input name="buttonAdd" type="button" onClick="javascript:addNew()" value="<%=strAdd%>"><!-- <a href="javascript:addNew()"><%//=strAdd%></a> -->
								 <% if (periodStatus == ctrlPeriode.MSG_PER_ERR) { %>
								&nbsp;|&nbsp;<a href="javascript:cmdCloseBook()"><%=strCloseBook%></a>
								<% } %>
								<% } %>
							   </span></td>
					      </tr>
							 <tr>
							   <td colspan="2">&nbsp;</td>
					      </tr>
							 <tr><td colspan="2"><table width="100%">
							   <% if (((iCommand == Command.SAVE) && ((frmPeriode.errorSize() > 0) || (ctrlErr != CtrlPeriode.RSLT_OK))) || (iCommand == Command.ADD) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) { %>
							   <tr>
								 <td width="83"></td>
								 <td width="9"></td>
								 <td width="885"></td>
							   </tr>
							   <tr>
								 <td>&nbsp;</td>
								 <td>&nbsp;</td>
								 <td>*) = <%=strReqs[SESS_LANGUAGE]%></td>
							   </tr>
							   <tr>
								 <td height="2"></td>
							   </tr>
							   <tr>
								 <td width="83"><%=getJspTitle(textJspTitle, 0, SESS_LANGUAGE, currPageTitle, false)%></td>
								 <td width="9"><b>:</b></td>
								 <td width="885"><%=ControlDate.drawDate(frmPeriode.fieldNames[frmPeriode.FRM_TGLAWAL], firstDateOfNewPeriod, "", "", "", "", 3, -6, readOnlyCombo)%><span class="fielderror"><%=frmPeriode.getErrorMsg(frmPeriode.FRM_TGLAWAL)%></span></td>
							   </tr>
							   <tr>
								 <td width="83" height="14"><%=getJspTitle(textJspTitle, 1, SESS_LANGUAGE, currPageTitle, false)%></td>
								 <td width="9" height="14"><b>:</b></td>
								 <td width="885"><%=ControlDate.drawDate(frmPeriode.fieldNames[frmPeriode.FRM_TGLAKHIR], lastDateOfNewPeriod, "", "", "", "", 3, -6, readOnlyCombo)%><span class="fielderror"><%=frmPeriode.getErrorMsg(frmPeriode.FRM_TGLAKHIR)%></span></td>
							   </tr>
							   <tr>
								 <td width="83"><%=getJspTitle(textJspTitle, 2, SESS_LANGUAGE, currPageTitle, false)%></td>
								 <td width="9"><b>:</b></td>
								 <td width="885"><%=ControlDate.drawDate(frmPeriode.fieldNames[frmPeriode.FRM_TGLAKHIRENTRY], lastEntryDate, "", "", "", "", 5, -8, "")%>&nbsp;&nbsp;*)&nbsp;&nbsp;<span class="fielderror"><%=frmPeriode.getErrorMsg(frmPeriode.FRM_TGLAKHIRENTRY)%></span></td>
							   </tr>
							   <tr>
								 <td width="83"><%=getJspTitle(textJspTitle, 3, SESS_LANGUAGE, currPageTitle, false)%></td>
								 <td width="9"><b>:</b></td>
								 <td width="885"><input type="text" name="<%=frmPeriode.fieldNames[frmPeriode.FRM_NAMA]%>" value="<%=periode.getNama()%>" size="40">
							 &nbsp;&nbsp;*)&nbsp;&nbsp;<span class="fielderror"><%=frmPeriode.getErrorMsg(frmPeriode.FRM_NAMA)%></span></td>
							   </tr>
							   <tr>
								 <td width="83" valign="top"><%=getJspTitle(textJspTitle,4,SESS_LANGUAGE,currPageTitle,false)%></td>
								 <td width="9" valign="top"><b>:</b></td>
								 <td width="885"><textarea name="<%=frmPeriode.fieldNames[frmPeriode.FRM_KETERANGAN]%>" cols="26" rows="3"><%=periode.getKeterangan()%></textarea></td>
							   </tr>
							   <tr>
								 <td width="83"><%=getJspTitle(textJspTitle, 5, SESS_LANGUAGE, currPageTitle, false)%></td>
								 <td width="9"><b>:</b></td>
								 <td width="885">
								   <%
								   String strPer = "";
								   if (iCommand == Command.ADD || iCommand == Command.SAVE) {
									   if (iPeriodeCount > 0)
										   strPer = "Prepare Open";
									   else     // there is no periode exist in database
										   strPer = "Open"; 
								   } else {
									switch (periode.getPosted()) {
									case PstPeriode.PERIOD_CLOSED : strPer = "Closed";
									break;
									case PstPeriode.PERIOD_OPEN : strPer = "Open";
									break;
									case PstPeriode.PERIOD_PREPARE_OPEN : strPer = "Prepare Open";
									break;
									default : ;
									}
								   }
							  %>
								   <%=strPer%> </td>
							   <tr> </tr>
							   <tr>
								 <td colspan="3" class="command">         
							   </tr>
							   <% if (iCommand == Command.SAVE) { %>
							   <tr>
								 <td colspan="3" class="msginfo"><%=ctrlPeriode.getMessage()%></td>
							   </tr>
							   <% } else if (iCommand == Command.ASK) { %>
							   <tr>
								 <td colspan="3" class="msgquestion"><%=delConfirm%></td>
							   </tr>
							   <tr>
								 <td height="10"></td>
							   </tr>
							   <% } %>
							   <tr>
								 <td width="83"></td>
								 <td width="9"></td>
								 <td width="885" class="command">
								   <% if (iCommand != Command.LIST) { %>
								   <%
								if (iCommand == Command.ASK) {
							   %>
								   <a href="javascript:cmdCancelDel()"><%=strCancel%></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:cmdDel()"><%=strDeleteAcc%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
								   <%
								}
							   %>
								   <% if (periode.getPosted() != PstPeriode.PERIOD_CLOSED && privUpdate && (iCommand == Command.ADD || iCommand == Command.SAVE || iCommand == Command.EDIT)) { %>
								   <a href="javascript:cmdSave()"><%=strSave%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
								   <% if (iCommand == Command.EDIT && PstPeriode.getLastPeriodeOid() == periodeID && !(periode.getPosted() == PstPeriode.PERIOD_OPEN || periode.getPosted() == PstPeriode.PERIOD_CLOSED)) { %>
								   <a href="javascript:cmdDelConfirm()"><%=strDel[SESS_LANGUAGE]%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
								   <% } %>
								   <% } %>
								   <a href="javascript:cmdBackList()"><%=strBack%></a>
								   <% } %>
								 </td>
							   </tr>
							   <% } %>
							 </table>	       <span class="command">
					  </span></td></tr></table>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>