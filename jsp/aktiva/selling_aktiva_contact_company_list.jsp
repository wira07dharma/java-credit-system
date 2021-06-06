<% 
/* 
 * Page Name  		:  contactlist_list.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		: karya 
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
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package prochain02 -->
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.entity.search.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>
<%@ page import = "com.dimata.common.session.contact.*" %>
<%@ page import = "com.dimata.aiso.form.aktiva.FrmSellingAktiva"%>
<%@ page import = "java.util.*,
                   com.dimata.aiso.form.aktiva.FrmOrderAktiva" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

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

<!-- Jsp Block -->
<%!
public static String strTitle[][] = {
	{	
		"No",
		"Kode",
		"Nama Perusahaan",
		"Nama Kontak",
		"Telepon",
		"Alamat",
		"Kelompok Kontak",
		"Urut Berdasarkan"
	},
	
	{	
		"No",
		"Code",
		"Company Name",
		"Contact Name",
		"Phone",
		"Address",
		"Contact Class",
		"Sort By"
	}
};

public static final String masterTitle[] = {
	"Daftar","List"	
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
	ctrlist.dataFormat(strTitle[language][0],"2%","left","left");
	ctrlist.dataFormat(strTitle[language][1],"11%","left","left");
	ctrlist.dataFormat(strTitle[language][2],"22%","left","left");
	ctrlist.dataFormat(strTitle[language][3],"22%","left","left");
	ctrlist.dataFormat(strTitle[language][4],"11%","left","left");
	ctrlist.dataFormat(strTitle[language][5],"33%","left","left");

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
		rowx.add(cekNull(contactList.getCompName()));
		rowx.add(cekNull(contactList.getPersonName())+" "+cekNull(contactList.getPersonLastname()));
		rowx.add(cekNull(contactList.getTelpNr()));
		rowx.add(cekNull(contactList.getBussAddress()));
		
		lstData.add(rowx);
		lstLinkData.add(String.valueOf(contactList.getOID())+"','"+mergeString(contactList.getCompName(),contactList.getPersonName()));
		//lstLinkData.add(String.valueOf(contactList.getOID()));
	}
	return ctrlist.drawMe(index);
}

public String cekNull(String val){
	if(val==null)
		val = "";
	return val;	
}

public String mergeString(String name1, String name2){
	if(name1==null || name1.length()==0){
        if(name2==null || name2.length()==0){
            return "";
        }
        else{
            return name2;
        }
    }
    else{
        if(name2==null || name2.length()==0){
            return name1;
        }
        else{
            return name1 + " / " + name2;
        }
    }
}

%>

<%
int iCommand = FRMQueryString.requestCommand(request);
long oidContactList = FRMQueryString.requestLong(request, "hidden_contact_id");
int start = FRMQueryString.requestInt(request, "start");

/**
* Setup controlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = compTitle[SESS_LANGUAGE];
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strBackComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK_SEARCH,true);
String strNoCompany = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "No "+currPageTitle+" Available" : "Tidak Ada "+currPageTitle;
String strSearchComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);
 

int recordToGet = 5;
int vectSize = 0;
String whereClause = "";
int iErrCode = FRMMessage.ERR_NONE;
String msgStr = "";

//if using deduplicate contact, set this variable TRUE otherwise FALSE
boolean useDeduplicate = true;


/**
* instantiate some object used in this page
*/
CtrlContactList ctrlContactList = new CtrlContactList(request);
SrcContactList srcContactList = new SrcContactList();
SessContactList sessContactList = new SessContactList();
FrmSrcContactList frmSrcContactList = new FrmSrcContactList(request, srcContactList);
		
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
<!-- End of Jsp Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function cmdAdd(){
	document.frm_contactlist.command.value="<%=Command.ADD%>";
	document.frm_contactlist.action="contact_company_edit.jsp";
	document.frm_contactlist.submit();
}

/*function cmdEdit(oid){
	document.frm_contactlist.command.value="<%=Command.EDIT%>";
	document.frm_contactlist.hidden_contact_id.value = oid;
	document.frm_contactlist.action="contact_company_edit.jsp";
	document.frm_contactlist.submit();
}*/

/*function cmdEdit(oid){
    self.opener.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_KONSUMEN_ID]%>_TEXT.value = oid;    
    self.close();

}*/

function cmdEdit(oid, name){ 
    self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_SUPPLIER_ID]%>.value = oid;
    self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_SUPPLIER_ID]%>_TEXT.value = name;
    self.close();
}

function first(){
	document.frm_contactlist.command.value="<%=Command.FIRST%>";
	document.frm_contactlist.action="contact_company_list.jsp";
	document.frm_contactlist.submit();
}

