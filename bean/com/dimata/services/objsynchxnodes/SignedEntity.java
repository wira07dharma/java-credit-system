/*
 * SignedEntity.java
 *
 * Created on December 17, 2001, 4:32 PM
 */

package com.dimata.services.objsynchxnodes;
import java.io.*;
import java.security.*;
import java.rmi.*;
import java.rmi.server.*;
import com.dimata.qdep.entity.*;

/**
 *
 * @author  ktanjana
 * @version 0.1
 * represent the object will be transfered for data synchronization 
 * An object of this class will encapsulate a Entity object with additional attribute and 
 * data like.
 */
public class SignedEntity extends Object implements Serializable {
    public   static final int STATUS_NEW_OUT_BOX=1;    
    public   static final int STATUS_SENT_WAIT_FOR_CFRM=2;    
    public   static final int STATUS_SENT_CFRM_OK =3;
    public   static final int STATUS_SENT_CFRM_FAIL =4;
    //
    public   static final int STATUS_NEW_IN_BOX = 11;
    public   static final int STATUS_UPDATE_WAIT_FOR_RSLT = 12;
    public   static final int STATUS_UPDATE_OK = 13;
    public   static final int STATUS_UPDATE_OK_REPLIED = 14; // confirmation already sent to the sender
    public   static final int STATUS_UPDATE_FAIL = 15;
    public   static final int STATUS_UPDATE_FAIL_REPLIED = 16; // confirmation already sent to the sender
    
    private  byte[] data;
    private  Entity entity;
    private  byte[] sign;
    private  PublicKey pubKey;
    private  int status;
    private  int command;
    private  long seqIndex=-1;
    
    /** Creates new SignedEntity */
    public SignedEntity()  {
        
    }
    
    public SignedEntity(byte[] data, Entity gen, byte[] sign, PublicKey pubKey){
        this.data = data;
        this.entity=gen;
        this.sign =sign;
        this.pubKey = pubKey;
    }
    
    public SignedEntity(byte[] data, long seqIndex, Entity gen, byte[] sign, PublicKey pubKey){
        this.data = data;
        this.entity=gen;
        this.sign =sign;
        this.pubKey = pubKey;
        this.seqIndex=seqIndex;
    }
    
    public long getSeqIndex(){
        return  this.seqIndex;
    }
    
    public void setSeqIndex(long seqIndex){
        this.seqIndex=seqIndex;
    }
    
    public Entity getEntity(){
        return this.entity;
    }
    
    public void setEntity(Entity gen){
        this.entity=gen;
    }
    
    public byte[] getData(){
        return data;
    }
    
    public void setData(byte[] data){
        this.data = data;
    }
    
    public byte[] getSign(){
        return sign;
    }
    
    public void setSign(byte[] sign){
        this.sign = sign;
    }
    
    public PublicKey getPubKey(){
        return pubKey;
    }
    
    public void setPubKey(PublicKey pubKey){
        this.pubKey = pubKey;
    }    
    
    public int getStatus(){
        return status;
    }
    
    public void setStatus(int status){
        this.status = status;
    }    
    
    public int getCommand(){
        return command;
    }
    
    public void setCommand(int command){
        this.command = command;
    }    
}
