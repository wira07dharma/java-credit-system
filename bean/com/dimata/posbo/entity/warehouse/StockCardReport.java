/**
 * Created by IntelliJ IDEA.
 * User: gadnyana
 * Date: Mar 3, 2005
 * Time: 11:34:37 AM
 * To change this template use Options | File Templates.
 */
package com.dimata.posbo.entity.warehouse;

import com.dimata.pos.entity.billing.PstBillMain;

import java.util.Date;

public class StockCardReport {

    private Date date = null;
    private int docType = 0;
    private String keterangan = "";
    private String docCode = "";
    private double qty = 0;

    public int getTransaction_type() {
        return transaction_type;
    }

    public void setTransaction_type(int transaction_type) {
        this.transaction_type = transaction_type;
    }

    // ini khusus di gunakan bill main
    private int transaction_type = PstBillMain.TYPE_INVOICE;


    public String getDocCode() {
        return docCode;
    }

    public void setDocCode(String docCode) {
        this.docCode = docCode;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getDocType() {
        return docType;
    }

    public void setDocType(int docType) {
        this.docType = docType;
    }

    public String getKeterangan() {
        return keterangan;
    }

    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

}
