/*
 * ObjSynchDeserializer.java
 *
 * Created on December 23, 2001, 10:27 AM
 * Deseriealize object file into database
 */

package com.dimata.services.objsynchxnodes;
import com.dimata.*;
import com.dimata.util.*;
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

//import com.dimata.mlm.entity.member.*;
import com.dimata.services.db.*;
import com.dimata.services.objsynchxnodes.SignedEntity;
/**
 *
 * @author  ktanjana
 * @version
 */
public class ObjSynchDeserializer implements Runnable, Serializable {
    public static int THREAD_SLEEP=1500;
    public static final String PATH_DELIM = System.getProperty("file.separator");
    
    public boolean running=true;
    public boolean doProcess = true;
    public ObjSynchNode objSynch = null;
    
    //private Vector fileObjIn = new Vector(1,1); // contains vector of file names inside IN folder
    
    /**
     * Vector of vectors contain file names inside IN folder of each node
     */
    private Vector nodeFileObjIn = new Vector();
    
    private Vector getNodeFileObjIn(int nodeIdx){
        if(nodeFileObjIn!=null){
            return (Vector) nodeFileObjIn.get(nodeIdx);
        }else {
            return null;
        }
    }
    
    //private int currentObjIn = -1;
    private Vector currentObjInNode = new Vector();
    private int getcurrentObjInNode(int nodeIdx){
        return ((Integer)currentObjInNode.get(nodeIdx)).intValue();
    }
    
    private void setcurrentObjInNode(int nodeIdx, int val){        
        currentObjInNode.set(nodeIdx, new Integer(val));
    }
    
    /** Creates new ObjSynchDeserializer */
    public ObjSynchDeserializer(ObjSynchNode objSynch ){
        this.objSynch= objSynch;
        Vector  nds = this.objSynch.getOtherNodesNames();
        if((nds!=null) & (nds.size()>0)) {
            for(int i=0; i< nds.size(); i++){
                String ndName = (String) nds.get(i);
                if(ndName!=null){
                    nodeFileObjIn.add(new Vector(1,1));
                    currentObjInNode.add(new Integer(-1));
                }
            }            
        }
        
    }
    
    public int doOutSynchResult(int nodeIdx, SignedEntity signGen, String objFileName){
        try{
            System.out.println("[Deserializer] doOutSynchResult : oid = " + signGen.getEntity().getOID()+
            " | seqIdx = " + signGen.getSeqIndex());
            
            String fileURL = this.objSynch.LocalInDirURL + PATH_DELIM + 
                             this.objSynch.getOtherNodeName(nodeIdx) + PATH_DELIM + 
                             this.objSynch.LocalStatusSubFolder+  PATH_DELIM +
                             this.objSynch.TARGET_FILENAME_PREF_STATUS + 
                             this.objSynch.getOtherNodeName(nodeIdx) +
                             this.objSynch.getOtherNodeName(nodeIdx) + signGen.getSeqIndex();
            
            Entity gen = signGen.getEntity();
            SynchStatus st = new SynchStatus();
            st.objectID = gen.getOID();
            st.className = gen.getPstClassName();//gen.getClass().getName();
            st.status = signGen.getStatus();
            st.seqIndex = signGen.getSeqIndex();
            
            return DSJ_ObjSynch.serializeObj(st, fileURL);
        } catch (Exception exc){
            exc.printStackTrace();
            return DSJ_ClassMsg.ERR_PROCESS_FAIL;
        }
    }
    
    
    
