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
                   com.dimata.aiso.entity.masterdata.PstPerkiraan,
                   com.dimata.aiso.entity.masterdata.Perkiraan,
                   com.dimata.gui.jsp.ControlLine,
                   com.dimata.common.entity.payment.CurrencyType,
                   com.dimata.common.entity.payment.PstCurrencyType,
                   com.dimata.common.entity.contact.ContactList,
                   com.dimata.common.entity.contact.PstContactList,
                   com.dimata.aiso.form.arap.FrmArApItem,
                   com.dimata.gui.jsp.ControlList,
                   com.dimata.aiso.entity.arap.ArApItem,
                   com.dimata.aiso.entity.masterdata.Aktiva,
                   com.dimata.aiso.entity.arap.PstArApItem,
                   com.dimata.aiso.session.arap.SessArApEntry,
                   com.dimata.aiso.entity.arap.PstArApMain,
                   com.dimata.util.Validator,
                   com.dimata.common.entity.payment.PstStandartRate,
                   com.dimata.common.entity.payment.StandartRate" %>
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
	window.location="<%//=approot%>/nopriv.html";
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
        "Nilai Tukar",
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
        "Rate",
        "Nominal",
        "Number of Payment",
        "Account",
        "Opposite Account",
        "Description",
        "Payment Term Entry",
        "Jurnal Posting",
        "Set all payment",
        "Book Value"
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
	"Entry Hutang/Piutang","AR/AP Entry"
};

public static final String listTitle[][] = {
    {"Piutang","Receivable"},
    {"Hutang","Payable"}
};

