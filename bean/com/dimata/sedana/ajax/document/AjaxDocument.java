/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.document;

import com.dimata.aiso.entity.masterdata.Company;
import com.dimata.aiso.entity.masterdata.PstCompany;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.common.session.convert.ConvertAngkaToHuruf;
import com.dimata.gui.jsp.ControlCombo;
import java.io.*;
import java.sql.*;
import java.awt.Color;
import java.io.ByteArrayOutputStream;

import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.util.Date;

import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import com.dimata.util.*;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.harisma.entity.employee.*;
import com.dimata.qdep.form.*;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.system.entity.PstSystemProperty;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.ExceptionConverter;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.ColumnText;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.tool.xml.ElementList;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import com.lowagie.text.html.simpleparser.HTMLWorker;
import com.lowagie.text.html.simpleparser.StyleSheet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import org.xhtmlrenderer.pdf.ITextRenderer;

/**
 *
 * @author Gunadi
 */
public class AjaxDocument extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     */
    public static String FOOTER = "";
    public static final String CSS
            = "html, body, div, span, applet, object, iframe,"
            + "table, caption, tbody, tfoot, thead, tr, th, td,"
            + "article, aside, canvas, details, embed, "
            + "figure, figcaption, footer, header, hgroup, "
            + "menu, nav, output, ruby, section, summary,"
            + "time, mark, audio, video {"
            + "margin: 0;"
            + "padding: 0;"
            + "border: 0;"
            + "font: inherit;"
            + "vertical-align: baseline;"
            + "}";

    public static String HEADER
            = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        float left = 30;
        float right = 30;
        float top = 100;
        float bottom = 60;

        long oidDocMaster = FRMQueryString.requestLong(request, "hidden_docmaster_id");
        long oidEmpDoc = FRMQueryString.requestLong(request, "oid_emp_doc");
        long oidPinjaman = FRMQueryString.requestLong(request, "oid_pinjaman");
        String empDocMasterTemplateText = "";
        EmpDoc empDoc = new EmpDoc();
        DocMaster empDocMaster = new DocMaster();
        DocMasterTemplate docMasterTemplate = new DocMasterTemplate();
        Pinjaman pinjaman = new Pinjaman();
        long templateId = 0;
        
        if (oidEmpDoc > 0) {
            try {
                empDoc = PstEmpDoc.fetchExc(oidEmpDoc);
                pinjaman = PstPinjaman.fetchExc(oidPinjaman);
            } catch (Exception exc) {
            }

            empDocMasterTemplateText = empDoc.getDetails();

            if (empDocMasterTemplateText.equals("")) {
                if (oidDocMaster > 0) {
                    try {
                        empDocMaster = PstDocMaster.fetchExc(oidDocMaster);
                    } catch (Exception e) {
                    }
                    try {
                        empDocMasterTemplateText = PstDocMasterTemplate.getTemplateText(oidDocMaster);
                    } catch (Exception e) {
                    }
                }
            }

            String where = PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] + "=" + oidDocMaster;
            Vector vListTemplate = PstDocMasterTemplate.list(0, 0, where, "");
            if (vListTemplate.size() > 0) {
                docMasterTemplate = (DocMasterTemplate) vListTemplate.get(0);
            }
        }

        HEADER = "<table style=\"width:100%\" border=\"0\"><tr><td>" + docMasterTemplate.getText_header() + "</td></tr></table>";
        FOOTER = docMasterTemplate.getText_footer();

        Document document = new Document(PageSize.A4, docMasterTemplate.getLeftMargin(), docMasterTemplate.getRightMargin(), docMasterTemplate.getTopMargin(), docMasterTemplate.getBottomMargin());
        //start
        empDocMasterTemplateText = empDocMasterTemplateText.replace("&lt", "<");
        empDocMasterTemplateText = empDocMasterTemplateText.replace("<;", "<");
        empDocMasterTemplateText = empDocMasterTemplateText.replace("&gt", ">");
        String tanpaeditor = empDocMasterTemplateText;
        String subString = "";
        String stringResidual = empDocMasterTemplateText;
        Vector vNewString = new Vector();

        String imgRoot = "";
        try {
            imgRoot = PstSystemProperty.getValueByName("COMPANY_NAME");
        } catch (Exception e) {
        }

        if (!imgRoot.equals("")) {
            empDocMasterTemplateText = empDocMasterTemplateText.replace("${COMPANY}", imgRoot);
        }

        String where1 = " " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
        Hashtable hlistEmpDocField = PstEmpDocField.Hlist(0, 0, where1, "");
        Hashtable hashCompany = new Hashtable();
        Hashtable hashContact = new Hashtable();
        Hashtable hashPinjaman = new Hashtable();
        Hashtable hashContactFamily = new Hashtable();
        Hashtable hashEmpDoc = new Hashtable();

        Vector listCompany = PstCompany.list(0, 0, "", "");
        if (listCompany != null && listCompany.size() > 0) {
            try {
                Company company = (Company) listCompany.get(0);
                hashCompany = PstCompany.fetchExcHashtable(company.getOID());
                hashContact = PstAnggota.fetchExcHashtable(pinjaman.getAnggotaId());
                hashPinjaman = PstPinjaman.fetchExcHashtable(pinjaman.getOID());
                hashContactFamily = PstAnggota.fetchExcHashtable(576462263449447080L);
                hashEmpDoc = PstEmpDoc.fetchExcHashtable(oidEmpDoc);
            } catch (Exception exc) {
                System.out.println(exc.toString());
            }
        }

        int startPosition = 0;
        int endPosition = 0;
        int index = 0;
        try {
            do {

                ObjectDocumentDetail objectDocumentDetail = new ObjectDocumentDetail();
                startPosition = stringResidual.indexOf("${") + "${".length();
                endPosition = stringResidual.indexOf("}", startPosition);
                subString = stringResidual.substring(startPosition, endPosition);

                        //cek substring
                String[] parts = subString.split("-");
                String objectName = "";
                String objectType = "";
                String objectClass = "";
                String objectStatusField = "";
                try {
                    objectName = parts[0];
                    objectType = parts[1];
                    objectClass = parts[2];
                    objectStatusField = parts[3];
                } catch (Exception e) {
                    System.out.printf("pastikan 4 parameter");
                }

                long oidEmpDocField = 0;
                String whereC = " " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                Vector listEmp = PstEmpDocField.list(0, 0, whereC, "");
                EmpDocField empDocField = new EmpDocField();
                try {
                    empDocField = (EmpDocField) listEmp.get(0);
                    oidEmpDocField = empDocField.getOID();
                } catch (Exception e) {

                }

                //cek dulu apakah hanya object name atau tidak
                if (!objectName.equals("") && !objectType.equals("") && !objectClass.equals("") && !objectStatusField.equals("")) {
                    if (objectType.equals("FIELD") && objectStatusField.equals("AUTO")) {
                        //String field = "<input type=\"text\" name=\""+ subString +"\" value=\"\">";
                        Date newd = new Date();
                        String field = "04/KEP/BPD-PMT/" + newd.getMonth() + "/" + newd.getYear();
                        empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", field);
                        tanpaeditor = tanpaeditor.replace("${" + subString + "}", field);

                    } else if (objectType.equals("FIELD")) {

                        if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("TEXT"))) {
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-"));
                        } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("MINITEXT"))) {
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-"));
                        } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("LONGTEXT"))) {
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-"));
                        } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.contains("SELECT"))) {
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-"));
                        } else if (objectClass.equals("SYSPROP")) {
                            String value = "-";
                            try {
                                value = PstSystemProperty.getValueByName(objectStatusField);
                            } catch (Exception exc) {
                                System.out.println(exc.toString());
                            }
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + value);
                        } else if (objectClass.equals("COMPANY")) {
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashCompany.get(objectStatusField));
                        } else if (objectClass.equals("CONTACT")) {
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashContact.get(objectStatusField));
                        } else if (objectClass.equals("CONTACT_FAMILY")) {
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashContactFamily.get(objectStatusField));
                        } else if (objectClass.equals("SELECTION")) {
                            if ((objectStatusField.equals("CONTACT"))) {

                                Vector con_key = new Vector(1, 1);
                                Vector con_val = new Vector(1, 1);
                                Vector listContact = PstContactList.list(0, 0, "", "");
                                if (listContact != null && listContact.size() > 0) {
                                    for (int i = 0; i < listContact.size(); i++) {
                                        ContactList contactList = (ContactList) listContact.get(i);
                                        con_key.add(contactList.getPersonName());
                                        con_val.add(String.valueOf(contactList.getOID()));
                                    }
                                }
                                String add = "<input type='hidden' name='FRM_FIELD_OBJECT_ID' value='" + oidEmpDocField + "'>"
                                        + "<input type='hidden' name='FRM_FIELD_OBJECT_NAME' value='" + objectName + "'>"
                                        + "<input type='hidden' name='FRM_FIELD_CLASS_NAME' value='" + objectClass + "'>"
                                        + "<input type='hidden' name='FRM_FIELD_OBJECT_TYPE' value='0'>"
                                        + ControlCombo.draw("FRM_FIELD_VALUE", null, "" + hlistEmpDocField.get(objectName), con_val, con_key, "class='select2'");
                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                            }
                        } else if (objectClass.equals("KREDIT")) {
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashPinjaman.get(objectStatusField));
                        } else if (objectClass.equals("DOCUMENT")){
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashEmpDoc.get(objectStatusField));
                        }
                    } else if (objectType.equals("RP")) {
                        if (objectClass.equals("KREDIT")) {
                            String value = "" + hashPinjaman.get(objectStatusField);
                            String angka = "";
                            try {
                                angka = Formater.formatNumber(Double.valueOf(value), "");
                            } catch (Exception exc) {
                                System.out.println("Exception at RP");
                            }
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "Rp." + angka + ",-");
                        }
                    } else if (objectType.equals("TERBILANGRP")) {
                        if (objectClass.equals("KREDIT")) {
                            String value = "" + hashPinjaman.get(objectStatusField);
                            double nilai = 0;
                            try {
                                nilai = Double.valueOf("" + hashPinjaman.get(objectStatusField));
                            } catch (Exception exc) {
                                System.out.println(exc.toString());
                            }

                            long longTotal = (long) (nilai);
                            String output = "";
                            if (longTotal == 0) {
                                output = "Nol rupiah";
                            } else if (longTotal < 0) {
                                longTotal *= -1;
                                ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                String con = "Minus " + convert.getText() + " rupiah";
                                output = con.substring(0, 1).toUpperCase() + con.substring(1);
                            } else {
                                ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                String con = convert.getText() + " rupiah";
                                output = con.substring(0, 1).toUpperCase() + con.substring(1);
                            }

                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + output);

                        }
                    } else if (objectType.equals("TERBILANG")) {
                        if (objectClass.equals("KREDIT")) {
                            String value = "" + hashPinjaman.get(objectStatusField);
                            double nilai = 0;
                            try {
                                nilai = Double.valueOf("" + hashPinjaman.get(objectStatusField));
                            } catch (Exception exc) {
                                System.out.println(exc.toString());
                            }

                            long longTotal = (long) (nilai);
                            String output = "";
                            if (longTotal == 0) {
                                output = "Nol ";
                            } else if (longTotal < 0) {
                                longTotal *= -1;
                                ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                String con = "Minus " + convert.getText();
                                output = con.substring(0, 1).toUpperCase() + con.substring(1);
                            } else {
                                ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                String con = convert.getText();
                                output = con.substring(0, 1).toUpperCase() + con.substring(1);
                            }

                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + output);

                        }
                    } else if (objectType.equals("TANGGAL")) {
                        if (objectClass.equals("KREDIT")) {
                            String dateShow = "-";
                            if (hashPinjaman.get(objectStatusField) != null) {
                                SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                String dateInString = "" + hashPinjaman.get(objectStatusField);

                                SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
                                try {
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                    Date dateX = formatterDateSql.parse(dateInString);
                                    String strDate = sdf.format(dateX);
                                    String strYear = strDate.substring(0, 4);
                                    String strMonth = strDate.substring(5, 7);
                                    if (strMonth.length() > 0) {
                                        switch (Integer.valueOf(strMonth)) {
                                            case 1:
                                                strMonth = "Januari";
                                                break;
                                            case 2:
                                                strMonth = "Februari";
                                                break;
                                            case 3:
                                                strMonth = "Maret";
                                                break;
                                            case 4:
                                                strMonth = "April";
                                                break;
                                            case 5:
                                                strMonth = "Mei";
                                                break;
                                            case 6:
                                                strMonth = "Juni";
                                                break;
                                            case 7:
                                                strMonth = "Juli";
                                                break;
                                            case 8:
                                                strMonth = "Agustus";
                                                break;
                                            case 9:
                                                strMonth = "September";
                                                break;
                                            case 10:
                                                strMonth = "Oktober";
                                                break;
                                            case 11:
                                                strMonth = "November";
                                                break;
                                            case 12:
                                                strMonth = "Desember";
                                                break;
                                        }
                                    }
                                    String strDay = strDate.substring(8, 10);
                                    dateShow = strDay + " " + strMonth + " " + strYear;  ////formatterDate.format(dateX);

                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }

                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + dateShow);
                        }
                    } else if (objectType.equals("HARI")) {
                        String[] stDays = {
                            "Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"
                        };
                        if (objectClass.equals("KREDIT")) {
                            String day = "-";
                            try {
                                String value = "" + hashPinjaman.get(objectStatusField);
                                DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                                Date result = df.parse(value);
                                Calendar objCal = Calendar.getInstance();
                                objCal.setTime(result);
                                day = stDays[objCal.get(Calendar.DAY_OF_WEEK) - 1];
                            } catch (Exception exc) {
                                System.out.println("Exception on PENGAJUAN_DAY");
                            }
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + day);
                        }
                    } else if (objectType.equals("DD")) {
                        if (objectClass.equals("KREDIT")) {
                            String strDay = "-";
                            if (hashPinjaman.get(objectStatusField) != null) {
                                SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                String dateInString = "" + hashPinjaman.get(objectStatusField);

                                SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
                                try {
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                    Date dateX = formatterDateSql.parse(dateInString);
                                    String strDate = sdf.format(dateX);
                                    strDay = strDate.substring(8, 10);

                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + strDay);
                        }
                    } else if (objectType.equals("DD_TERBILANG")) {
                        if (objectClass.equals("KREDIT")) {
                            String strDay = "-";
                            if (hashPinjaman.get(objectStatusField) != null) {
                                SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                String dateInString = "" + hashPinjaman.get(objectStatusField);

                                SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
                                try {
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                    Date dateX = formatterDateSql.parse(dateInString);
                                    String strDate = sdf.format(dateX);
                                    strDay = strDate.substring(8, 10);

                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }

                            double nilai = 0;
                            try {
                                nilai = Double.valueOf(strDay);
                            } catch (Exception exc) {
                                System.out.println(exc.toString());
                            }

                            long longTotal = (long) (nilai);
                            String output = "";
                            if (longTotal == 0) {
                                output = "Nol ";
                            } else if (longTotal < 0) {
                                longTotal *= -1;
                                ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                String con = "Minus " + convert.getText();
                                output = con.substring(0, 1).toUpperCase() + con.substring(1);
                            } else {
                                ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                String con = convert.getText();
                                output = con.substring(0, 1).toUpperCase() + con.substring(1);
                            }

                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + output);
                        }
                    }

                }
                stringResidual = stringResidual.substring(endPosition, stringResidual.length());
                objectDocumentDetail.setStartPosition(startPosition);
                objectDocumentDetail.setEndPosition(endPosition);
                objectDocumentDetail.setText(subString);
                vNewString.add(objectDocumentDetail);

                //mengecek apakah masih ada sisa
                startPosition = stringResidual.indexOf("${") + "${".length();
                endPosition = stringResidual.indexOf("}", startPosition);
                index++;
            } while (endPosition > 0);
        } catch (Exception e) {
        }

        String pathImage = "";

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        String[] arrayTemplate = empDocMasterTemplateText.split("<div class=\"document-editor\">");
        String htmlHead = "<!DOCTYPE html><html><head></head><body> ";
        String htmlClose = "</body></html> ";
        String htmlFinish = htmlHead + empDocMasterTemplateText + htmlClose;
        try {
            StyleSheet st = new StyleSheet();
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HeaderFooter event = new HeaderFooter();
            writer.setPageEvent(event);
            document.open();
            for (int i = 1; i < arrayTemplate.length; i++) {
                String html = htmlHead + "<div class=\"document-editor\">" + arrayTemplate[i] + htmlClose;
                ElementList list = XMLWorkerHelper.parseToElementList(html, "");
                for (Element e : list) {
                    document.add(e);
                }
                document.newPage();
            }
            //XMLWorkerHelper worker = XMLWorkerHelper.getInstance();
            //worker.parseXHtml(writer, document, new StringReader(htmlFinish));
            document.close();
            response.setContentType("application/pdf");
            response.setContentLength(baos.size());
            ServletOutputStream out = response.getOutputStream();
            baos.writeTo(out);
            out.flush();
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        // closing the document
//        document.close();
        // we have written the pdfstream to a ByteArrayOutputStream,
        // now we are going to write this outputStream to the ServletOutputStream       
//        response.setContentType("application/pdf");
//        response.setContentLength(baos.size());
//        ServletOutputStream out = response.getOutputStream();
//        baos.writeTo(out);
//        out.flush();
    }

    public class HeaderFooter extends PdfPageEventHelper {

        protected ElementList header;
        protected ElementList footer;

        public HeaderFooter() throws IOException {
            header = XMLWorkerHelper.parseToElementList(HEADER, null);
            footer = XMLWorkerHelper.parseToElementList(FOOTER, null);
        }

        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            try {
                ColumnText ct = new ColumnText(writer.getDirectContent());
                ct.setSimpleColumn(new Rectangle(0, 0, 559, 850));
                for (Element e : header) {
                    ct.addElement(e);
                }
                ct.go();
                ct.setSimpleColumn(new Rectangle(36, 10, 559, 60));
                for (Element e : footer) {
                    ct.addElement(e);
                }
                ct.go();
            } catch (DocumentException de) {
                throw new ExceptionConverter(de);
            }
        }
    }
}
