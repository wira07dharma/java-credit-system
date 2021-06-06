/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.kredit;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author gndiw
 */
public class HapusKreditItem extends Entity {

    private long hapusId = 0;
    private long cashBillDetailId = 0;
    private long materialId = 0;
    private double nilaiHpp = 0;
    private String qty = "";

    public long getHapusId() {
        return hapusId;
    }

    public void setHapusId(long hapusId) {
        this.hapusId = hapusId;
    }

    public long getCashBillDetailId() {
        return cashBillDetailId;
    }

    public void setCashBillDetailId(long cashBillDetailId) {
        this.cashBillDetailId = cashBillDetailId;
    }

    public long getMaterialId() {
        return materialId;
    }

    public void setMaterialId(long materialId) {
        this.materialId = materialId;
    }

    public double getNilaiHpp() {
        return nilaiHpp;
    }

    public void setNilaiHpp(double nilaiHpp) {
        this.nilaiHpp = nilaiHpp;
    }

    public String getQty() {
        return qty;
    }

    public void setQty(String qty) {
        this.qty = qty;
    }

}