    public synchronized void  synchronizeObj(int nodeIdx, SignedEntity obj, String objFileURL){
        Entity gen =obj.getEntity();
        long originalOID = gen.getOID();
        String tableName = "";
        String[] fieldOIDName;
        Entity  tmpGen = null;
        String clsName ="";
        
        int idx = objFileURL.lastIndexOf(PATH_DELIM);
        String fileName = objFileURL.substring(idx+1);
        
        
        System.out.print("\n========> [Deserializer] ");
        System.out.println(" gen.getOID() = " + originalOID);
        
        try{
            I_PersintentExc i_pstExc = (I_PersintentExc) Class.forName(gen.getPstClassName()).newInstance();
            I_PersistentExcSynch i_pstExcSynch = (I_PersistentExcSynch) Class.forName(gen.getPstClassName()).newInstance();
            System.out.println("[Deserializer] Class   : " + Class.forName(gen.getPstClassName()).newInstance().getClass().getName());
            System.out.println("[Deserializer] Command : " + obj.getCommand());
            
            long oid = 0;
            switch (obj.getCommand()){
                case Command.DELETE:
                    try{
                    oid = i_pstExc.deleteExc(gen);
                    System.out.println("[Deserializer] watch this...\n Command.DELETE oid = " + oid);
                    if(oid != 0){
                        System.out.println("[Deserializer] Command.DELETE obj.setStatus(SignedEntity.STATUS_UPDATE_OK)");
                        obj.setStatus(SignedEntity.STATUS_UPDATE_OK);
                        doOutSynchResult(nodeIdx, obj, fileName);
                    } else {
                        obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL);
                        System.out.println("[Deserializer] Command.DELETE obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL)");
                        doOutSynchResult(nodeIdx, obj, fileName);
                        System.out.println("[Deserializer] >>> Command.DELETE FAILED synchronizeObj - oid = "+ oid);
                    }
                    }catch (Exception exc){
                        System.out.println("[Deserializer] >>> Command.DELETE FAILED  EXP : "+ exc);
                    }
                    deleteFileObj(objFileURL);
                    break;
                    
                case Command.UPDATE:
                    //check the object exist
                    clsName = gen.getClass().getName();
                    System.out.println(" >>>>>>>>>  ENTITY CLASS : "+ clsName);
                    tmpGen = (Entity) Class.forName(clsName).newInstance();
                    tmpGen.setOID(gen.getOID());
                    try{
                    oid = i_pstExc.fetchExc(tmpGen);
                    } catch (Exception exc){
                      oid=0;
                    }
                    if(oid==0){
                     // not found in DB then INSERT
                      System.out.println("[Deserializer] watch this...\n Command.UPDATE => BUT NOT FOUND TRY TO ADD oid = " + oid);
                      oid = i_pstExcSynch.insertExcSynch(gen);

                      if(oid != 0){
                          System.out.println("[Deserializer] STATUS_UPDATE_OK )");
                          obj.setStatus(SignedEntity.STATUS_UPDATE_OK);
                          doOutSynchResult(nodeIdx, obj, fileName);
                      } else {
                          System.out.println("[Deserializer] STATUS_UPDATE_FAIL)");
                          obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL);
                          doOutSynchResult(nodeIdx, obj, fileName);
                      }
                    } else {
                      // found in DB then UPDATE
                      oid = i_pstExc.updateExc(gen);
                      System.out.println("[Deserializer] watch this...\n Command.UPDATE oid = " + oid);
                      if(oid != 0){
                          System.out.println("[Deserializer] Command.UPDATE obj.setStatus(SignedEntity.STATUS_UPDATE_OK)");
                          obj.setStatus(SignedEntity.STATUS_UPDATE_OK);
                          doOutSynchResult(nodeIdx, obj, fileName);
                      } else {
                          System.out.println("[Deserializer] Command.UPDATE obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL)");
                          obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL);
                          doOutSynchResult(nodeIdx, obj, fileName);
                          System.out.println("[Deserializer] >>> Command.UPDATE FAILED synchronizeObj - oid = "+ oid);
                      }
                    }
                    deleteFileObj(objFileURL);
                    break;
                    
