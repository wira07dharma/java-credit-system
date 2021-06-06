/*
 * SessAr.java
 *
 * Created on July 20, 2005, 11:21 AM
 */

package com.dimata.posbo.session.sales;

import com.dimata.pos.entity.billing.PstBillDetail;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.pos.entity.payment.PstCashCreditPayment;
import com.dimata.pos.entity.payment.PstCreditPaymentMain;
import com.dimata.posbo.db.DBHandler;
import com.dimata.posbo.db.DBResultSet;
import com.dimata.posbo.entity.masterdata.PstMemberReg;
import com.dimata.posbo.entity.search.RptArInvoice;
import com.dimata.posbo.entity.search.RptArPayment;
import com.dimata.posbo.entity.search.SrcSaleReport;
import com.dimata.util.Formater;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;




/**
 *
 * @author  pulantara
 */
public class SessAr {
    
    /** Creates a new instance of SessAr */
    public SessAr() {
    }
    
    public static Vector getArInvoice(int start,int recordToGet, SrcSaleReport srcSaleReport){
        Vector result = new Vector();
        
        long locationId = srcSaleReport.getLocationId();
        String where = "BM."+PstBillMain.fieldNames[PstBillMain.FLD_TRANSCATION_TYPE]+" = "+PstBillMain.TRANS_TYPE_CREDIT+" AND BM."+
        PstBillMain.fieldNames[PstBillMain.FLD_TRANSACTION_STATUS]+" = "+srcSaleReport.getTransStatus()+
        //+DocType
        " AND BM."+ PstBillMain.fieldNames[PstBillMain.FLD_DOC_TYPE]+" = 0";
        if(srcSaleReport.getLocationId()>0){
            where = where + " AND BM."+PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID]+" = "+locationId;
        }
        
