<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*,
                 com.dimata.aiso.form.arap.FrmArApItem,
                 com.dimata.aiso.form.arap.CtrlArApItem,
                 com.dimata.aiso.entity.arap.ArApItem,
                 com.dimata.aiso.form.arap.FrmArApMain,
                 com.dimata.interfaces.trantype.I_TransactionType,
                 com.dimata.aiso.entity.arap.ArApMain,
                 com.dimata.aiso.form.arap.CtrlArApMain,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.common.entity.contact.PstContactList,
                 com.dimata.aiso.entity.arap.PstArApItem,
                 com.dimata.aiso.entity.arap.PstArApMain" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.util.*" %>

<!--import qdep-->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<!--import common-->
<%@ page import="com.dimata.common.entity.payment.PstStandartRate" %>
<%@ page import="com.dimata.common.entity.payment.StandartRate,
				 com.dimata.common.entity.payment.CurrencyType,
                 com.dimata.common.entity.payment.PstCurrencyType" %>

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

<!--- For Journal Distbution --->
<%@ page import="com.dimata.aiso.entity.jurnal.JournalDistribution" %> 
<%@ page import="com.dimata.aiso.entity.jurnal.PstJournalDistribution" %> 
<%@ page import="com.dimata.aiso.session.jurnal.SessJurnal" %> 
<%@ page import="com.dimata.aiso.form.jurnal.FrmJournalDistribution" %>
<%@ page import="com.dimata.aiso.form.jurnal.CtrlJournalDistribution" %>
<%@ page import="com.dimata.aiso.session.masterdata.SessDailyRate"%>
<%@ page import="com.dimata.aiso.entity.periode.PstPeriode"%>

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


 public static String strTitle[][] =
 {
 	{
 		"Nomor Voucher",
         "Tanggal Voucher",
         "Nomor Nota",
         "Tanggal Nota",
         "Nama Kontak",
         "Mata Uang",
         "Kurs Standar",
         "Nominal",
         "Angsuran",
         "Perkiraan",
         "Perkiraan Lawan",
         "Keterangan",
         "Entry Angsuran",
         "Posting ke Jurnal",
         "Set semua angsuran",
         "Nilai Buku"
 	},
 	{
 		"Voucher Number",
         "Voucher Date",
         "Nota Number",
         "Nota Date",
         "Contact Name",
         "Currency",
         "Bookkeeping Rate",
         "Nominal",
         "Number of Payment",
         "Account",
         "Opposite Account",
         "Description",
         "Payment Term Entry",
         "Posted Journal",
         "Set all payment",
         "Book Value"
 	}
 };

public static String strTitleJDistribution[][] = {
	{
	"Input Jurnal Distribusi","Keterangan","Debet(Rp)","Kredit(Rp)","Mata Uang","Kurs(Rp)","Pusat Bisnis","Untuk","Catatan","Silahkan input debet atau kredit sesuai nilai mata uangnya. System seraca otomatis mengkonversi ke rupiah.","Daftar Journal Distribusi"
	},	
	
	{
	"Journal Distribution Entry","Remark","Debet(Rp)","Credit(Rp)","Currency","Rate(Rp)","Bussiness Center","For","Note","Please entry debit or credit amount in original currency. System will convert automatically to local currency.","List Journal Distribution"
	}
};


 public static String strItemTitle[][] = {
 	{
 	"No","Angsuran","Tanggal Jatuh Tempo","Keterangan"
 	},

 	{
 	"No","Payment Amount","Due Date","Description"
 	}
 };

 public static final String masterTitle[] = {
 	"Input Data","Data Entry"
 };

 public static final String listTitle[][] = {
     {"Piutang","Receivable"},
     {"Hutang","Payable"}
 };


