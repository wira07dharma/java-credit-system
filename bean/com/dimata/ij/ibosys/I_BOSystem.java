/*
 * I_BOSystem.java
 *
 * Created on December 29, 2004, 12:55 PM
 */

package com.dimata.ij.ibosys;

// import core java package

import java.util.Vector;
import java.util.Date;

/**
 *
 * @author  Administrator
 * @version
 */
public interface I_BOSystem {

    // --------------- Start Master Data  ---------------
    /**
     * this method used to get list Currency Type object used in BO System
     * return 'vector of obj com.dimata.common.entity.payment.CurrencyType'
     */
    public Vector getListCurrencyType();


    /**
     * this method used to get list Standart Rate object used in BO System
     * return 'vector of obj com.dimata.common.entity.payment.StandartRate'
     */
    public Vector getListStandartRate();


    /**
     * this method used to get list Location object used in BO System
     * return 'vector of obj com.dimata.common.entity.location.Location'
     */
    public Vector getListLocation();


    /**
     * this method used to get list Product Department object in BO System (special for ProChain Manufacture)
     * return 'vector of obj com.dimata.prochain.entity.masterdata.ProductDepartment'
     */
    public Vector getListProductDepartment();


    /**
     * this method used to get list Sale Type
     * look reference constant index & name in 'com.dimata.ij.I_IJGeneral'
     * return 'vector of obj com.dimata.ij.ibosys.IjSaleTypeData'
     */
    public Vector getListSaleType();


    /**
     * this method used to get list Payment System object used in BO System
     * return 'vector of obj com.dimata.common.entity.payment.PaymentSystem'
     */
    public Vector getListPaymentSystem();


    /**
     * this method used to get list Price Type object used in BO System
     * return 'vector of obj com.dimata.common.entity.payment.PriceType'
     */
    public Vector getListPriceType();
    // --------------- End Master Data  ---------------




    // --------------- Start Purchase Order ---------------
    /**
     * this method used to get list DP on Purchase Order defend on 'location' and 'date' of transaction selected by user
     * @param <CODE>lLocationOid</CODE>Purchase order's location
     * @param <CODE>transactionDate</CODE>Purchase order's transaction date
     * return 'vector of obj com.dimata.ij.ibosys.IjDPOnPODoc'
     */
    public Vector getListDPonPurchaseOrder(long lLocationOid, Date transactionDate);

    /**
     * this method used to get DP on Purchase Order document defend on 'objDPOnPODocOid' selected by user
     * @param <CODE>objDPOnPODocOid</CODE>OID of Purchase order's document
     * return 'obj com.dimata.ij.ibosys.IjDPOnPODoc'
     */
    public IjDPOnPODoc getDPonPurchaseOrderDoc(long objDPOnPODocOid);

    /**
     * this method used to update status DP on Purchase Order document with specified document status as parameter
     * @param <CODE>objDPOnPODoc</CODE>object DPOnPODoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objDPOnPODoc
     * return 'status of updated process'
     */
    public int updateStatusDPonPurchaseOrder(IjDPOnPODoc objDPOnPODoc, int iDocStatus);
    // --------------- End Purchase Order ---------------




    // --------------- Start Purchase LGR ---------------
    /**
     * this method used to get list Purchase on LGR defend on 'location' and 'date' of transaction selected by user
     * @param <CODE>lLocationOid</CODE>Purchase on LGR's location
     * @param <CODE>transactionDate</CODE>Purchase on LGR's transaction date
     * return 'vector of obj com.dimata.ij.ibosys.IjPurchaseOnLGRDoc'
     */
    public Vector getListPurchaseOnLGR(long lLocationOid, Date transactionDate);

    /**
     * this method used to get Purchase on LGR document defend on 'objPurchaseOnLGRDocOid' selected
     * @param <CODE>objPurchaseOnLGRDocOid</CODE>OID of Purchase on LGR's document
     * return 'obj com.dimata.ij.ibosys.IjPurchaseOnLGRDoc'
     */
    public IjPurchaseOnLGRDoc getPurchaseOnLGRDoc(long objPurchaseOnLGRDocOid);

