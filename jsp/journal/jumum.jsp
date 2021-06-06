<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.aiso.session.report.SessGeneralLedger,
                   com.dimata.common.entity.contact.ContactList,
                   com.dimata.common.entity.contact.PstContactList,
                   com.dimata.harisma.entity.masterdata.PstDepartment,
                   com.dimata.harisma.entity.masterdata.Department" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!--import qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>

<!--import common-->
<%@ page import = "com.dimata.common.entity.payment.*" %>

<!--import aiso-->
<%@ page import = "com.dimata.aiso.entity.admin.*" %>
<%@ page import = "com.dimata.aiso.entity.jurnal.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.entity.search.*" %>
<%@ page import = "com.dimata.aiso.form.search.*" %>
<%@ page import = "com.dimata.aiso.form.periode.*" %>
<%@ page import = "com.dimata.aiso.form.jurnal.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.periode.*" %>
<%@ page import = "com.dimata.aiso.session.jurnal.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>

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
}
%>

<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static final int INT_VALID_DELETE = 0;
public static final int INT_INVALID_DELETE = 1;

public static String strTitle[][] =
{
	{
		"No Voucher",//0
		"Tanggal Transaksi",//1
		"Tanggal Input",//2
		"Transaksi Dalam",//3
		"Keterangan Jurnal",//4
		"Dok Referensi",//5
		"Nama Operator",//6
		"No Perkiraan",//7
		"Nama Perkiraan",//8
		"Debet",//9
		"Kredit",//10
		"Daftar Jurnal Detail",//11
		"Tipe Pembukuan",//12
        "Bobot",//13
        "TOTAL",//14
        "Kontak",//15
		"Departemen",//16
        "Silakan tambah detail.",//17
		"Disetujui Oleh", //18
		"Dibuat Oleh"// 19
	},
	{
		"Voucher No",//0
		"Trans Date",//1
		"Entry Date",//2
		"Currency",//3
		"Description",//4
		"Doc Ref",//5
		"User",//6
		"Account Code",//7
		"Account Name",//8
		"Debit",//9
		"Credit",//10
		"List Detail's Journal",//11
		"Book Type",//12
        "Weight",//13
        "TOTAL",//14
        "Contact",//15
		"Department",//16
        "Please add detail first",//17
		"Approved By", //18
		"Prepared By"//19
	}
};

public static final String masterTitle[] = {
	"Transaksi","Transaction"
};

public static final String listTitle[] = {
	"Jurnal Umum","General Journal"
};

