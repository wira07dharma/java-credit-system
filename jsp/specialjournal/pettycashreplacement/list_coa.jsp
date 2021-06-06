<%
/*******************************************************************
 * Page Name  		:  contactdosearch.jsp
 * Page Description :  Contact List Page used to add contact to Journal,
 					   this page will display on Open Window 
 * Imput Parameters :  - 
 * Output 			:  - 
 * 
 * Created on 		:  July 01, 2003, 14:00 PM  
 * @author  		:  gedhy 
 * @version  		:  01  
 *******************************************************************/
 %> 
<%@page contentType="text/html"%>
<%@ page import="com.dimata.gui.jsp.ControlList,
                 com.dimata.aiso.entity.masterdata.Perkiraan,
                 com.dimata.aiso.entity.masterdata.PstPerkiraan,
				 com.dimata.aiso.form.masterdata.FrmPerkiraan,
                 com.dimata.aiso.form.masterdata.CtrlPerkiraan,
                 com.dimata.util.Command,                
                 com.dimata.gui.jsp.ControlCombo,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.form.masterdata.FrmActivityAccountLink"%>
<%@ include file = "../../main/javainit.jsp" %>
<%!
public static final int SORT_BY_NUMBER = 0;
public static final int SORT_BY_NAME = 1;

/* this constant used to list text of listHeader */
public static final String textListHeader[][] = { 
	{"No","Nomor","Nama","Status"},
	{"No","Number","Name","Status"}
};

public static final String strSearchParameter[][] = {
	{
		"Kelompok Perkiraan",
		"Nomor Perkiraan",
		"Nama Perkiraan",
		"Urut Berdasarkan"
	},
	{
		"Account Group",
		"Account Number",
		"Account Name",
		"Short By"
	}
};

public static final String strTitle[] = {
	"PENCARIAN PERKIRAAN","ACCOUNT SEARCH"
};

public static final String strSelectAll[] = {
	"Semua Kelompok", "All Group"
};

public static final String strShortBy[][] = {
	{
		"Nomor Perkiraan",
		"Nama Perkiraan"
	},
	{
		"Account Number",
		"Account Name"
	}
	
};


public String drawList(int language, Vector objectClass, int start){
	String result = "";
	if(objectClass!=null && objectClass.size()>0){
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%"); 
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setCellStyleOdd("listgensellOdd");
		ctrlist.setHeaderStyle("listgentitle");
		
		ctrlist.dataFormat(textListHeader[language][0],"5%","left","left");
		ctrlist.dataFormat(textListHeader[language][1],"15%","left","left");
		ctrlist.dataFormat(textListHeader[language][2],"60%","left","left");
		ctrlist.dataFormat(textListHeader[language][3],"20%","left","left");
	
		ctrlist.setLinkRow(-1);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		
		
		
		int index = -1;
		
		if(start <0)
			start = 0;
			
		for(int i=0; i<objectClass.size(); i++){
			 Perkiraan perkiraan = (Perkiraan)objectClass.get(i);
	
			String strAccName = "";			
			
			 if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			 
			 		strAccName = perkiraan.getAccountNameEnglish();
					
			 }else{
			 
			 		strAccName = perkiraan.getNama();
					
			 }
			 Vector rowx = new Vector();
			 start = start + 1;
			
			 rowx.add("<div align=\"center\">"+start+"</div>");		
            int pos = perkiraan.getPostable();
            String psn = "";
            if(pos==1){
               psn = "Postable";
               rowx.add("<a href=\"javascript:cmdEdit('"+perkiraan.getOID()+"','"+perkiraan.getNoPerkiraan()+"','"+strAccName+"')\">"+perkiraan.getNoPerkiraan()+"</a>");
            }else{
              psn = "Header";
              rowx.add(perkiraan.getNoPerkiraan());
            }

            String space = "";
            switch(perkiraan.getLevel()){
                case 1 : space = ""; break;
                case 2 : space = "&nbsp;&nbsp;&nbsp;&nbsp;"; break;
                case 3 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
                case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
                case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
                case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
            }

			
			
            rowx.add(space + strAccName);
			rowx.add(psn);
	
			 lstData.add(rowx);
			 lstLinkData.add(perkiraan.getOID()+"','"+perkiraan.getNoPerkiraan()+"','"+strAccName+"'");
		}
		result = ctrlist.drawMe(index);
	}else{
		result = "<div class=\"msginfo\">&nbsp;&nbsp;...</div>";
	}
	return result;	
}