/**
* this method used to list jurnal detail
*/
public String drawList(int language, int iCommand,Vector objectClass, long arApItemId, FrmArApItem frmArApItem, int iErrorCode){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
    ctrlist.dataFormat(strItemTitle[language][0],"5%","center","right"); // no
    ctrlist.dataFormat(strItemTitle[language][1],"15%","center","right"); // angsuran
    ctrlist.dataFormat(strItemTitle[language][2],"20%","center","center"); // tanggal
    ctrlist.dataFormat(strItemTitle[language][3],"60%","center","left"); // keterangan

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
	for (int i = 0; i < objectClass.size(); i++) {
		ArApItem arApItem = (ArApItem)objectClass.get(i);
        rowx = new Vector();
		if(arApItemId == arApItem.getOID())
		    index = i;

		if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
            rowx.add(""+(i+1));
            rowx.add("<input size=\"20\" type=\"text\" style=\"text-align:right\"  name=\""+FrmArApItem.fieldNames[FrmArApItem.FRM_ANGSURAN]+"\" value=\""+frmArApItem.userFormatStringDecimal(arApItem.getAngsuran())+"\">");
            String stDate = ControlDate.drawDate(FrmArApItem.fieldNames[FrmArApItem.FRM_DUE_DATE],arApItem.getDueDate(),4,-5);
            rowx.add(stDate);
            rowx.add("<input type=\"hidden\" name=\""+FrmArApItem.fieldNames[FrmArApItem.FRM_ARAP_ITEM_STATUS]+"\" value=\""+arApItem.getArApItemStatus()+"\"><input size=\"55\" type=\"text\" name=\""+FrmArApItem.fieldNames[FrmArApItem.FRM_DESCRIPTION]+"\" value=\""+arApItem.getDescription()+"\">");
		 }else{
			rowx.add(""+(i+1));
            if(arApItem.getAngsuran()==arApItem.getLeftToPay()){
                rowx.add("<a href=\"javascript:cmdEdit('"+arApItem.getOID()+"')\">"+frmArApItem.userFormatStringDecimal(arApItem.getAngsuran())+"</a>");
            }
            else{
                rowx.add(frmArApItem.userFormatStringDecimal(arApItem.getAngsuran()));
            }
            rowx.add(Formater.formatDate(arApItem.getDueDate(),"dd-MMM-yyyy"));
            rowx.add(arApItem.getDescription());
		 }
		 lstData.add(rowx);
	 }
	 if(iCommand==Command.ADD || iErrorCode != 0){
        rowx = new Vector();
        rowx.add(""+(objectClass.size()+1));
        rowx.add("<input size=\"20\" type=\"text\" style=\"text-align:right\" name=\""+FrmArApItem.fieldNames[FrmArApItem.FRM_ANGSURAN]+"\" value=\"\">");
        String stDate = ControlDate.drawDate(FrmArApItem.fieldNames[FrmArApItem.FRM_DUE_DATE],new Date(),4,-5);
        rowx.add(stDate);
        rowx.add("<input type=\"hidden\" name=\""+FrmArApItem.fieldNames[FrmArApItem.FRM_ARAP_ITEM_STATUS]+"\" value=\"0\"><input size=\"55\" type=\"text\" name=\""+FrmArApItem.fieldNames[FrmArApItem.FRM_DESCRIPTION]+"\" value=\"\">");

        lstData.add(rowx);
     }
    return ctrlist.drawMe(-1);
}

public String cekNull(String val){
	if(val==null || val.length()==0)
		val = "-";
	return val;
}

public String mergeString(String name1, String name2){
	if(name1==null || name1.length()==0){
        if(name2==null || name2.length()==0){
            return "";
        }
        else{
            return name2;
        }
    }
    else{
        if(name2==null || name2.length()==0){
            return name1;
        }
        else{
            return name1 + " / " + name2;
        }
    }
}


//------------------------------------------------- J Distribution -----------------------------------------------------

public String getAccName(int language, Perkiraan objPerkiraan)
{
	String sResult = "";
	try{
		if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			sResult = objPerkiraan.getAccountNameEnglish();
		}else{
			sResult = objPerkiraan.getNama();
		}
	}catch(Exception e){}
	return sResult;
}

