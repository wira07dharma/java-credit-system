<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.aiso.form.aktiva.FrmOrderAktiva,
                   com.dimata.aiso.form.aktiva.CtrlOrderAktiva,
                   com.dimata.aiso.entity.aktiva.OrderAktiva,
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
                   com.dimata.aiso.form.aktiva.FrmOrderAktivaItem,
                   com.dimata.gui.jsp.ControlList,
                   com.dimata.aiso.entity.aktiva.OrderAktivaItem,
                   com.dimata.aiso.entity.masterdata.Aktiva,
                   com.dimata.aiso.entity.aktiva.PstOrderAktivaItem,
                   com.dimata.aiso.session.aktiva.SessOrderAktiva,
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
        "Donw Payment",
        "Residue",
        "Posted Order"
	}
};

    public static String strItemTitle[][] = {
	{
	"No","Kode","Nama","Qty","Harga","Total Harga"
	},

	{
	"No","Code","Name","Qty","Price","Total Price"
	}
};

public static final String masterTitle[] = {
	"Aktiva Tetap","Fixed Assets"
};

public static final String listTitle[] = {
	"Proses Order","Order Process"
};

public String drawList(int language, Vector objectClass){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strItemTitle[language][0],"3%","left","left"); // no
    ctrlist.dataFormat(strItemTitle[language][1],"8%","left","left"); // kode
    ctrlist.dataFormat(strItemTitle[language][2],"35%","left","left"); // nama
    ctrlist.dataFormat(strItemTitle[language][3],"5%","left","left"); // qty
    ctrlist.dataFormat(strItemTitle[language][4],"8%","left","left"); // harga
    ctrlist.dataFormat(strItemTitle[language][5],"8%","left","left"); // total harga

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditDetail('");
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
        rowx.add(""+(i+1));
        rowx.add(aktiva.getKode());
        rowx.add(aktiva.getNama());
        rowx.add(""+orderAktivaItem.getQty());
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getPriceOrder())+"</div>");
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getTotalPriceOrder())+"</div>");

        lstData.add(rowx);
        lstLinkData.add(String.valueOf(orderAktivaItem.getOID()));
    }
    return ctrlist.drawMe(index);
}
/**
* this method used to list jurnal detail
*/
%>


<!-- JSP Block -->
<%
// get request from hidden text
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE ORDER AKTIVA PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES ORDER AKTIVA SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int index = FRMQueryString.requestInt(request,"index");

int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidOrderAktiva = FRMQueryString.requestLong(request,"order_aktiva_id");
int posTed = FRMQueryString.requestInt(request,"posted_status");

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New" : "Tambah Baru";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : " Tambah Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Order List" : "Kembali Ke Daftar Order";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Order" : "Hapus Order";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete" : "Ya Hapus Order";

/** Instansiasi object CtrlOrderAktiva and FrmOrderAktiva */
ControlLine ctrLine = new ControlLine();
CtrlOrderAktiva ctrlOrderAktiva = new CtrlOrderAktiva(request);
ctrlOrderAktiva.setLanguage(SESS_LANGUAGE);
FrmOrderAktiva frmOrderAktiva = ctrlOrderAktiva.getForm();
int iErrCode = ctrlOrderAktiva.action(iCommand, oidOrderAktiva);
OrderAktiva orderAktiva = ctrlOrderAktiva.getOrderAktiva();
oidOrderAktiva = orderAktiva.getOID();
String msgString = ctrlOrderAktiva.getMessage();

    // get nama company
    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(orderAktiva.getSupplierId());
    }catch(Exception e){}
    if(iCommand==Command.NONE)
        iCommand = Command.ADD;
    else if(iCommand==Command.SAVE && iErrCode == 0)
        iCommand = Command.EDIT;

     Vector list = PstOrderAktivaItem.getListItem(oidOrderAktiva);

    if(posTed!=0){
        SessOrderAktiva sessOrderAktiva = new SessOrderAktiva();
        sessOrderAktiva.postingOrderAktiva(accountingBookType,userOID,currentPeriodOid,oidOrderAktiva);
    }
