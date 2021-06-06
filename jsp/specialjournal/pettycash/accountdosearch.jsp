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
                 com.dimata.aiso.form.masterdata.CtrlPerkiraan,
                 com.dimata.util.Command,
                 com.dimata.aiso.session.report.SessGeneralLedger,
                 com.dimata.gui.jsp.ControlCombo,
                 com.dimata.gui.jsp.ControlLine,
		 com.dimata.aiso.form.specialJournal.*,
		 com.dimata.harisma.entity.masterdata.*"%>
<%@ include file = "../../main/javainit.jsp" %>
<%!
public static final int SORT_BY_NUMBER = 0;
public static final int SORT_BY_NAME = 1;

/* this constant used to list text of listHeader */
public static final String textListHeader[][] = { 
	{"No","Nomor","Nama","Departemen","Status"},
	{"No","Code","Name","Department","Postable"}
};

public static final String textSearchParameter[][] = { 
	{"Kelompok Perkiraam","Nomor Perkiraan","Nama Perkiraan","Urut Berdasar"},
	{"Account Group","Account Code","Account Name","Short By"}
};

public static final String strSelectAll[] = {
	"Semua Kelompok", "All Group"
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
		
		ctrlist.dataFormat(textListHeader[language][0],"5%","center","center");
		ctrlist.dataFormat(textListHeader[language][1],"10%","center","left");
		ctrlist.dataFormat(textListHeader[language][2],"50%","center","left");
		ctrlist.dataFormat(textListHeader[language][3],"20%","center","left");
		ctrlist.dataFormat(textListHeader[language][4],"15%","center","left");
	
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
		
		String strAccountName = "";	
		String strDepartmentName = "";
		Department objDepartment = new Department();
			
		for(int i=0; i<objectClass.size(); i++){
			 Perkiraan perkiraan = (Perkiraan)objectClass.get(i);
		
			 if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
			 	strAccountName = perkiraan.getAccountNameEnglish();
				else
				strAccountName = perkiraan.getNama();
				
			 int postable = perkiraan.getPostable();
			 
			 if(perkiraan.getDepartmentId() != 0)
			 	try{
					objDepartment = PstDepartment.fetchExc(perkiraan.getDepartmentId());
				}catch(Exception e){
					System.out.println("Exception on fetch obj Department  ==> "+e.toString());
				}
				
			 if(objDepartment != null)
			 	strDepartmentName = objDepartment.getDepartment();
						
			 Vector rowx = new Vector();
			 start = start + 1;
			 
			 rowx.add(""+start);
			 if(postable == 1)		
			 rowx.add("<a href=\"javascript:cmdEdit('"+perkiraan.getOID()+"','"+perkiraan.getNoPerkiraan()+"','"+strAccountName+"')\">"+perkiraan.getNoPerkiraan()+"</a>");
			 else
			 rowx.add(perkiraan.getNoPerkiraan());			
			 rowx.add(strAccountName);
			 rowx.add(strDepartmentName);	
			 
			 int pos = perkiraan.getPostable();
			 String psn = "";
			 if(pos==1){
			    psn = "Postable";  
			 }else{ 
        	   psn = "Header";  
			 } 			
			 rowx.add(psn);
	
			 lstData.add(rowx);
			 lstLinkData.add(perkiraan.getOID()+"','"+perkiraan.getNoPerkiraan()+"','"+strAccountName);
		}
		result = ctrlist.drawMe(index);
	}else{
		result = "<div class=\"msginfo\">&nbsp;&nbsp;No contact available ...</div>";		
	}
	return result;	
}
%>

<!-- JSP Block -->
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request,"start");
int accountGroup = FRMQueryString.requestInt(request,"account_group");
int accGroup = FRMQueryString.requestInt(request,"acc_group");
String accountNumber = FRMQueryString.requestString(request,"account_number");
String accCode = FRMQueryString.requestString(request,"acc_code");
String accountName = FRMQueryString.requestString(request,"account_name");
int intSortBy = FRMQueryString.requestInt(request,"sort_by");

