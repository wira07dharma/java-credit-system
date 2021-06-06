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
import com.dimata.sedana.entity.masterdata.JangkaWaktuMarkup;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmJangkaWaktuMarkup extends FRMHandler implements I_FRMInterface, I_FRMType {

  private JangkaWaktuMarkup entJangkaWaktuMarkup;
  public static final String FRM_NAME_JANGKA_WAKTU_MARKUP = "FRM_NAME_JANGKA_WAKTU_MARKUP";
  public static final int FRM_FIELD_JANGKA_WAKTU_MARKUP_ID = 0;
  public static final int FRM_FIELD_MARKUP_PCT = 1;
  public static final int FRM_FIELD_MARKUP_TYPE = 2;
  public static final int FRM_FIELD_USE_AS_CASH_CALCULATION = 3;

  public static String[] fieldNames = {
    "FRM_FIELD_JANGKA_WAKTU_MARKUP_ID",
    "FRM_FIELD_MARKUP_PCT",
    "FRM_FIELD_MARKUP_TYPE",
    "FRM_FIELD_USE_AS_CASH_CALCULATION"
  };

  public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_INT,
    TYPE_INT,
    TYPE_INT
  };

  public FrmJangkaWaktuMarkup() {
  }

  public FrmJangkaWaktuMarkup(JangkaWaktuMarkup entJangkaWaktuMarkup) {
    this.entJangkaWaktuMarkup = entJangkaWaktuMarkup;
  }

  public FrmJangkaWaktuMarkup(HttpServletRequest request, JangkaWaktuMarkup entJangkaWaktuMarkup) {
    super(new FrmJangkaWaktuMarkup(entJangkaWaktuMarkup), request);
    this.entJangkaWaktuMarkup = entJangkaWaktuMarkup;
  }

  public String getFormName() {
    return FRM_NAME_JANGKA_WAKTU_MARKUP;
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

  public JangkaWaktuMarkup getEntityObject() {
    return entJangkaWaktuMarkup;
  }

  public void requestEntityObject(JangkaWaktuMarkup entJangkaWaktuMarkup) {
    try {
      this.requestParam();
      entJangkaWaktuMarkup.setMarkupPct(getInt(FRM_FIELD_MARKUP_PCT));
      entJangkaWaktuMarkup.setMarkupType(getInt(FRM_FIELD_MARKUP_TYPE));
      entJangkaWaktuMarkup.setCashCalculation(getInt(FRM_FIELD_USE_AS_CASH_CALCULATION));
    } catch (Exception e) { 
      System.out.println("Error on requestEntityObject : " + e.toString());
    }
  }

}
