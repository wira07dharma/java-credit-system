/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.microservices.kredit;

import com.dimata.common.entity.contact.ContactClass;
import com.dimata.common.entity.contact.ContactClassAssign;
import com.dimata.common.entity.contact.PstContactClass;
import com.dimata.common.entity.contact.PstContactClassAssign;
import com.dimata.common.entity.contact.PstContactList;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import org.json.JSONObject;

/**
 *
 * @author Regen
 */
@Path("/")
public class ContactServices {
  @POST
    @Path("member/insert")
    @Produces("application/json")
    public Response insertContact(@Context HttpServletRequest request, InputStream requestBody){
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
            long oidContact = PstContactList.syncExc(jsonData);
            ContactClass con = new ContactClass();
            String where = PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE]+" = "+PstContactClass.CONTACT_TYPE_MEMBER;
            Vector contac = PstContactClass.list(0, 0, where, "");
            for(int i = 0; i < contac.size(); i++){
              con = (ContactClass) contac.get(i);
            }
            ContactClassAssign ca = new ContactClassAssign();
            ca.setContactClassId(con.getOID());
            ca.setContactId(oidContact);
            PstContactClassAssign.insertExc(ca);

            if (oidContact>0){
                jSONObject.put("SUCCES", true);
            } else {
                jSONObject.put("SUCCES", false);
            }
        } catch (Exception exc) {

        }
        return Response.status(Response.Status.OK).entity(jSONObject.toString()).build();
    }
}
