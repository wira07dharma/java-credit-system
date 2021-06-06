/*
 * I_DocStatus.java
 *
 * Created on November 12, 2007, 2:49 PM
 */

package com.dimata.interfaces.docstatus;

/**
 *
 * @author  dwi
 */
public interface I_DocStatus {
    
    public static final int STS_DRAFT = 0;
    public static final int STS_FINAL = 1;
    public static final int STS_POSTED = 2;
    
    public static String[] arrStatusNames = {
        "DRAFT","FINAL","POSTED"
    };
    
    
    public static final int DOCUMENT_STATUS_DRAFT 			= 0;
    public static final int DOCUMENT_STATUS_TO_BE_APPROVED  = 1;
    public static final int DOCUMENT_STATUS_FINAL 			= 2;
    public static final int DOCUMENT_STATUS_REVISED 		= 3;
    public static final int DOCUMENT_STATUS_PROCEED			= 4;
    public static final int DOCUMENT_STATUS_CLOSED 			= 5;
    public static final int DOCUMENT_STATUS_CANCELLED 		= 6;
    public static final int DOCUMENT_STATUS_POSTED	 		= 7;
    public static final int PAYMENT_STATUS_POSTED_CLEARED       = 8;
    public static final int PAYMENT_STATUS_POSTED_CLOSED        = 9;
    public static final int DOCUMENT_STATUS_APPROVED        = 10;
    public static final int DOCUMENT_STATUS_RETURN        = 11;
    
    
    /**
    * declaration of identifier to explain document status above
    */
    public static final String[] fieldDocumentStatus = {
		"Draft",
		"To Be Approved",
		"Final",
		"Revised",
                "Proceed",
                "Closed",
                "Cancelled",
                "Posted",   // khusus utk dokumen payment, sebenarnya namanya "POSTED NOT CLEARED"
                "Posted Cleared",
                "Posted Closed",
                "Approved",
                "Return"
    };
}