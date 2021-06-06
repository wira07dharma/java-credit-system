<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.aiso.form.aktiva.FrmSellingAktiva,
                   com.dimata.aiso.form.aktiva.CtrlSellingAktiva,
                   com.dimata.aiso.entity.aktiva.SellingAktiva,
			 	   com.dimata.aiso.entity.masterdata.*,
                   com.dimata.util.Command,
                   com.dimata.util.Formater,
                   com.dimata.gui.jsp.ControlDate,                  
                   com.dimata.gui.jsp.ControlCombo,
                   com.dimata.aiso.entity.masterdata.PstPerkiraan,
                   com.dimata.aiso.entity.masterdata.Perkiraan,
                   com.dimata.gui.jsp.ControlLine,
				   com.dimata.interfaces.trantype.I_TransactionType,
                   com.dimata.common.entity.payment.CurrencyType,
                   com.dimata.common.entity.payment.PstCurrencyType,
                   com.dimata.common.entity.contact.ContactList,
                   com.dimata.common.entity.contact.PstContactList,
                   com.dimata.aiso.form.aktiva.FrmSellingAktivaItem,
                   com.dimata.gui.jsp.ControlList,
                   com.dimata.aiso.entity.aktiva.SellingAktivaItem,
                   com.dimata.aiso.entity.masterdata.Aktiva,
                   com.dimata.aiso.entity.aktiva.PstSellingAktivaItem,
                   com.dimata.aiso.session.aktiva.SessSellingAktiva,
                   com.dimata.aiso.session.aktiva.SessSellingAktiva,
                   com.dimata.aiso.entity.masterdata.ModulAktiva,
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
		"Nomor Selling",
		"Tanggal Selling",
		"Customer",
		"Tipe Transaksi",
		"Perkiraan Lawan",
		"Perkiraan Uang Muka",
        "Mata Uang",
        "Total",
        "Uang Muka",
        "Sisa",
        "Posting ke Jurnal",
        "Jumlah Angsuran",
        "Simpan Angsuran",
		"Catatan"
	},
	{
		"Document No.",
		"Date",
		"Customer",
		"Trans Type",
		"Debet Account",
		"Down Payment",
        "Currency",
        "Total",
        "Donw Payment",
        "Residue",
        "Posting Jurnal",
        "Number of Payment",
        "Set Payment Term",
		"Note"
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
	"Aktiva Tetap","Fixed Assets"
};

public static final String listTitle[] = {
	"Proses Pengeluaran","Out Going Process"
};


public String drawList(int language, Vector objectClass, long oidSellingAktiva){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strItemTitle[language][0],"3%","center","center"); // no
    ctrlist.dataFormat(strItemTitle[language][1],"8%","center","center"); // kode
    ctrlist.dataFormat(strItemTitle[language][2],"35%","center","center"); // nama
    ctrlist.dataFormat(strItemTitle[language][3],"5%","center","center"); // qty
    ctrlist.dataFormat(strItemTitle[language][4],"8%","center","center"); // harga
    ctrlist.dataFormat(strItemTitle[language][5],"8%","center","center"); // total harga

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditDetail('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
  	int totQty = PstSellingAktivaItem.getTotalQuantitySellingAktivaItem(oidSellingAktiva);
	double totPrice = PstSellingAktivaItem.getTotalSellingAktivaItem(oidSellingAktiva);

	for (int i = 0; i < objectClass.size(); i++) {
        Vector vect = (Vector)objectClass.get(i);
		SellingAktivaItem orderAktivaItem = (SellingAktivaItem)vect.get(0);
        ModulAktiva aktiva = (ModulAktiva)vect.get(1);

	  rowx = new Vector();
        rowx.add("<div align=\"center\">"+(i+1)+"</div>");
        rowx.add(aktiva.getKode());
        rowx.add(aktiva.getName());
        rowx.add("<div align=\"center\">"+orderAktivaItem.getQty()+"</div>");
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getPriceSelling())+"</div>");
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(orderAktivaItem.getTotalPriceSelling())+"</div>");

        lstData.add(rowx);
        lstLinkData.add(String.valueOf(orderAktivaItem.getOID()));
    }
    	  rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("<div align=\"center\"><b>Total</b></div>");
        rowx.add("<div align=\"center\"><b>"+totQty+"</b></div>");
        rowx.add("");
        rowx.add("<div align=\"right\"><b>"+FRMHandler.userFormatStringDecimal(totPrice)+"</b></div>");

        lstData.add(rowx);

	return ctrlist.drawMe(index);
}

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
        rowx.add("<input size=\"20\" type=\"text\" readonly style=\"text-align:right\" name=\"ANGSURAN"+i+"\" value=\""+FrmSellingAktiva.userFormatStringDecimal(totalAmount/nop)+"\">");
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
boolean readonlyItem = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE SELLING AKTIVA PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES PENJUALAN AKTIVA SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int index = FRMQueryString.requestInt(request,"index");
int date = FRMQueryString.requestInt(request,FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]+"_dy");
int month = FRMQueryString.requestInt(request,FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]+"_mn");
int year = FRMQueryString.requestInt(request,FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]+"_yr");
int nop = FRMQueryString.requestInt(request,"nop");
if(nop==0){
    nop = INT_DEFAULT_NOP;
}

