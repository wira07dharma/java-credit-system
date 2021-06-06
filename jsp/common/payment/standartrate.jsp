<% 
/* 
 * Page Name  		:  standartrate.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */

/*******************************************************************
 * Page Description	: [project description ... ] 
 * Imput Parameters	: [input parameter ...] 
 * Output 			: [output ...] 
 *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package posbo -->
<%@ page import = "com.dimata.common.entity.payment.*" %>
<%@ page import = "com.dimata.common.form.payment.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<% //int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
  int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_STANDART_RATE);%>
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
	{"Kurs Standar","Harus diisi"},
	{"Bookkeeping Rate","required"}
};

public static final String textListHeader[][] =
{
	{"Jenis Mata Uang","Harga Jual","Tanggal Mulai","Tanggal Akhir","Status"/*,"Dipakai mapping"*/},
	{"Currency Type","Selling Rate","Start Date","End Date","Status"/*,"Include in mapping"*/}
};

public String drawList(Vector objectClass, long standartRateId, int languange, String sUserDecimalSeparator, String sUserDigitSeparator)

{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("75%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader(textListHeader[languange][0],"20%");
	ctrlist.addHeader(textListHeader[languange][1],"20%");
	ctrlist.addHeader(textListHeader[languange][2],"20%");
	ctrlist.addHeader(textListHeader[languange][3],"20%");
	ctrlist.addHeader(textListHeader[languange][4],"20%");
	
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
		StandartRate standartRate = (StandartRate)objectClass.get(i);
		Vector rowx = new Vector();
		
		if(standartRateId == standartRate.getOID())
		{
			index = i;
		}

		String strSellingRate = frmHandler.userFormatStringDecimal(standartRate.getSellingRate());		
		
		CurrencyType crType = new CurrencyType();
		String codeCurrency = "";
		try
		{
			crType = PstCurrencyType.fetchExc(standartRate.getCurrencyTypeId());
			codeCurrency = crType.getCode();
		}
		catch(Exception e)
		{
			System.out.println("Exc : " + e.toString());
		}
		
		String str_dt_StartDate = ""; 
		try
		{
			Date dt_StartDate = standartRate.getStartDate();
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
			Date dt_EndDate = standartRate.getEndDate();
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
		
		if(standartRate.getStatus()==PstStandartRate.ACTIVE)
		{			
			rowx.add("<a href=\"javascript:cmdEdit('"+standartRate.getOID()+"')\">"+codeCurrency+"</a>");
		}
		else
		{
			rowx.add(codeCurrency);
		}
		
		rowx.add("<div align=\"right\">"+strSellingRate+"</div>");		
		rowx.add("<div align=\"center\">"+str_dt_StartDate+"</div>");		
		rowx.add("<div align=\"center\">"+str_dt_EndDate+"</div>");
		rowx.add(PstStandartRate.statusName[languange][standartRate.getStatus()]);
		
		lstData.add(rowx);
	}

	return ctrlist.draw();
}
%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidStandartRate = FRMQueryString.requestLong(request, "hidden_standart_rate_id");

boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "STA."+PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS]+" DESC" +
					 ", CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX] +
					 ", STA."+PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE]+ " DESC" + 
					 ", STA."+PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE]+" DESC";  
					 
					 
/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = textListTitle[SESS_LANGUAGE][0];
String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
					 

CtrlStandartRate ctrlStandartRate = new CtrlStandartRate(request);
Vector listStandartRate = new Vector(1,1);

iErrCode = ctrlStandartRate.action(iCommand , oidStandartRate);
FrmStandartRate frmStandartRate = ctrlStandartRate.getForm();

int vectSize = PstStandartRate.getCount(whereClause);
StandartRate standartRate = ctrlStandartRate.getStandartRate();
msgString =  ctrlStandartRate.getMessage();

FRMHandler frmHandler = new FRMHandler();
frmHandler.setDecimalSeparator(","); 
frmHandler.setDigitSeparator("."); 

if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstStandartRate.findLimitStart(standartRate.getOID(),recordToGet, whereClause);
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlStandartRate.actionList(iCommand, start, vectSize, recordToGet);
} 

listStandartRate = PstStandartRate.listStandartRate(start,recordToGet, whereClause , orderClause);

