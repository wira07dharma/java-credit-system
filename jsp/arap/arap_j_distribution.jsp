<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*,
                 com.dimata.aiso.form.arap.FrmArApMain,
                 com.dimata.interfaces.trantype.I_TransactionType,
                 com.dimata.aiso.entity.arap.ArApMain,
                 com.dimata.aiso.form.arap.CtrlArApMain,
				 com.dimata.aiso.entity.arap.ArApItem,
				 com.dimata.aiso.entity.arap.PstArApItem,
                 com.dimata.common.entity.contact.ContactList,
				 com.dimata.aiso.session.arap.SessArApEntry,
                 com.dimata.common.entity.contact.PstContactList,
                 com.dimata.aiso.entity.arap.PstArApMain" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.util.*" %>

<!--import qdep-->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<!--import common-->
<%@ page import="com.dimata.common.entity.payment.PstStandartRate" %>
<%@ page import="com.dimata.common.entity.payment.StandartRate,
				 com.dimata.common.entity.payment.CurrencyType,
                 com.dimata.common.entity.payment.PstCurrencyType" %>

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

<!--- For Journal Distbution --->
<%@ page import="com.dimata.aiso.entity.jurnal.JournalDistribution" %> 
<%@ page import="com.dimata.aiso.entity.jurnal.PstJournalDistribution" %> 
<%@ page import="com.dimata.aiso.session.jurnal.SessJurnal" %> 
<%@ page import="com.dimata.aiso.form.jurnal.FrmJournalDistribution" %>
<%@ page import="com.dimata.aiso.form.jurnal.CtrlJournalDistribution" %>
<%@ page import="com.dimata.aiso.session.masterdata.SessDailyRate"%>
<%@ page import="com.dimata.aiso.entity.periode.PstPeriode"%>

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


 public static String strTitle[][] =
 {
 	{
 		"Nomor Voucher",
         "Tanggal Voucher",
         "Nomor Nota",
         "Tanggal Nota",
         "Nama Kontak",
         "Mata Uang",
         "Kurs Standar",
         "Nominal",
         "Angsuran",
         "Perkiraan",
         "Perkiraan Lawan",
         "Keterangan",
         "Entry Angsuran",
         "Posting ke Jurnal",
         "Set semua angsuran",
         "Nilai Buku"
 	},
 	{
 		"Voucher Number",
         "Voucher Date",
         "Nota Number",
         "Nota Date",
         "Contact Name",
         "Currency",
         "Bookkeeping Rate",
         "Nominal",
         "Number of Payment",
         "Account",
         "Opposite Account",
         "Description",
         "Payment Term Entry",
         "Posted Journal",
         "Set all payment",
         "Book Value"
 	}
 };

public static String strTitleJDistribution[][] = {
	{//0                                                            //4                                                         //9
	"Input Jurnal Distribusi","Keterangan","Debet(Rp)","Kredit(Rp)","Mata Uang","Kurs(Rp)","Pusat Bisnis","Untuk","Catatan","Silahkan input debet atau kredit sesuai nilai mata uangnya. System seraca otomatis mengkonversi ke rupiah.","Daftar Journal Distribusi"," COA"
	},	
	
	{
	"Journal Distribution Entry","Remark","Debet(Rp)","Credit(Rp)","Currency","Rate(Rp)","Bussiness Center","For","Note","Please entry debit or credit amount in original currency. System will convert automatically to local currency.","List Journal Distribution","COA"
	}
};


 public static String strItemTitle[][] = {
 	{
 	"No","Angsuran","Tanggal Jatuh Tempo","Keterangan"
 	},

 	{
 	"No","Payment Amount","Due Date","Description"
 	}
 };

 public static final String masterTitle[] = {
 	"Input Data","Data Entry"
 };

 public static final String listTitle[][] = {
     {"Piutang","Receivable"},
     {"Hutang","Payable"}
 };


