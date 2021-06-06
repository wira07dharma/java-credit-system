<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>
<!--import aiso-->
<%@ page import = "com.dimata.util.*,
                   com.dimata.aiso.entity.periode.PstPeriode,
                   com.dimata.aiso.entity.periode.Periode,
                   com.dimata.aiso.form.jurnal.CtrlJurnalDetail,
                   com.dimata.aiso.form.jurnal.FrmJurnalDetail,
                   com.dimata.aiso.entity.masterdata.PstPerkiraan,
                   com.dimata.aiso.entity.masterdata.Perkiraan,
			 com.dimata.aiso.entity.jurnal.*,
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
	{"No Voucher","Perkiraan","Periode","Tanggal","Keterangan","Debet","Kredit","Saldo","Anda tidak punya hak akses untuk laporan buku besar !!!","Departemen","Silahkan pilih departemen dulu"," s/d "},
	{"No Voucher","Account","Period","Date","Description","Debet","Credit","Balance","You haven't privilege for accessing general ledger report !!!","Department","Please change department first"," to "}
};

public static final String masterTitle[] = {
	"Laporan","Report"	
};

public static final String listTitle[] = {
	"Buku Besar","General Ledger"	
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
    ctrlist.addHeader(strTitle[language][0],"8%","2","0");
    ctrlist.addHeader(strTitle[language][4],"25%","2","0");
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

    double totalDbt = 0;
    double totalKrdt = 0;
    double saldoAwalDebet = 0;
    double saldoAwalKredit = 0; 
    double sldAwal = 0;   
    String soAwal = "";
	String strAccName = "";
    System.out.println(" startDate="+startDate+" endDate="+endDate);
    GeneralLedger gl = null;
    boolean isSaldoAwal = true;
    try {
        for (int i = 0; i < objectClass.size(); i++) {

            GeneralLedger generalLedger = (GeneralLedger)objectClass.get(i);

		/* 
		   Proses pengambilan saldo awal menggunakan method list milik class PstSaldoAkhirPeriode
		   Penggunaan method ini untuk mengetahui apakah saldo awal bersaldo debet atau kredit,
               hal ini sangat penting karena dalam standar akuntansi posisi saldo awal, diperhitungkan
               misalnya :

			- Untuk account yang saldo normalnya debet tetapi bersaldo kredit maka diperhitungkan
                    sebagai negatip dalam perhitungan selanjutnya kalaupun nilainya positip.
			- Begitu juga untuk account yang saldo normalnya kredit tetapi bersaldo debet maka 
                    diperhitungkan sebagai negatip dalam perhitungan selanjutnya kalaupun nilainya positip.
		   kesalahan dalam penentuan saldo awal akan mengakibatkan kesalahan dalam perhitungan saldo
               akhir begitu seterusnya.
		*/

		//Penentuan string where clause yang menjadi parameter method list

		try{
			String where = PstSaldoAkhirPeriode.fieldNames[PstSaldoAkhirPeriode.FLD_IDPERIODE] + "=" + periodId +
                        " AND " + PstSaldoAkhirPeriode.fieldNames[PstSaldoAkhirPeriode.FLD_IDPERKIRAAN] + "=" + accountId;

			//Deklarasi vector sebagai nilai balik method list

			Vector listSaldoAwal = PstSaldoAkhirPeriode.list(0, 0, where, "");

			//Pengambilan nilai debet atau kredit dari saldo awal dari vector via object saldoAkhirPeriode

			if(listSaldoAwal.size() > 0){
				SaldoAkhirPeriode saldoAkhirPrd = (SaldoAkhirPeriode)listSaldoAwal.get(0);
						saldoAwalDebet = saldoAkhirPrd.getDebet();
						saldoAwalKredit = saldoAkhirPrd.getKredit();
			}

		}catch(Exception e){

			System.out.println("Error.. Pada saat ambil saldo awal ===> "+e.toString());
		}

		if(generalLedger.getTandaDebetKredit()==PstPerkiraan.ACC_DEBETSIGN){
			if(saldoAwalDebet == 0){

				sldAwal = saldoAwalKredit * -1;				
		
			}else{

				sldAwal = saldoAwalDebet;			

			}
		}else{

			if(saldoAwalKredit == 0){

				sldAwal = saldoAwalDebet * -1;			
		
			}else{

				sldAwal = saldoAwalKredit;				

			}
		}		

            Vector rowx = new Vector();
		Vector rowR = new Vector();
            if(generalLedger.getGlDate()!=null&&generalLedger.getGlDate().after(endDate)){
                break;
            }

            if(generalLedger.getGlDate()==null || generalLedger.getGlDate().before(startDate)){
                if(gl==null){
                    gl = new GeneralLedger();
					if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
						strAccName = gl.getAccountNameEnglish();
					else
						strAccName = gl.getGlNama();
				
                    if(generalLedger.getGlDate()!=null){
                        gl.setGlDate(null);
                        gl.setGlDebet(0);
                        gl.setGlKeterangan("Saldo Awal");
                        gl.setGlKredit(0);
                        gl.setGlNama("");
                        /*if(generalLedger.getTandaDebetKredit()==PstPerkiraan.ACC_DEBETSIGN){
                            gl.setGlSaldo(generalLedger.getGlDebet()-generalLedger.getGlKredit());
                        }
                        else{
                            gl.setGlSaldo(generalLedger.getGlKredit()-generalLedger.getGlDebet());
                        }*/
				gl.setGlSaldo(sldAwal);
                        gl.setJurnalOid(0);
                        gl.setNoVoucher("");
                        gl.setTandaDebetKredit(generalLedger.getTandaDebetKredit());
                    }
                    else{
                        gl.setCounter(generalLedger.getCounter());
                        gl.setGlDate(generalLedger.getGlDate());
                        gl.setGlDebet(generalLedger.getGlDebet());
                        gl.setGlKeterangan(generalLedger.getGlKeterangan());
                        gl.setGlKredit(generalLedger.getGlKredit());
                        gl.setGlNama(strAccName);
                        gl.setGlNomor(generalLedger.getGlNomor());
                        gl.setGlSaldo(generalLedger.getGlSaldo());
                        gl.setJurnalOid(generalLedger.getJurnalOid());
                        gl.setNoVoucher(generalLedger.getNoVoucher());
                        gl.setTandaDebetKredit(generalLedger.getTandaDebetKredit());
                    }
                }
                else{
                    gl.setGlSaldo(gl.getGlSaldo()+generalLedger.getGlDebet()-generalLedger.getGlKredit());
                }
            }
            else{
                if(gl!=null&&gl.getGlSaldo()!=0&&isSaldoAwal){
                    rowx.add("");
                    rowx.add("");
                    rowx.add(gl.getGlKeterangan());
                    rowx.add("<div align=\"right\">"+formatStringNumber(gl.getGlDebet(), frmHandler)+"</div>");
                    rowx.add("<div align=\"right\">"+formatStringNumber(gl.getGlKredit(), frmHandler)+"</div>");
                    rowx.add("<div align=\"right\">"+formatStringNumber(gl.getGlSaldo(), frmHandler)+"</div>");

                    //for report
                    rowR.add("");
                    rowR.add("");
                    rowR.add(gl.getGlKeterangan());
                    rowR.add(formatStringNumber(gl.getGlDebet(), frmHandler));
                    rowR.add(formatStringNumber(gl.getGlKredit(), frmHandler));
                    rowR.add(formatStringNumber(gl.getGlSaldo(), frmHandler));

                    lstData.add(rowx);
                    lstLinkData.add(String.valueOf(gl.getJurnalOid()));
                    vectDataToReport.add(rowR);
                    rowx = new Vector();
                    rowR = new Vector();
                    isSaldoAwal = false;
                    FLAG_PRINT = 1;
                }
            }

            if(gl!=null && gl.getGlSaldo()!=0 && isSaldoAwal && i==objectClass.size()-1){
                    rowx.add("");
                    rowx.add("");
                    rowx.add(gl.getGlKeterangan());
                    rowx.add("<div align=\"right\">"+formatStringNumber(gl.getGlDebet(), frmHandler)+"</div>");
                    rowx.add("<div align=\"right\">"+formatStringNumber(gl.getGlKredit(), frmHandler)+"</div>");
                    rowx.add("<div align=\"right\">"+formatStringNumber(gl.getGlSaldo(), frmHandler)+"</div>");

                    //for report
                    rowR.add("");
                    rowR.add("");
                    rowR.add(gl.getGlKeterangan());
                    rowR.add(formatStringNumber(gl.getGlDebet(), frmHandler));
                    rowR.add(formatStringNumber(gl.getGlKredit(), frmHandler));
                    rowR.add(formatStringNumber(gl.getGlSaldo(), frmHandler));

                    lstData.add(rowx);
                    lstLinkData.add(String.valueOf(gl.getJurnalOid()));
                    vectDataToReport.add(rowR);
                    rowx = new Vector();
                    rowR = new Vector();
                    isSaldoAwal = false;
                    FLAG_PRINT = 1;
            }
            if(generalLedger.getGlDate()!=null&&generalLedger.getGlDate().compareTo(startDate)>=0 && generalLedger.getGlDate().compareTo(endDate)<=0){
                rowx.add("<div align=\"center\">"+Formater.formatDate(generalLedger.getGlDate(),"MMM dd, yyyy")+"</div>");
				String strNoVoucher = "";
				if((generalLedger.getNoVoucher()).length() > 4)
					strNoVoucher = generalLedger.getNoVoucher();
				else
					strNoVoucher = generalLedger.getNoVoucher()+"-"+SessJurnal.intToStr(generalLedger.getCounter(),4);
                rowx.add("<div align=\"center\">"+strNoVoucher+"</div>");
                //for report
                rowR.add(Formater.formatDate(generalLedger.getGlDate(),"MMM dd, yyyy"));
                rowR.add(strNoVoucher);


                rowx.add(generalLedger.getGlKeterangan());
                rowx.add("<div align=\"right\">"+Formater.formatNumber(generalLedger.getGlDebet(), "##,###.##")+"</div>");
                rowx.add("<div align=\"right\">"+Formater.formatNumber(generalLedger.getGlKredit(), "##,###.##")+"</div>");
                rowx.add("<div align=\"right\">"+Formater.formatNumber(generalLedger.getGlSaldo(), "##,###.##")+"</div>");


                //for report
                rowR.add(generalLedger.getGlKeterangan());
                rowR.add(Formater.formatNumber(generalLedger.getGlDebet(), "##,###.##"));
                rowR.add(Formater.formatNumber(generalLedger.getGlKredit(), "##,###.##"));
                rowR.add(Formater.formatNumber(generalLedger.getGlSaldo(), "##,###.##"));

                lstData.add(rowx);
                lstLinkData.add(String.valueOf(generalLedger.getJurnalOid()));
                vectDataToReport.add(rowR);
                FLAG_PRINT = 1;
                totalDbt = totalDbt + generalLedger.getGlDebet();
                totalKrdt = totalKrdt + generalLedger.getGlKredit();
            }

        }

        Vector rowx = new Vector();
        Vector rowR = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("<div align=\"right\"><b>TOTAL</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalDbt, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totalKrdt, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\">&nbsp;</div>");
        lstData.add(rowx);

        rowR.add("");
        rowR.add("");
        rowR.add("TOTAL");
        rowR.add(Formater.formatNumber(totalDbt, "##,###.##"));
        rowR.add(Formater.formatNumber(totalKrdt, "##,###.##"));
        rowR.add("");
        vectDataToReport.add(rowR);

    } catch(Exception exc) {
        System.out.println("err on list : "+exc.toString());
    }

	result.add(ctrlist.draw());
	result.add(vectDataToReport);
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
Date startDate = null;
Date endDate = null;
if(iCommand==Command.LIST){
    startDate = FRMQueryString.requestDate(request,"START_DATE_GL");
    endDate = FRMQueryString.requestDate(request,"END_DATE_GL");
}
Date today = new Date();
String linkPdf = reportrootfooter+"report.bukuBesar.GeneralLedgerPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
String linkXls = reportrootfooter+"report.bukuBesar.GeneralLedgerXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
System.out.println("accountId="+accountId+" periodId="+periodId+" oidDepartment="+oidDepartment+ " startDate="+startDate+" endDate="+endDate);

/**
* Declare Commands caption
*/
String strCheck = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "check" : "cari";
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";

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
	var strUrl = "accountdosearch.jsp?command=<%=Command.FIRST%>"+
				 "&account_group=0"+
				 "&account_number="+document.frmGeneralLedger.ACCOUNT_NUMBER.value+
				 "&account_name="+document.frmGeneralLedger.ACCOUNT_TITLES.value;
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
    var val = document.frmGeneralLedger.DEPARTMENT.value;
    if(val!=0){
        document.frmGeneralLedger.command.value ="<%=Command.LIST%>";
        document.frmGeneralLedger.action = "general_ledger_dept.jsp";
        document.frmGeneralLedger.submit();
    }else{
        alert('<%=strTitle[SESS_LANGUAGE][10]%>');
        document.frmGeneralLedger.DEPARTMENT.focus();
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

function cmdEdit(oid){
	document.frmGeneralLedger.journal_id.value=oid;
	document.frmGeneralLedger.command.value="<%=Command.EDIT%>";
	document.frmGeneralLedger.action="../journal/jumum.jsp";
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
            <%=masterTitle[SESS_LANGUAGE]%>&nbsp;&gt;&nbsp;<%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmGeneralLedger" method="post" action=""> 
			<input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="journal_id" value="0">
             <input type="hidden" name="fromGL" value="true">
			<input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>" value="<%=accountId%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2">&nbsp; 
                  </td>
                </tr>
              </table>
			  <%if(privView && privSubmit){%>						  			  
              <table width="100%" border="0">
                <tr> 
                  <td width="11%" height="23"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td height="23" width="1%" align="center"> : </td>
                  <td height="23" width="88%"> 
                    <input type="text" name="ACCOUNT_NUMBER" size="8" maxlength="10" onblur="javascript:cmdChange()" onKeyDown="javascript:enterTrap()" value="<%=numberP%>">
                    <input type="text" name="ACCOUNT_TITLES" size="60" readonly style="background-color:#E8E8E8" value="<%=namaP%>">
                    &nbsp;<a href="javascript:cmdSearchAccount()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a> 
                  </td>
                </tr>
                <tr>
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td height="20%" width="1%" align="center">:</td>
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
                    Vector vectResult = drawListGeneralLedger(list, SESS_LANGUAGE, frmjurnaldetail,startDate,endDate,accountId,periodId);
                    String listData = String.valueOf(vectResult.get(0));
                    Vector vectDataToReport = (Vector)vectResult.get(1);
                    Vector vecSess = new Vector();
                    vecSess.add(namaP);
                    vecSess.add(nameperiode+" ("+Formater.formatDate(startDate,"dd-MM-yyyy")+strTitle[SESS_LANGUAGE][11]+Formater.formatDate(endDate,"dd-MM-yyyy")+")");
                    vecSess.add(namedepartment);
                    vecSess.add(linkPdf);
                    vecSess.add(vectDataToReport);
                    vecSess.add(linkXls);

                    if(session.getValue("GENERAL_LEDGER")!=null){
                        session.removeValue("GENERAL_LEDGER");
                    }
                    session.putValue("GENERAL_LEDGER",vecSess);
				  %>
                  </td>
                </tr>
                <tr>
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][3]%></td>
                  <td height="20%" width="1%" align="center">:</td>
                  <td height="20%" width="89%">
                  <%=ControlDate.drawDate("START_DATE_GL",startDate,0,yrInterval)%>
                  <%=strTitle[SESS_LANGUAGE][11]%>
                  <%=ControlDate.drawDate("END_DATE_GL",endDate,0,yrInterval)%>
                  </td>
                </tr>
                <tr>
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][9]%></td>
                  <td height="20%" width="1%" align="center">:</td>
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
                <%=ControlCombo.draw("DEPARTMENT", "", null, strSelectedDept, vectDeptKey, vectDeptName)%>
                  </td>
                </tr>
                <tr>
                  <td width="10%" colspan="3" height="20%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="10%" height="20%">&nbsp;</td>
                  <td height="20%" width="1%">
                    <div align="center"></div>
                  </td>
                  <td height="20%" width="89%"><a href="javascript:report()" id="cmd_report"><span class="command"><%=strReport%></span></a> </td>
                </tr>
                <tr>
                  <td colspan="3" height="15">&nbsp;</td>
                </tr>
                <%if(iCommand==Command.LIST){%>
                <tr>
                  <td colspan="3" height="15"><%=listData%></td>
                </tr>
				<%System.out.println("flag : "+FLAG_PRINT);%>
						<%if(FLAG_PRINT == 1){%>
						<tr>
							<td>
								<table width="18%" border="0" cellspacing="1" cellpadding="1">
								<tr>
									<td width="83%" nowrap><b><a href="javascript:reportPdf()" class="command"><%=strCmdPrint[SESS_LANGUAGE]%></a></b> </td>
									<td width="83%" nowrap>&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<b><a href="javascript:printXLS()" class="command"><%=strCmdExport[SESS_LANGUAGE]%></a></b> </td>
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