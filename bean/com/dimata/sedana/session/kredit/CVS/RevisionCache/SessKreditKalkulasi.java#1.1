/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.session.kredit;

import com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.qdep.db.DBException;
import com.dimata.sedana.ajax.kredit.AjaxKredit;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.sedana.session.SessReportKredit;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Regen
 */
public class SessKreditKalkulasi {

  public static final int BASIS_BULAN = 12;
  public static final int BASIS_HARI = 360;
  public static final int BASIS_MINGGU = 48;
  public static final char ANGSURAN_INDEX = 'I';
  public static final char ANGSURAN_DATE = 'D';
  public static final char ANGSURAN_POKOK = 'P';
  public static final char ANGSURAN_POKOK_RAW = 'R';
  public static final char ANGSURAN_SISA_TOTAL = 'S';
  public static final char ANGSURAN_SISA_TOTAL_RAW = 'T';
  public static final char ANGSURAN_BUNGA = 'B';
  public static final char ANGSURAN_BESAR = 'N';
  public static final char ANGSURAN_BESAR_RAW = 'O';

  private ArrayList<HashMap<Character, Object>> table = new ArrayList<HashMap<Character, Object>>();
  public Double besarAngsuran = null; //Anuitas
  private static Calendar dateRealization = Calendar.getInstance();
  private static Calendar dateTempo = null;
  private static double biayaTotal = 0;
  private static double pengajuanTotal = 0;
  private static double pengajuanTotalCalc = 0; //generated
  private static int jangkaWaktuCalc = 0; //generated
  private static int frekuensiPokok = 0; //generated
  private static int tipeBunga = 0;
  private static double sukuBunga = 0;
  private static int jangkaWaktu = 0;
  private static boolean withMinimal = false;
  private static JenisKredit kredit = new JenisKredit();
  private static int tipeJadwal = Pinjaman.TIPE_JADWAL_BY_PERIOD;

  /**
   * @return the dateTempo
   */
  public Date getDateTempo() {
    return dateTempo.getTime();
  }

  /**
   * @param aDateTempo the dateTempo to set
   */
  public void setDateTempo(Date aDateTempo) {
    dateTempo = Calendar.getInstance();
    dateTempo.setTime(aDateTempo);
  }

  /**
   * @return the pengajuanTotalCalc
   */
  public double getPengajuanTotalCalc() {
    return pengajuanTotalCalc;
  }

  /**
   * @param aPengajuanTotalCalc the pengajuanTotalCalc to set
   */
  public void setPengajuanTotalCalc(double aPengajuanTotalCalc) {
    pengajuanTotalCalc = aPengajuanTotalCalc;
  }

  /**
   * @return the tipeBunga
   */
  public int getTipeBunga() {
    return tipeBunga;
  }

  /**
   * @param aTipeBunga the tipeBunga to set
   */
  public void setTipeBunga(int aTipeBunga) {
    tipeBunga = aTipeBunga;
  }

  /**
   * @return the bungaTahunan
   */
  public double getSukuBunga() {
    return sukuBunga;
  }

  /**
   * @param aBungaTahunan the bungaTahunan to set
   */
  public void setSukuBunga(double aBungaTahunan) {
    sukuBunga = aBungaTahunan;
  }

  /**
   * @return the jangkaWaktu
   */
  public int getJangkaWaktu() {
    return jangkaWaktu;
  }

  /**
   * @param aJangkaWaktu the jangkaWaktu to set
   */
  public void setJangkaWaktu(int aJangkaWaktu) {
    jangkaWaktu = aJangkaWaktu;
  }

  /**
   * @return the jangkaWaktuCalc
   */
  public int getJangkaWaktuCalc() {
    return jangkaWaktuCalc;
  }

  /**
   * @param aJangkaWaktuCalc the jangkaWaktuCalc to set
   */
  public void setJangkaWaktuCalc(int aJangkaWaktuCalc) {
    jangkaWaktuCalc = aJangkaWaktuCalc;
  }

