/* 
 * Form Name  	:  FrmContactList.java 
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

package com.dimata.common.form.contact;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.common.entity.contact.*;

public class FrmContactList extends FRMHandler implements I_FRMInterface, I_FRMType 
{
	private ContactList contactList;

	public static final String FRM_NAME_CONTACTLIST		=  "FRM_NAME_CONTACTLIST" ;

	public static final int FRM_FIELD_CONTACT_ID			=  0 ;
	public static final int FRM_FIELD_CONTACT_CODE			=  1 ;
	public static final int FRM_FIELD_EMPLOYEE_ID			=  2 ;
	public static final int FRM_FIELD_PARENT_ID			=  3 ;
	public static final int FRM_FIELD_CONTACT_TYPE			=  4 ;
	public static final int FRM_FIELD_REGDATE			=  5 ;
	public static final int FRM_FIELD_COMP_NAME			=  6 ;
	public static final int FRM_FIELD_PERSON_NAME			=  7 ;
	public static final int FRM_FIELD_PERSON_LASTNAME			=  8 ;
	public static final int FRM_FIELD_BUSS_ADDRESS			=  9 ;
	public static final int FRM_FIELD_TOWN			=  10 ;
	public static final int FRM_FIELD_PROVINCE			=  11 ;
	public static final int FRM_FIELD_COUNTRY			=  12 ;
	public static final int FRM_FIELD_TELP_NR			=  13 ;
	public static final int FRM_FIELD_TELP_MOBILE			=  14 ;
	public static final int FRM_FIELD_FAX			=  15 ;
	public static final int FRM_FIELD_HOME_ADDR			=  16 ;
	public static final int FRM_FIELD_HOME_TOWN			=  17 ;
	public static final int FRM_FIELD_HOME_PROVINCE			=  18 ;
	public static final int FRM_FIELD_HOME_COUNTRY			=  19 ;
	public static final int FRM_FIELD_HOME_TELP			=  20 ;
	public static final int FRM_FIELD_HOME_FAX			=  21 ;
	public static final int FRM_FIELD_NOTES			=  22 ;
	public static final int FRM_FIELD_BANK_ACC			=  23 ;
	public static final int FRM_FIELD_BANK_ACC2			=  24 ;
	public static final int FRM_FIELD_EMAIL			=  25 ;
        
        //new
        public static final int FRM_FIELD_COMPANY_BANK_ACC            =  26 ;
        public static final int FRM_FIELD_POSITION_PERSON             =  27 ;
        public static final int FRM_FIELD_POSTAL_CODE_COMPANY   =  28 ;
        public static final int FRM_FIELD_WEBSITE_COMPANY       =  29 ;
        public static final int FRM_FIELD_EMAIL_COMPANY         =  30 ;
        public static final int FRM_FIELD_POSTAL_CODE_HOME      =  31 ;
        public static final int FRM_FIELD_KTP_NO      =  32 ;
        
        

	public static String[] fieldNames = {
		"FRM_FIELD_CONTACT_ID",
        "FRM_FIELD_CONTACT_CODE",
		"FRM_FIELD_EMPLOYEE_ID",
        "FRM_FIELD_PARENT_ID",
		"FRM_FIELD_CONTACT_TYPE",
        "FRM_FIELD_REGDATE",
		"FRM_FIELD_COMP_NAME",
        "FRM_FIELD_PERSON_NAME",
		"FRM_FIELD_PERSON_LASTNAME",
        "FRM_FIELD_BUSS_ADDRESS",
		"FRM_FIELD_TOWN",
        "FRM_FIELD_PROVINCE",
		"FRM_FIELD_COUNTRY",
        "FRM_FIELD_TELP_NR",
		"FRM_FIELD_TELP_MOBILE",
        "FRM_FIELD_FAX",
		"FRM_FIELD_HOME_ADDR",
        "FRM_FIELD_HOME_TOWN",
		"FRM_FIELD_HOME_PROVINCE",
        "FRM_FIELD_HOME_COUNTRY",
		"FRM_FIELD_HOME_TELP",
        "FRM_FIELD_HOME_FAX",
		"FRM_FIELD_NOTES",
        "FRM_FIELD_BANK_ACC",
		"FRM_FIELD_BANK_ACC2",
        "FRM_FIELD_EMAIL",
        
        //new
        "FRM_FIELD_COMPANY_BANK_ACC",
       "FRM_FIELD_POSITION_PERSON",
       "FRM_FIELD_POSTAL_CODE_COMPANY",
       "FRM_FIELD_WEBSITE_COMPANY",
       "FRM_FIELD_EMAIL_COMPANY",
       "FRM_FIELD_POSTAL_CODE_HOME",
       "FRM_FIELD_KTP_NO"
        
        
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
		TYPE_LONG,
        TYPE_LONG,
		TYPE_INT,
        TYPE_DATE,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING,
		TYPE_STRING,
        TYPE_STRING,
        
        //new
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
        
	} ;

	public FrmContactList(){
	}
	public FrmContactList(ContactList contactList){
		this.contactList = contactList;
	}

	public FrmContactList(HttpServletRequest request, ContactList contactList){
		super(new FrmContactList(contactList), request);
		this.contactList = contactList;
	}

	public String getFormName() { return FRM_NAME_CONTACTLIST; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public ContactList getEntityObject(){ return contactList; }

	public void requestEntityObject(ContactList contactList) {
		try{
			this.requestParam();
			contactList.setContactCode(getString(FRM_FIELD_CONTACT_CODE));
			contactList.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
			contactList.setParentId(getLong(FRM_FIELD_PARENT_ID));
			contactList.setContactType(getInt(FRM_FIELD_CONTACT_TYPE));
			contactList.setRegdate(getDate(FRM_FIELD_REGDATE));
			contactList.setCompName(getString(FRM_FIELD_COMP_NAME));
			contactList.setPersonName(getString(FRM_FIELD_PERSON_NAME));
			contactList.setPersonLastname(getString(FRM_FIELD_PERSON_LASTNAME));
			contactList.setBussAddress(getString(FRM_FIELD_BUSS_ADDRESS));
			contactList.setTown(getString(FRM_FIELD_TOWN));
			contactList.setProvince(getString(FRM_FIELD_PROVINCE));
			contactList.setCountry(getString(FRM_FIELD_COUNTRY));
			contactList.setTelpNr(getString(FRM_FIELD_TELP_NR));
			contactList.setTelpMobile(getString(FRM_FIELD_TELP_MOBILE));
			contactList.setFax(getString(FRM_FIELD_FAX));
			contactList.setHomeAddr(getString(FRM_FIELD_HOME_ADDR));
			contactList.setHomeTown(getString(FRM_FIELD_HOME_TOWN));
			contactList.setHomeProvince(getString(FRM_FIELD_HOME_PROVINCE));
			contactList.setHomeCountry(getString(FRM_FIELD_HOME_COUNTRY));
			contactList.setHomeTelp(getString(FRM_FIELD_HOME_TELP));
			contactList.setHomeFax(getString(FRM_FIELD_HOME_FAX));
			contactList.setNotes(getString(FRM_FIELD_NOTES));
			contactList.setBankAcc(getString(FRM_FIELD_BANK_ACC));
			contactList.setBankAcc2(getString(FRM_FIELD_BANK_ACC2));
			contactList.setEmail(getString(FRM_FIELD_EMAIL));
                        
                        //new
                        contactList.setCompanyBankAcc(getString(FRM_FIELD_COMPANY_BANK_ACC));
                        contactList.setPositionPerson(getString(FRM_FIELD_POSITION_PERSON));
                        contactList.setPostalCodeCompany(getString(FRM_FIELD_POSTAL_CODE_COMPANY));
                        contactList.setWebsiteCompany(getString(FRM_FIELD_WEBSITE_COMPANY));
                        contactList.setEmailCompany(getString(FRM_FIELD_EMAIL_COMPANY));
                        contactList.setPostalCodeHome(getString(FRM_FIELD_POSTAL_CODE_HOME));
                        
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
