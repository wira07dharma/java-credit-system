
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.aiso.entity.search.SrcBussinessGroup" %>
<%@ page import = "com.dimata.aiso.form.search.FrmSrcBussGroup" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.BussinessGroup" %>
<%@ page import = "com.dimata.aiso.session.masterdata.SessBussGroup" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "/main/checkuser.jsp" %>

<%
/** Check privilege except VIEW, view is already checked on checkuser.jsp as basic access */
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
//boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));
%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
%>

<!-- Jsp Block -->
<%!
public static String strTitle[][] = {
	{"Kode","Nama","Alamat","Kota","Telp","Fax","Urutkan Berdasar"},	
	{"Code","Name","Address","Town","Phone","Fax","Sort By"}
};

public static final String masterTitle[] = {
	"Pencarian Kelompok Bisnis","Bussiness Group Inquiries"	
};

public static final String compTitle[] = {
	"Kelompok Bisnis","Bussiness Group"
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
SrcBussinessGroup srcBussinessGroup = new SrcBussinessGroup();
FrmSrcBussGroup frmSrcBussGroup = new FrmSrcBussGroup();

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = compTitle[SESS_LANGUAGE];
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSearchComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);

if(iCommand==Command.BACK){
	frmSrcBussGroup = new FrmSrcBussGroup(request, srcBussinessGroup);
	try{
		srcBussinessGroup = (SrcBussinessGroup)session.getValue(SessBussGroup.SESS_BUSS_GROUP);
		if(srcBussinessGroup == null) {
			srcBussinessGroup = new SrcBussinessGroup();
		}
	}catch(Exception e){
		srcBussinessGroup = new SrcBussinessGroup();
	}
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
		document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.command.value="<%=Command.ADD%>";
		document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.action="edit_buss_group.jsp";
		document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.submit(); 
}

function cmdSearch(){
		document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.command.value="<%=Command.LIST%>";
		document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.action="list_buss_group.jsp";
		document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.submit();
}

function fnTrapKD(){
   if (event.keyCode == 13) { 
		document.all.aSearch.focus();
		cmdSearch();
   }
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<SCRIPT language="javascript">
<!--

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
            <b><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font></b><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
			  <%try{%>
              <table border="0" width="100%">
                <tr> 
                  <td height="8">
                    
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
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcBussGroup.fieldNames[frmSrcBussGroup.FRM_FIELD_CODE] %>"  value="<%=srcBussinessGroup.getCode()%>" onKeyDown="javascript:fnTrapKD()" size="20">                              </td> 
                            </tr>
                            <script language="javascript">
								document.frm_contactlist.<%=frmSrcBussGroup.fieldNames[frmSrcBussGroup.FRM_FIELD_CODE]%>.focus();
							</script>
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcBussGroup.fieldNames[frmSrcBussGroup.FRM_FIELD_NAME] %>"  value="<%=srcBussinessGroup.getName()%>" size="40" onKeyDown="javascript:fnTrapKD()">                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp;
                              <input type="text" name="<%=frmSrcBussGroup.fieldNames[frmSrcBussGroup.FRM_FIELD_ADDRESS] %>"  value="<%=srcBussinessGroup.getAddress()%>" size="60" onKeyDown="javascript:fnTrapKD()"></td>
                            </tr>
							<!-- start update -->
							<tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp;
                              <input type="text" name="<%=frmSrcBussGroup.fieldNames[frmSrcBussGroup.FRM_FIELD_CITY] %>"  value="<%=srcBussinessGroup.getCity()%>" size="40" onKeyDown="javascript:fnTrapKD()"></td>
                            </tr>
							<tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcBussGroup.fieldNames[frmSrcBussGroup.FRM_FIELD_PHONE]%>"  value="<%=srcBussinessGroup.getPhone()%>" size="40" onKeyDown="javascript:fnTrapKD()">                              </td>
                            </tr>
							<tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcBussGroup.fieldNames[frmSrcBussGroup.FRM_FIELD_FAX] %>"  value="<%=srcBussinessGroup.getFax()%>" size="40" onKeyDown="javascript:fnTrapKD()">                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
								<td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <%= ControlCombo.draw(frmSrcBussGroup.fieldNames[frmSrcBussGroup.FRM_FIELD_ORDER],"formElemen",null, ""+srcBussinessGroup.getOrderBy(), frmSrcBussGroup.getOrderValue(), frmSrcBussGroup.getOrderKey(SESS_LANGUAGE), " onkeydown=\"javascript:fnTrapKD()\"") %> </td>
                            </tr>
							<!-- End Update -->
                            <tr align="left" valign="top"> 
                              <td width="10%">&nbsp;</td>
                              <td width="1%">&nbsp;</td>
                              <td width="89%">&nbsp;</td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%"> 
                                <div align="left"></div>                              </td>
                              <td width="1%" class="command">&nbsp;</td>
                              <td width="89%" class="command">&nbsp;
                                <a id="aSearch" href="javascript:cmdSearch()"><%=strSearchComp%></a>
                                <% if(privAdd){%>
                                | <a href="javascript:cmdAdd()"><%=strAddComp%></a> 
                                <%}%>                              </td>
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
      <%@ include file = "/main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
