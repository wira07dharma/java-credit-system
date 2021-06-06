<%-- 
    Document   : geo_area_anggota.jsp
    Created on : Mar 7, 2013, 10:29:43 AM
    Author     : HaddyPuutraa
--%>
<%@page import="com.dimata.sedana.form.sumberdana.FrmSumberDana"%>
<%@page import="com.dimata.sedana.form.sumberdana.CtrlSumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.SumberDana"%>
<%@page import="com.dimata.aiso.form.masterdata.transaksi.FrmDeposito"%>
<!-- package java -->
<%@ page language="java" %>

<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.region.*" %>
<%@page import="com.dimata.aiso.form.masterdata.region.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER); %>
<%@ include file = "../../main/checkuser.jsp" %>

<!-- Jsp Block -->
<%!
    public static String strTitle[][] = {
	{"No","Nama","Jenis Sumber Dana","Kode Sumber Dana","Target Pendanaan","Prioritas Penggunaan"},	
	{"No", "Name", "Types of Fund Sources", "Code of Fund Sources", "Funding Target", "Usage Priority"}
    };
    

    public static final String systemTitle[] = {
            "Daftar Sumber Dana","Select Fund Sources"
    };

    public static final String userTitle[][] = {
        {"Tambah","Edit","Cari"},{"Add","Edit","Search"}	
    };
    
    public static final String errAnggota[] = {
        "List Sumber Dana Tidak Ditemukan","No Fund Sources List Available"
    };
    
    public String drawListAnggota(int language, Vector objectClass, long oid){
	String temp = ""; 
	String regdatestr = "";
	
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
        
        //untuk tabel
	ctrlist.dataFormat(strTitle[language][0],"20%","center","left");
        ctrlist.dataFormat(strTitle[language][1],"25%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"12%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"12%","center","left");	
        ctrlist.dataFormat(strTitle[language][4],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][5],"10%","center","left");

	//ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData 	= ctrlist.getLinkData();							
	//ctrlist.setLinkPrefix("javascript:selectAnggota('");
	//ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
			
        String tgl_lahir = "";				
	for(int i=0; i<objectClass.size(); i++){
            SumberDana sumberDana = (SumberDana)objectClass.get(i);
            if(oid == sumberDana.getOID()){
                index = i;
            }
		 
            Vector rowx = new Vector();
            rowx.add(""+(i+1));
            rowx.add("<a href=\"javascript:selectAnggota('"+sumberDana.getOID()+"','"+sumberDana.getJudulSumberDana()+"')\">"+String.valueOf(sumberDana.getJudulSumberDana()) +"</a>");
            rowx.add(String.valueOf(PstSumberDana.jenisSumberDana[sumberDana.getJenisSumberDana()]));		 
            rowx.add(String.valueOf(sumberDana.getKodeSumberDana()));
            rowx.add(String.valueOf(sumberDana.getTargetPendanaan()));
            rowx.add(String.valueOf(sumberDana.getPrioritasPenggunaan()));
            lstData.add(rowx);
            //lstLinkData.add(String.valueOf(anggota.getOID()+ " <input type=\"hidden\" name=\""+FrmAnggota.fieldNames[FrmAnggota.FRM_ID_ANGGOTA] +"\"  value=\""+anggota.getOID()+"\">")); 
            
	}					
	return ctrlist.drawMe(index);
    }
%>