/**
* this method used to list jurnal detail
*/
public String drawList(int language, Vector objectClass,FrmJournalDistribution frmJournalDistribution,int arapMainStatus){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strItemTitle[language][0],"5%","center","right"); // no
	ctrlist.dataFormat(strItemTitle[language][1],"15%","center","right"); // angsuran
	ctrlist.dataFormat(strItemTitle[language][2],"20%","center","center"); // tanggal
	ctrlist.dataFormat(strItemTitle[language][3],"60%","center","left"); // keterangan

	Vector lstData = ctrlist.getData();
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
	int size = objectClass.size();
	for (int i = 0; i < size; i++) {

		ArApItem arApItem = (ArApItem)objectClass.get(i);

	rowx = new Vector();
        rowx.add(""+(i+1));
        if(arApItem.getAngsuran()==arApItem.getLeftToPay() && arapMainStatus != I_DocStatus.DOCUMENT_STATUS_POSTED){
                rowx.add("<a href=\"javascript:cmdEdit('"+arApItem.getOID()+"')\">"+frmJournalDistribution.userFormatStringDecimal(arApItem.getAngsuran())+"</a>");
        }
        else{
            rowx.add(frmJournalDistribution.userFormatStringDecimal(arApItem.getAngsuran()));
        }
        rowx.add(Formater.formatDate(arApItem.getDueDate(),"dd-MMM-yyyy"));
        rowx.add(arApItem.getDescription());

        lstData.add(rowx);
    }
	
    return ctrlist.drawMe(index);
}

public String cekNull(String val){
	if(val==null || val.length()==0)
		val = "-";
	return val;
}

public String mergeString(String name1, String name2){
	if(name1==null || name1.length()==0){
        if(name2==null || name2.length()==0){
            return "";
        }
        else{
            return name2;
        }
    }
    else{
        if(name2==null || name2.length()==0){
            return name1;
        }
        else{
            return name1 + " / " + name2;
        }
    }
}


//------------------------------------------------- J Distribution -----------------------------------------------------

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

