<%@ page language="java" %>

<!-- import java -->
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>

<!-- import aiso -->
<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.form.periode.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.periode.*" %>
<%@ page import="com.dimata.aiso.session.specialJournal.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>

<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;
%>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition
if(!privView && !privAdd && !privSubmit){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<!-- JSP Block -->
<%!
public static String strTitle[][] =
{
	{
		"Tgl Transaksi",
		"No Voucher",
		"Dokumen Referensi",
		"Nama Kontak",
		"Operator",
		"Urut Berdasar",
		"Periode Ini (",
		"Berdasar Tanggal, Dari ",
		" Sampai ",
		")"
	},
	{
		"Transaction Date",
		"Voucher No",
		"Document Reference",
		"Contact Name",
		"Operator",
		"Sort By",
		"Current Period (",
		"Base On Date, From ",
		" To ",
		")"
	}
};

public static final String masterTitle[] =
{
	"Jurnal Khusus","Journal Inquiries"
};

public static final String searchTitle[] =
{
	"Pencarian Jurnal Setoran Bank","Bank Deposit"
};

public String getJspTitle(String textJsp[][], int index, int language, String prefiks, boolean addBody)
{
	String result = "";
	if(addBody)
	{
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT)
		{
			result = textJsp[language][index] + " " + prefiks;
		}
		else
		{
			result = prefiks + " " + textJsp[language][index];
		}
	}
	else
	{
		result = textJsp[language][index];
	}
	return result;
}
%>


<%
int iCommand = FRMQueryString.requestCommand(request);

String orderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
Vector listPeriod = PstPeriode.list(0,0,"",orderBy);
Date firstPeriodDate = new Date();
if(listPeriod!=null && listPeriod.size()>0)
{
	Periode per = (Periode)listPeriod.get(0);
	firstPeriodDate = per.getTglAwal();
}
Date nowDate = new Date();
int interval = firstPeriodDate.getYear() - nowDate.getYear();

Vector listOperator =  PstAppUser.listAll();
SrcJurnalUmum srcJurnalUmum = new SrcJurnalUmum();
if(session.getValue(SrcJurnalUmum.SESS_SEARCH_JURNAL_UMUM)!=null)
{
	srcJurnalUmum = (SrcJurnalUmum)session.getValue(SrcJurnalUmum.SESS_SEARCH_JURNAL_UMUM);
}

if(iCommand == Command.NONE){
	srcJurnalUmum = new SrcJurnalUmum();
}

// ControlLine and Commands caption
ControlLine ctrLine = new ControlLine();
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Journal" : "Jurnal";
String strAdd = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSearch = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);
String strCloseBook = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close Book" : "Tutup Buku";
String strAddJournal = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Journal" : "Tambah Jurnal";
String strSetupPeriode = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close Book" : "Tutup Buku";

try
{
	session.removeValue(SessSpecialJurnal.SESS_SPECIAL_JOURNAL);
}
catch(Exception e)
{
	System.out.println("--- Remove session error ---");
}

