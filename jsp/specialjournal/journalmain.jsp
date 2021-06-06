<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.common.entity.contact.ContactList,
                   com.dimata.common.entity.contact.PstContactList" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import="com.dimata.common.entity.payment.PstCurrencyType"%>
<%@ page import="com.dimata.aiso.form.specialJournal.CtrlSpecialJournalMain"%>
<%@ page import="com.dimata.aiso.session.specialJournal.SessSpecialJurnal"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.SpecialJournalMain"%>
<%@ page import="com.dimata.aiso.form.specialJournal.FrmSpecialJournalMain"%>
<%@ page import="com.dimata.common.entity.payment.PstStandartRate"%>
<%@ page import="com.dimata.common.entity.payment.StandartRate"%>
<%@ page import="com.dimata.aiso.entity.masterdata.PstAccountLink"%>
<%@ page import="com.dimata.aiso.entity.masterdata.PstPerkiraan"%>
<%@ page import="com.dimata.aiso.entity.masterdata.Perkiraan"%>
<%@ page import="com.dimata.common.entity.payment.CurrencyType"%>
<%@ page import="com.dimata.interfaces.journal.I_JournalType"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.PstSpecialJournalMain"%>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
/** Check privilege except VIEW, view is already checked on checkuser.jsp as basic access */
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));
%>

<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static final int INT_VALID_DELETE = 0;
public static final int INT_INVALID_DELETE = 1;

public static String strTitleMain[][] = {
	{
		"Perkiraan Kas",//0
		"Saldo Akhir",//1
		"Nomor Jurnal",//2
		"Tanggal Jurnal",//3
		"Diterima Oleh",//4
		"No.",//5
		"Alamat",//6
		"Tanggal",//7
		"Memo",//8
		"Total Terima",//9
		"Cari"//10
	},
	
	{
		"Cash Account",//0
		"Ending Balance",//1
		"Voucher Number",//2
		"Voucher Date",//3
		"Receive by",//4
		"No.",//5
		"Address",//6
		"Tanggal",//7
		"Memo",//8
		"Receipts",//9
		"Search"
	}
};
public static String strTitle[][] =
{
	{
		"Departemen",//0
		"Aktivitas",//1
		"Nama",//2
		"Mata Uang",//3
		"Kurs",//4
		"Jumlah",//5
		"Catatan",//6
		"Perkiraan",//7
		"Prosentase"//8
	}
	,
	{		
		"Department",//0
		"Activity",//1
		"Name",//2
		"Currency",//3
        "Rate",//4
        "Amount",//5
        "Memo",//6
		"Account",//7
        "Share Procentage"//8
	}
};

public static final String masterTitle[] = {
	"Jurnal Khusus","Special Journal"
};

public static final String listTitle[] = {
	"Proses Jurnal","Journal Process"
};

public static final String subMasterTitle[] = {
	"Jurnal Penerimaan Kas","Cash Receipts Journal"
};
%>
<!-- JSP Block -->
<%
// get request from hidden text
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE JOURNAL PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES JURNAL SEBELUM MELAKUKAN PROSES LAIN";

