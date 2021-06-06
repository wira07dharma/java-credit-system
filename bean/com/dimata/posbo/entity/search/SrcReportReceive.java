package com.dimata.posbo.entity.search;

/* package java */
import java.util.*;

public class SrcReportReceive {
    
    private long locationId = 0;
    private long shiftId = 0;
    private long operatorId = 0;
    private long supplierId = 0;
    private long categoryId = 0;
    private long subCategoryId = 0;
    private Date dateFrom = new Date();
    private Date dateTo = new Date();
    private int sortBy;
    private int receiveSource = -1;
    private long receiveFrom = 0;
    private long currencyId = 0;
    
    public long getLocationId() {
        return locationId;
    }
    
    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }
    
    public long getShiftId() {
        return shiftId;
    }
    
    public void setShiftId(long shiftId) {
        this.shiftId = shiftId;
    }
    
    public long getOperatorId() {
        return operatorId;
    }
    
    public void setOperatorId(long operatorId) {
        this.operatorId = operatorId;
    }
    
    public long getSupplierId() {
        return supplierId;
    }
    
    public void setSupplierId(long supplierId) {
        this.supplierId = supplierId;
    }
    
    public long getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }
    
    public long getSubCategoryId() {
        return subCategoryId;
    }
    
    public void setSubCategoryId(long subCategoryId) {
        this.subCategoryId = subCategoryId;
    }
    
    public Date getDateFrom() {
        return dateFrom;
    }
    
    public void setDateFrom(Date dateFrom) {
        this.dateFrom = dateFrom;
    }
    
    public Date getDateTo() {
        return dateTo;
    }
    
    public void setDateTo(Date dateTo) {
        this.dateTo = dateTo;
    }
    
    public int getSortBy() {
        return sortBy;
    }
    
    public void setSortBy(int sortBy) {
        this.sortBy = sortBy;
    }
    
    public int getReceiveSource() {
        return receiveSource;
    }
    
    public void setReceiveSource(int receiveSource) {
        this.receiveSource = receiveSource;
    }
    
    public long getReceiveFrom() {
        return receiveFrom;
    }
    
    public void setReceiveFrom(long receiveFrom) {
        this.receiveFrom = receiveFrom;
    }
    
    public long getCurrencyId() {
        return currencyId;
    }
    
    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }
    
}
