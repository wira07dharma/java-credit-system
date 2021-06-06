/*
 * ObjSynchSender.java
 *
 * Created on December 19, 2001, 2:40 PM
 */

package com.dimata.services.objsynchxnodes;
import java.security.*;
import java.util.*;
import com.dimata.qdep.entity.*;
import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.net.MalformedURLException;
import com.dimata.instant.util.*;
import java.io.*;

import com.dimata.qdep.entity.*;
import com.dimata.services.objsynchxnodes.SignedEntity;
/**
 *
 * @author  ktanjana
 * @version 0.1
 * Serialize SignedEntity object into defined target folder
 */
public class ObjSynchSerializer extends Object implements Runnable, Serializable {
    public static int THREAD_SLEEP=1500;
    public static final String PATH_DELIM = System.getProperty("file.separator");
    
    public boolean running=true;
    public boolean doProcess = true;

    public ObjSynchNode objSynch = null; 

    
    public ObjSynchSerializer(ObjSynchNode objSynch){
        this.objSynch=objSynch;
        updateSignature();
    }


    private KeyPairGenerator kgen;
    private Signature sig;
    private PublicKey pub;
    private PrivateKey priv; 
    
    public void updateSignature()
    {
       try{ 
            kgen = KeyPairGenerator.getInstance("DSA");
            kgen.initialize(512);
            KeyPair kpair = kgen.generateKeyPair();

            sig = Signature.getInstance("SHA/DSA");
            pub = kpair.getPublic();
            priv = kpair.getPrivate();
            sig.initSign(priv);
       }catch (Exception e){
           e.printStackTrace();
       }
        
    }
    
    public  void doGetUpdatedObject(){
        Vector vct = DSJ_ObjSynch.getNextObjToSynch();
        if (vct ==null)
            return;
        
        Entity gen = (Entity) vct.get(0);
        int cmd = ((Integer)vct.get(1)).intValue();
        
        SignedEntity signGen = new SignedEntity();
        signGen.setCommand(cmd);
        byte[] data = {'1','A','$','T','8','s','@','F'};
        signGen.setData(data);
        signGen.setEntity(gen);
        signGen.setStatus(SignedEntity.STATUS_NEW_OUT_BOX);
        signGen.setSeqIndex(((Long)vct.get(2)).longValue());
        
        System.out.println("[Serializer] gen = " + gen);        
        System.out.println("[Serializer] gen.getOID() : " + gen.getOID());
        System.out.println("[Serializer] gen. ClassName() : " + gen.getClass().getName());
        
        Vector targetNodes = (Vector) vct.get(3);
        
        serializeObj(signGen, targetNodes);
    }
       
    public int serializeObj( SignedEntity signGen, Vector targetNodes){
        if( (signGen==null))// || (targetNodes==null))
           return DSJ_ClassMsg.ERR_IN_PARAM_LACK; 
        
       if(targetNodes==null){
            targetNodes = (Vector) this.objSynch.getOtherNodesNames().clone();
            System.out.println("Target Nodes = Null => ALL NODES");
       }
        
        try{
            String fileName = this.objSynch.TARGET_FILENAME_PREF_OBJECT + this.objSynch.getLocalNodeName() + 
                                DSJ_ObjSynch.createStringLong000(signGen.getSeqIndex());            
            
            String fileURL  = this.objSynch.LocalOutDirURL+ PATH_DELIM + this.objSynch.getLocalNodeName() 
                + PATH_DELIM + this.objSynch.LocalObjectSubFolder +  PATH_DELIM + fileName;
                  
                                
            byte data[] = signGen.getData(); 
            if(sig==null)
                updateSignature();
            if(sig==null){
                System.out.println("[Serializer] updateSignature() - failed");
                return DSJ_ClassMsg.ERR_PROCESS_FAIL;
            }
            //signGen.getEntity().setModifiedProperties(true); // ensure that the object will be processed in the persistent class
            sig.update(data);
            signGen.setData(data);
            signGen.setSign(sig.sign());
            signGen.setPubKey(pub);           

            System.out.println("[Serializer] serialize to = " + fileURL );
            
            int serRslt = DSJ_ObjSynch.serializeObj(signGen, fileURL);
            if(DSJ_ClassMsg.OK==serRslt){
                // save one byte size file
                Vector oNd = this.objSynch.getOtherNodesNames();
                if(oNd!=null){
                    for(int idx=0; idx< oNd.size();idx++){
                        fileURL  = this.objSynch.LocalOutDirURL+ PATH_DELIM + this.objSynch.getLocalNodeName() 
                        + PATH_DELIM + this.objSynch.LocalStatusSubFolder +  PATH_DELIM + 
                         oNd.get(idx) + PATH_DELIM + fileName;

                        if(DSJ_ObjSynch.saveFileText("0", fileURL)!= DSJ_ClassMsg.OK){
                            System.out.println(" ERROR write file = "+ fileURL);
                        }
                    }
                }
                
            }            
            return serRslt;
        }catch (Exception exc){
            System.out.println("[Serializer] ERROR serialize "+ exc);            
            return DSJ_ClassMsg.ERR_PROCESS_FAIL;
        }
    }
        
    
    public void run() {
        System.out.println("[Serializer] >>> -THREAD- Serializer running. Scheduler " );
        
        while(running){
            try{
                if(THREAD_SLEEP<1000)
                               THREAD_SLEEP = 1000;
                Thread.sleep(THREAD_SLEEP);
                if(doProcess){
                    System.out.println("[Serializer] >> CHECK ");
                    doGetUpdatedObject();
                }
            } catch(Exception e){
                //System.out.println("[Serializer] Interrupted "+e);
            }
        }
        System.out.println("[Serializer] Serializer STOP");
    }
  
    /*
    public static void main(String[] argv){         
        ObjSynchSerializer obj = 
            new ObjSynchSerializer();
        obj.hostName  = "backoff";
        obj.outDirURL = "D:\\forte4j\\user\\ktanjana\\ahotela\\WEB-INF\\objsysnch\\outsync";
        obj.run();
    }
     */
}
