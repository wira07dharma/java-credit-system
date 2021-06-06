package com.dimata.posbo.entity.masterdata;

/* package java */
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class MaterialComposit extends Entity {
    private long materialId = 0;
    private long materialComposerId = 0;
    private long unitId = 0;
    private double qty = 0.00;
    
    public long getMaterialId(){ return materialId; }
    
    public void setMaterialId(long materialId){ this.materialId = materialId; }
    
    public long getMaterialComposerId(){ return materialComposerId; }
    
    public void setMaterialComposerId(long materialComposerId){ this.materialComposerId = materialComposerId; }
    
    public long getUnitId() {
        return unitId;
    }
    
    public void setUnitId(long unitId) {
        this.unitId = unitId;
    }
    
    public double getQty() {
        return qty;
    }
    
    public void setQty(double qty) {
        this.qty = qty;
    }
    
}
