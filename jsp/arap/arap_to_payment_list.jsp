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
        "No / No Inv",//24
	"Centang",//25
	"Payment Date",//26
	"Perkiraan"//27                                                                                 
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
        "No / Inv No",//24
	"Check",//25
	"Payment Date",//26  
	"Chart of Account"//27                                                                                   
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
    ,
    {"Daftar Piutang Detail",
	"Detail Receivable List"
    }
    ,
    {"Daftar Hutang Detail",
	"Detail Payable List"
    }
    ,
    {"Daftar Piutang Jatuh Tempo Sekarang",
	"Today Due Date Receivable List"
    }
    ,
    {"Daftar Hutang Jatuh Tempo Sekarang",
	"Today Due Date Payable List"
    }
    ,
    {"Daftar Piutang Jatuh Tempo Besok",
	"Tomorrow Due Date Receivable List"
    }
    ,
    {"Daftar Hutang Jatuh Tempo Besok",
	"Tomorrow Due Date Payable List"
    }
    ,
    {"Daftar Umur Piutang",
     "Receivabel Aging List"
    }
    ,
    {"Daftar Umur Hutang",
     "Payable Aging List"
    }
};

public static final String listDetailTitle[][] = {
    {
    " per Debitur",
    " per Debitor"
    },
    {
    " per Kreditur",
    " per Creditor"
    }
};


public boolean getTruedFalse(Vector vectInvoiceMainId, long lInvoiceId){
	for(int i=0;i<vectInvoiceMainId.size();i++){
		long lInvoiceIdSelect = Long.parseLong((String)vectInvoiceMainId.get(i));
		if(lInvoiceIdSelect == lInvoiceId)
			return true;
	}
	return false;
}

    // todo from here

public String listDrawArApReport(FRMHandler objFRMHandler, Vector list, int language, SrcArApReport src, int arapType, Vector vArapMainId)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
    	int type = src.getReportType();

   
    	// todo
        ctrlist.dataFormat(strTitle[language][0],"5%","2","0","center","right");
        ctrlist.dataFormat(strTitle[language][1],"25%","2","0","center","left");
        ctrlist.dataFormat(strTitle[language][2],"65%","0","4","center","center");
	ctrlist.dataFormat(strTitle[language][25],"5%","0","0","center","center");
        if(arapType == 0){
            ctrlist.dataFormat(strTitle[language][21]+" "+strTitle[language][24],"15%","0","0","center","left");
        }else{
            ctrlist.dataFormat(strTitle[language][22]+" "+strTitle[language][24],"15%","0","0","center","left"); 
        }
        ctrlist.dataFormat(strTitle[language][4],"10%","0","0","center","center");
        ctrlist.dataFormat(strTitle[language][5],"10%","0","0","center","center");
        ctrlist.dataFormat(strTitle[language][6],"10%","0","0","center","right");
        ctrlist.dataFormat(strTitle[language][7],"10%","2","0","center","right");
        ctrlist.dataFormat(strTitle[language][8],"15%","2","0","center","right");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");

        Vector lstData = ctrlist.getData();

        ctrlist.reset();
        int index = -1;
        try{
            int size = list.size();
            double total = 0;
            double totalPay = 0;
            for (int i=0; i < size; i++){                
                ArApDetail arApReport = (ArApDetail)list.get(i);
                Vector detail = arApReport.getDetail();
                for(int j=0;j<detail.size();j++){
                    Vector rowx = new Vector();
                    if(j==0){
                        rowx.add((i+1)+" ");
			if(size == 1){
                        	rowx.add(cekNull(arApReport.getContactName()));
			}else{
				rowx.add("<a href=\"javascript:cmdEdit(\'"+i+"\')\">"+cekNull(arApReport.getContactName())+"</a>");
			}
                    }else{
                        rowx.add(" ");
                        rowx.add(" ");
                    }
		    
		    String chk = "";
		    if(getTruedFalse(vArapMainId,item.getMainId())){
		 	chk = "checked";	
		     }
		
                    ArApDetailItem item = (ArApDetailItem) detail.get(j);
		    rowx.add("<input type=\"checkbox\" "+chk+" name=\"cb_"+j+"\" value=\""+item.getMainId()+"\"");	
		    if(size == 1){
		        rowx.add("<a href=\"javascript:cmdAddPayment(\'"+i+"\')\">"+item.getVoucherNo()+" / "+item.getNotaNo()+"</a>");
			}else{
			    rowx.add(item.getVoucherNo()+" / "+item.getNotaNo());
			}
                    rowx.add(Formater.formatDate(item.getVoucherDate(),"dd-MMM-yyyy"));
                    rowx.add(Formater.formatDate(item.getDueDate(),"dd-MMM-yyyy"));
                    rowx.add(FRMHandler.userFormatStringDecimal(item.getNominal()));
                    rowx.add(FRMHandler.userFormatStringDecimal(item.getPayed()));
                    rowx.add(FRMHandler.userFormatStringDecimal(item.getBalance()));
                    lstData.add(rowx);
                }
                total = total + arApReport.getTotalNominal();
                totalPay = totalPay + arApReport.getTotalPay();
                Vector rowx = new Vector();
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add("");
                rowx.add("");
                rowx.add("");
                rowx.add("");
                lstData.add(rowx);
                rowx = new Vector();
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add("<b>Sub Total</b>");
                rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApReport.getTotalNominal())+"</b>");
                rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApReport.getTotalPay())+"</b>");
                rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApReport.getTotalBalance())+"</b>");
                lstData.add(rowx);
                rowx = new Vector();
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add("");
                rowx.add("");
                rowx.add("");
                rowx.add("");
                lstData.add(rowx);
            }

            Vector rowx = new Vector();
            rowx.add(" ");
            rowx.add(" ");
            rowx.add(" ");
            rowx.add(" ");
            rowx.add("<b>TOTAL</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(total)+"</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(totalPay)+"</b>");
            rowx.add("<b>"+FRMHandler.userFormatStringDecimal(total-totalPay)+"</b>");
            lstData.add(rowx);
         }catch(Exception e){
            System.out.println("EXc : "+e.toString());
         }
    }

    return ctrlist.drawMeList();

}

    //todo
