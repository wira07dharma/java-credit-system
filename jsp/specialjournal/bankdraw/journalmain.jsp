<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.common.entity.contact.ContactList,
                   com.dimata.common.entity.contact.PstContactList,
				   com.dimata.aiso.session.report.SessGeneralLedger" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import="com.dimata.common.entity.payment.PstCurrencyType"%>
<%@ page import="com.dimata.aiso.form.specialJournal.CtrlSpecialJournalMain"%>
<%@ page import="com.dimata.aiso.session.specialJournal.SessSpecialJurnal"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.SpecialJournalMain"%>
<%@ page import="com.dimata.aiso.form.specialJournal.FrmSpecialJournalMain"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.SpecialJournalDetail"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.SpecialJournalDetailAssignt"%>
<%@ page import="com.dimata.common.entity.payment.PstStandartRate"%>
<%@ page import="com.dimata.aiso.entity.masterdata.*"%>
<%@ page import="com.dimata.harisma.entity.masterdata.*"%>
<%@ page import="com.dimata.common.entity.payment.StandartRate"%>
<%@ page import="com.dimata.aiso.entity.masterdata.PstAccountLink"%>
<%@ page import="com.dimata.aiso.entity.masterdata.PstPerkiraan"%>
<%@ page import="com.dimata.aiso.entity.masterdata.Perkiraan"%>
<%@ page import="com.dimata.common.entity.payment.CurrencyType"%>
<%@ page import="com.dimata.interfaces.journal.I_JournalType"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.PstSpecialJournalMain"%>
<%@ page import = "com.dimata.common.form.search.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%
/** Check privilege except VIEW, view is already checked on checkuser.jsp as basic access */
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));
%>

<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static final int INT_VALID_DELETE = 0;
public static final int INT_INVALID_DELETE = 1;

public static String strTitleMain[][] = {
	{
		"Perkiraan Bank",//0
		"Saldo Akhir",//1
		"Nomor Jurnal",//2
		"Tanggal Jurnal",//3
		"Bayar atas perintah",//4
		"No.",//5
		"Alamat",//6
		"Tanggal",//7
		"Memo",//8
		"Total Bayar",//9
		"Cari"//10
	},
	
	{
		"Bank Account",//0
		"Ending Balance",//1
		"Voucher Number",//2
		"Voucher Date",//3
		"Pay to the order of",//4
		"No.",//5
		"Address",//6
		"Date",//7
		"Memo",//8
		"Total Payment",//9
		"Search"
	}
};
public static String strTitle[][] =
{
	{
		"Departemen",//0
		"Aktivitas",//1
		"Saldo Anggaran",//2
		"Nama",//3
		"Mata Uang",//4
		"Kurs",//5
		"Jumlah",//6
		"Catatan",//7
		"Perkiraan",//8
		"Prosentase",//9
		"Dibuat Oleh",//10
		"Disetujui Oleh"//11
	}
	,
	{		
		"Department",//0
		"Activity",//1
		"Budget Balance",//2
		"Name",//3
		"Currency",//4
        "Rate",//5
        "Amount",//6
        "Memo",//7
		"Account",//8
        "Share Procentage",//9
		"Prepared By",//10
		"Approved By"//11
	}
};

public static final String masterTitle[] = {
	"Jurnal Khusus","Special Journal"
};

public static final String listTitle[] = {
	"Transaksi","Transaction"
};

public static final String subMasterTitle[] = {
	"Jurnal Pengeluaran Bank","Cheque Request Journal"
};

public static final String strCekAmountTransaction[][] = {
	{"Nilai transaksi melebihi saldo","Nilai transaksi tidak boleh nol"},
	{"Transaction Over than Balance Amount","Transaction value has to be greater than zero"}
};

private static String cekNull(String objString){
	if(objString == null)
		return "-";
	else
		return objString;	
}

private static boolean cekValue(double dValue){
	if(dValue != 0)
		return true;
	else
		return false;	
}

private String getAccountName(Perkiraan objPerkiraan, int iLanguage){
	if(iLanguage == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
		return objPerkiraan.getAccountNameEnglish();
	}else{
		return objPerkiraan.getNama();
	}
}

public Vector listJurnalDetail(int language,
                                   Vector objectClass,String approot, String updateJournal, int iCommand){
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
		ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.addHeader(strTitle[language][0],"15%");
        ctrlist.addHeader(strTitle[language][1],"15%");
        ctrlist.addHeader(strTitle[language][2],"15%");
        ctrlist.addHeader(strTitle[language][3],"15%");
        ctrlist.addHeader(strTitle[language][4],"5%");
        ctrlist.addHeader(strTitle[language][5],"5%");
        ctrlist.addHeader(strTitle[language][6],"15%");
		ctrlist.addHeader(strTitle[language][7],"15%");
        
		Vector vResult = new Vector(1,1);
		Vector vDataPdf = new Vector(1,1);
        Vector lstData = ctrlist.getData();
        Vector rowx = new Vector(1,1);
		Vector rowy = new Vector(1,1);
        ctrlist.reset();
        if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){
        	ctrlist.setLinkRow(1);
		}
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdItemData('");
		ctrlist.setLinkSufix("')");

        // department
        Vector vectDeptKey = new Vector();
        Vector vectDeptName = new Vector();
        // currency
        Vector currencytypeid_value = new Vector(1,1);
        Vector currencytypeid_key = new Vector(1,1);
		
		String strAccName = "";
		double saldo = 0;
		
        for(int i=0; i<objectClass.size(); i++){
            Vector temp = (Vector)objectClass.get(i);

            SpecialJournalDetail specJournalDetail = (SpecialJournalDetail)temp.get(0); // if ada
            SpecialJournalDetailAssignt specialJournalDetailAssignt = (SpecialJournalDetailAssignt)temp.get(1);
			
			saldo = specJournalDetail.getBudgetBalance();

            // getNama activity
            Activity activity = new Activity();
            try{
                activity = PstActivity.fetchExc(specialJournalDetailAssignt.getActivityId());
            }catch(Exception e){
				activity = new Activity();
			}			
					
            
            ContactList contactList = new ContactList();
            try{
                contactList = PstContactList.fetchExc(specJournalDetail.getContactId());
            }catch(Exception e){}

            CurrencyType objectCurrencyType =new CurrencyType();
            try{
                objectCurrencyType = PstCurrencyType.fetchExc(specJournalDetail.getCurrencyTypeId());
            }catch(Exception e){contactList = new ContactList();}


            Department deptObject = new Department();
            try{
                deptObject = PstDepartment.fetchExc(specJournalDetail.getDepartmentId());
            }catch(Exception e){deptObject = new Department();}

            rowx = new Vector();
			rowx.add(deptObject.getDepartment());
			rowx.add("<div align=\"left\">"+activity.getDescription()+"</div>");
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(saldo)+"</div>");
			rowx.add("<div align=\"left\">"+contactList.getCompName()==null?contactList.getPersonName():contactList.getCompName()+"</div>");
			rowx.add("<div align=\"center\">"+objectCurrencyType.getCode()+"</div>");
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(specJournalDetail.getCurrencyRate())+"</div>");
			rowx.add("<div align=\"right\">"+Formater.formatNumber((specJournalDetail.getAmount() / specJournalDetail.getCurrencyRate()), "##,###.##")+"</div>");
			rowx.add("<div align=\"left\">"+specJournalDetail.getDescription()+"</div>");
            
			rowy = new Vector(1,1);
			rowy.add(deptObject.getDepartment());
			rowy.add(activity.getDescription());
			rowy.add(FRMHandler.userFormatStringDecimal(saldo));
			rowy.add(contactList.getCompName()==null?contactList.getPersonName():contactList.getCompName());
			rowy.add(objectCurrencyType.getCode());
			rowy.add(FRMHandler.userFormatStringDecimal(specJournalDetail.getCurrencyRate()));
			rowy.add(Formater.formatNumber((specJournalDetail.getAmount() / specJournalDetail.getCurrencyRate()), "##,###.##"));
			rowy.add(specJournalDetail.getDescription());			
			vDataPdf.add(rowy);
			
			lstData.add(rowx);
			lstLinkData.add(""+i);
        }
		vResult.add(ctrlist.draw());
		vResult.add(vDataPdf);
        return vResult;
    }

