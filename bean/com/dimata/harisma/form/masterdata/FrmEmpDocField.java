/* Created on 	:  30 September 2011 [time] AM/PM
 *
 * @author  	:  Ari_20110930
 * @version  	:  [version]
 */

/*******************************************************************
 * Class Description 	: FrmCompany
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 *******************************************************************/

package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Priska
 */

/* java package */

import com.dimata.harisma.entity.employee.Employee;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* qdep package */
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.util.Formater;

public class FrmEmpDocField extends FRMHandler implements I_FRMInterface, I_FRMType{
    private EmpDocField empDocField;

    public static final String FRM_NAME_EMP_DOC_FIELD = "FRM_NAME_EMP_DOC_FIELD";

    public static final int FRM_FIELD_EMP_DOC_FIELD_ID = 0;
    public static final int FRM_FIELD_OBJECT_NAME = 1;
    public static final int FRM_FIELD_OBJECT_TYPE = 2;
    public static final int FRM_FIELD_VALUE = 3;
    public static final int FRM_FIELD_EMP_DOC_ID = 4;
    
    public static final int FRM_FIELD_VALUE_DATE = 5;
    
    public static final int FRM_FIELD_CLASS_NAME = 6;
    public static final int FRM_FIELD_VALUE_LONG = 7;
    
    public static String[] fieldNames = {
       
        "FRM_FIELD_EMP_DOC_FIELD_ID",
        "FRM_FIELD_OBJECT_NAME",
        "FRM_FIELD_OBJECT_TYPE",
        "FRM_FIELD_VALUE",
        "FRM_FIELD_EMP_DOC_ID",
        
        "FRM_FIELD_VALUE_DATE",
        
        "FRM_FIELD_CLASS_NAME",
        
        "FRM_FIELD_VALUE_LONG"
    };

    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG
    };

    public FrmEmpDocField() {
    }

    public FrmEmpDocField(EmpDocField empDocField) {
        this.empDocField = empDocField;
    }

    public FrmEmpDocField(HttpServletRequest request, EmpDocField empDocField) {
        super(new FrmEmpDocField(empDocField), request);
        this.empDocField = empDocField;
    }

    public String getFormName() {
        return FRM_NAME_EMP_DOC_FIELD;
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

    public EmpDocField getEntityObject() {
        return empDocField;
    }

    public void requestEntityObject(EmpDocField empDocField) {
        try {
            this.requestParam();
            empDocField.setEmp_doc_id(getLong(FRM_FIELD_EMP_DOC_ID));
            empDocField.setObject_name(getString(FRM_FIELD_OBJECT_NAME));
            empDocField.setObject_type(getInt(FRM_FIELD_OBJECT_TYPE));
            
            empDocField.setClassName(getString(FRM_FIELD_CLASS_NAME));
            
            if ((getInt(FRM_FIELD_OBJECT_TYPE)) == 0  ){ //textfield
                empDocField.setValue(getString(FRM_FIELD_VALUE));
            } else if (((getInt(FRM_FIELD_OBJECT_TYPE)) == 1  )){ //date
                empDocField.setValue(String.valueOf(Formater.formatDate(getDate(FRM_FIELD_VALUE_DATE), "yyyy-MM-dd")).toString());
            }  else if (((getInt(FRM_FIELD_OBJECT_TYPE)) == 2  )){ //long
                empDocField.setValue(String.valueOf(getLong(FRM_FIELD_VALUE_LONG)));
            }     
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
