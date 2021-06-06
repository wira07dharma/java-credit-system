
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	:  [authorName] 
 * @version  	:  [version] 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.common.entity.logger;
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class Logger extends Entity {

	private Date date = null;
    private long loginId = 0;
    private String loginName = "";
	private String notes = "";

    public long getLoginId(){
        return loginId;
    }

    public void setLoginId(long loginId){
        this.loginId = loginId;
    }

	public Date getDate(){
		return date;
	} 

	public void setDate(Date date){
		if ( date == null ) {
			date = new Date();
		} 
		this.date = date;
	} 

	public String getLoginName(){
		return loginName;
	} 

	public void setLoginName(String loginName){
		if ( loginName == null) {
			loginName = "";
		} 
		this.loginName = loginName;
	}

    public String getNotes(){
        return notes;
    }

    public void setNotes(String notes){
        if ( notes == null) {
            notes = "";
        }
        this.notes = notes;
    }

}
