<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*,
                 com.dimata.util.Formater,
                 com.dimata.util.Command,
                 com.dimata.aiso.entity.report.WorkSheet" %>
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
public static String strTitle[][] = {
	{"Periode","Nomor Perkiraan","Nama Perkiraan","Anggaran","Saldo Awal","Debet",
     "Kredit","Saldo Akhir","Anda tidak punya hak akses untuk laporan neraca percobaan !!!"},

	{"Period","Number","Name","Budget","Fisrt Balance","Debet",
     "Kredit","Last Balance","You haven't privilege for accessing trial balance report !!!"}
};

public static final String masterTitle[] = {
	"Laporan","Report"
};

public static final String listTitle[] = {
	"Neraca Lajur","Work Sheet"
};

public static String formatStringNumber(double dbl){
    if(dbl<0)
        return "("+String.valueOf(FRMHandler.userFormatStringDecimal(dbl * -1))+")";
    else
        return String.valueOf(FRMHandler.userFormatStringDecimal(dbl));
}
    /** gadnyana
     * untuk menampilkan trial balance
     * @param objectClass
     * @param language
     * @return
     */
public String drawListWorkSheet(Vector objectClass, int language){
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("97%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
    ctrlist.setHeaderStyle("listgentitle");
    ctrlist.addHeader(strTitle[language][1],"8%","2","0");
    ctrlist.addHeader(strTitle[language][2],"20%","2","0");
    ctrlist.addHeader(strTitle[language][3],"8%","2","0");

    // neraca periode lalu
    ctrlist.addHeader("Neraca Periode Lalu","10%","0","2");
    // mutasi periode terselect
    ctrlist.addHeader("Mutasi","10%","0","2");
    // mutasi neraca saldo
    ctrlist.addHeader("Neraca Saldo","10%","0","2");
    // mutasi laba rugi
    ctrlist.addHeader("Laba(Rugi)","10%","0","2");
    // mutasi neraca
    ctrlist.addHeader("Neraca","10%","0","2");

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

    try {
        for (int i = 0; i < objectClass.size(); i++) {
            WorkSheet workSheet = (WorkSheet)objectClass.get(i);
            Vector rowx = new Vector();

            rowx.add(String.valueOf(workSheet.getNomorPerkiraan()));
            rowx.add(String.valueOf(workSheet.getNamaPerkiraan()));
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getAnggaran())+"</div>");

            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getDebetNeracaPeriodeLalu())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getKreditNeracaPeriodeLalu())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getDebetMutasi())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getKreditMutasi())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getDebetNeracaSaldo())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getKreditNeracaSaldo())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getDebetLabaRugi())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getKreditLabaRugi())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getDebetNeraca())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(workSheet.getKreditNeraca())+"</div>");

            lstData.add(rowx);

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

        Vector rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
        lstData.add(rowx);

        rowx = new Vector();
        rowx.add("");
        rowx.add("<b>Sub Total :</b>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totAnggaran)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totDbtNeracaSaldoPeridLalu)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totKrdNeracaSaldoPeridLalu)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totDbtMutasi)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totKrdtMutasi)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totDbtNeracaSaldo)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totKrdtNeracaSaldo)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totDbtLabaRugi)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totKdrtLabaRugi)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totDbtNeraca)+"</b></div>");
        rowx.add("<div align=\"right\"><b>"+formatStringNumber(totKrdtNeraca)+"</b></div>");

        lstData.add(rowx);

    } catch(Exception exc) {}
    return ctrlist.drawList();
}

%>

<!-- JSP Block -->
<%

    int iCommand = FRMQueryString.requestCommand(request);
    long periodId = FRMQueryString.requestLong(request,SessWorkSheet.FRM_NAMA_PERIODE);

    Vector list = new Vector();
    if(iCommand==Command.LIST)
        list = SessWorkSheet.getListWorkSheet(periodId,accountingBookType);


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
    document.frmTrialBalance.command.value ="<%=Command.LIST%>";
    document.frmTrialBalance.action = "worksheet.jsp";
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
                  <td colspan="3" height="2">&nbsp;</td><%=drawListWorkSheet(list, SESS_LANGUAGE)%>
                </tr>
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