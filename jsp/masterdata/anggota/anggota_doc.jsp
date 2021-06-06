<%-- 
    Document   : anggota_doc
    Created on : Dec 12, 2017, 4:49:39 PM
    Author     : Dimata 007
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<%!
    public static final String tabTitle[][] = {
        {"Data Pribadi", "Anggota Keluarga", "Dokumen Pendukung", "Pendidikan", "Data Tabungan"},
        {"Personal Date", "Family Member", "Support Document", "Education", "Saving Data"}
    };
    
    public static final String systemTitle[] = {
        "Anggota", "Member"
    };
    
    public static final String userTitle[][] = {
        {"Tambah", "Edit"}, {"Add", "Edit"}
    };
%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidAnggota = FRMQueryString.requestLong(request, "anggota_oid");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
    </head>
    <body bgcolor="" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg')">

        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="30%" bgcolor="#F9FCFF">
            <tr> 
                <td height="20" class="contenttitle" >
                    <b><%=systemTitle[SESS_LANGUAGE]%> > <%=oidAnggota != 0 ? userTitle[SESS_LANGUAGE][1].toUpperCase() : userTitle[SESS_LANGUAGE][0].toUpperCase()%></b>
                </td>
            </tr>            
            <tr>
                <td>
                    <% if (oidAnggota != 0) {%>
                    <table width="98%" align="center" border="0" cellspacing="2" cellpadding="2" height="26">
                        <tr style="height: 35px;">
                            <%-- TAB MENU --%>
                            <%-- active tab --%>
                            <td width="20%" style="background-color: lightgray">
                                <!-- Data Personal -->
                                <div align="center" class="">
                                    <a href="anggota_edit.jsp?anggota_oid=<%=oidAnggota%>" style="color: black; text-decoration: none;" class=""><%=tabTitle[SESS_LANGUAGE][0]%></a>
                                </div>
                            </td>                                                                                                        
                            <td width="20%" style="color: white; background-color: #337ab7">
                                <!-- Pendidikan-->
                                <div align="center"  class="">
                                    <span class=""><%=tabTitle[SESS_LANGUAGE][3]%></span>
                                </div>
                            </td>
                            <td width="20%" style="background-color: lightgray">
                                <!-- Keluarga Anggota-->
                                <div align="center"  class="">
                                    <a href="anggota_family.jsp?anggota_oid=<%=oidAnggota%>" style="color: black; text-decoration: none;" class=""><%=tabTitle[SESS_LANGUAGE][1]%></a>
                                </div>
                            </td>
                            <td width="20%" style="background-color: lightgray">
                                <!-- Keluarga Anggota-->
                                <div align="center"  class="">
                                    <a href="anggota_tabungan.jsp?anggota_oid=<%=oidAnggota%>" style="color: black; text-decoration: none;" class=""><%=tabTitle[SESS_LANGUAGE][4]%></a>
                                </div>
                            </td>
                            <td width="20%" style="background-color: lightgray">
                                <!-- Dokumen -->
                                <div align="center"  class="">
                                    <a href="anggota_doc.jsp?anggota_oid=<%=oidAnggota%>" style="color: black; text-decoration: none;" class=""><%=tabTitle[SESS_LANGUAGE][2]%></a>
                                </div>
                            </td>
                            <%-- END TAB MENU --%>
                        </tr>
                    </table>
                    <%}%>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                        
                    </table>
                </td>
            </tr>
        </table>

    </body>
</html>
