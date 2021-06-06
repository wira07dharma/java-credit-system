<%@ page language ="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.entity.search.SrcOrderAktiva,
                 com.dimata.aiso.form.search.FrmSrcOrderAktiva,
                 com.dimata.util.Command,
                 com.dimata.aiso.form.aktiva.CtrlOrderAktiva,
                 com.dimata.util.Formater,
                 com.dimata.aiso.entity.search.SrcArApEntry,
                 com.dimata.aiso.form.search.FrmSrcArApEntry,
                 com.dimata.aiso.session.arap.SessArApEntry,
                 com.dimata.aiso.form.arap.CtrlArApPayment,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.aiso.form.search.FrmSrcArApReport,
                 com.dimata.aiso.entity.search.SrcArApReport,
                 com.dimata.aiso.session.arap.SessArApDetailReport,
                 com.dimata.aiso.entity.report.*,
                 com.dimata.aiso.entity.arap.ArApPayment,
                 com.dimata.common.entity.payment.PstCurrencyType,
                 com.dimata.common.entity.payment.CurrencyType,
                 com.dimata.aiso.entity.masterdata.Perkiraan,
                 com.dimata.aiso.entity.masterdata.PstPerkiraan,
                 com.dimata.gui.jsp.ControlDate,
                 com.dimata.aiso.form.arap.FrmArApPayment,
                 com.dimata.gui.jsp.ControlCombo,
                 com.dimata.common.entity.payment.PstStandartRate,
                 com.dimata.common.entity.payment.StandartRate,
                 com.dimata.aiso.entity.arap.*,
                 com.dimata.aiso.form.jurnal.CtrlJurnalUmum" %>
				 
<!-- Package Journal Distribution --->
<%@ page import="com.dimata.aiso.entity.jurnal.JournalDistribution" %> 
<%@ page import="com.dimata.aiso.entity.jurnal.PstJournalDistribution" %> 
<%@ page import="com.dimata.aiso.session.jurnal.SessJurnal" %> 
<%@ page import="com.dimata.aiso.form.jurnal.FrmJournalDistribution" %>
<%@ page import="com.dimata.aiso.form.jurnal.CtrlJournalDistribution" %>
<%@ page import="com.dimata.aiso.session.masterdata.SessDailyRate"%>
<%@ page import="com.dimata.aiso.entity.periode.PstPeriode"%>
<%@ page import="com.dimata.aiso.entity.masterdata.BussinessCenter"%>
<%@ page import="com.dimata.aiso.entity.masterdata.PstBussinessCenter"%>
<%@ page import="com.dimata.aiso.entity.masterdata.DailyRate"%>
<!-- End Package Journal Distribution -->				 

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privSubmit){
%>


<!-- if of "has access" condition -->
<%
}
else
{
%>

<!-- JSP Block -->
<%!

public static String strTitle[][] = 
{
	{
		"No.",//0
		"Kontak",//1
        "Dokumen",//2
		"Nomor",//3
        "Tanggal",//4
        "Tanggal JT",//5
        "Nominal",//6
        "Bayar",//7
        "Saldo",//8
        "Keterangan",//9
        "Tidak ada data sesuai yang ditemukan",//10
        "s/d",//11
        "Posting ke Jurnal",//12
        "Daftar Angsuran ",//13
        "Entry Pembayaran ",//14
        "Jatuh Tempo",//15
        "Lewat Waktu",//16
        "Sekarang",//17
        "Besok",//18
        "hari",//19
        "diatas",//20
        "AR",//21
        "AP",//22
        "Bayar",//23
        "No / No Inv"//24                                                                                
	},
	{
		"No.",//0
        "Contact",//1
        "Document",//2
        "Nomor",//3
        "Date",//4
        "Due Date",//5
        "Nominal",//6
        "Payed",//7
        "Balance",//8
        "Description",//9
        "List is empty",//10
        "to",//11
        "Posting Jurnal",//12
        "List Term of Payment ",//13
        "Payment Entry ",//14
        "Due Date",//15
        "Over Due",//16
        "Today",//17
        "Tomorrow",//18
        "days",//19
        "above",//20
        "AR",//21
        "AP",//22
        "Payment",//23
        "No / Inv No"//24                                                                                     
	}
};

public static String strTitlePayment[][] =
{
	{
		"No.",
        "Dokumen Pembayaran",
		"Nomor",
        "Tanggal",
        "Mata Uang",
        "Nominal Pembayaran",
        "Nilai Tukar",
        "Nilai Buku",
        "Perkiraan Pembayaran"
	},
	{
		"No.",
        "Payment Document",
        "Number",
        "Date",
        "Currency",
        "Payment Nominal",
        "Rate",
        "Book Value",
        "Payment Account"
	}
};

public static String strTitleAngsuran[][] =
{
	{
		"No.",
        "Tanggal Jatuh Tempo",
		"Nominal",
        "Bayar",
        "Saldo",
        "Lunas",
        "Belum"
	},
	{
		"No.",
        "Due Date",
        "Nominal",
        "Payed",
        "Balance",
        "Closed",
        "No"
	}
};

public static final String masterTitle[][] ={
    {"Laporan","Piutang"},
	{"Report","Account Receivable"}
};

public static final String listTitle[][] =
{
    {"Daftar Penambahan Piutang",
	"Receivable Increase List"
    }
    ,
    {"Daftar Penambahan Hutang",
	"Payable Increase List"
    }
    ,
    {"Daftar Pembayarann Piutang",
	"Receivable Payment List"
    }
    ,
    {"Daftar Pembayaran Hutang",
	"Payable Payment List"
    }
};


//------------------------------------------------ JDistribution ---------------------------------------------------

public static String strTitleJDistribution[][] = {
	{
	"Input Jurnal Distribusi","Keterangan","Debet(Rp)","Kredit(Rp)","Mata Uang","Kurs(Rp)","Pusat Bisnis","Untuk","Catatan","Silahkan input debet atau kredit sesuai nilai mata uangnya. System seraca otomatis mengkonversi ke rupiah.","Daftar Journal Distribusi","Nama Perkiraan"
	},	
	
	{
	"Journal Distribution Entry","Remark","Debet(Rp)","Credit(Rp)","Currency","Rate(Rp)","Bussiness Center","For","Note","Please entry debit or credit amount in original currency. System will convert automatically to local currency.","List Journal Distribution","Account Name"
	}
};

//--------------------------------------------- End JDistribution --------------------------------------------------
   
public String listDrawDetailReport(FRMHandler objFRMHandler, Vector list, int language, int type, int idx)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

		ctrlist.dataFormat(strTitle[language][0],"5%","2","0","center","right");
        ctrlist.dataFormat(strTitle[language][2],"70%","0","4","center","center");
        ctrlist.dataFormat(strTitle[language][3],"15%","0","0","center","left");
        ctrlist.dataFormat(strTitle[language][4],"10%","0","0","center","center");
        ctrlist.dataFormat(strTitle[language][5],"10%","0","0","center","center");
        ctrlist.dataFormat(strTitle[language][6],"10%","0","0","center","right");
        ctrlist.dataFormat(strTitle[language][7],"10%","2","0","center","right");
        ctrlist.dataFormat(strTitle[language][8],"10%","2","0","center","right");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");

        Vector lstData = ctrlist.getData();

        ctrlist.reset();
        int index = -1;
        try{
            if(idx<list.size()){                
                ArApDetail arApReport = (ArApDetail)list.get(idx);
                Vector detail = arApReport.getDetail();
                for(int j=0;j<detail.size();j++){
                    Vector rowx = new Vector();

                    rowx.add((j+1)+" ");

                    ArApDetailItem item = (ArApDetailItem) detail.get(j);
                    
                    rowx.add(item.getVoucherNo());                    
                    rowx.add(Formater.formatDate(item.getVoucherDate(),"dd-MMM-yyyy"));
                    rowx.add(Formater.formatDate(item.getDueDate(),"dd-MMM-yyyy"));
                    rowx.add(FRMHandler.userFormatStringDecimal(item.getNominal()));
                    rowx.add(FRMHandler.userFormatStringDecimal(item.getPayed()));
                    rowx.add(FRMHandler.userFormatStringDecimal(item.getBalance()));
                    lstData.add(rowx);
                }

                Vector rowx = new Vector();
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                lstData.add(rowx);

                rowx = new Vector();
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add("<b>TOTAL</b>");
                rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApReport.getTotalNominal())+"</b>");
                rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApReport.getTotalPay())+"</b>");
                rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApReport.getTotalBalance())+"</b>");
                lstData.add(rowx);
            }
         }catch(Exception e){
            System.out.println("EXc : "+e.toString());
         }

    
       return ctrlist.drawMeList();

}

