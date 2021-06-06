<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*,
                 com.dimata.util.lang.I_Language,
                 com.dimata.aiso.session.report.SessGeneralLedger,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.common.entity.contact.PstContactList,
                 com.dimata.harisma.entity.masterdata.PstDepartment,
                 com.dimata.harisma.entity.masterdata.Department" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.util.*" %>

<!--import qdep-->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<!--import common-->
<%@ page import="com.dimata.common.entity.payment.*" %>

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

public static String strTitle[][] = {
	{
	"No Voucher","Tanggal Transaksi","Tanggal Input","Transaksi Dalam","Keterangan Jurnal","Dokumen Referensi",
	"Nama Operator","Nomor","Nama Perkiraan","Debet","Kredit","Daftar Jurnal Detail","Tipe Pembukuan",
	"Mata Uang Lain", "Nilai Transaksi Asli", "Kurs Standar", "Nilai Buku",
	"Klik tombol <u>Mata Uang Lain</u> jika transaksi dilakukan dengan mata uang yang berbeda dengan tipe pembukuan ...",
    "Bobot(%)","TOTAL","Kontak","Departemen"
	},

	{
	"Voucher No","Transaction Date","Entry Date","Transaction In","Journal Description","Reference Document",
	"Operator Name","Account Group","Account Name","Debit","Credit","List Detail's Journal","Book Type",
	"Other Currency","Original Transaction Amount", "Standart Rate", "Book Type Amount",
	"Click <u>Other Currency</u> if original transaction's currency different to book type used ...",
    "Weight(%)","TOTAL","Contact","Department"
	}
};

public static final String masterTitle[] = {
	"Jurnal Umum","General Journal"
};

public static final String listTitle[] = {
	"Proses Jurnal","Journal Process"
};


/**
* this method used to list jurnal detail
*/
public String listJurnalDetail(int iCommand, int language, int index, FrmJurnalDetail frmjurnaldetail, Vector listjurnaldetail, Vector listCode, Vector listCurrencyType, long lSelectedBookTypeUsed, JurnalDetail jurnaldetail, boolean fromGL)
{
	String sResult = "";
	String sListOpening = "<table width=\"100%\" border=\"0\" class=\"listgen\" cellspacing=\"1\">";
    sListOpening = sListOpening + "<tr><td width=\"15%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][7]+"</div></td>";
	sListOpening = sListOpening + "<td width=\"65%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][8]+"</div></td>";
	sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][9]+"</div></td>";
	sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][10]+"</div></td></tr>";

    String sListClosing = "</table>";
	String sListContent = "";

	Hashtable hashCurrency = new Hashtable();
	Vector currencytypeid_value = new Vector(1,1);
	Vector currencytypeid_key = new Vector(1,1);
	if(listCurrencyType!=null && listCurrencyType.size()>0){
		int maxCurr = listCurrencyType.size();
		for(int it=0; it<maxCurr; it++){
			CurrencyType currencyType =(CurrencyType)listCurrencyType.get(it);
			currencytypeid_value.add(currencyType.getName()+"("+currencyType.getCode()+")");
			currencytypeid_key.add(""+currencyType.getOID());
			hashCurrency.put(""+currencyType.getOID(),currencyType.getCode());
		}
	}

	String attr = "onChange=\"parent.frames[0].cmdChangeAccount()\"";
	String attrChange = "onChange=\"parent.frames[0].cmdChange()\"";
    if(fromGL){
        attr = "onChange=\"javascript:cmdChangeAccount()\"";
	    attrChange = "onChange=\"javascript:cmdChange()\"";
    }
	String strSelect = "";

	if(listjurnaldetail!=null && listjurnaldetail.size()>0)	{
		// --- start proses content ---
		for(int it = 0; it<listjurnaldetail.size();it++){
			 JurnalDetail jdetail = (JurnalDetail)listjurnaldetail.get(it);
			 // if jd.datastatus!=DELETE ---> don't display it, otherwise ---> display it
			 if(jdetail.getDataStatus() != PstJurnalDetail.DATASTATUS_DELETE){
				 Vector listAccount = PstPerkiraan.findFieldPerkiraan(jdetail.getIdPerkiraan());
				 String namaAcc = "";
                 String kode = "";
				 int groupPerkiraan = 1;
				 boolean postableAcc = false;
				 if(listAccount!=null && listAccount.size()>0){
					Perkiraan account = (Perkiraan)listAccount.get(0);
					namaAcc = account.getNama();
                     kode = account.getNoPerkiraan();
					postableAcc = account.getPostable() == PstPerkiraan.ACC_POSTED ? true : false;
					groupPerkiraan = account.getAccountGroup();
					//groupPerkiraan = Integer.parseInt(account.getNoPerkiraan().substring(0,1));
				 }
				 strSelect = ""+ jdetail.getIdPerkiraan();
				 if(index!=jdetail.getIndex() || iCommand==Command.LIST || iCommand==Command.SUBMIT ||
                         iCommand==Command.DELETE){
                    if(fromGL){
                        sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\">"+ "<a href=\"javascript:cmdClickAccountJd('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">"+kode+"</a>" +"</div></td>";
                    }else{
				 	    sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\">"+ "<a href=\"javascript:parent.frames[0].cmdClickAccountJd('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">"+kode+"</a>" +"</div></td>";
                    }
                    sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ namaAcc +"</div></td>";
				 	sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(jdetail.getDebet()) +"</div></td>";
				 	sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(jdetail.getKredit()) +"</div></td></tr>";
                    if(jdetail.getDetailLinks().size()>0){
                         double totalWeight = jdetail.getWeight();
                         double totalDebet = jdetail.getDebet();
                         double totalKredit = jdetail.getKredit();
                         int size = jdetail.getDetailLinks().size();
                         for(int i=0;i<size;i++){
                             JurnalDetail dLink = jdetail.getDetailLink(i);

                             Perkiraan account = new Perkiraan();
                             try{
                                account = PstPerkiraan.fetchExc(dLink.getIdPerkiraan());
                             }catch(Exception e){
                                 account = new Perkiraan();
                             }

                             namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
                             totalWeight = totalWeight + dLink.getWeight();
                             totalDebet = totalDebet + dLink.getDebet();
                             totalKredit = totalKredit + dLink.getKredit();

                             sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"></div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ namaAcc+"</div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(dLink.getDebet()) +"</div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(dLink.getKredit()) +"</div></td></tr>";
                         }
                    }
				 }else{				 	
                    Perkiraan account = new Perkiraan();
                    if(jurnaldetail.getDebet()>0 || jurnaldetail.getKredit()>0 ){
                         jdetail = jurnaldetail;
                         try{
                            account = PstPerkiraan.fetchExc(jurnaldetail.getIdPerkiraan());
                         }
                         catch(Exception e){
                             System.out.println("ERR ON ADD");
                            account = new Perkiraan();
                         }
                        groupPerkiraan = account.getAccountGroup();
                        strSelect = ""+account.getOID();
                    }
                    namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
					String disableStatus = "";
					if(!postableAcc){
						disableStatus = "disabled=\"true\"";
					}

					if(lSelectedBookTypeUsed != jdetail.getCurrType()){
						disableStatus = "style=\"background-color:#E8E8E8;\" readonly";
					}
                     // ControlCombo.draw("ACCOUNT_GROUP",null,""+groupPerkiraan,vectVal,vectKey,attrChange)
                    // ControlCombo.draw(frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_IDPERKIRAAN],null,strSelect,accCodeKey,accCodeVal,attr)
				 	sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_IDPERKIRAAN]+"\" size=\"15\" value=\""+account.getOID()+"\"> " +
                             " <input type=\"text\" name=\"account_code\" size=\"15\" value=\""+account.getNoPerkiraan()+"\"><a href=\"javascript:openaccount()\">CHK</a>" +"</div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"text\" readonly name=\"account_name\" size=\"60\" value=\""+namaAcc+"\"></div></td>";					
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_TYPE]+"\" value=\""+jdetail.getCurrType()+"\"><input type=\"text\" name=\"DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(jdetail.getDebet()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebet()\"" + disableStatus + ">"+"</div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_AMOUNT]+"\" value=\""+jdetail.getCurrAmount()+"\"><input type=\"text\" name=\"KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(jdetail.getKredit()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeKredit()\"" + disableStatus + ">"+"</div></td></tr>";
					
					double dAmountTransaction = (jdetail.getDebet() > 0 ? jdetail.getDebet() : jdetail.getKredit());
					double dAmountInOriginalCurr = dAmountTransaction / jdetail.getCurrAmount();

				 	sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"2\">&nbsp;>>> " + strTitle[language][14] + " : " + hashCurrency.get(""+jdetail.getCurrType()) + "&nbsp;" + frmjurnaldetail.userFormatStringDecimal(dAmountInOriginalCurr) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][15] + " : " + frmjurnaldetail.userFormatStringDecimal(jdetail.getCurrAmount()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][16] + " : " + hashCurrency.get(""+lSelectedBookTypeUsed) + " " + frmjurnaldetail.userFormatStringDecimal(dAmountTransaction) + "</td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrency('" + jdetail.getCurrType() + "','" + jdetail.getCurrAmount() + "','" + jdetail.getDebet() + "','" + jdetail.getKredit() + "')\"><b>"+strTitle[language][13]+"</b></a>" +"</td></tr>";
				 }
			 }
		 }

		 if(iCommand==Command.ADD){
              System.out.println("\n\nHOREEEE\n");
             Perkiraan account = new Perkiraan();
             try{
                account = PstPerkiraan.fetchExc(jurnaldetail.getIdPerkiraan());
             }catch(Exception e){
                account = new Perkiraan();
             }

             String disableStatus = "";
             if(account.getPostable()!=PstPerkiraan.ACC_POSTED){
                disableStatus = "disabled=\"true\"";
             } // ControlCombo.draw(frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_IDPERKIRAAN],null,""+account.getOID(),accCodeKey,accCodeVal,attr)
			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_IDPERKIRAAN]+"\" size=\"15\" value=\"0\">" +
                    " <input type=\"text\" name=\"account_code\" size=\"15\" value=\"\"><a href=\"javascript:openaccount()\">CHK</a>" +"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"text\" readonly name=\"account_name\" size=\"60\" value=\"\">" +"</div></td>";
            sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_TYPE]+"\" value=\"" + lSelectedBookTypeUsed + "\"><input type=\"text\" name=\"DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(0)+" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebet()\" "+disableStatus+" >" +"</div></td>";
            sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_AMOUNT]+"\" value=\"1\"><input type=\"text\" name=\"KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(0)+" class=\"txtalign\" onBlur=\"javascript:cmdChangeKredit()\" "+disableStatus+" >" +"</div></td></tr>";

			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"2\">&nbsp;" + strTitle[language][17] + "</td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrency('0','0','0','0')\"><b>" + strTitle[language][13] + "</b></a>" +"</td></tr>";
		 }
		 // --- finish proses content ---
	}else{
        System.out.println("\n\nHOREEEE\n");
		 if(iCommand==Command.ADD){
             Perkiraan account = new Perkiraan();
             try{
                account = PstPerkiraan.fetchExc(jurnaldetail.getIdPerkiraan());
             }catch(Exception e){
                 System.out.println("ERR ON ADD");
                account = new Perkiraan();
             }
             String disableStatus = "";
             if(account.getPostable()!=PstPerkiraan.ACC_POSTED){
                disableStatus = "disabled=\"true\"";
             } // ControlCombo.draw(frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_IDPERKIRAAN],null,""+account.getOID(),accCodeKey,accCodeVal,attr)

			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_IDPERKIRAAN]+"\" size=\"15\" value=\"0\">" +
                    "<input type=\"text\" name=\"account_code\" size=\"15\" value=\"\"><a href=\"javascript:openaccount()\">CHK</a>" +"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"text\" readonly name=\"account_name\" size=\"60\" value=\"\">"+"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_TYPE]+"\" value=\"" + lSelectedBookTypeUsed + "\"><input type=\"text\" name=\"DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(0)+" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebet()\" "+disableStatus+" >" +"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_AMOUNT]+"\" value=\"1\"><input type=\"text\" name=\"KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(0)+" class=\"txtalign\" onBlur=\"javascript:cmdChangeKredit()\" "+disableStatus+" >" +"</div></td></tr>";

			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"2\">&nbsp;" + strTitle[language][17] + "</td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrency('0','0','0','0')\"><b>" + strTitle[language][13] + "</b></a>" +"</td></tr>";
		 }
	}

	sResult = sListOpening + sListContent + sListClosing;
	return sResult;
}