public Vector listJurnalDetailCoA(int iCommand, int language,Vector objectClass,String updateJournal){
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
		ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.addHeader(strTitle[language][0],"15%");
        ctrlist.addHeader(strTitle[language][8],"15%");
        ctrlist.addHeader(strTitle[language][3],"15%");
        ctrlist.addHeader(strTitle[language][4],"5%");
        ctrlist.addHeader(strTitle[language][5],"5%");
        ctrlist.addHeader(strTitle[language][6],"15%");
		ctrlist.addHeader(strTitle[language][7],"15%");
        

        Vector lstData = ctrlist.getData();
		Vector vResult = new Vector(1,1);
		Vector vDataPdf = new Vector(1,1);
        Vector rowx = new Vector(1,1);
		Vector rowy = new Vector(1,1);
        ctrlist.reset();
        if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){
        	ctrlist.setLinkRow(1);
		}

        // department
        Vector vectDeptKey = new Vector();
        Vector vectDeptName = new Vector();
        // currency
        Vector currencytypeid_value = new Vector(1,1);
        Vector currencytypeid_key = new Vector(1,1);
		
		Vector vAccValue = new Vector();
		Vector vAccKey = new Vector();
		String strAccName = "";
		Perkiraan objPerkiraan = new Perkiraan();
		
        for(int i=0; i<objectClass.size(); i++){
            Vector temp = (Vector)objectClass.get(i);

            SpecialJournalDetail specJournalDetail = (SpecialJournalDetail)temp.get(0); // 

            // getNama contanct
            ContactList contactList = new ContactList();
            try{
                contactList = PstContactList.fetchExc(specJournalDetail.getContactId());
            }catch(Exception e){}

            CurrencyType objectCurrencyType =new CurrencyType();
            try{
                objectCurrencyType = PstCurrencyType.fetchExc(specJournalDetail.getCurrencyTypeId());
            }catch(Exception e){}


            Department deptObject = new Department();
            try{
                deptObject = PstDepartment.fetchExc(specJournalDetail.getDepartmentId());
            }catch(Exception e){}

            
			if(specJournalDetail.getIdPerkiraan() != 0){
				try{
					objPerkiraan = PstPerkiraan.fetchExc(specJournalDetail.getIdPerkiraan());
					if(objPerkiraan != null){
						strAccName = getAccountName(objPerkiraan,language);
					}
				}catch(Exception e){}	
			}
			
			rowx = new Vector();
			rowx.add(deptObject.getDepartment());
			rowx.add("<div align=\"left\">"+strAccName+"</div>");
			rowx.add("<div align=\"left\">"+contactList.getCompName()==null?contactList.getPersonName():contactList.getCompName()+"</div>");
			rowx.add("<div align=\"center\">"+objectCurrencyType.getCode()+"</div>");
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(specJournalDetail.getCurrencyRate())+"</div>");
			rowx.add("<div align=\"right\">"+Formater.formatNumber((specJournalDetail.getAmount() / specJournalDetail.getCurrencyRate()), "##,###.##")+"</div>");
			rowx.add("<div align=\"left\">"+specJournalDetail.getDescription()+"</div>");
            lstData.add(rowx);
			
			rowy = new Vector();
			rowy.add(deptObject.getDepartment());
			rowy.add(strAccName);
			rowy.add(contactList.getCompName()==null?contactList.getPersonName():contactList.getCompName());
			rowy.add(objectCurrencyType.getCode());
			rowy.add(FRMHandler.userFormatStringDecimal(specJournalDetail.getCurrencyRate()));
			rowy.add(Formater.formatNumber((specJournalDetail.getAmount() / specJournalDetail.getCurrencyRate()), "##,###.##"));
			rowy.add(specJournalDetail.getDescription());
            vDataPdf.add(rowy);
        }

		vResult.add(ctrlist.draw());
		vResult.add(vDataPdf);
        return vResult;
    }
    /**
     * untuk pengecekan di data sesion jika data
     * aktivity yang di kasukkan sudah ada di list
     * @param specialJournalDetail
     * @param specialJournalDetailAssignt
     * @param list
     */
    public int cekDataActivity(SpecialJournalDetail specialJournalDetail,
                               SpecialJournalDetailAssignt specialJournalDetailAssignt, Vector list){
        if(list!=null && list.size()>0){
            for(int k=0;k<list.size();k++){
                Vector temp = (Vector)list.get(k);
                SpecialJournalDetail specJournalDetail = (SpecialJournalDetail)temp.get(0); // if ada
                SpecialJournalDetailAssignt specialJournalDetailAssig = (SpecialJournalDetailAssignt)temp.get(1);
                if(specialJournalDetail.getIdPerkiraan()==specJournalDetail.getIdPerkiraan() &&
                        specialJournalDetailAssignt.getActivityId()==specialJournalDetailAssig.getActivityId() &&
                        specialJournalDetail.getContactId()==specJournalDetail.getContactId()
                        ){
                    return k;
                }
            }
        }
        return -1;
    }

    /**
     * get total activity
     * @param list
     */
    public double getAmountActivity(Vector list){
        double total = 0.0;
        if(list!=null && list.size()>0){
            for(int k=0;k<list.size();k++){
                Vector temp = (Vector)list.get(k);
                SpecialJournalDetail specJournalDetail = (SpecialJournalDetail)temp.get(0);
                total = total + (specJournalDetail.getAmount());
            }
        }
        return total;
    }

