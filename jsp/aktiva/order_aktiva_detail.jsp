<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*,
                 com.dimata.aiso.form.aktiva.FrmOrderAktivaItem,
                 com.dimata.aiso.form.aktiva.CtrlOrderAktivaItem,
                 com.dimata.aiso.entity.aktiva.OrderAktivaItem,
                 com.dimata.aiso.form.aktiva.FrmOrderAktiva,
                 com.dimata.interfaces.trantype.I_TransactionType,
                 com.dimata.aiso.entity.aktiva.OrderAktiva,
                 com.dimata.aiso.form.aktiva.CtrlOrderAktiva,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.common.entity.contact.PstContactList,
                 com.dimata.aiso.entity.aktiva.PstOrderAktivaItem" %>
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
		"Nomor Order",
		"Tanggal Order",
		"Supplier",
		"Tipe Transaksi",
		"Perkiraan Pembayaran",
		"Perkiraan Uang Muka",
        "Mata Uang",
        "Total",
        "Uang Muka",
        "Sisa",
        "Posting Order Aktiva"
	},
	{
		"Order Number",
		"Order Date",
		"Supplier",
		"Transaction Type",
		"Payment",
		"Down Payment",
        "Currency",
        "Total",
        "Down Payment",
        "Residue",
        "Posted Order"
	}
};

    public static final String masterTitle[] = {
        "Aktiva Tetap","Fixed Assets"
    };

    public static final String listTitle[] = {
       "Proses Order","Order Process"
    };



/**
* this method used to list jurnal detail
*/
public String drawList(int language, int iCommand,
                                  Vector objectClass, long orderAktivaItemId, FrmOrderAktivaItem frmOrderAktivaItem, String approot){
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
    System.out.println("test "+objectClass);
	for (int i = 0; i < objectClass.size(); i++) {
        Vector vect = (Vector)objectClass.get(i);
		OrderAktivaItem orderAktivaItem = (OrderAktivaItem)vect.get(0);
        Aktiva aktiva = (Aktiva)vect.get(1);

		rowx = new Vector();
		if(orderAktivaItemId == orderAktivaItem.getOID())
		 index = i;

		if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
            rowx.add("<div align=\"center\">"+(i+1)+"</div>");
            rowx.add("<input size=\"10\" type=\"text\" name=\"aktiva_code\" value="+aktiva.getKode()+"><a href =\"javascript:cmdopenitem()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
            rowx.add("<input type=\"hidden\" name=\""+FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_AKTIVA_ID]+"\" value="+orderAktivaItem.getAktivaId()+">"+aktiva.getNama());
            rowx.add("<input size=\"5\" type=\"text\" name=\""+FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_QTY]+"\" onKeyUp = \"javascript:setTotalSubTotal()\" value="+orderAktivaItem.getQty()+">");
            rowx.add("<input size=\"15\" type=\"text\" name=\""+FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_PRICE]+"\" onKeyUp = \"javascript:setTotalSubTotal()\" value="+Formater.formatNumber(orderAktivaItem.getPriceOrder(),"###.##")+">");
            rowx.add("<input size=\"15\" readonly type=\"text\" name=\""+FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_TOTAL_PRICE]+"\" value="+Formater.formatNumber(orderAktivaItem.getTotalPriceOrder(),"###.##")+">");
		 }else{
			rowx.add("<div align=\"center\">"+(i+1)+"</div>");
			rowx.add(aktiva.getKode());
			rowx.add(aktiva.getNama());
            rowx.add("<div align=\"center\">"+orderAktivaItem.getQty()+"</div>");
            rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getPriceOrder())+"</div>");
            rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getTotalPriceOrder())+"</div>");
		 }
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(orderAktivaItem.getOID()));
	 }

	 rowx = new Vector();
	 if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmOrderAktivaItem.errorSize()>0)){
         rowx.add("");
         rowx.add("<input size=\"10\" type=\"text\" name=\"aktiva_code\"><a href =\"javascript:cmdopenitem()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
         rowx.add("<input type=\"hidden\" name=\""+FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_AKTIVA_ID]+"\" value=\"\">"+
                 "<input size=\"60\" readonly type=\"text\" name=\"aktiva_name\">");
         rowx.add("<input size=\"5\" type=\"text\" onKeyUp = \"javascript:setTotalSubTotal()\" name=\""+FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_QTY]+"\" value=\"\">");
         rowx.add("<input size=\"15\" type=\"text\" onKeyUp = \"javascript:setTotalSubTotal()\" name=\""+FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_PRICE]+"\" value=\"\">");
         rowx.add("<input size=\"15\" readonly type=\"text\" name=\""+FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_TOTAL_PRICE]+"\" value=\"\">");
         lstData.add(rowx);
	 }

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
long orderAktivadetailId = FRMQueryString.requestLong(request,"order_aktiva_detail_id");
long oidOrderAktiva = FRMQueryString.requestLong(request,"order_aktiva_id");

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
CtrlOrderAktivaItem ctrlOrderAktivaItem = new CtrlOrderAktivaItem(request);
ctrlOrderAktivaItem.setLanguage(SESS_LANGUAGE);
FrmOrderAktivaItem frmOrderAktivaItem = ctrlOrderAktivaItem.getForm();
OrderAktivaItem orderAktivaItem = ctrlOrderAktivaItem.getOrderAktivaItem();
int iErrCode = ctrlOrderAktivaItem.action(iCommand,orderAktivadetailId);
String msgString = ctrlOrderAktivaItem.getMessage();

