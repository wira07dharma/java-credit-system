<%@page import="java.util.Date"%>
<%@page import="com.dimata.util.Formater"%>
<footer class="main-footer" style="margin-left: 0; background-color: #eaf3df; position: fixed; bottom: 0; left: 0; width: 100%; border-left: none;">
  <div class="pull-right hidden-xs">
    <b>Version</b> <%=request.getAttribute("version")%>
  </div>
  <strong>Copyright &copy; <%=request.getAttribute("year")%> <a href="http://dimata.com">Dimata IT Solutions</a>.</strong> All rights
  reserved.
</footer>