<% 
/* 
 * Page Name  		:  dailyrate_edit.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */

/*******************************************************************
 * Page Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
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

<!--package common -->
<%@ page import = "com.dimata.common.entity.payment.*" %>
<%@ page import = "com.dimata.common.form.payment.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<!-- Jsp Block -->
<%!
public static final String textListTitle[][] =
{
	{"Kurs Harian","Harus diisi"},
	{"Daily Rate","entry required"}
};

public static final String textListHeader[][] =
{
	{"Tipe Mata Uang","Kurs Jual","Tanggal"},
	{"Currency Type","Selling Rate","Roster Date"}
};
%>

<%
CtrlDailyRate ctrlDailyRate = new CtrlDailyRate(request);
long oidDailyRate = FRMQueryString.requestLong(request, "hidden_daily_rate_id");

String msgString = "";
int iErrCode = FRMMessage.ERR_NONE;
String errMsg = "";
String whereClause = "";
String orderClause = "";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request,"start");

//out.println("iCommand : "+iCommand);
ControlLine ctrLine = new ControlLine();

iErrCode = ctrlDailyRate.action(iCommand , oidDailyRate);

errMsg = ctrlDailyRate.getMessage();
FrmDailyRate frmDailyRate = ctrlDailyRate.getForm();
DailyRate dailyRate = ctrlDailyRate.getDailyRate();
oidDailyRate = dailyRate.getOID();
FRMHandler frmHandler = new FRMHandler();
frmHandler.setDecimalSeparator(sUserDecimalSymbol); 
frmHandler.setDigitSeparator(sUserDigitGroup);

if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmDailyRate.errorSize()<1))
{
%>

<jsp:forward page="dailyrate_list.jsp"> 
<jsp:param name="start" value="<%=start%>" />
<jsp:param name="hidden_daily_rate_id" value="<%=dailyRate.getOID()%>" />
</jsp:forward>

<%
}
%>
<!-- End of Jsp Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdCancel(){
	document.frm_dailyrate.command.value="<%=Command.ADD%>";
	document.frm_dailyrate.action="dailyrate_edit.jsp";
	document.frm_dailyrate.submit();
} 
function cmdCancel(){
	document.frm_dailyrate.command.value="<%=Command.CANCEL%>";
	document.frm_dailyrate.action="dailyrate_edit.jsp";
	document.frm_dailyrate.submit();
} 

function cmdEdit(oid){ 
	document.frm_dailyrate.command.value="<%=Command.EDIT%>";
	document.frm_dailyrate.action="dailyrate_edit.jsp";
	document.frm_dailyrate.submit(); 
} 

function cmdSave(){
	document.frm_dailyrate.command.value="<%=Command.SAVE%>"; 
	document.frm_dailyrate.action="dailyrate_edit.jsp";
	document.frm_dailyrate.submit();
}

function cmdAsk(oid){
	document.frm_dailyrate.command.value="<%=Command.ASK%>"; 
	document.frm_dailyrate.action="dailyrate_edit.jsp";
	document.frm_dailyrate.submit();
} 

function cmdConfirmDelete(oid){
	document.frm_dailyrate.command.value="<%=Command.DELETE%>";
	document.frm_dailyrate.action="dailyrate_edit.jsp"; 
	document.frm_dailyrate.submit();
}  

function cmdBack(){
	document.frm_dailyrate.command.value="<%=Command.FIRST%>"; 
	document.frm_dailyrate.action="dailyrate_list.jsp";
	document.frm_dailyrate.submit();
}
</script>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE"> 
      <%@ include file = "../../main/header.jsp" %>
    </td>
  </tr>
  <tr> 
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
      <%@ include file = "../../main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --> 
            Masterdata > <%=textListTitle[SESS_LANGUAGE][0]%> <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frm_dailyrate" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="hidden_daily_rate_id" value="<%=oidDailyRate%>">
              <table width="100%" cellspacing="1" cellpadding="1" border="0" >
                <tr> 
                  <td colspan="4"> 
                    <hr>
                  </td>
                </tr>
                <tr> 
                  <td width="11%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="88%"><i>*) <%=textListTitle[SESS_LANGUAGE][1]%></i></td>
                </tr>
                <tr align="left"> 
                  <td width="11%"  valign="top"  ><%=textListHeader[SESS_LANGUAGE][0]%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="88%"  valign="top"> 
                    <% 
					Vector obj_currencytypeid = new Vector(1,1); //vector of object to be listed 
					Vector val_currencytypeid = new Vector(1,1); //hidden values that will be deliver on request (oids) 
					Vector key_currencytypeid = new Vector(1,1); //texts that displayed on combo box
					String orderBy = PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];			   
					Vector listCurrencyType = PstCurrencyType.list(0,0,"",orderBy);
					if(listCurrencyType!=null&&listCurrencyType.size()>0){
						for(int i=0;i<listCurrencyType.size();i++){
							CurrencyType currencyType =(CurrencyType)listCurrencyType.get(i);
							val_currencytypeid.add(""+currencyType.getOID());
							key_currencytypeid.add(currencyType.getCode());
						}
					}
					String select_currencytypeid = ""+dailyRate.getCurrencyTypeId(); //selected on combo box
					%>
                    <%=ControlCombo.draw(FrmDailyRate.fieldNames[FrmDailyRate.FRM_FIELD_CURRENCY_TYPE_ID], null, select_currencytypeid, val_currencytypeid, key_currencytypeid, "", "")%> * <%=frmDailyRate.getErrorMsg(FrmDailyRate.FRM_FIELD_CURRENCY_TYPE_ID)%></td>
                </tr>
                <tr align="left"> 
                  <td width="11%"  valign="top"  ><%=textListHeader[SESS_LANGUAGE][1]%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="88%"  valign="top"> 
                    <input type="text" name="<%=FrmDailyRate.fieldNames[FrmDailyRate.FRM_FIELD_SELLING_RATE]%>" value="<%=frmHandler.userFormatStringDecimal(dailyRate.getSellingRate())%>" style="text-align:right">
                    * <%=frmDailyRate.getErrorMsg(FrmDailyRate.FRM_FIELD_SELLING_RATE)%></td>
                </tr>
                <tr align="left"> 
                  <td width="11%"  valign="top"  ><%=textListHeader[SESS_LANGUAGE][2]%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="88%"  valign="top"> <%=ControlDate.drawDateWithStyle(FrmDailyRate.fieldNames[FrmDailyRate.FRM_FIELD_ROSTER_DATE], (dailyRate.getRosterDate()==null) ? new Date() : dailyRate.getRosterDate(), 1, -5, "", "")%> <%=ControlDate.drawTime(FrmDailyRate.fieldNames[FrmDailyRate.FRM_FIELD_ROSTER_DATE], (dailyRate.getRosterDate()==null) ? new Date() : dailyRate.getRosterDate(),"")%> <%=frmDailyRate.getErrorMsg(FrmDailyRate.FRM_FIELD_ROSTER_DATE)%></td>
                </tr>
                <tr align="left"> 
                  <td width="11%"  valign="top"  >&nbsp;</td>
                  <td  width="1%"  valign="top">&nbsp;</td>
                  <td  width="88%"  valign="top">&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td colspan="3"> 
                    <%
							ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0]);
							ctrLine.setTableWidth("100%");
							ctrLine.setSaveImageAlt(ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_SAVE,true));
							ctrLine.setBackImageAlt(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT ? ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_BACK,true) : ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_BACK,true)+" List");
							ctrLine.setDeleteImageAlt(ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_ASK,true));
							ctrLine.setEditImageAlt(ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_CANCEL,false));
									
							String scomDel = "javascript:cmdAsk('"+oidDailyRate+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidDailyRate+"')";
							String scancel = "javascript:cmdEdit('"+oidDailyRate+"')";
							ctrLine.setBackCaption("Back to List");
								ctrLine.setDeleteCaption("Delete");
								ctrLine.setSaveCaption("Save");
								ctrLine.setAddCaption("");
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							
							// set command caption
							ctrLine.setAddCaption(ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_ADD,true));
							ctrLine.setSaveCaption(ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_SAVE,true));
							ctrLine.setBackCaption(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT ? ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_BACK,true) : ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_BACK,true)+" List");
							ctrLine.setDeleteCaption(ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_ASK,true));
							ctrLine.setConfirmDelCaption(ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_DELETE,true));
							ctrLine.setCancelCaption(ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_CANCEL,false));

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
							%>
                    <%= ctrLine.draw(iCommand, iErrCode, msgString)%> </td>
                </tr>
              </table>
            </form>
            <!-- #EndEditable --></td>
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
<!-- #EndTemplate -->
</html>
