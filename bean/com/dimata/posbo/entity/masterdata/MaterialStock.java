package com.dimata.posbo.entity.masterdata;

/* package java */

import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class MaterialStock extends Entity {
    private long periodeId = 0;
    private long materialUnitId = 0;
    private long locationId = 0;
    private double qty = 0;
    private double qtyMin = 0;
    private double qtyMax = 0;
    private double qtyIn = 0;
    private double qtyOut = 0;
    private double openingQty = 0;
    private double closingQty = 0;
    private double opnameQty = 0;
    private double saleQty = 0;

    public double getSaleQty() {
        return saleQty;
    }

    public void setSaleQty(double saleQty) {
        this.saleQty = saleQty;
    }

    public long getPeriodeId() {
        return periodeId;
    }

    public double getOpnameQty() {
        return opnameQty;
    }

    public void setOpnameQty(double opnameQty) {
        this.opnameQty = opnameQty;
    }

    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }

    public long getMaterialUnitId() {
        return materialUnitId;
    }

    public void setMaterialUnitId(long materialUnitId) {
        this.materialUnitId = materialUnitId;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public double getQtyMin() {
        return qtyMin;
    }

    public void setQtyMin(double qtyMin) {
        this.qtyMin = qtyMin;
    }

    public double getQtyMax() {
        return qtyMax;
    }

    public void setQtyMax(double qtyMax) {
        this.qtyMax = qtyMax;
    }

    public double getQtyIn() {
        return qtyIn;
    }

    public void setQtyIn(double qtyIn) {
        this.qtyIn = qtyIn;
    }

    public double getQtyOut() {
        return qtyOut;
    }

    public void setQtyOut(double qtyOut) {
        this.qtyOut = qtyOut;
    }

    public double getOpeningQty() {
        return openingQty;
    }

    public void setOpeningQty(double openingQty) {
        this.openingQty = openingQty;
    }

    public double getClosingQty() {
        return closingQty;
    }

    public void setClosingQty(double closingQty) {
        this.closingQty = closingQty;
    }

}