/**
* this method used to list jurnal detail with weight
*/
public String listJurnalDetailWithWeight(int iCommand, int language, int index, FrmJurnalDetail frmjurnaldetail, Vector listjurnaldetail, Vector listCode, Vector listCurrencyType, long lSelectedBookTypeUsed, JurnalDetail jurnaldetail, boolean fromGL)
{
	String sResult = "";
	String sListOpening = "<table width=\"100%\" border=\"0\" class=\"listgen\" cellspacing=\"1\">";
    sListOpening = sListOpening + "<tr><td width=\"15%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][7]+"</div></td>";
	sListOpening = sListOpening + "<td width=\"60%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][8]+"</div></td>";
    sListOpening = sListOpening + "<td width=\"5%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][18]+"</div></td>";
	sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][9]+"</div></td>";
	sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][10]+"</div></td></tr>";

    String sListClosing = "</table>";
	String sListContent = "";

	// list account code
	Vector accCodeKey = new Vector(1,1);
	Vector accCodeVal = new Vector(1,1);
	if(listCode!=null && listCode.size()>0){
		String space = "";
		String style = "";
		for(int i=0; i<listCode.size(); i++){
		   Perkiraan perkiraan = (Perkiraan)listCode.get(i);
		   switch(perkiraan.getLevel()){
			   case 1 : space = ""; break;
			   case 2 : space = "&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 3 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
			   case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
		   }
		   accCodeKey.add(""+perkiraan.getOID());
		   accCodeVal.add(space + perkiraan.getNoPerkiraan() + "&nbsp;&nbsp;&nbsp;&nbsp;"+perkiraan.getNama());
		 }
	}

	Vector vectVal = new Vector(1,1);
	Vector vectKey = new Vector(1,1);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_LIQUID_ASSETS]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_FIXED_ASSETS);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_FIXED_ASSETS]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_OTHER_ASSETS);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_OTHER_ASSETS]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_LONG_TERM_LIABILITIES);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_LONG_TERM_LIABILITIES]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_EQUITY);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_EQUITY]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_REVENUE);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_REVENUE]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_COST_OF_SALES);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_COST_OF_SALES]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_EXPENSE);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_EXPENSE]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_OTHER_REVENUE);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_OTHER_REVENUE]);
	vectVal.add(""+PstPerkiraan.ACC_GROUP_OTHER_EXPENSE);
	vectKey.add(""+PstPerkiraan.arrAccountGroupNames[0][PstPerkiraan.ACC_GROUP_OTHER_EXPENSE]);

	Hashtable hashCurrency = new Hashtable();
	Vector currencytypeid_value = new Vector(1,1);
	Vector currencytypeid_key = new Vector(1,1);
	if(listCurrencyType!=null && listCurrencyType.size()>0)
	{
		int maxCurr = listCurrencyType.size();
		for(int it=0; it<maxCurr; it++)
		{
			CurrencyType currencyType =(CurrencyType)listCurrencyType.get(it);
			currencytypeid_value.add(currencyType.getName()+"("+currencyType.getCode()+")");
			currencytypeid_key.add(""+currencyType.getOID());
			hashCurrency.put(""+currencyType.getOID(),currencyType.getCode());
		}
	}

	String attr = "onChange=\"parent.frames[0].cmdChangeAccount()\"";
	String attrChange = "onChange=\"parent.frames[0].cmdChange()\"";
     if(fromGL){
        attr = "onChange=\"javascript:cmdChangeAccount()\"";
	    attrChange = "onChange=\"javascript:cmdChange()\"";
    }
	String strSelect = "";

	if(listjurnaldetail!=null && listjurnaldetail.size()>0)
	{

		// --- start proses content ---
		for(int it = 0; it<listjurnaldetail.size();it++)
		{
			 JurnalDetail jdetail = (JurnalDetail)listjurnaldetail.get(it);

			 // if jd.datastatus!=DELETE ---> don't display it, otherwise ---> display it
			 if(jdetail.getDataStatus() != PstJurnalDetail.DATASTATUS_DELETE)
			 {
				 Vector listAccount = PstPerkiraan.findFieldPerkiraan(jdetail.getIdPerkiraan());
				 String namaAcc = "";
                 String kode = "";
				 int groupPerkiraan = 1;
				 boolean postableAcc = false;
				 if(listAccount!=null && listAccount.size()>0)
				 {
					Perkiraan account = (Perkiraan)listAccount.get(0);
					namaAcc = account.getNama();
                    kode = account.getNoPerkiraan();
					postableAcc = account.getPostable() == PstPerkiraan.ACC_POSTED ? true : false;
					groupPerkiraan = account.getAccountGroup();
					//groupPerkiraan = Integer.parseInt(account.getNoPerkiraan().substring(0,1));
				 }
				 strSelect = ""+ jdetail.getIdPerkiraan();

				 if(index!=jdetail.getIndex() || iCommand==Command.LIST || iCommand==Command.SUBMIT || iCommand==Command.DELETE)				 {
				 	sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\">"+ kode +"</div></td>";
                     if(fromGL){
                        sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ "<a href=\"javascript:cmdClickAccountJd('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">"+namaAcc+"</a>" +"</div></td>";
                     }else{
				 	    sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ "<a href=\"javascript:parent.frames[0].cmdClickAccountJd('"+groupPerkiraan+"','"+jdetail.getOID()+"','"+jdetail.getIdPerkiraan()+"','"+jdetail.getIndex()+"')\">"+namaAcc+"</a>" +"</div></td>";
                     }
                    sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(jdetail.getWeight()) +"</div></td>";
				 	sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(jdetail.getDebet()) +"</div></td>";
				 	sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(jdetail.getKredit()) +"</div></td></tr>";

                    if(jdetail.getDetailLinks().size()>0){
                         double totalWeight = jdetail.getWeight();
                         double totalDebet = jdetail.getDebet();
                         double totalKredit = jdetail.getKredit();
                         int size = jdetail.getDetailLinks().size();
                         for(int i=0;i<size;i++){
                             JurnalDetail dLink = jdetail.getDetailLink(i);

                             Perkiraan account = new Perkiraan();
                             try{
                                account = PstPerkiraan.fetchExc(dLink.getIdPerkiraan());
                             }
                             catch(Exception e){
                                account = new Perkiraan();
                             }

                             namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
                             totalWeight = totalWeight + dLink.getWeight();
                             totalDebet = totalDebet + dLink.getDebet();
                             totalKredit = totalKredit + dLink.getKredit();

                             sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"></div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ namaAcc+"</div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(dLink.getWeight()) +"</div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(dLink.getDebet()) +"</div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmjurnaldetail.userFormatStringDecimal(dLink.getKredit()) +"</div></td></tr>";

                         }
                    }
				 }else{
                    jdetail = jurnaldetail;
                    String disableStatus = "";
					String disableStatusDebet = "";
                    String disableStatusKredit = "";

                    if(lSelectedBookTypeUsed != jdetail.getCurrType()){
						disableStatus = "style=\"background-color:#E8E8E8;\" readonly";
                        disableStatusDebet = disableStatus;
                        disableStatusKredit = disableStatus;
					}

                    if(jdetail.getDebet()==0){
						disableStatusDebet = "disabled=\"true\"";
					}

                    if(jdetail.getKredit()==0){
						disableStatusKredit = "disabled=\"true\"";
					}
					 // ControlCombo.draw(frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_IDPERKIRAAN],null,strSelect,accCodeKey,accCodeVal,attr)

                    sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_IDPERKIRAAN]+"\" size=\"15\" value=\""+jdetail.getOID()+"\"> " +
                            " <input type=\"text\" name=\"account_code\" size=\"15\" value=\"\"><a href=\"javascript:openaccount()\">CHK</a></div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"text\" readonly name=\"account_name\" size=\"60\" value=\"\"></div></td>";
                    sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+"\" size=\"6\" value="+frmjurnaldetail.userFormatStringDecimal(jdetail.getWeight()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeWeight()\"" + disableStatus + ">"+"</div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_TYPE]+"\" value=\""+jdetail.getCurrType()+"\"><input type=\"text\" name=\"DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(jdetail.getDebet()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebetWeight()\"" + disableStatusDebet + ">"+"</div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_AMOUNT]+"\" value=\""+frmjurnaldetail.userFormatStringDecimal(jdetail.getCurrAmount())+"\"><input type=\"text\" name=\"KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(jdetail.getKredit()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeKreditWeight()\"" + disableStatusKredit + ">"+"</div></td></tr>";

                     if(jdetail.getDetailLinks().size()>0){
                         double totalWeight = jdetail.getWeight();
                         double totalDebet = jdetail.getDebet();
                         double totalKredit = jdetail.getKredit();
                         int size = jdetail.getDetailLinks().size();
                         for(int i=0;i<size;i++){
                             JurnalDetail dLink = jdetail.getDetailLink(i);
                             Perkiraan account = new Perkiraan();
                             try{
                                account = PstPerkiraan.fetchExc(dLink.getIdPerkiraan());
                             }catch(Exception e){
                                account = new Perkiraan();
                             }

                             namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
                             totalWeight = totalWeight + dLink.getWeight();
                             totalDebet = totalDebet + dLink.getDebet();
                             totalKredit = totalKredit + dLink.getKredit();

                             sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"></div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ namaAcc+"</div></td>";
                             sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+dLink.getIdPerkiraan()+"\" size=\"6\" value="+frmjurnaldetail.userFormatStringDecimal(dLink.getWeight()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeWeight"+dLink.getIdPerkiraan()+"()\"" + disableStatus + ">"+"</div></td>";
                             sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_TYPE]+dLink.getIdPerkiraan()+"\" value=\""+dLink.getCurrType()+"\"><input type=\"text\" name=\"DEBET"+dLink.getIdPerkiraan()+"\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(dLink.getDebet()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebet"+dLink.getIdPerkiraan()+"()\"" + disableStatusDebet + ">"+"</div></td>";
                             sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_AMOUNT]+dLink.getIdPerkiraan()+"\" value=\""+frmjurnaldetail.userFormatStringDecimal(dLink.getCurrAmount())+"\"><input type=\"text\" name=\"KREDIT"+dLink.getIdPerkiraan()+"\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(dLink.getKredit()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeKredit"+dLink.getIdPerkiraan()+"()\"" + disableStatusKredit + ">"+"</div></td></tr>";
                         }
                         sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"></div></td>";
                         sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+strTitle[language][19]+"</div></td>";
                         sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\"TOTAL_WEIGHT\" size=\"6\" value="+frmjurnaldetail.userFormatStringDecimal(totalWeight) +" class=\"txtalign\" style=\"background-color:#E8E8E8;\" readonly >"+"</div></td>";
                         sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\"TOTAL_DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(totalDebet) +" class=\"txtalign\" onBlur=\"javascript:cmdTotalDebet()\"" + disableStatus + ">"+"</div></td>";
                         sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\"TOTAL_KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(totalKredit) +" class=\"txtalign\" onBlur=\"javascript:cmdTotalKredit()\"" + disableStatus + ">"+"</div></td></tr>";

                         double dAmountTransaction = totalDebet > 0 ? totalDebet : totalKredit;
					     double dAmountInOriginalCurr = dAmountTransaction / jdetail.getCurrAmount();

				 	     sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"3\">&nbsp;>>> " + strTitle[language][14] + " : " + hashCurrency.get(""+jdetail.getCurrType()) + "&nbsp;" + frmjurnaldetail.userFormatStringDecimal(dAmountInOriginalCurr) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][15] + " : " + frmjurnaldetail.userFormatStringDecimal(jdetail.getCurrAmount()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][16] + " : " + hashCurrency.get(""+lSelectedBookTypeUsed) + " " + frmjurnaldetail.userFormatStringDecimal(dAmountTransaction) + "</td>";
				 	     sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrencyWithWeight('" + jdetail.getCurrType() + "','" + jdetail.getCurrAmount() + "','" + totalDebet + "','" + totalKredit + "')\"><b>"+strTitle[language][13]+"</b></a>" +"</td></tr>";

                     }else{
                        double dAmountTransaction = (jdetail.getDebet() > 0 ? jdetail.getDebet() : jdetail.getKredit());
					    double dAmountInOriginalCurr = dAmountTransaction / jdetail.getCurrAmount();

				 	    sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"3\">&nbsp;>>> " + strTitle[language][14] + " : " + hashCurrency.get(""+jdetail.getCurrType()) + "&nbsp;" + frmjurnaldetail.userFormatStringDecimal(dAmountInOriginalCurr) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][15] + " : " + frmjurnaldetail.userFormatStringDecimal(jdetail.getCurrAmount()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][16] + " : " + hashCurrency.get(""+lSelectedBookTypeUsed) + " " + frmjurnaldetail.userFormatStringDecimal(dAmountTransaction) + "</td>";
				 	    sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrency('" + jdetail.getCurrType() + "','" + jdetail.getCurrAmount() + "','" + jdetail.getDebet() + "','" + jdetail.getKredit() + "')\"><b>"+strTitle[language][13]+"</b></a>" +"</td></tr>";
                     }
				 }
			 }
		 }


		 if(iCommand==Command.ADD)
		 {
            Perkiraan account = new Perkiraan();
             try{
                account = PstPerkiraan.fetchExc(jurnaldetail.getIdPerkiraan());
             }
             catch(Exception e){
                account = new Perkiraan();
             } // ControlCombo.draw(frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_IDPERKIRAAN],null,""+account.getOID(),accCodeKey,accCodeVal,attr)
              String namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
                sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_IDPERKIRAAN]+"\" size=\"15\" value=\"0\">" +
                        " <input type=\"text\" name=\"account_code\" size=\"15\" value=\"\"><a href=\"javascript:openaccount()\">CHK</a>" +"</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ "<input type=\"text\" name=\"account_name\" size=\"60\" readonly value="+namaAcc+">"+"</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+"\" size=\"6\" value="+frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getWeight()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeWeight()\">"+"</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_TYPE]+"\" value=\"" + lSelectedBookTypeUsed + "\"><input type=\"text\" name=\"DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getDebet())+" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebetWeight()\" "+(jurnaldetail.getDebet()==0?"readonly":"")+" >" +"</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_AMOUNT]+"\" value=\"1\"><input type=\"text\" name=\"KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getKredit())+" class=\"txtalign\" onBlur=\"javascript:cmdChangeKreditWeight()\" "+(jurnaldetail.getKredit()==0?"readonly":"")+">" +"</div></td></tr>";

                if(jurnaldetail.getDetailLinks().size()>0){
                         double totalWeight = jurnaldetail.getWeight();
                         double totalDebet = jurnaldetail.getDebet();
                         double totalKredit = jurnaldetail.getKredit();
                         int size = jurnaldetail.getDetailLinks().size();
                         for(int i=0;i<size;i++){
                             JurnalDetail dLink = jurnaldetail.getDetailLink(i);

                             account = new Perkiraan();
                             try{
                                account = PstPerkiraan.fetchExc(dLink.getIdPerkiraan());
                             }
                             catch(Exception e){
                                account = new Perkiraan();
                             }

                             namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
                             totalWeight = totalWeight + dLink.getWeight();
                             totalDebet = totalDebet + dLink.getDebet();
                             totalKredit = totalKredit + dLink.getKredit();

                             sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"></div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ namaAcc+"</div></td>";
                             sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+dLink.getIdPerkiraan()+"\" size=\"60\" value="+frmjurnaldetail.userFormatStringDecimal(dLink.getWeight()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeWeight"+dLink.getIdPerkiraan()+"()\">"+"</div></td>";
                             sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_TYPE]+dLink.getIdPerkiraan()+"\" value=\""+dLink.getCurrType()+"\"><input type=\"text\" name=\"DEBET"+dLink.getIdPerkiraan()+"\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(dLink.getDebet()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebet"+dLink.getIdPerkiraan()+"()\" "+(dLink.getDebet()==0?"readonly":"")+" >"+"</div></td>";
                             sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_AMOUNT]+dLink.getIdPerkiraan()+"\" value=\"1\"><input type=\"text\" name=\"KREDIT"+dLink.getIdPerkiraan()+"\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(dLink.getKredit()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeKredit"+dLink.getIdPerkiraan()+"()\" "+(dLink.getKredit()==0?"readonly":"")+">"+"</div></td></tr>";
                         }

                         sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"></div></td>";
                         sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+strTitle[language][19]+"</div></td>";
                         sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\"TOTAL_WEIGHT\" size=\"6\" value="+frmjurnaldetail.userFormatStringDecimal(totalWeight) +" class=\"txtalign\" style=\"background-color:#E8E8E8;\" readonly>"+"</div></td>";
                         sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\"TOTAL_DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(totalDebet) +" class=\"txtalign\" onBlur=\"javascript:cmdTotalDebet()\">"+"</div></td>";
                         sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\"TOTAL_KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(totalKredit) +" class=\"txtalign\" onBlur=\"javascript:cmdTotalKredit()\">"+"</div></td></tr>";

                         double dAmountTransaction = totalDebet > 0 ? totalDebet : totalKredit;
					     double dAmountInOriginalCurr = dAmountTransaction / jurnaldetail.getCurrAmount();

				 	     sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"2\">&nbsp;>>> " + strTitle[language][14] + " : " + hashCurrency.get(""+jurnaldetail.getCurrType()) + "&nbsp;" + frmjurnaldetail.userFormatStringDecimal(dAmountInOriginalCurr) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][15] + " : " + frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getCurrAmount()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][16] + " : " + hashCurrency.get(""+lSelectedBookTypeUsed) + " " + frmjurnaldetail.userFormatStringDecimal(dAmountTransaction) + "</td>";
				 	     sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrencyWithWeight('" + jurnaldetail.getCurrType() + "','" + jurnaldetail.getCurrAmount() + "','" + totalDebet + "','" + totalKredit + "')\"><b>"+strTitle[language][13]+"</b></a>" +"</td></tr>";

                     }
                     else{
                        double dAmountTransaction = (jurnaldetail.getDebet() > 0 ? jurnaldetail.getDebet() : jurnaldetail.getKredit());
					    double dAmountInOriginalCurr = dAmountTransaction / jurnaldetail.getCurrAmount();

				 	    sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"3\">&nbsp;>>> " + strTitle[language][14] + " : " + hashCurrency.get(""+jurnaldetail.getCurrType()) + "&nbsp;" + frmjurnaldetail.userFormatStringDecimal(dAmountInOriginalCurr) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][15] + " : " + frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getCurrAmount()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][16] + " : " + hashCurrency.get(""+lSelectedBookTypeUsed) + " " + frmjurnaldetail.userFormatStringDecimal(dAmountTransaction) + "</td>";
				 	    sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrency('" + jurnaldetail.getCurrType() + "','" + jurnaldetail.getCurrAmount() + "','" + jurnaldetail.getDebet() + "','" + jurnaldetail.getKredit() + "')\"><b>"+strTitle[language][13]+"</b></a>" +"</td></tr>";
               }
		 }
		 // --- finish proses content ---
	}else{
		 if(iCommand==Command.ADD){
			Perkiraan account = new Perkiraan();
             try{
                account = PstPerkiraan.fetchExc(jurnaldetail.getIdPerkiraan());
             }catch(Exception e){
                account = new Perkiraan();
             } // ControlCombo.draw(frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_IDPERKIRAAN],null,""+account.getOID(),accCodeKey,accCodeVal,attr) ' combo aiso perkiraan
                sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_IDPERKIRAAN]+"\" size=\"15\" value=\"0\">" +
                        "<input type=\"text\" name=\"account_code\" size=\"15\" value=\"\">&nbsp;<a href=\"javascript:openaccount()\">CHK</a>" +"</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+"<input type=\"text\" name=\"account_name\" size=\"60\" value="+account.getOID()+">"+"</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+"\" size=\"6\" value="+frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getWeight()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeWeight()\">"+"</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_TYPE]+"\" value=\"" + lSelectedBookTypeUsed + "\"><input type=\"text\" name=\"DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getDebet())+" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebetWeight()\" "+(jurnaldetail.getDebet()==0?"readonly":"")+" >" +"</div></td>";
                sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+frmjurnaldetail.fieldNames[frmjurnaldetail.FRM_CURR_AMOUNT]+"\" value=\"1\"><input type=\"text\" name=\"KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getKredit())+" class=\"txtalign\" onBlur=\"javascript:cmdChangeKreditWeight()\" "+(jurnaldetail.getKredit()==0?"readonly":"")+" >" +"</div></td></tr>";

                if(jurnaldetail.getDetailLinks().size()>0){
                         double totalWeight = jurnaldetail.getWeight();
                         double totalDebet = jurnaldetail.getDebet();
                         double totalKredit = jurnaldetail.getKredit();
                         int size = jurnaldetail.getDetailLinks().size();
                         for(int i=0;i<size;i++){
                             JurnalDetail dLink = jurnaldetail.getDetailLink(i);

                             account = new Perkiraan();
                             try{
                                account = PstPerkiraan.fetchExc(dLink.getIdPerkiraan());
                             }
                             catch(Exception e){
                                account = new Perkiraan();
                             }

                             String namaAcc = language==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? account.getAccountNameEnglish() : account.getNama();
                             totalWeight = totalWeight + dLink.getWeight();
                             totalDebet = totalDebet + dLink.getDebet();
                             totalKredit = totalKredit + dLink.getKredit();

                             sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"></div></td>";
                             sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ namaAcc+"</div></td>";
                             sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+dLink.getIdPerkiraan()+"\" size=\"60\" value="+frmjurnaldetail.userFormatStringDecimal(dLink.getWeight()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeWeight"+dLink.getIdPerkiraan()+"()\">"+"</div></td>";
                             sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_TYPE]+dLink.getIdPerkiraan()+"\" value=\""+dLink.getCurrType()+"\"><input type=\"text\" name=\"DEBET"+dLink.getIdPerkiraan()+"\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(dLink.getDebet()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeDebet"+dLink.getIdPerkiraan()+"()\" "+(dLink.getDebet()==0?"readonly":"")+">"+"</div></td>";
                             sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"hidden\" name=\""+FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_CURR_AMOUNT]+dLink.getIdPerkiraan()+"\" value=\"1\"><input type=\"text\" name=\"KREDIT"+dLink.getIdPerkiraan()+"\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(dLink.getKredit()) +" class=\"txtalign\" onBlur=\"javascript:cmdChangeKredit"+dLink.getIdPerkiraan()+"()\" "+(dLink.getKredit()==0?"readonly":"")+">"+"</div></td></tr>";

                         }
                         sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\"></div></td>";
                         sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+strTitle[language][19]+"</div></td>";
                         sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\"TOTAL_WEIGHT\" size=\"6\" value="+frmjurnaldetail.userFormatStringDecimal(totalWeight) +" class=\"txtalign\" style=\"background-color:#E8E8E8;\" readonly>"+"</div></td>";
                         sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\"TOTAL_DEBET\" size=\"12\" value="+frmjurnaldetail.userFormatStringDecimal(totalDebet) +" class=\"txtalign\" onBlur=\"javascript:cmdTotalDebet()\">"+"</div></td>";
                         sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\">"+ "<input type=\"text\" name=\"TOTAL_KREDIT\" size=\"12\"  value="+frmjurnaldetail.userFormatStringDecimal(totalKredit) +" class=\"txtalign\" onBlur=\"javascript:cmdTotalKredit()\">"+"</div></td></tr>";

                         double dAmountTransaction = totalDebet > 0 ? totalDebet : totalKredit;
					     double dAmountInOriginalCurr = dAmountTransaction / jurnaldetail.getCurrAmount();

				 	     sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"3\">&nbsp;>>> " + strTitle[language][14] + " : " + hashCurrency.get(""+jurnaldetail.getCurrType()) + "&nbsp;" + frmjurnaldetail.userFormatStringDecimal(dAmountInOriginalCurr) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][15] + " : " + frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getCurrAmount()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][16] + " : " + hashCurrency.get(""+lSelectedBookTypeUsed) + " " + frmjurnaldetail.userFormatStringDecimal(dAmountTransaction) + "</td>";
				 	     sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrencyWithWeight('" + jurnaldetail.getCurrType() + "','" + jurnaldetail.getCurrAmount() + "','" + totalDebet + "','" + totalKredit + "')\"><b>"+strTitle[language][13]+"</b></a>" +"</td></tr>";

                     }
                     else{
                        double dAmountTransaction = (jurnaldetail.getDebet() > 0 ? jurnaldetail.getDebet() : jurnaldetail.getKredit());
					    double dAmountInOriginalCurr = dAmountTransaction / jurnaldetail.getCurrAmount();

				 	    sListContent = sListContent + "<tr><td class=\"tabtitlehidden\" colspan=\"2\">&nbsp;>>> " + strTitle[language][14] + " : " + hashCurrency.get(""+jurnaldetail.getCurrType()) + "&nbsp;" + frmjurnaldetail.userFormatStringDecimal(dAmountInOriginalCurr) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][15] + " : " + frmjurnaldetail.userFormatStringDecimal(jurnaldetail.getCurrAmount()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>> " + strTitle[language][16] + " : " + hashCurrency.get(""+lSelectedBookTypeUsed) + " " + frmjurnaldetail.userFormatStringDecimal(dAmountTransaction) + "</td>";
				 	    sListContent = sListContent + "<td class=\"tabtitlehidden\" colspan=\"2\" align=\"center\">"+ "<a href=\"javascript:editForOtherCurrency('" + jurnaldetail.getCurrType() + "','" + jurnaldetail.getCurrAmount() + "','" + jurnaldetail.getDebet() + "','" + jurnaldetail.getKredit() + "')\"><b>"+strTitle[language][13]+"</b></a>" +"</td></tr>";
               }
		 }
	}

	sResult = sListOpening + sListContent + sListClosing;
	return sResult;
}

