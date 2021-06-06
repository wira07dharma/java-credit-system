
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@ page import = "com.dimata.aiso.entity.masterdata.BussinessCenterBudget,
		  com.dimata.aiso.session.masterdata.SessBussCenterBgt,
		  com.dimata.aiso.entity.masterdata.BussinessCenter,
		  com.dimata.aiso.entity.masterdata.PstBussinessCenter,
		  com.dimata.aiso.entity.masterdata.PstBussCenterBudget,
		  com.dimata.aiso.form.masterdata.FrmBussCenterBudget,
		  com.dimata.aiso.form.masterdata.CtrlBussCenterBudget,
		  com.dimata.aiso.entity.periode.PstPeriode,
		  com.dimata.aiso.entity.periode.Periode,
		  com.dimata.aiso.entity.masterdata.Perkiraan,
		  com.dimata.aiso.entity.masterdata.PstPerkiraan"%>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_COMPANY_CLASS); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privUpdate && !privDelete){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<!-- Jsp Block -->
<%!
public static String strTitle[][] = {
	{"No","Periode","Pusat Bisnis","Perkiraan","Anggaran"},	
	{"No","Period","Bussiness Center","Chart of Account","Budget"}
};

public static final String masterTitle[] = {
	"Daftar","List"	
};

public static final String classTitle[] = {
	"Anggaran Pusat Bisnis","Bussiness Center Budget"	
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

public String getAccount(int language, Perkiraan objPerkiraan)
{
	String sResult = "";
	try
	{
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
			sResult = objPerkiraan.getNama();
		}
		else
		{
			sResult = objPerkiraan.getAccountNameEnglish();
		}
	}
	catch(Exception e){}
	return sResult;
}

