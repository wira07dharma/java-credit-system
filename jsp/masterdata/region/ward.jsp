<%-- 
    Document   : ward
    Created on : Feb 25, 2013, 8:42:00 AM
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
	{"Desa"},
	{"Ward"}
};

public static final String textListHeader[][] =
{
	{"Nomor","Nama Desa","Wilayah Kecamatan"},
	{"Number","Ward Name","Sub Regency Area"}
};

public String drawList(int iCommand, FrmWard frmObject, Ward objEntity, Vector objectClass,  long wardId, int languange, int number)
{
 	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
        ctrlist.setCellSpacing("0");
        
	ctrlist.addHeader(textListHeader[languange][0],"7%");
        ctrlist.addHeader(textListHeader[languange][2],"23%");
	ctrlist.addHeader(textListHeader[languange][1],"43%");
        ctrlist.addHeader("Action","10%");
	//ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);                
	ctrlist.reset();
	int index = -1;
        
         //Edit by Hadi tanggal 8 Maret 2013 penambahan field tabel Id Province
        if(iCommand == Command.FIRST){
            number = 0;
        }
        ControlCombo comboBox = new ControlCombo();
        int countSubRegency = PstSubRegency.getCount("");
        Vector listSubRegency = PstSubRegency.list(0, countSubRegency, "", PstSubRegency.fieldNames[PstSubRegency.FLD_SUBREGENCY_NAME]);
        Vector subRegencyKey = new Vector(1,1);
        Vector subRegencyValue = new Vector(1,1);
        for (int i=0; i<listSubRegency.size();i++){
            SubRegency subRegency = (SubRegency) listSubRegency.get(i);
            subRegencyKey.add(""+subRegency.getSubRegencyName());
            subRegencyValue.add(String.valueOf(subRegency.getOID()).toString());
        }

	for (int i = 0; i < objectClass.size(); i++) {
            number = number + 1;
		 Ward ward = (Ward)objectClass.get(i);
		 rowx = new Vector();
		 if(wardId == ward.getOID())
			 index = i; 

		 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
                        rowx.add(""+number);
			rowx.add(""+comboBox.draw(FrmWard.fieldNames[FrmWard.FRM_WARD_SUBREGENCY_ID] ,"formElemen", "select...", ""+ward.getIdSubRegency(), subRegencyValue, subRegencyKey));
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmWard.FRM_WARD_NAME] +"\" value=\""+ward.getWardName()+"\" class=\"formElemen\">");
			                                                                 
		} else{
			rowx.add(""+number);
                        SubRegency subRegency = new SubRegency();
                        if(ward.getIdSubRegency()!=0){
                            subRegency = PstSubRegency.fetch(ward.getIdSubRegency());
                        }
                        rowx.add(subRegency.getSubRegencyName ());	
			rowx.add(ward.getWardName());					  
		}       
                rowx.add(String.valueOf("<center><a class=\"btn-edit btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('"+ward.getOID()+"')\">Edit</a></center>"));                                                                                                                                   
		lstData.add(rowx); 
		
	}

	 rowx = new Vector();

	if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
                        rowx.add("");
			rowx.add(""+textListHeader[languange][2]+" "+comboBox.draw(FrmWard.fieldNames[FrmWard.FRM_WARD_SUBREGENCY_ID] ,"formElemen", "select...", ""+objEntity.getIdSubRegency(), subRegencyValue, subRegencyKey));
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmWard.FRM_WARD_NAME] +"\" value=\""+objEntity.getWardName()+"\" class=\"formElemen\">");
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
long oidWard = FRMQueryString.requestLong(request, "hidden_ward_id");
String keyword = request.getParameter("keyword");
// variable declaration
boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
if(keyword ==null) keyword ="";
String whereClause = "" + PstWard.fieldNames[PstWard.FLD_WARD_NAME] + " LIKE '%" + keyword + "%'";;
String orderClause = ""+PstWard.fieldNames[PstWard.FLD_WARD_NAME];

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

