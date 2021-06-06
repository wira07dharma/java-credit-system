<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.system.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>

<!--package java-->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<!--package qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- use harisma class -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>

<% int  appObjCode =  0;
try{
 	appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_ACCOUNT_CART, AppObjInfo.OBJ_MASTERDATA_ACCOUNT_CART);
 }catch(Exception e){
 	System.out.println("Exception on componseObjCode ::::: "+e.toString());  
 }%>
<%@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privPrint=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

//if of "hasn't access" condition 
if (!privView && !privAdd && !privUpdate && !privDelete && !privPrint) 
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
		"Induk",//0
		"Nomor",//1
		"Nama",//2
		"Level",//3
		"Saldo Normal",//4
		"Status",//5
		"Departemen",//6 
		"Anggaran", //7
		"Bobot", //8
		"Perkiraan Acuan",//9 
		"Catatan",//10
		"Perusahaan",//11
		"Perkiraan Hutang/Piutang",//12
		"Jenis Perkiraan",//13
		"Jenis Biaya",//14
		"Biaya Tetap / Variabel"//15
	},
	{
		"Reference",
		"Code",
		"Name",
		"Level",
		"Normal Sign",
		"Status",
		"Department", 
		"Budget", 
		"Weight", 
		"General Account", 
		"Note",
		"Company",
		"AR/AP Account",
		"Account Type",
		"Expense Type",
		"Fixed/Variable Exp"
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
	"Perkiraan","Chart of Account"	
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
	ctrlist.dataFormat(getJspTitle(textJspTitle,1,language,"",false),"15%","center","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,2,language,"",false),"48%","center","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,6,language,"",false),"20%","center","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,3,language,"",false),"7%","center","center");	
	ctrlist.dataFormat(getJspTitle(textJspTitle,5,language,"",false),"10%","center","left");

	ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");
	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
    String psn = ""; 
	int lvl = 0;
	String strLvl = "";
	String link = "";
	String closeLink ="";
	int index = -1;
	try 
	{ 								
		for (int i = 0; i < objectClass.size(); i++) 
		{
			 Perkiraan perkiraan = (Perkiraan)objectClass.get(i);
			 
			 if(oid==perkiraan.getOID())
			 {
			 	index =i;
			 }
			 
			 String strDepartment = "";
			 Department objDepartment = new Department();			 
			 
			 if(perkiraan.getDepartmentId() != 0){
			 	try{
					objDepartment = PstDepartment.fetchExc(perkiraan.getDepartmentId());
				}catch(Exception e){
					System.out.println("Exception on fetch objDepartment ==> "+e.toString());
				}
			 } 
			 
			 if(objDepartment != null)
			 	strDepartment = objDepartment.getDepartment();
				
			 psn = PstPerkiraan.arrStrPostable[language][perkiraan.getPostable()];

			 Vector rowx = new Vector();
			 lvl = perkiraan.getLevel();
			 switch(lvl)
			 {
			    case 2 : strLvl = "&nbsp;&nbsp;"; 
						 break;
			    case 3 : strLvl = "&nbsp;&nbsp;&nbsp;&nbsp;";
						 break;
			    case 4 : strLvl = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
						 break;
			    case 5 : strLvl = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
						 break;
			    case 6 : strLvl = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
						 break;
			    default : strLvl = "";
			 }
			 link ="<a href=\"javascript:cmdEdit('"+String.valueOf(perkiraan.getOID())+"')\">";
			 closeLink = "</a>"; 
			 rowx.add(strLvl+link+perkiraan.getNoPerkiraan()+closeLink);  
			 
			 String strAccountName = "";
			 if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
			 {			 
			 	strAccountName = perkiraan.getAccountNameEnglish();
			 }
			 else
			 {
			 	strAccountName = perkiraan.getNama();			 
			 }			 
			 rowx.add(strAccountName); 
			 rowx.add(strDepartment);
			 rowx.add(String.valueOf(lvl)); 
			 rowx.add(psn);

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
long iAccountOID = FRMQueryString.requestLong(request,"accountchart_id"); 
int iAccountGroup = FRMQueryString.requestInt(request,"accountchart_group");
int iAccountType = FRMQueryString.requestInt(request,"accountchart_type");
//int arapAccount = FRMQueryString.requestInt(request,"arapAccount");
long departmentOid = FRMQueryString.requestLong(request, "departmentOid");
long companyId = FRMQueryString.requestLong(request, "companyId");
long lGeneralAccOid = FRMQueryString.requestLong(request, "generalAccOid");
if(iAccountGroup == 0) iAccountGroup = PstPerkiraan.ACC_GROUP_LIQUID_ASSETS;	
int listCommand = FRMQueryString.requestInt(request, "list_command");
if(listCommand==Command.NONE) listCommand = Command.LIST; 

AisoBudgeting objAisoBudg = SessAisoBudgeting.getCurrentAisoBudgeting(iAccountOID);
double dBudget = objAisoBudg.getBudget();
// variable declaration 
int recordToGet = 20;

if(iCommand == Command.EDIT || iCommand == Command.ADD){
	recordToGet = 5;
}

// Setup controlLine and Commands caption
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = pageTitle[SESS_LANGUAGE];
String strAddAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strUploadAcc = "Upload "+ currPageTitle;
String strListAcc = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List " : "Daftar ")+currPageTitle;
String strSaveAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strBackAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strDeleteAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
String strHeader = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "LIST " : "DAFTAR ")+(PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][iAccountGroup]).toUpperCase();
String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
String strNoAccSelected = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) ? "- No Reference Account -" : "- Tidak ada referensi perkiraan -";
String strAccGroup = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) ? "Group Account" : "Kelompok Perkiraan";
String strAccPostable = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) ? "Non postable account" : "Perkiraan non postable";
String strNote = (SESS_LANGUAGE == 1) ? "Entry required" : "Harus diisi";