/** if Command.DELETE, delete journal and its descendant and redirect to journal detail page */
if(iCommand==Command.DELETE){
%>
	<jsp:forward page="order_aktiva_list.jsp">
	<jsp:param name="start" value="<%=start%>"/>
	<jsp:param name="command" value="<%=Command.LIST%>"/>
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
<%if((privView)&&(privAdd)&&(privSubmit)){%>
function getThn()
{
	var date1 = ""+document.frmorderaktiva.<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.frmorderaktiva.<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER] + "_mn"%>.value=bln;
	document.frmorderaktiva.<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER] + "_dy"%>.value=hri;
	document.frmorderaktiva.<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER] + "_yr"%>.value=thn;		
				
}

function addNewDetail(){
	document.frmorderaktiva.perkiraan.value=0;
	document.frmorderaktiva.index.value=-1;
	document.frmorderaktiva.command.value="<%=Command.ADD%>";
	document.frmorderaktiva.prev_command.value="<%=Command.ADD%>";
	document.frmorderaktiva.action="jdetail.jsp";
	document.frmorderaktiva.submit();
}

function addNew(){
	document.frmorderaktiva.journal_id.value="0";
	document.frmorderaktiva.command.value="<%=Command.ADD%>";
	document.frmorderaktiva.action="jdetail.jsp";
	document.frmorderaktiva.submit();
}

function cmdCancel(){
	document.frmorderaktiva.command.value="<%=Command.NONE%>";
	document.frmorderaktiva.action="jumum.jsp";
	document.frmorderaktiva.submit();
}

