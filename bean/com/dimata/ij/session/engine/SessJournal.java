/*
 * SessJournal.java
 *
 * Created on February 23, 2005, 8:44 AM
 */

package com.dimata.ij.session.engine;

// import core java package

import java.util.Vector;
import java.util.Date;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.sql.*;

// import dimata package
import com.dimata.util.*;
import com.dimata.util.lang.*;

// interfaces package
import com.dimata.ij.I_IJGeneral;

// system package
import com.dimata.common.entity.payment.PstStandartRate;
import com.dimata.common.entity.system.PstSystemProperty;

// qdep package
import com.dimata.qdep.entity.I_DocStatus;
import com.dimata.qdep.form.FRMHandler;

// import ij package
import com.dimata.ij.db.*;
import com.dimata.ij.iaiso.*;
import com.dimata.ij.ibosys.*;
import com.dimata.ij.entity.configuration.*;
import com.dimata.ij.entity.search.*;
import com.dimata.ij.form.search.*;
import com.dimata.qdep.form.FRMQueryString;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;


/**
 *
 * @author  gedhy
 */
public class SessJournal {

    /**
     * generate IJ Journal with interactive process that required user trigger
     *
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     * @return Number of journal created by IJ process
     * @created by Edhy
     *
     * @algoritm
     *  1. get configuration data from "IJ Configuration" module, store in variable
     *  2. get standart rate data from "common" store in "hashtable" object
     *  3. journal process to IJ database defend on list of task defined :
     *     3.1 Purchasing Journal
     *     3.2 Production Journal
     *     3.3 Sales Journal
     *     3.4 Cliring Journal
     */
    public int generateJournal(IjEngineParam objIjEngineParam) {
        int result = 0;

        // get parameter
        Date dStartTransactionDate = objIjEngineParam.getDStartTransactionDate();
        Date dFinishTransactionDate = objIjEngineParam.getDFinishTransactionDate();
        int iBoSystem = objIjEngineParam.getIBoSystem();

        // --- start get configuration data ---
        PstIjConfiguration objPstIjConfiguration = new PstIjConfiguration();
        IjConfiguration objIjConfiguration = new IjConfiguration();

        objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(iBoSystem, objPstIjConfiguration.CFG_GRP_PAY, objPstIjConfiguration.CFG_PAY_DP_PI);
        objIjEngineParam.setIConfPayment(objIjConfiguration.getConfigSelect());

        objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(iBoSystem, objPstIjConfiguration.CFG_GRP_INV, objPstIjConfiguration.CFG_GRP_INV_STORE);
        objIjEngineParam.setIConfInventory(objIjConfiguration.getConfigSelect());

        objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(iBoSystem, objPstIjConfiguration.CFG_GRP_TAX, objPstIjConfiguration.CFG_GRP_TAX_SALES);
        objIjEngineParam.setIConfTaxOnSales(objIjConfiguration.getConfigSelect());

        objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(iBoSystem, objPstIjConfiguration.CFG_GRP_TAX, objPstIjConfiguration.CFG_GRP_TAX_BUY);
        objIjEngineParam.setIConfTaxOnBuy(objIjConfiguration.getConfigSelect());

        objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(iBoSystem, objPstIjConfiguration.CFG_GRP_SYS, objPstIjConfiguration.CFG_GRP_SYS_IJ_ENG);
        objIjEngineParam.setIConfJournalSystem(objIjConfiguration.getConfigSelect());
        // --- finish get configuration data ---


        // --- start get standart rate data ---
        PstStandartRate objPstStandartRate = new PstStandartRate();
        objIjEngineParam.setHStandartRate(objPstStandartRate.getStandartRate());
        // --- finish get standart rate data ---


        // --- start journal process to IJ database defend on chart of task defined ---
        Date dTransDate = new Date();
        int maxIterate = ((int) DateCalc.dayDifference(dStartTransactionDate, dFinishTransactionDate)) + 1;
        if (maxIterate > 0) {
            // instantiate object that handle journal process
            SessDPOnPO objSessDPOnPO = new SessDPOnPO();
            SessPurchOnLGR objSessPurchOnLGR = new SessPurchOnLGR();
            SessPaymentOnLGR objSessPaymentOnLGR = new SessPaymentOnLGR();

            SessDPOnPdO objSessDPOnPdO = new SessDPOnPdO();
            SessInventoryOnDF objSessInventoryOnDF = new SessInventoryOnDF();
            SessProdCostOnLGR objSessProdCostOnLGR = new SessProdCostOnLGR();

            SessDPOnSO objSessDPOnSO = new SessDPOnSO();
            SessSalesOnInv objSessSalesOnInv = new SessSalesOnInv();
            SessPaymentOnInv objSessPaymentOnInv = new SessPaymentOnInv();

            SessPaymentType objSessPaymentType = new SessPaymentType();

            for (int i = 0; i < maxIterate; i++) {
                // generate date of process
                dTransDate = new Date(dStartTransactionDate.getYear(), dStartTransactionDate.getMonth(), (dStartTransactionDate.getDate() + i));

                // --- Start Purchasing Journal ---
                // ### 1. Start DP on Purchase Order Transaction ###
                result = objSessDPOnPO.generateDPOnPOJournal(dTransDate, I_IJGeneral.DOC_TYPE_DP_ON_PURCHASE_ORDER, objIjEngineParam);
                // ### 1. Finish DP on Purchase Order Transaction ###

                // ### 2. Start Purchase on LGR Transaction ###
                result = objSessPurchOnLGR.generateLGRJournal(dTransDate, I_IJGeneral.DOC_TYPE_PURCHASE_ON_LGR, objIjEngineParam);
                // ### 2. Finish Purchase on LGR Transaction ###

                // ### 3. Start Payment on LGR Transaction ###
                result = objSessPaymentOnLGR.generatePaymentOnLGRJournal(dTransDate, I_IJGeneral.DOC_TYPE_PAYMENT_ON_LGR, objIjEngineParam);
                // ### 3. Finish Payment on LGR Transaction ###
                // --- Finish Purchasing Journal ---



                // --- Start Production Journal ---
                // ### 4. Start DP on Production Order Transaction ###
                result = objSessDPOnPdO.generateDPOnPdOJournal(dTransDate, I_IJGeneral.DOC_TYPE_DP_ON_PRODUCTION_ORDER, objIjEngineParam);
                // ### 4. Finish DP on Production Order Transaction ###

                // ### 5. Start Inventory on DF Transaction ###   -- ragu2
                result = objSessInventoryOnDF.generateDFToWhJournal(dTransDate, I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF, objIjEngineParam);
                result = objSessInventoryOnDF.generateDFToProductionJournal(dTransDate, I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF, objIjEngineParam);
                // ### 5. Finish Inventory on DF Transaction ###

                // ### 6. Start Production Cost on LGR Transaction ###  -- ragu2
                result = objSessProdCostOnLGR.generateProdCostOnLGRJournal(dTransDate, I_IJGeneral.DOC_TYPE_PROD_COST_ON_LGR, objIjEngineParam);
                // ### 6. Finish Production Cost on LGR Transaction ###
                // --- Finish Production Journal ---



                // --- Start Sales Journal ---
                // ### 7. Start DP on Sales Order Transaction ###
                result = objSessDPOnSO.generateDPOnSOJournal(dTransDate, I_IJGeneral.DOC_TYPE_DP_ON_SALES_ORDER, objIjEngineParam);
                // ### 7. Finish DP on Sales Order Transaction ###

                // ### 8. Start Sales on Invoice Transaction ###
                result = objSessSalesOnInv.generateCreditSalesJournal(dTransDate, I_IJGeneral.DOC_TYPE_SALES_ON_INV, objIjEngineParam);
                result = objSessSalesOnInv.generateCashSalesJournal(dTransDate, I_IJGeneral.DOC_TYPE_SALES_ON_INV, objIjEngineParam);
                // ### 8. Finish Sales on Invoice Transaction ###

                // ### 9. Start Payment on Invoice Transaction ###
                result = objSessPaymentOnInv.generatePaymentOnInvoiceJournal(dTransDate, I_IJGeneral.DOC_TYPE_PAYMENT_ON_INV, objIjEngineParam);
                // ### 9. Finish Payment on Invoice Transaction ###
                // --- Finish Sales Journal ---

                // --- Start Cliring Journal ---
                // ### 10. Start Payment Type Transaction ###
                result = objSessPaymentType.generateCliringJournal(dTransDate, I_IJGeneral.DOC_TYPE_PAYMENT_TYPE_POSTED_CLEARED, objIjEngineParam);
                // ### 10. Finish Payment Type Transaction ###
                // --- Finish Cliring Journal ---
            }
        }
        // --- finish journal process to IJ database defend on chart of task defined ---

        return result;
    }


