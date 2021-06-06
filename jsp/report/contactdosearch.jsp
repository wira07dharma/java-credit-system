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
<%@ include file = "../main/javainit.jsp" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package common -->
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.common.session.contact.*" %>
<!--package aiso -->
<%@ page import = "com.dimata.aiso.entity.jurnal.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.jurnal.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.journal.*" %>

<%!
public static final int SORT_BY_CODE = 0;
public static final int SORT_BY_NAME = 1;

/* this constant used to list text of listHeader */
public static final String textListHeader[][] = { 
	{"No","Kode","Nama","Alamat","Telepon"},
	{"No","Code","Name","Address","Telepon"}
};

public String drawList(int language, Vector objectClass, int start){
	String result = "";
	if(objectClass!=null && objectClass.size()>0){
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%"); 
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		
		ctrlist.dataFormat(textListHeader[language][0],"5%","left","left");
		ctrlist.dataFormat(textListHeader[language][1],"15%","left","left");
		ctrlist.dataFormat(textListHeader[language][2],"30%","left","left");
		ctrlist.dataFormat(textListHeader[language][3],"40%","left","left");
		ctrlist.dataFormat(textListHeader[language][4],"10%","left","left");
	
		ctrlist.setLinkRow(2);
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
			Vector vt = (Vector)objectClass.get(i);			
			ContactList contactList = (ContactList)vt.get(0); 
			ContactClass cntClass = (ContactClass)vt.get(1);
	
			Vector rowx = new Vector();
			start = start + 1;
			rowx.add(""+start);		
			rowx.add(contactList.getContactCode());
			String cntName = contactList.getCompName();
			if(cntName.length()==0){
				cntName = contactList.getPersonName()+" "+contactList.getPersonLastname();			
			}
			rowx.add(cntName);			
			rowx.add(contactList.getBussAddress());
			rowx.add(contactList.getTelpNr());
	
			lstData.add(rowx);
			lstLinkData.add(contactList.getOID()+"','"+cntName);
		}
		result = ctrlist.drawMe(-1);
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
long contactType = FRMQueryString.requestLong(request,"contact_type");
String contactCode = FRMQueryString.requestString(request,"contact_code");
String contactName = FRMQueryString.requestString(request,"contact_name");
int intSortBy = FRMQueryString.requestInt(request,"sort_by");

int recordToGet = 20;
String pageHeader = "Search Contact"; 
String pageTitle = "SEARCH CONTACT";    


Vector vtClass = new Vector(1,1);
if(contactType!=-1){
	vtClass.add(String.valueOf(contactType));	
}

Vector vtCode = new Vector(1,1);
if(contactCode.length()>0){
	vtCode.add(contactCode);
}

Vector vtName = new Vector(1,1);
if(contactName.length()>0){
	vtName.add(contactName);
}


int vectSize = PstContactList.getCountListContact(vtClass,vtCode,vtName);

CtrlContactList ctrlContactList = new CtrlContactList(request);
if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	start = ctrlContactList.actionList(iCommand,start,vectSize,recordToGet);
} 
 
String sortBy = "";
if(intSortBy==SORT_BY_CODE){
	sortBy = "CNT."+PstContactList.fieldNames[PstContactList.FLD_CONTACT_CODE];
}else{
	sortBy = "CNT."+PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME]+
			 ",CNT."+PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME]+
			 ",CNT."+PstContactList.fieldNames[PstContactList.FLD_COMP_NAME]+
			 ",CNT."+PstContactList.fieldNames[PstContactList.FLD_CONTACT_CODE];			 
} 
Vector vect = PstContactList.getListContact(vtClass,vtCode,vtName,start,recordToGet,sortBy); 	
%>
<!-- End of JSP Block -->

<html>
<head>
<title><%=pageHeader%></title>
<script language="JavaScript">
function cmdEdit(oid,name){
	self.opener.document.forms.frmGeneralLedger.contact_id.value = oid;
	self.opener.document.forms.frmGeneralLedger.contact_name.value = name;
	self.close();
}

function first(){
	document.frmvendorsearch.command.value="<%=Command.FIRST%>";
	document.frmvendorsearch.action="contactdosearch.jsp";
	document.frmvendorsearch.submit();
}

function prev(){
	document.frmvendorsearch.command.value="<%=Command.PREV%>";
	document.frmvendorsearch.action="contactdosearch.jsp";
	document.frmvendorsearch.submit();
}

function next(){
	document.frmvendorsearch.command.value="<%=Command.NEXT%>";
	document.frmvendorsearch.action="contactdosearch.jsp";
	document.frmvendorsearch.submit();
}

