/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.analisakredit;

import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.pos.entity.billing.PstBillMain;
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.util.Command;
import java.util.Vector;

public class PstAnalisaKreditMain extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final String TBL_ANALISAKREDITMAIN = "sedana_analisa_kredit_main";
	public static final int FLD_ANALISAKREDITMAINID = 0;
	public static final int FLD_PINJAMANID = 1;
	public static final int FLD_ANALISID = 2;
	public static final int FLD_DIVISIONHEADID = 3;
	public static final int FLD_MANAGERID = 4;
	public static final int FLD_PENGHASILAN_PEMOHON = 5;
	public static final int FLD_PENGELUARAN = 6;
	public static final int FLD_SURPLUSANGSURAN = 7;
	public static final int FLD_ANALISATGL = 8;
	public static final int FLD_ANALISANOTE = 9;
	public static final int FLD_ANALISANUMBER = 10;
	public static final int FLD_LOCATIONID = 11;
	public static final int FLD_PENGHASILAN_PENANGGUNG = 12;
	public static final int FLD_PENGELUARAN_KONSUMSI = 13;
	public static final int FLD_PENGELUARAN_LISTELPAM = 14;
	public static final int FLD_PENGELUARAN_PENDIDIKAN = 15;
	public static final int FLD_PENGELUARAN_SANDANG = 16;
	public static final int FLD_PENGELUARAN_LAINNYA = 17;
	public static final int FLD_ANALISA_STATUS = 18;

	public static String[] fieldNames = {
		"ANALISA_KREDIT_MAIN_ID",
		"PINJAMAN_ID",
		"ANALIS_ID",
		"DIVISION_HEAD_ID",
		"MANAGER_ID",
		"PENGHASILAN_PEMOHON",
		"PENGELUARAN",
		"SURPLUS_ANGSURAN",
		"ANALISA_TGL",
		"ANALISA_NOTES",
		"ANALISA_NUMBER",
		"LOCATION_ID",
		"PENGHASILAN_PENANGGUNG",
		"PENGELUARAN_KONSUMSI",
		"PENGELUARAN_LISTELPAM",
		"PENGELUARAN_PENDIDIKAN",
		"PENGELUARAN_SANDANG",
		"PENGELUARAN_LAINNYA",
		"ANALISA_STATUS"
	};

	public static int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_INT 
	};

	public static final int NILAI_ANALISA_TIDAK_LAYAK = 0;
	public static final int NILAI_ANALISA_LAYAK_DENGAN_CATATAN = 1;
	public static final int NILAI_ANALISA_LAYAK = 2;

	public static String[] nilaiAnalisa = {
		"TIDAK LAYAK",
		"LAYAK DENGAN CATATAN",
		"LAYAK"
	};
	
	public static final int ANALISA_STATUS_DRAFT = 0;
	public static final int ANALISA_STATUS_CLOSED = 1;
	
	public static String[] analisaStatusName = {
		"Draft",
		"Closed"
	};
	public static int[] analisaStatusValue = {
		0,
		1
	};
	
	public PstAnalisaKreditMain() {
	}

	public PstAnalisaKreditMain(int i) throws DBException {
		super(new PstAnalisaKreditMain());
	}

	public PstAnalisaKreditMain(String sOid) throws DBException {
		super(new PstAnalisaKreditMain(0));
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public PstAnalisaKreditMain(long lOid) throws DBException {
		super(new PstAnalisaKreditMain(0));
		String sOid = "0";
		try {
			sOid = String.valueOf(lOid);
		} catch (Exception e) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public int getFieldSize() {
		return fieldNames.length;
	}

	public String getTableName() {
		return TBL_ANALISAKREDITMAIN;
	}

	public String[] getFieldNames() {
		return fieldNames;
	}

	public int[] getFieldTypes() {
		return fieldTypes;
	}

	public String getPersistentName() {
		return new PstAnalisaKreditMain().getClass().getName();
	}

	public static AnalisaKreditMain fetchExc(long oid) throws DBException {
		try {
			AnalisaKreditMain entAnalisaKreditMain = new AnalisaKreditMain();
			PstAnalisaKreditMain pstAnalisaKreditMain = new PstAnalisaKreditMain(oid);
			entAnalisaKreditMain.setOID(oid);
			entAnalisaKreditMain.setPinjamanId(pstAnalisaKreditMain.getlong(FLD_PINJAMANID));
			entAnalisaKreditMain.setAnalisId(pstAnalisaKreditMain.getlong(FLD_ANALISID));
			entAnalisaKreditMain.setDivisionHeadId(pstAnalisaKreditMain.getlong(FLD_DIVISIONHEADID));
			entAnalisaKreditMain.setManagerId(pstAnalisaKreditMain.getlong(FLD_MANAGERID));
			entAnalisaKreditMain.setPenghasilanPemohon(pstAnalisaKreditMain.getdouble(FLD_PENGHASILAN_PEMOHON));
			entAnalisaKreditMain.setPengeluaran(pstAnalisaKreditMain.getdouble(FLD_PENGELUARAN));
			entAnalisaKreditMain.setSurplusAngsuran(pstAnalisaKreditMain.getdouble(FLD_SURPLUSANGSURAN));
			entAnalisaKreditMain.setAnalisaTgl(pstAnalisaKreditMain.getDate(FLD_ANALISATGL));
			entAnalisaKreditMain.setAnalisaNote(pstAnalisaKreditMain.getString(FLD_ANALISANOTE));
			entAnalisaKreditMain.setAnalisaNumber(pstAnalisaKreditMain.getString(FLD_ANALISANUMBER)); 
			entAnalisaKreditMain.setLocationId(pstAnalisaKreditMain.getlong(FLD_LOCATIONID));
			entAnalisaKreditMain.setPenghasilanPenanggung(pstAnalisaKreditMain.getdouble(FLD_PENGHASILAN_PENANGGUNG));
			entAnalisaKreditMain.setPengeluaranKonsumsi(pstAnalisaKreditMain.getdouble(FLD_PENGELUARAN_KONSUMSI));
			entAnalisaKreditMain.setPengeluaranListelpam(pstAnalisaKreditMain.getdouble(FLD_PENGELUARAN_LISTELPAM));
			entAnalisaKreditMain.setPengeluaranPendidikan(pstAnalisaKreditMain.getdouble(FLD_PENGELUARAN_PENDIDIKAN));
			entAnalisaKreditMain.setPengeluaranSandang(pstAnalisaKreditMain.getdouble(FLD_PENGELUARAN_SANDANG));
			entAnalisaKreditMain.setPengeluaranLainnya(pstAnalisaKreditMain.getdouble(FLD_PENGELUARAN_LAINNYA)); 
			entAnalisaKreditMain.setAnalisaStatus(pstAnalisaKreditMain.getInt(FLD_ANALISA_STATUS));
			return entAnalisaKreditMain;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstAnalisaKreditMain(0), DBException.UNKNOWN);
		}
	}

	public long fetchExc(Entity entity) throws Exception {
		AnalisaKreditMain entAnalisaKreditMain = fetchExc(entity.getOID());
		entity = (Entity) entAnalisaKreditMain;
		return entAnalisaKreditMain.getOID();
	}

	public static synchronized long updateExc(AnalisaKreditMain entAnalisaKreditMain) throws DBException {
		try {
			if (entAnalisaKreditMain.getOID() != 0) {
				PstAnalisaKreditMain pstAnalisaKreditMain = new PstAnalisaKreditMain(entAnalisaKreditMain.getOID());
				pstAnalisaKreditMain.setLong(FLD_PINJAMANID, entAnalisaKreditMain.getPinjamanId());
				pstAnalisaKreditMain.setLong(FLD_ANALISID, entAnalisaKreditMain.getAnalisId());
				pstAnalisaKreditMain.setLong(FLD_DIVISIONHEADID, entAnalisaKreditMain.getDivisionHeadId());
				pstAnalisaKreditMain.setLong(FLD_MANAGERID, entAnalisaKreditMain.getManagerId());
				pstAnalisaKreditMain.setDouble(FLD_PENGHASILAN_PEMOHON, entAnalisaKreditMain.getPenghasilanPemohon());
				pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN, entAnalisaKreditMain.getPengeluaran());
				pstAnalisaKreditMain.setDouble(FLD_SURPLUSANGSURAN, entAnalisaKreditMain.getSurplusAngsuran());
				pstAnalisaKreditMain.setDate(FLD_ANALISATGL, entAnalisaKreditMain.getAnalisaTgl());
				pstAnalisaKreditMain.setString(FLD_ANALISANOTE, entAnalisaKreditMain.getAnalisaNote());
				pstAnalisaKreditMain.setString(FLD_ANALISANUMBER, entAnalisaKreditMain.getAnalisaNumber());
				pstAnalisaKreditMain.setLong(FLD_LOCATIONID, entAnalisaKreditMain.getLocationId());
				pstAnalisaKreditMain.setDouble(FLD_PENGHASILAN_PENANGGUNG, entAnalisaKreditMain.getPenghasilanPenanggung());
				pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_KONSUMSI, entAnalisaKreditMain.getPengeluaranKonsumsi());
				pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_LISTELPAM, entAnalisaKreditMain.getPengeluaranListelpam());
				pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_PENDIDIKAN, entAnalisaKreditMain.getPengeluaranPendidikan());
				pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_SANDANG, entAnalisaKreditMain.getPengeluaranSandang());
				pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_LAINNYA, entAnalisaKreditMain.getPengeluaranLainnya());
				pstAnalisaKreditMain.setInt(FLD_ANALISA_STATUS, entAnalisaKreditMain.getAnalisaStatus());
				pstAnalisaKreditMain.update();
				return entAnalisaKreditMain.getOID();
			}
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstAnalisaKreditMain(0), DBException.UNKNOWN);
		}
		return 0;
	}

	public long updateExc(Entity entity) throws Exception {
		return updateExc((AnalisaKreditMain) entity);
	}

	public static synchronized long deleteExc(long oid) throws DBException {
		try {
			PstAnalisaKreditMain pstAnalisaKreditMain = new PstAnalisaKreditMain(oid);
			pstAnalisaKreditMain.delete();
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstAnalisaKreditMain(0), DBException.UNKNOWN);
		}
		return oid;
	}

	public long deleteExc(Entity entity) throws Exception {
		if (entity == null) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(entity.getOID());
	}

	public static synchronized long insertExc(AnalisaKreditMain entAnalisaKreditMain) throws DBException {
		try {
			PstAnalisaKreditMain pstAnalisaKreditMain = new PstAnalisaKreditMain(0);
			pstAnalisaKreditMain.setLong(FLD_PINJAMANID, entAnalisaKreditMain.getPinjamanId());
			pstAnalisaKreditMain.setLong(FLD_ANALISID, entAnalisaKreditMain.getAnalisId());
			pstAnalisaKreditMain.setLong(FLD_DIVISIONHEADID, entAnalisaKreditMain.getDivisionHeadId());
			pstAnalisaKreditMain.setLong(FLD_MANAGERID, entAnalisaKreditMain.getManagerId());
			pstAnalisaKreditMain.setDouble(FLD_PENGHASILAN_PEMOHON, entAnalisaKreditMain.getPenghasilanPemohon());
			pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN, entAnalisaKreditMain.getPengeluaran());
			pstAnalisaKreditMain.setDouble(FLD_SURPLUSANGSURAN, entAnalisaKreditMain.getSurplusAngsuran());
			pstAnalisaKreditMain.setDate(FLD_ANALISATGL, entAnalisaKreditMain.getAnalisaTgl());
			pstAnalisaKreditMain.setString(FLD_ANALISANOTE, entAnalisaKreditMain.getAnalisaNote());
			pstAnalisaKreditMain.setString(FLD_ANALISANUMBER, entAnalisaKreditMain.getAnalisaNumber());
			pstAnalisaKreditMain.setLong(FLD_LOCATIONID, entAnalisaKreditMain.getLocationId());
			pstAnalisaKreditMain.setDouble(FLD_PENGHASILAN_PENANGGUNG, entAnalisaKreditMain.getPenghasilanPenanggung());
			pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_KONSUMSI, entAnalisaKreditMain.getPengeluaranKonsumsi());
			pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_LISTELPAM, entAnalisaKreditMain.getPengeluaranListelpam());
			pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_PENDIDIKAN, entAnalisaKreditMain.getPengeluaranPendidikan());
			pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_SANDANG, entAnalisaKreditMain.getPengeluaranSandang());
			pstAnalisaKreditMain.setDouble(FLD_PENGELUARAN_LAINNYA, entAnalisaKreditMain.getPengeluaranLainnya());
			pstAnalisaKreditMain.setInt(FLD_ANALISA_STATUS, entAnalisaKreditMain.getAnalisaStatus());
			pstAnalisaKreditMain.insert();
			entAnalisaKreditMain.setOID(pstAnalisaKreditMain.getlong(FLD_ANALISAKREDITMAINID));
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstAnalisaKreditMain(0), DBException.UNKNOWN);
		}
		return entAnalisaKreditMain.getOID();
	}

	public long insertExc(Entity entity) throws Exception {
		return insertExc((AnalisaKreditMain) entity);
	}

	public static void resultToObject(ResultSet rs, AnalisaKreditMain entAnalisaKreditMain) {
		try {
			entAnalisaKreditMain.setOID(rs.getLong(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISAKREDITMAINID]));
			entAnalisaKreditMain.setPinjamanId(rs.getLong(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PINJAMANID]));
			entAnalisaKreditMain.setAnalisId(rs.getLong(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISID]));
			entAnalisaKreditMain.setDivisionHeadId(rs.getLong(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_DIVISIONHEADID]));
			entAnalisaKreditMain.setManagerId(rs.getLong(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_MANAGERID]));
			entAnalisaKreditMain.setPenghasilanPemohon(rs.getDouble(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PENGHASILAN_PEMOHON]));
			entAnalisaKreditMain.setPengeluaran(rs.getDouble(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PENGELUARAN]));
			entAnalisaKreditMain.setSurplusAngsuran(rs.getDouble(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_SURPLUSANGSURAN]));
			entAnalisaKreditMain.setAnalisaTgl(rs.getDate(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISATGL]));
			entAnalisaKreditMain.setAnalisaNote(rs.getString(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISANOTE]));
			entAnalisaKreditMain.setAnalisaNumber(rs.getString(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISANUMBER]));
			entAnalisaKreditMain.setLocationId(rs.getLong(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_LOCATIONID]));
			entAnalisaKreditMain.setPenghasilanPenanggung(rs.getDouble(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PENGHASILAN_PENANGGUNG]));
			entAnalisaKreditMain.setPengeluaranKonsumsi(rs.getDouble(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PENGELUARAN_KONSUMSI]));
			entAnalisaKreditMain.setPengeluaranListelpam(rs.getDouble(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PENGELUARAN_LISTELPAM]));
			entAnalisaKreditMain.setPengeluaranPendidikan(rs.getDouble(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PENGELUARAN_PENDIDIKAN]));
			entAnalisaKreditMain.setPengeluaranSandang(rs.getDouble(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PENGELUARAN_SANDANG]));
			entAnalisaKreditMain.setPengeluaranLainnya(rs.getDouble(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PENGELUARAN_LAINNYA]));  
			entAnalisaKreditMain.setAnalisaStatus(rs.getInt(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISA_STATUS]));
		} catch (Exception e) {
		}
	}

	public static Vector listAll() {
		return list(0, 500, "", "");
	}

	public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
		Vector lists = new Vector();
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + TBL_ANALISAKREDITMAIN;
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
			ResultSet rs = dbrs.getResultSet();
			while (rs.next()) {
				AnalisaKreditMain entAnalisaKreditMain = new AnalisaKreditMain();
				resultToObject(rs, entAnalisaKreditMain);
				lists.add(entAnalisaKreditMain);
			}
			rs.close();
			return lists;
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			DBResultSet.close(dbrs);
		}
		return new Vector();
	}

	public static boolean checkOID(long entAnalisaKreditMainId) {
		DBResultSet dbrs = null;
		boolean result = false;
		try {
			String sql = "SELECT * FROM " + TBL_ANALISAKREDITMAIN + " WHERE "
					+ PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISAKREDITMAINID] + " = " + entAnalisaKreditMainId;
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while (rs.next()) {
				result = true;
			}
			rs.close();
		} catch (Exception e) {
			System.out.println("err : " + e.toString());
		} finally {
			DBResultSet.close(dbrs);
			return result;
		}
	}

    public static Vector getListJoin(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector(1, 1);
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_ANALISAKREDITMAIN
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN
                    + " ON " + TBL_ANALISAKREDITMAIN + "." + fieldNames[FLD_PINJAMANID]
                    + " = " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA
                    + " ON " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " = " + PstAnggota.TBL_ANGGOTA + "." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN
                    + " ON " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " = " + PstBillMain.TBL_CASH_BILL_MAIN + "." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID];
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
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector(1, 1);
                AnalisaKreditMain entAnalisaKreditMain = new AnalisaKreditMain();
                Pinjaman p = new Pinjaman();
                Anggota a = new Anggota();
                resultToObject(rs, entAnalisaKreditMain);
                PstPinjaman.resultToObject(rs, p);
                PstAnggota.resultToObject(rs, a);
                temp.add(entAnalisaKreditMain);
                temp.add(p);
                temp.add(a);
                lists.add(temp);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return lists;
    }

    public static int getCountJoin(String whereClause) {
        int total = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(*) AS TOTAL FROM " + TBL_ANALISAKREDITMAIN
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN
                    + " ON " + TBL_ANALISAKREDITMAIN + "." + fieldNames[FLD_PINJAMANID]
                    + " = " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA
                    + " ON " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " = " + PstAnggota.TBL_ANGGOTA + "." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN
                    + " ON " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " = " + PstBillMain.TBL_CASH_BILL_MAIN + "." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID];
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total = rs.getInt("TOTAL");
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return total;
    }

	public static int getCount(String whereClause) {
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT(" + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISAKREDITMAINID] + ") FROM " + TBL_ANALISAKREDITMAIN;
			if (whereClause != null && whereClause.length() > 0) {
				sql = sql + " WHERE " + whereClause;
			}
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
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

	public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
		int size = getCount(whereClause);
		int start = 0;
		boolean found = false;
		for (int i = 0; (i < size) && !found; i = i + recordToGet) {
			Vector list = list(i, recordToGet, whereClause, orderClause);
			start = i;
			if (list.size() > 0) {
				for (int ls = 0; ls < list.size(); ls++) {
					AnalisaKreditMain entAnalisaKreditMain = (AnalisaKreditMain) list.get(ls);
					if (oid == entAnalisaKreditMain.getOID()) {
						found = true;
					}
				}
			}
		}
		if ((start >= size) && (size > 0)) {
			start = start - recordToGet;
		}
		return start;
	}

	public static int findLimitCommand(int start, int recordToGet, int vectSize) {
		int cmd = Command.LIST;
		int mdl = vectSize % recordToGet;
		vectSize = vectSize + (recordToGet - mdl);
		if (start == 0) {
			cmd = Command.FIRST;
		} else {
			if (start == (vectSize - recordToGet)) {
				cmd = Command.LAST;
			} else {
				start = start + recordToGet;
				if (start <= (vectSize - recordToGet)) {
					cmd = Command.NEXT;
					System.out.println("next.......................");
				} else {
					start = start - recordToGet;
					if (start > 0) {
						cmd = Command.PREV;
						System.out.println("prev.......................");
					}
				}
			}
		}
		return cmd;
	}
}