  /**
   * @return the withMinimal
   */
  public boolean isWithMinimal() {
    return withMinimal;
  }

  /**
   * @param aWithMinimal the withMinimal to set
   */
  public void setWithMinimal(boolean aWithMinimal) {
    withMinimal = aWithMinimal;
  }

  public double calculateMinPengajuan() {
    setPengajuanTotalCalc(isWithMinimal() ? getPengajuanTotal() + biayaTotal : getPengajuanTotal());
    return getPengajuanTotalCalc();
  }

  /**
   * @return the biayaTotal
   */
  public double getBiayaTotal() {
    return biayaTotal;
  }

  /**
   * @param aBiayaTotal the biayaTotal to set
   */
  public void setBiayaTotal(double aBiayaTotal) {
    biayaTotal = aBiayaTotal;
  }

  /**
   * @return the pengajuanTotal
   */
  public double getPengajuanTotal() {
    return pengajuanTotal;
  }

  /**
   * @return the pengajuanTotal
   */
  public double getPengajuanFinal() {
    return pengajuanTotalCalc;
  }

  /**
   * @param aPengajuanTotal the pengajuanTotal to set
   */
  public void setPengajuanTotal(double aPengajuanTotal) {
    pengajuanTotal = aPengajuanTotal;
  }

  /**
   * @return the startDate
   */
  public Date getRealizationDate() {
    return dateRealization.getTime();
  }

  /**
   * @param aStartDate the startDate to set
   */
  public void setRealizationDate(Date aStartDate) {
    dateRealization = Calendar.getInstance();
    dateRealization.setTime(aStartDate);
  }

  /**
   * @return the kredit
   */
  public JenisKredit getKredit() {
    return kredit;
  }

  /**
   * @param aKredit the kredit to set
   */
  public void setKredit(JenisKredit aKredit) {
    kredit = aKredit;
  }

  public int getTIndex(int i) {
    return (Integer) table.get(i).get(ANGSURAN_INDEX);
  }

  public Date getTDate(int i) {
    return (Date) table.get(i).get(ANGSURAN_DATE);
  }

  public String[] getTDayName(int i) {
    Calendar c = Calendar.getInstance();
    c.setTime((Date) table.get(i).get(ANGSURAN_DATE));
    HashMap<Integer, String[]> dayNames = new HashMap<Integer, String[]>() {
      {
        put(Calendar.SUNDAY, new String[]{"Minggu", "Sunday"});
        put(Calendar.MONDAY, new String[]{"Senin", "Monday"});
        put(Calendar.TUESDAY, new String[]{"Selasa", "Tuesday"});
        put(Calendar.WEDNESDAY, new String[]{"Rabu", "Wednesday"});
        put(Calendar.THURSDAY, new String[]{"Kamis", "Thursday"});
        put(Calendar.FRIDAY, new String[]{"Jumat", "Friday"});
        put(Calendar.SATURDAY, new String[]{"Sabtu", "Saturday"});
      }
    };
    return dayNames.get(c.get(Calendar.DAY_OF_WEEK));
  }

  public double getTPokok(int i) {
    return (Double) table.get(i).get(ANGSURAN_POKOK);
  }

  public double getTPokokRaw(int i) {
    return (Double) table.get(i).get(ANGSURAN_POKOK_RAW);
  }

  public double getTTotalSisa(int i) {
    return (Double) table.get(i).get(ANGSURAN_SISA_TOTAL);
  }

  public double getTTotalSisaRaw(int i) {
    return (Double) table.get(i).get(ANGSURAN_SISA_TOTAL_RAW);
  }

  public double getTBunga(int i) {
    return (Double) table.get(i).get(ANGSURAN_BUNGA);
  }

  public double getTAngsuranBesar(int i) {
    return (Double) table.get(i).get(ANGSURAN_BESAR);
  }

  public double getTAngsuranBesarRaw(int i) {
    return (Double) table.get(i).get(ANGSURAN_BESAR_RAW);
  }

  public int getTSize() {
    return table.size();
  }

