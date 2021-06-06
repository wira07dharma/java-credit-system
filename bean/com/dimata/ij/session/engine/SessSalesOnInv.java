/*
 * SessSalesOnInv.java
 *
 * Created on January 18, 2005, 7:58 AM
 */

package com.dimata.ij.session.engine;

// core java package

import java.util.Vector;
import java.util.Date;
import java.util.Hashtable;

// qdep package
import com.dimata.qdep.entity.I_DocStatus;

// ij package
import com.dimata.ij.I_IJGeneral;
import com.dimata.ij.ibosys.*;
import com.dimata.ij.iaiso.*;
import com.dimata.ij.entity.mapping.*;

/**
 *
 * @author  gedhy
 */
public class SessSalesOnInv {

    // define journal note for transaction DP On Sales Order
    public static int TRAN_CREDIT_SALE = 0;
    public static int TRAN_CASH_SALE = 1;
    public static int TRAN_INVENTORY = 2;
    public static String strJournalNote[][] =
            {
                {"Jurnal Penjualan kredit", "Jurnal penjualan tunai", "Jurnal Hpp"},
                {"Credit sales transaction", "Cash sale transaction", "Inventory transaction"}
            };


    // --- start of credit sales ---
    /**
     * Generate list of Credit Sales journal based on selected document on selected Bo system
     *
     * @param <CODE>dSelectedDate</CODE>Date of transaction selected by user
     * @param <CODE>iDocTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return Number of Credit Sales Journal process
     * @created by Edhy
     *
     * @algoritm :
     *  1. iterate as long as location count to generate CreditSalesJournal
     */
    public int generateCreditSalesJournal(Date dSelectedDate, int iDocTypeReference, IjEngineParam objIjEngineParam) {
        int result = 0;

        Vector vLocationOid = objIjEngineParam.getVLocationOid();
        if (vLocationOid != null && vLocationOid.size() > 0) {
            int iLocationCount = vLocationOid.size();
            for (int i = 0; i < iLocationCount; i++) {
                long lLocationOid = Long.parseLong(String.valueOf(vLocationOid.get(i)));
                result = result + generateCreditSalesJournal(lLocationOid, dSelectedDate, iDocTypeReference, objIjEngineParam);
            }
        }

        return result;
    }


    /**
     * Generate list of Credit Sales journal based on selected document on selected Bo system
     *
     * @param <CODE>lLocationOid</CODE>ID of Location object of transaction
     * @param <CODE>dSelectedDate</CODE>Date of transaction selected by user
     * @param <CODE>iDocTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return Number of Credit Sales Journal process
     * @created by Edhy
     *
     * @algoritm :
     *  1. get list of Credit Sales Document from selected BO system
     *  2. iterate as long as document count to generate CreditSalesJournal
     */
    public int generateCreditSalesJournal(long lLocationOid, Date dSelectedDate, int iDocTypeReference, IjEngineParam objIjEngineParam) {
        int result = 0;

        Vector vSaleType = new Vector(1, 1);
        vSaleType.add("" + I_IJGeneral.SALE_TYPE_REGULAR);
        vSaleType.add("" + I_IJGeneral.SALE_TYPE_CONSIGNMENT);
        vSaleType.add("" + I_IJGeneral.SALE_TYPE_PERSONAL);

        int iMaxSaleType = vSaleType.size();
        for (int it = 0; it < iMaxSaleType; it++) {
            int iSaleType = Integer.parseInt("" + vSaleType.get(it));

            // 1. Ambil data DP (refer to IJ-Interface getListSalesOnInvoice)
            Vector vectOfSalesOnInvDoc = new Vector(1, 1);
            try {
                // --- start get list of LGR Document from selected BO system ---
                String strIjImplBo = objIjEngineParam.getSIjImplBo();
                I_BOSystem i_bosys = (I_BOSystem) Class.forName(strIjImplBo).newInstance();
                vectOfSalesOnInvDoc = i_bosys.getListSalesOnInvoice(lLocationOid, dSelectedDate, iSaleType, I_IJGeneral.TRANSACTION_TYPE_CREDIT);
                // --- end get list of LGR Document from selected BO system ---

                // --- start iterate as long as document count to generate LGRJournal ---
                if (vectOfSalesOnInvDoc != null && vectOfSalesOnInvDoc.size() > 0) {
                    int maxSalesOnInvDoc = vectOfSalesOnInvDoc.size();
                    for (int i = 0; i < maxSalesOnInvDoc; i++) {
                        IjSalesOnInvDoc objIjSalesOnInvDoc = (IjSalesOnInvDoc) vectOfSalesOnInvDoc.get(i);
                        long lResult = genJournalOfObjCreditSales(lLocationOid, objIjSalesOnInvDoc, iDocTypeReference, objIjEngineParam);
                    }
                } else {
                    System.out.println(".::MSG : Because no document found, journaling Sales on Invoice process skip ... ");
                }
                // --- end iterate as long as document count to generate LGRJournal ---
            } catch (Exception e) {
                System.out.println(".:: ERR : Exception when instantiate interface");
            }
        }

        return result;
    }

    /**
     * proses kredit barang
     * @param lLocationOid
     * @param objIjSalesOnInvDoc
     * @param iDocTypeReference
     * @param objIjEngineParam
     * @return
     */
    public long genJournalOfObjCreditSales(long lLocationOid, IjSalesOnInvDoc objIjSalesOnInvDoc, int iDocTypeReference, IjEngineParam objIjEngineParam) {
        long lResult = genJournalOfObjReceivable(lLocationOid, objIjSalesOnInvDoc, iDocTypeReference, objIjEngineParam);
        lResult = genJournalOfObjInventory(lLocationOid, objIjSalesOnInvDoc, iDocTypeReference, objIjEngineParam);
        return lResult;
    }

