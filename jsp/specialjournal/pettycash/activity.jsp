<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.specialJournal.SessSpecialJurnal"%>

<!--package java-->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.util.lang.*" %>

<!--package qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- use harisma class -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.form.specialJournal.FrmSpecialJournalDetail"%>
<%@ page import="com.dimata.aiso.form.specialJournal.FrmSpecialJournalDetailAssignt"%>
<%@ page import="com.dimata.aiso.form.search.*"%>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_ACCOUNT_CART, AppObjInfo.OBJ_MASTERDATA_ACCOUNT_CART); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if (!privAdd && !privUpdate && !privDelete) 
{
%>

<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>

<!-- if of "has access" condition -->
<%
}
else 
{
%>

<!-- JSP Block -->
<%! 
// this constant used to list text of listHeader 
public static final String textJspTitle[][] = 
{
	{
		"No.",//0		
		"Kode",//1
		"Saldo Anggaran",//2		
		"Keterangan",//3
		"Perkiraan",//4
		"Level",//5
		"Induk",//6
		"Status",//7
		"Tipe",//8
		"Outputs and deliverables",//9
		"Performance indicator",//10
		"Assumptions and risks",//11
		"Cost implication"//12
	},
	{
		"No.",//0		
		"Code",//1
		"Budget Balance",//2	
		"Description",//3
		"Account Name",//4
		"Level",//5
		"Parent",//6
		"Postable",//7
		"Type",//8
		"Outputs and deliverables",//9
		"Performance indicator",//10
		"Assumptions and risks",//11
		"Cost implication"//12
	}	
};

public static final String[][] strSearchParameter={
	{"Kode","Keterangan"},
	{"Code","Description"}
};

public static final String[][] strCommand = {
	{"Tampilkan","Kosongkan"},
	{"Search","Reset"}
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

public static final String pageTitle[] = 
{
	"Aktivitas","Activity"	
};


public String drawList(Vector objectClass, long oid, int language, int start)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(getJspTitle(textJspTitle,0,language,"",false),"5%","center","center");
	ctrlist.dataFormat(getJspTitle(textJspTitle,1,language,"",false),"10%","center","center");
	ctrlist.dataFormat(getJspTitle(textJspTitle,2,language,"",false),"20%","center","right");
	ctrlist.dataFormat(getJspTitle(textJspTitle,3,language,"",false),"30%","center","left");
	ctrlist.dataFormat(getJspTitle(textJspTitle,4,language,"",false),"30%","center","left");	
	ctrlist.dataFormat(getJspTitle(textJspTitle,5,language,"",false),"5%","center","center");

	ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");
	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
    String psn = ""; 
	int lvl = 0;
	String strLvl = "";
	String link = "";
	String closeLink ="";
	String strActivity = "";
	String strStatus = "";
	String strType = "";
	String strParentName = "";
	String strLevel = "";
	String accName = "";
	String strAccName = "";
	String strDescription = "";
	int iStatus = 0;
	int iType = 0;
	int index = -1;
    String where = "";
	Vector vListBudget = new Vector();
	double dSaldoBudget = 0.0;
	int idx = 0;
    try{
		for (int i = 0; i < objectClass.size(); i++){
			 
			 Vector vTemp = (Vector) objectClass.get(i);
			
			 Activity objActivity = (Activity) vTemp.get(0);
			 dSaldoBudget = Double.parseDouble(vTemp.get(1).toString());
			 Perkiraan objPerkiraan = (Perkiraan) vTemp.get(2);
			
			//long idActivity = Long.parseLong(vTemp.get(0).toString());
			 //vListBudget = SessSpecialJurnal.getTotalSaldoActivity(objActivity.getOID());
			 /*if(vListBudget != null && vListBudget.size() > 0){
				String strSaldoBudget = (String)vListBudget.get(1);
				 System.out.println("strSaldoBudget index ke : "+i+" = "+strSaldoBudget);	
				if(strSaldoBudget != null && strSaldoBudget.length() > 0){ 
					
				}
			}*/
			String strBudget = "";
			if(dSaldoBudget > 0)	
			 strBudget = FRMHandler.userFormatStringDecimal(dSaldoBudget);
			 
			 strStatus = PstActivity.actPosted[objActivity.getPosted()];
			 strType = PstActivity.actAssign[objActivity.getType()];
			 strLevel = PstActivity.actLevel[objActivity.getActLevel()];
			
			if(language == I_Language.LANGUAGE_FOREIGN)
					accName = objPerkiraan.getAccountNameEnglish();
				else
					accName = objPerkiraan.getNama();
					
			if(objActivity.getDescription().length() > 40)		
					strDescription = (objActivity.getDescription()).substring(0,40)+".....";
				else
					strDescription = objActivity.getDescription();
				
			if(accName.length() > 40)
					strAccName = accName.substring(0,40)+".....";
				else
					strAccName = accName;
					
            Vector rowx = new Vector();
			 link ="<a href=\"javascript:cmdChoose('"+String.valueOf(objActivity.getOID())+"','"+objActivity.getDescription()+"','"+String.valueOf(objPerkiraan.getOID())+"','"+strBudget+"')\">";
			 closeLink = "</a>";			
			  
			 
				 rowx.add(""+(i+start+1));			 
				 rowx.add(link+objActivity.getCode()+closeLink); 
				 rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(dSaldoBudget)+"</div>"); 		 
				 rowx.add(strDescription); 
				 rowx.add(strAccName);			 
				 rowx.add(strLevel); 
				
			 lstData.add(rowx);
		}
	} 
	catch(Exception exc) 
	{
		System.out.println("Exc when drawList : " + exc.toString());
	}
	return ctrlist.drawMe(index); 
}
%>

