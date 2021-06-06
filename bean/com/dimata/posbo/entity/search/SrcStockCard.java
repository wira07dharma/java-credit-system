/**
 * Created by IntelliJ IDEA.
 * User: gadnyana
 * Date: Feb 25, 2005
 * Time: 10:00:19 AM
 * To change this template use Options | File Templates.
 */
package com.dimata.posbo.entity.search;

import java.util.Date;
import java.util.Vector;

public class SrcStockCard {
    private int prevDays = 0;
    private long locationId = 0;
    private long materialId = 0;
    private Date stardDate = new Date();
    private Date endDate = new Date();
    private Vector docStatus = new Vector(1,1);

    public int getPrevDays() {
        return prevDays;
    }

    public void setPrevDays(int prevDays) {
        this.prevDays = prevDays;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getMaterialId() {
        return materialId;
    }

    public void setMaterialId(long materialId) {
        this.materialId = materialId;
    }

    public Date getStardDate() {
        return stardDate;
    }

    public void setStardDate(Date stardDate) {
        this.stardDate = stardDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public Vector getDocStatus() {
        return docStatus;
    }
    
    public void setDocStatus(Vector docStatus) {
        this.docStatus = docStatus;
    }
}
