<%@ page language="java" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.entity.search.SrcArApEntry,
                 com.dimata.aiso.form.search.FrmSrcArApReport,
                 com.dimata.aiso.session.arap.SessArApReport,
                 com.dimata.aiso.entity.arap.PstArApMain,
                 com.dimata.aiso.entity.search.SrcArApReport" %>
<%@ page import="java.util.Date" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>

<!-- import aiso -->
<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;
%>

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
}else{
%>

<!-- JSP Block -->
<%!
public static String strTitle[][] =
{
	{
		"Nama Laporan",
		"Nama Kontak",
		"Tanggal",
		"Dari",
		"s / d"
	},
	{
		"Report Name",
		"Cantact Name",
        "Date",
        "From",
        "To"
	}
};

public static final String masterTitle[] =
{
	"Report Piutang","AR Report"
};

public static final String searchTitle[] =
{
	"Pencarian Piutang","Search AR"
};

public String getJspTitle(String textJsp[][], int index, int language, String prefiks, boolean addBody)
{
	String result = "";
	if(addBody)
	{
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT)
		{
			result = textJsp[language][index] + " " + prefiks;
		}
		else
		{
			result = prefiks + " " + textJsp[language][index];
		}
	}
	else
	{
		result = textJsp[language][index];
	}
	return result;
}
%>


<%
int iCommand = FRMQueryString.requestCommand(request);
SrcArApReport srcArApReport = new SrcArApReport();
if(session.getValue(SessArApReport.SESS_SEARCH_ARAP_REPORT)!=null)
{
	srcArApReport = (SrcArApReport)session.getValue(SessArApReport.SESS_SEARCH_ARAP_REPORT);
}

// ControlLine and Commands caption
ControlLine ctrLine = new ControlLine();
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "AR" : "Piutang";
String strSearch = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);
try
{
	session.removeValue(SessArApReport.SESS_SEARCH_ARAP_REPORT);
}
catch(Exception e)
{
	System.out.println("--- Remove session error ---");
}

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">

	function cmdSearch(){
        document.frmsearch.command.value="<%=Command.LIST%>";
        document.frmsearch.action="arap_bo_report.jsp";
        document.frmsearch.submit();
    }

    function cmdChangeType(){
        var type = Math.abs(document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_REPORT_TYPE]%>.value);
        if(type==<%=SessArApReport.ARAP_REPORT_PER_DUE_DATE%>){
            document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_CONTACT_NAME]%>.readOnly="true";
            document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_CONTACT_NAME]%>.value="";
        }
        else{
            document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_CONTACT_NAME]%>.readOnly="";
        }
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
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> &gt; <%=searchTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td><!-- #BeginEditable "content" -->
            <form name="frmsearch" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="report_type" value="<%=srcArApReport.getReportType()%>">
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr>
                  <td colspan="3">
                    <hr>
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                  <%
                    Vector typeValue = new Vector();
                    Vector typeKey = new Vector();
                    String sel_type = srcArApReport.getReportType()+"";
					
					typeValue.add("Daftar Piutang per Debitur");
					typeKey.add(""+SessArApReport.AR_REPORT_PER_DEBITOR);
					
					//typeValue.add("Piutang per Jatuh Tempo");
					//typeKey.add(""+SessArApReport.ARAP_REPORT_PER_DUE_DATE);
                  %>
                  <%=ControlCombo.draw(FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_REPORT_TYPE],null,sel_type,typeKey,typeValue,"onChange=\"javascript:cmdChangeType()\"","")%>
                  </td>
                </tr>

                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_CONTACT_NAME]%>" size="50" value="<%=srcArApReport.getContactName()%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%>
                    <%
                        Date dtTransactionDate = srcArApReport.getFromDate();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE], dtTransactionDate, 3, -5));
                    %>
                    <%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%>
                    <%
                        dtTransactionDate = srcArApReport.getUntilDate();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE], dtTransactionDate, 3, -5));
                    %>
                  </td>
                </tr>

                <tr>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%">&nbsp;</td>
                </tr>
                <tr >
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%"><input type="button" name="Search" value="<%=strSearch%>" onClick="javascript:cmdSearch()"></td>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>