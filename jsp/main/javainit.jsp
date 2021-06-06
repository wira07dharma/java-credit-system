<%@ page import="java.util.*" %>

<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.system.*" %>

<%//@ page import="com.dimata.ij.I_IJGeneral" %>

<%@ page import="com.dimata.common.entity.system.*" %>
<%@ page import="com.dimata.common.session.system.*" %>

<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.session.admin.*" %>

<%@ page import="com.dimata.aiso.entity.periode.*" %>   
<%@ page import="com.dimata.aiso.session.periode.*" %>    

<%@ page import="com.dimata.common.entity.custom.DataCustom" %>
<%@ page import="com.dimata.common.entity.custom.PstDataCustom" %>
<%@include file="./../versioning.jsp" %>

<%
  int iInactiveInterval = 60;
  try {
    iInactiveInterval = Integer.parseInt(PstSystemProperty.getValueByName("ACTIVE_DURATION"));
  } catch (Exception e) {
  }

  try {
    //session.setMaxInactiveInterval(iInactiveInterval);
    session.setMaxInactiveInterval(60 * 60 * 5);
  } catch (Exception exc) {
    System.out.println("Error set session interval " + exc);
  }

  String approot = request.getContextPath();
  String urlForSessExpired = approot + "/inform.jsp";
  String reportroot = approot + "/servlet/com.dimata.sedana.";
  String chartroot = approot + "/servlet/DisplayChart?filename=";
  String reportrootimage = approot + "/images/";
  String reportrootfooter = "/" + reportroot;

  String sSystemDecimalSymbol = ".";
  String sUserDecimalSymbol = ".";
  String sUserDigitGroup = ",";
  long accountingBookType = 0;
  int useRaditya = Integer.parseInt(PstSystemProperty.getValueByName("USE_FOR_RADITYA"));
  long starttm = System.currentTimeMillis();
  System.out.println("START Javainit :   " + starttm);

  try {
    accountingBookType = Long.parseLong(PstSystemProperty.getValueByName("BOOK_TYPE"));
  } catch (Exception e) {
  }

  /**
   * user is logging in or not
   */
  boolean isLoggedIn = false;

  String strInformation = "";
  try {
    strInformation = PstSystemProperty.getValueByName("INFORMATION");
  } catch (Exception e) {

  }
  /**
   * used to hide menu
   */
  boolean showMenu = true;
  String replaceMenuWith = "";
  String strHomepage[] = {
    "KEMBALI KE HALAMAN UTAMA", "BACK TO HOMEPAGE"
  };
  String strMenuList[][] = {
    {"HALAMAN UTAMA", "JURNAL", "LAPORAN", "PERIODE", "MASTERDATA", "SISTEM", "BANTUAN", "KELUAR", "ANALISIS"},
    {"HOMEPAGE", "JOURNAL", "REPORT", "PERIOD", "MASTERDATA", "SYSTEM", "HELP", "LOGOUT", "ANALYSIS"}
  };

  String strJSPTitle[][] = {
    {"SEDANA untuk Perusahaan Anda", "Selamat Datang : SEDANA untuk Perusahaan Anda"},
    {"SEDANA for Your Company", "Welcome to SEDANA for Your Company"}
  };

  String sChartTitle[][] = {
    {
      "Grafik Komposisi Biaya (dalam IDR ",
      "Grafik Komposisi Pendapatan (dalam IDR ",
      "Grafik Kontribusi Pendapatan ",
      "Grafik Komposisi Modal Kerja (dalam IDR "
    },
    {
      "Expenses Composition (in IDR ",
      "Revenue Composition (in IDR ",
      "Revenue Contribution ",
      "Net Working Capital Composition (in IDR "
    }
  };

  String sOtherLabel[] = {
    "Lain-lain", "Others"
  };

  /**
   * instant of object user session
   */
    Cookie[] cookies = request.getCookies();
    String sessionId = "";
    if(cookies !=null){
        for(Cookie cookie : cookies){
                if(cookie.getName().equals("JSESSIONID")) sessionId = cookie.getValue();
                //session.putValue(sessionId, userSess);
        }
    }
  int autoLogin = FRMQueryString.requestInt(request, "autologin");
    if (autoLogin == 1){
        
        SessUserSession userSession = (SessUserSession) session.getValue(sessionId);
        if (userSession == null) {
            userSession = new SessUserSession();
          }
        if (userSession.isLoggedIn() == true) {
            userSession.printAppUser();
            userSession.doLogout();
            session.removeValue(sessionId);
            session.removeValue("APPLICATION_LANGUAGE");
        }
        if (userSession != null) {
            session.removeValue(sessionId);
        }
        String loginID = FRMQueryString.requestString(request, "username");
        String passwd = FRMQueryString.requestString(request, "password");
        int appLanguage = 0;
        int dologin = SessUserSession.DO_LOGIN_OK;
        String remoteIP = request.getRemoteAddr();
        SessUserSession userSess = new SessUserSession(remoteIP);

        dologin = userSess.doLogin(loginID, passwd);
        if (dologin == SessUserSession.DO_LOGIN_OK) {
            session.setMaxInactiveInterval(10000000);
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
  SessUserSession userSession = (SessUserSession) session.getValue(sessionId);
  if (userSession == null) {
    userSession = new SessUserSession();
  } else {
    if (userSession.isLoggedIn()) {
      isLoggedIn = true;
    }

  }

  /**
   * set language
   */
  String strLanguage = "";
  if (session.getValue("APPLICATION_LANGUAGE") != null) {
    strLanguage = String.valueOf(session.getValue("APPLICATION_LANGUAGE"));
  }

  int langDefault = com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT;
  int langForeign = com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN;
  int SESS_LANGUAGE = (strLanguage != null && strLanguage.length() > 0) ? Integer.parseInt(strLanguage) : langForeign;
  /**
   * set format number
   */
  String formatNum = "#,###.00";

  long userOID = 0;
  String userName = "";
  String userFullName = "";
  int iCheckMenu = 0;
  int userGroup = 0;
  long userLocationId = 0;
  String sCheckMenu = "";
  sCheckMenu = (String) session.getValue("CHECK_MENU");

  if (sCheckMenu != null && sCheckMenu.length() > 0) {
    iCheckMenu = Integer.parseInt(sCheckMenu);
  }

  AppUser appUserInit = new AppUser();
  try {
    appUserInit = userSession.getAppUser();
    userName = appUserInit.getLoginId();
    userOID = appUserInit.getOID();
    userGroup = appUserInit.getGroupUser();
    userFullName = appUserInit.getFullName();
    userLocationId = appUserInit.getAssignLocationId();
    } catch (Exception exc) {
      appUserInit = new AppUser();
    }

  /*        try 
   {
   if (userSession==null) 
   {
   userSession= new SessUserSession();
   AppUser appUser = userSession.getAppUser();
   userSession.doLogin(appUser.getLoginId(), appUser.getPassword());
   if (userSession.isLoggedIn()){
   isLoggedIn = true;
   }
   }
   }
   catch (Exception exc) 
   {
   userSession= new SessUserSession();
   }*/
  /**
   * load System Property
   */
  int periodInterval = 0;
  int periodActivityInterval = 0;
  int lastEntryDuration = 0;
  long currentPeriodOid = 0;
  long currentActivityPeriodOid = 0;
  boolean validCloseBookToday = false;
  boolean validClosePeriodToday = false;
  String isUseDatePicker = "";
  String updateJournal = "";
  String cHeckBoxContact = "";
  String commandBack = "";
  String iconSearchContact = "";
  String compName = "";
  String compAddr = "";
  String compPhone = "";
  String compCity = "";
  String accBankName = "";
  String accBankNo = "";
  String bankName = "";
  double dValueReport = 0;
  int iJournalBaseOn = 0;
  int iFixedAssetsModule = 0;
  String sAccForPettyCash = "";
  long lDefaultSpcJournalDeptId = 0;
  String sAutoReceiveFA = "";
  int iUseJournalDistribution = 0;

  String namaMasterData = "";
  String namaNasabah = "";

  try {
    iFixedAssetsModule = Integer.parseInt(PstSystemProperty.getValueByName("FIXED_ASSETS_ONLY"));
  } catch (Exception e) {
    System.out.println("Exp javainit.jsp :::::::::::::::: " + e.toString());
  }
  try {
    periodInterval = Integer.parseInt(PstSystemProperty.getValueByName("PERIOD_INTERVAL"));
    periodActivityInterval = Integer.parseInt(PstSystemProperty.getValueByName("PERIOD_ACTIVITY_INTERVAL"));
    lastEntryDuration = Integer.parseInt(PstSystemProperty.getValueByName("LAST_ENTRY_DURATION"));
    isUseDatePicker = PstSystemProperty.getValueByName("USE_DATE_PICKER");
    updateJournal = PstSystemProperty.getValueByName("UPDATE_JOURNAL");
    cHeckBoxContact = PstSystemProperty.getValueByName("CHECK_BOX_CONTACT");
    commandBack = PstSystemProperty.getValueByName("COMMAND_BACK");
    iconSearchContact = PstSystemProperty.getValueByName("ICON_SEARCH_CONTACT");
    dValueReport = Double.parseDouble(PstSystemProperty.getValueByName("REPORT_ON"));
    iJournalBaseOn = Integer.parseInt(PstSystemProperty.getValueByName("JOURNAL_BASE_ON"));
    compName = PstSystemProperty.getValueByName("COMPANY_NAME");
    compAddr = PstSystemProperty.getValueByName("COMPANY_ADDRESS");
    compPhone = PstSystemProperty.getValueByName("COMPANY_PHONE");
    compCity = PstSystemProperty.getValueByName("COMPANY_CITY");
    accBankName = PstSystemProperty.getValueByName("ACC_BANK_NAME");
    accBankNo = PstSystemProperty.getValueByName("ACC_BANK_NO");
    bankName = PstSystemProperty.getValueByName("BANK_NAME");
    sAccForPettyCash = PstSystemProperty.getValueByName("ACC_FOR_PETTY_CASH");
    lDefaultSpcJournalDeptId = Long.parseLong(PstSystemProperty.getValueByName("SPECIAL_JOURNAL_DEPT"));
    sAutoReceiveFA = PstSystemProperty.getValueByName("AUTO_REC_FA");
    iUseJournalDistribution = Integer.parseInt(PstSystemProperty.getValueByName("USE_JOURNAL_DISTRIBUTION"));
    namaMasterData = PstSystemProperty.getValueByName("SEDANA_MASTER_NAME");
    namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
  } catch (Exception e) {
  }

// -------------- start adding for IJ ----------------
//String ijroot = "/sedanav3-dsj-2010/ij";
  String ijroot = "/sedana-v3-koperasi/ij";
//int BO_SYSTEM = I_IJGeneral.BO_PROCHAIN_MANUFACTURE;
  int BO_SYSTEM = I_IJGeneral.BO_PROCHAIN_POS;

  Vector vectBOKey = new Vector(1, 1);
  Vector vectBOVal = new Vector(1, 1);
//vectBOKey.add(""+I_IJGeneral.BO_PROCHAIN_MANUFACTURE);
//vectBOVal.add(""+I_IJGeneral.strBoSystem[I_IJGeneral.BO_PROCHAIN_MANUFACTURE]);
  vectBOKey.add("" + I_IJGeneral.BO_PROCHAIN_POS);
  vectBOVal.add("" + I_IJGeneral.strBoSystem[I_IJGeneral.BO_PROCHAIN_POS]);
  vectBOKey.add("" + I_IJGeneral.BO_PROCHAIN_HANOMAN);
  vectBOVal.add("" + I_IJGeneral.strBoSystem[I_IJGeneral.BO_PROCHAIN_HANOMAN]);
// -------------- finish adding for IJ ----------------

  request.setAttribute("appUserInit", appUserInit);
  request.setAttribute("userName", userName);
  request.setAttribute("userOID", userOID);
  request.setAttribute("userGroup", userGroup);
  request.setAttribute("userFullName", userFullName);
  request.setAttribute("app", "SEDANA");

// add by rusdianta for header and footer of reports
  boolean bPdfCompanyTitleUseImg = true;
  String sPdfCompanyTitleImgPath = approot + "/images/company.jpg";
  String sPdfCompanyTitle = "Dimata";
  if (bPdfCompanyTitleUseImg) {
    sPdfCompanyTitle = sPdfCompanyTitleImgPath;
  }

  String sPdfCompanyDetail = "Dimata";

  /*
   * Nilai untuk iPdfHeaderFooterflag:
   * 0 : tidak memakai header dan footer
   * 1 : hanya memakai header
   * 2 : hanya memakai footer
   * 3 : memakai header dan footer
   */
  int iPdfHeaderFooterFlag = 3;

  long processDuration = System.currentTimeMillis() - starttm;
  System.out.println("END JAVAINIT => " + processDuration);

%>
<script>
  var baseUrl = function(uri = "") { return ("<%=request.getProtocol().split("/")[0].toLowerCase()%>://<%=request.getServerName()%>:<%=request.getServerPort()%>/<%=request.getRequestURI().split("/")[1]%>/" + uri); }
</script>

