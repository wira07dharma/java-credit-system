<%--
    Document   : angsuran_pinjaman
    Created on : Mar 29, 2013, 9:50:44 AM
    Author     : HaddyPuutraa
--%>

<%@ page language = "java" %>
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
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.transaksi.*" %>
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
            {"No Anggota",//0
                     "Nama Anggota",//1
                     "Alamat Anggota",//2
                     "Nomor Rekening",//3
                     "Jenis Deposito",//4
                     "Kelompok Anggota",//5
                     "Tanggal",//6
                     "Jumlah Pinjaman",//7
                     "PPH",//8
                     "Bunga",//9
                     "Biaya Admin",//10
                     "Jangka Waktu",//11
                     "Angsuran"//12
            },
            {"Member ID",//0
                     "Member Name",//1
                     "Member Address",//2
                     "Account Number",//3
                     "Deposits Type",//4
                     "Member Club",//5
                     "Date",//6
                     "Amount of Credits",//7
                     "Provisi",//8
                     "Interest",//9
                     "Admin Cost",//10
                     "Period",//11
                     "Installment"//12
            }
    };
    
    public static final String tabTitle[][] = {
               {"Peminjaman","Angsuran"},{"Loan","Installment Payment"}
    };

    public static final String systemTitle[] = {
            "Angsuran","Installment Payment"
    };

    public static final String userTitle[][] = {
        {"Tambah","Edit"},{"Add","Edit"}	
    };
    
    public static final String[][] titleTabel = {
               {"Nomor","Tanggal","Jumlah Angsuran"},{"Number","Date","Jumlah Angsuran"}
    };
    
    public String drawList(int iCommand, FrmAngsuran frmObject, Angsuran objEntity, Vector objectClass,  long angsuranId, int languange, int start, int sisaAngsuran){
 	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("80%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
        
        //create tabel
        ctrlist.addHeader(titleTabel[languange][0],"5%");
	ctrlist.addHeader(titleTabel[languange][1],"25%");
        ctrlist.addHeader(titleTabel[languange][2],"40%");

	//ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);                
	ctrlist.reset();
	int index = -1;
        int number = start;
        
	for (int i = 0; i < objectClass.size(); i++) {
            number = number + 1; 
            Angsuran angsuran = (Angsuran)objectClass.get(i);
            rowx = new Vector();
            if(angsuranId == angsuran.getOID()){
                index = i; 
            }

            if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
                
                rowx.add("<input type=\"hidden\" name=\""+frmObject.fieldNames[frmObject.FRM_FLD_ID_ANGSURAN] +"\" value=\""+angsuranId+"\" class=\"formElemen\">");
                rowx.add(Formater.formatDate(angsuran.getTanggalAngsuran(),"MMM, dd yyyy"));
                rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[frmObject.FRM_FLD_JUMLAH_ANGSURAN] +"\" value=\""+angsuran.getJumlahAngsuran()+"\" class=\"formElemen\" size=\"60\">"); 
			                                                                 
            }else{
		rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(angsuran.getOID())+"')\">"+number+"</a>");
                rowx.add(Formater.formatDate(angsuran.getTanggalAngsuran(),"MMM, dd yyyy"));
		rowx.add(String.valueOf(angsuran.getJumlahAngsuran()));					  
            }                                                       
            lstData.add(rowx); 
		
	}
	rowx = new Vector();

        //untuk membuat form input 
	if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
            rowx.add("<input type=\"hidden\" name=\""+frmObject.fieldNames[frmObject.FRM_FLD_ID_ANGSURAN] +"\" value=\""+angsuranId+"\" class=\"formElemen\">");
            rowx.add(Formater.formatDate(objEntity.getTanggalAngsuran(),"MMM, dd yyyy")); 
            rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[frmObject.FRM_FLD_JUMLAH_ANGSURAN] +"\" value=\""+objEntity.getJumlahAngsuran()+"\" class=\"formElemen\" size=\"60\">");
	}  
	lstData.add(rowx);

	return ctrlist.draw(index);
    }