public Vector drawListJDistribution(int iCommand, int language, long jDistributionId, FrmJournalDistribution frmJournalDistribution, Vector vJDistribution, Vector listCurrencyType, Vector vBisnisCenter, long jDAccountId, long periodeId, long arapMainId, long arapPaymentId, int posted,double amount, int arapType, String approot)
{
         Vector vResult = new Vector();
        String sResult = "";
        String sListOpening = "<table width=\"100%\" border=\"0\" class=\"listgen\" cellspacing=\"1\">";
        sListOpening = sListOpening + "<tr><td width=\"15%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][6] + "</div></td>";//2 Bisnis Center
        sListOpening = sListOpening + "<td width=\"15%\" class=\"listgentitle\"><div align=\"center\">" + strTitle[language][11] + "</div></td>";//11 COA
        sListOpening = sListOpening + "<td width=\"15%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][4] + "</div></td>";//3 Currency
        sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][5] + "</div></td>";//4 Rate
        sListOpening = sListOpening + "<td width=\"30%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][2] + "</div></td>";//5 Debet
        sListOpening = sListOpening + "<td width=\"30%\" class=\"listgentitle\"><div align=\"center\">" + strTitleJDistribution[language][3] + "</div></td></tr>";//6 Credit


        String sListClosing = "</table>";
        String sListContent = "";
        String accName = "";

        Vector currencytypeid_value = new Vector(1, 1);
        Vector currencytypeid_key = new Vector(1, 1);
        String selectedCurrType = "";
        double totDebet = 0.0;
        double totCredit = 0.0;

        if (listCurrencyType != null && listCurrencyType.size() > 0) {
            for (int it = 0; it < listCurrencyType.size(); it++) {
                CurrencyType currencyType = (CurrencyType) listCurrencyType.get(it);

                currencytypeid_key.add(currencyType.getName() + "(" + currencyType.getCode() + ")");
                currencytypeid_value.add("" + currencyType.getOID());
            }
        }

        Vector vBisnisCenterVal = new Vector();
        Vector vBisnisCenterKey = new Vector();
        String selectedBisnisCenter = "";
        if (vBisnisCenter.size() > 0) {
            for (int b = 0; b < vBisnisCenter.size(); b++) {
                BussinessCenter objBCenter = (BussinessCenter) vBisnisCenter.get(b);

                vBisnisCenterVal.add("" + objBCenter.getOID());
                vBisnisCenterKey.add(objBCenter.getBussCenterName());
            }
        }

        JournalDistribution jDistribution = new JournalDistribution();
        if (vJDistribution != null && vJDistribution.size() > 0) {
            // --- start proses content ---
            for (int it = 0; it < vJDistribution.size(); it++) {
                jDistribution = (JournalDistribution) vJDistribution.get(it);
                selectedBisnisCenter = "" + jDistribution.getBussCenterId();
                selectedCurrType = "" + jDistribution.getCurrencyId();

                String bisnisCenterName = "";
                if (jDistribution.getBussCenterId() != 0) {
                    try {
                        BussinessCenter bisnisCenter = PstBussinessCenter.fetchExc(jDistribution.getBussCenterId());
                        bisnisCenterName = bisnisCenter.getBussCenterName();
                    } catch (Exception e) {
                    }
                }

                Perkiraan coa = new Perkiraan();
                coa.setNama("NO COA, PLEASE FIX");
                if (jDistribution.getOID() != 0) {
                    try {
                        coa = PstPerkiraan.fetchExc(jDistribution.getIdPerkiraan());
                    } catch (Exception exc) {
                        System.out.println("erap_entry_edit : EXC" + exc);
                    }
                }

                String currName = "";
                CurrencyType currencyType = new CurrencyType();
                if (jDistribution.getCurrencyId() != 0) {
                    try {
                        currencyType = PstCurrencyType.fetchExc(jDistribution.getCurrencyId());
                        currName = currencyType.getName() + "(" + currencyType.getCode() + ")";
                    } catch (Exception e) {
                    }
                }

                System.out.println("jDistributionId = " + jDistributionId + ", jDistribution.getOID() = " + jDistribution.getOID());
                if (jDistributionId == jDistribution.getOID() && (iCommand == Command.EDIT || iCommand == Command.ASK)) {
                    sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">" +
                            ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_BUSS_CENTER_ID], null, selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey, "", "") + "</div>" +
                            "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ID_PERKIRAAN] + "\" size=\"15\" value=\"" + coa.getOID() + "\"> " +
                            "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_MAIN_ID] + "\" size=\"15\" value=\"" + arapMainId + "\"> " +
                            "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_PAYMENT_ID] + "\" size=\"15\" value=\"" + arapPaymentId + "\"> " +
                            "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_PERIODE_ID] + "\" size=\"15\" value=\"" + periodeId + "\"></td>";
                    
                    sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\"" + FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]+"\"" ;
                    sListContent = sListContent + "\" size=\"10\" value=\"" + coa.getNoPerkiraan() + "\" class=\"txtalign\">&nbsp; <a href=\"javascript:openJdAccount()\">";
                    sListContent = sListContent + "<img border=\"0\" src=\"" + approot + "/dtree/img/folderopen.gif\"></a>&nbsp;" +
                    "<input type=\"text\" name=\""+FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]+"\" readonly value=\"" + coa.getNama() + "\">" + "</div></td>";
                    
                    sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">" + ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CURRENCY_ID], null, selectedCurrType, currencytypeid_value, currencytypeid_key, "onChange=\"javascript:changeCurrTypeJDistribution()\"", "") + "</div></td>";
                    sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" readOnly name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_TRANS_RATE] + "\" size=\"10\" value=\"" + frmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate()) + "\" class=\"txtalign\"></div></td>" +
                            "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_STANDARD_RATE] + "\" value=\"" + frmJournalDistribution.userFormatStringDecimal(jDistribution.getStandardRate()) + "\">";
                    sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_DEBIT_AMOUNT] + "\" size=\"20\" value=\"" + frmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount()) + "\" class=\"txtalign\"></div></td>";
                    sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CREDIT_AMOUNT] + "\" size=\"20\" value=\"" + frmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount()) + "\" class=\"txtalign\"></div></td></tr>";
                    sListContent = sListContent + "<tr><td colspan=\"6\" class=\"listgensell\"><div align=\"left\"><b>" + strTitleJDistribution[language][1] + " : </b><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_NOTE] + "\" size=\"150\" value=\"" + jDistribution.getNote() + "\" ></div></td></tr>";

                } else {
                    if (posted == 0) {
                        sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"><a href=\"javascript:cmdClickBisnisCenter('" + jDistribution.getOID() + "')\">" + bisnisCenterName + "</a></div></td>";
                    } else {
                        sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\">" + bisnisCenterName + "</div></td>";
                    }
                    sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">" + coa.getNoPerkiraan() + " "+coa.getNama() + "</div></td>";
                    sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">" + currName + "</div></td>";
                    sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">" + frmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate()) + "</div></td>";
                    sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">" + frmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount()) + "&nbsp; (" + currencyType.getCode().toUpperCase() + " = " + frmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount() / jDistribution.getTransRate()) + ")</div></td>";
                    sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">" + frmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount()) + "&nbsp; (" + currencyType.getCode().toUpperCase() + " = " + frmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount() / jDistribution.getTransRate()) + ")</div></td></tr>";
                    sListContent = sListContent + "<tr><td colspan=\"6\" class=\"listgensell\"><div align=\"left\"><b>" + strTitleJDistribution[language][1] + " : </b>" + jDistribution.getNote() + "</div></td></tr>";

                }

                totDebet += jDistribution.getDebitAmount();
                totCredit += jDistribution.getCreditAmount();
            }

            // For second row and next  
            if (iCommand == Command.ADD) {
                sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">" + ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_BUSS_CENTER_ID], null, selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey, "", "") + "</div></td>" +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ID_PERKIRAAN] + "\" size=\"15\" value=\"" + "" + "\"> " +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_MAIN_ID] + "\" size=\"15\" value=\"" + arapMainId + "\"> " +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_PAYMENT_ID] + "\" size=\"15\" value=\"" + arapPaymentId + "\"> " +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_PERIODE_ID] + "\" size=\"15\" value=\"" + periodeId + "\"> ";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\"" + FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]+"\"" ;
                    sListContent = sListContent + "\" size=\"10\" value=\"" + "" + "\" class=\"txtalign\">&nbsp; <a href=\"javascript:openJdAccount()\">";
                    sListContent = sListContent + "<img border=\"0\" src=\"" + approot + "/dtree/img/folderopen.gif\"></a>&nbsp;" +
                    "<input type=\"text\" name=\""+FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]+"\" size=\"25\" readonly value=\"" + "" + "\">" + "</div></td>";
                  
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">" + ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CURRENCY_ID], null, selectedCurrType, currencytypeid_value, currencytypeid_key, "onChange=\"javascript:changeCurrTypeJDistribution()\"", "") + "</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" readOnly name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_TRANS_RATE] + "\" size=\"10\" value=\"" + frmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate()) + "\" class=\"txtalign\"></div></td>" +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_STANDARD_RATE] + "\" value=\"" + frmJournalDistribution.userFormatStringDecimal(jDistribution.getStandardRate()) + "\">";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_DEBIT_AMOUNT] + "\" size=\"20\" value=\"" + (arapType == 1 ? frmJournalDistribution.userFormatStringDecimal(amount - jDistribution.getDebitAmount()) : "0") + "\" class=\"txtalign\" </div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CREDIT_AMOUNT] + "\" size=\"20\" value=\"" + (arapType == 0 ? frmJournalDistribution.userFormatStringDecimal(amount - jDistribution.getCreditAmount()) : "0") + "\" class=\"txtalign\" </div></td></tr>";
                sListContent = sListContent + "<tr><td colspan=\"6\" class=\"tabtitlehidden\"><div align=\"left\"><b>" + strTitleJDistribution[language][1] + " : </b><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_NOTE] + "\" size=\"150\" value=\"\"></div></td></tr>";
            }
            sListContent += "<tr><td colspan=\"4\" class=\"tabtitlehidden\"><div align=\"right\"><b>TOTAL</b></div></td>";
            sListContent += "<td class=\"tabtitlehidden\"><div align=\"right\">" + frmJournalDistribution.userFormatStringDecimal(totDebet) + "</div></td>";
            sListContent += "<td class=\"tabtitlehidden\"><div align=\"right\">" + frmJournalDistribution.userFormatStringDecimal(totCredit) + "</div></td></tr>";
        } else {
            //Just first row
            if (iCommand == Command.ADD) {
                Perkiraan coa = new Perkiraan();
                coa.setNama("NO COA, PLEASE FIX");
                if (jDistribution.getOID() != 0) {
                    try {
                        coa = PstPerkiraan.fetchExc(jDAccountId);
                    } catch (Exception exc) {
                        System.out.println("erap_entry_edit : EXC" + exc);
                    }
                }
                
                
                
                sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">" + ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_BUSS_CENTER_ID], null, selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey, "", "") + "</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">" + ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CURRENCY_ID], null, selectedCurrType, currencytypeid_value, currencytypeid_key, "onChange=\"javascript:changeCurrTypeJDistribution()\"", "") +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ID_PERKIRAAN] + "\" size=\"15\" value=\"" + coa.getOID() + "\"> " +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_MAIN_ID] + "\" size=\"15\" value=\"" + arapMainId + "\"> " +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ARAP_PAYMENT_ID] + "\" size=\"15\" value=\"" + arapPaymentId + "\"> " +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_PERIODE_ID] + "\" size=\"15\" value=\"" + periodeId + "\"></div></td>";

                    sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\"" + FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]+"\"" ;
                    sListContent = sListContent + "\" size=\"10\" value=\"" + coa.getNoPerkiraan() + "\" class=\"txtalign\">&nbsp; <a href=\"javascript:openJdAccount()\">";
                    sListContent = sListContent + "<img border=\"0\" src=\"" + approot + "/dtree/img/folderopen.gif\"></a>&nbsp;" +
                    "<input type=\"text\" name=\""+FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]+"\" size=\"25\" readonly value=\"" + coa.getNama() + "\">" + "</div></td>";
                  
                    
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_TRANS_RATE] + "\" size=\"28\" readOnly value=\"" + frmJournalDistribution.userFormatStringDecimal(1) + "\" class=\"txtalign\">" +
                        "<input type=\"hidden\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_STANDARD_RATE] + "\" value=\"" + frmJournalDistribution.userFormatStringDecimal(1) + "\"></div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_DEBIT_AMOUNT] + "\" size=\"20\" value=\"" + (arapType == 1 ? frmJournalDistribution.userFormatStringDecimal(amount) : "0") + "\" class=\"txtalign\" </div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CREDIT_AMOUNT] + "\" size=\"20\" value=\"" + (arapType == 0 ? frmJournalDistribution.userFormatStringDecimal(amount) : "0") + "\" class=\"txtalign\" </div></td></tr>";
                sListContent = sListContent + "<tr><td colspan=\"6\" class=\"tabtitlehidden\"><div align=\"left\"><b>" + strTitleJDistribution[language][1] + " : </b><input type=\"text\" name=\"" + frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_NOTE] + "\" size=\"120\" value=\"\"></div></td></tr>";
            }
        }


        sResult = sListOpening + sListContent + sListClosing;
        vResult.add(sResult);
        vResult.add("" + totDebet);
        vResult.add("" + totCredit);
        return vResult;
    }

