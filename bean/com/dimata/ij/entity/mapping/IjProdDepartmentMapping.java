/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.ij.entity.mapping;

/* package java */ 
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

/**
 *
 * @author Mirahu
 */
public class IjProdDepartmentMapping extends Entity  {
    
    private long ijMapLocationId;
    private long prodDepartmentId;

    /**
     * @return the ijMapLocationId
     */
    public long getIjMapLocationId() {
        return ijMapLocationId;
    }

    /**
     * @param ijMapLocationId the ijMapLocationId to set
     */
    public void setIjMapLocationId(long ijMapLocationId) {
        this.ijMapLocationId = ijMapLocationId;
    }

    /**
     * @return the prodDepartmentId
     */
    public long getProdDepartmentId() {
        return prodDepartmentId;
    }

    /**
     * @param prodDepartmentId the prodDepartmentId to set
     */
    public void setProdDepartmentId(long prodDepartmentId) {
        this.prodDepartmentId = prodDepartmentId;
    }
    
    


}
