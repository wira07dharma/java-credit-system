<%-- 
    Document   : province
    Created on : Feb 25, 2013, 9:21:22 AM
    Author     : dw1p4
--%>

<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package master -->
<%@page import="com.dimata.aiso.entity.masterdata.region.*"%>
<%@page import="com.dimata.aiso.form.masterdata.region.*"%>


<%@include file="../../main/javainit.jsp" %>
<% //int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
   int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<!-- Jsp Block -->
<%!	
public static final String textListTitle[][] =
{
	{"Provinsi"},
	{"Province"}
};

public static final String textListHeader[][] =
{
	{"Nomor","Nama Provinsi"},
	{"Number","Province Name"}
};

public String drawList(int iCommand, FrmProvince frmObject, Province objEntity, Vector objectClass,  long provinceId, int languange, int number)
{
 	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
        ctrlist.setCellSpacing("0");
        
	ctrlist.addHeader(textListHeader[languange][0],"15%");
	ctrlist.addHeader(textListHeader[languange][1],"40%");
        ctrlist.addHeader("Action","10%");
        
	//ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);                
	ctrlist.reset();
	int index = -1;
        
        //update by Hadi tanggal 8 Maret 2013 penambahan tabel nomor
        if(iCommand == Command.FIRST){
            number = 0;
        }

	for (int i = 0; i < objectClass.size(); i++) {
            number = number + 1;
		 Province province = (Province)objectClass.get(i);
		 rowx = new Vector();
		 if(provinceId == province.getOID())
			 index = i; 

		 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){	
			rowx.add(""+number);
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmProvince.FRM_PROVINCE_NAME] +"\" value=\""+province.getProvinceName()+"\" class=\"formElemen\">");
			                                                                 
		} else{
			rowx.add(""+number);
			rowx.add(province.getProvinceName());				  
		}           
                rowx.add(String.valueOf("<center><a class=\"btn-edit btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('"+province.getOID()+"')\">Edit</a></center>"));     
		lstData.add(rowx); 
	}

	 rowx = new Vector();

	if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
			rowx.add("");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmProvince.FRM_PROVINCE_NAME] +"\" value=\""+objEntity.getProvinceName()+"\" class=\"formElemen\">");
                        rowx.add("");
	}  
	lstData.add(rowx);

	return ctrlist.draw(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidProvince = FRMQueryString.requestLong(request, "hidden_province_id");
String keyword = request.getParameter("keyword");
// variable declaration
boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
if(keyword ==null) keyword ="";
String whereClause = "" + PstProvince.fieldNames[PstProvince.FLD_PROVINCE_NAME] + " LIKE '%" + keyword + "%'";;
String orderClause = ""+PstProvince.fieldNames[PstProvince.FLD_PROVINCE_NAME];

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = textListTitle[SESS_LANGUAGE][0];
String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";

CtrlProvince ctrlProvince = new CtrlProvince(request);
iErrCode = ctrlProvince.action(iCommand, oidProvince);
FrmProvince frmProvince = ctrlProvince.getForm();
Province province = ctrlProvince.getProvince();
msgString =  ctrlProvince.getMessage();

Vector listProvince = new Vector(1,1);
    int vectSize = PstProvince.getCount(whereClause);
    if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
            start = ctrlProvince.actionList(iCommand, start, vectSize, recordToGet);
    } 

