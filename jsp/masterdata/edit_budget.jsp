<%@ page language = "java" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.util.lang.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_ACCOUNT_CART, AppObjInfo.OBJ_MASTERDATA_ACCOUNT_CART); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));

//if of "hasn't access" condition 
if (!privView && !privUpdate) {
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
} else {
%>
<%!
public static final String pageTitle[] = 
{
	"Perkiraan", 
	"Account"
};

public static final String strObjTitles[][] = 
{
 {
 	"Departemen", 
	"Induk Perkiraan", 
	"Nomor Perkiraan", 
	"Nama Perkiraan", 
	"Nama Perkiraan (Bahasa Inggris)"
 },
 {
 	"Department", 
	"Account Parent", 
	"Account Number", 
	"Account Name in Indonesian", 
	"Account Name in English"
 }
}; 
 
public String getJspTitle(String titles[][], int language, int index)
{
     return titles[language][index];
}
%>
<%
int iCommand = FRMQueryString.requestCommand(request);
long iAccountOID = FRMQueryString.requestLong(request, "accountchart_id");
int iBudgetCount = 0;
int iErrCode = 0;
AisoBudgeting objBudgeting = new AisoBudgeting();

if (iCommand == Command.SAVE) 
{
     String sBudget[] = request.getParameterValues(FrmBudgeting.fieldNames[FrmBudgeting.FRM_BUDGET]);
     String sPeriodOid[] = request.getParameterValues("period");
     
     iBudgetCount = sPeriodOid.length;
     
     Vector vectBudgeting = new Vector();     
     for (int item = 0; item < iBudgetCount; item++) 
	 {         
         double dBudget = CtrlBudgeting.getDecimalFromFormattedString(sBudget[item], sUserDigitGroup, sUserDecimalSymbol);         
         long lPeriodOid = Long.parseLong(sPeriodOid[item]);
         
         
         objBudgeting.setIdPerkiraan(iAccountOID);
         objBudgeting.setPeriodeId(lPeriodOid);
         objBudgeting.setBudget(dBudget);
		 
         if (dBudget > 0)
		 {
         	vectBudgeting.add(objBudgeting);
		 }
     }
     iErrCode = CtrlBudgeting.action(iCommand, vectBudgeting);
}    
     
 
 
Perkiraan objAccount = new Perkiraan();
Department objDept = new Department();
Perkiraan objAccParent = new Perkiraan();
 
String strDeptName = "";
String strAccParentName = "";
String strAccNumber = "";
String strAccIndonesian = "";
String strAccEnglish = "";
 
try 
{
     objAccount = PstPerkiraan.fetchExc(iAccountOID);
     long lDeptOid = objAccount.getDepartmentId();
     if (lDeptOid > 0) 
	 {
         objDept = PstDepartment.fetchExc(lDeptOid);
         strDeptName = objDept.getDepartment();
     }    
	 
     long lAccParent = objAccount.getIdParent();
     if (lAccParent > 0) 
	 {
         objAccParent = PstPerkiraan.fetchExc(lAccParent);
         if (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN)
		 {
             strAccParentName = objAccParent.getAccountNameEnglish();
		 }
         else
		 {
             strAccParentName = objAccParent.getNama();
		 }
     }         
     strAccNumber = objAccount.getNoPerkiraan();
     strAccIndonesian = objAccount.getNama();
     strAccEnglish = objAccount.getAccountNameEnglish();
} 
catch (Exception error) 
{
    System.out.println(".:: edit_budget.jsp : " + error.toString());
}    
%>
<%
String strPageTitle = pageTitle[SESS_LANGUAGE];
PstPerkiraan pstAccount = new PstPerkiraan();
Vector vectPeriod = PstPeriode.getBudgetingPeriod();
int iVectPerdSize = vectPeriod.size(); 

String strPageName = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "Edit Budget" : "Edit Anggaran";
String strEditorName = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "Budget Editor" : "Editor Anggaran";
String strPeriod = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "Period" : "Periode";
String strAmount = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "Amount" : "Jumlah";
String strSave = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "Save Budget" : "Simpan Anggaran";
String strBack = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "Back to Account List" : "Kembali ke Daftar Perkiraan";
String strList = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "Budget List" : "Daftar Anggaran";
String errAccount = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "Chart Account not found. Please entry chart account before entry budget" : "Perkiraan belum ada. Silahkan entry Perkiraan sebelum entry budget";
String errList = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "System can't view list budget because budget is not entry" : "System tidak bisa menampilkan list budget karena budget belum dientry";
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<script language="javascript">
function cmdSave() 
{
    var objDoc = document.<%=FrmBudgeting.FRM_BUDGETING%>;
    objDoc.command.value = "<%=Command.SAVE%>";
    objDoc.action = "edit_budget.jsp";
	<%if(iAccountOID == 0){%>
    	alert("<%=errAccount%>");
	<%}else{%>
		objDoc.submit();
	<%}%>
}

function cmdBack() 
{
    var objDoc = document.<%=FrmBudgeting.FRM_BUDGETING%>;    
	<%if(iAccountOID == 0){%>
    	objDoc.command.value = "<%=Command.ADD%>";		
	<%}else{%>
		objDoc.command.value = "<%=Command.EDIT%>";
	<%}%>
    objDoc.action = "account_chart.jsp#down";
    objDoc.submit();
}

function cmdList() 
{
    var objDoc = document.<%=FrmBudgeting.FRM_BUDGETING%>;
    objDoc.action = "list_budget.jsp";
	<%if(iAccountOID == 0){%>
    	alert("<%=errList%>");		
	<%}else{%>
		objDoc.submit();
	<%}%>
}
</script>
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
            <%
		  PstPerkiraan pstperkiraan = new PstPerkiraan();		 
		  %>
		  	 Masterdata : <font color="#CC3300">ENTRY BUDGET</font>
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmBudgeting.FRM_BUDGETING%>" method="POST">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="accountchart_id" value="<%=iAccountOID%>">
              <table width="100%">               
                <tr> 
                  <td colspan="2"> 
                    <table width="100%" cellpadding="2" cellspacing="2">
                      <tr> 
                        <td width="12%"><b><%=getJspTitle(strObjTitles, SESS_LANGUAGE, 0)%></b></td>
                        <td width="2%"><b>:</b></td>
                        <td width="86%"><b><%=strDeptName%></b></td>
                      </tr>
                      <tr> 
                        <td width="12%"><b><%=getJspTitle(strObjTitles, SESS_LANGUAGE, 1)%></b></td>
                        <td width="2%"><b>:</b></td>
                        <td width="86%"><b><%=strAccParentName%></b></td>
                      </tr>
                      <tr> 
                        <td width="12%"><b><%=getJspTitle(strObjTitles, SESS_LANGUAGE, 2)%></b></td>
                        <td width="2%"><b>:</b></td>
                        <td width="86%"><b><%=strAccNumber%></b></td>
                      </tr>
                      <tr> 
                        <td width="12%"><b><%=getJspTitle(strObjTitles, SESS_LANGUAGE, 3)%></b></td>
                        <td width="2%"><b>:</b></td>
                        <td width="86%"><b><%=SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT ? strAccIndonesian : strAccEnglish%></b></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2"><b><%="&nbsp;"+strEditorName.toUpperCase()%></b></td>
                </tr>
                <tr> 
                  <td colspan="2"> 
                    <table width="428" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td> 
                          <table cellpadding="1" cellspacing="1" width="100%" class="listgen">
                            <tr> 
                              <td align="center" width="23" height="25" class="listgentitle"><font color="white"><b>No</b></font></td>
                              <td align="center" width="251" class="listgentitle"><font color="white"><b><%=strPeriod%></b></font></td>
                              <td align="center" width="138" class="listgentitle"><font color="white"><b><%=strAmount%></b></font></td>
                            </tr>
                            <%
                 for (int item = 0; item < iVectPerdSize; item++) {
                     Periode objPeriode = (Periode) vectPeriod.get(item);
                     AisoBudgeting objBudget = PstAisoBudgeting.getAisoBudgeting(iAccountOID, objPeriode.getOID());
                     
                     double dBudget = objBudget.getBudget();
                     
                     if (objPeriode.getPosted() == PstPeriode.PERIOD_CLOSED) {
                %>
                            <tr> 
                              <td align="right" bgcolor="#E5E5E5" width="23"><%=(item + 1)%>&nbsp;</td>
                              <td bgcolor="#E5E5E5" width="251">&nbsp;<%=objPeriode.getNama()%> 
                                <input type="hidden" name="period" value="<%=objPeriode.getOID()%>">
                              </td>
                              <td bgcolor="#E5E5E5" width="138"> 
                                <input type="text" size="20" name="<%=FrmBudgeting.fieldNames[FrmBudgeting.FRM_BUDGET]%>" value="<%=FRMHandler.userFormatStringDecimal(dBudget)%>" readonly class="cmbDisabledStyle" style="text-align: right">
                              </td>
                            </tr>
                            <%
                    } else {
                %>
                            <tr> 
                              <td align="right" bgcolor="white" width="23"><%=(item + 1)%>&nbsp;</td>
                              <td bgcolor="white" width="251">&nbsp;<%=objPeriode.getNama()%> 
                                <input type="hidden" name="period" value="<%=objPeriode.getOID()%>">
								<%if(iAccountOID == 0){
									dBudget = 0;
								}%>
                              </td>
                              <td bgcolor="white" width="138"> 
                                <input type="text" size="20" name="<%=FrmBudgeting.fieldNames[FrmBudgeting.FRM_BUDGET]%>" value="<%=FRMHandler.userFormatStringDecimal(dBudget)%>" style="text-align: right">
                              </td>
                            </tr>
                            <%
                    }
                 }
                %>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2"> 
                    <table>
                      <tr> 
                        <td><a href="javascript:cmdSave()"><b><%=strSave%></b></a>&nbsp;|</td>
                        <td><a href="javascript:cmdList()"><b><%=strList%></b></a>&nbsp;|</td>
                        <td><a href="javascript:cmdBack()"><b><%=strBack%></b></a></td>						
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              <%
              if (iCommand == Command.SAVE && iErrCode == 0) 
			  {
           	  %>
              	<script language="javascript">
            		cmdBack();
           		</script>
              <% 
			  } 
			  %>
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
<% } %>