%>
<!-- JSP Block -->
<%
// get request from hidden text
showMenu = false;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE JOURNAL PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES JURNAL SEBELUM MELAKUKAN PROSES LAIN";

int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int addType = FRMQueryString.requestInt(request,"add_type");
long journalID = FRMQueryString.requestLong(request,"journal_id");
int accountGroup = FRMQueryString.requestInt(request,"account_group");
int index = FRMQueryString.requestInt(request,"index");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long idAccount = FRMQueryString.requestLong(request,"perkiraan");
boolean fromGL = FRMQueryString.requestBoolean(request,"fromGL");
long accountId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERKIRAAN);
long periodId = FRMQueryString.requestLong(request,SessGeneralLedger.FRM_NAMA_PERIODE);
String numberP = FRMQueryString.requestString(request,"ACCOUNT_NUMBER");
String namaP = FRMQueryString.requestString(request,"ACCOUNT_TITLES");
Date startDate = FRMQueryString.requestDate(request,"START_DATE_GL");
Date endDate = FRMQueryString.requestDate(request,"END_DATE_GL");
long getTimeMenu = FRMQueryString.requestLong(request,"get_time_menu");
long getTimeMenuLocal = FRMQueryString.requestLong(request,"get_time_menu_local");
/**
* Declare Commands caption
*/

String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Journal" : "Simpan Jurnal";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save and Add New Detail" : "Simpan dan Tambah Baru Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Special Journal List" : "Kembali Ke Daftar Jurnal Khusus";
if(fromGL){
	strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To General Ledger List" : "Kembali ke Buku Besar";
}
String strPosted = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Posted Journal" : "Posted Jurnal";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Journal" : "Hapus Jurnal";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strMsgDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure Delete Journal" : "Yakin Hapus Jurnal";
String strRate = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Bookkeeping Rate : " : "Kurs Standar : ";
String strMaxCaracter = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Required and Maximum 200 Character" : "Dibutuhkan dan Maksimum 200 Karakter";
String strRequired = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Required" : "Dibutuhkan";
String printJournal = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Print Journal" : "Cetak Jurnal";
long periodeOID = PstPeriode.getCurrPeriodId();
String msgErr = "";
String msgString = "";
FrmSrcContactList frmSrcContactList = new FrmSrcContactList();
NumberSpeller numberSpeller = new NumberSpeller();
    /** Instansiasi object CtrlJurnalUmum and FrmJurnalUmum */
	CurrencyType currType = new CurrencyType();
    CtrlSpecialJournalMain ctrlSpecialJournalMain = new CtrlSpecialJournalMain(request);
    ctrlSpecialJournalMain.setLanguage(SESS_LANGUAGE);
    FrmSpecialJournalMain frmSpecialJournalMain = ctrlSpecialJournalMain.getForm();
	frmSpecialJournalMain.setDigitSeparator(",");
	frmSpecialJournalMain.setDecimalSeparator(".");
	int ctrlErr =  0;
    if(journalID==0){
		ctrlErr = ctrlSpecialJournalMain.action(iCommand, journalID, userOID);
	}else{
		if(iCommand==Command.POST){
			ctrlErr = ctrlSpecialJournalMain.action(Command.SAVE, journalID, userOID);
		}else{
			ctrlErr = ctrlSpecialJournalMain.action(iCommand, journalID, userOID);
		}	
	}
	msgString = ctrlSpecialJournalMain.getMessage();
	
    SpecialJournalMain objSpecialJournalMain = ctrlSpecialJournalMain.getSpecialJournalMain();
    Vector objectClass = new Vector();
	try{
    	objectClass = (Vector)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
	}catch(Exception e){}	
    if(objectClass==null)
        objectClass = new Vector();
		
	if(getTimeMenu != 0){
		if(getTimeMenuLocal != getTimeMenu){
			journalID = 0;
			iCommand = Command.NONE;
			objectClass = new Vector();
		}	
		getTimeMenuLocal = getTimeMenu;
	}
    /** Saving object jurnalumum into session */
    if(objSpecialJournalMain.getOID()==0){
		if(iCommand == Command.NONE){		
			session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
			session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
			objSpecialJournalMain = new SpecialJournalMain();		
		}
        if(iCommand==Command.POST){
			if(objSpecialJournalMain.getAmount() != 0 && 
				objSpecialJournalMain.getDescription() != null &&
				objSpecialJournalMain.getDescription().length() > 0 &&
				objSpecialJournalMain.getContactId() != 0 		 	
			){
				try{ // ini digunakan untuk nyimpan data ke session saat tombol post
					objSpecialJournalMain.setAmount(objSpecialJournalMain.getAmount() * objSpecialJournalMain.getStandarRate());
					session.putValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL,objSpecialJournalMain);
				}catch(Exception e){
					System.out.println("gagal insert to session");
				}
			}else{
				objSpecialJournalMain.setAmount(objSpecialJournalMain.getAmount() * objSpecialJournalMain.getStandarRate());
			}
        }else{ // ini di gunakan tambah jurnal tapi tidak command post
            if(iCommand==Command.ADD){
                try{
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
                    objSpecialJournalMain = new SpecialJournalMain();
					objectClass = new Vector();
                }catch(Exception e){
					System.out.println("Exception on ADD ::: "+e.toString());
					objSpecialJournalMain = new SpecialJournalMain();
				}
            }else{
				try{
					objSpecialJournalMain = (SpecialJournalMain)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
					if(objSpecialJournalMain==null)
						objSpecialJournalMain = new SpecialJournalMain();
				}catch(Exception e){
					System.out.println("Exception on non Command ADD ::: "+e.toString());
					objSpecialJournalMain = new SpecialJournalMain();
				}
            }
        }
    }else{
        if(iCommand==Command.POST){
            try{ // ini digunakan untuk nyimpan data ke session saat tombol post				
				try{
					session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
				}catch(Exception e){}	
                session.putValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL,objSpecialJournalMain);
            }catch(Exception e){
				System.out.println("gagal insert to session");
			}
        }else{ // ini di gunakan tambah jurnal tapi tidak command post
            if(iCommand==Command.NONE){
                try{					
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
                    objSpecialJournalMain = new SpecialJournalMain();
                }catch(Exception e){
					System.out.println("Exception on command none :::: "+e.toString());
					objSpecialJournalMain = new SpecialJournalMain();
				}
			}else if(iCommand==Command.EDIT){
				try{ // ini digunakan untuk nyimpan data ke session saat tombol post
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
					session.putValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL,objSpecialJournalMain);
					session.putValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL,objSpecialJournalMain.getActivity());
					objectClass = (Vector)objSpecialJournalMain.getActivity();
				}catch(Exception e){
					System.out.println("gagal insert to session");
				}
            }else if(iCommand==Command.DELETE){						
				try{ // ini digunakan untuk nyimpan data ke session saat tombol post				
					ctrlSpecialJournalMain.journalDelete(objSpecialJournalMain.getOID());	
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
					objSpecialJournalMain = new SpecialJournalMain();
					objectClass = (Vector)objSpecialJournalMain.getActivity();
				}catch(Exception e){
					System.out.println("gagal insert to session");
				}
				
			}else{
				try{
					objSpecialJournalMain = (SpecialJournalMain)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
					if(objSpecialJournalMain==null)
						objSpecialJournalMain = new SpecialJournalMain();
				}catch(Exception e){
					System.out.println("Exception on non command delete ::: "+e.toString());
					objSpecialJournalMain = new SpecialJournalMain();
				}
            }
        }
    }
	
    String contactName = "";
    ContactList contactList = new ContactList();

    /** if Command.POST and no error occur, redirect to journal detail page */
    try{        
        contactList = PstContactList.fetchExc(objSpecialJournalMain.getContactId());
        contactName = contactList.getCompName();
        if(contactName.length()==0)
            contactName = contactList.getPersonName()+" "+contactList.getPersonLastname();
    }catch(Exception e){
		contactList = new ContactList();
	}
	
    // get user department from data custom
    Vector vDepartmentOid = new Vector(1,1);
    Vector vUsrCustomDepartment = PstDataCustom.getDataCustom(userOID, "hrdepartment");
    if(vUsrCustomDepartment!=null && vUsrCustomDepartment.size()>0){
        int iDataCustomCount = vUsrCustomDepartment.size();
        for(int i=0; i<iDataCustomCount; i++){
            DataCustom objDataCustom = (DataCustom) vUsrCustomDepartment.get(i);
            vDepartmentOid.add(objDataCustom.getDataValue());
        }
    }
    Periode currPeriod = new Periode();
    try{
        currPeriod = PstPeriode.fetchExc(periodeOID);
    }catch(Exception e){
		currPeriod = new Periode();
    }

