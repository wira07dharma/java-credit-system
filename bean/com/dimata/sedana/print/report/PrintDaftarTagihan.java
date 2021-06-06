/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.print.report;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.common.session.convert.ConvertAngkaToHuruf;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.pos.entity.billing.BillMain;
import com.dimata.pos.entity.billing.Billdetail;
import com.dimata.pos.entity.billing.PstBillDetail;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.posbo.entity.masterdata.PstSales;
import com.dimata.posbo.entity.masterdata.Sales;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstAngsuran;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran;
import com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.print.component.PrintUtility;
import com.dimata.sedana.session.SessReportKredit;
import com.dimata.services.WebServices;
import com.dimata.util.Formater;
import com.lowagie.text.BadElementException;
import com.lowagie.text.Cell;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.HeaderFooter;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
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
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

/**
 *
 * @author arise
 */
public class PrintDaftarTagihan extends HttpServlet {

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

    public static final String textHeaderMain[][] = {
        {"No. Kredit", "No. Kwitansi", "Terima Dari", "Alamat", "No. Telp.", "Angsuran", "Terbilang", "Barang", "Sales", "Kolektor", "Analis", "Saldo Akhir", "Angsuran ke"},
        {"Loan Num.", "Receipt Num.", "Accepted From", "Address", "Phone Num.", "Installments", "In Text", "Goods", "Sales", "Collector", "Analyst", "Final Balance", "Installment "}
    };

    public static final String textHeaderItem[][] = {
        {"No", "Nama Barang", "Kategori", "Qty", "Keterangan"},
        {"No", "Item Name", "Category", "Qty", "Remark"}
    };

    public static final String textMessage[][] = {
        {"Mohon diterima dengan baik barang-barang berikut ini: "},
        {"Please accept the following items: "}
    };

    public static final String textApproval[][] = {
        {"Konsumen", "Kolektor"},
        {"Consumer", "COllector"}
    };

    public static final String textSection[][] = {
        {"Analisa Form 5C", "Kemampuan Bayar", "Hasil Analisa"},
        {"5C Form Analysis", "Pay Capability", "Analysis Result"}
    };

    public static final String textTableContentA[][] = {
        {"No.", "Aspek & Faktor", "Nilai", "Bobot", "Skor", "Keterangan"},
        {"No.", "Aspect & Factor", "Value", "Weight", "Score", "Notes"}
    };

    public static final String textSubSectionB[][] = {
        {"Penghasilan", "Pengeluaran", "Surplus Untuk Angsuran", "Angsuran Pinjaman (Maksimal 50%)", "Angsuran Harian"},
        {"Income", "Spending", "Installments Surplus", "Loan Installments (Max. 50%)", "Daily Installments"}
    };

    public static final String textContentB[][] = {
        {"Penghasilan Pemohon", "Penghasilan Penanggung", "Total Penghasilan", "Konsumsi", "Listelpam", "Pendidikan", "Sandang", "Angsuran Pinjaman", "Total Pengluaran", "Lainnya"},
        {"Applicant Income", "Insurer Income", "Total Income", "Consumption", "Listelpam", "Education", "Clothing Needs", "Loan Installments", "Total Spending", "Others"}
    };

    public static final String textAnalisaResult[][] = {
        {"No", "Kategori", "Total Nilai", "Bobot (%)", "Total Skor", "Hasil Akhir"},
        {"No", "Category", "Total Value", "Weight (%)", "Total Score", "End Result"}
    };

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public static Vector vect = new Vector();
    // setting the color values
    public static Color border = new Color(0x00, 0x00, 0x00);
    public static Color bgColor = new Color(220, 220, 220);

    public static NumberFormat formatNumber = NumberFormat.getInstance(new Locale("id", "ID"));

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
            String whereClause;