// Manage controlList and Action process
Control controlList = new Control();
CtrlPerkiraan ctrlPerkiraan = new CtrlPerkiraan(request);  
ctrlPerkiraan.setLanguage(SESS_LANGUAGE);
int ctrlErr = ctrlPerkiraan.action(iCommand, iAccountOID); 
FrmPerkiraan frmPerkiraan = ctrlPerkiraan.getForm();
frmPerkiraan.setDecimalSeparator(sUserDecimalSymbol);
frmPerkiraan.setDigitSeparator(sUserDigitGroup);
Perkiraan perkiraan = ctrlPerkiraan.getPerkiraan(); 

if(iCommand == Command.ADD){
	perkiraan = new Perkiraan();
	dBudget = 0;
}

departmentOid = perkiraan.getDepartmentId();
companyId = perkiraan.getCompanyId();
//arapAccount = perkiraan.getArapAccount();

// get list of department object
String strWhere = "";
String strOrder = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT];
Vector vectDept = PstDepartment.list(0, 0, strWhere, strOrder);


// Update value of application variable id command is SUBMIT
if(iCommand==Command.SUBMIT)
{
	if(vectDept!=null && vectDept.size()>0)
	{
		AppValue.updateAppValueHashtable(vectDept);
	}
}

// Proses list account chart ...
Vector vectAccountList = PstPerkiraan.getAllAccount(iAccountGroup, 0);
int vectSize = vectAccountList.size(); 
if(iAccountType == iAccountGroup)
{
	start = controlList.actionList(listCommand, start, vectSize, recordToGet); 
}
else
{
	start = 0;
	iAccountType = iAccountGroup;
}

Vector vCompany = PstCompany.list(0, 0, "", PstCompany.fieldNames[PstCompany.FLD_COMPANY_NAME]);
System.out.println(frmPerkiraan.getErrors());
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
	document.frmaccountchart.accountchart_id.value="0";
	document.frmaccountchart.command.value="<%=Command.ADD%>";
	document.frmaccountchart.departmentOid.value = "0";
	document.frmaccountchart.companyId.value = "0";
	//document.frmaccountchart.<%//=frmPerkiraan.fieldNames[frmPerkiraan.FRM_ARAP_ACCOUNT]%>.value = "0";
	document.frmaccountchart.generalAccOid.value = "0";
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}

function cmdUpload(){
	document.frmaccountchart.command.value="<%=Command.SUBMIT%>";
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}

function cmdSave()
{
	var level = document.frmaccountchart.LEVEL.value;
	var posted = document.frmaccountchart.POSTABLE.value;
	if(level==1 && posted==1)
	{
		
		alert("<%=strAccPostable%>");
	    document.frmaccountchart.LEVEL.focus();
	}
	else
	{	
		document.frmaccountchart.departmentOid.value = document.frmaccountchart.<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_DEPARTMENT_ID]%>.value;
		document.frmaccountchart.companyId.value = document.frmaccountchart.<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_COMPANY_ID]%>.value;
		//document.frmaccountchart.generalAccOid.value = document.frmaccountchart.<%//=frmPerkiraan.fieldNames[frmPerkiraan.FRM_GENERAL_ACCOUNT_LINK]%>.value;
		document.frmaccountchart.command.value="<%=Command.SAVE%>";
		document.frmaccountchart.action = "account_chart.jsp#down";
		document.frmaccountchart.submit();		
	}
}

