<%-- 
    Document   : anggota_list
    Created on : Feb 21, 2013, 4:25:19 PM
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

<!--package anggota -->
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*"%>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>

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
	{"No Anggota","Nama","Tempat Lahir","Tanggal Lahir","Telepon","HandPhone","Email","Alamat Asal"},	
	{"Member ID","Name","Birth Place","Birth Date","Phone","HandPhone","Email","Address"}
    };

    public static final String systemTitle[] = {
	"Anggota","Member"	
    };

    public static final String userTitle[] = {
	"Daftar","List"	
    };
    
    public static final String errAnggota[] = {
        "List Anggota Tidak Ditemukan","No Member List Available"
    };
    
    public String drawListAnggota(int language, Vector objectClass, long oid){
	String temp = ""; 
	String regdatestr = "";
	
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
        
        //untuk tabel
	ctrlist.dataFormat(strTitle[language][0],"20%","center","left");
        ctrlist.dataFormat(strTitle[language][1],"25%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"12%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"12%","center","left");	
        ctrlist.dataFormat(strTitle[language][4],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][5],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][6], "25%","center", "left");
        ctrlist.dataFormat(strTitle[language][7],"25%","center","left");
        ctrlist.dataFormat("Action","10%","center","left");

	//ctrlist.setLinkRow(0);
        //ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData 	= ctrlist.getLinkData();							
	//ctrlist.setLinkPrefix("javascript:cmdEdit('");
	//ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
			
        String tgl_lahir = "";				
	for(int i=0; i<objectClass.size(); i++){
            Anggota anggota = (Anggota)objectClass.get(i);
            if(oid == anggota.getOID()){
                index = i;
            }
		 
            Vector rowx = new Vector();		 
            rowx.add(String.valueOf(anggota.getNoAnggota()));
            rowx.add(String.valueOf(anggota.getName()));		 
            rowx.add(String.valueOf(anggota.getBirthPlace()));
            if (anggota.getBirthDate() != null) {
                try{
                    tgl_lahir = Formater.formatDate(anggota.getBirthDate(), "dd, MMM yyyy");
                }catch(Exception e){
                    tgl_lahir="";
                }
            }else{tgl_lahir="";}
            rowx.add(String.valueOf(tgl_lahir));
            rowx.add(String.valueOf(anggota.getTelepon()));
            rowx.add(String.valueOf(anggota.getHandPhone()));
            rowx.add(String.valueOf(anggota.getEmail()));
            rowx.add(String.valueOf(anggota.getAddressPermanent()));
		 		 
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(anggota.getOID()));
	}					
	return ctrlist.drawMe(index);
    }
%>