public String listDrawArApPayment(FRMHandler objFRMHandler, Vector list, int language,long currId, double currPay, long userOID, int iCommand, long arapPaymentId)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

    ctrlist.dataFormat(strTitlePayment[language][0],"5%","2","0","center","right");
    ctrlist.dataFormat(strTitlePayment[language][1],"30%","0","2","center","center");
    ctrlist.dataFormat(strTitlePayment[language][2],"15%","0","0","center","left");
    ctrlist.dataFormat(strTitlePayment[language][3],"15%","0","0","center","center");
    ctrlist.dataFormat(strTitlePayment[language][4],"5%","2","0","center","center");
    ctrlist.dataFormat(strTitlePayment[language][5],"10%","2","0","center","right");
    ctrlist.dataFormat(strTitlePayment[language][6],"5%","2","0","center","right");
    ctrlist.dataFormat(strTitlePayment[language][7],"10%","2","0","center","right");
    ctrlist.dataFormat(strTitlePayment[language][8],"20%","2","0","center","left");

    Vector lstData = ctrlist.getData();

    ctrlist.reset();
    int index = -1;
	CurrencyType curr = new CurrencyType();
	Perkiraan per = new Perkiraan();
    try{
        int size = list.size();
        double total = 0;
        for (int i=0; i < size; i++){
            ArApPayment arap = (ArApPayment)list.get(i);
           
		   	if(arap.getIdCurrency() != 0){
				try{
					curr = PstCurrencyType.fetchExc(arap.getIdCurrency());
				}catch(Exception e){}
			}
			
			if(arap.getIdPerkiraanPayment() != 0){
				try{
					per = PstPerkiraan.fetchExc(arap.getIdPerkiraanPayment());
				}catch(Exception e){}
			}
	
			Vector rowx = new Vector();
			
			rowx.add((i+1)+" ");
			rowx.add(arap.getPaymentNo());
			rowx.add(Formater.formatDate(arap.getPaymentDate(),"dd-MMM-yyyy"));		
			rowx.add(curr.getCode());
			rowx.add(FRMHandler.userFormatStringDecimal(arap.getAmount()/arap.getRate()));
			rowx.add(FRMHandler.userFormatStringDecimal(arap.getRate()));
			rowx.add(FRMHandler.userFormatStringDecimal(arap.getAmount()));		
			rowx.add(per.getNoPerkiraan()+" "+per.getNama());
			lstData.add(rowx);
	   }
	}catch(Exception e){}
    return ctrlist.drawMeList();

}