    /**
     *
     * @param <CODE>objIjSalesOnInvDoc</CODE>object IjSalesOnInvDoc
     * @param <CODE>iDocTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return
     */
    public long genJournalOfObjReceivable(long lLocationOid, IjSalesOnInvDoc objIjSalesOnInvDoc, int iDocTypeReference, IjEngineParam objIjEngineParam) {
        long lResult = 0;

        Hashtable hashStandartRate = objIjEngineParam.getHStandartRate();
        String strStandartRate = (hashStandartRate.get("" + objIjSalesOnInvDoc.getDocTransCurrency())) != null ? "" + hashStandartRate.get("" + objIjSalesOnInvDoc.getDocTransCurrency()) : "1";
        double standartRate = Double.parseDouble(strStandartRate);

        // 1. pembuatan jurnal umum (object IjJournalMain) dengan mengambil dokumen Penjualan (object IjSalesOnInvDoc).
        IjJournalMain objIjJournalMain = genObjIjJournalMain(objIjSalesOnInvDoc, TRAN_CREDIT_SALE, iDocTypeReference, lLocationOid, objIjEngineParam);

        // 2. start pembuatan vector of object ij jurnal detail
        Vector vectOfObjIjJurDetail = new Vector(1, 1);

        // 2.1 pembuatan jurnal detail posisi kredit (object IjJournalDetail) dengan mengambil data payment.
        Vector vLocationSalesValue = genObjIjJournalDetailLocationSalesValue(objIjSalesOnInvDoc, standartRate);

        // 2.2 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Account Mapping DPonPurchaseOrder.
        Vector vOtherCost = genObjIjJournalDetailOtherCost(objIjSalesOnInvDoc, objIjEngineParam);

        // 2.3 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Account Mapping DPonPurchaseOrder.
        Vector vDiscount = genObjIjJournalDetailSalesDiscount(objIjSalesOnInvDoc, objIjEngineParam);

        // 2.4 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Account Mapping DPonPurchaseOrder.
        Vector vDPDeduction = genObjIjJournalDetailDPDeduction(objIjSalesOnInvDoc, objIjEngineParam);

        double totalLocationSalesValue = getTotalLocationSalesValue(vLocationSalesValue);
        double totalOtherCost = getTotalOtherCostAmount(vOtherCost);
        double totalDiscount = getTotalDiscount(vDiscount);
        double totalDPDeduction = getTotalDPDeduction(vDPDeduction);

        // 2.5 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Account Mapping DPonPurchaseOrder.
        Vector vTotalReceivable = genObjIjJournalKreditDetailSalesValue(objIjSalesOnInvDoc, totalLocationSalesValue, totalOtherCost, totalDiscount, totalDPDeduction, standartRate);

        // 2.6 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Account Mapping DPonPurchaseOrder.
        Vector vTaxOnSales = new Vector(1, 1);
        if (objIjEngineParam.getIConfTaxOnSales() == I_IJGeneral.CFG_GRP_TAX_SALES_VAT_RPT) {
            vTaxOnSales = genObjIjJournalDetailTaxOnSales(objIjSalesOnInvDoc, objIjEngineParam);
        }


        // 3. masukkan object masing-masing account ke dalam vector of jurnal detail
        if (vLocationSalesValue != null && vLocationSalesValue.size() > 0) {
            vectOfObjIjJurDetail.addAll(vLocationSalesValue);
        }

        if (vOtherCost != null && vOtherCost.size() > 0) {
            vectOfObjIjJurDetail.addAll(vOtherCost);
        }

        if (vDiscount != null && vDiscount.size() > 0) {
            vectOfObjIjJurDetail.addAll(vDiscount);
        }

        if (vDPDeduction != null && vDPDeduction.size() > 0) {
            vectOfObjIjJurDetail.addAll(vDPDeduction);
        }

        if (vTotalReceivable != null && vTotalReceivable.size() > 0) {
            vectOfObjIjJurDetail.addAll(vTotalReceivable);
        }

        if (vTaxOnSales != null && vTaxOnSales.size() > 0) {
            vectOfObjIjJurDetail.addAll(vTaxOnSales);
        }

        // 4. save jurnal ke database IJ
        if (vectOfObjIjJurDetail != null && vectOfObjIjJurDetail.size() > 0) {
            boolean bJournalBalance = PstIjJournalDetail.isBalanceDebetAndCredit(vectOfObjIjJurDetail);
            if ((vectOfObjIjJurDetail != null && vectOfObjIjJurDetail.size() > 1) && bJournalBalance) {
                lResult = PstIjJournalMain.generateIjJournal(objIjJournalMain, vectOfObjIjJurDetail);

                // posting ke AISO dan update BO Status
                if (lResult != 0 && objIjEngineParam.getIConfJournalSystem() == I_IJGeneral.CFG_GRP_SYS_IJ_ENG_FULL_AUTO) {
                    SessPosting objSessPosting = new SessPosting();
                    objIjJournalMain.setOID(lResult);
                    objSessPosting.postingAisoJournal(objIjJournalMain, objIjEngineParam);
                }
            }
        }

        return lResult;
    }
    // --- end of credit sales ---





    // --- start of cash sales ---
    /**
     * Generate list of Cash Sales journal based on selected document on selected Bo system
     *
     * @param <CODE>dSelectedDate</CODE>Date of transaction selected by user
     * @param <CODE>iDocTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return Number of Cash Sales Journal process
     * @created by Edhy
     *
     * @algoritm :
     *  1. iterate as long as location count to generate CashreditSalesJournal
     */
    public int generateCashSalesJournal(Date dSelectedDate, int iDocTypeReference, IjEngineParam objIjEngineParam) {
        int result = 0;

        Vector vLocationOid = objIjEngineParam.getVLocationOid();
        if (vLocationOid != null && vLocationOid.size() > 0) {
            int iLocationCount = vLocationOid.size();
            for (int i = 0; i < iLocationCount; i++) {
                long lLocationOid = Long.parseLong(String.valueOf(vLocationOid.get(i)));
                result = result + generateCashSalesJournal(lLocationOid, dSelectedDate, iDocTypeReference, objIjEngineParam);
            }
        }

        return result;
    }


