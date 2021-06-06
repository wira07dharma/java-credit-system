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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author WiraDharma
 */
@Path("/")
public class KreditPinjamanServices {
    
  @GET
  @Path("pinjaman/{keyword}/{limitStart}/{recordToGet}/{orderBy}")
  @Produces("application/json")
  public Response pinjamanKredit(
          @PathParam("keyword") String keyword,
          @PathParam("limitStart") int limitStart,
          @PathParam("recordToGet") int recordToGet,
          @PathParam("orderBy") String orderBy
          ){
    Response response = null;
    String whereClause = "";
      JSONObject jSONObject = pinjamanList(whereClause, limitStart, recordToGet, orderBy);
    return Response.status(Status.OK).entity(jSONObject.toString()).build();
  }

  @GET
  @Path("pinjaman/{limitStart}/{recordToGet}/{orderBy}")
  @Produces("application/json")
  public Response pinjamanKredit(
          @PathParam("limitStart") int limitStart,
          @PathParam("recordToGet") int recordToGet,
          @PathParam("orderBy") String orderBy) {
    Response response = null;
    JSONObject jSONObject = pinjamanList("", limitStart, recordToGet, orderBy);
    return Response.status(Status.OK).entity(jSONObject.toString()).build();
  }

  @GET
  @Path("pinjaman/{oid}")
  @Produces("application/json")
  public Response pinjamanKredit(@PathParam("oid") long oid) {
    JSONObject jSONObject = new JSONObject();
    try {
      Pinjaman pinjaman = PstPinjaman.fetchExc(oid);

      jSONObject = PstPinjaman.fetchJSON(oid);
    } catch (Exception e) {
    }
    return Response.status(Status.OK).entity(jSONObject.toString()).build();
  }
  
  public JSONObject pinjamanList(String whereClause, int limitStart, int recordToGet, String orderBy){
  JSONObject jSONObject = new JSONObject();
    try {
      Vector listData = PstPinjaman.list(limitStart, recordToGet, whereClause, orderBy);
        Vector listDataAll = PstPinjaman.list(0,0,whereClause, orderBy);
        JSONArray jSONArray = new JSONArray();
      if(listData.size() > 0){
        for(int i = 0; i < listData.size(); i++){
        Pinjaman pinjaman = (Pinjaman) listData.get(i);
        JSONObject objData = new JSONObject();
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID], "" + pinjaman.getOID());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID], "" + pinjaman.getAnggotaId());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_TIPE_KREDIT_ID], "" + pinjaman.getTipeKreditId());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_KELOMPOK_ID], "" + pinjaman.getKelompokId());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN], "" + pinjaman.getTglPengajuan());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_LUNAS], "" + pinjaman.getTglLunas());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_JANGKA_WAKTU], "" + pinjaman.getJangkaWaktu());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_JATUH_TEMPO], "" + pinjaman.getJatuhTempo());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN], "" + pinjaman.getJumlahPinjaman());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN], "" + pinjaman.getStatusPinjaman());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI], "" + pinjaman.getTglRealisasi());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_ANGSURAN], "" + pinjaman.getJumlahAngsuran());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_KODE_KOLEKTIBILITAS], "" + pinjaman.getKodeKolektibilitas());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_KETERANGAN], "" + pinjaman.getKeterangan());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_SUKU_BUNGA], "" + pinjaman.getSukuBunga());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_TIPE_BUNGA], "" + pinjaman.getTipeBunga());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT], "" + pinjaman.getNoKredit());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_ASSIGN_TABUNGAN_ID], "" + pinjaman.getAssignTabunganId());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_ID_JENIS_SIMPANAN], "" + pinjaman.getIdJenisSimpanan());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_JENIS_TRANSAKSI_ID], "" + pinjaman.getIdJenisTransaksi());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_WAJIB_ID_JENIS_SIMPANAN], "" + pinjaman.getWajibIdJenisSimpanan());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_WAJIB_VALUE], "" + pinjaman.getWajibValue());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_WAJIB_VALUE_TYPE], "" + pinjaman.getWajibValueType());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_TIPE_JADWAL], "" + pinjaman.getTipeJadwal());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID], "" + pinjaman.getBillMainId());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_DOWN_PAYMENT], "" + pinjaman.getDownPayment());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_SISA_ANGSURAN], "" + pinjaman.getSisaAngsuran());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID], "" + pinjaman.getCollectorId());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID], "" + pinjaman.getAccountOfficerId());
        objData.put(PstPinjaman.fieldNames[PstPinjaman.FLD_JANGKA_WAKTU_ID], "" + pinjaman.getJangkaWaktuId());

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
