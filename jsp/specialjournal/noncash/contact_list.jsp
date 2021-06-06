 
<% 
/* 
 * Page Name  		:  srcemployee.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		: lkarunia 
 * @version  		: 01 
 */

/*******************************************************************
 * Page Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 			: [output ...] 
 *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package wihita -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package common -->
<%@ page import = "com.dimata.common.entity.search.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.session.contact.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>

<!--package aiso -->
<%@ page import="com.dimata.aiso.form.search.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1; //AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
%>

<!-- Jsp Block -->
<%!
public static String strTitles[][] = {
	{"No","Kode","Nama Perusahaan","Telepon","Alamat","Kota","Propinsi","Negara"},
	{"No","Code","Company/Contact Name","Phone","Address","Town","Province","Country"}
};

public static String strTitle[][] = {
	{"Kelompok Kontak","Kode","Nama","Alamat","Urutkan Berdasar","Kota","Propinsi","Negara"},	
	{"Contact Class","Code","Name","Address","Sort By","Town","Province","Country"}
};

public static final String masterTitle[] = {
	"Pencarian","Search"	
};

public static final String compTitle[] = {
	"Kontak","Contact"
};

public String getJspTitle(String textJsp[][], int index, int language, String prefiks, boolean addBody){
	String result = "";
	if(addBody){
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){	
			result = textJsp[language][index] + " " + prefiks;
		}else{
			result = prefiks + " " + textJsp[language][index];		
		}
	}else{
		result = textJsp[language][index];
	} 
	return result;
}

public boolean getTruedFalse(Vector vect, long index){
	for(int i=0;i<vect.size();i++){
		long iStatus = Long.parseLong((String)vect.get(i));
		if(iStatus==index)
			return true;
	}
	return false;
}

public String drawList(int language, Vector objectClass, long oid, int start){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitles[language][0],"2%","center","center");
	ctrlist.dataFormat(strTitles[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitles[language][2],"24%","center","left");
	ctrlist.dataFormat(strTitles[language][3],"10%","center","left");
	ctrlist.dataFormat(strTitles[language][4],"24%","center","left");
	ctrlist.dataFormat(strTitles[language][5],"10%","center","left");
	ctrlist.dataFormat(strTitles[language][6],"10%","center","left");
	ctrlist.dataFormat(strTitles[language][7],"10%","center","left");

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	
	if(start<0)
		start =0;
		
	for (int i = 0; i < objectClass.size(); i++) {
		ContactList contactList = (ContactList)objectClass.get(i);
		Vector rowx = new Vector();
		
	    if(oid==contactList.getOID()){index =i;} 		
		
		start = start + 1;
		rowx.add(String.valueOf(start));
		rowx.add(cekNull(contactList.getContactCode()));		
		
		String compName = cekNull(contactList.getCompName());
        if(compName.length()==0)
            compName = cekNull(contactList.getPersonName());

        rowx.add(compName);
		rowx.add(cekNull(contactList.getTelpNr()));
        String address = cekNull(contactList.getBussAddress());
        if(address.length()==0)
		    address = cekNull(contactList.getHomeAddr());

        rowx.add(address);
		rowx.add(cekNull(contactList.getTown()));
		rowx.add(cekNull(contactList.getProvince()));
		rowx.add(cekNull(contactList.getCountry()));	
		
		lstData.add(rowx);
		lstLinkData.add(String.valueOf(contactList.getOID())+"','"+compName);
	}
	return ctrlist.drawMe(index);
}

public String cekNull(String val){
	if(val==null || val.length()==0)
		val = "";
	return val;	
}

%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int type = FRMQueryString.requestInt(request,"contact_class");
long oidContactList = FRMQueryString.requestLong(request, "hidden_contact_id");
int start = FRMQueryString.requestInt(request, "start");
int srcFrom = FRMQueryString.requestInt(request, "src_from");

System.out.println("start ====== > "+ start);

SrcContactList srcContactList = new SrcContactList();
FrmSrcContactList frmSrcContactList = new FrmSrcContactList();

//long typed = FRMQueryString.requestLong(request, "contact_class");

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = compTitle[SESS_LANGUAGE];
//String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSearchComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);

ctrLine.setLanguage(SESS_LANGUAGE);
//String currPageTitle = compTitle[SESS_LANGUAGE];
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strBackComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK_SEARCH,true);
String strNoCompany = SESS_LANGUAGE==langForeign ? "No "+currPageTitle+" Available" : "Tidak Ada "+currPageTitle; 
String strMergeComp = SESS_LANGUAGE==langForeign ? currPageTitle + " Merge" : "Penggabungan " + currPageTitle;
String strReset = SESS_LANGUAGE==langForeign ? "Reset" : "Kosongkan";
String searchData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View Search Form" : "Cari Data";
String hideSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Hide Search Form" : "Sembunyikan Form Cari Data";

int recordToGet = 20;
int vectSize = 0;
String whereClause = "";
int iErrCode = FRMMessage.ERR_NONE;
String msgStr = "";

//if using deduplicate contact, set this variable TRUE otherwise FALSE
boolean useDeduplicate = false; //true;

/**
* instantiate some object used in this page
*/
CtrlContactList ctrlContactList = new CtrlContactList(request);
SessContactList sessContactList = new SessContactList();
frmSrcContactList = new FrmSrcContactList(request, srcContactList);