// Untuk main order aktiva
ControlLine ctrLine = new ControlLine();
CtrlOrderAktiva ctrlOrderAktiva = new CtrlOrderAktiva(request);
ctrlOrderAktiva.setLanguage(SESS_LANGUAGE);
FrmOrderAktiva frmOrderAktiva = ctrlOrderAktiva.getForm();
int iErrCodexx = ctrlOrderAktiva.action(Command.EDIT,oidOrderAktiva);
OrderAktiva orderAktiva = ctrlOrderAktiva.getOrderAktiva();
    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(orderAktiva.getSupplierId());
    }catch(Exception e){}

    Vector list = PstOrderAktivaItem.getListItem(oidOrderAktiva);
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
	document.frmorderaktiva.action="order_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdSave(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
	document.frmorderaktiva.action="order_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdCancel(){
	document.frmorderaktiva.perkiraan.value=0;
	document.frmorderaktiva.command.value="<%=Command.NONE%>";
	document.frmorderaktiva.action="jumum.jsp";
	document.frmorderaktiva.submit();
}

function cmdEdit(oid){
    document.frmorderaktiva.order_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.prev_command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="order_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdAsk(oid){
    document.frmorderaktiva.order_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.ASK%>";
	document.frmorderaktiva.action="order_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdDelete(oid){
    document.frmorderaktiva.order_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.DELETE%>";
	document.frmorderaktiva.action="order_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdItemData(journalId){
	document.frmorderaktiva.command.value="<%=Command.NONE%>";
	document.frmorderaktiva.journal_id.value=journalId;
	document.frmorderaktiva.action="jumum.jsp";
	document.frmorderaktiva.submit();
}

function cmdBack(){
    document.frmorderaktiva.order_aktiva_detail_id.value = 0;
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="order_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdBackMain(){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="order_aktiva_list.jsp";
	document.frmorderaktiva.submit();
}

function cmdSaveMain(oid){
    document.frmorderaktiva.order_aktiva_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
	document.frmorderaktiva.action="order_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdPosted(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
    document.frmorderaktiva.<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ORDER_STATUS]%>.value = "<%=I_DocStatus.DOCUMENT_STATUS_POSTED%>";
    document.frmorderaktiva.posted_status.value="1";
	document.frmorderaktiva.action="order_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdAskMain(oid){
    document.frmorderaktiva.order_aktiva_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.ASK%>";
	document.frmorderaktiva.action="order_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function setTotalSubTotal(){
    var qty = document.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_QTY]%>.value;
    var price = document.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_PRICE]%>.value;
    var stotal = parseFloat(qty) * parseFloat(price);
    if(isNaN(stotal)){
        stotal = 0;
    }
    document.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_TOTAL_PRICE]%>.value = stotal;
}

