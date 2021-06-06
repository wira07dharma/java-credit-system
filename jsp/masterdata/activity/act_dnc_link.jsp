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
<%@ page import = "java.util.*,
                   com.dimata.aiso.entity.masterdata.ActivityDonorComponentLink,
                   com.dimata.aiso.form.masterdata.FrmActivityDonorComponentLink,
                   com.dimata.aiso.form.masterdata.CtrlActivityDonorComponentLink,
                   com.dimata.aiso.entity.masterdata.PstActivityDonorComponentLink,
				   com.dimata.aiso.entity.masterdata.DonorComponent,
				   com.dimata.aiso.entity.masterdata.Activity,
				   com.dimata.aiso.entity.periode.ActivityPeriod,
				   com.dimata.aiso.entity.periode.PstActivityPeriod,
				   com.dimata.aiso.entity.masterdata.PstActivity,
				   com.dimata.aiso.entity.masterdata.PstDonorComponent"
				    %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>
<!--package posbo -->
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
public static final String mainTitle[] = {
	"Data Master","Master Data"
};

public static final String childTitle[] = {
	"Link Aktivitas","Activity Link"
};

public static final String strErrorPeriod[] = {
	"Periode aktivitas belum di pilih. Silahkan pilih periode aktivitas pada tab Period Link",
	"Activity period is not selected yet. Please select activity period on Period Link Tab"
};

public static final String textListTitle[][] =
{
	{"Link Aktivitas ke Komponen Donor","Harus diisi"},
	{"Activity Link to Donor Component","required"}
};

public static final String strCommand[] = {
	"Link Aktivitas","Activity Link"
};

public static final String strListNol[] = {
	"Link Aktivitas Belum Ada","No Link to Donor Component"
};

public static final String strErrorLink[] = {
	"Aktivitas tidak bisa di link ke Komponen Donor, karena bukan Level Activity atau Activity belum di entry",
	"Activity can not link to Donor Component. This activity is not Activity Level or Activity not yet Entry"
};

public static final String textListHeader[][] =
{
	{"No","Kode","Nama", "Budget", "% Alokasi"},
	{"No","Code","Name", "Budget", "% Alocated"}
};

public static final String strTitleHeader[][] = {
	{"Kode","Level","Periode","Keterangan","Induk Aktvitas"},
	{"Code","Level","Period","Description","Activty Parent"}
};

public static final String[] strLevel = {
	"Module","Sub Module","Header","Activity"
};

private String clearDigitSeparator(String strValue){
	String strAngka = "";
	if(strValue != null && strValue.length() > 0){
		StringTokenizer objToken = new StringTokenizer(strValue);        
        while(objToken.hasMoreTokens()){            
            strAngka = strAngka + objToken.nextToken(",");           
        }
	}
	return strAngka;
}

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

public Vector drawList(Vector objectClass, long lActDncLinkId, long lActivityId, long lActPeriodId, int languange, 
int iCommand, FrmActivityDonorComponentLink frmActivityDonorComponentLink, int start, String approot, double dBudget)

