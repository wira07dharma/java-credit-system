
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.posbo.entity.masterdata; 
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class DiscountMapping extends Entity { 

	private int discountType;
	private double discount;

        /** Holds value of property discountPct. */
        private double discountPct;
        
        /** Holds value of property discountValue. */
        private double discountValue;
        
	public long getDiscountTypeId(){ 
		return this.getOID(0); 
	} 

	public void setDiscountTypeId(long discountTypeId){ 
		this.setOID(0, discountTypeId); 
	} 

	public long getMaterialId(){ 
		return this.getOID(1); 
	} 

	public void setMaterialId(long materialId){ 
		this.setOID(1, materialId); 
	} 

	public long getCurrencyTypeId(){ 
		return this.getOID(2); 
	} 

	public void setCurrencyTypeId(long currencyTypeId){ 
		this.setOID(2, currencyTypeId); 
	} 

	public int getDiscountType(){ 
		return discountType; 
	} 

	public void setDiscountType(int discountType){ 
		this.discountType = discountType; 
	} 

	public double getDiscount(){ 
		return discount; 
	} 

	public void setDiscount(double discount){ 
		this.discount = discount; 
	} 

        /** Getter for property discountPct.
         * @return Value of property discountPct.
         *
         */
        public double getDiscountPct() {
            return this.discountPct;
        }
        
        /** Setter for property discountPct.
         * @param discountPct New value of property discountPct.
         *
         */
        public void setDiscountPct(double discountPct) {
            this.discountPct = discountPct;
        }
        
        /** Getter for property discountValue.
         * @return Value of property discountValue.
         *
         */
        public double getDiscountValue() {
            return this.discountValue;
        }
        
        /** Setter for property discountValue.
         * @param discountValue New value of property discountValue.
         *
         */
        public void setDiscountValue(double discountValue) {
            this.discountValue = discountValue;
        }
        
}
