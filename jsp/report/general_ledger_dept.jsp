<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>
<!--import aiso-->
<%@ page import = "com.dimata.util.*,
                   com.dimata.aiso.entity.periode.PstPeriode, 
                   com.dimata.aiso.entity.periode.Periode,
		   com.dimata.aiso.entity.specialJournal.*,
                   com.dimata.aiso.form.jurnal.CtrlJurnalDetail,
                   com.dimata.aiso.form.jurnal.FrmJurnalDetail,
                   com.dimata.aiso.entity.masterdata.PstPerkiraan,
                   com.dimata.aiso.entity.masterdata.Perkiraan,
		   com.dimata.aiso.entity.jurnal.*,
		   com.dimata.interfaces.journal.*,
                   com.dimata.aiso.session.report.SessGeneralLedger,
                   com.dimata.gui.jsp.ControlCombo,
                   com.dimata.gui.jsp.ControlList,
                   com.dimata.aiso.entity.report.GeneralLedger,
                   com.dimata.harisma.entity.masterdata.PstDepartment,
                   com.dimata.harisma.entity.masterdata.Department,
                   com.dimata.aiso.session.jurnal.SessJurnal,
                   com.dimata.gui.jsp.ControlDate" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_GNR_LEDGER, AppObjInfo.OBJ_REPORT_GNR_LEDGER_PRIV); %>
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
	{"No Voucher","Perkiraan","Periode","Tanggal","Keterangan","Debet","Kredit","Saldo","Data tidak ditemukan. Silahkan periksa kembali data","Departemen","Silahkan pilih perkiraan dulu"," s/d "},
	{"No Voucher","Account","Period","Date","Description","Debet","Credit","Balance","Data not found. Please check data and try again.","Department","Please select chart of Account"," to "}
};

public static final String masterTitle[] = {
	"Laporan","Report"	
};

public static final String listTitle[] = {
	"Buku Besar","General Ledger"	
};

public static final String strTitlePdf[][] = {
	{"LAPORAN BUKU BESAR","PERKIRAAN","PERIODE"},
    {"GENERAL LEDGER","ACCOUNT","PERIOD"}
};

public static final String strHeaderPdf[][] = {
	{"TANGGAL","NO JURNAL","KETERANGAN","DEBET","KREDIT","SALDO"},
    {"DATE","VOUCHER NUMBER","DESCRIPTION","DEBET","CREDIT","BALANCE"}
};

    public static String formatStringNumber(double dbl, FrmJurnalDetail frmHandler){
        if(dbl<0)
            return "("+String.valueOf(frmHandler.userFormatStringDecimal(dbl * -1))+")";
        else
            return String.valueOf(frmHandler.userFormatStringDecimal(dbl));
    }

/**
 * gadnyana
 * @param objectClass
 * @param language
 * @return
 */
