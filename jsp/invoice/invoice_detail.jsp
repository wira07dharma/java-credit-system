<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.aiso.form.invoice.*,
                   com.dimata.aiso.entity.invoice.*,
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
				   com.dimata.aiso.printout.*,
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
		"Pemegang Rek."//29
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
		"Days",
		"Posted",
		"Acc. No.",
		"Bank Name",
		"Acc. Name"
	}
};

public static String strItemTitle[][] = {
	{"No","Perkiraan","Nama Pelanggan","Keterangan","Tanggal","Qty","@Harga(Inc Surcharge)","Diskon","Total Harga"},
	{"No","Chart of Account","Name of Pax","Description","Date","Qty","@Price(Inc Surcharge)","Discount","Amount"}
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


public Vector drawList(int language, Vector objectClass, int iCommand, long lInvoiceDetailId, Vector vListAccount, FrmInvoiceDetail frmInvoiceDetail, String approot){
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
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector vResult = new Vector(1,1);
	Vector vDataToPrint = new Vector(1,1);
	Vector rowx = new Vector(1,1);
	Vector rowr = new Vector(1,1);
	int index = -1;
	long idPerkiraan = 0;
	Perkiraan objPerkiraan = new Perkiraan();
	InvoiceDetail objInvoiceDetail = new InvoiceDetail();
	String strPerk = "";
	String strAccName = "";
	String sSelectedAccount = "";
	Vector vAccValue = new Vector(1,1);
	Vector vAccKey = new Vector(1,1);
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
			if(lInvoiceDetailId == objInvoiceDetail.getOID())
				index = i;
			
			if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
				sSelectedAccount = ""+objInvoiceDetail.getIdPerkiraan();
				vAccValue = new Vector(1,1);
				vAccKey = new Vector(1,1);
				if(vListAccount != null && vListAccount.size() > 0){
					for(int a=0; a < vListAccount.size(); a++){
						objPerkiraan = (Perkiraan) vListAccount.get(a);	
						strAccName = getAccName(objPerkiraan,language);		
						vAccValue.add(strAccName);					
						vAccKey.add(""+objPerkiraan.getOID());					
					}
				}	
				rowx.add(""+(i+1));
				rowx.add(ControlCombo.draw(FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_ID_PERKIRAAN], "", null, sSelectedAccount, vAccKey, vAccValue));
				rowx.add("<input type=\"text\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_NAME_OF_PAX]+"\" value=\""+objInvoiceDetail.getNameOfPax()+"\" class=\"formElemenR\">");
				rowx.add("<input type=\"text\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DESCRIPTION]+"\" value=\""+objInvoiceDetail.getDescription()+"\" class=\"formElemenR\">"+
"<a href=\"javascript:openTicket()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>"+
"<input type=\"text\" name=\"ticket_number\" value=\"\" onBlur=\"javascript:setDescription()\" class=\"formElemenR\">"+
"<a href=\"javascript:openTicketNumber()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>"+
"<input type=\"hidden\" name=\"ticket_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"carrier_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"supplier_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"acc_cogs_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"acc_ap_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"net_rate\" value=\"\" class=\"formElemenR\">"
);
				rowx.add("<input type=\"text\" size=\"7\" onClick=\"ds_sh(this);\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]+"\" readonly=\"readonly\" style=\"cursor: text\" value=\""+Formater.formatDate((objInvoiceDetail.getDate() == null) ? new Date() : objInvoiceDetail.getDate(), "dd-MM-yyyy")+"\" class=\"formElemenR\">"+
						"<input type=\"hidden\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]+"_mn\">"+
						"<input type=\"hidden\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]+"_dy\">"+
						"<input type=\"hidden\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]+"_yr\">"+
						"<script language=\"JavaScript\" type=\"text/JavaScript\">getThn();</script>");
				rowx.add("<input type=\"text\" size=\"3\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_NUMBER]+"\" value=\""+objInvoiceDetail.getNumber()+"\" class=\"formElemenR\">");
				rowx.add("<input type=\"text\" size=\"14\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_UNIT_PRICE]+"\" value=\""+objInvoiceDetail.getUnitPrice()+"\" class=\"formElemenR\">"+
"<input type=\"text\" size=\"14\" name=\"surcharge\" value=\"\" onBlur=\"javascript:hitungTotal()\" class=\"formElemenR\">");
				rowx.add("<input type=\"text\" size=\"7\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_ITEM_DISCOUNT]+"\" value=\""+objInvoiceDetail.getItemDiscount()+"\" class=\"formElemenR\">"+
					"<input type=\"text\" size=\"7\" name=\"commision\" value=\"\" class=\"formElemenR\">"
);
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice())+"</div>");
			
			}else{
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
				
				rowr = new Vector(1,1);
				rowr.add(objInvoiceDetail.getNameOfPax());
				rowr.add(objInvoiceDetail.getDescription());
				rowr.add(Formater.formatDate(objInvoiceDetail.getDate(),"dd-MM-yyyy"));
				rowr.add(""+objInvoiceDetail.getNumber());
				rowr.add(Formater.formatNumber(objInvoiceDetail.getUnitPrice(),"##,###"));
				rowr.add(Formater.formatNumber((objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice()) - objInvoiceDetail.getItemDiscount(), "##,###"));
				
				vDataToPrint.add(rowr);
			}
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objInvoiceDetail.getOID()));
			
		}
		
		
		rowx = new Vector();
		if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmInvoiceDetail.errorSize()>0)){
			sSelectedAccount = ""+objInvoiceDetail.getIdPerkiraan();
			vAccValue = new Vector(1,1);
			vAccKey = new Vector(1,1);
			if(vListAccount != null && vListAccount.size() > 0){
				for(int a=0; a < vListAccount.size(); a++){
					objPerkiraan = (Perkiraan) vListAccount.get(a);	
					strAccName = getAccName(objPerkiraan,language);		
					vAccValue.add(strAccName);					
					vAccKey.add(""+objPerkiraan.getOID());					
				}
			}
			rowx.add("");
			rowx.add(ControlCombo.draw(FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_ID_PERKIRAAN], "", null, sSelectedAccount, vAccKey, vAccValue));
			rowx.add("<input type=\"text\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_NAME_OF_PAX]+"\" value=\"\" class=\"formElemenR\">");
			rowx.add("<input type=\"text\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DESCRIPTION]+"\" value=\"\" class=\"formElemenR\">"+
"<a href=\"javascript:openTicket()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>"+
"<input type=\"text\" name=\"ticket_number\" value=\"\" onBlur=\"javascript:setDescription()\" class=\"formElemenR\">"+
"<a href=\"javascript:openTicketNumber()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>"+
"<input type=\"hidden\" name=\"ticket_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"carrier_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"supplier_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"acc_cogs_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"acc_ap_id\" value=\"\" class=\"formElemenR\">"+
"<input type=\"hidden\" name=\"net_rate\" value=\"\" class=\"formElemenR\">"
);
			rowx.add("<input type=\"text\" size=\"7\" onClick=\"ds_sh(this);\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]+"\" readonly=\"readonly\" style=\"cursor: text\" value=\""+Formater.formatDate((objInvoiceDetail.getDate() == null) ? new Date() : objInvoiceDetail.getDate(), "dd-MM-yyyy")+"\" class=\"formElemenR\">"+
					"<input type=\"hidden\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]+"_mn\">"+
					"<input type=\"hidden\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]+"_dy\">"+
					"<input type=\"hidden\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]+"_yr\">"+
					"<script language=\"JavaScript\" type=\"text/JavaScript\">getThn();</script>");
			rowx.add("<input type=\"text\" size=\"3\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_NUMBER]+"\" value=\"\" class=\"formElemenR\">");
			rowx.add("<input type=\"text\" size=\"14\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_UNIT_PRICE]+"\" value=\"\" onKeyUp=\"\" class=\"formElemenR\">"+" / "+"<input type=\"text\" size=\"14\" name=\"surcharge\" value=\"\" onBlur=\"javascript:hitungTotal()\" class=\"formElemenR\">");
			rowx.add("<input type=\"text\" size=\"7\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_ITEM_DISCOUNT]+"\" value=\"\" class=\"formElemenR\">"+
				"<input type=\"text\" size=\"7\" name=\"commision\" value=\"\" class=\"formElemenR\">"				
);
			rowx.add("<a id=\"amount\"></a>");
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
		vResult.add(""+0);
		return vResult;
}

