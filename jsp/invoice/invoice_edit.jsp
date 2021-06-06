<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.aiso.form.invoice.*,				   
                   com.dimata.aiso.entity.invoice.*,
		   com.dimata.aiso.session.invoice.*,
		   com.dimata.aiso.entity.costing.*,
                   com.dimata.util.Command,
		   com.dimata.common.form.contact.*, 
		   com.dimata.common.form.search.*,
                   com.dimata.util.Formater,
                   com.dimata.gui.jsp.ControlDate,
                   com.dimata.interfaces.trantype.I_TransactionType,
                   com.dimata.gui.jsp.ControlCombo,
                   com.dimata.aiso.entity.masterdata.*,
		   com.dimata.gui.jsp.ControlLine,
                   com.dimata.common.entity.payment.CurrencyType,
                   com.dimata.common.entity.payment.PstCurrencyType,
                   com.dimata.common.entity.contact.ContactList,
                   com.dimata.common.entity.contact.PstContactList,
		   com.dimata.aiso.printout.*,
                   com.dimata.gui.jsp.ControlList,
                   com.dimata.common.entity.payment.PstStandartRate,
                   com.dimata.common.entity.payment.StandartRate" %>
<%@ page import = "com.dimata.printman.*" %>
<%@ page import = "com.dimata.aiso.printout.*" %>				   
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
		"Tiket",//0
		"Paket",//1
		"No.",//2
		"Pelanggan",//3
		"Kepada",//4
		"U/p",//5
		"Telepon",//6
		"Perkiraan",//7
		"Nama Tamu",//8
		"Nama Hotel",//9
		"Invoice",//10
		"Tanggal",//11
		"Check In",//12
		"Check Out",//13
		"Status",//14
		"Total Tamu",//15
		"Total Kamar",//16
		"Nomor Referensi",//17
		"Keterangan",//18
		"Penyesuaian",//19
		"Perincian termin pembayaran piutang",//20
		"Perkiraan Hutang",//21
		"Perincian termin pembayaran hutang",//22
		"Jatuh Tempo",//23
		"Fax",//24
		"Hari",//25
		"Posted",//26
		"No Rek.",//27
		"Nama Bank",//28
		"Pemegang Rek.",//29
		"Batas Waktu Uang Muka",//30
		"Catatan"//31
	},
	{
		"Ticket",
		"Package",
		"No.",
		"Customer",
		"To.",
		"Attention",
		"Phone No.",
		"Chart of Account",
		"Guest Name",
		"Hotel Name",
		"Invoice",
		"Date",
		"Check In",
		"Check Out",
		"Status",
		"Total Pax",
		"Total Room",
		"Ref Number",
		"Note",
		"Adjustment",
		"List receivable payment term",
		"Payable Account",
		"List payable payment term",
		"Term of Payment",
		"Fax",
		"Day(s)",
		"Posted",
		"Acc. No.",
		"Bank Name",
		"Acc. Name",
		"Deposit Limit Time",
		"Note"
	}
};

public static String strHeaderReportLKU[][] = {
	{"No","Keterangan","Debet","Kredit","Saldo","Catatan","Penjualan","Biaya","Dilaporkan Oleh",
	"Diketahui","Disetujui","LKU No","Perusahaan","Tujuan","Hotel","Tanggal","Total Peserta","Agen Lokal",
	"Pimpinan Rombongan","Menejer","Direktur"},
	{"No","Description","Debit","Credit","Balance","Remark","Selling","Costing","Reported By",
	"Acknowledge By","Approved By","LKU No","Company Data","Destination","Hotel Name","Date","Total Passengger","Local Agent",
	"Team Leader","Dept Head","Director"}
};

public static String strItemTitle[][] = {
	{"No","Perkiraan","Nama Pelanggan","Keterangan","Tanggal","Qty","@Harga","Diskon","Total Harga"},
	{"No","Chart of Account","Name of Pax","Description","Date","Qty","@Price","Discount","Amount"}
};

public static String strCostingTitle[][] = {
	{"No","Perkiraan","Nama Penyedia","Keterangan","Jumlah","Harga Satuan","Diskon","Total Harga","Status","Nota Supplier"},
	{"No","Chart of Account","Supplier","Description","Number","Unit Price","Discount","Amount","App Status","Ref No."}
};

public static String strPaymentTerm[][] = {
	{"No","Jatuh Tempo","Jumlah","Keterangan"},
	{"No","Due Date","Amount","Description"}
};


public static final String masterTitle[] = {
	"Invoice","Invoice"
};

public static final String listTitle[] = {
	"Reservasi","Reservation"
};

public String getAccName(Perkiraan objPerkiraan, int language){
	if(objPerkiraan != null){
		if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			return objPerkiraan.getAccountNameEnglish();
		}else{
			return objPerkiraan.getNama();
		}
	}else{
		return "";
	}
}

public String getContactName(ContactList objCntList){
	if(objCntList != null){
		try{
			if(objCntList.getCompName() != null){
				return objCntList.getCompName();
			}else{
				return objCntList.getPersonName();
			}
		}catch(Exception e){}
	}
	return "";
}

public Vector drawList(int language, Vector objectClass, int iLinkRow){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strItemTitle[language][0],"3%","center","center"); // No
	ctrlist.dataFormat(strItemTitle[language][1],"17%","center","left"); // CoA
	ctrlist.dataFormat(strItemTitle[language][2],"10%","center","left"); // Name of Pax
	ctrlist.dataFormat(strItemTitle[language][3],"20%","center","left"); // Description
	ctrlist.dataFormat(strItemTitle[language][4],"10%","center","center"); // Date
	ctrlist.dataFormat(strItemTitle[language][5],"5%","center","right"); // Number
	ctrlist.dataFormat(strItemTitle[language][6],"15%","center","left"); // Unit Price
	ctrlist.dataFormat(strItemTitle[language][7],"10%","center","left"); // Discount
	ctrlist.dataFormat(strItemTitle[language][8],"15%","center","left"); // Amount
	
	ctrlist.setLinkRow(iLinkRow);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditInvoiceDetail('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	Vector rowr = new Vector(1,1);
	Vector vResult = new Vector(1,1);
	Vector vDataToPrint = new Vector(1,1);
	int index = -1;
	long idPerkiraan = 0;
	Perkiraan objPerkiraan = new Perkiraan();
	InvoiceDetail objInvoiceDetail = new InvoiceDetail();
	String strPerk = "";
	double totDiscount = 0.0;
	double totAmount = 0.0;
		for (int i = 0; i < objectClass.size(); i++) {
			objInvoiceDetail = (InvoiceDetail)objectClass.get(i);
			idPerkiraan = objInvoiceDetail.getIdPerkiraan();
			if(idPerkiraan != 0){
				try{
					objPerkiraan = PstPerkiraan.fetchExc(idPerkiraan);
				}catch(Exception e){objPerkiraan = new Perkiraan();}
			}
			strPerk = getAccName(objPerkiraan,language);
			
			rowx = new Vector();
			rowx.add(""+(i+1));
			rowx.add(strPerk);
			rowx.add(objInvoiceDetail.getNameOfPax());
			rowx.add(objInvoiceDetail.getDescription());
			rowx.add(Formater.formatDate(objInvoiceDetail.getDate(),"dd-MM-yyyy"));
			rowx.add(""+objInvoiceDetail.getNumber());
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceDetail.getUnitPrice())+"</div>");
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceDetail.getItemDiscount())+"</div>");
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice())+"</div>");
			totDiscount += objInvoiceDetail.getItemDiscount();
			totAmount += objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice();
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objInvoiceDetail.getOID()));
			
			rowr = new Vector(1,1);
			rowr.add(objInvoiceDetail.getNameOfPax());
			rowr.add(objInvoiceDetail.getDescription());
			rowr.add(Formater.formatDate(objInvoiceDetail.getDate(),"dd-MM-yyyy"));
			rowr.add(""+objInvoiceDetail.getNumber());
			rowr.add(Formater.formatNumber(objInvoiceDetail.getUnitPrice(),"##,###"));
			rowr.add(Formater.formatNumber((objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice()) - objInvoiceDetail.getItemDiscount(),"##,###"));
			
			vDataToPrint.add(rowr);
		}
		
		if(objectClass != null && objectClass.size() > 0){
				rowx = new Vector(1,1);
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("<div align=\"right\">Grand Total</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totDiscount)+"</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount)+"</div>");
				lstData.add(rowx);
				
				rowx = new Vector(1,1);
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("<div align=\"right\">Netto</div>");
				rowx.add("");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount - totDiscount)+"</div>");
				lstData.add(rowx);
		}
		vResult.add(ctrlist.drawMe(index));
		vResult.add(vDataToPrint);
		vResult.add(""+totDiscount);
		return vResult;
}

