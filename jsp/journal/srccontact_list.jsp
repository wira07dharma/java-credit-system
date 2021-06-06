 
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
<% int  appObjCode = 1; //AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
%>

<!-- Jsp Block -->
<%!
public static String strTitle[][] = {
	{"Kelompok Kontak","Kode","Nama","Alamat","Urutkan Berdasar"},	
	{"Contact Class","Code","Name","Address","Sort By"}
};

public static final String masterTitle[] = {
	"Kontak","Contact"	
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
int type = FRMQueryString.requestInt(request,"contact_class");
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
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
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
            <%=masterTitle[SESS_LANGUAGE]%> &gt; <%=currPageTitle%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frm_contactlist" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="contact_class" value="<%=type%>">
			  <%try{%>
              <table border="0" width="100%">
                <tr> 
                  <td height="8">&nbsp; 
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
							  /*
								public static final int CONTACT_TYPE_TRAVEL_AGENT       = 0;
								public static final int CONTACT_TYPE_SUPPLIER           = 1;
								public static final int CONTACT_TYPE_GUIDE              = 2;
								public static final int CONTACT_TYPE_COMPANY            = 3;
								public static final int CONTACT_TYPE_EMPLOYEE	    	= 4;        
								public static final int FLD_CLASS_SHIPPER               = 5;
								public static final int FLD_CLASS_CLIENT                = 6;
								public static final int CONTACT_TYPE_MEMBER             = 7;    
								public static final int FLD_CLASS_VENDOR                = 8;
								public static final int FLD_CLASS_OTHERS                = 9;    
							  */	
							  
							  String whClause = PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] +
							  					//" = " + PstContactClass.CONTACT_TYPE_TRAVEL_AGENT + 
												//" OR " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + 
							  					" = " + PstContactClass.CONTACT_TYPE_SUPPLIER + 												
												//" OR " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + 
							  					//" = " + PstContactClass.CONTACT_TYPE_GUIDE + 												
												//" OR " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + 
							  					//" = " + PstContactClass.CONTACT_TYPE_COMPANY + 												
												//" OR " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + 
							  					//" = " + PstContactClass.CONTACT_TYPE_EMPLOYEE + 																								
												//" OR " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + 
							  					//" = " + PstContactClass.FLD_CLASS_SHIPPER + 												
												" OR " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] +
							  					" = " + PstContactClass.FLD_CLASS_CLIENT +
												" OR " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + 
							  					" = " + PstContactClass.CONTACT_TYPE_MEMBER + 												
												//" OR " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + 
							  					//" = " + PstContactClass.FLD_CLASS_VENDOR + 												
												" OR " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + 
							  					" = " + PstContactClass.FLD_CLASS_OTHERS; 												
							  Vector vectClass = PstContactClass.list(0,0,whClause,"");						  
							  for(int i=0; i<vectClass.size(); i++)
							  {
							  	ContactClass cntClass = (ContactClass)vectClass.get(i);
								long idxContactClass = cntClass.getOID();							
								String strContactClass = cntClass.getClassName();							  							  
							  %>
							  &nbsp;<input type="checkbox" class="formElemen" name="<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_TYPE]%>" value="<%=(idxContactClass)%>" <%if(getTruedFalse(srcContactList.getType(),idxContactClass)){%>checked<%}%>>
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
                              <td width="89%" class="command">&nbsp;&nbsp;<a id="aSearch" href="javascript:cmdSearch()"><%=strSearchComp%></a> 
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