public Vector drawListPackage(int language, Vector objectClass, int iCommand, long lInvoiceDetailId, Vector vListAccount, FrmInvoiceDetail frmInvoiceDetail, InvoiceMain objInvMain, Vector vListAccDep){
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
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
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
	String strAccName = "";
	String sSelectedAccount = "";
	Vector vAccValue = new Vector(1,1);
	Vector vAccKey = new Vector(1,1);
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
			
			sSelectedAccount = ""+objInvoiceDetail.getIdPerkiraan();
			if(vListAccount != null && vListAccount.size() > 0){
				for(int a=0; a < vListAccount.size(); a++){
					objPerkiraan = (Perkiraan) vListAccount.get(a);	
					strAccName = getAccName(objPerkiraan,language);		
					vAccValue.add(strAccName);					
					vAccKey.add(""+objPerkiraan.getOID());					
				}
			}
			rowx = new Vector();
			if(lInvoiceDetailId == objInvoiceDetail.getOID())
				index = i;
			
			if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){	
				rowx.add(""+(i+1));
				rowx.add(ControlCombo.draw(FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_ID_PERKIRAAN], "", null, sSelectedAccount, vAccKey, vAccValue));
				rowx.add("<textarea rows=\"2\" cols=\"40\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DESCRIPTION]+"\">"+objInvoiceDetail.getDescription()+"</textarea>");
				rowx.add("<input type=\"text\" size=\"3\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_NUMBER]+"\" value=\""+objInvoiceDetail.getNumber()+"\" class=\"formElemenR\">");
				rowx.add("<input type=\"text\" size=\"14\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_UNIT_PRICE]+"\" value=\""+objInvoiceDetail.getUnitPrice()+"\" class=\"formElemenR\">");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice())+"</div>");			
			}else{
				int iRows = objInvoiceDetail.getDescription().length() / 40;
				rowx.add(""+(i+1));
				rowx.add(strPerk);
				rowx.add("<textarea rows=\""+iRows+"\" readOnly cols=\"40\" name=\"desc\">"+objInvoiceDetail.getDescription()+"</textarea>");
				rowx.add(""+objInvoiceDetail.getNumber());
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceDetail.getUnitPrice())+"</div>");
				rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice())+"</div>");
				totAmount += objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice();
				
				rowy = new Vector(1,1);
				rowy.add(objInvoiceDetail.getDescription());
				rowy.add(Formater.formatNumber(objInvoiceDetail.getNumber() * objInvoiceDetail.getUnitPrice(), "##,###"));
				vDataToPrint.add(rowy);
			}
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objInvoiceDetail.getOID()));
			
		}
		
		
		rowx = new Vector();
		if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmInvoiceDetail.errorSize()>0)){
			sSelectedAccount = ""+objInvoiceDetail.getIdPerkiraan();
			if(vListAccount != null && vListAccount.size() > 0){
				for(int a=0; a < vListAccount.size(); a++){
					objPerkiraan = (Perkiraan) vListAccount.get(a);	
					strAccName = getAccName(objPerkiraan,language);		
					vAccValue.add(strAccName);					
					vAccKey.add(""+objPerkiraan.getOID());					
				}
			}
			
			rowx.add("");
			rowx.add(ControlCombo.draw(FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_ID_PERKIRAAN], "", null, sSelectedAccount, vAccKey, vAccValue));
			rowx.add("<textarea rows=\"2\" cols=\"40\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DESCRIPTION]+"\"></textarea>");
			rowx.add("<input type=\"text\" size=\"3\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_NUMBER]+"\" value=\"\" class=\"formElemenR\">");
			rowx.add("<input type=\"text\" size=\"14\" name=\""+FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_UNIT_PRICE]+"\" value=\"\" onKeyUp=\"javascript:hitungTotal()\" class=\"formElemenR\">");
			rowx.add("<a id=\"amount\"></a>");
			lstData.add(rowx);
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
				
				if(objInvMain.getTermOfPayment() > 0){
						if(iCommand == Command.SUBMIT){
							String sSelAccDep = ""+objInvMain.getIdPerkDeposit();
							Vector vAccDepValue = new Vector(1,1);
							Vector vAccDepKey = new Vector(1,1);
							Perkiraan objPerkDep = new Perkiraan();
							if(vListAccDep != null && vListAccDep.size() > 0){
								for(int a=0; a < vListAccDep.size(); a++){
									objPerkDep = (Perkiraan) vListAccDep.get(a);	
									strAccName = getAccName(objPerkDep,language);		
									vAccDepValue.add(strAccName);					
									vAccDepKey.add(""+objPerkDep.getOID());					
								}
							}
							
							rowx = new Vector(1,1);
							rowx.add("");
							rowx.add("<div align=\"left\">Deposit</div>");
							rowx.add("<input type=\"text\" size=\"15\" onClick=\"ds_sh(this);\" name=\"depositDate\" readonly=\"readonly\" style=\"cursor: text\" value=\""+Formater.formatDate((objInvMain.getDepositDate() == null) ? new Date() : objInvMain.getDepositDate(), "dd-MM-yyyy")+"\" class=\"formElemenR\">"+
					"<input type=\"hidden\" name=\"depositDate_mn\">"+
					"<input type=\"hidden\" name=\"depositDate_dy\">"+
					"<input type=\"hidden\" name=\"depositDate_yr\">"+
					"<script language=\"JavaScript\" type=\"text/JavaScript\">getThn();</script>");
							rowx.add("");
							rowx.add(ControlCombo.draw("acc_dep", "", null, sSelAccDep, vAccDepKey, vAccDepValue));
							rowx.add("<input type=\"text\" size=\"14\" name=\"deposit\" value=\""+objInvMain.getTax()+"\" onKeyUp=\"javascript:hitungTotal()\" class=\"formElemenR\">");
							lstData.add(rowx);
							
							rowx = new Vector(1,1);
							rowx.add("");
							rowx.add("");
							rowx.add("");
							rowx.add("");
							rowx.add("<div align=\"right\">Balance</div>");
							rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount - objInvMain.getTax())+"</div>");
							lstData.add(rowx);
							
						}else{
							Perkiraan prk = new Perkiraan();
							String sPerk = "";
							if(objInvMain.getIdPerkDeposit() != 0){
								try{
									prk = PstPerkiraan.fetchExc(objInvMain.getIdPerkDeposit());
									if(prk != null){
										sPerk = getAccName(prk,language);
									}
								}catch(Exception e){}
							}
							if(objInvMain.getTax() > 0){
								rowx = new Vector(1,1);
								rowx.add("");
								rowx.add("");
								rowx.add("");
								rowx.add("");
								rowx.add("<div align=\"right\"><a href=\"javascript:cmdAddDeposit()\"> Deposit / "+Formater.formatDate(objInvMain.getDepositDate(), "dd-MM-yyyy")+" / "+sPerk+"</a></div>");
								rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objInvMain.getTax())+"</div>");
								lstData.add(rowx);
								
								rowx = new Vector(1,1);
								rowx.add("");
								rowx.add("");
								rowx.add("");
								rowx.add("");
								rowx.add("<div align=\"right\">Balance</div>");
								rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(totAmount - objInvMain.getTax())+"</div>");
								lstData.add(rowx);
							}
						}
				}
		}
		vResult.add(ctrlist.drawMe(index));
		vResult.add(vDataToPrint);
		vResult.add(""+(totAmount - objInvMain.getTax()));
		return vResult;
}


