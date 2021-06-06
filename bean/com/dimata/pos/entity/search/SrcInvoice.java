/*
 * SrcInvoice.java
 *
 * Created on February 25, 2005, 5:57 PM
 */

package com.dimata.pos.entity.search;

import java.io.*; 
/**
 *
 * @author  wpradnyana
 */
public class SrcInvoice implements Serializable
{
    
    /**
     * Holds value of property invoiceId.
     */
    private long invoiceId=0;
    
    /**
     * Holds value of property invoiceNumber.
     */
    private String invoiceNumber="";
    
    /**
     * Holds value of property transactionPoin.
     */
    private int transactionPoin=0;
    
    /**
     * Holds value of property memberId.
     */
    private long memberId=0;
    
    /**
     * Holds value of property memberName.
     */
    private String memberName="";
    
    /**
     * Holds value of property customerName.
     */
    private String customerName="";
    
    /**
     * Holds value of property invoiceDate.
     */
    private java.util.Date invoiceDate = new java.util.Date();  
    
    /**
     * Holds value of property invoiceDateTo.
     */
    private java.util.Date invoiceDateTo = new java.util.Date(); 
    
    /**
     * Holds value of property transStatus.
     */
    private int transStatus;
    
    /** Creates a new instance of SrcInvoice */
    public SrcInvoice ()
    {
    }
    
    /**
     * Getter for property invoiceId.
     * @return Value of property invoiceId.
     */
    public long getInvoiceId ()
    {
        return this.invoiceId;
    }
    
    /**
     * Setter for property invoiceId.
     * @param invoiceId New value of property invoiceId.
     */
    public void setInvoiceId (long invoiceId)
    {
        this.invoiceId = invoiceId;
    }
    
    /**
     * Getter for property invoiceNumber.
     * @return Value of property invoiceNumber.
     */
    public String getInvoiceNumber ()
    {
        return this.invoiceNumber;
    }
    
    /**
     * Setter for property invoiceNumber.
     * @param invoiceNumber New value of property invoiceNumber.
     */
    public void setInvoiceNumber (String invoiceNumber)
    {
        this.invoiceNumber = invoiceNumber;
    }
    
    /**
     * Getter for property transactionPoin.
     * @return Value of property transactionPoin.
     */
    public int getTransactionPoin ()
    {
        return this.transactionPoin;
    }
    
    /**
     * Setter for property transactionPoin.
     * @param transactionPoin New value of property transactionPoin.
     */
    public void setTransactionPoin (int transactionPoin)
    {
        this.transactionPoin = transactionPoin;
    }
    
    /**
     * Getter for property memberId.
     * @return Value of property memberId.
     */
    public long getMemberId ()
    {
        return this.memberId;
    }
    
    /**
     * Setter for property memberId.
     * @param memberId New value of property memberId.
     */
    public void setMemberId (long memberId)
    {
        this.memberId = memberId;
    }
    
    /**
     * Getter for property memberName.
     * @return Value of property memberName.
     */
    public String getMemberName ()
    {
        return this.memberName;
    }
    
    /**
     * Setter for property memberName.
     * @param memberName New value of property memberName.
     */
    public void setMemberName (String memberName)
    {
        this.memberName = memberName;
    }
    
    /**
     * Getter for property customerName.
     * @return Value of property customerName.
     */
    public String getCustomerName ()
    {
        return this.customerName;
    }
    
    /**
     * Setter for property customerName.
     * @param customerName New value of property customerName.
     */
    public void setCustomerName (String customerName)
    {
        this.customerName = customerName;
    }
    
    /**
     * Getter for property invoiceDate.
     * @return Value of property invoiceDate.
     */
    public java.util.Date getInvoiceDate ()
    {
        return this.invoiceDate;
    }
    
    /**
     * Setter for property invoiceDate.
     * @param invoiceDate New value of property invoiceDate.
     */
    public void setInvoiceDate (java.util.Date invoiceDate)
    {
        this.invoiceDate = invoiceDate;
    }
    
    /**
     * Getter for property invoiceDateTo.
     * @return Value of property invoiceDateTo.
     */
    public java.util.Date getInvoiceDateTo ()
    {
        return this.invoiceDateTo;
    }
    
    /**
     * Setter for property invoiceDateTo.
     * @param invoiceDateTo New value of property invoiceDateTo.
     */
    public void setInvoiceDateTo (java.util.Date invoiceDateTo)
    {
        this.invoiceDateTo = invoiceDateTo;
    }
    
    public String printValues(){
        StringBuffer buff = new StringBuffer();
        try{
            buff.append ("\n customername "+getCustomerName ());
            //buff.append ("\n invioceDate "+getInvoiceDate ().toString ());
            //buff.append ("\n invoiceDateTo "+getInvoiceDateTo ().toString ());
            buff.append ("\n invoiceNumber "+getInvoiceId ());
            buff.append ("\n memberId "+getMemberId ());
            buff.append ("\n memberName "+getMemberName ());
            buff.append ("\n transactionPoin "+getTransactionPoin ());
        }catch(Exception e){
            e.printStackTrace (); 
        }
        String result = new String(buff);
        return result;
    }
    
    /**
     * Getter for property transStatus.
     * @return Value of property transStatus.
     */
    public int getTransStatus ()
    {
        return this.transStatus;
    }
    
    /**
     * Setter for property transStatus.
     * @param transStatus New value of property transStatus.
     */
    public void setTransStatus (int transStatus)
    {
        this.transStatus = transStatus;
    }
    
}