public Vector drawListJDistribution(int iCommand, int language, FrmArApItem frmArApItem, Vector vJDistribution, int posted)
{
	Vector vResult = new Vector();
	String sResult = "";
	String sListOpening = "<table width=\"100%\" border=\"0\" class=\"listgen\" cellspacing=\"1\">";
	sListOpening = sListOpening + "<tr><td width=\"15%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][6]+"</div></td>";//2 Bisnis Center
	sListOpening = sListOpening + "<td width=\"15%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][4]+"</div></td>";//3 Currency
	sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][5]+"</div></td>";//4 Rate
	sListOpening = sListOpening + "<td width=\"30%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][2]+"</div></td>";//5 Debet
	sListOpening = sListOpening + "<td width=\"30%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][3]+"</div></td></tr>";//6 Credit
	

    String sListClosing = "</table>";
	String sListContent = "";
	String accName ="";
	
	double totDebet = 0.0;
	double totCredit = 0.0;
	
	JournalDistribution jDistribution = new JournalDistribution();
	if(vJDistribution!=null && vJDistribution.size()>0)	{
		// --- start proses content ---
		for(int it = 0; it<vJDistribution.size();it++){
			 jDistribution = (JournalDistribution)vJDistribution.get(it);
			 						 
			 String bisnisCenterName = "";
			 if(jDistribution.getBussCenterId() != 0)
			 {
			 	try{
			 	BussinessCenter bisnisCenter = PstBussinessCenter.fetchExc(jDistribution.getBussCenterId());
				bisnisCenterName = bisnisCenter.getBussCenterName();
				}catch(Exception e){}
			 }
			 
			 String currName = "";
			 CurrencyType currencyType = new CurrencyType();
			 if(jDistribution.getCurrencyId() != 0)
			 {
			 	try{
					currencyType = PstCurrencyType.fetchExc(jDistribution.getCurrencyId());
					currName = currencyType.getName()+"("+currencyType.getCode()+")";
				}catch(Exception e){}
			 }
			 			if(posted == 0){           
				 	 		sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"><a href=\"javascript:cmdClickBisnisCenter('"+jDistribution.getOID()+"')\">"+bisnisCenterName+"</a></div></td>";
						 }else{
						 	sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\">"+bisnisCenterName+"</div></td>";
						 }
                    	sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ currName +"</div></td>";
						sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmArApItem.userFormatStringDecimal(jDistribution.getTransRate()) +"</div></td>";
				 		sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+frmArApItem.userFormatStringDecimal(jDistribution.getDebitAmount())+"&nbsp; ("+currencyType.getCode().toUpperCase()+" = "+ frmArApItem.userFormatStringDecimal(jDistribution.getDebitAmount()/jDistribution.getTransRate()) +")</div></td>";
				 		sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+frmArApItem.userFormatStringDecimal(jDistribution.getCreditAmount())+"&nbsp; ("+currencyType.getCode().toUpperCase()+" = " +frmArApItem.userFormatStringDecimal(jDistribution.getCreditAmount()/jDistribution.getTransRate()) +")</div></td></tr>";
						sListContent = sListContent + "<tr><td colspan=\"5\" class=\"listgensell\"><div align=\"left\"><b>"+strTitle[language][1]+" : </b>"+ jDistribution.getNote() +"</div></td></tr>";
		
		 
		 totDebet += jDistribution.getDebitAmount();
		 totCredit += jDistribution.getCreditAmount();
		
	}
}

	sResult = sListOpening + sListContent + sListClosing;
	vResult.add(sResult);
	vResult.add(""+totDebet);
	vResult.add(""+totCredit);
	return vResult;
}

//-------------------------------------------------- End J Distribution ------------------------------------------------
%>
<!-- JSP Block -->