public String listPayTerm(int language, Vector objectClass, int iCommand){
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

public String drawListCosting(int language, Vector objectClass, int iCommand){
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
    ctrlist.dataFormat(strCostingTitle[language][3],"20%","center","left"); // Description
    ctrlist.dataFormat(strCostingTitle[language][4],"10%","center","right"); // Date
    ctrlist.dataFormat(strCostingTitle[language][5],"5%","center","right"); // Number
	ctrlist.dataFormat(strCostingTitle[language][6],"15%","center","right"); // Unit Price
	ctrlist.dataFormat(strCostingTitle[language][7],"10%","center","right"); // Discount
	ctrlist.dataFormat(strCostingTitle[language][8],"15%","center","left"); // Amount

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEditCosting('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	Vector vResult = new Vector(1,1);
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
			rowx.add(I_DocStatus.fieldDocumentStatus[objCosting.getStatus()]);
			totDiscount += objCosting.getDiscount();
			totAmount += objCosting.getNumber() * objCosting.getUnitPrice();
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objCosting.getOID()));
			
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
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
int posTed = FRMQueryString.requestInt(request,"posted_status");
int iQueryType = FRMQueryString.requestInt(request, "query_type");
int iInvoiceType = FRMQueryString.requestInt(request, "invoice_type");
double dDeposit = FRMQueryString.requestDouble(request, "deposit");
long idPerkDep = FRMQueryString.requestLong(request, "acc_dep");
int iDay = FRMQueryString.requestInt(request, "depositDate_dy");
int iMonth = FRMQueryString.requestInt(request, "depositDate_mn");
int iYear = FRMQueryString.requestInt(request, "depositDate_yr");
long ticketId = FRMQueryString.requestLong(request, "ticket_id");
double dUnitPrice = FRMQueryString.requestDouble(request, FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_UNIT_PRICE]);
double dSurcharge = FRMQueryString.requestDouble(request, "surcharge");
double dCommision = FRMQueryString.requestDouble(request, "commision");
double dNrta = FRMQueryString.requestDouble(request, "net_rate");
long supplierId = FRMQueryString.requestLong(request, "supplier_id");
long accCogsId = FRMQueryString.requestLong(request, "acc_cogs_id");
long accAPId = FRMQueryString.requestLong(request, "acc_ap_id");
double netPrice = dUnitPrice - dSurcharge;

