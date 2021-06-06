<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>
<!--import java-->
<%@ page import="java.util.Date" %>
<%@ page import="java.util.*" %>
<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<%@ page import="com.dimata.util.*" %> 
<!--import common-->
<%@ page import="com.dimata.common.entity.contact.*" %>
<%@ page import="com.dimata.common.session.contact.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_PAYABLE, AppObjInfo.OBJ_REPORT_OTHERS_PAYABLE_PRIV); %>
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

<%!
public static String strTitle[][] = { 
	{"Tipe Laporan","Kategori Kontak","Nama Kontak","Tgl Jatuh Tempo","Periode Ini (",")","Termasuk Semua Tanggal",
	"Berdasar Tanggal, Dari ","Sampai","Tipe Ageing","Periode","Tipe Pembukuan",
	"Anda tidak punya hak akses untuk laporan utang !!!"},
		
	{"Report Type","Contact Category","Contact Name","Due Date","Current Period (",")","Including All Date",
	"Base On Date, From ","To","Ageing Type","Period","Book Type",
	"You haven't privilege for accessing payable report !!!"}
};

public static final String masterTitle[] = {
	"Laporan","Report"	
};

public static final String listTitle[] = {
	"Utang","Payable"	
};
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

Vector listClass = PstContactClass.listAll();
Hashtable hashClass = SessContactClass.getContactClassAndItsList(PstPerkiraan.SUB_LEDGER_LIABILITY);

/**
* Declare Commands caption
*/
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/aiso.dwt" -->    
<head>   
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">

function cmdChange(){
	var type = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_TYPE]%>.value;	
	switch(type){
		case "<%=SessPayable.BY_CONTACT%>" : 
	         msgExist.innerHTML = "";
			 document.all.CATEGORY.style.display = "block";				 			 			 			 				
			 document.all.CONTACT.style.display = "none";			
			 document.all.DUEDATE.style.display = "none";
			 document.all.AGETYPE.style.display = "none";				 			 			 			 
			 document.all.PERIODTYPE.style.display = "none";				 			 			 			 							 			 			 			 				
			 break;
		case "<%=SessPayable.BY_DUEDATE%>" : 		
			 msgExist.innerHTML = "";
			 document.all.CATEGORY.style.display = "block";				 			 			 			 							 
			 document.all.CONTACT.style.display = "none";		
			 document.all.DUEDATE.style.display = "block";
			 document.all.AGETYPE.style.display = "none";				 			 			 			 
			 document.all.PERIODTYPE.style.display = "none";				 			 			 			 							 			 			 			 
			 break;
		case "<%=SessPayable.BY_AGEING%>" : 
			 msgExist.innerHTML = "";
			 document.all.CATEGORY.style.display = "block";				 			 			 			 							 
			 document.all.CONTACT.style.display = "none";		
			 document.all.DUEDATE.style.display = "none";	
			 document.all.AGETYPE.style.display = "block";
			 document.all.PERIODTYPE.style.display = "none";				 			 			 			 							 			 			 
			 break;	
		case "<%=SessPayable.BY_PERIOD%>" : 
			 msgExist.innerHTML = "";
			 document.all.CATEGORY.style.display = "block";				 			 			 			 							 
			 document.all.CONTACT.style.display = "none";		
			 document.all.DUEDATE.style.display = "none";	
			 document.all.AGETYPE.style.display = "none";
			 document.all.PERIODTYPE.style.display = "block";				 			 			 			 							 			 
			 break;				 			 			 			 			 			 			 			 
	}
}

