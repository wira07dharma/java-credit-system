/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

/**
 *
 * @author Dimata 007
 */
import com.dimata.qdep.entity.Entity;
import java.util.Date;

public class EmpCustomField extends Entity {

    private double dataNumber = 0;
    private String dataText = "";
    private Date dataDate = null;
    private long customFieldId = 0;
    private long employeeId = 0;
    private String fieldName = "";

    public double getDataNumber() {
        return dataNumber;
    }

    public void setDataNumber(double dataNumber) {
        this.dataNumber = dataNumber;
    }

    public String getDataText() {
        return dataText;
    }

    public void setDataText(String dataText) {
        this.dataText = dataText;
    }

    public Date getDataDate() {
        return dataDate;
    }

    public void setDataDate(Date dataDate) {
        this.dataDate = dataDate;
    }

    public long getCustomFieldId() {
        return customFieldId;
    }

    public void setCustomFieldId(long customFieldId) {
        this.customFieldId = customFieldId;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    /**
     * @return the fieldName
     */
    public String getFieldName() {
        return fieldName;
    }

    /**
     * @param fieldName the fieldName to set
     */
    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

}