CtrlWard ctrlWard = new CtrlWard(request);
iErrCode = ctrlWard.action(iCommand, oidWard);
FrmWard frmWard = ctrlWard.getForm();
Ward ward = ctrlWard.getWard();
msgString =  ctrlWard.getMessage();

Vector listWard = new Vector(1,1);
    int vectSize = PstWard.getCount(whereClause);
    if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
            start = ctrlWard.actionList(iCommand, start, vectSize, recordToGet);
    } 

listWard = PstWard.list(start, recordToGet, whereClause, orderClause);
if (listWard.size() < 1 && start > 0){
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
	 listWard = PstWard.list(start, recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmWard.hidden_ward_id.value="0";
	document.frmWard.command.value="<%=Command.ADD%>";
	document.frmWard.prev_command.value="<%=prevCommand%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdAsk(oidWard){
	document.frmWard.hidden_ward_id.value=oidWard;
	document.frmWard.command.value="<%=Command.ASK%>";
	document.frmWard.prev_command.value="<%=prevCommand%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdConfirmDelete(oidWard){
	document.frmWard.hidden_ward_id.value=oidWard;
	document.frmWard.command.value="<%=Command.DELETE%>";
	document.frmWard.prev_command.value="<%=prevCommand%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdSave(){
	document.frmWard.command.value="<%=Command.SAVE%>";
	document.frmWard.prev_command.value="<%=prevCommand%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdEdit(oidWard){
	document.frmWard.hidden_ward_id.value=oidWard;
	document.frmWard.command.value="<%=Command.EDIT%>";
	document.frmWard.prev_command.value="<%=prevCommand%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdCancel(oidWard){
	document.frmWard.hidden_ward_id.value=oidWard;
	document.frmWard.command.value="<%=Command.EDIT%>";
	document.frmWard.prev_command.value="<%=prevCommand%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdBack(){
	document.frmWard.command.value="<%=Command.BACK%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdListFirst(){
	document.frmWard.command.value="<%=Command.FIRST%>";
	document.frmWard.prev_command.value="<%=Command.FIRST%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdListPrev(){
	document.frmWard.command.value="<%=Command.PREV%>";
	document.frmWard.prev_command.value="<%=Command.PREV%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdListNext(){
	document.frmWard.command.value="<%=Command.NEXT%>";
	document.frmWard.prev_command.value="<%=Command.NEXT%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
}

function cmdListLast(){
	document.frmWard.command.value="<%=Command.LAST%>";
	document.frmWard.prev_command.value="<%=Command.LAST%>";
	document.frmWard.action="ward.jsp";
	document.frmWard.submit();
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
            <form name="frmWard" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_ward_id" value="<%=oidWard%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3">
                            &nbsp; 
                        </td>
                      </tr>
                      <tr>
                           <form name="cari" method="get" action="ward.jsp">
                           <td height="7" valign="middle" colspan="2" class="listtitle">&nbsp;</td>
                           <td height="7" align="left" valign="middle" class="listtitle">Search :
                           <input onFocus="this.select()" name="keyword"  type="text" id="keyword" size="25" maxlength="25">
                           <button type="submit" class="btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                           </form>
                      </tr>
                      
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,frmWard, ward,listWard,oidWard,SESS_LANGUAGE,start)%> </td>
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
					String scomDel = "javascript:cmdAsk('"+oidWard+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidWard+"')";
					String scancel = "javascript:cmdEdit('"+oidWard+"')";
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
					  if(privAdd && (iErrCode==ctrlWard.RSLT_OK) && (iCommand!=Command.ADD) && (iCommand!=Command.ASK) && (iCommand!=Command.EDIT) && (frmWard.errorSize()==0) )
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
				if( (iCommand ==Command.ADD) || (iCommand==Command.SAVE) && (frmWard.errorSize()>0) || (iCommand==Command.EDIT) || (iCommand==Command.ASK) )
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