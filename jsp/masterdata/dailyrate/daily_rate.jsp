
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.DailyRate" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.PstDailyRate" %>
<%@ page import = "com.dimata.aiso.form.masterdata.CtrlDailyRate" %>
<%@ page import = "com.dimata.aiso.form.masterdata.FrmDailyRate" %>
<%@ page import = "com.dimata.common.entity.payment.CurrencyType" %>
<%@ page import = "com.dimata.common.entity.payment.PstCurrencyType" %>
<%@ include file = "../../main/javainit.jsp" %>
<% //int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
   int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_DAILY_RATE);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
public static final String textListTitle[][] =
{
	{"Kurs Harian","Harus diisi"},
	{"Daily Rate","required"}
};

public static final String textListHeader[][] =
{
	{"Valuta","Kurs Beli","Kurs Jual","Berlaku Mulai","Berakhir","Status","Lokal/Asing"},
	{"Currency Type","Buying Rate","Selling Rate","Start Date","End Date","Status","Local/Foreign"}
};

public String drawList(Vector objectClass, long dailyRateId, int languange, String sUserDecimalSeparator, String sUserDigitSeparator)

{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("75%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader(textListHeader[languange][0],"10%");
	ctrlist.addHeader(textListHeader[languange][1],"20%");
	ctrlist.addHeader(textListHeader[languange][2],"20%");
	ctrlist.addHeader(textListHeader[languange][3],"20%");
	ctrlist.addHeader(textListHeader[languange][4],"20%");
	ctrlist.addHeader(textListHeader[languange][5],"10%");
	
	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.reset();
	int index = -1;

	FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSeparator); 
	frmHandler.setDigitSeparator(sUserDigitSeparator);

	for (int i = 0; i < objectClass.size(); i++) 
	{
		DailyRate objDailyRate = (DailyRate)objectClass.get(i);
		Vector rowx = new Vector();
		
		if(dailyRateId == objDailyRate.getOID())
		{
			index = i;
		}

		String strSellingRate = frmHandler.userFormatStringDecimal(objDailyRate.getSellingAmount());
		String strBuyingRate = frmHandler.userFormatStringDecimal(objDailyRate.getBuyingAmount());		
		
		CurrencyType crType = new CurrencyType();
		String codeCurrency = "";
		try
		{
			crType = PstCurrencyType.fetchExc(objDailyRate.getCurrencyId());
			codeCurrency = crType.getCode();
		}
		catch(Exception e)
		{
			System.out.println("Exc : " + e.toString());
		}
		
		String str_dt_StartDate = ""; 
		try
		{
			Date dt_StartDate = objDailyRate.getStartDate();
			if(dt_StartDate==null)
			{
				dt_StartDate = new Date();
			}
			str_dt_StartDate = Formater.formatDate(dt_StartDate, "MMM dd, yyyy");
		}
		catch(Exception e)
		{ 
			str_dt_StartDate = ""; 
		}

		String str_dt_EndDate = ""; 
		try
		{
			Date dt_EndDate = objDailyRate.getEndDate();
			if(dt_EndDate==null)
			{
				dt_EndDate = new Date();
			}
			str_dt_EndDate = Formater.formatDate(dt_EndDate, "MMM dd, yyyy");
		}
		catch(Exception e)
		{ 
			str_dt_EndDate = ""; 
		}
		
		if(objDailyRate.getStatus()==PstDailyRate.ACTIVE)
		{			
			rowx.add("<a href=\"javascript:cmdEdit('"+objDailyRate.getOID()+"')\">"+codeCurrency+"</a>");
		}
		else
		{
			rowx.add(codeCurrency);
		}
		
		rowx.add("<div align=\"right\">"+strBuyingRate+"</div>");	
		rowx.add("<div align=\"right\">"+strSellingRate+"</div>");		
		rowx.add("<div align=\"center\">"+str_dt_StartDate+"</div>");		
		rowx.add("<div align=\"center\">"+str_dt_EndDate+"</div>");
		rowx.add(PstDailyRate.statusName[languange][objDailyRate.getStatus()]);
		
		lstData.add(rowx);
	}

	return ctrlist.draw();
}
%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidDailyRate = FRMQueryString.requestLong(request, "hidden_daily_rate_id");

boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = PstDailyRate.fieldNames[PstDailyRate.FLD_STATUS]+" DESC"; 
/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = textListTitle[SESS_LANGUAGE][0];
String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
					 
ctrLine.initDefault(SESS_LANGUAGE,currPageTitle);
CtrlDailyRate ctrlDailyRate = new CtrlDailyRate(request);
Vector vDailyRate = new Vector(1,1);

iErrCode = ctrlDailyRate.action(iCommand , oidDailyRate);
FrmDailyRate frmDailyRate = ctrlDailyRate.getForm();

