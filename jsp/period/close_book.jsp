<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import dimata-->
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!-- import qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- import aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.entity.jurnal.*" %>
<%//@ page import = "com.dimata.aiso.form.periode.*" %>
<%@ page import = "com.dimata.aiso.session.periode.*" %>
<%@ page import = "com.dimata.aiso.session.jurnal.*" %>
<%//@ page import = "com.dimata.aiso.form.masterdata.*" %>

<!-- import harisma-->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_PERIOD, AppObjInfo.G2_PERIOD_CLOSE_BOOK, AppObjInfo.OBJ_PERIOD_CLOSE_BOOK); %>
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

<!-- JSP Block -->
<%!
/* this constant used to list text of listHeader */
public static final String textJspTitle[][] = {
	{"Fasilitas ini digunakan untuk proses tutup periode. Setelah proses ini, semua jurnal tidak bisa diubah lagi.",
	 "Anda yakin melakukan proses tutup periode ?",
	 "Tutup buku gagal, link perkiraan untuk <u>laba tahun berjalan</u> dan <u>laba periode berjalan</u> tidak boleh kosong !!! ",
	 "Fasilitas ini digunakan untuk proses tutup periode. Saldo akhir inventaris bulan ini diubah menjadi saldo awal dan mutasi dikosongkan"
	},
	 
	{"This feature is used to closing period. After this process, all journal cannot be edited.",
	 "Are you sure to close period ?",
	 "Close book failed, account link for <u>current earning year</u> and <u>current earning period</u> cannot null !!! ",
	 "This feature is used to closing period. System will close all fixed assets transaction and generate new fixed assets period."
	}	 
};

public static final String pageTitle[] = {
	"Tutup Buku","Closing Period"	
};

private static final String mainTitle[] = {
	"Periode Akuntansi","Accounting Period"
};
%>

<%
// ngambil data dari request form
int iCommand = FRMQueryString.requestCommand(request);

// setup controlLine and commands caption
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String strCloseBook = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close Period" : "Tutup Periode";
String strYesCloseBook = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes " : "Ya ") + strCloseBook;
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";

// ngambil OID dari current periode
long periodeId =  PstPeriode.getCurrPeriodId();

// ngambil nilai account link utk earning account
boolean bPeriodEarnExist = true;
boolean bYearEarnExist = true;
boolean bRetainEarnExist = true;

// department ini sangat penting dalam proses
// closing menurut siapa yang punya hak closing
Vector vDept = new Vector();
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
      vDept.add(dept);
  }
}

if(vDept!=null && vDept.size()>0){
	int iDeptCount = vDept.size();
	for(int i=0; i<iDeptCount; i++){
		Department objDepartment = (Department) vDept.get(i);
		
		AccountLink objAccountLinkPeriodEarn = PstAccountLink.getObjAccountLink(objDepartment.getOID(), PstPerkiraan.ACC_GROUP_PERIOD_EARNING);
		if(objAccountLinkPeriodEarn.getFirstId() == 0){
			bPeriodEarnExist = false;
			break;
		}
		
		AccountLink objAccountLinkYearEarn = PstAccountLink.getObjAccountLink(objDepartment.getOID(), PstPerkiraan.ACC_GROUP_YEAR_EARNING);
		if(objAccountLinkYearEarn.getFirstId() == 0){
			bYearEarnExist = false;
			break;
		}

		AccountLink objAccountLinkRetainEarn = PstAccountLink.getObjAccountLink(objDepartment.getOID(), PstPerkiraan.ACC_GROUP_RETAINED_EARNING);
		if(objAccountLinkRetainEarn.getFirstId() == 0){
			bRetainEarnExist = false;
			break;
		}
	}	
}else{
	bPeriodEarnExist = false;
	bYearEarnExist = false;
	bRetainEarnExist = false;
}

