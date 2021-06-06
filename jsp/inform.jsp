 
<%@ page language="java" %>
<%@ include file = "main/javainit.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dimata.qdep.system.*" %>
<%@ page import="com.dimata.aiso.session.admin.*" %>
<%@ page import="com.dimata.aiso.entity.admin.*" %>

<%!
    final static int CMD_NONE = 0;
    final static int CMD_LOGIN = 1;
    final static int MAX_SESSION_IDLE = 10000000;
    int langDefault = com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT;
    int langForeign = com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN;
%>

<%//
    String sic = "";
    int infCode = 0;
    String msgAccess = "";
    try {
        sic = (request.getParameter("ic") == null) ? "0" : request.getParameter("ic");
        infCode = Integer.parseInt(sic);
    } catch (Exception e) {
        infCode = 0;
    }

    switch (infCode) {
        case I_SystemInfo.HAVE_NOPRIV:
            msgAccess = "Anda tidak memiliki wewenang untuk mengakses modul ini";
            break;

        case I_SystemInfo.NOT_LOGIN:
            msgAccess = "Sesi Anda telah berakhir.<br>Silakan masuk untuk melanjutkan";
            break;

        default:
            
    }
    
    int iCommand = FRMQueryString.requestCommand(request);
    int dologin = SessUserSession.DO_LOGIN_OK;
    if (iCommand == CMD_LOGIN) {
        String loginID = FRMQueryString.requestString(request, "login_id");
        String passwd = FRMQueryString.requestString(request, "pass_wd");
        int appLanguage = FRMQueryString.requestInt(request, "app_language");
        String remoteIP = request.getRemoteAddr();
        SessUserSession userSess = new SessUserSession(remoteIP);

        dologin = userSess.doLogin(loginID, passwd);
        if (dologin == SessUserSession.DO_LOGIN_OK) {
            session.setMaxInactiveInterval(MAX_SESSION_IDLE);
            session.putValue(SessUserSession.HTTP_SESSION_NAME, userSess);

            session.putValue("APPLICATION_LANGUAGE", String.valueOf(appLanguage));
            String strLang = "";
            if (session.getValue("APPLICATION_LANGUAGE") != null) {
                strLang = String.valueOf(session.getValue("APPLICATION_LANGUAGE"));
            }
            appLanguage = (strLang != null && strLang.length() > 0) ? Integer.parseInt(strLang) : 0;
        }
    }
%>

<%
    if ((iCommand == CMD_LOGIN) && (dologin == SessUserSession.DO_LOGIN_OK)) {
%>
<script language="javascript">
    window.top.location = "sp_index.jsp";
</script>
<%
    }
%>
<html>
    <head>
        <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="style/main.css" type="text/css">
        <link rel="StyleSheet" href="dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="dtree/dtree.js"></script>
        <%@ include file = "/style/lte_head.jsp" %>
    </head>

    <body class="hold-transition login-page" style="background-color: #BBB">
        <div style="margin: 1% auto;" class="login-box">
            <div class="login-logo">
                <img src="./images/sedana-logo.png" style="display: inline-block; width: 50px;" /><br>  
                <div style="color:white;"><b style="width: 100%; display: inline-block;">SEDANA</b><span style="font-size: 22px;width: 100%; display: block;">Sistem Manajemen Simpan Pinjam</span></div>
            </div>
            <div class="login-box-body" style="box-shadow: 0 0 20px rgba(0, 0, 0, 0.35); border-radius: 2px;">
                
                <p class="login-box-msg" style="color: #4CAF50; font-weight: bold;"><%=msgAccess%></p>

                <form name="frmLogin" method="post" onsubmit="javascript:cmdLogin()">
                    <input type="hidden" name="sel_top_mn" value="4">
                    <input type="hidden" name="command" value="<%=CMD_LOGIN%>">
                    <div class="form-group has-feedback">
                        <input type="text" class="form-control" name="login_id" placeholder="User ID">
                        <span class="glyphicon glyphicon-user form-control-feedback"></span>
                    </div>
                    <div class="form-group has-feedback">
                        <input type="password" name="pass_wd" class="form-control" placeholder="Password">
                        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    </div>
                    <div class="row">
                        <div class="col-xs-8">
                            <div class="form-group">
                                <label>Language</label>
                                <% String[] strLang = com.dimata.util.lang.I_Language.langName;%>
                                <select name="app_language" class="form-control">
                                    <option value="<%=langDefault%>"><%=strLang[langDefault]%></option>
                                    <option value="<%=langForeign%>"><%=strLang[langForeign]%></option>
                                </select>
                            </div>
                        </div>
                        <div class="col-xs-4">
                            <button type="submit" style="margin-top: 24px;" class="btn btn-success btn-block btn-flat">Login</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
