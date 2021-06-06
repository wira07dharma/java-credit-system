<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>
<%@ page import="com.dimata.aiso.session.system.*" %>

<!--import java-->
<%@ page import="java.util.Date" %>

<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_GNR_LEDGER, AppObjInfo.OBJ_REPORT_GNR_LEDGER_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 
if(!privView && !privSubmit){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<!-- JSP Block -->
<%
String YR = "_yr";
String MN = "_mn";
String DY = "_dy";
String MM = "_mm";
String HH = "_hh";    
String orderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
Vector listPeriod = PstPeriode.list(0,0,"",orderBy);
Date firstPeriodDate = new Date();
if(listPeriod!=null && listPeriod.size()>0){
	Periode per = (Periode)listPeriod.get(0);
	firstPeriodDate = per.getTglAwal();
}
Date nowDate = new Date();
int interval = firstPeriodDate.getYear() - nowDate.getYear();

int iCommand = FRMQueryString.requestCommand(request);
long accountId = FRMQueryString.requestLong(request,"ACCOUNT_NAME");
Date startDate = FRMQueryString.requestDate(request,"START_DATE");
Date dueDate = FRMQueryString.requestDate(request,"DUE_DATE");

String order = "NOMOR_PERKIRAAN";
CtrlJurnalDetail ctrljurnaldetail = new CtrlJurnalDetail(request) ;  
FrmJurnalDetail frmjurnaldetail = ctrljurnaldetail.getForm(); 


Vector vectVal = new Vector(1,1);
Vector vectKey = new Vector(1,1);
Vector listAccGroup = AppValue.getVectorAccGroup();				  
if(listAccGroup!=null && listAccGroup.size()>0){
	for(int i=0; i<listAccGroup.size(); i++){
		Vector tempResult = (Vector)listAccGroup.get(i);
		vectVal.add(tempResult.get(0));
		vectKey.add(tempResult.get(1));		
	}
}
%>
<!-- End of JSP Block -->

<html><!-- #BeginTemplate "/Templates/aiso.dwt" -->    
<head>   
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
function cmdChange(){
	var n = document.frmGeneralLedger.ACCOUNT_GROUP.value;
	switch(n){
	<%
	if(vectVal!=null && vectVal.size()>0){
		for(int i=0; i<vectVal.size(); i++){
		Vector listAccount = AppValue.getAppValueVector(i+1);		
	%>
		case "<%=vectVal.get(i)%>" :
		
			 for(var j=document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT]%>.length-1; j>-1; j--){
				document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT]%>.options.remove(j);
			 }
			 			 
			 <%			 
			 String space = "";
			 if(listAccount!=null && listAccount.size()>0){
				for(int k=0; k<listAccount.size(); k++){  
				   Perkiraan perkiraan = (Perkiraan)listAccount.get(k); 
				   switch(perkiraan.getLevel()){
					   case 1 : space = ""; break; 
					   case 2 : space = "    "; break;
					   case 3 : space = "        "; break;
					   case 4 : space = "            "; break;
					   case 5 : space = "                "; break;
					   case 6 : space = "                    "; break;															    															   															   															   															   
				   }				   
				%>
				
				var oOption = document.createElement("OPTION");
				oOption.value = "<%=perkiraan.getOID()%>";				
				oOption.text = "<%=space+perkiraan.getNoPerkiraan()+"    "+perkiraan.getNama()%>";
				document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT]%>.add(oOption);						
				
				<%   
				} 
			 }																												
			 %>
			 break;	
	<%	
		}	
	}
	%>			
		default :
			break;
	}
}

function report(){
	var accountId  = document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT]%>.value;
	var currency   = document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_CURRENCY]%>.value;		
	var startYear  = document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE]+YR%>.value;								
	var startMonth = document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE]+MN%>.value;
	var startDate  = document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE]+DY%>.value;
	var dueYear    = document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE]+YR%>.value;				
	var dueMonth   = document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE]+MN%>.value;				
	var dueDate    = document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE]+DY%>.value;				
	var linkPage   = "general_ledger_buffer.jsp?" +
					 "<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT]%>=" + accountId + "&" +
					 "<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_CURRENCY]%>=" + currency + "&" +						 
					 "<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE]+YR%>=" + startYear + "&" + 
					 "<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE]+MN%>=" + startMonth + "&" + 
					 "<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE]+DY%>=" + startDate + "&" + 						 
					 "<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE]+YR%>=" + dueYear + "&" + 
					 "<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE]+MN%>=" + dueMonth + "&" + 
					 "<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE]+DY%>=" + dueDate; 		
	window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no");  			
}
</script>
<!-- #EndEditable --> 
<!-- #BeginEditable "headerscript" -->
<SCRIPT language=JavaScript>
function hideObjectForMenuJournal(){ 
}
	