public Vector drawListPackage(int language, Vector objectClass, int iLinkRow, InvoiceMain objInvoiceMain){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strItemTitle[language][0],"3%","center","center"); // No
	ctrlist.dataFormat(strItemTitle[language][1],"17%","center","left"); // CoA
    ctrlist.dataFormat(strItemTitle[language][3],"50%","center","left"); // Description
	 ctrlist.dataFormat(strItemTitle[language][5],"5%","center","right"); // Number
	ctrlist.dataFormat(strItemTitle[language][6],"15%","center","left"); // Unit Price
	ctrlist.dataFormat(strItemTitle[language][8],"15%","center","left"); // Amount

	ctrlist.setLinkRow(iLinkRow);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditInvoiceDetail('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	Vector rowy = new Vector(1,1);
	Vector vResult = new Vector(1,1);
	Vector vDataToPrint = new Vector(1,1);
	int index = -1;
	long idPerkiraan = 0;
	Perkiraan objPerkiraan = new Perkiraan();
	InvoiceDetail objInvoiceDetail = new InvoiceDetail();
	String strPerk = "";
	double totAmount = 0.0;
		for (int i = 0; i < objectClass.size(); i++) {
			objInvoiceDetail = (InvoiceDetail)objectClass.get(i);
			idPerkiraan = objInvoiceDetail.getIdPerkiraan();
			if(idPerkiraan != 0){
				try{
					objPerkiraan = PstPerkiraan.fetchExc(idPerkiraan);
				}catch(Exception e){objPerkiraan = new Perkiraan();}
			}
			strPerk = getAccName(objPerkiraan,language);
			int iRows = objInvoiceDetail.getDescription().length() / 40;
			
			rowx = new Vector(1,1);
			rowx.add(""+(i+1));
			rowx.add(strPerk);
			rowx.add("<textarea rows=\""+iRows+"\" readOnly cols=\"40\" name=\"desc\">"+objInvoiceDetail.getDescription()+"</textarea>");
			rowx.add(""+objInvoiceDetail.getNumber());
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceDetail.getUnitPrice())+"</div>");
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice())+"</div>");
			totAmount += objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice();
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objInvoiceDetail.getOID()));
			
			rowy = new Vector(1,1);
			rowy.add(objInvoiceDetail.getDescription());			
			rowy.add(Formater.formatNumber(objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice(), "##,###"));
			vDataToPrint.add(rowy);
			
		}
		
		if(objectClass != null && objectClass.size() > 0){
				rowx = new Vector(1,1);
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("<div align=\"right\">Grand Total</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount)+"</div>");
				lstData.add(rowx);
				
				if(objInvoiceMain.getTermOfPayment() > 0){
						if(objInvoiceMain.getTax() > 0){
							Perkiraan prk = new Perkiraan();
							String sPerk = "";
							if(objInvoiceMain.getIdPerkDeposit() != 0){
								try{
									prk = PstPerkiraan.fetchExc(objInvoiceMain.getIdPerkDeposit());
									if(prk != null){
										sPerk = getAccName(prk,language);
									}
								}catch(Exception e){}
							}
							rowx = new Vector(1,1);
							rowx.add("");
							rowx.add("");
							rowx.add("");
							rowx.add("");
							if(iLinkRow > -1){
								rowx.add("<div align=\"right\"><a href=\"javascript:cmdAddDeposit()\"> Deposit / "+sPerk+"</a></div>");
							}else{
								rowx.add("<div align=\"right\">Deposit / "+sPerk+"</div>");
							}
							rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceMain.getTax())+"</div>");
							lstData.add(rowx);
							
							rowx = new Vector(1,1);
							rowx.add("");
							rowx.add("");
							rowx.add("");
							rowx.add("");
							rowx.add("<div align=\"right\">Balance</div>");
							rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount - objInvoiceMain.getTax())+"</div>");
							lstData.add(rowx);
						}
				}
		}
		vResult.add(ctrlist.drawMe(index));
		vResult.add(vDataToPrint);
		vResult.add(Formater.formatNumber(totAmount, "##,###"));
		return vResult;
}

public String listPayTerm(int language, Vector objectClass, int iCommand, int iLinkRow){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("60%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strPaymentTerm[language][0],"3%","center","center"); // No
    ctrlist.dataFormat(strPaymentTerm[language][1],"17%","center","center"); // Term of Payment
    ctrlist.dataFormat(strPaymentTerm[language][2],"10%","center","right"); // Amount
    ctrlist.dataFormat(strPaymentTerm[language][3],"20%","center","left"); // Description

	ctrlist.setLinkRow(iLinkRow);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditPayTerm('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
	String strPlanPayment = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Plan payment for invoice no. " : "Termin pembayaran untuk invoice no. ";
	PaymentTerm objPaymentTerm = new PaymentTerm();
	double totAmount = 0.0;
		for (int i = 0; i < objectClass.size(); i++) {
			objPaymentTerm = (PaymentTerm)objectClass.get(i);
			
			rowx = new Vector();
			rowx.add(""+(i+1));
			rowx.add(Formater.formatDate(objPaymentTerm.getPlanDate(),"dd-MM-yyyy"));
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objPaymentTerm.getAmount())+"</div>");
			rowx.add(objPaymentTerm.getNote());
			totAmount += objPaymentTerm.getAmount();
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objPaymentTerm.getOID()));
		}
		
		if(objectClass != null && objectClass.size() > 0){
				rowx = new Vector(1,1);
				rowx.add("");
				rowx.add("<div align=\"right\">Grand Total</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount)+"</div>");
				rowx.add("");
				lstData.add(rowx);
		}
		
		return ctrlist.drawMe(index);
}

public Vector drawListCosting(int language, Vector objectClass, int iCommand, int iLinkRow){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strCostingTitle[language][0],"3%","center","center"); // No
	ctrlist.dataFormat(strCostingTitle[language][1],"17%","center","left"); // CoA
	ctrlist.dataFormat(strCostingTitle[language][2],"10%","center","left"); // Name of Pax
	ctrlist.dataFormat(strCostingTitle[language][9],"10%","center","left"); // Reference
	ctrlist.dataFormat(strCostingTitle[language][3],"15%","center","left"); // Description
	ctrlist.dataFormat(strCostingTitle[language][4],"10%","center","right"); // Date
	ctrlist.dataFormat(strCostingTitle[language][5],"5%","center","right"); // Number
	ctrlist.dataFormat(strCostingTitle[language][6],"10%","center","right"); // Unit Price
	ctrlist.dataFormat(strCostingTitle[language][7],"10%","center","right"); // Discount
	ctrlist.dataFormat(strCostingTitle[language][8],"15%","center","left"); // Amount

	ctrlist.setLinkRow(iLinkRow);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();	
	ctrlist.setLinkPrefix("javascript:cmdEditCosting('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	Vector rowy = new Vector(1,1);
	Vector vTemp = new Vector(1,1);
	Vector vResult = new Vector(1,1);
	Vector vDataToPrint = new Vector(1,1);
	int index = -1;
	long idPerkiraan = 0;
	Perkiraan objPerkiraan = new Perkiraan();
	Costing objCosting = new Costing();
	String strPerk = "";
	String strAccName = "";
	Vector vAccValue = new Vector(1,1);
	Vector vAccKey = new Vector(1,1);
	double totDiscount = 0.0;
	double totAmount = 0.0;
	ContactList objCntList = new ContactList();
	String strContact = "";
		for (int i = 0; i < objectClass.size(); i++) {
			objCosting = (Costing)objectClass.get(i);
			idPerkiraan = objCosting.getIdPerkiraanHpp();
			if(idPerkiraan != 0){
				try{
					objPerkiraan = PstPerkiraan.fetchExc(idPerkiraan);
				}catch(Exception e){objPerkiraan = new Perkiraan();}
			}
			strPerk = getAccName(objPerkiraan,language);
			
			if(objCosting.getContactId() != 0){
				try{
					objCntList = PstContactList.fetchExc(objCosting.getContactId());
				}catch(Exception e){}
			}
			
			if(objCntList != null){
				strContact = getContactName(objCntList);
			}	
			
			String strStatus = "";
			if(objCosting.getStatus() == I_DocStatus.DOCUMENT_STATUS_CANCELLED){
				strStatus = "Void";
			}else{
				strStatus = I_DocStatus.fieldDocumentStatus[objCosting.getStatus()];
			}
			
			int iRows = objCosting.getDescription().length() / 40;
			rowx = new Vector();
			rowx.add(""+(i+1));
			rowx.add(strPerk);
			rowx.add(strContact);
			rowx.add(objCosting.getReference());
			rowx.add("<textarea rows=\""+iRows+"\" readOnly cols=\"40\" name=\"desc\">"+objCosting.getDescription()+"</textarea>");
			rowx.add(""+objCosting.getNumber());
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objCosting.getUnitPrice())+"</div>");
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objCosting.getDiscount())+"</div>");
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objCosting.getNumber() * objCosting.getUnitPrice())+"</div>");
			rowx.add(strStatus);
			totDiscount += objCosting.getDiscount();
			totAmount += objCosting.getNumber() * objCosting.getUnitPrice();
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objCosting.getOID()));
			
			rowy = new Vector(1,1);
			rowy.add(strContact+" : Invoice : "+objCosting.getReference()+" "+objCosting.getDescription());
			rowy.add(Formater.formatNumber(((objCosting.getNumber() * objCosting.getUnitPrice()) - (objCosting.getNumber() * objCosting.getDiscount())),"##,###"));
			vTemp.add(rowy);
		}
		
		vDataToPrint.add(vTemp);
		vDataToPrint.add(Formater.formatNumber((totAmount - totDiscount), "##,###"));
		
		if(objectClass != null && objectClass.size() > 0){
				rowx = new Vector(1,1);
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("<div align=\"right\">Grand Total</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totDiscount)+"</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount)+"</div>");
				rowx.add("");
				lstData.add(rowx);
				
				rowx = new Vector(1,1);
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("<div align=\"right\">Netto</div>");
				rowx.add("");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount - totDiscount)+"</div>");
				rowx.add("");
				lstData.add(rowx);
		}
		vResult.add(ctrlist.drawMe(index));
		vResult.add(vDataToPrint);
		return vResult;
}

