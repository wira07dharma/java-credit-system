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
                   com.dimata.aiso.entity.masterdata.ActivityAccountLink,
                   com.dimata.aiso.form.masterdata.FrmActivityAccountLink,
                   com.dimata.aiso.form.masterdata.CtrlActivityAccountLink,
                   com.dimata.aiso.entity.masterdata.PstActivityAccountLink,
				   com.dimata.aiso.entity.masterdata.Activity,
				   com.dimata.aiso.entity.masterdata.PstActivity,
				   com.dimata.aiso.entity.masterdata.Perkiraan,
				   com.dimata.interfaces.chartofaccount.*,
				   com.dimata.aiso.entity.masterdata.PstPerkiraan"
				    %>
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
	"Aktivitas","Activity"
};

public static final String textListTitle[][] =
{
	{"Link ke Perkiraan","Harus diisi","Add","Edit"},
	{"Link to Account Chart","required","Add","Edit"}
};

public static final String strCommand[] = {
	"Link Aktivitas","Activity Link"
};

public static final String strErrorLink[] = {
	"Aktivitas tidak bisa di link ke Komponen Donor, karena bukan Level Activity atau Activity belum di entry!!!",
	"Activity can not link to Donor Component. This activity is not Activity Level or Activity not yet Entry !!!"
};

public static final String textListHeader[][] =
{
	{"No","No. Pekiraan","Nama Perkiraan"},
	{"No","Account Number","Account Name"}
};

public static final String strTitleHeader[][] = {
	{"Kode","Level","Keterangan","Induk Aktvitas"},
	{"Code","Level","Description","Activty Parent"}
};

public static final String[] strLevel = {
	"Module","Sub Module","Header","Activity"
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

public String drawList(Vector objectClass, long lActAccLinkId, long lActivityId, int languange, int iCommand, FrmActivityAccountLink frmActivityAccountLink, int start, String approot)

{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");	
	ctrlist.dataFormat(getJspTitle(textListHeader,0,languange,"",false),"5%","left","center");
	ctrlist.dataFormat(getJspTitle(textListHeader,1,languange,"",false),"25%","left","center");
	ctrlist.dataFormat(getJspTitle(textListHeader,2,languange,"",false),"70%","left","center");
	

	ctrlist.setLinkRow(1);
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
    ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	Vector rowx = new Vector(1,1);
	String strAccNo = "";
	String strAccName = "";
	long lAccountId = 0;
	Perkiraan objPerkiraan = new Perkiraan();

	for (int i = 0; i < objectClass.size(); i++){
		ActivityAccountLink objActivityAccountLink = (ActivityAccountLink)objectClass.get(i);
		rowx = new Vector();
		
		if(lActAccLinkId == objActivityAccountLink.getOID()){
			index = i;
		}		
		
		lAccountId = objActivityAccountLink.getIdPerkiraan();		
		
		if(lAccountId > 0){
			try{
				objPerkiraan = PstPerkiraan.fetchExc(lAccountId);
			}catch(Exception e){
				System.out.println("Error pada saat fetch Perkiraan ==> "+e.toString());
			}			
		}
		
		strAccNo = objPerkiraan.getNoPerkiraan();
		
		if(languange == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			strAccName = objPerkiraan.getAccountNameEnglish();
		}else{
			strAccName = objPerkiraan.getNama();
		}
				
	
		
		if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
            rowx.add("<div align=\"center\">"+(i+start+1)+"</div>");
            rowx.add("<input type=\"hidden\" name=\""+FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACTIVITY_ID]+"\" value=\""+lActivityId+"\">"+
					"<input type=\"hidden\" name=\""+FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACCOUNT_ID]+"\" value=\""+lAccountId+"\">"+
					"<input size=\"20\" type=\"text\" name=\""+FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACCOUNT_ID]+"_TEXT\"  value=\""+strAccNo+"\">"+					
					"<a href =\"javascript:cmdSeachAccount()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");  			
            rowx.add("<input size=\"40\" type=\"text\" onKeyDown=\"javascript:enterTrapName()\" name=\"acc_name\" value=\""+strAccName+"\">");  			
			   
          }else{
		
			rowx.add("<div align=\"center\">"+(i+start+1)+"</div>");
			rowx.add(strAccNo);
			rowx.add(strAccName);
			
		}
		
		lstData.add(rowx);
        lstLinkData.add(String.valueOf(objActivityAccountLink.getOID()));
	}
	
	rowx = new Vector();
	 if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmActivityAccountLink.errorSize()>0)){
         rowx.add("");		         
         rowx.add("<input type=\"hidden\" name=\""+FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACTIVITY_ID]+"\" value=\"\">"+
		 		"<input type=\"hidden\" name=\""+FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACCOUNT_ID]+"\" value=\"\">"+
                 "<input size=\"20\" type=\"text\" onKeyDown=\"javascript:enterTrapCode()\" name=\""+FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACCOUNT_ID]+"_TEXT\" value=\"\">"+				
				 "<a href =\"javascript:cmdSeachAccount()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>*");				    
         rowx.add("<input size=\"40\" type=\"text\" onKeyDown=\"javascript:enterTrapName()\" name=\"acc_name\">*");
         lstData.add(rowx);
	 }

	return ctrlist.draw(-1);
}
%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidActAccLink = FRMQueryString.requestLong(request, "hidden_act_acc_link_id");
long oidActivity = FRMQueryString.requestLong(request, "hidden_activity_id");
long oidAccount = FRMQueryString.requestLong(request, FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACCOUNT_ID]);