function prev(){
	document.frm_contactlist.command.value="<%=Command.PREV%>";
	document.frm_contactlist.action="contact_company_list.jsp";
	document.frm_contactlist.submit();
}

function next(){
	document.frm_contactlist.command.value="<%=Command.NEXT%>";
	document.frm_contactlist.action="contact_company_list.jsp";
	document.frm_contactlist.submit();
}

function last(){
	document.frm_contactlist.command.value="<%=Command.LAST%>";
	document.frm_contactlist.action="contact_company_list.jsp";
	document.frm_contactlist.submit();
}

function cmdBack(){
	document.frm_contactlist.command.value="<%=Command.BACK%>";
	document.frm_contactlist.action="srccontact_list.jsp";
	document.frm_contactlist.submit();
}

function cmdSearch(){
		document.frm_contactlist.command.value="<%=Command.LIST%>";
		document.frm_contactlist.action="selling_aktiva_contact_company_list.jsp";
		document.frm_contactlist.submit();
}

function cmdDeduplicate(){
	var strUrl = "deduplicate_company.jsp"; 
	window.open(strUrl,"personnel","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
}
//-------------- script control line -------------------
//-->
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
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
//-->
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
            <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frm_contactlist" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="hidden_contact_id" value="<%=oidContactList%>">
              <table border="0" width="100%">                
		    <tr> 
                  <td height="8">&nbsp; 
                    
                  </td>
                </tr>			
              </table> 
			
				<table border="0" cellspacing="2" cellpadding="2" width="100%">
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></td>
                              <td width="1%">:</td>
                              <td width="89%"><table width="100%">
							  <%
							  Vector vectClass = PstContactClass.listAll();
							  	int iCount = 0;						
								int iMaxColumn = 4;
								int iMaxRow = vectClass.size() / iMaxColumn;
								if(vectClass.size() % iMaxColumn > 0)
								iMaxRow += 1;					   
								for(int r = 0; r < iMaxRow; r++){		
								%>
								<tr>						  
							  <%for(int i=0; i<iMaxColumn; i++){
							  	ContactClass cntClass = (ContactClass)vectClass.get(iCount);
								long idxContactClass = cntClass.getOID();							
								String strContactClass = cntClass.getClassName();							  							  
							  %>
							  <td><input type="checkbox" class="formElemen" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_TYPE]%>" value="<%=(idxContactClass)%>" <%if(getTruedFalse(srcContactList.getType(),idxContactClass)){%>checked<%}%>>
							  <%=strContactClass%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td> <%iCount++;%>
							  <%
								  	if(iCount >= vectClass.size())
										break;
								  %>
							  <%}%>	
							   </tr>
							  <%}%>
							  </table>						  
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
                            <script language="javascript">
								document.frm_contactlist.<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_CODE]%>.focus();
							</script>
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_NAME] %>"  value="<%=srcContactList.getName()%>" size="40" onkeydown="javascript:fnTrapKD()">
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_ADDRESS] %>"  value="<%=srcContactList.getAddress()%>" size="60" onkeydown="javascript:fnTrapKD()">
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%" height="21" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <%= ControlCombo.draw(frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_ORDER],"formElemen",null, ""+srcContactList.getOrderBy(), frmSrcContactList.getOrderValue(), frmSrcContactList.getOrderKey(SESS_LANGUAGE), " onkeydown=\"javascript:fnTrapKD()\"") %> </td>
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
                              <td width="89%" class="command">&nbsp;<a id="aSearch" href="javascript:cmdSearch()"><%=strSearchComp%></a> 
                                <% if(privAdd){%>
                                | <a href="javascript:cmdAdd()"><%=strAddComp%></a> 
                                <%}%>
                              </td>
                            </tr>
                          </table>
				                   
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
	            <%if((records!=null)&&(records.size()>0)){%>			  
                <tr> 
                  <td><%=drawList(SESS_LANGUAGE,records,oidContactList,start)%></td>
                </tr>			  
                <%}else{%>
                <tr> 
                  <td><span class="comment"><%=strNoCompany%></span></td>
                </tr>			  				
				<%}%>				
                <tr> 
                  <td>
				  <%=ctrLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> 
                  </td>
                </tr>				
                <!-- <tr> 
                  <td width="46%" nowrap align="left" class="command">
				  <%if(privAdd){%><a href="javascript:cmdAdd()" class="command"><%=strAddComp%></a><%}%> | <a href="javascript:cmdBack()" class="command"><%=strBackComp%></a>
                  </td>
                </tr> -->								
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