public String listApPayTerm(int language, Vector objectClass, int iCommand, int iLinkRow){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("60%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strPaymentTerm[language][0],"3%","center","center"); // No
    ctrlist.dataFormat(strPaymentTerm[language][1],"17%","center","center"); // Term of Payment
    ctrlist.dataFormat(strPaymentTerm[language][2],"10%","center","right"); // Amount
    ctrlist.dataFormat(strPaymentTerm[language][3],"20%","center","left"); // Description

	ctrlist.setLinkRow(iLinkRow);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditApPayTerm('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
	String strPlanPayment = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Plan payment payable for invoice no. " : "Termin pembayaran hutang untuk invoice no. ";
	PaymentTerm objApPaymentTerm = new PaymentTerm();
	double totAmount = 0.0;
		for (int i = 0; i < objectClass.size(); i++) {
			objApPaymentTerm = (PaymentTerm)objectClass.get(i);
			
			rowx = new Vector();
			rowx.add(""+(i+1));
			rowx.add(Formater.formatDate(objApPaymentTerm.getPlanDate(),"dd-MM-yyyy"));
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objApPaymentTerm.getAmount())+"</div>");
			rowx.add(objApPaymentTerm.getNote());
			totAmount += objApPaymentTerm.getAmount();
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objApPaymentTerm.getOID()));
		}
		
		if(objectClass != null && objectClass.size() > 0){
				rowx = new Vector(1,1);
				rowx.add("");
				rowx.add("<div align=\"right\">Grand Total</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount)+"</div>");
				rowx.add("");
				lstData.add(rowx);
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
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int index = FRMQueryString.requestInt(request,"index");
long oidInvoiceMain = FRMQueryString.requestLong(request,"invoice_main_id");
int iQueryType = FRMQueryString.requestInt(request, "query_type");
long oidInvoiceDetail = FRMQueryString.requestLong(request,"invoice_detail_id");
long oidPerkCash = FRMQueryString.requestLong(request,FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ID_PERKIRAAN]+"_cash");
long oidPerkAr = FRMQueryString.requestLong(request,FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ID_PERKIRAAN]+"_ar");
long oidCosting = FRMQueryString.requestLong(request,"costing_id");
long oidApPaymentTerm = FRMQueryString.requestLong(request,"payment_ap_term_id");
long oidPaymentTerm = FRMQueryString.requestLong(request,"payment_term_id");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
int iTopPackage = FRMQueryString.requestInt(request, FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]+"_package");
int iTopTicket = FRMQueryString.requestInt(request, FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]+"_ticket");
int posTed = FRMQueryString.requestInt(request,"posted_status");
int iInvoiceType = FRMQueryString.requestInt(request,"invoice_type");
int iTop = 0;

if(iInvoiceType == 0){
	iTop = iTopTicket;
}else{
	iTop = iTopPackage;
}


long lIdPerkiraan = 0;
if(iTop == 0){
	lIdPerkiraan = oidPerkCash;
}else{
	lIdPerkiraan = oidPerkAr;
}


/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New" : "Tambah Baru";
String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Invoice" : "Simpan Data";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : " Tambah Detail";
String strAddPayTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add A/R Payment Term" : " Tambah Termin Pembayaran Piutang";
String strAddCosting = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Costing" : " Tambah Pembiayaan";
String strAddApPayTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add A/P Payment Term" : " Tambah Termin Pembayaran Hutang";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Invoice List" : "Kembali Ke Daftar Invoice";
String strPrintHtml = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Print Invoice Excel" : "Cetak Invoice Excel";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete" : "Hapus";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strPackage = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Package" : "Paket";
String strCetakLKU = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Print LKU" : "Cetak LKU";
String strTicket = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Ticket" : "Tiket";
String strTransaction = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Transaction" : "Transaksi";
String strCredit = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Credit" : "Kredit";
String strAddDeposit = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add Deposit" : "Entry Deposit";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete" : "Ya Hapus Order";
String strListInvoiceDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Detail Invoice" : "Daftar Perincian Invoice";
String strListCostingDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Costing Data Entry" : "Input Data Pembiayaan";
String strListPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Receivable Payment Term" : "Daftar Termin Pembayaran Piutang";
String strListApPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Payable Payment Term" : "Daftar Termin Pembayaran Hutang";
String strPayableAcc = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Payable Account : " : "Perkiraan Hutang : ";
String strInvoiceType = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Invoice Type" : "Tipe Invoice";
String strApproved = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Approved" : "Sahkan";
String strPrint = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Print Invoice" : "Cetak Invoice";
String strVoid = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Voiding Invoice" : "Batalkan Invoice";
String strDueDate = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Due Date" : "Jatuh Tempo";
String strSelectPrinter = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Select Printer" : "Pilih Printer";
String strAskApproved1 = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "System will change document status to Final." : "Sistem akan merubah status dokumen menjadi Final.";
String strAskApproved2 = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Make sure your data is correct, because document" : "Pastikan semua data sudah benar, sebab dokumen";
String strAskApproved3 = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "can not be edit after approval process." : "tidak bisa diubah setelah proses approval.";
String strPosted1 = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "System will change document status to Posted" : "Sistem akan merubah status dokumen menjadi Posted";
String strPosted2 = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Make sure your data is correct, because document" : "Pastikan semua data sudah benar, sebab dokumen";
String strPosted3 = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "can not be edit after posting process." : "tidak bisa diubah setelah proses posting.";


Vector vListCosting = new Vector(1,1);
if(iCommand != Command.ADD){
	if(oidInvoiceMain != 0){
		String strWhClauseCosting = PstCosting.fieldNames[PstCosting.FLD_INVOICE_ID]+" = "+oidInvoiceMain;
		vListCosting = PstCosting.list(0,0,strWhClauseCosting,"");
	}
}

/** Instansiasi object CtrlOrderAktiva and FrmOrderAktiva */
ControlLine ctrLine = new ControlLine();
CtrlInvoiceMain ctrlInvoiceMain = new CtrlInvoiceMain(request);
ctrlInvoiceMain.setLanguage(SESS_LANGUAGE);
FrmInvoiceMain frmInvoiceMain = ctrlInvoiceMain.getForm();
int iErrCode = 0;
if(iCommand == Command.PRINT){
	iErrCode = ctrlInvoiceMain.action(Command.EDIT, oidInvoiceMain, vListCosting, userOID);
}else{
	iErrCode = ctrlInvoiceMain.action(iCommand, oidInvoiceMain, vListCosting, userOID);
}

String yr = request.getParameter(FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ISSUED_DATE] + "_yr");
InvoiceMain objInvoiceMain = ctrlInvoiceMain.getInvoiceMain();
oidInvoiceMain = objInvoiceMain.getOID();
String msgString = ctrlInvoiceMain.getMassage();
if(iCommand == Command.DELETE){
	if(iQueryType == 1){
		response.sendRedirect("invoice_list.jsp");
	}else{
		iCommand = Command.ADD;
	}
}

