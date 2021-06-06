/*
 Author : I Ketut Kartika Tanjana
 Date   : 6 June 2003
 Class  : ObjSynchNode
 Purpose: Provide multiple node object synchronization among system nodes.
 Features:
    - Scheduled and manual triggered synchronization process
    - Serializatio and deserialization of objects
    - support persitence of session on java application server through Serializable interface
 
 
 */

package com.dimata.services.objsynchxnodes;

import com.dimata.*;
import com.dimata.instant.general.*;
import com.dimata.services.*;
import com.dimata.qdep.entity.*;
import java.util.*;
import com.dimata.instant.util.*;
import java.security.*;
import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.net.MalformedURLException;
import java.io.*;
import com.dimata.services.objsynchxnodes.ObjSynchSerializer;
import com.dimata.services.objsynchxnodes.ObjSynchDeserializer;
import com.dimata.services.objsynchxnodes.ObjSynchStatusInPrc;
import com.dimata.services.objsynchxnodes.ObjSynchFTPAPI;


public class ObjSynchNode implements Runnable, Serializable {
    private static boolean  AutoRunning = false;  // true = auto , false = manual triggered
    private static boolean  CurrentlyRunningManually = false;  // true = auto , false = manual triggered
    
    
    boolean getAutoRunning(){
        return AutoRunning;
    }
    
    void setAutoRunning(boolean modeAuto){
        this.AutoRunning = modeAuto;
    }
    
    public static final String TARGET_FILENAME_PREF_STATUS = "st";
    public static final String TARGET_FILENAME_PREF_OBJECT = "obj";
    
    public static final int LOCAL_PARAM =0;
    public static final int SERVICE_THREAD_SLEEP=1;
    public static final int REMOTE_PARAM =2;
    public static final int REMOTE_FTP =3;
    public static final int TIMER_SETUP=4;
    
    // LOCAL PARAM
    public static final int IDX_LocalHostNameFile = 0;
    public static final int IDX_LocalOutDirURL = 1;
    public static final int IDX_LocalInDirURL = 2;
    public static final int IDX_LocalObjectSubFolder = 3;
    public static final int IDX_LocalStatusSubFolder = 4;
    public static final int IDX_LocalScheFlagFolder = 5;
    public static final int IDX_SchFlagLocal = 6;
    public static final int IDX_LocalNodeName = 7;
    
    // SERVICE THREAD SLEEP TIME (in milli seconds)
    public static final int IDX_threadSleepScheduler = 0;
    public static final int IDX_threadSleepSerializer = 1;
    public static final int IDX_threadSleepDeserializer = 2;
    public static final int IDX_threadSleepStatusInProcessor =3;
    
    //REMOTE PARAMETER
    public static final int IDX_RemoteHostNameFile = 0;
    public static final int IDX_RemoteOutDirURL = 1;
    public static final int IDX_RemoteInDirURL = 2;
    public static final int IDX_RemoteObjectSubFolder = 3;
    public static final int IDX_RemoteStatusSubFolder = 4;
    public static final int IDX_RemoteScheFlagFolder = 5;
    public static final int IDX_SchFlagRemote = 6;
    
    /**
     * many nodes will be separated by semicolon ";" e.g.  node_x;node_y
     **/
    public static final int IDX_OtherNodesNames = 7;
    
    /**
     * many file names of nodes will be separated by semicolon ";" e.g.  last_file_node_x; last_file_node_y
     * the series has to be the same as the series on IDX_OtherNodesNames
     * The last file names will be used to get the next object to be got from nodes data pool.
     **/
    public static final int IDX_LastFileNamesGet = 8;
    
    
    //REMOTE FTP
    public static final int IDX_RemoteHost = 0;
    public static final int IDX_RemotePort = 1;
    public static final int IDX_RemoteUser = 2;
    public static final int IDX_RemotePassword = 3;
    public static final int IDX_RemotePathDelim = 4;
    public static final int IDX_FTPMode = 5;
    public static final int IDX_FTPConnMode = 6;
    
    //MASTER TIMER SETUP
    public static final int IDX_transferPeriodeMinutes = 0;
    public static final int IDX_timeOutRemoteReady = 1;
    
