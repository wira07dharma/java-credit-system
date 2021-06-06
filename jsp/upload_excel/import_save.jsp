<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<%@ page import="com.dimata.util.blob.TextLoader,
				 java.io.FileOutputStream,
				 java.io.ByteArrayInputStream,
				 com.dimata.util.Formater,
				 java.io.InputStream,
				 org.apache.poi.hssf.usermodel.HSSFDateUtil,
				 com.dimata.util.Excel,
				 com.dimata.util.Formater,
				 com.dimata.qdep.form.FRMQueryString,
				 com.dimata.util.Command,
				 com.dimata.interfaces.chartofaccount.I_ChartOfAccountGroup,
				 com.dimata.harisma.entity.masterdata.*,
				 com.dimata.aiso.entity.masterdata.*"%>
<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_PERIOD, AppObjInfo.G2_PERIOD_CLOSE_BOOK, AppObjInfo.OBJ_PERIOD_CLOSE_BOOK); %>
<%@ include file = "../main/checkuser.jsp" %>
<!-- %@ include file = "import_process.jsp" % -->
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
<%!
String strLanguage = "";

/* this constant used to list text of listHeader */
public static final String pageTitle[] = {
	"Import Data","Import Data"	
};

private static Hashtable getAccGroup(int language){
	Hashtable hashListAccGroup = new Hashtable();
		try{
			for(int i = 0; i < I_ChartOfAccountGroup.arrAccountGroupNames[language].length; i++){
				hashListAccGroup.put(I_ChartOfAccountGroup.arrAccountGroupNames[language][i].toUpperCase(), String.valueOf(i));
			}
		}catch(Exception e){
			System.out.println("Exception on getAccGroup() ::: "+e.toString());
			e.printStackTrace();
		}
	return hashListAccGroup;
}
%>

