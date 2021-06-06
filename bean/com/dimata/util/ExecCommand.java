/*
 * ExecCommand.java
 *
 * Created on October 8, 2004, 4:15 PM
 */

package com.dimata.util;

// import core java package
import java.util.*;
import java.io.*;

class StreamGobbler extends Thread
{
    InputStream is;
    String type;
    
    StreamGobbler(InputStream is, String type)
    {
        this.is = is;
        this.type = type;
    }
    
    public void run()
    {
        try
        {
            InputStreamReader isr = new InputStreamReader(is);
            BufferedReader br = new BufferedReader(isr);
            String line=null;
            while ( (line = br.readLine()) != null)
            {
                System.out.println(type + ">" + line);    
            }
        } 
        catch (IOException ioe)
        {
            ioe.printStackTrace();  
        }
    }
}



/**
 *
 * @author  gedhy
 */
public class ExecCommand  
{

    String strMsg = "";
    String  pathFile = "";
    public void setPathFile(String pathFile){
        this.pathFile = pathFile;
    }

    public String getPathFile(){
        return this.pathFile;
    }

    public String getMsg(){
        return strMsg;
    }
    
    /**
     * @param stCommand
     * @return
     */    
    public int runCommmand(String stCommand)
    {
        int result = 0;
        
        if (stCommand.length() < 1)
        {
            System.out.println("--- Command script cannot NULL ---");
            System.exit(1);
            return 1;
        }
        
        try
        {
            String cmd = stCommand;
            Runtime rt = Runtime.getRuntime();
            Process proc = rt.exec(cmd);
            
            // any error message?
            StreamGobbler errorGobbler = new StreamGobbler(proc.getErrorStream(), "ERR");            
            
            // any output?
            StreamGobbler outputGobbler = new StreamGobbler(proc.getInputStream(), "OUT");                
            
            // kick them off
            errorGobbler.start();
            outputGobbler.start();
                                    
            // any error???
            int exitVal = proc.waitFor();
//            System.out.println("ExitValue: " + exitVal);
            
            result = exitVal;
        } 
        catch (Throwable t)
        {
            t.printStackTrace();
        }        
        
        return result;
    }
    
    
    /**
     * @param args
     */    
    public static void main(String args[])
    {
        String stCommand = "net send gadnyana test dari java ...";
        ExecCommand execCommand = new ExecCommand();
        int result = execCommand.runCommmand(stCommand);
        if(result == 0)
        {            
            System.out.println("--- Execute command succesfully ---");
        }
        else
        {
            System.out.println("--- Execute command failed ---");
        }  
    }
    
}
