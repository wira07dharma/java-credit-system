/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author GUSWIK
 */
public class EmpDocField extends Entity{
    private long emp_doc_field_id ; 
     private long emp_doc_id ; 
     private String value ;
     private String object_name ;
     private int object_type ;

     
     private String className ;
    /**
     * @return the emp_doc_field_id
     */
    public long getEmp_doc_field_id() {
        return emp_doc_field_id;
    }

    /**
     * @param emp_doc_field_id the emp_doc_field_id to set
     */
    public void setEmp_doc_field_id(long emp_doc_field_id) {
        this.emp_doc_field_id = emp_doc_field_id;
    }

    /**
     * @return the emp_doc_id
     */
    public long getEmp_doc_id() {
        return emp_doc_id;
    }

    /**
     * @param emp_doc_id the emp_doc_id to set
     */
    public void setEmp_doc_id(long emp_doc_id) {
        this.emp_doc_id = emp_doc_id;
    }

    /**
     * @return the value
     */
    public String getValue() {
        if (value == null){
            value = "";
        }
        return value;
    }

    /**
     * @param value the value to set
     */
    public void setValue(String value) {
        this.value = value;
    }

    /**
     * @return the object_name
     */
    public String getObject_name() {
        return object_name;
    }

    /**
     * @param object_name the object_name to set
     */
    public void setObject_name(String object_name) {
        this.object_name = object_name;
    }

    /**
     * @return the object_type
     */
    public int getObject_type() {
        return object_type;
    }

    /**
     * @param object_type the object_type to set
     */
    public void setObject_type(int object_type) {
        this.object_type = object_type;
    }

    /**
     * @return the className
     */
    public String getClassName() {
        if (className == null){
            className = "";
        }
        return className;
    }

    /**
     * @param className the className to set
     */
    public void setClassName(String className) {
        this.className = className;
    }


}
