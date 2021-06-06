<%@ page language="java" %>

<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.util.*" %>

<!--import qdep-->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<!--import common -->
<%@ page import = "com.dimata.common.entity.payment.StandartRate" %>
<%@ page import = "com.dimata.common.entity.payment.PstStandartRate" %>
<%@ page import = "com.dimata.common.entity.payment.CurrencyType" %>
<%@ page import = "com.dimata.common.entity.payment.PstCurrencyType" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.JournalDistribution" %> 
<%@ page import="com.dimata.aiso.entity.jurnal.PstJournalDistribution" %> 
<%@ page import="com.dimata.aiso.entity.jurnal.JurnalUmum" %> 
<%@ page import="com.dimata.aiso.entity.jurnal.JurnalDetail" %> 
<%@ page import="com.dimata.aiso.entity.jurnal.PstJurnalUmum" %>
<%@ page import="com.dimata.aiso.entity.jurnal.PstJurnalDetail" %>
<%@ page import="com.dimata.aiso.session.jurnal.SessJurnal" %> 
<%@ page import="com.dimata.aiso.form.jurnal.FrmJournalDistribution" %>
<%@ page import="com.dimata.aiso.form.jurnal.CtrlJournalDistribution" %>
<%@ page import="com.dimata.aiso.form.jurnal.FrmJurnalDetail" %>
<%@ page import="com.dimata.aiso.form.jurnal.FrmJurnalUmum" %>
<%@ page import="com.dimata.aiso.form.jurnal.CtrlJurnalDetail" %>
<%@ page import="com.dimata.aiso.form.jurnal.CtrlJurnalUmum" %>
<%@ page import="com.dimata.aiso.entity.masterdata.BussinessCenter" %>
<%@ page import="com.dimata.aiso.entity.masterdata.PstBussinessCenter"%>  
<%@ page import="com.dimata.aiso.entity.masterdata.Perkiraan"%>
<%@ page import="com.dimata.aiso.entity.masterdata.PstPerkiraan"%>
<%@ page import="com.dimata.aiso.session.masterdata.SessDailyRate"%>
<%@ page import="com.dimata.aiso.entity.masterdata.DailyRate"%>

<%!
public static String strTitle[][] = {
	{
	"Input Jurnal Distribusi","Keterangan","Debet(Rp)","Kredit(Rp)","Mata Uang","Kurs(Rp)","Set Jumlah Ke Jurnal Detail","Batal Input Jurnal Distribusi Kembali Ke Jurnal Detail","Nama Perkiraan","Pusat Bisnis","Untuk","Catatan","Silahkan input debet atau kredit sesuai nilai mata uangnya. System seraca otomatis mengkonversi ke rupiah.","COA"
	},	
	
	{
	"Journal Distribution Entry","Remark","Debet(Rp)","Credit(Rp)","Currency","Rate(Rp)","Set Amount To Journal Detail","Cancel Entry Back To Journal Detail","Account","Bisnis Center","For","Note","Please entry debit or credit amount in original currency. System will convert automatically to local currency.","COA"
	}
};

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

