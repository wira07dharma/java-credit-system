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
<%@ page import="com.dimata.util.*,
				 com.dimata.gui.jsp.ControlList,
                 com.dimata.aiso.entity.masterdata.DonorComponent,
                 com.dimata.aiso.form.masterdata.FrmDonorComponent,
                 com.dimata.aiso.form.masterdata.CtrlDonorComponent,
                 com.dimata.aiso.entity.masterdata.PstDonorComponent,
                 com.dimata.util.Command,                
                 com.dimata.gui.jsp.ControlCombo,
                 com.dimata.gui.jsp.ControlLine,
				 com.dimata.common.entity.contact.*,
				 com.dimata.common.form.search.*,
                 com.dimata.aiso.form.masterdata.FrmActivityDonorComponentLink"%>
<%@ include file = "../../main/javainit.jsp" %>
<%!
public static final int SORT_BY_NUMBER = 0;
public static final int SORT_BY_NAME = 1;

/* this constant used to list text of listHeader */
public static final String textListHeader[][] = { 
	{"No","Kode","Nama Komponent", "Nama Donor", "Keterangan","Daftar","Pencarian"},
	{"No","Code","Component Name", "Donor Name", "Description","List","Search"}
};

public static final String strSearchParameter[][] = {
	{
		"Kode",
		"Nama",
		"Nama Donor",
		"Urut Berdasarkan"
	},
	{
		"Code",
		"Name",
		"Donor Name",
		"Short By"
	}
};

public static final String strTitle[] = {
	"KOMPONEN DONOR","DONOR COMPONENT"
};

public static final String strSelectAll[] = {
	"Semua Kelompok", "All Group"
};

public static final String strShortBy[][] = {
	{
		"Kode",
		"Nama"
	},
	{
		"Code",
		"Name"
	}
	
};


public String drawList(Vector objectClass, long lDonorComponentId, int languange, int iCommand, FrmDonorComponent frmDonorComponent, int iStart)

{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(textListHeader[languange][0],"5%","center","center");
	ctrlist.dataFormat(textListHeader[languange][1],"10%","center","left");
	ctrlist.dataFormat(textListHeader[languange][2],"25%","center","left");
	ctrlist.dataFormat(textListHeader[languange][3],"20%","center","left");
	ctrlist.dataFormat(textListHeader[languange][4],"40%","center","left");

	ctrlist.setLinkRow(1);
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
    ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	Vector rowx = new Vector(1,1);
	String sContact = "";	
	String strDonorCompName = "";
	if(iStart < 0)
		iStart = 0;
		
	for (int i = 0; i < objectClass.size(); i++){
		DonorComponent objDonorComponent = (DonorComponent)objectClass.get(i);
		rowx = new Vector();
		
		if(lDonorComponentId == objDonorComponent.getOID()){
			index = i;
		}
		ContactList objContact = new ContactList();
		try{
			objContact = PstContactList.fetchExc(objDonorComponent.getContactId());
			}catch(Exception e){
			
			}
		
		String strContact = "";			
		strContact = objContact.getCompName();			
		if(strContact != null && strContact.length() > 0){				
			sContact = objContact.getCompName();			
		}else{			
			sContact = objContact.getPersonName();
		}	
		
			strDonorCompName = objDonorComponent.getName();
		
			rowx.add("<div align=\"center\">"+(iStart+i+1)+"</div>");
			rowx.add(objDonorComponent.getCode());
			rowx.add(strDonorCompName);
			rowx.add(strContact);
			rowx.add(objDonorComponent.getDescription());
		
		
		lstData.add(rowx);
        lstLinkData.add(objDonorComponent.getOID()+"','"+objDonorComponent.getCode()+"','"+strDonorCompName+"");
		//lstLinkData.add(perkiraan.getOID()+"','"+perkiraan.getNoPerkiraan()+"','"+strAccName+"'");
	}	

	return ctrlist.draw(-1);
}
%>

<!-- JSP Block -->
<%
boolean fromGL = FRMQueryString.requestBoolean(request,"fromGL");
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request,"start");
long oidContact = FRMQueryString.requestLong(request,"contact_id");
String strCode = FRMQueryString.requestString(request,"code");
String strName = FRMQueryString.requestString(request,"name");
String strDonorName = FRMQueryString.requestString(request,"donor_name");
long oidDonorComponent = FRMQueryString.requestLong(request, "hidden_donor_component_id");
int intSortBy = FRMQueryString.requestInt(request,"sort_by");
String strBudget = FRMQueryString.requestString(request, "dBudget");
String strProsenBudget = FRMQueryString.requestString(request, "dProsenBudget");
System.out.println("iCommand atas ::::: "+iCommand);

int recordToGet = 10;
String pageHeader = "Search Account"; 
String pageTitle = "SEARCH ACCOUNT"; 
String allCondition = "";
String whereClause = "";
String sOidContact = String.valueOf(oidContact);
String orderClause = PstDonorComponent.fieldNames[PstDonorComponent.FLD_CODE];   
String strSearch[] = {"Tampilkan","Search"};
String strReset[] = {"Kosongkan","Reset"};
String searchData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View Search Form" : "Cari Data";
String hideSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Hide Search Form" : "Sembunyikan Form Cari Data";