int iLnkRow = 0;
if(objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT){
	iLnkRow = 1;
}else{
	iLnkRow = -1;
}

    // get nama company
    ContactList contactList = new ContactList();
	if(objInvoiceMain.getFirstContactId() != 0){
		try{
			contactList = PstContactList.fetchExc(objInvoiceMain.getFirstContactId());
		}catch(Exception e){contactList = new ContactList();}
	}
	
	String strFirstContact = "";
	String strFirstCompName = "";
	String strFirstPersonName = "";
	String strPhoneNumber = "";
	String strFaxNumber = "";
	if(contactList != null){
		strFirstCompName = contactList.getCompName();
		strPhoneNumber = contactList.getTelpNr();
		strFaxNumber = contactList.getFax();
		if(strFirstCompName != null && strFirstCompName.length() > 0){
			strFirstContact = strFirstCompName;
		}else{
			strFirstPersonName = contactList.getPersonName();
			if(strFirstPersonName != null && strFirstPersonName.length() > 0){
				strFirstContact = strFirstPersonName;
			}
		}
	}
	
	ContactList secondCntList = new ContactList();
	if(objInvoiceMain.getSecondContactId() != 0){
		try{
			secondCntList = PstContactList.fetchExc(objInvoiceMain.getSecondContactId());
		}catch(Exception e){secondCntList = new ContactList();}
    }
	
	String strSecondContact = "";
	String strSecondCompName = "";
	String strSecondPersonName = "";
	if(contactList != null){
		strSecondCompName = secondCntList.getCompName();
		if(strSecondCompName != null && strSecondCompName.length() > 0){
			strSecondContact = strSecondCompName;
		}else{
			strSecondPersonName = secondCntList.getPersonName();
			if(strSecondPersonName != null && strSecondPersonName.length() > 0){
				strSecondContact = strSecondPersonName;
			}
		}
	}

	String whClause = PstInvoiceMain.fieldNames[PstInvoiceMain.FLD_INV_MAIN_ID]+" = "+oidInvoiceMain;
	Vector list = new Vector(1,1);
	String strWClause = PstCosting.fieldNames[PstCosting.FLD_INVOICE_ID]+" = "+oidInvoiceMain;
	Vector listCosting = new Vector(1,1);	
	String strWhere = PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_INVOICE_ID]+" = "+oidInvoiceMain+
				  " AND "+PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_TYPE]+" = "+PstPaymentTerm.PAY_TERM_AR;
	Vector listPayTerm = new Vector(1,1);
	String strWhrCls =  PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_INVOICE_ID]+" = "+oidInvoiceMain+
				  " AND "+PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_TYPE]+" = "+PstPaymentTerm.PAY_TERM_AP;
	Vector listApPayTerm = new Vector(1,1);
	String strNamaPerkiraan = "";
	if(iCommand != Command.ADD){
     	list = PstInvoiceDetail.list(0,0,whClause,"");
		listPayTerm = PstPaymentTerm.list(0,0,strWhere,"");
		listCosting = PstCosting.list(0,0,strWClause,"");
		listApPayTerm = PstPaymentTerm.list(0,0,strWhrCls,"");
		if(listCosting != null && listCosting.size() > 0){
			for(int i = 0; i < listCosting.size(); i++){
				Costing objCosting = (Costing)listCosting.get(i);
				if(objCosting.getIdPerkiraanHutang() != 0){
					Perkiraan objPerk = PstPerkiraan.fetchExc(objCosting.getIdPerkiraanHutang());
					strNamaPerkiraan = getAccName(objPerk,SESS_LANGUAGE);
				}
			}
		}
	}
	
	boolean allList = false;
	if(list.size() > 0 && listPayTerm.size() > 0 && listCosting.size() > 0 && listApPayTerm.size() > 0){
		allList = true;
	}
	
	int iCheckList = 0;
	if(list.size() > 0){
		iCheckList = 1;
	}
	
	if(list.size() > 0 && listPayTerm.size() > 0){
		iCheckList = 2;
	}
	
	if(list.size() > 0 && listPayTerm.size() > 0 && listCosting.size() > 0 ){
		iCheckList = 3;
	}

Vector listTemp = new Vector(1,1);
String strList = "";
String totInvoice = "";
String totDisc = "";
Vector vDataPrint = new Vector(1,1);
try{
	if(objInvoiceMain.getType() == 0){
		listTemp = (Vector)drawList(SESS_LANGUAGE,list,iLnkRow);
	}else{
		listTemp = (Vector)drawListPackage(SESS_LANGUAGE,list,iLnkRow,objInvoiceMain);
	}
		
	if(listTemp != null && listTemp.size() > 0){
		strList = listTemp.get(0).toString();
		vDataPrint = (Vector)listTemp.get(1);
		totInvoice = listTemp.get(2).toString();
		totDisc = listTemp.get(2).toString();
	}
}catch(Exception e){listTemp = new Vector(1,1);}
	
Vector vTitleMain = new Vector(1,1);
if(strTitle != null){
	for(int m = 0; m < strTitle[SESS_LANGUAGE].length; m++){
		vTitleMain.add(strTitle[SESS_LANGUAGE][m]);
	}
}

Vector vMain = new Vector(1,1);
String strType = "";
if(objInvoiceMain.getType() == 0){
	strType = strTicket.toUpperCase();
}else{
	strType = strPackage.toUpperCase();
}

Date dueDate = new Date();
if(objInvoiceMain.getIssuedDate() != null){
	try{
		dueDate = (Date)objInvoiceMain.getIssuedDate().clone();
		if(objInvoiceMain.getTermOfPayment() > 0){
			int iDate = dueDate.getDate();
			int iDueDate = iDate + objInvoiceMain.getTermOfPayment();
			dueDate.setDate(iDueDate);
		}
	}catch(Exception e){dueDate = new Date();}
}

try{
	vMain.add(compName);//0
	vMain.add(compAddr);//1
	vMain.add(compPhone);//2
	vMain.add(strInvoiceType);//3
	vMain.add(strType);//4
	vMain.add(strFirstContact);//5
	vMain.add(objInvoiceMain.getInvoiceNumber());//6
	vMain.add(Formater.formatDate(dueDate,"dd-MM-yyyy"));//7
	vMain.add(Formater.formatDate((objInvoiceMain.getIssuedDate() == null) ? new Date() : objInvoiceMain.getIssuedDate(), "dd-MM-yyyy"));//8
	vMain.add(strTransaction);//9
	vMain.add(strCredit);//10
	vMain.add(strDueDate);//11
	vMain.add(compCity);//12
	vMain.add(strSecondContact);//13
	vMain.add(Formater.formatDate((objInvoiceMain.getCheckInDate() == null) ? new Date() : objInvoiceMain.getCheckInDate(), "dd-MM-yyyy"));//14
	vMain.add(strPhoneNumber);//15
	vMain.add(strFaxNumber);//16
	vMain.add(Formater.formatDate((objInvoiceMain.getCheckOutDate() == null) ? new Date() : objInvoiceMain.getCheckOutDate(), "dd-MM-yyyy"));//17
	vMain.add(objInvoiceMain.getGuestName());//18
	vMain.add(""+objInvoiceMain.getTotalPax());//19
	vMain.add(objInvoiceMain.getHotelName());//20
	vMain.add(""+objInvoiceMain.getTotalRoom());//21
	vMain.add(accBankName);//22.toString().toUpperCase()
	vMain.add(accBankNo);//23
	vMain.add(bankName);//24
	vMain.add(""+objInvoiceMain.getTermOfPayment());//25
	vMain.add(""+objInvoiceMain.getTax());//26
	vMain.add(userFullName);//27
	vMain.add(totDisc);//28
}catch(Exception e){}



Vector vListTitleDetail = new Vector(1,1);
if(strItemTitle != null){
	for(int d = 0; d < strItemTitle[SESS_LANGUAGE].length; d++){
		vListTitleDetail.add(strItemTitle[SESS_LANGUAGE][d]);
	}
}



if (iCommand == Command.PRINT) {
			String hostIpIdx ="";
			hostIpIdx = request.getParameter("printeridx");// ip server				
			DSJ_PrintObj obj = null;
			if(hostIpIdx!=null){
				if(objInvoiceMain.getType() == 0){
					obj = PrintInvoice.PrintForm(vListTitleDetail,vMain,vTitleMain,vDataPrint);
				}else{
					obj = PrintPackage.PrintForm(vListTitleDetail,vMain,vTitleMain,vDataPrint);
				}
				PrinterHost prnHost = RemotePrintMan.getPrinterHost(hostIpIdx,";");
				PrnConfig prn = RemotePrintMan.getPrinterConfig(hostIpIdx,";");
				obj.setPrnIndex(prn.getPrnIndex());
				RemotePrintMan.printObj(prnHost,obj);
			}
			
		}

Vector vPrintTicketHtml = new Vector(1,1);
vPrintTicketHtml.add(vListTitleDetail);
vPrintTicketHtml.add(vMain);
vPrintTicketHtml.add(vTitleMain);
vPrintTicketHtml.add(vDataPrint);

if(session.getValue("PRINT_HTML") != null)
	session.removeValue("PRINT_HTML");

session.putValue("PRINT_HTML",vPrintTicketHtml);

//Data for Laporan Kegiatan Usaha Package
Vector vLKUMain = new Vector(1,1);
Vector vPrintPdf = new Vector(1,1);
vLKUMain.add(objInvoiceMain.getInvoiceNumber());//0
vLKUMain.add(strFirstContact);//1
vLKUMain.add(objInvoiceMain.getHotelName());//2
vLKUMain.add(Formater.formatDate((objInvoiceMain.getCheckInDate() == null) ? new Date() : objInvoiceMain.getCheckInDate(), "dd-MM-yyyy"));//3
vLKUMain.add(Formater.formatDate((objInvoiceMain.getCheckOutDate() == null) ? new Date() : objInvoiceMain.getCheckOutDate(), "dd MMM yyyy"));//4
vLKUMain.add(""+objInvoiceMain.getTotalPax());//5		

Vector vHeaderDetailLKU = new Vector(1,1);
for(int l = 0; l < strHeaderReportLKU[SESS_LANGUAGE].length; l++){
	vHeaderDetailLKU.add(strHeaderReportLKU[SESS_LANGUAGE][l]);
}

Vector vTempCosting = new Vector(1,1);
Vector vDataPdf = new Vector(1,1);
String strListCosting = "";
try{
	vTempCosting = (Vector)drawListCosting(SESS_LANGUAGE, listCosting, iCommand, iLnkRow);
	if(vTempCosting != null && vTempCosting.size() > 0){
		strListCosting = vTempCosting.get(0).toString();
		vDataPdf = (Vector)vTempCosting.get(1);
	}
}catch(Exception e){vTempCosting = new Vector(1,1);}

vPrintPdf.add(vLKUMain);//0
vPrintPdf.add(vHeaderDetailLKU);//1
vPrintPdf.add(vDataPdf);//2
vPrintPdf.add(totInvoice);//3
vPrintPdf.add(""+objInvoiceMain.getTax());//4

if(session.getValue("REPORT_LKU") != null){
	session.removeValue("REPORT_LKU");
}

