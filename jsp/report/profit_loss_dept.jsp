<%@ page language="java" %>


<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*,
                 com.dimata.util.Formater,
                 com.dimata.util.Command,
                 com.dimata.harisma.entity.masterdata.PstDepartment,
                 com.dimata.harisma.entity.masterdata.Department,
                 com.dimata.aiso.entity.report.Neraca,
                 com.dimata.aiso.session.report.SessWorkSheet,
                 com.dimata.aiso.session.report.SessNeraca,
                 com.dimata.aiso.entity.periode.PstPeriode,
                 com.dimata.aiso.entity.periode.Periode,
                 com.dimata.aiso.entity.masterdata.Perkiraan,
                 com.dimata.interfaces.chartofaccount.I_ChartOfAccountGroup,
                 com.dimata.aiso.entity.masterdata.PstPerkiraan,
                 com.dimata.aiso.entity.report.ProfitLoss,
                 com.dimata.aiso.session.report.SessProfitLoss" %>

<!--import java-->
<%@ page import="java.util.Date" %>

<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%@ include file = "../main/javainit.jsp" %>
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
	{"Periode","Keterangan","Realisasi","Anggaran","Pencapaian","Debet",
     "Kredit","Saldo Akhir","Anda tidak punya hak akses untuk laporan laba(Rugi) !!!",
     "Departemen","Silahkan pilih departemen dulu","TOTAL LABA KOTOR","TOTAL LABA BERSIH OPERASIONAL","TOTAL LABA BERSIH SEBELUM PAJAK"},

	{"Period","Description","Actual","Budget","Achievement","Debet",
     "Credit","Last Balance","You haven't privilege for accessing profit loss report !!!",
     "Department","Please change department first","GROSS MARGIN","GROSS PROFIT", "NET PROFIT BEFORE TAX"}
};

public static String strTitleReportPdf[][] = {
	{"LAPORAN LABA(RUGI)","Periode","Departemen","Satuan Mata Uang"," dalam Rp."},
	{"PROFIT AND LOSS STATEMENT","Period ","Department ","Currency Unit"," in mio IDR"}
};
public static String strHeader[][] = {
	{"PERKIRAAN","Anggaran","Realisasi","Pencapaian Bulan Ini","Pencapaian Tahun Ini","s.d Bulan Ini","Bulan Ini","Rp","%"},
	{"ACCOUNT","Budget","Actual","MTD VAR to Budget","YTD VAR to Budget","Month-to-Date","Year-to-Date","IDR","%"}
};

public static String strTitleContent[][] = {
	{"PENDAPATAN","TOTAL PENDAPATAN","HARGA POKOK PENJUALAN","TOTAL HARGA POKOK PENJUALAN","BIAYA","TOTAL BIAYA","PENDAPATAN(BIAYA) LAIN-LAIN",
	"TOTAL PENDAPATAN(BIAYA) LAIN-LAIN","LABA BERSIH SETELAH PAJAK"},
	{"REVENUE","TOTAL REVENUE","COST OF GOOD SOLD","TOTAL COST OF GOOD SOLD","EXPENSES","TOTAL EXPENSES","OTHER REVENUE(EXPENSES)",
	"TOTAL OTHER REVENUE(EXPENSES)","NET PROFIT AFTER TAX"}
};

public static final String masterTitle[] = {
	"Laporan","Report"
};

public static final String listTitle[] = {
	"Laba(Rugi)","Profit and Loss"
};

private static String formatNumber(double value){
	String strNumber = "";
		try{
				if(value < 0)
					strNumber = "("+Formater.formatNumber((value * -1), "##,###.##")+")";
				else
					strNumber = Formater.formatNumber(value, "##,###.##");
			}catch(Exception e){
				System.out.println("Exception on formatNumber ::: "+e.toString());
			}	
	return strNumber;
}
    
