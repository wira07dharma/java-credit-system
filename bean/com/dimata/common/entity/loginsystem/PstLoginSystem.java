
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

package com.dimata.common.entity.loginsystem;

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
//import com.dimata.interfaces.common.loginsystem.*;

/* package hanoman */
//import com.dimata.hanoman.db.DBHandler;
//import com.dimata.hanoman.db.DBException;
//import com.dimata.hanoman.db.DBLogger;
//import com.dimata.common.entity.loginsystem.*;

public class PstLoginSystem extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final  String TBL_LOGIN_SYSTEM = "LOGIN_SYSTEM";

	public static final  int FLD_LOGIN_SYSTEM_ID = 0;
	public static final  int FLD_USER_ID = 1;
	public static final  int FLD_REMOTE_IP = 2;
	public static final  int FLD_LOGIN_DATE = 3;
	public static final  int FLD_STATUS = 4;
	public static final  int FLD_BLOCKED_DATE = 5;
	public static final  int FLD_NUM_LOGIN = 6;

	public static final  String[] fieldNames = {
		"LOGIN_SYSTEM_ID",
		"USER_ID",
		"REMOTE_IP",
		"LOGIN_DATE",
		"STATUS",
		"BLOCKED_DATE",
		"NUM_LOGIN"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_INT,
		TYPE_DATE,
		TYPE_INT
	 };

    public static final int LOGIN_STATUS_OPEN = 0;
    public static final int LOGIN_STATUS_BLOCKED = 1;

	public static final String[] loginStatus = {"Open", "Blocked"};


    public final static int DO_LOGIN_OK = 0;
    public final static int DO_LOGIN_ALREADY_LOGIN = 1;
    public final static int DO_LOGIN_NOT_VALID = 2;
    public final static int DO_LOGIN_SYSTEM_FAIL = 3;
    public final static int DO_LOGIN_GET_PRIV_ERROR = 4;
    public final static int DO_LOGIN_NO_PRIV_ASIGNED = 5;
    public final static int DO_LOGIN_STATUS_BLOCKED = 6;

    public final static String[] soLoginTxt = {"Login sukses", "User sudah dalam status login",
                                               "Login ID atau Password tidak sesuai", "System cannot login you", "Can't get privilege",
                                               "No access asigned, please contact your system administrator",
    										   "Login ID sedang di block oleh system, ulangi login beberapa waktu lagi"};


	public PstLoginSystem(){
	}

	public PstLoginSystem(int i) throws DBException { 
		super(new PstLoginSystem()); 
	}

	public PstLoginSystem(String sOid) throws DBException { 
		super(new PstLoginSystem(0)); 
		if(!locate(sOid)) 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public PstLoginSystem(long lOid) throws DBException { 
		super(new PstLoginSystem(0)); 
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
		return TBL_LOGIN_SYSTEM;
	}

	public String[] getFieldNames(){ 
		return fieldNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new PstLoginSystem().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		LoginSystem loginsystem = fetchExc(ent.getOID()); 
		ent = (Entity)loginsystem; 
		return loginsystem.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((LoginSystem) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((LoginSystem) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static LoginSystem fetchExc(long oid) throws DBException{ 
		try{ 
			LoginSystem loginsystem = new LoginSystem();
			PstLoginSystem pstLoginSystem = new PstLoginSystem(oid); 
			loginsystem.setOID(oid);

			loginsystem.setUserId(pstLoginSystem.getString(FLD_USER_ID));
			loginsystem.setRemoteIp(pstLoginSystem.getString(FLD_REMOTE_IP));
			loginsystem.setLoginDate(pstLoginSystem.getDate(FLD_LOGIN_DATE));
			loginsystem.setStatus(pstLoginSystem.getInt(FLD_STATUS));
			loginsystem.setBlockedDate(pstLoginSystem.getDate(FLD_BLOCKED_DATE));
			loginsystem.setNumLogin(pstLoginSystem.getInt(FLD_NUM_LOGIN));

			return loginsystem; 
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLoginSystem(0),DBException.UNKNOWN); 
		} 
	}

	public static long insertExc(LoginSystem loginsystem) throws DBException{ 
		try{ 
			PstLoginSystem pstLoginSystem = new PstLoginSystem(0);

			pstLoginSystem.setString(FLD_USER_ID, loginsystem.getUserId());
			pstLoginSystem.setString(FLD_REMOTE_IP, loginsystem.getRemoteIp());
			pstLoginSystem.setDate(FLD_LOGIN_DATE, loginsystem.getLoginDate());
			pstLoginSystem.setInt(FLD_STATUS, loginsystem.getStatus());
			pstLoginSystem.setDate(FLD_BLOCKED_DATE, loginsystem.getBlockedDate());
			pstLoginSystem.setInt(FLD_NUM_LOGIN, loginsystem.getNumLogin());

			pstLoginSystem.insert(); 
			loginsystem.setOID(pstLoginSystem.getlong(FLD_LOGIN_SYSTEM_ID));
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLoginSystem(0),DBException.UNKNOWN); 
		}
		return loginsystem.getOID();
	}

	public static long updateExc(LoginSystem loginsystem) throws DBException{ 
		try{ 
			if(loginsystem.getOID() != 0){ 
				PstLoginSystem pstLoginSystem = new PstLoginSystem(loginsystem.getOID());

				pstLoginSystem.setString(FLD_USER_ID, loginsystem.getUserId());
				pstLoginSystem.setString(FLD_REMOTE_IP, loginsystem.getRemoteIp());
				pstLoginSystem.setDate(FLD_LOGIN_DATE, loginsystem.getLoginDate());
				pstLoginSystem.setInt(FLD_STATUS, loginsystem.getStatus());
				pstLoginSystem.setDate(FLD_BLOCKED_DATE, loginsystem.getBlockedDate());
				pstLoginSystem.setInt(FLD_NUM_LOGIN, loginsystem.getNumLogin());

				pstLoginSystem.update(); 
				return loginsystem.getOID();

			}
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLoginSystem(0),DBException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws DBException{ 
		try{ 
			PstLoginSystem pstLoginSystem = new PstLoginSystem(oid);
			pstLoginSystem.delete();
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstLoginSystem(0),DBException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + TBL_LOGIN_SYSTEM; 
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
				LoginSystem loginsystem = new LoginSystem();
				resultToObject(rs, loginsystem);
				lists.add(loginsystem);
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

	private static void resultToObject(ResultSet rs, LoginSystem loginsystem){
		try{
			loginsystem.setOID(rs.getLong(PstLoginSystem.fieldNames[PstLoginSystem.FLD_LOGIN_SYSTEM_ID]));
			loginsystem.setUserId(rs.getString(PstLoginSystem.fieldNames[PstLoginSystem.FLD_USER_ID]));
			loginsystem.setRemoteIp(rs.getString(PstLoginSystem.fieldNames[PstLoginSystem.FLD_REMOTE_IP]));
			loginsystem.setLoginDate(rs.getDate(PstLoginSystem.fieldNames[PstLoginSystem.FLD_LOGIN_DATE]));
			loginsystem.setStatus(rs.getInt(PstLoginSystem.fieldNames[PstLoginSystem.FLD_STATUS]));
			loginsystem.setBlockedDate(rs.getDate(PstLoginSystem.fieldNames[PstLoginSystem.FLD_BLOCKED_DATE]));
			loginsystem.setNumLogin(rs.getInt(PstLoginSystem.fieldNames[PstLoginSystem.FLD_NUM_LOGIN]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long loginSystemId){
		DBResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + TBL_LOGIN_SYSTEM + " WHERE " + 
						PstLoginSystem.fieldNames[PstLoginSystem.FLD_LOGIN_SYSTEM_ID] + " = " + loginSystemId;

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
			String sql = "SELECT COUNT("+ PstLoginSystem.fieldNames[PstLoginSystem.FLD_LOGIN_SYSTEM_ID] + ") FROM " + TBL_LOGIN_SYSTEM;
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
			  	   LoginSystem loginsystem = (LoginSystem)list.get(ls);
				   if(oid == loginsystem.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}

    public static LoginSystem getLoginSystemUser(String userId, String remoteIp){

        LoginSystem lsystem = new LoginSystem();

        String where = PstLoginSystem.fieldNames[PstLoginSystem.FLD_USER_ID]+"='"+userId+"'"+
            " AND "+PstLoginSystem.fieldNames[PstLoginSystem.FLD_REMOTE_IP]+"='"+remoteIp+"'";

        Vector vct = PstLoginSystem.list(0,0, where , null);
        if(vct!=null && vct.size()>0){
			lsystem = (LoginSystem)vct.get(0);

            if(vct.size()>1){
                for(int i=1; i<vct.size(); i++){
                    LoginSystem lsystem_x = (LoginSystem)vct.get(i);
                    try{
						PstLoginSystem.deleteExc(lsystem_x.getOID());
                    }
                    catch(Exception e){
                    }
                }
            }
        }

        return lsystem;

    }


    public static void deleteUserFromLoginSystem(String userId, String remoteIp){

        LoginSystem lsystem = new LoginSystem();

        String where = "DELETE FROM "+PstLoginSystem.TBL_LOGIN_SYSTEM+
            " WHERE "+PstLoginSystem.fieldNames[PstLoginSystem.FLD_USER_ID]+"='"+userId+"'"+
            " AND "+PstLoginSystem.fieldNames[PstLoginSystem.FLD_REMOTE_IP]+"='"+remoteIp+"'";

        try{
			DBHandler.execUpdate(where);
        }
        catch(Exception e){
        }

    }

    public static int updateStatusLoginSystem(String userId, String remoteIp, int max){

        LoginSystem lsystem = getLoginSystemUser(userId, remoteIp);

        System.out.println("--lsystem.getNumLogin() : "+lsystem.getNumLogin());

        int status = 0;

        lsystem.setNumLogin(lsystem.getNumLogin()+1);

        System.out.println("--lsystem.getNumLogin() 2 : "+lsystem.getNumLogin());

        if(lsystem.getNumLogin()==max){
            lsystem.setBlockedDate(new Date());
            lsystem.setStatus(PstLoginSystem.LOGIN_STATUS_BLOCKED);
        	status = DO_LOGIN_STATUS_BLOCKED;
        }

        try{
            PstLoginSystem.updateExc(lsystem);
        }
        catch(Exception e){
        }

        return status;

    }

    public static LoginSystem insertNewLoginSystem(String userId, String remoteIp){
        LoginSystem ls = new LoginSystem();
        ls.setLoginDate(new Date());
        ls.setNumLogin(1);
        ls.setUserId(userId);
        ls.setRemoteIp(remoteIp);
        ls.setStatus(LOGIN_STATUS_OPEN);
        try{
            PstLoginSystem.insertExc(ls);
        }
        catch(Exception e){
        }

        return ls;
    }


    /*public int doLoginBySecurity(String loginID, String password, String remoteIp, int maxFailLogin, long interfal){

        LoginSystem lsystem = PstLoginSystem.getLoginSystemUser(loginID, remoteIp);

        I_LoginSession iLogSession = null;
        try{
        	iLogSession = (I_LoginSession)Class.forName(I_LoginSession.CLASS_NAME).newInstance();
        }
        catch(Exception e){
            System.out.println("--exc : "+e.toString());
            iLogSession = null;
        }

        int loginOK = 0;

        System.out.println("========== IN LOGIN SYSTEM ===========");
        System.out.println("==iLogSession : "+iLogSession);

        if(iLogSession!=null){


	
	        //if exist
	        if(lsystem.getOID()!=0){
	
	            try{
	               lsystem = PstLoginSystem.fetchExc(lsystem.getOID());
	            }
	            catch(Exception e){
	            }
	
	            System.out.println("-- lsystem prev exist ... id : "+lsystem.getOID());
	
	            //jika di block
	            if(lsystem.getStatus()==PstLoginSystem.LOGIN_STATUS_BLOCKED){
	
	                System.out.println("-- lsystem status blocked");
	
					Date dt = new Date();
	
	                Date blockDt = lsystem.getBlockedDate();
	                System.out.println("-- dt : "+dt);
	                System.out.println("-- dt.getTime : "+dt.getTime());
	                System.out.println("-- blockDt : "+blockDt);
	                System.out.println("-- blockDt.getTime : "+blockDt.getTime());
	
	                System.out.println("-- (dt.getTime()-blockDt.getTime() = "+(dt.getTime()-blockDt.getTime()));
					System.out.println("-- interfal : "+interfal);
	
	                //sudah bebas
	                if((dt.getTime()-blockDt.getTime()) > interfal){
	                    //hapus login system
	                    PstLoginSystem.deleteUserFromLoginSystem(loginID, remoteIp);
	                    System.out.println("-- loginsystem 1");
	                    //lakukan login
	                    loginOK = iLogSession.doLogin(loginID, password);
	                    System.out.println("-- loginsystem 2");
						//jika gagal lagi, input login system baru
	                    if(loginOK!=DO_LOGIN_OK){
	                        PstLoginSystem.insertNewLoginSystem(loginID, remoteIp);
	                        System.out.println("-- loginsystem 3");
	                    }
	                }
	                //belum
	                else{
	                    System.out.println("-- loginsystem 4");
	                    //error
	                    return DO_LOGIN_STATUS_BLOCKED;
	                }
	
	            }
	            //status masih open
	            else{
	                //lakukan login
	                loginOK = iLogSession.doLogin(loginID, password);
	                System.out.println("-- loginsystem 5");
					//jika gagal lagi, update number login
	                if(loginOK!=DO_LOGIN_OK){
	                    int status = PstLoginSystem.updateStatusLoginSystem(loginID, remoteIp, maxFailLogin);
	                    if(status==DO_LOGIN_STATUS_BLOCKED){
	                        loginOK = DO_LOGIN_STATUS_BLOCKED;
	                    }
	                    System.out.println("-- loginsystem 6");
	                }
	                //
	                else{
	                    //hapus login system
	                    PstLoginSystem.deleteUserFromLoginSystem(loginID, remoteIp);
	                    System.out.println("-- loginsystem 7");
	                }
	            }
	        }
	        //tidak ada login system
	        else{
	            //lakukan login
				loginOK = iLogSession.doLogin(loginID, password);
	            System.out.println("-- loginsystem 8");
				//jika gagal lagi, input login system baru
	            if(loginOK!=DO_LOGIN_OK){
	                PstLoginSystem.insertNewLoginSystem(loginID, remoteIp);
	                System.out.println("-- loginsystem 9");
	            }
	        }

        }

        return loginOK;
    }*/

}
