<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

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
<%@ include file = "../main/checkuser.jsp" %>

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
		"Receive by",//4
		"No.",//5
		"Address",//6
		"Tanggal",//7
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


    public String listJurnalDetail(int iCommand, int language,
                                   FrmSpecialJournalDetail  frmSpecialJournalDetail,
                                   Vector objectClass, Vector vDepartmentOid,
                                   SpecialJournalDetail specialJournalDetail,
                                   SpecialJournalDetailAssignt specialJournalDetailAssign,Vector vlistCurrencyType,int index){
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("listgentitle");
        ctrlist.addHeader(strTitle[language][0],"10%");
        ctrlist.addHeader(strTitle[language][1],"10%");
        ctrlist.addHeader(strTitle[language][2],"15%");
        ctrlist.addHeader(strTitle[language][3],"5%");
        ctrlist.addHeader(strTitle[language][4],"3%");
        ctrlist.addHeader(strTitle[language][5],"8%");
        ctrlist.addHeader(strTitle[language][6],"8%");
        //ctrlist.addHeader(strTitle[language][7],"5%");
        //ctrlist.addHeader(strTitle[language][8],"5%");

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
        for(int i=0; i<objectClass.size(); i++){
            Vector temp = (Vector)objectClass.get(i);

            SpecialJournalDetail specJournalDetail = (SpecialJournalDetail)temp.get(0); // if ada
            SpecialJournalDetailAssignt specialJournalDetailAssignt = (SpecialJournalDetailAssignt)temp.get(1);

            // getNama activity
            Activity activity = new Activity();
            try{
                activity = PstActivity.fetchExc(specialJournalDetailAssignt.getActivityId());
            }catch(Exception e){}

            // getNama activity
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

                rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DEPARTMENT_ID], "", null, strSelectedDept, vectDeptKey, vectDeptName)); // <a href=\"javascript:cmdCheck()\">CHK</a>
                rowx.add("<textarea name=\"act_desc\">"+activity.getDescription()+"</textarea><a href=\"javascript:cmdopen()\" disable=\"true\">GET</a>");
                //rowx.add("<input type=\"text\" size=\"20\" name=\"act_desc\" value=\""+activity.getDescription()+"\" class=\"hiddenText\" readOnly><a href=\"javascript:cmdopen()\" disable=\"true\">GET</a>");
                String name = "";
                if(contactList.getCompName()==null)
                    name = contactList.getPersonName();
                else
                    name = contactList.getCompName();
                rowx.add("<input type=\"text\" size=\"20\" name=\"cont_name\" value=\""+name+"\" class=\"hiddenText\" readOnly><a href=\"javascript:cmdopencontact()\" disable=\"true\">GET</a>");
                rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_TYPE_ID], null, sSelectedCurrType, currencytypeid_key, currencytypeid_value, "onChange=\"javascript:changeCurrType()\"", ""));
                rowx.add("<input type=\"text\" size=\"10\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_RATE]+"\" value=\""+FRMHandler.userFormatStringDecimal(specJournalDetail.getCurrencyRate())+"\" class=\"formElemenR\">");
                rowx.add("<input type=\"text\" size=\"4\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT ]+"\" value=\""+FRMHandler.userFormatStringDecimal(specJournalDetail.getAmount()/specJournalDetail.getCurrencyRate())+"\" class=\"hiddenTextR\">");
                rowx.add("<input type=\"text\" size=\"4\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DESCRIPTION]+"\" value=\""+specJournalDetail.getDescription()+"\">");
            }else{
                rowx.add(deptObject.getDepartment());
                rowx.add("<div align=\"right\"><a href=\"javascript:cmdEdit('"+i+"')\">"+activity.getDescription()+"</a></div>");
                rowx.add("<div align=\"right\">"+contactList.getCompName()==null?contactList.getPersonName():contactList.getCompName()+"</div>");
                rowx.add("<div align=\"right\">"+objectCurrencyType.getCode()+"</div>");
                rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(specJournalDetail.getCurrencyRate())+"</div>");
                rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(specJournalDetail.getAmount() / specJournalDetail.getCurrencyRate())+"</div>");
                rowx.add("<div align=\"right\">"+specJournalDetail.getDescription()+"</div>");
            }
            lstData.add(rowx);
        }

        rowx = new Vector();
        if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmSpecialJournalDetail.errorSize()>0)){

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
            // currency
            currencytypeid_value = new Vector(1,1);
            currencytypeid_key = new Vector(1,1);

            // for list data
            int iDeptSize = vDepartmentOid.size();
            String strSelectedDept = String.valueOf(specialJournalDetail.getDepartmentId());
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

            rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DEPARTMENT_ID], "", null, strSelectedDept, vectDeptKey, vectDeptName)); // <a href=\"javascript:cmdCheck()\">CHK</a>
            rowx.add("<textarea name=\"act_desc\">"+activity.getDescription()+"</textarea><a href=\"javascript:cmdopen()\" disable=\"true\">GET</a>");
            String name = "";
            if(contactList.getCompName()==null)
                name = contactList.getPersonName();
            else
                name = contactList.getCompName();

            rowx.add("<input type=\"text\" size=\"20\" name=\"cont_name\" value=\""+name+"\" class=\"hiddenText\" readOnly><a href=\"javascript:cmdopencontact()\" disable=\"true\">GET</a>");
            rowx.add(ControlCombo.draw(FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_TYPE_ID], null, sSelectedCurrType, currencytypeid_key, currencytypeid_value, "onChange=\"javascript:changeCurrType()\"", ""));
            rowx.add("<input type=\"text\" size=\"10\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_RATE]+"\" value=\""+FRMHandler.userFormatStringDecimal(specialJournalDetail.getCurrencyRate())+"\" class=\"formElemenR\" readOnly>");
            rowx.add("<input type=\"text\" size=\"4\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT ]+"\" value=\""+FRMHandler.userFormatStringDecimal(specialJournalDetail.getAmount()/specialJournalDetail.getCurrencyRate())+"\" class=\"hiddenTextR\">");
            rowx.add("<input type=\"text\" size=\"4\" name=\""+FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_DESCRIPTION]+"\" value=\""+specialJournalDetail.getDescription()+"\">");
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
long journalID = FRMQueryString.requestLong(request,"journal_id");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
int indexEdit = FRMQueryString.requestInt(request, "index_edit");

