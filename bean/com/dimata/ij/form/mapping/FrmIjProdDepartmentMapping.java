/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.ij.form.mapping;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.ij.entity.mapping.*;

/**
 *
 * @author Mirahu
 */
public class FrmIjProdDepartmentMapping extends FRMHandler implements I_FRMInterface, I_FRMType {
    private IjProdDepartmentMapping ijProdDepartmentMapping;

	public static final String FRM_NAME_IJPRODDEPARTMENTMAPPING		=  "FRM_NAME_IJPRODDEPARTMENTMAPPING" ;

	public static final int FRM_FIELD_IJ_MAP_PROD_DEPARTMENT_ID		=  0 ;
        public static final int FRM_FIELD_IJ_MAP_LOCATION_ID			=  1 ;
	public static final int FRM_FIELD_PROD_DEPARTMENT_ID			=  2 ;
	

	public static String[] fieldNames = {
		"FRM_FIELD_IJ_MAP_PROD_DEPARTMENT_ID",
                "FRM_FIELD_IJ_MAP_LOCATION_ID",
                "FRM_FIELD_PROD_DEPARTMENT_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  
		TYPE_LONG,
                TYPE_LONG
	} ;

	public FrmIjProdDepartmentMapping(){
	}
	public FrmIjProdDepartmentMapping(IjProdDepartmentMapping ijProdDepartmentMapping){
		this.ijProdDepartmentMapping = ijProdDepartmentMapping;
	}

	public FrmIjProdDepartmentMapping(HttpServletRequest request, IjProdDepartmentMapping ijProdDepartmentMapping){
		super(new FrmIjProdDepartmentMapping(ijProdDepartmentMapping), request);
		this.ijProdDepartmentMapping = ijProdDepartmentMapping;
	}

	public String getFormName() { return FRM_NAME_IJPRODDEPARTMENTMAPPING; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public IjProdDepartmentMapping getEntityObject(){ return ijProdDepartmentMapping; }

	public void requestEntityObject(IjProdDepartmentMapping ijProdDepartmentMapping) {
		try{
			this.requestParam();
			
			ijProdDepartmentMapping.setIjMapLocationId(getLong(FRM_FIELD_IJ_MAP_LOCATION_ID));
			ijProdDepartmentMapping.setProdDepartmentId(getLong(FRM_FIELD_PROD_DEPARTMENT_ID));
			
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
    

}
