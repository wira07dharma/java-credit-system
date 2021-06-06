<% 
/* 
 * Page Name  		:  back_up.jsp
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
<!--package harisma -->
<%@ page import = "com.dimata.common.entity.service.*" %>
<%@ page import = "com.dimata.common.form.service.*" %>
<%@ page import = "com.dimata.common.session.service.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%!
/* this constant used to list text of listHeader */
public static final String textJspTitle[][] = 
{
  {
  "Proses ini akan mem-backup database berdasarkan konfigurasi di bawah ini.", 
  "- Klik tombol <font color=\"#0000FF\">Start</font> untuk menjalankan proses backup database", 
  "- Klik tombol <font color=\"#0000FF\">Stop</font> untuk menghentikan proses backup database", 
  "Konfigurasi :", "Waktu Mulai", "Durasi", "Menit", "Simpan",
  "Status :", "Status backup database adalah", "Running", "Stopped",
  "Sistem > Back Up Database"  
  },
  
  {
  "This process will backup database based on service configuration below.", 
  "- Click <font color=\"#0000FF\">start</font>button to start backup database service process.", 
  "- Click <font color=\"#0000FF\">stop</font>button to stop backup database service process.", 
  "Configuration :", "Start Time", "Interval", "Minutes", "Save",
  "Status :", "Backup database service status is", "Running", "Stopped",
  "System > Back Up Database"
  }	
};
%>
<!-- Jsp Block -->
<%
int iCommandBackup = FRMQueryString.requestInt(request,"command_backup");
long oidServiceBackup = FRMQueryString.requestLong(request, "hidden_service_backup_id");       

Date toDay = new Date();

// simpan data dalam array
int serviceType = PstServiceConfiguration.SERVICE_TYPE_BACKUPDB;
int startTimeHour = FRMQueryString.requestInt(request,FrmServiceConfiguration.fieldNames[FrmServiceConfiguration.FRM_FIELD_START_TIME]+"_hr");
int startTimeMinutes = FRMQueryString.requestInt(request,FrmServiceConfiguration.fieldNames[FrmServiceConfiguration.FRM_FIELD_START_TIME]+"_mi");
int timeInterval = FRMQueryString.requestInt(request,FrmServiceConfiguration.fieldNames[FrmServiceConfiguration.FRM_FIELD_PERIODE]);
System.out.println("timeInterval : " + timeInterval);

Vector vectResult = new Vector(1,1);
CtrlServiceConfiguration ctrlServiceConfiguration = new CtrlServiceConfiguration(request);	
ServiceConfiguration serviceConfBackup = ctrlServiceConfiguration.action(iCommandBackup, oidServiceBackup, serviceType, startTimeHour, startTimeMinutes, timeInterval);
oidServiceBackup = serviceConfBackup.getOID();
%>
<!-- End of Jsp Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function cmdStopBackup()
{
  document.frm_servicecenter.command_backup.value="<%= Command.STOP %>"; 
  document.frm_servicecenter.start.value="0";
  document.frm_servicecenter.maxLog.value="0";  
  document.frm_servicecenter.submit();  
}

function cmdStartBackup()
{
  document.frm_servicecenter.start.value="0";
  document.frm_servicecenter.maxLog.value="0";
  document.frm_servicecenter.command_backup.value="<%= Command.START %>";   
  document.frm_servicecenter.action="service_center.jsp";  
  document.frm_servicecenter.submit();
}

function cmdUpdateBackup(){
  document.frm_servicecenter.command_backup.value="<%= Command.SAVE %>";     
  document.frm_servicecenter.start.value="0";
  document.frm_servicecenter.maxLog.value="0";
  document.frm_servicecenter.submit();
} 

