<%-- 
    Document   : list_anggota_kelompok
    Created on : Aug 29, 2017, 9:04:36 AM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.aiso.entity.masterdata.PstCompany"%>
<% 
/* 
 * Page Name  		:  contactlist_edit.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		: karya 
 * @version  		: 01 
 */

/*******************************************************************
 * Page Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 			: [output ...] 
 *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package aiso -->
<%@ page import = "com.dimata.aiso.entity.masterdata.Company" %>
<%@ page import = "com.dimata.aiso.form.masterdata.FrmCompany" %>
<%@ page import = "com.dimata.aiso.form.masterdata.CtrlCompany" %>
<%@ page import = "com.dimata.aiso.session.masterdata.SessCompany" %>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

%>

<%!
public static String strTitle[][] = {
	{
	"Kode","Nama Perusahaan","Nama Depan Kontak","Nama Belakang Kontak",
	"Alamat","Kota","Propinsi","Negara","Telepon","Handphone","Fax","Email","Kode POS","Logo Perusahaan"
	},	
	
	{
	"Code","Company Name","Person Name","Person Last Name",
	"Address","City","Province","Country","Phone","Handphone","Fax","Email","Postal Code","Company Logo"
	}
};

public static final String masterTitle[] = {
	"Input","Entry"	
};

public static final String compTitle[] = {
	"Perusahaan","Company"
};

public String getJspTitle(String textJsp[][], int index, int language, String prefiks, boolean addBody){
	String result = "";
	if(addBody){
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){	
			result = textJsp[language][index] + " " + prefiks;
		}else{
			result = prefiks + " " + textJsp[language][index];		
		}
	}else{
		result = textJsp[language][index];
	} 
	return result;
}

%>
<!-- Jsp Block -->
<%
CtrlCompany ctrlCompany = new CtrlCompany(request);
long oidCompany = FRMQueryString.requestLong(request, "hidden_company_id");

boolean sameContactCode = false;
int iErrCode = FRMMessage.ERR_NONE;
String errMsg = ""; 
String whereClause = "";
String orderClause = "";
int iCommand = FRMQueryString.requestCommand(request);
int pictCommand = FRMQueryString.requestInt(request,"pict_command");
int prevCommand = FRMQueryString.requestInt(request,"prev_command");
int start = FRMQueryString.requestInt(request,"start");
int statusUpload = FRMQueryString.requestInt(request, "status");
String pesanUpload = FRMQueryString.requestString(request, "message");

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = compTitle[SESS_LANGUAGE];
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";

System.out.println("iCommand ::: "+iCommand);

oidCompany = PstCompany.getOidCompany();

iErrCode = ctrlCompany.action(iCommand,oidCompany);

errMsg = ctrlCompany.getMessage();
FrmCompany frmCompany = ctrlCompany.getForm();
Company objCompany = ctrlCompany.getCompany();
oidCompany = objCompany.getOID();


ctrLine.initDefault(SESS_LANGUAGE,currPageTitle);
ctrLine.setBackCaption(strBackComp);

String lokasiSimpanFoto = PstSystemProperty.getValueByName("COMP_IMAGE_PATH");
String lokasiAmbilFoto = PstSystemProperty.getValueByName("COMP_IMAGE_GET_PATH");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/font-awesome-4.7.0/css/font-awesome.min.css">        
        <!-- Datetime Picker -->
        <link href="../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <!-- Select2 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
        <link href="../../style/datatables/dataTables.bootstrap.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../../style/bootstrap-notify/bootstrap-notify.css"/>
        <!-- jQuery 2.2.3 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <!-- Bootstrap 3.3.6 -->
        <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>
        <!-- AdminLTE for demo purposes -->
        <script src="../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
        <!-- AdminLTE App -->
        <script type="text/javascript" src="../../style/bootstrap-notify/bootstrap-notify.js"></script>
        <script src="../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>    
        <script src="../../style/dist/js/dimata-app.js" type="text/javascript"></script>
        <!-- Select2 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
        <!-- Datetime Picker -->
        <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <script src="../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
        <script src="../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
        <style>
            .label-button {
                border-style: solid;
                border-width: thin;
                border-color: grey;
                border-radius: 2px;
                padding: 3px 5px;
                cursor: pointer;
            }
        </style>
        <script language="JavaScript">
        function cmdCancel(){
                document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.ADD%>";
                document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
                document.<%=FrmCompany.FRM_COMPANY%>.submit();
        } 

        function cmdCancel(){
                document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.CANCEL%>";
                document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
                document.<%=FrmCompany.FRM_COMPANY%>.submit();
        } 

        function cmdEdit(oid){ 
                document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.EDIT%>";
                document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
                document.<%=FrmCompany.FRM_COMPANY%>.submit(); 
        } 

        function cmdSave(){
                document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.SAVE%>"; 
                document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
                document.<%=FrmCompany.FRM_COMPANY%>.submit();
        }

        function cmdDelete(oid){
                document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.ASK%>"; 
                document.<%=FrmCompany.FRM_COMPANY%>.hidden_company_id.value=oid; 
                document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
                document.<%=FrmCompany.FRM_COMPANY%>.submit();
        } 

        function cmdConfirmDelete(oid){
                document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.DELETE%>";
                document.<%=FrmCompany.FRM_COMPANY%>.hidden_company_id.value=oid; 
                document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
                document.<%=FrmCompany.FRM_COMPANY%>.submit();
        }  

        function cmdBack(){
                document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.BACK%>"; 
                document.<%=FrmCompany.FRM_COMPANY%>.action="company_list.jsp";
                document.<%=FrmCompany.FRM_COMPANY%>.submit();
        }


        </script>
        <SCRIPT language=JavaScript>
                    $(document).ready(function () {

                        var getDataFunction = function (onDone, onSuccess, dataSend, servletName, dataAppendTo, notification) {
                            $(this).getData({
                                onDone: function (data) {
                                    onDone(data);
                                },
                                onSuccess: function (data) {
                                    onSuccess(data);
                                },
                                approot: "<%=approot%>",
                                dataSend: dataSend,
                                servletName: servletName,
                                dataAppendTo: dataAppendTo,
                                notification: notification
                            });
                        };

                        $('#btn_upload').click(function () {
                            var foto = $('#btn_browse').val();
                            if (foto === "") {
                                alert("Silakan pilih foto terlebih dahulu");
                            } else {
                                $('#formUpload').submit();
                            }
                        });

                    });

                    ////////////////////////////////////////////////////////////

                    var loadFile = function (event) {
                        var output = document.getElementById('output');
                        output.src = URL.createObjectURL(event.target.files[0]);
                    };

                    function MM_preloadImages() { //v3.0
                        var d = document;
                        if (d.images) {
                            if (!d.MM_p)
                                d.MM_p = new Array();
                            var i, j = d.MM_p.length, a = MM_preloadImages.arguments;
                            for (i = 0; i < a.length; i++)
                                if (a[i].indexOf("#") != 0) {
                                    d.MM_p[j] = new Image;
                                    d.MM_p[j++].src = a[i];
                                }
                        }
                    }

                    function MM_findObj(n, d) { //v4.0
                        var p, i, x;
                        if (!d)
                            d = document;
                        if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
                            d = parent.frames[n.substring(p + 1)].document;
                            n = n.substring(0, p);
                        }
                        if (!(x = d[n]) && d.all)
                            x = d.all[n];
                        for (i = 0; !x && i < d.forms.length; i++)
                            x = d.forms[i][n];
                        for (i = 0; !x && d.layers && i < d.layers.length; i++)
                            x = MM_findObj(n, d.layers[i].document);
                        if (!x && document.getElementById)
                            x = document.getElementById(n);
                        return x;
                    }

                    function MM_swapImage() { //v3.0
                        var i, j = 0, x, a = MM_swapImage.arguments;
                        document.MM_sr = new Array;
                        for (i = 0; i < (a.length - 2); i += 3)
                            if ((x = MM_findObj(a[i])) != null) {
                                document.MM_sr[j++] = x;
                                if (!x.oSrc)
                                    x.oSrc = x.src;
                                x.src = a[i + 2];
                            }
                    }

        </SCRIPT>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Data Organisasi
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Master Bumdesa</li>
                    <li class="active">Data Organisasi</li>
                </ol>
            </section>
            <section class="content-header">
                <a class="btn btn-danger" href="../masterbumdes/company_edit.jsp?kelompok_id=0&command=<%=Command.EDIT%>">Data Perusahaan</a>
                <a style="background-color: white" class="btn btn-default" href="../masterbumdes/pengurus_company.jsp?kelompok_id=0">Data Pengurus</a>
            </section>
            <section class="content">
                <div class="box box-success">
                    <div class="box-body">
                        <table width="100%" border="0" cellspacing="1" cellpadding="1" >
                            <tr> 
                              <td > 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
                                  <tr> 
                                    <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
                                            <b><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font></b><!-- #EndEditable --></td>
                                  </tr>
                                  <tr> 
                                    <td valign="top"><!-- #BeginEditable "content" -->
                                        <% if (objCompany.getOID() != 0) {%>                                                                                                                                            
                                        <form id="formUpload" class="form-horizontal" action="<%=approot%>/AjaxUploadFile?company_oid=<%=objCompany.getOID()%>&SEND_ROOT=<%=approot%>&SEND_LOCATION=<%=lokasiSimpanFoto%>" method="post" enctype="multipart/form-data">    
                                            <div>
                                                <input type="file" name="file" id="btn_browse" style="display: none" accept=".jpg, .jpeg, .png" onchange="loadFile(event)" />                                                                                                                                                                                
                                            </div>
                                        </form>

                                        <% }%>
                                      <form name="<%=FrmCompany.FRM_COMPANY%>" method="post" action="">
                                        <input type="hidden" name="command" value="">
                                        <input type="hidden" name="start" value="<%=start%>">
                                        <input type="hidden" name="hidden_company_id" value="<%=oidCompany%>">
                                        <table border="0" width="100%">
                                          <tr> 
                                            <td height="8">&nbsp; 
                                            </td>
                                          </tr>
                                        </table>			   
                                        <table width="100%" cellspacing="1" cellpadding="1" >
                                            <% if (objCompany.getOID() != 0) {%>
                                            <tr align="left"> 
                                                <td width="13%" valign="top" >&nbsp;<%=getJspTitle(strTitle,13,SESS_LANGUAGE,currPageTitle,false)%></td>
                                                <td  width="1%"  valign="top">:</td>
                                                <td  width="86%"  valign="top">&nbsp; 
                                                    <!--input type="file" name="foto" accept="image/*" onchange="loadFile(event)"-->                                                                                                                                     
                                                    <%
                                                        String path = lokasiAmbilFoto + objCompany.getCompImage();
                                                    %>                                                                                                                                    
                                                    <img id="output" height="auto" width="200" src="<%=path%>" alt=""/>
                                                    <p></p>
                                                    <% if (statusUpload == 1) {%>                                                                                                                                    
                                                    Jika foto tidak muncul klik di <a href="company_edit.jsp?command="<%=Command.EDIT%>><b>SINI</b></a>.
                                                    <% } else {%>
                                                    <%=pesanUpload%>
                                                    <% } %>
                                                    <p></p>
                                                    <label class="label-button" for="btn_browse">Pilih foto</label>
                                                    &nbsp;
                                                    <button type="button" id="btn_upload">Simpan foto</button>
                                                </td>
                                            </tr>
                                                <% } %>
                                          <tr align="left"> 
                                            <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_COMPANY_CODE]%>" value="<%=objCompany.getCompanyCode()%>" class="formElemen" size="10">
                                            * <%=frmCompany.getErrorMsg(FrmCompany.FRM_COMPANY_CODE)%></td>
                                          </tr>


                                          <tr align="left"> 
                                            <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_COMPANY_NAME]%>" value="<%=objCompany.getCompanyName()%>"  size="40">
                                              *<%=frmCompany.getErrorMsg(FrmCompany.FRM_COMPANY_NAME)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_PERSON_NAME]%>" value="<%=objCompany.getPersonName()%>" size="30">
                                              <%=frmCompany.getErrorMsg(FrmCompany.FRM_PERSON_NAME)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top"> &nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_PERSON_LAST_NAME]%>" value="<%=objCompany.getPersonLastName()%>" size="30">
                                              <%=frmCompany.getErrorMsg(FrmCompany.FRM_PERSON_LAST_NAME)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%"  valign="top"  >&nbsp;<%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <textarea name="<%=FrmCompany.fieldNames[FrmCompany.FRM_BUSS_ADDRESS]%>" cols="45" rows="3"><%=objCompany.getBussAddress()%></textarea>                    
                                              * <%=frmCompany.getErrorMsg(FrmCompany.FRM_BUSS_ADDRESS)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_TOWN]%>" value="<%=objCompany.getTown()%>" size="30">
                                              <%=frmCompany.getErrorMsg(FrmCompany.FRM_TOWN)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_PROVINCE]%>" value="<%=objCompany.getProvince()%>" size="30">
                                              <%=frmCompany.getErrorMsg(FrmCompany.FRM_PROVINCE)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_COUNTRY]%>" value="<%=objCompany.getCountry()%>" size="30">
                                              <%=frmCompany.getErrorMsg(FrmCompany.FRM_COUNTRY)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,8,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_TELP_NR]%>" value="<%=objCompany.getPhoneNr()%>" size="15">
                                              <%=frmCompany.getErrorMsg(FrmCompany.FRM_TELP_NR)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,9,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_TELP_MOBILE]%>" value="<%=objCompany.getMobilePh()%>" size="20">
                                              <%=frmCompany.getErrorMsg(FrmCompany.FRM_TELP_MOBILE)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,10,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  width="1%"  valign="top">:</td>
                                            <td  width="86%"  valign="top">&nbsp; 
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_FAX]%>" value="<%=objCompany.getFax()%>" size="15">
                                              <%=frmCompany.getErrorMsg(FrmCompany.FRM_FAX)%></td>
                                          </tr>
                                          <tr align="left">
                                            <td  >&nbsp;<%=getJspTitle(strTitle,11,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  valign="top">:</td>
                                            <td  valign="top">&nbsp;
                                                <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_EMAIL_COMPANY]%>" value="<%=objCompany.getCompEmail()%>" size="30">
                                                <%=frmCompany.getErrorMsg(FrmCompany.FRM_EMAIL_COMPANY)%></td>
                                          </tr>
                                          <tr align="left">
                                            <td  >&nbsp;<%=getJspTitle(strTitle,12,SESS_LANGUAGE,currPageTitle,false)%></td>
                                            <td  valign="top">:</td>
                                            <td  valign="top">&nbsp;
                                              <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_POSTAL_CODE]%>" value="<%=objCompany.getPostalCode()%>" size="15">
                                              <%=frmCompany.getErrorMsg(FrmCompany.FRM_POSTAL_CODE)%></td>
                                          </tr>
                                          <tr align="left"> 
                                            <td width="13%"  valign="top" >&nbsp;</td>
                                            <td  width="1%"  valign="top">&nbsp;</td>
                                            <td  width="86%"  valign="top">&nbsp;</td>
                                          </tr>
                                                          <%if(iCommand == Command.ASK){%>
                                                          <tr align="left"> 
                                            <td width="13%"  colspan="3" class="msgquestion" valign="top" ><%=delConfirm%></td>
                                          </tr>
                                                          <tr align="left"> 
                                            <td width="13%"  valign="top" >&nbsp;</td>
                                            <td  width="1%"  valign="top">&nbsp;</td>
                                            <td  width="86%"  valign="top">&nbsp;</td>
                                          </tr>
                                                          <%}%>
                                          <tr align="left"> 
                                            <td colspan="3"  valign="top"  >
                                                <table width="100%"><tr><td><div class="command">
                                                <%if(iCommand == Command.ADD){%>
                                                      <a href="javascript:cmdSave()"><%=strSaveComp%></a> 
                                                <%}else{%>
                                                      <%if(iCommand == Command.ASK){%>

                                                      <%}else{%>
                                                           <button type="button" class="btn btn-md btn-danger" id="btn_add"  onclick="cmdSave()" ><i class="fa fa-save"> Simpan </i></button>
                                                      <%}%>
                                                <%}%>
                                                </div></td></tr></table>

                                                </td>
                                          </tr>
                                          <tr align="left"> 
                                            <td colspan="3">&nbsp;</td>
                                          </tr>
                                        </table>
                                      </form>
                                      <!-- #EndEditable --></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                    </div>

                </div>
            </section>
        </div>
    
</body>
</html>
