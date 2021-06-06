

<% 
/* 
 * Page Name  		:  MasterTabungan.jsp
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
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*"%>


<%@include file="../../main/javainit.jsp" %>
<% //int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
   int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privBack=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_BACK));
%>
<tr>
    
</tr>
<!-- Jsp Block -->
                                            
                                            
<%!	
public static final String textListTitle[][] =
{
	{"Nama Tabungan"},
	{"Name Of Saving"}
};

public static final String textListHeader[][] =
{
	{"Nomor","Nama Tabungan"},
	{"Nomor","Name Of Saving"}
};

public String drawList(int iCommand, FrmMasterTabungan frmObject, MasterTabungan objEntity, Vector objectClass,  long masterTabunganId, int languange, int start)
{
 	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("60%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
        
        ctrlist.addHeader(textListHeader[languange][0],"1%"); 
	ctrlist.addHeader(textListHeader[languange][1],"20%");
	ctrlist.addHeader("Action","20%");

        
	//ctrlist.setLinkRow(0);
	//ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);                
	ctrlist.reset();
	int index = -1;
        int indexNumber = start;

	for (int i = 0; i < objectClass.size(); i++) {
                 indexNumber = indexNumber + 1 ;
		 MasterTabungan masterTabungan = (MasterTabungan)objectClass.get(i);
		 rowx = new Vector();
		 if(masterTabunganId == masterTabungan.getOID())
			 index = i; 

		 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
			rowx.add("<center><input type=\"hidden\" name\""+frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_ID_TABUNGAN]+"\" value=\""+masterTabungan.getOID()+"\" class=\"formElemen\">"+indexNumber+"</center>");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_NAMA_TABUNGAN] +"\" value=\""+masterTabungan.getSavingName()+"\" class=\"formElemen\">");
			                                                         
		} else {
                        rowx.add(""+indexNumber);
			rowx.add(String.valueOf(masterTabungan.getSavingName()));
                        
		}    
                rowx.add(String.valueOf("<center><a class=\"btn-edit btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('"+masterTabungan.getOID()+"')\">Edit</a></center>"));                                                                   
		                                                                           
		lstData.add(rowx); 
		
	}

	 rowx = new Vector();

	if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
                        rowx.add("<center><input type=\"hidden\" name=\""+frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_ID_TABUNGAN]+ "\" value=\""+objEntity.getOID()+"\" class=\"formElemen\">"+indexNumber+"</center>");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmMasterTabungan.FRM_FIELD_NAMA_TABUNGAN] +"\" value=\""+objEntity.getSavingName()+"\" class=\"formElemen\">");
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
long oidMasterTabungan = FRMQueryString.requestLong(request, "FRM_FIELD_ID_TABUNGAN");
String keyword = request.getParameter("keyword");
// variable declaration
boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
if(keyword ==null) keyword ="";
String whereClause = ""  + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN] + " LIKE '%" + keyword + "%'";;
String orderClause = ""+PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN];


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


CtrlMasterTabungan ctrlMasterTabungan = new CtrlMasterTabungan(request);
iErrCode = ctrlMasterTabungan.action(iCommand, oidMasterTabungan);
FrmMasterTabungan frmMasterTabungan = ctrlMasterTabungan.getForm();
long masterTabunganOID = FRMQueryString.requestLong(request,"masterTabungan_oid"); 
MasterTabungan masterTabungan = ctrlMasterTabungan.getMasterTabungan();
msgString =  ctrlMasterTabungan.getMessage();

Vector listMasterTabungan = new Vector(1,1);
    int vectSize = PstMasterTabungan.getCount(whereClause);
    if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
            start = ctrlMasterTabungan.actionList(iCommand, start, vectSize, recordToGet);
    } 

listMasterTabungan = PstMasterTabungan.list(start, recordToGet, whereClause, orderClause);
if (listMasterTabungan.size() < 1 && start > 0){
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
	 listMasterTabungan = PstMasterTabungan.list(start, recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmMasterTabungan.<%=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]%>.value="0";
	document.frmMasterTabungan.command.value="<%=Command.ADD%>";
	document.frmMasterTabungan.prev_command.value="<%=prevCommand%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdAsk(oidMasterTabungan){
	document.frmMasterTabungan.<%=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]%>.value=oidMasterTabungan;
	document.frmMasterTabungan.command.value="<%=Command.ASK%>";
	document.frmMasterTabungan.prev_command.value="<%=prevCommand%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdConfirmDelete(oidMasterTabungan){
	document.frmMasterTabungan.<%=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]%>.value=oidMasterTabungan;
	document.frmMasterTabungan.command.value="<%=Command.DELETE%>";
	document.frmMasterTabungan.prev_command.value="<%=prevCommand%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdSave(){
	document.frmMasterTabungan.command.value="<%=Command.SAVE%>";
	document.frmMasterTabungan.prev_command.value="<%=prevCommand%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdEdit(oidMasterTabungan){
	document.frmMasterTabungan.<%=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]%>.value=oidMasterTabungan;
	document.frmMasterTabungan.command.value="<%=Command.EDIT%>";
	document.frmMasterTabungan.prev_command.value="<%=prevCommand%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdCancel(oidMasterTabungan){
	document.frmMasterTabungan.<%=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]%>.value=oidMasterTabungan;
	document.frmMasterTabungan.command.value="<%=Command.EDIT%>";
	document.frmMasterTabungan.prev_command.value="<%=prevCommand%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdBack(){
	document.frmMasterTabungan.command.value="<%=Command.BACK%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdEditJenis(oidMasterTabungan){
	document.frmMasterTabungan.<%=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]%>.value=oidMasterTabungan;
	document.frmMasterTabungan.command.value="<%=Command.ADD%>";
	document.frmMasterTabungan.prev_command.value="<%=prevCommand%>";
	document.frmMasterTabungan.action="jenistabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdListFirst(){
	document.frmMasterTabungan.command.value="<%=Command.FIRST%>";
	document.frmMasterTabungan.prev_command.value="<%=Command.FIRST%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdListPrev(){
	document.frmMasterTabungan.command.value="<%=Command.PREV%>";
	document.frmMasterTabungan.prev_command.value="<%=Command.PREV%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdListNext(){
	document.frmMasterTabungan.command.value="<%=Command.NEXT%>";
	document.frmMasterTabungan.prev_command.value="<%=Command.NEXT%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
}

function cmdListLast(){
	document.frmMasterTabungan.command.value="<%=Command.LAST%>";
	document.frmMasterTabungan.prev_command.value="<%=Command.LAST%>";
	document.frmMasterTabungan.action="mastertabungan.jsp";
	document.frmMasterTabungan.submit();
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
            <form name="frmMasterTabungan" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="<%=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]%>" value="<%=oidMasterTabungan%>">
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
                           <form name="cari" method="get" action="mastertabungan.jsp">
                           <td height="7" valign="middle" colspan="2" class="listtitle">&nbsp;</td>
                           <td height="7" align="left" valign="middle" class="listtitle">
                           <input onFocus="this.select()" name="keyword"  type="text" id="keyword" size="25" maxlength="25">
                           
                            <button type="submit" class="btn-primary btn-sm"><i class="fa fa-search"></i> Cari</button>
                      <% ///pencarian %>
                           </form>
                      </tr>
                      
                      
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,frmMasterTabungan, masterTabungan,listMasterTabungan,oidMasterTabungan,SESS_LANGUAGE, start)%> </td>
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
					String scomDel = "javascript:cmdAsk('"+oidMasterTabungan+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidMasterTabungan+"')";
					String scancel = "javascript:cmdEdit('"+oidMasterTabungan+"')";
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
					  if(privAdd && (iErrCode==ctrlMasterTabungan.RSLT_OK) && (iCommand!=Command.ADD) && (iCommand!=Command.ASK) && (iCommand!=Command.EDIT) && (iCommand!=Command.BACK)  && (frmMasterTabungan.errorSize()==0) )
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
                                        
                      <%if(oidMasterTabungan != 0){%>

                       <tr> 

                            <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>

                            <td height="22" valign="middle" colspan="3" width="951"> 

                            <a href="javascript:cmdEditJenis('<%=oidMasterTabungan%>')" class="btn-save btn-lg"> 

                             Edit Jenis Tabungan</a></td>
                                                        

                            </tr>

                            <%}%>
                      
                            
                    </table>
                            
                  </td>
                  
                </tr>
				
				<%
				if( (iCommand ==Command.ADD) || (iCommand==Command.SAVE) && (frmMasterTabungan.errorSize()>0) || (iCommand==Command.EDIT) || (iCommand==Command.ASK) )
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
				document.frmMasterTabungan.<%=FrmMasterTabungan.fieldNames[FrmMasterTabungan.FRM_FIELD_NAMA_TABUNGAN]%>.focus();
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

