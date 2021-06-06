<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.aiso.form.arap.FrmArApMain,
                   com.dimata.aiso.form.arap.CtrlArApMain,
                   com.dimata.aiso.entity.arap.ArApMain,
                   com.dimata.util.Command,
                   com.dimata.util.Formater,
                   com.dimata.gui.jsp.ControlDate,
                   com.dimata.interfaces.trantype.I_TransactionType,
                   com.dimata.gui.jsp.ControlCombo,
                   com.dimata.gui.jsp.ControlLine,
                   com.dimata.common.entity.payment.CurrencyType,
                   com.dimata.common.entity.payment.PstCurrencyType,
                   com.dimata.common.entity.contact.ContactList,
                   com.dimata.common.entity.contact.PstContactList,
                   com.dimata.aiso.form.arap.FrmArApItem,
                   com.dimata.gui.jsp.ControlList,
                   com.dimata.aiso.entity.arap.ArApItem,
                   com.dimata.aiso.entity.masterdata.*,
                   com.dimata.aiso.entity.arap.PstArApItem,
                   com.dimata.aiso.session.arap.SessArApEntry,
                   com.dimata.aiso.entity.arap.PstArApMain,
                   com.dimata.util.Validator,
                   com.dimata.common.entity.payment.PstStandartRate,
                   com.dimata.common.entity.payment.StandartRate" %>
				   
<!--- For Journal Distbution --->
<%@ page import="com.dimata.aiso.entity.jurnal.JournalDistribution" %> 
<%@ page import="com.dimata.aiso.entity.jurnal.PstJournalDistribution" %> 
<%@ page import="com.dimata.aiso.session.jurnal.SessJurnal" %> 
<%@ page import="com.dimata.aiso.form.jurnal.FrmJournalDistribution" %>
<%@ page import="com.dimata.aiso.form.jurnal.CtrlJournalDistribution" %>
<%@ page import="com.dimata.aiso.session.masterdata.SessDailyRate"%>
<%@ page import="com.dimata.aiso.entity.periode.PstPeriode"%>

