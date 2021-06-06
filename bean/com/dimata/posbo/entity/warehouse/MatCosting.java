package com.dimata.posbo.entity.warehouse;

import com.dimata.qdep.entity.Entity;

import java.util.Date;

public class MatCosting extends Entity {
    private long locationId = 0;
    private long costingTo = 0;
    private int locationType = 0;
    private Date costingDate = new Date();
    private String costingCode = "";
    private int costingCodeCounter = 0;
    private int costingStatus = 0;
    private String remark = "";
    private String invoiceSupplier = "";

    /** Holds value of property transferStatus. */
    private int transferStatus;
    private Date lastUpdate = new Date();

    //add costingId
    private long costingId = 0;


    public Date getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getCostingTo() {
        return costingTo;
    }

    public void setCostingTo(long costingTo) {
        this.costingTo = costingTo;
    }

    public int getLocationType() {
        return locationType;
    }

    public void setLocationType(int locationType) {
        this.locationType = locationType;
    }

    public Date getCostingDate() {
        return costingDate;
    }

    public void setCostingDate(Date costingDate) {
        this.costingDate = costingDate;
    }

    public String getCostingCode() {
        return costingCode;
    }

    public void setCostingCode(String costingCode) {
        if (costingCode == null) {
            costingCode = "";
        }
        this.costingCode = costingCode;
    }

    public int getCostingCodeCounter() {
        return costingCodeCounter;
    }

    public void setCostingCodeCounter(int costingCodeCounter) {
        this.costingCodeCounter = costingCodeCounter;
    }

    public int getCostingStatus() {
        return costingStatus;
    }

    public void setCostingStatus(int costingStatus) {
        this.costingStatus = costingStatus;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        if (remark == null) {
            remark = "";
        }
        this.remark = remark;
    }

    public String getInvoiceSupplier() {
        return invoiceSupplier;
    }

    public void setInvoiceSupplier(String invoiceSupplier) {
        if (invoiceSupplier == null) {
            invoiceSupplier = "";
        }
        this.invoiceSupplier = invoiceSupplier;
    }

    /** Getter for property transferStatus.
     * @return Value of property transferStatus.
     *
     */
    public int getTransferStatus() {
        return this.transferStatus;
    }

    /** Setter for property transferStatus.
     * @param transferStatus New value of property transferStatus.
     *
     */
    public void setTransferStatus(int transferStatus) {
        this.transferStatus = transferStatus;
    }

    /**
     * @return the costingId
     */
    public long getCostingId() {
        return costingId;
    }

    /**
     * @param costingId the costingId to set
     */
    public void setCostingId(long costingId) {
        this.costingId = costingId;
    }

}
