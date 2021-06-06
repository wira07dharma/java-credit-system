<%@ page language="java" %>

<%@ page import = "java.util.*" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.form.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.periode.*" %>
<%@ page import="com.dimata.aiso.session.system.*" %>

<!-- use harisma class -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>

<!--import java-->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!--import qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_ACCOUNT_LINK, AppObjInfo.OBJ_MASTERDATA_ACCOUNT_LINK); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privUpdate && !privDelete){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<!-- JSP Block -->

<%!
public static final String pageTitle[] = {
	"Perkiraan","Account"	
};

public static final String linkTitle[] = {
	"Link Perkiraan","Account Link"	
};

// for list and editor single account link
public String drawListSingleAccount(int language, String strAccIndex, int iCommand, FrmAccountLink frmAccountLink, Vector objectClass, long accLinkId, Vector listAccount,long userOID){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("75%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
		
	String strHeader = strAccIndex;
	if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
		strHeader = pageTitle[language] +" "+ strHeader; 
	}else{
		strHeader = strHeader +" "+ pageTitle[language]; 
	}
	ctrlist.dataFormat("Department","20%","left","left");		
	ctrlist.dataFormat(strHeader,"80%","left","left");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdClickLink('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);	
	int index = -1;
	
	Vector vectVal = new Vector(1,1);	 
	Vector vectKey = new Vector(1,1);	 
    String space = "";
	if(listAccount!=null && listAccount.size()>0){
		for(int j=0; j<listAccount.size(); j++){
			Perkiraan per = (Perkiraan)listAccount.get(j); 
		    switch(per.getLevel()){
			   case 1 : space = "&nbsp;"; break; 
			   case 2 : space = "&nbsp;&nbsp;&nbsp;"; break;
			   case 3 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break; 															    															   															   															   															   
		    }			
			vectKey.add(""+per.getOID());
			vectVal.add(space + per.getNoPerkiraan() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+ (language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? per.getAccountNameEnglish() : per.getNama()));
		}
    }

    Vector vectDept = new Vector();
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
          vectDept.add(dept);
      }
    }

	 Hashtable hastDept = new Hashtable();
	 Vector vectDeptKey = new Vector();
	 Vector vectDeptName = new Vector();
	 if(vectDept!=null && vectDept.size()>0){
	 	int iDeptSize = vectDept.size();	 
		for (int deptNum = 0; deptNum < iDeptSize; deptNum++){
			 Department dept = (Department) vectDept.get(deptNum);
			 vectDeptKey.add(String.valueOf(dept.getOID()));
			 vectDeptName.add(dept.getDepartment()); 
			 hastDept.put(String.valueOf(dept.getOID()), dept.getDepartment());					                             
		}
	 }
	
	String namaAccount = "";
	String strSelected = "";		
	String attrFirst = "onChange=\"javascript:cmdChangeFirst()\"";	
	for(int i=0; i<objectClass.size(); i++){
		 AccountLink acc = (AccountLink)objectClass.get(i);
		 strSelected = String.valueOf(acc.getFirstId());			 
		 rowx = new Vector();
		 if(accLinkId == acc.getOID())
			 index = i; 

		 if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_DEPARTMENT_ID],null,""+acc.getDepartmentOid(),vectDeptKey, vectDeptName,""));
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID],null,strSelected,vectKey,vectVal,attrFirst));
		 }else{ 			
			Vector listAccountFirst = PstPerkiraan.findFieldPerkiraan(acc.getFirstId());		 
			if(listAccountFirst!=null && listAccountFirst.size()>0){
				Perkiraan account = (Perkiraan)listAccountFirst.get(0);
				namaAccount = (language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama()); 
			}													 		 		 
			rowx.add(hastDept.get(""+acc.getDepartmentOid()));
			rowx.add(namaAccount);
		 } 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(acc.getOID()));	 		 		 
	 }
	 
	 rowx = new Vector();
	 if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmAccountLink.errorSize()>0)){ 
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_DEPARTMENT_ID],null,"",vectDeptKey, vectDeptName,""));	 
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID],null,"",vectKey,vectVal,attrFirst));
	 }		
	 lstData.add(rowx);

	 return ctrlist.drawMe(index);
}