<%
// get request from hidden text
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
String code = FRMQueryString.requestString(request, FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_CODE]);
String description = FRMQueryString.requestString(request, FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_DESCRIPTION]);
int recordToGet = 17;

// Setup controlLine and Commands caption
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = pageTitle[SESS_LANGUAGE];
String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
String strBackAct = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " Search" : " Pencarian");
String searchData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View Search Form" : "Cari Data";
String hideSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Hide Search Form" : "Sembunyikan Form Cari Data";

// Manage controlList and Action process
Control controlList = new Control();
CtrlActivity ctrlActivity = new CtrlActivity(request); 
Activity objActivity = ctrlActivity.getActivity();

SrcActivity srcActivity = new SrcActivity();
FrmSrcActivity frmSrcActivity = new FrmSrcActivity(request);
frmSrcActivity.requestEntityObject(srcActivity);

// get list of department object
String strWhere = "";
 if(code != null && code.length() > 0){
 	strWhere += " ATY.CODE LIKE '%"+code+"%'";
 }

 if(description != null && description.length() > 0){
 	if(strWhere != null && strWhere.length() > 0){
		strWhere += " AND ATY.DESCRIPTION ILIKE '%"+description+"%'";
	}else{
		strWhere += " ATY.DESCRIPTION ILIKE '%"+description+"%'";
	}
 }
String strOrder = PstActivity.fieldNames[PstActivity.FLD_CODE];

// Proses list account chart ...
Vector vectActivity = new Vector(); 
vectActivity = SessSpecialJurnal.getTotalSaldoActivity(strWhere, start, recordToGet);
//vectActivity = SessActivity.listActivity(strWhere, start, recordToGet);

int vectSize = vectActivity.size();

if((iCommand == Command.FIRST || iCommand == Command.PREV )||  (iCommand == Command.NEXT || iCommand == Command.LAST)){
    start = ctrlActivity.actionList(iCommand, start, vectSize, recordToGet);
}

if (vectActivity.size() < 1 && start > 0){
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 vectActivity = SessSpecialJurnal.getTotalSaldoActivity(strWhere, start, recordToGet);
	 //vectActivity = SessActivity.listActivity(srcActivity, start, recordToGet);
}


%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">

function cmdSearch(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.LIST%>";	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}	

function cmdClear(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_CODE]%>.value="";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_DESCRIPTION]%>.value="";	
}

function cmdChoose(activityOid, description, oidPerkiraan, saldoBudget){    
    self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetailAssignt.fieldNames[FrmSpecialJournalDetailAssignt.FRM_ACTIVITY_ID]%>.value = activityOid;
    self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_ID_PERKIRAAN]%>.value = oidPerkiraan;
    self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.act_desc.value = description;
	self.opener.document.forms.<%=FrmSpecialJournalDetail.FRM_SPECIAL_JOURNAL_DETAIL%>.<%=FrmSpecialJournalDetail.fieldNames[FrmSpecialJournalDetail.FRM_BUDGET_BALANCE]%>.value = saldoBudget;	
    self.close();
}