if(strCode != null && strCode.length() > 0)
allCondition = PstDonorComponent.fieldNames[PstDonorComponent.FLD_CODE] +" LIKE '%"+strCode+"%'";
if(strName != null && strName.length() > 0)
	if(allCondition != null && allCondition.length() > 0)
		allCondition = allCondition + " AND " + PstDonorComponent.fieldNames[PstDonorComponent.FLD_NAME] +" LIKE '%"+strName+"%'";
		else
		allCondition = PstDonorComponent.fieldNames[PstDonorComponent.FLD_NAME] +" LIKE '%"+strName+"%'";		
if(oidContact != 0)
	if(allCondition != null && allCondition.length() > 0)
		allCondition = allCondition + " AND " + PstDonorComponent.fieldNames[PstDonorComponent.FLD_CONTACT_ID] +" = "+sOidContact;
		else
		allCondition = PstDonorComponent.fieldNames[PstDonorComponent.FLD_CONTACT_ID] +" = "+sOidContact;
		
whereClause = allCondition;
		

Vector vtContact = new Vector(1,1);
if(oidContact!=0){
	vtContact.add(String.valueOf(oidContact));	
}

Vector vtCode = new Vector(1,1);
if(strCode.length()>0){
	vtCode.add(strCode);
}

Vector vtName = new Vector(1,1);
if(strName.length()>0){
	vtName.add(strName);
}


int vectSize = PstDonorComponent.getCount(whereClause);

CtrlDonorComponent ctrlDonorComponent = new CtrlDonorComponent(request);
Vector listDonorComponent = new Vector(1,1);

FrmSrcContactList frmSrcContactList = new FrmSrcContactList();

FrmDonorComponent frmDonorComponent = ctrlDonorComponent.getForm();
DonorComponent objDonorComponent = ctrlDonorComponent.getDonorComponent(); 

if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	start = ctrlDonorComponent.actionList(iCommand,start,vectSize,recordToGet);
} 
 
String sortBy = "";
if(intSortBy==SORT_BY_NUMBER){
	sortBy = PstDonorComponent.fieldNames[PstDonorComponent.FLD_CODE];
}else{
	sortBy = PstDonorComponent.fieldNames[PstDonorComponent.FLD_NAME];	 
} 
//Vector vectAccountList = PstPerkiraan.getAllAccount(iAccountGroup, 0);
listDonorComponent = PstDonorComponent.getListAccount(vtCode,vtName,vtContact,start,recordToGet,sortBy);

%>
<!-- End of JSP Block -->

<html>
<head>
<title><%=pageHeader%></title>
<script language="JavaScript">
window.focus();

function cmdEdit(oid,code,name){
	self.opener.document.forms.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_DONOR_COMPONENT_ID]%>.value =oid;      
	self.opener.document.forms.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_DONOR_COMPONENT_ID]%>_TEXT.value =code;	
	self.opener.document.forms.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_SHARE_BUDGET]%>.value="<%=strBudget%>";
	self.opener.document.forms.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_SHARE_PROCENTAGE]%>.value="<%=strProsenBudget%>";
	self.opener.document.forms.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.name.value =name;
	self.opener.document.forms.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_SHARE_BUDGET]%>.focus();	
	self.close();
}

function first(){
	document.frmdonorcomponentsearch.command.value="<%=Command.FIRST%>";
	document.frmdonorcomponentsearch.action="list_donor_comp.jsp";
	document.frmdonorcomponentsearch.submit();
}

function prev(){
	document.frmdonorcomponentsearch.command.value="<%=Command.PREV%>";
	document.frmdonorcomponentsearch.action="list_donor_comp.jsp";
	document.frmdonorcomponentsearch.submit();
}

function next(){
	document.frmdonorcomponentsearch.command.value="<%=Command.NEXT%>";
	document.frmdonorcomponentsearch.action="list_donor_comp.jsp";
	document.frmdonorcomponentsearch.submit();
}

function last(){
	document.frmdonorcomponentsearch.command.value="<%=Command.LAST%>";
	document.frmdonorcomponentsearch.action="list_donor_comp.jsp";
	document.frmdonorcomponentsearch.submit();
}

function cmdSearch(){
	document.frmdonorcomponentsearch.command.value="<%=Command.LIST%>";
	//document.frmaccountsearch.start.value="0";	
	document.frmdonorcomponentsearch.action="list_donor_comp.jsp";
	document.frmdonorcomponentsearch.submit();
}

function cmdSrcContact(){
	var url = "donor_list.jsp?command=<%=Command.LIST%>&<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_NAME]%>="+document.frmdonorcomponentsearch.donor_name.value+"";	
	window.open(url,"src_donor_comp_list_dnc","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");		
}		

