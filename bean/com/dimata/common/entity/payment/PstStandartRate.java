
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

package com.dimata.common.entity.payment;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.common.db.*;
import com.dimata.qdep.entity.*;

//import com.dimata.interfaces.BOPos.I_StandardRate;

public class PstStandartRate extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language{

    public static final  String TBL_POS_STANDART_RATE = "standart_rate";

    public static final  int FLD_STANDART_RATE_ID = 0;
    public static final  int FLD_CURRENCY_TYPE_ID = 1;
    public static final  int FLD_SELLING_RATE = 2;
    public static final  int FLD_START_DATE = 3;
    public static final  int FLD_END_DATE = 4;
    public static final  int FLD_STATUS = 5;
    ///public static final  int FLD_INCLUDE_IN_PROCESS = 6;

    public static final  String[] fieldNames = {
        "STANDART_RATE_ID",
        "CURRENCY_TYPE_ID",
        "SELLING_RATE",
        "START_DATE",
        "END_DATE",
        "STATUS"/*,
                "INCLUDE_IN_PROCESS"*/
    };

    public static final  int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT/*,
                TYPE_INT*/
    };

    public static final  int NOT_ACTIVE = 0;
    public static final  int ACTIVE = 1;

    public static final String statusName[][] = {
        {"History","Aktif"},
        {"History","Active"}
    };

    public static final  int NOT_INCLUDE = 0;
    public static final  int INCLUDE = 1;

    public static final String includeName[][] = {
        {"Tidak","Ya"},
        {"Not Include","Include"}
    };

    public PstStandartRate(){
    }

    public PstStandartRate(int i) throws DBException {
        super(new PstStandartRate());
    }

    public PstStandartRate(String sOid) throws DBException {
        super(new PstStandartRate(0));
        if(!locate(sOid))
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public PstStandartRate(long lOid) throws DBException {
        super(new PstStandartRate(0));
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
        return TBL_POS_STANDART_RATE;
    }

    public String[] getFieldNames(){
        return fieldNames;
    }

    public int[] getFieldTypes(){
        return fieldTypes;
    }

    public String getPersistentName(){
        return new PstStandartRate().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception{
        StandartRate standartrate = fetchExc(ent.getOID());
        ent = (Entity)standartrate;
        return standartrate.getOID();
    }

    public long insertExc(Entity ent) throws Exception{
        return insertExc((StandartRate) ent);
    }

    public long updateExc(Entity ent) throws Exception{
        return updateExc((StandartRate) ent);
    }

    public long deleteExc(Entity ent) throws Exception{
        if(ent==null){
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static StandartRate fetchExc(long oid) throws DBException{
        try{
            StandartRate standartrate = new StandartRate();
            PstStandartRate pstStandartRate = new PstStandartRate(oid);
            standartrate.setOID(oid);

            standartrate.setCurrencyTypeId(pstStandartRate.getlong(FLD_CURRENCY_TYPE_ID));
            standartrate.setSellingRate(pstStandartRate.getdouble(FLD_SELLING_RATE));
            standartrate.setStartDate(pstStandartRate.getDate(FLD_START_DATE));
            standartrate.setEndDate(pstStandartRate.getDate(FLD_END_DATE));
            standartrate.setStatus(pstStandartRate.getInt(FLD_STATUS));
            //standartrate.setIncludeInProcess(pstStandartRate.getInt(FLD_INCLUDE_IN_PROCESS));

            return standartrate;
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstStandartRate(0),DBException.UNKNOWN);
        }
    }

    public static long insertExc(StandartRate standartrate) throws DBException{
        try{
            PstStandartRate pstStandartRate = new PstStandartRate(0);

            pstStandartRate.setLong(FLD_CURRENCY_TYPE_ID, standartrate.getCurrencyTypeId());
            pstStandartRate.setDouble(FLD_SELLING_RATE, standartrate.getSellingRate());
            pstStandartRate.setDate(FLD_START_DATE, standartrate.getStartDate());
            pstStandartRate.setDate(FLD_END_DATE, standartrate.getEndDate());
            pstStandartRate.setInt(FLD_STATUS, standartrate.getStatus());
            //pstStandartRate.setInt(FLD_INCLUDE_IN_PROCESS, standartrate.getIncludeInProcess());

            pstStandartRate.insert();
            standartrate.setOID(pstStandartRate.getlong(FLD_STANDART_RATE_ID));
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstStandartRate(0),DBException.UNKNOWN);
        }
        return standartrate.getOID();
    }

    public static long updateExc(StandartRate standartrate) throws DBException{
        try{
            if(standartrate.getOID() != 0){
                PstStandartRate pstStandartRate = new PstStandartRate(standartrate.getOID());

                pstStandartRate.setLong(FLD_CURRENCY_TYPE_ID, standartrate.getCurrencyTypeId());
                pstStandartRate.setDouble(FLD_SELLING_RATE, standartrate.getSellingRate());
                pstStandartRate.setDate(FLD_START_DATE, standartrate.getStartDate());
                pstStandartRate.setDate(FLD_END_DATE, standartrate.getEndDate());
                pstStandartRate.setInt(FLD_STATUS, standartrate.getStatus());
                //pstStandartRate.setInt(FLD_INCLUDE_IN_PROCESS, standartrate.getIncludeInProcess());

                pstStandartRate.update();
                return standartrate.getOID();

            }
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstStandartRate(0),DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException{
        try{
            PstStandartRate pstStandartRate = new PstStandartRate(oid);
            pstStandartRate.delete();
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstStandartRate(0),DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll(){
        return list(0, 500, "","");
    }

    public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_POS_STANDART_RATE;
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;

            switch (DBHandler.DBSVR_TYPE)
            {
                case DBHandler.DBSVR_MYSQL :
                        if(limitStart == 0 && recordToGet == 0)
                                sql = sql + "";
                        else
                                sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                        break;

                case DBHandler.DBSVR_POSTGRESQL :
                        if(limitStart == 0 && recordToGet == 0)
                                sql = sql + "";
                        else
                                sql = sql + " LIMIT " +recordToGet + " OFFSET "+ limitStart ;

                        break;

                case DBHandler.DBSVR_SYBASE :
                    	break;

                case DBHandler.DBSVR_ORACLE :
                    	break;

                case DBHandler.DBSVR_MSSQL :
                    	break;

                default:
                        break;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                StandartRate standartrate = new StandartRate();
                resultToObject(rs, standartrate);
                lists.add(standartrate);
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

    private static void resultToObject(ResultSet rs, StandartRate standartrate){
        try{
            standartrate.setOID(rs.getLong(PstStandartRate.fieldNames[PstStandartRate.FLD_STANDART_RATE_ID]));
            standartrate.setCurrencyTypeId(rs.getLong(PstStandartRate.fieldNames[PstStandartRate.FLD_CURRENCY_TYPE_ID]));
            standartrate.setSellingRate(rs.getDouble(PstStandartRate.fieldNames[PstStandartRate.FLD_SELLING_RATE]));
            standartrate.setStartDate(rs.getDate(PstStandartRate.fieldNames[PstStandartRate.FLD_START_DATE]));
            standartrate.setEndDate(rs.getDate(PstStandartRate.fieldNames[PstStandartRate.FLD_END_DATE]));
            standartrate.setStatus(rs.getInt(PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS]));
            //standartrate.setIncludeInProcess(rs.getInt(PstStandartRate.fieldNames[PstStandartRate.FLD_INCLUDE_IN_PROCESS]));

        }catch(Exception e){ }
    }

    public static boolean checkOID(long standartRateId){
        DBResultSet dbrs = null;
        boolean result = false;
        try{
            String sql = "SELECT * FROM " + TBL_POS_STANDART_RATE + " WHERE " +
            PstStandartRate.fieldNames[PstStandartRate.FLD_STANDART_RATE_ID] + " = " + standartRateId;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while(rs.next()) { result = true; }
            rs.close();
        }catch(Exception e){
            System.out.println("err : "+e.toString());
        }finally{
            DBResultSet.close(dbrs);

        }
        return result;
    }

    public static int getCount(String whereClause){
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT("+ PstStandartRate.fieldNames[PstStandartRate.FLD_STANDART_RATE_ID] + ") FROM " + TBL_POS_STANDART_RATE;
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


    /* This method used to find current data */
    public static int findLimitStart( long oid, int recordToGet, String whereClause){
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found =false;
        for(int i=0; (i < size) && !found ; i=i+recordToGet){
            Vector list =  list(i,recordToGet, whereClause, order);
            start = i;
            if(list.size()>0){
                for(int ls=0;ls<list.size();ls++){
                    StandartRate standartrate = (StandartRate)list.get(ls);
                    if(oid == standartrate.getOID())
                        found=true;
                }
            }
        }
        if((start >= size) && (size > 0))
            start = start - recordToGet;

        return start;
    }
    /* proses update status */
    public static void updateStatus(long currencyTypeId){
        String whereClause = fieldNames[FLD_CURRENCY_TYPE_ID] +" = "+currencyTypeId+
        " AND "+fieldNames[FLD_STATUS] +" = "+ACTIVE;
        String order = fieldNames[FLD_STATUS]+" DESC ";
        Vector result = list(0,0, whereClause, order);
        if(result!=null&&result.size()>0){
            for(int i=0;i<result.size();i++){
                StandartRate sRate = (StandartRate)result.get(i);
                sRate.setStatus(NOT_ACTIVE);
                try{
                    updateExc(sRate);
                    System.out.println("Update OK");
                }catch(Exception e){
                    e.printStackTrace();
                    System.out.println("err di update status : "+e.toString());
                }
            }
        }
    }

    /* get data currency & standart rate */
    public static Vector listCurrStandard(){
        DBResultSet dbrs = null;
        Vector result = new Vector();
        try{
            String sql = " SELECT CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE]+
            ", CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_NAME]+
            ", STD."+PstStandartRate.fieldNames[PstStandartRate.FLD_STANDART_RATE_ID]+
            ", STD."+PstStandartRate.fieldNames[PstStandartRate.FLD_SELLING_RATE]+
            " FROM "+PstStandartRate.TBL_POS_STANDART_RATE+" AS STD "+
            " INNER JOIN "+PstCurrencyType.TBL_POS_CURRENCY_TYPE+" AS CURR "+
            " ON STD."+PstStandartRate.fieldNames[PstStandartRate.FLD_CURRENCY_TYPE_ID]+
            " = CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_CURRENCY_TYPE_ID]+
            " WHERE STD."+PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS]+
            " = "+PstStandartRate.ACTIVE+
            " AND "+
            " CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_INCLUDE_IN_PROCESS]+
            " = "+PstCurrencyType.INCLUDE+
            " ORDER BY CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                Vector temp = new Vector();
                CurrencyType curr = new CurrencyType();
                curr.setCode(rs.getString(PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE]));
                curr.setName(rs.getString(PstCurrencyType.fieldNames[PstCurrencyType.FLD_NAME]));
                temp.add(curr);

                StandartRate stdarRate = new StandartRate();
                stdarRate.setOID(rs.getLong(PstStandartRate.fieldNames[PstStandartRate.FLD_STANDART_RATE_ID]));
                stdarRate.setSellingRate(rs.getDouble(PstStandartRate.fieldNames[PstStandartRate.FLD_SELLING_RATE]));
                temp.add(stdarRate);
                result.add(temp);
            }
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("err get data currency & standard rate : "+e.toString());
        }finally{
            DBResultSet.close(dbrs);

        }
        return result;

    }


    public static StandartRate getActiveStandardRate(long oidCurrType) {
        DBResultSet dbrs = null;
        StandartRate stdRate = new StandartRate();
        try {
            String sql = "SELECT * FROM " + TBL_POS_STANDART_RATE + " WHERE " +
                    fieldNames[FLD_CURRENCY_TYPE_ID] + "=" + oidCurrType +
                    " AND " + fieldNames[FLD_STATUS] + "=" + ACTIVE;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                PstStandartRate.resultToObject(rs, stdRate);
            }

        } catch (Exception e) {
            System.out.println("exception : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }

        return stdRate;
    }


    /**
     * @param limitStart
     * @param recordToGet
     * @param whereClause
     * @param order
     * @return
     */
    public static Vector listStandartRate(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT STA.*" +
            " FROM " + TBL_POS_STANDART_RATE + " AS STA " +
            " INNER JOIN " + PstCurrencyType.TBL_POS_CURRENCY_TYPE + " AS CURR" +
            " ON STA." + PstStandartRate.fieldNames[PstStandartRate.FLD_CURRENCY_TYPE_ID] +
            " = CURR." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CURRENCY_TYPE_ID];
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;

            switch (DBHandler.DBSVR_TYPE)
            {
                case DBHandler.DBSVR_MYSQL :
                        if(limitStart == 0 && recordToGet == 0)
                                sql = sql + "";
                        else
                                sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                        break;

                case DBHandler.DBSVR_POSTGRESQL :
                        if(limitStart == 0 && recordToGet == 0)
                                sql = sql + "";
                        else
                                sql = sql + " LIMIT " +recordToGet + " OFFSET "+ limitStart ;

                        break;

                case DBHandler.DBSVR_SYBASE :
                    	break;

                case DBHandler.DBSVR_ORACLE :
                    	break;

                case DBHandler.DBSVR_MSSQL :
                    	break;

                default:
                        break;
            }

            System.out.println("sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                StandartRate standartrate = new StandartRate();
                resultToObject(rs, standartrate);
                lists.add(standartrate);
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


    /**
     * update oid lama dengan oid baru
     * @param newOID
     * @param originalOID
     * @return
     * @throws DBException
     */
    public static long updateSynchOID(long newOID, long originalOID) throws DBException
    {
        DBResultSet dbrs = null;
        try
        {
            String sql = "UPDATE " + TBL_POS_STANDART_RATE +
                         " SET " + PstStandartRate.fieldNames[PstStandartRate.FLD_STANDART_RATE_ID] +
                         " = " + originalOID +
                         " WHERE " + PstStandartRate.fieldNames[PstStandartRate.FLD_STANDART_RATE_ID] +
                         " = " + newOID;
//            System.out.println(new PstStandartRate().getClass().getName() + ".updateSynchOID() sql : " + sql);
            DBHandler.execUpdate(sql);
            return originalOID;
        }
        catch(Exception e)
        {
            System.out.println(new PstStandartRate().getClass().getName() + ".updateSynchOID() exp : " + e.toString());
            return 0;
        }
        finally
        {
            DBResultSet.close(dbrs);
        }
    }


    /**
     * this method used to get rate of each currency type on AISO
     * return 'hashtable of rate of each currency => key : currencyId, value : rate value'
     */
    public Hashtable getStandartRate()
    {
        Hashtable objHashtable = new Hashtable();

        String whereClause = "";
        Vector vectStandartRate = PstStandartRate.list(0, 0, whereClause, "");
        if(vectStandartRate!=null && vectStandartRate.size()>0)
        {
            int standartRateSize = vectStandartRate.size();
            for(int i=0; i<standartRateSize; i++)
            {
                StandartRate objStandartRate = (StandartRate) vectStandartRate.get(i);
                objHashtable.put(""+objStandartRate.getCurrencyTypeId(), ""+objStandartRate.getSellingRate());
            }
        }

        return objHashtable;
    }

     /*
     * GetCurrencyId
     */

    public static long getCurrencyId() {
        long count = 0;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_CURRENCY_TYPE_ID]+
            " FROM "+PstStandartRate.TBL_POS_STANDART_RATE+" AS STD "+
            " INNER JOIN "+PstCurrencyType.TBL_POS_CURRENCY_TYPE+" AS CURR "+
            " ON STD."+PstStandartRate.fieldNames[PstStandartRate.FLD_CURRENCY_TYPE_ID]+
            " = CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_CURRENCY_TYPE_ID]+
            " WHERE STD."+PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS]+
            " = "+PstStandartRate.ACTIVE+
            " AND "+
            " CURR."+PstCurrencyType.fieldNames[PstCurrencyType.FLD_INCLUDE_IN_PROCESS]+
            " = "+PstCurrencyType.INCLUDE;


          /*if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;*/

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getLong(1);
            }
            rs.close();

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return count;

    }
    
    public long saveStandardRate(String currCode, double value) {
        
        String where = PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE]+"='"+currCode+"'";
        Vector vct = PstCurrencyType.list(0,0, where, null);

        long oid = 0;

        if(vct!=null && vct.size()>0){
            
            CurrencyType ct = (CurrencyType)vct.get(0);
            
            where = PstStandartRate.fieldNames[PstStandartRate.FLD_CURRENCY_TYPE_ID]+"="+ct.getOID()+
                " AND "+PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS]+"="+PstStandartRate.ACTIVE;
            
            Vector temp = PstStandartRate.list(0,0, where, null);
            
            StandartRate sr = new StandartRate();
            StandartRate sr_old = new StandartRate();
            
            if(temp!=null && temp.size()>0){
                sr = (StandartRate)temp.get(0);
                try{
                    sr = PstStandartRate.fetchExc(sr.getOID());
                    sr_old = PstStandartRate.fetchExc(sr.getOID());
                }
                catch(Exception e){
                }
                
                sr.setStatus(PstStandartRate.NOT_ACTIVE);
            
                //inserting history
                try{
                    oid = PstStandartRate.insertExc(sr);
                }
                catch(Exception e){
                }

                //updating standart rate baru
                Date date = new Date();
                sr_old.setStartDate(date);
                date.setYear(date.getYear()+1);
                sr_old.setEndDate(date);
                sr_old.setSellingRate(value);


                try{
                    oid = PstStandartRate.updateExc(sr_old);
                }
                catch(Exception e){
                }
                
            }

            //update status to history
            /*where = "UPDATE "+PstStandartRate.TBL_POS_STANDART_RATE+
                " SET "+PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS]+"="+PstStandartRate.NOT_ACTIVE+
                " WHERE "+PstStandartRate.fieldNames[PstStandartRate.FLD_CURRENCY_TYPE_ID]+"="+ct.getOID();

            try{
                DBHandler.execUpdate(where);
            }
            catch(Exception e){
            }

            //insert active currency
            StandartRate dr = new StandartRate();
            dr.setCurrencyTypeId(ct.getOID());
            dr.setSellingRate(value);
            Date dt = new Date();
            dr.setStartDate(dt);
            dt.setMonth(dt.getMonth()+1);
            dr.setEndDate(dt);
            dr.setIncludeInProcess(INCLUDE);
            dr.setStatus(NOT_ACTIVE);


            try{
        		oid = PstStandartRate.insertExc(dr);
            }
            catch(Exception e){
                oid = 0;
            }*/

        }

        return oid;
        
    }
    
;

}
