/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.microservices.kredit;

import com.dimata.aiso.entity.admin.AppGroup;
import com.dimata.aiso.entity.admin.AppUser;
import com.dimata.aiso.entity.admin.PstAppGroup;
import com.dimata.aiso.entity.admin.PstAppUser;
import com.dimata.aiso.entity.admin.UserGroup;
import com.dimata.aiso.session.admin.SessAppUser;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.services.WebServices;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author WiraDharma
 */
@Path("/")
public class AppUserServices {

    @GET
    @Path("tester")
    @Produces("application/json")
    public Response userAdmin() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("RESULT", "ACTIVATED");
        } catch (Exception e) {
        }
        return Response.status(Response.Status.OK).entity(jSONObject.toString()).build();
    }

    @GET
    @Path("app-user/{keyword}/{limitStart}/{recordToGet}/{orderBy}")
    @Produces("application/json")
    public Response userAdmin(
            @PathParam("keyword") String keyword,
            @PathParam("limitStart") int limitStart,
            @PathParam("recordToGet") int recordToGet,
            @PathParam("orderBy") String orderBy
    ) {
        Response response = null;
        String whereClause = "";
        JSONObject jSONObject = userList(whereClause, limitStart, recordToGet, orderBy);
        return Response.status(Response.Status.OK).entity(jSONObject.toString()).build();
    }

    @GET
    @Path("app-user/{limitStart}/{recordToGet}/{orderBy}")
    @Produces("application/json")
    public Response userAdmin(
            @PathParam("limitStart") int limitStart,
            @PathParam("recordToGet") int recordToGet,
            @PathParam("orderBy") String orderBy) {
        Response response = null;
        JSONObject jSONObject = userList("", limitStart, recordToGet, orderBy);
        return Response.status(Response.Status.OK).entity(jSONObject.toString()).build();
    }

    @GET
    @Path("app-user/{oid}")
    @Produces("application/json")
    public Response userAdmin(@PathParam("oid") long oid) {
        JSONObject jSONObject = new JSONObject();
        try {
            AppUser appUser = PstAppUser.fetch(oid);

            jSONObject = PstAppUser.fetchJSON(oid);
        } catch (Exception e) {
        }
        return Response.status(Response.Status.OK).entity(jSONObject.toString()).build();
    }

    @POST
    @Path("insert-user/{oid}/{login}/{password}/{name}/{email}/{desc}/{status}/{assignlocation}/{emp}")
    @Produces("application/json")
    public Response insertUserAdmin(
            @PathParam("oid") long oid,
            @PathParam("login") String login,
            @PathParam("password") String password,
            @PathParam("name") String name,
            @PathParam("email") String email,
            @PathParam("desc") String desc,
            @PathParam("status") int status,
            @PathParam("assignlocation") long assignlocation,
            @PathParam("emp") long emp) {
        Response response = null;
        JSONObject jSONObject = new JSONObject();
        try {
            AppUser appUser = new AppUser();
            PstAppUser pstAppUser = new PstAppUser();
            appUser.setOID(Long.parseLong(WebServices.decodeUrl("" + oid)));
            appUser.setLoginId(WebServices.decodeUrl("" + login));
            appUser.setPassword(WebServices.decodeUrl("" + password));
            appUser.setFullName(WebServices.decodeUrl("" + name));
            appUser.setEmail(WebServices.decodeUrl("" + email));
            appUser.setDescription(WebServices.decodeUrl("" + desc));
            appUser.setEmployeeId(emp == 0 ? 0 : emp);
            appUser.setUserStatus(status);
            appUser.setAssignLocationId(assignlocation);
            long oidNew = 0;
            boolean checkOidUser = PstAppUser.checkOID(oid);
            if (checkOidUser) {
                oidNew = PstAppUser.update(appUser);
            } else {
                oidNew = PstAppUser.insertUser(appUser);
            }

            if (oidNew > 0) {
                jSONObject.put("SUCCES", true);
            } else {
                jSONObject.put("SUCCES", false);
            }
        } catch (Exception e) {
            System.out.println("Error : " + e.getMessage());
            e.printStackTrace();
        }
        return Response.status(Response.Status.OK).entity(jSONObject.toString()).build();
    }

    @POST
    @Path("user-pos/insert")
    @Produces("application/json")
    public Response insertUserFromPos(@Context HttpServletRequest request, InputStream requestBody) {
        JSONObject jSONObject = new JSONObject();
        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(requestBody));
            StringBuilder out = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                out.append(line);
            }
            String jsonString = out.toString();
            System.out.println("AppUserServices\ninsertUserFromPos JSON recevied: " + jsonString);
            JSONObject jsonObj = new JSONObject(jsonString);
            
            AppUser appUser = new AppUser();
            JSONArray userGroupArray = new JSONArray();
            try {
                PstAppUser.convertJsonToObject(jsonObj, appUser);
                userGroupArray = jsonObj.getJSONArray("USER_GROUP_ASSIGNED");
            } catch (Exception e) {
                System.out.println("========== AppUserServices =================");
                System.out.println("Error convert JSON to App User. \nError: " + e.getMessage());
                System.out.println("==========================================");
            }
            
            long oidRes;
            boolean checkOidUser = PstAppUser.checkOID(appUser.getOID());
            if (checkOidUser) {
                oidRes = PstAppUser.update(appUser);
            } else {
                oidRes = PstAppUser.insertUser(appUser);
            }

            String userGroupSysprop = PstSystemProperty.getValueByName("GRUP_USER_FROM_PROCHAIN");
            String[] userGroupCvt = userGroupSysprop.split("#");
            HashMap<String, String> userGroupMap = new HashMap<>();
            for(String i : userGroupCvt){
                String[] data = i.split("&");
                userGroupMap.put(data[0], data[1]);
            }
            
            String userGroup = "";
            for(int i = 0; i < userGroupArray.length(); i++){
                JSONObject temp = userGroupArray.optJSONObject(i);
                String group = temp.optString("USER_GROUP_NAME", "");
                String txt = userGroupMap.getOrDefault(group, "");
                if(i != 0 && !txt.equals("")){
                    userGroup += ", ";
                }
                userGroup += "'" + txt + "'";
            }
            
            Vector<AppGroup> appGroups = PstAppGroup.list(0, 0, PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_NAME] + " IN (" + userGroup + ")", "");
            Vector userGroups = new Vector(1,1);
            for(AppGroup ag : appGroups){
                UserGroup ug = new UserGroup();
                ug.setUserID(oidRes);
                ug.setGroupID(ag.getOID());
                userGroups.add(ug);
            }
            SessAppUser.setUserGroup(appUser.getOID(), userGroups);
            
            jSONObject.put("SUCCES", oidRes > 0);
            
        } catch (Exception e) {
            System.out.println("Error : " + e.getMessage());
            e.printStackTrace();
        }
        return Response.status(Response.Status.OK).entity(jSONObject.toString()).build();
    }

    @POST
    @Path("user-admin/insert")
    @Produces("application/json")
    public Response insertContactClassAssign(@Context HttpServletRequest request, InputStream requestBody) {
        JSONObject jSONObject = new JSONObject();
        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(requestBody));
            StringBuilder out = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                out.append(line);
            }
            String jsonString = out.toString();

            JSONObject jsonData = new JSONObject(jsonString);
            long oidContact = PstAppUser.syncExc(jsonData);
            if (oidContact > 0) {
                jSONObject.put("SUCCES", true);
            } else {
                jSONObject.put("SUCCES", false);
            }
        } catch (Exception exc) {

        }
        return Response.status(Response.Status.OK).entity(jSONObject.toString()).build();
    }

    public JSONObject userList(String whereClause, int limitStart, int recordToGet, String orderBy) {
        JSONObject jSONObject = new JSONObject();
        try {
            Vector listData = PstAppUser.listFullObj(limitStart, recordToGet, whereClause, orderBy);
            Vector listDataAll = PstAppUser.listFullObj(0, 0, whereClause, orderBy);
            JSONArray jSONArray = new JSONArray();
            if (listData.size() > 0) {
                for (int i = 0; i < listData.size(); i++) {
                    AppUser appUser = (AppUser) listData.get(i);
                    JSONObject objData = new JSONObject();
                    objData.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_ID], "" + appUser.getOID());
                    objData.put(PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME], "" + appUser.getFullName());
                    objData.put(PstAppUser.fieldNames[PstAppUser.FLD_EMAIL], appUser.getEmail());
                    objData.put(PstAppUser.fieldNames[PstAppUser.FLD_DESCRIPTION], "" + appUser.getDescription());
                    objData.put(PstAppUser.fieldNames[PstAppUser.FLD_UPDATE_DATE], "" + appUser.getUpdateDate());
                    objData.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_STATUS], "" + appUser.getUserStatus());
                    objData.put(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_DATE], "" + appUser.getLastLoginDate());
                    objData.put(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_IP], "" + appUser.getLastLoginIp());
                    objData.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_GROUP], "" + appUser.getUserStatus());

                    jSONArray.put(objData);
                }

                jSONObject.put("COUNT", listDataAll.size());
            }
            jSONObject.put("DATA", jSONArray);
        } catch (JSONException e) {
        }
        return jSONObject;
    }
}