Vector vSoAkhir = new Vector();
if(objSpecialJournalMain.getIdPerkiraan() > 0){
	vSoAkhir = SessSpecialJurnal.getTotalSaldoAccountLink(periodeOID, objSpecialJournalMain.getIdPerkiraan());
}

// get masterdata currency
String sOrderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector vlistCurrencyType = PstCurrencyType.list(0, 0, "", sOrderBy);

// get masterdata standart rate
String sStRateWhereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS] + " = " + PstStandartRate.ACTIVE;
String sStRateOrderBy = PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE] +
						", " + PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE];
Vector vlistStandartRate = PstStandartRate.list(0, 0, sStRateWhereClause, sStRateOrderBy);

StandartRate objStandartRate = new StandartRate();

    Vector vSaldoAkhir = SessSpecialJurnal.getTotalSaldoAccountLink(periodeOID,0);
        if(ctrlErr ==0 && iCommand==Command.POST && 
			objSpecialJournalMain.getContactId()!=0 && 
			objSpecialJournalMain.getAmount() > 0 && 
			objSpecialJournalMain.getReference().length()>0){
			
				response.sendRedirect("journaldetail.jsp?iCommand=Command.EDIT");        
        
             }

try{
	currType = PstCurrencyType.fetchExc(objSpecialJournalMain.getCurrencyTypeId());
}catch(Exception e){
	currType = new CurrencyType();
} 
											 			 
Vector vTitleMain = new Vector(1,1);			 
for(int i = 0; i < strTitleMain[SESS_LANGUAGE].length; i++){
	vTitleMain.add(strTitleMain[SESS_LANGUAGE][i]);			
}
Vector vHeaderDetail = new Vector(1,1);
for(int j = 0; j < strTitle[SESS_LANGUAGE].length; j++){
	vHeaderDetail.add(strTitle[SESS_LANGUAGE][j]);			
}



double salakhir = 0.0;
if(vSoAkhir !=null && vSoAkhir.size()>0){
	Vector temp = (Vector)vSoAkhir.get(0);
	salakhir = Double.parseDouble((String)temp.get(1));															
}
String strPerkiraan = "";
Perkiraan objAcc = new Perkiraan();
if(objSpecialJournalMain.getIdPerkiraan() != 0){
	try{
		objAcc = PstPerkiraan.fetchExc(objSpecialJournalMain.getIdPerkiraan());
		strPerkiraan = getAccountName(objAcc, SESS_LANGUAGE);
	}catch(Exception e){
		objAcc = new Perkiraan();
	}
} 
String strNumberSpeller = "";
if(objSpecialJournalMain.getStandarRate() > 0){
	strNumberSpeller = (String)numberSpeller.spellNumberToEngLong(Long.parseLong(Formater.formatNumber((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()),"###")));
}

Vector vMain = new Vector(1,1);
vMain.add(strPerkiraan); // Index 0
vMain.add(FRMHandler.userFormatStringDecimal(salakhir)); // Index 1
vMain.add(objSpecialJournalMain.getVoucherNumber()); // Index 2
vMain.add(Formater.formatDate(objSpecialJournalMain.getEntryDate(),"MMM dd,  yyyy")); // Index 3
vMain.add(contactName); // Index 4
vMain.add(cekNull(contactList.getBussAddress())); // Index 5
vMain.add(cekNull(contactList.getTown())); // Index 6
vMain.add(cekNull(contactList.getProvince())); // Index 7
vMain.add(cekNull(contactList.getCountry())); // Index 8
vMain.add(objSpecialJournalMain.getReference()); // Index 9
vMain.add(Formater.formatDate(objSpecialJournalMain.getTransDate(), "MMM dd, yyyy")); // Index 10
vMain.add(Formater.formatNumber((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()),"##,###.##")); // Index 11
vMain.add(strNumberSpeller+" "+currType.getName());// Index 12
vMain.add(objSpecialJournalMain.getDescription()); // Index 13
vMain.add(Formater.formatNumber((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()), "##,###.##")); // Index 14
vMain.add(currType.getCode()); // Index 15

