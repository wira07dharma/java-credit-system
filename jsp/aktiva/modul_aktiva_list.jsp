<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.masterdata.SessModulAktiva,
                 com.dimata.aiso.form.masterdata.CtrlModulAktiva,
                 com.dimata.aiso.form.aktiva.FrmOrderAktivaItem" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>

<!-- import aiso -->
<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %> 
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.periode.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.session.jurnal.*" %>

<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 

%>
<!-- JSP Block -->
<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static String strTitle[][] = 
{
	{
		"Kode",
		"Nama",
		"Jenis Aktiva",
		"Tipe Penyusutan",
		"Metode Penyusutan",
        "Tidak ada daftar data aktiva"
	},
	{
		"Code",
		"Name",
        "Fixed Assets Type",
        "Depreciation Type",
        "Depreciation Method",
        "Data not found"
	}
};

public static final String masterTitle[] = 
{
	"Daftar",
	"List"
};

public static final String listTitle[] = 
{
	"Aktiva Tetap",
	"Fixed Assets"
};

public String listDrawModulAktiva(FRMHandler objFRMHandler, Vector objectClass, int language)
{
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][1],"30%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"10%","center","left");

	ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	try
	{
		for (int i = 0; i < objectClass.size(); i++) 
		{
			 Vector vect = (Vector)objectClass.get(i);
			 
			 ModulAktiva modulAktiva = (ModulAktiva)vect.get(0);
			 Aktiva aktiva = (Aktiva)vect.get(1);


			 Vector rowx = new Vector(); 
			 rowx.add(modulAktiva.getKode());
             rowx.add(modulAktiva.getName());
            rowx.add(aktiva.getNama());
            rowx.add(aktiva.getNamaTipepenyusutan());
            rowx.add(aktiva.getNamaMetodepenyusutan());

            lstData.add(rowx);
			 lstLinkData.add(String.valueOf(modulAktiva.getOID())+"','"+modulAktiva.getKode()+"','"+modulAktiva.getName()+"','"+Formater.formatNumber(modulAktiva.getHargaPerolehan(),"###"));
		}
     }
	 catch(Exception e)
	 {
	 	System.out.println("EXc : "+e.toString());
	 }		 							
	 return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
int recordToGet = 15;
int vectSize = 0;

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.initDefault(SESS_LANGUAGE,"");
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Journal" : "Jurnal";  
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Journal Search" : "Kembali Ke Pencarian Jurnal";

SrcModulAktiva srcModulAktiva = new SrcModulAktiva();
FrmSrcModulAktiva frmSrcModulAktiva = new FrmSrcModulAktiva(request);
if((iCommand==Command.BACK) && (session.getValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA)!=null)){
	srcModulAktiva = (SrcModulAktiva)session.getValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA);
}else{
	frmSrcModulAktiva.requestEntityObject(srcModulAktiva);
}

try{
	session.removeValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA);
}catch(Exception e){
	System.out.println("--- Remove session error ---");
}

if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)
        ||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try	{
		srcModulAktiva = (SrcModulAktiva)session.getValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA);
	}catch(Exception e){
		srcModulAktiva = new SrcModulAktiva();
	}
}

if(srcModulAktiva==null){
	srcModulAktiva = new SrcModulAktiva();
} 

session.putValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA, srcModulAktiva);

SessModulAktiva objSessJurnal = new SessModulAktiva();
vectSize = SessModulAktiva.countModulAktiva(srcModulAktiva);

if(iCommand!=Command.BACK){
	if((iCommand==Command.NONE)||(iCommand==Command.LIST)){
		iCommand = Command.LAST;	
	}
	CtrlModulAktiva objCtrlModulAktiva = new CtrlModulAktiva(request);
	start = objCtrlModulAktiva.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

    //System.out.println("--- Remove session error ---");
Vector listModulAktiva = objSessJurnal.listModulAktiva(srcModulAktiva, start, recordToGet);
   // System.out.println("--- nilai : "+listModulAktiva);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
function cmdEdit(oid, code, aktivaName, price){
	self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_AKTIVA_ID]%>.value = oid;
    self.opener.document.forms.frmorderaktiva.aktiva_code.value = code;
    self.opener.document.forms.frmorderaktiva.aktiva_name.value = aktivaName;
    self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_QTY]%>.value = "1";
    self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_PRICE]%>.value = price;
    self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_TOTAL_PRICE]%>.value = price;
    self.close();
}

function first(){
	document.frmsrcju.command.value="<%=Command.FIRST%>";
	document.frmsrcju.action="modul_aktiva_list.jsp";
	document.frmsrcju.submit();
}

function prev(){
	document.frmsrcju.command.value="<%=Command.PREV%>";
	document.frmsrcju.action="modul_aktiva_list.jsp";
	document.frmsrcju.submit();
}

function next(){
	document.frmsrcju.command.value="<%=Command.NEXT%>";
	document.frmsrcju.action="modul_aktiva_list.jsp";
	document.frmsrcju.submit();
}

function last(){
	document.frmsrcju.command.value="<%=Command.LAST%>";
	document.frmsrcju.action="modul_aktiva_list.jsp";
	document.frmsrcju.submit();
}

function cmdBack(){
	document.frmsrcju.command.value="<%=Command.BACK%>";
	document.frmsrcju.action="modul_aktiva_search.jsp";
	document.frmsrcju.submit();
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
            <form name="frmsrcju" method="post" action="">
              <input type="hidden" name="hidden_modul_aktiva_id" value="0">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">			  			  			  
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
                <%if((listModulAktiva!=null)&&(listModulAktiva.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(listDrawModulAktiva(objFRMHandler,listModulAktiva,SESS_LANGUAGE));
				  %>                            
                  <%=ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%>               
                <%} else {%>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">				
                <tr> 
                  <td><span class="comment"><%=strTitle[SESS_LANGUAGE][5]%></span></td>
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