function cmdClear(){
	document.frmdonorcomponentsearch.code.value="";
	document.frmdonorcomponentsearch.name.value="";
	document.frmdonorcomponentsearch.donor_name.value="";	
	document.frmdonorcomponentsearch.contact_id.value="";	
	document.frmdonorcomponentsearch.code.focus();
}

function cmdViewSearch(){
	document.frmdonorcomponentsearch.command.value="<%=Command.NONE%>";	
	document.frmdonorcomponentsearch.action="list_donor_comp.jsp";
	document.frmdonorcomponentsearch.submit();
}

function cmdHide(){
	document.frmdonorcomponentsearch.command.value="<%=Command.LIST%>";	
	document.frmdonorcomponentsearch.action="list_donor_comp.jsp";
	document.frmdonorcomponentsearch.submit();
}

function enterTrap(){
	if(event.keyCode==13){
		document.frmdonorcomponentsearch.btnSubmit.focus();
		cmdSearch();
	}
}	
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
</head>
<BODY onBlur="self.focus()" bgcolor="#FFFFFF" class="menuleft">
  <script language="JavaScript">
		  	window.focus();
		  </SCRIPT>
	<form name="frmdonorcomponentsearch" method="post" action="">	   
	  <input type="hidden" name="start" value="<%=start%>">
	  <input type="hidden" name="command" value="<%=iCommand%>">       
      <input type="hidden" name="fromGL" value="<%=fromGL%>">
	  <input type="hidden" name="hidden_donor_component_id" value="<%=oidDonorComponent%>">		  
	  <input type="hidden" name="dBudget" value="<%=strBudget%>">
	  <input type="hidden" name="dProsenBudget" value="<%=strProsenBudget%>">	  
	  
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="menuleft">
        <tr>

      <td height="20" class="title" align="center">
	  		<b><font size="3">
				<%if(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){%>
					<%=strTitle[SESS_LANGUAGE]%>&nbsp;
					<%if(iCommand == Command.LIST){%>
						<%=textListHeader[SESS_LANGUAGE][5].toUpperCase()%>
					<%}else{%>
						<%=textListHeader[SESS_LANGUAGE][6].toUpperCase()%>
					<%}%>	
				<%}else{%>
					<%if(iCommand == Command.LIST){%>
						<%=textListHeader[SESS_LANGUAGE][5].toUpperCase()%>
					<%}else{%>
						<%=textListHeader[SESS_LANGUAGE][6].toUpperCase()%>
					<%}%>
					&nbsp;<%=strTitle[SESS_LANGUAGE]%>	
				<%}%>
			</font></b></td>
        </tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>		
        <tr>
      <td>
        <table width="100%" border="0" cellspacing="1" cellpadding="1">
          <tr>
		  <td>
		  <%if(iCommand != Command.LIST){%>
		  <table width="100%" cellspacing="1" cellpadding="1" class="listgenactivity">		  
		  <tr>
		    <td nowrap>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    </tr>		  
          <tr> 
            <td width="17%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][0]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
              <input type="text" name="code" value="<%=strCode%>" size="10" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][1]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
              <input type="text" name="name" value="<%=strName%>" size="50" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
		  <tr> 
            <td width="17%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][2]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
				<input type="hidden" name="contact_id" value="<%=oidContact%>">
              <input type="text" name="donor_name" value="<%=strDonorName%>" size="50" onKeyDown="javascript:enterTrap()">
			  <a href ="javascript:cmdSrcContact()"><img border="0" src=<%=approot%>/dtree/img/folderopen.gif></a>			  
			  <!-- <input type="button" name="btnSrcContact" value="Search" onClick="javascript:cmdSrcContact()"> -->
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
			String attr = "onKeyDown=\"javascript:enterTrap()\"";  	
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
		  <tr><td height="17">&nbsp;</td>
		  </tr>
		  </table>
		  <%}%>
		  </td>
		  </tr>		  
		  <tr>
                  <td align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
				  <%if(iCommand == Command.LIST){%>
				  <a href="javascript:cmdViewSearch()"><%=searchData%></a>
				  <%}else{%>				  
				  <a href="javascript:cmdHide()"><%=hideSearch%></a>
				  <%}%>
				  </font>
				  </td>
                </tr>
          <tr>		        
            <td colspan="3" id="down"><%= drawList(listDonorComponent,oidDonorComponent,SESS_LANGUAGE,iCommand,frmDonorComponent,start)%>			
			</td>
          </tr>
          <tr> 
            <td colspan="3"> <span class="command"> 
              <% 
			  ControlLine ctrlLine= new ControlLine();
			  ctrlLine.initDefault(SESS_LANGUAGE,"");
			  out.println(ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left"));
			  %>
              </span> </td>
          </tr>
        </table>
      </td>
        </tr>
      </table>
	  <script language="javascript">
	  	<%if(iCommand == Command.LIST){%>
	  	document.frmdonorcomponentsearch.code.focus();
		<%}%>
	  </script>
   </form>	  
</body>
</html>