%>

<!-- JSP Block -->
<%
boolean fromGL = FRMQueryString.requestBoolean(request,"fromGL");
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request,"start");
int iAccountGroup = FRMQueryString.requestInt(request,"accountchart_group");
String accountNumber = FRMQueryString.requestString(request,"account_number");
String accountName = FRMQueryString.requestString(request,"account_name");
int intSortBy = FRMQueryString.requestInt(request,"sort_by");

long departmentOid = FRMQueryString.requestLong(request,"department_oid");

int recordToGet = 10;
String pageHeader = "Search Account"; 
String pageTitle = "SEARCH ACCOUNT";    


Vector vtGroup = new Vector(1,1);
if(iAccountGroup!=0){
	vtGroup.add(String.valueOf(iAccountGroup));	
}

Vector vtNumber = new Vector(1,1);
if(accountNumber.length()>0){
	vtNumber.add(accountNumber);
}

Vector vtName = new Vector(1,1);
if(accountName.length()>0){
	vtName.add(accountName);
}


int vectSize = PstPerkiraan.getCountListAccount(vtGroup,vtNumber,vtName,departmentOid);

CtrlPerkiraan ctrlPerkiraan = new CtrlPerkiraan(request);
FrmPerkiraan frmPerkiraan = ctrlPerkiraan.getForm();
Perkiraan perkiraan = ctrlPerkiraan.getPerkiraan(); 

if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	start = ctrlPerkiraan.actionList(iCommand,start,vectSize,recordToGet);
} 
 
String sortBy = "";
if(intSortBy==SORT_BY_NUMBER){
	sortBy = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];
}else{
	sortBy = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NAMA]+
			 ","+PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];			 
} 
//Vector vectAccountList = PstPerkiraan.getAllAccount(iAccountGroup, 0);
Vector vect = PstPerkiraan.getListAccount(vtGroup,vtNumber,vtName,start,recordToGet,sortBy,departmentOid);

%>
<!-- End of JSP Block -->

<html>
<head>
<title><%=pageHeader%></title>
<script language="JavaScript">
window.focus();

function cmdEdit(oid,number,name){
	self.opener.document.forms.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.<%=FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACCOUNT_ID]%>.value = oid;      
	self.opener.document.forms.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.<%=FrmActivityAccountLink.fieldNames[FrmActivityAccountLink.FRM_ACCOUNT_ID]%>_TEXT.value = number;	
	self.opener.document.forms.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.acc_name.value = name;	
	self.opener.document.forms.<%=FrmActivityAccountLink.FRM_ACT_ACC_LINK%>.acc_name.focus();	
	self.close();
}

function first(){
	document.frmaccountsearch.command.value="<%=Command.FIRST%>";
	document.frmaccountsearch.action="list_coa.jsp";
	document.frmaccountsearch.submit();
}

function prev(){
	document.frmaccountsearch.command.value="<%=Command.PREV%>";
	document.frmaccountsearch.action="list_coa.jsp";
	document.frmaccountsearch.submit();
}

function next(){
	document.frmaccountsearch.command.value="<%=Command.NEXT%>";
	document.frmaccountsearch.action="list_coa.jsp";
	document.frmaccountsearch.submit();
}

function last(){
	document.frmaccountsearch.command.value="<%=Command.LAST%>";
	document.frmaccountsearch.action="list_coa.jsp";
	document.frmaccountsearch.submit();
}

