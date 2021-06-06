/*
 * FrmSrcInvoice.java
 *
 * Created on February 25, 2005, 5:57 PM
 */

package com.dimata.pos.form.search;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.dimata.qdep.form.*;
import com.dimata.pos.entity.search.*; 
import com.dimata.pos.entity.billing.*;
/* project package */



//public class FrmSrcPendingOrder  
/**
 *
 * @author  wpradnyana
 */
public class FrmSrcInvoice extends FRMHandler implements I_FRMInterface, I_FRMType
{
    
    public static final String FRM_NAME_SRC_INVOICE="FRM_NAME_SRC_INVOICE";
    
    SrcInvoice srcInvoice;
    public static final int FRM_FLD_CUSTOMER_NAME=0;    
      public static final int FRM_FLD_INVOICE_DATE=1;
      public static final int FRM_FLD_INVOICE_DATE_TO=2;
      public static final int FRM_FLD_INVOICE_ID=3;
      public static final int FRM_FLD_INVOICE_NUMBER=4;
      public static final int FRM_FLD_MEMBER_ID=5;
      public static final int FRM_FLD_MEMBER_NAME=6;
      public static final int FRM_FLD_TRANSACTION_POIN=7;
      public static final int FRM_FLD_TRANSACTION_STATUS=8;
      
      
    
    public static String[] fieldNames={
      "FRM_FLD_CUSTOMER_NAME",
      "FRM_FLD_INVOICE_DATE",
      "FRM_FLD_INVOICE_DATE_TO",
      "FRM_FLD_INVOICE_ID",
      "FRM_FLD_INVOICE_NUMBER",
      "FRM_FLD_MEMBER_ID",
      "FRM_FLD_MEMBER_NAME",
      "FRM_FLD_TRANSACTION_POIN",
      "FRM_FLD_TRANSACTION_STATUS"
      
      
    };
    public static int[] fieldTypes={
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT
        
    };
    
    /** Creates a new instance of FrmSrcInvoice */
    public FrmSrcInvoice ()
    {
    }
    
     public FrmSrcInvoice (SrcInvoice srcInvoice) 
        {
            this.srcInvoice = srcInvoice; 
	}

	public FrmSrcInvoice (HttpServletRequest request, SrcInvoice srcInvoice)
        {
            super(new FrmSrcInvoice(srcInvoice), request);
            this.srcInvoice = srcInvoice;
	}
    public String[] getFieldNames ()
    {
        return fieldNames;
        //throw new UnsupportedOperationException ();
    }
    
    public int getFieldSize ()
    {
        return fieldNames.length;
        //throw new UnsupportedOperationException ();
    }
    
    public int[] getFieldTypes ()
    {
        return fieldTypes;
        //throw new UnsupportedOperationException ();
    }
    
    public String getFormName ()
    {
        return FRM_NAME_SRC_INVOICE; 
        //;throw new UnsupportedOperationException ();
    }
    
    public void requestEntityObject(SrcInvoice srcInvoice){
        try{
            this.requestParam ();
             srcInvoice.setCustomerName (getString (FRM_FLD_CUSTOMER_NAME)); 
            srcInvoice.setInvoiceDate (getDate(FRM_FLD_INVOICE_DATE));
            srcInvoice.setInvoiceDateTo (getDate(FRM_FLD_INVOICE_DATE_TO));
            srcInvoice.setInvoiceId (getLong (FRM_FLD_INVOICE_ID));
            srcInvoice.setInvoiceNumber (getString (FRM_FLD_INVOICE_NUMBER));
            srcInvoice.setMemberId (getLong (FRM_FLD_MEMBER_ID));
            srcInvoice.setMemberName (getString(FRM_FLD_MEMBER_NAME));
            srcInvoice.setTransactionPoin (getInt(FRM_FLD_TRANSACTION_POIN));
            srcInvoice.setTransStatus(getInt(FRM_FLD_TRANSACTION_STATUS)); 
            
        }catch(Exception e){
            e.printStackTrace(); 
        }
    }
}
