/* Generated by Together */

package com.dimata.aiso.form.aktiva;

import com.dimata.aiso.entity.aktiva.SellingAktiva;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;

import javax.servlet.http.HttpServletRequest;

public class FrmSellingAktiva extends FRMHandler implements I_FRMInterface, I_FRMType {
    public static final String FRM_SELLING_AKTIVA = "FRM_SELLING_AKTIVA";
    public static final int FRM_NOMOR_SELLING = 0;
    public static final int FRM_TANGGAL_SELLING = 1;
    public static final int FRM_KONSUMEN_ID = 2;
    public static final int FRM_TYPE_PEMBAYARAN = 3;
    public static final int FRM_ID_PERKIRAAN_PAYMENT = 4;
    public static final int FRM_ID_CURRENCY = 5;
    public static final int FRM_VALUE_RATE = 6;
    public static final int FRM_SELLING_STATUS = 7;
    public static final int FRM_SELLING_NOTE = 8;

    public static String[] fieldNames =
            {
                "FRM_NOMOR_SELLING",
                "FRM_TANGGAL_SELLING",
                "FRM_SUPPLIER_ID",
                "FRM_TYPE_PEMBAYARAN",
                "FRM_ID_PERKIRAAN_PAYMENT",
                "FRM_ID_CURRENCY",
                "FRM_VALUE_RATE",
                "FRM_SELLING_STATUS",
                "FRM_SELLING_NOTE"
            };

    public static int[] fieldTypes =
            {
                TYPE_STRING,
                TYPE_DATE,
                TYPE_LONG,
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_STRING
            };

    private SellingAktiva aktiva;

    public FrmSellingAktiva(SellingAktiva aktiva) {
        this.aktiva = aktiva;
    }

    public FrmSellingAktiva(HttpServletRequest request, SellingAktiva aktiva) {
        super(new FrmSellingAktiva(aktiva), request);
        this.aktiva = aktiva;
    }

    public String getFormName() {
        return FRM_SELLING_AKTIVA;
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

    public SellingAktiva getEntityObject() {
        return aktiva;
    }

    public void requestEntityObject(SellingAktiva aktiva) {
        try {
            this.requestParam();
            aktiva.setNomorSelling(this.getString(FRM_NOMOR_SELLING));
            aktiva.setTanggalSelling(this.getDate(FRM_TANGGAL_SELLING));
            aktiva.setSupplierId(this.getLong(FRM_KONSUMEN_ID));
            aktiva.setTypePembayaran(this.getInt(FRM_TYPE_PEMBAYARAN));
            aktiva.setIdPerkiraanPayment(this.getLong(FRM_ID_PERKIRAAN_PAYMENT));
            aktiva.setIdCurrency(this.getLong(FRM_ID_CURRENCY));
            aktiva.setValueRate(this.getDouble(FRM_VALUE_RATE));
            aktiva.setSellingStatus(this.getInt(FRM_SELLING_STATUS));
            aktiva.setNote(this.getString(FRM_SELLING_NOTE));

            this.aktiva = aktiva;
        } catch (Exception e) {
            aktiva = new SellingAktiva();
        }
    }
}