/**
* this method used to list jurnal detail
*/
public Vector listJurnalDetail(int language,FrmJurnalDetail frmjurnaldetail, Vector listjurnaldetail, Vector listCode, Vector listCurrencyType, boolean fromGL){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitle[language][7],"15%","","left");
	ctrlist.dataFormat(strTitle[language][8],"65%","","left");
	ctrlist.dataFormat(strTitle[language][9],"10%","","right");
	ctrlist.dataFormat(strTitle[language][10],"10%","","right");
	ctrlist.setLinkRow(1);
	ctrlist.reset();

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	Vector dataPrint = new Vector(1,1);	
	Vector rowx = new Vector();
	Vector rowr = new Vector();
	Vector vResult = new Vector(1,1);
	//String attr = "onChange=\"javascript:cmdChangeAccount()\"";
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
	if(listCurrencyType!=null && listCurrencyType.size()>0){
		int maxCurr = listCurrencyType.size();
		for(int it=0; it<maxCurr; it++){
			CurrencyType currencyType =(CurrencyType)listCurrencyType.get(it);
			hashCurrency.put(""+currencyType.getOID(),currencyType.getName()+"("+currencyType.getCode()+")");
		}
	}

	for(int it = 0; it<listjurnaldetail.size();it++){
		 JurnalDetail jdetail = (JurnalDetail)listjurnaldetail.get(it);
    	 rowx = new Vector();

		 // if jd.datastatus!=DELETE ---> don't display it, otherwise ---> display it
		 if(jdetail.getDataStatus()!=PstJurnalDetail.DATASTATUS_DELETE){
			 Vector listAccount = PstPerkiraan.findFieldPerkiraan(jdetail.getIdPerkiraan());
		     String namaAcc = "";
             String nomor = "";
			 int groupPerkiraan = 1;
		     //boolean postableAcc = false;
			 if(listAccount!=null && listAccount.size()>0){
				Perkiraan account = (Perkiraan)listAccount.get(0);
				namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
				//postableAcc = account.getPostable();
				groupPerkiraan = account.getAccountGroup();
                 nomor = account.getNoPerkiraan();
			 }
			 strSelect = ""+ jdetail.getIdPerkiraan();


             if(fromGL){
                 rowx.add("<a href=\"javascript:cmdClickAccountJu('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">" + nomor + "</a>");
             }else{
			    rowx.add("<a href=\"javascript:cmdClickAccountJu('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">" + nomor + "</a>");
             }
             rowx.add(namaAcc);
			 rowx.add(frmjurnaldetail.userFormatStringDecimal(jdetail.getDebet()));
			 rowx.add(frmjurnaldetail.userFormatStringDecimal(jdetail.getKredit()));
			 
			 rowr = new Vector(1,1);
			 rowr.add(nomor);
			 rowr.add(namaAcc);
			 rowr.add(""+jdetail.getDebet());
			 rowr.add(""+jdetail.getKredit());
			 	
			 lstData.add(rowx);
			 dataPrint.add(rowr);	
             if(jdetail.getDetailLinks().size()>0){
                 double totalWeight = jdetail.getWeight();
                 double totalDebet = jdetail.getDebet();
                 double totalKredit = jdetail.getKredit();
                 int size = jdetail.getDetailLinks().size();
                 for(int i=0;i<size;i++){
                     JurnalDetail dLink = jdetail.getDetailLink(i);

                     Perkiraan account = new Perkiraan();
                     try{
                        account = PstPerkiraan.fetchExc(dLink.getIdPerkiraan());
                     }
                     catch(Exception e){
                        account = new Perkiraan();
                     }

                     namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
                     totalWeight = totalWeight + dLink.getWeight();
                     totalDebet = totalDebet + dLink.getDebet();
                     totalKredit = totalKredit + dLink.getKredit();

                     rowx = new Vector();
                     rowx.add("");
                     rowx.add(namaAcc);
                     rowx.add(frmjurnaldetail.userFormatStringDecimal(dLink.getDebet()));
                     rowx.add(frmjurnaldetail.userFormatStringDecimal(dLink.getKredit()));

                     lstData.add(rowx);
                 }
             }
		 }
	 }	
	 vResult.add(ctrlist.drawMe());
	 vResult.add(dataPrint);
	 return vResult;
}

/**
* this method used to list jurnal detail with weight
*/
public String listJurnalDetailWithWeight(int language,FrmJurnalDetail frmjurnaldetail, Vector listjurnaldetail, Vector listCode, Vector listCurrencyType){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitle[language][7],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][8],"60%","center","left");
    ctrlist.dataFormat(strTitle[language][13],"5%","center","left");
	ctrlist.dataFormat(strTitle[language][9],"10%","center","right");
	ctrlist.dataFormat(strTitle[language][10],"10%","center","right");
	ctrlist.setLinkRow(1);
	ctrlist.reset();

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector();
	//String attr = "onChange=\"javascript:cmdChangeAccount()\"";
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
			 Vector listAccount = PstPerkiraan.findFieldPerkiraan(jdetail.getIdPerkiraan());
		     String namaAcc = "";
             String nomor = "";
			 int groupPerkiraan = 1;
		     //boolean postableAcc = false;
			 if(listAccount!=null && listAccount.size()>0){
				Perkiraan account = (Perkiraan)listAccount.get(0);
				namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
				//postableAcc = account.getPostable();
				groupPerkiraan = account.getAccountGroup();
                nomor = account.getNoPerkiraan();
			 }
			 strSelect = ""+ jdetail.getIdPerkiraan();
             rowx.add("<a href=\"javascript:parent.frames[0].cmdClickAccountJu('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">" + nomor + "</a>");
			 rowx.add(namaAcc);
             rowx.add(frmjurnaldetail.userFormatStringDecimal(jdetail.getWeight()));
			 rowx.add(frmjurnaldetail.userFormatStringDecimal(jdetail.getDebet()));
			 rowx.add(frmjurnaldetail.userFormatStringDecimal(jdetail.getKredit()));

             lstData.add(rowx);

             if(jdetail.getDetailLinks().size()>0){
                 double totalWeight = jdetail.getWeight();
                 double totalDebet = jdetail.getDebet();
                 double totalKredit = jdetail.getKredit();
                 int size = jdetail.getDetailLinks().size();
                 for(int i=0;i<size;i++){
                     JurnalDetail dLink = jdetail.getDetailLink(i);

                     Perkiraan account = new Perkiraan();
                     try{
                        account = PstPerkiraan.fetchExc(dLink.getIdPerkiraan());
                     }
                     catch(Exception e){
                        account = new Perkiraan();
                     }

                     namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
                     totalWeight = totalWeight + dLink.getWeight();
                     totalDebet = totalDebet + dLink.getDebet();
                     totalKredit = totalKredit + dLink.getKredit();

                     rowx = new Vector();
                     rowx.add("");
                     rowx.add(namaAcc);
                     rowx.add(frmjurnaldetail.userFormatStringDecimal(dLink.getWeight()));
                     rowx.add(frmjurnaldetail.userFormatStringDecimal(dLink.getDebet()));
                     rowx.add(frmjurnaldetail.userFormatStringDecimal(dLink.getKredit()));

                     lstData.add(rowx);
                 }
             }
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
// get request from hidden text
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE JOURNAL PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES JURNAL SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int iEditJournal = FRMQueryString.requestInt(request, "edit_journal");
int addType = FRMQueryString.requestInt(request,"add_type");
long journalID = FRMQueryString.requestLong(request,"journal_id");
int accountGroup = FRMQueryString.requestInt(request,"account_group");
if(accountGroup == 0) accountGroup = PstPerkiraan.ACC_GROUP_LIQUID_ASSETS;
int index = FRMQueryString.requestInt(request,"index");
int isValidDelete = FRMQueryString.requestInt(request,"is_valid_delete");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long detailID = FRMQueryString.requestLong(request,"detail_id");
long idAccount = FRMQueryString.requestLong(request,"perkiraan");
long getTimeMenu = FRMQueryString.requestLong(request,"get_time_menu");
long getTimeMenuLocal = FRMQueryString.requestLong(request,"get_time_menu_local");



/**
 * from GL
 */
boolean fromGL = FRMQueryString.requestBoolean(request,"fromGL");
long accountId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERKIRAAN);
long periodId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERIODE);
String numberP = FRMQueryString.requestString(request,"ACCOUNT_NUMBER");
String namaP = FRMQueryString.requestString(request,"ACCOUNT_TITLES");
Date startDate = FRMQueryString.requestDate(request,"START_DATE_GL");
Date endDate = FRMQueryString.requestDate(request,"END_DATE_GL");

