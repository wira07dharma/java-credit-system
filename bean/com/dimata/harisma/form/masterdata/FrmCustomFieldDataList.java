/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Gunadi
 */

/* java package */

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* qdep package */
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.harisma.entity.masterdata.*;

public class FrmCustomFieldDataList extends FRMHandler implements I_FRMInterface, I_FRMType{
     private CustomFieldDataList customFieldDataList;

    public static final String FRM_NAME_CUSTOM_FIELD_MASTER = "FRM_NAME_CUSTOM_FIELD_MASTER";

    public static final int FRM_FIELD_CUSTOM_FIELD_DATA_LIST_ID = 0;
    public static final int FRM_FIELD_DATA_LIST_CAPTION = 1;
    public static final int FRM_FIELD_DATA_LIST_VALUE = 2;
    public static final int FRM_FIELD_CUSTOM_FIELD_ID = 3;
    
    public static String[] fieldNames = {
       
        "FRM_FIELD_CUSTOM_FIELD_DATA_LIST_ID",
        "FRM_FIELD_DATA_LIST_CAPTION",
        "FRM_FIELD_DATA_LIST_VALUE",
        "FRM_FIELD_CUSTOM_FIELD_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_LONG
    };

    public FrmCustomFieldDataList() {
    }

    public FrmCustomFieldDataList(CustomFieldDataList customFieldDataList) {
        this.customFieldDataList = customFieldDataList;
    }

    public FrmCustomFieldDataList(HttpServletRequest request, CustomFieldDataList customFieldDataList) {
        super(new FrmCustomFieldDataList(customFieldDataList), request);
        this.customFieldDataList = customFieldDataList;
    }

    public String getFormName() {
        return FRM_NAME_CUSTOM_FIELD_MASTER;
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

    public CustomFieldDataList getEntityObject() {
        return customFieldDataList;
    }

    public void requestEntityObject(CustomFieldDataList customFieldDataList) {
        try {
            this.requestParam();
            customFieldDataList.setDataListCaption(getString(FRM_FIELD_DATA_LIST_CAPTION));
            customFieldDataList.setDataListValue(getString(FRM_FIELD_DATA_LIST_VALUE));
            customFieldDataList.setCustomFieldId(getLong(FRM_FIELD_CUSTOM_FIELD_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
