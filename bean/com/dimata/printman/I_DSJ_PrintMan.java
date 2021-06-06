/*
 * I_DSJ_PrintMan.java
 *
 * Created on July 23, 2003, 1:36 PM
 */

package com.dimata.printman;

import java.rmi.*;
import java.util.*;

/** Remote interface.
 *
 * @author ktanjana
 * @version 1.0
 */
public interface I_DSJ_PrintMan extends java.rmi.Remote {
    public Vector getHostList() throws java.rmi.RemoteException;    
    public Vector getHostList(boolean reload) throws java.rmi.RemoteException;
    public Vector getPrinterList(PrinterHost rmtPrnHost) throws java.rmi.RemoteException;
    public Vector reloadPrinterList(PrinterHost rmtPrnHost)throws java.rmi.RemoteException;
    public Vector getPrinterListWithStatus(PrinterHost rmtPrnHost) throws java.rmi.RemoteException;
    public void stopPrinterService(PrinterHost rmtPrnHost) throws java.rmi.RemoteException;
    public PrinterHost getPrinterHost(String hostIpIdx, String separ) throws java.rmi.RemoteException;
    public PrnConfig getPrinterConfig(String hostIpIdx, String separ) throws java.rmi.RemoteException;
    public int printObj(PrinterHost rmtPrnHost, DSJ_PrintObj obj) throws java.rmi.RemoteException;
    public int pausePrinter(PrinterHost rmtPrnHost, PrnConfig prn) throws java.rmi.RemoteException;
    public int resumePrinter(PrinterHost rmtPrnHost, PrnConfig prn) throws java.rmi.RemoteException;
    public int cancelPrinter(PrinterHost rmtPrnHost, PrnConfig prn) throws java.rmi.RemoteException;
    public int setPrinterStatus(PrinterHost rmtPrnHost, PrnConfig prn, int cmd) throws java.rmi.RemoteException;
    public void loadPrintersOnAllHost() throws java.rmi.RemoteException;
    public void reloadPrintersOnAllHost() throws java.rmi.RemoteException;
    
    public void setPrinterHost(PrinterHost rmtPrnHost)throws java.rmi.RemoteException;
    public PrinterHost getPrinterHostByIP(String ip) throws java.rmi.RemoteException;
    public Vector getPrinterHostExceptIP(String ip) throws java.rmi.RemoteException;
    

}
