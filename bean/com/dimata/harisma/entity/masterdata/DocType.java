/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;
import com.dimata.sedana.session.json.JSONObject;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author GUSWIK
 */
public class DocType extends Entity implements Cloneable { 

   
	private int doc_type_id ;
	private String type_name = "";
        private String description = "";

    /**
     * @return the doc_type_id
     */
    public int getDoc_type_id() {
        return doc_type_id;
    }

    /**
     * @param doc_type_id the doc_type_id to set
     */
    public void setDoc_type_id(int doc_type_id) {
        this.doc_type_id = doc_type_id;
    }

    /**
     * @return the type_name
     */
    public String getType_name() {
        return type_name;
    }

    /**
     * @param type_name the type_name to set
     */
    public void setType_name(String type_name) {
        this.type_name = type_name;
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
    
    public JSONObject historyCompare(DocType o) {
      JSONObject j = new JSONObject();
      if(!getType_name().equals(o.getType_name()))
        j.put("Nama", "Dari "+getType_name()+" menjadi "+o.getType_name());
      if(!getDescription().equals(o.getDescription()))
        j.put("Deskripsi", "Dari "+getDescription()+" menjadi "+o.getDescription());
      return j;
    }
    
    public JSONObject historyNew() {
      JSONObject j = new JSONObject();
      j.put("Nama", getType_name());
      j.put("Deskripsi", getDescription());
      return j;
    }
    
    public DocType clone() {
      Object o = null;
      try {
        o = super.clone();;
      } catch (CloneNotSupportedException ex) {
        System.err.println(ex);
      }
      return (DocType) o;
    }
        
}
