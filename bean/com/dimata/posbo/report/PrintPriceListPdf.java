/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.report;

import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.posbo.entity.masterdata.Category;
import com.dimata.posbo.entity.masterdata.PstCategory;
import com.dimata.posbo.entity.masterdata.PstHelperPriceList;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.sedana.entity.masterdata.JangkaWaktu;
import com.dimata.sedana.entity.masterdata.JangkaWaktuFormula;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktu;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktuFormula;
import com.dimata.services.WebServices;
import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author gndiw
 */
public class PrintPriceListPdf extends HttpServlet {

    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    
    // destroy the servlet
    public void destroy(){
    }
    
    // setting the color values
    public static Color border = new Color(0x00, 0x00, 0x00);
    public static Color bgColor = new Color(220, 220, 220);
    // setting font for user choosen
    public static Font fontTitle = new Font(Font.TIMES_NEW_ROMAN, 14, Font.BOLD, border);
    public static Font fontMainHeader = new Font(Font.TIMES_NEW_ROMAN, 12, Font.BOLD, border);
    public static Font fontHeader = new Font(Font.TIMES_NEW_ROMAN, 12, Font.ITALIC, border);
    public static Font fontListHeader = new Font(Font.TIMES_NEW_ROMAN, 10, Font.BOLD, border);
    public static Font fontListContent = new Font(Font.TIMES_NEW_ROMAN, 10);
    
    // string head 
    public static final String textPriceListHeader[] = {
        "NO", "SKU", "NAMA & JENIS PRODUK", "MERK", "HARGA", "18x Angs.", "15x Angs.", "12x Angs.", "6x Angs.", "PRICE LIST PRODUCT"
    };
    
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Color bgColor = new Color(200, 200, 200);
        Rectangle rectangle = new Rectangle(20, 20, 20, 20);
        rectangle.rotate();
        Document document = new Document(PageSize.A4, 20, 20, 30, 30);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        
        try{
            
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            
            // add an footer
            HeaderFooter footer = new HeaderFooter(new Phrase(new Chunk("", fontListContent)), false);
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setBorder(HeaderFooter.NO_BORDER);
            
            // open document
            document.open();
            
            // get data form session
            Vector list = new Vector();
            int countList = 0;
            int SESS_LANGUAGE = 0;
            HttpSession session = request.getSession(true);
            
            try{
                 list = PstCategory.list(0, 0, "", "");
            }catch(Exception e){
            
            }
            
            // get image url
            String pathImage = "http://" + request.getServerName() + ":" + request.getServerPort() +request.getContextPath()+ "/images/company_pdf.jpg";
            
            com.lowagie.text.Image gambar = null;
            try{
                gambar = Image.getInstance(pathImage);
            }catch(Exception e){
            
            }
            // Take data from pos Category
                document.add(getHeaderImage(gambar));
                document.add(getContent(list, document, writer));
        }catch(Exception e){
        
        }
        
        // close document
        document.close();
        
