/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.tools.db;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

/**
 *
 * @author Gunadi
 */
public class MetaDataBuilder extends DBHandler{
    
    public static Vector getAllTables() throws DBException, SQLException{
        
        Vector result = new Vector(1,1);
        
        DatabaseMetaData databaseMetaData = getConnection().getMetaData();
        ResultSet rs = databaseMetaData.getTables(null, null, "%", null);
        while(rs.next()){
            String tableName = rs.getString(3);
            result.add(tableName);
        }
        
        rs.close();
        getConnection().close();
        
        return result;
    }
    
    public static Vector getMetaDataColumns(String table) throws DBException, SQLException{
        
        Vector result = new Vector(1,1);
        
        DatabaseMetaData databaseMetaData = getConnection().getMetaData();
        ResultSet rs = databaseMetaData.getColumns(null, null, table, null);
        while(rs.next()){
            MetaData metaData = new MetaData();
            resultToObjectColumns(rs, metaData);
            result.add(metaData);
        }
        
        rs.close();
        getConnection().close();
        
        return result;
    }
    
    public static int getSingleColumnsDataType(String table, String column) throws DBException, SQLException{
        
        int DataType = 0;
        
        DatabaseMetaData databaseMetaData = getConnection().getMetaData();
        ResultSet rs = databaseMetaData.getColumns(null, null, table, column);
        while(rs.next()){
            DataType = rs.getInt("DATA_TYPE");
        }
        
        rs.close();
        getConnection().close();
        
        return DataType;
    }
        
    public static Vector getMetaDataPK(String table) throws DBException, SQLException{
        
        Vector result = new Vector(1,1);
        
        DatabaseMetaData databaseMetaData = getConnection().getMetaData();
        ResultSet rs = databaseMetaData.getPrimaryKeys(null, null, table);
        while(rs.next()){
            MetaData metaData = new MetaData();
            resultToObjectPK(rs, metaData);
            metaData.setDataType(getSingleColumnsDataType(table, metaData.getPk()));
            result.add(metaData);
        }
        
        rs.close();
        getConnection().close();
        
        return result;
    }
        
    public static Vector getMetaDataFK(String table) throws DBException, SQLException{
        
        Vector result = new Vector(1,1);
        
        DatabaseMetaData databaseMetaData = getConnection().getMetaData();
        ResultSet rs = databaseMetaData.getImportedKeys(null, null, table);
        while(rs.next()){
            MetaData metaData = new MetaData();
            resultToObjectFK(rs, metaData);
            metaData.setDataType(getSingleColumnsDataType(table, metaData.getFkColumn()));
            result.add(metaData);
        }
        
        rs.close();
        getConnection().close();
        
        return result;
    }
    
    public static Vector getColumnData(String table, String column){
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "+column+" FROM " + table;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                String data = rs.getString(1);
                lists.add(data);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    public static int countData(String tableName) {
        int data = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + tableName;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                data++;
            }
            rs.close();
            return data;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return 0;
    }
    
    
    public static void resultToObjectColumns(ResultSet rs, MetaData metaData) {
        try {
            metaData.setColName(rs.getString("COLUMN_NAME"));
            metaData.setDataType(rs.getInt("DATA_TYPE"));
            metaData.setColSize(rs.getInt("COLUMN_SIZE"));
            
        } catch (Exception e) {
        }
    }
    
    public static void resultToObjectPK(ResultSet rs, MetaData metaData) {
        try {
            metaData.setPk(rs.getString("COLUMN_NAME"));
            metaData.setPkName(rs.getString("PK_NAME"));
        } catch (Exception e) {
        }
    }
    
    public static void resultToObjectFK(ResultSet rs, MetaData metaData) {
        try {
            metaData.setFkTable(rs.getString("FKTABLE_NAME"));
            metaData.setFkColumn(rs.getString("FKCOLUMN_NAME"));
            metaData.setPkTable(rs.getString("PKTABLE_NAME"));
            metaData.setPkColumn(rs.getString("PKCOLUMN_NAME"));
        } catch (Exception e) {
        }
    }
    
}