public Vector drawListJDistribution(int iCommand, int language, int index, FrmJournalDistribution frmJournalDistribution, Vector vJDistribution, Vector listCurrencyType, Vector vBisnisCenter, long accountId, long periodeId, String approot)
{
	Vector vResult = new Vector();
	String sResult = "";
	String sListOpening = "<table width=\"100%\" border=\"0\" class=\"listgen\" cellspacing=\"1\">";
	sListOpening = sListOpening + "<tr><td width=\"15%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][9]+"</div></td>";//2 Bisnis Center
	sListOpening = sListOpening + "<td width=\"15%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][13]+"</div></td>";//13 COA
        sListOpening = sListOpening + "<td width=\"5%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][4]+"</div></td>";//3 Currency
	sListOpening = sListOpening + "<td width=\"10%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][5]+"</div></td>";//4 Rate
	sListOpening = sListOpening + "<td width=\"25%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][2]+"</div></td>";//5 Debet
	sListOpening = sListOpening + "<td width=\"25%\" class=\"listgentitle\"><div align=\"center\">"+strTitle[language][3]+"</div></td></tr>";//6 Credit
	

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
                         if(jDistribution.getDataStatus()==PstJurnalDetail.DATASTATUS_DELETE){
                             continue;
                         }
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
                         
                         long coaId= jDistribution.getIdPerkiraan();                         
                         String coaCode ="-";
                         String coaName ="-";
                         try {
                             Perkiraan objCoa = PstPerkiraan.fetchExc(coaId);
                             coaCode = objCoa.getNoPerkiraan();
                             coaName = getAccName(language, objCoa);
                         } catch(Exception exc){
                             System.out.println(exc);
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
			 
			 	if(index==jDistribution.getIndex()&&(iCommand == Command.EDIT || iCommand == Command.ASK)){
				 	sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_BUSS_CENTER_ID], null, selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey,"","")+"</div>"+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ID_PERKIRAAN]+"\" size=\"15\" value=\""+accountId+"\"> "+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_PERIODE_ID]+"\" size=\"15\" value=\""+periodeId+"\"></td>";
                                        sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\""+"account_code"+"\" size=\"10\" value=\""+coaCode +"\" class=\"txtalign\">&nbsp; <a href=\"javascript:openJdAccount()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>&nbsp;"+"<input type=\"text\" name=\"account_name\" size=\"25\" readonly value=\""+coaName+"\">"+"</div></td>";
					sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CURRENCY_ID], null, selectedCurrType, currencytypeid_value, currencytypeid_key,"onChange=\"javascript:changeCurrType()\"","")+"</div></td>";
					sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" readOnly name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_TRANS_RATE]+"\" size=\"10\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate())+"\" class=\"txtalign\"></div></td>"+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_STANDARD_RATE]+"\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getStandardRate()) +"\">";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_DEBIT_AMOUNT]+"\" size=\"15\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount()) +"\" class=\"txtalign\"></div></td>";
				 	sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CREDIT_AMOUNT]+"\" size=\"15\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount())+"\" class=\"txtalign\"></div></td></tr>";
					sListContent = sListContent + "<tr><td colspan=\"6\" class=\"listgensell\"><div align=\"left\"><b>"+strTitle[language][1]+" : </b><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_NOTE]+"\" size=\"100\" value=\""+jDistribution.getNote()+"\" ></div></td></tr>";				
                   
				 }else{                 
				 	 	sListContent = sListContent + "<tr><td class=\"listgensell\"><div align=\"left\">"+ "<a href=\"javascript:cmdClickBisnisCenter('"+jDistribution.getOID()+"','"+jDistribution.getIndex()+"')\">"+bisnisCenterName+"</a>" +"</div></td>";
                                                sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ coaCode +" "+coaName +"</div></td>";
                                        	sListContent = sListContent + "<td class=\"listgensell\"><div align=\"left\">"+ currName +"</div></td>";
						sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+ frmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate()) +"</div></td>";
				 		sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+frmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount())+"&nbsp; ("+currencyType.getCode().toUpperCase()+" = "+ frmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount()/jDistribution.getTransRate()) +")</div></td>";
				 		sListContent = sListContent + "<td class=\"listgensell\"><div align=\"right\">"+frmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount())+"&nbsp; ("+currencyType.getCode().toUpperCase()+" = " +frmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount()/jDistribution.getTransRate()) +")</div></td></tr>";
						sListContent = sListContent + "<tr><td colspan=\"6\" class=\"listgensell\"><div align=\"left\"><b>"+strTitle[language][1]+" : </b>"+ jDistribution.getNote() +"</div></td></tr>";
				
		 }
		 
		 totDebet += jDistribution.getDebitAmount();
		 totCredit += jDistribution.getCreditAmount();
	}
	
		// For second row and next  
		if(iCommand==Command.ADD){ 		
			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_BUSS_CENTER_ID], null, selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey,"","")+"</div></td>"+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ID_PERKIRAAN]+"\" size=\"15\" value=\""+accountId+"\"> "+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_PERIODE_ID]+"\" size=\"15\" value=\""+periodeId+"\"> ";		
                        sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\""+"account_code"+"\" size=\"10\" value=\""+"\"\" "+"\" class=\"txtalign\">"+"&nbsp; <a href=\"javascript:openJdAccount()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a> "+
                                "<input type=\"text\" name=\"account_name\" size=\"25\" readonly value="+""+">"+"</div></td>";
                        sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CURRENCY_ID], null, selectedCurrType, currencytypeid_value, currencytypeid_key,"onChange=\"javascript:changeCurrType()\"","")+"</div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" readOnly name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_TRANS_RATE]+"\" size=\"10\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate())+"\" class=\"txtalign\"></div></td>"+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_STANDARD_RATE]+"\" value=\""+frmJournalDistribution.userFormatStringDecimal(jDistribution.getStandardRate())+"\">";		
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_DEBIT_AMOUNT]+"\" size=\"15\" value=\"\" class=\"txtalign\" ></div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CREDIT_AMOUNT]+"\" size=\"15\" value=\"\" class=\"txtalign\" ></div></td></tr>";	
			sListContent = sListContent + "<tr><td colspan=\"6\" class=\"tabtitlehidden\"><div align=\"left\"><b>"+strTitle[language][1]+" : </b><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_NOTE]+"\" size=\"100\" value=\"\"></div></td></tr>";
			}
			sListContent += "<tr><td colspan=\"4\" class=\"tabtitlehidden\"><div align=\"right\"><b>TOTAL</b></div></td>";
			sListContent += "<td class=\"tabtitlehidden\"><div align=\"right\">"+frmJournalDistribution.userFormatStringDecimal(totDebet)+"</div></td>";
			sListContent += "<td class=\"tabtitlehidden\"><div align=\"right\">"+frmJournalDistribution.userFormatStringDecimal(totCredit)+"</div></td></tr>";
}else{
	//Just first row
	if(iCommand==Command.ADD){			
			sListContent = sListContent + "<tr><td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_BUSS_CENTER_ID], null, selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey,"","")+"</div></td>";		
                        sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\""+"account_code"+"\" size=\"10\" value=\""+"\"\" "+"\" class=\"txtalign\">&nbsp;"+"<a href=\"javascript:openJdAccount()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>"+
                                "<input type=\"text\" name=\"account_name\" size=\"25\" readonly value="+""+">"+"</div></td>";
                        sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\">"+ControlCombo.draw(frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CURRENCY_ID], null, selectedCurrType, currencytypeid_value, currencytypeid_key,"onChange=\"javascript:changeCurrType()\"","")+
			"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_ID_PERKIRAAN]+"\" size=\"15\" value=\""+accountId+"\"> " +
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_PERIODE_ID]+"\" size=\"15\" value=\""+periodeId+"\"></div></td>";
                        
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"left\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_TRANS_RATE]+"\" size=\"10\" readOnly value=\""+frmJournalDistribution.userFormatStringDecimal(1)+"\" class=\"txtalign\">"+
					"<input type=\"hidden\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_STANDARD_RATE]+"\" value=\""+frmJournalDistribution.userFormatStringDecimal(1)+"\"></div></td>";		
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_DEBIT_AMOUNT]+"\" size=\"15\" value=\"\" class=\"txtalign\"> </div></td>";
			sListContent = sListContent + "<td class=\"tabtitlehidden\"><div align=\"right\"><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_CREDIT_AMOUNT]+"\" size=\"15\" value=\"\" class=\"txtalign\"> </div></td></tr>";			
		 	sListContent = sListContent + "<tr><td colspan=\"6\" class=\"tabtitlehidden\"><div align=\"left\"><b>"+strTitle[language][1]+" : </b><input type=\"text\" name=\""+frmJournalDistribution.fieldNames[frmJournalDistribution.FRM_NOTE]+"\" size=\"100\" value=\"\"></div></td></tr>";
	}
}

	sResult = sListOpening + sListContent + sListClosing;
	vResult.add(sResult);
	vResult.add(""+totDebet);
	vResult.add(""+totCredit);
	return vResult;
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long lCurrTypeOidUsed = FRMQueryString.requestLong(request,"curr_type_used");
double dCurrRateUsed = 1;
int index = FRMQueryString.requestInt(request,"index");
int prevIndex = FRMQueryString.requestInt(request,"prev_index");
long lJDistributionId = FRMQueryString.requestLong(request,"hidden_j_distribution_id");
long journalID = FRMQueryString.requestLong(request,"journal_id");
long accountId = FRMQueryString.requestLong(request,"account_id");
long periodId = FRMQueryString.requestLong(request,"period_id");