if(iCommand==Command.BACK){
	frmSrcContactList = new FrmSrcContactList(request, srcContactList);
	try{
		srcContactList = (SrcContactList)session.getValue(SessContactList.SESS_SRC_CONTACT_LIST);
		if(srcContactList == null) {
			srcContactList = new SrcContactList();
		}
	}catch(Exception e){
		srcContactList = new SrcContactList();
	}
}

/**
* handle current search data session 
*/
if(iCommand==Command.BACK || iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	 try{ 
		srcContactList = (SrcContactList)session.getValue(SessContactList.SESS_SRC_CONTACT_LIST); 
	 }catch(Exception e){ 
		srcContactList = new SrcContactList();
	 }
}else{
	 frmSrcContactList.requestEntityObject(srcContactList);
	 Vector vectSt = new Vector(1,1);
	 String[] strStatus = request.getParameterValues(frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_TYPE]);
	 if(strStatus!=null && strStatus.length>0){
		 for(int i=0; i<strStatus.length; i++){        
			try{
				vectSt.add(strStatus[i]);
			}catch(Exception exc){
				System.out.println("err");
			}
		 }
	 }
	 srcContactList.setType(vectSt);
	 session.putValue(SessContactList.SESS_SRC_CONTACT_LIST, srcContactList);
}

if(cHeckBoxContact.equalsIgnoreCase("N")){
	if(iCommand==Command.LIST || iCommand==Command.BACK || iCommand==Command.NONE){	
		 Vector vType = new Vector(1,1);
		 try{
			 long idContactClassCashier = PstContactClass.getIdContactType(PstContactClass.CONTACT_TYPE_EMPLOYEE);
			 String strIdTypeContClass = String.valueOf(idContactClassCashier); 
			 vType.add(strIdTypeContClass);		
		 }catch(Exception e){
			System.out.println("Exception on getIdContactClass ==> "+e.toString());
		 }
		 srcContactList.setType(vType);
	}
}	

/**
* get vectSize, start and data to be display in this page
*/
vectSize = sessContactList.countCompany(srcContactList);
if(iCommand!=Command.BACK){  
	start = ctrlContactList.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

Vector records = sessContactList.searchCompany(srcContactList, start, recordToGet);

if(useDeduplicate){
	if(session.getValue("DEDUPLICATE_COMPANY")!=null){
		session.removeValue("DEDUPLICATE_COMPANY");
	}
	session.putValue("DEDUPLICATE_COMPANY",records);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
		document.frm_contactlist.command.value="<%=Command.ADD%>";
		document.frm_contactlist.action="srccontact_list.jsp.jsp";
		document.frm_contactlist.submit(); 
}

function cmdSearch(){
		document.frm_contactlist.command.value="<%=Command.LIST%>";
		document.frm_contactlist.action="contact_list.jsp";
		document.frm_contactlist.submit();
}

function fnTrapKD(){
   if (event.keyCode == 13) { 
		document.all.aSearch.focus();
		cmdSearch();
   }
}
function cmdAdd(){
	document.frm_contactlist.command.value="<%=Command.ADD%>";
	document.frm_contactlist.action="contact_list.jsp";
	document.frm_contactlist.submit();
}

function cmdEdit(oid, name){  
        self.opener.document.forms.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_CONTACT_ID]%>.value = oid;
        self.opener.document.forms.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_CONTACT_ID]%>_TEXT.value = name;		
        self.close();
}

function first(){
	document.frm_contactlist.command.value="<%=Command.FIRST%>";
	document.frm_contactlist.action="contact_list.jsp";
	document.frm_contactlist.submit();
}