//System.out.println("accountId="+accountId+" periodId="+periodId+" oidDepartment="+oidDepartment+ " startDate="+startDate+" endDate="+endDate);

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Journal" : "Tambah Baru Jurnal";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : "Tambah Baru Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Journal List" : "Kembali Ke Daftar Jurnal";
if(fromGL){
    strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To General Ledger" : "Kembali Ke Buku Besar";
}
String strPrintJurnal = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Print Journal" : "Cetak Journal";
String strPosted = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Posted Journal" : "Posted Jurnal";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Journal" : "Hapus Jurnal";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Journal" : "Ya Hapus Jurnal";

long periodeOID = PstPeriode.getCurrPeriodId();
String msgErr = "";

// get masterdata currency
String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);


Vector vectTitle = new Vector(1,1);
for(int i = 0; i < strTitle[SESS_LANGUAGE].length; i++){
	vectTitle.add(strTitle[SESS_LANGUAGE][i]);
}



/** handle searching parameter in session */
SrcJurnalUmum srcJurnalUmum = new SrcJurnalUmum();
if(iCommand==Command.ADD){
    session.removeValue(SessJurnal.SESS_JURNAL_MAIN);
    journalID = 0;
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

System.out.println("jurnalumum.getOID() :::: "+jurnalumum.getOID());
if(iCommand == Command.NONE){
	session.removeValue(SessJurnal.SESS_JURNAL_MAIN);
}

String contactName = "";
/** Saving object jurnalumum into session */
if((iCommand==Command.EDIT)||(iCommand==Command.POST&&ctrlErr==ctrlJurnalUmum.RSLT_OK)){
    if(iCommand==Command.EDIT){
        // untuk menghilangkan session jurnal umum
        session.removeValue(SessJurnal.SESS_JURNAL_MAIN);
    }
	jurnalumum.setVoucherNo(PstPeriode.getStrVoucherEdit(jurnalumum.getVoucherNo()));
	session.putValue(SessJurnal.SESS_JURNAL_MAIN,jurnalumum);
}

/** Set initial value for object jUmum that will handle object from session */
JurnalUmum jUmum = jurnalumum;
if(iCommand!=Command.ADD){
	if(session.getValue(SessJurnal.SESS_JURNAL_MAIN)!=null){
	    jUmum = (JurnalUmum)session.getValue(SessJurnal.SESS_JURNAL_MAIN);
	}
}
boolean periodClosed = PstPeriode.isPeriodClosed(jUmum.getPeriodeId());

if(session.getValue("CHECK_MENU") != null){
	session.removeValue("CHECK_MENU");
 }

if(iCommand != Command.SAVE){
    iCheckMenu = 1;
    
    session.putValue("CHECK_MENU", String.valueOf(iCheckMenu));
}

System.out.println("iCheckMenu :::::::::: "+iCheckMenu);
/** if Command.POST and no error occur, redirect to journal detail page */
if((iCommand==Command.POST)&&(ctrlErr==ctrlJurnalUmum.RSLT_OK)){
%>
	<jsp:forward page="jdetail.jsp">
	<jsp:param name="command" value="<%=Command.ADD%>"/>
	<jsp:param name="edit_journal" value="<%=iEditJournal%>" />
	</jsp:forward>
<%
}else{
    // for get contact name
    try{
        //System.out.println("contact id : "+jUmum.getContactOid());
        ContactList contactList = PstContactList.fetchExc(jUmum.getContactOid());
        contactName = contactList.getCompName();
        if(contactName.length()==0)
            contactName = contactList.getPersonName()+" "+contactList.getPersonLastname();
        //System.out.println("contactList.getCompName() : "+contactList.getCompName());

    }catch(Exception e){}
}

/** if Command.DELETE, delete journal and its descendant and redirect to journal detail page */
if(iCommand==Command.DELETE){
    ctrlJurnalUmum.journalDelete(journalID);
%>
	<jsp:forward page="jlist.jsp">
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
	 session.putValue(SessJurnal.SESS_JURNAL_MAIN,jUmum);
     if(!fromGL){
         // untuk menghilangkan session jurnal umum
         session.removeValue(SessJurnal.SESS_JURNAL_MAIN);
         %>
         <jsp:forward page="jumum.jsp">
         <jsp:param name="start" value="<%=start%>"/>
         <jsp:param name="command" value="<%=Command.ADD%>"/>
         </jsp:forward>
         <%

     }
}

/** check if details already exist or not yet */
double amountDt = 0;
double amountCr = 0;


// menyatakan apakah jurnal detail sudah 2 buah ???
int iMaxDetailAmount = 100;
boolean bDetailAlreadyMaximum = false;

boolean boolDetail = false;
boolean balance = false;
String msgBalance = "";
if(!jUmum.getJurnalDetails().isEmpty()){
	Vector vectListJd = jUmum.getJurnalDetails();
	amountDt = SessJurnal.getBalanceSide(vectListJd,PstJurnalDetail.SIDE_DEBET);
	amountCr = SessJurnal.getBalanceSide(vectListJd,PstJurnalDetail.SIDE_CREDIT);    
	if(vectListJd.size() == iMaxDetailAmount){
		bDetailAlreadyMaximum = true;
	}

	boolDetail = true;
	if(SessJurnal.checkBalance(vectListJd)){
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

// get user department from data custom
Vector vDepartmentOid = new Vector(1,1);
Vector vUsrCustomDepartment = PstDataCustom.getDataCustom(userOID, "hrdepartment");
if(vUsrCustomDepartment!=null && vUsrCustomDepartment.size()>0){
	int iDataCustomCount = vUsrCustomDepartment.size();
	for(int i=0; i<iDataCustomCount; i++){
		DataCustom objDataCustom = (DataCustom) vUsrCustomDepartment.get(i);
		vDepartmentOid.add(objDataCustom.getDataValue());
	}
}
//Vector listCode = AppValue.getAppValueVector(accountGroup);
//Vector listAllCode = AppValue.getAppValueVector(PstPerkiraan.ACC_GROUP_ALL);
Vector listCode = AppValue.getAppValueVector(vDepartmentOid,accountGroup);
Vector listAllCode = AppValue.getAppValueVector(vDepartmentOid, PstPerkiraan.ACC_GROUP_ALL);

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
Vector vJournal = (Vector)listJurnalDetail(SESS_LANGUAGE,frmjurnaldetail,listjurnaldetail,listCode,listCurrencyType,fromGL);
String sDetail = "";
Vector vDetailPrint = new Vector(1,1);
if(vJournal != null && vJournal.size() > 0){
	sDetail = vJournal.get(0).toString();
	vDetailPrint = (Vector)vJournal.get(1);
}
//jurnalumum()
String bookType = "";
String stUserName = "";
String stDep = "";
String strCurr = "";
String strContact = "";
CurrencyType objBookType = new CurrencyType();
AppUser objUser = new AppUser();
Department objDept = new Department();
CurrencyType objCurrType = new CurrencyType();
ContactList objContact = new ContactList();
try{
	if(accountingBookType != 0){
		objBookType = PstCurrencyType.fetchExc(accountingBookType);
		bookType = objBookType.getName();
	}
}catch(Exception e){
	System.out.println("Exception on fetchobjBookType :::: "+e.toString());
}

try{
	if(jurnalumum.getUserId() != 0){
		objUser = PstAppUser.fetch(jurnalumum.getUserId());
		stUserName = objUser.getLoginId();
	}
}catch(Exception e){
	System.out.println("Exception on fetchobjUser :::: "+e.toString());
}

try{
	if(jurnalumum.getDepartmentOid() != 0){
		objDept = PstDepartment.fetchExc(jurnalumum.getDepartmentOid());
		stDep = objDept.getDepartment();
	} 
}catch(Exception e){
	System.out.println("Exception on fetchobjDept :::: "+e.toString());
}

try{
	if(jurnalumum.getCurrType() != 0){
		objCurrType = PstCurrencyType.fetchExc(jurnalumum.getCurrType());
		strCurr = objCurrType.getName();
	}
}catch(Exception e){
	System.out.println("Exception on fetchobjCurrType :::: "+e.toString());
}

try{
	if(jurnalumum.getContactOid() != 0){
		objContact = PstContactList.fetchExc(jurnalumum.getContactOid());
		strContact = objContact.getCompName();
	}
}catch(Exception e){
	System.out.println("Exception on fetchobjContact :::: "+e.toString());
}

Vector vMainPrint = new Vector(1,1);
vMainPrint.add(bookType);// index 0
vMainPrint.add(jurnalumum.getSJurnalNumber());// index 1
vMainPrint.add(Formater.formatDate(jurnalumum.getTglEntry(), "MMM dd, yyyy"));// index 2
vMainPrint.add(stUserName);// index 3
vMainPrint.add(stDep);// index 4
vMainPrint.add(jurnalumum.getReferenceDoc());// index 5
vMainPrint.add(strCurr);// index 6
vMainPrint.add(Formater.formatDate(jurnalumum.getTglTransaksi(), "MMM dd, yyyy"));// index 7
vMainPrint.add(strContact);// index 8
vMainPrint.add(jurnalumum.getKeterangan());// index 9

Vector vectJournal = new Vector(1,1);
vectJournal.add(vectTitle);// index 0
vectJournal.add(listTitle[SESS_LANGUAGE]); // index 1
vectJournal.add(""+SESS_LANGUAGE);// index 2
vectJournal.add(vDetailPrint);// index 3
vectJournal.add(vMainPrint);// index 4

if(session.getValue("JOURNAL") != null){
	session.removeValue("JOURNAL");
}
 session.putValue("JOURNAL", vectJournal);

if(fromGL){
%>
<%@ include file = "jaccountgl.jsp" %>
<%}%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script type="text/javascript" src="../main/digitseparator.js"></script>
<script language="javascript">
<%if((privView)&&(privAdd)&&(privSubmit)){%>
<%if(isUseDatePicker.equalsIgnoreCase("Y")){%>
function getThn()
{
	var date1 = ""+document.frmjournal.<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI]%>.value;
	
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.frmjournal.<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI] + "_mn"%>.value=bln;
	document.frmjournal.<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI] + "_dy"%>.value=hri;
	document.frmjournal.<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI] + "_yr"%>.value=thn;		
				
}
<%}%>

