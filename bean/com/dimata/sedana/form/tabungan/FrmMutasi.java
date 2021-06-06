/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.sedana.form.tabungan;

import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.tabungan.MutasiParam;
import com.dimata.common.session.convert.Master;
import static com.dimata.common.session.convert.Master.string2Date;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Regen
 */
public class FrmMutasi {
  private MutasiParam mutasiParam = new MutasiParam();
  public static final String FRM_FIELD_TANGGAL_AWAL = "tgl_awal";
  public static final String FRM_FIELD_TANGGAL_AKHIR = "tgl_akhir";
  public static final String FRM_FIELD_ID_MEMBER = "member";
  public static final String FRM_FIELD_MEMBER_REKENING = "member_rek";
  public static final String FRM_FIELD_MEMBER_NAMA = "member_name";
  public static final String FRM_FIELD_ID_JENIS_TRANSAKSI = "jenis_simpanan";

  public FrmMutasi(HttpServletRequest request) {
    this.mutasiParam.setIdMember(FRMQueryString.requestLong(request, FRM_FIELD_ID_MEMBER));
    String tglAwal = FRMQueryString.requestString(request, FRM_FIELD_TANGGAL_AWAL);
    Date tmpAWal = new Date();
    tmpAWal.setMonth(tmpAWal.getMonth()-1);
    Date tAwal = (tglAwal.equals("")|| tglAwal.equals(null)) ? tmpAWal : Master.string2Date(tglAwal);
    this.mutasiParam.setTanggalAwal(tAwal); 
    String tglAkhir = FRMQueryString.requestString(request, FRM_FIELD_TANGGAL_AKHIR);
    Date tmpAkhir = new Date();
    tmpAkhir.setDate(tmpAkhir.getDate());
    this.mutasiParam.setTanggalAkhir((tglAkhir.equals("")|| tglAkhir.equals(null)) ? tmpAkhir : Master.string2Date(tglAkhir));
    this.mutasiParam.setMemberNama(FRMQueryString.requestString(request, FRM_FIELD_MEMBER_NAMA));
    this.mutasiParam.setMemberRekening(FRMQueryString.requestString(request, FRM_FIELD_MEMBER_REKENING));
    String[] idjt = request.getParameterValues(FRM_FIELD_ID_JENIS_TRANSAKSI);
    if(idjt != null) {this.mutasiParam.setIdJenisSimpanan(idjt);}
  }

  /**
   * @return the mutasiParam
   */
  public MutasiParam getMutasiParam() {
    return mutasiParam;
  }
}
