/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.form.excel;

import com.dimata.common.entity.excel.FlowMappingDataList;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Gunadi
 */
public class FrmFlowMappingDataList extends FRMHandler implements I_FRMInterface, I_FRMType {
  private FlowMappingDataList entFlowMappingDataList;
  public static final String FRM_NAME_FLOW_MAPPING_DATA_LIST = "FRM_NAME_FLOW_MAPPING_DATA_LIST";
  public static final int FRM_FIELD_FLOW_MAPPING_DATA_LIST_ID = 0;
  public static final int FRM_FIELD_FLOW_MAPPING_ID = 1;
  public static final int FRM_FIELD_DATA_VALUE = 2;
  public static final int FRM_FIELD_DATA_CAPTION = 3;


public static String[] fieldNames = {
    "FRM_FIELD_FLOW_MAPPING_DATA_LIST_ID",
    "FRM_FIELD_FLOW_MAPPING_ID",
    "FRM_FIELD_DATA_VALUE",
    "FRM_FIELD_DATA_CAPTION"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_LONG,
    TYPE_STRING,
    TYPE_STRING
};

public FrmFlowMappingDataList() {
}

public FrmFlowMappingDataList(FlowMappingDataList entFlowMappingDataList) {
this.entFlowMappingDataList = entFlowMappingDataList;
}

public FrmFlowMappingDataList(HttpServletRequest request, FlowMappingDataList entFlowMappingDataList) {
super(new FrmFlowMappingDataList(entFlowMappingDataList), request);
this.entFlowMappingDataList = entFlowMappingDataList;
}

public String getFormName() {
return FRM_NAME_FLOW_MAPPING_DATA_LIST;
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

public FlowMappingDataList getEntityObject() {
return entFlowMappingDataList;
}

public void requestEntityObject(FlowMappingDataList entFlowMappingDataList) {
try {
this.requestParam();
    entFlowMappingDataList.setFlowMappingId(getLong(FRM_FIELD_FLOW_MAPPING_ID));
    entFlowMappingDataList.setDataValue(getString(FRM_FIELD_DATA_VALUE));
    entFlowMappingDataList.setDataCaption(getString(FRM_FIELD_DATA_CAPTION));
} catch (Exception e) {
System.out.println("Error on requestEntityObject : " + e.toString());
}
}

}