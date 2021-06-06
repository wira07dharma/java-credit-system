
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

public class MemberRegistrationHistory extends Entity { 

	private long memberId;
	private Date registrationDate;
	private Date validStartDate;
	private Date validExpiredDate;

	public long getMemberId(){ 
		return memberId; 
	} 

	public void setMemberId(long memberId){ 
		this.memberId = memberId; 
	} 

	public Date getRegistrationDate(){ 
		return registrationDate; 
	} 

	public void setRegistrationDate(Date registrationDate){ 
		this.registrationDate = registrationDate; 
	} 

	public Date getValidStartDate(){ 
		return validStartDate; 
	} 

	public void setValidStartDate(Date validStartDate){ 
		this.validStartDate = validStartDate; 
	} 

	public Date getValidExpiredDate(){ 
		return validExpiredDate; 
	} 

	public void setValidExpiredDate(Date validExpiredDate){ 
		this.validExpiredDate = validExpiredDate; 
	} 

}
