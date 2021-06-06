/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.masterdata;

/**
 *
 * @author Regen
 */
import com.dimata.sedana.entity.masterdata.SedanaShift;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.common.session.convert.Master;
import javax.servlet.http.HttpServletRequest;

public class FrmSedanaShift extends FRMHandler implements I_FRMInterface, I_FRMType {

  private SedanaShift entSedanaShift;
  public static final String FRM_NAME_SEDANA_SHIFT = "FRM_NAME_SEDANA_SHIFT";
  public static final int FRM_FIELD_SHIFT_ID = 0;
  public static final int FRM_FIELD_NAME = 1;
  public static final int FRM_FIELD_END_TIME = 2;
  public static final int FRM_FIELD_START_TIME = 3;
  public static final int FRM_FIELD_REMARK = 4;

  public static String[] fieldNames = {
    "FRM_FIELD_SHIFT_ID",
    "FRM_FIELD_NAME",
    "FRM_FIELD_END_TIME",
    "FRM_FIELD_START_TIME",
    "FRM_FIELD_REMARK"
  };

  public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_STRING,
    TYPE_STRING,
    TYPE_STRING,
    TYPE_STRING
  };

  public FrmSedanaShift() {
  }

  public FrmSedanaShift(SedanaShift entSedanaShift) {
    this.entSedanaShift = entSedanaShift;
  }

  public FrmSedanaShift(HttpServletRequest request, SedanaShift entSedanaShift) {
    super(new FrmSedanaShift(entSedanaShift), request);
    this.entSedanaShift = entSedanaShift;
  }

  public String getFormName() {
    return FRM_NAME_SEDANA_SHIFT;
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

  public SedanaShift getEntityObject() {
    return entSedanaShift;
  }

  public void requestEntityObject(SedanaShift entSedanaShift) {
    try {
      this.requestParam();
      entSedanaShift.setOID(getLong(FRM_FIELD_SHIFT_ID));
      entSedanaShift.setName(getString(FRM_FIELD_NAME));
      entSedanaShift.setRemark(getString(FRM_FIELD_REMARK));
    } catch (Exception e) {
      System.out.println("Error on requestEntityObject : " + e.toString());
    }
  }

}
