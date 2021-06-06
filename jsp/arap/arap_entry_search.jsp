<%@ page language="java" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.entity.search.SrcArApEntry,
                 com.dimata.aiso.form.search.FrmSrcArApEntry,
                 com.dimata.aiso.session.arap.SessArApEntry,
                 com.dimata.aiso.entity.arap.PstArApMain" %>
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
		"No. Voucher",
		"Nama Kontak",
		"Tanggal",
        "Semua Tanggal",
		"Dari",
		"s / d",
        "No. Nota",
        "Tipe"
	},
	{
		"Voucher Number",
		"Cantact Name",
        "Date",
        "All Date",
        "From",
        "To",
        "Nota No.",
        "Type"
	}
};

public static final String masterTitle[] =
{
	"Pencarian","Inquiries"
};

public static final String searchTitle[][] =
{
	{"Piutang","Receivable"},
	{"Hutang","Payable"}
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
int arapType = FRMQueryString.requestInt(request,"arapType");
int arapEdit = FRMQueryString.requestInt(request,"arapEdit");
SrcArApEntry srcArApEntry = new SrcArApEntry();
if(session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY)!=null)
{
	srcArApEntry = (SrcArApEntry)session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);
}

// ControlLine and Commands caption
ControlLine ctrLine = new ControlLine();
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "AR/AP" : "Hutang/Piutang";
String strAddAr = ctrLine.getCommand(SESS_LANGUAGE,PstArApMain.stTypeArAp[SESS_LANGUAGE][PstArApMain.TYPE_AR],ctrLine.CMD_ADD,true);
String strAddAp = ctrLine.getCommand(SESS_LANGUAGE,PstArApMain.stTypeArAp[SESS_LANGUAGE][PstArApMain.TYPE_AP],ctrLine.CMD_ADD,true);
String strSearchAr = ctrLine.getCommand(SESS_LANGUAGE,PstArApMain.stTypeArAp[SESS_LANGUAGE][PstArApMain.TYPE_AR],ctrLine.CMD_SEARCH,true);
String strSearchAp = ctrLine.getCommand(SESS_LANGUAGE,PstArApMain.stTypeArAp[SESS_LANGUAGE][PstArApMain.TYPE_AP],ctrLine.CMD_SEARCH,true);
try
{
	session.removeValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);
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
	<%if(privAdd){%>
	function cmdAddAr(){
        document.frmsearch.arap_type.value="<%=PstArApMain.TYPE_AR%>";
		document.frmsearch.command.value="<%=Command.ADD%>";
		document.frmsearch.action="arap_entry_edit.jsp";
		document.frmsearch.submit();
	}
    function cmdAddAp(){
        document.frmsearch.arap_type.value="<%=PstArApMain.TYPE_AP%>";
		document.frmsearch.command.value="<%=Command.ADD%>";
		document.frmsearch.action="arap_entry_edit.jsp";
		document.frmsearch.submit();
	}
	<%}%>

	function cmdSearch(){
		document.frmsearch.command.value="<%=Command.LIST%>";
		document.frmsearch.arapEdit.value="<%=arapEdit%>";
		document.frmsearch.action="arap_entry_list.jsp";
		document.frmsearch.submit();
	}

    function changeType(){
        /*var type = Math.abs(document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_ARAP_TYPE]%>.value);
        switch(type){
        case <%=PstArApMain.TYPE_AR%>:
            document.all.searchar.style.display="";
            document.all.searchap.style.display="none";
            document.all.ar.style.display="";
            document.all.ap.style.display="none";
            break;
        case <%=PstArApMain.TYPE_AP%>:
            document.all.searchar.style.display="none";
            document.all.searchap.style.display="";
            document.all.ar.style.display="none";
            document.all.ap.style.display="";
            break;
        default :
            document.all.searchar.style.display="";
            document.all.searchap.style.display="none";
            document.all.ar.style.display="";
            document.all.ap.style.display="none";
            break;
        }*/
    }