int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidSellingAktiva = FRMQueryString.requestLong(request,"hidden_selling_aktiva_id");
int posTed = FRMQueryString.requestInt(request,"posted_status");

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New" : "Tambah Baru";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : " Tambah Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Selling List" : "Kembali Ke Daftar Selling";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Selling" : "Hapus Selling";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete" : "Ya Hapus Selling";

/** Instansiasi object CtrlSellingAktiva and FrmSellingAktiva */
ControlLine ctrLine = new ControlLine();
CtrlSellingAktiva ctrlSellingAktiva = new CtrlSellingAktiva(request);
ctrlSellingAktiva.setLanguage(SESS_LANGUAGE);
FrmSellingAktiva frmSellingAktiva = ctrlSellingAktiva.getForm();
int iErrCode = ctrlSellingAktiva.action(iCommand, oidSellingAktiva);
SellingAktiva orderAktiva = ctrlSellingAktiva.getSellingAktiva();
oidSellingAktiva = orderAktiva.getOID();
String msgString = ctrlSellingAktiva.getMessage();

    // get nama company
    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(orderAktiva.getSupplierId());
    }catch(Exception e){}
    if(iCommand==Command.NONE)
        iCommand = Command.ADD;
    else if(iCommand==Command.SAVE && iErrCode == 0)
        iCommand = Command.EDIT;

Vector list = PstSellingAktivaItem.getListItem(oidSellingAktiva);

Vector lPaymentCmb = new Vector();
lPaymentCmb.add(PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_CASH));
lPaymentCmb.add(PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_BANK));    
Vector lPaymentHtLancar = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_PIUTANG);
Vector lPaymentAwal = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_RETAINED_EARNING);
Vector vDonated = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_EXPENSE);

Vector listItem = new Vector();
if(orderAktiva.getSellingStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED && orderAktiva.getTypePembayaran()==I_TransactionType.TIPE_TRANSACTION_KREDIT) {

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
                double angsuran = Double.parseDouble(FrmSellingAktiva.deFormatStringDecimal(stAngsuran));
                Date dueDate = FRMQueryString.requestDate(request,"DUE_DATE"+i);
                String desc = FRMQueryString.requestString(request,"DESCRIPTION"+i);

                arApItem = new ArApItem();
                arApItem.setAngsuran(angsuran);
                arApItem.setArApItemStatus(PstArApMain.STATUS_OPEN);
                arApItem.setSellingAktivaId(oidSellingAktiva);
                arApItem.setDescription(desc);
                arApItem.setDueDate(dueDate);
                arApItem.setLeftToPay(angsuran);
                arApItem.setCurrencyId(orderAktiva.getIdCurrency());
                arApItem.setRate(orderAktiva.getValueRate());

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
 			
    String where = PstArApItem.fieldNames[PstArApItem.FLD_SELLING_AKTIVA_ID]+"="+oidSellingAktiva;
    String order = PstArApItem.fieldNames[PstArApItem.FLD_DUE_DATE];
    listItem = PstArApItem.list(0,0,where,order);
    if(listItem.size()>0){
        nop = listItem.size();
        readonlyItem = true;
    }
}

    if(posTed!=0){
        SessSellingAktiva sessSellingAktiva = new SessSellingAktiva();
        sessSellingAktiva.postingSellingAktiva(accountingBookType,userOID,currentPeriodOid,oidSellingAktiva);
    }

/** if Command.DELETE, delete journal and its descendant and redirect to journal detail page */
if(iCommand==Command.DELETE){
%>
	<jsp:forward page="selling_aktiva_list.jsp">
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
	var date1 = ""+document.frmorderaktiva.<%=frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.frmorderaktiva.<%=frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING] + "_mn"%>.value=bln;
	document.frmorderaktiva.<%=frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING] + "_dy"%>.value=hri;
	document.frmorderaktiva.<%=frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING] + "_yr"%>.value=thn;		
				
}