public Vector drawListNeraca(Vector objectClass, int language, FRMHandler frmHandler, double dblValueReport){
	Vector result = new Vector(1,1);
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("100%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");	
	
    ctrlist.addHeader(strHeader[language][0],"30%","2","0");
    ctrlist.addHeader(strHeader[language][1],"10%","0","2");
    ctrlist.addHeader(strHeader[language][5],"10%","0","0");
    ctrlist.addHeader(strHeader[language][6],"10%","0","0");
	ctrlist.addHeader(strHeader[language][2],"10%","0","2");
    ctrlist.addHeader(strHeader[language][5],"10%","0","0");
    ctrlist.addHeader(strHeader[language][6],"10%","0","0");
	ctrlist.addHeader(strHeader[language][3],"10%","0","2");
    ctrlist.addHeader(strHeader[language][7],"10%","0","0");
    ctrlist.addHeader(strHeader[language][8],"5%","0","0");
	ctrlist.addHeader(strHeader[language][4],"10%","0","2");
    ctrlist.addHeader(strHeader[language][7],"10%","0","0");
    ctrlist.addHeader(strHeader[language][8],"5%","0","0"); 

    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();

	// vector of data will used in pdf and xls report
	Vector vectDataToReport = new Vector();
	String strAccName = "";
	String strSpaceParent = "&nbsp;&nbsp;&nbsp;&nbsp;";
	String strSpaceChild = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	
	double totMtdBudget = 0.0;
	double totYtdBudget = 0.0;		
	double totMtdActual = 0.0;
	double totYtdActual = 0.0;
	double totMtdVarValue = 0.0;
	double totMtdVarPersent = 0.0;
	double totYtdVarValue = 0.0;
	double totYtdVarPersent = 0.0;
	
    try {
		Vector rowx = new Vector();
		Vector rowR = new Vector();
        // proses Revenue
        rowx = new Vector();
        rowx.add("<b><font size=\"5\">"+strTitleContent[language][0]+"</font></b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
		rowx.add("");
        rowx.add("");
        rowx.add("");
		rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
		//untuk report
		rowR = new Vector();
		rowR.add("    "+strTitleContent[language][0]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
		rowR.add("");
        rowR.add("");
        rowR.add("");
		rowR.add("");
        rowR.add("");
        vectDataToReport.add(rowR);//Index ke 0
		
		double totMtdBudgetRev = 0.0;
		double totYtdBudgetRev = 0.0;		
        double totMtdActualRev = 0.0;
		double totYtdActualRev = 0.0;
		double totMtdVarValueRev = 0.0;
		double totMtdVarPersentRev = 0.0;
		double totYtdVarValueRev = 0.0;
		double totYtdVarPersentRev = 0.0;
		
        Vector vecRevenue = (Vector)objectClass.get(0);
		Vector vecRevenuePdf = new Vector();
		for (int i = 0; i < vecRevenue.size(); i++) {		
            ProfitLoss objProfitLoss = (ProfitLoss)vecRevenue.get(i);
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = objProfitLoss.getAccountNameEnglish();
				else
				strAccName = objProfitLoss.getNamaPerkiraan();				
           
			if(objProfitLoss.getIdParent() != 0){
				//--------------------------------- proses child ------------------------------------------------------
				rowx = new Vector();
				rowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strAccName);			
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div>");
				lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("        "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecRevenuePdf.add(rowR);//Index ke 1			
			
			}else{
				if(objProfitLoss.getValue() == 0){
				// ------------------------------------- Parent ----------------------------------------------------------
				rowx = new Vector();
				rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;"+objProfitLoss.getAccNumber()+"&nbsp;"+strAccName+"</b>");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				lstData.add(rowx);
				
				rowR = new Vector();
				rowR.add("    "+objProfitLoss.getAccNumber()+" "+strAccName);
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecRevenuePdf.add(rowR);//Index ke 0
				
				}else{
				
					// ------------------------------------------------ Sub Total -------------------------------------------------
					rowx = new Vector();
					rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;Sub Total&nbsp;"+strAccName+"</b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div></b>");
					lstData.add(rowx);
				
					//untuk report
					rowR = new Vector();
					rowR.add("    Sub Total "+strAccName);
					rowR.add(formatNumber((objProfitLoss.getBudget() / dblValueReport)));
					rowR.add(formatNumber((objProfitLoss.getYtdBudget() / dblValueReport)));
					rowR.add(formatNumber((objProfitLoss.getValue() / dblValueReport)));
					rowR.add(formatNumber((objProfitLoss.getYtdValue() / dblValueReport)));
					rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
					rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
					rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
					rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
					vecRevenuePdf.add(rowR);//Index ke 2	
				
					// spasi
					rowx = new Vector();
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					lstData.add(rowx);
					
					// spasi
					rowR = new Vector();
					rowR.add("");
					rowR.add("");
					rowR.add("");
					rowR.add("");
					rowR.add("");
					rowR.add("");
					rowR.add("");
					rowR.add("");
					rowR.add("");
					vecRevenuePdf.add(rowR);
		
				// ----------------------------------------- Count Sub Total Revenue ----------------------------------------------
				totMtdBudgetRev += objProfitLoss.getBudget();
				totYtdBudgetRev += objProfitLoss.getYtdBudget();		
				totMtdActualRev += objProfitLoss.getValue();
				totYtdActualRev += objProfitLoss.getYtdValue();
				totMtdVarValueRev += objProfitLoss.getValue() - objProfitLoss.getBudget();
				if(totMtdBudgetRev != 0)
					totMtdVarPersentRev = (totMtdVarValueRev / totMtdBudgetRev) * 100;
					else
					totMtdVarPersentRev = 0;
					
				totYtdVarValueRev += objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget();
				
				if(totYtdBudgetRev != 0)
					totYtdVarPersentRev = (totYtdVarValueRev / totYtdBudgetRev) * 100;
					else
					totYtdVarPersentRev = 0;
				}
			}
        }
		vectDataToReport.add(vecRevenuePdf);// Index ke 1
					
		// ------------------------------------------ Proses Sub Total Revenue ---------------------------------------------
        rowx = new Vector();
        rowx.add("<b><font size=\"4\">"+strTitleContent[language][1]+"</font></b>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdBudgetRev / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdBudgetRev / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdActualRev / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdActualRev / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarValueRev / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarPersentRev)+" %</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarValueRev / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarPersentRev)+" %</b></div>");
        lstData.add(rowx);
		
		//untuk report
		rowR = new Vector();
		rowR.add("    "+strTitleContent[language][1]);
        rowR.add(formatNumber(totMtdBudgetRev / dblValueReport));
        rowR.add(formatNumber(totYtdBudgetRev / dblValueReport));
		rowR.add(formatNumber(totMtdActualRev / dblValueReport));
		rowR.add(formatNumber(totYtdActualRev / dblValueReport));
		rowR.add(formatNumber(totMtdVarValueRev / dblValueReport));
        rowR.add(formatNumber(totMtdVarPersentRev));
		rowR.add(formatNumber(totYtdVarValueRev / dblValueReport));
		rowR.add(formatNumber(totYtdVarPersentRev));
        vectDataToReport.add(rowR);// Index ke 2
		
        // spasi
        rowx = new Vector();
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
		rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
		lstData.add(rowx);
				
        // proses CoGS
		//Start if CoGS
		Vector vecCoGS = (Vector)objectClass.get(1);
		Vector vecCoGSPdf = new Vector();
		
		double totMtdBudgetCoGS = 0.0;
		double totYtdBudgetCoGS = 0.0;		
        double totMtdActualCoGS = 0.0;
		double totYtdActualCoGS = 0.0;
		double totMtdVarValueCoGS = 0.0;
		double totMtdVarPersentCoGS = 0.0;
		double totYtdVarValueCoGS = 0.0;
		double totYtdVarPersentCoGS = 0.0;
		
		//untuk report
		rowR = new Vector();
		rowR.add("    "+strTitleContent[language][2]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
		rowR.add("");
        rowR.add("");
        rowR.add("");
		rowR.add("");
        rowR.add("");        
        vectDataToReport.add(rowR); // Index ke 3
		
		if(vecCoGS != null && vecCoGS.size() > 0){
        rowx = new Vector();
        rowx.add("<b><font size=\"5\">"+strTitleContent[language][2]+"</font></b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
		rowx.add("");
        rowx.add("");
        rowx.add("");
		rowx.add("");
        rowx.add("");
        lstData.add(rowx);
        
		for (int i = 0; i < vecCoGS.size(); i++) {
            ProfitLoss objProfitLoss = (ProfitLoss)vecCoGS.get(i);	
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = objProfitLoss.getAccountNameEnglish();
				else
				strAccName = objProfitLoss.getNamaPerkiraan();
            
			if(objProfitLoss.getIdParent() != 0){
				rowx = new Vector();
				rowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strAccName);			
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div>");
				lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("        "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecCoGSPdf.add(rowR);			
			
			}else{
				if(objProfitLoss.getValue() == 0){
				rowx = new Vector();
				rowx.add("<b>&nbsp;&nbsp;&nbsp;"+objProfitLoss.getAccNumber()+"&nbsp;"+strAccName+"</b>");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				lstData.add(rowx);
				
				rowR = new Vector();
				rowR.add("    "+objProfitLoss.getAccNumber()+" "+strAccName);
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecCoGSPdf.add(rowR);
				
				}else{
					rowx = new Vector();
					rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;Sub Total&nbsp;"+strAccName+"</b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div></b>");
					lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("    Sub Total"+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecCoGSPdf.add(rowR);
				
				rowR = new Vector();
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecCoGSPdf.add(rowR);
		
				totMtdBudgetCoGS += objProfitLoss.getBudget();
				totYtdBudgetCoGS += objProfitLoss.getYtdBudget();		
				totMtdActualCoGS += objProfitLoss.getValue();
				totYtdActualCoGS += objProfitLoss.getYtdValue();
				totMtdVarValueCoGS += objProfitLoss.getValue() - objProfitLoss.getBudget();
				if(totMtdBudgetCoGS != 0)
					totMtdVarPersentCoGS = (totMtdVarValueCoGS / totMtdBudgetCoGS) * 100;
					else
					totMtdVarPersentCoGS = 0;
					
				totYtdVarValueCoGS += objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget();
				
				if(totYtdBudgetCoGS != 0)
					totYtdVarPersentCoGS = (totMtdVarValueCoGS / totYtdBudgetCoGS) * 100;
					else
					totYtdVarPersentCoGS = 0;
				}
			}
		}
		
		
		rowx = new Vector();
        rowx.add("<b><font size=\"4\">"+strTitleContent[language][3]+"</font></b>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdBudgetCoGS / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdBudgetCoGS / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdActualCoGS / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdActualCoGS / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarValueCoGS / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarPersentCoGS)+" %</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarValueCoGS / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarPersentCoGS)+" %</b></div>");
        lstData.add(rowx);		
		} //End if CoGS
		
		vectDataToReport.add(vecCoGSPdf);// Index ke 4
		
		//untuk report
		rowR = new Vector();
		rowR.add("    "+strSpaceParent+strTitleContent[language][3]);
        rowR.add(formatNumber(totMtdBudgetCoGS / dblValueReport));
        rowR.add(formatNumber(totYtdBudgetCoGS / dblValueReport));
		rowR.add(formatNumber(totMtdActualCoGS / dblValueReport));
		rowR.add(formatNumber(totYtdActualCoGS / dblValueReport));
		rowR.add(formatNumber(totMtdVarValueCoGS / dblValueReport));
        rowR.add(formatNumber(totMtdVarPersentCoGS));
		rowR.add(formatNumber(totYtdVarValueCoGS / dblValueReport));
		rowR.add(formatNumber(totYtdVarPersentCoGS));
        vectDataToReport.add(rowR);// Index ke 5
		
        // proses expenses
        rowx = new Vector();
        rowx.add("<b><font size=\"5\">"+strTitleContent[language][4]+"</font></b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
		rowx.add("");
        rowx.add("");
        rowx.add("");
		rowx.add("");
        rowx.add("");
        lstData.add(rowx);

		//untuk report
		rowR = new Vector();
		rowR.add("    "+strTitleContent[language][4]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
		rowR.add("");
        rowR.add("");
        rowR.add("");
		rowR.add("");
        rowR.add("");        
        vectDataToReport.add(rowR);// Index ke 6
		
        double totMtdBudgetExp = 0.0;
		double totYtdBudgetExp = 0.0;		
        double totMtdActualExp = 0.0;
		double totYtdActualExp = 0.0;
		double totMtdVarValueExp = 0.0;
		double totMtdVarPersentExp = 0.0;
		double totYtdVarValueExp = 0.0;
		double totYtdVarPersentExp = 0.0;
		
        Vector listExpenses = (Vector)objectClass.get(2);
		Vector vecExpensesPdf = new Vector();
		for (int i = 0; i < listExpenses.size(); i++) {
            ProfitLoss objProfitLoss = (ProfitLoss)listExpenses.get(i);
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = objProfitLoss.getAccountNameEnglish();
				else
				strAccName = objProfitLoss.getNamaPerkiraan();
            
			if(objProfitLoss.getIdParent() != 0){
				rowx = new Vector();
				rowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strAccName);			
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div>");
				lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("        "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecExpensesPdf.add(rowR);			
			
			}else{
				if(objProfitLoss.getValue() == 0){
				rowx = new Vector();
				rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;"+objProfitLoss.getAccNumber()+"&nbsp;"+strAccName+"</b>");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				lstData.add(rowx);
				
				rowR = new Vector();
				rowR.add("    "+objProfitLoss.getAccNumber()+" "+strAccName);
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecExpensesPdf.add(rowR);
				
				}else{
					rowx = new Vector();
					rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;Sub Total&nbsp;"+strAccName+"</b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div></b>");
					lstData.add(rowx);
				
					//Spasi
					rowx = new Vector();
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("    Sub Total "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecExpensesPdf.add(rowR);
				
				rowR = new Vector();
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecExpensesPdf.add(rowR);
		
				totMtdBudgetExp += objProfitLoss.getBudget();
				totYtdBudgetExp += objProfitLoss.getYtdBudget();		
				totMtdActualExp += objProfitLoss.getValue();
				totYtdActualExp += objProfitLoss.getYtdValue();
				totMtdVarValueExp += objProfitLoss.getValue() - objProfitLoss.getBudget();
				if(totMtdBudgetExp != 0)
					totMtdVarPersentExp = (totMtdVarValueExp / totMtdBudgetExp) * 100;
					else
					totMtdVarPersentExp = 0;
					
				totYtdVarValueExp += objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget();
				
				if(totMtdBudgetExp != 0)
					totYtdVarPersentExp = (totYtdVarValueExp / totYtdBudgetExp) * 100;
					else
					totYtdVarPersentExp = 0;
				}
			}
		}
		vectDataToReport.add(vecExpensesPdf); // Index ke 7
		
		rowx = new Vector();
        rowx.add("<b><font size=\"4\">"+strTitleContent[language][5]+"</font></b>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdBudgetExp / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdBudgetExp / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdActualExp / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdActualExp / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarValueExp / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarPersentExp)+" %</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarValueExp / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarPersentExp)+" %</b></div>");
        lstData.add(rowx);
		
		//untuk report
		rowR = new Vector();
		rowR.add("    "+strTitleContent[language][5]);
        rowR.add(formatNumber(totMtdBudgetExp / dblValueReport));
        rowR.add(formatNumber(totYtdBudgetExp / dblValueReport));
		rowR.add(formatNumber(totMtdActualExp / dblValueReport));
		rowR.add(formatNumber(totYtdActualExp / dblValueReport));
		rowR.add(formatNumber(totMtdVarValueExp / dblValueReport));
        rowR.add(formatNumber(totMtdVarPersentExp));
		rowR.add(formatNumber(totYtdVarValueExp / dblValueReport));
		rowR.add(formatNumber(totYtdVarPersentExp));
        vectDataToReport.add(rowR); //Index ke 8

         // spasi
        rowx = new Vector();
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
		rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
		lstData.add(rowx);
		

        // proses other revenue
        rowx = new Vector();
        rowx.add("<b><font size=\"3\">"+strTitleContent[language][6]+"</b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
		rowx.add("");
        rowx.add("");
        rowx.add("");
		rowx.add("");
        rowx.add("");
        lstData.add(rowx);

		//untuk report
		rowR = new Vector();
		rowR.add("    "+strTitleContent[language][6]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
		rowR.add("");
        rowR.add("");
        rowR.add("");
		rowR.add("");
        rowR.add("");        
        vectDataToReport.add(rowR); //Index ke 9
		
        double totMtdBudgetOther = 0.0;
		double totYtdBudgetOther = 0.0;		
        double totMtdActualOther = 0.0;
		double totYtdActualOther = 0.0;
		double totMtdVarValueOther = 0.0;
		double totMtdVarPersentOther = 0.0;
		double totYtdVarValueOther = 0.0;
		double totYtdVarPersentOther = 0.0;
		
        Vector listOtherRevenue = (Vector)objectClass.get(3);
		Vector vecOtherRevenuePdf = new Vector();
		for (int i = 0; i < listOtherRevenue.size(); i++) {
            ProfitLoss objProfitLoss = (ProfitLoss)listOtherRevenue.get(i);
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = objProfitLoss.getAccountNameEnglish();
				else
				strAccName = objProfitLoss.getNamaPerkiraan();
            
			if(objProfitLoss.getIdParent() != 0){
				rowx = new Vector();
				rowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strAccName);			
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div>");
				lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("        "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecOtherRevenuePdf.add(rowR);			
			
			}else{
				if(objProfitLoss.getValue() == 0){
				rowx = new Vector();
				rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;"+objProfitLoss.getAccNumber()+"&nbsp;"+strAccName+"</b>");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				lstData.add(rowx);
				
				rowR = new Vector();
				rowR.add("    "+strAccName);
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecOtherRevenuePdf.add(rowR);
				
				}else{
					rowx = new Vector();
					rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;Sub Total&nbsp;"+strAccName+"</b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div></b>");
					lstData.add(rowx);
				
					rowx = new Vector();
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					rowx.add("&nbsp;");
					lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("        "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecOtherRevenuePdf.add(rowR);
				
				rowR = new Vector();
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecOtherRevenuePdf.add(rowR);
		
				totMtdBudgetOther += objProfitLoss.getBudget();
				totYtdBudgetOther += objProfitLoss.getYtdBudget();		
				totMtdActualOther += objProfitLoss.getValue();
				totYtdActualOther += objProfitLoss.getYtdValue();
				totMtdVarValueOther += objProfitLoss.getValue() - objProfitLoss.getBudget();				
				}
			}
		}
		vectDataToReport.add(vecOtherRevenuePdf); //Index ke 10	
		
        Vector listOtherExpenses = (Vector)objectClass.get(4);
		Vector vecOtherExpensesPdf = new Vector();
		for (int i = 0; i < listOtherExpenses.size(); i++) {
            ProfitLoss objProfitLoss = (ProfitLoss)listOtherExpenses.get(i);
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = objProfitLoss.getAccountNameEnglish();
				else
				strAccName = objProfitLoss.getNamaPerkiraan();
            
			if(objProfitLoss.getIdParent() != 0){
				rowx = new Vector();
				rowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strAccName);			
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div>");
				lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("        "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecOtherExpensesPdf.add(rowR);			
			
			}else{
				if(objProfitLoss.getValue() == 0){
				rowx = new Vector();
				rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;"+objProfitLoss.getAccNumber()+"&nbsp;"+strAccName+"</b>");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				lstData.add(rowx);
				
				rowR = new Vector();
				rowR.add("    "+strAccName);
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecOtherExpensesPdf.add(rowR);
				
				}else{
					rowx = new Vector();
					rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;Sub Total&nbsp;"+strAccName+"</b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div></b>");
					lstData.add(rowx);
				
					rowx = new Vector();
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("        "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget())));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecOtherExpensesPdf.add(rowR);
				
				rowR = new Vector();
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecOtherExpensesPdf.add(rowR);
									
				}
			}
		}
		vectDataToReport.add(vecOtherExpensesPdf); // Index ke 11	
		
		Vector listTax = (Vector)objectClass.get(5);
		Vector vecTaxPdf = new Vector();
		for (int i = 0; i < listTax.size(); i++) {
            ProfitLoss objProfitLoss = (ProfitLoss)listTax.get(i);
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = objProfitLoss.getAccountNameEnglish();
				else
				strAccName = objProfitLoss.getNamaPerkiraan();
            
			if(objProfitLoss.getIdParent() != 0){
				rowx = new Vector();
				rowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strAccName);			
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div>");
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
				rowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div>");
				lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("        "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget())));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecTaxPdf.add(rowR);			
			
			}else{
				if(objProfitLoss.getValue() == 0){
				rowx = new Vector();
				rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;"+objProfitLoss.getAccNumber()+"&nbsp;"+strAccName+"</b>");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				rowx.add(" ");
				lstData.add(rowx);
				
				rowR = new Vector();
				rowR.add("    "+strAccName);
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecTaxPdf.add(rowR);
				
				}else{
					rowx = new Vector();
					rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;Sub Total&nbsp;"+strAccName+"</b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+" %</div></b>");
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
					rowx.add("<b><div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+" %</div></b>");
					lstData.add(rowx);
				
					rowx = new Vector();
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					rowx.add(" ");
					lstData.add(rowx);
				
				//untuk report
				rowR = new Vector();
				rowR.add("        "+strAccName);
				rowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
				rowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
				rowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));
				rowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));
				vecTaxPdf.add(rowR);
				
				rowR = new Vector();
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				rowR.add(" ");
				vecTaxPdf.add(rowR);
		
				totMtdBudgetOther -= objProfitLoss.getBudget();
				totYtdBudgetOther -= objProfitLoss.getYtdBudget();		
				totMtdActualOther -= objProfitLoss.getValue();
				totYtdActualOther -= objProfitLoss.getYtdValue();
				totMtdVarValueOther -= objProfitLoss.getValue() - objProfitLoss.getBudget();
				
				if(totMtdBudgetOther != 0)
					totMtdVarPersentOther = (totMtdVarValueOther / totMtdBudgetOther) * 100;
					else
					totMtdVarPersentOther = 0;
					
				totYtdVarValueOther -= objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget();
				
				if(totMtdBudgetExp != 0)
					totYtdVarPersentOther = (totYtdVarValueOther / totYtdBudgetOther) * 100;
					else
					totYtdVarPersentOther = 0;
									
				}
			}
		}
		vectDataToReport.add(vecOtherExpensesPdf); // Index ke 12
		
		rowx = new Vector();
        rowx.add("<b><font size=\"3\">"+strTitleContent[language][7]+"</font></b>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdBudgetOther / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdBudgetOther / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdActualOther / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdActualOther / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarValueOther / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarPersentOther / dblValueReport)+" %</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarValueOther / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarPersentOther / dblValueReport)+" %</b></div>");
        lstData.add(rowx);
		
		//untuk report
		rowR = new Vector();
		rowR.add("    "+strTitleContent[language][7]);
        rowR.add(formatNumber(totMtdBudgetOther / dblValueReport));
        rowR.add(formatNumber(totYtdBudgetOther / dblValueReport));
		rowR.add(formatNumber(totMtdActualOther / dblValueReport));
		rowR.add(formatNumber(totYtdActualOther / dblValueReport));
		rowR.add(formatNumber(totMtdVarValueOther / dblValueReport));
        rowR.add(formatNumber(totMtdVarPersentOther));
		rowR.add(formatNumber(totYtdVarValueOther / dblValueReport));
		rowR.add(formatNumber(totYtdVarPersentOther));
        vectDataToReport.add(rowR);//Index ke 13

         // spasi
        rowx = new Vector();
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
		rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
        rowx.add("&nbsp;");
		lstData.add(rowx);
		
		 totMtdBudget = totMtdBudgetRev - totMtdBudgetCoGS - totMtdBudgetExp + totMtdBudgetOther;
		 totYtdBudget = totYtdBudgetRev - totYtdBudgetCoGS - totYtdBudgetExp + totYtdBudgetOther;		
		 totMtdActual = totMtdActualRev - totMtdActualCoGS - totMtdActualExp + totMtdActualOther;
		 totYtdActual = totYtdActualRev - totYtdActualCoGS - totYtdActualExp + totYtdActualOther;
		 totMtdVarValue = totMtdVarValueRev - totYtdActualCoGS - totMtdVarValueExp + totMtdVarValueOther;
		 
		 if(totMtdBudget != 0)
		 	totMtdVarPersent = (totMtdVarValue / totMtdVarValue) * 100;
			else
			totMtdVarPersent = 0;
			
		 totYtdVarValue = totYtdVarValueRev - totYtdVarValueCoGS - totYtdVarValueExp + totYtdVarValueOther;
		 
		 if(totYtdBudget != 0)
		 	totYtdVarPersent = ( totYtdVarValue / totYtdBudget) * 100;
			else
			totYtdVarPersent = 0;
	
        rowx = new Vector();
        rowx.add("<b><font size=\"4\">"+strTitleContent[language][8]+"</font></b>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdBudget / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdBudget / dblValueReport)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdActual / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdActual / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarValue / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totMtdVarPersent)+" %</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarValue / dblValueReport)+"</b></div>");
		rowx.add("<div align=\"right\"><b>"+formatNumber(totYtdVarPersent)+" %</b></div>");
        lstData.add(rowx);
		
		//untuk report
		rowR = new Vector();
		rowR.add("    "+strTitleContent[language][8]);
        rowR.add(formatNumber(totMtdBudget / dblValueReport));
        rowR.add(formatNumber(totYtdBudget / dblValueReport));
		rowR.add(formatNumber(totMtdActual / dblValueReport));
		rowR.add(formatNumber(totYtdActual / dblValueReport));
		rowR.add(formatNumber(totMtdVarValue / dblValueReport));
        rowR.add(formatNumber(totMtdVarPersent));
		rowR.add(formatNumber(totYtdVarValue / dblValueReport));
		rowR.add(formatNumber(totYtdVarPersent));
        vectDataToReport.add(rowR);//Index ke 14
        
		
		//Perkiraan perk = SessWorkSheet.getNamaSaldoPeriodeBerjalan();
		FLAG_PRINT = 1; 
    } catch(Exception exc) {
		System.out.println("Exception on List ====> "+exc.toString());
	}	
	result.add(ctrlist.drawList());	
	result.add(vectDataToReport);
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
    String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
    Date today = new Date();
	String linkPdf = reportrootfooter+"report.labaRugi.ProfitLossDeptPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String linkXls = reportrootfooter+"report.labaRugi.ProfitLossDeptXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String pathImage = reportrootimage+"company121.jpg";
	FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSymbol); 
	frmHandler.setDigitSeparator(sUserDigitGroup);
	
    Vector list = new Vector();
	String nameperiode = "";
    String namedepartment = "";	
    if(iCommand==Command.LIST)
	    //list = SessProfitLoss.getListPL(periodId,oidDepartment);
        list = SessProfitLoss.getListProfitLoss(periodId,oidDepartment);
		//vectResult = drawListNeraca(list, SESS_LANGUAGE, frmHandler);
	try{
            Periode period = PstPeriode.fetchExc(periodId);
            nameperiode = period.getNama();
			namedepartment = PstDepartment.fetchExc(oidDepartment).getDepartment();
        }catch(Exception e){}
	
	
	// process data on control drawlist
	//Vector vectResult = new Vector()drawListNeraca(list, SESS_LANGUAGE, frmHandler);
	Vector vectResult = new Vector();
	String listData = "";
	Vector vectDataToReport = new Vector();
	if(list != null && list.size() > 0){
		vectResult = drawListNeraca(list, SESS_LANGUAGE, frmHandler, dValueReport);
		listData = String.valueOf(vectResult.get(0));     
	    vectDataToReport = (Vector)vectResult.get(1);
		System.out.println("vectDataToReport.size() ====> "+vectDataToReport.size());	
	}
	
	Vector vecHeader = new Vector(1,1);
	for(int i=0; i < strHeader[SESS_LANGUAGE].length; i++){
		vecHeader.add(strHeader[SESS_LANGUAGE][i]);
	}
	
	Vector vecTitle = new Vector(1,1);
	for(int t=0; t < strTitleReportPdf[SESS_LANGUAGE].length; t++){
		vecTitle.add(strTitleReportPdf[SESS_LANGUAGE][t]);
	}
	
	Vector vecSess = new Vector();
	vecSess.add(nameperiode);// Index 0
	vecSess.add(namedepartment);// Index 1
	vecSess.add(linkPdf);// Index 2
	vecSess.add(linkXls);// Index 3	
	vecSess.add(vectDataToReport);// Index 4
	vecSess.add(vecHeader);// Index 5
	vecSess.add(vecTitle);// Index 6
	vecSess.add(pathImage);// Index 7
	
	if(session.getValue("PROFIT_LOSS")!=null){   
		session.removeValue("PROFIT_LOSS");
	}
	session.putValue("PROFIT_LOSS",vecSess);
	
	System.out.println("list.size() XXX =====> "+list.size());

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
    /*var val = document.frmTrialBalance.DEPARTMENT.value;
    if(val!=0){*/
        document.frmTrialBalance.command.value ="<%=Command.LIST%>";
        document.frmTrialBalance.action = "profit_loss_dept.jsp";
        document.frmTrialBalance.submit();
   /* }else{
        alert('<%=strTitle[SESS_LANGUAGE][10]%>');
        document.frmTrialBalance.DEPARTMENT.focus();
    }*/
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
		var linkPage = "<%=reportroot%>report.labaRugi.ProfitLossPdf";       
		window.open(linkPage);  				
}

