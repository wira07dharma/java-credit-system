/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;
import java.util.Date;

/**
 *
 * @author GUSWIK
 */
public class EmpDoc extends Entity {

    private long emp_doc_id = 0;
    private long doc_master_id = 0;
    private String doc_title = "";
    private Date request_date;
    private String doc_number = "";
    private Date date_of_issue = null;
    private Date plan_date_from = null;
    private Date plan_date_to = null;
    private Date real_date_from = null;
    private Date real_date_to = null;
    private String objectives = "";
    private String details = "";
    private long country_id = 0;
    private long province_id = 0;
    private long region_id = 0;
    private long subregion_id = 0;
    private String geo_address = "";
    private String docAttachFile = "";
    private String fileName = "";
    /* Update by Hendra Putu | 2016-07-15 */
    //private long empDocSeriesId = 0;
    /* Update by Hendra Putu | 2016-09-07 */
    private long companyId = 0;
    private long divisionId = 0;
    private long departmentId = 0;
    private long sectionId = 0;
    private int docStatus = 0;
    private long pinjamanId = 0;
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
     * @return the request_date
     */
    public Date getRequest_date() {
        return request_date;
    }

    /**
     * @param request_date the request_date to set
     */
    public void setRequest_date(Date request_date) {
        this.request_date = request_date;
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
     * @return the date_of_issue
     */
    public Date getDate_of_issue() {
        return date_of_issue;
    }

    /**
     * @param date_of_issue the date_of_issue to set
     */
    public void setDate_of_issue(Date date_of_issue) {
        this.date_of_issue = date_of_issue;
    }

    /**
     * @return the plan_date_from
     */
    public Date getPlan_date_from() {
        return plan_date_from;
    }

    /**
     * @param plan_date_from the plan_date_from to set
     */
    public void setPlan_date_from(Date plan_date_from) {
        this.plan_date_from = plan_date_from;
    }

    /**
     * @return the plan_date_to
     */
    public Date getPlan_date_to() {
        return plan_date_to;
    }

    /**
     * @param plan_date_to the plan_date_to to set
     */
    public void setPlan_date_to(Date plan_date_to) {
        this.plan_date_to = plan_date_to;
    }

    /**
     * @return the real_date_from
     */
    public Date getReal_date_from() {
        return real_date_from;
    }

    /**
     * @param real_date_from the real_date_from to set
     */
    public void setReal_date_from(Date real_date_from) {
        this.real_date_from = real_date_from;
    }

    /**
     * @return the real_date_to
     */
    public Date getReal_date_to() {
        return real_date_to;
    }

    /**
     * @param real_date_to the real_date_to to set
     */
    public void setReal_date_to(Date real_date_to) {
        this.real_date_to = real_date_to;
    }

    /**
     * @return the objectives
     */
    public String getObjectives() {
        return objectives;
    }

    /**
     * @param objectives the objectives to set
     */
    public void setObjectives(String objectives) {
        this.objectives = objectives;
    }

    /**
     * @return the details
     */
    public String getDetails() {
        return details;
    }

    /**
     * @param details the details to set
     */
    public void setDetails(String details) {
        this.details = details;
    }

    /**
     * @return the country_id
     */
    public long getCountry_id() {
        return country_id;
    }

    /**
     * @param country_id the country_id to set
     */
    public void setCountry_id(long country_id) {
        this.country_id = country_id;
    }

    /**
     * @return the province_id
     */
    public long getProvince_id() {
        return province_id;
    }

    /**
     * @param province_id the province_id to set
     */
    public void setProvince_id(long province_id) {
        this.province_id = province_id;
    }

    /**
     * @return the region_id
     */
    public long getRegion_id() {
        return region_id;
    }

    /**
     * @param region_id the region_id to set
     */
    public void setRegion_id(long region_id) {
        this.region_id = region_id;
    }

    /**
     * @return the subregion_id
     */
    public long getSubregion_id() {
        return subregion_id;
    }

    /**
     * @param subregion_id the subregion_id to set
     */
    public void setSubregion_id(long subregion_id) {
        this.subregion_id = subregion_id;
    }

    /**
     * @return the geo_address
     */
    public String getGeo_address() {
        return geo_address;
    }

    /**
     * @param geo_address the geo_address to set
     */
    public void setGeo_address(String geo_address) {
        this.geo_address = geo_address;
    }

    /**
     * @return the docAttachFile
     */
    public String getDocAttachFile() {
        return docAttachFile;
    }

    /**
     * @param docAttachFile the docAttachFile to set
     */
    public void setDocAttachFile(String docAttachFile) {
        this.docAttachFile = docAttachFile;
    }

    /**
     * @return the fileName
     */
    public String getFileName() {
        return fileName;
    }

    /**
     * @param fileName the fileName to set
     */
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    /**
     * @return the companyId
     */
    public long getCompanyId() {
        return companyId;
    }

    /**
     * @param companyId the companyId to set
     */
    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    /**
     * @return the divisionId
     */
    public long getDivisionId() {
        return divisionId;
}

    /**
     * @param divisionId the divisionId to set
     */
    public void setDivisionId(long divisionId) {
        this.divisionId = divisionId;
    }

    /**
     * @return the departmentId
     */
    public long getDepartmentId() {
        return departmentId;
    }

    /**
     * @param departmentId the departmentId to set
     */
    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    /**
     * @return the sectionId
     */
    public long getSectionId() {
        return sectionId;
    }

    /**
     * @param sectionId the sectionId to set
     */
    public void setSectionId(long sectionId) {
        this.sectionId = sectionId;
    }

    /**
     * @return the docStatus
     */
    public int getDocStatus() {
        return docStatus;
    }

    /**
     * @param docStatus the docStatus to set
     */
    public void setDocStatus(int docStatus) {
        this.docStatus = docStatus;
    }

    /**
     * @return the pinjamanId
     */
    public long getPinjamanId() {
        return pinjamanId;
    }

    /**
     * @param pinjamanId the pinjamanId to set
     */
    public void setPinjamanId(long pinjamanId) {
        this.pinjamanId = pinjamanId;
    }

}