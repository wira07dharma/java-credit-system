
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	:  [authorName] 
 * @version  	:  [version] 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.common.entity.logger;

/* package java */
import java.util.Date;
import java.util.Vector;
import java.sql.ResultSet;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.Command;
import com.dimata.common.db.*;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.qdep.entity.Entity;



public class PstLogger extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	//public static final  String TBL_LOGGER = "COM_LOGGER";
    public static final  String TBL_LOGGER = "com_logger";

	public static final  int FLD_LOGGER_ID = 0;
	public static final  int FLD_LOGIN_ID = 1;
	public static final  int FLD_LOGIN_NAME = 2;
    public static final  int FLD_DATE = 3;
    public static final  int FLD_NOTES= 4;

	public static final  String[] fieldNames = {
		"LOGGER_ID",
		"LOGIN_ID",
		"LOGIN_NAME",
        "DATE",
        "NOTES"
	 };

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING
	 };

	public PstLogger(){
	}

	public PstLogger(int i) throws DBException {
		super(new PstLogger());
	}

	public PstLogger(String sOid) throws DBException { 
		super(new PstLogger(0));
		if(!locate(sOid)) 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public PstLogger(long lOid) throws DBException { 
		super(new PstLogger(0));
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
		return TBL_LOGGER;
	}

	public String[] getFieldNames(){ 
		return fieldNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new PstLogger().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception{
		Logger logger = fetchExc(ent.getOID());
		ent = (Entity)logger;
		return logger.getOID();
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Logger) ent);
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Logger) ent);
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Logger fetchExc(long oid) throws DBException{
		try{ 
			Logger logger = new Logger();
			PstLogger pstLogger = new PstLogger(oid);
			logger.setOID(oid);

			logger.setLoginId(pstLogger.getlong(FLD_LOGIN_ID));
			logger.setLoginName(pstLogger.getString(FLD_LOGIN_NAME));
            logger.setDate(pstLogger.getDate(FLD_DATE));
            logger.setNotes(pstLogger.getString(FLD_NOTES));

			return logger;
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLogger(0),DBException.UNKNOWN);
		} 
	}

	public static long insertExc(Logger logger) throws DBException{
		try{ 
			PstLogger pstLogger = new PstLogger(0);

			pstLogger.setLong(FLD_LOGIN_ID, logger.getLoginId());
			pstLogger.setString(FLD_LOGIN_NAME, logger.getLoginName());
            pstLogger.setDate(FLD_DATE, logger.getDate());
            pstLogger.setString(FLD_NOTES, logger.getNotes());

			pstLogger.insert();
			logger.setOID(pstLogger.getlong(FLD_LOGGER_ID));
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLogger(0),DBException.UNKNOWN);
		}
		return logger.getOID();
	}

	public static long updateExc(Logger logger) throws DBException{
		try{ 
			if(logger.getOID() != 0){
				PstLogger pstLogger = new PstLogger(logger.getOID());

                pstLogger.setLong(FLD_LOGIN_ID, logger.getLoginId());
                pstLogger.setString(FLD_LOGIN_NAME, logger.getLoginName());
                pstLogger.setDate(FLD_DATE, logger.getDate());
                pstLogger.setString(FLD_NOTES, logger.getNotes());

				pstLogger.update();
				return logger.getOID();

			}
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLogger(0),DBException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws DBException{ 
		try{ 
			PstLogger pstDepartment = new PstLogger(oid);
			pstDepartment.delete();
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLogger(0),DBException.UNKNOWN);
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
			String sql = "SELECT * FROM " + TBL_LOGGER;
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
				Logger logger = new Logger();
				resultToObject(rs, logger);
				lists.add(logger);
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

	public static void resultToObject(ResultSet rs, Logger logger){
		try{
            logger.setOID(rs.getLong(PstLogger.fieldNames[PstLogger.FLD_LOGGER_ID]));
			logger.setLoginId(rs.getLong(PstLogger.fieldNames[PstLogger.FLD_LOGIN_ID]));
			logger.setLoginName(rs.getString(PstLogger.fieldNames[PstLogger.FLD_LOGIN_NAME]));

            Date tm = DBHandler.convertDate(rs.getDate(PstLogger.fieldNames[PstLogger.FLD_DATE]),rs.getTime(PstLogger.fieldNames[PstLogger.FLD_DATE]));
            logger.setDate(tm);
            logger.setNotes(rs.getString(PstLogger.fieldNames[PstLogger.FLD_NOTES]));
		}catch(Exception e){ }
	}

	public static boolean checkOID(long loggerId){
		DBResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + TBL_LOGGER+ " WHERE " +
						PstLogger.fieldNames[PstLogger.FLD_LOGGER_ID] + " = " + loggerId;

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
			String sql = "SELECT COUNT("+ PstLogger.fieldNames[PstLogger.FLD_LOGGER_ID] + ") FROM " + TBL_LOGGER;
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
	public static int findLimitStart( long oid, int recordToGet, String whereClause, String order){
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, order); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   Logger logger = (Logger)list.get(ls);
				   if(oid == logger.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}

   /*public static boolean checkMaster(long oid)
    {
        if(PstEmployee.checkDepartment(oid))
            return true;
        else{
            if(PstCareerPath.checkDepartment(oid))
            	return true;
            else{
                 if(PstSection.checkDepartment(oid))
                  	return true;
                 else
               		 return false;
            }
        }
    }*/

    /**
     * proses insert logger/history per page
     * @param loginId
     * @param loginName
     * @param logDate
     * @param notes
     * @return
     */
    public static long insertLogger(long loginId,String loginName, Date logDate,
                                   String notes){
        long oid = 0;
        Logger logger = new Logger();
        logger.setLoginId(loginId);
        logger.setLoginName(loginName);
        logger.setDate(logDate);
        logger.setNotes(notes);
        try{
            oid = PstLogger.insertExc(logger);
        }catch(Exception e){}
        return oid;
    }

    public static String checkCommLogger(String strNotes, int command){
        String str = "";
        switch(command){
            case Command.NONE: str = "Open pages : "+strNotes;break;
            case Command.LIST:str = "Pages list : "+strNotes;break;
            case Command.ADD:str = "Add data in : "+strNotes;break;
            case Command.SAVE:str = "Save data in : "+strNotes;break;
            case Command.DELETE:str = "Delete data in : "+strNotes;break;
            case Command.FIRST:str = "First data in : "+strNotes;break;
            case Command.PREV:str = "Previous data in : "+strNotes;break;
            case Command.NEXT:str = "Next data in : "+strNotes;break;
            case Command.LAST:str = "Last data in : "+strNotes;break;
            case Command.ASK:str = "Confirm delete data in : "+strNotes;break;
            case Command.LOGIN:str = "Login";break;
            case Command.LOGOUT:str = "Logout";break;
            default:str = strNotes;
        }
        return str+"...";
    }

    public static int findLimitCommand(int start, int recordToGet, int vectSize)
    {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + mdl;
    	if(start == 0)
            cmd =  Command.FIRST;
        else{
            if(start == (vectSize-recordToGet))
                cmd = Command.LAST;
            else{
            	start = start + recordToGet;
             	if(start <= (vectSize - recordToGet)){
                 	cmd = Command.NEXT;
                    System.out.println("next.......................");
             	}else{
                    start = start - recordToGet;
		             if(start > 0){
                         cmd = Command.PREV;
                         System.out.println("prev.......................");
		             }
                }
            }
        }

        return cmd;
    }

}
