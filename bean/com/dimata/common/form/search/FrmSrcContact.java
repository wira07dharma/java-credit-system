/* 
 * Form Name  	:  FrmSrcContact.java
 * Created on 	:  April 28,2003 10.44 AM
 * 
 * @author  	: lkarunia
 * @version  	: 01 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.common.form.search;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.common.entity.contact.*;
import com.dimata.common.entity.search.*;

public class FrmSrcContact extends FRMHandler implements I_FRMInterface, I_FRMType
{
	private SrcContact srcContact;

	public static final String FRM_NAME_SRC_CONTACT		=  "FRM_NAME_SRCCONTACT" ;

	public static final int FRM_FIELD_NAME			=  0 ;
	public static final int FRM_FIELD_ADDRESS		=  1 ;
	public static final int FRM_FIELD_CITY			=  2 ;
    public static final int FRM_FIELD_COUNTRY		=  3 ;
    public static final int FRM_FIELD_EMAIL			=  4 ;
    public static final int FRM_FIELD_FAX			=  5 ;
    public static final int FRM_FIELD_TELP			=  6 ;
    public static final int FRM_FIELD_CODE			=  7 ;
    public static final int FRM_FIELD_COMP_NAME			=  8 ;

    public static String[] fieldNames = {
		"FRM_FIELD_NAME",  "FRM_FIELD_ADDRESS",
		"FRM_FIELD_CITY","FRM_FIELD_COUNTRY",
        "FRM_FIELD_EMAIL", "FRM_FIELD_FAX",
        "FRM_FIELD_TELP", "FRM_FIELD_CODE",
        "FRM_FIELD_COMP_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_STRING, TYPE_STRING,
		TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING
	} ;

    public FrmSrcContact(){
	}
	public FrmSrcContact(SrcContact srcContact){
		this.srcContact = srcContact;
	}

	public FrmSrcContact(HttpServletRequest request, SrcContact srcContact){
		super(new FrmSrcContact(srcContact), request);
		this.srcContact = srcContact;
	}

	public String getFormName() { return FRM_NAME_SRC_CONTACT; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public SrcContact getEntityObject(){ return srcContact; }

	public void requestEntityObject(SrcContact srcContact) {
		try{
			this.requestParam();
			srcContact.setName(getString(FRM_FIELD_NAME).replaceAll("'","''"));
                        System.out.println("INI NAME DI FrmSrcContact = " + getString(FRM_FIELD_NAME).replaceAll("'","''"));
			srcContact.setAddress(getString(FRM_FIELD_ADDRESS));
            srcContact.setCity(getString(FRM_FIELD_CITY));
            srcContact.setCountry(getString(FRM_FIELD_COUNTRY));
            srcContact.setEmail(getString(FRM_FIELD_EMAIL));
			srcContact.setTelp(getString(FRM_FIELD_FAX));
            srcContact.setFax(getString(FRM_FIELD_TELP));
            srcContact.setCode(getString(FRM_FIELD_CODE));
            srcContact.setCompName(getString(FRM_FIELD_COMP_NAME).replaceAll("'","''"));
            System.out.println("INI NAME COMP DI FrmSrcContact = " + getString(FRM_FIELD_COMP_NAME).replaceAll("'","''"));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