public String drawListTotal(FrmJurnalDetail frmjurnaldetail, String strMessage, double debet, double kredit){
	String result = "<table width=\"100%\"><tr><td>"+
						"<table width=\"100%\" border=\"0\" cellspacing=\"1\">"+
							"<tr>"+
								"<td width=\"80%\" class=\"msgbalance\">"+
									"<div align=\"left\" ID=msgPostable><i>"+strMessage+"</i></div>"+
								"</td>"+
								"<td width=\"10%\" class=\"listgenTitle\">"+
									"<div align=\"right\">"+frmjurnaldetail.userFormatStringDecimal(debet)+"</div>"+
								"</td>"+
								"<td width=\"10%\" class=\"listgenTitle\">"+
									"<div align=\"right\">"+frmjurnaldetail.userFormatStringDecimal(kredit)+"</div>"+
								"</td>"+
							"</tr>"+
						"</table>"+
						"</td></tr></table>";
	return result;
}
%>
<!-- JSP Block -->

<%
/** Get value from hidden form */
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "COMPLETE JOURNAL PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES JURNAL SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long journalID = FRMQueryString.requestLong(request,"journal_id");
long detailID = FRMQueryString.requestLong(request,"detail_id");
int index = FRMQueryString.requestInt(request,"index");
int prevIndex = FRMQueryString.requestInt(request,"prev_index");
long idAccount = FRMQueryString.requestLong(request,"perkiraan");
long idPrevAccount = FRMQueryString.requestLong(request,"prev_perkiraan");
int accountGroup = FRMQueryString.requestInt(request,"account_group");
if(accountGroup == 0) accountGroup = PstPerkiraan.ACC_GROUP_LIQUID_ASSETS;
int isValidDelete = FRMQueryString.requestInt(request,"is_valid_delete");
String msgBalance = "";
boolean isDetailShared = FRMQueryString.requestBoolean(request,"is_detail_shared");
boolean isDetailPrevShared = FRMQueryString.requestBoolean(request,"is_detail_prev_shared");
System.out.println("\n\naccountGroup = "+accountGroup+" isDetailShared = "+isDetailShared+" isDetailPrevShared = "+isDetailPrevShared+" idAccount = "+idAccount+" index "+index+"prevIndex "+prevIndex+"\n\n");

