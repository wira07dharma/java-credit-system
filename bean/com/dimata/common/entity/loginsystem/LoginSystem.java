
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

package com.dimata.common.entity.loginsystem;
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class LoginSystem extends Entity { 

	private String userId;
	private String remoteIp = "";
	private Date loginDate;
	private int status;
	private Date blockedDate;
	private int numLogin;

	public String getUserId(){ 
		return userId; 
	} 

	public void setUserId(String userId){ 
		this.userId = userId; 
	} 

	public String getRemoteIp(){ 
		return remoteIp; 
	} 

	public void setRemoteIp(String remoteIp){ 
		if ( remoteIp == null ) {
			remoteIp = ""; 
		} 
		this.remoteIp = remoteIp; 
	} 

	public Date getLoginDate(){ 
		return loginDate; 
	} 

	public void setLoginDate(Date loginDate){ 
		this.loginDate = loginDate; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public Date getBlockedDate(){ 
		return blockedDate; 
	} 

	public void setBlockedDate(Date blockedDate){ 
		this.blockedDate = blockedDate; 
	} 

	public int getNumLogin(){ 
		return numLogin; 
	} 

	public void setNumLogin(int numLogin){ 
		this.numLogin = numLogin; 
	} 

}
