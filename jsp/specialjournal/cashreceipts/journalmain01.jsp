<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--import java-->
<%@ page import = "java.util.*,
                   com.dimata.common.entity.contact.ContactList,
                   com.dimata.common.entity.contact.PstContactList" %>
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
		"Perkiraan Kas",//0
		"Saldo Akhir",//1
		"Nomor Jurnal",//2
		"Tanggal Jurnal",//3
		"Diterima Oleh",//4
		"No.",//5
		"Alamat",//6
		"Tanggal",//7
		"Memo",//8
		"Total Terima",//9
		"Cari"//10
	},
	
	{
		"Cash Account",//0
		"Ending Balance",//1
		"Voucher Number",//2
		"Voucher Date",//3
		"Receipts By",//4
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
		"Aktivitas",//1
		"Nama",//2
		"Mata Uang",//3
		"Kurs",//4
		"Jumlah",//5
		"Catatan",//6
		"Perkiraan",//7
		"Prosentase"//8
	}
	,
	{		
		"Department",//0
		"Activity",//1
		"Name",//2
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
	"Proses Jurnal","Journal Process"
};

public static final String subMasterTitle[] = {
	"Jurnal Penerimaan Kas","Cash Receipts Journal"
};

    public String listJurnalDetail(int language,
                                   Vector objectClass,String approot){
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
		ctrlist.setCellStyleOdd("listgensellOdd");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.addHeader(strTitle[language][0],"20%");
        ctrlist.addHeader(strTitle[language][1],"15%");
        ctrlist.addHeader(strTitle[language][2],"20%");
        ctrlist.addHeader(strTitle[language][3],"5%");
        ctrlist.addHeader(strTitle[language][4],"5%");
        ctrlist.addHeader(strTitle[language][5],"20%");
        ctrlist.addHeader(strTitle[language][6],"25%");
        

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
		
		String strAccName = "";
		
        for(int i=0; i<objectClass.size(); i++){
            Vector temp = (Vector)objectClass.get(i);

            SpecialJournalDetail specJournalDetail = (SpecialJournalDetail)temp.get(0); // if ada
            SpecialJournalDetailAssignt specialJournalDetailAssignt = (SpecialJournalDetailAssignt)temp.get(1);

            // getNama activity
            Activity activity = new Activity();
            try{
                activity = PstActivity.fetchExc(specialJournalDetailAssignt.getActivityId());
            }catch(Exception e){}			
					
            
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
			rowx.add(deptObject.getDepartment());
			rowx.add("<div align=\"left\"><a href=\"javascript:cmdItemData('"+i+"')\">"+activity.getDescription()+"</a></div>");
			rowx.add("<div align=\"left\">"+contactList.getCompName()==null?contactList.getPersonName():contactList.getCompName()+"</div>");
			rowx.add("<div align=\"center\">"+objectCurrencyType.getCode()+"</div>");
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(specJournalDetail.getCurrencyRate())+"</div>");
			rowx.add("<div align=\"right\">"+Formater.formatNumber((specJournalDetail.getAmount() / specJournalDetail.getCurrencyRate()), "##,###.##")+"</div>");
			rowx.add("<div align=\"left\">"+specJournalDetail.getDescription()+"</div>");
            lstData.add(rowx);
        }
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
/**
* Declare Commands caption
*/

String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Journal" : "Simpan Jurnal";
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save and Add New Detail" : "Simpan dan Tambah Baru Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Special Journal List" : "Kembali Ke Daftar Jurnal Khusus";
String strPosted = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Posted Journal" : "Posted Jurnal";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Journal" : "Hapus Jurnal";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "search" : "cari";
String strMsgDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure Delete Journal" : "Yakin Hapus Jurnal";
String strRate = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Bookkeeping Rate : " : "Kurs Standar : ";

