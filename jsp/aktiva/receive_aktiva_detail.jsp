<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*,
                 com.dimata.interfaces.trantype.I_TransactionType,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.common.entity.contact.PstContactList,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.aiso.form.aktiva.FrmReceiveAktivaItem,
                 com.dimata.aiso.entity.masterdata.Aktiva,
                 com.dimata.util.Command,
                 com.dimata.util.Formater,
                 com.dimata.aiso.form.aktiva.CtrlReceiveAktivaItem,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.form.aktiva.CtrlReceiveAktiva,
                 com.dimata.aiso.form.aktiva.FrmReceiveAktiva,
                 com.dimata.gui.jsp.ControlDate,
                 com.dimata.gui.jsp.ControlCombo,
                 com.dimata.common.entity.payment.PstCurrencyType,
                 com.dimata.common.entity.payment.CurrencyType,
                 com.dimata.aiso.entity.masterdata.PstPerkiraan,
                 com.dimata.aiso.entity.masterdata.Perkiraan,
                 com.dimata.aiso.entity.aktiva.*,
                 com.dimata.aiso.entity.masterdata.ModulAktiva" %>
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
		"Nomor Terima",
		"Tanggal Terima",
		"Supplier",
		"Tipe Transaksi",
		"Perkiraan Pembayaran",
		"Perkiraan Uang Muka",
        "Mata Uang",
        "Total",
        "Uang Muka",
        "Sisa",
		"Nomor Order",
		"Nomor Nota",
        "Posting ke Jurnal"
	},
	{
		"Receive Number",
		"Receive Date",
		"Supplier",
		"Transaction Type",
		"Payment",
		"Down Payment",
        "Currency",
        "Total",
        "Down Payment",
        "Balance",
		"Receive Number",
		"Invoice Number",
        "Posting Jurnal"
	}
};

    public static final String masterTitle[] = {
        "Aktiva Tetap","Fixed Assets"
    };

    public static final String listTitle[] = {
       "Proses Terima","Receive Process"
    };



/**
* this method used to list jurnal detail
*/
public String drawList(int language, int iCommand,
                                  Vector objectClass, long orderAktivaItemId, FrmReceiveAktivaItem frmReceiveAktivaItem, String approot){
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
		ReceiveAktivaItem orderAktivaItem = (ReceiveAktivaItem)vect.get(0);
        ModulAktiva aktiva = (ModulAktiva)vect.get(1);

		rowx = new Vector();
		if(orderAktivaItemId == orderAktivaItem.getOID())
		 index = i;

		if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
            rowx.add(""+(i+1));
            rowx.add("<input size=\"10\" type=\"text\" name=\"aktiva_code\" value="+aktiva.getKode()+"><a href =\"javascript:cmdopenitem()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
            rowx.add("<input type=\"hidden\" name=\""+FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_AKTIVA_ID]+"\" value="+orderAktivaItem.getAktivaId()+">"+aktiva.getName());
            rowx.add("<input size=\"5\" type=\"text\" name=\""+FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_QTY]+"\" onKeyUp = \"javascript:setTotalSubTotal()\" value="+orderAktivaItem.getQty()+">");
            rowx.add("<input size=\"15\" type=\"text\" name=\""+FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_PRICE]+"\" onKeyUp = \"javascript:setTotalSubTotal()\" value="+Formater.formatNumber(orderAktivaItem.getPriceReceive(),"###.##")+">");
            rowx.add("<input size=\"15\" readonly type=\"text\" name=\""+FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_TOTAL_PRICE]+"\" value="+Formater.formatNumber(orderAktivaItem.getTotalPriceReceive(),"###.##")+">");
		 }else{
			rowx.add("<div align=\"center\">"+(i+1)+"</div>");
			rowx.add(aktiva.getKode());
			rowx.add(aktiva.getName());
            rowx.add("<div align=\"right\">"+orderAktivaItem.getQty()+"</div>");
            rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getPriceReceive())+"</div>");
            rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getTotalPriceReceive())+"</div>");
		 }
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(orderAktivaItem.getOID()));
	 }

	 rowx = new Vector();
	 if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmReceiveAktivaItem.errorSize()>0)){
         rowx.add("");
         rowx.add("<input size=\"10\" type=\"text\" name=\"aktiva_code\"><a href =\"javascript:cmdopenitem()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
         rowx.add("<input type=\"hidden\" name=\""+FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_AKTIVA_ID]+"\" value=\"\">"+
                 "<input size=\"60\" readonly type=\"text\" name=\"aktiva_name\">");
         rowx.add("<input size=\"5\" type=\"text\" onKeyUp = \"javascript:setTotalSubTotal()\" name=\""+FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_QTY]+"\" value=\"\">");
         rowx.add("<input size=\"15\" type=\"text\" onKeyUp = \"javascript:setTotalSubTotal()\" name=\""+FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_PRICE]+"\" value=\"\">");
         rowx.add("<input size=\"15\" readonly type=\"text\" name=\""+FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_TOTAL_PRICE]+"\" value=\"\">");
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
long receiveAktivadetailId = FRMQueryString.requestLong(request,"receive_aktiva_detail_id");
long oidReceiveAktiva = FRMQueryString.requestLong(request,"hidden_receive_aktiva_id");

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

    //System.out.println("oidReceiveAktiva : "+oidReceiveAktiva);

