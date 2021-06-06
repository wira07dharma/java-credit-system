 
<% 
/* 
 * Page Name  		:  srcemployee.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		: lkarunia 
 * @version  		: 01 
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

<!-- package wihita -->
<%@ page import = "com.dimata.util.*" %> 
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package common -->
<%@ page import = "com.dimata.common.entity.search.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.session.contact.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>
<%@ page import = "org.jfree.chart.*,java.awt.*,org.jfree.ui.*,org.jfree.data.general.*, java.util.*,org.jfree.chart.servlet.*,org.jfree.chart.entity.*,java.io.*"%>

<!--package aiso -->
<%@ page import = "com.dimata.aiso.form.specialJournal.FrmSpecialJournalMain"%>
<%@ page import="com.dimata.aiso.form.specialJournal.FrmSpecialJournalDetail"%>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1; //AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
%>

<!-- Jsp Block -->
<%!
public static String strTitles[][] = {
	{"No","Kode","Nama"},
	{"No","Code","Name"}
};

private static String strErrorMassage[] = {
	"Data Lokasi Tidak Ditemukan","System can't found data"
};

public static String strTitle[][] = {
	{"Kode","Nama"},	
	{"Code","Name"}
};
public static String[][] chartLabel ={
	{"Salary","Electricity","Depreciation","Development","Research"},
	{""+2.5,""+0.5,""+15.0,""+1.5,""+25.5,""+8.5}
    };
public static final String masterTitle[] = {
	"Pencarian","Search"	
};

public static final String compTitle[] = {
	"Lokasi Inventaris","Fixed Assets Location"
};

public String getJspTitle(String textJsp[][], int index, int language, String prefiks, boolean addBody){
	String result = "";
	if(addBody){
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){	
			result = textJsp[language][index] + " " + prefiks;
		}else{
			result = prefiks + " " + textJsp[language][index];		
		}
	}else{
		result = textJsp[language][index];
	} 
	return result;
}

public boolean getTruedFalse(Vector vect, long index){
	for(int i=0;i<vect.size();i++){
		long iStatus = Long.parseLong((String)vect.get(i));
		if(iStatus==index)
			return true;
	}
	return false;
}

private String caracterReplace(String strToReplace){
	String strReplace = "";
		try{
			strReplace = strToReplace.replace('\"','`');
			strReplace = strToReplace.replace('\'','`');
		}catch(Exception e){
			strReplace = "";
			System.out.println("Exception on caracterReplace() :::: "+e.toString());
			e.printStackTrace();
		}
	return strReplace;
}

public String selectOne(Vector objectClass, int language)
{
	String result = "";
		if(objectClass!=null && objectClass.size()>0){
	
			for(int i=0; i<objectClass.size(); i++){
				AktivaLocation objAktivaLocation = (AktivaLocation)objectClass.get(i);
				String locName = cekNull(objAktivaLocation.getAktivaLocName());
			        	
				result ="<script language=\"JavaScript\"> cmdEdit('"+(objAktivaLocation.getOID()+"','"+
							  locName+"');</script>");
			}
		}else{
			result = "<div class=\"msginfo\">"+strErrorMassage[language]+"</div>";
		}
	return result;
}

public String drawList(Vector objectClass, long oid, int start, int language){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitles[language][0],"2%","center","center");
	ctrlist.dataFormat(strTitles[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitles[language][2],"88%","center","left");

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	
	if(start<0)
		start =0;
		
	for (int i = 0; i < objectClass.size(); i++) {
		AktivaLocation objAktivaLocation = (AktivaLocation)objectClass.get(i);
		Vector rowx = new Vector();
		
	    if(oid==objAktivaLocation.getOID()){index =i;} 		
		
		start = start + 1;
		rowx.add(String.valueOf(start));
		rowx.add(cekNull(objAktivaLocation.getAktivaLocCode()));		
		String locName = cekNull(objAktivaLocation.getAktivaLocName());
        rowx.add(locName);
		
		lstData.add(rowx);
		lstLinkData.add(String.valueOf(objAktivaLocation.getOID())+"','"+locName);
	}
	return ctrlist.drawMe(index);
}

public String cekNull(String val){
	if(val==null || val.length()==0)
		val = "";
	return val;	
}

%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int type = FRMQueryString.requestInt(request,"contact_class");
long oidLocation = FRMQueryString.requestLong(request, "location_id");
int start = FRMQueryString.requestInt(request, "start");
int srcFrom = FRMQueryString.requestInt(request, "src_from");
String strCode = FRMQueryString.requestString(request, "code");
String strName = FRMQueryString.requestString(request, "name");

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = compTitle[SESS_LANGUAGE];
String strSearchComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);

ctrLine.setLanguage(SESS_LANGUAGE);
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strBackComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK_SEARCH,true);
String strNoCompany = SESS_LANGUAGE==langForeign ? "No "+currPageTitle+" Available" : "Tidak Ada "+currPageTitle; 
String strMergeComp = SESS_LANGUAGE==langForeign ? currPageTitle + " Merge" : "Penggabungan " + currPageTitle;
String strReset = SESS_LANGUAGE==langForeign ? "Reset" : "Kosongkan";
String searchData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View Search Form" : "Cari Data";
String hideSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Hide Search Form" : "Sembunyikan Form Cari Data";

int recordToGet = 20;
int vectSize = 0;
String whereClause = "";
int iErrCode = FRMMessage.ERR_NONE;

CtrlContactList ctrlContactList = new CtrlContactList(request);

if(strCode != null && strCode.length() > 0){
	whereClause = PstAktivaLocation.fieldNames[PstAktivaLocation.FLD_AKTIVA_LOC_CODE]+" ILIKE '%"+strCode+"%'";
}

if(strName != null && strName.length() > 0){
	if(whereClause != null && whereClause.length() > 0){
		whereClause += " AND "+PstAktivaLocation.fieldNames[PstAktivaLocation.FLD_AKTIVA_LOC_NAME]+" ILIKE '%"+strName+"%'";
	}else{
		whereClause = PstAktivaLocation.fieldNames[PstAktivaLocation.FLD_AKTIVA_LOC_NAME]+" ILIKE '%"+strName+"%'";
	}
}

/**
* get vectSize, start and data to be display in this page
*/
vectSize = PstAktivaLocation.getCount(whereClause);
if(iCommand!=Command.BACK){  
	start = ctrlContactList.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

Vector records = PstAktivaLocation.list(start, recordToGet,whereClause,"");
							  

%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
		document.frmlocationlist.command.value="<%=Command.ADD%>";
		document.frmlocationlist.action="aktiva_location.jsp";
		document.frmlocationlist.submit(); 
}

