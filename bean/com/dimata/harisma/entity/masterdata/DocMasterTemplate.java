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
public class DocMasterTemplate extends Entity{ 
     private long doc_master_template_id ; 
     private long doc_master_id ; 
     private String template_title ;
     private String template_filename ;
     private String text_template ;
     private String text_header ;
     private String text_footer ;
     private float topMargin = 0;
     private float rightMargin = 0;
     private float leftMargin = 0;
     private float bottomMargin = 0;
    /**
     * @return the doc_master_template_id
     */
    public long getDoc_master_template_id() {
        return doc_master_template_id;
    }

    /**
     * @param doc_master_template_id the doc_master_template_id to set
     */
    public void setDoc_master_template_id(long doc_master_template_id) {
        this.doc_master_template_id = doc_master_template_id;
    }

    /**
     * @return the template_title
     */
    public String getTemplate_title() {
         if (template_title == null){
            template_title="";
        }
        return template_title;
    }

    /**
     * @param template_title the template_title to set
     */
    public void setTemplate_title(String template_title) {
        this.template_title = template_title;
    }

    /**
     * @return the template_filename
     */
    public String getTemplate_filename() {
        if (template_filename == null){
            template_filename="";
        }
        return template_filename;
    }

    /**
     * @param template_filename the template_filename to set
     */
    public void setTemplate_filename(String template_filename) {
        this.template_filename = template_filename;
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
     * @return the text_template
     */
    public String getText_template() {
        if (text_template == null){
            text_template = "";
        }
        return text_template;
    }

    /**
     * @param text_template the text_template to set
     */
    public void setText_template(String text_template) {
        this.text_template = text_template;
    }

    /**
     * @return the text_header
     */
    public String getText_header() {
        return text_header;
    }

    /**
     * @param text_header the text_header to set
     */
    public void setText_header(String text_header) {
        this.text_header = text_header;
    }

    /**
     * @return the text_footer
     */
    public String getText_footer() {
        return text_footer;
    }

    /**
     * @param text_footer the text_footer to set
     */
    public void setText_footer(String text_footer) {
        this.text_footer = text_footer;
    }

    /**
     * @return the topMargin
     */
    public float getTopMargin() {
        return topMargin;
    }

    /**
     * @param topMargin the topMargin to set
     */
    public void setTopMargin(float topMargin) {
        this.topMargin = topMargin;
    }

    /**
     * @return the rightMargin
     */
    public float getRightMargin() {
        return rightMargin;
    }

    /**
     * @param rightMargin the rightMargin to set
     */
    public void setRightMargin(float rightMargin) {
        this.rightMargin = rightMargin;
    }

    /**
     * @return the leftMargin
     */
    public float getLeftMargin() {
        return leftMargin;
    }

    /**
     * @param leftMargin the leftMargin to set
     */
    public void setLeftMargin(float leftMargin) {
        this.leftMargin = leftMargin;
    }

    /**
     * @return the bottomMargin
     */
    public float getBottomMargin() {
        return bottomMargin;
    }

    /**
     * @param bottomMargin the bottomMargin to set
     */
    public void setBottomMargin(float bottomMargin) {
        this.bottomMargin = bottomMargin;
    }
}
