
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

public class PriceTypeMapping extends Entity { 

	private double price;

	public long getPriceTypeId(){ 
		return this.getOID(0); 
	} 

	public void setPriceTypeId(long priceTypeId){ 
		this.setOID(0, priceTypeId); 
	} 

	public long getMaterialId(){ 
		return this.getOID(1); 
	} 

	public void setMaterialId(long materialId){ 
		this.setOID(1, materialId); 
	} 

	public long getStandartRateId(){ 
		return this.getOID(2); 
	} 

	public void setStandartRateId(long standartRateId){ 
		this.setOID(2, standartRateId); 
	} 

	public double getPrice(){ 
		return price; 
	} 

	public void setPrice(double price){ 
		this.price = price; 
	} 

}
