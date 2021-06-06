/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.posbo.entity.masterdata;

/**
 *
 * @author PT. Dimata
 */

/* package qdep */
import com.dimata.qdep.entity.*;

public class DiscountQtyMapping extends Entity {
        private double startQty;
        private double toQty;
        private double discountValue;
        private int discountType;
         // for updated catalog
        private java.util.Date updateDate;

	

	public long getDiscountTypeId(){
		return this.getOID(0);
	}

	public void setDiscountTypeId(long discountTypeId){
		this.setOID(0, discountTypeId);
	}

	public long getCurrencyTypeId(){
		return this.getOID(1);
	}


	public void setCurrencyTypeId(long currencyTypeId){
		this.setOID(1, currencyTypeId);
	}
        public long getLocationId(){
		return this.getOID(2);
	}

	public void setLocationId(long LocationId){
		this.setOID(2, LocationId);
	}

        public long getMaterialId(){
		return this.getOID(3);
	}

	public void setMaterialId(long materialId){
		this.setOID(3, materialId);
	}

        
	public int getDiscountType(){
		return discountType;
	}

	public void setDiscountType(int discountType){
		this.discountType = discountType;
	}

	

    /**
     * @return the startQty
     */
    public double getStartQty() {
        return startQty;
    }

    /**
     * @param startQty the startQty to set
     */
    public void setStartQty(double startQty) {
        this.startQty = startQty;
    }

    /**
     * @return the toQty
     */
    public double getToQty() {
        return toQty;
    }

    /**
     * @param toQty the toQty to set
     */
    public void setToQty(double toQty) {
        this.toQty = toQty;
    }

    /**
     * @return the discountValue
     */
    public double getDiscountValue() {
        return discountValue;
    }

    /**
     * @param discountValue the discountValue to set
     */
    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    /**
     * @return the discountTypeId
     */
   // public long getDiscountTypeId() {
       // return discountTypeId;
   // }

    /**
     * @param discountTypeId the discountTypeId to set
     */
    //public void setDiscountTypeId(long discountTypeId) {
       // this.discountTypeId = discountTypeId;
   // }

    /**
     * @return the currencyTypeId
     */
    //public long getCurrencyTypeId() {
        //return currencyTypeId;
   // }

    /**
     * @param currencyTypeId the currencyTypeId to set
     */
   // public void setCurrencyTypeId(long currencyTypeId) {
       // this.currencyTypeId = currencyTypeId;
    //}

    /**
     * @return the locationId
     */
    //public long getLocationId() {
        //return locationId;
   // }

    /**
     * @param locationId the locationId to set
     */
   // public void setLocationId(long locationId) {
        //this.locationId = locationId;
    //}

    /**
     * @return the materialId
     */
    //public long getMaterialId() {
        //return materialId;
   // }

    /**
     * @param materialId the materialId to set
     */
    //public void setMaterialId(long materialId) {
        //this.materialId = materialId;
    //}

    public java.util.Date getUpdateDate() {
        return updateDate;
    }

    /**
     * @param updateDate the updateDate to set
     */
    public void setUpdateDate(java.util.Date updateDate) {
        this.updateDate = updateDate;
    }

}