// proses closing period
long lClosingPeriodStatus = 0;
long lClosingPeriod = 0;
long lClosingFA = 0;
if(iCommand == Command.SAVE){
	SessPeriode objSessPeriode = new SessPeriode();
	SessSaldoAkhirPeriode objSessSaldoAkhirPeriode = new SessSaldoAkhirPeriode();
	if(iFixedAssetsModule == 0){
	    boolean bNextPeriodIsNewYear = objSessPeriode.isNextPeriodIsNewYear(periodeId, periodInterval, lastEntryDuration);

	    // jika periode yang akan datang adalah tahun baru, maka lakukan proses tutup buku tahunan	
	    if(bNextPeriodIsNewYear){
		    lClosingPeriodStatus = objSessSaldoAkhirPeriode.closingBookYearly(new Date(), periodeId, periodInterval, lastEntryDuration, accountingBookType, userOID);

	    // jika periode yang akan datang bukan tahun baru, maka lakukan proses tutup buku bulanan / periodic 
	    }else{
		    lClosingPeriodStatus = objSessSaldoAkhirPeriode.closingBookPeriodic(new Date(), periodeId, periodInterval, lastEntryDuration, accountingBookType, userOID, true);
	    }
	}else{
	    try{
		lClosingFA = objSessSaldoAkhirPeriode.closingFAOnly(periodeId, periodInterval, lastEntryDuration);
	    }catch(Exception e){}
	}
	
	// update nilai variable di javainit.jsp
	try{
	    currentPeriodOid = PstPeriode.getCurrPeriodId();
	}catch(Exception e){}
	try{
	    validCloseBookToday = objSessSaldoAkhirPeriode.isValidCloseBookTime(new Date(),currentPeriodOid);
	}catch(Exception e){}
	
	if(iFixedAssetsModule == 0){
	    if( (currentPeriodOid != 0) && (currentPeriodOid == lClosingPeriodStatus)){
		    lClosingPeriodStatus = PstSaldoAkhirPeriode.NO_ERR;
	    }
	}else{
	    if(lClosingFA != 0){
		    lClosingPeriodStatus = PstSaldoAkhirPeriode.NO_ERR;
	    }
	}	
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">	
	function cmdSave(){
		document.frmclosebook.command.value="<%=Command.SAVE%>";
	    document.frmclosebook.action="close_book.jsp";
		document.frmclosebook.submit();
	}

	<%if(privSubmit){%>
	function cmdAsk(){
		document.frmclosebook.command.value="<%=Command.ASK%>";
	    document.frmclosebook.action="close_book.jsp";
		document.frmclosebook.submit();
	}
	<%}%>
	
	function cmdCancel(){
		document.frmclosebook.command.value="<%=Command.NONE%>";
	    document.frmclosebook.action="close_book.jsp";
		document.frmclosebook.submit();
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
    <td width="100%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=mainTitle[SESS_LANGUAGE]%> 
            : <font color="#CC3300"><%=pageTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmclosebook" method="post" action="">
		    <input type="hidden" name="command" value="">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  	<tr><td></td></tr>
				<tr>
					<td>
						<table width="100%" align="center" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
							<tr>
								<td>
									<table width="100%" border="0" cellpadding="0" cellspacing="2" class="list">
                <tr align="left" valign="top"> 
                  <td valign="middle" colspan="3">&nbsp; 
                  </td>
                </tr>
                <%if(iCommand==Command.SAVE){%>
                <tr> 
                  <td class="command" width="100%">&nbsp;
                  <%
                   int iCls = 0;
                   if((lClosingPeriodStatus>0) && ((int)lClosingPeriodStatus< PstSaldoAkhirPeriode.ERR_INVALID_EARNING_ACCOUNT)){
                    iCls = (int) lClosingPeriodStatus;    
                   }
                   
                  %>
                  <%=PstSaldoAkhirPeriode.arrErrClosingPeriod[SESS_LANGUAGE][iCls]%></td>
                </tr>
                <%}else{%>
                <tr> 
                  <td> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="2" >
                      <%if(iCommand!=Command.ASK){%>
                      <tr>
			<%if(iFixedAssetsModule == 0){%>
			    <td>&nbsp;&nbsp;<%=textJspTitle[SESS_LANGUAGE][0]%></td>
			<%}else{%>
			    <td>&nbsp;&nbsp;<%=textJspTitle[SESS_LANGUAGE][3]%></td>
			<%}%>
                      </tr>
                      <%}else{%>
                      <%if(bPeriodEarnExist && bYearEarnExist && bRetainEarnExist){%>
                      <tr> 
                        <td>&nbsp;&nbsp;<%=textJspTitle[SESS_LANGUAGE][1]%></td>
                      </tr>
                      <%}else{%>
                      <tr> 
                        <td class="msgErrComment">&nbsp;&nbsp;<%=PstSaldoAkhirPeriode.arrErrClosingPeriod[SESS_LANGUAGE][Integer.parseInt(""+PstSaldoAkhirPeriode.ERR_INVALID_EARNING_ACCOUNT)]%></td>
                      </tr> 
                      <%}%>
                      <%}%>
                      <%}%>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>&nbsp;&nbsp;<%if((iCommand!=Command.SAVE)&&(privSubmit)){%>
                          <%if(iCommand!=Command.ASK){%>
						  <input name="buttonAskCloseBook" type="button" onClick="javascript:cmdAsk()" value="<%=strCloseBook%>">
                          <!-- <a href="javascript:cmdAsk()" class="command"><%//=strCloseBook%></a> -->
                          <%}else{%>
                          <%if(bPeriodEarnExist && bYearEarnExist && bRetainEarnExist){%>
						  <input name="buttonYesCloseBook" type="button" onClick="javascript:cmdSave()" value="<%=strYesCloseBook%>">
						  <input name="buttonCancelCloseBook" type="button" onClick="javascript:cmdCancel()" value="<%=strCancel%>">
                          <!-- <a href="javascript:cmdSave()" class="command"><%//=strYesCloseBook%></a> | <a href="javascript:cmdCancel()" class="command"><%//=strCancel%></a> -->
                          <%}else{%>
						  <input name="buttonCancelCloseBook" type="button" onClick="javascript:cmdCancel()" value="<%=strCancel%>">
                          <!-- <a href="javascript:cmdCancel()" class="command"><%//=strCancel%></a> -->
                          <%}%>
                          <%}%>
                          <%}%></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
              </table>
								</td>
							</tr>
						</table>
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