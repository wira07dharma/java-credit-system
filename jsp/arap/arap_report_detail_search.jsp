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
                "hari",
                "Jenis Tampilan",
                "Termasuk yang terbayar"
	},
	{
		"Report Name",//0
		"Cantact Name",//1
                "Date",//2
                "From",//3
                "To",//4
                "Doc Number",//5
                "Period",//6
                "days",//7
                "View Type",//8
                "Included Paid Document"//9               
	}
};

public static final String masterTitle[][] =
{
    {"Piutang","Receivable"}
    ,
    {"Hutang","Payable"}
};

public static final String searchTitle[][] =
{
    {"Laporan","Report"},
    {"Pembayaran","Payment"}
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

<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>

<script language="JavaScript">

	function cmdSearch(){
        document.frmsearch.command.value="<%=Command.LIST%>";
        document.frmsearch.action="arap_detail_report.jsp";
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
                document.all.view_type.style.display="none";
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
                document.all.view_type.style.display="none";
            }
        }
        else{
            if(type == <%=SessArApDetailReport.AR_PAYMENT%>){ 
                document.all.date.style.display="";
                document.all.from.style.display="";
                document.all.fromDate.style.display="";
                document.all.until.style.display="";
                document.all.nota.style.display="";
                document.all.periode.style.display="none";
                document.all.periode1.style.display="none";
                document.all.periode2.style.display="none";
                document.all.periode3.style.display="none";
                document.all.view_type.style.display="none";
            }else{
                document.all.date.style.display="";
                document.all.from.style.display="";
                document.all.fromDate.style.display="";
                document.all.until.style.display="";
                document.all.nota.style.display="";
                document.all.periode.style.display="none";
                document.all.periode1.style.display="none";
                document.all.periode2.style.display="none";
                document.all.periode3.style.display="none";
                document.all.view_type.style.display="";
            }
        }
    }

function getThn()
{
	var date1 = ""+document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	//alert("hri = "+hri);
	document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE] + "_mn"%>.value=bln;
	document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE] + "_dy"%>.value=hri;
	document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE] + "_yr"%>.value=thn;
	
	var date2 = ""+document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE]%>.value;
	
	var thn2 = date2.substring(6,10);
	
	var bln2 = date2.substring(3,5);	
	if(bln2.charAt(0)=="0"){
		bln2 = ""+bln2.charAt(1);
	}
	
	var hri2 = date2.substring(0,2);
	if(hri2.charAt(0)=="0"){
		hri2 = ""+hri2.charAt(1);
	}
	
	document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE] + "_mn"%>.value=bln2;
	document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE] + "_dy"%>.value=hri2;
	document.frmsearch.<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE] + "_yr"%>.value=thn2;				
				
}

function hideObjectForDate(){			
						
		}
		
function showObjectForDate(){

}

</script>

<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">   
<link rel="stylesheet" href="../style/calendar.css" type="text/css">  
<link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
	  <table class="ds_box" cellpadding="0" cellspacing="0" id="ds_conclass" style="display: none;">
			<tr><td id="ds_calclass">
			</td></tr>
			</table>
	<script language=JavaScript src="<%=approot%>/main/calendar.js"></script>

	<%=searchTitle[payment][SESS_LANGUAGE]%> : <font color="#CC3300"><%=masterTitle[arapType][SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmsearch" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="report_type" value="<%=srcArApReport.getReportType()%>">
              <input type="hidden" name="arap_type" value="<%=arapType%>">
              <input type="hidden" name="payment" value="<%=payment%>">
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr> 
                  <td colspan="4">&nbsp; 
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
                        }%>
						 <%=ControlCombo.draw(FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_REPORT_TYPE],null,sel_type,typeKey,typeValue,"onChange=\"javascript:cmdChangeType()\"","")%> </td>
                    <%}
                    else{
						if(arapType == PstArApMain.TYPE_AR){
					%>
							<%out.println(SessArApDetailReport.stEntryPayment[SESS_LANGUAGE][PstArApMain.TYPE_AR]);%>
							<input type="hidden" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_REPORT_TYPE]%>" value="<%=SessArApDetailReport.REPORT_VS_PAYMENT_MAPPING + PstArApMain.TYPE_AR%>">
                        <%}else{%>
							<%out.println(SessArApDetailReport.stEntryPayment[SESS_LANGUAGE][PstArApMain.TYPE_AP]);%>
							<input type="hidden" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_REPORT_TYPE]%>" value="<%=SessArApDetailReport.REPORT_VS_PAYMENT_MAPPING + PstArApMain.TYPE_AP%>">
                    <%}
					}
                  %>
                   
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
                        //out.println(ControlDate.drawDate(FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE], dtTransactionDate, 3, -5));
                    %>
		    <input onClick="ds_sh(this);" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate(dtTransactionDate, "dd-MM-yyyy")%>"/> 						  
		      <input type="hidden" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE] + "_mn"%>">
		      <input type="hidden" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE] + "_dy"%>">
		      <input type="hidden" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_FROM_DATE] + "_yr"%>">	
                    </a>
                    <a id=until>
                    <%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%> 
                    <%
                        Date dtUntilDate = srcArApReport.getUntilDate();
                        if(dtUntilDate ==null)
                        {
                            dtUntilDate = new Date();
                        }
                        //out.println(ControlDate.drawDate(FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE], dtTransactionDate, 3, -5));
                    %>
		     <input onClick="ds_sh(this);" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate(dtUntilDate, "dd-MM-yyyy")%>"/> 						  
		      <input type="hidden" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE] + "_mn"%>">
		      <input type="hidden" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE] + "_dy"%>">
		      <input type="hidden" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_UNTIL_DATE] + "_yr"%>">
		      
                    </a>
		<script language="JavaScript" type="text/JavaScript">getThn();</script>		    
                  </td>
                </tr>
                <tr id="view_type">
                  <td width="3%" nowrap><%=strTitle[SESS_LANGUAGE][8]%></td>
                  <td width="11%" nowrap>&nbsp;</td>
                  <td width="1%"><b>:</b></td>
                  <td width="85%"> 
                    <input type="checkbox" name="<%=FrmSrcArApReport.fieldNames[FrmSrcArApReport.FRM_SEARCH_VIEW_TYPE]%>" value="1" <%if(srcArApReport.getViewType() == 1){%>checked<%}%> >
                    &nbsp; <%=strTitle[SESS_LANGUAGE][9]%>
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