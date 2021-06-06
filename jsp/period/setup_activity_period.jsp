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
  {"Tanggal Awal", "Tanggal Akhir",  "Nama", "Keterangan", "Status"},
  {"Start Date", "Last Date", "Name", "Description", "Status"}	
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

public static final String pageTitle[] = {"Setup Periode", "Period Setup"	
};

public String drawList(Vector objectClass,
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

 ctrlist.dataFormat(getJspTitle(textJspTitle,2,language,"",false),"20%","left","left");		
 ctrlist.dataFormat(getJspTitle(textJspTitle,3,language,"",false),"39%","left","left");
 ctrlist.dataFormat(getJspTitle(textJspTitle,0,language,"",false),"10%","left","left");
 ctrlist.dataFormat(getJspTitle(textJspTitle,1,language,"",false),"10%","left","left"); 
 ctrlist.dataFormat(getJspTitle(textJspTitle,4,language,"",false),"11%","left","left");

 ctrlist.setLinkRow(0);
 ctrlist.setLinkSufix("");

 Vector lstData = ctrlist.getData();
 Vector lstLinkData = ctrlist.getLinkData();						
	
 ctrlist.setLinkPrefix("javascript:cmdEdit('");
 ctrlist.setLinkSufix("')");
 ctrlist.reset();
	
 String dateStrStart = "";
 String dateStrLast = ""; 
 String strPosted = "";
 int index = -1;
	
 for (int i = 0; i < objectClass.size(); i++) {
  ActivityPeriod actPeriod = (ActivityPeriod) objectClass.get(i);
  if (oid == actPeriod.getOID()) {
   index = i;
  }
  Vector rowx = new Vector(); 

  rowx.add(actPeriod.getName()); 
  rowx.add(actPeriod.getDescription()); 

  try {
   Date dateStart = actPeriod.getStartDate();
   dateStrStart = Formater.formatDate(dateStart, "dd MMM yyyy");
  } catch (Exception e) {
  }		
  rowx.add(dateStrStart); 
  
  try {
   Date dateLast = actPeriod.getEndDate();
   dateStrLast = Formater.formatDate(dateLast, "dd MMM yyyy");
  } catch (Exception e) {
  }	
  rowx.add(dateStrLast); 
  
  /*try {
   Date dateLastEntry = periode.getTglAkhirEntry();
   dateStrLastEntry = Formater.formatDate(dateLastEntry, "MMM dd, yyyy");
  } catch (Exception e) {
  }	
  rowx.add(dateStrLastEntry); */
         
  switch (actPeriod.getPosted()) {
  case PstActivityPeriod.PERIOD_OPEN : strPosted = "Open";
  break;
  case PstActivityPeriod.PERIOD_CLOSED : strPosted = "Close";
  break;
  case PstActivityPeriod.PERIOD_PREPARE_OPEN : strPosted = "Prepare Open";
  break;
  default : strPosted = "Unknown";
  }
		 
  rowx.add(strPosted); 
  lstData.add(rowx);
  lstLinkData.add(String.valueOf(actPeriod.getOID()));
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
int recordToGet = 15;
String whereClause = "";
String orderBy = PstActivityPeriod.fieldNames[PstActivityPeriod.FLD_START_DATE];

/**
* Setup controlLine and Commands caption
*/
System.out.println("ADA DIATAS CONTROLLINE DIBAWAH REQUEST");
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String titles[] = {"Periode Activitas", "Activity Period"};
String currPageTitle = titles[SESS_LANGUAGE];
String strAdd = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
String strSave = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
String strBack = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCloseBook = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close Period" : "Tutup Periode";
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete this " : "Anda Yakin akan Menghapus ") + currPageTitle;
if (SESS_LANGUAGE != com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
    delConfirm += " ini";
delConfirm += " ?";

String strDeleteAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);

Vector listPeriode = new Vector(1,1);

Control controlList = new Control();
CtrlActivityPeriod ctrlActPeriod = new CtrlActivityPeriod(request);

int ctrlErr = ctrlActPeriod.action(iCommand, periodeID, periodInterval, lastEntryDuration);
FrmActivityPeriod frmActPeriod = ctrlActPeriod.getForm();

System.out.println("frmActPeriod : "+frmActPeriod);
ActivityPeriod actPeriod = ctrlActPeriod.getPeriode(); 
int periodStatus = ctrlActPeriod.getStatusPeriod();
String periodMessage = ctrlActPeriod.msgPeriodeText[SESS_LANGUAGE][periodStatus];

int vectSize = PstActivityPeriod.getCount(whereClause);

int startYear = 0;
int startMonth = 0;
int startDate = 0;
int lastYear = 0;
int lastMonth = 0;
int lastDate = 0;
if (iCommand == Command.EDIT || iCommand == Command.SAVE) {
 startYear = actPeriod.getStartDate().getYear() + 1900;
 startMonth = actPeriod.getStartDate().getMonth() + 1;
 startDate = actPeriod.getStartDate().getDate();
 lastYear = actPeriod.getEndDate().getYear() + 1900;
 lastMonth = actPeriod.getEndDate().getMonth() + 1;
 lastDate = actPeriod.getEndDate().getDate();
}

String msgString = ctrlActPeriod.getMessage();
int iErrCode = ctrlActPeriod.getErrCode();

//start = ctrlPeriode.getStart();
if (start >= vectSize)
    start -= recordToGet;
if (start < 0)
    start = 0;

start = controlList.actionList(listCommand, start, vectSize, recordToGet);
listPeriode = PstActivityPeriod.list(start, recordToGet, whereClause, orderBy);

String readOnlyCombo = "";
if (PstActivityPeriod.isTherePeriod()) {
 readOnlyCombo = "disabled";
}
%>

<%

 Date firstDateOfNewPeriod = actPeriod.getStartDate();
 Date lastDateOfNewPeriod = actPeriod.getEndDate();
 long periodeId =  PstActivityPeriod.getCurrPeriodId();
 //Date lastEntryDate = periode.getTglAkhirEntry();   
 
 int iPeriodeCount = PstActivityPeriod.getCount(""); 
 
 if (iCommand == Command.ADD) {
  firstDateOfNewPeriod = PstActivityPeriod.getFirstDateOfNewPeriod();
  int year = firstDateOfNewPeriod.getYear();
  int month = firstDateOfNewPeriod.getMonth() + periodInterval - 1;
  int date = firstDateOfNewPeriod.getDate();
  GregorianCalendar gregCal = new GregorianCalendar(year + 1900,  month, date);
  date = gregCal.getActualMaximum(gregCal.DAY_OF_MONTH);
  lastDateOfNewPeriod = new Date(year, month, date);
  //lastEntryDate = new Date(year, month, date + lastEntryDuration);
 } else if (iCommand == Command.SAVE && frmActPeriod.errorSize() > 0 && iPeriodeCount > 0) {
     try {
        ActivityPeriod actPeriode = PstActivityPeriod.fetchExc(periodeID);
        firstDateOfNewPeriod = actPeriode.getStartDate();
        lastDateOfNewPeriod = actPeriode.getEndDate();
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
    document.frmactivityperiod.periode_id.value = "0";
    document.frmactivityperiod.command.value = "<%=Command.ADD%>";
    document.frmactivityperiod.action = "setup_activity_period.jsp";
    document.frmactivityperiod.submit();
	
}

function cmdSave() {
    document.frmactivityperiod.command.value = "<%=Command.SAVE%>";
    document.frmactivityperiod.action = "setup_activity_period.jsp#down";
    document.frmactivityperiod.submit();
}

function cmdEdit(oid){
	document.frmactivityperiod.periode_id.value=oid;
	document.frmactivityperiod.command.value="<%=Command.EDIT%>";
	document.frmactivityperiod.action="setup_activity_period.jsp#down";
	document.frmactivityperiod.submit();
}

function cmdCancelDel() {
    document.frmactivityperiod.command.value = "<%=Command.EDIT%>";
    document.frmactivityperiod.action = "setup_activity_period.jsp#down";
    document.frmactivityperiod.submit();
}

function first(){
	document.frmactivityperiod.list_command.value="<%=Command.FIRST%>";
	document.frmactivityperiod.action="setup_activity_period.jsp";
	document.frmactivityperiod.submit();
}

function prev(){
	document.frmactivityperiod.list_command.value="<%=Command.PREV%>";
	document.frmactivityperiod.action="setup_activity_period.jsp";
	document.frmactivityperiod.submit();
}

function next(){
	document.frmactivityperiod.list_command.value="<%=Command.NEXT%>";
	document.frmactivityperiod.action="setup_activity_period.jsp";
	document.frmactivityperiod.submit();
}

function last(){
	document.frmactivityperiod.list_command.value="<%=Command.LAST%>";
	document.frmactivityperiod.action="setup_activity_period.jsp";
	document.frmactivityperiod.submit();
}

function cmdBackList(){
	document.frmactivityperiod.command.value="<%=Command.NONE%>"; 
	document.frmactivityperiod.list_command.value="<%=Command.LIST%>";
	document.frmactivityperiod.action="setup_activity_period.jsp";
	document.frmactivityperiod.submit();
}
function cmdCloseBook(){
	var act = "<%=approot%>" + "/period/close_book.jsp";
	document.frmactivityperiod.command.value="<%=Command.NONE%>";
	document.frmactivityperiod.action=act;
	document.frmactivityperiod.submit();	
}

function cmdDelConfirm() {
    document.frmactivityperiod.command.value = "<%=Command.ASK%>";
    document.frmactivityperiod.action = "setup_activity_period.jsp#down";
    document.frmactivityperiod.submit();
}

function cmdDel() {
    document.frmactivityperiod.command.value = "<%=Command.DELETE%>";
    document.frmactivityperiod.action = "setup_activity_period.jsp";
    document.frmactivityperiod.submit();
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
     <form name="frmactivityperiod" method="post">
       <table width="100%" border="0" cellspacing="0" cellpadding="0">
	   		<tr><td></td></tr>
	   		<tr>
				<td>
					<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
						<tr>
							<td>
								<table width="100%" border="0" cellpadding="0" cellspacing="0" class="list">
	     <tr>
	       <td colspan="2"><%System.out.println("SUDAH MASUK HTML");%></td>
	       </tr>
	     <tr>
	       <td colspan="2">
             <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
             <input type="hidden" name="list_command" value="<%=Command.LIST%>">
             <input type="hidden" name="start" value="<%=start%>">
             <input type="hidden" name="periode_id" value="<%=periodeID%>">
             <% 
	  if (PstActivityPeriod.isTherePeriod()) 
	  { 
	  %>
             <input type="hidden" name="<%=FrmActivityPeriod.fieldNames[FrmActivityPeriod.FRM_START_DATE]%>_yr" value="<%=startYear%>">
             <input type="hidden" name="<%=FrmActivityPeriod.fieldNames[FrmActivityPeriod.FRM_START_DATE]%>_mn" value="<%=startMonth%>">
             <input type="hidden" name="<%=FrmActivityPeriod.fieldNames[FrmActivityPeriod.FRM_START_DATE]%>_dy" value="<%=startDate%>">
             <input type="hidden" name="<%=FrmActivityPeriod.fieldNames[FrmActivityPeriod.FRM_END_DATE]%>_yr" value="<%=lastYear%>">
             <input type="hidden" name="<%=FrmActivityPeriod.fieldNames[FrmActivityPeriod.FRM_END_DATE]%>_mn" value="<%=lastMonth%>">
             <input type="hidden" name="<%=FrmActivityPeriod.fieldNames[FrmActivityPeriod.FRM_END_DATE]%>_dy" value="<%=lastDate%>">
             <%
	  }
	  %>
             <!-- <table width="100%"><tr align="left" valign="top"><td height="8" valign="middle" colspan="3"><hr></td></tr></table> -->
             <% if (periodStatus > ctrlActPeriod.MSG_PER_OK) { %></td>
	       </tr>
	     <tr>
	       <td colspan="2"><span class="msgErrComment"><%=periodMessage%></span></td>
	       </tr>
	     <tr>
	       <td colspan="2"><% } %>
             <% if ((listPeriode != null) && (listPeriode.size() > 0)) { %>
             <%=drawList(listPeriode, actPeriod.getOID(), SESS_LANGUAGE)%> </td>
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
	       <td colspan="2"><span class="command">
	         <% if (iCommand != Command.ADD && iCommand != Command.EDIT && !(iCommand == Command.SAVE && frmActPeriod.errorSize() > 0)) { %>
             <input name="buttonAdd" type="button" onClick="javascript:addNew()" value="<%=strAdd%>">
			 <!-- <a href="javascript:addNew()"><%//=strAdd%></a> -->
             <% if (periodStatus == ctrlActPeriod.MSG_PER_ERR) { %>
			 <input name="buttonCloseBook" type="button" onClick="javascript:cmdCloseBook()" value="<%=strCloseBook%>">
				<!-- &nbsp;|&nbsp;<a href="javascript:cmdCloseBook()"><%//=strCloseBook%></a> -->
<% } %>
<% } %>
           </span></td>
	       </tr>
	     <tr>
	       <td colspan="2"><span class="command">
                  </span></td>
	       </tr>
	     <tr><td colspan="2"><table width="100%">
           <% if (((iCommand == Command.SAVE) && ((frmActPeriod.errorSize() > 0) || (ctrlErr != CtrlActivityPeriod.RSLT_OK))) || (iCommand == Command.ADD) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) { %>
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
             <td width="885"><%=ControlDate.drawDate(frmActPeriod.fieldNames[frmActPeriod.FRM_START_DATE], firstDateOfNewPeriod, "", "", "", "", 3, -6, readOnlyCombo)%><span class="fielderror"><%=frmActPeriod.getErrorMsg(frmActPeriod.FRM_START_DATE)%></span></td>
           </tr>
           <tr>
             <td width="83" height="14"><%=getJspTitle(textJspTitle, 1, SESS_LANGUAGE, currPageTitle, false)%></td>
             <td width="9" height="14"><b>:</b></td>
             <td width="885"><%=ControlDate.drawDate(frmActPeriod.fieldNames[frmActPeriod.FRM_END_DATE], lastDateOfNewPeriod, "", "", "", "", 3, -6, readOnlyCombo)%><span class="fielderror"><%=frmActPeriod.getErrorMsg(frmActPeriod.FRM_END_DATE)%></span></td>
           </tr>
           <!--<tr> 
		  <td width="83"><%//=getJspTitle(textJspTitle, 2, SESS_LANGUAGE, currPageTitle, false)%></td>
		  <td width="9"><b>:</b></td>
		  <td width="885"><%//=ControlDate.drawDate(frmPeriode.fieldNames[frmActPeriod.FRM_TGLAKHIRENTRY], lastEntryDate, "", "", "", "", 5, -8, "")%>&nbsp;&nbsp;*)&nbsp;&nbsp;<span class="fielderror"><%//=frmPeriode.getErrorMsg(frmPeriode.FRM_TGLAKHIRENTRY)%></span></td>
		 </tr>-->
           <tr>
             <td width="83"><%=getJspTitle(textJspTitle, 2, SESS_LANGUAGE, currPageTitle, false)%></td>
             <td width="9"><b>:</b></td>
             <td width="885"><input type="text" name="<%=frmActPeriod.fieldNames[frmActPeriod.FRM_NAME]%>" value="<%=actPeriod.getName()%>" size="40">
         &nbsp;&nbsp;*)&nbsp;&nbsp;<span class="fielderror"><%=frmActPeriod.getErrorMsg(frmActPeriod.FRM_NAME)%></span></td>
           </tr>
           <tr>
             <td width="83" valign="top"><%=getJspTitle(textJspTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
             <td width="9" valign="top"><b>:</b></td>
             <td width="885"><textarea name="<%=frmActPeriod.fieldNames[frmActPeriod.FRM_DESCRIPTION]%>" cols="26" rows="3"><%=actPeriod.getDescription()%></textarea></td>
           </tr>
           <tr>
             <td width="83"><%=getJspTitle(textJspTitle, 4, SESS_LANGUAGE, currPageTitle, false)%></td>
             <td width="9"><b>:</b></td>
             <input type="hidden" name="<%=frmActPeriod.fieldNames[frmActPeriod.FRM_POSTED]%>" value="<%=actPeriod.getPosted()%>">
             <td width="885">
               <%
			   String strPer = "";
			   if (iCommand == Command.ADD || iCommand == Command.SAVE) {
				   if (iPeriodeCount > 0)
					   strPer = "Prepare Open";
				   else     // there is no periode exist in database
					   strPer = "Open"; 
			   } else {
				switch (actPeriod.getPosted()) {
				case PstActivityPeriod.PERIOD_CLOSED : strPer = "Closed";
				break;
				case PstActivityPeriod.PERIOD_OPEN : strPer = "Open";
				break;
				case PstActivityPeriod.PERIOD_PREPARE_OPEN : strPer = "Prepare Open";
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
             <td colspan="3" class="msginfo"><%=ctrlActPeriod.getMessage()%></td>
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
		   		<input name="buttonCancel" type="button" onClick="javascript:cmdCancelDel()" value="<%=strCancel%>">
				<input name="buttonDel" type="button" onClick="javascript:cmdDel()" value="<%=strDeleteAcc%>">
               <!-- <a href="javascript:cmdCancelDel()"><%//=strCancel%></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:cmdDel()"><%//=strDeleteAcc%></a>&nbsp;&nbsp;|&nbsp;&nbsp; -->
               <%
            }
           %>
               <% if (actPeriod.getPosted() != PstActivityPeriod.PERIOD_CLOSED && privUpdate && (iCommand == Command.ADD || iCommand == Command.SAVE || iCommand == Command.EDIT)) { %>
               <input name="buttonSave" type="button" onClick="javascript:cmdSave()" value="<%=strSave%>">
			   <!-- <a href="javascript:cmdSave()"><%//=strSave%></a>&nbsp;&nbsp;|&nbsp;&nbsp; -->
               <% if (iCommand == Command.EDIT && PstActivityPeriod.getLastPeriodeOid() == periodeID && !(actPeriod.getPosted() == PstActivityPeriod.PERIOD_OPEN || actPeriod.getPosted() == PstActivityPeriod.PERIOD_CLOSED)) { %>
               <input name="buttonDefConfirm" type="button" onClick="javascript:cmdDelConfirm()" value="<%=strDel[SESS_LANGUAGE]%>">
			   <!-- <a href="javascript:cmdDelConfirm()"><%//=strDel[SESS_LANGUAGE]%></a>&nbsp;&nbsp;|&nbsp;&nbsp; -->
               <% } %>
               <% } %>
			   <input name="buttonBackList" type="button" onClick="javascript:cmdBackList()" value="<%=strBack%>">
               <!-- <a href="javascript:cmdBackList()"><%//=strBack%></a> -->
               <% } %>
             </td>
           </tr>
           <% } %>
         </table></td></tr></table>
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