<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*,
                 com.dimata.interfaces.trantype.I_TransactionType,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.common.entity.contact.PstContactList,
                 com.dimata.aiso.form.aktiva.*,
                 com.dimata.aiso.entity.aktiva.*,
		 com.dimata.aiso.session.report.SessAktivaSusut,
		 com.dimata.aiso.entity.report.*,
                 com.dimata.aiso.session.report.SessWorkSheet" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.util.*" %>

<!--import qdep-->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<!--import common-->
<%@ page import="com.dimata.common.entity.payment.*" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.periode.*" %>
<%@ page import="com.dimata.aiso.session.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.system.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/** Check privilege except VIEW, view is already checked on checkuser.jsp as basic access */
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition
//if(!privView && !privAdd && !privUpdate && !privDelete && !privSubmit){
%>
<!--
<script language="javascript">
	window.location="<%//=approot%>/nopriv.html";
</script>
-->
<!-- if of "has access" condition -->
<%
//}else{
%>
<%!
public static final int INT_VALID_DELETE = 0;
public static final int INT_INVALID_DELETE = 1;
String formatNumber = "#,###.00";

public static String strItemTitle[][] = {
	{
		"No","Kode","Nama","Masa Manfaat","Nilai Perolehan","Nilai Residu","Penyusutan"
	},

	{
		"No","Code","Name","Life","Acquisition Value","Residu Value","Depreciation Value"
	}
};

public static String strTitle[][] =
{
	{
		"Periode",
		"Type Penyusutan",
		"Metode Penyusutan"
	},
	{
		"Period",
		"Depreciation Type",
		"Depreciation Method"
	}
};

    public static final String masterTitle[] = {
        "Inventaris","Fixed Assets"
    };

    public static final String listTitle[] = {
        "Proses Penyusutan","Depreciation Process"
    };



/**
* this method used to list jurnal detail
*/
public String drawList(int language, int iCommand, Vector objectClass,long oidPeriod, int start, ReportFixedAssets objReportFixedAssets)
{
	String sResult = "<table width=\"100%\" class=\"listarea\"><tr><td>";
	sResult += "<table width=\"100%\" border=\"0\" class=\"listgen\" cellspacing=\"1\"><tr>";
	sResult += "<td width=\"3%\" align=\"center\" class=\"listgentitle\">"+strItemTitle[language][0]+"</td>";
	sResult += "<td width=\"8%\" align=\"center\" class=\"listgentitle\">"+strItemTitle[language][1]+"</td>";
	sResult += "<td width=\"25%\" align=\"center\" class=\"listgentitle\">"+strItemTitle[language][2]+"</td>";
	sResult += "<td width=\"3%\" align=\"center\" class=\"listgentitle\">"+strItemTitle[language][3]+"</td>";
	sResult += "<td width=\"12%\" align=\"center\" class=\"listgentitle\">"+strItemTitle[language][4]+"</td>";
	sResult += "<td width=\"5%\" align=\"center\" class=\"listgentitle\">"+strItemTitle[language][5]+"</td>";
	sResult += "<td width=\"12%\" align=\"center\" class=\"listgentitle\">"+strItemTitle[language][6]+"</td></tr><tr>";
	
	String sListgensell = "";
	
	double totalHargaPerolehan = 0;
	double totalNilaiResidu = 0;	
	double totalPenyusutan = 0;		
	for (int i = 0; i < objectClass.size(); i++) 
	{
		ModulAktiva modulAktiva = (ModulAktiva)objectClass.get(i);
		
		if((i%2) == 0){
		    sListgensell = "listgensellOdd";
		}else{
		    sListgensell = "listgensell";
		}
		
		
		sResult += "<td nowrap class=\""+sListgensell+"\"><div align=\"center\">"+(i+1+start)+"</div></td>";
		sResult += "<td nowrap class=\""+sListgensell+"\"><div align=\"left\">"+modulAktiva.getKode()+"</div></td>";
		sResult += "<td nowrap class=\""+sListgensell+"\"><div align=\"left\">"+modulAktiva.getName()+"</div></td>";
		sResult += "<td nowrap class=\""+sListgensell+"\"><div align=\"right\">"+modulAktiva.getMasaManfaat()+"</div></td>";
		sResult += "<td nowrap class=\""+sListgensell+"\"><div align=\"right\">"+FRMHandler.userFormatStringDecimal(modulAktiva.getHargaPerolehan())+"</div></td>";
		sResult += "<td nowrap class=\""+sListgensell+"\"><div align=\"right\">"+FRMHandler.userFormatStringDecimal(modulAktiva.getNilaiResidu())+"</div></td>";
		sResult += "<td nowrap class=\""+sListgensell+"\"><div align=\"right\">"+FRMHandler.userFormatStringDecimal(modulAktiva.getTotalPenyusutan())+"</div></td>";
		if(i == (objectClass.size() - 1)){
		    sResult += "</tr>";
		}else{
		    sResult += "</tr><tr>";
		}
		
		totalHargaPerolehan += modulAktiva.getHargaPerolehan();
		totalNilaiResidu += modulAktiva.getNilaiResidu();	
		totalPenyusutan += modulAktiva.getTotalPenyusutan();		

		
	 }
	 
	 sResult += "<tr><td align=\"right\" width=\"62%\" colspan=\"4\" class=\"listgensellOdd\"><b>SUB TOTAL</b></td>";
	 sResult += "<td nowrap class=\"listgensellOdd\"><div align=\"right\"><b>"+FRMHandler.userFormatStringDecimal(totalHargaPerolehan)+"</b></div></td>";
	 sResult += "<td nowrap class=\"listgensellOdd\"><div align=\"right\"><b>"+FRMHandler.userFormatStringDecimal(totalNilaiResidu)+"</b></div></td>";
	 sResult += "<td nowrap class=\"listgensellOdd\"><div align=\"right\"><b>"+FRMHandler.userFormatStringDecimal(totalPenyusutan)+"</b></div></td></tr>";	 
	 sResult += "<td align=\"right\" width=\"62%\" colspan=\"4\" class=\"listgensellOdd\"><b>TOTAL</b></td>";
	 sResult += "<td nowrap class=\"listgensellOdd\"><div align=\"right\"><b>"+FRMHandler.userFormatStringDecimal(objReportFixedAssets.getAqcThisMonth())+"</b></div></td>";
	 sResult += "<td nowrap class=\"listgensellOdd\"><div align=\"right\"><b>"+FRMHandler.userFormatStringDecimal(0)+"</b></div></td>";
	 sResult += "<td nowrap class=\"listgensellOdd\"><div align=\"right\"><b>"+FRMHandler.userFormatStringDecimal(objReportFixedAssets.getDepIncrement())+"</b></div></td></tr>";
	 sResult += "</table>";
	 
	 return sResult;
}
%>
<!-- JSP Block -->

