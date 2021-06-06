/* Created on 	:  30 September 2011 [time] AM/PM
 *
 * @author  	:  Ari_20110930
 * @version  	:  [version]
 */
/**
 * *****************************************************************
 * Class Description : FrmCompany Imput Parameters : [input parameter ...]
 * Output : [output ...]
 ******************************************************************
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Priska
 */

/* java package */
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* qdep package */
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.harisma.entity.masterdata.*;
import static com.dimata.qdep.form.I_FRMType.TYPE_SPECIALSTRING;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class FrmEmpDoc extends FRMHandler implements I_FRMInterface, I_FRMType{
     private EmpDoc empDoc;

    public static final String FRM_NAME_EMP_DOC = "FRM_NAME_EMP_DOC";
 
 public static final int FRM_FIELD_EMP_DOC_ID = 0; 
 public static final int FRM_FIELD_DOC_MASTER_ID = 1 ; 
 public static final int FRM_FIELD_DOC_TITLE = 2 ;
 public static final int FRM_FIELD_REQUEST_DATE = 3 ;
 public static final int FRM_FIELD_DOC_NUMBER = 4 ;
 public static final int FRM_FIELD_DATE_OF_ISSUE = 5 ;
 public static final int FRM_FIELD_PLAN_DATE_FROM = 6 ;
 public static final int FRM_FIELD_PLAN_DATE_TO = 7 ;
 public static final int FRM_FIELD_REAL_DATE_FROM = 8 ;
 public static final int FRM_FIELD_REAL_DATE_TO = 9 ;
 public static final int FRM_FIELD_OBJECTIVES = 10 ;
 public static final int FRM_FIELD_DETAILS = 11 ;
 public static final int FRM_FIELD_COUNTRY_ID = 12 ;
 public static final int FRM_FIELD_PROVINCE_ID = 13 ;
 public static final int FRM_FIELD_REGION_ID = 14 ;
 public static final int FRM_FIELD_SUBREGION_ID = 15 ;
 public static final int FRM_FIELD_GEO_ADDRESS = 16 ;
    
 
 public static final int FRM_FIELD_EMPLOYEE_ID = 17 ;   
    
 public static final int FRM_FIELD_DOCH_ATTACH_FILE = 18 ;  
 public static final int FRM_FIELD_FILE_NAME = 19 ; 
 public static final int FRM_FIELD_REQUEST_DATE_STRING = 20;
 public static final int FRM_FIELD_DATE_OF_ISSUE_STRING = 21;
    /* Update by Hendra Putu | 2016-09-07 */
    public static final int FRM_FIELD_COMPANY_ID = 22;
    public static final int FRM_FIELD_DIVISION_ID = 23;
    public static final int FRM_FIELD_DEPARTMENT_ID = 24;
    public static final int FRM_FIELD_SECTION_ID = 25;
    public static final int FRM_FIELD_DOC_STATUS = 26;
    public static final int FRM_FIELD_PINJAMAN_ID = 27;
    public static String[] fieldNames = {
       
 "FRM_FIELD_EMP_DOC_ID", 
 "FRM_FIELD_DOC_MASTER_ID", 
 "FRM_FIELD_DOC_TITLE",
 "FRM_FIELD_REQUEST_DATE",
 "FRM_FIELD_DOC_NUMBER",
 "FRM_FIELD_DATE_OF_ISSUE",
 "FRM_FIELD_PLAN_DATE_FROM",
 "FRM_FIELD_PLAN_DATE_TO",
 "FRM_FIELD_REAL_DATE_FROM",
 "FRM_FIELD_REAL_DATE_TO",
 "FRM_FIELD_OBJECTIVES",
 "FRM_FIELD_DETAILS",
 "FRM_FIELD_COUNTRY_ID",
 "FRM_FIELD_PROVINCE_ID",
 "FRM_FIELD_REGION_ID",
 "FRM_FIELD_SUBREGION_ID",
 "FRM_FIELD_GEO_ADDRESS",
 "FRM_FIELD_EMPLOYEE_ID",
 "FRM_FIELD_DOCH_ATTACH_FILE",
 "FRM_FIELD_FILE_NAME",
 "FRM_FIELD_REQUEST_DATE_STRING",
        "FRM_FIELD_DATE_OF_ISSUE_STRING",
        "FRM_FIELD_COMPANY_ID",
        "FRM_FIELD_DIVISION_ID",
        "FRM_FIELD_DEPARTMENT_ID",
        "FRM_FIELD_SECTION_ID",
        "FRM_FIELD_DOC_STATUS",
        "FRM_FIELD_PINJAMAN_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_SPECIALSTRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG
    };
    private HttpServletRequest request;

    public FrmEmpDoc() {
    }

    public FrmEmpDoc(EmpDoc empDoc) {
        this.empDoc = empDoc;
    }

    public FrmEmpDoc(HttpServletRequest request, EmpDoc empDoc) {
        super(new FrmEmpDoc(empDoc), request);
        this.empDoc = empDoc;
    }

    public String getFormName() {
        return FRM_NAME_EMP_DOC;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public EmpDoc getEntityObject() {
        return empDoc;
    }

    public void requestEntityObject(EmpDoc empDoc) {
        try {
            this.requestParam();
            String requestDate = getString(FRM_FIELD_REQUEST_DATE_STRING);
            String issueDate = getString(FRM_FIELD_DATE_OF_ISSUE_STRING);
            Date dateRequest = null;
            Date dateIssue = null;
            DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            ////
            if (requestDate.length() > 0){
                dateRequest = format.parse(requestDate);
                empDoc.setRequest_date(dateRequest);
            } else {
                empDoc.setRequest_date(getDate(FRM_FIELD_REQUEST_DATE));
            }
            if (issueDate.length() > 0){
                dateIssue = format.parse(issueDate);
                empDoc.setDate_of_issue(dateIssue);
            } else {
                empDoc.setDate_of_issue(getDate(FRM_FIELD_DATE_OF_ISSUE));
            }

            empDoc.setDoc_master_id(getLong(FRM_FIELD_DOC_MASTER_ID));
            empDoc.setDoc_title(getString(FRM_FIELD_DOC_TITLE));
            
            empDoc.setDoc_number(getString(FRM_FIELD_DOC_NUMBER));
            
            empDoc.setPlan_date_from(getDate(FRM_FIELD_PLAN_DATE_FROM));
            empDoc.setPlan_date_to(getDate(FRM_FIELD_PLAN_DATE_TO));
            empDoc.setReal_date_from(getDate(FRM_FIELD_REAL_DATE_FROM));
            empDoc.setReal_date_to(getDate(FRM_FIELD_REAL_DATE_TO));
            empDoc.setObjectives(getString(FRM_FIELD_OBJECTIVES));
            empDoc.setDetails(getString(FRM_FIELD_DETAILS));
            empDoc.setCountry_id(getLong(FRM_FIELD_COUNTRY_ID));
            empDoc.setProvince_id(getLong(FRM_FIELD_PROVINCE_ID));
            empDoc.setRegion_id(getLong(FRM_FIELD_REGION_ID));
            empDoc.setSubregion_id(getLong(FRM_FIELD_SUBREGION_ID));
            empDoc.setGeo_address(getString(FRM_FIELD_GEO_ADDRESS));
            empDoc.setDocAttachFile(getString(FRM_FIELD_DOCH_ATTACH_FILE));
            empDoc.setFileName(getString(FRM_FIELD_FILE_NAME));
            
            empDoc.setCompanyId(getLong(FRM_FIELD_COMPANY_ID));
            empDoc.setDivisionId(getLong(FRM_FIELD_DIVISION_ID));
            empDoc.setDepartmentId(getLong(FRM_FIELD_DEPARTMENT_ID));
            empDoc.setSectionId(getLong(FRM_FIELD_SECTION_ID));
            empDoc.setDocStatus(getInt(FRM_FIELD_DOC_STATUS));
            empDoc.setPinjamanId(getLong(FRM_FIELD_PINJAMAN_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
