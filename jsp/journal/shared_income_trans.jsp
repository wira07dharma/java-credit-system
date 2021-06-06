<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.text.*" %>
<%//@ page import = "java.util.*" %>
<%//@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!--import qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%//@ page import = "com.dimata.qdep.db.*" %>
<%//@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<!--import common-->

<%@ page import = "com.dimata.common.entity.payment.*" %>
<!--import aiso-->
<%@ page import = "com.dimata.aiso.entity.jurnal.*" %>
<%//@ page import = "com.dimata.aiso.entity.admin.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.entity.search.*" %>
<%@ page import = "com.dimata.aiso.form.search.*" %>
<%//@ page import = "com.dimata.aiso.form.periode.*" %>
<%@ page import = "com.dimata.aiso.form.jurnal.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>
<%//@ page import = "com.dimata.aiso.session.periode.*" %>
<%@ page import = "com.dimata.aiso.session.journal.*" %>
<!-- import common -->
<%@ page import="com.dimata.common.entity.contact.*" %>
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
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static final int INT_VALID_DELETE = 0;
public static final int INT_INVALID_DELETE = 1;

public static String strTitle[][] = {
	{"No Voucher","Tanggal Transaksi","Tanggal Input","Transaksi Dalam","Keterangan Jurnal","Nama Kontak","Nama Operator","Kelompok Perkiraan","Nama Perkiraan","Debet","Kredit","Daftar Jurnal Detail","Tipe Pembukuan", "Bobot"},	
	{"Voucher No","Transaction Date","Entry Date","Transaction In","Journal Description","Contact Name","Operator Name","Account Group","Account Name","Debit","Credit","List Detail's Journal","Book Type", "Weight"}
};

public static final String masterTitle[] = {
	"Transaksi", "Transaction"	
};

public static final String listTitle[] = {
	"Shared Income Transaksi", "Shared Income Transaction"	
};

/**
* this method used to list jurnal detail
*/
public String listJurnalDetail(int language,
                               FrmJurnalDetail frmjurnaldetail,
                               Vector listjurnaldetail,
                               Vector listCode,
                               Vector listCurrencyType){
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitle[language][7],"15%","center","center");
	ctrlist.dataFormat(strTitle[language][8],"55%","center","center");
        ctrlist.dataFormat(strTitle[language][13], "10%", "center", "center");
	ctrlist.dataFormat(strTitle[language][9],"10%","center","center");
	ctrlist.dataFormat(strTitle[language][10],"10%","center","center");
	ctrlist.setLinkRow(1);	
	//ctrlist.setLinkPrefix("javascript:parent.frames[0].cmdClickAccountJu('");
	//ctrlist.setLinkSufix("')");
	ctrlist.reset();

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();							
	Vector rowx = new Vector();	
	String attr = "onChange=\"javascript:cmdChangeAccount()\"";		 		
	String strSelect = "";										
	
	// list account code
	Vector accCodeKey = new Vector(1,1);
	Vector accCodeVal = new Vector(1,1);	
	if(listCode!=null && listCode.size()>0){
		String space = "";
		String style = "";
		for(int i=0; i<listCode.size(); i++){  
		   Perkiraan perkiraan = (Perkiraan)listCode.get(i); 
		   switch(perkiraan.getLevel()){
			   case 1 : space = ""; break; 
			   case 2 : space = "&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 3 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;															    															   															   															   															   
		   }
		   accCodeKey.add(""+perkiraan.getOID());
		   accCodeVal.add(space + perkiraan.getNoPerkiraan() + "&nbsp;&nbsp;&nbsp;&nbsp;"+perkiraan.getNama()); 
		 } 
	}
	
	Hashtable hashCurrency = new Hashtable();
	if(listCurrencyType!=null && listCurrencyType.size()>0)
	{
		int maxCurr = listCurrencyType.size();
		for(int it=0; it<maxCurr; it++)
		{
			CurrencyType currencyType =(CurrencyType)listCurrencyType.get(it);
			hashCurrency.put(""+currencyType.getOID(),currencyType.getName()+"("+currencyType.getCode()+")");	
		}
	}
	
	for(int it = 0; it<listjurnaldetail.size();it++){																								
		 JurnalDetail jdetail = (JurnalDetail)listjurnaldetail.get(it);
    	 rowx = new Vector();
		 
		 // if jd.datastatus!=DELETE ---> don't display it, otherwise ---> display it
		 if(jdetail.getDataStatus()!=PstJurnalDetail.DATASTATUS_DELETE){		 	 
			 Vector listAccount = SessPerkiraan.findFieldPerkiraan(jdetail.getIdPerkiraan());
		     String namaAcc = "";			 
			 int groupPerkiraan = 1;
		     boolean postableAcc = false;   
			 if(listAccount!=null && listAccount.size()>0){
				Perkiraan account = (Perkiraan)listAccount.get(0);
				namaAcc = account.getNama();
				postableAcc = account.getPostable();
				groupPerkiraan = Integer.parseInt(account.getNoPerkiraan().substring(0,1));																									 													 													 
			 }													 
			 strSelect = ""+ jdetail.getIdPerkiraan();			 
			
			 rowx.add(PstPerkiraan.estimationNames[language][groupPerkiraan]);
			 //rowx.add("<a href=\"#\" onClick=\"parent.frames[0].cmdClickAccountJu('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">" + namaAcc + "</a>");
			 //rowx.add("<a href=\"javascript:parent.frames[0].cmdClickAccountJu('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">" + namaAcc + "</a>");
			 //rowx.add("<a href=\"javascript:parent.frames[0].testClick()\">" + namaAcc + "</a>");			 
			 rowx.add(frmjurnaldetail.userFormatStringDecimal(jdetail.getDebet()));
			 rowx.add(frmjurnaldetail.userFormatStringDecimal(jdetail.getKredit()));

			 //lstLinkData.add();													 					 
			 lstData.add(rowx); 
		 }		 
	 }	 
	 return ctrlist.drawMe(); 													 												
}

