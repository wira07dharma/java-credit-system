<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*,
                 com.dimata.util.Formater,
                 com.dimata.util.Command,
                 com.dimata.aiso.entity.report.WorkSheet,
                 com.dimata.harisma.entity.masterdata.PstDepartment,
                 com.dimata.harisma.entity.masterdata.Department,
                 com.dimata.aiso.entity.report.CashFlow" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.entity.search.*" %>
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
	{"Periode","Keterangan","Jurnal","TOTAL","PENAMBAHAN","PENGURANGAN",
     "No Jurnal","Saldo Akhir","Data tidak ditemukan. Silahkan periksa kembali data",
     "Departemen","Silahkan pilih departemen dulu","ANGGARAN","PENCAPAIAN","No.","TANGGAL",
	"DOKUMEN REFERENSI", "NOMOR", "NAMA","SALDO PER ","SALDO PER ","KAS","BANK","KAS KECIL","NOMOR","PERKIRAAN",
	"Tanggal","s.d"},

	{"Period","Description","Journal","TOTAL","INCREMENT","DECREASE",
     "No Voucher","Last Balance","Data not found. Please check data and try again.",
     "Department","Please change department first","BUGETING","ACHIEVEMENT","No.","DATE",
	"REFERENCE DOCUMENT", "CODE", "NAME","BALANCE ON ","BALANCE ON ","CASH","BANK","PETTY CASH","NUMBER","ACCOUNT",
	"Date","To"}
};

public static final String masterTitle[] = {
	"Laporan","Report"
};

public static final String listTitle[] = {
	"Aliran Kas","Cash Flow"
};

public static final String strTitleReportPdf[][] = {
	{"LAPORAN ARUS KAS","PERIODE"},
	{"CASH FLOW","PERIOD"}
};

public static final String strHeaderReportPdf[][] = {
	{"DOKUMEN REFERENSI","PERKIRAAN","TANGGAL","NOMOR","NO JURNAL","KODE","NAMA","KETERANGAN","TOTAL"},
	{"REFERENCE DOC","ACCOUNT","DATE","NUMBER","VOUCHER NUMBER","CODE","NAME","DESCRIPTION","TOTAL"}	
};

/*public static String formatStringNumber(double dbl, FRMHandler frmHandler){
    String str = "";
    /*try{
        if(dbl<0)
            str =  "("+String.valueOf(frmHandler.userFormatStringDecimal(dbl * -1))+")";
        else
            str =  String.valueOf(frmHandler.userFormatStringDecimal(dbl));
    }catch(Exception e){}
    return str;
}*/
    /** gadnyana
     * untuk menampilkan trial balance
     * @param objectClass
     * @param language
     * @return
     */
