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

public class FrmDocMasterTemplate extends FRMHandler implements I_FRMInterface, I_FRMType{
     private DocMasterTemplate docMasterTemplate;

    public static final String FRM_NAME_DOC_MASTER_TEMPLATE = "FRM_NAME_DOC_MASTER_TEMPLATE";

    public static final int FRM_FIELD_DOC_MASTER_TEMPLATE_ID = 0;
  public static final int FRM_FIELD_DOC_MASTER_ID = 1;
  public static final int FRM_FIELD_TEMPLATE_TITLE = 2;
  public static final int FRM_FIELD_TEMPLATE_FILE_NAME = 3;
  public static final int FRM_FIELD_TEXT_TEMPLATE = 4;
  public static final int FRM_FIELD_TEXT_HEADER = 5;
  public static final int FRM_FIELD_TEXT_FOOTER = 6;
  public static final int FRM_FIELD_TOP_MARGIN = 7;
  public static final int FRM_FIELD_RIGHT_MARGIN = 8;
  public static final int FRM_FIELD_LEFT_MARGIN = 9;
  public static final int FRM_FIELD_BOTTOM_MARGIN = 10;
    
    public static String[] fieldNames = {
    "FRM_FIELD_DOC_MASTER_TEMPLATE_ID",
    "FRM_FIELD_DOC_MASTER_ID",
    "FRM_FIELD_TEMPLATE_TITLE",
    "FRM_FIELD_TEMPLATE_FILE_NAME",
    "FRM_FIELD_TEXT_TEMPLATE",
    "FRM_FIELD_TEXT_HEADER",
    "FRM_FIELD_TEXT_FOOTER",
    "FRM_FIELD_TOP_MARGIN",
    "FRM_FIELD_RIGHT_MARGIN",
    "FRM_FIELD_LEFT_MARGIN",
    "FRM_FIELD_BOTTOM_MARGIN"
    };

    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_SPECIALSTRING,
        TYPE_SPECIALSTRING,
        TYPE_SPECIALSTRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    public FrmDocMasterTemplate() {
    }

    public FrmDocMasterTemplate(DocMasterTemplate docMasterTemplate) {
        this.docMasterTemplate = docMasterTemplate;
    }

    public FrmDocMasterTemplate(HttpServletRequest request, DocMasterTemplate docMasterTemplate) {
        super(new FrmDocMasterTemplate(docMasterTemplate), request);
        this.docMasterTemplate = docMasterTemplate;
    }

    public String getFormName() {
        return FRM_NAME_DOC_MASTER_TEMPLATE;
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

    public DocMasterTemplate getEntityObject() {
        return docMasterTemplate;
    }

    public void requestEntityObject(DocMasterTemplate docMasterTemplate) {
        try {
            this.requestParam();
            docMasterTemplate.setDoc_master_id(getLong(FRM_FIELD_DOC_MASTER_ID));
            docMasterTemplate.setTemplate_title(getString(FRM_FIELD_TEMPLATE_TITLE));
            docMasterTemplate.setTemplate_filename(getString(FRM_FIELD_TEMPLATE_FILE_NAME));
            docMasterTemplate.setText_template(getString(FRM_FIELD_TEXT_TEMPLATE));
            docMasterTemplate.setText_header(getString(FRM_FIELD_TEXT_HEADER));
            docMasterTemplate.setText_footer(getString(FRM_FIELD_TEXT_FOOTER));
            docMasterTemplate.setTopMargin(getFloat(FRM_FIELD_TOP_MARGIN));
            docMasterTemplate.setRightMargin(getFloat(FRM_FIELD_RIGHT_MARGIN));
            docMasterTemplate.setLeftMargin(getFloat(FRM_FIELD_LEFT_MARGIN));
            docMasterTemplate.setBottomMargin(getFloat(FRM_FIELD_BOTTOM_MARGIN));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
