<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>
<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.ij.form.mapping.CtrlIjLocationMapping"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>
<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>
<!-- import qdep -->
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<!--package common -->
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.entity.payment.*" %>
<!-- import ij -->
<%@ page import = "com.dimata.ij.iaiso.*" %>
<%@ page import = "com.dimata.ij.ibosys.*" %>
<%@ page import = "com.dimata.ij.entity.search.*" %>
<%@ page import = "com.dimata.ij.form.search.*" %>
<%@ page import = "com.dimata.ij.session.engine.*" %>

<% int  appObjCode =  1;//AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%//@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));
%>

<%!
public static final String textJspTitle[][] = {
	{
	 "Dok. Referensi",
	 "Tgl Transaksi",
	 "Keterangan",
	 "Debet",
	 "Kredit"
	},

	{
	 "Reference Doc.",
	 "Transaction Date",
	 "Transaction Note",
	 "Debet",
	 "Credit"
	}
};


public String listDrawJurnal(FRMHandler objFRMHandler, Vector objectClass, Vector listCurrencyAiso, int language)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat("","2%","left","left");
	ctrlist.dataFormat(textJspTitle[language][0],"10%","left","left");
	ctrlist.dataFormat(textJspTitle[language][1],"10%","left","left");
	ctrlist.dataFormat(textJspTitle[language][2],"54%","left","left");
	ctrlist.dataFormat(textJspTitle[language][3],"12%","right","right");
	ctrlist.dataFormat(textJspTitle[language][4],"12%","right","right");

	ctrlist.setLinkRow(1);
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();

	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();

	// selected aisoCurrency
	Hashtable hastAiso = new Hashtable();
	if(listCurrencyAiso!=null && listCurrencyAiso.size()>0){
		int maxCurrencyAiso = listCurrencyAiso.size();
		for(int i=0; i<maxCurrencyAiso; i++){
			CurrencyType objCurrencyType = (CurrencyType) listCurrencyAiso.get(i);
			hastAiso.put(String.valueOf(objCurrencyType.getOID()), objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");
		}
	}

	String dateStrEntry = "";
    String dateStrTrans = "";
	int index = -1;

	for (int i=0; i<objectClass.size(); i++)
	{
		IjJournalMain objIjJournalMain = (IjJournalMain) objectClass.get(i);

		Vector rowx = new Vector(1,1);
	    rowx.add("<input type=\"checkbox\" name=\"ij_journal_oid\" value=\""+objIjJournalMain.getOID()+"\">");
		rowx.add(String.valueOf(objIjJournalMain.getRefBoDocNumber()));
		//rowx.add(String.valueOf(hastAiso.get(String.valueOf(objIjJournalMain.getJurTransCurrency()))));
		rowx.add(Formater.formatDate(objIjJournalMain.getJurTransDate(),"MMM dd, yyyy"));

		rowx.add(""+objIjJournalMain.getJurDesc());

		double amountDt = 0;
		double amountCr = 0;
		Vector listDetail = objIjJournalMain.getListOfDetails();
		if(listDetail!=null && listDetail.size()>0)
		{
			int detailCount = listDetail.size();
			for(int j=0; j<detailCount; j++)
			{
				IjJournalDetail objIjJournalDetail = (IjJournalDetail) listDetail.get(j);
				amountDt = amountDt + objIjJournalDetail.getJdetDebet();
				amountCr = amountCr + objIjJournalDetail.getJdetCredit();
			}
		}
		rowx.add(objFRMHandler.userFormatStringDecimal(amountDt));
		rowx.add(objFRMHandler.userFormatStringDecimal(amountCr));

		lstData.add(rowx);
		lstLinkData.add(String.valueOf(objIjJournalMain.getOID()));
	}
	return ctrlist.drawMe(index);
}
%>


<%
    ControlLine ctrlLine = new ControlLine();
int iCommand = FRMQueryString.requestCommand(request);
int iSystemSelected = FRMQueryString.requestInt(request,"BO_SYSTEM");
    int iCommList = FRMQueryString.requestInt(request,"command_list");
int start = FRMQueryString.requestInt(request,"start");
int recordToGet = 50;
int vectSize = 0;

// setting currency format
FRMHandler objFRMHandler = new FRMHandler();
objFRMHandler.setDigitSeparator(".");
objFRMHandler.setDecimalSeparator(",");


    // proses list data for limit
    SessJournal objSessJournal = new SessJournal();
    SrcIjJournal objSrcIjJournal = new SrcIjJournal();
    FrmSrcIjJournal objFrmSrcIjJournal = new FrmSrcIjJournal(request);
    if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)||(iCommand==Command.LAST)||(iCommand==Command.SAVE)){
        try{
            iCommList = iCommand;
            objSrcIjJournal = (SrcIjJournal)session.getValue("SESS_IJJOURNAL");
            vectSize = SessJournal.getCountJournal(objSrcIjJournal);
            CtrlIjLocationMapping ctrlIjLocationMapping = new CtrlIjLocationMapping(request);
            start = ctrlIjLocationMapping.actionList(iCommand, start, vectSize, recordToGet);
        }catch(Exception e){
            objSrcIjJournal = new SrcIjJournal();
        }
    }else{
        if(iCommand == Command.SAVE){
            objSrcIjJournal = (SrcIjJournal)session.getValue("SESS_IJJOURNAL");
            vectSize = SessJournal.getCountJournal(objSrcIjJournal);
        }else{
            iCommList = Command.LIST;
            System.out.println("SESS_IJJOURNAL :::::::: ");
            start = 0;
            objFrmSrcIjJournal.requestEntityObject(objSrcIjJournal);
            objSrcIjJournal.setJournalStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
            session.putValue("SESS_IJJOURNAL", objSrcIjJournal);
            vectSize = SessJournal.getCountJournal(objSrcIjJournal);
        }
    }

