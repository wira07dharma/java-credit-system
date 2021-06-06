/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author gndiw
 */
public class HelperPriceList extends Entity {

    private long materialId = 0;
    private String sku = "";
    private String name = "";
    private String merk = "";
    private long jangkaWaktuId = 0;
    private double jmlAngsuran = 0;
    private long categoryId = 0;

    public long getMaterialId() {
        return materialId;
    }

    public void setMaterialId(long materialId) {
        this.materialId = materialId;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMerk() {
        return merk;
    }

    public void setMerk(String merk) {
        this.merk = merk;
    }

    public long getJangkaWaktuId() {
        return jangkaWaktuId;
    }

    public void setJangkaWaktuId(long jangkaWaktuId) {
        this.jangkaWaktuId = jangkaWaktuId;
    }

    public double getJmlAngsuran() {
        return jmlAngsuran;
    }

    public void setJmlAngsuran(double jmlAngsuran) {
        this.jmlAngsuran = jmlAngsuran;
    }

    public long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }

}