    /**
     * Generate list of Cash Sales journal based on selected document on selected Bo system
     *
     * @param <CODE>lLocationOid</CODE>ID of Location object of transaction
     * @param <CODE>dSelectedDate</CODE>Date of transaction selected by user
     * @param <CODE>iDocTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return Number of Cash Sales Journal process
     * @created by Edhy
     *
     * @algoritm :
     *  1. get list of Cash Sales Document from selected BO system
     *  2. iterate as long as document count to generate CashSalesJournal
     */
    public int generateCashSalesJournal(long lLocationOid, Date dSelectedDate, int iDocTypeReference, IjEngineParam objIjEngineParam) {
        int result = 0;

        Vector vSaleType = new Vector(1, 1);
        vSaleType.add("" + I_IJGeneral.SALE_TYPE_REGULAR);
        vSaleType.add("" + I_IJGeneral.SALE_TYPE_CONSIGNMENT);
        vSaleType.add("" + I_IJGeneral.SALE_TYPE_PERSONAL);

        int iMaxSaleType = vSaleType.size();
        for (int it = 0; it < iMaxSaleType; it++) {
            int iSaleType = Integer.parseInt("" + vSaleType.get(it));

            // 1. Ambil data DP (refer to IJ-Interface getListSalesOnInvoice)
            Vector vectOfSalesOnInvDoc = new Vector(1, 1);
            try {
                // --- start get list of LGR Document from selected BO system ---
                String strIjImplBo = objIjEngineParam.getSIjImplBo();
                I_BOSystem i_bosys = (I_BOSystem) Class.forName(strIjImplBo).newInstance();
                vectOfSalesOnInvDoc = i_bosys.getListSalesOnInvoice(lLocationOid, dSelectedDate, iSaleType, I_IJGeneral.TRANSACTION_TYPE_CASH);
                // --- end get list of Document from selected BO system ---

                // System.out.println(".:: ERR : Exception when instantiate interface");
                // --- start iterate as long as document count to generate LGRJournal ---
                if (vectOfSalesOnInvDoc != null && vectOfSalesOnInvDoc.size() > 0) {
                    int maxSalesOnInvDoc = vectOfSalesOnInvDoc.size();
                    for (int i = 0; i < maxSalesOnInvDoc; i++) {
                        IjSalesOnInvDoc objIjSalesOnInvDoc = (IjSalesOnInvDoc) vectOfSalesOnInvDoc.get(i);
                        long lResult = genJournalOfObjCashSales(lLocationOid, objIjSalesOnInvDoc, iDocTypeReference, objIjEngineParam);
                    }
                } else {
                    System.out.println(".::MSG : Because no document found, journaling Sales on Invoice process skip ... ");
                }
                // --- end iterate as long as document count to generate LGRJournal ---
            } catch (Exception e) {
                System.out.println(".:: ERR : Exception when instantiate interface");
            }
        }

        return result;
    }


    public long genJournalOfObjCashSales(long lLocationOid, IjSalesOnInvDoc objIjSalesOnInvDoc, int iDocTypeReference, IjEngineParam objIjEngineParam) {
        long lResult = genJournalOfObjCash(lLocationOid, objIjSalesOnInvDoc, iDocTypeReference, objIjEngineParam);
        // PROSES JURNAL HPP PENJUALAN
        lResult = genJournalOfObjInventory(lLocationOid, objIjSalesOnInvDoc, iDocTypeReference, objIjEngineParam);
        return lResult;
    }

    /**
     *
     * @param <CODE>objIjSalesOnInvDoc</CODE>object IjSalesOnInvDoc
     * @param <CODE>iDocTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return
     */
    public long genJournalOfObjCash(long lLocationOid, IjSalesOnInvDoc objIjSalesOnInvDoc, int iDocTypeReference, IjEngineParam objIjEngineParam) {
        long lResult = 0;
        Hashtable hashStandartRate = objIjEngineParam.getHStandartRate();
        String strStandartRate = (hashStandartRate.get("" + objIjSalesOnInvDoc.getDocTransCurrency())) != null ? "" + hashStandartRate.get("" + objIjSalesOnInvDoc.getDocTransCurrency()) : "1";
        double standartRate = Double.parseDouble(strStandartRate);

        System.out.println("---- start jdetail ");
        // 1. pembuatan jurnal umum (object IjJournalMain) dengan mengambil dokumen Penjualan (object IjSalesOnInvDoc).
        IjJournalMain objIjJournalMain = genObjIjJournalMain(objIjSalesOnInvDoc, TRAN_CASH_SALE, iDocTypeReference, lLocationOid, objIjEngineParam);

        // 2. start pembuatan vector of object ij jurnal detail
        Vector vectOfObjIjJurDetail = new Vector(1, 1);

        // 2.1 pembuatan jurnal detail posisi kredit (object IjJournalDetail) dengan mengambil data payment.
        Vector vLocationSalesValue = genObjIjJournalDetailLocationSalesValue(objIjSalesOnInvDoc, standartRate);

        // 2.2 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Account Mapping DPonPurchaseOrder.
        Vector vOtherCost = genObjIjJournalDetailOtherCost(objIjSalesOnInvDoc, objIjEngineParam);

        // 2.3 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Account Mapping DPonPurchaseOrder.
        Vector vDiscount = genObjIjJournalDetailSalesDiscount(objIjSalesOnInvDoc, objIjEngineParam);

        // 2.4 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Account Mapping DPonPurchaseOrder.
        Vector vDPDeduction = genObjIjJournalDetailDPDeduction(objIjSalesOnInvDoc, objIjEngineParam);

        // 2.5 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Account Mapping DPonPurchaseOrder.
        Vector vTaxOnSales = new Vector(1, 1);
        double totalTaxOnSales = 0;
        if (objIjEngineParam.getIConfTaxOnSales() == I_IJGeneral.CFG_GRP_TAX_SALES_VAT_RPT) {
            vTaxOnSales = genObjIjJournalDetailTaxOnSales(objIjSalesOnInvDoc, objIjEngineParam);
            totalTaxOnSales = getTotalTaxOnSales(vTaxOnSales);
        }

        // bobo
        // penambahan other cost ke penjualan
        /*if (vLocationSalesValue != null && vLocationSalesValue.size() > 0) {
            double hrg_cost = totalTaxOnSales / vLocationSalesValue.size();
            for (int k = 0; k < vLocationSalesValue.size(); k++) {
                IjJournalDetail ijJournalDetail = (IjJournalDetail) vLocationSalesValue.get(k);
                ijJournalDetail.setJdetCredit(ijJournalDetail.getJdetCredit() + hrg_cost);
            }
        }*/
        //------------

        // 2.6 pembuatan jurnal detail posisi debet (object IjJournalDetail) menggunakan Payment Mapping.
        Vector vTotalPayment = genObjIjJournalDetailPayment(lLocationOid, objIjSalesOnInvDoc, objIjEngineParam);
        System.out.println("---- finish jdetail ");

        // 3. masukkan object masing-masing account ke dalam vector of jurnal detail
        if (vLocationSalesValue != null && vLocationSalesValue.size() > 0) {
            vectOfObjIjJurDetail.addAll(vLocationSalesValue);
        }

        if (vOtherCost != null && vOtherCost.size() > 0) {
            vectOfObjIjJurDetail.addAll(vOtherCost);
        }

        if (vDiscount != null && vDiscount.size() > 0) {
            vectOfObjIjJurDetail.addAll(vDiscount);
        }

        if (vDPDeduction != null && vDPDeduction.size() > 0) {
            vectOfObjIjJurDetail.addAll(vDPDeduction);
        }

        if (vTaxOnSales != null && vTaxOnSales.size() > 0) {
            vectOfObjIjJurDetail.addAll(vTaxOnSales);
        }

        if (vTotalPayment != null && vTotalPayment.size() > 0) {
            vectOfObjIjJurDetail.addAll(vTotalPayment);
        }

        // System.out.println("vectOfObjIjJurDetail  : " + vectOfObjIjJurDetail.size());
        // 4. save jurnal ke database IJ
        if (vectOfObjIjJurDetail != null && vectOfObjIjJurDetail.size() > 0) {

            System.out.println("Debet  : " + PstIjJournalDetail.getTotalOnDebetSide(vectOfObjIjJurDetail));
            System.out.println("Credit : " + PstIjJournalDetail.getTotalOnCreditSide(vectOfObjIjJurDetail));
            boolean bJournalBalance = PstIjJournalDetail.isBalanceDebetAndCredit(vectOfObjIjJurDetail);
            if ((vectOfObjIjJurDetail != null && vectOfObjIjJurDetail.size() > 1) && bJournalBalance) {
                lResult = PstIjJournalMain.generateIjJournal(objIjJournalMain, vectOfObjIjJurDetail);
                // posting ke AISO dan update BO Status
                if (lResult != 0 && objIjEngineParam.getIConfJournalSystem() == I_IJGeneral.CFG_GRP_SYS_IJ_ENG_FULL_AUTO) {
                    SessPosting objSessPosting = new SessPosting();
                    objIjJournalMain.setOID(lResult);
                    objSessPosting.postingAisoJournal(objIjJournalMain, objIjEngineParam);
                }
            }
        }
        return lResult;
    }
    // --- end of cash sales ---