// Instansiasi CtrlJurnalDetail and FrmJurnalDetail
CtrlReceiveAktivaItem ctrlReceiveAktivaItem = new CtrlReceiveAktivaItem(request);
ctrlReceiveAktivaItem.setLanguage(SESS_LANGUAGE);
FrmReceiveAktivaItem frmReceiveAktivaItem = ctrlReceiveAktivaItem.getForm();
ReceiveAktivaItem receiveAktivaItem = ctrlReceiveAktivaItem.getReceiveAktivaItem();
int iErrCode = ctrlReceiveAktivaItem.action(iCommand,receiveAktivadetailId);
String msgString = ctrlReceiveAktivaItem.getMessage();
       //System.out.println("oidReceiveAktiva oidReceiveAktiva : "+oidReceiveAktiva);
// Untuk main receive aktiva
ControlLine ctrLine = new ControlLine();
CtrlReceiveAktiva ctrlReceiveAktiva = new CtrlReceiveAktiva(request);
ctrlReceiveAktiva.setLanguage(SESS_LANGUAGE);
FrmReceiveAktiva frmReceiveAktiva = ctrlReceiveAktiva.getForm();
int iErrCodexx = ctrlReceiveAktiva.action(Command.EDIT,oidReceiveAktiva);
ReceiveAktiva receiveAktiva = ctrlReceiveAktiva.getReceiveAktiva();
    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(receiveAktiva.getSupplierId());
    }catch(Exception e){}
    OrderAktiva odrAktiva = new OrderAktiva();
    try{
        odrAktiva = PstOrderAktiva.fetchExc(receiveAktiva.getOrderAktivaId());
    }catch(Exception e){}

    Vector list = PstReceiveAktivaItem.getListItem(oidReceiveAktiva);
    // ini untuk mengisi data perkiraan pembayaran
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

    Vector lPayment = new Vector();
    /*String whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS+
           " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
           */
    String whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+"="+PstPerkiraan.ACC_POSTED;
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
    Vector lPaymentCmb = PstPerkiraan.list(0,0,whereClause, PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN]);
    whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES+
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
    Vector lPaymentHtLancar = PstPerkiraan.list(0,0,whereClause,PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN]);
    if(receiveAktiva.getTypePembayaran()==I_TransactionType.TIPE_TRANSACTION_KREDIT){
       lPayment = lPaymentHtLancar;
    }else{
        lPayment = lPaymentCmb;
    }
    // --------------

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
	document.frmorderaktiva.action="receive_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdSave(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
	document.frmorderaktiva.action="receive_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdEdit(oid){
    document.frmorderaktiva.receive_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.prev_command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="receive_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdAsk(oid){
    document.frmorderaktiva.receive_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.ASK%>";
	document.frmorderaktiva.action="receive_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdDelete(oid){
    document.frmorderaktiva.receive_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.DELETE%>";
	document.frmorderaktiva.action="receive_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdItemData(journalId){
	document.frmorderaktiva.command.value="<%=Command.NONE%>";
	document.frmorderaktiva.journal_id.value=journalId;
	document.frmorderaktiva.action="jumum.jsp";
	document.frmorderaktiva.submit();
}

