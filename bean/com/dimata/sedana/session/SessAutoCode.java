/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.session;

import com.dimata.common.db.DBHandler;
import com.dimata.common.db.DBResultSet;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.common.entity.system.SystemProperty;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.util.Formater;
import java.sql.ResultSet;
import java.util.Date;
import java.util.HashMap;

/**
 *
 * @author Regen
 */
public class SessAutoCode {

  private String dbName = null;
  private String dbFieldToInsert = null;
  private String code = null;
  private String sysProp = null;
  private String whereClause = null;
  private HashMap<String, Integer> key = new HashMap<String, Integer>() {
    {
      this.put("S:", 0);
      this.put("F:", 1);
      this.put("N:", 2);
      this.put("L:", 3);
      this.put("P:", 4);
      this.put("K:", 5);
    }
  };

  /**
   * @return the db
   */
  public String getDb() {
    return dbName;
  }

  /**
   * @param db the db to set
   */
  public void setDb(String db) {
    this.dbName = db;
  }

  /**
   * @return the code
   */
  public String getCode() {
    return code;
  }

  /**
   * @param code the code to set
   */
  public void setCode(String code) {
    this.code = code;
  }

  /**
   * @return the sysProp
   */
  public String getSysProp() {
    return sysProp;
  }

  /**
   * @param sysProp the sysProp to set
   */
  public void setSysProp(String sysProp) {
    this.sysProp = sysProp;
  }

  public synchronized String generate(Long oidLocation){
      return generate(oidLocation, 0L);
  }
  
  
  