function hideObjectForMenuReport(){
    <%if(privView && privSubmit){%>						  			  
	document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT]%>.style.visibility="hidden";
	<%}%>
}
	
function hideObjectForMenuPeriod(){
}
	
function hideObjectForMenuMasterData(){
    <%if(privView && privSubmit){%>						  			  
	document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT]%>.style.visibility="hidden";
	<%}%>
}

function hideObjectForMenuSystem(){
}

function showObjectForMenu(){
    <%if(privView && privSubmit){%>						  			  
	document.frmGeneralLedger.<%=SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT]%>.style.visibility="";	
	<%}%>
}
</SCRIPT>
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
    <td bgcolor="#000099" height="20" ID="MAINMENU"> 
      <%@ include file = "../main/menumain.jsp" %>
    </td> 
  </tr>
  <tr>
    <td valign="top" align="left">  
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td  class="contenttitle" height="10"><!-- #BeginEditable "contenttitle" --> 
            Report &nbsp; &gt;&nbsp;General Ledger<!-- #EndEditable --></td>
        </tr>
        <tr>
          <td height="21"><!-- #BeginEditable "content" --> 
            <form name="frmGeneralLedger" method="post" action="">
			<input type="hidden" name="command">			
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"> 
                    <hr>
                  </td>
                </tr>
              </table>
			  <%if(privView && privSubmit){%>						  			  
              <table width="100%" border="0">
                <tr> 
                  <td width="8%" height="23">Account Name</td>
                  <td height="23" width="2%"> 
                    <div align="center"><b>: </b></div>
                  </td>
                  <td height="23" width="90%"> 
				  <%
				  String attrChange = "onChange=\"javascript:cmdChange()\"";																															  
    			  out.println(ControlCombo.draw("ACCOUNT_GROUP",null,null,vectVal,vectKey,attrChange));				  
				  %>
				  
                  <%
				  Vector accCodeKey = new Vector(1,1);
				  Vector accOptionStyle = new Vector(1,1);
				  Vector accCodeVal = new Vector(1,1);
				  String strSelect = "";									
 				  //Vector listCode = PstPerkiraan.list(0,0,"",order);
				  Vector listCode = AppValue.getAppValueVector(AppValue.ACCOUNT_CHART);
				  if(listCode!=null && listCode.size()>0){
						String space = "";
						for(int i=0; i<listCode.size(); i++){  
						   Perkiraan perkiraan = (Perkiraan)listCode.get(i); 
						   switch(perkiraan.getLevel()){
							   case 1 : space = "&nbsp;"; break; 
							   case 2 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
							   case 3 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
							   case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
							   case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
							   case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;															    															   															   															   															   
						   }
						   accCodeKey.add(""+perkiraan.getOID());
						   accCodeVal.add(space + perkiraan.getNoPerkiraan() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+perkiraan.getNama()) ; 
					 } 
				  }																																				  
				  %>
                    <%=ControlCombo.draw(SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT],null,strSelect,accCodeKey,accCodeVal)%></td>
                </tr>
                <tr> 
                  <td width="8%" height="20%">Duration, from</td>
                  <td height="20%" width="2%"> 
                    <div align="center"><b>: </b></div>
                  </td>
                  <td height="20%" width="90%"> <%=ControlDate.drawDate(SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE], new Date(), 0, interval)%> to <%=ControlDate.drawDate(SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE], new Date(), 0, interval)%></td>
                </tr>
                <tr> 
                  <td width="8%" height="20%">Currency</td>
                  <td height="20%" width="2%"> 
                    <div align="center"><b>: </b></div>
                  </td>
                  <td height="20%" width="90%"> <%=ControlCombo.draw(SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_CURRENCY],null,null,PstJurnalUmum.getCurrencyKey(),PstJurnalUmum.getCurrencyValue())%> </td>
                </tr>
                <tr> 
                  <td width="8%" height="20%">&nbsp;</td>
                  <td height="20%" width="2%">&nbsp;</td>
                  <td height="20%" width="90%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="8%" height="20%">&nbsp;</td>
                  <td height="20%" width="2%"> 
                    <div align="center"></div>
                  </td>
                  <td height="20%" width="90%"><a href="javascript:report()"><span class="command">Preview 
                    Report </span></a> </td>
                </tr>
                <tr> 
                  <td colspan="3" height="15">&nbsp;</td>
                </tr>
              </table>
			  <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><font color="#FF0000"><i>You haven't privilege 
                    for accessing general ledger report !!! </i></font></td>
                </tr>
              </table>			  			  
			  <%}%>			  
            </form>
            <!-- #EndEditable --></td>
        </tr>
      </table>
    </td>  
  </tr>  
  <tr> 
    <td bgcolor="#000099" height="29"> 
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>