function cmdBack(){
    document.frmorderaktiva.receive_aktiva_detail_id.value = 0;
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="receive_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdSaveMain(oid){
    document.frmorderaktiva.hidden_receive_aktiva_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
	document.frmorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdPosted(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_RECEIVE_STATUS]%>.value = "<%=I_DocStatus.DOCUMENT_STATUS_POSTED%>";
    document.frmorderaktiva.posted_status.value="1";
	document.frmorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdAskMain(oid){
    document.frmorderaktiva.hidden_receive_aktiva_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.ASK%>";
	document.frmorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}
function cmdBackMain(){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="receive_aktiva_list.jsp";
	document.frmorderaktiva.submit();
}

function cmdclear(){
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>.value = 0;
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>_TEXT.value = "";
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]%>.value = 0;
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]%>_TEXT.value = 0;
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_DOWN_PAYMENT]%>.value = "0";
}

function setTotalSubTotal(){
    var qty = document.frmorderaktiva.<%=FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_QTY]%>.value;
    var price = document.frmorderaktiva.<%=FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_PRICE]%>.value;
    var stotal = parseFloat(qty) * parseFloat(price);
    if(isNaN(stotal)){
        stotal = 0;
    }
    document.frmorderaktiva.<%=FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_TOTAL_PRICE]%>.value = stotal;
}

