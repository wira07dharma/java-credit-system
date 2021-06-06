/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.session.excel;

import com.dimata.common.entity.excel.FlowMappingDataList;
import com.dimata.common.entity.excel.FlowModul;
import com.dimata.common.entity.excel.FlowModulMapping;
import com.dimata.common.entity.excel.PstFlowMappingDataList;
import com.dimata.common.entity.excel.PstFlowModul;
import com.dimata.common.entity.excel.PstFlowModulMapping;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.tools.db.MetaDataBuilder;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.hssf.usermodel.DVConstraint;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDataValidation;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.DataValidation;
import org.apache.poi.ss.usermodel.DataValidationConstraint;
import org.apache.poi.ss.usermodel.DataValidationHelper;
import org.apache.poi.ss.util.CellRangeAddressList;

/**
 *
 * @author Gunadi
 */
public class ExcelTemplate extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long oidFlow = FRMQueryString.requestLong(request, "oid_flow");
        int jumlahData = FRMQueryString.requestInt(request, "dataCount");
        
        FlowModul flow = new FlowModul();
        try{
            flow = PstFlowModul.fetchExc(oidFlow);
        } catch (Exception exc){}
        
        response.setContentType("application/x-msexcel");
        
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet(flow.getFlowModulName());
        DataValidationConstraint constraint = null;
        DataValidationHelper validationHelper = null;
        HSSFRow row = sheet.createRow((short) 0);
        HSSFCell cell = row.createCell((short) 0);
        String whereClause = PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_ID]+"="+oidFlow;
        String order = PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_COLUMN_LEVEL];
        Vector listFlowMap = PstFlowModulMapping.list(0, 0, whereClause, order);
        if (listFlowMap.size()>0){
            for (int i=0; i<listFlowMap.size();i++){
                FlowModulMapping flowMap = (FlowModulMapping) listFlowMap.get(i);
                cell = row.createCell((short) i);
                cell.setCellValue(flowMap.getColumnName());
            }
            
            for (int n=0; n < jumlahData; n++){
                row = sheet.createRow((short) ((short) n+1));
                for (int x=0; x<listFlowMap.size();x++){
                    FlowModulMapping flowMap = (FlowModulMapping) listFlowMap.get(x);
                    
                    cell = row.createCell((short) x);
                    if (flowMap.getColumnName().equals("No")){
                        cell.setCellValue(n+1);
                    } else {
                        switch(flowMap.getInputType()){
                            case PstFlowModulMapping.INPUT_TYPE_TEXT:
                                    cell.setCellValue("");
                                    break;
                            case PstFlowModulMapping.INPUT_TYPE_DATALIST_SELECTION:
                                    String whereData = PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_FLOW_MAPPING_ID]+"="+flowMap.getOID();
                                    String orderData = PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_DATA_VALUE];
                                    Vector listData = PstFlowMappingDataList.list(0, 0, whereData, orderData);
                                    if (listData.size()>0){
                                        String[] data = new String[listData.size()];
                                        for (int m=0; m < listData.size();m++){
                                            FlowMappingDataList dataList = (FlowMappingDataList) listData.get(m);
                                            data[m] = dataList.getDataCaption();
                                        }
                                        CellRangeAddressList addressList = new CellRangeAddressList(n+1, n+1, x, x);
                                        DVConstraint dvConstraint = DVConstraint.createExplicitListConstraint(data);
                                        DataValidation dataValidation = new HSSFDataValidation(addressList, dvConstraint);
                                        dataValidation.setSuppressDropDownArrow(false);
                                        //sheet.addValidationData(dataValidation);
                                    }

                                    break;
                            case PstFlowModulMapping.INPUT_TYPE_TABLECOLUMN_SELECTION:
                                    listData = MetaDataBuilder.getColumnData(flowMap.getDataTable(), flowMap.getDataColumn());
                                    if (listData.size()>0){
                                        String[] data = new String[listData.size()];
                                        for (int m=0; m < listData.size();m++){
                                            String dataList = (String) listData.get(m);
                                            data[m] = dataList;
                                        }
                                        CellRangeAddressList addressList = new CellRangeAddressList(n+1, n+1, x, x);
                                        DVConstraint dvConstraint = DVConstraint.createExplicitListConstraint(data);
                                        DataValidation dataValidation = new HSSFDataValidation(addressList, dvConstraint);
                                        dataValidation.setSuppressDropDownArrow(false);
                                        //sheet.addValidationData(dataValidation);
                                    }
                                break;
                        }
                    }
                    
                }
            }
            
            for (int i=0; i<listFlowMap.size();i++){
                //sheet.autoSizeColumn(i);
            }
            
            
        }
        
        
        // Write the output to a file
        //FileOutputStream fileOut = new FileOutputStream("workbook.xls");
        //wb.write(fileOut);
        //fileOut.close();        
        ServletOutputStream sos = response.getOutputStream();
        wb.write(sos);
        sos.close();
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
