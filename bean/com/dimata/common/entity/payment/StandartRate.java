
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

package com.dimata.common.entity.payment; 
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class StandartRate extends Entity { 

	private long currencyTypeId;
	private double sellingRate;
	private Date startDate;
	private Date endDate;
	private int status;

        /** Holds value of property includeInProcess. */
        private int includeInProcess;
        
	public long getCurrencyTypeId(){ 
		return currencyTypeId; 
	} 

	public void setCurrencyTypeId(long currencyTypeId){ 
		this.currencyTypeId = currencyTypeId; 
	} 

	public double getSellingRate(){ 
		return sellingRate; 
	} 

	public void setSellingRate(double sellingRate){ 
		this.sellingRate = sellingRate; 
	} 

	public Date getStartDate(){ 
		return startDate; 
	} 

	public void setStartDate(Date startDate){ 
		this.startDate = startDate; 
	} 

	public Date getEndDate(){ 
		return endDate; 
	} 

	public void setEndDate(Date endDate){ 
		this.endDate = endDate; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

        /** Getter for property includeInProcess.
         * @return Value of property includeInProcess.
         *
         */
        public int getIncludeInProcess() {
            return this.includeInProcess;
        }
        
        /** Setter for property includeInProcess.
         * @param includeInProcess New value of property includeInProcess.
         *
         */
        public void setIncludeInProcess(int includeInProcess) {
            this.includeInProcess = includeInProcess;
        }
        
}
