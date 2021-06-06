/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.print.report;

import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstAngsuran;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.print.component.PrintUtility;
import com.dimata.sedana.session.SessReportKredit;
import com.dimata.util.Formater;
import com.lowagie.text.BadElementException;
import com.lowagie.text.Cell;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.HeaderFooter;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.NumberFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author arise
 */
public class PrintPencapaianTagihan extends HttpServlet {

    public int SESS_LANGUAGE = 0;
    public long locationId = 0;
    public boolean sessLogin = false;

    public String approot = "";
    public String startDate = "";
    public String endDate = "";
    public String dataFor = "";
    public String title = "";

    public static String defFormatCurr = "###,###";

    public static String compName = PstSystemProperty.getValueByName("COMPANY_NAME");
    public static String subTitle = "ELEKTRONIK, MESIN, FURNITURE";

    public static String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");

    public static final String textHeaderTable[][] = {
        {"No.", "Tanggal", "Estimasi Tagihan", "Realisasi Tagihan", "Sisa", "Qty", "Jumlah", "%", "Koml (%)"},
        {"No.", "Date", "Estimated Bill", "Bill Realization", "Rest", "Qty", "Amount", "%", "Koml (%)"}
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
        response.setContentType("text/html;charset=UTF-8");
        Color bgColor = new Color(200, 200, 200);
        com.lowagie.text.Rectangle rectangle = new com.lowagie.text.Rectangle(20, 20, 20, 20);
        rectangle.rotate();
        Document document = new Document();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            //Rectangle r = new Rectangle(597.6f, 439.2f);
            document.setPageSize(PageSize.A4);
            document.setMargins(20, 20, 30, 30);

            //step2.2: creating an instance of the writer
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            HeaderFooter header = new HeaderFooter(new Phrase(new Chunk("", PrintUtility.fontLsContent)), false);
            HeaderFooter footer = new HeaderFooter(new Phrase(new Chunk("", PrintUtility.fontLsContent)), false);
            footer.setBorder(HeaderFooter.NO_BORDER);
            header.setBorder(HeaderFooter.NO_BORDER);
            document.setHeader(header);
            document.setFooter(footer);

            document.open();

            this.SESS_LANGUAGE = FRMQueryString.requestInt(request, "SESS_LANGUAGE");
            this.approot = FRMQueryString.requestString(request, "approot");
            this.locationId = FRMQueryString.requestLong(request, "LOCATION_OID");

            this.startDate = request.getParameter("startDate");
            this.endDate = request.getParameter("endDate");
            this.dataFor = request.getParameter("dataFor");

            Date cvtStartDate = null;
            Date cvtEndDate = null;
            String[] oidKol = request.getParameterValues("KOLEKTOR_OID");
            String[] oidLoc = request.getParameterValues("LOCATION_ID");
            String whereClause = "";

            Vector listReport = new Vector(1, 1);
            Vector kolektorList = new Vector(1, 1);

            if (oidKol != null && oidKol.length > 0) {
                whereClause += "(";
                for (int i = 0; i < oidKol.length; i++) {
                    long kolektorOid = Long.parseLong(String.valueOf(oidKol[i]));
                    if (i > 0) {
                        whereClause += " OR ";
                    }
                    whereClause += PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " LIKE '%" + kolektorOid + "%' ";
                }
                whereClause += ") ";
            }
            kolektorList = PstEmployee.getListFromApi(0, 0, whereClause, "");

            Location loc = new Location();

            String pathImage = "http://" + request.getServerName() + ":" + request.getServerPort() + approot + "/images/company.jpg";
            System.out.println("approot = " + pathImage);
            com.lowagie.text.Image gambar = null;

            try {
                gambar = com.lowagie.text.Image.getInstance(pathImage);
            } catch (Exception ex) {
                System.out.println("gambar >>>>>> = " + gambar.getImageMask());
            }

            if (locationId != 0) {
                loc = PstLocation.fetchFromApi(locationId);
            }

            whereClause = " SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] 
            + " IN (" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ")";
            if (oidLoc != null && oidLoc.length > 0) {
                whereClause += " AND (";
                for (int j = 0; j < oidLoc.length; j++) {
                    long locOid = Long.parseLong(String.valueOf(oidLoc[j]));
                    if (j > 0) {
                        whereClause += " OR ";
                    }
                    whereClause += " CBM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " LIKE '%" + locOid + "%' ";
                }
                whereClause += ") ";
            }
            if ((startDate != null && startDate.length() > 0) && (endDate != null && endDate.length() > 0)) {
                cvtStartDate = Formater.formatDate(startDate, "yyyy-MM-dd");
                cvtEndDate = Formater.formatDate(endDate, "yyyy-MM-dd");
                whereClause += " AND ("
                        + " (TO_DAYS(SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")"
                        + " >= TO_DAYS('" + Formater.formatDate(cvtStartDate, "yyyy-MM-dd") + "'))"
                        + " AND (TO_DAYS(SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")"
                        + " <= TO_DAYS('" + Formater.formatDate(cvtEndDate, "yyyy-MM-dd") + "')))";
            }
            whereClause += " AND AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_CAIR;

            document.add(PrintUtility.getHeaderImage(SESS_LANGUAGE, gambar, loc));
            document = getContent(document, writer, SESS_LANGUAGE, cvtStartDate, cvtEndDate, kolektorList, listReport, dataFor, whereClause);
        } catch (Exception e) {
            PrintUtility.printErrorMessage(e.getMessage());
        }

        document.close();
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream sos = response.getOutputStream();
        baos.writeTo(sos);
        sos.flush();
    }

    private static Document getContent(Document document, PdfWriter writer, int SESS_LANGUAGE, Date startDate, Date endDate, Vector kolektorList, Vector listReport,
            String dataFor, String whereClause)
            throws BadElementException, DocumentException {

        Locale locale = new Locale("id", "ID");
        NumberFormat numberFormat = NumberFormat.getInstance(locale);
        Cell cell;

        int subAtasLebar[] = {100};
        Table subAtas = PrintUtility.createTable(subAtasLebar.length, subAtasLebar);
        subAtas.setDefaultCellBorder(Table.NO_BORDER);

        String periode = "Periode";
        if (startDate != null && endDate != null) {
            periode += " " + Formater.formatDate(startDate, "dd MMMM yyyy") + " - " + Formater.formatDate(endDate, "dd MMMM yyyy");
        } else {
            periode += " Semua.";
        }

        String title = "Daftar Pencapaian";
        if (dataFor.equals("perTanggal")) {
            title += " per Tanggal";
        } else if (dataFor.equals("perKolektor")) {
            title += " per Kolektor";
        }

        subAtas.addCell(new Phrase(title.toUpperCase(), PrintUtility.fontSection));
        cell = new Cell(new Phrase(periode, PrintUtility.fontSectionContentBold));
        subAtas.addCell(cell);

        int bagianAtasLebar[] = {5, 15, 5, 10, 5, 10, 5, 8, 5, 10};
        Table bagianAtas = PrintUtility.createTable(bagianAtasLebar.length, bagianAtasLebar);
        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
        bagianAtas.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
        bagianAtas.setCellsFitPage(true);

        bagianAtas.setDefaultCellBackgroundColor(new Color(223, 230, 233));
        cell = new Cell(new Phrase(textHeaderTable[SESS_LANGUAGE][0], PrintUtility.fontSectionContentBold));
        cell.setRowspan(2);
        bagianAtas.addCell(cell);
        cell = new Cell(new Phrase(textHeaderTable[SESS_LANGUAGE][1], PrintUtility.fontSectionContentBold));
        cell.setRowspan(2);
        bagianAtas.addCell(cell);
        cell = new Cell(new Phrase(textHeaderTable[SESS_LANGUAGE][2], PrintUtility.fontSectionContentBold));
        cell.setColspan(2);
        bagianAtas.addCell(cell);
        cell = new Cell(new Phrase(textHeaderTable[SESS_LANGUAGE][3], PrintUtility.fontSectionContentBold));
        cell.setColspan(4);
        bagianAtas.addCell(cell);
        cell = new Cell(new Phrase(textHeaderTable[SESS_LANGUAGE][4], PrintUtility.fontSectionContentBold));
        cell.setColspan(2);
        bagianAtas.addCell(cell);
        bagianAtas.addCell(new Phrase(textHeaderTable[SESS_LANGUAGE][5], PrintUtility.fontSectionContentBold));
        bagianAtas.addCell(new Phrase(textHeaderTable[SESS_LANGUAGE][6], PrintUtility.fontSectionContentBold));
        bagianAtas.addCell(new Phrase(textHeaderTable[SESS_LANGUAGE][5], PrintUtility.fontSectionContentBold));
        bagianAtas.addCell(new Phrase(textHeaderTable[SESS_LANGUAGE][6], PrintUtility.fontSectionContentBold));
        bagianAtas.addCell(new Phrase(textHeaderTable[SESS_LANGUAGE][7], PrintUtility.fontSectionContentBold));
        bagianAtas.addCell(new Phrase(textHeaderTable[SESS_LANGUAGE][8], PrintUtility.fontSectionContentBold));
        bagianAtas.addCell(new Phrase(textHeaderTable[SESS_LANGUAGE][5], PrintUtility.fontSectionContentBold));
        bagianAtas.addCell(new Phrase(textHeaderTable[SESS_LANGUAGE][6], PrintUtility.fontSectionContentBold));

        try {
            bagianAtas.setDefaultCellBackgroundColor(Color.WHITE);
            if (dataFor.equals("perKolektor")) {
                boolean isFound = false;
                if (!kolektorList.isEmpty()) {
                    boolean isShown = false;
                    int grandQtyEst = 0;
                    double grandTotalEst = 0;
                    int grandQtyReal = 0;
                    double grandTotalReal = 0;
                    int grandQtySisa = 0;
                    double grandTotalSisa = 0;

                    for (int i = 0; i < kolektorList.size(); i++) {
                        Employee emp = (Employee) kolektorList.get(i);
                        Location kolLoc = new Location();
                        try {
                            kolLoc = PstLocation.fetchFromApi(emp.getLocationId());
                        } catch (Exception e) {
                        }
                        long oid = emp.getOID();
                        Vector tempList = new Vector(1, 1);
                        Vector listRealisasi = new Vector(1, 1);

                        String tempWhereClause = whereClause;
                        tempWhereClause += " AND AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + oid;
                        tempList = SessReportKredit.listDaftarPencapaianEstimasi(tempWhereClause);

                        if (!tempList.isEmpty()) {
                            isFound = true;
                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                            String tmpTxt = "Kolektor: " + emp.getFullName() + ", Lokasi: " + kolLoc.getName();
                            cell = new Cell(new Phrase(tmpTxt, PrintUtility.fontSectionContentBold));
                            cell.setColspan(bagianAtasLebar.length);
                            bagianAtas.addCell(cell);

                            int subQtyEst = 0;
                            double subTotalEst = 0;
                            int subQtyReal = 0;
                            double subTotalReal = 0;
                            int subQtySisa = 0;
                            double subTotalSisa = 0;

                            for (int j = 0; j < tempList.size(); j++) {
                                Vector tempObj = (Vector) tempList.get(j);
                                String dateStr = String.valueOf(tempObj.get(0));
                                Date dateCvt = Formater.formatDate(dateStr, "yyyy-MM-dd");
                                int qtyEst = Integer.parseInt(String.valueOf(tempObj.get(1)));
                                subQtyEst += qtyEst;
                                double totalEst = Double.parseDouble(String.valueOf(tempObj.get(2)));
                                subTotalEst += totalEst;

                                bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                                bagianAtas.addCell(new Phrase(String.valueOf(j + 1), PrintUtility.fontSectionContent));
                                bagianAtas.addCell(new Phrase(Formater.formatDate(dateCvt, "dd MMMM yyyy"), PrintUtility.fontSectionContent));
                                bagianAtas.addCell(new Phrase(String.valueOf(qtyEst), PrintUtility.fontSectionContent));
                                bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                                bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(totalEst), PrintUtility.fontSectionContent));
                                bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);

                                listRealisasi = SessReportKredit.listDaftarPencapaianRealisasi(oid, dateCvt);

                                int qtyReal = 0;
                                double totalReal = 0;
                                if (!listRealisasi.isEmpty()) {
                                    qtyReal = Integer.parseInt(String.valueOf(listRealisasi.get(0)));
                                    subQtyReal += qtyReal;
                                    totalReal = Double.parseDouble(String.valueOf(listRealisasi.get(1)));
                                    subTotalReal += totalReal;

                                    bagianAtas.addCell(new Phrase(String.valueOf(qtyEst), PrintUtility.fontSectionContent));
                                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                                    bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(totalReal), PrintUtility.fontSectionContent));
                                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                                    bagianAtas.addCell(new Phrase(Formater.formatNumber(((totalReal / totalEst) * 100), "##.##") + "%", PrintUtility.fontSectionContent));
                                    bagianAtas.addCell(new Phrase(Formater.formatNumber(((subTotalReal / subTotalEst) * 100), "##.##") + "%", PrintUtility.fontSectionContent));
                                }
                                double sisaTotal = totalEst - totalReal;
                                int sisaQty = qtyEst - qtyReal;
                                subQtySisa += sisaQty;
                                subTotalSisa += sisaTotal;
                                bagianAtas.addCell(new Phrase(String.valueOf(sisaQty), PrintUtility.fontSectionContent));
                                bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                                bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(sisaTotal), PrintUtility.fontSectionContent));
                            }

                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_RIGHT);
                            cell = new Cell(new Phrase("Sub Total", PrintUtility.fontSectionContentBold));
                            cell.setColspan(2);
                            bagianAtas.addCell(cell);
                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                            bagianAtas.addCell(new Phrase(String.valueOf(subQtyEst), PrintUtility.fontSectionContent));
                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                            bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(subTotalEst), PrintUtility.fontSectionContent));
                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                            bagianAtas.addCell(new Phrase(String.valueOf(subQtyReal), PrintUtility.fontSectionContent));
                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                            bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(subTotalReal), PrintUtility.fontSectionContent));
                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                            bagianAtas.addCell(new Phrase(Formater.formatNumber(((subTotalReal / subTotalEst) * 100), "##.##") + "%", PrintUtility.fontSectionContent));
                            bagianAtas.addCell(new Phrase("", PrintUtility.fontSectionContent));
                            bagianAtas.addCell(new Phrase(String.valueOf(subQtySisa), PrintUtility.fontSectionContent));
                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                            bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(subTotalSisa), PrintUtility.fontSectionContent));

                            grandQtyEst += subQtyEst;
                            grandQtyReal += subQtyReal;
                            grandQtySisa += subQtySisa;
                            grandTotalEst += subTotalEst;
                            grandTotalReal += subTotalReal;
                            grandTotalSisa += subTotalSisa;

                            isShown = true;
                        } else {
                            isFound = false;
                        }
                    }
                    if (isShown) {
                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_RIGHT);
                        cell = new Cell(new Phrase("Sub Total", PrintUtility.fontSectionContentBold));
                        cell.setColspan(2);
                        bagianAtas.addCell(cell);
                        bagianAtas.addCell(new Phrase(String.valueOf(grandQtyEst), PrintUtility.fontSectionContentBold));
                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                        bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(grandTotalEst), PrintUtility.fontSectionContentBold));
                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                        bagianAtas.addCell(new Phrase(String.valueOf(grandQtyReal), PrintUtility.fontSectionContentBold));
                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                        bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(grandTotalReal), PrintUtility.fontSectionContentBold));
                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                        bagianAtas.addCell(new Phrase(Formater.formatNumber(((grandTotalReal / grandTotalEst) * 100), "##.##") + "%", PrintUtility.fontSectionContentBold));
                        bagianAtas.addCell(new Phrase("", PrintUtility.fontSectionContentBold));
                        bagianAtas.addCell(new Phrase(String.valueOf(grandQtySisa), PrintUtility.fontSectionContentBold));
                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                        bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(grandTotalSisa), PrintUtility.fontSectionContentBold));
                    }
                }
                if (!isFound) {
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                    cell = new Cell(new Phrase("Data tidak ditemukan.", PrintUtility.fontSectionContentBold));
                    cell.setColspan(bagianAtasLebar.length);
                    bagianAtas.addCell(cell);
                }
            } else if (dataFor.equals("perTanggal")) {
                listReport = SessReportKredit.listDaftarPencapaianEstimasi(whereClause);
                if (listReport.isEmpty()) {
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                    cell = new Cell(new Phrase("Data tidak ditemukan.", PrintUtility.fontSectionContentBold));
                    cell.setColspan(bagianAtasLebar.length);
                    bagianAtas.addCell(cell);
                } else {
                    int grandQtyEst = 0;
                    double grandTotalEst = 0;
                    int grandQtyReal = 0;
                    double grandTotalReal = 0;
                    int grandQtySisa = 0;
                    double grandTotalSisa = 0;
                    for (int i = 0; i < listReport.size(); i++) {
                        Vector tempObj = (Vector) listReport.get(i);
                        Vector listRealisasi = new Vector(1, 1);

                        String dateStr = String.valueOf(tempObj.get(0));
                        Date dateCvt = Formater.formatDate(dateStr, "yyyy-MM-dd");
                        int qtyEst = Integer.parseInt(String.valueOf(tempObj.get(1)));
                        grandQtyEst += qtyEst;
                        double totalEst = Double.parseDouble(String.valueOf(tempObj.get(2)));
                        grandTotalEst += totalEst;

                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                        bagianAtas.addCell(new Phrase(String.valueOf(i + 1), PrintUtility.fontSectionContent));
                        bagianAtas.addCell(new Phrase(Formater.formatDate(dateCvt, "dd MMMM yyyy"), PrintUtility.fontSectionContent));
                        bagianAtas.addCell(new Phrase(String.valueOf(qtyEst), PrintUtility.fontSectionContent));
                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                        bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(totalEst), PrintUtility.fontSectionContent));
                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);

                        listRealisasi = SessReportKredit.listDaftarPencapaianRealisasi(0, dateCvt);

                        int qtyReal = 0;
                        double totalReal = 0;
                        if (!listRealisasi.isEmpty()) {
                            qtyReal = Integer.parseInt(String.valueOf(listRealisasi.get(0)));
                            grandQtyReal += qtyReal;
                            totalReal = Double.parseDouble(String.valueOf(listRealisasi.get(1)));
                            grandTotalReal += totalReal;
                            bagianAtas.addCell(new Phrase(String.valueOf(qtyEst), PrintUtility.fontSectionContent));
                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                            bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(totalReal), PrintUtility.fontSectionContent));
                            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                            bagianAtas.addCell(new Phrase(Formater.formatNumber(((totalReal / totalEst) * 100), "##.##") + "%", PrintUtility.fontSectionContent));
                            bagianAtas.addCell(new Phrase(Formater.formatNumber(((grandTotalReal / grandTotalEst) * 100), "##.##") + "%", PrintUtility.fontSectionContent));
                        }
                        double sisaTotal = totalEst - totalReal;
                        int sisaQty = qtyEst - qtyReal;
                        grandQtySisa += sisaQty;
                        grandTotalSisa += sisaTotal;
                        bagianAtas.addCell(new Phrase(String.valueOf(sisaQty), PrintUtility.fontSectionContent));
                        bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                        bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(sisaTotal), PrintUtility.fontSectionContent));
                    }
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_RIGHT);
                    cell = new Cell(new Phrase("Grand Total", PrintUtility.fontSectionContentBold));
                    cell.setColspan(2);
                    bagianAtas.addCell(cell);
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                    bagianAtas.addCell(new Phrase(String.valueOf(grandQtyEst), PrintUtility.fontSectionContentBold));
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                    bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(grandTotalEst), PrintUtility.fontSectionContentBold));
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                    bagianAtas.addCell(new Phrase(String.valueOf(grandQtyReal), PrintUtility.fontSectionContentBold));
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                    bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(grandTotalReal), PrintUtility.fontSectionContentBold));
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                    bagianAtas.addCell(new Phrase(Formater.formatNumber(((grandTotalReal / grandTotalEst) * 100), "##.##") + "%", PrintUtility.fontSectionContentBold));
                    bagianAtas.addCell(new Phrase("", PrintUtility.fontSectionContent));
                    bagianAtas.addCell(new Phrase(String.valueOf(grandQtySisa), PrintUtility.fontSectionContentBold));
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                    bagianAtas.addCell(new Phrase("Rp. " + numberFormat.format(grandTotalSisa), PrintUtility.fontSectionContentBold));
                }
            }

            document.add(subAtas);
            document.add(bagianAtas);

        } catch (Exception e) {
            PrintUtility.printErrorMessage(e.getMessage());
        }

        return document;
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
