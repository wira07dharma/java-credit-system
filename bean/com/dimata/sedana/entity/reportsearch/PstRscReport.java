/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.reportsearch;

import com.dimata.aiso.db.DBException;
import com.dimata.aiso.db.DBHandler;
import com.dimata.aiso.db.DBResultSet;
import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.pos.db.I_DBInterface;
import com.dimata.pos.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Adi
 */
public class PstRscReport extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
  
    public String getQueryTabungan(RscReport rscReport) {
        String wDate = "(TB.`TDATE` >= '" + rscReport.getStartDate() + "' AND '" + rscReport.getEndDate() + "' >= TB.`TDATE`)";
        String wTabunganType = "";
        String wNoRekening = "";
        String wNoAnggota = "";
        for (int i = 0; i < rscReport.getTabungan().size(); i++) {
            if (i != 0) {
                wTabunganType += "AND ";
            }
            wTabunganType += " dt.`JENIS_TABUNGAN_ID` = " + rscReport.getTabungan().get(i) + " ";
        }

        if (rscReport.getNoRekeningStart() != 0 && rscReport.getNoRekeningEnd() != 0) {
            wNoRekening = " AND (CAST(a.`NO_REKENING` AS UNSIGNED) >= " + rscReport.getNoRekeningStart() + " AND " + rscReport.getNoRekeningEnd() + " >= CAST(a.`CONTACT_CODE` AS UNSIGNED)) ";
        } else if (rscReport.getNoRekeningStart() != 0) {
            wNoRekening = "AND a.`NO_REKENING` = '" + rscReport.getNoRekeningStart() + "' ";
        }

        if (rscReport.getNoAnggotaStart() != 0 && rscReport.getNoAnggotaEnd() != 0) {
            wNoAnggota = " AND (CAST(a.`CONTACT_CODE` AS UNSIGNED) >= " + rscReport.getNoAnggotaStart() + " AND " + rscReport.getNoAnggotaEnd() + " >= CAST(a.`CONTACT_CODE` AS UNSIGNED)) ";
        } else if (rscReport.getNoAnggotaStart() != 0) {
            wNoAnggota = "AND a.`CONTACT_CODE` = '" + rscReport.getNoAnggotaStart() + "' ";
        }

        wTabunganType = (wTabunganType.equals("") ? "" : "AND (" + wTabunganType + ")");
        String query = "SELECT * FROM ("
                + " SELECT t.ID_ANGGOTA, t.`TANGGAL` AS TDATE, 0 AS DEBET, `JUMLAH` AS KREDIT, s.`NAMA_SIMPANAN`  AS KETERANGAN FROM aiso_data_tabungan t "
                + " INNER JOIN aiso_jenis_simpanan s ON s.`ID_JENIS_SIMPANAN` = t.`ID_JENIS_SIMPANAN` "
                + " WHERE  t.ID_ANGGOTA  "
                + " UNION "
                + " SELECT t.ID_ANGGOTA, t.`TANGGAL_TRANSAKSI` AS TDATE, `JUMLAH_TRANSAKSI` AS DEBET, 0 AS KREDIT, t.`JENIS_TRANSAKSI`  AS KETERANGAN FROM aiso_proses_transaksi t "
                + " INNER JOIN aiso_jenis_transaksi p ON p.`JENIS_TRANSAKSI_ID` = t.`JENIS_TRANSAKSI` "
                + " WHERE  t.ID_ANGGOTA  ) AS TB   "
                + " WHERE " + wDate + " "
                + wTabunganType
                + wNoAnggota
                + wNoRekening
                + " ORDER BY ID_ANGGOTA, TDATE";

        return query;
    }

    public Vector<ReportTabunganValue> getReportTabungan(RscReport rscReport) throws SQLException, com.dimata.common.db.DBException {
        ReportTabunganValue rtv = new ReportTabunganValue();
        DBResultSet dbrs = null;
        Vector lists = new Vector();
        String sql = getQueryTabungan(rscReport);
        try {
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            long idAgt = -1;
            while (rs.next()) {
              if (idAgt != rs.getLong("ID_ANGGOTA")) {
                lists.add(rtv);
                rtv = new ReportTabunganValue();
                idAgt = rs.getLong("ID_ANGGOTA");
                ContactList cl = PstContactList.fetchExc(idAgt);
                rtv.setAlamat(cl.getHomeAddr());
                rtv.setJenisTabungan("");
                rtv.setKodeAnggota(cl.getContactCode());
                rtv.setKodeRekening("");
                rtv.setNamaAnggota(cl.getPersonName());
              }
              ReportTabunganValue.ReportRow rr = new ReportTabunganValue.ReportRow();
              rr.setDebit(rs.getLong("DEBET"));
              rr.setKredit(rs.getLong("KREDIT"));
              rr.setSaldo(Math.abs(rs.getLong("DEBET")-rs.getLong("KREDIT")));
              rr.setDate(rs.getDate("TDATE"));
              rr.setKeterangan(rs.getString("KETERANGAN"));
            }
            lists.add(rtv);
        } catch (DBException ex) {
            Logger.getLogger(PstRscReport.class.getName()).log(Level.SEVERE, null, ex);
        }
        return lists;
    }
  
  public ReportKolektabilitas getReportKolektabilitas(RscReport rscReport) {
    String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
    ReportKolektabilitas rk = new ReportKolektabilitas();
    rk.setDateRange("25 Maret 2017 s/d 17 Juni 2017");
    rk.setJenisKredit("Pertanian , Peternakan");
    rk.setKelompok("Anggota Koperasi , "+namaNasabah+" Umum");
    rk.setSumberDana("Semua");
    
    ReportKolektabilitas.ReportRow rr = new ReportKolektabilitas.ReportRow();
    rr.setKolektibilitas("K1");
    rr.setNoRekening("201705067");
    rr.setNamaNasabah("Made Lancar");
    rr.setJangkaWaktu("1/20");
    rr.setHariTunggakanPokok("0");
    rr.setHariTunggakanBunga("0");
    rr.setKreditPokok("10.000.000,00");
    rr.setKreditBunga("500.000,00");
    rr.setTuggakanPokok("0");
    rr.setTunggakanBunga("0");
    rr.setTotal("0");
    rk.addReports(rr);
    
    ReportKolektabilitas.ReportRow rr1 = new ReportKolektabilitas.ReportRow();
    rr1.setKolektibilitas("K2");
    rr1.setNoRekening("201704059");
    rr1.setNamaNasabah("Luh Sari");
    rr1.setJangkaWaktu("1/20");
    rr1.setHariTunggakanPokok("0");
    rr1.setHariTunggakanBunga("0");
    rr1.setKreditPokok("12.000.000,00");
    rr1.setKreditBunga("600.000,00");
    rr1.setTuggakanPokok("0");
    rr1.setTunggakanBunga("0");
    rr1.setTotal("0");
    rk.addReports(rr1);
    
    ReportKolektabilitas.ReportRow rr2 = new ReportKolektabilitas.ReportRow();
    rr2.setKolektibilitas("K3");
    rr2.setNoRekening("201508105");
    rr2.setNamaNasabah("Wayan Kari");
    rr2.setJangkaWaktu("2/20");
    rr2.setHariTunggakanPokok("30");
    rr2.setHariTunggakanBunga("0");
    rr2.setKreditPokok("10.000.000,00");
    rr2.setKreditBunga("500.000,00");
    rr2.setTuggakanPokok("0");
    rr2.setTunggakanBunga("200.000,00");
    rr2.setTotal("200.000,00");
    rk.addReports(rr2);
    
    rk.setTotalKreditPokok("32.000.000,00");
    rk.setTotalKreditBunga("1.600.000,00");
    rk.setTotalTunggakanPokok("0,00");
    rk.setTotalTunggakanBunga("200.000,00");
    rk.setTotalTunggakanTotal("200.000,00");
    
    return rk;
  }
  
  public ReportRangkumanKolektabilitas getReportRangkumanKolektibilitas(RscReport rscReport) {
    String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
    ReportRangkumanKolektabilitas rk = new ReportRangkumanKolektabilitas();
    rk.setDateRange("25 Maret 2017 s/d 17 Juni 2017");
    rk.setJenisKredit("Pertanian , Peternakan");
    rk.setKelompok("Anggota Koperasi , "+namaNasabah+" Umum");
    rk.setSumberDana("Semua");
    
    ReportRangkumanKolektabilitas.ReportRow rr = new ReportRangkumanKolektabilitas.ReportRow();
    rr.setKode("K1");
    rr.setPersentase("58%");
    rr.setJmlNasabah("200");
    rr.setJmlKredit("150,000,000");
    rr.setKreditPokok("10.000.000,00");
    rr.setKreditBunga("500.000,00");
    rr.setTuggakanPokok("0");
    rr.setTunggakanBunga("0");
    rr.setTunggakanTotal("0");
    rk.addReports(rr);
    
    rk.setTotalKreditPokok("32.000.000,00");
    rk.setTotalKreditBunga("1.600.000,00");
    rk.setTotalTunggakanPokok("0,00");
    rk.setTotalTunggakanBunga("200.000,00");
    rk.setTotalTunggakanTotal("200.000,00");
    rk.setTotalJumlahNasabah("3.000.000");
    rk.setTotalJumlahKredit("9.000.000.000");
    
    return rk;
  }

    @Override
    public int getFieldSize() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public String getTableName() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public String[] getFieldNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public int[] getFieldTypes() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public String getPersistentName() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public long fetchExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public long updateExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public long deleteExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public long insertExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }
  
  
}
