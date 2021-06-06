
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

package com.dimata.common.entity.logger;

/* package java */ 
import java.io.*
;
import java.sql.*
;import java.util.*
;import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.common.db.*;
import com.dimata.qdep.entity.*;

/* package jkjonline */
/*import com.dimata.jkjonline.db.DBHandler;
import com.dimata.jkjonline.db.DBException;
import com.dimata.jkjonline.db.DBLogger;
import com.dimata.jkjonline.entity.admin.*; */

public class PstLoginLog extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language { 

	public static final  String TBL_LOGIN_LOG = "LOGIN_LOG";

	public static final  int FLD_LOGIN_LOG_ID = 0;
	public static final  int FLD_REMOTE_IP = 1;
	public static final  int FLD_RELEASE_TIME = 2;
	public static final  int FLD_STATUS = 3;
	public static final  int FLD_DESCRIPTION = 4;
    public static final  int FLD_LOGIN_DATE	= 5;
    public static final  int FLD_UPDATE_DATE = 6;

	public static final  String[] fieldNames = {
		"LOGIN_LOG_ID",
		"REMOTE_IP",
		"RELEASE_TIME",
		"STATUS",
		"DESCRIPTION",
        "LOGIN_DATE",
        "UPDATE_DATE"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_INT,
		TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE
	 };

    public static int RELEASED_PERIODE = 15; //15 minutes
    public static int HOURS_DIFFERENT_W_SERVER = 0; //beda waktu dgn server, untuk non online default = 0

    public static final int LOGIN_ON_SESSION = 0;
    public static final int LOGIN_BLOCKED	 = 1;
    public static final int LOGIN_RELEASED	 = 2;

    public static final String[] strStatusLogin = {"ON SESSION", "BLOKED", "RELEASED"};

	public PstLoginLog(){
	}

	public PstLoginLog(int i) throws DBException { 
		super(new PstLoginLog()); 
	}

