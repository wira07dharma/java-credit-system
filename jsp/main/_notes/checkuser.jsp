<%@ page import="com.wihita.qdep.system.*" %>
<%@ page import="com.wihita.aisbit.session.admin.*" %>
<%@ page import="com.wihita.aisbit.entity.admin.*" %>

<%
/**
* jsp include this jsp hs to declare variable named :
* int appObjCode
* and initilize it it with the object code ( not with the command)
* e.g. 
* int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_ADMIN, AppObjInfo.G2_ADMIN_USER, AppObjInfo.OBJ_ADMIN_USER_USER); 
*
* !!! VIEW privilege access will be checked as the basic privilege !!!
*/
    
try{
    if(isLoggedIn==false){
        %>
                <script language="javascript">
                        window.location="<%= approot %>/inform.jsp?ic=<%= I_SystemInfo.NOT_LOGIN %>";
                </script>			
        <%			
    }

    if( false && (userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW)) ==false)){
        %>
                <script language="javascript">
                        window.location="<%= approot %>/inform.jsp?ic=<%= I_SystemInfo.NOT_LOGIN %>";
                </script>			
        <%			
    }

    


   } catch (Exception exc){
      System.out.println(" ==> Exception during check user");
    }

%>
