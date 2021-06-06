<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.search.*" %>
<%@ page import = "com.dimata.aiso.entity.search.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>

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
		"Cost implication"
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
		"Cost implication"
	}	
};

public static final String[][] strSearchParameter={
	{"Kode","Keterangan","Tingkat","Status","Tipe","Urut Berdasar"},
	{"Code","Description","Level","Posted","Type","Short By"}
};

public static final String[][] strCommand = {
	{"Tampilkan","Kosongkan"},
	{"Search","Reset"}
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

public static final String subPageTitle[] = 
{
	"Daftar","List"	
};


public String drawList(Vector objectClass, long oid, int language, int start)
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
	String strDescription = "";
	String strOutPutandDelv = "";
	String strPerfmIndict = "";
	String strAssumpAndRisk = "";
	String strCostImpl = "";
	
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
			 long idParent = 0;
			 idParent = objActivity.getIdParent();
			 
			 if(idParent != 0){
			 	try{
			 		oActivity = PstActivity.fetchExc(idParent);
				}catch(Exception e){
					System.out.println("Erorr pada saat fetch object activity ===> "+e.toString());
				}
			 }
			 strStatus = PstActivity.actPosted[objActivity.getPosted()];
			 strType = PstActivity.actAssign[objActivity.getType()];
			 strLevel = PstActivity.actLevel[objActivity.getActLevel()];
			 
			 if(oActivity.getDescription().length() > 30){
					strParentName = (oActivity.getDescription()).substring(0,30)+".....";
				 }else{
					strParentName = oActivity.getDescription();
				 }		
			 			 
			 if(oActivity.getDescription().length() > 30){
			 	strParentName = (oActivity.getDescription()).substring(0,30)+".....";
			 }else{			 	
			 	strParentName = oActivity.getDescription();
				if(strParentName.length() == 0){
			 	strParentName = "Module Level (No Parent)";
			 }
			 }
			 
			 Vector rowx = new Vector();
			
			if(objActivity.getDescription().length() > 30){
			 	strDescription = (objActivity.getDescription()).substring(0,30)+".....";
			 }else{
			 	strDescription = objActivity.getDescription();
			 }
			 
			 if(objActivity.getOutPutandDelv().length() > 30){
			 	strOutPutandDelv = (objActivity.getOutPutandDelv()).substring(0,30)+".....";
			 }else{
			 	strOutPutandDelv = objActivity.getOutPutandDelv();
			 }
			 
			 if(objActivity.getPerfmIndict().length() > 30){
			 	strPerfmIndict = (objActivity.getPerfmIndict()).substring(0,30)+".....";
			 }else{
			 	strPerfmIndict = objActivity.getPerfmIndict();
			 }
			 
			 if(objActivity.getAssumpAndRisk().length() > 30){
			 	strAssumpAndRisk = (objActivity.getAssumpAndRisk()).substring(0,30)+".....";
			 }else{
			 	strAssumpAndRisk = objActivity.getAssumpAndRisk();
			 }
			 
			 if(objActivity.getCostImpl().length() > 30){
			 	strCostImpl = (objActivity.getCostImpl()).substring(0,30)+".....";
			 }else{
			 	strCostImpl = objActivity.getCostImpl();
			 }
			 
			 link ="<a href=\"javascript:cmdEdit('"+String.valueOf(objActivity.getOID())+"')\">";
			 closeLink = "</a>";			
			  
			 rowx.add(""+(i+start+1));
			 rowx.add(link+objActivity.getCode()+closeLink);  		 
			 rowx.add(strDescription); 
			 rowx.add(strLevel); 
			 rowx.add(strParentName);
			 rowx.add(strStatus);
			 rowx.add(strType);
			 rowx.add(strOutPutandDelv);
			 rowx.add(strPerfmIndict);
			 rowx.add(strAssumpAndRisk);
			 rowx.add(strCostImpl);

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

int recordToGet = 20;

// Setup controlLine and Commands caption
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = pageTitle[SESS_LANGUAGE];
String strAddAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strListAct = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List " : "Daftar ")+currPageTitle;
String strSaveAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strBackAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " Search" : " Pencarian");
String strDeleteAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
String strHeader = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "LIST " : "DAFTAR ");
String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
String searchData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View Search Form" : "Cari Data";
String hideSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Hide Search Form" : "Sembunyikan Form Cari Data";
String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
String strNoAccSelected = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) ? "- No Activity Reference -" : "- Tidak ada aktivifitas referensi -";
String strNote = (SESS_LANGUAGE == 1) ? "Entry required" : "Harus diisi";