CtrlPeriode ctrlperiode = new CtrlPeriode(request);
int periodStatus = ctrlperiode.getStatusPeriod();
String periodMessage = ctrlperiode.msgPeriodeText[SESS_LANGUAGE][periodStatus];
FrmSrcContactList frmSrcContactList = new FrmSrcContactList();
String currStartDate = "";
String currDueDate = "";
Vector currDate = PstPeriode.getCurrPeriod();
if(currDate.size()==1)
{
   Periode per = (Periode) currDate.get(0);
   if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
   {
	   currStartDate = Formater.formatDate(per.getTglAwal(),SESS_LANGUAGE,"MMM dd, yyyy");
	   currDueDate = Formater.formatDate(per.getTglAkhir(),SESS_LANGUAGE,"MMM dd, yyyy");
   }
   else
   {
	   currStartDate = Formater.formatDate(per.getTglAwal(),SESS_LANGUAGE,"dd MMM yyyy");
	   currDueDate = Formater.formatDate(per.getTglAkhir(),SESS_LANGUAGE,"dd MMM yyyy");
   }
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
	<%if(privAdd){%>
	function cmdAdd(){
		document.frmjournal.command.value="<%=Command.ADD%>";
		document.frmjournal.add_type.value="<%=ADD_TYPE_SEARCH%>";		
		document.frmjournal.action="journalmain.jsp";
		document.frmjournal.submit();
	}

	function cmdUpdateVoucher(){
		document.frmjournal.command.value="<%=Command.SUBMIT%>";		
		document.frmjournal.action="journalmain.jsp";
		document.frmjournal.submit();
	}
	<%}%>
	
	<%if(isUseDatePicker.equalsIgnoreCase("Y")){%>
function getThn()
{
	var date1 = ""+document.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_START_DATE]%>.value;
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
	document.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_START_DATE] + "_mn"%>.value=bln;
	document.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_START_DATE] + "_dy"%>.value=hri;
	document.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_START_DATE] + "_yr"%>.value=thn;
	
	var date2 = ""+document.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_END_DATE]%>.value;
	
	var thn2 = date2.substring(6,10);
	
	var bln2 = date2.substring(3,5);	
	if(bln2.charAt(0)=="0"){
		bln2 = ""+bln2.charAt(1);
	}
	
	var hri2 = date2.substring(0,2);
	if(hri2.charAt(0)=="0"){
		hri2 = ""+hri2.charAt(1);
	}
	
	document.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_END_DATE] + "_mn"%>.value=bln2;
	document.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_END_DATE] + "_dy"%>.value=hri2;
	document.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_END_DATE] + "_yr"%>.value=thn2;				
				
}
<%}%>

    function cmdopen(){
		var url = "contact_list.jsp?command=<%=Command.LIST%>&"+
				"<%=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_NAME] %>="+document.frmjournal.<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_CONTACT_ID]%>_TEXT.value;
        window.open(url,"src_cnt_bank_dep_src","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
    }

	function cmdSearch(){
		document.frmjournal.command.value="<%=Command.LIST%>";
		document.frmjournal.target="_self";
		document.frmjournal.action="journallist.jsp";
		document.frmjournal.submit();
	}

	function cmdSetPeriod(){
		var act = "<%=approot%>" + "/period/setup_period.jsp";
		document.frmjournal.command.value="<%=Command.LIST%>";
		document.frmjournal.target="_self";
		document.frmjournal.action=act;
		document.frmjournal.submit();
	}

	function cmdCloseBook(){
		var act = "<%=approot%>" + "/period/close_book.jsp";
		document.frmjournal.command.value="<%=Command.NONE%>";
		document.frmjournal.target="_self";
		document.frmjournal.action=act;
		document.frmjournal.submit();
	}
	
