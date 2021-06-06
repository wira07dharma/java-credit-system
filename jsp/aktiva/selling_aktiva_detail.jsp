<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*,
                 com.dimata.aiso.form.aktiva.FrmSellingAktivaItem,
                 com.dimata.aiso.form.aktiva.CtrlSellingAktivaItem,
                 com.dimata.aiso.entity.aktiva.SellingAktivaItem,
                 com.dimata.aiso.form.aktiva.FrmSellingAktiva,
                 com.dimata.interfaces.trantype.I_TransactionType,
                 com.dimata.aiso.entity.aktiva.SellingAktiva,
                 com.dimata.aiso.form.aktiva.CtrlSellingAktiva,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.common.entity.contact.PstContactList,
                 com.dimata.aiso.entity.aktiva.PstSellingAktivaItem" %>
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
	"No","Kode","Nama","Qty","Harga","Total Harga"
	},

	{
	"No","Code","Name","Qty","Price","Total Price"
	}
};

public static String strTitle[][] =
{
	{
		"Nomor",
		"Tanggal",
		"Customer",
		"Tipe Transaksi",
		"Perkiraan Lawan",
	 	"Perkiraan Uang Muka",
        "Mata Uang",
        "Total",
        "Uang Muka",
        "Sisa",
        "Posting ke Jurnal",
		"Catatan"
	},
	{
		"Document No",
		"Date",
		"Customer",
		"Transaction Type",
		"Payment Account",
		"Down Payment",
        "Currency",
        "Total",
        "Donw Payment",
        "Residue",
        "Posted Journal",
		"Note"
	}
};

    public static final String masterTitle[] = {
        "Aktiva Tetap","Fixed Assets"
    };

    public static final String listTitle[] = {
        "Proses Penjualan","Selling Process"
    };



