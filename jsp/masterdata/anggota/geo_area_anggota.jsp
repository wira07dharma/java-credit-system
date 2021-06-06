<%-- 
    Document   : geo_area_anggota.jsp
    Created on : Mar 7, 2013, 10:29:43 AM
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

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER); %>
<%@ include file = "../../main/checkuser.jsp" %>

<!-- Jsp Block -->
<%!
    public static String strTitle[][] = {
            {"No Anggota",//0
                     "Nama",//1
                     "Jenis Kelamin",//2
                     "Tempat Lahir",//3
                     "Tanggal Lahir",//4
                     "Pekerjaan",//5
                     "Agensi",//6
                     "Alamat Kantor",//7
                     "Kota Alamat Kantor",//8
                     "Posisi",//9
                     "Alamat Asal",//10
                     "Kota Asal",//11
                     "Propinsi Asal",//12
                     "Kabupaten Asal",//13
                     "Kecamatan Asal",//14
                     "Kelurahan",//15
                     "Id Identitas KTP/SIM",//16
                     "Masa Brlaku KTP",//17
                     "Telepon",//18
                     "Hand Phone",//19
                     "Email",//20
                     "Pendidikan",//21
                     "No NPWP",//22
                     "Status",//23
                     "Nomor Rekening"},//24
            {"Member ID",//0
                     "Name",//1
                     "Sex",//2
                     "Birth of Place",//3
                     "Birth of Date",//4
                     "Vocation",//5
                     "Agencies",//6
                     "Office Address",//7
                     "Address Office City",//8
                     "Position",//9
                     "Address",//10
                     "City",//11
                     "Province",//12
                     "Regency",//13
                     "Sub Regency",//14
                     "Ward",//15
                     "ID Card",//16
                     "Expired Date KTP",//17
                     "Telephone",//18
                     "Hand Phone",//19
                     "Email",//20
                     "Education",//21
                     "No NPWP",//22
                     "Status",//23
                     "Rekening Number"}//24
    };

    public static final String systemTitle[] = {
            "Anggota","Member"
    };

    public static final String userTitle[][] = {
        {"Tambah","Edit"},{"Add","Edit"}	
    };
    
    public static final String tabTitle[][] = {
        {"Alamat Pribadi","Anggota Keluarga","Wilayah","Pendidikan"},{"Personal Address","Family Member","Region","Education"}
    };
%>