    private double getTotalTaxOnSales(Vector vIjJournalDetail) {
        return PstIjJournalDetail.getTotalOnCreditSide(vIjJournalDetail);
    }


    private Vector genObjIjJournalDetailPayment(long lLocationOid, IjSalesOnInvDoc objIjSalesOnInvDoc, IjEngineParam objIjEngineParam) {
        Vector vResult = new Vector(1, 1);

        // --- start membuat detail utk posisi debet 2 ---
        Vector listOfPayment = objIjSalesOnInvDoc.getListPayment();
        if (listOfPayment != null && listOfPayment.size() > 0) {
            Hashtable hashStandartRate = objIjEngineParam.getHStandartRate();
            PstIjPaymentMapping objPstIjPaymentMapping = new PstIjPaymentMapping();
            int PaymentCount = listOfPayment.size();
            for (int i = 0; i < PaymentCount; i++) {
                IjPaymentDoc objPaymentDoc = (IjPaymentDoc) listOfPayment.get(i);

                IjCurrencyMapping objCurrencyMapping = PstIjCurrencyMapping.getObjIjCurrencyMapping(objIjEngineParam.getIBoSystem(), objPaymentDoc.getPayCurrency());
                objPaymentDoc.setPayCurrency(objCurrencyMapping.getAisoCurrency());

                // pencarian account chart di sisi debet
                String whereClause = objPstIjPaymentMapping.fieldNames[objPstIjPaymentMapping.FLD_LOCATION] +
                        " = " + lLocationOid +
                        " AND " + objPstIjPaymentMapping.fieldNames[objPstIjPaymentMapping.FLD_PAYMENT_SYSTEM] +
                        " = " + objPaymentDoc.getPayType();
                if (objPaymentDoc.getPayCurrency() != 0) {
                    whereClause = whereClause + " AND " + objPstIjPaymentMapping.fieldNames[objPstIjPaymentMapping.FLD_CURRENCY] + " = " + objPaymentDoc.getPayCurrency();
                }

                long paymentAccChart = objPstIjPaymentMapping.getAccountChart(whereClause);
                String strStandartRate = (hashStandartRate.get("" + objPaymentDoc.getPayCurrency())) != null ? "" + hashStandartRate.get("" + objPaymentDoc.getPayCurrency()) : "1";
                double standartRate = objPaymentDoc.getPayRate(); // Double.parseDouble(strStandartRate);

                if (paymentAccChart != 0) {
                    // membuat detail utk posisi debet
                    IjJournalDetail objIjJournalDetail = new IjJournalDetail();
                    objIjJournalDetail.setJdetAccChart(paymentAccChart);
                    objIjJournalDetail.setJdetTransCurrency(objPaymentDoc.getPayCurrency());
                    objIjJournalDetail.setJdetTransRate(standartRate);
                    objIjJournalDetail.setJdetDebet((objPaymentDoc.getPayNominal()));
                    objIjJournalDetail.setJdetCredit(0);
                    vResult.add(objIjJournalDetail);
                }
            }
        }

        return vResult;
    }


    /**
     *
     * @param <CODE>objIjSalesOnInvDoc</CODE>object IjSalesOnInvDoc
     * @param <CODE>iDocTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return
     */
    public long genJournalOfObjInventory(long lLocationOid, IjSalesOnInvDoc objIjSalesOnInvDoc, int iDocTypeReference, IjEngineParam objIjEngineParam) {
        long lResult = 0;

        Hashtable hashStandartRate = objIjEngineParam.getHStandartRate();
        String strStandartRate = (hashStandartRate.get("" + objIjSalesOnInvDoc.getDocTransCurrency())) != null ? "" + hashStandartRate.get("" + objIjSalesOnInvDoc.getDocTransCurrency()) : "1";
        double standartRate = Double.parseDouble(strStandartRate);


        // 1. pembuatan jurnal umum (object IjJournalMain) dengan mengambil dokumen Penjualan (object IjSalesOnInvDoc).
        IjJournalMain objIjJournalMain = genObjIjJournalMain(objIjSalesOnInvDoc, TRAN_INVENTORY, iDocTypeReference, lLocationOid, objIjEngineParam);
        objIjJournalMain.setRefBoDocOid(0);

        // 2. start pembuatan vector of object ij jurnal detail
        Vector vectOfObjIjJurDetail = genObjIjJournalDetailLocationCostValue(objIjSalesOnInvDoc, standartRate);
        // 3. save jurnal ke database IJ
        if (vectOfObjIjJurDetail != null && vectOfObjIjJurDetail.size() > 0) {
            System.out.println("debet  : " + PstIjJournalDetail.getTotalOnDebetSide(vectOfObjIjJurDetail));
            System.out.println("credit : " + PstIjJournalDetail.getTotalOnCreditSide(vectOfObjIjJurDetail));
            boolean bJournalBalance = PstIjJournalDetail.isBalanceDebetAndCredit(vectOfObjIjJurDetail);

            if ((vectOfObjIjJurDetail != null && vectOfObjIjJurDetail.size() > 1) && bJournalBalance) {
                lResult = PstIjJournalMain.generateIjJournal(objIjJournalMain, vectOfObjIjJurDetail);
                // posting ke AISO dan update BO Status
                if (lResult != 0 && objIjEngineParam.getIConfJournalSystem() == I_IJGeneral.CFG_GRP_SYS_IJ_ENG_FULL_AUTO) {
                    SessPosting objSessPosting = new SessPosting();
                    objIjJournalMain.setOID(lResult);
                    objSessPosting.postingAisoJournal(objIjJournalMain, objIjEngineParam);
                }
            }
        }

        return lResult;
    }
    // --- end of credit sales ---