/**
 * from GL
 */
boolean fromGL = FRMQueryString.requestBoolean(request,"fromGL");
long accountId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERKIRAAN);
long periodId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERIODE);
long oidDepartment = FRMQueryString.requestLong(request,"DEPARTMENT");
String numberP = FRMQueryString.requestString(request,"ACCOUNT_NUMBER");
String namaP = FRMQueryString.requestString(request,"ACCOUNT_TITLES");
Date startDate = FRMQueryString.requestDate(request,"START_DATE_GL");
Date endDate = FRMQueryString.requestDate(request,"END_DATE_GL");
System.out.println("accountId="+accountId+" periodId="+periodId+" oidDepartment="+oidDepartment);
String contactName = "";

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : "Tambah Baru Detail";
String strBack = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "Back To Journal List" : "Kembali Ke Daftar Jurnal";
if(fromGL){
    strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To General Ledger" : "Kembali Ke Buku Besar";
}
String strPosted = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "Posted Journal" : "Posted Jurnal";
String strSave = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "Save Detail" : "Simpan Detail";
String strUpdate = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "Update Detail" : "Ubah Detail";
String strDelete = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "Delete Detail" : "Hapus Detail";
String strYesDelete = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "Yes Delete Detail" : "Ya Hapus Detail";
String strCancel = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strSubledger = SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN ? "Subledger" : "Buku Pembantu";