public String listDrawDetailReport(FRMHandler objFRMHandler, Vector list, int language, int type, int idx)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");


    if(type == SessArApDetailReport.AR_INCREASE || type==SessArApDetailReport.AP_INCREASE){
        ctrlist.dataFormat(strTitle[language][0],"5%","2","0","center","right");
        ctrlist.dataFormat(strTitle[language][2],"70%","0","5","center","center");
        ctrlist.dataFormat(strTitle[language][3],"15%","0","0","center","left");
        ctrlist.dataFormat(strTitle[language][4],"10%","0","0","center","center");
        ctrlist.dataFormat(strTitle[language][5],"10%","0","0","center","center");
        ctrlist.dataFormat(strTitle[language][6],"15%","0","0","center","right");
        ctrlist.dataFormat(strTitle[language][9],"20%","0","0","center","left");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");

        Vector lstData = ctrlist.getData();

        ctrlist.reset();
        int index = -1;
        try{
            if(idx<list.size()){
                System.out.println("ini yang ke "+idx);
                ArApDetail arApReport = (ArApDetail)list.get(idx);
                Vector detail = arApReport.getDetail();
                for(int j=0;j<detail.size();j++){
                    Vector rowx = new Vector();

                    rowx.add((j+1)+" ");

                    ArApDetailItem item = (ArApDetailItem) detail.get(j);
                    if(item.getItemType()!=SessArApDetailReport.TYPE_ORDER_AKTIVA){
                        rowx.add("<a href=\"javascript:cmdAddPayment(\'"+j+"\')\">"+item.getVoucherNo()+"</a>");
                    }
                    else{
                        rowx.add(item.getVoucherNo());
                    }
                    rowx.add(Formater.formatDate(item.getVoucherDate(),"dd-MMM-yyyy"));
                    rowx.add(Formater.formatDate(item.getDueDate(),"dd-MMM-yyyy"));
                    rowx.add(FRMHandler.userFormatStringDecimal(item.getNominal()));
                    rowx.add(item.getDescription());
                    lstData.add(rowx);
                }

                Vector rowx = new Vector();
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
                rowx.add(" ");
                lstData.add(rowx);
            }
         }catch(Exception e){
            System.out.println("EXc : "+e.toString());
         }

    }
    else if(type == SessArApDetailReport.AR_PAYMENT || type==SessArApDetailReport.AP_PAYMENT){
        ctrlist.dataFormat(strTitle[language][0],"5%","2","0","center","right");
        ctrlist.dataFormat(strTitle[language][2],"70%","0","3","center","center");
        ctrlist.dataFormat(strTitle[language][3],"15%","0","0","center","left");
        ctrlist.dataFormat(strTitle[language][4],"10%","0","0","center","center");
        ctrlist.dataFormat(strTitle[language][6],"15%","0","0","center","right");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");

        Vector lstData = ctrlist.getData();

        ctrlist.reset();
        int index = -1;
        try{
            if(idx<list.size()){                
                ArApDetail arApReport = (ArApDetail)list.get(idx);
                Vector detail = arApReport.getPayment();
                for(int j=0;j<detail.size();j++){
                    Vector rowx = new Vector();

                    rowx.add((j+1)+" ");

                    ArApDetailPayment item = (ArApDetailPayment) detail.get(j);
                    rowx.add(item.getPaymentNo());
                    rowx.add(Formater.formatDate(item.getPaymentDate(),"dd-MMM-yyyy"));
                    rowx.add(FRMHandler.userFormatStringDecimal(item.getNominal()));
                    lstData.add(rowx);
                }

                Vector rowx = new Vector();
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                rowx.add(" ");
                lstData.add(rowx);

                rowx = new Vector();
                rowx.add(" ");
                rowx.add(" ");
                rowx.add("<b>TOTAL</b>");
                rowx.add("<b>"+FRMHandler.userFormatStringDecimal(arApReport.getTotalPay())+"</b>");
                lstData.add(rowx);
            }
         }catch(Exception e){
            System.out.println("EXc : "+e.toString());
         }
    }
    else if(type >= SessArApDetailReport.AR_DETAIL && type < SessArApDetailReport.AR_AGING){
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
                    if(item.getItemType()!=SessArApDetailReport.TYPE_ORDER_AKTIVA){
                        rowx.add("<a href=\"javascript:cmdAddPayment(\'"+j+"\')\">"+item.getVoucherNo()+"</a>");
                    }
                    else{
                        rowx.add(item.getVoucherNo());
                    }
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
    try{
        int size = list.size();
        double total = 0;

        Hashtable hashCurr = new Hashtable();
        Vector currencytypeid_value = new Vector();
        Vector currencytypeid_key = new Vector();
        try{
            String where = PstCurrencyType.fieldNames[PstCurrencyType.FLD_INCLUDE_IN_PROCESS]+
                    "="+PstCurrencyType.INCLUDE;
            Vector vectCurr = PstCurrencyType.list(0,0,where,PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX]);

            for(int i=0; i<vectCurr.size(); i++){
                CurrencyType curr = (CurrencyType) vectCurr.get(i);
                hashCurr.put(curr.getOID()+"",curr);
                currencytypeid_value.add(curr.getCode());
                currencytypeid_key.add(""+curr.getOID());
            }
        }
        catch(Exception e){
            System.out.println("Err on get listCurr: "+e.toString());
        }
        
        Hashtable hashPer = new Hashtable();
        Vector vectPerVal = new Vector();
        Vector vectPerKey = new Vector();
        try{
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
            String where = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ACCOUNT_GROUP]+
                    " IN("+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS +", "+PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES+
                    ") AND "+ PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+
                    "="+PstPerkiraan.ACC_POSTED;
            String order = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];
            if(vDepartmentOid.size()>0){
                where = where +" AND (";

               for(int i = 0; i< vDepartmentOid.size(); i++){
                   where = where +PstPerkiraan.fieldNames[PstPerkiraan.FLD_DEPARTMENT_ID]+ " = "+(String) vDepartmentOid.get(i);
                   if(i<vDepartmentOid.size()-1){
                       where = where+" OR ";
                   }
               }
               where = where +")";
           }
            Vector vectPer = PstPerkiraan.list(0,0,where,order);
            for(int i=0; i<vectPer.size(); i++){
                Perkiraan per = (Perkiraan) vectPer.get(i);
                hashPer.put(per.getOID()+"",per);
                String padding = "";
                for(int j=0;j<per.getLevel();j++){
                    padding = padding + "&nbsp;&nbsp;&nbsp;";
                }
                vectPerVal.add(padding+per.getNoPerkiraan()+" "+per.getNama());
                vectPerKey.add(""+per.getOID());
            }
        }
        catch(Exception e){
            System.out.println("Err on get listCurr: "+e.toString());
        }

        for (int i=0; i < size; i++){


            ArApPayment arap = (ArApPayment)list.get(i);
            
	    if(arapPaymentId == arap.getOID()){
		index = i;
	    }

            Vector rowx = new Vector();
	    CurrencyType curr = (CurrencyType) hashCurr.get(arap.getIdCurrency()+"");
		if(curr==null){
		    curr = new CurrencyType();
		}
	    
	    Perkiraan per = (Perkiraan) hashPer.get(arap.getIdPerkiraanPayment()+"");
		if(per==null){
		    per = new Perkiraan();
		}
	    
	    
	    if(index == i && (iCommand==Command.EDIT || iCommand==Command.ASK)){ 
		rowx.add((i+1)+" ");
		rowx.add(arap.getPaymentNo());
		rowx.add(ControlDate.drawDate(FrmArApPayment.fieldNames[FrmArApPayment.FRM_PAYMENT_DATE],arap.getPaymentDate(),1,-2));
		rowx.add(ControlCombo.draw(FrmArApPayment.fieldNames[FrmArApPayment.FRM_ID_CURRENCY],null, currId+"", currencytypeid_key ,currencytypeid_value,  "onChange=\"javascript:cmdChangeCurr()\"", ""));
		rowx.add("<input type=\"text\" name=\"NOMINAL\" size=\"20\"  style=\"text-align:right\" onBlur=\"javascript:cmdNominal()\" value=\""+FRMHandler.userFormatStringDecimal(arap.getAmount()/arap.getRate())+"\">");
		rowx.add("<input type=\"text\" name=\""+FrmArApPayment.fieldNames[FrmArApPayment.FRM_RATE]+"\" size=\"12\"  readonly style=\"text-align:right\" value=\""+FrmArApPayment.userFormatStringDecimal(arap.getRate())+"\">");
		rowx.add("<input type=\"text\" name=\""+FrmArApPayment.fieldNames[FrmArApPayment.FRM_AMOUNT]+"\" size=\"20\" readonly style=\"text-align:right\" value=\""+FrmArApPayment.userFormatStringDecimal(arap.getAmount())+"\">");
		rowx.add(ControlCombo.draw(FrmArApPayment.fieldNames[FrmArApPayment.FRM_ID_PERKIRAAN_PAYMENT],null,"",vectPerKey,vectPerVal,"",""));

		lstData.add(rowx);	    
	    }else{
		rowx.add((i+1)+" ");
		rowx.add("<a href=\"javascript:cmdEditPayment(\'"+arap.getOID()+"\')\">"+arap.getPaymentNo()+"</a>");
		rowx.add(Formater.formatDate(arap.getPaymentDate(),"dd-MMM-yyyy"));		
		rowx.add(curr.getCode());
		rowx.add(FRMHandler.userFormatStringDecimal(arap.getAmount()/arap.getRate()));
		rowx.add(FRMHandler.userFormatStringDecimal(arap.getRate()));
		rowx.add(FRMHandler.userFormatStringDecimal(arap.getAmount()));		
		rowx.add(per.getNoPerkiraan()+" "+per.getNama());
		lstData.add(rowx);
	    }
        }

        Vector rowx = new Vector();
        Date today = new Date();
	   
	if(iCommand==Command.ADD){
        rowx.add((size+1)+" ");
        rowx.add("");
        rowx.add(ControlDate.drawDate(FrmArApPayment.fieldNames[FrmArApPayment.FRM_PAYMENT_DATE],today,1,-2));
        rowx.add(ControlCombo.draw(FrmArApPayment.fieldNames[FrmArApPayment.FRM_ID_CURRENCY],null, currId+"", currencytypeid_key ,currencytypeid_value,  "onChange=\"javascript:cmdChangeCurr()\"", ""));
        rowx.add("<input type=\"text\" name=\"NOMINAL\" size=\"20\"  style=\"text-align:right\" onBlur=\"javascript:cmdNominal()\" value=\""+FRMHandler.userFormatStringDecimal(currPay)+"\">");
        rowx.add("<input type=\"text\" name=\""+FrmArApPayment.fieldNames[FrmArApPayment.FRM_RATE]+"\" size=\"12\"  readonly style=\"text-align:right\" value=\""+FrmArApPayment.userFormatStringDecimal(1.0)+"\">");
        rowx.add("<input type=\"text\" name=\""+FrmArApPayment.fieldNames[FrmArApPayment.FRM_AMOUNT]+"\" size=\"20\" readonly style=\"text-align:right\" value=\""+FrmArApPayment.userFormatStringDecimal(currPay)+"\">");
        rowx.add(ControlCombo.draw(FrmArApPayment.fieldNames[FrmArApPayment.FRM_ID_PERKIRAAN_PAYMENT],null,"",vectPerKey,vectPerVal,"",""));

        lstData.add(rowx);
	}
     }catch(Exception e){
        System.out.println("EXc : "+e.toString());
     }


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
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int index = FRMQueryString.requestInt(request,"index");
int indexPay = FRMQueryString.requestInt(request,"index_pay");
int arapType = FRMQueryString.requestInt(request,"arap_type");
int payment = FRMQueryString.requestInt(request,"payment");
long paymentId = FRMQueryString.requestLong(request,"payment_id");

