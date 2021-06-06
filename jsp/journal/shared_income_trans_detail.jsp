<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.util.*" %>
<!--import qdep-->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.db.*" %>
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
<%@ page import="com.dimata.aiso.session.journal.*" %>
<%@ page import="com.dimata.aiso.session.system.*" %>
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
public static final int INT_VALID_DELETE = 0;
public static final int INT_INVALID_DELETE = 1;
String formatNumber = "#,###.00";

public static String strTitle[][] = {
	{
	"No Voucher","Tanggal Transaksi","Tanggal Input","Transaksi Dalam","Keterangan Jurnal","Nama Kontak",
	"Nama Operator","Kelompok Perkiraan","Nama Perkiraan","Debet","Kredit","Daftar Jurnal Detail","Tipe Pembukuan",
	"Mata Uang Lain", "Nilai Transaksi Asli", "Kurs Standar", "Nilai Buku",
	"Klik tombol <u>Mata Uang Lain</u> jika transaksi dilakukan dengan mata uang yang berbeda dengan tipe pembukuan ..."
	},	
	
	{
	"Voucher No","Transaction Date","Entry Date","Transaction In","Journal Description","Contact Name",
	"Operator Name","Account Group","Account Name","Debit","Credit","List Detail's Journal","Book Type",
	"Other Currency","Original Transaction Amount", "Standart Rate", "Book Type Amount",
	"Click <u>Other Currency</u> if original transaction's currency different to book type used ..."	
	}
};

public static final String masterTitle[] = {
	"Jurnal Umum","General Journal"	
};

public static final String listTitle[] = {
	"Proses Jurnal","Journal Process"	
};