<%
/** Get value from hidden form */
showMenu = true;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE PENYUSUTAN PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES PENYUSUTAN SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long typePenyusutanId = FRMQueryString.requestLong(request,"TYPE_AKTIVA_TYPE_PENYUSUTAN");
long metodepenyusutanId = FRMQueryString.requestLong(request,"TYPE_AKTIVA_METODE_PENYUSUTAN");

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : "Tambah Detail";
String strAll = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "All" : "Semua";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Detail" : "Simpan Detail";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Detail" : "Hapus Detail";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Detail" : "Ya Hapus Detail";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strViewList = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View List" : "Tampilkan Data";
String strSaveData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Process Data" : "Proses Data";
String strTransferData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Transfer Data" : "Transfer Data";

int recordToGet = 100;
if(iCommand==Command.NONE)
	iCommand = Command.ADD;

// untuk mencari aktiva sesuai dengan metode penyusutannya
String whereClause = "";
if(typePenyusutanId!=0){
	whereClause = PstModulAktiva.fieldNames[PstModulAktiva.FLD_TYPE_PENYUSUTAN_ID]+"="+typePenyusutanId;
}
if(metodepenyusutanId!=0){
	if(whereClause.length()>0)
		whereClause = whereClause + " AND " + PstModulAktiva.fieldNames[PstModulAktiva.FLD_METODE_PENYUSUTAN_ID]+"="+metodepenyusutanId;
	else
		whereClause = PstModulAktiva.fieldNames[PstModulAktiva.FLD_METODE_PENYUSUTAN_ID]+"="+metodepenyusutanId;
}



int iDepProcess = 0;
if(iCommand == Command.SAVE){	
	iDepProcess = SessAktivaSusut.depProcess(currentPeriodOid,typePenyusutanId,metodepenyusutanId);
	
}
// untuk mencari object periode
Periode periode = new Periode();
try
{
    periode = PstPeriode.fetchExc(currentPeriodOid);
}  
catch(Exception e)
{
}

