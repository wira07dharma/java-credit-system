<%@ page import="java.util.*" %>

<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.system.*" %>

<%//@ page import="com.dimata.ij.I_IJGeneral" %>

<%@ page import="com.dimata.common.entity.system.*" %>
<%@ page import="com.dimata.common.session.system.*" %>

<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.session.admin.*" %>
<%@ page import="com.dimata.aiso.session.analysis.SessChartDataSet" %>

<%@ page import="com.dimata.aiso.entity.periode.*" %>   
<%@ page import="com.dimata.aiso.session.periode.*" %>    

<%@ page import="com.dimata.common.entity.custom.DataCustom" %>
<%@ page import="com.dimata.common.entity.custom.PstDataCustom" %>

<%@ page import="com.dimata.aiso.session.system.AppValue" %>

<%
int iInactiveInterval = 60;
try{
	iInactiveInterval = Integer.parseInt(PstSystemProperty.getValueByName("ACTIVE_DURATION"));  
}catch(Exception e){}

try{
 session.setMaxInactiveInterval(iInactiveInterval);
}
catch(Exception exc){
 System.out.println("Error set session interval "+ exc);
}

String approot = "/aiso-divine";
String urlForSessExpired=approot+"/inform.jsp";
String reportroot = "/aiso-divine/servlet/com.dimata.aiso.";
String chartroot = approot+"/servlet/DisplayChart?filename=";
String reportrootimage = "/aiso-divine/images/"; 
String reportrootfooter = "/"+reportroot;

String sSystemDecimalSymbol = ".";
String sUserDecimalSymbol 	= ".";
String sUserDigitGroup 	= ",";
long accountingBookType = 0;

long starttm=System.currentTimeMillis();
System.out.println("START Javainit :   "+starttm);


	try{
		accountingBookType = Long.parseLong(PstSystemProperty.getValueByName("BOOK_TYPE"));
	}catch(Exception e){}

/** 
* user is logging in or not 
*/
boolean isLoggedIn = false;

    String  strInformation = "";
    try{
        strInformation = PstSystemProperty.getValueByName("INFORMATION");
    }catch(Exception e){

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
	{"AISO untuk Perusahaan Anda","Selamat Datang : AISO untuk Perusahaan Anda"},
	{"AISO for Your Company","Welcome to AISO for Your Company"}
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
    "Lain-lain","Others"
};

/** 
* instant of object user session  
*/
SessUserSession userSession = (SessUserSession) session.getValue(SessUserSession.HTTP_SESSION_NAME); 
if (userSession==null) 
	{
        userSession= new SessUserSession();
} else {
     if (userSession.isLoggedIn()){
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
int SESS_LANGUAGE = (strLanguage!=null && strLanguage.length() > 0) ? Integer.parseInt(strLanguage) : langForeign;
int SHORT_ASC = SessChartDataSet.SHORT_ASC;
int SHORT_DESC = SessChartDataSet.SHORT_DESC;
/**
* set format number
*/
String formatNum = "#,###.00";

long userOID = 0;
String userName = "";
String userFullName = "";
int iCheckMenu = 0;
int userGroup = 0;
String sCheckMenu = "";
sCheckMenu = (String)session.getValue("CHECK_MENU");

if(sCheckMenu != null && sCheckMenu.length() > 0){
    iCheckMenu = Integer.parseInt(sCheckMenu);
}

AppUser appUserInit = new AppUser();
try 
{ 
	appUserInit = userSession.getAppUser();
	userName = appUserInit.getLoginId();
	userOID = appUserInit.getOID();
	userGroup = appUserInit.getGroupUser(); 	
	userFullName = appUserInit.getFullName();
}
catch (Exception exc) 
{
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

try{
    iFixedAssetsModule = Integer.parseInt(PstSystemProperty.getValueByName("FIXED_ASSETS_ONLY"));	
}catch(Exception e){System.out.println("Exp javainit.jsp :::::::::::::::: "+e.toString());}
try{
	periodInterval = Integer.parseInt(PstSystemProperty.getValueByName("PERIOD_INTERVAL"));
	periodActivityInterval = Integer.parseInt(PstSystemProperty.getValueByName("PERIOD_ACTIVITY_INTERVAL"));
	lastEntryDuration = Integer.parseInt(PstSystemProperty.getValueByName("LAST_ENTRY_DURATION"));
	currentPeriodOid = PstPeriode.getCurrPeriodId();
	currentActivityPeriodOid = PstActivityPeriod.getCurrPeriodId();
	validClosePeriodToday = SessActvityPeriod.isValidCloseBookTime(new Date(), currentActivityPeriodOid);
	isUseDatePicker = PstSystemProperty.getValueByName("USE_DATE_PICKER");
	updateJournal = PstSystemProperty.getValueByName("UPDATE_JOURNAL");
	cHeckBoxContact = PstSystemProperty.getValueByName("CHECK_BOX_CONTACT");
	commandBack = PstSystemProperty.getValueByName("COMMAND_BACK");
	iconSearchContact = PstSystemProperty.getValueByName("ICON_SEARCH_CONTACT");
	validCloseBookToday = SessPeriode.isValidCloseBookTime(new Date(), currentPeriodOid);
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
}catch(Exception e){}



// -------------- start adding for IJ ----------------
String ijroot = "/aiso-divine/ij";
int BO_SYSTEM = I_IJGeneral.BO_PROCHAIN_MANUFACTURE;


Vector vectBOKey = new Vector(1,1);
Vector vectBOVal = new Vector(1,1);																		
vectBOKey.add(""+I_IJGeneral.BO_PROCHAIN_MANUFACTURE);
vectBOVal.add(""+I_IJGeneral.strBoSystem[I_IJGeneral.BO_PROCHAIN_MANUFACTURE]);
//vectBOKey.add(""+I_IJGeneral.BO_PROCHAIN_POS);
//vectBOVal.add(""+I_IJGeneral.strBoSystem[I_IJGeneral.BO_PROCHAIN_POS]);				
//vectBOKey.add(""+I_IJGeneral.BO_PROCHAIN_HANOMAN);
//vectBOVal.add(""+I_IJGeneral.strBoSystem[I_IJGeneral.BO_PROCHAIN_HANOMAN]);
// -------------- finish adding for IJ ----------------


// add by rusdianta for header and footer of reports
boolean bPdfCompanyTitleUseImg = true;
String sPdfCompanyTitleImgPath = "http://localhost" + approot + "/images/company.jpg";
String sPdfCompanyTitle = "Your Company";
if (bPdfCompanyTitleUseImg)
    sPdfCompanyTitle = sPdfCompanyTitleImgPath;

String sPdfCompanyDetail = "Your Company";

/*
 * Nilai untuk iPdfHeaderFooterflag:
 * 0 : tidak memakai header dan footer
 * 1 : hanya memakai header
 * 2 : hanya memakai footer
 * 3 : memakai header dan footer
 */

int iPdfHeaderFooterFlag = 3;

long processDuration = System.currentTimeMillis()-starttm;
System.out.println("END JAVAINIT => " + processDuration);

%>