Vector vDetail = new Vector(1,1);
if(iJournalBaseOn == 1){
	vDetail =(Vector)listJurnalDetail(SESS_LANGUAGE,objectClass,approot,updateJournal, iCommand); 
}else{
	vDetail =(Vector)listJurnalDetailCoA(iCommand, SESS_LANGUAGE,objectClass,updateJournal); 
}

String strListDetail = "";
Vector vDetailPdf = new Vector(1,1);
System.out.println("vDetail.size() :::::::: "+vDetail.size());
if(vDetail != null && vDetail.size() > 0){
	strListDetail = vDetail.get(0).toString();
	vDetailPdf = (Vector)vDetail.get(1);
}
Vector vDataToPdf = new Vector(1,1);
vDataToPdf.add(vTitleMain); // Index 0
vDataToPdf.add(vHeaderDetail); // Index 1
vDataToPdf.add(vMain); // Index 2
vDataToPdf.add(vDetailPdf); // Index 3
vDataToPdf.add(subMasterTitle[SESS_LANGUAGE]);// Index 4

if(session.getValue("CHEQUE_REQUEST") != null){
	session.removeValue("CHEQUE_REQUEST");
}
	session.putValue("CHEQUE_REQUEST",vDataToPdf);

			 
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script type="text/javascript" src="../../main/digitseparator.js"></script>
<script language="javascript">
<%System.out.println("Masuk Java Script");%>
<%if((privView)&&(privAdd)&&(privSubmit)){%>
<%if(isUseDatePicker.equalsIgnoreCase("Y")){%>

function getThn()
{
	var date1 = ""+document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_TRANS_DATE]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	//alert("hri = "+hri);
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_TRANS_DATE] + "_mn"%>.value=bln;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_TRANS_DATE] + "_dy"%>.value=hri;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_TRANS_DATE] + "_yr"%>.value=thn;		
				
}

function entContact(){
	if(event.keyCode == 13)
	cmdopen();
}

function entRef(){
	if(event.keyCode == 13)
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT]%>.focus();
}

function entDescription(){
	if(event.keyCode == 13)
	cmdAddDetail();
}
<%}%>

function getText(element){
	var rate = parseFloat(document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.rate.value);
	var balance = parseFloat(document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.total_val_balance.value);
	var blc = 0;
	if(rate != 1){
		blc = balance / rate;
	}else{
		blc = balance;
	}
	parserNumber(element,true,blc,'<%=strCekAmountTransaction[SESS_LANGUAGE][0]%>');
}

function cmdCancel(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.NONE %>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.target="_self";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="jumum.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}


function cmdAsk(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.ASK%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.target="_self";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="jumum.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function cmdDelete(oid){
	var deleteJournal = confirm("<%=strMsgDelete%>");
	if(deleteJournal){
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.journal_id.value=oid;
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.DELETE%>";
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journalmain.jsp";
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
		}
	}


function cmdItemData(indexedit){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.index_edit.value=indexedit;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journaldetail.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function cmdAddDetail(){
	var vTrans = document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT]%>.value;
	var totTrans = "0";	
	if(vTrans != " ")
		totTrans = parseFloat(document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT]%>.value);
		
	var totBalance = document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.total_val_balance.value;	
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.POST%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journalmain.jsp";
	if(totBalance >= totTrans){
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
	}else{
		if(isNaN){
			document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
		}else{	
			alert("<%=strCekAmountTransaction[SESS_LANGUAGE][0]%>");
			}		
	}
}

function cmdopen(){
	var url = "";
	var idContact = Math.abs(document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CONTACT_ID]%>.value);
	
	if(idContact == 0){
		url = "donor_list.jsp?command=<%=Command.LIST%>&"+
				"<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_NAME] %>="+document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CONTACT_ID]%>_TEXT.value;		
	}else{
		url = "donor_list.jsp?command=<%=Command.LIST%>";
	}		
		myWindow = window.open(url,"src_cnt_bank_draw_main","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
	
}


 <%}%>

function cmdBack(){
	<%if(fromGL){%>
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.LIST%>";
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="../../report/general_ledger_dept.jsp";
	<%}else{%>
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.BACK%>";
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.start.value="<%=start%>";    
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journallist.jsp";		
	<%}%>
		document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function changeCurrType()
{

	var iCurrType = 0;
	<%if(iCommand != Command.EDIT){%>
		iCurrType = document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CURRENCY_TYPE_ID]%>.value;
    <%}%>
    
    switch(iCurrType)
	{
	<% 
	if(vlistStandartRate!=null && vlistStandartRate.size()>0)
	{
		int ilistStandartRateCount = vlistStandartRate.size();
		for(int i=0; i<ilistStandartRateCount; i++)
		{
			objStandartRate = (StandartRate) vlistStandartRate.get(i);
			
	%>
		case '<%=objStandartRate.getCurrencyTypeId()%>':
			document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_STANDAR_RATE]%>.value = "<%=FRMHandler.userFormatStringDecimal(objStandartRate.getSellingRate())%>";
			 <% if(objStandartRate.getSellingRate() != 1){ %>
			 	document.all.currency_rate.innerHTML = "<%=strRate%><%=FrmSpecialJournalMain.userFormatStringDecimal(objStandartRate.getSellingRate())%>";
			  	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.rate.value = "<%=objStandartRate.getSellingRate()%>"
			  <%}else{%>
			  	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.rate.value = "<%=objStandartRate.getSellingRate()%>"
				document.all.currency_rate.innerHTML = "";
			  <%}%>	
			 break;
	<%
		
		}
	}
	%>
		default :
			 document.all.currency_rate.innerHTML = "";
			 
			 break;
	}
	
}

