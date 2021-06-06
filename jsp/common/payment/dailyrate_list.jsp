<% 
/* 
 * Page Name  		:  dailyrate_list.jsp
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
	{"Kurs Harian"},
	{"Daily Rate"}
};

public static final String textListHeader[][] =
{
	{"Jenis Mata Uang","Kurs Jual","Tanggal"},
	{"Currency Type","Selling Rate","Roster Date"}
};

public String drawList(Vector objectClass , int languange, String sUserDecimalSeparator, String sUserDigitSeparator){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("40%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader(textListHeader[languange][0],"30%");
	ctrlist.addHeader(textListHeader[languange][1],"30%");
	ctrlist.addHeader(textListHeader[languange][2],"40%");

	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.reset();

	FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSeparator); 
	frmHandler.setDigitSeparator(sUserDigitSeparator);

	for (int i = 0; i < objectClass.size(); i++) 
	{
		DailyRate dailyRate = (DailyRate)objectClass.get(i);
		Vector rowx = new Vector();
		
		CurrencyType crType = new CurrencyType();
		String codeCurrency = "";
		try
		{
			crType = PstCurrencyType.fetchExc(dailyRate.getCurrencyTypeId());
			codeCurrency = crType.getCode();
		}
		catch(Exception e)
		{
			System.out.println("Exc : " + e.toString());
		}

		String str_dt_RosterDate = ""; 
		try
		{
			Date dt_RosterDate = dailyRate.getRosterDate();				
			if(dt_RosterDate==null)
			{
				dt_RosterDate = new Date();
			}
			str_dt_RosterDate = Formater.formatDate(dt_RosterDate, "dd MMM yyyy hh:mm");
		}
		catch(Exception e)
		{ 
			str_dt_RosterDate = ""; 
		}

		String strSellingRate = frmHandler.userFormatStringDecimal(dailyRate.getSellingRate());
		rowx.add(codeCurrency);
		rowx.add("<div align=\"right\">"+strSellingRate+"</div>");
		rowx.add(str_dt_RosterDate);
		
		lstData.add(rowx);
	}
	return ctrlist.draw();
}
%>
<%
ControlLine ctrLine = new ControlLine();
CtrlDailyRate ctrlDailyRate = new CtrlDailyRate(request);
long oidDailyRate = FRMQueryString.requestLong(request, "hidden_daily_rate_id");

int iErrCode = FRMMessage.ERR_NONE;
String msgStr = "";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int recordToGet = 20;
int vectSize = 0;
String whereClause = "";
boolean privManageData = true; 
vectSize = PstDailyRate.getCount(whereClause);

if((iCommand!=Command.FIRST)&&(iCommand!=Command.NEXT)&&(iCommand!=Command.PREV)&&(iCommand!=Command.LIST))
{
	start = PstDailyRate.findLimitStart(  oidDailyRate,recordToGet, whereClause);
}

ctrlDailyRate.action(iCommand , oidDailyRate);

if((iCommand==Command.FIRST)||(iCommand==Command.NEXT)||(iCommand==Command.PREV)||(iCommand==Command.LAST)||(iCommand==Command.LIST))
{
	start = ctrlDailyRate.actionList(iCommand, start, vectSize, recordToGet);
}

String orderBy = "DY."+PstDailyRate.fieldNames[PstDailyRate.FLD_ROSTER_DATE]+" DESC" + 
				 ", CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];
Vector records = PstDailyRate.listDailyRate(start, recordToGet, "", orderBy);   
%>
<!-- End of Jsp Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">

	function cmdAdd(){
		document.frm_dailyrate.command.value="<%=Command.ADD%>";
		document.frm_dailyrate.action="dailyrate_edit.jsp";
		document.frm_dailyrate.submit();
	}

	function cmdEdit(oid){
		document.frm_dailyrate.command.value="<%=Command.EDIT%>";
		document.frm_dailyrate.hidden_daily_rate_id.value=oid;
		document.frm_dailyrate.action="dailyrate_edit.jsp";
		document.frm_dailyrate.submit();
	}

	function cmdListFirst(){
		document.frm_dailyrate.command.value="<%=Command.FIRST%>";
		document.frm_dailyrate.action="dailyrate_list.jsp";
		document.frm_dailyrate.submit();
	}

	function cmdListPrev(){
		document.frm_dailyrate.command.value="<%=Command.PREV%>";
		document.frm_dailyrate.action="dailyrate_list.jsp";
		document.frm_dailyrate.submit();
	}

	function cmdListNext(){
		document.frm_dailyrate.command.value="<%=Command.NEXT%>";
		document.frm_dailyrate.action="dailyrate_list.jsp";
		document.frm_dailyrate.submit();
	}

	function cmdListLast(){
		document.frm_dailyrate.command.value="<%=Command.LAST%>";
		document.frm_dailyrate.action="dailyrate_list.jsp";
		document.frm_dailyrate.submit();
	}

	function cmdBack(){
		document.frm_dailyrate.command.value="<%=Command.BACK%>";
		document.frm_dailyrate.action="srcdailyrate.jsp";
		document.frm_dailyrate.submit();
	}

</script>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> <!-- #EndEditable --> 
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
            Master Data > <%=textListTitle[SESS_LANGUAGE][0]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frm_dailyrate" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="hidden_daily_rate_id" value="<%=oidDailyRate%>">
              <table border="0" width="100%">
                <tr> 
                  <td height="8"> 
                    <hr size="1" noshade>
                  </td>
                </tr>
              </table>
              <%if((records!=null)&&(records.size()>0)){%>
              <%=drawList(records,SESS_LANGUAGE,sUserDecimalSymbol,sUserDigitGroup)%> 
              <%}
					else{
					%>
              <span class="comment"><br>
              &nbsp;Data tidak ada.</span> 
              <%}%>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td> 
                    <table width="100%" cellspacing="0" cellpadding="3">
                      <tr> 
                        <td> 
                          <% 
						    ctrLine.setLocationImg(approot+"/images");
							ctrLine.initDefault();
						  %>
                          <%=ctrLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%></td>						  
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="46%" nowrap align="left" class="command"> 
                    <table width="20%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <%if(privAdd && privManageData){%>
                        <td width="100%" nowrap class="command"><a href="javascript:cmdAdd()"><%=ctrLine.getCommand(SESS_LANGUAGE,textListTitle[SESS_LANGUAGE][0],ctrLine.CMD_ADD,true)%></a></td>
                        <%}%>
                      </tr>
                    </table>
                  </td>
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