function cmdSave(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
	document.frmorderaktiva.action="selling_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdChangeNop(){
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="selling_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdSetAngsuran(){
	document.frmorderaktiva.command.value="<%=Command.SUBMIT%>";
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

function cmdAsk(){
	document.frmorderaktiva.command.value="<%=Command.ASK%>";
	document.frmorderaktiva.action="selling_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdEdit(oid){
	document.frmorderaktiva.hidden_selling_aktiva_id.value=oid;
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="selling_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdDelete(oid){
	document.frmorderaktiva.hidden_selling_aktiva_id.value=oid;
	document.frmorderaktiva.command.value="<%=Command.DELETE%>";
	document.frmorderaktiva.action="selling_aktiva_edit.jsp";
	document.frmorderaktiva.submit();
}

function cmdEditItem(oid){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="selling_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdAddDetail(oid){
    document.frmorderaktiva.hidden_selling_aktiva_id.value=oid;
	document.frmorderaktiva.command.value="<%=Command.ADD%>";
	document.frmorderaktiva.action="selling_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
}

function cmdEditDetail(oid){
<%
    if(orderAktiva.getSellingStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
    %>
    document.frmorderaktiva.selling_aktiva_detail_id.value = oid;
	document.frmorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmorderaktiva.action="selling_aktiva_detail.jsp";
	document.frmorderaktiva.submit();
    <%
    }
    %>
}

    <%}%>

function cmdBack(){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.start.value="<%=start%>";
	document.frmorderaktiva.action="selling_aktiva_list.jsp";
	document.frmorderaktiva.submit();
}

function cmdopen(){
    window.open("selling_aktiva_contact_company_list.jsp","search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdChange(){
	var n = document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TYPE_PEMBAYARAN]%>.value;
	switch(n){
		case "<%=I_TransactionType.TIPE_TRANSACTION_CASH%>" :
			 for(var j=document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.length-1; j>-1; j--){
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.options.remove(j);
			 }
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
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.add(oOption);
				<%}
				
				}
			 }
			 %>
			 break;
		case "<%=I_TransactionType.TIPE_TRANSACTION_KREDIT%>" :
			 for(var j=document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.length-1; j>-1; j--){
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.options.remove(j);
			 }
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
                    }
                 }
			 %>
			 break;

		case "<%=I_TransactionType.TIPE_TRANSACTION_AWAL%>" :
			 for(var j=document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.length-1; j>-1; j--){
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.options.remove(j);
			 }
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
                    }
                 }
			 %>
			 break;
		
		case "<%=I_TransactionType.TIPE_TRANSACTION_WRITE_OFF%>" :
			 for(var j=document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.length-1; j>-1; j--){
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.options.remove(j);
			 }
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
                    }
                 }
			 %>
			 break;	 
		
		case "<%=I_TransactionType.TIPE_TRANSACTION_DONOR%>" :
			 for(var j=document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.length-1; j>-1; j--){
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.options.remove(j);
			 }
			 <%
                 if(vDonated!=null && vDonated.size()>0){
                    for(int k=0; k<vDonated.size(); k++){
                       Perkiraan perkiraan = (Perkiraan)vDonated.get(k);
				%>

				var oOption = document.createElement("OPTION");
				oOption.value = "<%=perkiraan.getOID()%>";
				oOption.text = "<%=perkiraan.getNama()%>";
				document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>.add(oOption);
				<%
                    }
                 }
			 %>
			 break;	 	 

	}
}


function cmdChangeCurr(){
    var id = Math.abs(document.frmorderaktiva.<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_CURRENCY]%>.value);
    	//var id = 0;
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