function printXLS(){	 
		var linkPage = "<%=reportroot%>report.labaRugi.ProfitLossXls";       
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
              <table width="100%" border="0" height="94">
                <tr>
                  <td><!-- Start Search -->
				  	<table width="100%">
						<tr>
							<td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="23" width="2%">
                    <div align="center">:</div>
                  </td>
                  <td height="23" width="87%">                  <%
                      Vector vtPeriod = PstPeriode.list(0,0,"","");
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
                  for (int deptNum = 0; deptNum < iDeptSize; deptNum++)
                  {
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
                  <td height="23">&nbsp;</td>
                  <td height="23">&nbsp;</td>
                  <td height="23">&nbsp;</td>
                </tr>
                <tr>
                  <td width="11%" height="23">&nbsp;</td>
                  <td height="23" width="2%">
                    <div align="center"><b></b></div>
                  </td>
                  <td height="23" width="87%"></span></a>
                  <input name="btnViewReport" type="button" onClick="javascript:report()" value="<%=strReport%>"></td>
						</tr>
					</table>
				  </td><!-- End Search -->
                </tr>
                <tr>
                  <td colspan="3" height="2">&nbsp;</td>
                </tr>
                <%if(iCommand==Command.LIST){%>
                <tr>
                  <td colspan="3" height="2"><%=listData%></td>
                </tr>
                <tr>
                  <td colspan="3" height="2">&nbsp;</td>
                </tr>
				<%System.out.println("flag : "+FLAG_PRINT);%>
						<%if(FLAG_PRINT == 1){%>
						<tr>
							<td>
								<table width="18%" border="0" cellspacing="1" cellpadding="1">
								<tr>
									<td width="83%" nowrap><b><input name="btnPrint" type="button" onClick="javascript:reportPdf()" value="<%=strCmdPrint[SESS_LANGUAGE]%>"></td>
									<td width="83%" nowrap><input name="btnExportToXls" type="button" onClick="javascript:printXLS()" value="<%=strCmdExport[SESS_LANGUAGE]%>"></td>
								</tr>
							  </table>
							</td>
						</tr>
						<%}%>
               <%}%>
              </table>
			  <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][2]%></i></font></td>
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