String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Journal Distribution" : "Tambah Baru Jurnal Distribusi";
String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Journal Distribution" : "Simpan Jurnal Distribusi";
String strUpdate = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Update Journal Distribution" : "Ubah Jurnal Distribusi";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Journal Distribution" : "Hapus Jurnal Distribusi";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Journal Distribution" : "Ya Hapus Jurnal Distribusi";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strConfirm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are you sure want to delete Journal Distribution?" : "Apakah anda yakin menghapus Jurnal Distribusi?";
boolean bWeight = false;
String accName = "";
double dDebetVal = 0.0;
double dKreditVal = 0.0;

JurnalUmum jUmum = (JurnalUmum)session.getValue(SessJurnal.SESS_JURNAL_MAIN);
if( jUmum ==null) {
    %> <jsp:forward page="../informonchildwindow.jsp?ic=0" />
    <%
}

CtrlJurnalUmum ctrlJurnalUmum = new CtrlJurnalUmum(request);
FrmJurnalUmum frmJurnalUmum = ctrlJurnalUmum.getForm();

CtrlJournalDistribution ctrJDistribution = new CtrlJournalDistribution(request);
FrmJournalDistribution frmJDistribution = ctrJDistribution.getForm();
int ctrlErr = ctrJDistribution.action(iCommand);
JournalDistribution objJDistribution = ctrJDistribution.getJournalDistribution();

