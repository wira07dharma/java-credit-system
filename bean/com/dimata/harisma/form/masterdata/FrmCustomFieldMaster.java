/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Hendra McHen
 */
import com.dimata.harisma.entity.masterdata.CustomFieldMaster;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmCustomFieldMaster extends FRMHandler implements I_FRMInterface, I_FRMType {

    private CustomFieldMaster entCustomFieldMaster;
    public static final String FRM_NAME_CUSTOM_FIELD_MASTER = "FRM_NAME_CUSTOM_FIELD_MASTER";
    public static final int FRM_FIELD_CUSTOM_FIELD_ID = 0;
    public static final int FRM_FIELD_FIELD_NAME = 1;
    public static final int FRM_FIELD_FIELD_TYPE = 2;
    public static final int FRM_FIELD_REQUIRED = 3;
    public static final int FRM_FIELD_DATA_LIST = 4;
    public static final int FRM_FIELD_INPUT_TYPE = 5;
    public static final int FRM_FIELD_SHOW_FIELD = 6;
    public static final int FRM_FIELD_NOTE = 7;
    public static final int FRM_FIELD_FULL_ACCESS = 8;
    public static final int FRM_FIELD_MODUL = 9;
    public static final int FRM_FIELD_MODUL_FIELD = 10;
    public static final int FRM_FIELD_MODUL_FIELD_VALUE = 11;

    public static String[] fieldNames = {
        "FRM_FIELD_CUSTOM_FIELD_ID",
        "FRM_FIELD_FIELD_NAME",
        "FRM_FIELD_FIELD_TYPE",
        "FRM_FIELD_REQUIRED",
        "FRM_FIELD_DATA_LIST",
        "FRM_FIELD_INPUT_TYPE",
        "FRM_FIELD_SHOW_FIELD",
        "FRM_FIELD_NOTE",
        "FRM_FIELD_FULL_ACCESS",
        "FRM_FIELD_MODUL",
        "FRM_FIELD_MODUL_FIELD",
        "FRM_FIELD_MODUL_FIELD_VALUE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING
    };

    private String[] showFields;
    private String dataList;
    
    public FrmCustomFieldMaster() {
    }

    public FrmCustomFieldMaster(CustomFieldMaster entCustomFieldMaster) {
        this.entCustomFieldMaster = entCustomFieldMaster;
    }

    public FrmCustomFieldMaster(HttpServletRequest request, CustomFieldMaster entCustomFieldMaster) {
        super(new FrmCustomFieldMaster(entCustomFieldMaster), request);
        this.entCustomFieldMaster = entCustomFieldMaster;
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

    public CustomFieldMaster getEntityObject() {
        return entCustomFieldMaster;
    }

    public void requestEntityObject(CustomFieldMaster entCustomFieldMaster) {
        try {
            this.requestParam();
            entCustomFieldMaster.setFieldName(getString(FRM_FIELD_FIELD_NAME));
            entCustomFieldMaster.setFieldType(getInt(FRM_FIELD_FIELD_TYPE));
            entCustomFieldMaster.setRequired(getInt(FRM_FIELD_REQUIRED));
            entCustomFieldMaster.setDataList(getDataList());
            entCustomFieldMaster.setInputType(getInt(FRM_FIELD_INPUT_TYPE));
            entCustomFieldMaster.setShowField(getCombineShow());
            entCustomFieldMaster.setNote(getString(FRM_FIELD_NOTE));
            entCustomFieldMaster.setFullAccess(getInt(FRM_FIELD_FULL_ACCESS));
            entCustomFieldMaster.setModul(getInt(FRM_FIELD_MODUL));
            entCustomFieldMaster.setModulField(getInt(FRM_FIELD_MODUL_FIELD));
            entCustomFieldMaster.setModulFieldValue(getString(FRM_FIELD_MODUL_FIELD_VALUE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
    public String[] getShowFields() {
        return showFields;
    }

    /**
     * @param empCategory the empCategory to set
     */
    public void setShowFields(String[] showField) {
        this.showFields = showField;
    }
    
    public String getCombineShow() {
        String[] showFieldCheck = getShowFields();
        String checkValues = "";
        if (showFieldCheck != null) {
            for (int i = 0; i < showFieldCheck.length; ++i) {
                if (i != showFieldCheck.length - 1) {
                    checkValues = checkValues + showFieldCheck[i] + ",";
                } else {
                    checkValues = checkValues + showFieldCheck[i];
                }
            }
        } else {
            checkValues = "";
        }
        return checkValues;
    }

    /**
     * @return the dataList
     */
    public String getDataList() {
        return dataList;
    }

    /**
     * @param dataList the dataList to set
     */
    public void setDataList(String dataList) {
        this.dataList = dataList;
    }

}