<%
/** Get value from hidden form */
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE JOURNAL PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES JURNAL SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long arApItemId = FRMQueryString.requestLong(request,"arap_item_id");
long oidArApMain = FRMQueryString.requestLong(request,"arap_main_id");
int arapType = FRMQueryString.requestInt(request,"arap_type");
int arapEdit = FRMQueryString.requestInt(request,"arapEdit");
int editDetail = FRMQueryString.requestInt(request,"edit_detail");
long jDistributionId = FRMQueryString.requestLong(request,"j_distribution_id");
int posted = FRMQueryString.requestInt(request,FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]);

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Payment" : "Tambah Angsuran";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Payment" : "Simpan Angsuran";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Payment" : "Hapus Angsuran";
String strDeleteMain = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete "+PstArApMain.stTypeArAp[1][arapType] : "Hapus "+PstArApMain.stTypeArAp[0][arapType];
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Payment" : "Ya Hapus Angsuran";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String sArapPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Plan Payment" : "Daftar Angsuran";
String sAddJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Journal Distribution" : "Tambah Jurnal Distribusi";
String sSaveJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Journal Distribution" : "Simpan Jurnal Distribusi";

if(iCommand==Command.NONE)
        iCommand = Command.ADD;

if(iCommand == Command.ADD)
		arApItemId = 0;

String strMenuType = "";
try{
	strMenuType = (String)session.getValue("MENU_TYPE");
}catch(Exception e){
	System.out.println("Exception on getMenuType from session ::: "+e.toString());
}

int menuType = 0;
if(strMenuType != null && strMenuType.length() > 0){
	menuType = Integer.parseInt(strMenuType);
}
	
// Instansiasi CtrlJurnalDetail and FrmJurnalDetail
CtrlArApItem ctrlArApItem = new CtrlArApItem(request);
ctrlArApItem.setLanguage(SESS_LANGUAGE);
FrmArApItem frmArApItem = ctrlArApItem.getForm();
frmArApItem.setDecimalSystemSeparator(sUserDecimalSymbol);
frmArApItem.setDigitSystemSeparator(sUserDigitGroup);
ArApItem arApItem = ctrlArApItem.getArApItem();
int iErrCode = ctrlArApItem.action(iCommand,arApItemId);
String msgString = ctrlArApItem.getMessage();

// Untuk main order arap
ControlLine ctrLine = new ControlLine();
CtrlArApMain ctrlArApMain = new CtrlArApMain(request);
ctrlArApMain.setLanguage(SESS_LANGUAGE);
FrmArApMain frmArApMain = ctrlArApMain.getForm();
frmArApMain.setDecimalSystemSeparator(sUserDecimalSymbol);
frmArApMain.setDigitSystemSeparator(sUserDigitGroup);

/** Instansiasi object CtrlJournalDistribution and FrmJournalDistribution */