/**
* this method used to list jurnal detail
*/
public String listJurnalDetail(int iCommand, int language, int index, FrmJurnalDetail frmjurnaldetail, Vector listjurnaldetail, Vector listAccGroup, Vector listCode, Vector listCurrencyType, long lSelectedBookTypeUsed)
{
	String sResult = "";
	String sListOpening = "<table width=\"100%\" border=\"0\" class=\"listgen\" cellspacing=\"1\">";
	sListOpening = sListOpening + "<tr><td width=\"15%\" class=\"listgentitle\"><div align=\"left\">"+strTitle[language][7]+"</div></td>";
	sListOpening = sListOpening + "<td width=\"65%\" class=\"listgentitle\"><div align=\"left\">"+strTitle[language][8]+"</div></td>";		
	sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"right\">"+strTitle[language][9]+"</div></td>";		
	sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"right\">"+strTitle[language][10]+"</div></td></tr>";						
	
	String sListClosing = "</table>";
	String sListContent = "";
	
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
	
	Vector vectVal = new Vector(1,1);
	Vector vectKey = new Vector(1,1);
	if(listAccGroup!=null && listAccGroup.size()>0){
		for(int i=0; i<listAccGroup.size(); i++){
			Vector tempResult = (Vector)listAccGroup.get(i);
			vectVal.add(tempResult.get(0));
			vectKey.add(tempResult.get(1));		
		}
	}																											
	
	Hashtable hashCurrency = new Hashtable();
	Vector currencytypeid_value = new Vector(1,1);
	Vector currencytypeid_key = new Vector(1,1);	
	if(listCurrencyType!=null && listCurrencyType.size()>0)
	{
		int maxCurr = listCurrencyType.size();
		for(int it=0; it<maxCurr; it++)
		{
			CurrencyType currencyType =(CurrencyType)listCurrencyType.get(it);
			currencytypeid_value.add(currencyType.getName()+"("+currencyType.getCode()+")");												
			currencytypeid_key.add(""+currencyType.getOID());			
			hashCurrency.put(""+currencyType.getOID(),currencyType.getCode());	
		}
	}

	String attr = "onChange=\"parent.frames[0].cmdChangeAccount()\"";
	String attrChange = "onChange=\"parent.frames[0].cmdChange()\""; 	
	String strSelect = "";			
	
	if(listjurnaldetail!=null && listjurnaldetail.size()>0)
	{				
		
		// --- start proses content ---				
		for(int it = 0; it<listjurnaldetail.size();it++)
		{																								
			 JurnalDetail jdetail = (JurnalDetail)listjurnaldetail.get(it);
			 
			 // if jd.datastatus!=DELETE ---> don't display it, otherwise ---> display it
			 if(jdetail.getDataStatus() != PstJurnalDetail.DATASTATUS_DELETE)
			 {		 	 
				 Vector listAccount = SessPerkiraan.findFieldPerkiraan(jdetail.getIdPerkiraan());
				 String namaAcc = "";
				 int groupPerkiraan = 1;
				 boolean postableAcc = false;			 
				 if(listAccount!=null && listAccount.size()>0)
				 {
					Perkiraan account = (Perkiraan)listAccount.get(0);
					namaAcc = account.getNama();
					postableAcc = account.getPostable(); 
					groupPerkiraan = Integer.parseInt(account.getNoPerkiraan().substring(0,1));																									 													 													 
				 }													 
				 strSelect = ""+ jdetail.getIdPerkiraan();
				
				 if(index!=jdetail.getIndex() || iCommand==Command.LIST || iCommand==Command.SUBMIT || iCommand==Command.DELETE)
				 {			 
				 	sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\">"+ PstPerkiraan.estimationNames[language][groupPerkiraan]  +"</div></td>";
				 	sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ "<a href=\"javascript:parent.frames[0].cmdClickAccountJd('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">"+namaAcc+"</a>" +"</div></td>";
				 	sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(jdetail.getDebet()) +"</div></td>";
				 	sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(jdetail.getKredit()) +"</div></td></tr>";															
				 }
				 else
				 {
					String disableStatus = "";
					if(!postableAcc)
					{ 
						disableStatus = "disabled=\"true\""; 
					}								
					
					if(lSelectedBookTypeUsed != jdetail.getCurrType())
					{
						disableStatus = "style=\"background-color:#E8E8E8;\" readonly"; 
					}
					
				 	sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ ControlCombo.draw("ACCOUNT_GROUP",null,""+groupPerkiraan,vectVal,vectKey,attrChange) +"</div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ ControlCombo.draw(frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_IDPERKIRAAN],null,strSelect,accCodeKey,accCodeVal,attr) +"</div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_TYPE]+"\" value=\""+jdetail.getCurrType()+"\"><input type=\"text\" name=\"DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(jdetail.getDebet()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebet()\"" + disableStatus + ">"+"</div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_AMOUNT]+"\" value=\""+jdetail.getCurrAmount()+"\"><input type=\"text\" name=\"KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(jdetail.getKredit()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeKredit()\"" + disableStatus + ">"+"</div></td></tr>";															
					
					double dAmountTransaction = (jdetail.getDebet() > 0 ? jdetail.getDebet() : jdetail.getKredit());
					double dAmountInOriginalCurr = dAmountTransaction / jdetail.getCurrAmount(); 		

				 	sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"2\">&nbsp;>>> " + strTitle[language][14] + " : " + hashCurrency.get(""+jdetail.getCurrType()) + "&nbsp;" + frmjurnaldetail.userFormatStringDecimal(dAmountInOriginalCurr) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][15] + " : " + frmjurnaldetail.userFormatStringDecimal(jdetail.getCurrAmount()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][16] + " : " + hashCurrency.get(""+lSelectedBookTypeUsed) + " " + frmjurnaldetail.userFormatStringDecimal(dAmountTransaction) + "</td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrency('" + jdetail.getCurrType() + "','" + jdetail.getCurrAmount() + "','" + jdetail.getDebet() + "','" + jdetail.getKredit() + "')\"><b>"+strTitle[language][13]+"</b></a>" +"</td></tr>";					
				 }
			 }		 
		 }
		 
	
		 if(iCommand==Command.ADD)
		 {
			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ ControlCombo.draw("ACCOUNT_GROUP",null,null,vectVal,vectKey,attrChange) +"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ ControlCombo.draw(frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_IDPERKIRAAN],"-","",accCodeKey,accCodeVal,attr) +"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_TYPE]+"\" value=\"" + lSelectedBookTypeUsed + "\"><input type=\"text\" name=\"DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(0)+" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebet()\" disabled=\"true\">" +"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_AMOUNT]+"\" value=\"1\"><input type=\"text\" name=\"KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(0)+" class=\"txtalign\" onBlur=\"javascript:cmdChangeKredit()\"disabled=\"true\">" +"</div></td></tr>";															
			
			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"2\">&nbsp;" + strTitle[language][17] + "</td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrency('0','0','0','0')\"><b>" + strTitle[language][13] + "</b></a>" +"</td></tr>";					
		 }	 		
		 // --- finish proses content ---						 
	}
	
	
	else
	{
		 if(iCommand==Command.ADD)
		 {
			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ ControlCombo.draw("ACCOUNT_GROUP",null,null,vectVal,vectKey,attrChange) +"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ ControlCombo.draw(frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_IDPERKIRAAN],"-","",accCodeKey,accCodeVal,attr) +"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_TYPE]+"\" value=\"" + lSelectedBookTypeUsed + "\"><input type=\"text\" name=\"DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(0)+" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebet()\" disabled=\"true\">" +"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_AMOUNT]+"\" value=\"1\"><input type=\"text\" name=\"KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(0)+" class=\"txtalign\" onBlur=\"javascript:cmdChangeKredit()\"disabled=\"true\">" +"</div></td></tr>";															

			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"2\">&nbsp;" + strTitle[language][17] + "</td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrency('0','0','0','0')\"><b>" + strTitle[language][13] + "</b></a>" +"</td></tr>";					
		 }	 			
	}	
	
	sResult = sListOpening + sListContent + sListClosing;
	return sResult;		
}