<!-- End Journal Distribution -->
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
if(!privView && !privAdd && !privUpdate && !privDelete && !privSubmit){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>

<!-- if of "has access" condition -->
<%
}else{
%>

<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static final int INT_VALID_DELETE = 0;
public static final int INT_INVALID_DELETE = 1;

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
	"Input Jurnal Distribusi","Keterangan","Debet(Rp)","Kredit(Rp)","Mata Uang","Kurs(Rp)","Pusat Bisnis","Untuk","Catatan","Silahkan input debet atau kredit sesuai nilai mata uangnya. System seraca otomatis mengkonversi ke rupiah.","Daftar Journal Distribusi","COA"
	},	
	
	{ // 0                                                          //4                                                        //9 
	"Journal Distribution Entry","Remark","Debet(Rp)","Credit(Rp)","Currency","Rate(Rp)","Bussiness Center","For","Note","Please entry debit or credit amount in original currency. System will convert automatically to local currency.","List Journal Distribution","COA"
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

public Vector getOppositeAccount(Vector vResult, Vector vInput){
	if(vInput != null && vInput.size() > 0){
		try{
			for(int i = 0; i < vInput.size(); i++){
				Perkiraan objPerkiraan = (Perkiraan)vInput.get(i);
				vResult.add(objPerkiraan);
			}
		}catch(Exception e){vResult = new Vector(1,1);}
	}
	return vResult;
}

public String drawList(int language, Vector objectClass,FrmArApMain frmArApMain,int arapMainStatus){
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

	Vector lstData = ctrlist.getData();
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
	int size = objectClass.size();
	for (int i = 0; i < size; i++) {

		ArApItem arApItem = (ArApItem)objectClass.get(i);

	rowx = new Vector();
        rowx.add(""+(i+1));
        if(arApItem.getAngsuran()==arApItem.getLeftToPay() && arapMainStatus != I_DocStatus.DOCUMENT_STATUS_POSTED){
                rowx.add("<a href=\"javascript:cmdEditDetail('"+arApItem.getOID()+"')\">"+frmArApMain.userFormatStringDecimal(arApItem.getAngsuran())+"</a>");
        }
        else{
            rowx.add(frmArApMain.userFormatStringDecimal(arApItem.getAngsuran()));
        }
        rowx.add(Formater.formatDate(arApItem.getDueDate(),"dd-MMM-yyyy"));
        rowx.add(arApItem.getDescription());

        lstData.add(rowx);
    }

    return ctrlist.drawMe(index);
}
/**
* this method used to list jurnal detail input
*/
public String drawList(int language, int nop){
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

	Vector lstData = ctrlist.getData();
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
    int size = nop;
	for (int i = 0; i < size; i++) {
        rowx = new Vector();
        rowx.add(""+(i+1));
        rowx.add("<input size=\"20\" type=\"text\" style=\"text-align:right\" name=\"ANGSURAN"+i+"\" value=\"\">");
        String stDate = ControlDate.drawDate("DUE_DATE"+i,new Date(),4,-5);
	
	rowx.add(stDate);
	
        if(i==0){
            rowx.add("<input size=\"55\" type=\"text\" name=\"DESCRIPTION"+i+"\" value=\"\"><a href=\"javascript:cmdSetAngsuran()\">"+strTitle[language][14]+"</a>");
        }
        else{
            rowx.add("<input size=\"55\" type=\"text\" name=\"DESCRIPTION"+i+"\" value=\"\">");
        }

        lstData.add(rowx);
    }

    return ctrlist.drawMe(index);
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

public Vector drawListJDistribution(int iCommand, int language, FrmArApMain frmArApMain, Vector vJDistribution, int posted)
{
         Vector vResult = new Vector();
    String sResult = "";
    String sListOpening = "<table width=\"100%\" border=\"0\" class=\"listgen\" cellspacing=\"1\">";
    sListOpening = sListOpening + "<tr><td width=\"15%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][6] + "</div></td>";//2 Bisnis Center
    sListOpening = sListOpening + "<td width=\"15%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][11] + "</div></td>";//13 COA
    sListOpening = sListOpening + "<td width=\"15%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][4] + "</div></td>";//3 Currency
    sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][5] + "</div></td>";//4 Rate
    sListOpening = sListOpening + "<td width=\"30%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][2] + "</div></td>";//5 Debet
    sListOpening = sListOpening + "<td width=\"30%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][3] + "</div></td></tr>";//6 Credit


    String sListClosing = "</table>";
    String sListContent = "";
    String accName = "";

    Vector currencytypeid_value = new Vector(1, 1);
    Vector currencytypeid_key = new Vector(1, 1);
    String selectedCurrType = "";
    double totDebet = 0.0;
    double totCredit = 0.0;


    JournalDistribution jDistribution = new JournalDistribution();
    if (vJDistribution != null && vJDistribution.size() > 0) {
        // --- start proses content ---
        for (int it = 0; it < vJDistribution.size(); it++) {
            jDistribution = (JournalDistribution) vJDistribution.get(it);

            String bisnisCenterName = "";
            if (jDistribution.getBussCenterId() != 0) {
                try {
                    BussinessCenter bisnisCenter = PstBussinessCenter.fetchExc(jDistribution.getBussCenterId());
                    bisnisCenterName = bisnisCenter.getBussCenterName();
                } catch (Exception e) {
                }
            }

            String currName = "";
            CurrencyType currencyType = new CurrencyType();
            if (jDistribution.getCurrencyId() != 0) {
                try {
                    currencyType = PstCurrencyType.fetchExc(jDistribution.getCurrencyId());
                    currName = currencyType.getName() + "(" + currencyType.getCode() + ")";
                } catch (Exception e) {
                }
            }
            Perkiraan coa = new Perkiraan();
            coa.setNama("NO COA, PLEASE FIX");
            if(jDistribution.getOID()!=0){
                try{
                    coa = PstPerkiraan.fetchExc(jDistribution.getIdPerkiraan());
                }catch(Exception exc){
                    System.out.println("erap_entry_edit : EXC"+exc);
                }                
            }

            if (posted == 0) {
                sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"><a href=\"javascript:cmdClickBisnisCenter('" + jDistribution.getOID() + "')\">" + bisnisCenterName + "</a></div></td>";
            } else {
                sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\">" + bisnisCenterName + "</div></td>";
            }            
            sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">" + coa.getNoPerkiraan() +" &nbsp;" + coa.getNama() + "</div></td>";
            sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">" + currName + "</div></td>";
            sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">" + frmArApMain.userFormatStringDecimal(jDistribution.getTransRate()) + "</div></td>";
            sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">" + frmArApMain.userFormatStringDecimal(jDistribution.getDebitAmount()) + "&nbsp; (" + currencyType.getCode().toUpperCase() + " = " + frmArApMain.userFormatStringDecimal(jDistribution.getDebitAmount() / jDistribution.getTransRate()) + ")</div></td>";
            sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">" + frmArApMain.userFormatStringDecimal(jDistribution.getCreditAmount()) + "&nbsp; (" + currencyType.getCode().toUpperCase() + " = " + frmArApMain.userFormatStringDecimal(jDistribution.getCreditAmount() / jDistribution.getTransRate()) + ")</div></td></tr>";
            sListContent = sListContent + "<tr><td colspan=\"5\" class=\"listgensell\"><div align=\"left\"><b>" + strTitleJDistribution[language][1] + " : </b>" + jDistribution.getNote() + "</div></td></tr>";


            totDebet += jDistribution.getDebitAmount();
            totCredit += jDistribution.getCreditAmount();
        }


    }

    sResult = sListOpening + sListContent + sListClosing;
    vResult.add(sResult);
    vResult.add("" + totDebet);
    vResult.add("" + totCredit);
    return vResult;
}

//-------------------------------------------------- End J Distribution ------------------------------------------------
%>


<!-- JSP Block -->
<%
// get request from hidden text
showMenu = false;
int arapType = FRMQueryString.requestInt(request,"arap_type");
int menuType = FRMQueryString.requestInt(request,"menu_type");
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE "+PstArApMain.stTypeArAp[1][arapType].toUpperCase()+" PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES "+PstArApMain.stTypeArAp[0][arapType].toUpperCase()+" SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int arapEdit = FRMQueryString.requestInt(request, "arapEdit");
int index = FRMQueryString.requestInt(request,"command_posted");
int iCommandPost = FRMQueryString.requestInt(request,"index");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidArApMain = FRMQueryString.requestLong(request,"arap_main_id");
long jDistributionId = FRMQueryString.requestLong(request,"j_distribution_id");
int posted = FRMQueryString.requestInt(request,"posted_status");

System.out.println("iCommand = "+iCommand);
/**
* Declare Commands caption
*/
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Payment Term" : " Tambah Angsuran";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To "+PstArApMain.stTypeArAp[1][arapType]+ " List": "Kembali Ke Daftar "+PstArApMain.stTypeArAp[0][arapType];
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete "+PstArApMain.stTypeArAp[1][arapType] : "Hapus "+PstArApMain.stTypeArAp[0][arapType];
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete" : "Ya Hapus";
String strRequired = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Required" : "Diperlukan";
String strConfirmDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are your sure delete data?" : "Apakah anda yakin menghapus data?";
String strDescription = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Entry" : "Input";
String sArapPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Plan Payment" : "Daftar Angsuran";
String sAddJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Journal Distribution" : "Tambah Jurnal Distribusi";
String sSaveJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Journal Distribution" : "Simpan Jurnal Distribusi";



if(iCommand == Command.SAVE && oidArApMain != 0 && posted == 0){
    oidArApMain = 0;
}

/** Instansiasi object CtrlArApMain and FrmArApMain */
ControlLine ctrLine = new ControlLine();
CtrlArApMain ctrlArApMain = new CtrlArApMain(request);
ctrlArApMain.setLanguage(SESS_LANGUAGE);
FrmArApMain frmArApMain = ctrlArApMain.getForm();
frmArApMain.setDecimalSystemSeparator(sUserDecimalSymbol);
frmArApMain.setDigitSystemSeparator(sUserDigitGroup);
int iErrCode = ctrlArApMain.action(iCommand, oidArApMain);
ArApMain arApMain = ctrlArApMain.getArApMain();
 if( arApMain==null){
     arApMain = new ArApMain();
 }
oidArApMain = arApMain.getOID();
String msgString = ctrlArApMain.getMessage();


frmArApMain.setDecimalSeparator(sUserDecimalSymbol);
frmArApMain.setDigitSeparator(sUserDigitGroup);

    // proses untuk command SUBMIT
    /**
     * proses ini juga akan mengupdate ArApMain jika ada ketidaksesuaian dalam jumlah
     * total angsuran dan number of payment nya
     */
ArApItem arApItem = new ArApItem();	 
if(iCommand==Command.SUBMIT){    
    for(int i=0;i<arApMain.getNumberOfPayment();i++){
        String stAngsuran = FRMQueryString.requestString(request,"ANGSURAN"+i);
        if(stAngsuran==null||stAngsuran.length()==0){
            stAngsuran = "0";
        }
        double angsuran = Double.parseDouble(frmArApMain.deFormatStringDecimal(stAngsuran));
        Date dueDate = FRMQueryString.requestDate(request,"DUE_DATE"+i);
        String desc = FRMQueryString.requestString(request,"DESCRIPTION"+i);
	
        arApItem = new ArApItem();
        arApItem.setAngsuran(angsuran);
        arApItem.setArApItemStatus(PstArApMain.STATUS_OPEN);
        arApItem.setArApMainId(oidArApMain);
        arApItem.setDescription(desc);
        arApItem.setDueDate(dueDate);
        arApItem.setLeftToPay(angsuran);
        arApItem.setCurrencyId(arApMain.getIdCurrency());
        arApItem.setRate(arApMain.getRate());
	
        if(arApItem.getAngsuran()>0){
            try{
                PstArApItem.insertExc(arApItem);
            }
            catch(Exception e){
                System.out.println("err on SUBMIT: "+e.toString());
            }
        }
    }

}

Vector list = new Vector();

if(posted!=0 && iCommand == Command.SAVE){
        SessArApEntry sessArApMain = new SessArApEntry();
        int iPosted = sessArApMain.postingArApMain(accountingBookType,userOID,currentPeriodOid,arApMain);
		if(iPosted != 0){
			iCommand = Command.ADD;
			arApMain = new ArApMain(); 
			list = new Vector(1,1);
			if(arApMain != null)				
				msgString = ctrlArApMain.resultText[SESS_LANGUAGE][iErrCode];
		}
    }

    // get nama company
    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(arApMain.getContactId());
    }catch(Exception e){}
   
    
    int cnop = 0;
    double totAng = 0;
    boolean needUpdate = false;
    if(iCommand==Command.SAVE && iErrCode == 0 && posted == 1){
	    iCommand = Command.ADD;
	    arApMain = new ArApMain(); 
	    arApItem = new ArApItem();
	    contactList = new ContactList();
	    posted = 0;
	    list = new Vector();
    } 
    if(iCommand==Command.NONE){
        iCommand = Command.ADD;
     }else if((iCommand==Command.SAVE && iErrCode == 0 && posted == 0)){
	 needUpdate = false;
	 totAng = 0;
	 cnop = 0;	
    }
	
	
    // get list item dan sinkronisasi dengan main
    
    String where = PstArApItem.fieldNames[PstArApItem.FLD_ARAP_MAIN_ID]+"="+oidArApMain+
            " AND "+PstArApItem.fieldNames[PstArApItem.FLD_SELLING_AKTIVA_ID]+" = 0 "+
            " AND "+PstArApItem.fieldNames[PstArApItem.FLD_RECEIVE_AKTIVA_ID]+" = 0 ";
    String order = PstArApItem.fieldNames[PstArApItem.FLD_DUE_DATE];
	
	if(iCommand == Command.EDIT || iCommand == Command.SUBMIT){
	    list = PstArApItem.list(0,0,where,order);
	}
	
	// Get data for list journal distribution
	
	/** Create vector as object handle for transaction below */
	//Table journal distribution mesti simpen arap_main_id and arap_payment_id
	String whClauseJD = PstJournalDistribution.fieldNames[PstJournalDistribution.FLD_ARAP_MAIN_ID]+" = "+oidArApMain;
	Vector vJDistribution = oidArApMain==0? new Vector() : PstJournalDistribution.list(0,0,whClauseJD,PstJournalDistribution.fieldNames[PstJournalDistribution.FLD_JOURNAL_DISTRIBUTION_ID]);
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
	//System.out.println("iUseJournalDistribution :::::::::::::::::::::::: "+iUseJournalDistribution);
	if(iUseJournalDistribution == 1){
		vListJournalDistribution = (Vector) drawListJDistribution(iCommand,SESS_LANGUAGE,frmArApMain,vJDistribution,arApMain.getArApDocStatus());
	}
	String sListJDistribution = "";
	if(vListJournalDistribution != null && vListJournalDistribution.size() > 0){
		sListJDistribution = vListJournalDistribution.get(0).toString();
		dDebetVal = Double.parseDouble(vListJournalDistribution.get(1).toString());
		dKreditVal = Double.parseDouble(vListJournalDistribution.get(2).toString());
	}
	// --------------------------- End Journal Distribution -----------------------
    if(iCommand == Command.SAVE && arApItem.getAngsuran() > 0){
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
    }

    
	
	// 
	
	if(arApMain.getArApDocStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED && menuType == 1){
			arApMain = new ArApMain();
			list = new Vector();
			contactList = new ContactList();
			iCommand = Command.ADD;
	}
	
	if(session.getValue("MENU_TYPE") != null){
		session.removeValue("MENU_TYPE");
	}
	
	if(iCommand == Command.ADD || iCommand == Command.EDIT){
		try{
			session.putValue("MENU_TYPE",String.valueOf(menuType));
		}catch(Exception e){};
	}
