/*
 * SessPosting.java
 *
 * Created on October 8, 2005, 6:48 AM
 */

package com.dimata.ij.session.engine;

// import core java package

import java.util.Vector;
import java.util.Date;

// import dimata package
import com.dimata.util.*;
import com.dimata.util.lang.*;

// qdep package
import com.dimata.qdep.entity.I_DocStatus;

// interfaces package
import com.dimata.ij.I_IJGeneral;

// import ij package
import com.dimata.ij.iaiso.*;
import com.dimata.ij.ibosys.*;
import com.dimata.ij.entity.configuration.*;

/**
 *
 * @author  Administrator
 * @version
 */
public class SessPosting {

    /**
     * Used to posting list of journal to AISO, update IJ journal reference and update Bo Doc Status
     * @param vListIjJournal
     * @param objIjEngineParam
     *
     * @created by Edhy
     * @algoritm :
     *  - looping / iterate as long as ListIjJornal count
     *  - each iterate, do process below :
     *      - posting journal to AISO
     *      - update ij journal with data reference got from AISO
     *      - update Bo Document status to POSTED if process above success
     */
    public void postingAisoJournal(Vector vListIjJournal, IjEngineParam objIjEngineParam) {
        if (vListIjJournal != null && vListIjJournal.size() > 0) {
            int iListIjJournalCount = vListIjJournal.size();
            for (int i = 0; i < iListIjJournalCount; i++) {
                IjJournalMain objIjJournalMain = (IjJournalMain) vListIjJournal.get(i);
                postingAisoJournal(objIjJournalMain, objIjEngineParam);
            }
        }
    }


    /**
     * Used to posting list of journal to AISO, update IJ journal reference and update Bo Doc Status
     *
     * @param objIjJournalMain
     * @param objIjEngineParam
     *
     * @created by Edhy
     * @algoritm :
     *  - looping / iterate as long as ListIjJornal count
     *  - each iterate, do process below :
     *      - posting journal to AISO
     *      - update ij journal with data reference got from AISO
     *      - update Bo Document status to POSTED if process above success
     */
    public void postingAisoJournal(IjJournalMain objIjJournalMain, IjEngineParam objIjEngineParam) {
        // get from param
        Date dStartDatePeriode = objIjEngineParam.getDStartDatePeriode();
        Date dEndDatePeriode = objIjEngineParam.getDEndDatePeriode();
        Date dLastEntryDatePeriode = objIjEngineParam.getDLastEntryDatePeriode();

        objIjJournalMain.setJurPeriod(objIjEngineParam.getLCurrPeriodeOid());
        objIjJournalMain.setJurUser(objIjEngineParam.getLOperatorOid());
        objIjJournalMain.setJurEntryDate(new Date());

        try {
            // proses save journal to AISO
            System.out.println(">>> .:: SessPosting - Start save journal to AISO ...");
            I_Aiso i_aiso = (I_Aiso) Class.forName(I_Aiso.implClassName).newInstance();
            long lAisoJournalMainOid = i_aiso.saveJournal(objIjJournalMain, dStartDatePeriode, dEndDatePeriode, dLastEntryDatePeriode);
            System.out.println(">>> .:: SessPosting -  Finish save journal to AISO  ...");

            // uproses pdate IJ Journal "status" to POSTED and "Ref Aiso Journal" with OID journal
            if (lAisoJournalMainOid != 0) {
                System.out.println(">>> .:: SessPosting -  Start update IJJournal with AISOJournal data ...");
                objIjJournalMain.setRefAisoJournalOid(lAisoJournalMainOid);
                objIjJournalMain.setJurStatus(I_DocStatus.DOCUMENT_STATUS_POSTED);
                long lIjJournalMainOid = PstIjJournalMain.updateExc(objIjJournalMain);
                System.out.println(">>> .:: SessPosting -  Finish update IJJournal with AISOJournal data ...");

                // update Bo system status to POSTED
                if (lIjJournalMainOid != 0) {
                    System.out.println(">>> .:: SessPosting -  Start update status on Bo Document ...");
                    PstIjConfiguration objPstIjConfiguration = new PstIjConfiguration();
                    IjConfiguration objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(objIjJournalMain.getRefBoSystem(), 0, 0);
                    String strIjImplBoClassName = objIjConfiguration.getSIjImplClass();

                    int iUpdatedDocStatus = -1;
                    switch (objIjJournalMain.getRefBoDocType()) {
                        case I_IJGeneral.DOC_TYPE_PAYMENT_TYPE_POSTED_CLEARED:
                            iUpdatedDocStatus = I_DocStatus.PAYMENT_STATUS_POSTED_CLOSED;
                            break;

                        default :
                            iUpdatedDocStatus = I_DocStatus.DOCUMENT_STATUS_POSTED;
                            break;
                    }


                    System.out.println(">>> .:: objIjJournalMain lokasi : " + objIjJournalMain.getRefBoLocation());
                    System.out.println(">>> .:: objIjJournalMain : type " + objIjJournalMain.getRefBoDocType());
                    System.out.println(">>> .:: objIjJournalMain : doc oid " + objIjJournalMain.getRefBoDocOid());
                    System.out.println(">>> .:: objIjJournalMain : last date " + objIjJournalMain.getRefBoDocLastUpdate());

                    int iStatusResultOnBO = postingBODocument(objIjJournalMain, iUpdatedDocStatus, strIjImplBoClassName);
                    System.out.println(">>> .:: SessPosting -  Finish update status on Bo Document ...");
                }
            }
        } catch (Exception e) {
            System.out.println(new SessPosting().getClass().getName() + ".postingAisoJournal() Exc : " + e.toString());
        }
    }