public String listDrawArApItem(int language, Vector objectClass,Date dueDate,ArApItem item){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("70%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitleAngsuran[language][0],"5%","center","right"); // no
    ctrlist.dataFormat(strTitleAngsuran[language][1],"15%","center","center"); // tanggal
    ctrlist.dataFormat(strTitleAngsuran[language][2],"15%","center","right"); // angsuran
    ctrlist.dataFormat(strTitleAngsuran[language][3],"15%","center","right"); // bayar
    ctrlist.dataFormat(strTitleAngsuran[language][4],"15%","center","right"); // saldo
    ctrlist.dataFormat(strTitleAngsuran[language][5],"5%","center","center"); // lunas

	Vector lstData = ctrlist.getData();
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
    int size = objectClass.size();
	for (int i = 0; i < size; i++) {

		ArApItem arApItem = (ArApItem)objectClass.get(i);

		rowx = new Vector();
        if(arApItem.getDueDate().equals(dueDate)){
            rowx.add("<b>"+(i+1)+"</b>");
            rowx.add("<b>"+Formater.formatDate(arApItem.getDueDate(),"dd-MMM-yyyy")+"</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApItem.getAngsuran())+"</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApItem.getAngsuran()-arApItem.getLeftToPay())+"</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApItem.getLeftToPay())+"</b>");
            rowx.add("<b>"+(arApItem.getLeftToPay()==0?strTitleAngsuran[language][5]:strTitleAngsuran[language][6])+"</b>");
            item.setLeftToPay(arApItem.getLeftToPay());
        }
        else{
            rowx.add(""+(i+1));
            rowx.add(Formater.formatDate(arApItem.getDueDate(),"dd-MMM-yyyy"));
            rowx.add(FRMHandler.userFormatStringDecimal(arApItem.getAngsuran()));
            rowx.add(FRMHandler.userFormatStringDecimal(arApItem.getAngsuran()-arApItem.getLeftToPay()));
            rowx.add(FRMHandler.userFormatStringDecimal(arApItem.getLeftToPay()));
            rowx.add(arApItem.getLeftToPay()==0?strTitleAngsuran[language][5]:strTitleAngsuran[language][6]);
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

//-------------------------------------------------------------------- JDistribution ---------------------------------------------------------------

public String getAccName(int language, Perkiraan objPerkiraan)
{
	String sResult = "";
	try{
		if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
			sResult = objPerkiraan.getAccountNameEnglish();
		}else{
			sResult = objPerkiraan.getNama();
		}
	}catch(Exception e){}
	return sResult;
}

public Vector drawListJDistribution(int iCommand, int language, long jDistributionId, FrmJournalDistribution frmJournalDistribution,
        Vector vJDistribution, Vector listCurrencyType, Vector vBisnisCenter, long accountId, long periodeId, long arapMainId,
        long arapPaymentId, int posted,double amount, int arapType, long jDetailId, String approot)
{
	Vector vResult = new Vector();
	String sResult = "";
	String sListOpening = "<table width=\"100%\" border=\"0\" class=\"listgen\" cellspacing=\"1\">";
	sListOpening = sListOpening + "<tr><td width=\"15%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][6]+"</div></td>";//2 Bisnis Center
	sListOpening = sListOpening + "<td width=\"20%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][11]+"</div></td>";//Acc
	sListOpening = sListOpening + "<td width=\"15%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][4]+"</div></td>";//3 Currency
	sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][5]+"</div></td>";//4 Rate
	sListOpening = sListOpening + "<td width=\"20%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][2]+"</div></td>";//5 Debet
	sListOpening = sListOpening + "<td width=\"20%\" class=\"listgentitle\"><div align=\"center\">"+strTitleJDistribution[language][3]+"</div></td></tr>";//6 Credit
	

    String sListClosing = "</table>";
	String sListContent = "";
	String accName ="";
	
	Vector currencytypeid_value = new Vector(1,1);
	Vector currencytypeid_key = new Vector(1,1);
	String selectedCurrType = "";
	double totDebet = 0.0;
	double totCredit = 0.0;
	
	if(listCurrencyType!=null && listCurrencyType.size()>0){
		for(int it=0; it<listCurrencyType.size(); it++){
			CurrencyType currencyType =(CurrencyType)listCurrencyType.get(it);
			
			currencytypeid_key.add(currencyType.getName()+"("+currencyType.getCode()+")");
			currencytypeid_value.add(""+currencyType.getOID());
		}
	}
	
	Perkiraan objPerk = new Perkiraan();
	String namaPerk = "";
	if(accountId != 0){
		try{
			objPerk = PstPerkiraan.fetchExc(accountId);
			namaPerk = getAccName(language,objPerk);
		}catch(Exception e){}
	}
	

	Vector vBisnisCenterVal = new Vector();
	Vector vBisnisCenterKey = new Vector();
	String selectedBisnisCenter = "";
	if(vBisnisCenter.size() > 0){
		for(int b = 0; b < vBisnisCenter.size(); b++){
			BussinessCenter objBCenter = (BussinessCenter)vBisnisCenter.get(b);
			
			vBisnisCenterVal.add(""+objBCenter.getOID()); 
			vBisnisCenterKey.add(objBCenter.getBussCenterName());
		}
	}
	
	JournalDistribution jDistribution = new JournalDistribution();
	if(vJDistribution!=null && vJDistribution.size()>0)	{
		// --- start proses content ---
		for(int it = 0; it<vJDistribution.size();it++){
			 jDistribution = (JournalDistribution)vJDistribution.get(it);
			 selectedBisnisCenter = ""+jDistribution.getBussCenterId();
			 selectedCurrType = ""+jDistribution.getCurrencyId();
			 						 
			 String bisnisCenterName = "";
			 if(jDistribution.getBussCenterId() != 0)
			 {
			 	try{
			 	BussinessCenter bisnisCenter = PstBussinessCenter.fetchExc(jDistribution.getBussCenterId());
				bisnisCenterName = bisnisCenter.getBussCenterName();
				}catch(Exception e){}
			 }
			 
			 String currName = "";
			 CurrencyType currencyType = new CurrencyType();
			 if(jDistribution.getCurrencyId() != 0)
			 {
			 	try{
					currencyType = PstCurrencyType.fetchExc(jDistribution.getCurrencyId());
					currName = currencyType.getName()+"("+currencyType.getCode()+")";
				}catch(Exception e){}
			 }
			 
			 //String accName = "";
			 Perkiraan objPerkiraan = new Perkiraan();
			 if(jDistribution.getIdPerkiraan() != 0){
					try{
						objPerkiraan = PstPerkiraan.fetchExc(jDistribution.getIdPerkiraan());
						accName = getAccName(language,objPerkiraan);
					}catch(Exception e){}
				}
				
			 	System.out.println("jDistributionId = "+jDistributionId+", jDistribution.getOID() = "+jDistribution.getOID());
			 	if(jDistributionId==jDistribution.getOID()&&(iCommand == Command.EDIT || iCommand == Command.ASK)){
					sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_BUSS_CENTER_ID], null, selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey,"","")+"</div>"+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ID_PERKIRAAN]+"\" size=\"15\" value=\""+jDistribution.getIdPerkiraan()+"\"> "+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_MAIN_ID]+"\" size=\"15\" value=\""+arapMainId+"\"> "+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_JOURNAL_DETAIL_ID]+"\" size=\"15\" value=\""+jDistribution.getJournalDetailId()+"\"> "+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_PAYMENT_ID]+"\" size=\"15\" value=\""+arapPaymentId+"\"> "+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_PERIODE_ID]+"\" size=\"15\" value=\""+periodeId+"\"></td>" ;                                        
                                        sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+
                                        "<input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_COA_CODE]+"\" size=\"10\" value=\""+objPerkiraan.getNoPerkiraan()+"\"> "+ 
                                         " &nbsp; <a href=\"javascript:openJdAccount()\">";
                                        sListContent = sListContent + "<img border=\"0\" src=\"" + approot + "/dtree/img/folderopen.gif\"></a>&nbsp;</div>"+accName+"</td>";
					sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CURRENCY_ID], null, selectedCurrType, currencytypeid_value, currencytypeid_key,"onChange=\"javascript:changeCurrTypeJDistribution()\"","")+"</div></td>";
					sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" readOnly name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_TRANS_RATE]+"\" size=\"28\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate())+"\" class=\"txtalign\"></div></td>"+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_STANDARD_RATE]+"\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getStandardRate()) +"\">";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_DEBIT_AMOUNT]+"\" size=\"20\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount()) +"\" class=\"txtalign\"></div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CREDIT_AMOUNT]+"\" size=\"20\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount())+"\" class=\"txtalign\"></div></td></tr>";
					sListContent = sListContent + "<tr><td colspan=\"6\" class=\"listgensell\"><div align=\"left\"><b>"+strTitleJDistribution[language][1]+" : </b><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_NOTE]+"\" size=\"150\" value=\""+jDistribution.getNote()+"\" ></div></td></tr>";				
                   
				 }else{      
				 		sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"><a href=\"javascript:cmdClickBisnisCenter('"+jDistribution.getOID()+"')\">"+bisnisCenterName+"</a></div></td>";
				 	 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"></div>"+accName+"</td>";						
                                                sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+objPerkiraan.getNoPerkiraan()+"&nbsp;"+ currName +"</div></td>";
						sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate()) +"</div></td>";
				 		sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+frmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount())+"&nbsp; ("+currencyType.getCode().toUpperCase()+" = "+ frmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount()/jDistribution.getTransRate()) +")</div></td>";
				 		sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+frmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount())+"&nbsp; ("+currencyType.getCode().toUpperCase()+" = " +frmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount()/jDistribution.getTransRate()) +")</div></td></tr>";
						sListContent = sListContent + "<tr><td colspan=\"6\" class=\"listgensell\"><div align=\"left\"><b>"+strTitleJDistribution[language][1]+" : </b>"+ jDistribution.getNote() +"</div></td></tr>";
				
		 }
		 
		 totDebet += jDistribution.getDebitAmount();
		 totCredit += jDistribution.getCreditAmount();
	}
	
		// For second row and next  
		if(iCommand==Command.ADD){ 	
			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_BUSS_CENTER_ID], null, selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey,"","")+"</div></td>"+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ID_PERKIRAAN]+"\" size=\"15\" value=\""+jDistribution.getIdPerkiraan()+"\"> "+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_MAIN_ID]+"\" size=\"15\" value=\""+arapMainId+"\"> "+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_JOURNAL_DETAIL_ID]+"\" size=\"15\" value=\""+jDistribution.getJournalDetailId()+"\"> "+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_PAYMENT_ID]+"\" size=\"15\" value=\""+arapPaymentId+"\"> "+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_PERIODE_ID]+"\" size=\"15\" value=\""+periodeId+"\"> ";	
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+
                   "<input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_COA_CODE]+"\" size=\"10\" value=\"\"> "+ 
                          " &nbsp; <a href=\"javascript:openJdAccount()\">";
            sListContent = sListContent + "<img border=\"0\" src=\"" + approot + "/dtree/img/folderopen.gif\"></a>&nbsp;</div><input type=\"text\" name=\""+
                                FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]+"\" size=\"25\" readonly value=\"" + "" + "\"></td>";
                        sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CURRENCY_ID], null, selectedCurrType, currencytypeid_value, currencytypeid_key,"onChange=\"javascript:changeCurrTypeJDistribution()\"","")+"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" readOnly name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_TRANS_RATE]+"\" size=\"28\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate())+"\" class=\"txtalign\"></div></td>"+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_STANDARD_RATE]+"\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getStandardRate())+"\">";		
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_DEBIT_AMOUNT]+"\" size=\"20\" value=\""+(arapType == 1? (amount - jDistribution.getDebitAmount()) : 0)+"\" class=\"txtalign\" </div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CREDIT_AMOUNT]+"\" size=\"20\" value=\""+(arapType == 0? (amount - jDistribution.getCreditAmount()) : 0)+"\" class=\"txtalign\" </div></td></tr>";			
			sListContent = sListContent + "<tr><td colspan=\"6\" class=\"tabtitlehidden\"><div align=\"left\"><b>"+strTitleJDistribution[language][1]+" : </b><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_NOTE]+"\" size=\"150\" value=\"\"></div></td></tr>";
			}
			sListContent += "<tr><td colspan=\"4\" class=\"tabtitlehidden\"><div align=\"right\"><b>TOTAL</b></div></td>";
			sListContent += "<td class=\"tabtitlehidden\"><div align=\"right\">"+frmJournalDistribution.userFormatStringDecimal(totDebet)+"</div></td>";
			sListContent += "<td class=\"tabtitlehidden\"><div align=\"right\">"+frmJournalDistribution.userFormatStringDecimal(totCredit)+"</div></td></tr>";
}else{
	//Just first row
	if(iCommand==Command.ADD){	
			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_BUSS_CENTER_ID], null, selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey,"","")+"</div></td>";		
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+
                          "<input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_COA_CODE]+"\" size=\"15\" value=\"\"> "+ 
                                  " &nbsp; <a href=\"javascript:openJdAccount()\">";
                        sListContent = sListContent + "<img border=\"0\" src=\"" + approot + "/dtree/img/folderopen.gif\"></a>&nbsp;</div><input type=\"text\" name=\""+
                                FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]+"\" size=\"25\" readonly value=\"" + "" + "\">" +"</td>";
                        sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CURRENCY_ID], null, selectedCurrType, currencytypeid_value, currencytypeid_key,"onChange=\"javascript:changeCurrTypeJDistribution()\"","")+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ID_PERKIRAAN]+"\" size=\"15\" value=\""+accountId+"\"> " +
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_MAIN_ID]+"\" size=\"15\" value=\""+arapMainId+"\"> "+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_JOURNAL_DETAIL_ID]+"\" size=\"15\" value=\""+jDetailId+"\"> "+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_PAYMENT_ID]+"\" size=\"15\" value=\""+arapPaymentId+"\"> "+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_PERIODE_ID]+"\" size=\"15\" value=\""+periodeId+"\"></div></td>";					
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_TRANS_RATE]+"\" size=\"28\" readOnly value=\""+frmJournalDistribution.userFormatStringDecimal(1)+"\" class=\"txtalign\">"+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_STANDARD_RATE]+"\" value=\""+frmJournalDistribution.userFormatStringDecimal(1)+"\"></div></td>";		
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_DEBIT_AMOUNT]+"\" size=\"20\" value=\""+(arapType == 1? amount : 0)+"\" class=\"txtalign\"> </div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CREDIT_AMOUNT]+"\" size=\"20\" value=\""+(arapType == 0? amount : 0)+"\" class=\"txtalign\"> </div></td></tr>";			
		 	sListContent = sListContent + "<tr><td colspan=\"6\" class=\"tabtitlehidden\"><div align=\"left\"><b>"+strTitleJDistribution[language][1]+" : </b><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_NOTE]+"\" size=\"180\" value=\"\"></div></td></tr>";
	}
}


	sResult = sListOpening + sListContent + sListClosing;
	vResult.add(sResult);
	vResult.add(""+totDebet);
	vResult.add(""+totCredit);
	return vResult;
}

