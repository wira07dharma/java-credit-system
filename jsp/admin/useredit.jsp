 
<%
/*
 * useredit.jsp
 *
 * Created on April 04, 2002, 11:30 AM
 *  
 * @author  ktanjana
 * @version 
 */ 
%>
<%@ page language="java" %>

<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@ page import = "com.dimata.aiso.entity.admin.*" %>
<%@ page import = "com.dimata.aiso.form.admin.*" %>
<%@ page import = "com.dimata.aiso.session.admin.*" %>

<%@ page import = "com.dimata.common.entity.location.Location" %>
<%@ page import = "com.dimata.common.entity.location.PstLocation" %>
<%@ page import = "com.dimata.common.entity.custom.DataCustom" %>
<%@ page import = "com.dimata.common.entity.custom.PstDataCustom" %>

<%@ page import = "com.dimata.harisma.entity.masterdata.Department" %>
<%@ page import = "com.dimata.harisma.entity.masterdata.PstDepartment" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privUpdate && !privDelete){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<!-- JSP Block -->
<%!
public static String strTitle[][] = {
	{"Login ID","Password","Konfirmasi Password","Nama","Email","Keterangan","Status User","Dimasukkan ke Grup","Ubah","Tambah","Lokasi Transaksi","Departmen","Kelompok Pemakai"},
	{"Login ID","Password","Confirm Password","Full Name","Email","Description","User Status","Group Assigned","Edit","Add","Assign Trans.Location","Department","User Group"}
};

public static final String systemTitle[] = {
	"Operator","User"
};

public static final String userTitle[] = {
	"Input","Entry"		
};

public String ctrCheckBox(long userID){ 
	ControlCheckBox chkBx=new ControlCheckBox();		
	chkBx.setCellSpace("0");		
	chkBx.setCellStyle("");
	chkBx.setWidth(4);
	chkBx.setTableAlign("left");
	chkBx.setCellWidth("10%");
	
        try{
            Vector checkValues = new Vector(1,1);
            Vector checkCaptions = new Vector(1,1);	  
			String orderBy = PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_NAME];
            Vector allGroups = PstAppGroup.list(0, 0, "", orderBy);

            if(allGroups!=null){
                int maxV = allGroups.size(); 
                for(int i=0; i< maxV; i++){
                    AppGroup appGroup = (AppGroup) allGroups.get(i);
                    checkValues.add(Long.toString(appGroup.getOID()));
                    checkCaptions.add(appGroup.getGroupName());
                }
            }

            Vector checkeds = new Vector(1,1);
            PstUserGroup pstUg = new PstUserGroup(0);
            Vector groups = SessAppUser.getUserGroup(userID);

            if(groups!=null){
                int maxV = groups.size(); 
                for(int i=0; i< maxV; i++){
                    AppGroup appGroup = (AppGroup) groups.get(i);
                    checkeds.add(Long.toString(appGroup.getOID()));
                }
            }
 
            chkBx.setTableWidth("100%");

            String fldName = FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP];
            return chkBx.draw(fldName,checkValues,checkCaptions,checkeds);

        } catch (Exception exc){
            return "No group assigned";
        }        
}

/**
 * untuk data custom lokasi
 * @param userID
 * @return
 */
public String ctrCheckBoxCustomLokasi(long userID)
{
    ControlCheckBox chkBx=new ControlCheckBox();
    chkBx.setCellSpace("0");
    chkBx.setCellStyle("");
    chkBx.setWidth(4);
    chkBx.setTableAlign("left");
    chkBx.setCellWidth("10%");

	try
	{
		Vector checkValues = new Vector(1,1);
		Vector checkCaptions = new Vector(1,1);
		String orderBy = PstLocation.fieldNames[PstLocation.FLD_NAME];
		Vector listLocat = PstLocation.list(0,0,"",orderBy);

		if(listLocat!=null)
		{
			int maxV = listLocat.size();
			for(int i=0; i< maxV; i++)
			{
				Location location = (Location) listLocat.get(i);
				checkValues.add(Long.toString(location.getOID()));
				checkCaptions.add(location.getName());
			}
		}

		Vector checkeds = new Vector(1,1);
		Vector userCustoms = PstDataCustom.getDataCustom(userID);
		if(userCustoms!=null)
		{
			int maxV = userCustoms.size();
			for(int i=0; i< maxV; i++)
			{
				DataCustom dataCustom = (DataCustom) userCustoms.get(i);
				checkeds.add(dataCustom.getDataValue());
			}
		}

		chkBx.setTableWidth("100%");
		String fldName = FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP]+"_DC";
		return chkBx.draw(fldName,checkValues,checkCaptions,checkeds);

	}
	catch (Exception exc)
	{
		return "No location assigned";
	}
}