// -------------- script control line -------------------
function MM_swapImgRestore() 
{ //v3.0
	var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) 
{ //v4.0
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() 
{ //v3.0 
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}//-->
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
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=textJspTitle[SESS_LANGUAGE][12]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frm_servicecenter" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="command_backup" value="<%=iCommandBackup%>">
              <input type="hidden" name="hidden_service_backup_id" value="<%=oidServiceBackup%>">
              <input type="hidden" name="log_command" value="0">
              <input type="hidden" name="start" value="<%//=start%>">
              <input type="hidden" name="maxLog" value="<%//=maxLog%>">
              <table width="100%" border="0" cellpadding="2" cellspacing="2">
                <tr align="left" valign="top"> 
                  <td height="8" valign="middle" colspan="3"> 
                    <hr size="1">
                  </td>
                </tr>
                <tr> 
                  <td width="48%" valign="top"> 
                    <table width="100%" border="0" cellspacing="1" cellpadding="1" align="center">
                      <tr> 
                        <td align="left" colspan="2"><%=textJspTitle[SESS_LANGUAGE][0]%></td>
                      </tr>
                      <tr> 
                        <td align="left" width="5%">&nbsp;</td>
                        <td align="left" width="95%"><%=textJspTitle[SESS_LANGUAGE][1]%></td>
                        <%
						  Date dtBackup=null;
						  try
						  {
							dtBackup = serviceConfBackup.getStartTime();  
							if(dtBackup==null)
							{
								dtBackup = new Date();
							}
						  }
						  catch(Exception e)
						  {
							dtBackup = new Date();
						  }
						  %>
                      </tr>
                      <tr> 
                        <td align="left" width="5%">&nbsp;</td>
                        <td align="left" width="95%"><%=textJspTitle[SESS_LANGUAGE][2]%></td>
                      </tr>
                      <tr> 
                        <td align="left" width="5%">&nbsp;</td>
                        <td align="left" width="95%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="left" colspan="2"><b><%=textJspTitle[SESS_LANGUAGE][3]%></b></td>
                      </tr>
                      <tr> 
                        <td align="left" width="5%">&nbsp;</td>
                        <td align="left" width="95%"> 
                          <table width="100%" border="0" cellspacing="1" cellpadding="1">
                            <tr> 
                              <td width="7%"><%=textJspTitle[SESS_LANGUAGE][4]%></td>
                              <td width="1%">:</td>
                              <td width="92%"><%=ControlDate.drawTime(FrmServiceConfiguration.fieldNames[FrmServiceConfiguration.FRM_FIELD_START_TIME], dtBackup, "formElemen")%></td>
                            </tr>
                            <tr> 
                              <td width="7%"><%=textJspTitle[SESS_LANGUAGE][5]%></td>
                              <td width="1%">:</td>
                              <td width="92%"> 
                                <input type="text" name="<%=FrmServiceConfiguration.fieldNames[FrmServiceConfiguration.FRM_FIELD_PERIODE]%>" value="<%=serviceConfBackup.getPeriode()%>" class="formElemen" size="10">
                                <i>(<%=textJspTitle[SESS_LANGUAGE][6]%>)</i></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <%
						String stCommandScript = "d:\\tomcat\\webapps\\aisover02\\backup.bat";    																											
						BackupDatabaseProcess objBackupDatabaseProcess = new BackupDatabaseProcess(stCommandScript);
						switch (iCommandBackup)
						{
							case  Command.START :
								try
								{
									objBackupDatabaseProcess.startService();  //menghidupkan service presence analyser
								}
								catch(Exception e)
								{
									System.out.println("exc when objBackupDatabaseProcess.startService() : " + e.toString());
								}
								break;
						
							case  Command.STOP :
								try
								{
									objBackupDatabaseProcess.stopService();  //mematikan service
								}
								catch(Exception e)
								{
									System.out.println("exc when objBackupDatabaseProcess.stopService : " + e.toString());
								}
								break;
						}						  

						boolean serviceBackupDatabaseRunning = objBackupDatabaseProcess.getStatus();  													
						String stopStsBackup="";
						String startStsBackup="";
						if(serviceBackupDatabaseRunning)
						{ 					
							startStsBackup="disabled=\"true\"";
							stopStsBackup="";
						} 
						else
						{
							startStsBackup="";
							stopStsBackup="disabled=\"true\"";
						}
						%>
                      <tr> 
                        <td align="left" width="5%">&nbsp;</td>
                        <td align="left" width="95%"> 
                          <input type="button" name="btnSaveBackup" value="   <%=textJspTitle[SESS_LANGUAGE][7]%>   " onClick="javascript:cmdUpdateBackup()" class="formElemen" <%=startStsBackup%>>
                        </td>
                      </tr>
                      <tr> 
                        <td align="left" width="5%">&nbsp;</td>
                        <td align="left" width="95%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="left" colspan="2"><b><%=textJspTitle[SESS_LANGUAGE][8]%></b></td>
                      </tr>
                      <tr> 
                        <td align="left" width="5%">&nbsp;</td>
                        <td align="left" width="95%"><%=textJspTitle[SESS_LANGUAGE][9]%>&nbsp;&nbsp; 
                          <%							
							if(serviceBackupDatabaseRunning)
							{
							%>
                          <font color="#009900"><%=textJspTitle[SESS_LANGUAGE][10]%>...</font> 
                          <%
							}
							else
							{
							%>
                          <font color="#FF0000"><%=textJspTitle[SESS_LANGUAGE][11]%></font> 
                          <%
							}
							%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="5%">&nbsp;</td>
                        <td width="95%"> 
                          <%//if(hasExecutePriv){%>
                          <input type="button" name="Button4" value="  Start  " onClick="javascript:cmdStartBackup()" class="formElemen" <%=startStsBackup%>>
                          <input type="button" name="Submit24" value="  Stop  " onClick="javascript:cmdStopBackup()" class="formElemen" <%=stopStsBackup%>>
                          <%//}%>
                        </td>
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
