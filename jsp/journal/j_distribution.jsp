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



%>

<%
int numRows = FRMQueryString.requestInt(request,"number_of_rows"); // jumlah baris yang akan ditampilkan
    numRows  = numRows==0 ? 5: numRows ; // set to 5 sbg default
int iCommand = FRMQueryString.requestCommand(request);
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long lCurrTypeOidUsed = FRMQueryString.requestLong(request,"curr_type_used");
double dCurrRateUsed = 1;
int index = FRMQueryString.requestInt(request,"index");
int prevIndex = FRMQueryString.requestInt(request,"prev_index");
long lJDistributionId = FRMQueryString.requestLong(request,"hidden_j_distribution_id");
long journalID = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JOURNAL_DETAIL_ID]);//"journal_id");
long accountId = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ID_PERKIRAAN]); 
long periodId = FRMQueryString.requestLong(request,""+FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_PERIODE_ID]); //"period_id");


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


Vector vBisnisCenter = PstBussinessCenter.list(0,0,"",PstBussinessCenter.fieldNames[PstBussinessCenter.FLD_BUSS_CENTER_NAME]);

JurnalDetail jDetail = null;
jDetail=jUmum.getJurnalDetailByCoaID(accountId);
if( jDetail==null){
    jDetail = new JurnalDetail();
    jDetail.setIdPerkiraan(accountId);
    jDetail.setIndex(jUmum.getJurnalDetails()==null?0:jUmum.getJurnalDetails().size());
    jUmum.addDetails(jDetail.getIndex(), jDetail);
}
index=jDetail.getIndex();
/** Create vector as object handle for transaction below */
        

/** if Command.SUBMIT, process adding or updating jurnal details in object jUmum */
if(iCommand==Command.SAVE){
	try{
            JournalDistribution jDistribution = null;            
            for(int ij=0; ij<numRows;ij++){                   
               long lJBCenter = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_BUSS_CENTER_ID]+"_"+ij);
               double dDebit = FRMQueryString.requestDouble(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_DEBIT_AMOUNT]+"_"+ij);
               double dCredit = FRMQueryString.requestDouble(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_CREDIT_AMOUNT]+"_"+ij);
               String sNote = FRMQueryString.requestString(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_NOTE]+"_"+ij);
               long lCurId = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_CURRENCY_ID]+"_"+ij);
               double dTransRate = FRMQueryString.requestDouble(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_TRANS_RATE]+"_"+ij);
               long lCoaID = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ID_PERKIRAAN]+"_"+ij);
               //long lPeriodId = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_PERIODE_ID]+"_"+ij);
               double dStdRate = FRMQueryString.requestDouble(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_STANDARD_RATE]+"_"+ij);

               long lArapMainId = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ARAP_MAIN_ID]+"_"+ij);
               long lArapPayId = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ARAP_PAYMENT_ID]+"_"+ij);
               //long lJournalDtlId = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JOURNAL_DETAIL_ID]+"_"+ij);
                             
               int iJdisIdx  = FRMQueryString.requestInt(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JDIS_INDEX]+"_"+ij);
               long lJdisOid = FRMQueryString.requestLong(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JDIS_OID]+"_"+ij);
               String sCoaCode = FRMQueryString.requestString(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]+"_"+ij);
               String sCoaName = FRMQueryString.requestString(request,FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]+"_"+ij);
               
               int iDel = FRMQueryString.requestInt(request, "delete_"+ij);
               
               jDistribution = new JournalDistribution();
               jDistribution.setBussCenterId(lJBCenter);
               jDistribution.setDebitAmount(dDebit);
               jDistribution.setCreditAmount(dCredit);
               jDistribution.setNote(sNote);
               jDistribution.setCurrencyId(lCurId);
               jDistribution.setTransRate(dTransRate);
               jDistribution.setIdPerkiraan(lCoaID);
               jDistribution.setPeriodeId(periodId);
               jDistribution.setStandardRate(dStdRate);               
               jDistribution.setArapMainId(lArapMainId);
               jDistribution.setArapPaymentId(lArapPayId);
               jDistribution.setJournalDetailId(journalID);
               jDistribution.setIndex(iJdisIdx);
               jDistribution.setOID(lJdisOid); 
               jDistribution.setCoaCode(sCoaCode);
               jDistribution.setCoaName(sCoaName);               
                              
                if(jDistribution.getOID()!=0) {               
                    if((iDel==1) || (jDistribution.getBussCenterId()==0)){
                      jDistribution.setDataStatus(PstJurnalDetail.DATASTATUS_DELETE);
                      jDistribution.setBussCenterId(0);
                      jDistribution.setCoaName("");
                      jDistribution.setIdPerkiraan(0);
                      jDistribution.setCreditAmount(0);
                      jDistribution.setDebitAmount(0);
                      jDistribution.setCurrencyId(0);                              
                     } else {
                      jDistribution.setDataStatus(PstJurnalDetail.DATASTATUS_UPDATE);
                      }
                    jDetail.updateJDistributions(jDistribution);                      
                } else {
                    if( (iDel!=1) && (jDistribution.getBussCenterId()!=0)){
                      jDistribution.setDataStatus(PstJurnalDetail.DATASTATUS_ADD);
                      jDetail.updateJDistributions(jDistribution);                      
                    }
                    //other when iDel=1 will not added to vector
                }
                dDebetVal=dDebetVal+jDistribution.getDebitAmount();
                dKreditVal=dKreditVal+jDistribution.getCreditAmount();
                                           
             }
        //if(numRows<=jDetail.getJournalDistributions().size()){
        //    numRows = jDetail.getJournalDistributions().size()+1;
        //}
        session.putValue(SessJurnal.SESS_JURNAL_MAIN,jUmum);
	}
	catch(Exception e){
		System.out.println("On Exception : "+e.toString());
	}
  }

