<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.masterdata.SessModulAktiva,
                 com.dimata.aiso.form.masterdata.CtrlModulAktiva,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.util.Command,
                 com.dimata.util.Formater,
                 com.dimata.aiso.entity.search.SrcReceiveAktiva,
                 com.dimata.aiso.form.search.FrmSrcReceiveAktiva,
                 com.dimata.aiso.session.aktiva.SessReceiveAktiva,
                 com.dimata.aiso.form.aktiva.CtrlReceiveAktiva,
                 com.dimata.aiso.entity.aktiva.ReceiveAktiva,
                 com.dimata.aiso.entity.aktiva.PstReceiveAktivaItem" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

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
}
else
{
%>

<!-- JSP Block -->
<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static String strTitle[][] = 
{
	{
		"Nomor Dok",
		"Tanggal",
		"Supplier",
		"Total",
        "System tidak dapat menemukan data penerimaan aktiva"
	},
	{
		"Doc No",
		"Date",
        "Supplier",
        "Amount",
        "System can not found fixed assets received data"
	}
};

public static final String masterTitle[] = 
{
	"Daftar",
	"List"
};

public static final String listTitle[] = 
{
	"Terima Aktiva",
	"Receive Fixed Assets"
};

public String listDrawReceiveAktiva(FRMHandler objFRMHandler, Vector objectClass, int language)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"30%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"10%","center","left");

	ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	try{
		for (int i = 0; i < objectClass.size(); i++){
			Vector vect = (Vector)objectClass.get(i);

			ReceiveAktiva orderAktiva = (ReceiveAktiva)vect.get(0);
			ContactList contactList = (ContactList)vect.get(1);
			Vector rowx = new Vector();
			rowx.add(orderAktiva.getNomorReceive());
            rowx.add(Formater.formatDate(orderAktiva.getTanggalReceive(),"yyyy-MM-dd"));
            rowx.add(contactList.getCompName());
            rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(PstReceiveAktivaItem.getTotalReceiveAktivaItem(orderAktiva.getOID()))+"</div>");

            lstData.add(rowx);
			 lstLinkData.add(String.valueOf(orderAktiva.getOID()));
		}
     }catch(Exception e){
	 	System.out.println("EXc : "+e.toString());
	 }		 							
	 return ctrlist.drawMe();
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
int recordToGet = 24;
int vectSize = 0;

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.initDefault(SESS_LANGUAGE,"");
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Terima Aktiva" : "Receive Aktiva";
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Terima Search" : "Kembali Ke Pencarian Receive";

SrcReceiveAktiva srcReceiveAktiva = new SrcReceiveAktiva();
FrmSrcReceiveAktiva frmSrcReceiveAktiva = new FrmSrcReceiveAktiva(request);
if((iCommand==Command.BACK) && (session.getValue(SessReceiveAktiva.SESS_SEARCH_RECEIVE_AKTIVA)!=null)){
	srcReceiveAktiva = (SrcReceiveAktiva)session.getValue(SessReceiveAktiva.SESS_SEARCH_RECEIVE_AKTIVA);
}else{
	frmSrcReceiveAktiva.requestEntityObject(srcReceiveAktiva);
}

/*try{
	session.removeValue(SessReceiveAktiva.SESS_SEARCH_RECEIVE_AKTIVA);
}catch(Exception e){
	System.out.println("--- Remove session error ---");
}*/

if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)
        ||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try	{
		srcReceiveAktiva = (SrcReceiveAktiva)session.getValue(SessReceiveAktiva.SESS_SEARCH_RECEIVE_AKTIVA);
	}catch(Exception e){
		srcReceiveAktiva = new SrcReceiveAktiva();
	}
}

if(srcReceiveAktiva==null){
	srcReceiveAktiva = new SrcReceiveAktiva();
} 

session.putValue(SessReceiveAktiva.SESS_SEARCH_RECEIVE_AKTIVA, srcReceiveAktiva);

SessReceiveAktiva objSessJurnal = new SessReceiveAktiva();
vectSize = SessReceiveAktiva.countModulAktiva(srcReceiveAktiva);

if(iCommand!=Command.BACK){
	if((iCommand==Command.NONE)||(iCommand==Command.LIST)){
		iCommand = Command.LAST;	
	}
	CtrlReceiveAktiva ctrlReceiveAktiva = new CtrlReceiveAktiva(request);
	start = ctrlReceiveAktiva.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

    //System.out.println("--- Remove session error ---");
Vector listReceiveAktiva = SessReceiveAktiva.listReceiveAktiva(srcReceiveAktiva, start, recordToGet);
    System.out.println("--- nilai : "+listReceiveAktiva);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
<%if(privAdd){%>
function cmdAdd(){
	document.frmsrcorderaktiva.hidden_receive_aktiva_id.value="0";
	document.frmsrcorderaktiva.command.value="<%=Command.ADD%>";
	document.frmsrcorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmsrcorderaktiva.submit();
}
<%}%>

function cmdEdit(oid){
	document.frmsrcorderaktiva.hidden_receive_aktiva_id.value=oid;
	document.frmsrcorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmsrcorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmsrcorderaktiva.submit();
}

function first(){
	document.frmsrcorderaktiva.command.value="<%=Command.FIRST%>";
	document.frmsrcorderaktiva.action="receive_aktiva_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function prev(){
	document.frmsrcorderaktiva.command.value="<%=Command.PREV%>";
	document.frmsrcorderaktiva.action="receive_aktiva_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function next(){
	document.frmsrcorderaktiva.command.value="<%=Command.NEXT%>";
	document.frmsrcorderaktiva.action="receive_aktiva_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function last(){
	document.frmsrcorderaktiva.command.value="<%=Command.LAST%>";
	document.frmsrcorderaktiva.action="receive_aktiva_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function cmdBack(){
	document.frmsrcorderaktiva.command.value="<%=Command.BACK%>";
	document.frmsrcorderaktiva.action="receive_aktiva_search.jsp";
	document.frmsrcorderaktiva.submit();
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
			<%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font>
		  <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmsrcorderaktiva" method="post" action="">
              <input type="hidden" name="hidden_receive_aktiva_id" value="0">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">			  			  			  
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
			  <table width="100%">				
				<tr>
				<td>
                <%if((listReceiveAktiva!=null)&&(listReceiveAktiva.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(listDrawReceiveAktiva(objFRMHandler,listReceiveAktiva,SESS_LANGUAGE));
				  %>
                  <%=ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%>               
                <%} else {%>
				
             <table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
				<tr>
					<td>
					  <table width="100%" border="0" cellspacing="2" cellpadding="0" class="listgensellOdd">		
					  	<tr><td>&nbsp;</td></tr>		
						<tr> 
						  <td><div align="center"><span class="errfont"><%=strTitle[SESS_LANGUAGE][4]%></span></div></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					  </table>
					  </td>
				 </tr>
				 </table> 
                <%  }	%>

              <table width="100%" border="0" cellspacing="2" cellpadding="0">
					<tr>
					  <td height="16" class="command">
					  <a href="javascript:cmdBack()"><%=strBack%></a>
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