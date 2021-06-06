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

public class FrmDocType extends FRMHandler implements I_FRMInterface, I_FRMType{
     private DocType docType;

    public static final String FRM_NAME_DOC_TYPE = "FRM_NAME_DOC_TYPE";

    public static final int FRM_FIELD_DOC_TYPE_ID = 0;
    public static final int FRM_FIELD_TYPE_NAME = 1;
    public static final int FRM_FIELD_DESCRIPTION = 2;
    
    public static String[] fieldNames = {
       
        "FRM_FIELD_DOC_TYPE_ID",
        "FRM_FIELD_TYPE_NAME",
        "FRM_FIELD_DESCRIPTION"
    };

    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING
    };

    public FrmDocType() {
    }

    public FrmDocType(DocType docType) {
        this.docType = docType;
    }

    public FrmDocType(HttpServletRequest request, DocType docType) {
        super(new FrmDocType(docType), request);
        this.docType = docType;
    }

    public String getFormName() {
        return FRM_NAME_DOC_TYPE;
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

    public DocType getEntityObject() {
        return docType;
    }

    public void requestEntityObject(DocType docType) {
        try {
            this.requestParam();
            docType.setType_name(getString(FRM_FIELD_TYPE_NAME));
            docType.setDescription(getString(FRM_FIELD_DESCRIPTION));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
