<%@ page language="java" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.entity.search.SrcArApEntry,
                 com.dimata.aiso.form.search.FrmSrcArApReport,
                 com.dimata.aiso.session.arap.SessArApDetailReport,
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
		"s / d",
        "Nomor Nota",
        "Periode",
        "hari"
	},
	{
		"Report Name",
		"Cantact Name",
        "Date",
        "From",
        "To",
        "Bill Number",
        "Periode",
        "days"
	}
};

public static final String masterTitle[][] =
{
    {"Report Detail Piutang","Receivable Detail Report"}
    ,
    {"Report Detail Hutang","Payable Detail Report"}
    ,
    {"Pembayaran Hutang/Piutang","A.R./A.P. Payment"}
};

public static final String searchTitle[][] =
{
    {"Pencarian Laporan Piutang","Search Receivable Report"},
    {"Pencarian Laporan Hutang","Search Payable Report"},
    {"Pencarian Pembayaran","Search Payment"}
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
int arapType = FRMQueryString.requestInt(request,"arap_type");
int payment = FRMQueryString.requestInt(request,"payment");

SrcArApReport srcArApReport = new SrcArApReport();
if(session.getValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL_REPORT)!=null)
{
	srcArApReport = (SrcArApReport)session.getValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL_REPORT);
}
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "AR/AP" : "Hutang/Piutang";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Do Search" : "Lakukan Pencarian";

try
{
	session.removeValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL_REPORT);
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
        document.frmsearch.action="arap_bo_detail_report.jsp";
        document.frmsearch.submit();
    }

    function cmdChangeType(){
        var type = Math.abs(document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_REPORT_TYPE]%>.value);
        if(type><%=SessArApDetailReport.AP_DETAIL%>){
            if(type><%=SessArApDetailReport.AP_TOMORROW_DUE_DATE%>){
                document.all.date.style.display="";
                document.all.from.style.display="none";
                document.all.fromDate.style.display="";
                document.all.until.style.display="none";
                document.all.nota.style.display="none";
                document.all.periode.style.display="";
                document.all.periode1.style.display="";
                document.all.periode2.style.display="";
                document.all.periode3.style.display="";
            }
            else{
                document.all.date.style.display="none";
                document.all.from.style.display="none";
                document.all.fromDate.style.display="none";
                document.all.until.style.display="none";
                document.all.nota.style.display="none";
                document.all.periode.style.display="none";
                document.all.periode1.style.display="none";
                document.all.periode2.style.display="none";
                document.all.periode3.style.display="none";
            }
        }
        else{
            document.all.date.style.display="";
            document.all.from.style.display="";
            document.all.fromDate.style.display="";
            document.all.until.style.display="";
            document.all.nota.style.display="";
            document.all.periode.style.display="none";
            document.all.periode1.style.display="none";
            document.all.periode2.style.display="none";
            document.all.periode3.style.display="none";
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
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=payment==0?masterTitle[arapType][SESS_LANGUAGE]:masterTitle[2][SESS_LANGUAGE]%> &gt; <%=payment==0?searchTitle[arapType][SESS_LANGUAGE]:searchTitle[2][SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td><!-- #BeginEditable "content" -->
            <form name="frmsearch" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="report_type" value="<%=srcArApReport.getReportType()%>">
              <input type="hidden" name="arap_type" value="<%=arapType%>">
              <input type="hidden" name="payment" value="<%=payment%>">
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr> 
                  <td colspan="4"> 
                    <hr>
                  </td>
                </tr>
                <tr> 
                  <td nowrap colspan="2"><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="85%"> 
                    <%
                    Vector typeValue = new Vector();
                    Vector typeKey = new Vector();
                    String sel_type = srcArApReport.getReportType()+"";
                    if(payment==0){
                        int size = SessArApDetailReport.stReportType[0].length;
                        for(int i=0; i<size; i++){
                            if(i%2==arapType){
                                typeValue.add(SessArApDetailReport.stReportType[SESS_LANGUAGE][i]);
                                typeKey.add(""+i);
                            }
                        }
                    }
                    else{
                        int size = SessArApDetailReport.stEntryPayment[0].length;
                        for(int i=0; i<size; i++){
                            typeValue.add(SessArApDetailReport.stEntryPayment[SESS_LANGUAGE][i]);
                            typeKey.add(""+(SessArApDetailReport.REPORT_VS_PAYMENT_MAPPING+i));
                        }
                    }
                  %>
                    <%=ControlCombo.draw(FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_REPORT_TYPE],null,sel_type,typeKey,typeValue,"onChange=\"javascript:cmdChangeType()\"","")%> </td>
                </tr>
                <tr> 
                  <td nowrap colspan="2"><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="85%"> 
                    <input type="text" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_CONTACT_NAME]%>" size="50" value="<%=srcArApReport.getContactName()%>">
                  </td>
                </tr>
                <tr id=nota> 
                  <td nowrap colspan="2"><%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="85%"> 
                    <input type="text" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_NOTA_NO]%>" size="50" value="<%=srcArApReport.getNotaNo()%>">
                  </td>
                </tr>
                <tr id=periode> 
                  <td nowrap colspan="2"><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="85%">&nbsp; </td>
                </tr>
                <tr id=periode1> 
                  <td width="3%" nowrap>&nbsp;</td>
                  <td width="11%" nowrap><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%> 1</td>
                  <td width="1%"><b>:</b></td>
                  <td width="85%"> 
                    <input type="text" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_PERIODE1]%>" size="5" style="text-align:right" value="<%=srcArApReport.getPeriodeSpan1()%>">
                    &nbsp;<%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%>
                  </td>
                </tr>
				<tr id=periode2>
                  <td width="3%" nowrap>&nbsp;</td>
                  <td width="11%" nowrap><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%> 2</td>
                  <td width="1%"><b>:</b></td>
                  <td width="85%"> 
                    <input type="text" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_PERIODE2]%>" size="5" style="text-align:right" value="<%=srcArApReport.getPeriodeSpan2()%>">
                    &nbsp;<%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%>
                  </td>
                </tr>
				<tr id=periode3>
                  <td width="3%" nowrap>&nbsp;</td>
                  <td width="11%" nowrap><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%> 3</td>
                  <td width="1%"><b>:</b></td>
                  <td width="85%"> 
                    <input type="text" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_PERIODE3]%>" size="5" style="text-align:right" value="<%=srcArApReport.getPeriodeSpan3()%>">
                    &nbsp;<%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%>
                  </td>
                </tr>
                <tr id=date>
                  <td height="80%" colspan="2"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="85%"><a id=from> <%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></a>
                  <a id=fromDate>
                    <%
                        Date dtTransactionDate = srcArApReport.getFromDate();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE], dtTransactionDate, 3, -5));
                    %>
                    </a>
                    <a id=until>
                    <%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%>
                    <%
                        dtTransactionDate = srcArApReport.getUntilDate();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE], dtTransactionDate, 3, -5));
                    %>
                    </a>
                  </td>
                </tr>

                <tr>
                  <td height="80%" colspan="2">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="85%">&nbsp;</td>
                </tr>
                <tr >
                  <td height="80%" colspan="2">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="85%"> 
                    <input type="button" name="Search" value="<%=strSearch%>" onClick="javascript:cmdSearch()">
                  </td>
                </tr>
              </table>
            </form>
<script language="JavaScript">
    cmdChangeType();
</script>
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