    /**
     * @param objIjSalesOnInvDoc
     * @param standartRate
     * @return
     */
    private Vector genObjIjJournalDetailLocationCostValue(IjSalesOnInvDoc objIjSalesOnInvDoc, double standartRate) {
        Vector vResult = new Vector(1, 1);

        // lakukan iterasi sebanyak "Sale Value"
        Vector listOfLocationSaleValue = objIjSalesOnInvDoc.getListSalesValue();
        if (listOfLocationSaleValue != null && listOfLocationSaleValue.size() > 0) {
            PstIjLocationMapping objPstIjLocationMappingLocSales = new PstIjLocationMapping();
            int saleValueCount = listOfLocationSaleValue.size();
            for (int iSal = 0; iSal < saleValueCount; iSal++) {
                IjSalesValue objIjSalesValue = (IjSalesValue) listOfLocationSaleValue.get(iSal);
                double totalCost = (objIjSalesValue.getCostValue() * standartRate);

                if (totalCost != 0) {
                    // Ambil Location Mapping Sales
                    IjLocationMapping objIjLocationMappingLocSales = objPstIjLocationMappingLocSales.getObjIjLocationMapping(I_IJGeneral.TRANS_COGS, objIjSalesOnInvDoc.getDocSaleType(), objIjSalesOnInvDoc.getDocTransCurrency(), objIjSalesOnInvDoc.getDocLocation(), objIjSalesValue.getProdDepartment());
                    long costAccChart = objIjLocationMappingLocSales.getAccount();
                    if (costAccChart != 0) {
                        // pembuatan jurnal detail
                        IjJournalDetail objIjJournalDetailLocSales = new IjJournalDetail();
                        objIjJournalDetailLocSales.setJdetAccChart(costAccChart);
                        objIjJournalDetailLocSales.setJdetTransCurrency(objIjSalesOnInvDoc.getDocTransCurrency());
                        objIjJournalDetailLocSales.setJdetTransRate(standartRate);
                        objIjJournalDetailLocSales.setJdetDebet(totalCost);
                        objIjJournalDetailLocSales.setJdetCredit(0);
                        vResult.add(objIjJournalDetailLocSales);
                    }


                    // Ambil Location Mapping Inventory
                    objIjLocationMappingLocSales = objPstIjLocationMappingLocSales.getObjIjLocationMapping(I_IJGeneral.TRANS_INVENTORY_LOCATION, objIjSalesOnInvDoc.getDocSaleType(), objIjSalesOnInvDoc.getDocTransCurrency(), objIjSalesOnInvDoc.getDocLocation(), objIjSalesValue.getProdDepartment());
                    long invAccChart = objIjLocationMappingLocSales.getAccount();

                    if (invAccChart != 0) {
                        // pembuatan jurnal detail
                        IjJournalDetail objIjJournalDetailLocSales = new IjJournalDetail();
                        objIjJournalDetailLocSales.setJdetAccChart(invAccChart);
                        objIjJournalDetailLocSales.setJdetTransCurrency(objIjSalesOnInvDoc.getDocTransCurrency());
                        objIjJournalDetailLocSales.setJdetTransRate(standartRate);
                        objIjJournalDetailLocSales.setJdetDebet(0);
                        objIjJournalDetailLocSales.setJdetCredit(totalCost);
                        vResult.add(objIjJournalDetailLocSales);
                    }
                }
            }
        }
        return vResult;
    }


    /**
     1. Ambil data Value of Sales (refer to IJ-Interface getListSalesOnInvoice)
     2. Ambil Account Mapping Sale (Invoicing)
     3. Ambil Transaction Location Mapping Sales Discount
     4. Ambil Account Mapping Other Cost on Invoicing
     5. Ambil Transaction Location Mapping Sales
     6. Cek Konfigurasi :
     6.1. Jika VAT Report
     o Create Jurnal :
     o Debet  : Account Mapping - Sales(Invoicing)
     o Debet  : Account Mapping - DP on Sales Order
     o Debet  : Transaction Location Mapping - Sales Discount
     o Kredit : Transaction Location Mapping - Sales
     o Kredit : Account Mapping - Other Cost on Invoicing
     o Kredit : Account Mapping - Tax on Selling

     Dipecah menjadi :
     Account Mapping - Sales(Invoicing) => PIUTANG USAHA
     Transaction Location Mapping - Sales => PENJUALAN / PENDAPATAN

     Transaction Location Mapping - Sales Discount => SALES DISCOUNT
     Account Mapping - Sales(Invoicing) => PIUTANG USAHA

     Account Mapping - Sales(Invoicing) => PIUTANG USAHA
     Account Mapping - Tax on Selling => PAJAK

     Account Mapping - DP on Sales Order => HUTANG USAHA
     Account Mapping - Sales(Invoicing) => PIUTANG USAHA

     Account Mapping - Sales(Invoicing) => PIUTANG USAHA
     Account Mapping - Other Cost on Invoicing => HUTANG KE THIRD PARTY


     6.2. Jika VAT but not Report
     o Create Jurnal :
     o Debet  : Account Mapping - Sales(Invoicing)
     o Debet  : Account Mapping - DP on Sales Order
     o Debet  : Transaction Location Mapping  Sales Discount.
     o Kredit : Transaction Location Mapping - Sales
     o Kredit : Account Mapping - Other Cost on Invoicing

     Dipecah menjadi :
     Account Mapping - Sales(Invoicing) => PIUTANG USAHA
     Transaction Location Mapping - Sales => PENJUALAN / PENDAPATAN

     Transaction Location Mapping - Sales Discount => SALES DISCOUNT
     Account Mapping - Sales(Invoicing) => PIUTANG USAHA

     Account Mapping - DP on Sales Order => HUTANG USAHA
     Account Mapping - Sales(Invoicing) => PIUTANG USAHA

     Account Mapping - Sales(Invoicing) => PIUTANG USAHA
     Account Mapping - Other Cost on Invoicing => HUTANG KE THIRD PARTY

     * @created by Edhy
     */