frmJDistribution.setDecimalSeparator(sUserDecimalSymbol); 
frmJDistribution.setDigitSeparator(sUserDigitGroup);

if(accountId != 0)
	{
		try{
			Perkiraan objPerkiraan = PstPerkiraan.fetchExc(accountId);
			accName = getAccName(SESS_LANGUAGE,objPerkiraan);
		}catch(Exception e){}
	}
	
JurnalDetail jDetail = jUmum.getJurnalDetailByCoaID(accountId);

if(iCommand==Command.EDIT || iCommand==Command.ASK){        
        JournalDistribution temp = null;
        if(lJDistributionId!=0){
            temp=jDetail.getJournalDistribution(lJDistributionId);       
        }else{
            temp=jDetail.getJournalDistribution(index);
        }
        if( temp==null){
            temp = new JournalDistribution();
        }
		objJDistribution.setBussCenterId(temp.getBussCenterId());
		objJDistribution.setJournalDetailId(temp.getJournalDetailId());
		objJDistribution.setIdPerkiraan(temp.getIdPerkiraan());
		objJDistribution.setPeriodeId(temp.getPeriodeId());
		objJDistribution.setDebitAmount(temp.getDebitAmount());
		objJDistribution.setCreditAmount(temp.getCreditAmount());
		objJDistribution.setNote(temp.getNote());
		objJDistribution.setCurrencyId(temp.getCurrencyId());
		objJDistribution.setTransRate(temp.getTransRate());
		objJDistribution.setStandardRate(temp.getStandardRate());
		objJDistribution.setOID(temp.getOID());
	
    }

/** if Command.EDIT, check status 'isValidUpdate' */
boolean isValidUpdate = true;

