<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.common.entity.contact.ContactList,
                   com.dimata.common.entity.contact.PstContactList" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import="com.dimata.common.entity.payment.PstCurrencyType"%>
<%@ page import="com.dimata.aiso.session.specialJournal.SessSpecialJurnal"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.SpecialJournalMain"%>
<%@ page import="com.dimata.common.entity.payment.PstStandartRate"%>
<%@ page import="com.dimata.common.entity.payment.CurrencyType"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.SpecialJournalDetail"%>
<%@ page import="com.dimata.aiso.entity.masterdata.*"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.SpecialJournalDetailAssignt"%>
<%@ page import="com.dimata.harisma.entity.masterdata.Department"%>
<%@ page import="com.dimata.harisma.entity.masterdata.PstDepartment"%>
<%@ page import="com.dimata.aiso.entity.specialJournal.PstSpecialJournalMain"%>
<%@ page import="com.dimata.common.entity.payment.StandartRate"%>
<%@ page import="com.dimata.aiso.form.specialJournal.*"%>

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
		"Perk. Bank",//0
		"Saldo Akhir",//1
		"Nomor Jurnal",//2
		"Tanggal Jurnal",//3
		"Pendanaan Dari",//4
		"No.",//5
		"Alamat",//6
		"Tanggal",//7
		"Memo",//8
		"Total Detail",//9
		"Cari"//10
	},
	
	{
		"Bank Account",//0
		"Ending Balance",//1
		"Voucher Number",//2
		"Voucher Date",//3
		"Funding From",//4
		"No.",//5
		"Address",//6
		"Date",//7
		"Memo",//8
		"Receipts",//9
		"Search"
	}
};
public static String strTitle[][] =
{
	{
		"Departemen",//0
		"Perkiraan",//1
		//"Nama",2
		"Mata Uang",//3
		"Kurs",//4
		"Jumlah",//5
		"Amount",//6
		"Perkiraan",//7
		"Prosentase"//8
	}
	,
	{		
		"Department",//0
		"Account",//1
		//"Name",2
		"Currency",//3
        "Rate",//4
        "Amount",//5
        "Memo",//6
		"Account",//7
        "Share Procentage"//8
	}
};

public static final String masterTitle[] = {
	"Jurnal Khusus","Special Journal"
};

public static final String listTitle[] = {
	"Transaksi","Transaction"
};

public static final String subMasterTitle[] = {
	"Jurnal Pemasukan Dana","Fund Journal"
};

public static final String strCekAmountTransaction[][] = {
	{"Nilai transaksi melebihi saldo","Nilai transaksi tidak boleh nol","Saldo = ","Nilai detail melebihi nilai transaksi","Sisa nilai transaksi = "},
	{"Transaction Amount Over than Balance Amount","Transaction value has to be greater than zero","Balance Amount is ","Detail amount over than transaction amount","Out of balance : "}
};

private static String cekNull(String objString){
	if(objString == null)
		return "-";
	else
		return objString;	
}

private static String clearDigitSeparator(String strValue){
	String strAngka = "";
	if(strValue != null && strValue.length() > 0){
		StringTokenizer objToken = new StringTokenizer(strValue);        
        while(objToken.hasMoreTokens()){            
            strAngka = strAngka + objToken.nextToken(",");           
        }
	}
	return strAngka;
}