int recordToGet = 20;
String pageHeader = "Search Account"; 
String pageTitle[] = {"PENCARIAN PERKIRAAN","SEARCH ACCOUNT"};    
String strSearch[] = {"Tampilkan","Search"};
String strReset[] = {"Kosongkan","Reset"};
String searchData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View Search Form" : "Cari Data";
String hideSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Hide Search Form" : "Sembunyikan Form Cari Data";

if(iCommand == Command.LIST){
     accGroup = accountGroup;
     accCode = accountNumber;
}

Vector vtGroup = new Vector(1,1);
vtGroup.add(String.valueOf(accountGroup));	


Vector vtNumber = new Vector(1,1);
if(accountNumber.length()>0){
	vtNumber.add(accountNumber);
}

Vector vtName = new Vector(1,1);
if(accountName.length()>0){
	vtName.add(accountName);
}


int vectSize = 0;

CtrlPerkiraan ctrlPerkiraan = new CtrlPerkiraan(request);
if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	 accountGroup = accGroup;
	 accountNumber = accCode;
	 vtNumber = new Vector(1,1);
	 vtNumber.add(accountNumber);
	 vtGroup.add(String.valueOf(accountGroup));
	 vectSize = PstPerkiraan.getCountListAccount(vtGroup,vtNumber,vtName);
	start = ctrlPerkiraan.actionList(iCommand,start,vectSize,recordToGet);
}else{
     vectSize = PstPerkiraan.getCountListAccount(vtGroup,vtNumber,vtName);
}  
 
String sortBy = "";
if(intSortBy==SORT_BY_NUMBER){
	sortBy = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];
}else{
	sortBy = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NAMA]+
			 ","+PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];			 
} 
Vector vect = PstPerkiraan.getListAccount(vtGroup,vtNumber,vtName,start,recordToGet,sortBy); 	
%>
<!-- End of JSP Block -->

<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Untitled Document</title>  
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<SCRIPT language=JavaScript>
function hideObjectForMenuJournal(){     
}
	 
function hideObjectForMenuReport(){
}
	
function hideObjectForMenuPeriod(){
}
	
function hideObjectForMenuMasterData(){
}

function hideObjectForMenuSystem(){ 
}

function showObjectForMenu(){
}

function cmdViewSearch(){
	document.frmaccountsearch.command.value="<%=Command.NONE%>";	
	document.frmaccountsearch.action="accountdosearch.jsp";
	document.frmaccountsearch.submit();
}

function cmdHideSearch(){
	document.frmaccountsearch.command.value="<%=Command.LIST%>";	
	document.frmaccountsearch.action="accountdosearch.jsp";
	document.frmaccountsearch.submit();
}

