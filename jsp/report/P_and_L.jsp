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
private static int FLAG_PRINT = 0;

public static String strTitle[][] = {
	{"Periode","Keterangan","Realisasi","Anggaran","Pencapaian","Debet",
     "Kredit","Saldo Akhir","Data tidak ditemukan. Silahkan periksa kembali data",
     "Departemen","Silahkan pilih departemen dulu","TOTAL LABA KOTOR","TOTAL LABA BERSIH OPERASIONAL","TOTAL LABA BERSIH SEBELUM PAJAK"},

	{"Period","Description","Actual","Budget","Achievement","Debet",
     "Credit","Last Balance","Data not found. Please check data and try again.",
     "Department","Please change department first","GROSS MARGIN","GROSS PROFIT", "NET PROFIT BEFORE TAX"}
};

public static String strTitleReportPdf[][] = {
	{"LAPORAN LABA(RUGI)","Periode","Departemen","Satuan Mata Uang"," dalam Rp."},
	{"PROFIT AND LOSS STATEMENT","Period ","Department ","Currency Unit"," in IDR Mio"}
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

private static String accNameBaseOnLanguage(Perkiraan objPerkiraan, int language){
	String accName = "";
		try{
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
				accName = objPerkiraan.getAccountNameEnglish();
			}else{
				accName = objPerkiraan.getNama();
			}
		}catch(Exception e){
			accName = "";
			System.out.println("Exception on accNameBaseOnLanguage() ::: "+e.toString());
		}
	return accName;
}

private static String accNameByLanguage(ProfitLoss objProfitLoss, int language){
	String accName = "";
		try{
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
				accName = objProfitLoss.getAccountNameEnglish();
			}else{
				accName = objProfitLoss.getNamaPerkiraan();
			}
		}catch(Exception e){
			accName = "";
			System.out.println("Exception on accNameBaseOnLanguage() ::: "+e.toString());
		}
	return accName;
}

private static Vector listChild(ProfitLoss objProfitLoss, int language, double dblValueReport, double dCurrBudget, 
double dYearBudget, double dCurrActual, double dYearActual, double totCurrBudget,  double totYearBudget, double totCurrActual, 
double totYearActual){	
	Vector vRowx = new Vector(1,1);
	Vector vRowR = new Vector(1,1);
	Vector vResult = new Vector(1,1);
		
	try{
		vRowx = new Vector();
		vRowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+accNameByLanguage(objProfitLoss, language));			
		vRowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getBudget() / dblValueReport)+"</div>");
		vRowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdBudget() / dblValueReport)+"</div>");
		vRowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getValue() / dblValueReport)+"</div>");
		vRowx.add("<div align=\"right\">"+formatNumber(objProfitLoss.getYtdValue() / dblValueReport)+"</div>");
		vRowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport)+"</div>");
		vRowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100))+"</div>");
		vRowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport)+"</div>");			
		vRowx.add("<div align=\"right\">"+formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100))+"</div>");	
		
		vRowR = new Vector();
		vRowR.add("        "+accNameByLanguage(objProfitLoss, language));			
		vRowR.add(formatNumber(objProfitLoss.getBudget() / dblValueReport));
		vRowR.add(formatNumber(objProfitLoss.getYtdBudget() / dblValueReport));
		vRowR.add(formatNumber(objProfitLoss.getValue() / dblValueReport));
		vRowR.add(formatNumber(objProfitLoss.getYtdValue() / dblValueReport));
		vRowR.add(formatNumber((objProfitLoss.getValue() - objProfitLoss.getBudget()) / dblValueReport));
		vRowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getValue() - objProfitLoss.getBudget())/objProfitLoss.getBudget() * 100)));
		vRowR.add(formatNumber((objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget()) / dblValueReport));			
		vRowR.add(formatNumber((objProfitLoss.getBudget() == 0? 0 : (objProfitLoss.getYtdValue() - objProfitLoss.getYtdBudget())/objProfitLoss.getYtdBudget() * 100)));	
		
		dCurrBudget += objProfitLoss.getBudget();
		dYearBudget += objProfitLoss.getYtdBudget();
		dCurrActual += objProfitLoss.getValue();
		dYearActual += objProfitLoss.getYtdValue();
		
		totCurrBudget += objProfitLoss.getBudget();
		totYearBudget += objProfitLoss.getYtdBudget();
		totCurrActual += objProfitLoss.getValue();
		totYearActual += objProfitLoss.getYtdValue();
		
	}catch(Exception e){
		vResult = new Vector(1,1);
		System.out.println("Exception on listDetailPL() ::: "+e.toString());
	}
	vResult.add(vRowx);
	vResult.add(""+dCurrBudget);
	vResult.add(""+dYearBudget);
	vResult.add(""+dCurrActual);
	vResult.add(""+dYearActual);
	vResult.add(""+totCurrBudget);
	vResult.add(""+totYearBudget);
	vResult.add(""+totCurrActual);
	vResult.add(""+totYearActual);
	vResult.add(vRowR);
	return vResult;
}    