// Get data from session
JurnalUmum jUmum = (JurnalUmum)session.getValue(SessJurnal.SESS_JURNAL_MAIN);

// get period status
boolean periodClosed = PstPeriode.isPeriodClosed(jUmum.getPeriodeId());

// get book type oid
long lSelectedBookTypeUsed = accountingBookType;

// get masterdata currency
String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);


// Instansiasi CtrlJurnalDetail and FrmJurnalDetail
CtrlJurnalUmum ctrlJurnalUmum = new CtrlJurnalUmum(request);
ctrlJurnalUmum.setLanguage(SESS_LANGUAGE);
FrmJurnalUmum frmJurnalUmum = ctrlJurnalUmum.getForm();
CtrlJurnalDetail ctrljurnaldetail = new CtrlJurnalDetail(request) ;

FrmJurnalDetail frmjurnaldetail = ctrljurnaldetail.getForm();
frmjurnaldetail.setDecimalSeparator(sUserDecimalSymbol);
frmjurnaldetail.setDigitSeparator(sUserDigitGroup);

int ctrlErr = ctrljurnaldetail.action(iCommand);
JurnalDetail jurnaldetail = ctrljurnaldetail.getJurnalDetail();

if(iCommand==Command.ADD){
    jurnaldetail.setIdPerkiraan(idAccount);
}

if(iCommand==Command.EDIT || iCommand==Command.ASK){
        // object copy avoid phare by reference
        JurnalDetail temp = jUmum.getJurnalDetail(index);
        jurnaldetail.setCurrAmount(temp.getCurrAmount());
        jurnaldetail.setCurrType(temp.getCurrType());
        jurnaldetail.setDataStatus(temp.getDataStatus());
        jurnaldetail.setDebet(temp.getDebet());
        jurnaldetail.setDetailLinks(temp.getDetailLinks());
        jurnaldetail.setGeneralDetailLink(temp.getGeneralDetailLink());
        jurnaldetail.setIdPerkiraan(temp.getIdPerkiraan());
        jurnaldetail.setIndex(temp.getIndex());
        jurnaldetail.setJurnalIndex(temp.getJurnalIndex());
        jurnaldetail.setKredit(temp.getKredit());
        jurnaldetail.setWeight(temp.getWeight());
        jurnaldetail.setOID(temp.getOID());

        isDetailShared = (SessJurnal.isGeneralAccount(idAccount)>0);
    }
System.out.println("isDetailShared "+isDetailShared);
if(isDetailShared || isDetailPrevShared){

    System.out.println(jUmum.getIShareTransaction()+" "+prevCommand+" "+iCommand+" "+(iCommand==Command.EDIT && prevCommand!=Command.EDIT)+" "+(iCommand==Command.SUBMIT && prevCommand!=Command.SUBMIT)+" "+(iCommand==Command.ADD));
    if(((iCommand==Command.EDIT && prevCommand==Command.EDIT) || (iCommand==Command.SUBMIT && prevCommand!=Command.SUBMIT) || (iCommand==Command.ADD && prevCommand==Command.ADD)) && (index==prevIndex)){
        if(isDetailPrevShared && iCommand!=Command.SUBMIT){
            String sKredit = FRMQueryString.requestString(request,"TOTAL_KREDIT");
            if(sKredit==null||sKredit.length()==0){
                sKredit = "0";
            }
            String sDebet = FRMQueryString.requestString(request,"TOTAL_DEBET");
            if(sDebet==null||sDebet.length()==0){
                sDebet = "0";
            }

            double kredit = Double.parseDouble(frmjurnaldetail.deFormatStringDecimal(sKredit));
            double debet = Double.parseDouble(frmjurnaldetail.deFormatStringDecimal(sDebet));
            System.out.println("MASUK PREV SHARED dengan kredit="+kredit+" dan debet="+debet);
            jurnaldetail.setKredit(kredit);
            jurnaldetail.setDebet(debet);
        }else{
            String sKredit = FRMQueryString.requestString(request,"KREDIT");
            if(sKredit==null||sKredit.length()==0){
                sKredit = "0";
            }
            String sDebet = FRMQueryString.requestString(request,"DEBET");
            if(sDebet==null||sDebet.length()==0){
                sDebet = "0";
            }

            double kredit = Double.parseDouble(frmjurnaldetail.deFormatStringDecimal(sKredit));
            double debet = Double.parseDouble(frmjurnaldetail.deFormatStringDecimal(sDebet));
            System.out.println("MASUK PREV NOT SHARED dengan kredit="+kredit+" dan debet="+debet);
            jurnaldetail.setKredit(kredit);
            jurnaldetail.setDebet(debet);
        }
        jurnaldetail.setIdPerkiraan(idAccount);
        int size = SessJurnal.isGeneralAccount(jurnaldetail.getIdPerkiraan());
        if(size>0){
            System.out.println("MASUK KE IF");
            jurnaldetail.setGeneralDetailLink(detailID);

            Vector accLinks = SessJurnal.getLinkAccount(jurnaldetail.getIdPerkiraan());
            Vector details = new Vector();
            for(int i = 0; i < size; i++){
                Perkiraan account = (Perkiraan) accLinks.get(i);

                String sWeight = FRMQueryString.requestString(request,FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+account.getOID());
                if(sWeight==null||sWeight.length()==0){
                    sWeight = "0";
                }
                String sKredit = FRMQueryString.requestString(request,FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_KREDIT]+account.getOID());
                if(sKredit==null||sKredit.length()==0){
                    sKredit = "0";
                }
                String sDebet = FRMQueryString.requestString(request,FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_DEBET]+account.getOID());
                if(sDebet==null||sDebet.length()==0){
                    sDebet = "0";
                }

                double weight = Double.parseDouble(frmjurnaldetail.deFormatStringDecimal(sWeight));
                double kredit = Double.parseDouble(frmjurnaldetail.deFormatStringDecimal(sKredit));
                double debet = Double.parseDouble(frmjurnaldetail.deFormatStringDecimal(sDebet));

                JurnalDetail dLink = new JurnalDetail();
                dLink.setCurrAmount(jurnaldetail.getCurrAmount());
                dLink.setCurrType(jurnaldetail.getCurrType());
                dLink.setDataStatus(jurnaldetail.getDataStatus());
                dLink.setGeneralDetailLink(detailID);
                dLink.setIdPerkiraan(account.getOID());
                dLink.setIndex(i);
                dLink.setJurnalIndex(journalID);

                if(idAccount!=idPrevAccount && iCommand!=Command.SUBMIT){
                    dLink.setWeight(account.getWeight());
                    dLink.setDebet(account.getWeight()*jurnaldetail.getDebet()/100);
                    dLink.setKredit(account.getWeight()*jurnaldetail.getKredit()/100);
                }
                else
                {
                    System.out.println("MASUK KE ACCOUNT SAMA");
                    dLink.setDebet(debet);
                    dLink.setKredit(kredit);
                    dLink.setWeight(weight);
                }

                details.add(dLink);
            }

            if(idAccount!=idPrevAccount && iCommand!=Command.SUBMIT && index==prevIndex){
                Perkiraan account = new Perkiraan();
                try{
                    account = PstPerkiraan.fetchExc(idAccount);
                }
                catch(Exception e){
                    account = new Perkiraan();
                }
                jurnaldetail.setWeight(account.getWeight());
                jurnaldetail.setDebet(account.getWeight()*jurnaldetail.getDebet()/100);
                jurnaldetail.setKredit(account.getWeight()*jurnaldetail.getKredit()/100);
            }

            jurnaldetail.setDetailLinks(details);

        }


    }

}
if(isDetailShared){
    jUmum.setIShareTransaction(PstJurnalUmum.JOURNAL_SHARE);
}
else{
    jUmum.setIShareTransaction(PstJurnalUmum.JOURNAL_NOT_SHARE);
    jurnaldetail.setGeneralDetailLink(0);
    jurnaldetail.setWeight(0);
    jurnaldetail.setDetailLinks(new Vector());
 }

/** if Command.EDIT, check status 'isValidUpdate' */
boolean isValidUpdate = true;

