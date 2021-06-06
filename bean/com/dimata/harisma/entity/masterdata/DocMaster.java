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
public class DocMaster extends Entity { 

   
	private long doc_master_id ;
	private long doc_type_id ;
        private String doc_title = "";
        private String description = "";
        private String doc_number = "";
        private String doc_code = "";

  
    /**
     * @return the doc_title
     */
    public String getDoc_title() {
        return doc_title;
    }

    /**
     * @param doc_title the doc_title to set
     */
    public void setDoc_title(String doc_title) {
        this.doc_title = doc_title;
    }

    /**
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * @return the doc_master_id
     */
    public long getDoc_master_id() {
        return doc_master_id;
    }

    /**
     * @param doc_master_id the doc_master_id to set
     */
    public void setDoc_master_id(long doc_master_id) {
        this.doc_master_id = doc_master_id;
    }

    /**
     * @return the doc_type_id
     */
    public long getDoc_type_id() {
        return doc_type_id;
    }

    /**
     * @param doc_type_id the doc_type_id to set
     */
    public void setDoc_type_id(long doc_type_id) {
        this.doc_type_id = doc_type_id;
    }

    /**
     * @return the doc_number
     */
    public String getDoc_number() {
        return doc_number;
    }

    /**
     * @param doc_number the doc_number to set
     */
    public void setDoc_number(String doc_number) {
        this.doc_number = doc_number;
    }
    
    /**
     * @return the doc_code
     */
    public String getDoc_code() {
        return doc_code;
    }

    /**
     * @param doc_code the doc_code to set
     */
    public void setDoc_code(String doc_code) {
        this.doc_code = doc_code;
    }

}
