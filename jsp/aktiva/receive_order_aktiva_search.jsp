<%@ page language="java" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.aktiva.SessOrderAktiva,
                 com.dimata.aiso.entity.search.SrcOrderAktiva,
                 com.dimata.aiso.form.periode.CtrlPeriode,
                 com.dimata.aiso.form.search.FrmSrcOrderAktiva" %>
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
		"Nomor Order",
		"Supplier",
		"Tanggal",
        "Semua Tanggal",
		"Dari",
		"s / d"
	},
	{
		"Order Number",
		"Supplier",
        "All Date",
        "Date",
        "From",
        "To"
	}
};

public static final String masterTitle[] =
{
	"Order Aktiva","Order Aktiva"
};

public static final String searchTitle[] =
{
	"Pencarian Order Aktiva","Search Order Aktiva"
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
SrcOrderAktiva srcOrderAktiva = new SrcOrderAktiva();
if(session.getValue(SessOrderAktiva.SESS_SEARCH_ORDER_AKTIVA)!=null)
{
	srcOrderAktiva = (SrcOrderAktiva)session.getValue(SessOrderAktiva.SESS_SEARCH_ORDER_AKTIVA);
}

// ControlLine and Commands caption
ControlLine ctrLine = new ControlLine();
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Order Aktiva" : "Order Aktiva";
String strAdd = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSearch = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);
try
{
	session.removeValue(SessOrderAktiva.SESS_SEARCH_ORDER_AKTIVA);
}
catch(Exception e)
{
	System.out.println("--- Remove session error ---");
}

CtrlPeriode ctrlperiode = new CtrlPeriode(request);
int periodStatus = ctrlperiode.getStatusPeriod();
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
	function cmdSearch(){
		document.frmsearchju.command.value="<%=Command.LIST%>";
		document.frmsearchju.action="receive_order_aktiva_list.jsp";
		document.frmsearchju.submit();
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> &gt; <%=searchTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmsearchju" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="add_type" value="">
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
                    <input type="text" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_NOMOR_ORDER]%>" size="20" value="<%=srcOrderAktiva.getNomorOrder()%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_NAMA_SUPPLIER]%>" size="50" value="<%=srcOrderAktiva.getNameSupplier()%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%"><input name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TYPE]%>" type="radio" value="0">
                    <%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%>
                  </td>
                </tr>
                <tr>
                  <td height="80%">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TYPE]%>" type="radio" value="1">
                    <%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%>
                    <%
                        Date dtTransactionDate = srcOrderAktiva.getTanggalAwal();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL], dtTransactionDate, 0, 5));
                    %>
                    <%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%>
                    <%
                        dtTransactionDate = srcOrderAktiva.getTanggalakhir();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR], dtTransactionDate, 0, 5));
                    %>

                    </td>
                </tr>
                <tr>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%"><input type="submit" name="Search" value="<%=strSearch%>" onClick="javascript:cmdSearch()"></td>
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