    /**
     * 1. Ambil data Value of Sales (refer to IJ-Interface getSalesValueonInvoice)
     * 2. Ambil Buku Pembantu Hutang (refer to IJ-AISO Interface getDPonSalesOrder). Berdasarkan DP deduction yang bersesuaian.
     * 3. Ambil Payment Mapping
     * 4. Ambil Transaction Location Mapping Sales Discount
     * 5. Ambil Account Mapping Other Cost on Invoicing
     * 6. Ambil Account Mapping DP on Sales Order
     * 7. Ambil Transaction Location Mapping Sales
     * 8. Cek Konfigurasi :
     * 1. Jika  VAT Report
     * o Ambil Account Mapping Tax on Selling
     * o Create Jurnal :
     * o Debet : Payment Mapping
     * o Debet : Account Mapping  DP on Sales Order
     * o Debet : Transaction Location Mapping-Sales Discount.
     * o Kredit : Account Mapping-Tax on Selling
     * o Kredit : Transaction Location Mapping-Sales
     *
     * 2. Jika  VAT but not Report
     * o Create Jurnal :
     * o Debet : Payment Mapping
     * o Debet : Account Mapping  DP on Sales Order
     * o Debet : Transaction Location Mapping  Sales Discount.
     * o Kredit : Transaction Location Maving-Sales
     * @created by Edhy
     *
     */


    /*
    * @param objIjSalesOnInvDoc
    * @param iSalesType
    * @param iDocTypeReference
    * @param objIjEngineParam
     *
    * @return
    */
    private IjJournalMain genObjIjJournalMain(IjSalesOnInvDoc objIjSalesOnInvDoc, int iSalesType, int iDocTypeReference, long lLocationOid, IjEngineParam objIjEngineParam) {
        IjJournalMain objIjJournalMain = new IjJournalMain();

        objIjJournalMain.setJurTransDate(objIjSalesOnInvDoc.getDocTransDate());
        objIjJournalMain.setJurBookType(objIjEngineParam.getLBookType());
        objIjJournalMain.setJurTransCurrency(objIjSalesOnInvDoc.getDocTransCurrency());
        objIjJournalMain.setJurStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
        objIjJournalMain.setJurDesc(strJournalNote[objIjEngineParam.getILanguage()][iSalesType]);
        objIjJournalMain.setRefBoSystem(objIjEngineParam.getIBoSystem());
        objIjJournalMain.setRefBoDocType(iDocTypeReference);
        objIjJournalMain.setRefBoDocOid(objIjSalesOnInvDoc.getDocId());
        objIjJournalMain.setRefBoDocNumber(objIjSalesOnInvDoc.getDocNumber());
        objIjJournalMain.setRefBoLocation(lLocationOid);
        objIjJournalMain.setRefBoDocLastUpdate(objIjSalesOnInvDoc.getDtLastUpdate());
        objIjJournalMain.setRefBoTransacTionType(objIjSalesOnInvDoc.getTransactionType());
        objIjJournalMain.setContactOid(objIjSalesOnInvDoc.getDocContact());

        return objIjJournalMain;
    }

    /**
     * @param objIjSalesOnInvDoc
     * @param standartRate
     * @return
     */
    private Vector genObjIjJournalDetailLocationSalesValue(IjSalesOnInvDoc objIjSalesOnInvDoc, double standartRate) {
        Vector vResult = new Vector(1, 1);

        // lakukan iterasi sebanyak "Sale Value"
        Vector listOfLocationSaleValue = objIjSalesOnInvDoc.getListSalesValue();
        if (listOfLocationSaleValue != null && listOfLocationSaleValue.size() > 0) {
            PstIjLocationMapping objPstIjLocationMappingLocSales = new PstIjLocationMapping();
            int saleValueCount = listOfLocationSaleValue.size();
            for (int iSal = 0; iSal < saleValueCount; iSal++) {
                IjSalesValue objIjSalesValue = (IjSalesValue) listOfLocationSaleValue.get(iSal);

                // Ambil Location Mapping Sales
                IjLocationMapping objIjLocationMappingLocSales = objPstIjLocationMappingLocSales.getObjIjLocationMapping(I_IJGeneral.TRANS_SALES, objIjSalesOnInvDoc.getDocSaleType(), objIjSalesOnInvDoc.getDocTransCurrency(), objIjSalesOnInvDoc.getDocLocation(), objIjSalesValue.getProdDepartment());
                long salesAccChart = objIjLocationMappingLocSales.getAccount();

                if (salesAccChart != 0) {
                    // pembuatan jurnal detail
                    IjJournalDetail objIjJournalDetailLocSales = new IjJournalDetail();
                    objIjJournalDetailLocSales.setJdetAccChart(salesAccChart);
                    objIjJournalDetailLocSales.setJdetTransCurrency(objIjSalesOnInvDoc.getDocTransCurrency());
                    objIjJournalDetailLocSales.setJdetTransRate(standartRate);
                    objIjJournalDetailLocSales.setJdetDebet(0);
                    objIjJournalDetailLocSales.setJdetCredit((objIjSalesValue.getSalesValue() * standartRate));
                    vResult.add(objIjJournalDetailLocSales);
                }
            }
        }
        return vResult;
    }

    /**
     * @param vIjJournalDetail
     * @return
     */
    private double getTotalLocationSalesValue(Vector vIjJournalDetail) {
        return PstIjJournalDetail.getTotalOnCreditSide(vIjJournalDetail);
    }