public Vector drawListGeneralLedger(Vector objectClass, int language, FrmJurnalDetail frmHandler, Date startDate, Date endDate,long accountId, long periodId){
    Vector result = new Vector(1,1);
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("100%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");
    ctrlist.addHeader(strTitle[language][3],"8%","2","0");
    ctrlist.addHeader(strTitle[language][0],"10%","2","0");
    ctrlist.addHeader(strTitle[language][4],"23%","2","0");
    ctrlist.addHeader(strTitle[language][5],"10%","2","0");
    ctrlist.addHeader(strTitle[language][6],"10%","2","0");
    ctrlist.addHeader(strTitle[language][7],"10%","2","0");

    ctrlist.setLinkRow(1);
    ctrlist.setLinkSufix("");

    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();

    ctrlist.setLinkPrefix("javascript:cmdEdit('");
    ctrlist.setLinkSufix("')");
    ctrlist.reset();

    // vector of data will used in pdf and xls report
    Vector vectDataToReport = new Vector();
    Vector vDataToReportContent = new Vector();
    Vector vDataToReportTotal = new Vector();

    int iExistingData = 0; 
    double totalDbt = 0;
    double totalKrdt = 0;
    double saldoAwalDebet = 0;
    double saldoAwalKredit = 0; 
    double sldAwal = 0;   
    String soAwal = "";
    String saldo = "";
    String strAccName = "";
    String description = "";	    

    GeneralLedger gl = null;
	Periode objPeriode = new Periode();
    boolean isSaldoAwal = true;
	Vector rowx = new Vector(1,1);
	Vector rowR = new Vector(1,1);
	Date startPeriodDate = new Date();
	Date endPeriodDate = new Date();
	GeneralLedger objGL = new GeneralLedger();
	boolean isStartReport = false;
	try {
        for (int i = 0; i < objectClass.size(); i++) {
            GeneralLedger generalLedger = (GeneralLedger)objectClass.get(i);
	    String sLinkData = "";
	    SpecialJournalMain objSPJMain = new SpecialJournalMain();			
	    int iJournalType = 0;
	    int iMountStatus = 0;
	    if(generalLedger.getJurnalOid() != 0){
		    try{
			    objSPJMain = PstSpecialJournalMain.fetchExc(generalLedger.getJurnalOid());
			    iJournalType = objSPJMain.getJournalType();
			    iMountStatus = objSPJMain.getAmountStatus();
		    }catch(Exception e){
			    iJournalType = 0;
			    iMountStatus = 0;
		    }
	    }

	    if(generalLedger.getGlDate() != null){
		    if(generalLedger.getGlDate().compareTo(startDate) >= 0 && generalLedger.getGlDate().compareTo(endDate) <= 0){
			    isStartReport = true;
		    }else{
			    isStartReport = false;
		    }
	    }

	    if(isStartReport){
		    if(i > 0){
			    objGL = (GeneralLedger)objectClass.get(i-1);
		    }
	    }

	    if(periodId != 0){
		    try{
			    objPeriode = PstPeriode.fetchExc(periodId);
			    if(objPeriode != null){
				    startPeriodDate = objPeriode.getTglAwal();
				    endPeriodDate = objPeriode.getTglAkhir();
			    }
		    }catch(Exception e){} 
	    }

	    description = generalLedger.getGlKeterangan();

	    String strNoVoucher = "";
	    if((generalLedger.getNoVoucher()).length() > 4)
		    strNoVoucher = generalLedger.getNoVoucher();
	    else
		    strNoVoucher = generalLedger.getNoVoucher()+"-"+SessJurnal.intToStr(generalLedger.getCounter(),4);	

	    double dSaldo = 0;
	    dSaldo  = generalLedger.getGlSaldo();
	    if(dSaldo >= 0){
		    saldo = Formater.formatNumber(dSaldo, "##,###.##");
	    }else{
		    saldo = "("+Formater.formatNumber((dSaldo * -1), "##,###.##")+")";
	    }
			
             if(isStartReport){
		rowx = new Vector(1,1);
		rowx.add("<div align=\"center\">"+Formater.formatDate(generalLedger.getGlDate(),"MMM dd, yyyy")+"</div>");
                rowx.add("<div align=\"left\">"+strNoVoucher+"</div>");
                rowx.add(description);
                rowx.add("<div align=\"right\">"+Formater.formatNumber(generalLedger.getGlDebet(), "##,###.##")+"</div>");
                rowx.add("<div align=\"right\">"+Formater.formatNumber(generalLedger.getGlKredit(), "##,###.##")+"</div>");
                rowx.add("<div align=\"right\">"+saldo+"</div>");		
				
		//for report
		rowR = new Vector(1,1);
                rowR.add(Formater.formatDate(generalLedger.getGlDate(),"MMM dd, yyyy"));
                rowR.add(strNoVoucher);
                rowR.add(description);
                rowR.add(Formater.formatNumber(generalLedger.getGlDebet(), "##,###.##"));
                rowR.add(Formater.formatNumber(generalLedger.getGlKredit(), "##,###.##"));
                rowR.add(saldo);
				
		sLinkData = String.valueOf(generalLedger.getJurnalOid())+"','"+String.valueOf(iJournalType)+"','"+String.valueOf(iMountStatus);				
                lstData.add(rowx);
                lstLinkData.add(sLinkData);
                vDataToReportContent.add(rowR);
                FLAG_PRINT = 1;
                totalDbt = totalDbt + generalLedger.getGlDebet();
                totalKrdt = totalKrdt + generalLedger.getGlKredit();
            }else{
		if((i==objectClass.size()-1) && (startPeriodDate.compareTo(startDate) == 0) && (endPeriodDate.compareTo(endDate) == 0)){
		    rowx = new Vector(1,1);
		    rowx.add("");
		    rowx.add("");
		    rowx.add("Balance");
		    rowx.add("");
		    rowx.add("");
		    rowx.add("<div align=\"right\">"+saldo+"</div>");

		    //for report
		    rowR = new Vector(1,1);
		    rowR.add("");
		    rowR.add("");
		    rowR.add("Opening Balance");
		    rowR.add("");
		    rowR.add("");
		    rowR.add(saldo);

		    lstData.add(rowx);
		    lstLinkData.add(sLinkData);
		    vDataToReportContent.add(rowR);
		    rowx = new Vector();
		    rowR = new Vector();
		    isSaldoAwal = false;
		    FLAG_PRINT = 1;
		}else{
			if(startDate.after(startPeriodDate)){
				if(isStartReport){
					rowx = new Vector(1,1);
					rowx.add("");
					rowx.add("");
					rowx.add("Balance till "+Formater.formatDate(objGL.getGlDate() == null? new Date() : objGL.getGlDate(),"MMM dd, yyyy"));
					rowx.add("");
					rowx.add("");
					rowx.add("<div align=\"right\">"+objGL.getGlSaldo()+"</div>");

					//for report
					rowR = new Vector(1,1);
					rowR.add("");
					rowR.add("");
					rowR.add("Opening Balance");
					rowR.add("");
					rowR.add("");
					rowR.add(saldo);

					lstData.add(rowx);
					lstLinkData.add(sLinkData);
					vDataToReportContent.add(rowR);
					rowx = new Vector();
					rowR = new Vector();
					isSaldoAwal = false;
					FLAG_PRINT = 1;
				}
			}else{
					if(i == 0){
					rowx = new Vector(1,1);
					rowx.add("");
					rowx.add("");
					rowx.add("Opening Balance");
					rowx.add("");
					rowx.add("");
					rowx.add("<div align=\"right\">"+saldo+"</div>");

					//for report
					rowR = new Vector(1,1);
					rowR.add("");
					rowR.add("");
					rowR.add("Opening Balance");
					rowR.add("");
					rowR.add("");
					rowR.add(saldo);

					lstData.add(rowx);
					lstLinkData.add(sLinkData);
					vDataToReportContent.add(rowR);
					rowx = new Vector();
					rowR = new Vector();
					isSaldoAwal = false;
					FLAG_PRINT = 1;
				}
			}
		}
	}

        }

        rowx = new Vector();
        rowR = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("<div align=\"right\"><b>TOTAL</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalDbt, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalKrdt, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\">&nbsp;</div>");
        lstData.add(rowx);

        rowR.add("TOTAL");
        rowR.add(Formater.formatNumber(totalDbt, "##,###.##"));
        rowR.add(Formater.formatNumber(totalKrdt, "##,###.##"));
        vDataToReportTotal.add(rowR);
	if(totalDbt != 0 || totalKrdt != 0)
		iExistingData = 1; 
    } catch(Exception exc) {
        System.out.println("err on list : "+exc.toString());
    }
	
	result.add(ctrlist.draw());
	result.add(vDataToReportContent);
	result.add(vDataToReportTotal);
	result.add(""+iExistingData);
	return result;
}