//----------------------------------------------------------------- End JDistribution --------------------------------------------------------------
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int index = FRMQueryString.requestInt(request,"index");
int indexPay = FRMQueryString.requestInt(request,"index_pay");
int arapType = FRMQueryString.requestInt(request,"arap_type");
int payment = FRMQueryString.requestInt(request,"payment");
long paymentId = FRMQueryString.requestLong(request,"payment_id");
long jDistributionId = FRMQueryString.requestLong(request,"j_distribution_id");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long jDetailId = FRMQueryString.requestLong(request,"j_detail_id");

SrcArApReport srcArApReport = new SrcArApReport();
FrmSrcArApReport frmSrcArApReport = new FrmSrcArApReport(request);
frmSrcArApReport.requestEntityObject(srcArApReport);

// Proses Data To Database
CtrlJournalDistribution ctrlJDistribution = new CtrlJournalDistribution(request);
int iJDErrorCode = ctrlJDistribution.action(iCommand, jDistributionId);
FrmJournalDistribution frmJDistribution = ctrlJDistribution.getForm();
JournalDistribution objJDistribution = ctrlJDistribution.getJournalDistribution();
jDistributionId = objJDistribution.getOID();
String msgString = ctrlJDistribution.getMessage();

ArApPayment arApPayment = new ArApPayment();
	if(paymentId != 0){
		try{
			arApPayment = PstArApPayment.fetchExc(paymentId);
		}catch(Exception e){}
	}
// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.setLanguage(SESS_LANGUAGE);
String strBack = "";
String strDelJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Journal Distribution" : "Hapus Jurnal Distribusi";
String strYesDelJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Journal Distribution" : "Ya Hapus Jurnal Distribusi";
String sAddJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Journal Distribution" : "Tambah Jurnal Distribusi";
String sBackToPayment = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Next Payment Proses" : "Pembayaran Selanjutnya";
String sSaveJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Journal Distribution" : "Simpan Jurnal Distribusi";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Journal Distribution" : "Ya Hapus Jurnal Distribusi";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String sDeleteQuestion = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure Want To Delete Journal Distribution Item?" : "Apakah Anda Yakin Ingin Menghapus Item Jurnal Distribusi?";
String strPrint = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Print Report" : "Cetak Laporan";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Payment" : "Hapus Pembayaran";
if(iCommand==Command.LIST){
    strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Report Search" : "Kembali Ke Pencarian Laporan";
}
else if(iCommand==Command.EDIT){
    strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Detail Report" : "Kembali Ke Laporan Detail";
}
else{
    strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Payment for other contact" : "Pembayaran untuk kontak selanjutnya";
}

if(session.getValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL_REPORT)!=null)
{
	srcArApReport = (SrcArApReport)session.getValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL_REPORT);
}