public String drawList(int language,int iCommand,FrmBussCenterBudget frmBussCenterBgt, Vector objectClass, long oidBussCenterBgt, int iStart,Vector vPeriode,String approot, Vector vBussCenter){
	
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");	
	ctrlist.dataFormat(strTitle[language][0],"3%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"20%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"32%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"20%","center","right");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);
	ctrlist.reset();
	int index = -1;
	
	Vector vPeriodVal = new Vector(1,1);
	Vector vPeriodKey = new Vector(1,1);
	String sSelectedPeriod = "";
	if(vPeriode != null && vPeriode.size() > 0){
		for(int c = 0; c < vPeriode.size(); c++){
			Periode objPeriode = (Periode)vPeriode.get(c);
			vPeriodVal.add(""+objPeriode.getOID());
			vPeriodKey.add(objPeriode.getNama());
		}
	}

	Vector vBussCenterVal = new Vector(1,1);
	Vector vBussCenterKey = new Vector(1,1);
	String sSelectedBussCenter = "";
	if(vBussCenter != null && vBussCenter.size() > 0){
		for(int b = 0; b < vBussCenter.size(); b++){
			BussinessCenter objBussCenter = (BussinessCenter)vBussCenter.get(b);
			vBussCenterVal.add(""+objBussCenter.getOID());
			vBussCenterKey.add(objBussCenter.getBussCenterName());
		}
	}
	
try{
	for(int i=0; i<objectClass.size(); i++) {
		 BussinessCenterBudget objBussCenterBgt = (BussinessCenterBudget)objectClass.get(i);
		 sSelectedPeriod = String.valueOf(objBussCenterBgt.getPeriodeId());	
		 sSelectedBussCenter = String.valueOf(objBussCenterBgt.getBussCenterId());	
		 
		 long bussCenterId = objBussCenterBgt.getBussCenterId();
		 BussinessCenter objBussCenter = new BussinessCenter();
		 if(bussCenterId != 0)
		 {
		 	try
			{
				objBussCenter = PstBussinessCenter.fetchExc(bussCenterId);
			}
			catch(Exception e){objBussCenter = new BussinessCenter();}
		 }
		 
		 long periodId = objBussCenterBgt.getPeriodeId();
		 Periode objPeriode = new Periode();
		 if(periodId != 0)
		 {
		 	try
			{
				objPeriode = PstPeriode.fetchExc(periodId);
			}
			catch(Exception e){objPeriode = new Periode();}
		 }
		 
		 
		 long perkiraanId = objBussCenterBgt.getIdPerkiraan();
		 Perkiraan objPerkiraan = new Perkiraan();
		 if(perkiraanId != 0){
		 	try
			{
				objPerkiraan = PstPerkiraan.fetchExc(perkiraanId);
			}catch(Exception e){objPerkiraan = new Perkiraan();}
		 }	 
		
		//For check record to edit	
		 if(oidBussCenterBgt == objBussCenterBgt.getOID())
		 	index = i;
		 
		 rowx = new Vector(1,1);
		 if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
			rowx.add(""+(i+1));
			rowx.add(""+ControlCombo.draw(frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_PERIODE_ID], null, sSelectedPeriod, vPeriodVal, vPeriodKey,"","")
					);
			rowx.add(""+ControlCombo.draw(frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_BUSS_CENTER_ID], null, sSelectedBussCenter, vBussCenterVal, vBussCenterKey,"","")
					);
			rowx.add("<input type=\"text\" name=\""+frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_ID_PERKIRAAN] +"_TEXT\" value=\""+getAccount(language,objPerkiraan)+"\" class=\"elemenForm\" size=\"55\">"+
			"<a href=\"javascript:cmdopen()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>"+
			"<input type=\"hidden\" name=\""+frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_ID_PERKIRAAN] +"\" value=\""+perkiraanId+"\" class=\"elemenForm\">");
			rowx.add("<input type=\"text\" name=\""+frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_BUDGET] +"\" value=\""+Formater.formatNumber(objBussCenterBgt.getBudget(),"###")+"\" class=\"elemenForm\" size=\"55\">");
		}else{		
			rowx.add(""+(i+1));
			rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objBussCenterBgt.getOID())+"')\">"+objPeriode.getNama()+"</a>");
			rowx.add(objBussCenter.getBussCenterName());
			rowx.add(getAccount(language,objPerkiraan));
			rowx.add(Formater.formatNumber(objBussCenterBgt.getBudget(),"##,###.##"));
		} 

		lstData.add(rowx);
	}

	rowx = new Vector();
	if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmBussCenterBgt.errorSize()>0)){ 	
			rowx.add("");
			rowx.add(""+ControlCombo.draw(frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_PERIODE_ID], null, sSelectedPeriod, vPeriodVal, vPeriodKey,"","")
					);
			rowx.add(""+ControlCombo.draw(frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_BUSS_CENTER_ID], null, sSelectedBussCenter, vBussCenterVal, vBussCenterKey,"",""));
			rowx.add("<input type=\"text\" name=\""+frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_ID_PERKIRAAN] +"_TEXT\" value=\"\" class=\"elemenForm\" size=\"55\">"+
			"<a href=\"javascript:cmdopen()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>"+
			"<input type=\"hidden\" name=\""+frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_ID_PERKIRAAN] +"\" value=\"\" class=\"elemenForm\">");
			rowx.add("<input type=\"text\" name=\""+frmBussCenterBgt.fieldNames[frmBussCenterBgt.FRM_BUDGET] +"\" value=\"\" class=\"elemenForm\" size=\"55\">");
	}
	
	lstData.add(rowx);
	
	}catch(Exception e){
		System.out.println("Exception on list ::::::: "+e.toString());
	}
	return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidBussCenterBgt = FRMQueryString.requestLong(request, "hidden_buss_center_bgt_id");

	
/*variable declaration*/
int recordToGet = 100;
String msgString = "";