%>

<!-- JSP Block -->
<%
int iCommand = FRMQueryString.requestCommand(request);
long accountId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERKIRAAN);
long periodId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERIODE);
String numberP = FRMQueryString.requestString(request,"ACCOUNT_NUMBER");
String namaP = FRMQueryString.requestString(request,"ACCOUNT_TITLES");
long oidDepartment = FRMQueryString.requestLong(request,"DEPARTMENT");
long oidJournal = FRMQueryString.requestLong(request,"journal_id");
Date startDate = null;
Date endDate = null;
if(iCommand==Command.LIST){
    startDate = FRMQueryString.requestDate(request,"START_DATE_GL");
    endDate = FRMQueryString.requestDate(request,"END_DATE_GL");
}
Date today = new Date();
String linkPdf = reportrootfooter+"report.bukuBesar.GeneralLedgerPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
String linkXls = reportrootfooter+"report.bukuBesar.GeneralLedgerXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
String pathImage = reportrootimage+"company121.jpg";

/**
* Declare Commands caption
*/
String strCheck = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "check" : "cari";
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
String strReset = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Reset" : "Kosongkan";
String strBackToSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back to Search" : "Kembali ke Pencarian";

String order = "NOMOR_PERKIRAAN";
String nameperiode = "";
String namedepartment = "";
CtrlJurnalDetail ctrljurnaldetail = new CtrlJurnalDetail(request) ;
FrmJurnalDetail frmjurnaldetail = ctrljurnaldetail.getForm();
frmjurnaldetail.setDecimalSeparator(sUserDecimalSymbol); 
frmjurnaldetail.setDigitSeparator(sUserDigitGroup);
String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
String strCmdPrint[] = {"Cetak Laporan", "Print Report"};
String strCmdExport[] = {"Ekspor ke Excel", "Export To Excel"};
String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];

