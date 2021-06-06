
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.common.entity.periode;

/* package java */ 
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;

public class PstOpnamePeriod extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final  String TBL_STOCK_PERIODE = "pos_opname_periode";

	public static final  int FLD_STOCK_PERIODE_ID = 0;
	public static final  int FLD_PERIODE_TYPE = 1;
	public static final  int FLD_PERIODE_NAME = 2;
	public static final  int FLD_START_DATE = 3;
	public static final  int FLD_END_DATE = 4;
	public static final  int FLD_STATUS = 5;

	public static final  String[] fieldNames = {
		"OPNAME_PERIODE_ID",
		"PERIODE_TYPE",
		"PERIODE_NAME",
		"START_DATE",
		"END_DATE",
		"STATUS"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_INT,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_INT
	 }; 

	public static final int MAT_PERIODE_MONTHLY    = 0;
	public static final int MAT_PERIODE_THREEMONTH = 1;
	public static final int MAT_PERIODE_FOURMONTH  = 2;
	public static final int MAT_PERIODE_SIXMONTH   = 3;
	public static final int MAT_PERIODE_ANNUAL     = 4;
	public static final int[] matPeriodTypeValues = {1,3,4,6,12};
	public static final String[] matPeriodTypeNames = {
		"Monthly",
		"Three Month",
		"Four Month",
		"Six Month",
        "Annual"
	};

    public static Vector getVectPeriodTypes(){
        Vector result = new Vector(1,1);
		for(int i=0; i<matPeriodTypeNames.length; i++){
            result.add(String.valueOf(matPeriodTypeNames[i]));
        }
        return result;
    }

	public static final  int FLD_STATUS_CLOSED = 0;
    public static final  int FLD_STATUS_PREPARE = 1;
	public static final  int FLD_STATUS_RUNNING = 2;
	public static final  String[] statusPeriode = {
		"Closed",
        "Prepare Running",
		"Running"
	};

    public static int NO_ERR = 0;
    public static int ERR_START_DATE = 1;
    public static int ERR_DUE_DATE = 2;

    public static String[][] errorText = {  
    	{" ","Tanggal awal tidak sesuai","Tanggal akhir tidak sesuai"},
    	{" ","Start date invalid","Due date invalid"}
    };

    public static Vector getVectPeriodStatus(){
        Vector result = new Vector(1,1);
		for(int i=0; i<statusPeriode.length; i++){
            result.add(String.valueOf(statusPeriode[i]));
        }
        return result;
    }

	public static final int START_DATE = 0;
	public static final int END_DATE = 1;

	public PstOpnamePeriod(){
	}

	public PstOpnamePeriod(int i) throws DBException { 
		super(new PstOpnamePeriod());
	}

	public PstOpnamePeriod(String sOid) throws DBException { 
		super(new PstOpnamePeriod(0));
		if(!locate(sOid)) 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public PstOpnamePeriod(long lOid) throws DBException { 
		super(new PstOpnamePeriod(0));
		String sOid = "0"; 
		try { 
			sOid = String.valueOf(lOid); 
		}catch(Exception e) { 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		} 
		if(!locate(sOid)) 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		else 
			return; 
	} 

	public int getFieldSize(){ 
		return fieldNames.length; 
	}

	public String getTableName(){ 
		return TBL_STOCK_PERIODE;
	}

	public String[] getFieldNames(){ 
		return fieldNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new PstOpnamePeriod().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception{ 
		OpnamePeriod periode = fetchExc(ent.getOID());
		ent = (Entity)periode;
		return periode.getOID();
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((OpnamePeriod) ent);
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((OpnamePeriod) ent);
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static OpnamePeriod fetchExc(long oid) throws DBException{
		try{ 
			OpnamePeriod periode = new OpnamePeriod();
			PstOpnamePeriod pstOpnamePeriod = new PstOpnamePeriod(oid);
			periode.setOID(oid);

			periode.setPeriodeType(pstOpnamePeriod.getInt(FLD_PERIODE_TYPE));
			periode.setPeriodeName(pstOpnamePeriod.getString(FLD_PERIODE_NAME));
			periode.setStartDate(pstOpnamePeriod.getDate(FLD_START_DATE));
			periode.setEndDate(pstOpnamePeriod.getDate(FLD_END_DATE));
			periode.setStatus(pstOpnamePeriod.getInt(FLD_STATUS));

			return periode;
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstOpnamePeriod(0),DBException.UNKNOWN);
		} 
	}

	public static long insertExc(OpnamePeriod periode) throws DBException{
		try{ 
			PstOpnamePeriod pstOpnamePeriod = new PstOpnamePeriod(0);

			pstOpnamePeriod.setInt(FLD_PERIODE_TYPE, periode.getPeriodeType());
			pstOpnamePeriod.setString(FLD_PERIODE_NAME, periode.getPeriodeName());
			pstOpnamePeriod.setDate(FLD_START_DATE, periode.getStartDate());
			pstOpnamePeriod.setDate(FLD_END_DATE, periode.getEndDate());
			pstOpnamePeriod.setInt(FLD_STATUS, periode.getStatus());

			pstOpnamePeriod.insert();
			periode.setOID(pstOpnamePeriod.getlong(FLD_STOCK_PERIODE_ID));
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstOpnamePeriod(0),DBException.UNKNOWN);
		}
		return periode.getOID();
	}

	public static long updateExc(OpnamePeriod periode) throws DBException{
		try{ 
			if(periode.getOID() != 0){
				PstOpnamePeriod pstOpnamePeriod = new PstOpnamePeriod(periode.getOID());

				pstOpnamePeriod.setInt(FLD_PERIODE_TYPE, periode.getPeriodeType());
				pstOpnamePeriod.setString(FLD_PERIODE_NAME, periode.getPeriodeName());
				pstOpnamePeriod.setDate(FLD_START_DATE, periode.getStartDate());
				pstOpnamePeriod.setDate(FLD_END_DATE, periode.getEndDate());
				pstOpnamePeriod.setInt(FLD_STATUS, periode.getStatus());

				pstOpnamePeriod.update();
				return periode.getOID();

			}
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstOpnamePeriod(0),DBException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws DBException{ 
		try{ 
			PstOpnamePeriod pstOpnamePeriod = new PstOpnamePeriod(oid);
			pstOpnamePeriod.delete();
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstOpnamePeriod(0),DBException.UNKNOWN);
		}
		return oid;
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + TBL_STOCK_PERIODE;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				OpnamePeriod periode = new OpnamePeriod();
				resultToObject(rs, periode);
				lists.add(periode);
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

	public static void resultToObject(ResultSet rs, OpnamePeriod periode){
		try{
			periode.setOID(rs.getLong(PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_STOCK_PERIODE_ID]));
			periode.setPeriodeType(rs.getInt(PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_PERIODE_TYPE]));
			periode.setPeriodeName(rs.getString(PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_PERIODE_NAME]));
			periode.setStartDate(rs.getDate(PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_START_DATE]));
			periode.setEndDate(rs.getDate(PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_END_DATE]));
			periode.setStatus(rs.getInt(PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_STATUS]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long mcdStockOpnamePeriodId){
		DBResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + TBL_STOCK_PERIODE + " WHERE " +
						PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_STOCK_PERIODE_ID] + " = " + mcdStockOpnamePeriodId;

			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) { result = true; }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			DBResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_STOCK_PERIODE_ID] + ") FROM " + TBL_STOCK_PERIODE;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			DBResultSet.close(dbrs);
		}
	}

	public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause){
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, orderClause); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   OpnamePeriod periode = (OpnamePeriod)list.get(ls);
				   if(oid == periode.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}

	public static int findLimitCommand(int start, int recordToGet, int vectSize){
		 int cmd = Command.LIST;
		 int mdl = vectSize % recordToGet;
		 vectSize = vectSize + (recordToGet - mdl);
		 if(start == 0)
			 cmd =  Command.FIRST;
		 else{
			 if(start == (vectSize-recordToGet))
				 cmd = Command.LAST;
			 else{
				 start = start + recordToGet;
				 if(start <= (vectSize - recordToGet)){
					 cmd = Command.NEXT;
				 }else{
					 start = start - recordToGet;
					 if(start > 0){
						 cmd = Command.PREV;
					 } 
				 }
			 } 
		 }
		 return cmd;
	}

    /**
    * this method used to check period
    * if period doesn't exist or the date is valid date to update period ---> create new period
    */
    public static void cekOpnamePeriod(Date date, int periodType){
        long oidOpnamePeriod = 0;
		try{
			oidOpnamePeriod = cekExistOpnamePeriod(PstOpnamePeriod.FLD_STATUS_RUNNING);
            if(oidOpnamePeriod!=0){
                OpnamePeriod periode = new OpnamePeriod();
            	try{
					periode = PstOpnamePeriod.fetchExc(oidOpnamePeriod);
            	}catch(Exception e){}
				if(cekEndDate(periodType,date,periode.getEndDate())){
                	insertOpnamePeriod(periodType,PstOpnamePeriod.FLD_STATUS_PREPARE,date,PstOpnamePeriod.FLD_STATUS_PREPARE);
                }else{
                    long oidPrepare = cekExistOpnamePeriod(PstOpnamePeriod.FLD_STATUS_PREPARE);
                    if(oidPrepare!=0){
		                OpnamePeriod prepare = new OpnamePeriod();
		            	try{
							prepare = PstOpnamePeriod.fetchExc(oidPrepare);
		            	}catch(Exception e){}
                    	if(cekEndDate(periodType,date,prepare.getStartDate())){
                            updateOpnamePeriod(oidOpnamePeriod,PstOpnamePeriod.FLD_STATUS_CLOSED);
                            updateOpnamePeriod(oidPrepare,PstOpnamePeriod.FLD_STATUS_RUNNING);
                    	}
                    }
                }
            }else{
            	insertOpnamePeriod(periodType,PstOpnamePeriod.FLD_STATUS_RUNNING,date,PstOpnamePeriod.FLD_STATUS_RUNNING);
            }
        }catch(Exception e){}
    }

    /**
    * this method used to check if period exist or not
    * if exist ---> return periodId otherwise return 0
    */
	public static long cekExistOpnamePeriod(int status){
		DBResultSet dbrs = null;
		boolean result = false;
        long oidOpnamePeriod = 0;
		try{
			String sql = "SELECT * FROM " + PstOpnamePeriod.TBL_STOCK_PERIODE + " WHERE " +
						PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_STATUS] +" = "+status;
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				oidOpnamePeriod = rs.getLong(PstOpnamePeriod.fieldNames[PstOpnamePeriod.FLD_STOCK_PERIODE_ID]);
            }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			DBResultSet.close(dbrs);
			return oidOpnamePeriod;
		}
	}

    /**
    * this method used to create new period
    */
    public static long insertOpnamePeriod(int periodType, int status, Date date, int typeDate){
        long oid = 0;
        String monthText[] = {
            "January","February","March","April","May","June","July","August","September","October","November","December"
        };

        OpnamePeriod periode = new OpnamePeriod();
		periode.setPeriodeType(periodType);
        periode.setStartDate(getDateStartEnd(periodType,START_DATE,date,typeDate));
        periode.setEndDate(getDateStartEnd(periodType,END_DATE,date,typeDate));
		periode.setStatus(status);

        Date startDate = periode.getStartDate();
        Date endDate = periode.getEndDate();
        if(periodType!=PstOpnamePeriod.MAT_PERIODE_MONTHLY){
	        periode.setPeriodeName("Period "+monthText[startDate.getMonth()]+" "+(1900+startDate.getYear())+" - "+monthText[endDate.getMonth()]+" "+(1900+endDate.getYear()));
        }else{
    	    periode.setPeriodeName("Period "+monthText[startDate.getMonth()]+" "+(1900+startDate.getYear()));
        }

		try{
        	oid = PstOpnamePeriod.insertExc(periode);
        }catch(Exception e){}
        return oid;
    }

    /**
    * this method used to get start date or end date depend on typeDate
    */
    public static Date getDateStartEnd(int periodType, int typeDate, Date date, int tpDate){
        Date result = null;
		Calendar newCalendar = Calendar.getInstance();

    	if(typeDate==START_DATE){
          	 if(tpDate==PstOpnamePeriod.FLD_STATUS_PREPARE){
               	result = new Date(date.getYear(),date.getMonth(),date.getDate()+1);
       		 }else{
				result = new Date(date.getYear(),date.getMonth(),1);
       		 }
    	}else{
	 	     int monthInterval = PstOpnamePeriod.matPeriodTypeValues[periodType];
             Date newDate = null;
          	 if(tpDate==PstOpnamePeriod.FLD_STATUS_PREPARE){
	            newDate = new Date(date.getYear(),date.getMonth()+monthInterval,1);
       		 }else{
	            newDate = new Date(date.getYear(),date.getMonth()+monthInterval-1,1);
       		 }
             newCalendar.setTime(newDate);
             Date currDate = newCalendar.getTime();
           	 result = new Date(currDate.getYear(),currDate.getMonth(),newCalendar.getActualMaximum(newCalendar.DAY_OF_MONTH));
    	}
    	return result;
    }

    /**
    * this method used to check if 'date' is equal to 'newDate'
    */
    public static boolean cekEndDate(int type, Date newDate, Date date){
        boolean bool = false;
        String strNewDate = Formater.formatDate(newDate,"dd MMMM yyyy");
		String strDate = Formater.formatDate(date,"dd MMMM yyyy");
    	if(strNewDate.equals(strDate)){
            bool = true;
		}
        return bool;
    }

	/**
    * this method used to update status of current period into 'close' status
    */
    public static long updateOpnamePeriod(long oidOpnamePeriod, int type){
		OpnamePeriod periode = new OpnamePeriod();
        long oid = 0;
		try{
	        try{
	        	periode = PstOpnamePeriod.fetchExc(oidOpnamePeriod);
	        }catch(Exception e){}
            periode.setOID(oidOpnamePeriod);
	        periode.setStatus(type);
	        try{
				oid = PstOpnamePeriod.updateExc(periode);
	        }catch(Exception e){}

        }catch(Exception e){
			System.out.println("Err : "+e.toString());
        }
        return oid;
    }


    public static void main(String args[]){
        Date newDate = new Date(102,1,28);
        Date startDate = getDateStartEnd(MAT_PERIODE_ANNUAL,START_DATE,newDate,FLD_STATUS_RUNNING);
        Date endDate = getDateStartEnd(MAT_PERIODE_ANNUAL,END_DATE,newDate,FLD_STATUS_RUNNING);
        System.out.println("new start date : "+startDate);
        System.out.println("new end date : "+endDate);
    }

}
