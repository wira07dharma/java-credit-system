package com.dimata.posbo.form.masterdata;

/* java package */

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* qdep package */
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.posbo.entity.masterdata.*;

public class FrmMaterial extends FRMHandler implements I_FRMInterface, I_FRMType {
    private Material material;

    public static final String FRM_NAME_MATERIAL = "FRM_NAME_MATERIAL";

    public static final int FRM_FIELD_MATERIAL_ID = 0;
    public static final int FRM_FIELD_SKU = 1;
    public static final int FRM_FIELD_BARCODE = 2;
    public static final int FRM_FIELD_NAME = 3;
    public static final int FRM_FIELD_MERK_ID = 4;
    public static final int FRM_FIELD_CATEGORY_ID = 5;
    public static final int FRM_FIELD_SUB_CATEGORY_ID = 6;
    public static final int FRM_FIELD_DEFAULT_STOCK_UNIT_ID = 7;
    public static final int FRM_FIELD_DEFAULT_PRICE = 8;
    public static final int FRM_FIELD_DEFAULT_PRICE_CURRENCY_ID = 9;
    public static final int FRM_FIELD_DEFAULT_COST = 10;
    public static final int FRM_FIELD_DEFAULT_COST_CURRENCY_ID = 11;
    public static final int FRM_FIELD_DEFAULT_SUPPLIER_TYPE = 12;
    public static final int FRM_FIELD_SUPPLIER_ID = 13;
    public static final int FRM_FIELD_PRICE_TYPE_01 = 14;
    public static final int FRM_FIELD_PRICE_TYPE_02 = 15;
    public static final int FRM_FIELD_PRICE_TYPE_03 = 16;
    public static final int FRM_FIELD_MATERIAL_TYPE = 17;

    public static final int FRM_FIELD_LAST_DISCOUNT = 18;
    public static final int FRM_FIELD_LAST_VAT = 19;
    public static final int FRM_FIELD_CURR_BUY_PRICE = 20;
    public static final int FRM_FIELD_BUY_UNIT_ID = 21;
    public static final int FRM_FIELD_EXPIRED_DATE = 22;
    public static final int FRM_FIELD_PROFIT = 23;
    public static final int FRM_FIELD_CURR_SELL_PRICE_RECOMENTATION = 24;

    public static final int FRM_FIELD_AVERAGE_PRICE = 25;
    public static final int FRM_FIELD_MINIMUM_POINT = 26;
    public static final int FRM_FIELD_REQUIRED_SERIAL_NUMBER = 27;
    public static final int FRM_FIELD_LAST_UPDATE = 28;
    public static final int FRM_FIELD_PROCESS_STATUS = 29;
    public static final int FRM_FIELD_CONSIGMENT_TYPE = 30;
    public static final int FRM_FIELD_GONDOLA_CODE = 31;
    public static final int FRM_FIELD_MATERIAL_DESCRIPTION = 32;
    
    public static String[] fieldNames =
            {
                "FRM_FIELD_MATERIAL_ID",
                "FRM_FIELD_SKU",
                "FRM_FIELD_BARCODE",
                "FRM_FIELD_NAME",
                "FRM_FIELD_MERK_ID",
                "FRM_FIELD_CATEGORY_ID",
                "FRM_FIELD_SUB_CATEGORY_ID",
                "FRM_FIELD_DEFAULT_STOCK_UNIT_ID",
                "FRM_FIELD_DEFAULT_PRICE",
                "FRM_FIELD_DEFAULT_PRICE_CURRENCY_ID",
                "FRM_FIELD_DEFAULT_COST",
                "FRM_FIELD_DEFAULT_COST_CURRENCY_ID",
                "FRM_FIELD_DEFAULT_SUPPLIER_TYPE",
                "FRM_FIELD_SUPPLIER_ID",
                "FRM_FIELD_PRICE_TYPE_01",
                "FRM_FIELD_PRICE_TYPE_02",
                "FRM_FIELD_PRICE_TYPE_03",
                "FRM_FIELD_MATERIAL_TYPE",
                "FRM_FIELD_LAST_DISCOUNT",
                "FRM_FIELD_LAST_VAT",
                "FRM_FIELD_CURR_BUY_PRICE",
                "FRM_FIELD_BUY_UNIT_ID",
                "FRM_FIELD_EXPIR ED_DATE",
                "FRM_FIELD_PROFIT",
                "FRM_FIELD_CURR_SELL_PRICE_RECOMENTATION",
                "FRM_FIELD_AVERAGE_PRICE",
                "FRM_FIELD_MINIMUM_POINT",
                "FRM_FIELD_REQUIRED_SERIAL_NUMBER",
                "FRM_FIELD_LAST_UPDATE",
                "FRM_FIELD_PROCESS_STATUS",
                "FRM_FIELD_CONSIGMENT_TYPE",
                "FRM_FIELD_GONDOLA_CODE",
                "FRM_FIELD_MATERIAL_DESCRIPTION"
            };