if(srcArApReport==null){
	srcArApReport = new SrcArApReport();
} 


session.putValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL_REPORT, srcArApReport);


    //System.out.println("--- Remove session error ---");
Vector listArApReport = new Vector();
Vector listArApPayment = new Vector();
Vector listArApItem = new Vector();
ArApDetailItem detail = new ArApDetailItem();
long mainId = 0;
long sellingId = 0;
long receiveId = 0;
int iErr = 0;

Vector vectSess = new Vector();

//if(iCommand==Command.ADD){
    switch(srcArApReport.getReportType()){ 
		case SessArApDetailReport.AR_PAYMENT :
            listArApReport = SessArApDetailReport.listArPaymentReport(srcArApReport);
            break;
		case SessArApDetailReport.AR_DETAIL :
            listArApReport = SessArApDetailReport.listArReport(srcArApReport);
            break;       
        case SessArApDetailReport.AP_PAYMENT :
            listArApReport = SessArApDetailReport.listApPaymentReport(srcArApReport);
            break;       
        case SessArApDetailReport.AP_DETAIL :
            listArApReport = SessArApDetailReport.listApReport(srcArApReport);
            break;
        default:
            break;
    }
   
    try{
    	session.removeValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL);
    }catch(Exception e){
    	System.out.println("--- Remove session error ---");
    }

    vectSess.add(srcArApReport);
    vectSess.add(listArApReport);
    session.putValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL, vectSess);

//}

long arapMainId = 0;


if(!listArApReport.isEmpty()){
        ArApDetail arap = (ArApDetail) listArApReport.get(index);
        detail = (ArApDetailItem) arap.getDetail().get(indexPay);
        String where = "";
        if(detail.getItemType()==SessArApDetailReport.TYPE_ARAP_MAIN){
            where = PstArApPayment.fieldNames[PstArApPayment.FLD_ARAP_MAIN_ID];
            arapMainId = detail.getMainId();
        }
        else if(detail.getItemType()==SessArApDetailReport.TYPE_RECEIVE_AKTIVA){
            where = PstArApPayment.fieldNames[PstArApPayment.FLD_RECEIVE_AKTIVA_ID];
            receiveId = detail.getMainId();
        }
        else if(detail.getItemType()==SessArApDetailReport.TYPE_SELLING_AKTIVA){
            where = PstArApPayment.fieldNames[PstArApPayment.FLD_SELLING_AKTIVA_ID];
            sellingId = detail.getMainId();
        }
        where = where + "=" + detail.getMainId();
        listArApPayment = PstArApPayment.list(0,0,where,PstArApPayment.fieldNames[PstArApPayment.FLD_PAYMENT_DATE]);
        listArApItem = PstArApItem.list(0,0,where,PstArApItem.fieldNames[PstArApItem.FLD_DUE_DATE]);
    }
	