//System.out.println("netPrice : "+netPrice+" dUnitPrice : "+dUnitPrice+" dSurcharge : "+dSurcharge);
Date tempDate = new Date();
Date depositDate = (Date)tempDate.clone();
depositDate.setDate(iDay);
depositDate.setMonth(iMonth - 1);
depositDate.setYear(iYear - 1900);

if(iCommand==Command.NONE)
        iCommand = Command.ADD;

if(iCommand == Command.ADD){
	oidInvoiceDetail = 0;
}		
/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add new detail" : "Tambah item";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : " Tambah Detail";
String strAddCosting = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Costing" : " Tambah Costing";
String strDeleteQuestion = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are you sure to delete ?" : "Anda yakin menghapus data ?";
String strAddPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Payment Term" : " Tambah Termin Pembayaran";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete" : "Hapus";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strPackage = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Package" : "Paket";
String strTicket = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Ticket" : "Tiket";
String strAddDeposit = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add Deposit" : "Entry Deposit";
String strSaveDeposit = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Deposit" : "Simpan Deposit";
String strAddApPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New AP Payment Term" : " Tambah Termin Pembayaran Hutang";
String strTransaction = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Transaction" : "Transaksi";
String strCredit = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Credit" : "Kredit";
String strPrint = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Print Invoice" : "Cetak Invoice";
String strDueDate = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Due Date" : "Jatuh Tempo";
String strSelectPrinter = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Select Printer" : "Pilih Printer";
String strPayableAcc = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Payable Account : " : "Perkiraan Hutang : ";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete" : "Ya Hapus Order";
String strListInvoiceDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Detail Invoice" : "Daftar Perincian Invoice";
String strListCostingDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Costing Data Entry" : "Input Data Pembiayaan";
String strListPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Receivable Payment Term" : "Daftar Termin Pembayaran Piutang";
String strListApPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Payable Payment Term" : "Daftar Termin Pembayaran Hutang";
String strInvoiceType = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Invoice Type" : "Tipe Invoice";
String strBack = "";
if(iQueryType == 1){
	strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back to invoice list" : "Kembali ke daftar invoice";
}else{
	strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add new invoice" : "Tambah invoice";
}

 
/** Instansiasi object CtrlOrderAktiva and FrmOrderAktiva */
ControlLine ctrLine = new ControlLine();
CtrlInvoiceDetail ctrlInvoiceDetail = new CtrlInvoiceDetail(request);
ctrlInvoiceDetail.setLanguage(SESS_LANGUAGE);
FrmInvoiceDetail frmInvoiceDetail = ctrlInvoiceDetail.getForm();
int iErrCode = ctrlInvoiceDetail.action(iCommand, oidInvoiceDetail, ticketId, netPrice, dCommision, supplierId, accCogsId, accAPId,dNrta,dSurcharge);
InvoiceDetail objInvoiceDetail = ctrlInvoiceDetail.getInvoiceDetail();
//oidInvoiceDetail = objInvoiceDetail.getOID();
String msgString = ctrlInvoiceDetail.getMassage();