public String listJurnalDetail(int iCommand, int language,
                                   FrmSpecialJournalDetail  frmSpecialJournalDetail,
                                   Vector objectClass, Vector vDepartmentOid,
                                   SpecialJournalDetail specialJournalDetail,
                                   SpecialJournalDetailAssignt specialJournalDetailAssign,Vector vlistCurrencyType,
								   int index,String approot, Vector vListAccount,int errSize,int strBalanceLength){
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
		ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.addHeader(strTitle[language][0],"10%");
        ctrlist.addHeader(strTitle[language][1],"15%");
        //ctrlist.addHeader(strTitle[language][2],"30%");
        ctrlist.addHeader(strTitle[language][2],"5%");
        ctrlist.addHeader(strTitle[language][3],"5%");
        ctrlist.addHeader(strTitle[language][4],"25%");
        ctrlist.addHeader(strTitle[language][5],"50%");
        

        Vector lstData = ctrlist.getData();
        Vector rowx = new Vector(1,1);
        ctrlist.reset();
        ctrlist.setLinkRow(1);

        // department
        Vector vectDeptKey = new Vector();
        Vector vectDeptName = new Vector();
        // currency
        Vector currencytypeid_value = new Vector(1,1);
        Vector currencytypeid_key = new Vector(1,1);
		
		Vector vAccValue = new Vector();
		Vector vAccKey = new Vector();
		String sSelectedAccount = "";
		String strAccName = "";
		String strNamaPerk = "";
		
		Perkiraan objPerkiraan = new Perkiraan();
		
        for(int i=0; i<objectClass.size(); i++){
            Vector temp = (Vector)objectClass.get(i);

            SpecialJournalDetail specJournalDetail = (SpecialJournalDetail)temp.get(0); // if ada
            //SpecialJournalDetailAssignt specialJournalDetailAssignt = (SpecialJournalDetailAssignt)temp.get(1);
			
			//getAccountChartName
			Perkiraan objPerk = new Perkiraan();
			if(specJournalDetail.getIdPerkiraan() > 0)
				try{
					objPerk = PstPerkiraan.fetchExc(specJournalDetail.getIdPerkiraan());
				}catch(Exception e){
					System.out.println("Exception pada saat fetch obj perkiraan ===> "+e.toString());
				}
			
			if(objPerk != null)
				if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
					strNamaPerk = objPerk.getAccountNameEnglish();
				else
					strNamaPerk = objPerk.getNama();
					
					
            // getNama activity
            /*Activity activity = new Activity();
            try{
                activity = PstActivity.fetchExc(specialJournalDetailAssignt.getActivityId());
            }catch(Exception e){}*/

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

            rowx = new Vector();
            if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
				if(errSize > 0)
					specJournalDetail = specialJournalDetail;
					
                vectDeptKey = new Vector();
                vectDeptName = new Vector();
                // currency
                currencytypeid_value = new Vector(1,1);
                currencytypeid_key = new Vector(1,1);
                // for list data
                int iDeptSize = vDepartmentOid.size();
                String strSelectedDept = String.valueOf(specJournalDetail.getDepartmentId());
                for (int deptNum = 0; deptNum < iDeptSize; deptNum++){
                    Department dept = new Department();
                    try{
                        dept = PstDepartment.fetchExc(Long.parseLong((String)vDepartmentOid.get(deptNum)));
                    }catch(Exception e){}
                    vectDeptKey.add(String.valueOf(dept.getOID()));
                    vectDeptName.add(dept.getDepartment());
                }

                // get list currency
                String sSelectedCurrType = ""+specJournalDetail.getCurrencyTypeId();
                if(vlistCurrencyType!=null && vlistCurrencyType.size()>0){
                    for(int k=0; k<vlistCurrencyType.size(); k++){
                        CurrencyType currencyType =(CurrencyType)vlistCurrencyType.get(k);

                        currencytypeid_value.add(currencyType.getCode());
                        currencytypeid_key.add(""+currencyType.getOID());
                    }
                }
				
				// get list account
			sSelectedAccount = ""+specialJournalDetail.getIdPerkiraan();
			if(vListAccount != null && vListAccount.size() > 0){
				for(int a=0; a < vListAccount.size(); a++){
					objPerkiraan = (Perkiraan) vListAccount.get(a);					
					if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
						strAccName = objPerkiraan.getAccountNameEnglish();
					else
						strAccName = objPerkiraan.getNama();
					
					vAccValue.add(strAccName);					
					vAccKey.add(""+objPerkiraan.getOID());					
				}
			}
				
                rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DEPARTMENT_ID], "", null, strSelectedDept, vectDeptKey, vectDeptName)); // <a href=\"javascript:cmdCheck()\">CHK</a>
                rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN],"", null, sSelectedAccount,   vAccKey, vAccValue,""));
                //rowx.add("<input type=\"text\" size=\"20\" name=\"act_desc\" value=\""+activity.getDescription()+"\" class=\"hiddenText\" readOnly><a href=\"javascript:cmdopen()\" disable=\"true\">GET</a>");
                String name = "";
                if(contactList.getCompName()==null)
                    name = contactList.getPersonName();
                else
                    name = contactList.getCompName();
                //rowx.add("<input type=\"text\" size=\"20\" name=\"cont_name\" value=\""+name+"\" class=\"hiddenText\" readOnly><a href=\"javascript:cmdopencontact()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
                rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_TYPE_ID], null, sSelectedCurrType, currencytypeid_key, currencytypeid_value, "onChange=\"javascript:changeCurrType()\"", ""));
                rowx.add("<input type=\"text\" size=\"10\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_RATE]+"\" value=\""+FRMHandler.userFormatStringDecimal(specJournalDetail.getCurrencyRate())+"\" class=\"formElemenR\">");
                rowx.add("<input type=\"text\" size=\"25\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT ]+"\" value=\""+FRMHandler.userFormatStringDecimal(specJournalDetail.getAmount()/specJournalDetail.getCurrencyRate())+"\" onKeyUp=\"javascript:getText(this)\" class=\"hiddenTextR\" maxlength=\""+(strBalanceLength + 3)+"\">");
                rowx.add("<input type=\"text\" size=\"40\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DESCRIPTION]+"\" value=\""+specJournalDetail.getDescription()+"\">");
            }else{
                rowx.add(deptObject.getDepartment());
                rowx.add("<div align=\"left\"><a href=\"javascript:cmdEdit('"+i+"')\">"+strNamaPerk+"</a></div>");
                //rowx.add("<div align=\"left\">"+contactList.getCompName()==null?contactList.getPersonName():contactList.getCompName()+"</div>");
                rowx.add("<div align=\"center\">"+objectCurrencyType.getCode()+"</div>");
                rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(specJournalDetail.getCurrencyRate())+"</div>");
                rowx.add("<div align=\"right\">"+Formater.formatNumber((specJournalDetail.getAmount() / specJournalDetail.getCurrencyRate()), "##,###.##")+"</div>");
                rowx.add("<div align=\"left\">"+specJournalDetail.getDescription()+"</div>");
            }
            lstData.add(rowx);
        }

        rowx = new Vector();
        if((iCommand==Command.ADD || (iCommand==Command.SAVE && frmSpecialJournalDetail.errorSize()>0)) && vDepartmentOid.size() > 0){

            // getNama activity
            Activity activity = new Activity();
            try{
                activity = PstActivity.fetchExc(specialJournalDetailAssign.getActivityId());
            }catch(Exception e){}

            // getNama activity
            ContactList contactList = new ContactList();
            try{
                contactList = PstContactList.fetchExc(specialJournalDetail.getContactId());
            }catch(Exception e){}

            vectDeptKey = new Vector();
            vectDeptName = new Vector();
			String strSelectedDept = "";
            // currency
            currencytypeid_value = new Vector(1,1);
            currencytypeid_key = new Vector(1,1);

            // for list data
			if(vDepartmentOid != null && vDepartmentOid.size() > 0){
				int iDeptSize = vDepartmentOid.size();
				strSelectedDept = String.valueOf(specialJournalDetail.getDepartmentId());
				Department deptObject = new Department();
				for (int j = 0; j < iDeptSize; j++){
					Department dept = new Department();
					try{
						dept = PstDepartment.fetchExc(Long.parseLong((String)vDepartmentOid.get(j)));
						if(dept.getOID()==specialJournalDetail.getDepartmentId())
							deptObject = dept;
	
					}catch(Exception e){
						System.out.println("sdsdfsdfds "+e.toString());
					}
					vectDeptKey.add(String.valueOf(dept.getOID()));
					vectDeptName.add(dept.getDepartment());
				}
			}
			
            // get list currency
            String sSelectedCurrType = ""+specialJournalDetail.getCurrencyTypeId();
            CurrencyType objectCurrencyType =new CurrencyType();
            if(vlistCurrencyType!=null && vlistCurrencyType.size()>0){
                for(int k=0; k<vlistCurrencyType.size(); k++){
                    CurrencyType currencyType =(CurrencyType)vlistCurrencyType.get(k);
                    if(specialJournalDetail.getCurrencyTypeId()==currencyType.getOID())
                        objectCurrencyType = currencyType;

                    currencytypeid_value.add(currencyType.getCode());
                    currencytypeid_key.add(""+currencyType.getOID());
                }
            }
			
			// get list account
			sSelectedAccount = ""+specialJournalDetail.getIdPerkiraan();
			if(vListAccount != null && vListAccount.size() > 0){
				for(int a=0; a < vListAccount.size(); a++){
					objPerkiraan = (Perkiraan) vListAccount.get(a);					
					if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
						strAccName = objPerkiraan.getAccountNameEnglish();
					else
						strAccName = objPerkiraan.getNama();
					
					vAccValue.add(strAccName);					
					vAccKey.add(""+objPerkiraan.getOID());
				}
			}
			
            rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DEPARTMENT_ID], "", null, strSelectedDept, vectDeptKey, vectDeptName)); // <a href=\"javascript:cmdCheck()\">CHK</a>
            rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN], null, sSelectedAccount,  vAccKey, vAccValue, "",""));
            String name = "";
            if(contactList.getCompName()==null)
                name = contactList.getPersonName();
            else
                name = contactList.getCompName();

            //rowx.add("<input type=\"text\" size=\"20\" name=\"cont_name\" value=\""+name+"\" class=\"hiddenText\" readOnly><a href=\"javascript:cmdopencontact()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");
            rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_TYPE_ID], null, sSelectedCurrType, currencytypeid_key, currencytypeid_value, "onChange=\"javascript:changeCurrType()\"", ""));
            rowx.add("<input type=\"text\" size=\"10\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_RATE]+"\" value=\""+FRMHandler.userFormatStringDecimal(specialJournalDetail.getCurrencyRate())+"\" class=\"formElemenR\" readOnly>");
            rowx.add("<input type=\"text\" size=\"25\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT ]+"\" value=\""+FRMHandler.userFormatStringDecimal(specialJournalDetail.getAmount()/specialJournalDetail.getCurrencyRate())+"\" onKeyUp=\"javascript:getText(this)\" class=\"hiddenTextR\" maxlength=\""+(strBalanceLength + 3)+"\">");
            rowx.add("<input type=\"text\" size=\"40\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DESCRIPTION]+"\" value=\""+specialJournalDetail.getDescription()+"\">");
        }

        lstData.add(rowx);
        return ctrlist.draw();
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
                        specialJournalDetail.getContactId()==specJournalDetail.getContactId()&&
						specialJournalDetail.getCurrencyTypeId() == specJournalDetail.getCurrencyTypeId()
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
long journalID = FRMQueryString.requestLong(request,"journal_id");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
double dBalance = FRMQueryString.requestDouble(request, "balance_amount");
int indexEdit = FRMQueryString.requestInt(request, "index_edit");
if(iCommand==Command.NONE){
	indexEdit = -1;
		iCommand = Command.ADD;
	}