public String drawListTotal(FrmJurnalDetail frmjurnaldetail, String strMessage, double debet, double kredit){
	String result = "<table width=\"100%\"><tr><td>"+
						"<table width=\"100%\" border=\"0\" cellspacing=\"1\">"+
							"<tr>"+
								"<td width=\"80%\" class=\"msgbalance\">"+
									"<div align=\"left\"><i>"+strMessage+"</i></div>"+
								"</td>"+
								"<td width=\"10%\" class=\"listgenTitle\">"+
									"<div align=\"right\">"+frmjurnaldetail.userFormatStringDecimal(debet)+"</div>"+
								"</td>"+
								"<td width=\"10%\" class=\"listgenTitle\">"+
									"<div align=\"right\">"+frmjurnaldetail.userFormatStringDecimal(kredit)+"</div>"+
								"</td>"+				
							"</tr>"+
						"</table>"+
						"</td></tr></table>";	
	return result;					
}
%>


<!-- JSP Block -->
<%
/** get request from hidden text */
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE JOURNAL PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES JURNAL SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");  
int addType = FRMQueryString.requestInt(request,"add_type");
long journalID = FRMQueryString.requestLong(request,"journal_id");
int accountGroup = FRMQueryString.requestInt(request,"account_group");
if(accountGroup==0){ accountGroup=1; }
int bpNumber = FRMQueryString.requestInt(request,"bpNumber");
int index = FRMQueryString.requestInt(request,"index");
int isValidDelete = FRMQueryString.requestInt(request,"is_valid_delete");

int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long detailID = FRMQueryString.requestLong(request,"detail_id");
long idAccount = FRMQueryString.requestLong(request,"perkiraan");

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Journal" : "Tambah Baru Jurnal";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : "Tambah Baru Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Journal List" : "Kembali Ke Daftar Jurnal";
String strPosted = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Posted Journal" : "Posted Jurnal";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Journal" : "Hapus Jurnal";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Journal" : "Ya Hapus Jurnal";

long periodeOID = SessPeriode.getCurrPeriodId();
String msgErr = "";

// get masterdata currency
String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);


/** handle searching parameter in session */
SrcJurnalUmum srcJurnalUmum = new SrcJurnalUmum();
if(iCommand==Command.ADD){
	if((addType==ADD_TYPE_LIST)&&(session.getValue(SrcJurnalUmum.SESS_SEARCH_JURNAL_UMUM)!=null)){
		srcJurnalUmum = (SrcJurnalUmum)session.getValue(SrcJurnalUmum.SESS_SEARCH_JURNAL_UMUM);			
	}	
	if(addType==ADD_TYPE_SEARCH){
		FrmSrcJurnalUmum frmSrcJurnalUmum = new FrmSrcJurnalUmum(request);	
		frmSrcJurnalUmum.requestEntityObject(srcJurnalUmum);	
		session.putValue(SrcJurnalUmum.SESS_SEARCH_JURNAL_UMUM, srcJurnalUmum);			
	}
}