function cmdClickAccountJu(accGroup,detailId,idAccount,index)
{
    var prev = document.frmjournal.command.value;
	document.frmjournal.detail_id.value=detailId;
	document.frmjournal.account_group.value=accGroup;
	document.frmjournal.perkiraan.value=idAccount;
	document.frmjournal.edit_journal.value="<%=iEditJournal%>";
	document.frmjournal.index.value=index;
	document.frmjournal.command.value="<%=Command.EDIT%>";
	document.frmjournal.prev_command.value=prev;
	document.frmjournal.target="_self";
	document.frmjournal.action="jdetail.jsp";
	document.frmjournal.submit();
}

function getText(elemet,bool,maxValue,strMassage){
	parserNumber(elemet,bool,maxValue,strMassage);
}
function addNewDetail(){
    var prev = document.frmjournal.command.value;
	document.frmjournal.perkiraan.value=0;
	document.frmjournal.account_group.value=0;
	document.frmjournal.index.value=-1;
	document.frmjournal.command.value="<%=Command.ADD%>";
	document.frmjournal.prev_command.value=prev;
	document.frmjournal.target="_self";
	document.frmjournal.action="jdetail.jsp";
	document.frmjournal.submit();
}

function addNew(){
    var prev = document.frmjournal.command.value;
	document.frmjournal.journal_id.value="0";
	document.frmjournal.command.value="<%=Command.ADD%>";
    document.frmjournal.prev_command.value=prev;
	document.frmjournal.target="_self";
	document.frmjournal.action="jdetail.jsp";
	document.frmjournal.submit();
}

