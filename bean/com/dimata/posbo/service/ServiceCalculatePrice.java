/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.service;

/**
 *
 * @author gndiw
 */
public class ServiceCalculatePrice {
    private static ServiceCalculatePrice man = null;
    //public static boolean running = false;
    private static AutomaticCalculatePrice assistant =null;
    /**
     * @return the txtProcessList
     */
    public static AutomaticCalculatePrice getAssistant(){
        if(assistant !=null){
            return assistant;
        }
        else{
            return assistant = new AutomaticCalculatePrice();
        }
        
    }

    public static ServiceCalculatePrice getInstance(boolean withAssistant) {
        if (man == null) {
            man = new ServiceCalculatePrice();            
            if(withAssistant){
                assistant = new AutomaticCalculatePrice();
                assistant.setRunning(false);                
            } else{
                assistant=null;    
            }
        }
        return man;
    }

    

    
    public void startService() {
       //  public void startTransfer(long oidDepartement, String employeeName,java.util.Date fromDate,java.util.Date toDate ,long oidSection) {
        if(assistant!=null){
            assistant.setRunning(true);
            Runnable task = (Runnable) assistant;                                      
            Thread worker = new Thread(task);
            worker.setDaemon(false);
            worker.start();                        
        }else {
            assistant= new AutomaticCalculatePrice();
            assistant.setRunning(true);
            Runnable task = (Runnable) assistant;                                      
            Thread worker = new Thread(task);
            worker.setDaemon(false);
            worker.start();                        
    }
       
        //running = true;
    }
    
    public void stopService() 
    {
        //setRunning(false);
        if(assistant!=null){
            assistant.setRunning(false);
           
        }
        System.out.println(".................... ServiceDPStock stoped ....................");       
    }
    
    public boolean isRunningAssistant() {
        if (assistant!=null) {                    
           return  assistant.isRunning(); 
            
        }
        else{
             return false;
        }
       
       
    }
     public boolean getStatus() {
          if (assistant!=null) {                    
           return  assistant.isRunning(); 
            
        }
        else{
             return false;
        }
       
    }
}
