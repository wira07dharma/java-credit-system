
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	: karya
 * @version  	: 01
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.posbo.entity.masterdata; 
 
/* package java */ 
import java.io.Serializable;
import java.util.Date;
import java.util.Vector;

import com.dimata.common.entity.contact.ContactList;
import com.dimata.qdep.entity.Entity;

public class MemberPoin extends Entity implements Serializable {

            
    private long cashBillMainId = 0;
    private long memberId = 0;
    private Date transactionDate = new Date();
    private int debet = 0;
    private int credit = 0;
    
    public String getPstClassName() {
       return "com.dimata.pos.entity.member.MemberPoin" ;
    }

    /**
     * Getter for property cashBillMainId.
     * @return Value of property cashBillMainId.
     */
    public long getCashBillMainId ()
    {
        return cashBillMainId;
    }
    
    /**
     * Setter for property cashBillMainId.
     * @param cashBillMainId New value of property cashBillMainId.
     */
    public void setCashBillMainId (long cashBillMainId)
    {
        this.cashBillMainId = cashBillMainId;
    }
    
    /**
     * Getter for property memberId.
     * @return Value of property memberId.
     */
    public long getMemberId ()
    {
        return memberId;
    }
    
    /**
     * Setter for property memberId.
     * @param memberId New value of property memberId.
     */
    public void setMemberId (long memberId)
    {
        this.memberId = memberId;
    }
    
    /**
     * Getter for property debet.
     * @return Value of property debet.
     */
    public int getDebet ()
    {
        return debet;
    }
    
    /**
     * Setter for property debet.
     * @param debet New value of property debet.
     */
    public void setDebet (int debet)
    {
        this.debet = debet;
    }
    
    /**
     * Getter for property credit.
     * @return Value of property credit.
     */
    public int getCredit ()
    {
        return credit;
    }
    
    /**
     * Setter for property credit.
     * @param credit New value of property credit.
     */
    public void setCredit (int credit)
    {
        this.credit = credit;
    }
    
    /**
     * Getter for property transactionDate.
     * @return Value of property transactionDate.
     */
    public java.util.Date getTransactionDate() {
        return transactionDate;
    }
    
    /**
     * Setter for property transactionDate.
     * @param transactionDate New value of property transactionDate.
     */
    public void setTransactionDate(java.util.Date transactionDate) {
        this.transactionDate = transactionDate;
    }
    
}