listProvince = PstProvince.list(start, recordToGet, whereClause, orderClause);
if (listProvince.size() < 1 && start > 0){
	 if (vectSize - recordToGet > recordToGet)
	 {
			start = start - recordToGet;  
	 }
	 else
	 {
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listProvince = PstProvince.list(start, recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmProvince.hidden_province_id.value="0";
	document.frmProvince.command.value="<%=Command.ADD%>";
	document.frmProvince.prev_command.value="<%=prevCommand%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdAsk(oidProvince){
	document.frmProvince.hidden_province_id.value=oidProvince;
	document.frmProvince.command.value="<%=Command.ASK%>";
	document.frmProvince.prev_command.value="<%=prevCommand%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdConfirmDelete(oidProvince){
	document.frmProvince.hidden_province_id.value=oidProvince;
	document.frmProvince.command.value="<%=Command.DELETE%>";
	document.frmProvince.prev_command.value="<%=prevCommand%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdSave(){
	document.frmProvince.command.value="<%=Command.SAVE%>";
	document.frmProvince.prev_command.value="<%=prevCommand%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdEdit(oidProvince){
	document.frmProvince.hidden_province_id.value=oidProvince;
	document.frmProvince.command.value="<%=Command.EDIT%>";
	document.frmProvince.prev_command.value="<%=prevCommand%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdCancel(oidProvince){
	document.frmProvince.hidden_province_id.value=oidProvince;
	document.frmProvince.command.value="<%=Command.EDIT%>";
	document.frmProvince.prev_command.value="<%=prevCommand%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdBack(){
	document.frmProvince.command.value="<%=Command.BACK%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdListFirst(){
	document.frmProvince.command.value="<%=Command.FIRST%>";
	document.frmProvince.prev_command.value="<%=Command.FIRST%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdListPrev(){
	document.frmProvince.command.value="<%=Command.PREV%>";
	document.frmProvince.prev_command.value="<%=Command.PREV%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdListNext(){
	document.frmProvince.command.value="<%=Command.NEXT%>";
	document.frmProvince.prev_command.value="<%=Command.NEXT%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}

function cmdListLast(){
	document.frmProvince.command.value="<%=Command.LAST%>";
	document.frmProvince.prev_command.value="<%=Command.LAST%>";
	document.frmProvince.action="province.jsp";
	document.frmProvince.submit();
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
<link rel="StyleSheet" href="../../style/font-awesome/4.6.1/css/font-awesome.css" type="text/css" >
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->Master 
            Data &gt; <%=textListTitle[SESS_LANGUAGE][0]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmProvince" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_province_id" value="<%=oidProvince%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3">&nbsp; 
                        </td>
                      </tr>
                      
                         <tr>
                      <% ///pencarian 28 februari 2012%>
                           <form name="cari" method="get" action="province.jsp">
                           <td height="7" valign="middle" colspan="2" class="listtitle">&nbsp;</td>
                           <td height="7" align="left" valign="middle" class="listtitle"> Search :
                           <input onFocus="this.select()" name="keyword"  type="text" id="keyword" size="25" maxlength="25">
                           <button type="submit" class="btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                      <% ///pencarian %>
                           </form>
                      </tr>
                      
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,frmProvince, province,listProvince,oidProvince,SESS_LANGUAGE,start)%> </td>
                      </tr>
                      <tr align="left" valign="top">
                        <td height="8" align="left" colspan="3" class="command"><% 
						  int cmd = 0;
                                                  ctrLine.setListFirstCaption("<i class=\"fa fa-angle-double-left\"></i>");
                                                  ctrLine.setListPrevCaption("<i class=\"fa fa-angle-left\"></i> ");
                                                  ctrLine.setListNextCaption("<i class=\"fa fa-angle-right\"></i> ");
                                                  ctrLine.setListLastCaption("<i class=\"fa fa-angle-double-right\"></i> ");
                                                  ctrLine.setFirstStyle("class=\"btn-primary btn-lg\"");
                                                  ctrLine.setPrevStyle("class=\"btn-primary btn-lg\"");
                                                  ctrLine.setNextStyle("class=\"btn-primary btn-lg\"");
                                                  ctrLine.setLastStyle("class=\"btn-primary btn-lg\"");
						  if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST)
						  {
								cmd =iCommand; 
						  }
						  else
						  {
							  if(iCommand == Command.NONE || prevCommand == Command.NONE)
							  {
								cmd = Command.FIRST;
							  }
							  else 
							  {
								cmd =prevCommand; 
							  }
						  } 
						  %>
                        <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> </td>
                      </tr>
                      <tr align="left" valign="top">
                        <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="8" align="left" colspan="3" class="command"> 
                          <span class="command">
                          <%
					ctrLine.setLocationImg(approot+"/images");						  
					ctrLine.initDefault();
					ctrLine.setTableWidth("80%");
					String scomDel = "javascript:cmdAsk('"+oidProvince+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidProvince+"')";
					String scancel = "javascript:cmdEdit('"+oidProvince+"')";
					ctrLine.setCommandStyle("command");
					ctrLine.setColCommStyle("command");
                                        ctrLine.setAddStyle("class=\"btn-primary btn-lg\"");
                                        ctrLine.setCancelStyle("class=\"btn-delete btn-lg\"");
                                        ctrLine.setDeleteStyle("class=\"btn-delete btn-lg\"");
                                        ctrLine.setBackStyle("class=\"btn-primary btn-lg\"");
                                        ctrLine.setSaveStyle("class=\"btn-save btn-lg\"");
                                        ctrLine.setConfirmStyle("class=\"btn-primary btn-lg\"");
					ctrLine.setAddCaption("<i class=\"fa fa-plus-circle\"></i> "+strAddMar);
					//ctrLine.setBackCaption("");
					ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> "+strCancel);														
					ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> "+strBackMar);														
					ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> "+strSaveMar);
					ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> "+strAskMar);
					ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> "+strDeleteMar);

					if (privDelete){
						ctrLine.setConfirmDelCommand(sconDelCom);
						ctrLine.setDeleteCommand(scomDel);
						ctrLine.setEditCommand(scancel);
					}else{ 
						ctrLine.setConfirmDelCaption("");
						ctrLine.setDeleteCaption("");
						ctrLine.setEditCaption("");
					}

					if(privAdd == false  && privUpdate == false){
						ctrLine.setSaveCaption("");
					}

					if (privAdd == false){
						ctrLine.setAddCaption("");
					}
					
					if(iCommand == Command.ASK)
					{
						ctrLine.setDeleteQuestion(delConfirm); 
					}					
					out.println(ctrLine.draw(iCommand, iErrCode, msgString));
					%>
					</span> </td>
                      </tr>
                      <%
					  if(privAdd && (iErrCode==ctrlProvince.RSLT_OK) && (iCommand!=Command.ADD) && (iCommand!=Command.ASK) && (iCommand!=Command.EDIT) && (frmProvince.errorSize()==0) )
					  { 
					  %>					  
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
                          <table width="20%" border="0" cellspacing="0" cellpadding="0">
                            <tr>&nbsp;<a href="javascript:cmdAdd()" class="command"><%//=strAddMar%></a></tr>
                          </table>
                        </td>
                      </tr>
					  <%					  
					  }
					  %>
                    </table>
                  </td>
                </tr>
				
				<%
				if( (iCommand ==Command.ADD) || (iCommand==Command.SAVE) && (frmProvince.errorSize()>0) || (iCommand==Command.EDIT) || (iCommand==Command.ASK) )
				{
				%>				
                <tr align="left" valign="top" > 
                  <td colspan="3" class="command">&nbsp; 
				    </td>
                </tr>
				<%
				}
				%>
              </table>
            </form>
            <%
			if(iCommand==Command.ADD || iCommand==Command.EDIT)
			{
			%>
            <script language="javascript">
				document.frmRegency.<%=FrmRegency.fieldNames[FrmRegency.FRM_REGENCY_NAME]%>.focus();
			</script>
            <%
			}
			%>
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