{
	//if((objectClass != null && objectClass.size() > 0 ){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");	
	ctrlist.dataFormat(getJspTitle(textListHeader,0,languange,"",false),"5%","left","center");
	ctrlist.dataFormat(getJspTitle(textListHeader,1,languange,"",false),"10%","left","center");
	ctrlist.dataFormat(getJspTitle(textListHeader,2,languange,"",false),"50%","left","center");
	ctrlist.dataFormat(getJspTitle(textListHeader,3,languange,"",false),"25%","left","center");
	ctrlist.dataFormat(getJspTitle(textListHeader,4,languange,"",false),"10%","left","center");
	
	Vector vResult = new Vector(1,1);
	ctrlist.setLinkRow(1);
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
    ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	Vector rowx = new Vector(1,1);
	String strCode = "";
	String strName = "";
	long lDonorCompId = 0;
	double dblBudget = 0.0;
	double dTotal = 0.0;
	DonorComponent objDonorComponent = new DonorComponent();
	ActivityDonorComponentLink objActivityDonorComponentLink = new ActivityDonorComponentLink();
	if(objectClass != null && objectClass.size() > 0){
		try{
			for (int i = 0; i < objectClass.size(); i++){
				objActivityDonorComponentLink = (ActivityDonorComponentLink)objectClass.get(i);
				rowx = new Vector();
				
				if(lActDncLinkId == objActivityDonorComponentLink.getOID()){
					index = i;
				}		
				
				lDonorCompId = objActivityDonorComponentLink.getDonorComponentId();		
				
				if(lDonorCompId > 0){
					try{
						objDonorComponent = PstDonorComponent.fetchExc(lDonorCompId);
					}catch(Exception e){
						System.out.println("Error pada saat fetch Perkiraan ==> "+e.toString());
					}			
				}
				
				strCode = objDonorComponent.getCode();		
				strName = objDonorComponent.getName();
				
				if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
					rowx.add(""+(i+start+1));
					rowx.add("<input type=\"hidden\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_ACTIVITY_ID]+"\" value=\""+lActivityId+"\">"+
							"<input type=\"hidden\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_ACTIVITY_PERIOD_ID]+"\" value=\""+lActPeriodId+"\">"+
							"<input type=\"hidden\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_DONOR_COMPONENT_ID]+"\" value=\""+lDonorCompId+"\">"+
							"<input size=\"20\" type=\"text\" onKeyDown=\"javascript:enterTrapSearch()\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_DONOR_COMPONENT_ID]+"_TEXT\"  value=\""+strCode+"\">"+					
							"<a href =\"javascript:cmdSeachDonorComp()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");  			
					rowx.add("<input size=\"40\" type=\"text\" readOnly=\"true\" name=\"name\" value=\""+strName+"\">");
					rowx.add("<input size=\"25\" type=\"text\" onKeyUp=\"javascript:hitProsenBudget(this)\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_SHARE_BUDGET]+"\" value=\""+Formater.formatNumber(objActivityDonorComponentLink.getShareBudget(),"###")+"\">"); 
					rowx.add("<input size=\"10\" type=\"text\" onKeyDown=\"javascript:enterTrapShare()\" onKeyUp=\"javascript:getText(this)\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_SHARE_PROCENTAGE]+"\" value=\""+Formater.formatNumber((objActivityDonorComponentLink.getShareBudget() / dBudget) * 100,"###")+"\">");   
				  }else{
				
					rowx.add("<div align=\"center\">"+(i+start+1)+"</div>");
					rowx.add(strCode);
					rowx.add(strName);
					rowx.add("<div align=\"right\">"+Formater.formatNumber(objActivityDonorComponentLink.getShareBudget(), "##,###.##")+"</div>");  			
					rowx.add("<div align=\"right\">"+Formater.formatNumber(objActivityDonorComponentLink.getShareProcentage(), "##,###.##")+"%</div>");
				}
				
				dTotal += objActivityDonorComponentLink.getShareBudget();
				lstData.add(rowx);
				lstLinkData.add(String.valueOf(objActivityDonorComponentLink.getOID()));
			}
		}catch(Exception e){
			lstData = new Vector(1,1);
			rowx = new Vector(1,1);
		}
	}
	
	if(dTotal == 0)
			dblBudget = dBudget;
		else
			dblBudget = dBudget - dTotal;	
		
	rowx = new Vector();
	 if(iCommand==Command.ADD){
         rowx.add("");		         
         rowx.add("<input type=\"hidden\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_ACTIVITY_ID]+"\" value=\"\">"+
		 		"<input type=\"hidden\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_ACTIVITY_PERIOD_ID]+"\" value=\"\">"+
				"<input type=\"hidden\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_DONOR_COMPONENT_ID]+"\" value=\"\">"+
                 "<input size=\"20\" type=\"text\" onKeyDown=\"javascript:enterTrapSearch()\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_DONOR_COMPONENT_ID]+"_TEXT\" value=\"\">"+				
				 "<a href =\"javascript:cmdSeachDonorComp()\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>");        
         rowx.add("<input size=\"40\" type=\"text\" readOnly=\"true\" name=\"name\">");
		 rowx.add("<input size=\"25\" type=\"text\" onKeyUp=\"javascript:hitProsenBudget(this)\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_SHARE_BUDGET]+"\" value=\"\">");
		 rowx.add("<input size=\"10\" type=\"text\" onKeyDown=\"javascript:enterTrapBudget()\" onKeyUp=\"javascript:getText(this)\" name=\""+FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_SHARE_PROCENTAGE]+"\" value=\"\">");
         lstData.add(rowx);
	 }
	 
	vResult.add(ctrlist.draw(-1));
	vResult.add(""+dTotal);
	return vResult;
}
%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidActDncLink = FRMQueryString.requestLong(request, "hidden_act_dnc_link_id");
long oidActivity = FRMQueryString.requestLong(request, "oidActivity");
long oidActivityPeriod = FRMQueryString.requestLong(request, "oidActivityPeriod");
String strBudget = FRMQueryString.requestString(request, "dBudget");
double dBudget = Double.parseDouble(strBudget);