/**
 * untuk data custom department
 * @param userID
 * @return
 */
public String ctrCheckBoxCustomDepartment(long userID)
{
    ControlCheckBox chkBx=new ControlCheckBox();
    chkBx.setCellSpace("0");
    chkBx.setCellStyle("");
    chkBx.setWidth(4);
    chkBx.setTableAlign("left");
    chkBx.setCellWidth("10%");

	try
	{
		Vector checkValues = new Vector(1,1);
		Vector checkCaptions = new Vector(1,1);
		String orderBy = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT];
		Vector listDept = PstDepartment.list(0,0,"",orderBy);
		if(listDept!=null && listDept.size()>0)
		{
			int maxV = listDept.size();
			for(int i=0; i<maxV; i++)
			{
				Department objDepartment = (Department) listDept.get(i);
				checkValues.add(Long.toString(objDepartment.getOID()));
				checkCaptions.add(objDepartment.getDepartment());
			}
		}

		Vector checkeds = new Vector(1,1);
		Vector userCustoms = PstDataCustom.getDataCustom(userID,"hrdepartment");
		if(userCustoms!=null)
		{
			int maxV = userCustoms.size();
			for(int i=0; i< maxV; i++)
			{
				DataCustom dataCustom = (DataCustom) userCustoms.get(i);
				checkeds.add(dataCustom.getDataValue());
			}
		}

		chkBx.setTableWidth("100%");
		String fldName = FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP]+"_DEPT";
		return chkBx.draw(fldName, checkValues, checkCaptions, checkeds);
	}
	catch (Exception exc)
	{
		return "No department assigned";
	}
}
%>

<%
/* VARIABLE DECLARATION */ 
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);

String currPageTitle = userTitle[SESS_LANGUAGE];
String strAddUser = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveUser = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskUser = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteUser = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackUser = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
String saveConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Data User Success" : "Simpan Data Sukses");

/* GET REQUEST FROM HIDDEN TEXT */
int iCommand = FRMQueryString.requestCommand(request);
long appUserOID = FRMQueryString.requestLong(request,"user_oid"); 
int start = FRMQueryString.requestInt(request, "start"); 

CtrlAppUser ctrlAppUser = new CtrlAppUser(request);
FrmAppUser frmAppUser = ctrlAppUser.getForm();
String strMasage = "";
 
int excCode=ctrlAppUser.action(iCommand,appUserOID);
AppUser appUser = ctrlAppUser.getAppUser();
strMasage = ctrlAppUser.getMessage();

if(iCommand == Command.SAVE){
	appUser = new AppUser();
	//strMasage = saveConfirm;
	}
// proses untuk data custom
if(iCommand == Command.DELETE)
	response.sendRedirect("userlist.jsp"); 

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">

function cmdCancel(){
	//document.frmAppUser.user_oid.value=oid;
	document.frmAppUser.command.value="<%=Command.EDIT%>";
	document.frmAppUser.action="useredit.jsp";
	document.frmAppUser.submit();
}

<% if(privAdd || privUpdate) {%>
function cmdSave(){
	document.frmAppUser.command.value="<%=Command.SAVE%>";
	document.frmAppUser.action="useredit.jsp";
	document.frmAppUser.submit();
}
<%}%>

<% if(privDelete) {%>
function cmdAsk(oid){
	document.frmAppUser.user_oid.value=oid;
	document.frmAppUser.command.value="<%=Command.ASK%>";
	document.frmAppUser.action="useredit.jsp";
	document.frmAppUser.submit();
}

function cmdDelete(oid){
	document.frmAppUser.user_oid.value=oid;
	document.frmAppUser.command.value="<%=Command.DELETE%>";
	document.frmAppUser.action="useredit.jsp";
	document.frmAppUser.submit();
}
<%}%>


