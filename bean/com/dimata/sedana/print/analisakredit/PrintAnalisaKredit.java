/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.print.analisakredit;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.analisakredit.AnalisaKreditDetail;
import com.dimata.sedana.entity.analisakredit.AnalisaKreditMain;
import com.dimata.sedana.entity.analisakredit.MasterAnalisaKredit;
import com.dimata.sedana.entity.analisakredit.MasterGroupAnalisaKredit;
import com.dimata.sedana.entity.analisakredit.PstAnalisaKreditDetail;
import com.dimata.sedana.entity.analisakredit.PstAnalisaKreditMain;
import com.dimata.sedana.entity.analisakredit.PstMasterAnalisaKredit;
import com.dimata.sedana.entity.analisakredit.PstMasterGroupAnalisaKredit;
import com.dimata.sedana.entity.analisakredit.PstMasterScore;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstPinjaman;
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
import com.lowagie.text.Table;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Locale;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author arise
 */
public class PrintAnalisaKredit extends HttpServlet {

	public long oidAnalisaMain = 0;

	public int SESS_LANGUAGE = 0;

	public boolean sessLogin = false;

	public String approot = "";
	public static String defFormatCurr = "###,###";

	public static String compName = PstSystemProperty.getValueByName("COMPANY_NAME");
	public static String subTitle = "ELEKTRONIK, MESIN, FURNITURE";