public String drawListTotal(FrmJurnalDetail frmjurnaldetail, String strMessage, double debet, double kredit){
	String result = "<table width=\"100%\"><tr><td>"+
						"<table width=\"100%\" border=\"0\" cellspacing=\"1\">"+
							"<tr>"+
								"<td width=\"80%\" class=\"msgbalance\">"+
									"<div align=\"left\" ID=msgPostable><i>"+strMessage+"</i></div>"+
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
/** Get value from hidden form */
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE JOURNAL PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES JURNAL SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long journalID = FRMQueryString.requestLong(request,"journal_id");
long detailID = FRMQueryString.requestLong(request,"detail_id");
int index = FRMQueryString.requestInt(request,"index");
long idAccount = FRMQueryString.requestLong(request,"perkiraan");
int accountGroup = FRMQueryString.requestInt(request,"account_group");
if(accountGroup==0){ accountGroup=1; }
int bpNumber = FRMQueryString.requestInt(request,"bpNumber");
int isValidDelete = FRMQueryString.requestInt(request,"is_valid_delete");
String msgBalance = "";

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : "Tambah Baru Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Journal List" : "Kembali Ke Daftar Jurnal";
String strPosted = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Posted Journal" : "Posted Jurnal";
String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Detail" : "Simpan Detail";
String strUpdate = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Update Detail" : "Ubah Detail";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Detail" : "Hapus Detail";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Detail" : "Ya Hapus Detail";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strSubledger = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Subledger" : "Buku Pembantu";

/** Get data from session */
JurnalUmum jUmum = (JurnalUmum)session.getValue(SessJurnalUmum.SESS_JURNAL_MAIN);

boolean periodClosed = SessPeriode.isPeriodClosed(jUmum.getPeriodeId());


// get book type oid
long lSelectedBookTypeUsed = Long.parseLong(PstSystemProperty.getValueByName("BOOK_TYPE_IDR")); 
if( accountingBookType == com.dimata.aiso.entity.jurnal.PstJurnalUmum.CURRENCY_DOLLAR)
{
	lSelectedBookTypeUsed = Long.parseLong(PstSystemProperty.getValueByName("BOOK_TYPE_USD")); 	
}

// get masterdata currency
String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);


/** Instansiasi CtrlJurnalDetail and FrmJurnalDetail */
CtrlJurnalUmum ctrlJurnalUmum = new CtrlJurnalUmum(request);
ctrlJurnalUmum.setLanguage(SESS_LANGUAGE);
FrmJurnalUmum frmJurnalUmum = ctrlJurnalUmum.getForm();
CtrlJurnalDetail ctrljurnaldetail = new CtrlJurnalDetail(request) ; 

FrmJurnalDetail frmjurnaldetail = ctrljurnaldetail.getForm();
frmjurnaldetail.setDecimalSeparator(sUserDecimalSymbol); 
frmjurnaldetail.setDigitSeparator(sUserDigitGroup);

int ctrlErr = ctrljurnaldetail.action(iCommand);
JurnalDetail jurnaldetail = ctrljurnaldetail.getJurnalDetail();

