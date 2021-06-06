<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*,
                 com.dimata.aiso.entity.report.TrialBalance,
                 com.dimata.util.Formater,
                 com.dimata.util.Command,
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
	{"Periode","Nomor","Nama","Anggaran","Saldo Awal","Debet","Kredit",
	"Saldo Akhir","Data tidak ditemukan. Silahkan periksa kembali data",
	"Departemen","Silahkan pilih departemen dulu","Mutasi","Perkiraan"},

	{"Period","Code","Name","Budget","First Balance","Debet","Credit",
	"Last Balance","Data not found. Please check data and try again.",
	"Department","Please change department first","Movement","Account"}
};

public static final String masterTitle[] = {
	"Laporan","Report"
};

public static final String listTitle[] = {
	"Neraca Percobaan","Trial Balance"
};

public static final String strTitleReportPdf[][] = {
	{"LAPORAN NERACA PERCOBAAN","PERIODE"},
	{"TRIAL BALANCE","PERIOD"}
};

public static final String strHeaderReportPdf[][] = {
	{"PERKIRAAN","NOMOR","NAMA","ANGGARAN","SALDO AWAL","MUTASI","SALDO AKHIR","DEBET","KREDIT"},
	{"ACCOUNT","CODE","NAME","BUDGET","FIRST BALANCE","MOVEMENT","LAST BALANCE","DEBET","CREDIT"}	
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
public Vector drawListTrialBalance(Vector objectClass, int language, FRMHandler frmHandler){
	Vector result = new Vector(1,1);
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("100%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");
    ctrlist.addHeader(strTitle[language][12],"6%","0","2");
    ctrlist.addHeader(strTitle[language][1],"8%","0","0");
    ctrlist.addHeader(strTitle[language][2],"25%","0","0");
	ctrlist.addHeader(strTitle[language][3],"8%","2","0");
    ctrlist.addHeader(strTitle[language][4],"8%","2","0");
    ctrlist.addHeader(strTitle[language][11],"30%","0","2");
    ctrlist.addHeader(strTitle[language][5],"8%","0","0");
    ctrlist.addHeader(strTitle[language][6],"8%","0","0");
    ctrlist.addHeader(strTitle[language][7],"8%","2","0");

    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();
	
	// vector of data will used in pdf and xls report
	Vector vectDataToReport = new Vector();
	int iExistingData = 0; 
    double totAngga = 0.0;
    double totSaldoAwal = 0.0;
    double totdebet = 0.0;
    double totKredit = 0.0;
    double totAkhir = 0.0;
	String strAccName = "";
	String strSaldoAkhir = "";
	String strSaldoAwal = "";
	String strTotalAwal = "";
	String strTotalAkhir = "";
    try {
		Vector vecTrial = new Vector();
        for (int i = 0; i < objectClass.size(); i++) {
            TrialBalance trialBaLance = (TrialBalance)objectClass.get(i);
            Vector rowx = new Vector();
			Vector rowR = new Vector();

			if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
				strAccName = trialBaLance.getAccountNameEnglish();
				else
				strAccName = trialBaLance.getNama();
				
				
			if(trialBaLance.getSaldoAkhir() < 0)
				strSaldoAkhir = "("+Formater.formatNumber((trialBaLance.getSaldoAkhir() * -1), "##,###.##")+")";
				else
				strSaldoAkhir = Formater.formatNumber(trialBaLance.getSaldoAkhir(), "##,###.##");
				
			if(trialBaLance.getSaldoAwal() < 0)
				strSaldoAwal = "("+Formater.formatNumber(trialBaLance.getSaldoAwal() * -1, "##,###.##")+")";
				else
				strSaldoAwal = Formater.formatNumber(trialBaLance.getSaldoAwal(), "##,###.##");
				
            rowx.add("<div align=\"center\">"+String.valueOf(trialBaLance.getNomor())+"</div>");
            rowx.add(String.valueOf(strAccName));
            rowx.add("<div align=\"right\">"+Formater.formatNumber(trialBaLance.getAnggaran(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+strSaldoAwal+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(trialBaLance.getDebet(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+Formater.formatNumber(trialBaLance.getKredit(), "##,###.##")+"</div>");
            rowx.add("<div align=\"right\">"+strSaldoAkhir+"</div>");
            lstData.add(rowx);

			//for report
			rowR.add(String.valueOf(trialBaLance.getNomor()));
            rowR.add(String.valueOf(strAccName));
            rowR.add(Formater.formatNumber(trialBaLance.getAnggaran(), "##,###.##"));
            rowR.add(strSaldoAwal);
            rowR.add(Formater.formatNumber(trialBaLance.getDebet(), "##,###.##"));
            rowR.add(Formater.formatNumber(trialBaLance.getKredit(), "##,###.##"));
            rowR.add(strSaldoAkhir);
            vecTrial.add(rowR);
			
            totAngga += trialBaLance.getAnggaran();
            totSaldoAwal += trialBaLance.getSaldoAwal();
            totdebet += trialBaLance.getDebet();
            totKredit += trialBaLance.getKredit();
            totAkhir += trialBaLance.getSaldoAkhir();
			
			if(totAkhir < 0)
				strTotalAkhir = "("+Formater.formatNumber((totAkhir * -1), "##,###.##")+")";
				else
				strTotalAkhir = Formater.formatNumber(totAkhir, "##,###.##");
				
			if(totSaldoAwal < 0)
				strTotalAwal = "("+Formater.formatNumber((totSaldoAwal * -1), "##,###.##")+")";
				else
				strTotalAwal = Formater.formatNumber(totSaldoAwal, "##,###.##");
        }
		vectDataToReport.add(vecTrial);
		
        Vector rowx = new Vector();
        rowx.add("");
        rowx.add("<div align=\"center\"><b>TOTAL</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totAngga, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+strTotalAwal+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totdebet, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+Formater.formatNumber(totKredit, "##,###.##")+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+strTotalAkhir+"</b></div>");
        lstData.add(rowx);
		
		//for report
		Vector rowR = new Vector();
		rowR.add("TOTAL");
        rowR.add(Formater.formatNumber(totAngga, "##,###.##"));
        rowR.add(strTotalAwal);
        rowR.add(Formater.formatNumber(totdebet, "##,###.##"));
        rowR.add(Formater.formatNumber(totKredit, "##,###.##"));
        rowR.add(strTotalAkhir);
        vectDataToReport.add(rowR);
		
		if(totdebet != 0 || totKredit != 0)
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
    long periodId = FRMQueryString.requestLong(request,SessTrialBalance.FRM_NAMA_PERIODE);
    long oidDepartment = FRMQueryString.requestLong(request,"DEPARTMENT");
    String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
	String strCmdPrint[] = {"Cetak Laporan", "Print Report"};
	String strCmdExport[] = {"Ekspor ke Excel", "Export To Excel"};
	String strCmdBack[] = {"Kembali ke Search","Back To Search"};
	String strReportName[] = {"Laporan Neraca Percobaan", "Trial Balance"};
    String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
    Date today = new Date();
	String linkPdf = reportrootfooter+"report.neracaPercobaan.TrialBalanceDeptPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String linkXls = reportrootfooter+"report.neracaPercobaan.TrialBalanceDeptXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String pathImage = reportrootimage +"company121.jpg";
	String nameperiode = "";
	String namedepartment = "";

	FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSymbol); 
	frmHandler.setDigitSeparator(sUserDigitGroup);
	
    Vector list = new Vector();
    if(iCommand==Command.LIST)
        list = SessTrialBalance.getListTrialBalance(periodId,accountingBookType,oidDepartment);
	try{
            Periode period = PstPeriode.fetchExc(periodId);
            nameperiode = period.getNama();
			namedepartment = PstDepartment.fetchExc(oidDepartment).getDepartment();
    }catch(Exception e){}
	// process data on control drawlist
	String sExistData = "";
	int iExistData = 0;
	Vector vectResult = new Vector(1,1);
	String listData = "";
	Vector vectDataToReport = new Vector(1,1);
	if(list != null && list.size() > 0){
		try{
			vectResult = drawListTrialBalance(list, SESS_LANGUAGE, frmHandler);
			if(vectResult != null && vectResult.size() > 0){
				listData = String.valueOf(vectResult.get(0));     
				vectDataToReport = (Vector)vectResult.get(1);
				sExistData = vectResult.get(2).toString();
				iExistData = Integer.parseInt(sExistData);
			}
		}catch(Exception e){
			System.out.println("Exception on drawListTrialBalance ::::: "+e.toString());
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
			
	Vector vecSess = new Vector();
	vecSess.add(String.valueOf(nameperiode));
	vecSess.add(String.valueOf(namedepartment ));
	vecSess.add(linkPdf);
	vecSess.add(linkXls);
	vecSess.add(vectDataToReport);
	vecSess.add(vecTitle);
	vecSess.add(vecHeader);
	vecSess.add(pathImage);
	
	if(session.getValue("TRIAL_BALANCE")!=null){   
		session.removeValue("TRIAL_BALANCE");
	}
	session.putValue("TRIAL_BALANCE",vecSess);

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
    //var val = document.frmTrialBalance.DEPARTMENT.value;
    //if(val!=0){
        document.frmTrialBalance.command.value ="<%=Command.LIST%>";
        document.frmTrialBalance.action = "trial_balance_dept.jsp#down";
        document.frmTrialBalance.submit();
    //}else{
        //alert('<%=strTitle[SESS_LANGUAGE][10]%>');
        //document.frmTrialBalance.DEPARTMENT.focus();
    //}
}

function backToList(){
	document.frmTrialBalance.command.value ="<%=Command.BACK%>";
    document.frmTrialBalance.action = "trial_balance_dept.jsp#up";
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
		var linkPage = "<%=reportroot%>report.neracaPercobaan.TrialBalanceDeptPdf";       
		window.open(linkPage);  				
}

function printXLS(){	 
		var linkPage = "<%=reportroot%>report.neracaPercobaan.TrialBalanceDeptXls";       
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
                <tr><!-- start search -->
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
                      out.println(ControlCombo.draw(SessTrialBalance.FRM_NAMA_PERIODE,"",null,""+periodId,vPeriodKey,vPeriodVal,""));
				  %>
                    </td>
                </tr>
                <tr>
                  <td width="11%" height="23"><%//=strTitle[SESS_LANGUAGE][9]%></td>
                  <td height="23" width="2%">
                    <!-- <div align="center">:</div> -->
                  </td>
                  <td height="23" width="87%">                <%
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
                  <td height="23" colspan="3">&nbsp;</td>
                </tr>
                <tr>
                  <td height="23" colspan="2">                  <!-- <b></b></div>                  <a href="javascript:report()"><span class="command"></span></a> --></td>
                  <td height="23"><input name="button" type="button" onClick="javascript:report()" value="<%=strReport%>"></td>
                </tr><!-- End Search -->
				</table>
				</td>
				</tr>                
                <%if(iCommand==Command.LIST && iExistData > 0){%>
				<tr>
                  <td colspan="3" height="2" id="down"><b><font size="5"><%=strReportName[SESS_LANGUAGE].toUpperCase()%>&nbsp;&nbsp; : &nbsp;&nbsp;<%=nameperiode.toUpperCase()%></font></b></td>
                </tr>
				<tr><td>&nbsp;</td></tr>
                <tr>
                  <td colspan="3" height="2"><%=listData%></td>
                </tr>
						<%if(FLAG_PRINT == 1){%>
						<tr>
						  <td>&nbsp;</td>
			    </tr>
						<tr>
							<td>
								<table width="18%" border="0" cellspacing="1" cellpadding="1">
								<tr>
									<td width="83%" nowrap><input type="button" value="<%=strCmdPrint[SESS_LANGUAGE]%>" onClick="javascript:reportPdf()">&nbsp;&nbsp;<input type="button" value="<%=strCmdExport[SESS_LANGUAGE]%>" onClick="javascript:printXLS()">
									&nbsp;&nbsp;<input type="button" value="<%=strCmdBack[SESS_LANGUAGE]%>" onClick="javascript:backToList()">
									<!-- <b><a href="" class="command"></a></b> --></td>
									<!-- <td width="83%" nowrap><b>| <a href="javascript:printXLS()" class="command"></a></b> </td> -->
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