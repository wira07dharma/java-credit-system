/* 
 * Form Name  	:  FrmCurrencyRate.java 
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

package com.dimata.common.form.currency;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.common.entity.currency.*;

public class FrmCurrencyRate extends FRMHandler implements I_FRMInterface, I_FRMType 
{
	private CurrencyRate currencyRate;

	public static final String FRM_NAME_CURRENCYRATE		=  "FRM_NAME_CURRENCYRATE" ;

	public static final int FRM_FIELD_RATE_ID			=  0 ;
	public static final int FRM_FIELD_DATE			=  1 ;
	public static final int FRM_FIELD_VALUE			=  2 ;

	public static String[] fieldNames = {
		"FRM_FIELD_RATE_ID",  "FRM_FIELD_DATE",
		"FRM_FIELD_VALUE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_DATE,
		TYPE_FLOAT + ENTRY_REQUIRED
	} ;

	public FrmCurrencyRate(){
	}
	public FrmCurrencyRate(CurrencyRate currencyRate){
		this.currencyRate = currencyRate;
	}

	public FrmCurrencyRate(HttpServletRequest request, CurrencyRate currencyRate){
		super(new FrmCurrencyRate(currencyRate), request);
		this.currencyRate = currencyRate;
	}

	public String getFormName() { return FRM_NAME_CURRENCYRATE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public CurrencyRate getEntityObject(){ return currencyRate; }

	public void requestEntityObject(CurrencyRate currencyRate) {
		try{
			this.requestParam();
            System.out.println("FRM_FIELD_DATE" + getDate(FRM_FIELD_DATE));
			currencyRate.setDate(getDate(FRM_FIELD_DATE));
			currencyRate.setValue(getDouble(FRM_FIELD_VALUE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
