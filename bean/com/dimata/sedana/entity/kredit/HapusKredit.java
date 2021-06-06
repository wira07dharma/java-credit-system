/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.kredit;

import com.dimata.qdep.entity.Entity;
import java.util.Date;

/**
 *
 * @author gndiw
 */
public class HapusKredit extends Entity {

    private String nomorHapus = "";
    private long pinjamanId = 0;
    private long cashBillMainId = 0;
    private Date tanggalHapus = null;
    private long locationTransaksi = 0;
    private double sisaPokok = 0;
    private double sisaBunga = 0;
    private int status = 0;
    private String catatan = "";

    public String getNomorHapus() {
        return nomorHapus;
    }

    public void setNomorHapus(String nomorHapus) {
        this.nomorHapus = nomorHapus;
    }

    public long getPinjamanId() {
        return pinjamanId;
    }

    public void setPinjamanId(long pinjamanId) {
        this.pinjamanId = pinjamanId;
    }

    public long getCashBillMainId() {
        return cashBillMainId;
    }

    public void setCashBillMainId(long cashBillMainId) {
        this.cashBillMainId = cashBillMainId;
    }

    public Date getTanggalHapus() {
        return tanggalHapus;
    }

    public void setTanggalHapus(Date tanggalHapus) {
        this.tanggalHapus = tanggalHapus;
    }

    public long getLocationTransaksi() {
        return locationTransaksi;
    }

    public void setLocationTransaksi(long locationTransaksi) {
        this.locationTransaksi = locationTransaksi;
    }

    public double getSisaPokok() {
        return sisaPokok;
    }

    public void setSisaPokok(double sisaPokok) {
        this.sisaPokok = sisaPokok;
    }

    public double getSisaBunga() {
        return sisaBunga;
    }

    public void setSisaBunga(double sisaBunga) {
        this.sisaBunga = sisaBunga;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCatatan() {
        return catatan;
    }

    public void setCatatan(String catatan) {
        this.catatan = catatan;
    }

}
