 

<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package wihita -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package common -->
<%@ page import = "com.dimata.aiso.entity.search.SrcCompany" %>
<%@ page import = "com.dimata.aiso.form.search.FrmSrcCompany" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.Company" %>
<%@ page import = "com.dimata.aiso.session.masterdata.SessCompany" %>

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
	{"Kode","Nama","Alamat","Kota","Propinsi","Negara","Urutkan Berdasar"},	
	{"Code","Name","Address","Town","Province","Country","Sort By"}
};

public static final String masterTitle[] = {
	"Pencarian Perusahaan","Company Inquiries"	
};

public static final String compTitle[] = {
	"Perusahaan","Company"
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
SrcCompany srcCompany = new SrcCompany();
FrmSrcCompany frmSrcCompany = new FrmSrcCompany();

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = compTitle[SESS_LANGUAGE];
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSearchComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);

if(iCommand==Command.BACK){
	frmSrcCompany = new FrmSrcCompany(request, srcCompany);
	try{
		srcCompany = (SrcCompany)session.getValue(SessCompany.SESS_COMPANY);
		if(srcCompany == null) {
			srcCompany = new SrcCompany();
		}
	}catch(Exception e){
		srcCompany = new SrcCompany();
	}
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
		document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.command.value="<%=Command.ADD%>";
		document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.action="company_edit.jsp";
		document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.submit(); 
}

function cmdSearch(){
		document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.command.value="<%=Command.LIST%>";
		document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.action="company_list.jsp";
		document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.submit();
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
            <b><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font></b><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>" method="post" action="">
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
                                <input type="text" name="<%=frmSrcCompany.fieldNames[frmSrcCompany.FRM_FIELD_CODE] %>"  value="<%=srcCompany.getCode()%>" onKeyDown="javascript:fnTrapKD()" size="20">                              </td> 
                            </tr>
                            <script language="javascript">
								document.frm_contactlist.<%=frmSrcCompany.fieldNames[frmSrcCompany.FRM_FIELD_CODE]%>.focus();
							</script>
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcCompany.fieldNames[frmSrcCompany.FRM_FIELD_NAME] %>"  value="<%=srcCompany.getName()%>" size="40" onKeyDown="javascript:fnTrapKD()">                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp;
                              <input type="text" name="<%=frmSrcCompany.fieldNames[frmSrcCompany.FRM_FIELD_ADDRESS] %>"  value="<%=srcCompany.getAddress()%>" size="60" onKeyDown="javascript:fnTrapKD()"></td>
                            </tr>
							<!-- start update -->
							<tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp;
                              <input type="text" name="<%=frmSrcCompany.fieldNames[frmSrcCompany.FRM_FIELD_CITY] %>"  value="<%=srcCompany.getTown()%>" size="40" onKeyDown="javascript:fnTrapKD()"></td>
                            </tr>
							<tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcCompany.fieldNames[frmSrcCompany.FRM_FIELD_PROVINCE]%>"  value="<%=srcCompany.getProvince()%>" size="40" onKeyDown="javascript:fnTrapKD()">                              </td>
                            </tr>
							<tr align="left" valign="top"> 
                              <td width="10%" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <input type="text" name="<%=frmSrcCompany.fieldNames[frmSrcCompany.FRM_FIELD_COUNTRY] %>"  value="<%=srcCompany.getCountry()%>" size="40" onKeyDown="javascript:fnTrapKD()">                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td width="10%" height="21" nowrap> 
                                <div align="left"><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></div>                              </td>
                              <td width="1%">:</td>
                              <td width="89%">&nbsp; 
                                <%= ControlCombo.draw(frmSrcCompany.fieldNames[frmSrcCompany.FRM_FIELD_ORDER],"formElemen",null, ""+srcCompany.getOrderBy(), frmSrcCompany.getOrderValue(), frmSrcCompany.getOrderKey(SESS_LANGUAGE), " onkeydown=\"javascript:fnTrapKD()\"") %> </td>
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
