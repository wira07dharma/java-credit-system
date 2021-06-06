<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>

<%@ page language="java" %>

<!-- import dimata-->
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!-- import qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>

<!-- import aiso-->
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.FrmActivityPeriodLink" %>
<%@ page import = "com.dimata.aiso.form.masterdata.CtrlActivityPeriodLink,
				   com.dimata.aiso.entity.masterdata.Activity,
				   com.dimata.aiso.form.masterdata.FrmActivityDonorComponentLink,
				   com.dimata.aiso.entity.masterdata.PstActivity"%>
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>


<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<!-- JSP Block -->
<%!
/**
 * untuk data custom lokasi
 * @param userID
 * @return
 */
 
public static final String strTitle[] = {
	"Data Master","Master Data"
};

public static final String strSubTitle[] = {
	"Aktivitas","Activity"
};

public static final String strPartTitle[] = {
	"Aktivitas Link ke Periode","Activity Link to Period"
};

public static final String strCommand[] = {
	"Link Aktivitas","Activity Link"
};

public static final String strErrorLink[] = {
	"Aktivitas tidak bisa di link ke Komponen Donor, karena bukan Level Activity atau Activity belum di entry!!!",
	"Activity can not link to Donor Component. This activity is not Activity Level or Activity not yet Entry !!!"
};

public static final String strTitleHeader[][] = {
	{"Kode","Level","Keterangan","Induk Aktvitas"},
	{"Code","Level","Description","Activty Parent"}
};

public static final String[] strLevel = {
	"Module","Sub Module","Header","Activity"
};
 
private static String clearDigitSeparator(String strValue){
	String strAngka = "";
	if(strValue != null && strValue.length() > 0){
		StringTokenizer objToken = new StringTokenizer(strValue);        
        while(objToken.hasMoreTokens()){            
            strAngka = strAngka + objToken.nextToken(",");           
        }
	}
	return strAngka;
}
 