// -------------------------------------------- JDistribution --------------------------------------------------------------
	
	ArApMain arApMain = new ArApMain();
	
	if(arapMainId != 0){
		try{			
				arApMain = PstArApMain.fetchExc(arapMainId);
		}catch(Exception e){}
	}
	
	if(paymentId == 0){
		paymentId = objJDistribution.getArapPaymentId();
	}
	
	String whClauseJD =	PstJournalDistribution.fieldNames[PstJournalDistribution.FLD_ARAP_MAIN_ID]+" = "+arapMainId +" AND "+
						PstJournalDistribution.fieldNames[PstJournalDistribution.FLD_ARAP_PAYMENT_ID]+" =  "+paymentId;
	Vector vJDistribution = arapMainId==0 ? new Vector() : PstJournalDistribution.list(0,0,whClauseJD,PstJournalDistribution.fieldNames[PstJournalDistribution.FLD_JOURNAL_DISTRIBUTION_ID]);
	Vector vBisnisCenter = PstBussinessCenter.list(0,0,"",PstBussinessCenter.fieldNames[PstBussinessCenter.FLD_BUSS_CENTER_NAME]);

	// get masterdata currency
	String sOrderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
	Vector vlistCurrencyType = PstCurrencyType.list(0, 0, "", sOrderBy);

	// get masterdata standart rate
	String sStRateWhereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS] + " = " + PstStandartRate.ACTIVE;
	String sStRateOrderBy = PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE] + 
						", " + PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE];
	Vector vlistRate = SessDailyRate.getDataCurrency();
	
	
	long periodId = PstPeriode.getCurrPeriodId();
	long accountId = arApPayment.getIdPerkiraanPayment();
	double dDebetVal = 0.0;
	double dKreditVal  = 0.0;
	Vector vListJournalDistribution = new Vector();
	if(iUseJournalDistribution == 1){
		vListJournalDistribution = (Vector) drawListJDistribution(iCommand,SESS_LANGUAGE,jDistributionId,frmJDistribution,
                        vJDistribution,vlistCurrencyType,vBisnisCenter,accountId,periodId,arapMainId,paymentId,arApPayment.getPaymentStatus(),
                        arApPayment.getAmount(),arApMain.getArApType(),jDetailId, approot);
	}
	
	String sListJDistribution = "";
	if(vListJournalDistribution != null && vListJournalDistribution.size() > 0){
		sListJDistribution = vListJournalDistribution.get(0).toString();
		dDebetVal = Double.parseDouble(vListJournalDistribution.get(1).toString());
		dKreditVal = Double.parseDouble(vListJournalDistribution.get(2).toString());
	}

// ----------------------------------------- End JDistribution -------------------------------------------------------------
%>
<%if(iCommand == Command.DELETE){%>
	<jsp:forward page="arap_detail_report.jsp">	
	<jsp:param name="command" value="<%=Command.EDIT%>"/>
	<jsp:param name="index" value="<%=index%>"/>
	<jsp:param name="index_pay" value="<%=indexPay%>"/>
	</jsp:forward>
<%
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript" src="../main/dsj_common.js"></script>
<script language="javascript">
var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";


function cmdBackToPayment(index){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.index.value=index;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.ADD%>";	
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_detail_report.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

//---------------------------------------- JDistribution --------------------------------------------------

function addNewJDistribution(){
	
    var prev = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
		
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.ADD%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="payment_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdSaveJDistribution(){
	var prev = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="payment_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdCancelJDistribution(){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="payment_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdEditJDistribution(oid){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.j_distribution_id.value=oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value="<%=Command.EDIT%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="payment_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdAskJDistribution(oid){
	var prev = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.j_distribution_id.value=oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.ASK%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="payment_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdDeleteJDistribution(oid){
	var prev = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.j_distribution_id.value=oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="payment_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function changeCurrTypeJDistribution()  
{ 
	var iCurrType = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_CURRENCY_ID]%>.value;
	switch(iCurrType)
	{
	<%
	if(vlistRate!=null && vlistRate.size()>0)
	{		
		for(int i=0; i<vlistRate.size(); i++)
		{
			DailyRate objDailyRate = (DailyRate) vlistRate.get(i); 		
	%>
		case "<%=objDailyRate.getCurrencyId()%>" :
			 document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_TRANS_RATE]%>.value = "<%=Formater.formatNumber(objDailyRate.getBuyingAmount(), "###")%>";
			 document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_STANDARD_RATE]%>.value = "<%=Formater.formatNumber(objDailyRate.getSellingAmount(), "###")%>";
			break;
	<%	
		}	
	}
	%>			
		default :
			document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_TRANS_RATE]%>.value = "<%=Formater.formatNumber(1, "###")%>";
			 document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_STANDARD_RATE]%>.value = "<%=Formater.formatNumber(1, "###")%>";
			break;
	}
}