// for list and editor pair account link
public String drawListPairAccount(int language, int iCommand, FrmAccountLink frmAccountLink, Vector objectClass, long accLinkId, Vector listAccount, Vector list2ndAccount, long userOID){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat("Department","20%","left","left");
	ctrlist.dataFormat("Sales Account","40%","left","left");
	ctrlist.dataFormat("Costs Account","40%","left","left");	

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdClickLink('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);	
	int index = -1;
	
	Vector vectVal = new Vector(1,1);	 
	Vector vectKey = new Vector(1,1);	 
    String space = "";
	if(listAccount!=null && listAccount.size()>0){
		for(int j=0; j<listAccount.size(); j++){
			Perkiraan per = (Perkiraan)listAccount.get(j); 
		    switch(per.getLevel()){
			   case 1 : space = "&nbsp;"; break; 
			   case 2 : space = "&nbsp;&nbsp;&nbsp;"; break;
			   case 3 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break; 															    															   															   															   															   
		    }			
			vectKey.add(""+per.getOID());
			vectVal.add(space + per.getNoPerkiraan() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+(language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? per.getAccountNameEnglish() : per.getNama()));						
		}
	}
	
	Vector vectVal2 = new Vector(1,1);	 
	Vector vectKey2 = new Vector(1,1);	 
    String space2 = "";
	if(list2ndAccount!=null && list2ndAccount.size()>0){
		for(int j=0; j<list2ndAccount.size(); j++){
			Perkiraan per = (Perkiraan)list2ndAccount.get(j); 
		    switch(per.getLevel()){
			   case 1 : space = "&nbsp;"; break; 
			   case 2 : space = "&nbsp;&nbsp;&nbsp;"; break;
			   case 3 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break; 															    															   															   															   															   
		    }			
			vectKey2.add(""+per.getOID());
			vectVal2.add(space + per.getNoPerkiraan() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+ (language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? per.getAccountNameEnglish() : per.getNama()));
		}
	}
	
	 // daftar department
	//String strWhere = "";
	// String strOrder = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT];
	// Vector vectDept = PstDepartment.list(0, 0, strWhere, strOrder);

    Vector vectDept = new Vector();
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
          vectDept.add(dept);
      }
    }

	 Hashtable hastDept = new Hashtable();
	 Vector vectDeptKey = new Vector();
	 Vector vectDeptName = new Vector();
	 if(vectDept!=null && vectDept.size()>0)
	 {
	 	int iDeptSize = vectDept.size();	 
		for (int deptNum = 0; deptNum < iDeptSize; deptNum++) 
		{
			 Department dept = (Department) vectDept.get(deptNum);
			 vectDeptKey.add(String.valueOf(dept.getOID()));
			 vectDeptName.add(dept.getDepartment()); 
			 hastDept.put(String.valueOf(dept.getOID()), dept.getDepartment());					                             
		}
	 }


	String namaAccount1 = "";
	String namaAccount2 = "";	
	String strSelect1 = "";		
	String strSelect2 = "";
	String attrFirst = "onChange=\"javascript:cmdChangeFirst()\" onBlur=\"javascript:cmdSmallerFirst()\" onFocus=\"javascript:cmdSmallerSecond()\"";	
	String attrSecond = "onChange=\"javascript:cmdChangeSecond()\" onBlur=\"javascript:cmdSmallerSecond()\" onFocus=\"javascript:cmdSmallerFirst()\"";
	for (int i = 0; i < objectClass.size(); i++) {
		 AccountLink acc = (AccountLink)objectClass.get(i);
		 strSelect1 = String.valueOf(acc.getFirstId());			 		 
		 strSelect2 = String.valueOf(acc.getSecondId());			 		 		 
		 rowx = new Vector();
		 if(accLinkId == acc.getOID())
			 index = i; 

		 if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_DEPARTMENT_ID],null,""+acc.getDepartmentOid(),vectDeptKey, vectDeptName,""));
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID],null,strSelect1,vectKey,vectVal,attrFirst));
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_SECOND_ID],null,strSelect2,vectKey2,vectVal2,attrSecond));			
		 }else{ 			
			Vector listAccountFirst = PstPerkiraan.findFieldPerkiraan(acc.getFirstId());		 
			if(listAccountFirst!=null && listAccountFirst.size()>0){
				Perkiraan account1 = (Perkiraan)listAccountFirst.get(0);
				namaAccount1 = (language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account1.getAccountNameEnglish() : account1.getNama()); 
			}													 		 		 
			Vector listAccountSecond = PstPerkiraan.findFieldPerkiraan(acc.getSecondId());		 
			if(listAccountSecond!=null && listAccountSecond.size()>0){
				Perkiraan account2 = (Perkiraan)listAccountSecond.get(0);
				namaAccount2 = (language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account2.getAccountNameEnglish() : account2.getNama()); 
			}													 		 		 		 
			rowx.add(hastDept.get(""+acc.getDepartmentOid()));
			rowx.add(namaAccount1);
			rowx.add(namaAccount2);			
		 } 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(acc.getOID()));	 		 		 		 
	 }
	 
	 rowx = new Vector();
	 if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmAccountLink.errorSize()>0)){ 
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_DEPARTMENT_ID],null,"",vectDeptKey, vectDeptName,""));			
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID],null,"",vectKey,vectVal,attrFirst));
			rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_SECOND_ID],null,"",vectKey2,vectVal2,attrSecond)); 
	 }		
	 lstData.add(rowx);
	 		 
	 return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
