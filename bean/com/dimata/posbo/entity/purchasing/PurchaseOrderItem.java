package com.dimata.posbo.entity.purchasing;

/* package java */

import java.util.Date;
import java.util.Vector;

/* package qdep */
import com.dimata.qdep.entity.*;

public class PurchaseOrderItem extends Entity {
    
    private long purchaseOrderId = 0;
    private long materialId = 0;
    private long unitId = 0;
    private double price = 0.00;
    private long currencyId = 0;
    private double quantity = 0;
    private double discount = 0.00;
    private double total = 0.00;
    private double residuQty = 0.00;
    private double orgBuyingPrice = 0.00;
    private double discount1 = 0.00;
    private double discount2 = 0.00;
    private double discNominal = 0.00;
    private double curBuyingPrice = 0.00;
    
    public double getResiduQty() {
        return residuQty;
    }
    
    public void setResiduQty(double residuQty) {
        this.residuQty = residuQty;
    }
    
    // discNominal
    public double getCurBuyingPrice() {
        return curBuyingPrice;
    }
    
    public void setCurBuyingPrice(double curBuyingPrice) {
        this.curBuyingPrice = curBuyingPrice;
    }
    
    // discNominal
    public double getDiscNominal() {
        return discNominal;
    }
    
    public void setDiscNominal(double discNominal) {
        this.discNominal = discNominal;
    }
    
    // discount 1
    public double getDiscount1() {
        return discount1;
    }
    
    public void setDiscount1(double discount1) {
        this.discount1 = discount1;
    }
    
    // discount 2
    public double getDiscount2() {
        return discount2;
    }
    
    public void setDiscount2(double discount2) {
        this.discount2 = discount2;
    }
    
    // buying price
    public double getOrgBuyingPrice() {
        return orgBuyingPrice;
    }
    
    public void setOrgBuyingPrice(double orgBuyingPrice) {
        this.orgBuyingPrice = orgBuyingPrice;
    }
    
    public long getPurchaseOrderId() {
        return purchaseOrderId;
    }
    
    public void setPurchaseOrderId(long purchaseOrderId) {
        this.purchaseOrderId = purchaseOrderId;
    }
    
    public long getMaterialId() {
        return materialId;
    }
    
    public void setMaterialId(long materialId) {
        this.materialId = materialId;
    }
    
    public long getUnitId() {
        return unitId;
    }
    
    public void setUnitId(long unitId) {
        this.unitId = unitId;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public long getCurrencyId() {
        return currencyId;
    }
    
    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }
    
    public double getQuantity() {
        return quantity;
    }
    
    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }
    
    public double getDiscount() {
        return discount;
    }
    
    public void setDiscount(double discount) {
        this.discount = discount;
    }
    
    public double getTotal() {
        return total;
    }
    
    public void setTotal(double total) {
        this.total = total;
    }
    
}
