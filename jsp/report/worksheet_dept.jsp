<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*,
                 com.dimata.util.Formater,
                 com.dimata.util.Command,
                 com.dimata.aiso.entity.report.WorkSheet,
                 com.dimata.harisma.entity.masterdata.PstDepartment,
                 com.dimata.harisma.entity.masterdata.Department" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>

<!--import java-->
<%@ page import="java.util.Date" %>

<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_TRIAL_BALANCE, AppObjInfo.OBJ_REPORT_TRIAL_BALANCE_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition
if(!privView && !privSubmit){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<%!
int FLAG_PRINT = 0;

public static String strTitle[][] = {
	{"Periode","Nomor","Nama","Anggaran","Saldo Awal","Debet",
     "Kredit","Saldo Akhir","Data tidak ditemukan. Silahkan periksa kembali data",
	 "Departemen","Silahkan pilih departemen dulu","Neraca Periode Lalu","Mutasi","Neraca Saldo",
	 "Laba(Rugi)","Neraca","Perkiraan"},

	{"Period","Code","Name","Budget","Fisrt Balance","Debet",
     "Credit","Last Balance","Data not found. Please check data and try again.",
	 "Department","Please change department first","Last Period Balance Sheet","Movement","Trial Balance",
	 "Profit(Loss)","Balance Sheet","Account"}
};

public static final String masterTitle[] = {
	"Laporan","Report"
};

public static final String listTitle[] = {
	"Neraca Lajur","Work Sheet"
};

public static final String strTitleReportPdf[][] = {
	{"LAPORAN NERACA LAJUR","PERIODE"},
	{"WHORK SHEET","PERIOD"}
};

public static final String strHeaderReportPdf[][] = {
	{"PERKIRAAN","NOMOR","NAMA","ANGGARAN","NERACA AWAL","MUTASI","NERACA SALDO","LABA(RUGI)","NERACA","DEBET","KREDIT"},
	{"ACCOUNT","CODE","NAME","BUDGET","FIRST BALANCE SHEET","MOVEMENT","TRIAL BALANCE","PROFIT(LOSS)","BALANCE SHEET","DEBET","CREDIT"}	
};

public static String formatStringNumber(double dbl, FRMHandler frmHandler){
    if(dbl<0)
        return "("+String.valueOf(frmHandler.userFormatStringDecimal(dbl * -1))+")";
    else
        return String.valueOf(frmHandler.userFormatStringDecimal(dbl));
}
    /** gadnyana
     * untuk menampilkan trial balance
     * @param objectClass
     * @param language
     * @return
     */
public Vector drawListWorkSheet(Vector objectClass, int language, long departmentOid, FRMHandler frmHandler){
	Vector result = new Vector(1,1);
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("100%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");
    ctrlist.addHeader(strTitle[language][16],"8%","0","2");
	ctrlist.addHeader(strTitle[language][1],"8%","0","0");
    ctrlist.addHeader(strTitle[language][2],"20%","0","0");
    ctrlist.addHeader(strTitle[language][3],"8%","2","0");

    // neraca periode lalu
    ctrlist.addHeader(strTitle[language][11],"10%","0","2");
    // mutasi periode terselect
    ctrlist.addHeader(strTitle[language][12],"10%","0","2");
    // mutasi neraca saldo
    ctrlist.addHeader(strTitle[language][13],"10%","0","2");
    // mutasi laba rugi
    ctrlist.addHeader(strTitle[language][14],"10%","0","2");
    // mutasi neraca
    ctrlist.addHeader(strTitle[language][15],"10%","0","2");

    ctrlist.addHeader(strTitle[language][5],"8%","0","0");
    ctrlist.addHeader(strTitle[language][6],"8%","0","0");
    ctrlist.addHeader(strTitle[language][5],"8%","0","0");
    ctrlist.addHeader(strTitle[language][6],"8%","0","0");
    ctrlist.addHeader(strTitle[language][5],"8%","0","0");
    ctrlist.addHeader(strTitle[language][6],"8%","0","0");
    ctrlist.addHeader(strTitle[language][5],"8%","0","0");
    ctrlist.addHeader(strTitle[language][6],"8%","0","0");
    ctrlist.addHeader(strTitle[language][5],"8%","0","0");
    ctrlist.addHeader(strTitle[language][6],"8%","0","0");

    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();

	// vector of data will used in pdf and xls report
	Vector vectDataToReport = new Vector();
	
	int iExistingData = 0; 
    double totAnggaran = 0.0;
    double totDbtNeracaSaldoPeridLalu = 0.0;
    double totKrdNeracaSaldoPeridLalu = 0.0;
    double totDbtMutasi = 0.0;
    double totKrdtMutasi = 0.0;
    double totDbtNeracaSaldo = 0.0;
    double totKrdtNeracaSaldo = 0.0;
    double totDbtLabaRugi = 0.0;
    double totKdrtLabaRugi = 0.0;
    double totDbtNeraca = 0.0;
    double totKrdtNeraca = 0.0;
	String strAccName = "";

    try {
		Vector vecWS = new Vector();
        for (int i = 0; i < objectClass.size(); i++) {
            WorkSheet workSheet = (WorkSheet)objectClass.get(i);
            Vector rowx = new Vector();
			Vector rowR = new Vector();
	
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = workSheet.getAccountNameEnglish();
				else
				strAccName = workSheet.getNamaPerkiraan();

            rowx.add("<div align=\"right\">"+workSheet.getNomorPerkiraan()+"</div>");
            rowx.add(String.valueOf(strAccName));
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getAnggaran(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getDebetNeracaPeriodeLalu(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getKreditNeracaPeriodeLalu(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getDebetMutasi(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getKreditMutasi(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getDebetNeracaSaldo(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getKreditNeracaSaldo(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getDebetLabaRugi(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getKreditLabaRugi(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getDebetNeraca(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(workSheet.getKreditNeraca(), "##,###.##")+"</div>");

            lstData.add(rowx);
			
			//for report
			rowR.add(String.valueOf(workSheet.getNomorPerkiraan()));
            rowR.add(String.valueOf(strAccName));
            rowR.add(Formater.formatNumber(workSheet.getAnggaran(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getDebetNeracaPeriodeLalu(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getKreditNeracaPeriodeLalu(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getDebetMutasi(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getKreditMutasi(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getDebetNeracaSaldo(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getKreditNeracaSaldo(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getDebetLabaRugi(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getKreditLabaRugi(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getDebetNeraca(), "##,###.##"));
            rowR.add(Formater.formatNumber(workSheet.getKreditNeraca(), "##,###.##"));
            vecWS.add(rowR);
			
            // for sub total
            totAnggaran = totAnggaran + workSheet.getAnggaran();
            totDbtNeracaSaldoPeridLalu = totDbtNeracaSaldoPeridLalu + workSheet.getDebetNeracaPeriodeLalu();
            totKrdNeracaSaldoPeridLalu = totKrdNeracaSaldoPeridLalu + workSheet.getKreditNeracaPeriodeLalu();
            totDbtMutasi = totDbtMutasi + workSheet.getDebetMutasi();
            totKrdtMutasi = totKrdtMutasi + workSheet.getKreditMutasi();
            totDbtNeracaSaldo = totDbtNeracaSaldo + workSheet.getDebetNeracaSaldo();
            totKrdtNeracaSaldo = totKrdtNeracaSaldo + workSheet.getKreditNeracaSaldo();
            totDbtLabaRugi = totDbtLabaRugi + workSheet.getDebetLabaRugi();
            totKdrtLabaRugi = totKdrtLabaRugi + workSheet.getKreditLabaRugi();
            totDbtNeraca = totDbtNeraca + workSheet.getDebetNeraca();
            totKrdtNeraca = totKrdtNeraca + workSheet.getKreditNeraca();
        }
		vectDataToReport.add(vecWS);

        Vector rowx = new Vector();
        
        rowx = new Vector();
        rowx.add("");
        rowx.add("<b>SUB TOTAL</b>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totAnggaran, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtNeracaSaldoPeridLalu, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKrdNeracaSaldoPeridLalu, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtMutasi, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKrdtMutasi, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtNeracaSaldo, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKrdtNeracaSaldo, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtLabaRugi, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKdrtLabaRugi, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtNeraca, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKrdtNeraca, "##,###.##")+"</b></div>");
        lstData.add(rowx);
		
		//for report
		Vector rowR = new Vector();
        rowR.add("SUB TOTAL");
        rowR.add(Formater.formatNumber(totAnggaran, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtNeracaSaldoPeridLalu, "##,###.##"));
        rowR.add(Formater.formatNumber(totKrdNeracaSaldoPeridLalu, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtMutasi, "##,###.##"));
        rowR.add(Formater.formatNumber(totKrdtMutasi, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtNeracaSaldo, "##,###.##"));
        rowR.add(Formater.formatNumber(totKrdtNeracaSaldo, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtLabaRugi, "##,###.##"));
        rowR.add(Formater.formatNumber(totKdrtLabaRugi, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtNeraca, "##,###.##"));
        rowR.add(Formater.formatNumber(totKrdtNeraca, "##,###.##"));
        vectDataToReport.add(rowR);

        Perkiraan perk = SessWorkSheet.getNamaSaldoPeriodeBerjalan(departmentOid);
		
		if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = perk.getAccountNameEnglish();
				else
				strAccName = perk.getNama();
					
        rowx = new Vector();
        rowx.add("<div align=\"left\">"+perk.getNoPerkiraan()+"</div>");
        rowx.add("<div align=\"left\">"+strAccName+"</div>");
        rowx.add("<div align=\"right\"><b></b></div>");
        rowx.add("<div align=\"right\"><b></b></div>");
        rowx.add("<div align=\"right\"><b></b></div>");
        rowx.add("<div align=\"right\"><b></b></div>");
        rowx.add("<div align=\"right\"><b></b></div>");
        rowx.add("<div align=\"right\"><b></b></div>");
        rowx.add("<div align=\"right\"><b></b></div>");
		
		//for report
		rowR = new Vector();
        rowR.add(perk.getNoPerkiraan());
        rowR.add(strAccName);
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
       	vectDataToReport.add(rowR);
		
        double hasil = totKdrtLabaRugi - totDbtLabaRugi;
        if(hasil >= 0){
            totDbtLabaRugi = totDbtLabaRugi + hasil;
            totKrdtNeraca = totKrdtNeraca + hasil;

            rowx.add("<div align=\"right\">"+Formater.formatNumber(hasil, "##,###.##")+"</div>");
            rowx.add("<div align=\"right\"><b></b></div>");
            rowx.add("<div align=\"right\"><b></b></div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(hasil, "##,###.##")+"</div>");
			//for report
			rowR = new Vector();
			rowR.add(Formater.formatNumber(hasil, "##,###.##"));
			rowR.add("");
			rowR.add("");
			rowR.add(Formater.formatNumber(hasil, "##,###.##"));
        }else{
            totKdrtLabaRugi = totKdrtLabaRugi + (hasil * -1);
            totDbtNeraca = totDbtNeraca + (hasil * -1);

            rowx.add("<div align=\"right\"><b></b></div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(hasil * -1, "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(hasil * -1, "##,###.##")+"</div>");
            rowx.add("<div align=\"right\"></div>");
			//for report
			rowR = new Vector();
			rowR.add("");
			rowR.add(Formater.formatNumber(hasil * -1, "##,###.##"));
			rowR.add(Formater.formatNumber(hasil * -1, "##,###.##"));
			rowR.add("");
	   }

        lstData.add(rowx);
		vectDataToReport.add(rowR);
     
        rowx = new Vector();
        rowx.add("");
        rowx.add("<b>TOTAL</b>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totAnggaran, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtNeracaSaldoPeridLalu, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKrdNeracaSaldoPeridLalu, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtMutasi, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKrdtMutasi, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtNeracaSaldo, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKrdtNeracaSaldo, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtLabaRugi, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKdrtLabaRugi, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totDbtNeraca, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKrdtNeraca, "##,###.##")+"</b></div>");
        lstData.add(rowx);
		
		//for report
		rowR = new Vector();
        rowR.add("TOTAL");
        rowR.add(Formater.formatNumber(totAnggaran, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtNeracaSaldoPeridLalu, "##,###.##"));
        rowR.add(Formater.formatNumber(totKrdNeracaSaldoPeridLalu, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtMutasi, "##,###.##"));
        rowR.add(Formater.formatNumber(totKrdtMutasi, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtNeracaSaldo, "##,###.##"));
        rowR.add(Formater.formatNumber(totKrdtNeracaSaldo, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtLabaRugi, "##,###.##"));
        rowR.add(Formater.formatNumber(totKdrtLabaRugi, "##,###.##"));
        rowR.add(Formater.formatNumber(totDbtNeraca, "##,###.##"));
        rowR.add(Formater.formatNumber(totKrdtNeraca, "##,###.##"));
        vectDataToReport.add(rowR);
		
		if(totDbtNeracaSaldoPeridLalu != 0 || totKrdNeracaSaldoPeridLalu != 0 || totDbtMutasi != 0 || totKrdtMutasi != 0
			|| totDbtNeracaSaldo != 0 || totKrdtNeracaSaldo != 0 || totDbtLabaRugi != 0 || totDbtNeraca != 0 || totKrdtNeraca != 0)
			
		iExistingData = 1; 
		
		FLAG_PRINT = 1; 

    } catch(Exception exc) {}
    result.add(ctrlist.drawList());				
	result.add(vectDataToReport);
	result.add(""+iExistingData);
    return result;
}

%>

<!-- JSP Block -->
<%

    int iCommand = FRMQueryString.requestCommand(request);
    long periodId = FRMQueryString.requestLong(request,SessWorkSheet.FRM_NAMA_PERIODE);
    long oidDepartment = FRMQueryString.requestLong(request,"DEPARTMENT");
    String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
	String strCmdPrint[] = {"Cetak Laporan", "Print Report"};
	String strCmdExport[] = {"Ekspor ke Excel", "Export To Excel"};
	String strCmdBack[] = {"Kembali ke Pencarian", "Back To Search"};
    String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
    Date today = new Date();
	String linkPdf = reportrootfooter+"report.neracaLajur.WorkSheetDeptPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String linkXls = reportrootfooter+"report.neracaLajur.WorkSheetDeptXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String pathImage = reportrootimage +"company121.jpg";
	String nameperiode = "";
	String namedepartment = "";

	FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSymbol); 
	frmHandler.setDigitSeparator(sUserDigitGroup);
	
    Vector list = new Vector();
    if(iCommand==Command.LIST)
        list = SessWorkSheet.getListWorkSheet(periodId,accountingBookType,oidDepartment);
	try{
            Periode period = PstPeriode.fetchExc(periodId);
            nameperiode = period.getNama();
			namedepartment = PstDepartment.fetchExc(oidDepartment).getDepartment();
    }catch(Exception e){}
	
	// process data on control drawlist
	Vector vectResult = new Vector(1,1);
	String listData = "";
	String sExistData = "";
	int iExistData = 0;
	Vector vectDataToReport = new Vector(1,1);
	if(list != null && list.size() > 0){
		try{
			vectResult = drawListWorkSheet(list, SESS_LANGUAGE,oidDepartment, frmHandler);
			listData = String.valueOf(vectResult.get(0));     
			vectDataToReport = (Vector)vectResult.get(1);
			sExistData = vectResult.get(2).toString();
			iExistData = Integer.parseInt(sExistData);
		}catch(Exception e){
			System.out.println("Exception on listWorkSheet ::::: "+e.toString());
		}
	}
	
	Vector vecTitle = new Vector();
		vecTitle.add(strTitleReportPdf[SESS_LANGUAGE][0]);
		vecTitle.add(strTitleReportPdf[SESS_LANGUAGE][1]);
		
	Vector vecHeader = new Vector();
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][0]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][1]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][2]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][3]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][4]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][5]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][6]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][7]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][8]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][9]);
		vecHeader.add(strHeaderReportPdf[SESS_LANGUAGE][10]);
			
	Vector vecSess = new Vector();
	vecSess.add(nameperiode);
	vecSess.add(namedepartment);
	vecSess.add(linkPdf);
	vecSess.add(linkXls);
	vecSess.add(vectDataToReport);
	vecSess.add(vecTitle);
	vecSess.add(vecHeader);
	vecSess.add(pathImage);
		
	if(session.getValue("WORKSHEET")!=null){   
		session.removeValue("WORKSHEET");
	}
	session.putValue("WORKSHEET",vecSess);

/**
* Declare Commands caption
*/
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">
function report(){
   // var val = document.frmTrialBalance.DEPARTMENT.value;
    //if(val!=0){
        document.frmTrialBalance.command.value ="<%=Command.LIST%>";
        document.frmTrialBalance.action = "worksheet_dept.jsp#down";
        document.frmTrialBalance.submit();
    //}else{
        //alert('<%=strTitle[SESS_LANGUAGE][10]%>');
        //document.frmTrialBalance.DEPARTMENT.focus();
    //}
}
function backToSearch(){
	document.frmTrialBalance.command.value ="<%=Command.BACK%>";
	document.frmTrialBalance.action = "worksheet_dept.jsp#up";
    document.frmTrialBalance.submit();
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

//*****************
function showObjectForMenu(){

}
function reportPdf(){	 
		var linkPage = "<%=reportroot%>report.neracaLajur.WorkSheetDeptPdf";       
		window.open(linkPage);  				
}

function printXLS(){	 
		var linkPage = "<%=reportroot%>report.neracaLajur.WorkSheetDeptXls";       
		window.open(linkPage);  				
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
            <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmTrialBalance" method="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="2">&nbsp;
                  </td>
                </tr>
              </table>
			  <%if(privView && privSubmit){%>
              <table width="100%" height="94" border="0" class="listgenactivity">
			  	<tr>
				<td>
				<table width="100%" border="0" class="listgenvalue">
				<tr><td id="up">&nbsp;</td></tr>
                <tr><!-- Start Search -->
                  <td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="23" width="2%">
                    <div align="center">:</div>
                  </td>
                  <td height="23" width="87%"> <%
				     String sOrderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL]+" DESC";
                      Vector vtPeriod = PstPeriode.list(0,0,"",sOrderBy);
                      Vector vPeriodKey = new Vector(1,1);
                      Vector vPeriodVal = new Vector(1,1);
                      for(int k=0;k<vtPeriod.size();k++){
                        Periode periode = (Periode)vtPeriod.get(k);

                        vPeriodKey.add(""+periode.getOID());
                        vPeriodVal.add(periode.getNama());
                      }
                      out.println(ControlCombo.draw(SessWorkSheet.FRM_NAMA_PERIODE,"",null,""+periodId,vPeriodKey,vPeriodVal,""));
				  %>
                    </td>
                </tr>
                <tr>
                  <td width="11%" height="23"><%//=strTitle[SESS_LANGUAGE][9]%></td>
                  <td height="23" width="2%">
                    <!-- <div align="center">:</div> -->
                  </td>
                  <td height="23" width="87%"><%
                  /*Vector vectDept = new Vector();
                  Vector vUsrCustomDepartment = PstDataCustom.getDataCustom(userOID, "hrdepartment");
                  if(vUsrCustomDepartment!=null && vUsrCustomDepartment.size()>0){
                  int iDataCustomCount = vUsrCustomDepartment.size();
                    for(int i=0; i<iDataCustomCount; i++){
                        DataCustom objDataCustom = (DataCustom) vUsrCustomDepartment.get(i);
                        Department dept = new Department();
                        try{
                            dept = PstDepartment.fetchExc(Long.parseLong(objDataCustom.getDataValue()));
                        }catch(Exception e){
                            System.out.println("Err >> department : "+e.toString());
                        }
                        vectDept.add(dept);
                    }
                  }
                  Vector vectDeptKey = new Vector();
                  Vector vectDeptName = new Vector();
                  vectDeptKey.add("0");
                  vectDeptName.add(strCmbFirstSelection);
                  int iDeptSize = vectDept.size();

                  for (int deptNum = 0; deptNum < iDeptSize; deptNum++){
                      Department dept = (Department) vectDept.get(deptNum);
                      vectDeptKey.add(String.valueOf(dept.getOID()));
                      vectDeptName.add(dept.getDepartment());
                  }
                  String strSelectedDept = String.valueOf(oidDepartment);*/
                %>
                <%//=ControlCombo.draw("DEPARTMENT", "", null, strSelectedDept, vectDeptKey, vectDeptName)%>
                    </td>
                </tr>
                <tr>
                  <td height="23" colspan="3">&nbsp;</td>
                  </tr>
                <tr>
                  <td width="11%" height="23">&nbsp;</td>
                  <td height="23" width="2%">
                    <div align="center"><b></b></div>
                  </td>
                  <td height="23" width="87%"><input type="button" value="<%=strReport%>" onClick="javascript:report()"><!-- <a href="javascript:report()"><span class="command"><%//=strReport%></span></a> --></td>
                </tr><!-- End Search -->
				</table>
				</td>
				</tr>
                <tr>
                  <td colspan="3" height="2">&nbsp;</td>
                </tr>
                <%if(iCommand==Command.LIST && iExistData > 0){%>
				<tr><td id="down"><b><font size="4"><%=listTitle[SESS_LANGUAGE]%>&nbsp;&nbsp;<%=nameperiode%></font></b></td></tr>
				<tr><td><hr color="#00CCFF" size="2"></td></tr>
                <tr>
                  <td colspan="3" height="2"><%=listData%></td>
                </tr>
						<%if(FLAG_PRINT == 1){%>
						<tr>
						  <td><hr color="#00CCFF" size="2"></td>
			    </tr>
						<tr>
							<td>
								<table width="18%" border="0" cellspacing="1" cellpadding="1">
								<tr>
									<td width="83%" nowrap><input type="button" value="<%=strCmdPrint[SESS_LANGUAGE]%>" onClick="javascript:reportPdf()">&nbsp;&nbsp;<input type="button" value="<%=strCmdExport[SESS_LANGUAGE]%>" onClick="javascript:printXLS()">&nbsp;&nbsp;<input type="button" value="<%=strCmdBack[SESS_LANGUAGE]%>" onClick="javascript:backToSearch()"><!-- <b><a href="javascript:reportPdf()" class="command"><%//=strCmdPrint[SESS_LANGUAGE]%></a></b> --></td>
									<!-- <td width="100%" nowrap><b>| <a href="javascript:printXLS()" class="command"><%//=strCmdExport[SESS_LANGUAGE]%></a></b> </td> -->									
								</tr>
							  </table>
							</td>
						</tr>
						<%}%>
              </table>
			  <%}else{%>
			   	<%if(iCommand == Command.LIST){%>
			   	<table width="100%">
					<tr><td class="msgerror"><%=strTitle[SESS_LANGUAGE][8]%></td></tr>
				</table>
				<%}%>
			   <%}%>
			  <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="2" nowrap><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][2]%></i></font></td>
                </tr>
              </table>
			  <%}%>
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