public Vector drawListWorkSheet(Vector objectClass, int language,String nameperiode,long oidPeriod, long oidDepartment, 
FRMHandler frmHandler, String startDatePeriod, String endDatePeriod, SrcCashFlow srcCashFlow){
    Vector result = new Vector(1,1);
	ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("100%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
    ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");    
	ctrlist.addHeader(strTitle[language][15],"25%","0","2");
    ctrlist.addHeader(strTitle[language][14],"12%","0","0");
    ctrlist.addHeader(strTitle[language][23],"13%","0","0");
    ctrlist.addHeader(strTitle[language][6],"10%","2","0");
	ctrlist.addHeader(strTitle[language][24],"27%","0","2");
    ctrlist.addHeader(strTitle[language][16],"12%","0","0");
    ctrlist.addHeader(strTitle[language][17],"15%","0","0");
    ctrlist.addHeader(strTitle[language][1],"31%","2","0");
    ctrlist.addHeader(strTitle[language][3],"10%","2","0");
    //ctrlist.addHeader(strTitle[language][1],"15%","0","0");

    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();

    // vector of data will be used in pdf and xls report
    Vector vectDataToReport = new Vector(1,1);

    //Instansiasi object
    AisoBudgeting aisoBudgeting = new AisoBudgeting();
    SaldoAkhirPeriode SaldoAkhirPeriode = new SaldoAkhirPeriode();
	Perkiraan objPerkiraan = new Perkiraan();

    //Declarasi variabel
	int iExistingData = 0; 
    double totalTambahKas = 0.0;
	double totalTambahBank = 0.0;
	double totalTambahKasKecil = 0.0;
	double totalPenambahan = 0.0;
    double totalKurangKas = 0.0;
	double totalKurangBank = 0.0;
	double totalKurangKasKecil = 0.0;
	double totalPengurangan = 0.0;
    double achBudget = 0.0;
    double saldoDebetCash = 0.0;
    double saldoKreditCash = 0.0;
	double saldoDebetBank = 0.0;
    double saldoKreditBank = 0.0;
	double saldoDebetPettyCash = 0.0;
    double saldoKreditPettyCash = 0.0;
	double saldoDebetTotal = 0.0;
    double saldoKreditTotal = 0.0;
    double saldoAwalCash = 0.0;
	double saldoAwalBank = 0.0;
	double saldoAwalPettyCash = 0.0;
	double saldoAwalTotal = 0.0;
    double saldoAkhirCash = 0.0;
	double saldoAkhirBank = 0.0;
	double saldoAkhirPettyCash = 0.0;
	double saldoAkhirTotal = 0.0;
    double budget = aisoBudgeting.getBudget();
    double surplusDefisitKas = 0.0;
	double surplusDefisitBank = 0.0;
	double surplusDefisitKasKecil = 0.0;
	double surplusDefisitTotal = 0.0;
    String surplusDefKas = "";
	String surplusDefBank = ""; 
	String surplusDefKasKecil = ""; 
	String surplusDefTotal = "";  
	String strAccName = "";
	String strNamaPerk = "";
	
    try {

        // ------------------------ start proses penambahan -------------------------------------------------------------
        Vector rowx = new Vector();
        rowx.add("<b>"+strTitle[language][4]+"</b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
	  //for report
	  Vector rowR = new Vector();
	  rowR.add(strTitle[language][4]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        vectDataToReport.add(rowR); //Index ke 0
		
		 rowx = new Vector();
        rowx.add("<b>"+strTitle[language][20]+"</b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
	  rowR.add(strTitle[language][20]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        vectDataToReport.add(rowR); //Index ke 1
		
        Vector listDebetCash = (Vector)objectClass.get(0);	 
	  
	  Vector vDataAkhir = new Vector();         
	  Vector vecDbtCash = new Vector();
        for (int i = 0; i < listDebetCash.size(); i++) {  
          
            CashFlow cashFlow = (CashFlow)listDebetCash.get(i); 
			
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = cashFlow.getAccountNameEnglish();				
				else
				strAccName = cashFlow.getNamaPerkiraan();
				

		rowx = new Vector();		            
		rowx.add(Formater.formatDate(cashFlow.getTglTransaksi(), "MMM dd, yyyy"));
		rowx.add(cashFlow.getNoDocRef());
		rowx.add("<div align=\"center\">"+cashFlow.getNoVoucher()+"</div>");
            rowx.add("<div align=\"center\">"+cashFlow.getNoPerkiraan()+"</div>") ; // cashFlow.getNoVoucher());
		rowx.add(strAccName) ; 
            rowx.add(cashFlow.getKeterangan()) ; // cashFlow.getKeterangan());		
		rowx.add("<div align=\"right\">"+Formater.formatNumber(cashFlow.getValue(), "##,###.##")+"</div>");           
            lstData.add(rowx);			
			
		//for report
		rowR = new Vector();            
		rowR.add(Formater.formatDate(cashFlow.getTglTransaksi(), "MMM dd, yyyy"));
		rowR.add(cashFlow.getNoDocRef());
		rowR.add(cashFlow.getNoVoucher());
            rowR.add(cashFlow.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowR.add(strAccName) ; 
            rowR.add(cashFlow.getKeterangan()) ; // cashFlow.getKeterangan());
		rowR.add(Formater.formatNumber(cashFlow.getValue(), "##,###.##"));             
		vecDbtCash.add(rowR);

		

            totalTambahKas += cashFlow.getValue();
        }
		vectDataToReport.add(vecDbtCash);//Index ke 2
	 
	  rowx = new Vector();
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("<b>SUB TOTAL "+strTitle[language][20]+"&nbsp;"+strTitle[language][4]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalTambahKas, "##,###.##")+"</b></div>");        
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("SUB TOTAL "+strTitle[language][20]+" "+strTitle[language][4]);
	  rowR.add(Formater.formatNumber(totalTambahKas, "##,###.##"));        
	  vectDataToReport.add(rowR);//Index ke 3
	  
	  rowx = new Vector();
        rowx.add("<b>"+strTitle[language][21]+"</b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
	  //for report
	   rowR = new Vector();
	  rowR.add(strTitle[language][21]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        vectDataToReport.add(rowR); //Index ke 4
		
		Vector listDebetBank = (Vector)objectClass.get(1);
		Vector vecDbtBank = new Vector();	
		for (int i = 0; i < listDebetBank.size(); i++) {  
          
            CashFlow cashFlow = (CashFlow)listDebetBank.get(i); 
			
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = cashFlow.getAccountNameEnglish();				
				else
				strAccName = cashFlow.getNamaPerkiraan();

		rowx = new Vector();		            
		rowx.add(Formater.formatDate(cashFlow.getTglTransaksi(), "MMM dd, yyyy"));
		rowx.add(cashFlow.getNoDocRef());
		rowx.add("<div align=\"center\">"+cashFlow.getNoVoucher()+"</div>");
            rowx.add("<div align=\"center\">"+cashFlow.getNoPerkiraan()+"</div>") ; // cashFlow.getNoVoucher());
		rowx.add(strAccName) ; 
            rowx.add(cashFlow.getKeterangan()) ; // cashFlow.getKeterangan());		
		rowx.add("<div align=\"right\">"+Formater.formatNumber(cashFlow.getValue(), "##,###.##")+"</div>");           
            lstData.add(rowx);
			
		
		//for report
		rowR = new Vector();            
		rowR.add(Formater.formatDate(cashFlow.getTglTransaksi(), "MMM dd, yyyy"));
		rowR.add(cashFlow.getNoDocRef());
		rowR.add(cashFlow.getNoVoucher());
            rowR.add(cashFlow.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowR.add(strAccName) ; 
            rowR.add(cashFlow.getKeterangan()) ; // cashFlow.getKeterangan());
		rowR.add(Formater.formatNumber(cashFlow.getValue(), "##,###.##"));             
		vecDbtBank.add(rowR);

		

            totalTambahBank += cashFlow.getValue();
        }
		vectDataToReport.add(vecDbtBank);//Index ke 5
		
		rowx = new Vector();
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("<b>SUB TOTAL "+strTitle[language][21]+"&nbsp;"+strTitle[language][4]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalTambahBank, "##,###.##")+"</b></div>");        
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("SUB TOTAL "+strTitle[language][21]+" "+strTitle[language][4]);
	  rowR.add(Formater.formatNumber(totalTambahBank, "##,###.##"));        
	  vectDataToReport.add(rowR);//Index ke 6
	  
	   rowx = new Vector();
        rowx.add("<b>"+strTitle[language][22]+"</b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
	  //for report
	   rowR = new Vector();
	  rowR.add(strTitle[language][22]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        vectDataToReport.add(rowR); //Index ke 7
		
		Vector listDebetPettyCash = (Vector)objectClass.get(2);
		Vector vecDbtPettyCash = new Vector();
		for (int i = 0; i < listDebetPettyCash.size(); i++) {  
          
            CashFlow cashFlow = (CashFlow)listDebetPettyCash.get(i); 
			
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = cashFlow.getAccountNameEnglish();				
				else
				strAccName = cashFlow.getNamaPerkiraan();

		rowx = new Vector();		            
		rowx.add(Formater.formatDate(cashFlow.getTglTransaksi(), "MMM dd, yyyy"));
		rowx.add(cashFlow.getNoDocRef());
		rowx.add("<div align=\"center\">"+cashFlow.getNoVoucher()+"</div>");
            rowx.add("<div align=\"center\">"+cashFlow.getNoPerkiraan()+"</div>") ; // cashFlow.getNoVoucher());
		rowx.add(strAccName) ; 
            rowx.add(cashFlow.getKeterangan()) ; // cashFlow.getKeterangan());		
		rowx.add("<div align=\"right\">"+Formater.formatNumber(cashFlow.getValue(), "##,###.##")+"</div>");           
            lstData.add(rowx);
			
			
		//for report
		rowR = new Vector();            
		rowR.add(Formater.formatDate(cashFlow.getTglTransaksi(), "MMM dd, yyyy"));
		rowR.add(cashFlow.getNoDocRef());
		rowR.add(cashFlow.getNoVoucher());
            rowR.add(cashFlow.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowR.add(strAccName) ; 
            rowR.add(cashFlow.getKeterangan()) ; // cashFlow.getKeterangan());
		rowR.add(Formater.formatNumber(cashFlow.getValue(), "##,###.##"));             
		vecDbtPettyCash.add(rowR);

		

            totalTambahKasKecil += cashFlow.getValue();
        }
		vectDataToReport.add(vecDbtPettyCash);//Index ke 8
		
		rowx = new Vector();
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("<b>SUB TOTAL "+strTitle[language][22]+"&nbsp;"+strTitle[language][4]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalTambahKasKecil, "##,###.##")+"</b></div>");        
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("SUB TOTAL "+strTitle[language][22]+" "+strTitle[language][4]);
	  rowR.add(Formater.formatNumber(totalTambahKasKecil, "##,###.##"));        
	  vectDataToReport.add(rowR);//Index ke 9
		
		totalPenambahan = totalTambahKas + totalTambahBank + totalTambahKasKecil;
		
        rowx = new Vector();
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("<b>TOTAL "+strTitle[language][4]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalPenambahan, "##,###.##")+"</b></div>");        
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("TOTAL "+strTitle[language][4]);
	  rowR.add(Formater.formatNumber(totalPenambahan, "##,###.##"));        
	  vectDataToReport.add(rowR);//Index ke 10

        // ------------------------ end penambahan ----------------------------------------------------------------


        // ------------------------ start pengurangan -------------------------------------------------------------
        rowx = new Vector();
        rowx.add("<b>"+strTitle[language][5]+"</b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
        rowR.add(strTitle[language][5]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
        rowR.add("");
	  vectDataToReport.add(rowR); //Index ke 11
	  
	  rowx = new Vector();
        rowx.add("<b>"+strTitle[language][20]+"</b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
        rowR.add(strTitle[language][20]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
        rowR.add("");
	  vectDataToReport.add(rowR); //Index ke 12
	 	
        Vector listKreditKas = (Vector)objectClass.get(3);	  
	  	Vector vecKrtKas = new Vector();	
		
        for (int i = 0; i < listKreditKas.size(); i++) { 
          
            CashFlow cashFlowKredit = (CashFlow)listKreditKas.get(i); 
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = cashFlowKredit.getAccountNameEnglish();
				else
				strAccName = cashFlowKredit.getNamaPerkiraan();          

            rowx = new Vector();            
		rowx.add(Formater.formatDate(cashFlowKredit.getTglTransaksi(), "MMM dd, yyyy"));
		rowx.add(cashFlowKredit.getNoDocRef());
		rowx.add("<div align=\"center\">"+cashFlowKredit.getNoVoucher()+"</div>");
            rowx.add("<div align=\"center\">"+cashFlowKredit.getNoPerkiraan()+"</div>") ; // cashFlow.getNoVoucher());
		rowx.add(strAccName) ; 
            rowx.add(cashFlowKredit.getKeterangan()) ; // cashFlow.getKeterangan());
		rowx.add("<div align=\"right\">"+Formater.formatNumber(cashFlowKredit.getValue(), "##,###.##")+"</div>");           
            lstData.add(rowx);
			
		
		//for report
		rowR = new Vector();            
		rowR.add(Formater.formatDate(cashFlowKredit.getTglTransaksi(), "MMM dd, yyyy"));
		rowR.add(cashFlowKredit.getNoDocRef());
		rowR.add(cashFlowKredit.getNoVoucher());
            rowR.add(cashFlowKredit.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowR.add(strAccName) ; 
            rowR.add(cashFlowKredit.getKeterangan()) ; // cashFlow.getKeterangan());
     		rowR.add(Formater.formatNumber(cashFlowKredit.getValue(), "##,###.##"));            
		vecKrtKas.add(rowR);

		//Hitung sub total pengurangan
            totalKurangKas += cashFlowKredit.getValue();

        }

	  vectDataToReport.add(vecKrtKas);//Index ke 13
	  
	  rowx = new Vector();
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("<b>SUB TOTAL "+strTitle[language][20]+"&nbsp;"+strTitle[language][5]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalKurangKas, "##,###.##")+"</b></div>");       
        lstData.add(rowx);
		
	  // For report
	  rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("SUB TOTAL "+strTitle[language][20]+" "+strTitle[language][5]);
	  rowR.add(Formater.formatNumber(totalKurangKas, "##,###.##"));       
        vectDataToReport.add(rowR);//Index ke 14
		
		rowx = new Vector();
        rowx.add("<b>"+strTitle[language][21]+"</b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
        rowR.add(strTitle[language][21]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
        rowR.add("");
	  vectDataToReport.add(rowR); //Index ke 15
	 	
        Vector listKreditBank = (Vector)objectClass.get(4);	  
	  	Vector vecKrtBank = new Vector();
        for (int i = 0; i < listKreditBank.size(); i++) { 
          
            CashFlow cashFlowKredit = (CashFlow)listKreditBank.get(i); 
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = cashFlowKredit.getAccountNameEnglish();
				else
				strAccName = cashFlowKredit.getNamaPerkiraan();          

            rowx = new Vector();            
		rowx.add(Formater.formatDate(cashFlowKredit.getTglTransaksi(), "MMM dd, yyyy"));
		rowx.add(cashFlowKredit.getNoDocRef());
		rowx.add("<div align=\"center\">"+cashFlowKredit.getNoVoucher()+"</div>");
            rowx.add("<div align=\"center\">"+cashFlowKredit.getNoPerkiraan()+"</div>") ; // cashFlow.getNoVoucher());
		rowx.add(strAccName) ; 
            rowx.add(cashFlowKredit.getKeterangan()) ; // cashFlow.getKeterangan());
		rowx.add("<div align=\"right\">"+Formater.formatNumber(cashFlowKredit.getValue(), "##,###.##")+"</div>");           
            lstData.add(rowx);
		
			
		//for report
		rowR = new Vector();            
		rowR.add(Formater.formatDate(cashFlowKredit.getTglTransaksi(), "MMM dd, yyyy"));
		rowR.add(cashFlowKredit.getNoDocRef());
		rowR.add(cashFlowKredit.getNoVoucher());
            rowR.add(cashFlowKredit.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowR.add(strAccName) ; 
            rowR.add(cashFlowKredit.getKeterangan()) ; // cashFlow.getKeterangan());
     		rowR.add(Formater.formatNumber(cashFlowKredit.getValue(), "##,###.##"));            
		vecKrtBank.add(rowR);

		//Hitung sub total pengurangan
            totalKurangBank += cashFlowKredit.getValue();

        }
		
	  vectDataToReport.add(vecKrtBank);//Index ke 16
	  
	  rowx = new Vector();
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("<b>SUB TOTAL "+strTitle[language][21]+"&nbsp;"+strTitle[language][5]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalKurangBank, "##,###.##")+"</b></div>");       
        lstData.add(rowx);
		
	  // For report
	  rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("SUB TOTAL "+strTitle[language][21]+" "+strTitle[language][5]);
	  rowR.add(Formater.formatNumber(totalKurangBank, "##,###.##"));       
        vectDataToReport.add(rowR);//Index ke 17

	
	rowx = new Vector();
        rowx.add("<b>"+strTitle[language][22]+"</b>");
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
        rowR.add(strTitle[language][22]);
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
        rowR.add("");
	  vectDataToReport.add(rowR); //Index ke 18
	 	
        Vector listKreditPettyCash = (Vector)objectClass.get(5);	
		Vector vecKrtPettyCash = new Vector();	  
	  
        for (int i = 0; i < listKreditPettyCash.size(); i++) { 
          
            CashFlow cashFlowKredit = (CashFlow)listKreditPettyCash.get(i); 
			
			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = cashFlowKredit.getAccountNameEnglish();
				else
				strAccName = cashFlowKredit.getNamaPerkiraan();          

            rowx = new Vector();            
		rowx.add(Formater.formatDate(cashFlowKredit.getTglTransaksi(), "MMM dd, yyyy"));
		rowx.add(cashFlowKredit.getNoDocRef());
		rowx.add("<div align=\"center\">"+cashFlowKredit.getNoVoucher()+"</div>");
            rowx.add("<div align=\"center\">"+cashFlowKredit.getNoPerkiraan()+"</div>") ; // cashFlow.getNoVoucher());
		rowx.add(strAccName) ; 
            rowx.add(cashFlowKredit.getKeterangan()) ; // cashFlow.getKeterangan());
		rowx.add("<div align=\"right\">"+Formater.formatNumber(cashFlowKredit.getValue(), "##,###.##")+"</div>");           
            lstData.add(rowx);
		
		
		//for report
		rowR = new Vector();            
		rowR.add(Formater.formatDate(cashFlowKredit.getTglTransaksi(), "MMM dd, yyyy"));
		rowR.add(cashFlowKredit.getNoDocRef());
		rowR.add(cashFlowKredit.getNoVoucher());
            rowR.add(cashFlowKredit.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowR.add(strAccName) ; 
            rowR.add(cashFlowKredit.getKeterangan()) ; // cashFlow.getKeterangan());
     		rowR.add(Formater.formatNumber(cashFlowKredit.getValue(), "##,###.##"));            
		vecKrtPettyCash.add(rowR);

		//Hitung sub total pengurangan
            totalKurangKasKecil += cashFlowKredit.getValue();

        }

	  vectDataToReport.add(vecKrtPettyCash);//Index ke 19
	  
	  rowx = new Vector();
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("<b>SUB TOTAL "+strTitle[language][22]+"&nbsp;"+strTitle[language][5]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalKurangKasKecil, "##,###.##")+"</b></div>");       
        lstData.add(rowx);
		
	  // For report
	  rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("SUB TOTAL "+strTitle[language][22]+" "+strTitle[language][5]);
	  rowR.add(Formater.formatNumber(totalKurangKasKecil, "##,###.##"));       
        vectDataToReport.add(rowR);//Index ke 20

		
		totalPengurangan = totalKurangKas + totalKurangBank + totalKurangKasKecil;
		
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("<b>TOTAL "+strTitle[language][5]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalPengurangan, "##,###.##")+"</b></div>");       
        lstData.add(rowx);
		
	  // For report
	  rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("TOTAL "+strTitle[language][5]);
	  rowR.add(Formater.formatNumber(totalPengurangan, "##,###.##"));       
        vectDataToReport.add(rowR);//Index ke 21

        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  vectDataToReport.add(rowR);//Index ke 22

      //Perhitungan Surplus Defisit
	  
	surplusDefisitKas = totalTambahKas - totalKurangKas;
	surplusDefisitBank = totalTambahBank - totalKurangBank;
	surplusDefisitKasKecil = totalTambahKasKecil - totalKurangKasKecil;
	surplusDefisitTotal = totalPenambahan - totalPengurangan;

	/* Kondisi ini untuk cek hasil perhitungan surplus (defisit) kas :
       - Jika surplus nilainya sesuai dengan hasil perhitungan.
       - Jika defisit nilainya dibuat positip tapi ditaruh di dalam kurung sesuai standar akuntansi.
      */

	if(surplusDefisitKas < 0){
		surplusDefKas = "("+Formater.formatNumber(surplusDefisitKas * -1, "##,###.##")+")";
	}else{
		surplusDefKas = Formater.formatNumber(surplusDefisitKas, "##,###.##"); 
	}	
	
	if(surplusDefisitBank < 0){
		surplusDefBank = "("+Formater.formatNumber(surplusDefisitBank * -1, "##,###.##")+")";
	}else{
		surplusDefBank = Formater.formatNumber(surplusDefisitBank, "##,###.##"); 
	}	
	
	if(surplusDefisitKasKecil < 0){
		surplusDefKasKecil = "("+Formater.formatNumber(surplusDefisitKasKecil * -1, "##,###.##")+")";
	}else{
		surplusDefKasKecil = Formater.formatNumber(surplusDefisitKasKecil, "##,###.##"); 
	}	
	
	if(surplusDefisitTotal < 0){
		surplusDefTotal = "("+Formater.formatNumber(surplusDefisitTotal * -1, "##,###.##")+")";
	}else{
		surplusDefTotal = Formater.formatNumber(surplusDefisitTotal, "##,###.##"); 
	}	
		 // total
		 
		Date dateFr = (Date)srcCashFlow.getDateFrom();
        Date dateTo = (Date)srcCashFlow.getDateTo();
		String stDateFr = Formater.formatDate(dateTo,"dd MMM yyyy").substring(0,2);
		rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>SURPLUS (DEFISIT) "+stDateFr+" - "+Formater.formatDate(dateTo,"dd MMM yyyy")+"</b>");
	  	rowx.add("");        
        lstData.add(rowx);
		
		//for Report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("SURPLUS (DEFISIT)"+" "+stDateFr+" - "+Formater.formatDate(dateTo,"dd MMM yyyy"));
	  rowR.add("");       
	  vectDataToReport.add(rowR);//Index ke 23
		
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strTitle[language][20]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+surplusDefKas+"</b></div>");        
        lstData.add(rowx);
		
	  //for Report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("       "+strTitle[language][20]);
	  rowR.add(surplusDefKas);       
	  vectDataToReport.add(rowR);//Index ke 24
	  
	   // total
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strTitle[language][21]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+surplusDefBank+"</b></div>");        
        lstData.add(rowx);
		
	  //for Report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("       "+strTitle[language][21]);
	  rowR.add(surplusDefBank);       
	  vectDataToReport.add(rowR);//Index ke 25
	  
	   // total
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strTitle[language][22]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+surplusDefKasKecil+"</b></div>");        
        lstData.add(rowx);
		
	  //for Report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("       "+strTitle[language][22]);
	  rowR.add(surplusDefKasKecil);       
	  vectDataToReport.add(rowR);//Index ke 26
		
        // total
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>"+strTitle[language][3]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+surplusDefTotal+"</b></div>");        
        lstData.add(rowx);
		
	  //for Report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add(strTitle[language][3]);
	  rowR.add(surplusDefTotal);       
	  vectDataToReport.add(rowR);//Index ke 27
	
        // saldo per tgl 1
	  //Untuk mengambil saldo awal periode
        //SaldoAkhirPeriode = SessWorkSheet.getSoAwal(SessWorkSheet.getOidPeriodeLalu(oidPeriod), oidDepartment);	
		Vector vSaldoAwal = SessWorkSheet.getSaldoAwalCashFlow(oidPeriod, oidDepartment, srcCashFlow);
		SaldoAkhirPeriode objSoAkhirPeriodCash = (SaldoAkhirPeriode)vSaldoAwal.get(0);
		SaldoAkhirPeriode objSoAkhirPeriodBank = (SaldoAkhirPeriode)vSaldoAwal.get(1);
		SaldoAkhirPeriode objSoAkhirPeriodPettyCash = (SaldoAkhirPeriode)vSaldoAwal.get(2);

	  /*Kondisi ini digunakan untuk cek saldo awal kas di satu departemen untuk saldo awal sebagai dasar perhitungan 
          saldo akhir periode :  
          - Jika salah satu account kas bersaldo debet, dan yang lain bersaldo kredit, maka saldo awal kas 
            adalah debet dikurangi kredit.
            - Jika hasilnya positip maka nilai ini langsung dijadikan nilai saldo awal.
            - Jika hasilnya negatip maka nilai ini mesti dikalikan -1 terus ditaruh didalam kurung sesuai standar
              akuntansi.
            - Saldo akhir dihitung : (totalTambah - totalKurang) + saldoAwal
          - Jika semua account kas bersaldo debet, maka saldo kas adalah hasil penjumlahan saldo kas yang dimiliki 
            oleh department itu dan saldoAkhir dihitung : (totalTambah - totalKurang) + saldoAwal
          - Jika semua account kas bersaldo kredit, maka saldo kas adalah hasil penjumlahan saldo kas yang dimiliki
            oleh department itu dan nilainya ditaruh di dalam kurung karena saldo normal kas adalah debet, dan saldo
            akhir dihitung : (totalTambah - totalKurang) - saldoAwal

	  */

	 saldoDebetCash = objSoAkhirPeriodCash.getDebet();
      saldoKreditCash = objSoAkhirPeriodCash.getKredit();
	  String soAwalKas = "";
	  
	  if(saldoDebetCash > 0 && saldoKreditCash > 0){

		saldoAwalCash = saldoDebetCash - saldoKreditCash; 
		saldoAkhirCash = (totalTambahKas - totalKurangKas) + saldoAwalCash;
	
		if(saldoAwalCash > 0){

			soAwalKas = Formater.formatNumber(saldoAwalCash, "##,###.##");
		}else{
		
			soAwalKas = "("+Formater.formatNumber(saldoAwalCash * -1, "##,###.##")+")";


		}
	  }

	  if(saldoDebetCash > 0 && saldoKreditCash == 0){

		saldoAwalCash = saldoDebetCash;
		soAwalKas = Formater.formatNumber(saldoAwalCash, "##,###.##");
		saldoAkhirCash = (totalTambahKas - totalKurangKas) + saldoAwalCash;

	  }

	 if(saldoDebetCash == 0 && saldoKreditCash > 0){

		saldoAwalCash = saldoKreditCash;
		soAwalKas = "("+Formater.formatNumber(saldoAwalCash, "##,###.##")+")";
		saldoAkhirCash = (totalTambahKas - totalKurangKas) - saldoAwalCash;

	  }
	  
	   if(saldoDebetCash == 0 && saldoKreditCash == 0){

		saldoAwalCash = saldoDebetCash;
		soAwalKas = Formater.formatNumber(saldoAwalCash, "##,###.##");
		saldoAkhirCash = (totalTambahKas - totalKurangKas) + saldoAwalCash;

	  }
		
		Date dateFrAwal = (Date)dateFr.clone();
		dateFrAwal.setDate(dateFr.getDate() - 1);
		rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>"+strTitle[language][18]+"&nbsp;"+(Formater.formatDate(dateFrAwal,"dd MMM yyyy"))+"</b>");       
	  	rowx.add("");       
        lstData.add(rowx);
		
	  //for report
	  	rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  	rowR.add("");
        rowR.add("");
	  	rowR.add("");
	  	rowR.add(strTitle[language][18]+" "+Formater.formatDate(dateFrAwal,"dd MMM yyyy"));
	  	rowR.add("");	  
        vectDataToReport.add(rowR);//Index ke 28
		
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strTitle[language][20]+"</b>");       
	  	rowx.add("<div align=\"right\"><b>"+soAwalKas+"</b></div>");       
        lstData.add(rowx);
		
	  //for report
	  	rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  	rowR.add("");
        rowR.add("");
	  	rowR.add("");
	  	rowR.add("      "+strTitle[language][20]);
	  	rowR.add(soAwalKas);	  
        vectDataToReport.add(rowR);//Index ke 29
		
	  saldoDebetBank = objSoAkhirPeriodBank.getDebet();
      saldoKreditBank = objSoAkhirPeriodBank.getKredit();
	  
	  String soAwalBank = "";
	  		
		if(saldoDebetBank > 0 && saldoKreditBank > 0){

		saldoAwalBank = saldoDebetBank - saldoKreditBank; 
		saldoAkhirBank = (totalTambahBank - totalKurangBank) + saldoAwalBank;
	
		if(saldoAwalBank > 0){

			soAwalBank = Formater.formatNumber(saldoAwalBank, "##,###.##");
		}else{
		
			soAwalBank = "("+Formater.formatNumber(saldoAwalBank * -1, "##,###.##")+")";


		}
	  }

	  if(saldoDebetBank > 0 && saldoKreditBank == 0){

		saldoAwalBank = saldoDebetBank;
		soAwalBank = Formater.formatNumber(saldoAwalBank, "##,###.##");
		saldoAkhirBank = (totalTambahBank - totalKurangBank) + saldoAwalBank;

	  }

	 if(saldoDebetBank == 0 && saldoKreditBank > 0){

		saldoAwalBank = saldoKreditBank;
		soAwalBank = "("+Formater.formatNumber(saldoAwalBank, "##,###.##")+")";
		saldoAkhirBank = (totalTambahBank - totalKurangBank) - saldoAwalBank;

	  }
	  
	   if(saldoDebetBank == 0 && saldoKreditBank == 0){

		saldoAwalBank = saldoDebetBank;
		soAwalBank = Formater.formatNumber(saldoAwalBank, "##,###.##");
		saldoAkhirBank = (totalTambahBank - totalKurangBank) + saldoAwalBank;

	  }


        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strTitle[language][21]+"</b>");       
	  rowx.add("<div align=\"right\"><b>"+soAwalBank+"</b></div>");       
        lstData.add(rowx);
		
	  //for report
	  	rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  	rowR.add("");
        rowR.add("");
	  	rowR.add("");
	  	rowR.add("      "+strTitle[language][21]);
	  	rowR.add(soAwalBank);	  
        vectDataToReport.add(rowR);//Index ke 30

  	  saldoDebetPettyCash = objSoAkhirPeriodPettyCash.getDebet();
      saldoKreditPettyCash = objSoAkhirPeriodPettyCash.getKredit();	
	  
	  String soAwalKasKecil = "";
	  		
		if(saldoDebetPettyCash > 0 && saldoKreditPettyCash > 0){

		saldoAwalPettyCash = saldoDebetPettyCash - saldoKreditPettyCash; 
		saldoAkhirPettyCash = (totalTambahKasKecil - totalKurangKasKecil) + saldoAwalPettyCash;
	
		if(saldoAwalPettyCash > 0){

			soAwalKasKecil = Formater.formatNumber(saldoAwalPettyCash, "##,###.##");
		}else{
		
			soAwalKasKecil = "("+Formater.formatNumber(saldoAwalPettyCash * -1, "##,###.##")+")";


		}
	  }

	  if(saldoDebetPettyCash > 0 && saldoKreditPettyCash == 0){

		saldoAwalPettyCash = saldoDebetPettyCash;
		soAwalKasKecil = Formater.formatNumber(saldoAwalPettyCash, "##,###.##");
		saldoAkhirPettyCash = (totalTambahKasKecil - totalKurangKasKecil) + saldoAwalPettyCash;

	  }

	 if(saldoDebetPettyCash == 0 && saldoKreditPettyCash > 0){

		saldoAwalPettyCash = saldoKreditPettyCash;
		soAwalKasKecil = "("+Formater.formatNumber(saldoAwalPettyCash, "##,###.##")+")";
		saldoAkhirPettyCash = (totalTambahKasKecil - totalKurangKasKecil) - saldoAwalPettyCash;

	  }
	  
	   if(saldoDebetPettyCash == 0 && saldoKreditPettyCash == 0){

		saldoAwalPettyCash = saldoDebetPettyCash;
		soAwalKasKecil = Formater.formatNumber(saldoAwalPettyCash, "##,###.##");
		saldoAkhirPettyCash = (totalTambahKasKecil - totalKurangKasKecil) + saldoAwalPettyCash;

	  }


        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strTitle[language][22]+"</b>");       
	  	rowx.add("<div align=\"right\"><b>"+soAwalKasKecil+"</b></div>");       
        lstData.add(rowx);
		
	  //for report
	  	rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  	rowR.add("");
        rowR.add("");
	  	rowR.add("");
	  	rowR.add("      "+strTitle[language][22]);
	  	rowR.add(soAwalKasKecil);	  
        vectDataToReport.add(rowR);//Index ke 31
		
	  saldoDebetTotal = saldoDebetCash + saldoDebetBank + saldoDebetPettyCash;
      saldoKreditTotal = saldoKreditCash + saldoKreditBank + saldoKreditPettyCash;
	  
	  String soAwalTotal = "";
	  		
		if(saldoDebetTotal > 0 && saldoKreditTotal > 0){

		saldoAwalTotal = saldoDebetTotal - saldoKreditTotal; 
		saldoAkhirTotal = (totalPenambahan - totalPengurangan) + saldoAwalTotal;
	
		if(saldoAwalTotal > 0){

			soAwalTotal = Formater.formatNumber(saldoAwalTotal, "##,###.##");
		}else{
		
			soAwalTotal = "("+Formater.formatNumber(saldoAwalTotal * -1, "##,###.##")+")";


		}
	  }

	  if(saldoDebetTotal > 0 && saldoKreditTotal == 0){

		saldoAwalTotal = saldoDebetTotal;
		soAwalTotal = Formater.formatNumber(saldoAwalTotal, "##,###.##");
		saldoAkhirTotal = (totalPenambahan - totalPengurangan) + saldoAwalTotal;

	  }

	 if(saldoDebetTotal == 0 && saldoKreditTotal > 0){

		saldoAwalTotal = saldoKreditTotal;
		soAwalTotal = "("+Formater.formatNumber(saldoAwalTotal, "##,###.##")+")";
		saldoAkhirTotal = (totalPenambahan - totalPengurangan) - saldoAwalTotal;

	  }
	  
	   if(saldoDebetTotal == 0 && saldoKreditTotal == 0){

		saldoAwalTotal = saldoDebetTotal;
		soAwalTotal = Formater.formatNumber(saldoAwalTotal, "##,###.##");
		saldoAkhirTotal = (totalPenambahan - totalPengurangan) + saldoAwalTotal;

	  }


        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>"+strTitle[language][3]+"</b>");       
	  	rowx.add("<div align=\"right\"><b>"+soAwalTotal+"</b></div>");       
        lstData.add(rowx);
		
	  //for report
	  	rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  	rowR.add("");
        rowR.add("");
	  	rowR.add("");
	  	rowR.add(strTitle[language][3]);
	  	rowR.add(soAwalTotal);	  
        vectDataToReport.add(rowR);//Index ke 32		
		
       /*
	 Kondisi ini digunakan untuk cek hasil perhitungan saldo akhir periode :
       - Jika hasilnya positip maka nilai itu yang digunakan sebagai saldo akhir.
       - Jika hasilnya negatip maka nilai hasil perhitungan mesti di setup positip
         namun ditaruh di dalam kurung sesuai dengan standar akuntansi.
	 */
	 String soAkhirCash = "";

	 if(saldoAkhirCash >= 0){

	 	soAkhirCash = Formater.formatNumber(saldoAkhirCash, "##,###.##");

	 }else{

		soAkhirCash = "("+Formater.formatNumber(saldoAkhirCash * -1, "##,###.##")+")";

	 }

	  // saldo per 31
	  	rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>"+strTitle[language][19]+"&nbsp;"+(Formater.formatDate(dateTo,"dd MMM yyyy"))+"</b>");
	  	rowx.add("");       
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add(strTitle[language][19]+" "+Formater.formatDate(dateTo,"dd MMM yyyy"));
	  rowR.add("");        
	  vectDataToReport.add(rowR);//Index ke 33
	  
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strTitle[language][20]+"</b>");
	  	rowx.add("<div align=\"right\"><b>"+soAkhirCash+"</b></div>");       
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("      "+strTitle[language][20]);
	  rowR.add(soAkhirCash);        
	  vectDataToReport.add(rowR);//Index ke 34
	  
	  String soAkhirBank = "";

	 if(saldoAkhirBank >= 0){

	 	soAkhirBank = Formater.formatNumber(saldoAkhirBank, "##,###.##");

	 }else{

		soAkhirBank = "("+Formater.formatNumber(saldoAkhirBank * -1, "##,###.##")+")";

	 }

	  // saldo per 31
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strTitle[language][21]+"</b>");
	  	rowx.add("<div align=\"right\"><b>"+soAkhirBank+"</b></div>");       
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("      "+strTitle[language][21]);
	  rowR.add(soAkhirBank);        
	  vectDataToReport.add(rowR);//Index ke 35

	String soAkhirPettyCash = "";

	 if(saldoAkhirPettyCash >= 0){

	 	soAkhirPettyCash = Formater.formatNumber(saldoAkhirPettyCash, "##,###.##");

	 }else{

		soAkhirPettyCash = "("+Formater.formatNumber(saldoAkhirPettyCash * -1, "##,###.##")+")";

	 }

	  // saldo per 31
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strTitle[language][22]+"</b>");
	  	rowx.add("<div align=\"right\"><b>"+soAkhirPettyCash+"</b></div>");       
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("      "+strTitle[language][22]);
	  rowR.add(soAkhirPettyCash);        
	  vectDataToReport.add(rowR);//Index ke 36

	String soAkhirTotal = "";

	 if(saldoAkhirTotal >= 0){

	 	soAkhirTotal = Formater.formatNumber(saldoAkhirTotal, "##,###.##");

	 }else{

		soAkhirTotal = "("+Formater.formatNumber(saldoAkhirTotal * -1, "##,###.##")+")";

	 }

	  // saldo per 31
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  	rowx.add("");
        rowx.add("");
	  	rowx.add("<b>"+strTitle[language][3]+"</b>");
	  	rowx.add("<div align=\"right\"><b>"+soAkhirTotal+"</b></div>");       
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add(strTitle[language][3]);
	  rowR.add(soAkhirTotal);        
	  vectDataToReport.add(rowR);//Index ke 37


        // butgeting
	  // Digunakan untuk mengambil budget. 
	  aisoBudgeting = SessWorkSheet.getBudgetAwal(oidPeriod);

        /*rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
   	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>"+strTitle[language][11]+" "+(startDatePeriod.toUpperCase())+"</b>");        
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(aisoBudgeting.getBudget(), "##,###.##")+"</b></div>");       
        lstData.add(rowx);
		
	  //for report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add(strTitle[language][11]+" "+(startDatePeriod.toUpperCase()));
	  rowR.add(""+aisoBudgeting.getBudget());
        vectDataToReport.add(rowR);*///Index ke 10

        // Pencapaian

    	/* Kondisi ini untuk cek perhitungan achievement budget :
       - Jika budgetnya nol achievement otomatis diset nol untuk menghindari hasil tak terhingga.
       - Jika budgetnya lebih dari nol maka mengikuti perhitungan yang sudah ditentukan.
    	*/
 
    	if(budget > 0){
		achBudget = ((totalPenambahan - totalPengurangan) + SaldoAkhirPeriode.getDebet()) / aisoBudgeting.getBudget()*100;
	}else{
		achBudget = 0;
	}

        /*rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>"+strTitle[language][12]+"</b>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(achBudget, "##,###.##")+"</b></div>");        
        lstData.add(rowx);
		
		//for report
	  rowR = new Vector();        
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add(strTitle[language][12]);
	  rowR.add(""+achBudget); */ 
     	  
      //vectDataToReport.add(rowR);Index ke 11
	  /*vectDataToReport.add(""+surplusDefisitKas);//Index ke 12
	  vectDataToReport.add(""+surplusDefisitBank);//Index ke 12
	  vectDataToReport.add(""+surplusDefisitKasKecil);//Index ke 12
	  vectDataToReport.add(""+surplusDefisitTotal);//Index ke 12
	  vectDataToReport.add(""+saldoAkhirCash);//Index ke 13
	  vectDataToReport.add(""+saldoAkhirBank);//Index ke 13
	  vectDataToReport.add(""+saldoAkhirPettyCash);//Index ke 13
	  vectDataToReport.add(""+saldoAkhirTotal);//Index ke 13
	  vectDataToReport.add(""+saldoKreditCash);//Index ke 14
	  vectDataToReport.add(""+saldoKreditBank);//Index ke 14
	  vectDataToReport.add(""+saldoKreditPettyCash);//Index ke 14
	  vectDataToReport.add(""+saldoKreditTotal);//Index ke 14
	  vectDataToReport.add(""+achBudget);//Index ke 15
	  vectDataToReport.add(""+budget);//Index ke 16*/
	
	  if(totalPenambahan != 0 || totalPengurangan != 0)
	  	iExistingData = 1;
 	  FLAG_PRINT = 1; 
    
	} catch(Exception exc) {
						System.out.println(" Error pada method drawListWorkSheet() ==> "+ exc.toString());
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
	int iDate = FRMQueryString.requestInt(request,FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]+"_dy");
	int iMonth = FRMQueryString.requestInt(request,FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]+"_mn");
	int iYear = FRMQueryString.requestInt(request,FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]+"_yr"); 
	int iDateTo = FRMQueryString.requestInt(request,FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]+"_dy");
	int iMonthTo = FRMQueryString.requestInt(request,FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]+"_mn");
	int iYearTo = FRMQueryString.requestInt(request,FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]+"_yr"); 
	
	System.out.println("periodId JSP : "+periodId);
	SrcCashFlow srcCashFlow = new SrcCashFlow();
	if(iCommand == Command.LIST){
		Date dateFrom = new Date(iYear - 1900, iMonth - 1, iDate);
		Date dateTo = new Date(iYearTo - 1900, iMonthTo - 1, iDateTo);
		srcCashFlow.setDateFrom(dateFrom);
		srcCashFlow.setDateTo(dateTo);
	}
	
    String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
	String strCmdPrint[] = {"Cetak Laporan", "Print Report"};
	String strCmdExport[] = {"Ekspor ke Excel", "Export To Excel"};
	String strCmdBack[] = {"Kembali ke Pencarian", "Back To Search"};
    String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
    Date today = new Date();
	String linkPdf = reportrootfooter+"report.aliranKas.CashFlowDeptPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String linkXls = reportrootfooter+"report.aliranKas.CashFlowDeptXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String pathImage = reportrootimage +"company121.jpg";
	
	FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSymbol); 
	frmHandler.setDigitSeparator(sUserDigitGroup);
	
    Vector list = new Vector();
    String nameperiode = "";
	String startDatePeriod = "";
	String endDatePeriod = "";
    String namedepartment = "";	
    if(iCommand==Command.LIST){
        list = SessCashFlow.getListCashFlow(periodId,oidDepartment,srcCashFlow);
	  
        try{
            Periode period = PstPeriode.fetchExc(periodId);
            nameperiode = period.getNama();
			startDatePeriod = Formater.formatDate(period.getTglAwal(), "MMM dd, yyyy");
			endDatePeriod = Formater.formatDate(period.getTglAkhir(), "MMM dd, yyyy");
			namedepartment = PstDepartment.fetchExc(oidDepartment).getDepartment();
        }catch(Exception e){}
    }
	
	// process data on control drawlist
	Vector vectResult = new Vector(1,1);
	String listData = "";
	Vector vectDataToReport = new Vector(1,1);
	String sExistData = "";
	int iExistData = 0;
	try{
		vectResult = drawListWorkSheet(list, SESS_LANGUAGE,nameperiode,periodId, oidDepartment, frmHandler, startDatePeriod, endDatePeriod, srcCashFlow);
		if(vectResult != null && vectResult.size() > 0){
			listData = String.valueOf(vectResult.get(0));
			vectDataToReport = (Vector)vectResult.get(1);
			sExistData = vectResult.get(2).toString();
			iExistData = Integer.parseInt(sExistData);
		}
	}catch(Exception e){
		System.out.println("Exception on getDataCashFlow ::::::: "+e.toString());
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
	
	Vector vecSess = new Vector();
	vecSess.add(nameperiode);
	vecSess.add(namedepartment);
	vecSess.add(linkPdf);
	vecSess.add(linkXls);
	vecSess.add(vectDataToReport);
	vecSess.add(vecTitle);
	vecSess.add(vecHeader);
	vecSess.add(pathImage);
	
	if(session.getValue("CASH_FLOW")!=null){   
		session.removeValue("CASH_FLOW");
	}

	session.putValue("CASH_FLOW",vecSess);
	

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
function getThn(){
	var date1 = ""+document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]%>_mn.value=bln;
	document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]%>_dy.value=hri;
	document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]%>_yr.value=thn;
	
	var date2 = ""+document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]%>.value;
	var thn1 = date2.substring(6,10);
	var bln1 = date2.substring(3,5);	
	if(bln1.charAt(0)=="0"){
		bln1 = ""+bln1.charAt(1);
	}
	
	var hri1 = date2.substring(0,2);
	if(hri1.charAt(0)=="0"){
		hri1 = ""+hri1.charAt(1);
	}
	
	document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]%>_mn.value=bln1;
	document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]%>_dy.value=hri1;
	document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]%>_yr.value=thn1;		
}

