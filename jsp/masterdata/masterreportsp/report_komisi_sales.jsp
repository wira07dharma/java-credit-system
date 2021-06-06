<%-- 
    Document   : report_komisi_sales
    Created on : Feb 27, 2020, 3:33:20 PM
    Author     : arisena
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%! 
    public static String textHeader[][] = {
        {"Komisi Sales", "Laporan", "Hasil Pencarian", "Form Pencarian"},
        {"Sales Commission", "Report", "Loan Data", "Search Form"}
    };

    public static final String dataTableTitle[][] = {
        {"Tampilkan _MENU_ data per halaman",
            "Data Tidak Ditemukan",
            "Menampilkan halaman _PAGE_ dari _PAGES_",
            "Belum Ada Data",
            "(Disaring dari _MAX_ data)",
            "Pencarian :",
            "Awal",
            "Akhir",
            "Berikutnya",
            "Sebelumnya"},
        {"Display _MENU_ records per page",
            "Nothing found - sorry",
            "Showing page _PAGE_ of _PAGES_",
            "No records available",
            "(filtered from _MAX_ total records)",
            "Search :",
            "First",
            "Last",
            "Next",
            "Previous"}
    };
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../../style/style_kredit.jsp" %>
        
        <style>
            
        </style>
        <script>
            
        </script>
        
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