function last(){
	document.frmvendorsearch.command.value="<%=Command.LAST%>";
	document.frmvendorsearch.action="contactdosearch.jsp";
	document.frmvendorsearch.submit();
}

function cmdSearch(){
	document.frmvendorsearch.command.value="<%=Command.LIST%>";
	document.frmvendorsearch.start.value="0";	
	document.frmvendorsearch.action="contactdosearch.jsp";
	document.frmvendorsearch.submit();
}	

function cmdClear(){
	document.frmvendorsearch.contact_code.value="";
	document.frmvendorsearch.contact_name.value="";	
}	

function enterTrap(){
	if(event.keyCode==13){
		document.frmvendorsearch.btnSubmit.focus();
		cmdSearch();
	}
}	
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>
<body>
<script language="JavaScript">
	window.focus();
</script>
	<form name="frmvendorsearch" method="post" action="">
	  <input type="hidden" name="start" value="<%=start%>">
	  <input type="hidden" name="command" value="<%=iCommand%>">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>          
      		
      <td height="20" class="title" align="center"><b><font size="3">SEARCH CONTACT</font></b></td>
        </tr>		
        <tr>           
      <td> 
        <table width="100%" border="0" cellspacing="1" cellpadding="1">
          <tr> 
            <td width="12%">&nbsp;</td>
            <td width="1%">&nbsp;</td>
            <td width="87%">&nbsp;</td>
          </tr>
          <tr> 
            <td width="12%">&nbsp;Contact Type</td>
            <td width="1%">:</td>
            <td width="87%"> 
              <%
			String whereClauseClass = "";
			String orderByClass = "";
			Vector listContactClass = PstContactClass.list(0,0,whereClauseClass,orderByClass);
			Vector vectClassVal = new Vector(1,1);
			Vector vectClassKey = new Vector(1,1);
			vectClassVal.add("All Contact Type");
			vectClassKey.add("-1");																	  				  						
			if(listContactClass!=null && listContactClass.size()>0){
				for(int i=0; i<listContactClass.size(); i++){
					ContactClass contClass = (ContactClass)listContactClass.get(i);					
					if(contClass.getClassType()==PstContactClass.FLD_CLASS_VENDOR || 
					   contClass.getClassType()==PstContactClass.CONTACT_TYPE_EMPLOYEE ||
					   contClass.getClassType()==PstContactClass.FLD_CLASS_OTHERS){
					   vectClassVal.add(contClass.getClassName());
					   vectClassKey.add(String.valueOf(contClass.getOID()));
					}
				}
			}else{
				vectClassVal.add("No Contact Type Available");
				vectClassKey.add("0");			
			}
			String attr = "onKeyDown=\"javascript:enterTrap()\"";
		    out.println(ControlCombo.draw("contact_type","formElemen",null,""+contactType,vectClassKey,vectClassVal,attr));						
			%>
            </td>
          </tr>
          <tr> 
            <td width="12%">&nbsp;Contact Code</td>
            <td width="1%">:</td>
            <td width="87%"> 
              <input type="text" name="contact_code" value="<%=contactCode%>" class="formElemen" size="19" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
          <tr> 
            <td width="12%">&nbsp;Contact Name</td>
            <td width="1%">:</td>
            <td width="87%"> 
              <input type="text" name="contact_name" value="<%=contactName%>" class="formElemen" size="40" onKeyDown="javascript:enterTrap()">
            </td>
          </tr>
          <tr> 
            <td width="12%">&nbsp;Sort By</td>
            <td width="1%">:</td>
            <td width="87%"> 
            <%
			Vector vectSortVal = new Vector(1,1);
			Vector vectSortKey = new Vector(1,1);
			vectSortVal.add("Contact Code");
			vectSortKey.add(""+SORT_BY_CODE);																	  				  						
			vectSortVal.add("Contact Name");
			vectSortKey.add(""+SORT_BY_NAME);			
		    out.println(ControlCombo.draw("sort_by","formElemen",null,""+intSortBy,vectSortKey,vectSortVal,attr));						
			%>
            </td>
          </tr>
          <tr> 
            <td width="12%">&nbsp;</td>
            <td width="1%">&nbsp;</td>
            <td width="87%"> 
              <input type="button" name="btnSubmit" value="Search" onClick="javascript:cmdSearch()" class="formElemen">
              <input type="button" name="btnReset" value="Reset" onClick="javascript:cmdClear()" class="formElemen">
            </td>
          </tr>
          <tr> 
            <td colspan="3"><%=drawList(com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN,vect,start)%></td>
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
   </form>	  
</body>
</html>