//-------------------------------------------------- End J Distribution ------------------------------------------------
%>
<!-- JSP Block -->

<%
/** Get value from hidden form */
showMenu = false;
replaceMenuWith = "";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidArApMain = FRMQueryString.requestLong(request,"arap_main_id");
int arapType = FRMQueryString.requestInt(request,"arap_type");
long arApItemId = FRMQueryString.requestLong(request,"arap_item_id");
int arapEdit = FRMQueryString.requestInt(request,"arapEdit");
int editDetail = FRMQueryString.requestInt(request,"edit_detail");
long jDistributionId = FRMQueryString.requestLong(request,"j_distribution_id");
int posted = FRMQueryString.requestInt(request,FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]);

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Plan Payment" : "Tambah Angsuran";
String strAddNewArap = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New "+PstArApMain.stTypeArAp[1][arapType] : "Tambah Angsuran";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Payment" : "Simpan Angsuran";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Journal Distribution" : "Hapus Jurnal Distribusi";
String strDeleteMain = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete "+PstArApMain.stTypeArAp[1][arapType] : "Hapus "+PstArApMain.stTypeArAp[0][arapType];
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Journal Distribution" : "Ya Hapus Jurnal Distribusi";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String sAddJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Journal Distribution" : "Tambah Jurnal Distribusi";
String sSaveJDistribution = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Journal Distribution" : "Simpan Jurnal Distribusi";
String sArapPaymentTerm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List Plan Payment" : "Daftar Angsuran";
String sPostedArap = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Posted Journal" : "Posting";
String sDeleteQuestion = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure Want To Delete Journal Distribution Item?" : "Apakah Anda Yakin Ingin Menghapus Item Jurnal Distribusi?";