int iErrCodexx = ctrlArApMain.action(Command.EDIT,oidArApMain);
ArApMain arApMain = ctrlArApMain.getArApMain();
    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(arApMain.getContactId());
    }catch(Exception e){}

   // get list item dan sinkronisasi dengan main
    int cnop = 0;
    double totAng = 0;
    boolean needUpdate = false;   
     String where = PstArApItem.fieldNames[PstArApItem.FLD_ARAP_MAIN_ID]+"="+oidArApMain+
            " AND "+PstArApItem.fieldNames[PstArApItem.FLD_SELLING_AKTIVA_ID]+" = 0 "+
            " AND "+PstArApItem.fieldNames[PstArApItem.FLD_RECEIVE_AKTIVA_ID]+" = 0 ";
    String order = PstArApItem.fieldNames[PstArApItem.FLD_DUE_DATE];
    Vector list = PstArApItem.list(0,0,where,order);

    cnop = list.size();
    totAng = PstArApItem.getTotalAngsuran(where);
    if(cnop>0 && cnop!=arApMain.getNumberOfPayment()){
        arApMain.setNumberOfPayment(cnop);
        needUpdate = true;
    }
    if(totAng>0 && totAng!=arApMain.getAmount()){
        arApMain.setAmount(totAng);
        needUpdate = true;
    }

    if(needUpdate){
        try{
            PstArApMain.updateExc(arApMain);	    
        }
        catch(Exception e){
            System.out.println("err on UPDATE MAIN: "+e.toString());
        }
    }
   
    ArApMain objArapMain = new ArApMain();
    if(iCommand == Command.SUBMIT && oidArApMain != 0){
	try{
	    objArapMain = PstArApMain.fetchExc(oidArApMain);
	    objArapMain.setArApDocStatus(I_DocStatus.DOCUMENT_STATUS_POSTED);
	    objArapMain.setArApMainStatus(I_DocStatus.DOCUMENT_STATUS_POSTED);
	    long lUpdate = PstArApMain.updateExc(objArapMain);
	}catch(Exception e){}
    }
	
	String whClauseJD = PstJournalDistribution.fieldNames[PstJournalDistribution.FLD_ARAP_MAIN_ID]+" = "+oidArApMain;
	Vector vJDistribution = oidArApMain==0 ? new Vector() : PstJournalDistribution.list(0,0,whClauseJD,PstJournalDistribution.fieldNames[PstJournalDistribution.FLD_JOURNAL_DISTRIBUTION_ID]);
	Vector vBisnisCenter = PstBussinessCenter.list(0,0,"",PstBussinessCenter.fieldNames[PstBussinessCenter.FLD_BUSS_CENTER_NAME]);

	// get masterdata currency
	String sOrderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
	Vector vlistCurrencyType = PstCurrencyType.list(0, 0, "", sOrderBy);

	// get masterdata standart rate
	String sStRateWhereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS] + " = " + PstStandartRate.ACTIVE;
	String sStRateOrderBy = PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE] + 
						", " + PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE];
	Vector vlistRate = SessDailyRate.getDataCurrency();
	
	long periodId = PstPeriode.getCurrPeriodId();
	long accountId = arApMain.getIdPerkiraan();
	double dDebetVal = 0.0;
	double dKreditVal  = 0.0;
	Vector vListJournalDistribution = new Vector();
	if(iUseJournalDistribution == 1){
		vListJournalDistribution = (Vector) drawListJDistribution(iCommand,SESS_LANGUAGE,frmArApItem,vJDistribution,arApMain.getArApDocStatus());
	}
	String sListJDistribution = "";
	if(vListJournalDistribution != null && vListJournalDistribution.size() > 0){
		sListJDistribution = vListJournalDistribution.get(0).toString();
		dDebetVal = Double.parseDouble(vListJournalDistribution.get(1).toString());
		dKreditVal = Double.parseDouble(vListJournalDistribution.get(2).toString());
	}
	// --------------------------- End Journal Distribution -----------------------
%>
<%if(iCommand == Command.SUBMIT && arapEdit == 1){%>
    <jsp:forward page="arap_entry_list.jsp">
	<jsp:param name="command" value="<%=Command.LAST%>"/>
    </jsp:forward>
<%}%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript" src="../main/dsj_common.js"></script>
<script language="JavaScript">
var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";
function cmdAdd(){
	document.frmarapentry.command.value="<%=Command.ADD%>";
	document.frmarapentry.prev_command.value="<%=Command.ADD%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdSave(){
	document.frmarapentry.command.value="<%=Command.SAVE%>";
	document.frmarapentry.edit_detail.value="1";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdCancel(){
	document.frmarapentry.command.value="<%=Command.NONE%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdEdit(oid){
	document.frmarapentry.arap_item_id.value = oid;
	document.frmarapentry.command.value="<%=Command.EDIT%>";
	document.frmarapentry.prev_command.value="<%=Command.EDIT%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdAsk(oid){
    document.frmarapentry.arap_item_id.value = oid;
	document.frmarapentry.command.value="<%=Command.ASK%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdDelete(oid){
    document.frmarapentry.arap_item_id.value = oid;
	document.frmarapentry.command.value="<%=Command.DELETE%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdItemData(journalId){
	document.frmarapentry.command.value="<%=Command.NONE%>";
	document.frmarapentry.journal_id.value=journalId;
	document.frmarapentry.action="jumum.jsp";
	document.frmarapentry.submit();
}

function cmdBack(){
    document.frmarapentry.arap_item_id.value = 0;
	document.frmarapentry.command.value="<%=Command.LIST%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdBackMain(){
	document.frmarapentry.command.value="<%=Command.BACK%>";
	document.frmarapentry.action="arap_entry_list.jsp";
	document.frmarapentry.submit();
}

function cmdBckMain(){
	document.frmarapentry.command.value="<%=Command.BACK%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdSaveMain(oid){
    document.frmarapentry.arap_main_id.value = oid;
	document.frmarapentry.command.value="<%=Command.SAVE%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdPosted(){
	document.frmarapentry.command.value="<%=Command.SUBMIT%>";
	document.frmarapentry.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]%>.value = "<%=I_DocStatus.DOCUMENT_STATUS_POSTED%>";
	document.frmarapentry.posted_status.value="1";
	<%if(arapEdit == 1){%>
	    document.frmarapentry.action="arap_entry_detail.jsp";
	<%}else{%>
	    document.frmarapentry.action="arap_entry_edit.jsp";
	<%}%>
	document.frmarapentry.submit();
}