<%if(isUseDatePicker.equalsIgnoreCase("Y")){%>
		function hideObjectForDate(){
									
		}
		
		function showObjectForDate(){
			
		}
<%}%>
	   

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
		    <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=searchTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmjournal" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="add_type" value="">
              <input type="hidden" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_CONTACT_ID]%>" value="">
			  <table width="100%">
			  
			  <tr>
			  <td>
              	<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
					<tr>
						<td>
							<table width="100%" border="0" cellpadding="1" cellspacing="0" class="search02">
                <tr>
                  <td colspan="3">&nbsp;
                    
                  </td>
                </tr>
                <%if(periodStatus>ctrlperiode.MSG_PER_OK){%>
                <tr>
                  <td colspan="3" class="msgErrComment"><%=periodMessage%></td>
                </tr>
                <%}%>
                <tr>
                  <td width="10%" valign="top"><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top"><b>:</b></td>
                  <td width="89%">
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr>
                        <td>
                          <input type="radio" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_DATE_TYPE]%>" value="<%=FrmSrcJurnalUmum.DATEPARAM_PERIOD%>" <%if(srcJurnalUmum.getDateStatus()==FrmSrcJurnalUmum.DATEPARAM_PERIOD){%>checked<%}%>>
                          <%=strTitle[SESS_LANGUAGE][6]%><%=currStartDate+"&nbsp;&nbsp;to&nbsp;&nbsp;"+currDueDate%><%=strTitle[SESS_LANGUAGE][9]%></td>
                      </tr>
                      <!--<tr>
                        <td>
                          <input type="radio" name="<%//=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_DATE_TYPE]%>" value="<%//=FrmSrcJurnalUmum.DATEPARAM_NONE%>" <%//if(srcJurnalUmum.getDateStatus()==FrmSrcJurnalUmum.DATEPARAM_NONE){%>checked<%//}%>>
                          Including All Date</td>
                      </tr>-->
                      <tr>
                        <td>
                          <input type="radio" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_DATE_TYPE]%>" value="<%=FrmSrcJurnalUmum.DATEPARAM_DATE%>" <%if(srcJurnalUmum.getDateStatus()==FrmSrcJurnalUmum.DATEPARAM_DATE){%>checked<%}%>>
                          <%
						  Date startDateCondition = new Date();
						  Date dueDateCondition = new Date();
						  if(srcJurnalUmum.getStartDate()!=null){startDateCondition = srcJurnalUmum.getStartDate();}
						  if(srcJurnalUmum.getEndDate()!=null){dueDateCondition = srcJurnalUmum.getEndDate();}
						  %>
						  <%=strTitle[SESS_LANGUAGE][7]%>&nbsp;&nbsp;
						  <%if(isUseDatePicker.equalsIgnoreCase("Y")){%>										   										   
										  <input onClick="ds_sh(this);" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_START_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate(startDateCondition, "dd-MM-yyyy")%>"/> 						  
										  <input type="hidden" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_START_DATE] + "_mn"%>">
										  <input type="hidden" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_START_DATE] + "_dy"%>">
										  <input type="hidden" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_START_DATE] + "_yr"%>">
										  
										  <%}%>
                          <%//=strTitle[SESS_LANGUAGE][7]%><%//=ControlDate.drawDate(FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_START_DATE], startDateCondition, 0, interval)%>
						  <%=strTitle[SESS_LANGUAGE][8]%>&nbsp;&nbsp;
						  <%if(isUseDatePicker.equalsIgnoreCase("Y")){%>										   										   
										  <input onClick="ds_sh(this);" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_END_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate(dueDateCondition, "dd-MM-yyyy")%>"/> 						  
										  <input type="hidden" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_END_DATE] + "_mn"%>">
										  <input type="hidden" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_END_DATE] + "_dy"%>">
										  <input type="hidden" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_END_DATE] + "_yr"%>">
										  <script language="JavaScript" type="text/JavaScript">getThn();</script>
										  <%}%>
						  <%//=ControlDate.drawDate(FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_END_DATE], dueDateCondition, 0, interval)%></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td width="10%" nowrap><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="89%">&nbsp;&nbsp;
                    <input type="text" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_VOUCHER_NUMBER]%>" size="10" value="<%=srcJurnalUmum.getVoucherNo()%>">
				  <input type="hidden" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_VOUCHER]%>" size="10" value="<%=srcJurnalUmum.getVoucher()%>">
                    <input type="hidden" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_JOURNAL_NUMBER]%>" size="10" value="<%=srcJurnalUmum.getStrJournalNumber()%>">                 
                  </td>
                </tr>
                <tr>
                  <td width="10%" nowrap><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="89%">&nbsp;&nbsp;
                    <input type="text" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_INVOICE_NO]%>" size="20" value="<%=srcJurnalUmum.getInvoice()%>">
                  </td>
                </tr>
                <tr>
                  <td height="80%"><%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td><b>:</b></td>
                  <td>&nbsp;&nbsp;
				  <input type="text" name="<%=FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_CONTACT_ID]%>_TEXT" value="" size="25">
                    <a href="javascript:cmdopen()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a> </td>
                </tr>
                <tr>
                  <td width="10%" height="80%"><%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="89%">
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr>
                        <td>
                          <%
							Vector optKey = new Vector(1,1);
							Vector optValue = new Vector(1,1);
							if(listOperator.size()> 0 && listOperator != null){
							    optValue.add(String.valueOf(FrmSrcJurnalUmum.ALL_OPERATOR));
							    optKey.add(FrmSrcJurnalUmum.textOperator[SESS_LANGUAGE][FrmSrcJurnalUmum.ALL_OPERATOR]);
								try{
									for(int i = 0; i < listOperator.size(); i ++){
										AppUser operator = (AppUser)listOperator.get(i);
										optKey.add((String)operator.getLoginId());
										optValue.add(""+operator.getOID());
									}
								}catch(Exception exc){
								}
							}
							String selectOpt = ""+srcJurnalUmum.getOperatorId();
	    				  %>
                          <%="&nbsp;&nbsp;"+ControlCombo.draw(FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_OPERATOR_ID],null,selectOpt,optValue,optKey)%> </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td width="10%" height="80%"><%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="89%">
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr>
                        <td>
                          <%
						  Vector vSortKey = new Vector(1,1);
						  Vector vSortValue = new Vector(1,1);
						  String sSelectedSort = String.valueOf(srcJurnalUmum.getOrderBy());
						   	  vSortKey.add(FrmSrcJurnalUmum.sortFieldNames[SESS_LANGUAGE][2]);
							  vSortValue.add(""+FrmSrcJurnalUmum.SORT_BY_OPERATOR);
							  vSortKey.add(FrmSrcJurnalUmum.sortFieldNames[SESS_LANGUAGE][3]);
							  vSortValue.add(""+FrmSrcJurnalUmum.SORT_BY_VOUCHER_NUMBER);
							  vSortKey.add(FrmSrcJurnalUmum.sortFieldNames[SESS_LANGUAGE][4]);
							  vSortValue.add(""+FrmSrcJurnalUmum.SORT_BY_TRANS_DATE);		
						  %>
                          <%="&nbsp;&nbsp;"+ControlCombo.draw(FrmSrcJurnalUmum.fieldNames[FrmSrcJurnalUmum.FRM_SEARCH_ORDER_BY],null,sSelectedSort,vSortValue,vSortKey)%> </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <%if((periodStatus==ctrlperiode.MSG_PER_OK)||(periodStatus==ctrlperiode.MSG_PER_LAST)||(periodStatus==ctrlperiode.MSG_PER_LAST_DUE)){%>
                <%if((privAdd)){%>
                <tr>
                  <td height="16" colspan="3">&nbsp;</td>
                </tr>
                <tr>
                  <td height="16" colspan="2">&nbsp;&nbsp;&nbsp;<b><a href="javascript:cmdSearch()"><%=strSearch%></a></b></td>
                  <td height="16"><div align="right">
                    <!-- <input type="button" name="addjournal" value="<%//=strAddJournal%>" onClick="javascript:cmdAdd()"> -->
                  </div></td>
                </tr>
                <%}%>
                <%}else{%>
                <%if(periodStatus==ctrlperiode.MSG_NO_PER){%>
                <tr>
                  <td height="16">&nbsp;</td>
                  <td height="16" class="command">&nbsp;</td>
                  <td height="16" class="command">&nbsp;</td>
                </tr>
                <tr>
                  <td width="10%" height="16">&nbsp;</td>
                  <td width="1%" height="16" class="command">&nbsp;</td>
                  <td width="89%" height="16" class="command">&nbsp;&nbsp;&nbsp;<a href="javascript:cmdSetPeriod()"><%=strSetupPeriode%></a></td>
                </tr>
                <%}else{%>
                <tr>
                  <td width="10%" height="16">&nbsp;</td>
                  <td width="1%" height="16" class="command">&nbsp;</td>
                  <td width="89%" height="16" class="command">&nbsp;&nbsp;&nbsp;<a href="javascript:cmdCloseBook()"><%=strCloseBook%></a></td>
                </tr>
                <%}%>
                <%}%>
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>