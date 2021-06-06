<%-- 
    Document   : select_jenis_simpanan.jsp
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
	{"Nomor","Jenis Simpanan","Setoran Min","Bunga","PPH","Biaya Admin","Keterangan"},	
	{"Number","Saving Type","Min Setoran","Bunga","Provisi","Biaya Admin","Description"}
    };

    public static final String systemTitle[] = {
            "Jenis Simpanan","Saving Type"
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
    
    public String drawListJenisSimpanan(int language, Vector objectClass, long oid, int start){
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
	ctrlist.dataFormat(strTitle[language][0],"2%","center","left");
        ctrlist.dataFormat(strTitle[language][1],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"15%","center","left");	
        ctrlist.dataFormat(strTitle[language][4],"15%","center","left");
        ctrlist.dataFormat(strTitle[language][5],"15%","center","left");
        ctrlist.dataFormat(strTitle[language][6],"15%","center","left");

	//ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData 	= ctrlist.getLinkData();							
	//ctrlist.setLinkPrefix("javascript:selectAnggota('");
	//ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
        int nomor = start;
			
        String tgl_lahir = "";				
	for(int i=0; i<objectClass.size(); i++){
            nomor = nomor +1;
            JenisSimpanan jenisSimpanan = (JenisSimpanan)objectClass.get(i);
            if(oid == jenisSimpanan.getOID()){
                index = i;
            }
		 
            Vector rowx = new Vector();		 
            rowx.add("<a href=\"javascript:selectJenisSimpanan('"+jenisSimpanan.getOID()+"','"+jenisSimpanan.getNamaSimpanan()+"','"+jenisSimpanan.getProvisi()+"','"+jenisSimpanan.getBunga()+"','"+jenisSimpanan.getBiayaAdmin()+"')\">"+nomor+"</a>");
            rowx.add(String.valueOf(jenisSimpanan.getNamaSimpanan()));		 
            rowx.add(String.valueOf(jenisSimpanan.getSetoranMin()));
            rowx.add(String.valueOf(jenisSimpanan.getBunga()));
            rowx.add(String.valueOf(jenisSimpanan.getProvisi()));
            rowx.add(String.valueOf(jenisSimpanan.getBiayaAdmin()));
            rowx.add(String.valueOf(jenisSimpanan.getDescJenisSimpanan()));
		 		 
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
    
    long oidJenisSimpanan = FRMQueryString.requestLong(request, FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_ID_JENIS_SIMPANAN]);              
           
    String formName = FRMQueryString.requestString(request,"formName");                        
            
    /*variable declaration*/
    int recordToGet = 5;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;

    CtrlJenisSimpanan ctrlJenisSimpanan = new CtrlJenisSimpanan(request);
    ControlLine ctrLine = new ControlLine();

    iErrCode = ctrlJenisSimpanan.action(iCommand, oidJenisSimpanan);
    FrmJenisSimpanan frmJenisSimpanan = ctrlJenisSimpanan.getForm();
    JenisSimpanan jenisSimpanan = ctrlJenisSimpanan.getJenisSimpanan();
   
    msgString = ctrlJenisSimpanan.getMessage();
    int commandRefresh = FRMQueryString.requestInt(request, "commandRefresh");
    
    String whereClause = "";
    String order = " " + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN];   
    
    int vectSize = PstJenisSimpanan.getCount("");
    if(iCommand!=Command.BACK){  
            start = ctrlJenisSimpanan.actionList(iCommand, start,vectSize,recordToGet);
    }else{
            iCommand = Command.LIST;
    }
    Vector listJenisSimpanan = PstJenisSimpanan.list(start,recordToGet,whereClause, order);
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>KOPERASI - Select Geo Address</title>
        <script language="JavaScript">
            
            function selectJenisSimpanan(oid,nama,pph,bunga,biaya){
                self.opener.document.<%=formName%>.<%=FrmDataTabungan.fieldNames[FrmDataTabungan.FRM_FIELD_ID_JENIS_SIMPANAN]%>.value =oid; 
                self.opener.document.<%=formName%>.<%=frmJenisSimpanan.fieldNames[frmJenisSimpanan.FRM_FIELD_NAMA_SIMPANAN]%>.value =nama;
                self.opener.document.<%=formName%>.<%=frmJenisSimpanan.fieldNames[frmJenisSimpanan.FRM_FIELD_PROVISI]%>.value =pph;
                self.opener.document.<%=formName%>.<%=frmJenisSimpanan.fieldNames[frmJenisSimpanan.FRM_FIELD_BUNGA]%>.value =bunga;
                self.opener.document.<%=formName%>.<%=frmJenisSimpanan.fieldNames[frmJenisSimpanan.FRM_FIELD_BIAYA_ADMIN]%>.value =biaya;
                
                self.close();                               
           
            }
            
            function first(){
                document.<%=frmJenisSimpanan.getFormName()%>.command.value="<%=Command.FIRST%>";
                document.<%=frmJenisSimpanan.getFormName()%>.list_command.value="<%=Command.FIRST%>";
                document.<%=frmJenisSimpanan.getFormName()%>.action="select_jenis_simpanan.jsp";
                document.<%=frmJenisSimpanan.getFormName()%>.submit();
            }
            
            function prev(){
                document.<%=frmJenisSimpanan.getFormName()%>.command.value="<%=Command.PREV%>";
                document.<%=frmJenisSimpanan.getFormName()%>.list_command.value="<%=Command.PREV%>";
                document.<%=frmJenisSimpanan.getFormName()%>.action="select_jenis_simpanan.jsp";
                document.<%=frmJenisSimpanan.getFormName()%>.submit();
            }

            function next(){
                document.<%=frmJenisSimpanan.getFormName()%>.command.value="<%=Command.NEXT%>";
                document.<%=frmJenisSimpanan.getFormName()%>.list_command.value="<%=Command.NEXT%>";
                document.<%=frmJenisSimpanan.getFormName()%>.action="select_jenis_simpanan.jsp";
                document.<%=frmJenisSimpanan.getFormName()%>.submit();
            }
            
            function last(){
                document.<%=frmJenisSimpanan.getFormName()%>.command.value="<%=Command.LAST%>";
                document.<%=frmJenisSimpanan.getFormName()%>.list_command.value="<%=Command.LAST%>";
                document.<%=frmJenisSimpanan.getFormName()%>.action="select_jenis_simpanan.jsp";
                document.<%=frmJenisSimpanan.getFormName()%>.submit();
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
                                    if(oidJenisSimpanan != 0){
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
                                                                                <form name="<%=frmJenisSimpanan.getFormName()%>" method ="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">                                                                                    
                                                                                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="list_command" value="<%=listCommand%>">
                                                                                    <input type="hidden" name="commandRefresh" value= "0">                                                                                    
                                                                                    <input type="hidden" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_ID_JENIS_SIMPANAN]%>" value="<%=oidJenisSimpanan%>">  
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
                                                                                                            <% if ((listJenisSimpanan!=null)&&(listJenisSimpanan.size()>0)){ %>
                                                                                                            <%=drawListJenisSimpanan(SESS_LANGUAGE,listJenisSimpanan,oidJenisSimpanan,start)%>  
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
