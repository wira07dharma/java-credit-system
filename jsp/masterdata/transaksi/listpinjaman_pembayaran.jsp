<%-- 
    Document   : listpinjaman_pembayaran
    Created on : Jun 19, 2017, 8:29:19 PM
    Author     : dimata005
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
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.*"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.transaksi.*" %>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.form.masterdata.transaksi.*" %>

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
        {"No","Nama","Rekening","Kelompok","Tanggal Pengajuan","Tanggal Lunas","Jangka Waktu","Jatuh Tempo","Jumlah Pinjaman","Bunga","Denda","Banyak Angsuran","Total Angsuran"},	
	{"No","Name","Account Number","Club","Reg Date","Date Paid","Period","Maturity","Loan Amount","Interest","Pinalty","Many Installments","Installment Amount"},
    };

    public static final String systemTitle[] = {
            "Kredit","Credits"
    };

    public static final String userTitle[] = {
        "Daftar","List"	
    };
    
    public String drawListPinjaman(int language, Vector objectClass, long oid, int start){
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
	ctrlist.dataFormat(strTitle[language][0],"3%","center","left");
        ctrlist.dataFormat(strTitle[language][1],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"12%","center","left");
	//ctrlist.dataFormat(strTitle[language][3],"12%","center","left");	
        ctrlist.dataFormat(strTitle[language][4],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][5],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][6],"15%","center", "left");
        ctrlist.dataFormat(strTitle[language][7],"20%","center","left");
        ctrlist.dataFormat(strTitle[language][8],"15%","center","left");
        ctrlist.dataFormat(strTitle[language][9],"15%","center","left");
        ctrlist.dataFormat(strTitle[language][10],"15%","center","left");
        ctrlist.dataFormat(strTitle[language][11],"10%","center","left");
        ctrlist.dataFormat(strTitle[language][12],"10%","center","left");
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
			
        String tgl_pengajuan = "";
        String tgl_lunas = "";
        String tgl_jatuhTempo = "";		
	for(int i=0; i<objectClass.size(); i++){
            indexNumber = indexNumber + 1;
            Pinjaman pinjaman = (Pinjaman)objectClass.get(i);
            if(oid == pinjaman.getOID()){
                index = i;
            }
            
            Anggota anggota = new Anggota();
            if(pinjaman.getAnggotaId() != 0){
                try{
                    anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
                }catch(Exception e){
                    anggota = new Anggota();
                }
            }
            
            JenisKredit kredit = new JenisKredit();
            if(pinjaman.getTipeKreditId() != 0){
                try{
                    kredit = PstJenisKredit.fetch(pinjaman.getTipeKreditId());
                }catch(Exception e){
                    kredit = new JenisKredit();
                }
            }
            
            /*KelompokKoperasi kelompokKoprasi = new KelompokKoperasi();
            if(pinjaman.getKelompokId() != 0){
                try{
                    kelompokKoprasi = PstKelompokKoperasi.fetchExc(pinjaman.getKelompokId());
                }catch(Exception e){
                    kelompokKoprasi = new KelompokKoperasi();
                }
            }*/
            
            //prtoses mencari total angsuran
            double totalAngsuran = 0.0;
            int banyakAngsuran = 0;
            try{
                totalAngsuran = PstAngsuran.sumAngsuran(pinjaman.getOID());
                banyakAngsuran = PstAngsuran.getCount(""+PstAngsuran.fieldNames[PstAngsuran.FLD_ID_PINJAMAN]+" = "+pinjaman.getOID());
            }catch(Exception e){}
             
            Vector rowx = new Vector();
            rowx.add(String.valueOf(indexNumber));	 
            rowx.add(String.valueOf(anggota.getName()));		 
            rowx.add(String.valueOf(anggota.getNoRekening()));
            //rowx.add(String.valueOf(kelompokKoprasi.getNamaKelompok()));
           
             if (pinjaman.getTanggalPengajuan() != null) {
                try{
                    tgl_pengajuan = Formater.formatDate(pinjaman.getTanggalPengajuan(), "dd, MMM yyyy");
                }catch(Exception e){
                    tgl_pengajuan="";
                }
            }else{tgl_pengajuan="";}
            rowx.add(String.valueOf(tgl_pengajuan));
            
            if (pinjaman.getTanggalLunas() != null) {
                try{
                    tgl_lunas = Formater.formatDate(pinjaman.getTanggalLunas(), "dd, MMM yyyy");
                }catch(Exception e){
                    tgl_lunas="";
                }
            }else{tgl_lunas="";}
            rowx.add(String.valueOf(tgl_lunas));
            
            rowx.add(String.valueOf(pinjaman.getJangkaWaktu()));
            
            if (pinjaman.getJatuhTempo() != null) {
                try{
                    tgl_jatuhTempo = Formater.formatDate(pinjaman.getJatuhTempo(), "dd, MMM yyyy");
                }catch(Exception e){
                    tgl_jatuhTempo="";
                }
            }else{tgl_jatuhTempo="";}
            rowx.add(String.valueOf(tgl_jatuhTempo));
            
            rowx.add(String.valueOf(Formater.formatNumber(pinjaman.getJumlahPinjaman(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(kredit.getBungaMin(),"#.##")));
            rowx.add(String.valueOf(Formater.formatNumber(kredit.getDenda(),"#.##")));
            rowx.add(String.valueOf(banyakAngsuran));
            rowx.add(String.valueOf(Formater.formatNumber(totalAngsuran,"#.##")));
            //rowx.add("Bayar");
            rowx.add(String.valueOf("<center><a class=\"btn-edit btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('"+pinjaman.getOID()+"')\">Bayar</a></center>"));
            //rowx.add(String.valueOf("<center><a class=\"btn-edit btn-sm\" style=\"color:#FFF\" href=\"javascript:cmdEdit('"+education.getOID()+"')\">Edit</a></center>"));
                      
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(pinjaman.getOID()));
	}					
	return ctrlist.drawMe(index);
    }