    /**
     * this method used to update status Purchase on LGR document with specified document status as parameter
     * @param <CODE>objPurchaseOnLGRDoc</CODE>object IjPurchaseOnLGRDoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objPurchaseOnLGRDoc
     * return 'status of updated process'
     */
    public int updateStatusPurchaseOnLGR(IjPurchaseOnLGRDoc objPurchaseOnLGRDoc, int iDocStatus);
    // --------------- End Purchase LGR ---------------




    // --------------- Start Payment On LGR ---------------
    /**
     * this method used to get list Payment On LGR defend on 'location' and 'date' of transaction selected by user
     * @param <CODE>lLocationOid</CODE>Payment On LGR's location
     * @param <CODE>transactionDate</CODE>Payment On LGR's transaction date
     * return 'vector of obj com.dimata.ij.ibosys.IjPaymentOnLGRDoc'
     */
    public Vector getListPaymentOnLGR(long lLocationOid, Date transactionDate);

    /**
     * this method used to get Payment On LGR document defend on 'objPaymentOnLGRDocOid' selected
     * @param <CODE>objPaymentOnLGRDocOid</CODE>OID of Payment On LGR's document
     * return 'obj com.dimata.ij.ibosys.IjPaymentOnLGRDoc'
     */
    public IjPaymentOnLGRDoc getPaymentOnLGRDoc(long objPaymentOnLGRDocOid);

    /**
     * this method used to update status Payment On LGR document with specified document status as parameter
     * @param <CODE>objPaymentOnLGRDoc</CODE>object IjPaymentOnLGRDoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objPaymentOnLGRDoc
     * return 'status of updated process'
     */
    public int updateStatusPaymentOnLGR(IjPaymentOnLGRDoc objPaymentOnLGRDoc, int iDocStatus);
    // --------------- End Payment On LGR ---------------





    // --------------- Start Production Order ---------------
    /**
     * this method used to get list DP on Production Order defend on 'location' and 'date' of transaction selected by user
     * @param <CODE>lLocationOid</CODE>Production order's location
     * @param <CODE>transactionDate</CODE>Production order's transaction date
     * return 'vector of obj com.dimata.ij.ibosys.DPOnPdODoc'
     */
    public Vector getListDPonProductionOrder(long lLocationOid, Date transactionDate);

    /**
     * this method used to get DP on Production Order document defend on 'objDPOnPdODocOid' selected
     * @param <CODE>objDPOnPdODocOid</CODE>OID of Production order's document
     * return 'obj com.dimata.ij.ibosys.IjDPOnPdODoc'
     */
    public IjDPOnPdODoc getDPonProductionOrderDoc(long objDPOnPdODocOid);

    /**
     * this method used to update status DP on Production Order document with specified document status as parameter
     * @param <CODE>objDPOnPdODoc</CODE>object DPOnPdODoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objDPOnPdODoc
     * return 'status of updated process'
     */
    public int updateStatusDPonProductionOrder(IjDPOnPdODoc objDPOnPdODoc, int iDocStatus);
    // --------------- End Production Order ---------------





    // --------------- Start Inventory On DF ---------------
    /**
     * this method used to get list Production Cost On LGR defend on 'location', 'date' and 'dftype' of transaction selected by user
     * @param <CODE>lLocationOid</CODE>Inventory On DF's location
     * @param <CODE>transactionDate</CODE>Inventory On DF's transaction date
     * @param <CODE>dfType</CODE>DF type, see "com.dimata.ij.I_IJGeneral"
     * return 'vector of obj com.dimata.ij.ibosys.IjInventoryOnDFDoc'
     */
    public Vector getListInventoryOnDF(long lLocationOid, Date transactionDate, int dfType);

    /**
     * this method used to get Inventory On DF document defend on 'objInventoryOnDFDocOid' selected
     * @param <CODE>objInventoryOnDFDocOid</CODE>OID of Inventory On DF's document
     * return 'obj com.dimata.ij.ibosys.IjInventoryOnDFDoc'
     */
    public IjInventoryOnDFDoc getInventoryOnDFDoc(long objInventoryOnDFDocOid);

