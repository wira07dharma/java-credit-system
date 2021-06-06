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
                   com.dimata.aiso.entity.masterdata.AktivaLocation,
                   com.dimata.aiso.form.masterdata.FrmAktivaLocation,
                   com.dimata.aiso.form.masterdata.CtrlAktivaLocation,
                   com.dimata.aiso.entity.masterdata.PstAktivaLocation" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package posbo -->
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
public static final String textListTitle[][] =
{
	{"Lokasi Inventaris","Harus diisi"},
	{"Fixed Assets Location","Required"}
};

public static final String textListHeader[][] =
{
	{"Kode","Nama Lokasi"},
	{"Code","Location Name"}
};

public String drawList(Vector objectClass, int language)

{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("50%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader(textListHeader[language][0],"5%");
	ctrlist.addHeader(textListHeader[language][1],"15%");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
    ctrlist.setLinkSufix("')");
	ctrlist.reset();

	for (int i = 0; i < objectClass.size(); i++){
		AktivaLocation objAktivaLocation = (AktivaLocation)objectClass.get(i);
		Vector rowx = new Vector();
		
		rowx.add(objAktivaLocation.getAktivaLocCode());
		rowx.add(objAktivaLocation.getAktivaLocName());

		lstData.add(rowx);
        lstLinkData.add(String.valueOf(objAktivaLocation.getOID()));
	}

	return ctrlist.draw();
}
%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidAktivaLocation = FRMQueryString.requestLong(request, "aktiva_location_id");

boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = PstAktivaLocation.fieldNames[PstAktivaLocation.FLD_AKTIVA_LOC_CODE];
					 
					 
/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = textListTitle[SESS_LANGUAGE][0];
String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
					 

CtrlAktivaLocation ctrlAktivaLocation = new CtrlAktivaLocation(request);
Vector listAktivaLocation = new Vector(1,1);

iErrCode = ctrlAktivaLocation.action(iCommand , oidAktivaLocation);
FrmAktivaLocation frmAktivaLocation = ctrlAktivaLocation.getForm();

int vectSize = PstAktivaLocation.getCount(whereClause);
AktivaLocation objAktivaLocation = ctrlAktivaLocation.getAktivaLocation();
msgString =  ctrlAktivaLocation.getMessage();

FRMHandler frmHandler = new FRMHandler();
frmHandler.setDecimalSeparator(","); 
frmHandler.setDigitSeparator("."); 

//if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
//	start = PstAktivaGroup.findLimitStart(aktiva.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlAktivaLocation.actionList(iCommand, start, vectSize, recordToGet);
} 

listAktivaLocation = PstAktivaLocation.list(start,recordToGet, whereClause , orderClause);

if (listAktivaLocation.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listAktivaLocation = PstAktivaLocation.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function cmdAdd(){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.aktiva_location_id.value="0";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.ADD%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
}

function cmdAsk(oidAktivaLocation){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.aktiva_location_id.value=oidAktivaLocation;
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.ASK%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
}

function cmdConfirmDelete(oidAktivaLocation){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.aktiva_location_id.value=oidAktivaLocation;
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
}

function cmdSave(){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
	}

function cmdEdit(oidAktivaLocation){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.aktiva_location_id.value=oidAktivaLocation;
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
	}

function cmdCancel(oidAktivaLocation){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.aktiva_location_id.value=oidAktivaLocation;
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
}

function cmdBack(){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.BACK%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
	}

function cmdListFirst(){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=Command.FIRST%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
}

function cmdListPrev(){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.PREV%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=Command.PREV%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
	}

function cmdListNext(){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=Command.NEXT%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
}

function cmdListLast(){
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.command.value="<%=Command.LAST%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.prev_command.value="<%=Command.LAST%>";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.action="aktiva_location.jsp";
	document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.submit();
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
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
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
            Master Data : <font color="#CC3300"><%=textListTitle[SESS_LANGUAGE][0].toUpperCase()%></font> <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="aktiva_location_id" value="<%=oidAktivaLocation%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3" valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3">&nbsp; 
                        </td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(listAktivaLocation, SESS_LANGUAGE)%> </td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="8" align="left" colspan="3" class="command"> 
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
                          <% ctrLine.setLocationImg(approot+"/images");
							   	ctrLine.initDefault();
								 %>
                          <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> </span> </td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
                          <table width="20%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <%if(privAdd && privManageData){%>
                              <%if(iCommand==Command.NONE||iCommand==Command.FIRST||iCommand==Command.PREV||iCommand==Command.NEXT||iCommand==Command.LAST||iCommand==Command.BACK||iCommand==Command.SAVE||iCommand==Command.DELETE){%>
                              <td width="100%" nowrap class="command"><a href="javascript:cmdAdd()"><%=ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_ADD,true)%></a></td>
                              <%}}%>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="8" colspan="3"> 
                    <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmAktivaLocation.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="21" valign="middle" width="10%">&nbsp;</td>
                        <td height="21" valign="middle" width="1%">&nbsp;</td>
                        <td height="21" colspan="2" class="comment">*)= <%=textListTitle[SESS_LANGUAGE][1]%> </td>
                      </tr>
                      <tr align="left" valign="top">
                        <td height="21" valign="top" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][0]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"> 
                          <input type="text" name="<%=frmAktivaLocation.fieldNames[frmAktivaLocation.FRM_AKTIVA_LOC_CODE] %>"  value="<%=objAktivaLocation.getAktivaLocCode()%>">
                          * <%= frmAktivaLocation.getErrorMsg(frmAktivaLocation.FRM_AKTIVA_LOC_CODE) %>
                      <tr align="left" valign="top">
                        <td height="21" valign="top" width="10%" nowrap>&nbsp;<%=textListHeader[SESS_LANGUAGE][1]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2">
                          <input type="text" name="<%=frmAktivaLocation.fieldNames[frmAktivaLocation.FRM_AKTIVA_LOC_NAME] %>"  value="<%=objAktivaLocation.getAktivaLocName()%>">
                          * <%= frmAktivaLocation.getErrorMsg(frmAktivaLocation.FRM_AKTIVA_LOC_NAME) %>
                      <tr align="left" valign="top" >
                        <td colspan="5" class="command">&nbsp;</td>
                      </tr>
                      <tr align="left" valign="top" > 
                        <td colspan="5" class="command"> 
                          <%
							ctrLine.setLocationImg(approot+"/images");						  
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidAktivaLocation+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidAktivaLocation+"')";
							String scancel = "javascript:cmdEdit('"+oidAktivaLocation+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);														
							ctrLine.setBackCaption(strBackMar);														
							ctrLine.setSaveCaption(strSaveMar);
							ctrLine.setDeleteCaption(strAskMar);
							ctrLine.setConfirmDelCaption(strDeleteMar);
		
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
							
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							%>
                        </td>
                      </tr>
                    </table>
                    <%}%>
                  </td>
                </tr>
              </table>
            </form>
            <%
			if(iCommand==Command.ADD || iCommand==Command.EDIT)
			{
			%>
            <script language="javascript">
				document.<%=FrmAktivaLocation.FRM_AKTIVA_LOCATION%>.<%=FrmAktivaLocation.fieldNames[FrmAktivaLocation.FRM_AKTIVA_LOC_CODE]%>.focus();
			</script>
            <%
			}
			%>
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