/**
* Declare Commands caption
*/
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save and Add New Detail" : "Simpan Detail";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strPosted = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Posted Journal" : "Posting Jurnal";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Detail" : "Hapus Detail";
String strTableName = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Detail List" : "Daftar Perincian";
String strErrorDept = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "System can not find department data. Please clik button Cancel and then clik button Save and New Detail again. Pardon me about this unconvinience" :
						"System tidak menemukan data departemen.Silahkan clik tombol Cancel and clik tombol Save and New Detail kembali. Mohon maaf atas tidak kenyamanan ini";

long periodeOID = PstPeriode.getCurrPeriodId();
String msgErr = "";

    // for get main 
    SpecialJournalMain objSpecialJournalMain = new SpecialJournalMain();
    try{		
        objSpecialJournalMain = (SpecialJournalMain)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
        if(objSpecialJournalMain==null)
            objSpecialJournalMain = new SpecialJournalMain();
    }catch(Exception e){
		objSpecialJournalMain = new SpecialJournalMain();
	}
	
    if(iCommand == Command.SAVE && objSpecialJournalMain.getAmount() == 0){
		iCommand = Command.SUBMIT;
	}

///standarRate = objSpecialJournalMain.getStandarRate();
int iAmountStatus = objSpecialJournalMain.getAmountStatus();

    // get masterdata currency
    String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
    Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);

    /** Instansiasi object CtrlJurnalUmum and FrmJurnalUmum */
    CtrlSpecialJournalDetail ctrlSpecialJournalDetail = new CtrlSpecialJournalDetail(request);
    ctrlSpecialJournalDetail.setLanguage(SESS_LANGUAGE);
    FrmSpecialJournalDetail frmSpecialJournalDetail = ctrlSpecialJournalDetail.getForm();
    int ctrlErrDetail = ctrlSpecialJournalDetail.action(iCommand);
	msgErr = ctrlSpecialJournalDetail.getMessage();
    SpecialJournalDetail objSpecialJournalDetail = ctrlSpecialJournalDetail.getJurnalDetail();

    // assign
    CtrlSpecialJournalDetailAssignt  ctrlSpecialJournalDetailAssignt = new CtrlSpecialJournalDetailAssignt(request);
    FrmSpecialJournalDetailAssignt frmSpecialJournalDetailAssignt = ctrlSpecialJournalDetailAssignt.getForm();
    int ctrlErr = ctrlSpecialJournalDetailAssignt.action(iCommand);
    SpecialJournalDetailAssignt specialJournalDetailAssignt = ctrlSpecialJournalDetailAssignt.getJurnalDetail();

    /** Saving object jurnalumum into session */
    Vector objectClass = new Vector();
    objectClass = (Vector)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
    if(objectClass==null)
        objectClass = new Vector();

  	if(objectClass.size() > 0 && iCommand == Command.BACK){
		iCommand  = Command.ADD;
		indexEdit = -1;
	}	
	
        if(iCommand==Command.SAVE){
            try{ // ini digunakan untuk nyimpan data ke session saat tombol post
                if(indexEdit==-1){
						if(objSpecialJournalDetail.getIdPerkiraan()!=0 &&
					//specialJournalDetailAssignt.getActivityId()!=0 &&
					//objSpecialJournalDetail.getContactId()!=0 &&
					objSpecialJournalDetail.getAmount()>0 &&
					objSpecialJournalDetail.getDescription().length() > 0){
					
						Vector dtlList = new  Vector();				
						objSpecialJournalDetail.setAmount(objSpecialJournalDetail.getAmount() * objSpecialJournalDetail.getCurrencyRate());
						dtlList.add(objSpecialJournalDetail); // index 0
	
						specialJournalDetailAssignt.setAmount(objSpecialJournalDetail.getAmount());
						specialJournalDetailAssignt.setShareProcentage(100);
						dtlList.add(specialJournalDetailAssignt); // index 1
	
						int idx = cekDataActivity(objSpecialJournalDetail,specialJournalDetailAssignt,objectClass);
						if(idx==-1)
							objectClass.add(dtlList);
						else
							objectClass.setElementAt(dtlList,idx);
	
						session.putValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL,objectClass);
						objSpecialJournalDetail = new SpecialJournalDetail();
						specialJournalDetailAssignt = new SpecialJournalDetailAssignt();
						indexEdit = -1;
						}
                }else{
					if(objSpecialJournalDetail.getIdPerkiraan()!=0 &&
						//specialJournalDetailAssignt.getActivityId()!=0 &&
						//objSpecialJournalDetail.getContactId()!=0 &&
						objSpecialJournalDetail.getAmount()>0 &&
						objSpecialJournalDetail.getDescription().length() > 0){
					
                    Vector temp = (Vector)objectClass.get(indexEdit);
                    objSpecialJournalDetail.setAmount(objSpecialJournalDetail.getAmount()*objSpecialJournalDetail.getCurrencyRate());
                    temp.setElementAt(objSpecialJournalDetail,0);

                    specialJournalDetailAssignt.setAmount(objSpecialJournalDetail.getAmount());
                    specialJournalDetailAssignt.setShareProcentage(100);
                    temp.add(specialJournalDetailAssignt); // index 1
                    objectClass.setElementAt(temp,indexEdit);
					
                    session.putValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL,objectClass);
                    objSpecialJournalDetail = new SpecialJournalDetail();
                    specialJournalDetailAssignt = new SpecialJournalDetailAssignt();
                    indexEdit = -1;
					
					}else{
							iCommand = Command.EDIT;
						}	
                }
            }catch(Exception e){
				
			}
        }else{ // ini di gunakan tambah jurnal tapi tidak command post
            if(iCommand==Command.NONE){
                try{
                    System.out.println("on Command.NONE");
                }catch(Exception e){}
            }else{
                try{
                    switch(iCommand){
						case Command.ADD:
							if(objectClass.size()==0){
								objSpecialJournalDetail.setAmount(objSpecialJournalMain.getAmount());
								objSpecialJournalDetail.setDescription(objSpecialJournalMain.getDescription());
								objSpecialJournalDetail.setCurrencyRate(objSpecialJournalMain.getStandarRate());
								objSpecialJournalDetail.setCurrencyTypeId(objSpecialJournalMain.getCurrencyTypeId());
							}
                        case Command.EDIT:
                            Vector temp = (Vector)objectClass.get(indexEdit);
                            objSpecialJournalDetail = (SpecialJournalDetail)temp.get(0); // if ada
                            specialJournalDetailAssignt = (SpecialJournalDetailAssignt)temp.get(1);
							dBalance += objSpecialJournalDetail.getAmount(); 
                            break;

                        case Command.DELETE:
                            objectClass.remove(indexEdit);
                            session.putValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL,objectClass);
                            iCommand=Command.ADD;
                            indexEdit = -1;
                            break;

                        case Command.SUBMIT:
                            CtrlSpecialJournalMain ctrlSpecialJournalMain = new CtrlSpecialJournalMain(request);
                            ctrlSpecialJournalMain.JournalSave(objSpecialJournalMain,objectClass);
                            try{
                                session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
                                session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
                            }catch(Exception e){}
                            break;
                    }
                }catch(Exception e){}
            }
        }
		
    String contactName = "";
    ContactList contactList = new ContactList();
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
	Vector vUsrCustomDepartment = new Vector(1,1);
	try{
    	vUsrCustomDepartment = PstDataCustom.getDataCustom(userOID, "hrdepartment");
	 }catch(Exception e){
		vUsrCustomDepartment = new Vector(1,1);
	}
		
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

