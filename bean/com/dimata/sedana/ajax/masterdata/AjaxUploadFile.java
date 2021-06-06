/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.masterdata;

import com.dimata.aiso.entity.masterdata.Company;
import com.dimata.aiso.entity.masterdata.PstCompany;
import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import java.io.FileOutputStream;
/**
 *
 * @author Dimata 007
 */
public class AjaxUploadFile extends HttpServlet {

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
        int status = 0;
        String message = "";
        String root = FRMQueryString.requestString(request, "SEND_ROOT");
        String location = PstSystemProperty.getValueByName("PHOTO_LOCATION_PATH");// FRMQueryString.requestString(request, "SEND_LOCATION");
        String compLocation = PstSystemProperty.getValueByName("COMP_IMAGE_PATH");
        String base64 = FRMQueryString.requestString(request, "BASE64");
        long idAnggota = FRMQueryString.requestLong(request, "anggota_oid");
        long oidCompany = FRMQueryString.requestLong(request, "company_oid");

        System.out.println("lokasi simpan " + location);
        if ((idAnggota != 0  && !location.equals("")) || (oidCompany != 0 && !compLocation.equals(""))) {
            System.out.println("proses 1");
            if (!base64.equals("")){
                try {
                    String base64Image = base64.split(",")[1];
                    byte[] imageBytes = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64Image);
                    if (idAnggota != 0){
                        Anggota a = PstAnggota.fetchExc(idAnggota);
                        File lastFoto = new File(location + File.separator + a.getFotoAnggota());
                        String tgl = Formater.formatDate(new Date(), "yyyyMMdd_HHmmss");
                        String namaFoto = "" + idAnggota + "_" + tgl + ".png";
                        System.out.println("Simpan 2: cek data 3");
                        try {
                            FileOutputStream outputStream = new FileOutputStream(location + File.separator+namaFoto); 
                            outputStream.write(imageBytes);
                            outputStream.flush();
                            outputStream.close();
                            System.out.println("Simpan foto");
                            a.setFotoAnggota(namaFoto);
                            PstAnggota.updateExc(a);
                            status = 1;
                            lastFoto.delete();
                            System.out.println("Hapus foto");
                        } catch (Exception ex) {
                            System.out.println("eror " + ex);
                        }

                    }
                } catch (Exception exc){}
                
            } else if (ServletFileUpload.isMultipartContent(request)) {
                System.out.println("Simpan 2");
                try {
                    List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
                    for (FileItem item : multiparts) {
                        if (item.getSize() > 0) {
                            if (!item.isFormField()) {
                                if (idAnggota != 0){
                                    System.out.println("Simpan 2: cek data");
                                    Anggota a = PstAnggota.fetchExc(idAnggota);
                                    File lastFoto = new File(location + File.separator + a.getFotoAnggota());
                                    String tgl = Formater.formatDate(new Date(), "yyyyMMdd_HHmmss");
                                    String typeFile = item.getName().substring(item.getName().lastIndexOf("."), item.getName().length());
                                    String namaFoto = "" + idAnggota + "_" + tgl + typeFile;
                                    System.out.println("Simpan 2: cek data 3");
                                    if (typeFile.equals(".jpg") || typeFile.equals(".JPG") || typeFile.equals(".jpeg") || typeFile.equals(".JPEG") 
                                            || typeFile.equals(".png") || typeFile.equals(".PNG")) {
                                        try {
                                            item.write(new File(location + File.separator + namaFoto));
                                            System.out.println("Simpan foto");
                                            a.setFotoAnggota(namaFoto);
                                            PstAnggota.updateExc(a);
                                            status = 1;
                                            lastFoto.delete();
                                            System.out.println("Hapus foto");
                                        } catch (Exception ex) {
                                            System.out.println("eror " + ex);
                                        }
                                    }
                                } else {
                                    System.out.println("Simpan 2: cek data");
                                    Company a = PstCompany.fetchExc(oidCompany);
                                    File lastFoto = new File(compLocation + File.separator + a.getCompImage());
                                    String tgl = Formater.formatDate(new Date(), "yyyyMMdd_HHmmss");
                                    String typeFile = item.getName().substring(item.getName().lastIndexOf("."), item.getName().length());
                                    String namaFoto = "" + oidCompany + "_" + tgl + typeFile;
                                    System.out.println("Simpan 2: cek data 3");
                                    if (typeFile.equals(".jpg") || typeFile.equals(".JPG") || typeFile.equals(".jpeg") || typeFile.equals(".JPEG") 
                                            || typeFile.equals(".png") || typeFile.equals(".PNG")) {
                                        try {
                                            item.write(new File(compLocation + File.separator + namaFoto));
                                            System.out.println("Simpan foto");
                                            a.setCompImage(namaFoto);
                                            PstCompany.updateExc(a);
                                            status = 1;
                                            lastFoto.delete();
                                            System.out.println("Hapus foto");
                                        } catch (Exception ex) {
                                            System.out.println("eror " + ex);
                                        }
                                    }
                                }
                            }
                        } else {
                            message += "Foto kosong (ukuran foto 0).";
                            System.out.println(message);
                            request.setAttribute("RETURN_MESSAGE", " " + message);
                        }
                    }

                    if (status == 1) {
                        message += "Foto berhasil disimpan.";
                        System.out.println(message);
                        request.setAttribute("RETURN_MESSAGE", " " + message);
                    } else {
                        message += "Foto gagal disimpan.";
                        System.out.println(message);
                        request.setAttribute("RETURN_MESSAGE", " " + message);
                    }
                } catch (Exception ex) {
                    message += "Fail to save file due " + ex;
                    System.out.println(message);
                    request.setAttribute("RETURN_MESSAGE", "File Upload Failed due to " + ex);
                }
            } else {
                message += "Sorry this Servlet only handles file upload request.";
                System.out.println(message);
                request.setAttribute("RETURN_MESSAGE", " " + message);
            }
        } else {
            if (root.equals("")) {
                message += "Approot is empty.";
                System.out.println(message);
                request.setAttribute("RETURN_MESSAGE", " " + message);
            }
            if (location.equals("")) {
                message += "Path location is empty.";
                System.out.println(message);
                request.setAttribute("RETURN_MESSAGE", " " + message);
            }
            if (idAnggota == 0) {
                message += "Person ID is empty.";
                System.out.println(message);
                request.setAttribute("RETURN_MESSAGE", " " + message);
            }
        }
        if (idAnggota != 0){
            response.sendRedirect(root + "/masterdata/anggota/anggota_edit.jsp?status=" + status + "&anggota_oid=" + idAnggota + "&message=" + message);
        } else {
            response.sendRedirect(root + "/sedana/masterbumdes/company_edit.jsp?status=" + status + "&message=" + message+"&command="+Command.EDIT);
        }
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
