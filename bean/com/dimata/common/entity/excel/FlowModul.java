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
public class FlowModul extends Entity {

    private long flowGroupId = 0;
    private int flowLevel = 0;
    private String flowModulName = "";
    private String flowModulTable = "";

    public long getFlowGroupId() {
        return flowGroupId;
    }

    public void setFlowGroupId(long flowGroupId) {
        this.flowGroupId = flowGroupId;
    }

    public int getFlowLevel() {
        return flowLevel;
    }

    public void setFlowLevel(int flowLevel) {
        this.flowLevel = flowLevel;
    }

    /**
     * @return the flowModulName
     */
    public String getFlowModulName() {
        return flowModulName;
    }

    /**
     * @param flowModulName the flowModulName to set
     */
    public void setFlowModulName(String flowModulName) {
        this.flowModulName = flowModulName;
    }

    /**
     * @return the flowModulTable
     */
    public String getFlowModulTable() {
        return flowModulTable;
    }

    /**
     * @param flowModulTable the flowModulTable to set
     */
    public void setFlowModulTable(String flowModulTable) {
        this.flowModulTable = flowModulTable;
    }
    
}