    /**
     * generate Ij Journal of last version of object on BO system
     * @param objIjJournalMain
     * @param strIjImplBoClassName
     * @return
     */
    public long generateIjJournalImmediately(IjJournalMain objIjJournalMain, IjEngineParam objIjEngineParam) {
        long lResult = 0;

        // get parameter
        String strIjImplBoClassName = objIjEngineParam.getSIjImplBo();

        int iRefBoDocType = objIjJournalMain.getRefBoDocType();
        long lRefBoDocOid = objIjJournalMain.getRefBoDocOid();
        long lLocationOid = objIjJournalMain.getRefBoLocation();
        switch (iRefBoDocType) {
            // generate IJJOurnal of "DP on Purchase Order" dengan object "objIjDPOnPODoc"
            case I_IJGeneral.DOC_TYPE_DP_ON_PURCHASE_ORDER:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjDPOnPODoc objIjDPOnPODoc = i_bosystem.getDPonPurchaseOrderDoc(lRefBoDocOid);

                    SessDPOnPO objSessDPOnPO = new SessDPOnPO();
                    lResult = objSessDPOnPO.genJournalOfObjDPOnPO(lLocationOid, objIjDPOnPODoc, iRefBoDocType, objIjEngineParam);
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - DPonPurchaseOrder document exc : " + e.toString());
                }
                break;


                // generate IJJOurnal of "Purchase On LGR" dengan object "objIjPurchaseOnLGRDoc"
            case I_IJGeneral.DOC_TYPE_PURCHASE_ON_LGR:
                try {
                    System.out.println("objIjPurchaseOnLGRDoc : " + strIjImplBoClassName + " lRefBoDocOid : " + lRefBoDocOid);
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjPurchaseOnLGRDoc objIjPurchaseOnLGRDoc = i_bosystem.getPurchaseOnLGRDoc(lRefBoDocOid);
                    System.out.println("objIjPurchaseOnLGRDoc : " + objIjPurchaseOnLGRDoc);

                    SessPurchOnLGR objSessPurchOnLGR = new SessPurchOnLGR();
                    System.out.println("lLocationOid : " + objIjPurchaseOnLGRDoc);
                    System.out.println("iRefBoDocType : " + iRefBoDocType);
                    lResult = objSessPurchOnLGR.genJournalOfObjPurchOnLGR(lLocationOid, objIjPurchaseOnLGRDoc, iRefBoDocType, objIjEngineParam);
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - PurchaseOnLGR document exc : " + e.toString());
                }
                break;


                // generate IJJOurnal of "Payment On LGR" dengan object "objIjPaymentOnLGRDoc"
            case I_IJGeneral.DOC_TYPE_PAYMENT_ON_LGR:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjPaymentOnLGRDoc objIjPaymentOnLGRDoc = i_bosystem.getPaymentOnLGRDoc(lRefBoDocOid);

                    SessPaymentOnLGR objSessPaymentOnLGR = new SessPaymentOnLGR();
                    lResult = objSessPaymentOnLGR.genJournalOfObjPaymentOnLGR(lLocationOid, objIjPaymentOnLGRDoc, iRefBoDocType, objIjEngineParam);
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - PaymentOnLGR document exc : " + e.toString());
                }
                break;