Vector vListCosting = new Vector(1,1);
//Edit detail from main
CtrlInvoiceMain ctrlInvoiceMain = new CtrlInvoiceMain(request);
ctrlInvoiceMain.setLanguage(SESS_LANGUAGE);
FrmInvoiceMain frmInvoiceMain = ctrlInvoiceMain.getForm();
int iErrCodeMain = ctrlInvoiceMain.action(Command.EDIT, oidInvoiceMain, vListCosting, userOID);
InvoiceMain objInvoiceMain = ctrlInvoiceMain.getInvoiceMain();
String msgStr = ctrlInvoiceMain.getMassage();

if(iCommand == Command.UPDATE && idPerkDep != 0){
	objInvoiceMain.setTax(dDeposit);
	objInvoiceMain.setIdPerkDeposit(idPerkDep);
	objInvoiceMain.setDepositDate(depositDate);

	try{	
		PstInvoiceMain.updateExc(objInvoiceMain);
	}catch(Exception e){}
}

String strWhClause = PstInvoiceDetail.fieldNames[PstInvoiceDetail.FLD_INVOICE_ID]+" = "+oidInvoiceMain;
Vector list = PstInvoiceDetail.list(0,0,strWhClause,"");
	
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
   Vector vListAccDep = new Vector(1,1);
   Vector vListAccBank = new Vector(1,1);
   Perkiraan perkBank = new Perkiraan();
   String strWClause = PstCosting.fieldNames[PstCosting.FLD_INVOICE_ID]+" = "+oidInvoiceMain;
	Vector listCosting = new Vector(1,1);	
	String strWhrCls =  PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_INVOICE_ID]+" = "+oidInvoiceMain+
				  " AND "+PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_TYPE]+" = "+PstPaymentTerm.PAY_TERM_AP;
	Vector listApPayTerm = new Vector(1,1);
	String strNamaPerkiraan = "";
   try{
		vMainAccount = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_REVENUE);
		vListAccDep = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_CASH);
		vListAccBank = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_BANK);
		if(vListAccBank != null && vListAccBank.size() > 0){
			for(int b = 0; b < vListAccBank.size(); b++){
				perkBank = (Perkiraan)vListAccBank.get(b);
				vListAccDep.add(perkBank);
			}
		}
		listApPayTerm = PstPaymentTerm.list(0,0,strWhrCls,"");
		listCosting = PstCosting.list(0,0,strWClause,"");
		if(listCosting != null && listCosting.size() > 0){
			for(int i = 0; i < listCosting.size(); i++){
				Costing objCosting = (Costing)listCosting.get(i);
				if(objCosting.getIdPerkiraanHutang() != 0){
					Perkiraan objPerk = PstPerkiraan.fetchExc(objCosting.getIdPerkiraanHutang());
					strNamaPerkiraan = getAccName(objPerk,SESS_LANGUAGE);
				}
			}
		}
	}catch(Exception e){vMainAccount = new Vector(1,1);} 	