int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int addType = FRMQueryString.requestInt(request,"add_type");
long journalID = FRMQueryString.requestLong(request,"journal_id");
int accountGroup = FRMQueryString.requestInt(request,"account_group");
int index = FRMQueryString.requestInt(request,"index");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long idAccount = FRMQueryString.requestLong(request,"perkiraan");
/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New" : "Tambah Baru";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : "Tambah Baru Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Special Journal List" : "Kembali Ke Daftar Jurnal Khusus";
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

    /** Instansiasi object CtrlJurnalUmum and FrmJurnalUmum */
    CtrlSpecialJournalMain ctrlSpecialJournalMain = new CtrlSpecialJournalMain(request);
    ctrlSpecialJournalMain.setLanguage(SESS_LANGUAGE);
    FrmSpecialJournalMain frmSpecialJournalMain = ctrlSpecialJournalMain.getForm();
    int ctrlErr = ctrlSpecialJournalMain.action(iCommand, journalID, userOID);
    SpecialJournalMain objSpecialJournalMain = ctrlSpecialJournalMain.getSpecialJournalMain();
    /** Saving object jurnalumum into session */
    if(objSpecialJournalMain.getOID()==0){
        if(iCommand==Command.POST){
            try{ // ini digunakan untuk nyimpan data ke session saat tombol post
                session.putValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL,objSpecialJournalMain);
            }catch(Exception e){}
        }else{ // ini di gunakan tambah jurnal tapi tidak command post
            if(iCommand==Command.NONE){
                try{
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
                    objSpecialJournalMain = new SpecialJournalMain();
                }catch(Exception e){}
            }else{
                try{
                    objSpecialJournalMain = (SpecialJournalMain)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
                    if(objSpecialJournalMain==null)
                        objSpecialJournalMain = new SpecialJournalMain();
                }catch(Exception e){}
            }
        }
    }else{

    }

    String contactName = "";
    ContactList contactList = new ContactList();


    // boolean periodClosed = PstPeriode.isPeriodClosed(objSpcJournalMain.getPeriodeId());

    /** if Command.POST and no error occur, redirect to journal detail page */
    try{
        //System.out.println("contact id : "+jUmum.getContactOid());
        contactList = PstContactList.fetchExc(objSpecialJournalMain.getContactId());
        contactName = contactList.getCompName();
        if(contactName.length()==0)
            contactName = contactList.getPersonName()+" "+contactList.getPersonLastname();
    }catch(Exception e){}

    //Vector listjurnaldetail = objSpecialJournalMain.getJurnalDetails();

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
    Periode currPeriod = new Periode();
    try{
        currPeriod = PstPeriode.fetchExc(periodeOID);
    }catch(Exception e){
    }

// get masterdata currency
String sOrderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector vlistCurrencyType = PstCurrencyType.list(0, 0, "", sOrderBy);

// get masterdata standart rate
String sStRateWhereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS] + " = " + PstStandartRate.ACTIVE;
String sStRateOrderBy = PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE] +
						", " + PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE];