function changeTotal()
{
	var iCurrType = 0;
	<%if(iCommand != Command.EDIT){%>
		iCurrType = document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_ID_PERKIRAAN]%>.value;
	<%}%>	
	switch(iCurrType){
        <%
        if(vSaldoAkhir!=null && vSaldoAkhir.size()>0){
                for(int k=0; k<vSaldoAkhir.size(); k++){
                    Vector temp = (Vector) vSaldoAkhir.get(k);
                %>
		case "<%=temp.get(0)%>" :
			 document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.total_val_balance.value = <%=Double.parseDouble((String)temp.get(1))%>;
			 document.all.tot_saldo_akhir.innerHTML = "<%=frmSpecialJournalMain.userFormatStringDecimal(Double.parseDouble((String)temp.get(1)))%>";
			 break;
        <%
            }
       }
        %>
		<%if(iCommand != Command.EDIT){%>
		default :
			 document.all.tot_saldo_akhir.innerHTML = "";
		break;
		<%}%>	
	}
}

function hideObjectForDate(){
  }
	
  function showObjectForDate(){
  }	

function printJournal(){
		var linkPage = "<%=reportroot%>report.specialJournal.ChequeRequestJournalPdf";
		window.open(linkPage);
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="stylesheet" href="../../style/calendar.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
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
		    <%=listTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=subMasterTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="journal_id" value="<%=journalID%>">
			  <input type="hidden" name="total_val_balance" value="">
			  <input type="hidden" name="rate" value="">
              <input type="hidden" name="list_command" value="<%=Command.LIST%>">
              <input type="hidden" name="index" value="<%=index%>">
              <input type="hidden" name="add_type" value="<%=addType%>">
              <input type="hidden" name="perkiraan" value="<%=idAccount%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
	          <input type="hidden" name="account_group" value="<%=accountGroup%>">
              <input type="hidden" name="index_edit" value="-1">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_DEPARTMENT_ID]%>" value="<%=lDefaultSpcJournalDeptId%>">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_JOURNAL_TYPE]%>" value="<%=I_JournalType.TIPE_SPECIAL_JOURNAL_BANK%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_BOOK_TYPE]%>" value="<%=""+accountingBookType%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_STANDAR_RATE]%>" value="<%=""+FRMHandler.userFormatStringDecimal(objSpecialJournalMain.getStandarRate())%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT_STATUS]%>" value="<%=""+PstSpecialJournalMain.STS_KREDIT%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_JOURNAL_STATUS]%>" value="<%=""+I_DocStatus.DOCUMENT_STATUS_DRAFT%>" size="35">
			  <input type="hidden" name="fromGL" value="<%=fromGL%>">
			  <input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERKIRAAN%>" value="<%=accountId%>">
              <input type="hidden" name="<%=SessGeneralLedger.FRM_NAMA_PERIODE%>" value="<%=periodId%>">
			  <input type="hidden" name="ACCOUNT_NUMBER" value="<%=numberP%>">
              <input type="hidden" name="ACCOUNT_TITLES" value="<%=namaP%>">
              <input type="hidden" name="START_DATE_GL_yr" value="<%=(startDate.getYear()+1900)%>">
              <input type="hidden" name="START_DATE_GL_mn" value="<%=(startDate.getMonth()+1)%>">
              <input type="hidden" name="START_DATE_GL_dy" value="<%=startDate.getDate()%>">
              <input type="hidden" name="END_DATE_GL_yr" value="<%=(endDate.getYear()+1900)%>">
              <input type="hidden" name="END_DATE_GL_mn" value="<%=(endDate.getMonth()+1)%>">
              <input type="hidden" name="END_DATE_GL_dy" value="<%=endDate.getDate()%>">
			  <input type="hidden" name="get_time_menu_local" value="<%=getTimeMenuLocal%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%" class="tabtitleactive">
                          <table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
						  	<tr><td></td></tr>                            
                            <tr>
                              <td width="100%" valign="top"><div align="center"> 
							  		<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
										<tr>
											<td>
													<table width="100%" border="0" cellpadding="0" cellspacing="0" class="list">
                                <tr>
                                  <td height="25" colspan="3" ><div align="center">
								  	<table width="99%" border="0" cellpadding="1" cellspacing="0" bgcolor="#D6EEFA">
										<tr>
											<td><div align="center">
												<table width="100%"  border="0" class="mainJournalOut">
                                      <tr >
                                        <td width="9%" nowrap><strong><%=strTitleMain[SESS_LANGUAGE][0]%></strong></td>
                                        <td width="1%"><strong>:</strong></td>
                                        <td width="14%" nowrap>
                                          <% 	if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                          <%
															Vector vectCashAccount = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_BANK);
															Vector val = new Vector(1,1);
															Vector key = new Vector(1,1);
															Perkiraan objPerkiraan = new Perkiraan();
															String selectPerkiraan = String.valueOf(objSpecialJournalMain.getIdPerkiraan());
				
															if(vectCashAccount != null && vectCashAccount.size() > 0){
																for(int i=0; i<vectCashAccount.size(); i++){
																	objPerkiraan = (Perkiraan)vectCashAccount.get(i);
																	val.add(objPerkiraan.getNama());
																	key.add(""+objPerkiraan.getOID());
																}
															}
														%>
                                          <%= ControlCombo.draw(frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_ID_PERKIRAAN],null, selectPerkiraan, key, val, "onChange=\"javascript:changeTotal()\"", "")%>
                                          <%}else{
												Perkiraan objPerk = new Perkiraan();
												try{													
													objPerk = PstPerkiraan.fetchExc(objSpecialJournalMain.getIdPerkiraan());
												}catch(Exception e){
													System.out.println("Exception on fetc objPerkiraan ==> "+e.toString());
												}
												out.println(objPerk.getNama());
											}%>
                                        </td>
                                        <td width="30%"><table width="60%"  border="0" >
                                            <tr>
                                              <td width="50%" nowrap><b><%=strTitleMain[SESS_LANGUAGE][1]%></b></td>
                                              <td width="9%"><strong>:</strong></td>
                                              <td width="41%" nowrap>
                                                <% if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                                <a id="tot_saldo_akhir"></a>
                                                <%}else{%>
                                                	<%=FRMHandler.userFormatStringDecimal(salakhir)%>
                                                <%}%>
                                              </td>
                                            </tr>
                                        </table></td>
                                        <td width="14%" nowrap><b><%=strTitleMain[SESS_LANGUAGE][2]%></b></td>
                                        <td width="1%"><strong>:</strong></td>
                                        <td width="7%" nowrap><%
											out.println(objSpecialJournalMain.getVoucherNumber());
									        %></td>
                                        <td width="13%" nowrap><b><%=strTitleMain[SESS_LANGUAGE][3]%></b></td>
                                        <td width="1%"><strong>:</strong></td>
                                        <td width="10%" nowrap><%
									   out.println(Formater.formatDate(objSpecialJournalMain.getEntryDate(),"MMM dd,  yyyy"));
									  %></td>
                                      </tr>
                                  </table>
											</div></td>
										</tr>
									</table>
								  </div></td>
                                </tr>
                                <tr>
                                  <td>&nbsp;</td>
                                </tr>
                                <tr>
                                  <td height="25" colspan="3"><div align="center">
                                      <table width="99%" border="0" cellpadding="1" cellspacing="0" bgcolor="#D6EEFA">
									  	<tr>
											<td><div align="center">
												<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="mainJournalOut">
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td width="0%">&nbsp;</td>
                                          <td colspan="2"><b><%=strTitleMain[SESS_LANGUAGE][4]%></b></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td><input type="hidden" readonly name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CONTACT_ID]%>" value="<%=objSpecialJournalMain.getContactId()%>" size="25">
                                              <% if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                              <input type="text" name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CONTACT_ID]%>_TEXT" value="<%=contactName%>" size="25" onKeyDown="javascript:entContact()">
                                              <span class="msgErrComment"><a href="javascript:cmdopen()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a> *)</span>
                                              <%}else{%>
                                              <%=contactName%>
                                              <%}%></td>
                                          <td width="7%"><b><%=strTitleMain[SESS_LANGUAGE][5]%></b></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td colspan="2">
                                            <% if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                            <input name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_REFERENCE]%>" type="text" value="<%=objSpecialJournalMain.getReference()%>" size="20" onKeyDown="javascript:entRef()" maxlength="20">
                                            <font face="Verdana, Arial, Helvetica, sans-serif" color="#FF0033">*)
											<%if(ctrlErr != ctrlSpecialJournalMain.RSLT_FORM_INCOMPLETE || ctrlErr == ctrlSpecialJournalMain.RSLT_ERR_MEMO){%>													
												 	<%=frmSpecialJournalMain.getErrorMsg(FrmSpecialJournalMain.FRM_REFERENCE)%></font>
												 <%}%>						
                                            <%}else{%>
                                            <%=objSpecialJournalMain.getReference()%>
                                            <%}%>
                                          </font></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2"><b><%=strTitleMain[SESS_LANGUAGE][6]%></b></td>
                                          <td><strong>:</strong></td>
                                          <td><a id="address"></a><%=cekNull(contactList.getBussAddress())%>
										  <font face="Verdana, Arial, Helvetica, sans-serif" color="#FF0033">
										  <%if(ctrlErr != ctrlSpecialJournalMain.RSLT_FORM_INCOMPLETE || ctrlErr == ctrlSpecialJournalMain.RSLT_ERR_MEMO){%>
										  	<%=frmSpecialJournalMain.getErrorMsg(FrmSpecialJournalMain.FRM_CONTACT_ID)%></font>
										  <%}%>
										  </td>
                                          <td><b><%=strTitleMain[SESS_LANGUAGE][7]%></b></td>
                                          <td><strong>:</strong></td>
                                          <td colspan="2"><% if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                              <%if(isUseDatePicker.equalsIgnoreCase("Y")){%>
                                              <input onClick="ds_sh(this);" name="<%=frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((objSpecialJournalMain.getTransDate() == null) ? new Date() : objSpecialJournalMain.getTransDate(), "dd-MM-yyyy")%>"/>
                                              <input type="hidden" name="<%=frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE] + "_mn"%>">
                                              <input type="hidden" name="<%=frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE] + "_dy"%>">
                                              <input type="hidden" name="<%=frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE] + "_yr"%>">
                                              <script language="JavaScript" type="text/JavaScript">getThn();</script>
                                              <%}%>
                                              <%}else{%>
                                              <%=Formater.formatDate(objSpecialJournalMain.getTransDate(), "MMM dd, yyyy")%>
                                              <%}%>
                                          </td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td><a id="town"></a><%=cekNull(contactList.getTown())%>&nbsp;&nbsp;&nbsp;&nbsp;<%=cekNull(contactList.getPostalCodeCompany())%></td>
                                          <td>
                                            <% if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                            <%
												  Vector currencytypeid_value = new Vector(1,1);
												  Vector currencytypeid_key = new Vector(1,1);

												  String sSelectedCurrType = ""+objSpecialJournalMain.getCurrencyTypeId();
												  if(vlistCurrencyType!=null && vlistCurrencyType.size()>0){
													for(int i=0; i<vlistCurrencyType.size(); i++){
														CurrencyType currencyType =(CurrencyType)vlistCurrencyType.get(i);
														currencytypeid_value.add(currencyType.getCode());
														currencytypeid_key.add(""+currencyType.getOID());
													}
												  }
												  out.println(ControlCombo.draw(FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CURRENCY_TYPE_ID], null, sSelectedCurrType, currencytypeid_key, currencytypeid_value, "onChange=\"javascript:changeCurrType()\"", ""));
											%>
                                            <%}else{%>
                                            <b>
                                            	<%out.println(currType.getCode());
											}%>
                                          </b></td>
                                          <td><strong>:</strong></td>
                                          <td width="17%"><% if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                              <%
												String strAmount = "";
												if(objSpecialJournalMain.getAmount() > 0){
													strAmount = Formater.formatNumber((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()),"###");
												}else{
													strAmount = "";
												}
											%>
                                              <input name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT]%>" type="text" value="<%=strAmount%>" onKeyUp="javascript:getText(this)" maxlength="16">
                                              <%}else{%>
                                              <%=Formater.formatNumber((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()),"##,###.##")%>
                                              <%}%></td>
                                          <td width="23%" >
                                            <% if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                            <font face="Verdana, Arial, Helvetica, sans-serif" color="#FF0033">*) 
											<%if(ctrlErr != ctrlSpecialJournalMain.RSLT_FORM_INCOMPLETE){%>
											<%=msgString%></font>
											<%}%>	
                                            <%}%>
                                          </font></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td><a id="country"></a><%=cekNull(contactList.getProvince())%>&nbsp;&nbsp;<%=cekNull(contactList.getCountry())%></td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td colspan="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><a id="currency_rate"></a>
                                              <%if(cekValue(objSpecialJournalMain.getAmount()) == true){%>                                              
                                              <em>(<%=numberSpeller.spellNumberToEngLong(Long.parseLong(Formater.formatNumber((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()),"###")))%>&nbsp;&nbsp;<%=currType.getName()%>)</em>
                                              <%}%>