function cmdAsk(oid){
	document.frmaccountchart.accountchart_id.value=oid;
	document.frmaccountchart.command.value="<%=Command.ASK%>";
	document.frmaccountchart.action="account_chart.jsp#down";
	document.frmaccountchart.submit();
}

function cmdDelete(oid){
	document.frmaccountchart.accountchart_id.value=oid;
	document.frmaccountchart.command.value="<%=Command.DELETE%>";
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}
<%
}
%>

<%
if(privPrint)
{
%>
function cmdListAccount()
{
	var linkPage = "account_list.jsp?accountchart_group=<%=iAccountGroup%>&str_header=<%=strHeader%>";
	window.open(linkPage,null,"height=480,width=640,status=no,toolbar=no,menubar=yes,location=no,scrollbars=yes");
}
<%
}
%>

function cmdCancel(){
	document.frmaccountchart.command.value="<%=Command.EDIT%>";
	document.frmaccountchart.action="account_chart.jsp#down";
	document.frmaccountchart.submit();
}

function cmdEdit(oid){
	document.frmaccountchart.accountchart_id.value=oid;
	document.frmaccountchart.departmentOid.value = "0";
	document.frmaccountchart.generalAccOid.value = "0";
	document.frmaccountchart.command.value="<%=Command.EDIT%>";
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}

function first(){
	document.frmaccountchart.list_command.value="<%=Command.FIRST%>";
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}
function prev(){
	document.frmaccountchart.list_command.value="<%=Command.PREV%>";
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}

function next(){
	document.frmaccountchart.list_command.value="<%=Command.NEXT%>";
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}
function last(){
	document.frmaccountchart.list_command.value="<%=Command.LAST%>";
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}

function cmdBackList(){
	document.frmaccountchart.command.value="<%=Command.NONE%>";
	document.frmaccountchart.list_command.value="<%=Command.LIST%>";
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}

function cmdChange(){
	if(document.frmaccountchart.TANDA_DEBET_KREDIT.value=="1"){
		document.frmaccountchart.KREDIT.value=" +";
	} else {
		document.frmaccountchart.KREDIT.value=" -";
	}
}

function cmdItemData(tipe){
	document.frmaccountchart.command.value="<%=Command.NONE%>";	
	document.frmaccountchart.list_command.value="<%=Command.LIST%>";
	document.frmaccountchart.accountchart_group.value=tipe;
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}

function cmdClasification(){
	var classType = document.frmaccountchart.<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_ACCOUNT_GROUP]%>.value;	
	document.frmaccountchart.command.value="<%=Command.NONE%>";	
	document.frmaccountchart.list_command.value="<%=Command.LIST%>";
	document.frmaccountchart.accountchart_group.value=classType;
	document.frmaccountchart.action="account_chart.jsp";
	document.frmaccountchart.submit();
}

function cmdChangeLevel(){
	var level = document.frmaccountchart.LEVEL.value;
	if(level==1){
	   document.frmaccountchart.POSTABLE.options[1].selected=true;
	}
 
}

function cmdEditBudget() 
{
    document.frmaccountchart.action = "edit_budget.jsp";
    document.frmaccountchart.submit();
}

