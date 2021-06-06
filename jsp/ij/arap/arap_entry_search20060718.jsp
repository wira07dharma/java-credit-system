<%@ page language="java" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.entity.search.SrcArApEntry,
                 com.dimata.aiso.form.search.FrmSrcArApEntry,
                 com.dimata.aiso.session.arap.SessArApEntry,
                 com.dimata.aiso.entity.arap.PstArApMain" %>
<%@ page import="java.util.Date" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>

<!-- import aiso -->
<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

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
		"No. Voucher",
		"Nama Kontak",
		"Tanggal",
        "Semua Tanggal",
		"Dari",
		"s / d",
        "No. Nota",
        "Tipe"
	},
	{
		"Voucher Number",
		"Cantact Name",
        "Date",
        "All Date",
        "From",
        "To",
        "Nota No.",
        "Type"
	}
};

public static final String masterTitle[] =
{
	"Entry Hutang/Piutang","AR/AP Entry"
};

public static final String searchTitle[] =
{
	"Pencarian Hutang/Piutang","Search AR/AP"
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
SrcArApEntry srcArApEntry = new SrcArApEntry();
if(session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY)!=null)
{
	srcArApEntry = (SrcArApEntry)session.getValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);
}

// ControlLine and Commands caption
ControlLine ctrLine = new ControlLine();
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "AR/AP" : "Hutang/Piutang";
String strAddAr = ctrLine.getCommand(SESS_LANGUAGE,PstArApMain.stTypeArAp[SESS_LANGUAGE][PstArApMain.TYPE_AR],ctrLine.CMD_ADD,true);
String strAddAp = ctrLine.getCommand(SESS_LANGUAGE,PstArApMain.stTypeArAp[SESS_LANGUAGE][PstArApMain.TYPE_AP],ctrLine.CMD_ADD,true);
String strSearchAr = ctrLine.getCommand(SESS_LANGUAGE,PstArApMain.stTypeArAp[SESS_LANGUAGE][PstArApMain.TYPE_AR],ctrLine.CMD_SEARCH,true);
String strSearchAp = ctrLine.getCommand(SESS_LANGUAGE,PstArApMain.stTypeArAp[SESS_LANGUAGE][PstArApMain.TYPE_AP],ctrLine.CMD_SEARCH,true);
try
{
	session.removeValue(SessArApEntry.SESS_SEARCH_ARAP_ENTRY);
}
catch(Exception e)
{
	System.out.println("--- Remove session error ---");
}

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
	<%if(privAdd){%>
	function cmdAddAr(){
        document.frmsearch.arap_type.value="<%=PstArApMain.TYPE_AR%>";
		document.frmsearch.command.value="<%=Command.ADD%>";
		document.frmsearch.action="arap_entry_edit.jsp";
		document.frmsearch.submit();
	}
    function cmdAddAp(){
        document.frmsearch.arap_type.value="<%=PstArApMain.TYPE_AP%>";
		document.frmsearch.command.value="<%=Command.ADD%>";
		document.frmsearch.action="arap_entry_edit.jsp";
		document.frmsearch.submit();
	}
	<%}%>

	function cmdSearch(){
		document.frmsearch.command.value="<%=Command.LIST%>";
		document.frmsearch.action="arap_entry_list.jsp";
		document.frmsearch.submit();
	}

    function changeType(){
        var type = Math.abs(document.frmsearch.<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_ARAP_TYPE]%>.value);
        switch(type){
        case <%=PstArApMain.TYPE_AR%>:
            document.all.searchar.style.display="";
            document.all.searchap.style.display="none";
            document.all.ar.style.display="";
            document.all.ap.style.display="none";
            break;
        case <%=PstArApMain.TYPE_AP%>:
            document.all.searchar.style.display="none";
            document.all.searchap.style.display="";
            document.all.ar.style.display="none";
            document.all.ap.style.display="";
            break;
        default :
            document.all.searchar.style.display="";
            document.all.searchap.style.display="none";
            document.all.ar.style.display="";
            document.all.ap.style.display="none";
            break;
        }
    }
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr>
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE">
      <%@ include file = "../main/header.jsp" %>
    </td>
  </tr>
  <tr>
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer">
      <%@ include file = "../main/menumain.jsp" %>
    </td>
  </tr>
  <tr>
    <td width="88%" valign="top" align="left">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> &gt; <%=searchTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td><!-- #BeginEditable "content" -->
            <form name="frmsearch" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="add_type" value="">
              <input type="hidden" name="arap_type" value="<%=srcArApEntry.getArApType()%>">
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr>
                  <td colspan="3">
                    <hr>
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                  <%
                    Vector typeValue = new Vector();
                    Vector typeKey = new Vector();
                    String sel_type = srcArApEntry.getArApType()+"";
                    int size = PstArApMain.stTypeArAp[0].length;
                    for(int i=0; i<size; i++){
                        typeValue.add(PstArApMain.stTypeArAp[SESS_LANGUAGE][i]);
                        typeKey.add(""+i);
                    }
                  %>
                  <%=ControlCombo.draw(FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_ARAP_TYPE],null,sel_type,typeKey,typeValue,"onChange=\"javascript:changeType()\"","")%>
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_VOUCHER_NO]%>" size="20" value="<%=srcArApEntry.getVoucherNo()%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_NOTA_NO]%>" size="20" value="<%=srcArApEntry.getNotaNo()%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_CONTACT_NAME]%>" size="50" value="<%=srcArApEntry.getContactName()%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%"><input name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_TYPE]%>" type="radio" value="0" <%=(srcArApEntry.getType()==0?"checked":"")%>>
                    <%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%>
                  </td>
                </tr>
                <tr>
                  <td height="80%">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input name="<%=FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_TYPE]%>" type="radio" value="1" <%=(srcArApEntry.getType()==1?"checked":"")%>>
                    <%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%>
                    <%
                        Date dtTransactionDate = srcArApEntry.getFromDate();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_FROM_DATE], dtTransactionDate, 3, -5));
                    %>
                    <%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%>
                    <%
                        dtTransactionDate = srcArApEntry.getUntilDate();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcArApEntry.fieldNames[FrmSrcArApEntry.FRM_SEARCH_UNTIL_DATE], dtTransactionDate, 3, -5));
                    %>

                    </td>
                </tr>
                <tr>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%">&nbsp;</td>
                </tr>
                <tr id=searchar>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%"><input type="submit" name="Search" value="<%=strSearchAr%>" onClick="javascript:cmdSearch()"></td>
                </tr>
                <tr id=searchap>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%"><input type="submit" name="Search" value="<%=strSearchAp%>" onClick="javascript:cmdSearch()"></td>
                </tr>
                <%if((privAdd)){%>
                <tr id=ar>
                  <td width="16%" height="16">&nbsp;</td>
                  <td width="1%" height="16" class="command">&nbsp;</td>
                  <td width="83%" height="16" class="command"><a href="javascript:cmdAddAr()"><%=strAddAr%></a></td>
                </tr>
                <tr id=ap>
                  <td width="16%" height="16">&nbsp;</td>
                  <td width="1%" height="16" class="command">&nbsp;</td>
                  <td width="83%" height="16" class="command"><a href="javascript:cmdAddAp()"><%=strAddAp%></a></td>
                </tr>
                <%}%>
              </table>
            </form>
<script language="JavaScript">
    changeType();
</script>
            <!-- #EndEditable --></td>
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
<%}%>