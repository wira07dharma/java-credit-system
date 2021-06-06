/* 
 * Form Name  	:  FrmPriceTypeMapping.java 
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

package com.dimata.posbo.form.masterdata;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.posbo.entity.masterdata.*;

public class FrmPriceTypeMapping extends FRMHandler implements I_FRMInterface, I_FRMType 
{
	private PriceTypeMapping priceTypeMapping;

	public static final String FRM_NAME_PRICETYPEMAPPING		=  "FRM_NAME_PRICETYPEMAPPING" ;

	public static final int FRM_FIELD_PRICE_TYPE_ID			=  0 ;
	public static final int FRM_FIELD_MATERIAL_ID			=  1 ;
	public static final int FRM_FIELD_STANDART_RATE_ID			=  2 ;
	public static final int FRM_FIELD_PRICE			=  3 ;

	public static String[] fieldNames = {
		"FRM_FIELD_PRICE_TYPE_ID",  "FRM_FIELD_MATERIAL_ID",
		"FRM_FIELD_STANDART_RATE_ID",  "FRM_FIELD_PRICE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_FLOAT + ENTRY_REQUIRED
	} ;

	public FrmPriceTypeMapping(){
	}
	public FrmPriceTypeMapping(PriceTypeMapping priceTypeMapping){
		this.priceTypeMapping = priceTypeMapping;
	}

	public FrmPriceTypeMapping(HttpServletRequest request, PriceTypeMapping priceTypeMapping){
		super(new FrmPriceTypeMapping(priceTypeMapping), request);
		this.priceTypeMapping = priceTypeMapping;
	}

	public String getFormName() { return FRM_NAME_PRICETYPEMAPPING; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public PriceTypeMapping getEntityObject(){ return priceTypeMapping; }

	public void requestEntityObject(PriceTypeMapping priceTypeMapping) {
		try{
			this.requestParam();
                        priceTypeMapping.setPriceTypeId(getLong(FRM_FIELD_PRICE_TYPE_ID));
                        priceTypeMapping.setStandartRateId(getLong(FRM_FIELD_STANDART_RATE_ID));
                        priceTypeMapping.setMaterialId(getLong(FRM_FIELD_MATERIAL_ID));
			priceTypeMapping.setPrice(getDouble(FRM_FIELD_PRICE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
