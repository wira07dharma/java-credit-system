/*
 * SessReportPotitionStock.java
 *
 * Created on February 18, 2008, 10:36 AM
 */

package com.dimata.posbo.session.warehouse;

import com.dimata.common.entity.periode.Periode;
import com.dimata.common.entity.periode.PstPeriode;
import com.dimata.pos.entity.billing.PstBillDetail;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.posbo.db.DBHandler;
import com.dimata.posbo.db.DBResultSet;
import com.dimata.posbo.entity.masterdata.Material;
import com.dimata.posbo.entity.masterdata.MaterialStock;
import com.dimata.posbo.entity.masterdata.PstCategory;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import com.dimata.posbo.entity.masterdata.PstMaterialStock;
import com.dimata.posbo.entity.masterdata.PstUnit;
import com.dimata.posbo.entity.masterdata.Unit;
import com.dimata.posbo.entity.search.SrcReportPotitionStock;
import com.dimata.posbo.entity.warehouse.PstMatCosting;
import com.dimata.posbo.entity.warehouse.PstMatCostingItem;
import com.dimata.posbo.entity.warehouse.PstMatDispatch;
import com.dimata.posbo.entity.warehouse.PstMatDispatchItem;
import com.dimata.posbo.entity.warehouse.PstMatReceive;
import com.dimata.posbo.entity.warehouse.PstMatReceiveItem;
import com.dimata.posbo.entity.warehouse.PstMatReturn;
import com.dimata.posbo.entity.warehouse.PstMatReturnItem;
import com.dimata.posbo.entity.warehouse.PstMatStockOpname;
import com.dimata.posbo.entity.warehouse.PstMatStockOpnameItem;
import com.dimata.qdep.entity.I_DocStatus;
import com.dimata.util.Formater;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

import javax.servlet.jsp.JspWriter;
import com.dimata.qdep.form.FRMHandler;

/**
 *
 * @author gwawan
 */
public class SessReportPotitionStock {
    
    // for report posisi stock
    public static final String TBL_MATERIAL_STOCK_REPORT = "pos_material_stock_report";
    public static final String TBL_MATERIAL_STOCK_REPORT_HIS = "pos_material_stock_report_temp";
    public static final int TYPE_REPORT_POSISI_ALL = 0;
    public static final int TYPE_REPORT_POSISI_CATEGORY = 1;
    public static final int TYPE_REPORT_POSISI_SUPPLIER = 2;
    
    // constant for session stock potition report
    public static final String SESS_SRC_STOCK_POTITION_REPORT = "SESS_SRC_STOCK_POTITION_REPORT";
    
    public static final int STOCK_VALUE_BEGIN = 0;
    public static final int STOCK_VALUE_OPNAME = 1;
    public static final int STOCK_VALUE_RECEIVE = 2;
    public static final int STOCK_VALUE_DISPATCH = 3;
    public static final int STOCK_VALUE_RETURN = 4;
    public static final int STOCK_VALUE_SALE = 5;
    public static final int STOCK_VALUE_RETURN_CUST = 6;
    public static final int STOCK_VALUE_CLOSING = 7;


    
    /** Creates a new instance of SessReportPotitionStock */
    public SessReportPotitionStock() {
    }
    
    /** Fungsi ini digunakan untuk melakukan rekap data transaksi, untuk selanjutnya disimpan sementara dalam tabel
     * @param boolean Jenis laporan yang akan menggunakan hasil data rekapan (Weekly/Potition)
     * @param SrcReportPotitionStock Instance pencarian
     * @boolean Parameter untuk menentukkan apakah proses melibatkan stok bernilai nol
     * @created gwawan@dimata 2008-01-21
     */
    synchronized public static boolean summarryTransactionData(boolean weekReport, SrcReportPotitionStock srcReportPotitionStock, boolean isZero) {
        /** hapus isi tabel temporary dalam keadaan kosong */
        deleteHistory(TBL_MATERIAL_STOCK_REPORT, srcReportPotitionStock);
        deleteHistory(TBL_MATERIAL_STOCK_REPORT_HIS, srcReportPotitionStock);
        
        Vector list = new Vector(1, 1);
        try {
            System.out.println("masukkan data transaksi ke tabel "+TBL_MATERIAL_STOCK_REPORT);
            // mengambil data trnasaksi sesuai dengan periode yang di select
            System.out.println(" proses transaksi receive....");
            insertSelectReceive(TBL_MATERIAL_STOCK_REPORT, srcReportPotitionStock);
            System.out.println(" proses transaksi return supplier....");
            insertSelectReturn(TBL_MATERIAL_STOCK_REPORT, srcReportPotitionStock);
            System.out.println(" proses transaksi dispatch....");
            insertSelectDispatch(TBL_MATERIAL_STOCK_REPORT, srcReportPotitionStock);
            System.out.println(" proses transaksi costing....");
            insertSelectCosting(TBL_MATERIAL_STOCK_REPORT, srcReportPotitionStock);
            System.out.println(" proses transaksi sale + return sale....");
            insertSelectSale(TBL_MATERIAL_STOCK_REPORT, srcReportPotitionStock);
            System.out.println(" proses transaksi opname....");
            insertSelectOpname(TBL_MATERIAL_STOCK_REPORT, srcReportPotitionStock);
            
            // set date last find data
            Date dateTo = srcReportPotitionStock.getDateFrom();
            dateTo.setDate(dateTo.getDate() - 1);
            srcReportPotitionStock.setDateTo(dateTo);
            
            Vector vect = PstPeriode.list(0, 0, "", PstPeriode.fieldNames[PstPeriode.FLD_START_DATE]);
            if (vect != null && vect.size() > 0) {
                Periode periode = (Periode) vect.get(0);
                srcReportPotitionStock.setDateFrom(periode.getStartDate());
                srcReportPotitionStock.setPeriodeId(periode.getOID());
            }
            
            System.out.println("masukkan data transaksi ke tabel "+TBL_MATERIAL_STOCK_REPORT_HIS);
            // mengambil data sebelum periode yang diselect
            System.out.println(" proses transaksi receive....");
            insertSelectReceive(TBL_MATERIAL_STOCK_REPORT_HIS, srcReportPotitionStock);
            System.out.println(" proses transaksi return supplier....");
            insertSelectReturn(TBL_MATERIAL_STOCK_REPORT_HIS, srcReportPotitionStock);
            System.out.println(" proses transaksi dispatch....");
            insertSelectDispatch(TBL_MATERIAL_STOCK_REPORT_HIS, srcReportPotitionStock);
            System.out.println(" proses transaksi costing....");
            insertSelectCosting(TBL_MATERIAL_STOCK_REPORT_HIS, srcReportPotitionStock);
            System.out.println(" proses transaksi sale + return sale....");
            insertSelectSale(TBL_MATERIAL_STOCK_REPORT_HIS, srcReportPotitionStock);
            System.out.println(" proses transaksi opname....");
            insertSelectOpname(TBL_MATERIAL_STOCK_REPORT_HIS, srcReportPotitionStock);
            
        } catch (Exception e) {
            System.out.println("Exc. summarryTransactionData(#,#,#,#) >> " + e.toString());
            return false;
        }
        
        return true;
    }
    