public String drawList(int language, Vector objectClass,FrmArApMain frmArApMain){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
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
        if(arApItem.getAngsuran()==arApItem.getLeftToPay()){
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
%>


<!-- JSP Block -->
<%
// get request from hidden text
showMenu = false;
int arapType = FRMQueryString.requestInt(request,"arap_type");
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE "+PstArApMain.stTypeArAp[1][arapType].toUpperCase()+" PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES "+PstArApMain.stTypeArAp[0][arapType].toUpperCase()+" SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int index = FRMQueryString.requestInt(request,"index");

int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidArApMain = FRMQueryString.requestLong(request,"arap_main_id");
int posted = FRMQueryString.requestInt(request,"posted_status");

/**
* Declare Commands caption
*/
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Payment Term" : " Tambah Angsuran";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To "+PstArApMain.stTypeArAp[1][arapType]+ " List": "Kembali Ke Daftar "+PstArApMain.stTypeArAp[0][arapType];
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete "+PstArApMain.stTypeArAp[1][arapType] : "Hapus "+PstArApMain.stTypeArAp[0][arapType];
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete" : "Ya Hapus";

/** Instansiasi object CtrlArApMain and FrmArApMain */
ControlLine ctrLine = new ControlLine();
CtrlArApMain ctrlArApMain = new CtrlArApMain(request);
ctrlArApMain.setLanguage(SESS_LANGUAGE);
FrmArApMain frmArApMain = ctrlArApMain.getForm();
int iErrCode = ctrlArApMain.action(iCommand, oidArApMain);
ArApMain arApMain = ctrlArApMain.getArApMain();
oidArApMain = arApMain.getOID();
String msgString = ctrlArApMain.getMessage();

frmArApMain.setDecimalSeparator(sUserDecimalSymbol);
frmArApMain.setDigitSeparator(sUserDigitGroup);

    // proses untuk command SUBMIT
    /**
     * proses ini juga akan mengupdate ArApMain jika ada ketidaksesuaian dalam jumlah
     * total angsuran dan number of payment nya
     */
if(iCommand==Command.SUBMIT){
    ArApItem arApItem = new ArApItem();
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

    // get nama company
    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(arApMain.getContactId());
    }catch(Exception e){}
    if(iCommand==Command.NONE)
        iCommand = Command.ADD;
    else if((iCommand==Command.SAVE && iErrCode == 0)||(iCommand==Command.SUBMIT))
        iCommand = Command.EDIT;

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


    if(posted!=0){
        SessArApEntry sessArApMain = new SessArApEntry();
        sessArApMain.postingArApMain(accountingBookType,userOID,currentPeriodOid,arApMain);
    }
/** if Command.DELETE, delete journal and its descendant and redirect to journal detail page */
if(iCommand==Command.DELETE){
%>
	<jsp:forward page="arap_entry_list.jsp">
	<jsp:param name="start" value="<%=start%>"/>
	<jsp:param name="command" value="<%=Command.LIST%>"/>
	</jsp:forward>
<%
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript" src="../main/dsj_common.js"></script>
<script language="javascript">
var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

<%if((privView)&&(privAdd)&&(privSubmit)){%>
function addNewDetail(){
	document.frmarapentry.perkiraan.value=0;
	document.frmarapentry.index.value=-1;
	document.frmarapentry.command.value="<%=Command.ADD%>";
	document.frmarapentry.prev_command.value="<%=Command.ADD%>";
	document.frmarapentry.action="jdetail.jsp";
	document.frmarapentry.submit();
}

function addNew(){
	document.frmarapentry.journal_id.value="0";
	document.frmarapentry.command.value="<%=Command.ADD%>";
	document.frmarapentry.action="jdetail.jsp";
	document.frmarapentry.submit();
}

function cmdCancel(){
	document.frmarapentry.command.value="<%=Command.NONE%>";
	document.frmarapentry.action="jumum.jsp";
	document.frmarapentry.submit();
}

function cmdSave(){
    <%if(iCommand==Command.EDIT && list.size()==0){
     %>
     document.frmarapentry.command.value="<%=Command.SUBMIT%>";
     <%
    }
    else{
       %>
    document.frmarapentry.command.value="<%=Command.SAVE%>";
       <%
    }
    %>

	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdPosted(){
	document.frmarapentry.command.value="<%=Command.SAVE%>";
    document.frmarapentry.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]%>.value = "<%=I_DocStatus.DOCUMENT_STATUS_POSTED%>";
    document.frmarapentry.posted_status.value="1";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdAsk(){
	document.frmarapentry.command.value="<%=Command.ASK%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdEdit(oid){
	document.frmarapentry.arap_main_id.value=oid;
	document.frmarapentry.command.value="<%=Command.EDIT%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdDelete(oid){
	document.frmarapentry.arap_main_id.value=oid;
	document.frmarapentry.command.value="<%=Command.DELETE%>";
	document.frmarapentry.action="arap_entry_edit.jsp";
	document.frmarapentry.submit();
}

function cmdEditItem(oid){
	document.frmarapentry.command.value="<%=Command.LIST%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdAddDetail(oid){
    document.frmarapentry.arap_main_id.value=oid;
	document.frmarapentry.command.value="<%=Command.ADD%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

function cmdEditDetail(oid){
    document.frmarapentry.arap_item_id.value = oid;
	document.frmarapentry.command.value="<%=Command.EDIT%>";
	document.frmarapentry.action="arap_entry_detail.jsp";
	document.frmarapentry.submit();
}

    <%}%>

function cmdBack(){
	document.frmarapentry.command.value="<%=Command.BACK%>";
	document.frmarapentry.start.value="<%=start%>";
	document.frmarapentry.action="arap_entry_list.jsp";
	document.frmarapentry.submit();
}

function cmdopen(){
    window.open("srccontact_list.jsp","search_company","height=550,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
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
    case <%=currencyType.getOID()%> :
        document.frmarapentry.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_RATE]%>.value="<%=frmArApMain.userFormatStringDecimal(rate)%>"
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
    document.frmarapentry.ANGSURAN<%=i%>.value="<%=frmArApMain.userFormatStringDecimal(dAngsuran)%>";
    document.frmarapentry.DUE_DATE<%=i%>_mn.value=month;
    document.frmarapentry.DUE_DATE<%=i%>_yr.value=year;
    document.frmarapentry.DUE_DATE<%=i%>_dy.value=day;
    document.frmarapentry.DESCRIPTION<%=i%>.value=desc+" "+"<%=(i+1)%>";
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

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
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
            &gt; <%=listTitle[arapType][SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td><!-- #BeginEditable "content" -->
          <%try{%>
            <form name="frmarapentry" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_CONTACT_ID]%>" value="<%=arApMain.getContactId()%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_MAIN_STATUS]%>" value="<%=arApMain.getArApMainStatus()%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]%>" value="<%=arApMain.getArApDocStatus()%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_TYPE]%>" value="<%=arapType%>">
              <input type="hidden" name="arap_main_id" value="<%=oidArApMain%>">
              <input type="hidden" name="arap_item_id" value="0">
              <input type="hidden" name="posted_status" value="0">
              <input type="hidden" name="arap_type" value="<%=arapType%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
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
                                    <td width="18%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_VOUCHER_NO]%>" value="<%=arApMain.getVoucherNo()%>" size="35"><%=arApMain.getVoucherNo()%>
									</td>
                                    <td width="21%" height="25"><%=strTitle[SESS_LANGUAGE][6]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                      <input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_RATE]%>" size="15" readonly style="background-color:#E8E8E8; text-align:right" value="<%=frmArApMain.userFormatStringDecimal(arApMain.getRate())%>">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][1]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
                                    <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_VOUCHER_DATE]%>_dy" value="<%=Validator.getIntDate(arApMain.getVoucherDate())%>">
                                    <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_VOUCHER_DATE]%>_mn" value="<%=Validator.getIntMonth(arApMain.getVoucherDate())%>">
                                    <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_VOUCHER_DATE]%>_yr" value="<%=Validator.getIntYear(arApMain.getVoucherDate())%>">
									<%=Formater.formatDate(arApMain.getVoucherDate(),"dd-MM-yyyy")%>
									</td>
                                    <td width="21%" height="25"><%=strTitle[SESS_LANGUAGE][7]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                      <input type="text" name="NOMINAL" size="20"  <%=iCommand==Command.EDIT?"readonly":""%> style="<%=iCommand==Command.EDIT?"background-color:#E8E8E8;":""%>text-align:right" onBlur="javascript:cmdNominal()" value="<%=frmArApMain.userFormatStringDecimal(arApMain.getAmount()/arApMain.getRate())%>">
                                      &nbsp;<%=strTitle[SESS_LANGUAGE][15]%>&nbsp;<input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_AMOUNT]%>" size="20"  readonlu style="background-color:#E8E8E8;text-align:right" value="<%=frmArApMain.userFormatStringDecimal(arApMain.getAmount())%>">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_NOTA_NO]%>" size="15"   value="<%=arApMain.getNotaNo()%>">
									</td>
                                    <td width="21%" height="25"><%=strTitle[SESS_LANGUAGE][8]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                    <input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_NUMBER_OF_PAYMENT]%>" size="3" <%=iCommand==Command.EDIT?"readonly":""%> style="<%=iCommand==Command.EDIT?"background-color:#E8E8E8;":""%>text-align:right" value="<%=arApMain.getNumberOfPayment()%>">*
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][3]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<%
                                        Date dtTransactionDate = arApMain.getNotaDate();
                                        if(dtTransactionDate ==null)
                                        {
                                            dtTransactionDate = new Date();
                                        }
                                        out.println(ControlDate.drawDate(frmArApMain.fieldNames[FrmArApMain.FRM_NOTA_DATE], dtTransactionDate, 4, -5));
									%>
                                    </td>
                                    <td width="21%" height="25"><%=strTitle[SESS_LANGUAGE][9]+" "+listTitle[arapType][SESS_LANGUAGE]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
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
                                       String whereClause = "";

                                       if(arapType==PstArApMain.TYPE_AR){
                                            whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS+
                                               " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
                                       }
                                       else{
                                            whereClause = "("+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES+
                                               " OR "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_LONG_TERM_LIABILITIES+")"+
                                               " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
                                       }
                                       if(vDepartmentOid.size()>0){
                                            whereClause = whereClause +" AND (";

                                           for(int i = 0; i< vDepartmentOid.size(); i++){
                                               whereClause = whereClause +PstPerkiraan.fieldNames[PstPerkiraan.FLD_DEPARTMENT_ID]+ " = "+(String) vDepartmentOid.get(i);
                                               if(i<vDepartmentOid.size()-1){
                                                   whereClause = whereClause+" OR ";
                                               }
                                           }
                                           whereClause = whereClause +")";
                                       }
									   Vector lPayment = PstPerkiraan.list(0,0,whereClause,
                                               PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN]);
                                       if(lPayment!=null&&lPayment.size()>0){
											for(int i=0;i<lPayment.size();i++){
												Perkiraan perkiraan =(Perkiraan)lPayment.get(i);
                                                String padding = "";
                                                for(int j=0;j<perkiraan.getLevel();j++){
                                                    padding = padding + "&nbsp;&nbsp;&nbsp;";
                                                }
												perkiraanPayid_value.add(padding+perkiraan.getNoPerkiraan()+" "+perkiraan.getNama());
												perkiraanPayid_key.add(""+perkiraan.getOID());
											}
									   }
									  %>
                                      <%= ControlCombo.draw(frmArApMain.fieldNames[FrmArApMain.FRM_ID_PERKIRAAN],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %>*
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][4]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
                                    <input type="text" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_CONTACT_ID]%>_TEXT" readonly style="background-color:#E8E8E8" size="35"  value="<%=mergeString(contactList.getCompName(),contactList.getPersonName())%>">*&nbsp;<a href="javascript:cmdopen()"><%=SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Search" : "Cari"%></a>
                                    </td>
                                    <td width="21%" height="25"><%=strTitle[SESS_LANGUAGE][10]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                    <%
              /*
                                       if(arapType==PstArApMain.TYPE_AR){
                                            whereClause = "("+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_REVENUE+
                                               " OR "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_OTHER_REVENUE+
                                               " OR "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS+
                                               " OR "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_OTHER_ASSETS+
                                               ") AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
                                       }
                                       else{
                                           perkiraanPayid_value = new Vector();
                                           perkiraanPayid_key = new Vector();
                                           whereClause = "("+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS+
                                               " OR "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_EXPENSE+
                                               " OR "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_OTHER_EXPENSE+
                                               " OR "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_OTHER_ASSETS+
                                               ") AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
                                       }
                                       */
                                       whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
                                       if(vDepartmentOid.size()>0){
                                            whereClause = whereClause +" AND (";

                                           for(int i = 0; i< vDepartmentOid.size(); i++){
                                               whereClause = whereClause +PstPerkiraan.fieldNames[PstPerkiraan.FLD_DEPARTMENT_ID]+ " = "+(String) vDepartmentOid.get(i);
                                               if(i<vDepartmentOid.size()-1){
                                                   whereClause = whereClause+" OR ";
                                               }
                                           }
                                           whereClause = whereClause +")";
                                       }
									   lPayment = PstPerkiraan.list(0,0,whereClause,PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN]);
                                       if(lPayment!=null&&lPayment.size()>0){
											for(int i=0;i<lPayment.size();i++){
												Perkiraan perkiraan =(Perkiraan)lPayment.get(i);
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
                                      <%= ControlCombo.draw(frmArApMain.fieldNames[FrmArApMain.FRM_ID_PERKIRAAN_LAWAN],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %>*
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][5]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">

                                      <%= ControlCombo.draw(frmArApMain.fieldNames[FrmArApMain.FRM_ID_CURRENCY],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value,  "onChange=\"javascript:cmdChangeCurr()\"", "") %>                                    </td>
                                    <td width="21%" height="25"><%=strTitle[SESS_LANGUAGE][11]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"> 
                                      <textarea cols="40" rows="3" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_DESCRIPTION]%>"><%=arApMain.getDescription()%></textarea>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">
                                    </td>
                                  </tr>
                                  <tr>
                                    <%
                                    if(list.size()>0){
                                    %>
                                    <td colspan="6"><%=drawList(SESS_LANGUAGE,list,frmArApMain)%></td>
                                    <%
                                    }
                                    else if(iCommand==Command.EDIT){
                                    %>
                                    <td colspan="6"><%=drawList(SESS_LANGUAGE,arApMain.getNumberOfPayment())%></td>
                                    <%
                                    }
                                    %>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%
                                        if(arApMain.getArApDocStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
										  if((iCommand==Command.EDIT) || (iCommand==Command.SAVE && iErrCode==0) || (iCommand==Command.LIST)){
                                            out.println("<a href=\"javascript:cmdAddDetail('"+oidArApMain+"')\" class=\"command\">"+strAddDetail+"</a>");
                                          }
                                        }
									  %></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                          <td width="76%" nowrap scope="row">
                                            <%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidArApMain+"')";
							String sconDelCom = "javascript:cmdDelete('"+oidArApMain+"')";
							String scancel = "javascript:cmdEdit('"+oidArApMain+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);
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
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							%>
                                          </td>
                                        <td width="24%" align="right"><a href="javascript:cmdPosted()" class="command"><%if(arApMain.getArApDocStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0){%><%=strTitle[SESS_LANGUAGE][13]%><%}%></a></td>
                                      </tr>
                                    </table></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
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
            <%}catch(Exception e){
                System.out.println("err on JSP: "+e.toString());
          }   %>
            <script language="javascript">
cmdChangeCurr();
            </script>
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
<%}%>
