package com.dimata.posbo.session.masterdata;

import com.dimata.posbo.entity.search.SrcStockCard;
import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.qdep.entity.I_DocStatus; 
import com.dimata.qdep.entity.I_PstDocType;
import com.dimata.qdep.entity.I_DocType;
import com.dimata.util.Formater;

//replaced by widi
import com.dimata.pos.entity.billing.*;

import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.entity.purchasing.PurchaseOrder;
import com.dimata.posbo.entity.purchasing.PstPurchaseOrder;
import com.dimata.posbo.entity.purchasing.PurchaseOrderItem;
import com.dimata.posbo.entity.purchasing.PstPurchaseOrderItem;
import com.dimata.posbo.db.DBResultSet;
import com.dimata.posbo.db.DBHandler;
import com.dimata.posbo.session.warehouse.SessMatReceive;
import com.dimata.common.entity.periode.Periode;
import com.dimata.common.entity.periode.PstPeriode;
import com.dimata.common.entity.logger.PstDocLogger;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.payment.StandartRate;
import com.dimata.common.entity.payment.PstStandartRate;

import com.dimata.posbo.session.warehouse.SessStockCard;

//import matDispatchReceiveItem
import com.dimata.posbo.entity.warehouse.MatDispatchReceiveItem;
import com.dimata.posbo.entity.warehouse.PstMatDispatchReceiveItem;

import java.util.Date;
import java.util.Vector;
import java.sql.ResultSet;

public class SessPosting {
    // Document Type in posting
    public static final int DOC_TYPE_RECEIVE = 0;
    public static final int DOC_TYPE_RETURN = 1;
    public static final int DOC_TYPE_DISPATCH = 2;
    public static final int DOC_TYPE_SALE_REGULAR = 3;
    public static final int DOC_TYPE_SALE_COMPOSIT = 4;
    public static final int DOC_TYPE_COSTING = 5;
    public static final int DOC_TYPE_SALE_RETURN = 6;
    public static final int DOC_TYPE_FORWARDER = 7;

    // Mode in accessing MaterialStock
    public static final int MODE_UPDATE = 0;
    public static final int MODE_INSERT = 1;

    /** Holds value of property vListUnPostedLGRDoc. */
    private Vector vListUnPostedLGRDoc;

    /** Holds value of property vListUnPostedReturnDoc. */
    private Vector vListUnPostedReturnDoc;

    /** Holds value of property vListUnPostedDFDoc. */
    private Vector vListUnPostedDFDoc;

    /** Holds value of property vListUnPostedSalesDoc. */
    private Vector vListUnPostedSalesDoc;

    /** Holds value of property vListUnPostedCostDoc. */
    private Vector vListUnPostedCostDoc;

    /** Getter for property vListUnPostedLGRDoc.
     * @return Value of property vListUnPostedLGRDoc.
     *
     */
    public Vector getVListUnPostedLGRDoc() {
        return this.vListUnPostedLGRDoc;
    }

    /** Setter for property vListUnPostedLGRDoc.
     * @param vListUnPostedLGRDoc New value of property vListUnPostedLGRDoc.
     *
     */
    public void setVListUnPostedLGRDoc(Vector vListUnPostedLGRDoc) {
        this.vListUnPostedLGRDoc = vListUnPostedLGRDoc;
    }

    /** Getter for property vListUnPostedReturnDoc.
     * @return Value of property vListUnPostedReturnDoc.
     *
     */
    public Vector getVListUnPostedReturnDoc() {
        return this.vListUnPostedReturnDoc;
    }

    /** Setter for property vListUnPostedReturnDoc.
     * @param vListUnPostedReturnDoc New value of property vListUnPostedReturnDoc.
     *
     */
    public void setVListUnPostedReturnDoc(Vector vListUnPostedReturnDoc) {
        this.vListUnPostedReturnDoc = vListUnPostedReturnDoc;
    }

    /** Getter for property vListUnPostedDFDoc.
     * @return Value of property vListUnPostedDFDoc.
     *
     */
    public Vector getVListUnPostedDFDoc() {
        return this.vListUnPostedDFDoc;
    }

    /** Setter for property vListUnPostedDFDoc.
     * @param vListUnPostedDFDoc New value of property vListUnPostedDFDoc.
     *
     */
    public void setVListUnPostedDFDoc(Vector vListUnPostedDFDoc) {
        this.vListUnPostedDFDoc = vListUnPostedDFDoc;
    }

    /** Getter for property vListUnPostedSalesDoc.
     * @return Value of property vListUnPostedSalesDoc.
     *
     */
    public Vector getVListUnPostedSalesDoc() {
        return this.vListUnPostedSalesDoc;
    }

    /** Setter for property vListUnPostedSalesDoc.
     * @param vListUnPostedSalesDoc New value of property vListUnPostedSalesDoc.
     *
     */
    public void setVListUnPostedSalesDoc(Vector vListUnPostedSalesDoc) {
        this.vListUnPostedSalesDoc = vListUnPostedSalesDoc;
    }

    /** Getter for property vListUnPostedCostDoc.
     * @return Value of property vListUnPostedCostDoc.
     *
     */
    public Vector getVListUnPostedCostDoc() {
        return this.vListUnPostedCostDoc;
    }

    /** Setter for property vListUnPostedCostDoc.
     * @param vListUnPostedCostDoc New value of property vListUnPostedCostDoc.
     *
     */
    public void setVListUnPostedCostDoc(Vector vListUnPostedCostDoc) {
        this.vListUnPostedCostDoc = vListUnPostedCostDoc;
    }

    /**
     * @param postingDate
     * @param oidLocation
     * @return
     */
     synchronized public boolean postingTransDocument(Date postingDate, long oidLocation, boolean postedDateCheck) {
        boolean bPostingOK = false;
        Periode objPeriode = PstPeriode.getPeriodeRunning();
        long oidPeriode = objPeriode.getOID();

         // Process Dispatch
        Vector vUnPostedDFDoc = getUnPostedDFDocument(postingDate, oidLocation, oidPeriode, postedDateCheck);
        this.vListUnPostedDFDoc = vUnPostedDFDoc;
        System.out.println("vListUnPostedDFDoc : "+vListUnPostedDFDoc);

        // Process Receive
        Vector vUnPostedLGRDoc = getUnPostedLGRDocument(postingDate, oidLocation, oidPeriode, postedDateCheck);
        this.vListUnPostedLGRDoc = vUnPostedLGRDoc;
        System.out.println("vListUnPostedLGRDoc : "+vListUnPostedLGRDoc);

        // Process Return
        Vector vUnPostedReturnDoc = getUnPostedReturnDocument(postingDate, oidLocation, oidPeriode, postedDateCheck);
        this.vListUnPostedReturnDoc = vUnPostedReturnDoc;
        System.out.println("vListUnPostedReturnDoc : "+vListUnPostedReturnDoc);

        // Process Cost
        Vector vUnPostedCostDoc = getUnPostedCostDocument(postingDate, oidLocation, oidPeriode, postedDateCheck);
        this.vListUnPostedCostDoc = vUnPostedCostDoc;
        System.out.println("vListUnPostedCostDoc : "+vListUnPostedCostDoc);

        // Process Sale
        Vector vUnPostedSalesDoc = getUnPostedSalesDocument(postingDate, oidLocation, oidPeriode, postedDateCheck);
        //getUnPostedSalesDocument(postingDate, oidLocation, oidPeriode, postedDateCheck, DOC_TYPE_SALE_RETURN);
	
        this.vListUnPostedSalesDoc = vUnPostedSalesDoc;
        System.out.println("vListUnPostedSalesDoc : "+vListUnPostedSalesDoc);
        
        // Process Opname

        if (((vUnPostedLGRDoc != null && vUnPostedLGRDoc.size() > 0)
                || (vListUnPostedReturnDoc != null && vListUnPostedReturnDoc.size() > 0)
                || (vListUnPostedDFDoc != null && vListUnPostedDFDoc.size() > 0)
                || (vListUnPostedCostDoc != null && vListUnPostedCostDoc.size() > 0)
                || (vListUnPostedSalesDoc != null && vListUnPostedSalesDoc.size() > 0))) {
            return true;
        }

        return bPostingOK;
    }


    private Vector getTimeDurationOfTransDocument(long oidPeriode) {
        Vector vResult = new Vector(1, 1);

        // --- start get time duration of transaction document that will posting ---
        // get current period "start date" and "end date" combine to "shift"
        Date dStartDatePeriod = null;
        Date dEndDatePeriod = null;
        try {
            Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
            dStartDatePeriod = objMaterialPeriode.getStartDate();
            dEndDatePeriod = objMaterialPeriode.getEndDate();
        } catch (Exception e) {
            System.out.println("Exc " + new SessPosting().getClass().getName() + ".PostingSaleWithoutItem() - fetch period : " + e.toString());
        }

        int iDayOfShiftInterval = 0;
        String sStartTime = "";
        String sEndTime = "";
        Vector vListShift = PstShift.list(0, 0, "", PstShift.fieldNames[PstShift.FLD_START_TIME]);
        
        if (vListShift != null && vListShift.size() > 0) {
            int iShiftCount = vListShift.size();
            for (int i = 0; i < iShiftCount; i++) {
                Shift objShift = (Shift) vListShift.get(i);

                // set startTime with first record of result
                if (i == 0) {
                    sStartTime = Formater.formatDate(objShift.getStartTime(), "HH:mm:00");
                }

                // set endTime with last record of result
                if (i == (iShiftCount - 1)) {
                    sEndTime = Formater.formatDate(objShift.getEndTime(), "HH:mm:00");
                }

                if ((objShift.getStartTime().getHours()) > (objShift.getEndTime().getHours())) {
                    iDayOfShiftInterval = 1;
                }
            }
        }

        if (dEndDatePeriod != null) {
            int iOldDate = dEndDatePeriod.getDate();
            dEndDatePeriod.setDate(iOldDate + iDayOfShiftInterval);
        }

        if (dStartDatePeriod != null && dEndDatePeriod != null) {
            vResult.add(dStartDatePeriod);
            vResult.add(dEndDatePeriod);
            vResult.add(sStartTime);
            vResult.add(sEndTime);
        }

        return vResult;
    }

