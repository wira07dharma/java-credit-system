<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>

<!--package java-->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!--package qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- use harisma class -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_ACCOUNT_CART, AppObjInfo.OBJ_MASTERDATA_ACCOUNT_CART); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if (!privAdd && !privUpdate && !privDelete) 
{
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
// this constant used to list text of listHeader 
public static final String textJspTitle[][] = 
{
	{
		"No.",
		"Kode",		
		"Keterangan",
		"Level",
		"Induk",
		"Status",
		"Tipe",
		"Outputs and deliverables",
		"Performance indicator",
		"Assumptions and risks",
		"Cost implication",
		"Add",
		"Edit"
	},
	{
		"No.",
		"Code",	
		"Description",
		"Level",
		"Parent",
		"Postable",
		"Type",
		"Outputs and deliverables",
		"Performance indicator",
		"Assumptions and risks",
		"Cost implication",
		"Add",
		"Edit"
	}	
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

public static final String pageTitle[] = 
{
	"Aktivitas","Activity"	
};



public String drawList(Vector objectClass, long oid, int language)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(getJspTitle(textJspTitle,0,language,"",false),"5%","left","center");
	ctrlist.dataFormat(getJspTitle(textJspTitle,1,language,"",false),"10%","left","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,2,language,"",false),"33%","left","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,3,language,"",false),"5%","left","center");
	ctrlist.dataFormat(getJspTitle(textJspTitle,4,language,"",false),"32%","left","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,5,language,"",false),"5%","left","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,6,language,"",false),"10%","left","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,7,language,"",false),"30%","left","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,8,language,"",false),"30%","left","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,9,language,"",false),"25%","left","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,10,language,"",false),"15%","left","left");

	ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");
	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
    String psn = ""; 
	int lvl = 0;
	String strLvl = "";
	String link = "";
	String closeLink ="";
	String strActivity = "";
	String strStatus = "";
	String strType = "";
	String strParentName = "";
	String strLevel = "";
	int iStatus = 0;
	int iType = 0;
	int index = -1;
	try 
	{ 								
		for (int i = 0; i < objectClass.size(); i++) 
		{
			 Activity objActivity = (Activity)objectClass.get(i);
			 
			 if(oid==objActivity.getOID())
			 {
			 	index =i;
			 }
			 
			 Activity oActivity = new Activity();
			 long idParent = objActivity.getIdParent();
			 
			 try{
			 	oActivity = PstActivity.fetchExc(idParent);
				}catch(Exception e){
					System.out.println("Erorr pada saat object activity ===> "+e.toString());
				}
			 
			 strStatus = PstActivity.actPosted[objActivity.getPosted()];
			 strType = PstActivity.actAssign[objActivity.getType()];
			 strLevel = PstActivity.actLevel[objActivity.getActLevel()];
			 			 
			 strParentName = oActivity.getDescription();
			
			 if(strParentName == null){
			 	strParentName = "Module Level (No Parent)";
			 }

			 Vector rowx = new Vector();
			
			 link ="<a href=\"javascript:cmdEdit('"+String.valueOf(objActivity.getOID())+"')\">";
			 closeLink = "</a>";			
			  
			 rowx.add(""+(i+1));
			 rowx.add(link+objActivity.getCode()+closeLink);  		 
			 rowx.add(objActivity.getDescription()); 
			 rowx.add(strLevel); 
			 rowx.add(strParentName);
			 rowx.add(strStatus);
			 rowx.add(strType);
			 rowx.add(objActivity.getOutPutandDelv());
			 rowx.add(objActivity.getPerfmIndict());
			 rowx.add(objActivity.getAssumpAndRisk());
			 rowx.add(objActivity.getCostImpl());

			 lstData.add(rowx);
		}
	} 
	catch(Exception exc) 
	{
		System.out.println("Exc when drawList : " + exc.toString());
	}
	return ctrlist.drawMe(index); 
}
%>

<%
// get request from hidden text
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidActivity = FRMQueryString.requestLong(request,"activity_id");

boolean privManageData = true; 



int recordToGet = 17;

// Setup controlLine and Commands caption
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = pageTitle[SESS_LANGUAGE];
String strAddAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strListAct = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List " : "Daftar ")+currPageTitle;
String strSaveAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strBackAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strDeleteAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
String strHeader = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "LIST " : "DAFTAR ");
String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
String strNoAccSelected = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) ? "- No Activity Reference -" : "- Tidak ada aktivifitas referensi -";
String strNote = (SESS_LANGUAGE == 1) ? "Entry required" : "Harus diisi";
String strConfSave = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) ? "Data is saved" : "Data telah tersimpan";