    /**
     * this method used to update status Inventory On DF document with specified document status as parameter
     * @param <CODE>objInventoryOnDFDoc</CODE>object InventoryOnDFDoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objInventoryOnDFDoc
     * return 'status of updated process'
     */
    public int updateStatusInventoryOnDF(IjInventoryOnDFDoc objInventoryOnDFDoc, int iDocStatus);
    // --------------- End Inventory On DF ---------------




    // --------------- Start Production Cost On LGR ---------------
    /**
     * this method used to get list Production Cost On LGR defend on 'location' and 'date' of transaction selected by user
     * @param <CODE>lLocationOid</CODE>Production Cost On LGR's location
     * @param <CODE>transactionDate</CODE>Production Cost On LGR's transaction date
     * return 'vector of obj com.dimata.ij.ibosys.IjProdCostOnLGRDoc'
     */
    public Vector getListProductionCostOnLGR(long lLocationOid, Date transactionDate);

    /**
     * this method used to get Production Cost On LGR document defend on 'objProdCostOnLGRDocOid' selected
     * @param <CODE>objProdCostOnLGRDocOid</CODE>OID of Production Cost On LGR's document
     * return 'obj com.dimata.ij.ibosys.IjProdCostOnLGRDoc'
     */
    public IjProdCostOnLGRDoc getProductionCostOnLGRDoc(long objProdCostOnLGRDocOid);


    /**
     * this method used to update status Production Cost on LGR document with specified document status as parameter
     * @param <CODE>objProdCostOnLGRDoc</CODE>object IjProdCostOnLGRDoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objProdCostOnLGRDoc
     * return 'status of updated process'
     */
    public int updateStatusProductionCostOnLGR(IjProdCostOnLGRDoc objProdCostOnLGRDoc, int iDocStatus);
    // --------------- End Production Cost On LGR ---------------




    // --------------- Start Sales Order ---------------
    /**
     * this method used to get list DP on Sales Order defend on 'location' and 'date' of transaction selected by user
     * @param <CODE>lLocationOid</CODE>Sales order's location
     * @param <CODE>transactionDate</CODE>Sales order's transaction date
     * return 'vector of obj com.dimata.ij.ibosys.IjDPOnSODoc'
     */
    public Vector getListDPonSalesOrder(long lLocationOid, Date transactionDate);

    /**
     * this method used to get DP on Sales Order document defend on 'objDPOnSODocOid' selected by user
     * @param <CODE>objDPOnSODocOid</CODE>OID of Sales order's document
     * return 'obj com.dimata.ij.ibosys.IjDPOnSODoc'
     */
    public IjDPOnSODoc getDPonSalesOrderDoc(long objDPOnSODocOid);

    /**
     * this method used to update status DP on Sales Order document with specified document status as parameter
     * @param <CODE>objDPOnSODoc</CODE>object DPOnSODoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objDPOnSODoc
     * return 'status of updated process'
     */
    public int updateStatusDPonSalesOrder(IjDPOnSODoc objDPOnSODoc, int iDocStatus);
    // --------------- End Sales Order ---------------




    // --------------- Start Sales On Invoice ---------------
    /**
     * this method used to get list Sales On Invoice defend on 'location', 'date', 'saletype' and 'transtype' of transaction selected by user
     * @param <CODE>lLocationOid</CODE>Sales On Invoice's location
     * @param <CODE>transactionDate</CODE>Sales On Invoice's transaction date
     * @param <CODE>salesType</CODE>Sales type, see "com.dimata.ij.I_IJGeneral"
     * @param <CODE>transactionType</CODE>Transaction Type, see "com.dimata.ij.I_IJGeneral"
     * return 'vector of obj com.dimata.ij.ibosys.IjSalesOnInvDoc'
     */
    public Vector getListSalesOnInvoice(long lLocationOid, Date transactionDate, int salesType, int transactionType);

    /**
     * this method used to get Sales On Invoice document defend on 'objSalesOnInvDocOid' selected
     * @param <CODE>objSalesOnInvDocOid</CODE>OID of Sales On Invoice's document
     * return 'obj com.dimata.ij.ibosys.IjSalesOnInvDoc'
     */
    public IjSalesOnInvDoc getSalesOnInvoiceDoc(long objSalesOnInvDocOid);