// get masterdata currency
String sOrderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector vlistCurrencyType = PstCurrencyType.list(0, 0, "", sOrderBy);

Vector vListAccount = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_FUND);

// get masterdata standart rate
String sStRateWhereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS] + " = " + PstStandartRate.ACTIVE;
String sStRateOrderBy = PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE] +
						", " + PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE];
Vector vlistStandartRate = PstStandartRate.list(0, 0, sStRateWhereClause, sStRateOrderBy);

    double total =  getAmountActivity(objectClass);
	if(total == objSpecialJournalMain.getAmount() && iCommand == Command.SAVE){
		iCommand = Command.REFRESH;
	}
	
	String strBalance = "";
	int strBalanceLength = 0;
	if(iCommand != Command.EDIT){
		dBalance = objSpecialJournalMain.getAmount() - total;
		
	}
	
	if(dBalance > 0){
		strBalance = String.valueOf(dBalance);
		strBalanceLength = strBalance.length();
	}
	
	double rate = objSpecialJournalMain.getStandarRate();
	double dTotal = total / objSpecialJournalMain.getStandarRate();

double dAmountDetail = 0;
String strAmountDet = request.getParameter(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT]);
if(strAmountDet != null && strAmountDet.length() > 0){
	String strAmountDetail = clearDigitSeparator(strAmountDet);
	dAmountDetail = Double.parseDouble(strAmountDetail);
}
		
    Vector vSaldoAkhir = SessSpecialJurnal.getTotalSaldoAccountLink(periodeOID, objSpecialJournalMain.getIdPerkiraan());
    if(iCommand==Command.SUBMIT){
		response.sendRedirect("journalmain.jsp");        
    }
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script type="text/javascript" src="../../main/digitseparator.js"></script>
<script language="javascript">
function cmdCancel(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.BACK%>";
	<%if(objectClass.size() > 0){%>
		document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="journaldetail.jsp";
	<%}else{%>
		document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="journalmain.jsp";
	<%}%>
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}

