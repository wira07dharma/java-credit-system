

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
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.aiso.entity.masterdata.*"%>
<%@page import="com.dimata.aiso.form.masterdata.*"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.FrmTypeTabungan"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.CtrlTypeTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstTypeTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.TypeTabungan"%>
<%@page import="java.util.Vector"%>


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
public static final String textListHeader[][] =
{
	{"Nomor","Tipe Tabungan"},
	{"Number","TypeTabungan"}
};

public static final String textListTitle[][] =
{
	{"Tipe Tabungan"},
	{"TypeTabungan"}
};

public String drawList(int iCommand, FrmTypeTabungan frmObject, TypeTabungan objEntity, Vector objectClass,  long typeTabunganId, int languange, int start)
{
 	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("80%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
        
	ctrlist.addHeader(textListHeader[languange][0],"5%");
        ctrlist.addHeader(textListHeader[languange][1],"30%");
        ctrlist.addHeader("Action","30%");

	//ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);                
	ctrlist.reset();
	int index = -1;
        int number = start;

	for (int i = 0; i < objectClass.size(); i++) {
            number = number + 1;
		 TypeTabungan typeTabungan = (TypeTabungan)objectClass.get(i);
		 rowx = new Vector();
		 if(typeTabunganId == typeTabungan.getOID())
			 index = i; 

		 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
			rowx.add(""+number);
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmTypeTabungan.FRM_FIELD_TIPE_TABUNGAN] +"\" value=\""+typeTabungan.getTypeTabungan()+"\" class=\"formElemen\">");
			                                                                 
		}  else{
			rowx.add(""+number);
                        rowx.add(String.valueOf(typeTabungan.getTypeTabungan()));
								  
		} 

                rowx.add(String.valueOf("<center><a class=\"btn-edit btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('"+typeTabungan.getOID()+"')\">Edit</a></center>"));                                                                   	                                                                      
		lstData.add(rowx); 
		
	}

	 rowx = new Vector();

	if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
            rowx.add(""); 
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmTypeTabungan.FRM_FIELD_TIPE_TABUNGAN] +"\" value=\""+objEntity.getTypeTabungan()+"\" class=\"formElemen\">");
	 rowx.add("-");
        }  
	lstData.add(rowx);

	return ctrlist.draw(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidTypeTabungan = FRMQueryString.requestLong(request, "hidden_typeTabungan_id");
String keyword = request.getParameter("keyword");
// variable declaration
boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
if(keyword ==null) keyword ="";
String whereClause = "" + PstTypeTabungan.fieldNames[PstTypeTabungan.FLD_TIPE_TABUNGAN] + " LIKE '%" + keyword + "%'";;
String orderClause = ""+PstTypeTabungan.fieldNames[PstTypeTabungan.FLD_TIPE_TABUNGAN];

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

CtrlTypeTabungan ctrlTypeTabungan = new CtrlTypeTabungan(request);
iErrCode = ctrlTypeTabungan.action(iCommand, oidTypeTabungan);
FrmTypeTabungan frmTypeTabungan = ctrlTypeTabungan.getForm();
TypeTabungan typeTabungan = ctrlTypeTabungan.getTypeTabungan();
msgString =  ctrlTypeTabungan.getMessage();

Vector listTypeTabungan = new Vector(1,1);
    int vectSize = PstTypeTabungan.getCount(whereClause);
    if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
            start = ctrlTypeTabungan.actionList(iCommand, start, vectSize, recordToGet);
    } 

listTypeTabungan = PstTypeTabungan.list(start, recordToGet, whereClause, orderClause);
if (listTypeTabungan.size() < 1 && start > 0){
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
	 listTypeTabungan = PstTypeTabungan.list(start, recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmTypeTabungan.hidden_typeTabungan_id.value="0";
	document.frmTypeTabungan.command.value="<%=Command.ADD%>";
	document.frmTypeTabungan.prev_command.value="<%=prevCommand%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdAsk(oidTypeTabungan){
	document.frmTypeTabungan.hidden_typeTabungan_id.value=oidTypeTabungan;
	document.frmTypeTabungan.command.value="<%=Command.ASK%>";
	document.frmTypeTabungan.prev_command.value="<%=prevCommand%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdConfirmDelete(oidTypeTabungan){
	document.frmTypeTabungan.hidden_typeTabungan_id.value=oidTypeTabungan;
	document.frmTypeTabungan.command.value="<%=Command.DELETE%>";
	document.frmTypeTabungan.prev_command.value="<%=prevCommand%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdSave(){
	document.frmTypeTabungan.command.value="<%=Command.SAVE%>";
	document.frmTypeTabungan.prev_command.value="<%=prevCommand%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdEdit(oidTypeTabungan){
	document.frmTypeTabungan.hidden_typeTabungan_id.value=oidTypeTabungan;
	document.frmTypeTabungan.command.value="<%=Command.EDIT%>";
	document.frmTypeTabungan.prev_command.value="<%=prevCommand%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdCancel(oidTypeTabungan){
	document.frmTypeTabungan.hidden_typeTabungan_id.value=oidTypeTabungan;
	document.frmTypeTabungan.command.value="<%=Command.EDIT%>";
	document.frmTypeTabungan.prev_command.value="<%=prevCommand%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdBack(){
	document.frmTypeTabungan.command.value="<%=Command.BACK%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdListFirst(){
	document.frmTypeTabungan.command.value="<%=Command.FIRST%>";
	document.frmTypeTabungan.prev_command.value="<%=Command.FIRST%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdListPrev(){
	document.frmTypeTabungan.command.value="<%=Command.PREV%>";
	document.frmTypeTabungan.prev_command.value="<%=Command.PREV%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdListNext(){
	document.frmTypeTabungan.command.value="<%=Command.NEXT%>";
	document.frmTypeTabungan.prev_command.value="<%=Command.NEXT%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
}

function cmdListLast(){
	document.frmTypeTabungan.command.value="<%=Command.LAST%>";
	document.frmTypeTabungan.prev_command.value="<%=Command.LAST%>";
	document.frmTypeTabungan.action="type_tabungan.jsp";
	document.frmTypeTabungan.submit();
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
            <form name="frmTypeTabungan" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_typeTabungan_id" value="<%=oidTypeTabungan%>">
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
                           <button type="submit" class="btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                      <% ///pencarian %>
                           </form>
                      </tr>
                      
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,frmTypeTabungan, typeTabungan,listTypeTabungan,oidTypeTabungan,SESS_LANGUAGE,start)%> </td>
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
					String scomDel = "javascript:cmdAsk('"+oidTypeTabungan+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidTypeTabungan+"')";
					String scancel = "javascript:cmdEdit('"+oidTypeTabungan+"')";
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
					  if(privAdd && (iErrCode==ctrlTypeTabungan.RSLT_OK) && (iCommand!=Command.ADD) && (iCommand!=Command.ASK) && (iCommand!=Command.EDIT) && (frmTypeTabungan.errorSize()==0) )
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
				if( (iCommand ==Command.ADD) || (iCommand==Command.SAVE) && (frmTypeTabungan.errorSize()>0) || (iCommand==Command.EDIT) || (iCommand==Command.ASK) )
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
				document.frmTypeTabungan.<%=FrmTypeTabungan.fieldNames[FrmTypeTabungan.FRM_FIELD_TIPE_TABUNGAN]%>.focus();
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