function cmdCancel(){
	document.frmjournal.command.value="<%=Command.NONE %>";
	document.frmjournal.target="_self";
	document.frmjournal.action="jumum.jsp";
	document.frmjournal.submit();
}

function cmdSave(){
	document.frmjournal.command.value="<%=Command.SAVE%>";
	document.frmjournal.target="_self";
	document.frmjournal.action="jumum.jsp";
    <%
        if(!jUmum.getDeptView()){
    %>
	document.frmjournal.submit();
    <%
        }
        else{
    %>
        alert('<%=strTitle[SESS_LANGUAGE][17]%>');
    <%
        }
    %>
}

function cmdAsk(){
	document.frmjournal.command.value="<%=Command.ASK%>";
	document.frmjournal.target="_self";
	document.frmjournal.action="jumum.jsp";
	document.frmjournal.submit();
}

function cmdDelete(oid){
	document.frmjournal.journal_id.value=oid;
	document.frmjournal.command.value="<%=Command.DELETE%>";
	document.frmjournal.target="_self";
	document.frmjournal.action="jumum.jsp";
	document.frmjournal.submit();
}

function cmdItemData(){
	document.frmjournal.index.value=-1;
	document.frmjournal.command.value="<%=Command.LIST%>";
	document.frmjournal.target="_self";
	document.frmjournal.action="jdetail.jsp";
	document.frmjournal.submit();
}