Vector listJurnal = objSessJournal.getJournal(objSrcIjJournal, start, recordToGet);

PstCurrencyType objPstCurrencyType = new PstCurrencyType();
String strOrder = objPstCurrencyType.fieldNames[objPstCurrencyType.FLD_TAB_INDEX];
Vector listCurrAiso = objPstCurrencyType.list(0, 0, "", strOrder);

if(iCommand == Command.SAVE){
	// nyimpan object IjJournal ke hastable
	Hashtable hashJournal = new Hashtable();
	if(listJurnal!=null && listJurnal.size()>0){
		int iMaxJournal = listJurnal.size();
		for(int i=0; i<iMaxJournal; i++){
			IjJournalMain objIjJournalMain = (IjJournalMain) listJurnal.get(i);
			hashJournal.put(String.valueOf(objIjJournalMain.getOID()), objIjJournalMain);
		}

		Vector vSelectedJournal = new Vector(1,1);
		String sArrIjJournalOid[] = request.getParameterValues("ij_journal_oid");
		if(sArrIjJournalOid!=null && sArrIjJournalOid.length>0){
			int iMaxSelectedJournal = sArrIjJournalOid.length;
			for(int i=0; i<iMaxSelectedJournal; i++){
				try{
                    IjJournalMain objIjJMain = (IjJournalMain) hashJournal.get(""+sArrIjJournalOid[i]);
					if(objIjJMain.getOID() != 0){
						vSelectedJournal.add(objIjJMain);
					}
				}catch(Exception e){
					System.out.println("Exc when get data from hastable : " + e.toString());
				}
			}
		}

		try{
			Periode objPeriod = PstPeriode.fetchExc(currentPeriodOid);
			if(objPeriod.getOID() != 0){
				IjEngineParam objIjEngineParam = new IjEngineParam();
				objIjEngineParam.setLCurrPeriodeOid(objPeriod.getOID());
				objIjEngineParam.setDStartDatePeriode(objPeriod.getTglAwal());
				objIjEngineParam.setDEndDatePeriode(objPeriod.getTglAkhir());
				objIjEngineParam.setDLastEntryDatePeriode(objPeriod.getTglAkhirEntry());
				objIjEngineParam.setLOperatorOid(userOID);
                objIjEngineParam.setIBoSystem(iSystemSelected);
                System.out.println("iSystemSelected : " + iSystemSelected);
                System.out.println("objPeriod.getOID() : " + objPeriod.getOID());
                System.out.println("objPeriod.getTglAwal() : " + objPeriod.getTglAwal());
                System.out.println("objPeriod.getTglAkhir() : " + objPeriod.getTglAkhir());
                System.out.println("objPeriod.getTglAkhirEntry() : " + objPeriod.getTglAkhirEntry());
                System.out.println("userOID : " + userOID);

				IjEngineController objIjEngineController = new IjEngineController();
				objIjEngineController.runAisoJournalProcess(vSelectedJournal, objIjEngineParam);

                // jika proses save to jurnal aiso sukses
                // maka buat list baru
                vectSize = SessJournal.getCountJournal(objSrcIjJournal);
                listJurnal = objSessJournal.getJournal(objSrcIjJournal, 0, 50);
                iCommList = Command.LIST;
                start = 0;
			}
		}catch(Exception e){
			System.out.println("Exc : " + e.toString());
		}
	}
}

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>AISO - Interactive Journal</title>
<script language="javascript">
function cmdEdit(oid)
{
	document.frmjournal.command.value="<%=Command.EDIT%>";
	document.frmjournal.hidden_ij_journal_main_id.value = oid;
	document.frmjournal.action="ij_journal_edit.jsp";
	document.frmjournal.submit();
}

function cmdPosted()
{
	document.frmjournal.command.value="<%=Command.SAVE%>";
	document.frmjournal.action="ij_journal_list.jsp";
	document.frmjournal.submit();
}

function cmdBack()
{
	document.frmjournal.command.value="<%=Command.BACK%>";
	document.frmjournal.action="src_ij_journal.jsp";
	document.frmjournal.submit();
}

function first(){
	document.frmjournal.command.value="<%=Command.FIRST%>";
	document.frmjournal.action="ij_journal_list.jsp";
	document.frmjournal.submit();
}

function prev(){
	document.frmjournal.command.value="<%=Command.PREV%>";
	document.frmjournal.action="ij_journal_list.jsp";
	document.frmjournal.submit();
}

function next(){
	document.frmjournal.command.value="<%=Command.NEXT%>";
	document.frmjournal.action="ij_journal_list.jsp";
	document.frmjournal.submit();
}

function last(){
	document.frmjournal.command.value="<%=Command.LAST%>";
	document.frmjournal.action="ij_journal_list.jsp";
	document.frmjournal.submit();
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->Journal
            &gt; Journal List<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmjournal" method="post" action="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="hidden_ij_journal_main_id" value="">
              <input type="hidden" name="BO_SYSTEM" value="<%=iSystemSelected%>">

              <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr>
                  <td>
                   &nbsp;
                  </td>
                </tr>
                <tr>
                  <td><%=listDrawJurnal(objFRMHandler,listJurnal,listCurrAiso,SESS_LANGUAGE)%></td>
                </tr>
                <tr>
                  <td><%=ctrlLine.drawMeListLimit(iCommList,vectSize,start,recordToGet,"first","prev","next","last","left")%></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;&nbsp;<a href="javascript:cmdPosted()" class="command">Posted
                    Journal</a> | <a href="javascript:cmdBack()" class="command">Back
                    To Search Journal</a></td>
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
