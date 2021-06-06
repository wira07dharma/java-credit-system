/* 
 * Form Name  	:  FrmDepartment.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	: karya 
 * @version  	: 01 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.harisma.form.masterdata;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 

/* qdep package */ 
import com.dimata.qdep.form.*;

/* project package */
import com.dimata.harisma.entity.masterdata.*;

public class FrmDepartment extends FRMHandler implements I_FRMInterface, I_FRMType 
{
	private Department department;

	public static final String FRM_NAME_DEPARTMENT		=  "FRM_NAME_DEPARTMENT" ;

	public static final int FRM_FIELD_DEPARTMENT_ID			=  0 ;
	public static final int FRM_FIELD_DEPARTMENT			=  1 ;
	public static final int FRM_FIELD_DESCRIPTION			=  2 ;

	public static String[] fieldNames = {
		"FRM_FIELD_DEPARTMENT_ID",  "FRM_FIELD_DEPARTMENT",
		"FRM_FIELD_DESCRIPTION"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING
	} ;

	public FrmDepartment(){
	}
	public FrmDepartment(Department department){
		this.department = department;
	}

	public FrmDepartment(HttpServletRequest request, Department department){
		super(new FrmDepartment(department), request);
		this.department = department;
	}

	public String getFormName() { return FRM_NAME_DEPARTMENT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public Department getEntityObject(){ return department; }

	public void requestEntityObject(Department department) {
		try{
			this.requestParam();
			department.setDepartment(getString(FRM_FIELD_DEPARTMENT));
			department.setDescription(getString(FRM_FIELD_DESCRIPTION));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