/**
* Setup controlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = classTitle[SESS_LANGUAGE];
String strAddCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strBackCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strDeleteCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";

ctrLine.initDefault(SESS_LANGUAGE,currPageTitle);
CtrlBussCenterBudget ctrlBussCenterBgt = new CtrlBussCenterBudget(request);
int iErrCode = ctrlBussCenterBgt.action(iCommand , oidBussCenterBgt);
FrmBussCenterBudget frmBussCenterBgt = ctrlBussCenterBgt.getForm();
BussinessCenterBudget objBussCenter = ctrlBussCenterBgt.getBussCenterBgt();
msgString =  ctrlBussCenterBgt.getMessage();

int vectSize = SessBussCenterBgt.getCount();
Vector vPeriode = PstPeriode.list(0,0,"",PstPeriode.fieldNames[PstPeriode.FLD_IDPERIODE]+" DESC ");
Vector vBussCenter = PstBussinessCenter.list(0,0,"",PstBussinessCenter.fieldNames[PstBussinessCenter.FLD_BUSS_CENTER_NAME]);
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlBussCenterBgt.actionList(iCommand, start, vectSize, recordToGet);
} 

Vector vDataBussCenterBgt = PstBussCenterBudget.list(start,recordToGet, "" , PstBussCenterBudget.fieldNames[PstBussCenterBudget.FLD_PERIODE_ID]+" DESC ");

if (vDataBussCenterBgt.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet){
			start = start - recordToGet; 
	 }else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 vDataBussCenterBgt = PstBussCenterBudget.list(start,recordToGet, "" , PstBussCenterBudget.fieldNames[PstBussCenterBudget.FLD_PERIODE_ID]+" DESC ");
}

%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){	
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.hidden_buss_center_bgt_id.value="0";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.ADD%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function cmdAsk(oidBussCenterBgt){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.hidden_buss_center_bgt_id.value=oidBussCenterBgt;
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.ASK%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function cmdConfirmDelete(oidBussCenterBgt){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.hidden_buss_center_bgt_id.value=oidBussCenterBgt;
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function cmdSave(){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function cmdEdit(oidBussCenterBgt){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.hidden_buss_center_bgt_id.value=oidBussCenterBgt;
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function cmdCancel(oidBussCenterBgt){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.hidden_buss_center_bgt_id.value=oidBussCenterBgt;
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function cmdBack(){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.BACK%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function first(){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.prev_command.value="<%=Command.FIRST%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function prev(){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.PREV%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.prev_command.value="<%=Command.PREV%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function next(){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.prev_command.value="<%=Command.NEXT%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function last(){
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.command.value="<%=Command.LAST%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.prev_command.value="<%=Command.LAST%>";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.action="buss_center_bgt_edit.jsp";
	document.<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>.submit();
}

function cmdopen(){
	var url = "list_coa.jsp";
    window.open(url,"search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 

</SCRIPT>
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --> 
           <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmBussCenterBudget.FRM_BUSSINESS_CENTER_BUDGET%>" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_buss_center_bgt_id" value="<%=oidBussCenterBgt%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3">&nbsp; 
                          
                        </td>
                      </tr>
                      <%
							try{
							%>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
						<%= drawList(SESS_LANGUAGE,iCommand,frmBussCenterBgt, vDataBussCenterBgt,oidBussCenterBgt,start,vPeriode,approot,vBussCenter)%> </td>
                      </tr>
                      <% 
						  }catch(Exception exc){ 
						  }%>
                      <tr align="left" valign="top"> 
                        <td height="8" align="left" colspan="3" class="command"> 
                          <span class="command"> 
                          <% 
						   int cmd = 0;
							   if ((iCommand == Command.FIRST || iCommand == Command.PREV )|| 
								(iCommand == Command.NEXT || iCommand == Command.LAST))
									cmd =iCommand; 
						   else{
							  if(iCommand == Command.NONE || prevCommand == Command.NONE)
								cmd = Command.LAST;
							  else 
								cmd =prevCommand; 
						   } 
						   ctrLine.initDefault();
						 %>
                         <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"first","prev","next","last","left")%></span> </td>
                      </tr>					  
                      <%//if(privAdd && (iErrCode==CtrlContactClass.RSLT_OK)&&(iCommand!=Command.ADD)&&(iCommand!=Command.ASK)&&(iCommand!=Command.EDIT)&&(frmContactClass.errorSize()==0)){ %>
					  					  
                      <!-- <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
						<a href="javascript:cmdAdd()" class="command"><%//=strAddCls%></a>
                        </td>
                      </tr> -->
                      <%//}%>					  
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top" > 
                  <td colspan="3" class="command"> 
                    <% 
					ctrLine.setLocationImg(approot+"/images");						  					
					ctrLine.initDefault();
					ctrLine.setTableWidth("80%");
					String scomDel = "javascript:cmdAsk('"+oidBussCenterBgt+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidBussCenterBgt+"')";
					String scancel = "javascript:cmdEdit('"+oidBussCenterBgt+"')";
					ctrLine.setCommandStyle("command");
					ctrLine.setColCommStyle("command");
					ctrLine.setCancelCaption(strBackCls);
					ctrLine.setBackCaption("");
					ctrLine.setSaveCaption(strSaveCls);
					ctrLine.setDeleteCaption(strAskCls);
					ctrLine.setAddCaption(strAddCls);
					ctrLine.setConfirmDelCaption(strDeleteCls);

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
					}%>
					<%=ctrLine.draw(iCommand, iErrCode, msgString)%> 
					<% if(iCommand==Command.ASK)
						ctrLine.setDeleteQuestion(delConfirm);%>				
					
                    
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
      <%@ include file = "/main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>