    /**
     * Ini di gunakan untuk mencari document penjualan sesuai shift id
     * @param <CODE>objSalesOnInvDocOid</CODE>OID of Sales On Invoice's document
     * return 'obj com.dimata.ij.ibosys.IjSalesOnInvDoc'
     */
    public IjSalesOnInvDoc getSalesOnInvoiceDoc(long docId, long lLocationOid, Date transactionDate, int salesType, int transactionType);

    /**
     * this method used to update status Inventory On DF document with specified document status as parameter
     * @param <CODE>objSalesOnInvDoc</CODE>object IjSalesOnInvDoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objSalesOnInvDoc
     * return 'status of updated process'
     */
    public int updateStatusSalesOnInvoice(IjSalesOnInvDoc objSalesOnInvDoc, int iDocStatus);

    /**
     * gadnyana
     * untuk update penjualan yang kredit
     * @param objSalesOnInvDoc
     * @param iDocStatus
     * @return
     */
    public int updateStatusSalesCreditOnInvoice(IjSalesOnInvDoc objSalesOnInvDoc, int iDocStatus);


    // --------------- End Sales On Invoice ---------------




    // --------------- Start Payment On Invoice ---------------
    /**
     * this method used to get list Payment On Invoice defend on 'location' and 'date' of transaction selected by user
     * @param <CODE>lLocationOid</CODE>Payment On LGR's location
     * @param <CODE>transactionDate</CODE>Payment On Invoice's transaction date
     * return 'vector of obj com.dimata.ij.ibosys.IjPaymentOnInvDoc'
     */
    public Vector getListPaymentOnInvoice(long lLocationOid, Date transactionDate);

    /**
     * this method used to get Payment On Invoice document defend on 'objPaymentOnInvDocOid' selected
     * @param <CODE>objPaymentOnInvDocOid</CODE>OID of Payment On Invoice's document
     * return 'obj com.dimata.ij.ibosys.IjPaymentOnInvDoc'
     */
    public IjPaymentOnInvDoc getPaymentOnInvoiceDoc(long objPaymentOnInvDocOid);

    /**
     * this method used to update status Payment On Invoice document with specified document status as parameter
     * @param <CODE>objPaymentOnInvDoc</CODE>object objPaymentOnInvDoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objPaymentOnInvDoc
     * return 'status of updated process'
     */
    public int updateStatusPaymentOnInvoice(IjPaymentOnInvDoc objPaymentOnInvDoc, int iDocStatus);
    // --------------- End Payment On Invoice ---------------





    // --------------- Start Payment Type ---------------
    /**
     * this method used to get list Payment Type defend on 'location' and 'date' of transaction selected by user
     * with document status on I_IJGeneral : PAYMENT_STATUS_POSTED_CLEARED
     * @param <CODE>lLocationOid</CODE>Payment Type's location
     * @param <CODE>transactionDate</CODE>Payment Type's transaction date
     * return 'vector of obj com.dimata.ij.ibosys.IjPaymentTypeDoc'
     */
    public Vector getListPaymentTypePostedCleared(long lLocationOid, Date transactionDate);

    /**
     * this method used to get Payment Type document defend on 'objPaymentTypeDocOid' selected
     * @param <CODE>objPaymentTypeDocOid</CODE>OID of Payment Type's document
     * return 'obj com.dimata.ij.ibosys.IjPaymentTypeDoc'
     */
    public IjPaymentTypeDoc getPaymentTypeDoc(long objPaymentTypeDocOid);

    /**
     * this method used to update status Payment On Invoice document with specified document status as parameter
     * @param <CODE>objPaymentTypeDoc</CODE>object IjPaymentTypeDoc whose status will updated
     * @param <CODE>iDocStatus</CODE>status of objPaymentTypeDoc
     * return 'status of updated process'
     */
    public int updateStatusPaymentType(IjPaymentTypeDoc objPaymentTypeDoc, int iDocStatus);
    // --------------- End Payment Type ---------------
}
