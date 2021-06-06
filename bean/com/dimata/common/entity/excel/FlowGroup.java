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
public class FlowGroup extends Entity {

    private String flowGroupName = "";
    private String flowGroupDescription = "";

    public String getFlowGroupName() {
        return flowGroupName;
    }

    public void setFlowGroupName(String flowGroupName) {
        this.flowGroupName = flowGroupName;
    }

    public String getFlowGroupDescription() {
        return flowGroupDescription;
    }

    public void setFlowGroupDescription(String flowGroupDescription) {
        this.flowGroupDescription = flowGroupDescription;
    }
}