function cmdSave(){
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

function cmdAsk(){
	document.frmorderaktiva.command.value="<%=Command.ASK%>";
	document.frmorderaktiva.action="order_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdEdit(oid){
	document.frmorderaktiva.order_aktiva_id.value=oid;
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="order_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdDelete(oid){
	document.frmorderaktiva.order_aktiva_id.value=oid;
	document.frmorderaktiva.command.value="<%=Command.DELETE%>";
	document.frmorderaktiva.action="order_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdEditItem(oid){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="order_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdAddDetail(oid){
    document.frmorderaktiva.order_aktiva_id.value=oid;
	document.frmorderaktiva.command.value="<%=Command.ADD%>";
	document.frmorderaktiva.action="order_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdEditDetail(oid){
    document.frmorderaktiva.order_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="order_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

    <%}%>

function cmdBack(){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.start.value="<%=start%>";
	document.frmorderaktiva.action="order_aktiva_list.jsp";
	document.frmorderaktiva.submit();
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

function hideObjectForDate(){
	document.frmorderaktiva.<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ID_CURRENCY]%>.style.display="none";
  }
	
  function showObjectForDate(){
  	document.frmorderaktiva.<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ID_CURRENCY]%>.style.display="";
  }	
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
		  <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmorderaktiva" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_SUPPLIER_ID]%>" value="<%=orderAktiva.getSupplierId()%>">
              <input type="hidden" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ORDER_STATUS]%>" value="<%=orderAktiva.getOrderStatus()%>">
              <input type="hidden" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_VALUE_RATE]%>" value="<%=orderAktiva.getValueRate()%>">
              <input type="hidden" name="order_aktiva_id" value="<%=oidOrderAktiva%>">
              <input type="hidden" name="order_aktiva_detail_id" value="0">
              <input type="hidden" name="posted_status" value="0">
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
                                    <td width="18%" height="25">&nbsp;<b><%=strTitle[SESS_LANGUAGE][0]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<input type="hidden" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_NOMOR_ORDER]%>" value="<%=orderAktiva.getNomorOrder()%>" size="35"><%=orderAktiva.getNomorOrder()%>
									</td>
                                    <td width="21%" height="25"><b><%=strTitle[SESS_LANGUAGE][3]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%
									   Vector trantypeid_value = new Vector(1,1);
									   Vector trantypeid_key = new Vector(1,1);
									   String sel_trantypeid = ""+orderAktiva.getTypePembayaran();
                                        for(int i=0;i<I_TransactionType.arrTransactionTypeNames.length;i++){
                                            trantypeid_value.add(I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][i]);
                                            trantypeid_key.add(""+i);
                                        }
									  %>
                                      <%= ControlCombo.draw(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TYPE_PEMBAYARAN],null, sel_trantypeid, trantypeid_key, trantypeid_value, "", "") %>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<b><%=strTitle[SESS_LANGUAGE][1]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<%/*
                                        Date dtTransactionDate = orderAktiva.getTanggalOrder();
                                        if(dtTransactionDate ==null)
                                        {
                                            dtTransactionDate = new Date();
                                        }
                                        out.println(ControlDate.drawDate(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER], dtTransactionDate, 4, -5));
									*/%>
									<%if(isUseDatePicker.equalsIgnoreCase("Y")){%>
                                          <input onClick="ds_sh(this);" name="<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((orderAktiva.getTanggalOrder() == null) ? new Date() : orderAktiva.getTanggalOrder(), "dd-MM-yyyy")%>"/>
                                          <input type="hidden" name="<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER] + "_mn"%>">
                                          <input type="hidden" name="<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER] + "_dy"%>">
                                          <input type="hidden" name="<%=frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_TANGGAL_ORDER] + "_yr"%>">
                                          <script language="JavaScript" type="text/JavaScript">getThn();</script>
                                          <%}%>		
                                    </td>
                                    <td width="21%" height="25"><b><%=strTitle[SESS_LANGUAGE][4]%></b></td>
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
                                      <%= ControlCombo.draw(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ID_PERKIRAAN_PAYMENT],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<b><%=strTitle[SESS_LANGUAGE][2]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<%
										String companyName = contactList.getCompName();
										if(companyName.length() > 0 && companyName != null){									
										
									%>
                                    <input readonly type="text" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_SUPPLIER_ID]%>_TEXT" value="<%=contactList.getCompName()%>">&nbsp;<a href="javascript:cmdopen()"><img alt="search contact" border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
									<%}else{%>
										<input readonly type="text" name="<%=FrmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_SUPPLIER_ID]%>_TEXT" value="<%=contactList.getPersonName()%>">&nbsp;<a href="javascript:cmdopen()"><img alt="search contact" border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
									<%}%>
                                    </td>
                                    <td width="21%" height="25"><b><%=strTitle[SESS_LANGUAGE][5]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
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
                                      <%= ControlCombo.draw(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ID_PERKIRAAN_DP],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<b><%=strTitle[SESS_LANGUAGE][6]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
                                      <%= ControlCombo.draw(frmOrderAktiva.fieldNames[FrmOrderAktiva.FRM_ID_CURRENCY],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value, "", "") %>                                    </td>
                                    <td width="21%" height="25">&nbsp;</td>
                                    <td width="1%" height="25">&nbsp;</td>
                                    <td width="27%" height="25">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">
									<%if(list != null && list.size() > 0){%>	
										<%=drawList(SESS_LANGUAGE,list)%>
									<%}%>	
									</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%
                                        if(orderAktiva.getOrderStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
										  if((iCommand==Command.EDIT) || (iCommand==Command.SAVE && iErrCode==0) || (iCommand==Command.LIST)){
                                            out.println("<a href=\"javascript:cmdAddDetail('"+oidOrderAktiva+"')\" class=\"command\">"+strAddDetail+"</a>");
                                          }
                                        }
									  %></td>
                                  </tr>
                                  <tr align="right">
								  	<%if(list != null && list.size() > 0){%>
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
									<%}%>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="76%" nowrap scope="row"><%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault(SESS_LANGUAGE,"");
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidOrderAktiva+"')";
							String sconDelCom = "javascript:cmdDelete('"+oidOrderAktiva+"')";
							String scancel = "javascript:cmdEdit('"+oidOrderAktiva+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);
							ctrLine.setBackCaption(strBack);
							//ctrLine.setSaveCaption(strSave);
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
                            if(orderAktiva.getOrderStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){
                                ctrLine.setBackCaption(strBack);
                                ctrLine.setSaveCaption("");
                                ctrLine.setDeleteCaption("");
                                ctrLine.setAddCaption("");
                            }
							if(iCommand == Command.SAVE && iErrCode == 0){
								ctrLine.setBackCaption("");
                                ctrLine.setSaveCaption("");
                                ctrLine.setDeleteCaption("");
							}
							
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							%></td>
                                        <td width="24%" align="right"><a href="javascript:cmdPosted()" class="command"><%if(orderAktiva.getOrderStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0){%><%=strTitle[SESS_LANGUAGE][10]%><%}%></a></td>
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
<%//}%>
