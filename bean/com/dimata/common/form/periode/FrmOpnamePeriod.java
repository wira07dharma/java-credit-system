/* 
 * Form Name  	:  FrmMcdPeriode.java 
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

package com.dimata.common.form.periode;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.common.entity.periode.*;

public class FrmOpnamePeriod extends FRMHandler implements I_FRMInterface, I_FRMType 
{
	private OpnamePeriod periode;

	public static final String FRM_NAME_PERIODE		=  "FRM_NAME_PERIODE" ;

	public static final int FRM_FIELD_STOCK_PERIODE_ID			=  0 ;
	public static final int FRM_FIELD_PERIODE_TYPE			=  1 ;
	public static final int FRM_FIELD_PERIODE_NAME			=  2 ;
	public static final int FRM_FIELD_START_DATE			=  3 ;
	public static final int FRM_FIELD_END_DATE			=  4 ;
	public static final int FRM_FIELD_STATUS			=  5 ;

	public static String[] fieldNames = {
		"FRM_FIELD_STOCK_PERIODE_ID",
        "FRM_FIELD_PERIODE_TYPE",
		"FRM_FIELD_PERIODE_NAME",
        "FRM_FIELD_START_DATE",
		"FRM_FIELD_END_DATE",
        "FRM_FIELD_STATUS"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,
        TYPE_INT,
		TYPE_STRING + ENTRY_REQUIRED,
        TYPE_DATE,
		TYPE_DATE,
        TYPE_INT
	} ;

	public FrmOpnamePeriod(){
	}
	public FrmOpnamePeriod(OpnamePeriod periode){
		this.periode = periode;
	}

	public FrmOpnamePeriod(HttpServletRequest request, OpnamePeriod periode){
		super(new FrmOpnamePeriod(periode), request);
		this.periode = periode;
	}

	public String getFormName() { return FRM_NAME_PERIODE; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public OpnamePeriod getEntityObject(){ return periode; }

	public void requestEntityObject(OpnamePeriod periode) {
		try{
			this.requestParam();
			periode.setPeriodeType(getInt(FRM_FIELD_PERIODE_TYPE));
			periode.setPeriodeName(getString(FRM_FIELD_PERIODE_NAME));
			periode.setStartDate(getDate(FRM_FIELD_START_DATE));
			periode.setEndDate(getDate(FRM_FIELD_END_DATE));
			periode.setStatus(getInt(FRM_FIELD_STATUS));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
