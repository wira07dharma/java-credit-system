/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.session;

import com.dimata.sedana.entity.kredit.Angsuran;
import com.dimata.sedana.entity.kredit.AngsuranPayment;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstAngsuran;
import com.dimata.sedana.entity.kredit.PstAngsuranPayment;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.util.Formater;
import com.dimata.util.blob.TextLoader;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

/**
 *
 * @author gndiw
 */
public class SessUploadPayment {
    
    public static boolean running = false;
	
    public static double countTotalData = 0.0;

    public static double currentProgress = 0.0;

    public static String table = "";
    
    
    public static void startUpload(ServletConfig config,HttpServletRequest request,HttpServletResponse response, JspWriter output, int typeTemp) {
        try {
            final List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
            Runnable r = new Runnable() {
                public void run() {
                    running = true;
                    while (running) {
                        currentProgress = 0;
                        String html = "";
                        int NUM_HEADER = 2;
                        int NUM_CELL = 0;
                        try {
                            
                            SessUploadPayment sessUploadPayment = new SessUploadPayment();
                            
                            for (FileItem item : multiparts) {
                                if (!item.isFormField()) {
                                    TextLoader uploader = new TextLoader();
                                    InputStream inStream = item.getInputStream();
                                    POIFSFileSystem fs = new POIFSFileSystem(inStream);

                                    HSSFWorkbook wb = new HSSFWorkbook(fs);

                                    int r = 0;
                                    int col = 0;
                                    HSSFSheet sheet = (HSSFSheet) wb.getSheetAt(0);
                                    int rows = sheet.getPhysicalNumberOfRows();
                                    countTotalData = rows - 1;
                                    int start = 1;
                                    String barcode = "";
                                    
                                    for (r = start; r < rows; r++) {
                                        if (r != 0) {
                                            currentProgress = sessUploadPayment.getCurrentProgress() + 1;
                                        }

                                        try {
                                            HSSFRow row = sheet.getRow(r);
                                            int cells = 0;
                                            //if number of cell is static
                                            if (NUM_CELL > 0) {
                                                cells = NUM_CELL;
                                            } else { //number of cell is dinamyc
                                                cells = row.getPhysicalNumberOfCells();
                                            }
                                            NUM_CELL = cells;
                                            html += "<tr>";
                                            int caseValue = 0;
                                            int errCell = 0;

                                            String noPk = "";
                                            String tanggalBayar = "";
                                            double jumlahBayar = 0;

                                            for (int c = 0; c < cells; c++) {
                                                HSSFCell cell = row.getCell(c);
                                                String value = null;
                                                boolean check = false;
                                                col = c;
                                                if (cell != null) {
                                                    if (c==0){
                                                        value = String.valueOf(cell.getStringCellValue() != null ? cell.getStringCellValue() : "");
                                                        noPk = value;
                                                    }
                                                    if (c==1){
                                                        value = String.valueOf(cell.getStringCellValue() != null ? cell.getStringCellValue() : "");
                                                        tanggalBayar = value;
                                                    }
                                                    if (c==2){
                                                        try {
                                                            value = Formater.formatNumber(cell.getNumericCellValue(), "###");
                                                            jumlahBayar = Double.valueOf(value);
                                                        } catch (Exception exc){}
                                                    }
                                                } else {
                                                    value = "";
                                                }

                                                

                                            }

                                            
                                            String wherePinjaman = PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]+"='"+noPk+"'";
                                            Vector listPinjaman = PstPinjaman.list(0, 0, wherePinjaman, "");
                                            if (listPinjaman.size()>0){
                                                Pinjaman pinjaman = (Pinjaman) listPinjaman.get(0);

                                                /*ini ngecek angsuran pertama*/
//                                                String whereJadwalAngsuranAll = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+" = "+pinjaman.getOID();
//                                                Vector listJadwalAll = PstJadwalAngsuran.list(0, 0, whereJadwalAngsuranAll, "TANGGAL_ANGSURAN");
//                                                if (listJadwalAll.size()>0){
//                                                    JadwalAngsuran jadwalAngsuran = (JadwalAngsuran) listJadwalAll.get(0);
//                                                    if (jadwalAngsuran.getSisa()>0){
//                                                        String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_KREDIT_PEMBAYARAN_ANGSURAN, Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT, pinjaman.getTglRealisasi());
//                                                        long idTransaksi = 0;
//                                                        Transaksi transaksi = new Transaksi();
//                                                        transaksi.setTanggalTransaksi(pinjaman.getTglRealisasi());
//                                                        transaksi.setKodeBuktiTransaksi(nomorTransaksi);
//                                                        transaksi.setIdAnggota(pinjaman.getAnggotaId());
//                                                        transaksi.setTellerShiftId(504404738974393115L);
//                                                        transaksi.setKeterangan("Pembayaran angsuran kredit");
//                                                        transaksi.setPinjamanId(pinjaman.getOID());
//                                                        transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_OPEN);
//                                                        transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
//                                                        transaksi.setUsecaseType(Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT);
//                                                        try {
//                                                            idTransaksi = PstTransaksi.insertExc(transaksi);
//                                                        } catch (Exception ex) {
//                                                        }
//                                                        
//                                                        AngsuranPayment ap = new AngsuranPayment();
//                                                        ap.setPaymentSystemId(504404634093158004L);
//                                                        ap.setJumlah(jumlahBayar);
//                                                        ap.setStatus(AngsuranPayment.STATUS_DOC_CLOSE);
//                                                        ap.setTransaksiId(idTransaksi);
//                                                        try {
//                                                            long idPayment = PstAngsuranPayment.insertExc(ap);
//                                                        } catch (Exception exc){}
//                                                        
//                                                        Angsuran a = new Angsuran();
//                                                        a.setJadwalAngsuranId(jadwalAngsuran.getOID());
//                                                        a.setJumlahAngsuran(jadwalAngsuran.getSisa());
//                                                        a.setTransaksiId(idTransaksi);
//                                                        try {
//                                                            PstAngsuran.insertExc(a);
//                                                            jadwalAngsuran.setSisa(0);
//                                                            PstJadwalAngsuran.updateExc(jadwalAngsuran);
//                                                        } catch (Exception ex) {
//                                                        }
//                                                        
//                                                    }
//                                                }
                                                
                                                
                                                Date tglBayar = new Date();
                                                try {
                                                    tglBayar = Formater.formatDate(tanggalBayar, "yyyy-MM-dd");
                                                } catch (Exception e) {

                                                }
                                                String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_KREDIT_PEMBAYARAN_ANGSURAN, Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT, tglBayar);
                                                long idTransaksi = 0;
                                                Transaksi transaksi = new Transaksi();
                                                transaksi.setTanggalTransaksi(tglBayar);
                                                transaksi.setKodeBuktiTransaksi(nomorTransaksi);
                                                transaksi.setIdAnggota(pinjaman.getAnggotaId());
                                                transaksi.setTellerShiftId(504404738974393115L);
                                                transaksi.setKeterangan("Pembayaran angsuran kredit");
                                                transaksi.setPinjamanId(pinjaman.getOID());
                                                transaksi.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_OPEN);
                                                transaksi.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
                                                transaksi.setUsecaseType(Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT);
                                                try {
                                                    idTransaksi = PstTransaksi.insertExc(transaksi);
                                                } catch (Exception ex) {
                                                }
                                                
                                                 AngsuranPayment ap = new AngsuranPayment();
                                                ap.setPaymentSystemId(504404634093158004L);
                                                ap.setJumlah(jumlahBayar);
                                                ap.setStatus(AngsuranPayment.STATUS_DOC_CLOSE);
                                                ap.setTransaksiId(idTransaksi);
                                                try {
                                                    long idPayment = PstAngsuranPayment.insertExc(ap);
                                                } catch (Exception exc){}

                                                
                                                
                                                String whereJadwalAngsuran = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_SISA]+" > 0 AND "
                                                        +PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+" = "+pinjaman.getOID();
                                                Vector listJadwal = PstJadwalAngsuran.list(0, 0, whereJadwalAngsuran, "TANGGAL_ANGSURAN");
                                                for (int x= 0; x<listJadwal.size();x++){
                                                    JadwalAngsuran jadwalAngsuran = (JadwalAngsuran) listJadwal.get(x);
                                                    long idAngsuran = 0;
                                                    Angsuran a = new Angsuran();
                                                    if (jumlahBayar > jadwalAngsuran.getSisa()){
                                                        
                                                        a.setJadwalAngsuranId(jadwalAngsuran.getOID());
                                                        a.setJumlahAngsuran(jadwalAngsuran.getSisa());
                                                        a.setTransaksiId(idTransaksi);
                                                        try {
                                                            jumlahBayar = (jumlahBayar - jadwalAngsuran.getSisa());
                                                            idAngsuran = PstAngsuran.insertExc(a);
                                                            jadwalAngsuran.setSisa(0);
                                                            PstJadwalAngsuran.updateExc(jadwalAngsuran);
                                                            
                                                        } catch (Exception ex) {
                                                        }
                                                    } else if (jumlahBayar < jadwalAngsuran.getSisa()){
                                                        a.setJadwalAngsuranId(jadwalAngsuran.getOID());
                                                        a.setJumlahAngsuran(jumlahBayar);
                                                        a.setTransaksiId(idTransaksi);
                                                        try {
                                                            idAngsuran = PstAngsuran.insertExc(a);
                                                            jadwalAngsuran.setSisa(jadwalAngsuran.getSisa() - jumlahBayar);
                                                            PstJadwalAngsuran.updateExc(jadwalAngsuran);
                                                        } catch (Exception ex) {
                                                        }
                                                        
                                                        
                                                        break;
                                                    } else if (jumlahBayar == jadwalAngsuran.getSisa()){
                                                        a.setJadwalAngsuranId(jadwalAngsuran.getOID());
                                                        a.setJumlahAngsuran(jumlahBayar);
                                                        a.setTransaksiId(idTransaksi);
                                                        try {
                                                            idAngsuran = PstAngsuran.insertExc(a);
                                                            jadwalAngsuran.setSisa(0);
                                                            PstJadwalAngsuran.updateExc(jadwalAngsuran);
                                                        } catch (Exception ex) {
                                                        }
                                                        
                                                        break;
                                                    }
                                                    
                                                }
                                                
                                            }


                                        } catch (Exception exc){} 
                                }
                            }
                            
                            
                                
                            }
                            table = html;
                            running = false;
                        } catch (Exception exc){running = false;}
                        
                    }
                }
            };
            Thread t = new Thread(r);
            t.start();
        } catch (Exception exc){
            
        }
    }
    
    public String getTable() {

        return table;

    }
	
	public double getTotalData() {

        return countTotalData;

    }
	
	public double getCurrentProgress() {

        return currentProgress;

    }
	
	public boolean isRunning(){
		return running;
	}
    
}
