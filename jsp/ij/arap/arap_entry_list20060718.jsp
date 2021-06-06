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
        "Tanggal",
		"Kontak",
		"Nilai Buku",
        "Tidak ada data sesuai yang ditemukan",
        "No. Nota",
        "Posted",
        "Belum"
	},
	{
		"Voucher Number",
        "Date",
        "Contact",
        "Book Value",
        "List is empty",
        "Nota Number",
        "Posted",
        "Not Yet"
	}
};

public static final String masterTitle[] =
{
    "Entry Piutang/Hutang",
	"AR/AP Entry"
};

public static final String listTitle[][] =
{
    {"Daftar Piutang",
	"List Receivable"}
    ,
    {"Daftar Hutang",
	"List Payable"}
};

public String listDrawArApEntry(FRMHandler objFRMHandler, Vector objectClass, int language)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("90%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"10%","center","left");
    ctrlist.dataFormat(strTitle[language][5],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"40%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"10%","center","left");
    ctrlist.dataFormat(strTitle[language][6],"10%","center","center");

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

			ArApMain arApMain = (ArApMain)vect.get(0);
			ContactList contactList = (ContactList)vect.get(1);
			Vector rowx = new Vector();
			rowx.add(arApMain.getVoucherNo());
            rowx.add(arApMain.getNotaNo());
            rowx.add(Formater.formatDate(arApMain.getVoucherDate(),"yyyy-MM-dd"));
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
int recordToGet = 15;
int vectSize = 0;

SrcArApEntry srcArApMain = new SrcArApEntry();
FrmSrcArApEntry frmSrcArApEntry = new FrmSrcArApEntry(request);
if((iCommand==Command.BACK) && (session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY)!=null)){
	srcArApMain = (SrcArApEntry)session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);
    srcArApMain.setArApType(arapType);
}else{
	frmSrcArApEntry.requestEntityObject(srcArApMain);
}

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.setLanguage(SESS_LANGUAGE);
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,listTitle[srcArApMain.getArApType()][SESS_LANGUAGE],ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To AR/AP Search" : "Kembali Ke Pencarian Hutang/Piutang";

try{
	session.removeValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);
}catch(Exception e){
	System.out.println("--- Remove session error ---");
}

if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)
        ||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try	{
		srcArApMain = (SrcArApEntry)session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);
	}catch(Exception e){
		srcArApMain = new SrcArApEntry();
	}
}

if(srcArApMain==null){
	srcArApMain = new SrcArApEntry();
} 

session.putValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY, srcArApMain);

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
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
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
	document.frmsrcarapentry.action="arap_entry_search.jsp";
	document.frmsrcarapentry.submit();
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
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> &gt; <%=listTitle[srcArApMain.getArApType()][SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmsrcarapentry" method="post" action="">
              <input type="hidden" name="arap_main_id" value="0">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">
              <input type="hidden" name="arap_type" value="<%=arapType%>">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
                <%if((listArApMain!=null)&&(listArApMain.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(listDrawArApEntry(objFRMHandler,listArApMain,SESS_LANGUAGE));
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