function cmdListFirst(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function cmdBackList(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.NONE%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function cmdListPrev(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.PREV%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
	}

function cmdListNext(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function cmdListLast(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.LAST%>";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function cmdViewSearch(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.REFRESH%>";	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

function cmdHide(){
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.command.value="<%=Command.NONE%>";	
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.action="activity.jsp";
	document.<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>.submit();
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/tab.css" type="text/css">
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
		  List : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font>
		  <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
		    <script language="JavaScript">
		  		window.focus();
		  </SCRIPT> 
            <form name="<%=FrmSrcActivity.FRM_SRC_ACTIVITY%>" method="post" action="">              		  
              <input type="hidden" name="command" value="<%=iCommand%>">			 
              <input type="hidden" name="start" value="<%=start%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2">&nbsp; 
                  
                  </td>
                </tr>
              </table>			  
              <table width="100%" cellpadding="0" cellspacing="0" class="listgenactivity">
                <%if(iCommand == Command.REFRESH){%>
                <tr>
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" valign="top">
				  <table width="100%" cellpadding="1" cellspacing="1" class="listgenvalue">
                    <tr>
                      <td nowrap id="up">&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td width="17%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][0]%></td>
                      <td width="1%">:</td>
                      <td width="82%"><input type="text" name="<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_CODE]%>" value="<%=srcActivity.getCode()%>" size="20" >
                      </td>
                    </tr>
                    <tr>
                      <td width="17%" nowrap>&nbsp;&nbsp;&nbsp;<%=strSearchParameter[SESS_LANGUAGE][1]%></td>
                      <td width="1%">:</td>
                      <td width="82%">
                        <input type="text" name="<%=FrmSrcActivity.fieldNames[FrmSrcActivity.FRM_DESCRIPTION]%>" value="<%=srcActivity.getDescription()%>" size="50" >
                      </td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td width="17%">&nbsp;</td>
                      <td width="1%">&nbsp;</td>
                      <td width="82%">
                        <input type="button" name="btnSubmit" value="<%=strCommand[SESS_LANGUAGE][0]%>" onClick="javascript:cmdSearch()">
                        <input type="button" name="btnReset" value="<%=strCommand[SESS_LANGUAGE][1]%>" onClick="javascript:cmdClear()">
                      </td>
                    </tr>
                    <tr>
                      <td height="17">&nbsp;</td>
                    </tr>
                  </table></td>
                </tr>
				<%}%>
                <tr>
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" valign="top">&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="2" bgcolor="#F0F5FA" align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
				  	<%if(iCommand == Command.NONE || iCommand == Command.LIST){%>
				  		<a href="javascript:cmdViewSearch()"><%=searchData%></a>
				  	<%}else{%>				  
				  		<a href="javascript:cmdHide()"><%=hideSearch%></a>
				  	<%}%>
				  </font></td>
                </tr>
                <tr>
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" valign="top" id="down"><span class="command">
                    <% 
						   int cmd = 0;
							   if ((iCommand == Command.FIRST || iCommand == Command.PREV )|| 
								(iCommand == Command.NEXT || iCommand == Command.LAST))
									cmd =iCommand; 
						   else{
							  if(iCommand == Command.NONE || prevCommand == Command.NONE)
								cmd = Command.FIRST;
							  else 
								cmd =prevCommand; 
						   } 
						 %>
                  </span>
                    <%				

                 	if((vectActivity!=null)&&(vectActivity.size()>0))
					{  
						out.println(drawList(vectActivity,objActivity.getOID(),SESS_LANGUAGE,start)); 
					}
					else
					{
						out.println("<font size=\"2\" color=\"#FF0000\"><em>&nbsp;No Activity Available ...<em></font>");
					}
			  		%></td>
                </tr>
                <tr>
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" valign="top" id="down"><table width="100%">
                    <tr>
                      <td colspan="2"> <span class="command"> <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> </span> </td>
                    </tr>
                  </table></td>
                </tr>
                <tr>
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" valign="top" id="down">&nbsp;</td>
                </tr>
                <tr>
				 <%if(commandBack.equalsIgnoreCase("Y")){%>
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" valign="top" id="down">&nbsp;&nbsp;<b><a href="javascript:cmdBackList()"><%=strBackAct%></a></b></td>
                <%}%>
				</tr>
                <tr> 
                  <td colspan="2" bordercolor="#000066" bgcolor="#F0F5FA" valign="top" id="down"><span class="command"> 
                    </span>
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