	public static final String textHeaderMain[][] = {
		{"Nomor Kredit", "Nama Pemohon", "Nomor Form 5C", "Tanggal Analisa", "Nama Analis", "Alamat", "Kepala Divisi Kredit", "Manager Operasional", "Analisa Kredit"},
		{"Loan Number", "Consumer Name", "5C Form Number", "Analysis Date", "Analyst Name", "Address", "Division Head of Loan", "Operational Manager", "Loan Analysis"}
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
		{"Konsumen", "Pengirim", "Koordinator"},
		{"Consumer", "Courier", "Coordinator"}
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
		{"Penghasilan Pemohon", "Penghasilan Penanggung", "Total Penghasilan", "Konsumsi", "Listelpam", "Pendidikan", "Sandang", "Angsuran Pinjaman", "Total Pengluaran","Lainnya"},
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
	// setting some fonts in the color chosen by the user
	public static com.lowagie.text.Font fontTitle = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 16, com.lowagie.text.Font.BOLD, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontTitleUnderline = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 22, com.lowagie.text.Font.BOLD + com.lowagie.text.Font.UNDERLINE, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontUnderSubTitle = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 13);
	public static com.lowagie.text.Font fontMainHeader = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 14, com.lowagie.text.Font.BOLD + com.lowagie.text.Font.UNDERLINE, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontHeader = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.ITALIC, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontHeaderUnderline = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.ITALIC + com.lowagie.text.Font.UNDERLINE, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontListHeader = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.BOLD, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontLsContent = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 8);
	public static com.lowagie.text.Font fontLsContentUnderline = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 8, com.lowagie.text.Font.UNDERLINE, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontNormal = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10);
	public static com.lowagie.text.Font fontNormalBold = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.BOLD, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontNormalHeader = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10);
	public static com.lowagie.text.Font fontSection = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 12, com.lowagie.text.Font.BOLD, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontSubSection = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 10, com.lowagie.text.Font.BOLD, PrintAnalisaKredit.border);
	public static com.lowagie.text.Font fontSectionContent = new com.lowagie.text.Font(com.lowagie.text.Font.STRIKETHRU, 8);

	public static NumberFormat formatNumber = NumberFormat.getInstance(new Locale("id","ID"));
	
	/**
	 * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
		Document document = new Document(PageSize.A4, 20, 20, 30, 30);
		ByteArrayOutputStream baos = new ByteArrayOutputStream();

		try {

			//step2.2: creating an instance of the writer
			PdfWriter writer = PdfWriter.getInstance(document, baos);
			// step 3.1: adding some metadata to the document
			document.addSubject("This is a subject.");
			document.addSubject("This is a subject two.");

			HeaderFooter footer = new HeaderFooter(new Phrase(new Chunk("", PrintAnalisaKredit.fontLsContent)), false);
			footer.setAlignment(Element.ALIGN_CENTER);
			footer.setBorder(HeaderFooter.NO_BORDER);
			//document.setHeader(header);
			document.setFooter(footer);

			document.open();

			this.SESS_LANGUAGE = FRMQueryString.requestInt(request, "SESS_LANGUAGE");
			this.oidAnalisaMain = FRMQueryString.requestLong(request, "ANALISA_MAIN_OID");
			this.approot = FRMQueryString.requestString(request, "approot");

			AnalisaKreditMain akm = PstAnalisaKreditMain.fetchExc(this.oidAnalisaMain);

			String pathImage = "http://" + request.getServerName() + ":" + request.getServerPort() + approot + "/images/company.jpg";
			System.out.println("approot = " + pathImage);
			com.lowagie.text.Image gambar = null;

			try {
				gambar = com.lowagie.text.Image.getInstance(pathImage);
			} catch (Exception ex) {
				System.out.println("gambar >>>>>> = " + gambar.getImageMask());
			}

			document.add(PrintAnalisaKredit.getHeaderImage(SESS_LANGUAGE, gambar, akm));
			document.add(PrintAnalisaKredit.getSubHeader(SESS_LANGUAGE, akm));

			document = PrintAnalisaKredit.getContent(document, writer, SESS_LANGUAGE, akm);
//			document.add(PrintAnalisaKredit.getApproval(SESS_LANGUAGE, pinjaman));
		} catch (Exception e) {
			printErrorMessage(e.getMessage());
		}

		document.close();
		response.setContentType("application/pdf");
		response.setContentLength(baos.size());
		ServletOutputStream sos = response.getOutputStream();
		baos.writeTo(sos);
		sos.flush();

	}

	// PROCESS ===================================
	private static Table getHeaderImage(int SESS_LANGUAGE, com.lowagie.text.Image gambar, AnalisaKreditMain akm) throws BadElementException, DocumentException {
		Table table = new Table(2);

		try {
			Location loc = PstLocation.fetchExc(akm.getLocationId());

			int ctnInt[] = {30, 70};
			table.setBorderColor(new Color(255, 255, 255));
			table.setWidth(100);
			table.setWidths(ctnInt);
			table.setSpacing(1);
			table.setPadding(0);
			table.setDefaultCellBorder(Table.NO_BORDER);

			createEmptySpace(table, 2, 3);

			//image in header
			//gambar.setAlignment(com.lowagie.text.Image.MIDDLE);
			gambar.scaleAbsolute(100, 100);
			Cell cellImage = new Cell(new Phrase(new Chunk(gambar, 0, 0)));
			cellImage.setRowspan(6);
			table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
			table.setDefaultVerticalAlignment(Table.ALIGN_BOTTOM);
			table.addCell(cellImage);

			//sub title
			table.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
			table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
			table.addCell(new Phrase(PrintAnalisaKredit.compName.toUpperCase(), PrintAnalisaKredit.fontTitleUnderline));
			table.addCell(new Phrase("", PrintAnalisaKredit.fontLsContent));
			table.addCell(new Phrase(PrintAnalisaKredit.subTitle.toUpperCase(), PrintAnalisaKredit.fontTitle));
			table.addCell(new Phrase(loc.getAddress(), PrintAnalisaKredit.fontUnderSubTitle));
			table.addCell(new Phrase(loc.getTelephone(), PrintAnalisaKredit.fontUnderSubTitle));
			table.addCell(new Phrase("", PrintAnalisaKredit.fontLsContent));

			createEmptySpace(table, 2, 2);

		} catch (Exception e) {
			printErrorMessage(e.getMessage());
		}
		return table;
	}

	private static Table getSubHeader(int SESS_LANGUAGE, AnalisaKreditMain akm) throws BadElementException, DocumentException {
		int column = 7;
		Table table = new Table(column);
		int ctnInt[] = {20, 2, 25, 10, 25, 2, 25};
		table.setBorderColor(new Color(255, 255, 255));
		table.setWidth(100);
		table.setWidths(ctnInt);
		table.setSpacing(1);
		table.setPadding(1);

		table.setDefaultCellBorder(Table.NO_BORDER);
		table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
		table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);

		Pinjaman pinjaman = new Pinjaman();
		Anggota anggota = new Anggota();
		Employee analis = new Employee();
		Employee empKadiv = new Employee();
		Employee empManager = new Employee();
		try {
			pinjaman = PstPinjaman.fetchExc(akm.getPinjamanId());
			anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
			analis = PstEmployee.fetchFromApi(pinjaman.getAccountOfficerId());
			empKadiv = PstEmployee.fetchFromApi(akm.getDivisionHeadId());
			empManager = PstEmployee.fetchFromApi(akm.getManagerId());
		} catch (Exception e) {
			printErrorMessage(e.getMessage());
		}

		Cell cell = new Cell(new Phrase(PrintAnalisaKredit.textHeaderMain[SESS_LANGUAGE][8], PrintAnalisaKredit.fontMainHeader));
		cell.setColspan(column);
		table.addCell(cell);

		createEmptySpace(table, column, 1);

		table.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
		// Nomor Form - Nama Pemohon
		table.addCell(new Phrase(PrintAnalisaKredit.textHeaderMain[SESS_LANGUAGE][2], PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(":", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(((akm.getAnalisaNumber().equals("") ? "-" : akm.getAnalisaNumber())), PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase("", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(PrintAnalisaKredit.textHeaderMain[SESS_LANGUAGE][1], PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(":", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(anggota.getName(), PrintAnalisaKredit.fontNormal));

		// Nomor Kredit - Nama Analis
		table.addCell(new Phrase(PrintAnalisaKredit.textHeaderMain[SESS_LANGUAGE][0], PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(":", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(((pinjaman.getNoKredit().equals("") ? "-" : pinjaman.getNoKredit())), PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase("", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(PrintAnalisaKredit.textHeaderMain[SESS_LANGUAGE][4], PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(":", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(analis.getFullName(), PrintAnalisaKredit.fontNormal));

		// Tanggal Analisa - Nama Manager
		table.addCell(new Phrase(PrintAnalisaKredit.textHeaderMain[SESS_LANGUAGE][3], PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(":", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(((akm.getAnalisaTgl() == null ? "-" : Formater.formatDate(akm.getAnalisaTgl(), "dd MMMM yyyy"))), PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase("", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(PrintAnalisaKredit.textHeaderMain[SESS_LANGUAGE][7], PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(":", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(empManager.getFullName(), PrintAnalisaKredit.fontNormal));

		// Alamat - Nama Kadiv
		table.addCell(new Phrase(PrintAnalisaKredit.textHeaderMain[SESS_LANGUAGE][5], PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(":", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(((anggota.getAddressPermanent().equals("") ? "-" : anggota.getAddressPermanent())), PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase("", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(PrintAnalisaKredit.textHeaderMain[SESS_LANGUAGE][6], PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(":", PrintAnalisaKredit.fontNormal));
		table.addCell(new Phrase(empKadiv.getFullName(), PrintAnalisaKredit.fontNormal));

		createEmptySpace(table, column, 2);

		return table;
	}

	private static Document getContent(Document document, PdfWriter writer, int SESS_LANGUAGE, AnalisaKreditMain akm) throws BadElementException, DocumentException {

		//Vector listTotal = new Vector(1, 1);
		double totalNilai = 0;
		boolean subSectionPrinted = false;

		int tableSectionWidths[] = {5, 97};
		Table tableSection = createTable(tableSectionWidths.length, tableSectionWidths);
		tableSection.setDefaultCellBorder(Table.NO_BORDER);

		int subSectionWidths[] = {5, 5, 90};
		Table tableSubSection = createTable(subSectionWidths.length, subSectionWidths);
		tableSubSection.setDefaultCellBorder(Table.NO_BORDER);

		int contentSectionAWidths[] = {10, 30, 10, 10, 10, 30};
		Table contentSectionA = createTable(contentSectionAWidths.length, contentSectionAWidths);
		contentSectionA.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
		contentSectionA.setWidth(80);
		contentSectionA.setCellsFitPage(true);
		
		Cell cell;
		try {
			//add section A
			tableSection.addCell(new Phrase("A. ", PrintAnalisaKredit.fontSection));
			tableSection.addCell(new Phrase(textSection[SESS_LANGUAGE][0], PrintAnalisaKredit.fontSection));
			Vector listMasterGroup = PstMasterGroupAnalisaKredit.listAll();
			document.add(tableSection);
			if (listMasterGroup.isEmpty()) {
				cell = new Cell(new Phrase("Master Group Empty.", PrintAnalisaKredit.fontSubSection));
				cell.setColspan(contentSectionAWidths.length);
				contentSectionA.addCell(cell);
			} else {
				String subSectionName = "";
				for (int i = 0; i < listMasterGroup.size(); i++) {
					//sub section
					MasterGroupAnalisaKredit mgak = (MasterGroupAnalisaKredit) listMasterGroup.get(i);
					if (!mgak.getGroupDesc().equals(subSectionName)) {
						subSectionPrinted = false;
					}
					if (!subSectionPrinted) {
						subSectionPrinted = true;
						subSectionName = mgak.getGroupDesc();
						tableSubSection.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
						tableSubSection.addCell(new Phrase("", PrintAnalisaKredit.fontSubSection));
						tableSubSection.addCell(new Phrase(String.valueOf(i + 1) + ".", PrintAnalisaKredit.fontSubSection));
						tableSubSection.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
						tableSubSection.addCell(new Phrase(mgak.getGroupDesc(), PrintAnalisaKredit.fontSubSection));
					}

					//section content
					double totalBobot = 0;
					double totalSkor = 0;
					double tempTotNilai = 0;
					contentSectionA.addCell(new Phrase(textTableContentA[SESS_LANGUAGE][0], PrintAnalisaKredit.fontSectionContent));
					contentSectionA.addCell(new Phrase(textTableContentA[SESS_LANGUAGE][1], PrintAnalisaKredit.fontSectionContent));
					contentSectionA.addCell(new Phrase(textTableContentA[SESS_LANGUAGE][2], PrintAnalisaKredit.fontSectionContent));
					contentSectionA.addCell(new Phrase(textTableContentA[SESS_LANGUAGE][3], PrintAnalisaKredit.fontSectionContent));
					contentSectionA.addCell(new Phrase(textTableContentA[SESS_LANGUAGE][4], PrintAnalisaKredit.fontSectionContent));
					contentSectionA.addCell(new Phrase(textTableContentA[SESS_LANGUAGE][5], PrintAnalisaKredit.fontSectionContent));

					String whereClause = PstAnalisaKreditDetail.TBL_ANALISAKREDITDETAIL + "." + PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_ANALISAKREDITMAINID]
							+ " = " + akm.getOID() + " AND " + PstMasterAnalisaKredit.TBL_MASTERANALISAKREDIT + "."
							+ PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_GROUPID] + " = " + mgak.getOID();
					Vector listAnalisaDetail = PstAnalisaKreditDetail.listDetailJoinMaster(0, 0, whereClause, "");

					if (listAnalisaDetail.isEmpty()) {
						cell = new Cell(new Phrase("Data Empty.", PrintAnalisaKredit.fontLsContent));
						cell.setColspan(contentSectionAWidths.length);
						contentSectionA.addCell(cell);
					} else {
						for (int j = 0; j < listAnalisaDetail.size(); j++) {
							Vector temp = (Vector) listAnalisaDetail.get(j);
							AnalisaKreditDetail akd = (AnalisaKreditDetail) temp.get(0);
							MasterAnalisaKredit mak = (MasterAnalisaKredit) temp.get(1);
							contentSectionA.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
							contentSectionA.addCell(new Phrase(String.valueOf(j + 1) + ".", PrintAnalisaKredit.fontSectionContent));
							contentSectionA.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
							contentSectionA.addCell(new Phrase("\t" + mak.getDescription(), PrintAnalisaKredit.fontSectionContent));
							contentSectionA.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
							contentSectionA.addCell(new Phrase(Formater.formatNumber(akd.getNilai(), "###"), PrintAnalisaKredit.fontSectionContent));
							contentSectionA.addCell(new Phrase(Formater.formatNumber(mgak.getGroupBobot(), "###"), PrintAnalisaKredit.fontSectionContent));
							contentSectionA.addCell(new Phrase(Formater.formatNumber(((akd.getNilai() * mgak.getGroupBobot()) / 100), "###.##"), PrintAnalisaKredit.fontSectionContent));
							contentSectionA.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
							contentSectionA.addCell(new Phrase("\t" + akd.getNotes(), PrintAnalisaKredit.fontSectionContent));
							tempTotNilai += akd.getNilai();
							totalBobot = mgak.getGroupBobot();
							totalSkor += (akd.getNilai() * mgak.getGroupBobot()) / 100;
							totalNilai += tempTotNilai;

						}
						contentSectionA.setDefaultHorizontalAlignment(Table.ALIGN_RIGHT);
						cell = new Cell(new Phrase("Total", PrintAnalisaKredit.fontSectionContent));
						cell.setColspan(2);
						contentSectionA.addCell(cell);
						contentSectionA.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
						contentSectionA.addCell(new Phrase(Formater.formatNumber(tempTotNilai, "###"), PrintAnalisaKredit.fontSectionContent));
						contentSectionA.addCell(new Phrase(Formater.formatNumber(totalBobot, "###"), PrintAnalisaKredit.fontSectionContent));
						contentSectionA.addCell(new Phrase(Formater.formatNumber(totalSkor, "###.##"), PrintAnalisaKredit.fontSectionContent));
						contentSectionA.addCell(new Phrase("", PrintAnalisaKredit.fontSectionContent));
					}
					//listTotal.add(totalNilai);
					totalNilai = 0;
					document.add(tableSubSection);
					document.add(contentSectionA);
					tableSubSection = createTable(subSectionWidths.length, subSectionWidths);
					tableSubSection.setDefaultCellBorder(Table.NO_BORDER);
					createEmptySpace(tableSubSection, subSectionWidths.length, 1);
					contentSectionA = createTable(contentSectionAWidths.length, contentSectionAWidths);
					contentSectionA.setWidth(80);
					contentSectionA.setCellsFitPage(true);
					contentSectionA.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
				}
			}

			//add content section B
			tableSection = createTable(tableSectionWidths.length, tableSectionWidths);
			tableSection.setDefaultCellBorder(Table.NO_BORDER);
			createEmptySpace(tableSection, tableSectionWidths.length, 1);
			tableSection.addCell(new Phrase("B. ", PrintAnalisaKredit.fontSection));
			tableSection.addCell(new Phrase(textSection[SESS_LANGUAGE][1], PrintAnalisaKredit.fontSection));
			document.add(tableSection);

			//add sub section
			tableSubSection = createTable(subSectionWidths.length, subSectionWidths);
			tableSubSection.setDefaultCellBorder(Table.NO_BORDER);
			tableSubSection.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
			tableSubSection.addCell(new Phrase("", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase("1.", PrintAnalisaKredit.fontSubSection));
			tableSubSection.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
			tableSubSection.addCell(new Phrase(textSubSectionB[SESS_LANGUAGE][0], PrintAnalisaKredit.fontSubSection));
			document.add(tableSubSection);

			double totalPenghasilan = akm.getPenghasilanPemohon() + akm.getPenghasilanPenanggung();
			double totalPengeluaran = akm.getPengeluaranKonsumsi() + akm.getPengeluaranListelpam() + akm.getPengeluaranPendidikan() + akm.getPengeluaranSandang() + akm.getPengeluaranLainnya();
			
			//add content sub section
			int contentSectionBWidths[] = {29, 1, 70};
			Table contentSectionB = createTable(contentSectionBWidths.length, contentSectionBWidths);
			contentSectionB.setDefaultCellBorder(Table.NO_BORDER);
			contentSectionB.setWidth(80);
			contentSectionB.setCellsFitPage(true);
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][0], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(akm.getPenghasilanPemohon()), PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][1], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(akm.getPenghasilanPenanggung()), PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][2], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(totalPenghasilan), PrintAnalisaKredit.fontSectionContent));
			document.add(contentSectionB);

			//add sub section
			JadwalAngsuran ja = new JadwalAngsuran();
			String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + "=" + akm.getPinjamanId();
			Vector listAngsuran = PstJadwalAngsuran.list(0, 0, whereClause, "");
			if (!listAngsuran.isEmpty()) {
				ja = (JadwalAngsuran) listAngsuran.get(0);
			}
			tableSubSection = createTable(subSectionWidths.length, subSectionWidths);
			tableSubSection.setDefaultCellBorder(Table.NO_BORDER);
			tableSubSection.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
			tableSubSection.addCell(new Phrase("", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase("2.", PrintAnalisaKredit.fontSubSection));
			tableSubSection.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
			tableSubSection.addCell(new Phrase(textSubSectionB[SESS_LANGUAGE][1], PrintAnalisaKredit.fontSubSection));
			document.add(tableSubSection);

			//add content sub section
			contentSectionB = createTable(contentSectionBWidths.length, contentSectionBWidths);
			contentSectionB.setDefaultCellBorder(Table.NO_BORDER);
			contentSectionB.setWidth(80);
			contentSectionB.setCellsFitPage(true);
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][3], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(akm.getPengeluaranKonsumsi()), PrintAnalisaKredit.fontSectionContent));
			
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][4], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(akm.getPengeluaranListelpam()), PrintAnalisaKredit.fontSectionContent));
			
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][5], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(akm.getPengeluaranPendidikan()), PrintAnalisaKredit.fontSectionContent));
			
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][6], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(akm.getPengeluaranSandang()), PrintAnalisaKredit.fontSectionContent));
			
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][9], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(akm.getPengeluaranLainnya()), PrintAnalisaKredit.fontSectionContent));
			
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][7], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(ja.getJumlahANgsuran()), PrintAnalisaKredit.fontSectionContent));
			
			contentSectionB.addCell(new Phrase(textContentB[SESS_LANGUAGE][8], PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase(":", PrintAnalisaKredit.fontSectionContent));
			contentSectionB.addCell(new Phrase("Rp. " + formatNumber.format(totalPengeluaran), PrintAnalisaKredit.fontSectionContent));
			document.add(contentSectionB);

			//add subcontent sub section
			int addSubContentBWidths[] = {5, 5, 34, 1, 55};

			tableSubSection = createTable(addSubContentBWidths.length, addSubContentBWidths);
			tableSubSection.setDefaultCellBorder(Table.NO_BORDER);
			tableSubSection.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
			double surplus = totalPenghasilan - totalPengeluaran;
			double surplusStengah = surplus*50/100;
			double surplusharian = surplusStengah/30;
			tableSubSection.addCell(new Phrase("", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase("", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase(textSubSectionB[SESS_LANGUAGE][2], PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase(":", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase("Rp. " + formatNumber.format(surplus), PrintAnalisaKredit.fontSubSection));

			tableSubSection.addCell(new Phrase("", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase("", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase(textSubSectionB[SESS_LANGUAGE][3], PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase(":", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase("Rp. " + formatNumber.format(surplusStengah), PrintAnalisaKredit.fontSubSection));

			tableSubSection.addCell(new Phrase("", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase("", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase(textSubSectionB[SESS_LANGUAGE][4], PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase(":", PrintAnalisaKredit.fontSubSection));
			tableSubSection.addCell(new Phrase("Rp. " + formatNumber.format(Math.round(surplusharian)), PrintAnalisaKredit.fontSubSection)); 
			document.add(tableSubSection);

			//add content section C
			tableSection = createTable(tableSectionWidths.length, tableSectionWidths);
			tableSection.setDefaultCellBorder(Table.NO_BORDER);
			createEmptySpace(tableSection, tableSectionWidths.length, 1);
			tableSection.addCell(new Phrase("C. ", PrintAnalisaKredit.fontSection));
			tableSection.addCell(new Phrase(textSection[SESS_LANGUAGE][2], PrintAnalisaKredit.fontSection));
			document.add(tableSection);

			int contentSectionCWidths[] = {10, 30, 10, 10, 10, 30};
			Table contentSectionC = createTable(contentSectionCWidths.length, contentSectionCWidths);
			contentSectionC.setWidth(90);
			contentSectionC.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
			contentSectionC.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
			contentSectionC.addCell(new Phrase(textAnalisaResult[SESS_LANGUAGE][0], PrintAnalisaKredit.fontSubSection));
			contentSectionC.addCell(new Phrase(textAnalisaResult[SESS_LANGUAGE][1], PrintAnalisaKredit.fontSubSection));
			contentSectionC.addCell(new Phrase(textAnalisaResult[SESS_LANGUAGE][2], PrintAnalisaKredit.fontSubSection));
			contentSectionC.addCell(new Phrase(textAnalisaResult[SESS_LANGUAGE][3], PrintAnalisaKredit.fontSubSection));
			contentSectionC.addCell(new Phrase(textAnalisaResult[SESS_LANGUAGE][4], PrintAnalisaKredit.fontSubSection));
			contentSectionC.addCell(new Phrase(textAnalisaResult[SESS_LANGUAGE][5], PrintAnalisaKredit.fontSubSection));

			double grandTotalSkor = 0;
			
			String endResult = "";
			ArrayList analystRes = PstAnalisaKreditDetail.calculateAnalystResult(akm.getOID());
			for (int i = 0; i < analystRes.size(); i++) {
				ArrayList temp = (ArrayList) analystRes.get(i);
				String desc = String.valueOf(temp.get(0));
				double nilai = Double.parseDouble(String.valueOf(temp.get(1))); 
				int bobot = Integer.parseInt(String.valueOf(temp.get(2))); 
				double skor = Double.parseDouble(String.valueOf(temp.get(3))); 
				long oid = Long.parseLong(String.valueOf(temp.get(4)));
				endResult = PstMasterScore.calculateScore(oid, skor);
				grandTotalSkor += skor;
				contentSectionC.addCell(new Phrase(String.valueOf(i + 1) + ".", PrintAnalisaKredit.fontSectionContent));
				contentSectionC.addCell(new Phrase(desc, PrintAnalisaKredit.fontSectionContent));
				contentSectionC.addCell(new Phrase(Formater.formatNumber(nilai, "###"), PrintAnalisaKredit.fontSectionContent));
				contentSectionC.addCell(new Phrase(Formater.formatNumber(bobot, "###"), PrintAnalisaKredit.fontSectionContent));
				contentSectionC.addCell(new Phrase(Formater.formatNumber(skor, "###.##"), PrintAnalisaKredit.fontSectionContent)); 
				contentSectionC.addCell(new Phrase(endResult, PrintAnalisaKredit.fontSectionContent));
			}

			contentSectionC.setDefaultHorizontalAlignment(Table.ALIGN_RIGHT);
			cell = new Cell(new Phrase("Total", PrintAnalisaKredit.fontSubSection));
			cell.setColspan(4);
			contentSectionC.addCell(cell);
			contentSectionC.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
			contentSectionC.addCell(new Phrase(Formater.formatNumber(grandTotalSkor, "###.##"), PrintAnalisaKredit.fontSectionContent)); 
			endResult = "";
			endResult = PstMasterScore.calculateScore(0, grandTotalSkor);

			contentSectionC.addCell(new Phrase(endResult, PrintAnalisaKredit.fontSectionContent));
			document.add(contentSectionC);

		} catch (Exception e) {
			System.out.println("err: " + e.toString());
		}
		return document;
	}

//=============================== UTILITY =======================
	public static Table createTable(int col, int[] widths) throws BadElementException, DocumentException {
		Table tempTable = new Table(col);

		int ctnInt[] = widths;
		tempTable.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
		tempTable.setDefaultVerticalAlignment(Table.ALIGN_CENTER);
		tempTable.setDefaultCellBackgroundColor(PrintAnalisaKredit.bgColor);
		tempTable.setCellsFitPage(true);
		tempTable.setDefaultCellBackgroundColor(Color.WHITE);
		tempTable.setBorderColor(new Color(255, 255, 255));
		tempTable.setWidth(100);
		tempTable.setWidths(ctnInt);
		tempTable.setSpacing(1);
		tempTable.setPadding(1);

		return tempTable;
	}

	private static void createEmptySpace(Table table, int col, int row) throws BadElementException, DocumentException {
		for (int i = 0; i < row; i++) {
			Cell cell = new Cell(new Phrase("", PrintAnalisaKredit.fontLsContent));
			cell.setColspan(col);
			table.addCell(cell);
		}

	}

	public static void printErrorMessage(String errorMessage) {
		System.out.println("");
		System.out.println("========================================>>> WARNING <<<========================================");
		System.out.println("");
		System.out.println("MESSAGE : " + errorMessage);
		System.out.println("");
		System.out.println("========================================<<< * * * * >>>========================================");
		System.out.println("");
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
