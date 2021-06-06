/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.microservices.kredit;

import com.dimata.pos.entity.billing.BillMain;
import com.dimata.pos.entity.billing.Billdetail;
import com.dimata.pos.entity.billing.PstBillDetail;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.entity.I_DocStatus;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.masterdata.BiayaTransaksi;
import com.dimata.sedana.entity.masterdata.PstBiayaTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import java.sql.ResultSet;
import java.util.Vector;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
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
 * @author Dimata IT Solutions
 */
@Path("/")
public class PengajuanServices {

    @GET
    @Path("pengajuan/status-by-bill/{oid}")
    @Produces("application/json")
    public Response material(@PathParam("oid") long oid) {
        JSONObject jSONObject = new JSONObject();
        try {
            Vector listPinjaman = PstPinjaman.list(0, 0, PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID] + "=" + oid, "");
            if (listPinjaman.size() > 0) {
                Pinjaman pinjaman = (Pinjaman) listPinjaman.get(0);
                jSONObject = PstPinjaman.fetchJSON(pinjaman.getOID());
            }

        } catch (Exception exc) {

        }
        return Response.status(Status.OK).entity(jSONObject.toString()).build();
    }

    @POST
    @Path("exchange-item/{cbmOid}/{bdOid}")
    @Produces("application/json")
    public Response exchangeItem(
            @PathParam("cbmOid") long cbmOid,
            @PathParam("bdOid") long bdOid) {
        Response response = null;
        JSONObject jSONObject = new JSONObject();
        try {
            String whereClause = PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID] + " = " + cbmOid;
            Vector<Pinjaman> listPinjaman = PstPinjaman.list(0, 0, whereClause, "");
            long oidPinjaman = 0;
            Pinjaman pin = new Pinjaman();
            Billdetail bd = new Billdetail();
            for (Pinjaman p : listPinjaman) {
                oidPinjaman = p.getOID();
            }
            bd = PstBillDetail.fetchExc(bdOid);
            if (bd.getOID() != 0) {
                pin = PstPinjaman.fetchExc(oidPinjaman);
                pin.setStatusPinjaman(I_DocStatus.DOCUMENT_STATUS_DRAFT);
                PstPinjaman.updateExc(pin);
                PstBillDetail.deleteExc(bdOid);
                if (oidPinjaman != 0) {
                    jSONObject.put("SUCCES", true);
                    jSONObject.put("OID", oidPinjaman);
                    jSONObject.put("EXCHANGE", true);
                } else {
                    jSONObject.put("SUCCES", false);
                    jSONObject.put("OID", 0);
                    jSONObject.put("EXCHANGE", false);
                }
            }
        } catch (Exception e) {
            System.out.println("Error : " + e.getMessage());
            e.printStackTrace();
        }
        return Response.status(Response.Status.OK).entity(jSONObject.toString()).build();
    }

    @GET
    @Path("pinjaman/data-biaya/{oid}")
    @Produces("application/json")
    public Response dataBiaya(@PathParam("oid") long oid) {
        JSONObject jSONObject = new JSONObject();
        JSONArray array = new JSONArray();
        try {
            array = PstBiayaTransaksi.listBiayaTransaksi(0, 0, ""
                    + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oid + "'"
                    + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '2'", "");
            if (array.length() > 0) {
                jSONObject.put("DATA", array);
            } else {
                jSONObject.put("ERROR", 1);
            }
        } catch (Exception exc) {
        }
        return Response.status(Status.OK).entity(jSONObject.toString()).build();
    }

    @GET
    @Path("pinjaman/laporan-penjualan-tanggal/{start}/{end}/{location}")
    @Produces("application/json")
    public Response getLaporanPenjualanTanggal(
            @PathParam("start") String start,
            @PathParam("end") String end,
            @PathParam("location") long location
    ) {
        JSONObject jSONObject = new JSONObject();
        JSONArray array = new JSONArray();
        try {
            String whereClause = " BM." + PstBillMain.fieldNames[PstBillMain.FLD_STATUS] + " <> 2"
                    + " AND ("
                    + "(TO_DAYS( BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] + ") "
                    + ">= TO_DAYS('" + start + "')) AND "
                    + "(TO_DAYS( BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] + ") "
                    + "<= TO_DAYS('" + end + "'))"
                    + ")";
            if (location != 0) {
                whereClause += " AND BM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + location
                        + "";
            }
            array = PstPinjaman.laporanPenjualan(0, 0, whereClause, "");
            if (array.length() > 0) {
                jSONObject.put("DATA", array);
            } else {
                jSONObject.put("ERROR", 1);
            }
        } catch (Exception exc) {
        }
        return Response.status(Status.OK).entity(jSONObject.toString()).build();
    }
    
    @GET
    @Path("pinjaman/laporan-penjualan-bulanan/{start}/{end}/{location}")
    @Produces("application/json")
    public Response getLaporanPenjualanBulan(
            @PathParam("start") String start,
            @PathParam("end") String end,
            @PathParam("location") long location
    ) {
        JSONObject jSONObject = new JSONObject();
        JSONArray array = new JSONArray();
        try {
            String whereClause = " BM." + PstBillMain.fieldNames[PstBillMain.FLD_STATUS] + " <> 2"
                    + " AND ("
                    + "(TO_DAYS( BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] + ") "
                    + ">= TO_DAYS('" + start + "')) AND "
                    + "(TO_DAYS( BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] + ") "
                    + "<= TO_DAYS('" + end + "'))"
                    + ")";
            if (location != 0) {
                whereClause += " AND BM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + location
                        + "";
            }
            array = PstPinjaman.laporanPenjualanBulanan(0, 0, whereClause, "");
            if (array.length() > 0) {
                jSONObject.put("DATA", array);
            } else {
                jSONObject.put("ERROR", 1);
            }
        } catch (Exception exc) {
        }
        return Response.status(Status.OK).entity(jSONObject.toString()).build();
    }

}
