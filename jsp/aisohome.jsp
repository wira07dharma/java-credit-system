<%@ page language="java" %>
<%@ include file = "main/javainit.jsp" %>


<% 
  int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); 
  urlForSessExpired =approot+"/login.jsp";

%>
<%@ include file = "/main/checkuser.jsp" %>

<%
/** Check privilege except VIEW, view is already checked on checkuser.jsp as basic access */
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));
%>

<html>
<head>
<title><%=strJSPTitle[SESS_LANGUAGE][0]%>
</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset cols="222,15,*" frameborder="NO" border="0" framespacing="0"> 
  <frameset rows="1,*" frameborder="NO" border="0" framespacing="0"> 
    <frame name="logoFrame" id="logoFrame" scrolling="NO" noresize src="logo.html" >
    <frame name="leftFrame" id="leftFrame" scrolling="YES" noresize src="leftmenu.jsp?user_group=<%=userGroup%>&SESS_LANGUAGE=<%=SESS_LANGUAGE%>">
  </frameset>
  <frameset rows="5,*"  frameborder="NO" border="0" framespacing="0" > 
  	<frame name="spaceTopFrame" id="spaceTopFrame" scrolling="NO" noresize src="header.jsp" >
    <frame name="spaceFrame" id="spaceFrame" scrolling="NO" noresize src="space.jsp?user_group=<%=userGroup%>&SESS_LANGUAGE=<%=SESS_LANGUAGE%>" >  
  </frameset>	
  <frameset rows="5,*" frameborder="NO" border="0" framespacing="0" cols="*"> 
    <frame name="topFrame" id="topFrame" scrolling="YES" noresize src="header.jsp" >
    <frame name="mainFrame" id="mainFrame" scrolling="YES" noresize src="homexframe.jsp">
  </frameset>
</frameset>
<noframes> 
<body bgcolor="#FFFFFF" text="#000000">
</body>
</noframes> 
</html>
