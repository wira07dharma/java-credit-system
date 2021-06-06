<% 
// if menu will show
if(showMenu){ 

int intCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_SYSTEM, AppObjInfo.OBJ_SYSTEM_SYSTEM_APP); 
boolean pAdd=userSession.checkPrivilege(AppObjInfo.composeCode(intCode, AppObjInfo.COMMAND_ADD));
boolean pUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(intCode, AppObjInfo.COMMAND_UPDATE));
boolean pDelete=userSession.checkPrivilege(AppObjInfo.composeCode(intCode, AppObjInfo.COMMAND_DELETE));
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="footer">  
  <tr> 
	<td nowrap> 
	  <div align="center"> <A target="_parent" href="<%=approot%>/main/homepage.jsp"" class="topmenu"><img src="../image/home.gif" name="tes" width="988" height="30" border="0"><%//=strHomepage[SESS_LANGUAGE]%></A></div>
	</td> 
  </tr>
</table>


<%
// if menu will not show
}else{
%>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="footer"> 
  <tr><td><div align="center"><%=replaceMenuWith%></div></td></tr>
</table>

<%}%>