/** if Command.EDIT, check status 'isValidUpdate' */
boolean isValidUpdate = true;
if(iCommand==Command.EDIT){
	JurnalDetail currJurDetail = jUmum.getJurnalDetail(index);
	if(!(jUmum.isEmptyBpAktivaTetap(currJurDetail)&&jUmum.isEmptyBpAktivaLain(currJurDetail)&&
	   jUmum.isEmptyBpPiutang(currJurDetail)&&jUmum.isEmptyBpUtang(currJurDetail))){	   		
	   if(!jUmum.isEmptyBpAktivaTetap(currJurDetail)){
		   for(int j=0; j<currJurDetail.getBpAktivaTetap().size(); j++){	   		
			   BpAktivaTetap subAktivaTetap = currJurDetail.getBpAktivaTetap(j);	   
			   SessBpPiutang sessBpPiutang = new SessBpPiutang();	
			   if(!sessBpPiutang.isValidDelete(subAktivaTetap.getOID(),bpNumber,PstBpAktivaTetap.TBL_BP_AKTIVA_TETAP)){
				   isValidUpdate = false;   
				   break;
			   }   
		   }					   	   
	   }	   
	   if(!jUmum.isEmptyBpAktivaLain(currJurDetail)){
		   for(int j=0; j<currJurDetail.getBpAktivaLain().size(); j++){	   			   
			   BpAktivaLain subAktivaLain = currJurDetail.getBpAktivaLain(j);	   
			   SessBpPiutang sessBpPiutang = new SessBpPiutang();	
			   if(!sessBpPiutang.isValidDelete(subAktivaLain.getOID(),bpNumber,PstBpAktivaLain.TBL_BP_AKTIVA_LAIN)){
				   isValidUpdate = false;
				   break;
			   }   
		   }					   	   
	   }	   
	   if(!jUmum.isEmptyBpPiutang(currJurDetail)){
		   for(int j=0; j<currJurDetail.getBpPiutang().size(); j++){	   			   
			   BpPiutang subPiutang = currJurDetail.getBpPiutang(j);	   
			   SessBpPiutang sessBpPiutang = new SessBpPiutang();	
			   if(!sessBpPiutang.isValidDelete(subPiutang.getOID(),bpNumber,PstBpPiutang.TBL_BP_PIUTANG)){
				   isValidUpdate = false;
				   break;
			   }	   
		   }					   	   
	   }	   
	   if(!jUmum.isEmptyBpUtang(currJurDetail)){
		   for(int j=0; j<currJurDetail.getBpUtang().size(); j++){	   			   
			   BpUtang subUtang = currJurDetail.getBpUtang(j);	   
			   SessBpPiutang sessBpPiutang = new SessBpPiutang();	
			   if(!sessBpPiutang.isValidDelete(subUtang.getOID(),bpNumber,PstBpUtang.TBL_BP_UTANG)){
				   isValidUpdate = false;
				   break;
			   }	   
		   }					   	   
	   }	   	   
	}		
}

