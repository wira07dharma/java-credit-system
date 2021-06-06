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
	"Pencarian","Inquiries"
};

public static final String searchTitle[] =
{
	"Order Aktiva","Fixed Assets Order"
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
	<%if(privAdd){%>
	function cmdAdd(){
		document.frmsearchju.command.value="<%=Command.ADD%>";
		document.frmsearchju.action="order_aktiva_edit.jsp";
		document.frmsearchju.submit();
	}
	<%}%>

	function cmdSearch(){
		document.frmsearchju.command.value="<%=Command.LIST%>";
		document.frmsearchju.action="order_aktiva_list.jsp";
		document.frmsearchju.submit();
	}

function getThn(){
	var date1 = ""+document.frmsearchju.<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.frmsearchju.<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL]%>_mn.value=bln;
	document.frmsearchju.<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL]%>_dy.value=hri;
	document.frmsearchju.<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL]%>_yr.value=thn;
	
	var date2 = ""+document.frmsearchju.<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR]%>.value;
	var thn1 = date2.substring(6,10);
	var bln1 = date2.substring(3,5);	
	if(bln1.charAt(0)=="0"){
		bln1 = ""+bln1.charAt(1);
	}
	
	var hri1 = date2.substring(0,2);
	if(hri1.charAt(0)=="0"){
		hri1 = ""+hri1.charAt(1);
	}
	
	document.frmsearchju.<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR]%>_mn.value=bln1;
	document.frmsearchju.<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR]%>_dy.value=hri1;
	document.frmsearchju.<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR]%>_yr.value=thn1;		
}
function hideObjectForDate(){
}
	
function showObjectForDate(){
}		
</script>
<link rel="stylesheet" href="../style/calendar.css" type="text/css">
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		  <%if(isUseDatePicker.equalsIgnoreCase("Y")){%> 
      		<table class="ds_box" cellpadding="0" cellspacing="0" id="ds_conclass" style="display: none;">
			<tr><td id="ds_calclass">
			</td></tr>
			</table>
			<script language=JavaScript src="<%=approot%>/main/calendar.js"></script>
			<%}%>	
		  <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=searchTitle[SESS_LANGUAGE].toUpperCase()%></font>
		  <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmsearchju" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="add_type" value="">
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr>
                  <td colspan="3">&nbsp;
                    
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
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%"><input name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TYPE]%>" type="radio" value="0" checked>
                    <%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%>
                  </td>
                </tr>
                <tr>
                  <td height="80%">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TYPE]%>" type="radio" value="1">
                    <%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%>
					<input onClick="ds_sh(this);" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcOrderAktiva.getTanggalAwal() == null? new Date() : srcOrderAktiva.getTanggalAwal()), "dd-MM-yyyy")%>"/>
				    <input type="hidden" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL]%>_mn">
				    <input type="hidden" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL]%>_dy">
				    <input type="hidden" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL]%>_yr">
                    <%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%>&nbsp;&nbsp;
					<input onClick="ds_sh(this);" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcOrderAktiva.getTanggalakhir() == null? new Date() : srcOrderAktiva.getTanggalakhir()), "dd-MM-yyyy")%>"/>
				    <input type="hidden" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR]%>_mn">
				    <input type="hidden" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR]%>_dy">
				    <input type="hidden" name="<%=FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR]%>_yr">
                    <script language="JavaScript" type="text/JavaScript">getThn();</script>
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
                <%if((privAdd)){%>
                <tr>
                  <td width="16%" height="16">&nbsp;</td>
                  <td width="1%" height="16" class="command">&nbsp;</td>
                  <td width="83%" height="16" class="command"><a href="javascript:cmdAdd()"><%//=strAdd%></a></td>
                </tr>
                <%}%>
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