SrcArApReport srcArApReport = new SrcArApReport();
FrmSrcArApReport frmSrcArApReport = new FrmSrcArApReport(request);
frmSrcArApReport.requestEntityObject(srcArApReport);


// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.setLanguage(SESS_LANGUAGE);
String strBack = "";
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

if(iCommand == Command.ADD){
    paymentId = 0;
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

if(iCommand==Command.LIST){
    switch(srcArApReport.getReportType()){
        case SessArApDetailReport.AR_DETAIL :
            listArApReport = SessArApDetailReport.listArReport(srcArApReport);
            break;
        case SessArApDetailReport.AP_DETAIL :
            listArApReport = SessArApDetailReport.listApReport(srcArApReport);
            break;
        default:
            break;
    }
    String linkPdf = reportrootfooter+"report.arap.ArApDetailReportPdf";
    srcArApReport.setReportLink(linkPdf);
    srcArApReport.setLanguage(SESS_LANGUAGE);
    try{
    	session.removeValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL);
    }catch(Exception e){
    	System.out.println("--- Remove session error ---");
    }

    vectSess.add(srcArApReport);
    vectSess.add(listArApReport);

    session.putValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL, vectSess);

}
else if(iCommand==Command.EDIT){
    try{
    	vectSess = (Vector) session.getValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL);
    }catch(Exception e){
    	System.out.println("--- Get session error ---");
    }
    if(!vectSess.isEmpty()){
        listArApReport = (Vector) vectSess.get(1);
    }
    if(!listArApReport.isEmpty()){
        ArApDetail arap = (ArApDetail) listArApReport.get(index);
        detail = (ArApDetailItem) arap.getDetail().get(indexPay);
        String where = "";
        if(detail.getItemType()==SessArApDetailReport.TYPE_ARAP_MAIN){
            where = PstArApPayment.fieldNames[PstArApPayment.FLD_ARAP_MAIN_ID];
            mainId = detail.getMainId();
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
}
else if(iCommand==Command.ADD){
    try{
    	vectSess = (Vector) session.getValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL);
    }catch(Exception e){
    	System.out.println("--- Get session error ---");
    }
    if(!vectSess.isEmpty()){
        listArApReport = (Vector) vectSess.get(1);
    }
    if(!listArApReport.isEmpty()){
        ArApDetail arap = (ArApDetail) listArApReport.get(index);
        detail = (ArApDetailItem) arap.getDetail().get(indexPay);
        String where = "";
        if(detail.getItemType()==SessArApDetailReport.TYPE_ARAP_MAIN){
            where = PstArApPayment.fieldNames[PstArApPayment.FLD_ARAP_MAIN_ID];
            mainId = detail.getMainId();
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
}
else if(iCommand==Command.SUBMIT){
    try{
    	vectSess = (Vector) session.getValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL);
    }catch(Exception e){
    	System.out.println("--- Get session error ---");
    }
    if(!vectSess.isEmpty()){
        listArApReport = (Vector) vectSess.get(1);
    }
    if(!listArApReport.isEmpty()){
        ArApDetail arap = (ArApDetail) listArApReport.get(index);
        detail = (ArApDetailItem) arap.getDetail().get(indexPay);
        String where = "";
        if(detail.getItemType()==SessArApDetailReport.TYPE_ARAP_MAIN){
            where = PstArApPayment.fieldNames[PstArApPayment.FLD_ARAP_MAIN_ID];
            mainId = detail.getMainId();
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
    }
    ArApPayment arApPayment = new ArApPayment();
    FrmArApPayment frmArApPayment = new FrmArApPayment(request, arApPayment);
    frmArApPayment.requestEntityObject(arApPayment);
    if(paymentId == 0){
	iErr = SessArApEntry.postingArApPayment(accountingBookType,userOID,currentPeriodOid,arApPayment);
    }else{
	SessArApEntry.updateArapPayment(paymentId,arApPayment);
    }
}else if(iCommand == Command.DELETE){
    SessArApEntry.deleteArapPayment(paymentId);
    try{
    	vectSess = (Vector) session.getValue(SessArApDetailReport.SESS_SEARCH_ARAP_DETAIL);
    }catch(Exception e){
    	System.out.println("--- Get session error ---");
    }
    if(!vectSess.isEmpty()){
        listArApReport = (Vector) vectSess.get(1);
    }
    if(!listArApReport.isEmpty()){
        ArApDetail arap = (ArApDetail) listArApReport.get(index);
        detail = (ArApDetailItem) arap.getDetail().get(indexPay);
        String where = "";
        if(detail.getItemType()==SessArApDetailReport.TYPE_ARAP_MAIN){
            where = PstArApPayment.fieldNames[PstArApPayment.FLD_ARAP_MAIN_ID];
            mainId = detail.getMainId();
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
    
    iCommand = Command.ADD; 
}

Vector vArapMainId = new Vector();
if(iCommand == Command.POST){
	for(int i = 0; i < vListInvoice.size(); i++){
		String strArapMainId = request.getParameter("cb_"+i);
		if(strArapMainId != null && strArapMainId.length() > 0){
			vArapMainId.add(strArapMainId);
		}
	}
	
	
	if(vArapMainId != null && vArapMainId.size() > 0){
		for(int p = 0; p < vArapMainId.size(); p++){
			long lArapMainId = Long.parseLong(vArapMainId.get(p).toString());
			if(lArapMainId != 0){
				try{
					objInvoiceMain = PstInvoiceMain.fetchExc(lArapMainId);
				}catch(Exception e){}
			}
			ArApPayment arApPayment = new ArApPayment();
		        FrmArApPayment frmArApPayment = new FrmArApPayment(request, arApPayment);
		        frmArApPayment.requestEntityObject(arApPayment);
			iErr = SessArApEntry.postingArApPayment(accountingBookType,userOID,currentPeriodOid,arApPayment);
		        
			if(objInvoiceMain != null){
				try{
					iErr = SessArApEntry.postingArApPayment(accountingBookType,userOID,currentPeriodOid,arApPayment);
				}catch(Exception e){}
			}
		}
	}
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

function cmdBack(){
<% if(iCommand==Command.LIST){ %>
	document.frmsrcarapentry.command.value="<%=Command.BACK%>";
	document.frmsrcarapentry.action="arap_report_detail_search.jsp";
<% }else{ %>
    document.frmsrcarapentry.command.value="<%=Command.LIST%>";
    document.frmsrcarapentry.index.value="0";
    document.frmsrcarapentry.index_pay.value="0";
	document.frmsrcarapentry.action="arap_detail_report.jsp";
<% } %>
	document.frmsrcarapentry.submit();
}

function cmdEdit(idx){
	document.frmsrcarapentry.command.value="<%=Command.EDIT%>";
	document.frmsrcarapentry.index.value=idx;
	document.frmsrcarapentry.action="arap_detail_report.jsp";
	document.frmsrcarapentry.submit();
}

function cmdEditPayment(oid){
	document.frmsrcarapentry.payment_id.value=oid;
	document.frmsrcarapentry.command.value="<%=Command.EDIT%>";	
	document.frmsrcarapentry.action="arap_detail_report.jsp";
	document.frmsrcarapentry.submit();
}

function cmdDeletePayment(){
	document.frmsrcarapentry.command.value="<%=Command.DELETE%>";	
	document.frmsrcarapentry.action="arap_detail_report.jsp";
	document.frmsrcarapentry.submit();
}

function cmdAddPayment(idx){
	document.frmsrcarapentry.command.value="<%=Command.ADD%>";
    document.frmsrcarapentry.index_pay.value=idx;
	document.frmsrcarapentry.action="arap_detail_report.jsp";
	document.frmsrcarapentry.submit();
}

function cmdPostingPayment(){
	document.frmsrcarapentry.command.value="<%=Command.SUBMIT%>";
	document.frmsrcarapentry.action="arap_detail_report.jsp";
	document.frmsrcarapentry.submit();
}

function reportPdf(){
<% if(iCommand==Command.LIST){%>
		var linkPage = "<%=reportroot%>report.arap.ArApDetailReportPdf";
 <%}else{%>
        var linkPage = "<%=reportroot%>report.arap.ArApDetailPdf?index=<%=index%>";
 <%}%>
		window.open(linkPage);
}

function cmdChangeCurr(){
    var id = Math.abs(document.frmsrcarapentry.<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_ID_CURRENCY]%>.value);
    switch(id){
<%
           Vector currencytypeid_value = new Vector(1,1);
           Vector currencytypeid_key = new Vector(1,1);
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
        document.frmsrcarapentry.<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_RATE]%>.value="<%=FrmArApPayment.userFormatStringDecimal(rate)%>"
        break;
                    <%
                }
}
									  %>
    default :
        document.frmsrcarapentry.<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_RATE]%>.value="<%=FrmArApPayment.userFormatStringDecimal(1.0)%>"
        break;
    }
    cmdCurrency();
}