String strMassage = "";
// Manage controlList and Action process
Control controlList = new Control();
CtrlActivity ctrlActivity = new CtrlActivity(request); 
ctrlActivity.setLanguage(SESS_LANGUAGE);

ctrlActivity.setLanguage(SESS_LANGUAGE);
int ctrlErr = ctrlActivity.action(iCommand, oidActivity); 
strMassage = ctrlActivity.getMessage(); 
FrmActivity frmActivity = ctrlActivity.getForm();
Activity objActivity = ctrlActivity.getActivity(); 
oidActivity = objActivity.getOID();

String strActivityId = String.valueOf(oidActivity);
if(session.getValue("ACTIVITY_ID") != null){
	session.removeValue("ACTIVITY_ID");
	}
if(objActivity.getActLevel() == PstActivity.LEVEL_ACTIVITY){	
		session.putValue("ACTIVITY_ID", strActivityId);
		}						


// get list of department object
String strWhere = "";
String strOrder = "";

// Proses list account chart ...
Vector vectActivity = new Vector(); 
Vector vActivity = new Vector(); 

int vectSize = PstActivity.getCount(strWhere); 

if((iCommand == Command.FIRST || iCommand == Command.PREV )||  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlActivity.actionList(iCommand, start, vectSize, recordToGet);
}

if (vectActivity.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 vectActivity = PstActivity.list(start,recordToGet, strWhere , strOrder);
}

  Vector actCodeKey = new Vector(1,1);
  Vector actOptionStyle = new Vector(1,1);
  Vector actCodeVal = new Vector(1,1);
  String strSelect = String.valueOf(objActivity.getIdParent());	
  String style = "";																  

  Vector listCode = new Vector(1,1);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<%
if((privAdd)&&(privUpdate)&&(privDelete))
{
%>
function addNew(){
	document.frmactivity.activity_id.value="0";
	document.frmactivity.command.value="<%=Command.ADD%>";	
	document.frmactivity.action="activity_edit.jsp#down";	
	document.frmactivity.submit();	
}


function cmdSave()
{	
	document.frmactivity.command.value="<%=Command.SAVE%>";
	document.frmactivity.action = "activity_edit.jsp";	
	document.frmactivity.submit();	
	parent.frames[2].refresh();
}

function cmdAsk(oid){
	document.frmactivity.activity_id.value=oid;
	document.frmactivity.command.value="<%=Command.ASK%>";
	document.frmactivity.action="activity_edit.jsp";
	document.frmactivity.submit();
}

function cmdDelete(oid){
	document.frmactivity.activity_id.value=oid;
	document.frmactivity.command.value="<%=Command.DELETE%>";
	document.frmactivity.action="activity_edit.jsp";
	document.frmactivity.submit();
}
<%
}
%>



function cmdCancel(){
	document.frmactivity.command.value="<%=Command.EDIT%>";
	document.frmactivity.action="activity_edit.jsp";
	document.frmactivity.submit();
}

function cmdEdit(oid){
	document.frmactivity.activity_id.value=oid;	
	document.frmactivity.command.value="<%=Command.EDIT%>";
	document.frmactivity.action="activity_edit.jsp#down";
	document.frmactivity.submit();
	parent.frames[1].refresh();
	parent.frames[2].refresh();
	parent.frames[3].refresh();
}

function cmdBackList(){
	document.frmactivity.command.value="<%=Command.NONE%>";
	document.frmactivity.command.value="<%=Command.LIST%>";
	document.frmactivity.action="activity.jsp";
	document.frmactivity.submit();
}

