/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.tools.db;

import com.dimata.common.entity.excel.FlowModul;
import com.dimata.common.entity.excel.FlowModulMapping;
import com.dimata.common.entity.excel.PstFlowMappingDataList;
import com.dimata.common.entity.excel.PstFlowModul;
import com.dimata.common.entity.excel.PstFlowModulMapping;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.OIDFactory;
import com.dimata.util.blob.TextLoader;
import java.io.ByteArrayInputStream;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

/**
 *
 * @author Gunadi
 */
public class Excel2DB extends DBHandler{
    
    private static OIDFactory oidFactory = new OIDFactory();
    
    public static String drawImport(ServletConfig config, HttpServletRequest request, HttpServletResponse response, JspWriter output, long oidFlow) throws DBException, SQLException{
        String html="";
        try {
            /* inisialiasi tabel */
            
            String tdColor = "#FFF;";
            
            FlowModul flowModul = new FlowModul();
            try {
                flowModul = PstFlowModul.fetchExc(oidFlow);
            } catch (Exception exc){}
            
            String table = flowModul.getFlowModulTable();
            Connection conn = getConnection(); 
            String sql = null;
            PreparedStatement stmt = null;

            sql = "SELECT * from " + table;
            stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            ResultSetMetaData metaData = rs.getMetaData();
            String whereCol = PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_ID]+"="+oidFlow;
            Vector listColoumn = PstFlowModulMapping.list(0, 0, whereCol, PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_COLUMN_LEVEL]);
            int colCount = listColoumn.size();

            String q = "";
            for (int c = 0; c < colCount; c++) {
                if(q.equalsIgnoreCase("")){
                    q = "?";
                }
                else{
                    q = q + ",?";
                }
            }
            
            String field = "";
            if (listColoumn.size()>0){
                for (int i=0; i < listColoumn.size();i++){
                    FlowModulMapping flowModulMap = (FlowModulMapping) listColoumn.get(i);
                    if (field.equalsIgnoreCase("")){
                        field = flowModulMap.getFieldName();
                    } else {
                        field = field + "," +flowModulMap.getFieldName();
                    }
                }
            }

            sql = "INSERT into " +
            table + "( "+field+" )"+ " VALUES(" + q + ")";
            stmt = conn.prepareStatement(sql);
            /*end*/
            
            boolean insertData = true;
            
            TextLoader uploader = new TextLoader();
            ByteArrayInputStream inStream = null;

            uploader.uploadText(config, request, response);
            Object obj = uploader.getTextFile("FRM_DOC");
            byte byteText[] = null;
            byteText = (byte[]) obj;
            inStream = new ByteArrayInputStream(byteText);

            POIFSFileSystem fs = new POIFSFileSystem(inStream);
            
            HSSFWorkbook workbook = new HSSFWorkbook(fs);
            HSSFSheet sheet = workbook.getSheetAt(0);
            
            int rows = sheet.getPhysicalNumberOfRows();
            int count = 0;
            html += "<table class=\"table table-bordered table-striped\">";
            for (int r = 0; r < rows; r++) {
                HSSFRow row = sheet.getRow(r);
                if (row == null) {
                    continue;
                }
                // Skip Header Row
                if (r == 0) {
                    html += "<thead><tr class=\"label-success\">";
                } else {
                    html += "<tr>";
                }
                insertData = true;
                String strValue = "";
                int cells = row.getPhysicalNumberOfCells();
                for (int c = 0; c < listColoumn.size(); c++) {
                    FlowModulMapping flowModulMap = (FlowModulMapping) listColoumn.get(c);
                    HSSFCell cell = row.getCell((short) c);
                    String value = null,printValue = null;
                    
                    if (r == 0) {
                        value = cell.getStringCellValue();
                        insertData = false;
                        html += "<td>"+ value + "</td>";
                    } else {
                        
                        if (cell == null){
                            value = "";
                            strValue = "";
                        } else {
                            switch (cell.getCellType()) {

                                case HSSFCell.CELL_TYPE_FORMULA:
                                    //value = cell.getCellFormula();
                                    strValue = value;
                                    break;

                                case HSSFCell.CELL_TYPE_NUMERIC:
                                    value = String.valueOf(cell.getNumericCellValue());
                                    strValue = value;
                                    break;

                                case HSSFCell.CELL_TYPE_STRING:
                                    value = cell.getStringCellValue();
                                    strValue = value;
                                    break;

                                case HSSFCell.CELL_TYPE_BLANK:
                                    value = cell.getStringCellValue();
                                    strValue = value;
                                    break;

                                default:
                            }
                        }

                        if (c==0){
                            value = String.valueOf(oidFactory.generateOID());
                         }
                        
                        if (flowModulMap.getInputType() == PstFlowModulMapping.INPUT_TYPE_DATALIST_SELECTION){
                            value = PstFlowMappingDataList.getCustomDataListValue(value, flowModulMap.getOID());
                        } else if (flowModulMap.getInputType() == PstFlowModulMapping.INPUT_TYPE_TABLECOLUMN_SELECTION){
                            value = PstFlowModulMapping.getDataListValue(flowModulMap.getDataTable(),
                                    flowModulMap.getDataColumn(), flowModulMap.getDataValue(), value);
                        }


                        // If no data was provided, do not insert
                        if(value.equalsIgnoreCase("") || value == null){
                            insertData = false;
                            html += "<td style=\"background-color:#d9534f ;\">"+ strValue + "</td>";
                            break;
                        } else {
                            html += "<td>"+ strValue + "</td>";
                        }

//                        switch (metaData.getColumnType(cell.getColumnIndex()+1)) {
//                            case java.sql.Types.BIGINT:
//                                stmt.setLong(cell.getColumnIndex()+1,Long.valueOf(value));
//                                break;
//
//                            case java.sql.Types.VARCHAR:
//                                stmt.setString(cell.getColumnIndex()+1,value);
//                                break;
//
//                            case java.sql.Types.LONGVARCHAR:
//                                stmt.setString(cell.getColumnIndex()+1,value);
//                                break;
//
//                            case java.sql.Types.INTEGER:
//                                if(metaData.getScale(cell.getColumnIndex()+1) == 0){
//                                    stmt.setInt(cell.getColumnIndex()+1,Integer.parseInt(value));
//                                }
//                                else {
//                                    stmt.setDouble(cell.getColumnIndex()+1,Double.parseDouble(value));
//                                }
//                                break;
//
//                            case java.sql.Types.DOUBLE:
//                                if(metaData.getScale(cell.getColumnIndex()+1) == 0){
//                                    stmt.setInt(cell.getColumnIndex()+1,Integer.parseInt(value));
//                                }
//                                else {
//                                    stmt.setDouble(cell.getColumnIndex()+1,Double.parseDouble(value));
//                                }
//                                break;
//
//                            default:
//                        }
                    }
                }
                if (r == 0) {
                    html += "</tr></thead><tbody>";
                } else {
                    html += "</tr>";
                }
                if(insertData){
                    try {
                        stmt.executeUpdate();
                        count++;
                    } catch (Exception exc){
                        
                    }
                }
            }
            html += "</tbody></table><strong>"+count+" Data berhasil di import</strong>";
            rs.close();
            stmt.close();
            getConnection().close();
        } catch (Exception exc){
            
        }
        
        
        return html;
    }
}