/** if Command.DELETE, delete journal and its descendant and redirect to journal detail page */
 
%>
<%if((iCommand == Command.ADD || iCommand == Command.DELETE) && arapEdit == 1){%>
	<jsp:forward page="arap_entry_list.jsp">	
	<jsp:param name="command" value="<%=Command.LAST%>"/>
	</jsp:forward>
<%
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript" src="../main/dsj_common.js"></script>
<script language="javascript">
var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

<%if((privView)&&(privAdd)&&(privSubmit)){%>
function getThn()
{
	var date1 = ""+document.frmarapentry.<%=frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE]%>.value;
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
	document.frmarapentry.<%=frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE] + "_mn"%>.value=bln;
	document.frmarapentry.<%=frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE] + "_dy"%>.value=hri;
	document.frmarapentry.<%=frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE] + "_yr"%>.value=thn;		
				
}


function addNewDetail(){
	document.frmarapentry.perkiraan.value=0;
	document.frmarapentry.index.value=-1;
	document.frmarapentry.command.value="<%=String.valueOf(Command.ADD)%>";
	document.frmarapentry.prev_command.value="<%=String.valueOf(Command.ADD)%>";
	document.frmarapentry.action="jdetail.jsp";
	document.frmarapentry.submit();
}

function addNew(){
	document.frmarapentry.journal_id.value="0";
	document.frmarapentry.command.value="<%=String.valueOf(Command.ADD)%>";
	document.frmarapentry.action="jdetail.jsp";
	document.frmarapentry.submit();
}

