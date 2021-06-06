<%
/*
 * Page Name  		:  standartrate.jsp
 * Created on 		:  [date] [time] AM/PM
 *
 * @author  		:  [authorName]
 * @version  		:  [version]
 */

/*******************************************************************
 * Page Description	: [project description ... ]
 * Imput Parameters	: [input parameter ...]
 * Output 			: [output ...]
 *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*,
                   com.dimata.aiso.form.masterdata.FrmAktiva,
                   com.dimata.aiso.form.masterdata.CtrlAktiva,
                   com.dimata.aiso.session.report.SessWorkSheet,
		   com.dimata.aiso.session.aktiva.*,
		   com.dimata.aiso.session.masterdata.*,
                   com.dimata.aiso.form.masterdata.CtrlModulAktiva,
                   com.dimata.aiso.form.masterdata.FrmModulAktiva,
		   com.dimata.aiso.entity.aktiva.*,
		   com.dimata.common.entity.contact.*,
		   com.dimata.interfaces.trantype.*,
		   com.dimata.interfaces.chartofaccount.*,
		   com.dimata.common.form.search.*,
                   com.dimata.aiso.entity.masterdata.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package posbo -->
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_ACCOUNT_CART, AppObjInfo.OBJ_MASTERDATA_ACCOUNT_CART); %>

<%//@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
public static final String textListTitle[][] =
{
	{"Master Aktiva Tetap","Harus diisi"},
	{"Fixed Assets Master","required"}
};

public static final String textListHeader[][] =
{
	{
	     "Kode",
	     "Name",
	     "Jenis Aktiva",
	     "Tipe Penyusutan",
	     "Metode Penyusutan",
	     "Masa Manfaat",
	     "Prosentase Penyusutan",
	     "Harga Perolehan",
	     "Nilai Residu",
	     "Perk. Aktiva",
	     "Perk. Biaya Penyusutan",
	     "Nilai Akm. Penyusutan",
	     "Nilai Laba Penj. Aktiva",
	     "Nilai Rugi Penj. Aktiva",
	     "Grup Aktiva",
	     "Akumulasi Penyusutan",
	     "Tanggal Perolehan",
	     "Lokasi Inventaris",
	     "Tahun",
	     "Jumlah Awal",
	     "Jumlah Masuk",
	     "Jumlah Keluar",
	     "Uang Muka",
	     "Perkiraan Uang Muka",
	     "Perkiraan Pembayaran",
	     "Jenis Transaksi",
	     "Pemasok"
    },
	{
	     "Code",//0
	     "Name",//1
	     "Fixed Assets Type",//2
	     "Depreciation Type",//3
	     "Depreciation Method",//4
	     "Life",//5
	     "Depreciation Procentage",//6
	     "Acquisition Value",//7
	     "Residu Value",//8
	     "Fixed Assets Account",//9
	     "Depreciation Expense Account",//10
	     "Acc Depreciation Account",//11
	     "Other Revenue",//12
	     "Other Expenses",//13
	     "Fixed Assets Group",//14
	     "Depreciation Accumulation",//15
	     "Acquisition Date",//16
	     "Fixed Assets Location",//17
	     "Year(s)",//18
	     "Opening Balance Qty",//19
	     "In Quantity Total(Inc OB Qty)",//20
	     "Out Going Quantity",//21
	     "Down Payment",//22
	     "Down Payment Account",//23
	     "Payment Account",//24
	     "Transaction Type",//25
	     "Supplier"//26
    }
};
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int iFATipe = FRMQueryString.requestInt(request, "fa_type");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidAktiva = FRMQueryString.requestLong(request, "hidden_modul_aktiva_id");
double dAccDep = FRMQueryString.requestDouble(request, "acc_penyusutan");
int iMonth = FRMQueryString.requestInt(request, "tgl_perolehan_mn");
int iDate = FRMQueryString.requestInt(request, "tgl_perolehan_dy");
int iYear = FRMQueryString.requestInt(request, "tgl_perolehan_yr");
int iQty = FRMQueryString.requestInt(request, "qty");
int iTransType = FRMQueryString.requestInt(request, FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_TRANS_TYPE]);
long lIdCash = FRMQueryString.requestLong(request, FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]+"_cash");
long lIdCredit = FRMQueryString.requestLong(request, FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]+"_credit");
long lIdAwal = FRMQueryString.requestLong(request, FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]+"_awal");
long lIdPerkiraanPayment = 0;
switch(iTransType){
    case I_TransactionType.TIPE_TRANSACTION_CASH:
	lIdPerkiraanPayment = lIdCash;
	break;
    case I_TransactionType.TIPE_TRANSACTION_KREDIT:
	lIdPerkiraanPayment = lIdCredit;
	break;
    case I_TransactionType.TIPE_TRANSACTION_AWAL:
	lIdPerkiraanPayment = lIdAwal;
	break;
}

boolean privManageData = true;
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+"="+PstAktiva.TYPE_AKTIVA_JENIS_AKTIVA;
String orderClause = PstAktiva.fieldNames[PstAktiva.FLD_KODE];

Date ownDate = new Date(iYear-1900,iMonth-1,iDate);
/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = textListTitle[SESS_LANGUAGE][0];
String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
String saveConfirm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Please check own date data, before save data!" : "Silahkan cek tanggal perolehan sebelum disimpan!";

FRMHandler frmHandler = new FRMHandler();
frmHandler.setDecimalSeparator(".");
frmHandler.setDigitSeparator(",");

CtrlModulAktiva ctrlModulAktiva = new CtrlModulAktiva(request);
Vector listAktiva = new Vector(1,1);

int qtyFixedAssets = 0;
int qtyFAIn = 0;
int qtyFAOut = 0;
double dOBDepAcc = 0;
Vector vCash = new Vector(1,1);
Vector vAP = new Vector(1,1);
Vector vEQuity = new Vector(1,1);
Vector vPayment = new Vector(1,1);
try{
   vCash = PstAccountLink.getVectObjListAccountLink(lDefaultSpcJournalDeptId, I_ChartOfAccountGroup.ACC_GROUP_CASH);
   vCash.addAll(PstAccountLink.getVectObjListAccountLink(lDefaultSpcJournalDeptId, I_ChartOfAccountGroup.ACC_GROUP_BANK));
   vCash.addAll(PstAccountLink.getVectObjListAccountLink(lDefaultSpcJournalDeptId, I_ChartOfAccountGroup.ACC_GROUP_PETTY_CASH));
    vAP = PstAccountLink.getVectObjListAccountLink(lDefaultSpcJournalDeptId, I_ChartOfAccountGroup.ACC_GROUP_CURRENCT_LIABILITIES);
    vEQuity = PstAccountLink.getVectObjListAccountLink(lDefaultSpcJournalDeptId, I_ChartOfAccountGroup.ACC_GROUP_EQUITY);    
}catch(Exception e){
    System.out.println(e);
}

String sOBDepAcc = "0";
if(iQty > 0){
	qtyFixedAssets = iQty;
}

if(oidAktiva != 0){
	try{
		qtyFAIn = SessReceiveAktiva.getQtyReceiveByIdAktiva(oidAktiva);
		qtyFAOut = SessSellingAktiva.getQtySellingByIdAktiva(oidAktiva); 
	}catch(Exception e){}
}


iErrCode = ctrlModulAktiva.action(iCommand , oidAktiva, dAccDep, userOID, ownDate,qtyFixedAssets,sAutoReceiveFA);

FrmModulAktiva frmModulAktiva = ctrlModulAktiva.getForm();

int vectSize = PstAktiva.getCount(whereClause);
ModulAktiva modulAktiva = ctrlModulAktiva.getModulAktiva();
msgString =  ctrlModulAktiva.getMessage();

if(iErrCode == 0 && iCommand != Command.EDIT){
	modulAktiva = new ModulAktiva();
}	

String strFixedAssetsLocName = "";
AktivaLocation objAktivaLocation = new AktivaLocation();
if(modulAktiva.getIdFixedAssetsLoc() != 0){
	try{
		objAktivaLocation = PstAktivaLocation.fetchExc(modulAktiva.getIdFixedAssetsLoc());
		if(objAktivaLocation != null){
			strFixedAssetsLocName = objAktivaLocation.getAktivaLocName();
		}
	}catch(Exception e){}
}

String contactName = "";
ContactList objContactList = new ContactList(); 
if(modulAktiva.getIdSupplier() != 0){
    try{
	objContactList = PstContactList.fetchExc(modulAktiva.getIdSupplier());
	if(objContactList != null){
	    if(objContactList.getCompName() != null && objContactList.getCompName().length() > 0){
		contactName = objContactList.getCompName();
	    }else{
		contactName = objContactList.getPersonName();
	    }
	}
    }catch(Exception e){}
}

if(iCommand==Command.NONE)
    iCommand = Command.ADD;


if(iCommand == Command.EDIT){
	dAccDep = PstPenyusutanAktiva.getTotalNilaiSusut(modulAktiva.getOID());
	dOBDepAcc = SessModulAktiva.countDepAccumulation(oidAktiva); 
	if(dOBDepAcc > 0){
	    sOBDepAcc = frmHandler.userFormatStringDecimal(dOBDepAcc);
	}
}else{
	dAccDep = 0;
}

int iQtyAwal = 0;
if(modulAktiva.getTglPerolehan() != null && oidAktiva != 0){
	try{
		iQtyAwal = SessReceiveAktiva.getOpeningBalanceQty(oidAktiva, modulAktiva.getTglPerolehan());
	}catch(Exception e){}
}

Vector vAccPayKey = new Vector(1,1);
Vector vAccPayVal = new Vector(1,1);

%>
<%if(((iCommand == Command.SAVE && iErrCode == 0) || iCommand == Command.DELETE)&& iFATipe == 1){%>
<jsp:forward page="modul_aktiva_list.jsp">
    <jsp:param name="command" value="<%=Command.LIST%>"/> 
</jsp:forward>
<%}%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<link rel="stylesheet" href="../../style/calendar.css" type="text/css">
<script type="text/javascript" src="../../main/digitseparator.js"></script>    
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function getThn()
{
	var date1 = ""+document.frmstandartrate.tgl_perolehan.value;
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
	document.frmstandartrate.tgl_perolehan_mn.value=bln;
	document.frmstandartrate.tgl_perolehan_dy.value=hri;
	document.frmstandartrate.tgl_perolehan_yr.value=thn;		
}

function countDep(){
    document.frmstandartrate.acc_penyusutan.value="<%=sOBDepAcc%>";
}

function openSupplier(){
    var url = "supplier_list.jsp?iCommand=<%=String.valueOf(Command.LIST)%>&"+
	      "<%=FrmSrcContactList.fieldNames[FrmSrcContactList.FRM_FIELD_NAME]%>="+document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_SUPPLIER_ID] %>_TEXT.value; 
    window.open(url,"open_supplier","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function changeTransType(){
    <%if(sAutoReceiveFA.equalsIgnoreCase("Y")){%>
    var transType = Math.abs(document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_TRANS_TYPE]%>.value);
    switch(transType){
	case <%=String.valueOf(I_TransactionType.TIPE_TRANSACTION_CASH)%>:
	    document.getElementById("dp").style.display = "none";
	    document.getElementById("acc_dp").style.display="none";
	    document.getElementById("cash").style.display = "";
	    document.getElementById("credit").style.display = "none";
	    document.getElementById("awal").style.display = "none";
	    <%if(iCommand == Command.ADD || iCommand == Command.EDIT){%>
		document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.value = document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]+"_cash"%>.value;
	    <%}%>
	break;
	case <%=String.valueOf(I_TransactionType.TIPE_TRANSACTION_KREDIT)%>:
	    document.getElementById("dp").style.display = "";
	    document.getElementById("acc_dp").style.display="";
	    document.getElementById("cash").style.display = "none";
	    document.getElementById("credit").style.display = "";
	    document.getElementById("awal").style.display = "none";
	    <%if(iCommand == Command.ADD || iCommand == Command.EDIT){%>
		document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.value = document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]+"_credit"%>.value;
	    <%}%>
	break;
	case <%=String.valueOf(I_TransactionType.TIPE_TRANSACTION_AWAL)%>:
	    document.getElementById("dp").style.display = "none";
	    document.getElementById("acc_dp").style.display="none";
	    document.getElementById("cash").style.display = "none";
	    document.getElementById("credit").style.display = "none";
	    document.getElementById("awal").style.display = "";
	    <%if(iCommand == Command.ADD || iCommand == Command.EDIT){%>
		document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.value = document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]+"_awal"%>.value;
	    <%}%>
	    break;
	
    }
    <%}%>
}   

function hideDP(){
    document.getElementById("dp").style.display = "none";
    document.getElementById("acc_dp").style.display="none";
    document.getElementById("credit").style.display = "none";
    document.getElementById("awal").style.display = "none";
}

function cmdAdd(){
	document.frmstandartrate.hidden_modul_aktiva_id.value="0";
	document.frmstandartrate.command.value="<%=String.valueOf(Command.ADD)%>";
	document.frmstandartrate.prev_command.value="<%=String.valueOf(prevCommand)%>";
	document.frmstandartrate.action="modul_aktiva_edit.jsp";
	document.frmstandartrate.submit();
}

function cmdAsk(oidAktiva){
	document.frmstandartrate.hidden_modul_aktiva_id.value=oidAktiva;
	document.frmstandartrate.command.value="<%=String.valueOf(Command.ASK)%>";
	document.frmstandartrate.prev_command.value="<%=String.valueOf(prevCommand)%>";
	document.frmstandartrate.action="modul_aktiva_edit.jsp";
	document.frmstandartrate.submit();
}

function hitDepProcentage(){
    var vLife = Math.abs(document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_MASA_MANFAAT] %>.value);
    var procen = 100;
    var procenLife = 0;
    if(vLife > 0){
	procenLife = procen / vLife;
    }
    document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_PERSEN_PENYUSUTAN] %>.value=procenLife;
   
}

function cmdConfirmDelete(oidAktiva){
	document.frmstandartrate.hidden_modul_aktiva_id.value=oidAktiva;
	document.frmstandartrate.command.value="<%=String.valueOf(Command.DELETE)%>";
	document.frmstandartrate.prev_command.value="<%=String.valueOf(prevCommand)%>";
	document.frmstandartrate.action="modul_aktiva_edit.jsp";
	document.frmstandartrate.submit();
}
function cmdSave(){
	document.frmstandartrate.command.value="<%=String.valueOf(Command.SAVE)%>";
	document.frmstandartrate.prev_command.value="<%=String.valueOf(prevCommand)%>";
	document.frmstandartrate.action="modul_aktiva_edit.jsp";
	if(confirm("<%=saveConfirm%>")){
		document.frmstandartrate.submit();
	}
}

function cmdopen(){
	url = "location_list.jsp?command=<%=String.valueOf(Command.LIST)%>&"+							
		  "name="+document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_AKTIVA_LOC_ID] %>_TEXT.value;
		  
	window.open(url,"src_fixed_assets_loc","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdEdit(oidAktiva){
	document.frmstandartrate.hidden_modul_aktiva_id.value=oidAktiva;
	document.frmstandartrate.command.value="<%=String.valueOf(Command.EDIT)%>";
	document.frmstandartrate.prev_command.value="<%=String.valueOf(prevCommand)%>";
	document.frmstandartrate.action="modul_aktiva_edit.jsp";
	document.frmstandartrate.submit();
	}

function cmdCancel(oidAktiva){
	document.frmstandartrate.hidden_modul_aktiva_id.value=oidAktiva;
	document.frmstandartrate.command.value="<%=String.valueOf(Command.EDIT)%>";
	document.frmstandartrate.prev_command.value="<%=String.valueOf(prevCommand)%>";
	document.frmstandartrate.action="modul_aktiva_edit.jsp";
	document.frmstandartrate.submit();
}

function cmdEnter(){
	if(event.keyCode == 13){
		cmdopen();
	}
}

function getText(element){
	parserNumber(element,false,0,'');	
}

function cmdBack(){
	document.frmstandartrate.command.value="<%=String.valueOf(Command.BACK)%>";
	document.frmstandartrate.action="modul_aktiva_list.jsp";
	document.frmstandartrate.submit();
	}

function hideObjectForDate(){
	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_TRANS_TYPE]%>.style.display="none";
	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_DP]%>.style.display="none";
	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>_cash.style.display="none";
	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>_credit.style.display="none";
	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>_awal.style.display="none";
  }
	
  function showObjectForDate(){
  	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_TRANS_TYPE]%>.style.display="";
	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_DP]%>.style.display="";
	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>_cash.style.display="";
	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>_credit.style.display="";
	document.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>_awal.style.display="";
  }	
  
//-------------- script control line -------------------
//-->
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
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
            Master Data : <font color="#CC3300"><%=textListTitle[SESS_LANGUAGE][0].toUpperCase()%></font> <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->

            <form name="frmstandartrate" method ="get" action="">
              <input type="hidden" name="command" value="<%=String.valueOf(iCommand)%>">
              <input type="hidden" name="vectSize" value="<%=String.valueOf(vectSize)%>">
              <input type="hidden" name="start" value="<%=String.valueOf(start)%>">
	      <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>" value="<%=String.valueOf(lIdPerkiraanPayment)%>">
	      <input type="hidden" name="fa_type" value="<%=String.valueOf(iFATipe)%>">
              <input type="hidden" name="prev_command" value="<%=String.valueOf(prevCommand)%>">
              <input type="hidden" name="hidden_modul_aktiva_id" value="<%=String.valueOf(oidAktiva)%>">
              <input type="hidden" name="<%=FrmAktiva.fieldNames[FrmAktiva.FRM_TYPE] %>" value="<%=String.valueOf(PstAktiva.TYPE_AKTIVA_JENIS_AKTIVA)%>">
              <%if(iFixedAssetsModule == 1){%>
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_AKTIVA]%>" value="1">
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_BYA_PENYUSUTAN]%>" value="1">
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_AKM_PENYUSUTAN]%>" value="1">
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_LB_PENJ_AKTIVA]%>" value="1">
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_RG_PENJ_AKTIVA]%>" value="1">
	      <%}%>
	      <%if(sAutoReceiveFA.equalsIgnoreCase("N")){%>
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_DOWN_PAYMENT]%>" value="0">
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_DP]%>" value="1">
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>" value="1">
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_SUPPLIER_ID]%>" value="1">
		    <input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_TRANS_TYPE]%>" value="0">
	      <%}%>
	      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top">
                  <td height="8" colspan="3">
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="21" valign="middle" width="22%">&nbsp;</td>
                        <td height="21" valign="middle" width="1%">&nbsp;</td>
                        <td width="77%" height="21" colspan="2" class="comment">*)= 
                          <%=textListTitle[SESS_LANGUAGE][1]%> </td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][0]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"> <input type="text" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_KODE] %>"  value="<%=modulAktiva.getKode()%>">
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_KODE) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][1]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"> <input type="text" size="50" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_NAME] %>"  value="<%=modulAktiva.getName()%>">
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_NAME) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][14]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"><%
                          Vector vtAktiva = PstAktivaGroup.list(0,0,"",PstAktivaGroup.fieldNames[PstAktivaGroup.FLD_KODE]);
                          Vector vAktivaKey = new Vector(1,1);
                          Vector vAktivaVal = new Vector(1,1);
                          vAktivaKey.add("0");
                          vAktivaVal.add("-Select-");

                          for(int k=0;k < vtAktiva.size();k++){
                            AktivaGroup aktiva = (AktivaGroup)vtAktiva.get(k);

                            vAktivaKey.add(""+aktiva.getOID());
                            vAktivaVal.add(aktiva.getNama());
                          }
                          out.println(ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_AKTIVA_GROUP_ID],"",null,""+modulAktiva.getAktivaGroupOid(),vAktivaKey,vAktivaVal,""));
				          %>
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_AKTIVA_GROUP_ID) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][2]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"><%
                          vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_JENIS_AKTIVA,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          vAktivaKey = new Vector(1,1);
                          vAktivaVal = new Vector(1,1);
                          vAktivaKey.add("0");
                          vAktivaVal.add("-Select-");
                          for(int k=0;k < vtAktiva.size();k++){
                            Aktiva aktiva = (Aktiva)vtAktiva.get(k);

                            vAktivaKey.add(""+aktiva.getOID());
                            vAktivaVal.add(aktiva.getNama());
                          }
                          out.println(ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_JENIS_AKTIVA_ID],"",null,""+modulAktiva.getJenisAktivaOid(),vAktivaKey,vAktivaVal,""));
				          %>
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_JENIS_AKTIVA_ID) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][3]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"><%
                          vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_TYPE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          vAktivaKey = new Vector(1,1);
                          vAktivaVal = new Vector(1,1);
                          vAktivaKey.add("0");
                          vAktivaVal.add("-Select-");
                          for(int k=0;k < vtAktiva.size();k++){
                            Aktiva aktiva = (Aktiva)vtAktiva.get(k);

                            vAktivaKey.add(""+aktiva.getOID());
                            vAktivaVal.add(aktiva.getNama());
                          }
                          out.println(ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_TYPE_PENYUSUTAN_ID],"",null,""+modulAktiva.getTypePenyusutanOid(),vAktivaKey,vAktivaVal,""));
				          %>
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_TYPE_PENYUSUTAN_ID) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][4]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"><%
                          vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_METODE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          vAktivaKey = new Vector(1,1);
                          vAktivaVal = new Vector(1,1);                         
                          vAktivaKey.add("0");
                          vAktivaVal.add("-Select-");
                          for(int k=0;k < vtAktiva.size();k++){
                            Aktiva aktiva = (Aktiva)vtAktiva.get(k);

                            vAktivaKey.add(""+aktiva.getOID());
                            vAktivaVal.add(aktiva.getNama());
                          }
                          out.println(ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_METODE_PENYUSUTAN_ID],"",null,""+modulAktiva.getMetodePenyusutanOid(),vAktivaKey,vAktivaVal,""));
				          %>
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_METODE_PENYUSUTAN_ID) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top">&nbsp;<%=textListHeader[SESS_LANGUAGE][16]%></td>
                        <td height="21" valign="top">:</td>
                        <td height="21" colspan="2"> <input onClick="ds_sh(this);" name="tgl_perolehan" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((modulAktiva.getTglPerolehan() == null) ? new Date() : modulAktiva.getTglPerolehan(), "dd-MM-yyyy")%>"/>	
                          *
                          <input type="hidden" name="tgl_perolehan_mn"> <input type="hidden" name="tgl_perolehan_dy"> 
                          <input type="hidden" name="tgl_perolehan_yr"> <script language="JavaScript" type="text/JavaScript">getThn();</script> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][5]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"> <input type="text" onKeyUp="javascript:hitDepProcentage()" style="text-align:right" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_MASA_MANFAAT] %>"  value="<%=String.valueOf(modulAktiva.getMasaManfaat())%>">
                          * <%=textListHeader[SESS_LANGUAGE][18]%><%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_MASA_MANFAAT) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][6]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"> <input type="text" style="text-align:right" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_PERSEN_PENYUSUTAN] %>"  value="<%=frmHandler.userFormatStringDecimal(modulAktiva.getPersenPenyusutan())%>">
                          *% <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_PERSEN_PENYUSUTAN) %> 
					  <tr align="left" valign="top">
                        <td height="21" valign="top">&nbsp;<%=textListHeader[SESS_LANGUAGE][19]%></td>
                        <td height="21" valign="top">:</td>
                        <td height="21" colspan="2"><input type="text" style="text-align:right" name="qty"  value="<%=String.valueOf(iQtyAwal)%>">
                          * </td>
						</tr>
						<%if(iCommand == Command.EDIT){%>                       
                      <tr align="left" valign="top">
                        <td height="21" valign="top">&nbsp;<%=textListHeader[SESS_LANGUAGE][20]%></td>
                        <td height="21" valign="top">:</td>
                        <td height="21" colspan="2"><input type="text" style="text-align:right" name="inqty" disabled value="<%=String.valueOf(qtyFAIn)%>"></td>
                      <tr align="left" valign="top">
                        <td height="21" valign="top">&nbsp;<%=textListHeader[SESS_LANGUAGE][21]%></td>
                        <td height="21" valign="top">:</td>
                        <td height="21" colspan="2"><input type="text" style="text-align:right" name="outqty" disabled value="<%=String.valueOf(qtyFAOut)%>"></td> 
					</tr>
					<%}%>	                     
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][7]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"> <input type="text" style="text-align:right" onKeyUp="javascript:getText(this)" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_HARGA_PEROLEHAN] %>"  value="<%=modulAktiva.getHargaPerolehan() == 0? "" : frmHandler.userFormatStringDecimal(modulAktiva.getHargaPerolehan())%>">
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_HARGA_PEROLEHAN) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top">&nbsp;<%=textListHeader[SESS_LANGUAGE][15]%></td>
                        <td height="21" valign="top">:</td>
                        <td height="21" colspan="2"> <input type="text" style="text-align:right" onKeyUp="javascript:getText(this)" name="acc_penyusutan"  value="<%=dAccDep == 0? "" : frmHandler.userFormatStringDecimal(dAccDep)%>">
                        <%if(dAccDep == 0 && iFATipe == 1){%>
			<a href="javascript:countDep()"><img border="0" alt="Count Depreciation" src="<%=approot%>/dtree/img/base.gif"></a>
			<%}%>
			* 
                      <tr align="left" valign="top"> 
                        <td height="23" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][8]%></td>
                        <td height="23" valign="top" width="1%">:</td>
                        <td height="23" colspan="2"> <input type="text" style="text-align:right" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_NILAI_RESIDU] %>"  value="<%=frmHandler.userFormatStringDecimal(modulAktiva.getNilaiResidu() == 0? 1 : modulAktiva.getNilaiResidu())%>">
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_NILAI_RESIDU) %> 
		    <%if(sAutoReceiveFA.equalsIgnoreCase("Y")){%>  
		    <tr align="left" valign="top"> 
                        <td height="23" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][25]%></td>
                        <td height="23" valign="top" width="1%">:</td>
                        <td height="23" colspan="2"> 
			  <%
			      Vector vTransKey = new Vector(1,1);
			      Vector vTransVal = new Vector(1,1);			      
                              vAktivaKey.add("0");
                              vAktivaVal.add("-Select-");
			      for(int k=0;k < 3;k++){	 			
				vTransKey.add(""+k);
				vTransVal.add(I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][k]);
			      }
			  %>
			  <%= ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_TRANS_TYPE],null, ""+modulAktiva.getTransType(), vTransKey,vTransVal, "onChange=\"javascript:changeTransType()\"", "")%> 
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_NILAI_RESIDU) %>  
			<tr align="left" valign="top" id="dp">
                        <td height="21" valign="top">&nbsp;<%=textListHeader[SESS_LANGUAGE][22]%></td>
                        <td height="21" valign="top">:</td>			
                        <td height="21" colspan="2"><input type="text" onKeyUp="javascript:getText(this)" style="text-align:right" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_DOWN_PAYMENT] %>" value="<%=frmHandler.userFormatStringDecimal(modulAktiva.getDownPayment())%>"></td>  
                        </tr>
			<tr align="left" valign="top" id="acc_dp"> 
                        <td height="23" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][23]%></td>
                        <td height="23" valign="top" width="1%">:</td>
                        <td height="23" colspan="2"> 
			  <%
			      Vector vAccDpKey = new Vector(1,1);
			      Vector vAccDpVal = new Vector(1,1);			      
                              vAccDpKey.add("0");
                              vAccDpVal.add("-Select-");
			      for(int a=0;a < vCash.size();a++){
				Perkiraan objPerkiraan = new Perkiraan();
				objPerkiraan = (Perkiraan) vCash.get(a); 
				vAccDpKey.add(""+objPerkiraan.getOID());
				vAccDpVal.add(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? objPerkiraan.getAccountNameEnglish() : objPerkiraan.getNama());
			      }			     
			  %>
			  <%= ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_DP],null, ""+modulAktiva.getIdPerkiraanDp(), vAccDpKey,vAccDpVal, "", "")%> 
                          * 
			  </tr>
			<tr align="left" valign="top"> 
                        <td height="23" valign="top" width="22%">&nbsp;<%=textListHeader[SESS_LANGUAGE][24]%></td>
                        <td height="23" valign="top" width="1%">:</td>
                        <td height="23" id="cash"> 
			  <%
			      Vector vCashKey = new Vector(1,1);
			      Vector vCashVal = new Vector(1,1);
			      String sCashSelected = String.valueOf(modulAktiva.getIdPerkiraanPayment());
			      vCashKey.add("0");
			      vCashVal.add("-Select-");
			       if(vCash != null && vCash.size() > 0){
				  for(int c=0;c < vCash.size();c++){
				    Perkiraan objPerkiraan = new Perkiraan();
				    objPerkiraan = (Perkiraan) vCash.get(c); 
				    vCashKey.add(""+objPerkiraan.getOID());
				    vCashVal.add(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? objPerkiraan.getAccountNameEnglish() : objPerkiraan.getNama());
				  }
			      }
			  %>
			  <%= ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]+"_cash",null, sCashSelected, vCashKey,vCashVal, "", "")%> 
			  </td>
			  <td height="23" id="credit"> 
			  <%
			      Vector vCreditKey = new Vector(1,1);
			      Vector vCreditVal = new Vector(1,1);
			      String sCreditSelected = String.valueOf(modulAktiva.getIdPerkiraanPayment());
			      if(vAP != null && vAP.size() > 0){
                                  vCreditKey.add("-");
                                  vCreditVal.add("-Select-");
				  for(int c=0;c < vAP.size();c++){
				    Perkiraan objPerkiraan = new Perkiraan();
				    objPerkiraan = (Perkiraan) vAP.get(c); 
				    vCreditKey.add(""+objPerkiraan.getOID());
				    vCreditVal.add(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? objPerkiraan.getAccountNameEnglish() : objPerkiraan.getNama());
				  }
			    }
			  %>
			  <%= ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]+"_credit",null, sCreditSelected, vCreditKey,vCreditVal, "", "")%> 
			  </td>
			  <td height="23" id="awal"> 
			  <%
			      Vector vAwalKey = new Vector(1,1);
			      Vector vAwalVal = new Vector(1,1);
			      String sAwalSelected = String.valueOf(modulAktiva.getIdPerkiraanPayment());
			      if(vEQuity != null && vEQuity.size() > 0){
				  vAwalKey.add("0");
				  vAwalVal.add("-Select-");
				  for(int c=0;c < vEQuity.size();c++){
				    Perkiraan objPerkiraan = new Perkiraan();
				    objPerkiraan = (Perkiraan) vEQuity.get(c); 
				    vAwalKey.add(""+objPerkiraan.getOID());
				    vAwalVal.add(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? objPerkiraan.getAccountNameEnglish() : objPerkiraan.getNama());
				  }
			      }
			  %>
			  <%= ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_PAYMENT]+"_awal",null, sAwalSelected, vAwalKey,vAwalVal, "", "")%> 
			  </td>
                          *
			<tr align="left" valign="top">
                        <td height="21" valign="top" nowrap>&nbsp;<%=textListHeader[SESS_LANGUAGE][26]%></td>
                        <td height="21" valign="top">:</td>
                        <td height="21" colspan="2"><input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_SUPPLIER_ID] %>"  value="<%=String.valueOf(modulAktiva.getIdSupplier())%>">
			<input type="text" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_SUPPLIER_ID] %>_TEXT"  value="<%=contactName%>" onKeyDown="javascript:cmdEnter()">
                         * <a href="javascript:openSupplier()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a> <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_SUPPLIER_ID) %>   
			<%}%>
			<tr align="left" valign="top">
                        <td height="21" valign="top" nowrap>&nbsp;<%=textListHeader[SESS_LANGUAGE][17]%></td>
                        <td height="21" valign="top">:</td>
                        <td height="21" colspan="2"><input type="hidden" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_AKTIVA_LOC_ID] %>"  value="<%=String.valueOf(modulAktiva.getIdFixedAssetsLoc())%>">
						<input type="text" name="<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_AKTIVA_LOC_ID] %>_TEXT"  value="<%=strFixedAssetsLocName%>" onKeyDown="javascript:cmdEnter()">
                         * <a href="javascript:cmdopen()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a> <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_AKTIVA_LOC_ID) %> 
                      <%if(iFixedAssetsModule == 0){%>
					  <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%" nowrap>&nbsp;<%=textListHeader[SESS_LANGUAGE][9]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"><%
                          Vector vtPerk = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_FIXED_ASSETS);
                          Vector vPerkKey = new Vector(1,1);
                          Vector vPerkVal = new Vector(1,1);
                          vPerkKey.add("0");
                          vPerkVal.add("-Select-");
                          for(int k=0;k < vtPerk.size();k++){
                            Perkiraan perkiraan = (Perkiraan)vtPerk.get(k);
                            vPerkKey.add(""+perkiraan.getOID());
                           // vPerkVal.add(perkiraan.getNama());
                            vPerkVal.add(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? perkiraan.getAccountNameEnglish() : perkiraan.getNama());

                          }
                          out.println(ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_AKTIVA],"",null,""+modulAktiva.getIdPerkiraanAktiva(),vPerkKey,vPerkVal,""));
				          %>
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_ID_PERKIRAAN_AKTIVA) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%" nowrap>&nbsp;<%=textListHeader[SESS_LANGUAGE][10]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"><%
                          vtPerk = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_BIAYA_PENYUSUTAN);
                          vPerkKey = new Vector(1,1);
                          vPerkVal = new Vector(1,1);
                          vPerkKey.add("0");
                          vPerkVal.add("-Select-");
                          for(int k=0;k < vtPerk.size();k++){
                            Perkiraan perkiraan = (Perkiraan)vtPerk.get(k);
                            vPerkKey.add(""+perkiraan.getOID());
                            //vPerkVal.add(perkiraan.getNama());
                            vPerkVal.add(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? perkiraan.getAccountNameEnglish() : perkiraan.getNama());
                          }
                          out.println(ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_BYA_PENYUSUTAN],"",null,""+modulAktiva.getIdPerkiraanByaPenyusutan(),vPerkKey,vPerkVal,""));
				          %>
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_ID_PERKIRAAN_BYA_PENYUSUTAN) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%" nowrap>&nbsp;<%=textListHeader[SESS_LANGUAGE][11]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"><%
                          vtPerk = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_AKU_PENYUSUTAN);
                          vPerkKey = new Vector(1,1);
                          vPerkVal = new Vector(1,1);
                          vPerkKey.add("0");
                          vPerkVal.add("-Select-");
                          for(int k=0;k < vtPerk.size();k++){
                            Perkiraan perkiraan = (Perkiraan)vtPerk.get(k);
                            vPerkKey.add(""+perkiraan.getOID());
                            //vPerkVal.add(perkiraan.getNama());
                            vPerkVal.add(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? perkiraan.getAccountNameEnglish() : perkiraan.getNama());
                          }
                          out.println(ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_AKM_PENYUSUTAN],"",null,""+modulAktiva.getIdPerkiraanAkmPenyusutan(),vPerkKey,vPerkVal,""));
				          %>
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_ID_PERKIRAAN_AKM_PENYUSUTAN) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%" nowrap>&nbsp;<%=textListHeader[SESS_LANGUAGE][12]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"><%
                          vtPerk = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_OTHER_REVENUE);
                          vPerkKey = new Vector(1,1);
                          vPerkVal = new Vector(1,1);
                          vPerkKey.add("0");
                          vPerkVal.add("-Select-");
                          for(int k=0;k < vtPerk.size();k++){
                            Perkiraan perkiraan = (Perkiraan)vtPerk.get(k);
                            vPerkKey.add(""+perkiraan.getOID());
                            //vPerkVal.add(perkiraan.getNama());
                            vPerkVal.add(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? perkiraan.getAccountNameEnglish() : perkiraan.getNama());
                          }
                          out.println(ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_LB_PENJ_AKTIVA],"",null,""+modulAktiva.getIdPerkiraanLbPenjAktiva(),vPerkKey,vPerkVal,""));
				          %>
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_ID_PERKIRAAN_LB_PENJ_AKTIVA) %> 
                      <tr align="left" valign="top"> 
                        <td height="21" valign="top" width="22%" nowrap>&nbsp;<%=textListHeader[SESS_LANGUAGE][13]%></td>
                        <td height="21" valign="top" width="1%">:</td>
                        <td height="21" colspan="2"><%
                          vtPerk = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_OTHER_EXPENSE);
                          vPerkKey = new Vector(1,1);
                          vPerkVal = new Vector(1,1);
                          vPerkKey.add("0");
                          vPerkVal.add("-Select-");
                          for(int k=0;k < vtPerk.size();k++){
                            Perkiraan perkiraan = (Perkiraan)vtPerk.get(k);
                            vPerkKey.add(""+perkiraan.getOID());
                            //vPerkVal.add(perkiraan.getNama());
                            vPerkVal.add(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? perkiraan.getAccountNameEnglish() : perkiraan.getNama());
                          }
                          out.println(ControlCombo.draw(FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_ID_PERKIRAAN_RG_PENJ_AKTIVA],"",null,""+modulAktiva.getIdPerkiraanRgPenjAktiva(),vPerkKey,vPerkVal,""));
				          %>
                          * <%= frmModulAktiva.getErrorMsg(FrmModulAktiva.FRM_ID_PERKIRAAN_RG_PENJ_AKTIVA) %> 
                      <%}%>
					  <tr align="left" valign="top" > 
                        <td colspan="5" class="command">&nbsp;</td>
                      </tr>
                      <tr align="left" valign="top" > 
                        <td colspan="5" class="command"> 
			<%
			    ctrLine.setLocationImg(approot+"/images");
			    ctrLine.initDefault();
			    ctrLine.setTableWidth("80%");
			    String scomDel = "javascript:cmdAsk('"+oidAktiva+"')";
			    String sconDelCom = "javascript:cmdConfirmDelete('"+oidAktiva+"')";
			    String scancel = "javascript:cmdEdit('"+oidAktiva+"')";
			    ctrLine.setCommandStyle("command");
			    ctrLine.setColCommStyle("command");
			    ctrLine.setBackCaption(strBackMar);
			    ctrLine.setSaveCaption(strSaveMar);
			    ctrLine.setDeleteCaption(strAskMar);
			    ctrLine.setConfirmDelCaption(strDeleteMar);

			    if (privDelete){
				    ctrLine.setConfirmDelCommand(sconDelCom);
				    ctrLine.setDeleteCommand(scomDel);
				    ctrLine.setEditCommand(scancel);
			    }else{
				    ctrLine.setConfirmDelCaption("");
				    ctrLine.setDeleteCaption("");
				    ctrLine.setEditCaption("");
			    }

			    if(privAdd == false  && privUpdate == false){
				    ctrLine.setSaveCaption("");
			    }

			    if (privAdd == false){
				    ctrLine.setAddCaption("");
			    }

			    if(iCommand == Command.ASK)
			    {
				    ctrLine.setDeleteQuestion(delConfirm);
			    }

			    if(iCommand == Command.SAVE){
				    iCommand = Command.ADD;
				    ctrLine.setAddCaption("");
				    ctrLine.setBackCaption("");
			    }
			    if(iCommand == Command.ADD){
				    ctrLine.setCancelCaption("");
			    }
			    out.println(ctrLine.draw(iCommand, iErrCode, msgString));
			    %> 
			   </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </form>
            <%
			if(iCommand==Command.ADD || iCommand==Command.EDIT)
			{
			%>
            <script language="javascript">
				document.frmstandartrate.<%=FrmAktiva.fieldNames[FrmAktiva.FRM_KODE]%>.focus();				
	    </script>
            <%
			}
			%>
	   <script language="javascript">
				document.frmstandartrate.<%=FrmAktiva.fieldNames[FrmAktiva.FRM_KODE]%>.focus();
				hideDP();
				changeTransType();
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
