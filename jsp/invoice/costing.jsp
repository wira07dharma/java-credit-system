<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.aiso.form.invoice.*,
                   com.dimata.aiso.entity.invoice.*,
				   com.dimata.aiso.form.costing.*,
                   com.dimata.aiso.entity.costing.*,
                   com.dimata.util.Command,
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
                   com.dimata.gui.jsp.ControlList,
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
		"Hari"//25
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
		"Days"
	}
};

public static String strItemTitle[][] = {
	{"No","Perkiraan","Nama Pelanggan","Keterangan","Tanggal","Jumlah","Harga Satuan","Diskon","Total Harga"},
	{"No","Chart of Account","Name of Pax","Description","Date","Number","Unit Price","Discount","Amount"}
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
	"Input Reservasi","Reservation Entry"
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

public Vector drawList(int language, Vector objectClass, int iCommand){
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

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditInvoiceDetail('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	Vector vResult = new Vector(1,1);
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
		vResult.add(""+(totAmount - totDiscount));
		return vResult;
}

public Vector drawListPackage(int language, Vector objectClass, InvoiceMain objInvoiceMain){
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

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditInvoiceDetail('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	Vector vResult = new Vector(1,1);
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
							rowx.add("<div align=\"right\"><a href=\"javascript:cmdAddDeposit()\"> Deposit / "+sPerk+"</a></div>");
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
		vResult.add(""+totAmount);
		return vResult;
}

public String listPayTerm(int language, Vector objectClass, int iCommand, long lPaymentTermId, InvoiceMain objInvoiceMain, 
		double dNetAmount, FrmPaymentTerm frmPaymentTerm){
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

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditPaymentTerm('");
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

public String listCosting(int language, Vector objectClass, int iCommand, long lCostingId, Vector vListAccount, FrmCosting frmCosting, String approot){
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

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
	long idPerkiraan = 0;
	Perkiraan objPerkiraan = new Perkiraan();
	Costing objCosting = new Costing();
	String strPerk = "";
	String strAccName = "";
	String sSelectedAccount = "";
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
			
			sSelectedAccount = ""+objCosting.getIdPerkiraanHpp();
			if(vListAccount != null && vListAccount.size() > 0){
				for(int a=0; a < vListAccount.size(); a++){
					objPerkiraan = (Perkiraan) vListAccount.get(a);	
					strAccName = getAccName(objPerkiraan,language);		
					vAccValue.add(strAccName);					
					vAccKey.add(""+objPerkiraan.getOID());					
				}
			}
			rowx = new Vector();
			if(lCostingId == objCosting.getOID())
				index = i;
			
			System.out.println("objCosting.getDescription() :::::: "+objCosting.getDescription());
			if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){	
				rowx.add(""+(i+1));
				rowx.add(ControlCombo.draw(FrmCosting.fieldNames[FrmCosting.FRM_ID_PERKIRAAN_HPP], "", null, sSelectedAccount, vAccKey, vAccValue));
				rowx.add("<input type=\"hidden\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_CONTACT_ID]+"\" value=\""+objCosting.getContactId()+"\" class=\"formElemenR\">"+
						"<input type=\"text\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_CONTACT_ID]+"_TEXT\" value=\""+strContact+"\" class=\"formElemenR\">"+
						"<a href=\"javascript:cmdopen()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
				rowx.add("<input type=\"text\" size=\"10\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_REFERENCE]+"\" value=\""+objCosting.getReference()+"\" class=\"formElemenR\">");
				System.out.println("objCosting.getDescription() 2 :::::: "+objCosting.getDescription());
				rowx.add("<textarea rows=\"2\" cols=\"30\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_DESCRIPTION]+"\" class=\"formElemenR\">"+objCosting.getDescription()+"</textarea>");
				rowx.add("<input type=\"text\" size=\"3\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_NUMBER]+"\" value=\""+objCosting.getNumber()+"\" class=\"formElemenR\">");
				rowx.add("<input type=\"text\" size=\"14\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_UNIT_PRICE]+"\" value=\""+objCosting.getUnitPrice()+"\" class=\"formElemenR\">");
				rowx.add("<input type=\"text\" size=\"7\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_DISCOUNT]+"\" value=\""+objCosting.getDiscount()+"\" class=\"formElemenR\">");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objCosting.getNumber() * objCosting.getUnitPrice())+"</div>");
				rowx.add(I_DocStatus.fieldDocumentStatus[objCosting.getStatus()]);
			
			}else{
				int iRows = objCosting.getDescription().length() / 40;
				rowx.add(""+(i+1));
				rowx.add(strPerk);
				rowx.add(strContact);
				rowx.add(objCosting.getReference());
				rowx.add("<textarea rows=\""+iRows+"\" readOnly cols=\"40\" name=\"desc\">"+objCosting.getDescription()+"</textarea>");
				rowx.add(""+objCosting.getNumber());
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objCosting.getUnitPrice())+"</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objCosting.getDiscount())+"</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objCosting.getNumber() * objCosting.getUnitPrice())+"</div>");
				rowx.add(I_DocStatus.fieldDocumentStatus[objCosting.getStatus()]);
				totDiscount += objCosting.getDiscount();
				totAmount += objCosting.getNumber() * objCosting.getUnitPrice();
			}
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objCosting.getOID()));
			
		}
		
		
		rowx = new Vector();
		if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmCosting.errorSize()>0)){
			sSelectedAccount = ""+objCosting.getIdPerkiraanHpp();
			vAccValue = new Vector(1,1);
			vAccKey = new Vector(1,1);
			if(vListAccount != null && vListAccount.size() > 0){
				for(int a=0; a < vListAccount.size(); a++){
					objPerkiraan = new Perkiraan();					
					objPerkiraan = (Perkiraan) vListAccount.get(a);	
					strAccName = getAccName(objPerkiraan,language);		
					vAccValue.add(strAccName);					
					vAccKey.add(""+objPerkiraan.getOID());					
				}
			}
			rowx.add("");
			rowx.add(ControlCombo.draw(FrmCosting.fieldNames[FrmCosting.FRM_ID_PERKIRAAN_HPP], "", null, sSelectedAccount, vAccKey, vAccValue));
			rowx.add("<input type=\"hidden\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_CONTACT_ID]+"\" value=\"\" class=\"formElemenR\">"+
					"<input type=\"text\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_CONTACT_ID]+"_TEXT\" value=\"\" class=\"formElemenR\">"+
					"<a href=\"javascript:cmdopen()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
			rowx.add("<input type=\"text\" size=\"10\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_REFERENCE]+"\" value=\"\" class=\"formElemenR\">");
			rowx.add("<textarea rows=\"2\" cols=\"40\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_DESCRIPTION]+"\"></textarea>");
			rowx.add("<input type=\"text\" size=\"3\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_NUMBER]+"\" value=\"\" class=\"formElemenR\">");
			rowx.add("<input type=\"text\" size=\"14\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_UNIT_PRICE]+"\" value=\"\" class=\"formElemenR\">");
			rowx.add("<input type=\"text\" size=\"7\" name=\""+FrmCosting.fieldNames[FrmCosting.FRM_DISCOUNT]+"\" value=\"\" onKeyUp=\"javascript:hitungTotal()\" class=\"formElemenR\">");
			rowx.add("<a id=\"amount\"></a>");
			rowx.add("");
			lstData.add(rowx);
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
		
		return ctrlist.drawMe(index);
}

public String listApPayTerm(int language, Vector objectClass, int iCommand){
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

	ctrlist.setLinkRow(1);
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
long oidInvoiceDetail = FRMQueryString.requestLong(request,"invoice_detail_id");
long oidInvoiceMain = FRMQueryString.requestLong(request,"invoice_main_id");
long oidPaymentTerm = FRMQueryString.requestLong(request,"payment_term_id");
long oidCosting = FRMQueryString.requestLong(request,"costing_id");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
int posTed = FRMQueryString.requestInt(request,"posted_status");
int iQueryType = FRMQueryString.requestInt(request, "query_type");
int iInvoiceType = FRMQueryString.requestInt(request, "invoice_type");
if(iCommand==Command.NONE)
        iCommand = Command.ADD;
		
/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add new costing" : "Tambah item pembiayaan";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : " Tambah Detail";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete" : "Hapus";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strAddDeposit = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add Deposit" : "Entry Deposit";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete" : "Ya Hapus Order";
String strPayableAcc = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Payable Account : " : "Perkiraan Hutang : ";
String strListInvoiceDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Detail Invoice" : "Daftar Perincian Invoice";
String strListCostingDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Costing Data Entry" : "Input Data Pembiayaan";
String strListPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Receivable Payment Term" : "Daftar Termin Pembayaran";
String strAddPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New AP Payment Term" : " Tambah Termin Pembayaran Hutang";
String strListApPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Payable Payment Term" : "Daftar Termin Pembayaran Hutang";
String strInvoiceType = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Invoice Type : " : "Tipe Invoice : ";
String strPackage = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Package" : "Paket";
String strTicket = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Ticket" : "Tiket";
String strBack = "";
if(iQueryType == 1){
	strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back to invoice list" : "Kembali ke daftar invoice";
}else{
	strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add new invoice" : "Tambah invoice";
}


/** Instansiasi object CtrlOrderAktiva and FrmOrderAktiva */
ControlLine ctrLine = new ControlLine();
CtrlCosting ctrlCosting = new CtrlCosting(request);
ctrlCosting.setLanguage(SESS_LANGUAGE);
FrmCosting frmCosting = ctrlCosting.getForm();
int iErrCode = ctrlCosting.action(iCommand, oidCosting);
Costing objCosting = ctrlCosting.getCosting();
oidCosting = objCosting.getOID();
String msgString = ctrlCosting.getMassage();

//Edit detail from costing
CtrlInvoiceDetail ctrlInvoiceDetail = new CtrlInvoiceDetail(request);
ctrlInvoiceDetail.setLanguage(SESS_LANGUAGE);
FrmInvoiceDetail frmInvoiceDetail = ctrlInvoiceDetail.getForm();
int iErrCodeDetail = ctrlInvoiceDetail.action(Command.EDIT, oidInvoiceDetail);
InvoiceDetail objInvoiceDetail = ctrlInvoiceDetail.getInvoiceDetail();
String mString = ctrlInvoiceDetail.getMassage();

Vector vListCosting = new Vector(1,1);
//Edit detail from main
CtrlInvoiceMain ctrlInvoiceMain = new CtrlInvoiceMain(request);
ctrlInvoiceMain.setLanguage(SESS_LANGUAGE);
FrmInvoiceMain frmInvoiceMain = ctrlInvoiceMain.getForm();
int iErrCodeMain = ctrlInvoiceMain.action(Command.EDIT, oidInvoiceMain, vListCosting,userOID);
InvoiceMain objInvoiceMain = ctrlInvoiceMain.getInvoiceMain();
String msgStr = ctrlInvoiceMain.getMassage();

//Edit payment term
CtrlPaymentTerm ctrlPaymentTerm = new CtrlPaymentTerm(request);
ctrlPaymentTerm.setLanguage(SESS_LANGUAGE);
FrmPaymentTerm frmPaymentTerm = ctrlPaymentTerm.getForm();
int iErrCodePaymentTerm = ctrlPaymentTerm.action(Command.EDIT, oidPaymentTerm);
PaymentTerm objPaymentTerm = ctrlPaymentTerm.getPaymentTerm();
String msgStringPaymentTerm = ctrlPaymentTerm.getMassage();

String strWhClause = PstInvoiceDetail.fieldNames[PstInvoiceDetail.FLD_INVOICE_ID]+" = "+oidInvoiceMain;
Vector list = PstInvoiceDetail.list(0,0,strWhClause,"");

String strWClause = PstCosting.fieldNames[PstCosting.FLD_INVOICE_ID]+" = "+oidInvoiceMain;
Vector listCosting = PstCosting.list(0,0,strWClause,"");	

Vector vTempList = new Vector(1,1);
String strListDetail = "";
double dNetAmount = 0;
try{
	if(objInvoiceMain.getType() == 0){
		vTempList = drawList(SESS_LANGUAGE,list,iCommand);
	}else{
		vTempList = drawListPackage(SESS_LANGUAGE,list,objInvoiceMain);
	}
	if(vTempList != null && vTempList.size() > 0){
		strListDetail = vTempList.get(0).toString();
		dNetAmount = Double.parseDouble(vTempList.get(1).toString());
	}
}catch(Exception e){}

String strWhere = PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_INVOICE_ID]+" = "+oidInvoiceMain+
				  " AND "+PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_TYPE]+" = "+PstPaymentTerm.PAY_TERM_AR;