function cmdCancel(){
	document.frmarapentry.command.value="<%=String.valueOf(Command.ADD)%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdSave(){  
    <%if(iCommand == Command.SAVE && iErrCode == 0 && posted == 0){
     %>
     	document.frmarapentry.command.value="<%=String.valueOf(Command.SUBMIT)%>";		
     <%
   }
    else{
       %>
    	document.frmarapentry.command.value="<%=String.valueOf(Command.SAVE)%>";
       <%
    }
    %>

	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdPosted(){	
	document.frmarapentry.command.value="<%=String.valueOf(Command.SAVE)%>";	
	document.frmarapentry.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]%>.value = "<%=String.valueOf(I_DocStatus.DOCUMENT_STATUS_POSTED)%>";    
	document.frmarapentry.posted_status.value="1";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdAsk(){
	document.frmarapentry.command.value="<%=String.valueOf(Command.ASK)%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdEdit(oid){
	document.frmarapentry.arap_main_id.value=oid;	
	document.frmarapentry.command.value="<%=String.valueOf(Command.EDIT)%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdDelete(oid){
	document.frmarapentry.arap_main_id.value=oid;
	document.frmarapentry.command.value="<%=String.valueOf(Command.DELETE)%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	if(confirm("<%=strConfirmDelete%>")){
	    document.frmarapentry.submit();
	}
}

function cmdEditItem(oid){
	document.frmarapentry.command.value="<%=String.valueOf(Command.LIST)%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdAddDetail(oid){
    document.frmarapentry.arap_main_id.value=oid;
	document.frmarapentry.command.value="<%=String.valueOf(Command.ADD)%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdEditDetail(oid){
	document.frmarapentry.arap_item_id.value = oid;
	document.frmarapentry.arapEdit.value="<%=String.valueOf(arapEdit)%>";
	document.frmarapentry.command.value="<%=String.valueOf(Command.EDIT)%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

    <%}%>

function cmdBack(){
	document.frmarapentry.command.value="<%=String.valueOf(Command.BACK)%>";
	document.frmarapentry.start.value="<%=String.valueOf(start)%>";
	document.frmarapentry.action="arap_entry_list.jsp";
	document.frmarapentry.submit();
}