Vector vlistStandartRate = PstStandartRate.list(0, 0, sStRateWhereClause, sStRateOrderBy);

    Vector vSaldoAkhir = SessSpecialJurnal.getTotalSaldoAccountLink(0);
        if(ctrlErr ==0 && iCommand==Command.POST && objSpecialJournalMain.getContactId()!=0 && objSpecialJournalMain.getAmount() > 0 && objSpecialJournalMain.getReference().length()>0){
         %>
            <jsp:forward page="journaldetail.jsp">
            <jsp:param name="command" value="<%=Command.ADD%>"/>
            </jsp:forward>
         <%
             }
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">
<%System.out.println("Masuk Java Script");%>
<%if((privView)&&(privAdd)&&(privSubmit)){%>
function addNewDetail(){
    var prev = document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.perkiraan.value=0;
    document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.account_group.value=0;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.index.value=-1;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.POST%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.prev_command.value=prev;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function cmdCancel(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.NONE %>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.target="_self";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="jumum.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}
function cmdAddDetail(){
    document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.ADD%>";
    document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journaldetail.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function cmdAsk(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.ASK%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.target="_self";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="jumum.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function cmdDelete(oid){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.journal_id.value=oid;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.target="_self";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="jumum.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function cmdItemData(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.index.value=-1;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.LIST%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.target="_self";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="jdetail.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function cmdAddDetail(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.POST%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.target="_self";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journalmain.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function cmdopen(){
	window.open("donor_list.jsp","jurnal_search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

 <%}%>

function cmdBack(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.BACK%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.start.value="<%=start%>";
    document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.target="_self";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="jlist.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}


function changeCurrType()  
{ 
	var iCurrType = document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CURRENCY_TYPE_ID]%>.value;
	switch(iCurrType)
	{
	<% System.out.println(" vlistStandartRate =========================="+vlistStandartRate.size());
	if(vlistStandartRate!=null && vlistStandartRate.size()>0)
	{
		int ilistStandartRateCount = vlistStandartRate.size();
		for(int i=0; i<ilistStandartRateCount; i++)
		{
			StandartRate objStandartRate = (StandartRate) vlistStandartRate.get(i);
	%>
		case "<%=objStandartRate.getCurrencyTypeId()%>" :
			 document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_STANDAR_RATE]%>.value = "<%=frmSpecialJournalMain.userFormatStringDecimal(objStandartRate.getSellingRate())%>";
			 //changeJournalDebet();
			 //changeJournalKredit();
			 break;
	<%	
		}	
	}
	%>			
		default :
			 document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.STANDART_RATE.value = "<%=frmSpecialJournalMain.userFormatStringDecimal(1)%>";		
			 changeJournalDebet();
			 changeJournalKredit();			 
			 break;
	}
}

function changeTotal()
{
	var iCurrType = document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_ID_PERKIRAAN]%>.value;
	switch(iCurrType){
        <%
        if(vSaldoAkhir!=null && vSaldoAkhir.size()>0){
                for(int k=0; k<vSaldoAkhir.size(); k++){
                    Vector temp = (Vector) vSaldoAkhir.get(k);
                %>
		case "<%=temp.get(0)%>" :
			 document.all.tot_saldo_akhir.innerHTML = "<%=frmSpecialJournalMain.userFormatStringDecimal(Double.parseDouble((String)temp.get(1)))%>";
			 break;
        <%
            }
       }
        %>
	}
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
            &gt; <%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="journal_id" value="<%=journalID%>">
              <input type="hidden" name="list_command" value="<%=Command.LIST%>">
              <input type="hidden" name="index" value="<%=index%>">
              <input type="hidden" name="add_type" value="<%=addType%>">
              <input type="hidden" name="perkiraan" value="<%=idAccount%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
	          <input type="hidden" name="account_group" value="<%=accountGroup%>">
			  <input type="hidden" name="STANDART_RATE" value="">
              <input type="hidden" name="index_edit" value="-1">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_DEPARTMENT_ID]%>" value="<%=lDefaultSpcJournalDeptId%>">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_JOURNAL_TYPE]%>" value="<%=I_JournalType.TIPE_SPECIAL_JOURNAL_CASH%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_BOOK_TYPE]%>" value="<%=""+accountingBookType%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_STANDAR_RATE]%>" value="<%=""+objSpecialJournalMain.getStandarRate()%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT_STATUS]%>" value="<%=""+PstSpecialJournalMain.STS_DEBET%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_JOURNAL_STATUS]%>" value="<%=""+I_DocStatus.DOCUMENT_STATUS_DRAFT%>" size="35">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%" height="2">&nbsp;
                         
                        </td>
                      </tr>
                      <tr>
                        <td width="100%" class="tabtitleactive">
                          <table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                              <td width="94%" height="25" class="listgensell" valign="top">&nbsp;</td>
                              <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                            </tr>
                            <tr>
                              <td width="3%" valign="top"></td>
                              <td width="94%" valign="top">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                                  <tr>
                                    <td width="42%" height="25" ><table width="100%"  border="0" >
                                        <tr >
                                          <td width="9%"><%=strTitleMain[SESS_LANGUAGE][0]%></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="14%"> <%
											Vector vectCashAccount = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_CASH);
											Vector val = new Vector(1,1);
											Vector key = new Vector(1,1);
											Perkiraan objPerkiraan = new Perkiraan();
											String selectPerkiraan = String.valueOf(objSpecialJournalMain.getIdPerkiraan());

											if(vectCashAccount != null && vectCashAccount.size() > 0){
												for(int i=0; i<vectCashAccount.size(); i++){
													objPerkiraan = (Perkiraan)vectCashAccount.get(i);
													val.add(objPerkiraan.getNama());
													key.add(""+objPerkiraan.getOID());
												}
											}
										%> <%= ControlCombo.draw(frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_ID_PERKIRAAN],null, selectPerkiraan, key, val, "onChange=\"javascript:changeTotal()\"", "")%> </td>
                                          <td width="30%"><table width="60%"  border="0" class="listgenvalue">
                                              <tr>
                                                <td width="50%" nowrap><%=strTitleMain[SESS_LANGUAGE][1]%></td>
                                                <td width="9%"><strong>:</strong></td>
                                                <td width="41%" nowrap><a id="tot_saldo_akhir"></a></td>
                                              </tr>
                                            </table></td>
                                          <td width="14%" nowrap><%=strTitleMain[SESS_LANGUAGE][2]%></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="7%" nowrap> <%
											out.println(objSpecialJournalMain.getVoucherNumber());
									        %> </td>
                                          <td width="13%" nowrap><%=strTitleMain[SESS_LANGUAGE][3]%></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="10%" nowrap> <%
									   out.println(Formater.formatDate(objSpecialJournalMain.getEntryDate(),"MMM dd,  yyyy"));
									  %> </td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <tr>
                                    <td height="25"><table width="99%"  border="0" cellpadding="0" cellspacing="0" class="listgenkubaru">
                                        <tr>
                                          <td width="13%"><%=strTitleMain[SESS_LANGUAGE][4]%></td>
                                          <td width="5%">&nbsp;</td>
                                          <td width="42%"> <input type="hidden" readonly name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CONTACT_ID]%>" value="<%=objSpecialJournalMain.getContactId()%>" size="25">
                                            <input type="text" readonly name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CONTACT_ID]%>_TEXT" value="<%=contactName%>" size="25">
                                            <a href="javascript:cmdopen()"><%=strTitleMain[SESS_LANGUAGE][10]%></a> </td>
                                          <td width="7%"><%=strTitleMain[SESS_LANGUAGE][5]%></td>
                                          <td width="2%"><strong>:</strong></td>
                                          <td width="31%"><input name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_REFERENCE]%>" type="text" value="<%=objSpecialJournalMain.getReference()%>" size="20"></td>
                                        </tr>
                                        <tr>
                                          <td><%=strTitleMain[SESS_LANGUAGE][6]%></td>
                                          <td>&nbsp;</td>
                                          <td><%=contactList.getBussAddress()%></td>
                                          <td><%=strTitleMain[SESS_LANGUAGE][7]%></td>
                                          <td><strong>:</strong></td>
                                          <td> <%
											Date dtTransactionDate = objSpecialJournalMain.getTransDate();
											if(dtTransactionDate ==null)
											{
												dtTransactionDate = new Date();
											}
											out.println(ControlDate.drawDate(frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE], dtTransactionDate, 0, -2));
											%> </td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td> <%
												  Vector currencytypeid_value = new Vector(1,1);
												  Vector currencytypeid_key = new Vector(1,1);

												  String sSelectedCurrType = ""+objSpecialJournalMain.getCurrencyTypeId();
												  if(vlistCurrencyType!=null && vlistCurrencyType.size()>0){
													for(int i=0; i<vlistCurrencyType.size(); i++){
														CurrencyType currencyType =(CurrencyType)vlistCurrencyType.get(i);
														currencytypeid_value.add(currencyType.getCode());
														currencytypeid_key.add(""+currencyType.getOID());
													}
												  }
												  out.println(ControlCombo.draw(FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CURRENCY_TYPE_ID], null, sSelectedCurrType, currencytypeid_key, currencytypeid_value, "onChange=\"javascript:changeCurrType()\"", ""));
										%> </td>
                                          <td>&nbsp;</td>
                                          <td><input name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT]%>" type="text" value="<%=objSpecialJournalMain.getAmount()%>"></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp; </td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td colspan="6">______________________________________________________________________________________________________rupiah</td>
                                        </tr>
                                        <tr>
                                          <td colspan="6">&nbsp; </td>
                                        </tr>
                                        <tr>
                                          <td><%=strTitleMain[SESS_LANGUAGE][8]%></td>
                                          <td colspan="5"><input name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_DESCRIPTION]%>" type="text" value="<%=objSpecialJournalMain.getDescription()%>" size="100"></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="5">&nbsp;</td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <tr>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td><table width="30%"  border="0" class="listgenvalue">
                                        <tr>
                                          <td width="34%"><%=strTitleMain[SESS_LANGUAGE][9]%></td>
                                          <td width="66%">&nbsp;</td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <tr>
                                    <td><%=frmSpecialJournalMain.getErrorMsg(FrmSpecialJournalMain.FRM_TRANS_DATE)%><%=frmSpecialJournalMain.getErrorMsg(FrmSpecialJournalMain.FRM_ENTRY_DATE)%></td>
                                  </tr>
                                  <tr>
                                    <td> <%
                                        String sCommandAddSaveAskBack = "";
                                    sCommandAddSaveAskBack = sCommandAddSaveAskBack + "<a href=\"javascript:addNewDetail()\"> Simpan Spec Main</a>";
                                      out.println(sCommandAddSaveAskBack);
									  %> </td>
                                  </tr>
                                </table>                              </td>
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
          <script language="javascript">
            changeTotal();
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
