<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.form.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.journal.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>
<!--import java-->
<%@ page import="java.util.Date" %>
<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<%@ page import = "com.dimata.util.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_DEPRECIATION, AppObjInfo.OBJ_REPORT_OTHERS_DEPRECIATION_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>
<%!
String YR = "_yr";
String MN = "_mn";
String DY = "_dy";
String MM = "_mm";
String HH = "_hh";   
%>
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
	{"Tipe Penyusutan","Tipe Laporan","Nama Perkiraan","Kelompok Asset","No Asset","Bulan","Periode","Anda tidak punya hak akses untuk laporan penyusutan aktiva tetap !!!"},	
	{"Depreciation Type","Report Type","Account Name","Asset Group","Asset No","Month","Period","You haven't privilege for accessing fixed asset depreciation report !!!"}
};

public static final String masterTitle[] = {
	"Laporan","Report"	
};

public static final String listTitle[] = {
	"Penyusutan Aktiva Lain","Other Asset Depreciation"	
};
%>

<!-- JSP Block -->
<%
int iCommand = FRMQueryString.requestCommand(request);
long accountId = FRMQueryString.requestLong(request,"account_id");
long assetGroupId = FRMQueryString.requestLong(request,"asset_group_id");

CtrlBpAktivaLain ctrlBpAktivaLain = new CtrlBpAktivaLain(request);
ctrlBpAktivaLain.setLanguage(SESS_LANGUAGE);

AssetGroup assetGrp = new AssetGroup();
if(assetGroupId!=0){
	try{
		assetGrp = PstAssetGroup.fetchExc(assetGroupId);
	}catch(Exception e){
		System.out.println("Err");
	}
}

Vector listCode = SessOtherAsset.getAssetAccount(CtrlAccountLink.TYPE_OTHERASSET);

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
	var type = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_TYPE]%>.value;
	if(type==0){
		document.all.MONTH.style.display = "block";			
		document.all.PERIODE.style.display = "none";
	}
	if(type==1){
		document.all.MONTH.style.display = "none";			
		document.all.PERIODE.style.display = "block";
	}	
}

function report(){ 
	var depType = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_DEP_TYPE]%>.value;
	var type = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_TYPE]%>.value;
	var accountId = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ACC_NAME]%>.value;
	var assetGroup = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.value;
	var assetId = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>.value;
	var typeText = "";
	for(i=0; i<document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_DEP_TYPE]%>.length; i++) {
		if(document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_DEP_TYPE]%>.options[i].selected){
			typeText = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_DEP_TYPE]%>.options[i].text;
		}
	}
	var groupText = "";
	for(i=0; i<document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.length; i++) {
		if(document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.options[i].selected){
			groupText = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.options[i].text;
		}
	}	
					
	if(type==0){
		var year = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_MONTH]+YR%>.value;				
		var month = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_MONTH]+MN%>.value;				
		var linkPage  = "other_depretiation_buffer.jsp?" +
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_DEP_TYPE]%>=" + depType + "&" +				
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_TYPE]%>=" + type + "&" +		
						"DEP_TEXT=" + typeText + "&" + 								
						"GROUP_TEXT=" + groupText + "&" + 
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ACC_NAME]%>=" + accountId + "&" +
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>=" + assetGroup + "&" +
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>=" + assetId + "&" +												
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_MONTH]+MN%>=" + month + "&" +
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_MONTH]+YR%>=" + year;										
		window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no");  					
	}
	if(type==1){
		var period = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_PERIODE]%>.value;				
		var linkPage  = "other_depretiation_buffer.jsp?" +
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_DEP_TYPE]%>=" + depType + "&" +						
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_TYPE]%>=" + type + "&" +
						"DEP_TEXT=" + typeText + "&" + 								
						"GROUP_TEXT=" + groupText + "&" + 
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ACC_NAME]%>=" + accountId + "&" +
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>=" + assetGroup + "&" +
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>=" + assetId + "&" +																		
						"<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_PERIODE]%>=" + period;
		window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no");  					
	}
}

