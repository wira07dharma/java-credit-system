<%@page import="com.dimata.common.entity.system.PstSystemProperty"%>
<%@page import="com.dimata.aiso.entity.masterdata.Company"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstCompany"%>
<%@ page language="java" %> 
<%//@ include file="main/javainit.jsp"%> 
<%@ page import="java.util.*" %>
<%@ page import="com.dimata.aiso.session.admin.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ include file = "main/javainit.jsp" %>

<%!
    final static int CMD_NONE = 0;
    final static int CMD_LOGIN = 1;
    final static int MAX_SESSION_IDLE = 10000000;
    int langDefault = com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT;
    int langForeign = com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN;
%>

<%    /*com.dimata.aiso.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso-divine.xml";
     com.dimata.common.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso-divine.xml";
     com.dimata.harisma.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso-divine.xml";
     com.dimata.ij.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso-divine.xml";
     com.dimata.qdep.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso-divine.xml";
     com.dimata.services.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso-divine.xml";
     */

    /*com.dimata.aiso.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_v3.xml";
     com.dimata.common.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_v3.xml";
     com.dimata.harisma.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_v3.xml";
     com.dimata.ij.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_v3.xml";
     com.dimata.qdep.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_v3.xml";
     com.dimata.services.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_v3.xml";

     com.dimata.aiso.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_dimata.xml";
     com.dimata.common.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_dimata.xml";
     com.dimata.harisma.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_dimata.xml";
     com.dimata.ij.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_dimata.xml";
     com.dimata.qdep.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_dimata.xml";
     com.dimata.services.db.DBHandler.CONFIG_FILE = System.getProperty("java.home") + System.getProperty("file.separator") + "dimata" +System.getProperty("file.separator") + "aiso_dimata.xml";
     */
    try {
        if (userSession.isLoggedIn() == true) {
            userSession.printAppUser();
            userSession.doLogout();
            session.removeValue(sessionId);
            session.removeValue("APPLICATION_LANGUAGE");
        }
        if (userSession != null) {
            session.removeValue(sessionId);
        }
    } catch (Exception exc) {
        System.out.println(" ==> Exception during logout user");
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
            session.putValue(sessionId, userSess);
            // userSess = (SessUserSession) session.getValue(SessUserSession.HTTP_SESSION_NAME);			

            session.putValue("APPLICATION_LANGUAGE", String.valueOf(appLanguage));
            String strLang = "";
            if (session.getValue("APPLICATION_LANGUAGE") != null) {
                strLang = String.valueOf(session.getValue("APPLICATION_LANGUAGE"));
            }
            appLanguage = (strLang != null && strLang.length() > 0) ? Integer.parseInt(strLang) : 0;
        }
    }

    if ((iCommand == CMD_LOGIN) && (dologin == SessUserSession.DO_LOGIN_OK)) {
        String destination = "sp_index.jsp";
        response.sendRedirect(response.encodeRedirectURL(destination));
    }

    long oidCompany = PstCompany.getOidCompany();
    Company objCompany = new Company();
    if (oidCompany != 0) {
        objCompany = PstCompany.fetchExc(oidCompany);
    }
    String lokasiAmbilFoto = PstSystemProperty.getValueByName("COMP_IMAGE_GET_PATH");

%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <%@ include file = "/style/lte_head.jsp" %>
        <style> html {position: fixed; width: 100%; height: 100% !important; overflow: auto;} body { background-image: url(./images/background.jpg) !important; background-position: left bottom !important; height: unset !important; } </style>
    </head>
    <body class="hold-transition login-page">
        <div style="margin: 1% auto;" class="login-box">
            <div class="login-logo">
                <img src="./images/sedana-logo.png" style="display: inline-block; width: 50px;" /><br>  
                <div style="color:white;"><b style="width: 100%; display: inline-block;">SEDANA</b><span style="font-size: 22px;width: 100%; display: block;">Sistem Manajemen Sewa Beli</span></div>
            </div>
            <div class="login-box-body" style="box-shadow: 0 0 20px rgba(0, 0, 0, 0.35); border-radius: 2px;">
                <div class="login-logo">
                    <% if (!lokasiAmbilFoto.equals("") && (!objCompany.getCompImage().equals("") && objCompany.getCompImage() != null)) {%>
                    <img src="<%=lokasiAmbilFoto%>/<%=objCompany.getCompImage()%>" style="display: inline-block; width: 100px;" alt="User Image">
                    <% } else { %>
                    <img src="./images/company_logo.jpg" style="display: inline-block; width: 100px;" />
                    <% }%>
                </div>
                <p class="login-box-msg" style="color: #4CAF50; font-weight: bold;">Anda berhasil keluar.<br>Masuk untuk memulai sesi baru.</p>

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
                    <% if ((iCommand == CMD_LOGIN) && (dologin != SessUserSession.DO_LOGIN_OK)) {%>
                    <div class="row">
                        <div class="col-xs-12">
                            <span style="display: inline-block; text-align: center; width: 100%; margin-bottom: 10px;" class="alert-error"><%=SessUserSession.soLoginTxt[dologin]%></span>
                        </div>
                    </div>
                    <%}%>
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

        <!-- Bootstrap 3.3.6 -->
        <script src="./style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="./style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>
        <!-- AdminLTE App -->
        <script src="./style/AdminLTE-2.3.11/dist/js/app.min.js"></script>
        <!-- AdminLTE for demo purposes -->
        <script src="./style/AdminLTE-2.3.11/dist/js/demo.js"></script>

        <% if ((iCommand != CMD_LOGIN) && (dologin != SessUserSession.DO_LOGIN_OK)) { %>
        <script language="JavaScript">
                    document.frmLogin.login_id.focus();
        </script>
        <%}%>
    </body>
</html>