boolean privManageData = true; 
int recordToGet = 20;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

String strActivityId = "";
String strActivityPeriodId = "";

whereClause = PstActivityDonorComponentLink.fieldNames[PstActivityDonorComponentLink.FLD_ACTIVITY_PERIOD_ID]+" = "+oidActivityPeriod
			 +" AND "+PstActivityDonorComponentLink.fieldNames[PstActivityDonorComponentLink.FLD_ACTIVITY_ID]+" = "+oidActivity;					 
/**
* ControlLine and Commands caption
*/

ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String strPageCommand = strCommand[SESS_LANGUAGE];
String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_ADD,true);
String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_SAVE,true);
String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_ASK,true);
String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_DELETE,true);
String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "Daftar");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,strPageCommand,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+strPageCommand+" ?";
			 

CtrlActivityDonorComponentLink ctrlActivityDonorComponentLink = new CtrlActivityDonorComponentLink(request);
ctrlActivityDonorComponentLink.setLanguage(SESS_LANGUAGE);
Vector listActivityDonorComponentLink = new Vector(1,1);

FrmSrcContactList frmSrcContactList = new FrmSrcContactList();

iErrCode = ctrlActivityDonorComponentLink.action(iCommand , oidActDncLink);
FrmActivityDonorComponentLink frmActivityDonorComponentLink = ctrlActivityDonorComponentLink.getForm();
frmActivityDonorComponentLink.setDecimalSeparator(".");
frmActivityDonorComponentLink.setDigitSeparator(",");
Activity objActivity = new Activity();
try{
	objActivity = PstActivity.fetchExc(oidActivity);
}catch(Exception e){
	System.out.println("Error pada saat fetch objActivity ==> "+ e.toString());
}
Activity objParentActivity = new Activity();
try{
	objParentActivity = PstActivity.fetchExc(objActivity.getIdParent());
}catch(Exception e){
	System.out.println("Error pada saat fetch objParentActivity ===> "+ e.toString());
}

ActivityPeriod objActivityPeriod = new ActivityPeriod();
try{
	objActivityPeriod = PstActivityPeriod.fetchExc(oidActivityPeriod);
}catch(Exception e){
	System.out.println("Error pada saat fetch objActivityPeriod ====> "+ e.toString());
}

String strActPrdName = objActivityPeriod.getName();
int endIndex = strActPrdName.length();
String strPrdYear = "";
if(endIndex > 0){
	  strPrdYear = strActPrdName.substring((endIndex-5),endIndex);
	}else{		
		strPrdYear = "<em><font color=\"FF0000\" face=\"Verdana, Arial, Helvetica, sans-serif\">"+strErrorPeriod[SESS_LANGUAGE]+"</font></em>";
	}

int vectSize = PstActivityDonorComponentLink.getCount(whereClause);
ActivityDonorComponentLink objActivityDonorComponentLink = ctrlActivityDonorComponentLink.getActivityDonorComponentLink();
msgString =  ctrlActivityDonorComponentLink.getMessage();

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlActivityDonorComponentLink.actionList(iCommand, start, vectSize, recordToGet);
} 