/** if Command.SUBMIT, process adding or updating jurnal details in object jUmum */
if(iCommand==Command.SUBMIT){
	try{
		if(jUmum.getJurnalDetails().isEmpty()){
			System.out.println(" <--------------------< JDETAIL ADD EMPTY >---------------------> ");
			jurnaldetail.setIndex(0);
			jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);
			jUmum.addDetails(jurnaldetail.getIndex(),jurnaldetail);		
		}else{
			if(prevCommand==Command.ADD){
				System.out.println(" <--------------------< JDETAIL ADD NOT EMPTY >---------------------> ");
				jurnaldetail.setIndex(jUmum.getJurnalDetails().size());						
				jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);				
				jUmum.addDetails(jurnaldetail.getIndex(),jurnaldetail);			
			}
			if(prevCommand==Command.EDIT){
				System.out.println(" <--------------------< JDETAIL EDIT >---------------------> ");
				JurnalDetail prevJD = jUmum.getJurnalDetail(index);	
				Vector vectBpFixedAsset = prevJD.getBpAktivaTetap();								
				Vector vectBpOtherAsset = prevJD.getBpAktivaLain();								
				Vector vectBpReceivable = prevJD.getBpPiutang();								
				Vector vectBpPayable = prevJD.getBpUtang();								
																
				jurnaldetail.setOID(detailID);
				jurnaldetail.setJurnalIndex(journalID);
				jurnaldetail.setIndex(index);		
				if(detailID==0){		
					jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);
				}else{
					jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_UPDATE);
				}					
				if(vectBpFixedAsset!=null && vectBpFixedAsset.size()>0){ jurnaldetail.setBpAktivaTetap(vectBpFixedAsset); }
				if(vectBpOtherAsset!=null && vectBpOtherAsset.size()>0){ jurnaldetail.setBpAktivaLain(vectBpOtherAsset); }
				if(vectBpReceivable!=null && vectBpReceivable.size()>0){ jurnaldetail.setBpPiutang(vectBpReceivable); }
				if(vectBpPayable!=null && vectBpPayable.size()>0){ jurnaldetail.setBpUtang(vectBpPayable); }
																
				jUmum.updateDetails(index,jurnaldetail);
			}		
		}	
	}catch(Exception e){
		System.out.println("On Submit Exception : "+e.toString());
	}	
	
	switch(bpNumber){
	  case PstPerkiraan.SUB_LEDGER_FIXED_ASSET  : 
			%>
			<jsp:forward page="sl_fixedasset.jsp"> 
			<jsp:param name="command" value="<%=Command.LIST%>"/>
			<jsp:param name="bpNumber" value="<%=bpNumber%>"/>
			<jsp:param name="index" value="<%=jurnaldetail.getIndex()%>"/>			
			</jsp:forward>
			<%	 
			break;			
	  case PstPerkiraan.SUB_LEDGER_OTHER_ASSET  :  	
			%>
			<jsp:forward page="sl_otherasset.jsp"> 
			<jsp:param name="command" value="<%=Command.LIST%>"/>
			<jsp:param name="bpNumber" value="<%=bpNumber%>"/>
			<jsp:param name="index" value="<%=jurnaldetail.getIndex()%>"/>						
			</jsp:forward>
			<%		
			break;			
	  case PstPerkiraan.SUB_LEDGER_RECEIVABLE  :  	
			%>
			<jsp:forward page="sl_receivable.jsp"> 
			<jsp:param name="command" value="<%=Command.LIST%>"/>
			<jsp:param name="bpNumber" value="<%=bpNumber%>"/>
			<jsp:param name="index" value="<%=jurnaldetail.getIndex()%>"/>						
			</jsp:forward>
			<%		
			break;			
	  case PstPerkiraan.SUB_LEDGER_LIABILITY  :  				 			 
			%>
			<jsp:forward page="sl_liability.jsp"> 
			<jsp:param name="command" value="<%=Command.LIST%>"/>
			<jsp:param name="bpNumber" value="<%=bpNumber%>"/>
			<jsp:param name="index" value="<%=jurnaldetail.getIndex()%>"/>						
			</jsp:forward>
			<%		
			break;			
	  default  :  				 			 
			break;						
	 }	 
}

/** if Command.ASK, check detail's availability */
String msgAvailability = "";
if(iCommand==Command.ASK){
	JurnalDetail currJurDetail = jUmum.getJurnalDetail(index);
	if(!(jUmum.isEmptyBpAktivaTetap(currJurDetail)&&jUmum.isEmptyBpAktivaLain(currJurDetail)&&
	   jUmum.isEmptyBpPiutang(currJurDetail)&&jUmum.isEmptyBpUtang(currJurDetail))){	   		
	   if(!jUmum.isEmptyBpAktivaTetap(currJurDetail)){
		    isValidDelete = INT_INVALID_DELETE;
			if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			   msgAvailability = "Cannot delete journal detail, please check its fixedasset sub ledger first ...";				
			}else{
			   msgAvailability = "Tidak bisa menghapus jurnal detail, silakan cek dulu buku pembantu asset tetapnya ...";					
			}		      
	   }	   
	   if(!jUmum.isEmptyBpAktivaLain(currJurDetail)){
		    isValidDelete = INT_INVALID_DELETE;   
			if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			   msgAvailability = "Cannot delete journal detail, please check its otherasset sub ledger first ...";				
			}else{
			   msgAvailability = "Tidak bisa menghapus jurnal detail, silakan cek dulu buku pembantu asset lainnya ...";					
			}		      	   
	   }	   
	   if(!jUmum.isEmptyBpPiutang(currJurDetail)){
		    isValidDelete = INT_INVALID_DELETE;   
			if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			   msgAvailability = "Cannot delete journal detail, please check its receivable sub ledger first ...";				
			}else{
			   msgAvailability = "Tidak bisa menghapus jurnal detail, silakan cek dulu buku pembantu piutangnya ...";					
			}		      	   		   
	   }	   
	   if(!jUmum.isEmptyBpUtang(currJurDetail)){
		    isValidDelete = INT_INVALID_DELETE;   
			if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			   msgAvailability = "Cannot delete journal detail, please check its payable sub ledger first ...";				
			}else{
			   msgAvailability = "Tidak bisa menghapus jurnal detail, silakan cek dulu buku pembantu utangnya ...";					
			}		      	   		   		   
	   }	   	   
	}	
}

