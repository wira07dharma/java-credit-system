<%@page import="com.dimata.posbo.service.ServiceCalculatePrice"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.common.entity.system.PstSystemProperty"%>
<%@page import="com.dimata.aiso.entity.masterdata.Company"%>
<%@page import="com.dimata.common.entity.license.LicenseProduct"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstCompany"%>
<%@ page language="java" %> 
<%//@ include file="main/javainit.jsp"%> 
<%@ page import="java.util.*" %>
<%@ page import="com.dimata.aiso.session.admin.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@include file="./versioning.jsp" %>

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
            Cookie[] cookies = request.getCookies();
            String sessionId = "";
            if(cookies !=null){
                for(Cookie cookie : cookies){
                        if(cookie.getName().equals("JSESSIONID")) sessionId = cookie.getValue();
                        session.putValue(sessionId, userSess);
                }
            }
            
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

    String txtChiperText = "";
    try {
        txtChiperText = PstCompany.getLicenseKey();
    } catch (Exception e) {
    }
    boolean isValidKey = true;//LicenseProduct.btDekripActionPerformed(txtChiperText);

    long oidCompany = PstCompany.getOidCompany();
    Company objCompany = new Company();
    if (oidCompany != 0) {
        objCompany = PstCompany.fetchExc(oidCompany);
    }
    String lokasiAmbilFoto = PstSystemProperty.getValueByName("COMP_IMAGE_GET_PATH");
    
    ServiceCalculatePrice service = new ServiceCalculatePrice();
    boolean isRunning = service.getStatus();
    if (!isRunning){
        service.startService();
    }


%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="./style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="./style/AdminLTE-2.3.11/bootstrap/css/font-awesome.min.css">
        <!-- Ionicons -->
        <link rel="stylesheet" href="./style/AdminLTE-2.3.11/bootstrap/css/ionicons.min.css">
        <!-- Datetime Picker -->
        <link href="./style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <!-- Select2 -->
        <link rel="stylesheet" href="./style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="./style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins
             folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="./style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">

        <!-- jQuery 2.2.3 -->
        <script src="./style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
        <%--<style> html {position: fixed; width: 100%; height: 100% !important; overflow: auto;} body { background-image: url(./images/background.jpg) !important; background-position: left bottom !important; height: unset !important; } </style>--%>
        <style> html {position: fixed; width: 100%; height: 100% !important; overflow: auto;} body > div.background { background-image: url(./images/background.jpg) !important; background-position: center center !important; height: unset !important; width: 100%; -webkit-background-size: cover; -moz-background-size: cover; -o-background-size: cover; position: fixed; top: 0; bottom: 0; left: 0; right: 0; z-index: -1;} </style>
    </head>
    <body class="hold-transition login-page">
        <div class="background"></div>
        <div style="margin: 1% auto;" class="login-box"> 
            <div class="login-logo">
                <div style="color:white;"><b style="width: 100%; display: inline-block;">SEDANA</b><span style="font-size: 22px;width: 100%; display: block;">Sistem Manajemen Sewa Beli</span></div>
            </div>
            <!-- /.login-logo -->
            <div class="login-box-body" style="box-shadow: 0 0 20px rgba(0, 0, 0, 0.35); border-radius: 2px;">
                <div class="login-logo">
                    <% if (!lokasiAmbilFoto.equals("") && (!objCompany.getCompImage().equals("") && objCompany.getCompImage() != null)) {%>
                    <img src="<%=lokasiAmbilFoto%>/<%=objCompany.getCompImage()%>" style="display: inline-block; width: 100px;" alt="User Image">
                    <% } else { %>
                    <img src="./images/company_logo.jpg" style="display: inline-block; width: 100px;" />
                    <% }%>
                </div>
                <p class="login-box-msg">Masuk untuk memulai sesi</p>

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
                                    <option selected value="<%=langDefault%>"><%=strLang[langDefault]%></option>
                                    <option value="<%=langForeign%>"><%=strLang[langForeign]%></option>
                                </select>
                            </div>
                        </div>
                        <!-- /.col -->
                        <div class="col-xs-4">
                            <button type="submit" style="margin-top: 24px;" class="btn btn-success btn-block btn-flat">Login</button>
                        </div>
                        <!-- /.col -->
                        <div class="col-xs-12">
                            <hr style="margin-top:5px;margin-bottom:5px;">
                            <center>
                                <span>SEDANA Version <%=request.getAttribute("version")%> ( Build : <%=request.getAttribute("build")%> )<br>Copyright &copy; <%=request.getAttribute("year")%> Dimata&reg; IT Solution<br>Telp. (0361) 499029, 482431; Fax (0361) 499029<br>Hotline Support. 081237710011 <br>Website : <a href="http://www.dimata.com" class="footerLink">www.dimata.com</a><br></span>
                            </center>
                        </div>
                    </div>
                </form>
            </div>
            <!-- /.login-box-body -->
        </div>
        <!-- /.login-box -->

        <!-- Bootstrap 3.3.6 -->
        <script src="./style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="./style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>
        <!-- AdminLTE App -->
        <script src="./style/AdminLTE-2.3.11/dist/js/app.min.js"></script>
        <!-- AdminLTE for demo purposes -->
        <script src="./style/AdminLTE-2.3.11/dist/js/demo.js"></script>

        <script language="JavaScript">
                    document.frmLogin.login_id.focus();
        </script>
        <%
            if (true) {
        %>
        <script language="javascript">
            <%if (isValidKey) {%>
            <%} else {%>
            window.location = "license.jsp";
            <%}%>
        </script>
        <%
            }
        %>
    </body>
</html>
