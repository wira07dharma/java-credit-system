/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.form.excel;

import com.dimata.common.entity.excel.FlowModul;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;
/**
 *
 * @author Gunadi
 */
public class FrmFlowModul extends FRMHandler implements I_FRMInterface, I_FRMType {

    private FlowModul entFlowModul;
    public static final String FRM_NAME_FLOW_MODUL = "FRM_NAME_FLOW_MODUL";
    public static final int FRM_FIELD_FLOW_MODUL_ID = 0;
    public static final int FRM_FIELD_FLOW_GROUP_ID = 1;
    public static final int FRM_FIELD_FLOW_LEVEL = 2;
    public static final int FRM_FIELD_FLOW_MODUL_NAME = 3;
    public static final int FRM_FIELD_FLOW_MODUL_TABLE = 4;
    public static String[] fieldNames = {
        "FRM_FIELD_FLOW_MODUL_ID",
        "FRM_FIELD_FLOW_GROUP_ID",
        "FRM_FIELD_FLOW_LEVEL",
        "FRM_FIELD_FLOW_MODUL_NAME",
        "FRM_FIELD_FLOW_MODUL_TABLE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmFlowModul() {
    }

    public FrmFlowModul(FlowModul entFlowModul) {
        this.entFlowModul = entFlowModul;
    }

    public FrmFlowModul(HttpServletRequest request, FlowModul entFlowModul) {
        super(new FrmFlowModul(entFlowModul), request);
        this.entFlowModul = entFlowModul;
    }

    public String getFormName() {
        return FRM_NAME_FLOW_MODUL;
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

    public FlowModul getEntityObject() {
        return entFlowModul;
    }

    public void requestEntityObject(FlowModul entFlowModul) {
        try {
            this.requestParam();
            entFlowModul.setFlowGroupId(getLong(FRM_FIELD_FLOW_GROUP_ID));
            entFlowModul.setFlowLevel(getInt(FRM_FIELD_FLOW_LEVEL));
            entFlowModul.setFlowModulName(getString(FRM_FIELD_FLOW_MODUL_NAME));
            entFlowModul.setFlowModulTable(getString(FRM_FIELD_FLOW_MODUL_TABLE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}