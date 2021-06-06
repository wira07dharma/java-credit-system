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
                   com.dimata.aiso.session.report.SessGeneralLedger,
                   com.dimata.gui.jsp.ControlCombo,
                   com.dimata.gui.jsp.ControlList,
                   com.dimata.aiso.entity.report.GeneralLedger" %>
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
public static String strTitle[][] = {
	{"Nomor","Perkiraan","Periode","Tanggal","Keterangan","Debet","Kredit","Saldo","Anda tidak punya hak akses untuk laporan buku besar !!!"},
	{"Number","Account","Period","Date","Description","Debet","Kredit","Saldo","You haven't privilege for accessing general ledger report !!!"}
};

public static final String masterTitle[] = {
	"Laporan","Report"	
};

public static final String listTitle[] = {
	"Buku Besar","General Ledger"	
};


    public static String formatStringNumber(double dbl){
        if(dbl<0)
            return "("+String.valueOf(FRMHandler.userFormatStringDecimal(dbl * -1))+")";
        else
            return String.valueOf(FRMHandler.userFormatStringDecimal(dbl));
    }

/**
 * gadnyana
 * @param objectClass
 * @param language
 * @return
 */
public String drawListGeneralLedger(Vector objectClass, int language){
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("97%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
    ctrlist.setHeaderStyle("listgentitle");
    ctrlist.addHeader(strTitle[language][3],"8%","2","0");
    ctrlist.addHeader("Perkiraan Lawan","30%","0","2");
    ctrlist.addHeader(strTitle[language][0],"8%","0","0");
    ctrlist.addHeader(strTitle[language][1],"23%","0","0");
    ctrlist.addHeader(strTitle[language][4],"25%","2","0");
    ctrlist.addHeader(strTitle[language][5],"10%","2","0");
    ctrlist.addHeader(strTitle[language][6],"10%","2","0");
    ctrlist.addHeader(strTitle[language][7],"10%","2","0");

    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();
    try {
        for (int i = 0; i < objectClass.size(); i++) {
            GeneralLedger generalLedger = (GeneralLedger)objectClass.get(i);
            Vector rowx = new Vector();

            if(generalLedger.getGlDate()!=null)
                rowx.add(Formater.formatDate(generalLedger.getGlDate(),"dd-MM-yyyy"));
            else
                rowx.add("");

            rowx.add(String.valueOf(generalLedger.getGlNomor()));
            rowx.add(String.valueOf(generalLedger.getGlNama()));
            rowx.add(String.valueOf(generalLedger.getGlKeterangan()));
            rowx.add("<div align=\"right\">"+formatStringNumber(generalLedger.getGlDebet())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(generalLedger.getGlKredit())+"</div>");
            rowx.add("<div align=\"right\">"+formatStringNumber(generalLedger.getGlSaldo())+"</div>");

            lstData.add(rowx);
        }
    } catch(Exception exc) {}
    return ctrlist.drawList();
}
%>

<!-- JSP Block -->
<%
int iCommand = FRMQueryString.requestCommand(request);
long accountId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERKIRAAN);
long periodId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERIODE);
String numberP = FRMQueryString.requestString(request,"ACCOUNT_NUMBER");
String namaP = FRMQueryString.requestString(request,"ACCOUNT_TITLES");

/**
* Declare Commands caption
*/
String strCheck = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "check" : "cari";
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";

String order = "NOMOR_PERKIRAAN";
CtrlJurnalDetail ctrljurnaldetail = new CtrlJurnalDetail(request) ;
FrmJurnalDetail frmjurnaldetail = ctrljurnaldetail.getForm();


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
        list = SessGeneralLedger.listGeneralLedger(accountId,periodId);

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
    document.frmGeneralLedger.command.value ="<%=Command.LIST%>";
    document.frmGeneralLedger.action = "general_ledger.jsp";
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
			<input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>" value="<%=accountId%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2">&nbsp;</td>
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
                    &nbsp;<a href="javascript:cmdSearchAccount()"><%=strCheck%></a> 
                  </td>
                </tr>
                <tr>
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td height="20%" width="1%" align="center">:</td>
                  <td height="20%" width="89%">
                  <%
                      Vector vtPeriod = PstPeriode.list(0,0,"","");
                      Vector vPeriodKey = new Vector(1,1);
                      Vector vPeriodVal = new Vector(1,1);
                      for(int k=0;k<vtPeriod.size();k++){
                        Periode periode = (Periode)vtPeriod.get(k);

                        vPeriodKey.add(""+periode.getOID());
                        vPeriodVal.add(periode.getNama());
                      }
                      out.println(ControlCombo.draw(SessGeneralLedger.FRM_NAMA_PERIODE,"",null,"",vPeriodKey,vPeriodVal,""));
				  %>
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
                  <td colspan="3" height="15"><%=drawListGeneralLedger(list, SESS_LANGUAGE)%></td>
                </tr>
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