// Instansiasi CtrlJurnalDetail and FrmJurnalDetail
ControlLine ctrLine = new ControlLine();
ctrLine.initDefault(SESS_LANGUAGE,"");
CtrlPenyusutanAktiva ctrlPenyusutanAktiva = new CtrlPenyusutanAktiva(request);
ctrlPenyusutanAktiva.setLanguage(SESS_LANGUAGE);
FrmPenyusutanAktiva frmOrderAktivaItem = ctrlPenyusutanAktiva.getForm();
PenyusutanAktiva penyusutanAktiva = ctrlPenyusutanAktiva.getPenyusutanAktiva();
int iErrCode = 0;//ctrlPenyusutanAktiva.action(iCommand,0,list,currentPeriodOid);
String msgString = ctrlPenyusutanAktiva.getMessage();

Vector allList = new Vector(1,1);
int vectSize = 0;
boolean isDepreciationDone = false;
ReportFixedAssets objReportFixedAssets = new ReportFixedAssets(); 
//if(iCommand != Command.ADD){	
	allList = SessAktivaSusut.listFADepreciation(currentPeriodOid,typePenyusutanId,metodepenyusutanId,0,0);
	objReportFixedAssets = PstReportFixedAssets.getTotalValue(currentPeriodOid, typePenyusutanId,metodepenyusutanId, 0, 0, 0);
	if(objReportFixedAssets.getDepIncrement() > 0){
	    isDepreciationDone = true;
	}
	vectSize = allList.size();
//}

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlPenyusutanAktiva.actionList(iCommand, start, vectSize, recordToGet); 
 } 

Vector list = new Vector(1,1);