function cmdSave(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="journaldetail.jsp";
	var amountBalance = document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.balance_amount.value;
	var amountDetail = document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT]%>.value;	
	var amountDet = clearDigitSeparator(amountDetail,',','.');
	if(parseFloat(amountBalance) < parseFloat(amountDet)){
		alert("<%=strCekAmountTransaction[SESS_LANGUAGE][3]%>");
		document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT]%>.value = amountBalance;
	}else{
		document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
	}
}

function getText(element){
	var currCode = document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.curr_code.value;
	var amountBalance = parseFloat(document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.balance_amount.value);
	var rate = 1;
	<%if(iCommand != Command.REFRESH){%>
		rate = parseFloat(document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.rate.value);
	<%}%>
	var blc = 0;
	var msg = "";
		if(rate != 1){
			msg = "<%=strCekAmountTransaction[SESS_LANGUAGE][3]%>\n<%=strCekAmountTransaction[SESS_LANGUAGE][4]%>";
			blc = amountBalance / rate;
		}else{
			blc = amountBalance;
			msg = "<%=strCekAmountTransaction[SESS_LANGUAGE][3]%>\n<%=strCekAmountTransaction[SESS_LANGUAGE][4]%>";
		}
		var strBalance = blc.toLocaleString();
		parserNumber(element,true,blc,msg+' '+currCode+' '+strBalance);
}