/** Instansiasi object CtrlJurnalUmum and FrmJurnalUmum */
CtrlJurnalUmum ctrlJurnalUmum = new CtrlJurnalUmum(request);
ctrlJurnalUmum.setLanguage(SESS_LANGUAGE);
FrmJurnalUmum frmJurnalUmum = ctrlJurnalUmum.getForm();
CtrlJurnalDetail ctrljurnaldetail = new CtrlJurnalDetail(request) ; 

FrmJurnalDetail frmjurnaldetail = ctrljurnaldetail.getForm();
frmjurnaldetail.setDecimalSeparator(sUserDecimalSymbol); 
frmjurnaldetail.setDigitSeparator(sUserDigitGroup);

int ctrlErr = ctrlJurnalUmum.action(iCommand, journalID, userOID);  
JurnalUmum jurnalumum = ctrlJurnalUmum.getJurnalUmum();

/** Saving object jurnalumum into session */
if((iCommand==Command.EDIT)||(iCommand==Command.POST&&ctrlErr==ctrlJurnalUmum.RSLT_OK)){ 
	jurnalumum.setVoucherNo(SessPeriode.getStrVoucherEdit(jurnalumum.getVoucherNo()));
	session.putValue(SessJurnalUmum.SESS_JURNAL_MAIN,jurnalumum);
}

/** Set initial value for object jUmum that will handle object from session */
JurnalUmum jUmum = jurnalumum; 
if(iCommand!=Command.ADD){
	if(session.getValue(SessJurnalUmum.SESS_JURNAL_MAIN)!=null){
	jUmum = (JurnalUmum)session.getValue(SessJurnalUmum.SESS_JURNAL_MAIN);
	}
}
boolean periodClosed = SessPeriode.isPeriodClosed(jUmum.getPeriodeId());

/** if Command.ASK, check journal subledger to get 'deleteValidity' status */
if(iCommand==Command.ASK){
	Vector tempJurResult = jUmum.getJurnalDetails();		
	if(tempJurResult!=null && tempJurResult.size()>0){
		for(int i=0; i<tempJurResult.size(); i++){
			JurnalDetail jurD = (JurnalDetail)tempJurResult.get(i);			
			if(!(jUmum.isEmptyBpAktivaTetap(jurD)&&jUmum.isEmptyBpAktivaLain(jurD)&&jUmum.isEmptyBpPiutang(jurD)&&jUmum.isEmptyBpUtang(jurD))){	   		
			   if(!jUmum.isEmptyBpAktivaTetap(jurD)){
				   for(int j=0; j<jurD.getBpAktivaTetap().size(); j++){
					   BpAktivaTetap subAktivaTetap = jurD.getBpAktivaTetap(j);	   
					   SessBpPiutang sessBpPiutang = new SessBpPiutang();	
					   if(!sessBpPiutang.isValidDelete(subAktivaTetap.getOID(),PstPerkiraan.SUB_LEDGER_FIXED_ASSET,PstBpAktivaTetap.TBL_BP_AKTIVA_TETAP)){
						   isValidDelete = INT_INVALID_DELETE; 
						   break;  
					   }
				   }					   	   
			   }	   
			   if(!jUmum.isEmptyBpAktivaLain(jurD)){
				   for(int j=0; j<jurD.getBpAktivaLain().size(); j++){			   
					   BpAktivaLain subAktivaLain = jurD.getBpAktivaLain(j);	   
					   SessBpPiutang sessBpPiutang = new SessBpPiutang();	
					   if(!sessBpPiutang.isValidDelete(subAktivaLain.getOID(),PstPerkiraan.SUB_LEDGER_OTHER_ASSET,PstBpAktivaLain.TBL_BP_AKTIVA_LAIN)){
						   isValidDelete = INT_INVALID_DELETE;
						   break;  
					   }
				   }   
			   }	   
			   if(!jUmum.isEmptyBpPiutang(jurD)){
				   for(int j=0; j<jurD.getBpPiutang().size(); j++){			   			   
					   BpPiutang subPiutang = jurD.getBpPiutang(j);	   
					   SessBpPiutang sessBpPiutang = new SessBpPiutang();	
					   if(!sessBpPiutang.isValidDelete(subPiutang.getOID(),PstPerkiraan.SUB_LEDGER_RECEIVABLE,PstBpPiutang.TBL_BP_PIUTANG)){
						   isValidDelete = INT_INVALID_DELETE;
						   break;
					   }  
				   }					   
			   }	   
			   if(!jUmum.isEmptyBpUtang(jurD)){
				   for(int j=0; j<jurD.getBpUtang().size(); j++){			   			   			   
					   BpUtang subUtang = jurD.getBpUtang(j);	   
					   SessBpPiutang sessBpPiutang = new SessBpPiutang();	
					   if(!sessBpPiutang.isValidDelete(subUtang.getOID(),PstPerkiraan.SUB_LEDGER_LIABILITY,PstBpUtang.TBL_BP_UTANG)){
						   isValidDelete = INT_INVALID_DELETE; 
						   break;
					   }  					   
				   }					  	   
			   }
			}			
	    if(isValidDelete==INT_INVALID_DELETE){break;}		   	   	   			
		}   
	}	

	if(isValidDelete==INT_INVALID_DELETE){
	   if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){ 	
		   msgErr = "Cannot delete journal because referenced by other journal ...";
	   }else{
		   msgErr = "Tidak bisa hapus jurnal karena datanya dipakai jurnal lain ...";	   
	   }
	}	
}