int vectSize = PstDailyRate.getCount("");
DailyRate objDailyRate = ctrlDailyRate.getDailyRate();
msgString =  ctrlDailyRate.getMessage();

FRMHandler frmHandler = new FRMHandler();
frmHandler.setDecimalSeparator(","); 
frmHandler.setDigitSeparator("."); 

if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = ctrlDailyRate.actionList(iCommand, start, vectSize, recordToGet);
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlDailyRate.actionList(iCommand, start, vectSize, recordToGet);
} 

vDailyRate = PstDailyRate.list(start,recordToGet, whereClause , orderClause);

if (vDailyRate.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 vDailyRate = PstDailyRate.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function cmdAdd(){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.hidden_daily_rate_id.value="0";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.ADD%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
}

function cmdAsk(oidDailyRate){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.hidden_daily_rate_id.value=oidDailyRate;
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.ASK%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
}

function cmdConfirmDelete(oidDailyRate){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.hidden_daily_rate_id.value=oidDailyRate;
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
}
function cmdSave(){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
	}

function cmdEdit(oidDailyRate){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.hidden_daily_rate_id.value=oidDailyRate;
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
	}

function cmdCancel(oidDailyRate){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.hidden_daily_rate_id.value=oidDailyRate;
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
}

function cmdBack(){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.BACK%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
	}

function cmdListFirst(){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=Command.FIRST%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
}

function cmdListPrev(){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.PREV%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=Command.PREV%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
	}

function cmdListNext(){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=Command.NEXT%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
}

function cmdListLast(){
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.command.value="<%=Command.LAST%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.prev_command.value="<%=Command.LAST%>";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.action="daily_rate.jsp";
	document.<%=FrmDailyRate.FRM_DAILY_RATE%>.submit();
}

//-------------- script control line -------------------
function MM_swapImgRestore() { //v3.0
	var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.0
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}//-->


</script>

<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --> 
            Master Data : <font color="#CC3300"><%=textListTitle[SESS_LANGUAGE][0].toUpperCase()%></font> <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmDailyRate.FRM_DAILY_RATE%>" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_daily_rate_id" value="<%=oidDailyRate%>">
			  <table width="100%">
			  <tr>
			  <td>
              <table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
                <tr> 
                  <td> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="search00">
                      <tr><td>&nbsp;</td></tr>
                      <tr > 
                        <td height="22" colspan="3" > <%= drawList(vDailyRate,oidDailyRate,SESS_LANGUAGE,sUserDecimalSymbol,sUserDigitGroup)%> </td>
                      </tr>
                      <tr> 
                        <td height="8" align="left" colspan="3" class="command"> 
                          <span class="command"> 
                          <% 
						   
						   int comd = Command.NONE;
						   if ((iCommand == Command.FIRST || iCommand == Command.PREV )|| 
								(iCommand == Command.NEXT || iCommand == Command.LAST)){
									comd =iCommand; 
						   }else{
						   		if(iCommand == Command.SAVE){
						   			comd =Command.LAST;
									prevCommand = Command.LAST;
								}else{
									if(prevCommand == Command.LAST)
										comd =Command.LAST;
									else
								 		comd =Command.FIRST;
								 }
						   }
						   
						  
						  %>
                          <% ctrLine.setLocationImg(approot+"/images");
							   	ctrLine.initDefault();
								 %>
                          <%=ctrLine.drawMeListLimit(comd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> </span> </td>
                      </tr>
                      <tr > 
                        <td height="22" colspan="3"> 
                          <table width="20%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <%if(privAdd && privManageData){%>
                              <%if(iCommand==Command.NONE||iCommand==Command.FIRST||iCommand==Command.PREV||iCommand==Command.NEXT||iCommand==Command.LAST||iCommand==Command.BACK||iCommand==Command.SAVE||iCommand==Command.DELETE){%>
                              <td width="100%" nowrap class="command"><a href="javascript:cmdAdd()"><%=ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_ADD,true)%></a></td>
                              <%}}%>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr > 
                  <td height="8" colspan="3"> 
                    <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmDailyRate.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr > 
                        <td height="21" width="10%">&nbsp;</td>
                        <td height="21" width="1%">&nbsp;</td>
                        <td height="21" colspan="2" class="comment">*)= <%=textListTitle[SESS_LANGUAGE][1]%> </td>
                      </tr>
                      <tr > 
                        <td height="21" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][0]%></td>
                        <td height="21" width="1%">:</td>
                        <td height="21" colspan="2"> 
                          <% 
						   Vector currencytypeid_value = new Vector(1,1);
						   Vector currencytypeid_key = new Vector(1,1);
					 	  
						   String sel_currencytypeid = ""+objDailyRate.getCurrencyId();
						   					   
					   	   String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
					   	   Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);
						   if(listCurrencyType!=null&&listCurrencyType.size()>0)
						   {
								for(int i=0;i<listCurrencyType.size();i++)
								{
									CurrencyType currencyType =(CurrencyType)listCurrencyType.get(i);
									currencytypeid_value.add(currencyType.getCode());
									currencytypeid_key.add(""+currencyType.getOID());
								}
						   }
					   	  %>
                          <%= ControlCombo.draw(frmDailyRate.fieldNames[FrmDailyRate.FRM_CURRENCY_ID],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value, "", null) %> 
                      <tr> 
                        <td height="21" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][1]%></td>
                        <td height="21" width="1%">:</td>
                        <td height="21" colspan="2"> 
                          <input type="text" name="<%=frmDailyRate.fieldNames[FrmDailyRate.FRM_BUYING_AMOUNT] %>"  value="<%=frmHandler.userFormatStringDecimal(objDailyRate.getBuyingAmount())%>" style="text-align:right">
                          * <%= frmDailyRate.getErrorMsg(FrmDailyRate.FRM_BUYING_AMOUNT) %> 
                      <tr> 
                        <td height="21" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][2]%></td>
                        <td height="21" width="1%">:</td>
                        <td height="21" colspan="2"> 
                          <input type="text" name="<%=frmDailyRate.fieldNames[FrmDailyRate.FRM_SELLING_AMOUNT] %>"  value="<%=frmHandler.userFormatStringDecimal(objDailyRate.getSellingAmount())%>" style="text-align:right">
                          * <%= frmDailyRate.getErrorMsg(FrmDailyRate.FRM_SELLING_AMOUNT) %> 
						  <!--        Local Foreign                                  -->
                      <tr> 
                        <td height="21" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][6]%></td>
                        <td height="21" width="1%">:</td>
                        <td height="21" colspan="2"> 
                          <%=ControlCombo.draw(frmDailyRate.fieldNames[frmDailyRate.FRM_LOCAL_FOREIGN], "", null, ""+objDailyRate.getLocalForeign(), PstDailyRate.getLocalForeigVal(SESS_LANGUAGE), PstDailyRate.getLocalForeignKey(SESS_LANGUAGE))%>
                          * <%= frmDailyRate.getErrorMsg(FrmDailyRate.FRM_LOCAL_FOREIGN) %> 
                      
					  <tr> 
                        <td height="21" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][3]%></td>
                        <td height="21" width="1%">:</td>
                        <td height="21" colspan="2"> <%=	ControlDate.drawDateWithStyle(frmDailyRate.fieldNames[FrmDailyRate.FRM_START_DATE], objDailyRate.getStartDate()==null?new Date():objDailyRate.getStartDate(), 4,-5, "", "") %> 
                      <tr> 
                        <td height="21" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][4]%></td>
                        <td height="21" width="1%">:</td>
                        <td height="21" colspan="2"> <%=	ControlDate.drawDateWithStyle(frmDailyRate.fieldNames[FrmDailyRate.FRM_END_DATE], objDailyRate.getEndDate()==null?new Date():objDailyRate.getEndDate(), 4,-5, "", "") %> 
                      <tr>
                        <td colspan="5" class="command">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="5" class="command"> 
                          <%
							ctrLine.setLocationImg(approot+"/images");	
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidDailyRate+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidDailyRate+"')";
							String scancel = "javascript:cmdEdit('"+oidDailyRate+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);														
							ctrLine.setBackCaption(strBackMar);														
							ctrLine.setSaveCaption(strSaveMar);
							ctrLine.setDeleteCaption(strAskMar);
							ctrLine.setConfirmDelCaption(strDeleteMar);
		
							if (privDelete){
								ctrLine.setConfirmDelCommand(sconDelCom);
								ctrLine.setDeleteCommand(scomDel);
								ctrLine.setEditCommand(scancel);
							}else{ 
								ctrLine.setConfirmDelCaption("");
								ctrLine.setDeleteCaption("");
								ctrLine.setEditCaption("");
							}
		
							if(privAdd == false  && privUpdate == false){
								ctrLine.setSaveCaption("");
							}
		
							if (privAdd == false){
								ctrLine.setAddCaption("");
							}
							
							if(iCommand == Command.ASK)
							{
								ctrLine.setDeleteQuestion(delConfirm); 
							}
							
							out.println(ctrLine.draw(iCommand, iErrCode, msgString));
							%>
                        </td>
                      </tr>
                    </table>
                    <%}%>
                  </td>
                </tr>
              </table>
			  </td>
			  </tr>
			  </table>
            </form>
            <%
			if(iCommand==Command.ADD || iCommand==Command.EDIT)
			{
			%>
            <script language="javascript">
				document.<%=FrmDailyRate.FRM_DAILY_RATE%>.<%=FrmDailyRate.fieldNames[FrmDailyRate.FRM_CURRENCY_ID]%>.focus();
			</script>
            <%
			}
			%>
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
