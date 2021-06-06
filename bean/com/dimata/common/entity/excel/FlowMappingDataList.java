/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.entity.excel;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Gunadi
 */
public class FlowMappingDataList extends Entity {

    private long flowMappingId = 0;
    private String dataValue = "";
    private String dataCaption = "";

    public long getFlowMappingId() {
        return flowMappingId;
    }

    public void setFlowMappingId(long flowMappingId) {
        this.flowMappingId = flowMappingId;
    }

    public String getDataValue() {
        return dataValue;
    }

    public void setDataValue(String dataValue) {
        this.dataValue = dataValue;
    }

    public String getDataCaption() {
        return dataCaption;
    }

    public void setDataCaption(String dataCaption) {
        this.dataCaption = dataCaption;
    }
}