// Manage controlList and Action process
Control controlList = new Control();
CtrlActivity ctrlActivity = new CtrlActivity(request); 

ctrlActivity.setLanguage(SESS_LANGUAGE);
int ctrlErr = ctrlActivity.action(iCommand, oidActivity); 
FrmActivity frmActivity = ctrlActivity.getForm();
Activity objActivity = ctrlActivity.getActivity(); 
oidActivity = objActivity.getOID();
SrcActivity srcActivity = new SrcActivity();
FrmSrcActivity frmSrcActivity = new FrmSrcActivity(request);
frmSrcActivity.requestEntityObject(srcActivity);


String strActivityId = String.valueOf(oidActivity);

if(session.getValue("ACTIVITY_ID") != null){
	session.removeValue("ACTIVITY_ID");
	}
if(objActivity.getActLevel() == PstActivity.LEVEL_ACTIVITY){	
		session.putValue("ACTIVITY_ID", strActivityId);
		}						


// get list of department object
String strWhere = "";
String strOrder = PstActivity.fieldNames[PstActivity.FLD_CODE];

// Proses list account chart ...
Vector vectActivity = new Vector(); 
Vector vectAllActivity = new Vector();
vectActivity = SessActivity.listAllActivity(srcActivity,start, recordToGet);
vectAllActivity = SessActivity.listAllActivity(srcActivity,0, 0);

int vectSize = vectAllActivity.size();
if((iCommand == Command.FIRST || iCommand == Command.PREV )||  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlActivity.actionList(iCommand, start, vectSize, recordToGet);
}

vectActivity = SessActivity.listAllActivity(srcActivity,start, recordToGet);


if (vectActivity.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 vectActivity = SessActivity.listAllActivity(srcActivity,start, recordToGet);
}


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
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.activity_id.value="0";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.ADD%>";	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity_edit.jsp";	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();	
}


function cmdSave()
{	
	document.frmactivity.command.value="<%=Command.SAVE%>";
	document.frmactivity.action = "activity.jsp";	
	document.frmactivity.submit();	
	parent.frames[2].refresh();
}

function cmdAsk(oid){
	document.frmactivity.activity_id.value=oid;
	document.frmactivity.command.value="<%=Command.ASK%>";
	document.frmactivity.action="activity.jsp";
	document.frmactivity.submit();
}

function cmdDelete(oid){
	document.frmactivity.activity_id.value=oid;
	document.frmactivity.command.value="<%=Command.DELETE%>";
	document.frmactivity.action="activity.jsp";
	document.frmactivity.submit();
}
<%
}
%>



