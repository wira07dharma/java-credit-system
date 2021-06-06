/*
 * Form Name  	:  FrmLoginSystem.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	:  [authorName] 
 * @version  	:  [version] 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.common.form.loginsystem;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.common.entity.loginsystem.*;

public class FrmLoginSystem extends FRMHandler implements I_FRMInterface, I_FRMType 
{
	private LoginSystem loginSystem;

	public static final String FRM_NAME_LOGINSYSTEM		=  "FRM_NAME_LOGINSYSTEM" ;

	public static final int FRM_FIELD_LOGIN_SYSTEM_ID			=  0 ;
	public static final int FRM_FIELD_USER_ID			=  1 ;
	public static final int FRM_FIELD_REMOTE_IP			=  2 ;
	public static final int FRM_FIELD_LOGIN_DATE			=  3 ;
	public static final int FRM_FIELD_STATUS			=  4 ;
	public static final int FRM_FIELD_BLOCKED_DATE			=  5 ;
	public static final int FRM_FIELD_NUM_LOGIN			=  6 ;

	public static String[] fieldNames = {
		"FRM_FIELD_LOGIN_SYSTEM_ID",  "FRM_FIELD_USER_ID",
		"FRM_FIELD_REMOTE_IP",  "FRM_FIELD_LOGIN_DATE",
		"FRM_FIELD_STATUS",  "FRM_FIELD_BLOCKED_DATE",
		"FRM_FIELD_NUM_LOGIN"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_DATE,
		TYPE_INT,  TYPE_DATE,
		TYPE_INT
	} ;

	public FrmLoginSystem(){
	}
	public FrmLoginSystem(LoginSystem loginSystem){
		this.loginSystem = loginSystem;
	}

	public FrmLoginSystem(HttpServletRequest request, LoginSystem loginSystem){
		super(new FrmLoginSystem(loginSystem), request);
		this.loginSystem = loginSystem;
	}

	public String getFormName() { return FRM_NAME_LOGINSYSTEM; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public LoginSystem getEntityObject(){ return loginSystem; }

	public void requestEntityObject(LoginSystem loginSystem) {
		try{
			this.requestParam();
			loginSystem.setUserId(getString(FRM_FIELD_USER_ID));
			loginSystem.setRemoteIp(getString(FRM_FIELD_REMOTE_IP));
			loginSystem.setLoginDate(getDate(FRM_FIELD_LOGIN_DATE));
			loginSystem.setStatus(getInt(FRM_FIELD_STATUS));
			loginSystem.setBlockedDate(getDate(FRM_FIELD_BLOCKED_DATE));
			loginSystem.setNumLogin(getInt(FRM_FIELD_NUM_LOGIN));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
