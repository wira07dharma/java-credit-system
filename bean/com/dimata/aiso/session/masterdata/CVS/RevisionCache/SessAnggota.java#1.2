/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.aiso.session.masterdata;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggotaKeluarga;
import com.dimata.aiso.entity.masterdata.anggota.PstVocation;
import com.dimata.common.entity.contact.PstContactClass;
import com.dimata.common.entity.contact.PstContactClassAssign;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPenjamin;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.mysql.jdbc.ResultSet;
import java.util.Vector;

/**
 *
 * @author Dimata 007
 */
public class SessAnggota {

    public static Vector listJoinKeluarga(int limitStart, int recordToGet, String whereClause, String order, long oidAnggota) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT anggota.*,"
                    + " keluarga." + PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_KETERANGAN] + ","
                    + " keluarga." + PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_STATUS_RELASI] + ","
                    + " keluarga." + PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_RELASI_ANGGOTA_ID] + ""
                    + " FROM " + PstAnggota.TBL_ANGGOTA + " AS anggota "
                    + " INNER JOIN " + PstAnggotaKeluarga.TBL_ANGGOTA_KELUARGA + " AS keluarga"
                    + " ON anggota." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = keluarga." + PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_CONTACT_KELUARGA_ID] + " "
                    + " WHERE keluarga." + PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_CONTACT_ANGGOTA_ID] + " = '" + oidAnggota + "'";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                Anggota anggota = new Anggota();
                resultToObject(rs, anggota);
                anggota.setKeteranganKeluarga(rs.getString(PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_KETERANGAN]));
                anggota.setHubunganKeluarga(rs.getInt(PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_STATUS_RELASI]));
                anggota.setRelasiId(rs.getLong(PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_RELASI_ANGGOTA_ID]));
                lists.add(anggota);
            }
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listJoinContactPinjaman(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT cl.*,"
                    + " voc.*"
                    + " FROM " + PstAnggota.TBL_ANGGOTA + " cl "
                    + " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " cca"
                    + " ON cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + "=cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID]
                    + " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " cc"
                    + " ON cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] + " =cc." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
                    + " LEFT JOIN " + PstVocation.TBL_TB_VOCATION + " voc"
                    + " ON voc." + PstVocation.fieldNames[PstVocation.FLD_VOCATION_ID] + " = cl." + PstAnggota.fieldNames[PstAnggota.FLD_VOCATION_ID]
                    + " LEFT JOIN " + PstPinjaman.TBL_PINJAMAN + " AS pinjaman "
                    + " ON pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID] + " = cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " WHERE (cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " ='" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                    + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " ='" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "')"
                    + " AND ("
                    + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_LUNAS + "' "
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_TIDAK_DISETUJUI + "' "
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " IS NULL "
                    + " )";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                Anggota anggota = new Anggota();
                resultToObject(rs, anggota);
                lists.add(anggota);
            }
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listPasangan(int limitStart, int recordToGet, String whereClause, String order, long oidAnggota) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT"
                    + " cl.*,"
                    + " keluarga.*,"
                    + " cc.*"
                    + " FROM " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + " INNER JOIN `contact_class_assign` AS cca"
                    + " ON cca.`CONTACT_ID` = cl.`CONTACT_ID`"
                    + " INNER JOIN `contact_class` AS cc"
                    + " ON cc.`CONTACT_CLASS_ID` = cca.`CONTACT_CLASS_ID`"
                    + " LEFT JOIN `aiso_anggota_keluarga` keluarga "
                    + " ON keluarga.`CONTACT_KELUARGA_ID` = cl.`CONTACT_ID`"
                    + " WHERE keluarga.`CONTACT_ANGGOTA_ID` = '" + oidAnggota + "'"
                    + " AND cc.`CLASS_TYPE` = '10' "
                    + " AND (keluarga.`STATUS_RELASI` = '2' OR keluarga.`STATUS_RELASI` = '3')"
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                Anggota anggota = new Anggota();
                resultToObject(rs, anggota);
                anggota.setKeteranganKeluarga(rs.getString(PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_KETERANGAN]));
                anggota.setHubunganKeluarga(rs.getInt(PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_STATUS_RELASI]));
                anggota.setRelasiId(rs.getLong(PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_RELASI_ANGGOTA_ID]));
                lists.add(anggota);
            }
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listAnggotaPenjamin(int limitStart, int recordToGet, String whereClause, String order, long oidAnggota) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT"
                    + " cl.*, penjamin.`PENJAMIN_ID`"
                    + " FROM " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + " INNER JOIN `sedana_penjamin` AS penjamin"
                    + " ON penjamin.`CONTACT_ID` = cl.`CONTACT_ID`"
                    + " INNER JOIN aiso_pinjaman AS pinjaman"
                    + " ON pinjaman.`PINJAMAN_ID` = penjamin.`PINJAMAN_ID`"
                    + " WHERE pinjaman.`ANGGOTA_ID` = '" + oidAnggota + "'"
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                Anggota anggota = new Anggota();
                resultToObject(rs, anggota);
                anggota.setPenjaminId(rs.getLong(PstPenjamin.fieldNames[PstPenjamin.FLD_PENJAMIN_ID]));
                lists.add(anggota);
            }
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, Anggota anggota) {
        try {
            anggota.setOID(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]));
            anggota.setNoAnggota(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA]));
            anggota.setName(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_NAME]));
            anggota.setSex(rs.getInt(PstAnggota.fieldNames[PstAnggota.FLD_SEX]));
            anggota.setBirthPlace(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_PLACE]));
            anggota.setBirthDate(rs.getDate(PstAnggota.fieldNames[PstAnggota.FLD_BIRTH_DATE]));
            anggota.setVocationId(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_VOCATION_ID]));
            // anggota.setAgencies(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_AGENCIES]));
            anggota.setOfficeAddress(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_OFFICE_ADDRESS]));
            anggota.setAddressOfficeCity(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_ADDR_OFFICE_CITY])); //update tanggal 26 Pebruari 2013 oleh Hadi
            anggota.setPositionId(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_POSITION_ID]));
            anggota.setAddressPermanent(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PERMANENT]));
            anggota.setAddressCityPermanentId(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_ADDR_CITY_PERMANENT]));
            anggota.setAddressProvinceId(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PROVINCE_ID]));
            anggota.setAddressPermanentRegencyId(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PMNT_REGENCY_ID]));
            anggota.setAddressPermanentSubRegencyId(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PMNT_SUBREGENCY_ID]));
            anggota.setWardId(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_WARD_ID]));
            anggota.setIdCard(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_ID_CARD]));
            anggota.setExpiredDateKtp(rs.getDate(PstAnggota.fieldNames[PstAnggota.FLD_EXPIRED_DATE_KTP]));
            anggota.setTelepon(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_TLP]));
            anggota.setHandPhone(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_HANDPHONE]));
            anggota.setEmail(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_EMAIL]));

            anggota.setNoNpwp(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_NO_NPWP]));
            anggota.setStatus(rs.getInt(PstAnggota.fieldNames[PstAnggota.FLD_STATUS]));

            anggota.setNoRekening(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_NO_REKENING]));
            anggota.setTanggalRegistrasi(rs.getDate(PstAnggota.fieldNames[PstAnggota.FLD_REGRISTATION_DATE]));
			anggota.setAssignLocation(rs.getLong(PstAnggota.fieldNames[PstAnggota.FLD_ASSIGN_LOCATION_ID]));

        } catch (Exception e) {
        }
    }

    public static int getCountJoinContactPinjaman(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        int count = 0;
        try {
            String sql = "SELECT COUNT(cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + ") "
                    + " FROM " + PstAnggota.TBL_ANGGOTA + " cl "
                    + " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " cca"
                    + " ON cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + "=cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID]
                    + " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " cc"
                    + " ON cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] + " =cc." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
                    + " LEFT JOIN " + PstVocation.TBL_TB_VOCATION + " voc"
                    + " ON voc." + PstVocation.fieldNames[PstVocation.FLD_VOCATION_ID] + " = cl." + PstAnggota.fieldNames[PstAnggota.FLD_VOCATION_ID]
                    + " LEFT JOIN " + PstPinjaman.TBL_PINJAMAN + " AS pinjaman "
                    + " ON pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID] + " = cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " WHERE (cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " ='" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                    + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " ='" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "')"
                    + " AND ("
                    + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_LUNAS + "' "
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_TIDAK_DISETUJUI + "' "
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " IS NULL "
                    + " )";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
            return count;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return count;
    }

    public static Vector listPenjamin(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT cl.* "
                    + " FROM " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + " INNER JOIN `contact_class_assign` AS cca "
                    + " ON cca.`CONTACT_ID` = cl.`CONTACT_ID`"
                    + " INNER JOIN `contact_class` AS cc "
                    + " ON cc.`CONTACT_CLASS_ID` = cca.`CONTACT_CLASS_ID` "
                    + " AND cc.`CLASS_TYPE` = '10' "
                    + " WHERE cl.`MEMBER_SEX` <> '-1'"
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                Anggota anggota = new Anggota();
                resultToObject(rs, anggota);
                lists.add(anggota);
            }
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static int getCountPenjamin(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        int count = 0;
        try {
            String sql = "SELECT COUNT(cl.`CONTACT_ID`) "
                    + " FROM " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + " INNER JOIN `contact_class_assign` AS cca "
                    + " ON cca.`CONTACT_ID` = cl.`CONTACT_ID`"
                    + " INNER JOIN `contact_class` AS cc "
                    + " ON cc.`CONTACT_CLASS_ID` = cca.`CONTACT_CLASS_ID` "
                    + " AND cc.`CLASS_TYPE` = '10' "
                    + " WHERE cl.`MEMBER_SEX` <> '-1'"
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
            return count;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return count;
    }
    
    public static int getCountJoinContactClassAssign(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + ")"
                    + " FROM " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " AS cca "
                    + " ON cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " = cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " AS cc "
                    + " ON cc." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] + " = cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            //System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
        
    public static Vector listJoinContactClassAssign(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT cl.* "
                    + " FROM " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " AS cca "
                    + " ON cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " = cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " AS cc "
                    + " ON cc." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] + " = cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                Anggota anggota = new Anggota();
                resultToObject(rs, anggota);
                lists.add(anggota);
            }
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }
    
}
