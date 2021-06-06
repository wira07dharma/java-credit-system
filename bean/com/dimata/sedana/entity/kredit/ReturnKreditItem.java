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
public class ReturnKreditItem extends Entity {

    private long returnId = 0;
    private long cashBillDetailId = 0;
    private long materialId = 0;
    private double nilaiHpp = 0;
    private double nilaiPersediaan = 0;
    private int qty = 0;
    private String newMaterialName = "";
    private String newSku = "";
    private long newMaterialId = 0;

    public long getReturnId() {
        return returnId;
    }

    public void setReturnId(long returnId) {
        this.returnId = returnId;
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

    public double getNilaiPersediaan() {
        return nilaiPersediaan;
    }

    public void setNilaiPersediaan(double nilaiPersediaan) {
        this.nilaiPersediaan = nilaiPersediaan;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public String getNewMaterialName() {
        return newMaterialName;
    }

    public void setNewMaterialName(String newMaterialName) {
        this.newMaterialName = newMaterialName;
    }

    public String getNewSku() {
        return newSku;
    }

    public void setNewSku(String newSku) {
        this.newSku = newSku;
    }

    public long getNewMaterialId() {
        return newMaterialId;
    }

    public void setNewMaterialId(long newMaterialId) {
        this.newMaterialId = newMaterialId;
    }

}
