<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.system.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>

<!--package java-->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.PstBussCenterBudget" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.BussinessCenterBudget" %>

<!--package qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- use harisma class -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>

<% int  appObjCode =  0;
try{
 	AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_ACCOUNT_CART, AppObjInfo.OBJ_MASTERDATA_ACCOUNT_CART); 
 }catch(Exception e){
 	System.out.println("Exception on componseObjCode ::::: "+e.toString());  
 }%>
<%@ include file = "../../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privPrint=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

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

public String getJspTitle( String textJsp[][], int index, int language, String prefiks, boolean addBody)
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

public String drawList(HttpServletRequest request, int iCommand, long bussCenterId,  long periodId, Vector prevList, Vector objectClass, long oid, int language)
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
	//ctrlist.dataFormat(getJspTitle(textJspTitle,6,language,"",false),"20%","center","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,3,language,"",false),"7%","center","center");	
	ctrlist.dataFormat(getJspTitle(textJspTitle,5,language,"",false),"10%","center","left");
	ctrlist.dataFormat("Prev. Budget","10%","center","left");
        ctrlist.dataFormat(" ","10%","center","left");
	ctrlist.dataFormat("Budget","10%","center","left");

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
                boolean  prevOk = prevList!=null && prevList.size()==objectClass.size();                
		for (int i = 0; i < objectClass.size(); i++) 
		{
                         BussinessCenterBudget prevBud= prevOk? (BussinessCenterBudget)prevList.get(i): new BussinessCenterBudget();
                         BussinessCenterBudget accBud= (BussinessCenterBudget)objectClass.get(i);
                         Perkiraan perkiraan = accBud.getPerkiraan();
			 
			 if(oid==perkiraan.getOID())
			 {
			 	index =i;
			 }
                         
                        if(iCommand==Command.SAVE)
                        {
                            double dBdg = FRMQueryString.requestDouble(request, "C_"+perkiraan.getOID()+"");
                            accBud.setBudget(dBdg);
                            accBud.setIdPerkiraan(perkiraan.getOID());
                            accBud.setBussCenterId(bussCenterId);
                            accBud.setPeriodeId(periodId);
                            try{
                            if(accBud.getOID()>0){
                                PstBussCenterBudget.updateExc(accBud);
                            } else {
                                PstBussCenterBudget.insertExc(accBud);
                            }} catch(Exception exc){
                                System.out.println(exc);
                            }
                            
                        }
                         
                         
			 
	/*		 String strDepartment = "";
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
 * */
				
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
			 //rowx.add(strDepartment);
			 rowx.add(String.valueOf(lvl)); 
			 rowx.add(psn);
                         if(perkiraan.getPostable()==PstPerkiraan.ACC_POSTED){
                             rowx.add("<input type=\"text\" readonly name=\"P_"+ perkiraan.getOID() +"\" value=\""+ (prevOk? ((BussinessCenterBudget)prevList.get(i)).getBudget() :0 )+"\">");
                             rowx.add("<input type=\"button\" value=\">\" onClick=\"javascript:cmdCopyPrevBudget("+prevBud.getBudget()+",document.frmaccountchart.C_"+ perkiraan.getOID()+")\"/> ");                         
                             rowx.add("<input type=\"text\" name=\"C_"+ perkiraan.getOID() +"\" value=\""+ accBud.getBudget()+"\">");
                         } else{
                             rowx.add("");
                             rowx.add("");                         
                             rowx.add("");
                             
                         }

			 lstData.add(rowx);
		}
                if(objectClass.size()>0){
                            Vector rowx = new Vector();
                             rowx.add("");
                             rowx.add("");                         
                             rowx.add("");
                             rowx.add("");
                             rowx.add("Copy All ");
                             rowx.add("<input type=\"button\" value=\">>>\" onClick=\"cmdCopyAllPrevBudget()\"/> ");                         
                             rowx.add("");                         
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
long bussCenterId = FRMQueryString.requestLong(request,"bussCenterId");
long periodId = FRMQueryString.requestLong(request,"period_id");

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
int recordToGet = 500;


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
Vector vectAccountList = PstBussCenterBudget.listByAccountGroup(bussCenterId, periodId, iAccountGroup); //PstPerkiraan.getAllAccount(iAccountGroup, 0);
Vector vectAccPrevPeriod = PstBussCenterBudget.listByAccountGroup(bussCenterId, PstPeriode.getPrevPeriod(periodId), iAccountGroup);
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
    
function cmdCopyPrevBudget(valueX, object){
     object.value = valueX;
    }

function cmdCopyAllPrevBudget(){
    <% if(vectAccountList!=null){ 
	try 
	{ 								
                boolean  prevOk = vectAccPrevPeriod!=null && vectAccPrevPeriod.size()==vectAccountList.size();                
		for (int i = 0; i < vectAccountList.size(); i++) 
		{
                         BussinessCenterBudget prevBud= prevOk? (BussinessCenterBudget)vectAccPrevPeriod.get(i): new BussinessCenterBudget();
                         BussinessCenterBudget accBud= (BussinessCenterBudget)vectAccountList.get(i);                         
                         Perkiraan perkiraanX = accBud.getPerkiraan();
                         if(perkiraanX.getPostable()==PstPerkiraan.ACC_POSTED){
			 %> document.frmaccountchart.C_<%=perkiraanX.getOID()%>.value=<%=prevBud.getBudget()%>;<%="\n"%> <%
                         }
                }
	} 
	catch(Exception exc) 
	{
		System.out.println("Exc when drawList : " + exc.toString());
	}                    
        }%>
    }
    
function addNew(){
	document.frmaccountchart.accountchart_id.value="0";
	document.frmaccountchart.command.value="<%=Command.ADD%>";
	document.frmaccountchart.departmentOid.value = "0";
	document.frmaccountchart.companyId.value = "0";
	//document.frmaccountchart.<%//=frmPerkiraan.fieldNames[frmPerkiraan.FRM_ARAP_ACCOUNT]%>.value = "0";
	document.frmaccountchart.generalAccOid.value = "0";
	document.frmaccountchart.action="buss_ctr_budget.jsp";
	document.frmaccountchart.submit();
}

function cmdUpload(){
	document.frmaccountchart.command.value="<%=Command.SUBMIT%>";
	document.frmaccountchart.action="buss_ctr_budget.jsp";
	document.frmaccountchart.submit();
}

function cmdSave()
{ 		document.frmaccountchart.command.value="<%=Command.SAVE%>";
		document.frmaccountchart.action = "buss_ctr_budget.jsp#down";
		document.frmaccountchart.submit();		

}

function cmdAsk(oid){
	document.frmaccountchart.accountchart_id.value=oid;
	document.frmaccountchart.command.value="<%=Command.ASK%>";
	document.frmaccountchart.action="buss_ctr_budget.jsp#down";
	document.frmaccountchart.submit();
}

function cmdDelete(oid){
	document.frmaccountchart.accountchart_id.value=oid;
	document.frmaccountchart.command.value="<%=Command.DELETE%>";
	document.frmaccountchart.action="buss_ctr_budget.jsp";
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
	document.frmaccountchart.action="buss_ctr_budget.jsp#down";
	document.frmaccountchart.submit();
}

function cmdEdit(oid){
	document.frmaccountchart.accountchart_id.value=oid;
	document.frmaccountchart.departmentOid.value = "0";
	document.frmaccountchart.generalAccOid.value = "0";
	document.frmaccountchart.command.value="<%=Command.EDIT%>";
	document.frmaccountchart.action="buss_ctr_budget.jsp";
	document.frmaccountchart.submit();
}

function first(){
	document.frmaccountchart.list_command.value="<%=Command.FIRST%>";
	document.frmaccountchart.action="buss_ctr_budget.jsp";
	document.frmaccountchart.submit();
}
function prev(){
	document.frmaccountchart.list_command.value="<%=Command.PREV%>";
	document.frmaccountchart.action="buss_ctr_budget.jsp";
	document.frmaccountchart.submit();
}

function next(){
	document.frmaccountchart.list_command.value="<%=Command.NEXT%>";
	document.frmaccountchart.action="buss_ctr_budget.jsp";
	document.frmaccountchart.submit();
}
function last(){
	document.frmaccountchart.list_command.value="<%=Command.LAST%>";
	document.frmaccountchart.action="buss_ctr_budget.jsp";
	document.frmaccountchart.submit();
}

function cmdBackList(){
	document.frmaccountchart.command.value="<%=Command.NONE%>";
	document.frmaccountchart.list_command.value="<%=Command.LIST%>";
	document.frmaccountchart.action="buss_ctr_budget.jsp";
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
	document.frmaccountchart.action="buss_ctr_budget.jsp";
	document.frmaccountchart.submit();
}

function cmdClasification(){
	var classType = document.frmaccountchart.<%=frmPerkiraan.fieldNames[frmPerkiraan.FRM_ACCOUNT_GROUP]%>.value;	
	document.frmaccountchart.command.value="<%=Command.NONE%>";	
	document.frmaccountchart.list_command.value="<%=Command.LIST%>";
	document.frmaccountchart.accountchart_group.value=classType;
	document.frmaccountchart.action="buss_ctr_budget.jsp";
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
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
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
                  <td width="11%" height="23">Period</td>
                  <td height="23" width="2%">
                    <div align="center">:</div></td>
                  <td height="23" width="1%">
                    <%
                      String attrClass = "";//onChange=\"javascript:cmdClasification()\"";				  
                      String sOrderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL]+" DESC";
                      Vector vtPeriod = PstPeriode.list(0,0,"",sOrderBy);
                      Vector vPeriodKey = new Vector(1,1);
                      Vector vPeriodVal = new Vector(1,1);
                      for(int k=0;k<vtPeriod.size();k++){
                        Periode periode = (Periode)vtPeriod.get(k);

                        vPeriodKey.add(""+periode.getOID());
                        vPeriodVal.add(periode.getNama());
                      }
                      out.println(ControlCombo.draw("period_id","",null,""+periodId,vPeriodKey,vPeriodVal,attrClass));
				  %>                  </td> 
                </tr>
                <tr>
                  <td width="11%" height="23">Business Center</td>
                  <td height="23" width="2%">
                    <!-- <div align="center">:</div></td> -->
                  <td height="23" width="87%"><%
                        attrClass = "";//onChange='javascript:cmdClasification()';				  
                  	Vector vBisnisCenterVal = new Vector();
                        Vector vBisnisCenterKey = new Vector();
                        String selectedBisnisCenter = ""+bussCenterId;
                        Vector vBisnisCenter = PstBussinessCenter.list(0,0,"",PstBussinessCenter.fieldNames[PstBussinessCenter.FLD_BUSS_CENTER_NAME]);
                        if(vBisnisCenter.size() > 0){
                        for(int b = 0; b < vBisnisCenter.size(); b++){
                            BussinessCenter objBCenter = (BussinessCenter)vBisnisCenter.get(b);			
                            vBisnisCenterVal.add(""+objBCenter.getOID()); 
                            vBisnisCenterKey.add(objBCenter.getBussCenterName());
                        }
	}

                %>
                      <%=ControlCombo.draw("bussCenterId", null,  selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey,attrClass)%>                    </td>
                         
                </tr>

                <tr> 
                  <td width="11%" height="23"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><%=strAccGroup%> :</font></td>
                  <td height="23" width="2%">
                    <!-- <div align="center">:</div></td> -->
                  <td colspan="2">
                  <%
				  attrClass = "";// "onChange=\"javascript:cmdClasification()\"";				  
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
				  				  				  				  				  				  				  				  				  				  				  				  				  
				  out.println("&nbsp;"+ControlCombo.draw(frmPerkiraan.fieldNames[frmPerkiraan.FRM_ACCOUNT_GROUP]," - SELECT -",""+iAccountGroup,vectClassVal,vectClassKey,attrClass));
				  %>
                  </td>
                </tr>
                <tr>
                  <td width="11%" height="23"></td>
                  <td height="23" width="2%">&nbsp;</td>
                    <td height="23" width="1%"> <input type="button" value="List Budget" name="list" onClick="javascript:cmdClasification();"/></td>
                </tr>
                
                
              </table>	
              
              <table width="100%" cellpadding="0" cellspacing="0" class="listgenactivity">
                <tr> 
                  <td colspan="2"> 
				    <%
					/*Vector listPerkiraan = new Vector(1,1);
                                        
					for (int item=start; item<(start + recordToGet) && item<vectSize; item++) 
					{
						listPerkiraan.add(vectAccountList.get(item));
					}
                                        * */

                 	if((vectAccountList!=null)&&(vectAccountList.size()>0))
					{  
						out.println(drawList(request, iCommand, bussCenterId,  periodId, vectAccPrevPeriod, vectAccountList,perkiraan.getOID(),SESS_LANGUAGE)); 
					}
					else
					{
						out.println("<font size=\"2\" color=\"#FF0000\">&nbsp;No Account Available ...</font>");
					}
			  		%>                     
                    <% if((vectAccountList!=null)&&(vectAccountList.size()>0)) {%>
                    <table width="100%">
                      <tr> 
                          <td>&nbsp;</td>
                          <td><input type="button" value="Save Budget" name="savebudget" onClick="javascript:cmdSave()"/></td>
                      </tr>
                    </table>
                    <%}%>
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