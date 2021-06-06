/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.print.report;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.aiso.entity.masterdata.region.PstRegency;
import com.dimata.aiso.entity.masterdata.region.Regency;
import com.dimata.common.entity.location.Kabupaten;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstKabupaten;
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
import com.dimata.sedana.entity.kredit.Angsuran;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstAngsuran;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstPinjaman;
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
import com.lowagie.text.Element;
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
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author arise
 */
public class PrintKwitansi extends HttpServlet {

    public int SESS_LANGUAGE = 0;
    public long locationId = 0;
    public boolean sessLogin = false;

    public String approot = "";
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

    public static String bulan[][] = {
        {"Januari","Februari","Maret","April","Mei","Juni","Juli","Agustus","September","Oktober","November","Desember"},
        {"January","February","March","April","May","June","July","August","September","October","November","December"}
    };
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public static Vector vect = new Vector();
    // setting the color values
    public static Color border = new Color(0x00, 0x00, 0x00);
    public static Color bgColor = new Color(220, 220, 220);
    // setting some fonts in the color chosen by the user
    public static com.lowagie.text.Font fontTitle = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 22, com.lowagie.text.Font.BOLD, PrintKwitansi.border);
    public static com.lowagie.text.Font fontTitleUnderline = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 22, com.lowagie.text.Font.BOLD + com.lowagie.text.Font.UNDERLINE, PrintKwitansi.border);
    public static com.lowagie.text.Font fontUnderSubTitle = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 12);
    public static com.lowagie.text.Font fontMainHeader = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 14, com.lowagie.text.Font.BOLD + com.lowagie.text.Font.UNDERLINE, PrintKwitansi.border);
    public static com.lowagie.text.Font fontHeader = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.ITALIC, PrintKwitansi.border);
    public static com.lowagie.text.Font fontHeaderUnderline = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.ITALIC + com.lowagie.text.Font.UNDERLINE, PrintKwitansi.border);
    public static com.lowagie.text.Font fontListHeader = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.BOLD, PrintKwitansi.border);
    public static com.lowagie.text.Font fontLsContent = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 8);
    public static com.lowagie.text.Font fontLsContentUnderline = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 8, com.lowagie.text.Font.UNDERLINE, PrintKwitansi.border);
    public static com.lowagie.text.Font fontNormal = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10);
    public static com.lowagie.text.Font fontNormalBold = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.BOLD, PrintKwitansi.border);
    public static com.lowagie.text.Font fontNormalHeader = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10);
    public static com.lowagie.text.Font fontSection = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 12, com.lowagie.text.Font.BOLD, PrintKwitansi.border);
    public static com.lowagie.text.Font fontSubSection = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.BOLD, PrintKwitansi.border);
    public static com.lowagie.text.Font fontSectionContent = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 8);
    public static com.lowagie.text.Font fontSectionContentBold = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 8, com.lowagie.text.Font.BOLD, PrintKwitansi.border);

    public static NumberFormat formatNumber = NumberFormat.getInstance(new Locale("en", "EN"));

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
        com.lowagie.text.Rectangle rectangle = new com.lowagie.text.Rectangle(20, 20, 20, 20);
        rectangle.rotate();
        Document document = new Document();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            Rectangle r = new Rectangle(597.6f, 439.2f);
//			PageSize.CUSTOM;
            document.setPageSize(r);
            document.setMargins(20, 20, 15, 10);

            //step2.2: creating an instance of the writer
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            HeaderFooter header = new HeaderFooter(new Phrase(new Chunk("", PrintKwitansi.fontLsContent)), false);
            HeaderFooter footer = new HeaderFooter(new Phrase(new Chunk("", PrintKwitansi.fontLsContent)), false);
            footer.setBorder(HeaderFooter.NO_BORDER);
            header.setBorder(HeaderFooter.NO_BORDER);
            document.setHeader(header);
            document.setFooter(footer);

            document.open();

            this.SESS_LANGUAGE = FRMQueryString.requestInt(request, "SESS_LANGUAGE");
            String[] jadwalOid = request.getParameterValues("JADWAL_ANGSURAN_OID");
            this.approot = FRMQueryString.requestString(request, "approot");
            this.locationId = FRMQueryString.requestLong(request, "LOCATION_OID");

            Location loc = new Location();

            String pathImage = "http://" + request.getServerName() + ":" + request.getServerPort() + approot + "/images/company.jpg";
            System.out.println("approot = " + pathImage);
            com.lowagie.text.Image gambar = null;

            try {
                gambar = com.lowagie.text.Image.getInstance(pathImage);
            } catch (Exception ex) {
                System.out.println("gambar >>>>>> = " + gambar.getImageMask());
            }

