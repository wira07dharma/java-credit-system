<% 
/* 
 * Page Name  		:  ijconfiguration.jsp
 * Created on 		:  27 Des 2004
 * 
 * @author  		:  gedhy 
 * @version  		:  01
 */

/*******************************************************************
 * Page Description : IJ Configuration per Bo System
 * Imput Parameters : -
 * Output 			: -
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
<!--package ij -->
<%@ page import = "com.dimata.ij.entity.configuration.*" %>
<%@ page import = "com.dimata.ij.form.configuration.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../main/checkuser.jsp" %>
<%
// Check privilege except VIEW, view is already checked on checkuser.jsp as basic access
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
// get vector of data from form request
int iCommand = FRMQueryString.requestCommand(request);
int intBoSystem = FRMQueryString.requestInt(request, FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_BO_SYSTEM]);
String strIjImplClass = FRMQueryString.requestString(request, FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_IJ_IMPL_CLASS]);
String[] strConfigGroup = request.getParameterValues(FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_CONFIG_GROUP]);
String[] strConfigItem = request.getParameterValues(FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_CONFIG_ITEM]);
String[] strConfigSelect = request.getParameterValues(FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_CONFIG_SELECT]);

// variable declaration
String configTitle = "IJ Configuration";

// Process IJConfiguration to db
PstIjConfiguration objPstIjConfiguration = new PstIjConfiguration();
    if(iCommand == Command.NONE)
        intBoSystem = BO_SYSTEM;

if(iCommand == Command.SAVE || iCommand == Command.NONE)
{
	int result = objPstIjConfiguration.storeIjConfPerBoSystem(intBoSystem, strConfigGroup, strConfigItem, strConfigSelect, strIjImplClass);
}
%>
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<script language="JavaScript">
function cmdChange(){
	document.frmijconfiguration.command.value="<%=Command.EDIT%>";
	document.frmijconfiguration.action="ijconfiguration_1.jsp";
	document.frmijconfiguration.submit();
}

function cmdSave(){
	document.frmijconfiguration.command.value="<%=Command.SAVE%>";
	document.frmijconfiguration.action="ijconfiguration_1.jsp";
	document.frmijconfiguration.submit();
}
</script>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
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
</SCRIPT>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
</head>
<!--body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">-->
<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <!--<tr>
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE"> 
      <%//@ include file = "../../main/header.jsp" %>
    </td>
  </tr>
  <tr> 
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
      <%//@ include file = "../../main/menumain.jsp" %>
    </td>
  </tr>-->
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --> 
            AISO > IJ Configuration<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmijconfiguration" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <hr>
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <table class="listgen" width="100%" border="0">
                      <tr> 
                        <td width="14%"><b>Back Office System :</b></td>
                        <td> 
                        <%
						out.println(ControlCombo.draw(FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_BO_SYSTEM], null, ""+intBoSystem, vectBOKey, vectBOVal, "onChange=\"javascript:cmdChange()\"", ""));						
						%>
                        </td>
                      </tr>
                    </table>
                    <table class="listgen" width="100%" border="0">
                      <%
					int maxConfigGroup = PstIjConfiguration.strConfigGroup.length;
					for(int i=0; i<maxConfigGroup; i++)
					{
						int maxConfigItem = PstIjConfiguration.strConfigItem[i].length;
						int selectedConfigSelect = 0;
						for(int j=0; j<maxConfigItem; j++)
						{
							selectedConfigSelect = objPstIjConfiguration.getIJConfiguration(intBoSystem, i, j);
						
							Vector vectKeyConfig = new Vector(1,1);
							Vector vectValConfig = new Vector(1,1);
							vectKeyConfig.add("-1");
							vectValConfig.add("...:: select ::...");																						
							int maxConfigSelect = PstIjConfiguration.strConfigSelect[i][j].length;							
							for(int k=0; k<maxConfigSelect; k++)
							{
								vectKeyConfig.add(""+k);
								vectValConfig.add(""+PstIjConfiguration.strConfigSelect[i][j][k]);															
							}
					%>
                      <tr class="listgensell"> 
                        <%
					  	if( (maxConfigItem==1) )
						{
						%>
                        <td valign="top"><b><%=PstIjConfiguration.strConfigGroup[i]%></b></td>
                        <%
						}
						%>
                        <%
						if( (maxConfigItem>1 && j==0) )      
						{
						%>
                        <td valign="top" rowspan="<%=maxConfigItem%>"><b><%=PstIjConfiguration.strConfigGroup[i]%></b></td>
                        <%
						}
						%>
                        <td width="30%"> <%=PstIjConfiguration.strConfigItem[i][j]%> 
                          <input type="hidden" name="<%=FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_CONFIG_GROUP]%>" value="<%=i%>">
                          <input type="hidden" name="<%=FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_CONFIG_ITEM]%>" value="<%=j%>">
                        </td>
                        <td width="56%"><%=ControlCombo.draw(FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_CONFIG_SELECT], null, ""+selectedConfigSelect, vectKeyConfig, vectValConfig, "formElemen", "")%></td>
                      </tr>
                      <%
						}
					}
					%>
                    </table>
                    <table class="listgen" width="100%" border="0">
                      <tr> 
                        <td width="14%"><b>Class Implementator :</b></td>
                        <td> 
						  <%
						  IjConfiguration objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(intBoSystem, 0, 0);
						  %>	
                          <input type="text" name="<%=FrmIjConfiguration.fieldNames[FrmIjConfiguration.FRM_FIELD_IJ_IMPL_CLASS]%>" size="50" value="<%=objIjConfiguration.getSIjImplClass()%>">
                        </td>
                      </tr>
                    </table>					
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3">&nbsp;</td>
                </tr>
                <tr align="left" valign="top" > 
                  <td colspan="3" class="command"> 
                    <div class="command"> <a href="javascript:cmdSave()"> 
                      <%
					ControlLine ctrLine = new ControlLine();
					out.println(ctrLine.getCommand(SESS_LANGUAGE,configTitle,ctrLine.CMD_SAVE,true));
					%>
                      </a> </div>
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