function chgExpenseType()
{
	var expType = document.frmaccountchart.<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_EXPENSE_TYPE]%>.value;
	if(expType == 0){
		document.getElementById("fixedvar").style.display="";
	}else{
		document.getElementById("fixedvar").style.display="none";
	}
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --><!-- #EndEditable -->
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		  <%
		  PstPerkiraan pstperkiraan = new PstPerkiraan();
		  pstperkiraan.setIndex(iAccountGroup);
		  %>
		  <b><%=currPageTitle%> : </b><font color="#CC3300"><%=pstperkiraan.getAccountGroupName(SESS_LANGUAGE).toUpperCase()%></font>
		  <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmaccountchart" method="post" action="">
              <input type="hidden" name="accountchart_group" value="<%=iAccountGroup%>">
              <input type="hidden" name="accountchart_type" value="<%=iAccountType%>">			  
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="accountchart_id" value="<%=iAccountOID%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="list_command" value="<%=Command.LIST%>">
              <input type="hidden" name="departmentOid" value="<%=departmentOid%>">
			  <input type="hidden" name="companyId" value="<%=companyId%>">
              <input type="hidden" name="generalAccOid" value="<%=lGeneralAccOid%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2">&nbsp; 
                  </td>
                </tr>
              </table>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><%=strAccGroup%> :</font>
                  <%
				  String attrClass = "onChange=\"javascript:cmdClasification()\"";				  
				  Vector vectClassVal = new Vector(1,1);				  				  				  
				  Vector vectClassKey = new Vector(1,1);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_LIQUID_ASSETS]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_FIXED_ASSETS);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_FIXED_ASSETS]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_OTHER_ASSETS);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_OTHER_ASSETS]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_LONG_TERM_LIABILITIES);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_LONG_TERM_LIABILITIES]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_EQUITY);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_EQUITY]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_REVENUE);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_REVENUE]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_COST_OF_SALES);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_COST_OF_SALES]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_EXPENSE);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_EXPENSE]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_OTHER_REVENUE);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_OTHER_REVENUE]);
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_OTHER_EXPENSE);					
				  vectClassKey.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_OTHER_EXPENSE]);
				  				  				  				  				  				  				  				  				  				  				  				  				  
				  out.println("&nbsp;"+ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_ACCOUNT_GROUP],null,""+iAccountGroup,vectClassVal,vectClassKey,attrClass));
				  %>
                  </td>
                </tr>
              </table>			  
              <table width="100%" cellpadding="0" cellspacing="0" class="listgenactivity">
                <tr> 
                  <td colspan="2"> 
				    <%
					Vector listPerkiraan = new Vector(1,1);
					for (int item=start; item<(start + recordToGet) && item<vectSize; item++) 
					{
						listPerkiraan.add(vectAccountList.get(item));
					}

                 	if((listPerkiraan!=null)&&(listPerkiraan.size()>0))
					{  
						out.println(drawList(listPerkiraan,perkiraan.getOID(),SESS_LANGUAGE)); 
					}
					else
					{
						out.println("<font size=\"2\" color=\"#FF0000\">&nbsp;No Account Available ...</font>");
					}
			  		%>                     
                    <table width="100%">
                      <tr> 
                        <td colspan="2"> 
						<%
							ctrLine.initDefault(SESS_LANGUAGE,"");
						%>
						<span class="command"><%=ctrLine.drawMeListLimit(listCommand, vectSize, start, recordToGet,"first","prev","next","last","left")%> </span> </td>
                      </tr>
                    </table>
                    <table width="100%" cellpadding="1" cellspacing="1">
                      <% if( (ctrlErr==CtrlPerkiraan.RSLT_OK) && (iCommand!=Command.ADD)&&(iCommand!=Command.ASK)&&(iCommand!=Command.EDIT)&&(frmPerkiraan.errorSize()<1) ) { %>
                      <tr>
                        <td colspan="6" class="command"><hr color="#00CCFF" size="2"></td>
                      </tr>
                      <tr>
                        <td colspan="6" class="command"><%if(privAdd){%>
                          &nbsp;<a href="javascript:addNew()"><%=strAddAcc%></a> |
                          <%if(iCommand==Command.SAVE){%>
                          <a href="javascript:cmdUpload()"><%=strUploadAcc%></a> |
                          <%}%>
                          <%}%>
                          <%if(privPrint){%>
                          <a href="javascript:cmdListAccount()"><%=strListAcc%></a
						>
                          <%}%></td>
                      </tr>
                      <tr>
                        <td colspan="6" class="command">&nbsp;</td>
                      </tr>
                      <%}%>
                      <% if(((iCommand==Command.SAVE)&& ((frmPerkiraan.errorSize()>0) || (ctrlErr!=CtrlPerkiraan.RSLT_OK)) )||(iCommand==Command.ADD)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){ %>
                      <tr>
                        <td width="15%" nowrap height="25">&nbsp;</td>
                        <td width="2%" align="center">&nbsp;</td>
                        <td width="83%"><span class="fielderror">*)&nbsp;=&nbsp;<%=strNote%></span></td>
                      </tr>
                      <tr>
                        <td height="28" nowrap>&nbsp;<%=textJspTitle[SESS_LANGUAGE][11]%></td>
                        <td align="center"><div align="center"><strong>:</strong></div></td>
                        <td colspan="4">
							<%
								Vector vCompanyVal = new Vector();
								Vector vCompanyKey = new Vector();
								String selectedCompany = ""+perkiraan.getCompanyId();
								if(vCompany != null && vCompany.size() > 0)
								{
									for(int t = 0; t < vCompany.size(); t++)
									{
										Company objCompany = (Company) vCompany.get(t);
										vCompanyVal.add(""+objCompany.getOID());
										vCompanyKey.add(objCompany.getCompanyName());
									}
								}
							%>
                            <%=ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_COMPANY_ID], "", null, selectedCompany, vCompanyVal, vCompanyKey)%> </td>
                      </tr>
                      <tr>
                        <td width="15%" height="28" nowrap>&nbsp;<%=getJspTitle(textJspTitle, 6, SESS_LANGUAGE, currPageTitle, false)%></td>
                        <td width="2%" align="<%
							 Vector vectCompKey = new Vector();
							 Vector vectCompName = new Vector();
							 String strSelectedComp = String.valueOf(companyId);							 
							%>center"><b>:</b></td>
                        <td colspan="4" width="83%"><table width="100%">
                            <tr>
                              <td id="down"><!-- ------------------ Update by DWI ------------------- 
				 Digunakan untuk menampilkan departement sesuai dengan wewenang user.
				 Alurnya :
				 - Kenali OID user yang masuk
				 - Cari departement berdasarkan OID user
				 - Masukan department ke combo departement -->
                                  <%
                  Vector vctDept = new Vector();
                  Vector vUsrCustomDepartment = PstDataCustom.getDataCustom(userOID, "hrdepartment");
                  if(vUsrCustomDepartment!=null && vUsrCustomDepartment.size()>0){
                  int iDataCustomCount = vUsrCustomDepartment.size();
                    for(int i=0; i<iDataCustomCount; i++){
                        DataCustom objDataCustom = (DataCustom) vUsrCustomDepartment.get(i);
                        Department dept = new Department();
                        try{
                            dept = PstDepartment.fetchExc(Long.parseLong(objDataCustom.getDataValue()));
                        }catch(Exception e){
                            System.out.println("Err >> department : "+e.toString());
                        }
                        vctDept.add(dept);
                    }
                  }

                 Vector vectDeptKey = new Vector();
                 Vector vectDeptName = new Vector();
                 vectDeptKey.add("0");
                 vectDeptName.add(strCmbFirstSelection);
                 int iDeptSize = vctDept.size();
                 for (int deptNum = 0; deptNum < iDeptSize; deptNum++){
                     Department dept = (Department) vctDept.get(deptNum);
                     vectDeptKey.add(String.valueOf(dept.getOID()));
                     vectDeptName.add(dept.getDepartment());

                 }
                 String strSelectedDept = String.valueOf(departmentOid);
                 if(departmentOid==0 && iDeptSize==1){
                    strSelectedDept = String.valueOf(vectDeptKey.get(0));
                 }
                %>
                                  <!--  ---------------------------- End Update -------------------------	-->
                                  <%=ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_DEPARTMENT_ID], "", null, strSelectedDept, vectDeptKey, vectDeptName)%> <span class="fielderror">&nbsp;&nbsp;*)&nbsp;&nbsp;<%=frmPerkiraan.getErrorMsg(frmPerkiraan.FRM_DEPARTMENT_ID)%></span> </td>
                            </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td width="15%" nowrap>&nbsp;<%=getJspTitle(textJspTitle,0,SESS_LANGUAGE,currPageTitle,true)%></td>
                        <td width="2%"><div align="center"><b>:</b></div></td>
                        <td colspan="4" width="83%"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr>
                              <td><%
								  Vector accCodeKey = new Vector(1,1);
								  Vector accOptionStyle = new Vector(1,1);
								  Vector accCodeVal = new Vector(1,1);
								  String strSelect = String.valueOf(perkiraan.getIdParent());																	  

								  Vector listCode = new Vector(1,1);
								  for (int item=0; item < vectSize; item++) 
								  {
									 Perkiraan account = (Perkiraan) vectAccountList.get(item);
									 if (account.getPostable() == PstPerkiraan.ACC_NOTPOSTED)									 
									 {		 									 
										 listCode.add(account);
									 }
								  }  								  

								  if(listCode!=null && listCode.size()>0)
								  {
										String space = "";
										String style = "";
										for(int i=0; i<listCode.size(); i++)
										{  
										   Perkiraan perk = (Perkiraan)listCode.get(i); 
										   switch(perk.getLevel())
										   {
											   case 1 : space = ""; style= "Style=\"font-weight:bold; color:#000000\""; break; 
											   case 2 : space = "&nbsp;&nbsp;&nbsp;&nbsp;"; style= "Style=\"font-weight:bold; color:#000000\""; break;
											   case 3 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; style= "Style=\"font-weight:bold; color:#000000\""; break;
											   case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; style= "Style=\"font-weight:bold; color:#000000\"";break;
											   case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; style= "Style=\"font-weight:bold; color:#000000\""; break;
											   case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; style= "Style=\"font-weight:bold; color:#000000\""; break;															    															   															   															   															   
										   }
										   accCodeKey.add(""+perk.getOID());
										   accOptionStyle.add(style);
										   accCodeVal.add(space + perk.getNoPerkiraan() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+perk.getNama()) ; 
									 } 
								  }																																				  
								%>
                                  <%=ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_IDPARENT], strNoAccSelected,strSelect,accCodeKey,accCodeVal)%></td>
                            </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td width="15%" nowrap>&nbsp;<%=getJspTitle(textJspTitle,1,SESS_LANGUAGE,currPageTitle,true)%></td>
                        <td width="2%"><div align="center"><b>:</b></div></td>
                        <td colspan="4" width="83%"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr>
                              <td valign="top"><input type="text" name="<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_NOPERKIRAAN] %>" value="<%=perkiraan.getNoPerkiraan()%>" maxlength="9" size="7">
                                  <span class="fielderror">&nbsp;*)&nbsp;&nbsp;<%=frmPerkiraan.getErrorMsg(frmPerkiraan.FRM_NOPERKIRAAN)%></span></td>
                            </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td width="15%" nowrap>&nbsp;<%=getJspTitle(textJspTitle,2,SESS_LANGUAGE,currPageTitle,true)%></td>
                        <td width="2%"><div align="center"><b>:</b></div></td>
                        <td colspan="4" width="83%"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr>
                              <td><input type="text" name="<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_NAMA] %>" size="60" value="<%=perkiraan.getNama()%>">
                                  <span class="fielderror">&nbsp;*)&nbsp;&nbsp;(Indonesia)&nbsp;&nbsp;<%=frmPerkiraan.getErrorMsg(frmPerkiraan.FRM_NAMA)%><b></b></span> </td>
                            </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td width="15%"></td>
                        <td width="2%"></td>
                        <td colspan="4" width="83%"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr>
                              <td><input type="text" name="<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_ACCOUNT_NAME_ENGLISH]%>" size="60" value="<%=perkiraan.getAccountNameEnglish()%>">
                                  <span class="fielderror">&nbsp;*)&nbsp;&nbsp;(English)&nbsp;&nbsp;<%=frmPerkiraan.getErrorMsg(frmPerkiraan.FRM_ACCOUNT_NAME_ENGLISH)%></span> </td>
                            </tr>
                        </table></td>
                      </tr>
                      <%if(iCommand != Command.ADD){%>
                      <tr>
                        <td width="15%" height="36" nowrap>&nbsp;<%=getJspTitle(textJspTitle,7,SESS_LANGUAGE,currPageTitle,true)%></td>
                        <td width="2%" height="36"><div align="center"><b>:</b></div></td>
                        <td colspan="4" width="83%" height="36"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr>
                              <td><input type="text" name="budget" size="30" value="<%=frmPerkiraan.userFormatStringDecimal(dBudget)%>" class="cmbDisabledStyle" readonly style="text-align: right">
                                &nbsp;&nbsp;&nbsp;<a href="javascript:cmdEditBudget()"><b>Edit&nbsp;<%=getJspTitle(textJspTitle, 7, SESS_LANGUAGE, "", false)%></b></a> </td>
                            </tr>
                        </table></td>
                      </tr>
                      <%}//if(iCommand != Command.ADD){%>
                      <!-- tr>
                       <td width="11%" nowrap>&nbsp;<%//=getJspTitle(textJspTitle, 8, SESS_LANGUAGE, "", false)%></td>
                       <td width="2%" align="center"><b>:</b></td>
                       <td colspan="4" width="87%">
                        <table border="0" cellspacing="0" cellpadding="0">
                         <tr>
                          <td width="62">
                          <input type="text" size="6" name="<%//=frmPerkiraan.fieldNames[frmPerkiraan.FRM_WEIGHT]%>" value="<%//=Formater.formatNumber(perkiraan.getWeight(), "##,###.##")%>" style="text-align: right;"></td>
                          <td width="138">&nbsp;&nbsp;%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%//=getJspTitle(textJspTitle, 9, SESS_LANGUAGE, "", false)%>&nbsp;&nbsp;</td>
                          <td width="70">
                          <%
                           Vector vectAccKey = new Vector();
                           Vector vectAccName = new Vector();
                           
                           for (int item = 0; item < vectSize; item++) {
                                Perkiraan account = (Perkiraan) vectAccountList.get(item);
                                String strName = "";
                                switch (account.getLevel()) {
                                case 1 : strName = "";
                                break;
                                case 2 : strName = "&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                                case 3 : strName = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                                case 4 : strName = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                                case 5 : strName = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                                case 6 : strName = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                                default : ;
                                }
                                strName += account.getNoPerkiraan();
                                if (account.getPostable()==PstPerkiraan.ACC_POSTED) {
                                    strName += "&nbsp;&nbsp;&nbsp;&nbsp;";
                                    vectAccKey.add(String.valueOf(account.getOID()));
                                } else {
                                    strName += "&nbsp;&nbsp;>>&nbsp;&nbsp;";
                                    vectAccKey.add(String.valueOf(0 - account.getOID()));
                                }    
                                strName += account.getNama();
                                vectAccName.add(strName);
                           }
                          	String strSelectedAcc = String.valueOf(perkiraan.getGeneralAccountLink());
                          %>
                          <%//=ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_GENERAL_ACCOUNT_LINK], strNoAccSelected, strSelectedAcc, vectAccKey, vectAccName)%>
                          </td>
                         </tr>
                        </table>
                       </td>
                      </tr -->
                      <tr>
                        <td width="15%" nowrap>&nbsp;<%=getJspTitle(textJspTitle,3,SESS_LANGUAGE,"",false)%></td>
                        <td width="2%"><div align="center"><b>:</b></div></td>
                        <td colspan="4" width="83%"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr>
                              <td><select name="<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_LEVEL] %>" onChange="javascript:cmdChangeLevel()" style="width: 50">
                                  <% int levelValue = perkiraan.getLevel(); 
								     if(levelValue>0){ 
								    	for(int i=1;i<7;i++) {
							        	   if (levelValue==i) { 
								  %>
                                  <option value="<%=i%>" selected><%=i%></option>
                                  <%       } else { 
			   					  %>
                                  <option value="<%=i%>"><%=i%></option>
                                  <%       } 
					    			} 
								  %>
                                  <% } else {
								  %>
                                  <option value="1" selected>1</option>
                                  <% 	 for(int i=2;i<7;i++) { 
								 %>
                                  <option value="<%=i%>"><%=i%></option>
                                  <%   } 
					   			  } 
								 %>
                                </select>
                                  <span class="fielderror"><%=frmPerkiraan.getErrorMsg(frmPerkiraan.FRM_LEVEL)%></span></td>
                            </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="27" nowrap>&nbsp;<%=textJspTitle[SESS_LANGUAGE][13]%></td>
                        <td height="27"><div align="center"><b>:</b></div></td>
                        <td colspan="4" height="27"><input name="<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_ARAP_ACCOUNT]%>" type="checkbox" value="1" <%if(perkiraan.getArapAccount() == 1){%>checked<%}%>>
                          &nbsp;&nbsp;<%=textJspTitle[SESS_LANGUAGE][12]%> </td>
                      </tr> 
					  <%if(iAccountGroup == PstPerkiraan.ACC_GROUP_EXPENSE){%>               
                      <tr>
                        <td nowrap>&nbsp;<%=textJspTitle[SESS_LANGUAGE][14]%></td>
                        <td><b><div align="center">:</div></b></td>
                        <td colspan="4"><%
								out.println(ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_EXPENSE_TYPE], null,""+perkiraan.getExpenseType(),PstPerkiraan.getExpTypeVal(SESS_LANGUAGE),PstPerkiraan.getExpTypeKey(SESS_LANGUAGE),"onChange=\"javascript:chgExpenseType()\""));
							%>                          &nbsp;&nbsp;
                          <%//=textJspTitle[SESS_LANGUAGE][14]%>						</td>
                      </tr>
                      <tr id="fixedvar">
                        <td nowrap>&nbsp;<%=textJspTitle[SESS_LANGUAGE][15]%></td>
                        <td><b><div align="center">:</div></b></td>
                        <td colspan="4">
							<%
								out.println(ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_EXPENSE_FIXED_VARIABLE], null,""+perkiraan.getExpenseFixedVar(),PstPerkiraan.getExpFVVal(SESS_LANGUAGE),PstPerkiraan.getExpFVKey(SESS_LANGUAGE)));
							%>							
                          &nbsp;&nbsp;<%//=textJspTitle[SESS_LANGUAGE][15]%>						</td>
                      </tr>
					  <%}%>
                      <tr>
                        <td width="15%" nowrap>&nbsp;<%=getJspTitle(textJspTitle,4,SESS_LANGUAGE,"",false)%></td>
                        <td width="2%"><div align="center"><b>:</b></div></td>
                        <td colspan="4" width="83%"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr>
                              <td width="6%"><%
								/*
								public static final int ACC_NOTPOSTED  = 0;
								public static final int ACC_POSTED 	   = 1;
								public static String[][] arrStrPostable = 
								{
									{
										"Header",
										"Postable",        
									},
									{
										"Header",
										"Postable",                    
									}
								};
								*/    
								%>
                                  <%
								  Vector valNormalSign = new Vector(1,1);																									
								  Vector keyNormalSign = new Vector(1,1);
								  
								  valNormalSign.add(""+PstPerkiraan.ACC_DEBETSIGN);					
								  keyNormalSign.add(""+PstPerkiraan.arrStrNormalSign[SESS_LANGUAGE][PstPerkiraan.ACC_DEBETSIGN]);
								  
								  valNormalSign.add(""+PstPerkiraan.ACC_KREDITSIGN);					
								  keyNormalSign.add(""+PstPerkiraan.arrStrNormalSign[SESS_LANGUAGE][PstPerkiraan.ACC_KREDITSIGN]);								  
																																																								  
								  out.println(ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_TANDA_DEBET_KREDIT],null,""+perkiraan.getTandaDebetKredit(),valNormalSign,keyNormalSign,""));
								  out.println("<span class=\"fielderror\">"+frmPerkiraan.getErrorMsg(frmPerkiraan.FRM_TANDA_DEBET_KREDIT)+"</span>");
								%>                              </td>
                            </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td width="15%" nowrap>&nbsp;<%=getJspTitle(textJspTitle,5,SESS_LANGUAGE,"",false)%></td>
                        <td width="2%"><div align="center"><b>:</b></div></td>
                        <td colspan="4" width="83%"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr>
                              <td><%
								  Vector valPostable = new Vector(1,1);																									
								  Vector keyPostable = new Vector(1,1);
								  
								  valPostable.add(""+PstPerkiraan.ACC_NOTPOSTED);					
								  keyPostable.add(""+PstPerkiraan.arrStrPostable[SESS_LANGUAGE][PstPerkiraan.ACC_NOTPOSTED]);
								  
								  valPostable.add(""+PstPerkiraan.ACC_POSTED);					
								  keyPostable.add(""+PstPerkiraan.arrStrPostable[SESS_LANGUAGE][PstPerkiraan.ACC_POSTED]);								  

								  String selectedPostable = ""+perkiraan.getPostable();																																																  
								  out.println(ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_POSTABLE],null,selectedPostable,valPostable,keyPostable,""));								  
								%>                              </td>
                            </tr>
                        </table></td>
                      </tr>
                      <%if(iCommand == Command.ASK){%>
                      <tr>
                        <td colspan="6" height="27"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr>
                              <td width="97%" class="msgquestion"><div align="center"><%=delConfirm%></div></td>
                            </tr>
                        </table></td>
                      </tr>
                      <%}%>
                      <% if ((ctrlPerkiraan.getMessage()).length() > 0) { %>
                      <tr>
                        <td height="15" align="center" colspan="6" id=errMsg class="msgerror" bgcolor="#ebebeb"><%=ctrlPerkiraan.getMessage()%></td>
                      </tr>
                      <% } %>
                      <tr>
                        <td height="10" width="15%"></td>
                      </tr>
                      <tr>
                        <td colspan="6" class="command"><%if((privAdd)&&(privUpdate)&&(privDelete)){%>
                            <% if(iCommand!=Command.ASK){  %>
                            <a href="javascript:cmdSave()"><%=strSaveAcc%></a> |
                          <%   if((iCommand != Command.ADD) && !((iCommand == Command.SAVE) && (iAccountOID < 1)) && PstPerkiraan.isFreeAccount(iAccountOID)){ %>
                            <a href="javascript:cmdAsk('<%=iAccountOID%>')"><%=strAskAcc%></a> |
                          <%   }
					     	 } else {
						  %>
                            <a href="javascript:cmdCancel()"><%=strCancel%></a> | <a href="javascript:cmdDelete('<%=iAccountOID%>')"><%=strDeleteAcc%></a> |
                          <% }
						  }
						  %>
                          <a href="javascript:cmdBackList()"><%=strBackAcc%></a> </td>
                      </tr>
                      <tr>
                        <td colspan="6" class="command">&nbsp;</td>
                      </tr>
                      <script language="javascript">
							document.frmaccountchart.<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_DEPARTMENT_ID]%>.focus();
					  </script>
                      <%}%>
                    </table></td>
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