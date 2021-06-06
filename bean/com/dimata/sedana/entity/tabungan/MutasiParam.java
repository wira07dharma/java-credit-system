/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.sedana.entity.tabungan;

import com.dimata.qdep.entity.Entity;
import static com.dimata.common.session.convert.Master.*;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Regen
 */
public class MutasiParam {
  private Date tanggalAwal = null;
  private Date tanggalAkhir = null;
  private long idMember = 0;
  private String memberRekening = "";
  private String memberNama = "";
  private Vector<Long> idJenisSimpanan = new Vector<Long>();

  /**
   * @return the tanggalAwal
   */
  public Date getTanggalAwal() {
    return tanggalAwal;
  }

  /**
   * @param tanggalAwal the tanggalAwal to set
   */
  public void setTanggalAwal(Date tanggalAwal) {
    this.tanggalAwal = tanggalAwal;
  }

  /**
   * @return the tanggalAkhir
   */
  public Date getTanggalAkhir() {
    return tanggalAkhir;
  }

  /**
   * @param tanggalAkhir the tanggalAkhir to set
   */
  public void setTanggalAkhir(Date tanggalAkhir) {
    this.tanggalAkhir = tanggalAkhir;
  }

  /**
   * @return the idMember
   */
  public long getIdMember() {
    return idMember;
  }

  /**
   * @param idMember the idMember to set
   */
  public void setIdMember(long idMember) {
    this.idMember = idMember;
  }

  /**
   * @return the idJenisTransaksi
   */
  public String getCombinedIdJenisSimpanan() {
    return implode(",", idJenisSimpanan);
  }

  /**
   * @return the idJenisTransaksi
   */
  public Vector getIdJenisSimpanan() {
    return idJenisSimpanan;
  }
  
  public boolean isIdJenisSimpanan(long idjt) {
    for(long id: idJenisSimpanan) {
      if(id==idjt){
        return true;
      }
    }
    
    return false;
  }

  /**
   * @param idJenisTransaksi the idJenisTransaksi to set
   */
  public void setIdJenisSimpanan(String[] idJenisTransaksi) {
    for(String s: idJenisTransaksi) {
      this.idJenisSimpanan.add(Long.valueOf(s));
    }
  }

  /**
   * @return the memberRekening
   */
  public String getMemberRekening() {
    return memberRekening;
  }

  /**
   * @param memberRekening the memberRekening to set
   */
  public void setMemberRekening(String memberRekening) {
    this.memberRekening = memberRekening;
  }

  /**
   * @return the memberNama
   */
  public String getMemberNama() {
    return memberNama;
  }

  /**
   * @param memberNama the memberNama to set
   */
  public void setMemberNama(String memberNama) {
    this.memberNama = memberNama;
  }
}