function changeActLevel(){
	var level = document.frmactivity.<%=frmActivity.fieldNames[frmActivity.FRM_ACT_LEVEL]%>.value;	
	switch(level){
		case "<%=PstActivity.LEVEL_MODULE%>" :		
				for(var j=document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.length-1; j>-1; j--){
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.options.remove(j);
			 	}	
				for(var x=document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.length-1; x>-1; x--){
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.options.remove(x);
			 	}
								
				var mOption = document.createElement("OPTION");
				mOption.value = "0";
				mOption.text = "No Parent";				
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.add(mOption);
				
				var mpOption = document.createElement("OPTION");
				mpOption.value = "<%=PstActivity.ACT_NOTPOSTED%>";
				mpOption.text = "<%=PstActivity.actPosted[PstActivity.ACT_NOTPOSTED]%>";				
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.add(mpOption);
				
			break;
		case "<%=PstActivity.LEVEL_SUB_MODULE%>" :
				for(var s=document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.length-1; s>-1; s--){
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.options.remove(s);
			 	}
				for(var x=document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.length-1; x>-1; x--){
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.options.remove(x);
			 	}
			<%
				strOrder = PstActivity.fieldNames[PstActivity.FLD_CODE];
				strWhere = PstActivity.fieldNames[PstActivity.FLD_ACT_LEVEL]+" = "+PstActivity.LEVEL_MODULE;
				vActivity = PstActivity.list(0, 0, strWhere, strOrder);						
				for (int item=0; item < vActivity.size(); item++) 
				  {
					 Activity oActivity = (Activity) vActivity.get(item);									 									 		 									 
					 listCode.add(oActivity);									
				  } 
												
				  if(listCode!=null && listCode.size()>0)
				  {
						String space = "";										
						for(int i=0; i<listCode.size(); i++)
						{  
						   Activity obActivity = (Activity)listCode.get(i); 				
				%>		   
						   
						   var sOption = document.createElement("OPTION");
							sOption.value = "<%=obActivity.getOID()%>";
							sOption.text = "<%=obActivity.getCode()%> - <%=obActivity.getDescription()%>";
							document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.add(sOption);
					 <%}
					 }%> 
				var mpOption = document.createElement("OPTION");
				mpOption.value = "<%=PstActivity.ACT_NOTPOSTED%>";
				mpOption.text = "<%=PstActivity.actPosted[PstActivity.ACT_NOTPOSTED]%>";				
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.add(mpOption);
			
		break;
		case "<%=PstActivity.LEVEL_HEADER%>" :			
			for(var h=document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.length-1; h>-1; h--){
							document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.options.remove(h);
			 	}
			for(var x=document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.length-1; x>-1; x--){
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.options.remove(x);
			 	}					
			<%
				strOrder = PstActivity.fieldNames[PstActivity.FLD_CODE];
				strWhere = PstActivity.fieldNames[PstActivity.FLD_ACT_LEVEL]+" = "+PstActivity.LEVEL_SUB_MODULE;
				Vector vAct = new Vector(1,1);
				vAct = PstActivity.list(0, 0, strWhere, strOrder);				
				Vector lsCode = new Vector(1,1);
				for (int item=0; item < vAct.size(); item++) 
				  {
					 Activity oActivity = (Activity) vAct.get(item);									 									 		 									 
					 lsCode.add(oActivity);									
				  } 
				  				 								
				   if(lsCode!=null && lsCode.size()>0)
				  {
						String space = "";										
						for(int i=0; i<lsCode.size(); i++)
						{  
						   Activity obActivity = (Activity)lsCode.get(i); 						   
				%>		   
						   
						   var hOption = document.createElement("OPTION");
							hOption.value = "<%=obActivity.getOID()%>";
							hOption.text = "<%=obActivity.getCode()%> - <%=obActivity.getDescription()%>";
							document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.add(hOption);
					 <%}
					 }%> 
				var mpOption = document.createElement("OPTION");
				mpOption.value = "<%=PstActivity.ACT_NOTPOSTED%>";
				mpOption.text = "<%=PstActivity.actPosted[PstActivity.ACT_NOTPOSTED]%>";				
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.add(mpOption);
			
		break;
		case "<%=PstActivity.LEVEL_ACTIVITY%>" :
			for(var a=document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.length-1; a>-1; a--){
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.options.remove(a);
			 	}
			for(var x=document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.length-1; x>-1; x--){
				document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.options.remove(x);
			 	}	
			<%
				strOrder = PstActivity.fieldNames[PstActivity.FLD_CODE];
				strWhere = PstActivity.fieldNames[PstActivity.FLD_ACT_LEVEL]+" in("+PstActivity.LEVEL_SUB_MODULE+", "+PstActivity.LEVEL_HEADER+")";
				Vector aActivity = new Vector(1,1);
				Vector aListCode = new Vector(1,1);
				aActivity = PstActivity.list(0, 0, strWhere, strOrder);
				for (int item=0; item < aActivity.size(); item++) 
				  {
					 Activity oActivity = (Activity) aActivity.get(item);									 									 		 									 
					 aListCode.add(oActivity);									
				  } 
												
				   if(aListCode!=null && aListCode.size()>0)
				  {														
						for(int i=0; i<aListCode.size(); i++)
						{  
						   Activity obActivity = (Activity)aListCode.get(i); 	
						   String actDescription = "";
						   if(obActivity.getDescription().length() > 60){
						   		actDescription = obActivity.getDescription().substring(0,60) + "....";
						   }else{
						   		actDescription = obActivity.getDescription();
						   }
						  		
				%>		   
						   
						   var aOption = document.createElement("OPTION");
							aOption.value = "<%=obActivity.getOID()%>";
							aOption.text = "<%=obActivity.getCode()%> - <%=actDescription%>";
							document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_PARENT_ID]%>.add(aOption);
					 <%}
					 }%> 					 
			var mpOption = document.createElement("OPTION");
			mpOption.value = "<%=PstActivity.ACT_POSTED%>";
			mpOption.text = "<%=PstActivity.actPosted[PstActivity.ACT_POSTED]%>";				
			document.frmactivity.<%=FrmActivity.fieldNames[frmActivity.FRM_POSTED]%>.add(mpOption);
		break;
	}
}



