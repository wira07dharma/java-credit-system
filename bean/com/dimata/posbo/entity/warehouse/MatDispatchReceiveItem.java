/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.posbo.entity.warehouse;

/*package java */
import java.util.Date;

/*package qdep */
import com.dimata.qdep.entity.*;

public class MatDispatchReceiveItem extends Entity {

 
    private long dfRecGroupId = 0;
    private long dispatchMaterialId= 0;
    private MatDispatchItem sourceItem=new MatDispatchItem();
    private MatReceiveItem targetItem=new MatReceiveItem();


    /**
     * @return the dfRecGroupId
     */
    public long getDfRecGroupId() {
        return dfRecGroupId;
    }

    /**
     * @param dfRecGroupId the dfRecGroupId to set
     */
    public void setDfRecGroupId(long dfRecGroupId) {
        this.dfRecGroupId = dfRecGroupId;
    }

    /**
     * @return the dispatchMaterialId
     */
    public long getDispatchMaterialId() {
        return dispatchMaterialId;
    }

    /**
     * @param dispatchMaterialId the dispatchMaterialId to set
     */
    public void setDispatchMaterialId(long dispatchMaterialId) {
        this.dispatchMaterialId = dispatchMaterialId;
    }

    /**
     * @return the sourceItem
     */
    public MatDispatchItem getSourceItem() {
        if(sourceItem==null)
        {
            sourceItem = new MatDispatchItem();
        }
        return sourceItem;
    }

    /**
     * @param sourceItem the sourceItem to set
     */
    public void setSourceItem(MatDispatchItem sourceItem) {
        this.sourceItem = sourceItem;
    }

    /**
     * @return the targetItem
     */
    public MatReceiveItem getTargetItem() {
        if(targetItem==null)
        {
          targetItem = new MatReceiveItem();
        }
        return targetItem;
    }

    /**
     * @param targetItem the targetItem to set
     */
    public void setTargetItem(MatReceiveItem targetItem) {
        this.targetItem = targetItem;
    }
}
