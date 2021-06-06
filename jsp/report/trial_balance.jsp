<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*,
                 com.dimata.aiso.entity.report.TrialBalance,
                 com.dimata.util.Formater,
                 com.dimata.util.Command" %>
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
	{"Periode","Nomor Perkiraan","Nama Perkiraan","Anggaran","Saldo Awal","Debet","Kredit","Saldo Akhir","Anda tidak punya hak akses untuk laporan neraca percobaan !!!"},

	{"Period","Number","Name","Budget","Fisrt Balance","Debet","Kredit","Last Balance","You haven't privilege for accessing trial balance report !!!"}
};

public static final String masterTitle[] = {
	"Laporan","Report"
};

public static final String listTitle[] = {
	"Neraca Percobaan","Trial Balance"
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
public String drawListTrialBalance(Vector objectClass, int language){
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("97%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
    ctrlist.setHeaderStyle("listgentitle");
    ctrlist.addHeader(strTitle[language][1],"10%","2","0");
    ctrlist.addHeader(strTitle[language][2],"25%","2","0");
    ctrlist.addHeader(strTitle[language][3],"10%","2","0");
    ctrlist.addHeader(strTitle[language][4],"10%","2","0");
    ctrlist.addHeader("Mutasi","30%","0","2");
    ctrlist.addHeader(strTitle[language][5],"8%","0","0");
    ctrlist.addHeader(strTitle[language][6],"8%","0","0");
    ctrlist.addHeader(strTitle[language][7],"8%","2","0");

    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();
    try {
        for (int i = 0; i < objectClass.size(); i++) {
            TrialBalance trialBaLance = (TrialBalance)objectClass.get(i);
            Vector rowx = new Vector();

            rowx.add(String.valueOf(trialBaLance.getNomor()));
            rowx.add(String.valueOf(trialBaLance.getNama()));
            rowx.add("<div align=\"right\">"+formatStringNumber(trialBaLance.getAnggaran())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(trialBaLance.getSaldoAwal())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(trialBaLance.getDebet())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(trialBaLance.getKredit())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(trialBaLance.getSaldoAkhir())+"</div>");

            lstData.add(rowx);
        }
    } catch(Exception exc) {}
    return ctrlist.drawList();
}

%>

<!-- JSP Block -->
<%

    int iCommand = FRMQueryString.requestCommand(request);
    long periodId = FRMQueryString.requestLong(request,SessTrialBalance.FRM_NAMA_PERIODE);

    Vector list = new Vector();
    if(iCommand==Command.LIST)
        list = SessTrialBalance.getListTrialBalance(periodId,accountingBookType);


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
    document.frmTrialBalance.command.value ="<%=Command.LIST%>";
    document.frmTrialBalance.action = "trial_balance.jsp";
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
                      out.println(ControlCombo.draw(SessTrialBalance.FRM_NAMA_PERIODE,"",null,""+periodId,vPeriodKey,vPeriodVal,""));
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
                  <td colspan="3" height="2">&nbsp;</td><%=drawListTrialBalance(list, SESS_LANGUAGE)%>
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