        // bring to pdf
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
        
    }
    
    
    // make image header
    private static Table getHeaderImage(Image gambar)throws BadElementException, DocumentException {
        Table table = new Table(1);

        try {
                int ctnInt[] = {100};
                table.setBorderColor(new Color(255, 255, 255));
                table.setWidth(100);
                table.setWidths(ctnInt);
                table.setSpacing(1);
                table.setPadding(0);
                table.setDefaultCellBorder(Table.NO_BORDER);

                createEmptySpace(table, 10);

                //image in header
                gambar.setAlignment(Image.MIDDLE);
                gambar.scaleAbsolute(100, 100);
                table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
                table.addCell(new Phrase(new Chunk(gambar, 0, 0)));

                //sub title
                table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
                table.addCell(new Phrase(PrintPriceListPdf.textPriceListHeader[9],fontTitle));

                createEmptySpace(table, 2);

        } catch (Exception e) {
        }
        return table;
    }
    
     private static void createEmptySpace(Table table, int space) throws BadElementException, DocumentException {
        for (int i = 0; i < space; i++) {
                table.setDefaultCellBorder(Table.NO_BORDER);
                table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
                table.addCell(new Phrase("", fontListContent));
        }

    }
     
     // make table header
    private static Table getHeader(String name) throws BadElementException, DocumentException{
        // int ctnInt
        int ctnInt[] = {100};
        Table table = new Table(1);
        table.setBorderColor(new Color(255, 255, 255));
        table.setWidth(100);
        table.setWidths(ctnInt);
//        table.setCellpadding(1);
//        table.setCellspacing(0);

        table.setDefaultCellBorder(table.NO_BORDER);
        table.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
        table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
        table.addCell(new Phrase(name, fontTitle));
        return table;
    }
    
    
    private static Table getListHeader() throws BadElementException, DocumentException {
        
        Vector listJangkaWaktu = PstJangkaWaktu.list(0, 0, "STATUS=0", PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU]);
        int ctnInt[] = {2, 4, 8, 6};
        
        for (int i = 0; i < listJangkaWaktu.size(); i++){
            ctnInt = addElement(ctnInt, 4);
        }
        Table table = new Table((4+listJangkaWaktu.size())); 
        try {
            table.setBorderColor(new Color(255, 255, 255));
            table.setWidth(100);
            table.setWidths(ctnInt);
            
            table.setBorderWidth(0);
//            table.setCellpadding(1);
//            table.setCellspacing(0);
            table.setDefaultRowspan(2);

            table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
            table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
            table.setDefaultCellBackgroundColor(bgColor);
            table.addCell(new Phrase(PrintPriceListPdf.textPriceListHeader[0], fontListHeader));

            table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
            table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
            table.setDefaultCellBackgroundColor(bgColor);
            table.addCell(new Phrase(PrintPriceListPdf.textPriceListHeader[1], fontListHeader));

            table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
            table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
            table.setDefaultCellBackgroundColor(bgColor);
            table.addCell(new Phrase(PrintPriceListPdf.textPriceListHeader[2], fontListHeader));

            table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
            table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
            table.setDefaultCellBackgroundColor(bgColor);           
            table.addCell(new Phrase(PrintPriceListPdf.textPriceListHeader[3], fontListHeader));
            
            table.setDefaultRowspan(1);
            table.setDefaultColspan(listJangkaWaktu.size());
            table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
            table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
            table.setDefaultCellBackgroundColor(bgColor);
            table.addCell(new Phrase(PrintPriceListPdf.textPriceListHeader[4], fontListHeader));
            
            for (int i = 0; i < listJangkaWaktu.size(); i++){
                JangkaWaktu jw = (JangkaWaktu) listJangkaWaktu.get(i);
                table.setDefaultColspan(1);
                table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
                table.setDefaultCellBackgroundColor(bgColor);
                table.addCell(new Phrase(jw.getJangkaWaktu()+"x", fontListHeader));
            }


        } catch (Exception e) {
            System.out.println("exc header" + e.toString());
        }

        return table;
    }
    
    static int[] addElement(int[] a, int e) {
        a  = Arrays.copyOf(a, a.length + 1);
        a[a.length - 1] = e;
        return a;
    }
    
    private static Table getListFooter(Table table, Vector footer) throws BadElementException, DocumentException {
        try {
            
        } catch (Exception e) {
            System.out.println("exc footer" + e.toString());
        }

        return table;
    }
    
    private static Table getContent(Vector vct, Document document, PdfWriter writer) throws BadElementException, DocumentException {
      
           Vector body = vct;
           String hello  = "";
           Table table = new Table(1);
           
           Vector listJangkaWaktu = PstJangkaWaktu.list(0, 0, "STATUS=0", PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU]);
           
           try{
               for(int i = 0; i < body.size(); i++ ){
                   Category category = (Category) body.get(i);
               
               long categoryOid = category.getOID();
               String categoryName = category.getName();
               
               if(categoryOid > 0){
                
                Hashtable<String, Double> listHash = PstHelperPriceList.listHash(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_CATEGORY_ID]+"="+categoryOid);
                
                String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
                String url = posApiUrl + "/material/list/simple?limitStart=0&recordToGet=0&whereClause="+URLEncoder.encode("CATEGORY_ID="+category.getOID()+" AND VIEW_IN_SHOPPING_CHART = 1")+"&orderBy=M.NAME";
                   JSONArray arr = WebServices.getAPIArray("", url);
                   
                   if (arr != null){
                       document.add(getHeader(categoryName));
                                table = getListHeader();
                       for (int x = 0; x < arr.length(); x++){
                                
                                JSONObject objects = arr.getJSONObject(x);
                                 // get the price average
                                 double avgPrice = objects.optDouble(PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE],0);
                                 String merkName = objects.optString("MERK","-");

                                 table.setDefaultCellBackgroundColor(Color.WHITE);
                                 table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                                 table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
                                 table.addCell(new Phrase(String.valueOf(x + 1), fontListContent));
                                 
                                 table.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                                 table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
                                 table.addCell(new Phrase(objects.optString(PstMaterial.fieldNames[PstMaterial.FLD_SKU],"-"), fontListContent));

                                 table.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                                 table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
                                 table.addCell(new Phrase(objects.optString(PstMaterial.fieldNames[PstMaterial.FLD_NAME],"-"), fontListContent));

                                 table.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                                 table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
                                 table.addCell(new Phrase(merkName, fontListContent));
                                 
                                 for (int j = 0; j < listJangkaWaktu.size(); j++){
                                    JangkaWaktu jw = (JangkaWaktu) listJangkaWaktu.get(j);
                                    String key = objects.optLong(PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID],0)+"_"+jw.getOID();
                                    double value = 0;
                                    try {
                                        value = listHash.get(key);
                                    } catch (Exception exc){}
                                    
                                    table.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                                 table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
                                 table.addCell(new Phrase("Rp. "+String.format("%,.0f", value), fontListContent));
                                    
                                 }
                                 
                                
                                  if(!writer.fitsPage(table)){
                                      /** hapus baris kosong */
                                     table.deleteLastRow();
                                     table.deleteLastRow();
                                     table.deleteLastRow();
                                     table.deleteLastRow();

                                     // add footer
                                     document.add(getListFooter(table, body));

                                     // add new page
                                     document.newPage();
                                     table = getListHeader();
                                 }

                       }
                   }
                   
                     
               }
               if(i == 0){
                   
               document.add(table);
               }
           }
           //document.add(createEmptySpace(table, 0));
           }catch(Exception e){
           
           }
        return table;
      
    }

    public static int checkString(String strObject, String toCheck) {
        if (toCheck == null || strObject == null) {
            return -1;
        }
        if (strObject.startsWith("=")) {
            strObject = strObject.substring(1);
        }

        String[] parts = strObject.split(" ");
        if (parts.length > 0) {
            for (int i = 0; i < parts.length; i++) {
                String p = parts[i];
                if (toCheck.trim().equalsIgnoreCase(p.trim())) {
                    return i;
                };
            }
        }
        return -1;
    }

    public static String checkStringStart(String strObject, String toCheck) {
        if (toCheck == null || strObject == null) {
            return null;
        }
        if (strObject.startsWith("=")) {
            strObject = strObject.substring(1);
        }

        String[] parts = strObject.split(" ");
        if (parts.length > 0) {
            for (int i = 0; i < parts.length; i++) {
                String p = parts[i];
                if (p.trim().startsWith(toCheck.trim())) {
                    return p.trim();
                };
            }
        }
        return null;
    }
    
     public static double getValue(String formula) {
        DBResultSet dbrs = null;
        double compValueX = 0;
        try {
            String sql = "SELECT (" + formula + ")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                compValueX = rs.getDouble(1);
            }

            rs.close();
            return compValueX;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

     public static double getComponentValue(String compName, String formulaPart, double increase, double hpp, double dp) {
        double retValue = 0.0;

        Vector vLsitComp = null;
        if (compName == null || formulaPart == null) {
            return 0;
        }
        compName = compName.trim();
        formulaPart = formulaPart.trim();
        if (formulaPart.startsWith(compName)) {
            String[] parts = formulaPart.split("#");
            if (parts.length > 0) {
                vLsitComp = new Vector();
                for (int i = 1; i < parts.length; i++) {
                    vLsitComp.add(parts[i]);
                }
            }
        }

        Vector vJangkaWaktu = PstJangkaWaktu.list(0, 0, PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU] + "='" + vLsitComp.get(0) + "'", "");
        if (vJangkaWaktu.size() > 0) {
            JangkaWaktu jangkaWaktu = (JangkaWaktu) vJangkaWaktu.get(0);

            Vector listFormula = PstJangkaWaktuFormula.list(0, 0,
                    PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID] + "=" + jangkaWaktu.getOID(),
                    PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);

            Hashtable<String, Double> hashFormula = new Hashtable<>();
            double value = 0;
            if (listFormula.size() > 0) {
                for (int i = 0; i < listFormula.size(); i++) {
                    JangkaWaktuFormula jangkaWaktuFormula = (JangkaWaktuFormula) listFormula.get(i);
                    String formula = jangkaWaktuFormula.getFormula().replaceAll("%", "/100");
                    formula = formula.replaceAll("&gt", ">");
                    formula = formula.replaceAll("&lt", "<");
                    if (checkString(formula, "HPP") > -1) {
                        formula = formula.replaceAll("HPP", "" + hpp);
                    }
                    if (checkString(formula, "DP") > -1) {
                        formula = formula.replaceAll("DP", "" + dp);
                    }
                    if (checkString(formula, "INCREASE") > -1) {
                        formula = formula.replaceAll("INCREASE", increase + " / 100.0");
                    }

                    for (Map.Entry m : hashFormula.entrySet()) {
                        formula = formula.replaceAll("" + m.getKey(), "" + m.getValue());
                    }

                    String sComp = checkStringStart(formula, "JANGKA_WAKTU");
                    if (sComp != null && sComp.length() > 0) {
                        double compVal = getComponentValue("JANGKA_WAKTU", sComp, increase, hpp, dp);
                        formula = formula.replaceAll("" + sComp, "" + compVal);
                    }

                    value = getValue(formula);

                    switch (jangkaWaktuFormula.getPembulatan()) {
                        case PstJangkaWaktuFormula.PEMBULATAN_PULUHAN:
                            value = rounding(-1, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RATUSAN:
                            value = rounding(-2, value);
                            break;
                        case PstJangkaWaktuFormula.PEMBULATAN_RIBUAN:
                            value = rounding(-3, value);
                            break;
                    }

                    hashFormula.put(jangkaWaktuFormula.getCode(), value);
                    if (String.valueOf(vLsitComp.get(1)).equals(jangkaWaktuFormula.getCode())) {
                        retValue = value;
                        break;
                    }

                }
            }
        }

        return retValue;
    }
     
    public int convertInteger(int scale, double val) {
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(scale, RoundingMode.UP);
        return bDecimal.intValue();
    }

    public static double rounding(int scale, double val) {
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(scale, RoundingMode.UP);
        return bDecimal.doubleValue();
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
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
     * Handles the HTTP <code>POST</code> method.
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