function changeAssetAccount(){
	var accOid = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ACC_NAME]%>.value;
	switch(accOid){
	<%
	if(listCode!=null && listCode.size()>0){
		long accId = 0;		
		for(int i=0; i<listCode.size(); i++){
		Perkiraan acc = (Perkiraan)listCode.get(i);
	%>
		case "<%=acc.getOID()%>" :
			 <%
			 String grpWhere = PstAssetGroup.fieldNames[PstAssetGroup.FLD_ID_PERKIRAAN]+"="+acc.getOID();
			 String grpOrder = PstAssetGroup.fieldNames[PstAssetGroup.FLD_GROUP_CODE];				  			 
			 Vector tempGroup = PstAssetGroup.list(0,0,grpWhere,grpOrder);
			 if(tempGroup!=null && tempGroup.size()>0){
			 %>
			 
				for(var k=document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.length-1; k>-1; k--){
					document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.options.remove(k);
				}

				document.all.ASSGROUP.style.display="block";
				document.all.ASSNO.style.display="none";													 																							 					
				var oOption = document.createElement("OPTION");
				oOption.value = "0";				
				oOption.text = "All Group";
				document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.add(oOption);													 
			 
			 <%
			 	for(int j=0; j<tempGroup.size(); j++){
				AssetGroup assetGroup = (AssetGroup)tempGroup.get(j);
			 %>
			 
				var oOption = document.createElement("OPTION");
				oOption.value = "<%=assetGroup.getOID()%>";				
				oOption.text = "<%=assetGroup.getGroupName()%>";
				document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.add(oOption);													 
				
			 <%
			 	}
			 }else{
			 %>			 
				document.all.ASSGROUP.style.display="none";	
				document.all.ASSNO.style.display="none";													 																						 					
			<%
			}
			%>	
			break;
	<%
		}
	}	
	%>					 	
		
		default :
			for(var k=document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.length-1; k>-1; k--){
				document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.options.remove(k);
			}

			document.all.ASSGROUP.style.display="none";	
			document.all.ASSNO.style.display="none";													 																						 																					 				
	}
}

function changeAssetGroup(){
	var grpOid = document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>.value;
	switch(grpOid){
	<%
	Vector listGroup = PstAssetGroup.list(0,0,"","");	
	if(listGroup!=null && listGroup.size()>0){
		long assId = 0;		
		for(int i=0; i<listGroup.size(); i++){
		AssetGroup assGrp = (AssetGroup)listGroup.get(i);
	%>
		case "<%=assGrp.getOID()%>" :
			 <%
			 String assetWhere = PstBpAktivaTetap.fieldNames[PstBpAktivaTetap.FLD_GROUPID]+"="+assGrp.getOID()+
								  " AND "+PstBpAktivaTetap.fieldNames[PstBpAktivaTetap.FLD_ASSET_STATUS]+
								  "="+PstBpAktivaTetap.ASSETSTATUS_NEWBUY;
			 String assetOrder = PstBpAktivaTetap.fieldNames[PstBpAktivaTetap.FLD_GROUPID]+","+PstBpAktivaTetap.fieldNames[PstBpAktivaTetap.FLD_NOAKTIVA];				  
			 Vector tempAsset = PstBpAktivaTetap.list(0,0,assetWhere,assetOrder);
			 if(tempAsset!=null && tempAsset.size()>0){			 
			 %>	
			 			 
				for(var k=document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>.length-1; k>-1; k--){
					document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>.options.remove(k);
				}

				document.all.ASSNO.style.display="block";													 						
				var oOption = document.createElement("OPTION");
				oOption.value = "0";				
				oOption.text = "All Asset";
				document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>.add(oOption);													 
			 
			 <%
			 	for(int j=0; j<tempAsset.size(); j++){
				BpAktivaTetap bpFixedAsset = (BpAktivaTetap)tempAsset.get(j);
			 %>
			 
				var oOption = document.createElement("OPTION");
				oOption.value = "<%=bpFixedAsset.getOID()%>";				
				oOption.text = "<%=assGrp.getGroupCode()+"-"+SessJurnalUmum.intToStr(bpFixedAsset.getNoAktiva(),3)%>";
				document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>.add(oOption);													 
				
			 <%
			 	}
			 }
			 %>
			 break;				 
	<%	
		}	
	}else{
	%>
		document.all.ASSNO.style.display="none";													 						
	<%
	}
	%>
		default :
			for(var k=document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>.length-1; k>-1; k--){
				document.frmDepretiation.<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>.options.remove(k);
			}	 
			document.all.ASSNO.style.display="none";													 																						 					
	}	
}
</script>
<!-- #EndEditable --> 
<!-- #BeginEditable "headerscript" -->
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

