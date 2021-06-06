/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.form.excel;

import com.dimata.common.entity.excel.FlowModulMapping;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Gunadi
 */
public class FrmFlowModulMapping extends FRMHandler implements I_FRMInterface, I_FRMType {

    private FlowModulMapping entFlowModulMapping;
    public static final String FRM_NAME_FLOW_MODUL_MAPPING = "FRM_NAME_FLOW_MODUL_MAPPING";
    public static final int FRM_FIELD_FLOW_MODUL_MAPPING_ID = 0;
    public static final int FRM_FIELD_FLOW_MODUL_ID = 1;
    public static final int FRM_FIELD_FIELD_NAME = 2;
    public static final int FRM_FIELD_DATA_TYPE = 3;
    public static final int FRM_FIELD_COLUMN_NAME = 4;
    public static final int FRM_FIELD_DATA_EXAMPLE = 5;
    public static final int FRM_FIELD_COLUMN_LEVEL = 6;
    public static final int FRM_FIELD_TYPE = 7;
    public static final int FRM_FIELD_INPUT_TYPE = 8;
    public static final int FRM_FIELD_DATA_TABLE = 9;
    public static final int FRM_FIELD_DATA_COLUMN = 10;
    public static final int FRM_FIELD_DATA_VALUE = 11;
    public static String[] fieldNames = {
        "FRM_FIELD_FLOW_MODUL_MAPPING_ID",
        "FRM_FIELD_FLOW_MODUL_OID",
        "FRM_FIELD_FIELD_NAME",
        "FRM_FIELD_DATA_TYPE",
        "FRM_FIELD_COLUMN_NAME",
        "FRM_FIELD_DATA_EXAMPLE",
        "FRM_FIELD_COLUMN_LEVEL",
        "FRM_FIELD_TYPE",
        "FRM_FIELD_INPUT_TYPE",
        "FRM_FIELD_DATA_TABLE",
        "FRM_FIELD_DATA_COLUMN",
        "FRM_FIELD_DATA_VALUE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmFlowModulMapping() {
    }

    public FrmFlowModulMapping(FlowModulMapping entFlowModulMapping) {
        this.entFlowModulMapping = entFlowModulMapping;
    }

    public FrmFlowModulMapping(HttpServletRequest request, FlowModulMapping entFlowModulMapping) {
        super(new FrmFlowModulMapping(entFlowModulMapping), request);
        this.entFlowModulMapping = entFlowModulMapping;
    }

    public String getFormName() {
        return FRM_NAME_FLOW_MODUL_MAPPING;
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

    public FlowModulMapping getEntityObject() {
        return entFlowModulMapping;
    }

    public void requestEntityObject(FlowModulMapping entFlowModulMapping) {
        try {
            this.requestParam();
            entFlowModulMapping.setFlowModulId(getLong(FRM_FIELD_FLOW_MODUL_ID));
            entFlowModulMapping.setFieldName(getString(FRM_FIELD_FIELD_NAME));
            entFlowModulMapping.setDataType(getInt(FRM_FIELD_DATA_TYPE));
            entFlowModulMapping.setColumnName(getString(FRM_FIELD_COLUMN_NAME));
            entFlowModulMapping.setDataExample(getString(FRM_FIELD_DATA_EXAMPLE));
            entFlowModulMapping.setColumnLevel(getInt(FRM_FIELD_COLUMN_LEVEL));
            entFlowModulMapping.setType(getInt(FRM_FIELD_TYPE));
            entFlowModulMapping.setInputType(getInt(FRM_FIELD_INPUT_TYPE));
            entFlowModulMapping.setDataTable(getString(FRM_FIELD_DATA_TABLE));
            entFlowModulMapping.setDataColumn(getString(FRM_FIELD_DATA_COLUMN));
            entFlowModulMapping.setDataValue(getString(FRM_FIELD_DATA_VALUE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}