function cmdopen(){
    window.open("srccontact_list.jsp","search_company","left=300,top=250,height=550,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdChangeCurr(){
    var id = Math.abs(document.frmarapentry.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ID_CURRENCY]%>.value);
    switch(id){
<%
           Vector currencytypeid_value = new Vector(1,1);
           Vector currencytypeid_key = new Vector(1,1);
           String sel_currencytypeid = ""+arApMain.getIdCurrency();
           String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
           Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);
            double rate = 1;
           if(listCurrencyType!=null&&listCurrencyType.size()>0){
                for(int i=0;i<listCurrencyType.size();i++){
                    CurrencyType currencyType =(CurrencyType)listCurrencyType.get(i);
                    currencytypeid_value.add(currencyType.getName()+"("+currencyType.getCode()+")");
                    currencytypeid_key.add(""+currencyType.getOID());
                    Vector listStd = PstStandartRate.list(0,0,PstStandartRate.fieldNames[PstStandartRate.FLD_CURRENCY_TYPE_ID]+"="+currencyType.getOID()+
                            " AND "+PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS]+"="+PstStandartRate.ACTIVE,PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE]+" DESC");
                    rate = 1;
                    if(listStd!=null&&listStd.size()>0){
                        StandartRate stdRate = (StandartRate) listStd.get(0);
                        rate = stdRate.getSellingRate();
                    }
                    else{
                        rate = 1;   
                    }
                    %>
    case <%=String.valueOf(currencyType.getOID())%> :  
        document.frmarapentry.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_RATE]%>.value="<%=Formater.formatNumber(rate,"##,###.##")%>"
        break;
                    <%
                }
}
									  %>
    default :
        document.frmarapentry.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_RATE]%>.value="<%=frmArApMain.userFormatStringDecimal(1.0)%>"
        break;
    }
}

