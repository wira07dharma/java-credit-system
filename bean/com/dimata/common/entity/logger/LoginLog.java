
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

package com.dimata.common.entity.logger;
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class LoginLog extends Entity { 

	private String remoteIp = "";
	private Date releaseTime;
	private int status;
	private String description = "";
    private Date loginDate;
    private Date updateDate;

	public String getRemoteIp(){ 
		return remoteIp; 
	} 

	public void setRemoteIp(String remoteIp){ 
		if ( remoteIp == null ) {
			remoteIp = ""; 
		} 
		this.remoteIp = remoteIp; 
	} 

	public Date getReleaseTime(){ 
		return releaseTime; 
	} 

	public void setReleaseTime(Date releaseTime){ 
		this.releaseTime = releaseTime; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public String getDescription(){ 
		return description; 
	} 

	public void setDescription(String description){ 
		if ( description == null ) {
			description = ""; 
		} 
		this.description = description; 
	} 

    public Date getLoginDate(){ return loginDate; }

    public void setLoginDate(Date loginDate){ this.loginDate = loginDate; }

    public Date getUpdateDate(){ return updateDate; }

    public void setUpdateDate(Date updateDate){ this.updateDate = updateDate; }
}