/** if Command.DELETE, removing jurnalDetail from jUmum in specified index 
 * this operation not remove jd from session but only set status to DATASTATUS_DELETE
 * if detail's have sub ledger, delete sub ledger permanently first from db before delete detail itself 
 */
if(iCommand==Command.DELETE){	
	jurnaldetail.setOID(detailID);
	jurnaldetail.setJurnalIndex(journalID); 
	jurnaldetail.setIndex(index);			
	jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_DELETE); 					
	jUmum.updateDetails(index,jurnaldetail);		
}

/** if Command.SAVE, posted/save journal main and its details */ 
if(iCommand==Command.SAVE){
	 CtrlJurnalUmum ctrlJU = new CtrlJurnalUmum(request);	 	                                                                                                                                                                                                                                                                                           
	 ctrlJU.JournalPosted(ctrlJurnalUmum.POSTED_JD, jUmum.getOID(),jUmum);	
	 %>
	 <jsp:forward page="__jlist.jsp"> 
	 <jsp:param name="command" value="<%=Command.BACK%>"/>
	 </jsp:forward>
	 <%	 	 	 
}

/** check if jurnal details already balance or not */
double amountDt = 0;
double amountCr = 0;

boolean balance = false;
Vector vectListJd = jUmum.getJurnalDetails();
amountDt = SessJurnalUmum.getBalanceSide(vectListJd,SessJurnalUmum.SIDE_DEBET);
amountCr = SessJurnalUmum.getBalanceSide(vectListJd,SessJurnalUmum.SIDE_CREDIT);

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
			msgBalance = "journal detail haven't balance yet ..."; 
		}else{
			msgBalance = "jurnal detail belum seimbang ..."; 
		}
	}
}

/** Create vector as object handle for transaction below */
Vector listjurnaldetail = jUmum.getJurnalDetails();
Vector listAllCode = AppValue.getAppValueVector(AppValue.ACCOUNT_CHART);
Vector listCode = AppValue.getAppValueVector(accountGroup);
Vector listAcc = jUmum.getJurnalDetails();

// check if jd item's status clear or not
boolean isStatusClear = ctrljurnaldetail.isDetailItemClear(listjurnaldetail);

