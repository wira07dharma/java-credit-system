<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>
<!-- import java -->
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>
<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>
<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<!-- import ij -->
<%@ page import = "com.dimata.ij.iaiso.*" %>
<%@ page import = "com.dimata.ij.ibosys.*" %>
<%@ page import = "com.dimata.ij.iij.*" %>
<%@ page import = "com.dimata.ij.entity.search.*" %>
<%@ page import = "com.dimata.ij.form.search.*" %>
<%@ page import = "com.dimata.ij.session.engine.*" %>

<% int  appObjCode =  1;//AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%//@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));
%>

<%!
public static final String textJspTitle[][] = {
	{
	 "Tgl Transaksi",
	 "Contact",
	 "Mata Uang",
	 "Keterangan"
	},
	 
	{
	 "Transaction Date",
	 "Contact",
	 "Currency",
	 "Transaction Note"
	}	 
};
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
String sSelectedIjJournal[] = request.getParameterValues("chkbox");

// iterate to posting IjJournal
if(iCommand == Command.SAVE)
{
	if(sSelectedIjJournal!=null && sSelectedIjJournal.length>0)
	{
		int iSelectedIjJournalCount = sSelectedIjJournal.length;
		Vector vJournal = new Vector(1,1);
		for(int i=0; i<iSelectedIjJournalCount; i++)
		{		
			// get vector of IjJournal will posted
			long lSelectedIjJournal = Long.parseLong(sSelectedIjJournal[i]);
			IjJournalMain objIjJournalMain = PstIjJournalMain.getIjJournalMain(lSelectedIjJournal);
			vJournal.add(objIjJournalMain);		
		}
		
		
		if(vJournal!=null && vJournal.size()>0)	
		{
			int iJournalCount = vJournal.size();
			for(int i=0; i<iJournalCount; i++)
			{
				IjJournalMain objIjJournalMain = (IjJournalMain) vJournal.get(i);
			}
		}
				

		// posting journal 		
		/*
		try
		{
			System.out.println(">>> Start save journal ...");
			long lCurrPeriodeOid = currentPeriodOid;
			Date dStartDatePeriode = new Date(104,0,1);
			Date dEndDatePeriode = new Date(105,11,31);		
			Date dLastEntryDatePeriode = new Date(106,0,15);				
			long lOperatorOid = 504404178941945439L;				
			Date dPostingDate = new Date();
			I_Aiso i_aiso = (I_Aiso) Class.forName(I_Aiso.implClassName).newInstance();                        				
			int iJournalGeneratedCount = i_aiso.saveJournal(vJournal, lCurrPeriodeOid, dStartDatePeriode, dEndDatePeriode, dLastEntryDatePeriode, lOperatorOid, dPostingDate);
			System.out.println(">>> Finish save journal ...");		
		}
		catch(Exception e)
		{
			System.out.println("Exc : " + e.toString());
		}
		*/
		
		try
		{
			System.out.println(">>> Start save journal ...");
			long lCurrPeriodeOid = currentPeriodOid;
			Date dStartDatePeriode = new Date(104,0,1);
			Date dEndDatePeriode = new Date(105,11,31);		
			Date dLastEntryDatePeriode = new Date(106,0,15);				
			long lOperatorOid = 504404178941945439L;				
			Date dPostingDate = new Date();
			
			IjEngineController objIjEngineController = new IjEngineController();
			//int iJournalGeneratedCount = objIjEngineController.postingJournal(vJournal, lCurrPeriodeOid, dStartDatePeriode, dEndDatePeriode, dLastEntryDatePeriode, lOperatorOid, dPostingDate);
			System.out.println(">>> Finish save journal ...");		
		}
		catch(Exception e)
		{
			System.out.println("Exc : " + e.toString());
		}							
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
function cmdEdit(oid)
{ 
	document.frmjournal.command.value="<%=Command.EDIT%>";
	document.frmjournal.hidden_ij_journal_main_id.value = oid;	
	document.frmjournal.action="ij_journal_edit.jsp";
	document.frmjournal.submit(); 
} 

function cmdBack()
{ 
	document.frmjournal.command.value="<%=Command.BACK%>";
	document.frmjournal.action="src_ij_journal.jsp";
	document.frmjournal.submit(); 
} 
</script>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
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

function showObjectForMenu(){
}
</SCRIPT>
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
            &gt; Journal Posted<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmjournal" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="hidden_ij_journal_main_id" value="">
              <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr> 
                  <td> 
                    <hr size="1" noshade>
                  </td>
                </tr>
                <tr> 
                  <td><%//=listDrawJurnal(listJurnal,listCurrAiso,SESS_LANGUAGE)%></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;&nbsp;<a href="javascript:cmdBack()" class="command">Back 
                    To Search Journal</a></td>
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
