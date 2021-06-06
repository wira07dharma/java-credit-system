<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
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
                   com.dimata.gui.jsp.ControlList,
                   com.dimata.aiso.entity.masterdata.Aktiva,
                   com.dimata.aiso.form.aktiva.*,
                   com.dimata.aiso.entity.aktiva.*,
                   com.dimata.aiso.entity.masterdata.ModulAktiva,
                   com.dimata.aiso.session.aktiva.SessOrderAktiva,
                   com.dimata.aiso.session.aktiva.SessReceiveAktiva,
                   com.dimata.aiso.entity.arap.ArApItem,
                   com.dimata.aiso.entity.arap.PstArApItem,
                   com.dimata.aiso.entity.arap.PstArApMain,
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

public static final int INT_DEFAULT_NOP = 1;
public static final int INT_MAX_NOP = 24;

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
        "Posting ke Jurnal",
        "Jumlah Angsuran",
        "Simpan Angsuran"
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
        "Donw Payment",
        "Residue",
		"Order Number",
		"Invoice Number",
        "Posting Jurnal",
        "Number of Payment",
        "Set Payment Term"
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

public static String strApItemTitle[][] = {
	{
	"No","Angsuran","Tanggal Jatuh Tempo","Keterangan"
	},

	{
	"No","Payment Amount","Due Date","Description"
	}
};

public static final String masterTitle[] = {
	"Terima Aktiva","Receive Aktiva"
};

public static final String listTitle[] = {
	"Proses Terima","Receive Process"
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
		ReceiveAktivaItem orderAktivaItem = (ReceiveAktivaItem)vect.get(0);
        ModulAktiva aktiva = (ModulAktiva)vect.get(1);

		rowx = new Vector();
        rowx.add(""+(i+1));
        rowx.add(aktiva.getKode());
        rowx.add(aktiva.getName());
        rowx.add(""+orderAktivaItem.getQty());
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getPriceReceive())+"</div>");
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getTotalPriceReceive())+"</div>");

        lstData.add(rowx);
        lstLinkData.add(String.valueOf(orderAktivaItem.getOID()));
    }
    return ctrlist.drawMe(index);
}

/**
* this method used to list jurnal detail input
*/
public String drawListItem(int language, int nop, double totalAmount, Vector listItem){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("85%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strApItemTitle[language][0],"5%","center","right"); // no
    ctrlist.dataFormat(strApItemTitle[language][1],"15%","center","right"); // angsuran
    ctrlist.dataFormat(strApItemTitle[language][2],"20%","center","center"); // tanggal
    ctrlist.dataFormat(strApItemTitle[language][3],"45%","center","left"); // keterangan

	Vector lstData = ctrlist.getData();
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
    int size = nop;
    int listSize = listItem.size();
    boolean isEdit = (size==listSize);
    Date dueDate = new Date();
    String desc = "";
    boolean readonly = false;
    long oid = 0;
	for (int i = 0; i < size; i++) {
        if(isEdit){
            ArApItem item = (ArApItem) listItem.get(i);
            dueDate = item.getDueDate();
            desc = item.getDescription();
            oid = item.getOID();
            readonly = item.getAngsuran()!=item.getLeftToPay();
        }
        else{
            dueDate = new Date();
            dueDate.setYear(dueDate.getYear() + ((int) (dueDate.getMonth()+i)/12));
            dueDate.setMonth((dueDate.getMonth()+i)%12);
        }
        rowx = new Vector();
        rowx.add(""+(i+1));
        rowx.add("<input size=\"20\" type=\"text\" readonly style=\"text-align:right\" name=\"ANGSURAN"+i+"\" value=\""+FrmReceiveAktiva.userFormatStringDecimal(totalAmount/nop)+"\">");
        String stDate = ControlDate.drawDateWithStyle("DUE_DATE"+i,dueDate,4,-5,"",(readonly?"disabled":""));
        rowx.add(stDate);
        rowx.add("<input type=\"hidden\" name=\"ARAP_ITEM_ID"+i+"\" value=\""+oid+"\"><input size=\"55\" "+(readonly?"readonly":"")+" type=\"text\" name=\"DESCRIPTION"+i+"\" value=\""+desc+"\">");

        lstData.add(rowx);
    }

    return ctrlist.drawMe(index);
}
%>


<!-- JSP Block -->
<%
// get request from hidden text
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE ORDER AKTIVA PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES ORDER AKTIVA SEBELUM MELAKUKAN PROSES LAIN";
boolean readonlyItem = false;
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int index = FRMQueryString.requestInt(request,"index");
int nop = FRMQueryString.requestInt(request,"nop");
if(nop==0){
    nop = INT_DEFAULT_NOP;
}

int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidReceiveAktiva = FRMQueryString.requestLong(request,"hidden_receive_aktiva_id");
int posTed = FRMQueryString.requestInt(request,"posted_status");
/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New" : "Tambah Baru";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : " Tambah Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Terima List" : "Kembali Ke Daftar Terima";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Receive" : "Hapus Terima";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete" : "Ya Hapus Terima";

/** Instansiasi object CtrlReceiveAktiva and FrmReceiveAktiva */
ControlLine ctrLine = new ControlLine();
CtrlReceiveAktiva ctrlReceiveAktiva = new CtrlReceiveAktiva(request);
ctrlReceiveAktiva.setLanguage(SESS_LANGUAGE);
FrmReceiveAktiva frmReceiveAktiva = ctrlReceiveAktiva.getForm();
int iErrCode = ctrlReceiveAktiva.action(iCommand, oidReceiveAktiva);
ReceiveAktiva receiveAktiva = ctrlReceiveAktiva.getReceiveAktiva();
oidReceiveAktiva = receiveAktiva.getOID();
String msgString = ctrlReceiveAktiva.getMessage();

    // get nama company
    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(receiveAktiva.getSupplierId());
    }catch(Exception e){}
    OrderAktiva odrAktiva = new OrderAktiva();
    try{
        odrAktiva = PstOrderAktiva.fetchExc(receiveAktiva.getOrderAktivaId());
    }catch(Exception e){}

    if(iCommand==Command.NONE)
        iCommand = Command.ADD;
    else if(iCommand==Command.SAVE && iErrCode == 0)
        iCommand = Command.EDIT;

