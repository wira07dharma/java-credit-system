<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="com.dimata.util.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.qdep.form.*" %>

<%@ page import="com.dimata.common.form.system.*" %>

<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<% 
int iCommand = FRMQueryString.requestCommand(request);
long lOid = FRMQueryString.requestLong(request, "oid");
CtrlSystemProperty ctrlSystemProperty = new CtrlSystemProperty(request);
ctrlSystemProperty.action(iCommand, lOid, request);

SystemProperty sysProp = ctrlSystemProperty.getSystemProperty();
FrmSystemProperty frmSystemProperty = ctrlSystemProperty.getForm();
%>
<%!
public static final String textListTitleHeader[][]=
{
	{"Sistem","Seting Aplikasi","Nama","Nilai","Keterangan","Update Nilai","Batal","Load Nilai Terbaru","Keterangan :", 
	 "Gunakan karakter \"\\\\\" jika anda ingin menginput karakter \"\\\" dalam bagian nilai.",
	 "Klik \"Load Nilai Terbaru\" untuk mengaktifkan nilai variabel terbaru." },
	{"System","Application Setting","Name","Value","Description","Update Value","Canceled","Load the Newest Value","Note :",
	 "Use character \"\\\\\" if you want to input character \"\\\" into part of value.",
	  "Click \"Load the Newest Value\" to active the Newest Variable Value."}
};
%>
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language=javascript>
function cmdList(){
  document.frmData.command.value="<%= Command.LIST %>";          
  document.frmData.action = "sysprop.jsp";
  document.frmData.submit();
}

function cmdEdit(oid){
  <%if(privUpdate){%>
  document.frmData.command.value="<%= Command.EDIT %>";                    
  document.frmData.oid.value = oid;
  document.frmData.action = "syspropnew.jsp";
  document.frmData.submit();
  <%}%>
}	

function cmdAssign(oid){
  <%if(privUpdate){%>	
  document.frmData.command.value="<%= Command.ASSIGN %>";       
  document.frmData.oid.value= oid;          
  document.frmData.action = "sysprop.jsp";
  document.frmData.submit();
  <%}%>
}

<%if((privAdd)&&(privDelete)){%>
function cmdLoad(){
  document.frmData.command.value="<%= Command.LOAD %>";          
  document.frmData.action = "sysprop.jsp";
  document.frmData.submit();
}

function cmdNew(){
  document.frmData.command.value="<%= Command.ADD %>";          
  document.frmData.action = "syspropnew.jsp";
  document.frmData.submit();
}

function cmdUpdate(oid){
  document.frmData.command.value="<%= Command.UPDATE %>";          
  document.frmData.oid.value = oid;
  document.frmData.action = "sysprop.jsp";
  document.frmData.submit();
}
<%}%>
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
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" -->&nbsp;<%=textListTitleHeader[SESS_LANGUAGE][0]%> &gt; <%=textListTitleHeader[SESS_LANGUAGE][1]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmData" method="post" action="">
              <input type="hidden" name="command" value="0">
              <input type="hidden" name="oid" value="<%= lOid %>">
              <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr> 
                  <td> 
                    <hr noshade size="1">
                  </td>
                </tr>
                <tr> 
                  <td> 
                    <%			  
					String cbxName = FrmSystemProperty.fieldNames[FrmSystemProperty.FRM_GROUP];			
					String groupName = FRMQueryString.requestString(request, cbxName);
	
					if(groupName==null || groupName.equals("")){
					   groupName = "";
					} 
	
					Vector grs = Validator.toVector(SessSystemProperty.groups, SessSystemProperty.subGroups, "", "", true);
					Vector val = Validator.toVector(SessSystemProperty.groups, SessSystemProperty.subGroups, "", "", false);
					String attr = "onChange=\"javacript:cmdList()\"";
					out.println("&nbsp;"+ControlCombo.draw(cbxName, null, groupName, val, grs, attr));			
				    %>
                    <%
					ControlList ctrlList = new ControlList();
					ctrlList.setListStyle("listgen");
					ctrlList.setTitleStyle("listgentitle");
					ctrlList.setCellStyle("listgensell");
					ctrlList.setHeaderStyle("listgentitle");
				
					ctrlList.addHeader(textListTitleHeader[SESS_LANGUAGE][2],"20%");
					ctrlList.addHeader(textListTitleHeader[SESS_LANGUAGE][3],"25%");
					ctrlList.addHeader(textListTitleHeader[SESS_LANGUAGE][4],"55%");
				
					ctrlList.setLinkRow(0);
					ctrlList.setLinkSufix("");
				  %>
                  </td>
                </tr>
                <tr> 
                  <td> 
                    <%
						String editValPre = "<input type=\"text\" name=\"" + FrmSystemProperty.fieldNames[FrmSystemProperty.FRM_VALUE] +"\" size=\"20\" value=\"";
						String editValSup = "\"> * "+ frmSystemProperty.getErrorMsg(FrmSystemProperty.FRM_NAME);
		
						Vector lstData 		= ctrlList.getData();
						Vector lstLinkData 	= ctrlList.getLinkData();
		
						Vector vctData = new Vector();
						try {
							vctData = PstSystemProperty.listByGroup(groupName);
		
							ctrlList.setLinkPrefix("javascript:cmdAssign('");					
							ctrlList.setLinkSufix("')");
							ctrlList.reset();
		
							if (vctData != null) {  
								for (int i = 0; i < vctData.size(); i++) {
									 Vector rowx = new Vector();
		
									 SystemProperty sysProp2 = (SystemProperty)vctData.get(i);
		
									 rowx.add(sysProp2.getName());
		
									 if(iCommand == Command.ASSIGN && lOid == sysProp2.getOID()) {
										rowx.add(editValPre + sysProp2.getValue() + editValSup);
									 }else{
										rowx.add(sysProp2.getValue());								
									 }
		
									 rowx.add(sysProp2.getNote());
		
									 lstData.add(rowx); 
									 lstLinkData.add(String.valueOf(sysProp2.getOID()));
								}
							}
						} catch(Exception e) {
							System.out.println("Exc : " + e.toString());
						} 
						out.println(ctrlList.draw());
						%>
                  </td>
                </tr>
                <tr> 
                  <td align="right"> 
                    <div align="right"><%= "<i>" + ctrlSystemProperty.getMessage() + "</i>" %> </div>
                  </td>
                </tr>
                <tr> 
                  <td align="right"> 
                    <%if((privAdd)&&(privUpdate)&&(privDelete)){%>
                    <div align="right"> 
                      <% 
							if(iCommand == Command.ASSIGN) {
							out.println("<a href=\"javascript:cmdUpdate('"+ lOid +"')\">"+textListTitleHeader[SESS_LANGUAGE][5]+"</a> | <a href='javascript:cmdList()'>"+textListTitleHeader[SESS_LANGUAGE][6]+"</a> | ");
							}
							out.println("<a href=\"javascript:cmdLoad()\">"+textListTitleHeader[SESS_LANGUAGE][7]+"</a>&nbsp;");
						 %>
                      <%}%>
                    </div>
                  </td>
                </tr>
                <tr> 
                  <td align="left">&nbsp;<%=textListTitleHeader[SESS_LANGUAGE][8]%> <br>
                    &nbsp;- <%=textListTitleHeader[SESS_LANGUAGE][9]%><br>
                    &nbsp;- <%=textListTitleHeader[SESS_LANGUAGE][10]%> </td>
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
<!-- endif of "has access" condition -->