session.putValue("REPORT_LKU",vPrintPdf);
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
	<%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode > 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
	var date1 = ""+document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ISSUED_DATE]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ISSUED_DATE]+ "_mn"%>.value=bln;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ISSUED_DATE] + "_dy"%>.value=hri;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ISSUED_DATE] + "_yr"%>.value=thn;
	
	var date2 = ""+document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKIN_DATE]%>.value;
	var thn1 = date2.substring(6,10);
	var bln1 = date2.substring(3,5);	
	if(bln1.charAt(0)=="0"){
		bln1 = ""+bln1.charAt(1);
	}
	
	var hri1 = date2.substring(0,2);
	if(hri1.charAt(0)=="0"){
		hri1 = ""+hri1.charAt(1);
	}
	
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKIN_DATE] + "_mn"%>.value=bln1;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKIN_DATE] + "_dy"%>.value=hri1;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKIN_DATE] + "_yr"%>.value=thn1;	
	
	
	var date3 = ""+document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKOUT_DATE]%>.value;
	var thn2 = date3.substring(6,10);
	var bln2 = date3.substring(3,5);	
	if(bln2.charAt(0)=="0"){
		bln2 = ""+bln2.charAt(1);
	}
	
	var hri2 = date3.substring(0,2);
	if(hri2.charAt(0)=="0"){
		hri2 = ""+hri2.charAt(1);
	}
	
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKOUT_DATE] + "_mn"%>.value=bln2;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKOUT_DATE] + "_dy"%>.value=hri2;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKOUT_DATE] + "_yr"%>.value=thn2;	

	var date4 = ""+document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_DEPOSIT_TIME_LIMIT]%>.value;
	var thn3 = date4.substring(6,10);
	var bln3 = date4.substring(3,5);	
	if(bln3.charAt(0)=="0"){
		bln3 = ""+bln3.charAt(1);
	}
	
	var hri3 = date4.substring(0,2);
	if(hri3.charAt(0)=="0"){
		hri3 = ""+hri3.charAt(1);
	}
	
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_DEPOSIT_TIME_LIMIT] + "_mn"%>.value=bln3;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_DEPOSIT_TIME_LIMIT] + "_dy"%>.value=hri3;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_DEPOSIT_TIME_LIMIT] + "_yr"%>.value=thn3;			
	
	<%}%>			
}

function cmdCancel(){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.NONE%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdopen(){
	var url = "";
	var idContact = Math.abs(document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_FIRST_CONTACT_ID]%>.value);
	
	if(idContact == 0){
		url = "srccontact_list.jsp?command=<%=Command.LIST%>&"+							
		      "<%=FrmSrcContactList.fieldNames[FrmSrcContactList.FRM_FIELD_NAME] %>="+document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_FIRST_CONTACT_ID]%>_TEXT.value;
	}else{
		url = "srccontact_list.jsp?command=<%=Command.LIST%>";
	}
	myWindow = window.open(url,"src_invoice_main","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function entContact(){
	if(event.keyCode == 13)
	cmdopen();
}

function cmdAddDeposit(){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.SUBMIT%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdSave(){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdPrint(){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.PRINT%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdAsk(){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.ASK%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdEdit(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_main_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdApproved(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_main_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.SUBMIT%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	if(confirm("<%=strAskApproved1%>\n<%=strAskApproved2%>\n<%=strAskApproved3%>")){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
	}
}

function cmdVoid(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_main_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.UPDATE%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	if(confirm("<%=strAskApproved1%>\n<%=strAskApproved2%>\n<%=strAskApproved3%>")){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
	}
}

function cmdPosted(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_main_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.POST%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	if(confirm("<%=strPosted1%>\n<%=strPosted2%>\n<%=strPosted3%>")){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
	}
}

function cmdEditInvoiceDetail(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_detail_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdEditPayTerm(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.payment_term_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="payment_term.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdEditCosting(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.costing_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="costing.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdEditApPayTerm(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.payment_ap_term_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="ap_payment_term.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdDelete(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_main_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdEditItem(oid){
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.LIST%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdAddDetail(oid){
    document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_main_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdAddPayTerm(oid){
    document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_main_id.value=oid;
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="payment_term.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdAddCosting(oid){
    document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_main_id.value=oid;	
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="costing.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

function cmdAddApPayTerm(oid){
    document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_main_id.value=oid;	
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="ap_payment_term.jsp";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
}

<%}%>

function cmdBack(){
	<% switch(iQueryType){
		case 0:%>
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.ADD%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_edit.jsp";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
		<%break;
		case 1:%>
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.LIST%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="1";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.start.value="<%=start%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_list.jsp";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
		<%break;
		case 2:%>
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.LIST%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.start.value="<%=start%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="post_invoice_list.jsp";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
		<%break;
		case 3:%>
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.LIST%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.start.value="<%=start%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="void_invoice_list.jsp";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
		<%break;
		case 4:%>
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.LIST%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="2";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.start.value="<%=start%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_list.jsp";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
		<%break;
		case 5:%>
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.LIST%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value="2";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.start.value="<%=start%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="invoice_list.jsp";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
		<%break;
		case 6:%>
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.query_type.value="<%=iQueryType%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.command.value="<%=Command.LIST%>";		
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.start.value="<%=start%>";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.action="update_invoice_list.jsp";
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.submit();
		<%break;
	}%>
}

function hidePackage(){
	document.getElementById("telpon").style.display = "none";
	document.getElementById("contact").style.display = "none";
	document.getElementById("guest").style.display = "none";
	document.getElementById("hotel").style.display = "none";
	document.getElementById("timelimit1").style.display = "none";
	document.getElementById("timelimit2").style.display = "none";
	document.getElementById("timelimit3").style.display = "none";
	document.getElementById("toppackage").style.display = "none";
	document.getElementById("description").style.display = "none";
	document.getElementById("topticket1").style.display = "";
	document.getElementById("topticket2").style.display = "";
	document.getElementById("topticket3").style.display = "";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value = "0";
}

function showPackage(){
	document.getElementById("telpon").style.display = "";
	document.getElementById("contact").style.display = "";
	document.getElementById("guest").style.display = "";
	document.getElementById("hotel").style.display = "";
	document.getElementById("timelimit1").style.display = "";
	document.getElementById("timelimit2").style.display = "";
	document.getElementById("timelimit3").style.display = "";
	document.getElementById("toppackage").style.display = "";
	document.getElementById("description").style.display = "";
	document.getElementById("topticket1").style.display = "none";
	document.getElementById("topticket2").style.display = "none";
	document.getElementById("topticket3").style.display = "none";
	document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value = "1";
}

function hideTopTicket(){
	document.getElementById("topticket1").style.display = "none";
	document.getElementById("topticket2").style.display = "none";
	document.getElementById("topticket3").style.display = "none";
}

function changeAccChart(){
	var top = 0;
	var iInvType = 0;
	<%if(iCommand == Command.ADD || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
		iInvType = Math.abs(document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.invoice_type.value);
		if(iInvType == 0){
			top = Math.abs(document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]+"_ticket"%>.value);
		}else{
			top = Math.abs(document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]+"_package"%>.value);
		}
	<%}%>
	
	
	if(top > 0){
		document.getElementById("receivable").style.display = "";
		document.getElementById("cash").style.display = "none";
		<%if(iCommand == Command.ADD || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
		document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ID_PERKIRAAN]%>.value = document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ID_PERKIRAAN]+"_ar"%>.value;
		if(iInvType == 0){
		document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]%>.value = document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]+"_ticket"%>.value;
		}else{
			document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]%>.value = document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]+"_package"%>.value;
		}
		<%}%>
	}else{
		document.getElementById("receivable").style.display = "none";
		document.getElementById("cash").style.display = "";
		<%if(iCommand == Command.ADD || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
		document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ID_PERKIRAAN]%>.value = document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ID_PERKIRAAN]+"_cash"%>.value;
		<%}%>
	}
}