if(iCommand==Command.NONE)
        iCommand = Command.ADD;

/*if(iCommand == Command.ADD)
		arApItemId = 0;*/

String strMenuType = "";
try{
	strMenuType = (String)session.getValue("MENU_TYPE");
}catch(Exception e){
	System.out.println("Exception on getMenuType from session ::: "+e.toString());
}

int menuType = 0;
if(strMenuType != null && strMenuType.length() > 0){
	menuType = Integer.parseInt(strMenuType);
}


/** Instansiasi object CtrlJournalDistribution and FrmJournalDistribution */
ControlLine ctrLine = new ControlLine();
CtrlJournalDistribution ctrlJDistribution = new CtrlJournalDistribution(request);
int iJDErrorCode = ctrlJDistribution.action(iCommand, jDistributionId);
FrmJournalDistribution frmJDistribution = ctrlJDistribution.getForm();
JournalDistribution objJDistribution = ctrlJDistribution.getJournalDistribution();
jDistributionId = objJDistribution.getOID();
String msgString = ctrlJDistribution.getMessage();

ArApMain arApMain = new ArApMain();
if(oidArApMain != 0){
	try{
		arApMain = PstArApMain.fetchExc(oidArApMain);
	}catch(Exception e){}
}

    ContactList contactList = new ContactList();
    try{
        contactList = PstContactList.fetchExc(arApMain.getContactId());
    }catch(Exception e){}
	
	
   // get list item dan sinkronisasi dengan main   
    int cnop = 0;
    double totAng = 0;
    boolean needUpdate = false;   
     String where = PstArApItem.fieldNames[PstArApItem.FLD_ARAP_MAIN_ID]+"="+oidArApMain+
            " AND "+PstArApItem.fieldNames[PstArApItem.FLD_SELLING_AKTIVA_ID]+" = 0 "+
            " AND "+PstArApItem.fieldNames[PstArApItem.FLD_RECEIVE_AKTIVA_ID]+" = 0 ";
    String order = PstArApItem.fieldNames[PstArApItem.FLD_DUE_DATE];
    Vector list = PstArApItem.list(0,0,where,order);	
   
	int iPosted = 0;
	if(posted!=0 && iCommand == Command.SAVE){
        SessArApEntry sessArApMain = new SessArApEntry();
       	iPosted = sessArApMain.postingArApMain(accountingBookType,userOID,currentPeriodOid,arApMain);
		iPosted = 1;
    }
	
	String whClauseJD = PstJournalDistribution.fieldNames[PstJournalDistribution.FLD_ARAP_MAIN_ID]+" = "+oidArApMain;
	Vector vJDistribution = oidArApMain==0 ? new Vector() : PstJournalDistribution.list(0,0,whClauseJD,PstJournalDistribution.fieldNames[PstJournalDistribution.FLD_JOURNAL_DISTRIBUTION_ID]);
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
	long accountId = arApMain.getIdPerkiraan();
	double dDebetVal = 0.0;
	double dKreditVal  = 0.0;
	Vector vListJournalDistribution = new Vector();
	if(iUseJournalDistribution == 1){
		vListJournalDistribution = (Vector) drawListJDistribution(iCommand,SESS_LANGUAGE,jDistributionId,frmJDistribution,vJDistribution,vlistCurrencyType,vBisnisCenter,accountId,periodId,oidArApMain,0,iPosted,arApMain.getAmount(),arapType, approot);
	}
	
	String sListJDistribution = "";
	if(vListJournalDistribution != null && vListJournalDistribution.size() > 0){
		sListJDistribution = vListJournalDistribution.get(0).toString();
		dDebetVal = Double.parseDouble(vListJournalDistribution.get(1).toString());
		dKreditVal = Double.parseDouble(vListJournalDistribution.get(2).toString());
	}
	// --------------------------- End Journal Distribution -----------------------
	
	
	