System.out.println("DIATAS VECTOR LIST ::::::: ");
    Vector list = PstReceiveAktivaItem.getListItem(oidReceiveAktiva);

    Vector lPaymentCmb = new Vector();
    lPaymentCmb.add(PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_CASH));
    lPaymentCmb.add(PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_BANK));    
    Vector lPaymentHtLancar = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES);
    Vector lPaymentAwal = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_RETAINED_EARNING);
	

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



Vector listItem = new Vector();
if(receiveAktiva.getReceiveStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED && receiveAktiva.getTypePembayaran()==I_TransactionType.TIPE_TRANSACTION_KREDIT) {

    if(iCommand==Command.SUBMIT){

        ArApItem arApItem = new ArApItem();
        for(int i=0;i<nop;i++){
            long oid = FRMQueryString.requestLong(request,"ARAP_ITEM_ID"+i);
            if(oid>0){    // update
                arApItem = PstArApItem.fetchExc(oid);
                if(arApItem.getAngsuran()!=arApItem.getLeftToPay()){
                    continue;
                }
                else{
                    Date dueDate = FRMQueryString.requestDate(request,"DUE_DATE"+i);
                    String desc = FRMQueryString.requestString(request,"DESCRIPTION"+i);
                    arApItem.setDueDate(dueDate);
                    arApItem.setDescription(desc);
                    try{
                        PstArApItem.updateExc(arApItem);
                    }
                    catch(Exception e){
                        System.out.println("err on SUBMIT: "+e.toString());
                    }
                }
            }
            else{    // insert
                String stAngsuran = FRMQueryString.requestString(request,"ANGSURAN"+i);
                if(stAngsuran==null||stAngsuran.length()==0){
                    stAngsuran = "0";
                }
                double angsuran = Double.parseDouble(FrmReceiveAktiva.deFormatStringDecimal(stAngsuran));
                Date dueDate = FRMQueryString.requestDate(request,"DUE_DATE"+i);
                String desc = FRMQueryString.requestString(request,"DESCRIPTION"+i);

                arApItem = new ArApItem();
                arApItem.setAngsuran(angsuran);
                arApItem.setArApItemStatus(PstArApMain.STATUS_OPEN);
                arApItem.setReceiveAktivaId(oidReceiveAktiva);
                arApItem.setDescription(desc);
                arApItem.setDueDate(dueDate);
                arApItem.setLeftToPay(angsuran);
                arApItem.setCurrencyId(receiveAktiva.getIdCurrency());
                arApItem.setRate(receiveAktiva.getValueRate());

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
    }
    String where = PstArApItem.fieldNames[PstArApItem.FLD_RECEIVE_AKTIVA_ID]+"="+oidReceiveAktiva;
    String order = PstArApItem.fieldNames[PstArApItem.FLD_DUE_DATE];
    listItem = PstArApItem.list(0,0,where,order);
    if(listItem.size()>0){
        nop = listItem.size();
        readonlyItem = true;
    }
}

    // --------------
    System.out.println("posTed : "+posTed);
    if(posTed!=0){
        SessReceiveAktiva sessReceiveAktiva = new SessReceiveAktiva();
        sessReceiveAktiva.postingReceiveAktiva(accountingBookType,userOID,currentPeriodOid,oidReceiveAktiva);
    }

if(iCommand==Command.DELETE){
%>
	<jsp:forward page="receive_aktiva_list.jsp">
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
<script language="javascript">
<%if((privView)&&(privAdd)&&(privSubmit)){%>
function cmdSave(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
	document.frmorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdChangeNop(){
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdSetAngsuran(){
	document.frmorderaktiva.command.value="<%=Command.SUBMIT%>";
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

function cmdAsk(){
	document.frmorderaktiva.command.value="<%=Command.ASK%>";
	document.frmorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdEdit(oid){
	document.frmorderaktiva.hidden_receive_aktiva_id.value=oid;
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdDelete(oid){
	document.frmorderaktiva.hidden_receive_aktiva_id.value=oid;
	document.frmorderaktiva.command.value="<%=Command.DELETE%>";
	document.frmorderaktiva.action="receive_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdEditItem(oid){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="receive_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdAddDetail(oid){
    document.frmorderaktiva.hidden_receive_aktiva_id.value=oid;
	document.frmorderaktiva.command.value="<%=Command.ADD%>";
	document.frmorderaktiva.action="receive_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdEditDetail(oid){
    <%
    if(receiveAktiva.getReceiveStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
    %>
    document.frmorderaktiva.receive_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="receive_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
    <%
    }
    %>
}

    <%}%>

function cmdclear(){
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>.value = 0;
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>_TEXT.value = "";
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]%>.value = 0;
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]%>_TEXT.value = 0;
    document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_DOWN_PAYMENT]%>.value = "0";
}

function cmdBack(){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.start.value="<%=start%>";
	document.frmorderaktiva.action="receive_aktiva_list.jsp";
	document.frmorderaktiva.submit();
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
			 }//end for
			 <%
			 if(lPaymentCmb!=null && lPaymentCmb.size()>0){
				for(int k=0; k<lPaymentCmb.size(); k++){
				   Vector temp = (Vector)lPaymentCmb.get(k);
				   for(int i=0; i<temp.size(); i++){	
				   Perkiraan perkiraan = (Perkiraan)temp.get(i);
				   	
				%>
				var oOption = document.createElement("OPTION");
				oOption.value = "<%=perkiraan.getOID()%>";
				oOption.text = "<%=perkiraan.getNama()%>";
				document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.add(oOption);
				<%
				}//End for
			 }//End if
			 %>
			 break;
		case "<%=I_TransactionType.TIPE_TRANSACTION_KREDIT%>" :
			 for(var j=document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.length-1; j>-1; j--){
				document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.options.remove(j);
			 }//End for
			 <%
                 if(lPaymentHtLancar!=null && lPaymentHtLancar.size()>0){
                    for(int k=0; k<lPaymentHtLancar.size(); k++){
                       Perkiraan perkiraan = (Perkiraan)lPaymentHtLancar.get(k);
				%>

				var oOption = document.createElement("OPTION");
				oOption.value = "<%=perkiraan.getOID()%>";
				oOption.text = "<%=perkiraan.getNama()%>";
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.add(oOption);
				<%
                    }//End for
                 }//End if
			 %>
			 break;
		case "<%=I_TransactionType.TIPE_TRANSACTION_AWAL%>" :
			 for(var j=document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.length-1; j>-1; j--){
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.options.remove(j);
			 }//End for
			 <%
                 if(lPaymentAwal!=null && lPaymentAwal.size()>0){
                    for(int k=0; k<lPaymentAwal.size(); k++){
                       Perkiraan perkiraan = (Perkiraan)lPaymentAwal.get(k);
				%>

				var oOption = document.createElement("OPTION");
				oOption.value = "<%=perkiraan.getOID()%>";
				oOption.text = "<%=perkiraan.getNama()%>";
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.add(oOption);
				<%
                    }//End for
                 }//End if
			 %>
			 break;

	}//End switch
}//End command

function cmdChangeCurr(){
    var id = Math.abs(document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_CURRENCY]%>.value);
    switch(id){
<%
           Vector currencytypeid_value = new Vector(1,1);
           Vector currencytypeid_key = new Vector(1,1);
           String sel_currencytypeid = ""+receiveAktiva.getIdCurrency();
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
        document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_VALUE_RATE]%>.value="<%=FrmReceiveAktiva.userFormatStringDecimal(rate)%>"
        break;
                    <%
                }
}
									  %>
    default :
        document.frmorderaktiva.<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_VALUE_RATE]%>.value="<%=FrmReceiveAktiva.userFormatStringDecimal(1.0)%>"
        break;
    }
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" breceive="0" cellspacing="3" cellpadding="2" height="100%">
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
      <table width="100%" breceive="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%>
            &gt; <%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td><!-- #BeginEditable "content" -->
            <form name="frmorderaktiva" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_SUPPLIER_ID]%>" value="<%=receiveAktiva.getSupplierId()%>">
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>" value="<%=receiveAktiva.getOrderAktivaId()%>">
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]%>" value="<%=receiveAktiva.getIdPerkiraanDp()%>">
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_RECEIVE_STATUS]%>" value="<%=receiveAktiva.getReceiveStatus()%>">
              <input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_VALUE_RATE]%>" value="<%=FrmReceiveAktiva.userFormatStringDecimal(receiveAktiva.getValueRate())%>">
              <input type="hidden" name="hidden_receive_aktiva_id" value="<%=oidReceiveAktiva%>">
              <input type="hidden" name="receive_aktiva_detail_id" value="0">
              <input type="hidden" name="posted_status" value="0">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <table width="100%" breceive="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table breceive="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%">
                          <hr>
                        </td>
                      </tr>
                      <tr>
                        <td width="100%" class="tabtitleactive" valign="top">
                          <table width="100%" breceive="0" cellpadding="0" cellspacing="0" height="25">
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
									<input type="hidden" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_NOMOR_RECEIVE]%>" value="<%=receiveAktiva.getNomorReceive()%>" size="35"><%=receiveAktiva.getNomorReceive()%>
									</td>
                                    <td width="21%" height="25"><%=strTitle[SESS_LANGUAGE][3]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%
									   Vector trantypeid_value = new Vector(1,1);
									   Vector trantypeid_key = new Vector(1,1);
									   String sel_trantypeid = ""+receiveAktiva.getTypePembayaran();
                                        for(int i=0;i<I_TransactionType.arrTransactionTypeNames.length;i++){
                                            trantypeid_value.add(I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][i]);
                                            trantypeid_key.add(""+i);
                                        }
									  %>
                                      <%= ControlCombo.draw(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_TYPE_PEMBAYARAN],null, sel_trantypeid, trantypeid_key, trantypeid_value, "onChange=\"javascript:cmdChange()\"", "") %>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][1]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<%
                                        Date dtTransactionDate = receiveAktiva.getTanggalReceive();
                                        if(dtTransactionDate ==null)
                                        {
                                            dtTransactionDate = new Date();
                                        }
                                        out.println(ControlDate.drawDate(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_TANGGAL_RECEIVE], dtTransactionDate, 4, -5));
									%>
                                    </td>
                                    <td height="25"><%=strTitle[SESS_LANGUAGE][6]%> </td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
                                      <%= ControlCombo.draw(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_CURRENCY],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value,  "onChange=\"javascript:cmdChangeCurr()\"", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
                                    <input readonly type="text" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_SUPPLIER_ID]%>_TEXT" value="<%=contactList.getCompName()%>" size="30">
                                    &nbsp;<a href="javascript:cmdopen()">OPEN</a>
                                    </td>
                                    <td height="25"><%=strTitle[SESS_LANGUAGE][4]%> </td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
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
                                      <%= ControlCombo.draw(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_PAYMENT],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][10]%> </td>
                                    <td width="1%"><b>:</b></td>
                                    <td height="25"><input readonly type="text" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ORDER_AKTIVA_ID]%>_TEXT" value="<%=odrAktiva.getNomorOrder()%>" size="30">
                                    &nbsp;<a href="javascript:cmdopenorder()">OPEN</a> | <a href="javascript:cmdclear()">CANCEL</a></td>
                                    <td height="25"><%=strTitle[SESS_LANGUAGE][5]%> </td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
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
                                      <%= ControlCombo.draw(frmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_ID_PERKIRAAN_DP]+"_TEXT",null, sel_perkiraanPayidx, perkiraanPayid_keyx, perkiraanPayid_valuex, "disabled=true", "") %> </td>
                                  </tr>
                                  <tr>
                                    <td height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][11]%> </td>
                                    <td width="1%"><b>:</b></td>
                                    <td height="25"><input type="text" name="<%=FrmReceiveAktiva.fieldNames[FrmReceiveAktiva.FRM_NOMOR_INVOICE]%>" value="<%=receiveAktiva.getNomorInvoice()%>" size="30"></td>
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
                                    <td colspan="6">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=drawList(SESS_LANGUAGE,list)%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%
                                        if(receiveAktiva.getReceiveStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
										  if((iCommand==Command.EDIT) || (iCommand==Command.SAVE && iErrCode==0) || (iCommand==Command.LIST)){
                                            out.println("<a href=\"javascript:cmdAddDetail('"+oidReceiveAktiva+"')\" class=\"command\">"+strAddDetail+"</a>");
                                          }
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
                  <%
                   if(receiveAktiva.getReceiveStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED && receiveAktiva.getTypePembayaran()==I_TransactionType.TIPE_TRANSACTION_KREDIT) {
                       Vector vals = new Vector();
                       for(int i = 1; i <= INT_MAX_NOP; i++){
                            vals.add(i+"");
                       }
                       String att = "onChange=\"javascript:cmdChangeNop()\"";
                       String stHidden = "<input type=\"hidden\" name=\"nop\" value=\""+nop+"\">";
                       if(readonlyItem){
                            att = "disabled";
                       }
                       else{
                            stHidden = "";
                       }
                       String stCombo = ControlCombo.draw("nop","",nop+"",vals,vals,att,"")+stHidden;
                  %>
                                  <tr>
                                    <td colspan="6"><%=strTitle[SESS_LANGUAGE][13]%>&nbsp;&nbsp;:&nbsp;
                                        <%=stCombo%>
                                    </td>
                                  </tr>
                                   <tr>
                                    <td colspan="6"><%=drawListItem(SESS_LANGUAGE,nop,(total - receiveAktiva.getDownPayment()),listItem)%></td>
                                  </tr>
                  <%
                   }
                  %>
                                  <tr>
                                    <td colspan="6"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="76%"><%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidReceiveAktiva+"')";
							String sconDelCom = "javascript:cmdDelete('"+oidReceiveAktiva+"')";
							String scancel = "javascript:cmdEdit('"+oidReceiveAktiva+"')";
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
                            if(receiveAktiva.getReceiveStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){
                                ctrLine.setBackCaption(strBack);
                                ctrLine.setSaveCaption("");
                                ctrLine.setDeleteCaption("");
                                ctrLine.setAddCaption("");
                            }
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							%></td>
                            <%
                            if(receiveAktiva.getReceiveStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED && receiveAktiva.getTypePembayaran()==I_TransactionType.TIPE_TRANSACTION_KREDIT) {
                            %>
                                        <td width="24%"><a href="javascript:cmdSetAngsuran()" class="command"><%=strTitle[SESS_LANGUAGE][14]%></a></td>
                            <%}
                                else{
                                %>
                                        <td width="24%"><a href="javascript:cmdPosted()" class="command"><%if(receiveAktiva.getReceiveStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0){%><%=strTitle[SESS_LANGUAGE][12]%><%}%></a></td>
                            <%
                            }
                            %>
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