/** if Command.POST and no error occur, redirect to journal detail page */
if((iCommand==Command.POST)&&(ctrlErr==ctrlJurnalUmum.RSLT_OK)){
%>
	<jsp:forward page="__jdetail.jsp"> 
	<jsp:param name="command" value="<%=Command.ADD%>"/>
	</jsp:forward>
<%
}

/** if Command.DELETE, delete journal and its descendant and redirect to journal detail page */
if(iCommand==Command.DELETE){
    ctrlJurnalUmum.journalDelete(journalID);		
%>
	<jsp:forward page="__jlist.jsp"> 
	<jsp:param name="start" value="<%=start%>"/>
	<jsp:param name="command" value="<%=Command.BACK%>"/>
	</jsp:forward>
<%
}

/** Posted journal, and get all data from formJournal except its details and subledger */
if(iCommand==Command.SAVE){
	 Vector tempDetail = (Vector)jUmum.getJurnalDetails(); //---> save existing details data from session	 
	 frmJurnalUmum.requestEntityObject(jUmum); //---> get current data from journal main form 		  
	 jUmum.setUserId(userOID); 
	 jUmum.setTglEntry(new Date());
	 jUmum.setPeriodeId(periodeOID);
	 jUmum.setJurnalDetails(tempDetail);                                                      
	 ctrlErr = ctrlJurnalUmum.JournalPosted(ctrlJurnalUmum.POSTED_JU, jUmum.getOID(),jUmum); 
	 session.putValue(SessJurnalUmum.SESS_JURNAL_MAIN,jUmum);	 
	 %>
	 <jsp:forward page="__jlist.jsp"> 
	 <jsp:param name="start" value="<%=start%>"/>	 
	 <jsp:param name="command" value="<%=Command.BACK%>"/>
	 </jsp:forward>
	 <%	 	 	 	 
}

/** check if details already exist or not yet */
double amountDt = 0;
double amountCr = 0;

boolean boolDetail = false;
boolean balance = false;
String msgBalance = "";
if(!jUmum.getJurnalDetails().isEmpty()){ 
	Vector vectListJd = jUmum.getJurnalDetails();
	amountDt = SessJurnalUmum.getBalanceSide(vectListJd,SessJurnalUmum.SIDE_DEBET);
	amountCr = SessJurnalUmum.getBalanceSide(vectListJd,SessJurnalUmum.SIDE_CREDIT);
		
	boolDetail = true; 
	if(SessJurnalUmum.checkBalance(vectListJd)){
		balance = true;
		if(msgBalance==""){ 
			if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
				msgBalance = "journal detail already balance ..."; 
			}else{
				msgBalance = "jurnal detail sudah seimbang ..."; 
			}
		}		
	}else{
		if(msgBalance==""){ 
			if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){		
				msgBalance = "journal detail hasn't balance yet ..."; 
			}else{
				msgBalance = "jurnal detail belum seimbang ..."; 
			}
		}	
	}	
}
  
Vector listjurnaldetail = jUmum.getJurnalDetails();
Vector listCode = AppValue.getAppValueVector(accountGroup);
Vector listAllCode = AppValue.getAppValueVector(AppValue.ACCOUNT_CHART);

Periode currPeriod = new Periode();
try{
	currPeriod = PstPeriode.fetchExc(periodeOID);
}catch(Exception e){
}

String ordBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
Vector listPeriod = PstPeriode.list(0,0,"",ordBy);
Date firstPeriodDate = new Date();
if(listPeriod!=null && listPeriod.size()>0){
	Periode per = (Periode)listPeriod.get(0);
	firstPeriodDate = per.getTglAwal();
}
Date nowDate = new Date();
int interval = firstPeriodDate.getYear() - nowDate.getYear();


