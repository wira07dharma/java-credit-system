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
                 com.dimata.util.*,
                 com.dimata.aiso.session.report.SessGeneralLedger,
                 com.dimata.gui.jsp.ControlCombo,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.form.jurnal.FrmJurnalDetail,                 
				 com.dimata.harisma.entity.masterdata.*"%>
<%@ page import="com.dimata.aiso.form.jurnal.FrmJournalDistribution" %>
<%@ include file = "../main/javainit.jsp" %>
<%!
public static final int SORT_BY_NUMBER = 0;
public static final int SORT_BY_NAME = 1;

/* this constant used to list text of listHeader */
public static final String textListHeader[][] = { 
	{"No","Nomor","Nama","Departemen","Status"},
	{"No","Code","Name","Department","Postable"}
};

public static final String strSearchParameter[][] = {
	{"Kelompok Perkiraan","Nomor Perkiraan","Nama Perkiraan","Urut Berdasarkan"},
	{"Account Group","Account Code","Account Name","Short By"}
};

public static final String strShortBy[][] = {
	{"Nomor Perkiraan","Nama Perkiraan"},
	{"Code","Name"}
};

private static String strErrorMassage[] = {
	"Kontak Tidak Ditemukan","System can't found contact"
};

public static final String strSelectAll[] = {
	"Semua Kelompok", "All Group"
};

private String setAccNameBaseLanguage(Perkiraan objPerkiraan, int language){
	String strAccName = "";
		try{
			if(objPerkiraan != null){
				if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
					strAccName = objPerkiraan.getAccountNameEnglish();
				else
					strAccName = objPerkiraan.getNama();
			}
		}catch(Exception e){
			System.out.println("Exception on setAccNameBaseLanguage() ::: "+e.toString());
			e.printStackTrace();
		}
	return strAccName;
}

private String caracterReplace(String strToReplace){
	String strReplace = "";
		try{
			strReplace = strToReplace.replace('\"','`');
			strReplace = strToReplace.replace('\'','`');
		}catch(Exception e){
			strReplace = "";
			System.out.println("Exception on caracterReplace() :::: "+e.toString());
			e.printStackTrace();
		}
	return strReplace;
}

public String selectOne(int iJDistIdx, int language, Vector objectClass)
{
	String result = "";
		if(objectClass!=null && objectClass.size()>0){
	
			for(int i=0; i<objectClass.size(); i++){
				Perkiraan perkiraan = (Perkiraan)objectClass.get(i);
				String strAccountName = setAccNameBaseLanguage(perkiraan,language);
				strAccountName = caracterReplace(strAccountName);
				String strAccCode = perkiraan.getNoPerkiraan();
				strAccCode = caracterReplace(strAccCode);
				        	
				result ="<script language=\"JavaScript\"> cmdEdit("+iJDistIdx+",'"+(perkiraan.getOID()+"','"+
							  strAccCode+"','"+strAccountName+"','"+perkiraan.getPostable()+"');</script>");
			}
		}else{
			result = "<div class=\"msginfo\">"+strErrorMassage[language]+"</div>";
		}
	return result;
}


public String drawList(int iJDistIdx, int language, Vector objectClass, int start){
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
		ctrlist.dataFormat(textListHeader[language][1],"15%","center","left");
		ctrlist.dataFormat(textListHeader[language][2],"50%","center","left");
		ctrlist.dataFormat(textListHeader[language][3],"20%","center","left");
		ctrlist.dataFormat(textListHeader[language][4],"10%","center","left");
	
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
			 
			 String strAccountName = "";
			 if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
			 	strAccountName = perkiraan.getAccountNameEnglish();
				else
				strAccountName = perkiraan.getNama();
	
			 Vector rowx = new Vector();
			 start = start + 1;
			
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
				
			 rowx.add(""+start);		
            int pos = perkiraan.getPostable();
            String psn = "";
            if(pos==1){
               psn = "Postable";
               rowx.add("<a href=\"javascript:cmdEdit("+iJDistIdx+",'"+perkiraan.getOID()+"','"+perkiraan.getNoPerkiraan()+"','"+strAccountName+"')\">"+perkiraan.getNoPerkiraan()+"</a>");
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

            rowx.add(space + strAccountName);
			rowx.add(strDepartment);
			rowx.add(psn);
	
			 lstData.add(rowx);
			 lstLinkData.add(perkiraan.getOID()+"','"+perkiraan.getNoPerkiraan()+"','"+strAccountName+"','"+perkiraan.getPostable());
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
int iJDistIdx = FRMQueryString.requestInt(request, FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JDIS_INDEX]);
int start = FRMQueryString.requestInt(request,"start");
int iAccountGroup = FRMQueryString.requestInt(request,"account_group");
int iAccGroup = FRMQueryString.requestInt(request,"acc_group");
//String accountNumber = FRMQueryString.requestString(request,"account_number");
String accountNumber = "";
String sAccCode = FRMQueryString.requestString(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]);
String accountName = FRMQueryString.requestString(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]);
String sDebetAmount = FRMQueryString.requestString(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_DEBIT_AMOUNT]);
String sCreditAmount = FRMQueryString.requestString(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_CREDIT_AMOUNT]);
String dAmountSisa = FRMQueryString.requestString(request,"dAmountSisa");
int intSortBy = FRMQueryString.requestInt(request,"sort_by");