private static Vector subTotalChild(Perkiraan objPerkiraan, int language, double dblValueReport, double dCurrBudget, 
double dYearBudget, double dCurrActual, double dYearActual){
	Vector vResult = new Vector(1,1);	
	Vector rowx = new Vector(1,1);
	Vector rowR = new Vector(1,1);	
		try{
			rowx = new Vector();
			rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;Sub Total&nbsp;"+objPerkiraan.getNoPerkiraan()+"&nbsp;"+accNameBaseOnLanguage(objPerkiraan, language)+"</b>");
			rowx.add("<b><div align=\"right\">"+formatNumber(dCurrBudget / dblValueReport)+"</div></b>");
			rowx.add("<b><div align=\"right\">"+formatNumber(dYearBudget / dblValueReport)+"</div></b>");
			rowx.add("<b><div align=\"right\">"+formatNumber(dCurrActual / dblValueReport)+"</div></b>");
			rowx.add("<b><div align=\"right\">"+formatNumber(dYearActual / dblValueReport)+"</div></b>");
			rowx.add("<b><div align=\"right\">"+formatNumber((dCurrActual - dCurrBudget) / dblValueReport)+"</div></b>");
			rowx.add("<b><div align=\"right\">"+formatNumber((dCurrBudget == 0? 0 : (dCurrActual - dCurrBudget) / dCurrBudget * 100))+"</div></b>");
			rowx.add("<b><div align=\"right\">"+formatNumber((dYearActual - dYearBudget) / dblValueReport)+"</div>");			
			rowx.add("<b><div align=\"right\">"+formatNumber((dYearBudget == 0? 0 : (dYearActual - dYearBudget)/dYearBudget * 100))+"</div></b>");
			
			rowR = new Vector();
			rowR.add("    Sub Total "+objPerkiraan.getNoPerkiraan()+" "+accNameBaseOnLanguage(objPerkiraan, language));
			rowR.add(formatNumber(dCurrBudget / dblValueReport));
			rowR.add(formatNumber(dYearBudget / dblValueReport));
			rowR.add(formatNumber(dCurrActual / dblValueReport));
			rowR.add(formatNumber(dYearActual / dblValueReport));
			rowR.add(formatNumber((dCurrActual - dCurrBudget) / dblValueReport));
			rowR.add(formatNumber((dCurrBudget == 0? 0 : (dCurrActual - dCurrBudget) / dCurrBudget * 100)));
			rowR.add(formatNumber((dYearActual - dYearBudget) / dblValueReport));			
			rowR.add(formatNumber((dYearBudget == 0? 0 : (dYearActual - dYearBudget)/dYearBudget * 100)));
			
		}catch(Exception e){
			vResult = new Vector(1,1);
			System.out.println("Exception on subTotalChild() ::: "+e.toString());
		}
	vResult.add(rowx);
	vResult.add(rowR);	
	return vResult;
}

