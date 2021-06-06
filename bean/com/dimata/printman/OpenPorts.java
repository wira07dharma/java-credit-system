
package com.dimata.printman;
/* 
 * @author gadnyana
 * @version 1.0
 * Copyright : PT. Dimata Sora Jayate , 2003
 */

import java.io.*;
import java.util.*;
import javax.comm.*;

public class OpenPorts {
    static Enumeration portList;
    static CommPortIdentifier portId;
    static OutputStream outputStream;
    
    static ParallelPort parallelPort;
    static SerialPort serialPort;
    static Vector vector = new Vector(1,1);
    
    public OpenPorts(){
        
    }
    
    public Vector getPort(){
        return vector;
    }
    
    public static void setDefaultPort(String strPort){
        portList = CommPortIdentifier.getPortIdentifiers();
        
        while (portList.hasMoreElements()) {
            portId = (CommPortIdentifier) portList.nextElement();
            if (portId.isCurrentlyOwned()) {
                System.out.println("port : " + portId.getName() + " in use by " + portId.getCurrentOwner());
            }else{
                if(portId.getName().equals(strPort)){
                    if (portId.getPortType() == CommPortIdentifier.PORT_PARALLEL) {
                        try {
                            parallelPort = (ParallelPort)portId.open("PARALEL", 2000);
                        } catch (PortInUseException e) {}
                    }else if(portId.getPortType() == CommPortIdentifier.PORT_SERIAL){
                        try {
                            serialPort = (SerialPort)portId.open("SERIAL", 2000);
                        } catch (PortInUseException e) {}
                    }
                }
            }
            vector.add(portId.getName());
        }
    }
    
    synchronized  public void endPrint(){
        try {
            if(parallelPort!=null){
                parallelPort.close();
            }
            if(serialPort!=null){
                serialPort.close();
            }
        } catch (Exception e) {
            System.out.println("-------- : "+e.toString());
        }
    }
    
}