// elemen for account group and its item's name
Vector listAccount = new Vector(1,1);																													
Vector listAccGroup = AppValue.getVectorAccGroup(SESS_LANGUAGE);
Vector vectVal = new Vector(1,1);
Vector vectKey = new Vector(1,1);
if(listAccGroup!=null && listAccGroup.size()>0){
	for(int i=0; i<listAccGroup.size(); i++){
		Vector tempResult = (Vector)listAccGroup.get(i);
		vectVal.add(tempResult.get(0));
		vectKey.add(tempResult.get(1));		
	}
}																										
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function editForOtherCurrency(currtypeused, currrateused, ddebetamount, dcreditamount)
{
	var strUrl = "jdetail_othercurr.jsp?" +
				 "curr_type_used="+currtypeused +
				 "&curr_rate_used="+currrateused +
				 "&debet_amount="+ddebetamount +
				 "&credit_amount="+dcreditamount;				  	
	window.open(strUrl,"journal","height=190,width=500,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
}

function addNew(){
	document.frmjournaldetail.perkiraan.value=0;
	document.frmjournaldetail.index.value=-1;
	document.frmjournaldetail.command.value="<%=Command.ADD%>";
	document.frmjournaldetail.prev_command.value="<%=Command.ADD%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdSave(){
	document.frmjournaldetail.command.value="<%=Command.SAVE%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdCancel(){
	document.frmjournaldetail.perkiraan.value=0;
	document.frmjournaldetail.index.value=-1;
	document.frmjournaldetail.is_valid_delete.value="<%=INT_VALID_DELETE%>";		
	document.frmjournaldetail.command.value="<%=Command.NONE%>";	
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jumum.jsp";
	document.frmjournaldetail.submit();
}

function cmdEdit(index){
	document.frmjournaldetail.index.value=index;
	document.frmjournaldetail.command.value="<%=Command.EDIT%>";
	document.frmjournaldetail.prev_command.value="<%=Command.EDIT%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();		
}

function cmdAsk(index){
	document.frmjournaldetail.index.value=index;	
	document.frmjournaldetail.command.value="<%=Command.ASK%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdDelete(index){
	document.frmjournaldetail.perkiraan.value="";	
	document.frmjournaldetail.index.value=index;		
	document.frmjournaldetail.command.value="<%=Command.DELETE%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdItemData(journalId){
	document.frmjournaldetail.command.value="<%=Command.NONE%>";
	document.frmjournaldetail.journal_id.value=journalId;
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jumum.jsp";
	document.frmjournaldetail.submit();
}

function cmdBP(){
	var bpVal = document.frmjournaldetail.bpNumber.defaultValue; // to get default value of this object (not submit)
	var subledger = "";
	switch(bpVal){
	  case "1"  : subledger = "sl_fixedasset.jsp";	break;			
	  case "2"  : subledger = "sl_otherasset.jsp";	break;			
	  case "3"  : subledger = "sl_receivable.jsp";	break;			
	  case "4"  : subledger = "sl_liability.jsp";	break;			
	 }	   	 
    document.frmjournaldetail.command.value="<%=Command.LIST%>";	
	document.frmjournaldetail.target="_self";	
	document.frmjournaldetail.action=subledger;
	document.frmjournaldetail.submit();
}


function cmdBack(){
	document.frmjournaldetail.command.value="<%=Command.BACK%>";
	document.frmjournaldetail.target="_self";	
	document.frmjournaldetail.action="jlist.jsp";
	document.frmjournaldetail.submit();
}

function cmdChangeDebet(){
	var debet = document.frmjournaldetail.DEBET.value;
	var kredit = document.frmjournaldetail.KREDIT.value;
	if(kredit>0 && debet>0){ 
	   document.frmjournaldetail.KREDIT.value = 0;
	}
}

function cmdChangeKredit(){
	var debet = document.frmjournaldetail.DEBET.value;
	var kredit = document.frmjournaldetail.KREDIT.value;
	if(kredit>0 && debet>0){
	   document.frmjournaldetail.DEBET.value = 0;
	}
}


function cmdSetPeriod(){
	var act = "<%=approot%>" + "/period/setup_period.jsp";
	document.frmjournaldetail.command.value="<%=Command.LIST%>";
	document.frmjournaldetail.action=act; 
	document.frmjournaldetail.submit();
}


function cmdAddItem(){ 
	<%if(isValidUpdate){%>
		document.frmjournaldetail.command.value="<%=Command.SUBMIT%>";
		document.frmjournaldetail.action="jdetail.jsp";
		document.frmjournaldetail.submit();
	<%
	}else{
		String mPostable = "";
		if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			mPostable = "<i>Cannot update detail because its sub ledger referenced by other one(s) ...</i>"; 
		}else{
			mPostable = "<i>Tidak bisa mengubah jurnal detail karena data buku pembantunya dipakai oleh jurnal lain ...</i>"; 
		}	
	%>
		document.all.msgPostable.innerHTML = "<%=mPostable%>";		
	<%}%>
}