function cmdopenitem(){
    window.open("modul_aktiva_search.jsp","search_aktiva","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdopen(){
    window.open("srccontact_list.jsp","search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdopenorder(){
    window.open("receive_order_aktiva_search.jsp","search_order_receive","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdChange(){
	var n = document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_TYPE_PEMBAYARAN]%>.value;
	switch(n){
		case "<%=I_TransactionType.TIPE_TRANSACTION_CASH%>" :
			 for(var j=document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.length-1; j>-1; j--){
				document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.options.remove(j);
			 }
			 <%
                 if(lPaymentCmb!=null && lPaymentCmb.size()>0){
                    for(int k=0; k<lPaymentCmb.size(); k++){
                       Perkiraan perkiraan = (Perkiraan)lPaymentCmb.get(k);
				%>

				var oOption = document.createElement("OPTION");
				oOption.value = "<%=perkiraan.getOID()%>";
				oOption.text = "<%=perkiraan.getNama()%>";
				document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.add(oOption);
				<%
                    }
                 }
			 %>
			 break;
		case "<%=I_TransactionType.TIPE_TRANSACTION_KREDIT%>" :
			 for(var j=document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.length-1; j>-1; j--){
				document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.options.remove(j);
			 }
			 <%
                     if(lPaymentHtLancar!=null && lPaymentHtLancar.size()>0){
                        for(int k=0; k<lPaymentHtLancar.size(); k++){
                           Perkiraan perkiraan = (Perkiraan)lPaymentHtLancar.get(k);
				%>

				var oOption = document.createElement("OPTION");
				oOption.value = "<%=perkiraan.getOID()%>";
				oOption.text = "<%=perkiraan.getNama()%>";
				document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.add(oOption);
				<%
                        }
                     }
			 %>
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
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_SUPPLIER_ID]%>" value="<%=receiveAktiva.getSupplierId()%>">
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>" value="<%=receiveAktiva.getOrderAktivaId()%>">
              <input type="hidden" name="<%=FrmReceiveAktivaItem.fieldNames[FrmReceiveAktivaItem.FRM_RECEIVE_AKTIVA_ID]%>" value="<%=oidReceiveAktiva%>">
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]%>" value="<%=receiveAktiva.getIdPerkiraanDp()%>">
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_RECEIVE_STATUS]%>" value="<%=receiveAktiva.getReceiveStatus()%>">
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_VALUE_RATE]%>" value="<%=FrmReceiveAktiva.userFormatStringDecimal(receiveAktiva.getValueRate())%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="posted_status" value="0">
              <input type="hidden" name="hidden_receive_aktiva_id" value="<%=oidReceiveAktiva%>">
              <input type="hidden" name="receive_aktiva_detail_id" value="<%=receiveAktivadetailId%>">
              <table width="100%" breceive="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table breceive="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%" height="2">&nbsp;
                        </td>
                      </tr>
                      <tr>
                        <td width="100%" class="tabtitleactive">
                          <table width="100%" breceive="0" cellpadding="0" cellspacing="0" height="25">
                            <tr>
                              <td width="3%" valign="top"></td>
                              <td width="94%">
                                <table width="100%">
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][0]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
                                      <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_NOMOR_RECEIVE]%>" value="<%=receiveAktiva.getNomorReceive()%>" size="35">
                                      <%=receiveAktiva.getNomorReceive()%> </td>
                                    <td width="21%" height="25" nowrap><b><%=strTitle[SESS_LANGUAGE][3]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
									<%
										out.println(I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][receiveAktiva.getTypePembayaran()]);
									%>
									<%
									   Vector trantypeid_value = new Vector(1,1);
									   Vector trantypeid_key = new Vector(1,1);
									   String sel_trantypeid = ""+receiveAktiva.getTypePembayaran();
                                        for(int i=0;i<I_TransactionType.arrTransactionTypeNames.length;i++){
                                            trantypeid_value.add(I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][i]);
                                            trantypeid_key.add(""+i);
                                        }
									  %>
                                        <%//= ControlCombo.draw(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_TYPE_PEMBAYARAN],null, sel_trantypeid, trantypeid_key, trantypeid_value, "onChange=\"javascript:cmdChange()\"", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][1]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									  <%
									  	if(receiveAktiva.getTanggalReceive() != null){
											out.println(Formater.formatDate(receiveAktiva.getTanggalReceive(),"dd MMM yyyy"));
										}else{
											out.println(Formater.formatDate(new Date(),"dd MMM yyyy"));
										}
									  %>
                                      <%
                                        Date dtTransactionDate = receiveAktiva.getTanggalReceive();
                                        if(dtTransactionDate ==null)
                                        {
                                            dtTransactionDate = new Date();
                                        }
                                        //out.println(ControlDate.drawDate(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_TANGGAL_RECEIVE], dtTransactionDate, 4, -5));
									%>
                                    </td>
                                    <td height="25" nowrap><b><%=strTitle[SESS_LANGUAGE][6]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
										<%
											CurrencyType currType = new CurrencyType();
											if(receiveAktiva.getIdCurrency() != 0){
												currType = PstCurrencyType.fetchExc(receiveAktiva.getIdCurrency());
												out.println(currType.getName());
											}
										%>
                                      <%
									   Vector currencytypeid_value = new Vector(1,1);
									   Vector currencytypeid_key = new Vector(1,1);
									   String sel_currencytypeid = ""+receiveAktiva.getIdCurrency();
                                       String receiveBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
                                       Vector listCurrencyType = PstCurrencyType.list(0,0,"",receiveBy);
									   if(listCurrencyType!=null&&listCurrencyType.size()>0){
											for(int i=0;i<listCurrencyType.size();i++){
												CurrencyType currencyType =(CurrencyType)listCurrencyType.get(i);
												currencytypeid_value.add(currencyType.getName()+"("+currencyType.getCode()+")");
												currencytypeid_key.add(""+currencyType.getOID());
											}
									   }
									  %>
                                      <%//= ControlCombo.draw(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_CURRENCY],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value, "", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][2]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
										<%=contactList.getCompName()%>
                                      <!-- input readonly type="text" name="<%//=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_SUPPLIER_ID]%>_TEXT" value="<%//=contactList.getCompName()%>" size="30" -->
                               		 </td>
                                    <td height="25" nowrap><b><%=strTitle[SESS_LANGUAGE][4]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
										<%
											Perkiraan objPrk = new Perkiraan();
											if(receiveAktiva.getIdPerkiraanPayment() != 0){
												try{
													objPrk = PstPerkiraan.fetchExc(receiveAktiva.getIdPerkiraanPayment());	
													out.println(objPrk.getNama());
												}catch(Exception e){}
											}
										%>
                                      <%
									   Vector perkiraanPayid_value = new Vector(1,1);
									   Vector perkiraanPayid_key = new Vector(1,1);
									   String sel_perkiraanPayid = ""+receiveAktiva.getIdPerkiraanPayment();
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
                                      <%//= ControlCombo.draw(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][10]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
										<%out.println(odrAktiva.getNomorOrder());%>
                                      <!-- input readonly type="text" name="<%//=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>_TEXT" value="<%//=odrAktiva.getNomorOrder()%>" size="30" -->
									&nbsp;</td>
                                    <td height="25" nowrap><b><%=strTitle[SESS_LANGUAGE][5]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
										<%
											Perkiraan objPerkiraan = new Perkiraan();
											if(receiveAktiva.getIdPerkiraanDp() != 0){
												try{
													objPerkiraan = PstPerkiraan.fetchExc(receiveAktiva.getIdPerkiraanDp());
													out.println(objPerkiraan.getNama());
												}catch(Exception e){}
											}
										%>
                                      <%

                                          Vector perkiraanPayid_valuex = new Vector(1,1);
                                          Vector perkiraanPayid_keyx = new Vector(1,1);
                                          String sel_perkiraanPayidx = ""+receiveAktiva.getIdPerkiraanDp();
                                          whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+"="+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS+
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
                                          Vector lPaymentx = PstPerkiraan.list(0,0,whereClause,PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN]);
                                          perkiraanPayid_valuex.add("-");
                                          perkiraanPayid_keyx.add("0");
                                          if(lPaymentx!=null&&lPaymentx.size()>0){
                                               for(int i=0;i<lPaymentx.size();i++){
                                                   Perkiraan perkiraan =(Perkiraan)lPaymentx.get(i);
                                                   String padding = "";
                                                    for(int j=0;j<perkiraan.getLevel();j++){
                                                        padding = padding + "&nbsp;&nbsp;&nbsp;";
                                                    }
                                                   perkiraanPayid_valuex.add(padding+perkiraan.getNoPerkiraan()+" "+perkiraan.getNama());
                                                   perkiraanPayid_keyx.add(""+perkiraan.getOID());
                                               }
                                          }
									  %>
                                      <%//= ControlCombo.draw(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]+"_TEXT",null, sel_perkiraanPayidx, perkiraanPayid_keyx, perkiraanPayid_valuex, "disabled=true", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td height="25" nowrap>&nbsp;<b><%=strTitle[SESS_LANGUAGE][11]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
										<%out.println(receiveAktiva.getNomorInvoice());%>
                                      <!-- input type="text" name="<%//=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_NOMOR_INVOICE]%>" value="<%//=receiveAktiva.getNomorInvoice()%>" size="30" --></td>
                                    <td height="25">&nbsp;</td>
                                    <td height="25">&nbsp;</td>
                                    <td height="25">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;</td>
                                    <td width="1%" height="25">&nbsp;</td>
                                    <td width="32%" height="25">&nbsp;</td>
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
                                    <td colspan="6"><%=drawList(SESS_LANGUAGE,iCommand,list,receiveAktivadetailId, frmReceiveAktivaItem,approot)%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault(SESS_LANGUAGE,"");
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+receiveAktivadetailId+"')";
							String sconDelCom = "javascript:cmdDelete('"+receiveAktivadetailId+"')";
							String scancel = "javascript:cmdEdit('"+receiveAktivadetailId+"')";
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
                            if(receiveAktiva.getReceiveStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
							    out.println(ctrLine.draw(iCommand, iErrCode, msgString));
                            }
							%></td>
                                  </tr>
                                  <tr align="right">
                                    <td colspan="6"><table width="40%"  breceive="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="40%" scope="row">&nbsp;<%=strTitle[SESS_LANGUAGE][7]%></td>
                                        <%
                                            double total = PstReceiveAktivaItem.getTotalReceiveAktivaItem(oidReceiveAktiva);
                                        %>
                                        <td width="60%" align="right"><b><%=FRMHandler.userFormatStringDecimal(total)%></b></td>
                                      </tr>
                                      <tr>
                                        <td scope="row">&nbsp;<%=strTitle[SESS_LANGUAGE][8]%></td>
                                        <td align="right"><input readonly type="text" name="<%=frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_DOWN_PAYMENT]%>" value="<%=FRMHandler.userFormatStringDecimal(receiveAktiva.getDownPayment())%>" class="txtalign"></td>
                                      </tr>
                                      <tr>
                                        <td scope="row">&nbsp;<%=strTitle[SESS_LANGUAGE][9]%></td>
                                        <td align="right"><b><%=FRMHandler.userFormatStringDecimal(total - receiveAktiva.getDownPayment())%></b></td>
                                      </tr>
                                    </table></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="76%" scope="row"><%
                                        ControlLine ctrLinex = new ControlLine();
							ctrLinex.setLocationImg(approot+"/images");
							ctrLinex.initDefault(SESS_LANGUAGE,"");
							ctrLinex.setTableWidth("80%");
							scomDel = "javascript:cmdAskMain('"+oidReceiveAktiva+"')";
							sconDelCom = "javascript:cmdConfirmDeleteMain('"+oidReceiveAktiva+"')";
							scancel = "javascript:cmdEdit('"+oidReceiveAktiva+"')";
                            strSave = "javascript:cmdSaveMain('"+oidReceiveAktiva+"')";
                            strBack = "javascript:cmdBackMain()";
							ctrLinex.setCommandStyle("command");
							ctrLinex.setColCommStyle("command");
                            ctrLinex.setDeleteCaption("Hapus Receive");
							ctrLinex.setSaveCommand(strSave);
							ctrLinex.setDeleteCommand(scomDel);
							ctrLinex.setConfirmDelCommand(strDelete);
                            //ctrLinex.setBackCaption(strBack);
                            ctrLinex.setBackCommand(strBack);

							if (privDelete){
								ctrLinex.setConfirmDelCommand(sconDelCom);
								ctrLinex.setDeleteCommand(scomDel);
								ctrLinex.setEditCommand(scancel);
							}else{
								ctrLinex.setConfirmDelCaption("");
								ctrLinex.setDeleteCaption("");
								ctrLinex.setEditCaption("");
							}

							if(privAdd == false  && privUpdate == false){
								ctrLinex.setSaveCaption("");
							}

							if (privAdd == false){
								ctrLinex.setAddCaption("");
							}

							if(iCommand == Command.ASK)
							{
								ctrLinex.setDeleteQuestion(strDelete);
							}
                            if(receiveAktiva.getReceiveStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){
                                //controlLine.setBackCaption(strBack);
                                ctrLinex.setSaveCaption("");
                                ctrLinex.setDeleteCaption("");
                                ctrLinex.setAddCaption("");
                            }
							    ctrLinex.setBackCaption("");
                                ctrLinex.setSaveCaption("");
                                ctrLinex.setDeleteCaption("");
							out.println(ctrLinex.draw(Command.EDIT, 0, ""));
							%></td>
                                        <td width="24%"><a href="javascript:cmdPosted()" class="command"><%if(receiveAktiva.getReceiveStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0 && iFixedAssetsModule == 0){%><%=strTitle[SESS_LANGUAGE][12]%><%}%></a></td>
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