
<% 
/* 
 * Page Name  		:  jenistabungan.jsp
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
%>
<tr>
    
</tr>
<!-- Jsp Block -->
                                            
                                            
<%!	
public static final String textListTitle[][] =
{
	{"Jenis Tabungan"},
	{"Type Of Savings"}
};

public static final String textListHeader[][] =
{
	{"Nomor","Jenis Tabungan"},
	{"Nomor","Type Of Savings"}
};

public String drawList(int iCommand, FrmJenisTabungan frmObject, JenisTabungan objEntity, Vector objectClass,  long jenisTabunganId, int languange, int start) 
{
 	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("80%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
        
        ctrlist.addHeader(textListHeader[languange][0],"7%");
	ctrlist.addHeader(textListHeader[languange][1],"30%");

        
	//ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);                
	ctrlist.reset();
	int index = -1;
        int indexNumber = start; 

	for (int i = 0; i < objectClass.size(); i++) {
                 indexNumber = indexNumber + 1 ;
		 JenisTabungan jenisTabungan = (JenisTabungan)objectClass.get(i);
		 rowx = new Vector();
		 if(jenisTabunganId == jenisTabungan.getOID())
			 index = i; 

		 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
			
                        rowx.add("<center><input type=\"hidden\" name=\""+frmObject.fieldNames[FrmJenisTabungan.FRM_FIELD_JENIS_TABUNGAN_ID] +"\" value=\""+jenisTabungan.getOID()+"\" class=\"formElemen\">"+indexNumber+"</center>");    
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmJenisTabungan.FRM_FIELD_NAMA_JENIS_TABUNGAN] +"\" value=\""+jenisTabungan.getNamaJenisTbgn()+"\" class=\"formElemen\">");
			//rowx.add("<input type=\"hidden\" name=\""+frmObject.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN] +"\" value=\""+jenisTabungan.getId_tabungan()+"\" class=\"formElemen\">");                                                                 
		} 
                        else{
                        rowx.add("<center><a href=\"javascript:cmdEdit('"+String.valueOf(jenisTabungan.getOID())+"')\">"+indexNumber+"</a></center>"); 
			rowx.add(String.valueOf(jenisTabungan.getNamaJenisTbgn()));
					
							  
		}                                                       
		lstData.add(rowx); 
		
	}

	 rowx = new Vector();

	if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
                        rowx.add("<center><input type=\"hidden\" name=\""+frmObject.fieldNames[FrmJenisTabungan.FRM_FIELD_JENIS_TABUNGAN_ID] +"\" valie=\""+objEntity.getOID()+"\" class=\"formElemen\">"+indexNumber+"</center>");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmJenisTabungan.FRM_FIELD_NAMA_JENIS_TABUNGAN] +"\" value=\""+objEntity.getNamaJenisTbgn()+"\" class=\"formElemen\">");
	}  
	lstData.add(rowx);

	return ctrlist.draw(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidJenisTabungan = FRMQueryString.requestLong(request, "hidden_jenisTabungan_id");
long oidMasterTabungan = FRMQueryString.requestLong (request, "FRM_FIELD_ID_TABUNGAN");
String keyword = request.getParameter("keyword");
// variable declaration
boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
String whereClause="";
int iErrCode = FRMMessage.NONE;
if(keyword ==null){
    keyword ="";
}
if(oidMasterTabungan != 0){
    whereClause = ""  + PstJenisTabungan.fieldNames[PstJenisTabungan.FLD_NAMA_JENIS_TABUNGAN] + " LIKE '%" + keyword + "%'"+" AND "+ PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_ID_TABUNGAN] +" = "+oidMasterTabungan;
}else{
    whereClause = ""  + PstJenisTabungan.fieldNames[PstJenisTabungan.FLD_NAMA_JENIS_TABUNGAN] + " LIKE '%" + keyword + "%'";
}

String orderClause = ""+PstJenisTabungan.fieldNames[PstJenisTabungan.FLD_NAMA_JENIS_TABUNGAN];


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


CtrlJenisTabungan ctrlJenisTabungan = new CtrlJenisTabungan(request);
iErrCode = ctrlJenisTabungan.action(iCommand, oidJenisTabungan);
FrmJenisTabungan frmJenisTabungan = ctrlJenisTabungan.getForm();
JenisTabungan jenisTabungan = ctrlJenisTabungan.getJenisTabungan();
msgString =  ctrlJenisTabungan.getMessage();

Vector listJenisTabungan = new Vector(1,1);
    int vectSize = PstJenisTabungan.getCount(whereClause);
    if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
            start = ctrlJenisTabungan.actionList(iCommand, start, vectSize, recordToGet);
    } 

listJenisTabungan = PstJenisTabungan.list(start, recordToGet, whereClause, orderClause);
if (listJenisTabungan.size() < 1 && start > 0){
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
	 listJenisTabungan = PstJenisTabungan.list(start, recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmJenisTabungan.hidden_jenisTabungan_id.value="0";
	document.frmJenisTabungan.command.value="<%=Command.ADD%>";
	document.frmJenisTabungan.prev_command.value="<%=prevCommand%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdAsk(oidJenisTabungan){
	document.frmJenisTabungan.hidden_jenisTabungan_id.value=oidJenisTabungan;
	document.frmJenisTabungan.command.value="<%=Command.ASK%>";
	document.frmJenisTabungan.prev_command.value="<%=prevCommand%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdConfirmDelete(oidJenisTabungan){
	document.frmJenisTabungan.hidden_jenisTabungan_id.value=oidJenisTabungan;
	document.frmJenisTabungan.command.value="<%=Command.DELETE%>";
	document.frmJenisTabungan.prev_command.value="<%=prevCommand%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdSave(){
	document.frmJenisTabungan.command.value="<%=Command.SAVE%>";
	document.frmJenisTabungan.prev_command.value="<%=prevCommand%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdEdit(oidJenisTabungan){
	document.frmJenisTabungan.hidden_jenisTabungan_id.value=oidJenisTabungan;
	document.frmJenisTabungan.command.value="<%=Command.EDIT%>";
	document.frmJenisTabungan.prev_command.value="<%=prevCommand%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdCancel(oidJenisTabungan){
	document.frmJenisTabungan.hidden_jenisTabungan_id.value=oidJenisTabungan;
	document.frmJenisTabungan.command.value="<%=Command.EDIT%>";
	document.frmJenisTabungan.prev_command.value="<%=prevCommand%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdBack(){
	document.frmJenisTabungan.command.value="<%=Command.BACK%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdBackMaster(){
	document.frmJenisTabungan.command.value="<%=Command.BACK%>";
	document.frmJenisTabungan.action="mastertabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdListFirst(){
	document.frmJenisTabungan.command.value="<%=Command.FIRST%>";
	document.frmJenisTabungan.prev_command.value="<%=Command.FIRST%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdListPrev(){
	document.frmJenisTabungan.command.value="<%=Command.PREV%>";
	document.frmJenisTabungan.prev_command.value="<%=Command.PREV%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdListNext(){
	document.frmJenisTabungan.command.value="<%=Command.NEXT%>";
	document.frmJenisTabungan.prev_command.value="<%=Command.NEXT%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
}

function cmdListLast(){
	document.frmJenisTabungan.command.value="<%=Command.LAST%>";
	document.frmJenisTabungan.prev_command.value="<%=Command.LAST%>";
	document.frmJenisTabungan.action="jenistabungan.jsp";
	document.frmJenisTabungan.submit();
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
            <form name="frmJenisTabungan" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_jenisTabungan_id" value="<%=oidJenisTabungan%>">
              <input type="hidden" name="<%=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]%>" value="<%=oidMasterTabungan%>">
               <!--input type="text" name="hidden_masterTabungan_id<%--=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_ID_TABUNGAN]--%>" value="<%//=oidMasterTabungan%>"-->
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
                           <form name="cari" method="get" action="jenistabungan.jsp">
                           <td height="7" valign="middle" colspan="2" class="listtitle">&nbsp;</td>
                           <td height="7" align="left" valign="middle" class="listtitle">
                           <input onFocus="this.select()" name="keyword"  type="text" id="keyword" size="25" maxlength="25">
                           <input type="submit" value="cari" bgcolor="#00000"></td>
                      <% ///pencarian %>
                           </form>
                      </tr>
                      
                      
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,frmJenisTabungan, jenisTabungan,listJenisTabungan,oidJenisTabungan,SESS_LANGUAGE, start)%> </td> 
                      </tr>
                      <tr align="left" valign="top">
                        <td height="8" align="left" colspan="3" class="command"><% 
						  int cmd = 0;
						  if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST || iCommand==Command.BACK)
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
					String scomDel = "javascript:cmdAsk('"+oidJenisTabungan+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidJenisTabungan+"')";
					String scancel = "javascript:cmdEdit('"+oidJenisTabungan+"')";
                                        String scaback = "javascript:cmdBackt('"+oidJenisTabungan+"')";
					ctrLine.setCommandStyle("command");
					ctrLine.setColCommStyle("command");
					ctrLine.setAddCaption(strAddMar);
					//ctrLine.setBackCaption("");
					ctrLine.setCancelCaption(strCancel);														
					ctrLine.setBackCaption(strBackMar);														
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
					  if(privAdd && (iErrCode==ctrlJenisTabungan.RSLT_OK) && (iCommand!=Command.ADD) && (iCommand!=Command.ASK) && (iCommand!=Command.EDIT) && (iCommand!=Command.BACK) && (frmJenisTabungan.errorSize()==0) )
					  { 
					  %>					  
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
                          <table width="20%" border="0" cellspacing="0" cellpadding="0">
                            <tr>&nbsp;<a href="javascript:cmdAdd()" class="command"><%//=strAddMar%></a></tr>
                            <tr>&nbsp;<a href="javascript:cmdBack()" class="command"><%//=strBackMar%></a></tr>
                          </table>
                        </td>
                      </tr>
					  <%					  
					  }
					  %>
                           

                         

                            <td height="22" valign="middle" colspan="3" width="951"> 

                            <a href="javascript:cmdBackMaster('<%=oidMasterTabungan%>')" class="command"> 

                             Kembali ke Menu Utama</a></td>
                                                        

                            
                                          
                    </table>
                  </td>
                </tr>
				
				<%
				if( (iCommand ==Command.ADD) || (iCommand==Command.SAVE) || (iCommand==Command.BACK) && (frmJenisTabungan.errorSize()>0) || (iCommand==Command.EDIT) || (iCommand==Command.ASK) || (iCommand==Command.BACK ))
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
			if(iCommand==Command.ADD || iCommand==Command.EDIT || iCommand==Command.BACK)
			{
			%>
            <script language="javascript">
				document.frmJenisTabungan.<%=FrmJenisTabungan.fieldNames[FrmJenisTabungan.FRM_FIELD_NAMA_JENIS_TABUNGAN]%>.focus();
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