function cmdSearch(){
		document.frmlocationlist.command.value="<%=Command.LIST%>";
		document.frmlocationlist.action="location_list.jsp";
		document.frmlocationlist.submit();
}

function fnTrapKD(){
   if (event.keyCode == 13) { 
		document.all.aSearch.focus();
		cmdSearch();
   }
}

function cmdEdit(oid, name, address, town, country){   
    self.opener.document.forms.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_AKTIVA_LOC_ID]%>.value = oid;
    self.opener.document.forms.frmstandartrate.<%=FrmModulAktiva.fieldNames[FrmModulAktiva.FRM_AKTIVA_LOC_ID]%>_TEXT.value = name;		
    self.close();
}



function first(){
	document.frmlocationlist.command.value="<%=Command.FIRST%>";
	document.frmlocationlist.action="location_list.jsp";
	document.frmlocationlist.submit();
}

function prev(){
	document.frmlocationlist.command.value="<%=Command.PREV%>";
	document.frmlocationlist.action="location_list.jsp";
	document.frmlocationlist.submit();
}

function next(){
	document.frmlocationlist.command.value="<%=Command.NEXT%>";
	document.frmlocationlist.action="location_list.jsp";
	document.frmlocationlist.submit();
}

function last(){
	document.frmlocationlist.command.value="<%=Command.LAST%>";
	document.frmlocationlist.action="location_list.jsp";
	document.frmlocationlist.submit();
}

function cmdBack(){
	document.frmlocationlist.command.value="<%=Command.BACK%>";
	document.frmlocationlist.action="location_list.jsp";
	document.frmlocationlist.submit();
}


function cmdViewSearch(){
	document.frmlocationlist.command.value="<%=Command.NONE%>";	
	document.frmlocationlist.action="location_list.jsp";
	document.frmlocationlist.submit();
}

function cmdHideSearch(){
	document.frmlocationlist.command.value="<%=Command.LIST%>";	
	document.frmlocationlist.action="location_list.jsp";
	document.frmlocationlist.submit();
}

