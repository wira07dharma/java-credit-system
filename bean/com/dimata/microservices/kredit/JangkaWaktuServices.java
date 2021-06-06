/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.microservices.kredit;

import com.dimata.sedana.entity.masterdata.JangkaWaktu;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktu;
import java.util.Vector;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author WiraDharma
 */
@Path("/")
public class JangkaWaktuServices {
    
  @GET
  @Path("jangka-waktu/{keyword}/{limitStart}/{recordToGet}/{orderBy}")
  @Produces("application/json")
  public Response jangkaWaktu(
          @PathParam("keyword") String keyword,
          @PathParam("limitStart") int limitStart,
          @PathParam("recordToGet") int recordToGet,
          @PathParam("orderBy") String orderBy
          ){
    Response response = null;
    String whereClause ="";
    JSONObject jSONObject = masterList(whereClause, limitStart, recordToGet, orderBy);
    return Response.status(Status.OK).entity(jSONObject.toString()).build();
  }

  @GET
  @Path("jangka-waktu/{limitStart}/{recordToGet}/{orderBy}")
  @Produces("application/json")
  public Response jangkaWaktu(
          @PathParam("limitStart") int limitStart,
          @PathParam("recordToGet") int recordToGet,
          @PathParam("orderBy") String orderBy) {
    Response response = null;
    JSONObject jSONObject = masterList("", limitStart, recordToGet, orderBy);
    return Response.status(Status.OK).entity(jSONObject.toString()).build();
  }

  @GET
  @Path("jangka-waktu/{oid}")
  @Produces("application/json")
  public Response jangkaWaktu(@PathParam("oid") long oid) {
    JSONObject jSONObject = new JSONObject();
    try {
      JangkaWaktu jangkaWaktu = PstJangkaWaktu.fetchExc(oid);

      jSONObject = PstJangkaWaktu.fetchJSON(oid);
    } catch (Exception e) {
    }
    return Response.status(Status.OK).entity(jSONObject.toString()).build();
  }
  
  public JSONObject masterList(String whereClause, int limitStart, int recordToGet, String orderBy){
  JSONObject jSONObject = new JSONObject();
    try {
      Vector listData = PstJangkaWaktu.list(limitStart, recordToGet, whereClause, orderBy);
      Vector listDataAll = PstJangkaWaktu.list(0,0,whereClause, orderBy);
      JSONArray jSONArray = new JSONArray();
      if(listData.size() > 0){
        for(int i = 0; i < listData.size(); i++){
        JangkaWaktu jangkaWaktu = (JangkaWaktu) listData.get(i);
        JSONObject objData = new JSONObject();
        objData.put(PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU_ID], "" + jangkaWaktu.getOID());
        objData.put(PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU], "" + jangkaWaktu.getJangkaWaktu());

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