            Vector listReport = new Vector(1, 1);

//            whereClause = " SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + PstJadwalAngsuran.JENIS_ANGSURAN_POKOK;
            whereClause = "AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_CAIR
                    + " AND SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]
                    + " IN(" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", "+ JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT +") ";
            if (oidKol != null && oidKol.length > 0) {
                whereClause += " AND (";
                for (int i = 0; i < oidKol.length; i++) {
                    long kolektorOid = Long.parseLong(String.valueOf(oidKol[i]));
                    if (i > 0) {
                        whereClause += " OR ";
                    }
                    whereClause += " AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " LIKE '%" + kolektorOid + "%' ";
                }
                whereClause += ") ";
            }
            if (oidLoc != null && oidLoc.length > 0) {
                whereClause += " AND (";
                for (int i = 0; i < oidLoc.length; i++) {
                    long locOid = Long.parseLong(String.valueOf(oidLoc[i]));
                    if (i > 0) {
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
            this.title = "Daftar Tagihan Kolektor";
            if (this.dataFor != null && this.dataFor.length() > 0) {
                if (dataFor.equals("tidakTertagih")) {
                    this.title += " Yang Tidak Tertagih";
                    whereClause += " AND SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID]
                            + " NOT IN (SELECT AA." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS AA)";
                }
            }
            whereClause += " AND AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_CAIR;
            listReport = SessReportKredit.listDaftarTagihan(whereClause);

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

            document.add(PrintUtility.getHeaderImage(SESS_LANGUAGE, gambar, loc));
            document = getContent(document, writer, SESS_LANGUAGE, listReport, cvtStartDate, cvtEndDate, this.title);

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

    // PROCESS ===================================
    private static Document getContent(Document document, PdfWriter writer, int SESS_LANGUAGE, Vector listReport, Date startDate, Date endDate, String title) throws BadElementException, DocumentException {

        int bagianAtasLebar[] = {5, 11, 11, 14, 13, 11, 11, 11, 11};
        Table bagianAtas = PrintUtility.createTable(bagianAtasLebar.length, bagianAtasLebar);
//		bagianAtas.setDefaultCellBorder(Table.NO_BORDER);
        bagianAtas.setCellsFitPage(true);
        Cell cell;

        int subAtasLebar[] = {100};
        Table subAtas = PrintUtility.createTable(subAtasLebar.length, subAtasLebar);
        subAtas.setDefaultCellBorder(Table.NO_BORDER);

        try {

            String periode = "Periode";
            if (startDate != null && endDate != null) {
                periode += " " + Formater.formatDate(startDate, "dd MMMM yyyy") + " - " + Formater.formatDate(endDate, "dd MMMM yyyy");
            } else {
                periode += " Semua.";
            }

            subAtas.addCell(new Phrase(title.toUpperCase(), PrintUtility.fontSection));
            cell = new Cell(new Phrase(periode, PrintUtility.fontSectionContentBold));

            subAtas.addCell(cell);

            boolean isShown = false;
            long oldOid = 0L;
            int tempCount = 1;
            double total = 0;
            double grandTotal = 0;

            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
            bagianAtas.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
            bagianAtas.setDefaultCellBackgroundColor(new Color(223, 230, 233));

            bagianAtas.addCell(new Phrase("No.", PrintUtility.fontSectionContentBold));
            bagianAtas.addCell(new Phrase("Tgl. Angsuran", PrintUtility.fontSectionContentBold));
            bagianAtas.addCell(new Phrase("No. Kredit", PrintUtility.fontSectionContentBold));
            bagianAtas.addCell(new Phrase("No. Kwitansi", PrintUtility.fontSectionContentBold));
            bagianAtas.addCell(new Phrase("Nama Customer", PrintUtility.fontSectionContentBold));
            bagianAtas.addCell(new Phrase("Alamat", PrintUtility.fontSectionContentBold));
            bagianAtas.addCell(new Phrase("Phone", PrintUtility.fontSectionContentBold));
            bagianAtas.addCell(new Phrase("Angsuran", PrintUtility.fontSectionContentBold));
            bagianAtas.addCell(new Phrase("Kolektibilitas", PrintUtility.fontSectionContentBold));

            bagianAtas.setDefaultCellBackgroundColor(Color.WHITE);

            for (int i = 0; i < listReport.size(); i++) {
                Vector temp = (Vector) listReport.get(i);
                JadwalAngsuran ja = (JadwalAngsuran) temp.get(0);
                Pinjaman p = (Pinjaman) temp.get(1);
                Anggota a = new Anggota();
                Employee kol = new Employee();
                Location kolLoc = new Location();
                //Anggota kol = new Anggota();
                KolektibilitasPembayaran kp = new KolektibilitasPembayaran();
                double jumlahAngsuran = 0;
                try {
                    a = PstAnggota.fetchExc(p.getAnggotaId());
                    kol = PstEmployee.fetchFromApi(p.getCollectorId());
                    kp = PstKolektibilitasPembayaran.fetchExc(p.getKodeKolektibilitas());
                    kolLoc = PstLocation.fetchFromApi(kol.getLocationId());

                    String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()
                            + " AND DATE(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")" + " = DATE('" + Formater.formatDate(ja.getTanggalAngsuran(), "yyyy-MM-dd") + "')";
                    Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.list(0, 0, whereClause, "");
                    for (JadwalAngsuran tempJa : listAngsuran) {
                        jumlahAngsuran += tempJa.getJumlahANgsuran();
                    }

                } catch (Exception e) {
                }

                if (!isShown) {
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                    String tmpTxt = "Kolektor: " + kol.getFullName() + ", Lokasi: " + kolLoc.getName();
                    cell = new Cell(new Phrase(tmpTxt, PrintUtility.fontSectionContentBold));
                    cell.setColspan(bagianAtasLebar.length);
                    bagianAtas.addCell(cell);

                    oldOid = kol.getOID();
                    tempCount = 1;
                    total = 0;
                    isShown = true;
                }

                bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                bagianAtas.addCell(new Phrase(String.valueOf(tempCount), PrintUtility.fontSectionContent));
                bagianAtas.addCell(new Phrase(Formater.formatDate(ja.getTanggalAngsuran(), "dd-MM-yyyy"), PrintUtility.fontSectionContent));
                bagianAtas.addCell(new Phrase(p.getNoKredit(), PrintUtility.fontSectionContent));
                bagianAtas.addCell(new Phrase((ja.getNoKwitansi() == null ? "-" : ja.getNoKwitansi()), PrintUtility.fontSectionContent));
                bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                bagianAtas.addCell(new Phrase(a.getName(), PrintUtility.fontSectionContent));
                bagianAtas.addCell(new Phrase(a.getAddressPermanent(), PrintUtility.fontSectionContent));
                bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
                bagianAtas.addCell(new Phrase(a.getHandPhone(), PrintUtility.fontSectionContent));
                bagianAtas.addCell(new Phrase("Rp. " + formatNumber.format(jumlahAngsuran), PrintUtility.fontSectionContent));
                bagianAtas.addCell(new Phrase(kp.getJudulKolektibilitas(), PrintUtility.fontSectionContent));

                total += jumlahAngsuran;
                grandTotal += jumlahAngsuran;

                if ((i + 1) >= listReport.size()) {
                    oldOid = 0;
                }
                if (p.getCollectorId() != oldOid) {
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_RIGHT);
                    cell = new Cell(new Phrase("Total", PrintUtility.fontSectionContentBold));
                    cell.setColspan(7);
                    bagianAtas.addCell(cell);
                    bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
                    cell = new Cell(new Phrase("Rp. " + formatNumber.format(total), PrintUtility.fontSectionContentBold));
                    cell.setColspan(2);
                    bagianAtas.addCell(cell);
                    isShown = false;
                }

                tempCount++;
            }
            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_RIGHT);
            cell = new Cell(new Phrase("Grand Total", PrintUtility.fontSectionContentBold));
            cell.setColspan(7);
            bagianAtas.addCell(cell);
            bagianAtas.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
            cell = new Cell(new Phrase("Rp. " + formatNumber.format(grandTotal), PrintUtility.fontSectionContentBold));
            cell.setColspan(2);
            bagianAtas.addCell(cell);
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