%>
<%if(iCommand == Command.SAVE && arapEdit == 1 && iPosted == 1){%>
    <jsp:forward page="arap_entry_list.jsp">
	<jsp:param name="command" value="<%=Command.LAST%>"/>
    </jsp:forward>
	<%}%>
	
	<%if(iCommand == Command.SAVE && arapEdit == 0 && iPosted == 1){%>
    <jsp:forward page="arap_entry_edit.jsp">
	<jsp:param name="command" value="<%=Command.NONE%>"/>
    </jsp:forward>
	<%}%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript" src="../main/dsj_common.js"></script>
<script language="JavaScript">
var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";


function openJdAccount(){
                  
 coa=document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>.value;
var strUrl = "arap_coasearch_jdis.jsp?command=<%=Command.LIST%>"+"&account_group=0"+
			"&<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>"+"="+coa;
                        //alert(strUrl);
                         
   popcoa = window. open(strUrl,"src_account_jdetail","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
}



function cmdAdd(){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.ADD%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value="<%=Command.ADD%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_entry_edit.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdEdit(oid){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.arap_item_id.value = oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value="<%=Command.EDIT%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_entry_detail.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdAddDetail(oid){
    document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.arap_main_id.value=oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=String.valueOf(Command.ADD)%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_entry_detail.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdBackMain(){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_entry_list.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.BACK%>";
function cmdBckMain(){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.BACK%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_entry_edit.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdSaveMain(oid){
    document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.arap_main_id.value = oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_entry_edit.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdPosted(){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]%>.value = "<%=I_DocStatus.DOCUMENT_STATUS_POSTED%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.posted_status.value="1";
	<%if(arapEdit == 1){%>
	    document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_entry_detail.jsp";
	<%}else{%>
	    document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_j_distribution.jsp";
	<%}%>
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function addNewJDistribution(){
	
    var prev = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
		
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.NONE%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdSaveJDistribution(){
	var prev = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdCancelJDistribution(){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdEditJDistribution(oid){
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.arap_j_distribution_id.value=oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value="<%=Command.EDIT%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdAskJDistribution(oid){
	var prev = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.arap_j_distribution_id.value=oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.ASK%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdDeleteJDistribution(oid){
	var prev = document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.arap_j_distribution_id.value=oid;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_j_distribution.jsp";
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
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="arap_j_distribution.jsp";
	document.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
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
            : <font color="#CC3300"><%=listTitle[arapType][SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="start" value="<%=start%>">
	      	  <input type="hidden" name="arapEdit" value="<%=arapEdit%>">
	      	  <input type="hidden" name="edit_detail" value="<%=editDetail%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_CONTACT_ID]%>" value="<%=arApMain.getContactId()%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_MAIN_STATUS]%>" value="<%=arApMain.getArApMainStatus()%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_DOC_STATUS]%>" value="<%=arApMain.getArApDocStatus()%>">
              <input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ARAP_MAIN_ID]%>" value="<%=oidArApMain%>">
              <input type="hidden" name="<%=FrmArApMain.fieldNames[FrmArApMain.FRM_ARAP_TYPE]%>" value="<%=arapType%>">
              <input type="hidden" name="arap_main_id" value="<%=oidArApMain%>">
			  <input type="hidden" name="arap_item_id" value="<%=arApItemId%>">
              <input type="hidden" name="j_distribution_id" value="<%=jDistributionId%>">
              <input type="hidden" name="posted_status" value="0">
              <input type="hidden" name="arap_type" value="<%=arapType%>">
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
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25"><%=cekNull(arApMain.getVoucherNo())%>
									</td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][6]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%=FrmJournalDistribution.userFormatStringDecimal(arApMain.getRate())%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][1]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<%=Formater.formatDate(arApMain.getVoucherDate(),"dd-MM-yyyy")%>
									</td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][7]%>&nbsp;/&nbsp;<%=strTitle[SESS_LANGUAGE][15]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%=FrmJournalDistribution.userFormatStringDecimal(arApMain.getAmount()/arApMain.getRate())%>
                                      &nbsp;/&nbsp;<%=FrmJournalDistribution.userFormatStringDecimal(arApMain.getAmount())%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25"><%=cekNull(arApMain.getNotaNo())%>
									</td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][8]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%=arApMain.getNumberOfPayment()%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][3]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									<%
                                        Date dtTransactionDate = arApMain.getNotaDate();
                                        if(dtTransactionDate ==null)
                                        {
                                            dtTransactionDate = new Date();
                                        }
                                        out.println(Formater.formatDate(dtTransactionDate,"dd-MM-yyyy"));
									%>
                                    </td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][9]+" "+listTitle[arapType][SESS_LANGUAGE]%>  </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                      <%
										Perkiraan perkiraanPayment = new Perkiraan();
										String namaPerkiraanPayment = "";
									   if(arApMain.getIdPerkiraan() > 0){
									   		try{
									   			perkiraanPayment = PstPerkiraan.fetchExc(arApMain.getIdPerkiraan());
												namaPerkiraanPayment = getAccName(SESS_LANGUAGE,perkiraanPayment);
											}catch(Exception e){}
									   }
									  %>
                                      <%=namaPerkiraanPayment%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][4]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25"><%=mergeString(contactList.getCompName(),contactList.getPersonName())%>
                                    </td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][10]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                    <%
										Perkiraan perkiraanLawan = new Perkiraan();
										String namaPerkiraanLawan = "";
									   if(arApMain.getIdPerkiraanLawan() > 0){
									   		try{
									   			perkiraanLawan = PstPerkiraan.fetchExc(arApMain.getIdPerkiraanLawan());
												namaPerkiraanLawan = getAccName(SESS_LANGUAGE,perkiraanLawan);
											}catch(Exception e){}
									   }
									  %>
                                      <%=namaPerkiraanLawan%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="18%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][5]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="32%" height="25">
									  <%
									  		CurrencyType currencyType = new CurrencyType();
											String sCurrency = "";
											if(arApMain.getIdCurrency() > 0){
												try{
													currencyType = PstCurrencyType.fetchExc(arApMain.getIdCurrency());
													sCurrency = currencyType.getName()+"("+currencyType.getCode()+")";
												}catch(Exception e){}
											}
									  %> 
									  <%=sCurrency%>
									  </td>
                                    <td width="21%" height="25" nowrap><%=strTitle[SESS_LANGUAGE][11]%> </td>
                                    <td width="1%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><%=cekNull(arApMain.getDescription())%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
								  <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
                                 <tr>
                                    <td colspan="6" class="contenttitle"><%=sArapPaymentTerm%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=drawList(SESS_LANGUAGE,list,frmJDistribution,arApMain.getArApMainStatus())%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><a href="javascript:cmdAddDetail('<%=oidArApMain%>')" class="command"><%=strAdd%></a></td>                                       
                                      </tr>	
									   <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>
								   <tr>
                                    <td colspan="6">&nbsp;</td>
                                  </tr>								 
								   <%if(vListJournalDistribution.size() > 0 && list.size() > 0 && oidArApMain != 0){%>
								  <tr>
                                    <td colspan="6" class="contenttitle"><%=strTitleJDistribution[SESS_LANGUAGE][10]%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="6"><%=sListJDistribution%></td>
                                  </tr>	
								   <tr>
                                    <td colspan="6" class="msginfo"><%=strTitleJDistribution[SESS_LANGUAGE][9]%></td>
                                  </tr>	
								   <tr>
                                    <td colspan="6">&nbsp;</td>
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
                                    <td colspan="6">
										
										<%if(iCommand == Command.NONE || (iCommand == Command.SAVE && arApMain.getArApDocStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED && iJDErrorCode == 0) || iCommand == Command.DELETE){%>
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
										<%if((dDebetVal + dKreditVal) > 0 && arApMain.getArApDocStatus()!=I_DocStatus.DOCUMENT_STATUS_POSTED && iCommand != Command.EDIT && iCommand != Command.ASK){%>
											| <a href="javascript:cmdAdd()" class="command"><%=strAddNewArap%></a>
											| <a href="javascript:cmdPosted()" class="command"><%=sPostedArap%></a>
										<%}%>
										<%if(arApMain.getArApDocStatus()==I_DocStatus.DOCUMENT_STATUS_POSTED){%>
											<a href="javascript:cmdAdd()" class="command"><%=strAddNewArap%></a>
										<%}%>
									</td>
                                  </tr>
								  <%}%>
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