listActivityDonorComponentLink = PstActivityDonorComponentLink.list(start,recordToGet, whereClause , orderClause);
System.out.println("listActivityDonorComponentLink.size() atas  :::::::: "+listActivityDonorComponentLink.size());

if (listActivityDonorComponentLink.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listActivityDonorComponentLink = PstActivityDonorComponentLink.list(start,recordToGet, whereClause, orderClause);
}
double dTotalList = 0.0;
String sList = "";
Vector vList = new Vector(1,1);
	vList = (Vector)drawList(listActivityDonorComponentLink,oidActDncLink,oidActivity, oidActivityPeriod, SESS_LANGUAGE,iCommand,frmActivityDonorComponentLink,start,approot,dBudget);

if(vList != null && vList.size() > 0){
	sList = vList.get(0).toString();
	String sTotalList =  vList.get(1).toString();
	dTotalList = Double.parseDouble(sTotalList);
}

double dNetBudget = 0.0;
double dProsenBudget = 0.0; 
dNetBudget = dBudget - dTotalList;
dProsenBudget = (dNetBudget / dBudget) * 100;
String netBudget = Formater.formatNumber(dNetBudget,"###");
String strProsenBudget = Formater.formatNumber(dProsenBudget,"###");
%>
<html><!-- #BeginTemplate "Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script type="text/javascript" src="../../main/digitseparator.js"></script>
<script language="JavaScript">
<!--
function cmdAdd(){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.hidden_act_dnc_link_id.value="0";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.ADD%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
}

function cmdAsk(oidActDncLink){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.hidden_act_dnc_link_id.value=oidActDncLink;
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.ASK%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
}

function cmdConfirmDelete(oidActDncLink){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.hidden_act_dnc_link_id.value=oidActDncLink;
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
}

function hitProsenBudget(element){
	parserNumberNew(element,false,0,'','','');
	var amount = Math.abs(document.FRM_ACTIVITY_ASSIGN.SHARE_BUDGET.value);
	var budget = Math.abs(document.FRM_ACTIVITY_ASSIGN.dBudget.value);
	var prosen = (amount / budget) * 100;
	document.FRM_ACTIVITY_ASSIGN.SHARE_PROCENTAGE.value = prosen;
}

function getText(element){
	parserNumber(element,false,0,'');
}

function cmdSave(){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
	}

function cmdEdit(oidActDncLink){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.hidden_act_dnc_link_id.value=oidActDncLink;
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
	}

function cmdCancel(oidActDncLink){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.hidden_act_dnc_link_id.value=oidActDncLink;
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
}

function cmdBack(){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.BACK%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
	}

function cmdListFirst(){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=Command.FIRST%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
}

function cmdListPrev(){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.PREV%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=Command.PREV%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
	}

function cmdListNext(){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=Command.NEXT%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
}

function cmdListLast(){
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.command.value="<%=Command.LAST%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.prev_command.value="<%=Command.LAST%>";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.action="act_dnc_link.jsp";
	document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.submit();
}

function cmdSeachDonorComp(){	
	var url = "list_donor_comp.jsp?command=<%=Command.LIST%>&"+
			"code="+document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_DONOR_COMPONENT_ID]%>_TEXT.value+
			"&dBudget=<%=netBudget%>&dProsenBudget=<%=strProsenBudget%>";	
	window.open(url,"src_donor_comp_dnc_link","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");	
	
	}
	