function report(){  
        var reportType = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_TYPE]%>.value;
	    var classId = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS]%>.value;

		var classText = "";
		for(i=0; i<document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS]%>.length; i++) {
			if(document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS]%>.options[i].selected){
				classText = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS]%>.options[i].text;
			}
		}
		switch(reportType){
			case "<%=SessPayable.BY_CONTACT%>" : 
				 var idContact = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.value;				
				 var currency = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CURRENCY]%>.value;				
				 msgExist.innerHTML = "";						
				 var linkPage  = "payable_buffer.jsp?" +
				 				 "CLS_CAT=" + classText + "&" +										
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_TYPE]%>=" + reportType + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS]%>=" + classId + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>=" + idContact + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CURRENCY]%>=" + currency;
				 window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no"); 			
				 break;
				 
			case "<%=SessPayable.BY_DUEDATE%>" :
				 var dateType = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>.value;				
				 if(document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>[0].checked){
					dateType = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>[0].value;								
				 }else if(document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>[1].checked){
					dateType = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>[1].value;								
				 }else {
					dateType = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>[2].value;
				 }														
				
				 var startYear  = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_START_DATE]+YR%>.value;								
				 var startMonth = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_START_DATE]+MN%>.value;
				 var startDate  = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_START_DATE]+DY%>.value;
				 var dueYear    = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]+YR%>.value;				
				 var dueMonth   = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]+MN%>.value;				
				 var dueDate    = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]+DY%>.value;		
				 var currency 	= document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CURRENCY]%>.value;				
				 var linkPage  = "payable_buffer.jsp?" +
								 "CLS_CAT=" + classText + "&" +								 
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS]%>=" + classId + "&" +				 
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_TYPE]%>=" + reportType + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>=" + dateType + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_START_DATE]+YR%>=" + startYear + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_START_DATE]+MN%>=" + startMonth + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_START_DATE]+DY%>=" + startDate + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]+YR%>=" + dueYear + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]+MN%>=" + dueMonth + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]+DY%>=" + dueDate + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CURRENCY]%>=" + currency;
				 window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no"); 
				 break;			
				 
			case "<%=SessPayable.BY_AGEING%>" :
				 var idContact = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.value;							
				 var ageingType  = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_AGEING]%>.value;								
				 var currency = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CURRENCY]%>.value;				
				 var linkPage  = "payable_buffer.jsp?" +
								 "CLS_CAT=" + classText + "&" +				
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS]%>=" + classId + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>=" + idContact + "&" +								 				 
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_TYPE]%>=" + reportType + "&" +				 
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_AGEING]%>=" + ageingType + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CURRENCY]%>=" + currency;
				 window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no"); 
				 break;
			case "<%=SessPayable.BY_PERIOD%>" :
				 var idContact = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.value;										
				 var idPeriod = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_PERIODE]%>.value;							
				 var currency = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CURRENCY]%>.value;				
				 var linkPage  = "payable_buffer.jsp?" +
								 "CLS_CAT=" + classText + "&" +				
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS]%>=" + classId + "&" +
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>=" + idContact + "&" +	
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_TYPE]%>=" + reportType + "&" +				 
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_PERIODE]%>=" + idPeriod + "&" +				 
								 "<%=SessPayable.payFieldNames[SessPayable.FLD_CURRENCY]%>=" + currency;
				 window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no"); 
				 break;				 				 				 				 
		}
}
	
function changeContactClass(){
	var type = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_TYPE]%>.value;
	if(type != <%=SessPayable.BY_PERIOD%>){

	var classOid = document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS]%>.value;
	switch(classOid){
	<%
	if(listClass!=null && listClass.size()>0){		
		for(int i=0; i<listClass.size(); i++){
		ContactClass cntClass = (ContactClass)listClass.get(i);
	%>
		case "<%=cntClass.getOID()%>" :		
			 for(var j=document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.length-1; j>-1; j--){
				document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.options.remove(j);
			 }			 
			 
			 <%
			 Vector vectContactList = (Vector)hashClass.get(String.valueOf(cntClass.getOID()));
			 if(vectContactList!=null && vectContactList.size()>0){
			 %>

				 if(document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_TYPE]%>.value!=1){
				   document.all.CONTACT.style.display = "block";		
				   var oOption = document.createElement("OPTION");
				   oOption.value = "0";				
				   oOption.text = "All Contact";
				   document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.add(oOption);										 
			 	 }
				 
			 	<%
				for(int k=0; k<vectContactList.size(); k++){  
				   ContactList cntList = (ContactList)vectContactList.get(k);
				   String cntOid = "0"; 
				   String cntName = ""; 				   
				   if((cntList.getContactType()==PstContactList.OWN_COMPANY) || (cntList.getContactType()==PstContactList.EXT_COMPANY)){			 
						cntOid=""+cntList.getOID();
						cntName=cntList.getCompName(); 						
				   }else{
						 if((cntList.getPersonName()!=null) && (cntList.getPersonLastname()!=null)){			 
							cntOid=""+cntList.getOID();
							cntName=cntList.getPersonName()+" "+cntList.getPersonLastname(); 												 
						 }
				   }					   				   		
				%>
								
					var oOption = document.createElement("OPTION");
					oOption.value = "<%=cntOid%>";				
					oOption.text = "<%=cntName%>";
					document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.add(oOption);						
				
			 <%
			 	}
			 }else{
			 %>

				 for(var j=document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.length-1; j>-1; j--){
					document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.options.remove(j);
				 }			 			 

				 var oOption = document.createElement("OPTION");
				 oOption.value = "";				
				 oOption.text = "No Contact";
				 document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.add(oOption);										 
			 
			 <%
			 }
			 %>
			 break;	
	<%	
		}	
	}
	%>
	
		default :
			for(var j=document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.length-1; j>-1; j--){
				document.frmPayable.<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>.options.remove(j);
			}			 			 
		    document.all.CONTACT.style.display = "none";		
	}
	}
}	
</script>
<!-- #EndEditable --> 
<!-- #BeginEditable "headerscript" -->
<SCRIPT language=JavaScript>
function hideObjectForMenuJournal(){ 
}
	