/** if Command.SUBMIT, process adding or updating jurnal details in object jUmum */
if(iCommand==Command.SUBMIT){
	try{
		if(jUmum.getJurnalDetails().isEmpty()){
			jurnaldetail.setIndex(0);
			jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);
			jUmum.addDetails(jurnaldetail.getIndex(),jurnaldetail);
		}
        else{
			if(prevCommand==Command.ADD){
				jurnaldetail.setIndex(jUmum.getJurnalDetails().size());
				jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);
				jUmum.addDetails(jurnaldetail.getIndex(),jurnaldetail);
			}
			if(prevCommand==Command.EDIT){
				jurnaldetail.setOID(detailID);
				jurnaldetail.setJurnalIndex(journalID);
				jurnaldetail.setIndex(index);
				if(detailID==0){
					jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);
				}
                else{
					jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_UPDATE);
				}

				jUmum.updateDetails(index,jurnaldetail);
			}
		}
        session.putValue(SessJurnal.SESS_JURNAL_MAIN,jUmum);
	}
	catch(Exception e){
		System.out.println("On Submit Exception : "+e.toString());
	}
}

/** if Command.ASK, check detail's availability */
String msgAvailability = "";

/** if Command.DELETE, removing jurnalDetail from jUmum in specified index
 * this operation not remove jd from session but only set status to DATASTATUS_DELETE
 * if detail's have sub ledger, delete sub ledger permanently first from db before delete detail itself
 */
if(iCommand==Command.DELETE){
	jurnaldetail.setOID(detailID);
	jurnaldetail.setJurnalIndex(journalID);
	jurnaldetail.setIndex(index);
	jurnaldetail.setDataStatus(PstJurnalDetail.DATASTATUS_DELETE);
	jUmum.updateDetails(index,jurnaldetail);

    session.putValue(SessJurnal.SESS_JURNAL_MAIN,jUmum);
    if(jUmum.getDeptView()){
        %>
         <jsp:forward page="jumum.jsp">
         <jsp:param name="command" value="<%=Command.NONE%>"/>
         </jsp:forward>
        <%
    }
}

/** if Command.SAVE, posted/save journal main and its details */
if(iCommand==Command.SAVE){
	 CtrlJurnalUmum ctrlJU = new CtrlJurnalUmum(request);
	 ctrlJU.JournalPosted(ctrlJurnalUmum.POSTED_JD, jUmum.getOID(),jUmum);
    if(!fromGL){
        //session.removeValue(SessJurnal.SESS_JURNAL_MAIN);
	 %>
	 <jsp:forward page="jumum.jsp">
	 <jsp:param name="command" value="<%=%>"/>
	 </jsp:forward>
	 <%
    }
}else{
    // for get contact name
    try{
        ContactList contactList = PstContactList.fetchExc(jUmum.getContactOid());
        contactName = contactList.getCompName();
    }catch(Exception e){}
}

/** check if jurnal details already balance or not */
double amountDt = 0;
double amountCr = 0;

boolean balance = false;
Vector vectListJd = jUmum.getJurnalDetails();
amountDt = SessJurnal.getBalanceSide(vectListJd,PstJurnalDetail.SIDE_DEBET);
amountCr = SessJurnal.getBalanceSide(vectListJd,PstJurnalDetail.SIDE_CREDIT);

// menyatakan apakah jurnal detail sudah 2 buah ???
int iMaxDetailAmount = 100;
boolean bDetailAlreadyMaximum = false;
if(vectListJd.size() == iMaxDetailAmount)
{
	bDetailAlreadyMaximum = true;
}

if(SessJurnal.checkBalance(vectListJd))
{
	balance = true;
	if(msgBalance=="")
	{
			if(SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN)
			{
				msgBalance = "journal detail already balance ...";
			}
			else
			{
				msgBalance = "jurnal detail sudah seimbang ...";
			}
	}
}else{
	if(msgBalance==""){
		if(SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN){
			msgBalance = "journal detail haven't balance yet ...";
		}
		else{
			msgBalance = "jurnal detail belum seimbang ...";
		}
	}
}

/** Create vector as object handle for transaction below */
Vector listjurnaldetail = jUmum.getJurnalDetails();


// get user department from data custom
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
//Vector listCode = AppValue.getAppValueVector(accountGroup);
//Vector listAllCode = AppValue.getAppValueVector(PstPerkiraan.ACC_GROUP_ALL);
Vector listCode = AppValue.getAppValueVector(vDepartmentOid,accountGroup);
Vector listAllCode = AppValue.getAppValueVector(vDepartmentOid, PstPerkiraan.ACC_GROUP_ALL);


Vector listAcc = jUmum.getJurnalDetails();

// check if jd item's status clear or not
PstJurnalDetail objPstJurnalDetail = new PstJurnalDetail();
boolean isStatusClear = objPstJurnalDetail.isDetailItemClear(listjurnaldetail);

if(fromGL){
%>
<%@ include file = "jaccountgl.jsp" %>
<%}%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript" src="../main/dsj_common.js"></script>
<script language="JavaScript">
function editForOtherCurrency(currtypeused, currrateused, ddebetamount, dcreditamount)
{
	var strUrl = "jdetail_othercurr.jsp?" +
				 "curr_type_used="+currtypeused +
				 "&curr_rate_used="+currrateused +
				 "&debet_amount="+ddebetamount +
                 "&weight=false"+
				 "&credit_amount="+dcreditamount;
	window.open(strUrl,"journal","height=190,width=500,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
}

function editForOtherCurrencyWithWeight(currtypeused, currrateused, ddebetamount, dcreditamount){
	var strUrl = "jdetail_othercurr.jsp?" +
				 "curr_type_used="+currtypeused +
				 "&curr_rate_used="+currrateused +
				 "&debet_amount="+ddebetamount +
                 "&weight=true"+
				 "&credit_amount="+dcreditamount;
	window.open(strUrl,"journal","height=190,width=500,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
}

function cmdopen(){
	window.open("srccontact_list.jsp","jurnal_search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function openaccount(){
	var strUrl = "accountdosearch.jsp?command=<%=Command.FIRST%>"+
				 "&account_group=0"+
			"&account_number="+document.frmjournaldetail.account_code.value+""+
                 "&department_oid=<%=jUmum.getDepartmentOid()%>&fromGL=<%=fromGL%>";      
	popup = window.open(strUrl,"","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	

}

function addNew(){
    var prev = document.frmjournaldetail.command.value;
	document.frmjournaldetail.perkiraan.value=0;
	document.frmjournaldetail.index.value=-1;
	document.frmjournaldetail.command.value="<%=%>";
	document.frmjournaldetail.prev_command.value=prev;
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdSave(){
	document.frmjournaldetail.command.value="<%=Command.SAVE%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdCancel(){
	document.frmjournaldetail.perkiraan.value=0;
    document.frmjournaldetail.account_group.value=0;
	document.frmjournaldetail.index.value=-1;
	document.frmjournaldetail.is_valid_delete.value="<%=INT_VALID_DELETE%>";
	document.frmjournaldetail.command.value="<%=Command.NONE%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jumum.jsp";
	document.frmjournaldetail.submit();
}

function cmdEdit(index){
	document.frmjournaldetail.index.value=index;
	document.frmjournaldetail.command.value="<%=Command.EDIT%>";
	document.frmjournaldetail.prev_command.value="<%=Command.EDIT%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdAsk(index){
	document.frmjournaldetail.index.value=index;
	document.frmjournaldetail.command.value="<%=Command.ASK%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdDelete(index){
	document.frmjournaldetail.perkiraan.value="";
	document.frmjournaldetail.index.value=index;
	document.frmjournaldetail.command.value="<%=Command.DELETE%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdItemData(journalId){
	document.frmjournaldetail.command.value="<%=Command.NONE%>";
	document.frmjournaldetail.journal_id.value=journalId;
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jumum.jsp";
	document.frmjournaldetail.submit();
}

function cmdBack(){
<%if(fromGL){%>
    document.frmjournaldetail.command.value="<%=Command.LIST%>";
	document.frmjournaldetail.action="../report/general_ledger_dept.jsp";
<%}else{%>
	document.frmjournaldetail.command.value="<%=Command.BACK%>";
	document.frmjournaldetail.target="_self";
	document.frmjournaldetail.action="jlist.jsp";
<%}%>
	document.frmjournaldetail.submit();
}

function cmdChangeDebet(){
	var debet = document.frmjournaldetail.DEBET.value;
	if(debet>0){
	   document.frmjournaldetail.KREDIT.value = 0;
	}
}

function cmdChangeKredit(){
	var kredit = document.frmjournaldetail.KREDIT.value;
	if(kredit>0){
	   document.frmjournaldetail.DEBET.value = 0;
	}
}

<%
    // persiapan javascript untuk shared transaction
    int size = jurnaldetail.getDetailLinks().size();
    double totalWeight = jurnaldetail.getWeight();
    double totalDebet = jurnaldetail.getDebet();
    double totalKredit = jurnaldetail.getKredit();
    for(int i=0; i<size; i++){
        totalWeight = totalWeight + jurnaldetail.getDetailLink(i).getWeight();
        totalDebet = totalDebet + jurnaldetail.getDetailLink(i).getDebet();
        totalKredit = totalKredit + jurnaldetail.getDetailLink(i).getKredit();
    }

 // to do jadikan total *** menjadi variable dinamik jsp
    %>

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

var totalDebet = parseFloat('<%=totalDebet%>');
var totalKredit = parseFloat('<%=totalKredit%>');

function cmdTotalDebet(){
    var debet = parseFloat('0');
    var sDebet = cleanNumberFloat(document.frmjournaldetail.TOTAL_DEBET.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sDebet)){
        debet = parseFloat(sDebet);
    }
    var weight = parseFloat('0');
    var sWeight = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sWeight)){
        weight = parseFloat(sWeight);
    }
	if(debet>0){
       document.frmjournaldetail.TOTAL_KREDIT.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       document.frmjournaldetail.KREDIT.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       document.frmjournaldetail.KREDIT.disabled = true;
       document.frmjournaldetail.DEBET.disabled = false;
       document.frmjournaldetail.DEBET.value = formatFloat((weight*debet/100), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       <% for(int i=0; i<size; i++){%>
       document.frmjournaldetail.KREDIT<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       document.frmjournaldetail.KREDIT<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.disabled = true;
       weight = parseFloat('0');
       sWeight = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
       if(!isNaN(sWeight)){
            weight = parseFloat(sWeight);
       }
       document.frmjournaldetail.DEBET<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.disabled = false;
       document.frmjournaldetail.DEBET<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value = formatFloat((weight*debet/100), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       <%}%>
       totalDebet = debet;
    }

}

function cmdTotalKredit(){
    var kredit = parseFloat('0');
    var sKredit = cleanNumberFloat(document.frmjournaldetail.TOTAL_KREDIT.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sKredit)){
        kredit = parseFloat(sKredit);
    }
    var weight = parseFloat('0');
    var sWeight = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sWeight)){
        weight = parseFloat(sWeight);
    }
	if(kredit>0){
	   document.frmjournaldetail.TOTAL_DEBET.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       document.frmjournaldetail.DEBET.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       document.frmjournaldetail.DEBET.disabled = true;
       document.frmjournaldetail.KREDIT.disabled = false;
        document.frmjournaldetail.KREDIT.value = formatFloat((weight*kredit/100), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       <% for(int i=0; i<size; i++){%>
       document.frmjournaldetail.DEBET<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value = formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       document.frmjournaldetail.DEBET<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.disabled = true;
        weight = parseFloat('0');
        sWeight = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
        if(!isNaN(sWeight)){
            weight = parseFloat(sWeight);
        }
        document.frmjournaldetail.KREDIT<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.disabled = false;
        document.frmjournaldetail.KREDIT<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value = formatFloat((weight*kredit/100), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
       <%}%>
       totalKredit = kredit;
    }

}

function cmdChangeWeight(){
    var weight = parseFloat('0');
    var sWeight = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sWeight)){
        weight = parseFloat(sWeight);
    }
    var total = parseFloat('0');
    if(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_DEBET]%>.disabled==false){
        total = totalDebet;
        document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_DEBET]%>.value = formatFloat((weight*total/100), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    }
    else{
        total = totalKredit;
        document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_KREDIT]%>.value = formatFloat((weight*total/100), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    }
    calcAll();
}

