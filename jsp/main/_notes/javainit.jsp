<%@ page import="com.wihita.qdep.system.*" %>
<%@ page import="com.wihita.aisbit.session.admin.*" %>
<%@ page import="com.wihita.aisbit.entity.admin.*" %>
<%@ page import="com.wihita.aisbit.entity.system.*" %>
<%@ page import="com.wihita.aisbit.session.periode.*" %> 

<%  
String approot="http://192.168.0.14:8080/aisbit";
String reportroot="http://192.168.0.14:8080/aisbit/servlet/com.wihita.aisbit.";

/* user is logging in or not */
boolean isLoggedIn = false; 

/* instant of object user session */
SessUserSession userSession = (SessUserSession) session.getValue(SessUserSession.HTTP_SESSION_NAME); 

/* set language */
int SESS_LANGUAGE = com.wihita.util.lang.I_Language.LANGUAGE_FOREIGN; 

/* set format number*/
String formatNum = "#,###.00";

long userOID = 0;
String userName = "";
AppUser appUserInit = new AppUser();
try{ 
	 appUserInit = userSession.getAppUser();
	 userName = appUserInit.getLoginId();
	 userOID = appUserInit.getOID();
}catch(Exception exc){
}

try{
    if(userSession==null){
        //userSession = new SessUserSession();
		//out.println("User session empty");
%>
		<script language="javascript">
			window.location="../login.jsp"; 
		</script> 
<%		
    }else{
        userSession.printAppUser();
        if(userSession.isLoggedIn())
            isLoggedIn  = true;
    }
} catch (Exception exc){
		out.println("Unknown error");
%>
		<script language="javascript">
			window.location="../login.jsp"; 
		</script> 
<% 
}


/* load System Property */
int periodInterval = Integer.parseInt(PstSystemProperty.getValueByName("PERIOD_INTERVAL"));
//out.println("periodInterval : "+ periodInterval);
int lastEntryDuration = Integer.parseInt(PstSystemProperty.getValueByName("LAST_ENTRY_DURATION"));
//out.println("lastEntryDuration : "+ lastEntryDuration);
%>