                case Command.ADD:
                    //oid = i_pstExc.insertExc(gen);
                    //oid = i_pstExc.updateSynchOID(oid, originalOID);
                    clsName = gen.getClass().getName();
                    System.out.println(" >>>>>>>>>  ENTITY CLASS : "+ clsName);
                    tmpGen = (Entity) Class.forName(clsName).newInstance();
                    tmpGen.setOID(gen.getOID());
                    // check is exists :
                    try{
                    oid = i_pstExc.fetchExc(tmpGen);
                    } catch (Exception exc){
                      //System.out.println(" >>>>>>>>>  FETCH : "+ clsName+ " EXC"+ exc);  
                      oid=0;
                    }
                    if(oid==0){
                        // not found in DB then INSERT
                        oid = i_pstExcSynch.insertExcSynch(gen);
                        
                        System.out.println("[Deserializer] watch this...\n Command.ADD oid = " + oid);
                        if(oid != 0){
                            System.out.println("[Deserializer] Command.ADD obj.setStatus(SignedEntity.STATUS_UPDATE_OK)");
                            obj.setStatus(SignedEntity.STATUS_UPDATE_OK);
                            doOutSynchResult(nodeIdx, obj, fileName);
                        } else {
                            System.out.println("[Deserializer] Command.ADD obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL)");
                            obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL);
                            doOutSynchResult(nodeIdx, obj, fileName);
                            System.out.println("[Deserializer] >>> Command.ADD FAILED synchronizeObj - oid = "+ oid);
                        }
                    } else {
                      // found in DB then UPDATE
                      oid = i_pstExc.updateExc(gen);
                      System.out.println("[Deserializer] watch this...\n Command.ADD ==> BUT UPDATE oid = " + oid);
                      if(oid != 0){
                          System.out.println("[Deserializer] Command.UPDATE obj.setStatus(SignedEntity.STATUS_UPDATE_OK)");
                          obj.setStatus(SignedEntity.STATUS_UPDATE_OK);
                          doOutSynchResult(nodeIdx, obj, fileName);
                      } else {
                          System.out.println("[Deserializer] Command.UPDATE obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL)");
                          obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL);
                          doOutSynchResult(nodeIdx, obj, fileName);
                          System.out.println("[Deserializer] >>> Command.UPDATE FAILED synchronizeObj - oid = "+ oid);
                      }
                    }
                    Thread.sleep(500);
                    deleteFileObj(objFileURL);
                    break;
            }
        }
        catch (Exception exc){
            System.out.println("[Deserializer] EXCEPTION in synchronizeObj : "+exc);
            obj.setStatus(SignedEntity.STATUS_UPDATE_FAIL);
            doOutSynchResult(nodeIdx, obj, fileName);
            //deleteFileObj(objFileURL);
        }
    }
    
    private int deleteFileObj(String fileURL){
        try{
            java.io.File file = new java.io.File(fileURL);
            if (file.delete()) {
                System.out.println("[Deserializer] deleteFileObj -> OK");
                return DSJ_ClassMsg.OK;
            }
            else {
                System.out.println("[Deserializer] deleteFileObj -> ERR_PROCESS_FAIL");
                return DSJ_ClassMsg.ERR_PROCESS_FAIL;
            }
        }
        catch (Exception exc) {
            System.out.println("[Deserializer] deleteFileObj -> EXCEPTION - ERR_PROCESS_FAIL");
            return DSJ_ClassMsg.ERR_PROCESS_FAIL;
        }
    }
    
    /**
     * return vector of :  (0) fileURL of synch object (1) the object
     */
    public Vector getObjectInFolder(int nodeIdx){
        Vector ins = new Vector();
        Vector fileObjIn = getNodeFileObjIn(nodeIdx);
        int currentObjIn = getcurrentObjInNode(nodeIdx);
        
        if( (fileObjIn==null) || (fileObjIn.size()==0) || ( (currentObjIn+1) > (fileObjIn.size()-1)) ) {
            refreshVectorObjIn(nodeIdx);
            currentObjIn = getcurrentObjInNode(nodeIdx);
        }
        
        if(fileObjIn.size()>0){
            this.setcurrentObjInNode(nodeIdx, ++currentObjIn);
            java.io.File file = (java.io.File) fileObjIn.get(currentObjIn);
            SignedEntity obj = deserializeObj(file);
            ins.add(file.getAbsolutePath());
            System.out.println("[Deserializer] getObjectInFolder = "+file.getAbsolutePath());
            ins.add(obj);
        }
        else {
            ins.add("");
            ins.add(null);
        }
        return ins;
    }
    
    private SignedEntity deserializeObj(File file){
        FileInputStream fileIn = null;
        try{
            /*
            //fileIn = new FileInputStream("C:/Temp/obj_online0000000000000000000000001");
            fileIn = new FileInputStream("C:/Temp/obj_backoff0000000000000000000000001");
             
            System.out.println("[Deserializer] fileIn = " + fileIn);
             
            ObjectInputStream objIn = new ObjectInputStream(fileIn);
            System.out.println("[Deserializer] objIn = " + objIn);
             
            //System.out.println("[Deserializer] objIn.readObject() = start");
            //objIn.readObject();
            //System.out.println("[Deserializer] objIn.readObject() = end");
             
            SignedEntity signObj = (SignedEntity) objIn.readObject();
            System.out.println("[Deserializer] signObj = " + signObj);
            return signObj;
             */
            
            fileIn = new FileInputStream(file.getAbsolutePath());
            System.out.println("[Deserializer] fileIn = " + fileIn);
            
            ObjectInputStream objIn = new ObjectInputStream(fileIn);
            System.out.println("[Deserializer] objIn = " + objIn);
            
            SignedEntity signObj = (SignedEntity) objIn.readObject();
            System.out.println("[Deserializer] signObj = " + signObj);
            return signObj;
        }
        catch(Exception exc){
            System.out.println("[Deserializer] EXCEPTION in deserializeObj - " + exc.toString());
            return null;
        }
        finally{
            if (fileIn!=null){
                try{
                    System.out.println("[Deserializer] close file : " + file.getAbsolutePath());
                    fileIn.close();
                } catch(Exception exc){
                }
            }
        }
    }
    
    private void refreshVectorObjIn(int nodeIdx){
        try{
            String dirURL  = this.objSynch.LocalInDirURL + PATH_DELIM + this.objSynch.getOtherNodeName(nodeIdx)
                             + PATH_DELIM +  this.objSynch.LocalObjectSubFolder;
            
            java.io.File fl = new java.io.File(dirURL); // set in directory
            
            DSJ_FilenameFilter ff = new DSJ_FilenameFilter();
            ff.setFileNameStart("");
            
            java.io.File[] fileslist = fl.listFiles(ff);
            
            if(fileslist != null) {
                Vector fileObjIn = getNodeFileObjIn(nodeIdx);

                if (fileObjIn== null)
                    fileObjIn = new Vector(1,1);
                fileObjIn.removeAllElements();
                this.setcurrentObjInNode(nodeIdx, -1);
                
                if(fileslist.length>0)
                    System.out.println("[Deserializer] refreshVectorObjIn , node "+ objSynch.getOtherNodeName(nodeIdx));
                
                for(int i = 0; i < fileslist.length; i++) {
                    java.io.File f = fileslist[i];
                    fileObjIn.add(f);
                }
            }
        } catch(Exception exc){
            System.out.println("[Deserializer] EXCEPTION in refreshVectorObjIn : "+exc);
        }
    }
    
    
    public void run() {
        SignedEntity obj = null;
        String objURL="";
        System.out.println("[Deserializer] >>> -THREAD- Deserializer running");
        while(running){
            try{
               if(THREAD_SLEEP<300)
                               THREAD_SLEEP = 300;
                Thread.sleep(THREAD_SLEEP);
                if(doProcess){
                    Vector  nds = this.objSynch.getOtherNodesNames();
                    if((nds!=null) &&(nds.size()>0)) {
                        for(int i=0; i< nds.size(); i++){
                            String ndName = (String) nds.get(i);
                            if(ndName!=null){
                                Vector objIn = getObjectInFolder(i);
                                if( (objIn!=null)  && (objIn.size()==2)  && (objIn.get(1)!=null))  {
                                    objURL = (String) objIn.get(0);
                                    obj =(SignedEntity)objIn.get(1);
                                    if(obj!=null){
                                        synchronizeObj(i, obj, objURL);
                                    }
                                }
                                
                                
                            }
                        }
                        
                    }
                    
                }
            } catch(Exception e){
                System.out.println("[Deserializer] EXCEPTION in Deserializer "+e);
            }
        }
        System.out.println("[Deserializer] Deserializer STOP");
    }
    
    
    public static void main(String[] argv){
/*        
        ObjSynchDeserializer obj = new ObjSynchDeserializer();
        obj.hostName  = "backoff";
        //obj.hostName  = "online";
        //obj.outDirURL = "D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\objsysnch\\outsync";
        //obj.inDirURL  = "D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\objsysnch\\insync";
        obj.outDirURL = "C:\\Apache\\tomcat321\\webapps\\mlm\\synch\\objsynch\\outsync";
        obj.inDirURL  = "C:\\Apache\\tomcat321\\webapps\\mlm\\synch\\objsynch\\insync";
        obj.run();
 **/
    }
    
}
