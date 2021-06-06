<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.masterdata.SessModulAktiva,
                 com.dimata.aiso.form.masterdata.CtrlModulAktiva,
                 com.dimata.aiso.entity.aktiva.OrderAktiva,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.aiso.session.aktiva.SessOrderAktiva,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.entity.search.SrcOrderAktiva,
                 com.dimata.aiso.form.search.FrmSrcOrderAktiva,
                 com.dimata.util.Command,
                 com.dimata.aiso.form.aktiva.CtrlOrderAktiva,
                 com.dimata.util.Formater,
                 com.dimata.aiso.form.aktiva.FrmReceiveAktiva" %>

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
		"Order Nomor",
		"Tanggal",
		"Supplier",
		"Uang Muka",
        "Tidak ada daftar order aktiva"
	},
	{
		"Order Number",
		"Date",
        "Supplier",
        "Down Payment",
        "Not found data order aktiva"
	}
};

public static final String masterTitle[] = 
{
	"Order Aktiva",
	"Order Aktiva"
};

public static final String listTitle[] = 
{
	"Daftar Order Aktiva",
	"List Order Aktiva"
};

public String listDrawOrderAktiva(FRMHandler objFRMHandler, Vector objectClass, int language)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"10%","left","left");
	ctrlist.dataFormat(strTitle[language][1],"10%","left","left");
	ctrlist.dataFormat(strTitle[language][2],"30%","left","left");
	ctrlist.dataFormat(strTitle[language][3],"10%","left","left");

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

			OrderAktiva orderAktiva = (OrderAktiva)vect.get(0);
			ContactList contactList = (ContactList)vect.get(1);
			Vector rowx = new Vector();
			rowx.add(orderAktiva.getNomorOrder());
            rowx.add(Formater.formatDate(orderAktiva.getTanggalOrder(),"yyyy-MM-dd"));
            rowx.add(contactList.getCompName());
            rowx.add(""+orderAktiva.getValueRate());

            lstData.add(rowx);
			 lstLinkData.add(String.valueOf(orderAktiva.getOID())+"','"+orderAktiva.getNomorOrder()+"','"+orderAktiva.getIdPerkiraanDp()+"','"+FRMHandler.userFormatStringDecimal(orderAktiva.getDownPayment()));
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
int recordToGet = 15;
int vectSize = 0;

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Order Aktiva" : "Order Aktiva";
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Order Search" : "Kembali Ke Pencarian Order";

SrcOrderAktiva srcOrderAktiva = new SrcOrderAktiva();
FrmSrcOrderAktiva frmSrcOrderAktiva = new FrmSrcOrderAktiva(request);
if((iCommand==Command.BACK) && (session.getValue(SessOrderAktiva.SESS_SEARCH_ORDER_AKTIVA)!=null)){
	srcOrderAktiva = (SrcOrderAktiva)session.getValue(SessOrderAktiva.SESS_SEARCH_ORDER_AKTIVA);
}else{
	frmSrcOrderAktiva.requestEntityObject(srcOrderAktiva);
}

try{
	session.removeValue(SessOrderAktiva.SESS_SEARCH_ORDER_AKTIVA);
}catch(Exception e){
	System.out.println("--- Remove session error ---");
}

if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)
        ||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try	{
		srcOrderAktiva = (SrcOrderAktiva)session.getValue(SessOrderAktiva.SESS_SEARCH_ORDER_AKTIVA);
	}catch(Exception e){
		srcOrderAktiva = new SrcOrderAktiva();
	}
}

if(srcOrderAktiva==null){
	srcOrderAktiva = new SrcOrderAktiva();
} 

session.putValue(SessOrderAktiva.SESS_SEARCH_ORDER_AKTIVA, srcOrderAktiva);

SessOrderAktiva objSessJurnal = new SessOrderAktiva();
vectSize = SessOrderAktiva.countModulAktiva(srcOrderAktiva);

if(iCommand!=Command.BACK){
	if((iCommand==Command.NONE)||(iCommand==Command.LIST)){
		iCommand = Command.LAST;	
	}
	CtrlOrderAktiva ctrlOrderAktiva = new CtrlOrderAktiva(request);
	start = ctrlOrderAktiva.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

    //System.out.println("--- Remove session error ---");
Vector listOrderAktiva = SessOrderAktiva.listOrderAktiva(srcOrderAktiva, start, recordToGet);
    //System.out.println("--- nilai : "+listOrderAktiva);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">
function cmdEdit(oid,nomor,oiddp,downpay){
   self.opener.document.forms.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>.value = oid;
   self.opener.document.forms.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>_TEXT.value = nomor;
   self.opener.document.forms.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]%>.value = oiddp;
   self.opener.document.forms.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]%>_TEXT.value = oiddp;
   self.opener.document.forms.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_DOWN_PAYMENT]%>.value = downpay;
   self.close();
}

function first(){
	document.frmsrcorderaktiva.command.value="<%=Command.FIRST%>";
	document.frmsrcorderaktiva.action="receive_order_aktiva_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function prev(){
	document.frmsrcorderaktiva.command.value="<%=Command.PREV%>";
	document.frmsrcorderaktiva.action="receive_order_aktiva_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function next(){
	document.frmsrcorderaktiva.command.value="<%=Command.NEXT%>";
	document.frmsrcorderaktiva.action="receive_order_aktiva_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function last(){
	document.frmsrcorderaktiva.command.value="<%=Command.LAST%>";
	document.frmsrcorderaktiva.action="receive_order_aktiva_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function cmdBack(){
	document.frmsrcorderaktiva.command.value="<%=Command.BACK%>";
	document.frmsrcorderaktiva.action="receive_order_aktiva_search.jsp";
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> &gt; <%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmsrcorderaktiva" method="post" action="">
              <input type="hidden" name="order_aktiva_id" value="0">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">			  			  			  
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
                <%if((listOrderAktiva!=null)&&(listOrderAktiva.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(listDrawOrderAktiva(objFRMHandler,listOrderAktiva,SESS_LANGUAGE));
				  %>
                  <%=ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%>               
                <%} else {%>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">				
                <tr> 
                  <td><span class="comment"><%=strTitle[SESS_LANGUAGE][4]%></span></td>
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