    /**
     * @param objIjSalesOnInvDoc
     * @param objIjEngineParam
     * @return
     */
    private Vector genObjIjJournalDetailOtherCost(IjSalesOnInvDoc objIjSalesOnInvDoc, IjEngineParam objIjEngineParam) {
        Vector vResult = new Vector(1, 1);

        // --- start membuat detail utk posisi kredit 2 ---
        double otherCost = objIjSalesOnInvDoc.getDocOtherCost();
        if (otherCost > 0) {
            // Ambil Account Mapping Other Cost On Invoicing
            PstIjAccountMapping objPstIjAccountMapping = new PstIjAccountMapping();
            IjAccountMapping objIjAccountMapping = objPstIjAccountMapping.getObjIjAccountMapping(I_IJGeneral.TRANS_OTHER_COST_ON_INVOICING, objIjSalesOnInvDoc.getDocTransCurrency());
            long otherCostAccChart = objIjAccountMapping.getAccount();

            if (otherCostAccChart != 0) {
                IjJournalDetail objIjJournalDetailOther = new IjJournalDetail();
                objIjJournalDetailOther.setJdetAccChart(otherCostAccChart);
                objIjJournalDetailOther.setJdetTransCurrency(objIjEngineParam.getLBookType());
                objIjJournalDetailOther.setJdetTransRate(1);
                objIjJournalDetailOther.setJdetDebet(0);
                objIjJournalDetailOther.setJdetCredit(otherCost);
                vResult.add(objIjJournalDetailOther);
            }
        }
        return vResult;
    }

    /**
     * @param vIjJournalDetail
     * @return
     */
    private double getTotalOtherCostAmount(Vector vIjJournalDetail) {
        return PstIjJournalDetail.getTotalOnCreditSide(vIjJournalDetail);
    }

    /**
     * @param objIjSalesOnInvDoc
     * @param objIjEngineParam
     * @return
     */
    private Vector genObjIjJournalDetailSalesDiscount(IjSalesOnInvDoc objIjSalesOnInvDoc, IjEngineParam objIjEngineParam) {
        Vector vResult = new Vector(1, 1);

        // --- start membuat detail utk posisi debet 3 ---
        double totalDisc = objIjSalesOnInvDoc.getDocDiscount();
        if (totalDisc > 0) {
            // Ambil Location Mapping Sales Discount
            PstIjLocationMapping objPstIjLocationMapping = new PstIjLocationMapping();
            IjLocationMapping objIjLocationMapping = objPstIjLocationMapping.getObjIjLocationMapping(I_IJGeneral.TRANS_SALES_DISCOUNT, objIjSalesOnInvDoc.getDocSaleType(), objIjSalesOnInvDoc.getDocTransCurrency(), objIjSalesOnInvDoc.getDocLocation(), 0);
            long salesDiscountAccChart = objIjLocationMapping.getAccount();

            if (salesDiscountAccChart != 0) {
                IjJournalDetail objIjJournalDetail = new IjJournalDetail();
                objIjJournalDetail.setJdetAccChart(salesDiscountAccChart);
                objIjJournalDetail.setJdetTransCurrency(objIjEngineParam.getLBookType());
                objIjJournalDetail.setJdetTransRate(1);
                objIjJournalDetail.setJdetDebet(totalDisc);
                objIjJournalDetail.setJdetCredit(0);
                vResult.add(objIjJournalDetail);
            }
        }

        return vResult;
    }

    /**
     * @param vIjJournalDetail
     * @return
     */
    private double getTotalDiscount(Vector vIjJournalDetail) {
        return PstIjJournalDetail.getTotalOnDebetSide(vIjJournalDetail);
    }


    /**
     * @param objIjSalesOnInvDoc
     * @param objIjEngineParam
     * @return
     */
    private Vector genObjIjJournalDetailDPDeduction(IjSalesOnInvDoc objIjSalesOnInvDoc, IjEngineParam objIjEngineParam) {
        Vector vResult = new Vector(1, 1);

        // --- start membuat detail utk posisi debet 2 ---
        Vector listOfDpDeduction = objIjSalesOnInvDoc.getListDPDeduction();
        if (listOfDpDeduction != null && listOfDpDeduction.size() > 0) {
            Hashtable hashStandartRate = objIjEngineParam.getHStandartRate();
            PstIjAccountMapping objPstIjAccountMapping = new PstIjAccountMapping();
            int DPDeductionCount = listOfDpDeduction.size();
            for (int iDp = 0; iDp < DPDeductionCount; iDp++) {
                IjDPDeductionDoc objIjDPDeductionDoc = (IjDPDeductionDoc) listOfDpDeduction.get(iDp);

                // Ambil Account Mapping DP On Sales Order
                IjAccountMapping objIjAccountMapping = objPstIjAccountMapping.getObjIjAccountMapping(I_IJGeneral.TRANS_DP_ON_SALES_ORDER, objIjSalesOnInvDoc.getDocTransCurrency());
                long dpDeductionAccChart = objIjAccountMapping.getAccount();

                if (dpDeductionAccChart != 0) {
                    String strStandartRateDp = (hashStandartRate.get("" + objIjDPDeductionDoc.getPayCurrency())) != null ? "" + hashStandartRate.get("" + objIjDPDeductionDoc.getPayCurrency()) : "1";
                    double standartRateDp = Double.parseDouble(strStandartRateDp);

                    // pembuatan jurnal detail
                    IjJournalDetail objIjJournalDetail = new IjJournalDetail();
                    objIjJournalDetail.setJdetAccChart(dpDeductionAccChart);
                    objIjJournalDetail.setJdetTransCurrency(objIjSalesOnInvDoc.getDocTransCurrency());
                    objIjJournalDetail.setJdetTransRate(standartRateDp);
                    objIjJournalDetail.setJdetDebet((objIjDPDeductionDoc.getPayNominal() * standartRateDp));
                    objIjJournalDetail.setJdetCredit(0);
                    vResult.add(objIjJournalDetail);
                }
            }
        }

        return vResult;
    }

    /**
     * @param vIjJournalDetail
     * @return
     */
    private double getTotalDPDeduction(Vector vIjJournalDetail) {
        return PstIjJournalDetail.getTotalOnDebetSide(vIjJournalDetail);
    }