<%
// ngambil data dari request form
int iCommand = FRMQueryString.requestCommand(request);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">	
	
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=pageTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmcoa" method="post" action="">
				<input type="hidden" name="command" value="">
					   <%
                        	
							String strIndexFile = "";
							try{
								strIndexFile = (String)session.getValue("INDEX_FILE");
							}catch(Exception e){
								System.out.println("Exception on getIndexFile ::::::::::::: "+e.toString());
							}
							
							int iIndexFile = Integer.parseInt(strIndexFile);
							
							
							boolean transferSuccess = false;
							String strError = "";
					   		switch(iIndexFile){
								case 0 :
									Vector vCoA = new Vector();
									String[] arrDepartment = request.getParameterValues("department");
									String[] arrParentAcc = request.getParameterValues("parent_account");
									String[] arrAccCode = request.getParameterValues("account_code");
									String[] arrAccNameIndo = request.getParameterValues("acc_name_indo");
									String[] arrAccNameEnglish = request.getParameterValues("acc_name_english");
									String[] arrLevel = request.getParameterValues("level");
									String[] arrNormaAssign = request.getParameterValues("normal_assign");
									String[] arrStatus = request.getParameterValues("status");
									String[] arrAccGroup = request.getParameterValues("acc_group");
									
									Hashtable hashDepartment = PstDepartment.getListDepartment();
									Hashtable hAccGroupt = getAccGroup(SESS_LANGUAGE);
									
									transferSuccess = false;
									Perkiraan objCoA = new Perkiraan();
									
									for(int i = 0; i < arrAccCode.length; i++)
									{
										Hashtable hashCoA = PstPerkiraan.getListCoA(SESS_LANGUAGE);
										Perkiraan objAccountParent = (Perkiraan)hashCoA.get(arrParentAcc[i].toUpperCase());
										Department objDepartment = (Department)hashDepartment.get(arrDepartment[i].toUpperCase());								
										int iAccGroup = Integer.parseInt((String)hAccGroupt.get(arrAccGroup[i]));
										
										long lParentId = 0;
										if(objAccountParent != null)
											lParentId = objAccountParent.getOID();
										
										long lDepartmentId = 0;
										if(objDepartment != null)
											lDepartmentId = objDepartment.getOID();
										
										int iLevel = Integer.parseInt(arrLevel[i]);	
										int iDbCrAssign = 0;
										String strNormalAssign = arrNormaAssign[i];
										if(strNormalAssign.equalsIgnoreCase("K"))
											iDbCrAssign = 1;
											
										int iPostable = 0;
										String strStatus = arrStatus[i];
										if(strStatus.equalsIgnoreCase("P"))
											iPostable = 1;
										
											objCoA.setNoPerkiraan(arrAccCode[i]);
											objCoA.setLevel(iLevel);
											objCoA.setNama(arrAccNameIndo[i]);
											objCoA.setTandaDebetKredit(iDbCrAssign);
											objCoA.setPostable(iPostable);
											objCoA.setIdParent(lParentId);
											objCoA.setDepartmentId(lDepartmentId);
											objCoA.setAccountNameEnglish(arrAccNameEnglish[i]);
											objCoA.setWeight(0);
											objCoA.setGeneralAccountLink(0);
											objCoA.setAccountGroup(iAccGroup);
										
										try{
											PstPerkiraan.insertExc(objCoA);
											transferSuccess = true;
										}catch(Exception e){
											System.out.println("Insert error : " + e);
										}//End Try Catch
									}//End for(int i = 0; i < arrAccCode.length; i++)
								break;
								
								case 1 :
									Vector vFixedAssets = new Vector();
									String[] arrCode = request.getParameterValues("code");
									String[] arrName = request.getParameterValues("name");
									String[] arrAssetsType = request.getParameterValues("assets_type");
									String[] arrDepType = request.getParameterValues("dep_type");
									String[] arrDepMethod = request.getParameterValues("dep_method");
									String[] arrDepPeriod = request.getParameterValues("dep_period");
									String[] arrPersenDep = request.getParameterValues("persen_dep");
									String[] arrBasicAmount = request.getParameterValues("basic_amount");
									String[] arrResidueAmount = request.getParameterValues("residue_amount");
									String[] arrAssetsAccount = request.getParameterValues("assets_account");
									String[] arrDepAssetsAccount = request.getParameterValues("dep_assets_account");
									String[] arrAcmDepAcc = request.getParameterValues("acm_dep_acc");
									String[] arrOtherRevenue = request.getParameterValues("other_revenue");
									String[] arrReceiveDate = request.getParameterValues("receive_date");
									String[] arrTotalDep = request.getParameterValues("total_dep");
									String[] arrOtherExpAcc = request.getParameterValues("other_exp_acc");
									String[] arrAssetsGroup = request.getParameterValues("assets_group");
									
									Hashtable hashAssetsType = PstAktiva.getListAssetsType();
									Hashtable hashDepType = PstAktiva.getListDepType();
									Hashtable hashDepMethod = PstAktiva.getListDepMethod();
									Hashtable hashAssetsGroup = PstAktivaGroup.getListGroupAssets();
									Hashtable hashAccount = PstPerkiraan.getListAccAssets(SESS_LANGUAGE);
									
									transferSuccess = false;
									Aktiva objAssetsType = new Aktiva();
									Aktiva objDepType = new Aktiva();
									Aktiva objDepMethod = new Aktiva();
									AktivaGroup objAssetsGroup = new AktivaGroup();
									Perkiraan objFixedAssetsAcc = new Perkiraan();
									Perkiraan objAcmFixedAssetsAcc = new Perkiraan();
									Perkiraan objDepCost = new Perkiraan();
									Perkiraan objOthRevAcc = new Perkiraan();
									Perkiraan objOthExpAcc = new Perkiraan();
									ModulAktiva objAssets = new ModulAktiva();
									Date objDate = null;
									
									for(int i = 0; i < arrCode.length; i++)
									{
										objAssetsType = (Aktiva)hashAssetsType.get(arrAssetsType[i].toUpperCase());
										objDepType = (Aktiva)hashDepType.get(arrDepType[i].toUpperCase());								
										objDepMethod = (Aktiva)hashDepMethod.get(arrDepMethod[i].toUpperCase());		
										objAssetsGroup = (AktivaGroup)hashAssetsGroup.get(arrAssetsGroup[i].toUpperCase());		
										objFixedAssetsAcc = (Perkiraan)hashAccount.get(arrAssetsAccount[i].toUpperCase());
										objAcmFixedAssetsAcc = (Perkiraan)hashAccount.get(arrAcmDepAcc[i].toUpperCase());
										objDepCost = (Perkiraan)hashAccount.get(arrDepAssetsAccount[i].toUpperCase());
										objOthRevAcc = (Perkiraan)hashAccount.get(arrOtherRevenue[i].toUpperCase());
										objOthExpAcc = (Perkiraan)hashAccount.get(arrOtherExpAcc[i].toUpperCase());
										objDate = Formater.formatDate(arrReceiveDate[i],"dd-MM-yyyy");
										String strDate = Formater.formatDate(objDate,"yyyy-MM-dd");
										
										objAssets.setKode(arrCode[i]);
										objAssets.setName(arrName[i]);
										objAssets.setJenisAktivaOid(objAssetsType.getOID());
										objAssets.setTypePenyusutanOid(objDepType.getOID());
										objAssets.setMetodePenyusutanOid(objDepMethod.getOID());
										objAssets.setMasaManfaat(Integer.parseInt(arrDepPeriod[i]));
										objAssets.setPersenPenyusutan(Double.parseDouble(arrPersenDep[i]));
										objAssets.setHargaPerolehan(Double.parseDouble(arrBasicAmount[i]));
										objAssets.setNilaiResidu(Double.parseDouble(arrBasicAmount[i]));
										objAssets.setIdPerkiraanAktiva(objFixedAssetsAcc.getOID());
										objAssets.setIdPerkiraanByaPenyusutan(objDepCost.getOID());
										objAssets.setIdPerkiraanAkmPenyusutan(objAcmFixedAssetsAcc.getOID());
										objAssets.setIdPerkiraanLbPenjAktiva(objOthRevAcc.getOID());
										objAssets.setTglPerolehan(Formater.formatDate(strDate,"yyyy-MM-dd"));
										objAssets.setTotalPenyusutan(Double.parseDouble(arrTotalDep[i]));
										objAssets.setIdPerkiraanRgPenjAktiva(objOthExpAcc.getOID());
										objAssets.setAktivaGroupOid(objAssetsGroup.getOID());										
										
										try{
											PstModulAktiva.insertExc(objAssets);
											transferSuccess = true;
										}catch(Exception e){
											System.out.println("Insert error : " + e);
										}//End Try Catch
									}//End for(int i = 0; i < arrAccCode.length; i++)
								break;
								
							}//End switch
							   if(transferSuccess){
									out.println("Process Success ...");
								}else{
									out.println("<font color=\"#FF0000\">Process Failed ...</font>");
								}
							
					   %>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>