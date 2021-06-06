<%-- 
    Document   : upload_payment
    Created on : Apr 30, 2020, 11:12:30 AM
    Author     : gndiw
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form name="form1" method="post" action="upload_payment_proccess.jsp" enctype="multipart/form-data">
            <input type="file" name="file" size="40">
            <input type="submit" name="Submit" value="Submit">
        </form>
    </body>
</html>