  public void tableAddRow(int index, Date date) {
    HashMap<Character, Object> row = new HashMap<Character, Object>();
    row.put(ANGSURAN_INDEX, index);
    row.put(ANGSURAN_DATE, date);
    table.add(row);
  }

  public void tableAddRow(int index, Date date, double pokok, double bunga, double besar, double sisa, double pokok_raw) {
    HashMap<Character, Object> row = new HashMap<Character, Object>();
    row.put(ANGSURAN_INDEX, index);
    row.put(ANGSURAN_DATE, date);
    row.put(ANGSURAN_POKOK, pokok);
    row.put(ANGSURAN_BUNGA, bunga);
    row.put(ANGSURAN_BESAR, besar);
    row.put(ANGSURAN_SISA_TOTAL, sisa);
    row.put(ANGSURAN_POKOK_RAW, pokok_raw);
    table.add(row);
  }

  public void tableModRow(HashMap<Character, Object> row, Object pokok, Object bunga, Object besar, Object sisa, Object pokok_raw, Object besar_raw, Object total_raw) {
    row.put(ANGSURAN_POKOK, pokok);
    row.put(ANGSURAN_BUNGA, bunga);
    row.put(ANGSURAN_BESAR, besar);
    row.put(ANGSURAN_SISA_TOTAL, sisa);
    row.put(ANGSURAN_POKOK_RAW, pokok_raw);
    row.put(ANGSURAN_BESAR_RAW, besar_raw);
    row.put(ANGSURAN_SISA_TOTAL_RAW, total_raw);
  }

  public double calcBunga() {
    int freq = getJangkaWaktuCalc();
    double bunga = (getSukuBunga() == 0 ? 0 : (getSukuBunga() / 100));
    switch (kredit.getTipeFrekuensiPokokLegacy()) {
        case I_Sedana.TIPE_KREDIT_HARIAN:
            bunga /=  BASIS_HARI;
            break;
        case I_Sedana.TIPE_KREDIT_MINGGUAN:
            bunga /=  BASIS_MINGGU;
            break;
        case I_Sedana.TIPE_KREDIT_MUSIMAN:
        case I_Sedana.TIPE_KREDIT_BULANAN:
            bunga /=  1;
            break;
    }
    /*
    boolean monthly = kredit.getTipeFrekuensiPokokLegacy()!= I_Sedana.TIPE_KREDIT_HARIAN
            && kredit.getTipeFrekuensiPokokLegacy() != I_Sedana.TIPE_KREDIT_MINGGUAN;
    bunga /= (monthly || freq == 0 ? 1 : BASIS_HARI);
    */
    return bunga;
  }

  public double getBunga(double totalPokok) {
    double b = 0;
    double bunga = calcBunga();
    
    boolean monthly = kredit.getTipeFrekuensiPokokLegacy()!= I_Sedana.TIPE_KREDIT_HARIAN
            && kredit.getTipeFrekuensiPokokLegacy() != I_Sedana.TIPE_KREDIT_MINGGUAN;
    int period = (monthly ? BASIS_BULAN : 1);

    switch (getTipeBunga()) {
      case Pinjaman.TIPE_BUNGA_FLAT:
        b = (((double) getJangkaWaktuCalc() / period) * bunga) * (totalPokok / getJangkaWaktuCalc());
        break;
      case Pinjaman.TIPE_BUNGA_MENURUN:
        b = (totalPokok * bunga) / period;
        break;
      case Pinjaman.TIPE_BUNGA_ANUITAS:
        b = (totalPokok * bunga) / period;
        break;
    }

    return b;
  }