Vector vJDistribution = jDetail.getJournalDistributions();
JurnalDetail.cleanUpJournalDistribution(vJDistribution);
if(vJDistribution==null){
    vJDistribution = new Vector();
}
if(vJDistribution.size()<numRows){
    do{
        JournalDistribution jDisT= new JournalDistribution();
        vJDistribution.add(jDisT);
    }while (vJDistribution.size()<numRows);
} else {
    if(vJDistribution.size()==numRows){
        JournalDistribution jDisT= new JournalDistribution();
        vJDistribution.add(jDisT);
        numRows=numRows+vJDistribution.size();
    } else{
        numRows = vJDistribution.size();
    }    
}

jDetail.indexJDistributionSyncronize(vJDistribution);

/** if Command.ASK, check detail's availability */
String msgAvailability = "";

// get masterdata currency
String sOrderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector vlistCurrencyType = PstCurrencyType.list(0, 0, "", sOrderBy);

// get masterdata standart rate
String sStRateWhereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS] + " = " + PstStandartRate.ACTIVE;
String sStRateOrderBy = PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE] + 
						", " + PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE];
Vector vlistRate = SessDailyRate.getDataCurrency();
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
    
function openJdAccount(idx, coa){
                  
 //alert(idx+" & "+coa);       
var strUrl = "coasearch_jdis.jsp?command=<%=Command.LIST%>&<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JDIS_INDEX]%>="+idx+
				 "&account_group=0"+
			"&<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>_"+idx+"="+coa+
			"&<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_DEBIT_AMOUNT]%>"+idx+"=<%=amountDt%>"+
                        "&d<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_CREDIT_AMOUNT]%>"+idx+"=<%=amountCr%>&dAmountSisa=<%=amountSisa%>";
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

function setSameCoa(){        
	oid=document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ID_PERKIRAAN]%>_0.value;
	code=document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>_0.value;
	name=document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]%>_0.value;         
        
        <%
         for(int ij=1;ij<numRows;ij++){ %>
            document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ID_PERKIRAAN]%>_<%=ij%>.value=oid;
            document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%>_<%=ij%>.value=code;
            document.forms.<%=FrmJournalDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]%>_<%=ij%>.value=name;                      
            <%
         }
        
        %>
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
         //alert("H1"+document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value);
	//var prev = document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value;
	document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.command.value="<%=Command.SAVE%>";
         
         //alert("H1"+document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value);

        //document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.prev_command.value=prev;
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