<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int listCommand = FRMQueryString.requestInt(request, "list_command");
    if(listCommand==Command.NONE)
     listCommand = Command.LIST;
    
    long oidAnggota = FRMQueryString.requestLong(request, FrmAnggota.fieldNames[FrmAnggota.FRM_ID_ANGGOTA]);          
    String formName = FRMQueryString.requestString(request,"formName"); 
    String frmFieldIdAnggotaName = FRMQueryString.requestString(request, "frmFieldIdAnggotaName");
            
    /*variable declaration*/
    int recordToGet = 5;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;

    CtrlSumberDana ctrlSumberDana = new CtrlSumberDana(request);
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);

    iErrCode = ctrlSumberDana.action(iCommand, oidAnggota);
    FrmSumberDana frmSumberDana = ctrlSumberDana.getForm();
    SumberDana sumberDana = ctrlSumberDana.getSumberDana();
   
    msgString = ctrlSumberDana.getMessage();
    int commandRefresh = FRMQueryString.requestInt(request, "commandRefresh");
    String whereClause = "";
    String order = PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA];
    //update tanggal 14 Maret
    if(iCommand == Command.SEARCH){
        String noAnggota = FRMQueryString.requestString(request, frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_KODE_SUMBER_DANA]);
        String namaAnggota = FRMQueryString.requestString(request, frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_JUDUL_SUMBER_DANA]);
        if(namaAnggota=="" && noAnggota != ""){
            whereClause = PstSumberDana.fieldNames[PstSumberDana.FLD_KODE_SUMBER_DANA]+" = '"+noAnggota+"'";
        }else if((namaAnggota == "" && noAnggota == "") || (namaAnggota != "" && noAnggota != "")){
            whereClause = " ("+PstSumberDana.fieldNames[PstSumberDana.FLD_KODE_SUMBER_DANA]+" = '"+noAnggota+"' OR "
                      + ""+PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + namaAnggota + "%' )";
        }else{
            whereClause = ""+PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " LIKE '%" + namaAnggota + "%'";
        }
    }else{
        whereClause = "";
    }    
    
    int vectSize = PstSumberDana.getCount(whereClause);            

    if(iCommand!=Command.BACK){  
            start = ctrlSumberDana.actionList(iCommand, start,vectSize,recordToGet);
    }else{
            iCommand = Command.LIST;
    }
    Vector listAnggota = PstSumberDana.list(start,recordToGet,whereClause, order);
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>KOPERASI - Select Geo Address</title>
        <script language="JavaScript">
            
            function selectAnggota(oid,name){
                self.opener.document.<%=formName%>.<%=frmFieldIdAnggotaName%>.value =oid; 
                self.opener.document.<%=formName%>.contact.value =name;
                self.close();    
            }
            
            function cmdUpdateKec(){
                document.<%=frmSumberDana.getFormName()%>.command.value="<%=iCommand%>";
                document.<%=frmSumberDana.getFormName()%>.commandRefresh.value= "1";
                document.<%=frmSumberDana.getFormName()%>.action="select_anggota.jsp";
                document.<%=frmSumberDana.getFormName()%>.submit();
            }
            
            function first(){
                document.<%=frmSumberDana.getFormName()%>.command.value="<%=Command.FIRST%>";
                document.<%=frmSumberDana.getFormName()%>.list_command.value="<%=Command.FIRST%>";
                document.<%=frmSumberDana.getFormName()%>.action="select_anggota.jsp";
                document.<%=frmSumberDana.getFormName()%>.submit();
            }
            
            function prev(){
                document.<%=frmSumberDana.getFormName()%>.command.value="<%=Command.PREV%>";
                document.<%=frmSumberDana.getFormName()%>.list_command.value="<%=Command.PREV%>";
                document.<%=frmSumberDana.getFormName()%>.action="select_anggota.jsp";
                document.<%=frmSumberDana.getFormName()%>.submit();
            }

            function next(){
                document.<%=frmSumberDana.getFormName()%>.command.value="<%=Command.NEXT%>";
                document.<%=frmSumberDana.getFormName()%>.list_command.value="<%=Command.NEXT%>";
                document.<%=frmSumberDana.getFormName()%>.action="select_anggota.jsp";
                document.<%=frmSumberDana.getFormName()%>.submit();
            }
            
            function last(){
                document.<%=frmSumberDana.getFormName()%>.command.value="<%=Command.LAST%>";
                document.<%=frmSumberDana.getFormName()%>.list_command.value="<%=Command.LAST%>";
                document.<%=frmSumberDana.getFormName()%>.action="select_anggota.jsp";
                document.<%=frmSumberDana.getFormName()%>.submit();
            }
            
            function cmdSearchAnggota(){
                var anggota_number = document.<%=frmSumberDana.FRM_NAME_SUMBERDANA%>.<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_KODE_SUMBER_DANA]%>.value;
                var anggota_name = document.<%=frmSumberDana.FRM_NAME_SUMBERDANA %>.<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_JUDUL_SUMBER_DANA]%>.value;
                document.<%=frmSumberDana.getFormName()%>.command.value="<%=Command.SEARCH%>";
                document.<%=frmSumberDana.getFormName()%>.action="select_sumberdana.jsp?anggota_number=" + anggota_number + "&anggota_name=" + anggota_name;
                document.<%=frmSumberDana.getFormName()%>.submit();
            }
        </script>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <!-- #EndEditable --> 
    </head>

    <body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg')">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF">
            <tr>
                <td width="90%" valign="top" align="left">
                    <table width="100%" border="0" cellspacing="3" cellpadding="2">
                        <tr>
                            <td bgcolor="#9BC1FF"  valign="middle" height="15" class="contenttitle">
                                <font color="#FF6600" face="Arial">
                                <!-- #BeginEditable "contenttitle" -->
                                <%=systemTitle[SESS_LANGUAGE]%>&nbsp;
                                <!-- #EndEditable --> 
                               </font>
                            </td>
                        </tr>
                        <tr>
                            <td width="100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0"  bgcolor="#9BC1FF">
                                    <tr>
                                        <td height="20">&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%" height="75%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td class="tablecolor">
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                            <tr>
                                                                <td valign="top">
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                                                        <tr>
                                                                            <td valign="top">
                                                                                <!-- #BeginEditable "content" -->
                                                                                <form name="<%=frmSumberDana.getFormName()%>" method ="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">                                                                                    
                                                                                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="list_command" value="<%=listCommand%>">
                                                                                    <input type="hidden" name="commandRefresh" value= "0">                                                                                    
                                                                                    <input type="hidden" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_SUMBER_DANA_ID]%>" value="<%=oidAnggota%>">  
                                                                                    <input type="hidden" name="formName" value="<%=formName%>"> 
                                                                                    <input type="hidden" name="frmFieldIdAnggotaName" value="<%=frmFieldIdAnggotaName%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                        
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" valign="middle" colspan="3">
                                                                                                <%{%>
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                                    <tr>
                                                                                                        <td height="100%">
                                                                                                            <table border="0" cellspacing="2" cellpadding="2" width="70%">
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <!--no anggota-->
                                                                                                                    <td valign="top" width="25%" height="25"><%=strTitle[SESS_LANGUAGE][0]%></td>
                                                                                                                    <td>
                                                                                                                        <input type="text" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_KODE_SUMBER_DANA] %>" value="<%=sumberDana.getKodeSumberDana()%>" class="formElemen" size="50">
                                                                                                                        * &nbsp;<%= frmSumberDana.getErrorMsg(frmSumberDana.FRM_FIELD_KODE_SUMBER_DANA) %>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <!--nama anggota-->
                                                                                                                    <td valign="top" height="25"><%=strTitle[SESS_LANGUAGE][1]%></td>
                                                                                                                    <td>
                                                                                                                        <input type="text" name="<%=frmSumberDana.fieldNames[frmSumberDana.FRM_FIELD_JUDUL_SUMBER_DANA] %>" value="<%=sumberDana.getJudulSumberDana()%>" class="formElemen" size="50">
                                                                                                                        * &nbsp;<%= frmSumberDana.getErrorMsg(frmSumberDana.FRM_FIELD_JUDUL_SUMBER_DANA) %>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" height="25">&nbsp;</td>
                                                                                                                    <td>
                                                                                                                        &nbsp; <a href="javascript:cmdSearchAnggota()"><%=userTitle[SESS_LANGUAGE][2]%></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top" >
                                                                                                        <td>
                                                                                                            &nbsp; 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr valign="top">
                                                                                                        <td>
                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                                                                                                            <% if ((listAnggota!=null)&&(listAnggota.size()>0)){ %>
                                                                                                              <%=drawListAnggota(SESS_LANGUAGE,listAnggota,oidAnggota)%> 
                                                                                                              <tr> 
                                                                                                                <td colspan="2"> <span class="command"> <%=ctrLine.drawMeListLimit(listCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </span> </td>
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
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top" >
                                                                                                        <td class="command">
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </form>
                                                                                <!-- #EndEditable -->
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="20" bgcolor="#9BC1FF"> 
                                <!-- #BeginEditable "footer" -->
                                <%@ include file = "../../main/footer.jsp" %>
                                <!-- #EndEditable --> 
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #BeginEditable "script" -->
    <script language="JavaScript">
                //var oBody = document.body;
                //var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
    </script>
    <!-- #EndEditable -->
    <!-- #EndTemplate --></html>