<% 
    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start"); 
    long anggotaOID = FRMQueryString.requestLong(request,"anggota_oid");
    int listCommand = FRMQueryString.requestInt(request, "list_command");
    if(listCommand==Command.NONE)
     listCommand = Command.LIST;

    /* VARIABLE DECLARATION */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);

    String currPageTitle = userTitle[SESS_LANGUAGE];
    String strAddAnggota = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
    String strSearchAnggota = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK_SEARCH,true);

    int recordToGet = 20;
    String whereClause = "";
    String order = " " + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA];
    //update tanggal 14 Maret
    if(iCommand == Command.SEARCH){
        String noAnggota = FRMQueryString.requestString(request, FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]);
        String namaAnggota = FRMQueryString.requestString(request, FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]);
        if(namaAnggota=="" && noAnggota != ""){
            whereClause = ""+PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA]+" = '"+noAnggota+"'";
        }else if((namaAnggota == "" && noAnggota == "") || (namaAnggota != "" && noAnggota != "")){
            whereClause = ""+PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA]+" = '"+noAnggota+"' OR "
                      + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + namaAnggota + "%'";
        }else{
            whereClause = PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + namaAnggota + "%'";
        }
    }else{
        whereClause = "";
    }    

    CtrlAnggota ctrlAnggota= new CtrlAnggota(request); 
    int vectSize = PstAnggota.getCount(whereClause);            

    if(iCommand!=Command.BACK){  
            start = ctrlAnggota.actionList(iCommand, start,vectSize,recordToGet);
    }else{
            iCommand = Command.LIST;
    }
    Vector listAnggota = PstAnggota.list(start,recordToGet,whereClause, order);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        
        <title>Anggota List</title>
        
        <script language="JavaScript">
            <%if(privAdd){%>
            function addNew(){
                document.frmAnggota.anggota_oid.value="0";
                document.frmAnggota.list_command.value="<%=listCommand%>";
                document.frmAnggota.command.value="<%=Command.ADD%>";
                document.frmAnggota.action="anggota_edit.jsp";
                document.frmAnggota.submit();
            }
            <%}%>

            function cmdEdit(oid){
                <%if(privUpdate){%>
                    document.frmAnggota.anggota_oid.value=oid;
                    document.frmAnggota.list_command.value="<%=listCommand%>";
                    document.frmAnggota.command.value="<%=Command.EDIT%>";
                    document.frmAnggota.action="anggota_edit.jsp";
                    document.frmAnggota.submit();
                <%}%>
            }

            function cmdSearch(){
                document.frmAnggota.command.value="<%=Command.NONE%>";
                document.frmAnggota.action="anggota_search.jsp";
                document.frmAnggota.submit();
            }

            function first(){
                document.frmAnggota.command.value="<%=Command.FIRST%>";
                document.frmAnggota.list_command.value="<%=Command.FIRST%>";
                document.frmAnggota.action="anggota_list.jsp";
                document.frmAnggota.submit();
            }
            
            function prev(){
                document.frmAnggota.command.value="<%=Command.PREV%>";
                document.frmAnggota.list_command.value="<%=Command.PREV%>";
                document.frmAnggota.action="anggota_list.jsp";
                document.frmAnggota.submit();
            }

            function next(){
                document.frmAnggota.command.value="<%=Command.NEXT%>";
                document.frmAnggota.list_command.value="<%=Command.NEXT%>";
                document.frmAnggota.action="anggota_list.jsp";
                document.frmAnggota.submit();
            }
            
            function last(){
                document.frmAnggota.command.value="<%=Command.LAST%>";
                document.frmAnggota.list_command.value="<%=Command.LAST%>";
                document.frmAnggota.action="anggota_list.jsp";
                document.frmAnggota.submit();
            }
        </script>   
    </head>
    
    <body class="bodystyle" leftmargin="0" topmargin="1" marginwidth="0" marginheight="0">
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
                                <form name="frmAnggota" method="get" action="">
                                  <input type="hidden" name="command" value="">
                                  <input type="hidden" name="anggota_oid" value="<%=anggotaOID%>">
                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                  <input type="hidden" name="start" value="<%=start%>">
                                  <input type="hidden" name="list_command" value="<%=listCommand%>">
                                  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                      <tr align="left" valign="top"> 
                                          <td height="8"  colspan="3">
                                              <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                                                  <tr align="left" valign="top"> 
                                                      <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                  </tr>
                                                <% if ((listAnggota!=null)&&(listAnggota.size()>0)){ %>
                                                  <tr> 
                                                    <td colspan="2"> 
                                                        <%=drawListAnggota(SESS_LANGUAGE,listAnggota,anggotaOID)%>
                                                        <span class="command"> <%=ctrLine.drawMeListLimit(listCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </span> </td>
                                                  </tr>
                                                <%}else{%>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" align="middle">
                                                            <font color="#FF6600">&nbsp;<%=errAnggota[SESS_LANGUAGE]%>...</font>
                                                        </td>
                                                    </tr>
                                                    <tr height="30">
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                <%}%>
                                                  <% if (privAdd){%>
                                                  <tr>
                                                      <td>
                                                          <table width="100%" >
                                                            <tr>
                                                              <td width="15%" class="command">&nbsp;<a href="javascript:addNew()"><%=strAddAnggota%></a> </td>
                                                              <td class="command">&nbsp;<a href="javascript:cmdSearch()"><%=strSearchAnggota%></a> </td>
                                                            </tr>
                                                          </table>
                                                      </td>
                                                  </tr>
                                                  <%}%>
                                              </table>
                                          </td>
                                      </tr>
                                  </table>
                                </form>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                        <tr>
                            <td height="20"> 
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
