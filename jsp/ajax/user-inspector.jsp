<%@page import="com.dimata.aiso.entity.admin.PstAppUser"%>
<%@page import="com.dimata.aiso.entity.admin.AppUser"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="com.dimata.aiso.form.admin.FrmAppUser"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%
  //JSONArray a   = new JSONArray();
  //JSONObject o  = new JSONObject();
  //a.put(o);
  String username = FRMQueryString.requestString(request, FrmAppUser.fieldNames[FrmAppUser.FRM_LOGIN_ID]);
  String password = FRMQueryString.requestString(request, FrmAppUser.fieldNames[FrmAppUser.FRM_PASSWORD]);
  int userGroup = FRMQueryString.requestInt(request, FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP]);
  AppUser au = PstAppUser.getByLoginIDAndPassword(username, password);
  String value = "[]";
  if(au == null) {
    //o.put("login", false);
    value = "[{\"login\":false}]";
  } else {
    if(au.getOID() == 0 || (userGroup != 0 && au.getGroupUser()!=userGroup)) {
      //o.put("login", false);    
      value = "[{\"login\":false}]";
    } else {
      value = "[{\"login\":true,"
              + "\"oid\":\""+String.valueOf(au.getOID())+"\","
              + "\"username\":\""+au.getLoginId()+"\","
              + "\"name\":\""+au.getFullName()+"\"}]";
      //o.put("login", true);
      //o.put("oid", String.valueOf(au.getOID()));
      //o.put("username", au.getLoginId());
      //o.put("name", au.getFullName());
    }
  }
  //a.put(value);
%>
<%=value%>