long accLinkId = FRMQueryString.requestLong(request,"accLinkId");
int postableFirst = FRMQueryString.requestInt(request,"postableFirst");
int postableSecond = FRMQueryString.requestInt(request,"postableSecond");
int linkType = FRMQueryString.requestInt(request,"account_link_type");

if(linkType==PstPerkiraan.ACC_GROUP_ALL){
    linkType = PstPerkiraan.ACC_GROUP_CASH;
}
// ControlLine and Commands caption
ControlLine ctrLine = new ControlLine();
String currPageTitle = linkTitle[SESS_LANGUAGE];
String strAddLink = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveLink = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskLink = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteLink = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
String strAccGroup = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Group Account Link" : "Kelompok Perkiraan";
String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Data is saved" : "Data tersimpan";
String strNoLink = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "No "+currPageTitle+" Available" : "Tidak Ada "+currPageTitle; 

// Controlist and Action process
CtrlAccountLink ctrlAccountLink = new CtrlAccountLink(request);
ctrlAccountLink.setLanguage(SESS_LANGUAGE);
int ctrlErr = ctrlAccountLink.action(iCommand,accLinkId);
FrmAccountLink frmAccountLink = ctrlAccountLink.getForm(); 
AccountLink accountLink = ctrlAccountLink.getAccountLink();

// List account link
String order = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];
String whereLink = PstAccountLink.fieldNames[PstAccountLink.FLD_LINKTYPE]+" = "+linkType;
String ordLink = PstAccountLink.fieldNames[PstAccountLink.FLD_LINKTYPE];
Vector listAccountLink = PstAccountLink.list(0,0,whereLink,ordLink);

// list account chart
Vector listFirstAccountChart = new Vector(1,1);
Vector listSecondAccountChart = new Vector(1,1);
switch(linkType)
{
	case PstPerkiraan.ACC_GROUP_CASH : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_LIQUID_ASSETS);
		break;	
		
	case PstPerkiraan.ACC_GROUP_BANK : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_LIQUID_ASSETS);
		break;
		
	case PstPerkiraan.ACC_GROUP_PETTY_CASH : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_LIQUID_ASSETS);
		break;
		
	case PstPerkiraan.ACC_GROUP_FUND : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_EQUITY);
		break;
		
		//-------- baru
	case PstPerkiraan.ACC_GROUP_PIUTANG: 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_LIQUID_ASSETS);
		break;	
	
	case PstPerkiraan.ACC_GROUP_INVENTORY: 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_LIQUID_ASSETS);
		break;		
		
	case PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES: 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES);
		break;
	
	case PstPerkiraan.ACC_GROUP_GROSS_PROFIT : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_REVENUE);
		listSecondAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_COST_OF_SALES);		
		break;		
		
	case PstPerkiraan.ACC_GROUP_COST_OF_SALES : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_COST_OF_SALES);	
		break;	
	
	case PstPerkiraan.ACC_GROUP_EXPENSE : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_EXPENSE);	
		break;				
	
	case PstPerkiraan.ACC_GROUP_INCOME_TAXES : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_EXPENSE);
		break;		
	
	case PstPerkiraan.ACC_GROUP_EQUITY : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_EQUITY);
		break;
		
	case PstPerkiraan.ACC_GROUP_PERIOD_EARNING : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_EQUITY);
		break;		
	
	case PstPerkiraan.ACC_GROUP_YEAR_EARNING : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_EQUITY);
		break;		
	
	case PstPerkiraan.ACC_GROUP_RETAINED_EARNING : 
		listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_EQUITY);
		break;

        // -------- baru
    case PstPerkiraan.ACC_GROUP_FIXED_ASSETS :
        listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_FIXED_ASSETS);
        break;

    case PstPerkiraan.ACC_GROUP_AKU_PENYUSUTAN :
        listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_FIXED_ASSETS);
        break;
	
    case PstPerkiraan.ACC_GROUP_REVENUE:
        listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_REVENUE);
        break;
    
    case PstPerkiraan.ACC_GROUP_BIAYA_PENYUSUTAN :
        listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_EXPENSE);
        break;
    case PstPerkiraan.ACC_GROUP_OTHER_REVENUE :
        listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_OTHER_REVENUE);
        break;

    case PstPerkiraan.ACC_GROUP_OTHER_EXPENSE :
        listFirstAccountChart = PstPerkiraan.getAccountByGroup(PstPerkiraan.ACC_GROUP_OTHER_EXPENSE);
        break;		
		

	default :
		break;		
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdSearchLink(){
	document.frmaccountlink.command.value="<%=Command.NONE%>";
	document.frmaccountlink.accLinkId.value=0;
	document.frmaccountlink.action="account_link.jsp"; 
	document.frmaccountlink.submit();
}