boolean privManageData = true; 
int recordToGet = 20;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

String strActivityId = "";

strActivityId = (String)session.getValue("ACTIVITY_ID");
					


if(strActivityId != null && strActivityId.length() > 0){
oidActivity = Long.parseLong(strActivityId);	
}

whereClause = PstActivityAccountLink.fieldNames[PstActivityAccountLink.FLD_ACTIVITY_ID] +" = "+strActivityId;					 
/**
* ControlLine and Commands caption
*/

ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String strPageCommand = strCommand[SESS_LANGUAGE];
String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_ADD,true);
String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_SAVE,true);
String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_ASK,true);
String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_DELETE,true);
String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "Daftar");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+strPageCommand+" ?";
			 

CtrlActivityAccountLink ctrlActivityAccountLink = new CtrlActivityAccountLink(request);
ctrlActivityAccountLink.setLanguage(SESS_LANGUAGE);
Vector listActivityAccountLink = new Vector(1,1);

FrmSrcContactList frmSrcContactList = new FrmSrcContactList();

iErrCode = ctrlActivityAccountLink.action(iCommand , oidActAccLink, oidActivity);
FrmActivityAccountLink frmActivityAccountLink = ctrlActivityAccountLink.getForm();

Activity objActivity = new Activity();
	try{
		objActivity = PstActivity.fetchExc(oidActivity);
	}catch(Exception e){
		objActivity = new Activity();
	}
	
Activity objParentActivity = new Activity();
	try{
		objParentActivity = PstActivity.fetchExc(objActivity.getIdParent());
	}catch(Exception e){
		objParentActivity = new Activity();
	}
	
int vectSize = PstActivityAccountLink.getCount(whereClause);
ActivityAccountLink objActivityAccountLink = ctrlActivityAccountLink.getActivityAccountLink();
msgString =  ctrlActivityAccountLink.getMessage();
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlActivityAccountLink.actionList(iCommand, start, vectSize, recordToGet);
} 

listActivityAccountLink = PstActivityAccountLink.list(start,recordToGet, whereClause , orderClause);

if (listActivityAccountLink.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listActivityAccountLink = PstActivityAccountLink.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function refresh(){ 
	window.location.reload( false ); 
	}
	
function cmdAdd(){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.hidden_act_acc_link_id.value="0";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.ADD%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
}

function cmdAsk(oidActAccLink){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.hidden_act_acc_link_id.value=oidActAccLink;
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.ASK%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
}

function cmdConfirmDelete(oidActAccLink){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.hidden_act_acc_link_id.value=oidActAccLink;
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
}
function cmdSave(){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
	parent.frames[1].refresh();
	}

function cmdEdit(oidActAccLink){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.hidden_act_acc_link_id.value=oidActAccLink;
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
	}

function cmdCancel(oidActAccLink){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.hidden_act_acc_link_id.value=oidActAccLink;
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
}

function cmdBack(){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.BACK%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
	}

function cmdListFirst(){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=Command.FIRST%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
}
function cmdList(){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.LIST%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=Command.FIRST%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
}

function cmdListPrev(){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.PREV%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=Command.PREV%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
	}

function cmdListNext(){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=Command.NEXT%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
}

function cmdListLast(){
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.command.value="<%=Command.LAST%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.prev_command.value="<%=Command.LAST%>";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.action="act_acc_link.jsp";
	document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.submit();
}

function cmdSeachAccount(){	
	var url = "list_coa.jsp?command=<%=Command.LIST%>&"+
			  "account_group="+document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.acc_group.value+"&"+
			  "account_number="+document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.<%=FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACCOUNT_ID]%>_TEXT.value+"";	
	window.open(url,"src_cnt_acc_link","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");	
	
	}
	
function enterTrapCode(){
	if(event.keyCode == 13){
		cmdSeachAccount();
	}
}

