<%@ page language="java" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.invoice.*,
		 com.dimata.aiso.entity.search.SrcCrossCheckData,
		 com.dimata.aiso.form.search.FrmSrcCrossCheckData,
                 com.dimata.aiso.entity.invoice.*,
		 com.dimata.aiso.entity.arap.*,
		 com.dimata.aiso.entity.masterdata.*,
		 com.dimata.common.entity.contact.*,
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
		"Tipe Data",
		"Tipe Transaksi",
		"Tipe Pencocokan",
		"Hutang/Piutang ke Buku Besar",
		"Buku Besar ke Hutang/Piutang"
	},
	{
		"Data Type",
		"Transaction Type",
		"Cross Check Type",
		"AR/AP to GL",
		"GL to AR/AP"	
	}
};

public static final String masterTitle[] =
{
	"Proses","Process"
};

public static final String searchTitle[] =
{
	"Pencocokan Data","Cross Check Data"
};

public String getContactName(ContactList objContactList){
	if(objContactList != null){
		try{
			if(objContactList.getCompName() != null){
				return objContactList.getCompName();
			}else{
				return objContactList.getPersonName();
			}
		}catch(Exception e){}
	}
	return "";
}

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
int iQueryType = FRMQueryString.requestInt(request, "query_type");



// ControlLine and Commands caption
ControlLine ctrLine = new ControlLine();
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Invoice" : "Invoice";
String strAdd = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSearch = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);
String process = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Process" : "Proses";

SrcCrossCheckData objSrcCrossCheckData = new SrcCrossCheckData();
FrmSrcCrossCheckData frmSrcCrossCheckData = new FrmSrcCrossCheckData();
frmSrcCrossCheckData.requestEntityObject(objSrcCrossCheckData);
if(session.getValue("WHERE_CLAUSE") != null){
	try{
		session.removeValue("WHERE_CLAUSE");
	}catch(Exception e){}
}

try{
	session.putValue("WHERE_CLAUSE",objSrcCrossCheckData);
}catch(Exception e){}

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdSearch(qType){
	document.<%=FrmSrcCrossCheckData.FRM_SRC_CRS_DATA%>.query_type.value=qType;
	document.<%=FrmSrcCrossCheckData.FRM_SRC_CRS_DATA%>.command.value="<%=Command.LIST%>";
	document.<%=FrmSrcCrossCheckData.FRM_SRC_CRS_DATA%>.action="crosscheck_invoice_list.jsp";
	document.<%=FrmSrcCrossCheckData.FRM_SRC_CRS_DATA%>.submit();
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		  <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=searchTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="<%=FrmSrcCrossCheckData.FRM_SRC_CRS_DATA%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="add_type" value="">	     
	      <input type="hidden" name="query_type" value="<%=iQueryType%>">
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr>
                  <td colspan="3">&nbsp;
                    
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                     <%
			   Vector type_value = new Vector(1,1);
			   Vector type_key = new Vector(1,1);
			   String sel_type = ""+objSrcCrossCheckData.getTypeArap(); 
			   String strAR = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Account Receivable" : "Piutang Usaha";
			   String strAP = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Account Payable" : "Hutang Usaha";
			    type_value.add(strAR);
			    type_key.add(""+PstArApMain.TYPE_AR); 
			    type_value.add(strAP);
			    type_key.add(""+PstArApMain.TYPE_AP);
			 %>    
		<%= ControlCombo.draw(FrmSrcCrossCheckData.fieldNames[FrmSrcCrossCheckData.FRM_TYPE_DATA],null, sel_type, type_key, type_value, "", "") %> 
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                   <%
			   Vector trans_value = new Vector(1,1);
			   Vector trans_key = new Vector(1,1);
			   String sel_trans = ""+objSrcCrossCheckData.getTypeTrans(); 
			   String strIncrease = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Increase" : "Penambahan";
			   String strPayment = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Payment" : "Pembayaran";
			    trans_value.add(strIncrease);
			    trans_key.add(""+PstPerkiraan.ACC_DEBETSIGN);  
			    trans_value.add(strPayment);
			    trans_key.add(""+PstPerkiraan.ACC_KREDITSIGN);
			 %>    
		<%= ControlCombo.draw(FrmSrcCrossCheckData.fieldNames[FrmSrcCrossCheckData.FRM_TYPE_TRANS],null, sel_trans, trans_key, trans_value, "", "") %> 
                  </td>
                </tr>
		<tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                   <%
			   Vector cc_value = new Vector(1,1);
			   Vector cc_key = new Vector(1,1);
			   String sel_cc = ""+objSrcCrossCheckData.getTypeCrossCheck(); 
			    cc_value.add(strTitle[SESS_LANGUAGE][3]);
			    cc_key.add("0");  
			    cc_value.add(strTitle[SESS_LANGUAGE][4]);
			    cc_key.add("1");
			 %>    
		<%= ControlCombo.draw(FrmSrcCrossCheckData.fieldNames[FrmSrcCrossCheckData.FRM_TYPE_CRS_CHECK],null, sel_cc, cc_key, cc_value, "", "") %> 
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
                  <td width="83%"><input type="submit" name="Search" value="<%=process%>" onClick="javascript:cmdSearch('<%=iQueryType%>')"></td>
                </tr>
                <%if((privAdd)){%>
                <tr>
                  <td width="16%" height="16">&nbsp;</td>
                  <td width="1%" height="16" class="command">&nbsp;</td>
                  <td width="83%" height="16" class="command">&nbsp;</td>
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