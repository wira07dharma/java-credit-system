/*
 * Form Name  	:  FrmCategory.java
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

import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.posbo.entity.masterdata.Category;

import javax.servlet.http.HttpServletRequest;

public class FrmCategory extends FRMHandler implements I_FRMInterface, I_FRMType {
    private Category category;

    public static final String FRM_NAME_CATEGORY = "FRM_NAME_CATEGORY";

    public static final int FRM_FIELD_CATEGORY_ID = 0;
    public static final int FRM_FIELD_CODE = 1;
    public static final int FRM_FIELD_NAME = 2;
    public static final int FRM_FIELD_PRICE_POINT = 3;
    public static final int FRM_FIELD_DESCRIPTION = 4;

    public static String[] fieldNames =
            {
                "FRM_FIELD_CATEGORY_ID",
                "FRM_FIELD_CODE",
                "FRM_FIELD_NAME",
                "FRM_FIELD_PRICE_POINT",
                "FRM_FIELD_DESCRIPTION"
            };

    public static int[] fieldTypes =
            {
                TYPE_LONG,
                TYPE_STRING + ENTRY_REQUIRED,
                TYPE_STRING, TYPE_FLOAT,
                TYPE_STRING
            };

    public FrmCategory() {
    }

    public FrmCategory(Category category) {
        this.category = category;
    }

    public FrmCategory(HttpServletRequest request, Category category) {
        super(new FrmCategory(category), request);
        this.category = category;
    }

    public String getFormName() {
        return FRM_NAME_CATEGORY;
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

    public Category getEntityObject() {
        return category;
    }

    public void requestEntityObject(Category category) {
        try {
            this.requestParam();
            category.setCode(getString(FRM_FIELD_CODE));
            category.setName(getString(FRM_FIELD_NAME));
            category.setPointPrice(getDouble(FRM_FIELD_PRICE_POINT));
            category.setDescription(getString(FRM_FIELD_DESCRIPTION));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