<%if((privAdd)&&(privUpdate)&&(privDelete)){%>
function addNew(){
	document.frmaccountlink.command.value="<%=Command.ADD%>";
	document.frmaccountlink.accLinkId.value=0;
	document.frmaccountlink.action="account_link.jsp";
	document.frmaccountlink.submit();
}


function cmdSaveXX(){
	<%if(linkType!=PstPerkiraan.ACC_GROUP_GROSS_PROFIT){%>	
		var postFirstValue = document.frmaccountlink.postableFirst.value;
		if(postFirstValue==1){
			document.frmaccountlink.command.value="<%=Command.SAVE%>";
			document.frmaccountlink.action="account_link.jsp";
			document.frmaccountlink.submit();
		}else{
			if(postFirstValue==0){
				//msgPostable.innerHTML = "<i>&nbsp;Please choose an account ...</i>";					
			}else{
				//msgPostable.innerHTML = "<i>&nbsp;Cannot process, non postable account ...</i>";			
			}
		}
	<%}else{%>	
		var postFirstValue = document.frmaccountlink.postableFirst.value;
		var postSecondValue = document.frmaccountlink.postableSecond.value;	
		document.frmaccountlink.command.value="<%=Command.SAVE%>";
		document.frmaccountlink.action="account_link.jsp";
		document.frmaccountlink.submit();
		/*if(postFirstValue==1&&postSecondValue==1){
			document.frmaccountlink.command.value="<%=Command.SAVE%>";
			document.frmaccountlink.action="account_link.jsp";
			document.frmaccountlink.submit();
		}else{
			if(postFirstValue==0 && postSecondValue==0){
				//msgPostable.innerHTML = "<i>&nbsp;Please choose an account ...</i>";					
			}else{
				//msgPostable.innerHTML = "<i>&nbsp;Cannot process, non postable account ...</i>";			
			}
		}	*/
	<%}%>	
}

function cmdSave(){
	document.frmaccountlink.command.value="<%=Command.SAVE%>";
	document.frmaccountlink.action="account_link.jsp";
	document.frmaccountlink.submit();
}

function cmdAsk(oidFirst){
	document.frmaccountlink.command.value="<%=Command.ASK%>";
	document.frmaccountlink.accLinkId.value=oidFirst;	
	document.frmaccountlink.action="account_link.jsp";
	document.frmaccountlink.submit();
}
 
function cmdDelete(oidFirst){
	document.frmaccountlink.command.value="<%=Command.DELETE%>";
	document.frmaccountlink.accLinkId.value=oidFirst;	
	document.frmaccountlink.action="account_link.jsp";
	document.frmaccountlink.submit();
}
<%}%>

function cmdCancel(){
	document.frmaccountlink.command.value="<%=Command.NONE%>";
	document.frmaccountlink.accLinkId.value=0;
	document.frmaccountlink.postableFirst.value="0";
	document.frmaccountlink.postableSecond.value="0";	
	document.frmaccountlink.action="account_link.jsp";
	document.frmaccountlink.submit();
}