  public int calcJangkaWaktu() {
    int j = 0;
    table = new ArrayList<HashMap<Character, Object>>() {
      {
        add(new HashMap<Character, Object>() {
          {
            put(ANGSURAN_INDEX, 0);
            put(ANGSURAN_DATE, dateRealization.getTime());
          }
        });
      }
    };
    int day = dateTempo.get(Calendar.DAY_OF_MONTH);
    Calendar current = (Calendar) dateTempo.clone();
    Calendar endDate = (Calendar) dateTempo.clone();
    if (kredit.getTipeFrekuensiPokokLegacy() == I_Sedana.TIPE_KREDIT_HARIAN) {
        endDate.add(Calendar.DAY_OF_MONTH, jangkaWaktu);
    } else if (kredit.getTipeFrekuensiPokokLegacy() == I_Sedana.TIPE_KREDIT_MINGGUAN) {
        endDate.add(Calendar.WEEK_OF_MONTH, jangkaWaktu);
    } else {
        endDate.set(Calendar.DAY_OF_MONTH, (endDate.getActualMaximum(Calendar.DAY_OF_MONTH) >= day ? day : endDate.getActualMaximum(Calendar.DAY_OF_MONTH)));
        endDate.add(Calendar.MONTH, jangkaWaktu);
    }
    Date endView = endDate.getTime();
    int i = 0;
    int freq = (kredit.getFrekuensiPokok() == 0) ? jangkaWaktu : (int) Math.ceil(jangkaWaktu / kredit.getFrekuensiPokok());
    switch (kredit.getTipeFrekuensiPokokLegacy()) {
      case I_Sedana.TIPE_KREDIT_MINGGUAN:
        current.add(Calendar.WEEK_OF_MONTH, 1);
        while (current.compareTo(endDate) <= 0) {
          i++;
          j++;
          tableAddRow(i, (Date) current.getTime().clone());
          current.add(Calendar.WEEK_OF_MONTH, 1);
        }
        frekuensiPokok = (int) Math.ceil(j / freq);
        jangkaWaktuCalc = j;
        break;
      case I_Sedana.TIPE_KREDIT_HARIAN:
        current.add(Calendar.DAY_OF_MONTH, 1);
        //updated by dewok 2019-01-11, agar jumlah hari jadwal sesuai dgn jumlah jangka waktu yg diinput
        int hari = 0;
        while (hari < jangkaWaktu) {
          if (kredit.isInSelectedDayOfWeek(current.get(Calendar.DAY_OF_WEEK))) {
            i++;
            j++;
            tableAddRow(i, (Date) current.getTime().clone());
            hari++;
          }
          current.add(Calendar.DAY_OF_MONTH, 1);
        }
        /*
        while (current.compareTo(endDate) <= 0) {
          if (kredit.isInSelectedDayOfWeek(current.get(Calendar.DAY_OF_WEEK))) {
            i++;
            j++;
            tableAddRow(i, (Date) current.getTime().clone());
          }
          current.add(Calendar.DAY_OF_MONTH, 1);
        }
        */
        frekuensiPokok = (int) Math.ceil(j / freq);
        jangkaWaktuCalc = j;
        break;
      case I_Sedana.TIPE_KREDIT_MUSIMAN:
      case I_Sedana.TIPE_KREDIT_BULANAN:
        jangkaWaktuCalc = jangkaWaktu;
        current.add(Calendar.MONTH, 1);
        while (current.compareTo(endDate) <= 0) {
          i++;
          tableAddRow(i, (Date) current.getTime().clone());
          current.set(Calendar.DAY_OF_MONTH, 1);
          current.add(Calendar.MONTH, 1);
          current.set(Calendar.DAY_OF_MONTH, (current.getActualMaximum(Calendar.DAY_OF_MONTH) >= day ? day : current.getActualMaximum(Calendar.DAY_OF_MONTH)));
        }
        frekuensiPokok = freq;
        current.getTime();
        endDate.getTime();
        break;
    }
    return jangkaWaktuCalc;
  }

