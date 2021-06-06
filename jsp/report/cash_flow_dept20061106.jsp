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
	{"Periode","Keterangan","Jurnal","Total","PENAMBAHAN","PENGURANGAN",
     "No Voucher","Saldo Akhir","Anda tidak punya hak akses untuk laporan neraca percobaan !!!",
     "Departemen","Silahkan pilih departemen dulu","ANGGARAN","PENCAPAIAN","No.","Tgl Transaksi",
	"Doc Ref", "No. Perk", "Nama Perkiraan"},

	{"Period","Description","Journal","Total","Increment","Decrease",
     "No Voucher","Last Balance","You haven't privilege for accessing trial balance report !!!",
     "Department","Please change department first","BUGETING","TARGET","No.","Trans Date",
	"Ref Doc", "Acc Number", "Acc Name"}
};

public static final String masterTitle[] = {
	"Laporan","Report"
};

public static final String listTitle[] = {
	"Aliran Kas","Cash Flow"
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
public Vector drawListWorkSheet(Vector objectClass, int language,String nameperiode,long oidPeriod, FRMHandler frmHandler){
    Vector result = new Vector(1,1);
	ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("90%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
    ctrlist.setHeaderStyle("listgentitle");    
    ctrlist.addHeader(strTitle[language][14],"5%","0","0");
    ctrlist.addHeader(strTitle[language][15],"15%","0","0");
    ctrlist.addHeader(strTitle[language][6],"10%","0","0");
    ctrlist.addHeader(strTitle[language][16],"10%","0","0");
    ctrlist.addHeader(strTitle[language][17],"15%","0","0");
    ctrlist.addHeader(strTitle[language][1],"25%","0","0");
    ctrlist.addHeader(strTitle[language][3],"10%","0","0");
    //ctrlist.addHeader(strTitle[language][1],"15%","0","0");

    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();

	// vector of data will be used in pdf and xls report
	Vector vectDataToReport = new Vector(1,1);
		
    double totalTambah = 0.0;
    double totalKurang = 0.0;

    try {
        // proses penambahan
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
        vectDataToReport.add(rowR);
		
        Vector listDebet = (Vector)objectClass.get(0);	 
	  Vector vecDbt = new Vector();         
	  
        for (int i = 0; i < listDebet.size(); i++) {            
            CashFlow cashFlow = (CashFlow)listDebet.get(i); // listDebet.get(i);            

		rowx = new Vector();
            //rowx.add(cashFlow.getTglTransaksi());
		rowx.add("<div align=\"center\">"+Formater.formatDate(cashFlow.getTglTransaksi(), "dd MMM yyyy")+"</div>");
		rowx.add(cashFlow.getNoDocRef());
		rowx.add(cashFlow.getNoVoucher());
            rowx.add(cashFlow.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowx.add(cashFlow.getNamaPerkiraan()) ; 
            rowx.add(cashFlow.getKeterangan()) ; // cashFlow.getKeterangan());		
		rowx.add("<div align=\"right\">"+Formater.formatNumber(cashFlow.getValue(), "##,###")+"</div>");		
            //rowx.add("<div align=\"right\">"+formatStringNumber(cashFlow.getValue(), frmHandler)+"</div>");
            lstData.add(rowx);
			
			//for report
			rowR = new Vector();
            //rowR.add(cashFlow.getTglTransaksi());
		rowR.add("");
		rowR.add(cashFlow.getNoDocRef());
		rowR.add(cashFlow.getNoVoucher());
            rowR.add(cashFlow.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowR.add(cashFlow.getNamaPerkiraan()) ; 
            rowR.add(cashFlow.getKeterangan()) ; // cashFlow.getKeterangan());
		rowR.add(""+cashFlow.getValue()); 
            //rowR.add(formatStringNumber(cashFlow.getValue(), frmHandler));
			vecDbt.add(rowR);

            totalTambah += cashFlow.getValue();
        }
		vectDataToReport.add(vecDbt);
		
        rowx = new Vector();
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("<b>SUB TOTAL "+strTitle[language][4]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalTambah, "##,###")+"</b></div>");
        //rowx.add("<div align=\"right\"><b>"+formatStringNumber(totalTambah, frmHandler)+"</b></div>");
        lstData.add(rowx);
		
		//for report
		rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("SUB TOTAL "+strTitle[language][4]);
	  rowR.add(""+totalTambah);
        //rowR.add(formatStringNumber(totalTambah, frmHandler));
	  vectDataToReport.add(rowR);

        // ------------------------


        // pengurangan
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

		vectDataToReport.add(rowR);
	 	
        Vector listKredit = (Vector)objectClass.get(1);
	  Vector vecKrt = new Vector();
	  
        for (int i = 0; i < listKredit.size(); i++) {           
            CashFlow cashFlowKredit = (CashFlow)listKredit.get(i);           

            rowx = new Vector();
            //rowx.add(cashFlowKredit.getTglTransaksi());
		rowx.add("<div align=\"center\">"+Formater.formatDate(cashFlowKredit.getTglTransaksi(), "dd MMM yyyy")+"</div>");
		rowx.add(cashFlowKredit.getNoDocRef());
		rowx.add(cashFlowKredit.getNoVoucher());
            rowx.add(cashFlowKredit.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowx.add(cashFlowKredit.getNamaPerkiraan()) ; 
            rowx.add(cashFlowKredit.getKeterangan()) ; // cashFlow.getKeterangan());
		rowx.add("<div align=\"right\">"+Formater.formatNumber(cashFlowKredit.getValue(), "##,###")+"</div>");		
            //rowx.add("<div align=\"right\">"+formatStringNumber(cashFlow.getValue(), frmHandler)+"</div>");
            lstData.add(rowx);
			
			//for report
			rowR = new Vector();
            //rowR.add(cashFlowKredit.getTglTransaksi());
		rowR.add("<div align=\"center\">"+Formater.formatDate(cashFlowKredit.getTglTransaksi(), "dd MMM yyyy")+"</div>");
		rowR.add(cashFlowKredit.getNoDocRef());
		rowR.add(cashFlowKredit.getNoVoucher());
            rowR.add(cashFlowKredit.getNoPerkiraan()) ; // cashFlow.getNoVoucher());
		rowR.add(cashFlowKredit.getNamaPerkiraan()) ; 
            rowR.add(cashFlowKredit.getKeterangan()) ; // cashFlow.getKeterangan());
     		rowR.add(""+cashFlowKredit.getValue()); 
            //rowR.add(formatStringNumber(cashFlow.getValue(), frmHandler));
			vecKrt.add(rowR);

            totalKurang += cashFlowKredit.getValue();
        }
		vectDataToReport.add(vecKrt);
		
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("<b>SUB TOTAL "+strTitle[language][5]+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalKurang, "##,###")+"</b></div>");
        //rowx.add("<div align=\"right\"><b>"+formatStringNumber(totalKurang, frmHandler)+"</b></div>");
        lstData.add(rowx);
		
		//report
		rowR = new Vector();
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("");
        rowR.add("SUB TOTAL "+strTitle[language][5]);
        //rowR.add(formatStringNumber(totalKurang, frmHandler));
		vectDataToReport.add(rowR);

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
		vectDataToReport.add(rowR);

        // total
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>SURPLUS (DEFISIT) "+nameperiode+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber((totalTambah - totalKurang), "##,###")+"</b></div>");
        //rowx.add("<div align=\"right\"><b>"+formatStringNumber((totalTambah - totalKurang), frmHandler)+"</b></div>");
        lstData.add(rowx);
		
		//for Report
		rowR = new Vector();
        rowR.add("SURPLUS (DEFISIT) "+nameperiode);
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("");
        //rowR.add(formatStringNumber((totalTambah - totalKurang), frmHandler));
		vectDataToReport.add(rowR);

        // saldo per tgl 1
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>SALDO PER 1 "+nameperiode+"</b>");
        SaldoAkhirPeriode SaldoAkhirPeriode = SessWorkSheet.getSaldoAwal(SessWorkSheet.getOidPeriodeLalu(oidPeriod));
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(SaldoAkhirPeriode.getDebet(), "##,###")+"</b></div>");
        //rowx.add("<div align=\"right\"><b>"+formatStringNumber(SaldoAkhirPeriode.getDebet(), frmHandler)+"</b></div>");
        lstData.add(rowx);
		
		//for report
		rowR = new Vector();
        rowR.add("SALDO PER 1 "+nameperiode);
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("");
        //rowR.add(formatStringNumber(SaldoAkhirPeriode.getDebet(), frmHandler));
		vectDataToReport.add(rowR);

        // saldo per 31
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>SALDO PER 31 "+nameperiode+"</b>");
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(((totalTambah - totalKurang) + SaldoAkhirPeriode.getDebet()), "##,###")+"</b></div>");
       // rowx.add("<div align=\"right\"><b>"+formatStringNumber(((totalTambah - totalKurang) + SaldoAkhirPeriode.getDebet()), frmHandler)+"</b></div>");
        lstData.add(rowx);
		
		//for report
		rowR = new Vector();
        rowR.add("SALDO PER 31 "+nameperiode);
        rowR.add("");
        rowR.add("");
        rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add(""+((totalTambah - totalKurang) + SaldoAkhirPeriode.getDebet()));
        //rowR.add(formatStringNumber(((totalTambah - totalKurang) + SaldoAkhirPeriode.getDebet()), frmHandler));
		vectDataToReport.add(rowR);

        // butgeting
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
   	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>"+strTitle[language][11]+" "+nameperiode+"</b>");
        AisoBudgeting aisoBudgeting = SessWorkSheet.getBudgetAwal(oidPeriod);
	  rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(aisoBudgeting.getBudget(), "##,###")+"</b></div>");
        //rowx.add("<div align=\"right\"><b>"+formatStringNumber(aisoBudgeting.getBudget(), frmHandler)+"</b></div>");
        lstData.add(rowx);
		
		//for report
		rowR = new Vector();
        rowR.add(strTitle[language][11]+" "+nameperiode);
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("");
        //rowR.add(formatStringNumber(aisoBudgeting.getBudget(), frmHandler));
		vectDataToReport.add(rowR);

        // Pencapaian
        rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
	  rowx.add("");
        rowx.add("");
	  rowx.add("<b>"+strTitle[language][12]+"</b>");
        rowx.add(""+(((totalTambah - totalKurang) + SaldoAkhirPeriode.getDebet()) / aisoBudgeting.getBudget()*100));
        //rowx.add("<div align=\"right\"><b>"+formatStringNumber((((totalTambah - totalKurang) + SaldoAkhirPeriode.getDebet()) / aisoBudgeting.getBudget()*100), frmHandler)+" %</b></div>");
        lstData.add(rowx);
		
		//for report
		rowR = new Vector();
        rowR.add(strTitle[language][12]);
        rowR.add("");
        rowR.add("");
	  rowR.add("");
        rowR.add("");
	  rowR.add("");
	  rowR.add("");
        //rowR.add(formatStringNumber((((totalTambah - totalKurang) + SaldoAkhirPeriode.getDebet()) / aisoBudgeting.getBudget()*100), frmHandler)+" %");
		vectDataToReport.add(rowR);
		FLAG_PRINT = 1; 
    } catch(Exception exc) {
		System.out.println(" Error pada method drawListWorkSheet() ==> "+ exc.toString());
		}
	result.add(ctrlist.drawList());
	System.out.println("ctrlist.drawList() ===> "+ctrlist.drawList());			
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
    String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
    Date today = new Date();
	String linkPdf = reportrootfooter+"report.aliranKas.CashFlowDeptPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String linkXls = reportrootfooter+"report.aliranKas.CashFlowDeptXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");

	FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSymbol); 
	frmHandler.setDigitSeparator(sUserDigitGroup);
	
    Vector list = new Vector();
    String nameperiode = "";
    String namedepartment = "";	
    if(iCommand==Command.LIST){
        list = SessCashFlow.getListCashFlow(periodId,oidDepartment);
	  System.out.println("BESAR VECTOR OBJECT CLASS ===> "+list.size());
        try{
            Periode period = PstPeriode.fetchExc(periodId);
            nameperiode = period.getNama();
			namedepartment = PstDepartment.fetchExc(oidDepartment).getDepartment();
        }catch(Exception e){}
    }
	
	// process data on control drawlist
	Vector vectResult = drawListWorkSheet(list, SESS_LANGUAGE,nameperiode,periodId, frmHandler);
	

	String listData = String.valueOf(vectResult.get(0));
	 System.out.println("listData ===> "+listData);
    
	Vector vectDataToReport = (Vector)vectResult.get(1);
	
	Vector vecSess = new Vector();
	vecSess.add(nameperiode);
	vecSess.add(namedepartment);
	vecSess.add(linkPdf);
	vecSess.add(linkXls);
	vecSess.add(vectDataToReport);
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
<html><!-- #BeginTemplate "/Templates/aiso.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">
function report(){
    var val = document.frmTrialBalance.DEPARTMENT.value;
    if(val!=0){
        document.frmTrialBalance.command.value ="<%=Command.LIST%>";
        document.frmTrialBalance.action = "cash_flow_dept.jsp";
        document.frmTrialBalance.submit();
    }else{
        alert('<%=strTitle[SESS_LANGUAGE][10]%>');
        document.frmTrialBalance.DEPARTMENT.focus();
    }
}