    public static final String SVC_NAME = "DSJ_OBJSYNCH_XNODE";
    public static final String paramName[][]={
        {"LocalHostNameFile", "LocalOutDirURL","LocalInDirURL","LocalObjectSubFolder","LocalStatusSubFolder","LocalScheFlagFolder","SchFlagLocal","LocalNodeName"},
        {"threadSleepScheduler","threadSleepSerializer","threadSleepDeserializer","threadSleepStatusInProcessor"},
        {"RemoteHostNameFile","RemoteOutDirURL","RemoteInDirURL","RemoteObjectSubFolder","RemoteStatusSubFolder","RemoteScheFlagFolder","SchFlagRemote","OtherNodesNames","LastFileNamesGet"},
        {"RemoteHost","RemotePort","RemoteUser","RemotePassword","RemotePathDelim","FTPMode","FTPConnMode"},
        {"transferPeriodeMinutes","timeOutRemoteReady"}
    };
    
    public static final String PATH_DELIM = System.getProperty("file.separator");
    
    public int threadSleepScheduler=4000; // raster check periode for transfer, in milliseconds
    public int threadSleepSerializer=1500;
    public int threadSleepDeserializer=1500;
    public int threadSleepStatusInProcessor=1500;
    public static boolean running=false;
    
    public String LocalHostNameFile ="";
    public String LocalOutDirURL="";
    public String LocalInDirURL="";
    public String LocalScheFlagFolder = "";
    
    public String LocalObjectSubFolder="" ;
    public String LocalStatusSubFolder="";
    
    public String SchFlagLocal  = "";
    public String SchFlagRemote = "";
    
    public String RemoteHostNameFile ="";
    public String RemoteHost ="";
    public int RemotePort =21;
    public String RemoteUser ="";
    public String RemotePassword ="";
    public String RemoteOutDirURL="";
    public String RemoteInDirURL="";
    public String RemoteObjectSubFolder="";
    public String RemoteStatusSubFolder="";
    public String RemoteScheFlagFolder = "";
    public String RemotePathDelim="/";
    
    public String FTPMode      = ObjSynchFTPAPI.FTP_MODE_BINARY;//args[5];
    public String FTPConnMode  = ObjSynchFTPAPI.FTP_CONN_MODE_PASIV;//args[6];
    
    public int transferPeriodeMinutes=10; // in minutes
    public int timeOutRemoteReady=2; // in minutes
    private long lastDoTransfer = System.currentTimeMillis();
    
    private ObjSynchSerializer serializer = null;
    private ObjSynchDeserializer deserializer = null;
    //private ObjSynchStatusInPrc statusInPrc = null;
    private ObjSynchFTPAPI ftpAPI = null;
    
    private int prevStatus=SchedulerFlag.STATE_IDLE;
    private Vector otherNodesNames;
    private Vector lastFileNamesGet;
    private String localNodeName;
    
    /** Creates new ObjSynchDeserializer     
     */

    private static ObjSynchNode singleInstant= null;

    private ObjSynchNode() {
        System.out.println("[Node]  >>> Constructor : Object Synch. Scheduler will run Node");
        LocalHostNameFile ="node";
        RemoteHostNameFile ="datapool";
    }

    public static ObjSynchNode getInstant(){
        if(singleInstant==null){
          singleInstant= new ObjSynchNode();
        }

        return singleInstant;
    }
    