function cmdSearchContact(){
	var strUrl = "detailcontactdosearch.jsp?command=<%=Command.FIRST%>"+
				 "&contact_type=-1"+	
				 "&contact_name="+document.frmjournaldetail.contact_name.value; 
	window.open(strUrl,"contact","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
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
            <form name="frmjournaldetail" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="start" value="<%=start%>">			  			  
              <input type="hidden" name="index" value="<%=index%>">		
              <input type="hidden" name="journal_id" value="<%=jUmum.getOID()%>">	  			  
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
                        <td width="100%" height="2"> 
                          <hr>
                        </td>
                      </tr>
                      <tr> 
                        <td width="100%" class="tabtitleactive"> 
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
                            <tr> 
                              <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                              <td width="94%" height="25" class="listgensell" valign="top">&nbsp;</td>
                              <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="3%" valign="top"></td>
                              <td width="94%"> 
                                <table width="100%">
                                  <tr> 
                                    <td width="11%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][12]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25"> 
                                      <input type="hidden" name="<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_MATAUANG]%>" value="<%=""+accountingBookType%>" size="35">
                                      <%=PstJurnalUmum.getCurrencyValue(accountingBookType)%> </td>
                                    <td width="13%" height="25"><%=strTitle[SESS_LANGUAGE][3]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"> 
                                      <% 
									   Vector currencytypeid_value = new Vector(1,1);
									   Vector currencytypeid_key = new Vector(1,1);
									  
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
								    Date tanggal = jUmum.getTglTransaksi();
									out.println(ControlDate.drawDate(frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI], tanggal, 0, -2));
								    %>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="11%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25"> 
                                      <%
									   String strDt = Formater.formatDate(jUmum.getTglEntry(),"MMMM dd, yyyy");
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
									whereUser = PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = "+ jUmum.getUserId();									
									try{
										Vector vectUser = PstAppUser.listPartObj(0,0,whereUser,"");
										if(vectUser.size()>0 && vectUser != null){
											AppUser aUser = (AppUser)vectUser.get(0);
											userName = aUser.getLoginId();
										}
									}catch(Exception exc){	}										
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
                                    <td colspan="3" height="25" valign="bottom">&nbsp;<i><u><%=strTitle[SESS_LANGUAGE][11]%></u></i></td>
                                    <td height="25" width="13%">&nbsp;</td>
                                    <td height="25" width="3%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="6"> 
                                      <%
									out.println(listJurnalDetail(iCommand,SESS_LANGUAGE,index,frmjurnaldetail,listjurnaldetail,listAccGroup,listCode,listCurrencyType,lSelectedBookTypeUsed));
									if(amountDt>0 || amountCr>0){
									out.println(drawListTotal(frmjurnaldetail,msgBalance,amountDt,amountCr));
									}
									%>
                                    </td>
                                  </tr>
                                  <%if(iCommand == Command.ASK){%>
                                  <tr> 
                                    <td colspan="6"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="msgquestion"> 
                                            <div align="center"><%=isValidDelete==INT_VALID_DELETE? "Are you sure to delete journal detail ?" : msgAvailability%></div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                  <tr> 
                                    <td colspan="6" class="command">&nbsp; 
                                      <%if((!periodClosed)&&(privView)&&(privAdd)&&(privSubmit)){%>
                                      <%if(iCommand!=Command.ASK){%>
                                      <%if(iCommand==Command.LIST || iCommand==Command.DELETE || iCommand==Command.SUBMIT){%>
                                      <a href="javascript:addNew()"><%=strAdd%></a> 
                                      <%if(balance && !isStatusClear){%>
                                      | <a href="javascript:cmdSave()"><%=strPosted%></a> 
                                      <%}%>
                                      | <a href="javascript:cmdBack()"><%=strBack%></a> 
                                      <%}%>
                                      <%if(iCommand==Command.EDIT){%>
                                      <a href="javascript:cmdAddItem()"><%=strUpdate%></a> | <a href="javascript:cmdAsk('<%=index%>')"><%=strDelete%></a> 
                                      <%if(bpNumber>0){%>
                                      | <a href="javascript:cmdBP()"><%=strSubledger%></a> 
                                      <%}%>
                                      | <a href="javascript:cmdCancel()"><%=strCancel%></a> 
                                      <%}%>
                                      <%if(iCommand==Command.ADD){%>
                                      <a href="javascript:cmdAddItem()"><%=strSave%></a> | <a href="javascript:cmdCancel()"><%=strCancel%></a> 
                                      <%}%>
                                      <%}else{%>
                                      <%=isValidDelete==INT_VALID_DELETE? "<a href=\"javascript:cmdDelete('"+index+"')\">"+strYesDelete+"</a> | " : ""%> <a href="javascript:cmdCancel()"><%=strCancel%></a> <%=isValidDelete==INT_INVALID_DELETE? " | <a href=\"javascript:cmdBP()\">"+strSubledger+"</a>" : ""%> 
                                      <%}%>
                                      <%}else{%>
                                      <%if(iCommand==Command.EDIT && bpNumber>0){%>
                                      <a href="javascript:cmdBP()"><%=strSubledger%></a> | 
                                      <%}%>
                                      <a href="javascript:cmdBack()"><%=strBack%></a> 
                                      <%}%>
                                    </td>
                                  </tr>
                                </table>                              								
                                
                              </td>
                              <td width="3%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="3%" valign="top" height="25"></td>
                              <td width="94%" height="25">&nbsp;</td>
                              <td width="3%" height="25">&nbsp;&nbsp;</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
			  
			  <%
			  if(iCommand==Command.ADD || iCommand==Command.EDIT)
			  {
			  %>
			  <script language="javascript"> 
			  		document.frmjournaldetail.ACCOUNT_GROUP.focus();
			  </script>
			  <%
			  }
			  %>
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