%>

<%
    CtrlAngsuran ctrlAngsuran = new CtrlAngsuran(request);
    long angsuranOID = FRMQueryString.requestLong(request, FrmAngsuran.fieldNames[FrmAngsuran.FRM_FLD_ID_ANGSURAN]);
    long oidPinjaman = FRMQueryString.requestLong(request, ""+FrmPinjaman.fieldNames[FrmPinjaman.FRM_PINJAMAN_ID]);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.ERR_NONE;
    
    String errMsg = "";
    String whereClause = ""+PstAngsuran.fieldNames[PstAngsuran.FLD_ID_PINJAMAN]+" = "+oidPinjaman;
    String orderClause = ""+PstAngsuran.fieldNames[PstAngsuran.FLD_TANGGAL_ANGSURAN];
    int start = FRMQueryString.requestInt(request, "start");
    int recordToGet = 10;
    
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = systemTitle[SESS_LANGUAGE];
    String strAddAngsuran = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
    String strSaveAngsuran = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
    String strAskAngsuran = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
    String strDeleteAngsuran = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
    String strBackAngsuran = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
    String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
    String saveConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Data Member Success" : "Simpan Data Sukses");
    
    iErrCode = ctrlAngsuran.Action(iCommand, angsuranOID);
    errMsg = ctrlAngsuran.getMessage();
    FrmAngsuran frmAngsuran = ctrlAngsuran.getForm();
    Angsuran angsuran = ctrlAngsuran.getAngsuran(); 
    
    Vector listAngsuran = new Vector(1,1);
    int vectSize = PstAngsuran.getCount(whereClause);
    if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
            start = ctrlAngsuran.actionList(iCommand, start, vectSize, recordToGet); 
    }
    listAngsuran = PstAngsuran.list(start, recordToGet, whereClause, orderClause);
    if (listAngsuran.size() < 1 && start > 0){
        if (vectSize - recordToGet > recordToGet){
            start = start - recordToGet;  
	}else{
            start = 0 ;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; 
	}
	listAngsuran = PstAngsuran.list(start, recordToGet, whereClause , orderClause);
    }
    
%>