    /**
     * create child thread and init ftpAPI
     **/
    public void initScheduler(){
        try {
            System.out.println("[Node]  Init Object Synch. Scheduler - starting child threads ");
            // replace  character '/' for path delimination to current system PATH_DELIM
            char chPathDel= PATH_DELIM.charAt(0);
            if(this.LocalOutDirURL!=null)
                this.LocalOutDirURL=this.LocalOutDirURL.replace('/',chPathDel);
            System.out.println("[Node]  LocalOutDirURL = "+LocalOutDirURL);
            
            if(this.LocalInDirURL!=null)
                this.LocalInDirURL=this.LocalInDirURL.replace('/',chPathDel);
            System.out.println("[Node]  LocalInDirURL = "+LocalInDirURL);
            
            if(this.LocalScheFlagFolder!=null)
                this.LocalScheFlagFolder=this.LocalScheFlagFolder.replace('/',chPathDel);
            System.out.println("[Node]  LocalScheFlagFolder = "+LocalScheFlagFolder);
            
            if(this.LocalStatusSubFolder!=null)
                this.LocalStatusSubFolder=this.LocalStatusSubFolder.replace('/',chPathDel);
            System.out.println("[Node]  LocalStatusSubFolder = "+LocalStatusSubFolder);
            
            if(this.LocalObjectSubFolder!=null)
                this.LocalObjectSubFolder=this.LocalObjectSubFolder.replace('/',chPathDel);
            System.out.println("[Node]  LocalObjectSubFolder = "+LocalObjectSubFolder);
            System.out.println("[Node]  LocalHostNameFile = "+ LocalHostNameFile);
            
            System.out.println("[Node]  Serializer");
            serializer = new ObjSynchSerializer(this);            
            serializer.THREAD_SLEEP= threadSleepSerializer;
            System.out.println("[Node]  threadSleepSerializer : " + threadSleepSerializer);
            serializer.running=true;
            Thread threadSerializer = new Thread(serializer);
            threadSerializer.setDaemon(true);
            threadSerializer.start();
            
            deserializer = new ObjSynchDeserializer(this);
            System.out.println("[Node]  Deserializer");
            deserializer.objSynch = this;
            deserializer.running=true;
            deserializer.THREAD_SLEEP = threadSleepDeserializer;
            Thread threadDeserializer = new Thread(deserializer);
            threadDeserializer.setDaemon(true);
            threadDeserializer.start();
            /*
            statusInPrc = new ObjSynchStatusInPrc();
            System.out.println("[Node]  StatusInPrc");
            statusInPrc.hostName  = this.LocalHostNameFile;
            statusInPrc.outDirURL = this.LocalOutDirURL;
            statusInPrc.inDirURL  = this.LocalInDirURL;
            statusInPrc.running=true;
            statusInPrc.THREAD_SLEEP = threadSleepStatusInProcessor;
            Thread threadStatusPrc = new Thread(statusInPrc);
            threadStatusPrc.setDaemon(true);
            threadStatusPrc.start();
            */
            
            System.out.println("[Node]  Child threads lauched ");
            
            System.out.println("[Node]  >>> Init Object Synch. Scheduler as Node ===>>> Init FTP");
            
            ftpAPI = new ObjSynchFTPAPI(this);
            /*
            System.out.println("[Node]  Test FTP connection");
            ftpAPI.connectFTP();
            ftpAPI.ftp.quit();
            System.out.println("[Node]  End of Test. FTP connection closed");
            */
       /* } catch (RemoteException ex) {
            ex.printStackTrace();
        } catch (MalformedURLException ex) {
            ex.printStackTrace();*/
        } catch (Exception exc) {
            exc.printStackTrace();
        }
    }
    
    public boolean timeToTransfer(){
        long curr= System.currentTimeMillis();
        long chk = lastDoTransfer + (long)this.transferPeriodeMinutes * 60 * 1000 ;
        
        if( ( (chk<=curr) && this.AutoRunning) || (CurrentlyRunningManually && !this.AutoRunning)){ // ||( (curr>chk) && (chk>(curr-this.threadSleepScheduler)) )){
            lastDoTransfer = curr;
            return true;
        }
        else return false;
    }
    
    
    public void run() {
        String title = "" ;
        title = "[Node]  >>> Object Synch. Scheduler running as NODE <<<"
        + "\n       periode = "+transferPeriodeMinutes+" minutes";
        System.out.println(title);
        
        while(running){
            try{
               if(threadSleepScheduler<1000)
                               threadSleepScheduler = 1000;

                Thread.sleep(threadSleepScheduler);
                
                if(timeToTransfer()){
                    System.out.println("\n[Scheduler] >>>   TIME FOR TRANSFERING <<<");
                    System.out.println("[Node] \t- pause all child threads & request remote to pause childthreads ");
                    
                    serializer.doProcess = false;
                    deserializer.doProcess = false;
                   // statusInPrc.doProcess = false;
                    Thread.sleep(threadSleepScheduler*4); // sleep awhile for giving child thread finished
                    System.out.println("[Node] Open ftp");
                    
                    if(ftpAPI.testConnectFTP()){                        
                        System.out.println("[Node] putAllObject");
                        ftpAPI.putAllObject(true);

                        System.out.println("[Node] getAllObject");
                        ftpAPI.getAllObject(false, true);
                                                
                    }else{
                        System.out.println("[Data Pool] is NOT ready for transferring object files => pending to next schedule");
                        System.out.println("- PLEASE CHECK IF CONNECTION TO THE INTERNET IS OK - ");                        
                    }
                    // resume child threads
                    serializer.doProcess    = true;
                    deserializer.doProcess  = true;
                    //statusInPrc.doProcess   = true;
                    lastDoTransfer = System.currentTimeMillis();
                                        
                    CurrentlyRunningManually = false;
                    System.out.println("[Node]  >>> END OF TRANSFER PROCESS <<<");
                    //
                }
                
                
            } catch(Exception e){
                System.out.println("[Node]  Exception in Object Synch. Scheduler "+e);
                System.out.println("[Node]  - resume all child threads ");
                serializer.doProcess = true;
                deserializer.doProcess = true;
                //statusInPrc.doProcess = true;
                CurrentlyRunningManually = false;
                lastDoTransfer = System.currentTimeMillis();
            } finally{
            }
            
            
        }
        try{
            System.out.println("[Node]  STOP serializer");
            if(serializer != null)
                serializer.running = false;
            System.out.println("[Node]  STOP deserializer");
            if(deserializer != null)
                deserializer.running = false;
            System.out.println("[Node]  STOP statusInPrc");
           // if(statusInPrc != null)
           //     statusInPrc.running = false;
            
            System.out.println("[Node]  Close FTP");
            if(ftpAPI != null)
                ftpAPI.ftp.quit();
        }catch (Exception exc){
        }
        
        System.out.println("[Node]  >>> Object Synch. Scheduler STOPPED <<<");
    }
    