long periodeOID = PstPeriode.getCurrPeriodId();
String msgErr = "";

    // get masterdata currency
    //String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
    //Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);

    /** Instansiasi object CtrlJurnalUmum and FrmJurnalUmum */
    CtrlSpecialJournalMain ctrlSpecialJournalMain = new CtrlSpecialJournalMain(request);
    ctrlSpecialJournalMain.setLanguage(SESS_LANGUAGE);
    FrmSpecialJournalMain frmSpecialJournalMain = ctrlSpecialJournalMain.getForm();
	System.out.println("====>>>>>>>>>>>>>>>>>>>>>>>>>>>>> journalID : "+journalID);
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
	
    SpecialJournalMain objSpecialJournalMain = ctrlSpecialJournalMain.getSpecialJournalMain();
	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> : "+objSpecialJournalMain.getAmount());
	System.out.println("oid atas : "+objSpecialJournalMain.getOID()+" "+objSpecialJournalMain.getDescription());
    Vector objectClass = new Vector();
	try{
    	objectClass = (Vector)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
	}catch(Exception e){}	
    if(objectClass==null)
        objectClass = new Vector();
	
    /** Saving object jurnalumum into session */
	System.out.println("==========================>>>> : "+objSpecialJournalMain.getOID()+" = "+iCommand);
    if(objSpecialJournalMain.getOID()==0){
        if(iCommand==Command.POST){
            try{ // ini digunakan untuk nyimpan data ke session saat tombol post
				objSpecialJournalMain.setAmount(objSpecialJournalMain.getAmount() * objSpecialJournalMain.getStandarRate());
                session.putValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL,objSpecialJournalMain);
            }catch(Exception e){
				System.out.println("gagal insert to session");
			}
        }else{ // ini di gunakan tambah jurnal tapi tidak command post
            if(iCommand==Command.ADD){
                try{
					System.out.println("dfgdfsgdfgfdgsf n");
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
                    objSpecialJournalMain = new SpecialJournalMain();
					objectClass = new Vector();
                }catch(Exception e){
					System.out.println("dfgdfsgdfgfdgsf n"+e.toString());
					objSpecialJournalMain = new SpecialJournalMain();
				}
            }else{
				try{
					objSpecialJournalMain = (SpecialJournalMain)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
					if(objSpecialJournalMain==null)
						objSpecialJournalMain = new SpecialJournalMain();
				}catch(Exception e){
					System.out.println("dfgdfsgdfgfdgadfasdasdasdaSSSssf n"+e.toString());
					objSpecialJournalMain = new SpecialJournalMain();
				}
            }
        }
    }else{
        if(iCommand==Command.POST){
            try{ // ini digunakan untuk nyimpan data ke session saat tombol post
				System.out.println("oid : "+objSpecialJournalMain.getOID()+" "+objSpecialJournalMain.getDescription()+" amount : "+objSpecialJournalMain.getAmount());
				//objSpecialJournalMain.setAmount(objSpecialJournalMain.getAmount() * objSpecialJournalMain.getStandarRate());
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
					System.out.println("dfgdfsgdfgfdgsf n");
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
                    objSpecialJournalMain = new SpecialJournalMain();
                }catch(Exception e){
					System.out.println("dfgdfsgdfgfdgsf n"+e.toString());
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
				System.out.println("==========================>>>> : "+objSpecialJournalMain.getOID());
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
					System.out.println("dfgdfsgdfgfdgadfasdasdasdaSSSssf n"+e.toString());
					objSpecialJournalMain = new SpecialJournalMain();
				}
            }
        }
    }
	System.out.println("dfgdfsgdfgfdgadfasdasdasdaSSSssf n dsdsd: "+objSpecialJournalMain.getOID());
    String contactName = "";
    ContactList contactList = new ContactList();


    // boolean periodClosed = PstPeriode.isPeriodClosed(objSpcJournalMain.getPeriodeId());

    /** if Command.POST and no error occur, redirect to journal detail page */
    try{
        //System.out.println("contact id : "+jUmum.getContactOid());
        contactList = PstContactList.fetchExc(objSpecialJournalMain.getContactId());
        contactName = contactList.getCompName();
        if(contactName.length()==0)
            contactName = contactList.getPersonName()+" "+contactList.getPersonLastname();
    }catch(Exception e){}

    //Vector listjurnaldetail = objSpecialJournalMain.getJurnalDetails();

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

    Vector vSaldoAkhir = SessSpecialJurnal.getTotalSaldoAccountLink(0);
        if(ctrlErr ==0 && iCommand==Command.POST && 
			objSpecialJournalMain.getContactId()!=0 && 
			objSpecialJournalMain.getAmount() > 0 && 
			objSpecialJournalMain.getReference().length()>0){
			
				response.sendRedirect("journaldetail.jsp");        
         /*%>
            <jsp:forward page="journaldetail.jsp">
            <jsp:param name="command" value="<%=Command.ADD%>"/>
            </jsp:forward>
         <%*/
             }
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">
<%System.out.println("Masuk Java Script");%>
<%if((privView)&&(privAdd)&&(privSubmit)){%>
/*function addNewDetail(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.index.value=-1;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.POST%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journalmain.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}*/

function cmdCancel(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.NONE %>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.target="_self";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="jumum.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

<%if(isUseDatePicker.equalsIgnoreCase("Y")){%>
function getThn()
{
	var date1 = ""+document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_TRANS_DATE]%>.value;
	//alert ("Date = "+date1);	
	var thn = date1.substring(0,4);
	//alert("Tahun = "+thn);
	var bln = date1.substring(5,7);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	//alert("bln = "+bln);
	var hri = date1.substring(8,10);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	//alert("hri = "+hri);
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_TRANS_DATE] + "_mn"%>.value=bln;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_TRANS_DATE] + "_dy"%>.value=hri;
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_TRANS_DATE] + "_yr"%>.value=thn;		
				
}
<%}%>