function hideObjectForDate(){
  }
	
  function showObjectForDate(){
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
              <input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_KONSUMEN_ID]%>" value="<%=orderAktiva.getSupplierId()%>">
              <input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_SELLING_STATUS]%>" value="<%=orderAktiva.getSellingStatus()%>">
              <input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_VALUE_RATE]%>" value="<%=FrmSellingAktiva.userFormatStringDecimal(orderAktiva.getValueRate())%>">
              <input type="hidden" name="hidden_selling_aktiva_id" value="<%=oidSellingAktiva%>">
              <input type="hidden" name="selling_aktiva_detail_id" value="0">
              <input type="hidden" name="posted_status" value="0">
			<input type="hidden" name="test" value="2500" size="35">
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
                                    <td width="15%" height="25"><b>&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="42%" height="25">
									<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_NOMOR_SELLING]%>" value="<%=orderAktiva.getNomorSelling()%>" size="35"><%=orderAktiva.getNomorSelling()%>
									</td>
                                    <td width="15%" height="25"><b><%=strTitle[SESS_LANGUAGE][6]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="26%" height="25">
							<%														
												
							      if(iCommand==Command.EDIT && iErrCode == 0){%>
								<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_CURRENCY]%>" value="<%=orderAktiva.getIdCurrency()%>" size="35">
								
								<%
									CurrencyType ct = new CurrencyType();
								try {	
									 ct = PstCurrencyType.fetchExc(orderAktiva.getIdCurrency());
								}catch(Exception e){}
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
                                        /*Date dtTransactionDate = orderAktiva.getTanggalSelling();                                        
                                        if(iCommand==Command.EDIT && iErrCode == 0){%>
							<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]%>_dy" value="<%=dtTransactionDate.getDate()%>" size="35">
							<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]%>_mn" value="<%=(dtTransactionDate.getMonth() + 1)%>" size="35">
							<input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]%>_yr" value="<%=(dtTransactionDate.getYear() + 1900)%>" size="35">							
							<%out.println(Formater.formatDate(dtTransactionDate, "dd-MM-yyyy"));
						    }else{
						       dtTransactionDate = new Date();                                        								
							out.println(ControlDate.drawDate(frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING], dtTransactionDate, 4, -5));
						   }*/
						    
							%>
							<%if(isUseDatePicker.equalsIgnoreCase("Y")){%>
                                          <input onClick="ds_sh(this);" name="<%=frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((orderAktiva.getTanggalSelling() == null) ? new Date() : orderAktiva.getTanggalSelling(), "dd-MM-yyyy")%>"/>
                                          <input type="hidden" name="<%=frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING] + "_mn"%>">
                                          <input type="hidden" name="<%=frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING] + "_dy"%>">
                                          <input type="hidden" name="<%=frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TANGGAL_SELLING] + "_yr"%>">
                                          <script language="JavaScript" type="text/JavaScript">getThn();</script>
                                          <%}%>			
                                    </td>
                                    <td width="15%" height="25"><b><%=strTitle[SESS_LANGUAGE][3]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="26%" height="25">
							
                                      <%
									   Vector trantypeid_value = new Vector(1,1);
									   Vector trantypeid_key = new Vector(1,1);
									   String sel_trantypeid = ""+orderAktiva.getTypePembayaran();									   
									   String typePay = "";	
									 
                                        for(int i=0;i<I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE].length;i++){
                                            trantypeid_value.add(I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][i]);
											 System.out.println(I_TransactionType.arrTransactionTypeNames[SESS_LANGUAGE][i]);
                                            trantypeid_key.add(""+i);
							  //typePay = (String)trantypeid_value.get(Integer.parseInt(sel_trantypeid));							  
                                        }							
							if(iCommand==Command.EDIT && iErrCode == 0){%>								
                                      <input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TYPE_PEMBAYARAN]%>" value="<%=orderAktiva.getTypePembayaran()%>" size="35">								
								<%typePay = (String)trantypeid_value.get(orderAktiva.getTypePembayaran());
								out.println(typePay);
							}else{
									  %>
                                      <%= ControlCombo.draw(frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_TYPE_PEMBAYARAN],null, sel_trantypeid, trantypeid_key, trantypeid_value, "onChange=\"javascript:cmdChange()\"", "") %>
                                    <%}%>                                    
									</td>
                                  </tr>
                                  <tr>
                                    <td height="25"><b>&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25"><%
							if(iCommand==Command.EDIT && iErrCode == 0){
							out.println(contactList.getPersonName());
							}else{
						%>
                                    <input readonly type="text" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_KONSUMEN_ID]%>_TEXT" value="<%=contactList.getPersonName()%>">&nbsp;<a href="javascript:cmdopen()"><img alt="search contact" border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
                                    <%}%>