    /**
     * Used to update related BO Document status based on parameter
     *
     * @param iDocStatus
     * @param strIjImplBoClassName
     * @param objIjJournalMain
     *
     * @return 'status of updated process'
     * @create by Edhy
     * @algoritm :
     *  - get reference Bo Document object base on BODocOID stored in objIjJournalMain object
     *  - depend on type of Bo Document, update its status to POSTED
     */
    private int postingBODocument(IjJournalMain objIjJournalMain, int iDocStatus, String strIjImplBoClassName) {
        int iResult = -1;

        int iRefBoDocType = objIjJournalMain.getRefBoDocType();
        long lRefBoDocOid = objIjJournalMain.getRefBoDocOid();
        switch (iRefBoDocType) {
            case I_IJGeneral.DOC_TYPE_DP_ON_PURCHASE_ORDER:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjDPOnPODoc objIjDPOnPODoc = i_bosystem.getDPonPurchaseOrderDoc(lRefBoDocOid);
                    iResult = i_bosystem.updateStatusDPonPurchaseOrder(objIjDPOnPODoc, iDocStatus);
                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to DPonPurchaseOrder document exc : " + e.toString());
                }
                break;


            case I_IJGeneral.DOC_TYPE_PURCHASE_ON_LGR:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjPurchaseOnLGRDoc objIjPurchaseOnLGRDoc = i_bosystem.getPurchaseOnLGRDoc(lRefBoDocOid);
                    iResult = i_bosystem.updateStatusPurchaseOnLGR(objIjPurchaseOnLGRDoc, iDocStatus);
                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to PurchaseOnLGR document exc : " + e.toString());
                }
                break;