function cmdopen(){
	var url = "srccontact_list.jsp?cnt_type=0&inv_type="+document.<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TYPE]%>.value;
    window.open(url,"search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdopenCnt(){
	var url = "srccontact_list.jsp?cnt_type=1";
    window.open(url,"search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function reportPdf(){	 
	var linkPage = "<%=reportroot%>report.lapKegiatanUsaha.LapKegUsahaPackagePdf";       
	window.open(linkPage);  				
}

function printXLS(){
		var linkPage = "<%=reportroot%>report.invoice.InvoiceTicketXls";
		window.open(linkPage);
}

function cmdPrintTicket()
{
	<%if(objInvoiceMain.getType() == 0){%>
		window.open("print_ticket.jsp","print_ticket","height=480,width=640,left=300,top=150,status=yes,toolbar=no,menubar=yes,location=no,scrollbars=yes");
	<%}else{%>
		window.open("print_package.jsp","print_package","height=480,width=640,left=300,top=150,status=yes,toolbar=no,menubar=yes,location=no,scrollbars=yes");
	<%}%>
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
            <form name="<%=FrmInvoiceMain.FRM_INVOICE_MAIN%>" method="post" action="">
              <!-- input type="hidden" name="command" value="<%//=iCommand==Command.ADD ? Command.ADD : Command.NONE%>" -->
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="invoice_main_id" value="<%=oidInvoiceMain%>">
              <input type="hidden" name="invoice_detail_id" value="<%=oidInvoiceDetail%>">
              <input type="hidden" name="costing_id" value="<%=oidCosting%>">
              <input type="hidden" name="invoice_type" value="<%=iInvoiceType%>">
              <input type="hidden" name="payment_ap_term_id" value="<%=oidApPaymentTerm%>">
              <input type="hidden" name="payment_term_id" value="<%=oidPaymentTerm%>">
              <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]%>" value="<%=String.valueOf(iTop)%>">
	      <input type="hidden" name="posted_status" value="0">	
              <input type="hidden" name="query_type" value="<%=iQueryType%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_STATUS]%>" value="<%=objInvoiceMain.getStatus()%>">
              <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TOTAL_DISCOUNT]%>" value="0">
              <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TAX]%>" value="0">
              <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ID_PERKIRAAN]%>" value="<%=lIdPerkiraan%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="100%" class="tabtitleactive" valign="top">
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
                            <tr>
                              <td width="94%">
                                <table width="100%">
				<%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                  <tr>
                                    <td height="25" colspan="9">
					<table width="20%"  border="0">
                                            <tr>
                                                <td width="11%"><input type="radio" onClick="javascript:hidePackage()" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TYPE]%>" value="0" <%if(objInvoiceMain.getType() == 0){%>checked<%}%>></td>
                                                <td width="39%"><b><%=strTicket%></b></td> 
                                                <td width="12%"><input type="radio" onClick="javascript:showPackage()" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TYPE]%>" value="1" <%if(objInvoiceMain.getType() == 1){%>checked<%}%>></td>                                        
                                                <td width="38%"><b><%=strPackage%></b></td>
                                            </tr>
                                        </table>
                                    </td>
                                   </tr>
				<%}else{%>
                                    <tr>
                                        <td colspan="9">&nbsp;<b><%=strInvoiceType%> : <font color="#CC3300"><%=objInvoiceMain.getType() == 0? strTicket.toUpperCase() : strPackage.toUpperCase()%></font></b></td>
                                    </tr>
                                <%}%>
                                    <tr>
					<td colspan="9">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%>&nbsp;<b><%=objInvoiceMain.getInvoiceNumber()%></b></td>
                                        <td width="1%" height="25">&nbsp;</td>
                                        <td height="25" colspan="3">&nbsp;</td>
                                        <td width="12%">&nbsp;</td>
                                        <td width="13%" height="25">&nbsp;</td>
                                        <td width="1%" height="25">&nbsp;</td>
                                        <td width="25%" height="25"><b><%=strTitle[SESS_LANGUAGE][10].toUpperCase()%></b></td>
                                    </tr>
                                    <tr>
                                        <td height="25">&nbsp;<b><%=strTitle[SESS_LANGUAGE][3]%></b></td>
                                        <td height="25">&nbsp;</td>
                                        <td height="25" colspan="3">&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][14]%></td>
                                        <td height="25"><b>:</b></td>
                                        <td height="25">
                                            <%if(objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_CANCELLED){%>
                                                Void
                                            <%}else{%>
                                                <%=I_DocStatus.fieldDocumentStatus[objInvoiceMain.getStatus()]%>
                                            <%}%>
                                        </td>
                                    </tr>
                                    <tr>
                                    <td height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][4]%></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25" colspan="3">
                                    <%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                        <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_FIRST_CONTACT_ID]%>" value="<%=objInvoiceMain.getFirstContactId()%>">
                                        <input type="text" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_FIRST_CONTACT_ID]%>_TEXT" value="<%=strFirstContact%>" onKeyDown="javascript:entContact()">
                                        &nbsp;<a href="javascript:cmdopen()"><img alt="search contact" border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
                                    <%}else{
					out.println(strFirstContact);
                                    }%>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][11]%></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25">
                                    <%if(isUseDatePicker.equalsIgnoreCase("Y")){
					if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){
                                    %>
                                          <input onClick="ds_sh(this);" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ISSUED_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((objInvoiceMain.getIssuedDate() == null) ? new Date() : objInvoiceMain.getIssuedDate(), "dd-MM-yyyy")%>"/>
                                          <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ISSUED_DATE] + "_mn"%>">
                                          <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ISSUED_DATE] + "_dy"%>">
                                          <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ISSUED_DATE] + "_yr"%>">
                                    <%}else{
					  out.println(Formater.formatDate((objInvoiceMain.getIssuedDate() == null) ? new Date() : objInvoiceMain.getIssuedDate(), "dd-MM-yyyy"));
                                    }
                                    }%>
                                    </td>
                                  </tr>			  
                                  <tr id="contact">
                                    <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][5]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td height="25" colspan="3">
                                    <%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
					<input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_SECOND_CONTACT_ID]%>" value="<%=objInvoiceMain.getSecondContactId()%>">
					<input readonly type="text" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_SECOND_CONTACT_ID]%>_TEXT" value="<%=strSecondContact%>">
					&nbsp;<a href="javascript:cmdopenCnt()"><img alt="search contact" border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
                                    <%}else{
					out.println(strSecondContact);
                                    }%>
                                    </td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][12]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25">
                                    <%if(isUseDatePicker.equalsIgnoreCase("Y")){
                                          if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                            <input onClick="ds_sh(this);" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKIN_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((objInvoiceMain.getCheckInDate() == null) ? new Date() : objInvoiceMain.getCheckInDate(), "dd-MM-yyyy")%>"/>                                     
                                            <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKIN_DATE] + "_mn"%>">
                                            <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKIN_DATE] + "_dy"%>">
                                            <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKIN_DATE] + "_yr"%>">                                          
                                          <%}else{
                                            out.println(Formater.formatDate((objInvoiceMain.getCheckInDate() == null) ? new Date() : objInvoiceMain.getCheckInDate(), "dd-MM-yyyy"));
                                            }
                                    }%>		
                                    </td>
                                  </tr>								
                                  <tr id="telpon">
                                    <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][6]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="16%" height="25">
                                    <%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0)){%>
					<input disabled type="text" name="telpon" value="<%=strPhoneNumber%>">
                                    <%}else{%>
                                        <%=strPhoneNumber%>
                                    <%}%>
                                    </td>
                                    <td width="5%"><%=strTitle[SESS_LANGUAGE][24]%> :  </td>
                                    <td width="15%">
                                    <%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
					<input disabled size="10" type="text" name="fax" value="<%=strFaxNumber%>">
                                    <%}else{%>
					<%=strFaxNumber%>
                                    <%}%>
                                    </td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][13]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25">
                                    <%if(isUseDatePicker.equalsIgnoreCase("Y")){
					if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                          <input onClick="ds_sh(this);" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKOUT_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((objInvoiceMain.getCheckOutDate() == null) ? new Date() : objInvoiceMain.getCheckOutDate(), "dd-MM-yyyy")%>"/>
                                          <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKOUT_DATE] + "_mn"%>">
                                          <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKOUT_DATE] + "_dy"%>">
                                          <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_CHECKOUT_DATE] + "_yr"%>">
                                         <%}else{
						out.println(Formater.formatDate((objInvoiceMain.getCheckOutDate() == null) ? new Date() : objInvoiceMain.getCheckOutDate(), "dd-MM-yyyy"));  
                                            }										  
                                    }%>		
                                    </td>
                                  </tr>			  
                                  <tr>
                                    <td width="12%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][7]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td height="25" colspan="3" id="receivable">
					<%	
                                            String strPerkReceivable = "";
                                            if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){
						Vector perkiraanPayid_value = new Vector(1,1);
						Vector perkiraanPayid_key = new Vector(1,1);
						String sel_perkiraanPayid = ""+objInvoiceMain.getIdPerkiraan();
						Vector vMainAccount = new Vector(1,1);
						try{
                                                    vMainAccount = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_PIUTANG);
						}catch(Exception e){vMainAccount = new Vector(1,1);} 	   
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
                                            <%= ControlCombo.draw(FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ID_PERKIRAAN]+"_ar",null, sel_perkiraanPayid, perkiraanPayid_key, perkiraanPayid_value, "", "") %>                           
                                            <%}else{
						if(objInvoiceMain.getIdPerkiraan() != 0){
                                                    try{
							Perkiraan accReceivable = PstPerkiraan.fetchExc(objInvoiceMain.getIdPerkiraan());
							strPerkReceivable = getAccName(accReceivable, SESS_LANGUAGE);
                                                    }catch(Exception e){}
						}
                                            }%>
                                            <%=strPerkReceivable%>
                                    </td>
                                    <td height="25" colspan="3" id="cash">
					<%	
                                            String strCash = "";
                                            if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){
						Vector perkPayid_value = new Vector(1,1);
						Vector perkPayid_key = new Vector(1,1);
						String sel_perkPayid = ""+objInvoiceMain.getIdPerkiraan();
						Vector vMainAcc = new Vector(1,1);
						try{
                                                    vMainAcc = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_CASH);
						}catch(Exception e){vMainAcc = new Vector(1,1);} 
						if(vMainAcc!=null&&vMainAcc.size()>0){
                                                    for(int i=0;i<vMainAcc.size();i++){
							Perkiraan perkiraan =(Perkiraan)vMainAcc.get(i);
							String padding = "";
							for(int j=0;j<perkiraan.getLevel();j++){
                                                            padding = padding + "&nbsp;&nbsp;&nbsp;";
							}
							perkPayid_value.add(padding+perkiraan.getNoPerkiraan()+" "+perkiraan.getNama());
							perkPayid_key.add(""+perkiraan.getOID());
                                                    }
						}
                                            %>    
						<%= ControlCombo.draw(FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_ID_PERKIRAAN]+"_cash",null, sel_perkPayid, perkPayid_key, perkPayid_value, "", "") %>                           
                                            <%}else{
						if(objInvoiceMain.getIdPerkiraan() != 0){
                                                    try{
							Perkiraan cash = PstPerkiraan.fetchExc(objInvoiceMain.getIdPerkiraan());
							strCash = getAccName(cash, SESS_LANGUAGE);
                                                    }catch(Exception e){}
						}
                                            }%>
						<%=strCash%>
                                    </td>
					<td width="14%">&nbsp;</td>
				    <td width="14%" id="timelimit1" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][30]%></td>
	                            <td width="1%" id="timelimit2"><b>:</b></td>
	                            <td width="25%" id="timelimit3">
					<%if(isUseDatePicker.equalsIgnoreCase("Y")){
					if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                          <input onClick="ds_sh(this);" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_DEPOSIT_TIME_LIMIT]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((objInvoiceMain.getDepositTimeLimit() == null) ? new Date() : objInvoiceMain.getDepositTimeLimit(), "dd-MM-yyyy")%>"/>
                                          <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_DEPOSIT_TIME_LIMIT] + "_mn"%>">
                                          <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_DEPOSIT_TIME_LIMIT] + "_dy"%>">
                                          <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_DEPOSIT_TIME_LIMIT] + "_yr"%>">
                                          <script language="JavaScript" type="text/JavaScript">getThn();</script>
                                         <%}else{
						out.println(Formater.formatDate((objInvoiceMain.getDepositTimeLimit() == null) ? new Date() : objInvoiceMain.getDepositTimeLimit(), "dd-MM-yyyy"));  
                                            }										  
                                    }%>			
					</td>
					
					<td width="14%" height="25" id="topticket1" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][23]%></td>
                                    <td width="1%" height="25" id="topticket2"><b>:</b></td>
                                    <td width="25%" height="25" id="topticket3">
					<%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                            <input type="text"  onKeyUp="javascript:changeAccChart()" size="3" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]+"_ticket"%>" value="<%=objInvoiceMain.getTermOfPayment()%>">
					<%}else{%>
                                            <%=objInvoiceMain.getTermOfPayment()%>
					<%}%>
					&nbsp;<%=strTitle[SESS_LANGUAGE][25]%>
                                    </td>
				    
                                  </tr>
				 
				  <tr id="toppackage">
                                     <td width="14%" height="25" nowrap>&nbsp;</td>
                                    <td width="1%" height="25">&nbsp;</td>
                                    <td width="25%" height="25">&nbsp;</td>
				    <td height="25">&nbsp;</td>
				     <td>&nbsp;</td>
				    <td>&nbsp;</td>	
                                     <td width="14%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][23]%></td>
                                    <td width="1%" height="25" ><b>:</b></td>
                                    <td width="25%" height="25">
					<%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                            <input type="text"  onKeyUp="javascript:changeAccChart()" size="3" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TERM_OF_PAYMENT]+"_package"%>" value="<%=objInvoiceMain.getTermOfPayment()%>">
					<%}else{%>
                                            <%=objInvoiceMain.getTermOfPayment()%>
					<%}%>
					&nbsp;<%=strTitle[SESS_LANGUAGE][25]%>
                                    </td>
                                   </tr>
                                   <tr id="guest">
                                     <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][8]%></td>
                                     <td width="1%" height="25"><b>:</b></td>
                                     <td height="25" colspan="3">
                                        <%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                        <input type="text" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_GUEST_NAME]%>" value="<%=objInvoiceMain.getGuestName()%>">
                                        <%}else{%>
                                        <%=objInvoiceMain.getGuestName()%>
                                        <%}%>
                                     </td>
                                     <td width="11%">&nbsp;</td>
                                     <td width="14%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][15]%></td>
                                     <td width="1%" height="25"><b>:</b></td>
                                     <td width="25%" height="25">
                                        <%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                        <input type="text" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TOTAL_PAX]%>" value="<%=objInvoiceMain.getTotalPax()%>">
                                        <%}else{%>
                                        <%=objInvoiceMain.getTotalPax()%>
                                        <%}%>
                                     </td>
                                   </tr>
                                   <tr id="hotel">
                                     <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][9]%></td>
                                     <td width="1%" height="25"><b>:</b></td>
                                     <td height="25" colspan="3">
                                        <%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                        <input type="text" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_HOTEL_NAME]%>" value="<%=objInvoiceMain.getHotelName()%>">
                                        <%}else{%>
                                        <%=objInvoiceMain.getHotelName()%>
                                        <%}%>
                                      </td>
                                      <td width="11%">&nbsp;</td>
                                      <td width="14%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][16]%></td>
                                      <td width="1%" height="25"><b>:</b></td>
                                      <td width="25%" height="25">
                                        <%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
                                        <input type="text" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TOTAL_ROOM]%>" value="<%=objInvoiceMain.getTotalRoom()%>">
                                        <%}else{%>
                                        <%=objInvoiceMain.getTotalRoom()%>
                                        <%}%>
                                      </td>
                                   </tr>
				    <tr id="description">
					<td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][31]%></td>
                                      <td width="1%" height="25"><b>:</b></td>
                                      <td colspan="5">
                                        <%if(iCommand == Command.ADD || (iCommand == Command.SAVE && iErrCode != 0) || (iCommand == Command.EDIT && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT)){%>
					<textarea rows="5" cols="17" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_DESCRIPTION]%>"><%=objInvoiceMain.getDescription()%></textarea>
                                        <%}else{%>
                                        <%=objInvoiceMain.getDescription()%>
                                        <%}%>
                                      </td>
                                   </tr>
					<%if(list != null && list.size() > 0){%>
				   <tr>
                                      <td colspan="7">&nbsp;<b><%=strListInvoiceDetail%></b></td>
                                      <td colspan="2">
                                            <b><%=strSelectPrinter%></b>
                                            <select  name="printeridx">
                                              <%
                                                Vector prnLst = null;
                                                PrinterHost host = null;
                                                Vector hostLst = null;
                                                try{
                                                        hostLst = RemotePrintMan.getHostList();
                                                }catch(Exception e){hostLst = new Vector(1,1);}
                                                if(hostLst!=null){
                                                        for(int h = 0; h< hostLst.size();h++){
                                                                try{
                                                                        host = (PrinterHost )hostLst.get(h);
                                                                        if(host!=null)
                                                                                prnLst = host.getListOfPrinters(false);
                                                                        if(prnLst!=null){
                                                                                for(int i = 0; i< prnLst.size();i++){
                                                                                        try{
                                                                                                PrnConfig prnConf= (PrnConfig) prnLst.get(i);
                                                                                                out.print(" <option value='"+ host.getHostIP()+";"+prnConf.getPrnIndex()+"'> ");
                                                                                                out.println(host.getHostName()+ " / " + prnConf.getPrnIndex()+ " "+prnConf.getPrnName()+" "+prnConf.getPrnPort());
                                                                                                out.print(" </option>");
                                                                                        } catch (Exception exc){}
                                                                                }
                                                                        }
                                                                } catch (Exception exc1){host = new PrinterHost();}
                                                        }
                                                    }
                                                %>
                                            </select>
                                      </td>
                                  </tr>
                                  <tr>
                                      <td colspan="9"><%=strList%></td>
                                  </tr>
                                      <%}%>
				  <tr>
                                      <td colspan="9">&nbsp;</td>
                                  </tr>
                                      <%if(listPayTerm != null && listPayTerm.size() > 0){%>
				  <tr>
                                      <td colspan="9">&nbsp;<b><%=strListPaymentTerm%></b></td>
                                  </tr>
				  <tr>
                                      <td colspan="9">																				
                                      <%=listPayTerm(SESS_LANGUAGE, listPayTerm, iCommand,iLnkRow)%>
                                      </td>
                                  </tr>
                                      <%}%>
				  <tr>
                                      <td colspan="9">&nbsp;</td>
                                  </tr>
                                      <%if(listCosting != null && listCosting.size() > 0){%>
                                  <tr>
                                      <td colspan="9">&nbsp;<b><%=strListCostingDetail%></b></td>
                                  </tr>
				  <tr>
                                      <td colspan="9">&nbsp;<%=strPayableAcc%>&nbsp;<%=strNamaPerkiraan%></td>
                                  </tr>
				  <tr>
                                      <td colspan="9">																				
					 <%=strListCosting%>
				      </td>
                                  </tr>
				      <%}%>
				  <tr>
                                      <td colspan="9">&nbsp;</td>
                                  </tr>
                                       <%if(listApPayTerm != null && listApPayTerm.size() > 0){%>
				  <tr>
                                      <td colspan="9">&nbsp;<b><%=strListApPaymentTerm%></b></td>
                                  </tr>
				  <tr>
                                      <td colspan="9">																				
				      <%=listApPayTerm(SESS_LANGUAGE, listApPayTerm, iCommand, iLnkRow)%>
				      </td>
                                  </tr>
				      <%}%>
                                  <tr>
                                    <td colspan="9">
                                        <%
                                        if(objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT){
					     if((iCommand==Command.EDIT) || (iCommand==Command.SAVE && iErrCode==0) || (iCommand==Command.LIST)){
					     out.println("<a href=\"javascript:cmdAddDetail('"+oidInvoiceMain+"')\" class=\"command\">"+strAddDetail+"</a>");
                                          }
                                        }
					%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="9"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="66%" nowrap scope="row">
                                            <%
                                                ctrLine.setLocationImg(approot+"/images");
                                                ctrLine.initDefault(SESS_LANGUAGE, "");
                                                ctrLine.setTableWidth("80%");
                                                String scomDel = "javascript:cmdAsk('"+oidInvoiceMain+"')";
                                                String sconDelCom = "javascript:cmdDelete('"+oidInvoiceMain+"')";
                                                String scancel = "javascript:cmdEdit('"+oidInvoiceMain+"')";
                                                ctrLine.setCommandStyle("command");
                                                ctrLine.setColCommStyle("command");
                                                ctrLine.setCancelCaption(strCancel);
                                                ctrLine.setBackCaption(strBack);
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
                                                
                                                if(objInvoiceMain.getStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED || objInvoiceMain.getStatus()==I_DocStatus.DOCUMENT_STATUS_CANCELLED){
                                                    ctrLine.setBackCaption(strBack);
                                                    ctrLine.setSaveCaption("");
                                                    ctrLine.setDeleteCaption("");
                                                    ctrLine.setAddCaption("");
                                                }
							
                                                if(objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_FINAL){
                                                        ctrLine.setSaveCaption("");
                                                        ctrLine.setDeleteCaption("");
                                                }

                                                if(iCommand == Command.ADD){
                                                        ctrLine.setBackCaption("");
                                                }

                                                if(iQueryType == 1){
                                                        ctrLine.setSaveCaption("");
                                                        ctrLine.setEditCaption("");
                                                }
							
                                                if(iCommand == Command.POST){
                                                        ctrLine.setBackCaption(strBack);
                                                }

                                                if(iCommand == Command.UPDATE){
                                                        ctrLine.setBackCaption(strBack);
                                                        iCommand = Command.POST;
                                                }

                                                if(iCommand != Command.SAVE && iQueryType != 5){
                                                        if(iCommand == Command.PRINT){
                                                                iCommand = Command.EDIT;
                                                        }
                                                        ctrLine.setSaveCaption(strSave);
                                                        out.println(ctrLine.draw(iCommand, iErrCode, msgString));
                                                }
							

                                                if(iCommand == Command.SAVE && iErrCode != 0 && iQueryType != 5){
                                                        ctrLine.setBackCaption("");
                                                        out.println(ctrLine.draw(iCommand, iErrCode, msgString));
                                                        iCommand = Command.EDIT;
                                                }
					      %>
							
					</td>
                                            <%if(iQueryType == 5){%>
                                                <%if(allList){%>
                                                    <a href="javascript:reportPdf()" class="command">
                                                    <%=strCetakLKU%>
                                                    </a> | 
                                                <%}%>
                                                    <a href="javascript:cmdBack()" class="command">
                                                    <%=strBack%>
                                                </a>
                                            <%}else{%>
                                                <%if(oidInvoiceMain != 0 && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT && iQueryType > 0 ){%>
                                                    <%if(allList){%>
                                                        <td width="34%" nowrap>
                                                            <a href="javascript:cmdPrint()" class="command"><%=strPrint%></a> |
<a href="javascript:printXLS()" class="command"><%=strPrintHtml%></a> | <a href="javascript:cmdApproved('<%=oidInvoiceMain%>')" class="command"><%=strApproved%></a>                                                               
                                                            <%if(objInvoiceMain.getTax() == 0 && objInvoiceMain.getTermOfPayment() > 0 && objInvoiceMain.getType() == 1){%>
                                                            | <a href="javascript:cmdAddDeposit()" class="command">
                                                            <%=strAddDeposit%>
                                                        <%}%>
                                                        </td>
						   <%}else{%>
							<td width="34%" nowrap>
                                                            <%if(objInvoiceMain.getTax() == 0 && objInvoiceMain.getTermOfPayment() > 0 && objInvoiceMain.getType() == 1 && iQueryType != 5){%>
                                                                <a href="javascript:cmdAddDeposit()" class="command">
                                                                <%=strAddDeposit%>
                                                                </a>  | 
                                                            <%}%>
                                                            <% switch(iCheckList){
                                                                case 1:
                                                                         out.println("<a href=\"javascript:cmdPrint()\" class=\"command\">"+strPrint+"</a> | <a href=\"javascript:printXLS()\" class=\"command\">"+strPrintHtml+"</a>");
                                                                         System.out.println("objInvoiceMain.getTermOfPayment() : "+objInvoiceMain.getTermOfPayment());
                                                                         if(objInvoiceMain.getTermOfPayment() > 0){
                                                                                out.println(" | <a href=\"javascript:cmdAddPayTerm('"+oidInvoiceMain+"')\" class=\"command\">"+strAddPayTerm+"</a>");
                                                                         }else{
                                                                                if(!SessInvoice.checkApPaymentTerm(oidInvoiceMain)){
                                                                                out.println(" | <a href=\"javascript:cmdAddCosting('"+oidInvoiceMain+"')\" class=\"command\">"+strAddCosting+"</a>");
                                                                                }
                                                                         }
                                                                break;
                                                                case 2:
                                                                         out.println("<a href=\"javascript:cmdPrint()\" class=\"command\">"+strPrint+"</a> | <a href=\"javascript:printXLS()\" class=\"command\">"+strPrintHtml+"</a> | <a href=\"javascript:cmdAddCosting('"+oidInvoiceMain+"')\" class=\"command\">"+strAddCosting+"</a>");
                                                                break;
                                                                case 3:
                                                                         out.println("<a href=\"javascript:cmdPrint()\" class=\"command\">"+strPrint+"</a> |<a href=\"javascript:printXLS()\" class=\"command\">"+strPrintHtml+"</a> | <a href=\"javascript:cmdAddApPayTerm('"+oidInvoiceMain+"')\" class=\"command\">"+strAddApPayTerm+"</a>");
                                                                break;
                                                            }%>
                                                            <%if(SessInvoice.checkApPaymentTerm(oidInvoiceMain)){
                                                                out.println(" | <a href=\"javascript:cmdApproved('"+oidInvoiceMain+"')\" class=\"command\">"+strApproved+"</a>");
                                                            }%>	
							</td>		
							<%}%>
							<%}else{%>
								<%if(allList && objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_FINAL){%>
                                                        <td width="34%">
                                                            <a href="javascript:cmdPrint()" class="command"><%=strPrint%></a> | 
<a href="javascript:printXLS()" class="command"><%=strPrintHtml%></a>
							    <%switch(iQueryType){
                                                                case 2:%>
                                                                        | <a href="javascript:cmdPosted('<%=oidInvoiceMain%>')" class="command">
                                                                        <%if(objInvoiceMain.getStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0 && iQueryType == 2){%>
                                                                        <%=strTitle[SESS_LANGUAGE][26]%>
                                                                        <%}%>
                                                                        </a> 
                                                                <%break;
                                                                case 3:%> 
                                                                        | <a href="javascript:cmdVoid('<%=oidInvoiceMain%>')" class="command"><%=strVoid%></a>
                                                                <%break;
                                                              }%>
							</td>	
                                                    <%}else{%>
                                                        <td width="34%">
                                                            <%if(SessInvoice.checkApPaymentTerm(oidInvoiceMain)){%>
                                                                    <%if(objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_FINAL){%>
                                                                    <a href="javascript:cmdPrint()" class="command"><%=strPrint%></a> 
<a href="javascript:printXLS()" class="command">"+strPrintHtml+"</a>
                                                                     |
                                                                    <%}%> 
                                                                    <%if(objInvoiceMain.getStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0){%> 
                                                                                    <%if(iQueryType == 2 && objInvoiceMain.getStatus() != I_DocStatus.DOCUMENT_STATUS_CANCELLED){%>
                                                                                    <a href="javascript:cmdPosted('<%=oidInvoiceMain%>')" class="command">
                                                                                    <%=strTitle[SESS_LANGUAGE][26]%>
                                                                                    </a> 
                                                                                    <%}else if(iQueryType == 3){%>
                                                                                    <a href="javascript:cmdVoid('<%=oidInvoiceMain%>')" class="command"><%=strVoid%></a>
                                                                                    <%}%>
                                                                    <%}%>
                                                            <%}%>
                                                            <%if(objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_CANCELLED || objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_POSTED){%>
                                                            <a href="javascript:cmdPrint()" class="command"><%=strPrint%></a> 
<a href="javascript:printXLS()" class="command"><%=strPrintHtml%></a>
                                                        </td>	
									<%}%>
								<%}%>
							 <%}%>
							 <%}%>
                                            </tr>
                                        </table>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="9">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="9">&nbsp;</td>
                                  </tr>
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
			<script language="javascript">
				changeAccChart();
				<%if(objInvoiceMain.getType() == 0){%>
				hidePackage();
				<%}else{%>
					hideTopTicket();	
				<%}%>
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
