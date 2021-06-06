<%-- 
    Document   : log_list
    Created on : Oct 17, 2017, 3:22:17 PM
    Author     : Regen
--%>
<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.*"%>
<%@page import="java.util.Vector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../main/checkuser.jsp" %>
<%
  JSONObject o = new JSONObject();
  JSONArray adoc = new JSONArray();
  String[] docs = ((request.getParameterValues("doc") == null) ? new String[0] : request.getParameterValues("doc"));
  o.put("time", FRMQueryString.requestString(request, "time"));
  for(String doc: docs) {
    adoc.put(doc);
  }
  o.put("doc", adoc);
  request.setAttribute("obj", o);
%>
<!DOCTYPE html>
<html>
  <head>
    <title>SEDANA</title>
    <%@ include file = "/style/lte_head.jsp" %>
  </head>
  <body>
    <section class="content-header">
      <h1>
        Log System
        <small>History</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Log System</a></li>
        <li><a href="#">History</a></li>
      </ol>
    </section>
    <section class="content">
      <div class="row">
        <div class="col-lg-12">
          <div class="box box-solid box-default">
            <div class="box-header">
              <h3 class="box-title">Cari Log History</h3>
              <div class="box-tools pull-right">
                <button type="button" class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                <button type="button" class="btn btn-default btn-sm" data-widget="remove"><i class="fa fa-times"></i></button>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body">
              <form method="post">
                <div class="col-md-6">
                  <div class="form-group">
                    <label>History Time</label>
                    <div class="input-group">
                      <div class="input-group-addon">
                        <i class="fa fa-clock-o"></i>
                      </div>
                      <input type="text" value="<%=FRMQueryString.requestString(request, "time")%>" class="form-control pull-right time-range" name="time">
                    </div>
                    <!-- /.input group -->
                  </div>
                </div>
                <div class="col-md-5">
                  <div class="form-group">
                    <label>Document </label>
                    <select class="form-control select2" name="doc" placeholder="All" multiple style="width: 100%;" tabindex="-1" aria-hidden="true">
                      <% for (String h : SessHistory.document) {%>
                      <option <%=Master.inArray(docs, h)?"selected":""%> value="<%=h%>"><%=h%></option>
                      <% } %>
                    </select>
                  </div>
                </div>
                <div class="col-md-1">
                  <button style="margin-top: 24px;" class="btn btn-success" type="submit">Search</button>
                </div>
              </form>
            </div><!-- /.box-body -->
          </div>
          <div class="box box-danger">
            <div class="box-header">
              <h3 class="box-title">History List</h3>
            </div><!-- /.box-header -->
            <div class="box-body">
              <%@ include file = "history_table.jsp" %>
            </div><!-- /.box-body -->
          </div>
        </div>
      </div>
    </section>
  </body>
</html>