function cmdClickBisnisCenter(oid)
{
    var prev = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;

	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.j_distribution_id.value=oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="payment_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function openJdAccount(){
                  
 coa=document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>.value;
var strUrl = "arap_coasearch_jdis.jsp?command=<%=Command.LIST%>"+"&account_group=0"+
			"&<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>"+"="+coa;
                        //alert(strUrl);
                         
   popcoa = window. open(strUrl,"src_account_jdetail","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
}

//-------------------------------------- End JDistribution ------------------------------------------------
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE][0]%> : <font color="#CC3300"><%=SessArApDetailReport.stReportType[SESS_LANGUAGE][srcArApReport.getReportType()].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->

            <form name="<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>" method="post" action="">
              <input type="hidden" name="arap_main_id" value="0">
              <input type="hidden" name="index" value="<%=index%>">
              <input type="hidden" name="index_pay" value="<%=indexPay%>">
              <input type="hidden" name="arap_type" value="<%=arapType%>">
              <input type="hidden" name="payment" value="<%=payment%>">
              <input type="hidden" name="command" value="<%=iCommand%>">
	      	  <input type="hidden" name="payment_id" value="<%=paymentId%>">
              <input type="hidden" name="j_distribution_id" value="<%=jDistributionId%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
			  <input type="hidden" name="j_detail_id" value="<%=jDetailId%>">
              <table width="75%" border="0">
              <tr>
                  <td width="14%">&nbsp;</td>
                  <td width="2%">
                    <div align="center"></div>
                </td>
                  <td width="84%">&nbsp;</td>
              </tr>
              <%if(iCommand != Command.LIST){
                  ArApDetail arap = new ArApDetail();
                  if(listArApReport.isEmpty()){
                      arap = new ArApDetail();
                  }
                  else{
                      arap = (ArApDetail) listArApReport.get(index);
                  }
              %>
              <tr>
                  <td width="14%"><b><%=strTitle[SESS_LANGUAGE][1]%></b></td>
                  <td width="2%"> 
                    <div align="center">:</div>
                </td>
                  <td width="84%"><input type="hidden" name="<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_CONTACT_ID]%>" value="<%=arap.getContactId()%>"><b><%=arap.getContactName()%></b></td>
              </tr>
              <%}%>
              <tr><b>
                  <td width="14%"><b><%=strTitle[SESS_LANGUAGE][4]%></b></td>
                  <td width="2%"> 
                    <div align="center">:</div>
                </td>
                  <td width="84%"><b><%=Formater.formatDate(srcArApReport.getFromDate(),"dd MMMMMM yyyy")%>
                  <% if(srcArApReport.getReportType()<SessArApDetailReport.AR_TODAY_DUE_DATE){ %>
                    &nbsp;<%=strTitle[SESS_LANGUAGE][11]%>&nbsp;<%=Formater.formatDate(srcArApReport.getUntilDate(),"dd MMMMMM yyyy")%></b></td>
                  <%}%>
              </b></tr>
            </table>
			<table width="100%" border="0">
				<tr>
					<td>
                		<%
						  FRMHandler objFRMHandler = new FRMHandler();
						  objFRMHandler.setDigitSeparator(sUserDigitGroup);
						  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);
						 
						  out.println(listDrawDetailReport(objFRMHandler,listArApReport,SESS_LANGUAGE,srcArApReport.getReportType(),index));
						  
						%>
					</td>
				</tr>
			</table>
    		<table width="75%" border="0">
              <tr>
                  <td height="20" class="contenttitle" ><%=strTitle[SESS_LANGUAGE][13]%>[<%=detail.getVoucherNo()%>]</td>
              </tr>
    		</table>
 				<%     
					ArApItem item = new ArApItem();
					
        			out.println(listDrawArApItem(SESS_LANGUAGE,listArApItem,detail.getDueDate(),item));
										
 				%>

 			<table width="100%" border="0">
              <tr>
                  <td height="20" class="contenttitle" ><%=strTitle[SESS_LANGUAGE][14]%>[<%=detail.getVoucherNo()%>]</td>
              </tr>
 			</table>
  				<%      
					out.println(listDrawArApPayment(objFRMHandler,listArApPayment,SESS_LANGUAGE,accountingBookType, item.getLeftToPay(),userOID, iCommand, paymentId)); 
				%>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>	
							
				 <tr> 
                  <td class="contenttitle" colspan="2"><%=strTitleJDistribution[SESS_LANGUAGE][10]%></td>
                </tr>
				<tr> 
                  <td colspan="2"><%=sListJDistribution%></td>
                </tr>
				<tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>	
				 <%if(iCommand == Command.ASK){%>
								  	<tr>
                                    <td colspan="6" class="msgquestion"><%=sDeleteQuestion%></td>
                                  </tr>	
								   <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
								  <%}%>		
				<tr> 
                  <td colspan="2">
				  	<%if(iCommand == Command.NONE || (iCommand == Command.SAVE && iJDErrorCode == 0) || iCommand == Command.DELETE){%>
						<a href="javascript:addNewJDistribution()" class="command"><%=sAddJDistribution%></a>
					<%}else{%>
						<%if(iCommand == Command.EDIT){%>
							<a href="javascript:cmdSaveJDistribution()" class="command"><%=sSaveJDistribution%></a> 
							| <a href="javascript:cmdAskJDistribution('<%=jDistributionId%>')" class="command"><%=strDelete%></a>
						<%}else{%>
							<%if(iCommand == Command.ASK){%>
								<a href="javascript:cmdDeleteJDistribution('<%=jDistributionId%>')" class="command"><%=strYesDelete%></a> 
								| <a href="javascript:cmdCancelJDistribution()" class="command"><%=strCancel%></a>
							<%}else{%>
								<%if(iCommand == Command.ADD && prevCommand == Command.ASK){%>	
									<a href="javascript:addNewJDistribution()" class="command"><%=sAddJDistribution%></a>		
								<%}else{%>										
									<a href="javascript:cmdSaveJDistribution()" class="command"><%=sSaveJDistribution%></a> 
								<%}%>
							<%}%>
						<%}%>
					<%}%>
					<%if((dDebetVal + dKreditVal) > 0 && iCommand != Command.EDIT && iCommand != Command.ASK){%>
						| <a href="javascript:cmdBackToPayment('<%=index%>')" class="command"><%=sBackToPayment%></a>
					<%}%>
				  </td>
                </tr>				
                <tr>
                  <td height="16" class="command" width="40%">&nbsp;</td>
				  <td height="16" class="command" width="88%">&nbsp;</td>
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
<%}%>