function cmdPosted(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.SUBMIT%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="journaldetail.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}


function cmdAsk(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.ASK%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.target="_self";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="jumum.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}

function cmdDelete(oid){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.journal_id.value=oid;
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="journaldetail.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}

function cmdItemData(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.index.value=-1;
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.LIST%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.target="_self";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="jdetail.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}

function cmdEdit(indexx){
    document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.index_edit.value =indexx;
    document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="journaldetail.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}

function cmdRefresh(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="journaldetail.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}

function cmdopen(){
	closeWindow();
	myWindow = window.open("activity.jsp","src_donor_comp_cash_pay_det","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdopencontact(){
	closeWindow();
	myWindow = window.open("donor_list.jsp?src_from=1&&command=<%=Command.LIST%>","src_cnt_cash_pay_det","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdBack(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.NONE%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="journalmain.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}

function changeCurrType()
{
	var iCurrType = 0;
	<%if(iCommand != Command.REFRESH){%>
		iCurrType = document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_TYPE_ID]%>.value;
    <%}%>
    switch(iCurrType)
	{
	<% 
	if(vlistStandartRate!=null && vlistStandartRate.size()>0)
	{
		int ilistStandartRateCount = vlistStandartRate.size();
		for(int i=0; i<ilistStandartRateCount; i++)
		{
			StandartRate objStandartRate = (StandartRate) vlistStandartRate.get(i);
	%>
		case '<%=objStandartRate.getCurrencyTypeId()%>':
			<%
				String currCode = "";			
				CurrencyType oCurrencyType =new CurrencyType();
				if(objStandartRate.getCurrencyTypeId() > 0){
					try{
						oCurrencyType = PstCurrencyType.fetchExc(objStandartRate.getCurrencyTypeId());
					}catch(Exception e){
						oCurrencyType = new CurrencyType();
					}
				}
				
				if(oCurrencyType != null){
					currCode = oCurrencyType.getCode();
				}
			%>
			 document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_RATE]%>.value = "<%=FrmSpecialJournalDetail.userFormatStringDecimal(objStandartRate.getSellingRate())%>";
			 document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.rate.value = "<%=objStandartRate.getSellingRate()%>";
			 document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.curr_code.value = "<%=currCode%>";
			 <%if(objStandartRate.getSellingRate() > 1){%>
			 	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT]%>.value = "<%=objSpecialJournalDetail.getAmount() / objStandartRate.getSellingRate()%>"
			 <%}else{%>
			 	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT]%>.value = "<%=Formater.formatNumber((objSpecialJournalDetail.getAmount() / objStandartRate.getSellingRate()), "##,###.##")%>"
			 <%}%>
			 break;
	<%
		}
	}
	%>
		default :
			<%if(iCommand != Command.REFRESH){%>
			 	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_RATE]%>.value = "<%=FrmSpecialJournalDetail.userFormatStringDecimal(1)%>";
			  <%}%>
			 break;
	}
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=listTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=subMasterTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
		 
            <form name="<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="journal_id" value="<%=journalID%>">
              <input type="hidden" name="list_command" value="<%=Command.LIST%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
             <input type="hidden" name="index_edit" value="<%=indexEdit%>">
			 <input type="hidden" name="standar_rate" value="1">
			 <input type="hidden" name="rate" value="">
			 <input type="hidden" name="curr_code" value="1">
			 <input type="hidden" name="balance_amount" value="<%=dBalance%>">
              <input type="hidden" name="<%//=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN]%>" value="<%//=objSpecialJournalDetail.getIdPerkiraan()%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalDetailAssignt.fieldNames[FrmSpecialJournalDetailAssignt.FRM_ACTIVITY_ID]%>" value="<%=specialJournalDetailAssignt.getActivityId()%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CONTACT_ID]%>" value="<%=objSpecialJournalDetail.getContactId()%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT_STATUS]%>" value="<%=""+PstSpecialJournalMain.STS_DEBET%>" size="35">
              
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%" class="tabtitleactive">
                          <table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
						  	<tr><td></td></tr>
                            <tr>
                              <td width="94%" valign="top">
                             	<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
									<tr>
										<td>
											<table width="100%" border="0" cellpadding="0" cellspacing="0" class="list">
                                  <tr> 
                                    <td height="25" colspan="2" ><div align="center">
										<table width="99%" border="0" cellpadding="1" cellspacing="0" bgcolor="#D6EEFA">
											<tr>
												<td>
													<table width="100%"  border="0" class="mainJournalOut" >
                                        <tr > 
                                          <td width="9%" nowrap><b><%=strTitleMain[SESS_LANGUAGE][0]%></b></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="19%" nowrap><%
											Perkiraan objPerkiraan = new Perkiraan();
											  try{
                                              objPerkiraan = PstPerkiraan.fetchExc(objSpecialJournalMain.getIdPerkiraan());
                                              }catch(Exception e){}
                                        %> <%=objPerkiraan.getNama()%></td>
                                          <td width="25%"><table width="60%"  border="0">
                                              <tr> 
                                                <td width="50%" nowrap><b><%=strTitleMain[SESS_LANGUAGE][1]%></b></td>
                                                <td width="9%"><strong>:</strong></td>

                                                  <%
                                                      double salakhir = 0.0;
                                                    if(vSaldoAkhir!=null && vSaldoAkhir.size()>0){
                                                        Vector temp = (Vector)vSaldoAkhir.get(0);
                                                        salakhir = Double.parseDouble((String)temp.get(1));
                                                        salakhir = salakhir + objSpecialJournalMain.getAmount();
                                                    }
                                                  %>
                                                <td width="41%" nowrap><%=FRMHandler.userFormatStringDecimal(salakhir)%></td>
                                              </tr>
                                            </table></td>
                                          <td width="8%" nowrap><b><%=strTitleMain[SESS_LANGUAGE][2]%></b></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="13%" nowrap> <%
											out.println(objSpecialJournalMain.getVoucherNumber());
									        %> </td>
                                          <td width="5%" nowrap><b><%=strTitleMain[SESS_LANGUAGE][3]%></b></td>
                                          <td width="2%"><strong>:</strong></td>
                                          <td width="17%" nowrap><%
									   out.println(Formater.formatDate(objSpecialJournalMain.getEntryDate(),"MMM dd,  yyyy"));
									  %></td>
                                        </tr>
                                      </table>
												</td>
											</tr>
										</table>
									</div></td>
                                  </tr>
								  <tr><td colspan="2">&nbsp;</td></tr>
                                  <tr> 
                                    <td height="25" colspan="2"><div align="center">
										<table width="99%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CC99">
											<tr>
												<td><div align="center">
													<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="mainJournalIn">
									<tr><td>&nbsp;</td></tr>
                                        <tr> 
										  <td width="1%">&nbsp;</td>
                                          <td width="18%"><strong><%=strTitleMain[SESS_LANGUAGE][4]%></strong></td>
                                          <td width="1%"><strong>:</strong></td>
                                            <%
                                                String namaContak = "";
                                                if(contactList.getCompName().length()>0)
                                                    namaContak = contactList.getCompName();
                                                else
                                                    namaContak = contactList.getPersonName();
                                            %>
                                          <td width="33%"><%=namaContak%></td>
                                          <td width="9%"><strong><%=strTitleMain[SESS_LANGUAGE][5]%></strong></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="37%"><%=objSpecialJournalMain.getReference()%></td>
                                        </tr>
                                        <tr>
										<td width="1%">&nbsp;</td>
                                          <td><strong><%=strTitleMain[SESS_LANGUAGE][6]%></strong></td>
                                          <td><strong>:</strong></td>
                                          <td><%=cekNull(contactList.getBussAddress())%></td>
                                          <td><strong><%=strTitleMain[SESS_LANGUAGE][7]%></strong></td>
                                          <td><strong>:</strong></td>
                                          <td><%=Formater.formatDate(objSpecialJournalMain.getTransDate(),"MMM dd,  yyyy")%></td>
                                        </tr>
                                        <tr>
											<td width="1%">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td><%=cekNull(contactList.getTown())%>&nbsp;&nbsp;&nbsp;&nbsp;<%=cekNull(contactList.getPostalCodeCompany())%></td>
                                          <td><strong> <%
                                              CurrencyType currencyType = new CurrencyType();
                                              try{
                                                currencyType = PstCurrencyType.fetchExc(objSpecialJournalMain.getCurrencyTypeId());
                                              }catch(Exception e){}
                                              out.println(currencyType.getCode());
										%> </strong></td>
                                          <td><strong>:</strong></td>
                                          <td><strong>
										  <%
										  	String amount = "";
											amount = Formater.formatNumber((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()), "##,###.##"); 	
											//amount = FRMHandler.userFormatStringDecimal((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()));
												
										  %>										  
										  <%=amount%></strong></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td><%=cekNull(contactList.getProvince())%>,&nbsp;&nbsp;&nbsp;&nbsp;<%=cekNull(contactList.getCountry())%></td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>												  
                                          <td><em>
										  	<% NumberSpeller numberSpeller = new NumberSpeller(); %>
										   <%if(objSpecialJournalMain.getStandarRate() == 1){%>
                                             <%  String strNumbToSpell = "";
											  	long lNumbToSpell = 0;                                              							
												if(objSpecialJournalMain.getAmount() > 0){
													strNumbToSpell = Formater.formatNumber((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()), "###");
													lNumbToSpell = Long.parseLong(strNumbToSpell);
                                            %>
												(<%=numberSpeller.spellNumberToEngLong(lNumbToSpell)%>&nbsp;&nbsp;<%=currencyType.getName()%>)</em>
												<%}%></td>
                                        	<%}else{%>
												<%if(objSpecialJournalMain.getAmount() > 0){%>
												(<%=numberSpeller.spellNumberToEng(objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate())%>&nbsp;<%=currencyType.getName()%> )
												<%}%>
											<%}%>	
										</tr>
                                        <tr>
										<td width="1%">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp; </td>
                                          <td colspan="3"><em>&nbsp;</em></td>
                                        </tr>
                                        <tr align="right">
											<td width="1%">&nbsp;</td>
                                          <td colspan="6"><div align="center"><em>
										  </em></div></td>
                                        </tr>
                                        <tr> 
										<td width="1%">&nbsp;</td>
                                          <td colspan="6">&nbsp; </td>
                                        </tr>
                                        <tr>
										<td width="1%">&nbsp;</td> 
                                          <td><strong><%=strTitleMain[SESS_LANGUAGE][8]%></strong></td>
										  <td width="1%"><strong>:</strong></td>
                                          <td colspan="5"><%=objSpecialJournalMain.getDescription()%></td>
                                        </tr>
                                        <tr>
										<td width="1%">&nbsp;</td> 
                                          <td>&nbsp;</td>
                                          <td colspan="5">&nbsp;</td>
                                        </tr>
                                      </table>
												</div></td>
											</tr>
										</table>
									</div></td>
                                  </tr>
                                  <tr>
                                    <td colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="2">&nbsp;&nbsp;<b><font face="Verdana, Arial, Helvetica, sans-serif" size="+1" color="#0000CC"><%=strTableName%></font></b></td>
                                  </tr>
                                  <tr>
                                    <td colspan="2"><div align="center">
										<table width="99%" border="0" cellpadding="1" cellspacing="0" bgcolor="#D6EEFA">
											<tr>
												<td>
													<table width="100%"  border="0" class="mainJournalOut">
                                      <tr>
                                        <td width="13%"><strong><%=strTitleMain[SESS_LANGUAGE][9]%></strong></td>
                                        <td width="2%"><strong>:</strong></td>
                                        <td width="85%"> <strong><%=Formater.formatNumber(dTotal, "##,###.##")%></strong></td>
                                      </tr>
                                    </table>
												</td>
											</tr>
										</table>
									</div></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"><%=listJurnalDetail(iCommand,SESS_LANGUAGE,frmSpecialJournalDetail,objectClass,vDepartmentOid,objSpecialJournalDetail,specialJournalDetailAssignt,vlistCurrencyType,indexEdit,approot,vListAccount,ctrlErrDetail,strBalanceLength)%></td>
                                  </tr>
                                  <tr>
                                    <td colspan="2" class="msgerror">
									<%if(ctrlErrDetail != ctrlSpecialJournalDetail.RSLT_CONTACT){%>
										<%=msgErr%>
									<%}%>
									<%if(vDepartmentOid.size() == 0){%>
											<%=strErrorDept%>
										<%}%>
									</td>
                                  </tr>
                                  <tr>
                                    <td colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td width="3%">&nbsp;</td>
                                    <td width="97%"><b>
                                      <%
                                        String sCommandAddSaveAskBack = "";                                        
                                        if(iCommand==Command.EDIT){%>
                                      <input type="button" name="saveEdit" value="<%=strAddDetail%>" onClick="javascript:cmdSave()">
                                      <input type="button" name="delete" value="<%=strDelete%>" onClick="javascript:cmdDelete()">
                                      <%}else{ 
									  		double sisa = total - objSpecialJournalMain.getAmount();
											String strSisa = Formater.formatNumber(sisa,"###"); 
									  %>
                                      
                                      <%if(strSisa.equalsIgnoreCase("0")){%>
                                      <input name="posted" type="button" value="<%=strPosted%>" onClick="javascript:cmdPosted()">
                                      <%}else{%>
									  	<%if(vDepartmentOid.size() > 0){%>
									  		<input name="addDetail" type="button" value="<%=strAddDetail%>" onClick="javascript:cmdSave()">
                                      		<input name="cancel" type="button" value="<%=strCancel%>" onClick="javascript:cmdCancel()">
									  	<%}else{%>
											<input name="cancel" type="button" value="<%=strCancel%>" onClick="javascript:cmdCancel()">
                                      	<%}%>
									  <%}
                                        }                                      
									  %>
                                    </b></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2">&nbsp;  </td>
                                  </tr>
                                </table>
										</td>
									</tr>
								</table>                                 
							  </td>
                            </tr>
                            <tr>
                              <td width="3%" valign="top" height="25"></td>
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
                <%
                    if(iCommand!=Command.DELETE)
                %>
                    changeCurrType();
				
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