function cmdAddDetail(){
	document.frmjournal.command.value="<%=Command.POST%>";
	document.frmjournal.target="_self";
	document.frmjournal.action="jumum.jsp";
	document.frmjournal.submit();
}

function cmdopen(){
	var url = "";
	var idContact = Math.abs(document.frmjournal.<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_CONTACT_ID]%>.value);
	if(idContact == 0){
		url = "donor_list.jsp?command=<%=Command.LIST%>&"+
			"<%=FrmSrcContactList.fieldNames[FrmSrcContactList.FRM_FIELD_NAME] %>="+document.frmjournal.<%=frmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_CONTACT_ID]%>_TEXT.value;
	}else{
		url = "donor_list.jsp?command=<%=Command.LIST%>";
	}
	window.open(url,"src_cnt_jumum","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function entContact(){
	if(event.keyCode == 13)
		cmdopen();
}
function entRef(){
	if(event.keyCode == 13)
		document.frmjournal.<%=frmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_CONTACT_ID]%>_TEXT.focus();
}
function entDesc(){
	if(event.keyCode == 13)
		addNewDetail();
}
 <%}%>

function cmdBack(){
<%if(fromGL){%>
    document.frmjournal.command.value="<%=Command.LIST%>";
	document.frmjournal.action="../report/general_ledger_dept.jsp";
<%}else{%>
	document.frmjournal.command.value="<%=Command.BACK%>";
	document.frmjournal.start.value="<%=start%>";
    document.frmjournal.target="_self";
	document.frmjournal.action="jlist.jsp";
<%}%>
	document.frmjournal.submit();
}
function hideObjectForDate(){
  }
	
  function showObjectForDate(){
  }	
function printJournal(){
		var linkPage = "<%=reportroot%>report.jurnal.JurnalPrintPdf";
		window.open(linkPage);
}

</script>

<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->