function cmdClickLink(idLink){
	 document.frmaccountlink.postableFirst.value="1";
	 document.frmaccountlink.postableSecond.value="1";	
     document.frmaccountlink.accLinkId.value=idLink; 
	 document.frmaccountlink.command.value="<%=Command.EDIT%>";
	 document.frmaccountlink.action="account_link.jsp";
	 document.frmaccountlink.submit();  
}

<%if(iCommand!=Command.NONE || iCommand!=Command.SUBMIT){%>
function cmdChangeFirst(){  
  var selVal = document.frmaccountlink.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID]%>.value;  
  switch(selVal){  
  <%for(int i=0;i<listFirstAccountChart.size();i++){
	 Perkiraan p = (Perkiraan)listFirstAccountChart.get(i);
	 long oid = p.getOID(); 
	%>
	 case "<%=oid%>" : <%if(p.getPostable() ==  PstPerkiraan.ACC_POSTED){%>
					 <%}else{%>
	 					document.frmaccountlink.postableFirst.value="-1";
						<%//if(!(linkType==ctrlAccountLink.TYPE_FIXEDASSET || linkType==ctrlAccountLink.TYPE_OTHERASSET)){%>
								
						<%//}%>
					 <%}%>  				  
					 break;
  <%}%>
	 default :	
	 alert("Please select an account");
	 break;
  }	 
}


function cmdChangeSecond(){
  
  var selVal = document.frmaccountlink.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_SECOND_ID]%>.value;
  
  switch(selVal){  
  <%for(int i=0;i<listFirstAccountChart.size();i++){
	 Perkiraan p = (Perkiraan)listFirstAccountChart.get(i);
	 long oid = p.getOID(); 	 
	 %>
	 case "<%=oid%>" : <%if(p.getPostable() ==  PstPerkiraan.ACC_POSTED){%>
	 					document.frmaccountlink.postableSecond.value="1";
					 <%}else{%>
	 					document.frmaccountlink.postableSecond.value="-1";	
					 <%}%>  				  
					 break;
  <%}%>
	 default :	
	 break;
  }	 
}
<%}%>

function cmdTypeChange(){
	var typeValue = document.frmaccountlink.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_TYPE]%>.value;
	//if(typeValue==<%//=ctrlAccountLink.TYPE_CASH_FLOW%>){
		document.frmaccountlink.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_SECOND_ID]%>.disabled="yes";
	//}
}

function cmdSmallerFirst(){
	document.all.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID]%>.style.width="483";
	document.all.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_SECOND_ID]%>.style.width="500";	
}