%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
<%if((privView)&&(privAdd)&&(privSubmit)){%>
function addNewDetail(){
	document.frmjournal.perkiraan.value=0;
	document.frmjournal.index.value=-1;
	document.frmjournal.command.value="<%=Command.ADD%>";
	document.frmjournal.prev_command.value="<%=Command.ADD%>";
	document.frmjournal.target="_self";	
	//document.frmjournal.action="jdetail.jsp";
	document.frmjournal.submit();
}

function addNew(){
	document.frmjournal.journal_id.value="0";
	document.frmjournal.command.value="<%=Command.ADD%>";
	document.frmjournal.target="_self";	
	//document.frmjournal.action="jdetail.jsp";
	document.frmjournal.submit();
}

function cmdCancel(){
	document.frmjournal.command.value="<%=Command.NONE%>";
	//document.frmjournal.target="_self";	
	document.frmjournal.action="shared_income_trans.jsp";	
	document.frmjournal.submit();
}

function cmdSave(){
	document.frmjournal.command.value="<%=Command.SAVE%>";
	//document.frmjournal.target="_self";	
	document.frmjournal.action="shared_income_trans.jsp";
	document.frmjournal.submit();
}

function cmdAsk(){
	document.frmjournal.command.value="<%=Command.ASK%>";
	//document.frmjournal.target="_self";	
	document.frmjournal.action="shared_income_trans.jsp";
	document.frmjournal.submit();
}

function cmdDelete(oid){
	document.frmjournal.journal_id.value=oid;
	document.frmjournal.command.value="<%=Command.DELETE%>";
	//document.frmjournal.target="_self";	
	document.frmjournal.action="shared_income_trans.jsp";
	document.frmjournal.submit();
}

function cmdItemData(){
	document.frmjournal.index.value=-1;
	document.frmjournal.command.value="<%=Command.LIST%>";
	//document.frmjournal.target="_self";	
	//document.frmjournal.action="jdetail.jsp";	
	document.frmjournal.submit();
}

function cmdAddDetail(){
	document.frmjournal.command.value="<%=Command.POST%>";
	//document.frmjournal.target="_self";	
	document.frmjournal.action="shared_income_trans.jsp";	
	document.frmjournal.submit();
}
<%}%>

function cmdBack(){
	document.frmjournal.command.value="<%=Command.BACK%>";
	document.frmjournal.start.value="<%=start%>";
	document.frmjournal.action="__jlist.jsp";	
	document.frmjournal.submit();
}

function cmdChangeCurrency(){
	var curr = document.frmjournal.<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_MATAUANG]%>.value;
	if(curr==0){
		document.frmjournal.<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_RATE]%>.style.background="#E8E8E8";	
		document.frmjournal.<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_RATE]%>.readOnly=true;			
	}	
	if(curr==1){
		document.frmjournal.<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_RATE]%>.style.background="#FFFFFF";
		document.frmjournal.<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_RATE]%>.readOnly=false;			
	}
}