	public PstLoginLog(String sOid) throws DBException { 
		super(new PstLoginLog(0)); 
		if(!locate(sOid)) 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public PstLoginLog(long lOid) throws DBException { 
		super(new PstLoginLog(0)); 
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
		return TBL_LOGIN_LOG;
	}

	public String[] getFieldNames(){ 
		return fieldNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new PstLoginLog().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		LoginLog loginlog = fetchExc(ent.getOID()); 
		ent = (Entity)loginlog; 
		return loginlog.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((LoginLog) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((LoginLog) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static LoginLog fetchExc(long oid) throws DBException{ 
		try{ 
			LoginLog loginlog = new LoginLog();
			PstLoginLog pstLoginLog = new PstLoginLog(oid); 
			loginlog.setOID(oid);

			loginlog.setRemoteIp(pstLoginLog.getString(FLD_REMOTE_IP));
			loginlog.setReleaseTime(pstLoginLog.getDate(FLD_RELEASE_TIME));
			loginlog.setStatus(pstLoginLog.getInt(FLD_STATUS));
			loginlog.setDescription(pstLoginLog.getString(FLD_DESCRIPTION));
            loginlog.setLoginDate(pstLoginLog.getDate(FLD_LOGIN_DATE));
            loginlog.setUpdateDate(pstLoginLog.getDate(FLD_UPDATE_DATE));

			return loginlog; 
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLoginLog(0),DBException.UNKNOWN); 
		} 
	}

	public static long insertExc(LoginLog loginlog) throws DBException{ 
		try{ 
			PstLoginLog pstLoginLog = new PstLoginLog(0);

			pstLoginLog.setString(FLD_REMOTE_IP, loginlog.getRemoteIp());
			pstLoginLog.setDate(FLD_RELEASE_TIME, loginlog.getReleaseTime());
			pstLoginLog.setInt(FLD_STATUS, loginlog.getStatus());
			pstLoginLog.setString(FLD_DESCRIPTION, loginlog.getDescription());
            pstLoginLog.setDate(FLD_LOGIN_DATE, loginlog.getLoginDate());
            pstLoginLog.setDate(FLD_UPDATE_DATE, loginlog.getUpdateDate());

			pstLoginLog.insert(); 
			loginlog.setOID(pstLoginLog.getlong(FLD_LOGIN_LOG_ID));
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLoginLog(0),DBException.UNKNOWN); 
		}
		return loginlog.getOID();
	}

	public static long updateExc(LoginLog loginlog) throws DBException{ 
		try{ 
			if(loginlog.getOID() != 0){ 
				PstLoginLog pstLoginLog = new PstLoginLog(loginlog.getOID());

				pstLoginLog.setString(FLD_REMOTE_IP, loginlog.getRemoteIp());
				pstLoginLog.setDate(FLD_RELEASE_TIME, loginlog.getReleaseTime());
				pstLoginLog.setInt(FLD_STATUS, loginlog.getStatus());
				pstLoginLog.setString(FLD_DESCRIPTION, loginlog.getDescription());
                pstLoginLog.setDate(FLD_LOGIN_DATE, loginlog.getLoginDate());
                pstLoginLog.setDate(FLD_UPDATE_DATE, loginlog.getUpdateDate());

				pstLoginLog.update(); 
				return loginlog.getOID();

			}
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLoginLog(0),DBException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws DBException{ 
		try{ 
			PstLoginLog pstLoginLog = new PstLoginLog(oid);
			pstLoginLog.delete();
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLoginLog(0),DBException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + TBL_LOGIN_LOG; 
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
				LoginLog loginlog = new LoginLog();
				resultToObject(rs, loginlog);
				lists.add(loginlog);
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

	private static void resultToObject(ResultSet rs, LoginLog loginlog){
		try{
			loginlog.setOID(rs.getLong(PstLoginLog.fieldNames[PstLoginLog.FLD_LOGIN_LOG_ID]));
			loginlog.setRemoteIp(rs.getString(PstLoginLog.fieldNames[PstLoginLog.FLD_REMOTE_IP]));

            Date dt = null;
            Date tm = null;
            Date dateTime = null;
            try{
	            dt = rs.getDate(fieldNames[FLD_RELEASE_TIME]);
	            tm = rs.getTime(fieldNames[FLD_RELEASE_TIME]);
	            dateTime = new Date(dt.getYear(), dt.getMonth(), dt.getDate(), tm.getHours(), tm.getMinutes());
				loginlog.setReleaseTime(dateTime);
            }
            catch(Exception e){
            }

			loginlog.setStatus(rs.getInt(PstLoginLog.fieldNames[PstLoginLog.FLD_STATUS]));
			loginlog.setDescription(rs.getString(PstLoginLog.fieldNames[PstLoginLog.FLD_DESCRIPTION]));

            try{
	            dt = rs.getDate(fieldNames[FLD_LOGIN_DATE]);
	            tm = rs.getTime(fieldNames[FLD_LOGIN_DATE]);
	            dateTime = new Date(dt.getYear(), dt.getMonth(), dt.getDate(), tm.getHours(), tm.getMinutes());
				loginlog.setLoginDate(dateTime);
            }
            catch(Exception e){
            }

            try{
	            dt = rs.getDate(fieldNames[FLD_UPDATE_DATE]);
	            tm = rs.getTime(fieldNames[FLD_UPDATE_DATE]);
	            dateTime = new Date(dt.getYear(), dt.getMonth(), dt.getDate(), tm.getHours(), tm.getMinutes());
				loginlog.setLoginDate(dateTime);
            }
            catch(Exception e){
            }


		}catch(Exception e){ }
	}

	public static boolean checkOID(long loginLogId){
		DBResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + TBL_LOGIN_LOG + " WHERE " + 
						PstLoginLog.fieldNames[PstLoginLog.FLD_LOGIN_LOG_ID] + " = " + loginLogId;

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
			String sql = "SELECT COUNT("+ PstLoginLog.fieldNames[PstLoginLog.FLD_LOGIN_LOG_ID] + ") FROM " + TBL_LOGIN_LOG;
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
			  	   LoginLog loginlog = (LoginLog)list.get(ls);
				   if(oid == loginlog.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}


    public static boolean getStatusLogin(String remoteIp, int status){

        String where  = fieldNames[FLD_STATUS]+"="+status+
            " AND "+fieldNames[FLD_REMOTE_IP]+"='"+remoteIp+"'";

        Vector vct = list(0,0, where, null);

        if(vct!=null && vct.size()>0){
              return true;
        }

        return false;
    }

    public static LoginLog getLogLogin(String remoteIp, int status){

        String where  = fieldNames[FLD_STATUS]+"="+status+
            " AND "+fieldNames[FLD_REMOTE_IP]+"='"+remoteIp+"'";

        Vector vct = list(0,0, where, null);

        if(vct!=null && vct.size()>0){
              return (LoginLog)vct.get(0);
        }

        return null;
    }

    public static boolean isTimeToRelease(LoginLog lLog){
        //pengecekan waktu 15 menit login .. eka
       if (lLog!=null && lLog.getReleaseTime()!= null) {
	       Date dt = new Date();
	       Date loginDt = lLog.getReleaseTime();
	       if (dt.before(loginDt))
	         return false;
       }

       return true;

    }


    public static LoginLog insertNewLoginSession(String remoteIp){

        LoginLog loginLog = new LoginLog();
        loginLog.setRemoteIp(remoteIp);
        loginLog.setStatus(LOGIN_ON_SESSION);
        loginLog.setDescription("Login On Session");
        Date dt = new Date();
        dt.setHours(dt.getHours()+HOURS_DIFFERENT_W_SERVER);
        loginLog.setLoginDate(dt);

        long oid = 0;
        try{
			oid = PstLoginLog.insertExc(loginLog);
        }
        catch(Exception e){
        }
        return loginLog;
    }

    public static long updateStatus(LoginLog lLog, int status){

        if(lLog!=null && lLog.getOID()!=0){
	        lLog.setStatus(status);
	        lLog.setDescription("Update status to "+strStatusLogin[status]);
            Date dtx = new Date();
            dtx.setHours(dtx.getHours()+HOURS_DIFFERENT_W_SERVER);
	        lLog.setUpdateDate(dtx);
	        if(status==LOGIN_BLOCKED){
	            Date dt = new Date();
                dtx.setHours(dt.getHours()+HOURS_DIFFERENT_W_SERVER);
	            dt.setMinutes(dt.getMinutes()+RELEASED_PERIODE);
	            lLog.setReleaseTime(dt);
	        }
	
	        long oid = 0;
	        try{
				oid = PstLoginLog.updateExc(lLog);
	        }
	        catch(Exception e){
	        }
	        return oid;
        }

        return 0;
    }

}
