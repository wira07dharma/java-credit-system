<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import dimata-->
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!-- import qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- import aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.entity.jurnal.*" %>
<%//@ page import = "com.dimata.aiso.form.periode.*" %>
<%@ page import = "com.dimata.aiso.session.periode.*" %>
<%@ page import = "com.dimata.aiso.session.jurnal.*" %>
<%//@ page import = "com.dimata.aiso.form.masterdata.*" %>

<!-- import harisma-->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_PERIOD, AppObjInfo.G2_PERIOD_CLOSE_BOOK, AppObjInfo.OBJ_PERIOD_CLOSE_BOOK); %>
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

<!-- JSP Block -->
<%!
/* this constant used to list text of listHeader */
public static final String textJspTitle[][] = {
	{"Fasilitas ini digunakan untuk proses tutup periode aktivitas. Tutup periode hanya dapat diproses pada tanggal: ",
	 "Anda yakin melakukan proses tutup periode ?",
	 "Tutup buku gagal !!!"},
	 
	{"This feature is used to closing period. Do this process on : ",
	 "Are you sure to close period ?",
	 "Close period failed !!! "}	 
};

public static final String pageTitle[] = {
	"Tutup Periode Aktivitas","Close Activity Period"	
};
%>

<%
// ngambil data dari request form
int iCommand = FRMQueryString.requestCommand(request);

// setup controlLine and commands caption
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String titles[] = {"Periode Activitas", "Activity Period"};
String currPageTitle = titles[SESS_LANGUAGE];
String strCloseBook = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close Activity Period" : "Tutup Periode Aktivitas";
String strYesCloseBook = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes " : "Ya ") + strCloseBook;
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";

// ngambil OID dari current periode
long periodeId =  PstActivityPeriod.getCurrPeriodId();
System.out.println("periodeId ===> "+periodeId);

ActivityPeriod actPeriod = new ActivityPeriod();
actPeriod = PstActivityPeriod.fetchExc(periodeId);
// ngambil nilai account link utk earning account
boolean bPeriodEarnExist = true;
boolean bYearEarnExist = true;
boolean bRetainEarnExist = true;

// proses closing period
long lClosingPeriodStatus = 0;
if(iCommand == Command.SAVE){	
	SessActvityPeriod objSessActPeriode = new SessActvityPeriod();
	
	lClosingPeriodStatus = objSessActPeriode.closingBookYearly(periodeId, periodActivityInterval, lastEntryDuration);	
	
	// update nilai variable di javainit.jsp
	currentActivityPeriodOid = PstActivityPeriod.getCurrPeriodId();
	validClosePeriodToday = objSessActPeriode.isValidCloseBookTime(new Date(), currentActivityPeriodOid);
		
	if( (currentActivityPeriodOid != 0) && (currentActivityPeriodOid == lClosingPeriodStatus)){
		lClosingPeriodStatus = PstSaldoAkhirPeriode.NO_ERR;
	}	
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">	
	function cmdSave(){
		document.frmclosebook.command.value="<%=Command.SAVE%>";
	    document.frmclosebook.action="close_activity_period.jsp";
		document.frmclosebook.submit();
	}

	<%if(privSubmit){%>
	function cmdAsk(){
		document.frmclosebook.command.value="<%=Command.ASK%>";
	    document.frmclosebook.action="close_activity_period.jsp";
		document.frmclosebook.submit();
	}
	<%}%>
	
	function cmdCancel(){
		document.frmclosebook.command.value="<%=Command.NONE%>";
	    document.frmclosebook.action="close_activity_period.jsp";
		document.frmclosebook.submit();
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=currPageTitle%>
            &gt; <%=pageTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmclosebook" method="post" action="">
		    <input type="hidden" name="command" value="">
		    <table width="100%" border="0" cellspacing="2" cellpadding="0">
              <tr align="left" valign="top">
                <!-- <td height="8" valign="middle" colspan="3"> 
                    <hr>
                  </td> -->
              </tr>
              <tr>
                <td width="100%">&nbsp;&nbsp;
                  <table width="100%" height="25" border="0" cellpadding="2" cellspacing="2" class="listgencontent">
                    <tr>
                      <td><span class="command">&nbsp;&nbsp;
                          <%if((iCommand!=Command.SAVE)&&(privSubmit)){%>
                          <%if(iCommand==Command.SAVE){%>
                        <%=PstSaldoAkhirPeriode.arrErrClosingPeriod[SESS_LANGUAGE][Integer.parseInt(""+lClosingPeriodStatus)]%>
                        <%}else{%>
                      </span></td>
                    </tr>
                    <tr>
                      <td>&nbsp;&nbsp;
                        <%if(iCommand!=Command.ASK){%>
                        <%=textJspTitle[SESS_LANGUAGE][0]%><b><font color="#0000FF"><%=Formater.formatDate(actPeriod.getEndDate(), "dd MMMM yyyy")%>
                        <%}else{%>
                        <%if(validClosePeriodToday){%>
                        <%=textJspTitle[SESS_LANGUAGE][1]%></font></b></td>
                    </tr>
                    <%//}%>
                    <tr>
                      <td class="msgErrComment">&nbsp;&nbsp;<%}else{%>
                          <%=PstSaldoAkhirPeriode.arrErrClosingPeriod[SESS_LANGUAGE][Integer.parseInt(""+PstSaldoAkhirPeriode.ERR_INVALID_DATE_TO_CLOSE_PERIOD)]%>
                          <%}%>
                          <%}%>
                          <%}%></td>
                    </tr>
                    <tr>
                      <td><hr color="#00CCFF" size="2"></td>
                    </tr>
                    <tr>
                      <td>&nbsp;&nbsp;<%if(iCommand!=Command.ASK){%>
                        <a href="javascript:cmdAsk()" class="command"><%=strCloseBook%></a>
                        <%}else{%>
                        <%if(validClosePeriodToday){%>
                        <a href="javascript:cmdSave()" class="command"><%=strYesCloseBook%></a> | <a href="javascript:cmdCancel()" class="command"><%=strCancel%></a>
                        <%}else{%>
                        <a href="javascript:cmdCancel()" class="command"><%=strCancel%></a>
                        <%}%>
                        <%}%>
                        <%}%></td>
                    </tr>
                    <tr>
                      <td>&nbsp;                        </td>
                    </tr>
                    <tr>
                      <td>
                        </td>
                    </tr>
                </table></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
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