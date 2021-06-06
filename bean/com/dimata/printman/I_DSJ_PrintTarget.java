/*
 * I_DSJ_PrintTarget.java
 *
 * Created on July 18, 2003, 11:07 AM
 * by I Ketut Kartika T.
 * copyright : PT. Dimata Sora Jayate
 */

package com.dimata.printman;

import java.rmi.*;
import java.util.*;

/** Remote interface.
 *
 * @author ktanjana
 * @version 1.0
 */
public interface I_DSJ_PrintTarget extends java.rmi.Remote {
    /** Hello method usually returns "Hello".
     */
    public String hello() throws java.rmi.RemoteException;
    
    public int printObj(DSJ_PrintObj ObjPrint) throws java.rmi.RemoteException;
    
    public void stopPrintSvc() throws java.rmi.RemoteException;
    
    public Vector getLisfOfPrinter() throws java.rmi.RemoteException;

    public Vector reloadLisfOfPrinter() throws java.rmi.RemoteException;
        
    public Vector getStatusOfPrinter() throws java.rmi.RemoteException;
    
    public int pausePrint(PrnConfig prn) throws java.rmi.RemoteException;
    
    public int resumePrint(PrnConfig prn) throws java.rmi.RemoteException;
    
    public int cancelPrint(PrnConfig printer) throws java.rmi.RemoteException;
    
}