function cmdopenitem(){
    window.open("modul_aktiva_search.jsp","search_aktiva","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdopen(){
    window.open("srccontact_list.jsp","search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdChangeCurr(){
    var id = Math.abs(document.frmorderaktiva.<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ID_CURRENCY]%>.value);
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
        document.frmorderaktiva.<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_VALUE_RATE]%>.value="<%=FrmOrderAktiva.userFormatStringDecimal(rate)%>"
        break;
                    <%
                }
}
									  %>
    default :
        document.frmorderaktiva.<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_VALUE_RATE]%>.value="<%=FrmOrderAktiva.userFormatStringDecimal(1.0)%>"
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
              <input type="hidden" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_SUPPLIER_ID]%>" value="<%=orderAktiva.getSupplierId()%>">
              <input type="hidden" name="<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_ORDER_AKTIVA_ID]%>" value="<%=oidOrderAktiva%>">
              <input type="hidden" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ORDER_STATUS]%>" value="<%=orderAktiva.getOrderStatus()%>">
              <input type="hidden" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_VALUE_RATE]%>" value="<%=orderAktiva.getValueRate()%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="posted_status" value="0">
              <input type="hidden" name="order_aktiva_id" value="<%=oidOrderAktiva%>">
              <input type="hidden" name="order_aktiva_detail_id" value="<%=orderAktivadetailId%>">
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
                                    <td width="18%" height="25">&nbsp;<b><%=strTitle[SESS_LANGUAGE][0]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
                                      <input type="hidden" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_NOMOR_ORDER]%>" value="<%=orderAktiva.getNomorOrder()%>" size="35">
                                      <%=orderAktiva.getNomorOrder()%> </td>
                                    <td width="21%" height="25"><b><%=strTitle[SESS_LANGUAGE][3]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
									<%=I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][orderAktiva.getTypePembayaran()]%>
									<%
									   Vector trantypeid_value = new Vector(1,1);
									   Vector trantypeid_key = new Vector(1,1);
									   String sel_trantypeid = ""+orderAktiva.getTypePembayaran();
                                        for(int i=0;i<I_TransactionType.arrTransactionTypeNames.length;i++){
                                            trantypeid_value.add(I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][i]);
                                            trantypeid_key.add(""+i);
                                        }
									  %>
                                        <%//= ControlCombo.draw(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TYPE_PEMBAYARAN],null, sel_trantypeid, trantypeid_key, trantypeid_value, "", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<b><%=strTitle[SESS_LANGUAGE][1]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25"><%=orderAktiva.getTanggalOrder()%>
                                      <%
                                        /*Date dtTransactionDate = orderAktiva.getTanggalOrder();
                                        if(dtTransactionDate ==null)
                                        {
                                            dtTransactionDate = new Date();
                                        }
                                        out.println(ControlDate.drawDate(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER], dtTransactionDate, 4, -5));*/
									%>
                                    </td>
                                    <td width="21%" height="25"><b><%=strTitle[SESS_LANGUAGE][4]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
										<%
											Perkiraan objPerkiraan = new Perkiraan();
											if(orderAktiva.getIdPerkiraanPayment() != 0){
												objPerkiraan = PstPerkiraan.fetchExc(orderAktiva.getIdPerkiraanPayment());
												out.println(objPerkiraan.getNama());
											}
										%>
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
									   String sel_perkiraanPayid = ""+orderAktiva.getIdPerkiraanPayment();
                                          /*
                                       String whereClause  = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS+
                                               " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
                                            */
                                       String whereClause  = PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
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
									   Vector lPayment = PstPerkiraan.list(0,0,whereClause,PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN]);
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
                                      <%//= ControlCombo.draw(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ID_PERKIRAAN_PAYMENT],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<b><%=strTitle[SESS_LANGUAGE][2]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25"><%=contactList.getCompName()%>
                                      <!-- input readonly type="text" name="<%//=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_SUPPLIER_ID]%>_TEXT" value="<%//=contactList.getCompName()%>" size="35" -->
                                &nbsp;</td>
                                    <td width="21%" height="25"><b><%=strTitle[SESS_LANGUAGE][5]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
										<%
											Perkiraan oPerkiraan = new Perkiraan();
											if(orderAktiva.getIdPerkiraanDp() != 0){
												oPerkiraan = PstPerkiraan.fetchExc(orderAktiva.getIdPerkiraanDp());
												out.println(oPerkiraan.getNama());
											}
										%>
                                      <%

									   perkiraanPayid_value = new Vector(1,1);
									   perkiraanPayid_key = new Vector(1,1);
                                       whereClause  = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS+
                                               " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
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

									   sel_perkiraanPayid = ""+orderAktiva.getIdPerkiraanDp();
									  %>
                                      <%//= ControlCombo.draw(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ID_PERKIRAAN_DP],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<b><%=strTitle[SESS_LANGUAGE][6]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
										<%
											 CurrencyType currencyType = new CurrencyType();
											 String strCurrencyName = "";
											 if(orderAktiva.getIdCurrency() != 0){
											 	currencyType = PstCurrencyType.fetchExc(orderAktiva.getIdCurrency());
												strCurrencyName = currencyType.getName();
												out.println(strCurrencyName);
											 }
										%>

                                      <%//= ControlCombo.draw(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ID_CURRENCY],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value, "", "") %> </td>
                                    <td width="21%" height="25">&nbsp;</td>
                                    <td width="1%" height="25">&nbsp;</td>
                                    <td width="27%" height="25">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"> </td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=drawList(SESS_LANGUAGE,iCommand,list,orderAktivadetailId, frmOrderAktivaItem,approot)%></td>
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
                            if(orderAktiva.getOrderStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
                                out.println(ctrLine.draw(iCommand, iErrCode, msgString));
                            }

							%></td>
                                  </tr>
                                  <tr align="right">
                                    <td colspan="6"><table width="40%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="40%" scope="row">&nbsp;<%=strTitle[SESS_LANGUAGE][7]%></td>
                                        <%
                                            double total = PstOrderAktivaItem.getTotalOrderAktivaItem(oidOrderAktiva);
                                        %>
                                        <td width="60%" align="right"><b><%=FRMHandler.userFormatStringDecimal(total)%></b></td>
                                      </tr>
                                      <tr>
                                        <td scope="row">&nbsp;<%=strTitle[SESS_LANGUAGE][8]%></td>
                                        <td align="right"><input type="text" name="<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_DOWN_PAYMENT]%>" value="<%=FRMHandler.userFormatStringDecimal(orderAktiva.getDownPayment())%>" class="txtalign"></td>
                                      </tr>
                                      <tr>
                                        <td scope="row">&nbsp;<%=strTitle[SESS_LANGUAGE][9]%></td>
                                        <td align="right"><b><%=FRMHandler.userFormatStringDecimal(total - orderAktiva.getDownPayment())%></b></td>
                                      </tr>
                                    </table></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="76%" nowrap scope="row"><%
                            ControlLine controlLine = new ControlLine();
							controlLine.initDefault(SESS_LANGUAGE,"");
							controlLine.setLocationImg(approot+"/images");
							controlLine.initDefault();
							controlLine.setTableWidth("80%");
							scomDel = "javascript:cmdAskMain('"+oidOrderAktiva+"')";
							sconDelCom = "javascript:cmdConfirmDeleteMain('"+oidOrderAktiva+"')";
							scancel = "javascript:cmdEdit('"+oidOrderAktiva+"')";
                            strSave = "javascript:cmdSaveMain('"+oidOrderAktiva+"')";
                            strBack = "javascript:cmdBackMain('"+oidOrderAktiva+"')";
							controlLine.setCommandStyle("command");
							controlLine.setColCommStyle("command");
                            controlLine.setDeleteCaption("Hapus Order");
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

                            if(orderAktiva.getOrderStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){
                                //controlLine.setBackCaption(strBack);
                                controlLine.setSaveCaption("");
                                controlLine.setDeleteCaption("");
                                controlLine.setAddCaption("");
                            }
							
							//if((iCommand == Command.SAVE && iErrCode == 0) || iCommand == Command.ADD || iCommand == Command.LIST){
								controlLine.setSaveCaption("");
                                controlLine.setDeleteCaption("");
								controlLine.setBackCaption("");
							//}
							
							out.println(controlLine.draw(Command.EDIT, 0, ""));
							%></td>
                                        <td width="24%" align="right"><a href="javascript:cmdPosted()" class="command"><%if(orderAktiva.getOrderStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0 && iFixedAssetsModule == 0){%><%=strTitle[SESS_LANGUAGE][10]%><%}%></a> </td>
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