if (listStandartRate.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listStandartRate = PstStandartRate.listStandartRate(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function cmdAdd(){
	document.frmstandartrate.hidden_standart_rate_id.value="0";
	document.frmstandartrate.command.value="<%=Command.ADD%>";
	document.frmstandartrate.prev_command.value="<%=prevCommand%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
}

function cmdAsk(oidStandartRate){
	document.frmstandartrate.hidden_standart_rate_id.value=oidStandartRate;
	document.frmstandartrate.command.value="<%=Command.ASK%>";
	document.frmstandartrate.prev_command.value="<%=prevCommand%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
}

function cmdConfirmDelete(oidStandartRate){
	document.frmstandartrate.hidden_standart_rate_id.value=oidStandartRate;
	document.frmstandartrate.command.value="<%=Command.DELETE%>";
	document.frmstandartrate.prev_command.value="<%=prevCommand%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
}
function cmdSave(){
	document.frmstandartrate.command.value="<%=Command.SAVE%>";
	document.frmstandartrate.prev_command.value="<%=prevCommand%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
	}

function cmdEdit(oidStandartRate){
	document.frmstandartrate.hidden_standart_rate_id.value=oidStandartRate;
	document.frmstandartrate.command.value="<%=Command.EDIT%>";
	document.frmstandartrate.prev_command.value="<%=prevCommand%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
	}

function cmdCancel(oidStandartRate){
	document.frmstandartrate.hidden_standart_rate_id.value=oidStandartRate;
	document.frmstandartrate.command.value="<%=Command.EDIT%>";
	document.frmstandartrate.prev_command.value="<%=prevCommand%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
}

function cmdBack(){
	document.frmstandartrate.command.value="<%=Command.BACK%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
	}

function cmdListFirst(){
	document.frmstandartrate.command.value="<%=Command.FIRST%>";
	document.frmstandartrate.prev_command.value="<%=Command.FIRST%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
}

function cmdListPrev(){
	document.frmstandartrate.command.value="<%=Command.PREV%>";
	document.frmstandartrate.prev_command.value="<%=Command.PREV%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
	}

function cmdListNext(){
	document.frmstandartrate.command.value="<%=Command.NEXT%>";
	document.frmstandartrate.prev_command.value="<%=Command.NEXT%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
}

function cmdListLast(){
	document.frmstandartrate.command.value="<%=Command.LAST%>";
	document.frmstandartrate.prev_command.value="<%=Command.LAST%>";
	document.frmstandartrate.action="standartrate.jsp";
	document.frmstandartrate.submit();
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
            <form name="frmstandartrate" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_standart_rate_id" value="<%=oidStandartRate%>">
              <input type="hidden" name="<%=FrmStandartRate.fieldNames[FrmStandartRate.FRM_FIELD_STATUS] %>" value="1">
			  <table width="100%">
			  <tr>
			  <td>
              <table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
                <tr> 
                  <td> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="search00">
                      <tr><td>&nbsp;</td></tr>
                      <tr > 
                        <td height="22" colspan="3" > <%= drawList(listStandartRate,oidStandartRate,SESS_LANGUAGE,sUserDecimalSymbol,sUserDigitGroup)%> </td>
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
                    <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmStandartRate.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
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
					 	  
						   String sel_currencytypeid = ""+standartRate.getCurrencyTypeId();
						   					   
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
                          <%= ControlCombo.draw(frmStandartRate.fieldNames[FrmStandartRate.FRM_FIELD_CURRENCY_TYPE_ID],null, sel_currencytypeid, currencytypeid_key, currencytypeid_value, "", null) %> 
                      <tr> 
                        <td height="21" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][1]%></td>
                        <td height="21" width="1%">:</td>
                        <td height="21" colspan="2"> 
                          <input type="text" name="<%=frmStandartRate.fieldNames[FrmStandartRate.FRM_FIELD_SELLING_RATE] %>"  value="<%=frmHandler.userFormatStringDecimal(standartRate.getSellingRate())%>" style="text-align:right">
                          * <%= frmStandartRate.getErrorMsg(FrmStandartRate.FRM_FIELD_SELLING_RATE) %> 
                      <tr> 
                        <td height="21" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][2]%></td>
                        <td height="21" width="1%">:</td>
                        <td height="21" colspan="2"> <%=	ControlDate.drawDateWithStyle(frmStandartRate.fieldNames[FrmStandartRate.FRM_FIELD_START_DATE], standartRate.getStartDate()==null?new Date():standartRate.getStartDate(), 4,-5, "", "") %> 
                      <tr> 
                        <td height="21" width="10%">&nbsp;<%=textListHeader[SESS_LANGUAGE][3]%></td>
                        <td height="21" width="1%">:</td>
                        <td height="21" colspan="2"> <%=	ControlDate.drawDateWithStyle(frmStandartRate.fieldNames[FrmStandartRate.FRM_FIELD_END_DATE], standartRate.getEndDate()==null?new Date():standartRate.getEndDate(), 4,-5, "", "") %> 
                      <tr>
                        <td colspan="5" class="command">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="5" class="command"> 
                          <%
							ctrLine.setLocationImg(approot+"/images");						  
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidStandartRate+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidStandartRate+"')";
							String scancel = "javascript:cmdEdit('"+oidStandartRate+"')";
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
				document.frmstandartrate.<%=FrmStandartRate.fieldNames[FrmStandartRate.FRM_FIELD_CURRENCY_TYPE_ID]%>.focus();
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
