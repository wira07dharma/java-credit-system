
package com.dimata.posbo.session.masterdata;

import java.io.Serializable;
import java.util.Vector;
import com.dimata.posbo.entity.masterdata.DataSyncSql;
import com.dimata.posbo.entity.masterdata.DataSyncStatus;
import com.dimata.posbo.entity.masterdata.PstDataSyncSql;
import com.dimata.posbo.entity.masterdata.OutletConnection;
import com.dimata.posbo.entity.masterdata.PstDataSyncStatus;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Vector;
import java.util.Date;
/* 
 * @author rahde, ktanjana
 * @version 1.0
 * Copyright : PT. Dimata Sora Jayate , 2010
 */


public class TransferDataToOutletThread  implements Runnable, Serializable {
    private OutletConnection conOb=null;
    private Connection dbConn = null;
    private int threadSleep=40;
    private int maxNumber=10;
    private boolean runThread=true;
    private int errCode=0;
    private boolean pauseTransfer=false;
    private String statusText ="";
    

    public TransferDataToOutletThread(){

    }

    public TransferDataToOutletThread(OutletConnection conOb) {
        try{
            this.conOb = conOb;
            conOb.getCash_master_id();
        }catch(Exception e){
            System.out.println(" ! EXC : initiate thread =  "+e.toString());
            setStatusText("connection failed");

            
        }
    }

private void createConn()
        throws SQLException
    {
        try
        {
            Class.forName(this.conOb.getDbdriver()).newInstance();
            setStatusText("Try to connect " + conOb.getDburl() + " " + conOb.getDbuser());
            dbConn = DriverManager.getConnection(this.conOb.getDburl(), this.conOb.getDbuser(), this.conOb.getDbpasswd());
        }
        catch(ClassNotFoundException _ex) {
           System.out.println(" ! EXC :   "+_ex.toString());
            setStatusText("connection failed");
        }
        catch(Exception e) {
            System.out.println(" ! EXC :  "+e.toString());
             setStatusText("connection failed");
        }
    }

  
    public void run() {
        try{
            createConn();
            //int start =0;
            //Vector dataSychSql = PstDataSyncSql.listAll();//ambil data sql by id connection limit by maxNumber ;            
            Vector dataSychSql = PstDataSyncStatus.listQuery(0, maxNumber, PstDataSyncStatus.fieldNames[PstDataSyncStatus.FLD_ID_DBCONNECTION] + "=" + conOb.getOID() , "date");
            String sql =null;
            Statement statement=null;
            setStatusText("Try to transfer data katalog...");
            while(isRunThread() && dataSychSql!=null && dataSychSql.size() > 0){
                if(!isPauseTransfer()){
                for(int idx=0;idx<dataSychSql.size();idx++){
                    DataSyncStatus data = (DataSyncStatus) dataSychSql.get(idx);
                    //sql =data.getQuery() ;// by (idx)
                    //idx++;
                    try{
                     
                     statement = this.dbConn.createStatement();
                     statement.executeUpdate(data.getSql());                     
                     PstDataSyncStatus.deleteExc(data.getOID());
                     System.out.println(" "+conOb.getOID()+ " >> "+data.getSql());
                     // kalau sukses delete dari data synch status
                    } catch(Exception exc){
                       // PstDataSyncSql pstData = new PstDataSyncSql(data.getId_data_sync());
                       // pstData.deleteExc(data.getId_data_sync());
                        Thread.sleep(threadSleep);
                        if(isRunThread()){
                            createConn();
                        }
                        System.out.println(exc);
                    } finally{
                         statement.close();
                    }
                    Thread.sleep(threadSleep);
                }
                //start = start + maxNumber +1;
                dataSychSql = PstDataSyncStatus.listQuery(0, maxNumber, PstDataSyncStatus.fieldNames[PstDataSyncStatus.FLD_ID_DBCONNECTION] + "=" +conOb.getOID() , null);
                }
                Thread.sleep(threadSleep);
                //setRunThread(false);
            }
            this.dbConn.close();
            setStatusText("transfer data finished...");
        }catch(Exception e){
            System.out.println(" ! EXC : PrinterDriverLoader > run =  "+e.toString());
            setStatusText("connection failed...");
            try{
                if(isRunThread()){
                    run();
                }
            }catch(Exception ex){
                System.out.println(ex);
            }


        }
    }
         
    public int getThreadSleep(){
        return threadSleep;
    }
    
    public void setThreadSleep(int threadSleep){
        this.threadSleep = threadSleep;
    }
 
    public int getErrCode(){ return errCode;}
    
    public void setErrCode(int errCode){ this.errCode = errCode; }

    /**
     * @return the runThread
     */
    public boolean isRunThread() {
        return runThread;
    }

    /**
     * @param runThread the runThread to set
     */
    public void setRunThread(boolean runThread) {
        this.runThread = runThread;
    }

    /**
     * @return the pauseTransfer
     */
    public boolean isPauseTransfer() {
        return pauseTransfer;
    }

    /**
     * @param pauseTransfer the pauseTransfer to set
     */
    public void setPauseTransfer(boolean pauseTransfer) {
        this.pauseTransfer = pauseTransfer;
    }

    /**
     * @return the maxNumber
     */
    public int getMaxNumber() {
        return maxNumber;
    }

    /**
     * @param maxNumber the maxNumber to set
     */
    public void setMaxNumber(int maxNumber) {
        this.maxNumber = maxNumber;
    }

    /**
     * @return the statusText
     */
    public String getStatusText() {
        return statusText;
    }

    /**
     * @param statusText the statusText to set
     */
    public void setStatusText(String statusText) {
        this.statusText = statusText;
    }

   
    
        
}