    /**
     * @param objIjSalesOnInvDoc
     * @param totalLocationSaleValue
     * @param otherCost
     * @param totalDisc
     * @param totalDpDeduction
     * @param standartRate
     * @return
     */
    private Vector genObjIjJournalDetailSalesValue(IjSalesOnInvDoc objIjSalesOnInvDoc, double totalLocationSaleValue, double otherCost, double totalDisc, double totalDpDeduction, double standartRate) {
        Vector vResult = new Vector(1, 1);

        // --- start membuat detail utk posisi debet 1 ---
        /*PstIjAccountMapping objPstIjAccountMappingDb = new PstIjAccountMapping();
        IjAccountMapping objIjAccountMappingDb = objPstIjAccountMappingDb.getObjIjAccountMapping(I_IJGeneral.TRANS_SALES, objIjSalesOnInvDoc.getDocTransCurrency());
        long salesAccChart = objIjAccountMappingDb.getAccount();*/

        // new versi bobo
        Vector listPayment = objIjSalesOnInvDoc.getListPayment();
        if (listPayment != null && listPayment.size() > 0) {
            PstIjPaymentMapping objPstIjPaymentMapping = new PstIjPaymentMapping();
            for (int k = 0; k < listPayment.size(); k++) {
                IjPaymentDoc objPaymentDoc = (IjPaymentDoc) listPayment.get(k);

                // pencarian account chart di sisi debet
                String whereClause = objPstIjPaymentMapping.fieldNames[objPstIjPaymentMapping.FLD_PAYMENT_SYSTEM] + " = " + objPaymentDoc.getPayType();
                if (objPaymentDoc.getPayCurrency() != 0) {
                    whereClause = whereClause + " AND " + objPstIjPaymentMapping.fieldNames[objPstIjPaymentMapping.FLD_CURRENCY] + " = " + objPaymentDoc.getPayCurrency();
                }
                long paymentAccChart = objPstIjPaymentMapping.getAccountChart(whereClause);

                if (paymentAccChart != 0) {
                    //String strStandartRatePay = (hashStandartRate.get("" + objPaymentDoc.getPayCurrency())) != null ? "" + hashStandartRate.get("" + objPaymentDoc.getPayCurrency()) : "1";
                    //double standartRatePay = Double.parseDouble(strStandartRatePay);

                    // membuat detail utk posisi debet
                    IjJournalDetail objIjJournalDetail = new IjJournalDetail();
                    objIjJournalDetail.setJdetAccChart(paymentAccChart);
                    objIjJournalDetail.setJdetTransCurrency(objPaymentDoc.getPayCurrency());
                    objIjJournalDetail.setJdetTransRate(standartRate);
                    objIjJournalDetail.setJdetDebet((objPaymentDoc.getPayNominal() * standartRate));
                    objIjJournalDetail.setJdetCredit(0);
                    vResult.add(objIjJournalDetail);
                }
            }
        }

        /* if (salesAccChart != 0) {
             // pembuatan jurnal detail
             IjJournalDetail objIjJournalDetail = new IjJournalDetail();
             objIjJournalDetail.setJdetAccChart(salesAccChart);
             objIjJournalDetail.setJdetTransCurrency(objIjSalesOnInvDoc.getDocTransCurrency());
             objIjJournalDetail.setJdetTransRate(standartRate);
             objIjJournalDetail.setJdetDebet((totalLocationSaleValue + otherCost - totalDisc - totalDpDeduction));
             objIjJournalDetail.setJdetCredit(0);
             vResult.add(objIjJournalDetail);
         }*/

        return vResult;
    }


    /**
     *  gadnyana
     * untuk menghandle debet dari jurnal penjualan kredit
     * @param objIjSalesOnInvDoc
     * @param totalLocationSaleValue
     * @param otherCost
     * @param totalDisc
     * @param totalDpDeduction
     * @param standartRate
     * @return
     */
    private Vector genObjIjJournalKreditDetailSalesValue(IjSalesOnInvDoc objIjSalesOnInvDoc, double totalLocationSaleValue, double otherCost, double totalDisc, double totalDpDeduction, double standartRate) {
        Vector vResult = new Vector(1, 1);

        // --- start membuat detail utk posisi debet 1 ---
        PstIjAccountMapping objPstIjAccountMappingDb = new PstIjAccountMapping();
        IjAccountMapping objIjAccountMappingDb = objPstIjAccountMappingDb.getObjIjAccountMapping(I_IJGeneral.TRANS_SALES, objIjSalesOnInvDoc.getDocTransCurrency());
        long salesAccChart = objIjAccountMappingDb.getAccount();

        if (salesAccChart != 0) {
            // pembuatan jurnal detail
            IjJournalDetail objIjJournalDetail = new IjJournalDetail();
            objIjJournalDetail.setJdetAccChart(salesAccChart);
            objIjJournalDetail.setJdetTransCurrency(objIjSalesOnInvDoc.getDocTransCurrency());
            objIjJournalDetail.setJdetTransRate(standartRate);
            objIjJournalDetail.setJdetDebet((totalLocationSaleValue + otherCost - totalDisc - totalDpDeduction));
            objIjJournalDetail.setJdetCredit(0);
            vResult.add(objIjJournalDetail);
        }
        return vResult;
    }

    /**
     * @param objIjSalesOnInvDoc
     * @param objIjEngineParam
     * @return
     */
    private Vector genObjIjJournalDetailTaxOnSales(IjSalesOnInvDoc objIjSalesOnInvDoc, IjEngineParam objIjEngineParam) {
        Vector vResult = new Vector(1, 1);

        // --- start membuat detail utk posisi kredit 3 ---
        // Ambil Account Mapping Tax On Sales
        PstIjAccountMapping objPstIjAccountMappingTax = new PstIjAccountMapping();
        IjAccountMapping objIjAccountMappingTax = objPstIjAccountMappingTax.getObjIjAccountMapping(I_IJGeneral.TRANS_TAX_ON_SELLING, objIjSalesOnInvDoc.getDocTransCurrency());
        long taxAccChart = objIjAccountMappingTax.getAccount();
        if (taxAccChart != 0 && objIjSalesOnInvDoc.getDocTax() > 0) {
            IjJournalDetail objIjJournalDetailTax = new IjJournalDetail();
            objIjJournalDetailTax.setJdetAccChart(taxAccChart);
            objIjJournalDetailTax.setJdetTransCurrency(objIjEngineParam.getLBookType());
            objIjJournalDetailTax.setJdetTransRate(1);
            objIjJournalDetailTax.setJdetDebet(0);
            objIjJournalDetailTax.setJdetCredit(objIjSalesOnInvDoc.getDocTax());
            vResult.add(objIjJournalDetailTax);
        }

        return vResult;
    }

}