function hideObjectForMenuReport(){
    <%if(privView && privSubmit){%>						  			  
	document.all.<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]%>_yr.style.visibility = "hidden";
	document.all.<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]%>_mn.style.visibility = "hidden";
	document.all.<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]%>_dy.style.visibility = "hidden";	 
	<%}%>
}
	
function hideObjectForMenuPeriod(){
}
	
function hideObjectForMenuMasterData(){
}

function hideObjectForMenuSystem(){
}

//*****************
function showObjectForMenu(){
    <%if(privView && privSubmit){%>						  			  
	document.all.<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]%>_yr.style.visibility = "";
	document.all.<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]%>_mn.style.visibility = "";	 
	document.all.<%=SessPayable.payFieldNames[SessPayable.FLD_END_DATE]%>_dy.style.visibility = "";	 		
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
            <%=masterTitle[SESS_LANGUAGE]%>&nbsp;&gt;&nbsp;<%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td height="21"><!-- #BeginEditable "content" --> 
            <form name="frmPayable" method="post" action="">
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
                  <td ID=msgExist colspan="3" height="20%" class="msgbalance"> 
                    <div align="center"><b></b></div>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="20%"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="20%" width="2%"> : </td>
                  <td height="20%" width="87%">&nbsp;&nbsp; 
                    <%
				  	Vector vectorKey = new Vector(1,1);
				  	Vector vectorValue = new Vector(1,1);
				  	for(int i=0; i<SessPayable.reportFieldNames[0].length; i++){ 
					   vectorKey.add(String.valueOf(i));
					   vectorValue.add(SessPayable.reportFieldNames[SESS_LANGUAGE][i]) ; 
				  	}
				  	String attrType = "onChange=\"javascript:cmdChange()\"";
				  	%>
                    <%=ControlCombo.draw(SessPayable.payFieldNames[SessPayable.FLD_TYPE],null,null,vectorKey,vectorValue,attrType)%> </td>
                </tr>
                <tr id="CATEGORY"> 
                  <td width="11%" height="20%"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td height="20%" width="2%"> :</td>
                  <td height="20%" width="87%">&nbsp;&nbsp; 
                    <%
				  String attrChangeContact = "onChange=\"javascript:changeContactClass()\"";
				  Vector ClassKey = new Vector(1,1);
				  Vector ClassVal = new Vector(1,1);
				  ClassKey.add("0");
				  ClassVal.add("All Category") ; 												 
				  if(listClass!=null && listClass.size()>0){				  
					  for(int i=0; i<listClass.size(); i++){ 
						ContactClass cnt = (ContactClass)listClass.get(i);					   
						ClassKey.add(""+cnt.getOID());
						ClassVal.add(cnt.getClassName()) ; 												 
					  }
				  }else{
					ClassKey.add("");
					ClassVal.add("No Category Available") ; 										  
				  }
				  %>
                    <%=ControlCombo.draw(SessPayable.payFieldNames[SessPayable.FLD_CONTACT_CLASS],null,null,ClassKey,ClassVal,attrChangeContact)%></td>
                </tr>
                <%
				String currStartDate = "";
				String currDueDate = "";
				Date startDate = new Date();
				Date dueDate = new Date();				
				Vector currDate = SessPeriode.getCurrPeriod();
				if(currDate.size()==1){
				   Periode per = (Periode) currDate.get(0);
				   currStartDate = Formater.formatDate(per.getTglAwal(),"MMMM dd, yyyy");
				   currDueDate = Formater.formatDate(per.getTglAkhir(),"MMMM dd, yyyy");
				   startDate = per.getTglAwal();
				   if(dueDate.compareTo(per.getTglAkhir())>0){
						dueDate = per.getTglAkhir();
				   }				   
				}
				%>
                <tr ID="CONTACT"> 
                  <td width="11%" height="20%"><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td height="20%" width="2%"> : </td>
                  <td height="20%" width="87%">&nbsp;&nbsp; 
                    <select name="<%=SessPayable.payFieldNames[SessPayable.FLD_CONTACT_NAME]%>">
                      <option value="0" selected>All Contact</option>
                    </select>
                  </td>
                </tr>
                <tr ID="DUEDATE"> 
                  <td width="11%" height="80%" valign="top"><%=strTitle[SESS_LANGUAGE][3]%></td>
                  <td height="20%" width="2%" valign="top"> : </td>
                  <td width="87%"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> 
                          <input type="radio" name="<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>" value="0" checked>
                          <%=strTitle[SESS_LANGUAGE][4]%><%=currStartDate+"&nbsp;&nbsp;"+strTitle[SESS_LANGUAGE][8]+"&nbsp;&nbsp;"+currDueDate%><%=strTitle[SESS_LANGUAGE][5]%></td>
                      </tr>
                      <tr> 
                        <td> 
                          <input type="radio" name="<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>" value="1" >
                          <%=strTitle[SESS_LANGUAGE][6]%></td>
                      </tr>
                      <tr> 
                        <td> 
                          <input type="radio" name="<%=SessPayable.payFieldNames[SessPayable.FLD_DATE_TYPE]%>" value="2" >
                          <%=strTitle[SESS_LANGUAGE][7]%><%=ControlDate.drawDate(SessPayable.payFieldNames[SessPayable.FLD_START_DATE], startDate, 0, interval)%> <%=strTitle[SESS_LANGUAGE][8]%> <%=ControlDate.drawDate(SessPayable.payFieldNames[SessPayable.FLD_END_DATE], dueDate, 0, interval)%></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr ID=AGETYPE> 
                  <td width="11%" height="20%"><%=strTitle[SESS_LANGUAGE][9]%></td>
                  <td height="20%" width="2%"> :</td>
                  <td height="20%" width="87%">&nbsp;&nbsp; 
                    <%
				  	Vector ageKey = new Vector(1,1);
				  	Vector ageValue = new Vector(1,1);
				  	for(int i=0; i<SessPayable.ageingFieldNames[0].length; i++){ 
					   ageKey.add(String.valueOf(i));
					   ageValue.add(SessPayable.ageingFieldNames[SESS_LANGUAGE][i]) ; 
				  	}
				  	%>
                    <%=ControlCombo.draw(SessPayable.payFieldNames[SessPayable.FLD_AGEING],null,null,ageKey,ageValue)%></td>
                </tr>
                <tr ID=PERIODTYPE> 
                  <td width="11%" height="20%"><%=strTitle[SESS_LANGUAGE][10]%></td>
                  <td height="20%" width="2%"> :</td>
                  <td height="20%" width="87%">&nbsp;&nbsp; 
                    <%
				  String order = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
				  Vector vectPeriod = PstPeriode.list(0,0,"",order);
				  Vector vectKey = new Vector(1,1);
				  Vector vectVal = new Vector(1,1);					
				  for(int i=0; i<vectPeriod.size(); i++){ 
					   Periode per = (Periode)vectPeriod.get(i);
					   vectKey.add(""+per.getOID());
					   vectVal.add(per.getNama()) ; 
				  }
				  out.println(ControlCombo.draw(SessPayable.payFieldNames[SessPayable.FLD_PERIODE],null,"",vectKey,vectVal));	  
				  %>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="20%"><%=strTitle[SESS_LANGUAGE][11]%></td>
                  <td height="20%" width="2%"> :</td>
                  <td height="20%" width="87%">&nbsp;&nbsp; 
                    <%try{%>
				  <%
				  Vector vBookTypeKey = new Vector(1,1);
				  Vector vBookTypeVal = new Vector(1,1);				  
				  
				  vBookTypeKey.add(""+PstJurnalUmum.CURRENCY_RUPIAH);				  
				  vBookTypeVal.add(PstJurnalUmum.currencyValue[PstJurnalUmum.CURRENCY_RUPIAH]);

				  out.println(ControlCombo.draw(SessPayable.payFieldNames[SessPayable.FLD_CURRENCY],null,"",vBookTypeKey,vBookTypeVal));
				  %>					
					</td>
                  <%}catch(Exception exc){}%>
                </tr>
                <tr> 
                  <td width="11%" height="20%">&nbsp;</td>
                  <td height="20%" width="2%">&nbsp;</td>
                  <td height="20%" width="87%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="11%" height="20%">&nbsp;</td>
                  <td height="20%" width="2%">&nbsp;</td>
                  <td height="20%" width="87%">&nbsp;&nbsp;&nbsp;<a href="javascript:report()"><span class="command"><%=strReport%></span></a></td>
                </tr>
                <script language="javascript">
					document.all.CONTACT.style.display = "none";			
					document.all.DUEDATE.style.display = "none";
					document.all.AGETYPE.style.display = "none";
					document.all.PERIODTYPE.style.display = "none";																																				
				</script>
              </table> 
			  <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][12]%></i></font></td>
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