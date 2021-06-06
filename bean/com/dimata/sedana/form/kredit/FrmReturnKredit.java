/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.kredit;

/**
 *
 * @author Regen
 */
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.sedana.entity.kredit.ReturnKredit;
import javax.servlet.http.HttpServletRequest;

public class FrmReturnKredit extends FRMHandler implements I_FRMInterface, I_FRMType {
  private ReturnKredit entReturnKredit;
  public static final String FRM_NAME_RETURNKREDIT = "FRM_NAME_RETURNKREDIT";
  public static final int FRM_FIELD_RETURN_ID = 0;
  public static final int FRM_FIELD_NOMOR_RETURN = 1;
  public static final int FRM_FIELD_PINJAMAN_ID = 2;
  public static final int FRM_FIELD_TRANSAKSI_ID = 3;
  public static final int FRM_FIELD_CASH_BILL_MAIN_ID = 4;
  public static final int FRM_FIELD_TANGGAL_RETURN = 5;
  public static final int FRM_FIELD_LOCATION_TRANSAKSI = 6;
  public static final int FRM_FIELD_STATUS = 7;
  public static final int FRM_FIELD_CATATAN = 8;
  public static final int FRM_FIELD_JENIS_RETURN = 9;


public static String[] fieldNames = {
    "FRM_FIELD_RETURNID",
    "FRM_FIELD_NOMOR_RETURN",
    "FRM_FIELD_PINJAMAN_ID",
    "FRM_FIELD_TRANSAKSI_ID",
    "FRM_FIELD_CASH_BILL_MAIN_ID",
    "FRM_FIELD_TANGGAL_RETURN",
    "FRM_FIELD_LOCATION_TRANSAKSI",
    "FRM_FIELD_STATUS",
    "FRM_FIELD_CATATAN",
    "FRM_FIELD_JENIS_RETURN"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_STRING,
    TYPE_LONG,
    TYPE_LONG,
    TYPE_LONG,
    TYPE_DATE,
    TYPE_LONG,
    TYPE_INT,
    TYPE_STRING
};

public FrmReturnKredit() {
}

public FrmReturnKredit(ReturnKredit entReturnKredit) {
this.entReturnKredit = entReturnKredit;
}

public FrmReturnKredit(HttpServletRequest request, ReturnKredit entReturnKredit) {
super(new FrmReturnKredit(entReturnKredit), request);
this.entReturnKredit = entReturnKredit;
}

public String getFormName() {
return FRM_NAME_RETURNKREDIT;
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

public ReturnKredit getEntityObject() {
return entReturnKredit;
}

public void requestEntityObject(ReturnKredit entReturnKredit) {
try {
this.requestParam();
    entReturnKredit.setNomorReturn(getString(FRM_FIELD_NOMOR_RETURN));
    entReturnKredit.setPinjamanId(getLong(FRM_FIELD_PINJAMAN_ID));
    entReturnKredit.setTransaksiId(getLong(FRM_FIELD_TRANSAKSI_ID));
    entReturnKredit.setCashBillMainId(getLong(FRM_FIELD_CASH_BILL_MAIN_ID));
    entReturnKredit.setTanggalReturn(getDate(FRM_FIELD_TANGGAL_RETURN));
    entReturnKredit.setLocationTransaksi(getLong(FRM_FIELD_LOCATION_TRANSAKSI));
    entReturnKredit.setStatus(getInt(FRM_FIELD_STATUS));
    entReturnKredit.setCatatan(getString(FRM_FIELD_CATATAN));
    entReturnKredit.setStatus(getInt(FRM_FIELD_JENIS_RETURN));
} catch (Exception e) {
System.out.println("Error on requestEntityObject : " + e.toString());
}
}

}