<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="stylesheet" href="../style/calendar.css" type="text/css">
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
		    <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmjournal" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
	      <input type="hidden" name="edit_journal" value="<%=iEditJournal%>">
              <input type="hidden" name="journal_id" value="<%=journalID%>">
              <input type="hidden" name="list_command" value="<%=Command.LIST%>">
              <input type="hidden" name="index" value="<%=index%>">
              <input type="hidden" name="add_type" value="<%=addType%>">
              <input type="hidden" name="detail_id" value="<%=detailID%>">
              <input type="hidden" name="perkiraan" value="<%=idAccount%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="is_valid_delete" value="<%=isValidDelete%>">
	          <input type="hidden" name="account_group" value="<%=accountGroup%>">
              <input type="hidden" name="<%=frmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_CONTACT_ID]%>" value="<%=jurnalumum.getContactOid()%>">
              <input type="hidden" name="fromGL" value="<%=fromGL%>">
              <input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>" value="<%=accountId%>">
              <input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERIODE%>" value="<%=periodId%>">
              <%
                  if(!jUmum.getDeptView()){
              %>
              <input type="hidden" name="<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_DEPARTMENT_ID]%>" value="<%=jUmum.getDepartmentOid()%>">
              <%
                  }
              %>
              <input type="hidden" name="ACCOUNT_NUMBER" value="<%=numberP%>">
              <input type="hidden" name="ACCOUNT_TITLES" value="<%=namaP%>">
              <input type="hidden" name="START_DATE_GL_yr" value="<%=(startDate.getYear()+1900)%>">
              <input type="hidden" name="START_DATE_GL_mn" value="<%=(startDate.getMonth()+1)%>">
              <input type="hidden" name="START_DATE_GL_dy" value="<%=startDate.getDate()%>">
              <input type="hidden" name="END_DATE_GL_yr" value="<%=(endDate.getYear()+1900)%>">
              <input type="hidden" name="END_DATE_GL_mn" value="<%=(endDate.getMonth()+1)%>">
              <input type="hidden" name="END_DATE_GL_dy" value="<%=endDate.getDate()%>">
			  <input type="hidden" name="get_time_menu_local" value="<%=getTimeMenuLocal%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%" class="tabtitleactive" valign="top">
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
						  	<tr><td></td></tr>
                            <tr>
                              <td width="94%"><div align="center">
							  	<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
									<tr>
										<td>
											<table width="100%" class="list">
									<tr>
										<td><div align="center">
											<table width="99%" border="0" cellpadding="1" cellspacing="0" bgcolor="#D6EEFA">
												<tr>
													<td>
													  <table width="100%" class="mainJournalOut">
								<tr>
                                    <td width="11%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][12]%></b></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25">
									<input type="hidden" name="<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_BOOK_TYPE]%>" value="<%=""+accountingBookType%>" size="35">
									<%
									String sBookType = "";
									try{
										CurrencyType objCurrencyType = PstCurrencyType.fetchExc(accountingBookType);
										sBookType = objCurrencyType.getName();
									}catch(Exception e){
										System.out.println("Exc when fetch book type from currtype : " + e.toString());
									}
									out.println(sBookType);
									%>
									</td>
                                    <td width="13%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][5]%></b></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                      <input type="text" name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_REFERENCE_DOC]%>" value="<%=jUmum.getReferenceDoc()%>" size="18" onKeyDown="javascript:entRef()">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="11%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][0]%></b></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25">
                                      <%
									String strVoucherNumber = "-";
									if(jUmum.getVoucherNo()!=null && jUmum.getVoucherNo().length()>0)
									{
										//strVoucherNumber = jUmum.getVoucherNo()+"-"+SessJurnal.intToStr(jUmum.getVoucherCounter(),4);
										strVoucherNumber = jUmum.getSJurnalNumber();
									}
									out.println(strVoucherNumber);
									%>
                                    </td>
                                    <td width="13%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][3]%></b></td>
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
                                      <%= ControlCombo.draw(frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_CURR_TYPE],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value, "", "") %>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][2]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25"><%
									   String strDt = "";
									   try{
									   if(iCommand==Command.EDIT || iCommand==Command.NONE)
											strDt = Formater.formatDate(jUmum.getTglEntry(),"MMMM dd,  yyyy");
									   else
											strDt = Formater.formatDate(new Date(),"MMMM dd,  yyyy");
									   }catch(Exception exc){
									   }
									   out.println(strDt);
									  %>
									  </td>
                                    <td height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][1]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
									 <%if(isUseDatePicker.equalsIgnoreCase("Y")){%>										   										   
										  <input onClick="ds_sh(this);" name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((jUmum.getTglTransaksi() == null) ? new Date() : jUmum.getTglTransaksi(), "dd-MM-yyyy")%>"/> 						  
										  <input type="hidden" name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI] + "_mn"%>">
										  <input type="hidden" name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI] + "_dy"%>">
										  <input type="hidden" name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI] + "_yr"%>">
										  <script language="JavaScript" type="text/JavaScript">getThn();</script>
										  <%}%>
									<%/*
									Date dtTransactionDate = jUmum.getTglTransaksi();
									if(dtTransactionDate ==null)
									{
                                        dtTransactionDate = new Date();
									}
									out.println(ControlDate.drawDate(frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI], dtTransactionDate, 0, -2));
									*/%></td>
                                  </tr>
                                  <tr>
                                    <td width="11%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][6]%></b></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25"><%
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
                                    <td width="13%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][15]%></b></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><input type="text" name="<%=frmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_CONTACT_ID]%>_TEXT" value="<%=contactName%>" size="25" onKeyDown="javascript:entContact()">
                                      <a href="javascript:cmdopen()"><img alt="Open List Contact" border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
									</td>
                                  </tr>
                                  <tr>
                                    <td width="11%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][16]%></b></td>
                                    <td width="3%" height="25"><strong>:</strong></td>
                                    <td width="43%" height="25"><%
									Department department = new Department();
                                     if(jUmum.getDeptView()){
                                        Vector vectDeptKey = new Vector();
                                         Vector vectDeptName = new Vector();
                                         int iDeptSize = vDepartmentOid.size();
										
                                         for (int deptNum = 0; deptNum < iDeptSize; deptNum++){
                                             Department dept = new Department();
                                             try{
                                                 dept = PstDepartment.fetchExc(Long.parseLong((String)vDepartmentOid.get(deptNum)));
                                             }catch(Exception e){}
                                             vectDeptKey.add(String.valueOf(dept.getOID()));
                                             vectDeptName.add(dept.getDepartment());
                                         }
                                         String strSelectedDept = String.valueOf(jUmum.getDepartmentOid());
                                    %>
                                    <%=ControlCombo.draw(FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_DEPARTMENT_ID], "", null, strSelectedDept, vectDeptKey, vectDeptName)%>
                                    <%}else{
                                        try{
                                            department = PstDepartment.fetchExc(jUmum.getDepartmentOid());
                                            out.println(department.getDepartment());
                                        }catch(Exception e){}
                                     }
                                    %>
                                    </td>
                                    <td width="13%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][4]%></b></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td rowspan="2" height="52">
                                      <textarea name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_KETERANGAN] %>" cols="30" rows="2"><%=jUmum.getKeterangan()%></textarea>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="4" height="25" valign="bottom"></td>
                                    <td height="25" width="3%">&nbsp;</td>
                                  </tr><!-- end row journal main -->
								  </table>
													</td>
												</tr>
											</table>
										</div></td>
								  </tr>
                                  <tr>
                                    <td colspan="6">
									<%if(journalID > 0){%>
									&nbsp;<i><u><%=strTitle[SESS_LANGUAGE][11]%></u></i></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">
                                      <%
                                         
                                                //out.println(listJurnalDetail(SESS_LANGUAGE,frmjurnaldetail,listjurnaldetail,listCode,listCurrencyType,fromGL));
                                          out.println(sDetail);
										  if(amountDt>0 || amountCr>0){
                                                out.println(drawListTotal(frmjurnaldetail,msgBalance,amountDt,amountCr));
									}
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
                                    <td colspan="6" class="command"><table width="100%"  border="0">
                                      <tr>
                                        <td width="83%"><%
									  if((!periodClosed) && (privView) && (privAdd) && (privSubmit)){ // index 1
										  if( (balance && boolDetail && iCommand==Command.NONE) || (iCommand==Command.EDIT)){ //index 2
										  	  String sCommandAddSaveAskBack = "";
										  	  if(!bDetailAlreadyMaximum){ // index 2.1%> 			
													<input alt="Add Detail" type="button" name="add4" value="<%=strAddDetail%>" onClick="javascript:addNewDetail()">
													<input type="button" name="posted" value="<%=strPosted%>" onClick="javascript:cmdSave()">
									  		 <% }else{ // else index 2.1%>
											  		<input type="button" name="posted" value="<%=strPosted%>" onClick="javascript:cmdSave()">
											  <%}// End index 2.1

											  if(journalID!=0){// Index 2.2 %>
											  		<input type="button" name="delete" value="<%=strDelete%>" onClick="javascript:cmdAsk()">
											  		<input type="button" name="print" value="<%=strPrintJurnal%>" onClick="javascript:printJournal()">																								  		
											  <%} // End index 2.2											  
										  }else{ // Else index 2
									      	  if(iCommand==Command.ADD || ctrlErr!=0 || iCommand==Command.NONE || (iCommand==Command.BACK)){ // index 2.3												 
												  if(boolDetail && (!bDetailAlreadyMaximum)){ // index 2.3.1 %>
												  		<input alt="Add Detail Journal" type="button" name="add3" value="<%=strAddDetail%>" onClick="javascript:addNewDetail()">
									  			 <%}else{ // Else index 2.3.1 %>				
												  		<input alt="Add Detail Journal" type="button" name="add1" value="<%=strAddDetail%>" onClick="javascript:cmdAddDetail()">
									  		 	  <%} // End index 2.3.1												  
									  	  	  }//End index 2.3

									  		  if((iCommand==Command.SAVE && ctrlErr==0) || iCommand==Command.LIST){ // index 2.4%>
											  		<input alt="Add Detail Journal" type="button" name="add2" value="<%=strAdd%>" onClick="javascript:addNew()">													
									  		  <%} // End index 2.4
											  
									  		  if(iCommand==Command.ASK){ // Index 2.5
											  	//if(isValidDelete==INT_VALID_DELETE){ Index 2.5.1													
											  		%>
													<input name="askDelete" type="button" onClick="javascript:cmdDelete('<%=journalID%>')" value="<%=strYesDelete%>">										  		
									  		  	<%//}else{ /Else index 2.5.1%>
											  		<input type="button" name="askCancel" value="<%=strCancel%>" onClick="javascript:cmdCancel()">
											  	<%//}/End index 2.5.1
												}//End index 2.5
									  	   	}//End index 2									  
									  %></td>
                                        <td width="17%"><b>
										  <%if( (balance && boolDetail && iCommand==Command.NONE) || (iCommand==Command.EDIT) )
										  { // Index 3
										  	  String sCommandAddSaveAskBack = "";
											  sCommandAddSaveAskBack = sCommandAddSaveAskBack + " <a href=\"javascript:cmdBack()\">"+strBack+"</a>";
											  out.println(sCommandAddSaveAskBack);
										  }else{ // Else index 3
									      	  if(iCommand==Command.ADD || ctrlErr!=0 || iCommand==Command.NONE){ // Index 3.1
											  	  String sCommandAddBack = "";	
												  //sCommandAddBack = sCommandAddBack + " <a href=\"javascript:cmdBack()\">"+strBack+"</a>";
												  out.println(sCommandAddBack);
									  	  	  } // End index 3.1

									  		  if((iCommand==Command.SAVE && ctrlErr==0) || iCommand==Command.LIST){ //Index 3.2
													String sCommandAddBack = "";
													//sCommandAddBack = sCommandAddBack + " | <a href=\"javascript:cmdBack()\">"+strBack+"</a>";
													out.println(sCommandAddBack);
									  		  }//End index 3.2									  		  
									  	   }//End index 3
									  }else{//Else index 1
											String sCommandBack = "<a href=\"javascript:cmdBack()\">"+strBack+"</a>";
											out.println(sCommandBack);
									  }// End index 1
									  %></b></td>
                                      </tr>
                                    </table></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6" class="command">&nbsp 
                                    </td>
                                  </tr>
                                </table>
										</td>
									</tr>
								</table>
							  </div></td>
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
            <%
			  if(iCommand==Command.SAVE && fromGL){
			  %>
              <script language="javascript">
			  		cmdBack();
			  </script>
              <%}%>
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