function enterTrapName(){
	if(event.keyCode == 13){
		cmdSave();
	}
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
<link rel="stylesheet" href="../../style/tab.css" type="text/css">
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
           <%=childTitle[SESS_LANGUAGE]%> : 
		   <font color="#CC3300"><%=oidActAccLink != 0? textListTitle[SESS_LANGUAGE][3].toUpperCase() : textListTitle[SESS_LANGUAGE][2].toUpperCase()%>
		   &nbsp;<%=textListTitle[SESS_LANGUAGE][0].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
			  <input type="hidden" name="acc_group" value="<%=I_ChartOfAccountGroup.ACC_GROUP_EXPENSE%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_act_acc_link_id" value="<%=oidActAccLink%>">
			  <input type="hidden" name="<%=FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACTIVITY_ID]%>" value="<%=oidActivity%>">		  
			 
              <table width="100%" border="0" cellspacing="0" cellpadding="0"> <!-- tbl 1 -->
			  	<tr><td>&nbsp;</td></tr>			  
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3" valign="top"> 
				  	<table width="100%" border="0" cellspacing="0" cellpadding="0"> <!-- tbl 2.1 -->
				  		<tr>
				  			<td colspan="3">
								<table width="100%" border="0" cellpadding="0" cellspacing="0"><!-- tbl 3.1 -->
									<tr>
										<td width="1%">&nbsp;</td>
										<td colspan="2"> 
                    						<table width="60%" border="0" cellspacing="0" cellpadding="0"><!-- tbl 4.1 --> 
                      							<tr> 
                        							<td> 
                          								<table width="100%" border="0" cellpadding="0" cellspacing="0"><!-- tbl 5.1 -->
                            								<tr> 
                              									<td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
                              									<td valign="middle" background="<%=approot%>/images/tab/inactive_bg.jpg"> 
																		<div align="center" class="tablink"><a href="<%=approot%>/masterdata/activity/activity_edit.jsp?activity_id=<%=oidActivity%>&command=<%=Command.EDIT%>" class="tablink"><span class="tablink">Activity</span></a></div>
																	  </td>
                              									<td width="12"   valign="top" align="right"><img src="<%=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
                            									<td>&nbsp;</td>
															</tr>
                          								</table><!-- end tbl 5.1 -->
                        							</td>
                        							<td> 
                          								<table width="100%" border="0" cellpadding="0" cellspacing="0"><!-- tbl 5.2 -->
                            								<tr> 
                              									<td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/active_left.jpg" width="12" height="29"></td>
                              									<td valign="middle" background="<%=approot%>/images/tab/active_bg.jpg" > 
                                           							 <div align="center" class="tablink"><span class="tablink">Account 
                                              						Link</span></div>
                              									</td>
                              									<td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/active_right.jpg" width="12" height="29"></td>
                            									<td>&nbsp;</td>
															</tr>
                          								</table><!-- end tbl 5.2 -->
                        							</td>
                        							<td> 
                          								<table width="100%" border="0" cellpadding="0" cellspacing="0"><!-- tbl 5.3 -->
                            								<tr> 
                              									<td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
                              									<td valign="middle" background="<%=approot%>/images/tab/inactive_bg.jpg" > 
                                									<div align="center" class="tablink"><a href="<%=approot%>/masterdata/activity/act_prd_link.jsp?hidden_activity_id=<%=oidActivity%>" class="tablink"><span class="tablink">Period 
                                  									Link</span></a></div>
                              									</td>
                              									<td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
                            									<td>&nbsp;</td>
															</tr>
                          								</table><!-- end tbl 5.3 -->
                        							</td>
                        							<td> 
														<!-- tbl 5.4 
                          								<table width="100%" border="0" cellpadding="0" cellspacing="0">
                            								<tr> 
                              									<td valign="top" align="left" width="12"><img src="<%//=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
                              									<td valign="middle" background="<%//=approot%>/images/tab/inactive_bg.jpg"> 
                                									<div align="center" class="tablink"><a href="<%//=approot%>/masterdata/activity/act_dnc_link.jsp?hidden_activity_id=<%//=oidActivity%>" class="tablink"><span class="tablink">Donor 
                                  									Comp Link</span></a></div>
                              									</td>
                              									<td valign="top" align="left" width="10"><img src="<%//=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
                            								</tr>
                          								</table><!-- end tbl 5.4 -->
                        							</td>
                      							</tr>
                    						</table><!-- end tbl 4.1 -->
                  						</td>                
									</tr>
								</table><!-- end tbl 3.1 -->
							</td>
				  		</tr>
				  		<tr>							     
				  			<td width="1%">				  
                    			<!-- end tbl 3.2 --> 
                  
				  </td>
				  			<td bgcolor="#B6CDFB"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="listgenactivity"><!-- tbl 3.2 -->
							
                      				<tr align="left" valign="top"> 
                        				<td height="8" valign="middle" colspan="3"><%if(strActivityId != null && strActivityId.length() > 0){%>                  
                        				</td>
                      				</tr>
									<tr>
										<td><table width="100%"><tr>
										<td width="1%">&nbsp;</td>
										<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][0]%></td>
										<td width="1%">:</td>
										<td width="88%"><%=objActivity.getCode()%></td>
									</tr>
									<tr>
										<td width="1%">&nbsp;</td>
										<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][1]%></td>
										<td width="1%">:</td>
										<td width="88%"><%=strLevel[objActivity.getActLevel()]%></td>										
									</tr>
									<tr>
										<td width="1%">&nbsp;</td>
										<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][2]%></td>
										<td width="1%">:</td>
										<td width="88%"><%=objActivity.getDescription()%></td>
										</tr>
									<tr>
										<td td width="1%">&nbsp;</td>
										<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][3]%></td>
										<td td width="1%">:</td>
										<td width="88%"><%=objParentActivity.getDescription()%></td>
										</tr>
										</table>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr><td><table class="msgbalance">
									  <tr><td>&nbsp;&nbsp;&nbsp;*) Entry Requiered</td></tr></table></td></tr>														   
                      				<tr align="left" valign="top">
									<td>									  <table width="100%">
									  <!-- start table for list -->
                                      <tr>
                                        <td td width="1%">&nbsp;</td>
                                        <td colspan="3"> <%= drawList(listActivityAccountLink,oidActAccLink,oidActivity,SESS_LANGUAGE,iCommand,frmActivityAccountLink,start,approot)%> </td>
                                      </tr>
                                      <tr>
                                        <td>&nbsp;</td>
                                        <td height="8" align="left" colspan="3" class="command">
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
                                          <% ctrLine.initDefault(SESS_LANGUAGE,"");%>
                                          <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> </td>
                                      </tr>                                      
                                      <tr align="left" valign="top">
                                        <td>&nbsp;</td>
                                        <td height="22" valign="middle" colspan="3">
                                          <!-- table width="40%" border="0" cellspacing="0" cellpadding="0">
                                            <!-- tbl 4.2 -->
                                            <!-- tr>
                                              <td width="100%" nowrap class="command">
                                                <%if(privAdd && privManageData){%>
                                                <%if(iCommand==Command.NONE||iCommand==Command.FIRST||iCommand==Command.PREV||iCommand==Command.NEXT||iCommand==Command.LAST||iCommand==Command.BACK||iCommand==Command.DELETE||iCommand==Command.SAVE){%>
                                                <!-- a href="javascript:cmdAdd()"><%//=strAddMar%></a -->
                                                <%}}%>
                                              <!-- /td>
                                            </tr>                                            
                                          </table>
                                          <!-- end tbl 4.2 -->
                                        </td>
                                      </tr>                                      
                                      <tr align="left" valign="top" >
                                        <td>&nbsp;</td>
                                        <td colspan="5" class="command">
                                          <%											  
														ctrLine.initDefault();
														ctrLine.setTableWidth("80%");
														String scomDel = "javascript:cmdAsk('"+oidActAccLink+"')";
														String sconDelCom = "javascript:cmdConfirmDelete('"+oidActAccLink+"')";
														String scancel = "javascript:cmdEdit('"+oidActAccLink+"')";
														ctrLine.setCommandStyle("command");
														ctrLine.setColCommStyle("command");
														ctrLine.setCancelCaption(strCancel);														
														ctrLine.setAddCaption(strAddMar);	
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
														if(iCommand == Command.SAVE || iCommand == Command.DELETE){
															ctrLine.setBackCaption("");
															ctrLine.setAddCaption(strAddMar);
														}
														out.println(ctrLine.draw(iCommand, iErrCode, msgString));
														%>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>
                                          <%}else{%>
                                          <em><font color="FF0000" face="Verdana, Arial, Helvetica, sans-serif"><%=strErrorLink[SESS_LANGUAGE]%></font></em>
                                          <%}%>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td>&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td>&nbsp;</td>
                                      </tr>
                                    </table></td>
								</tr>
                  			</table>
						</td>
				  		<td width="1%">&nbsp;</td>
		  		    </tr>
				</table>				  	
              </td>
            </tr>
          </table>
        </form>
            <%
			if(iCommand==Command.ADD || iCommand==Command.EDIT)
			{
			%>			
            <script language="javascript">
				document.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.<%=FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACCOUNT_ID]%>_TEXT.focus();
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
