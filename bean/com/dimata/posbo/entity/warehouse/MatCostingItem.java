package com.dimata.posbo.entity.warehouse;

/* package java */

import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class MatCostingItem extends Entity {

    private long costingMaterialId = 0;
    private long materialId = 0;
    private long unitId = 0;
    private double hpp = 0;
    private double qty = 0;
    private double residueQty = 0;

    public double getHpp() {
        return hpp;
    }

    public void setHpp(double hpp) {
        this.hpp = hpp;
    }

    public long getDispatchMaterialId() {
        return costingMaterialId;
    }

    public void setCostingMaterialId(long costingMaterialId) {
        this.costingMaterialId = costingMaterialId;
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

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    /** Getter for property residueQty.
     * @return Value of property residueQty.
     *
     */
    public double getResidueQty() {
        return this.residueQty;
    }

    /** Setter for property residueQty.
     * @param residueQty New value of property residueQty.
     *
     */
    public void setResidueQty(double residueQty) {
        this.residueQty = residueQty;
    }

}
