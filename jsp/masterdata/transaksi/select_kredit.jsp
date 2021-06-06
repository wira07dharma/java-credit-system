<%-- 
    Document   : select_kredit
    Created on : Mar 25, 2013, 8:43:53 AM
    Author     : dw1p4
--%>


<!-- package java -->
<%@ page language="java" %>

<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.transaksi.*" %>
<%@page import="com.dimata.aiso.form.masterdata.transaksi.*"%>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER); %>
<%@ include file = "../../main/checkuser.jsp" %>

<!-- Jsp Block -->
<%!
    public static String strTitle[][] = {
	{"Biaya Admin","Min Kredit","Max Kredit","Bunga Min","Bunga Max","Provisi","Denda","Jangka Waktu Min","Jangka Waktu Max","Kegunaan"},	
	{"Admin Cost","Min Credit","Max Credit","Interest Min","Interest Max","Provisi","Penalty","Min Period","Max Period","Usefulness"},
    };

    public static final String systemTitle[] = {
            "Kredit","Credit"
    };

    public static final String userTitle[][] = {
        {"Tambah","Edit","Cari"},{"Add","Edit","Search"}	
    };
    
    public static final String tabTitle[][] = {
        {"Alamat Pribadi","Anggota Keluarga","Wilayah","Pendidikan"},{"Personal Address","Family Member","Region","Education"}
    };
    
    public static final String errAnggota[] = {
        "List Anggota Tidak Ditemukan","No Member List Available"
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
	ctrlist.dataFormat(strTitle[language][0],"5%","center","left");
	ctrlist.dataFormat(strTitle[language][1],"7%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"8%","center","left");	
        ctrlist.dataFormat(strTitle[language][3],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][4],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][5],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][6],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][7],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][8],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][9],"10%","center","left");

        ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	ctrlist.reset();
	int index = -1;
			
        String tgl_min = "";
        String tgl_max = "";				
	for(int i=0; i<objectClass.size(); i++){
            JenisKredit kredit = (JenisKredit)objectClass.get(i);
            if(oid == kredit.getOID()){
                index = i;
            }
		 
            Vector rowx = new Vector();		 
            rowx.add("<a href=\"javascript:selectKredit('"+kredit.getOID()+"','"+kredit.getBiayaAdmin()+"','"+kredit.getBungaMin()+"','"+kredit.getDenda()+"','"+kredit.getNamaKredit()+" ( "+kredit.getJangkaWaktuMin() +" s/d "+kredit.getJangkaWaktuMax()+" ) "+"','"+kredit.getJangkaWaktuMin()+"','"+kredit.getJangkaWaktuMax()+"')\">"+String.valueOf(kredit.getBiayaAdmin()) +"</a>");	 
            rowx.add(String.valueOf(Formater.formatNumber(kredit.getMinKredit(),"#.##")));		 
            rowx.add(String.valueOf(Formater.formatNumber(kredit.getMaxKredit(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(kredit.getBungaMin(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(kredit.getBungaMax(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(kredit.getProvisi(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(kredit.getDenda(),"#.##")));
            
            rowx.add(String.valueOf(kredit.getJangkaWaktuMin()));
            rowx.add(String.valueOf(kredit.getJangkaWaktuMax()));
            rowx.add(String.valueOf(kredit.getKegunaan()));
		 		 
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
    
    long oidKredit = FRMQueryString.requestLong(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TYPE_KREDIT_ID]);              
           
    String formName = FRMQueryString.requestString(request,"formName");                        
            
    /*variable declaration*/
    int recordToGet = 5;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;

    CtrlJenisKredit ctrlKredit = new CtrlJenisKredit(request);
    ControlLine ctrLine = new ControlLine();

    iErrCode = ctrlKredit.action(iCommand, oidKredit);
    FrmJenisKredit frmKredit = ctrlKredit.getForm();
    JenisKredit kredit = ctrlKredit.getKredit();
   
    msgString = ctrlKredit.getMessage();
    int commandRefresh = FRMQueryString.requestInt(request, "commandRefresh");
    
    String whereClause = "";
    String order = " " + PstJenisKredit.fieldNames[PstJenisKredit.FLD_MIN_KREDIT];
    if(iCommand == Command.SEARCH){
        String minKredit = FRMQueryString.requestString(request, FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_MIN_KREDIT]);
        if(minKredit==""){
            whereClause = ""+PstJenisKredit.fieldNames[PstJenisKredit.FLD_MIN_KREDIT]+" = '"+minKredit+"'";
        }
    }else{
        whereClause = "";
    }  
    
    int vectSize = PstJenisKredit.getCount("");
    if(iCommand!=Command.BACK){  
            start = ctrlKredit.actionList(iCommand, start,vectSize,recordToGet);
    }else{
            iCommand = Command.LIST;
    }
    Vector listKredit = PstJenisKredit.list(start,recordToGet,whereClause, order);
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>KOPERASI - Select Anggota</title>
        <script language="JavaScript">
            
            function selectKredit(oid,biaya,bunga,denda,nama,min,max){
                self.opener.document.<%=formName%>.<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TIPE_KREDIT_ID]%>.value =oid; 
                self.opener.document.<%=formName%>.<%=frmKredit.fieldNames[frmKredit.FRM_BIAYA_ADMIN]%>.value =biaya;
                self.opener.document.<%=formName%>.<%=frmKredit.fieldNames[frmKredit.FRM_BUNGA_MIN]%>.value =bunga;
                self.opener.document.<%=formName%>.<%=frmKredit.fieldNames[frmKredit.FRM_DENDA]%>.value =denda;
                self.opener.document.<%=formName%>.FRM_TIPE_KREDIT_NAME.value =nama;
                self.close();                               
           
            }
            
            function cmdUpdateKec(){
                document.<%=frmKredit.getFormName()%>.command.value="<%=iCommand%>";
                document.<%=frmKredit.getFormName()%>.commandRefresh.value= "1";
                document.<%=frmKredit.getFormName()%>.action="select_kredit.jsp";
                document.<%=frmKredit.getFormName()%>.submit();
            }
            
            function first(){
                document.<%=frmKredit.getFormName()%>.command.value="<%=Command.FIRST%>";
                document.<%=frmKredit.getFormName()%>.list_command.value="<%=Command.FIRST%>";
                document.<%=frmKredit.getFormName()%>.action="select_kredit.jsp";
                document.<%=frmKredit.getFormName()%>.submit();
            }
            
            function prev(){
                document.<%=frmKredit.getFormName()%>.command.value="<%=Command.PREV%>";
                document.<%=frmKredit.getFormName()%>.list_command.value="<%=Command.PREV%>";
                document.<%=frmKredit.getFormName()%>.action="select_kredit.jsp";
                document.<%=frmKredit.getFormName()%>.submit();
            }

            function next(){
                document.<%=frmKredit.getFormName()%>.command.value="<%=Command.NEXT%>";
                document.<%=frmKredit.getFormName()%>.list_command.value="<%=Command.NEXT%>";
                document.<%=frmKredit.getFormName()%>.action="select_kredit.jsp";
                document.<%=frmKredit.getFormName()%>.submit();
            }
            
            function last(){
                document.<%=frmKredit.getFormName()%>.command.value="<%=Command.LAST%>";
                document.<%=frmKredit.getFormName()%>.list_command.value="<%=Command.LAST%>";
                document.<%=frmKredit.getFormName()%>.action="select_kredit.jsp";
                document.<%=frmKredit.getFormName()%>.submit();
            }
            
            function cmdSearchAnggota(){
                anggota_number = document.<%=frmKredit.getFormName()%>.<%=frmKredit.fieldNames[frmKredit.FRM_MIN_KREDIT]%>.value;
                document.<%=frmKredit.getFormName()%>.command.value="<%=Command.SEARCH%>";
                document.<%=frmKredit.getFormName()%>.action="select_kredit.jsp?anggota_number=" + anggota_number;
                document.<%=frmKredit.getFormName()%>.submit();
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
                                <%
                                    if(oidKredit != 0){
                                        out.print(userTitle[SESS_LANGUAGE][1]);
                                    } else{
                                        out.print(userTitle[SESS_LANGUAGE][0]);
                                    }
                                %><font color="000000"><strong>&nbsp;>> </strong></font><%=tabTitle[SESS_LANGUAGE][0]%>
                                <!-- #EndEditable --> 
                               </font>
                            </td>
                        </tr>
                        <tr>
                            <td width="100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0"  bgcolor="#9BC1FF">
                                    <tr>
                                        <td height="20">
                                            <font color="#FF6600" face="Arial"><strong>
                                                    Select Geo 
                                                </strong></font>
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
                                                                                <form name="<%=frmKredit.getFormName()%>" method ="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">                                                                                    
                                                                                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="list_command" value="<%=listCommand%>">
                                                                                    <input type="hidden" name="commandRefresh" value= "0">                                                                                    
                                                                                    <input type="hidden" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TYPE_KREDIT_ID]%>" value="<%=oidKredit%>">  
                                                                                    <input type="hidden" name="formName" value="<%=formName%>"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                        
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" valign="middle" colspan="3">
                                                                                                <%{%>
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                                    <tr>
                                                                                                        <td height="100%">
                                                                                                            <table border="0" cellspacing="2" cellpadding="2" width="70%">
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" width="25%" height="25">No Anggota</td>
                                                                                                                    <td>
                                                                                                                        <input type="text" name="<%=frmKredit.fieldNames[frmKredit.FRM_MIN_KREDIT] %>" value="<%=kredit.getMinKredit()%>" class="formElemen" size="50">
                                                                                                                        * &nbsp;<%= frmKredit.getErrorMsg(frmKredit.FRM_MIN_KREDIT) %>
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
                                                                                                            <% if ((listKredit!=null)&&(listKredit.size()>0)){ %>
                                                                                                              <%=drawListAnggota(SESS_LANGUAGE,listKredit,oidKredit)%> 
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