    public void runMasterManually() {
        
        String title = "" ;
            title = "[Node]  >>> Object Synch. Scheduler runs Node <<<"
            + "\n       periode = "+transferPeriodeMinutes+" minutes";
        
        System.out.println(title);
                
        if(running && (!this.AutoRunning)){
            CurrentlyRunningManually = true;
        }
    }
    
    public static void main(String[] argv){
        ObjSynchNode node = new ObjSynchNode(); // default =msster
        int i=200;
        System.out.println(" max long /2 = " + Long.MAX_VALUE/2);
        do{
            System.out.println("[Node]  ObjSynchNode");
            System.out.println(" Menu ");
            System.out.println(" 0. END");
            System.out.println(" 1. start");
            System.out.println(" 2. stop");
            System.out.println(" 3. run manually");
            System.out.print("Select :");
            try{
                i= System.in.read();
                System.out.println(" i = " +i);
                switch (i){
                    case 48:
                        node.running=false;
                        i=0;
                        break;
                    case 49:
                        node.running=false;
                        Hashtable htbl = DSJ_SvcParam.getParams(SVC_NAME);
                        DSJ_ObjSynch.setObjSynchNode(node, htbl);
                        node.initScheduler();
                        node.running=true;

                        Thread thr = new Thread(node);
                        thr.setDaemon(false);
                        thr.start();
                        break;
                    case 50:
                        node.running=false;
                        break;
                    case 51:
                        node.CurrentlyRunningManually=true;
                        break;
                   default :;
                }
            }
            catch(Exception ex){
                System.out.println(ex.toString());
            }
        } while ((i!=48));
        
        
        /*
        if((argv.length==0) || ("MASTER".equalsIgnoreCase(argv[0]))){
                obj.runAsMaster = true; // master will drive the remote object synch via flag per FTP
                obj.LocalHostNameFile ="backoff";
                obj.LocalOutDirURL="D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\objsysnch\\outsync";
                obj.LocalInDirURL="D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\objsysnch\\insync";
                obj.LocalScheFlagFolder = "D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\objsysnch\\schflag";
         
                obj.LocalObjectSubFolder=ObjSynchInfo.TARGET_OBJECT_SUB_FOLDER ;
                obj.LocalStatusSubFolder=ObjSynchInfo.TARGET_STATUS_SUB_FOLDER ;
         
                obj.SchFlagLocal  = ObjSynchInfo.TARGET_SCHFLAG_BOFF;
                obj.SchFlagRemote = ObjSynchInfo.TARGET_SCHFLAG_ONLINE;
         
                obj.RemoteHostNameFile ="online";
                obj.RemoteHost ="192.168.0.2";
                obj.RemotePort =21;
                obj.RemoteUser ="administrator";
                obj.RemotePassword ="ikktnmjm";
                obj.RemoteOutDirURL="/ahotela/outsync";
                obj.RemoteInDirURL="/ahotela/insync";
                obj.RemoteObjectSubFolder=ObjSynchInfo.TARGET_OBJECT_SUB_FOLDER ;
                obj.RemoteStatusSubFolder=ObjSynchInfo.TARGET_STATUS_SUB_FOLDER ;
                obj.RemoteScheFlagFolder = "/ahotela/schflag";
                obj.RemotePathDelim="/";
         
                obj.FTPMode      = ObjSynchFTPAPI.FTP_MODE_BINARY;//args[5];
                obj.FTPConnMode  = ObjSynchFTPAPI.FTP_CONN_MODE_PASIV;//args[6];
         
                obj.transferPeriodeMinutes=5; // in minutes
                obj.timeOutRemoteReady=1; // in minutes
        }else{
                obj.runAsMaster = false;
                obj.LocalHostNameFile ="online";
                obj.LocalOutDirURL="D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\testobjsysnch\\outsync";
                obj.LocalInDirURL="D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\testobjsysnch\\insync";
                obj.LocalScheFlagFolder = "D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\testobjsysnch\\schflag";
         
                obj.LocalObjectSubFolder=ObjSynchInfo.TARGET_OBJECT_SUB_FOLDER ;
                obj.LocalStatusSubFolder=ObjSynchInfo.TARGET_STATUS_SUB_FOLDER ;
         
                obj.SchFlagLocal  = ObjSynchInfo.TARGET_SCHFLAG_ONLINE;
                obj.SchFlagRemote = ObjSynchInfo.TARGET_SCHFLAG_BOFF;
         
                obj.RemoteHostNameFile ="backoff";
        }
        obj.initScheduler();
        obj.run();
         */
    }
    