/*function cmdAddDetail(){
    document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.ADD%>";
    document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journaldetail.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}*/

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
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.POST%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journalmain.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}

function cmdopen(){
	window.open("donor_list.jsp?command=<%=Command.LIST%>","jurnal_search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

 <%}%>

function cmdBack(){
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.command.value="<%=Command.BACK%>";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.start.value="<%=start%>";    
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.action="journallist.jsp";
	document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.submit();
}


function changeCurrType()
{

	var iCurrType = document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CURRENCY_TYPE_ID]%>.value;
    //alert(iCurrType);
    switch(iCurrType)
	{
	<% System.out.println(" vlistStandartRate =========================="+vlistStandartRate.size());
	if(vlistStandartRate!=null && vlistStandartRate.size()>0)
	{
		int ilistStandartRateCount = vlistStandartRate.size();
		for(int i=0; i<ilistStandartRateCount; i++)
		{
			objStandartRate = (StandartRate) vlistStandartRate.get(i);
			
	%>
		case '<%=objStandartRate.getCurrencyTypeId()%>':
			document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_STANDAR_RATE]%>.value = "<%=FRMHandler.userFormatStringDecimal(objStandartRate.getSellingRate())%>";
			 document.all.currency_rate.innerHTML = "<%=FrmSpecialJournalMain.userFormatStringDecimal(objStandartRate.getSellingRate())%>";
			  
			
			 break;
	<%
		
		}
	}
	%>
		default :
			 document.all.currency_rate.innerHTML = "<%=FrmSpecialJournalMain.userFormatStringDecimal(objStandartRate.getSellingRate())%>";
			 
			 break;
	}
	
}