/** if Command.SUBMIT, process adding or updating jurnal details in object jUmum */
if(iCommand==Command.SAVE){
	try{
		if(jDetail.getJournalDistributions().size()==0){
			objJDistribution.setIndex(0);
			objJDistribution.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);
			jDetail.addJDistributions(objJDistribution.getIndex(),objJDistribution);
		} else{                            		
                    if(prevCommand==Command.EDIT) {
                        objJDistribution.setOID(lJDistributionId);
                        if(jDetail!=null){
                            objJDistribution.setJournalDetailId(jDetail.getOID());
                            }
                        objJDistribution.setJournalIndex(journalID);
                        objJDistribution.setIndex(index);
                        if(lJDistributionId==0){
                                objJDistribution.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);                                
                        }else{
                                objJDistribution.setDataStatus(PstJurnalDetail.DATASTATUS_UPDATE);
                                //if(objJDistribution.getOID()!=0){
                                  // PstJournalDistribution.updateExc(objJDistribution); 
                               // }
                        }
                        jDetail.updateJDistributions(index,objJDistribution);
                        
                    }else{
                        objJDistribution.setIndex(jDetail.getJournalDistributions().size());
                        objJDistribution.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);
                        jDetail.addJDistributions(objJDistribution.getIndex(),objJDistribution);	
                    }			
		}
        session.putValue(SessJurnal.SESS_JURNAL_MAIN,jUmum);
	}
	catch(Exception e){
		System.out.println("On Exception : "+e.toString());
	}
}

/** if Command.ASK, check detail's availability */
String msgAvailability = "";

/** if Command.DELETE, removing jurnalDetail from jUmum in specified index
 * this operation not remove jd from session but only set status to DATASTATUS_DELETE
 * if detail's have sub ledger, delete sub ledger permanently first from db before delete detail itself
 */
if(iCommand==Command.DELETE){
	objJDistribution.setOID(lJDistributionId);
	objJDistribution.setJournalIndex(journalID);
	objJDistribution.setIndex(index);
	objJDistribution.setDataStatus(PstJurnalDetail.DATASTATUS_DELETE);
	//jDetail.deleteJDistributions(index);
        jDetail=jUmum.getJurnalDetailByOID(jDetail.getOID());
        jDetail.updateJDistributions(index, objJDistribution);
        session.putValue(SessJurnal.SESS_JURNAL_MAIN,jUmum);
   
}

/** Create vector as object handle for transaction below */
Vector vJDistribution = jDetail.getJournalDistributions();
Vector vBisnisCenter = PstBussinessCenter.list(0,0,"",PstBussinessCenter.fieldNames[PstBussinessCenter.FLD_BUSS_CENTER_NAME]);


// check if jd item's status clear lior not
PstJournalDistribution objPstJournalDistribution = new PstJournalDistribution();

// get masterdata currency
String sOrderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector vlistCurrencyType = PstCurrencyType.list(0, 0, "", sOrderBy);

// get masterdata standart rate
String sStRateWhereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS] + " = " + PstStandartRate.ACTIVE;
String sStRateOrderBy = PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE] + 
						", " + PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE];
Vector vlistRate = SessDailyRate.getDataCurrency();

Vector vListJournalDistribution = (Vector) drawListJDistribution(iCommand,SESS_LANGUAGE,index,frmJDistribution,vJDistribution,vlistCurrencyType,vBisnisCenter,accountId,periodId, approot);
String sListJDistribution = "";
if(vListJournalDistribution != null && vListJournalDistribution.size() > 0){
	sListJDistribution = vListJournalDistribution.get(0).toString();
	dDebetVal = Double.parseDouble(vListJournalDistribution.get(1).toString());
	dKreditVal = Double.parseDouble(vListJournalDistribution.get(2).toString());
}
%>

<html>
<head>
<title>Accounting Information System Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/login.css" type="text/css">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<script language="JavaScript" src="../main/dsj_common.js"></script>
<script type="text/javascript" src="../main/digitseparator.js"></script>
<script language="javascript">
    <% double amountDt=0, amountCr=0, amountSisa=0;%>
    
    window.focus();
    
