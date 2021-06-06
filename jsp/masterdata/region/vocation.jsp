<% 
/* 
 * Page Name  		:  Vocation.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		:  [dede] 
 * @version  		:  [version] 
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
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package master -->
<%@page import="com.dimata.aiso.entity.masterdata.*"%>
<%@page import="com.dimata.aiso.form.masterdata.*"%>


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
	{"Pekerjaan Anggota"},
	{"Vocation Club"}
};

public static final String textListHeader[][] =
{
	{"Nama Pekerjaan","Keterangan"},
	{"Vocation Name","Description"}
};

public String drawList(int iCommand, FrmVocation frmObject, Vocation objEntity, Vector objectClass,  long vocationId, int languange)
{
 	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("80%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
        
	ctrlist.addHeader(textListHeader[languange][0],"30%");
	ctrlist.addHeader(textListHeader[languange][1],"40%");

	//ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);                
	ctrlist.reset();
	int index = -1;

	for (int i = 0; i < objectClass.size(); i++) {
		 Vocation vocation = (Vocation)objectClass.get(i);
		 rowx = new Vector();
		 if(vocationId == vocation.getOID())
			 index = i; 

		 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
				
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmVocation.FRM_FIELD_VOCATION_NAME] +"\" value=\""+vocation.getVocationName()+"\" class=\"formElemen\">");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmVocation.FRM_FIELD_DESC_VOCATION] +"\" value=\""+vocation.getDescription()+"\" class=\"formElemen\">");
			                                                                 
		} 
                        else{
			rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(vocation.getOID())+"')\">"+vocation.getVocationName()+"</a>");
			rowx.add(vocation.getDescription());
							
							
							  
		}                                                       
		lstData.add(rowx); 
		
	}

	 rowx = new Vector();

	if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmVocation.FRM_FIELD_VOCATION_NAME] +"\" value=\""+objEntity.getVocationName()+"\" class=\"formElemen\">");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmVocation.FRM_FIELD_DESC_VOCATION] +"\" value=\""+objEntity.getDescription()+"\" class=\"formElemen\">");
	}  
	lstData.add(rowx);

	return ctrlist.draw(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidVocation = FRMQueryString.requestLong(request, "hidden_vocation_id");
String keyword = request.getParameter("keyword");
// variable declaration
boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
if(keyword ==null) keyword ="";
String whereClause = "" + PstVocation.fieldNames[PstVocation.FLD_VOCATION_NAME] + " LIKE '%" + keyword + "%'";;
String orderClause = ""+PstVocation.fieldNames[PstVocation.FLD_VOCATION_NAME];

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

CtrlVocation ctrlVocation = new CtrlVocation(request);
iErrCode = ctrlVocation.action(iCommand, oidVocation);
FrmVocation frmVocation = ctrlVocation.getForm();
Vocation vocation = ctrlVocation.getvocation();
msgString =  ctrlVocation.getMessage();

Vector listVocation = new Vector(1,1);
    int vectSize = PstVocation.getCount(whereClause);
    if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
            start = ctrlVocation.actionList(iCommand, start, vectSize, recordToGet);
    } 

listVocation = PstVocation.list(start, recordToGet, whereClause, orderClause);
if (listVocation.size() < 1 && start > 0){
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
	 listVocation = PstVocation.list(start, recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmVocation.hidden_vocation_id.value="0";
	document.frmVocation.command.value="<%=Command.ADD%>";
	document.frmVocation.prev_command.value="<%=prevCommand%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdAsk(oidVocation){
	document.frmVocation.hidden_vocation_id.value=oidVocation;
	document.frmVocation.command.value="<%=Command.ASK%>";
	document.frmVocation.prev_command.value="<%=prevCommand%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdConfirmDelete(oidVocation){
	document.frmVocation.hidden_vocation_id.value=oidVocation;
	document.frmVocation.command.value="<%=Command.DELETE%>";
	document.frmVocation.prev_command.value="<%=prevCommand%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdSave(){
	document.frmVocation.command.value="<%=Command.SAVE%>";
	document.frmVocation.prev_command.value="<%=prevCommand%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdEdit(oidVocation){
	document.frmVocation.hidden_vocation_id.value=oidVocation;
	document.frmVocation.command.value="<%=Command.EDIT%>";
	document.frmVocation.prev_command.value="<%=prevCommand%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdCancel(oidVocation){
	document.frmVocation.hidden_vocation_id.value=oidVocation;
	document.frmVocation.command.value="<%=Command.EDIT%>";
	document.frmVocation.prev_command.value="<%=prevCommand%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdBack(){
	document.frmVocation.command.value="<%=Command.BACK%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdListFirst(){
	document.frmVocation.command.value="<%=Command.FIRST%>";
	document.frmVocation.prev_command.value="<%=Command.FIRST%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdListPrev(){
	document.frmVocation.command.value="<%=Command.PREV%>";
	document.frmVocation.prev_command.value="<%=Command.PREV%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdListNext(){
	document.frmVocation.command.value="<%=Command.NEXT%>";
	document.frmVocation.prev_command.value="<%=Command.NEXT%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}

function cmdListLast(){
	document.frmVocation.command.value="<%=Command.LAST%>";
	document.frmVocation.prev_command.value="<%=Command.LAST%>";
	document.frmVocation.action="vocation.jsp";
	document.frmVocation.submit();
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->Master 
            Data &gt; <%=textListTitle[SESS_LANGUAGE][0]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmVocation" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_vocation_id" value="<%=oidVocation%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3">&nbsp; 
                        </td>
                      </tr>
                      
                         <tr>
                      <% ///pencarian 28 februari 2012%>
                           <form name="cari" method="get" action="city.jsp">
                           <td height="7" valign="middle" colspan="2" class="listtitle">&nbsp;</td>
                           <td height="7" align="left" valign="middle" class="listtitle">
                           <input onFocus="this.select()" name="keyword"  type="text" id="keyword" size="25" maxlength="25">
                           <input type="submit" value="cari" bgcolor="#00000"></td>
                      <% ///pencarian %>
                           </form>
                      </tr>
                      
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,frmVocation, vocation,listVocation,oidVocation,SESS_LANGUAGE)%> </td>
                      </tr>
                      <tr align="left" valign="top">
                        <td height="8" align="left" colspan="3" class="command"><% 
						  int cmd = 0;
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
					String scomDel = "javascript:cmdAsk('"+oidVocation+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidVocation+"')";
					String scancel = "javascript:cmdEdit('"+oidVocation+"')";
					ctrLine.setCommandStyle("command");
					ctrLine.setColCommStyle("command");
					ctrLine.setAddCaption(strAddMar);
					//ctrLine.setBackCaption("");
					ctrLine.setCancelCaption(strCancel);														
					ctrLine.setBackCaption("");														
					ctrLine.setSaveCaption(strSaveMar);
					ctrLine.setDeleteCaption(strAskMar);
					ctrLine.setConfirmDelCaption(strDeleteMar);

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
					  if(privAdd && (iErrCode==ctrlVocation.RSLT_OK) && (iCommand!=Command.ADD) && (iCommand!=Command.ASK) && (iCommand!=Command.EDIT) && (frmVocation.errorSize()==0) )
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
				if( (iCommand ==Command.ADD) || (iCommand==Command.SAVE) && (frmVocation.errorSize()>0) || (iCommand==Command.EDIT) || (iCommand==Command.ASK) )
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
				document.frmVocation.<%=FrmVocation.fieldNames[FrmVocation.FRM_FIELD_VOCATION_NAME]%>.focus();
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