function enterTrapBudget(){
	if(event.keyCode==13){
		document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_SHARE_PROCENTAGE]%>.focus();		
	}
}	
function enterTrapShare(){
	if(event.keyCode==13){				
		cmdSave();		
	}
}	
function enterTrapSearch(){
	if(event.keyCode==13){				
		cmdSeachDonorComp();
	}
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
<link rel="stylesheet" href="../../style/tab.css" type="text/css">
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
           <%=mainTitle[SESS_LANGUAGE]%> &gt; <%=childTitle[SESS_LANGUAGE]%>  &gt; <%=textListTitle[SESS_LANGUAGE][0]%> <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">			  
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_act_dnc_link_id" value="<%=oidActDncLink%>">
			  <input type="hidden" name="oidActivity" value="<%=oidActivity%>">
			  <input type="hidden" name="oidActivityPeriod" value="<%=oidActivityPeriod%>">
			  <input type="hidden" name="dBudget" value="<%=dBudget%>">
			  <input type="hidden" name="<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_ACTIVITY_ID]%>" value="<%=oidActivity%>">
			  <input type="hidden" name="<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_ACTIVITY_PERIOD_ID]%>" value="<%=oidActivityPeriod%>">
			 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3" valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3">&nbsp; </td>
                      </tr>
                      <tr align="left" valign="top">
                        <td height="22" valign="middle" colspan="3">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td colspan="2"> 
								<table width="60%" border="0" cellspacing="0" cellpadding="0">
								  <tr>
								  <td width="2%">&nbsp;</td> 
									<td> 
									  <table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr> 
										  <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
										  <td valign="middle" background="<%=approot%>/images/tab/inactive_bg.jpg"> 
											<div align="center" class="tablink"><a href="<%=approot%>/masterdata/activity/activity_edit.jsp?activity_id=<%=oidActivity%>&command=<%=Command.EDIT%>" class="tablink"><span class="tablink">Activity</span></a></div>
										  </td>
										  <td width="12"   valign="top" align="right"><img src="<%=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
										<td>&nbsp;</td>
										</tr>
									  </table>
									</td>
									<td> 
									  <table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr> 
										  <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
										  <td valign="middle" background="<%=approot%>/images/tab/inactive_bg.jpg" > 
											<div align="center" class="tablink"><a href="<%=approot%>/masterdata/activity/act_acc_link.jsp?hidden_activity_id=<%=oidActivity%>" class="tablink"><span class="tablink">Account 
											  Link</span></a></div>
										  </td>
										  <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
										<td>&nbsp;</td>
										</tr>
									  </table>
									</td>
									<td> 
									  <table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr> 
										  <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
										  <td valign="middle" background="<%=approot%>/images/tab/inactive_bg.jpg" > 
											<div align="center" class="tablink"><a href="<%=approot%>/masterdata/activity/act_prd_link.jsp?hidden_activity_id=<%=oidActivity%>" class="tablink"><span class="tablink">Period 
											  Link</span></a></div>
										  </td>
										  <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
										<td>&nbsp;</td>
										</tr>
									  </table>
									</td>
									<td> 
									  <table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr> 
										  <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/active_left.jpg" width="12" height="29"></td>
										  <td valign="middle" background="<%=approot%>/images/tab/active_bg.jpg"> 
											<div align="center" class="tablink">Donor 
											  Comp Link</div>
										  </td>
										  <td valign="top" align="left" width="10"><img src="<%=approot%>/images/tab/active_right.jpg" width="12" height="29"></td>
										</tr>
									  </table>
									</td>
								  </tr>
								</table>
							  </td>                
							</tr>
						  </table>
						</td>
					  </tr>
					  <tr align="left" valign="top">
						<td width="1%">&nbsp;</td>
						<td bgcolor="#B6CDFB">
							<table width="100%"  border="0" class="listgenactivity">
								<tr>																	
									<td><%if(oidActivity != 0){%>
									<%System.out.println("endIndex :::::::::::::::::::::::::::::::::::::::: "+endIndex);%>
										<%if(endIndex > 0){%>
									<table width="100%"><tr>
									<td width="1%">&nbsp;</td>
									<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][0]%></td>
									<td width="1%">:</td>
									<td width="88%"><%=objActivity.getCode()%></td>
								</tr>
								<tr>
									<td width="1%">&nbsp;</td>
									<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][1]%></td>
									<td width="1%">:</td>
									<td width="88%"><%=strLevel[objActivity.getActLevel()]%></td>										
								</tr>
								<tr>
									<td width="1%">&nbsp;</td>
									<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][2]%></td>
									<td width="1%">:</td>
									<td width="88%"><%=strPrdYear%></td>										
								</tr>
								<tr>
									<td width="1%">&nbsp;</td>
									<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][3]%></td>
									<td width="1%">:</td>
									<td width="88%"><%=objActivity.getDescription()%></td>
									</tr>
								<tr>
									<td td width="1%">&nbsp;</td>
									<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][4]%></td>
									<td td width="1%">:</td>
									<td width="88%"><%=objParentActivity.getDescription()%></td>
								</tr>
							</table>
						</td>
					</tr>							
				  <tr>
				  	<td>
						<table width="100%">
							<tr>
								<td height="22" valign="middle" colspan="3"> 
									  <%if(listActivityDonorComponentLink != null && listActivityDonorComponentLink.size() > 0){%>
									  		<%=sList%> 
									  <%}else{%>
										  <%if(iCommand == Command.ADD || iCommand == Command.SAVE){%>
												<%=sList%> 
										  <%}else{%>
												<b><em><font face="Verdana, Arial, Helvetica, sans-serif" color="#FF0000"><%=strListNol[SESS_LANGUAGE]%></font></em></b> 
										  <%}
									  }%>
								</td>
						  </tr>
						  <tr>
							<td height="8" align="left" colspan="3" class="command"> 
							  <span class="command"> 
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
							  <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> 
							  </span> 
							 </td>
						  </tr>
						  <tr>
							<td width="100%" nowrap class="command">
								<%if(privAdd && privManageData){%><br>
								<%//if(iCommand==Command.NONE||iCommand==Command.FIRST||iCommand==Command.PREV||iCommand==Command.NEXT||iCommand==Command.LAST||iCommand==Command.BACK||iCommand==Command.DELETE||iCommand==Command.SAVE){%>
								<!-- a href="javascript:cmdAdd()"><%//=strAddMar%></a> -->
								<span class="command"><%//}
								}%></span>
							</td>
						   </tr>					   
							<tr>
							   <td><%											  
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidActDncLink+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidActDncLink+"')";
									String scancel = "javascript:cmdEdit('"+oidActDncLink+"')";
									ctrLine.setCommandStyle("command");
									ctrLine.setColCommStyle("command");
									ctrLine.setCancelCaption(strCancel);
									ctrLine.setAddCaption(strAddMar);															
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
									
									if((iCommand == Command.NONE) && (dTotalList == dBudget))
									{
										ctrLine.setAddCaption(""); 
									}
									
									if(iCommand == Command.SAVE || iCommand == Command.DELETE){
										ctrLine.setBackCaption("");
										if(dTotalList == dBudget){
											ctrLine.setAddCaption("");
										}else{
											ctrLine.setAddCaption(strAddMar);
										}
									}
									out.println(ctrLine.draw(iCommand, iErrCode, msgString));
									%>
								</td>
							 </tr>
							 <tr>
								 <td>
									<%}else{%>									
									<em><font color="FF0000" face="Verdana, Arial, Helvetica, sans-serif"><%=strErrorPeriod[SESS_LANGUAGE]%></font>
									<%}
									}else{%>
									<em><font color="FF0000" face="Verdana, Arial, Helvetica, sans-serif"><%=strErrorLink[SESS_LANGUAGE]%></font></em>
									<%}%>
									
								 </td>
							  </tr>
							  <tr>
								 <td>&nbsp;</td>
							  </tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<td height="22" valign="middle" width="1%">&nbsp;</td>
		  </tr>
		</table>
	  </td>
	</tr>			
  </table>
</form> 
			<%
			if(iCommand==Command.ADD)
			{
			%>			
            <script language="javascript">
				//document.<%=FrmActivityDonorComponentLink.FRM_ACTIVITY_ASSIGN%>.<%=FrmActivityDonorComponentLink.fieldNames[FrmActivityDonorComponentLink.FRM_DONOR_COMPONENT_ID]%>_TEXT.focus();
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
                       			                 
                  
                 
                    			
                          
							
                        
					          
                	
				
                    
            
        

