/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.tools.db;


/**
 *
 * @author Gunadi
 */
public class MetaData {
    
    private String colName = "";
    private int dataType = 0;
    private int colSize = 0;
    private String pk = "";
    private String pkName = "";
    private String fkTable = "";
    private String fkColumn = "";
    private String pkTable = "";
    private String pkColumn = "";
    
    /**
     * @return the colName
     */
    public String getColName() {
        return colName;
    }

    /**
     * @param colName the colName to set
     */
    public void setColName(String colName) {
        this.colName = colName;
    }

    /**
     * @return the dataType
     */
    public int getDataType() {
        return dataType;
    }

    /**
     * @param dataType the dataType to set
     */
    public void setDataType(int dataType) {
        this.dataType = dataType;
    }

    /**
     * @return the colSize
     */
    public int getColSize() {
        return colSize;
    }

    /**
     * @param colSize the colSize to set
     */
    public void setColSize(int colSize) {
        this.colSize = colSize;
    }

    /**
     * @return the pk
     */
    public String getPk() {
        return pk;
    }

    /**
     * @param pk the pk to set
     */
    public void setPk(String pk) {
        this.pk = pk;
    }

    /**
     * @return the fkTable
     */
    public String getFkTable() {
        return fkTable;
    }

    /**
     * @param fkTable the fkTable to set
     */
    public void setFkTable(String fkTable) {
        this.fkTable = fkTable;
    }

    /**
     * @return the fkColumn
     */
    public String getFkColumn() {
        return fkColumn;
    }

    /**
     * @param fkColumn the fkColumn to set
     */
    public void setFkColumn(String fkColumn) {
        this.fkColumn = fkColumn;
    }

    /**
     * @return the pkTable
     */
    public String getPkTable() {
        return pkTable;
    }

    /**
     * @param pkTable the pkTable to set
     */
    public void setPkTable(String pkTable) {
        this.pkTable = pkTable;
    }

    /**
     * @return the pkColumn
     */
    public String getPkColumn() {
        return pkColumn;
    }

    /**
     * @param pkColumn the pkColumn to set
     */
    public void setPkColumn(String pkColumn) {
        this.pkColumn = pkColumn;
    }

    /**
     * @return the pkName
     */
    public String getPkName() {
        return pkName;
    }

    /**
     * @param pkName the pkName to set
     */
    public void setPkName(String pkName) {
        this.pkName = pkName;
    }
    
}