function cmdAskMain(oid){
    document.frmarapentry.arap_main_id.value = oid;
	document.frmarapentry.command.value="<%=Command.ASK%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdopen(){
    window.open("srccontact_list.jsp","search_company","height=550,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}


function cmdNominal(){
    var nom = parseFloat('0');
    var rate = parseFloat('0');
    var sNom = cleanNumberFloat(document.frmarapentry.NOMINAL.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sNom)){
        nom = parseFloat(sNom);
    }
    var sRate = cleanNumberFloat(document.frmarapentry.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_RATE]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sRate)){
        rate = parseFloat(sRate);
    }
    document.frmarapentry.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_AMOUNT]%>.value=formatFloat((rate*nom), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
}

function addNewJDistribution(){
	
    var prev = document.frmarapentry.command.value;
		
	document.frmarapentry.command.value="<%=Command.NONE%>";
	document.frmarapentry.prev_command.value=prev;
	document.frmarapentry.action="arap_j_distribution.jsp";
	document.frmarapentry.submit();
}


function cmdClickBisnisCenter(oid)
{
    var prev = document.frmarapentry.command.value;

	document.frmarapentry.j_distribution_id.value=oid;
	document.frmarapentry.command.value="<%=Command.EDIT%>";
	document.frmarapentry.prev_command.value=prev;
	document.frmarapentry.action="arap_j_distribution.jsp";
	document.frmarapentry.submit();
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
            : <font color="#CC3300"><%=listTitle[arapType][SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmarapentry" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">	      
	          <input type="hidden" name="arapEdit" value="<%=arapEdit%>">
	          <input type="hidden" name="edit_detail" value="<%=editDetail%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_CONTACT_ID]%>" value="<%=arApMain.getContactId()%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_MAIN_STATUS]%>" value="<%=arApMain.getArApMainStatus()%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]%>" value="<%=arApMain.getArApDocStatus()%>">
              <input type="hidden" name="<%=FrmArApItem.fieldNames[FrmArApItem.FRM_ARAP_MAIN_ID]%>" value="<%=oidArApMain%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_TYPE]%>" value="<%=arapType%>">
              <input type="hidden" name="arap_main_id" value="<%=oidArApMain%>">
              <input type="hidden" name="arap_item_id" value="<%=arApItemId%>">			  
              <input type="hidden" name="j_distribution_id" value="<%=jDistributionId%>">
              <input type="hidden" name="posted_status" value="0">
              <input type="hidden" name="arap_type" value="<%=arapType%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%">&nbsp;
                        </td>
                      </tr>
                      <tr>
                        <td width="100%" class="tabtitleactive" valign="top">
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
                            <tr>
                              <td width="3%"></td>
                              <td width="94%">
                                <table width="100%">
								<tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25"><%=cekNull(arApMain.getVoucherNo())%>
									</td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][6]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%=FrmJournalDistribution.userFormatStringDecimal(arApMain.getRate())%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][1]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<%=Formater.formatDate(arApMain.getVoucherDate(),"dd-MM-yyyy")%>
									</td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][7]%>&nbsp;/&nbsp;<%=strTitle[SESS_LANGUAGE][15]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%=FrmJournalDistribution.userFormatStringDecimal(arApMain.getAmount()/arApMain.getRate())%>
                                      &nbsp;/&nbsp;<%=FrmJournalDistribution.userFormatStringDecimal(arApMain.getAmount())%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25"><%=cekNull(arApMain.getNotaNo())%>
									</td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][8]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%=arApMain.getNumberOfPayment()%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][3]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<%
                                        Date dtTransactionDate = arApMain.getNotaDate();
                                        if(dtTransactionDate ==null)
                                        {
                                            dtTransactionDate = new Date();
                                        }
                                        out.println(Formater.formatDate(dtTransactionDate,"dd-MM-yyyy"));
									%>
                                    </td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][9]+" "+listTitle[arapType][SESS_LANGUAGE]%>  </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                      <%
										Perkiraan perkiraanPayment = new Perkiraan();
										String namaPerkiraanPayment = "";
									   if(arApMain.getIdPerkiraan() > 0){
									   		try{
									   			perkiraanPayment = PstPerkiraan.fetchExc(arApMain.getIdPerkiraan());
												namaPerkiraanPayment = getAccName(SESS_LANGUAGE,perkiraanPayment);
											}catch(Exception e){}
									   }
									  %>
                                      <%=namaPerkiraanPayment%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][4]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25"><%=mergeString(contactList.getCompName(),contactList.getPersonName())%>
                                    </td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][10]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                    <%
										Perkiraan perkiraanLawan = new Perkiraan();
										String namaPerkiraanLawan = "";
									   if(arApMain.getIdPerkiraanLawan() > 0){
									   		try{
									   			perkiraanLawan = PstPerkiraan.fetchExc(arApMain.getIdPerkiraanLawan());
												namaPerkiraanLawan = getAccName(SESS_LANGUAGE,perkiraanLawan);
											}catch(Exception e){}
									   }
									  %>
                                      <%=namaPerkiraanLawan%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][5]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									  <%
									  		CurrencyType currencyType = new CurrencyType();
											String sCurrency = "";
											if(arApMain.getIdCurrency() > 0){
												try{
													currencyType = PstCurrencyType.fetchExc(arApMain.getIdCurrency());
													sCurrency = currencyType.getName()+"("+currencyType.getCode()+")";
												}catch(Exception e){}
											}
									  %> 
									  <%=sCurrency%>
									  </td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][11]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%=cekNull(arApMain.getDescription())%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                 <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
								  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                 <tr>
                                    <td colspan="6" class="contenttitle"><%=sArapPaymentTerm%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=drawList(SESS_LANGUAGE,iCommand,list,arApItemId, frmArApItem,iErrCode)%></td>
                                  </tr>
								  <tr><td colspan="6"><%//=msgString%></td></tr>
                                  <tr>
                                    <td colspan="5"><%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault(SESS_LANGUAGE,"");
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+arApItemId+"')";
							String sconDelCom = "javascript:cmdDelete('"+arApItemId+"')";
							String scancel = "javascript:cmdEdit('"+arApItemId+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);
                            ctrLine.setAddCaption(strAdd);
							ctrLine.setSaveCaption(strSave);
							ctrLine.setBackCaption(strBack);
                            ctrLine.setDeleteCommand(scomDel);
							//ctrLine.setSaveCaption(strSave);

                            if(iCommand==Command.SAVE && iErrCode==0){
                                ctrLine.setBackCaption("");
                            }else if(iCommand==Command.LIST)
                                ctrLine.setBackCaption("");
                            else if(iCommand==Command.DELETE){
                                iCommand=Command.LIST;
                                ctrLine.setBackCaption("");
                            }

                            ctrLine.setDeleteCaption(strDelete);
							ctrLine.setConfirmDelCaption(strYesDelete);

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
							if(iCommand == Command.ASK){
								//ctrLine.setDeleteQuestion(strDelete);
                                ctrLine.setBackCaption("");
							}
							
							if(iCommand == Command.LIST && menuType == 0){
								ctrLine.setBackCaption(strBack);
								ctrLine.setBackCommand("javascript:cmdBackMain()");
							}
							
							
							
                            if(arApMain.getArApDocStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
                               out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							}
							%>
			    </td>
			    <td>
				    <%
					if(iCommand == Command.SAVE && list.size()>0 && arApMain.getArApDocStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED && iErrCode == 0 && iUseJournalDistribution == 0){
						out.println("<a href=\"javascript:cmdPosted()\" class=\"command\">"+strTitle[SESS_LANGUAGE][13]+"</a>");
					}
				    %>
				</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="76%" nowrap scope="row"><%
                            ControlLine controlLine = new ControlLine();
							controlLine.setLocationImg(approot+"/images");
							controlLine.initDefault(SESS_LANGUAGE,"");
							controlLine.setTableWidth("80%");
							scomDel = "javascript:cmdAskMain('"+oidArApMain+"')";
							sconDelCom = "javascript:cmdConfirmDeleteMain('"+oidArApMain+"')";
							scancel = "javascript:cmdEdit('"+oidArApMain+"')";
                            strSave = "javascript:cmdSaveMain('"+oidArApMain+"')";
                            strBack = "javascript:cmdBackMain('"+oidArApMain+"')";
							controlLine.setCommandStyle("command");
							controlLine.setColCommStyle("command");
                            controlLine.setDeleteCaption(strDeleteMain);
                            controlLine.setSaveCaption(controlLine.getSaveCaption()+listTitle[arapType][SESS_LANGUAGE]);
                            controlLine.setSaveCommand(strSave);
							controlLine.setDeleteCommand(scomDel);
							controlLine.setConfirmDelCommand(strDelete);
                            controlLine.setBackCommand(strBack);

							if (privDelete){
								controlLine.setConfirmDelCommand(sconDelCom);
								controlLine.setDeleteCommand(scomDel);
								controlLine.setEditCommand(scancel);
							}else{
								controlLine.setConfirmDelCaption("");
								controlLine.setDeleteCaption("");
								controlLine.setEditCaption("");
							}

							if(privAdd == false  && privUpdate == false){
								controlLine.setSaveCaption("");
							}

							if (privAdd == false){
								controlLine.setAddCaption("");
							}

							if(iCommand == Command.ASK)
							{
								controlLine.setDeleteQuestion(strDelete);
							}

                            if(arApMain.getArApDocStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){
                                //controlLine.setBackCaption(strBack);
                                controlLine.setSaveCaption("");
                                controlLine.setDeleteCaption("");
                                controlLine.setAddCaption("");
                            }

							//out.println(controlLine.draw(Command.EDIT, 0, ""));
							
							%></td>
                                        <td width="24%" align="right">&nbsp;</td>
                                      </tr>
                                    </table></td>
                                  </tr>
								   <%if(vListJournalDistribution.size() > 0 && list.size() > 0 && oidArApMain != 0){%>
								  <tr>
                                    <td colspan="6" class="contenttitle"><%=strTitleJDistribution[SESS_LANGUAGE][10]%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=sListJDistribution%></td>
                                  </tr>								  
                                  <tr>
                                    <td colspan="6">
										<a href="javascript:addNewJDistribution()" class="command"><%=sAddJDistribution%></a>
										<%if(iUseJournalDistribution == 1 && arApMain.getArApDocStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED && (dDebetVal + dKreditVal) > 0){%>
											| <a href="javascript:cmdPosted()" class="command"><%=strTitle[SESS_LANGUAGE][13]%></a>
										<%}%>
									</td>
                                  </tr>
								  <%}%>
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
<%//}%>