function cmdSearchContact(){
	var strUrl = "contactdosearch.jsp?command=<%=Command.FIRST%>"+
				 "&contact_type=-1"+	
				 "&contact_name="+document.frmjournal.contact_name.value; 
	window.open(strUrl,"contact","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
}

/**
 * this function occur when user change account list combobox
 */
<%//if(iCommand!=Command.LIST || iCommand!=Command.SUBMIT){%>
function cmdChangeAccount(){
  var selVal = Math.abs(parent.frames[1].document.frmjournaldetail.ID_PERKIRAAN.value);
  var debitValDefault = parent.frames[1].document.frmjournaldetail.DEBET.defaultValue;
  var creditValDefault = parent.frames[1].document.frmjournaldetail.KREDIT.defaultValue;
  var exist = 0;
  var jdAccount = 0;
  var jdIndex = -1;    
  
  // Get index of details if alreday exist in details list 
  <%//for(int i=0;i<listAcc.size();i++){
     //JurnalDetail jdAcc = (JurnalDetail) listAcc.get(i); %>
	 //if(selVal==<%//=jdAcc.getIdPerkiraan()%>){
	 //	 exist = 1;
	//	 jdId = "<%//=jdAcc.getOID()%>";		
	//	 jdAccount = "<%//=jdAcc.getIdPerkiraan()%>";				 		 
	//	 jdIndex = "<%//=jdAcc.getIndex()%>";		
	 //}  
  <%//}%>
  
  // If account already exist in the details list, di javascript:cmdEdit(index) 
  //if(exist==1){ //===> jika tdk diperbolehkan account yg sama dalam satu jurnal, maka aktifkan 'if' ini beserta 'else' nya
    //cmdEdit(jdIndex);
	//cmdClickAccountJd(jdId,jdAccount,jdIndex);
  
  // If account not available in details list 
  //}else{
	  switch(selVal){  
	 <%for(int i=0;i<listAllCode.size();i++){
		 Perkiraan p = (Perkiraan)listAllCode.get(i);
		 long oid = p.getOID(); %>
		   case <%=oid%> : <%if(p.getPostable()){%>
	   							<%//if((p.getBukuPembantu()==PstPerkiraan.SUB_LEDGER_RECEIVABLE) || (p.getBukuPembantu()==PstPerkiraan.SUB_LEDGER_LIABILITY)){%>
									<%//if(jUmum.getClientId()!=0){%>		   
									  //parent.frames[1].document.frmjournaldetail.DEBET.value = debitValDefault;
									  //parent.frames[1].document.frmjournaldetail.KREDIT.value = creditValDefault;																	
									  //parent.frames[1].document.frmjournaldetail.DEBET.disabled = false;
									  //parent.frames[1].document.frmjournaldetail.KREDIT.disabled = false;
									  //parent.frames[1].document.frmjournaldetail.bpNumber.value="<%=p.getBukuPembantu()%>";				
								 	  //parent.frames[1].document.all.msgPostable.innerHTML = "";			
									<%//}else{%>
									  //parent.frames[1].document.frmjournaldetail.DEBET.value = "0";
									  //parent.frames[1].document.frmjournaldetail.KREDIT.value = "0";
									  //parent.frames[1].document.frmjournaldetail.DEBET.disabled = true;
									  //parent.frames[1].document.frmjournaldetail.KREDIT.disabled = true;
									  //parent.frames[1].document.frmjournaldetail.bpNumber.value=0;			
									  //parent.frames[1].document.all.msgPostable.innerHTML = "<i>cannot process, journal's contact name empty ...</i>";										
									<%//}%>
								<%//}else{%>
								  parent.frames[1].document.frmjournaldetail.DEBET.value = debitValDefault;
								  parent.frames[1].document.frmjournaldetail.KREDIT.value = creditValDefault;								
								  parent.frames[1].document.frmjournaldetail.DEBET.disabled = false;
								  parent.frames[1].document.frmjournaldetail.KREDIT.disabled = false;
								  parent.frames[1].document.frmjournaldetail.bpNumber.value="<%=p.getBukuPembantu()%>";				
								  if(parent.frames[1].document.all.msgPostable!=null){
									  parent.frames[1].document.all.msgPostable.innerHTML = "";	
								  }
								<%//}%>
							<%}else{%>
								parent.frames[1].document.frmjournaldetail.DEBET.value = "0";
								parent.frames[1].document.frmjournaldetail.KREDIT.value = "0";
								parent.frames[1].document.frmjournaldetail.DEBET.disabled = true;
								parent.frames[1].document.frmjournaldetail.KREDIT.disabled = true;
								parent.frames[1].document.frmjournaldetail.bpNumber.value=0;			
							    if(parent.frames[1].document.all.msgPostable!=null){
									parent.frames[1].document.all.msgPostable.innerHTML = "<i>cannot process, this account is header / non postable ...</i>";
							    }								
				 		    <%}%>  				  
							break;
	 <%}%>
		  default :	break;
	  }
    //}
}
<%//}%>


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
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
      <%@ include file = "../main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> 
            &gt; <%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmjournal" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">			  
              <input type="hidden" name="journal_id" value="<%=journalID%>">
              <input type="hidden" name="list_command" value="<%=Command.LIST%>">
              <input type="hidden" name="index" value="<%=index%>">
              <input type="hidden" name="add_type" value="<%=addType%>">			  			
              <input type="hidden" name="detail_id" value="<%=detailID%>">	  			  			  
              <input type="hidden" name="perkiraan" value="<%=idAccount%>">
			  <input type="hidden" name="bpNumber" value="<%=bpNumber%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">			  			  			  			  			    
              <input type="hidden" name="is_valid_delete" value="<%=isValidDelete%>"> 
	          <input type="hidden" name="account_group" value="<%=accountGroup%>">			  			  			  		  			  			  			  
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td valign="top" height="372"> 
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr> 
                        <td width="100%"> 
                          <hr>
                        </td>
                      </tr>
                      <tr> 
                        <td width="100%" class="tabtitleactive" valign="top"> 
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
                            <tr> 
                              <td width="3%" class="listgensell" valign="top" height="25">&nbsp;</td>
                              <td width="94%" class="listgensell" valign="top" height="25">&nbsp;</td>
                              <td width="3%" class="listgensell" valign="top" height="25">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="3%"></td>
                              <td width="94%"> 
                                <table width="100%">
                                  <tr> 
                                    <td width="11%" height="25"><%=strTitle[SESS_LANGUAGE][12]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25">
									<input type="hidden" name="<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_MATAUANG]%>" value="<%="" + accountingBookType%>" size="35">									
									<%=PstJurnalUmum.getCurrencyValue(accountingBookType)%>
									</td>
                                    <td width="13%" height="25"><%=strTitle[SESS_LANGUAGE][3]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">                                       
                                      <% 
									   Vector currencytypeid_value = new Vector(1, 1);
									   Vector currencytypeid_key = new Vector(1, 1);
									  
									   String sel_currencytypeid = ""+jUmum.getCurrType();								   
									   if(listCurrencyType!=null&&listCurrencyType.size()>0)
									   {
											for(int i=0;i<listCurrencyType.size();i++)
											{
												CurrencyType currencyType =(CurrencyType)listCurrencyType.get(i);
												currencytypeid_value.add(currencyType.getName()+"("+currencyType.getCode()+")");												
												currencytypeid_key.add(""+currencyType.getOID());
											}
									   }
									  %>
                                      <%= ControlCombo.draw(frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_CURR_TYPE],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value, "", "") %> </td>
                                  </tr>
                                  <tr> 
                                    <td width="11%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25"> 
                                      <%
									String strVoucherNumber = "-";
									if(jUmum.getVoucherNo()!=null && jUmum.getVoucherNo().length()>0)
									{ 
										strVoucherNumber = jUmum.getVoucherNo()+"-"+SessJurnalUmum.intToStr(jUmum.getVoucherCounter(),4);
									}
									out.println(strVoucherNumber);
									%>
                                    </td>
                                    <td width="13%" height="25"><%=strTitle[SESS_LANGUAGE][1]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"> 
                                     <%
                                       if (jUmum.getTglTransaksi() == null) {
                                           jUmum.setTglTransaksi(new Date());
                                       }
                                     %>
                                     
                                     <%out.println(ControlDate.drawDate(frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI], jUmum.getTglTransaksi(), 0, interval));%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="11%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25"> 
                                      <%
									   String strDt = "";
                                                                           DateFormat fmt = DateFormat.getDateInstance(DateFormat.LONG, Locale.US);
                                                                           try{
									   if(iCommand==Command.EDIT || iCommand==Command.NONE) {
                                                                               
                                                                               if (jUmum.getTglEntry() == null)
                                                                                   jUmum.setTglEntry(new Date());
										//	strDt = Formater.formatDate(jUmum.getTglEntry(),"MMMM dd,  yyyy"); */
                                                                               strDt = fmt.format(jUmum.getTglEntry());
									   } else					
                                                                                strDt = fmt.format(new Date());
											//strDt = Formater.formatDate(new Date(),"MMMM dd,  yyyy");
									   }catch(Exception exc){
                                                                               System.out.println(".:: shared_income_trans.jsp : " + exc.toString());
									   }	
                                                                           
                                                                           
                                                                           
                                                                           
									   out.println(strDt);
                                                                           
									  %>
                                    </td>
                                    <td width="13%" height="25"><%=strTitle[SESS_LANGUAGE][5]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"> 
                                      <%
									long conJurlId = jUmum.getClientId();
									String strCntName = "";
									try{
										PstContactList pstCntList = new PstContactList();
										ContactList cntList = pstCntList.fetchExc(conJurlId);
										strCntName = cntList.getCompName();
										if(strCntName.length()==0){
											strCntName = cntList.getPersonName()+" "+cntList.getPersonLastname();			
										}
									}catch(Exception e){
										System.out.println("Error on create contact : "+e.toString());
									}
									%>
                                      <input type="hidden" name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_CLIENTID]%>" value="<%=conJurlId%>">
                                      <input type="text" name="contact_name" value="<%=strCntName%>" size="35">
                                      <a href="javascript:cmdSearchContact()"><%=strSearch%></a> </td>
                                  </tr>
                                  <tr> 
                                    <td width="11%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][6]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25"> 
                                      <%
									String whereUser = "";									
									if(iCommand == Command.EDIT){
										whereUser = PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = "+ jurnalumum.getUserId();									
										try{
											Vector vectUser = PstAppUser.listPartObj(0,0,whereUser,"");
											if(vectUser.size()>0 && vectUser != null){
												AppUser aUser = (AppUser)vectUser.get(0);
												userName = aUser.getLoginId();
											}
										}catch(Exception exc){	}										
									}											
									if(iCommand == Command.NONE){
										whereUser = PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = "+ jUmum.getUserId();									
										try{
											Vector vectUser = PstAppUser.listPartObj(0,0,whereUser,"");
											if(vectUser.size()>0 && vectUser != null){
												AppUser aUser = (AppUser)vectUser.get(0);
												userName = aUser.getLoginId();
											}
										}catch(Exception exc){	}										
									}
									out.println(userName);																				
									%>
                                    </td>
                                    <td width="13%" height="25"><%=strTitle[SESS_LANGUAGE][4]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td rowspan="2" height="52"> 
                                      <textarea name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_KETERANGAN] %>" cols="30" rows="3"><%=jUmum.getKeterangan()%></textarea>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="25" valign="bottom">&nbsp;<i><u><%=strTitle[SESS_LANGUAGE][11]%></u></i></td>
                                    <td height="25" width="3%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="6"> 
                                      <%
									out.println(listJurnalDetail(SESS_LANGUAGE,frmjurnaldetail,listjurnaldetail,listCode,listCurrencyType));
									if(amountDt>0 || amountCr>0){
									out.println(drawListTotal(frmjurnaldetail,msgBalance,amountDt,amountCr));
									}
									%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="6"> 
                                      <%if(iCommand==Command.ASK){%>
                                      <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                        <tr> 
                                          <td class="msgquestion"> 
                                            <div align="center"><%=isValidDelete==INT_VALID_DELETE? "Are you sure to delete journal main ?" : msgErr%></div>
                                          </td>
                                        </tr>
                                      </table>
                                      <%}%>
                                    </td>
                                  </tr>
                                  <%if(ctrlErr!=ctrlJurnalUmum.RSLT_OK){%>
                                  <tr> 
                                    <td colspan="6" class="msgErrComment">&nbsp;<%=ctrlJurnalUmum.getMessage()%></td>
                                  </tr>
                                  <%}%>
                                  <tr> 
                                    <td colspan="6" class="command">&nbsp; 
                                      <%if((!periodClosed) && (privView) && (privAdd) && (privSubmit)){%>
                                      <%if((balance && boolDetail && iCommand==Command.NONE) || (iCommand==Command.EDIT)){%>
                                      <a href="javascript:addNewDetail()"><%=strAddDetail%></a> | <a href="javascript:cmdSave()"><%=strPosted%></a> | 
                                      <%if(journalID!=0){%>
                                      <a href="javascript:cmdAsk()"><%=strDelete%></a> | 
                                      <%}%>
                                      <a href="javascript:cmdBack()"><%=strBack%></a> 
                                      <%}else{%>
                                      <%if(iCommand==Command.ADD || ctrlErr!=0 || iCommand==Command.NONE){%>
                                      <%if(boolDetail){%>
                                      <a href="javascript:addNewDetail()"><%=strAddDetail%></a> | 
                                      <%}else{%>
                                      <a href="javascript:cmdAddDetail()"><%=strAddDetail%></a> | 
                                      <%}%>
                                      <a href="javascript:cmdBack()"><%=strBack%></a> 
                                      <%}%>
                                      <%if((iCommand==Command.SAVE && ctrlErr==0) || iCommand==Command.LIST){%>
                                      <a href="javascript:addNew()"><%=strAdd%></a> | <a href="javascript:cmdBack()"><%=strBack%></a> 
                                      <%}%>
                                      <%if(iCommand==Command.ASK){%>
                                      &nbsp;<%=isValidDelete==INT_VALID_DELETE? "<a href=\"javascript:cmdDelete('"+journalID+"')\">"+strYesDelete+"</a> | " : ""%> <a href="javascript:cmdCancel()"><%=strCancel%></a> 
                                      <%}%>
                                      <%}%>
                                      <%}else{%>
                                      <a href="javascript:cmdBack()"><%=strBack%></a> 
                                      <%}%>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                              <td width="3%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="3%" height="25"></td>
                              <td width="94%" height="25">&nbsp;</td>
                              <td width="3%" height="25">&nbsp;</td>
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