function cmdSearch(){
	document.frmaccountsearch.command.value="<%=Command.LIST%>";
	//document.frmaccountsearch.start.value="0";	
	document.frmaccountsearch.action="list_coa.jsp#down";
	document.frmaccountsearch.submit();
}	

function cmdClear(){
	document.frmaccountsearch.account_number.value="";
	document.frmaccountsearch.account_name.value="";	
}

function enterTrap(){
	if(event.keyCode==13){
		document.frmaccountsearch.btnSubmit.focus();
		cmdSearch();
	}
}	
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
</head>
<BODY onBlur="self.focus()" bgcolor="#FFFFFF" class="menuleft">
	<form name="frmaccountsearch" method="post" action="">
	   <input type="hidden" name="accountchart_group" value="<%=iAccountGroup%>">
	  <input type="hidden" name="start" value="<%=start%>">
	  <input type="hidden" name="command" value="<%=iCommand%>">
      <input type="hidden" name="department_oid" value="<%=departmentOid%>">	  
      <input type="hidden" name="fromGL" value="<%=fromGL%>">
	  	  
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="menuleft">
        <tr>

      <td height="20" class="title" align="center"><b><font size="3"><%=strTitle[SESS_LANGUAGE]%></font></b></td>
        </tr>
		<tr><td><hr></td></tr>		
        <tr>
      <td>
        <table width="100%" border="0" cellspacing="1" cellpadding="1">
          <tr>
		  <td><table width="100%" cellspacing="1" cellpadding="1" class="listgenactivity">		  
		  <tr>
		    <td nowrap>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    </tr>
		  <tr>		  	
            <td width="17%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][0]%></td>
            <td width="1%">:</td>
            <td width="81%">            
			<%
				  
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
				  
				  vectClassVal.add("0");
				  vectClassKey.add(strSelectAll[SESS_LANGUAGE]);
				  
				  String attr = "onKeyDown=\"javascript:enterTrap()\"";  
				  				  				  				  				  				  				  				  				  				  				  				  				  
				  out.println(ControlCombo.draw("account_group","",null,""+iAccountGroup,vectClassVal,vectClassKey,attr));
				  %>
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][1]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
              <input type="text" name="account_number" value="<%=accountNumber%>" size="10" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][2]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
              <input type="text" name="account_name" value="<%=accountName%>" size="50" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][3]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
            <%
			Vector vectSortVal = new Vector(1,1);
			Vector vectSortKey = new Vector(1,1);
			vectSortVal.add(strShortBy[SESS_LANGUAGE][0]);
			vectSortKey.add(""+SORT_BY_NUMBER);																	  				  						
			vectSortVal.add(strShortBy[SESS_LANGUAGE][1]);
			vectSortKey.add(""+SORT_BY_NAME);			
		    out.println(ControlCombo.draw("sort_by","",null,""+intSortBy,vectSortKey,vectSortVal,attr));						
			%>
            </td>
          </tr>
          <tr> 
            <td width="17%">&nbsp;</td>
            <td width="1%">&nbsp;</td>
            <td width="82%"> 
              <input type="button" name="btnSubmit" value="Search" onClick="javascript:cmdSearch()">
              <input type="button" name="btnReset" value="Reset" onClick="javascript:cmdClear()">
            </td>			
          </tr>
		  <tr><td height="17">&nbsp;</td>
		  </tr>
		  </table>
		  </td>
		  </tr>		  
		  <tr><td><hr></td></tr>
          <tr>		        
            <td colspan="3" id="down"><%=drawList(SESS_LANGUAGE,vect,start)%>			
			</td>
          </tr>
          <tr> 
            <td colspan="3"> <span class="command"> 
              <% 
			  ControlLine ctrlLine= new ControlLine();
			  ctrlLine.setLanguage(SESS_LANGUAGE);
			  out.println(ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left"));
			  %>
              </span> </td>
          </tr>
        </table>
      </td>
        </tr>
      </table>
	  <script language="javascript">
	  	document.frmaccountsearch.account_group.focus();
	  </script>
   </form>	  
</body>
</html>