/**
* Declare Commands caption
*/
String strAddDetail = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : "Tambah Baru Detail";
String strPosted = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Posted Journal" : "Posted Jurnal";

long periodeOID = PstPeriode.getCurrPeriodId();
String msgErr = "";

    // for get main =================================
    SpecialJournalMain objSpecialJournalMain = new SpecialJournalMain();
    try{
        objSpecialJournalMain = (SpecialJournalMain)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
        if(objSpecialJournalMain==null)
            objSpecialJournalMain = new SpecialJournalMain();
    }catch(Exception e){}
    //=============================================================

    // get masterdata currency
    String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
    Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);

    /** Instansiasi object CtrlJurnalUmum and FrmJurnalUmum */
    CtrlSpecialJournalDetail ctrlSpecialJournalDetail = new CtrlSpecialJournalDetail(request);
    ctrlSpecialJournalDetail.setLanguage(SESS_LANGUAGE);
    FrmSpecialJournalDetail frmSpecialJournalDetail = ctrlSpecialJournalDetail.getForm();
    int ctrlErr = ctrlSpecialJournalDetail.action(iCommand);
    SpecialJournalDetail objSpecialJournalDetail = ctrlSpecialJournalDetail.getJurnalDetail();

    // assign
    CtrlSpecialJournalDetailAssignt  ctrlSpecialJournalDetailAssignt = new CtrlSpecialJournalDetailAssignt(request);
    FrmSpecialJournalDetailAssignt frmSpecialJournalDetailAssignt = ctrlSpecialJournalDetailAssignt.getForm();
    ctrlErr = ctrlSpecialJournalDetailAssignt.action(iCommand);
    SpecialJournalDetailAssignt specialJournalDetailAssignt = ctrlSpecialJournalDetailAssignt.getJurnalDetail();

    /** Saving object jurnalumum into session */
    Vector objectClass = new Vector();
    objectClass = (Vector)session.getValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
    if(objectClass==null)
        objectClass = new Vector();

    if(objSpecialJournalDetail.getOID()==0){
        if(iCommand==Command.SAVE){
            try{ // ini digunakan untuk nyimpan data ke session saat tombol post
                System.out.println("=>>>>> indexEdit :"+indexEdit);
                if(indexEdit==-1 && objSpecialJournalDetail.getIdPerkiraan()!=0 &&
                        specialJournalDetailAssignt.getActivityId()!=0 &&
                        objSpecialJournalDetail.getContactId()!=0 &&
                        objSpecialJournalDetail.getAmount()>0){

                    Vector dtlList = new  Vector();
                    objSpecialJournalDetail.setAmount(objSpecialJournalDetail.getAmount()*objSpecialJournalDetail.getCurrencyRate());
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
                }else{
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
                }
            }catch(Exception e){}
        }else{ // ini di gunakan tambah jurnal tapi tidak command post
            if(iCommand==Command.NONE){
                try{
                    session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL_DETAIL);
                }catch(Exception e){}
            }else{
                try{
                    switch(iCommand){
                        case Command.EDIT:
                            Vector temp = (Vector)objectClass.get(indexEdit);
                            objSpecialJournalDetail = (SpecialJournalDetail)temp.get(0); // if ada
                            specialJournalDetailAssignt = (SpecialJournalDetailAssignt)temp.get(1);
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
    }else{

    }

    String contactName = "";
    ContactList contactList = new ContactList();


    // boolean periodClosed = PstPeriode.isPeriodClosed(objSpcJournalDetail.getPeriodeId());

    /** if Command.POST and no error occur, redirect to journal detail page */
    try{
        //System.out.println("contact id : "+jUmum.getContactOid());
        contactList = PstContactList.fetchExc(objSpecialJournalMain.getContactId());
        contactName = contactList.getCompName();
        if(contactName.length()==0)
            contactName = contactList.getPersonName()+" "+contactList.getPersonLastname();
    }catch(Exception e){}

    //Vector listjurnaldetail = objSpecialJournalDetail.getJurnalDetails();

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

    double total = getAmountActivity(objectClass);
    Vector vSaldoAkhir = SessSpecialJurnal.getTotalSaldoAccountLink(objSpecialJournalMain.getIdPerkiraan());
    if(iCommand==Command.SUBMIT){
         %>
        <jsp:forward page="journalmain.jsp">
        <jsp:param name="command" value="<%=Command.NONE%>"/>
        </jsp:forward>
         <%
    }
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">
function cmdCancel(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.NONE %>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.target="_self";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="jumum.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}
function cmdSave(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="journaldetail.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
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

function cmdopen(){
	window.open("activity.jsp","activity_list","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdopencontact(){
	window.open("donor_list.jsp?src_from=1","donor_list","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdBack(){
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.command.value="<%=Command.BACK%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.start.value="<%=start%>";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.action="jlist.jsp";
	document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.submit();
}

function changeCurrType()
{

	var iCurrType = document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_TYPE_ID]%>.value;
    //alert(iCurrType);
    switch(iCurrType)
	{
	<% System.out.println(" vlistStandartRate =========================="+vlistStandartRate.size());
	if(vlistStandartRate!=null && vlistStandartRate.size()>0)
	{
		int ilistStandartRateCount = vlistStandartRate.size();
		for(int i=0; i<ilistStandartRateCount; i++)
		{
			StandartRate objStandartRate = (StandartRate) vlistStandartRate.get(i);
	%>
		case '<%=objStandartRate.getCurrencyTypeId()%>':
			 document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_RATE]%>.value = "<%=FrmSpecialJournalDetail.userFormatStringDecimal(objStandartRate.getSellingRate())%>";
			 break;
	<%
		}
	}
	%>
		default :
			 document.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CURRENCY_RATE]%>.value = "<%=FrmSpecialJournalDetail.userFormatStringDecimal(1)%>";
			 break;
	}
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
            &gt; <%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="journal_id" value="<%=journalID%>">
              <input type="hidden" name="list_command" value="<%=Command.LIST%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
             <input type="hidden" name="index_edit" value="<%=indexEdit%>">

              <input type="hidden" name="<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN]%>" value="<%=objSpecialJournalDetail.getIdPerkiraan()%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalDetailAssignt.fieldNames[FrmSpecialJournalDetailAssignt.FRM_ACTIVITY_ID]%>" value="<%=specialJournalDetailAssignt.getActivityId()%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_CONTACT_ID]%>" value="<%=objSpecialJournalDetail.getContactId()%>" size="35">
              <input type="hidden" name="<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_AMOUNT_STATUS]%>" value="<%=""+PstSpecialJournalMain.STS_KREDIT%>" size="35">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr>
                        <td width="100%" height="2">&nbsp;
                         
                        </td>
                      </tr>
                      <tr>
                        <td width="100%" class="tabtitleactive">
                          <table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                              <td width="94%" height="25" class="listgensell" valign="top">&nbsp;</td>
                              <td width="3%" height="25" class="listgensell" valign="top">&nbsp;</td>
                            </tr>
                            <tr>
                              <td width="3%" valign="top"></td>
                              <td width="94%" valign="top">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                                  <tr> 
                                    <td width="42%" height="25" ><table width="100%"  border="0" >
                                        <tr > 
                                          <td width="9%"><%=strTitleMain[SESS_LANGUAGE][0]%></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="14%"> <%
											Perkiraan objPerkiraan = new Perkiraan();
											  try{
                                              objPerkiraan = PstPerkiraan.fetchExc(objSpecialJournalMain.getIdPerkiraan());
                                              }catch(Exception e){}
                                        %> <%=objPerkiraan.getNama()%> </td>
                                          <td width="30%"><table width="60%"  border="0" class="listgenvalue">
                                              <tr> 
                                                <td width="50%" nowrap><%=strTitleMain[SESS_LANGUAGE][1]%></td>
                                                <td width="9%"><strong>:</strong></td>

                                                  <%
                                                      double salakhir = 0.0;
                                                    if(vSaldoAkhir!=null && vSaldoAkhir.size()>0){
                                                        Vector temp = (Vector)vSaldoAkhir.get(0);
                                                        salakhir = Double.parseDouble((String)temp.get(1));
                                                        salakhir = salakhir + objSpecialJournalMain.getAmount();
                                                    }
                                                  %>
                                                <td width="41%" nowrap><%=salakhir%></td>
                                              </tr>
                                            </table></td>
                                          <td width="14%" nowrap><%=strTitleMain[SESS_LANGUAGE][2]%></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="7%" nowrap> <%
											out.println(objSpecialJournalMain.getVoucherNumber());
									        %> </td>
                                          <td width="13%" nowrap><%=strTitleMain[SESS_LANGUAGE][3]%></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="10%" nowrap> <%
									   out.println(Formater.formatDate(objSpecialJournalMain.getEntryDate(),"MMM dd,  yyyy"));
									  %> </td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <tr> 
                                    <td height="25"><table width="99%"  border="0" cellpadding="0" cellspacing="0" class="listgenkubaru">
                                        <tr> 
                                          <td width="13%"><%=strTitleMain[SESS_LANGUAGE][4]%></td>
                                          <td width="1%"><strong>:</strong></td>
                                            <%
                                                String namaContak = "";
                                                if(contactList.getCompName().length()>0)
                                                    namaContak = contactList.getCompName();
                                                else
                                                    namaContak = contactList.getPersonName();
                                            %>
                                          <td width="44%"><%=namaContak%></td>
                                          <td width="10%"><%=strTitleMain[SESS_LANGUAGE][5]%></td>
                                          <td width="1%"><strong>:</strong></td>
                                          <td width="31%"><%=objSpecialJournalMain.getReference()%></td>
                                        </tr>
                                        <tr>
                                          <td><%=strTitleMain[SESS_LANGUAGE][6]%></td>
                                          <td><strong>:</strong></td>
                                          <td><%=contactList.getBussAddress()%></td>
                                          <td><%=strTitleMain[SESS_LANGUAGE][7]%></td>
                                          <td><strong>:</strong></td>
                                          <td> <%=Formater.formatDate(objSpecialJournalMain.getTransDate(),"MMM dd,  yyyy")%> </td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td> <%
                                              CurrencyType currencyType = new CurrencyType();
                                              try{
                                                currencyType = PstCurrencyType.fetchExc(objSpecialJournalMain.getCurrencyTypeId());
                                              }catch(Exception e){}
                                              out.println(currencyType.getCode());
										%> </td>
                                          <td><strong>:</strong></td>
                                          <td><%=objSpecialJournalMain.getAmount()%></td>
                                        </tr>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp; </td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr align="right">
                                            <%
                                                NumberSpeller numberSpeller = new NumberSpeller();
                                            %>
                                          <td colspan="6"><em><%=numberSpeller.spellNumberToEng(objSpecialJournalMain.getAmount())%>&nbsp;&nbsp;<%=currencyType.getName()%></em></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="6">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td><%=strTitleMain[SESS_LANGUAGE][8]%></td>
                                          <td colspan="5"><%=objSpecialJournalMain.getDescription()%></td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td colspan="5">&nbsp;</td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <tr>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td><table width="30%"  border="0" class="listgenvalue">
                                        <tr> 
                                          <td width="34%"><%=strTitleMain[SESS_LANGUAGE][9]%></td>
                                          <td width="66%">: <%=FRMHandler.userFormatStringDecimal(total)%></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <tr> 
                                    <td><%=listJurnalDetail(iCommand,SESS_LANGUAGE,frmSpecialJournalDetail,objectClass,vDepartmentOid,objSpecialJournalDetail,specialJournalDetailAssignt,vlistCurrencyType,indexEdit)%></td>
                                  </tr>
                                  <tr> 
                                    <td> <%
                                        String sCommandAddSaveAskBack = "";
                                        sCommandAddSaveAskBack = sCommandAddSaveAskBack + "<a href=\"javascript:cmdSave()\">Simpan</a> ";
                                        if(iCommand==Command.EDIT){
                                            sCommandAddSaveAskBack = sCommandAddSaveAskBack + "| <a href=\"javascript:cmdDelete()\">Delete</a>";
                                        }else{
                                            if(total==objSpecialJournalMain.getAmount()){
                                                sCommandAddSaveAskBack = sCommandAddSaveAskBack + "| <a href=\"javascript:cmdPosted()\"> POSTED</a>";
                                            }
                                        }
                                      out.println(sCommandAddSaveAskBack);
									  %> </td>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%//}%>