</font></td>
                                        </tr>
                                        <tr>
                                          <td colspan="9">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td colspan="9">&nbsp; </td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td width="5%"><div align="left"><b><%=strTitleMain[SESS_LANGUAGE][8]%></b></div></td>
                                          <td width="12%"><strong>:</strong></td>
                                          <td colspan="6">
                                            <% if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                            <input name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_DESCRIPTION]%>" type="text" value="<%=objSpecialJournalMain.getDescription()%>" size="100" onKeyDown="javascript:entDescription()">
                                            <span class="msgErrComment">**)</span>
                                            <%}else{%>
                                            <%=objSpecialJournalMain.getDescription()%>
                                            <%}%></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                          <td colspan="6"><font face="Verdana, Arial, Helvetica, sans-serif" color="#FF0033">
                                            <% if (ctrlErr != ctrlSpecialJournalMain.RSLT_FORM_INCOMPLETE) { %>
                                            <%=frmSpecialJournalMain.getErrorMsg(FrmSpecialJournalMain.FRM_DESCRIPTION)%>
                                            <%}%>
                                          </font></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2" class="msgErrComment">&nbsp;</td>
                                          <td colspan="6"><% if(updateJournal.equalsIgnoreCase("Y") || (iCommand != Command.EDIT)){%>
                                              <font face="Verdana, Arial, Helvetica, sans-serif" color="#FF0033">*) <%=strRequired%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**) <%=strMaxCaracter%></font>
                                              <%}%></td>
                                        </tr>
                                      </table>
											</div></td>
										</tr>
									  </table>
                                  </div></td>
                                </tr>
                                <tr>
                                  <td colspan="3">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td colspan="3"><div align="center">
								  	<table width="99%" border="0" cellpadding="1" cellspacing="0" bgcolor="#D6EEFA">
										<tr>
											<td>
												<table width="100%"  border="0" class="mainJournalOut">
                                      <%if(objectClass != null && objectClass.size() > 0){%>
                                      <tr>
                                        <td width="9%"><b><%=strTitleMain[SESS_LANGUAGE][9]%></b></td>
                                        <td width="2%"><strong>:</strong></td>
                                        <td width="89%"><b><%=Formater.formatNumber((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()), "##,###.##")%></b></td>
                                      </tr>
                                      <%}else{%>
                                      <tr>
                                        <td width="9%">&nbsp;</td>
                                        <td width="2%">&nbsp;</td>
                                        <td width="89%" > <font face="Verdana, Arial, Helvetica, sans-serif" color="#FF0033"> 
											<%=frmSpecialJournalMain.getErrorMsg(FrmSpecialJournalMain.FRM_TRANS_DATE)%> 
											<%=frmSpecialJournalMain.getErrorMsg(FrmSpecialJournalMain.FRM_ENTRY_DATE)%>
                                              <%if (ctrlErr == ctrlSpecialJournalMain.RSLT_FORM_INCOMPLETE) { %>
											  	<%=msgString%>
											  <%} %>
                                        </font></td>
                                      </tr>
                                      <%}%>
                                  </table>
											</td>
										</tr>
									</table>
								  </div></td>
                                </tr>
                                <tr>
                                  <%if(objectClass != null && objectClass.size() > 0){%>
                                  <td colspan="3"><%=strListDetail%></td>
                                  <%}else{%>
                                  <td width="0%" colspan="2">&nbsp;</td>
                                  <%}%>
                                </tr>
                                <tr>
                                  <td colspan="3">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td width="2%"><b> </b></td>
                                  <td width="73%"><b>
                                    </b></td>
                                  <td width="25%"></td>
                                </tr>
                                <tr>
                                  <td colspan="3"><div align="center">
								  	<table width="99%" border="0" cellpadding="1" cellspacing="0" class="list">
										<tr>
											<td>
												<table width="100%"  border="0" class="list">
                                    <tr>
                                      <td><b>
                                        <% if(iCommand == Command.ADD || iCommand == Command.NONE || iCommand == Command.POST || iCommand == Command.BACK){%>
                                        <input name="addDetail" type="button" value="<%=strAddDetail%>" onClick="javascript:cmdAddDetail()">
                                        <% }else{
										if(updateJournal.equalsIgnoreCase("Y")){%>
                                        <input name="saveDetail" type="button" value="<%=strSave%>" onClick="javascript:cmdAddDetail()">
                                        <input name="delDetail" type="button" value="<%=strDelete%>" onClick="javascript:cmdDelete('"+objspecialjournalmain.getoid()+"')">
                                       <%}else{%>
											<input name="btnPrint" type="button" onClick="javascript:printJournal()" value="<%=printJournal%>">
										<%}
									}%>
                                      </b></td>
                                      <td><div align="right"><b>
                                      <%
                                        String sCommandAddSaveAskBack = "";
										if(iCommand == Command.ADD || iCommand == Command.NONE || iCommand == Command.POST || iCommand == Command.BACK){
											//sCommandAddSaveAskBack = sCommandAddSaveAskBack + "<a href=\"javascript:cmdAddDetail()\">"+strAddDetail+"</a>";
											//sCommandAddSaveAskBack = sCommandAddSaveAskBack + "  <a href=\"javascript:cmdBack()\">"+strBack+"</a>";
											}else{
												if(updateJournal.equalsIgnoreCase("Y")){
													//sCommandAddSaveAskBack = sCommandAddSaveAskBack + "<a href=\"javascript:cmdAddDetail()\">"+strSave+"</a>";	
													//sCommandAddSaveAskBack = sCommandAddSaveAskBack + " | <a href=\"javascript:cmdDelete('"+objSpecialJournalMain.getOID()+"')\">"+strDelete+"</a>";	
													sCommandAddSaveAskBack = sCommandAddSaveAskBack + "  <a href=\"javascript:cmdBack()\">"+strBack+"</a>";
												}else{
													sCommandAddSaveAskBack = sCommandAddSaveAskBack + " <a href=\"javascript:cmdBack()\">"+strBack+"</a>";
												}	
											}
									  out.println(sCommandAddSaveAskBack);
									  %>
                                      </b></div></td>
                                    </tr>
                                  </table>
											</td>
										</tr>
									</table>
								  </div></td>
                                </tr>
                                <tr>
                                  <td colspan="3">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td colspan="3"><b> </b></td>
                                </tr>
                              </table>
											</td>
										</tr>
									</table>                             
							  </div></td>
                            </tr>
                            <tr>
                              
                              <td width="94%" height="25">&nbsp;</td>
                             
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
		  	changeCurrType();
            changeTotal();
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%//}%>
