<%-- 
    Document   : select_jenis_deposito.jsp
    Created on : Mar 23, 2013, 10:29:43 AM
    Author     : HaddyPuutraa
--%>

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
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*"%>
<%@page import="com.dimata.aiso.entity.masterdata.transaksi.*"%>
<%@page import="com.dimata.aiso.form.masterdata.transaksi.*"%>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER); %>
<%@ include file = "../../main/checkuser.jsp" %>

<!-- Jsp Block -->
<%!
    public static String strTitle[][] = {
	{"Nomor","Jenis Deposito","Min Deposito","Max Deposito","Bunga","Jangka Waktu","PPH","Biaya Admin"},	
	{"Number","Deposits Type","Deposits Min","Deposits Max","Bunga","Jangka Waktu","Provisi","Biaya Admin"}
    };

    public static final String systemTitle[] = {
            "Jenis Deposito","Deposits Type"
    };

    public static final String userTitle[][] = {
        {"Tambah","Edit","Cari"},{"Add","Edit","Search"}	
    };
    
    public static final String errAnggota[] = {
        "Daftar Jenis Deposito Tidak Ditemukan","No Deposits Type List Available"
    };
    
    public String drawListJenisDeposito(int language, Vector objectClass, long oid, int start){
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
	ctrlist.dataFormat(strTitle[language][0],"5%","center","left");
        ctrlist.dataFormat(strTitle[language][1],"20%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"15%","center","left");	
        ctrlist.dataFormat(strTitle[language][4],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][5],"5%","center","left");
        ctrlist.dataFormat(strTitle[language][6],"15%","center", "left");
        ctrlist.dataFormat(strTitle[language][7],"15%","center","left");

        ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	ctrlist.reset();
	int index = -1;
        int nomor = start;
			
        String tgl_lahir = "";				
	for(int i=0; i<objectClass.size(); i++){
            nomor = nomor +1;
            JenisDeposito jenisDeposito = (JenisDeposito)objectClass.get(i);
            if(oid == jenisDeposito.getOID()){
                index = i;
            }
		 
            Vector rowx = new Vector();		 
            rowx.add("<a href=\"javascript:selectJenisDeposito('"+jenisDeposito.getOID()+"','"+jenisDeposito.getNamaJenisDeposito()+"','"+jenisDeposito.getProvisi()+"','"+jenisDeposito.getBunga()+"','"+jenisDeposito.getBiayaAdmin()+"')\">"+nomor+"</a>");
            rowx.add(String.valueOf(jenisDeposito.getNamaJenisDeposito()));		 
            rowx.add(String.valueOf(Formater.formatNumber(jenisDeposito.getMinDeposito(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(jenisDeposito.getMaxDeposito(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(jenisDeposito.getBunga(),"#.##")));
            rowx.add(String.valueOf(jenisDeposito.getJangkaWaktu()));
            rowx.add(String.valueOf(Formater.formatNumber(jenisDeposito.getProvisi(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(jenisDeposito.getBiayaAdmin(),"#.##")));
		 		 
            lstData.add(rowx);
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
    
    long oidJenisDeposito = FRMQueryString.requestLong(request, FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]);              
           
    String formName = FRMQueryString.requestString(request,"formName");                        
            
    /*variable declaration*/
    int recordToGet = 5;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;

    CtrlJenisDeposito ctrlJenisDeposito = new CtrlJenisDeposito(request);
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);

    iErrCode = ctrlJenisDeposito.action(iCommand, oidJenisDeposito);
    FrmJenisDeposito frmJenisDeposito = ctrlJenisDeposito.getForm();
    JenisDeposito jenisDeposito = ctrlJenisDeposito.getJenisDeposito();
   
    msgString = ctrlJenisDeposito.getMessage();
    int commandRefresh = FRMQueryString.requestInt(request, "commandRefresh");
    
    String whereClause = "";
    String order = " " + PstJenisDeposito.fieldNames[PstJenisDeposito.FLD_NAMA_JENIS_DEPOSITO];  
    
    int vectSize = PstJenisDeposito.getCount("");
    if(iCommand!=Command.BACK){  
            start = ctrlJenisDeposito.actionList(iCommand, start,vectSize,recordToGet);
    }else{
            iCommand = Command.LIST;
    }
    Vector listJenisDeposito = PstJenisDeposito.list(start,recordToGet,whereClause, order);
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>KOPERASI - Select Geo Address</title>
        <script language="JavaScript">
            
            function selectJenisDeposito(oid,nama,pph,bunga,biaya){
                self.opener.document.<%=formName%>.<%=FrmDeposito.fieldNames[FrmDeposito.FRM_FLD_ID_JENIS_DEPOSITO]%>.value =oid; 
                self.opener.document.<%=formName%>.<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_NAMA_JENIS_DEPOSITO]%>.value =nama;
                self.opener.document.<%=formName%>.<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_PROVISI]%>.value =pph;
                self.opener.document.<%=formName%>.<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_BUNGA]%>.value =bunga;
                self.opener.document.<%=formName%>.<%=frmJenisDeposito.fieldNames[frmJenisDeposito.FRM_BIAYA_ADMIN]%>.value =biaya;
                self.close();                               
           
            }
            
            function first(){
                document.<%=frmJenisDeposito.getFormName()%>.command.value="<%=Command.FIRST%>";
                document.<%=frmJenisDeposito.getFormName()%>.list_command.value="<%=Command.FIRST%>";
                document.<%=frmJenisDeposito.getFormName()%>.action="select_jenis_deposito.jsp";
                document.<%=frmJenisDeposito.getFormName()%>.submit();
            }
            
            function prev(){
                document.<%=frmJenisDeposito.getFormName()%>.command.value="<%=Command.PREV%>";
                document.<%=frmJenisDeposito.getFormName()%>.list_command.value="<%=Command.PREV%>";
                document.<%=frmJenisDeposito.getFormName()%>.action="select_jenis_deposito.jsp";
                document.<%=frmJenisDeposito.getFormName()%>.submit();
            }

            function next(){
                document.<%=frmJenisDeposito.getFormName()%>.command.value="<%=Command.NEXT%>";
                document.<%=frmJenisDeposito.getFormName()%>.list_command.value="<%=Command.NEXT%>";
                document.<%=frmJenisDeposito.getFormName()%>.action="select_jenis_deposito.jsp";
                document.<%=frmJenisDeposito.getFormName()%>.submit();
            }
            
            function last(){
                document.<%=frmJenisDeposito.getFormName()%>.command.value="<%=Command.LAST%>";
                document.<%=frmJenisDeposito.getFormName()%>.list_command.value="<%=Command.LAST%>";
                document.<%=frmJenisDeposito.getFormName()%>.action="select_jenis_deposito.jsp";
                document.<%=frmJenisDeposito.getFormName()%>.submit();
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
                                                                                <form name="<%=frmJenisDeposito.getFormName()%>" method ="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">                                                                                    
                                                                                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="list_command" value="<%=listCommand%>">
                                                                                    <input type="hidden" name="commandRefresh" value= "0">                                                                                    
                                                                                    <input type="hidden" name="<%=FrmJenisDeposito.fieldNames[FrmJenisDeposito.FRM_ID_JENIS_DEPOSITO]%>" value="<%=oidJenisDeposito%>">  
                                                                                    <input type="hidden" name="formName" value="<%=formName%>"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                        
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" valign="middle" colspan="3">
                                                                                                <%{%>
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                                    <tr>
                                                                                                        <td height="100%">
                                                                                                            <!--search-->
                                                                                                            <!--end search-->
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
                                                                                                            <% if ((listJenisDeposito!=null)&&(listJenisDeposito.size()>0)){ %>
                                                                                                            <%=drawListJenisDeposito(SESS_LANGUAGE,listJenisDeposito,oidJenisDeposito,start)%> 
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