        String custNameText = srcSaleReport.getCustName();
        if(custNameText!=null&&custNameText.length()>0){
            String stCustName = " (CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME]+
            " LIKE '%"+custNameText+"%' OR CL."+
            PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_LASTNAME]+
            " LIKE '%"+custNameText+"%') ";
            where = where + " AND " + stCustName;
        }
        
        String custNameCode = srcSaleReport.getCustCode();
        if(custNameCode!=null&&custNameCode.length()>0){
            String stCustCode = " (CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BARCODE]+
            " LIKE '%"+custNameCode+"%'";
            where = where + " AND " + stCustCode;
        }
        
        if(srcSaleReport.getCurrencyOid() != 0) {
            where += " AND BM."+PstBillMain.fieldNames[PstBillMain.FLD_CURRENCY_ID]+" = "+srcSaleReport.getCurrencyOid();
        }
        
        if(srcSaleReport.getUseDate()==1){
            Date dtFrom = srcSaleReport.getDateFrom();
            Date dtTo = srcSaleReport.getDateTo();
            if(dtFrom!=null&&dtTo!=null){
                if(where!=null&&where.length()>0){
                    where = where + " AND (BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE]+
                    " BETWEEN '"+Formater.formatDate(dtFrom,"yyyy-MM-dd")+" 00:00:01'  "+
                    " AND '"+Formater.formatDate(dtTo,"yyyy-MM-dd")+" 23:59:00') ";
                }else{
                    where = where + " (BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE]+
                    " BETWEEN '"+Formater.formatDate(dtFrom,"yyyy-MM-dd")+" 00:00:01' "+
                    " AND '"+Formater.formatDate(dtTo,"yyyy-MM-dd")+" 23:59:00') ";
                }
            }
        }
        
        String order = "CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME]+
        ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE];
        
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "+
            " BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_INVOICE_NUMBER]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_NOTES]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE]+
            ", CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME]+
            ", SUM(BD."+PstBillDetail.fieldNames[PstBillDetail.FLD_TOTAL_PRICE]+")"+
            ", CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_DISCOUNT]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_TAX_VALUE]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_RATE]+
            " FROM " + PstBillMain.TBL_CASH_BILL_MAIN+ " AS BM "+
            " INNER JOIN "+PstMemberReg.TBL_CONTACT_LIST+ " AS CL "+
            " ON BM."+PstBillMain.fieldNames[PstBillMain.FLD_CUSTOMER_ID]+
            " = CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID]+
            " INNER JOIN "+PstBillDetail.TBL_CASH_BILL_DETAIL+" AS BD "+
            " ON BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]+
            " = BD."+PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID];
            
            sql = sql + " WHERE " + where;
            
            sql = sql + " GROUP BY "+
            " BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_INVOICE_NUMBER]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_NOTES]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE]+
            ", CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME]+
            ", CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID]+
            ", BM."+PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID];
            
            if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;
            
            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL :
                    if(start == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + start + ","+ recordToGet ;
                    break;
                case DBHandler.DBSVR_POSTGRESQL :
                    if(start == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " +recordToGet + " OFFSET "+ start ;
                    break;
                default:
                    if(start == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + start + ","+ recordToGet ;
            }
            //System.out.println("sql get AR Invoice : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                
                RptArInvoice temp = new RptArInvoice();
                long billMainId = rs.getLong(1);
                temp.setBillMainId(billMainId);
                temp.setInvoiceNo(rs.getString(2));
                temp.setNotes(rs.getString(3));
                temp.setBillDate(rs.getDate(4));
                temp.setCustName(rs.getString(5));
                double netTrans = rs.getDouble(6);
                temp.setMemberId(rs.getLong(7));
                temp.setSaleNetto(netTrans);
                temp.setLocationId(rs.getLong(8));
                setPaymentForArInvoice(temp);
                temp.setDiscount(rs.getDouble(9));
                temp.setTax(rs.getDouble(10));
                temp.setRate(rs.getDouble(11));
                setReturnFromInvoice(temp);
                
                result.add(temp);
            }
            rs.close();
            
        }catch(Exception e) {
            System.out.println(e);
        }finally {
            DBResultSet.close(dbrs);
        }
        
        return result;
    }
    
    public static int getArInvoiceCount(SrcSaleReport srcSaleReport){
        int result = 0;
        
        long locationId = srcSaleReport.getLocationId();
        String where = "BM."+PstBillMain.fieldNames[PstBillMain.FLD_TRANSCATION_TYPE]+" = "+PstBillMain.TRANS_TYPE_CREDIT+" AND BM."+
        PstBillMain.fieldNames[PstBillMain.FLD_TRANSACTION_STATUS]+" = "+srcSaleReport.getTransStatus()+
         //+DocType
        " AND BM."+ PstBillMain.fieldNames[PstBillMain.FLD_DOC_TYPE]+" = 0";
        if(srcSaleReport.getLocationId()>0){
            where = where + " AND BM."+PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID]+" = "+locationId;
        }
        
        String custNameText = srcSaleReport.getCustName();
        if(custNameText!=null&&custNameText.length()>0){
            String stCustName = " (CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME]+
            " LIKE '%"+custNameText+"%' OR CL."+
            PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_LASTNAME]+
            " LIKE '%"+custNameText+"%') ";
            where = where + " AND " + stCustName;
        }
        
        String custNameCode = srcSaleReport.getCustCode();
        if(custNameCode!=null&&custNameCode.length()>0){
            String stCustCode = " (CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BARCODE]+
            " LIKE '%"+custNameCode+"%'";
            where = where + " AND " + stCustCode;
        }
        
        if(srcSaleReport.getCurrencyOid() != 0) {
            where += " AND BM."+PstBillMain.fieldNames[PstBillMain.FLD_CURRENCY_ID]+" = "+srcSaleReport.getCurrencyOid();
        }
        
        if(srcSaleReport.getUseDate()==1){
            Date dtFrom = srcSaleReport.getDateFrom();
            Date dtTo = srcSaleReport.getDateTo();
            if(dtFrom!=null&&dtTo!=null){
                if(where!=null&&where.length()>0){
                    where = where + " AND (BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE]+
                    " BETWEEN '"+Formater.formatDate(dtFrom,"yyyy-MM-dd")+" 00:00:01'  "+
                    " AND '"+Formater.formatDate(dtTo,"yyyy-MM-dd")+" 23:59:00') ";
                }else{
                    where = where + " (BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE]+
                    " BETWEEN '"+Formater.formatDate(dtFrom,"yyyy-MM-dd")+" 00:00:01' "+
                    " AND '"+Formater.formatDate(dtTo,"yyyy-MM-dd")+" 23:59:00') ";
                }
            }
        }
        
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT("+
            " BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]+
            ") FROM " + PstBillMain.TBL_CASH_BILL_MAIN+ " AS BM "+
            " INNER JOIN "+PstMemberReg.TBL_CONTACT_LIST+ " AS CL "+
            " ON BM."+PstBillMain.fieldNames[PstBillMain.FLD_CUSTOMER_ID]+
            " = CL."+PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID];
            
            sql = sql + " WHERE " + where;
            
            
            //System.out.println("sql get Invoice : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            if(rs.next()) {
                result = rs.getInt(1);
            }
            rs.close();
            
        }catch(Exception e) {
            System.out.println(e);
        }finally {
            DBResultSet.close(dbrs);
        }
        
        return result;
    }
    
    
    private static double getLastPayment(long billMainId){
        double result = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(P."+PstCashCreditPayment.fieldNames[PstCashCreditPayment.FLD_AMOUNT]+") "+
            " FROM " + PstCreditPaymentMain.TBL_CASH_CREDIT_PAYMENT_MAIN+" AS M "+
            " INNER JOIN "+ PstCashCreditPayment.TBL_PAYMENT+" AS P "+
            " ON M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_CREDIT_PAYMENT_MAIN_ID]+
            " = P."+PstCashCreditPayment.fieldNames[PstCashCreditPayment.FLD_CREDIT_MAIN_ID]+
            " WHERE M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_BILL_MAIN_ID]+
            " = "+billMainId;
            
            //System.out.println("sql get Last Payment : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            if(rs.next()) {
                result = rs.getDouble(1);
            }
            rs.close();
            
        }catch(Exception e) {
            System.out.println(e);
        }finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }
    
    private static void setPaymentForArInvoice(RptArInvoice arInvoice){
        DBResultSet dbrs = null;
        Vector listPayment = new Vector();
        double total = 0;
        try {
            String sql = "SELECT SUM(P."+PstCashCreditPayment.fieldNames[PstCashCreditPayment.FLD_AMOUNT]+") "+
            ", M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_INVOICE_NUMBER]+
            ", M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_CREDIT_PAYMENT_MAIN_ID]+
            ", M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_BILL_DATE]+
            " FROM " + PstCreditPaymentMain.TBL_CASH_CREDIT_PAYMENT_MAIN+" AS M "+
            " INNER JOIN "+ PstCashCreditPayment.TBL_PAYMENT+" AS P "+
            " ON M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_CREDIT_PAYMENT_MAIN_ID]+
            " = P."+PstCashCreditPayment.fieldNames[PstCashCreditPayment.FLD_CREDIT_MAIN_ID]+
            " WHERE M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_BILL_MAIN_ID]+
            " = "+arInvoice.getBillMainId()+
            " GROUP BY M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_INVOICE_NUMBER]+
            ", M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_CREDIT_PAYMENT_MAIN_ID]+
            ", M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_BILL_DATE]+
            " ORDER BY M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_BILL_DATE]+
            ", M."+PstCreditPaymentMain.fieldNames[PstCreditPaymentMain.FLD_INVOICE_NUMBER];
            
            //System.out.println("sql setPaymentForArInvoice : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            RptArPayment arPayment;
            while(rs.next()) {
                arPayment = new RptArPayment();
                arPayment.setRefInvoiceNo(arInvoice.getInvoiceNo());
                arPayment.setCustName(arInvoice.getCustName());
                arPayment.setCreditPaymentMainId(rs.getLong(3));
                arPayment.setPayInvoiceNo(rs.getString(2));
                arPayment.setPayDate(rs.getDate(4));
                arPayment.setTotalPay(rs.getDouble(1));
                
                listPayment.add(arPayment);
                total = total + arPayment.getTotalPay();
            }
            rs.close();
            
        }catch(Exception e) {
            System.out.println(e);
        }finally {
            DBResultSet.close(dbrs);
        }
        arInvoice.setTotalPay(total);
        arInvoice.setVectPayment(listPayment);
    }
    
    /**
     * Fungsi ini digunakan untuk mencari dan menset besarnya return terhadap sebuah invoice
     * @param Instance RptArInvoice
     * @create gwawan@dimata 2008-02-26 11:51:00
     */
    private static void setReturnFromInvoice(RptArInvoice objRptArInvoice) {
        DBResultSet dbrs = null;
        String sql = "";
        Vector vListReturn = new Vector(1,1);
        double totalReturn = 0;
        try {
            sql += "SELECT SUM(BD."+PstBillDetail.fieldNames[PstBillDetail.FLD_TOTAL_PRICE]+") AS TOTAL_RETURN";
            sql += " FROM "+PstBillMain.TBL_CASH_BILL_MAIN+" BM INNER JOIN "+PstBillDetail.TBL_CASH_BILL_DETAIL+" BD";
            sql += " ON BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]+"= ";
            sql += " BD."+PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID];
            sql += " WHERE BM."+PstBillMain.fieldNames[PstBillMain.FLD_PARENT_ID]+"="+objRptArInvoice.getBillMainId();
            
            //System.out.println("sql setReturnFromInvoice: "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                totalReturn = rs.getDouble("TOTAL_RETURN");
            }
            rs.close();
            objRptArInvoice.setTotalReturn(totalReturn);
            
        } catch(Exception e) {
            System.out.println(e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    /** Fungsi ini digunakan untuk mendapatkan total harga netto dari sebuah invoice
     * @param oidInvoice long
     * @return totalHargaNetto double
     */
    public static double getTotalPriceNetto(long oidInvoice) {
        double totalPriceNetto = 0;
        double totalRetur = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "";
            sql += "SELECT BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID];
            sql += ", (SUM(BD."+PstBillDetail.fieldNames[PstBillDetail.FLD_TOTAL_PRICE]+") - ";
            sql += "BM."+PstBillMain.fieldNames[PstBillMain.FLD_DISCOUNT]+") + ";
            sql += "BM."+PstBillMain.fieldNames[PstBillMain.FLD_TAX_VALUE]+" AS PRICE";
            sql += " FROM "+PstBillMain.TBL_CASH_BILL_MAIN+" BM INNER JOIN "+PstBillDetail.TBL_CASH_BILL_DETAIL+" BD";
            sql += " ON BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]+" = BD."+PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID];
            
            if (oidInvoice != 0) {
                sql += " WHERE BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]+" = "+oidInvoice;
            }
            
            sql += " GROUP BY BM."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID];
            //System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                totalPriceNetto = rs.getDouble(2);
            }
            rs.close();
            
            /** get total retur */
            RptArInvoice objRptArInvoice = new RptArInvoice();
            objRptArInvoice.setBillMainId(oidInvoice);
            setReturnFromInvoice(objRptArInvoice);
            totalRetur = objRptArInvoice.getTotalReturn();
            
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return (totalPriceNetto - totalRetur);
    }
}