Vector listPayTerm = new Vector(1,1);
String strWhrCls =  PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_INVOICE_ID]+" = "+oidInvoiceMain+
				  " AND "+PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_TYPE]+" = "+PstPaymentTerm.PAY_TERM_AP;
Vector listApPayTerm = new Vector(1,1);
try{
	listPayTerm = PstPaymentTerm.list(0,0,strWhere,"");
	listApPayTerm = PstPaymentTerm.list(0,0,strWhrCls,"");
}catch(Exception e){}	

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
	
	String strPerkiraan = "";
	Perkiraan objPerkiraan = new Perkiraan();
	if(objInvoiceMain.getIdPerkiraan() != 0){
		try{
			objPerkiraan = PstPerkiraan.fetchExc(objInvoiceMain.getIdPerkiraan());
		}catch(Exception e){}
		if(objPerkiraan.getOID() != 0){
			strPerkiraan = getAccName(objPerkiraan,SESS_LANGUAGE);
		}
	}
	
   Vector vMainAccount = new Vector(1,1);
   try{
		vMainAccount = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_COST_OF_SALES);
	}catch(Exception e){vMainAccount = new Vector(1,1);}
	
   Vector vPayableAccount = new Vector(1,1);
   try{
		vPayableAccount = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES);
	}catch(Exception e){vPayableAccount = new Vector(1,1);} 	 	
	
	boolean allList = false;
	if(list.size() > 0 && listPayTerm.size() > 0 && listCosting.size() > 0 && listApPayTerm.size() > 0){
		allList = true;
	}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">