  public synchronized String generate(Long oidLocation, Long pinjamanId) {

        String[] format = PstSystemProperty.getValueByName(sysProp).split("#");
        code = "";
        for (String f : format) {
            switch (key.get(f.substring(0, 2))) {
                case 0:
                    code += f.substring(2, f.length());
                    break;
                case 1:
                    code += Formater.formatDate(new Date(), f.substring(2, f.length()));
                    break;
                case 2:
                    String nCode = "";
                    long n = 0;
                    String zero = "0";
                    int length = 0;
                    try {
                        length = Integer.parseInt(f.substring(2, f.length()));
                        length = length > 250 ? 250 : length;
                    } catch (Exception e) {
                        System.err.println("Invalid integer :" + f.substring(2, f.length()) + "\n" + e);
                    }

                    for (int i = 1; i < length; i++) {
                        zero += "0";
                    }

                    n = this.getCount();
                    String val = String.valueOf(n);
                    nCode = zero.substring(0, zero.length() - val.length()) + val;
                    while (isCode(code + nCode)) {
                        n++;
                        val = String.valueOf(n);
                        nCode = zero.substring(0, zero.length() - val.length()) + val;
                    }
                    code += nCode;
                    break;
                case 3:
                    String locode = "";
                    if (oidLocation != 0) {
                        Location location = new Location();
                        try {
                            location = PstLocation.fetchExc(oidLocation);
                        } catch (Exception e) {
                        }
                        locode = location.getCode();
                    } else {
                        locode = f.substring(2);
                    }
                    code += "" + locode;

//          code += Formater.formatDate(new Date(), f.substring(2, f.length()));
                    break;
                case 4:
                    String pk = "";

                    code += "" + pk;

                    break;
                case 5:
                    String noKredit = "";
                    if(pinjamanId != 0){
                        Pinjaman p = new Pinjaman();
                        try {
                            p = PstPinjaman.fetchExc(pinjamanId);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        String[] temp = p.getNoKredit().split("/");
                        noKredit = temp[0];
                    }
                    code += noKredit;
                    break;
            }
        }

        System.out.println(code);

        return code;
    }

    public synchronized String generatePk(Long oidLocation, long categoryPinjaman, int add) {

        String[] format = PstSystemProperty.getValueByName(sysProp).split("#");
        code = "";
        for (String f : format) {
            switch (key.get(f.substring(0, 2))) {
                case 0:
                    code += f.substring(2, f.length());
                    break;
                case 1:
                    code += Formater.formatDate(new Date(), f.substring(2, f.length()));
                    break;
                case 2:
                    String nCode = "";
                    long n = 0;
                    String zero = "0";
                    int length = 0;
                    try {
                        length = Integer.parseInt(f.substring(2, f.length()));
                        length = length > 250 ? 250 : length;
                    } catch (Exception e) {
                        System.err.println("Invalid integer :" + f.substring(2, f.length()) + "\n" + e);
                    }

                    for (int i = 1; i < length; i++) {
                        zero += "0";
                    }

                    n = this.getCountPK(add);
                    String val = String.valueOf(n);
                    nCode = zero.substring(0, zero.length() - val.length()) + val;
                    while (isCode(code + nCode)) {
                        n++;
                        val = String.valueOf(n);
                        nCode = zero.substring(0, zero.length() - val.length()) + val;
                    }
                    code += nCode;
                    break;
                case 3:
                    String locode = "";
                    if (oidLocation != 0) {
                        Location location = new Location();
                        try {
                            location = PstLocation.fetchExc(oidLocation);
                        } catch (Exception e) {
                        }
                        locode = location.getCode();
                    } else {
                        locode = f.substring(2);
                    }
                    code += "" + locode;

//          code += Formater.formatDate(new Date(), f.substring(2, f.length()));
                    break;
                case 4:
                    String pk = "";
                    if (categoryPinjaman == 0) {
                        pk = "UM";
                    }else{
                        pk = "AG";
                    }
                    code += "" + pk;

                    break;
            }
        }

        System.out.println(code);

        return code;
    }

  private boolean isCode(String code) {
    boolean isCode = false;
    DBResultSet dbrs = null;
    try {
      String sql = "SELECT COUNT(0) FROM " + dbName + " WHERE " + getDbFieldToInsert() + " = '" + code + "'";
      System.out.println(sql);
      dbrs = DBHandler.execQueryResult(sql);
      ResultSet rs = dbrs.getResultSet();
      if (rs.next()) {
        isCode = rs.getLong(1) > 0;
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("get >>>>> " + e);
    } finally {
      DBResultSet.close(dbrs);
    }
    return isCode;
  }

  private long getCount() {
    return this.getCount(0);
  }

  private long getCount(long i) {
    long n = 0;
    DBResultSet dbrs = null;
    try {
      String sql = "SELECT COUNT(0) FROM " + dbName;
      if(this.getWhereClause() != null){
          sql += " WHERE " + this.getWhereClause();
      }
      System.out.println(sql);
      dbrs = DBHandler.execQueryResult(sql);
      ResultSet rs = dbrs.getResultSet();

      if (rs.next()) {
        n = rs.getLong(1) + 1;
      }
      rs.close();

    } catch (Exception e) {
      System.out.println("get >>>>> " + e);
    } finally {
      DBResultSet.close(dbrs);
    }

    return n;
  }
  
  private long getCountPK(int add) {
    long n = 0;
    DBResultSet dbrs = null;
    try {
      String sql = "SELECT COUNT(0) FROM aiso_pinjaman p INNER JOIN cash_bill_main cbm "
              + " ON p.cash_bill_main_id = cbm.cash_bill_main_id";
      if(this.getWhereClause() != null){
          sql += " WHERE " + this.getWhereClause();
      }
      System.out.println(sql);
      dbrs = DBHandler.execQueryResult(sql);
      ResultSet rs = dbrs.getResultSet();

      if (rs.next()) {
        n = rs.getLong(1) + 1 + add;
      }
      rs.close();

    } catch (Exception e) {
      System.out.println("get >>>>> " + e);
    } finally {
      DBResultSet.close(dbrs);
    }

    return n;
  }

  /**
   * @return the dbField
   */
  public String getDbFieldToInsert() {
    return dbFieldToInsert;
  }

  /**
   * @param dbField the dbField to set
   */
  public void setDbFieldToCheck(String dbField) {
    this.dbFieldToInsert = dbField;
  }

    /**
     * @return the whereClause
     */
    public String getWhereClause() {
        return whereClause;
    }

    /**
     * @param whereClause the whereClause to set
     */
    public void setWhereClause(String whereClause) {
        this.whereClause = whereClause;
    }

}
