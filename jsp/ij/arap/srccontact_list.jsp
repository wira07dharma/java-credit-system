 
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

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
%>

<!-- Jsp Block -->
<%!
public static String strTitle[][] = {
	{"Kelompok Kontak","Kode","Nama","Alamat","Urutkan Berdasar"},	
	{"Contact Class","Code","Name","Address","Sort By"}
};

public static final String masterTitle[] = {
	"Hutang/Piutang","A.R./A.P."	
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
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
SrcContactList srcContactList = new SrcContactList();
FrmSrcContactList frmSrcContactList = new FrmSrcContactList();

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = compTitle[SESS_LANGUAGE];
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSearchComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);

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
%>
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
		document.frm_contactlist.command.value="<%=Command.ADD%>";
		document.frm_contactlist.action="contact_company_edit.jsp";
		document.frm_contactlist.submit(); 
}

function cmdSearch(){
		document.frm_contactlist.command.value="<%=Command.LIST%>";
		document.frm_contactlist.action="contact_company_list.jsp";
		document.frm_contactlist.submit();
}

function fnTrapKD(){
   if (event.keyCode == 13) { 
		document.all.aSearch.focus();
		cmdSearch();
   }
}
</script>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<SCRIPT language="javascript">

</SCRIPT>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">

  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" -->
            <%=masterTitle[SESS_LANGUAGE]%> &gt; <%=currPageTitle%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frm_contactlist" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
			  <%try{%>
              <table border="0" width="100%">
                <tr> 
                  <td height="8"> 
                    <hr>
                  </td>
                </tr>
              </table>			  			  
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td colspan="2"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                      <tr> 
                        <td width="97%"> 
                          <table border="0" cellspacing="2" cellpadding="2" width="100%">
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                              <td width="1%">:</td>
                              <td width="89%">
							  <%
							  Vector vectClass = PstContactClass.listAll();						  
							  for(int i=0; i<vectClass.size(); i++){
							  	ContactClass cntClass = (ContactClass)vectClass.get(i);
								long idxContactClass = cntClass.getOID();							
								String strContactClass = cntClass.getClassName();							  							  
							  %>
							  <input type="checkbox" class="formElemen" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_TYPE]%>" value="<%=(idxContactClass)%>" <%if(getTruedFalse(srcContactList.getType(),idxContactClass)){%>checked<%}%>>
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
                            <script language="javascript">
								document.frm_contactlist.<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_CODE]%>.focus();
							</script>
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></div>
                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_NAME] %>"  value="<%=srcContactList.getName()%>" size="40" onkeydown="javascript:fnTrapKD()">
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
                              <td width="10%" height="21" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></div>
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
            </form>
            <!-- #EndEditable --></td>
        </tr>
      </table>
    </td>
  </tr>

</table>
</body>
<!-- #EndTemplate -->
</html>