/**
* this method used to list jurnal detail
*/
public String drawList(int language, int iCommand,
                                  Vector objectClass, long orderAktivaItemId, FrmSellingAktivaItem frmSellingAktivaItem,long oidSellingAktiva,String approot){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strItemTitle[language][0],"3%","center","left"); // no
    ctrlist.dataFormat(strItemTitle[language][1],"8%","center","left"); // kode
    ctrlist.dataFormat(strItemTitle[language][2],"35%","center","left"); // nama
    ctrlist.dataFormat(strItemTitle[language][3],"5%","center","left"); // qty
    ctrlist.dataFormat(strItemTitle[language][4],"8%","center","left"); // harga
    ctrlist.dataFormat(strItemTitle[language][5],"8%","center","left"); // total harga

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
	int totQty = PstSellingAktivaItem.getTotalQuantitySellingAktivaItem(oidSellingAktiva);
	//double totPrice = 0;
	double total = PstSellingAktivaItem.getTotalSellingAktivaItem(oidSellingAktiva);

    System.out.println("test "+objectClass);
	for (int i = 0; i < objectClass.size(); i++) {
        Vector vect = (Vector)objectClass.get(i);
		SellingAktivaItem orderAktivaItem = (SellingAktivaItem)vect.get(0);
        ModulAktiva aktiva = (ModulAktiva)vect.get(1);

		rowx = new Vector();
		if(orderAktivaItemId == orderAktivaItem.getOID())
		 index = i;

		if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
            rowx.add("<div align=\"center\">"+(i+1)+"</div>");
            rowx.add("<input size=\"10\" type=\"text\" value="+aktiva.getKode()+" name=\"aktiva_code\"><a href =\"javascript:cmdopenitem()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
            rowx.add("<input type=\"hidden\" name=\""+FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_AKTIVA_ID]+"\" value="+orderAktivaItem.getAktivaId()+">"+aktiva.getName());
            rowx.add("<div align=\"center\"><input size=\"5\" type=\"text\" name=\""+FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_QTY]+"\" onKeyUp = \"javascript:setTotalSubTotal()\" value="+orderAktivaItem.getQty()+"></div>");
            rowx.add("<input size=\"15\" type=\"text\" name=\""+FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_PRICE]+"\" onKeyUp = \"javascript:setTotalSubTotal()\" value="+Formater.formatNumber(orderAktivaItem.getPriceSelling(),"###.##")+">");
            rowx.add("<input size=\"15\" readonly type=\"text\" name=\""+FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_TOTAL_PRICE]+"\" value="+Formater.formatNumber(orderAktivaItem.getTotalPriceSelling(),"###.##")+">");
		
		//totPrice += orderAktivaItem.getTotalPriceSelling();  
		 }else{
			rowx.add("<div align=\"center\">"+(i+1)+"</div>");
			rowx.add(aktiva.getKode());
			rowx.add(aktiva.getName());
            rowx.add("<div align=\"center\">"+orderAktivaItem.getQty()+"</div>");
            rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getPriceSelling())+"</div>");
            rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getTotalPriceSelling())+"</div>");
		
		//totPrice += orderAktivaItem.getTotalPriceSelling();  
		 }
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(orderAktivaItem.getOID()));
	 }

	 rowx = new Vector();
	 if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmSellingAktivaItem.errorSize()>0)){
         rowx.add("");
         rowx.add("<input size=\"10\" type=\"text\" name=\"aktiva_code\"><a href =\"javascript:cmdopenitem()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
         rowx.add("<input type=\"hidden\" name=\""+FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_AKTIVA_ID]+"\" value=\"\">"+
                 "<input size=\"60\" readonly type=\"text\" name=\"aktiva_name\">");
         rowx.add("<input size=\"5\" type=\"text\" onKeyUp = \"javascript:setTotalSubTotal()\" name=\""+FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_QTY]+"\" value=\"\">");
         rowx.add("<input size=\"15\" type=\"text\" onKeyUp = \"javascript:setTotalSubTotal()\" name=\""+FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_PRICE]+"\" value=\"\">");
         rowx.add("<input size=\"15\" readonly type=\"text\" name=\""+FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_TOTAL_PRICE]+"\" value=\"\">");
         lstData.add(rowx);
	 }
	
	rowx = new Vector();

	rowx.add("");
      rowx.add("");
      rowx.add("<div align=\"center\"><b>Total</b></div>");
      rowx.add("<div align=\"center\"><b>"+totQty+"</b></div>");
      rowx.add("");
      rowx.add("<div align=\"right\"><b>"+FRMHandler.userFormatStringDecimal(total)+"</b></div>");
	lstData.add(rowx);

	return ctrlist.drawMe(-1);
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
long orderAktivadetailId = FRMQueryString.requestLong(request,"selling_aktiva_detail_id");
long oidSellingAktiva = FRMQueryString.requestLong(request,"hidden_selling_aktiva_id");

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : "Tambah Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Detail" : "Simpan Detail";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Detail" : "Hapus Detail";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Detail" : "Ya Hapus Detail";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";

    if(iCommand==Command.NONE)
        iCommand = Command.ADD;

// Instansiasi CtrlJurnalDetail and FrmJurnalDetail
CtrlSellingAktivaItem ctrlSellingAktivaItem = new CtrlSellingAktivaItem(request);
ctrlSellingAktivaItem.setLanguage(SESS_LANGUAGE);
FrmSellingAktivaItem frmSellingAktivaItem = ctrlSellingAktivaItem.getForm();
SellingAktivaItem orderAktivaItem = ctrlSellingAktivaItem.getSellingAktivaItem();
int iErrCode = ctrlSellingAktivaItem.action(iCommand,orderAktivadetailId);
String msgString = ctrlSellingAktivaItem.getMessage();

// Untuk main order aktiva
ControlLine ctrLine = new ControlLine();
CtrlSellingAktiva ctrlSellingAktiva = new CtrlSellingAktiva(request);
ctrlSellingAktiva.setLanguage(SESS_LANGUAGE);
FrmSellingAktiva frmSellingAktiva = ctrlSellingAktiva.getForm();
int iErrCodexx = ctrlSellingAktiva.action(Command.EDIT,oidSellingAktiva);
SellingAktiva orderAktiva = ctrlSellingAktiva.getSellingAktiva();
    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(orderAktiva.getSupplierId());
    }catch(Exception e){}

    Vector list = PstSellingAktivaItem.getListItem(oidSellingAktiva);