  private void calculateTempo() {
    if (dateTempo == null || dateTempo.compareTo(dateRealization) < 0) {
      dateTempo = (Calendar) dateRealization.clone();
      switch (kredit.getTipeFrekuensiPokokLegacy()) {
        case I_Sedana.TIPE_KREDIT_MINGGUAN:
          dateTempo.add(Calendar.WEEK_OF_MONTH, 1);
          break;
        case I_Sedana.TIPE_KREDIT_HARIAN:
          dateTempo.add(Calendar.DAY_OF_WEEK, 1);
          break;
        case I_Sedana.TIPE_KREDIT_MUSIMAN:
        case I_Sedana.TIPE_KREDIT_BULANAN:
          int day = dateRealization.get(Calendar.DAY_OF_MONTH);
          dateTempo.set(Calendar.DAY_OF_MONTH, 1);
          dateTempo.add(Calendar.MONTH, 1);
          dateTempo.set(Calendar.DAY_OF_MONTH, dateTempo.getActualMaximum(Calendar.DAY_OF_MONTH) >= day ? day : dateTempo.getActualMaximum(Calendar.DAY_OF_MONTH));
          break;
      }
    }
  }

  public synchronized ArrayList<HashMap<Character, Object>> generateDataKredit() {
    besarAngsuran = null;
    calculateTempo();
    calculateMinPengajuan();
    calcJangkaWaktu();
    HashMap<String, Double> v = new HashMap<String, Double>() {
      {
        put("pokok", 0D);
        put("bunga", 0D);
        put("besar", 0D);
        put("total", getPengajuanTotalCalc());
        put("pokok_raw", 0D);
        put("besar_raw", 0D);
        put("total_raw", get("total"));
      }
    };
    HashMap<String, Double> tmp = new HashMap<String, Double>() {
      {
        put("accumulator", 0D);
        put("pokok", 0D);
      }
    };
    switch (getTipeBunga()) {
      case Pinjaman.TIPE_BUNGA_ANUITAS:
        for (int loop = 0; loop < table.size(); loop++) {
          HashMap<Character, Object> row = table.get(loop);
          generateBungaAnuitas(loop, tmp, v);
          tableModRow(
                  row,
                  v.get("pokok"),
                  v.get("bunga"),
                  v.get("besar"),
                  v.get("total"),
                  v.get("pokok_raw"),
                  v.get("besar_raw"),
                  v.get("total_raw")
          );
        }
        break;

      case Pinjaman.TIPE_BUNGA_FLAT:
        for (int loop = 0; loop < table.size(); loop++) {
          HashMap<Character, Object> row = table.get(loop);
          generateBungaFlat(loop, tmp, v);
          tableModRow(
                  row,
                  v.get("pokok"),
                  v.get("bunga"),
                  v.get("besar"),
                  v.get("total"),
                  v.get("pokok_raw"),
                  v.get("besar_raw"),
                  v.get("total_raw")
          );
        }
        break;

      case Pinjaman.TIPE_BUNGA_MENURUN:
        for (int loop = 0; loop < table.size(); loop++) {
          HashMap<Character, Object> row = table.get(loop);
          generateBungaMenurun(loop, tmp, v);
          tableModRow(
                  row,
                  v.get("pokok"),
                  v.get("bunga"),
                  v.get("besar"),
                  v.get("total"),
                  v.get("pokok_raw"),
                  v.get("besar_raw"),
                  v.get("total_raw")
          );
        }
        break;
    }
    return table;
  }

  private void throwPokok(int loop, HashMap<String, Double> tmp, HashMap<String, Double> v) {
    boolean isThrow = true;
    switch (kredit.getTipeFrekuensiPokokLegacy()) {
      case I_Sedana.TIPE_KREDIT_MUSIMAN:
        isThrow = (loop % frekuensiPokok == 0 && loop != 0) || (loop >= table.size());
        break;
      default:
        isThrow = true;
    }
    tmp.put("accumulator", tmp.get("accumulator") + v.get("pokok_raw"));
    if (isThrow) {
      v.put("pokok", tmp.get("accumulator"));
      v.put("besar", v.get("bunga") + v.get("pokok"));
      tmp.put("accumulator", 0D);
    } else {
      v.put("pokok", 0D);
      v.put("besar", v.get("bunga"));
    }
    v.put("total", v.get("total") - v.get("pokok"));
    v.put("total", v.get("total") <= 10 ? 0D : v.get("total"));
  }

