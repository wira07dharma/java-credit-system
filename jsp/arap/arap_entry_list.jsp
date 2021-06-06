<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.entity.search.SrcOrderAktiva,
                 com.dimata.aiso.form.search.FrmSrcOrderAktiva,
                 com.dimata.util.Command,
                 com.dimata.aiso.form.aktiva.CtrlOrderAktiva,
                 com.dimata.util.Formater,
                 com.dimata.aiso.entity.arap.ArApMain,
                 com.dimata.aiso.entity.search.SrcArApEntry,
                 com.dimata.aiso.form.search.FrmSrcArApEntry,
                 com.dimata.aiso.session.arap.SessArApEntry,
                 com.dimata.aiso.form.arap.CtrlArApMain,
                 com.dimata.common.entity.contact.ContactList" %>

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
	"No. Voucher",
        "Tanggal Nota",
	"Kontak",
	"Jumlah",
        "Tidak ada data sesuai yang ditemukan",
        "No. Nota",
        "Posted",
        "Belum",
	"No."	
	},
	{
	"Voucher Number",
        "Invoice Date",
        "Contact",
        "Amount",
        "List is empty",
        "Nota Number",
        "Posted",
        "Not Yet",
	"No"	
	}
};

public static final String masterTitle[] =
{
    "Daftar",
	"List"
};

public static final String listTitle[][] =
{
    {"Piutang",
	"Receivable"}
    ,
    {"Hutang",
	"Payable"}
};

public String listDrawArApEntry(FRMHandler objFRMHandler, Vector objectClass, int language, int start)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][8],"3%","center","center");
	ctrlist.dataFormat(strTitle[language][0],"10%","center","center");
	ctrlist.dataFormat(strTitle[language][5],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"40%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"17%","center","left");
	ctrlist.dataFormat(strTitle[language][6],"10%","center","left");

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

			ArApMain arApMain = (ArApMain)vect.get(0);
			ContactList contactList = (ContactList)vect.get(1);
			Vector rowx = new Vector();
			rowx.add(""+(i+1+start));
			rowx.add(arApMain.getVoucherNo());
			rowx.add(arApMain.getNotaNo());
			rowx.add(Formater.formatDate(arApMain.getNotaDate(),"dd MMM yyyy"));
			rowx.add(mergeString(contactList.getCompName(),contactList.getPersonName()));
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(arApMain.getAmount())+"</div>");
			rowx.add(arApMain.getArApDocStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED?strTitle[language][6]:strTitle[language][7]);

            lstData.add(rowx);
			 lstLinkData.add(String.valueOf(arApMain.getOID()));
		}
     }catch(Exception e){
	 	System.out.println("EXc : "+e.toString());
	 }		 							
	 return ctrlist.drawMe();
}

public String cekNull(String val){
	if(val==null || val.length()==0)
		val = "-";
	return val;
}

public String mergeString(String name1, String name2){
	if(name1==null || name1.length()==0){
        if(name2==null || name2.length()==0){
            return "";
        }
        else{
            return name2;
        }
    }
    else{
        if(name2==null || name2.length()==0){
            return name1;
        }
        else{
            return name1 + " / " + name2;
        }
    }
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int arapType = FRMQueryString.requestInt(request,"arap_type");
int arapEdit = FRMQueryString.requestInt(request,"arapEdit");
int recordToGet = 25;
int vectSize = 0;

SrcArApEntry srcArApMain = new SrcArApEntry();
FrmSrcArApEntry frmSrcArApEntry = new FrmSrcArApEntry(request);
if((iCommand==Command.BACK) && (session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY)!=null)){
	srcArApMain = (SrcArApEntry)session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);	
}else{
    if(iCommand==Command.LIST)
	    frmSrcArApEntry.requestEntityObject(srcArApMain);
}

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.setLanguage(SESS_LANGUAGE);
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,listTitle[srcArApMain.getArApType()][SESS_LANGUAGE],ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Search" : "Kembali Ke Pencarian";

//try{
//	session.removeValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);
//}catch(Exception e){
//	System.out.println("--- Remove session error ---");
//}

if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)
        ||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try	{
		srcArApMain = (SrcArApEntry)session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);
	}catch(Exception e){
		srcArApMain = new SrcArApEntry();
	}
}else{
    session.putValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY, srcArApMain);
}

if(srcArApMain==null){
	srcArApMain = new SrcArApEntry();
} 


SessArApEntry objSessJurnal = new SessArApEntry();
vectSize = SessArApEntry.countArApMain(srcArApMain);

if(iCommand!=Command.BACK){
	CtrlArApMain ctrlArApMain = new CtrlArApMain(request);
	start = ctrlArApMain.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

    //System.out.println("--- Remove session error ---");
Vector listArApMain = SessArApEntry.listArApMain(srcArApMain, start, recordToGet);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
<%if(privAdd){%>
function cmdAdd(){
	document.frmsrcarapentry.arap_main_id.value="0";
    document.frmsrcarapentry.arap_type.value="<%=srcArApMain.getArApType()%>";
	document.frmsrcarapentry.command.value="<%=Command.ADD%>";
	document.frmsrcarapentry.action="arap_entry_edit.jsp";
	document.frmsrcarapentry.submit();
}
<%}%>

function cmdEdit(oid){
	document.frmsrcarapentry.arap_main_id.value=oid;
	document.frmsrcarapentry.arapEdit.value="<%=arapEdit%>";
	document.frmsrcarapentry.arap_type.value="<%=srcArApMain.getArApType()%>";
	document.frmsrcarapentry.command.value="<%=Command.EDIT%>";
	document.frmsrcarapentry.action="arap_entry_edit.jsp";
	document.frmsrcarapentry.submit();
}

function first(){
	document.frmsrcarapentry.command.value="<%=Command.FIRST%>";
	document.frmsrcarapentry.action="arap_entry_list.jsp";
	document.frmsrcarapentry.submit();
}

function prev(){
	document.frmsrcarapentry.command.value="<%=Command.PREV%>";
	document.frmsrcarapentry.action="arap_entry_list.jsp";
	document.frmsrcarapentry.submit();
}

function next(){
	document.frmsrcarapentry.command.value="<%=Command.NEXT%>";
	document.frmsrcarapentry.action="arap_entry_list.jsp";
	document.frmsrcarapentry.submit();
}

function last(){
	document.frmsrcarapentry.command.value="<%=Command.LAST%>";
	document.frmsrcarapentry.action="arap_entry_list.jsp";
	document.frmsrcarapentry.submit();
}

function cmdBack(){
	document.frmsrcarapentry.command.value="<%=Command.BACK%>";
	document.frmsrcarapentry.arap_type.value="<%=arapType%>";
	document.frmsrcarapentry.action="arap_entry_search.jsp";
	document.frmsrcarapentry.submit();
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[srcArApMain.getArApType()][SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmsrcarapentry" method="post" action="">
              <input type="hidden" name="arap_main_id" value="0">
              <input type="hidden" name="start" value="<%=start%>">
	      <input type="hidden" name="arapEdit" value="<%=arapEdit%>">
              <input type="hidden" name="add_type" value="">
              <input type="hidden" name="arap_type" value="<%=arapType%>">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
                <%if((listArApMain!=null)&&(listArApMain.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(listDrawArApEntry(objFRMHandler,listArApMain,SESS_LANGUAGE,start));
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
					  <a href="javascript:cmdBack()"><%=strBack%>&nbsp;<%=listTitle[arapType][SESS_LANGUAGE]%></a>
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