    /*
     * Fungsi ini digunakan untuk menghapus isi tabel temporary pada saat proses genarate laporan posisi stok
     * @param String Nama tabel yang isinya akan dihapus
     * @param SrcReportPotitionStock Search key
     * @create gwawan@dimata 2008-02-17
     */
    public static void deleteHistory(String TBL_NAME, SrcReportPotitionStock objSrcReportPotitionStock) {
        try {
            System.out.println("== >> DELETE HISTORY in TABLE "+TBL_NAME+"; USER ID: "+objSrcReportPotitionStock.getUserId());
            String sql = "DELETE FROM " + TBL_NAME;
            sql += " WHERE USER_ID = " + objSrcReportPotitionStock.getUserId();
            DBHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
    
    /**
     * Fungsi ini digunakan untuk mendapatkan nilai stok dari laporan posisi stok
     * @param SrcReportPotitionStock instance dari SrcReportPotitionStock
     * @return Vector Merupakan objek yang menampung jumlah dari list stok dan nilai stok
     * @created by gwawan@20080121
     */
    public static Vector getGrandTotalReportPosisiStockAll(SrcReportPotitionStock srcReportPotitionStock, boolean isCalculateZeroQty) {
        DBResultSet dbrs = null;
        Vector list = new Vector();
        String sql = "";
        Vector stockValue = new Vector(1,1);
        
        double stockValueBegin = 0;
        double stockValueOpname = 0;
        double stockValueReceive = 0;
        double stockValueDispatch = 0;
        double stockValueReturn = 0;
        double stockValueSale = 0;
        double stockValueReturnCust = 0;
        double stockValueClosing = 0;
        
        double grandTotalStockValueBegin = 0;
        double grandTotalStockValueOpname = 0;
        double grandTotalStockValueReceive = 0;
        double grandTotalStockValueDispatch = 0;
        double grandTotalStockValueReturn = 0;
        double grandTotalStockValueSale = 0;
        double grandTotalStockValueReturnCust = 0;
        double grandTotalStockValueClosing = 0;
        
        try {
            /** mencari daftar semua stok */
            Vector vect = new Vector(1,1);
            vect = getReportStockAll(srcReportPotitionStock, isCalculateZeroQty, 0, 0);
            
            /** untuk mencari posisi stock */
            if (vect != null && vect.size() > 0) {
                for (int k = 0; k < vect.size(); k++) {
                    Vector vt = (Vector) vect.get(k);
                    Material material = (Material) vt.get(0);
                    MaterialStock materialStock = (MaterialStock) vt.get(1);
                    Unit unit = (Unit) vt.get(2);
                    
                    MaterialStock matStock = new MaterialStock();
                    Vector vctTemp = new Vector(1,1);
                    
                    stockValueBegin = 0;
                    stockValueOpname = 0;
                    stockValueReceive = 0;
                    stockValueDispatch = 0;
                    stockValueReturn = 0;
                    stockValueSale = 0;
                    stockValueReturnCust = 0;
                    stockValueClosing = 0;
                    
                    /** get qty opname */
                    sql = "SELECT QTY_OPNAME,OPNAME_ITEM_ID,TRS_DATE, (QTY_OPNAME * COGS_PRICE) AS STOCK_VALUE_OPNAME FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID = " + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    sql += " AND OPNAME_ITEM_ID != 0 ORDER BY TRS_DATE DESC";
                    
                    dbrs = DBHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    
                    Date date = new Date();
                    boolean withOpBool = false;
                    while (rs.next()) {
                        withOpBool = true;
                        matStock.setOpnameQty(rs.getDouble("QTY_OPNAME"));
                        date = DBHandler.convertDate(rs.getDate("TRS_DATE"), rs.getTime("TRS_DATE"));
                        stockValueOpname = rs.getDouble("STOCK_VALUE_OPNAME");
                        break;
                    }
                                         
                    /** get qty all */
                    sql = "SELECT SUM(QTY_RECEIVE) AS RECEIVE, SUM(QTY_RECEIVE * COGS_PRICE) AS STOCK_VALUE_RECEIVE";
                    sql+= ", SUM(QTY_DISPATCH) AS DISPATCH, SUM(QTY_DISPATCH * COGS_PRICE) AS STOCK_VALUE_DISPATCH";
                    sql+= ", SUM(QTY_RETURN) AS RETUR, SUM(QTY_RETURN * COGS_PRICE) AS STOCK_VALUE_RETURN";
                    sql+= ", SUM(QTY_SALE) AS SALE, SUM(QTY_SALE * COGS_PRICE) AS STOCK_VALUE_SALE";
                    sql+= ", SUM(QTY_RETURN_CUST) AS RETURN_CUST, SUM(QTY_RETURN_CUST * COGS_PRICE) AS STOCK_VALUE_RETURN_CUST";
                    sql+= " FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID=" + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    if (withOpBool) {
                        sql = sql + " AND TRS_DATE > '" + Formater.formatDate(date,"yyyy-MM-dd")+" "+Formater.formatTimeLocale(date,"kk:mm:ss") + "'";
                    }
                    sql = sql + " GROUP BY MATERIAL_ID";
                    
                    dbrs = DBHandler.execQueryResult(sql);
                    rs = dbrs.getResultSet();
                    while (rs.next()) {
                        matStock.setQtyIn(rs.getDouble("RECEIVE"));
                        matStock.setQtyOut(rs.getDouble("DISPATCH"));
                        matStock.setQtyMin(rs.getDouble("RETUR"));
                        matStock.setSaleQty(rs.getDouble("SALE"));
                        matStock.setQtyMax(rs.getDouble("RETURN_CUST"));
                        stockValueReceive = rs.getDouble("STOCK_VALUE_RECEIVE");
                        stockValueDispatch = rs.getDouble("STOCK_VALUE_DISPATCH");
                        stockValueReturn = rs.getDouble("STOCK_VALUE_RETURN");
                        stockValueSale = rs.getDouble("STOCK_VALUE_SALE");
                        stockValueReturnCust = rs.getDouble("STOCK_VALUE_RETURN_CUST");
                    }
                    
                    /** get begin stock */
                    //matStock.setQty(reportQtyAwalPosisiStock(material.getOID(), materialStock.getLocationId()));
                    Vector vctBeginQty = getBeginQty(material.getOID(), materialStock.getLocationId(), srcReportPotitionStock.getUserId());
                    matStock.setQty(Double.parseDouble((String)vctBeginQty.get(0)));
                    stockValueBegin = Double.parseDouble((String)vctBeginQty.get(1));
                    /** end get begin stock */
                    
                    /** get end stock */
                    /*if (withOpBool) {
                        matStock.setClosingQty((matStock.getOpnameQty() + matStock.getQtyIn()+ matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueOpname+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    } else {
                        matStock.setClosingQty((matStock.getQtyIn() + matStock.getQty() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueBegin+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    }*/
                    
                    /** get end stock */
                    if (withOpBool) {
                        matStock.setClosingQty((matStock.getOpnameQty() + matStock.getQtyIn() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueOpname+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    } else {
                        matStock.setClosingQty((matStock.getQtyIn() + matStock.getQty() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueBegin+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    }
                    
                    grandTotalStockValueBegin += stockValueBegin;
                    grandTotalStockValueOpname += stockValueOpname;
                    grandTotalStockValueReceive += stockValueReceive;
                    grandTotalStockValueDispatch += stockValueDispatch;
                    grandTotalStockValueReturn += stockValueReturn;
                    grandTotalStockValueSale += stockValueSale;
                    grandTotalStockValueReturnCust += stockValueReturnCust;
                    grandTotalStockValueClosing += stockValueClosing;                    
                }
            }
            
            stockValue.add(STOCK_VALUE_BEGIN, String.valueOf(grandTotalStockValueBegin));
            stockValue.add(STOCK_VALUE_OPNAME, String.valueOf(grandTotalStockValueOpname));
            stockValue.add(STOCK_VALUE_RECEIVE, String.valueOf(grandTotalStockValueReceive));
            stockValue.add(STOCK_VALUE_DISPATCH, String.valueOf(grandTotalStockValueDispatch));
            stockValue.add(STOCK_VALUE_RETURN, String.valueOf(grandTotalStockValueReturn));
            stockValue.add(STOCK_VALUE_SALE, String.valueOf(grandTotalStockValueSale));
            stockValue.add(STOCK_VALUE_RETURN_CUST, String.valueOf(grandTotalStockValueReturnCust));
            stockValue.add(STOCK_VALUE_CLOSING, String.valueOf(grandTotalStockValueClosing));
            
            list.add(String.valueOf(vect.size()));
            list.add(stockValue);
            
        } catch (Exception e) {
            System.out.println("Exc. in getGrandTotalReportPosisiStockAll(#,#) : " + e.toString());
        }
        return list;
    }



    /**
     * Fungsi ini digunakan untuk mendapatkan list stok
     * @param SrcReportPotitionStock Objek untuk melakukan pencarian
     * @param boolean Kondisi untuk menentukkan apakah proses kalkulasi melibatkan stok bernilai nol
     * @param int Start list
     * @param int Banyaknya list yang harus ditampilkan
     * @return Vector yang menampung instance dari class Material, MaterialStock dan Unit
     * @create by gwawan@dimata 3 Jan 2008
     * @updated by gwawan@dimata 17 Jan 2008
     */
    public static Vector getReportStockAll(SrcReportPotitionStock srcReportPotitionStock, boolean isZero, int limitStart, int recordToGet) {
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "SELECT M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] + // SKU
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] + // NAME
                    ", MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] + // QTY
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_NAME] + //UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST] + // DEFAULT_COST
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_PRICE] + // DEFAULT_PRICE
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] + // BUYING_UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] + // STOCK_UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] + // SELLING_PRICE
                    ", MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] + // QTY
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE] + //UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST_CURRENCY_ID] + // DEFAULT_COST_CURRENCY_ID
                    ", MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] + // LOCATION
                    " FROM " + PstMaterialStock.TBL_MATERIAL_STOCK + " AS MS " + //  MATERIAL_STOCK
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " AS M " + // MATERIAL
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] + // MATERIAL_STOCK_ID
                    " LEFT JOIN " + PstUnit.TBL_P2_UNIT + " AS U " + //UNIT
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " LEFT JOIN " + PstCategory.TBL_CATEGORY + " AS C " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] +
                    " = C." + PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID] +
                    " WHERE MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] + " = " + srcReportPotitionStock.getPeriodeId() +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + " = " + PstMaterial.MAT_TYPE_REGULAR +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_PROCESS_STATUS] + " != " + PstMaterial.DELETE;
            
            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] + " = " + srcReportPotitionStock.getLocationId();
            }
            
            if(srcReportPotitionStock.getMerkId()!=0){
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MERK_ID] + " = " + srcReportPotitionStock.getMerkId();
            }
            
            if(srcReportPotitionStock.getCategoryId()!=0){
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + " = " + srcReportPotitionStock.getCategoryId();
            }
            
            if (!isZero) {
                sql = sql + " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] + " <> 0";
            }
            
            sql = sql + " ORDER BY " +
                    " M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU];
            
            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    
                    break;
                    
                case DBHandler.DBSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    
                    break;
                    
                case DBHandler.DBSVR_SYBASE:
                    break;
                    
                case DBHandler.DBSVR_ORACLE:
                    break;
                    
                case DBHandler.DBSVR_MSSQL:
                    break;
                    
                default:
                    ;
            }
            
            System.out.println("SessReportPotitionStock.getReportStockAll(#,#,#,#) : "+sql);
            System.out.print("proses generate report....  ");
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                Vector vectTemp = new Vector(1, 1);
                
                // calculate cost per stock unit id
                double costPerBuyUnit = rs.getDouble(5);
                long buyUnitId = rs.getLong(7);
                long stockUnitId = rs.getLong(8);
                double qtyPerStockUnit = PstUnit.getQtyPerBaseUnit(buyUnitId, stockUnitId);
                double costPerStockUnit = costPerBuyUnit / qtyPerStockUnit;
                
                Material material = new Material();
                material.setSku(rs.getString(1));
                material.setName(rs.getString(2));
                material.setDefaultCost(costPerStockUnit);
                material.setDefaultPrice(rs.getDouble(6));
                material.setAveragePrice(rs.getDouble(9));// * standarRate);
                material.setOID(rs.getLong(10));
                vectTemp.add(material);
                
                MaterialStock materialStock = new MaterialStock();
                materialStock.setQty(rs.getDouble(3));
                materialStock.setLocationId(rs.getLong(PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID]));
                vectTemp.add(materialStock);
                
                Unit unit = new Unit();
                unit.setName(rs.getString(4));
                unit.setCode(rs.getString(11));
                vectTemp.add(unit);
                
                result.add(vectTemp);
            }
            
            rs.close();
            System.out.println("OK!");
        } catch (Exception e) {
            System.out.println("Exc on SessReportPotitionStock.getReportStockAll(#,#,#,#) : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }


    /**
     * Fungsi ini digunakan untuk mendapatkan list stok
     * @param SrcReportPotitionStock Objek untuk melakukan pencarian
     * @param boolean Kondisi untuk menentukkan apakah proses kalkulasi melibatkan stok bernilai nol
     * @param int Start list
     * @param int Banyaknya list yang harus ditampilkan
     * @return Vector yang menampung instance dari class Material, MaterialStock dan Unit
     * @create by gwawan@dimata 3 Jan 2008
     * @updated by gwawan@dimata 17 Jan 2008
     * @modified by mirah@dimata 22 Feb 2011
     */
    public static void getReportStockAll(JspWriter out, int infoShowed, int stockValueBy, int language,int start, SrcReportPotitionStock srcReportPotitionStock, boolean isZero, int limitStart, int recordToGet, String cellStyle) {
    //public static void getReportStockAll(JspWriter out, int infoShowed, int stockValueBy, int language,int start, SrcReportPotitionStock srcReportPotitionStock, int limitStart, int recordToGet, String cellStyle) {
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "SELECT M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] + // SKU
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] + // NAME
                    ", MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] + // QTY
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_NAME] + //UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST] + // DEFAULT_COST
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_PRICE] + // DEFAULT_PRICE
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] + // BUYING_UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] + // STOCK_UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] + // SELLING_PRICE
                    ", MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] + // QTY
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE] + //UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST_CURRENCY_ID] + // DEFAULT_COST_CURRENCY_ID
                    ", MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] + // LOCATION
                    " FROM " + PstMaterialStock.TBL_MATERIAL_STOCK + " AS MS " + //  MATERIAL_STOCK
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " AS M " + // MATERIAL
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] + // MATERIAL_STOCK_ID
                    " LEFT JOIN " + PstUnit.TBL_P2_UNIT + " AS U " + //UNIT
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " LEFT JOIN " + PstCategory.TBL_CATEGORY + " AS C " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] +
                    " = C." + PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID] +
                    " WHERE MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] + " = " + srcReportPotitionStock.getPeriodeId() +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + " = " + PstMaterial.MAT_TYPE_REGULAR +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_PROCESS_STATUS] + " != " + PstMaterial.DELETE;

            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] + " = " + srcReportPotitionStock.getLocationId();
            }

            if(srcReportPotitionStock.getMerkId()!=0){
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MERK_ID] + " = " + srcReportPotitionStock.getMerkId();
            }

            if(srcReportPotitionStock.getCategoryId()!=0){
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + " = " + srcReportPotitionStock.getCategoryId();
            }

            if (!isZero) {
                sql = sql + " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] + " <> 0";
            }

            sql = sql + " ORDER BY " +
                    " M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU];

            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;

                    break;

                case DBHandler.DBSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;

                    break;

                case DBHandler.DBSVR_SYBASE:
                    break;

                case DBHandler.DBSVR_ORACLE:
                    break;

                case DBHandler.DBSVR_MSSQL:
                    break;

                default:
                    ;
            }

            System.out.println("SessReportPotitionStock.getReportStockAll(#,#,#,#) : "+sql);
            System.out.print("proses generate report....  ");
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double stockValueBegin = 0;
            double stockValueOpname = 0;
            double stockValueReceive = 0;
            double stockValueDispatch = 0;
            double stockValueReturn = 0;
            double stockValueSale = 0;
            double stockValueReturnCust = 0;
            double stockValueClosing = 0;

            double subTotalStockValueBegin = 0;
            double subTotalStockValueOpname = 0;
            double subTotalStockValueReceive = 0;
            double subTotalStockValueDispatch = 0;
            double subTotalStockValueReturn = 0;
            double subTotalStockValueSale = 0;
            double subTotalStockValueReturnCust = 0;
            double subTotalStockValueClosing = 0;

            while (rs.next()) {
                //Vector vectTemp = new Vector(1, 1);

                // calculate cost per stock unit id
                double costPerBuyUnit = rs.getDouble(5);
                long buyUnitId = rs.getLong(7);
                long stockUnitId = rs.getLong(8);
                double qtyPerStockUnit = PstUnit.getQtyPerBaseUnit(buyUnitId, stockUnitId);
                double costPerStockUnit = costPerBuyUnit / qtyPerStockUnit;

                Material material = new Material();
                material.setSku(rs.getString(1));
                material.setName(rs.getString(2));
                material.setDefaultCost(costPerStockUnit);
                material.setDefaultPrice(rs.getDouble(6));
                material.setAveragePrice(rs.getDouble(9));// * standarRate);
                material.setOID(rs.getLong(10));
                //vectTemp.add(material);

                MaterialStock materialStock = new MaterialStock();
                materialStock.setQty(rs.getDouble(3));
                materialStock.setLocationId(rs.getLong(PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID]));
                //vectTemp.add(materialStock);

                Unit unit = new Unit();
                unit.setName(rs.getString(4));
                unit.setCode(rs.getString(11));
                //vectTemp.add(unit);

                MaterialStock matStock = new MaterialStock();
                Vector vctTemp = new Vector(1,1);
                Vector stockValue = new Vector(1,1);

                    stockValueBegin = 0;
                    stockValueOpname = 0;
                    stockValueReceive = 0;
                    stockValueDispatch = 0;
                    stockValueReturn = 0;
                    stockValueSale = 0;
                    stockValueReturnCust = 0;
                    stockValueClosing = 0;

                     /** get qty opname */
                    sql = "SELECT QTY_OPNAME,OPNAME_ITEM_ID,TRS_DATE, (QTY_OPNAME * COGS_PRICE) AS STOCK_VALUE_OPNAME FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID = " + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    sql += " AND OPNAME_ITEM_ID != 0 ORDER BY TRS_DATE DESC";

                    dbrs = DBHandler.execQueryResult(sql);
                    ResultSet rsx = dbrs.getResultSet();

                    Date date = new Date();
                    boolean withOpBool = false;
                    while (rsx.next()) {
                        withOpBool = true;
                        matStock.setOpnameQty(rsx.getDouble("QTY_OPNAME"));
                        date = DBHandler.convertDate(rsx.getDate("TRS_DATE"), rsx.getTime("TRS_DATE"));
                        stockValueOpname = rsx.getDouble("STOCK_VALUE_OPNAME");
                        break;
                    }

                    /** get qty all (meanggantikan query diatas)*/
                    sql = "SELECT SUM(QTY_RECEIVE) AS RECEIVE, SUM(QTY_RECEIVE * COGS_PRICE) AS STOCK_VALUE_RECEIVE";
                    sql+= ", SUM(QTY_DISPATCH) AS DISPATCH, SUM(QTY_DISPATCH * COGS_PRICE) AS STOCK_VALUE_DISPATCH";
                    sql+= ", SUM(QTY_RETURN) AS RETUR, SUM(QTY_RETURN * COGS_PRICE) AS STOCK_VALUE_RETURN";
                    sql+= ", SUM(QTY_SALE) AS SALE, SUM(QTY_SALE * COGS_PRICE) AS STOCK_VALUE_SALE";
                    sql+= ", SUM(QTY_RETURN_CUST) AS RETURN_CUST, SUM(QTY_RETURN_CUST * COGS_PRICE) AS STOCK_VALUE_RETURN_CUST";
                    sql+= " FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID=" + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    /** kondisi ini berfungsi untuk membatasi transaksi (receive, dispatch, return, sale) yang harus diproses,
                     * dimana hanya transaksi yang terjadi setelah (tanggal dan waktu) proses opname saja yang perlu di proses
                     */
                    if (withOpBool) {
                        sql = sql + " AND TRS_DATE > '" + Formater.formatDate(date,"yyyy-MM-dd")+" "+Formater.formatTimeLocale(date,"kk:mm:ss") + "'";
                    }
                    sql = sql + " GROUP BY MATERIAL_ID";

                    dbrs = DBHandler.execQueryResult(sql);
                    rsx = dbrs.getResultSet();
                    while (rsx.next()) {
                        matStock.setQtyIn(rsx.getDouble("RECEIVE"));
                        matStock.setQtyOut(rsx.getDouble("DISPATCH"));
                        matStock.setQtyMin(rsx.getDouble("RETUR"));
                        matStock.setSaleQty(rsx.getDouble("SALE"));
                        matStock.setQtyMax(rsx.getDouble("RETURN_CUST"));
                        stockValueReceive = rsx.getDouble("STOCK_VALUE_RECEIVE");
                        stockValueDispatch = rsx.getDouble("STOCK_VALUE_DISPATCH");
                        stockValueReturn = rsx.getDouble("STOCK_VALUE_RETURN");
                        stockValueSale = rsx.getDouble("STOCK_VALUE_SALE");
                        stockValueReturnCust = rsx.getDouble("STOCK_VALUE_RETURN_CUST");
                    }

                    /** get begin stock */
                    //matStock.setQty(reportQtyAwalPosisiStock(material.getOID(), materialStock.getLocationId()));
                    Vector vctBeginQty = getBeginQty(material.getOID(), materialStock.getLocationId(), srcReportPotitionStock.getUserId());
                    matStock.setQty(Double.parseDouble((String)vctBeginQty.get(0)));
                    stockValueBegin = Double.parseDouble((String)vctBeginQty.get(1));
                    /** end get begin stock */

                    /** get end stock */
                    if (withOpBool) {
                        matStock.setClosingQty((matStock.getOpnameQty() + matStock.getQtyIn() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueOpname+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    } else {
                        matStock.setClosingQty((matStock.getQtyIn() + matStock.getQty() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueBegin+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    }

                    stockValue.add(STOCK_VALUE_BEGIN, String.valueOf(stockValueBegin));
                    stockValue.add(STOCK_VALUE_OPNAME, String.valueOf(stockValueOpname));
                    stockValue.add(STOCK_VALUE_RECEIVE, String.valueOf(stockValueReceive));
                    stockValue.add(STOCK_VALUE_DISPATCH, String.valueOf(stockValueDispatch));
                    stockValue.add(STOCK_VALUE_RETURN, String.valueOf(stockValueReturn));
                    stockValue.add(STOCK_VALUE_SALE, String.valueOf(stockValueSale));
                    stockValue.add(STOCK_VALUE_RETURN_CUST, String.valueOf(stockValueReturnCust));
                    stockValue.add(STOCK_VALUE_CLOSING, String.valueOf(stockValueClosing));

                    //subTotal
                     subTotalStockValueBegin += stockValueBegin;
                     subTotalStockValueOpname += stockValueOpname;
                     subTotalStockValueReceive += stockValueReceive;
                     subTotalStockValueDispatch += stockValueDispatch;
                     subTotalStockValueReturn += stockValueReturn;
                     subTotalStockValueSale += stockValueSale;
                     subTotalStockValueReturnCust += stockValueReturnCust;
                     subTotalStockValueClosing += stockValueClosing;

                     System.out.println("Sub Total :" +subTotalStockValueClosing);

                out.print("<tr valign=\"top\">") ;

                     out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+String.valueOf(start+1)+".</div></td>");
                     out.print("<td class=\""+cellStyle+ "\" div align=\"left\">"+material.getSku()+"</div></td>");
                     out.print("<td class=\""+cellStyle+ "\" div align=\"left\">"+material.getName()+"</div></td>");

               
                if((infoShowed == SrcReportPotitionStock.SHOW_VALUE_ONLY && stockValueBy == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) ||
                   (infoShowed == SrcReportPotitionStock.SHOW_BOTH && stockValueBy == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER)) {
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(material.getAveragePrice())+"</div></td>"); // HPP/COGS
                }

                if(infoShowed == SrcReportPotitionStock.SHOW_QTY_ONLY || infoShowed == SrcReportPotitionStock.SHOW_BOTH) {
                    out.print("<td class=\""+cellStyle+ "\" div align=\"center\">"+unit.getCode()+"</div>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(matStock.getQty())+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(matStock.getOpnameQty())+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(matStock.getQtyIn())+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(matStock.getQtyOut())+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(matStock.getQtyMin())+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(matStock.getSaleQty())+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(matStock.getQtyMax())+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(matStock.getClosingQty())+"</div></td>");
                } else if(infoShowed == SrcReportPotitionStock.SHOW_VALUE_ONLY) {
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(stockValueBegin)+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(stockValueOpname)+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(stockValueReceive)+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(stockValueDispatch)+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(stockValueReturn)+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(stockValueSale)+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(stockValueReturnCust)+"</div></td>");
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(stockValueClosing)+"</div></td>");
                }

                if(infoShowed == SrcReportPotitionStock.SHOW_BOTH) {
                    out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(stockValueClosing)+"</div>");
                }

               out.print("</tr>");
               start++;
                //result.add(vectTemp);
            }

            //gui jsp subtotal
              if(infoShowed == SrcReportPotitionStock.SHOW_VALUE_ONLY) {
                    out.print("<tr valign=\"top\">") ;

                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"left\"><b>Sub Total</b></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"left\"></div></td>");


                    if(stockValueBy == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER){
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>"); // HPP/COGS
                    }

                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(subTotalStockValueBegin)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(subTotalStockValueOpname)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(subTotalStockValueReceive)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(subTotalStockValueDispatch)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(subTotalStockValueReturn)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(subTotalStockValueSale)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(subTotalStockValueReturnCust)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(subTotalStockValueClosing)+"</div></td>");
                    out.print("</tr>");
                }
                else if (infoShowed == SrcReportPotitionStock.SHOW_BOTH) {
                     out.print("<tr valign=\"top\">") ;

                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      //out.print("<td class=\""+cellStyle+ "\" div align=\"left\"><b>Sub Total</b></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"left\"><b>Sub Total</b></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"left\"></div></td>");

                    if(stockValueBy == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER){
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>"); // HPP/COGS
                    }

                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(subTotalStockValueClosing)+"</div></td>");
                    out.print("</tr>");
                  }
            //end of gui jsp sub total

            rs.close();
            System.out.println("OK!");
        } catch (Exception e) {
            System.out.println("Exc on SessReportPotitionStock.getReportStockAll(#,#,#,#) : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return;
        }
    }

     /**
     * Fungsi ini digunakan untuk mendapatkan Grand total list stok
     * @param SrcReportPotitionStock Objek untuk melakukan pencarian
     * @param boolean Kondisi untuk menentukkan apakah proses kalkulasi melibatkan stok bernilai nol
     * @param int Start list
     * @param int Banyaknya list yang harus ditampilkan
     * @return Vector yang menampung instance dari class Material, MaterialStock dan Unit
     * @create by gwawan@dimata 3 Jan 2008
     * @updated by gwawan@dimata 17 Jan 2008
     * @modified by mirah@dimata 22 Feb 2011
     */
    public static void getGrandTotalReportStockAll(JspWriter out, int infoShowed, int stockValueBy, int language,int start, SrcReportPotitionStock srcReportPotitionStock, boolean isZero, int limitStart, int recordToGet, String cellStyle) {
    //public static void getReportStockAll(JspWriter out, int infoShowed, int stockValueBy, int language,int start, SrcReportPotitionStock srcReportPotitionStock, int limitStart, int recordToGet, String cellStyle) {
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "SELECT M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] + // SKU
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] + // NAME
                    ", MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] + // QTY
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_NAME] + //UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST] + // DEFAULT_COST
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_PRICE] + // DEFAULT_PRICE
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] + // BUYING_UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] + // STOCK_UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] + // SELLING_PRICE
                    ", MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] + // QTY
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE] + //UNIT
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST_CURRENCY_ID] + // DEFAULT_COST_CURRENCY_ID
                    ", MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] + // LOCATION
                    " FROM " + PstMaterialStock.TBL_MATERIAL_STOCK + " AS MS " + //  MATERIAL_STOCK
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " AS M " + // MATERIAL
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] + // MATERIAL_STOCK_ID
                    " LEFT JOIN " + PstUnit.TBL_P2_UNIT + " AS U " + //UNIT
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " LEFT JOIN " + PstCategory.TBL_CATEGORY + " AS C " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] +
                    " = C." + PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID] +
                    " WHERE MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] + " = " + srcReportPotitionStock.getPeriodeId() +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + " = " + PstMaterial.MAT_TYPE_REGULAR +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_PROCESS_STATUS] + " != " + PstMaterial.DELETE;

            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] + " = " + srcReportPotitionStock.getLocationId();
            }

            if(srcReportPotitionStock.getMerkId()!=0){
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MERK_ID] + " = " + srcReportPotitionStock.getMerkId();
            }

            if(srcReportPotitionStock.getCategoryId()!=0){
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + " = " + srcReportPotitionStock.getCategoryId();
            }

            if (!isZero) {
                sql = sql + " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] + " <> 0";
            }

            sql = sql + " ORDER BY " +
                    " M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU];

            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;

                    break;

                case DBHandler.DBSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;

                    break;

                case DBHandler.DBSVR_SYBASE:
                    break;

                case DBHandler.DBSVR_ORACLE:
                    break;

                case DBHandler.DBSVR_MSSQL:
                    break;

                default:
                    ;
            }

            System.out.println("SessReportPotitionStock.getReportStockAll(#,#,#,#) : "+sql);
            System.out.print("proses generate report....  ");
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double stockValueBegin = 0;
            double stockValueOpname = 0;
            double stockValueReceive = 0;
            double stockValueDispatch = 0;
            double stockValueReturn = 0;
            double stockValueSale = 0;
            double stockValueReturnCust = 0;
            double stockValueClosing = 0;
            
            double grandTotalStockValueBegin = 0;
            double grandTotalStockValueOpname = 0;
            double grandTotalStockValueReceive = 0;
            double grandTotalStockValueDispatch = 0;
            double grandTotalStockValueReturn = 0;
            double grandTotalStockValueSale = 0;
            double grandTotalStockValueReturnCust = 0;
            double grandTotalStockValueClosing = 0;
            //double grandTotalStockValueClosing2 = 0;

            while (rs.next()) {
                Vector vectTemp = new Vector(1, 1);

                // calculate cost per stock unit id
                double costPerBuyUnit = rs.getDouble(5);
                long buyUnitId = rs.getLong(7);
                long stockUnitId = rs.getLong(8);
                double qtyPerStockUnit = PstUnit.getQtyPerBaseUnit(buyUnitId, stockUnitId);
                double costPerStockUnit = costPerBuyUnit / qtyPerStockUnit;

                Material material = new Material();
                material.setSku(rs.getString(1));
                material.setName(rs.getString(2));
                material.setDefaultCost(costPerStockUnit);
                material.setDefaultPrice(rs.getDouble(6));
                material.setAveragePrice(rs.getDouble(9));// * standarRate);
                material.setOID(rs.getLong(10));
                vectTemp.add(material);

                MaterialStock materialStock = new MaterialStock();
                materialStock.setQty(rs.getDouble(3));
                materialStock.setLocationId(rs.getLong(PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID]));
                vectTemp.add(materialStock);

                Unit unit = new Unit();
                unit.setName(rs.getString(4));
                unit.setCode(rs.getString(11));
                vectTemp.add(unit);

                MaterialStock matStock = new MaterialStock();
                Vector vctTemp = new Vector(1,1);
                Vector stockValue = new Vector(1,1);

                    stockValueBegin = 0;
                    stockValueOpname = 0;
                    stockValueReceive = 0;
                    stockValueDispatch = 0;
                    stockValueReturn = 0;
                    stockValueSale = 0;
                    stockValueReturnCust = 0;
                    stockValueClosing = 0;

                     /** get qty opname */
                    sql = "SELECT QTY_OPNAME,OPNAME_ITEM_ID,TRS_DATE, (QTY_OPNAME * COGS_PRICE) AS STOCK_VALUE_OPNAME FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID = " + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    sql += " AND OPNAME_ITEM_ID != 0 ORDER BY TRS_DATE DESC";

                    dbrs = DBHandler.execQueryResult(sql);
                    ResultSet rsx = dbrs.getResultSet();

                    Date date = new Date();
                    boolean withOpBool = false;
                    while (rsx.next()) {
                        withOpBool = true;
                        matStock.setOpnameQty(rsx.getDouble("QTY_OPNAME"));
                        date = DBHandler.convertDate(rsx.getDate("TRS_DATE"), rsx.getTime("TRS_DATE"));
                        stockValueOpname = rsx.getDouble("STOCK_VALUE_OPNAME");
                        break;
                    }

                    /** get qty all (meanggantikan query diatas)*/
                    sql = "SELECT SUM(QTY_RECEIVE) AS RECEIVE, SUM(QTY_RECEIVE * COGS_PRICE) AS STOCK_VALUE_RECEIVE";
                    sql+= ", SUM(QTY_DISPATCH) AS DISPATCH, SUM(QTY_DISPATCH * COGS_PRICE) AS STOCK_VALUE_DISPATCH";
                    sql+= ", SUM(QTY_RETURN) AS RETUR, SUM(QTY_RETURN * COGS_PRICE) AS STOCK_VALUE_RETURN";
                    sql+= ", SUM(QTY_SALE) AS SALE, SUM(QTY_SALE * COGS_PRICE) AS STOCK_VALUE_SALE";
                    sql+= ", SUM(QTY_RETURN_CUST) AS RETURN_CUST, SUM(QTY_RETURN_CUST * COGS_PRICE) AS STOCK_VALUE_RETURN_CUST";
                    sql+= " FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID=" + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    /** kondisi ini berfungsi untuk membatasi transaksi (receive, dispatch, return, sale) yang harus diproses,
                     * dimana hanya transaksi yang terjadi setelah (tanggal dan waktu) proses opname saja yang perlu di proses
                     */
                    
                    if (withOpBool) {
                        sql = sql + " AND TRS_DATE > '" + Formater.formatDate(date,"yyyy-MM-dd")+" "+Formater.formatTimeLocale(date,"kk:mm:ss") + "'";
                    }
                    sql = sql + " GROUP BY MATERIAL_ID";

                    dbrs = DBHandler.execQueryResult(sql);
                    rsx = dbrs.getResultSet();
                    while (rsx.next()) {
                        matStock.setQtyIn(rsx.getDouble("RECEIVE"));
                        matStock.setQtyOut(rsx.getDouble("DISPATCH"));
                        matStock.setQtyMin(rsx.getDouble("RETUR"));
                        matStock.setSaleQty(rsx.getDouble("SALE"));
                        matStock.setQtyMax(rsx.getDouble("RETURN_CUST"));
                        stockValueReceive = rsx.getDouble("STOCK_VALUE_RECEIVE");
                        stockValueDispatch = rsx.getDouble("STOCK_VALUE_DISPATCH");
                        stockValueReturn = rsx.getDouble("STOCK_VALUE_RETURN");
                        stockValueSale = rsx.getDouble("STOCK_VALUE_SALE");
                        stockValueReturnCust = rsx.getDouble("STOCK_VALUE_RETURN_CUST");
                    }

                    /** get begin stock */
                    //matStock.setQty(reportQtyAwalPosisiStock(material.getOID(), materialStock.getLocationId()));
                    Vector vctBeginQty = getBeginQty(material.getOID(), materialStock.getLocationId(), srcReportPotitionStock.getUserId());
                    matStock.setQty(Double.parseDouble((String)vctBeginQty.get(0)));
                    stockValueBegin = Double.parseDouble((String)vctBeginQty.get(1));
                    /** end get begin stock */

                    /** get end stock */
                    if (withOpBool) {
                        matStock.setClosingQty((matStock.getOpnameQty() + matStock.getQtyIn() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueOpname+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    } else {
                        matStock.setClosingQty((matStock.getQtyIn() + matStock.getQty() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueBegin+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    }
                    
                     

                    stockValue.add(STOCK_VALUE_BEGIN, String.valueOf(stockValueBegin));
                    stockValue.add(STOCK_VALUE_OPNAME, String.valueOf(stockValueOpname));
                    stockValue.add(STOCK_VALUE_RECEIVE, String.valueOf(stockValueReceive));
                    stockValue.add(STOCK_VALUE_DISPATCH, String.valueOf(stockValueDispatch));
                    stockValue.add(STOCK_VALUE_RETURN, String.valueOf(stockValueReturn));
                    stockValue.add(STOCK_VALUE_SALE, String.valueOf(stockValueSale));
                    stockValue.add(STOCK_VALUE_RETURN_CUST, String.valueOf(stockValueReturnCust));
                    stockValue.add(STOCK_VALUE_CLOSING, String.valueOf(stockValueClosing));

                     grandTotalStockValueBegin += stockValueBegin;
                     grandTotalStockValueOpname += stockValueOpname;
                     grandTotalStockValueReceive += stockValueReceive;
                     grandTotalStockValueDispatch += stockValueDispatch;
                     grandTotalStockValueReturn += stockValueReturn;
                     grandTotalStockValueSale += stockValueSale;
                     grandTotalStockValueReturnCust += stockValueReturnCust;
                     grandTotalStockValueClosing += stockValueClosing;

                     System.out.println("No. " +start++);
                     System.out.println(". Grand Total :" +grandTotalStockValueClosing);
   
            }
                //grandTotalStockValueClosing2 += stockValueClosing;
                //System.out.println("Grand Total :" +grandTotalStockValueClosing);
         
              if(infoShowed == SrcReportPotitionStock.SHOW_VALUE_ONLY) {
                    out.print("<tr valign=\"top\">") ;

                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"left\"><b>Grand Total</b></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"left\"></div></td>");


                    if(stockValueBy == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER){
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>"); // HPP/COGS
                    }

                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(grandTotalStockValueBegin)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(grandTotalStockValueOpname)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(grandTotalStockValueReceive)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(grandTotalStockValueDispatch)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(grandTotalStockValueReturn)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(grandTotalStockValueSale)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(grandTotalStockValueReturnCust)+"</div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(grandTotalStockValueClosing)+"</div></td>");
                    out.print("</tr>");
               //start++;
                //result.add(vectTemp);
                }
                else if (infoShowed == SrcReportPotitionStock.SHOW_BOTH) {
                     out.print("<tr valign=\"top\">") ;

                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      //out.print("<td class=\""+cellStyle+ "\" div align=\"left\"><b>Sub Total</b></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"left\"><b>Grand Total</b></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"left\"></div></td>");

                    if(stockValueBy == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER){
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>"); // HPP/COGS
                    }

                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\"></div></td>");
                      out.print("<td class=\""+cellStyle+ "\" div align=\"right\">"+FRMHandler.userFormatStringDecimal(grandTotalStockValueClosing)+"</div></td>");
                    out.print("</tr>");
                   start++;
                }

            rs.close();
            System.out.println("OK!");
        } catch (Exception e) {
            System.out.println("Exc on SessReportPotitionStock.getReportStockAll(#,#,#,#) : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return;
        }
    }

    /**
     * Fungsi ini digunakan untuk mendapatkan  count list stok
     * @param SrcReportPotitionStock Objek untuk melakukan pencarian
     * @param boolean Kondisi untuk menentukkan apakah proses kalkulasi melibatkan stok bernilai nol
     * @param int Start list
     * @param int Banyaknya list yang harus ditampilkan
     * @return Vector yang menampung instance dari class Material, MaterialStock dan Unit
     * @create by gwawan@dimata 3 Jan 2008
     * @updated by gwawan@dimata 17 Jan 2008
     * @modified by mirah@dimata 25 Feb 2011
     */
    public static int getCountReportStockAll(SrcReportPotitionStock srcReportPotitionStock, boolean isZero, int limitStart, int recordToGet) {
        int count = 0;
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "SELECT COUNT(MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] +
                    ") AS CNT FROM " + PstMaterialStock.TBL_MATERIAL_STOCK + " AS MS " + //  MATERIAL_STOCK
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " AS M " + // MATERIAL
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] + // MATERIAL_STOCK_ID
                    " LEFT JOIN " + PstUnit.TBL_P2_UNIT + " AS U " + //UNIT
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " LEFT JOIN " + PstCategory.TBL_CATEGORY + " AS C " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] +
                    " = C." + PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID] +
                    " WHERE MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] + " = " + srcReportPotitionStock.getPeriodeId() +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + " = " + PstMaterial.MAT_TYPE_REGULAR +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_PROCESS_STATUS] + " != " + PstMaterial.DELETE;

            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] + " = " + srcReportPotitionStock.getLocationId();
            }

            if(srcReportPotitionStock.getMerkId()!=0){
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MERK_ID] + " = " + srcReportPotitionStock.getMerkId();
            }

            if(srcReportPotitionStock.getCategoryId()!=0){
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + " = " + srcReportPotitionStock.getCategoryId();
            }

            if (!isZero) {
                sql = sql + " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] + " <> 0";
            }

            sql = sql + " ORDER BY " +
                    " M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU];

            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;

                    break;

                case DBHandler.DBSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;

                    break;

                case DBHandler.DBSVR_SYBASE:
                    break;

                case DBHandler.DBSVR_ORACLE:
                    break;

                case DBHandler.DBSVR_MSSQL:
                    break;

                default:
                    ;
            }

            System.out.println("SessReportPotitionStock.getReportStockAll(#,#,#,#) : "+sql);
            System.out.print("proses generate report....  ");
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
               count = rs.getInt(1);
            }

            rs.close();
            System.out.println("OK!");
        } catch (Exception e) {
            System.out.println("Exc on SessReportPotitionStock.getCountReportStockAll(#,#,#,#) : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return count;
        }
    }

    public static void insertSelectOpname(String TBL_NAME, SrcReportPotitionStock srcReportPotitionStock) {
        try {
            String sql = "INSERT INTO " + TBL_NAME +
                    " (SUB_CATEGORY_NAME, OPNAME_ITEM_ID, TRS_DATE, SUB_CATEGORY_ID, SUPPLIER_ID, MATERIAL_ID," +
                    " BARCODE,MATERIAL,SELL_PRICE,UNIT,QTY_OPNAME, LOCATION_ID, COGS_PRICE, USER_ID) " +
                    " SELECT DISTINCT " +
                    " SO." + PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_STOCK_OPNAME_NUMBER] +
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ITEM_ID] +
                    ", SO." + PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_STOCK_OPNAME_DATE] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_OPNAME] + // " ,SUM(RMI."+PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_QTY]+") "+
                    ", SO." + PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_LOCATION_ID];
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql += ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE];
            } else if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_TRANSACTION) {
                sql += ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_COST];
            } else {
                sql += ", 0";
            }
            sql += ", " + srcReportPotitionStock.getUserId();
            sql +=  " FROM " + PstMaterial.TBL_MATERIAL + " AS M " +
                    " INNER JOIN " + PstUnit.TBL_P2_UNIT + " AS U ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " INNER JOIN " + PstMatStockOpnameItem.TBL_STOCK_OPNAME_ITEM + " AS SOI " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstMatStockOpname.TBL_MAT_STOCK_OPNAME + " AS SO " +
                    " ON SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ID] +
                    " = SO." + PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_STOCK_OPNAME_ID] +
                    " WHERE SO." + PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_STOCK_OPNAME_DATE] +
                    " BETWEEN '" + Formater.formatDate(srcReportPotitionStock.getDateFrom(), "yyyy-MM-dd 00:00:00") + "' AND '" + Formater.formatDate(srcReportPotitionStock.getDateTo(), "yyyy-MM-dd 23:59:59") + "'" +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + "=" + PstMaterial.MAT_TYPE_REGULAR;
            
            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND SO." + PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_LOCATION_ID] + "=" + srcReportPotitionStock.getLocationId();
            }
            if (srcReportPotitionStock.getSupplierId() != 0) {
                //sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] + "=" + srcReportPotitionStock.getSupplierId();
            }
            
            if (srcReportPotitionStock.getCategoryId() != 0) {
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + "=" + srcReportPotitionStock.getCategoryId();
            }
            
            if (srcReportPotitionStock.getSubCategoryId() != 0) {
                // sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] + "=" + srcReportPotitionStock.getSubCategoryId();
            }
            
            //sql = sql + " AND MR." + PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_STOCK_OPNAME_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_POSTED;
            //sql = sql + " GROUP BY M."+PstMaterial.fieldNames[PstMaterial.FLD_SKU];
            //sql = sql + " GROUP BY RMI."+PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID];
            
            sql += " AND SO."+PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_STOCK_OPNAME_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_DRAFT;
            sql += " AND SO."+PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_STOCK_OPNAME_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_FINAL;
            
            //System.out.println("SQL OPNAME : " + sql);
            int i = DBHandler.execSqlInsert(sql);
            
        } catch (Exception e) {
        }
    }
    
    public static void insertSelectReceive(String TBL_NAME, SrcReportPotitionStock srcReportPotitionStock) {
        DBResultSet dbrs = null;
        try {
            String sql = "INSERT INTO " + TBL_NAME +
                    " (SUB_CATEGORY_NAME, TRS_DATE, SUB_CATEGORY_ID, SUPPLIER_ID, MATERIAL_ID, BARCODE, MATERIAL," +
                    " SELL_PRICE, UNIT, QTY_RECEIVE, UNIT_ID, BASE_UNIT_ID, ITEM_ID, LOCATION_ID, COGS_PRICE, USER_ID) " +
                    " SELECT DISTINCT " +
                    " MR." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] +
                    ", MR." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
                    ", MRI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_QTY] +
                    ", MRI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_UNIT_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", MRI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ITEM_ID] +
                    ", MR." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID];
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql += ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE];
            } else if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_TRANSACTION) {
                sql += ", (MR." + PstMatReceive.fieldNames[PstMatReceive.FLD_TRANS_RATE];
                sql += " * (MRI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_COST];
                sql += " + MRI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_FORWADER_COST] + "))";
                
            } else {
                sql += ", 0";
            }
            sql += ", " + srcReportPotitionStock.getUserId();
            sql +=  " FROM " + PstMaterial.TBL_MATERIAL + " AS M " +
                    " INNER JOIN " + PstUnit.TBL_P2_UNIT + " AS U ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " INNER JOIN " + PstMatReceiveItem.TBL_MAT_RECEIVE_ITEM + " AS MRI " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = MRI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstMatReceive.TBL_MAT_RECEIVE + " AS MR " +
                    " ON MRI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ID] +
                    " = MR." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] +
                    " WHERE MR." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
                    " BETWEEN '" + Formater.formatDate(srcReportPotitionStock.getDateFrom(), "yyyy-MM-dd 00:00:00") + "' AND '" + Formater.formatDate(srcReportPotitionStock.getDateTo(), "yyyy-MM-dd 23:59:59") + "'" +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + "=" + PstMaterial.MAT_TYPE_REGULAR;
            
            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND MR." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] + "=" + srcReportPotitionStock.getLocationId();
            }
            
            if (srcReportPotitionStock.getSupplierId() != 0) {
                // sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] + "=" + srcReportPotitionStock.getSupplierId();
            }
            
            if (srcReportPotitionStock.getCategoryId() != 0) {
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + "=" + srcReportPotitionStock.getCategoryId();
            }
            
            if (srcReportPotitionStock.getSubCategoryId() != 0) {
                //sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] + "=" + srcReportPotitionStock.getSubCategoryId();
            }
            
            //sql = sql + " AND (MR." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_POSTED +
            //        " OR MR." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_CLOSED + ")";
            //sql = sql + " GROUP BY M."+PstMaterial.fieldNames[PstMaterial.FLD_SKU];
            //sql = sql + " GROUP BY RMI."+PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID];
            
            sql += " AND MR."+PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_DRAFT;
            sql += " AND MR."+PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_FINAL;
            
            //System.out.println("SQL RECEIVE : " + sql);
            int i = DBHandler.execSqlInsert(sql);
            // untuk mengalikan qty sesuai dengan base unit
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql = "SELECT * FROM " + TBL_NAME;
                dbrs = DBHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {
                    long unitId = rs.getLong("UNIT_ID");
                    long baseUnitId = rs.getLong("BASE_UNIT_ID");
                    
                    double qtyBase = PstUnit.getQtyPerBaseUnit(unitId, baseUnitId);
                    sql = "UPDATE " + TBL_NAME + " SET QTY_RECEIVE = " + (rs.getDouble("QTY_RECEIVE") * qtyBase);
                    sql+= " WHERE ITEM_ID = " + rs.getLong("ITEM_ID") + " AND MATERIAL_ID = " + rs.getLong("MATERIAL_ID")+";";
                    DBHandler.execUpdate(sql);
                }
            }
            //System.out.println("====>>>> END TRANSFER DATA RECEIVE");
        } catch (Exception e) {
            System.out.println("Exc. in insertSelectReceive(#,#) >> " + e.toString());
        }
    }
    
    public static void insertSelectReturn(String TBL_NAME, SrcReportPotitionStock srcReportPotitionStock) {
        DBResultSet dbrs = null;
        try {
            String sql = "INSERT INTO " + TBL_NAME +
                    " (SUB_CATEGORY_NAME, TRS_DATE, SUB_CATEGORY_ID, SUPPLIER_ID, MATERIAL_ID,"+
                    " BARCODE,MATERIAL, SELL_PRICE, UNIT, QTY_RETURN, UNIT_ID, BASE_UNIT_ID, ITEM_ID, LOCATION_ID, COGS_PRICE, USER_ID) " +
                    " SELECT DISTINCT " +
                    " MR." + PstMatReturn.fieldNames[PstMatReturn.FLD_RET_CODE] +
                    ", MR." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_DATE] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
                    ", MRI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_QTY] + // " ,SUM(RMI."+PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_QTY]+") "+
                    ", MRI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_UNIT_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", MRI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_RETURN_MATERIAL_ITEM_ID] +
                    ", MR." + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID];
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql += ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE];
            } else if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_TRANSACTION) {
                sql += ", (MRI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_COST];
                sql += " * MR." + PstMatReturn.fieldNames[PstMatReturn.FLD_TRANS_RATE] + ")";
            } else {
                sql += ", 0";
            }
            sql += ", " + srcReportPotitionStock.getUserId();
            sql +=  " FROM " + PstMaterial.TBL_MATERIAL + " AS M " +
                    " INNER JOIN " + PstUnit.TBL_P2_UNIT + " AS U ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " INNER JOIN " + PstMatReturnItem.TBL_MAT_RETURN_ITEM + " AS MRI " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = MRI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstMatReturn.TBL_MAT_RETURN + " AS MR " +
                    " ON MRI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_RETURN_MATERIAL_ID] +
                    " = MR." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_MATERIAL_ID] +
                    " WHERE MR." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_DATE] +
                    " BETWEEN '" + Formater.formatDate(srcReportPotitionStock.getDateFrom(), "yyyy-MM-dd 00:00:00") + "' AND '" + Formater.formatDate(srcReportPotitionStock.getDateTo(), "yyyy-MM-dd 23:23:59") + "'" +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + "=" + PstMaterial.MAT_TYPE_REGULAR;
            
            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND MR." + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] + "=" + srcReportPotitionStock.getLocationId();
            }
            
            if (srcReportPotitionStock.getSupplierId() != 0) {
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] + "=" + srcReportPotitionStock.getSupplierId();
            }
            
            if (srcReportPotitionStock.getCategoryId() != 0) {
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + "=" + srcReportPotitionStock.getCategoryId();
            }
            
            if (srcReportPotitionStock.getSubCategoryId() != 0) {
                // sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] + "=" + srcReportPotitionStock.getSubCategoryId();
            }
            
            //sql = sql + " AND (MR." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_POSTED +
            //        " OR MR." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_CLOSED + ")";
            //sql = sql + " GROUP BY M."+PstMaterial.fieldNames[PstMaterial.FLD_SKU];
            
            sql += " AND MR."+PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_DRAFT;
            sql += " AND MR."+PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_FINAL;
            
            // System.out.println("SQL RETUR : " + sql);
            int i = DBHandler.execSqlInsert(sql);
            
            // untuk mengalikan qty sesuai dengan base unit
            //System.out.println("====>>>> START TRANSFER DATA RETURN");
            sql = "SELECT * FROM " + TBL_NAME;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long unitId = rs.getLong("UNIT_ID");
                long baseUnitId = rs.getLong("BASE_UNIT_ID");
                
                double qtyBase = PstUnit.getQtyPerBaseUnit(unitId, baseUnitId);
                sql = "UPDATE " + TBL_NAME + " SET QTY_RETURN = " + (rs.getDouble("QTY_RETURN") * qtyBase);
                sql+= " WHERE ITEM_ID = " + rs.getLong("ITEM_ID") + " AND MATERIAL_ID = " + rs.getLong("MATERIAL_ID");
                DBHandler.execUpdate(sql);
            }
            //System.out.println("====>>>> END TRANSFER DATA RETURN");
            
        } catch (Exception e) {
        }
    }
    
    public static void insertSelectDispatch(String TBL_NAME, SrcReportPotitionStock srcReportPotitionStock) {
        DBResultSet dbrs = null;
        try {
            String sql = "INSERT INTO " + TBL_NAME +
                    " (SUB_CATEGORY_NAME, TRS_DATE, SUB_CATEGORY_ID, SUPPLIER_ID, MATERIAL_ID, BARCODE, MATERIAL, SELL_PRICE," +
                    " UNIT, QTY_DISPATCH, UNIT_ID, BASE_UNIT_ID, ITEM_ID, LOCATION_ID, COGS_PRICE, USER_ID) " +
                    " SELECT DISTINCT " +
                    " MD." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_CODE] +
                    ", MD." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
                    ", MDI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_QTY] + // " ,SUM(RMI."+PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_QTY]+") "+
                    ", MDI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_UNIT_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", MDI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ID] +
                    ", MD." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID];
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql += ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE];
            } else if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_TRANSACTION) {
                sql += ", MDI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_HPP];
            } else {
                sql += ", 0";
            }
            sql += ", " + srcReportPotitionStock.getUserId();
            sql +=  " FROM " + PstMaterial.TBL_MATERIAL + " AS M " +
                    " INNER JOIN " + PstUnit.TBL_P2_UNIT + " AS U ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " INNER JOIN " + PstMatDispatchItem.TBL_MAT_DISPATCH_ITEM + " AS MDI " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = MDI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstMatDispatch.TBL_DISPATCH + " AS MD " +
                    " ON MDI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ID] +
                    " = MD." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_MATERIAL_ID] +
                    " WHERE MD." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE] +
                    " BETWEEN '" + Formater.formatDate(srcReportPotitionStock.getDateFrom(), "yyyy-MM-dd 00:00:00") + "' AND '" + Formater.formatDate(srcReportPotitionStock.getDateTo(), "yyyy-MM-dd 23:59:59") + "'" +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + "=" + PstMaterial.MAT_TYPE_REGULAR;
            
            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND MD." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] + "=" + srcReportPotitionStock.getLocationId();
            }
            
            if (srcReportPotitionStock.getSupplierId() != 0) {
                //sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] + "=" + srcReportPotitionStock.getSupplierId();
            }
            
            if (srcReportPotitionStock.getCategoryId() != 0) {
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + "=" + srcReportPotitionStock.getCategoryId();
            }
            
            if (srcReportPotitionStock.getSubCategoryId() != 0) {
                // sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] + "=" + srcReportPotitionStock.getSubCategoryId();
            }
            
            //sql = sql + " AND (MR." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_CLOSED +
            //       " OR MR." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_POSTED + ")";
            //sql = sql + " GROUP BY M."+PstMaterial.fieldNames[PstMaterial.FLD_SKU];
            //sql = sql + " GROUP BY RMI."+PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID];
            
            sql += " AND MD."+PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_DRAFT;
            sql += " AND MD."+PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_FINAL;
            
            //System.out.println("SQL DISPATCH : " + sql);
            int i = DBHandler.execSqlInsert(sql);
            // untuk mengalikan qty sesuai dengan base unit
            //System.out.println("====>>>> START TRANSFER DATA DISPATCH");
            sql = "SELECT * FROM " + TBL_NAME;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long unitId = rs.getLong("UNIT_ID");
                long baseUnitId = rs.getLong("BASE_UNIT_ID");
                
                double qtyBase = PstUnit.getQtyPerBaseUnit(unitId, baseUnitId);
                sql = "UPDATE " + TBL_NAME + " SET QTY_DISPATCH = " + (rs.getDouble("QTY_DISPATCH") * qtyBase);
                sql+= " WHERE ITEM_ID = " + rs.getLong("ITEM_ID") + " AND MATERIAL_ID = " + rs.getLong("MATERIAL_ID");
                DBHandler.execUpdate(sql);
            }
            //System.out.println("====>>>> END TRANSFER DATA DISPATCH");
            
        } catch (Exception e) {
        }
    }
    
    public static void insertSelectCosting(String TBL_NAME, SrcReportPotitionStock srcReportPotitionStock) {
        DBResultSet dbrs = null;
        try {
            String sql = "INSERT INTO " + TBL_NAME +
                    " (SUB_CATEGORY_NAME, TRS_DATE, SUB_CATEGORY_ID, SUPPLIER_ID, MATERIAL_ID, BARCODE, MATERIAL," +
                    " SELL_PRICE, UNIT, QTY_DISPATCH, UNIT_ID, BASE_UNIT_ID, ITEM_ID, LOCATION_ID, COGS_PRICE, USER_ID) " +
                    " SELECT DISTINCT " +
                    " MC." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE] +
                    ", MC." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
                    ", MCI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_QTY] + // " ,SUM(RMI."+PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_QTY]+") "+
                    ", MCI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_UNIT_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", MCI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_COSTING_MATERIAL_ITEM_ID] +
                    ", MC." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID];
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql += ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE];
            } else if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_TRANSACTION) {
                sql += ", MCI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_HPP];
            } else {
                sql += ", 0";
            }
            sql += ", " + srcReportPotitionStock.getUserId();
            sql +=  " FROM " + PstMaterial.TBL_MATERIAL + " AS M " +
                    " INNER JOIN " + PstUnit.TBL_P2_UNIT + " AS U ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " INNER JOIN " + PstMatCostingItem.TBL_MAT_COSTING_ITEM + " AS MCI " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = MCI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstMatCosting.TBL_COSTING + " AS MC " +
                    " ON MCI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_COSTING_MATERIAL_ID] +
                    " = MC." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_MATERIAL_ID] +
                    " WHERE MC." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                    " BETWEEN '" + Formater.formatDate(srcReportPotitionStock.getDateFrom(), "yyyy-MM-dd 00:00:00") + "' AND '" + Formater.formatDate(srcReportPotitionStock.getDateTo(), "yyyy-MM-dd 23:59:59") + "'" +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + "=" + PstMaterial.MAT_TYPE_REGULAR;
            
            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND MC." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] + "=" + srcReportPotitionStock.getLocationId();
            }
            
            if (srcReportPotitionStock.getSupplierId() != 0) {
                //sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] + "=" + srcReportPotitionStock.getSupplierId();
            }
            
            if (srcReportPotitionStock.getCategoryId() != 0) {
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + "=" + srcReportPotitionStock.getCategoryId();
            }
            
            if (srcReportPotitionStock.getSubCategoryId() != 0) {
                // sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] + "=" + srcReportPotitionStock.getSubCategoryId();
            }
            
            //sql = sql + " AND (MR." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_CLOSED +
            //       " OR MR." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_POSTED + ")";
            //sql = sql + " GROUP BY M."+PstMaterial.fieldNames[PstMaterial.FLD_SKU];
            //sql = sql + " GROUP BY RMI."+PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID];
            
            sql += " AND MC."+PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_DRAFT;
            sql += " AND MC."+PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_FINAL;
            
            //System.out.println("SQL COSTING : " + sql);
            int i = DBHandler.execSqlInsert(sql);
            // untuk mengalikan qty sesuai dengan base unit
            //System.out.println("====>>>> START TRANSFER DATA COSTING");
            sql = "SELECT * FROM " + TBL_NAME;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long unitId = rs.getLong("UNIT_ID");
                long baseUnitId = rs.getLong("BASE_UNIT_ID");
                
                double qtyBase = PstUnit.getQtyPerBaseUnit(unitId, baseUnitId);
                sql = "UPDATE " + TBL_NAME + " SET QTY_DISPATCH = " + (rs.getDouble("QTY_DISPATCH") * qtyBase);
                sql+= " WHERE ITEM_ID = " + rs.getLong("ITEM_ID") + " AND MATERIAL_ID = " + rs.getLong("MATERIAL_ID");
                DBHandler.execUpdate(sql);
            }
            //System.out.println("====>>>> END TRANSFER DATA DISPATCH");
            
        } catch (Exception e) {
        }
    }
    
    public static void insertSelectSale(String TBL_NAME, SrcReportPotitionStock srcReportPotitionStock) {
        DBResultSet dbrs = null;
        try {
            String sql = "INSERT INTO " + TBL_NAME +
                    " (SUB_CATEGORY_NAME, TRS_DATE, SUB_CATEGORY_ID, SUPPLIER_ID, MATERIAL_ID, BARCODE, MATERIAL, SELL_PRICE," +
                    " UNIT, QTY_SALE, UNIT_ID, BASE_UNIT_ID, ITEM_ID, LOCATION_ID, COGS_PRICE, USER_ID) " +
                    " SELECT DISTINCT " +
                    " BM." + PstBillMain.fieldNames[PstBillMain.FLD_INVOICE_NUMBER] +
                    ", BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE];
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql += ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_QTY_STOCK];
            } else if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_TRANSACTION) {
                sql += ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_QUANTITY];
            }
            sql +=  ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_UNIT_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_DETAIL_ID] +
                    ", BM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID];
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql += ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE];
            } else if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_TRANSACTION) {
                sql += ", (BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_ITEM_PRICE];
                sql += " * BM." + PstBillMain.fieldNames[PstBillMain.FLD_RATE] + ")";
            } else {
                sql += ", 0";
            }
            sql += ", " + srcReportPotitionStock.getUserId();
            sql +=  " FROM " + PstMaterial.TBL_MATERIAL + " AS M " +
                    " INNER JOIN " + PstUnit.TBL_P2_UNIT + " AS U ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " INNER JOIN " + PstBillDetail.TBL_CASH_BILL_DETAIL + " AS BD " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS BM " +
                    " ON BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] +
                    " = BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] +
                    " WHERE BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                    " BETWEEN '" + Formater.formatDate(srcReportPotitionStock.getDateFrom(), "yyyy-MM-dd 00:00:00") + "' AND '" + Formater.formatDate(srcReportPotitionStock.getDateTo(), "yyyy-MM-dd 23:59:59") + "'" +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + "=" + PstMaterial.MAT_TYPE_REGULAR +
                    " AND BM." + PstBillMain.fieldNames[PstBillMain.FLD_DOC_TYPE] + "=" + PstBillMain.TYPE_INVOICE +
                    " AND BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_DRAFT +
                    " AND BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_FINAL;
            
            
            String sql2 = "INSERT INTO " + TBL_NAME +
                    " (SUB_CATEGORY_NAME, TRS_DATE, SUB_CATEGORY_ID, SUPPLIER_ID, MATERIAL_ID, BARCODE, MATERIAL," +
                    " SELL_PRICE, UNIT, QTY_RETURN_CUST, UNIT_ID, BASE_UNIT_ID, ITEM_ID, LOCATION_ID, COGS_PRICE, USER_ID) " +
                    " SELECT DISTINCT " +
                    " BM." + PstBillMain.fieldNames[PstBillMain.FLD_INVOICE_NUMBER] +
                    ", BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    ", U." + PstUnit.fieldNames[PstUnit.FLD_CODE];
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql2 += ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_QTY_STOCK];
            } else if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_TRANSACTION) {
                sql2 += ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_QUANTITY];
            }
            sql2 += ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_UNIT_ID] +
                    ", M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_DETAIL_ID] +
                    ", BM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID];
            if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_MASTER) {
                sql2 += ", M." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE];
            } else if(srcReportPotitionStock.getStockValueBy() == SrcReportPotitionStock.STOCK_VALUE_BY_COGS_TRANSACTION) {
                sql2 += ", (BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_ITEM_PRICE];
                sql2 += " * BM." + PstBillMain.fieldNames[PstBillMain.FLD_RATE] + ")";
            } else {
                sql2 += ", 0";
            }
            sql2 += ", " + srcReportPotitionStock.getUserId();
            sql2 +=  " FROM " + PstMaterial.TBL_MATERIAL + " AS M " +
                    " INNER JOIN " + PstUnit.TBL_P2_UNIT + " AS U ON M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = U." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " INNER JOIN " + PstBillDetail.TBL_CASH_BILL_DETAIL + " AS BD " +
                    " ON M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS BM " +
                    " ON BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] +
                    " = BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] +
                    " WHERE BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                    " BETWEEN '" + Formater.formatDate(srcReportPotitionStock.getDateFrom(), "yyyy-MM-dd 00:00:00") + "' AND '" + Formater.formatDate(srcReportPotitionStock.getDateTo(), "yyyy-MM-dd 23:59:59") + "'" +
                    " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_TYPE] + "=" + PstMaterial.MAT_TYPE_REGULAR +
                    " AND BM." + PstBillMain.fieldNames[PstBillMain.FLD_DOC_TYPE] + "=" + PstBillMain.TYPE_RETUR +
                    " AND BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_DRAFT +
                    " AND BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS]+" != "+I_DocStatus.DOCUMENT_STATUS_FINAL;
            
            if(srcReportPotitionStock.getLocationId() != 0) {
                sql += " AND BM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + "=" + srcReportPotitionStock.getLocationId();
                sql2 += " AND BM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + "=" + srcReportPotitionStock.getLocationId();
            }
            
            if (srcReportPotitionStock.getCategoryId() != 0) {
                sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + "=" + srcReportPotitionStock.getCategoryId();
                sql2 = sql2 + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + "=" + srcReportPotitionStock.getCategoryId();
            }
            
            if (srcReportPotitionStock.getSupplierId() != 0) {
                //sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUPPLIER_ID] + "=" + srcReportPotitionStock.getSupplierId();
            }
            
            if (srcReportPotitionStock.getSubCategoryId() != 0) {
                // sql = sql + " AND M." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] + "=" + srcReportPotitionStock.getSubCategoryId();
            }
            
            //sql = sql + " AND (MR." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_POSTED +
            //        " OR MR." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_CLOSED + ")";
            //sql2 = sql2 + " AND (MR." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_POSTED +
            //        " OR MR." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_CLOSED + ")";
            //sql = sql + " GROUP BY M."+PstMaterial.fieldNames[PstMaterial.FLD_SKU];
            //sql = sql + " GROUP BY RMI."+PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID];
            
            
            //System.out.println("SQL PENJUALAN : " + sql+"\n");
            int i = DBHandler.execSqlInsert(sql);
            /** Proses ini tidak diperlukan lagi, karena field qty_stock merupakan qty berdasarkan unit dari stock
             * // untuk mengalikan qty sesuai dengan base unit
             * //System.out.println("====>>>> START TRANSFER DATA INVOICE");
             * sql = "SELECT * FROM " + TBL_NAME;
             * dbrs = DBHandler.execQueryResult(sql);
             * ResultSet rs = dbrs.getResultSet();
             * while (rs.next()) {
             * long unitId = rs.getLong("UNIT_ID");
             * long baseUnitId = rs.getLong("BASE_UNIT_ID");
             *
             * double qtyBase = PstUnit.getQtyPerBaseUnit(unitId, baseUnitId);
             * sql = "UPDATE " + TBL_NAME + " SET QTY_SALE = " + (rs.getDouble("QTY_SALE") * qtyBase);
             * sql+= " WHERE ITEM_ID = " + rs.getLong("ITEM_ID") + " AND MATERIAL_ID = " + rs.getLong("MATERIAL_ID");
             * DBHandler.execUpdate(sql);
             * }
             */
            //System.out.println("====>>>> END TRANSFER DATA INVOICE");
            
            //System.out.println("SQL RETUR PENJUALAN : " + sql2);
            int a = DBHandler.execSqlInsert(sql2);
            /** Proses ini tidak diperlukan lagi, karena field qty_stock merupakan qty berdasarkan unit dari stock
             * // untuk mengalikan qty sesuai dengan base unit
             * //System.out.println("====>>>> START TRANSFER DATA CUSTOMER RETURN");
             * sql2 = "SELECT * FROM " + TBL_NAME;
             * dbrs = DBHandler.execQueryResult(sql2);
             * ResultSet rs2 = dbrs.getResultSet();
             * while (rs2.next()) {
             * long unitId = rs2.getLong("UNIT_ID");
             * long baseUnitId = rs2.getLong("BASE_UNIT_ID");
             *
             * double qtyBase = PstUnit.getQtyPerBaseUnit(unitId, baseUnitId);
             * sql = "UPDATE " + TBL_NAME + " SET QTY_RETURN_CUST = " + (rs2.getDouble("QTY_RETURN_CUST") * qtyBase);
             * sql+= " WHERE ITEM_ID = " + rs2.getLong("ITEM_ID") + " AND MATERIAL_ID = " + rs2.getLong("MATERIAL_ID");
             * DBHandler.execUpdate(sql);
             * }
             */
            //System.out.println("====>>>> END TRANSFER DATA CUSTOMER RETURN");
            
        } catch (Exception e) {
            System.out.println("Error insert penjualan " + e.toString());
        }
    }
    
    /** Fungsi ini digunakan untuk mendapatkan laporan posisi stock. Fungsi ini dipanggil dari fungsi:
     * reportPosisiStock(boolean weekReport, int type, SrcReportPotitionStock srcReportPotitionStock, int language, boolean isZero, int pgStart, int pgNext)
     * create by: gwawan@dimata 13/09/2007
     * @param srcReportPotitionStock SrcReportPotitionStock
     * @param sql String
     */
    public static Vector reportPosisiStockAll(SrcReportPotitionStock srcReportPotitionStock, String sql, int start, int recordToGet, boolean isCalculateZeroQty) {
        DBResultSet dbrs = null;
        Vector list = new Vector();
        try {
            /** mencari daftar semua stok */
            Vector vect = new Vector(1,1);
            vect = getReportStockAll(srcReportPotitionStock, isCalculateZeroQty, start, recordToGet);
            
            double stockValueBegin = 0;
            double stockValueOpname = 0;
            double stockValueReceive = 0;
            double stockValueDispatch = 0;
            double stockValueReturn = 0;
            double stockValueSale = 0;
            double stockValueReturnCust = 0;
            double stockValueClosing = 0;
            
            /** untuk mencari posisi stock */
            if (vect != null && vect.size() > 0) {
                for (int k = 0; k < vect.size(); k++) {
                    Vector vt = (Vector) vect.get(k);
                    Material material = (Material) vt.get(0);
                    MaterialStock materialStock = (MaterialStock) vt.get(1);
                    Unit unit = (Unit) vt.get(2);
                    
                    MaterialStock matStock = new MaterialStock();
                    Vector vctTemp = new Vector(1,1);
                    Vector stockValue = new Vector(1,1);
                    
                    stockValueBegin = 0;
                    stockValueOpname = 0;
                    stockValueReceive = 0;
                    stockValueDispatch = 0;
                    stockValueReturn = 0;
                    stockValueSale = 0;
                    stockValueReturnCust = 0;
                    stockValueClosing = 0;
                    
                    /** get qty opname */
                    sql = "SELECT QTY_OPNAME,OPNAME_ITEM_ID,TRS_DATE, (QTY_OPNAME * COGS_PRICE) AS STOCK_VALUE_OPNAME FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID = " + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    sql += " AND OPNAME_ITEM_ID != 0 ORDER BY TRS_DATE DESC";
                    
                    dbrs = DBHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    
                    Date date = new Date();
                    boolean withOpBool = false;
                    while (rs.next()) {
                        withOpBool = true; 
                        matStock.setOpnameQty(rs.getDouble("QTY_OPNAME"));
                        date = DBHandler.convertDate(rs.getDate("TRS_DATE"), rs.getTime("TRS_DATE"));
                        stockValueOpname = rs.getDouble("STOCK_VALUE_OPNAME");
                        break;
                    }
                    
                    /** get qty all (meanggantikan query diatas)*/
                    sql = "SELECT SUM(QTY_RECEIVE) AS RECEIVE, SUM(QTY_RECEIVE * COGS_PRICE) AS STOCK_VALUE_RECEIVE";
                    sql+= ", SUM(QTY_DISPATCH) AS DISPATCH, SUM(QTY_DISPATCH * COGS_PRICE) AS STOCK_VALUE_DISPATCH";
                    sql+= ", SUM(QTY_RETURN) AS RETUR, SUM(QTY_RETURN * COGS_PRICE) AS STOCK_VALUE_RETURN";
                    sql+= ", SUM(QTY_SALE) AS SALE, SUM(QTY_SALE * COGS_PRICE) AS STOCK_VALUE_SALE";
                    sql+= ", SUM(QTY_RETURN_CUST) AS RETURN_CUST, SUM(QTY_RETURN_CUST * COGS_PRICE) AS STOCK_VALUE_RETURN_CUST";
                    sql+= " FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID=" + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    /** kondisi ini berfungsi untuk membatasi transaksi (receive, dispatch, return, sale) yang harus diproses,
                     * dimana hanya transaksi yang terjadi setelah (tanggal dan waktu) proses opname saja yang perlu di proses
                     */
                    if (withOpBool) {
                        sql = sql + " AND TRS_DATE > '" + Formater.formatDate(date,"yyyy-MM-dd")+" "+Formater.formatTimeLocale(date,"kk:mm:ss") + "'";
                    }
                    sql = sql + " GROUP BY MATERIAL_ID";
                    
                    dbrs = DBHandler.execQueryResult(sql);
                    rs = dbrs.getResultSet();
                    while (rs.next()) {
                        matStock.setQtyIn(rs.getDouble("RECEIVE"));
                        matStock.setQtyOut(rs.getDouble("DISPATCH"));
                        matStock.setQtyMin(rs.getDouble("RETUR"));
                        matStock.setSaleQty(rs.getDouble("SALE"));
                        matStock.setQtyMax(rs.getDouble("RETURN_CUST"));
                        stockValueReceive = rs.getDouble("STOCK_VALUE_RECEIVE");
                        stockValueDispatch = rs.getDouble("STOCK_VALUE_DISPATCH");
                        stockValueReturn = rs.getDouble("STOCK_VALUE_RETURN");
                        stockValueSale = rs.getDouble("STOCK_VALUE_SALE");
                        stockValueReturnCust = rs.getDouble("STOCK_VALUE_RETURN_CUST");
                    }
                    
                    /** get begin stock */
                    //matStock.setQty(reportQtyAwalPosisiStock(material.getOID(), materialStock.getLocationId()));
                    Vector vctBeginQty = getBeginQty(material.getOID(), materialStock.getLocationId(), srcReportPotitionStock.getUserId());
                    matStock.setQty(Double.parseDouble((String)vctBeginQty.get(0)));
                    stockValueBegin = Double.parseDouble((String)vctBeginQty.get(1));
                    /** end get begin stock */
                    
                    /** get end stock */
                    if (withOpBool) {
                        matStock.setClosingQty((matStock.getOpnameQty() + matStock.getQtyIn() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueOpname+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    } else {
                        matStock.setClosingQty((matStock.getQtyIn() + matStock.getQty() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueBegin+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    }
                    
                    stockValue.add(STOCK_VALUE_BEGIN, String.valueOf(stockValueBegin));
                    stockValue.add(STOCK_VALUE_OPNAME, String.valueOf(stockValueOpname));
                    stockValue.add(STOCK_VALUE_RECEIVE, String.valueOf(stockValueReceive));
                    stockValue.add(STOCK_VALUE_DISPATCH, String.valueOf(stockValueDispatch));
                    stockValue.add(STOCK_VALUE_RETURN, String.valueOf(stockValueReturn));
                    stockValue.add(STOCK_VALUE_SALE, String.valueOf(stockValueSale));
                    stockValue.add(STOCK_VALUE_RETURN_CUST, String.valueOf(stockValueReturnCust));
                    stockValue.add(STOCK_VALUE_CLOSING, String.valueOf(stockValueClosing));
                    
                    /** simpan kedalam vector, untuk selanjutnya diolah di JSP */
                    vctTemp.add(material);
                    vctTemp.add(matStock);
                    vctTemp.add(unit);
                    vctTemp.add(stockValue);
                    list.add(vctTemp); 
                }
            }
            
        } catch (Exception e) {
            System.out.println("Exc. in reportPosisiStockAll(#,#) : " + e.toString());
        }
        return list;
    }


    /** Fungsi ini digunakan untuk mendapatkan laporan posisi stock. Fungsi ini dipanggil dari fungsi:
     * reportPosisiStock(boolean weekReport, int type, SrcReportPotitionStock srcReportPotitionStock, int language, boolean isZero, int pgStart, int pgNext)
     * create by: gwawan@dimata 13/09/2007
     * Modified by Mirah@dimata 22/02/2011 tambah parameter jspWriter
     * @param srcReportPotitionStock SrcReportPotitionStock
     * @param sql String
     */
    public static  void reportPosisiStockAll(JspWriter out, SrcReportPotitionStock srcReportPotitionStock, String sql, int start, int recordToGet, boolean isCalculateZeroQty) {
        DBResultSet dbrs = null;
        Vector list = new Vector();
        try {
            /** mencari daftar semua stok */
            Vector vect = new Vector(1,1);
            //vect = getReportStockAll(out,srcReportPotitionStock, isCalculateZeroQty, start, recordToGet);

            double stockValueBegin = 0;
            double stockValueOpname = 0;
            double stockValueReceive = 0;
            double stockValueDispatch = 0;
            double stockValueReturn = 0;
            double stockValueSale = 0;
            double stockValueReturnCust = 0;
            double stockValueClosing = 0;

            /** untuk mencari posisi stock */
            if (vect != null && vect.size() > 0) {
                for (int k = 0; k < vect.size(); k++) {
                    Vector vt = (Vector) vect.get(k);
                    Material material = (Material) vt.get(0);
                    MaterialStock materialStock = (MaterialStock) vt.get(1);
                    Unit unit = (Unit) vt.get(2);

                    MaterialStock matStock = new MaterialStock();
                    Vector vctTemp = new Vector(1,1);
                    Vector stockValue = new Vector(1,1);

                    stockValueBegin = 0;
                    stockValueOpname = 0;
                    stockValueReceive = 0;
                    stockValueDispatch = 0;
                    stockValueReturn = 0;
                    stockValueSale = 0;
                    stockValueReturnCust = 0;
                    stockValueClosing = 0;

                    /** get qty opname */
                    sql = "SELECT QTY_OPNAME,OPNAME_ITEM_ID,TRS_DATE, (QTY_OPNAME * COGS_PRICE) AS STOCK_VALUE_OPNAME FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID = " + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    sql += " AND OPNAME_ITEM_ID != 0 ORDER BY TRS_DATE DESC";

                    dbrs = DBHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();

                    Date date = new Date();
                    boolean withOpBool = false;
                    while (rs.next()) {
                        withOpBool = true;
                        matStock.setOpnameQty(rs.getDouble("QTY_OPNAME"));
                        date = DBHandler.convertDate(rs.getDate("TRS_DATE"), rs.getTime("TRS_DATE"));
                        stockValueOpname = rs.getDouble("STOCK_VALUE_OPNAME");
                        break;
                    }

                    /** get qty all (meanggantikan query diatas)*/
                    sql = "SELECT SUM(QTY_RECEIVE) AS RECEIVE, SUM(QTY_RECEIVE * COGS_PRICE) AS STOCK_VALUE_RECEIVE";
                    sql+= ", SUM(QTY_DISPATCH) AS DISPATCH, SUM(QTY_DISPATCH * COGS_PRICE) AS STOCK_VALUE_DISPATCH";
                    sql+= ", SUM(QTY_RETURN) AS RETUR, SUM(QTY_RETURN * COGS_PRICE) AS STOCK_VALUE_RETURN";
                    sql+= ", SUM(QTY_SALE) AS SALE, SUM(QTY_SALE * COGS_PRICE) AS STOCK_VALUE_SALE";
                    sql+= ", SUM(QTY_RETURN_CUST) AS RETURN_CUST, SUM(QTY_RETURN_CUST * COGS_PRICE) AS STOCK_VALUE_RETURN_CUST";
                    sql+= " FROM " + TBL_MATERIAL_STOCK_REPORT;
                    sql += " WHERE MATERIAL_ID=" + material.getOID();
                    sql += " AND LOCATION_ID = " + materialStock.getLocationId();
                    sql += " AND USER_ID = " + srcReportPotitionStock.getUserId();
                    /** kondisi ini berfungsi untuk membatasi transaksi (receive, dispatch, return, sale) yang harus diproses,
                     * dimana hanya transaksi yang terjadi setelah (tanggal dan waktu) proses opname saja yang perlu di proses
                     */
                    if (withOpBool) {
                        sql = sql + " AND TRS_DATE > '" + Formater.formatDate(date,"yyyy-MM-dd")+" "+Formater.formatTimeLocale(date,"kk:mm:ss") + "'";
                    }
                    sql = sql + " GROUP BY MATERIAL_ID";

                    dbrs = DBHandler.execQueryResult(sql);
                    rs = dbrs.getResultSet();
                    while (rs.next()) {
                        matStock.setQtyIn(rs.getDouble("RECEIVE"));
                        matStock.setQtyOut(rs.getDouble("DISPATCH"));
                        matStock.setQtyMin(rs.getDouble("RETUR"));
                        matStock.setSaleQty(rs.getDouble("SALE"));
                        matStock.setQtyMax(rs.getDouble("RETURN_CUST"));
                        stockValueReceive = rs.getDouble("STOCK_VALUE_RECEIVE");
                        stockValueDispatch = rs.getDouble("STOCK_VALUE_DISPATCH");
                        stockValueReturn = rs.getDouble("STOCK_VALUE_RETURN");
                        stockValueSale = rs.getDouble("STOCK_VALUE_SALE");
                        stockValueReturnCust = rs.getDouble("STOCK_VALUE_RETURN_CUST");
                    }

                    /** get begin stock */
                    //matStock.setQty(reportQtyAwalPosisiStock(material.getOID(), materialStock.getLocationId()));
                    Vector vctBeginQty = getBeginQty(material.getOID(), materialStock.getLocationId(), srcReportPotitionStock.getUserId());
                    matStock.setQty(Double.parseDouble((String)vctBeginQty.get(0)));
                    stockValueBegin = Double.parseDouble((String)vctBeginQty.get(1));
                    /** end get begin stock */

                    /** get end stock */
                    if (withOpBool) {
                        matStock.setClosingQty((matStock.getOpnameQty() + matStock.getQtyIn() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueOpname+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    } else {
                        matStock.setClosingQty((matStock.getQtyIn() + matStock.getQty() + matStock.getQtyMax()) - (matStock.getQtyOut() + matStock.getQtyMin())-matStock.getSaleQty());
                        stockValueClosing = (stockValueBegin+stockValueReceive+stockValueReturnCust) - (stockValueDispatch+stockValueReturn) - stockValueSale;
                    }

                    stockValue.add(STOCK_VALUE_BEGIN, String.valueOf(stockValueBegin));
                    stockValue.add(STOCK_VALUE_OPNAME, String.valueOf(stockValueOpname));
                    stockValue.add(STOCK_VALUE_RECEIVE, String.valueOf(stockValueReceive));
                    stockValue.add(STOCK_VALUE_DISPATCH, String.valueOf(stockValueDispatch));
                    stockValue.add(STOCK_VALUE_RETURN, String.valueOf(stockValueReturn));
                    stockValue.add(STOCK_VALUE_SALE, String.valueOf(stockValueSale));
                    stockValue.add(STOCK_VALUE_RETURN_CUST, String.valueOf(stockValueReturnCust));
                    stockValue.add(STOCK_VALUE_CLOSING, String.valueOf(stockValueClosing));

                    /** simpan kedalam vector, untuk selanjutnya diolah di JSP */
                    vctTemp.add(material);
                    vctTemp.add(matStock);
                    vctTemp.add(unit);
                    vctTemp.add(stockValue);
                    list.add(vctTemp);
                }
            }

        } catch (Exception e) {
            System.out.println("Exc. in reportPosisiStockAll(#,#) : " + e.toString());
        }
        return ;
    }

    /**
     * Fungsi ini digunakan untuk mendapatkan qty awal untuk laporan posisi stock
     * @param long OID dari material yang akan dicari stock awalnya
     * @param long Merupakan OID location tempat material berada
     * @return Vector
     * @created gwawan@dimata 2008-01-29
     */
    public static Vector getBeginQty(long oidMaterial, long oidLocation, long oidUser) {
        DBResultSet dbrs = null;
        MaterialStock matStock = new MaterialStock();
        double stockValueOpname = 0;
        double stockValueReceive = 0;
        double stockValueDispatch = 0;
        double stockValueReturn = 0;
        double stockValueSale = 0;
        double stockValueReturnCust = 0;
        double stockValueClosing = 0;
        Vector result = new Vector(1,1);
        
        try {
            Date date = new Date();
            boolean withOpBool = false;
            
            /** get qty opname */
            String sql = "SELECT QTY_OPNAME,OPNAME_ITEM_ID,TRS_DATE, (QTY_OPNAME * COGS_PRICE) AS STOCK_VALUE_OPNAME";
            sql += " FROM " + TBL_MATERIAL_STOCK_REPORT_HIS;
            sql += " WHERE MATERIAL_ID = " + oidMaterial;
            sql += " AND LOCATION_ID = " + oidLocation;
            sql += " AND USER_ID = " + oidUser;
            sql += " AND OPNAME_ITEM_ID != 0 ORDER BY TRS_DATE DESC";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                withOpBool = true;
                matStock.setOpnameQty(rs.getDouble("QTY_OPNAME"));
                date = DBHandler.convertDate(rs.getDate("TRS_DATE"), rs.getTime("TRS_DATE"));
                stockValueOpname = rs.getDouble("STOCK_VALUE_OPNAME");
                break;
            }
            
            /** get qty all */
            sql = "SELECT SUM(QTY_RECEIVE) AS RECEIVE, SUM(QTY_RECEIVE * COGS_PRICE) AS STOCK_VALUE_RECEIVE";
            sql += ", SUM(QTY_DISPATCH) AS DISPATCH, SUM(QTY_DISPATCH * COGS_PRICE) AS STOCK_VALUE_DISPATCH";
            sql += ", SUM(QTY_RETURN) AS RETUR, SUM(QTY_RETURN * COGS_PRICE) AS STOCK_VALUE_RETURN";
            sql += ", SUM(QTY_SALE) AS SALE, SUM(QTY_SALE * COGS_PRICE) AS STOCK_VALUE_SALE";
            sql+= ", SUM(QTY_RETURN_CUST) AS RETURN_CUST, SUM(QTY_RETURN_CUST * COGS_PRICE) AS STOCK_VALUE_RETURN_CUST";
            sql += " FROM " + TBL_MATERIAL_STOCK_REPORT_HIS;
            sql += " WHERE MATERIAL_ID=" + oidMaterial;
            sql += " AND LOCATION_ID = " + oidLocation;
            sql += " AND USER_ID = " + oidUser;
            if (withOpBool) {
                sql = sql + " AND TRS_DATE > '" + Formater.formatDate(date,"yyyy-MM-dd")+" "+Formater.formatTimeLocale(date,"kk:mm:ss") + "'";
            }
            sql = sql + " GROUP BY MATERIAL_ID";
            
            dbrs = DBHandler.execQueryResult(sql);
            rs = dbrs.getResultSet();
            while (rs.next()) {
                matStock.setQtyIn(rs.getDouble("RECEIVE"));
                matStock.setQtyOut(rs.getDouble("DISPATCH"));
                matStock.setQtyMin(rs.getDouble("RETUR"));
                matStock.setSaleQty(rs.getDouble("SALE"));
                matStock.setQtyMax(rs.getDouble("RETURN_CUST"));
                stockValueReceive = rs.getDouble("STOCK_VALUE_RECEIVE");
                stockValueDispatch = rs.getDouble("STOCK_VALUE_DISPATCH");
                stockValueReturn = rs.getDouble("STOCK_VALUE_RETURN");
                stockValueSale = rs.getDouble("STOCK_VALUE_SALE");
                stockValueReturnCust = rs.getDouble("STOCK_VALUE_RETURN_CUST");
            }
            
            /** get end qty */
            if (withOpBool) {
                matStock.setClosingQty((matStock.getOpnameQty() + matStock.getQtyIn() + matStock.getQtyMax()) - matStock.getQtyOut() - matStock.getQtyMin() - matStock.getSaleQty());
                stockValueClosing = stockValueOpname + stockValueReceive + stockValueReturnCust - stockValueDispatch - stockValueReturn - stockValueSale;
            }else{
                matStock.setClosingQty(matStock.getQtyIn()  + matStock.getQtyMax() - matStock.getQtyOut() - matStock.getQtyMin() - matStock.getSaleQty());
                stockValueClosing = stockValueReceive + stockValueReturnCust - stockValueDispatch - stockValueReturn - stockValueSale;
            }
            
            result.add(String.valueOf(matStock.getClosingQty()));
            result.add(String.valueOf(stockValueClosing));
            
        } catch (Exception e) {
            System.out.println("Exc. in SessReportStock.getBeginQty(#,#) : " + e.toString());
        }
        
        return result;
    }
    
}