<% 
  for(int it = 0; it<vJDistribution.size();it++){                                      
%>

function changeCurrType_<%=it%>(idx)  
{ 
        //alert("hi");
	var iCurrType = document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_CURRENCY_ID]%>_<%=it%>.value;
        //alert(iCurrType);
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
                             document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_TRANS_RATE]%>_<%=it%>.value = "<%=Formater.formatNumber(objDailyRate.getBuyingAmount(), "###")%>";
                             document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_STANDARD_RATE]%>_<%=it%>.value = "<%=Formater.formatNumber(objDailyRate.getSellingAmount(), "###")%>";
                            break;
            <%	
                    }	
            }
            %>			
                    default :
                            document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_TRANS_RATE]%>_<%=it%>.value = "<%=Formater.formatNumber(1, "###")%>";
                             document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=frmJDistribution.fieldNames[frmJDistribution.FRM_STANDARD_RATE]%>_<%=it%>.value = "<%=Formater.formatNumber(1, "###")%>";
                            break;
            }                 
}

<%}%>


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
<input type="hidden" name="index" value="<%=index%>">
<input type="hidden" name="standard_rt" value="">
<input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ID_PERKIRAAN]%>" value="<%=jDetail.getIdPerkiraan()%>">
<input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JOURNAL_DETAIL_ID]%>" value="<%=jDetail.getOID()%>">
<input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_PERIODE_ID]%>" value="<%=jUmum.getPeriodeId()%>">

  <table width="100%" border="0" cellpadding="0" cellspacing="0" height="25">
    <tr> 
      <td width="3%" class="listgensell" valign="top" height="25">&nbsp;</td>
      <td width="82%" class="listgensell" valign="top" height="25" align="left"><b><%=strTitle[SESS_LANGUAGE][0].toUpperCase()%>&nbsp;<%=strTitle[SESS_LANGUAGE][10].toUpperCase()%>&nbsp;<%=accName.toUpperCase()%></b></td>
      <td width="15%" class="listgensell" valign="top" height="25" nowrap>Rows number :      
      <input name="number_of_rows" type="text" value="<%=numRows%>" size="4" maxlength="4"></td>
    </tr>
    <tr> 
      <td height="25" colspan="3" valign="top" class="listgensell">
	   <table width="100%" border="0" class="listgen" cellspacing="1">
               <tr>
                   <td width="15%" class="listgentitle">
                       <div align="center">Bisnis Center</div>                   </td>
                   <td width="15%" class="listgentitle">
                   <div align="center">COA &nbsp;&nbsp;<a href="javascript:setSameCoa()">Set Same Coa</a> </div></td>
                   <td width="5%" class="listgentitle">
                       <div align="center">Currency</div>                   </td>
                   <td width="10%" class="listgentitle">
                       <div align="center">Rate(Rp)</div>                   </td>
                   <td width="25%" class="listgentitle">
                       <div align="center">Debet(Rp)</div>                   </td>
                   <td width="25%" class="listgentitle">
                       <div align="center">Credit(Rp)</div>                   </td>
                   <td width="25%" class="listgentitle">ACTION</td>  
            </tr>
            <%
	accName ="";
	
	Vector currencytypeid_value = new Vector(1,1);
	Vector currencytypeid_key = new Vector(1,1);
	String selectedCurrType = "";
	double totDebet = 0.0;
	double totCredit = 0.0;
	
	if(vlistCurrencyType!=null && vlistCurrencyType.size()>0){
		for(int it=0; it<vlistCurrencyType.size(); it++){
			CurrencyType currencyType =(CurrencyType)vlistCurrencyType.get(it);			
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
	
	JournalDistribution jDistribution = null;
        if(vJDistribution==null){
            vJDistribution = new Vector();
        }
        if(vJDistribution.size()<numRows){
            do{
                vJDistribution.add(new JournalDistribution());
            }while (vJDistribution.size()<numRows);
        }
        
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
                         /*
                         String coaCode ="-";
                         String coaName ="-";
                         try {
                             Perkiraan objCoa = PstPerkiraan.fetchExc(coaId);
                             coaCode = objCoa.getNoPerkiraan();
                             coaName = getAccName(SESS_LANGUAGE, objCoa);
                         } catch(Exception exc){
                             System.out.println(exc);
                         }*/
			 
			 String currName = "";
			 CurrencyType currencyType = new CurrencyType();
			 if(jDistribution.getCurrencyId() != 0)
			 {
			 	try{
					currencyType = PstCurrencyType.fetchExc(jDistribution.getCurrencyId());
					currName = currencyType.getName()+"("+currencyType.getCode()+")";
				}catch(Exception e){}
			 }            
                        totDebet += jDistribution.getDebitAmount();
                        totCredit += jDistribution.getCreditAmount();
            %>
            <tr>
                <td class="tabtitlehidden">
                    <div align="left">
                       <input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JDIS_INDEX]%><%=("_"+it)%>" size="15" value="<%=it %><%//jDistribution.getIndex()%>" >                                           
                       <input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_JDIS_OID]%><%=("_"+it)%>" size="15" value="<%=jDistribution.getOID()%>" >                                           
                       <%=ControlCombo.draw((FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_BUSS_CENTER_ID]+"_"+it), "-", selectedBisnisCenter, vBisnisCenterVal, vBisnisCenterKey,"","")%>                    </div>                </td>
               <td class="tabtitlehidden">
                   <div align="right">
                       <input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_ID_PERKIRAAN]%><%=("_"+it)%>" size="15" value="<%=jDistribution.getIdPerkiraan()%>">                                            
                       <input type="text" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%><%=("_"+it)%>" size="10" value="<%=jDistribution.getCoaCode()%>" class="txtalign">&nbsp; 
                       <a href="javascript:openJdAccount(<%=it%>,document.<%=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_CODE]%><%=("_"+it)%>.value)"><img border="0" src="/aiso/dtree/img/folderopen.gif"></a>
                       &nbsp;<input type="text" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_COA_NAME]%><%=("_"+it)%>" size="25" readonly value="<%=jDistribution.getCoaName()%>">
                   </div>               </td>
               <td class="tabtitlehidden">
                   <div align="left">
                        <%=ControlCombo.draw((FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_CURRENCY_ID]+"_"+it), null,
                          selectedCurrType, currencytypeid_value, currencytypeid_key,("onChange=\"javascript:changeCurrType_"+it+"()\""),"")%>                    </div>                    </td>
                <td class="tabtitlehidden">
                    <div align="right">                        
                        <input type="text" readOnly name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_TRANS_RATE]%><%=("_"+it)%>" size="10" value="<%=FrmJournalDistribution.userFormatStringDecimal(jDistribution.getTransRate()>0.0?jDistribution.getTransRate():1.0)%>" class="txtalign">
			<input type="hidden" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_STANDARD_RATE]%><%=("_"+it)%>" value="<%=FrmJournalDistribution.userFormatStringDecimal(jDistribution.getStandardRate())%>" >                            
                    </div>                </td>					
                <td class="tabtitlehidden">
                    <div align="right">
                        <input type="text" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_DEBIT_AMOUNT]%><%=("_"+it)%>" size="15" value="<%=FrmJournalDistribution.userFormatStringDecimal(jDistribution.getDebitAmount())%>" class="txtalign">
                    </div>                </td>
                <td class="tabtitlehidden">
                    <div align="right">
                        <input type="text" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_CREDIT_AMOUNT]%><%=("_"+it)%>" size="15" value="<%=FrmJournalDistribution.userFormatStringDecimal(jDistribution.getCreditAmount())%>" class="txtalign">
                    </div>                </td>
                <td class="tabtitlehidden"><input type="checkbox" name="delete_<%=it%>" value="1">Delete</td>                
              </tr>
              <tr>
                  <td colspan="7" class="listgensell"><div align="left"><b><%=strTitle[SESS_LANGUAGE][1]%> : </b>
                  <input type="text" name="<%=FrmJournalDistribution.fieldNames[FrmJournalDistribution.FRM_NOTE]%><%=("_"+it)%>" size="100" value="<%=jDistribution.getNote()%>" ></div></td>
              </tr>
              <%}%>
              <tr>
                  <td colspan="4" class="tabtitlehidden"><div align="right"><b>TOTAL</b></div></td>
                  <td class="tabtitlehidden"><div align="right"><%=FrmJournalDistribution.userFormatStringDecimal(totDebet)%></div></td><td class="tabtitlehidden"><div align="right"><%=FrmJournalDistribution.userFormatStringDecimal(totCredit)%></div></td>
                  <td class="tabtitlehidden">&nbsp;</td>
              </tr>
            <%}
            vJDistribution = jDetail.getJournalDistributions();
            JurnalDetail.cleanUpJournalDistribution(vJDistribution);         
        %>
         </table>	</td>
    </tr>
	<tr> 
      <td colspan="3" class="msginfo"><div align="left"><%=strTitle[SESS_LANGUAGE][11]%> &nbsp;<b>:</b>&nbsp;<%=strTitle[SESS_LANGUAGE][12]%></div></td>
    </tr>
	<tr> 
      <td width="3%" class="listgensell">&nbsp;</td>
      <td width="82%" class="listgensell">&nbsp;</td>
      <td width="15%" class="listgensell">&nbsp;</td>
    </tr>
    <tr class="listgensell"> 
      <td width="3%" class="command">&nbsp;</td>
      <td width="82%" class="command">&nbsp;	
        <a href="javascript:cmdSave()"><%=strSave%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
        <a href="javascript:processToJDetail()"><%=strTitle[SESS_LANGUAGE][6]%></a> 
        | <a href="javascript:cancelProcess()"><%=strTitle[SESS_LANGUAGE][7]%></a>  
      </td>
      <td width="15%" class="command">&nbsp;</td>
    </tr>
    <tr> 
      <td width="3%" class="listgensell">&nbsp;</td>
      <td width="82%" class="listgensell">&nbsp;</td>
      <td width="15%" class="listgensell">&nbsp;</td>
    </tr>
  </table>
<script language="javascript">
	//document.<%//=frmJDistribution.FRM_JOURNAL_DISTRIBUTION%>.CURRENCY_TYPE.focus();
function processToJDetail()
{ 
		self.opener.document.forms.frmjournaldetail.<%=(bWeight?"TOTAL_DEBET":"DEBET")%>.value = "<%=FrmJournalDistribution.userFormatStringDecimal(totDebet)%>";	
		self.opener.document.forms.frmjournaldetail.<%=(bWeight?"TOTAL_KREDIT":"KREDIT")%>.value = "<%=FrmJournalDistribution.userFormatStringDecimal(totCredit)%>";
                self.opener.document.forms.frmjournaldetail.back_from_jdistribution.value = "1";
                self.opener.document.forms.frmjournaldetail.index.value = "<%=jDetail.getIndex()%>";
		self.close();
}
         
</script>
</form>
</body>
</html>