function openJdAccount(){
                  
        
var strUrl = "coasearch_jdis.jsp?command=<%=Command.LIST%>"+
				 "&account_group=0"+
			"&account_number="+document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.account_code.value+
			"&dDebetAmount=<%=amountDt%>&dCreditAmount=<%=amountCr%>&dAmountSisa=<%=amountSisa%>";
                         //alert(strUrl);
   popcoa = window. open(strUrl,"src_account_jdetail","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
}

function openJdAccountY(){
                  
        //alert("hi");
	var strUrl = "coasearch_jdis.jsp?command=<%=Command.LIST%>"+
				 "&account_group=0"+
			"&account_number="+document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.account_code.value+
			"&dDebetAmount=<%=amountDt%>&dCreditAmount=<%=amountCr%>&dAmountSisa=<%=amountSisa%>";
                         alert(strUrl);
	window.location.href=strUrl;	
}
    
    
    
/*var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";*/	

var sysDecSymbol = ".";
var usrDigitGroup = ",";
var usrDecSymbol = ".";

function getText(element){
	parserNumber(element,false,0,'');
}

function addNew(){
	
    var prev = document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.index.value=-1;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.ADD%>";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.target="_self";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="j_distribution.jsp";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdSave(){
	var prev = document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.SAVE%>";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.target="_self";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="j_distribution.jsp";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdCancel(){
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.SAVE%>";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.target="_self";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="j_distribution.jsp";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdEdit(index){
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.index.value=index;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.EDIT%>";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value="<%=Command.EDIT%>";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.target="_self";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="j_distribution.jsp";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdAsk(index){
	var prev = document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.index.value=index;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.ASK%>";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.target="_self";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="j_distribution.jsp";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdDelete(index){
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.index.value=index;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.DELETE%>";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.target="_self";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="j_distribution.jsp";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}

function cmdItemData(journalId){
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.NONE%>";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.journal_id.value=journalId;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.target="_self";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="jumum.jsp";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}


function changeCurrType()  
{ 
	var iCurrType = document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_CURRENCY_ID]%>.value;
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
			 document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_TRANS_RATE]%>.value = "<%=Formater.formatNumber(objDailyRate.getBuyingAmount(), "###")%>";
			 document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_STANDARD_RATE]%>.value = "<%=Formater.formatNumber(objDailyRate.getSellingAmount(), "###")%>";
			break;
	<%	
		}	
	}
	%>			
		default :
			document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_TRANS_RATE]%>.value = "<%=Formater.formatNumber(1, "###")%>";
			 document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_STANDARD_RATE]%>.value = "<%=Formater.formatNumber(1, "###")%>";
			break;
	}
}

function processToJDetail()
{ 
		self.opener.document.forms.frmjournaldetail.<%=(bWeight?"TOTAL_DEBET":"DEBET")%>.value = "<%=dDebetVal%>";	
		self.opener.document.forms.frmjournaldetail.<%=(bWeight?"TOTAL_KREDIT":"KREDIT")%>.value = "<%=dKreditVal%>";
		self.close();
}

function cancelProcess()
{ 
	self.close();
}

