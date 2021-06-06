/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.searchtabungan;

import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import static com.dimata.qdep.form.I_FRMType.TYPE_COLLECTION;
import static com.dimata.qdep.form.I_FRMType.TYPE_INT;
import static com.dimata.qdep.form.I_FRMType.TYPE_LONG;
import static com.dimata.qdep.form.I_FRMType.TYPE_STRING;
import com.dimata.sedana.entity.reportsearch.RscReport;
import com.dimata.sedana.entity.searchtabungan.SearchTabungan;
import com.dimata.sedana.form.reportsearch.FrmRscReport;
import com.dimata.common.session.convert.Master;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Regen
 */
public class FrmSearchTabungan extends FRMHandler implements I_FRMInterface, I_FRMType {

  public static final String FRM_SRC_TABUNGAN = "FRM_SRC_TABUNGAN";

  public static final String[] fieldNames = {
    "START_DATE",
    "END_DATE",
    "NASABAH_NO_REKENING",
    "NASABAH_ID",
    "NASABAH_NAMA",
    "JENIS_SIMPANAN"
  };

  public static String FRM_FIELD_START_DATE = FrmSearchTabungan.fieldNames[0];
  public static String FRM_FIELD_END_DATE = FrmSearchTabungan.fieldNames[1];
  public static String FRM_FIELD_NASABAH_NO_REKENING = FrmSearchTabungan.fieldNames[2];
  public static String FRM_FIELD_NASABAH_ID = FrmSearchTabungan.fieldNames[3];
  public static String FRM_FIELD_NASABAH_NAMA = FrmSearchTabungan.fieldNames[4];
  public static String FRM_FIELD_JENIS_SIMPANAN = FrmSearchTabungan.fieldNames[5];

  public static final String[][] shortFieldNames = {};

  public static int[] fieldTypes = {
    TYPE_STRING,
    TYPE_STRING,
    TYPE_STRING,
    TYPE_LONG,
    TYPE_STRING,
    TYPE_COLLECTION
  };

  private SearchTabungan searchTabungan = new SearchTabungan();

  /**
   * Creates a new instance of FrmSrcActvity
   */
  public FrmSearchTabungan() {
  }

  public FrmSearchTabungan(HttpServletRequest request) {
    //super(new FrmSearchTabungan(), request);
    this.searchTabungan.setNama(FRMQueryString.requestString(request, FRM_FIELD_NASABAH_NAMA));
    this.searchTabungan.setNoRekening(FRMQueryString.requestString(request, FRM_FIELD_NASABAH_NO_REKENING));
    this.searchTabungan.setOID(FRMQueryString.requestLong(request, FRM_FIELD_NASABAH_ID));
    this.searchTabungan.setTanggalAwal(Master.string2Date(FRMQueryString.requestString(request, FRM_FIELD_START_DATE)));
    this.searchTabungan.setTanggalAkhir(Master.string2Date(FRMQueryString.requestString(request, FRM_FIELD_END_DATE)));
    String n = FRMQueryString.requestString(request, FRM_FIELD_JENIS_SIMPANAN); 
    if (!n.equals("") && !n.equals(null)) {
      this.searchTabungan.setIdJenisSimpanan(request.getParameterValues(FRM_FIELD_JENIS_SIMPANAN));
    }
  }

  public String[] getFieldNames() {
    return fieldNames;
  }

  public int getFieldSize() {
    return fieldNames.length;
  }

  public int[] getFieldTypes() {
    return fieldTypes;
  }

  public String getFormName() {
    return this.FRM_SRC_TABUNGAN;
  }

  public SearchTabungan getEntityObject() {
    return searchTabungan;
  }

}