function cmdSmallerSecond(){
	document.all.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID]%>.style.width="500";
	document.all.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_SECOND_ID]%>.style.width="483";	
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->Masterdata 
            : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmaccountlink" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.LIST%>">
              <input type="hidden" name="accLinkId" value="<%=accLinkId%>">
              <input type="hidden" name="postableFirst" value="<%=postableFirst%>">
              <input type="hidden" name="postableSecond" value="<%=postableSecond%>">
              <input type="hidden" name="<%=frmAccountLink.fieldNames[frmAccountLink.FRM_TYPE]%>" value="<%=linkType%>">			  			  
              <table width="100%">
                <tr> 
                  <td> 
                     <table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
					 	<tr>
							<td>
								<table width="100%" cellpadding="0" cellspacing="1" class="search02">
                            <tr>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="25%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><%=strAccGroup%> : </font>
                              <%
							  Vector linkTypeKey = new Vector(1,1);
							  Vector linkTypeValue = new Vector(1,1);							   										  																									  								 							

							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_CASH);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_CASH]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_PETTY_CASH);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_PETTY_CASH]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_BANK);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_BANK]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_PIUTANG);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_PIUTANG]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_INVENTORY);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_INVENTORY]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_FUND);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_FUND]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_FIXED_ASSETS);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_FIXED_ASSETS]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_AKU_PENYUSUTAN);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_AKU_PENYUSUTAN]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_REVENUE);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_REVENUE]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_COST_OF_SALES);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_COST_OF_SALES]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_EXPENSE);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_EXPENSE]);
							 
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_BIAYA_PENYUSUTAN);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_BIAYA_PENYUSUTAN]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_OTHER_REVENUE);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_OTHER_REVENUE]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_OTHER_EXPENSE);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_OTHER_EXPENSE]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_PERIOD_EARNING);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_PERIOD_EARNING]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_EQUITY);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_EQUITY]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_YEAR_EARNING);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_YEAR_EARNING]);
							  
							  linkTypeKey.add(""+PstPerkiraan.ACC_GROUP_RETAINED_EARNING);					
							  linkTypeValue.add(""+PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_RETAINED_EARNING]);							  
							  
							  String strSelType = String.valueOf(linkType);
							  String attrType = "onChange=\"javascript:cmdSearchLink()\"";
							  %>
                                <%=ControlCombo.draw("account_link_type",null,strSelType,linkTypeKey,linkTypeValue,attrType)%> </td>
                            </tr>
							
                            <!-- No journal detail available -->
                            <% if(listAccountLink.size()==0 && (iCommand==Command.NONE || iCommand==Command.DELETE)){ %>
								<tr> 
								  <td colspan="2" height="8">&nbsp;&nbsp; 									
                                  <font color="#FF0000"><%="&nbsp;"+strNoLink%></font>
								  </td>
								</tr>
								<%if(privAdd){%>
								<tr> 
								  <td colspan="2" height="16">&nbsp;</td>
								</tr>								
								<tr> 
								  <td colspan="2"class="command">&nbsp; 
									<div align="left"><a href="javascript:addNew()"><%=strAddLink%></a></div>
								  </td>
								</tr>
								<%}%>
                            <%}else{%>
								<tr> 
								  <td width="25%">&nbsp;
								  <%
								  if(linkType!=PstPerkiraan.ACC_GROUP_GROSS_PROFIT){
										out.println(drawListSingleAccount(SESS_LANGUAGE,PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][linkType],iCommand,frmAccountLink,listAccountLink,accLinkId,listFirstAccountChart,userOID));
								  }
								  else{
										out.println(drawListPairAccount(SESS_LANGUAGE,iCommand,frmAccountLink,listAccountLink,accLinkId,listFirstAccountChart,listSecondAccountChart,userOID));
								  }
								  %>
								  </td>
								</tr>
								<%if(iCommand == Command.ASK){%>
								<tr> 
								  <td colspan="2" class="msgquestion"> 
									
                                <div align="center"><%=delConfirm%></div>
								  </td>
								</tr>
								<%}%>
                            	<tr> 
									<%if(ctrlAccountLink.getMessage().length() > 0){%>
                              		<td class="msgerror" ID=msgPostable width="25%">
										<%=ctrlAccountLink.getMessage()%>								
									</td>
									<%}else{
										if(iCommand == Command.SAVE){
									%>
									<td class="msginfo" ID=msgPostable width="25%">
										<%=strSave%>
									</td>
									<%
										}
									}%>
	                            </tr>
								<tr> 
								  <td width="25%">&nbsp;
								  <%if((privAdd)&&(privUpdate)&&(privDelete)){%> 
									<%if(iCommand!=Command.ASK){%>
									<%if(iCommand==Command.NONE || iCommand==Command.DELETE){%>
									<span class="command"><a href="javascript:addNew()"><%=strAddLink%></a></span> 
									<%}%>
									<%if(iCommand==Command.ADD){%>
									<span class="command"><a href="javascript:cmdSave()"><%=strSaveLink%></a></span> | <span class="command"><a href="javascript:cmdCancel()"><%=strCancel%></a></span> 
									<%}%>
									<%if(iCommand==Command.SAVE){%>
									<span class="command"><a href="javascript:addNew()"><%=strAddLink%></a></span> 
									<%}%>
									<%if(iCommand==Command.EDIT || iCommand==Command.LIST){%>
									<span class="command"><a href="javascript:cmdSave()"><%=strSaveLink%></a></span> | <span class="command"><a href="javascript:cmdAsk('<%=accLinkId%>')"><%=strAskLink%></a></span> | <span class="command"><a href="javascript:cmdCancel()"><%=strCancel%></a></span> 
									<%}%>
									<%}else{%>
									<span class="command"><a href="javascript:cmdDelete('<%=accLinkId%>')"><%=strDeleteLink%></a></span> | <span class="command"><a href="javascript:cmdCancel()"><%=strCancel%></a></span>	
									<%}%>
								  <%}%>
								  </td>
								</tr>
								<%}%>
                          </table>
							</td>
						</tr>
					 </table>	
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