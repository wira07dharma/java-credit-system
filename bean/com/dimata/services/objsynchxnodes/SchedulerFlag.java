/*
 * SchedulerFlag.java
 *
 * Created on January 24, 2002, 5:39 PM
 * scheduler flag for communication backoffice and online system
 * existing on online system but use/check  by both systems 
 */

package com.dimata.services.objsynchxnodes;
import java.io.*;
/**
 *
 * @author  ktanjana
 * @version 
 */
public class SchedulerFlag extends Object implements Serializable {
    public static final int STATE_IDLE=0;
    public static final int STATE_SYNCHRONIZE_OBJECT=1;
    public static final int STATE_TRANSFER_FILE=2;
    
    public int state = 0;
    
    /** Creates new SchedulerFlag */
    public SchedulerFlag() {
        this.state  = STATE_IDLE;
    }
    
    public SchedulerFlag(int state) {
        this.state = state;
    }
    
    public static int serialize(String pathFileName, SchedulerFlag obj){
        return DSJ_ObjSynch.serializeObj(obj, pathFileName);
    }

    public static SchedulerFlag deserialize(String pathFileName){
        try{
            java.io.File file = new java.io.File(pathFileName);
            if(!file.exists()){
                SchedulerFlag sf = new SchedulerFlag(SchedulerFlag.STATE_IDLE);            
                return sf;                
            }
            FileInputStream fileIn = new FileInputStream(pathFileName);
            ObjectInputStream objIn = new ObjectInputStream(fileIn );
            SchedulerFlag obj = (SchedulerFlag) objIn.readObject();
            return obj;        
        } catch(Exception exc){
            //System.out.println(" Excpt. in deserialize  SchedulerFlag - " + pathFileName);
            SchedulerFlag sf = new SchedulerFlag(SchedulerFlag.STATE_IDLE);
            return sf;
        }
    }   

    public static SchedulerFlag deserialize(String pathFileName, boolean delete){
        try{
            java.io.File file = new java.io.File(pathFileName);
            if(!file.exists()){
                SchedulerFlag sf = new SchedulerFlag(SchedulerFlag.STATE_IDLE);            
                return sf;                
            }
            
            FileInputStream fileIn = new FileInputStream(pathFileName);
            ObjectInputStream objIn = new ObjectInputStream(fileIn );
            SchedulerFlag obj = (SchedulerFlag) objIn.readObject();
            try{
                if(obj!=null){
                    file.delete();
                }
            }catch(Exception exc){
            }
            return obj;        
        } catch(Exception exc){
            //System.out.println(" Excpt. in deserialize  SchedulerFlag - " + pathFileName);
            SchedulerFlag sf = new SchedulerFlag(SchedulerFlag.STATE_IDLE);            
            return sf;
        }
    }   
    
    public static int checkStatusFlag(String pathFileName){
        SchedulerFlag obj = deserialize(pathFileName);
        if(obj==null)
             return STATE_IDLE;
        return obj.state;
    }
    
}
