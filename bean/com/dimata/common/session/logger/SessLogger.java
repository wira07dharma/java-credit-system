/**
 * Created by IntelliJ IDEA.
 * User: gadnyana
 * Date: May 1, 2004
 * Time: 11:46:26 AM
 * To change this template use Options | File Templates.
 */
package com.dimata.common.session.logger;

import com.dimata.common.entity.search.SrcLogger;
import com.dimata.common.entity.logger.PstLogger;
import com.dimata.common.entity.logger.Logger;
import com.dimata.util.Formater;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.DBHandler;

import java.util.Vector;
import java.util.Date;
import java.sql.ResultSet;

public class SessLogger {
    public static final String SESS_SRC_LOGGER = "SESS_SRC_LOGGER";

    public static Vector searchLogger(SrcLogger srcLogger,int start, int maxRecord){
        DBResultSet dbrs = null;
        Vector list = new Vector(1,1);
        try{
            String sql = "SELECT * FROM "+PstLogger.TBL_LOGGER+
                " WHERE "+PstLogger.fieldNames[PstLogger.FLD_DATE]+
                " BETWEEN '"+Formater.formatDate(srcLogger.getStartDate(),"yyyy-MM-dd 00:00:00")+"' AND '"+
                Formater.formatDate(srcLogger.getEndDate(),"yyyy-MM-dd 23:59:59")+"'";

            sql = sql + " ORDER BY "+PstLogger.fieldNames[PstLogger.FLD_DATE]+" DESC";
            if(maxRecord!=0){
                sql = sql + " LIMIT "+start+","+maxRecord;
            }

            System.out.println("LOG :"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while(rs.next()){
                Logger log = new Logger();
                log.setOID(rs.getLong(PstLogger.fieldNames[PstLogger.FLD_LOGGER_ID]));

                Date tm = DBHandler.convertDate(rs.getDate(PstLogger.fieldNames[PstLogger.FLD_DATE]),rs.getTime(PstLogger.fieldNames[PstLogger.FLD_DATE]));
                log.setDate(tm);

                log.setLoginId(rs.getLong(PstLogger.fieldNames[PstLogger.FLD_LOGIN_ID]));
                log.setLoginName(rs.getString(PstLogger.fieldNames[PstLogger.FLD_LOGIN_NAME]));
                log.setNotes(rs.getString(PstLogger.fieldNames[PstLogger.FLD_NOTES]));

                list.add(log);
            }
        }catch(Exception e){}
        return list;
    }

    /**
     * pengambilan jumlah record berdasarkan parameter search.
     * @param srcLogger
     * @return
     */
    public static int countLogger(SrcLogger srcLogger){
        DBResultSet dbrs = null;
        int count = 0;
        try{
            String sql = "SELECT COUNT("+PstLogger.fieldNames[PstLogger.FLD_LOGGER_ID]+
                ") AS CNT_"+PstLogger.fieldNames[PstLogger.FLD_LOGGER_ID]+" FROM "+PstLogger.TBL_LOGGER+
                " WHERE "+PstLogger.fieldNames[PstLogger.FLD_DATE]+
                " BETWEEN '"+Formater.formatDate(srcLogger.getStartDate(),"yyyy-MM-dd 00:00:00")+"' AND '"+
                Formater.formatDate(srcLogger.getEndDate(),"yyyy-MM-dd 23:59:59")+"'";

            System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while(rs.next()){
                count = rs.getInt("CNT_"+PstLogger.fieldNames[PstLogger.FLD_LOGGER_ID]);
            }
        }catch(Exception e){}
        return count;
    }

}