Vector lPaymentCmb = new Vector();
lPaymentCmb.add(PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_CASH));
lPaymentCmb.add(PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_BANK));    
Vector lPaymentHtLancar = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_PIUTANG);
Vector lPaymentAwal = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_RETAINED_EARNING);

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmorderaktiva.command.value="<%=Command.ADD%>";
	document.frmorderaktiva.prev_command.value="<%=Command.ADD%>";
	document.frmorderaktiva.action="selling_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdSave(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
	document.frmorderaktiva.action="selling_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdCancel(){
	document.frmorderaktiva.perkiraan.value=0;
	document.frmorderaktiva.command.value="<%=Command.NONE%>";
	document.frmorderaktiva.submit();
}

function cmdEdit(oid){
    document.frmorderaktiva.selling_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.prev_command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="selling_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdAsk(oid){
    document.frmorderaktiva.selling_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.ASK%>";
	document.frmorderaktiva.action="selling_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdDelete(oid){
    document.frmorderaktiva.selling_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.DELETE%>";
	document.frmorderaktiva.action="selling_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdBack(){
    document.frmorderaktiva.selling_aktiva_detail_id.value = 0;
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="selling_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdBackMain(){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="selling_aktiva_list.jsp";
	document.frmorderaktiva.submit();
}

function cmdSaveMain(oid){
    document.frmorderaktiva.hidden_selling_aktiva_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
	document.frmorderaktiva.action="selling_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdPosted(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
    document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_SELLING_STATUS]%>.value = "<%=I_DocStatus.DOCUMENT_STATUS_POSTED%>";
    document.frmorderaktiva.posted_status.value="1";
	document.frmorderaktiva.action="selling_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdAskMain(oid){
    document.frmorderaktiva.hidden_selling_aktiva_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.ASK%>";
	document.frmorderaktiva.action="selling_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function setTotalSubTotal(){
    var qty = document.frmorderaktiva.<%=FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_QTY]%>.value;
    var price = document.frmorderaktiva.<%=FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_PRICE]%>.value;
    var stotal = parseFloat(qty) * parseFloat(price);
    if(isNaN(stotal)){
        stotal = 0;
    }
    document.frmorderaktiva.<%=FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_TOTAL_PRICE]%>.value = stotal;
}

