/*
 * SessInvoice.java
 *
 * Created on October 7, 2003, 1:03 PM
 */

package com.dimata.pos.session.billing;

import com.dimata.pos.db.DBHandler;
import com.dimata.pos.db.DBResultSet;
import com.dimata.posbo.entity.masterdata.PstSales;
/**
 *
 * @author  pman
 * @version 
 */
/*package java*/
import java.sql.ResultSet;
import java.util.Vector;

//import entity

public class SessSales {
   private static String TBL_SALES="sales_person"; 
    /** Creates new SessInvoice */
    public SessSales() {
    }
    
  public Vector getSales(){  
  Vector lists = new Vector(); 
	DBResultSet dbrs = null;
        try{
            //String sql = "select cash_master_id,location,cashier_name  from CASH_MASTER  where cash_master_id="+cashMasterId;
            String sql=" SELECT "+PstSales.fieldNames[PstSales.FLD_SALES_ID]+","
                                 +PstSales.fieldNames[PstSales.FLD_CODE]+","
                                 +PstSales.fieldNames[PstSales.FLD_NAME]+""+
                       " FROM "+TBL_SALES;
                      // " WHERE "+PstSales.fieldNames[PstSales.FLD_CODE]+"='"+salesCode+"'";
                                   
            
            dbrs = DBHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
            lists = new Vector();           
            while(rs.next()) {
               Vector sales=new Vector(); 
               sales.add(""+rs.getLong(1));
               sales.add(""+rs.getString(2));
               sales.add(""+rs.getString(3));
               lists.add(sales);
            }
            rs.close();
            return lists;
	}catch(Exception e) {
		System.out.println(e);
	}finally {
		DBResultSet.close(dbrs);
	}
     return new Vector();
   }
   

}