<!-- End of Jsp Block -->
<html>
    <!-- #BeginTemplate "/Templates/maintab.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>Koperasi - Anggota</title>
        <script language="JavaScript">
            
            function cmdAdd(){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.ADD%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.<%=frmAngsuran.fieldNames[frmAngsuran.FRM_FLD_ID_ANGSURAN]%>.value=0;
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }
            function cmdCancel(){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.CANCEL%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }

            function cmdEdit(oidEducation){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.<%=frmAngsuran.fieldNames[frmAngsuran.FRM_FLD_ID_ANGSURAN]%>.value=oidEducation;
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.EDIT%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.prev_command.value="<%=prevCommand%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }

            function cmdSave(){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.SAVE%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }
            
            function cmdAsk(oidEducation){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.<%=frmAngsuran.fieldNames[frmAngsuran.FRM_FLD_ID_ANGSURAN]%>.value=oidEducation;
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.ASK%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.prev_command.value="<%=prevCommand%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }

            function cmdConfirmDelete(oid){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.DELETE%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }

            function cmdBack(){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.FIRST%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }
            
            function cmdListFirst(){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.FIRST%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.prev_command.value="<%=Command.FIRST%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }

            function cmdListPrev(){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.PREV%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.prev_command.value="<%=Command.PREV%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }

            function cmdListNext(){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.NEXT%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.prev_command.value="<%=Command.NEXT%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
            }

            function cmdListLast(){
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.command.value="<%=Command.LAST%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.prev_command.value="<%=Command.LAST%>";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.action="angsuran_pinjaman.jsp";
                document.<%=frmAngsuran.FRM_ANGSURAN_NAME%>.submit();
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
                  <td height="20" class="contenttitle">
                    <!-- #BeginEditable "contenttitle" -->
                    &nbsp;Pembayaran
                    <!-- #EndEditable -->
                  </td>
                </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="88%" valign="top" align="left">
                                <table width="100%" border="0" cellspacing="3" cellpadding="2">
                                    <tr>
                                        <td width="100%">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td valign="top">
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                        <tr>
                                                                            <td valign="top"> <!-- #BeginEditable "content" -->
                                                                                <form name="<%=frmAngsuran.FRM_ANGSURAN_NAME%>" method="post" action="">
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_PINJAMAN_ID]%>" value="<%=oidPinjaman%>">
                                                                                    <input type="hidden" name="<%=frmAngsuran.fieldNames[frmAngsuran.FRM_FLD_ID_ANGSURAN]%>" value="<%=angsuran.getOID()%>">
                                                                                    <input type="hidden" name="<%=frmAngsuran.fieldNames[frmAngsuran.FRM_FLD_ID_PINJAMAN]%>" value="<%=oidPinjaman%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <% if (oidPinjaman != 0) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <br>
                                                                                                <table width="98%" align="center" border="0" cellspacing="2" cellpadding="2" height="26">
                                                                                                    <tr>
                                                                                                        <%-- TAB MENU --%>
                                                                                                        <%-- active tab 
                                                                                                        <td width="11%" nowrap bgcolor="#0066CC">
                                                                                                            <!-- Data Pinjaman -->
                                                                                                            <div align="center" class="tablink">
                                                                                                                <a href="editpinjaman.jsp?<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_PINJAMAN_ID]%>=<%=oidPinjaman%>" class="tablink"><%=tabTitle[SESS_LANGUAGE][0]%></a>
                                                                                                            </div>
                                                                                                        </td>--%>

                                                                                                        <td width="100%" nowrap bgcolor="#66CCFF">
                                                                                                            <!-- Data Angsuran-->
                                                                                                            <div align="center"  class="tablink">
                                                                                                                <span class="tablink"><%=tabTitle[SESS_LANGUAGE][1]%></span>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <%-- END TAB MENU --%>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}else{%>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td class="tablecolor">
                                                                                                <table  width="98%" align="center" border="0" cellspacing="2" cellpadding="2" >
                                                                                                    <tr>
                                                                                                        <td valign="top">
                                                                                                            <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="1" >
                                                                                                                <tr>
                                                                                                                    <td valign="top" width="100%">
                                                                                                                        <table width="100%" border="0" cellspacing="2" cellpadding="2" >
                                                                                                                            <tr>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="15%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="25%">&nbsp;</td>
                                                                                                                                <td scope="col" width="5%">&nbsp;</td>
                                                                                                                                <td scope="col" width="15%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                                <td scope="col" width="25%">&nbsp;</td>
                                                                                                                                <td scope="col" width="2%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td colspan="3">
                                                                                                                                    <table width="100%">
                                                                                                                                        <tr>
                                                                                                                                            <%
                                                                                                                                                Pinjaman pinjaman = new Pinjaman();
                                                                                                                                                Anggota anggota = new Anggota();
                                                                                                                                                JenisKredit jenisKredit = new JenisKredit();
                                                                                                                                                try{
                                                                                                                                                    if(PstPinjaman.listPinjamanJoin(pinjaman, anggota, jenisKredit, oidPinjaman) == false){
                                                                                                                                                        pinjaman = new Pinjaman();
                                                                                                                                                        anggota = new Anggota();
                                                                                                                                                        jenisKredit = new JenisKredit();                                                                                                                                                  
                                                                                                                                                    }   
                                                                                                                                                }catch(Exception e){
                                                                                                                                                }
                                                                                                                                            %>
                                                                                                                                            <td width="2%">&nbsp;</td>  
                                                                                                                                            <!-- No Anggota -->
                                                                                                                                            <td width="30%"><%=strTitle[SESS_LANGUAGE][0]%></td> 
                                                                                                                                            <td width="5%">:</td>
                                                                                                                                            <td width="45%">&nbsp;<%=anggota.getNoAnggota()%></td>
                                                                                                                                            <td width="2%">&nbsp;</td>         	
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td width="2%">&nbsp;</td>  
                                                                                                                                            <!--Tanggal -->
                                                                                                                                            <td width="30%"><%=strTitle[SESS_LANGUAGE][6]%></td>
                                                                                                                                            <td width="5%">:</td>
                                                                                                                                            <td width="45%"><%=Formater.formatDate(new Date(), "MMM, dd yyyy")%> </td>
                                                                                                                                            <td width="2%">&nbsp;</td>         	
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Nama Anggota-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][1]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>&nbsp;<%=anggota.getName()%></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Jumlah Kredit / Pinjaman-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][7]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>&nbsp;<%=Formater.formatNumber(pinjaman.getJumlahPinjaman(),"#.##")%></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--No Rekening-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][3]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>&nbsp;<%=anggota.getNoRekening()%></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Bunga-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][9]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>&nbsp;<%=Formater.formatNumber(jenisKredit.getBungaMin(),"#.##")%></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Alamat-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][2]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>&nbsp;<%=anggota.getAddressPermanent()%></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <!--Jangka Waktu-->
                                                                                                                                <td><%=strTitle[SESS_LANGUAGE][11]%></td>
                                                                                                                                <td>:</td>
                                                                                                                                <td>&nbsp;<%=pinjaman.getJangkaWaktu()%>&nbsp;<%=SESS_LANGUAGE!=0 ? "Moon" : "Bulan"%></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td colspan="7">
                                                                                                                                    <table border="0" width="100%" class="listgenactivity">
                                                                                                                                        <tr>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                            <td width="15%">&nbsp;</td>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                            <td width="25%">&nbsp;</td>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                            <td width="20%">&nbsp;</td>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                            <td width="25%">&nbsp;</td>
                                                                                                                                            <td width="2%">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <!--sisa angsuran-->
                                                                                                                                            <% 
                                                                                                                                                int sisaAngsuran = 0; 
                                                                                                                                                int jangkaWaktu = 0;
                                                                                                                                                double bunga = 0.0; 
                                                                                                                                                double jumlahPinjaman = 0.0;
                                                                                                                                                double besarAngsuran = 0.0; 
                                                                                                                                                try{
                                                                                                                                                    jangkaWaktu = Integer.valueOf(pinjaman.getJangkaWaktu());
                                                                                                                                                    bunga = Double.valueOf(jenisKredit.getBungaMin());
                                                                                                                                                    jumlahPinjaman = Double.valueOf(pinjaman.getJumlahPinjaman());
                                                                                                                                                    if(jangkaWaktu > vectSize){
                                                                                                                                                        sisaAngsuran = jangkaWaktu - vectSize;
                                                                                                                                                        besarAngsuran = (bunga/100*jumlahPinjaman)+jumlahPinjaman;
                                                                                                                                                    }
                                                                                                                                                }catch(Exception e){};
                                                                                                                                            %>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td colspan="5">&nbsp;
                                                                                                                                                <%=SESS_LANGUAGE!=0 ? "Remaining of installment" : "Sisa Angsuran"%> = &nbsp;<%=sisaAngsuran%>&nbsp;<%=SESS_LANGUAGE!=0 ? "times" : "kali"%>
                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td colspan="5">&nbsp;
                                                                                                                                                <%=SESS_LANGUAGE!=0 ? "Great of Installment = Principal + Interest" : "Besar Angsuran = Pokok + Bunga"%> = &nbsp;<%=FRMHandler.userFormatStringDecimal(besarAngsuran)%>&nbsp;
                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <% try{
                                                                                                                                            if(listAngsuran.size()!=0 || iCommand == Command.ADD){%> 
                                                                                                                                        <tr>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <!--angsuran-->
                                                                                                                                            <td><%=strTitle[SESS_LANGUAGE][12]%></td>
                                                                                                                                            <td width="2%">:</td>
                                                                                                                                            <td colspan="5">
                                                                                                                                                <!--daftar angsuran -->
                                                                                                                                                <%if(sisaAngsuran == 0 && iCommand == Command.ADD){iCommand=Command.NONE;}%>
                                                                                                                                                <%=drawList(iCommand, frmAngsuran, angsuran, listAngsuran, angsuranOID, SESS_LANGUAGE, start, sisaAngsuran)%>
                                                                                                                                                &nbsp;
                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td colspan="5">
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
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <%}else{
                                                                                                                                                String[] erorAngsuran= {"Data Angsuran Kosong . . .","No  . . ."};
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td colspan="6"><font color="#FF6600"><%=erorAngsuran[SESS_LANGUAGE]%></font></td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                        }}catch(Exception e){
                                                                                                                                        %>
                                                                                                                                            <%=e%> 
                                                                                                                                        <%}%>
                                                                                                                                        <tr>
                                                                                                                                          <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="20" colspan="9"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td colspan="5">
                                                                                                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                    <tr>
                                                                                                                                        <td> <%

                                                                                                                                            ctrLine.setLocationImg(approot + "/image/ctr_line");
                                                                                                                                            ctrLine.initDefault();
                                                                                                                                            ctrLine.setTableWidth("100%");
                                                                                                                                            String scomDel = "javascript:cmdAsk('" + angsuranOID+ "')";
                                                                                                                                            String sconDelCom = "javascript:cmdConfirmDelete('" + angsuranOID + "')";
                                                                                                                                            String scancel = "javascript:cmdEdit('" + angsuranOID + "')";
                                                                                                                                            
                                                                                                                                            ctrLine.setCommandStyle("command");
                                                                                                                                            ctrLine.setColCommStyle("command");
                                                                                                                                            
                                                                                                                                            ctrLine.setAddCaption(strAddAngsuran);
                                                                                                                                            ctrLine.setCancelCaption(strCancel);														
                                                                                                                                            ctrLine.setBackCaption(strBackAngsuran);														
                                                                                                                                            ctrLine.setSaveCaption(strSaveAngsuran);
                                                                                                                                            ctrLine.setDeleteCaption(strAskAngsuran);
                                                                                                                                            ctrLine.setConfirmDelCaption(strDeleteAngsuran);

                                                                                                                                            if (privDelete) {
                                                                                                                                                ctrLine.setConfirmDelCommand(sconDelCom);
                                                                                                                                                ctrLine.setDeleteCommand(scomDel);
                                                                                                                                                ctrLine.setEditCommand(scancel);
                                                                                                                                            } else {
                                                                                                                                                ctrLine.setConfirmDelCaption("");
                                                                                                                                                ctrLine.setDeleteCaption("");
                                                                                                                                                ctrLine.setEditCaption("");
                                                                                                                                            }
                                                                                                                                            if (privAdd == false && privUpdate == false) {
                                                                                                                                                ctrLine.setSaveCaption("");
                                                                                                                                            }
                                                                                                                                            if (privAdd == false) {
                                                                                                                                                ctrLine.setAddCaption("");
                                                                                                                                            }

                                                                                                                                            if (iCommand == Command.EDIT) {
                                                                                                                                                iCommand = Command.EDIT;
                                                                                                                                            }
                                                                                                                                            %> <%= ctrLine.draw(iCommand, iErrCode, errMsg)%> 
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                </table>
                                                                                                                              </td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                              <td height="40">&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                              <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>

                                                                                                <!-- #EndEditable -->
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </form>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="70">&nbsp;</td>
                                                            </tr>
                                                        </table>
                                                    </td>
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
                    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>