function cmdReset(){
	document.frmlocationlist.action="location_list.jsp";
	document.frmlocationlist.code.value = "";
	document.frmlocationlist.name.value = "";
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<SCRIPT language="javascript">
<!--
function hideObjectForMenuJournal(){ 
}
	
function hideObjectForMenuReport(){
}
	
function hideObjectForMenuPeriod(){
}
	
function hideObjectForMenuMasterData(){
}

function hideObjectForMenuSystem(){
}

function showObjectForMenu(){
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a && i < a.length && (x=a[i]) && x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i < a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0 && parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n]) && d.all) x=d.all[n]; for (i=0;!x && i < d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x && d.layers && i < d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
-->
</SCRIPT>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">  
<%
String fileName = null; //dont forget to add this
DefaultPieDataset pd = new DefaultPieDataset(); 
try
{
   
    for(int cnt=0;cnt < chartLabel[0].length;cnt++){
      pd.setValue(chartLabel[0][cnt],Double.parseDouble(chartLabel[1][cnt]));
   }
 
   JFreeChart chart=ChartFactory.createPieChart3D("Expenses Share",pd, false,false, false);
	request.getSession().setAttribute("contentType", "image/jpg");
	
	chart.setBorderVisible(false);
	chart.setTitle("Expenses Share");
	
    //  Write the chart image to the temporary directory
	ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
   System.out.println("view image.info ::::::::: "+info);
   
   fileName = ServletUtilities.saveChartAsJPEG(chart, 500, 300, info, session);
   PrintWriter pw = new PrintWriter(out);
   
  //  Write the image map to the PrintWriter
   ChartUtilities.writeImageMap(pw, fileName, info, true);
   pw.flush();
}
 
 
catch(Exception e)
{
    System.out.println("Exception on view image ::::::::: "+e.toString());
	e.printStackTrace();
}
String path = request.getContextPath() +"/servlet/DisplayChart?filename=" + fileName;
System.out.println("view image.path ::::::::: "+path);
%>
<img src="<%=path%>" border=0>
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --> 
            <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=compTitle[SESS_LANGUAGE]%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
		   <script language="JavaScript">
		  		window.focus();
		  </SCRIPT>
            <form name="frmlocationlist" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="contact_class" value="<%=type%>">
			  <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="src_from" value="<%=srcFrom%>">
			  <input type="hidden" name="cnt_type_cashier" value="504404337050268208">
              <input type="hidden" name="location_id" value="<%=oidLocation%>">

			  <%try{%>
              <table border="0" width="100%">
                <tr> 
                  <td width="2%" height="8">
                    
                  </td>
                  <td width="98%">
				  	<%if(iCommand != Command.LIST){%>
				  		<table border="0" cellspacing="2" cellpadding="2" width="100%">
                      <tr align="left" valign="top"> 
                        <td width="10%" nowrap> <div align="left"><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></div></td>
                        <td width="1%">:</td>
                        <td width="89%">&nbsp;
                          <input type="text" name="code"  value="<%=cekNull(strCode)%>" onKeyDown="javascript:fnTrapKD()" size="20"></td>
                      </tr>
                      <!-- <script language="javascript">
								document.frm_contactlist.<%//=frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_CODE]%>.focus();
							</script> -->
                      <tr align="left" valign="top"> 
                        <td width="10%" nowrap> <div align="left"><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></div></td>
                        <td width="1%">:</td>
                        <td width="89%">&nbsp; <input type="text" name="name"  value="<%=cekNull(strName)%>" size="40" onkeydown="javascript:fnTrapKD()"> 
                          <!-- <input type="text" name="name"  value="<%//=srcContactList.getName()%>" size="40" onkeydown="javascript:fnTrapKD()"> -->
                        </td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td width="10%">&nbsp;</td>
                        <td width="1%">&nbsp;</td>
                        <td width="89%">&nbsp;</td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td width="10%"> <div align="left"></div></td>
                        <td width="1%" class="command">&nbsp;</td>
                        <td width="89%" class="command">&nbsp;&nbsp; <input name="viewListContact" type="button" onClick="javascript:cmdSearch()" value="<%=strSearchComp%>"> 
                          <input name="btnReset" type="button" onClick="javascript:cmdReset()" value="<%=strReset%>"> 
                        </td>
                      </tr>
                    </table>
                        <%}%>
</td>
                </tr>
              </table>			  			  
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td colspan="2"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                      <tr> 
                        <td width="97%"> 
                          
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
			  <%}catch(Exception e){
			  	System.out.println("err : "+e.toString());
				}
			  %>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	            <%if((records!=null)&&(records.size()>0)){%>			  
                <tr>
                  <td>&nbsp;</td>
                  <td align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
				  <%if(iCommand == Command.LIST){%>
				  <a href="javascript:cmdViewSearch()"><%=searchData%></a>
				  <%}else{%>				  
				  <a href="javascript:cmdHideSearch()"><%=hideSearch%></a>
				  <%}%>
				  </font>
				  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>
				  <%if(records.size() == 1){%>
						<%out.println(selectOne(records,SESS_LANGUAGE));%>
					<%}else{%>				  	
				  		<%=drawList(records,oidLocation,start,SESS_LANGUAGE)%>
					<%}%>
				  <%//=drawList(SESS_LANGUAGE,records,oidContactList,start)%></td>
                </tr>			  
                <%}else{%>
                <tr> 
                  <td>&nbsp;</td>
                  <td><span class="comment"><%=strNoCompany%></span></td>
                </tr>			  				
				<%}%>				
                <tr> 
                  <td>&nbsp;
				  </td>
                  <td><%ctrLine.initDefault(SESS_LANGUAGE,"");%>
                  <%=ctrLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </td>
                </tr>				
                <tr>
                  <td colspan="2" align="left" nowrap class="command">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="2%" nowrap align="left" class="command">&nbsp;&nbsp;&nbsp;&nbsp;
				  </td>
                  <td width="98%" nowrap align="left" class="command"><%if(privAdd){%>
                    <a href="javascript:cmdAdd()" class="command"><%=strAddComp%> | </a>
                    <%}%>
					<%if(commandBack.equalsIgnoreCase("Y")){%>
                    <a href="javascript:cmdBack()" class="command"><%=strBackComp%></a>
					<%}%>
                </tr>								
              </table>
            </form>
			<script>
				<%if(iCommand == Command.LIST){%>
					//cmdHideSearch();
				<%}%>
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