  private void generateBungaAnuitas(int loop, HashMap<String, Double> tmp, HashMap<String, Double> v) {
    boolean first = besarAngsuran == null;
    besarAngsuran = (!first) ? besarAngsuran : (v.get("total_raw") * (calcBunga() / BASIS_BULAN)) / (1 - (1 / Math.pow((1 + (calcBunga() / BASIS_BULAN)), getJangkaWaktuCalc())));
    v.put("besar_raw", (!first) ? besarAngsuran : 0);
    v.put("bunga", (!first) ? getBunga(v.get("total_raw")) : 0);
    v.put("pokok_raw", v.get("besar_raw") - v.get("bunga"));
    v.put("total_raw", v.get("total_raw") - v.get("pokok_raw"));
    v.put("total_raw", v.get("total_raw") <= 0 ? 0 : v.get("total_raw"));
    throwPokok(loop, tmp, v);
  }

  private void generateBungaFlat(int loop, HashMap<String, Double> tmp, HashMap<String, Double> v) {
    double bunga = 0;
    if (loop > 1 && tipeJadwal == Pinjaman.TIPE_JADWAL_ON_PAID) {
        bunga = 0;
    } else {
        bunga = getBunga(getPengajuanTotalCalc());
    }
    boolean first = besarAngsuran == null;
    besarAngsuran = (!first) ? besarAngsuran : v.get("total_raw") / getJangkaWaktuCalc();
    v.put("pokok_raw", (!first) ? besarAngsuran : 0);
    v.put("bunga", (!first) ? bunga : 0);
    v.put("besar_raw", v.get("pokok_raw") + v.get("bunga"));
    v.put("total_raw", v.get("total_raw") - v.get("pokok_raw"));
    throwPokok(loop, tmp, v);
  }

  private void generateBungaMenurun(int loop, HashMap<String, Double> tmp, HashMap<String, Double> v) {
    double bunga = 0;
    if (loop > 1 && tipeJadwal == Pinjaman.TIPE_JADWAL_ON_PAID) {
        bunga = 0;
    } else {
        bunga = getBunga(v.get("total_raw"));
    }
    boolean first = besarAngsuran == null;
    besarAngsuran = (!first) ? besarAngsuran : (getJangkaWaktuCalc() == 0 ? 0 : v.get("total_raw") / getJangkaWaktuCalc());
    v.put("pokok_raw", (!first) ? besarAngsuran : 0);
    v.put("bunga", (!first) ? bunga : 0);
    v.put("besar_raw", v.get("pokok_raw") + v.get("bunga"));
    v.put("total_raw", v.get("total_raw") - v.get("pokok_raw"));
    throwPokok(loop, tmp, v);
  }

  /**
   * @return the tipeJadwal
   */
  public int getTipeJadwal() {
    return tipeJadwal;
  }

  /**
   * @param aTipeJadwal the tipeJadwal to set
   */
  public void setTipeJadwal(int aTipeJadwal) {
    tipeJadwal = aTipeJadwal;
  }

  // -- STATIC ----------------------
  public static double getBunga(double pokok, int tipeJadwal, int tipeBunga, int jangkaWaktu, JenisKredit jK, Pinjaman p) {
    SessKreditKalkulasi kal = new SessKreditKalkulasi();
    kal.setKredit(jK);
    kal.setSukuBunga(p.getSukuBunga());
    kal.setTipeJadwal(tipeJadwal);
    kal.setJangkaWaktuCalc(jangkaWaktu);
    kal.setTipeBunga(tipeBunga);

    return kal.getBunga(pokok);
  }

