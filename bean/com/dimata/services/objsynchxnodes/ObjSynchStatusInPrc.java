/*
 * ObjSynchDeserializer.java
 *
 * Created on December 23, 2001, 10:27 AM
 * Deserealize and Process object status reply from outside world
 */

package com.dimata.services.objsynchxnodes;
import com.dimata.*;
import com.dimata.instant.general.*;
import com.dimata.qdep.entity.*;
import java.util.*;
import com.dimata.instant.util.*;
import java.security.*;
import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.net.MalformedURLException;
import java.io.*;
import com.dimata.services.objsynchxnodes.SynchStatus;

/**
 *
 * @author  ktanjana
 * @version
 */
public class ObjSynchStatusInPrc implements Runnable, Serializable {
    public static int THREAD_SLEEP=1500;
    public static final String PATH_DELIM = System.getProperty("file.separator");
    
    public boolean running=true;
    public boolean doProcess = true;
    
    public String outDirURL="";
    public String objectSubFolder="";
    public String TARGET_FILENAME_PREF_OBJECT="";
    public String TARGET_FILENAME_PREF_STATUS="";
    
    public String inDirURL="";
    public String statusSubFolder="";
    public String hostName =""; // set has to be set to help separation of host
    
    private Vector fileObjIn = new Vector(1,1);
    private int currentObjIn = -1;
    
    /** Creates new ObjSynchDeserializer */
    public ObjSynchStatusInPrc() {
    }
    
    public void ObjSynchStatusInPrc(String inDirURL){
       this.inDirURL = inDirURL;
    }

    public void ObjSynchStatusInPrc(String hostName, String inDirURL){
       this.hostName = hostName;
       this.inDirURL = inDirURL;
    }
           
    public void synchronizeStatus(SynchStatus obj , String objFileURL){
        try{
            System.out.println("[StatusInPrc] synchronizeStatus with oid = " + obj.objectID+ " idx ="+obj.seqIndex);
            int iErrCode = -1;
            switch(obj.status){
                case SignedEntity.STATUS_UPDATE_OK :
                    deleteOutObjFile(obj.seqIndex);
                    iErrCode=DSJ_ObjSynch.delete(obj.seqIndex);                    
                    break;
                    
                case SignedEntity.STATUS_UPDATE_FAIL :
                    iErrCode=DSJ_ObjSynch.updateStatus(obj.seqIndex, DSJ_ObjSynch.OBJ_STATUS_FAILED);                    
                    break;
            }   
            
            if(iErrCode == DSJ_ClassMsg.OK)                
                deleteFileStatus(objFileURL);
            
        }catch (Exception exc){
            System.out.println("[StatusInPrc] EXCEPTION in synchronizeStatus with oid = " + obj.objectID+ " | idx = "+obj.seqIndex);
        }
    }
    
    private int deleteFileStatus(String fileURL){
        try{
            System.out.println("[StatusInPrc] deleteFileStatus - file = " + fileURL);
            java.io.File file = new java.io.File(fileURL);
            if (file.delete())
                    return DSJ_ClassMsg.OK;
               else  
                    return  DSJ_ClassMsg.ERR_PROCESS_FAIL;                   
        } catch (Exception exc){
            return  DSJ_ClassMsg.ERR_PROCESS_FAIL;
        }
    }
    
    private int deleteOutObjFile(long index){
        try{
            String fileURL  = this.outDirURL + PATH_DELIM + this.objectSubFolder + 
                PATH_DELIM + TARGET_FILENAME_PREF_OBJECT +
                                this.hostName + DSJ_ObjSynch.createStringLong000(index);

            System.out.println("[StatusInPrc] deleteOutObjFile - file = " + fileURL);
            java.io.File file = new java.io.File(fileURL);
            if (file.delete())
                    return DSJ_ClassMsg.OK;
               else  
                    return  DSJ_ClassMsg.ERR_PROCESS_FAIL;                   
        } catch (Exception exc){
            return  DSJ_ClassMsg.ERR_PROCESS_FAIL;
        }
    }
    
    /**
     * return vector of :  (0) fileURL of synch object (1) the object
     */
    public Vector getObjectInFolder(){
      Vector ins = new Vector();
      
      if( (this.fileObjIn==null) || (this.fileObjIn.size()==0) || ( (this.currentObjIn+1) > (this.fileObjIn.size()-1)) )
          refreshVectorObjIn();
      
      if(this.fileObjIn.size()>0){
        this.currentObjIn++;
        java.io.File file = (java.io.File) this.fileObjIn.get( this.currentObjIn);
        SynchStatus obj = (SynchStatus)deserializeObjStatus(file); 
        ins.add(file.getAbsolutePath());
        ins.add(obj);        
      }
      else{
          ins.add("");
          ins.add(null);
      }      
      return ins;
    }
    
    private SynchStatus deserializeObjStatus(File file){
        try{
            FileInputStream fileIn = new FileInputStream(file.getAbsolutePath());
            ObjectInputStream objIn = new ObjectInputStream(fileIn );
            SynchStatus objSt = (SynchStatus) objIn.readObject();
            return objSt;        
        } catch(Exception exc){
            System.out.println("[StatusInPrc] EXCEPTION in deserializeObj - " + exc.toString());
            return null;
        }
    }
    
    private void refreshVectorObjIn(){
        try{
            String dirURL  = this.inDirURL + PATH_DELIM + this.statusSubFolder; 
            java.io.File fl = new java.io.File(dirURL); // set in directory

            DSJ_FilenameFilter ff = new DSJ_FilenameFilter();
            ff.setFileNameStart(TARGET_FILENAME_PREF_STATUS);

            java.io.File[] fileslist = fl.listFiles(ff);

            if(fileslist != null) {
                if (this.fileObjIn== null)
                     this.fileObjIn = new Vector(1,1);
                this.fileObjIn.removeAllElements();
                this.currentObjIn =-1;
                if(fileslist.length>0)
                    System.out.println("[StatusInPrc] >>> refreshVectorObjIn ");

                for(int i = 0; i < fileslist.length; i++) {
                    java.io.File f = fileslist[i];
                    this.fileObjIn.add(f);
                }        
            }
        } catch(Exception exc){
            System.out.println("[StatusInPrc] EXCEPTION in refreshVectorObjIn "+exc);
        }
    }

    public void run() {
        SynchStatus obj = null;
        String objURL="";
        System.out.println("[StatusInPrc] -THREAD- Status Incoming Processor running");
        while(running){
            try{                
                Thread.sleep(THREAD_SLEEP);
                if(doProcess){                
                    Vector objIn = getObjectInFolder();
                    if( (objIn!=null)  && (objIn.size()==2)  && (objIn.get(1)!=null))  {
                        objURL = (String) objIn.get(0); 
                        obj =(SynchStatus)objIn.get(1);
                        if(obj!=null){
                            synchronizeStatus(obj, objURL);
                        }                          
                    }
                }
            } catch(Exception e){
                System.out.println("[StatusInPrc] EXCEPTION in Deserializer : "+e);
            }
        }
        System.out.println("[StatusInPrc] Status Incoming Processor STOP");
    }
    
    /*
    public static void main(String[] argv){         
        ObjSynchStatusInPrc obj = 
            new ObjSynchStatusInPrc();
        obj.hostName  = "backoff";
        obj.inDirURL  = "D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\objsysnch\\insync";
        obj.outDirURL = "D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\objsysnch\\outsync";        
        obj.run();
    }
     */
}
