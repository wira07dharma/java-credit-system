<%-- 
    Document   : test
    Created on : Oct 16, 2018, 8:47:21 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan"%>
<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HashMap<String,Double> listData = SessReportKredit.rangkumanKolekBulanan(0, "June 2020", "July 2020", "");
    DateFormat formater = new SimpleDateFormat("MMMM yyyy");
        
    Calendar start = Calendar.getInstance();
    Calendar end = Calendar.getInstance();

    try {
        start.setTime(formater.parse("June 2020"));
        end.setTime(formater.parse("July 2020"));
    } catch (ParseException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .test {
                border-style: dotted;
                border-width: thin
            }
        </style>
    </head>
    <body>
        <%
         if (listData.size()>0){
             
             %>
             <table class="table">
                 <tr>
                    <th>Kriteria</th>
                    <%
                        while (start.before(end) || start.equals(end)) {
                            %>
                                <th><%=Formater.formatDate(start.getTime(), "MMMM")%></th>
                                <th><%=Formater.formatDate(start.getTime(), "MMMM")%></th>
                            <%
                            start.add(Calendar.MONTH, 1);
                        }
                    %>
                 </tr>
             
             <%
             Vector list = PstKolektibilitasPembayaran.listJoin(0, 0, "", "det."+PstKolektibilitasPembayaranDetails.fieldNames[PstKolektibilitasPembayaranDetails.FLD_MAXHARITUNGGAKANPOKOK]);
             for (int x = 0; x < list.size(); x++){
                 KolektibilitasPembayaran kolek = (KolektibilitasPembayaran) list.get(x);
                 try {
                    start.setTime(formater.parse("June 2020"));
                    end.setTime(formater.parse("July 2020"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                 %>
                 <tr>
                     <td><%=kolek.getJudulKolektibilitas()%></td>
                     <%
                        while (start.before(end) || start.equals(end)) {
                            String bulan = Formater.formatDate(start.getTime(), "MMMM");
                            %>
                                <th><%=listData.get(kolek.getJudulKolektibilitas()+"_"+bulan+"_JUMLAH")%></th>
                                <th><%=String.format("%.2f", listData.get(kolek.getJudulKolektibilitas()+"_"+bulan+"_SISA"))%></th>
                            <%
                            start.add(Calendar.MONTH, 1);
                        }
                    %>
                 </tr>
                 <%
             }
             
         }
        %>
        </table>
    </body>
</html>