function cmdSetAngsuran(){
    var month = Math.abs(document.frmarapentry.DUE_DATE0_mn.value);
    month--;
    var year = Math.abs(document.frmarapentry.DUE_DATE0_yr.value);
    var day = Math.abs(document.frmarapentry.DUE_DATE0_dy.value);
    var desc = document.frmarapentry.DESCRIPTION0.value;
    <%
        int nop = arApMain.getNumberOfPayment();
        double dAngsuran = arApMain.getAmount()/nop;
        for(int i=0;i<nop;i++){
            %>
    month++;
    if(month>12){
        month=1;
        year++;
    }
    document.frmarapentry.ANGSURAN<%=String.valueOf(i)%>.value="<%=frmArApMain.userFormatStringDecimal(dAngsuran)%>";
    document.frmarapentry.DUE_DATE<%=String.valueOf(i)%>_mn.value=month;
    document.frmarapentry.DUE_DATE<%=String.valueOf(i)%>_yr.value=year;
    document.frmarapentry.DUE_DATE<%=String.valueOf(i)%>_dy.value=day;
    document.frmarapentry.DESCRIPTION<%=String.valueOf(i)%>.value=desc+" "+"<%=String.valueOf(i+1)%>";
            <%
        }
    %>
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

function hideObjectForDate(){
	document.frmarapentry.<%=frmArApMain.fieldNames[FrmArApMain.FRM_ID_CURRENCY]%>.style.display="none";
  }
	
  function showObjectForDate(){
  document.frmarapentry.<%=frmArApMain.fieldNames[FrmArApMain.FRM_ID_CURRENCY]%>.style.display="";
  }	

//------------------------------- JDistribution ------------------------------

function addNewJDistribution(oid){
	
    var prev = document.frmarapentry.command.value;
	
	document.frmarapentry.arap_main_id.value=oid;	
	document.frmarapentry.command.value="<%=Command.ADD%>";
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
//------------------------------- End JDistribution --------------------------
</script>
<link rel="stylesheet" href="../style/calendar.css" type="text/css">
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		  <%if(isUseDatePicker.equalsIgnoreCase("Y")){%> 
      		<table class="ds_box" cellpadding="0" cellspacing="0" id="ds_conclass" style="display: none;">
			<tr><td id="ds_calclass">
			</td></tr>
			</table>
			<script language=JavaScript src="<%=approot%>/main/calendar.js"></script>
			<%}%>		
		  <%=listTitle[arapType][SESS_LANGUAGE]%> : <font color="#CC3300"><%=masterTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
          <%try{%>
            <form name="frmarapentry" method="post" action="">
              <input type="hidden" name="command" value="<%=String.valueOf(iCommand==Command.ADD ? Command.ADD : Command.NONE)%>">
              <input type="hidden" name="start" value="<%=String.valueOf(start)%>">
	      	  <input type="hidden" name="arapEdit" value="<%=String.valueOf(arapEdit)%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_CONTACT_ID]%>" value="<%=String.valueOf(arApMain.getContactId())%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_COUNTER]%>" value="<%=String.valueOf(arApMain.getCounter())%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_MAIN_STATUS]%>" value="<%=String.valueOf(arApMain.getArApMainStatus())%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]%>" value="<%=String.valueOf(arApMain.getArApDocStatus())%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_TYPE]%>" value="<%=String.valueOf(arapType)%>">
              <input type="hidden" name="arap_main_id" value="<%=String.valueOf(oidArApMain)%>">
			  <input type="hidden" name="j_distribution_id" value="<%=jDistributionId%>">
              <input type="hidden" name="arap_item_id" value="0">
              <input type="hidden" name="posted_status" value="0">
	      	  <input type="hidden" name="command_posted" value="<%=String.valueOf(iCommandPost)%>">
              <input type="hidden" name="arap_type" value="<%=String.valueOf(arapType)%>">
	      	  <input type="hidden" name="menu_type" value="<%=String.valueOf(menuType)%>">
	          <input type="hidden" name="prev_command" value="<%=String.valueOf(prevCommand)%>">
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
                              
                              <td width="100%">
                                <table width="100%">
								<tr>
                                    <td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="39%" height="25">
									<input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_VOUCHER_NO]%>" value="<%=arApMain.getVoucherNo()%>" size="35"><%=arApMain.getVoucherNo()%>									</td>
                                    <td width="13%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][6]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="29%" height="25">
                                      <input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_RATE]%>" readonly style="background-color:#E8E8E8; text-align:right" value="<%=frmArApMain.userFormatStringDecimal(arApMain.getRate())%>">
									  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=strTitle[SESS_LANGUAGE][15]%>                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][1]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="39%" height="25">
                                    <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_VOUCHER_DATE]%>_dy" value="<%=String.valueOf(Validator.getIntDate(arApMain.getVoucherDate()))%>">
                                    <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_VOUCHER_DATE]%>_mn" value="<%=String.valueOf(Validator.getIntMonth(arApMain.getVoucherDate()))%>">
                                    <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_VOUCHER_DATE]%>_yr" value="<%=String.valueOf(Validator.getIntYear(arApMain.getVoucherDate()))%>">
									<%=Formater.formatDate(arApMain.getVoucherDate(),"dd-MM-yyyy")%>									</td>
                                    <td width="13%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][7]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="29%" height="25">
                                      <input maxlength="16" type="text" name="NOMINAL" <%=iCommand==Command.EDIT?"readonly":""%> style="<%=iCommand==Command.EDIT?"background-color:#E8E8E8;":""%>text-align:right" onBlur="javascript:cmdNominal()" value="<%=frmArApMain.userFormatStringDecimal(arApMain.getAmount()/arApMain.getRate())%>">
                                      &nbsp;<input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_AMOUNT]%>" size="20"  readonlu style="background-color:#E8E8E8;text-align:right" value="<%=frmArApMain.userFormatStringDecimal(arApMain.getAmount())%>">
                                      <%if(iErrCode == 2 && arApMain.getAmount() == 0){%><span class="errfont">*)&nbsp;<%=strRequired%></span><%}else{%>*<%}%>									</td>
                                  </tr>
								  
                                  <tr>
                                    <td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="39%" height="25">
									<input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_NOTA_NO]%>" value="<%=arApMain.getNotaNo()%>">
									<%if(iErrCode == 2 && arApMain.getNotaNo().length() == 0){%><span class="errfont">*)&nbsp;<%=strRequired%></span><%}else{%>*<%}%>									</td>
                                    <td width="13%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][8]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="29%" height="25">
                                    <input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_NUMBER_OF_PAYMENT]%>" size="3" <%=iCommand==Command.EDIT?"readonly":""%> style="<%=iCommand==Command.EDIT?"background-color:#E8E8E8;":""%>text-align:right" value="<%=arApMain.getNumberOfPayment() == 0? 1 : arApMain.getNumberOfPayment()%>">									</td>
                                  </tr>
                                  <tr>
                                    <td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][3]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="39%" height="25">
									<%
                                       /* Date dtTransactionDate = arApMain.getNotaDate();
                                        if(dtTransactionDate ==null)
                                        {
                                            dtTransactionDate = new Date();
                                        }
                                        out.println(ControlDate.drawDate(frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE], dtTransactionDate, 4, -5));
									*/%>
									 <%if(isUseDatePicker.equalsIgnoreCase("Y")){%>
                                          <input onClick="ds_sh(this);" name="<%=frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((arApMain.getNotaDate() == null) ? new Date() : arApMain.getNotaDate(), "dd-MM-yyyy")%>"/>
                                          <input type="hidden" name="<%=frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE] + "_mn"%>">
                                          <input type="hidden" name="<%=frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE] + "_dy"%>">
                                          <input type="hidden" name="<%=frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE] + "_yr"%>">
                                          <script language="JavaScript" type="text/JavaScript">getThn();</script>
                                          <%}%>                                    </td>
                                    <td width="13%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][9]+" "+listTitle[arapType][SESS_LANGUAGE]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="29%" height="25">
                                      <%
                                      Vector vDepartmentOid = new Vector(1,1);
                                      Vector vUsrCustomDepartment = PstDataCustom.getDataCustom(userOID, "hrdepartment");
                                      if(vUsrCustomDepartment!=null && vUsrCustomDepartment.size()>0)
                                      {
                                        int iDataCustomCount = vUsrCustomDepartment.size();
                                        for(int i=0; i<iDataCustomCount; i++)
                                        {
                                            DataCustom objDataCustom = (DataCustom) vUsrCustomDepartment.get(i);
                                            vDepartmentOid.add(objDataCustom.getDataValue());
                                        }
                                      }

				       Vector perkiraanPayid_value = new Vector(1,1);
				       Vector perkiraanPayid_key = new Vector(1,1);
				       String sel_perkiraanPayid = ""+arApMain.getIdPerkiraan();
				       Vector vMainAccount = new Vector(1,1);
				       if(arapType==PstArApMain.TYPE_AR){
						    vMainAccount = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_PIUTANG);
				       }else{
						    Vector vCurrLiab = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES);
						    Vector vLongLiab = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_LONG_TERM_LIABILITIES);
						    if(vCurrLiab != null && vCurrLiab.size() > 0){
							    vMainAccount = getOppositeAccount(vMainAccount,vCurrLiab);
						    }
						    if(vLongLiab != null && vLongLiab.size() > 0){
							    vMainAccount = getOppositeAccount(vMainAccount,vLongLiab);
						    }
				       }
										 		   
                                       if(vMainAccount!=null&&vMainAccount.size()>0){
											for(int i=0;i<vMainAccount.size();i++){
												Perkiraan perkiraan =(Perkiraan)vMainAccount.get(i);
                                                String padding = "";
                                                for(int j=0;j<perkiraan.getLevel();j++){
                                                    padding = padding + "&nbsp;&nbsp;&nbsp;";
                                                }
												perkiraanPayid_value.add(padding+perkiraan.getNoPerkiraan()+" "+perkiraan.getNama());
												perkiraanPayid_key.add(""+perkiraan.getOID());
											}
									   }
									  %>
                                      <%= ControlCombo.draw(frmArApMain.fieldNames[FrmArApMain.FRM_ID_PERKIRAAN],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %>*                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][4]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="39%" height="25">
                                    <input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_CONTACT_ID]%>_TEXT" readonly style="background-color:#E8E8E8" value="<%=mergeString(contactList.getCompName(),contactList.getPersonName())%>">&nbsp;<a href="javascript:cmdopen()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
					<%if(iErrCode == 2 && arApMain.getContactId() == 0){%><span class="errfont">*)&nbsp;<%=strRequired%></span><%}else{%>*<%}%>                                    </td>									
				    <%if(iCommand == Command.EDIT && arApMain.getIdPerkiraanLawan() == 0){%>
				    <td width="13%" height="25" nowrap>&nbsp;</td>
				    <td width="1%" height="25">&nbsp;</td>
				    <td width="29%" height="25">&nbsp;</td>
				    <%}else{%>
				    <td width="13%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][10]%> </td>
				    <td width="1%" height="25"><b>:</b></td>
				    <td width="29%" height="25">
					<%
					   Vector opAccount = new Vector(1,1);
					   Vector vCash = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_CASH);
					   Vector vBank = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_BANK);
					   Vector vModal = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_EQUITY);
					   Vector vLiabilities = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES);
					   if(vCash != null && vCash.size() > 0){
							opAccount = getOppositeAccount(opAccount, vCash);
					   }
					   if(vBank != null && vBank.size() > 0){
							opAccount = getOppositeAccount(opAccount, vBank);
					   }
					   if(vLiabilities != null && vLiabilities.size() > 0){
							opAccount = getOppositeAccount(opAccount, vLiabilities);
					   }
					   if(vModal != null && vModal.size() > 0){
							opAccount = getOppositeAccount(opAccount, vModal);
					   }
						if(arapType==PstArApMain.TYPE_AR){
							   Vector vRevenue = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_REVENUE);
							   if(vRevenue != null && vRevenue.size() > 0){
									opAccount = getOppositeAccount(opAccount, vRevenue);
							   }
						}else{
							Vector vInventory = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_INVENTORY);
							Vector vExpenses = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_EXPENSE);
							if(vInventory != null && vInventory.size() > 0){
								opAccount = getOppositeAccount(opAccount, vInventory);
						   }
						   if(vExpenses != null && vExpenses.size() > 0){
								opAccount = getOppositeAccount(opAccount, vExpenses);
						   }
						}	   

					  perkiraanPayid_value = new Vector(1,1);
					  perkiraanPayid_key = new Vector(1,1);
					   if(opAccount!=null&&opAccount.size()>0){
							for(int i=0;i<opAccount.size();i++){
								Perkiraan perkiraan =(Perkiraan)opAccount.get(i);
								String padding = "";
								for(int j=0;j<perkiraan.getLevel();j++){
									padding = padding + "&nbsp;&nbsp;&nbsp;";
								}
								perkiraanPayid_value.add(padding+perkiraan.getNoPerkiraan()+" "+perkiraan.getNama());
								perkiraanPayid_key.add(""+perkiraan.getOID());
							}
					   }

					   sel_perkiraanPayid = ""+arApMain.getIdPerkiraanLawan();
					  %>
					  <%= ControlCombo.draw(frmArApMain.fieldNames[FrmArApMain.FRM_ID_PERKIRAAN_LAWAN],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %>*                                    </td>
									<%}%>
                                  </tr>
                                  <tr>
                                    <td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][5]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="39%" height="25">
                                      <%= ControlCombo.draw(frmArApMain.fieldNames[FrmArApMain.FRM_ID_CURRENCY],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value,  "onChange=\"javascript:cmdChangeCurr()\"", "") %>				    </td>
                                    <td width="13%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][11]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="29%" height="25"> 
                                      <textarea cols="40" rows="3" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_DESCRIPTION]%>"><%=arApMain.getDescription()%></textarea>                                    </td>
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
								   <%									
                                    if(list.size()>0  && arApMain.getOID() != 0){
                                    %>
                                 <tr>
                                    <td colspan="6" class="contenttitle"><%=sArapPaymentTerm%></td>
                                  </tr>
								 
                                  <tr>
                                  
                                    <td colspan="6"><%=drawList(SESS_LANGUAGE,list,frmArApMain,arApMain.getArApDocStatus())%></td>
                                    <%
                                    }
                                    else if((iCommand==Command.SAVE && iErrCode == 0) && posted == 0){
                                    %>
					<td width="2%" colspan="6"><%=drawList(SESS_LANGUAGE,arApMain.getNumberOfPayment())%></td>
                                    <%
                                    }
                                    %>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                          <td width="76%" nowrap scope="row">
                                            <%
						ctrLine.setLocationImg(approot+"/images");
						ctrLine.initDefault(SESS_LANGUAGE,"");
						ctrLine.setTableWidth("80%");
						String scomDel = "javascript:cmdAsk('"+oidArApMain+"')";
						String sconDelCom = "javascript:cmdDelete('"+oidArApMain+"')";
						String scancel = "javascript:cmdEdit('"+oidArApMain+"')";
						ctrLine.setCommandStyle("command");
						ctrLine.setColCommStyle("command");
						ctrLine.setBackCaption(strBack);
						ctrLine.setSaveCaption(ctrLine.getSaveCaption()+listTitle[arapType][SESS_LANGUAGE]);
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


						if(iCommand == Command.SAVE && prevCommand == Command.NONE){
							ctrLine.setBackCaption("");	
						}

						if(iCommand == Command.SAVE && menuType==1){
							ctrLine.setBackCaption("");	
						}

						if(privAdd == false  && privUpdate == false){
							ctrLine.setSaveCaption("");
						}

						if (privAdd == false){
							ctrLine.setAddCaption("");
						}

						if(iCommand == Command.ASK)
						{
							ctrLine.setDeleteQuestion(strDelete);
						}
						
						if(arApMain.getArApDocStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){
							ctrLine.setBackCaption(strBack);
							ctrLine.setSaveCaption("");
							ctrLine.setDeleteCaption("");
							ctrLine.setAddCaption("");
						}

						if(iCommand == Command.EDIT){
							if(menuType == 1){
								ctrLine.setBackCaption("");
							}else{
								ctrLine.setBackCaption(strBack);
							}
							ctrLine.setSaveCaption(ctrLine.getSaveCaption());
							ctrLine.setDeleteCaption(strDelete);
						}

						if(iCommand == Command.ADD){
							ctrLine.setCancelCaption("");
						}

						if(iErrCode > 0){
							ctrLine.setAddCommand("javascript:cmdSave()");
							ctrLine.setAddCaption(ctrLine.getSaveCaption());
						}

						if(iCommand == Command.SAVE && iErrCode==0 && posted == 0){
							ctrLine.setAddCommand("javascript:cmdSave()");
							ctrLine.setAddCaption(ctrLine.getSaveCaption());	
						}
					%>
                                            <%
						if(list.size() == 0 ){
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
						}

						if(menuType == 0 && arApMain.getArApDocStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED && iUseJournalDistribution == 0){
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
						}
					%>
                                            <%
						 if(arApMain.getArApDocStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
							 if(list != null && list.size() > 0){
								out.println("<a href=\"javascript:cmdAddDetail('"+oidArApMain+"')\" class=\"command\">"+strAddDetail+"</a>");
								if(true || iUseJournalDistribution == 0){
									out.println("| <a href=\"javascript:cmdPosted()\" class=\"command\">"+strTitle[SESS_LANGUAGE][13]+"</a>");
								}
								if(iCommand == Command.EDIT && (true || iUseJournalDistribution == 0)) {
										out.println("| <a href=\"javascript:cmdDelete('"+oidArApMain+"')\" class=\"command\">"+strDelete+"</a>");
									}
									if(menuType == 0){
										out.println("| <a href=\"javascript:cmdBack()\" class=\"command\">"+strBack+"</a>");
									}
									
								}
						  }
					%></td>
                                        <td width="24%">&nbsp;</td>
                                      </tr>
                                    </table></td>
                                  </tr>
								  
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
				<%if(vListJournalDistribution.size() > 0 && list.size() > 0 && oidArApMain != 0 && arApMain.getArApDocStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED && iUseJournalDistribution == 1){%>
								  <tr>
                                    <td colspan="6" class="contenttitle"><%=strTitleJDistribution[SESS_LANGUAGE][10]%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=sListJDistribution%></td>
                                  </tr>								  
                                  <tr>
                                    <td colspan="6">
										
										<%	
								  if(iCommand == Command.EDIT){
										out.println("| <a href=\"javascript:cmdDelete('"+oidArApMain+"')\" class=\"command\">"+strDelete+"</a>");
										out.println("| <a href=\"javascript:cmdPosted()\" class=\"command\">"+strTitle[SESS_LANGUAGE][13]+"</a>");
																			
									if(menuType == 0){
										out.println("| <a href=\"javascript:cmdBack()\" class=\"command\">"+strBack+"</a>");
									}
									
								}else{
								%>
										<a href="javascript:addNewJDistribution('<%=oidArApMain%>')" class="command"><%=sAddJDistribution%></a>
										<%if((dDebetVal + dKreditVal) > 0){%>
											| <a href="javascript:cmdPosted()" class="command"><%=strTitle[SESS_LANGUAGE][13]%></a>
										<%}%>
										<%}%>
										
									</td>
                                  </tr>
								  <%}else{%>
								  <%if(arApItem.getOID() != 0 && iUseJournalDistribution == 1 ){%>
								  <tr>
                                    <td colspan="6" class="contenttitle"><%=strTitleJDistribution[SESS_LANGUAGE][10]%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=sListJDistribution%></td>
                                  </tr>
								  <%}%>
								  <%	
								  if(iCommand == Command.EDIT && arApMain.getArApDocStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED && iUseJournalDistribution == 1){
									%>
									<tr>
                                    <td colspan="6" class="contenttitle"><%=strTitleJDistribution[SESS_LANGUAGE][10]%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=sListJDistribution%></td>
                                  </tr>
								  <tr>
								  <td><%
									if(menuType == 0){
										out.println("<a href=\"javascript:cmdBack()\" class=\"command\">"+strBack+"</a>");
									}
									
								}
								%>
								</td>
								</tr>
								  <%}%>
                               </table>
                              </td>
                            </tr>
                            <tr>
                              <td width="3%" height="25"></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </form>
            <%}catch(Exception e){}%>
            <script language="javascript">
					cmdChangeCurr();
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
<%}%>
