<% 
/* 
 * Page Name  		:  standartrate.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */

/*******************************************************************
 * Page Description	: [project description ... ] 
 * Imput Parameters	: [input parameter ...] 
 * Output 			: [output ...] 
 *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*,
                   com.dimata.aiso.entity.masterdata.DonorComponent,
                   com.dimata.aiso.form.masterdata.FrmDonorComponent,
                   com.dimata.aiso.form.masterdata.CtrlDonorComponent,
                   com.dimata.aiso.entity.masterdata.PstDonorComponent,
				   com.dimata.common.entity.contact.*,
				   com.dimata.common.form.contact.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>
<!--package posbo -->
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
public static final String mainTitle[] = {
	"Data Master","Master Data"
};

public static final String childTitle[] = {
	"Komponen Donor","Donor Component"
};

public static final String textListTitle[][] =
{
	{"Komponen Donor","Harus diisi"},
	{"Donor Component","required"}
};

public static final String textListHeader[][] =
{
	{"No","Kode","Nama Komponent", "Nama Donor", "Keterangan"},
	{"No","Code","Component Name", "Donor Name", "Description"}
};

public String drawList(Vector objectClass, long lDonorComponentId, int languange, int iCommand, FrmDonorComponent frmDonorComponent, int start,String approot)

{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(textListHeader[languange][0],"5%","left","center");
	ctrlist.dataFormat(textListHeader[languange][1],"10%","left","left");
	ctrlist.dataFormat(textListHeader[languange][2],"30%","left","left");
	ctrlist.dataFormat(textListHeader[languange][3],"15%","left","left");
	ctrlist.dataFormat(textListHeader[languange][4],"40%","left","left");

	ctrlist.setLinkRow(1);
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
    ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	Vector rowx = new Vector(1,1);
	String sContact = "";	
	String strDonorCompName = "";
	String strDonorCompDesc = "";

	/*FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSeparator); 
	frmHandler.setDigitSeparator(sUserDigitSeparator);*/

	for (int i = 0; i < objectClass.size(); i++){
		DonorComponent objDonorComponent = (DonorComponent)objectClass.get(i);
		rowx = new Vector();
		
		if(lDonorComponentId == objDonorComponent.getOID()){
			index = i;
		}
		ContactList objContact = new ContactList();
		try{
			objContact = PstContactList.fetchExc(objDonorComponent.getContactId());
			}catch(Exception e){
			
			}
		
		if(objDonorComponent.getName().length() > 30){
			strDonorCompName = (objDonorComponent.getName()).substring(0,30)+ "......";
		}else{
			strDonorCompName = objDonorComponent.getName();
		}
		
		if(objDonorComponent.getDescription().length() > 45){
			strDonorCompDesc = (objDonorComponent.getDescription()).substring(0,45) + "......";
		}else{
			strDonorCompDesc = objDonorComponent.getDescription();
		}
		
		String strContact = "";			
		strContact = objContact.getCompName();			
		if(strContact != null && strContact.length() > 0){				
			sContact = objContact.getCompName();			
		}else{			
			sContact = objContact.getPersonName();
		}
		
		if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
            rowx.add("<div align=\"center\">"+(i+start+1)+"</div>");
            rowx.add("<input size=\"10\" type=\"text\"  name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_CODE]+"\" value=\""+objDonorComponent.getCode()+"\">*)");
			rowx.add("<input size=\"15\" type=\"text\" name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_NAME]+"\" value=\""+objDonorComponent.getName()+"\">*)");				
            rowx.add("<input type=\"hidden\" name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_CONTACT_ID]+"\" value=\""+objDonorComponent.getContactId()+"\">"+
					"<input size=\"20\" type=\"text\" name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_CONTACT_ID]+"_TEXT\"  value=\""+sContact+"\">"+
					"<a href =\"javascript:cmdSeachContact()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>*)");  			
            rowx.add("<input size=\"60\" type=\"text\" name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_DESCRIPTION]+"\" value=\""+objDonorComponent.getDescription()+"\">*)");  			
			   
          }else{
		
			rowx.add("<div align=\"center\">"+(i+start+1)+"</div>");
			rowx.add(objDonorComponent.getCode());
			rowx.add(strDonorCompName);
			rowx.add(strContact);
			rowx.add(strDonorCompDesc);
		}
		
		lstData.add(rowx);
        lstLinkData.add(String.valueOf(objDonorComponent.getOID()));
	}
	
	rowx = new Vector();
	 if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmDonorComponent.errorSize()>0)){
         rowx.add("");
		 rowx.add("<input size=\"10\" type=\"text\"  name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_CODE]+"\" value=\"\">*)");
         rowx.add("<input size=\"15\" type=\"text\" name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_NAME]+"\" value=\"\">*)");         
         rowx.add("<input type=\"hidden\" name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_CONTACT_ID]+"\" value=\"\">"+
                 "<input size=\"20\" type=\"text\" name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_CONTACT_ID]+"_TEXT\" value=\"\">"+
				 "<a href =\"javascript:cmdSeachContact()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>*)");        
         rowx.add("<input size=\"60\" type=\"text\" name=\""+FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_DESCRIPTION]+"\" value=\"\">*)");
         lstData.add(rowx);
	 }

	return ctrlist.draw(-1);
}
%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidDonorComponent = FRMQueryString.requestLong(request, "hidden_donor_component_id");
String sCode = FRMQueryString.requestString(request, "code");
String sName = FRMQueryString.requestString(request, "name");
long lDonorId = FRMQueryString.requestLong(request, "donor_id");
String sDonorName = FRMQueryString.requestString(request, "donor_id_text");