Vector listTemp = new Vector(1,1);
String strList = "";
double dPaymentTerm = 0;
Vector vDataPrint = new Vector(1,1);
try{
	if(objInvoiceMain.getType() == 0){
		listTemp = (Vector)drawList(SESS_LANGUAGE,list,iCommand, oidInvoiceDetail, vMainAccount,frmInvoiceDetail,approot);
	}else{
		listTemp = (Vector)drawListPackage(SESS_LANGUAGE,list,iCommand, oidInvoiceDetail, vMainAccount,frmInvoiceDetail,objInvoiceMain,vListAccDep);
	}	
	if(listTemp != null && listTemp.size() > 0){
		strList = listTemp.get(0).toString();
		vDataPrint = (Vector)listTemp.get(1);
		dPaymentTerm = Double.parseDouble(listTemp.get(2).toString());
	}
}catch(Exception e){listTemp = new Vector(1,1);}

Vector vListARPaymentTerm = new Vector(1,1);
String whClause = "";
PaymentTerm payTerm = new PaymentTerm();
whClause = PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_INVOICE_ID]+" = "+oidInvoiceMain+
			" AND "+PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_TYPE]+" = "+PstPaymentTerm.PAY_TERM_AR;
try{
	vListARPaymentTerm = PstPaymentTerm.list(0,0,whClause,"");
}catch(Exception e){}

if(iCommand == Command.UPDATE && idPerkDep != 0){
	if(vListARPaymentTerm != null && vListARPaymentTerm.size() > 0){
		for(int a = 0; a < vListARPaymentTerm.size(); a++){
			payTerm = (PaymentTerm)vListARPaymentTerm.get(a);
			if(dPaymentTerm > 0){
				payTerm.setAmount(dPaymentTerm / (a+1));
			}
			try{
				PstPaymentTerm.updateExc(payTerm);
			}catch(Exception e){}
		}
	}
}

String strWhere = PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_INVOICE_ID]+" = "+oidInvoiceMain+
				  " AND "+PstPaymentTerm.fieldNames[PstPaymentTerm.FLD_TYPE]+" = "+PstPaymentTerm.PAY_TERM_AR;
	Vector listPayTerm = new Vector(1,1);
try{
	listPayTerm = PstPaymentTerm.list(0,0,strWhere,"");
}catch(Exception e){}

	boolean allList = false;
	if(list.size() > 0 && listPayTerm.size() > 0 && listCosting.size() > 0 && listApPayTerm.size() > 0){
		allList = true;
	}

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
	vMain.add(accBankName);//22
	vMain.add(accBankNo);//23
	vMain.add(bankName);//24
	vMain.add(""+objInvoiceMain.getTermOfPayment());//25
	vMain.add(""+objInvoiceMain.getTax());//26
	vMain.add(userFullName);//27
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
		
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">
function getThn()
{
	<%if(objInvoiceMain.getType() == 0){%>
	var date1 = ""+document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE]+ "_mn"%>.value=bln;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE] + "_dy"%>.value=hri;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DATE] + "_yr"%>.value=thn;
	<%}else{%>
		var date2 = ""+document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.depositDate.value;
	
		var thn2 = date2.substring(6,10);
		var bln2 = date2.substring(3,5);	
		if(bln2.charAt(0)=="0"){
			bln2 = ""+bln2.charAt(1);
		}
	
		var hri2 = date2.substring(0,2);
		if(hri2.charAt(0)=="0"){
			hri2 = ""+hri2.charAt(1);
		}
	
		document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.depositDate_mn.value=bln2;
		document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.depositDate_dy.value=hri2;
		document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.depositDate_yr.value=thn2;
	<%}%>
}