function cmdBack(oid){
	document.frmAppUser.user_oid.value=oid;
	document.frmAppUser.command.value="<%=Command.BACK%>";
	document.frmAppUser.action="userlist.jsp";
	document.frmAppUser.submit();
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
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
		  <b><%=systemTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=appUserOID!=0 ? strTitle[SESS_LANGUAGE][8].toUpperCase() : strTitle[SESS_LANGUAGE][9].toUpperCase()%></font></b><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmAppUser" method="get" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="user_oid" value="<%=appUserOID%>">
              <input type="hidden" name="start" value="<%=start%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                
              </table>			  			  			  
              <table width="100%" cellspacing="2" cellpadding="2">
                <%if((excCode>-1) || ((iCommand==Command.SAVE)&&(frmAppUser.errorSize()>0)) ||(iCommand==Command.ADD)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                <tr> 
                  <td colspan="3" class="txtheading1"></td>
                </tr>
                <tr> 
                  <td width="11%" height="26"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td width="1%" height="26">:</td>
                  <td width="88%" height="26">&nbsp; 
                    <input type="text" name="<%=frmAppUser.fieldNames[frmAppUser.FRM_LOGIN_ID] %>" value="<%=appUser.getLoginId()%>">
                    * &nbsp;<%= frmAppUser.getErrorMsg(frmAppUser.FRM_LOGIN_ID) %></td>
                </tr>
                <tr> 
                  <td width="11%"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <input type="password" name="<%=frmAppUser.fieldNames[frmAppUser.FRM_PASSWORD] %>" value="<%=appUser.getPassword()%>">
                    * &nbsp;<%= frmAppUser.getErrorMsg(frmAppUser.FRM_PASSWORD) %></td>
                </tr>
                <tr> 
                  <td width="11%"><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <input type="password" name="<%=frmAppUser.fieldNames[frmAppUser.FRM_CFRM_PASSWORD] %>" value="<%=appUser.getPassword()%>">
                    * &nbsp;<%= frmAppUser.getErrorMsg(frmAppUser.FRM_CFRM_PASSWORD) %></td>
                </tr>
                <tr> 
                  <td width="11%"><%=strTitle[SESS_LANGUAGE][3]%></td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <input type="text" name="<%=frmAppUser.fieldNames[frmAppUser.FRM_FULL_NAME] %>" value="<%=appUser.getFullName()%>">
                    * &nbsp;<%= frmAppUser.getErrorMsg(frmAppUser.FRM_FULL_NAME) %></td>
                </tr>
                <tr> 
                  <td width="11%"><%=strTitle[SESS_LANGUAGE][4]%></td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <input type="text" name="<%=frmAppUser.fieldNames[frmAppUser.FRM_EMAIL] %>" value="<%=appUser.getEmail()%>" size="30">
                    &nbsp;<%= frmAppUser.getErrorMsg(frmAppUser.FRM_EMAIL) %></td>
                </tr>
                <tr> 
                  <td width="11%" valign="top"><%=strTitle[SESS_LANGUAGE][5]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="88%">&nbsp; 
                    <textarea name="<%=frmAppUser.fieldNames[frmAppUser.FRM_DESCRIPTION] %>" cols="45"><%=appUser.getDescription()%></textarea>
                    &nbsp;<%= frmAppUser.getErrorMsg(frmAppUser.FRM_DESCRIPTION) %></td>
                </tr>
                <tr> 
                  <td width="11%"><%=strTitle[SESS_LANGUAGE][6]%></td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <%
                        ControlCombo cmbox = new ControlCombo();
                        Vector sts = AppUser.getStatusTxts();
                        Vector stsVals = AppUser.getStatusVals();
                    %>
                    <%=cmbox.draw(frmAppUser.fieldNames[frmAppUser.FRM_USER_STATUS] ,
                        null, Integer.toString(appUser.getUserStatus()), stsVals, sts)%> &nbsp;<%= frmAppUser.getErrorMsg(frmAppUser.FRM_USER_STATUS) %></td>
                </tr>
				<tr> 
                  <td width="11%"><%=strTitle[SESS_LANGUAGE][12]%></td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <%
                        ControlCombo cmbBox = new ControlCombo();
                        Vector vUserGroupKey = AppUser.getUserGroupTxts();						
                        Vector vUserGroupVals = AppUser.getUserGroupVals();						
                    %>
                    <%=cmbBox.draw(frmAppUser.fieldNames[frmAppUser.FRM_USER_GROUP] ,
                        null, Integer.toString(appUser.getGroupUser()), vUserGroupVals, vUserGroupKey)%> &nbsp;<%= frmAppUser.getErrorMsg(frmAppUser.FRM_USER_GROUP) %></td>
                </tr>
				
                <!--<tr> 
                  <td width="11%">Last Update Date</td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <%/* if(appUser.getUpdateDate()==null)
						out.println("-");
					   else 
						out.println(appUser.getUpdateDate());
						*/
					%>
                    <input type="hidden" name="<%=frmAppUser.fieldNames[frmAppUser.FRM_UPDATE_DATE] %>2" value="<%=appUser.getUpdateDate()%>">
                  </td>
                </tr>
                <tr> 
                  <td width="11%">Registered Date</td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <%/* if(appUser.getRegDate()==null)
						out.println("-");
					   else 
						out.println(appUser.getRegDate());
						*/
					%>
                  </td>
                </tr>
                <tr> 
                  <td width="11%">Last Login Date</td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <%/* if(appUser.getLastLoginDate()==null)
						out.println("-");
					   else 
						out.println(appUser.getLastLoginDate());
						*/
					%>
                  </td>
                </tr>
                <tr> 
                  <td width="11%">Last Login IP</td>
                  <td width="1%">:</td>
                  <td width="88%">&nbsp; 
                    <%/* if(appUser.getLastLoginIp()==null)
						 out.println("-");
					   else 
						 out.println(appUser.getLastLoginIp());
						 */
					%>
                  </td>
                </tr>-->

                <tr>
                  <td width="11%" valign="top" height="14" nowrap><%=strTitle[SESS_LANGUAGE][11]%></td>
                  <td width="1%" height="14" valign="top">:</td>
                  <td width="88%" height="14"><%=ctrCheckBoxCustomDepartment(appUserOID)%> </td>
                </tr>
                <tr>
                  <td width="11%" valign="top" height="14" nowrap><%=strTitle[SESS_LANGUAGE][10]%></td>
                  <td width="1%" height="14" valign="top">:</td>
                  <td width="88%" height="14"><%=ctrCheckBoxCustomLokasi(appUserOID)%> </td>
                </tr>				  
                <tr>
                  <td width="11%" valign="top" height="14" nowrap><%=strTitle[SESS_LANGUAGE][7]%></td>
                  <td width="1%" height="14" valign="top">:</td>
                  <td width="88%" height="14"><%=ctrCheckBox(appUserOID)%> </td>
                </tr>				  
                <tr> 
                  <td width="11%" valign="top" height="14" nowrap>&nbsp;</td>
                  <td width="1%" height="14">&nbsp;</td>
                  <td width="88%" height="14">&nbsp;</td>
                </tr>				  
                <%if(iCommand == Command.ASK){%>
                <tr> 
                  <td colspan="3" class="msgerror"><%=delConfirm%></td>
                </tr>
                <%}%>
				<%if(strMasage.length() > 0){
					if(excCode > 0){
				%>
					<tr> 
					  <td colspan="3" class="msgerror"><%=strMasage%></td>
					</tr>
				<%}else{%>	
					<tr> 
					  <td colspan="3" class="msginfo"><%=strMasage%></td>
					</tr>
				<%}
				}%>			
                <tr> 
                  <td width="11%" class="command">&nbsp;</td>
                  <td width="1%" class="command">&nbsp;</td>
                  <td width="88%" class="command"> 
                    <%if(iCommand!=Command.ASK){%>     
					<%if(iCommand!=Command.ADD){%>
                    <%}%>               
						<% if(privAdd || privUpdate) {%>
							&nbsp;<a href="javascript:cmdSave()"><%=strSaveUser%></a> | 
							
							
						<%}%>
                    		<a href="javascript:cmdBack()"><%=strBackUser%></a> 
						<%if(privDelete && (iCommand!=Command.ADD)&&(!((iCommand==Command.SAVE)&&(appUserOID<1)))){%>
							| <a href="javascript:cmdAsk('<%=appUserOID%>')"><%=strAskUser%></a> 
						<%}%>
                    <%}else{%>
						<% if(privDelete) {%>
						&nbsp;<a href="javascript:cmdDelete('<%=appUserOID%>')"><%=strDeleteUser%></a> | <a href="javascript:cmdCancel()"><%=strCancel%></a> 
						<%
						}// end of privDelete
						
						%>
					<%}  %>
					  </td>
					</tr>
                <%} else {%>
					<%if(SESS_LANGUAGE==langDefault){%>
					<tr> 
					  <td colspan="3">&nbsp; Prosess OK .. kembali ke daftar, <a href="javascript:cmdBack()">klik di sini</a></td>
						<script language="JavaScript">
						cmdBack();
						</script>
					</tr>
					<%}else{%>
					<tr> 
					  <td colspan="3">&nbsp; Processing OK .. back to list, <a href="javascript:cmdBack()">click here</a></td>
						<script language="JavaScript">
						cmdBack();
						</script>				  
					</tr>
					<%}%>								
                <%}%>
				
              </table>
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
<!-- endif of "has access" condition -->
<%}%>