            case I_IJGeneral.DOC_TYPE_PAYMENT_ON_LGR:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjPaymentOnLGRDoc objIjPaymentOnLGRDoc = i_bosystem.getPaymentOnLGRDoc(lRefBoDocOid);
                    iResult = i_bosystem.updateStatusPaymentOnLGR(objIjPaymentOnLGRDoc, iDocStatus);
                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to PaymentOnLGR document exc : " + e.toString());
                }
                break;


            case I_IJGeneral.DOC_TYPE_DP_ON_PRODUCTION_ORDER:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjDPOnPdODoc objIjDPOnPdODoc = i_bosystem.getDPonProductionOrderDoc(lRefBoDocOid);
                    iResult = i_bosystem.updateStatusDPonProductionOrder(objIjDPOnPdODoc, iDocStatus);
                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to DPonProductionOrder document exc : " + e.toString());
                }
                break;


            case I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjInventoryOnDFDoc objIjInventoryOnDFDoc = i_bosystem.getInventoryOnDFDoc(lRefBoDocOid);
                    iResult = i_bosystem.updateStatusInventoryOnDF(objIjInventoryOnDFDoc, iDocStatus);
                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to InventoryOnDF document exc : " + e.toString());
                }
                break;


            case I_IJGeneral.DOC_TYPE_PROD_COST_ON_LGR:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjProdCostOnLGRDoc objIjProdCostOnLGRDoc = i_bosystem.getProductionCostOnLGRDoc(lRefBoDocOid);
                    iResult = i_bosystem.updateStatusProductionCostOnLGR(objIjProdCostOnLGRDoc, iDocStatus);
                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to ProductionCostOnLGR document exc : " + e.toString());
                }
                break;


            case I_IJGeneral.DOC_TYPE_DP_ON_SALES_ORDER:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjDPOnSODoc objIjDPOnSODoc = i_bosystem.getDPonSalesOrderDoc(lRefBoDocOid);
                    iResult = i_bosystem.updateStatusDPonSalesOrder(objIjDPOnSODoc, iDocStatus);
                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to DPonSalesOrder document exc : " + e.toString());
                }
                break;


            case I_IJGeneral.DOC_TYPE_SALES_ON_INV:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjSalesOnInvDoc objIjSalesOnInvDoc = new IjSalesOnInvDoc();
                    if (objIjJournalMain.getRefBoTransacTionType() == I_IJGeneral.TRANSACTION_TYPE_CREDIT) {
                        objIjSalesOnInvDoc = i_bosystem.getSalesOnInvoiceDoc(lRefBoDocOid);
                        iResult = i_bosystem.updateStatusSalesCreditOnInvoice(objIjSalesOnInvDoc, iDocStatus);

                    } else if (objIjJournalMain.getRefBoTransacTionType() == I_IJGeneral.TRANSACTION_TYPE_CASH) {

                        objIjSalesOnInvDoc = i_bosystem.getSalesOnInvoiceDoc(lRefBoDocOid, objIjJournalMain.getRefBoLocation(), objIjJournalMain.getRefBoDocLastUpdate(), 0, I_IJGeneral.TRANSACTION_TYPE_CASH);
                        iResult = i_bosystem.updateStatusSalesOnInvoice(objIjSalesOnInvDoc, iDocStatus);
                    }

                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to SalesOnInvoice document exc : " + e.toString());
                }
                break;


            case I_IJGeneral.DOC_TYPE_PAYMENT_ON_INV:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjPaymentOnInvDoc objIjPaymentOnInvDoc = i_bosystem.getPaymentOnInvoiceDoc(lRefBoDocOid);
                    iResult = i_bosystem.updateStatusPaymentOnInvoice(objIjPaymentOnInvDoc, iDocStatus);
                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to PaymentOnInv document exc : " + e.toString());
                }
                break;


            case I_IJGeneral.DOC_TYPE_PAYMENT_TYPE_POSTED_CLEARED:
                try {
                    I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
                    IjPaymentTypeDoc objIjPaymentTypeDoc = i_bosystem.getPaymentTypeDoc(lRefBoDocOid);
                    iResult = i_bosystem.updateStatusPaymentType(objIjPaymentTypeDoc, iDocStatus);
                } catch (Exception e) {
                    System.out.println(new SessPosting().getClass().getName() + ".postedBODocument() - process to PaymentType document exc : " + e.toString());
                }
                break;


            default :
                break;
        }

        return iResult;
    }
}