function cmdAdd(){
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.prev_command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdAddDeposit(){
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.SUBMIT%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdSaveDeposit(){
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.UPDATE%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdSave(){
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdPrint(){
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.PRINT%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdEdit(oid){
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_detail_id.value = oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.prev_command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdEditPayTerm(oid){
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.payment_term_id.value=oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_type.value="<%=iInvoiceType%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="payment_term.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdEditCosting(oid){
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.costing_id.value=oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_type.value="<%=iInvoiceType%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="costing.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdEditApPayTerm(oid){
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.payment_ap_term_id.value=oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_type.value="<%=iInvoiceType%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="ap_payment_term.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdAddPaymentTerm(oid){
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_main_id.value=oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_type.value="<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="payment_term.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdAddApPaymentTerm(oid){
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_main_id.value=oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.query_type.value ="<%=iQueryType%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_type.value = "<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="ap_payment_term.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdAsk(oid){
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_detail_id.value = oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.ASK%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function hitungTotal(){
	var totPrice = 0;
	var qty = parseInt(document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_NUMBER]%>.value);
	var unitPrice = parseInt(document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_UNIT_PRICE]%>.value);
	var surcharge = parseInt(document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.surcharge.value);
	totPrice = unitPrice + surcharge;
	var amount = qty * totPrice;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_UNIT_PRICE]%>.value=totPrice;
	if(!isNaN(amount)){
	document.all.amount.innerHTML = amount;
	}
}

function cmdDelete(oid){
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_detail_id.value = oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_detail.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdAddCosting(oid){
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.costing_id.value=oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_type.value="<%=objInvoiceMain.getType()%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.query_type.value="<%=iQueryType%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="costing.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdBackMain(){
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_detail_id.value = 0;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.ADD%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdBack(){
	<%if(iQueryType == 1){%>
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.LIST%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_list.jsp";
	<%}else{%>
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.LIST%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_detail.jsp";
	<%}%>
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdSaveMain(oid){
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_main_id.value = oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdPosted(){
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.SAVE%>";
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_STATUS]%>.value = "<%=I_DocStatus.DOCUMENT_STATUS_POSTED%>";
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.posted_status.value="1";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function cmdAskMain(oid){
    document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.invoice_main_id.value = oid;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.command.value="<%=Command.ASK%>";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.action="invoice_edit.jsp";
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.submit();
}

function openTicket(){
	closeWindow();
	myWindow = window.open("searchticket.jsp?src_from=1&&command=<%=Command.LIST%>","src_ticket","height=500,width=500,left=400,top=100, status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function openTicketNumber(){
	closeWindow();
	var url = "search_ticket_number.jsp?command=<%=Command.LIST%>"+
	"&carrier_id="+document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.carrier_id.value;
	myWindow = window.open(url,"src_ticket_number","height=500,width=500,left=400,top=100,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function setDescription(){
	var description = document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DESCRIPTION]%>.value;
	var ticketNumber = document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.ticket_number.value;
	var newDescription = description +"/"+ticketNumber;
	document.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DESCRIPTION]%>.value = newDescription;
	
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
            <form name="<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="invoice_main_id" value="<%=oidInvoiceMain%>">
              <input type="hidden" name="invoice_detail_id" value="<%=oidInvoiceDetail%>">
			  <input type="hidden" name="costing_id" value="0">
			  <input type="hidden" name="payment_term_id" value="0">
			  <input type="hidden" name="payment_ap_term_id" value="0">
              <input type="hidden" name="posted_status" value="0">
			  <input type="hidden" name="query_type" value="<%=iQueryType%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
			  <input type="hidden" name="<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_INVOICE_ID]%>" value="<%=oidInvoiceMain%>">
			  <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_STATUS]%>" value="<%=objInvoiceMain.getStatus()%>">
			  <input type="hidden" name="<%=FrmInvoiceMain.fieldNames[FrmInvoiceMain.FRM_TOTAL_DISCOUNT]%>" value="0">
			  <input type="hidden" name="invoice_type" value="<%=iInvoiceType%>">
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
								  	<td colspan="9">&nbsp;<b><%=strInvoiceType%> : <font color="#CC3300"><%=objInvoiceMain.getType() == 0? strTicket.toUpperCase() : strPackage.toUpperCase()%></font></b></td>
								  </tr>
								  <tr>
                                    <td colspan="9">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td width="12%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][2]%>&nbsp;<b><%=objInvoiceMain.getInvoiceNumber()%></b></td>
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
                                    <td height="25" colspan="9">
										<%if(objInvoiceMain.getType() == 0){%>
										
										<table width="100%">
											<tr>
                                    <td width="12%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][4]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td height="25" colspan="3"><%=strFirstContact%>
                                    </td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25"><%=strTitle[SESS_LANGUAGE][11]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25"><%=Formater.formatDate((objInvoiceMain.getIssuedDate() == null) ? new Date() : objInvoiceMain.getIssuedDate(), "dd-MM-yyyy")%>
                                    </td>
                                  </tr>
								  <tr>
                                    <td width="12%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][7]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td height="25" colspan="3"><%=strPerkiraan%></td>
                                    <td width="11%">&nbsp;</td>
                                    <td width="14%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][11]%><%=strTitle[SESS_LANGUAGE][23]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="25%" height="25"><%=objInvoiceMain.getTermOfPayment()%>&nbsp;&nbsp;<%=strTitle[SESS_LANGUAGE][25]%></td>
                                  </tr>
										</table>
										<%}%>
									</td>
                                  </tr>
                                  <tr>
                                    <td colspan="9">
									<%if(objInvoiceMain.getType() == 1){%>
										<table width="100%">
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
										</table>
										<%}%>
									</td>
                                  </tr>
								  <tr>
                                    <td colspan="9">&nbsp;</td>
                                  </tr>
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
                                  <tr>
                                    <td colspan="9">&nbsp;</td>
                                  </tr>
								  <%if(listPayTerm != null && listPayTerm.size() > 0){%>
								  <tr>
                                    <td colspan="9">&nbsp;<b><%=strListPaymentTerm%></b></td>
                                  </tr>
								  <tr>
                                    <td colspan="9">																				
											<%=listPayTerm(SESS_LANGUAGE, listPayTerm, iCommand)%>
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
											<%=drawListCosting(SESS_LANGUAGE, listCosting, iCommand)%>
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
											<%=listApPayTerm(SESS_LANGUAGE, listApPayTerm, iCommand)%>
									</td>
                                  </tr>
								  <%}%>
                                  <tr>
                                    <td colspan="9"><table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                      <tr>
                                        <td width="70%" nowrap scope="row"><%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault(SESS_LANGUAGE,"");
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidInvoiceDetail+"')";
							String sconDelCom = "javascript:cmdDelete('"+oidInvoiceDetail+"')";
							String scancel = "javascript:cmdEdit('"+oidInvoiceDetail+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);
							ctrLine.setBackCaption(strBack);
							ctrLine.setAddCaption(strAdd);
							ctrLine.setDeleteQuestion(strDeleteQuestion);
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
							
							if(iCommand != Command.SUBMIT){
								out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							}
							//&& iQueryType != 1
							%></td>
							<td width="30%" nowrap>
							<%if((list != null && list.size() > 0) && !allList){%>
							<%if(objInvoiceMain.getTermOfPayment() > 0){%>
								<a href="javascript:cmdPrint()" class="command">
									<%=strPrint%>
								</a>
								<%if(objInvoiceMain.getTax() == 0 && (iCommand == Command.SAVE || iCommand == Command.UPDATE) && objInvoiceMain.getType() == 1){%>
									| <a href="javascript:cmdAddDeposit()" class="command">
									<%=strAddDeposit%>
									</a>
								<%}%>
								<%if(iCommand == Command.SUBMIT){%>
									| <a href="javascript:cmdSaveDeposit()" class="command">
									<%=strSaveDeposit%>
									</a>
								<%}%>
								<%if(listPayTerm.size() == 0){%>
									 | <a href="javascript:cmdAddPaymentTerm('<%=oidInvoiceMain%>')" class="command">
									<%=strAddPaymentTerm%>
									</a> 
								<%}else{
									if(listCosting == null && listCosting.size() == 0){
								%>
									| <a href="javascript:cmdAddCosting('<%=oidInvoiceMain%>')" class="command">
									<%=strAddCosting%>
									</a>
									<%}else{%>
										| <a href="javascript:cmdAddApPaymentTerm('<%=oidInvoiceMain%>')" class="command">
										<%=strAddApPaymentTerm%>
										</a>
									<%}%>
								<%}%>
							<%}else{%>
								<a href="javascript:cmdAddCosting('<%=oidInvoiceMain%>')" class="command">
								<%=strAddCosting%>
								</a> | 							
								<a href="javascript:cmdPrint()" class="command">
									<%=strPrint%>
								</a>
							<%}%>
							<%}else{%>
								<%if(iCommand == Command.UPDATE){%>
								<a href="javascript:cmdBack()" class="command">
									<%=strBack%>
								</a> |
								<%}%>
								 <a href="javascript:cmdPrint()" class="command">
									<%=strPrint%>
								</a>
								<%if(objInvoiceMain.getTax() == 0 && (iCommand == Command.SAVE || iCommand == Command.UPDATE)){%>
									| <a href="javascript:cmdAddDeposit()" class="command">
									<%=strAddDeposit%>
									</a>
								<%}%>
								<%if(iCommand == Command.SUBMIT){%>
									| <a href="javascript:cmdSaveDeposit()" class="command">
									<%=strSaveDeposit%>
									</a>
								<%}%>
							<%}%>
							<a href="javascript:cmdPosted()" class="command"><%if(objInvoiceMain.getStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED&&list.size()>0){%><%//=strTitle[SESS_LANGUAGE][10]%><%}%></a></td>
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