private static Vector subTotalGroup(int language, double totCurrBudget,  double totYearBudget, double totCurrActual, 
double totYearActual, double totGroupCurrBudget,  double totGroupYearBudget, double totGroupCurrActual, double totGroupYearActual, 
double dblValueReport, int index){
	Vector vResult = new Vector(1,1);
	Vector rowx = new Vector(1,1);
	Vector rowR = new Vector(1,1);			
		try{
			rowx = new Vector();
			rowx.add("<b>"+strTitleContent[language][index]+"</b>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totCurrBudget / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totYearBudget / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totCurrActual / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totYearActual / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber((totCurrActual - totCurrBudget) / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totCurrBudget == 0? 0 : ((totCurrActual - totCurrBudget) / totCurrBudget) * 100)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber((totYearActual - totYearBudget) / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totYearBudget == 0? 0 : ((totYearActual - totYearBudget) / totYearBudget) * 100)+"</b></div>");			
			
			rowR = new Vector();
			rowR.add(strTitleContent[language][index]);
			rowR.add(formatNumber(totCurrBudget / dblValueReport));
			rowR.add(formatNumber(totYearBudget / dblValueReport));
			rowR.add(formatNumber(totCurrActual / dblValueReport));
			rowR.add(formatNumber(totYearActual / dblValueReport));
			rowR.add(formatNumber((totCurrActual - totCurrBudget) / dblValueReport));
			rowR.add(formatNumber(totCurrBudget == 0? 0 : ((totCurrActual - totCurrBudget) / totCurrBudget) * 100));
			rowR.add(formatNumber((totYearActual - totYearBudget) / dblValueReport));
			rowR.add(formatNumber(totYearBudget == 0? 0 : ((totYearActual - totYearBudget) / totYearBudget) * 100));
			
			totGroupCurrBudget += totCurrBudget;
			totGroupYearBudget += totYearBudget;
			totGroupCurrActual += totCurrActual;
			totGroupYearActual += totYearActual;
			
		}catch(Exception e){
			vResult = new Vector(1,1);
			System.out.println("Exception on subTotalGroup() ::: "+e.toString());
		}
		
	vResult.add(rowx);
	vResult.add(""+totGroupCurrBudget);
	vResult.add(""+totGroupYearBudget);
	vResult.add(""+totGroupCurrActual);
	vResult.add(""+totGroupYearActual);
	vResult.add(rowR);
		
	return vResult;
}

private static Vector totProfitLoss(int language, double totPLCurrBudget,  double totPLYearBudget, double totPLCurrActual, 
double totPLYearActual, double dblValueReport, int index){
	Vector vResult = new Vector(1,1);
	Vector rowx = new Vector(1,1);
	Vector rowR = new Vector(1,1);		
		try{
			rowx = new Vector();
			rowx.add("<b>"+strTitleContent[language][index]+"</b>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totPLCurrBudget / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totPLYearBudget / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totPLCurrActual / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totPLYearActual / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber((totPLCurrActual - totPLCurrBudget) / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totPLCurrBudget == 0? 0 : ((totPLCurrActual - totPLCurrBudget)/totPLCurrBudget) * 100)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber((totPLYearActual - totPLYearBudget) / dblValueReport)+"</b></div>");
			rowx.add("<div align=\"right\"><b>"+formatNumber(totPLYearBudget == 0? 0 : ((totPLYearActual - totPLYearBudget)/totPLYearBudget) * 100)+"</b></div>");
			
			rowR = new Vector();
			rowR.add(strTitleContent[language][index]);
			rowR.add(formatNumber(totPLCurrBudget / dblValueReport));
			rowR.add(formatNumber(totPLYearBudget / dblValueReport));
			rowR.add(formatNumber(totPLCurrActual / dblValueReport));
			rowR.add(formatNumber(totPLYearActual / dblValueReport));
			rowR.add(formatNumber((totPLCurrActual - totPLCurrBudget) / dblValueReport));
			rowR.add(formatNumber(totPLCurrBudget == 0? 0 : ((totPLCurrActual - totPLCurrBudget)/totPLCurrBudget) * 100));
			rowR.add(formatNumber((totPLYearActual - totPLYearBudget) / dblValueReport));
			rowR.add(formatNumber(totPLYearBudget == 0? 0 : ((totPLYearActual - totPLYearBudget)/totPLYearBudget) * 100));
        	
		}catch(Exception e){
			vResult = new Vector(1,1);
			System.out.println("Exception on totProfitLoss() ::: "+e.toString());
		}
	vResult.add(rowx);
	vResult.add(rowR);		
	return vResult;
}

private static Vector listTitleContent(int language, int index){
	Vector vResult = new Vector(1,1);
	Vector rowx = new Vector(1,1);
	Vector rowR = new Vector(1,1);
		try{
			rowx = new Vector();
			rowx.add("<b>"+strTitleContent[language][index]+"</b>");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			
			rowR = new Vector();
			rowR.add(strTitleContent[language][index]);
			rowR.add("");
			rowR.add("");
			rowR.add("");
			rowR.add("");
			rowR.add("");
			rowR.add("");
			rowR.add("");
			rowR.add("");			
						
		}catch(Exception e){
			vResult = new Vector(1,1);
			System.out.println("Exception on listTitleContent() ::: "+e.toString());
		}
	vResult.add(rowx);	
	vResult.add(rowR);
	return vResult;
}

private static Vector listParent(Perkiraan objPerkiraan, int language){
	Vector vResult = new Vector(1,1);
	Vector rowx = new Vector(1,1);
	Vector rowR = new Vector(1,1);
	try{
		rowx = new Vector();
		rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;"+objPerkiraan.getNoPerkiraan()+"&nbsp;"+accNameBaseOnLanguage(objPerkiraan, language)+"</b>");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		
		rowR = new Vector();
		rowR.add(objPerkiraan.getNoPerkiraan()+" "+accNameBaseOnLanguage(objPerkiraan, language));
		rowR.add("");
		rowR.add("");
		rowR.add("");
		rowR.add("");
		rowR.add("");
		rowR.add("");
		rowR.add("");
		rowR.add("");		
					
	}catch(Exception e){
		vResult = new Vector(1,1);
		System.out.println("Exception on listParent() ::: "+e.toString());
	}
	vResult.add(rowx);
	vResult.add(rowR);
	return vResult;
}

private static Vector space(){
	Vector vResult = new Vector(1,1);
	Vector rowx = new Vector(1,1);
	Vector rowR = new Vector(1,1);
		try{
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
			
			rowR = new Vector();
			rowR.add("&nbsp;");
			rowR.add("&nbsp;");
			rowR.add("&nbsp;");
			rowR.add("&nbsp;");
			rowR.add("&nbsp;");
			rowR.add("&nbsp;");
			rowR.add("&nbsp;");
			rowR.add("&nbsp;");
			rowR.add("&nbsp;");
			
		}catch(Exception e){
			vResult = new Vector(1,1);
			System.out.println("Exception on listTitleContent() ::: "+e.toString());
		}
	vResult.add(rowx);	
	vResult.add(rowR);	
	return vResult;
}

private static Vector listDetail(Vector vData, int language, double dblValueReport, double dCurrBgt, double dYearBgt,
double dCurrAct, double dYearAct){
	Vector vResult = new Vector(1,1);
	Vector listData = new Vector(1,1);
	Vector dataToReport = new Vector(1,1);
	double dCurrBudget = 0.0;
	double dYearBudget = 0.0;
	double dCurrActual = 0.0;
	double dYearActual = 0.0;
	double totCurrBudget = 0.0;  
	double totYearBudget = 0.0;
	double totCurrActual = 0.0;
	double totYearActual = 0.0;
	Vector rowx = new Vector();
	Vector rowR = new Vector();
	long oidOldParent = 0;
	Perkiraan oldObjParentPerkiraan = new Perkiraan();
	Perkiraan objParentPerkiraan = new Perkiraan();
	
	ProfitLoss objOldProfitLoss = new ProfitLoss();
		if(vData != null && vData.size() > 0){
			try{
				for(int i = 0; i < vData.size(); i++){
					ProfitLoss objProfitLoss = (ProfitLoss)vData.get(i);
					long idParent = objProfitLoss.getIdParent();
					try{
						objParentPerkiraan = PstPerkiraan.fetchExc(idParent);
					}catch(Exception e){
						objParentPerkiraan = new Perkiraan();
						System.out.println("Exception on fetch objParentPerkiraan ::: "+e.toString());
					}
					if(i > 0){
						objOldProfitLoss = (ProfitLoss)vData.get(i - 1);
						oidOldParent = objOldProfitLoss.getIdParent();
						
						if(idParent != oidOldParent){
							try{
								oldObjParentPerkiraan = PstPerkiraan.fetchExc(oidOldParent);
							}catch(Exception e){
								oldObjParentPerkiraan = new Perkiraan();
								System.out.println("Exception on fetch oldObjParentPerkiraan ::: "+e.toString());
							}
							
							Vector subTotalChild = (Vector)subTotalChild(oldObjParentPerkiraan, language, dblValueReport, dCurrBudget, 
													dYearBudget, dCurrActual, dYearActual);
							if(subTotalChild != null && subTotalChild.size() > 0){
								rowx = (Vector)subTotalChild.get(0);
								listData.add(rowx);
								
								rowR = (Vector)subTotalChild.get(1);
								dataToReport.add(rowR);
							}
							
							dCurrBudget = 0.0;
							dYearBudget = 0.0;
							dCurrActual = 0.0;
							dYearActual = 0.0;
								
							Vector vParent = (Vector)listParent(objParentPerkiraan, language);
							if(vParent != null && vParent.size() > 0){
								rowx = (Vector)vParent.get(0);
								listData.add(rowx);
								
								rowR = (Vector)vParent.get(1);
								dataToReport.add(rowR);	
							}
							
							
							Vector vChild = (Vector)listChild(objProfitLoss, language, dblValueReport, dCurrBudget, dYearBudget, 
											dCurrActual, dYearActual, totCurrBudget,  totYearBudget, totCurrActual,totYearActual);
							
							if(vChild != null && vChild.size() > 0){
								rowx = (Vector)vChild.get(0);
								listData.add(rowx);
								dCurrBudget = Double.parseDouble(vChild.get(1).toString());
								dYearBudget = Double.parseDouble(vChild.get(2).toString());
								dCurrActual = Double.parseDouble(vChild.get(3).toString());
								dYearActual = Double.parseDouble(vChild.get(4).toString());
								totCurrBudget = Double.parseDouble(vChild.get(5).toString());  
								totYearBudget = Double.parseDouble(vChild.get(6).toString());
								totCurrActual = Double.parseDouble(vChild.get(7).toString());
								totYearActual = Double.parseDouble(vChild.get(8).toString());
								rowR = (Vector)vChild.get(9);
								dataToReport.add(rowR);						
							}
														
						}else{
							Vector vChild = (Vector)listChild(objProfitLoss, language, dblValueReport, dCurrBudget, dYearBudget, 
											dCurrActual, dYearActual, totCurrBudget,  totYearBudget, totCurrActual,totYearActual);
							
							if(vChild != null && vChild.size() > 0){
								rowx = (Vector)vChild.get(0);
								listData.add(rowx);
								dCurrBudget = Double.parseDouble(vChild.get(1).toString());
								dYearBudget = Double.parseDouble(vChild.get(2).toString());
								dCurrActual = Double.parseDouble(vChild.get(3).toString());
								dYearActual = Double.parseDouble(vChild.get(4).toString());
								totCurrBudget = Double.parseDouble(vChild.get(5).toString());  
								totYearBudget = Double.parseDouble(vChild.get(6).toString());
								totCurrActual = Double.parseDouble(vChild.get(7).toString());
								totYearActual = Double.parseDouble(vChild.get(8).toString());
								rowR = (Vector)vChild.get(9);
								dataToReport.add(rowR);							
							}
						}
						
						if(i == (vData.size() - 1)){
							Vector subTotalChild = (Vector)subTotalChild(objParentPerkiraan, language, dblValueReport, dCurrBudget, 
													dYearBudget, dCurrActual, dYearActual);
							if(subTotalChild != null && subTotalChild.size() > 0){
								rowx = (Vector)subTotalChild.get(0);
								listData.add(rowx);
								
								rowR = (Vector)subTotalChild.get(1);
								dataToReport.add(rowR);	
							}
						}			
					}else{					
						Vector vParent = (Vector)listParent(objParentPerkiraan, language);
						if(vParent != null && vParent.size() > 0){
							rowx = (Vector)vParent.get(0);
							listData.add(rowx);
							
							rowR = (Vector)vParent.get(1);
							dataToReport.add(rowR);	
						}
						
						
							
						if(vData.size() == 1){
										Vector vChild = (Vector)listChild(objProfitLoss, language, dblValueReport, dCurrBudget, dYearBudget, 
														dCurrActual, dYearActual, totCurrBudget,  totYearBudget, totCurrActual,totYearActual);
										
										if(vChild != null && vChild.size() > 0){
											rowx = (Vector)vChild.get(0);
											listData.add(rowx);
											dCurrBudget = Double.parseDouble(vChild.get(1).toString());
											dYearBudget = Double.parseDouble(vChild.get(2).toString());
											dCurrActual = Double.parseDouble(vChild.get(3).toString());
											dYearActual = Double.parseDouble(vChild.get(4).toString());
											totCurrBudget = Double.parseDouble(vChild.get(5).toString());  
											totYearBudget = Double.parseDouble(vChild.get(6).toString());
											totCurrActual = Double.parseDouble(vChild.get(7).toString());
											totYearActual = Double.parseDouble(vChild.get(8).toString());
											
											rowR = (Vector)vChild.get(9);
											dataToReport.add(rowR);								
										}
							
									Vector subTotalChild = (Vector)subTotalChild(objParentPerkiraan, language, dblValueReport, dCurrBudget, 
															dYearBudget, dCurrActual, dYearActual);
									if(subTotalChild != null && subTotalChild.size() > 0){
										rowx = (Vector)subTotalChild.get(0);
										listData.add(rowx);
										
										rowR = (Vector)subTotalChild.get(1);
										dataToReport.add(rowR);		
									}
						}else{
							Vector vChildFirstIndex = (Vector)listChild(objProfitLoss, language, dblValueReport, dCurrBudget, dYearBudget, 
											dCurrActual, dYearActual, totCurrBudget,  totYearBudget, totCurrActual,totYearActual);
							
							if(vChildFirstIndex != null && vChildFirstIndex.size() > 0){
								rowx = (Vector)vChildFirstIndex.get(0);
								listData.add(rowx);
								dCurrBudget = Double.parseDouble(vChildFirstIndex.get(1).toString());
								dYearBudget = Double.parseDouble(vChildFirstIndex.get(2).toString());
								dCurrActual = Double.parseDouble(vChildFirstIndex.get(3).toString());
								dYearActual = Double.parseDouble(vChildFirstIndex.get(4).toString());
								totCurrBudget = Double.parseDouble(vChildFirstIndex.get(5).toString());  
								totYearBudget = Double.parseDouble(vChildFirstIndex.get(6).toString());
								totCurrActual = Double.parseDouble(vChildFirstIndex.get(7).toString());
								totYearActual = Double.parseDouble(vChildFirstIndex.get(8).toString());	
								
								rowR = (Vector)vChildFirstIndex.get(9);
								dataToReport.add(rowR);						
							}
						}						
					}
					
				}
			}catch(Exception e){
				vResult = new Vector(1,1);
				System.out.println("Exception on listDetail() ::: "+e.toString());
			}
		}
	vResult.add(listData);
	vResult.add(""+totCurrBudget);
	vResult.add(""+totYearBudget);
	vResult.add(""+totCurrActual);
	vResult.add(""+totYearActual);
	vResult.add(dataToReport);		
	return vResult;
}

public static Vector listProfitLoss(Vector objClass, int language, double dblValueReport){
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
	int iExistingData = 0; 
	
	// For pdf and xls report
	Vector vectDataToReport = new Vector();
	
	double totMtdBudget = 0.0;
	double totYtdBudget = 0.0;		
	double totMtdActual = 0.0;
	double totYtdActual = 0.0;
	double totMtdVarValue = 0.0;
	double totMtdVarPersent = 0.0;
	double totYtdVarValue = 0.0;
	double totYtdVarPersent = 0.0;
	
	double totGroupCurrBudget = 0.0;
	double totGroupYearBudget = 0.0;
	double totGroupCurrActual = 0.0; 
	double totGroupYearActual = 0.0;
	
	Vector rowx = new Vector();
	Vector rowR = new Vector();
	
	try{
		if(objClass != null && objClass.size() > 0){			
			Vector vRevenue = (Vector)objClass.get(0);
			double totMtdRevBudget = 0.0;
			double totYtdRevBudget = 0.0;
			double totMtdRevActual = 0.0;
			double totYtdRevActual = 0.0;
			
			Vector vRow = (Vector)listTitleContent(language, 0);
			rowx = (Vector)vRow.get(0);
			rowR = (Vector)vRow.get(1);					
			vectDataToReport.add(rowR);// Index ke 0
			Vector vDTRRev = new Vector(1,1);
			Vector subTotalRevenue = new Vector(1,1);
			if(vRevenue != null && vRevenue.size() > 0){
				lstData.add(rowx);
				try{
					Vector detRevenue = (Vector)listDetail(vRevenue, language, dblValueReport, totMtdBudget, totYtdBudget,totMtdActual,totYtdActual);
					
					if(detRevenue!= null && detRevenue.size() > 0){
						Vector tempListDetail = (Vector)detRevenue.get(0);
						for(int a = 0; a < tempListDetail.size(); a++){
							rowx = (Vector)tempListDetail.get(a);
							lstData.add(rowx);
						}				
						totMtdBudget = Double.parseDouble(detRevenue.get(1).toString());
						totYtdBudget = Double.parseDouble(detRevenue.get(2).toString());
						totMtdActual = Double.parseDouble(detRevenue.get(3).toString());
						totYtdActual = Double.parseDouble(detRevenue.get(4).toString());
						Vector tempListDetRpt = (Vector)detRevenue.get(5);
						for(int z = 0; z < tempListDetRpt.size(); z++){
							rowR = (Vector)tempListDetRpt.get(z);
							vDTRRev.add(rowR);
						}		
					}
					
					subTotalRevenue = (Vector)subTotalGroup(language, totMtdBudget,  totYtdBudget, totMtdActual, 
											totYtdActual, totGroupCurrBudget, totGroupYearBudget, totGroupCurrActual, totGroupYearActual, 
											dblValueReport, 1);		
					if(subTotalRevenue != null && subTotalRevenue.size() > 0){
						rowx = (Vector)subTotalRevenue.get(0);
						lstData.add(rowx);
						totMtdRevBudget = Double.parseDouble(subTotalRevenue.get(1).toString());
						totYtdRevBudget = Double.parseDouble(subTotalRevenue.get(2).toString());
						totMtdRevActual = Double.parseDouble(subTotalRevenue.get(3).toString());
						totYtdRevActual = Double.parseDouble(subTotalRevenue.get(4).toString());
						rowR = (Vector)subTotalRevenue.get(5);
					}
				}catch(Exception e){
					System.out.println("Exception on drawListRevenue ::: "+e.toString());
				}
			}//-------------
			vectDataToReport.add(vDTRRev); // Index ke 1
			vectDataToReport.add(rowR); // Index ke 2
			
			//---------------------------------------- CoGS --------------------------------------------------------
			Vector vTempSpaceCoGS = (Vector)space();
			rowR = (Vector)vTempSpaceCoGS.get(1);
			//vectDataToReport.add(rowR); // Index ke 
				
			Vector vCoGS = (Vector)objClass.get(1);
			double totMtdCoGSBudget = 0.0;
			double totYtdCoGSBudget = 0.0;
			double totMtdCoGSActual = 0.0;
			double totYtdCoGSActual = 0.0;
			
			Vector vDRTCogs = new Vector(1,1);	
			Vector vRowCogs = (Vector)listTitleContent(language, 2);						   
				   rowR = (Vector)vRowCogs.get(1);
			vectDataToReport.add(rowR); // Index ke 3	   
			if(vCoGS != null && vCoGS.size() > 0){
				rowx = (Vector)vTempSpaceCoGS.get(0);
				lstData.add(rowx);
				totMtdBudget = 0.0;
				totYtdBudget = 0.0;		
				totMtdActual = 0.0;
				totYtdActual = 0.0;
				try{
					rowx = (Vector)vRowCogs.get(0);
					lstData.add(rowx);
					Vector detCoGS = (Vector)listDetail(vCoGS, language, dblValueReport, totMtdBudget, totYtdBudget,totMtdActual,totYtdActual);
					Vector tempRow = (Vector)detCoGS.get(0);
					if(detCoGS!= null && detCoGS.size() > 0){
						for(int b = 0; b < tempRow.size(); b++){
							rowx = (Vector)tempRow.get(b);
							lstData.add(rowx);
						}
						totMtdBudget = Double.parseDouble(detCoGS.get(1).toString());
						totYtdBudget = Double.parseDouble(detCoGS.get(2).toString());
						totMtdActual = Double.parseDouble(detCoGS.get(3).toString());
						totYtdActual = Double.parseDouble(detCoGS.get(4).toString());
						Vector tempListDetRpt = (Vector)detCoGS.get(5);
						for(int y = 0; y < tempListDetRpt.size(); y++){
							rowR = (Vector)tempListDetRpt.get(y);
							vDRTCogs.add(rowR);
						}
					}
					
					
					Vector subTotalCoGS = (Vector)subTotalGroup(language, totMtdBudget,  totYtdBudget, totMtdActual, 
											totYtdActual, totGroupCurrBudget, totGroupYearBudget, totGroupCurrActual, totGroupYearActual, 
											dblValueReport, 3);
					if(subTotalCoGS != null && subTotalCoGS.size() > 0){
						rowx = (Vector)subTotalCoGS.get(0);
						lstData.add(rowx);
						
						totYtdCoGSBudget = Double.parseDouble(subTotalCoGS.get(1).toString());
						totYtdRevBudget = Double.parseDouble(subTotalCoGS.get(2).toString());
						totMtdCoGSActual = Double.parseDouble(subTotalCoGS.get(3).toString());
						totYtdCoGSActual = Double.parseDouble(subTotalCoGS.get(4).toString());
						rowR = (Vector)subTotalCoGS.get(5);
					}
				}catch(Exception e){
					System.out.println("Exception on drawCoGS ::: "+e.toString());
				}
			}//-------------
			vectDataToReport.add(vDRTCogs); // Index ke 4
			vectDataToReport.add(rowR); // Index ke 5
			// ------------------------------------------------ Expenses --------------------------------------------------
			Vector vExp = (Vector)objClass.get(2);
			double totMtdExpBudget = 0.0;
			double totYtdExpBudget = 0.0;
			double totMtdExpActual = 0.0;
			double totYtdExpActual = 0.0;
			
			Vector vTempSpaceExp = (Vector)space();				
				rowR = (Vector)vTempSpaceExp.get(1);
			//vectDataToReport.add(rowR); // Index ke 
			Vector vRowExp = (Vector)listTitleContent(language, 4);
			rowR = (Vector)vRowExp.get(1);
			vectDataToReport.add(rowR); // Index ke 6
			Vector vDTRExp = new Vector(1,1);
				
			if(vExp != null && vExp.size() > 0){
				rowx = (Vector)vTempSpaceExp.get(0);
				lstData.add(rowx);
			
				totMtdBudget = 0.0;
				totYtdBudget = 0.0;		
				totMtdActual = 0.0;
				totYtdActual = 0.0;
				try{
					rowx = (Vector)vRowExp.get(0);
					lstData.add(rowx);
					Vector detExp = (Vector)listDetail(vExp, language, dblValueReport, totMtdBudget, totYtdBudget,totMtdActual,totYtdActual);
					Vector tempRow = (Vector)detExp.get(0);
					if(detExp != null && detExp.size() > 0){
						for(int c = 0; c < tempRow.size(); c++){
							rowx = (Vector)tempRow.get(c);
							lstData.add(rowx);
						}
						totMtdBudget = Double.parseDouble(detExp.get(1).toString());
						totYtdBudget = Double.parseDouble(detExp.get(2).toString());
						totMtdActual = Double.parseDouble(detExp.get(3).toString());
						totYtdActual = Double.parseDouble(detExp.get(4).toString());
						Vector tempListDetRpt = (Vector)detExp.get(5);
						for(int x = 0; x < tempListDetRpt.size(); x++){
							rowR = (Vector)tempListDetRpt.get(x);
							vDTRExp.add(rowR);
						}
					}
					Vector subTotalExp = (Vector)subTotalGroup(language, totMtdBudget,  totYtdBudget, totMtdActual, 
											totYtdActual, totGroupCurrBudget, totGroupYearBudget, totGroupCurrActual, totGroupYearActual, 
											dblValueReport, 5);
					if(subTotalExp != null && subTotalExp.size() > 0){
						rowx = (Vector)subTotalExp.get(0);
						lstData.add(rowx);
						totMtdExpBudget = Double.parseDouble(subTotalExp.get(1).toString());
						totYtdExpBudget = Double.parseDouble(subTotalExp.get(2).toString());
						totMtdExpActual = Double.parseDouble(subTotalExp.get(3).toString());
						totYtdExpActual = Double.parseDouble(subTotalExp.get(4).toString());
						rowR = (Vector)subTotalExp.get(5);
					}
				}catch(Exception e){
					System.out.println("Exception on drawExpenses ::: "+e.toString());
				}
			}//-------------
			
			vectDataToReport.add(vDTRExp); // Index ke 7
			vectDataToReport.add(rowR); // Index ke 8
			//-------------------------------------------------- Other Income (Expenses) -----------------------------------------
			Vector vOthIncome = (Vector)objClass.get(3);
			Vector vOthExpenses = (Vector)objClass.get(4);
			Vector vTax = (Vector)objClass.get(5);
			Vector vDTROR = new Vector();
			Vector vDTROE = new Vector();
			Vector vDTRTax = new Vector();
			Vector vTempSpaceOther = (Vector)space();
				rowR = (Vector)vTempSpaceOther.get(1);
				//vectDataToReport.add(rowR); // Index ke 
			Vector vRowOth = (Vector)listTitleContent(language, 6);
				rowR = (Vector)vRowOth.get(1);
				vectDataToReport.add(rowR); // Index ke 9
				
				
			double totMtdOthBudget = 0.0;
			double totYtdOthBudget = 0.0;
			double totMtdOthActual = 0.0;
			double totYtdOthActual = 0.0;
			
			double dPLMtdBudget = 0.0;
			double dPLYtdBudget = 0.0;
			double dPLMtdActual = 0.0;
			double dPLYtdActual = 0.0;
			
			if((vOthIncome != null && vOthIncome.size() > 0) || (vOthExpenses != null && vOthExpenses.size() > 0) || (vTax != null && vTax.size() > 0)){
				
				rowx = (Vector)vTempSpaceOther.get(0);
				lstData.add(rowx);
				
				rowx = (Vector)vRowOth.get(0);
				lstData.add(rowx);
				try{
					totMtdBudget = 0.0;
					totYtdBudget = 0.0;		
					totMtdActual = 0.0;
					totYtdActual = 0.0;
									
					Vector detOthRev = (Vector)listDetail(vOthIncome, language, dblValueReport, totMtdBudget, totYtdBudget,totMtdActual,totYtdActual);
					Vector vTempRowOR = (Vector)detOthRev.get(0);
					if(detOthRev != null && detOthRev.size() > 0){
						for(int d = 0; d < vTempRowOR.size(); d++){
							rowx = (Vector)vTempRowOR.get(d);
							lstData.add(rowx);
						}
					}	
						totMtdBudget = Double.parseDouble(detOthRev.get(1).toString());
						totYtdBudget = Double.parseDouble(detOthRev.get(2).toString());
						totMtdActual = Double.parseDouble(detOthRev.get(3).toString());
						totYtdActual = Double.parseDouble(detOthRev.get(4).toString()); 
						Vector tempListDetRptOR = (Vector)detOthRev.get(5);
						if(tempListDetRptOR != null && tempListDetRptOR.size() > 0){
							for(int w = 0; w < tempListDetRptOR.size(); w++){
								rowR = (Vector)tempListDetRptOR.get(w);
								vDTROR.add(rowR);
							}
						}
					
					double totMtdOthRevBudget = totMtdBudget;
					double totYtdOthRevBudget = totYtdBudget;
					double totMtdOthRevActual = totMtdActual;
					double totYtdOthRevActual = totYtdActual;
					
					totMtdBudget = 0.0;
					totYtdBudget = 0.0;		
					totMtdActual = 0.0;
					totYtdActual = 0.0;
									
					Vector detOthExp = (Vector)listDetail(vOthExpenses, language, dblValueReport, totMtdBudget, totYtdBudget,totMtdActual,totYtdActual);
					
					Vector vTempRowOE = (Vector)detOthExp.get(0);
					if(detOthExp != null && detOthExp.size() > 0){
						for(int e = 0; e < vTempRowOE.size(); e++){							
							rowx = (Vector)vTempRowOE.get(e);
							lstData.add(rowx);
						}
					}	
						totMtdBudget = Double.parseDouble(detOthExp.get(1).toString());
						totYtdBudget = Double.parseDouble(detOthExp.get(2).toString());
						totMtdActual = Double.parseDouble(detOthExp.get(3).toString());
						totYtdActual = Double.parseDouble(detOthExp.get(4).toString());
						Vector tempListDetRptOE = (Vector)detOthExp.get(5);
						System.out.println("tempListDetRptOE.size() :::: "+tempListDetRptOE.size());
						if(tempListDetRptOE != null && tempListDetRptOE.size() > 0){
							for(int v = 0; v < tempListDetRptOE.size(); v++){
								rowR = (Vector)tempListDetRptOE.get(v);
								vDTROE.add(rowR);
							}
						}
					
					
					double totMtdOthExpBudget = totMtdBudget;
					double totYtdOthExpBudget = totYtdBudget;
					double totMtdOthExpActual = totMtdActual;
					double totYtdOthExpActual = totYtdActual;
					
					totMtdBudget = 0.0;
					totYtdBudget = 0.0;		
					totMtdActual = 0.0;
					totYtdActual = 0.0;
									
					Vector detTax = (Vector)listDetail(vTax, language, dblValueReport, totMtdBudget, totYtdBudget,totMtdActual,totYtdActual);
					Vector vTempRowTax = (Vector)detTax.get(0);
					if(detTax != null && detTax.size() > 0){
						for(int f = 0; f < vTempRowTax.size(); f++){
							rowx = (Vector)vTempRowTax.get(f);
							lstData.add(rowx);
						}
					}	
						totMtdBudget = Double.parseDouble(detTax.get(1).toString());
						totYtdBudget = Double.parseDouble(detTax.get(2).toString());
						totMtdActual = Double.parseDouble(detTax.get(3).toString());
						totYtdActual = Double.parseDouble(detTax.get(4).toString());
						Vector tempListDetRptTax = (Vector)detTax.get(5);
						System.out.println("tempListDetRptTax.size() :::: "+tempListDetRptTax.size());
						if(tempListDetRptTax != null && tempListDetRptTax.size() > 0){
							for(int u = 0; u < tempListDetRptTax.size(); u++){
								rowR = (Vector)tempListDetRptTax.get(u);
								vDTRTax.add(rowR);
							}
						}
					
					
					double totMtdTaxBudget = totMtdBudget;
					double totYtdTaxBudget = totYtdBudget;
					double totMtdTaxActual = totMtdActual;
					double totYtdTaxActual = totYtdActual;
					
						
					totMtdBudget = totMtdOthRevBudget - totMtdOthExpBudget - totMtdTaxBudget;
					totYtdBudget = totYtdOthRevBudget - totYtdOthExpBudget - totYtdTaxBudget;
					totMtdActual = totMtdOthRevActual - totMtdOthExpActual - totMtdTaxActual;
					totYtdActual = totYtdOthRevActual - totYtdOthExpActual - totYtdTaxActual;
					
					Vector subTotalOth = (Vector)subTotalGroup(language, totMtdBudget,  totYtdBudget, totMtdActual, 
											totYtdActual, totGroupCurrBudget, totGroupYearBudget, totGroupCurrActual, totGroupYearActual, 
											dblValueReport, 7);
					if(subTotalOth != null && subTotalOth.size() > 0){
						rowx = (Vector)subTotalOth.get(0);
						lstData.add(rowx);
			
						totMtdOthBudget = Double.parseDouble(subTotalOth.get(1).toString());
						totYtdOthBudget = Double.parseDouble(subTotalOth.get(2).toString());
						totMtdOthActual = Double.parseDouble(subTotalOth.get(3).toString());
						totYtdOthActual = Double.parseDouble(subTotalOth.get(4).toString());
						rowR = (Vector)subTotalOth.get(5);
					}
					
				}catch(Exception e){
					System.out.println("Exception on drawListOther ::: "+e.toString());
					e.printStackTrace();
				}
			}//-------------
			vectDataToReport.add(vDTROR); // Index ke 10
			vectDataToReport.add(vDTROE); // Index ke 11
			vectDataToReport.add(vDTRTax); // Index ke 12
			vectDataToReport.add(rowR); // Index ke 13
			
			Vector vTempSpaceRL = (Vector)space();
			rowx = (Vector)vTempSpaceRL.get(0);
			rowR = (Vector)vTempSpaceRL.get(1);
			//vectDataToReport.add(rowR); // Index ke 
			lstData.add(rowx);
			
			dPLMtdBudget = totMtdRevBudget - totYtdCoGSBudget - totMtdExpBudget + totMtdOthBudget;
			dPLYtdBudget = totYtdRevBudget - totYtdRevBudget - totYtdExpBudget + totYtdOthBudget;
			dPLMtdActual = totMtdRevActual - totMtdCoGSActual - totMtdExpActual + totMtdOthActual;
			dPLYtdActual = totYtdRevActual - totYtdCoGSActual - totYtdExpActual + totYtdOthActual;
			
			//------------------------------------------- Profit Loss ---------------------------------------
			Vector vPL = (Vector)totProfitLoss(language,dPLMtdBudget,  dPLYtdBudget, dPLMtdActual, dPLYtdActual, dblValueReport, 8);
			rowR = (Vector)vPL.get(1);
			vectDataToReport.add(rowR); // Index ke 14
			if(vPL != null && vPL.size() > 0){
				rowx = (Vector)vPL.get(0);
				lstData.add(rowx);
			}
			
				if(totMtdRevActual != 0 || totMtdExpActual != 0 || totMtdOthActual != 0 || totYtdRevActual != 0
					|| totYtdExpActual != 0 || totYtdOthActual != 0	)
					iExistingData = 1;
				
		}
		FLAG_PRINT = 1; 
	}catch(Exception e){
		result = new Vector(1,1);
	}
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
	String strBack[] = {"Kembali Ke Pencarian", "Back To Search"};
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
	    list = SessProfitLoss.getListPL(periodId,oidDepartment);
	try{
            Periode period = PstPeriode.fetchExc(periodId);
            nameperiode = period.getNama();
			namedepartment = PstDepartment.fetchExc(oidDepartment).getDepartment();
        }catch(Exception e){}
	
	
	// process data on control drawlist
	Vector vectResult = new Vector();
	String listData = "";
	String sExistData = "";
	int iExistData = 0;
	Vector vectDataToReport = new Vector();
	if(list != null && list.size() > 0){
		vectResult = listProfitLoss(list, SESS_LANGUAGE, dValueReport);
		listData = String.valueOf(vectResult.get(0));     
	    vectDataToReport = (Vector)vectResult.get(1);
		sExistData = vectResult.get(2).toString();
		iExistData = Integer.parseInt(sExistData);
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
        document.frmTrialBalance.action = "P_and_L.jsp";
        document.frmTrialBalance.submit();
   /* }else{
        alert('<%=strTitle[SESS_LANGUAGE][10]%>');
        document.frmTrialBalance.DEPARTMENT.focus();
    }*/
}

function cmdBack(){
	document.frmTrialBalance.command.value ="<%=Command.BACK%>";
	document.frmTrialBalance.action = "P_and_L.jsp#up";
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
                  <td id="up"><!-- Start Search -->
				  	<table width="100%">
						<tr>
							<td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="23" width="2%">
                    <div align="center">:</div>
                  </td>
                  <td height="23" width="87%">                  <%
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
                 /* Vector vectDept = new Vector();
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
                <%if(iCommand==Command.LIST && iExistData > 0){%>
				<tr>
                  <td colspan="3" height="2">&nbsp;&nbsp;<b><%=masterTitle[SESS_LANGUAGE]%> : <%=strTitleReportPdf[SESS_LANGUAGE][4]%></b></td>
                </tr>
                <tr>
                  <td colspan="3" height="2"><%=listData%></td>
                </tr>
                <tr>
                  <td colspan="3" height="2"><table width="18%" border="0" cellspacing="1" cellpadding="1">
                    <tr>
                      <td width="83%" nowrap><b>
                        <input name="btnPrint" type="button" onClick="javascript:reportPdf()" value="<%=strCmdPrint[SESS_LANGUAGE]%>">
                      </b></td>
                      <td width="83%" nowrap><input name="btnExportToXls" type="button" onClick="javascript:printXLS()" value="<%=strCmdExport[SESS_LANGUAGE]%>"></td>
					  <td width="83%" nowrap><input name="btnBack" type="button" onClick="javascript:cmdBack()" value="<%=strBack[SESS_LANGUAGE]%>"></td>
                    </tr>
                  </table></td>
                </tr>				
						<%if(FLAG_PRINT == 1){%>
						<tr>
							<td >&nbsp;</td>
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