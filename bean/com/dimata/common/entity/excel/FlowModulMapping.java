/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.entity.excel;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Gunadi
 */
public class FlowModulMapping extends Entity {

    private long flowModulId = 0;
    private String fieldName = "";
    private int dataType = 0;
    private String columnName = "";
    private String dataExample = "";
    private int columnLevel = 0;
    private int type = 0;
    private String dataTable = "";
    private String dataColumn = "";
    private int inputType = 0;
    private String dataValue = "";

    public long getFlowModulId() {
        return flowModulId;
    }

    public void setFlowModulId(long flowModulId) {
        this.flowModulId = flowModulId;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public int getDataType() {
        return dataType;
    }

    public void setDataType(int dataType) {
        this.dataType = dataType;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getDataExample() {
        return dataExample;
    }

    public void setDataExample(String dataExample) {
        this.dataExample = dataExample;
    }

    /**
     * @return the columnLevel
     */
    public int getColumnLevel() {
        return columnLevel;
    }

    /**
     * @param columnLevel the columnLevel to set
     */
    public void setColumnLevel(int columnLevel) {
        this.columnLevel = columnLevel;
    }

    /**
     * @return the type
     */
    public int getType() {
        return type;
    }

    /**
     * @param type the type to set
     */
    public void setType(int required) {
        this.type = required;
    }

    /**
     * @return the dataTable
     */
    public String getDataTable() {
        return dataTable;
    }

    /**
     * @param dataTable the dataTable to set
     */
    public void setDataTable(String dataTable) {
        this.dataTable = dataTable;
    }

    /**
     * @return the dataColumn
     */
    public String getDataColumn() {
        return dataColumn;
    }

    /**
     * @param dataColumn the dataColumn to set
     */
    public void setDataColumn(String dataColumn) {
        this.dataColumn = dataColumn;
    }

    /**
     * @return the inputType
     */
    public int getInputType() {
        return inputType;
    }

    /**
     * @param inputType the inputType to set
     */
    public void setInputType(int inputType) {
        this.inputType = inputType;
    }

    /**
     * @return the dataValue
     */
    public String getDataValue() {
        return dataValue;
    }

    /**
     * @param dataValue the dataValue to set
     */
    public void setDataValue(String dataValue) {
        this.dataValue = dataValue;
    }
}