if(iCommand == Command.LIST || (iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
	//list = SessAktivaSusut.listPenyusutan(currentPeriodOid,typePenyusutanId,metodepenyusutanId);
	list = SessAktivaSusut.listFADepreciation(currentPeriodOid,typePenyusutanId,metodepenyusutanId,start,recordToGet);
}

int iTransferData = 0;
if(iCommand == Command.SUBMIT)
{
	iTransferData = SessAktivaSusut.procesTransferFAData();
	/*SessAktivaSusut objSessAktivaSusut = new SessAktivaSusut();
	objSessAktivaSusut.postingPenyusutanAktiva(accountingBookType,userOID,currentPeriodOid,list);*/}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdsearch(){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="penyusutan_aktiva.jsp";
	document.frmorderaktiva.submit();
}

function cmdSave(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
    document.frmorderaktiva.action="penyusutan_aktiva.jsp";
	document.frmorderaktiva.submit();
}

function cmdPosted(){
	document.frmorderaktiva.command.value="<%=Command.SUBMIT%>";
	document.frmorderaktiva.action="penyusutan_aktiva.jsp";
	document.frmorderaktiva.submit();
}
function first(){
	document.frmorderaktiva.command.value="<%=String.valueOf(Command.FIRST)%>";
	document.frmorderaktiva.action="penyusutan_aktiva.jsp";
	document.frmorderaktiva.submit();
}
function prev(){
	document.frmorderaktiva.command.value="<%=String.valueOf(Command.PREV)%>";
	document.frmorderaktiva.action="penyusutan_aktiva.jsp";
	document.frmorderaktiva.submit();
}

function next(){
	document.frmorderaktiva.command.value="<%=String.valueOf(Command.NEXT)%>";
	document.frmorderaktiva.action="penyusutan_aktiva.jsp";
	document.frmorderaktiva.submit();
}
function last(){
	document.frmorderaktiva.command.value="<%=String.valueOf(Command.LAST)%>";
	document.frmorderaktiva.action="penyusutan_aktiva.jsp";
	document.frmorderaktiva.submit();
}

function hideSearch(){
	document.getElementById("depMethod").style.display="none";
	document.getElementById("depType").style.display="none";
	document.getElementById("command").style.display="none";
	document.getElementById("hide").style.display="none";
	document.getElementById("view").style.display = "";
}

function viewSearch(){
	<%if(iCommand != Command.ADD){%>
	document.getElementById("depMethod").style.display="";
	document.getElementById("depType").style.display="";
	document.getElementById("command").style.display="";
	document.getElementById("hide").style.display="";
	document.getElementById("view").style.display = "none";
	<%}%>
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%>
            : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmorderaktiva" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="start" value="<%=start%>">
	    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="type_penyusutan_aktiva_id" value="<%=typePenyusutanId%>">
              <input type="hidden" name="metode_penyusutan_aktiva_id" value="<%=metodepenyusutanId%>">
              <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgensell">
                <tr>
                  <td width="94%" class="listgensell">
                    <table width="100%">
                      <tr>
                        <td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                        <td width="1%" height="25"><b>:</b></td>
                        <td width="84%" height="25"><%=periode.getNama()%></td>
                      </tr>
                      <tr id="depType">
                        <td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][1]%> </td>
                        <td width="1%" height="25"><b>:</b></td>
                        <td width="84%" height="25">
                          <%
                          Vector vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_TYPE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          Vector vAktivaKey = new Vector(1,1);
                          Vector vAktivaVal = new Vector(1,1);
                          vAktivaKey.add("0");
                          vAktivaVal.add(strAll+" "+strTitle[SESS_LANGUAGE][1]);
                          for(int k=0;k < vtAktiva.size();k++){
                              Aktiva aktiva = (Aktiva)vtAktiva.get(k);
                              vAktivaKey.add(""+aktiva.getOID());
                              vAktivaVal.add(aktiva.getNama());
                          }
                          out.println(ControlCombo.draw("TYPE_AKTIVA_TYPE_PENYUSUTAN","",null,""+typePenyusutanId,vAktivaKey,vAktivaVal,""));
				          %>
                        </td>
                      </tr>
                      <tr id="depMethod">
                        <td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][2]%> </td>
                        <td width="1%" height="25"><b>:</b></td>
                        <td width="84%" height="25"><%
                          vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_METODE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          vAktivaKey = new Vector(1,1);
                          vAktivaVal = new Vector(1,1);
                            vAktivaKey.add("0");
                            vAktivaVal.add(strAll+" "+strTitle[SESS_LANGUAGE][2]);
                          for(int k=0;k < vtAktiva.size();k++){
                            Aktiva aktiva = (Aktiva)vtAktiva.get(k);

                            vAktivaKey.add(""+aktiva.getOID());
                            vAktivaVal.add(aktiva.getNama());
                          }
                          out.println(ControlCombo.draw("TYPE_AKTIVA_METODE_PENYUSUTAN","",null,""+metodepenyusutanId,vAktivaKey,vAktivaVal,""));
				          %>
                        </td>
                      </tr>
                      <tr id="command">
                        <td width="15%" height="25">&nbsp;</td>
                        <td width="1%" height="25">&nbsp;</td>
                        <td width="84%" height="25">&nbsp;
			    <%if(isDepreciationDone){%>
				<input name="btnList" type="button" onClick="javascript:cmdsearch()" value="<%=strViewList%>">				
			    <%}else{%>
				<input name="btnSave" type="button" onClick="javascript:cmdSave()" value="<%=strSaveData%>">
				<%if(iTransferData == 0){%>
					<input name="btnSave" type="button" onClick="javascript:cmdPosted()" value="<%=strTransferData%>">
				<%}%>
				
			    <%}%>
			    <!-- a href="javascript:cmdsearch()"><b>Cari Aktiva</b></a --></td>
                      </tr>
		      <%if(iCommand != Command.ADD){%>
                      <tr>
                        <td colspan="3" id="view"><input name="viewcb" type="checkbox"  value="0" onclick="javascript:viewSearch()">View Search</td>
			<td colspan="3" id="hide"><input name="hidecb" type="checkbox"  value="1" onclick="javascript:hideSearch()">Hide Search</td>
                      </tr>
		      <%}%>
                      <%if(list != null && list.size() > 0){%>
                      <tr>
                        <td colspan="3">
							<%=drawList(SESS_LANGUAGE,iCommand,list,currentPeriodOid,start,objReportFixedAssets)%>
						</td>
                      </tr>
                      <tr>
			    <td colspan="3" class="command"> <%=ctrLine.drawMeListLimit(iCommand, vectSize, start, recordToGet,"first","prev","next","last","left")%>  </td>
			</tr>
                        <td colspan="3">&nbsp;<!-- input name="btnSave" type="button" onClick="javascript:cmdSave()" value="<%//=strSaveData%>"><!-- a href="javascript:cmdPosted()" --></td>
                      </tr>
					  <%}%>
                      <tr>
                        <td width="15%" valign="top" height="25"></td>
                        <td width="1%" height="25">&nbsp;</td>
                        <td width="84%" height="25">&nbsp;&nbsp;</td>
                      </tr>
                  </table></td>
                </tr>
              </table>
            </form>
	    <script language="JavaScript">
		<%if(iCommand == Command.ADD){%>
			viewSearch();
		<%}else{%>
			hideSearch();
		<%}%>
	    </script>
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
<%//}%>