Vector vectVal = new Vector(1,1);
Vector vectKey = new Vector(1,1);
Vector listAccGroup = AppValue.getVectorAccGroup();				  
if(listAccGroup!=null && listAccGroup.size()>0){
	for(int i=0; i<listAccGroup.size(); i++){
		Vector tempResult = (Vector)listAccGroup.get(i);
		vectVal.add(tempResult.get(0));
		vectKey.add(tempResult.get(1));		
	}
}

    Vector list = new Vector();
    if(iCommand==Command.LIST)
        list = SessGeneralLedger.listGeneralLedger(accountId,periodId,oidDepartment);		
		
	try{
            Periode period = PstPeriode.fetchExc(periodId);
            nameperiode = period.getNama();
	    namedepartment = PstDepartment.fetchExc(oidDepartment).getDepartment();
        }catch(Exception e){}
	

%>
<!-- End of JSP Block -->

<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
function cmdSearchAccount(){
	var strUrl = "accountdosearch.jsp?command=<%=Command.LIST%>"+
		     "&account_group=0"+
		     "&account_number="+document.frmGeneralLedger.ACCOUNT_NUMBER.value;
	popup = window.open(strUrl,"","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
}

function enterTrap(){
	if(event.keyCode==13){
	    document.frmGeneralLedger.command.value ="<%=Command.NONE%>";
	    document.all.cmd_report.focus();
	    cmdChange();
	}
}

function cmdChange(){
	var n = document.frmGeneralLedger.ACCOUNT_NUMBER.value;
	if(n.length>0){
		switch(n){
		<%
		String whrCls = PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE] + "=" + PstPerkiraan.ACC_POSTED;
		String ordCls = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];
		Vector listCode = PstPerkiraan.list(0,0,whrCls,ordCls);
		if(listCode!=null && listCode.size()>0){
			int maxAcc = listCode.size();
			for(int i=0; i<maxAcc; i++){
			Perkiraan rekening = (Perkiraan)listCode.get(i);
		%>
			case "<%=rekening.getNoPerkiraan()%>" :					 			 
				 document.frmGeneralLedger.<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>.value="<%=rekening.getOID()%>";
				 document.frmGeneralLedger.ACCOUNT_TITLES.value="<%=rekening.getNama()%>";			 							
				 break;	
		<%	
			}	
		}
		%>			
			default :
				document.frmGeneralLedger.<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>.value="0";
				document.frmGeneralLedger.ACCOUNT_TITLES.value="No account found for specified number";			 									
				break;
		}
	}else{
		document.frmGeneralLedger.<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>.value="0";
		document.frmGeneralLedger.ACCOUNT_TITLES.value="";
	}
}