function prev(){
	document.frm_contactlist.command.value="<%=Command.PREV%>";
	document.frm_contactlist.action="contact_list.jsp";
	document.frm_contactlist.submit();
}

function next(){
	document.frm_contactlist.command.value="<%=Command.NEXT%>";
	document.frm_contactlist.action="contact_list.jsp";
	document.frm_contactlist.submit();
}

function last(){
	document.frm_contactlist.command.value="<%=Command.LAST%>";
	document.frm_contactlist.action="contact_list.jsp";
	document.frm_contactlist.submit();
}

function cmdBack(){
	document.frm_contactlist.command.value="<%=Command.BACK%>";
	document.frm_contactlist.action="contact_list.jsp";
	document.frm_contactlist.submit();
}

function cmdViewSearch(){
	document.frm_contactlist.command.value="<%=Command.NONE%>";	
	document.frm_contactlist.action="contact_list.jsp";
	document.frm_contactlist.submit();
}

function cmdHideSearch(){
	document.frm_contactlist.command.value="<%=Command.LIST%>";	
	document.frm_contactlist.action="contact_list.jsp";
	document.frm_contactlist.submit();
}


function cmdDeduplicate(){
	var strUrl = "deduplicate_company.jsp"; 
	window.open(strUrl,"personnel","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
}

function cmdReset(){
	document.frm_contactlist.action="donor_list.jsp";
	document.frm_contactlist.<%=FrmSrcContactList.fieldNames[FrmSrcContactList.FRM_FIELD_CODE]%>.value = "";
	document.frm_contactlist.<%=FrmSrcContactList.fieldNames[FrmSrcContactList.FRM_FIELD_NAME]%>.value = "";
	document.frm_contactlist.<%=FrmSrcContactList.fieldNames[FrmSrcContactList.FRM_FIELD_ADDRESS]%>.value = "";
	document.frm_contactlist.<%=FrmSrcContactList.fieldNames[FrmSrcContactList.FRM_FIELD_CITY]%>.value = "";
	document.frm_contactlist.<%=FrmSrcContactList.fieldNames[FrmSrcContactList.FRM_FIELD_PROVINCE]%>.value = "";
	document.frm_contactlist.<%=FrmSrcContactList.fieldNames[FrmSrcContactList.FRM_FIELD_COUNTRY]%>.value = "";	
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<SCRIPT language="javascript">
<!--
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

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a && i < a.length && (x=a[i]) && x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i < a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0 && parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n]) && d.all) x=d.all[n]; for (i=0;!x && i < d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x && d.layers && i < d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
-->
</SCRIPT>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
            <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=compTitle[SESS_LANGUAGE]%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
		   <script language="JavaScript">
		  		window.focus();
		  </SCRIPT>
            <form name="frm_contactlist" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="contact_class" value="<%=type%>">
			  <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="src_from" value="<%=srcFrom%>">
              <input type="hidden" name="hidden_contact_id" value="<%=oidContactList%>">
			  <%try{%>
              <table border="0" width="100%">
                <tr> 
                  <td width="2%" height="8">&nbsp; 
                    
                  </td>
                  <td width="98%">
				  	<%if(iCommand != Command.LIST){%>
				  	<table border="0" cellspacing="2" cellpadding="2" width="100%">
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                              <td width="1%">:</td>
                              <td width="89%">
							  <%
							  String whClause = PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE]+" = "+PstContactClass.CONTACT_TYPE_EMPLOYEE;
							  Vector vectClass = new Vector(1,1);
							  String disabled = "";							 
							  if(cHeckBoxContact.equalsIgnoreCase("N")){
							  		vectClass = PstContactClass.list(0,0,whClause,"");
									disabled = "disabled";									
							 	}else{
									vectClass = PstContactClass.listAll();
									disabled = "";
								}							  
							  for(int i=0; i<vectClass.size(); i++){
							  	ContactClass cntClass = (ContactClass)vectClass.get(i);
								long idxContactClass = cntClass.getOID();							
								String strContactClass = cntClass.getClassName();							  							  
							  %>
							  <input type="checkbox" <%=disabled%> class="formElemen" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_TYPE]%>" value="<%=(idxContactClass)%>" <%if(getTruedFalse(srcContactList.getType(),idxContactClass)){%>checked<%}%> >
							  <%=strContactClass%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							  <%}%>							  
							  </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_CODE] %>"  value="<%=srcContactList.getCode()%>" onkeydown="javascript:fnTrapKD()" size="20">
                              </td> 
                            </tr>
                            <!-- <script language="javascript">
								document.frm_contactlist.<%//=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_CODE]%>.focus();
							</script> -->
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_NAME] %>"  value="<%=srcContactList.getName()%>" size="40" onkeydown="javascript:fnTrapKD()">
								<!-- <input type="text" name="name"  value="<%//=srcContactList.getName()%>" size="40" onkeydown="javascript:fnTrapKD()"> -->
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_ADDRESS] %>"  value="<%=srcContactList.getAddress()%>" size="60" onkeydown="javascript:fnTrapKD()">
                              </td>
                            </tr>
							<tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_CITY] %>"  value="<%=srcContactList.getCity()%>" size="40" onkeydown="javascript:fnTrapKD()">
								<!-- <input type="text" name="name"  value="<%//=srcContactList.getName()%>" size="40" onkeydown="javascript:fnTrapKD()"> -->
                              </td>
                            </tr>
							<tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_PROVINCE] %>"  value="<%=srcContactList.getProvince()%>" size="40" onkeydown="javascript:fnTrapKD()">
								<!-- <input type="text" name="name"  value="<%//=srcContactList.getName()%>" size="40" onkeydown="javascript:fnTrapKD()"> -->
                              </td>
                            </tr>
							<tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_COUNTRY] %>"  value="<%=srcContactList.getCountry()%>" size="40" onkeydown="javascript:fnTrapKD()">
								<!-- <input type="text" name="name"  value="<%//=srcContactList.getName()%>" size="40" onkeydown="javascript:fnTrapKD()"> -->
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%" height="21" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <%= ControlCombo.draw(frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_ORDER],"",null, ""+srcContactList.getOrderBy(), frmSrcContactList.getOrderValue(), frmSrcContactList.getOrderKey(SESS_LANGUAGE), " onkeydown=\"javascript:fnTrapKD()\"") %> </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%">&nbsp;</td>
                              <td width="1%">&nbsp;</td>
                              <td width="89%">&nbsp;</td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%"> 
                                <div align="left"></div>
                              </td>
                              <td width="1%" class="command">&nbsp;</td>
                              <td width="89%" class="command">&nbsp;&nbsp;<input name="viewListContact" type="button" onClick="javascript:cmdSearch()" value="<%=strSearchComp%>"> 
							  <input name="btnReset" type="button" onClick="javascript:cmdReset()" value="<%=strReset%>">
                              </td>
                            </tr>
                    </table>
					<%}%>
				  </td>
                </tr>
              </table>			  			  
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td colspan="2"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                      <tr> 
                        <td width="97%"> 
                          
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
			  <%}catch(Exception e){
			  	System.out.println("err : "+e.toString());
				}
			  %>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	            <%if((records!=null)&&(records.size()>0)){%>			  
                <tr>
                  <td>&nbsp;</td>
                  <td align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
				  <%if(iCommand == Command.LIST){%>
				  <a href="javascript:cmdViewSearch()"><%=searchData%></a>
				  <%}else{%>				  
				  <a href="javascript:cmdHideSearch()"><%=hideSearch%></a>
				  <%}%>
				  </font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><%=drawList(SESS_LANGUAGE,records,oidContactList,start)%></td>
                </tr>			  
                <%}else{%>
                <tr> 
                  <td>&nbsp;</td>
                  <td><span class="comment"><%=strNoCompany%></span></td>
                </tr>			  				
				<%}%>				
                <tr> 
                  <td>&nbsp;
				  </td>
                  <td><%ctrLine.initDefault(SESS_LANGUAGE,"");%>
                    <%=ctrLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </td>
                </tr>				
                <tr>
                  <td align="left" nowrap class="command">&nbsp;</td>
                  <td align="left" nowrap class="command">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="2%" align="left" nowrap class="command">&nbsp;
				  </td>
                  <td width="98%" align="left" nowrap class="command"><%if(privAdd){%>
                    <a href="javascript:cmdAdd()" class="command"><%=strAddComp%> | </a>
                    <%}%>
					<%if(commandBack.equalsIgnoreCase("Y")){%>
					<a href="javascript:cmdBack()" class="command"><%=strBackComp%></a>
					<%}%>
					<%if(records!=null && records.size()>0 && useDeduplicate){%>
					| <a href="javascript:cmdDeduplicate()"><%=strMergeComp%></a>
					<%}%></td>
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
