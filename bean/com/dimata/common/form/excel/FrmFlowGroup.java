/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.form.excel;

import com.dimata.common.entity.excel.FlowGroup;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Gunadi
 */
public class FrmFlowGroup extends FRMHandler implements I_FRMInterface, I_FRMType {

    private FlowGroup entFlowGroup;
    public static final String FRM_NAME_FLOW_GROUP = "FRM_NAME_FLOW_GROUP";
    public static final int FRM_FIELD_FLOW_GROUP_ID = 0;
    public static final int FRM_FIELD_FLOW_GROUP_NAME = 1;
    public static final int FRM_FIELD_FLOW_GROUP_DESCRIPTION = 2;
    public static String[] fieldNames = {
        "FRM_FIELD_FLOW_GROUP_ID",
        "FRM_FIELD_FLOW_GROUP_NAME",
        "FRM_FIELD_FLOW_GROUP_DESCRIPTION"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmFlowGroup() {
    }

    public FrmFlowGroup(FlowGroup entFlowGroup) {
        this.entFlowGroup = entFlowGroup;
    }

    public FrmFlowGroup(HttpServletRequest request, FlowGroup entFlowGroup) {
        super(new FrmFlowGroup(entFlowGroup), request);
        this.entFlowGroup = entFlowGroup;
    }

    public String getFormName() {
        return FRM_NAME_FLOW_GROUP;
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

    public FlowGroup getEntityObject() {
        return entFlowGroup;
    }

    public void requestEntityObject(FlowGroup entFlowGroup) {
        try {
            this.requestParam();
            entFlowGroup.setFlowGroupName(getString(FRM_FIELD_FLOW_GROUP_NAME));
            entFlowGroup.setFlowGroupDescription(getString(FRM_FIELD_FLOW_GROUP_DESCRIPTION));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}