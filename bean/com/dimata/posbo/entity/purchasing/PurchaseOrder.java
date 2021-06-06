package com.dimata.posbo.entity.purchasing;

/* package java */

import java.util.Date;
import java.util.Vector;

import com.dimata.qdep.entity.*;

public class PurchaseOrder extends Entity {
    private long locationId;
    private int locationType = 0;
    private String poCode = "";
    private int poCodeCounter;
    private Date purchDate;
    private long supplierId;
    private int poStatus;
    private String remark = "";
    // new
    private int termOfPayment = 0;
    private int creditTime = 0;
    private double ppn = 0;
    private long currencyId = 0;
    private String codeRevisi = "";

    public String getCodeRevisi() {
        return codeRevisi;
    }

    public void setCodeRevisi(String codeRevisi) {
        this.codeRevisi = codeRevisi;
    }

    private Vector listItem = new Vector();
    public Vector getListItem() {
        return listItem;
    }

    public void setListItem(PurchaseOrderItem purhItem) {
        this.listItem.add(purhItem);
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public double getPpn() {
        return ppn;
    }

    public void setPpn(double ppn) {
        this.ppn = ppn;
    }

    public int getCreditTime() {
        return creditTime;
    }

    public void setCreditTime(int creditTime) {
        this.creditTime = creditTime;
    }

    public int getTermOfPayment() {
        return termOfPayment;
    }

    public void setTermOfPayment(int termOfPayment) {
        this.termOfPayment = termOfPayment;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public int getLocationType() {
        return locationType;
    }

    public void setLocationType(int locationType) {
        this.locationType = locationType;
    }

    public String getPoCode() {
        return poCode;
    }

    public void setPoCode(String poCode) {
        if (poCode == null) {
            poCode = "";
        }
        this.poCode = poCode;
    }

    public int getPoCodeCounter() {
        return poCodeCounter;
    }

    public void setPoCodeCounter(int poCodeCounter) {
        this.poCodeCounter = poCodeCounter;
    }

    public Date getPurchDate() {
        return purchDate;
    }

    public void setPurchDate(Date purchDate) {
        this.purchDate = purchDate;
    }


    public long getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(long supplierId) {
        this.supplierId = supplierId;
    }

    public int getPoStatus() {
        return poStatus;
    }

    public void setPoStatus(int poStatus) {
        this.poStatus = poStatus;
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

}
