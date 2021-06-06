/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.microservices.kredit;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import java.util.Vector;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import org.json.JSONObject;
/**
 *
 * @author Regen
 */
@Path("/")
public class BiayaServices {
  
  @GET
    @Path("biaya-transaksi/list/{cbmOid}")
    @Produces("application/json")
    public Response material( @PathParam("cbmOid") long oid){
        JSONObject jSONObject = new JSONObject();
        try {
            Vector listPinjaman = PstPinjaman.list(0, 0, PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]+"="+oid, "");
            if (listPinjaman.size()>0){
                Pinjaman pinjaman = (Pinjaman) listPinjaman.get(0);
                jSONObject = PstPinjaman.fetchJSON(pinjaman.getOID());
            }
            
        } catch (Exception exc) {

        }
        return Response.status(Status.OK).entity(jSONObject.toString()).build();
    }
    
  
}