</td>
                                    <td height="25"><b><%=strTitle[SESS_LANGUAGE][4]%></b></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25"><%
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
							
                                       if(lPaymentCmb!=null&&lPaymentCmb.size()>0){
								for(int i=0;i<lPaymentCmb.size();i++){
									Vector temp = (Vector)lPaymentCmb.get(i);
									for(int l=0; l<temp.size(); l++){
										Perkiraan perkiraan =(Perkiraan)temp.get(l);
                                                           
										perkiraanPayid_value.add(perkiraan.getNama());
										perkiraanPayid_key.add(""+perkiraan.getOID());

									}//End for (int l=0; l<temp.size(); l++) 
								}//End for(int i=0;i<lPaymentCmb.size();i++)
							}//End if(lPaymentCmb!=null&&lPaymentCmb.size()>0)
							if(iCommand==Command.EDIT && iErrCode == 0){%>
                                      <input type="hidden" name="<%=FrmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT]%>" value="<%=orderAktiva.getIdPerkiraanPayment()%>" size="35">
                                      <%Perkiraan perk = new Perkiraan();
								try{
									perk = PstPerkiraan.fetchExc(orderAktiva.getIdPerkiraanPayment());
								}catch(Exception e){}
								out.println(perk.getNama());
							}else{	
						   %>
                                      <%= ControlCombo.draw(frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_ID_PERKIRAAN_PAYMENT],null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %>
                                      <%}%></td>
                                  </tr>
                                  <tr>
                                    <td width="15%" height="25"></td>
                                    <td width="1%" height="25">&nbsp;</td>
                                    <td width="42%" height="25">
												</td>
                                    <td width="15%" height="25"><b><%=strTitle[SESS_LANGUAGE][13]%></b></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="26%" height="25">
									<textarea rows="2" name="<%=frmSellingAktiva.fieldNames[FrmSellingAktiva.FRM_SELLING_NOTE]%>"><%=orderAktiva.getNote()%></textarea>
									</td>
                                  </tr>                                  
                                  <tr>
                                    <td colspan="6">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">
									<%if(list != null && list.size() > 0){%>
									<%=drawList(SESS_LANGUAGE,list, oidSellingAktiva)%>
									<%}%>
									</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%
                                        if(orderAktiva.getSellingStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED){
										  if((iCommand==Command.EDIT) || (iCommand==Command.SAVE && iErrCode==0) || (iCommand==Command.LIST)){
                                            out.println("<a href=\"javascript:cmdAddDetail('"+oidSellingAktiva+"')\" class=\"command\">"+strAddDetail+"</a>");
                                          }
                                        }
									  %></td>
                                  </tr>
                                  <!-- <tr align="right">
                                    <td colspan="6"><table width="20%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="40%" scope="row"><b><%=strTitle[SESS_LANGUAGE][7]%></b></td>
                                        <%
                                            double total = PstSellingAktivaItem.getTotalSellingAktivaItem(oidSellingAktiva);
                                        %>
                                        <td width="60%" align="right"><b><%=FRMHandler.userFormatStringDecimal(total)%></b></td>
                                      </tr>
                                    </table></td>
                                  </tr> -->
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                   <%
                   if(orderAktiva.getSellingStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED && orderAktiva.getTypePembayaran()==I_TransactionType.TIPE_TRANSACTION_KREDIT) {
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
                                    <td colspan="6"><%=strTitle[SESS_LANGUAGE][11]%>&nbsp;&nbsp;:&nbsp;
                                        <%=stCombo%>
                                    </td>
                                  </tr>
                                   <tr>
                                    <td colspan="6"><%=drawListItem(SESS_LANGUAGE,nop,total,listItem)%></td>
                                  </tr>
                  <%
                   }
                  %>
                                  <tr>
                                    <td colspan="6"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="76%" nowrap><%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault(SESS_LANGUAGE,"");
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidSellingAktiva+"')";
							String sconDelCom = "javascript:cmdDelete('"+oidSellingAktiva+"')";
							String scancel = "javascript:cmdEdit('"+oidSellingAktiva+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);
							ctrLine.setBackCaption(strBack);
							//ctrLine.setSaveCaption(strSave);
							ctrLine.setDeleteCaption(strDelete);
							ctrLine.setConfirmDelCaption(strYesDelete);

							/*if(iCommand==Command.ADD){
								ctrLine.setBackCaption("");
					  			ctrLine.setConfirmDelCaption("");
					  			ctrLine.setDeleteCaption("");
					  			ctrLine.setEditCaption("");
					  			ctrLine.setSaveCaption("");
							}*/

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
							
							if(iCommand == Command.ADD)
							{
								ctrLine.setAddCaption(strAddDetail);
								ctrLine.setCancelCaption("");
							}
							
                            if(orderAktiva.getSellingStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){
                                ctrLine.setBackCaption(strBack);
                                ctrLine.setSaveCaption("");
                                ctrLine.setDeleteCaption("");
                                ctrLine.setAddCaption("");
                            }
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							%></td>
                                        <%
                            if(orderAktiva.getSellingStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED && orderAktiva.getTypePembayaran()==I_TransactionType.TIPE_TRANSACTION_KREDIT) {
                            %>
                                        <td width="24%"><a href="javascript:cmdSetAngsuran()" class="command"><%=strTitle[SESS_LANGUAGE][12]%></a></td>
                            <%}
                                else{
                                %>
                                        <td width="24%"><a href="javascript:cmdPosted()" class="command"><%if(orderAktiva.getSellingStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0){%><%=strTitle[SESS_LANGUAGE][10]%><%}%></a></td>
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
