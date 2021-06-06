<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.entity.search.SrcOrderAktiva,
                 com.dimata.aiso.form.search.FrmSrcOrderAktiva,
                 com.dimata.util.Command,
                 com.dimata.aiso.form.aktiva.CtrlOrderAktiva,
                 com.dimata.util.Formater,
                 com.dimata.aiso.entity.arap.ArApMain,
                 com.dimata.aiso.entity.search.SrcArApEntry,
                 com.dimata.aiso.form.search.FrmSrcArApEntry,
                 com.dimata.aiso.session.arap.SessArApEntry,
                 com.dimata.aiso.form.arap.CtrlArApMain,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.aiso.entity.report.ArApPerContact,
                 com.dimata.aiso.form.search.FrmSrcArApReport,
                 com.dimata.aiso.entity.search.SrcArApReport,
                 com.dimata.aiso.session.arap.SessArApReport,
                 com.dimata.aiso.entity.report.ArApPerDueDate" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privSubmit){
%>

<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>

<!-- if of "has access" condition -->
<%
}
else
{
%>

<!-- JSP Block -->
<%!

public static String strTitle[][] = 
{
	{
		"No.",
		"Kontak",
		"Awal",
        "Penambahan",
        "Pembayaran",
        "Akhir",
        "Mutasi",
        "Tidak ada data sesuai yang ditemukan",
        "Tanggal Jatuh Tempo",
        "Hutang",
        "Piutang",
        "Selisih",
        "Tanggal",
        "s/d"
	},
	{
		"No.",
        "Contact",
        "Prev Balance",
        "Increment",
        "Payment",
        "Balance",
        "Mutation",
        "List is empty",
        "Due Date",
        "Payable",
        "Receivable",
        "Differ",
        "Date",
        "to"
	}
};

public static final String masterTitle[] =
{
    "Laporan",
	"Report"
};

public static final String listTitle[][] =
{
    {"Daftar Piutang per Debitur",
	"List Receivable per Debitor"
    }
    ,
    {"Daftar Hutang per Kreditur",
	"List Payable per Creditor"
    }
    ,
    {"Hutang Piutang per Jatuh Tempo",
     "Receivable Payable per Due Date"
    }
};

public String listDrawArApReport(FRMHandler objFRMHandler, Vector list, int language, int type)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("95%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

    if(type != SessArApReport.ARAP_REPORT_PER_DUE_DATE){
        ctrlist.dataFormat(strTitle[language][0],"5%","2","0","center","right");
        ctrlist.dataFormat(strTitle[language][1],"30%","2","0","center","left");
        ctrlist.dataFormat(strTitle[language][2],"15%","2","0","center","right");
        ctrlist.dataFormat(strTitle[language][6],"30%","0","2","center","center");
        ctrlist.dataFormat(strTitle[language][5],"15%","2","0","center","right");
        ctrlist.dataFormat(strTitle[language][3],"15%","0","0","center","right");
        ctrlist.dataFormat(strTitle[language][4],"15%","0","0","center","right");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");

        Vector lstData = ctrlist.getData();

        ctrlist.reset();
        int index = -1;
        try{
            int size = list.size();
            double totalPrev = 0;
            double totalInc = 0;
            double totalDec = 0;
            for (int i=0; i < size; i++){
                System.out.println("ini yang ke "+i);
                ArApPerContact arApReport = (ArApPerContact)list.get(i);

                Vector rowx = new Vector();
                rowx.add((i+1)+" ");
                rowx.add(cekNull(arApReport.getContactName()));
                rowx.add(FRMHandler.userFormatStringDecimal(arApReport.getPrevBalance()));
                rowx.add(FRMHandler.userFormatStringDecimal(arApReport.getIncrement()));
                rowx.add(FRMHandler.userFormatStringDecimal(arApReport.getDecrement()));
                rowx.add(FRMHandler.userFormatStringDecimal(arApReport.getBalance()));
                totalPrev = totalPrev + arApReport.getPrevBalance();
                totalInc = totalInc + arApReport.getIncrement();
                totalDec = totalDec + arApReport.getDecrement();
                lstData.add(rowx);
            }

            Vector rowx = new Vector();
            rowx.add(" ");
            rowx.add("<b>TOTAL</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(totalPrev)+"</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(totalInc)+"</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(totalDec)+"</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal((totalPrev+totalInc-totalDec))+"</b>");
            lstData.add(rowx);
         }catch(Exception e){
            System.out.println("EXc : "+e.toString());
         }
        return ctrlist.drawMeList();
    }
    else{
        ctrlist.setAreaWidth("70%");
        ctrlist.dataFormat(strTitle[language][0],"5%","center","right");
        ctrlist.dataFormat(strTitle[language][8],"15%","center","left");
        ctrlist.dataFormat(strTitle[language][9],"15%","center","right");
        ctrlist.dataFormat(strTitle[language][10],"15%","center","right");
        ctrlist.dataFormat(strTitle[language][11],"20%","center","right");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");

        Vector lstData = ctrlist.getData();

        ctrlist.reset();
        int index = -1;
        try{
            int size = list.size();
            double totalInc = 0;
            double totalDec = 0;
            String pref = "";
            String suf = "";
            int mul = 1;
            for (int i=0; i < size; i++){
                System.out.println("ini yang ke "+i);
                ArApPerDueDate arApReport = (ArApPerDueDate)list.get(i);
                pref = "";
                suf = "";
                mul = 1;
                Vector rowx = new Vector();
                rowx.add((i+1)+"&nbsp;");
                rowx.add("&nbsp;&nbsp;&nbsp;"+Formater.formatDate(arApReport.getDueDate(),"dd-MMMMM-yyyy"));
                rowx.add(FRMHandler.userFormatStringDecimal(arApReport.getPayable()));
                rowx.add(FRMHandler.userFormatStringDecimal(arApReport.getReceivable()));
                if(arApReport.getDiffer()<0){
                    pref = "(";
                    suf = ")";
                    mul = -1;
                }
                rowx.add(pref+FRMHandler.userFormatStringDecimal(arApReport.getDiffer()*mul)+suf);
                totalInc = totalInc + arApReport.getReceivable();
                totalDec = totalDec + arApReport.getPayable();
                lstData.add(rowx);
            }
            System.out.println("ini yang ke akhir");
            Vector rowx = new Vector();
            rowx.add(" ");
            rowx.add("<b>TOTAL</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(totalDec)+"</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(totalInc)+"</b>");
            if((totalInc-totalDec)<0){
                    pref = "(";
                    suf = ")";
                    mul = -1;
            }
            else{
                    pref = "";
                    suf = "";
                    mul = 1;
            }
            rowx.add("<b>"+pref+FRMHandler.userFormatStringDecimal((totalInc-totalDec)*mul)+suf+"</b>");
            lstData.add(rowx);
         }catch(Exception e){
            System.out.println("EXc : "+e.toString());
         }
        return ctrlist.drawMe();
    }

}



public String cekNull(String val){
	if(val==null || val.length()==0)
		val = "-";
	return val;
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
SrcArApReport srcArApReport = new SrcArApReport();
FrmSrcArApReport frmSrcArApReport = new FrmSrcArApReport(request);
frmSrcArApReport.requestEntityObject(srcArApReport);


// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.setLanguage(SESS_LANGUAGE);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Report Search" : "Kembali Ke Pencarian Laporan";
String strPrint = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Print Report" : "Cetak Laporan";

try{
	session.removeValue(SessArApReport.SESS_SEARCH_ARAP_REPORT);
}catch(Exception e){
	System.out.println("--- Remove session error ---");
}

if(srcArApReport==null){
	srcArApReport = new SrcArApReport();
} 

session.putValue(SessArApReport.SESS_SEARCH_ARAP_REPORT, srcArApReport);

    //System.out.println("--- Remove session error ---");
Vector listArApReport = new Vector();
Vector vectReportPrint = new Vector();

if(srcArApReport.getFromDate()!=null){
    switch(srcArApReport.getReportType()){
        case SessArApReport.AR_REPORT_PER_DEBITOR :
            listArApReport = SessArApReport.listArReport(srcArApReport);
            break;
        case SessArApReport.AP_REPORT_PER_CREDITOR :
            listArApReport = SessArApReport.listApReport(srcArApReport);
            break;
        case SessArApReport.ARAP_REPORT_PER_DUE_DATE:
            listArApReport = SessArApReport.listArApPerDueDate(srcArApReport);
            break;
        default:
            break;
    }
}

// session for printing pdf
String linkPdf = reportrootfooter+"report.arap.ArApReportPdf";
srcArApReport.setReportLink(linkPdf);
srcArApReport.setLanguage(SESS_LANGUAGE);
vectReportPrint.add(srcArApReport);
vectReportPrint.add(listArApReport);
try{
	session.removeValue(SessArApReport.SESS_SEARCH_ARAP);
}catch(Exception e){
	System.out.println("--- Remove session error ---");
}

session.putValue(SessArApReport.SESS_SEARCH_ARAP, vectReportPrint);

// end session for printing

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">

function cmdBack(){
	document.frmsrcarapentry.command.value="<%=Command.BACK%>";
	document.frmsrcarapentry.action="arap_report_search.jsp";
	document.frmsrcarapentry.submit();
}

function reportPdf(){
		var linkPage = "<%=reportroot%>report.arap.ArApReportPdf";
		window.open(linkPage);
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[srcArApReport.getReportType()][SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 

            <form name="frmsrcarapentry" method="post" action="">
              <input type="hidden" name="arap_main_id" value="0">
              <input type="hidden" name="add_type" value="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <table width="75%" border="0">
               <tr>
                <td width="19%">&nbsp;</td>
                <td width="2%">
                  <div align="center">&nbsp;</div>
                </td>
                <td width="79%">&nbsp;</td>
              </tr>
              <tr>
                <td width="19%"><b><%=strTitle[SESS_LANGUAGE][12]%></b></td>
                <td width="2%">
                  <div align="center">:</div>
                </td>
                <td width="79%"><b><%=Formater.formatDate(srcArApReport.getFromDate(),"dd-MMM-yyyy")%>&nbsp;<%=strTitle[SESS_LANGUAGE][13]%>&nbsp;<%=Formater.formatDate(srcArApReport.getUntilDate(),"dd-MMM-yyyy")%></b></td>
              </tr>

            </table>
                <%if((listArApReport!=null)&&(!listArApReport.isEmpty())){ %>
                  <%
                    System.out.println("INI ARAP COUNT "+listArApReport.size());
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(listDrawArApReport(objFRMHandler,listArApReport,SESS_LANGUAGE,srcArApReport.getReportType()));
				 } else {%>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">				
                <tr> 
                  <td><span class="comment"><%=strTitle[SESS_LANGUAGE][7]%></span></td>
                </tr>
			  </table>
                <%  }	%>

              <table width="100%" border="0" cellspacing="2" cellpadding="0">
					<tr>
					  <td height="16" class="command">
                        <a href="javascript:reportPdf()"><%=strPrint%></a>
                        &nbsp;&nbsp;
  					    <a href="javascript:cmdBack()"><%=strBack%></a>
					  </td>
					</tr>
              </table>
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