%>

<% 
    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start"); 
    long pinjamanOID = FRMQueryString.requestLong(request, FrmPinjaman.fieldNames[FrmPinjaman.FRM_PINJAMAN_ID]);
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
    String order = " " + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN];  

    CtrlPinjaman ctrlPinjaman = new CtrlPinjaman(request); 
    FrmPinjaman frmPinjaman = ctrlPinjaman.getForm();
    int vectSize = PstPinjaman.getCount("");            
    
    if(iCommand!=Command.BACK){  
            start = ctrlPinjaman.actionList(iCommand, start,vectSize,recordToGet);
    }else{
            iCommand = Command.LIST;
    }
    Vector listPinjaman = PstPinjaman.list(start,recordToGet,whereClause, order);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        
        <title>Kredit</title>
        
        <script language="javascript">
            <%if(privAdd){%>
            function addNew(){
                document.<%=frmPinjaman.FRM_PINJAMAN%>.<%=frmPinjaman.fieldNames[frmPinjaman.FRM_PINJAMAN_ID]%>.value="0";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.list_command.value="<%=listCommand%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.command.value="<%=Command.ADD%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.action="angsuran_pinjaman.jsp";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.submit();
            }
            <%}%>

            function cmdEdit(oid){
                <%if(privUpdate){%>
                    document.<%=frmPinjaman.FRM_PINJAMAN%>.<%=frmPinjaman.fieldNames[frmPinjaman.FRM_PINJAMAN_ID]%>.value=oid;
                    document.<%=frmPinjaman.FRM_PINJAMAN%>.list_command.value="<%=listCommand%>";
                    document.<%=frmPinjaman.FRM_PINJAMAN%>.command.value="<%=Command.ADD%>";
                    document.<%=frmPinjaman.FRM_PINJAMAN%>.action="angsuran_pinjaman.jsp";
                    document.<%=frmPinjaman.FRM_PINJAMAN%>.submit();
                <%}%>
            }

            function first(){
                document.<%=frmPinjaman.FRM_PINJAMAN%>.command.value="<%=Command.FIRST%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.list_command.value="<%=Command.FIRST%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.action="listpinjaman.jsp";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.submit();
            }
            
            function prev(){
                document.<%=frmPinjaman.FRM_PINJAMAN%>.command.value="<%=Command.PREV%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.list_command.value="<%=Command.PREV%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.action="listpinjaman.jsp";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.submit();
            }

            function next(){
                document.<%=frmPinjaman.FRM_PINJAMAN%>.command.value="<%=Command.NEXT%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.list_command.value="<%=Command.NEXT%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.action="listpinjaman.jsp";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.submit();
            }
            
            function last(){
                document.<%=frmPinjaman.FRM_PINJAMAN%>.command.value="<%=Command.LAST%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.list_command.value="<%=Command.LAST%>";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.action="listpinjaman.jsp";
                document.<%=frmPinjaman.FRM_PINJAMAN%>.submit();
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
                      <form name="<%=frmPinjaman.FRM_PINJAMAN%>" method ="get" action="">
                      <input type="hidden" name="command" value="<%=iCommand%>">
                      <input type="hidden" name="vectSize" value="<%=vectSize%>">
                      <input type="hidden" name="start" value="<%=start%>">
                      <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                      <input type="hidden" name="list_command" value="<%=listCommand%>">
                      <input type="hidden" name="<%=frmPinjaman.fieldNames[frmPinjaman.FRM_PINJAMAN_ID]%>" value="<%=pinjamanOID%>">
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
                                        <%= drawListPinjaman(SESS_LANGUAGE, listPinjaman, pinjamanOID,start)%> 
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
                                                        <td width="10%" class="command">&nbsp;<a href="javascript:addNew()"><%=strAddDeposito%></a> </td>
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