</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/tab.css" type="text/css">
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
		  <%=pageTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=oidActivity != 0? textJspTitle[SESS_LANGUAGE][12].toUpperCase() : textJspTitle[SESS_LANGUAGE][11].toUpperCase()%></font>
		  <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmactivity" method="post" action="">              		  
              <input type="hidden" name="command" value="<%=iCommand%>">			 
              <input type="hidden" name="activity_id" value="<%=oidActivity%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
             <input type="hidden" name="list_command" value="<%=Command.LIST%>">
             
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2">&nbsp; 
                  
                  </td>
                </tr>
              </table>			  
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
				<td width="1%">&nbsp;</td> 
                  <td colspan="2">
				  <%
				  	String strWidth = "";
					if(objActivity.getActLevel() == PstActivity.LEVEL_ACTIVITY){
						strWidth = "60%";
					}else{
						strWidth = "10%";
					}
				  %> 
                    <table width="<%=strWidth%>" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td> 
                          <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/active_left.jpg" width="12" height="29"></td>
                              <td valign="middle" background="<%=approot%>/images/tab/active_bg.jpg"> 
                                <div align="center" class="tablink">Activity</div>
                              </td>
                              <td width="12"   valign="top" align="right"><img src="<%=approot%>/images/tab/active_right.jpg" width="12" height="29"></td>
                            </tr>
                          </table>
                        </td>
						<td>&nbsp;</td>
                        <td> <%if(objActivity.getActLevel() == PstActivity.LEVEL_ACTIVITY){%>
                          <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
                              <td valign="middle" background="<%=approot%>/images/tab/inactive_bg.jpg" > 
                                <div align="center" class="tablink"><a href="<%=approot%>/masterdata/activity/act_acc_link.jsp?hidden_activity_id=<%=oidActivity%>" class="tablink"><span class="tablink">Account 
                                  Link</span></a></div>
                              </td>
                              <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
                            </tr>
                          </table>
                        </td>
						<td>&nbsp;</td>
                        <td> 
                          <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
                              <td valign="middle" background="<%=approot%>/images/tab/inactive_bg.jpg" > 
                                <div align="center" class="tablink"><a href="<%=approot%>/masterdata/activity/act_prd_link.jsp?hidden_activity_id=<%=oidActivity%>" class="tablink"><span class="tablink">Period 
                                  Link</span></a></div>
                              </td>
                              <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
                            </tr>
                          </table>
                        </td>
						<td>&nbsp;</td>
                        <td> 
							<!--- 
                          <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td valign="top" align="left" width="12"><img src="<%//=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
                              <td valign="middle" background="<%//=approot%>/images/tab/inactive_bg.jpg"> 
                                <div align="center" class="tablink"><a href="<%//=approot%>/masterdata/activity/act_dnc_link.jsp?hidden_activity_id=<%//=oidActivity%>" class="tablink"><span class="tablink">Donor 
                                  Comp Link</span></a></div>
                              </td>
                              <td valign="top" align="left" width="10"><img src="<%//=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
                            </tr>
                          </table>
						  -->
                        </td>
						<%}%>
                      </tr>
                    </table>									
                  </td>				  
                </tr>
                <tr> 
				<td>&nbsp;</td>
                  <td colspan="2" bgcolor="#B6CDFB">

                 	  <table width="100%" cellpadding="0" cellspacing="0" class="listgenactivity">
                      <tr> 
                        <td width="20%">&nbsp;</td>
                        <td width="2%">&nbsp;</td>
                        <td colspan="4">&nbsp;</td>
                      </tr>
                      <tr>					  	
                        <td width="20%" nowrap height="25" id="down"></td>
                        <td width="2%" align="center">&nbsp;</td>
                        <td colspan="4" ><span class="fielderror">*)&nbsp;=&nbsp;<%=strNote%></span></td>
                      </tr>
                      <tr>					  	
                        <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle, 1, SESS_LANGUAGE, currPageTitle, false)%></td>
                        <td width="2%" align="center"><b>:</b></td>
                        <td colspan="4"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td valign="top"> 
                                <input type="text" name="<%=frmActivity.fieldNames[frmActivity.FRM_CODE] %>" value="<%=objActivity.getCode()%>" maxlength="9" size="7">
                                <span class="fielderror">&nbsp;*)&nbsp;&nbsp;<%=frmActivity.getErrorMsg(frmActivity.FRM_CODE)%></span></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 					  	
                        <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                        <td width="2%"> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td colspan="4"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td> 
                                <input type="text" name="<%=frmActivity.fieldNames[frmActivity.FRM_DESCRIPTION] %>" size="93" value="<%=objActivity.getDescription()%>">
                                <span class="fielderror">&nbsp;*)&nbsp;&nbsp;<%=frmActivity.getErrorMsg(frmActivity.FRM_DESCRIPTION)%><b></b></span> </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 					  	
                        <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle,7,SESS_LANGUAGE,currPageTitle,false)%></td>
                        <td width="2%"> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td colspan="4"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td> 
                                <textarea name="<%=frmActivity.fieldNames[frmActivity.FRM_OUTPUT_AND_DELV] %>" cols="60" rows="2"><%=objActivity.getOutPutandDelv()%></textarea>
                                <span class="fielderror">&nbsp;&nbsp;<%=frmActivity.getErrorMsg(frmActivity.FRM_OUTPUT_AND_DELV)%><b></b></span> </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>					  	
                        <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle,8,SESS_LANGUAGE,currPageTitle,false)%></td>
                        <td width="2%"> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td colspan="4"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td> 
                                <textarea name="<%=frmActivity.fieldNames[frmActivity.FRM_PERFM_INDICT] %>" cols="60" rows="2"><%=objActivity.getPerfmIndict()%></textarea>
                                <span class="fielderror">&nbsp;&nbsp;<%=frmActivity.getErrorMsg(frmActivity.FRM_PERFM_INDICT)%><b></b></span> </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 					  	
                        <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle,9,SESS_LANGUAGE,currPageTitle,false)%></td>
                        <td width="2%"> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td colspan="4"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td> 
                                <textarea name="<%=frmActivity.fieldNames[frmActivity.FRM_ASSUMP_AND_RISK] %>" cols="60" rows="2"><%=objActivity.getAssumpAndRisk()%></textarea>
                                <span class="fielderror">&nbsp;&nbsp;<%=frmActivity.getErrorMsg(frmActivity.FRM_ASSUMP_AND_RISK)%><b></b></span> </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 					  	
                        <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle,10,SESS_LANGUAGE,currPageTitle,false)%></td>
                        <td width="2%"> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td colspan="4"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td> 
                                <textarea name="<%=frmActivity.fieldNames[frmActivity.FRM_COST_IMPL] %>" cols="60" rows="2"><%=objActivity.getCostImpl()%></textarea>
                                <span class="fielderror">&nbsp;&nbsp;<%=frmActivity.getErrorMsg(frmActivity.FRM_COST_IMPL)%><b></b></span> </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>					  	
                        <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
                        <td width="2%"> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td colspan="4"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td> 
                                <%
								  Vector valLevel = new Vector(1,1);																									
								  Vector keyLevel = new Vector(1,1);
								  
								  valLevel.add(""+PstActivity.LEVEL_MODULE);					
								  keyLevel.add(""+PstActivity.actLevel[PstActivity.LEVEL_MODULE]);
								  
								  valLevel.add(""+PstActivity.LEVEL_SUB_MODULE);					
								  keyLevel.add(""+PstActivity.actLevel[PstActivity.LEVEL_SUB_MODULE]);		
								  
								  valLevel.add(""+PstActivity.LEVEL_HEADER);					
								  keyLevel.add(""+PstActivity.actLevel[PstActivity.LEVEL_HEADER]);
								  
								  valLevel.add(""+PstActivity.LEVEL_ACTIVITY);					
								  keyLevel.add(""+PstActivity.actLevel[PstActivity.LEVEL_ACTIVITY]);						  

								  String selectedLevel = ""+objActivity.getActLevel();																																																  
								  out.println(ControlCombo.draw(frmActivity.fieldNames[frmActivity.FRM_ACT_LEVEL],null,selectedLevel,valLevel,keyLevel,"onChange=\"javascript:changeActLevel()\"",""));								  
								%>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>					  	
                        <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle,4,SESS_LANGUAGE,currPageTitle,false)%></td>
                        <td width="2%"> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td colspan="4"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td>                                 
                                <%=ControlCombo.draw(frmActivity.fieldNames[frmActivity.FRM_PARENT_ID],null,strSelect,actCodeKey,actCodeVal)%></td>
                            </tr>
                          </table>
                        </td>
                      </tr>					  
                      <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle,5,SESS_LANGUAGE,"",false)%></td>
                      <td width="2%"> 
                        <div align="center"><b>:</b></div>
                      </td>
                      <td colspan="4"> 
                        <table width="100%" border="0" cellspacing="2" cellpadding="0">
                          <tr> 
                            <td> 
                              <%
								  Vector valPostable = new Vector(1,1);																									
								  Vector keyPostable = new Vector(1,1);

								  String selectedPostable = ""+objActivity.getPosted();																																																  
								  out.println(ControlCombo.draw(frmActivity.fieldNames[frmActivity.FRM_POSTED],null,selectedPostable,valPostable,keyPostable,""));								  
								%>
                            </td>
                          </tr>
                        </table>
                      </td>
                      </tr>
                      <tr> 					  	
                        <td width="30%" nowrap>&nbsp;&nbsp;&nbsp;<%=getJspTitle(textJspTitle,6,SESS_LANGUAGE,"",false)%></td>
                        <td width="2%"> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td colspan="4"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td> 
                                <%
								  Vector valType = new Vector(1,1);																									
								  Vector keyType = new Vector(1,1);
								  
								  valType.add(""+PstActivity.ACT_PROGRAMATIC);					
								  keyType.add(""+PstActivity.actAssign[PstActivity.ACT_PROGRAMATIC]);
								  
								  valType.add(""+PstActivity.ACT_SUPPORT);					
								  keyType.add(""+PstActivity.actAssign[PstActivity.ACT_SUPPORT]);								  

								  String selectedType = ""+objActivity.getType();																																																  
								  out.println(ControlCombo.draw(frmActivity.fieldNames[frmActivity.FRM_TYPE],null,selectedType,valType,keyType,""));								  
								%>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <%if(iCommand == Command.ASK){%>
                      <tr> 
                        <td colspan="6" height="27"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td width="97%" class="msgquestion"> 
                                <div align="center"><%=delConfirm%></div>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <%}%>
                      <% if ((ctrlActivity.getMessage()).length() != 0) { %>
                      <tr> 
                        <td height="15" align="center" colspan="6" id=errMsg class="msgErrComment" bgcolor="#ebebeb"><%=ctrlActivity.getMessage()%></td>
                      </tr>
                      <% }else{ 
					  	if(iCommand == Command.SAVE){
					  %>
                      <tr> 
                        <td height="10" colspan="6" width="14%" class="msginfo"><%=strConfSave%></td>
                      </tr>
					  <%
					  	}
					  }%>
                      <tr> 					  	
                        <td colspan="6" class="command"> &nbsp;&nbsp;&nbsp;
                          <%if((privAdd)&&(privUpdate)&&(privDelete)){%>
                          <% if(iCommand!=Command.ASK){  %>
                          <a href="javascript:cmdSave()"><%=strSaveAct%></a> | 
                          <%   if((iCommand != Command.ADD) && !((iCommand == Command.SAVE) && (oidActivity < 1))){ %>
                          <a href="javascript:cmdAsk('<%=oidActivity%>')"><%=strAskAct%></a> | 
                          <%   }
					     	 } else {
						  %>
                          <a href="javascript:cmdCancel()"><%=strCancel%></a> | <a href="javascript:cmdDelete('<%=oidActivity%>')"><%=strDeleteAct%></a> | 
                          <% }
						  }
						  %>
                          <a href="javascript:cmdBackList()"><%=strBackAct%></a> </td>
						  <tr><td>&nbsp;</td></tr>
                      </tr>
                      <script language="javascript">
					  		changeActLevel();
							document.frmactivity.<%=frmActivity.fieldNames[frmActivity.FRM_CODE]%>.focus();
					  </script>					  
                      <%//}%>
                    </table>
					<td width="1%">&nbsp;</td> 
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>