    // ------------------------------- POSTING RECEIVE START ---------------------------
    /**
     * This method use to posting LGR document
     * @return
     * algoritm :
     *  - posting all sales document during specified time interval (with sales item)
     *  - if there are sales document cannot posting, do posting process for outstanding trans document (without sales item)
     */
    private Vector getUnPostedLGRDocument(Date postingDate, long oidLocation, long lPeriodeOid, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;

        // --- start get time duration of transaction document that will posting ---
        // get current period "start date" and "end date" combine to "shift"
        Date dStartDatePeriod = null;
        Date dEndDatePeriod = null;
        Vector vTimeDuration = getTimeDurationOfTransDocument(lPeriodeOid);
        if (vTimeDuration != null && vTimeDuration.size() > 3) {
            dStartDatePeriod = (Date) vTimeDuration.get(0);
            dEndDatePeriod = (Date) vTimeDuration.get(1);
        }
        // --- finish get time duration of transaction document that will posting ---
        try {
            String sql = "SELECT " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] +
                    ", " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE] +
                    ", " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_FROM] +
                    " FROM " + PstMatReceive.TBL_MAT_RECEIVE;

            if (postedDateCheck) {
                sql = sql + " WHERE " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                        " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                } else {
                    sWhereClause = PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }
                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sql = sql + " WHERE " + sWhereClause;
                }
            }
            sql = sql + " ORDER BY "+PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE];
            
            //System.out.println(">>> " + new SessPosting().getClass().getName() + ".getUnPostedLGRDocument() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidRM = rs.getLong(PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID]);
                int recSource = rs.getInt(PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE]);

                Vector vErrUpdateStockByReceiveItem = new Vector(1,1);
                try {
                    vErrUpdateStockByReceiveItem = updateStockByReceiveItem(lPeriodeOid, oidLocation, oidRM, recSource);
                }
                catch(Exception e) {
                    System.out.println("Exc when get vector vErrUpdateStockByReceiveItem... "+e.toString());
                    vErrUpdateStockByReceiveItem = new Vector(1,1);
                }
                
                // Set status document receive menjadi posted
                boolean isOK = false;
                if (!(vErrUpdateStockByReceiveItem != null && vErrUpdateStockByReceiveItem.size() > 0)) {
                    isOK = setPosted(oidRM, DOC_TYPE_RECEIVE);
                }
                
                /** set status pada forwarder info dengan value terkini! */
                try {
                    String whereClause = ""+PstForwarderInfo.fieldNames[PstForwarderInfo.FLD_RECEIVE_ID]+"="+oidRM;
                    Vector vctListFi = PstForwarderInfo.list(0, 0, whereClause, "");
                    ForwarderInfo forwarderInfo = new ForwarderInfo();
                    
                    if(vctListFi.size() != 0) {
                        forwarderInfo = (ForwarderInfo)vctListFi.get(0);
                        isOK = setPosted(forwarderInfo.getOID(), DOC_TYPE_FORWARDER);
                    }
                }
                catch(Exception e) {
                    System.out.println("Exc in update status, forwarder_info >>> "+e.toString());
                }

                if (!isOK) {
                    try {
                        MatReceive objBillMain = PstMatReceive.fetchExc(oidRM);
                        vResult.add(objBillMain);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                    break;
                }
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("Exc in getUnPostedLGRDocument(#,#,#,#) : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;
        /*// posting LGR document that have lgr item
        vResult = PostingLGRToStock(dPostingDate, lLocationOid, lPeriodeOid, bPostedDateCheck);

        // posting LGR document that haven't lgr item
        Vector vUnPostedLGR = listLGRWithoutItem(lPeriodeOid, dPostingDate, lLocationOid, bPostedDateCheck);
        if (vUnPostedLGR != null && vUnPostedLGR.size() > 0) {
            vResult.addAll(vUnPostedLGR);
        }
        return vResult;*/
    }


    /**
     * gadnyana
     * proses posted doc receive
     */
    public boolean postedReceiveDoc(long oidRec){
        boolean isOK = false;
        try{
            MatReceive matReceive = PstMatReceive.fetchExc(oidRec);
            Periode periode = PstPeriode.getPeriodeRunning();
            Vector vErrUpdateStockByReceiveItem = updateStockByReceiveItem(periode.getOID(), matReceive.getLocationId(), matReceive.getOID(), matReceive.getReceiveSource());

            // Set status document receive menjadi posted
            if (!(vErrUpdateStockByReceiveItem != null && vErrUpdateStockByReceiveItem.size() > 0)) {
                isOK = setPosted(oidRec, DOC_TYPE_RECEIVE);
            }
        }catch(Exception e){
            System.out.println("err > postedReceiveDoc(long oidRec) : "+e.toString());
        }
        return isOK;
    }

    /**
     *
     * @param oidPeriode
     * @param oidLocation
     * @param lReceiveMaterialOid
     * @param recSource
     * @return
     */
    private Vector updateStockByReceiveItem(long oidPeriode, long oidLocation, long lReceiveMaterialOid, int recSource) {
        DBResultSet dbrs = null;
        Vector vResult = new Vector(1, 1);
        long oidOldLocation = 0;
        try {
            MatReceive matreceive = PstMatReceive.fetchExc(lReceiveMaterialOid);
            String sql = "SELECT " +
                    " RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MATERIAL_ID] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_CURR_BUYING_PRICE] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_CURRENCY_ID] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_QTY] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ITEM_ID] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_UNIT_ID] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_COST] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_FORWADER_COST] +
                    //+query Discount & ppn by Mirahu (19 Feb 2011)
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_DISCOUNT] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_DISCOUNT2] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_DISC_NOMINAL] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_LAST_VAT]+
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_CURR_BUY_PRICE] +
                    //end of query
                    " FROM " + PstMatReceiveItem.TBL_MAT_RECEIVE_ITEM + " RI" +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " WHERE RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ID] +
                    " = " + lReceiveMaterialOid;

            //System.out.println(">>> " + new SessPosting().getClass().getName() + ".updateStockByReceiveItem() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                long oidMaterial = rs.getLong(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MATERIAL_ID]);
                double newCost = rs.getDouble(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_COST]);
                double newForwarderCost = rs.getDouble(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_FORWADER_COST]);
                long oidCurrency = rs.getLong(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_CURRENCY_ID]);
                double recQty = rs.getDouble(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_QTY]);
                double qtyPerBaseUnit = PstUnit.getQtyPerBaseUnit(rs.getLong(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_UNIT_ID]), rs.getLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID]));
                double recQtyReal = recQty * qtyPerBaseUnit;
                double averagePrice = rs.getDouble(PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE]);
                //get discount
                double lastDisc = rs.getDouble(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_DISCOUNT]);
                double lastDisc2 = rs.getDouble(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_DISCOUNT2]);
                double lastDiscNom = rs.getDouble(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_DISC_NOMINAL]);

                double totalDiscount = newCost * lastDisc/100;
                double totalMinus = newCost - totalDiscount;
                double totalDiscount2 = totalMinus * lastDisc2/100;
                double totalCost = (totalMinus - totalDiscount2)-lastDiscNom;
                double totalCostAll = totalCost + newForwarderCost;
                //end get dan calculate discount

                //get currBuyPrice + PPn
                double lastVat = rs.getDouble(PstMaterial.fieldNames[PstMaterial.FLD_LAST_VAT]);
                double currBuyPrice = rs.getDouble(PstMaterial.fieldNames[PstMaterial.FLD_CURR_BUY_PRICE]);

                //double totalPpn = totalCost * lastVat/100;
                //double totalCurrBuyPrice = totalCost + totalPpn;
                double totalCurrBuyPrice = totalCost*(1+(lastVat/100));
                //end of currBuyPrice

                Thread.sleep(50);
                // Update Cost di Master
                boolean isOK = false;
                if ((recSource == PstMatReceive.SOURCE_FROM_SUPPLIER) ||
                        (recSource == PstMatReceive.SOURCE_FROM_SUPPLIER_PO || recSource == PstMatReceive.SOURCE_FROM_DISPATCH_UNIT )) {

                    //isOK = updateCostMaster(oidMaterial, oidCurrency, newCost);
                  if(recSource != PstMatReceive.SOURCE_FROM_DISPATCH_UNIT){
                    isOK = updateCostMaster(oidMaterial, oidCurrency, totalCost);
                    System.out.println("=============== update currBuy(cost) : "+totalCost);
                    //updateCostSupplierPrice(matreceive.getSupplierId(), oidMaterial, matreceive.getCurrencyId(), (newCost + newForwarderCost));
                    //updateCostSupplierPrice(matreceive.getSupplierId(), oidMaterial, matreceive.getCurrencyId(), (totalCost + newForwarderCost));
                    //System.out.println("=============== update cost master : "+(totalCost + newForwarderCost));

                    //updateCurrBuyPrice + PPn 
                    updateCurrBuyPriceMaster(oidMaterial, oidCurrency, totalCurrBuyPrice);
                    System.out.println("=============== update currBuyPrice+PPn : "+totalCurrBuyPrice);
                    //end of CurrBuyPrice
                  }

                    // Update average price for each receive stock
                    double new_price = 0.0;
                    double avg_new_price = 0.0;
                    StandartRate startdartRate = PstStandartRate.getActiveStandardRate(oidCurrency);
                    //newCost = (startdartRate.getSellingRate() * newCost);
                    newCost = (startdartRate.getSellingRate() * totalCost);
                    double qtyStock = checkStockMaterial(oidMaterial, oidLocation, oidPeriode);
                    //double qtyStock = checkStockMaterial(oidMaterial, 0, oidPeriode);
                    if(qtyStock < 0) qtyStock = 0;
                    avg_new_price = ((averagePrice * qtyStock) + (recQty * newCost)) / (qtyStock + recQty);
                    updateAveragePrice(oidMaterial, oidCurrency, avg_new_price);

                    /**
                     * untuk cek qty po
                     */
                    if(recSource == PstMatReceive.SOURCE_FROM_SUPPLIER_PO){
                        updateItemPO(oidMaterial,matreceive.getPurchaseOrderId(),recQty);
                    }
                } else {
                    if(recSource == PstMatReceive.SOURCE_FROM_RETURN){
                        try{
                            MatReturn matReturn = PstMatReturn.fetchExc(matreceive.getReturnMaterialId());
                            oidOldLocation = matReturn.getLocationId();
                        }catch(Exception e){}
                    }else if(recSource == PstMatReceive.SOURCE_FROM_DISPATCH){
                        try{
                            MatDispatch matDispatch = PstMatDispatch.fetchExc(matreceive.getDispatchMaterialId());
                            oidOldLocation = matDispatch.getLocationId();
                        }catch(Exception e){}
                    }
                    isOK = true;
                }

                // Check if this item is allready exists in MaterialStock
                if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {
                    if (recQtyReal > 0) {
                        isOK = updateMaterialStock(oidMaterial, oidLocation, recQtyReal, 0, MODE_UPDATE, DOC_TYPE_RECEIVE, oidPeriode);
                    }
                } else {
                    // Insert into MaterialStock
                    isOK = updateMaterialStock(oidMaterial, oidLocation, recQtyReal, 0, MODE_INSERT, DOC_TYPE_RECEIVE, oidPeriode);
                }

                if (!isOK) {
                    vResult.add(oidMaterial + " on " + lReceiveMaterialOid);
                }

                // Proses insert/update stok code
                cekInsertUpdateStockCode(oidOldLocation, oidLocation, oidMaterial, rs.getLong(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ITEM_ID]), DOC_TYPE_RECEIVE,recSource);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("Exc in updateStockByReceiveItem(#,#,#,#) : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }

        return vResult;
    }

    /**
     * Update data PO untuk
     * itemnya sesuai dengan qty receive
     * @param oidMat
     * @param oidPo
     * @param qtyRec
     */
    public void updateItemPO(long oidMat, long oidPo, double qtyRec) {
        try {
            PurchaseOrderItem purchOrderItem = new PurchaseOrderItem();
            purchOrderItem = PstPurchaseOrderItem.getPurchaseOrderItem(purchOrderItem, oidMat, oidPo);
            if (purchOrderItem.getOID() != 0) {
                if ((purchOrderItem.getQuantity() - purchOrderItem.getResiduQty()) > 0) {
                    double qtyRe = purchOrderItem.getResiduQty() + qtyRec;
                    purchOrderItem.setResiduQty(qtyRe);

                    // update item
                    PstPurchaseOrderItem.updateExc(purchOrderItem);
                    if(cekPurchaseOrder(oidPo)){
                        PurchaseOrder purchOrder = PstPurchaseOrder.fetchExc(oidPo);
                        purchOrder.setPoStatus(I_DocStatus.DOCUMENT_STATUS_POSTED);
                        PstPurchaseOrder.updateExc(purchOrder);
                    }else{
                        PurchaseOrder purchOrder = PstPurchaseOrder.fetchExc(oidPo);
                        purchOrder.setPoStatus(I_DocStatus.DOCUMENT_STATUS_FINAL);
                        PstPurchaseOrder.updateExc(purchOrder);
                    }
                }
            }
        } catch (Exception e) {
        }
    }

    /**
     *
     * @param oidPurchase
     * @return
     */
    public boolean cekPurchaseOrder(long oidPurchase) {
        DBResultSet dbrs = null;
        boolean bool = false;
        try {
            String sql = "select sum(" + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_QUANTITY] + ") as tot_qty " +
                    " ,sum(" + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_RESIDU_QTY] + ") as tot_res_qty " +
                    " from "+PstPurchaseOrderItem.TBL_PURCHASE_ORDER_ITEM+
                    " where " + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID] + "=" + oidPurchase +
                    " group by "+PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID];

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                double totalQty = rs.getDouble("tot_qty");
                double totalResiduQty = rs.getDouble("tot_res_qty");
                if(totalResiduQty < totalQty){
                    bool = false;
                }
                else{
                    bool = true;
                }
            }
        } catch (Exception e) {
        }finally{

        }
        return bool;
    }

    /**
     * @param postingDate
     * @param oidLocation
     * @param oidPeriode
     * @return
     * @update by Edhy
     * algoritm :
     1. Update Cost in Master
     2. Insert MaterialStock if not exists
     3. Inc Qty In in MaterialStock
     4. Inc Qty in MaterialStock
     5. Set document status into posted
     *
     */
    private Vector PostingLGRToStock(Date postingDate, long oidLocation, long oidPeriode, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;

        try {
            // Select all receive today with detail
            String sql = "SELECT RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] +
                    ", RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MATERIAL_ID] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_COST] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_CURRENCY_ID] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_QTY] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ITEM_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    " FROM " + PstMatReceive.TBL_MAT_RECEIVE + " RM" +
                    " INNER JOIN " + PstMatReceiveItem.TBL_MAT_RECEIVE_ITEM + " RI" +
                    " ON RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] +
                    " = RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ID] +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID];

            if (postedDateCheck) {
                sql = sql + " WHERE RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
                        " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                        " AND RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
                        " = " + oidLocation;

            } else {
                Date dStartDatePeriod = null;
                Date dEndDatePeriod = null;
                try {
                    Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                    dStartDatePeriod = objMaterialPeriode.getStartDate();
                    dEndDatePeriod = objMaterialPeriode.getEndDate();
                } catch (Exception e) {
                    System.out.println("Exc " + new SessClosing().getClass().getName() + ".PostingLGRToStock() - fetch period : " + e.toString());
                }

                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = " RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
                            " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:00:01") + "'" +
                            " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:59:59") + "'";
                }

                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sWhereClause = sWhereClause + " AND RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                } else {
                    sWhereClause = " RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND RM." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }

                sql = sql + " WHERE " + sWhereClause;
            }

            //System.out.println(">>> " + new SessClosing().getClass().getName() + ".PostingLGRToStock() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidRM = rs.getLong(1);
                int recSource = rs.getInt(2);
                long oidMaterial = rs.getLong(3);
                double newCost = rs.getDouble(4);
                long oidCurrency = rs.getLong(5);

                // jumlah dalam order per buy unit
                double recQtyPerBuyUnit = rs.getDouble(6);

                // jumlah barang per dalam buying unit relatif terhadap sell/base unit
                double qtyPerSellingUnit = PstUnit.getQtyPerBaseUnit(rs.getLong(7), rs.getLong(8));
                double averagePrice = rs.getDouble(7);

                // jumlah barang yg akan masuk stock
                double recQty = recQtyPerBuyUnit * qtyPerSellingUnit;

                // Update Cost di Master
                boolean isOK = false;
                if ((recSource == PstMatReceive.SOURCE_FROM_SUPPLIER) || (recSource == PstMatReceive.SOURCE_FROM_SUPPLIER_PO)) {
                    isOK = updateCostMaster(oidMaterial, oidCurrency, newCost);
                } else {
                    isOK = true;
                }

                // Update average price for each receive stock
                double new_price = 0.0;
                double avg_new_price = 0.0;
                double qtyStock = checkStockMaterial(oidMaterial, oidLocation, oidPeriode);
                averagePrice = averagePrice * qtyStock;
                new_price = recQty * newCost;
                avg_new_price = (averagePrice + new_price) / (qtyStock + recQty);
                //if (avg_new_price != 0) {
                //    avg_new_price = 0;
                //}
                updateAveragePrice(oidMaterial, oidCurrency, avg_new_price);


                // Check if this item is allready exists in MaterialStock
                if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {
                    // Update Qty only
                    if (recQty > 0) {
                        isOK = updateMaterialStock(oidMaterial, oidLocation, recQty, 0, MODE_UPDATE, DOC_TYPE_RECEIVE, oidPeriode);
                    }
                } else {
                    // Insert into MaterialStock
                    isOK = updateMaterialStock(oidMaterial, oidLocation, recQty, 0, MODE_INSERT, DOC_TYPE_RECEIVE, oidPeriode);
                }

                // Set status document receive menjadi posted
                if (isOK == true) {
                    isOK = setPosted(oidRM, DOC_TYPE_RECEIVE);
                }

                if (!isOK) {
                    try {
                        BillMain objBillMain = PstBillMain.fetchExc(oidRM);
                        vResult.add(objBillMain);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                    break;
                }

                // Proses insert/update stok code
                cekInsertUpdateStockCode(0, oidLocation, oidMaterial, rs.getLong(9), DOC_TYPE_RECEIVE,0);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("Exc in PostingLGRToStock(#,#,#,#) : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;
    }


    /**
     * This method using to posting LGR document without lgr item include during specified period
     * @param oidPeriode
     * @param postingDate
     * @param oidLocation
     * @param postedDateCheck
     * @return
     * @created by Edhy
     * algoritm :
     *  - list all lgr document that still draft
     *  - iterate process of set lgr document status to POSTED without care about stock
     */
    private Vector listLGRWithoutItem(long oidPeriode, Date postingDate, long oidLocation, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);

        String sWhereClause = "";
        if (postedDateCheck) {
            sWhereClause = PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
                    " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                    " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                    " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                    " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                    " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
                    " = " + oidLocation;
        } else {
            Date dStartDatePeriod = null;
            Date dEndDatePeriod = null;
            try {
                Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                dStartDatePeriod = objMaterialPeriode.getStartDate();
                dEndDatePeriod = objMaterialPeriode.getEndDate();
            } catch (Exception e) {
                System.out.println("Exc " + new SessClosing().getClass().getName() + ".listLGRWithoutItem() - fetch period : " + e.toString());
            }

            if (dStartDatePeriod != null && dEndDatePeriod != null) {
                sWhereClause = PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
                        " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:59:59") + "'";
            }

            if (sWhereClause != null && sWhereClause.length() > 0) {
                sWhereClause = sWhereClause + " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                sWhereClause = PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            }
        }

        Vector vListUnPostedLGRDoc = PstMatReceive.list(0, 0, sWhereClause, "");
        if (vListUnPostedLGRDoc != null && vListUnPostedLGRDoc.size() > 0) {
            int unPostedLGRDocCount = vListUnPostedLGRDoc.size();
            for (int i = 0; i < unPostedLGRDocCount; i++) {
                MatReceive objMatReceive = (MatReceive) vListUnPostedLGRDoc.get(i);
                vResult.add(objMatReceive);
            }
        }

        return vResult;
    }
    // ------------------------------- POSTING RECEIVE FINISH ---------------------------





    // ------------------------------- POSTING RETURN START ---------------------------
    /**
     * This method use to posting return document
     * @param dPostingDate
     * @param lLocationOid
     * @param lPeriodeOid
     * @param bPostedDateCheck
     * @return
     * @created by Edhy
     * algoritm :
     *  - posting all return document during specified time interval (with return item)
     *  - if there are return document cannot posting, do posting process for outstanding trans document (without return item)
     */
    private Vector getUnPostedReturnDocument(Date postingDate, long oidLocation, long oidPeriode, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;

        // --- start get time duration of transaction document that will posting ---
        // get current period "start date" and "end date" combine to "shift"
        Date dStartDatePeriod = null;
        Date dEndDatePeriod = null;
        String sStartTime = "";
        String sEndTime = "";
        Vector vTimeDuration = getTimeDurationOfTransDocument(oidPeriode);
        if (vTimeDuration != null && vTimeDuration.size() > 3) {
            dStartDatePeriod = (Date) vTimeDuration.get(0);
            dEndDatePeriod = (Date) vTimeDuration.get(1);
            sStartTime = (String) vTimeDuration.get(2);
            sEndTime = (String) vTimeDuration.get(3);
        }
        // --- finish get time duration of transaction document that will posting ---


        try {
            // Select all receive today with detail
            String sql = "SELECT " + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_MATERIAL_ID] +
                    ", " + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_SOURCE] +
                    " FROM " + PstMatReturn.TBL_MAT_RETURN;

            if (postedDateCheck) {
                sql = sql + " WHERE " + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                        " AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] +
                        " = " + oidLocation;

                /*" AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_DATE] +
                " BETWEEN \"" + Formater.formatDate(postingDate, "yyyy-MM-dd") + " " + sStartTime + "\"" +
                " AND \"" + Formater.formatDate(postingDate, "yyyy-MM-dd") + " " + sEndTime + "\"";*/
            } else {
                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] +
                            " = " + oidLocation;

                    /*" AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_DATE] +
                    " BETWEEN \"" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd") + " " + sStartTime + "\"" +
                    " AND \"" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd") + " " + sEndTime + "\"";*/
                } else {
                    sWhereClause = PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }

                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sql = sql + " WHERE " + sWhereClause;
                }
            }

            //System.out.println(">>> " + new SessPosting().getClass().getName() + ".getUnPostedReturnDocument() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidRET = rs.getLong(1);
                int retSource = rs.getInt(2);

                Vector vErrUpdateStockByReturnItem = updateStockByReturnItem(oidPeriode, oidLocation, oidRET);

                // Set status document receive menjadi posted
                boolean isOK = false;
                if (!(vErrUpdateStockByReturnItem != null && vErrUpdateStockByReturnItem.size() > 0)) {
                    isOK = setPosted(oidRET, DOC_TYPE_RETURN);
                }

                if (!isOK) {
                    try {
                        MatReturn objBillMain = PstMatReturn.fetchExc(oidRET);
                        vResult.add(objBillMain);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                    break;
                }
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("RET : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;

        /**Vector vResult = new Vector(1, 1);
         // posting Return document that have return item
         vResult = PostingReturnToStock(dPostingDate, lLocationOid, lPeriodeOid, bPostedDateCheck);
         // posting Return document that haven't resutn item
         Vector vUnPostedReturn = listReturnDocWithoutItem(lPeriodeOid, dPostingDate, lLocationOid, bPostedDateCheck);
         if (vUnPostedReturn != null && vUnPostedReturn.size() > 0) {
         vResult.addAll(vUnPostedReturn);
         }
         return vResult;*/
    }

    synchronized private Vector updateStockByReturnItem(long oidPeriode, long oidLocation, long lReturnOid) {
        DBResultSet dbrs = null;
        Vector vResult = new Vector(1, 1);

        try {
            MatReturn matreturn = PstMatReturn.fetchExc(lReturnOid);

            // Select all receive today with detail
            String sql = "SELECT RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_MATERIAL_ID] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_COST] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_CURRENCY_ID] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_QTY] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_RETURN_MATERIAL_ITEM_ID] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_UNIT_ID] +
                    " FROM " + PstMatReturnItem.TBL_MAT_RETURN_ITEM + " RTI" +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " WHERE RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_RETURN_MATERIAL_ID] +
                    " = " + lReturnOid;

            // System.out.println(">>> " + new SessPosting().getClass().getName() + ".updateStockByReturnItem() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                long oidMaterial = rs.getLong(1);
                double newCost = rs.getDouble(2);
                long oidCurrency = rs.getLong(3);
                double rtnQty = rs.getDouble(4);
                double qtyBase = PstUnit.getQtyPerBaseUnit(rs.getLong(PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_UNIT_ID]), rs.getLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID]));
                double rtnQtyReal = rtnQty * qtyBase;
                //System.out.println(">>> rtnQty: "+rtnQty+"\n>>> rtnQtyReal: "+rtnQtyReal);
                Thread.sleep(100);
                // Update Cost di Master
                boolean isOK = false;

                // jumlah barang per dalam buying unit relatif terhadap sell/base unit
                // int qtyPerSellingUnit = PstUnit.getQtyPerBaseUnit(rs.getLong(5), rs.getLong(6));

                // jumlah barang yg akan masuk stock
                // retQty = retQty * qtyPerSellingUnit;

                // Check if this item is allready exists in MaterialStock
                if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {
                    // Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, rtnQtyReal, MODE_UPDATE, DOC_TYPE_RETURN, oidPeriode);
                } else {
                    // Insert Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, rtnQtyReal, MODE_INSERT, DOC_TYPE_RETURN, oidPeriode);
                }

                if (!isOK) {
                    vResult.add(oidMaterial + " on " + lReturnOid);
                }
                // Proses insert/update stok code
                cekInsertUpdateStockCode(matreturn.getReturnTo(), oidLocation, oidMaterial, rs.getLong(7), DOC_TYPE_RETURN,0);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("RET : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }

        return vResult;
    }


    /**
     * @param postingDate
     * @param oidLocation
     * @param oidPeriode
     * @return
     * @update by Edhy
     * algoritm :
     *  - Inc Qty Out in MaterialStock
     *  - Dec Qty in MaterialStock
     *  -Set document status into posted
     */
    private Vector PostingReturnToStock(Date postingDate, long oidLocation, long oidPeriode, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;
        try {
            // Select all receive today with detail
            String sql = "SELECT RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_MATERIAL_ID] +
                    ", RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_SOURCE] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_MATERIAL_ID] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_COST] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_CURRENCY_ID] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_QTY] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_RETURN_MATERIAL_ITEM_ID] +
                    " FROM " + PstMatReturn.TBL_MAT_RETURN + " RET" +
                    " INNER JOIN " + PstMatReturnItem.TBL_MAT_RETURN_ITEM + " RTI" +
                    " ON RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_MATERIAL_ID] +
                    " = RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_RETURN_MATERIAL_ID] +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON RTI." + PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID];

            if (postedDateCheck) {
                sql = sql + " WHERE RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_DATE] +
                        " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                        " AND RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                Date dStartDatePeriod = null;
                Date dEndDatePeriod = null;
                try {
                    Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                    dStartDatePeriod = objMaterialPeriode.getStartDate();
                    dEndDatePeriod = objMaterialPeriode.getEndDate();
                } catch (Exception e) {
                    System.out.println("Exc " + new SessClosing().getClass().getName() + ".PostingReturnToStock() - fetch period : " + e.toString());
                }

                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = " RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_DATE] +
                            " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:;00:01") + "'" +
                            " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:59:59") + "'";
                }

                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sWhereClause = sWhereClause + " AND RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                } else {
                    sWhereClause = " RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND RET." + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }

                sql = sql + " WHERE " + sWhereClause;
            }

            // System.out.println(">>> " + new SessClosing().getClass().getName() + ".PostingReturnToStock() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidRET = rs.getLong(1);
                int retSource = rs.getInt(2);
                long oidMaterial = rs.getLong(3);
                double newCost = rs.getDouble(4);
                long oidCurrency = rs.getLong(5);
                double retQty = rs.getDouble(6);

                // Update Cost di Master
                boolean isOK = false;

                // jumlah barang per dalam buying unit relatif terhadap sell/base unit
                double qtyPerSellingUnit = PstUnit.getQtyPerBaseUnit(rs.getLong(7), rs.getLong(8));

                // jumlah barang yg akan masuk stock
                retQty = retQty * qtyPerSellingUnit;

                // Check if this item is allready exists in MaterialStock
                if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {
                    // Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, retQty, MODE_UPDATE, DOC_TYPE_RETURN, oidPeriode);
                } else {
                    // Insert Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, retQty, MODE_INSERT, DOC_TYPE_RETURN, oidPeriode);
                }

                // Set status document receive menjadi posted
                if (isOK == true) {
                    isOK = setPosted(oidRET, DOC_TYPE_RETURN);
                }


                if (!isOK) {
                    try {
                        BillMain objBillMain = PstBillMain.fetchExc(oidRET);
                        vResult.add(objBillMain);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                    break;
                }

                // Proses insert/update stok code
                cekInsertUpdateStockCode(0, oidLocation, oidMaterial, rs.getLong(9), DOC_TYPE_RETURN,0);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("RET : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;
    }


    /**
     * This method using to posting Return document without return item include during specified period
     * @param oidPeriode
     * @param postingDate
     * @param oidLocation
     * @param postedDateCheck
     * @return
     * @created by Edhy
     * algoritm :
     *  - list all return document that still draft
     *  - iterate process of set return document status to POSTED without care about stock
     */
    private Vector listReturnDocWithoutItem(long oidPeriode, Date postingDate, long oidLocation, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        String sWhereClause = "";
        if (postedDateCheck) {
            sWhereClause = PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_DATE] +
                    " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                    " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                    " AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                    " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                    " AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] +
                    " = " + oidLocation;
        } else {
            Date dStartDatePeriod = null;
            Date dEndDatePeriod = null;
            try {
                Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                dStartDatePeriod = objMaterialPeriode.getStartDate();
                dEndDatePeriod = objMaterialPeriode.getEndDate();
            } catch (Exception e) {
                System.out.println("Exc " + new SessClosing().getClass().getName() + ".listReturnDocWithoutItem() - fetch period : " + e.toString());
            }
            if (dStartDatePeriod != null && dEndDatePeriod != null) {
                sWhereClause = PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_DATE] +
                        " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:59:59") + "'";
            }

            if (sWhereClause != null && sWhereClause.length() > 0) {
                sWhereClause = sWhereClause + " AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                sWhereClause = PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstMatReturn.fieldNames[PstMatReturn.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            }
        }

        Vector vListUnPostedReturnDoc = PstMatReturn.list(0, 0, sWhereClause, "");
        if (vListUnPostedReturnDoc != null && vListUnPostedReturnDoc.size() > 0) {
            int unPostedReturnDocCount = vListUnPostedReturnDoc.size();
            for (int i = 0; i < unPostedReturnDocCount; i++) {
                MatReturn objMatReturn = (MatReturn) vListUnPostedReturnDoc.get(i);
                vResult.add(objMatReturn);
            }
        }

        return vResult;
    }
    // ------------------------------- POSTING RETURN FINISH ---------------------------





    // ------------------------------- POSTING DISPATCH START ---------------------------
    /**
     * This method use to posting dispatch document
     * @param dPostingDate
     * @param lLocationOid
     * @param lPeriodeOid
     * @param bPostedDateCheck
     * @return
     * @created by Edhy
     * algoritm :
     *  - posting all dispatch document during specified time interval (with df item)
     *  - if there are dispatch document cannot posting, do posting process for outstanding trans document (without df item)
     */
    private Vector getUnPostedDFDocument(Date postingDate, long oidLocation, long oidPeriode, boolean postedDateCheck) {

        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;

        // --- start get time duration of transaction document that will posting ---
        // get current period "start date" and "end date" combine to "shift"
        Date dStartDatePeriod = null;
        Date dEndDatePeriod = null;
        String sStartTime = "";
        String sEndTime = "";
        Vector vTimeDuration = getTimeDurationOfTransDocument(oidPeriode);
        if (vTimeDuration != null && vTimeDuration.size() > 3) {
            dStartDatePeriod = (Date) vTimeDuration.get(0);
            dEndDatePeriod = (Date) vTimeDuration.get(1);
            sStartTime = (String) vTimeDuration.get(2);
            sEndTime = (String) vTimeDuration.get(3);
        }
        // --- finish get time duration of transaction document that will posting ---

        try {
            // Select all receive today with detail
            String sql = "SELECT " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_MATERIAL_ID] +
                    " FROM " + PstMatDispatch.TBL_DISPATCH;

            if (postedDateCheck) {
                sql = sql + " WHERE " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                        " AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] +
                        " = " + oidLocation;

                /*" AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE] +
                " BETWEEN \"" + Formater.formatDate(postingDate, "yyyy-MM-dd") + " " + sStartTime + "\"" +
                " AND \"" + Formater.formatDate(postingDate, "yyyy-MM-dd") + " " + sEndTime + "\"";*/
            } else {
                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] +
                            " = " + oidLocation;

                    /*" AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE] +
                    " BETWEEN \"" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd") + " " + sStartTime + "\"" +
                    " AND \"" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd") + " " + sEndTime + "\"";*/
                } else {
                    sWhereClause = PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }

                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sql = sql + " WHERE " + sWhereClause;
                }
            }

            //System.out.println(">>> " + new SessPosting().getClass().getName() + ".getUnPostedDFDocument() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidDF = rs.getLong(1);

                Vector vErrUpdateStockByDispatchItem = updateStockByDispatchItem(oidPeriode, oidLocation, oidDF);

                // Set status document receive menjadi posted
                boolean isOK = false;
                if (!(vErrUpdateStockByDispatchItem != null && vErrUpdateStockByDispatchItem.size() > 0)) {
                    isOK = setPosted(oidDF, DOC_TYPE_DISPATCH);
                }
                
                if (!isOK) {
                    try {
                        MatDispatch objBillMain = PstMatDispatch.fetchExc(oidDF);
                        vResult.add(objBillMain);
                        System.out.println(">>> DF ERROR : "+objBillMain.getDispatchCode());
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                    //break;
                }
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("DF : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;

        /*Vector vResult = new Vector(1, 1);
        // posting DF document that have df item
        vResult = PostingDFToStock(dPostingDate, lLocationOid, lPeriodeOid, bPostedDateCheck);
        // posting DF document that haven't df item
        Vector vUnPostedDF = listDFDocWithoutItem(lPeriodeOid, dPostingDate, lLocationOid, bPostedDateCheck);
        if (vUnPostedDF != null && vUnPostedDF.size() > 0) {
            vResult.addAll(vUnPostedDF);
        }
        return vResult;*/
    }

    synchronized public Vector updateStockByDocDispatchItem(long oidPeriode, long oidLocation, long lDispacthOid) {
        return updateStockByDispatchItem(oidPeriode,oidLocation, lDispacthOid);
    }

    synchronized private Vector updateStockByDispatchItem(long oidPeriode, long oidLocation, long lDispacthOid) {
        DBResultSet dbrs = null;
        Vector vResult = new Vector(1, 1);

        // --- start get time duration of transaction document that will posting ---
        // get current period "start date" and "end date" combine to "shift"
        Date dStartDatePeriod = null;
        Date dEndDatePeriod = null;
        String sStartTime = "";
        String sEndTime = "";
        Vector vTimeDuration = getTimeDurationOfTransDocument(oidPeriode);
        if (vTimeDuration != null && vTimeDuration.size() > 3) {
            dStartDatePeriod = (Date) vTimeDuration.get(0);
            dEndDatePeriod = (Date) vTimeDuration.get(1);
            sStartTime = (String) vTimeDuration.get(2);
            sEndTime = (String) vTimeDuration.get(3);
        }
        // --- finish get time duration of transaction document that will posting ---


        try { 
            // Select all receive today with detail
            String sql = "SELECT DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID] +
                    ", DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_QTY] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ITEM_ID] +
                    ", DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_HPP] +
                    ", DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_UNIT_ID] +
                    " FROM " + PstMatDispatchItem.TBL_MAT_DISPATCH_ITEM + " DFI" +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " WHERE DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ID] +
                    " = " + lDispacthOid;

            //System.out.println(">>> " + new SessPosting().getClass().getName() + ".updateStockByDispatchItem() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 

            MatDispatch matDispatch = new MatDispatch();
	    MatReceive matReceive = new MatReceive();

             try {
                matDispatch = PstMatDispatch.fetchExc(lDispacthOid);
            } catch (Exception e) {
                System.out.println("Exc. when fetch Dispatch in updateStockBydispatchItem(#,#,#,#): "+e.toString());
            }
            
            long oid = 0;
           //kondisi if location_type !=2
          if(matDispatch.getLocationType()!= PstMatDispatch.FLD_TYPE_TRANSFER_UNIT){
            try{
                //matDispatch = PstMatDispatch.fetchExc(lDispacthOid);

                // proses pembuatan penerimaan
                // dari dispatch secara otomatis                
                matReceive.setReceiveDate(matDispatch.getDispatchDate());
                matReceive.setReceiveFrom(matDispatch.getLocationId());
                matReceive.setLocationId(matDispatch.getDispatchTo());
                matReceive.setLocationType(PstLocation.TYPE_LOCATION_STORE);
                matReceive.setReceiveStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
                matReceive.setReceiveSource(PstMatReceive.SOURCE_FROM_DISPATCH);
                matReceive.setDispatchMaterialId(matDispatch.getOID());
                matReceive.setRemark("Automatic Receive process from transfer number : " + matDispatch.getDispatchCode());
                int docType = -1;
                try { 
                    I_PstDocType i_pstDocType = (I_PstDocType) Class.forName(I_DocType.DOCTYPE_CLASSNAME).newInstance();
                    docType = i_pstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL, I_DocType.MAT_DOC_TYPE_LMRR);
                } catch (Exception e) {
                }
                matReceive.setRecCodeCnt(SessMatReceive.getIntCode(matReceive, matReceive.getReceiveDate(), 0, docType, 0, true));
                matReceive.setRecCode(SessMatReceive.getCodeReceive(matReceive));
		
		oid = PstMatReceive.insertExc(matReceive); 
            }catch(Exception e){}   
         }
            while (rs.next()) {
                boolean isOK = false;
                long oidMaterial = rs.getLong(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID]);
                double dfQty = rs.getDouble(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_QTY]);
                double cost = rs.getDouble(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_HPP]);
                double qtyPerBaseUnit = PstUnit.getQtyPerBaseUnit(rs.getLong(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_UNIT_ID]), rs.getLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID]));
                double dfQtyReal = dfQty * qtyPerBaseUnit;

                // Check if this item is allready exists in MaterialStock
                if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {
                    // Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, dfQtyReal, MODE_UPDATE, DOC_TYPE_DISPATCH, oidPeriode);
                } else {
                    //Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, dfQtyReal, MODE_INSERT, DOC_TYPE_DISPATCH, oidPeriode);
                }

                // ini di pakai untuk pengecekan barang di lokasi tujuan dispatch
               /* if (checkMaterialStock(oidMaterial, matDispatch.getDispatchTo(), oidPeriode) == true) {
                    // Update Qty only
                    isOK = updateMaterialStock(oidMaterial, matDispatch.getDispatchTo(), dfQty, 0 , MODE_UPDATE, DOC_TYPE_RECEIVE, oidPeriode);
                } else {
                    //Update Qty only
                    isOK = updateMaterialStock(oidMaterial, matDispatch.getDispatchTo(), dfQty, 0 , MODE_INSERT, DOC_TYPE_RECEIVE, oidPeriode);
                }*/

                /// insert item for terima barang dari barang dispatch
                 //kondisi if location_type !=2
                if(matDispatch.getLocationType()!= PstMatDispatch.FLD_TYPE_TRANSFER_UNIT){
                try{
                    MatReceiveItem matReceiveItem = new MatReceiveItem();
                    matReceiveItem.setUnitId(rs.getLong(3));
                    matReceiveItem.setQty(rs.getInt(2));
                    matReceiveItem.setResidueQty(rs.getInt(2));
                    matReceiveItem.setMaterialId(rs.getLong(1));
                    matReceiveItem.setReceiveMaterialId(oid);
                    matReceiveItem.setCost(cost);
                    matReceiveItem.setCurrBuyingPrice(cost);
                    matReceiveItem.setTotal(matReceiveItem.getQty() * matReceiveItem.getCost());

		    PstMatReceiveItem.insertExc(matReceiveItem);
                }catch(Exception e){}
             }

                if (!isOK) {
                    vResult.add(oidMaterial + " on " + lDispacthOid);
                }

                // Proses insert/update serial stock codenya
               // cekInsertUpdateStockCode(oidLocation, matDispatch.getDispatchTo(), oidMaterial, rs.getLong(5), DOC_TYPE_DISPATCH);
            }
	    //kondisi if location_type !=2
          if(matDispatch.getLocationType()!= PstMatDispatch.FLD_TYPE_TRANSFER_UNIT){

	    // update menjadi status final
	    matReceive.setOID(oid);
	    matReceive.setReceiveStatus(I_DocStatus.DOCUMENT_STATUS_FINAL);
	    PstMatReceive.updateExc(matReceive);
         }
	    
            rs.close();
        } catch (Exception exc) {
            System.out.println("DF : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }

        return vResult;
    }


    /**
     * @param postingDate
     * @param oidLocation
     * @param oidPeriode
     * @return
     * @update by Edhy
     *  - Inc Qty Out in MaterialStock
     *  - Dec Qty in MaterialStock
     *  - Set document status into posted
     */
    private Vector PostingDFToStock(Date postingDate, long oidLocation, long oidPeriode, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;

        try {
            // Select all receive today with detail
            String sql = "SELECT DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_MATERIAL_ID] +
                    ", DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID] +
                    ", DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_QTY] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_TO] +
                    ", DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ITEM_ID] +
                    " FROM " + PstMatDispatch.TBL_DISPATCH + " DF" +
                    " INNER JOIN " + PstMatDispatchItem.TBL_MAT_DISPATCH_ITEM + " DFI" +
                    " ON DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_MATERIAL_ID] +
                    " = DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ID] +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID];

            if (postedDateCheck) {
                sql = sql + " WHERE DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE] +
                        " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                        " AND DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                Date dStartDatePeriod = null;
                Date dEndDatePeriod = null;
                try {
                    Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                    dStartDatePeriod = objMaterialPeriode.getStartDate();
                    dEndDatePeriod = objMaterialPeriode.getEndDate();
                } catch (Exception e) {
                    System.out.println("Exc " + new SessClosing().getClass().getName() + ".PostingDFToStock() - fetch period : " + e.toString());
                }

                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = " DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE] +
                            " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:00:01") + "'" +
                            " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:59:59") + "'";
                }

                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sWhereClause = sWhereClause + " AND DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                } else {
                    sWhereClause = " DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND DF." + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }

                sql = sql + " WHERE " + sWhereClause;
            }

            // System.out.println(">>> " + new SessClosing().getClass().getName() + ".PostingDFToStock() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidDF = rs.getLong(1);
                long oidMaterial = rs.getLong(2);
                double dfQty = rs.getDouble(3);
                long oidNewLocation = rs.getLong(6);
                boolean isOK = false;

                // jumlah barang per dalam buying unit relatif terhadap sell/base unit
                double qtyPerSellingUnit = PstUnit.getQtyPerBaseUnit(rs.getLong(4), rs.getLong(5));

                // jumlah barang yg akan masuk stock
                dfQty = dfQty * qtyPerSellingUnit;

                // Check if this item is allready exists in MaterialStock
                if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {
                    // Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, dfQty, MODE_UPDATE, DOC_TYPE_DISPATCH, oidPeriode);
                } else {
                    //Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, dfQty, MODE_INSERT, DOC_TYPE_DISPATCH, oidPeriode);
                }

                // Set status document receive menjadi posted
                if (isOK == true) {
                    isOK = setPosted(oidDF, DOC_TYPE_DISPATCH);
                }

                if (!isOK) {
                    try {
                        BillMain objBillMain = PstBillMain.fetchExc(oidDF);
                        vResult.add(objBillMain);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                    break;
                }

                // Proses insert/update serial stock codenya
                cekInsertUpdateStockCode(oidLocation, oidNewLocation, oidMaterial, rs.getLong(7), DOC_TYPE_DISPATCH,0);

            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("DF : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;
    }


    /**
     * This method using to posting DF document without df item include during specified period
     * @param oidPeriode
     * @param postingDate
     * @param oidLocation
     * @param postedDateCheck
     * @return
     * @created by Edhy
     * algoritm :
     *  - list all df document that still draft
     *  - iterate process of set df document status to POSTED without care about stock
     */
    private Vector listDFDocWithoutItem(long oidPeriode, Date postingDate, long oidLocation, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);

        String sWhereClause = "";
        if (postedDateCheck) {
            sWhereClause = PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE] +
                    " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                    " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                    " AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                    " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                    " AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] +
                    " = " + oidLocation;
        } else {
            Date dStartDatePeriod = null;
            Date dEndDatePeriod = null;
            try {
                Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                dStartDatePeriod = objMaterialPeriode.getStartDate();
                dEndDatePeriod = objMaterialPeriode.getEndDate();
            } catch (Exception e) {
                System.out.println("Exc " + new SessClosing().getClass().getName() + ".listDFDocWithoutItem() - fetch period : " + e.toString());
            }

            if (dStartDatePeriod != null && dEndDatePeriod != null) {
                sWhereClause = PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE] +
                        " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:59:59") + "'";
            }

            if (sWhereClause != null && sWhereClause.length() > 0) {
                sWhereClause = sWhereClause + " AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                sWhereClause = PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            }
        }

        Vector vListUnPostedDFDoc = PstMatDispatch.list(0, 0, sWhereClause, "");
        if (vListUnPostedDFDoc != null && vListUnPostedDFDoc.size() > 0) {
            int unPostedDFDocCount = vListUnPostedDFDoc.size();
            for (int i = 0; i < unPostedDFDocCount; i++) {
                MatDispatch objMatDispatch = (MatDispatch) vListUnPostedDFDoc.get(i);
                vResult.add(objMatDispatch);
            }
        }

        return vResult;
    }
    // ------------------------------- POSTING DISPATCH FINISH ---------------------------




    // ------------------------------- POSTING COST START ---------------------------
    /**
     * This method use to posting dispatch document
     * @param dPostingDate
     * @param lLocationOid
     * @param lPeriodeOid
     * @param bPostedDateCheck
     * @return
     * @created by Edhy
     * algoritm :
     *  - posting all costing document during specified time interval (with df item)
     *  - if there are costing document cannot posting, do posting process for outstanding trans document (without df item)
     */
    private Vector getUnPostedCostDocument(Date postingDate, long oidLocation, long oidPeriode, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;

        // --- start get time duration of transaction document that will posting ---
        // get current period "start date" and "end date" combine to "shift"
        Date dStartDatePeriod = null;
        Date dEndDatePeriod = null;
        String sStartTime = "";
        String sEndTime = "";
        Vector vTimeDuration = getTimeDurationOfTransDocument(oidPeriode);
        if (vTimeDuration != null && vTimeDuration.size() > 3) {
            dStartDatePeriod = (Date) vTimeDuration.get(0);
            dEndDatePeriod = (Date) vTimeDuration.get(1);
            sStartTime = (String) vTimeDuration.get(2);
            sEndTime = (String) vTimeDuration.get(3);
        }
        // --- finish get time duration of transaction document that will posting ---

        try {
            // Select all receive today with detail
            String sql = "SELECT " + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_MATERIAL_ID] +
                    " FROM " + PstMatCosting.TBL_COSTING;

            if (postedDateCheck) {
                sql = sql + " WHERE " + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                        " AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                        " = " + oidLocation;
                /*" AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                " BETWEEN \"" + Formater.formatDate(postingDate, "yyyy-MM-dd") + " " + sStartTime + "\"" +
                " AND \"" + Formater.formatDate(postingDate, "yyyy-MM-dd") + " " + sEndTime + "\"";*/
            } else {
                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                    /*" AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                    " BETWEEN \"" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd") + " " + sStartTime + "\"" +
                    " AND \"" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd") + " " + sEndTime + "\"";*/
                } else {
                    sWhereClause = PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }

                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sql = sql + " WHERE " + sWhereClause;
                }
            }

            //System.out.println(">>> " + new SessPosting().getClass().getName() + ".getUnPostedDFDocument() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidDF = rs.getLong(1);

                Vector vErrUpdateStockByCostingItem = updateStockByCostingItem(oidPeriode, oidLocation, oidDF);

                // Set status document receive menjadi posted
                boolean isOK = false;
                if (!(vErrUpdateStockByCostingItem != null && vErrUpdateStockByCostingItem.size() > 0)) {
                    isOK = setPosted(oidDF, DOC_TYPE_COSTING);
                }

                if (!isOK) {
                    try {
                        MatCosting objBillMain = PstMatCosting.fetchExc(oidDF);
                        vResult.add(objBillMain);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                    break;
                }
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("DF : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;


        /*Vector vResult = new Vector(1, 1);
        // posting Costing document that have df item
        vResult = PostingCostToStock(dPostingDate, lLocationOid, lPeriodeOid, bPostedDateCheck);
        // posting Costing document that haven't df item
        Vector vUnPostedCosting = listCostDocWithoutItem(lPeriodeOid, dPostingDate, lLocationOid, bPostedDateCheck);
        if (vUnPostedCosting != null && vUnPostedCosting.size() > 0) {
            vResult.addAll(vUnPostedCosting);
        }
        return vResult;*/

    }


    synchronized private Vector updateStockByCostingItem(long oidPeriode, long oidLocation, long lCostingOid) {
        DBResultSet dbrs = null;
        Vector vResult = new Vector(1, 1);

        // --- start get time duration of transaction document that will posting ---
        // get current period "start date" and "end date" combine to "shift"
        Date dStartDatePeriod = null;
        Date dEndDatePeriod = null;
        String sStartTime = "";
        String sEndTime = "";
        Vector vTimeDuration = getTimeDurationOfTransDocument(oidPeriode);
        if (vTimeDuration != null && vTimeDuration.size() > 3) {
            dStartDatePeriod = (Date) vTimeDuration.get(0);
            dEndDatePeriod = (Date) vTimeDuration.get(1);
            sStartTime = (String) vTimeDuration.get(2);
            sEndTime = (String) vTimeDuration.get(3);
        }
        // --- finish get time duration of transaction document that will posting ---


        try {
            // Select all receive today with detail
            String sql = "SELECT DFI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MATERIAL_ID] +
                    ", DFI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_QTY] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", DFI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_COSTING_MATERIAL_ITEM_ID] +
                    ", DFI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_UNIT_ID] +
                    " FROM " + PstMatCostingItem.TBL_MAT_COSTING_ITEM + " DFI" +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON DFI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " WHERE DFI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_COSTING_MATERIAL_ID] +
                    " = " + lCostingOid;

            //System.out.println(">>> " + new SessPosting().getClass().getName() + ".updateStockByDispatchItem() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                long oidMaterial = rs.getLong(PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MATERIAL_ID]);
                double dfQty = rs.getDouble(PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_QTY]);
                boolean isOK = false;
                
                double qtyPerBaseUnit = PstUnit.getQtyPerBaseUnit(rs.getLong(PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_UNIT_ID]), rs.getLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID]));
                double dfQtyReal = dfQty * qtyPerBaseUnit; // jumlah barang yg akan masuk stock

                // Check if this item is allready exists in MaterialStock
                if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {
                    // Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, dfQtyReal, MODE_UPDATE, DOC_TYPE_COSTING, oidPeriode);
                } else {
                    //Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, dfQtyReal, MODE_INSERT, DOC_TYPE_COSTING, oidPeriode);
                }

                if (!isOK) {
                    vResult.add(oidMaterial + " on " + lCostingOid);
                }

                // Proses insert/update serial stock codenya
                cekInsertUpdateStockCode(oidLocation, oidLocation, oidMaterial, rs.getLong(5), DOC_TYPE_COSTING,0);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("DF : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }

        return vResult;
    }


    /**
     * @param postingDate
     * @param oidLocation
     * @param oidPeriode
     * @return
     * @update by Edhy
     *  - Inc Qty Out in MaterialStock
     *  - Dec Qty in MaterialStock
     *  - Set document status into posted
     */
    private Vector PostingCostToStock(Date postingDate, long oidLocation, long oidPeriode, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;
        try {
            // Select all receive today with detail
            String sql = "SELECT CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_MATERIAL_ID] +
                    ", CSI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MATERIAL_ID] +
                    ", CSI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_QTY] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_BUY_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    ", CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_TO] +
                    " FROM " + PstMatCosting.TBL_COSTING + " CST" +
                    " INNER JOIN " + PstMatCostingItem.TBL_MAT_COSTING_ITEM + " CSI" +
                    " ON CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_MATERIAL_ID] +
                    " = CSI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_COSTING_MATERIAL_ID] +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON CSI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID];

            if (postedDateCheck) {
                sql = sql + " WHERE CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                        " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                        " AND CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                Date dStartDatePeriod = null;
                Date dEndDatePeriod = null;
                try {
                    Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                    dStartDatePeriod = objMaterialPeriode.getStartDate();
                    dEndDatePeriod = objMaterialPeriode.getEndDate();
                } catch (Exception e) {
                    System.out.println("Exc " + new SessClosing().getClass().getName() + ".PostingCostToStock() - fetch period : " + e.toString());
                }
                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = " CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                            " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:00:01") + "'" +
                            " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:23:59") + "'";
                }

                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sWhereClause = sWhereClause + " AND CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                } else {
                    sWhereClause = " CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND CST." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }

                sql = sql + " WHERE " + sWhereClause;
            }

            //System.out.println(">>> " + new SessClosing().getClass().getName() + ".PostingCostToStock() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidCST = rs.getLong(1);
                long oidMaterial = rs.getLong(2);
                double dfQty = rs.getDouble(3);
                long oidNewLocation = rs.getLong(6);
                boolean isOK = false;

                // jumlah barang per dalam buying unit relatif terhadap sell/base unit
                double qtyPerSellingUnit = PstUnit.getQtyPerBaseUnit(rs.getLong(4), rs.getLong(5));

                // jumlah barang yg akan masuk stock
                dfQty = dfQty * qtyPerSellingUnit;

                // Check if this item is allready exists in MaterialStock
                if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {
                    // Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, dfQty, MODE_UPDATE, DOC_TYPE_DISPATCH, oidPeriode);
                } else {
                    //Update Qty only
                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, dfQty, MODE_INSERT, DOC_TYPE_DISPATCH, oidPeriode);
                }

                // Set status document receive menjadi posted
                if (isOK == true) {
                    isOK = setPosted(oidCST, DOC_TYPE_COSTING);
                }

                if (!isOK) {
                    try {
                        BillMain objBillMain = PstBillMain.fetchExc(oidCST);
                        vResult.add(objBillMain);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                    break;
                }
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("COST : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;
    }


    /**
     * This method using to posting Cost document without df item include during specified period
     * @param oidPeriode
     * @param postingDate
     * @param oidLocation
     * @param postedDateCheck
     * @return
     * @created by Edhy
     * algoritm :
     *  - list all df document that still draft
     *  - iterate process of set cost document status to POSTED without care about stock
     */
    private Vector listCostDocWithoutItem(long oidPeriode, Date postingDate, long oidLocation, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        String sWhereClause = "";
        if (postedDateCheck) {
            sWhereClause = PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                    " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                    " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                    " AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                    " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                    " AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                    " = " + oidLocation;
        } else {
            Date dStartDatePeriod = null;
            Date dEndDatePeriod = null;
            try {
                Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                dStartDatePeriod = objMaterialPeriode.getStartDate();
                dEndDatePeriod = objMaterialPeriode.getEndDate();
            } catch (Exception e) {
                System.out.println("Exc " + new SessClosing().getClass().getName() + ".listCostDocWithoutItem() - fetch period : " + e.toString());
            }

            if (dStartDatePeriod != null && dEndDatePeriod != null) {
                sWhereClause = PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                        " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:59:59") + "'";
            }

            if (sWhereClause != null && sWhereClause.length() > 0) {
                sWhereClause = sWhereClause + " AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                sWhereClause = PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            }
        }

        Vector vListUnPostedCostDoc = PstMatCosting.list(0, 0, sWhereClause, "");
        if (vListUnPostedCostDoc != null && vListUnPostedCostDoc.size() > 0) {
            int unPostedCostDocCount = vListUnPostedCostDoc.size();
            for (int i = 0; i < unPostedCostDocCount; i++) {
                MatCosting objMatCosting = (MatCosting) vListUnPostedCostDoc.get(i);
                vResult.add(objMatCosting);
            }
        }

        return vResult;
    }
    // ------------------------------- POSTING COSTING FINISH ---------------------------



    // ------------------------------- POSTING SALES START ---------------------------
    /**
     * This method use to posting sales document
     * @param dPostingDate
     * @param lLocationOid
     * @param lPeriodeOid
     * @param bPostedDateCheck
     * @return
     * @created by Edhy
     * algoritm :
     *  - posting all sales document during specified time interval (with sales item)
     *  - if there are sales document cannot posting, do posting process for outstanding trans document (without sales item)
     */
    private Vector getUnPostedSalesDocument(Date postingDate, long oidLocation, long oidPeriode, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;

        // --- start get time duration of transaction document that will posting ---
        // get current period "start date" and "end date" combine to "shift"
        Date dStartDatePeriod = null;
        Date dEndDatePeriod = null;
        String sStartTime = "";
        String sEndTime = "";
        Vector vTimeDuration = getTimeDurationOfTransDocument(oidPeriode);
        if (vTimeDuration != null && vTimeDuration.size() > 3) {
            dStartDatePeriod = (Date) vTimeDuration.get(0);
            dEndDatePeriod = (Date) vTimeDuration.get(1);
            sStartTime = (String) vTimeDuration.get(2);
            sEndTime = (String) vTimeDuration.get(3);
        }
        // --- finish get time duration of transaction document that will posting ---

        try {
            // Select all sale today with detail
            String sql = "SELECT " + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] +
                    " FROM " + PstBillMain.TBL_CASH_BILL_MAIN;

            if (postedDateCheck) { 
                sql = sql + " WHERE " + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                        " AND " + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] +
                        " = " + oidLocation +
                        " AND " + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                        " BETWEEN \"" + Formater.formatDate(postingDate, "yyyy-MM-dd") + " 00:00:00\"" +
                        " AND \"" + Formater.formatDate(postingDate, "yyyy-MM-dd") + " 23:59:59\"";
            } else { 
                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] +
                            " = " + oidLocation +
                            " AND " + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                            " BETWEEN \"" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd") + " 00:00:00\"" +
                            " AND \"" + Formater.formatDate(postingDate, "yyyy-MM-dd") + " 23:59:59\"";
                } else {
                    sWhereClause = PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_FINAL +
                            " AND " + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }

                sWhereClause = sWhereClause + " AND ("+PstBillMain.fieldNames[PstBillMain.FLD_TRANSACTION_STATUS]+"!="+PstBillMain.TRANS_STATUS_OPEN+
                        " OR "+PstBillMain.fieldNames[PstBillMain.FLD_TRANSCATION_TYPE]+"!="+PstBillMain.TRANS_TYPE_CASH+")";
                
                
                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sql = sql + " WHERE " + sWhereClause;
                }
            }

            System.out.println(">>> " + new SessPosting().getClass().getName() + ".getUnPostedSalesDocument() sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidSL = rs.getLong(1);
                
                Vector vErrUpdateStockBySaleItem = updateStockBySalesItem(postingDate, oidSL, oidLocation, oidPeriode);

                // Set status document receive menjadi posted
                boolean isOK = false;
                if (!(vErrUpdateStockBySaleItem != null && vErrUpdateStockBySaleItem.size() > 0)) {
                    isOK = setPosted(oidSL, DOC_TYPE_SALE_REGULAR);
                }


                if (!isOK) {
                    try {
                        BillMain objBillMain = PstBillMain.fetchExc(oidSL);
                        vResult.add(objBillMain);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                }
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("Exc when Process SALE : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;

        /*        Vector vResult = new Vector(1, 1);
        System.out.println("dPostingDate : " + dPostingDate);
        System.out.println("lLocationOid : " + lLocationOid);
        System.out.println("lPeriodeOid : " + lPeriodeOid);
        System.out.println("bPostedDateCheck : " + bPostedDateCheck);

        // posting sales document that have sales item
        Vector vResultTemp = PostingSaleToStock(dPostingDate, lLocationOid, lPeriodeOid, bPostedDateCheck);

        // posting sales document that haven't sales item
        Vector vUnPostedSales = PostingSaleWithoutItem(lPeriodeOid, dPostingDate, lLocationOid, bPostedDateCheck);
        if (vUnPostedSales != null && vUnPostedSales.size() > 0) {
            vResult.addAll(vUnPostedSales);
        }
        return vResult;*/
    }


    synchronized private Vector updateStockBySalesItem(Date postingDate, long lBillMainOid, long oidLocation, long oidPeriode) {
        DBResultSet dbrs = null;
        Vector vResult = new Vector(1, 1);

        try {
            // Select all receive today with detail
            String sql = "SELECT BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_ID] +
                    ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_QUANTITY] +
                    ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_TYPE] +
                    ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_DETAIL_ID] +
                    ", BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_UNIT_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " FROM " + PstBillDetail.TBL_CASH_BILL_DETAIL + " AS BD " +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " AS MAT " +
                    " ON BD." + PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " WHERE " + PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] +
                    " = " + lBillMainOid;
            
            //System.out.println(">>> "+ new SessPosting().getClass().getName()+".updateStockBySalesItem() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            BillMain billMain = new BillMain();
            try {
                billMain = PstBillMain.fetchExc(lBillMainOid);
            } catch (Exception e) {
                System.out.println("Exc. when fetch BillMain in updateStockBysalesItem(#,#,#,#): "+e.toString());
            }

            while (rs.next()) {
                long oidMaterial = rs.getLong(PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_ID]); //rs.getLong(1);
                double slQty = rs.getDouble(PstBillDetail.fieldNames[PstBillDetail.FLD_QUANTITY]);//rs.getDouble(2);
                int materialType = rs.getInt(PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_TYPE]);//rs.getInt(3); // kalau SQL Value = NULL, maka nilai materialType adalah 0 (Regular)
                double qtyPerBaseUnit = PstUnit.getQtyPerBaseUnit(rs.getLong(PstBillDetail.fieldNames[PstBillDetail.FLD_UNIT_ID]), rs.getLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID]));
                double sellQtyReal = slQty * qtyPerBaseUnit;
                //System.out.println(">>> slQty: "+slQty+"\n>>>sellQtyReal: "+sellQtyReal);
                
                Thread.sleep(50);
                boolean isOK = false;
                switch (materialType) {
                    case PstMaterial.MATERIAL_TYPE_REGULAR:
                        // Check if this item is allready exists in MaterialStock
                        if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {
                            // Update Qty only
                            if (sellQtyReal != 0) {
                                if (billMain.getDocType() == PstBillMain.TYPE_INVOICE)
                                    isOK = updateMaterialStock(oidMaterial, oidLocation, 0, sellQtyReal, MODE_UPDATE, DOC_TYPE_SALE_REGULAR, oidPeriode);
                                else
                                    isOK = updateMaterialStock(oidMaterial, oidLocation, sellQtyReal, 0, MODE_UPDATE, DOC_TYPE_RECEIVE, oidPeriode); // retur
                            }
                        } else {
                            // Insert Stock and its qty
                            if (billMain.getDocType() == PstBillMain.TYPE_INVOICE) {
                                //sellQtyReal = 0 - sellQtyReal; // karena sudah ada penjualan maka qty menjadi min.
                                isOK = updateMaterialStock(oidMaterial, oidLocation, 0, sellQtyReal, MODE_INSERT, DOC_TYPE_SALE_REGULAR, oidPeriode);
                            } else {
                                isOK = updateMaterialStock(oidMaterial, oidLocation, sellQtyReal, 0, MODE_INSERT, DOC_TYPE_RECEIVE, oidPeriode);
                            }
                        }
                        
                        if (!isOK) {
                            vResult.add(oidMaterial + " on " + lBillMainOid);
                        }
                        break;

                    case PstMaterial.MATERIAL_TYPE_COMPOSITE:
                        // Decrement Qty composernya
                        Vector listComposer = getMaterialComposer(oidMaterial);
                        for (int i = 0; i < listComposer.size(); i++) {
                            MaterialComposit matCom = (MaterialComposit) listComposer.get(i);
                            isOK = updateMaterialStock(matCom.getMaterialComposerId(), oidLocation, 0, (sellQtyReal * matCom.getQty()), MODE_UPDATE, DOC_TYPE_SALE_REGULAR, oidPeriode);
                            if (isOK == false) break;
                        }

                        // Create automatic transaction for each material composer
                        // Insert Bill Main
                        BillMain bm = new BillMain();
                        bm.setAppUserId(0);
                        bm.setBillDate(postingDate);
                        bm.setBillStatus(I_DocStatus.DOCUMENT_STATUS_POSTED);
                        bm.setInvoiceNo("AUTO-COMPOSIT");
                        bm.setLocationId(oidLocation);
                        long oidBillMain = PstBillMain.insertExc(bm);

                        // Insert Bill Detail
                        for (int j = 0; j < listComposer.size(); j++) {
                            Billdetail bd = new Billdetail();
                            MaterialComposit matCom = (MaterialComposit) listComposer.get(j);

                            // Fetch Material Info
                            Material mat = new Material();
                            try {
                                mat = PstMaterial.fetchExc(matCom.getMaterialComposerId());
                            } catch (Exception ex) {
                                System.out.println("Exc when fetch material composer : " + ex.toString());
                            }
                            bd.setBillMainId(oidBillMain);
                            bd.setMaterialId(matCom.getMaterialComposerId());
                            bd.setMaterialType(PstMaterial.MATERIAL_TYPE_REGULAR);
                            bd.setQty(matCom.getQty());
                            bd.setSku(mat.getSku());
                            bd.setItemName(mat.getName());
                            bd.setUnitId(mat.getDefaultStockUnitId());
                            long oidBD = PstBillDetail.insertExc(bd);
                        }
                        
                        // Update compositnya
                        if (isOK) {
                            isOK = updateMaterialStock(oidMaterial, oidLocation, 0, sellQtyReal, MODE_UPDATE, DOC_TYPE_SALE_COMPOSIT, oidPeriode);
                        }
                        
                        ///System.out.println("isOK COMPOSIT : " + isOK);
                        if (!isOK) {
                            vResult.add(oidMaterial + " on " + lBillMainOid);
                        }
                        break;
                }
                
                // update serial code stock
                cekInsertUpdateStockCode(0, oidLocation, oidMaterial, rs.getLong(4), DOC_TYPE_SALE_REGULAR,0);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("SALE : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }

        return vResult;
    }


    /**
     * This method using to posting sales document with sales item include during specified period
     * @param postingDate
     * @param oidLocation
     * @param oidPeriode
     * @return
     * @update by Edhy
     * algoritm :
     *  - Inc Qty Out in MaterialStock
     *  - Dec Qty in MaterialStock
     *  - Set document status into posted
     */
    private Vector PostingSaleToStock(Date postingDate, long oidLocation, long oidPeriode, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);
        DBResultSet dbrs = null;

        try {
            // Select all sale today with detail
            String sql = "SELECT CBM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] +
                    ", CBD." + PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_ID] +
                    ", CBD." + PstBillDetail.fieldNames[PstBillDetail.FLD_QUANTITY] +
                    ", CBD." + PstBillDetail.fieldNames[PstBillDetail.FLD_MATERIAL_TYPE] +
                    ", CBD." + PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_DETAIL_ID] +
                    " FROM " + PstBillMain.TBL_CASH_BILL_MAIN + " CBM" +
                    " INNER JOIN " + PstBillDetail.TBL_CASH_BILL_DETAIL + " CBD" +
                    " ON CBM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] +
                    " = CBD." + PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID];

            if (postedDateCheck) {
                sql = sql + " WHERE CBM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                        " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                        " AND CBM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND CBM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                Date dStartDatePeriod = null;
                Date dEndDatePeriod = null;
                try {
                    Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                    dStartDatePeriod = objMaterialPeriode.getStartDate();
                    dEndDatePeriod = objMaterialPeriode.getEndDate();
                } catch (Exception e) {
                    System.out.println("Exc " + new SessClosing().getClass().getName() + ".PostingSaleToStock() - fetch period : " + e.toString());
                }

                String sWhereClause = "";
                if (dStartDatePeriod != null && dEndDatePeriod != null) {
                    sWhereClause = " CBM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                            " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:00:01") + "'" +
                            " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:59:59") + "'";
                }

                if (sWhereClause != null && sWhereClause.length() > 0) {
                    sWhereClause = sWhereClause + " AND " + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND CBM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                } else {
                    sWhereClause = " CBM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                            " AND CBM." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] +
                            " = " + oidLocation;
                }

                sql = sql + " WHERE " + sWhereClause;
            }

            //System.out.println(">>> " + new SessClosing().getClass().getName() + ".PostingSaleToStock() sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                // Fetch all we needed
                long oidSL = rs.getLong(1);
                long oidMaterial = rs.getLong(2);
                double slQty = rs.getDouble(3);
                int materialType = rs.getInt(4); // kalau SQL Value = NULL, maka nilai materialType adalah 0 (Regular)

                boolean isOK = false;
                switch (materialType) {
                    case PstMaterial.MATERIAL_TYPE_REGULAR:
                        // Check if this item is allready exists in MaterialStock
                        //System.out.println("oidMaterial : " + oidMaterial);
                        //System.out.println("oidLocation : " + oidLocation);
                        //System.out.println("oidPeriode : " + oidPeriode);

                        if (checkMaterialStock(oidMaterial, oidLocation, oidPeriode) == true) {

                            //System.out.println("true slQty : " + slQty);
                            // Update Qty only
                            if (slQty > 0) {
                                isOK = updateMaterialStock(oidMaterial, oidLocation, 0, slQty, MODE_UPDATE, DOC_TYPE_SALE_REGULAR, oidPeriode);
                                //System.out.println("true isOK : " + isOK);
                            }
                        } else {
                            //System.out.println("false slQty : " + slQty);
                            // Insert Stock and its qty
                            isOK = updateMaterialStock(oidMaterial, oidLocation, 0, slQty, MODE_INSERT, DOC_TYPE_SALE_REGULAR, oidPeriode);
                            //System.out.println("false isOK : " + isOK);
                        }
                        break;

                    case PstMaterial.MATERIAL_TYPE_COMPOSITE:

                        //System.out.println("MATERIAL_TYPE_COMPOSITE oidMaterial : " + oidMaterial);
                        //System.out.println("MATERIAL_TYPE_COMPOSITE oidLocation : " + oidLocation);
                        //System.out.println("MATERIAL_TYPE_COMPOSITE oidPeriode : " + oidPeriode);

                        // Decrement Qty composernya
                        Vector listComposer = getMaterialComposer(oidMaterial);
                        for (int i = 0; i < listComposer.size(); i++) {
                            MaterialComposit matCom = (MaterialComposit) listComposer.get(i);
                            isOK = updateMaterialStock(matCom.getMaterialComposerId(), oidLocation, 0, (slQty * matCom.getQty()), MODE_UPDATE, DOC_TYPE_SALE_REGULAR, oidPeriode);
                            if (isOK == false) break;
                        }

                        // Create automatic transaction for each material composer
                        // Insert Bill Main
                        BillMain bm = new BillMain();
                        bm.setAppUserId(0);
                        bm.setBillDate(postingDate);
                        bm.setBillStatus(I_DocStatus.DOCUMENT_STATUS_POSTED);
                        bm.setInvoiceNo("AUTO-COMPOSIT");
                        bm.setLocationId(oidLocation);
                        long oidBillMain = PstBillMain.insertExc(bm);

                        // Insert Bill Detail
                        for (int j = 0; j < listComposer.size(); j++) {
                            Billdetail bd = new Billdetail();
                            MaterialComposit matCom = (MaterialComposit) listComposer.get(j);

                            // Fetch Material Info
                            Material mat = new Material();
                            try {
                                mat = PstMaterial.fetchExc(matCom.getMaterialComposerId());
                            } catch (Exception ex) {
                                System.out.println("Exc when fetch material composer : " + ex.toString());
                            }
                            bd.setBillMainId(oidBillMain);
                            bd.setMaterialId(matCom.getMaterialComposerId());
                            bd.setMaterialType(PstMaterial.MATERIAL_TYPE_REGULAR);
                            bd.setQty(matCom.getQty());
                            bd.setSku(mat.getSku());
                            bd.setItemName(mat.getName());
                            bd.setUnitId(mat.getDefaultStockUnitId());
                            long oidBD = PstBillDetail.insertExc(bd);
                        }

                        // Update compositnya
                        if (isOK == true) {
                            isOK = updateMaterialStock(oidMaterial, oidLocation, 0, slQty, MODE_UPDATE, DOC_TYPE_SALE_COMPOSIT, oidPeriode);
                        }
                        break;
                }

                // Set status document receive menjadi posted
                if (isOK == true) {
                    isOK = setPosted(oidSL, DOC_TYPE_SALE_REGULAR);
                }

                // update serial code stock
                cekInsertUpdateStockCode(0, oidLocation, oidMaterial, rs.getLong(5), DOC_TYPE_SALE_REGULAR,0);

                if (!isOK) {
                    try {
                        BillMain objBillMain = PstBillMain.fetchExc(oidSL);
                        vResult.add(objBillMain);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                    break;
                }
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("Exc when Process SALE : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vResult;
    }


    /**
     * This method using to posting sales document without sales item include during specified period
     * @param oidPeriode
     * @param postingDate
     * @param oidLocation
     * @param postedDateCheck
     * @return
     * @created by Edhy
     * algoritm :
     *  - list all sales document that still draft
     *  - iterate process of set sales document status to POSTED without care about stock
     */
    private Vector PostingSaleWithoutItem(long oidPeriode, Date postingDate, long oidLocation, boolean postedDateCheck) {
        Vector vResult = new Vector(1, 1);

        String sWhereClause = "";
        if (postedDateCheck) {
            sWhereClause = PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                    " BETWEEN '" + Formater.formatDate(postingDate, "yyyy-MM-dd 00:00:01") + "'" +
                    " AND '" + Formater.formatDate(postingDate, "yyyy-MM-dd 23:59:59") + "'" +
                    " AND " + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                    " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                    " AND " + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] +
                    " = " + oidLocation;
        } else {
            Date dStartDatePeriod = null;
            Date dEndDatePeriod = null;
            try {
                Periode objMaterialPeriode = PstPeriode.fetchExc(oidPeriode);
                dStartDatePeriod = objMaterialPeriode.getStartDate();
                dEndDatePeriod = objMaterialPeriode.getEndDate();
            } catch (Exception e) {
                System.out.println("Exc " + new SessClosing().getClass().getName() + ".PostingSaleWithoutItem() - fetch period : " + e.toString());
            }

            if (dStartDatePeriod != null && dEndDatePeriod != null) {
                sWhereClause = PstBillMain.fieldNames[PstBillMain.FLD_BILL_DATE] +
                        " BETWEEN '" + Formater.formatDate(dStartDatePeriod, "yyyy-MM-dd 00:00:01") + "'" +
                        " AND '" + Formater.formatDate(dEndDatePeriod, "yyyy-MM-dd 23:59:59") + "'";
            }

            if (sWhereClause != null && sWhereClause.length() > 0) {
                sWhereClause = sWhereClause + " AND " + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            } else {
                sWhereClause = PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                        " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                        " AND " + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] +
                        " = " + oidLocation;
            }
        }

        Vector vListUnPostedSalesDoc = PstBillMain.list(0, 0, sWhereClause, "");
        if (vListUnPostedSalesDoc != null && vListUnPostedSalesDoc.size() > 0) {
            int unPostedSalesDocCount = vListUnPostedSalesDoc.size();
            for (int i = 0; i < unPostedSalesDocCount; i++) {
                BillMain objBillMain = (BillMain) vListUnPostedSalesDoc.get(i);

                // check apakah ada cash bill detail
                // kalau tidak ada, update bill status menjadi posted tanpa mempengaruhi stock
                if (!salesItemExist(objBillMain.getOID())) {
                    try {
                        objBillMain.setBillStatus(I_DocStatus.DOCUMENT_STATUS_POSTED);
                        long lResult = PstBillMain.updateExc(objBillMain);
                    } catch (Exception e) {
                        vResult.add(objBillMain);
                        System.out.println(">>> Exc " + new SessClosing().getClass().getName() + ".PostingSaleWithoutItem() - update bill main status : " + e.toString());
                    }
                }
            }
        }

        return vResult;
    }


    /**
     * This method used to check if sales item for specified bill document already exist or not
     * @param lBillMainOid
     * @return <CODE>true</CODE>if sales item already exist, otherwise <CODE>false</CODE>
     * @created by Edhy
     */
    private boolean salesItemExist(long lBillMainOid) {
        boolean lResult = false;

        String sWhereClause = PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + " = " + lBillMainOid;
        Vector vListSalesItem = PstBillDetail.list(0, 0, sWhereClause, "");
        if (vListSalesItem != null && vListSalesItem.size() > 0) {
            lResult = true;
        }

        return lResult;
    }
    // ------------------------------- POSTING SALES FINISH ---------------------------






    /**
     * Periksa apakah material sudah ada di MaterialStock
     * @param oidMaterial
     * @param oidLocation
     * @param oidPeriode
     * @return
     */
    private static boolean checkMaterialStock(long oidMaterial, long oidLocation, long oidPeriode) {
        boolean hasil = false;
        DBResultSet dbrs = null;
        try {
            //Select all receive today with detail
            String sql = "SELECT * " +
                    " FROM " + PstMaterialStock.TBL_MATERIAL_STOCK +
                    " WHERE " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] +
                    " = " + oidMaterial +
                    " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] +
                    " = " + oidLocation +
                    " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] +
                    " = " + oidPeriode;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                hasil = true;
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("CekMatStock : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return hasil;
    }


    /**
     * untuk pencarian data qty stock di material,
     * lokasi dan sesuai dengan periode terpilih
     * @param oidMaterial
     * @param oidLocation
     * @param oidPeriode
     * @return
     */
    private static double checkStockMaterial(long oidMaterial, long oidLocation, long oidPeriode) {
        double qty = 0.00;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "+PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY]+
                    " FROM " + PstMaterialStock.TBL_MATERIAL_STOCK +
                    " WHERE " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] +
                    " = " + oidMaterial;
            if(oidLocation > 0) {
                sql += " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] +
                    " = " + oidLocation;
            }
            sql += " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] + " = " + oidPeriode;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                qty = rs.getDouble(PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY]);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("CekMatStock : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return qty;
    }


    /**
     *
     * @param oidDocItem
     * @param docType
     * @return
     */
    private static boolean cekInsertUpdateStockCode(long oidOldLocation, long oidNewLocation,
                                                    long oidMaterial, long oidDocItem, int docType, int recSouce) {
        DBResultSet dbrs = null;
        boolean hasil = false;
        try {
            String sql = "";
            switch (docType) {
                case DOC_TYPE_RECEIVE: // Receive
                    sql = "SELECT " +
                            PstReceiveStockCode.fieldNames[PstReceiveStockCode.FLD_RECEIVE_MATERIAL_CODE_ID] +
                            "," + PstReceiveStockCode.fieldNames[PstReceiveStockCode.FLD_RECEIVE_MATERIAL_ITEM_ID] +
                            "," + PstReceiveStockCode.fieldNames[PstReceiveStockCode.FLD_STOCK_CODE] +
                            " FROM " + PstReceiveStockCode.TBL_POS_RECEIVE_MATERIAL_CODE +
                            " WHERE " + PstReceiveStockCode.fieldNames[PstReceiveStockCode.FLD_RECEIVE_MATERIAL_ITEM_ID] + "=" + oidDocItem;
                    break;

                case DOC_TYPE_RETURN: //  return
                    sql = "SELECT " +
                            PstReturnStockCode.fieldNames[PstReturnStockCode.FLD_RETURN_MATERIAL_CODE_ID] +
                            "," + PstReturnStockCode.fieldNames[PstReturnStockCode.FLD_RETURN_MATERIAL_ITEM_ID] +
                            "," + PstReturnStockCode.fieldNames[PstReturnStockCode.FLD_STOCK_CODE] +
                            " FROM " + PstReturnStockCode.TBL_POS_RETURN_MATERIAL_CODE +
                            " WHERE " + PstReturnStockCode.fieldNames[PstReturnStockCode.FLD_RETURN_MATERIAL_ITEM_ID] + "=" + oidDocItem;
                    break;

                case DOC_TYPE_DISPATCH: // dispatch
                    sql = "SELECT " +
                            PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_CODE_ID] +
                            "," + PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_ITEM_ID] +
                            "," + PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_STOCK_CODE] +
                            " FROM " + PstDispatchStockCode.TBL_POS_DISPATCH_MATERIAL_CODE +
                            " WHERE " + PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_ITEM_ID] + "=" + oidDocItem;
                    break;

                case DOC_TYPE_COSTING: // costing
                    sql = "SELECT " +
                            PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_CODE_ID] +
                            "," + PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_ITEM_ID] +
                            "," + PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_STOCK_CODE] +
                            " FROM " + PstCostingStockCode.TBL_POS_COSTING_MATERIAL_CODE +
                            " WHERE " + PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_ITEM_ID] + "=" + oidDocItem;
                    break;

                case DOC_TYPE_SALE_REGULAR: // penjualan
                    sql = "SELECT " +
                            PstBillDetailCode.fieldNames[PstBillDetailCode.FLD_CASH_BILL_DETAIL_CODE_ID] +
                            "," + PstBillDetailCode.fieldNames[PstBillDetailCode.FLD_SALE_ITEM_ID] +
                            "," + PstBillDetailCode.fieldNames[PstBillDetailCode.FLD_STOCK_CODE] +
                            " FROM " + PstBillDetailCode.TBL_CASH_BILL_DETAIL_CODE +
                            " WHERE " + PstBillDetailCode.fieldNames[PstBillDetailCode.FLD_SALE_ITEM_ID] + "=" + oidDocItem;
                    break;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                switch (docType) {
                    case DOC_TYPE_RECEIVE: // Receive
                        switch(recSouce){
                            case PstMatReceive.SOURCE_FROM_SUPPLIER:
                                MaterialStockCode matStockCode = new MaterialStockCode();
                                matStockCode.setMaterialId(oidMaterial);
                                matStockCode.setLocationId(oidNewLocation);
                                matStockCode.setStockCode(rs.getString(3));
                                matStockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                                try {
                                    PstMaterialStockCode.insertExc(matStockCode);
                                } catch (Exception e) {
                                    System.out.println("error insert stock : " + e.toString());
                                }
                                break;
                            case PstMatReceive.SOURCE_FROM_SUPPLIER_PO:
                                matStockCode = new MaterialStockCode();
                                matStockCode.setMaterialId(oidMaterial);
                                matStockCode.setLocationId(oidNewLocation);
                                matStockCode.setStockCode(rs.getString(3));
                                matStockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                                try {
                                    PstMaterialStockCode.insertExc(matStockCode);
                                } catch (Exception e) {
                                    System.out.println("error insert stock : " + e.toString());
                                }
                                break;
                            case PstMatReceive.SOURCE_FROM_RETURN:
                                // update status serial code di lokasi return
                                String where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'" +
                                        " AND " + PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_LOCATION_ID] + "=" + oidOldLocation;
                                Vector vect = PstMaterialStockCode.list(where, "");
                                if (vect != null && vect.size() > 0) {
                                    MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                                    stockCode.setLocationId(oidNewLocation);
                                    stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                                    try {
                                        PstMaterialStockCode.updateExc(stockCode);
                                    } catch (Exception e) {
                                        System.out.println("error update stock : " + e.toString());
                                    }
                                }

                                // update status serial code di lokasi lama
                               /* where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'" +
                                        " AND " + PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_LOCATION_ID] + "=" + oidOldLocation;
                                vect = PstMaterialStockCode.list(where, "");
                                if (vect != null && vect.size() > 0) {
                                    MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                                    stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_RETURN);
                                    try {
                                        PstMaterialStockCode.updateExc(stockCode);
                                    } catch (Exception e) {
                                        System.out.println("error update stock : " + e.toString());
                                    }
                                }*/
                                break;
                            case PstMatReceive.SOURCE_FROM_DISPATCH:
                                // update status serial code di lokasi return
                                where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'" +
                                        " AND " + PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_LOCATION_ID] + "=" + oidOldLocation;
                                vect = PstMaterialStockCode.list(where, "");
                                if (vect != null && vect.size() > 0) {
                                    MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                                    stockCode.setLocationId(oidNewLocation);
                                    stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                                    try {
                                        PstMaterialStockCode.updateExc(stockCode);
                                    } catch (Exception e) {
                                        System.out.println("error update stock : " + e.toString());
                                    }
                                }else{
                                    matStockCode = new MaterialStockCode();
                                    matStockCode.setMaterialId(oidMaterial);
                                    matStockCode.setLocationId(oidNewLocation);
                                    matStockCode.setStockCode(rs.getString(3));
                                    matStockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                                    try {
                                        PstMaterialStockCode.insertExc(matStockCode);
                                    } catch (Exception e) {
                                        System.out.println("error insert stock : " + e.toString());
                                    }
                                }

                                // update status serial code di lokasi lama
                               /* where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'" +
                                        " AND " + PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_LOCATION_ID] + "=" + oidOldLocation;
                                vect = PstMaterialStockCode.list(where, "");
                                if (vect != null && vect.size() > 0) {
                                    MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                                    stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_DELIVERED);
                                    try {
                                        PstMaterialStockCode.updateExc(stockCode);
                                    } catch (Exception e) {
                                        System.out.println("error update stock : " + e.toString());
                                    }
                                }*/
                                break;
                        }
                        break;

                    case DOC_TYPE_RETURN: // retur
                        // update status serial code di lokasi return
                        String where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'" +
                                " AND " + PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_LOCATION_ID] + "=" + oidNewLocation;
                        Vector vect = PstMaterialStockCode.list(where, "");
                        if (vect != null && vect.size() > 0) {
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            if(oidOldLocation==0)
                                stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_RETURN);
                            else
                                stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_BAD);

                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }

                        // update status serial code di lokasi lama
                       /* where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'" +
                                " AND " + PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_LOCATION_ID] + "=" + oidOldLocation;
                        vect = PstMaterialStockCode.list(where, "");
                        if (vect != null && vect.size() > 0) {
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }*/
                        break;

                    case DOC_TYPE_DISPATCH: // dispatch
                        where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'"+
                                " AND " + PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_LOCATION_ID] + "=" + oidNewLocation;
                        vect = PstMaterialStockCode.list(where, "");
                        if (vect != null && vect.size() > 0) {
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_DELIVERED);
                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }

                        // this for receive outomatic int transfer
                      /*  if (vect != null && vect.size() > 0) {
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                            stockCode.setLocationId(oidNewLocation);
                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }*/

                        break;

                    case DOC_TYPE_COSTING: // dispatch
                        where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'"+
                                " AND " + PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_LOCATION_ID] + "=" + oidNewLocation;
                        vect = PstMaterialStockCode.list(where, "");
                        if (vect != null && vect.size() > 0) {
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_DELIVERED);
                            stockCode.setLocationId(oidNewLocation);
                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }
                        break;

                    case DOC_TYPE_SALE_REGULAR: // penjualan
                        //System.out.println("serial code jual:"+rs.getString(3));
                        where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'"+
                                " AND " + PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_LOCATION_ID] + "=" + oidNewLocation;
                        vect = PstMaterialStockCode.list(where, "");
                        if (vect != null && vect.size() > 0) {
                            //System.out.println("==>> update : PstMaterialStockCode.FLD_STOCK_STATUS_SOLED "+PstMaterialStockCode.FLD_STOCK_STATUS_SOLED);
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_SOLED);
                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }
                        break;
                }
            }
            hasil = true;
        } catch (Exception exc) {
            System.out.println("cekInsertUpdateStockCode " + exc);
        }
        return hasil;
    }


    /**
     *
     * @param oidOldLocation
     * @param oidNewLocation
     * @param oidMaterial
     * @param oidDocItem
     * @param docType
     * @return
     */
    public static boolean deleteUpdateStockCode(long oidNewLocation, long oidMaterial, long oidDocItem, int docType) {
        DBResultSet dbrs = null;
        boolean hasil = false;
        try {
            String sql = "";
            switch (docType) {
                case DOC_TYPE_RECEIVE: // Receive
                    sql = "SELECT " +
                            PstReceiveStockCode.fieldNames[PstReceiveStockCode.FLD_RECEIVE_MATERIAL_CODE_ID] +
                            "," + PstReceiveStockCode.fieldNames[PstReceiveStockCode.FLD_RECEIVE_MATERIAL_ITEM_ID] +
                            "," + PstReceiveStockCode.fieldNames[PstReceiveStockCode.FLD_STOCK_CODE] +
                            " FROM " + PstReceiveStockCode.TBL_POS_RECEIVE_MATERIAL_CODE +
                            " WHERE " + PstReceiveStockCode.fieldNames[PstReceiveStockCode.FLD_RECEIVE_MATERIAL_ITEM_ID] + "=" + oidDocItem;
                    break;

                case DOC_TYPE_RETURN: //  return
                    sql = "SELECT " +
                            PstReturnStockCode.fieldNames[PstReturnStockCode.FLD_RETURN_MATERIAL_CODE_ID] +
                            "," + PstReturnStockCode.fieldNames[PstReturnStockCode.FLD_RETURN_MATERIAL_ITEM_ID] +
                            "," + PstReturnStockCode.fieldNames[PstReturnStockCode.FLD_STOCK_CODE] +
                            " FROM " + PstReturnStockCode.TBL_POS_RETURN_MATERIAL_CODE +
                            " WHERE " + PstReturnStockCode.fieldNames[PstReturnStockCode.FLD_RETURN_MATERIAL_ITEM_ID] + "=" + oidDocItem;
                    break;

                case DOC_TYPE_DISPATCH: // dispatch
                    sql = "SELECT " +
                            PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_CODE_ID] +
                            "," + PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_ITEM_ID] +
                            "," + PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_STOCK_CODE] +
                            " FROM " + PstDispatchStockCode.TBL_POS_DISPATCH_MATERIAL_CODE +
                            " WHERE " + PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_ITEM_ID] + "=" + oidDocItem;
                    break;

                case DOC_TYPE_COSTING: // costing
                    sql = "SELECT " +
                            PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_CODE_ID] +
                            "," + PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_ITEM_ID] +
                            "," + PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_STOCK_CODE] +
                            " FROM " + PstCostingStockCode.TBL_POS_COSTING_MATERIAL_CODE +
                            " WHERE " + PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_ITEM_ID] + "=" + oidDocItem;
                    break;

                case DOC_TYPE_SALE_REGULAR: // penjualan
                    sql = "SELECT " +
                            PstBillDetailCode.fieldNames[PstBillDetailCode.FLD_CASH_BILL_DETAIL_CODE_ID] +
                            "," + PstBillDetailCode.fieldNames[PstBillDetailCode.FLD_SALE_ITEM_ID] +
                            "," + PstBillDetailCode.fieldNames[PstBillDetailCode.FLD_STOCK_CODE] +
                            " FROM " + PstBillDetailCode.TBL_CASH_BILL_DETAIL_CODE +
                            " WHERE " + PstBillDetailCode.fieldNames[PstBillDetailCode.FLD_SALE_ITEM_ID] + "=" + oidDocItem;
                    break;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                switch (docType) {
                    case DOC_TYPE_RECEIVE: // Receive
                        try {
                            PstReceiveStockCode.deleteExc(rs.getLong(0));
                        } catch (Exception e) {
                            System.out.println("error delete receive stock code : " + e.toString());
                        }
                        break;

                    case DOC_TYPE_RETURN: // retur
                        String where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'";
                        Vector vect = PstMaterialStockCode.list(where, "");
                        if (vect != null && vect.size() > 0) {
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                                PstReturnStockCode.deleteExc(rs.getLong(0));
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }
                        break;

                    case DOC_TYPE_DISPATCH: // dispatch
                        where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'";
                        vect = PstMaterialStockCode.list(where, "");
                        if (vect != null && vect.size() > 0) {
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                                PstDispatchStockCode.deleteExc(rs.getLong(0));
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }
                        break;

                    case DOC_TYPE_COSTING: // dispatch
                        where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'";
                        vect = PstMaterialStockCode.list(where, "");
                        if (vect != null && vect.size() > 0) {
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                                PstCostingStockCode.deleteExc(rs.getLong(0));
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }
                        break;

                    case DOC_TYPE_SALE_REGULAR: // penjualan
                        where = PstMaterialStockCode.fieldNames[PstMaterialStockCode.FLD_STOCK_CODE] + "='" + rs.getString(3) + "'";
                        vect = PstMaterialStockCode.list(where, "");
                        if (vect != null && vect.size() > 0) {
                            MaterialStockCode stockCode = (MaterialStockCode) vect.get(0);
                            stockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                            try {
                                PstMaterialStockCode.updateExc(stockCode);
                                PstBillDetailCode.deleteExc(rs.getLong(0));
                            } catch (Exception e) {
                                System.out.println("error update stock : " + e.toString());
                            }
                        }
                        break;
                }
            }
            hasil = true;
        } catch (Exception exc) {
            System.out.println("cekInsertUpdateStockCode " + exc);
        }
        return hasil;
    }

    /**
     *
     * @param oidMaterial
     * @param oidLocation
     * @param oidPeriode
     * @return
     */
    private static MaterialStock getMaterialStock(long oidMaterial, long oidLocation, long oidPeriode) {
        MaterialStock materialStock = new MaterialStock();
        DBResultSet dbrs = null;
        try {
            //Select all receive today with detail
            String sql = "SELECT * " +
                    " FROM " + PstMaterialStock.TBL_MATERIAL_STOCK +
                    " WHERE " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] +
                    " = " + oidMaterial +
                    " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] +
                    " = " + oidLocation +
                    " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] +
                    " = " + oidPeriode;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PstMaterialStock.resultToObject(rs, materialStock);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("CekMatStock : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return materialStock;
    }

    public static boolean setDocumentByPosted(long oidDocument, int docType) {
        return setPosted(oidDocument,docType);
    }
    /**
     * Set status semua document yg sudah diposting menjadi posted
     * @param oidDocument
     * @param docType
     * @return
     * @update by Edhy
     */
    private static boolean setPosted(long oidDocument, int docType) {
        boolean hasil = false;
        try {
            String sql = "";
            switch (docType) {
                case DOC_TYPE_RECEIVE:// Receive
                    sql = "UPDATE " + PstMatReceive.TBL_MAT_RECEIVE +
                            " SET " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_CLOSED +
                            " WHERE " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] +
                            " = " + oidDocument;
                    break;

                case DOC_TYPE_RETURN:// Return
                    sql = "UPDATE " + PstMatReturn.TBL_MAT_RETURN +
                            " SET " + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_CLOSED +
                            " WHERE " + PstMatReturn.fieldNames[PstMatReturn.FLD_RETURN_MATERIAL_ID] +
                            " = " + oidDocument;
                    break;

                case DOC_TYPE_DISPATCH://Dispatch
                    sql = "UPDATE " + PstMatDispatch.TBL_DISPATCH +
                            " SET " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_CLOSED +
                            " WHERE " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_MATERIAL_ID] +
                            " = " + oidDocument;
                    break;

                case DOC_TYPE_SALE_REGULAR://Sale
                    sql = "UPDATE " + PstBillMain.TBL_CASH_BILL_MAIN +
                            " SET " + PstBillMain.fieldNames[PstBillMain.FLD_BILL_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_CLOSED +
                            " WHERE " + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] +
                            " = " + oidDocument;
                    break;

                case DOC_TYPE_COSTING:// costing
                    sql = "UPDATE " + PstMatCosting.TBL_COSTING +
                            " SET " + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_CLOSED +
                            " WHERE " + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_MATERIAL_ID] +
                            " = " + oidDocument;
                    break;
                    
                case DOC_TYPE_FORWARDER://Forwarder
                    sql = "UPDATE " + PstForwarderInfo.TBL_FORWARDER_INFO +
                            " SET " + PstForwarderInfo.fieldNames[PstForwarderInfo.FLD_STATUS] +
                            " = " + I_DocStatus.DOCUMENT_STATUS_CLOSED +
                            " WHERE " + PstForwarderInfo.fieldNames[PstForwarderInfo.FLD_FORWARDER_ID] +
                            " = " + oidDocument;
                    break;
                    
            }
            System.out.println("set posted: "+sql);
            int a = DBHandler.execUpdate(sql);
            hasil = true;
        } catch (Exception exc) {
            System.out.println("POST " + exc);
        }
        return hasil;
    }


    /**
     * Update master cost di material jika receive dari supplier
     * @param oidMaterial
     * @param currencyId
     * @param newCost
     * @return
     */
    private static boolean updateCostMaster(long oidMaterial, long currencyId, double newCost) {
        boolean hasil = false;
        try {
            // Select all receive today with detail
            String sql = "UPDATE " + PstMaterial.TBL_MATERIAL +
                    " SET " + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST] +
                    " = " + newCost;
                    if(currencyId!=0){
                        sql = sql + ", " + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST_CURRENCY_ID] +
                        " = " + currencyId;
                    }
                    sql = sql + " WHERE " + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = " + oidMaterial;
            //System.out.println("updateCostMaster >>> "+sql);
            int a = DBHandler.execUpdate(sql);
            hasil = true;
        } catch (Exception exc) {
            System.out.println("eRR >>= UpdCost : " + exc);
        }
        return hasil;
    }


    /**
     * ini gunanya untuk mengupdate harga
     * barang supplier terakhir
     * @param oidSupplier
     * @param oidMaterial
     * @param currencyId
     * @param newCost
     * @return
     */
    private static boolean updateCostSupplierPrice(long oidSupplier, long oidMaterial, long currencyId, double newCost) {
        boolean hasil = false;
        try {               
            String sql = "UPDATE " + PstMatVendorPrice.TBL_MATERIAL_VENDOR_PRICE +
                    " SET " + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_CURR_BUYING_PRICE] + " = " + newCost;
                    if(currencyId!=0){
                        sql = sql + ", " + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_PRICE_CURRENCY] + " = " + currencyId;
                    }
                    sql = sql + ", " + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_ORG_BUYING_PRICE] + " = " + newCost +
                    " WHERE " + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_MATERIAL_ID] + " = " + oidMaterial + 
                    " AND " + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_VENDOR_ID] + " = " + oidSupplier;
            //System.out.println("==>>> Update Cost Supplier Success");
            int a = DBHandler.execUpdate(sql);
            hasil = true;
        } catch (Exception exc) {
            System.out.println("Update cost material price: " + exc);
        }
        return hasil;
    }

    /**
     * Update master currbuyprice + ppn di material jika receive dari supplier
     * @param oidMaterial
     * @param currencyId
     * @param newCost
     * @return
     */
    private static boolean updateCurrBuyPriceMaster(long oidMaterial, long currencyId, double newCost) {
        boolean hasil = false;
        try {
            // Select all receive today with detail
            String sql = "UPDATE " + PstMaterial.TBL_MATERIAL +
                    " SET " + PstMaterial.fieldNames[PstMaterial.FLD_CURR_BUY_PRICE] +
                    " = " + newCost;
                    if(currencyId!=0){
                        sql = sql + ", " + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST_CURRENCY_ID] +
                        " = " + currencyId;
                    }
                    sql = sql + " WHERE " + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = " + oidMaterial;
            //System.out.println("updateCostMaster >>> "+sql);
            int a = DBHandler.execUpdate(sql);
            hasil = true;
        } catch (Exception exc) {
            System.out.println("eRR >>= UpdCost : " + exc);
        }
        return hasil;
    }


    /**
     * update hpp satu barang
     * yang proses ini di jalankan secara otomatis sewaktu posting
     * pada document penerimaan barang
     * @param oidMaterial
     * @param currencyId
     * @param newCost
     * @return
     * @created by gadnyana
     */
    private static boolean updateAveragePrice(long oidMaterial, long currencyId, double newAverage) {
        boolean hasil = false;
        try {
            String sql = "UPDATE " + PstMaterial.TBL_MATERIAL +
                    " SET " + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] + " = " + newAverage;
                    if(currencyId!=0){
                        sql = sql + ", " + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST_CURRENCY_ID] +
                        " = " + currencyId;
                    }
                    sql = sql + " WHERE " + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = " + oidMaterial;
            // System.out.println(" sql >> " + sql);
            int a = DBHandler.execUpdate(sql);
            hasil = true;
        } catch (Exception exc) {
            System.out.println(" XXXXX updateAveragePrice : " + exc);
        }
        return hasil;
    }


    /**
     * Update master cost di material jika receive dari supplier
     * @param oidMaterial
     * @param oidLocation
     * @param QtyIn
     * @param QtyOut
     * @param mode
     * @param docType
     * @param oidPeriode
     * @return
     * @update by Edhy
     */
    synchronized private static boolean updateMaterialStock(long oidMaterial, long oidLocation, double QtyIn, double QtyOut, int mode, int docType, long oidPeriode) {
        boolean hasil = false;
        try {
            String sql = "";
            switch (mode) {
                case MODE_UPDATE:
                    MaterialStock materialStock = new MaterialStock();
                    materialStock = getMaterialStock(oidMaterial, oidLocation, oidPeriode);
                    switch (docType) {
                        case DOC_TYPE_RECEIVE:
                            sql = "UPDATE " + PstMaterialStock.TBL_MATERIAL_STOCK +
                                    " SET " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY_IN] +
                                    " = " + (QtyIn + materialStock.getQtyIn()) +
                                    ", " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] +
                                    " = " + (QtyIn + materialStock.getQty());
                            break;

                        case DOC_TYPE_RETURN:
                            sql = "UPDATE " + PstMaterialStock.TBL_MATERIAL_STOCK +
                                    " SET " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY_OUT] +
                                    " = " + (materialStock.getQtyOut() + QtyOut) +
                                    ", " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] +
                                    " = " + (materialStock.getQty() - QtyOut);
                            break;

                        case DOC_TYPE_DISPATCH:
                            sql = "UPDATE " + PstMaterialStock.TBL_MATERIAL_STOCK +
                                    " SET " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY_OUT] +
                                    " = " + (materialStock.getQtyOut() + QtyOut) +
                                    ", " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] +
                                    " = " + (materialStock.getQty() - QtyOut);
                            break;

                        case DOC_TYPE_COSTING:
                            sql = "UPDATE " + PstMaterialStock.TBL_MATERIAL_STOCK +
                                    " SET " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY_OUT] +
                                    " = " + (materialStock.getQtyOut() + QtyOut) +
                                    ", " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] +
                                    " = " + (materialStock.getQty() - QtyOut);
                            break;

                        case DOC_TYPE_SALE_REGULAR:
                            sql = "UPDATE " + PstMaterialStock.TBL_MATERIAL_STOCK +
                                    " SET " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY_OUT] +
                                    " = " + (materialStock.getQtyOut() + QtyOut) +
                                    ", " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] +
                                    " = " + (materialStock.getQty() - QtyOut);
                            break;

                        case DOC_TYPE_SALE_COMPOSIT:
                            sql = "UPDATE " + PstMaterialStock.TBL_MATERIAL_STOCK +
                                    " SET " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY_OUT] +
                                    " = " + (materialStock.getQtyOut() + QtyOut) +
                                    ", " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY_IN] +
                                    " = " + (materialStock.getQtyIn() + QtyIn);
                            break;
                    }

                    sql = sql + " WHERE " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] +
                            " = " + oidMaterial +
                            " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] +
                            " = " + oidLocation +
                            " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] +
                            " = " + oidPeriode;

                    
                    // for update stock get previous stock 
                    balanceStock(oidMaterial,oidLocation,oidPeriode);

                    int iUpdated = 1; // DBHandler.execUpdate(sql);
                    if (iUpdated > 0) {
                        hasil = true;
                    }
                    break;


                case MODE_INSERT:
                    MaterialStock matStock = new MaterialStock();
                    long oid = 0;
                    switch (docType) {
                        case DOC_TYPE_RECEIVE:
                            matStock.setPeriodeId(oidPeriode);
                            matStock.setMaterialUnitId(oidMaterial);
                            matStock.setLocationId(oidLocation);
                            matStock.setQtyIn(QtyIn);
                            matStock.setQty(QtyIn);
                            oid = PstMaterialStock.insertExc(matStock);
                            if (oid != 0) {
                                hasil = true;
                            }
                            break;

                        case DOC_TYPE_SALE_REGULAR:
                            matStock.setPeriodeId(oidPeriode);
                            matStock.setMaterialUnitId(oidMaterial);
                            matStock.setLocationId(oidLocation);
                            matStock.setQtyOut(QtyOut);
                            matStock.setQty(0 - QtyOut);
                            oid = PstMaterialStock.insertExc(matStock);
                            if (oid != 0) {
                                hasil = true;
                            }
                            break;

                       case DOC_TYPE_DISPATCH:
                            matStock.setPeriodeId(oidPeriode);
                            matStock.setMaterialUnitId(oidMaterial);
                            matStock.setLocationId(oidLocation);
                            matStock.setQtyOut(QtyOut);
                            matStock.setQty(0 - QtyOut);
                            oid = PstMaterialStock.insertExc(matStock);
                            if (oid != 0) {
                                hasil = true;
                            }
                            break;

                       case DOC_TYPE_RETURN:
                            matStock.setPeriodeId(oidPeriode);
                            matStock.setMaterialUnitId(oidMaterial);
                            matStock.setLocationId(oidLocation);
                            matStock.setQtyOut(QtyOut);
                            matStock.setQty(0 - QtyOut);
                            oid = PstMaterialStock.insertExc(matStock);
                            if (oid != 0) {
                                hasil = true;
                            }
                            break;

                      case DOC_TYPE_COSTING:
                            matStock.setPeriodeId(oidPeriode);
                            matStock.setMaterialUnitId(oidMaterial);
                            matStock.setLocationId(oidLocation);
                            matStock.setQtyOut(QtyOut);
                            matStock.setQty(0 - QtyOut);
                            oid = PstMaterialStock.insertExc(matStock);
                            if (oid != 0) {
                                hasil = true;
                            }
                            break;

                      case DOC_TYPE_SALE_COMPOSIT:
                            matStock.setPeriodeId(oidPeriode);
                            matStock.setMaterialUnitId(oidMaterial);
                            matStock.setLocationId(oidLocation);
                            matStock.setQtyOut(QtyOut);
                            matStock.setQty(0 - QtyOut);
                            oid = PstMaterialStock.insertExc(matStock);
                            if (oid != 0) {
                                hasil = true;
                            }
                            break;



                            /*default :
                                matStock.setPeriodeId(oidPeriode);
                                matStock.setMaterialUnitId(oidMaterial);
                                matStock.setLocationId(oidLocation);
                                matStock.setQtyOut(QtyOut);
                                matStock.setQty(0 - QtyOut);
                                oid = PstMaterialStock.insertExc(matStock);
                                if (oid != 0) {
                                    hasil = true;
                                }
                                break;*/
                    }
            }
        } catch (Exception exc) { 
            System.out.println("UpdMatStock : " + exc);
            PstDocLogger.insertDataBo_toDocLogger("updateMaterialStock - SessPosting : ", docType, new Date(), exc.toString());

        }
        return hasil;
    }


    /**
     *
     * @param oidMaterial
     * @param oidLocation
     * @param QtyIn
     * @param QtyOut
     * @param mode
     * @param oidPeriode
     * @return
     */
    synchronized private static boolean updateMaterialStock(long oidMaterial, long oidLocation, double QtyIn, double QtyOut, int mode, long oidPeriode) {
        boolean hasil = false;
        try {
            String sql = "";
            switch (mode) {
                case MODE_UPDATE: // Update Only
                    // System.out.println("---MODE UPDATE---");
                    sql = "UPDATE " + PstMaterialStock.TBL_MATERIAL_STOCK +
                            " SET " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY_IN] +
                            " = " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY_IN] +
                            " + " + QtyIn +
                            ", " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] +
                            " = " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] +
                            " + " + QtyOut;

                    sql += " WHERE " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] +
                            " = " + oidMaterial +
                            " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] +
                            " = " + oidLocation +
                            " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] +
                            " = " + oidPeriode;
                    int a = DBHandler.execUpdate(sql);
                    hasil = true;
                    break;

                case MODE_INSERT: // Insert Only and the docType can only be Receive
                    // System.out.println("---MODE INSERT---");
                    MaterialStock matStock = new MaterialStock();
                    long oid = 0;
                    matStock.setPeriodeId(oidPeriode);
                    matStock.setMaterialUnitId(oidMaterial);
                    matStock.setLocationId(oidLocation);
                    matStock.setQtyIn(QtyOut); // );QtyOut(
                    matStock.setQty(QtyOut);
                    oid = PstMaterialStock.insertExc(matStock);
                    if (oid != 0) hasil = true;
            }
        } catch (Exception exc) {
            System.out.println("UpdMatStock : " + exc);
        }
        return hasil;
    }
    
    /**
     * Get Current Stock Periode (There can be only one with status open !!!)
     * @param oidMaterial
     * @return
     * @update by Edhy
     */
    private static Vector getMaterialComposer(long oidMaterial) {
        Vector hasil = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT *" +
                    " FROM " + PstMaterialComposit.TBL_MATERIAL_COMPOSIT +
                    " WHERE " + PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_ID] +
                    " = " + oidMaterial;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                MaterialComposit objMaterialComposit = new MaterialComposit();

                objMaterialComposit.setOID(rs.getLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSIT_ID]));
                objMaterialComposit.setMaterialId(rs.getLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_ID]));
                objMaterialComposit.setMaterialComposerId(rs.getLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSER_ID]));
                objMaterialComposit.setUnitId(rs.getLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_UNIT_ID]));
                objMaterialComposit.setQty(rs.getDouble(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_QTY]));

                hasil.add(objMaterialComposit);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("GetMaterialComposer : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return hasil;
    }
    
    private static MaterialStock getProductOidStock(long oidMaterial, long oidLocation, long oidPeriode) {
        MaterialStock materialStock = new MaterialStock();
        DBResultSet dbrs = null;
        try {
            //Select all receive today with detail
            String sql = "SELECT * " +
                    " FROM " + PstMaterialStock.TBL_MATERIAL_STOCK +
                    " WHERE " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] +
                    " = " + oidMaterial +
                    " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] +
                    " = " + oidLocation +
                    " AND " + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] +
                    " = " + oidPeriode;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                PstMaterialStock.resultToObject(rs, materialStock);
            //oidstock= rs.getLong(PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_STOCK_ID]);
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("CekMatStock : " + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return materialStock;
    }
    
    
    public static int balanceStock(long materialOid, long locationOid, long periodeOid) {
        try {
	    Date dtstart = new Date();
            Date dtend = new Date();

	    Periode periode = PstPeriode.getPeriodeRunning();
	    if(periode.getStartDate().after(new Date())){
		dtstart = periode.getEndDate();
		dtend = periode.getEndDate();
	    }
            dtstart.setDate(dtend.getDate() - 1);

            SrcStockCard srcStockCard = new SrcStockCard();
            srcStockCard.setStardDate(dtstart);
            srcStockCard.setEndDate(dtend); 
            srcStockCard.setMaterialId(materialOid);
            srcStockCard.setLocationId(locationOid);
            Vector list = SessStockCard.createHistoryStockCard(srcStockCard);
            double qtyReal = prosesGetPrivousDataStockCard(list);
            MaterialStock matStock = getProductOidStock(materialOid, locationOid, periodeOid);
            try {
                if (matStock.getOID() != 0) { 
                    matStock.setQty(qtyReal);
                    PstMaterialStock.updateExc(matStock);
                    System.out.println("=>> Suksess update stock : " + qtyReal);

                // this for delete serial code

                } else {
                    System.out.println("=>> belum basuk stock mt oid : " + matStock.getMaterialUnitId());
                }
            } catch (Exception e) {
                System.out.println("=>> Err upda material . : mt oid : " + matStock.getMaterialUnitId() + " loc :" + locationOid);
            }

        } catch (Exception ee) {
        }
        return 1; 
    }

    // this for balance stock
    public static double prosesGetPrivousDataStockCard(Vector objectClassx) {
        double qtyawal = 0;
        StockCardReport stockCrp = (StockCardReport) objectClassx.get(0);
        Vector objectClass = (Vector) objectClassx.get(1);
        qtyawal = stockCrp.getQty();
        int initloop = objectClass.size();
	
	System.out.println("qtyawal : "+qtyawal);
	
        try {
            for (int i = 0; i < initloop; i++) {
                StockCardReport stockCardReport = (StockCardReport) objectClass.get(i);
		
		System.out.println("stockCardReport : "+stockCardReport.getQty()+" - "+stockCardReport.getKeterangan());
                switch (stockCardReport.getDocType()) {
                    case I_DocType.MAT_DOC_TYPE_LMRR:
                        qtyawal = qtyawal + stockCardReport.getQty();
                        break;
                    case I_DocType.MAT_DOC_TYPE_ROMR:
                        qtyawal = qtyawal - stockCardReport.getQty();
                        break;
                    case I_DocType.MAT_DOC_TYPE_DF:
                        qtyawal = qtyawal - stockCardReport.getQty();
                        break;
                    case I_DocType.MAT_DOC_TYPE_OPN:
                        qtyawal = stockCardReport.getQty();
                        break;
                    case I_DocType.MAT_DOC_TYPE_SALE:
                        switch (stockCardReport.getTransaction_type()) {
                            case PstBillMain.TYPE_INVOICE:
                                qtyawal = qtyawal - stockCardReport.getQty();
                                break;
                            case PstBillMain.TYPE_RETUR:
                                qtyawal = qtyawal + stockCardReport.getQty();
                                break;
                        }
                        break;
                }
                System.out.println("==>>>>> Qty awal : " + qtyawal);
            }
        } catch (Exception e) {
            System.out.println("prosesGetPrivousDataStockCard : " + e.toString());
        }
        return qtyawal;
    }
    

}
