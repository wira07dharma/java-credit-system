/* 
 * Form Name  	:  FrmLocation.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	: lkarunia
 * @version  	: 01 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.common.form.location;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
/* project package */

import com.dimata.common.entity.location.Location;

public class FrmLocation extends FRMHandler implements I_FRMInterface, I_FRMType 
{
	private Location location;

	public static final String FRM_NAME_LOCATION		 =  "FRM_NAME_LOCATION" ;

	public static final int FRM_FIELD_CODE				 =  0;
	public static final int FRM_FIELD_NAME				 =  1;
	public static final int FRM_FIELD_ADDRESS			 =  2;
	public static final int FRM_FIELD_TELEPHONE			 =  3;
	public static final int FRM_FIELD_FAX				 =  4;
	public static final int FRM_FIELD_PERSON			 =  5;
	public static final int FRM_FIELD_EMAIL				 =  6;
    public static final int FRM_FIELD_WEBSITE			 =  7;
	public static final int FRM_FIELD_PARENT_LOCATION_ID =  8;
	public static final int FRM_FIELD_CONTACT_ID		 =  9;
	public static final int FRM_FIELD_TYPE				 =  10;
	public static final int FRM_FIELD_DESCRIPTION		 =  11;

	public static String[] fieldNames = {
		"FRM_FIELD_CODE",
        "FRM_FIELD_NAME",
        "FRM_FIELD_ADDRESS",
		"FRM_FIELD_TELEPHONE",
        "FRM_FIELD_FAX",
		"FRM_FIELD_PERSON",
        "FRM_FIELD_EMAIL",
        "FRM_FIELD_WEBSITE",
        "FRM_FIELD_PARENT_LOCATION_ID",
		"FRM_FIELD_CONTACT_ID",
		"FRM_FIELD_TYPE",
        "FRM_FIELD_DESCRIPTION"
    };

	public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_LONG,
        TYPE_LONG,
		TYPE_INT,
        TYPE_STRING
	} ;

	public FrmLocation(){
	}
	public FrmLocation(Location location){
		this.location = location;
	}

	public FrmLocation(HttpServletRequest request, Location location){
		super(new FrmLocation(location), request);
		this.location = location;
	}

	public String getFormName() { return FRM_NAME_LOCATION; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public Location getEntityObject(){ return location; }

	public void requestEntityObject(Location location) {
		try{
			this.requestParam();
			location.setCode(getString(FRM_FIELD_CODE));
			location.setName(getString(FRM_FIELD_NAME));
			location.setAddress(getString(FRM_FIELD_ADDRESS));
			location.setTelephone(getString(FRM_FIELD_TELEPHONE));
			location.setFax(getString(FRM_FIELD_FAX));
			location.setPerson(getString(FRM_FIELD_PERSON));
			location.setEmail(getString(FRM_FIELD_EMAIL));
            location.setWebsite(getString(FRM_FIELD_WEBSITE));
			location.setParentLocationId(getLong(FRM_FIELD_PARENT_LOCATION_ID));
			location.setContactId(getLong(FRM_FIELD_CONTACT_ID));
			location.setType(getInt(FRM_FIELD_TYPE));
			location.setDescription(getString(FRM_FIELD_DESCRIPTION));
            System.out.println("location.getParentLocationId() : "+location.getParentLocationId());
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