    public Vector getOtherNodesNames(){ return otherNodesNames; }
    
    public void setOtherNodesNames(Vector otherNodesNames){ this.otherNodesNames = otherNodesNames; }
    
    public void setOtherNodesNames(String otherNodesNamesStr){
        if (otherNodesNamesStr==null){
            this.otherNodesNames = new Vector();
            return;
        }

        Vector otherNodesNames = new Vector();
        // parse string to vector with separator character ";"
        StringTokenizer st = new StringTokenizer(otherNodesNamesStr,";");
        int iTemp=0; 
        while (st.hasMoreTokens()) {
            String strTemp1 = st.nextToken();
            otherNodesNames.add(strTemp1);
            iTemp++;
        }
        
        this.otherNodesNames = otherNodesNames;
    }

    public String getOtherNodeName(int nodeIdx){
        Vector  nds = this.getOtherNodesNames();
        if((nds!=null) && (nds.size()>0) && (0<=nodeIdx) && (nodeIdx<nds.size())) {
            return (String) nds.get(nodeIdx);                
        }
        return null;
    }
    
    
    
    public Vector getLastFileNamesGet(){ return lastFileNamesGet; }

    public String getLastFileNamesGetStr(int nodeIdx){ 
        String str="";
        if( lastFileNamesGet!=null){
            for(int idx=0;idx<lastFileNamesGet.size();idx++){
                if(idx==nodeIdx)
                     return (String) lastFileNamesGet.get(idx);
            }
        }
        return str;
    }        

    public String getLastFileNamesGetStr(){ 
        String str="";
        if( lastFileNamesGet!=null){
            for(int idx=0;idx<lastFileNamesGet.size();idx++){
                if(idx==0)
                    str=(String) lastFileNamesGet.get(idx);
                else
                    str = str +";"+(String) lastFileNamesGet.get(idx);
            }
        }
        return str;
    }        

    
    public void setLastFileNamesGet(Vector lastFileNamesGet){ this.lastFileNamesGet = lastFileNamesGet; }
    
    public void setLastFileNamesGet(String lastFileNamesGetStr){
        Vector lastFileNamesGet = new Vector();
        // parse string to vector with separator character ";"
        StringTokenizer st = new StringTokenizer(lastFileNamesGetStr,";");
        int iTemp=0;
        while (st.hasMoreTokens()) {
            String strTemp1 = st.nextToken();
            lastFileNamesGet.add(strTemp1);
            iTemp++;
        }
        
        this.lastFileNamesGet = lastFileNamesGet;
    }
    
    public String getLocalNodeName(){ return localNodeName; }
    
    public void setLocalNodeName(String localNodeName){ this.localNodeName = localNodeName; }

    public boolean ftpConnectOk(){
        try{
            long start= System.currentTimeMillis();
            ObjSynchFTPAPI testFtpAPI = new ObjSynchFTPAPI(this);
            System.out.println("[Node]  Test FTP connection");
            testFtpAPI.connectFTP();
            testFtpAPI.ftp.dir(RemoteInDirURL);
            testFtpAPI.ftp.quit();
            long end = System.currentTimeMillis();

            if((end-start) < (timeOutRemoteReady * 60 * 1000)){
                System.out.println("FTP OK :) > end-start = "+( end-start) + " < TimeOut = "+(timeOutRemoteReady * 60 * 1000));
                return true;
            }
            else{
                System.out.println("FTP NOT OK  :( > end-start = "+( end-start) + "> TimeOut = "+(timeOutRemoteReady * 60 * 1000));                
                return false;
            }
        } catch(Exception exc){
            return false;
        }
    }
}