//			if (locationId != 0) {
//				loc = PstLocation.fetchFromApi(this.locationId);
//			}
            if (jadwalOid != null && jadwalOid.length > 0) {
                int tempIndex = 1;
                long oldOid = 0;
                double totalAngsuran = 0;
                boolean sudahDibayar = false;
                Date tglAngsuran = new Date();
                for (int i = 0; i < jadwalOid.length; i++) {
                    long jaOid = Long.parseLong(jadwalOid[i]);

                    double jumlahAngsuran = 0;
                    int banyakAngsuran = 0;
                    int angsuranKe = 0;
                    
                    JadwalAngsuran ja = PstJadwalAngsuran.fetchExc(jaOid);
                    tglAngsuran = ja.getTanggalAngsuran();
                    Pinjaman p = PstPinjaman.fetchExc(ja.getPinjamanId());
                    try {
                        BillMain bm = PstBillMain.fetchExc(p.getBillMainId());
                        //loc = PstLocation.fetchFromApi(bm.getLocationId());
                        //if (loc.getOID() == 0) {
                            loc = PstLocation.fetchExc(bm.getLocationId());
                        //}
                        
                        banyakAngsuran = PstJadwalAngsuran.getCountAngsuranWithBunga(p.getOID());
                        String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID();
                        Vector<JadwalAngsuran> listAngsuranTemp = PstJadwalAngsuran.list(0, 0, whereClause, "", PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
                        for(JadwalAngsuran tempJa : listAngsuranTemp){
                            if(tempJa.getTanggalAngsuran().compareTo(ja.getTanggalAngsuran()) < 0 || tempJa.getTanggalAngsuran().compareTo(ja.getTanggalAngsuran()) == 0 ){
                                angsuranKe++;
                                
                            } else {
                                break;
                            }
                        }
                        listAngsuranTemp.clear();
                        
                        String whereClauseBefore = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID()+" AND DATE (" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")" 
                                + " < DATE('" + Formater.formatDate(ja.getTanggalAngsuran(), "yyyy-MM-dd") + "')"
                                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " IN ("
                                + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ", " + JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT
                                + ")";
                        listAngsuranTemp = PstJadwalAngsuran.list(0, 0, whereClauseBefore, "");
                        double sisaSebelumnya = 0;
                        double jumlahBayarSebelumnya = 0;
                        for(JadwalAngsuran tempJa : listAngsuranTemp){
                            double yangSudahDibayar = 0;
                            Vector<Angsuran> dibayar = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + tempJa.getOID(), "");
                            for(Angsuran a : dibayar){
                                yangSudahDibayar += a.getJumlahAngsuran();
                            }
                            sisaSebelumnya += tempJa.getJumlahANgsuran() - yangSudahDibayar;
                            jumlahBayarSebelumnya+= yangSudahDibayar;
                        }
                        
                        whereClause += " AND DATE (" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")" 
                                + " = DATE('" + Formater.formatDate(ja.getTanggalAngsuran(), "yyyy-MM-dd") + "')"
                                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " IN ("
                                + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ", " + JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT
                                + ")";
                        listAngsuranTemp = PstJadwalAngsuran.list(0, 0, whereClause, "");
                        for(JadwalAngsuran tempJa : listAngsuranTemp){
                            double yangSudahDibayar = 0;
                            Vector<Angsuran> dibayar = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + tempJa.getOID(), "");
                            for(Angsuran a : dibayar){
                                yangSudahDibayar += a.getJumlahAngsuran();
                            }
                            if (yangSudahDibayar > 0){
                                jumlahAngsuran += yangSudahDibayar;
                            } else {
                                jumlahAngsuran += tempJa.getJumlahANgsuran();
                            }
                            //totalAngsuran += yangSudahDibayar;//(tempJa.getJumlahANgsuran() + yangSudahDibayar);
                            sudahDibayar = jumlahAngsuran - yangSudahDibayar == 0;
                        }
                        jumlahAngsuran += sisaSebelumnya;
                        totalAngsuran += jumlahBayarSebelumnya + jumlahAngsuran;
                    } catch (Exception e) {
                    }
                    if (oldOid != ja.getPinjamanId()) {
                        oldOid = ja.getPinjamanId();
                        tempIndex = 1;
                    }
                    //if(!sudahDibayar){
                        document.add(PrintUtility.getHeaderImage(SESS_LANGUAGE, gambar, loc));
                        document = PrintKwitansi.getContent(document, writer, SESS_LANGUAGE, ja, p, angsuranKe, banyakAngsuran, jumlahAngsuran, totalAngsuran);
                        document.add(PrintKwitansi.getApproval(SESS_LANGUAGE, p, loc, tglAngsuran));
                        document.newPage();
                    //}
                    tempIndex = tempIndex + 1;
                }

            }

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
    private static Document getContent(Document document, PdfWriter writer, int SESS_LANGUAGE, JadwalAngsuran ja, Pinjaman p, int angsuranKe,
            int banyakAngsuran, double jumlahAngsuran, double totalAngsuran) throws BadElementException, DocumentException {

        int bagianAtasLebar[] = {15, 1, 20, 25, 15, 1, 20};
        Table bagianAtas = PrintUtility.createTable(bagianAtasLebar.length, bagianAtasLebar);
        bagianAtas.setDefaultCellBorder(Table.NO_BORDER);
        
        Anggota a = new Anggota();
        Employee kol = new Employee();
        Employee analis = new Employee();

        BillMain bm = new BillMain();
        Sales sales = new Sales();
        Cell cell;

        try {

            a = PstAnggota.fetchExc(p.getAnggotaId());
            kol = PstEmployee.fetchFromApi(p.getCollectorId());
            analis = PstEmployee.fetchFromApi(p.getAccountOfficerId());
            bm = PstBillMain.fetchExc(p.getBillMainId());

            String listBarang = "";
            Vector barangs = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + p.getBillMainId(), "");
            for (int i = 0; i < barangs.size(); i++) {
                Billdetail bd = (Billdetail) barangs.get(i);
                listBarang += (i + 1) + ". " + bd.getItemName() + " (" + bd.getQty() + ")\n";
            }

            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][0], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(p.getNoKredit(), PrintKwitansi.fontSectionContent));
            // sisi tengah alias pembagi 2 sisi
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            //sisi kanan
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase((SESS_LANGUAGE == 0 ? "Kwitansi" : "Receipt"), PrintKwitansi.fontNormalBold));

            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][1], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase((ja.getNoKwitansi() != null && ja.getNoKwitansi().length() > 0 ? ja.getNoKwitansi() : "-"), PrintKwitansi.fontSectionContent));
            // sisi tengah alias pembagi 2 sisi
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            //sisi kanan
            cell = new Cell(new Phrase(textHeaderMain[SESS_LANGUAGE][7], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(cell);
            cell = new Cell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(cell);
            cell = new Cell(new Phrase(listBarang, PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(cell);

            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][7], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(a.getName(), PrintKwitansi.fontSectionContent));
            // sisi tengah alias pembagi 2 sisi
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            //sisi kanan
            
            Calendar tglAmbil = Calendar.getInstance();
            tglAmbil.setTime(p.getTglRealisasi());
            
            cell = new Cell(new Phrase("Tgl Pengambilan", PrintKwitansi.fontSectionContent));
            cell.setRowspan(4);
            bagianAtas.addCell(cell);
            cell = new Cell(new Phrase(":", PrintKwitansi.fontSectionContent));
            cell.setRowspan(4);
            bagianAtas.addCell(cell);
            cell = new Cell(new Phrase(tglAmbil.get(Calendar.DATE)+" "+bulan[SESS_LANGUAGE][tglAmbil.get(Calendar.MONTH)]+" "+tglAmbil.get(Calendar.YEAR), PrintKwitansi.fontSectionContent));
            cell.setRowspan(4);
            bagianAtas.addCell(cell);

            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][3], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            cell = new Cell(new Phrase((p.getLokasiPenagihan() == Pinjaman.LOKASI_PENAGIHAN_RUMAH ? a.getAddressPermanent() : a.getOfficeAddress()), PrintKwitansi.fontSectionContent));
            cell.setColspan(2);
            bagianAtas.addCell(cell);

            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][4], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(a.getHandPhone(), PrintKwitansi.fontSectionContent));
            // sisi tengah alias pembagi 2 sisi
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));

            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][5], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase("Rp. " + formatNumber.format(jumlahAngsuran), PrintKwitansi.fontSectionContent));
            // sisi tengah alias pembagi 2 sisi
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));

            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][6], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            ConvertAngkaToHuruf angkaToHuruf = new ConvertAngkaToHuruf(new Double(jumlahAngsuran).longValue());
            String text = angkaToHuruf.getText() + "rupiah.";
            String res = PrintUtility.capitalizeWord(text);
            cell = new Cell(new Phrase(res, PrintKwitansi.fontSectionContentBold));
            cell.setColspan(2);
            cell.setBorder(Table.LEFT | Table.TOP);
            bagianAtas.addCell(cell);
            //sisi kanan
            bagianAtas.setDefaultCellBorder(Table.LEFT);
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            bagianAtas.setDefaultCellBorder(Table.NO_BORDER);
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));