function report(){
    var val = document.frmGeneralLedger.ACCOUNT_NUMBER.value;
    if(val!=0){
        document.frmGeneralLedger.command.value ="<%=Command.LIST%>";
        document.frmGeneralLedger.action = "general_ledger_dept.jsp#down";
        document.frmGeneralLedger.submit();
    }else{
        alert('<%=strTitle[SESS_LANGUAGE][10]%>');
        document.frmGeneralLedger.ACCOUNT_NUMBER.focus();
    }
}

function refresh(){
    var val = document.frmGeneralLedger.<%=SessGeneralLedger.FRM_NAMA_PERIODE%>.value;
    if(val!=0){
        document.frmGeneralLedger.command.value ="<%=Command.REFRESH%>";
        document.frmGeneralLedger.action = "general_ledger_dept.jsp";
        document.frmGeneralLedger.submit();
    }
}

function reportPdf(){
		var linkPage = "<%=reportroot%>report.bukuBesar.GeneralLedgerPdf";
		window.open(linkPage);  				
}
function printXLS(){
		var linkPage = "<%=reportroot%>report.bukuBesar.GeneralLedgerXls";
		window.open(linkPage);
}

function cmdEdit(oid,jurnaltype,amountstatus){
	document.frmGeneralLedger.journal_id.value=oid;
	document.frmGeneralLedger.journal_type.value=jurnaltype;
	document.frmGeneralLedger.amount_status.value=amountstatus;
	document.frmGeneralLedger.command.value="<%=Command.EDIT%>";
	
	var jurnaltype = document.frmGeneralLedger.journal_type.value;
	var amountstatus = document.frmGeneralLedger.amount_status.value;
	switch(jurnaltype){
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_CASH%>":	
			document.frmGeneralLedger.action="../specialjournal/cashreceipts/journalmain.jsp";			
	  	break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_BANK%>":
		if(amountstatus == "<%=PstSpecialJournalMain.STS_DEBET%>"){	
			document.frmGeneralLedger.action="../specialjournal/bankdeposite/journalmain.jsp";
		}else{
			document.frmGeneralLedger.action="../specialjournal/bankdraw/journalmain.jsp";
		} 
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_PETTY_CASH%>":	
			document.frmGeneralLedger.action="../specialjournal/pettycash/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_REPLACEMENT%>":	
			document.frmGeneralLedger.action="../specialjournal/pettycashreplacement/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_BANK_TRANSFER%>":	
			document.frmGeneralLedger.action="../specialjournal/banktransfer/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_NON_CASH%>":	
			document.frmGeneralLedger.action="../specialjournal/noncash/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_FUND%>":	
			document.frmGeneralLedger.action="../specialjournal/cashpayment/journalmain.jsp";
		break;
		case "<%=I_JournalType.TIPE_SPECIAL_JOURNAL_PAYMENT%>":	
			document.frmGeneralLedger.action="../specialjournal/payment/journalmain.jsp";
		break;
		default:	
			document.frmGeneralLedger.action="../journal/jumum.jsp";
		break;		
	}
	
	document.frmGeneralLedger.submit();
}

<%if(isUseDatePicker.equalsIgnoreCase("Y")){%>

function getThn()
{
	var date1 = ""+document.frmGeneralLedger.START_DATE_GL.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	//alert("hri = "+hri);
	document.frmGeneralLedger.START_DATE_GL_mn.value=bln;
	document.frmGeneralLedger.START_DATE_GL_dy.value=hri;
	document.frmGeneralLedger.START_DATE_GL_yr.value=thn;
	
	var date2 = ""+document.frmGeneralLedger.END_DATE_GL.value;
	
	var thn2 = date2.substring(6,10);
	
	var bln2 = date2.substring(3,5);	
	if(bln2.charAt(0)=="0"){
		bln2 = ""+bln2.charAt(1);
	}
	
	var hri2 = date2.substring(0,2);
	if(hri2.charAt(0)=="0"){
		hri2 = ""+hri2.charAt(1);
	}
	
	document.frmGeneralLedger.END_DATE_GL_mn.value=bln2;
	document.frmGeneralLedger.END_DATE_GL_dy.value=hri2;
	document.frmGeneralLedger.END_DATE_GL_yr.value=thn2;				
				
}

		function hideObjectForDate(){
									
		}
		
		function showObjectForDate(){
			
		}
<%}%>