  public static void generateNewJadwalIfNecessary(Pinjaman p, long tellerShiftId, Date tglBayar, Transaksi parent) {
    if (p.getTipeJadwal() == Pinjaman.TIPE_JADWAL_ON_PAID) {
      double totalPokok = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
      double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
      //BULATKAN NILAI UANG DENGAN 2 DIGIT DI BELAKANG KOMA
      DecimalFormat df = new DecimalFormat("#.##");
      double newAngsuran = Double.valueOf(df.format(totalPokok));
      double newDibayar = Double.valueOf(df.format(pokokDibayar));
      if ((newAngsuran - newDibayar) > 0L) {
        double sisaPokok = 0;
        if (p.getTipeBunga() == Pinjaman.TIPE_BUNGA_MENURUN) {
            sisaPokok = p.getJumlahPinjaman() - newDibayar;
        } else if (p.getTipeBunga() == Pinjaman.TIPE_BUNGA_FLAT) {
            sisaPokok = p.getJumlahPinjaman();
        }
        JenisKredit jK = PstJenisKredit.fetch(p.getTipeKreditId());
        Calendar date = Calendar.getInstance();
        date.setTime(tglBayar);
        
        //CARI JADWAL ANGSURAN BUNGA TERAKHIR
        String whereBunga = ""
              + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + p.getOID() + "'"
              + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + "'"
              + "";
        String orderBunga = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " DESC ";
        Vector<JadwalAngsuran> listJadwalBunga = PstJadwalAngsuran.list(0, 1, whereBunga, orderBunga);
        for (JadwalAngsuran ja : listJadwalBunga) {
            date.setTime(ja.getTanggalAngsuran());
        }
        
        switch (jK.getTipeFrekuensiPokokLegacy()) {
          case I_Sedana.TIPE_KREDIT_HARIAN:
            date.add(Calendar.DAY_OF_MONTH, 1);
            break;
          case I_Sedana.TIPE_KREDIT_MINGGUAN:
            date.add(Calendar.WEEK_OF_MONTH, 1);
            break;
          default:
            date.add(Calendar.MONTH, 1);
            break;
        }

        JadwalAngsuran j = new JadwalAngsuran();
        j.setPinjamanId(p.getOID());
        j.setTanggalAngsuran(date.getTime());
        j.setParentJadwalAngsuranId(0);
        j.setJenisAngsuran(JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
        int useRounding = 0;
        try {
          useRounding = Integer.valueOf(PstSystemProperty.getValueByName("GUNAKAN_PEMBULATAN_ANGSURAN"));
        } catch (Exception exc) {
          System.out.println(exc.getMessage());
        }
        double angsuran = getBunga(sisaPokok, p.getTipeJadwal(), p.getTipeBunga(), 1, jK, p);
        if (useRounding == 1) {
          double pembulatan = (Math.floor((angsuran + 499) / 500)) * 500;
          j.setJumlahAngsuranSeharusnya(angsuran);
          j.setJumlahANgsuran(pembulatan);
          j.setSisa(pembulatan - angsuran);
        } else {
          j.setJumlahAngsuranSeharusnya(angsuran);
          j.setJumlahANgsuran(angsuran);
          j.setSisa(0);
        }
        
        if (j.getJumlahANgsuran() <= 0) {
            return;
        }
          
        try {
          Date tglTransaksi = new Date();
          String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_BUNGA_TAMBAHAN, I_Sedana.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN, tglTransaksi);
          
          Transaksi t = new Transaksi();
          t.setTanggalTransaksi(tglTransaksi);
          t.setKodeBuktiTransaksi(nomorTransaksi);
          t.setIdAnggota(p.getAnggotaId());
          t.setTellerShiftId(tellerShiftId);
          t.setKeterangan("Pencatatan bunga kredit setelah pembayaran angsuran [" + parent.getKodeBuktiTransaksi() + "]");
          t.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
          t.setUsecaseType(I_Sedana.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN);
          t.setPinjamanId(p.getOID());
          t.setTransaksiParentId(parent.getOID());
          long idTrx = PstTransaksi.insertExc(t);
          j.setTransaksiId(idTrx);
          PstJadwalAngsuran.insertExc(j);
        } catch (DBException ex) {
          Logger.getLogger(SessKreditKalkulasi.class.getName()).log(Level.SEVERE, null, ex);
        }
      }
    }
  }

}