function cmdopenitem(){
    var strUrl = "modul_aktiva_own_list.jsp?command=<%=Command.LIST%>"+				 
			"&<%=FrmSrcModulAktiva.fieldNames[FrmSrcModulAktiva.FRM_SEARCH_KODE_AKTIVA]%>="+document.frmorderaktiva.aktiva_code.value+"";			
	
    popup = window.open(strUrl,"","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
	
}

function cmdopen(){
    window.open("srccontact_list.jsp","search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdChangeCurr(){
    var id = Math.abs(document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_CURRENCY]%>.value);
    switch(id){
<%
           Vector currencytypeid_value = new Vector(1,1);
           Vector currencytypeid_key = new Vector(1,1);
           String sel_currencytypeid = ""+orderAktiva.getIdCurrency();
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
        document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_VALUE_RATE]%>.value="<%=FrmSellingAktiva.userFormatStringDecimal(rate)%>"
        break;
                    <%
                }
}
									  %>
    default :
        document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_VALUE_RATE]%>.value="<%=FrmSellingAktiva.userFormatStringDecimal(1.0)%>"
        break;
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
            : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmorderaktiva" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_KONSUMEN_ID]%>" value="<%=orderAktiva.getSupplierId()%>">
              <input type="hidden" name="<%=FrmSellingAktivaItem.fieldNames[FrmSellingAktivaItem.FRM_SELLING_AKTIVA_ID]%>" value="<%=oidSellingAktiva%>">
              <input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_SELLING_STATUS]%>" value="<%=orderAktiva.getSellingStatus()%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_selling_aktiva_id" value="<%=oidSellingAktiva%>">
              <input type="hidden" name="selling_aktiva_detail_id" value="<%=orderAktivadetailId%>">
              <input type="hidden" name="posted_status" value="0">
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
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
                            <tr>
                              <td width="3%" valign="top"></td>
                              <td width="94%">
                                <table width="100%">

						<tr>
                                    <td width="15%" height="25"><b>&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="42%" height="25">
									<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_NOMOR_SELLING]%>" value="<%=orderAktiva.getNomorSelling()%>" size="35"><%=orderAktiva.getNomorSelling()%>
									</td>
                                    <td width="15%" height="25"><b><%=strTitle[SESS_LANGUAGE][6]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="26%" height="25">
							<%													
										
							      if((iCommand==Command.EDIT && iErrCode == 0) || iCommand==Command.ADD || iCommand==Command.LIST || iCommand==Command.SAVE || iCommand==Command.DELETE || iCommand==Command.ASK){
								%>
								<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_CURRENCY]%>" value="<%=orderAktiva.getIdCurrency()%>" size="35">
								<%
								CurrencyType ct = PstCurrencyType.fetchExc(orderAktiva.getIdCurrency());
								out.println(ct.getName());
							}else{
							%>
							<%= ControlCombo.draw(frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_CURRENCY],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value, "onChange=\"javascript:cmdChangeCurr()\"", "") %>
							<%}%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="15%" height="25"><b>&nbsp;<%=strTitle[SESS_LANGUAGE][1]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="42%" height="25">
									<%
                                        Date dtTransactionDate = orderAktiva.getTanggalSelling();                                        
                                        if((iCommand==Command.EDIT && iErrCode == 0) || iCommand==Command.ADD || iCommand==Command.LIST || iCommand==Command.SAVE || iCommand==Command.DELETE || iCommand==Command.ASK){
							%>
							<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]%>_dy" value="<%=dtTransactionDate.getDate()%>" size="35">
							<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]%>_mn" value="<%=(dtTransactionDate.getMonth() + 1)%>" size="35">
							<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]%>_yr" value="<%=(dtTransactionDate.getYear() + 1900)%>" size="35">
							<%
							out.println(Formater.formatDate(dtTransactionDate, "dd-MM-yyyy"));
						    }else{
						       dtTransactionDate = new Date();                                        								
							out.println(ControlDate.drawDate(frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING], dtTransactionDate, 4, -5));
						   }			
							%>
                                    </td>
                                    <td width="15%" height="25"><b><%=strTitle[SESS_LANGUAGE][3]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="26%" height="25">
							
							<%
									   Vector trantypeid_value1 = new Vector(1,1);
									   Vector trantypeid_key1 = new Vector(1,1);
									   String sel_trantypeid1 = ""+orderAktiva.getTypePembayaran();
									   String typePay = "";
                                        for(int i=0;i<I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE].length;i++){
                                            trantypeid_value1.add(I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][i]);
                                            trantypeid_key1.add(""+i);							  
                                        }
							if((iCommand==Command.EDIT && iErrCode == 0) || iCommand==Command.ADD || iCommand==Command.LIST || iCommand==Command.SAVE || iCommand==Command.DELETE || iCommand==Command.ASK){								
								%>
								<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TYPE_PEMBAYARAN]%>" value="<%=orderAktiva.getTypePembayaran()%>" size="35">
								<%
								typePay = (String)trantypeid_value1 .get(orderAktiva.getTypePembayaran());
								out.println(typePay);
							}else{
									  %>
                                      <%= ControlCombo.draw(frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TYPE_PEMBAYARAN],null, sel_trantypeid1, trantypeid_key1, trantypeid_value1, "onChange=\"javascript:cmdChange()\"", "") %>
                                      <%}%>                                      
                                    </td>
                                  </tr>
                                  <tr>
                                    <td height="25"><b>&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25"><%
							if((iCommand==Command.EDIT && iErrCode == 0) || iCommand==Command.ADD || iCommand==Command.LIST || iCommand==Command.SAVE || iCommand==Command.DELETE || iCommand==Command.ASK){
							out.println(contactList.getPersonName());
							}else{
						%>
                                      <input readonly type="text" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_KONSUMEN_ID]%>_TEXT2" value="<%=contactList.getPersonName()%>" size="35">
                                      &nbsp;&nbsp;&nbsp;<b><i><font face="Times New Roman, Times, serif" size="3"><a href="javascript:cmdopen()">search</a></font></i></b>
                                      <%}%></td>
                                    <td height="25"><b><%=strTitle[SESS_LANGUAGE][4]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
										<%
                                       Vector vDepartmentOid1 = new Vector(1,1);
                                         Vector vUsrCustomDepartment1 = PstDataCustom.getDataCustom(userOID, "hrdepartment");
                                         if(vUsrCustomDepartment1!=null && vUsrCustomDepartment1.size()>0)
                                         {
                                           int iDataCustomCount = vUsrCustomDepartment1.size();
                                           for(int i=0; i<iDataCustomCount; i++)
                                           {
                                               DataCustom objDataCustom = (DataCustom) vUsrCustomDepartment1.get(i);
                                               vDepartmentOid1.add(objDataCustom.getDataValue());
                                           }
                                         }

									   Vector perkiraanPayid_value1 = new Vector(1,1);
									   Vector perkiraanPayid_key1 = new Vector(1,1);
									   String sel_perkiraanPayid1 = ""+orderAktiva.getIdPerkiraanPayment();
                                       
                                       String whereClause1 = PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
                                       if(vDepartmentOid1.size()>0){
                                       whereClause1 = whereClause1 +" AND (";

                                           for(int i = 0; i< vDepartmentOid1.size(); i++){
                                               whereClause1 = whereClause1 +PstPerkiraan.fieldNames[PstPerkiraan.FLD_DEPARTMENT_ID]+ " = "+(String) vDepartmentOid1.get(i);
                                               if(i<vDepartmentOid1.size()-1){
                                                   whereClause1 = whereClause1+" OR ";
                                               }
                                           }
                                           whereClause1 = whereClause1 +")";
                                       }									  
							
                                       if(lPaymentCmb!=null&&lPaymentCmb.size()>0){
								for(int i=0;i<lPaymentCmb.size();i++){
									Vector temp = (Vector)lPaymentCmb.get(i);
									for(int l=0; l<temp.size(); l++){
										Perkiraan perkiraan =(Perkiraan)temp.get(l);
                                                           
										perkiraanPayid_value1.add(perkiraan.getNama());
										perkiraanPayid_key1.add(""+perkiraan.getOID());

									}//End for (int l=0; l<temp.size(); l++) 
								}//End for(int i=0;i<lPaymentCmb.size();i++)
							}//End if(lPaymentCmb!=null&&lPaymentCmb.size()>0)
						   if((iCommand==Command.EDIT && iErrCode == 0) || iCommand==Command.ADD || iCommand==Command.LIST || iCommand==Command.SAVE || iCommand==Command.DELETE || iCommand==Command.ASK ){
								%>
								<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>" value="<%=orderAktiva.getIdPerkiraanPayment()%>" size="35">
								<%
								Perkiraan perk = PstPerkiraan.fetchExc(orderAktiva.getIdPerkiraanPayment());
								out.println(perk.getNama());
							}else{	
						   %>
                                      <%= ControlCombo.draw(frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT],null, sel_perkiraanPayid1, perkiraanPayid_key1, perkiraanPayid_value1, "", "") %>							
						  <%}%>	
									</td>
                                  </tr>
                                  <tr>
                                    <td width="15%" height="25">&nbsp;</td>
                                    <td width="1%" height="25">&nbsp;</td>
                                    <td width="42%" height="25">&nbsp;
                                    </td>
                                    <td width="15%" height="25"><b><%=strTitle[SESS_LANGUAGE][11]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="26%" height="25"><%=orderAktiva.getNote()%></td>
                                  </tr>                         
				    
                                  <tr>
                                    <td colspan="6"> </td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=drawList(SESS_LANGUAGE,iCommand,list,orderAktivadetailId, frmSellingAktivaItem, oidSellingAktiva,approot)%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault(SESS_LANGUAGE,"");
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+orderAktivadetailId+"')";
							String sconDelCom = "javascript:cmdDelete('"+orderAktivadetailId+"')";
							String scancel = "javascript:cmdEdit('"+orderAktivadetailId+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);
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
                            if(orderAktiva.getSellingStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
							    out.println(ctrLine.draw(iCommand, iErrCode, msgString));
                            }
							%></td>
                                  </tr>
                                  <!-- <tr align="right">
                                    <td colspan="6"><table width="20%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="20%" scope="row">&nbsp;<b><%=strTitle[SESS_LANGUAGE][7]%></b></td>
                                        <%
                                            double total = PstSellingAktivaItem.getTotalSellingAktivaItem(oidSellingAktiva);
                                        %>
                                        <td width="80%" align="right"><b><%=FRMHandler.userFormatStringDecimal(total)%></b></td>
                                      </tr>
                                    </table></td>
                                  </tr> -->
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="76%" nowrap><%
                            			ControlLine controlLine = new ControlLine();
							controlLine.setLocationImg(approot+"/images");
							controlLine.initDefault(SESS_LANGUAGE,"");
							controlLine.setTableWidth("80%");
							scomDel = "javascript:cmdAskMain('"+oidSellingAktiva+"')";
							sconDelCom = "javascript:cmdConfirmDeleteMain('"+oidSellingAktiva+"')";
							scancel = "javascript:cmdEdit('"+oidSellingAktiva+"')";
                            			strSave = "javascript:cmdSaveMain('"+oidSellingAktiva+"')";
                            			strBack = "javascript:cmdBackMain('"+oidSellingAktiva+"')";
							controlLine.setCommandStyle("command");
							controlLine.setColCommStyle("command");
                            			controlLine.setDeleteCaption("Hapus Selling");
							controlLine.setSaveCommand(strSave);
							controlLine.setDeleteCommand(scomDel);
							controlLine.setConfirmDelCommand(strDelete);
                            			controlLine.setBackCommand(strBack);
                            			//controlLine.setBackCaption(strBack);

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

							if(iCommand == Command.ASK){
								controlLine.setDeleteQuestion(strDelete);
							}
							
							if(iCommand==Command.ADD || iCommand==Command.EDIT || iCommand == Command.ASK){
					  			controlLine.setBackCaption("");
					  			controlLine.setConfirmDelCaption("");
					  			controlLine.setDeleteCaption("");
					  			controlLine.setEditCaption("");
					  			controlLine.setSaveCaption("");								

				    			}

							if(iCommand == Command.SAVE && iErrCode == 0){
								controlLine.setBackCaption("");
								controlLine.setSaveCaption("");
								controlLine.setDeleteCaption("");
							}
							
                            if(orderAktiva.getSellingStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){
                                ctrLine.setBackCaption(strBack);
                                ctrLine.setSaveCaption("");
                                ctrLine.setDeleteCaption("");
                                ctrLine.setAddCaption("");
                            }
							out.println(controlLine.draw(Command.EDIT, 0, ""));
							%></td>
							<%
								if(iCommand==Command.ADD || iCommand==Command.EDIT || iCommand == Command.ASK){%>
									<td>&nbsp;</td>
								<%}else{
							%>
                                        <td width="24%" align="right"><a href="javascript:cmdPosted()" class="command"><%if(orderAktiva.getSellingStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0 && iFixedAssetsModule == 0){%><%=strTitle[SESS_LANGUAGE][10]%><%}%></a></td>
							<%}%>
                                      </tr>
                                    </table></td>
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