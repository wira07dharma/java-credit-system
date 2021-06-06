<%-- 
    Document   : jenis_kredit
    Created on : Mar 23, 2013, 4:50:54 PM
    Author     : HaddyPuutraa
--%>

<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package region -->
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*" %>

<%@include file="../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE); %>
<%@ include file = "../../main/checkuser.jsp" %>

<!DOCTYPE html>
<% 
    boolean privView= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd=true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate=true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete=true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
    
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
<%! 
    public static String strTitle[][] = {
	{"Nomor","Jenis Deposito","Min Deposito","Max Deposits","Bunga","Jangka Waktu","Provisi","Biaya Admin","Kegunaan"},	
	{"Number","Deposits Type","Deposits Min","Deposits Max","Interest","Jangka Waktu","Provisi","Admin Cost","Usefulness"}
    };

    public static final String systemTitle[] = {
	"Deposito","Deposits"	
    };

    public static final String userTitle[] = {
	"Daftar","List"	
    };
    
    public String drawListDeposito(int language, Vector objectClass, long oid, int start){
	String temp = ""; 
	String regdatestr = "";
	
	ControlList ctrlist = new ControlList();
	ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
	
        //untuk tabel
	ctrlist.dataFormat(strTitle[language][0],"5%","center","left");
        ctrlist.dataFormat(strTitle[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"7%","center","right");
	ctrlist.dataFormat(strTitle[language][3],"8%","center","right");	
        ctrlist.dataFormat(strTitle[language][4],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][5],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][6],"10%","center", "right");
        ctrlist.dataFormat(strTitle[language][7],"10%","center","right");
        ctrlist.dataFormat(strTitle[language][8],"10%","center","left");
        ctrlist.dataFormat("Action","10%","center","left");

	//ctrlist.setLinkRow(0);
        //ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData 	= ctrlist.getLinkData();							
	//ctrlist.setLinkPrefix("javascript:cmdEdit('");
	//ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
        int indexNumber = start;
						
	for(int i=0; i<objectClass.size(); i++){
            indexNumber = indexNumber + 1;
            JenisDeposito jenisDeposito = (JenisDeposito)objectClass.get(i);
            if(oid == jenisDeposito.getOID()){
                index = i;
            }
            
            Vector rowx = new Vector();
            rowx.add(String.valueOf(indexNumber));
            rowx.add(String.valueOf(jenisDeposito.getNamaJenisDeposito())); 
            
            rowx.add(String.valueOf(FRMHandler.userFormatStringDecimal(jenisDeposito.getMinDeposito())));
            rowx.add(String.valueOf(FRMHandler.userFormatStringDecimal(jenisDeposito.getMaxDeposito())));
            rowx.add(String.valueOf(FRMHandler.userFormatStringDecimal(jenisDeposito.getBunga())));
            rowx.add(String.valueOf(jenisDeposito.getJangkaWaktu()));
            rowx.add(String.valueOf(FRMHandler.userFormatStringDecimal(jenisDeposito.getProvisi())));
            rowx.add(String.valueOf(FRMHandler.userFormatStringDecimal(jenisDeposito.getBiayaAdmin())));
            rowx.add(String.valueOf(jenisDeposito.getKeterangan()));
            rowx.add(String.valueOf("<center><a class=\"btn-edit btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('"+jenisDeposito.getOID()+"')\">Edit</a></center>")); 		 		 
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(jenisDeposito.getOID()));
	}					
	return ctrlist.drawMe(index);
    }
%>

<% 
    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start"); 
    long jenisDepositoOID = FRMQueryString.requestLong(request,FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]);
    int listCommand = FRMQueryString.requestInt(request, "list_command");
    if(listCommand==Command.NONE)
     listCommand = Command.LIST;

    /* VARIABLE DECLARATION */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);

    String currPageTitle = userTitle[SESS_LANGUAGE];
    String strAddDeposito = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);

    int recordToGet = 10;
    String order = " " + PstJenisDeposito.fieldNames[PstJenisDeposito.FLD_NAMA_JENIS_DEPOSITO];

    CtrlJenisDeposito ctrlJenisDeposito= new CtrlJenisDeposito(request); 
    int vectSize = PstJenisDeposito.getCount("");            

    if(iCommand!=Command.BACK){  
            start = ctrlJenisDeposito.actionList(iCommand, start, vectSize, recordToGet);
    }else{
            iCommand = Command.LIST;
    }
    Vector listJenisDeposito = PstJenisDeposito.list(start,recordToGet, "" , order);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        
        <title>Jenis Deposito List</title>
        
        <script language="JavaScript">
<%if(privAdd){%>
function addNew(){
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>.value="0";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.list_command.value="<%=listCommand%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.ADD%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito_edit.jsp";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
}
<%}%>
 
function cmdEdit(oid){
	<%if(privUpdate){%>
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>.value=oid;
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.list_command.value="<%=listCommand%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito_edit.jsp";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
	<%}%>
}

function first(){
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.list_command.value="<%=Command.FIRST%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito.jsp";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
}
function prev(){
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.PREV%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.list_command.value="<%=Command.PREV%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito.jsp";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
}

function next(){
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.list_command.value="<%=Command.NEXT%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito.jsp";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
}
function last(){
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.command.value="<%=Command.LAST%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.list_command.value="<%=Command.LAST%>";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.action="jenis_deposito.jsp";
	document.<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>.submit();
}

</script>
        
    </head>
    <body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
            <tr>
                <td width="91%" valign="top" align="left" bgcolor="#99CCCC">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
                        <tr>
                            <td height="20" class="contenttitle" >&nbsp;
                                <!-- #BeginEditable "contenttitle" -->
                                <b><%=systemTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=userTitle[SESS_LANGUAGE].toUpperCase()%></font></b>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                        <tr>
                            <td valign="top"><!-- #BeginEditable "content" --> 
                                <table width="100%">
                                    <tr>
                                        <td>
                                <form name="<%=FrmJenisDeposito.FRM_JENIS_DEPOSITO_NAME%>" method="get" action="">
                                  <input type="hidden" name="command" value="">
                                  <input type="hidden" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>" value="<%=jenisDepositoOID%>">
                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                  <input type="hidden" name="start" value="<%=start%>">
                                  <input type="hidden" name="list_command" value="<%=listCommand%>">
                                  <table width="100%" cellspacing="0" cellpadding="0">

                                  </table>
                                  <% if ((listJenisDeposito!=null)&&(listJenisDeposito.size()>0)){ %>
                                  <%=drawListDeposito(SESS_LANGUAGE,listJenisDeposito,jenisDepositoOID, start)%>
                                  <%}%>
                                  <table width="100%">
                                    <tr> 
                                      <td colspan="2"> <span class="command"> <%=ctrLine.drawMeListLimit(listCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </span> </td>
                                    </tr>
                                    <% if (privAdd){%>				
                                    <tr valign="middle"> 
                                        <td colspan="2" class="command">&nbsp;<a href="javascript:addNew()" class="btn-save btn-lg"><%=strAddDeposito%></a> </td>
                                    </tr>
                                    <%}%>
                                  </table>
                                </form>
                                <!-- #EndEditable -->
                                        </td>
                                    </tr>
                                </table>
                            </td>
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
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" height="20" class="footer"> 
                    <%@include file="../../main/footer.jsp" %>
                </td>
            </tr>
        </table>
    </body>
</html>
<%}%>