boolean privManageData = true; 
int recordToGet = 22;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
if(sCode != null && sCode.length() > 0){
	whereClause += PstDonorComponent.fieldNames[PstDonorComponent.FLD_CODE]+" like '%"+sCode+"%'";
}
if(sName != null && sName.length() > 0){
	if(whereClause != null && whereClause.length() > 0){
		whereClause += " AND "+PstDonorComponent.fieldNames[PstDonorComponent.FLD_NAME]+" like '%"+sName+"%'";
	}else{
		whereClause += PstDonorComponent.fieldNames[PstDonorComponent.FLD_NAME]+" like '%"+sName+"%'";
	}
}
if(lDonorId != 0){
	if(whereClause != null && whereClause.length() > 0){
		whereClause += " AND "+PstDonorComponent.fieldNames[PstDonorComponent.FLD_CONTACT_ID]+" = "+lDonorId;
	}else{
		whereClause += PstDonorComponent.fieldNames[PstDonorComponent.FLD_CONTACT_ID]+" = "+lDonorId;
	}
}
String orderClause = PstDonorComponent.fieldNames[PstDonorComponent.FLD_CODE];
					 
					 
/**
* ControlLine and Commands caption
*/

ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = textListTitle[SESS_LANGUAGE][0];
String strMassageError[] = {"Data tidak ditemukan","Data not found"}; 
String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "Daftar");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String searchData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View Search Form" : "Cari Data";
String entryRequired = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Entry required" : "Mesti diisi";
String hideSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Hide Search Form" : "Sembunyikan Form Cari Data";
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
String strSearch[] = {"Tampilkan","Search"};
String strReset[] = {"Kosongkan","Reset"};					 

CtrlDonorComponent ctrlDonorComponent = new CtrlDonorComponent(request);
Vector listDonorComponent = new Vector(1,1);
ctrlDonorComponent.setLanguage(SESS_LANGUAGE);
FrmSrcContactList frmSrcContactList = new FrmSrcContactList();

iErrCode = ctrlDonorComponent.action(iCommand , oidDonorComponent);
FrmDonorComponent frmDonorComponent = ctrlDonorComponent.getForm();

int vectSize = PstDonorComponent.getCount(whereClause);
DonorComponent objDonorComponent = ctrlDonorComponent.getDonorComponent();
msgString =  ctrlDonorComponent.getMessage();

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlDonorComponent.actionList(iCommand, start, vectSize, recordToGet);
} 

listDonorComponent = PstDonorComponent.list(start,recordToGet, whereClause , orderClause);

