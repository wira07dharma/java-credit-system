/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Dimata IT Solutions
 */
public class JangkaWaktuFormula extends Entity {

    /**
     * @return the pembulatan
     */
    public int getPembulatan() {
        return pembulatan;
    }

    /**
     * @param pembulatan the pembulatan to set
     */
    public void setPembulatan(int pembulatan) {
        this.pembulatan = pembulatan;
    }

    /**
     * @return the compName
     */
    public String getCompName() {
        return compName;
    }

    /**
     * @param compName the compName to set
     */
    public void setCompName(String compName) {
        this.compName = compName;
    }

    /**
     * @return the code
     */
    public String getCode() {
        return code;
    }

    /**
     * @param code the code to set
     */
    public void setCode(String code) {
        this.code = code;
    }

    /**
     * @return the idx
     */
    public int getIdx() {
        return idx;
    }

    /**
     * @param idx the idx to set
     */
    public void setIdx(int idx) {
        this.idx = idx;
    }

    /**
     * @return the jangkaWaktuId
     */
    public long getJangkaWaktuId() {
        return jangkaWaktuId;
    }

    /**
     * @param jangkaWaktuId the jangkaWaktuId to set
     */
    public void setJangkaWaktuId(long jangkaWaktuId) {
        this.jangkaWaktuId = jangkaWaktuId;
    }

    /**
     * @return the transType
     */
    public int getTransType() {
        return transType;
    }

    /**
     * @param transType the transType to set
     */
    public void setTransType(int transType) {
        this.transType = transType;
    }

    /**
     * @return the formula
     */
    public String getFormula() {
        return formula;
    }

    /**
     * @param formula the formula to set
     */
    public void setFormula(String formula) {
        this.formula = formula;
    }
    private long jangkaWaktuId = 0;
    private int transType = 0;
    private String formula = "";
    private String code = "";
    private int idx = 0;
    private String compName = "";
    private int pembulatan = 0;
    private long jenisKreditId = 0;
    private int status = 0;

    /**
     * @return the jenisKreditId
     */
    public long getJenisKreditId() {
        return jenisKreditId;
    }

    /**
     * @param jenisKreditId the jenisKreditId to set
     */
    public void setJenisKreditId(long jenisKreditId) {
        this.jenisKreditId = jenisKreditId;
    }

    /**
     * @return the status
     */
    public int getStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(int status) {
        this.status = status;
    }
}