function cmdAdd(){
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.ADD%>";
	document.<%=FrmCosting.FRM_COSTING%>.prev_command.value="<%=Command.ADD%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdAddDeposit(){
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.SUBMIT%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="invoice_detail.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdopen(){
	var url = "srccontact_list.jsp?cnt_type=2";
    window.open(url,"search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdSave(){
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdEdit(oid){
    document.<%=FrmCosting.FRM_COSTING%>.costing_id.value = oid;
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmCosting.FRM_COSTING%>.prev_command.value="<%=Command.EDIT%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdEditPaymentTerm(oid){
    document.<%=FrmCosting.FRM_COSTING%>.payment_term_id.value = oid;
	document.<%=FrmCosting.FRM_COSTING%>.invoice_type.value = "<%=iInvoiceType%>";
	document.<%=FrmCosting.FRM_COSTING%>.query_type.value ="<%=iQueryType%>";
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmCosting.FRM_COSTING%>.prev_command.value="<%=Command.EDIT%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="payment_term.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdEditApPayTerm(oid){
    document.<%=FrmCosting.FRM_COSTING%>.payment_ap_term_id.value = oid;
	document.<%=FrmCosting.FRM_COSTING%>.invoice_type.value = "<%=iInvoiceType%>";	
	document.<%=FrmCosting.FRM_COSTING%>.query_type.value ="<%=iQueryType%>";
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmCosting.FRM_COSTING%>.prev_command.value="<%=Command.EDIT%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="ap_payment_term.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdEditInvoiceDetail(oid){
    document.<%=FrmCosting.FRM_COSTING%>.invoice_detail_id.value = oid;
	document.<%=FrmCosting.FRM_COSTING%>.invoice_type.value = "<%=iInvoiceType%>";
	document.<%=FrmCosting.FRM_COSTING%>.query_type.value ="<%=iQueryType%>";
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmCosting.FRM_COSTING%>.prev_command.value="<%=Command.EDIT%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="invoice_detail.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdAsk(oid){
    document.<%=FrmCosting.FRM_COSTING%>.costing_id.value = oid;
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.ASK%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdAddPaymentTerm(oid){
    document.<%=FrmCosting.FRM_COSTING%>.invoice_main_id.value=oid;
	document.<%=FrmCosting.FRM_COSTING%>.query_type.value ="<%=iQueryType%>";
	document.<%=FrmCosting.FRM_COSTING%>.invoice_type.value = "<%=objInvoiceMain.getType()%>";
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.ADD%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="ap_payment_term.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function hitungTotal(){
	var qty = parseInt(document.<%=FrmCosting.FRM_COSTING%>.<%=FrmCosting.fieldNames[FrmCosting.FRM_NUMBER]%>.value);
	var unitPrice = parseInt(document.<%=FrmCosting.FRM_COSTING%>.<%=FrmCosting.fieldNames[FrmCosting.FRM_UNIT_PRICE]%>.value);
	var amount = qty * unitPrice;
	if(!isNaN(amount)){
	document.all.amount.innerHTML = amount;
	}
}

function cmdDelete(oid){
    document.<%=FrmCosting.FRM_COSTING%>.invoice_detail_id.value = oid;
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdBackMain(){
	document.<%=FrmCosting.FRM_COSTING%>.costing_id.value = 0;
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.LIST%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdBack(){
	<%if(iQueryType == 1){%>
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.LIST%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="invoice_list.jsp";
	<%}else{%>
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.LIST%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	<%}%>
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdSaveMain(oid){
    document.<%=FrmCosting.FRM_COSTING%>.invoice_main_id.value = oid;
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdPosted(){
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.SAVE%>";
    document.<%=FrmCosting.FRM_COSTING%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_STATUS]%>.value = "<%=I_DocStatus.DOCUMENT_STATUS_POSTED%>";
    document.<%=FrmCosting.FRM_COSTING%>.posted_status.value="1";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
}

function cmdAskMain(oid){
    document.<%=FrmCosting.FRM_COSTING%>.invoice_main_id.value = oid;
	document.<%=FrmCosting.FRM_COSTING%>.command.value="<%=Command.ASK%>";
	document.<%=FrmCosting.FRM_COSTING%>.action="costing.jsp";
	document.<%=FrmCosting.FRM_COSTING%>.submit();
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
            <form name="<%=FrmCosting.FRM_COSTING%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="invoice_main_id" value="<%=oidInvoiceMain%>">
              <input type="hidden" name="invoice_detail_id" value="<%=oidInvoiceDetail%>">
			  <input type="hidden" name="costing_id" value="<%=oidCosting%>">
			  <input type="hidden" name="payment_term_id" value="<%=oidPaymentTerm%>">
			  <input type="hidden" name="payment_ap_term_id" value="0">
              <input type="hidden" name="posted_status" value="0">
			  <input type="hidden" name="query_type" value="<%=iQueryType%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
			  <input type="hidden" name="invoice_type" value="<%=iInvoiceType%>">
			  <input type="hidden" name="<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_INVOICE_ID]%>" value="<%=oidInvoiceMain%>">
			  <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TYPE]%>" value="<%=objInvoiceMain.getType()%>">
			  <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_STATUS]%>" value="<%=objInvoiceMain.getStatus()%>">
			  <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TOTAL_DISCOUNT]%>" value="0">
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
                              <td width="94%">
                                <table width="100%">
									<tr>
								  	<td colspan="9">&nbsp;<b><%=strInvoiceType%><font color="#CC3300"><%=objInvoiceMain.getType() == 0? strTicket.toUpperCase() : strPackage.toUpperCase()%></font></b></td>
								  </tr>
								  <tr>
                                    <td colspan="9">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%>&nbsp;<b><%=objInvoiceMain.getInvoiceNumber()%></b></td>
                                    <td width="1%" height="25">&nbsp;</td>
                                    <td height="25" colspan="3">
									</td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25">&nbsp;</td>
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
                                    <td height="25"><%=I_DocStatus.fieldDocumentStatus[objInvoiceMain.getStatus()]%></td>
                                  </tr>
                                  <tr>
                                    <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][4]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td height="25" colspan="3"><%=strFirstContact%>
                                    </td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][11]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25"><%=Formater.formatDate((objInvoiceMain.getIssuedDate() == null) ? new Date() : objInvoiceMain.getIssuedDate(), "dd-MM-yyyy")%>
                                    </td>
                                  </tr>
								  <%if(objInvoiceMain.getType() == 1){%>
                                  <tr>
                                    <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][5]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td height="25" colspan="3"><%=strSecondContact%></td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][12]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25"><%=Formater.formatDate((objInvoiceMain.getCheckInDate() == null) ? new Date() : objInvoiceMain.getCheckInDate(), "dd-MM-yyyy")%></td>                                    
                                  </tr>
                                  <tr>
                                    <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][6]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="16%" height="25"><%=strPhoneNumber%></td>
                                    <td width="5%"><%=strTitle[SESS_LANGUAGE][24]%> :</td>
                                    <td width="15%"><%=strFaxNumber%></td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][13]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25"><%=Formater.formatDate((objInvoiceMain.getCheckOutDate() == null) ? new Date() : objInvoiceMain.getCheckOutDate(), "dd-MM-yyyy")%></td>		
                                  </tr>
								  <%}%>
								  <tr>
                                    <td width="12%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][7]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td height="25" colspan="3"><%=strPerkiraan%></td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][23]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25"><%=objInvoiceMain.getTermOfPayment()%>&nbsp;&nbsp;<%=strTitle[SESS_LANGUAGE][25]%></td>
                                  </tr>
								  
								   <tr>
								     <td height="25">&nbsp;</td>
								     <td height="25">&nbsp;</td>
								     <td height="25" colspan="3">&nbsp;</td>
								     <td>&nbsp;</td>
								     <td height="25">&nbsp;</td>
								     <td height="25">&nbsp;</td>
								     <td height="25">&nbsp;</td>
							      </tr>
								  <%if(objInvoiceMain.getType() == 1){%>
								   <tr>
                                    <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][8]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td height="25" colspan="3"><%=objInvoiceMain.getGuestName()%></td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][15]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25"><%=objInvoiceMain.getTotalPax()%></td>
                                  </tr>
								  <tr>
                                    <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][9]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td height="25" colspan="3"><%=objInvoiceMain.getHotelName()%></td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][16]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25"><%=objInvoiceMain.getTotalRoom()%></td>
                                  </tr>
								  <%}%>
								  <tr>
                                    <td colspan="9">&nbsp;
                                    </td>
                                  </tr>
                                   <tr>
                                    <td colspan="9">&nbsp;<b><%=strListInvoiceDetail%></b></td>
                                  </tr>
                                  <tr>
                                    <td colspan="9"><%=strListDetail%></td>
                                  </tr>
								  <tr>
                                    <td colspan="9">&nbsp;</td>
                                  </tr>
								  <%if(objInvoiceMain.getTermOfPayment() > 0){%>
								    <tr>
                                    <td colspan="9">&nbsp;<b><%=strListPaymentTerm%></b></td>
                                  </tr>
								  <tr>
                                    <td colspan="9">
										<%=listPayTerm(SESS_LANGUAGE,listPayTerm,iCommand, oidPaymentTerm, objInvoiceMain, dNetAmount,  frmPaymentTerm)%>
									</td>
                                  </tr>
								  <%}%>
								  <tr>
                                    <td colspan="9">&nbsp;
                                    </td>
                                  </tr>
								  <tr>
                                    <td colspan="9">&nbsp;<b><%=strListCostingDetail%></b></td>
                                  </tr>
								   <tr>
                                    <td colspan="9">&nbsp;<%=strPayableAcc%>
									<%
										String sSelectedAccount = ""+objCosting.getIdPerkiraanHutang();
										Perkiraan objPerk = new Perkiraan();
										Vector vAccValue = new Vector(1,1);
										Vector vAccKey = new Vector(1,1);
										String strAccName = "";
										if(vPayableAccount != null && vPayableAccount.size() > 0){
											for(int a=0; a < vPayableAccount.size(); a++){
												objPerk = (Perkiraan) vPayableAccount.get(a);	
												strAccName = getAccName(objPerk,SESS_LANGUAGE);		
												vAccValue.add(strAccName);					
												vAccKey.add(""+objPerk.getOID());					
											}
										}
									%>
									<%
										out.println(ControlCombo.draw(FrmCosting.fieldNames[FrmCosting.FRM_ID_PERKIRAAN_HUTANG], "", null, sSelectedAccount, vAccKey, vAccValue));
									%>
                                    </td>
                                  </tr>
								   <tr>
                                    <td colspan="9">
										<%=listCosting(SESS_LANGUAGE,listCosting,iCommand, oidCosting, vMainAccount,frmCosting,approot)%>
									</td>
                                  </tr>
                                  <tr>
                                    <td colspan="9">&nbsp;</td>
                                  </tr>
								  <%if(listApPayTerm != null && listApPayTerm.size() > 0){%>
								  <tr>
                                    <td colspan="9">&nbsp;<b><%=strListApPaymentTerm%></b></td>
                                  </tr>
								  <tr>
                                    <td colspan="9">																				
											<%=listApPayTerm(SESS_LANGUAGE, listApPayTerm, iCommand)%>
									</td>
                                  </tr>
								  <%}%>
                                  <tr>
                                    <td colspan="9"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="76%" nowrap scope="row"><%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault(SESS_LANGUAGE,"");
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidCosting+"')";
							String sconDelCom = "javascript:cmdDelete('"+oidCosting+"')";
							String scancel = "javascript:cmdEdit('"+oidCosting+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);
							ctrLine.setBackCaption(strBack);
							ctrLine.setAddCaption(strAdd);
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
                            if(objInvoiceMain.getStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){
                                ctrLine.setBackCaption(strBack);
                                ctrLine.setSaveCaption("");
                                ctrLine.setDeleteCaption("");
                                ctrLine.setAddCaption("");
                            }
							
							if(iCommand == Command.SAVE){
								ctrLine.setAddCaption(strAdd);
							}
							
							
							if(!allList){
								ctrLine.setBackCaption("");
							}else{
								if(iCommand == Command.EDIT){
								ctrLine.setBackCaption("");
								}
							}
							/*
							
							*/
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							%></td>
							<td width="34%" nowrap>
								<%if((listCosting != null && listCosting.size() > 0) && !allList){%>
										<a href="javascript:cmdAddPaymentTerm('<%=oidInvoiceMain%>')" class="command">
											<%=strAddPaymentTerm%>
										</a>
										<%if(objInvoiceMain.getTax() == 0 && objInvoiceMain.getType() == 1){%>
											| <a href="javascript:cmdAddDeposit()" class="command">
											<%=strAddDeposit%>
											</a>
										<%}%>
								<%}%>
								<a href="javascript:cmdPosted()" class="command"><%if(objInvoiceMain.getStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0 && iQueryType == 2){%><%//=strTitle[SESS_LANGUAGE][10]%><%}%></a></td>
                                      </tr>
                                    </table></td>
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
