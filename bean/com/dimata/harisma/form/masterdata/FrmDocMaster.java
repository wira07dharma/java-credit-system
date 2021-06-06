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

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* qdep package */
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.harisma.entity.masterdata.*;

public class FrmDocMaster extends FRMHandler implements I_FRMInterface, I_FRMType{
     private DocMaster docMaster;

    public static final String FRM_NAME_DOC_MASTER = "FRM_NAME_DOC_MASTER";

    public static final int FRM_FIELD_DOC_MASTER_ID = 0;
    public static final int FRM_FIELD_DOC_TYPE_ID = 1;
    public static final int FRM_FIELD_TITLE = 2;
    public static final int FRM_FIELD_DESCRIPTION = 3;
    public static final int FRM_FIELD_DOC_NUMBER = 4;
    public static final int FRM_FIELD_DOC_CODE = 5;
    
    public static String[] fieldNames = {
       
        "FRM_FIELD_DOC_MASTER_ID",
        "FRM_FIELD_DOC_TYPE_ID",
        "FRM_FIELD_TITLE",
        "FRM_FIELD_DESCRIPTION",
        "FRM_FIELD_DOC_NUMBER",
        "FRM_FIELD_DOC_CODE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmDocMaster() {
    }

    public FrmDocMaster(DocMaster docMaster) {
        this.docMaster = docMaster;
    }

    public FrmDocMaster(HttpServletRequest request, DocMaster docMaster) {
        super(new FrmDocMaster(docMaster), request);
        this.docMaster = docMaster;
    }

    public String getFormName() {
        return FRM_NAME_DOC_MASTER;
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

    public DocMaster getEntityObject() {
        return docMaster;
    }

    public void requestEntityObject(DocMaster docMaster) {
        try {
            this.requestParam();
            docMaster.setDoc_type_id(getLong(FRM_FIELD_DOC_TYPE_ID));
            docMaster.setDoc_title(getString(FRM_FIELD_TITLE));
            docMaster.setDescription(getString(FRM_FIELD_DESCRIPTION));
            docMaster.setDoc_number(getString(FRM_FIELD_DOC_NUMBER));
            docMaster.setDoc_code(getString(FRM_FIELD_DOC_CODE));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
