/* Generated by Together */

package com.dimata.aiso.form.arap;

import com.dimata.aiso.entity.arap.ArApItem;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;

import javax.servlet.http.HttpServletRequest;

public class FrmArApItem extends FRMHandler implements I_FRMInterface, I_FRMType {
    public static final String FRM_ARAP_ITEM = "FRM_ARAP_ITEM";
    public static final int FRM_ARAP_MAIN_ID = 0;
    public static final int FRM_ANGSURAN = 1;
    public static final int FRM_DUE_DATE = 2;
    public static final int FRM_DESCRIPTION = 3;
    public static final int FRM_ARAP_ITEM_STATUS = 4;
    public static final int FRM_LEFT_TO_PAY = 5;
    public static final int FRM_ID_CURRENCY = 6;
    public static final int FRM_RATE = 7;
    public static final int FRM_SELLING_AKTIVA_ID = 8;
    public static final int FRM_RECEIVE_AKTIVA_ID = 9;

    public static String[] fieldNames =
            {
                "FRM_ARAP_MAIN_ID",
                "FRM_ANGSURAN",
                "FRM_DUE_DATE",
                "FRM_ITEM_DESCRIPTION",
                "FRM_ARAP_ITEM_STATUS",
                "FRM_LEFT_TO_PAY",
                "FRM_ID_CURRENCY",
                "FRM_RATE",
                "FRM_SELLING_AKTIVA_ID",
                "FRM_RECEIVE_AKTIVA_ID"
            };

    public static int[] fieldTypes =
            {
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_DATE,
                TYPE_STRING,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_LONG
            };

    private ArApItem aktiva;

    public FrmArApItem(ArApItem aktiva) {
        this.aktiva = aktiva;
    }

    public FrmArApItem(HttpServletRequest request, ArApItem aktiva) {
        super(new FrmArApItem(aktiva), request);
        this.aktiva = aktiva;
    }

    public String getFormName() {
        return FRM_ARAP_ITEM;
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

    public ArApItem getEntityObject() {
        return aktiva;
    }

    public void requestEntityObject(ArApItem aktiva) {
        try {
            this.requestParam();
            aktiva.setArApMainId(this.getLong(FRM_ARAP_MAIN_ID));
            aktiva.setAngsuran(this.getDouble(FRM_ANGSURAN));
            aktiva.setDueDate(this.getDate(FRM_DUE_DATE));
            aktiva.setDescription(this.getString(FRM_DESCRIPTION));
            aktiva.setArApItemStatus(this.getInt(FRM_ARAP_ITEM_STATUS));
            aktiva.setLeftToPay(this.getDouble(FRM_LEFT_TO_PAY));
            aktiva.setCurrencyId(this.getLong(FRM_ID_CURRENCY));
            aktiva.setRate(this.getDouble(FRM_RATE));
            aktiva.setSellingAktivaId(this.getLong(FRM_SELLING_AKTIVA_ID));
            aktiva.setReceiveAktivaId(this.getLong(FRM_RECEIVE_AKTIVA_ID));
            this.aktiva = aktiva;
        } catch (Exception e) {
            aktiva = new ArApItem();
        }
    }
}