accountNumber =sAccCode;
        
double dDebetAmount = 0;
double dCreditAmount = 0;
double dSisa = 0; 
try{
 dDebetAmount = Double.parseDouble(sDebetAmount);
 dCreditAmount = Double.parseDouble(sCreditAmount);
 dSisa = Double.parseDouble(dAmountSisa); 
 } catch(Exception exc){
     System.out.println("EXC >>>> "+exc);
 }

String strSisa = Formater.formatNumber(dSisa, "##,###.##");

long departmentOid = FRMQueryString.requestLong(request,"department_oid");
String strTitle[] = {"PENCARIAN PERKIRAAN","SEARCH ACCOUNT"};
String strSearch[] = {"Tampilkan","Search"};
String strReset[] = {"Kosongkan","Reset"};
String searchData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View Search Form" : "Cari Data";
String hideSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Hide Search Form" : "Sembunyikan Form Cari Data";

int recordToGet = 100;
String pageHeader = "Search Account"; 
String pageTitle = "SEARCH ACCOUNT";   

if(iCommand == Command.LIST){
    iAccGroup = iAccountGroup;
    sAccCode = accountNumber;    
}

Vector vtGroup = new Vector(1,1);
vtGroup.add(String.valueOf(iAccountGroup));

Vector vtNumber = new Vector(1,1);
vtNumber.add(accountNumber);

Vector vtName = new Vector(1,1);
if(accountName.length()>0){
	vtName.add(accountName);
}


int vectSize = 0;

CtrlPerkiraan ctrlPerkiraan = new CtrlPerkiraan(request);
if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){	
	iAccountGroup = iAccGroup; 
	accountNumber = sAccCode;
	vtGroup.add(String.valueOf(iAccountGroup));
	vtNumber = new Vector(1,1);
	vtNumber.add(accountNumber);
	vectSize = PstPerkiraan.getCountListAccount(vtGroup,vtNumber,vtName,departmentOid);
	start = ctrlPerkiraan.actionList(iCommand,start,vectSize,recordToGet);
}else{
    vectSize = PstPerkiraan.getCountListAccount(vtGroup,vtNumber,vtName,departmentOid);
} 
 
String sortBy = "";
if(intSortBy==SORT_BY_NUMBER){
	sortBy = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];
}else{
	sortBy = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NAMA]+
			 ","+PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];			 
} 

String msgAccount="";
boolean accpostable= true;
Vector vect = PstPerkiraan.getListAccount(vtGroup,vtNumber,vtName,start,recordToGet,sortBy,departmentOid);
        if(vect!=null && vect.size()==1){
            Perkiraan  pk = (Perkiraan) vect.get(0);
            if(pk!=null){
                if(pk.getPostable()!=PstPerkiraan.ACC_POSTED){
                    msgAccount="Account is not postable";
                    accpostable = false;
                }
            } 
        } 
%>
<!-- End of JSP Block -->

<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Jurnal Distribution - Search CAO</title>  
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<script language="JavaScript">
window.focus();

function cmdEdit(jDisIdx, oid,number,name){
      
	self.opener.document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ID_PERKIRAAN]%>.value = oid;
        //alert(self.opener.document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ID_PERKIRAAN]%>.value);
            
	self.opener.document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>.value = number;         
        //alert(self.opener.document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>.value);
    	self.opener.document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]%>.value=name;
        //alert(">"+self.opener.document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>.value);
        //alert("done");
	self.close();
}

function first(){
	document.frmaccountsearch.command.value="<%=Command.FIRST%>";
	document.frmaccountsearch.action="arap_coasearch_jdis.jsp";
	document.frmaccountsearch.submit();
}

function prev(){
	document.frmaccountsearch.command.value="<%=Command.PREV%>";
	document.frmaccountsearch.action="arap_coasearch_jdis.jsp";
	document.frmaccountsearch.submit();
}

function next(){
	document.frmaccountsearch.command.value="<%=Command.NEXT%>";
	document.frmaccountsearch.action="arap_coasearch_jdis.jsp";
	document.frmaccountsearch.submit();
}