                // generate IJJOurnal of "DP on Production Order" dengan object "objIjDPOnPdODoc"
            case I_IJGeneral.DOC_TYPE_DP_ON_PRODUCTION_ORDER:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjDPOnPdODoc objIjDPOnPdODoc = i_bosystem.getDPonProductionOrderDoc(lRefBoDocOid);

                    SessDPOnPdO objSessDPOnPdO = new SessDPOnPdO();
                    lResult = objSessDPOnPdO.genJournalOfObjDPOnPdO(lLocationOid, objIjDPOnPdODoc, iRefBoDocType, objIjEngineParam);
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - DPonProductionOrder document exc : " + e.toString());
                }
                break;


                // generate IJJOurnal of "Inventory On DF" dengan object "objIjInventoryOnDFDoc"
            case I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjInventoryOnDFDoc objIjInventoryOnDFDoc = i_bosystem.getInventoryOnDFDoc(lRefBoDocOid);

                    SessInventoryOnDF objSessInventoryOnDF = new SessInventoryOnDF();
                    lResult = objSessInventoryOnDF.genJournalOfObjDFToWH(lLocationOid, objIjInventoryOnDFDoc, iRefBoDocType, objIjEngineParam);
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - InventoryOnDF document exc : " + e.toString());
                }
                break;


                // generate IJJOurnal of "Production Cost On LGR" dengan object "objIjProdCostOnLGRDoc"
            case I_IJGeneral.DOC_TYPE_PROD_COST_ON_LGR:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjProdCostOnLGRDoc objIjProdCostOnLGRDoc = i_bosystem.getProductionCostOnLGRDoc(lRefBoDocOid);

                    SessProdCostOnLGR objSessProdCostOnLGR = new SessProdCostOnLGR();
                    lResult = objSessProdCostOnLGR.genJournalOfObjProdCostOnLGR(lLocationOid, objIjProdCostOnLGRDoc, iRefBoDocType, objIjEngineParam);
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - ProductionCostOnLGR document exc : " + e.toString());
                }
                break;


                // generate IJJOurnal of "DP on Sales Order" dengan object "objIjDPOnSODoc"
            case I_IJGeneral.DOC_TYPE_DP_ON_SALES_ORDER:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjDPOnSODoc objIjDPOnSODoc = i_bosystem.getDPonSalesOrderDoc(lRefBoDocOid);

                    SessDPOnSO objSessDPOnSO = new SessDPOnSO();
                    lResult = objSessDPOnSO.genJournalOfObjDPOnSO(lLocationOid, objIjDPOnSODoc, iRefBoDocType, objIjEngineParam);
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - DPonSalesOrder document exc : " + e.toString());
                }
                break;


                // generate IJJOurnal of "Sales on Invoice" dengan object "objIjSalesOnInvDoc"
            case I_IJGeneral.DOC_TYPE_SALES_ON_INV:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjSalesOnInvDoc objIjSalesOnInvDoc = i_bosystem.getSalesOnInvoiceDoc(lRefBoDocOid);

                    SessSalesOnInv objSessSalesOnInv = new SessSalesOnInv();
                    lResult = objSessSalesOnInv.genJournalOfObjCreditSales(lLocationOid, objIjSalesOnInvDoc, iRefBoDocType, objIjEngineParam);
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - SalesOnInvoice document exc : " + e.toString());
                }
                break;


                // generate IJJOurnal of "Payment On Invoice" dengan object "objIjPaymentOnInvDoc"
            case I_IJGeneral.DOC_TYPE_PAYMENT_ON_INV:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjPaymentOnInvDoc objIjPaymentOnInvDoc = i_bosystem.getPaymentOnInvoiceDoc(lRefBoDocOid);

                    System.out.println("jangan kau eror lagi yaaaaa 01");
                    SessPaymentOnInv objSessPaymentOnInv = new SessPaymentOnInv();
                    lResult = objSessPaymentOnInv.genJournalOfObjPaymentOnInvoice(lLocationOid, objIjPaymentOnInvDoc, iRefBoDocType, objIjEngineParam);
                    System.out.println("jangan kau eror lagi yaaaaa 02");
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - PaymentOnInv document exc : " + e.toString());
                }
                break;


                // generate IJJOurnal of "Payment Type" dengan object "objIjPaymentTypeDoc"
            case I_IJGeneral.DOC_TYPE_PAYMENT_TYPE_POSTED_CLEARED:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjPaymentTypeDoc objIjPaymentTypeDoc = i_bosystem.getPaymentTypeDoc(lRefBoDocOid);

                    SessPaymentType objSessPaymentType = new SessPaymentType();
                    lResult = objSessPaymentType.genJournalOfObjPaymentType(lLocationOid, objIjPaymentTypeDoc, iRefBoDocType, objIjEngineParam);
                } catch (Exception e) {
                    System.out.println(new SessJournal().getClass().getName() + ".generateIjJournalImmediately() - PaymentType document exc : " + e.toString());
                }
                break;


            default :
                break;
        }

        return lResult;
    }


    /**
     * @param objSrcIjJournal
     * @param start
     * @param recordToGet
     * @return
     */
    public static Vector getJournal(SrcIjJournal objSrcIjJournal, int start, int recordToGet) {
        Vector result = new Vector(1, 1);
        DBResultSet dbrs = null;

        // proses pencarian daftar jurnal sesuai dengan parameter pencarian
        try {
            String sql = "SELECT MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_IJ_JOURNAL_MAIN_ID] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_TRANSACTION_DATE] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_BOOK_TYPE] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CURRENCY_ID] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_STATUS] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_NOTE] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_PERIOD] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_ENTRY_DATE] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_USER] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_TYPE] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_OID] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_NUMBER] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_AISO_JOURNAL_OID] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_SYSTEM] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_LAST_UPDATE] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_LOCATION] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_TRANSACTION_TYPE] +
                    ", MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CONTACT_ID] +
                    " FROM " + PstIjJournalMain.TBL_IJ_JOURNAL_MAIN + " AS MAIN ";

            if (objSrcIjJournal.getBillNumber() != null && objSrcIjJournal.getBillNumber().length() > 0) {
                sql = sql + " INNER JOIN " + PstIjJournalDetail.TBL_IJ_JOURNAL_DETAIL + " AS DETAIL " +
                        " ON MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_IJ_JOURNAL_MAIN_ID] +
                        " = DETAIL." + PstIjJournalDetail.fieldNames[PstIjJournalDetail.FLD_JOURNAL_MAIN_ID];
            }


            String strTransDate = "";
            if (objSrcIjJournal.getSelectedTransDate() == FrmSrcIjJournal.SELECTED_USER_DATE) {
                if (objSrcIjJournal.getTransStartDate() != null && objSrcIjJournal.getTransEndDate() != null) {
                    String strStartDate = Formater.formatDate(objSrcIjJournal.getTransStartDate(), "yyyy-MM-dd");
                    String strEndDate = Formater.formatDate(objSrcIjJournal.getTransEndDate(), "yyyy-MM-dd");
                    strTransDate = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_TRANSACTION_DATE] +
                            " BETWEEN \"" + strStartDate + "\" AND \"" + strEndDate + "\"";
                }
            }

            String strCurrency = "";
            if (objSrcIjJournal.getTransCurrency() != 0) {
                strCurrency = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CURRENCY_ID] +
                        " = " + objSrcIjJournal.getTransCurrency();
            }

            String strJournalStatus = "";
            if (objSrcIjJournal.getJournalStatus() != -1) {
                strJournalStatus = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_STATUS] +
                        " = " + objSrcIjJournal.getJournalStatus();
            }

            String strSortBy = "";
            switch (objSrcIjJournal.getSortBy()) {
                case FrmSrcIjJournal.SORT_BY_TRANS_DATE:
                    strSortBy = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_TRANSACTION_DATE];
                    break;

                case FrmSrcIjJournal.SORT_BY_BILL_NUMBER:
                    strSortBy = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_NUMBER];
                    break;

                case FrmSrcIjJournal.SORT_BY_CURRENCY:
                    strSortBy = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CURRENCY_ID];
                    break;

                case FrmSrcIjJournal.SORT_BY_JOURNAL_STATUS:
                    strSortBy = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_STATUS];
                    break;
            }


            String allCondition = "";
            if (strTransDate != null && strTransDate.length() > 0) {
                allCondition = strTransDate;
            }

            if (strCurrency != null && strCurrency.length() > 0) {
                if (allCondition != null && allCondition.length() > 0) {
                    allCondition = allCondition + " AND " + strCurrency;
                } else {
                    allCondition = strCurrency;
                }
            }

            if (strJournalStatus != null && strJournalStatus.length() > 0) {
                if (allCondition != null && allCondition.length() > 0) {
                    allCondition = allCondition + " AND " + strJournalStatus;
                } else {
                    allCondition = strJournalStatus;
                }
            }

            if (allCondition != null && allCondition.length() > 0) {
                sql = sql + " WHERE  " + allCondition;
            }

            if (strSortBy != null && strSortBy.length() > 0) {
                sql = sql + " ORDER BY  " + strSortBy;
            }

                           
                switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL:
                    if (start == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + start + "," + recordToGet;
                    break;

                case DBHandler.DBSVR_POSTGRESQL:
                    if (start == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + start;

                    break;

                case DBHandler.DBSVR_SYBASE:
                    break;

                case DBHandler.DBSVR_ORACLE:
                    break;

                case DBHandler.DBSVR_MSSQL:
                    break;

                default:
                    break;
            }
            

            System.out.println(new SessJournal().getClass().getName() + ".getJournal() - sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                IjJournalMain objIjJournalMain = new IjJournalMain();

                objIjJournalMain.setOID(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_IJ_JOURNAL_MAIN_ID]));
                objIjJournalMain.setJurTransDate(rs.getDate(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_TRANSACTION_DATE]));
                objIjJournalMain.setJurBookType(rs.getInt(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_BOOK_TYPE]));
                objIjJournalMain.setJurTransCurrency(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CURRENCY_ID]));
                objIjJournalMain.setJurStatus(rs.getInt(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_STATUS]));
                objIjJournalMain.setJurDesc(rs.getString(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_NOTE]));
                objIjJournalMain.setJurPeriod(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_PERIOD]));
                objIjJournalMain.setJurEntryDate(rs.getDate(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_ENTRY_DATE]));
                objIjJournalMain.setJurUser(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_USER]));
                objIjJournalMain.setRefBoDocType(rs.getInt(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_TYPE]));
                objIjJournalMain.setRefBoDocOid(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_OID]));
                objIjJournalMain.setRefBoDocNumber(rs.getString(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_NUMBER]));
                objIjJournalMain.setRefAisoJournalOid(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_AISO_JOURNAL_OID]));
                objIjJournalMain.setRefBoSystem(rs.getInt(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_SYSTEM]));
                objIjJournalMain.setRefBoLocation(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_LOCATION]));
                objIjJournalMain.setRefBoTransacTionType(rs.getInt(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_TRANSACTION_TYPE]));
                objIjJournalMain.setContactOid(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CONTACT_ID]));

                objIjJournalMain.setRefBoDocLastUpdate(rs.getTimestamp(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_LAST_UPDATE]));
                //Date dates = DBHandler.convertDate(rs.getDate(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_LAST_UPDATE]), rs.getTime(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_LAST_UPDATE]));
                //objIjJournalMain.setRefBoDocLastUpdate(dates);

                String whDetail = PstIjJournalDetail.fieldNames[PstIjJournalDetail.FLD_JOURNAL_MAIN_ID] + "=" + objIjJournalMain.getOID();
                String ordDetail = PstIjJournalDetail.fieldNames[PstIjJournalDetail.FLD_DEBT_VALUE];
                Vector listJournalDetail = PstIjJournalDetail.list(0, 0, whDetail, ordDetail);
                objIjJournalMain.setListOfDetails(listJournalDetail);

                result.add(objIjJournalMain);
            }
        } catch (Exception e) {
            System.out.println(new SessJournal().getClass().getName() + ".getJournal() - exc : " + e.toString());
        }

        return result;
    }


    /** gadnyana
     *  untuk mencari total journal yang telah di buat IJ
     * sesuai dengan parameter pencarian
     * @param objSrcIjJournal
     * @return
     */
    public static int getCountJournal(SrcIjJournal objSrcIjJournal) {
        int cnt = 0;
        DBResultSet dbrs = null;

        // proses pencarian daftar jurnal sesuai dengan parameter pencarian
        try {
            String sql = "SELECT COUNT(MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_IJ_JOURNAL_MAIN_ID] + ") AS CNT " +
                    " FROM " + PstIjJournalMain.TBL_IJ_JOURNAL_MAIN + " AS MAIN ";

            if (objSrcIjJournal.getBillNumber() != null && objSrcIjJournal.getBillNumber().length() > 0) {
                sql = sql + " INNER JOIN " + PstIjJournalDetail.TBL_IJ_JOURNAL_DETAIL + " AS DETAIL " +
                        " ON MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_IJ_JOURNAL_MAIN_ID] +
                        " = DETAIL." + PstIjJournalDetail.fieldNames[PstIjJournalDetail.FLD_JOURNAL_MAIN_ID];
            }


            String strTransDate = "";
            if (objSrcIjJournal.getSelectedTransDate() == FrmSrcIjJournal.SELECTED_USER_DATE) {
                if (objSrcIjJournal.getTransStartDate() != null && objSrcIjJournal.getTransEndDate() != null) {
                    String strStartDate = Formater.formatDate(objSrcIjJournal.getTransStartDate(), "yyyy-MM-dd");
                    String strEndDate = Formater.formatDate(objSrcIjJournal.getTransEndDate(), "yyyy-MM-dd");
                    strTransDate = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_TRANSACTION_DATE] +
                            " BETWEEN \"" + strStartDate + "\" AND \"" + strEndDate + "\"";
                }
            }

            String strCurrency = "";
            if (objSrcIjJournal.getTransCurrency() != 0) {
                strCurrency = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CURRENCY_ID] +
                        " = " + objSrcIjJournal.getTransCurrency();
            }

            String strJournalStatus = "";
            if (objSrcIjJournal.getJournalStatus() != -1) {
                strJournalStatus = " MAIN." + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_STATUS] +
                        " = " + objSrcIjJournal.getJournalStatus();
            }

            String allCondition = "";
            if (strTransDate != null && strTransDate.length() > 0) {
                allCondition = strTransDate;
            }

            if (strCurrency != null && strCurrency.length() > 0) {
                if (allCondition != null && allCondition.length() > 0) {
                    allCondition = allCondition + " AND " + strCurrency;
                } else {
                    allCondition = strCurrency;
                }
            }

            if (strJournalStatus != null && strJournalStatus.length() > 0) {
                if (allCondition != null && allCondition.length() > 0) {
                    allCondition = allCondition + " AND " + strJournalStatus;
                } else {
                    allCondition = strJournalStatus;
                }
            }

            if (allCondition != null && allCondition.length() > 0) {
                sql = sql + " WHERE  " + allCondition;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                cnt = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(new SessJournal().getClass().getName() + ".getJournal() - exc : " + e.toString());
        }

        return cnt;
    }

    /**
     * this method used to get list all journal main object base on specified parameter
     * @param objSrcIjJournal
     * @return
     * @created by Edhy
     */
    public static Vector getListJournalMain(SrcIjJournal objSrcIjJournal) {
        Vector result = new Vector(1, 1);
        DBResultSet dbrs = null;

        // proses pencarian daftar jurnal sesuai dengan parameter pencarian
        try {
            String sql = "SELECT " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_IJ_JOURNAL_MAIN_ID] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_TRANSACTION_DATE] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_BOOK_TYPE] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CURRENCY_ID] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_STATUS] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_NOTE] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_PERIOD] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_ENTRY_DATE] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_USER] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_TYPE] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_OID] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_NUMBER] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_AISO_JOURNAL_OID] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_SYSTEM] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_LAST_UPDATE] +
                    ", " + PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CONTACT_ID] +
                    " FROM " + PstIjJournalMain.TBL_IJ_JOURNAL_MAIN;

            String strTransDate = "";
            if (objSrcIjJournal.getSelectedTransDate() == FrmSrcIjJournal.SELECTED_USER_DATE) {
                if (objSrcIjJournal.getTransStartDate() != null && objSrcIjJournal.getTransEndDate() != null) {
                    String strStartDate = Formater.formatDate(objSrcIjJournal.getTransStartDate(), "yyyy-MM-dd");
                    String strEndDate = Formater.formatDate(objSrcIjJournal.getTransEndDate(), "yyyy-MM-dd");
                    strTransDate = PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_TRANSACTION_DATE] +
                            " BETWEEN \"" + strStartDate + "\" AND \"" + strEndDate + "\"";
                }
            }

            String strCurrency = "";
            if (objSrcIjJournal.getTransCurrency() != 0) {
                strCurrency = PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CURRENCY_ID] +
                        " = " + objSrcIjJournal.getTransCurrency();
            }

            String strJournalStatus = "";
            if (objSrcIjJournal.getJournalStatus() != -1) {
                strJournalStatus = PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_STATUS] +
                        " = " + objSrcIjJournal.getJournalStatus();
            }


            String allCondition = "";
            if (strTransDate != null && strTransDate.length() > 0) {
                allCondition = strTransDate;
            }

            if (strCurrency != null && strCurrency.length() > 0) {
                if (allCondition != null && allCondition.length() > 0) {
                    allCondition = allCondition + " AND " + strCurrency;
                } else {
                    allCondition = strCurrency;
                }
            }

            if (strJournalStatus != null && strJournalStatus.length() > 0) {
                if (allCondition != null && allCondition.length() > 0) {
                    allCondition = allCondition + " AND " + strJournalStatus;
                } else {
                    allCondition = strJournalStatus;
                }
            }

            if (allCondition != null && allCondition.length() > 0) {
                sql = sql + " WHERE  " + allCondition;
            }

            System.out.println(new SessJournal().getClass().getName() + ".getListJournalMain() sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                IjJournalMain objIjJournalMain = new IjJournalMain();

                objIjJournalMain.setOID(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_IJ_JOURNAL_MAIN_ID]));
                objIjJournalMain.setJurTransDate(rs.getDate(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_TRANSACTION_DATE]));
                objIjJournalMain.setJurBookType(rs.getInt(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_BOOK_TYPE]));
                objIjJournalMain.setJurTransCurrency(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CURRENCY_ID]));
                objIjJournalMain.setJurStatus(rs.getInt(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_STATUS]));
                objIjJournalMain.setJurDesc(rs.getString(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_NOTE]));
                objIjJournalMain.setJurPeriod(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_PERIOD]));
                objIjJournalMain.setJurEntryDate(rs.getDate(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_ENTRY_DATE]));
                objIjJournalMain.setJurUser(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_USER]));
                objIjJournalMain.setRefBoDocType(rs.getInt(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_TYPE]));
                objIjJournalMain.setRefBoDocOid(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_OID]));
                objIjJournalMain.setRefBoDocNumber(rs.getString(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_NUMBER]));
                objIjJournalMain.setRefAisoJournalOid(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_AISO_JOURNAL_OID]));
                objIjJournalMain.setRefBoSystem(rs.getInt(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_SYSTEM]));
                objIjJournalMain.setRefBoDocLastUpdate(rs.getDate(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_REF_BO_DOC_LAST_UPDATE]));
                objIjJournalMain.setContactOid(rs.getLong(PstIjJournalMain.fieldNames[PstIjJournalMain.FLD_CONTACT_ID]));

                result.add(objIjJournalMain);
            }
        } catch (Exception e) {
            System.out.println(new SessJournal().getClass().getName() + ".getListJournalMain() exc : " + e.toString());
        }

        return result;
    }


    /**
     * this method used to list all journal object (main, detail n its sub ledger) base on specified parameter
     * @param objSrcIjJournal
     * @return
     * @created by Edhy
     */
    public static Vector getListJournalObj(SrcIjJournal objSrcIjJournal) {
        Vector vResult = new Vector(1, 1);

        // get list journal main
        Vector vListJournalMain = getListJournalMain(objSrcIjJournal);
        if (vListJournalMain != null && vListJournalMain.size() > 0) {
            int iListJournalMainCount = vListJournalMain.size();
            PstIjJournalMain objPstIjJournalMain = new PstIjJournalMain();
            for (int i = 0; i < iListJournalMainCount; i++) {
                IjJournalMain objIjJournalMain = (IjJournalMain) vListJournalMain.get(i);

                // get journal business object
                IjJournalMain objIjJournal = objPstIjJournalMain.getIjJournalMain(objIjJournalMain.getOID());
                vResult.add(objIjJournal);
            }
        }

        return vResult;
    }

}
