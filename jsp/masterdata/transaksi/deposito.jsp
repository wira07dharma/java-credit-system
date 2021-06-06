<%-- 
    Document   : deposito
    Created on : Mar 18, 2013, 3:33:36 PM
    Author     : HaddyPuutraa
--%>

<%@page language="java" %>

<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package aiso -->
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.transaksi.*" %>
<%@page import="com.dimata.aiso.form.masterdata.transaksi.*"%>

<%@include file="../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privPrint = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
%>

<%!
    public static String strTitle[][] = {
            {"No Anggota",//0
                     "Nama Anggota",//1
                     "Alamat Anggota",//2
                     "Nomor Rekening",//3
                     "Jenis Deposito",//4
                     "Kelompok Anggota",//5
                     "Tanggal",//6
                     "Jumlah Deposito",//7
                     "PPH",//8
                     "Bunga",//9
                     "Biaya Admin"//10
            },
            {"Member ID",//0
                     "Member Name",//1
                     "Member Address",//2
                     "Account Number",//3
                     "Deposits Type",//4
                     "Member Club",//5
                     "Date",//6
                     "Amount of Deposits",//7
                     "Provisi",//8
                     "Interest",//9
                     "Admin Cost"//10
            }
    };

    public static final String systemTitle[] = {
            "Deposito","Deposits"
    };

    public static final String userTitle[] = {
        "Daftar","List"	
    };
    
    public String drawListDeposito(int language, Vector objectClass, long oid){
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
	ctrlist.dataFormat(strTitle[language][0],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][1],"20%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"12%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"12%","center","left");	
        ctrlist.dataFormat(strTitle[language][4],"10%","center","left");
        //ctrlist.dataFormat(strTitle[language][5],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][6],"15%","center", "left");
        ctrlist.dataFormat(strTitle[language][7],"30%","center","left");
        ctrlist.dataFormat(strTitle[language][8],"25%","center","left");
        ctrlist.dataFormat(strTitle[language][9],"25%","center","left");
        ctrlist.dataFormat(strTitle[language][10],"25%","center","left");
        ctrlist.dataFormat("Action","25%","center","left");
        // ctrlist.addHeader("Action","10%");
	ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();							
	//ctrlist.setLinkPrefix("javascript:cmdEdit('");
	//ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
			
        String tgl = "";				
	for(int i=0; i<objectClass.size(); i++){
            Deposito deposito = (Deposito)objectClass.get(i);
            if(oid == deposito.getOID()){
                index = i;
            }
		 
            Vector rowx = new Vector();	
            
            //mengambil data anggota
            Anggota anggota = new Anggota();
            if(deposito.getIdAnggota() != 0){
                try{
                    anggota = PstAnggota.fetchExc(deposito.getIdAnggota());
                }catch(Exception e){
                    anggota = new Anggota();
                }
            }
            
            //mengambil data jenis deposito
            JenisDeposito jenisDeposito = new JenisDeposito();
            if(deposito.getIdJenisDeposito() != 0){
                try{
                    jenisDeposito = PstJenisDeposito.fetchExc(deposito.getIdJenisDeposito());
                }catch(Exception e){
                    jenisDeposito = new JenisDeposito();
                }
            }
            
            //mengambil data kelompok
            KelompokKoperasi kelompokKoperasi = new KelompokKoperasi();
            if(deposito.getIdKelompokKoperasi() != 0){
                try{
                    kelompokKoperasi = PstKelompokKoperasi.fetchExc(deposito.getIdKelompokKoperasi());
                }catch(Exception e){
                    kelompokKoperasi = new KelompokKoperasi();
                }
            }
            
            rowx.add(String.valueOf(anggota.getNoAnggota()));
            rowx.add(String.valueOf(anggota.getName()));		 
            rowx.add(String.valueOf(anggota.getAddressPermanent()));
            rowx.add(String.valueOf(anggota.getNoRekening()));
            rowx.add(String.valueOf(jenisDeposito.getNamaJenisDeposito()));
            //rowx.add(String.valueOf(kelompokKoperasi.getNamaKelompok()));
            if (deposito.getTanggalPengajuanDeposito() != null) {
                try{
                    tgl = Formater.formatDate(deposito.getTanggalPengajuanDeposito(), "dd, MMM yyyy");
                }catch(Exception e){
                    tgl="";
                }
            }else{tgl="";}
            rowx.add(String.valueOf(tgl));
            rowx.add(String.valueOf(Formater.formatNumber(deposito.getJumlahDeposito(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(jenisDeposito.getBunga(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(jenisDeposito.getProvisi(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(jenisDeposito.getBiayaAdmin(),"#.##")));
            rowx.add(String.valueOf("<center><a class=\"btn-edit btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('"+deposito.getOID()+"')\">Edit</a></center>"));     

            lstData.add(rowx);
            //lstLinkData.add(String.valueOf(deposito.getOID()));
	}					
	return ctrlist.drawMe(index);
    }
%>

<% 
    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start"); 
    long depositoOID = FRMQueryString.requestLong(request, FrmDeposito.fieldNames[FrmDeposito.FRM_FLD_ID_DEPOSITO]);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    
    int listCommand = FRMQueryString.requestInt(request, "list_command");
    if(listCommand==Command.NONE)
     listCommand = Command.LIST;

    /* VARIABLE DECLARATION */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);

    String currPageTitle = userTitle[SESS_LANGUAGE];
    String strAddDeposito = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);

    int recordToGet = 10;
    String whereClause = "";
    String order = " " + PstDeposito.fieldNames[PstDeposito.FLD_ID_ANGGOTA];  

    CtrlDeposito ctrlDeposito = new CtrlDeposito(request); 
    FrmDeposito frmDeposito = ctrlDeposito.getForm();
    int vectSize = PstDeposito.getCount("");            
    
    if(iCommand!=Command.BACK){  
            start = ctrlDeposito.actionList(iCommand, start,vectSize,recordToGet);
    }else{
            iCommand = Command.LIST;
    }
    Vector listDeposito = PstDeposito.list(start,recordToGet,whereClause, order);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        
        <title>Request Deposito</title>
        
        <script language="javascript">
            <%if(privAdd){%>
            function addNew(){
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_DEPOSITO]%>.value=0;
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.list_command.value="<%=listCommand%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value="<%=Command.ADD%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action="deposito_edit.jsp";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
            }
            <%}%>

            function cmdEdit(oid){
                <%if(privUpdate){%>
                    document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_DEPOSITO]%>.value=oid;
                    document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.list_command.value="<%=listCommand%>";
                    document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value="<%=Command.EDIT%>";
                    document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action="deposito_edit.jsp";
                    document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
                    
                <%}%>
            }

            function first(){
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value="<%=Command.FIRST%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.list_command.value="<%=Command.FIRST%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action="deposito.jsp";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
            }
            
            function prev(){
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value="<%=Command.PREV%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.list_command.value="<%=Command.PREV%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action="deposito.jsp";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
            }

            function next(){
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value="<%=Command.NEXT%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.list_command.value="<%=Command.NEXT%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action="deposito.jsp";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
            }
            
            function last(){
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.command.value="<%=Command.LAST%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.list_command.value="<%=Command.LAST%>";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.action="deposito.jsp";
                document.<%=frmDeposito.FRM_DEPOSITO_NAME%>.submit();
            }
        </script>
        
    </head>
    <body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
          <tr> 
            <td width="100%" valign="top" align="left" bgcolor="#99CCCC"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
                <tr> 
                  <td height="20" class="contenttitle">
                    <!-- #BeginEditable "contenttitle" -->
                    &nbsp;<%=userTitle[SESS_LANGUAGE]%> &nbsp<%=systemTitle[SESS_LANGUAGE]%>
                    <!-- #EndEditable -->
                  </td>
                </tr>
                <tr> 
                  <td valign="top"><!-- #BeginEditable "content" --> 
                      <form name="<%=frmDeposito.FRM_DEPOSITO_NAME%>" method ="get" action="">
                      <input type="hidden" name="command" value="<%=iCommand%>">
                      <input type="hidden" name="vectSize" value="<%=vectSize%>">
                      <input type="hidden" name="start" value="<%=start%>">
                      <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                      <input type="hidden" name="list_command" value="<%=listCommand%>">
                      <input type="hidden" name="<%=frmDeposito.fieldNames[frmDeposito.FRM_FLD_ID_DEPOSITO]%>" value="<%=depositoOID%>">
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top"> 
                          <td height="8"  colspan="3"> 
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                                <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        <!-- form untuk pencarian berdasarkan no anggota deposito-->
                                        <!--form name="cari" method="get" action="deposito.jsp">
                                            <table border="0" width="95%">
                                                <tr>
                                                    <td height="7" align="left" valign="middle" class="listtitle">Search : 
                                                        <input onFocus="this.select()" name="keyword"  type="text" id="keyword" size="25" maxlength="25">
                                                        <input type="submit" value="cari" bgcolor="#00000">
                                                    </td>
                                                </tr>
                                            </table>
                                        </form-->
                                        <!-- end proses pencarian-->&nbsp;
                                    </td>
                                </tr>

                                <tr align="left" valign="top"> 
                                    <td width="100%" height="22" valign="middle" colspan="3"> 
                                        <%= drawListDeposito(SESS_LANGUAGE, listDeposito, depositoOID)%> 
                                    </td>
                                </tr>
                                <tr align="left" valign="top">
                                    <td height="8" align="left" colspan="3" class="command">
                                        <% 
                                            int cmd = 0;
                                            if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){ 
                                                cmd =iCommand;
                                            }else{
                                                if(iCommand == Command.NONE || prevCommand == Command.NONE){
                                                    cmd = Command.FIRST;
                                                }else{
                                                    cmd =prevCommand;
                                                }
                                            } 
                                        %>
                                        <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> 
                                    </td>
                                </tr>
                                <tr align="left" valign="top">
                                    <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                </tr>
                                <tr align="left" valign="top"> 
                                    <td height="8" align="left" colspan="3" class="command"> 
                                        <span class="command">
                                            <% if (privAdd){%>
                                            <table width="100%">
                                            <tr>
                                                <td>
                                                    <table width="100%">
                                                      <tr>
                                                        <td width="10%" class="command">&nbsp;
                                                            
                                                            <a href="javascript:addNew()"><%=strAddDeposito%></a> 
                                                        
                                                        </td>
                                                      </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            </table>
                                            <%}%>
                                        </span> 
                                    </td>
                                </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
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
              <%@ include file = "../../main/footer.jsp" %>
            </td>
          </tr>
        </table>
    </body>
</html>