function reportPdf(){	 
		var linkPage = "<%=reportroot%>report.aliranKas.CashFlowDeptPdf";       
		window.open(linkPage);  				
}

function printXLS(){
		var linkPage = "<%=reportroot%>report.aliranKas.CashFlowDeptXls";       
		window.open(linkPage);  				
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
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr>
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE">
      <%@ include file = "../main/header.jsp" %>
    </td>
  </tr>
  <tr>
    <td bgcolor="#000099" height="20" ID="MAINMENU">
      <%@ include file = "../main/menumain.jsp" %>
    </td>
  </tr>
  <tr>
    <td valign="top" align="left">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td  class="contenttitle" height="10"><!-- #BeginEditable "contenttitle" -->
            <%=masterTitle[SESS_LANGUAGE]%>&nbsp;&gt;&nbsp;<%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td height="21"><!-- #BeginEditable "content" -->
            <form name="frmTrialBalance" method="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="2">
                    <hr>
                  </td>
                </tr>
              </table>
			  <%if(privView && privSubmit){%>
              <table width="100%" border="0" height="94">
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
                  <td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][9]%></td>
                  <td height="23" width="2%">
                    <div align="center">:</div>
                  </td>
                  <td height="23" width="87%"><%
                  Vector vectDept = new Vector();
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
                  String strSelectedDept = String.valueOf(oidDepartment);
                %>
                <%=ControlCombo.draw("DEPARTMENT", "", null, strSelectedDept, vectDeptKey, vectDeptName)%>
                    </td>
                </tr>
                <tr>
                  <td width="11%" height="23">&nbsp;</td>
                  <td height="23" width="2%">
                    <div align="center"><b></b></div>
                  </td>
                  <td height="23" width="87%"><a href="javascript:report()"><span class="command"><%=strReport%></span></a></td>
                </tr>
                <tr>
                  <td colspan="3" height="2">&nbsp;</td>
                </tr>
                <%if(iCommand==Command.LIST){%>
                <tr>
                  <td colspan="3" height="2">&nbsp;</td><%=listData%>
			<%System.out.println("listData di HTML  ==> "+listData);%>
                </tr>
				<%System.out.println("flag : "+FLAG_PRINT);%>
						<%if(FLAG_PRINT == 1){%>
						<tr>
							<td>
								<table width="18%" border="0" cellspacing="1" cellpadding="1">
								<tr>
									<td width="83%" nowrap><b><a href="javascript:reportPdf()" class="command">Print Laporan</a></b> </td>
									<td width="83%" nowrap><b><a href="javascript:printXLS()" class="command">Export to Excel</a></b> </td>
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
      </table>
    </td>
  </tr>
  <tr>
    <td bgcolor="#000099" height="29">
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>