function cmdClickBisnisCenter(jDistributionId,index)
{
    var prev = document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
    var prevIdx = document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.index.value;

	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.hidden_j_distribution_id.value=jDistributionId;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.index.value=index;
    document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_index.value=prevIdx;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.EDIT%>";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.action="j_distribution.jsp";
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.submit();
}
</script>
</head>
<body class="bodystyle" text="#000000">
<form name="<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>" method="post" action="">
<input type="hidden" name="command" value="<%=iCommand%>">
<input type="hidden" name="std_rate" value="<%=dCurrRateUsed%>">
<input type="hidden" name="hidden_j_distribution_id" value="<%=lJDistributionId%>">
<input type="hidden" name="index" value="<%=index%>">
<input type="hidden" name="prev_index" value="<%=prevIndex%>">
<input type="hidden" name="prev_command" value="<%=prevCommand%>">
<input type="hidden" name="standard_rt" value="">
<input type="hidden" name="account_id" value="<%=accountId%>">
<input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JOURNAL_DETAIL_ID]%>" value="<%=jDetail.getOID()%>">
<input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_PERIODE_ID]%>" value="<%=jUmum.getPeriodeId()%>">

  <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
    <tr> 
      <td width="3%" class="listgensell" valign="top">&nbsp; </td>
      <td width="94%" class="listgensell" valign="top">&nbsp;</td>
      <td width="3%" class="listgensell" valign="top">&nbsp;</td>
    </tr>
    <tr> 
      <td width="3%" class="listgensell" valign="top" height="25">&nbsp;</td>
      <td width="94%" class="listgensell" valign="top" height="25" align="center"><b><%=strTitle[SESS_LANGUAGE][0].toUpperCase()%>&nbsp;<%=strTitle[SESS_LANGUAGE][10].toUpperCase()%>&nbsp;<%=accName.toUpperCase()%></b></td>
      <td width="3%" class="listgensell" valign="top" height="25">&nbsp;</td>
    </tr>
    <tr> 
      <td height="25" colspan="3" valign="top" class="listgensell">
	   <%              									  	
        out.println(sListJDistribution);
       %>
	  </td>
    </tr>
	<tr> 
      <td colspan="3" class="msginfo"><div align="left"><%=strTitle[SESS_LANGUAGE][11]%> &nbsp;<b>:</b>&nbsp;<%=strTitle[SESS_LANGUAGE][12]%></div></td>
    </tr>
	<tr> 
      <td width="3%" class="listgensell">&nbsp;</td>
      <td width="94%" class="listgensell">&nbsp;</td>
      <td width="3%" class="listgensell">&nbsp;</td>
    </tr>
	<%if(iCommand == Command.ASK){%>
    <tr class="msgquestion">
      <td width="3%">&nbsp;</td>
      <td width="94%"><div align="center"><b><%=strConfirm%></b></div></td>
      <td width="3%">&nbsp;</td>
    </tr>
	 <tr> 
      <td width="3%" class="listgensell">&nbsp;</td>
      <td width="94%" class="listgensell">&nbsp;</td>
      <td width="3%" class="listgensell">&nbsp;</td>
    </tr>
	<%}%>
    <tr class="listgensell"> 
      <td width="3%" class="command">&nbsp;</td>
      <td width="94%" class="command">&nbsp;	  
	  	<%if(iCommand == Command.NONE || (iCommand == Command.SAVE && ctrlErr == 0) || iCommand == Command.DELETE){%>
		  	<a href="javascript:addNew()"><%=strAdd%></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:processToJDetail()"><%=strTitle[SESS_LANGUAGE][6]%></a> 
         	| <a href="javascript:cancelProcess()"><%=strTitle[SESS_LANGUAGE][7]%></a>  
	  	<%}else{%>
	  		<%if(iCommand == Command.EDIT){%>
	  			<a href="javascript:cmdSave()"><%=strSave%></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:cmdAsk('<%=index%>')"><%=strDelete%></a>	
			<%}else{%>
				<%if(iCommand == Command.ASK){%>
					<a href="javascript:cmdDelete('<%=index%>')"><%=strYesDelete%></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:cmdCancel()"><%=strCancel%></a>
				<%}else{%>
					<a href="javascript:cmdSave()"><%=strSave%></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:processToJDetail()"><%=strTitle[SESS_LANGUAGE][6]%></a>
                                         &nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:cancelProcess()"><%=strTitle[SESS_LANGUAGE][7]%></a>
				<%}%>
			<%}%>
	  	<%}%>
	  </td>
      <td width="3%" class="command">&nbsp;</td>
    </tr>
    <tr> 
      <td width="3%" class="listgensell">&nbsp;</td>
      <td width="94%" class="listgensell">&nbsp;</td>
      <td width="3%" class="listgensell">&nbsp;</td>
    </tr>
  </table>
<script language="javascript">
	//document.<%//=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.CURRENCY_TYPE.focus();
</script>
</form>
</body>
</html>