function cmdCancel(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function cmdEdit(oid){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.activity_id.value=oid;	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity_edit.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
	parent.frames[1].refresh();
	parent.frames[2].refresh();
	parent.frames[3].refresh();
}

function cmdListFirst(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.prev_command.value="<%=Command.FIRST%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp#down";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function cmdBackList(){	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.NONE%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.LIST%>";		
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp#up";		
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
	
}

function cmdListPrev(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.PREV%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.prev_command.value="<%=Command.PREV%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp#down";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
	}

function cmdListNext(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.prev_command.value="<%=Command.NEXT%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp#down";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function cmdListLast(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.LAST%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.prev_command.value="<%=Command.LAST%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp#down";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}
function cmdSearch(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.LIST%>";	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}	

function cmdClear(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_CODE]%>.value="";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_DESCRIPTION]%>.value="";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_CODE]%>.focus();	
}

function cmdViewSearch(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.ADD%>";	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function cmdHideSearch(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.NONE%>";	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function enterTrap(){
	if(event.keyCode == 13){
		cmdSearch();
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
		  <%=pageTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=subPageTitle[SESS_LANGUAGE].toUpperCase()%></font>
		  <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>" method="post" action="">              		  
              <input type="hidden" name="command" value="<%=iCommand%>">			 
              <input type="hidden" name="activity_id" value="<%=oidActivity%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
             <input type="hidden" name="list_command" value="<%=Command.LIST%>">
                
              <table width="100%" cellpadding="0" cellspacing="0" class="listgencontent">
                
                <tr>
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" valign="top">
				  <%
				  int icmd = Command.LIST;
				  	if(iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST){
						icmd = Command.NONE;
					}else{
						icmd = iCommand;
					}				  
				  %>
				 <!-- --->
				 <%if(iCommand != Command.NONE){
				 	if(icmd != Command.NONE){
				 %>
				  <table width="100%" cellpadding="1" cellspacing="1" class="listgenvalue">
                    <tr>
                      <td nowrap id="up">&nbsp;</td>
                      <td><div align="center"></div></td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td width="8%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][0]%></td>
                      <td width="2%"><div align="center"><strong>:</strong></div></td>
                      <td width="90%"><input type="text" onKeyDown="javascript:enterTrap()" name="<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_CODE]%>" value="<%=srcActivity.getCode()%>" size="20">
                      </td>
                    </tr>
                    <tr>
                      <td width="8%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][1]%></td>
                      <td width="2%"><div align="center"><strong>:</strong></div></td>
                      <td width="90%">
                        <input type="text" name="<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_DESCRIPTION]%>" value="<%=srcActivity.getDescription()%>" size="50" onKeyDown="javascript:enterTrap()">
                      </td>
                    </tr>
                    <tr>
                      <td>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][2]%></td>
                      <td><div align="center"><strong>:</strong></div></td>
                      <td>
					  	<%
							PstActivity pstActivity = new PstActivity();
							Vector vVal = new Vector(1,1);
							Vector vKey = new Vector(1,1);
							
							vKey.add(frmSrcActivity.fieldAllLevel[SESS_LANGUAGE]);
							vVal.add(""+(FrmSrcActivity.ALL_LEVEL + 1));
							for(int i=0; i < pstActivity.actLevel.length; i++){
								vKey.add(pstActivity.actLevel[i]);
							}
							vVal.add(""+(PstActivity.LEVEL_MODULE + 1));
							vVal.add(""+(PstActivity.LEVEL_SUB_MODULE + 1));
							vVal.add(""+(PstActivity.LEVEL_HEADER + 1));
							vVal.add(""+(PstActivity.LEVEL_ACTIVITY + 1));
							
							String strSelected = String.valueOf(srcActivity.getActLevel());
						%>
						<% out.println(ControlCombo.draw(FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_LEVEL],"",null,strSelected,vVal,vKey,""));%>	
							  
					  </td>
                    </tr>
                    <tr>
                      <td>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][3]%></td>
                      <td><div align="center"><strong>:</strong></div></td>
                      <td>
					  	<%
							Vector vctValue = new Vector(1,1);
							Vector vctKey = new Vector(1,1);
							vctValue.add(""+(FrmSrcActivity.ALL_POSTED + 1));
							vctKey.add(FrmSrcActivity.fieldAllPosted[SESS_LANGUAGE]);
							for(int p=0; p < PstActivity.actPosted.length; p++){
								vctKey.add(PstActivity.actPosted[p]);
							}
							vctValue.add(""+(PstActivity.ACT_NOTPOSTED + 1));
							vctValue.add(""+(PstActivity.ACT_POSTED + 1));
							
							String strPostedSelected = String.valueOf(srcActivity.getPosted());
						%>
						<% out.println(ControlCombo.draw(FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_POSTED],"",null,strSelected,vctValue,vctKey,""));%>
						
					  </td>
                    </tr>
                    <tr>
                      <td>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][4]%></td>
                      <td><div align="center"><strong>:</strong></div></td>
                      <td>
					  	<%
							Vector vecVal = new Vector();
							Vector vecKey = new Vector();
							vecVal.add(""+(FrmSrcActivity.ALL_TYPE + 1));
							vecKey.add(FrmSrcActivity.fieldAllType[SESS_LANGUAGE]);
							for(int t=0; t < PstActivity.actAssign.length; t++){
								vecKey.add(PstActivity.actAssign[t]);
							}
							vecVal.add(""+(PstActivity.ACT_PROGRAMATIC + 1));
							vecVal.add(""+(PstActivity.ACT_SUPPORT + 1));
							
							String strActSelected = String.valueOf(srcActivity.getActType());
						%>
						<% out.println(ControlCombo.draw(FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_TYPE],"",null,strActSelected,vecVal,vecKey,""));%>
						
					  </td>
                    </tr>
                    <tr>
                      <td>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][5]%></td>
                      <td><div align="center"><strong>:</strong></div></td>
                      <td>
					  	<%
							Vector vectValue = new Vector(1,1);
							Vector vectKey = new Vector(1,1);
						    vectKey.add(FrmSrcActivity.shortFieldNames[SESS_LANGUAGE][0]);
						 	vectKey.add(FrmSrcActivity.shortFieldNames[SESS_LANGUAGE][1]);
						  	vectKey.add(FrmSrcActivity.shortFieldNames[SESS_LANGUAGE][2]);
						   	vectKey.add(FrmSrcActivity.shortFieldNames[SESS_LANGUAGE][3]);							   
							
							vectValue.add(""+FrmSrcActivity.SHORTBY_CODE);
							vectValue.add(""+FrmSrcActivity.SHORTBY_LEVEL);
							vectValue.add(""+FrmSrcActivity.SHORTBY_POSTED);
							vectValue.add(""+FrmSrcActivity.SHORTBY_TYPE);			
							
							String strOrdSelected = String.valueOf(srcActivity.getOrderBy());
							
						%>
						<% out.println(ControlCombo.draw(FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_ORDERBY],"",null,strOrdSelected,vectValue,vectKey,""));%>
						
					  </td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td><div align="center"></div></td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td width="8%">&nbsp;</td>
                      <td width="2%"><div align="center"></div></td>
                      <td width="90%">
                        <input type="button" name="btnSubmit" value="<%=strCommand[SESS_LANGUAGE][0]%>" onClick="javascript:cmdSearch()">
                        <input type="button" name="btnReset" value="<%=strCommand[SESS_LANGUAGE][1]%>" onClick="javascript:cmdClear()">
                      </td>
                    </tr>
                    
                  </table>
				  <%}
				  }
				  %>
				  <!-- End search -->
				  </td>
                </tr>
                <tr>
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
				  <%if(iCommand == Command.NONE || icmd == Command.NONE){%>
				  <a href="javascript:cmdViewSearch()"><%=searchData%></a>
				  <%}else{%>
				  <a href="javascript:cmdHideSearch()"><%=hideSearch%></a>
				  <%}%>
				  </font>
				  </td>
                </tr>
                <tr> 
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" valign="top" id="down"><span class="command"> 
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
                    </span> 
                    <%				

                 	if((vectActivity!=null)&&(vectActivity.size()>0))
					{  
						out.println(drawList(vectActivity,objActivity.getOID(),SESS_LANGUAGE,start)); 
					}
					else
					{
						out.println("<font size=\"2\" color=\"#FF0000\"><em>&nbsp;No Activity Available ...<em></font>");
					}
			  		%>
                    <table width="100%">
                      <tr> 
                        <td colspan="2">
						<%
							ctrLine.initDefault(SESS_LANGUAGE,"");
						%>
						 <span class="command"> <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> </span> </td>
                      </tr>
                    </table>
				  </td>
				</tr>
					<tr>
					  <td>&nbsp;</td>
					</tr>
					<tr>					
					<td>
                    <table width="100%" cellpadding="1" cellspacing="1">										
                      <tr>			  
                        <%if(privAdd && privManageData){%>
                        <%if(iCommand == Command.LIST || iCommand==Command.ADD || iCommand==Command.NONE || iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT|| iCommand==Command.LAST|| iCommand==Command.DELETE|| iCommand==Command.SAVE){%>
                        <td width="97%" nowrap class="command">						
						&nbsp;&nbsp;<a href="javascript:addNew()"><%=strAddAct%></a> 
						<%if(commandBack.equalsIgnoreCase("Y")){%>
						| <a href="javascript:cmdBackList()"><%=strBackAct%></a></td>
						<%}%>
                        <%}}%>
                      </tr>
					  <tr><td>&nbsp;</td></tr>
                      <%//if(((iCommand==Command.SAVE)&& ((frmActivity.errorSize()>0) || (ctrlErr!=CtrlActivity.RSLT_OK)) )||(iCommand==Command.ADD)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){ %>
                    </table>
                  </td>
                </tr>
              </table>			  
            </form>
			 <script language="JavaScript">		
			 <% if(iCommand == Command.LIST){
			 		if(iCommand != Command.EDIT){
			 %>			 	
						document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_CODE]%>.focus();	
						cmdHideSearch();					
						<%}
						}%>
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
<!-- endif of "has access" condition -->
<%}%>