function changeTotal()
{
	var iCurrType = document.<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>.<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_ID_PERKIRAAN]%>.value;
	switch(iCurrType){
        <%
        if(vSaldoAkhir!=null && vSaldoAkhir.size()>0){
                for(int k=0; k<vSaldoAkhir.size(); k++){
                    Vector temp = (Vector) vSaldoAkhir.get(k);
                %>
		case "<%=temp.get(0)%>" :
			 document.all.tot_saldo_akhir.innerHTML = "<%=frmSpecialJournalMain.userFormatStringDecimal(Double.parseDouble((String)temp.get(1)))%>";
			 break;
        <%
            }
       }
        %>
	}
}
 function hideObjectForDate(){
  }
	
  function showObjectForDate(){
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

		  <%=masterTitle[SESS_LANGUAGE]%>
            &gt; <%=listTitle[SESS_LANGUAGE]%> &gt; <%=subMasterTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="<%=FrmSpecialJournalMain.FRM_SPECIAL_JOURNAL_MAIN%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="journal_id" value="<%=journalID%>">
              <input type="hidden" name="list_command" value="<%=Command.LIST%>">
              <input type="hidden" name="index" value="<%=index%>">
              <input type="hidden" name="add_type" value="<%=addType%>">
              <input type="hidden" name="perkiraan" value="<%=idAccount%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
	          <input type="hidden" name="account_group" value="<%=accountGroup%>">
              <input type="hidden" name="index_edit" value="-1">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_DEPARTMENT_ID]%>" value="<%=lDefaultSpcJournalDeptId%>">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_JOURNAL_TYPE]%>" value="<%=I_JournalType.TIPE_SPECIAL_JOURNAL_CASH%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_BOOK_TYPE]%>" value="<%=""+accountingBookType%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_STANDAR_RATE]%>" value="<%=""+FRMHandler.userFormatStringDecimal(objSpecialJournalMain.getStandarRate())%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT_STATUS]%>" value="<%=""+PstSpecialJournalMain.STS_DEBET%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_JOURNAL_STATUS]%>" value="<%=""+I_DocStatus.DOCUMENT_STATUS_DRAFT%>" size="35">
			  
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%" height="2">&nbsp;                         
                        </td>
                      </tr>
					  <tr>				 
                        <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="3" >
							<%=frmSpecialJournalMain.getErrorMsg(FrmSpecialJournalMain.FRM_TRANS_DATE)%>
							<%=frmSpecialJournalMain.getErrorMsg(FrmSpecialJournalMain.FRM_ENTRY_DATE)%>                         
							</font></div></td>
                      </tr>
                      <tr>
                        <td width="100%" class="tabtitleactive">
                          <table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">                            
                            <tr>
                              <td width="3%" valign="top"></td>
                              <td width="94%" valign="top">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
								<tr><td>&nbsp;</td></tr>
                                  <tr>
                                    <td height="25" colspan="2" ><table width="100%"  border="0" class="listgenvalue">
                                        <tr >
                                          <td width="9%" nowrap><strong><%=strTitleMain[SESS_LANGUAGE][0]%></strong></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="14%"><strong> <%
											Vector vectCashAccount = PstAccountLink.getVectObjListAccountLink(0, PstPerkiraan.ACC_GROUP_CASH);
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
										%> <%= ControlCombo.draw(frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_ID_PERKIRAAN],null, selectPerkiraan, key, val, "onChange=\"javascript:changeTotal()\"", "")%> </strong></td>
                                          <td width="30%"><table width="60%"  border="0" >
                                              <tr>
                                                <td width="50%" nowrap><b><%=strTitleMain[SESS_LANGUAGE][1]%></b></td>
                                                <td width="9%"><strong>:</strong></td>
                                                <td width="41%" nowrap><a id="tot_saldo_akhir"></a></td>
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
                                      </table></td>
                                  </tr>
								  <tr><td>&nbsp;</td></tr>
                                  <tr>
                                    <td height="25" colspan="2"><div align="center"><table width="98%"  border="0" cellpadding="0" cellspacing="0" class="listgenvaluecekin">
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td width="0%">&nbsp;</td>
                                          <td colspan="2"><b><%=strTitleMain[SESS_LANGUAGE][4]%></b></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td colspan="2"><input type="hidden" readonly name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CONTACT_ID]%>" value="<%=objSpecialJournalMain.getContactId()%>" size="25">
                                            <input type="text" readonly name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_CONTACT_ID]%>_TEXT" value="<%=contactName%>" size="25">
                                            <a href="javascript:cmdopen()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a> </td>
                                          <td width="7%"><b><%=strTitleMain[SESS_LANGUAGE][5]%></b></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td colspan="2"><input name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_REFERENCE]%>" type="text" value="<%=objSpecialJournalMain.getReference()%>" size="20"></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2"><b><%=strTitleMain[SESS_LANGUAGE][6]%></b></td>
                                          <td><strong>:</strong></td>
                                          <td colspan="2"><%=contactList.getBussAddress()%></td>
                                          <td><b><%=strTitleMain[SESS_LANGUAGE][7]%></b></td>
                                          <td><strong>:</strong></td>
                                          <td colspan="2"> 
										  <%if(isUseDatePicker.equalsIgnoreCase("Y")){%>
										  <input onClick="ds_sh(this);" name="<%=frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((objSpecialJournalMain.getTransDate() == null) ? new Date() : objSpecialJournalMain.getTransDate(), "MMM dd, yyyy")%>"/>										  
										  <input type="hidden" name="<%=frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE] + "_mn"%>">
										  <input type="hidden" name="<%=frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE] + "_dy"%>">
										  <input type="hidden" name="<%=frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE] + "_yr"%>">
										  <script language="JavaScript" type="text/JavaScript">getThn();</script>
										  <%} //else{%>
							  				<%//=ControlDate.drawDateWithStyle(frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE], (objSpecialJournalMain.getTransDate() ==null) ? new Date() : objSpecialJournalMain.getTransDate(), 0, -2, "formElemen", "")%>
							  				<%//}%>
										  <%/*
											Date dtTransactionDate = objSpecialJournalMain.getTransDate();
											if(dtTransactionDate ==null)
											{
												dtTransactionDate = new Date();
											}
											out.println(dtTransactionDate);
											out.println(ControlDate.drawDate(frmSpecialJournalMain.fieldNames[frmSpecialJournalMain.FRM_TRANS_DATE], dtTransactionDate, 0, -2));
											*/%> </td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="20%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
										  </font></td>
                                          <td> <%
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
										%> </td>
                                          <td><strong>:</strong></td>
                                          <td width="17%">
										  	<%
												String strAmount = "";
												if(objSpecialJournalMain.getAmount() > 0){
													strAmount = FRMHandler.userFormatStringDecimal((objSpecialJournalMain.getAmount() / objSpecialJournalMain.getStandarRate()));
												}else{
													strAmount = " ";
												}
											%>
										  	<input name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_AMOUNT]%>" type="text" value="<%=strAmount%>"></td>
											<td width="23%">&nbsp;</td>
											
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp; </td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td colspan="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><%=strRate%><a id="currency_rate"></a></font></td>
                                        </tr>
                                        <tr>
                                          <td colspan="10">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td colspan="10">&nbsp; </td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td width="5%"><div align="left"><b><%=strTitleMain[SESS_LANGUAGE][8]%></b></div></td>
                                          <td width="12%"><strong>:</strong></td>
                                          <td colspan="7"><input name="<%=frmSpecialJournalMain.fieldNames[FrmSpecialJournalMain.FRM_DESCRIPTION]%>" type="text" value="<%=objSpecialJournalMain.getDescription()%>" size="100"></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td colspan="2">&nbsp;</td>
                                          <td colspan="7">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </div></td>
                                  </tr>
                                  <tr>
                                    <td colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="2"><table width="100%"  border="0" class="listgenvalue">
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
                                        <td width="89%">&nbsp;</td>
                                      </tr>
									  <%}%>
                                    </table></td>
                                  </tr>
                                  <tr>
								  <%if(objectClass != null && objectClass.size() > 0){%>
                                    <td colspan="2"><%=listJurnalDetail(SESS_LANGUAGE,objectClass,approot)%></td>
									<%}else{%>
									<td colspan="2">&nbsp;</td>
									<%}%>
                                  </tr>
                                  <tr>
                                    <td colspan="2"><hr color="#00CCFF" size="2"></td>
                                  </tr>
                                  <tr>
                                    <td width="2%"><b>
                                    </b></td>
                                    <td width="98%"><b>
                                      <%
                                        String sCommandAddSaveAskBack = "";
										if(iCommand == Command.ADD || iCommand == Command.NONE || iCommand == Command.POST){
											sCommandAddSaveAskBack = sCommandAddSaveAskBack + "<a href=\"javascript:cmdAddDetail()\">"+strAddDetail+"</a>";
											sCommandAddSaveAskBack = sCommandAddSaveAskBack + " | <a href=\"javascript:cmdBack()\">"+strBack+"</a>";
											}else{
											sCommandAddSaveAskBack = sCommandAddSaveAskBack + "<a href=\"javascript:cmdAddDetail()\">"+strSave+"</a>";	
											sCommandAddSaveAskBack = sCommandAddSaveAskBack + " | <a href=\"javascript:cmdDelete('"+objSpecialJournalMain.getOID()+"')\">"+strDelete+"</a>";	
											sCommandAddSaveAskBack = sCommandAddSaveAskBack + " | <a href=\"javascript:cmdBack()\">"+strBack+"</a>";
											}
																						
											
                                      
									  out.println(sCommandAddSaveAskBack);
									  %>
                                    </b></td>
                                  </tr>
                                  <tr>
                                    <td colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="2"><b>  </b></td>
                                  </tr>
                                </table>                              </td>
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