<%for(int i=0;i<size;i++){%>
function cmdChangeWeight<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>(){
	var weight = parseFloat('0');
    var sWeight = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sWeight)){
        weight = parseFloat(sWeight);
    }
    var total = parseFloat('0');
    if(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_DEBET]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.disabled==false){
        total = totalDebet;
        document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_DEBET]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value = formatFloat((weight*total/100), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    }
    else{
        total = totalKredit;
        document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_KREDIT]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value = formatFloat((weight*total/100), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    }
    calcAll();
}
<%}%>

function cmdChangeDebetWeight(){
    var debet = parseFloat('0');
	var sDebet = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_DEBET]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sDebet)){
        debet = parseFloat(sDebet);
    }
    var total = parseFloat('0');
    var sTotal = cleanNumberFloat(document.frmjournaldetail.TOTAL_DEBET.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sTotal)){
        total = parseFloat(sTotal);
    }
    var weight = parseFloat('0');
    var sWeight = cleanNumberFloat(document.frmjournaldetail.TOTAL_WEIGHT.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sWeight)){
        weight = parseFloat(sWeight);
    }
    document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]%>.value = formatFloat((debet*weight/total), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    calcAll();
}

<%for(int i=0;i<size;i++){%>
function cmdChangeDebet<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>(){
	var debet = parseFloat('0');
	var sDebet = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_DEBET]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sDebet)){
        debet = parseFloat(sDebet);
    }
    var total = parseFloat('0');
    var sTotal = cleanNumberFloat(document.frmjournaldetail.TOTAL_DEBET.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sTotal)){
        total = parseFloat(sTotal);
    }
    var weight = parseFloat('0');
    var sWeight = cleanNumberFloat(document.frmjournaldetail.TOTAL_WEIGHT.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sWeight)){
        weight = parseFloat(sWeight);
    }
    document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value = formatFloat((debet*weight/total), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    calcAll();
}
<%}%>

function cmdChangeKreditWeight(){
	var kredit = parseFloat('0');
	var sKredit = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_KREDIT]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sKredit)){
        kredit = parseFloat(sKredit);
    }
    var total = parseFloat('0');
    var sTotal = cleanNumberFloat(document.frmjournaldetail.TOTAL_KREDIT.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sTotal)){
        total = parseFloat(sTotal);
    }
    var weight = parseFloat('0');
    var sWeight = cleanNumberFloat(document.frmjournaldetail.TOTAL_WEIGHT.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sWeight)){
        weight = parseFloat(sWeight);
    }
    document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]%>.value = formatFloat((kredit*weight/total), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    calcAll();
}

<%for(int i=0;i<size;i++){%>
function cmdChangeKredit<%=jurnaldetail.getDetailLink(i).getIdPerkiraan()%>(){
	var kredit = parseFloat('0');
	var sKredit = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_KREDIT]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sKredit)){
        kredit = parseFloat(sKredit);
    }
    var total = parseFloat('0');
    var sTotal = cleanNumberFloat(document.frmjournaldetail.TOTAL_KREDIT.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sTotal)){
        total = parseFloat(sTotal);
    }
    var weight = parseFloat('0');
    var sWeight = cleanNumberFloat(document.frmjournaldetail.TOTAL_WEIGHT.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sWeight)){
        weight = parseFloat(sWeight);
    }
    document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value = formatFloat((kredit*weight/total), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    calcAll();
}
<%}%>

function calcAll(){
    calcWeight();
    calcDebet();
    calcKredit();
}

function calcWeight(){
    var weight = parseFloat('0');
    var temp = parseFloat('0');
    var sWeight = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sWeight)){
        weight = parseFloat(sWeight);
    }
    <%for(int i=0;i<size;i++){%>
        temp = parseFloat('0');
        sWeight = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_WEIGHT]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
        if(!isNaN(sWeight)){
            temp = parseFloat(sWeight);
        }
        weight = weight+temp;
    <%}%>
    document.frmjournaldetail.TOTAL_WEIGHT.value=formatFloat(weight, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
}

function calcDebet(){
    var debet = parseFloat('0');
    var temp = parseFloat('0');
    var sDebet = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_DEBET]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sDebet)){
        debet = parseFloat(sDebet);
    }
    <%for(int i=0;i<size;i++){%>
        temp = parseFloat('0');
        sDebet = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_DEBET]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
        if(!isNaN(sDebet)){
            temp = parseFloat(sDebet);
        }
        debet = debet+temp;
    <%}%>
    var temp = totalDebet;
    document.frmjournaldetail.TOTAL_DEBET.value=formatFloat(debet, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    totalDebet = temp;
}

function calcKredit(){
    var kredit = parseFloat('0');
    var temp = parseFloat('0');
    var sKredit = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_KREDIT]%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sKredit)){
        kredit = parseFloat(sKredit);
    }
    <%for(int i=0;i<size;i++){%>
        temp = parseFloat('0');
        sKredit = cleanNumberFloat(document.frmjournaldetail.<%=FrmJurnalDetail.fieldNames[FrmJurnalDetail.FRM_KREDIT]+jurnaldetail.getDetailLink(i).getIdPerkiraan()%>.value,sysDecSymbol, usrDigitGroup, usrDecSymbol);
        if(!isNaN(sKredit)){
            temp = parseFloat(sKredit);
        }
        kredit = kredit+temp;
    <%}%>
    var temp = totalKredit;
    document.frmjournaldetail.TOTAL_KREDIT.value=formatFloat(kredit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    totalKredit = temp;
}

function cmdSetPeriod(){
	var act = "<%=approot%>" + "/period/setup_period.jsp";
	document.frmjournaldetail.command.value="<%=Command.LIST%>";
	document.frmjournaldetail.action=act;
	document.frmjournaldetail.submit();
}