<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");            
    
    long oidProvince = FRMQueryString.requestLong(request, FrmWard.fieldNames[FrmWard.FRM_WARD_PROVINCE_ID]);
    long oidCity = FRMQueryString.requestLong(request, FrmWard.fieldNames[FrmWard.FRM_WARD_CITY_ID ]);
    long oidRegency = FRMQueryString.requestLong(request, FrmWard.fieldNames[FrmWard.FRM_WARD_REGENCY_ID]); 
    long oidSubRegency = FRMQueryString.requestLong(request, FrmWard.fieldNames[FrmWard.FRM_WARD_SUBREGENCY_ID ]);
              
    long oidAnggota = FRMQueryString.requestLong(request, "anggota_oid");
    long oidWard = FRMQueryString.requestLong(request, FrmWard.fieldNames[FrmWard.FRM_WARD_ID]);            
    String anggota = FRMQueryString.requestString(request, "anggota");            
           
    String formName = FRMQueryString.requestString(request,"formName");
    int addresstype = FRMQueryString.requestInt(request,"addresstype");
    String sKelurahan =""; //Ward
    String sKecamatan =""; //SubRegency
    String sKabupaten =""; //Regency
    String sKota =""; //City
    String sProvinsi =""; //Province
                        
            
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;

    CtrlWard ctrlWard = new CtrlWard(request);
    ControlLine ctrLine = new ControlLine();

    iErrCode = ctrlWard.action(iCommand, oidWard);
    FrmWard frmWard = ctrlWard.getForm();
    Ward ward = ctrlWard.getWard();
    
    msgString = ctrlWard.getMessage();
    int commandRefresh = FRMQueryString.requestInt(request, "commandRefresh");
            
    ward.setIdProvince(oidProvince);
    ward.setIdCity(oidCity);
    ward.setIdRegency(oidRegency);             
    ward.setIdSubRegency(oidSubRegency);
    ward.setOID(oidWard);
    String geoAddress = "";
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>KOPERASI - Select Geo Address</title>
        <script language="JavaScript">
            
            function selectGeo(geoAddress){
                
                oidProvince = document.frmgeoaddress.<%=FrmWard.fieldNames[FrmWard.FRM_WARD_PROVINCE_ID]%>.value;
                oidCity = document.frmgeoaddress.<%=FrmWard.fieldNames[FrmWard.FRM_WARD_CITY_ID]%>.value;
                oidRegency = document.frmgeoaddress.<%=FrmWard.fieldNames[FrmWard.FRM_WARD_REGENCY_ID]%>.value;
                oidSubRegency = document.frmgeoaddress.<%=FrmWard.fieldNames[FrmWard.FRM_WARD_SUBREGENCY_ID ]%>.value; 
                oidWard = document.frmgeoaddress.<%=FrmWard.fieldNames[FrmWard.FRM_WARD_ID]%>.value;
                <% if(addresstype==1) { %>
                    self.opener.document.<%=formName%>.<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PROVINCE_ID]%>.value = oidProvince;
                    self.opener.document.<%=formName%>.<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_CITY_PERMANENT]%>.value = oidCity;
                    self.opener.document.<%=formName%>.<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PMNT_REGENCY_ID]%>.value = oidRegency;
                    self.opener.document.<%=formName%>.<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PMNT_SUBREGENCY_ID]%>.value = oidSubRegency; 
                    self.opener.document.<%=formName%>.<%=FrmAnggota.fieldNames[FrmAnggota.FRM_WARD_ID]%>.value = oidWard;
                    self.opener.document.<%=formName%>.geo_address_pmnt.value = geoAddress;                                        
                <%} else { %>
                    self.opener.document.<%=formName%>.<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_OFFICE_CITY]%>.value = oidCity;                    
                    self.opener.document.<%=formName%>.geo_area_pmnt.value = geoAddress;                                        
                <%}%>
                
                self.close();                               
            }
            
            function cmdUpdateKec(){
                document.frmgeoaddress.command.value="<%=iCommand%>";
                document.frmgeoaddress.commandRefresh.value= "1";
                document.frmgeoaddress.action="geo_area_anggota.jsp";
                document.frmgeoaddress.submit();
            }

                //-------------- script control line -------------------
                function MM_swapImgRestore() { //v3.0
                    var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
                }

                function MM_preloadImages() { //v3.0
                    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
                    }

                    function MM_findObj(n, d) { //v4.0
                        var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                        if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                        for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                        if(!x && document.getElementById) x=document.getElementById(n); return x;
                    }

                    function MM_swapImage() { //v3.0
                        var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                            if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                    }

        </script>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
        <SCRIPT language=JavaScript>
                    function hideObjectForEmployee(){
                    }

                    function hideObjectForLockers(){
                    }

                    function hideObjectForCanteen(){
                    }

                    function hideObjectForClinic(){
                    }

                    function hideObjectForMasterdata(){
                    }

        </SCRIPT>
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
                                    if(oidAnggota != 0){
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
                                                    <!-- #BeginEditable "contenttitle" -->
                                                    Select Geo <%=(addresstype==1?"":"Permanent") %> Address for <%=anggota%><!-- #EndEditable -->
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
                                                                                <form name="frmgeoaddress" method ="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">                                                                                    
                                                                                    <input type="hidden" name="start" value="<%=start%>">
                                                                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                    <input type="hidden" name="commandRefresh" value= "0">                                                                                    
                                                                                    <input type="hidden" name="anggota_oid" value="<%=oidAnggota%>">  
                                                                                    <input type="hidden" name="formName" value="<%=formName%>">  
                                                                                    <input type="hidden" name="addresstype" value="<%=addresstype%>">
                                                                                    <input type="hidden" name="anggota" value="<%=anggota%>">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                        
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" valign="middle" colspan="3">
                                                                                                <%{%>
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                                    <tr>
                                                                                                        <td height="100%">
                                                                                                            <table border="0" cellspacing="2" cellpadding="2" width="70%">
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" width="25%" height="25">Province</td>
                                                                                                                    <td width="75%"><%
                                                                                                                        Vector pro_value = new Vector(1, 1);
                                                                                                                        Vector pro_key = new Vector(1, 1);
                                                                                                                        Province province = new Province();
                                                                                                                        pro_value.add("0");
                                                                                                                        pro_key.add("select ...");
                                                                                                                        String strWhere = ""; //PstProvince.fieldNames[PstProvince.FLD_PROVINCE_ID] + "=" +ward.getIdProvince();
                                                                                                                        Vector listPro = PstProvince.list(0, 300, strWhere, ""+PstProvince.fieldNames[PstProvince.FLD_PROVINCE_NAME]);
                                                                                                                        boolean oidProvOk = false;
                                                                                                                        for (int i = 0; i < listPro.size(); i++) {
                                                                                                                            Province prov = (Province) listPro.get(i);
                                                                                                                            pro_key.add(prov.getProvinceName());
                                                                                                                            pro_value.add(String.valueOf(prov.getOID()));
                                                                                                                            if(ward.getIdProvince()==prov.getOID()){
                                                                                                                                geoAddress = geoAddress+ prov.getProvinceName();
                                                                                                                            }
                                                                                                                            if(prov.getOID()==ward.getIdProvince()){
                                                                                                                                oidProvOk=true;
                                                                                                                            }
                                                                                                                        }
                                                                                                                        if(!oidProvOk){
                                                                                                                            ward.setIdProvince(0);
                                                                                                                            oidProvince=0;
                                                                                                                        }
                                                                                                                        if(ward.getIdProvince()==0){
                                                                                                                                geoAddress = geoAddress+ "-";
                                                                                                                            }
                                                                                                                        %>
                                                                                                                        <%= ControlCombo.draw(frmWard.fieldNames[frmWard.FRM_WARD_PROVINCE_ID], "formElemen", null, "" + ward.getIdProvince(), pro_value, pro_key, "onChange=\"javascript:cmdUpdateKec()\"")%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" height="25">City</td>
                                                                                                                    <td><%
                                                                                                                        Vector kota_value = new Vector(1, 1);
                                                                                                                        Vector kota_key = new Vector(1, 1);
                                                                                                                        kota_value.add("0");
                                                                                                                        kota_key.add("select ...");
                                                                                                                        String strWhereKota = PstCity.fieldNames[PstCity.FLD_PROVINCE_ID] + "=" + ward.getIdProvince();
                                                                                                                        Vector listKota = PstCity.list(0, 300, strWhereKota, ""+PstCity.fieldNames[PstCity.FLD_CITY_NAME]);
                                                                                                                        boolean oidKotaOk = false;
                                                                                                                        for (int i = 0; i < listKota.size(); i++) {
                                                                                                                            City city = (City) listKota.get(i);
                                                                                                                            kota_key.add(city.getCityName());
                                                                                                                            kota_value.add(String.valueOf(city.getOID()));
                                                                                                                            if(ward.getIdCity()==city.getOID()){
                                                                                                                                geoAddress = geoAddress+ ","+ city.getCityName();
                                                                                                                            }
                                                                                                                            if(oidCity==city.getOID()){
                                                                                                                              oidKotaOk=true;  
                                                                                                                            }
                                                                                                                        }
                                                                                                                        if(!oidKotaOk){
                                                                                                                            oidCity=0;
                                                                                                                            ward.setIdCity(0);
                                                                                                                        }
                                                                                                                        if(ward.getIdCity()==0){
                                                                                                                                geoAddress = geoAddress+ ",-";
                                                                                                                            }
                                                                                                                        %> <%= ControlCombo.draw(frmWard.fieldNames[frmWard.FRM_WARD_CITY_ID], "formElemen", null, "" + ward.getIdCity(), kota_value, kota_key, "onChange=\"javascript:cmdUpdateKec()\"")%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" height="25">Regency</td>
                                                                                                                    <td><%
                                                                                                                        Vector kab_value = new Vector(1, 1);
                                                                                                                        Vector kab_key = new Vector(1, 1);
                                                                                                                        kab_value.add("0");
                                                                                                                        kab_key.add("select ...");
                                                                                                                        String strWhereKab = PstRegency.fieldNames[PstRegency.FLD_PROVINCE_ID] + "=" + ward.getIdProvince();
                                                                                                                        Vector listKab = PstRegency.list(0, 300, strWhereKab, ""+PstRegency.fieldNames[PstRegency.FLD_REGENCY_NAME]);
                                                                                                                        boolean oidKabOk = false;
                                                                                                                        for (int i = 0; i < listKab.size(); i++) {
                                                                                                                            Regency regency = (Regency) listKab.get(i);
                                                                                                                            kab_key.add(regency.getRegencyName());
                                                                                                                            kab_value.add(String.valueOf(regency.getOID()));
                                                                                                                            if(ward.getIdRegency()==regency.getOID()){
                                                                                                                                geoAddress = geoAddress+ ","+ regency.getRegencyName();
                                                                                                                            }
                                                                                                                            if(oidRegency==regency.getOID()){
                                                                                                                              oidKabOk=true;  
                                                                                                                            }
                                                                                                                        }
                                                                                                                        if(!oidKabOk){
                                                                                                                            oidRegency=0;
                                                                                                                            ward.setIdRegency(0);
                                                                                                                        }
                                                                                                                        if(ward.getIdRegency()==0){
                                                                                                                                geoAddress = geoAddress+ ",-";
                                                                                                                            }
                                                                                                                        %> <%= ControlCombo.draw(frmWard.fieldNames[frmWard.FRM_WARD_REGENCY_ID], "formElemen", null, "" + ward.getIdRegency(), kab_value, kab_key, "onChange=\"javascript:cmdUpdateKec()\"")%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" height="25">Sub Regency</td>
                                                                                                                    <td><%
                                                                                                                        Vector kec_value = new Vector(1, 1);
                                                                                                                        Vector kec_key = new Vector(1, 1);
                                                                                                                        kec_value.add("0");
                                                                                                                        kec_key.add("select ...");
                                                                                                                        String strWhereKec = PstSubRegency.fieldNames[PstSubRegency.FLD_REGENCY_ID] + "=" + ward.getIdRegency();
                                                                                                                        Vector listKec = PstSubRegency.list(0, 300, strWhereKec, ""+PstSubRegency.fieldNames[PstSubRegency.FLD_SUBREGENCY_NAME]);
                                                                                                                        boolean oidKecOk = false;
                                                                                                                        for (int i = 0; i < listKec.size(); i++) {
                                                                                                                            SubRegency subRegency = (SubRegency) listKec.get(i);
                                                                                                                            kec_key.add(subRegency.getSubRegencyName());
                                                                                                                            kec_value.add(String.valueOf(subRegency.getOID()));
                                                                                                                            if(ward.getIdSubRegency()==subRegency.getOID()){
                                                                                                                                geoAddress = geoAddress+ ","+ subRegency.getSubRegencyName();
                                                                                                                            }
                                                                                                                            if(oidSubRegency==subRegency.getOID()){
                                                                                                                              oidKecOk=true;  
                                                                                                                            }
                                                                                                                        }
                                                                                                                        if(!oidKecOk){
                                                                                                                            oidSubRegency=0;
                                                                                                                            ward.setIdSubRegency(0);
                                                                                                                        }
                                                                                                                        if(ward.getIdSubRegency()==0){
                                                                                                                                geoAddress = geoAddress+ ",-";
                                                                                                                            }
                                                                                                                        %> <%= ControlCombo.draw(frmWard.fieldNames[frmWard.FRM_WARD_SUBREGENCY_ID], "formElemen", null, "" + ward.getIdSubRegency(), kec_value, kec_key, "onChange=\"javascript:cmdUpdateKec()\"")%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="top" height="25">Ward</td>
                                                                                                                    <td><%                                                                                                                    
                                                                                                                    
                                                                                                                        Vector ward_value = new Vector(1, 1);
                                                                                                                        Vector ward_key = new Vector(1, 1);
                                                                                                                        ward_value.add("0");
                                                                                                                        ward_key.add("select ...");
                                                                                                                        
                                                                                                                        String whereClause = PstWard.fieldNames[PstWard.FLD_SUBREGENCY_ID]+" = "+ward.getIdSubRegency(); //"k." + PstRegency.fieldNames[PstRegency.FLD_ADDR_REGENCY_ID]+"="+oidRegency;
                                                                                                                        String orderClause = PstWard.fieldNames[PstWard.FLD_WARD_NAME]; //"k." + PstRegency.fieldNames[PstRegency.FLD_REGENCY_NAME] + ", kec." + PstWard.fieldNames[PstWard.FLD_WARD_NAME];
                                                                                                                        Vector listWard = new Vector(1, 1);                                                                                                                        
                                                                                                                        listWard = PstWard.list(0, 300, whereClause, orderClause);                                                                                                                        
                                                                                                                        
                                                                                                                        for (int i = 0; i < listWard.size(); i++) {
                                                                                                                            Ward objEntity = (Ward) listWard.get(i);
                                                                                                                            ward_key.add(objEntity.getWardName());
                                                                                                                            ward_value.add(String.valueOf(objEntity.getOID()));
                                                                                                                            if(ward.getOID()==objEntity.getOID()){
                                                                                                                                geoAddress = geoAddress+ ","+ objEntity.getWardName();
                                                                                                                            }
                                                                                                                        }
                                                                                                                        if(ward.getOID ()==0){
                                                                                                                                geoAddress = geoAddress+ ",-";
                                                                                                                            }
                                                                                                                        %> <%= ControlCombo.draw(frmWard.fieldNames[frmWard.FRM_WARD_ID], "formElemen", null, "" + ward.getOID(), ward_value, ward_key, "onChange=\"javascript:cmdUpdateKec()\"")%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top" >
                                                                                                        <td class="command">
                                                                                                            &nbsp; 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top" >
                                                                                                        <td class="command">
                                                                                                            &nbsp; <a href="javascript:selectGeo('<%=geoAddress%>')">Select <%=(addresstype==1?"":"Permanent") %> Geo Address</a>
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