//			//sisi kiri
//			bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][7], PrintKwitansi.fontSectionContent));
//			bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
//			bagianAtas.setDefaultCellBorder(Table.TOP);
//			cell = new Cell(new Phrase(listBarang, PrintKwitansi.fontSectionContent));
//			cell.setColspan(2);
//			bagianAtas.addCell(cell);			
//			// sisi tengah alias pembagi 2 sisi
////			bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent)); 			
//			//sisi kanan
//			bagianAtas.setDefaultCellBorder(Table.NO_BORDER);
//			bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
//			bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
//			bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            String linkSales = posApiUrl + "/user/sales-code/6/" + WebServices.encodeUrl(bm.getSalesCode());
            JSONObject jsonObj = WebServices.getAPI("", linkSales);
            JSONArray apiResult = new JSONArray();
            JSONObject salesPerson = new JSONObject();
            try {
                apiResult = jsonObj.getJSONArray("DATA");
                salesPerson = apiResult.getJSONArray(0).getJSONObject(1);
            } catch (Exception e) {
                PrintUtility.printErrorMessage(e.getMessage());
            }
            
//            double totalPokok = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
//            double totalBunga = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
//            double totalDP = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT);
//            double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
//            double bungaDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
//            double dpDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT);
//            double sisaPiutang = (totalPokok + totalBunga + totalDP) - (pokokDibayar + bungaDibayar + dpDibayar);
            double sisaPiutang = p.getJumlahPinjaman() - totalAngsuran;
            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][8], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.setDefaultCellBorder(Table.TOP);
            bagianAtas.addCell(new Phrase(salesPerson.optString("FULL_NAME", "-"), PrintKwitansi.fontSectionContent));
            // sisi tengah alias pembagi 2 sisi
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            //sisi kanan
            bagianAtas.setDefaultCellBorder(Table.NO_BORDER);
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][11], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase("Rp. " + formatNumber.format(sisaPiutang), PrintKwitansi.fontSectionContent));

            String whereClause = PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = " + p.getOID()
                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = " + I_Sedana.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT;
            int jumlahDibayar = PstTransaksi.getCount(whereClause);

            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][9], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(kol.getFullName(), PrintKwitansi.fontSectionContent));
            // sisi tengah alias pembagi 2 sisi
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            //sisi kanan
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][12], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            text = angsuranKe + (SESS_LANGUAGE == 0 ? " dari " : " of ") + banyakAngsuran;
            bagianAtas.addCell(new Phrase(text, PrintKwitansi.fontSectionContent));

            //sisi kiri
            bagianAtas.addCell(new Phrase(textHeaderMain[SESS_LANGUAGE][10], PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(":", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase(analis.getFullName(), PrintKwitansi.fontSectionContent));
            // sisi tengah alias pembagi 2 sisi
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            //sisi kanan
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));
            bagianAtas.addCell(new Phrase("", PrintKwitansi.fontSectionContent));

            document.add(bagianAtas);

        } catch (Exception e) {
            PrintUtility.printErrorMessage(e.getMessage());
        }

        return document;
    }

    private static Table getApproval(int SESS_LANGUAGE, Pinjaman p, Location loc, Date tglAngsuran) throws BadElementException, DocumentException {
        int ctnInt[] = {40, 20, 40};
        Table table = PrintUtility.createTable(ctnInt.length, ctnInt);
        try {
            String spasiLokasi = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            Anggota a = PstAnggota.fetchExc(p.getAnggotaId());
            Employee kol = PstEmployee.fetchFromApi(p.getCollectorId());
            Regency kab = new Regency();
            try {
                if (loc.getRegencyId() != 0) {
                    kab = PstRegency.fetch(loc.getRegencyId());
                }
            } catch (Exception exc){}
            
            Calendar tglAmbil = Calendar.getInstance();
            tglAmbil.setTime(tglAngsuran);
            
            table.setDefaultCellBorder(Table.NO_BORDER);

            table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
            table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
            table.addCell(new Phrase("", PrintKwitansi.fontNormal));
            table.addCell(new Phrase("", PrintKwitansi.fontNormal));
            Cell cell = new Cell(new Phrase(kab.getRegencyName()+ ", " + tglAmbil.get(Calendar.DATE)+" "+bulan[SESS_LANGUAGE][tglAmbil.get(Calendar.MONTH)]+" "+tglAmbil.get(Calendar.YEAR), PrintKwitansi.fontNormal));
            table.addCell(cell);

            table.addCell(new Phrase(textApproval[SESS_LANGUAGE][1], PrintKwitansi.fontNormalBold));
            table.addCell(new Phrase("", PrintKwitansi.fontNormalBold));
            table.addCell(new Phrase(textApproval[SESS_LANGUAGE][0], PrintKwitansi.fontNormalBold));

            PrintUtility.createEmptySpace(table, ctnInt.length, 3);

            table.addCell(new Phrase(kol.getFullName(), PrintKwitansi.fontNormal));
            table.addCell(new Phrase("", PrintKwitansi.fontNormal));
            table.addCell(new Phrase(a.getName(), PrintKwitansi.fontNormal));

        } catch (Exception e) {
            PrintUtility.printErrorMessage(e.getMessage());
        }
        return table;
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