public String drawCheckBudgetPeriod(long userID, Vector vCheck, String command, String secondCom, String approot, long lActivityId)
{
    ControlCheckBox objControlCheckBox =new ControlCheckBox();    
	
	objControlCheckBox.setCellSpace("0");
    objControlCheckBox.setCellStyle("");
    objControlCheckBox.setWidth(4);
    objControlCheckBox.setTableAlign("left");
    objControlCheckBox.setCellWidth("10%"); 
	
	String strYear = "";  

	try
	{
		Vector checkValues = new Vector(1,1);
		Vector checkPosted = new Vector(1,1);
		Vector checkCaptions = new Vector(1,1);		
				
		String orderBy = PstActivityPeriod.fieldNames[PstActivityPeriod.FLD_END_DATE];		
							
		Vector listActivityPeriod = PstActivityPeriod.list(0,0,"",orderBy); 		
		
		if(listActivityPeriod!=null && listActivityPeriod.size()>0)
		{
			Vector userCustoms = PstDataCustom.getDataCustom(userID);		
			if(userCustoms!=null && userCustoms.size()>0)
			{		
				int maxCust = userCustoms.size();					
				int maxV = listActivityPeriod.size();		
				
				for(int i=0; i<maxV; i++)
				{
					ActivityPeriod objActivityPeriod = (ActivityPeriod) listActivityPeriod.get(i);					
													
					for(int j=0; j<maxCust; j++)
					{
						DataCustom dataCustom = (DataCustom) userCustoms.get(j);
												
							checkValues.add(Long.toString(objActivityPeriod.getOID()));
							checkPosted.add(""+(objActivityPeriod.getPosted()));
							checkCaptions.add(objActivityPeriod.getName());
							break;							
											
					}				
				}
			}
		}
		
		return objControlCheckBox.drawME(checkValues,checkCaptions,vCheck,command,checkPosted,secondCom,approot,lActivityId);

	}
	catch (Exception exc)
	{
		System.out.println(exc.toString());
		return "No Link To Activity Period";
	}
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
long oidActPrdLink = FRMQueryString.requestLong(request, "hidden_ActPrdLink_id");
long oidActivity = FRMQueryString.requestLong(request, ""+FrmActivityPeriodLink.fieldNames[FrmActivityPeriodLink.FRM_ACTIVITY_ID]+"");
long oidPeriod = FRMQueryString.requestLong(request, "hidden_activity_period_id");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");


String msgString = "";
int iErrCode = FRMMessage.NONE;

String strActivityId = "";
			
strActivityId = (String)session.getValue("ACTIVITY_ID");
if(strActivityId != null && strActivityId.length() > 0){
	oidActivity = Long.parseLong(strActivityId);	
}


		
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
String saveConfirm = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Data is saved" : "Data tersimpan";


String strMessage = "";

CtrlActivityPeriodLink ctrlActivityPeriodLink = new CtrlActivityPeriodLink(request);
ctrlActivityPeriodLink.setLanguage(SESS_LANGUAGE);
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
String orderBy = PstActivityPeriod.fieldNames[PstActivityPeriod.FLD_END_DATE];							
Vector listActivityPeriod = PstActivityPeriod.list(0,0,"",orderBy);

Vector vectData = new Vector(1,1);
Vector vCheck = new Vector();
double vlBudget = 0;
if(iCommand==Command.SAVE){
	if(listActivityPeriod!=null && listActivityPeriod.size()>0){    
		for(int i=0;i<listActivityPeriod.size();i++){
				Vector vectBudget = new Vector();			
				objActivityPeriod = (ActivityPeriod)listActivityPeriod.get(i);            
					long oidCheck = FRMQueryString.requestLong(request, "checkbox_"+i);					
					if(oidCheck!=0){
						String stBudget = clearDigitSeparator(FRMQueryString.requestString(request, "budget_"+i));			
						
						// this for selected and values text
						Vector vt = new Vector();
						if(stBudget != null && stBudget.length() > 0){					
							vt.add(String.valueOf(oidCheck));
							vt.add(stBudget);
							vCheck.add(vt);
						}
						vectBudget.add(""+oidCheck);
						vectBudget.add(strActivityId);						
						vectBudget.add(stBudget);           
						
						vectData.add(vectBudget);
					}				
				
		}
		
	}
}
ActivityPeriodLink objActivityPeriodLink = new ActivityPeriodLink();
iErrCode = ctrlActivityPeriodLink.action(iCommand,oidActPrdLink,vectData);
FrmActivityPeriodLink frmActivityPeriodLink = ctrlActivityPeriodLink.getForm();
msgString = ctrlActivityPeriodLink.getMessage();
if(iErrCode == 0 && iCommand == Command.SAVE)
	msgString = saveConfirm;
objActivityPeriodLink = ctrlActivityPeriodLink.getActivityPeriodLink();
oidActPrdLink = objActivityPeriodLink.getOID();

String ordBy = PstActivityPeriodLink.fieldNames[PstActivityPeriodLink.FLD_ACT_PERIOD_ID];
String whCls = PstActivityPeriodLink.fieldNames[PstActivityPeriodLink.FLD_ACTIVITY_ID] +" = "+strActivityId;
Vector listActivityPeriodLink = PstActivityPeriodLink.list(0,0,whCls,ordBy);

if(listActivityPeriodLink!=null && listActivityPeriodLink.size()>0){
	for(int i=0;i<listActivityPeriodLink.size();i++){            
            ActivityPeriodLink objActPeriodLink = (ActivityPeriodLink)listActivityPeriodLink.get(i);            
				long oidCheck = objActPeriodLink.getActivityPeriodId();	
				long oidAct = objActPeriodLink.getActivityId();		
				
				String strActId = String.valueOf(oidActivity);
				ActivityPeriod objActivityPrd = PstActivityPeriod.fetchExc(oidCheck);
				int stPosted = objActivityPrd.getPosted();			
								
				if(oidCheck!=0){
					double valBudget = objActPeriodLink.getBudget();
					String valBgt = Formater.formatNumber(valBudget, "###");
					// this for selected and values text
					Vector vFillValue = new Vector();					
					if((strActivityId != null && strActivityId.length() > 0) && (stPosted != PstActivityPeriod.PERIOD_CLOSED) && (oidAct != oidActivity)){						
							vFillValue.add(String.valueOf(oidCheck));
							vFillValue.add(valBgt);
						
					}else{					
						vFillValue.add(String.valueOf(oidCheck));
						vFillValue.add(valBgt);
					}
					vCheck.add(vFillValue);				
					
				}			
	}	
}

String strActivityPeriod = String.valueOf(oidPeriod);

if(session.getValue("ACTIVITY_PERIOD_ID") != null){
	session.removeValue("ACTIVITY_PERIOD_ID");
	}
if(objActivityPeriodLink.getBudget() == vlBudget){	
		session.putValue("ACTIVITY_PERIOD_ID", strActivityPeriod);
		}
		
			
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<script type="text/javascript" src="../../main/digitseparator.js"></script>
<script language="javascript">

function checkBox(form){	
	switch(form.name){	
	<% if(listActivityPeriod !=null && listActivityPeriod.size() > 0){
		for(int i=0; i<listActivityPeriod.size(); i++){%>		
		
		case 'checkbox_<%=i%>':
			if(!document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.checkbox_<%=i%>.checked){
				alert("Are you sure uncheck. Uncheck cause data unsave");
				document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.budget_<%=i%>.disabled = true;
				document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.budget_<%=i%>.value = "";
			}else{
				document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.budget_<%=i%>.disabled = false;
				document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.budget_<%=i%>.focus();
			}
			break;
	
	<%}
	}
	%>	
				
	}
}

function refresh(){ 
	window.location.reload( false ); 
	}

function searchLoc(url){

	window.location = url;
}

function getText(element){
	parserNumber(element,false,0,'');
}
	
function cmdAdd(){
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.hidden_ActPrdLink_id.value="0";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.command.value="<%=Command.ADD%>";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.action="act_prd_link.jsp";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.submit();
}

function cmdAsk(oidActPrdLink){
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.hidden_ActPrdLink_id.value=oidActPrdLink;
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.command.value="<%=Command.ASK%>";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.action="act_prd_link.jsp";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.submit();
}

function cmdConfirmDelete(oidActPrdLink){
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.hidden_ActPrdLink_id.value=oidActPrdLink;
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.action="act_prd_link.jsp";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.submit();
}
function cmdSave(){
		document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.command.value="<%=Command.SAVE%>";
		document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.prev_command.value="<%=prevCommand%>";
		document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.action="act_prd_link.jsp";
		document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.submit();
	}

function cmdEdit(oidPeriod){
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.command.value="<%=Command.EDIT%>"; 
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.action="act_dnc_link.jsp?oidActivityPeriod=oidPeriod";	
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.submit();
		
	}

function cmdCancel(oidActPrdLink){
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.hidden_ActPrdLink_id.value=oidActPrdLink;
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.action="act_prd_link.jsp";
	document.<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>.submit();
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 

<!-- #EndEditable -->
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=strTitle[SESS_LANGUAGE]%> 
            &gt; <%=strSubTitle[SESS_LANGUAGE]%>  &gt; <%=strPartTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmActivityPeriodLink.FRM_ACT_PRD_LINK%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
			  <input type="hidden" name="hidden_ActPrdLink_id" value="<%=oidActPrdLink%>">
			  <input type="hidden" name="<%=FrmActivityPeriodLink.fieldNames[FrmActivityPeriodLink.FRM_ACTIVITY_ID]%>" value="<%=oidActivity%>">
			  <input type="hidden" name="hidden_activity_period_id" value="<%=oidPeriod%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2"> 
                    <table width="60%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
					  <td width="2%">&nbsp;</td>
                        <td > 
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
                              <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/active_left.jpg" width="12" height="29"></td>
                              <td valign="middle" background="<%=approot%>/images/tab/active_bg.jpg" > 
                                <div align="center" class="tablink"><span class="tablink">Period 
                                  Link</span></div>
                              </td>
                              <td valign="top" align="left" width="12"><img src="<%=approot%>/images/tab/active_right.jpg" width="12" height="29"></td>
                            <td>&nbsp;</td>
							</tr>
                          </table>
                        </td>
                        <td>
						<!---  
                          <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td valign="top" align="left" width="12"><img src="<%//=approot%>/images/tab/inactive_left.jpg" width="12" height="29"></td>
                              <td valign="middle" background="<%//=approot%>/images/tab/inactive_bg.jpg"> 
                                <div align="center" class="tablink"><a href="<%//=approot%>/masterdata/activity/act_dnc_link.jsp?hidden_activity_id=<%//=oidActivity%>" class="tablink"><span class="tablink">Donor 
                                  Comp Link</span></a></div>
                              </td>
                              <td valign="top" align="left" width="10"><img src="<%//=approot%>/images/tab/inactive_right.jpg" width="12" height="29"></td>
                            </tr>
                          </table>
						  -->
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                
                <tr>
                  <td width="1%">&nbsp;</td>
                  <td bgcolor="#B6CDFB"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                    <tr><td><%if(strActivityId != null && strActivityId.length() > 0){%></td></tr>
					<tr>
						<td>
							<table width="100%">
								<tr>
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
									<td width="88%"><%=objActivity.getDescription()%></td>
								</tr>
								<tr>
									<td td width="1%">&nbsp;</td>
									<td width="10%"><%=strTitleHeader[SESS_LANGUAGE][3]%></td>
									<td td width="1%">:</td>
									<td width="88%"><%=objParentActivity.getDescription()%></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>		
					<tr>						
						<td width="1%">
							<table width="100%">
								<tr>
								<td width="1%">&nbsp;</td>								
                      			<td width="98%" class="listgencontent">
									
									<%=drawCheckBudgetPeriod(userOID,vCheck,"onClick=\"javascript:checkBox(this)\"","onKeyUp=\"javascript:getText(this)\"",approot,oidActivity)%>
								</td>
								<td width="1%" >&nbsp;
								</td>		
                    			</tr>
								<%if(iCommand == Command.SAVE){%>
								<tr><td width="1%">&nbsp;</td>	
								<td class="msginfo"><%=msgString%></td>
								</tr>
								<%}%>							
								 <tr>
								 	<td width="1%">&nbsp;</td>									
                      				<td>
										<%if(iCommand==Command.NONE||iCommand==Command.EDIT||iCommand==Command.PREV||iCommand==Command.NEXT||iCommand==Command.LAST||iCommand==Command.BACK||iCommand==Command.DELETE||iCommand==Command.SAVE){%>
										<input name="btnSave" type="button" onClick="javascript:cmdSave()" value="<%=strSaveMar%>">
									</td>
                    			</tr>
                    			<tr>
									<td width="1%">&nbsp;</td>									
                      				<td>
										<%}%>
										<%=strMessage%>
									</td>
                    			</tr>
                    			<tr>
									<td width="1%">&nbsp;</td>									
                      				<td>
										<%}else{%><em><font color="FF0000" face="Verdana, Arial, Helvetica, sans-serif">
										<%=strErrorLink[SESS_LANGUAGE]%><%}%></font></em>
									</td>
								<tr><td>&nbsp;</td></tr>
							</table>
						</td>
					</tr>                    			
                  </table>
				</td>
				<td width="1%">&nbsp;</td>             
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