function getThn(){
	var date1 = ""+document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_FROM_DATE]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_FROM_DATE]%>_mn.value=bln;
	document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_FROM_DATE]%>_dy.value=hri;
	document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_FROM_DATE]%>_yr.value=thn;
	
	var date2 = ""+document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_UNTIL_DATE]%>.value;
	var thn1 = date2.substring(6,10);
	var bln1 = date2.substring(3,5);	
	if(bln1.charAt(0)=="0"){
		bln1 = ""+bln1.charAt(1);
	}
	
	var hri1 = date2.substring(0,2);
	if(hri1.charAt(0)=="0"){
		hri1 = ""+hri1.charAt(1);
	}
	
	document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_UNTIL_DATE]%>_mn.value=bln1;
	document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_UNTIL_DATE]%>_dy.value=hri1;
	document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_UNTIL_DATE]%>_yr.value=thn1;		
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
	  <table class="ds_box" cellpadding="0" cellspacing="0" id="ds_conclass" style="display: none;">
	    <tr><td id="ds_calclass"></td></tr>
	  </table>
	  <script language=JavaScript src="<%=approot%>/main/calendar.js"></script>
	<%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=searchTitle[arapType][SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmsearch" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="add_type" value="">
	      <input type="hidden" name="arapEdit" value="<%=arapEdit%>">
	      <input type="hidden" name="arapType" value="<%=arapType%>">
              <input type="hidden" name="arap_type" value="<%=arapType%><%//=srcArApEntry.getArApType()%>">
			  <input type="hidden" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_ARAP_TYPE]%>" value="<%=arapType%>">
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr>
                  <td colspan="3">&nbsp;
                  </td>
                </tr>
                <!-- tr>
                  <td width="16%" nowrap><%//=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                  <%/*
                    Vector typeValue = new Vector();
                    Vector typeKey = new Vector();
                    String sel_type = srcArApEntry.getArApType()+"";
                    int size = PstArApMain.stTypeArAp[0].length;
                    for(int i=0; i<size; i++){
                        typeValue.add(PstArApMain.stTypeArAp[SESS_LANGUAGE][i]);
                        typeKey.add(""+i);
                    }
                  */%>
                  <%//=ControlCombo.draw(FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_ARAP_TYPE],null,sel_type,typeKey,typeValue,"onChange=\"javascript:changeType()\"","")%>
                  </td>
                </tr -->
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_VOUCHER_NO]%>" size="20" value="<%=srcArApEntry.getVoucherNo()%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_NOTA_NO]%>" size="20" value="<%=srcArApEntry.getNotaNo()%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_CONTACT_NAME]%>" size="50" value="<%=srcArApEntry.getContactName()%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%"><input name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_TYPE]%>" type="radio" value="0" <%=(srcArApEntry.getType()==0?"checked":"")%>>
                    <%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%>
                  </td>
                </tr>
                <tr>
                  <td height="80%">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_TYPE]%>" type="radio" value="1" <%=(srcArApEntry.getType()==1?"checked":"")%>>
                    <%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%>
			<input onClick="ds_sh(this);" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_FROM_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcArApEntry.getFromDate() == null? new Date() : srcArApEntry.getFromDate()), "dd-MM-yyyy")%>"/>
			<input type="hidden" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_FROM_DATE]%>_mn">
			<input type="hidden" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_FROM_DATE]%>_dy">
			<input type="hidden" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_FROM_DATE]%>_yr">                   
                    <%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%>
			<input onClick="ds_sh(this);" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_UNTIL_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcArApEntry.getUntilDate() == null? new Date() : srcArApEntry.getUntilDate()), "dd-MM-yyyy")%>"/>
			<input type="hidden" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_UNTIL_DATE]%>_mn">
			<input type="hidden" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_UNTIL_DATE]%>_dy">
			<input type="hidden" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_UNTIL_DATE]%>_yr">
			<script language="JavaScript" type="text/JavaScript">getThn();</script> 
                    </td>
                </tr>
                <tr>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%">&nbsp;</td>
                </tr>
				<%if(arapType == PstArApMain.TYPE_AR){%>
                <tr id=searchar>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%"><input type="submit" name="Search" value="<%=strSearchAr%>" onClick="javascript:cmdSearch()"></td>
                </tr>
				<%}else{%>
                <tr id=searchap>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%"><input type="submit" name="Search" value="<%=strSearchAp%>" onClick="javascript:cmdSearch()"></td>
                </tr>
				<%}%>	
              </table>
            </form>
<script language="JavaScript">
    changeType();
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