    public static int[] fieldTypes =
            {
                TYPE_LONG,
                TYPE_STRING + ENTRY_REQUIRED,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_INT,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_DATE,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,//*
                TYPE_INT,
                TYPE_INT,
                TYPE_DATE,
                TYPE_INT,
                TYPE_INT,
                TYPE_STRING,
                TYPE_STRING
            };

    public FrmMaterial() {
    }

    public FrmMaterial(Material material) {
        this.material = material;
    }

    public FrmMaterial(HttpServletRequest request, Material material) {
        super(new FrmMaterial(material), request);
        this.material = material;
    }

    public String getFormName() {
        return FRM_NAME_MATERIAL;
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

    public Material getEntityObject() {
        return material;
    }

    public void requestEntityObject(Material material) {
        try {
            this.requestParam();
            material.setSku(getString(FRM_FIELD_SKU));
            material.setBarCode(getString(FRM_FIELD_BARCODE));
            material.setName(getString(FRM_FIELD_NAME)); 
            material.setMerkId(getLong(FRM_FIELD_MERK_ID));
            material.setCategoryId(getLong(FRM_FIELD_CATEGORY_ID));
            material.setSubCategoryId(getLong(FRM_FIELD_SUB_CATEGORY_ID));
            material.setDefaultStockUnitId(getLong(FRM_FIELD_DEFAULT_STOCK_UNIT_ID));
            material.setDefaultPrice(getDouble(FRM_FIELD_DEFAULT_PRICE));
            material.setDefaultPriceCurrencyId(getLong(FRM_FIELD_DEFAULT_PRICE_CURRENCY_ID));
            material.setDefaultCost(getDouble(FRM_FIELD_DEFAULT_COST));
            material.setDefaultCostCurrencyId(getLong(FRM_FIELD_DEFAULT_COST_CURRENCY_ID));
            material.setDefaultSupplierType(getInt(FRM_FIELD_DEFAULT_SUPPLIER_TYPE));
            material.setSupplierId(getLong(FRM_FIELD_SUPPLIER_ID));
            material.setPriceType01(getDouble(FRM_FIELD_PRICE_TYPE_01));
            material.setPriceType02(getDouble(FRM_FIELD_PRICE_TYPE_02));
            material.setPriceType03(getDouble(FRM_FIELD_PRICE_TYPE_03));
            material.setMaterialType(getInt(FRM_FIELD_MATERIAL_TYPE));

            // NEW
            material.setLastDiscount(getDouble(FRM_FIELD_LAST_DISCOUNT));
            material.setLastVat(getDouble(FRM_FIELD_LAST_VAT));
            material.setCurrBuyPrice(getDouble(FRM_FIELD_CURR_BUY_PRICE));
            material.setBuyUnitId(getLong(FRM_FIELD_BUY_UNIT_ID));
            material.setExpiredDate(getDate(FRM_FIELD_EXPIRED_DATE));

            material.setProfit(getDouble(FRM_FIELD_PROFIT));
            material.setCurrSellPriceRecomentation(getDouble(FRM_FIELD_CURR_SELL_PRICE_RECOMENTATION));
            
            material.setAveragePrice(getDouble(FRM_FIELD_AVERAGE_PRICE));
            material.setMinimumPoint(getInt(FRM_FIELD_MINIMUM_POINT));
            material.setRequiredSerialNumber(getInt(FRM_FIELD_REQUIRED_SERIAL_NUMBER));
            material.setLastUpdate(getDate(FRM_FIELD_LAST_UPDATE));
            material.setProcessStatus(getInt(FRM_FIELD_PROCESS_STATUS));
            material.setMatTypeConsig(getInt(FRM_FIELD_CONSIGMENT_TYPE));
            
            material.setGondolaCode(getString(FRM_FIELD_GONDOLA_CODE));
            material.setDescription(getString(FRM_FIELD_MATERIAL_DESCRIPTION));
        } catch (Exception e) { 
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