function cmdAddItem(){
	<%if(isValidUpdate){%>
        var prev = document.frmjournaldetail.command.value;
        var prevId = document.frmjournaldetail.perkiraan.value;
        var prevIdx = document.frmjournaldetail.index.value;
        document.frmjournaldetail.prev_index.value = prevIdx;
        document.frmjournaldetail.prev_perkiraan.value=prevId;
        document.frmjournaldetail.prev_command.value=prev;
		document.frmjournaldetail.command.value="<%=Command.SUBMIT%>";
		document.frmjournaldetail.action="jdetail.jsp";
		document.frmjournaldetail.submit();
	<%
	}else{
		String mPostable = "";
		if(SESS_LANGUAGE==I_Language.LANGUAGE_FOREIGN){
			mPostable = "<i>Cannot update detail because its sub ledger referenced by other one(s) ...</i>";
		}else{
			mPostable = "<i>Tidak bisa mengubah jurnal detail karena data buku pembantunya dipakai oleh jurnal lain ...</i>";
		}
	%>
		document.all.msgPostable.innerHTML = "<%=mPostable%>";
	<%}%>
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->

<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
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
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%>
            &gt; <%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td><!-- #BeginEditable "content" -->
            <form name="frmjournaldetail" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="index" value="<%=index%>">
              <input type="hidden" name="prev_index" value="<%=prevIndex%>">
              <input type="hidden" name="journal_id" value="<%=jUmum.getOID()%>">
              <input type="hidden" name="detail_id" value="<%=detailID%>">
              <input type="hidden" name="perkiraan" value="<%=idAccount%>">
              <input type="hidden" name="prev_perkiraan" value="<%=idPrevAccount%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
	          <input type="hidden" name="is_valid_delete" value="<%=isValidDelete%>">
	          <input type="hidden" name="account_group" value="<%=accountGroup%>">
              <input type="hidden" name="is_detail_shared" value="<%=isDetailShared%>">
              <input type="hidden" name="is_detail_prev_shared" value="<%=isDetailPrevShared%>">
              <input type="hidden" name="<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_CONTACT_ID]%>" value="<%=jUmum.getContactOid()%>">

              <input type="hidden" name="<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_SHARED_TRANSACTION]%>" value="<%=jUmum.getIShareTransaction()%>">
              <input type="hidden" name="fromGL" value="<%=fromGL%>">
              <input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>" value="<%=accountId%>">
              <input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERIODE%>" value="<%=periodId%>">
              <input type="hidden" name="DEPARTMENT" value="<%=jUmum.getDepartmentOid()%>">
              <input type="hidden" name="ACCOUNT_NUMBER" value="<%=numberP%>">
              <input type="hidden" name="ACCOUNT_TITLES" value="<%=namaP%>">
              <input type="hidden" name="START_DATE_GL_yr" value="<%=(startDate.getYear()+1900)%>">
              <input type="hidden" name="START_DATE_GL_mn" value="<%=(startDate.getMonth()+1)%>">
              <input type="hidden" name="START_DATE_GL_dy" value="<%=startDate.getDate()%>">
              <input type="hidden" name="END_DATE_GL_yr" value="<%=(endDate.getYear()+1900)%>">
              <input type="hidden" name="END_DATE_GL_mn" value="<%=(endDate.getMonth()+1)%>">
              <input type="hidden" name="END_DATE_GL_dy" value="<%=endDate.getDate()%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%" height="2">
                          <hr>
                        </td>
                      </tr>
                      <tr>
                        <td width="100%" class="tabtitleactive">
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
                            <tr>
                              <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                              <td width="94%" height="25" class="listgensell" valign="top">&nbsp;</td>
                              <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                            </tr>
                            <tr>
                              <td width="3%" valign="top"></td>
                              <td width="94%">
                                <table width="100%">
                                  <tr>
                                    <td width="11%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][12]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25">
                                      <input type="hidden" name="<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_BOOK_TYPE]%>" value="<%=""+accountingBookType%>" size="35">
										<%
										String sBookType = "";
										try
										{
											CurrencyType objCurrencyType = PstCurrencyType.fetchExc(accountingBookType);
											sBookType = objCurrencyType.getName();
										}
										catch(Exception e)
										{
											System.out.println("Exc when fetch book type from currtype : " + e.toString());
										}
										out.println(sBookType);
										%>
                                    </td>
                                    <td width="13%" height="25"><%=strTitle[SESS_LANGUAGE][5]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                      <input type="text" name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_REFERENCE_DOC]%>" value="<%=jUmum.getReferenceDoc()%>" size="18">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="11%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25">
                                      <%
									String strVoucherNumber = "-";
									if(jUmum.getVoucherNo()!=null && jUmum.getVoucherNo().length()>0)
									{
										strVoucherNumber = jUmum.getVoucherNo()+"-"+SessJurnal.intToStr(jUmum.getVoucherCounter(),4);
									}
									out.println(strVoucherNumber);
									%>
                                    </td>
                                    <td width="13%" height="25"><%=strTitle[SESS_LANGUAGE][3]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="27%" height="25">
                                      <%
									   Vector currencytypeid_value = new Vector(1,1);
									   Vector currencytypeid_key = new Vector(1,1);

									   String sel_currencytypeid = ""+jUmum.getCurrType();
									   if(listCurrencyType!=null&&listCurrencyType.size()>0)
									   {
											for(int i=0;i<listCurrencyType.size();i++)
											{
												CurrencyType currencyType =(CurrencyType)listCurrencyType.get(i);
												currencytypeid_value.add(currencyType.getName()+"("+currencyType.getCode()+")");
												currencytypeid_key.add(""+currencyType.getOID());
											}
									   }
									  %>
                                      <%= ControlCombo.draw(frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_CURR_TYPE],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value, "", "") %>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25"><%
									   String strDt = Formater.formatDate(jUmum.getTglEntry(),"MMMM dd, yyyy");
									   out.println(strDt);
									  %></td>
                                    <td height="25"><%=strTitle[SESS_LANGUAGE][1]%></td>
                                    <td height="25"><b>:</b></td>
                                    <td height="25"><%
								    Date tanggal = jUmum.getTglTransaksi();
									out.println(ControlDate.drawDate(frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_TGLTRANSAKSI], tanggal, 0, -2));
								    %></td>
                                  </tr>
                                  <tr>
                                    <td width="11%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][6]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="43%" height="25"><%
									String whereUser = "";
									whereUser = PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = "+ jUmum.getUserId();
									try{
										Vector vectUser = PstAppUser.listPartObj(0,0,whereUser,"");
										if(vectUser.size()>0 && vectUser != null){
											AppUser aUser = (AppUser)vectUser.get(0);
											userName = aUser.getLoginId();
										}
									}catch(Exception exc){	}
									out.println(userName);
									%>
                                    </td>
                                    <td width="13%" height="25"><%=strTitle[SESS_LANGUAGE][20]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td width="27%" height="25"><input type="text" readonly name="<%=frmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_CONTACT_ID]%>_TEXT" value="<%=contactName%>" size="25">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td width="11%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][21]%></td>
                                    <td width="3%" height="25"><strong>:</strong></td>
                                    <td width="43%" height="25">
                                    <%
                                     if(jUmum.getDeptView()){
                                        Vector vectDeptKey = new Vector();
                                         Vector vectDeptName = new Vector();
                                         int iDeptSize = vDepartmentOid.size();
                                         for (int deptNum = 0; deptNum < iDeptSize; deptNum++){
                                             Department dept = new Department();
                                             try{
                                                 dept = PstDepartment.fetchExc(Long.parseLong((String)vDepartmentOid.get(deptNum)));
                                             }catch(Exception e){}
                                             vectDeptKey.add(String.valueOf(dept.getOID()));
                                             vectDeptName.add(dept.getDepartment());
                                         }
                                         String strSelectedDept = String.valueOf(jUmum.getDepartmentOid());
                                    %>
                                    <%=ControlCombo.draw(FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_DEPARTMENT_ID], "", null, strSelectedDept, vectDeptKey, vectDeptName)%>
                                    <%}else{
                                        try{
                                            Department department = PstDepartment.fetchExc(jUmum.getDepartmentOid());
                                            out.println(department.getDepartment());
                                        }catch(Exception e){}
                                     }
                                    %>
                                    </td>
                                    <td width="13%" height="25"><%=strTitle[SESS_LANGUAGE][4]%></td>
                                    <td width="3%" height="25"><b>:</b></td>
                                    <td rowspan="2" height="52">
                                      <textarea name="<%=frmJurnalUmum.fieldNames[frmJurnalUmum.FRM_KETERANGAN] %>" cols="30" rows="3"><%=jUmum.getKeterangan()%></textarea>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="3" height="25" valign="bottom">&nbsp;<i><u><%=strTitle[SESS_LANGUAGE][11]%></u></i></td>
                                    <td height="25" width="13%">&nbsp;</td>
                                    <td height="25" width="3%">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="6">
                                      <%
                                          if(jUmum.getIShareTransaction()==PstJurnalUmum.JOURNAL_SHARE){
									            out.println(listJurnalDetailWithWeight(iCommand,SESS_LANGUAGE,index,frmjurnaldetail,listjurnaldetail,listCode,listCurrencyType,lSelectedBookTypeUsed,jurnaldetail, fromGL));
                                          }
                                          else{
                                                out.println(listJurnalDetail(iCommand,SESS_LANGUAGE,index,frmjurnaldetail,listjurnaldetail,listCode,listCurrencyType,lSelectedBookTypeUsed,jurnaldetail, fromGL));
                                          }
									if(amountDt>0 || amountCr>0){
									out.println(drawListTotal(frmjurnaldetail,msgBalance,amountDt,amountCr));
									}
									%>
                                    </td>
                                  </tr>
                                  <%if(iCommand == Command.ASK){%>
                                  <tr>
                                    <td colspan="6">
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr>
                                          <td class="msgquestion">
                                            <div align="center"><%=isValidDelete==INT_VALID_DELETE? "Are you sure to delete journal detail ?" : msgAvailability%></div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>

                                  <tr>
                                    <td colspan="6" class="command">&nbsp;
                                      <%
									  if((!periodClosed)&&(privView)&&(privAdd)&&(privSubmit))
									  {
										  if(iCommand!=Command.ASK)
										  {
											  if(iCommand==Command.LIST || iCommand==Command.DELETE || iCommand==Command.SUBMIT)
											  {
													String sCommandListDeleteSubmit = "";
												    if(!bDetailAlreadyMaximum)
												    {
														sCommandListDeleteSubmit = sCommandListDeleteSubmit + "<a href=\"javascript:addNew()\">"+strAdd+"</a> | ";
									  			    }

												    if(balance && !isStatusClear)
												    {
														sCommandListDeleteSubmit = sCommandListDeleteSubmit + "<a href=\"javascript:cmdSave()\">"+strPosted+"</a> | ";
									  			    }
													sCommandListDeleteSubmit = sCommandListDeleteSubmit + "<a href=\"javascript:cmdBack()\">"+strBack+"</a>";
													out.println(sCommandListDeleteSubmit);
									  		  }

											  if(iCommand==Command.EDIT)
											  {
													String sCommandAddAskCancel = "<a href=\"javascript:cmdAddItem()\">"+strUpdate+"</a>";
													sCommandAddAskCancel = sCommandAddAskCancel + " | <a href=\"javascript:cmdAsk("+index+")\">"+strDelete+"</a>";
													sCommandAddAskCancel = sCommandAddAskCancel + " | <a href=\"javascript:cmdCancel()\">"+strCancel+"</a>";
													out.println(sCommandAddAskCancel);
											  }

											  if(iCommand==Command.ADD)
											  {
													String sCommandAddCancel = "<a href=\"javascript:cmdAddItem()\">"+strSave+"</a>";
													sCommandAddCancel = sCommandAddCancel + " | <a href=\"javascript:cmdCancel()\">"+strCancel+"</a>";
													out.println(sCommandAddCancel);
											  }
									  	  }

									  	  else
									  	  {
										  		String sCommandAsk = isValidDelete==INT_VALID_DELETE? "<a href=\"javascript:cmdDelete('"+index+"')\">"+strYesDelete+"</a> | "+ " <a href=\"javascript:cmdCancel()\">"+strCancel+"</a>" : "";
                                      			out.println(sCommandAsk);
									  	  }
									  }

									  else
									  {
									  		String sCommandBack = "<a href=\"javascript:cmdBack()\">"+strBack+"</a>";
											out.println(sCommandBack);
									  }
									  %>
                                    </td>
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

			  <%
			  if(iCommand==Command.ADD || iCommand==Command.EDIT){
			  %>
			  <script language="javascript">
			  		document.frmjournaldetail.account_code.focus();
			  </script>
			  <%
			  }
              else if(iCommand==Command.SAVE && fromGL){
			  %>
              <script language="javascript">
			  		cmdBack();
			  </script>
              <%}%>
            </form>
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