function last(){
	document.frmaccountsearch.command.value="<%=Command.LAST%>";
	document.frmaccountsearch.action="arap_coasearch_jdis.jsp";
	document.frmaccountsearch.submit();
}

function cmdSearch(){
	document.frmaccountsearch.command.value="<%=Command.LIST%>";
	document.frmaccountsearch.start.value="0";	
	document.frmaccountsearch.action="arap_coasearch_jdis.jsp";
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

function cmdViewSearch(){
	document.frmaccountsearch.command.value="<%=Command.NONE%>";	
	document.frmaccountsearch.action="arap_coasearch_jdis.jsp";
	document.frmaccountsearch.submit();
}

function cmdHideSearch(){
	document.frmaccountsearch.command.value="<%=Command.LIST%>";	
	document.frmaccountsearch.action="arap_coasearch_jdis.jsp";
	document.frmaccountsearch.submit();
}
	
</script>
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
		  <SCRIPT language="javascript">
		  	window.focus();
		  </SCRIPT>
	<form name="frmaccountsearch" method="post" action="">
	 <input type="hidden" name="acc_group" value="<%=iAccGroup%>">
	 <input type="hidden" name="acc_code" value="<%=sAccCode%>">
	  <input type="hidden" name="start" value="<%=start%>">
	  <input type="hidden" name="command" value="<%=iCommand%>">
      <input type="hidden" name="department_oid" value="<%=departmentOid%>">
	  <input type="hidden" name="dDebetAmount" value="<%=dDebetAmount%>">
	  <input type="hidden" name="dCreditAmount" value="<%=dCreditAmount%>">
	  <input type="hidden" name="dAmountSisa" value="<%=dAmountSisa%>">
      <input type="hidden" name="fromGL" value="<%=fromGL%>">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="menuleft">
        <tr>

      <td height="20" class="title" align="center"><b><font size="3"><%=strTitle[SESS_LANGUAGE]%></font></b></td>
        </tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
        <tr>
      <td>
        <table width="100%" border="0" cellpadding="1" cellspacing="1" class="listgenactivity">
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
					<table width="100%" class="listgenvalue">
          <tr><!-- Start Parameter -->
            <td width="17%" nowrap>&nbsp;<%=strSearchParameter[SESS_LANGUAGE][0]%></td>
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
				  
				  vectClassVal.add(""+PstPerkiraan.ACC_GROUP_ALL);
				  vectClassKey.add(PstPerkiraan.arrAccountGroupNames[SESS_LANGUAGE][PstPerkiraan.ACC_GROUP_ALL]);
				  
				  String attr = "onKeyDown=\"javascript:enterTrap()\"";  
				  				  				  				  				  				  				  				  				  				  				  				  				  
				  out.println(ControlCombo.draw("account_group","",null,""+iAccountGroup,vectClassVal,vectClassKey,attr));
				  %>
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=strSearchParameter[SESS_LANGUAGE][1]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
              <input type="text" name="account_number" value="<%=accountNumber%>" size="10" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=strSearchParameter[SESS_LANGUAGE][2]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
              <input type="text" name="account_name" value="<%=accountName%>" size="50" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=strSearchParameter[SESS_LANGUAGE][3]%></td>
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
              <input type="button" name="btnSubmit" value="<%=strSearch[SESS_LANGUAGE]%>" onClick="javascript:cmdSearch()">
              <input type="button" name="btnReset" value="<%=strReset[SESS_LANGUAGE]%>" onClick="javascript:cmdClear()">
            </td>
          </tr><!-- End Parameter-->
		  </table>
		  <%}
		  }%>
		  </td>
		  </tr>
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
            <td colspan="3">

			<%if(vect.size() == 1 && accpostable){%>
				<%out.println(selectOne(iJDistIdx, SESS_LANGUAGE, vect));%>
			<%}else{		
                                      if(!accpostable){ 
                                               out.println("<h2>"+msgAccount+"</h2>");
                                        }
                                        %>
				<%=drawList(iJDistIdx, SESS_LANGUAGE,vect,start)%>
			<%}%>	



			</td>
          </tr>
          <tr> 
            <td colspan="3"> <span class="command"> 
              <% 
			  ControlLine ctrlLine= new ControlLine();
			  ctrlLine.initDefault(SESS_LANGUAGE,"");
			  System.out.println("vectSize ::::: "+vectSize);
			  out.println(ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left"));
			  %>
              </span> </td>
          </tr>
        </table>
      </td>
        </tr>
      </table>
	  <script language="javascript">
	  	<%
			if(iCommand != Command.LIST){
				if(iCmd != Command.LIST){
		%>
	  		document.frmaccountsearch.account_group.focus();
		<%}
		}%>
	  </script>
   </form>	  




<link rel="stylesheet" href="../style/main.css" type="text/css">
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