function cmdNominal(){
    var nom = parseFloat('0');
    var rate = parseFloat('0');
    var sNom = cleanNumberFloat(document.frmsrcarapentry.NOMINAL.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sNom)){
        nom = parseFloat(sNom);
    }
    var sRate = cleanNumberFloat(document.frmsrcarapentry.<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_RATE]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sRate)){
        rate = parseFloat(sRate);
    }
    document.frmsrcarapentry.<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_AMOUNT]%>.value=formatFloat((rate*nom), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
}

function cmdCurrency(){
    var nom = parseFloat('0');
    var rate = parseFloat('0');
    var sNom = cleanNumberFloat(document.frmsrcarapentry.<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_AMOUNT]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sNom)){
        nom = parseFloat(sNom);
    }
    var sRate = cleanNumberFloat(document.frmsrcarapentry.<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_RATE]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sRate)){
        rate = parseFloat(sRate);
    }
    document.frmsrcarapentry.NOMINAL.value=formatFloat((nom/rate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE][0]%> : <font color="#CC3300"><%=SessArApDetailReport.stReportType[SESS_LANGUAGE][srcArApReport.getReportType()].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->

            <form name="frmsrcarapentry" method="post" action="">
              <input type="hidden" name="arap_main_id" value="0">
              <input type="hidden" name="index" value="<%=index%>">
              <input type="hidden" name="index_pay" value="<%=indexPay%>">
              <input type="hidden" name="arap_type" value="<%=arapType%>">
              <input type="hidden" name="payment" value="<%=payment%>">
              <input type="hidden" name="command" value="<%=iCommand%>">
	      <input type="hidden" name="payment_id" value="<%=paymentId%>">
              <%
              if(iCommand!=Command.LIST){
              %>
              <input type="hidden" name="<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_ARAP_TYPE]%>" value="<%=arapType%>">
              <input type="hidden" name="<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_ARAP_MAIN_ID]%>" value="<%=mainId%>">
              <input type="hidden" name="<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_SELLING_AKTIVA_ID]%>" value="<%=sellingId%>">
              <input type="hidden" name="<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_RECEIVE_AKTIVA_ID]%>" value="<%=receiveId%>">
              <input type="hidden" name="<%=FrmArApPayment.fieldNames[FrmArApPayment.FRM_LEFT_TO_PAY]%>" value="<%=detail.getBalance()%>">
              <%}
              %>
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
                <%
    FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);
    if(iCommand==Command.LIST){
        if((listArApReport!=null)&&(!listArApReport.isEmpty())){
                  System.out.println("INI ARAP COUNT "+listArApReport.size());

				  out.println(listDrawArApReport(objFRMHandler,listArApReport,SESS_LANGUAGE,srcArApReport,arapType));
				 } else {%>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">				
                <tr> 
                  <td><span class="comment"><%=strTitle[SESS_LANGUAGE][10]%></span></td>
                </tr>
			  </table>
                <%
        }
    }
    else{
        out.println(listDrawDetailReport(objFRMHandler,listArApReport,SESS_LANGUAGE,srcArApReport.getReportType(),index));
    }
    if(iCommand==Command.ADD || iCommand == Command.EDIT){ %>
    <table width="75%" border="0">
              <tr>
                  <td height="20" class="contenttitle" ><%=strTitle[SESS_LANGUAGE][13]%>[<%=detail.getVoucherNo()%>]</td>
              </tr>
    </table>
 <%     ArApItem item = new ArApItem();
        out.println(listDrawArApItem(SESS_LANGUAGE,listArApItem,detail.getDueDate(),item));
 %>

 <table width="75%" border="0">
              <tr>
                  <td height="20" class="contenttitle" ><%=strTitle[SESS_LANGUAGE][14]%>[<%=detail.getVoucherNo()%>]</td>
              </tr>
 </table>
  <%      out.println(listDrawArApPayment(objFRMHandler,listArApPayment,SESS_LANGUAGE,accountingBookType, item.getLeftToPay(),userOID, iCommand, paymentId)); %>

  <%  }
                %>

              <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <%if(iCommand==Command.SUBMIT && iErr>0){ %>
                <tr> 
                  <td class="msgquestion" colspan="2"><%=CtrlJurnalUmum.resultText[SESS_LANGUAGE][iErr]%></td>
                </tr>
                <%}else{%>
                <tr>
                  <td  colspan="2"></td>
                </tr>
                <%}%>
                <tr>
                  <td height="16" class="command" width="40%">
                    <% if(iCommand==Command.ADD){%>
                    <a href="javascript:cmdPostingPayment()"><%=strTitle[SESS_LANGUAGE][12]%></a> 		    
                    <%}
		    else if(iCommand == Command.EDIT){%>
			<a href="javascript:cmdPostingPayment()"><%=strTitle[SESS_LANGUAGE][12]%></a>
			<%if(paymentId != 0){%>
			 | <a href="javascript:cmdDeletePayment()"><%=strDelete%></a>  
		    <%}%>                 
                    <%} else if(!listArApReport.isEmpty()){%>
                    <a href="javascript:reportPdf()"><%=strPrint%></a>
		    <%}%>
                  </td>
				  <td height="16" class="command" width="88%">
                  <a href="javascript:cmdBack()"><%=strBack%></a>
                  </td>
                </tr>
              </table>
            </form>
<%
    if(iCommand == Command.SUBMIT && iErr==0){
    %>
<script language="javascript">
    cmdAddPayment('<%=indexPay%>');
</script>
<%
    }
    else if(iCommand == Command.ADD){
%>
<script language="javascript">
    cmdChangeCurr();
</script>
<%}
    %>

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
