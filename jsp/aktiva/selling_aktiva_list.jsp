<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.entity.aktiva.SellingAktiva,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.aiso.session.aktiva.SessSellingAktiva,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.entity.search.SrcSellingAktiva,
                 com.dimata.aiso.form.search.FrmSrcSellingAktiva,
                 com.dimata.util.Command,
                 com.dimata.aiso.form.aktiva.CtrlSellingAktiva,
                 com.dimata.util.Formater,
                 com.dimata.aiso.entity.aktiva.PstSellingAktivaItem" %>

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
		"No. Dok Jual",
		"Tgl Dok Jual",
		"Customer",
		"Total",
        	"Tidak ada daftar penjualan aktiva",
		"Status Dok.",
		"No.",
		"Posted",
		"Draft"
	},
	{
		"Doc Number",
		"Doc Date",
        	"Customer",
        	"Amount",
        	"Not found data selling aktiva",
		"Doc Status",
		"No.",
		"Posted",
		"Draft"
	}
};

public static final String masterTitle[] = 
{
	"Daftar",
	"List"
};

public static final String listTitle[] = 
{
	"Pengeluaran Inventaris",
	"Fixed Assets Out Going"
};

public String listDrawSellingAktiva(FRMHandler objFRMHandler, Vector objectClass, int language)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][6],"5%","center","left");
	ctrlist.dataFormat(strTitle[language][0],"20%","center","left");
	ctrlist.dataFormat(strTitle[language][1],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"35%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][5],"10%","center","center");

	ctrlist.setLinkRow(1);
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

			SellingAktiva sellingAktiva = (SellingAktiva)vect.get(0);
			ContactList contactList = (ContactList)vect.get(1);
			Vector rowx = new Vector();
			rowx.add("<div align=\"center\">"+(i+1)+"</div>");
			rowx.add("<div align=\"center\">"+sellingAktiva.getNomorSelling()+"</div>");
            	rowx.add("<div align=\"center\">"+Formater.formatDate(sellingAktiva.getTanggalSelling(),"dd-MM-yyyy")+"</div>");
            	rowx.add(contactList.getCompName());
            	rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(PstSellingAktivaItem.getTotalSellingAktivaItem(sellingAktiva.getOID()))+"</div>");
			rowx.add(sellingAktiva.getSellingStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED?strTitle[language][7]:strTitle[language][8]);
            lstData.add(rowx);
			 lstLinkData.add(String.valueOf(sellingAktiva.getOID()));
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
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Selling Aktiva" : "Selling Aktiva";
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Selling Search" : "Kembali Ke Pencarian Selling";

SrcSellingAktiva srcSellingAktiva = new SrcSellingAktiva();
FrmSrcSellingAktiva frmSrcSellingAktiva = new FrmSrcSellingAktiva(request);
if((iCommand==Command.BACK) && (session.getValue(SessSellingAktiva.SESS_SEARCH_SELLING_AKTIVA)!=null)){
	srcSellingAktiva = (SrcSellingAktiva)session.getValue(SessSellingAktiva.SESS_SEARCH_SELLING_AKTIVA);
}else{
	frmSrcSellingAktiva.requestEntityObject(srcSellingAktiva);
}

try{
	session.removeValue(SessSellingAktiva.SESS_SEARCH_SELLING_AKTIVA);
}catch(Exception e){
	System.out.println("--- Remove session error ---");
}

if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)
        ||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try	{
		srcSellingAktiva = (SrcSellingAktiva)session.getValue(SessSellingAktiva.SESS_SEARCH_SELLING_AKTIVA);
	}catch(Exception e){
		srcSellingAktiva = new SrcSellingAktiva();
	}
}

if(srcSellingAktiva==null){
	srcSellingAktiva = new SrcSellingAktiva();
} 

session.putValue(SessSellingAktiva.SESS_SEARCH_SELLING_AKTIVA, srcSellingAktiva);

SessSellingAktiva objSessJurnal = new SessSellingAktiva();
vectSize = SessSellingAktiva.countModulAktiva(srcSellingAktiva);

if(iCommand!=Command.BACK){
	if((iCommand==Command.NONE)||(iCommand==Command.LIST)){
		iCommand = Command.LAST;	
	}
	CtrlSellingAktiva ctrlSellingAktiva = new CtrlSellingAktiva(request);
	start = ctrlSellingAktiva.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

    //System.out.println("--- Remove session error ---");
Vector listSellingAktiva = SessSellingAktiva.listSellingAktiva(srcSellingAktiva, start, recordToGet);
    System.out.println("--- nilai : "+listSellingAktiva);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
<%if(privAdd){%>
function cmdAdd(){
	document.frmsrcsellingaktiva.hidden_selling_aktiva_id.value="0";
	document.frmsrcsellingaktiva.command.value="<%=Command.ADD%>";
	document.frmsrcsellingaktiva.action="selling_aktiva_edit.jsp";
	document.frmsrcsellingaktiva.submit();
}
<%}%>

function cmdEdit(oid){
	document.frmsrcsellingaktiva.hidden_selling_aktiva_id.value=oid;
	document.frmsrcsellingaktiva.command.value="<%=Command.EDIT%>";
	document.frmsrcsellingaktiva.action="selling_aktiva_edit.jsp";
	document.frmsrcsellingaktiva.submit();
}

function first(){
	document.frmsrcsellingaktiva.command.value="<%=Command.FIRST%>";
	document.frmsrcsellingaktiva.action="selling_aktiva_list.jsp";
	document.frmsrcsellingaktiva.submit();
}

function prev(){
	document.frmsrcsellingaktiva.command.value="<%=Command.PREV%>";
	document.frmsrcsellingaktiva.action="selling_aktiva_list.jsp";
	document.frmsrcsellingaktiva.submit();
}

function next(){
	document.frmsrcsellingaktiva.command.value="<%=Command.NEXT%>";
	document.frmsrcsellingaktiva.action="selling_aktiva_list.jsp";
	document.frmsrcsellingaktiva.submit();
}

function last(){
	document.frmsrcsellingaktiva.command.value="<%=Command.LAST%>";
	document.frmsrcsellingaktiva.action="selling_aktiva_list.jsp";
	document.frmsrcsellingaktiva.submit();
}

function cmdBack(){
	document.frmsrcsellingaktiva.command.value="<%=Command.BACK%>";
	document.frmsrcsellingaktiva.action="selling_aktiva_search.jsp";
	document.frmsrcsellingaktiva.submit();
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmsrcsellingaktiva" method="post" action="">
              <input type="hidden" name="hidden_selling_aktiva_id" value="0">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">			  			  			  
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
                <%if((listSellingAktiva!=null)&&(listSellingAktiva.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(listDrawSellingAktiva(objFRMHandler,listSellingAktiva,SESS_LANGUAGE));
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
  					  <%if((privAdd)){%>
					  <a href="javascript:cmdAdd()"><%=strAdd%></a> |
					  <%}%>
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