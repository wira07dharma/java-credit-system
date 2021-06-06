/* Generated by Together */
package com.dimata.aiso.form.search;

import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.aiso.entity.search.SrcModulAktiva;

import javax.servlet.http.HttpServletRequest;

public class FrmSrcModulAktiva extends FRMHandler implements I_FRMInterface, I_FRMType {

  public static final String FRM_SEARCH_MODUL_AKTIVA = "FRM_SEARCH_MODUL_AKTIVA";
  public static final int FRM_SEARCH_KODE_AKTIVA = 0;
  public static final int FRM_SEARCH_NAMA_AKTIVA = 1;
  public static final int FRM_SEARCH_JENIS_AKTIVA_ID = 2;
  public static final int FRM_SEARCH_TIPE_PENYUSUTAN_ID = 3;
  public static final int FRM_SEARCH_METODE_PENYUSUTAN_ID = 4;

  public static String[] fieldNames = {
    "FRM_SEARCH_KODE_AKTIVA",
    "FRM_SEARCH_NAMA_AKTIVA",
    "FRM_SEARCH_JENIS_AKTIVA_ID",
    "FRM_SEARCH_TIPE_PENYUSUTAN_ID",
    "FRM_SEARCH_METODE_PENYUSUTAN_ID"
  };

  public static int[] fieldTypes = {
    TYPE_STRING,
    TYPE_STRING,
    TYPE_LONG,
    TYPE_LONG,
    TYPE_LONG
  };

  private SrcModulAktiva srcModulAktiva = new SrcModulAktiva();

  public FrmSrcModulAktiva() {
  }

  public FrmSrcModulAktiva(HttpServletRequest request) {
    super(new FrmSrcModulAktiva(), request);
  }

  public String getFormName() {
    return this.FRM_SEARCH_MODUL_AKTIVA;
  }

  public int[] getFieldTypes() {
    return fieldTypes;
  }

  public String[] getFieldNames() {
    return fieldNames;
  }

  public int getFieldSize() {
    return fieldNames.length;
  }

  public SrcModulAktiva getEntityObject() {
    return srcModulAktiva;
  }

  public void requestEntityObject(SrcModulAktiva srcModulAktiva) {
    try {
      this.requestParam();

      srcModulAktiva.setKodeAktiva(getString(FRM_SEARCH_KODE_AKTIVA));
      srcModulAktiva.setNamaAktiva(getString(FRM_SEARCH_NAMA_AKTIVA));
      srcModulAktiva.setJenisAktivaId(getLong(FRM_SEARCH_JENIS_AKTIVA_ID));
      srcModulAktiva.setTipePenyusutanId(getLong(FRM_SEARCH_TIPE_PENYUSUTAN_ID));
      srcModulAktiva.setMetodepenyusutanId(getLong(FRM_SEARCH_METODE_PENYUSUTAN_ID));

      this.srcModulAktiva = srcModulAktiva;
    } catch (Exception e) {
      System.out.println("EXC...");
      srcModulAktiva = new SrcModulAktiva();
    }
  }
}