function cmdReset(){
	document.frmGeneralLedger.ACCOUNT_NUMBER.value = " ";	
	document.frmGeneralLedger.ACCOUNT_TITLES.value = " ";
}

function cmdBackToSearch(){
	document.frmGeneralLedger.command.value="<%=Command.BACK%>";
	document.frmGeneralLedger.action="general_ledger_dept.jsp#up";
	document.frmGeneralLedger.ACCOUNT_NUMBER.focus();
	cmdReset();	
	document.frmGeneralLedger.submit();
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<SCRIPT language=JavaScript>
</SCRIPT>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="stylesheet" href="../style/calendar.css" type="text/css">
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
            <form name="frmGeneralLedger" method="post" action=""> 
			<input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="journal_id" value="0">
			<input type="hidden" name="journal_type" value="0">
			<input type="hidden" name="amount_status" value="0">
             <input type="hidden" name="fromGL" value="true">
			<input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>" value="<%=accountId%>">
              
			  <%if(privView && privSubmit){%>						  			  
              <table width="100%" cellspacing="0" cellpadding="0">
			  	<tr><td></td></tr>
                <tr> 
                  <td>
				  		<table align="center" width="760" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
							<tr>
								<td>
									<table width="100%" border="0" class="search00">
			  	<tr>
				<td>
				<table width="100%" border="0" class="mainJournalOut">
                <tr>
                  <td height="23" id="up">&nbsp;</td>
                  <td height="23" align="center">&nbsp;</td>
                  <td height="23">&nbsp;</td>
                </tr>
                <tr><!-- begin search --> 
                  <td width="11%" height="23"><b><%=strTitle[SESS_LANGUAGE][1]%></b></td>
                  <td height="23" width="1%" align="center"><strong> : </strong></td>
                  <td height="23" width="88%"> 
                    <input type="text" name="ACCOUNT_NUMBER" size="8" maxlength="10" onblur="javascript:cmdChange()" onKeyDown="javascript:enterTrap()" value="<%=numberP%>">
                    <input type="text" name="ACCOUNT_TITLES" size="60" readonly style="background-color:#E8E8E8" value="<%=namaP%>">
                    &nbsp;<a href="javascript:cmdSearchAccount()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a> 
                  </td>
                </tr>
                <tr>
                  <td width="10%" height="20%"><b><%=strTitle[SESS_LANGUAGE][2]%></b></td>
                  <td height="20%" width="1%" align="center"><strong>:</strong></td>
                  <td height="20%" width="89%">
                  <%
                      Vector vtPeriod = PstPeriode.list(0,0,"",PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL]+" DESC ");
                      Periode lastPeriode = new Periode();
                      Periode firstPeriode = new Periode();
                      Vector vPeriodKey = new Vector(1,1);
                      Vector vPeriodVal = new Vector(1,1);
                      for(int k=0;k<vtPeriod.size();k++){
                        Periode periode = (Periode)vtPeriod.get(k);
                        if(k==0){
                            lastPeriode = periode;
                        }
                        if(k==(vtPeriod.size()-1)){
                            firstPeriode = periode;
                        }
                        vPeriodKey.add(""+periode.getOID());
                        vPeriodVal.add(periode.getNama());
                      }
                      out.println(ControlCombo.draw(SessGeneralLedger.FRM_NAMA_PERIODE,"",null,""+periodId,vPeriodKey,vPeriodVal,"onChange=\"javascript:refresh()\""));
                      if(startDate==null || endDate==null || iCommand==Command.REFRESH){
                          if(periodId>0){
                                try{
                                    Periode periode = PstPeriode.fetchExc(periodId);
                                    startDate = periode.getTglAwal();
                                    endDate = periode.getTglAkhir();
                                    System.out.println("masuk periodeId>0");
                                }
                                catch(Exception e){
                                    System.out.println("masuk err periodeId>0");
                                }
                          }
                          else{
                                startDate = lastPeriode.getTglAwal();
                                endDate = lastPeriode.getTglAkhir();
                                System.out.println("masuk periodeId<=0");
                          }
                      }

                   int yrInterval = 0;
                   yrInterval = firstPeriode.getTglAwal().getYear()-today.getYear();

                    // process data on control drawlist
					String sExistData = "";
					int iExistData = 0;
					Vector vectResult = new Vector(1,1);
					String listData = "";
					Vector vDataToReportContent = new Vector(1,1);
					Vector vDataToReportTotal = new Vector(1,1);
					try{
                    	vectResult = drawListGeneralLedger(list, SESS_LANGUAGE, frmjurnaldetail,startDate,endDate,accountId,periodId);
						if(vectResult != null && vectResult.size() > 0){
							listData = String.valueOf(vectResult.get(0));
                    		vDataToReportContent = (Vector)vectResult.get(1);
							vDataToReportTotal = (Vector)vectResult.get(2);
							sExistData = vectResult.get(3).toString();
							iExistData = Integer.parseInt(sExistData);
						}
					}catch(Exception e){
						System.out.println("Exception on drawListGeneralLedger ::::: "+e.toString());
					}
					
					Vector vTitle = new Vector();
					vTitle.add(strTitlePdf[SESS_LANGUAGE][0]);
					vTitle.add(strTitlePdf[SESS_LANGUAGE][1]);
					vTitle.add(strTitlePdf[SESS_LANGUAGE][2]);
					
					Vector vHeader = new Vector();
					vHeader.add(strHeaderPdf[SESS_LANGUAGE][0]);
					vHeader.add(strHeaderPdf[SESS_LANGUAGE][1]);
					vHeader.add(strHeaderPdf[SESS_LANGUAGE][2]);
					vHeader.add(strHeaderPdf[SESS_LANGUAGE][3]);
					vHeader.add(strHeaderPdf[SESS_LANGUAGE][4]);
					vHeader.add(strHeaderPdf[SESS_LANGUAGE][5]);
					
                    Vector vecSess = new Vector();
                    vecSess.add(namaP);
                    vecSess.add(nameperiode+" ("+Formater.formatDate(startDate,"MMM dd, yyyy")+"    "+strTitle[SESS_LANGUAGE][11]+"    "+Formater.formatDate(endDate,"MMM dd, yyyy")+")");
                    vecSess.add(namedepartment);
                    vecSess.add(linkPdf);
                    vecSess.add(vDataToReportContent);
                    vecSess.add(linkXls);
					vecSess.add(vTitle);
					vecSess.add(vHeader);
					vecSess.add(vDataToReportTotal);
					vecSess.add(pathImage);
					
                    if(session.getValue("GENERAL_LEDGER")!=null){
                        session.removeValue("GENERAL_LEDGER");
                    }
                    session.putValue("GENERAL_LEDGER",vecSess);
					
					
				  %>
                  </td>
                </tr>
                <tr>
                  <td width="10%" height="20%"><b><%=strTitle[SESS_LANGUAGE][3]%></b></td>
                  <td height="20%" width="1%" align="center"><strong>:</strong></td>
                  <td height="20%" width="89%">
				  <%if(isUseDatePicker.equalsIgnoreCase("Y")){%>										   										   
										  <input onClick="ds_sh(this);" name="START_DATE_GL" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate(startDate, "dd-MM-yyyy")%>"/> 						  
										  <input type="hidden" name="START_DATE_GL_mn">
										  <input type="hidden" name="START_DATE_GL_dy">
										  <input type="hidden" name="START_DATE_GL_yr">
										  
										  <%}%>
                  <%//=ControlDate.drawDate("START_DATE_GL",startDate,0,yrInterval)%>
                  <%=strTitle[SESS_LANGUAGE][11]%>&nbsp;&nbsp;
				  <%if(isUseDatePicker.equalsIgnoreCase("Y")){%>										   										   
										  <input onClick="ds_sh(this);" name="END_DATE_GL" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate(endDate, "dd-MM-yyyy")%>"/> 						  
										  <input type="hidden" name="END_DATE_GL_mn">
										  <input type="hidden" name="END_DATE_GL_dy">
										  <input type="hidden" name="END_DATE_GL_yr">
										  <script language="JavaScript" type="text/JavaScript">getThn();</script>
										  <%}%>
                  <%//=ControlDate.drawDate("END_DATE_GL",endDate,0,yrInterval)%>
                  </td>
                </tr>
                <tr>
                  <td width="10%" height="20%"><%//=strTitle[SESS_LANGUAGE][9]%></td>
                  <td height="20%" width="1%" align="center"></td>
                  <td height="20%" width="89%">
                <%
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
                 for (int deptNum = 0; deptNum < iDeptSize; deptNum++){
                     Department dept = (Department) vectDept.get(deptNum);
                     vectDeptKey.add(String.valueOf(dept.getOID()));
                     vectDeptName.add(dept.getDepartment());

                 }
                 String strSelectedDept = String.valueOf(oidDepartment);
                 if(oidDepartment==0 && iDeptSize==1){
                    strSelectedDept = String.valueOf(vectDeptKey.get(0));
                 }
                %>
                <%//=ControlCombo.draw("DEPARTMENT", "", null, strSelectedDept, vectDeptKey, vectDeptName)%>
                  </td>
                </tr><!-- end search -->
				
                <tr>
                  <td width="10%" colspan="3" height="20%">&nbsp;</td>
                </tr>
                <tr>
                  <td  height="20%" colspan="3">
                  <div align="center"></div><input type="button" id="cmd_report" value="<%=strReport%>" onClick="javascript:report()">&nbsp;&nbsp;<input type="button" id="cmd_report" value="<%=strReset%>" onClick="javascript:cmdReset()"><!--  <a href="javascript:report()" id="cmd_report"><span class="command"><%//=strReport%></span></a> --> </td>
                </tr>
				</table>
				</td>
				</tr>
                <tr>
                  <td colspan="3" height="15">&nbsp;</td>
                </tr>
                <%if(iCommand==Command.LIST && iExistData > 0){%>				
		    <tr>
			<td colspan="3" id="down"><b><%=listTitle[SESS_LANGUAGE]%> : </b><%=numberP%> - <%=namaP%></td>
		    </tr>	
                <tr>
                  <td colspan="3" height="15" >&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="3" height="15" ><%=listData%></td>
                </tr>				
						<%if(FLAG_PRINT == 1){%>
						<tr>
						  <td>&nbsp;</td>
						</tr>
						<tr>
							<td>
								<table width="18%" border="0" cellspacing="1" cellpadding="1">
								<tr>
									<td width="83%" nowrap><input type="button" value="<%=strCmdPrint[SESS_LANGUAGE]%>" onClick="javascript:reportPdf()"><!-- <b><a href="javascript:reportPdf()" class="command"><%//=strCmdPrint[SESS_LANGUAGE]%></a></b> --></td>
									<td width="83%" nowrap>&nbsp;&nbsp;<input type="button" value="<%=strCmdExport[SESS_LANGUAGE]%>" onClick="javascript:printXLS()"><!-- <b><a href="javascript:printXLS()" class="command"><%//=strCmdExport[SESS_LANGUAGE]%></a></b> --></td>
									<td width="83%" nowrap>&nbsp;&nbsp;<input type="button" id="cmd_report" value="<%=strBackToSearch%>" onClick="javascript:cmdBackToSearch()"><!-- <b><a href="javascript:printXLS()" class="command"><%//=strCmdExport[SESS_LANGUAGE]%></a></b> --></td>

								</tr>
								</table>
							</td>
						</tr>
						<%}%>               			
              		</table>
								</td>
							</tr>
						</table>
                  </td>
                </tr>
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
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][8]%></i></font></td>
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