//*****************
function showObjectForMenu(){
	
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
            <form name="frmDepretiation" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">			  			
			  <input type="hidden" name="account_id" value="<%=accountId%>">
              <input type="hidden" name="asset_group_id" value="<%=assetGroupId%>">
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
                  <td colspan="3" height="20%"> 
                    <div align="center"><b></b></div>
                  </td>
                </tr>
                <tr> 
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="88%"> 
                    <%
					Vector vectDepreciationType = ctrlBpAktivaLain.getDepreciationVector();
					Vector depValue = new Vector();
					Vector depKey = new Vector();
					if(vectDepreciationType!=null && vectDepreciationType.size()>0){
						for(int i=vectDepreciationType.size()-1; i>-1; i--){				
							depValue.add(""+i);
							depKey.add((String)vectDepreciationType.get(i));
						}
					}
					out.println(ControlCombo.draw(SessOtherAsset.deFieldNames[SessOtherAsset.FLD_DEP_TYPE],null,null,depValue,depKey));				  
				  %>
                  </td>
                </tr>
                <tr> 
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="88%"> 
                    <%
				  Vector vectorKey = new Vector(1,1);
				  Vector vectorValue = new Vector(1,1);
				  for(int i=0; i<SessOtherAsset.reportFieldNames[0].length; i++){ 
					   vectorKey.add(String.valueOf(i));
					   vectorValue.add(SessOtherAsset.reportFieldNames[SESS_LANGUAGE][i]) ; 
				  }
				  String attrType = "onChange=\"javascript:cmdChange()\"";
				  out.println(ControlCombo.draw(SessOtherAsset.deFieldNames[SessOtherAsset.FLD_TYPE],null,null,vectorKey,vectorValue,attrType));
				  %>
                  </td>
                </tr>
                <%String order = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
				  Vector vectPeriod = PstPeriode.list(0,0,"",order);
					  Vector vectKey = new Vector(1,1);
					  Vector vectVal = new Vector(1,1);					
					  for(int i=0; i<vectPeriod.size(); i++){ 
						   Periode per = (Periode)vectPeriod.get(i);
						   vectKey.add(""+per.getOID());
						   vectVal.add(per.getNama()) ; 
					  }
					  Periode peri = (Periode)vectPeriod.get(vectPeriod.size()-1);
					  String selected = ""+peri.getOID();					  
				%>
                <tr> 
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="88%"> 
                    <%
					Vector accCodeKey = new Vector(1,1);
					Vector accCodeVal = new Vector(1,1);
					String space = "";
					String selectedAcc = ""+accountId;
					String changeAccount = "onChange=\"javascript:changeAssetAccount()\"";
					for(int i=0; i<listCode.size(); i++){  
					   Perkiraan perkiraan = (Perkiraan)listCode.get(i);
					   accCodeKey.add(String.valueOf(perkiraan.getOID()));
					   accCodeVal.add(space+perkiraan.getNama()) ; 
					} 
					out.println(ControlCombo.draw(SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ACC_NAME],"All Account",selectedAcc,accCodeKey,accCodeVal,changeAccount));
				 	%>
                  </td>
                </tr>
                <tr ID=ASSGROUP> 
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][3]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="88%"> 
                    <select name="<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_GROUP]%>" onChange="javascript:changeAssetGroup()">
                    </select>
                  </td>
                </tr>
                <tr ID=ASSNO> 
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][4]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="88%"> 
                    <select name="<%=SessOtherAsset.deFieldNames[SessOtherAsset.FLD_ASSET_NO]%>">
                    </select>
                  </td>
                </tr>
                <tr ID="MONTH"> 
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][5]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="88%"> <%=ControlDate.drawDateMY(SessOtherAsset.deFieldNames[SessOtherAsset.FLD_MONTH], new Date(),"MMM","","","",-1,2)%> </td>
                </tr>
                <tr ID="PERIODE"> 
                  <td width="10%" height="20%"><%=strTitle[SESS_LANGUAGE][6]%></td>
                  <td height="20%" width="2%"> 
                    <div align="center">:</div>
                  </td>
                  <td height="20%" width="88%"><%=ControlCombo.draw(SessOtherAsset.deFieldNames[SessOtherAsset.FLD_PERIODE],null,selected,vectKey,vectVal)%></td>
                </tr>
                <tr> 
                  <td width="10%" height="20%">&nbsp;</td>
                  <td height="20%" width="2%">&nbsp;</td>
                  <td height="20%" width="88%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="10%" height="20%">&nbsp;</td>
                  <td height="20%" width="2%">&nbsp;</td>
                  <td height="20%" width="88%"><a href="javascript:report()"><span class="command"><%=strReport%></span></a></td>
                </tr>
                <script language="javascript">
					document.all.ASSGROUP.style.display="none";													 					
					document.all.ASSNO.style.display="none";													 																		
					document.all.MONTH.style.display = "block";			
					document.all.PERIODE.style.display = "none";
				</script>
              </table>
			  <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][7]%></i></font></td>
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