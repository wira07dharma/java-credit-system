/*
 * FrmRack.java
 *
 * Created on April 26, 2006, 10:29 AM
 */

package com.dimata.common.form.location;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
/* project package */

import com.dimata.common.entity.location.Rack;

/**
 *
 * @author  hendra
 */
public class FrmRack extends FRMHandler implements I_FRMInterface, I_FRMType 
{
	private Rack rack = new Rack();

	public static final String FRM_NAME_RACK		 =  "FRM_NAME_RACK" ;

	public static final int FRM_FIELD_CODE				 =  0;
	public static final int FRM_FIELD_NAME				 =  1;
	public static final int FRM_FIELD_DESCRIPTION			 =  2;
        public static final int FRM_FIELD_LOCATION_ID			 =  3;
        
	

	public static String[] fieldNames = {
	"FRM_FIELD_CODE",
        "FRM_FIELD_NAME",
        "FRM_FIELD_DESCRIPTION",
        "FRM_FIELD_LOCATION_ID"        
    };

	public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED,
	TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_LONG + ENTRY_REQUIRED
	} ;

	public FrmRack(){
	}
	

	public FrmRack(HttpServletRequest request){
		super(new FrmRack(), request);
		//this.rack = rack;
	}

	public String getFormName() { return FRM_NAME_RACK; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public Rack getEntityObject(){ return rack; }

	public void requestEntityObject(Rack rack) {
		try{
			this.requestParam();
			rack.setRackCode(getString(FRM_FIELD_CODE));
			rack.setRackName(getString(FRM_FIELD_NAME));
			rack.setRackDescription(getString(FRM_FIELD_DESCRIPTION));
			rack.setLocationId(getLong(FRM_FIELD_LOCATION_ID));
                        
                        this.rack = rack;
			
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}