</SCRIPT>
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
	<form name="frmaccountsearch" method="post" action="">
	  <input type="hidden" name="start" value="<%=start%>">
	  <input type="hidden" name="command" value="<%=iCommand%>">
	  <input type="hidden" name="acc_group" value="<%=accGroup%>">
	  <input type="hidden" name="acc_code" value="<%=accCode%>">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>          
      		
      <td height="20" class="title" align="center"><b><font size="3"><%=pageTitle[SESS_LANGUAGE]%></font></b></td>
        </tr>		
        <tr>           
      <td> 
	  		<%
				int iCmd = 0;
				if(iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT
				|| iCommand == Command.LAST){
					iCmd = Command.LIST;
				}
				%>
				<%if(iCommand != Command.LIST){
					if(iCmd != Command.LIST){
				%>
        <table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
			<td>
			<table width="100%">
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=textSearchParameter[SESS_LANGUAGE][0]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
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
				  				  				  				  				  				  				  				  				  				  				  				  				  
				  out.println(ControlCombo.draw("account_group","",null,""+accountGroup,vectClassVal,vectClassKey,attr));
				  %>
            <%
			/*Vector listAccGroup = AppValue.getVectorAccGroup();
			Vector vectVal = new Vector(1,1);
			Vector vectKey = new Vector(1,1);
			vectKey.add("-");
			vectVal.add("0");					
			if(listAccGroup!=null && listAccGroup.size()>0){
				for(int i=0; i<listAccGroup.size(); i++){
					Vector tempResult = (Vector)listAccGroup.get(i);
					vectVal.add(tempResult.get(0));
					vectKey.add(tempResult.get(1)); 
				}
			}
			String attr = "onKeyDown=\"javascript:enterTrap()\"";			
		    out.println(ControlCombo.draw("account_group","",null,""+accountGroup,vectVal,vectKey,attr));
			*/%>
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=textSearchParameter[SESS_LANGUAGE][1]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
              <input type="text" name="account_number" value="<%=accountNumber%>" size="10" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=textSearchParameter[SESS_LANGUAGE][2]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
              <input type="text" name="account_name" value="<%=accountName%>" size="50" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=textSearchParameter[SESS_LANGUAGE][3]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
            <%
			Vector vectSortVal = new Vector(1,1);
			Vector vectSortKey = new Vector(1,1);
			vectSortVal.add(textSearchParameter[SESS_LANGUAGE][2]);
			vectSortKey.add(""+SORT_BY_NUMBER);																	  				  						
			vectSortVal.add(textSearchParameter[SESS_LANGUAGE][1]);
			vectSortKey.add(""+SORT_BY_NAME);			
		    out.println(ControlCombo.draw("sort_by","",null,""+intSortBy,vectSortKey,vectSortVal,attr));						
			%>
            </td>
          </tr>
          <tr> 
            <td width="17%">&nbsp;</td>
            <td width="1%">&nbsp;</td>
            <td width="82%"> 
              <input type="button" name="btnSubmit" value="<%=strSearch[SESS_LANGUAGE]%>" onClick="javascript:cmdSearch()">
              <input type="button" name="btnReset" value="<%=strReset[SESS_LANGUAGE]%>" onClick="javascript:cmdClear()">
            </td>
          </tr>
		  </table>
		   <%}
		  }%>
		  <tr>
                  <td align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
				  <%if(iCommand == Command.LIST || iCmd == Command.LIST){%>
				  <a href="javascript:cmdViewSearch()"><%=searchData%></a>
				  <%}else{%>				  
				  <a href="javascript:cmdHideSearch()"><%=hideSearch%></a>
				  <%}%>
				  </font>
				  </td>
                </tr>
          <tr> 
            <td colspan="3"><%=drawList(com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN,vect,start)%></td>
          </tr>
          <tr> 
            <td colspan="3"> <span class="command"> 
              <% 
			  ControlLine ctrlLine= new ControlLine();
			  ctrlLine.initDefault(SESS_LANGUAGE,"");;
			  out.println(ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left"));
			  %>
              </span> </td>
          </tr>
        </table>
      </td>
        </tr>
      </table>
	  <script language="javascript">
	  	<%if(iCommand != Command.LIST){
			if(iCmd != Command.LIST){
		%>
	  	document.frmaccountsearch.account_group.focus();
		<%
			}
		}	
		%>
	  </script>
   </form>	  
<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->

<script language="JavaScript">
window.focus();

function cmdEdit(oid,number,name){
	self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN]%>.value = oid;
	self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN]%>_TEXT.value = name;		
	self.close();
}

function first(){
	document.frmaccountsearch.command.value="<%=Command.FIRST%>";
	document.frmaccountsearch.action="accountdosearch.jsp";
	document.frmaccountsearch.submit();
}

function prev(){
	document.frmaccountsearch.command.value="<%=Command.PREV%>";
	document.frmaccountsearch.action="accountdosearch.jsp";
	document.frmaccountsearch.submit();
}

function next(){
	document.frmaccountsearch.command.value="<%=Command.NEXT%>";
	document.frmaccountsearch.action="accountdosearch.jsp";
	document.frmaccountsearch.submit();
}

function last(){
	document.frmaccountsearch.command.value="<%=Command.LAST%>";
	document.frmaccountsearch.action="accountdosearch.jsp";
	document.frmaccountsearch.submit();
}

function cmdSearch(){
	document.frmaccountsearch.command.value="<%=Command.LIST%>";
	document.frmaccountsearch.start.value="0";	
	document.frmaccountsearch.action="accountdosearch.jsp";
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

<link rel="stylesheet" href="../../style/main.css" type="text/css">
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
