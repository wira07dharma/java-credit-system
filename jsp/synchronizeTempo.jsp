<%-- 
    Document   : synchronizeTempo
    Created on : Feb 12, 2019, 3:57:44 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="java.util.Vector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%//
    String msg = "";
    Vector<Pinjaman> pinjamans = PstPinjaman.list(0, 0, "", "");
    int counter = 0;
    for (Pinjaman p : pinjamans) {
        try {
            p.setJatuhTempo(p.getTglRealisasi());
            PstPinjaman.updateExc(p);
            counter += 1;
        } catch (Exception e) {
            msg += e.getMessage() + "</br>";
        }
    }
    msg = msg.isEmpty() ? "" + counter + " data berhasil diubah" : msg;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%= msg %>
    </body>
</html>