function report(){
    //var val = document.frmTrialBalance.DEPARTMENT.value;
    //if(val!=0){
        document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.command.value ="<%=Command.LIST%>";
        document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.action = "cash_flow_dept.jsp";
        document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.submit();
    //}else{
        //alert('<%=strTitle[SESS_LANGUAGE][10]%>');
        //document.frmTrialBalance.DEPARTMENT.focus();
    //}
}

function reportPdf(){	 
		var linkPage = "<%=reportroot%>report.aliranKas.CashFlowDeptPdf";       
		window.open(linkPage);  				
}

function printXLS(){
		var linkPage = "<%=reportroot%>report.aliranKas.CashFlowDeptXls";       
		window.open(linkPage);  				
}

function backToSearch(){
	document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.command.value ="<%=Command.BACK%>";
	document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.action = "cash_flow_dept.jsp#up";
    document.<%=FrmSrcCashFlow.FRM_CASHFLOW%>.submit();
}


function hideObjectForDate(){
}
	
function showObjectForDate(){
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
</SCRIPT>
<link rel="stylesheet" href="../style/calendar.css" type="text/css">
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
		   <%if(isUseDatePicker.equalsIgnoreCase("Y")){%> 
      		<table class="ds_box" cellpadding="0" cellspacing="0" id="ds_conclass" style="display: none;">
			<tr><td id="ds_calclass">
			</td></tr>
			</table>
			<script language=JavaScript src="<%=approot%>/main/calendar.js"></script>
			<%}%>	
		  <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="<%=FrmSrcCashFlow.FRM_CASHFLOW%>" method="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">              
			  <%if(privView && privSubmit){%>
			  <table><tr><td></td></tr></table>
              <table align="center" width="99%" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">			   
			  	<tr>
					<td>
						<table width="100%" height="94" border="0" class="search00">
			  <tr>
			  <td>
			  <table width="100%" border="0" class="mainJournalOut">
                <tr>
                  <td height="23" id="up">&nbsp;</td>
                  <td height="23">&nbsp;</td>
                  <td height="23" colspan="3">&nbsp;</td>
                </tr>
                <tr><!-- start search -->
                  <td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="23" width="2%">
                    <div align="center">:</div>
                  </td>
                  <td height="23" colspan="3">                  <%
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
                  <td height="23"><%=strTitle[SESS_LANGUAGE][25]%></td>
                  <td height="23"><div align="center">:</div></td>
                  <td width="14%" height="23">   										   
							  <input onClick="ds_sh(this);" size="14" name="<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcCashFlow.getDateFrom() == null? new Date() : srcCashFlow.getDateFrom()), "dd-MM-yyyy")%>"/> 						  
							  <input type="hidden" name="<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]%>_mn">
							  <input type="hidden" name="<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]%>_dy">
							  <input type="hidden" name="<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_START_DATE]%>_yr">	
						 
				  </td>
                  <td width="3%"><div align="center"><%=strTitle[SESS_LANGUAGE][26]%></div></td>
                  <td width="70%">
				  										   										   
							  <input onClick="ds_sh(this);" size="14" name="<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcCashFlow.getDateTo() == null? new Date() : srcCashFlow.getDateTo()), "dd-MM-yyyy")%>"/> 						  
							  <input type="hidden" name="<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]%>_mn">
							  <input type="hidden" name="<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]%>_dy">
							  <input type="hidden" name="<%=FrmSrcCashFlow.fieldNames[FrmSrcCashFlow.FRM_END_DATE]%>_yr">	
							  <script language="JavaScript" type="text/JavaScript">getThn();</script>				
				  </td>
                </tr>
                <tr>
                  <td width="11%" height="23"><%//=strTitle[SESS_LANGUAGE][9]%></td>
                  <td height="23" width="2%">
                    <!-- <div align="center">:</div> -->
                  </td>
                  <td height="23" colspan="3"><%
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
                  <td height="23" colspan="5">&nbsp;</td>
                </tr>
                <tr>
                  <td width="11%" height="23">&nbsp;</td>
                  <td height="23" width="2%">
                    <div align="center"><b></b></div>
                  </td>
                  <td height="23" colspan="3"><input type="button" value="<%=strReport%>" onClick="javascript:report()"></td>
                </tr><!-- end search-->
				</table>
				</td>
				</tr>
                <tr>
                  <td colspan="3" height="2" id="down">&nbsp;</td>
                </tr>				
                <%if(iCommand==Command.LIST && iExistData > 0){%>
				<%
					Date dateFr = (Date)srcCashFlow.getDateFrom();
            		Date dateTo = (Date)srcCashFlow.getDateTo();
					String dtFrom = Formater.formatDate(dateFr, "dd MMM yyyy");
					String dtTo = Formater.formatDate(dateTo, "dd MMM yyyy");
				%>
				<tr><td ><b><font size="5"><%=listTitle[SESS_LANGUAGE]%>&nbsp;<%=dtFrom%> - <%=dtTo%></font></b></td></tr>
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
									<td width="83%" nowrap>
									<input type="button" value="<%=strCmdPrint[SESS_LANGUAGE]%>" onClick="javascript:reportPdf()">&nbsp;&nbsp;
									<input type="button" value="<%=strCmdExport[SESS_LANGUAGE]%>" onClick="javascript:printXLS()">&nbsp;&nbsp;
									<input type="button" value="<%=strCmdBack[SESS_LANGUAGE]%>" onClick="javascript:backToSearch()">
								  </td>									
								</tr>
								</table>
							</td>
						</tr>
						<%}%>
               <%}else{%>
			   <tr><%if(iCommand == Command.LIST){%><td class="msgerror"><%=strTitle[SESS_LANGUAGE][8]%></td><%}%></tr>
			   <%}%>
              </table>
					</td>
				</tr>
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