if (listDonorComponent.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listDonorComponent = PstDonorComponent.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function cmdAdd(){
	document.frmdonorcomponent.hidden_donor_component_id.value="0";
	document.frmdonorcomponent.command.value="<%=Command.ADD%>";
	document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}

function cmdAsk(oidDonorComponent){
	document.frmdonorcomponent.hidden_donor_component_id.value=oidDonorComponent;
	document.frmdonorcomponent.command.value="<%=Command.ASK%>";
	document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}

function cmdConfirmDelete(oidDonorComponent){
	document.frmdonorcomponent.hidden_donor_component_id.value=oidDonorComponent;
	document.frmdonorcomponent.command.value="<%=Command.DELETE%>";
	document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}
function cmdSave(){
	document.frmdonorcomponent.command.value="<%=Command.SAVE%>";
	document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
	}

function cmdEdit(oidDonorComponent){
	document.frmdonorcomponent.hidden_donor_component_id.value=oidDonorComponent;
	document.frmdonorcomponent.command.value="<%=Command.EDIT%>";
	document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
	}

function cmdCancel(oidDonorComponent){
	document.frmdonorcomponent.hidden_donor_component_id.value=oidDonorComponent;
	document.frmdonorcomponent.command.value="<%=Command.EDIT%>";
	document.frmdonorcomponent.prev_command.value="<%=prevCommand%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}

function cmdBack(){
	document.frmdonorcomponent.command.value="<%=Command.BACK%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
	}

function cmdSearch(){
	document.frmdonorcomponent.command.value="<%=Command.LIST%>";	
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}	

function cmdopen(){
		var url = "contact_list.jsp?command=<%=Command.LIST%>&"+
				"<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_NAME] %>="+document.frmdonorcomponent.donor_id_text.value;
        window.open(url,"src_cnt_bank_dep_src","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
    }
	
	
	
function cmdListFirst(){
	document.frmdonorcomponent.command.value="<%=Command.FIRST%>";
	document.frmdonorcomponent.prev_command.value="<%=Command.FIRST%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}

function cmdListPrev(){
	document.frmdonorcomponent.command.value="<%=Command.PREV%>";
	document.frmdonorcomponent.prev_command.value="<%=Command.PREV%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
	}

function cmdListNext(){
	document.frmdonorcomponent.command.value="<%=Command.NEXT%>";
	document.frmdonorcomponent.prev_command.value="<%=Command.NEXT%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}

function cmdListLast(){
	document.frmdonorcomponent.command.value="<%=Command.LAST%>";
	document.frmdonorcomponent.prev_command.value="<%=Command.LAST%>";
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}

function cmdViewSearch(){
	document.frmdonorcomponent.command.value="<%=Command.REFRESH%>";	
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}

function cmdHideSearch(){
	document.frmdonorcomponent.command.value="<%=Command.NONE%>";	
	document.frmdonorcomponent.action="donor_component.jsp";
	document.frmdonorcomponent.submit();
}

function cmdReset(){
	document.frmdonorcomponent.code.value ="";
	document.frmdonorcomponent.name.value ="";	
	document.frmdonorcomponent.donor_id_text.value = "";
	document.frmdonorcomponent.donor_id.value = "";
}

function cmdSeachContact(){	
	var url = "donor_list.jsp?command=<%=Command.LIST%>&<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_NAME]%>="+document.frmdonorcomponent.<%=FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_CONTACT_ID]%>_TEXT.value+"";	
	window.open(url,"src_cnt_master_dnc","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");	
	
	}
	
	
//-------------- script control line -------------------
function MM_swapImgRestore() { //v3.0
	var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.0
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}//-->

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 



<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --> 
           <%=mainTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=textListTitle[SESS_LANGUAGE][0].toUpperCase()%></font> <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmdonorcomponent" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_donor_component_id" value="<%=oidDonorComponent%>">		  
			 
              <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3" valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<% int iCmd = Command.REFRESH;
					if(iCommand == Command.FIRST || iCommand == Command.PREV ||
					iCommand == Command.NEXT || iCommand == Command.LAST 
					|| iCommand == Command.EDIT || iCommand == Command.SAVE 
					|| iCommand == Command.DELETE || iCommand == Command.ASK || iCommand == Command.ADD
					|| iCommand == Command.BACK
					){
						iCmd = Command.NONE;
					}%>
					
					
					<%if(iCommand != Command.NONE){
						if(iCmd != Command.NONE){
					%>
                      <tr align="left" valign="top">
                        <td height="22" valign="middle" colspan="3">
						<!-- Start -->
						
						<table width="60%"  border="0">
                          <tr>
                            <td width="20%"><%=textListHeader[SESS_LANGUAGE][1]%></td>
                            <td width="8%"><div align="center"><strong>:</strong></div></td>
                            <td colspan="2"><input name="code" type="text" maxlength="10" value="<%=sCode%>"></td>
                          </tr>
                          <tr>
                            <td nowrap><%=textListHeader[SESS_LANGUAGE][2]%></td>
                            <td><div align="center"><strong>:</strong></div></td>
                            <td colspan="2"><input type="text" name="name" maxlength="50" size="50" value="<%=sName%>"></td>
                          </tr>
                          <tr>
                            <td><%=textListHeader[SESS_LANGUAGE][3]%></td>
                            <td><div align="center"><strong>:</strong></div></td>
                            <td colspan="2"><input name="donor_id_text" type="text" maxlength="10"><a href="javascript:cmdopen()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
								<input name="donor_id" type="hidden">
							</td>
                          </tr>
                          <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td width="13%"><input name="btnSearch" type="button" onClick="javascript:cmdSearch()" value="<%=strSearch[SESS_LANGUAGE]%>"></td>
                            <td width="59%"><input name="btnReset" type="button" onClick="javascript:cmdReset()" value="<%=strReset[SESS_LANGUAGE]%>"></td>
                          </tr>
                          <tr>
                            <td colspan="4">&nbsp;</td>
                            </tr>
                        </table>
						
						<!-- End Table -->
						</td>
                      </tr>
					  <%}
					  }%>
					  <tr><td align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
					  	  <%if(iCommand == Command.NONE){
						  %>
						  	<a href="javascript:cmdViewSearch()"><%=searchData%></a>
						  <%}else{
						  	if(iCmd == Command.NONE){
						  %>
						  	<a href="javascript:cmdViewSearch()"><%=searchData%></a>
						  <%}else{%>
						  	<a href="javascript:cmdHideSearch()"><%=hideSearch%></a>
						  <%}
						  }%>
						  </font>
					  </td></tr>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="2">&nbsp;&nbsp; 
						<%if(listDonorComponent != null && listDonorComponent.size() > 0){%>
							<%= drawList(listDonorComponent,oidDonorComponent,SESS_LANGUAGE,iCommand,frmDonorComponent, start,approot)%> 
                      	<%}%>
						</td>
					  </tr>
					  <%if(iCommand == Command.ADD || iCommand == Command.EDIT){%>
					  <tr><td class="msgbalance">&nbsp;&nbsp;&nbsp;*)&nbsp;<%=entryRequired%></td></tr>
					  <%}%>
                      <tr align="left" valign="top"> 
                        <td height="8" align="left" colspan="3" class="command">&nbsp;&nbsp;				 
                          <span class="command"> 
                          <% 
						   int cmd = 0;
							   if ((iCommand == Command.FIRST || iCommand == Command.PREV )|| 
								(iCommand == Command.NEXT || iCommand == Command.LAST))
									cmd =iCommand; 
						   else{
							  if(iCommand == Command.NONE || prevCommand == Command.NONE)
								cmd = Command.FIRST;
							  else 
								cmd =prevCommand; 
						   } 
						  %>  
						  <%ctrLine.initDefault(SESS_LANGUAGE,"");%>
						  <%if(vectSize > 0){%>                        
                          	<%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> </span> 
							
							</td>
                      	<%}else{%>
					  </tr>
					  
					  <tr>
					  	<td class="msgerror">
							<%=strMassageError[SESS_LANGUAGE]%>
						</td>
						<%}%>
					  </tr> 
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="8" colspan="3"> 				  
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">                      
                      <tr align="left" valign="top" >
                        <td colspan="5" class="command">&nbsp;</td>
                      </tr>
                      <tr align="left" valign="top" >
                        <td colspan="5" class="command"><%if(privAdd && privManageData){%>
                          <%if(iCommand==Command.NONE||iCommand==Command.FIRST||iCommand==Command.PREV||iCommand==Command.NEXT||iCommand==Command.LAST||iCommand==Command.BACK||iCommand==Command.DELETE||iCommand==Command.SAVE){%>
                          <a href="javascript:cmdAdd()"><%//=ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_ADD,true)%></a>
                          <%}}%>
                          <%											  
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidDonorComponent+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidDonorComponent+"')";
							String scancel = "javascript:cmdEdit('"+oidDonorComponent+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);
							ctrLine.setAddCaption(strAddMar);															
							ctrLine.setBackCaption("");														
							ctrLine.setSaveCaption(strSaveMar);
							ctrLine.setDeleteCaption(strAskMar);
							ctrLine.setConfirmDelCaption(strDeleteMar);
							
							if(commandBack.equalsIgnoreCase("Y")){
								ctrLine.setBackCaption(strBackMar);
							}
							
							if (privDelete){
								ctrLine.setConfirmDelCommand(sconDelCom);
								ctrLine.setDeleteCommand(scomDel);
								ctrLine.setEditCommand(scancel);
							}else{ 
								ctrLine.setConfirmDelCaption("");
								ctrLine.setDeleteCaption("");
								ctrLine.setEditCaption("");
							}
		
							if(privAdd == false  && privUpdate == false){
								ctrLine.setSaveCaption("");
							}
		
							if (privAdd == false){
								ctrLine.setAddCaption("");
							}
							
							if(iCommand == Command.ASK)
							{
								ctrLine.setDeleteQuestion(delConfirm); 
							}
							if(iCommand == Command.SAVE || iCommand == Command.DELETE){
								ctrLine.setBackCaption("");
								ctrLine.setAddCaption(strAddMar);
							}
							if(iCommand == Command.REFRESH){
								ctrLine.setAddCaption(strAddMar);
							}
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							%></td>
                      </tr>
                      <tr align="left" valign="top" > 
                        <td colspan="5" class="command">&nbsp;&nbsp; 
						</td>
                      </tr>
                    </table>
                    <%//}%>
                  </td>
                </tr>
              </table>
            </form>
           		
            <script language="javascript">
				 <%
			if(iCommand==Command.LIST)
			{
			%>	
				//document.frmdonorcomponent.<%=FrmDonorComponent.fieldNames[FrmDonorComponent.FRM_CODE]%>.focus();
				cmdHideSearch();
			<%
			}
			%>
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
